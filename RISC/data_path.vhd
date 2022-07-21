library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components_init.all;

entity data_path is
  port (

  	--Instruction Register signals
  	ir_enable : in std_logic;

  	-- PC in
  	pc_select : in std_logic_vector(1 downto 0);

  	-- ALU Operation signals
  	alu_op : in std_logic_vector(1 downto 0); --rename alu
  	-- ALU - a
  	alu_a_select : in std_logic_vector(1 downto 0);
  	-- ALU - b
  	alu_b_select : in std_logic_vector(2 downto 0);

  	--Memory address select signals
  	mem_add_select : in std_logic_vector(1 downto 0);
	
	mem_data_select : in std_logic;
	--Memory read and write signals
	mem_write : in std_logic;
	mem_read : in std_logic;

	--Register File read and write control signals 
	rf_write : in std_logic;
	rf_read : in std_logic;
	-- Register file - A1
	rf_a1_select : in std_logic;
	-- Register file - A2
	rf_a2_select : in std_logic;
	-- Register file - A3	
	rf_a3_select : in std_logic_vector(1 downto 0);
	-- Register file - D3
	rf_d3_select : in std_logic_vector(2 downto 0); -- 2 down to 0

	--Temporary Registers control signals 
	--T1
	t1_c : in std_logic_vector(1 downto 0); -- change no of bits
	--T2
	t2_c : in std_logic_vector(2 downto 0); -- change no of bits

	--Carry and Zero flags enable signals
	carry_en : in std_logic;
	zero_en : in std_logic;

	--Continue signal (For instructions like ADC, ADZ etc)
	continue_state : out std_logic; 

	--Loop out signal
	loop_out : out std_logic;

	--Zero flag value out 
	zero_out : out std_logic;

	--Carry flag value out
	carry_out : out std_logic;

	--Clock signal in 
	clk : in std_logic;

	--Reset pin 
	rst : in std_logic;

	--Instruction type -----------------------------------------//check
	inst_type: out std_logic_vector(3 downto 0)

--	--Data coming into datapath (for testbench only, no other purpose)
--	ext_address : std_logic_vector(15 downto 0);
--	ext_data: in std_logic_vector(15 downto 0);
--    ext_memorywrite_enable: in std_logic;
--    ext_pc: out std_logic_vector(15 downto 0);
--    ext_ir: out std_logic_vector(15 downto 0);
--    ext_r0: out std_logic_vector(15 downto 0);
--    ext_r1: out std_logic_vector(15 downto 0);
--    ext_r2: out std_logic_vector(15 downto 0);
--    ext_r3: out std_logic_vector(15 downto 0);
--    ext_r4: out std_logic_vector(15 downto 0);
--    ext_r5: out std_logic_vector(15 downto 0);
--    ext_r6: out std_logic_vector(15 downto 0)
	
  ) ;
end entity ; 

architecture compute of data_path is
	
	-- The signals defined here are the data values moving in the wires inside the datapath

	-- ALU signals 
	signal alu_operation : std_logic_vector(1 downto 0); 
	signal alu_in_a : std_logic_vector(15 downto 0);
	signal alu_in_b : std_logic_vector(15 downto 0);
	signal alu_out : std_logic_vector(15 downto 0);
	signal alu_carryflag : std_logic;
	signal alu_zeroflag : std_logic;

	--Carry and zero registers 
	signal carry_reg : std_logic;
	signal zero_reg : std_logic;

	--Signals for temporary registers 
	--T1
	signal T1_data_in : std_logic_vector(15 downto 0);
	signal T1_data_out : std_logic_vector(15 downto 0);
	--T2
	signal T2_data_in : std_logic_vector(15 downto 0);
	signal T2_data_out : std_logic_vector(15 downto 0);
	--T3
	signal T3_data_in : std_logic_vector(15 downto 0);
	signal T3_data_out : std_logic_vector(15 downto 0);

	--Register file signal/wire values
	signal adr1_read : std_logic_vector(2 downto 0);
	signal adr2_read : std_logic_vector(2 downto 0);
	signal data1_read : std_logic_vector(15 downto 0);
	signal data2_read : std_logic_vector(15 downto 0);
	signal adr3_write : std_logic_vector(2 downto 0);
	signal data3_write : std_logic_vector(15 downto 0);

	--PC in and out signal values 
	signal PC_in : std_logic_vector(15 downto 0);
	signal PC_out : std_logic_vector(15 downto 0);

	--Memory signal values 
	signal mem_addr_in : std_logic_vector(15 downto 0);
	signal mem_data_in : std_logic_vector(15 downto 0);
	signal mem_data_out : std_logic_vector(15 downto 0);

	--Sign extender output values 
	signal SE6_out : std_logic_vector(15 downto 0);
	signal SE9_out : std_logic_vector(15 downto 0);
	signal data_extender9_out : std_logic_vector(15 downto 0);
	signal sl1_out : std_logic_vector(15 downto 0);

	--Constant for ALU (for PC + 1)
	signal const_1 : std_logic_vector(15 downto 0) := (0=>'1',others => '0');--?
	signal const_minus_1 : std_logic_vector(15 downto 0) := (others => '1');--?
	
	--Instruction based signals --?
	signal instruction : std_logic_vector(15 downto 0);
	signal instruction_operation : std_logic_vector(1 downto 0);
	signal instruction_carry : std_logic;
	signal instruction_zero : std_logic;
-- PE_out_signals
   signal peout_sig :  std_logic_vector(2 downto 0);
	signal PE0_sig : STD_LOGIC;
-- Shifter signal
signal ls1_out : std_logic_vector(15 downto 0);
	
	begin
	
	--Assigning values to the signals based on the input control signals given as port-in

	--ALU inputs - a and b (ADD ALU OPERATION)
	alu_in_a <= PC_out when alu_a_select = "00" else --00
		T1_data_out when alu_a_select = "01" else --01
		data1_read when alu_a_select = "10" else
		const_1; -- default 

	alu_in_b <= const_1 when alu_b_select = "000" else --000
		T2_data_out when alu_b_select = "001" else --001
		SE6_out when alu_b_select = "011" else --011
		const_minus_1 when alu_b_select = "010" else --010 
		SE9_out when alu_b_select = "100" else --100
		const_1; -- default --111
		
	alu_operation <= instruction_operation when alu_op = "10" else --?
		alu_op;

	carry_reg <= alu_carryflag when carry_en = '1';

	zero_reg <= alu_zeroflag when zero_en = '1';

	--Temporary registers values based on the input control signals 
	--T1
	T1_data_in <= data1_read when t1_c = "00" else
		data2_read when t1_c = "01" else
		alu_out when t1_c ="10";
	--T2
	--need to do this
	T2_data_in <= ls1_out when t2_c = "000" else
		data2_read when t2_c = "001" else
		data1_read when t2_c = "010" else
		mem_data_out when t2_c="011" else		
		SE6_out when t2_c = "100";
	--T3
	T3_data_in <= alu_out;
		
	--Register file input values based on the control signals
	--A1
	adr1_read <= instruction(11 downto 9) when rf_a1_select = '0' else
		peout_sig when rf_a1_select = '1';
	--A2
	adr2_read <= instruction(8 downto 6);
	--A3
	adr3_write <= instruction(5 downto 3) when rf_a3_select = "00" else
		instruction(8 downto 6) when rf_a3_select = "01" else
		instruction(11 downto 9) when rf_a3_select = "10" else
		peout_sig when rf_a3_select = "11";
	--D3
	data3_write <= PC_out when rf_d3_select = "000" else
		mem_data_out when rf_d3_select = "001" else
		data_extender9_out when rf_d3_select = "010" else
		T3_data_out when rf_d3_select = "011" else
		T2_data_out when rf_d3_select = "100" ;

	--Memory signal values based on the control signals
	mem_data_in <= data1_read when mem_data_select = '0' else
		T2_data_out when mem_data_select='1';
		
	mem_addr_in <= PC_out when mem_add_select = "00" else
	T1_data_out when mem_add_select = "01" else
	T3_data_out when mem_add_select = "10" ;
	


	--PC in and out signal values 
	PC_in <= data2_read when pc_select = "01" else
		alu_out when pc_select = "10";

	--Port maps 
	--Port map for continue decoder, gives an out signal continue_state which is used in checking for zero or carry flags when needed
	CD : continue_decoder
		port map (
			cz_condition => instruction(1 downto 0),
			carry_flag => alu_carryflag,
			zero_flag => alu_zeroflag,
			continue => continue_state 
		);
	--Port map for data extension
	DE : data_extension
		port map (
			data_in => instruction(8 downto 0),
			data_out => data_extender9_out
		);
	--Port map for sign extender 9
	SE9 : sign_extender_9
		port map (
			data_in => instruction(8 downto 0),
			data_out => SE9_out
			);
	--Port map for sign extender 6
	SE6 : sign_extender_6
		port map (
			data_in => instruction(5 downto 0),
			data_out => SE6_out
			);
	--Port map for shifter 1
	S1: shifter_1
		port map (
			data_in => data2_read,
			data_out => ls1_out
			);

	--Instruction register and decoder 
	Inst_register : inst_register_data 
		port map(
			inst_in => mem_data_out,
			inst_out => instruction,
			inst_enable => ir_enable,
			clk => clk
			);
	ID : instruction_register
		port map(
			instruction => instruction,
			instruction_operation => instruction_operation,
			instruction_type => inst_type
			);

	PE : PriorityEncoder
		port map(
		PriorityEncoderReg =>instruction(7 downto 0),
      PE_out =>	peout_sig,	
		PE0 => PE0_sig);			
			
	--Register file port mapping 
	RF : reg_file 
		port map (
			clk => clk,
			reg_file_read => rf_read,
			reg_file_write => rf_write,
			PC_write_rf => pc_select,
			address_1 => adr1_read,
			address_2 => adr2_read,
			address_3 => adr3_write,
			data_in => data3_write,
			data_out_1 => data1_read,
			data_out_2 => data2_read
			);
			
			
	--ALU port mapping 
	ALU1 : ALU
		port map(
			alu_a => alu_in_a,
			alu_b => alu_in_b,
			alu_op => alu_operation,
			alu_out => alu_out,
			carry => alu_carryflag,
			zero => alu_zeroflag
			);

	T1 : register_data 
		port map (
			data_in => T1_data_in,
			data_out => T1_data_out,
			clk => clk
		);

	T2 : register_data 
		port map (
			data_in => T2_data_in,
			data_out => T2_data_out,
			clk => clk
		);

	T3 : register_data 
		port map (
			data_in => T3_data_in,
			data_out => T3_data_out,
			clk => clk
		);

end architecture ; -- compute
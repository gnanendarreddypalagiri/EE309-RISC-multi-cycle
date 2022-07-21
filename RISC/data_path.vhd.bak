library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components_init.all;

entity data_path is
  port (

  	--Instruction Register signals
  	ir_enable : in std_logic_1164;

  	-- PC in
  	pc_select : in std_logic_vector(1 downto 0);

  	-- ALU Operation signals
  	alu_op : in std_logic_vector(1 downto 0);
  	-- ALU - a
  	alu_a_select : in std_logic_vector(1 downto 0);
  	-- ALU - b
  	alu_b_select : in std_logic_vector(2 downto 0);

  	--Memory address select signals
  	mem_add_select : in std_logic_vector(1 downto 0);
	--Memory read and write signals
	mem_write : in std_logic_1164;
	mem_read : in std_logic_1164;

	--Register File read and write control signals 
	rf_write : in std_logic_1164;
	rf_read : in std_logic_1164;
	-- Register file - A1
	rf_a1_select : in std_logic_1164;
	-- Register file - A3
	rf_a3_select : in std_logic_vector(1 downto 0);
	-- Register file - D3
	rf_d3_select : in std_logic_vector(1 downto 0);

	--Temporary Registers control signals 
	--T1
	t1 : in std_logic_1164;
	--T2
	t2 : in std_logic_1164;
	--T4
	t4 : in std_logic_1164;
	--T5
	t5 : in std_logic_1164;

	--Carry and Zero flags enable signals
	carry_en : in std_logic_1164;
	zero_en : in std_logic_1164;

	--Continue signal (For instructions like ADC, ADZ etc)
	continue_state : out std_logic_1164;

	--Loop out signal
	loop_out : out std_logic_1164;

	--Zero flag value out 
	zero_out : out std_logic_1164;

	--Carry flag value out
	carry_out : out std_logic_1164;

	--Clock signal in 
	clk : in std_logic_1164;

	--Reset pin 
	rst : in std_logic_1164;

	--Instruction type -----------------------------------------//check
	inst_type: out std_logic_vector(3 downto 0);

	--Data coming into datapath (for testbench only, no other purpose as such)
	ext_address : std_logic_vector(15 downto 0);
	ext_data: in std_logic_vector(15 downto 0);
    ext_memorywrite_enable: in std_logic_1164;
    ext_pc: out std_logic_vector(15 downto 0);
    ext_ir: out std_logic_vector(15 downto 0);
    ext_r0: out std_logic_vector(15 downto 0);
    ext_r1: out std_logic_vector(15 downto 0);
    ext_r2: out std_logic_vector(15 downto 0);
    ext_r3: out std_logic_vector(15 downto 0);
    ext_r4: out std_logic_vector(15 downto 0);
    ext_r5: out std_logic_vector(15 downto 0);
    ext_r6: out std_logic_vector(15 downto 0)
	
  ) ;
end entity ; -- data_path

architecture compute of data_path is

	-- The signals defined here are the data values moving in the wires inside the datapath

	-- ALU signals 
	signal alu_operation : std_logic_vector(1 downto 0); 
	signal alu_in_a : std_logic_vector(15 downto 0);
	signal alu_in_b : std_logic_vector(15 downto 0);
	signal alu_out : std_logic_vector(15 downto 0);
	signal alu_carryflag : std_logic_1164;
	signal alu_zeroflag : std_logic_1164;

	--Carry and zero registers 
	signal carry_reg : std_logic_1164;
	signal zero_reg : std_logic_1164;

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
	--T4
	signal T4_data_in : std_logic_vector(15 downto 0);
	signal T4_data_out : std_logic_vector(15 downto 0);
	--T5 
	signal T5_data_in : std_logic_vector(15 downto 0);
	signal T5_data_out : std_logic_vector(15 downto 0);
	--T6 
	signal T6_data_in : std_logic_vector(15 downto 0);
	signal T6_data_out : std_logic_vector(15 downto 0);

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

	--LM, SM instruction loop signal values 
	signal PE_in : std_logic_vector(15 downto 0); --Not needed 
	signal PE_out : std_logic_vector(15 downto 0);
	--Inputs and outputs of AND gate present in the LM,SM circuit
	signal AND_a : std_logic_vector(15 downto 0);
	signal AND_b : std_logic_vector(15 downto 0);
	signal AND_out : std_logic_vector(15 downto 0);
	--Input and Output of the decoder which is going into the AND gate
	signal decoder_in : std_logic_vector(15 downto 0);
	signal decoder_out : std_logic_vector(15 downto 0);
	--Incrementer input and output 
	signal inc_in : std_logic_vector(15 downto 0);
	signal inc_out : std_logic_vector(15 downto 0);
	--Second zero flag 
	signal zero_2_in : std_logic_1164;
	signal zero_2_out : std_logic_1164;

	--Sign extender output values 
	signal SE6_out : std_logic_vector(15 downto 0);
	signal SE9_out : std_logic_vector(15 downto 0);
	signal data_extender9_out : std_logic_vector(15 downto 0);

	--Constant for ALU (for PC + 1)
	signal const_1 : std_logic_vector(15 downto 0) := (others => '0');
	signal const_minus_1 : std_logic_vector(15 downto 0) := (others => '1');

	--Instruction based signals 
	signal instruction : std_logic_vector(15 downto 0);
	signal instruction_operation : std_logic_vector(1 downto 0);
	signal instruction_carry : std_logic_1164;
	signal instruction_zero : std_logic_1164;

begin
	
	--Assigning values to the signals based on the input control signals given as port-in

	--ALU inputs - a and b (ADD ALU OPERATION)
	alu_in_a <= PC_out when alu_a_select = "01" else
		T1_data when alu_a_select = "10" else 
		const_1; -- default 

	alu_in_b <= T2_data when alu_b_select = "010" else
		const_1 when alu_b_select = "001" else
		SE6_out when alu_b_select = "011" else
		SE9_out when alu_b_select = "100" else
		const_minus_1 when alu_b_select = "101" else 
		const_1; -- default 

	alu_operation <= instruction_operation when alu_op = "10" else
		alu_op;

	carry_reg <= alu_carryflag when carry_en = '1';

	zero_reg <= alu_zeroflag when zero_en = '1';

	--Temporary registers values based on the input control signals 
	--T1
	T1_data_in <= data1_read when t1 = "0" else
		data2_read when t1 = "1";
	--T2
	T2_data_in <= data2_read when t2 = "0" else
		SE6_out when t2 = "1";
	--T3
	T3_data_in <= alu_out;
	--T4
	T4_data_in <= instruction(7 downto 0) when t4 = "0" else
		AND_out when t4 = "1";
	--T5
	T5_data_in <= instruction(11 downto 9) when t5 = "0" else
		inc_out when t5 = "1";
		
	--Register file input values based on the control signals
	--A1
	adr1_read <= T6_data when rf_a1_select = "0" else
		instruction(11 downto 9) when rf_a1_select = "1";
	--A2
	adr2_read <= instruction(8 downto 6);
	--A3
	adr3_write <= instruction(5 downto 3) when rf_a3_select = "00" else
		instruction(8 downto 6) when rf_a3_select = "01" else
		instruction(11 downto 9) when rf_a3_select = "10" else
		t6 when rf_a3_select = "11";
	--D3
	data3_write <= data_extender9_out when rf_d3_select = "00" else
		T3_data when rf_d3_select = "01" else
		alu_out when rf_d3_select = "10" else
		mem_data_out when rf_d3_select = "11";

	--Memory signal values based on the control signals
	mem_data_in <= data1_read;
	mem_addr_in <= PC_out when mem_add_select = "00" else
		T3_data when mem_add_select = "01" else
		T5_data when mem_add_select = "10";

	--Priority circuit values based on the control signals
	PE_in <= T4_data;
	T6_data <= PE_out;
	AND_a <= T4_data;
	AND_b <= decoder_out;
	decoder_in <= PE_out;
	zero_2_in <= AND_out;
	inc_in <= T5_data;
	loop_out <= zero_2_out;

	--PC in and out signal values 
	PC_in <= alu_out when pc_select = "01" else
		T2_data when pc_select = "10";

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
	--Priority encoder 
	PE : priority_encoder 
		port map (
			pe_in => PE_in,
			pe_out => PE_out
			);
	--decoder port mapping 
	Decoder_PM : decoder 
		port map (
			decoder_input => decoder_in,
			decoder_output => decoder_out
			);
	--AND gate for priority circuit 
	PE_AND : PE_and 
		port map (
			AND_input_1 => AND_a,
			AND_input_2 => AND_b,
			AND_output => AND_out
		);

	--PL_Zero 
	PL_zero : PL_loopout 
		port map (
			PL_loopout_in => AND_output,
			PL_loopout_out => zero_2_out
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
	ALUu : ALU
		port map(
			alu_a => alu_in_a,
			alu_b => alu_in_b,
			alu_op => alu_operation,
			alu_out => alu_out,
			carry => alu_carryflag,
			zero => alu_zeroflag
			);
	--Incrementer port mapping 
	INC : incrementer 
		port map (
			data_in => inc_in,
			data_out => inc_out
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

	T4 : register_data 
		port map (
			data_in => T4_data_in,
			data_out => T4_data_out,
			clk => clk
		);

	T5 : register_data 
		port map (
			data_in => T5_data_in,
			data_out => T5_data_out,
			clk => clk
		);

end architecture ; -- compute





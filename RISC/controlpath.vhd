library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.ProcessorComponents.all;
entity controlpath is 
	port (

	--Instruction Register signals
  	ir_enable : out std_logic_1164;

  	-- PC in
  	pc_select : out std_logic_vector(1 downto 0);

  	-- ALU Operation signals
  	alu_op : out std_logic_vector(1 downto 0);
  	-- ALU - a
  	alu_a_select : out std_logic_vector(1 downto 0);
  	-- ALU - b
  	alu_b_select : out std_logic_vector(2 downto 0);

  	--Memory address select signals
  	mem_add_select : out std_logic_vector(1 downto 0);
	--Memory read and write signals
	mem_write : out std_logic_1164;
	mem_read : out std_logic_1164;

	--Register File read and write control signals 
	rf_write : out std_logic_1164;
	rf_read : out std_logic_1164;
	-- Register file - A1
	rf_a1_select : out std_logic_1164;
	-- Register file - A3
	rf_a3_select : out std_logic_vector(1 downto 0);
	-- Register file - D3
	rf_d3_select : out std_logic_vector(1 downto 0);

	--Temporary Registers control signals 
	--T1
	t1 : out std_logic_1164;
	--T2
	t2 : out std_logic_1164;
	--T4
	t4 : out std_logic_1164;
	--T5
	t5 : out std_logic_1164;

	--Carry and Zero flags enable signals
	carry_en : out std_logic_1164;
	zero_en : out std_logic_1164;

	--Continue signal (For instructions like ADC, ADZ etc)
	continue_state : in std_logic_1164;

	--Loop out signal
	loop_out : in std_logic_1164;

	--Zero flag value out 
	zero_out : in std_logic_1164;

	--Carry flag value out
	carry_out : in std_logic_1164;

	--Clock signal in 
	clk : in std_logic_1164;

	--Reset pin 
	rst : in std_logic_1164;

	--Instruction type -----------------------------------------//check
	inst_type: in std_logic_vector(3 downto 0)
);
end entity;

architecture struct of controlpath is
	type FsmState is (S0_reset, S1_hkt, S2_bringregdata, S3_aluopcz, S4_writeback, S5_writebackrb, S6_bringimm, S7_storemem, S8_loadfrommem, S9_aluopz, S10_storepc, S11_decpc, S12_pcoff6, S13_pcoff9, S14_t2pc, S15_lmloadreg, S16_checkz2, S17_smstoremem, S18_pout, S19_dataext, S20_bringimm2, S21_alusubtract, S22_aluadd);
	signal state: FsmState;
begin
	--determining next state
	process(clk, rst, state, continue_state, loop_out, zero_out, carry_out, inst_type)
  		variable statenext: FsmState;
	begin
		statenext := S0_reset;
	case state is
		--PC points to this as soon as the microprocessor gets booted 
		when S0_reset =>  
			--First state of every instruction - Housekeeping task
        	statenext := S1_hkt;   
		when S1_hkt =>
			--For ADD instructions and NAND instructions and BEQ instruction
        	if inst_type = "0000" or inst_type = "1100" or inst_type = "0010" then
         		statenext := S2_bringregdata;
         	--For LM and SM instructions
       		elsif inst_type = "0111" or inst_type = "0110" then
          		statenext := S16_checkz2;
          	--SW instruction
        	elsif inst_type = "0101" then
         		statenext := S6_bringimm;
         	--JAL and JLR instruction
        	elsif inst_type = "1001" or inst_type = "1000" then
        		statenext := S10_storepc;
        	--LWI instruction
        	elsif inst_type = "0100" then 
		   		statenext := S20_bringimm2;
		   	--ADI instruction 
		   	elsif inst_type = "0001" then 
		   		statenext := S6_bringimm;
		   	--LHI instruction
		   	elsif inst_type = "0011" then
		   		statenext := S19_dataext;
		   	else
		   		statenext := S0_reset;
            end if;
		when S2_bringregdata =>  
			--For AND, ADC, ADZ instructions
		   	if inst_type = "0000" then 
				if continue = "1" then
		   			statenext := S3_aluopcz;
		   		else 
		   			statenext := S1_hkt;
		   		end if;
		   	end if;

		   	--For NDU, NDC, NDZ instruction
		   	if inst_type = "0010" then 
		   		if continue = "1" then 
		   			statenext := S9_aluopz;
		   		else 
		   			statenext := S1_hkt;
		   		end if;
		   	end if;

		   	--BEQ instruction
		   	if inst_type = "1100" then 
		   		statenext := S21_alusubtract;
		   	end if;

		   	--JLR instruction 
		   	if inst_type = "1001" then 
		   		statenext := S14_t2pc;
		   	end if;

	----------statenext := S9_aluopz
		when S3_aluopcz =>
			--For ADC, ADZ, ADD instruction 
			if inst_type = "0000" then 
				statenext := S4_writeback;
			end if;
			--ADI instruction 
			if inst_type = "0001" then 
				statenext := S5_writebackrb;
			end if;
				
	----------statenext := S5_writebackrb
		--Last states for instruction
		when S4_writeback => 
			statenext := S1_hkt;
		when S5_writebackrb => -- from ADI
			statenext := S1_hkt;

		when S6_bringimm => 
			--ADI instruction
			if inst_type = "0001" then 
				statenext := S3_aluopcz;
			end if; 

			--SW instruction 
			if inst_type = "0101" then 
				statenext := S22_aluadd;
			end if; 

	-----------statenext := S9_aluopz
		when s7_storemem =>
			statenext := S1_hkt; --from SW
		when S8_loadfrommem =>
			statenext := S1_hkt; --from Lw
		when S9_aluopz =>
			statenext := S4_writeback;
	-------------statenext := S8_loadfrommem
		when S10_storepc =>
			--JAL instruction 
			if inst_type = "1000" then 
				statenext := S13_pcoff9;
			end if;

			--JLR instruction 
			if inst_type = "1001" then 
				statenext := S2_bringregdata;
			end if;

		when S11_decpc =>
			statenext := S1_hkt;

		--BEQ instruction 
		when S12_pcoff6 =>
			statenext := S11_decpc;

		--JAL instruction 
		when S13_pcoff9 =>
			statenext := S1_hkt;

		--JLR instruction 
		when S14_t2pc =>
			statenext := S1_hkt;

		--LM instruction 
		when S15_lmloadreg =>
			if loop_out = "1" then 
				statenext := S1_hkt;
			else
				statenext := S18_pout;
			end if;
				
	---------------statenext := S16_lmloadreg
		when S16_checkz2 =>
			if loop_out = "1" then 
				statenext := S1_hkt;
			else 
				statenext := S18_pout;
			end if; 
	----------------statenext := S15_lmloadreg;
		when S17_smstoremem => 
			if loop_out = "1" then 
				statenext := S1_hkt;
			else 
				statenext := S18_pout;
			end if;

		when S18_pout =>
			if inst_type = "0110" then 
				statenext := S15_lmloadreg;
			else 
				statenext := S17_smstoremem;
			end if;

		--LHI instruction
		when S19_dataext =>
			statenext := S1_hkt;

		when S20_bringimm2 =>
			statenext := S22_aluadd;

		when S21_alusubtract =>
			if zero_out = "1" then 
				statenext := S12_pcoff6;
			else 
				statenext := S1_hkt;
			end if;

		when S22_aluadd => 
			--SW instruction and LW instructions respectively 
			if inst_type = "0101" then 
				statenext := S7_storemem;
			else 
				statenext := S8_loadfrommem; 
			end if;
	end case;

	if (clk'event and clk = "1") then
    	if (rst = "1") then
        	state <= S0_reset;
      	else
        	state <= nstate;
      	end if;
    end if;
  	end process;
		
------control signal assignments

process (state, zero_flag, zero_out, rst, loop_out)
--Instruction Register signals
  	variable nir_enable : std_logic_1164;
  	variable npc_select : std_logic_vector(1 downto 0);
  	variable nalu_op : std_logic_vector(1 downto 0);
  	variable nalu_a_select : std_logic_vector(1 downto 0);
  	variable nalu_b_select : std_logic_vector(2 downto 0);
  	variable nmem_add : std_logic_vector(1 downto 0);
	variable nmem_write : std_logic_1164;
	variable nmem_read : std_logic_1164; 
	variable nrf_write : std_logic_1164;
	variable nrf_read : std_logic_1164;
	variable nrf_a1 : std_logic_1164;
	variable nrf_a3 : std_logic_vector(1 downto 0);
	variable nrf_d3 : std_logic_vector(1 downto 0);
	variable nt1 : std_logic_1164;
	variable nt2 : std_logic_1164;
	variable nt4 : std_logic_1164;
	variable nt5 : std_logic_1164;
	variable ncarry_en : std_logic_1164;
	variable nzero_en : std_logic_1164;
begin

	nir_enable := "0";
  	npc_select := "00";
  	nalu_op := "00";
  	nalu_a_select := "00";
  	nalu_b_select := "000";
  	nmem_add := "00";
	nmem_write := "0";
	nmem_read := "0"; 
	nrf_write := "0";
	nrf_read := "0";
	nrf_a1 := "0";
	nrf_a3 := "00";
	nrf_d3 := "00";
	nt1 := "0";
	nt2 := "0";
	nt4 := "0";
	nt5 := "0";
	ncarry_en := "0";
	nzero_en := "0";

case state is

	when S0_reset =>
		nir_enable := "0";
  		npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S1_hkt =>
		nir_enable := "1";
	  	npc_select := "01";
	  	nalu_op := "11";
	  	nalu_a_select := "01";
	  	nalu_b_select := "001";
		nmem_read := "1";
	  	nmem_add := "00";
		nmem_write := "0";	 
		nrf_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0"; 

	when S2_bringregdata =>
		nrf_write := "1";
		nrf_a1 := "1";
	----------------------------------------------------------------------
		nir_enable := "0";
	  	npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_read := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0"; 

	when S3_aluopcz =>
		ncarry_en := "1";
		nzero_en := "1";
	  	nalu_op := "10";
	  	nalu_a_select := "10";
	  	nalu_b_select := "010";
	-----------------------------------------------------------------------
		nir_enable := "0";
	  	npc_select := "00";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
	
	when S4_writeback =>
		nrf_write : "1";
		nrf_d3 : "01";
	-----------------------------------------------------------------------
		nir_enable : "0";
	  	npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select : "00";
	  	nalu_b_select : "000";
	  	nmem_add : "00";
		nmem_write : "0";
		nmem_read : "0"; 
		nrf_read : "0";
		nrf_a1 : "0";
		nrf_a3 : "00";
		nt1 : "0";
		nt2 : "0";
		nt4 : "0";
		nt5 : "0";
		ncarry_en : "0";
		nzero_en : "0";

	when S5_writebackrb =>
		nrf_a3 := "01";
		nrf_d3 := "01";
		nrf_write := "1";
	-----------------------------------------------------------------------
		nir_enable := "0";
	  	npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_read := "0";
		nrf_a1 := "0";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S6_bringimm =>
		nrf_read := "1";
		nrf_a1 := "1";
		nt2 := "1";
	-----------------------------------------------------------------------
		nir_enable := "0";
	  	npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S7_storemem =>
		nrf_a1 := "1";
		nrf_write := "1";
	  	nmem_add := "01";
	-----------------------------------------------------------------------
		nir_enable := "0";
	  	npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_read := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S8_loadfrommem =>
		nrf_a3 := "10";
		nrf_d3 := "11";
	  	nmem_add := "01";
		nmem_read := "1"; 
		nrf_write := "1";
	-----------------------------------------------------------------------
		nir_enable := "0";
	  	npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
		nmem_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S9_aluopz =>
	  	nalu_op := "10";
	  	nalu_a_select := "10";
	  	nalu_b_select := "010";
		ncarry_en := "1";
	------------------------------------------------------------------------
		nir_enable := "0";
	  	npc_select := "00";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		nzero_en := "0";

	when S10_storepc =>
	  	nalu_op := "01";
	  	nalu_a_select := "01";
	  	nalu_b_select := "001";
		nrf_a3 := "10";
		nrf_d3 := "10";
		nrf_write := "1";
	-----------------------------------------------------------------------
		nir_enable := "0";
	  	npc_select := "00";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_read := "0";
		nrf_a1 := "0";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S11_decpc =>
	  	npc_select := "01";
	  	nalu_op := "01";
	  	nalu_a_select := "01";
	  	nalu_b_select := "001";
	-----------------------------------------------------------------------
		nir_enable := "0";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S12_pcoff6 =>
	  	npc_select := "01";
	  	nalu_op := "11";
	  	nalu_a_select := "01";
	  	nalu_b_select := "011";
	------------------------------------------------------------------------
		nir_enable := "0";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S13_pcoff9 =>
	  	npc_select := "01";
	  	nalu_op := "11";
	  	nalu_a_select := "01";
	  	nalu_b_select := "100";
	--------------------------------------------------------------------------
		nir_enable := "0";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S14_t2pc =>
	  	npc_select := "01";
	---------------------------------------------------------------------
		nir_enable := "0";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S15_lmloadreg =>
		nrf_a3 := "11";
		nrf_d3 := "11";
	  	nmem_add := "10";
		nmem_read := "1"; 
		nrf_write := "1";
		nt4 := "1";
		nt5 := "1";
	----------------------------------------------------------------------
		nir_enable := "0";
	  	npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
		nmem_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nt1 := "0";
		nt2 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S16_checkz2 =>
		nir_enable := "0";
	  	npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S17_smstoremem =>
		nt4 := "1";
		nt5 := "1";
	  	nmem_add := "10";
		nmem_write := "1";
		nrf_read := "1";
	-------------------------------------------------------------------------
		nir_enable := "0";
	  	npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S18_pout =>
		nt4 := "1";
	----------------------------------------------------------------------
		nir_enable := "0";
	  	npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S19_dataext =>
		nrf_write := "1";
		nrf_a3 := "10";
	-------------------------------------------------------------------------
		nir_enable := "0";
	  	npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S20_bringimm2 =>
		nt1 := "1";
		nt2 := "1";
		nrf_read := "1";
	-----------------------------------------------------------------------	
		nir_enable := "0";
	  	npc_select := "00";
	  	nalu_op := "00";
	  	nalu_a_select := "00";
	  	nalu_b_select := "000";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";
		nzero_en := "0";

	when S21_alusubtract =>
		nalu_a_select := "10";
		nalu_b_select := "010";
		nalu_op := "01";
		nzero_en := "1";
	-----------------------------------------------------------------------	
		nir_enable := "0";
	  	npc_select := "00";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";

	when S22_aluadd =>
		nalu_a_select := "10";
		nalu_b_select := "010";
		nalu_op := "11";
		nzero_en := "1";
	-----------------------------------------------------------------------	
		nir_enable := "0";
	  	npc_select := "00";
	  	nmem_add := "00";
		nmem_write := "0";
		nmem_read := "0"; 
		nrf_write := "0";
		nrf_read := "0";
		nrf_a1 := "0";
		nrf_a3 := "00";
		nrf_d3 := "00";
		nt1 := "0";
		nt2 := "0";
		nt4 := "0";
		nt5 := "0";
		ncarry_en := "0";

end case;

if reset = "1" then
	ir_enable <= nir_enable;
  	pc_select <= npc_select;
  	alu_op <= nalu_op;
  	alu_a_select <= nalu_a_select;
  	alu_b_select <= nalu_b_select;
  	mem_add_select <= nmem_add;
	mem_write <= nmem_write;
	mem_read <= nmem_read; 
	rf_write <= nrf_write;
	rf_read <= nrf_read;
	rf_a1_select <= nrf_a1;
	rf_a3_select <= nrf_a3;
	rf_d3_select <= nrf_d3;
	t1 <= nt1;
	t2<= nt2;
	t4 <= nt4;
	t5 <= nt5;
	carry_en <= ncarry_en;
	zero <= nzero_en;
end if;
end process;
end struct;

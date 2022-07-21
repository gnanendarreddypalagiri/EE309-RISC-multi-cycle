library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components_init.all;

--All the signals you want from the instruction used for next state logic, branches etc
--Takes in the instruction and gives the necessary information about the instruction 
entity instruction_register is
  port (
	--Doesnt need a clock, just a decoder type of circuit 
	instruction : in std_logic_vector(15 downto 0);
	instruction_operation : out std_logic_vector(1 downto 0);
	instruction_carry : out std_logic_1164;
	instruction_zero : out std_logic_1164
	instruction_type : out std_logic_vector(3 downto 0)
  ) ;
end entity ; -- instruction_register

--Instruction type and what it corresponds to 
--0000 means it is an ADD or NAND instructions so next state will always be S2
--0001 means it is ADI instruction so next state will be S6 which brings in immediate data
--0010 means it is an LWI instruction so next state will be S19
--0011 means it is an SW instruction so next state will be S6
--0100 means it is an BEQ instruction so next state will be S2
--0101 means it is an JAL instruction so next state will be S10
--0110 means it is an JLR instruction so next state will be S10
--0111 means it is an LM instruction so next state will be S16 
--1000 means it is an SM instruction so next state will be S16 

architecture IR of instruction_register is

	signal OP : std_logic_vector(3 downto 0);
	signal CZ : std_logic_vector(1 downto 0);

begin
	OP <= instruction(15 downto 12);
	process(OP)
	variable carry_variable : std_logic_1164 := '0';
	variable zero_variable : std_logic_1164 := '0';
	variable inst_op_variable : std_logic_vector(1 downto 0) := "10"; --None operation
	begin 
		if OP = "0000" or OP = "0001" then 
			carry_variable := '1';
			zero_variable := '1';
			inst_op_variable := "11";
		end if;
		if OP = "0010" then
			carry_variable := '0';
			zero_variable := '1';
			inst_op_variable := "00";
		end if;
		instruction_carry <= carry_variable;
		instruction_zero <= zero_variable;
		instruction_operation <= inst_op_variable;
	end process;

	process(OP)
	variable inst_type_variable : std_logic_vector(3 downto 0);
	begin 
		if OP = "0000" or OP = "0010" then --AND and NAND instructions
			inst_type_variable := "0000";
		elsif OP = "0001" then 
			inst_type_variable := "0001"; --ADI instruction
		elsif OP = "0100" then
			inst_type_variable := "0010"; --LWI instruction
		elsif OP = "0101" then
			inst_type_variable := "0011"; --SWI instruction 
		elsif OP = "1100" then
			inst_type_variable := "0100"; --BEQ instruction 
		elsif OP = "1000" then
			inst_type_variable := "0101"; --JAL instruction 
		elsif OP = "1001" then
			inst_type_variable := "0110"; --JLR instruction 
		elsif OP = "0110" then
			inst_type_variable := "0111"; --LM instruction 
		elsif OP = "0111" then
			inst_type_variable := "1000"; --SM instruction 
		end if;
		instruction_type <= inst_type_variable;
	end process;
			
end architecture ; -- IR


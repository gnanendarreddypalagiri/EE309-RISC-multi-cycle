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
	instruction_carry : out std_logic;
	instruction_zero : out std_logic;
	instruction_type : out std_logic_vector(3 downto 0)
  ) ;
end entity ; -- instruction_register

--Instruction type and what it corresponds to 
--0000 means it is an ADI
--0001 means it is ADD
--0010 means it is NAND instructions
--0011 means it is LHI
--0101 means it is SW
--0111 means it is LW
--1000 means it is BEQ
--1001 means it is JAL 
--1010 means it is JLR 
--1011 means it is JRI 
--1100 means it is LM
--1101 means it is SM

architecture IR of instruction_register is

	signal OP : std_logic_vector(3 downto 0);
	signal CZ : std_logic_vector(1 downto 0);

begin
	OP <= instruction(15 downto 12);
	process(OP)
	variable carry_variable : std_logic := '0';
	variable zero_variable : std_logic := '0';
	variable inst_op_variable : std_logic_vector(1 downto 0) := "10"; --None operation
	begin 
		if OP = "0001" or OP = "0010" then 
			carry_variable := '1';
			zero_variable := '1';
			inst_op_variable := "11";
		end if;
		if OP = "0111" then
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
		if OP = "0001" or OP = "0010" then --AND and NAND instructions
			inst_type_variable := "0000";
		elsif OP = "0001" then 
			inst_type_variable := "0000"; --ADI instruction
		elsif OP = "0100" then
			inst_type_variable := "0111"; --LW instruction
		elsif OP = "0101" then
			inst_type_variable := "0101"; --SW instruction 
		elsif OP = "1100" then
			inst_type_variable := "1000"; --BEQ instruction 
		elsif OP = "1000" then
			inst_type_variable := "1001"; --JAL instruction 
		elsif OP = "1001" then
			inst_type_variable := "1010"; --JLR instruction 
		elsif OP = "0110" then
			inst_type_variable := "1100"; --LM instruction 
		elsif OP = "0111" then
			inst_type_variable := "1101"; --SM instruction 
		end if;
		instruction_type <= inst_type_variable;
	end process;
			
end architecture ; -- IR


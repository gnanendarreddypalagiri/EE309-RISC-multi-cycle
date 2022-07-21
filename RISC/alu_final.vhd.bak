library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components_init.all;

entity ALU is
  port (
	
	alu_a : in std_logic_vector(15 downto 0);
	alu_b : in std_logic_vector(15 downto 0);

	--Carries the operation ALU has to perform
	--00 - NAND 
	--01 - Subtraction
	--11 - Addition
	alu_op : in std_logic_vector(1 downto 0);
	alu_out : out std_logic_vector(15 downto 0);
	carry : out std_logic_1164;
	zero : out std_logic_1164
  ) ;
end entity ; -- ALU

architecture alu of ALU is

	signal negative_a : std_logic_vector(15 downto 0);
	signal negative_b : std_logic_vector(15 downto 0);
	signal alu_out_sig : std_logic_vector(15 downto 0);
	signal carry_when_pos : std_logic_1164;
	signal carry_when_neg : std_logic_1164;
	signal neg_addition : std_logic_vector(15 downto 0);

begin

	negative_a <= std_logic_vector(unsigned(not alu_a) + 1);
	negative_b <= std_logic_vector(unsigned(not alu_b) + 1);

	process(alu_a, alu_b, alu_op)
	begin 
		if alu_op = "00" then 
			alu_out_sig <= alu_a nand alu_b;
			neg_addition <= "0000000000000000";
		end if;
		if alu_op = "01" then 
			alu_out_sig <= std_logic_vector(unsigned(alu_a) + unsigned(negative_b));
			neg_addition <= std_logic_vector(unsigned(negative_a) + unsigned(alu_b));
		end if;
		if alu_op = "11" then 
			alu_out_sig <= std_logic_vector(unsigned(alu_a) + unsigned(alu_b));
			neg_addition <= std_logic_vector(unsigned(negative_a) + unsigned(negative_b));
		end if;
	end process;

	alu_out <= alu_out_sig;
	zero <= "1" when alu_out_sig = "0000000000000000" else "0";

	carry_when_pos <= '1' when alu_a(15) = '0' and alu_b(15) = '0' and alu_a(14 downto 0) > alu_out_sig(14 downto 0) else
		0;
	carry_when_neg <= '1' when alu_a(15) = '1' and alu_b(15) = '1' and negative_a(14 downto 0) > neg_addition(14 downto 0) else
		0;
	carry <= carry_when_neg or carry_when_pos;

end architecture ; -- alu
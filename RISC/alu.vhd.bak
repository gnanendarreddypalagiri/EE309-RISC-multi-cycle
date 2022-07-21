library std;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.components_init.all;

entity ALU is
  port (
	
	alu_a : in std_logic_vector(15 downto 0);
	alu_b : in std_logic_vector(15 downto 0);

	--Carries the operation ALU has to perform
	--00 - add
	-- - Subtraction
	--10 - nand
	alu_op : in std_logic_vector(1 downto 0);
	alu_out : out std_logic_vector(15 downto 0);
	carry : out std_logic;
	zero : out std_logic
  ) ;
end entity ; -- ALU

architecture alu_arch of ALU is

	
	signal alu_out_sig : std_logic_vector(15 downto 0);
	signal carry_sig: std_logic;

	

begin

	
	process(alu_a, alu_b, alu_op)
	begin 
		if alu_op = "10" then 
			alu_out_sig <= alu_a nand alu_b;
			
		end if;
		
		if alu_op = "01" then 
			alu_out_sig <= std_logic_vector(unsigned(alu_a) + unsigned(alu_b));
		end if;
	end process;

	alu_out <= alu_out_sig;
	zero <= '1' when alu_out_sig = "0000000000000000" else '0';

	carry_sig <= '1' when alu_a(15) = '0' and alu_b(15) = '0' and alu_a(14 downto 0) > alu_out_sig(14 downto 0) else
		'0';
--	carry_when_neg <= '1' when alu_a(15) = '1' and alu_b(15) = '1' and negative_a(14 downto 0) > neg_addition(14 downto 0) else
		--0;
carry <=carry_sig;

end architecture ; -- alu
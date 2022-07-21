library std;
library ieee;
use ieee.std_logic_1164.all;

entity continue_decoder is
  port (
	cz_condition : in std_logic_vector(1 downto 0);
	carry_flag : in std_logic_1164;
	zero_flag : in std_logic_1164;
	continue : out std_logic_1164
  ) ;
end entity ; -- continue_decoder

architecture CD of continue_decoder is

begin
	process(cz_condition, carry_flag, zero_flag)
	variable continue_var : std_logic_1164 := '0';
	begin
		if cz_condition = "00" then 
			continue_var := '1';
		end if;
		if cz_condition = "10" then 
			continue_var := carry_flag;
		end if;
		if cz_condition = "01" then 
			continue_var := zero_flag;
		end if;
		continue <= continue_var;
	end process;


end architecture ; -- CD
library std;
library ieee;
use ieee.std_logic_1164.all;

entity inst_register_data is
  port (

	inst_in : in std_logic_vector(15 downto 0);
	inst_out : out std_logic_vector(15 downto 0);
	inst_enable : in std_logic_1164;
	clk : in std_logic_1164

  ) ;
end entity ; -- register_data

architecture IR_inst of inst_register_data is

begin

	process(clk) 
	begin 
		if (clk'event and clk = '1') then 
			if inst_enable = '1' then 
				inst_out <= inst_in;
			end if;
		end if;
	end process;


end architecture ; -- IR_inst

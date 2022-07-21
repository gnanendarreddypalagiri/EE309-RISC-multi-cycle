library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.ProcessorComponents.all;

entity register_data is
  port (

	data_in : in std_logic_vector(15 downto 0);
	data_out : out std_logic_vector(15 downto 0);
	clk : in std_logic_1164

  ) ;
end entity ; -- register_data

architecture Reg_data of register_data is

begin
 	-- Clock as writing happens only at the clock edge!!
	process (clk)
	begin 
		if (clk'event and clk = '1') then 
			data_out <= data_in;
		end if;
	end process;

end architecture ; -- IR_inst

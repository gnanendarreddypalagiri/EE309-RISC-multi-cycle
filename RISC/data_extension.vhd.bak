library std;
library ieee;
use ieee.std_logic_1164.all;

entity data_extension is
  port (
	--Doesn't need a clock as whenever the input comes, output should be given. It is a combinational circuit

	data_in : in std_logic_vector(8 downto 0);
	data_out : out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- sign_extender_6

architecture DE of data_extension is

begin
data_out(15 downto 7) <= data_in(8 downto 0);
data_out(6) <= "0";
data_out(5) <= "0";
data_out(4) <= "0";
data_out(3) <= "0";
data_out(2) <= "0";
data_out(1) <= "0";
data_out(0) <= "0";


end architecture ; -- DE

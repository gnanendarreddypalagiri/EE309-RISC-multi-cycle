library std;
library ieee;
use ieee.std_logic_1164.all;
--library work;
--use work.ProcessorComponents.all;

entity shifter_1 is
  port (
	--Doesn't need a clock as whenever the input comes, output should be given. It is a combinational circuit

	data_in : in std_logic_vector(15 downto 0);
	data_out : out std_logic_vector(15 downto 0)
  ) ;
end entity ;

architecture S1 of shifter_1 is


begin
data_out(15 downto 1) <= data_in(14 downto 0);
data_out(0) <= '0';

end architecture ;
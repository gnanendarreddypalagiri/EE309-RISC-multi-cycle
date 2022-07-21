library std;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components_init.all;

--Memory basically takes in the memory read and write signals along with the data in(if needed) and address in to give out data(if needed)
entity memory is
  port (

  	--Clock 
	clk : in std_logic_1164;

	--Memory read and write signals 
	memory_read : in std_logic_1164;
	memory_write : in std_logic_1164;

	--Address in 
	address_in : in std_logic_vector(15 downto 0);

	--Data in 
	data_in : in std_logic_vector(15 downto 0);

	--Used to Initialize
	initialize : in std_logic_1164;

	--Data out of the memory 
	data_out : out std_logic_vector(15 downto 0)

  ) ;
end entity ; -- memory

architecture memory_comp of memory is
type memory_database is array(0 to 127) of std_logic_vector(15 downto 0);
signal memory_block : memory_database;

begin
	process(clk)
	begin 
	if (clk'event and clk = '1') then 
		if (initialize = '1') then 
			memory_block(0) <= "0000000000000000";
			memory_block(1) <= "0000000000000000";
			memory_block(0) <= "0000000000000000";
			memory_block(2) <= "0000000000000000";
			memory_block(3) <= "0000000000000000";
			memory_block(4) <= "0000000000000000";
			memory_block(5) <= "0000000000000000";
			memory_block(6) <= "0000000000000000";
			memory_block(7) <= "0000000000000000";
			memory_block(8) <= "0000000000000000";
			memory_block(9) <= "0000000000000000";
			memory_block(10) <= "0000000000000000";
			memory_block(11) <= "0000000000000000";
			memory_block(12) <= "0000000000000000";
			memory_block(13) <= "0000000000000000";
			memory_block(14) <= "0000000000000000";
			memory_block(15) <= "0000000000000000";
			memory_block(16) <= "0000000000000000";
			memory_block(17) <= "0000000000000000";
			memory_block(18) <= "0000000000000000";
			memory_block(19) <= "0000000000000000";
			memory_block(20) <= "0000000000000000";
			memory_block(21) <= "0000000000000000";
			memory_block(22) <= "0000000000000000";
			memory_block(23) <= "0000000000000000";
			memory_block(24) <= "0000000000000000";
			memory_block(25) <= "0000000000000000";
			memory_block(26) <= "0000000000000000";
			memory_block(27) <= "0000000000000000";
			memory_block(28) <= "0000000000000000";
			memory_block(29) <= "0000000000000000";
			memory_block(30) <= "0000000000000000";
			memory_block(31) <= "0000000000000000";
			memory_block(32) <= "0000000000000000";
			memory_block(33) <= "0000000000000000";
			memory_block(34) <= "0000000000000000";
			memory_block(35) <= "0000000000000000";
			memory_block(36) <= "0000000000000000";
			memory_block(37) <= "0000000000000000";
			memory_block(38) <= "0000000000000000";
			memory_block(39) <= "0000000000000000";
			memory_block(40) <= "0000000000000000";
			memory_block(41) <= "0000000000000000";
			memory_block(42) <= "0000000000000000";
			memory_block(43) <= "0000000000000000";
			memory_block(44) <= "0000000000000000";
			memory_block(45) <= "0000000000000000";
			memory_block(46) <= "0000000000000000";
			memory_block(47) <= "0000000000000000";
			memory_block(48) <= "0000000000000000";
			memory_block(49) <= "0000000000000000";
			memory_block(50) <= "0000000000000000";
			memory_block(51) <= "0000000000000000";
			memory_block(52) <= "0000000000000000";
			memory_block(53) <= "0000000000000000";
			memory_block(54) <= "0000000000000000";
			memory_block(55) <= "0000000000000000";
			memory_block(56) <= "0000000000000000";
			memory_block(57) <= "0000000000000000";
			memory_block(58) <= "0000000000000000";
			memory_block(59) <= "0000000000000000";
			memory_block(60) <= "0000000000000000";
			memory_block(61) <= "0000000000000000";
			memory_block(62) <= "0000000000000000";
			memory_block(63) <= "0000000000000000";
			memory_block(64) <= "0000000000000000";
			memory_block(65) <= "0000000000000000";
			memory_block(66) <= "0000000000000000";
			memory_block(67) <= "0000000000000000";
			memory_block(68) <= "0000000000000000";
			memory_block(69) <= "0000000000000000";
			memory_block(70) <= "0000000000000000";
			memory_block(71) <= "0000000000000000";
			memory_block(72) <= "0000000000000000";
			memory_block(73) <= "0000000000000000";
			memory_block(74) <= "0000000000000000";
			memory_block(75) <= "0000000000000000";
			memory_block(76) <= "0000000000000000";
			memory_block(77) <= "0000000000000000";
			memory_block(78) <= "0000000000000000";
			memory_block(79) <= "0000000000000000";
			memory_block(80) <= "0000000000000000";
			memory_block(81) <= "0000000000000000";
			memory_block(82) <= "0000000000000000";
			memory_block(83) <= "0000000000000000";
			memory_block(84) <= "0000000000000000";
			memory_block(85) <= "0000000000000000";
			memory_block(86) <= "0000000000000000";
			memory_block(87) <= "0000000000000000";
			memory_block(88) <= "0000000000000000";
			memory_block(89) <= "0000000000000000";
			memory_block(90) <= "0000000000000000";
			memory_block(91) <= "0000000000000000";
			memory_block(92) <= "0000000000000000";
			memory_block(93) <= "0000000000000000";
			memory_block(94) <= "0000000000000000";
			memory_block(95) <= "0000000000000000";
			memory_block(96) <= "0000000000000000";
			memory_block(97) <= "0000000000000000";
			memory_block(98) <= "0000000000000000";
			memory_block(99) <= "0000000000000000";
			memory_block(100) <= "0000000000000000";
			memory_block(101) <= "0000000000000000";
			memory_block(102) <= "0000000000000000";
			memory_block(103) <= "0000000000000000";
			memory_block(104) <= "0000000000000000";
			memory_block(105) <= "0000000000000000";
			memory_block(106) <= "0000000000000000";
			memory_block(107) <= "0000000000000000";
			memory_block(108) <= "0000000000000000";
			memory_block(109) <= "0000000000000000";
			memory_block(110) <= "0000000000000000";
			memory_block(111) <= "0000000000000000";
			memory_block(112) <= "0000000000000000";
			memory_block(113) <= "0000000000000000";
			memory_block(114) <= "0000000000000000";
			memory_block(115) <= "0000000000000000";
			memory_block(116) <= "0000000000000000";
			memory_block(117) <= "0000000000000000";
			memory_block(118) <= "0000000000000000";
			memory_block(119) <= "0000000000000000";
			memory_block(120) <= "0000000000000000";
			memory_block(121) <= "0000000000000000";
			memory_block(122) <= "0000000000000000";
			memory_block(123) <= "0000000000000000";
			memory_block(124) <= "0000000000000000";
			memory_block(125) <= "0000000000000000";
			memory_block(126) <= "0000000000000000";
			memory_block(127) <= "0000000000000000";
		
		if (memory_write = '1') then
			memory_block(to_integer(unsigned(address_in(3 downto 0)))) <= data_in;

		end if;
		end if;
		end if;
		data_out <= memory_block(to_integer(unsigned(address_in(3 downto 0)))); -- default 

	end process;

	end architecture;

			
			
			


end architecture ; -- memroy_comp
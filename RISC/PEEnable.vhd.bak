library ieee;
use ieee.std_logic_1164.all;

entity PEEnable is
	port (current_state : IN STD_LOGIC_VECTOR(4 downto 0);
        PE_enable : OUT STD_LOGIC
        );
end PEEnable;


architecture description of PEEnable is
    constant S2: STD_LOGIC_VECTOR(4 downto 0) := "00010";
		begin
			process (current_state)
			begin
				case current_state is
	        when S2 =>
	                PE_enable <= '1';
					when others =>
          	      PE_enable <= '0';
	      end case;
			end process;
end description;

library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY compt10s IS
PORT(
	clk : IN std_logic;
	Q : OUT std_logic_vector(3 downto 0);
        led_o: OUT std_logic_vector(7 downto 0)
	);
END compt10s ;

ARCHITECTURE a OF compt10s IS
	CONSTANT max : integer := ( 125e6 )/10-1;
        CONSTANT VALMAX : integer := 8-1;
	SIGNAL compteur1s : integer range 0 to max;
	SIGNAL compteur10 : integer range 0 to VALMAX;
BEGIN
	process
	begin
		wait until rising_edge(clk);
		if compteur1s >= max then
			compteur1s <= 0;
			if compteur10 >= VALMAX then
				compteur10 <= 0;
			else compteur10 <= compteur10 + 1;
			end if;
		else compteur1s <= compteur1s + 1;
			compteur10 <= compteur10;
		end if;
                led_o <= (others => '0');
                led_o(compteur10) <= '1';
-- led_o <= led_o(6 downto 0) & led_o(7);
-- led_o <= led_o(to_integer(unsigned(vecteur,3))) <= '1';
	end process;
	Q <= std_logic_vector(to_unsigned(compteur10,4));
END a;

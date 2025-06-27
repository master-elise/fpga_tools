library ieee;
use ieee.std_logic_1164.all;

ENTITY seven_seg IS
PORT(
	SW: in std_logic_vector (3 downto 0);
	gfedcba : OUT std_logic_vector (6 downto 0) -- gfedcba
	);	
END seven_seg ;

ARCHITECTURE a OF seven_seg IS
	SIGNAL non_inv : STD_LOGIC_vector (6 downto 0);
BEGIN
	WITH SW select
		non_inv <=  "0111111" WHEN "0000",--0
						"0000110" WHEN "0001",--1
						"1011011" WHEN "0010",--2
						"1001111" WHEN "0011",--3
						"1100110" WHEN "0100",--4
						"1101101" WHEN "0101",--5
						"1111101" WHEN "0110",--6
						"0000111" WHEN "0111",--7
						"1111111" WHEN "1000",--8
						"1100111" WHEN "1001",--9
						"1110111" WHEN "1010",--A
						"1111100" WHEN "1011",--B
						"0111001" WHEN "1100",--C
						"1011110" WHEN "1101",--D
						"1111001" WHEN "1110",--E
						"1110001" WHEN "1111", --F
						"0000000" WHEN OTHERS;
	gfedcba <=  not non_inv;
END a;

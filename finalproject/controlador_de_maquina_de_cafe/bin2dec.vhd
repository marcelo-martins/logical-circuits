LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

entity bin2dec is
port (
SW: in std_logic_vector(4 downto 0);
HEX0: out std_logic_vector(6 downto 0)
);
end bin2dec;

ARCHITECTURE LogicFunction OF bin2dec IS
BEGIN
WITH SW SELECT
	HEX0 <= "1000000" WHEN "00000",
		"1111001" WHEN "00001",            --DCBA
 		"0100100" WHEN "00010",
		"0110000" WHEN "00011",
		"0011001" WHEN "00100",
		"0010010" WHEN "00101",
		"0000010" WHEN "00110",
		"1111000" WHEN "00111",
		"0000000" WHEN "01000",
		"0010000" WHEN "01001",
		
		--letras
		"0000110" when "10001", --E 
		"0001100" when "10011", --P
		"1001100" when "10100", --R
		"1000110" when "10101", --C
		"0001000" when "10111", --A
		"0001001" when "11000", --H 
		"1000111" when "10010", --L
		"0100001" when "11001", --d
		"0101011" when "11100", --n
		
		
		"1000001" when "11010" ,--U -----------------------------------------------------apaga
		
		
		"1111111" WHEN OTHERS;
	
END LogicFunction ;

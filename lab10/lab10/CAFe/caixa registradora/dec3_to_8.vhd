library IEEE;	
use IEEE.STD_LOGIC_1164.ALL;

entity dec3_to_8 is
Port ( x : in STD_LOGIC_VECTOR (2 downto 0);
		y : out STD_LOGIC_VECTOR (7 downto 0)
);
end dec3_to_8;

architecture rt1 of dec3_to_8 is
begin
with x select
		y<="00000001" when "000",
			"00000010" when "001",
			"00000100" when "010",
			"00001000" when "011",
			"00010000" when "100",
			"00100000" when "101",
			"01000000" when "110",
			"10000000" when "111",
			"00000000" when others;
end rt1;
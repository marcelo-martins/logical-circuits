library IEEE;	
use IEEE.STD_LOGIC_1164.ALL;

entity zbuffer is
	generic(N : INTEGER :=4);
    Port ( x  : in  STD_LOGIC_VECTOR (N-1 downto 0);
           e  : in  STD_LOGIC;
           f : out STD_LOGIC_VECTOR (N-1 downto 0));
end zbuffer;

architecture rt1 of zbuffer is

begin

    --f <= x when (e = '0') else "ZZZZ"; jeito mais facil mas sem generic
	 f <= (others => 'Z') when e = '0' else x ;

end rt1;
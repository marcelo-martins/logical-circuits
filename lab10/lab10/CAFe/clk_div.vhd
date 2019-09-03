library ieee;
use ieee.std_logic_1164.all;

entity clk_div is
  port (
    CLOCK_50 : in std_logic;
    clock_1s : out std_logic
  );
end clk_div;

architecture behavioral of clk_div is

signal clk_count: integer range 0 to 50000001;
signal new_clk: std_logic;

begin
process
	begin
		wait until clk'EVENT and clk='1';
		clk_count <= clk_count + 1;
		if clk_count = 50000000 then
			new_clk <= '1';
			clk_count <= 0;
		else
			new_clk <= '0';
		end if;
	end process;
	
clock_1s <= new_clk;

end behavioral;

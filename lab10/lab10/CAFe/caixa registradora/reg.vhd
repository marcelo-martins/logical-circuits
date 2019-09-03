library ieee;
use ieee.std_logic_1164.all;

entity reg is
  generic (
    N : integer := 4
  );
  port (
    clk : in std_logic;
    data_in : in std_logic_vector(N-1 downto 0);
    data_out : out std_logic_vector(N-1 downto 0);
    load : in std_logic; -- Write enable
    clear : in std_logic
  );
end reg;

architecture rtl of reg is

begin
  
  g1: for i in N-1 downto 0 generate
		process(clear, clk)
			begin
				if (Clear='1') then 
					data_out(i) <= '0';
				elsif Clk'event AND Clk = '1' AND load='1' then
					data_out(i)<=data_in(i);
				end if;
		end process;
		end generate;
  
end rtl;

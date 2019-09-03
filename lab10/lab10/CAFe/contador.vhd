library ieee;
use ieee.std_logic_1164.all;

entity contador is
  port (
    clock_1s : in std_logic;
    tempo_preparo : in std_logic_vector(1 downto 0);
	 esgotou_tempo : out std_logic;
  );
end contador;

c

signal tempo_passado: integer range 0 to 20;
signal terminou std_logic;

begin
	process
	begin 
		wait until clock_1s'EVENT and clock_1s = '1'
			tempo_passado <= tempo_passado + 1;
			if tempo_passado = tempo_preparo then
				terminou <= '1';
				tempo_passado <= '0';
			else
				terminou <= '0';
			end if;
	end process;
	
	esgotou_tempo <= terminou;
				




end behavioral;
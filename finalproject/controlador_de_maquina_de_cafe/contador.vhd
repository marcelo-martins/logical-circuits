library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity contador is
  port (
    clock_1s : in std_logic;
    tempo_preparo : in std_logic_vector(1 downto 0);
	 esgotou_tempo : out std_logic
  );
end contador;

architecture behavioral of contador is


signal tempo_passado: integer range 0 to 20;
signal tempo_passado_int: integer range 0 to 20;
signal tempo_preparo_int: integer range 0 to 20;


signal terminou: std_logic;

begin
	tempo_preparo_int <= to_integer(unsigned(tempo_preparo));


	process
	begin
		wait until clock_1s'EVENT and clock_1s = '1';
			tempo_passado <= tempo_passado + 1;
			if (tempo_passado = tempo_preparo_int) then
				terminou <= '1';
				tempo_passado <= 0;
			else
				terminou <= '0';
			end if;
	end process;

	esgotou_tempo <= terminou;





end behavioral;

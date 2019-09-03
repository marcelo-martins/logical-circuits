library ieee;
use ieee.std_logic_1164.all;



entity caixa_registradora_lixo is
  port (
		dinheiro_inserido: in std_logic_vector(7 downto 0);
  );
end caixa_registradora;

architecture behavioral of caixa_registradora_lixo is

signal 5_cents:  std_logic_vector(6 downto 0);
signal 10_cents: std_logic_vector(6 downto 0);
signal 25_cents: std_logic_vector(6 downto 0);
signal 50_cents: std_logic_vector(6 downto 0);
signal 1_real:   std_logic_vector(6 downto 0);
signal 2_real:   std_logic_vector(6 downto 0);
signal 5_real:   std_logic_vector(6 downto 0);
signal 10_real:  std_logic_vector(6 downto 0);


begin

	p1 process()
	variable n_5cents: integer range 0 to 127;
	begin
		case dinheiro_inserido is
				when "00000001"	=> n_5cents  <= n_5cents  + 1;
				when "00000010"	=> n_10cents <= n_10cents + 1;
				when "00000100"	=> n_25cents <= n_25cents + 1;
				when "00001000"	=> n_50cents <= n_50cents + 1;
				when "00010000"	=> n_1real   <= n_1real  + 1;
				when "00100000"	=> n_2real   <= n_2real  + 1;
				when "01000000"	=> n_5real   <= n_5real  + 1;
				when "10000000"	=> n_10real  <= n_10real  + 1;
		
								
	
	end process;
end caixa_registradora_lixo;
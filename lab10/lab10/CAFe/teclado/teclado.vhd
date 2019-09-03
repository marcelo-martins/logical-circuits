library ieee;
use ieee.std_logic_1164.all;

entity teclado is
  port (
    clk : in std_logic;
    key_on : in std_logic_vector(2 downto 0);
    key_code : in std_logic_vector(47 downto 0); 
	 dinheiro_inserido: out std_logic_vector(7 downto 0);
	 opcao_cafe: out std_logic_vector(2 downto 0);
  );
end teclado;
 
architecture rtl of teclado is 

begin 

with scanCode select
		dinheiro_inserido  <= 
				 --moedas
				 "00000001" when x"0016",-- 5 cents
				 "00000010" when x"001E",-- 10cents
				 "00000100" when x"0026",-- 25cents
				 "00001000" when x"0025",-- 50cents
				 "00010000" when x"002E",-- 1 reaol
				 --notas	
				 "00100000" when x"0069",-- 2 real
				 "01000000" when x"0072",-- 5 real
				 "10000000" when x"007A",--10 real 
 
				 --valor invalido/sem moeda
				 x"0" when others;
				 
with scanCode select
		opcao_cafe  <= 
			"001" when x"0024",--(E) escolheu espresso
			"010" when x"0021",--(C) escolheu o cappuccino
			"011" when x"003A",--(M) escolheu moca
			"100" when x"0043",--(I) escolheu irlandes
			
			"000" when others;
	
end rtl;

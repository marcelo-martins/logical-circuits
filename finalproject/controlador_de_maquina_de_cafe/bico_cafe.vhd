LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;



ENTITY bico_cafe IS 
		PORT (
			clock_50: in std_logic;
			cafe_prept: in std_logic_vector(3 downto 0);
			leit_prept: in std_logic_vector(3 downto 0);
			choc_prept: in std_logic_vector(3 downto 0);
			uisk_prept: in std_logic_vector(3 downto 0);
			
			pode_fazer: in std_logic;
			
			saida_fazendo0: out std_logic_vector(4 downto 0);
			saida_fazendo1: out std_logic_vector(4 downto 0);
			saida_fazendo2: out std_logic_vector(4 downto 0);
			saida_fazendo3: out std_logic_vector(4 downto 0);
			saida_fazendo4: out std_logic_vector(4 downto 0);
			saida_fazendo5: out std_logic_vector(4 downto 0);
			
			acabou	   : OUT	integer
		);
END ENTITY;
architecture rtl of bico_cafe is 

component clk_div is
  port (
    CLOCK_50 : in std_logic;
    clock_1s : out std_logic
  );
end component;

signal clock_1s: std_logic;

begin
	
	clock_div : clk_div port map(
		clock_50 => clock_50,
		clock_1s => clock_1s
	);
	
	making_coffee: process
	variable making: std_logic_vector(2 downto 0) := "000";
	variable tempo: integer := 0;
	variable tempo_vet: std_logic_vector(4 downto 0) := "00000";
	variable acabou_local: integer := 0;
	
	variable pode_fazer_var: std_logic;

	begin
		wait until clock_1s'EVENT and clock_1s = '1';
		
		pode_fazer_var := pode_fazer;
		
		--if(pode_fazer_var = '1') then tempo := 0; end if;
		
		if(pode_fazer='1') then 
			tempo := tempo + 1;
			--saida_fazendo0 <= "10001";
			
			if(making = "000") then --cafe
				if(tempo /= to_integer(unsigned(cafe_prept)) + 1) then
					if(cafe_prept /= "0000") then
						saida_fazendo5 <= "10101";
						saida_fazendo4 <= "10111";
						saida_fazendo1 <= std_logic_vector(to_unsigned(tempo/10, 5));
						saida_fazendo0 <= std_logic_vector(to_unsigned(tempo mod 10, 5));
						
						saida_fazendo3 <= "11111";
				saida_fazendo2 <= "11111";
						
					end if;
				else
					making := std_logic_vector(to_unsigned(to_integer(unsigned(making))+1, 3));
					tempo := 0;
				end if;
			elsif(making = "001") then --leite
				if(tempo /= to_integer(unsigned(leit_prept)) + 1) then
						if(leit_prept /= "0000") then
							saida_fazendo5 <= "10010";
							saida_fazendo4 <= "10001";
							saida_fazendo1 <= std_logic_vector(to_unsigned(tempo/10, 5));
							saida_fazendo0 <= std_logic_vector(to_unsigned(tempo mod 10, 5));
							
							saida_fazendo3 <= "11111";
				saida_fazendo2 <= "11111";
							
						end if;
					else
						making := std_logic_vector(to_unsigned(to_integer(unsigned(making))+1, 3));
						tempo := 0;
					end if;
			elsif(making = "010") then --achocolatado
				if(tempo /= to_integer(unsigned(choc_prept)) + 1) then
						if(choc_prept /= "0000") then
							saida_fazendo5 <= "10101";
							saida_fazendo4 <= "11000";
							saida_fazendo1 <= std_logic_vector(to_unsigned(tempo/10, 5));
							saida_fazendo0 <= std_logic_vector(to_unsigned(tempo mod 10, 5));
							
							saida_fazendo3 <= "11111";
				saida_fazendo2 <= "11111";
							
						end if;
					else
						making := std_logic_vector(to_unsigned(to_integer(unsigned(making))+1, 3));
						tempo := 0;
					end if;
			elsif(making = "011") then --uisk
				if(tempo /= to_integer(unsigned(uisk_prept)) + 1) then
						if(uisk_prept /= "0000") then
							saida_fazendo5 <= "11010";
							saida_fazendo4 <= "00001";
							saida_fazendo1 <= std_logic_vector(to_unsigned(tempo/10, 5));
							saida_fazendo0 <= std_logic_vector(to_unsigned(tempo mod 10, 5));
							
							saida_fazendo3 <= "11111";
				saida_fazendo2 <= "11111";
							
						end if;
					else
						acabou_local := 1;
						making := std_logic_vector(to_unsigned(to_integer(unsigned(making))+1, 3));
						tempo := 0;
					end if;
			else
				saida_fazendo5 <= "11001";
				saida_fazendo4 <= "00000";
				saida_fazendo3 <= "11100";
				saida_fazendo2 <= "10001";
				saida_fazendo1 <= "11111";
				saida_fazendo0 <= "11111";
				
			end if;
			
			acabou <= acabou_local; --------pode voltar ao estado inicial fazerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
		
		end if;

end process making_coffee;

end rtl;



-------------------------------------------------------------------------------
-----------------------maquina de cafe-----------------------------------------
-------------------------------------------------------------------------------
--OPCOES
--1 - ESPRESSO
--			30ml de cafe
--2 - CAPPUCCINO
--			30ml de cafe
--			60ml de leite
--3 - MOCACCINO
--			30ml de cafe
--			30ml de leite
--       30ml de chocolate
--4 - IRLANDES
--			30ml de cafe
--       30ml de leite
--			30ml whiskey(uiskiin)
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------



LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

ENTITY UC IS
		PORT (
			 CLOCK_50: in std_logic;
			 PS2_DAT : inout STD_LOGIC;
			 KEY: in std_logic_vector(3 downto 0);
			 PS2_CLK : inout STD_LOGIC;
			 HEX0: out std_logic_vector(6 downto 0);
			 HEX1: out std_logic_vector(6 downto 0);
			 HEX2: out std_logic_vector(6 downto 0);
			 HEX3: out std_logic_vector(6 downto 0);
			 HEX4: out std_logic_vector(6 downto 0);
			 HEX5: out std_logic_vector(6 downto 0)
		);
END UC;

architecture fulltrab of UC is

------------------------------------
------------COMPONENTES-------------
------------------------------------
component kbd_alphanum_board is
  port (
	 CLOCK_50 : in std_logic;
    PS2_DAT : inout STD_LOGIC;
    PS2_CLK : inout STD_LOGIC;
	 --dinheiro_inserido : out std_logic_vector(7 downto 0);
	 dinheiro_inserido: out std_logic_vector(3 downto 0);
	 --cafeOn:out std_logic;
	 opcao_cafe: out std_logic_vector(2 downto 0)
  );
end component;

component register_bank is
  port (
    clk : in std_logic;
    data_in : in std_logic_vector(7 downto 0);    --3 0
	 data_out: out std_logic_vector(7 downto 0);
    reg_rd : in std_logic_vector(2 downto 0); ---6 4
    reg_wr : in std_logic_vector(2 downto 0);  --9 7
    we : in std_logic;
    clear : in std_logic
  );
end component;

component clk_div is
  port (
    CLOCK_50 : in std_logic;
    clock_1s : out std_logic
  );
end component;

component contador is
  port (
    clock_1s : in std_logic;
    tempo_preparo : in std_logic_vector(1 downto 0);
	  esgotou_tempo : out std_logic
  );
end component;


component bico_cafe IS 
		PORT (
			clock_50 : in std_logic;
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
END component;





component bin2dec is
port (
	SW: in std_logic_vector(4 downto 0);
	HEX0: out std_logic_vector(6 downto 0)
);
end component;

component ff_t IS
	PORT (
		T: in std_logic;
		Clk: in std_logic;
		Q: out std_logic;
		Preset: in std_logic;
		Clear: in std_logic;
		Q_n: out std_logic
		);
end component;

component kbdex_ctrl is
    generic(
      clkfreq : integer
    );
    port(
      ps2_data : inout std_logic;
      ps2_clk : inout std_logic;
      clk :	in std_logic;
      en : in std_logic;
      resetn : in std_logic;
      lights : in std_logic_vector(2 downto 0);
      key_on : out std_logic_vector(2 downto 0);
      key_code : out std_logic_vector(47 downto 0)
    );
  end component;


--ESTADOS DA MAQUINA DE CAFFERSON
type estado_type is (escolhendo_cafe,mostrando_escolha, pagando, troco, fazendo_cafe);
signal estado_maq: estado_type := escolhendo_cafe;
signal proximo_estado: estado_type := escolhendo_cafe;
signal clock_1s: std_logic;
signal cafe_escolhido_sub: std_logic;
signal cafeOn: std_logic;
signal cafe_ff: std_logic;
--TEMPOS DE PREPARO
signal cafe_prept: std_logic_vector(3 downto 0);
signal leit_prept: std_logic_vector(3 downto 0);
signal choc_prept: std_logic_vector(3 downto 0);
signal uisk_prept: std_logic_vector(3 downto 0);


signal cafe_escolhido: std_logic := '0';
signal preco_cafe: std_logic_vector(3 downto 0);

--signal dinheiro_inserido: std_logic_vector(7 downto 0);


signal dinheiro_inserido: std_logic_vector(3 downto 0);
signal dinheiro_inserido_anterior: std_logic_vector(3 downto 0);
signal dinheiro_inserido_aux: std_logic_vector(3 downto 0);



signal opcao_cafe: std_logic_vector(2 downto 0);

signal mudou_dinheiro: std_logic;
--signal dinheiro_inserido_anterior: std_logic_vector(7 downto 0);
--signal dinheiro_inserido_aux: std_logic_vector(7 downto 0);
signal opcao_cafe_aux: std_logic_vector(2 downto 0);

--bagulhos da caixa registradora
signal ta_pago: std_logic := '0';
signal ta_trocado: std_logic;
signal mostrar_escolha: std_logic;
signal mostrou_escolha: std_logic;
signal real_total: std_logic_vector(6 downto 0);
signal centavos_total: std_logic_vector(6 downto 0);
signal real_pago: std_logic_vector(6 downto 0);
signal centavos_pago: std_logic_vector(6 downto 0);
signal real_troco: std_logic_vector(6 downto 0);
signal centavos_troco: std_logic_vector(6 downto 0);
signal quantidade_nota: std_logic_vector(7 downto 0);

signal cents_5:  std_logic_vector(6 downto 0) := "0000000";
signal cents_10: std_logic_vector(6 downto 0) := "0000000";
signal cents_25: std_logic_vector(6 downto 0) := "0000000";
signal cents_50: std_logic_vector(6 downto 0) := "0000000";
signal real_1:   std_logic_vector(6 downto 0) := "0000000";
signal real_2:   std_logic_vector(6 downto 0) := "0000000";
signal real_5:   std_logic_vector(6 downto 0) := "0000000";
signal real_10:  std_logic_vector(6 downto 0) := "0000000";

signal saida_hex0:  std_logic_vector(4 downto 0) := "11111";
signal saida_hex1:  std_logic_vector(4 downto 0) := "11111";
signal saida_hex2:  std_logic_vector(4 downto 0) := "11111";
signal saida_hex3:  std_logic_vector(4 downto 0) := "11111";
signal saida_hex4:  std_logic_vector(4 downto 0) := "11111";
signal saida_hex5:  std_logic_vector(4 downto 0) := "11111";

signal saida_cafe0:  std_logic_vector(4 downto 0) := "11111";
signal saida_cafe1:  std_logic_vector(4 downto 0) := "11111";
signal saida_cafe2:  std_logic_vector(4 downto 0) := "11111";
signal saida_cafe3:  std_logic_vector(4 downto 0) := "11111";
signal saida_cafe4:  std_logic_vector(4 downto 0) := "11111";
signal saida_cafe5:  std_logic_vector(4 downto 0) := "11111";

signal saida_pagando0:  std_logic_vector(4 downto 0) := "11111";
signal saida_pagando1:  std_logic_vector(4 downto 0) := "11111";
signal saida_pagando2:  std_logic_vector(4 downto 0) := "11111";
signal saida_pagando3:  std_logic_vector(4 downto 0) := "11111";
signal saida_pagando4:  std_logic_vector(4 downto 0) := "11111";
signal saida_pagando5:  std_logic_vector(4 downto 0) := "11111";

signal saida_troco0:  std_logic_vector(4 downto 0) := "11111";
signal saida_troco1:  std_logic_vector(4 downto 0) := "11111";
signal saida_troco2:  std_logic_vector(4 downto 0) := "11111";
signal saida_troco3:  std_logic_vector(4 downto 0) := "11111";
signal saida_troco4:  std_logic_vector(4 downto 0) := "11111";
signal saida_troco5:  std_logic_vector(4 downto 0) := "11111";

signal saida_fazendo0:  std_logic_vector(4 downto 0) := "11111";
signal saida_fazendo1:  std_logic_vector(4 downto 0) := "11111";
signal saida_fazendo2:  std_logic_vector(4 downto 0) := "11111";
signal saida_fazendo3:  std_logic_vector(4 downto 0) := "11111";
signal saida_fazendo4:  std_logic_vector(4 downto 0) := "11111";
signal saida_fazendo5:  std_logic_vector(4 downto 0) := "11111";

signal rstn : std_logic;
signal key_on : std_logic_vector(2 downto 0);
signal key_code : std_logic_vector(47 downto 0);

signal lixo: std_logic_vector(6 downto 0);

signal inteiro: integer:= 0;

signal trocou: std_logic;

signal dinheiros_iguais: std_logic_vector(3 downto 0);

signal preparando: std_logic_vector (1 downto 0) := "00";

signal acabou: integer := 0;

signal pode_fazer: std_logic := '0';

signal cafe_e_reset:std_logic_vector(1 downto 0);


--signal int: integer range 0 to 20;

begin
   --PORT MAPS
--	cafe_ff_inst: ff_t PORT map(
--		T => '1',
--		Clk =>  cafeOn,
--		Q => cafe_ff,
--		Preset => '0',
--		Clear => '0',
--		Q_n => open
--		);
	--TECLADO
	 kbd_inst: kbd_alphanum_board port map(
		 CLOCK_50 => CLOCK_50,
		 PS2_DAT => PS2_DAT,
		 PS2_CLK => PS2_CLK,
		 dinheiro_inserido => dinheiro_inserido,
		-- cafeOn=>cafeOn,
		 opcao_cafe => opcao_cafe_aux ----------------------mudei o aux
	 );
	 
	 
	 bico_cafe_inst: bico_cafe port map(
			clock_50 => clock_50,
			cafe_prept =>cafe_prept,
			leit_prept =>leit_prept,
			choc_prept =>choc_prept,
			uisk_prept =>uisk_prept,
			pode_fazer => pode_fazer,
			saida_fazendo0 => saida_fazendo0,
			saida_fazendo1 => saida_fazendo1,
			saida_fazendo2 => saida_fazendo2,
			saida_fazendo3 => saida_fazendo3,
			saida_fazendo4 => saida_fazendo4,
			saida_fazendo5 => saida_fazendo5,
			acabou => acabou
	);
			
	 
	 
	 
	 
	 
	 
	 
	 
	 
kbdex_ctrl_inst: kbdex_ctrl
	  generic map (
      clkfreq => 50000
    )
		port map(
		ps2_data	=> PS2_DAT,
		ps2_clk	=> PS2_CLK,
		clk => CLOCK_50,	
		en	=> '1',
		resetn => '1',
		lights => "000",
		key_on => key_on,
		key_code	=> key_code
	);
	 
	 

  clk_div_1s: clk_div port map(
    CLOCK_50 => 	CLOCK_50,
    clock_1s => clock_1s
  );

	bintodec0: bin2dec port map(
		SW => saida_hex0,
		HEX0 => HEX0
	);
	bintodec1: bin2dec port map(
		SW => saida_hex1,
		HEX0 => HEX1
	);
	bintodec2: bin2dec port map(
		SW => saida_hex2,
		HEX0 => HEX2
	);
	bintodec3: bin2dec port map(
		SW =>saida_hex3,
		HEX0 => HEX3
	);
	bintodec4: bin2dec port map(
		SW =>saida_hex4,
		HEX0 =>HEX4
	);
	bintodec5: bin2dec port map(
		SW =>saida_hex5,
		HEX0 => HEX5
	);

	with estado_maq select
	saida_hex0 <= saida_cafe0 when escolhendo_cafe,
					  saida_cafe0 when mostrando_escolha,
					  saida_pagando0 when pagando,
					  saida_troco0 when troco,
					  saida_fazendo0 when fazendo_cafe,
					  "11111" when others;
	with estado_maq select
	saida_hex1 <= saida_cafe1 when escolhendo_cafe,
					  saida_cafe1 when mostrando_escolha,
					  saida_pagando1 when pagando,
					  saida_troco1 when troco,
					  saida_fazendo1 when fazendo_cafe,
					  "11111" when others;
	with estado_maq select
		saida_hex2 <= saida_cafe2 when escolhendo_cafe,
							saida_cafe2 when mostrando_escolha,
						  saida_pagando2 when pagando,
						  saida_troco2 when troco,
						  saida_fazendo2 when fazendo_cafe,
						  "11111" when others;

	with estado_maq select
		saida_hex3 <= saida_cafe3 when escolhendo_cafe,
							saida_cafe3 when mostrando_escolha,
						  saida_pagando3 when pagando,
						  saida_troco3 when troco,
						  saida_fazendo3 when fazendo_cafe,
						  "11111" when others;
	with estado_maq select
		saida_hex4 <= saida_cafe4 when escolhendo_cafe,
							saida_cafe4 when mostrando_escolha,
						  saida_pagando4 when pagando,
						  saida_troco4 when troco,
						  saida_fazendo4 when fazendo_cafe,
						  "11111" when others;
	with estado_maq select
		saida_hex5 <= saida_cafe5 when escolhendo_cafe,
		              saida_cafe5 when mostrando_escolha,
						  saida_pagando5 when pagando,
						  saida_troco5 when troco,
						  saida_fazendo5 when fazendo_cafe,
						  "11111" when others;
						  
	with proximo_estado select
		pode_fazer <= '1' when fazendo_cafe,
						  '0' when others;
	

	 ----------------------------------------------------
	 -----------------maquina de estado------------------
	 ----------------------------------------------------
	 maquina_cafe: process(cafe_escolhido_sub,estado_maq)
	 begin
		case estado_maq is
			when escolhendo_cafe =>
							if(cafe_escolhido_sub = '1') then
								mostrar_escolha <= '1';
								proximo_estado <= mostrando_escolha; 
							else
								proximo_estado <= escolhendo_cafe; 
								mostrar_escolha <= '0';
							end if;
			when mostrando_escolha =>
							if(mostrou_escolha = '1') then
								proximo_estado <= pagando; 
							else
							   proximo_estado <= mostrando_escolha; 
							end if;

			when pagando =>
							if(ta_pago = '1') then
								proximo_estado <= fazendo_cafe;        --fazer o mostrar grana aqui aaaaaaaaaaaaaaaaaaaaaaa
								--ta_pago <= '0';
							else  
								proximo_estado <= pagando;
							end if;
							-------TEM QUE FAZER UMAS FLAG PRA NAO RECEBER DINHERO QUANDO NAO TEM QUE RECEBER DINHEIRO

			when troco =>
							if(ta_trocado = '1') then
								proximo_estado <= fazendo_cafe;
							else
								proximo_estado <= troco;
							end if;


			when fazendo_cafe =>
							if(acabou = 1) then
								proximo_estado <= fazendo_cafe;
							else
								proximo_estado <= fazendo_cafe;
							end if;
			when others =>
							proximo_estado <= escolhendo_cafe;
							--cafe_escolhido <= '0';
		end case;



	 end process;
	 
	 --dinheiros_iguais <= dinheiro_inserido xor dinheiro_inserido_anterior;

--	 with dinheiros_iguais select
--			dinheiro_inserido_anterior <= dinheiro_inserido when "0000",
--													dinheiro_inserido_anterior when others;
--													
--													
--	  with dinheiros_iguais select
--			trocou <= '1' when "0000", 
--						'0' when others;

chega_igual: process
	variable dinheiro: std_logic_vector(3 downto 0);
	variable dinheiros_iguaisss : std_logic_vector(3 downto 0);
begin
	wait until clock_50'event and clock_50 = '1';
	dinheiros_iguaisss:= dinheiro_inserido xor dinheiro_inserido_anterior;
	dinheiro := dinheiro_inserido_anterior;
	if(dinheiros_iguaisss /= "0000") then
		trocou <= '1';
		dinheiro := dinheiro_inserido;
	else
		trocou <= '0';
	end if;
	dinheiro_inserido_anterior <= dinheiro;
end process chega_igual;


--	 if dinheiro_inserido /= dinheiro_inserido_anterior then
--			  trocou := 1;
--			  dinheiro_inserido_anterior <= dinheiro_inserido;
--			else
--		     trocou := 0;
--			  --dinheiro_inserido_anterior <= dinheiro_inserido_anterior ; -- dinheiro_inserido;
--			end if;
			
	 

	 --------------------------------------------------------------
	 -----------------recebendo_grana------------------------------
	 --------------------------------------------------------------
	  recebendo_grana: process 
	  
		variable centavos_pago_dec : integer := 0;
		variable centavos_pago_un : integer := 0;
		variable real_pago_dec : integer := 0;
		variable real_pago_un : integer := 0;
		variable coins : std_logic_vector ( 4 downto 0) := "00000"; --sepa da pra usar soh essa variavel pq soh entra em um if memo, ve depois
		variable int_real: integer := 0;
		variable int_centavo: integer := 0;
		variable ta_pago_aux : std_logic := '0';
		
		begin  
			wait until clock_50'event and clock_50 = '1';
			
			if(dinheiro_inserido /= "0000" and key_on /= "000" and estado_maq = pagando and trocou = '1') then --pq qdo começa ele entra no processo e ja seta valores, com esse if ele passa reto
			
			
			saida_pagando4 <= "11010"; --imprime RS e fixa ele
			saida_pagando5 <= "10101";
			

			if   (dinheiro_inserido = "0001") then --5cents
					int_centavo := int_centavo + 5;
					
			elsif(dinheiro_inserido = "0010") then --10cents       --invertii esse eh o 25
					int_centavo := int_centavo + 10;
					
			elsif(dinheiro_inserido = "0011") then --10cents       --invertii esse eh o 25
					int_centavo := int_centavo + 25;
					
			elsif(dinheiro_inserido = "0100") then --50cents
			int_centavo := int_centavo + 50;
			
			elsif(dinheiro_inserido = "0101") then --1real
			int_real := int_real + 1;
			elsif(dinheiro_inserido = "0110") then --2real
			int_real := int_real + 2;
			elsif(dinheiro_inserido = "0111") then --5real
			int_real := int_real + 5;
			elsif(dinheiro_inserido = "1000") then --10real
			int_real := int_real + 10;
			end if;
			
			int_real := int_real + int_centavo/100;
			int_centavo := int_centavo mod 100;
			
			centavos_pago_dec := int_centavo/10;                  --ver se da pra acender o pontinho
			centavos_pago_un := int_centavo mod 10;
			
			real_pago_dec := int_real/10;
			real_pago_un := int_real mod 10;
			
			saida_pagando3 <= std_logic_vector(to_unsigned(real_pago_dec, 5));--se funcionar pode tacar nos bin2dec direto
			saida_pagando2 <= std_logic_vector(to_unsigned(real_pago_un, 5));
			saida_pagando1 <= std_logic_vector(to_unsigned(centavos_pago_dec, 5));
			saida_pagando0 <= std_logic_vector(to_unsigned(centavos_pago_un, 5));

			if (int_real >= to_integer(unsigned(preco_cafe))) then --ja inseriu a grana entao para de imprimir
				ta_pago <= '1';
			else
				ta_pago <= '0';
			end if;

		end if;
		
end process recebendo_grana; 



--------------------------------------------------------------
----------------escolhendo cafe-------------------------------
--------------------------------------------------------------
	  selecionando_cafe: process                                               --fazer a mnema coisa de pegar o opcao cafe antigo igual no dinheiro
			variable escolheu_cafe : std_logic;
	  begin  -- process seq_fsm 
	  
	  wait until clock_50'event and clock_50 = '1';             --tirar essa linha e colocar clock na sens list tira o delay, mas entra no case "000"
	  
	  if(key_on /= "000" and cafe_escolhido_sub = '0' and estado_maq = escolhendo_cafe) then  --se ta apertando alguma tecla e ainda nao escolheu cafe
	  
	  escolheu_cafe := cafe_escolhido_sub;
	  --if(escolheu_cafe = '0') then  se enttrou aqui eh pq escolheu_cafe eh 0 ne
				case opcao_cafe is
					--espresso
					when "001" =>
						cafe_prept <= "0101";
						leit_prept <= "0000";
						choc_prept <= "0000";
						uisk_prept <= "0000";
						preco_cafe <= "0010";
						saida_cafe0 <= "00010";
						saida_cafe1 <= "11111";
						saida_cafe2 <= "10011";
						saida_cafe3 <= "00101";
						saida_cafe4 <= "00101";
						saida_cafe5 <= "10001";
						escolheu_cafe := '1';
					--cappuccino
					when "010" =>
						cafe_prept <= "0101";
						leit_prept <= "1010";
						choc_prept <= "0000";
						uisk_prept <= "0000";
						preco_cafe <= "0100";
						saida_cafe0 <= "00100";
						saida_cafe1 <= "11111";
						saida_cafe2 <= "10011";
						saida_cafe3 <= "10011";
						saida_cafe4 <= "10111";
						saida_cafe5 <= "10101";
						escolheu_cafe := '1';
					--moca
					when "011" =>
						cafe_prept <= "0101";
						leit_prept <= "0101";
						choc_prept <= "0101";
						uisk_prept <= "0000";
						preco_cafe <= "0100";
						saida_cafe0 <= "00100";
						saida_cafe1 <= "11111";
						saida_cafe2 <= "10101";
						saida_cafe3 <= "00000";
						saida_cafe4 <= "11000";
						saida_cafe5 <= "10101";
						escolheu_cafe := '1';
					--irlandes
					when "100" =>
						cafe_prept <= "0101";
						leit_prept <= "0101";
						choc_prept <= "0000";
						uisk_prept <= "0101";
						preco_cafe <= "1000";
						saida_cafe0 <= "01000";
						saida_cafe1 <= "11111";
						saida_cafe2 <= "11000";--H
						saida_cafe3 <= "00101";--S
						saida_cafe4 <= "10100";--R
						saida_cafe5 <= "00001";--I
						escolheu_cafe := '1'; 
					when "000" =>
						if(cafe_escolhido_sub = '0') then
						saida_cafe0 <= "10001";
						saida_cafe1 <= "10010";
						saida_cafe2 <= "10001";
						saida_cafe3 <= "00101";--qdo aperta uma letra nada a v ele entra aqui
						saida_cafe4 <= "11111";
						saida_cafe5 <= "11111";
						
--						cafe_prept <= cafe_prept;
--						leit_prept <= leit_prept;
--						choc_prept <= choc_prept;
--						uisk_prept <= uisk_prept;
--						preco_cafe <= preco_cafe;

						end if;
						escolheu_cafe := '0';
					when "111" =>
							cafe_prept <= "0000";
							leit_prept <= "0000";
							choc_prept <= "0000";
							uisk_prept <= "0000";
							preco_cafe <= "0000";
							saida_cafe0 <= "10001";
							saida_cafe1 <= "11111";
							saida_cafe2 <= "11111";
							saida_cafe3 <= "11111";
							saida_cafe4 <= "11111";
							saida_cafe5 <= "11111";
							escolheu_cafe := '0';
					when others =>
							cafe_prept <= "0101";
						leit_prept <= "0101";
						choc_prept <= "0000";
						uisk_prept <= "0101";
						preco_cafe <= "1000";
						saida_cafe0 <= "01001";
						saida_cafe1 <= "00110";
						saida_cafe2 <= "10100";
						saida_cafe3 <= "00001";
						saida_cafe4 <= "00000";
						saida_cafe5 <= "00000";
						escolheu_cafe := '1'; 
					
					
					
					end case;

		cafe_escolhido <= escolheu_cafe;
		
		
		elsif(key_on = "000" and cafe_escolhido_sub = '0') then
						saida_cafe0 <= "10001"; --choose
						saida_cafe1 <= "00101";
						saida_cafe2 <= "00000";
						saida_cafe3 <= "00000";
						saida_cafe4 <= "11000";
						saida_cafe5 <= "10101";
		
		end if;
end process selecionando_cafe;



-------------------------------------------------------
--making_coffee: process
--	variable making: std_logic_vector(2 downto 0) := "000";
--	variable tempo: integer := 0;
--	variable tempo_vet: std_logic_vector(4 downto 0) := "00000";
--	variable acabou_local: integer := 0;
--
--begin
----		if(rstn = '0') then tempo:= 0; making:="000"; end if;
--		wait until clock_1s'EVENT and clock_1s = '1';
--		if(rstn = '0') then tempo:= 0; making:="000"; end if;
--		
--		if(estado_maq = fazendo_cafe) then 
--			tempo := tempo + 1;
--			--saida_fazendo0 <= "10001";
--			
--			if(making = "000") then --cafe
--				if(tempo /= to_integer(unsigned(cafe_prept)) + 1) then
--					if(cafe_prept /= "0000") then
--						saida_fazendo5 <= "10101";
--						saida_fazendo4 <= "10111";
--						saida_fazendo1 <= std_logic_vector(to_unsigned(tempo/10, 5));
--						saida_fazendo0 <= std_logic_vector(to_unsigned(tempo mod 10, 5));
--					end if;
--				else
--					making := std_logic_vector(to_unsigned(to_integer(unsigned(making))+1, 3));
--					tempo := 0;
--				end if;
--			elsif(making = "001") then --leite
--				if(tempo /= to_integer(unsigned(leit_prept)) + 1) then
--						if(leit_prept /= "0000") then
--							saida_fazendo5 <= "10010";
--							saida_fazendo4 <= "10001";
--							saida_fazendo1 <= std_logic_vector(to_unsigned(tempo/10, 5));
--							saida_fazendo0 <= std_logic_vector(to_unsigned(tempo mod 10, 5));
--						end if;
--					else
--						making := std_logic_vector(to_unsigned(to_integer(unsigned(making))+1, 3));
--						tempo := 0;
--					end if;
--			elsif(making = "010") then --achocolatado
--				if(tempo /= to_integer(unsigned(choc_prept)) + 1) then
--						if(choc_prept /= "0000") then
--							saida_fazendo5 <= "10101";
--							saida_fazendo4 <= "11000";
--							saida_fazendo1 <= std_logic_vector(to_unsigned(tempo/10, 5));
--							saida_fazendo0 <= std_logic_vector(to_unsigned(tempo mod 10, 5));
--						end if;
--					else
--						making := std_logic_vector(to_unsigned(to_integer(unsigned(making))+1, 3));
--						tempo := 0;
--					end if;
--			elsif(making = "011") then --uisk
--				if(tempo /= to_integer(unsigned(uisk_prept)) + 1) then
--						if(uisk_prept /= "0000") then
--							saida_fazendo5 <= "11010";
--							saida_fazendo4 <= "00001";
--							saida_fazendo1 <= std_logic_vector(to_unsigned(tempo/10, 5));
--							saida_fazendo0 <= std_logic_vector(to_unsigned(tempo mod 10, 5));
--						end if;
--					else
--						acabou_local := 1;
--						making := std_logic_vector(to_unsigned(to_integer(unsigned(making))+1, 3));
--						tempo := 0;
--					end if;
--			else
--				saida_fazendo5 <= "11001";
--				saida_fazendo4 <= "00000";
--				saida_fazendo3 <= "11100";
--				saida_fazendo2 <= "10001";
--				saida_fazendo1 <= "11111";
--				saida_fazendo0 <= "11111";
--				
--			end if;
--			
--			acabou <= acabou_local; --------pode voltar ao estado inicial fazerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
--		
--		end if;
--
--end process making_coffee;
---------------------------------------------------------





atualiza_opcao_cafe: process(clock_50, rstn)
	variable mudou : std_logic := '0';
	begin
		if rstn = '0' then
			opcao_cafe <= "111";
		elsif clock_50'event and clock_50 = '1' then
	--else
			--opcao_cafe <= opcao_cafe_aux;
			mudou := not(mudou);
			if(mudou = '0') then
			opcao_cafe <= opcao_cafe_aux; 
			end if;
		end if;
end process atualiza_opcao_cafe;

--------------------------------------------------------
atualiza_dinheiro: process
	variable mudou : std_logic := '0';
	begin
		--if rstn = '0' then 
	--else 
			wait until clock_50'event and clock_50 = '1';
			mudou := not(mudou);
			if(mudou = '0') then
			dinheiro_inserido <= dinheiro_inserido_aux; 
			end if;
		--end if;
end process atualiza_dinheiro;



--------------------------------------------------------
cafe_e_reset <= cafe_escolhido & rstn;



 with (cafe_e_reset) select
		cafe_escolhido_sub <= '1' when "11",
		                       '0' when "01",
									  '0' when "10",
									  '0' when "00";
	
	-----------------------------------------------
	espera3s: process 
	variable tempo: integer range 0 to 20;
	begin
		wait until clock_1s'EVENT and clock_1s = '1';
			tempo := tempo + 1;
			if(mostrar_escolha = '0') then
				tempo := 0;
			end if;
			if(tempo = 4) then
				mostrou_escolha <= '1';
				tempo := 0;
			else
				mostrou_escolha <= '0';
			end if;
	end process espera3s;
  
  -------------------------------------------------
	  seq_fsm: process (CLOCK_50, rstn)
	  begin
		 if rstn = '0' then
			estado_maq <= escolhendo_cafe;
		 elsif CLOCK_50'event and CLOCK_50 = '1' then
			estado_maq <= proximo_estado;
		 end if;
	  end process seq_fsm;

	 ------------------------------------------------ 
	  build_rstn: process (CLOCK_50)
		 variable temp : std_logic;
	  begin
		 if CLOCK_50'event and CLOCK_50 = '1' then
			rstn <= temp;
			temp := KEY(0);
		 end if;
	  end process build_rstn;

end fulltrab;

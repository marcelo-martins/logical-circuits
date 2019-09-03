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
USE ieee.std_logic_1164.ALL;

ENTITY UC IS 
		PORT (
			--io
		);
END ENTITY;

architecture fulltrab of UC is

------------------------------------
------------COMPONENTES-------------
------------------------------------
component kbd_alphanum_board is
  port (
	 CLOCK_50 : in std_logic;
    PS2_DAT : inout STD_LOGIC;
    PS2_CLK : inout STD_LOGIC; 
	 dinheiro_inserido : out std_logic_vector(7 downto 0);
	 opcao_cafe: out std_logic_vector(2 downto 0);
  );
end component;

component register_bank is
  port (
    clk : in std_logic;
    data_in : in std_logic_vector(3 downto 0);    --3 0
    reg_rd : in std_logic_vector(2 downto 0); ---6 4
    reg_wr : in std_logic_vector(2 downto 0);  --9 7
    we : in std_logic;
	 saida_hex: out std_logic_vector(6 downto 0);
    clear : in std_logic
  );
end component;

--ESTADOS DA MAQUINA DE CAFFERSON
type estado_maq is (escolhendo_cafe, pagando, troco, fazendo_cafe);

--TEMPOS DE PREPARO
signal cafe_prept: std_logic_vector(3 downto 0);
signal leit_prept: std_logic_vector(3 downto 0);
signal choc_prept: std_logic_vector(3 downto 0);
signal uisk_prept: std_logic_vector(3 downto 0);


signal cafe_escolhido: std_logic;
signal cafe_pago: std_logic;

signal dinheiro_inserido: std_logic_vector(7 downto 0);
signal opcao_cafe: std_logic_vector(2 downto 0);

--bagulhos da caixa registradora
signal reais_total: std_logic_vector(3 downto 0);
signal centavos_total: std_logic_vector(6 downto 0);
signal quantidade_nota: std_logic_vector(6 downto 0);
signal reg_rd: std_logic_vector(2 downto 0);
signal reg_wr: std_logic_vector(2 downto 0);
signal we: std_logic;
signal clear_caixa: std_logic;

begin
   --PORT MAPS
	--TECLADO
	 kbd_inst: kbd_alphanum_board port map(
		 CLOCK_50 => CLOCK_50,
		 PS2_DAT => PS2_DAT,
		 PS2_CLK => PS2_CLK,
		 dinheiro_inserido => dinheiro_inserido,
		 opcao_cafe: => opcao_cafe
	 );
	 
	 --CAIXA REGISTRADORA
	 caixa_registradora: register_bank port map(
		clk => CLOCK_50,
		data_in => dinheiro_recebido,
		reg_rd => reg_rd,
		reg_wr => reg_wr,
		we => we,
		saida_hex: => quantidade_nota,
		clear => clear_caixa
	);
	 
	 
	 
	 ----------------------------------------------------
	 -----------------maquina de estado------------------
	 ----------------------------------------------------
	 maquina_cafe: process(estado)
	 begin 
		case estado_maq is
			when escolhendo_cafe =>  
							if(cafe_escolhido = '1') 
								proximo_estado <= pagando;
								cafe_escolhido <= '0';
							end if;
				
			when pagando =>
							if(cafe_pago = '1') 
								proximo_estado <= troco;
								cafe_pago <= '0';
							end if;
			
			
			when troco =>
			
			
			
			when fazendo_cafe =>
			
			
			
			when others =>
			
			
			
	 
	 end process;
	 
	   recebendo_grana: process(dinheiro_recebido, CLOCK_50) 
			if(dinheiro_recebido = "00000001") then
				
			
			end if;
	   begin
	  
	  
	  end process;
	 
	  selecionando_cafe: process (opcao_cafe, CLOCK_50)
	  begin  -- process seq_fsm
		 if(opcao_cafe /= "000") then
				case opcao_cafe
					--espresso
					when "001" => 
						cafe_prept <= "0101";
						leit_prept <= "0000";
						choc_prept <= "0000";
						uisk_prept <= "0000";
					--cappuccino
					when "010" => 
						cafe_prept <= "0101";
						leit_prept <= "1010";
						choc_prept <= "0000";
						uisk_prept <= "0000";
					--moca
					when "011" => 
						cafe_prept <= "0101";
						leit_prept <= "0101";
						choc_prept <= "0101";
						uisk_prept <= "0000";
					--irlandes
					when "100" => 
						cafe_prept <= "0101";
						leit_prept <= "0101";
						choc_prept <= "0000";
						uisk_prept <= "0101"; 
				cafe_escolhido <='1';
		 else 
				cafe_escolhido <='0';
		 end if;
	  end process selecionando_cafe;
	  
	  
	 
	  -- purpose: Avança a FSM para o próximo estado
	  -- type   : sequential
	  -- inputs : CLOCK_50, rstn, proximo_estado
	  -- outputs: estado
	  seq_fsm: process (CLOCK_50, rstn)
	  begin  -- process seq_fsm
		 if rstn = '0' then                  -- asynchronous reset (active low)
			estado <= escolhendo_cafe;
		 elsif CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
			estado <= proximo_estado;
		 end if;
	  end process seq_fsm;
	  
	  -- purpose: Aqui sincronizamos nosso sinal de reset vindo do botão da DE1
	  -- type   : sequential
	  -- inputs : CLOCK_50
	  -- outputs: rstn
	  build_rstn: process (CLOCK_50)
		 variable temp : std_logic;          -- flipflop intermediario
	  begin  -- process build_rstn
		 if CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
			rstn <= temp;
			temp := KEY(0);      
		 end if;
	  end process build_rstn;
			 
end fulltrab;
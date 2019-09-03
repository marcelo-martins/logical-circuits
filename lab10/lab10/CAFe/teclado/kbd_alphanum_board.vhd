library ieee;
use ieee.std_logic_1164.all;

entity kbd_alphanum_board is
  port (
    CLOCK_50 : in std_logic;
    PS2_DAT : inout STD_LOGIC;
    PS2_CLK : inout STD_LOGIC; 
	 dinheiro_inserido : out std_logic_vector(7 downto 0);
	 opcao_cafe: out std_logic_vector(2 downto 0);
  );
end kbd_alphanum_board;

architecture rtl of kbd_alphanum_board is
  component teclado is
    port (
		 clk : in std_logic;
		 key_on : in std_logic_vector(2 downto 0);
		 key_code : in std_logic_vector(47 downto 0); 
		 dinheiro_inserido: out std_logic_vector(7 downto 0);
		 opcao_cafe: out std_logic_vector(2 downto 0);
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
  
  signal key_on : std_logic_vector(2 downto 0);
  signal key_code : std_logic_vector(47 downto 0);
begin

  kbdex_ctrl_inst : kbdex_ctrl
    generic map (
      clkfreq => 50000
    )
    port map (
      ps2_data => PS2_DAT,
      ps2_clk => PS2_CLK,
      clk => CLOCK_50,
      en => '1',
      resetn => '1',
      lights => "000",
      key_on => key_on,
      key_code => key_code
    );
	 
	
--------------------------------------------------------
--MUDAR AS ENTRADAS E SAIDAS DO TECLADO AQUIE EM CIMA---
--------------------------------------------------------
    teclado_inst : teclado
    port map (
      clk => CLOCK_50,
      key_on => key_on,
      key_code => key_code,
		dinheiro_inserido => dinheiro_inserido,
		opcao_cafe => opcao_cafe
    );

end rtl;
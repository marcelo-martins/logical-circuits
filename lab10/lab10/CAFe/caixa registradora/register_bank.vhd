library ieee;
use ieee.std_logic_1164.all;

entity register_bank is
  port (
    clk : in std_logic;
    data_in : in std_logic_vector(3 downto 0);    --3 0
    reg_rd : in std_logic_vector(2 downto 0); ---6 4
    reg_wr : in std_logic_vector(2 downto 0);  --9 7
    we : in std_logic;
	 data_out: out std_logic_vector(3 downto 0);
	 
	 
	 --tinah um de visor de 7 seg aqui
    clear : in std_logic
  );
end register_bank;

architecture structural of register_bank is

component reg
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
end component;


component dec3_to_8
	port ( x : in STD_LOGIC_VECTOR (2 downto 0);
		y : out STD_LOGIC_VECTOR (7 downto 0)
	);
end component;

component zbuffer
	generic(N : INTEGER :=4);
    Port ( x : in  STD_LOGIC_VECTOR (N-1 downto 0);
           e : in  STD_LOGIC;
           f : out STD_LOGIC_VECTOR (N-1 downto 0)
	 );
end component;

component bin2hex 
	port (
		SW: in std_logic_vector(3 downto 0);
		HEX0: out std_logic_vector(6 downto 0)
	);
end component;

signal decbuffer_in: std_logic_vector(7 downto 0);
signal decbuffer_out: std_logic_vector(7 downto 0);
signal tmp_tri_state_x: std_logic_vector(31 downto 0);

signal data_out: std_logic_vector(3 downto 0);




begin

		dec3_to_8_entrada: dec3_to_8 port map(reg_rd, decbuffer_in);
		dec3_to_8_saida:   dec3_to_8 port map(reg_wr, decbuffer_out);
		g1: for i in 7 downto 0 generate
			regs: reg port map(not(clk), data_in, tmp_tri_state_x((4*i + 3) downto 4*i), (not(we) and decbuffer_in(i)), (not(clear) AND decbuffer_in(i)));
			--os not ai em cima eh pq a logica dos KEY eh invertida. We and buffer eh pra ver se o load ta setado, not clear and buffer eh pra dar clear apenas em um reg por vez
			tri_state: zbuffer port map(tmp_tri_state_x((4*i + 3) downto 4*i), decbuffer_out(i), data_out);
		end generate;
		
		bin2hex_1: bin2hex port map(data_out, saida_hex);
	
end structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity cascadare is
   Port ( START_STOP : in STD_LOGIC;
           M : in STD_LOGIC;
           S : in STD_LOGIC;
           CLK : in STD_LOGIC;
           alarma: out std_logic;
           CATOZI : out STD_LOGIC_VECTOR (6 downto 0);
           ANOZI :out STD_LOGIC_VECTOR (3 downto 0));
end cascadare;

architecture Behavioral of cascadare is	
component or_3 is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           C : in STD_LOGIC;
           Y : out STD_LOGIC);
end component;
component  numarator_min is
    Port ( clk : in STD_LOGIC;
	      rst : in STD_LOGIC;	
	      en: in std_logic;
	      ld:in std_logic;
          c_up : in STD_LOGIC;	
		  c_down: in std_logic;		   
		  borrow:out std_logic;
		  carry:out std_logic;
          minute : out STD_LOGIC_VECTOR (7 downto 0)
       );
end component;		
component numarator_sec is
  Port ( clk : in STD_LOGIC;
	      rst : in STD_LOGIC;	
	      en: in std_logic;
	      ok:in std_logic;
	       ld:in std_logic;
          c_up : in STD_LOGIC;	
		  c_down: in std_logic;			  
		  borrow:out std_logic;
		  carry:out std_logic;
           secunde : out STD_LOGIC_VECTOR (7 downto 0)
       );
end component;

component butoane is
	port(clk, buton1: in std_logic;
	buton2: out std_logic);
end component;

component divfrecv is
	port(CLK, Reset: in std_logic;
	clk_divizat: out std_logic);	
end component;

component clock_enable_debouncing_button is
port(
 clk: in std_logic;
 slow_clk_enable: out std_logic
);
end component;
component activare_anozi is
Port( clk: in std_logic;
     Secunde_unitati:in std_logic_vector(3 downto 0);
     Secunde_zeci: in std_logic_vector(3 downto 0);
     Minute_unitati :in std_logic_vector(3 downto 0);
     Minute_zeci: in std_logic_vector(3 downto 0);
     Catozi: out std_logic_vector(6 downto 0);
     Anozi:out std_logic_vector(3 downto 0)
    );
end component;

component binar8_zecimal_binar4 is
  Port( vector: in std_logic_vector(7 downto 0);
        zeci: out std_logic_vector(3 downto 0);
        unitati: out std_logic_vector(3 downto 0)
        ); 
end component;

signal enable1,enable2,enable,rst,c_up,c_down,borrow1,borrow2,carry1,carry2,lds,ldm,en,S_b,M_b,clk_2:std_logic:='0';
signal MINUTE,SECUNDE: std_logic_vector(7 downto 0):="00000000";
signal minute_unitati,minute_zeci,secunde_unitati,secunde_zeci: std_logic_vector(3 downto 0):="0000";

begin
DIV: divfrecv port map(clk,rst,clk_2);
S1: numarator_sec port map(clk_2,rst,enable1,borrow2,lds,c_up,c_down,borrow1,carry1,SECUNDE);
M1: numarator_min port map(clk_2,rst,enable,ldm,c_up,c_down,borrow2,carry2,MINUTE);	
S3: or_3 port map (enable2,borrow1,carry1,enable);
S2: butoane port map(clk,M,M_b);
M2: butoane port map (clk,S,S_b);

T1: binar8_zecimal_binar4 port map(MINUTE,minute_zeci,minute_unitati);
T2: binar8_zecimal_binar4 port map(SECUNDE, secunde_zeci,secunde_unitati);
AN: activare_anozi port map (clk,secunde_unitati,secunde_zeci,minute_unitati,minute_zeci,CATOZI,ANOZI);
alarma<=borrow2 and borrow1;

process(M_b,S_b,c_up,c_down,lds,ldm,enable1,enable2,START_STOP)
begin

     if(M_b='1' and S_b='1')then
            rst<='1';
            c_up<='1'; c_down<='0';
            enable1<='1';enable2<='0';
            lds<='0';ldm<='0';
    
      elsif(M_b='1' and S_b='0') then
             rst<='0';
            if(START_STOP='1')then 
                enable1<='1';enable2<='0';
                c_down<='1';c_up<='0';
                lds<='0';ldm<='0';
             elsif(START_STOP='0')then
                ldm<='1';lds<='0';
                enable1<='0'; enable2<='1';
                c_up<='1'; c_down<='0';
              end if;
    
      elsif(M_b='0' and S_b='1') then
       rst<='0';
            if(START_STOP='1')then 
                enable1<='1';enable2<='0';
                c_down<='1';c_up<='0';
                lds<='0';ldm<='0';
             elsif(START_STOP='0')then
                ldm<='0';lds<='1';
                enable1<='1'; enable2<='0';
                c_up<='1'; c_down<='0';
              end if;
    
        elsif(M_b='0' and S_b='0') then
         rst<='0';
            if(START_STOP='1')then 
                enable1<='1';enable2<='0';
                c_down<='0';c_up<='1';
                lds<='0';ldm<='0';
             elsif(START_STOP='0')then
                ldm<='0';lds<='0';
                enable1<='0'; enable2<='0';
                c_up<='1'; c_down<='0';
              end if;
      end  if;
      end process; 
end Behavioral;

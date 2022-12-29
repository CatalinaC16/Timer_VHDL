library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity activare_anozi is
Port( clk: in std_logic;
     Secunde_unitati:in std_logic_vector(3 downto 0);
     Secunde_zeci: in std_logic_vector(3 downto 0);
     Minute_unitati :in std_logic_vector(3 downto 0);
     Minute_zeci: in std_logic_vector(3 downto 0);
     Catozi: out std_logic_vector(6 downto 0);
     Anozi:out std_logic_vector(3 downto 0)
    );
end activare_anozi;

architecture Behavioral of activare_anozi is

component bcd_7segment is
Port ( vector: in STD_LOGIC_VECTOR (3 downto 0);
        Seven_Segment : out STD_LOGIC_VECTOR (6 downto 0)
     );
end component;

signal Cnt: std_logic_vector(15 downto 0):=(others => '0');
signal temp: std_logic_vector(3 downto 0);
begin
process(clk)  
	begin
		if(rising_edge(clk)) then
			if(Cnt="1111111111111111") then
				Cnt<=(others => '0');
			else
				Cnt<=Cnt+1;
			end if;
		end if;
	end process;
temp <=
    Secunde_unitati when Cnt(15 downto 14)="00" else
	Secunde_zeci when Cnt(15 downto 14)="01" else
	Minute_unitati when Cnt(15 downto 14)="10" else
	Minute_zeci when Cnt(15 downto 14)="11";
	
Anozi<=
    "1110" when Cnt(15 downto 14)="00" else
	"1101" when Cnt(15 downto 14)="01" else
	"1011" when Cnt(15 downto 14)="10" else
	"0111" when Cnt(15 downto 14)="11";
	
F1: bcd_7segment port map(temp,Catozi);
end Behavioral;

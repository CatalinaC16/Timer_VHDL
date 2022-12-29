library IEEE;
use IEEE.std_logic_1164.all;

entity divfrecv is
	port(CLK, Reset: in std_logic;
	clk_divizat: out std_logic);	
end divfrecv;

architecture Comportamental of divfrecv is 
signal count: integer:=0; 
signal temp: std_logic; 
begin
	process(CLK, Reset)
	begin
		if (Reset='1') then 
			temp<='0';
			count<=1;
		elsif(rising_edge(CLK)) then 
             if (count=49999999) then 
				temp<=NOT(temp);
				count<=1; 
			else
				count<=count+1; 
			end if;
		end if;	
	end process;
	clk_divizat<=temp;
end Comportamental;

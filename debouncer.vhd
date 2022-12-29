library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity butoane is
	port(clk, buton1: in std_logic;
	buton2: out std_logic);
end entity;

architecture Debouncer of butoane is 
signal  Q1, Q0: std_logic;
begin 
	process(CLK)
	begin
		if rising_edge(CLK) then
			Q1<=buton1;
			Q0<=Q1;
		end if;
	end process; 
	buton2<=Q1 and Q0 ;
	

end Debouncer;

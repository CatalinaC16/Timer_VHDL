library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.numeric_std.ALL;

entity numarator_sec is
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
end numarator_sec;		
	   
architecture Behavioral of numarator_sec is
signal temp_sec :std_logic_vector(7 downto 0);
signal br:std_logic;

begin
process(clk,rst,c_up,c_down,en,ld)
variable sec:std_logic_vector(7 downto 0):=(others=>'0');
begin
if(rst='1') then 
    sec:="00000000";
else 
	if(en='0' and ld='1')then
	  if(sec="00111011") then
	 sec:="00000000";
	  else sec:=sec+1;
	  end if;
	elsif(en='0' and ld='0') then sec:=sec;
	else
	if(rising_edge(clk) )then 
	 if c_up='1' then
		if(sec="00111011") then
	 sec:="00000000";
	    else 
	      sec:=sec+1;
	  end if;
	 elsif c_down='1' then 
		  if(sec="00000000" and ok='0') then
		 sec:="00111011";
		  elsif(br='1' and ok='1')then
		  sec:=sec;
		  else 
		   sec:=sec-1;
		  end if; 
	end if;	
end if;	
end if;
end if;
secunde<=sec;
temp_sec<=sec;
end process;


process(temp_sec,c_up)
begin

	if(temp_sec="00111011" and c_up='1')	 THEN
		CARRY<='1';
	ELSE CARRY<='0';
  END IF;
 end process; 
 
 process(temp_sec,c_down)
begin
	if(temp_sec="00000000" and c_down='1')	 THEN
		borrow<='1';br<='1';
	ELSE borrow<='0';br<='0';
  END IF;
 end process;
end Behavioral;
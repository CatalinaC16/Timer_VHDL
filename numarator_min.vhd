library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.numeric_std.ALL;

entity numarator_min is
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
end numarator_min;		
	   
architecture Behavioral of numarator_min is
signal temp_min :std_logic_vector(7 downto 0);

begin
process(clk,rst,c_up,c_down,ld,en)
variable min:std_logic_vector(7 downto 0):=(others=>'0');
begin
if(rst='1') then 
    min:="00000000"; 
else 
	if(en='0'and ld='1')then min:=min+1;
	elsif(en='0' and ld='0') then min:=min;
	else
	if(rising_edge(clk) )then 
	 if c_up='1' then
		if(min="01100011") then
	 min:="00000000";
	  else 
	  min:=min+1;
	  end if;
	 elsif c_down='1' then 
		  if(min="00000000") then
		 min:="00000000";
		  else 
		  min:=min-1;
		  end if; 
	end if;	
end if;	
end if;
end if;
minute<=min;
temp_min<=min;
end process;

process(temp_min,c_up)
begin
	if(temp_min="00111011" and c_up='1')	 THEN
		CARRY<='1';
	ELSE CARRY<='0';
  END IF;
 end process; 
 
 process(temp_min,c_down)
begin
	if(temp_min="00000000" and c_down='1')	 THEN
		borrow<='1';
	ELSE borrow<='0';
  END IF;
 end process;
end Behavioral;
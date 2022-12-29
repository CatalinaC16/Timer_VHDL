library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

entity binar8_zecimal_binar4 is
  Port( vector: in std_logic_vector(7 downto 0);
        zeci: out std_logic_vector(3 downto 0);
        unitati: out std_logic_vector(3 downto 0)
        ); 
end binar8_zecimal_binar4;

architecture Behavioral of binar8_zecimal_binar4 is
signal vect_intreg,vu,vz:integer;
signal vect:std_logic_vector(7 downto 0);
begin
vect<=vector;
vect_intreg<=to_integer(unsigned(vect));
vu<= vect_intreg mod 10;
vz<= vect_intreg / 10;
unitati(3 downto 0)<=std_logic_vector(to_unsigned(vu,4));
zeci(3 downto 0)<=std_logic_vector(to_unsigned(vz,4));
end Behavioral;

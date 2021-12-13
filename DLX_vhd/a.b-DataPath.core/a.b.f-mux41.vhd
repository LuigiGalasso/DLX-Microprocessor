library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity Mux41 is
	port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);
  c : in std_logic_vector(31 downto 0);
		d : in std_logic_vector(31 downto 0);
		sel:in std_logic_vector(1 downto 0);
		y : out std_logic_vector(31 downto 0)
		);
end Mux41;

architecture Behavioral of Mux41 is

begin
	process(a,b,c,d,sel)
	begin
 case sel is
		when "00" 	=>y<=a ;
  when "01" 	=>y<=b ;
  when "10" 	=>y<=c ;
  when "11" 	=>y<=d ;
  when others=>y<=d;
  end case;
	end process;
end Behavioral;

configuration CFG_Mux41 of Mux41 is
  for Behavioral
  end for;
end CFG_Mux41;

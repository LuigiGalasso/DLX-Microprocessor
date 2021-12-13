library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
--general generate---
entity G is 
	Port (	p1:	In	std_logic;
		g1:	In	std_logic;
		g2:	In	std_logic;
		g_Out:	out	std_logic);
end G;

architecture BEHAVIORAL of G is
begin
	g_Out <= g1 or (p1 and g2); --g2 is the one on the right in schematic view

end architecture BEHAVIORAL;


configuration CFG_G of G is
  for behavioral
  end for;
end CFG_g;

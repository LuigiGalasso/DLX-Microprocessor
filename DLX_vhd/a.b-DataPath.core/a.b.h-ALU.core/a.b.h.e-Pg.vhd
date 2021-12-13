library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
--general generate and propagate---
entity PG is 
	Port (	p1:	In	std_logic;
		g1:	In	std_logic;
		p2:	In	std_logic;
		g2:	In	std_logic;
		p_Out:	out	std_logic;
		g_Out:	out	std_logic);
end PG;

architecture BEHAVIORAL of PG is
begin
	p_Out <= p1 and p2; --p2 is the one on the right in schematic view
	g_Out <= g1 or (p1 and g2); 

end architecture BEHAVIORAL;
 


configuration CFG_PG of PG is
  for behavioral
  end for;
end CFG_PG;

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
--simple Pg network---
entity PGnet is
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		p:	out	std_logic;
		g:	Out	std_logic);
end PGnet;
--standard propagate and generate----
architecture BEHAVIORAL of PGnet is
begin
	p <= A xor B;
	g <= A and B; 

end architecture BEHAVIORAL;
 



configuration CFG_PGnet of PGnet is
  for behavioral
  end for;
end CFG_PGnet;

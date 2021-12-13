library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

--carry select adder --
entity  CSA is
generic(n_bit: integer := 32);
	Port(A :In      std_logic_vector(n_bit-1 downto 0);
	     B :In	std_logic_vector(n_bit-1 downto 0);
	     c :In      std_logic_vector((n_bit/4 - 1) downto 0);		
	     s :out 	std_logic_vector(n_bit-1 downto 0));
end CSA;

architecture STRUCTURAL of CSA is
	component  CSb
	Port(A 	 :In    std_logic_vector(3 downto 0);
	     B 	 :In	std_logic_vector(3 downto 0);
	     ci  :In    std_logic;		
	     s   :out   std_logic_vector(3 downto 0));
	end component;

begin

	porta : for i in 0 to ((n_bit/4) - 1) generate 
		CSbi:CSb
		Port Map(A((3 + 4*I) downto (4*I)),B((3 + 4*I) downto (4*I)),c(I),S((3 + 4*I) downto (4*I)));
end generate;

end STRUCTURAL;

configuration CFG_CSA of CSA is
  for Structural 
  end for;
end CFG_CSA;

configuration CFG_CSA of CSA is
  for STRUCTURAL 
	for porta
      		for all  : CSb
        	use configuration WORK.CFG_CSb_Structural;
		end for;
      	end for;
  end for;
end CFG_CSA;




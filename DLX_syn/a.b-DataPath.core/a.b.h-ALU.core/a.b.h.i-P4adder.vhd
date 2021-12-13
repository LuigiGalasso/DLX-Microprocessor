library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;


entity  P4ADDER is
	generic(n_bit: integer := 32);

	Port(A :In      std_logic_vector(n_bit-1 downto 0);
	     B :In						std_logic_vector(n_bit-1 downto 0);	
      cin0: In    std_logic;
	     S :out     std_logic_vector(n_bit-1 downto 0));	
end P4ADDER;


architecture STRUCTURAL of P4ADDER is

signal Ci: std_logic_vector ((n_bit/4 - 1) downto 0);	--Internal carry 
signal carries: std_logic_vector ((n_bit/4 -1)downto 0) ;
signal BS:std_logic_vector (n_bit -1 downto 0);

component Cg
Port(A :In      std_logic_vector(n_bit-1 downto 0);
	    B :In	     std_logic_vector(n_bit-1 downto 0);	
					cin0: In   std_logic;
	    cout :out    std_logic_vector((n_bit/4) -1 downto 0));	
end component;


	component  CSA
	Port(A :In      std_logic_vector(n_bit-1 downto 0);
	     B :In						std_logic_vector(n_bit-1 downto 0);
	     c :In      std_logic_vector((n_bit/4 -1) downto 0);		
	     s :out 				std_logic_vector(n_bit-1 downto 0));
	end component;
begin
--carries from the sparse tree to the carry save adder---
carries<= Ci((n_bit/4 -2)downto 0) & cin0;
--if cin0 is 1 do a subtraction so found the right second operand
sub:for i in 0 to n_bit-1 generate
BS(i)<=B(i) xor cin0;
end generate;
	CG1 : Cg--sparse tree carry generate
	Port Map (A,BS,cin0,Ci);

	CSA1 : CSA--carry save adder
	Port Map (A,BS,carries,S);


end STRUCTURAL;

configuration CFG_P4ADDER of P4ADDER is
  for STRUCTURAL
  end for;
end CFG_P4ADDER;

configuration CFG_P4ADDER of P4ADDER is
  for STRUCTURAL 	
	for all: Cg
 	     use configuration WORK.CFG_CG;
       end for;		
      for all : CSA
        use configuration WORK.CFG_CSA;
      end for;		
  end for;
end CFG_P4ADDER;



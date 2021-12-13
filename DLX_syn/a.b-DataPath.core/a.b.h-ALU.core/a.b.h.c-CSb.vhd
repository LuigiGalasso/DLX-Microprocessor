library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;


entity  CSb is
	Port(A :In      std_logic_vector(3 downto 0);
	     B :In	std_logic_vector(3 downto 0);
	     ci :In       std_logic;		
	     s :out std_logic_vector(3 downto 0));
end CSb;

architecture STRUCTURAL of CSb is
signal out0,out1 : std_logic_vector(3 downto 0);
component rca 
	Port (	A:	In	std_logic_vector(3 downto 0);
		B:	In	std_logic_vector(3 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(3 downto 0);
		Co:     Out	std_logic);
end component;

begin
 
	RCA0: RCA
	port map(
		 A => A,
		 B => B,
		 Ci => '0',
		 S => out0);
	RCA1: RCA
	port map(
		 A => A,
		 B => B,
		 Ci => '1',
		 S => out1);

process(out0,out1,ci)
	begin
		if Ci ='0' then s<=out0;
		else  		 s<=out1;
		end if;
	end process;

end STRUCTURAL;



configuration CFG_CSb_STRUCTURAL of CSb is
  for STRUCTURAL 
      for RCA1 : RCA
        use configuration WORK.CFG_RCA_Structural;
      end for;
      for RCA0 : RCA
        use configuration WORK.CFG_RCA_Structural;
      end for;
  end for;
end CFG_CSb_STRUCTURAL;

configuration CFG_CSb_STRUCTURAL of CSb is
	for STRUCTURAL
	end for;
end CFG_CSb_STRUCTURAL;





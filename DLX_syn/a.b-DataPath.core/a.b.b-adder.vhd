library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;


entity Adder is
	 port ( 
		A: in std_logic_vector(31 downto 0); 
		B: in std_logic_vector(31 downto 0); 
     reset:in std_logic;
		Cin: in std_logic; 
		O: out std_logic_vector(31 downto 0); 
		Cout: out std_logic 
	);
end Adder;

architecture Behavioral of Adder is

begin
	process(A,B,Cin,reset)
		 variable sum: integer;
		 variable sum_vector: std_logic_vector(32 downto 0); 
	begin
   if(reset = '0') then
		sum := conv_integer(A) + conv_integer(B) + conv_integer(Cin) ;
		sum_vector := conv_std_logic_vector(sum, 33);
		O <= sum_vector(31 downto 0);
		Cout <= sum_vector(32);
  else
   sum := 0 ;
		sum_vector := conv_std_logic_vector(sum, 33);
		O <= sum_vector(31 downto 0);
		Cout <= sum_vector(32);
   end if;

	end process;

end Behavioral;

configuration CFG_Adder of Adder is
  for Behavioral
  end for;
end CFG_Adder;


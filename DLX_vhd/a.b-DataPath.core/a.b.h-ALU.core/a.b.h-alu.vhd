library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.globals.all;

entity ALU is
  generic (constant M   : integer := WordSize;	
											constant C : integer := ALUOP_SIZE);
  port 	 ( CODE: IN std_logic_vector(C-1 downto 0);
           DATA1, DATA2: IN std_logic_vector(M-1 downto 0);
           OUTALU: OUT std_logic_vector(M-1 downto 0));
end ALU;

architecture structural of ALU is


component SHIFTER is
	generic(M: integer:= 32;
									N: integer:= 5);
	port(	A: in std_logic_vector(M-1 downto 0);
							B: in std_logic_vector(M-1 downto 0);
							LEFT_RIGHT: in std_logic;	-- 1 = left, 0 = right
							OUTPUT: out std_logic_vector(M-1 downto 0)
	);
end component;

component COMPARATOR is
	generic(M: integer:= 32);
	port(	A: in std_logic_vector(M-1 downto 0);
							B: in std_logic_vector(M-1 downto 0);
							sel: in std_logic_vector(1 downto 0);
							OUTPUT: out std_logic_vector(M-1 downto 0)
	);

end component;

component P4ADDER is
	generic(n_bit: integer := 32);

	Port(A :In      std_logic_vector(n_bit-1 downto 0);
	     B :In						std_logic_vector(n_bit-1 downto 0);	
      cin0: In   std_logic;
	     S :out     std_logic_vector(n_bit-1 downto 0));	
end component;

signal SHIFTERout       :std_logic_vector(31 downto 0);
signal ADDERout        :std_logic_vector(31 downto 0);
signal COMPARATORout    :std_logic_vector(31 downto 0);


signal SHIFTdirection   :std_logic;
signal CarryIn          :std_logic;
signal Comparison       :std_logic_vector(1 downto 0);  
 
begin
--some simple logic function are used to obtain the correct operations 
CarryIn<= NOT CODE(0);
SHIFTdirection<=CODE(0);


Comparison(1)<=(CODE(0) OR CODE(1));
Comparison(0)<=(NOT CODE(1));

--3 main components---
SHIFTOP:  SHIFTER Port Map(DATA1,DATA2,SHIFTdirection,SHIFTERout);
ADDSUBOP: P4ADDER Port Map(DATA1,DATA2,CarryIn,ADDERout);
COMPOP:COMPARATOR Port Map(DATA1,DATA2,Comparison,COMPARATORout);



  P_ALU: process (CODE,DATA1,DATA2,SHIFTERout,ADDERout,COMPARATORout)
  begin
  case conv_integer(CODE) is
		when 1 	=> OUTALU<=SHIFTERout;
		when 2 	=> OUTALU<=SHIFTERout;
 	when 3 	=> OUTALU<=ADDERout;
 	when 4	 => OUTALU<=ADDERout;
		when 5 	=> OUTALU <= (DATA1 AND DATA2); 
		when 6	 => OUTALU <= (DATA1 OR DATA2);
		when 7 	=> OUTALU <= (DATA1 XOR DATA2);
		when 8 	=> OUTALU<=COMPARATORout;
		when 9 	=> OUTALU<=COMPARATORout;
		when 10 => OUTALU<=COMPARATORout;  

		when others => OUTALU<=(others =>'0');
  end case; 
  end process P_ALU;




end structural;

configuration CFG_ALU_STRUCTURAL of ALU is
  for STRUCTURAL
  end for;
end CFG_ALU_STRUCTURAL;

configuration CFG_ALU_STRUCTURAL of ALU is
  for STRUCTURAL 	
	     for all: SHIFTER
 	     use configuration WORK.CFG_SHIFTER;
      end for;		
      for all : COMPARATOR
        use configuration WORK.CFG_COMPARATOR;
      end for;	
      for all: P4ADDER
 	     use configuration WORK.CFG_P4ADDER;
      end for;		 	
  end for;
end CFG_ALU_STRUCTURAL;
 	



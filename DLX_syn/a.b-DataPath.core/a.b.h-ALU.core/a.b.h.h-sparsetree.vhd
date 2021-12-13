library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.all;
USE ieee.math_real.all;


entity  Cg is
	generic (n_bit: integer := 32;
										N_carry: integer :=8);
		 							

Port(A :In      std_logic_vector(n_bit-1 downto 0);
	    B :In	     std_logic_vector(n_bit-1 downto 0);	
					cin0: In   std_logic;--carry in 
	    cout :out     std_logic_vector((N_carry -1) downto 0));	--carry out
end Cg;

architecture STRUCTURAL of Cg is

component PGnet is
		Port (	A:	In	std_logic;
			B:	In	std_logic;
			p:	out	std_logic;
			g:	Out	std_logic);
	end component PGnet;

component G is 
		Port (	p1:	In	std_logic;
			g1:	In	std_logic;
			g2:	In	std_logic;
			g_Out:	out	std_logic);
	end component G;

component PG is 
		Port (	p1:	In	std_logic;
			g1:	In	std_logic;
			p2:	In	std_logic;
			g2:	In	std_logic;
			p_Out:	out	std_logic;
			g_Out:	out	std_logic);
	end component PG;

constant rows : integer := 6;
signal p0,g0 : std_logic;

--psignal and gsignal are signalMatrix
type SignalM is array (rows-1 downto 0) of std_logic_vector(n_bit-1 downto 0);
	signal psignal: SignalM;
	signal gsignal: SignalM;



	begin
--PG network---
p0 <= (A(0) xor B(0));--standard propagate
g0 <= (A(0) and B(0));--standard generate

	PG_network: for i in n_bit-1 downto 0 generate
	begin
		PG_Net_others: if (i > 0) generate
			PGN1: PGnet 
				port map( A => A(i), B => B(i), p => psignal(0)(i) , g => gsignal(0)(i));
		end generate PG_Net_others;	

		PG_Net_0: if (i = 0) generate
			PGN0: G --for i=0 only G will be used(exeption of PG network)
				port map( p1 => p0, g1 => g0, g2 => Cin0, g_Out => gsignal(0)(i));
		end generate PG_Net_0;
	end generate PG_Network;

-------------------------first half of the sparse tree: from the line 1 to 3------------------------------------------------
--the organization of blocks follows the 32 bits sparse tree solution-----
first: for i in 0 to rows/2 -1  generate
							elements:for j in 1 to  n_bit-1  generate
																												 firstG:if((j+1) = 2**(i+1)) generate--first block of each row has to be a G block
																																			g0:	G	port map	(									P1	 	=> pSignal(i)(j),
																																																												G1 		=> gSignal(i)(j),
																																																												G2 		=> gSignal(i)(j-2**i),
																																																												G_out 		=> gSignal(i+1)(j)
																																																											);
																													      carries:if(i>0) generate
																																				cout((j+1)/(N_carry/2) -1)<=gSignal(i+1)(j);	
																																			end generate;
																																		end generate;  
																												otherPG:if (j>= (2**(i+2) -1)) generate--other blocks of each row have to be a PG block
																																			even:if (j mod (2**(i+1)) = (2**(i+1) -1)) generate
																																				PGelements : PG port map	(
																																																											P1 		=> pSignal(i)(j),
																																																											G1 		=> gSignal(i)(j),
																																																											G2 		=> gSignal(i)(j-2**i),
																																																											P2		 =>	pSignal(i)(j-2**i),
																																																											G_out 		=> gSignal(i+1)(j),
																																																											P_out 		=> pSignal(i+1)(j));					
																																						end generate;
																													end generate;
--propagate and generate signals reach the second part of the tree
																												signalPropagation:if (i=rows/2 -1 and ((j+1+2**i) mod 2**(i+1)= 0 )) generate
																																										pSignal(i+1)(j)<=pSignal(i)(j);
																																										gSignal(i+1)(j)<=gSignal(i)(j);
																											 end generate;
																									
					end generate;
end generate;


-------------------------second half of the sparse tree: from the line 4 and 5------------------------------------------------			
second: for i in rows/2 to (rows-2)  generate
						 elements:for j in 0 to  n_bit-1 generate
									sec:if (j < 2**(i+1) and j>2**i) generate 	    --G blocks are in the first half row for the row 4 and in second half row for the row 5       
                       s:if((j+1)mod(rows-2)=0)generate	--symmetry in position of G block with respect to the row index																			
																																																							g1:	G	port map(P1=> pSignal(i)(j),																																																																							G1 		=> gSignal(i)(j),
                                                                      G2 		=> gSignal(i)(2**(i)-1),
																																																																						G_out 		=> gSignal(i+1)(j));
																																								                              carries:cout((j+1)/(N_carry/2) -1)<=gSignal(i+1)(j);	
																																																					end generate;
																																								
																												end generate;

													sec1:if(j>n_bit/2 ) generate--second half of the row
                       --PG blocks are only in the row 4
																							s1:if(i=rows/2 and (j+1) mod (2**(i-1))=0 and ((j+1)mod(2**(i+1))=0 or (j+1)mod(2**(i+1))>2**i)) generate 
																										pg1:	PG	port map	(P1	 	=> pSignal(i)(j),
																																												G1 		=> gSignal(i)(j),
																																												G2 		=> gSignal(i)(2**(i+1)-1),
																																												p2 => pSignal(i)(2**(i+1)-1),
																																												G_out 		=> gSignal(i+1)(j),
																																												P_out =>pSignal(i+1)(j)
															);
                               end generate;
--outputs to carry select adder --
signalPropagation1:if (i=rows/2 and ((j+1) mod 2**(i+1)=2**i or (j+1) mod 2**(i+1)= 2**(i-1)))generate 
																						pSignal(i+1)(j)<=pSignal(i)(j);
																						gSignal(i+1)(j)<=gSignal(i)(j);
																				end generate;
end generate;	
end generate;
end generate;
end STRUCTURAL;


configuration CFG_Cg of Cg is
  for STRUCTURAL 
      for all : Pgnet
        use configuration WORK.CFG_Pgnet;
      end for;
      for all : Pg
        use configuration WORK.CFG_Pg;
      end for;		
      for all : G
        use configuration WORK.CFG_G;
      end for;		
  end for;
end CFG_Cg;

configuration CFG_Cg of Cg is
  for Structural 
  end for;
end CFG_Cg;


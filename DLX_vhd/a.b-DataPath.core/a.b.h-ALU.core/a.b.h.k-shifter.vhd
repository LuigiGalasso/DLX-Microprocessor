library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use WORK.all;


entity SHIFTER is
	generic(M: integer:= 32;
									N: integer:= 5);
	port(	A: in std_logic_vector(M-1 downto 0);
							B: in std_logic_vector(M-1 downto 0);
							LEFT_RIGHT: in std_logic;	-- 1 = left, 0 = right
							OUTPUT: out std_logic_vector(M-1 downto 0)
	);

end entity SHIFTER;


architecture BEHAVIORAL of SHIFTER is

begin
	SHIFT: process (A, B,LEFT_RIGHT) is
	begin

			if LEFT_RIGHT = '0' then --shift right
					OUTPUT <= to_StdLogicVector((to_bitvector(A)) srl (conv_integer(B)));			
			else                     --shift left
					OUTPUT <= to_StdLogicVector((to_bitvector(A)) sll (conv_integer(B)));
		 end if;
	end process;
end architecture BEHAVIORAL;


configuration CFG_SHIFTER of SHIFTER is
  for BEHAVIORAL
  end for;
end CFG_SHIFTER;



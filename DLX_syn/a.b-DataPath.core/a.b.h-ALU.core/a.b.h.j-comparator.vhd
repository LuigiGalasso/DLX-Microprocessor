library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use WORK.all;



entity COMPARATOR is
	generic(M: integer:= 32);
	port(	A: in std_logic_vector(M-1 downto 0);
							B: in std_logic_vector(M-1 downto 0);
							sel: in std_logic_vector(1 downto 0);
							OUTPUT: out std_logic_vector(M-1 downto 0)
	);

end entity COMPARATOR;

architecture BEHAVIORAL of COMPARATOR is

------00 = equal-------------
------01 = not equal---------
------10 = greater or equal--
------11 = less or equal-----
begin
	COMPARE: process (A, B,sel) is
	begin
	case sel is
			when "00" =>
									if(A=B) then
									OUTPUT <= (0 =>'1',others =>'0');
									else
									OUTPUT <=(others =>'0');
									end if;
	  when "01" =>
									if(A=B) then
									OUTPUT <= (others =>'0');
									else
									OUTPUT <= (0 =>'1',others =>'0');
									end if;
			when "10" =>
									if(A>=B) then
									OUTPUT <= (0 =>'1',others =>'0');
									else
									OUTPUT <= (others =>'0');
									end if;
		 when "11" =>
									if(A<=B) then
									OUTPUT <= (0 =>'1',others =>'0');
									else
									OUTPUT <= (others =>'0');
									end if;
			when others =>
								 OUTPUT <= (others =>'0');
	end case;
	end process;
end architecture BEHAVIORAL;

configuration CFG_COMPARATOR of COMPARATOR is
  for BEHAVIORAL
  end for;
end CFG_COMPARATOR;



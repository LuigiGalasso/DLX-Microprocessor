library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.globals.all;


entity BranchUnit is
	port(
		a : in std_logic_vector(31 downto 0);
		sel :in std_logic;
		y : out std_logic
		);
end BranchUnit;

architecture Behavioral of BranchUnit is
signal zero: std_logic_vector(31 downto 0) :=(others=>'0');
begin
	process(a,sel)
	begin
		
    if(a = zero) then			
        if(sel = '1')then--Branch equal 0
        y<='1';--Branch equal 0 taken 
    		  else   y <= '0';--Branch equal 0 not taken
        end if;
    else
        if(sel = '0')then--Branch not equal 0
        y<='1';--Branch not equal 0 taken 
    		  else   y <= '0';--Branch not equal 0 not taken
        end if;
		  end if;
	end process;
end Behavioral;

configuration CFG_BranchUnit of BranchUnit is
  for Behavioral
  end for;
end CFG_BranchUnit;

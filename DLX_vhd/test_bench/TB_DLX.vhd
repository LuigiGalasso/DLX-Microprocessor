library IEEE;
use WORK.globals.all;
use IEEE.std_logic_1164.all;
use WORK.all;

entity tb_dlx is

end tb_dlx;

architecture TEST of tb_dlx is


 
    signal Clk: std_logic := '0';
    signal Rst: std_logic := '1';

    component DLX 
  generic (
    constant M : integer := WordSize;	
				constant C : integer := ALUOP_SIZE;
    constant N : integer := Address);
  port (
    Clk : in std_logic;
    Rst : in std_logic);                -- Active High

    end component;
begin


        -- instance of DLX
	U1: DLX
	Port Map (Clk, Rst);
	

        PCLOCK : process(Clk)
	begin
		Clk <= not(Clk) after 0.5 ns;	
	end process;
	
	Rst <= '0', '1' after 0.5 ns,'0' after 1.5 ns;
       

end TEST;

-------------------------------

configuration CFG_TB of tb_dlx  is
	for TEST
	end for;
end CFG_TB;

configuration  CFG_TB of tb_dlx is
  for TEST	
  	for all: DLX
	     use configuration WORK.CFG_DLX;
   end for;		
  end for;
end CFG_TB ;


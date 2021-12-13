library ieee;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_1164.all;
use WORK.globals.all;

--Data memory--
entity DRAM is
  generic (
    constant N : integer := Address;
    constant M : integer := WordSize	);
  port (
    Clk :          in std_logic;
    Rst :          in std_logic;
    MemoryEnable:  in std_logic;
    ReadNotWrite:  in std_logic;
    DRAMadd:       in std_logic_vector(N-1  downto 0);
    DRAMin:        in std_logic_vector(M-1 downto 0);
    DRAMout:       out std_logic_vector(M-1 downto 0)
);               
end DRAM;


 architecture behavioral of DRAM is

	type DRAM_type is array (0 to (2**N)-1) of std_logic_vector(M-1 downto 0);  --Matrix of #Adresses x WordSize
	signal DRAM : DRAM_type;

begin
--clockwise write 
	MEM_WRITE: process(Clk) is
	begin
		   if (Rst = '1') then
			    DRAM  <= (others =>(others =>'0'));
     end if;
			    if (Clk'event and  Clk= '1') then
		      if MemoryEnable = '1' then
			       if ReadNotWrite = '0' then
				        DRAM (to_integer(unsigned(DRAMadd))) <= DRAMin;
		        
		        end if;--if read/write
		    end if;-- if enable
   end if;


 
	end process;
--asynchronous read
MEM_READ: process(DRAM,ReadNotWrite,DRAMadd) is
begin
if(ReadNotWrite='1') then
DRAMOut <= DRAM(to_integer(unsigned(DRAMadd)));
else
DRAMOut <= (others=>'0');
end if;
end process;

end behavioral;

configuration CFG_DRAM of DRAM is
  for behavioral
  end for;
end CFG_DRAM;

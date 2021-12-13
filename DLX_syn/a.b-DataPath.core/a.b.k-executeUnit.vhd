library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.globals.all;

entity executeUnit is
generic (constant M   : integer := WordSize;	
											constant C : integer := ALUOP_SIZE);
 port(

         --*INPUTS*--
  							clock : in std_logic;
  							reset : in std_logic;


         ----INPUTS FROM CONTROL WORD--------- 
  							en3: in std_logic;--execute enable         
         Mux1Sel:in std_logic;
  							Mux2Sel: in std_logic;
         ALUCODE: in std_logic_vector(ALUOP_SIZE-1 downto 0);
         
        -----INPUT FROM PREVIOUS STAGE-----------
        OUT1RF:in std_logic_vector(31 downto 0);
        OUT2RF:in std_logic_vector(31 downto 0);
        IMMEDIATE:in std_logic_vector(31 downto 0);
        NPCFromDecode:in std_logic_vector(31 downto 0); 
        AddressWfromDecode:in std_logic_vector(31 downto 0); 

        
        -----OUTPUTS-----------
                        
        ALUtoMEMORY: out std_logic_vector(31 downto 0);      
        OUT2RFtoMEMORY: out std_logic_vector(31 downto 0); 
       
        AddressWtoMEMORY:out std_logic_vector(31 downto 0)

 );
end executeUnit;

architecture structural of executeUnit is


component reg is
	port(
		clock,reset,load : in std_logic;
		i : in std_logic_vector(31 downto 0);
		o : out std_logic_vector(31 downto 0)
	);
end component;

component Mux21 is
	port(
		a   : in std_logic_vector(31 downto 0);
		b   : in std_logic_vector(31 downto 0);
		sel : in std_logic;
		y   : out std_logic_vector(31 downto 0)
		);
end component;

component ALU is
  generic (constant M   : integer := WordSize;	
											constant C : integer := ALUOP_SIZE);
  port 	 ( CODE: IN std_logic_vector(C-1 downto 0);
           DATA1, DATA2: IN std_logic_vector(M-1 downto 0);
           OUTALU: OUT std_logic_vector(M-1 downto 0));
end component;



signal MUX2out:  std_logic_vector(31 downto 0);
signal MUXNPCout:  std_logic_vector(31 downto 0);
signal MUXWITH4out:  std_logic_vector(31 downto 0);
signal ALUout :  std_logic_vector(31 downto 0);
signal JAL4     :std_logic_vector(31 downto 0):= (0 => '1', others=>'0'); --Number four used to add with NPC for the JAL INSTRUCTION



begin 


MUX:mux21 port map(OUT2RF,IMMEDIATE,Mux2Sel,MUX2out);
MUXNPC:mux21 port map(NPCFromDecode,OUT1RF,Mux1Sel,MUXNPCout);   
MUXWITH4:mux21 port map(JAL4,MUX2out,Mux1Sel,MUXWITH4out);


ALUset:ALU port map(ALUCODE,MUXNPCout,MUXWITH4out,ALUout);

--Pipeline registers

ALUout_REG: reg port map(clock,reset,en3,ALUout,ALUtoMEMORY);  -- ALU output register    
RFout2_REG: reg port map(clock,reset,en3,OUT2RF,OUT2RFtoMEMORY); -- Register File's output 2 register
AddressW_REG: reg  port map(clock,reset,en3,AddressWfromDecode,AddressWtoMEMORY); -- Addresses register real


  
end structural;

configuration CFG_executeUnit of executeUnit is
  for structural
  end for;
end CFG_executeUnit;

configuration CFG_executeUnit of executeUnit is
  for structural	
	     for all: ALU
 	     use configuration WORK.CFG_ALU_STRUCTURAL;
      end for;		
      for all : reg
       use configuration WORK.CFG_reg;
      end for;		 	
      
      for all : Mux21
       use configuration WORK.CFG_Mux21;
      end for;	
  end for;
end CFG_executeUnit;

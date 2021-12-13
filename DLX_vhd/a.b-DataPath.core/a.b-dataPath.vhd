library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.globals.all;

entity dataPath is
  generic (constant M : integer := WordSize;	
											constant C : integer := ALUOP_SIZE;
           constant N : integer := Address);

 port(
  							clock : in std_logic;
  							reset : in std_logic;


   -------INPUT CONTROL SIGNAL-------------

    -- Instruction Register
         Instruction: in std_logic_vector(31 downto 0);--Instruction from Instruction Memory
    
    -- IF Control Signal
         en1: in std_logic;--Fetch registers enable 
                                            
    -- ID Control Signals
  							en2: in std_logic;--Decode registers enable
         SignSelect: in std_logic;
									RD1: 				IN std_logic;
									RD2: 				IN std_logic;
									WR: 					IN std_logic;
         JMP: in std_logic; 
         BRANCHenable: in std_logic;
    -- EX Control Signals
  							en3: in std_logic;--execute enable
         BranchCondSel: in std_logic;--select the condition for branching
         Mux1Sel: in std_logic;
  							Mux2Sel: in std_logic;
         ALUCODE: in std_logic_vector(ALUOP_SIZE-1 downto 0);
         RegDestination: in std_logic;--selection bit of register destination multiplexer
    -- MEM Control Signals
  					 		en4: in std_logic;--memory stage enable
          
    -- Data Memory Input
         DRAMout:in std_logic_vector(31 downto 0);

    -- WB Control signals
  				   selwb: in std_logic;--bit selection for Mux

    -------OUTPUTS-------------
         PCtoIM  : out std_logic_vector(31 downto 0);--Program counter value sent to the Instruction Memory
         ALUtoMEMORY: out std_logic_vector(31 downto 0);      
         OUT2RFtoMEMORY: out std_logic_vector(31 downto 0);

    -------OUTPUTS to CU-------------

         InstructionToCU: out std_logic_vector(31 downto 0)

    );
        
end dataPath;



architecture structural of datapath is

component fetchUnit is
  port(  
  							clock : in std_logic;
  							reset : in std_logic;
  							--------INPUTS FROM CONTROL WORD-------------  
  							en1: in std_logic;--Fetch registers enable  
  							
  							BranchPC: in std_logic_vector(31 downto 0);--Program Counter value if Branch is taken
  							BRANCHfromDECODE:in std_logic;-- selection bit of Program Counter Multiplexer
  							Instruction: in std_logic_vector(31 downto 0);--Instruction from Instruction Memory
  							PCtoIM  : out std_logic_vector(31 downto 0);--Program counter value sent to the Instruction Memory
  							IRtoDecode: out std_logic_vector(31 downto 0);--Instruction to be decoded stored in the Instruction Register
         NPCtoDecode  : out std_logic_vector(31 downto 0)--Next Program counter value sent to the next pipe stage

 );
end component;

component DecodeUnit is
 port(

         --*INPUTS*--
  							clock : in std_logic;
  							reset : in std_logic;
         
         JMP: in std_logic;--Jump signal from Control Word
         RegDestination: in std_logic;--selection bit of register destination multiplexer
  							en2: in std_logic;--Decode registers enable
         SignSelect: in std_logic;--select the type of immidiate
         BranchCondSel: in std_logic;--select the condition for branching
         BRANCHenable: in std_logic;
  							--RF enables
									RD1: 				IN std_logic;
									RD2: 				IN std_logic;
									WR: 					IN std_logic;
     
  							Instruction: in std_logic_vector(31 downto 0);--Instruction from Instruction Memory 
     
							  --Data signals
  							ADD_WR: 	IN std_logic_vector(4 downto 0);
									DATAIN: 	IN std_logic_vector(31 downto 0);
   					 NPCfromIF: in std_logic_vector(31 downto 0);  -- PC sent by the IF stage
         

         --*OUTPUTS*--
       
         OUT1: 		 OUT std_logic_vector(31 downto 0);
									OUT2: 		 OUT std_logic_vector(31 downto 0);
         OUTNPC: 		 OUT std_logic_vector(31 downto 0);
         OUTIMM: 		 OUT std_logic_vector(31 downto 0);
         NPCtoEX:   OUT std_logic_vector(31 downto 0);
         AddressWtoEX:  OUT std_logic_vector(31 downto 0); 
         BRANCHtoFetch: out std_logic
         

  
 );
end component;

component executeUnit is
generic (constant M   : integer := WordSize;	
											constant C : integer := ALUOP_SIZE);
 port(

         --*INPUTS*--
  							clock : in std_logic;
  							reset : in std_logic;


         ----INPUTS FROM CONTROL WORD--------- 
  							en3: in std_logic;--execute enable         

         Mux1Sel: in std_logic;
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

end component;



component memoryUnit is
 port(

         --*INPUTS*--
  							clock : in std_logic;
  							reset : in std_logic;

         ----INPUTS FROM CONTROL WORD---------          
  							en4: in std_logic;--memory stage enable
         
        -----INPUT FROM PREVIOUS STAGE-----------
        ALUout:in std_logic_vector(31 downto 0);
        DRAMout:in std_logic_vector(31 downto 0);
        AddressWfromEXECUTE:in std_logic_vector(31 downto 0); 

        -----OUTPUTS-----------
        LOADDATA: out std_logic_vector(31 downto 0); --LMD register output
        ALUtoWBMUX: out std_logic_vector(31 downto 0);      
        AddressWtoWB:out std_logic_vector(31 downto 0)

 );
end component;

component WBUnit is
 port(

         --*INPUTS*--
        
         ----INPUTS FROM CONTROL WORD---------    
  						selwb: in std_logic;--bit selection for Mux
 
        -----INPUT FROM PREVIOUS STAGE-----------
        ALUin :in std_logic_vector(31 downto 0);
        LOADDATA: in std_logic_vector(31 downto 0); --LMD register output
        AddressWfromMemory:in std_logic_vector(31 downto 0);
        -----OUTPUTS-----------
        MUXtoRF : out std_logic_vector(31 downto 0); 
        AddressWtoDECODE: out std_logic_vector(31 downto 0)
 );
end component;

------------SIGNALS-----------
   ---FETCH---
signal  							NewPC:  							  							    std_logic_vector(31 downto 0);--Program Counter value if Branch is taken or in case of a jump
signal  							IRout:  							             std_logic_vector(31 downto 0);--Instruction to be decoded stored in the Instruction Register
   ---DECODE---
signal         NXPC:                       std_logic_vector(31 downto 0);--Next program counter
signal         OUT1:  							  							     std_logic_vector(M-1 downto 0);--RF OUT 1
signal									OUT2:  							  							     std_logic_vector(M-1 downto 0);--RF OUT 2
signal         OUTIMM:  							  						    std_logic_vector(M-1 downto 0);--IMMIDIATE
signal         BRANCHtoFetch:                std_logic;
signal         AddressfromWB: std_logic_vector(31 downto 0);
   ---EXECUTE---
signal         NPCfromDECODE:              std_logic_vector(31 downto 0);
signal         ADDWfromDECODE:              std_logic_vector(31 downto 0);
signal         ALUOUTtoMEMORY:  											std_logic_vector(31 downto 0);      
signal         OUT2RFfromEXECUTE:  						 	std_logic_vector(31 downto 0); 
signal         ADDWtoMEMORY:  						  	 std_logic_vector(31 downto 0);
   ---MEMORY---
 signal        LOADDATA:  					 							    std_logic_vector(31 downto 0); --LMD register output
 signal        ALUtoWBMUX: 					  							  std_logic_vector(31 downto 0);      
 signal        ADDWtoWB :                   std_logic_vector(31 downto 0);


   ---WRITEBACK---
signal         MUXtoRF :					  							     std_logic_vector(31 downto 0);

 

begin

FU:fetchUnit port map(  
  							clock =>clock,
  							reset => reset,

  							en1=>en1, --CW input
  					  
  							BranchPC=>NewPC,
  							BRANCHfromDECODE=>BRANCHtoFetch,
  							Instruction=>Instruction,
  							PCtoIM=>PCtoIM,
  							IRtoDecode=>IRout,
         NPCtoDecode=>NXPC  
         
 );

DU:DecodeUnit port map(

         
  							clock =>clock,
  							reset => reset,

  							en2=>en2,--CW input
         SignSelect=>SignSelect,--CW input
									RD1=>RD1,--CW input
									RD2=>RD2,--CW input
									WR=>WR,--CW input
         JMP=>JMP,--CW input
         BRANCHenable=>BRANCHenable,--CW input
         BranchCondSel=>BranchCondSel,--CW input
         RegDestination=>RegDestination,--CW input

  							Instruction=>IRout,
  
  							ADD_WR=>AddressfromWB(N-1 downto 0),--Address is N bits 
									DATAIN=>MUXtoRF,
   					 NPCfromIF=>NXPC,


         OUT1=>OUT1,
									OUT2=>OUT2,
         OUTNPC=>NewPC,
         OUTIMM=>OUTIMM,
         NPCtoEX=>NPCfromDECODE,
         AddressWtoEX  =>ADDWfromDECODE,
         BRANCHtoFetch=>BRANCHtoFetch
 );

EU:executeUnit port map(

  						 clock =>clock,
  							reset => reset,

   						en3=>en3,--CW input
         Mux1Sel=>Mux1Sel,--CW input
  							Mux2Sel=>Mux2Sel,--CW input
         ALUCODE=>ALUCODE,   --CW input    
         

         OUT1RF=>OUT1,
         OUT2RF=>OUT2,
         IMMEDIATE=>OUTIMM,
         NPCFromDecode=>NPCfromDECODE,
         AddressWfromDecode=>ADDWfromDECODE,
            
         
         ALUtoMEMORY=> ALUOUTtoMEMORY,
         OUT2RFtoMEMORY=>OUT2RFfromEXECUTE,
         AddressWtoMEMORY=>ADDWtoMEMORY
         
 );

MU:memoryUnit port map(

        clock =>clock,
  						reset => reset,

  						en4=>en4,--CW input

        ALUout=> ALUOUTtoMEMORY,
        DRAMout=>DRAMout,--Data from Data Memory as input
        AddressWfromEXECUTE=> ADDWtoMEMORY,
        LOADDATA=>LOADDATA,
        ALUtoWBMUX=>ALUtoWBMUX,
        AddressWtoWB=>ADDWtoWB
 );

WBU:WBUnit port map(

  						selwb=>selwb,--CW input
        ALUin=>ALUtoWBMUX,
        LOADDATA=>LOADDATA,--Data from Data Memory as output of reg
        AddressWfromMemory    =>ADDWtoWB,    
        MUXtoRF=>MUXtoRF,
        AddressWtoDECODE=>AddressfromWB
 );

ALUtoMEMORY<=ALUOUTtoMEMORY;
OUT2RFtoMEMORY<=OUT2RFfromEXECUTE;
InstructionToCU<=IRout;

end structural;

configuration CFG_dataPath of dataPath is
  for structural
  end for;
end CFG_dataPath;

configuration CFG_dataPath of dataPath is
  for structural 	
  	for all: fetchUnit
	     use configuration WORK.CFG_FETCHUNIT;
   end for;		
   for all : DecodeUnit
      use configuration WORK.CFG_DECODEUNIT;
   end for;	
	 for all : executeUnit
      use configuration WORK.CFG_executeUnit;
   end for;	
  for all : memoryUnit 
      use configuration WORK.CFG_memoryUnit;
   end for;	
	 for all : WBUnit
      use configuration WORK.CFG_WBUnit;
   end for;	

  end for;
end CFG_dataPath;


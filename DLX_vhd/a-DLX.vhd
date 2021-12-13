library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use WORK.globals.all;
use work.all;

entity DLX is
  generic (
    constant M : integer := WordSize;	
				constant C : integer := ALUOP_SIZE;
    constant N : integer := Address);
  port (
    Clk : in std_logic;
    Rst : in std_logic);                -- Active High
end DLX;

architecture dlx_rtl of DLX is

 --------------------------------------------------------------------
 -- Components Declaration
 --------------------------------------------------------------------
  
  --Instruction Ram
  component IRAM
  generic (
    RAM_DEPTH : integer := 1024;
    I_SIZE : integer := 32);
    port (
      Rst  : in  std_logic;
      Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
      Dout : out std_logic_vector(I_SIZE- 1 downto 0));
  end component;

  -- Data Ram 
 component DRAM is
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
 end component;


  -- Datapath 
  component dataPath 
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

    -------OUTPUT to CU-------------
         InstructionToCU: out std_logic_vector(31 downto 0)

    );
        
end component;
  -- Control Unit
  component Cu
 	generic (
     constant M : integer := WordSize;	
	    FUNC_SIZE          :     integer := FUNC_SIZE;  -- Func Field Size for R-Type Ops
	    OP_CODE_SIZE       :     integer := OPCODE_SIZE;   -- Op Code Size
					ALU_OP_CODE_SIZE   :     integer := ALUOP_SIZE;   -- ALU Op Code Size
	    CW_SIZE            :     integer := CW_SIZE); -- Control Word Size
       port (
              -- INPUTS         
              Clk : in std_logic;
              Rst : in std_logic; -- Active Low
  
              -- Instruction Register
              IR_IN:         in  std_logic_vector(M - 1 downto 0);

              -- IF Control Signal
              en1:           out std_logic;--Fetch stage registers enable 
                      
              -- ID Control Signals
       							en2:           out std_logic;--Decode stage registers enable
              SignSelect:    out std_logic;-- 1 for ITYPE instructions, 0 for JTYPE
									     RD1: 				      out std_logic;--Register File Read Port 1 enable 
									     RD2: 				      out std_logic;--Register File Read Port 2 enable 
              JMP:           out std_logic;--JUMP enable
              BranchCondSel: out std_logic;--select the condition for branching
              BRANCHenable:  out std_logic;--Branch enable   
              RegDestination:out std_logic;--selection bit of register destination multiplexer  
              -- EX Control Signals
  						     	en3:           out std_logic;--Execute stage registers enable
       							Mux1Sel:       out std_logic;--selection bit for the j-type instructions multiplexer
       							Mux2Sel:       out std_logic;--selection bit of input operands multiplexer

              ALUCODE:       out std_logic_vector(ALUOP_SIZE-1 downto 0);

              -- MEM Control Signals
  					 	    	en4:           out std_logic;--Memory stage registers enable

              --Data memory--
              MemoryEnable:  out std_logic;
              ReadNotWrite:  out std_logic;--1 for reading, 0 for writing  

              -- WB Control signals
       				   selwb:         out std_logic;--bit selection for Mux
              WR: 			        out std_logic--enable the write on the Register file 
);                  
    
  end component;


  ----------------------------------------------------------------
  -- Signals Declaration
  ---------------------------------------------------------------- 

       -- Control Unit Bus signals
       signal en1,en2,SignSelect,RD1,RD2,WR,JMP,BRANCHenable,en3,BranchCondSel,Mux1Sel,Mux2Sel,RegDestination,MemoryEnable,ReadNotWrite,en4,selwb: std_logic;
       signal ALUCODE: std_logic_vector(C-1 downto 0);
       --Instruction Memory signal
       signal InstructionToCU : std_logic_vector(M - 1 downto 0);
       signal Instruction: std_logic_vector(M-1 downto 0);        
       signal PCtoIM  : std_logic_vector(M-1 downto 0);
       --Data Memory signal
       signal ALUtoMEMORY: std_logic_vector(M-1 downto 0); 
       signal OUT2RF:  std_logic_vector(M-1 downto 0);  
       signal DRAMout: std_logic_vector(M-1 downto 0);
    


  begin  -- DLX


    -- Control Unit port map
    CU_I: Cu
      port map (
          -- INPUTS         
              Clk=>Clk, 
              Rst=>Rst, 
              IR_IN=>InstructionToCU,
              en1=>en1,
       							en2=>en2,
              SignSelect=>SignSelect,
									     RD1=>RD1,
									     RD2=>RD2,
              JMP=>JMP,
              BranchCondSel=>BranchCondSel,
              BRANCHenable=>BRANCHenable,   
              RegDestination=>RegDestination,
  						     	en3=>en3,
       							Mux1Sel=>Mux1Sel,
       							Mux2Sel=>Mux2Sel,
              ALUCODE=>ALUCODE,
  					 	    	en4=>en4,
              MemoryEnable=>MemoryEnable,
              ReadNotWrite=>ReadNotWrite,
       				   selwb=>selwb,
              WR=>WR
              );
    -- Instruction Ram port map
  IRAM_I: IRAM
    port map (
         Rst  => Rst,
         Addr => PCtoIM,
        Dout => Instruction);
    -- Data Memory port map   
    DRAM_D: DRAM
     port map (
      Clk           => Clk ,        
      Rst           => Rst,        
      MemoryEnable  => MemoryEnable,
      ReadNotWrite  => ReadNotWrite,
      DRAMadd       => ALUtoMEMORY(4 downto 0),
      DRAMin        => OUT2RF,
      DRAMout       => DRAMout  
);
    -- DataPath port map 
     DP:dataPath  port map(
         Clock=>Clk,
         Reset=>Rst,  
         Instruction=>  Instruction,
         en1=>en1,                                            
  							en2=>en2,
         SignSelect=>SignSelect,
									RD1=>RD1,
									RD2=>RD2,
									WR=>WR,
         JMP=>JMP, 
         BRANCHenable=>BRANCHenable,
  							en3=>en3,
         BranchCondSel=>BranchCondSel,
         Mux1Sel=>Mux1Sel,
  							Mux2Sel=>Mux2Sel,
         ALUCODE=>ALUCODE,
         RegDestination=>RegDestination,
  					 	en4=>en4,
         DRAMout=>DRAMout,
  				   selwb=>selwb,
         PCtoIM=>PCtoIM,
         ALUtoMEMORY=>ALUtoMEMORY, 
         OUT2RFtoMEMORY=>OUT2RF,
         InstructionToCU=>InstructionToCU
);
end dlx_rtl;


configuration CFG_DLX of DLX is
  for dlx_rtl
  end for;
end CFG_DLX;

configuration  CFG_DLX of DLX is
  for dlx_rtl 	
  	for all: dataPath
	     use configuration WORK.CFG_dataPath ;
   end for;		
   for all :Cu
      use configuration WORK.CFG_CU_RTL;
   end for;
   for all: DRAM	
      use configuration WORK.CFG_DRAM;
   end for;
   for all: IRAM	
      use configuration WORK.CFG_IRAM;
   end for;
  end for;
end CFG_DLX ;


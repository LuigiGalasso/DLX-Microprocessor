library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


entity DecodeUnit is
 port(

         --*INPUTS*--
  							clock : in std_logic;
  							reset : in std_logic;
         
         JMP: in std_logic;--Jump signal from Control Word
         RegDestination: in std_logic;

  							en2: in std_logic;--Decode registers enable
         SignSelect: in std_logic;
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
end DecodeUnit;

architecture structural of DecodeUnit is

component register_file is
 port (  CLK:	IN std_logic;
         RESET: 		IN std_logic;
									ENABLE: 	IN std_logic;
									RD1: 				IN std_logic;
									RD2: 				IN std_logic;
									WR: 					IN std_logic;
									ADD_WR: 	IN std_logic_vector(4 downto 0);
									ADD_RD1: IN std_logic_vector(4 downto 0);
									ADD_RD2:	IN std_logic_vector(4 downto 0);
									DATAIN: 	IN std_logic_vector(31 downto 0);
         OUT1: 		 OUT std_logic_vector(31 downto 0);
									OUT2: 		 OUT std_logic_vector(31 downto 0));
end component;

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

component Mux41 is
	port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);
  c : in std_logic_vector(31 downto 0);
		d : in std_logic_vector(31 downto 0);
		sel:in std_logic_vector(1 downto 0);
		y : out std_logic_vector(31 downto 0)
		);
end component;

component BranchUnit is
	      port(
		      a : in std_logic_vector(31 downto 0);
		      sel :in std_logic;
		      y : out std_logic
		      );
end component;

signal MuxtoIMM:    std_logic_vector(31 downto 0); --Immidiate sign extended has to be used in branch and jump instructions 
signal RFOUT1:  std_logic_vector(31 downto 0);
signal RFOUT2:  std_logic_vector(31 downto 0); 

signal	ADD_RD1: std_logic_vector(4 downto 0);
signal	ADD_RD2: std_logic_vector(4 downto 0);

signal zero: std_logic_vector(26 downto 0):=(others=>'0');
signal AddressI: std_logic_vector(31 downto 0);
signal AddressR: std_logic_vector(31 downto 0);
signal ADDR_R31     :std_logic_vector(31 downto 0);
signal AddressW  :std_logic_vector(31 downto 0);
signal Selection :std_logic_vector(1 downto 0);

signal immidiate_Itype: std_logic_vector(31 downto 0);
signal immidiate_Jtype: std_logic_vector(31 downto 0);
signal BranchTaken : std_logic;--high if branch is taken


begin 
 
ADDR_R31 <=zero & "11111";--Address register 31 used to store di PC+4 (JAL instruction)
AddressI <=zero & Instruction(20 downto 16);--I_TYPE REGISTER DESTINATION ADDRESS
AddressR <=zero & Instruction(15 downto 11);--R_TYPE REGISTER DESTINATION ADDRESS
Selection<=JMP & RegDestination;

ADDRESS_MUX: Mux41     port map(AddressI ,AddressR,ADDR_R31,ADDR_R31,Selection,AddressW);

immidiate_Itype(15 downto 0)<= Instruction(15 downto 0);
immidiate_Itype(31 downto 16)<=(others=>Instruction(15));
immidiate_Jtype(25 downto 0)<= Instruction(25 downto 0);
immidiate_Jtype(31 downto 26)<=(others=>Instruction(25));
-----sign extend the immidiate from 26 to 32 bits for J-TYPE instructions or 16 to 32 bits for I-TYPE instructions---- 
MUX: Mux21     port map(immidiate_Itype ,immidiate_Jtype,SignSelect,MuxtoImm);

BRANCH:BranchUnit port map(RFOUT1,BranchCondSel,BranchTaken);
BRANCHtoFetch<=JMP OR  (BranchTaken AND BRANCHenable);
-----ADDER used to calculate the next pc-------------- 
--sum on 32 bit: PC+4(=NPCfromIF)+Immidiate (two bits right shifted for the correct instruction memory allignment)-- 
OUTNPC<= conv_std_logic_vector(   (conv_integer( NPCfromIF + ( "00" & MuxtoImm(31 downto 2)) )   mod 1024) ,32);--1024=Instruction memory size

--Pipeline registers
IMM_REG: reg port map(clock,reset,en2,MuxtoIMM,OUTIMM); -- Immediate Register

OUT1_REG: reg port map(clock,reset,en2,RFOUT1,OUT1); -- Register File's output 1 register
OUT2_REG: reg port map(clock,reset,en2,RFOUT2,OUT2); -- Register File's output 2 register
NXPC_REG: reg port map(clock,reset,en2,NPCfromIF,NPCtoEX); -- Next program counter register
ADD_WR_REG: reg port map(clock,reset,en2,AddressW,AddressWtoEX); -- Address write resgister destination register
RF: register_file port map(clock,reset,'1',RD1,RD2,WR,ADD_WR,ADD_RD1,ADD_RD2,DATAIN,RFOUT1,RFOUT2);

ADD_RD1<=Instruction(25 downto 21);
ADD_RD2<=Instruction(20 downto 16);


  
end structural;

configuration CFG_DECODEUNIT of DecodeUnit is
  for structural
  end for;
end CFG_DECODEUNIT;

configuration CFG_DECODEUNIT of DecodeUnit is
  for structural 	
  	for all: reg
	     use configuration WORK.CFG_reg;
   end for;		
   for all : Mux21
      use configuration WORK.CFG_Mux21;
   end for;	
   for all : Mux41
    use configuration WORK.CFG_Mux41;
   end for;
	 for all : register_file
      use configuration WORK.CFG_register_file;
   end for;	
  for all: BranchUnit 
       use configuration WORK.CFG_BranchUnit;
      end for;
  end for;
end CFG_DECODEUNIT;

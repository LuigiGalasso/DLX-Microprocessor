library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.globals.all;
use work.all;

entity Cu is
	generic (
     constant M : integer := WordSize;	 
	    FUNC_SIZE          :     integer := FUNC_SIZE;  -- Func Field Size for R-Type Ops
	    OP_CODE_SIZE       :     integer := OPCODE_SIZE;   -- Op Code Size
					ALU_OP_CODE_SIZE   :     integer := ALUOP_SIZE;   -- ALU Op Code Size
	    CW_SIZE            :     integer := CW_SIZE); -- Control Word Size
       port (
              -- INPUTS         
              Clk : in std_logic;
              Rst : in std_logic; -- Active HIGH
  
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
    end Cu;

architecture structural of Cu is

      


                                
  signal IR_opcode : std_logic_vector(OP_CODE_SIZE -1 downto 0);  -- OpCode part of IR
  signal IR_func : std_logic_vector(FUNC_SIZE -1 downto 0);   -- Func part of IR when Rtype
  signal aluOpcode  : std_logic_vector (ALU_OP_CODE_SIZE-1 downto 0) := (others =>'0');--NOPaluOpcode;

  -- control word is shifted to the correct stage
  signal cw2 : std_logic_vector(CW_SIZE - 1 - 1  downto 0); -- second stage--16 bit   
  signal cw3 : std_logic_vector(CW_SIZE - 1 - 9  downto 0); -- third stage-- 8 bit         
  signal cw4 : std_logic_vector(CW_SIZE - 1 - 12 downto 0); -- fourth stage--5 bit 
  signal cw5 : std_logic_vector(CW_SIZE - 1 - 15 downto 0); -- fifth stage-- 2 bit

  
  signal aluOpcode3 : std_logic_vector (ALU_OP_CODE_SIZE-1 downto 0) := (others =>'0');


begin

  IR_opcode <=IR_IN(31 downto 26);
  IR_func   <=IR_IN(10 downto  0);


--en1    --en2,SignSelect,RD1,RD2,JMP,BranchCondSel,BRANCHenable,RegDestination  --en3,Mux2Sel  --en4,MemoryEnable,ReadNotWrite--   selwb,WR--
-- stage one control signals																																																															
  en1  <=      '1';    --always enabled 
-- stage two control signals
  en2  <=            cw2(CW_SIZE - 2);
  SignSelect  <=     cw2(CW_SIZE - 3);
  RD1  <=            cw2(CW_SIZE - 4);
  RD2   <=           cw2(CW_SIZE - 5);
  JMP   <=           cw2(CW_SIZE - 6);   
  BranchCondSel <=   cw2(CW_SIZE - 7);
  BRANCHenable <=    cw2(CW_SIZE - 8);
  RegDestination  <= cw2(CW_SIZE - 9);
  ALUCODE<=aluOpcode3;
-- stage three control signals
  en3   <=           cw3(CW_SIZE-10);
  Mux1Sel  <=        cw3(CW_SIZE-11); 
  Mux2Sel  <=        cw3(CW_SIZE-12); 
-- stage four control signals  
  en4   <=           cw4(CW_SIZE-13);
  MemoryEnable  <=   cw4(CW_SIZE-14); 
  ReadNotWrite<=     cw4(CW_SIZE-15); 
-- stage five control signals  
  selwb  <=          cw5(CW_SIZE-16);
  WR  <=             cw5(CW_SIZE-17); 
 -- process to pipeline control words and aluCode
  CW_PIPE: process (Clk,Rst)
  begin  -- process Clk
     if Clk'event and Clk = '1' then     -- rising clock edge
    if Rst = '1' then                   -- reset (active high)
      cw3 <= (others => '0');
      cw4 <= (others => '0');
      cw5 <= (others => '0');
   else 
      cw3 <= cw2(CW_SIZE - 1 - 9  downto 0);			
				  cw4 <= cw3(CW_SIZE - 1 - 12 downto 0);
      cw5 <= cw4(CW_SIZE - 1 - 15 downto 0);	
   
      aluOpcode3 <= aluOpcode;
	   end if;
    end if;
  end process CW_PIPE;

      

-- process to compute the correct ALU code and Contro Word
ALU_OP_CODE_P : process (IR_opcode, IR_func,Rst)
   begin  
   if Rst = '1' then 
   cw2 <= (others => '0');
   aluOpcode <=  (others =>'0');
   else

	case conv_integer(unsigned(IR_opcode)) is
-- case of R type requires analysis of FUNC instead of the I type instructions which require the analysis of the only opcode 
		when 0 =>
   cw2<="1011000110110001";--R type
			case conv_integer(unsigned(IR_func)) is     --We used the same configuration defined on the globals file for this selection
				when 4 =>  aluOpcode <=  ALUOP_SLL; -- SLL
				when 6 =>  aluOpcode <=  ALUOP_SRL; -- SRL
				when 32 => aluOpcode <=  ALUOP_ADD; -- ADD
				when 34 => aluOpcode <=  ALUOP_SUB; -- SUB
				when 36 => aluOpcode <=  ALUOP_AND; -- AND
				when 37 => aluOpcode <=  ALUOP_OR;  -- OR
				when 38 => aluOpcode <=  ALUOP_XOR; -- XOR
				when 41 => aluOpcode <=  ALUOP_SNE; -- SNE
				when 44 => aluOpcode <=  ALUOP_SLE; -- SLE
				when 45 => aluOpcode <=  ALUOP_SGE; -- SGE
			
				when others => aluOpcode <=  (others =>'0');--NOPaluOpcode;
			end case;
--en2,SignSelect,RD1,RD2,JMP,BranchCondSel,BRANCHenable,RegDestination  --en3,Mux1Sel,Mux2Sel  --en4,MemoryEnable,ReadNotWrite--   selwb,WR--						
		when 2 => aluOpcode  <=  ALUOP_NOP ;cw2<= "1000100010010000";  --J
		when 3 => aluOpcode  <=  ALUOP_ADD ;cw2<= "1000100011010001";  --JAL
		when 4 => aluOpcode  <=  ALUOP_NOP ;cw2<= "1110011010010000";  --BEQZ
		when 5 => aluOpcode  <=  ALUOP_NOP ;cw2<= "1110001010010000";  --BNEZ
		when 8 => aluOpcode  <=  ALUOP_ADD ;cw2<= "1110000010010001";  --ADDI
		when 10=> aluOpcode  <=  ALUOP_SUB ;cw2<= "1110000010010001";  --SUBI
		when 12=> aluOpcode  <=  ALUOP_AND ;cw2<= "1110000010010001";  --ANDI
		when 13=> aluOpcode  <=  ALUOP_OR  ;cw2<= "1110000010010001";  --ORI 
		when 14=> aluOpcode  <=  ALUOP_XOR ;cw2<= "1110000010010001";  --XORI
		when 20=> aluOpcode  <=  ALUOP_SLL ;cw2<= "1110000010010001";  --SLLI
		when 21=> aluOpcode  <=  ALUOP_NOP ;cw2<= "1110000010010001";  --NOP
		when 22=> aluOpcode  <=  ALUOP_SRL ;cw2<= "1110000010010001";  --SRLI
		when 25=> aluOpcode  <=  ALUOP_SNE ;cw2<= "1110000010010001";  --SNEI
		when 28=> aluOpcode  <=  ALUOP_SLE ;cw2<= "1110000010010001";  --SLEI
		when 29=> aluOpcode  <=  ALUOP_SGE ;cw2<= "1110000010010001";  --SGEI
		when 35=> aluOpcode  <=  ALUOP_ADD ;cw2<= "1111000010011111";  --LW
		when 43=> aluOpcode  <=  ALUOP_ADD ;cw2<= "1111000010011000";  --SW

		when others => aluOpcode <=  (others =>'0');--NOPaluOpcode;
	 end case;
  end if;
	end process ALU_OP_CODE_P;


end structural;

configuration CFG_CU_RTL of Cu is
  for structural
  end for;
end configuration;

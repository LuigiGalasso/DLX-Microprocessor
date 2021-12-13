
library ieee;
use ieee.std_logic_1164.all;

package globals is
		 constant Address    : integer := 5;
   constant WordSize   : integer := 32;		
  -- CW size
  constant CW_SIZE : integer := 17;
  -- ALU Operation
  constant ALUOP_SIZE : integer := 4;
  -- OPCODE
  constant OPCODE_SIZE : integer := 6;
  -- FUNCTION FIELD SIZE
  constant FUNC_SIZE : integer := 11;




  -- FUNC FIELDS FOR EACH INSTRUCTION
   constant FUNC_SLL      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000000100";
   constant FUNC_SRL      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000000110";
   constant FUNC_ADD      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000100000";
   constant FUNC_SUB      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000100010";
   constant FUNC_AND      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000100100";
   constant FUNC_OR       : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000100101";
   constant FUNC_XOR      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000100110";
   constant FUNC_SNE      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000101001";
   constant FUNC_SLE      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000101100";
   constant FUNC_SGE      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000101101";

  -- OPCODE FIELD
   	constant RTYPE         : std_logic_vector (OPCODE_SIZE-1 downto 0) := "000000"; --iclude AND ADD SUB OR SGE SLE SLL SNE SRL XOR SRL
    
    constant J_TYPE_J      : std_logic_vector (OPCODE_SIZE-1 downto 0) := "000010";
  	 constant J_TYPE_JAL    : std_logic_vector (OPCODE_SIZE-1 downto 0) := "000011";

 	  constant I_TYPE_BEQZ   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "000100";
  	 constant I_TYPE_BNEZ   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "000101";

  	 constant I_TYPE_ADDI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001000";
  	 constant I_TYPE_SUBI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001010";
  	 constant I_TYPE_ANDI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001100";
  	 constant I_TYPE_ORI    : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001101";
  	 constant I_TYPE_XORI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001110";

  	 constant I_TYPE_SLLI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "010100";
  	 constant N_TYPE_NOP    : std_logic_vector (OPCODE_SIZE-1 downto 0) := "010101";
  	 constant I_TYPE_SRLI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "010110";
  	 constant I_TYPE_SNEI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "011001";
  	 constant I_TYPE_SLEI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "011100";
  	 constant I_TYPE_SGEI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "011101";
 	  constant I_TYPE_LW     : std_logic_vector (OPCODE_SIZE-1 downto 0) := "100011";
  	 constant I_TYPE_SW     : std_logic_vector (OPCODE_SIZE-1 downto 0) := "101011";

  -- ALU OPERATION
  constant ALUOP_SLL      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0001";
  constant ALUOP_SRL      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0010";
  constant ALUOP_ADD      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0011";
  constant ALUOP_SUB      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0100";
  constant ALUOP_AND      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0101";
  constant ALUOP_OR       : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0110";
  constant ALUOP_XOR      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0111";
  constant ALUOP_SNE      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "1000";
  constant ALUOP_SLE      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "1001";
  constant ALUOP_SGE      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "1010";
  constant ALUOP_NOP      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "0000";



end globals;

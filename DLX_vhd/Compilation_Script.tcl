
#globals
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/000-globals.vhd
#Fetch
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.a-reg.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.b-adder.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.c-InstructionRegister.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.d-mux21.vhd


#Decode
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.e-BranchUnit.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.f-mux41.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.g-registerfile.vhd  
#Execute
#P4ADDER
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.h-ALU.core/a.b.h.a-fa.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.h-ALU.core/a.b.h.b-rca.vhd 
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.h-ALU.core/a.b.h.c-CSb.vhd  
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.h-ALU.core/a.b.h.d-CSA.vhd 
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.h-ALU.core/a.b.h.e-Pg.vhd  
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.h-ALU.core/a.b.h.f-G.vhd  
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.h-ALU.core/a.b.h.g-PGnet.vhd   
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.h-ALU.core/a.b.h.h-sparsetree.vhd  
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.h-ALU.core/a.b.h.i-P4adder.vhd 
#
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.h-ALU.core/a.b.h.j-comparator.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.h-ALU.core/a.b.h.k-shifter.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.h-ALU.core/a.b.h-alu.vhd

#Memory Unit
#WB Unit

#DATAPATH
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.i-fetchUnit.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.j-DecodeUnit.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.k-executeUnit.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.l-memoryUnit.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b.m-WBunit.vhd
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.b-DataPath.core/a.b-dataPath.vhd

#Control Unit
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a.a-HWCU.vhd
#Instruction memory
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/b-InstructionMemory.vhd
#Data memory
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/c-DataMemory.vhd
#DLX
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/a-DLX.vhd
#Test Bench
vcom -reportprogress 300 -work work /home/ms19.7/0DLX/Simulation/TEST_BENCH/TB_DLX.vhd

vsim -t ps -novopt work.tb_dlx(test)


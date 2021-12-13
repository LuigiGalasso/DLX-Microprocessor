###################################################################

# Created by write_sdc on Mon Oct  7 17:56:47 2019

###################################################################
set sdc_version 1.9

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
create_clock [get_ports Clk]  -period 1.28  -waveform {0 0.64}
set_max_delay 1.28  -from [list [get_ports Clk] [get_ports Rst] [get_ports {IRAM_Dout[31]}]       \
[get_ports {IRAM_Dout[30]}] [get_ports {IRAM_Dout[29]}] [get_ports             \
{IRAM_Dout[28]}] [get_ports {IRAM_Dout[27]}] [get_ports {IRAM_Dout[26]}]       \
[get_ports {IRAM_Dout[25]}] [get_ports {IRAM_Dout[24]}] [get_ports             \
{IRAM_Dout[23]}] [get_ports {IRAM_Dout[22]}] [get_ports {IRAM_Dout[21]}]       \
[get_ports {IRAM_Dout[20]}] [get_ports {IRAM_Dout[19]}] [get_ports             \
{IRAM_Dout[18]}] [get_ports {IRAM_Dout[17]}] [get_ports {IRAM_Dout[16]}]       \
[get_ports {IRAM_Dout[15]}] [get_ports {IRAM_Dout[14]}] [get_ports             \
{IRAM_Dout[13]}] [get_ports {IRAM_Dout[12]}] [get_ports {IRAM_Dout[11]}]       \
[get_ports {IRAM_Dout[10]}] [get_ports {IRAM_Dout[9]}] [get_ports              \
{IRAM_Dout[8]}] [get_ports {IRAM_Dout[7]}] [get_ports {IRAM_Dout[6]}]          \
[get_ports {IRAM_Dout[5]}] [get_ports {IRAM_Dout[4]}] [get_ports               \
{IRAM_Dout[3]}] [get_ports {IRAM_Dout[2]}] [get_ports {IRAM_Dout[1]}]          \
[get_ports {IRAM_Dout[0]}] [get_ports {DRAM_out[31]}] [get_ports               \
{DRAM_out[30]}] [get_ports {DRAM_out[29]}] [get_ports {DRAM_out[28]}]          \
[get_ports {DRAM_out[27]}] [get_ports {DRAM_out[26]}] [get_ports               \
{DRAM_out[25]}] [get_ports {DRAM_out[24]}] [get_ports {DRAM_out[23]}]          \
[get_ports {DRAM_out[22]}] [get_ports {DRAM_out[21]}] [get_ports               \
{DRAM_out[20]}] [get_ports {DRAM_out[19]}] [get_ports {DRAM_out[18]}]          \
[get_ports {DRAM_out[17]}] [get_ports {DRAM_out[16]}] [get_ports               \
{DRAM_out[15]}] [get_ports {DRAM_out[14]}] [get_ports {DRAM_out[13]}]          \
[get_ports {DRAM_out[12]}] [get_ports {DRAM_out[11]}] [get_ports               \
{DRAM_out[10]}] [get_ports {DRAM_out[9]}] [get_ports {DRAM_out[8]}] [get_ports \
{DRAM_out[7]}] [get_ports {DRAM_out[6]}] [get_ports {DRAM_out[5]}] [get_ports  \
{DRAM_out[4]}] [get_ports {DRAM_out[3]}] [get_ports {DRAM_out[2]}] [get_ports  \
{DRAM_out[1]}] [get_ports {DRAM_out[0]}]]  -to [list [get_ports {IRAM_Addr[31]}] [get_ports {IRAM_Addr[30]}] [get_ports  \
{IRAM_Addr[29]}] [get_ports {IRAM_Addr[28]}] [get_ports {IRAM_Addr[27]}]       \
[get_ports {IRAM_Addr[26]}] [get_ports {IRAM_Addr[25]}] [get_ports             \
{IRAM_Addr[24]}] [get_ports {IRAM_Addr[23]}] [get_ports {IRAM_Addr[22]}]       \
[get_ports {IRAM_Addr[21]}] [get_ports {IRAM_Addr[20]}] [get_ports             \
{IRAM_Addr[19]}] [get_ports {IRAM_Addr[18]}] [get_ports {IRAM_Addr[17]}]       \
[get_ports {IRAM_Addr[16]}] [get_ports {IRAM_Addr[15]}] [get_ports             \
{IRAM_Addr[14]}] [get_ports {IRAM_Addr[13]}] [get_ports {IRAM_Addr[12]}]       \
[get_ports {IRAM_Addr[11]}] [get_ports {IRAM_Addr[10]}] [get_ports             \
{IRAM_Addr[9]}] [get_ports {IRAM_Addr[8]}] [get_ports {IRAM_Addr[7]}]          \
[get_ports {IRAM_Addr[6]}] [get_ports {IRAM_Addr[5]}] [get_ports               \
{IRAM_Addr[4]}] [get_ports {IRAM_Addr[3]}] [get_ports {IRAM_Addr[2]}]          \
[get_ports {IRAM_Addr[1]}] [get_ports {IRAM_Addr[0]}] [get_ports               \
DRAM_MemoryEnable] [get_ports DRAM_ReadNotWrite] [get_ports {DRAM_Addr[4]}]    \
[get_ports {DRAM_Addr[3]}] [get_ports {DRAM_Addr[2]}] [get_ports               \
{DRAM_Addr[1]}] [get_ports {DRAM_Addr[0]}] [get_ports {DRAM_in[31]}]           \
[get_ports {DRAM_in[30]}] [get_ports {DRAM_in[29]}] [get_ports {DRAM_in[28]}]  \
[get_ports {DRAM_in[27]}] [get_ports {DRAM_in[26]}] [get_ports {DRAM_in[25]}]  \
[get_ports {DRAM_in[24]}] [get_ports {DRAM_in[23]}] [get_ports {DRAM_in[22]}]  \
[get_ports {DRAM_in[21]}] [get_ports {DRAM_in[20]}] [get_ports {DRAM_in[19]}]  \
[get_ports {DRAM_in[18]}] [get_ports {DRAM_in[17]}] [get_ports {DRAM_in[16]}]  \
[get_ports {DRAM_in[15]}] [get_ports {DRAM_in[14]}] [get_ports {DRAM_in[13]}]  \
[get_ports {DRAM_in[12]}] [get_ports {DRAM_in[11]}] [get_ports {DRAM_in[10]}]  \
[get_ports {DRAM_in[9]}] [get_ports {DRAM_in[8]}] [get_ports {DRAM_in[7]}]     \
[get_ports {DRAM_in[6]}] [get_ports {DRAM_in[5]}] [get_ports {DRAM_in[4]}]     \
[get_ports {DRAM_in[3]}] [get_ports {DRAM_in[2]}] [get_ports {DRAM_in[1]}]     \
[get_ports {DRAM_in[0]}]]

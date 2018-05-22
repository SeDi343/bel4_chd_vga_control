vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm
vlib riviera/blk_mem_gen_v8_3_2

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm
vmap blk_mem_gen_v8_3_2 riviera/blk_mem_gen_v8_3_2

vlog -work xil_defaultlib -v2k5 -sv \
"/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_base.sv" \
"/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_dpdistram.sv" \
"/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_dprom.sv" \
"/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_sdpram.sv" \
"/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_spram.sv" \
"/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_sprom.sv" \
"/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_tdpram.sv" \

vcom -work xpm -93 \
"/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_3_2 -v2k5 \
"../../../ipstatic/blk_mem_gen_v8_3_2/simulation/blk_mem_gen_v8_3.v" \

vlog -work xil_defaultlib -v2k5 \
"../../../../rom_mem1/sim/rom_mem1.v" \

vlog -work xil_defaultlib "glbl.v"


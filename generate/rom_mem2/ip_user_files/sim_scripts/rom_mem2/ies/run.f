-makelib ies/xil_defaultlib \
  "/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_base.sv" \
  "/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_dpdistram.sv" \
  "/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_dprom.sv" \
  "/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_sdpram.sv" \
  "/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_spram.sv" \
  "/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_sprom.sv" \
  "/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_memory/hdl/xpm_memory_tdpram.sv" \
-endlib
-makelib ies/xpm \
  "/home/fedora/bin/Xilinx/Vivado/2016.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies/blk_mem_gen_v8_3_2 \
  "../../../ipstatic/blk_mem_gen_v8_3_2/simulation/blk_mem_gen_v8_3.v" \
-endlib
-makelib ies/xil_defaultlib \
  "../../../../rom_mem2/sim/rom_mem2.v" \
-endlib
-makelib ies/xil_defaultlib \
  glbl.v
-endlib


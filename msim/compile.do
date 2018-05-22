### IP Cores
## Memory 1
# copy .mif file (which holds content of ROM) into ModelSim simulation directory
file copy -force ../generate/rom_mem1/rom_mem1/rom_mem1.mif ./

# compile simulation model of generated ROM
vlog ../generate/rom_mem1/rom_mem1/blk_mem_gen_v8_3_2/simulation/blk_mem_gen_v8_3.v
vcom ../generate/rom_mem1/rom_mem1/synth/rom_mem1.vhd

# compile Xilinx GLBL module (required for proper initialization
# of all generated  Xilinx macros during simulation)
vlog ../generate/rom_mem1/ip_user_files/sim_scripts/rom_mem1/modelsim/glbl.v

vcom ../vhdl/memory_control_1_entity.vhd
vcom ../vhdl/memory_control_1_architecture.vhd

## Memory 2
# copy .mif file (which holds content of ROM) into ModelSim simulation directory
file copy -force ../generate/rom_mem2/rom_mem2/rom_mem2.mif ./

# compile simulation model of generated ROM
vlog ../generate/rom_mem2/rom_mem2/blk_mem_gen_v8_3_2/simulation/blk_mem_gen_v8_3.v
vcom ../generate/rom_mem2/rom_mem2/synth/rom_mem2.vhd

# compile Xilinx GLBL module (required for proper initialization
# of all generated  Xilinx macros during simulation)
vlog ../generate/rom_mem2/ip_user_files/sim_scripts/rom_mem2/modelsim/glbl.v

#vcom ../vhdl/memory_control_2_entity.vhd
#vcom ../vhld/memory_control_2_architecture.vhd

### Compile Programmed Components
## Prescaler
vcom ../vhdl/prescaler_entity.vhd
vcom ../vhdl/prescaler_architecture.vhd

## VGA Control
vcom ../vhdl/vga_control_entity.vhd
vcom ../vhdl/vga_control_architecture.vhd

## IO Logic
vcom ../vhdl/io_logic_entity.vhd
vcom ../vhdl/io_logic_architecture.vhd

## Source Mulitplexer
vcom ../vhdl/source_multiplex_entity.vhd
vcom ../vhdl/source_multiplex_architecture.vhd

## Patterngenerator 1
vcom ../vhdl/patterngenerator_1_entity.vhd
vcom ../vhdl/patterngenerator_1_architecture.vhd

## Patterngenerator 2
vcom ../vhdl/patterngenerator_2_entity.vhd
vcom ../vhdl/patterngenerator_2_architecture.vhd

## VGA Monitor
# only Simulation
vcom ../vhdl/vga_monitor/vga_monitor_.vhd
vcom ../vhdl/vga_monitor/vga_monitor_sim.vhd

## Top Level
vcom ../vhdl/top_level_entity.vhd
vcom ../vhdl/top_level_architecture.vhd

### Testbenches
## Top Level
vcom ../tb/tb_top_level.vhd

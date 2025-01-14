#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/fedora/bin/Xilinx/Vivado/2016.1/ids_lite/ISE/bin/lin64:/home/fedora/bin/Xilinx/Vivado/2016.1/bin
else
  PATH=/home/fedora/bin/Xilinx/Vivado/2016.1/ids_lite/ISE/bin/lin64:/home/fedora/bin/Xilinx/Vivado/2016.1/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=/home/fedora/bin/Xilinx/Vivado/2016.1/ids_lite/ISE/lib/lin64
else
  LD_LIBRARY_PATH=/home/fedora/bin/Xilinx/Vivado/2016.1/ids_lite/ISE/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/impl/vga_controller/vga_controller.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .init_design.begin.rst
EAStep vivado -log top_level_entity.vdi -applog -m64 -messageDb vivado.pb -mode batch -source top_level_entity.tcl -notrace



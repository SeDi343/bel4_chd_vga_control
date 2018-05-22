// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.1 (lin64) Build 1538259 Fri Apr  8 15:45:23 MDT 2016
// Date        : Tue May 22 21:57:48 2018
// Host        : fedora running 64-bit Fedora release 27 (Twenty Seven)
// Command     : write_verilog -force -mode synth_stub
//               /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/generate/rom_mem2/rom_mem2/rom_mem2_stub.v
// Design      : rom_mem2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_2,Vivado 2016.1" *)
module rom_mem2(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[13:0],douta[11:0]" */;
  input clka;
  input [13:0]addra;
  output [11:0]douta;
endmodule

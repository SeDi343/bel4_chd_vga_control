proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/impl/vga_controller/vga_controller.cache/wt [current_project]
  set_property parent.project_path /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/impl/vga_controller/vga_controller.xpr [current_project]
  set_property ip_repo_paths /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/impl/vga_controller/vga_controller.cache/ip [current_project]
  set_property ip_output_repo /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/impl/vga_controller/vga_controller.cache/ip [current_project]
  set_property XPM_LIBRARIES XPM_MEMORY [current_project]
  add_files -quiet /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/impl/vga_controller/vga_controller.runs/synth_1/top_level_entity.dcp
  add_files -quiet /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/generate/rom_mem1/rom_mem1/rom_mem1.dcp
  set_property netlist_only true [get_files /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/generate/rom_mem1/rom_mem1/rom_mem1.dcp]
  add_files -quiet /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/generate/rom_mem2/rom_mem2/rom_mem2.dcp
  set_property netlist_only true [get_files /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/generate/rom_mem2/rom_mem2/rom_mem2.dcp]
  read_xdc -mode out_of_context -ref rom_mem1 -cells U0 /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/generate/rom_mem1/rom_mem1/rom_mem1_ooc.xdc
  set_property processing_order EARLY [get_files /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/generate/rom_mem1/rom_mem1/rom_mem1_ooc.xdc]
  read_xdc -mode out_of_context -ref rom_mem2 -cells U0 /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/generate/rom_mem2/rom_mem2/rom_mem2_ooc.xdc
  set_property processing_order EARLY [get_files /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/generate/rom_mem2/rom_mem2/rom_mem2_ooc.xdc]
  read_xdc /home/fedora/Dokumente/Schule/Fachhochschule/Semester_4/Chip_Design/Project_VGA_Controller/code/impl/vga_controller/vga_controller.srcs/constrs_1/new/vga_controller_constrs.xdc
  link_design -top top_level_entity -part xc7a35tcpg236-1
  write_hwdef -file top_level_entity.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force top_level_entity_opt.dcp
  report_drc -file top_level_entity_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force top_level_entity_placed.dcp
  report_io -file top_level_entity_io_placed.rpt
  report_utilization -file top_level_entity_utilization_placed.rpt -pb top_level_entity_utilization_placed.pb
  report_control_sets -verbose -file top_level_entity_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force top_level_entity_routed.dcp
  report_drc -file top_level_entity_drc_routed.rpt -pb top_level_entity_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file top_level_entity_timing_summary_routed.rpt -rpx top_level_entity_timing_summary_routed.rpx
  report_power -file top_level_entity_power_routed.rpt -pb top_level_entity_power_summary_routed.pb -rpx top_level_entity_power_routed.rpx
  report_route_status -file top_level_entity_route_status.rpt -pb top_level_entity_route_status.pb
  report_clock_utilization -file top_level_entity_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force top_level_entity.mmi }
  write_bitstream -force top_level_entity.bit 
  catch { write_sysdef -hwdef top_level_entity.hwdef -bitfile top_level_entity.bit -meminfo top_level_entity.mmi -file top_level_entity.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}


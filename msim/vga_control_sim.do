vsim -t ns -novopt -lib work work.tb_vga_control_entity
view *
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_vga_control_entity/clk_i
add wave -noupdate -format Logic /tb_vga_control_entity/reset_i
add wave -noupdate -format Logic /tb_vga_control_entity/en_25mhz_i
add wave -noupdate -format Logic /tb_vga_control_entity/h_sync_o
add wave -noupdate -format Logic /tb_vga_control_entity/v_sync_o
add wave -noupdate -format Logic /tb_vga_control_entity/rgb_o
add wave -noupdate -format Logic /tb_vga_control_entity/i_vga_control_entity/s_enctr_h_sync
add wave -noupdate -format Logic /tb_vga_control_entity/i_vga_control_entity/H_WHOLE_LINE
add wave -noupdate -format Logic /tb_vga_control_entity/i_vga_control_entity/s_enctr_v_sync
add wave -noupdate -format Logic /tb_vga_control_entity/i_vga_control_entity/V_WHOLE_LINE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
run 1000 ms

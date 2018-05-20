vsim -t ns -novopt -lib work work.tb_top_level_entity
view *
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_top_level_entity/clk_i
add wave -noupdate -format Logic /tb_top_level_entity/reset_i
add wave -noupdate -format Logic /tb_top_level_entity/sw_i
add wave -noupdate -format Logic /tb_top_level_entity/pb_i
add wave -noupdate -format Logic /tb_top_level_entity/rgb_o
add wave -noupdate -format Logic /tb_top_level_entity/h_sync_o
add wave -noupdate -format Logic /tb_top_level_entity/v_sync_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
run 1 sec

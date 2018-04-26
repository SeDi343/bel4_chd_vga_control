vsim -t ns -novopt -lib work work.tb_prescaler_entity
view *
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_prescaler_entity/clk_i
add wave -noupdate -format Logic /tb_prescaler_entity/reset_i
add wave -noupdate -format Logic /tb_prescaler_entity/en_25mhz_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
run 500 ns
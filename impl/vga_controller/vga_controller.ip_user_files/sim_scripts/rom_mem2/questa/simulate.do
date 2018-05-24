onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib rom_mem2_opt

do {wave.do}

view wave
view structure
view signals

do {rom_mem2.udo}

run -all

quit -force

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mux8_1_testbench/clk
add wave -noupdate /mux8_1_testbench/data
add wave -noupdate /mux8_1_testbench/sel
add wave -noupdate /mux8_1_testbench/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {132 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 320
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {874210 ps} {875042 ps}

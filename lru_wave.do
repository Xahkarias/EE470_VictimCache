onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lru_testbench/clk
add wave -noupdate /lru_testbench/reset
add wave -noupdate -divider {New Divider}
add wave -noupdate /lru_testbench/add_cache
add wave -noupdate -radix binary /lru_testbench/lru_update
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix binary /lru_testbench/lru_number
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {529 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {1 ns}

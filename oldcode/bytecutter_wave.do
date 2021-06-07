onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bytecutter_testbench/clk
add wave -noupdate -radix hexadecimal /bytecutter_testbench/block_in
add wave -noupdate /bytecutter_testbench/offset
add wave -noupdate -radix hexadecimal /bytecutter_testbench/byte_out
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix hexadecimal /bytecutter_testbench/dut/word
add wave -noupdate -divider mux1
add wave -noupdate {/bytecutter_testbench/dut/genblk1[0]/muxer1/data}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {46 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 718
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
WaveRestoreZoom {0 ps} {527 ps}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /victim_cache_testbench/clk
add wave -noupdate /victim_cache_testbench/reset
add wave -noupdate -divider inputs
add wave -noupdate -radix hexadecimal -childformat {{{/victim_cache_testbench/page_offset[11]} -radix hexadecimal} {{/victim_cache_testbench/page_offset[10]} -radix hexadecimal} {{/victim_cache_testbench/page_offset[9]} -radix hexadecimal} {{/victim_cache_testbench/page_offset[8]} -radix hexadecimal} {{/victim_cache_testbench/page_offset[7]} -radix hexadecimal} {{/victim_cache_testbench/page_offset[6]} -radix hexadecimal} {{/victim_cache_testbench/page_offset[5]} -radix hexadecimal} {{/victim_cache_testbench/page_offset[4]} -radix hexadecimal} {{/victim_cache_testbench/page_offset[3]} -radix hexadecimal} {{/victim_cache_testbench/page_offset[2]} -radix hexadecimal} {{/victim_cache_testbench/page_offset[1]} -radix hexadecimal} {{/victim_cache_testbench/page_offset[0]} -radix hexadecimal}} -subitemconfig {{/victim_cache_testbench/page_offset[11]} {-height 15 -radix hexadecimal} {/victim_cache_testbench/page_offset[10]} {-height 15 -radix hexadecimal} {/victim_cache_testbench/page_offset[9]} {-height 15 -radix hexadecimal} {/victim_cache_testbench/page_offset[8]} {-height 15 -radix hexadecimal} {/victim_cache_testbench/page_offset[7]} {-height 15 -radix hexadecimal} {/victim_cache_testbench/page_offset[6]} {-height 15 -radix hexadecimal} {/victim_cache_testbench/page_offset[5]} {-height 15 -radix hexadecimal} {/victim_cache_testbench/page_offset[4]} {-height 15 -radix hexadecimal} {/victim_cache_testbench/page_offset[3]} {-height 15 -radix hexadecimal} {/victim_cache_testbench/page_offset[2]} {-height 15 -radix hexadecimal} {/victim_cache_testbench/page_offset[1]} {-height 15 -radix hexadecimal} {/victim_cache_testbench/page_offset[0]} {-height 15 -radix hexadecimal}} /victim_cache_testbench/page_offset
add wave -noupdate -radix unsigned /victim_cache_testbench/data_in
add wave -noupdate /victim_cache_testbench/write_en
add wave -noupdate -radix unsigned /victim_cache_testbench/phys_tag_ret
add wave -noupdate /victim_cache_testbench/tlb_miss
add wave -noupdate -divider outputs
add wave -noupdate -radix hexadecimal /victim_cache_testbench/byte_out
add wave -noupdate /victim_cache_testbench/is_found
add wave -noupdate -radix unsigned /victim_cache_testbench/block_out
add wave -noupdate -divider {internal data ports}
add wave -noupdate -radix unsigned -childformat {{{/victim_cache_testbench/dut/cache_data_out[7]} -radix unsigned} {{/victim_cache_testbench/dut/cache_data_out[6]} -radix unsigned} {{/victim_cache_testbench/dut/cache_data_out[5]} -radix unsigned} {{/victim_cache_testbench/dut/cache_data_out[4]} -radix unsigned} {{/victim_cache_testbench/dut/cache_data_out[3]} -radix unsigned} {{/victim_cache_testbench/dut/cache_data_out[2]} -radix unsigned} {{/victim_cache_testbench/dut/cache_data_out[1]} -radix unsigned} {{/victim_cache_testbench/dut/cache_data_out[0]} -radix unsigned}} -expand -subitemconfig {{/victim_cache_testbench/dut/cache_data_out[7]} {-height 15 -radix unsigned} {/victim_cache_testbench/dut/cache_data_out[6]} {-height 15 -radix unsigned} {/victim_cache_testbench/dut/cache_data_out[5]} {-height 15 -radix unsigned} {/victim_cache_testbench/dut/cache_data_out[4]} {-height 15 -radix unsigned} {/victim_cache_testbench/dut/cache_data_out[3]} {-height 15 -radix unsigned} {/victim_cache_testbench/dut/cache_data_out[2]} {-height 15 -radix unsigned} {/victim_cache_testbench/dut/cache_data_out[1]} {-height 15 -radix unsigned} {/victim_cache_testbench/dut/cache_data_out[0]} {-height 15 -radix unsigned}} /victim_cache_testbench/dut/cache_data_out
add wave -noupdate -radix hexadecimal /victim_cache_testbench/dut/pv_data_out
add wave -noupdate /victim_cache_testbench/dut/valid_data
add wave -noupdate -divider debugging
add wave -noupdate /victim_cache_testbench/dut/reset_TL_TV_reg
add wave -noupdate /victim_cache_testbench/dut/reset_tl_tv_found_targ_pipeline
add wave -noupdate /victim_cache_testbench/dut/pre_tl_tl_writeEn_pipeline
add wave -noupdate /victim_cache_testbench/dut/tlb_miss
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {554459 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 361
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
WaveRestoreZoom {0 ps} {892500 ps}

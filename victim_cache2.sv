/*
    Lawrence Atienza
    EE 470

    This is the better victim cache


*/

`timescale 1ns/10ps
module victim_cache (page_offset, data_in, write_en, phys_tag_ret, tlb_miss, reset, clk, byte_out, is_found, block_out);
	input logic [11:0] page_offset;
		//this is the part of vaddr that isnt the vtag
	input logic [511:0] data_in;
		//this is the data to overwrite part of the cache
	input logic write_en;
		//this is the toggle to actually use data_in
	input logic [43:0] phys_tag_ret;
		//this is the incoming physical tag from the tlb in the retieval pipeline
        //NOTE: this arrives a cycle late
	input logic tlb_miss;
		//this is true on a tlb miss
		//NOTE: this arrives a cycle late
	input logic reset;
    input logic clk;
		//this is the clk

	output logic [7:0] byte_out;
		//the result of the victim cache search
	output logic is_found;
		//triggered if data is actually found in the data cache
    output logic [511:0] block_out;
        //used to contain evicted block
	

    //Expected Outputs:
    /*
        byte_out: 
            0x00 on a failed fetch
            8 bit correct data on a successful fetch 
            8 bit garbage on a write
        is_found:
            0b1 on a sucessful fetch
            0b0 on a failed fetch
            0b0 on a write
        block_out:
            512 bit block that contains the selected byte on a read
            512 bit block that contains the evicted data on a write
    */

    //NOTE: this will break if you write with a block with the same ptag+vindex as an existing block, don't do that

    //TODO LATER: this cache is always reading or writing, can't I put a read signal?

    /* //////////////////////////////////////
	PRE TL
	////////////////////////////////////// */
    //declaring outputs of the pipeline (for use in next one)
    logic [5:0] pretl_tl_vindex_pipeline;
    logic [5:0] pretl_tl_offset_pipeline;
    logic [511:0] pretl_tl_dataIn_pipeline;
    logic pre_tl_tl_writeEn_pipeline;

    //pipeline registers
    register #(.width(6)) pretl_tl_vindex_pipeline_reg (.data_out(pretl_tl_vindex_pipeline), .data_in(page_offset[11:6]), .write_en(1'b1), .reset(reset), .clk(clk));
    register #(.width(6)) pretl_tl_offset_pipeline_reg (.data_out(pretl_tl_offset_pipeline), .data_in(page_offset[5:0]), .write_en(1'b1), .reset(reset), .clk(clk));
    register #(.width(512)) pretl_tl_dataIn_pipeline_reg (.data_out(pretl_tl_dataIn_pipeline), .data_in(data_in), .write_en(1'b1), .reset(reset), .clk(clk));
    register #(.width(1)) pre_tl_tl_writeEn_pipeline_reg (.data_out(pre_tl_tl_writeEn_pipeline), .data_in(write_en), .write_en(1'b1), .reset(reset), .clk(clk));




    /* //////////////////////////////////////
	TL
	////////////////////////////////////// */
    logic reset_TL_TV_reg;
    assign reset_TL_TV_reg = reset || (tlb_miss && !pre_tl_tl_writeEn_pipeline);
        //the registers at the end of this section reset on two occassions:
        //1. If the reset is triggered
        //2. If the TLB misses, AND it is not in write mode

    logic tlb_miss_unfluxed;
    mux2_1 tlb_smasher (.out(tlb_miss_unfluxed), .i0(tlb_miss), .i1(1'b0), .sel(pre_tl_tl_writeEn_pipeline));
        //Here's a scenario, I am writing but tlb_miss gets a junk 1.
        //Now this could mess everything up by squashing pipelines registers + disabling writes on the data blocks + lru controller
        //The code ~6 lines above solves the former, and this solves the latter by forcing tlb misses to be 0 during a write 
        //so this is just tlb_miss, but with a guaranteed value of 0 during a write

    logic [49:0] ptag_vindex;
    assign ptag_vindex = {phys_tag_ret, pretl_tl_vindex_pipeline};
        //this is the ptag+vindex


    //////////// LRU CONTROLLER
    logic [7:0] lru_info;
        //this contains the bits that signify which block is the lru 

    logic [7:0] comparator_output;
        //this contains the output of the comparator which shows which block has the correct data

    logic [7:0] lru_update;
        //this contains the inforamtion that is entering the LRU
        //This is different from comparator_output because tlb_miss_unfluxed makes sure that this signal is zero on a read

    genvar k;
    generate
        for (k = 0; k < 8; k = k + 1) begin
            mux2_1 lru_update_muxer (.out(lru_update[k]), .i0(comparator_output[k]), .i1(1'b0), .sel(tlb_miss_unfluxed));
        end
        //this is the part that zeros out lru_update on a miss
    endgenerate

    lru lru_controller (.lru_number(lru_info), .lru_update(lru_update), .add_cache(pre_tl_tl_writeEn_pipeline), .reset(reset), .clk(clk));

    
    //////////// Comparator
    logic [49:0] pv_data_out [7:0];
        //this is the output of the tag+index memory
    logic [7:0] valid_data;
        //these are the valid tags from tag+index memory
    logic found_target;
        //this goes into a pipeline

    
    genvar a;
    generate
        for (a = 0; a < 8; a = a + 1) begin
            assign comparator_output[a] = (pv_data_out[a] ==  ptag_vindex) && valid_data[a];
        end
    endgenerate

    assign found_target = |comparator_output;
        //reduction operator on the output of comparator
    
    //////////// tag+index data (and validity)
    logic [7:0] tagindex_memory_write;
        //this controls if a specific tag block should be written to 

    genvar b;
    generate 
        for (b = 0; b < 8; b = b + 1) begin
            assign tagindex_memory_write[b] = (pre_tl_tl_writeEn_pipeline && lru_info[b]) && !tlb_miss_unfluxed; 
            //this will set which tag memory block should be written to, but also stops all writes on a tlb_miss

            register #(.width(50)) ptag_vindex_data_block (.data_out(pv_data_out[b]), .data_in(ptag_vindex), .write_en(tagindex_memory_write[b]), .reset(reset), .clk(clk));
            //outputs to the 2d array
            //takes in ptag_vindex value, with the earlier boolean logic controling which one gets written to.

            register #(.width(1)) valid_data_block (.data_out(valid_data[b]), .data_in(1'b1), .write_en(tagindex_memory_write[b]), .reset(reset), .clk(clk));
            //memory is always valid after first write
        end
    endgenerate

    //////////// actual data cache
    logic [511:0] target_block;
        //on read, it holds the target output
        //on write, it holds the evicted block

    logic [7:0] data_write_control;
        //controls writes
    
    logic [511:0] cache_data_out [7:0];
        //output wires for the data blocks

    logic [7:0] output_selector;
        //on a read, this should point to the block to read
        //on a write, this should point to the evicted block

    genvar c;
    generate
        for (c = 0; c < 8; c = c + 1) begin
            assign data_write_control[c] = (pre_tl_tl_writeEn_pipeline && lru_info[c]) && !tlb_miss_unfluxed;
            //this will set which data block should be written to, but also stops all writes on a tlb_miss
            //technically this is the same as tagindex_memory_write but I'm too lazy to change it now.

            register #(.width(512)) actual_data_block (.data_out(cache_data_out[c]), .data_in(pretl_tl_dataIn_pipeline), .write_en(data_write_control[c]), .reset(reset), .clk(clk));
            //outputs to the 2d array

            mux2_1 output_selector_selector_mux (.out(output_selector[c]), .i0(comparator_output[c]), .i1(lru_info[c]), .sel(pre_tl_tl_writeEn_pipeline));
            //this creates the behavior for output_selector
            //this isnt connected to anything yet, its the next lines that achieves that
        end
    endgenerate

    always_comb begin   
        //this is a bit of a mess , i wanted to use gate level logic but ended up using rtl to make it easier
        //easily the part that needs to be rewritten the most
        if (output_selector[0] == 1'b1)
            target_block = cache_data_out[0];
        else if (output_selector[1] == 1'b1)
            target_block = cache_data_out[1];
        else if (output_selector[2] == 1'b1)
            target_block = cache_data_out[2];
        else if (output_selector[3] == 1'b1)
            target_block = cache_data_out[3];
        else if (output_selector[4] == 1'b1)
            target_block = cache_data_out[4];
        else if (output_selector[5] == 1'b1)
            target_block = cache_data_out[5];
        else if (output_selector[6] == 1'b1)
            target_block = cache_data_out[6];
        else if (output_selector[7] == 1'b1)
            target_block = cache_data_out[7];
        else 
            target_block = 512'bX;
            //this output is junkfied because if there is no output selector, then that means the read failed and thus the output doesnt actually matter
    end



    //////////// pipeline
    //declaring outputs of the pipeline (for use in next one)
    logic tl_tv_found_target_pipeline;
    logic [511:0] tl_tv_target_block_pipeline;
        //on read, it holds the target output
        //on write, it holds the evicted block
    logic [5:0] tl_tv_offset_pipeline;
        //just copy this pretl_tl_offset_pipeline

    logic reset_tl_tv_found_targ_pipeline;
    assign reset_tl_tv_found_targ_pipeline = (reset || pre_tl_tl_writeEn_pipeline) || tlb_miss;
    register #(.width(1)) tl_tv_found_target_pipeline_reg (.data_out(tl_tv_found_target_pipeline), .data_in(found_target), .write_en(1'b1), .reset(reset_tl_tv_found_targ_pipeline), .clk(clk));

    register #(.width(512)) tl_tv_target_block_pipeline_reg (.data_out(tl_tv_target_block_pipeline), .data_in(target_block), .write_en(1'b1), .reset(reset_TL_TV_reg), .clk(clk));

    register #(.width(6)) tl_tv_offset_pipeline_reg (.data_out(tl_tv_offset_pipeline), .data_in(pretl_tl_offset_pipeline), .write_en(1'b1), .reset(reset_TL_TV_reg), .clk(clk));
    //pipelines here use the reset_TL_TV_reg signal
    //tl_tv_found_target_pipeline register instead uses (reset || !pre_tl_tl_writeEn_pipeline || tlb_miss)
        //this means it resets on a restart and whenever a fetch fails OR it is in write mode
        //this is to describe the behavior of the signal on a readmode instead of garbage







    /* //////////////////////////////////////
	TV
	////////////////////////////////////// */
    //declaring logic signals
    logic [63:0] selected_word;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin
            mux8_1 muxer1 (.out(selected_word[i]), 
                .data({
                    tl_tv_target_block_pipeline[i+448],
                    tl_tv_target_block_pipeline[i+384],
                    tl_tv_target_block_pipeline[i+320],
                    tl_tv_target_block_pipeline[i+256],
                    tl_tv_target_block_pipeline[i+192],
                    tl_tv_target_block_pipeline[i+128],
                    tl_tv_target_block_pipeline[i+64],
                    tl_tv_target_block_pipeline[i]}), 
                .sel(tl_tv_offset_pipeline[5:3]));
        end
        //this generates the stuff that picks which word
    endgenerate

    //declaring outputs of the pipeline (for use in next one)
    logic tv_dm_found_target_pipeline;
    logic [511:0] tv_dm_target_block_pipeline;
    logic [2:0] tv_dm_byte_select_pipeline;
    logic [63:0] tv_dm_selected_word_pipeline;

    register #(.width(1)) tv_dm_found_target_pipeline_reg (.data_out(tv_dm_found_target_pipeline), .data_in(tl_tv_found_target_pipeline), .write_en(1'b1), .reset(reset), .clk(clk));
    register #(.width(512)) tv_dm_target_block_pipeline_reg (.data_out(tv_dm_target_block_pipeline), .data_in(tl_tv_target_block_pipeline), .write_en(1'b1), .reset(reset), .clk(clk));
    register #(.width(3)) tv_dm_byte_select_pipeline_reg (.data_out(tv_dm_byte_select_pipeline), .data_in(tl_tv_offset_pipeline[2:0]), .write_en(1'b1), .reset(reset), .clk(clk));
    register #(.width(64)) tv_dm_selected_word_pipeline_reg (.data_out(tv_dm_selected_word_pipeline), .data_in(selected_word), .write_en(1'b1), .reset(reset), .clk(clk));





    /* //////////////////////////////////////
	DM
	////////////////////////////////////// */
    //declaring logic signals
    logic [7:0] selected_byte;

    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin
            mux8_1 dm_muxer (.out(selected_byte[j]), 
                .data({
                    tv_dm_selected_word_pipeline[j+56],
                    tv_dm_selected_word_pipeline[j+48],
                    tv_dm_selected_word_pipeline[j+40],
                    tv_dm_selected_word_pipeline[j+32],
                    tv_dm_selected_word_pipeline[j+24],
                    tv_dm_selected_word_pipeline[j+16],
                    tv_dm_selected_word_pipeline[j+8],
                    tv_dm_selected_word_pipeline[j]}), 
                .sel(tv_dm_byte_select_pipeline));
        end
        //this generates the stuff that picks which byte
    endgenerate

    assign byte_out = selected_byte;
    assign is_found = tv_dm_found_target_pipeline;
    assign block_out = tv_dm_target_block_pipeline;

endmodule














module victim_cache_testbench;
    parameter ClockDelay = 50;

    //inputs
    logic [11:0] page_offset;
        //remember that vindex is the first 6 bits
        //and that the word/byte selector is the last 6 bits
	logic [511:0] data_in;
	logic write_en;
	logic [43:0] phys_tag_ret;
        //NOTE: this arrives a cycle late, but the testbench handles that
	logic tlb_miss;
		//NOTE: this arrives a cycle late, but the testbench handles that
	logic reset;
    logic clk;

    //outputs
	logic [7:0] byte_out;
	logic is_found;
    logic [511:0] block_out;
    
    initial begin // Set up the clock
		clk <= 1;
		forever #(ClockDelay/2) clk <= ~clk;
	end

    logic [43:0] phys_tag_ret_delayed;
    logic tlb_miss_delayed;
        //these represent the delay

    always_ff @(posedge clk) begin
        tlb_miss_delayed <= tlb_miss;
        phys_tag_ret_delayed <= phys_tag_ret;
	end

    victim_cache dut (.page_offset, .data_in, .write_en, .phys_tag_ret(phys_tag_ret_delayed), .tlb_miss(tlb_miss_delayed), .reset, .clk, .byte_out, .is_found, .block_out);

    initial begin
        @(posedge clk);
            //reset stage
            reset <= 1'b1;
            phys_tag_ret <= 44'h0;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'h0;
            write_en <= 1'b0;   
        $display("RESET COMPLETE");
        $display("TESTING WRITING");
        @(posedge clk);
            //write for the first time
            reset <= 1'b0;
            phys_tag_ret <= 44'h1;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'h111;
            write_en <= 1'b1;
        @(posedge clk);
            //gonna fill up the writes
            reset <= 1'b0;
            phys_tag_ret <= 44'h2;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'h222;
            write_en <= 1'b1; 
        @(posedge clk);
            reset <= 1'b0;
            phys_tag_ret <= 44'hA;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'hAAA;
            write_en <= 1'b1; 
        @(posedge clk);
            reset <= 1'b0;
            phys_tag_ret <= 44'hB;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'hBBB;
            write_en <= 1'b1; 
        @(posedge clk);
            reset <= 1'b0;
            phys_tag_ret <= 44'hC;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'hCCC;
            write_en <= 1'b1; 
        @(posedge clk);
            reset <= 1'b0;
            phys_tag_ret <= 44'hD;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'hDDD;
            write_en <= 1'b1;
        @(posedge clk);
            reset <= 1'b0;
            phys_tag_ret <= 44'hE;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'hEEE;
            write_en <= 1'b1; 
        @(posedge clk);
            reset <= 1'b0;
            phys_tag_ret <= 44'hF;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'hFFF;
            write_en <= 1'b1; 
            $display("FILLING LAST CACHE SLOT");
        @(posedge clk);
            $display("READ FIRST CACHE SLOT");
            //read the first slot
            reset <= 1'b0;
            phys_tag_ret <= 44'h1;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'h111;
            write_en <= 1'b0;
        @(posedge clk);
            $display("FILL LRU");
            //do a write, this should evict the second slot
            reset <= 1'b0;
            phys_tag_ret <= 44'hABC;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'h999;
            write_en <= 1'b1; 
        @(posedge clk);
            $display("READ THE LOAD FROM LAST CYCLE");
            //immediately read new slot, should output the new information
            reset <= 1'b0;
            phys_tag_ret <= 44'hABC;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'h999;
            write_en <= 1'b0; 
        @(posedge clk);
            $display("SEARCH WITH TLB MISS");
            //this should report a fail, because of the tlb miss
            //this has the same search charatcerissts as the last one for easy checking:
                //if it reports found, then the tlb squasher is not working
            reset <= 1'b0;
            phys_tag_ret <= 44'hABC;
            tlb_miss <= 1'b1;
            page_offset <= 12'h0;
            data_in <= 512'h999;
            write_en <= 1'b0; 
        @(posedge clk);
            $display("SEARCH WITH TAG MISS");
            //this should report a fail, 
            reset <= 1'b0;
            phys_tag_ret <= 44'hCAB;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'h999;
            write_en <= 1'b0; 
        @(posedge clk);
            $display("READ FIRST CACHE SLOT");
            //the previous cycle outputs garbage in byte_out and block_out due to the miss
            //this is to make sure that it can output real values again
            //read the first slot
            reset <= 1'b0;
            phys_tag_ret <= 44'h1;
            tlb_miss <= 1'b0;
            page_offset <= 12'h0;
            data_in <= 512'h111;
            write_en <= 1'b0;

        @(posedge clk); write_en <= 1'b0; @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); 
        @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);
        //TODO: need to test write with tlb miss being true (testing junk removal)
		$stop;
    end

endmodule

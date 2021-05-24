

`timescale 1ns/10ps
module victim_cache (addr_in, data_in, write_en, phys_tag_ret, tlb_miss, phys_tag_str, reset, byte_out, data_out, found_out, clk);
	input logic [11:0] addr_in;
		//this is the part of vaddr that isnt the vtag
	input logic [511:0] data_in;
		//this is the data to overwrite part of the cache
	input logic write_en;
		//this is the toggle to actually use data_in
	input logic [43:0] phys_tag_ret;
		//this is the incoming physical tag from the tlb in the retieval pipeline
	input logic tlb_miss;
		//this is true on a tlb miss
	input logic [43:0] phys_tag_str;
		//this is the incoming physical tag from the tlb in the storage pipeline
	input logic reset;
	output logic [7:0] byte_out;
		//the result of the victim cache search
	output logic [511:0] data_out;
		//data out, theorically will be sent to L1 dcache to replace a value there
		//this is triggered when a value is 
	output logic found_out;
		//triggered if data is actually found in the data cache
	input logic clk;
		//this is the clk

	/*
		The original cache has 8 sets with 8 blocks per set
			Each block is tagged physically, so a 44 bit tag is on each block
		
		Victim cache has 8 blocks
			each block is tagged physically, 44 bit tag on each block + 6 bits from the index (stored for validation reasons)
			also a bit for valid

		victim cache has these steps to retrieve data
			CYCLE 1: select the correct byte 
				if tlb_miss comes in true at the end of this stage, squash the next one
			CYCLE 2: select the correct block 
				this order looks weird, but we dont get the physical tag immediately, only after 1 cycle
				thus we want to be able to do work before then

		victim cache has these steps to store data
			immediately store tag and data in LRU
			note that the cache will only output the new data in the next cycle, no passthrough here
	*/

	//NOTE ON 2d array syntax:
	//logic [31:0][63:0] regOutput;
	//	creates an array of size 32, with each index containing 64 bits
	//	regOutput[i] accesses index i.

	/* //////////////////////////////////////
	CACHE DECLARIONS
	////////////////////////////////////// */
	logic [7:0][511:0] blks;
	logic [7:0][43:0] phys_tag;
	logic [7:0][5:0] index_bits;
	logic [7:0] valid_bits;
		//these are outputs

	logic [511:0] cache_input;
	logic [43:0] tag_input;
	logic [5:0] index_input;
	logic valid_input;
		//these are write inputs
		//TODO use these

	logic [7:0] write_en_array;
		//this controls which blocks are written to

	genvar j;
    generate
        for (j = 0; j < 7; j = j + 1) begin
			register #(.width(512)) cache_block (.data_out(blks[j]), .data_in(cache_input), .write_en(write_en_array[j]), .reset(reset), .clk(clk));
				//this generates the data cache
			register #(.width(44)) tag_block (.data_out(phys_tag[j]), .data_in(tag_input), .write_en(write_en_array[j]), .reset(reset), .clk(clk));
				//this generates the tag blocks
			register #(.width(6)) index_block (.data_out(index_bits[j]), .data_in(index_input), .write_en(write_en_array[j]), .reset(reset), .clk(clk));	
				//this generates the stuff that stores the index bits
			register #(.width(1)) valid_block (.data_out(valid_bits[j]), .data_in(valid_input), .write_en(write_en_array[j]), .reset(reset), .clk(clk));	
				//this generates the stuff that stores the valid bits
        end
    endgenerate



	//TODO: declare triangular lru storage
	//TODO: lru bits will need to have a default value loaded

	
	/* //////////////////////////////////////
	Load CYCLE 1
	////////////////////////////////////// */
	logic [7:0][7:0] cut_bytes;
	genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
			bytecutter cutter (.block_in(blks[i]), .offset(addr_in[5:0]), .byte_out(cut_bytes[i]));
        end
        //this finds the wanted byte from each cache block
    endgenerate

	logic [7:0][7:0] cut_bytes_pipeline;
	logic [7:0][43:0] phys_tag_pipeline;
	logic [7:0][5:0] index_bits_pipeline;
	logic [7:0] valid_bits_pipeline;
		//TODO use these
	//after this is the pipeline stuff
	genvar k;
    generate
        for (k = 0; k < 7; k = k + 1) begin
			register #(.width(8)) piped_byte (.data_out(cut_bytes_pipeline[k]), .data_in(cut_bytes[k]), .write_en(1'b1), .reset(tlb_miss | reset), .clk(clk));
			register #(.width(44)) piped_tag (.data_out(phys_tag_pipeline[j]), .data_in(phys_tag[k]), .write_en(1'b1), .reset(tlb_miss | reset), .clk(clk));
			register #(.width(6)) index_block (.data_out(index_bits_pipeline[j]), .data_in(index_bits[k]), .write_en(1'b1), .reset(tlb_miss | reset), .clk(clk));	
			register #(.width(1)) valid_block (.data_out(valid_bits_pipeline[j]), .data_in(valid_bits[k]), .write_en(1'b1), .reset(tlb_miss | reset), .clk(clk));	
			//pipeline registers, the tlb_miss squashes all output
        end
    endgenerate


	/* //////////////////////////////////////
	Load CYCLE 2
	////////////////////////////////////// */
	//TODO: comparator with the incoming phys tag from tlb vs stored phys_tag
	//TODO: also comparator between stored index bits and index bits from (addr_in[11:6])
		//this is so that we can make sure that we have the exact data that we want
	//TODO: then output

	/* //////////////////////////////////////
	store data
	////////////////////////////////////// */
	//TODO: find the lru code
		//NOTE: LOOK AT PAPER ON DESK
	//TODO: update cache block with new data
	//TODO: update lru bits
endmodule

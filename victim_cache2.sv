

`timescale 1ns/10ps
module victim_cache (page_offset, data_in, write_en, phys_tag_ret, tlb_miss, reset, clk, byte_out, is_found);
	input logic [11:0] page_offset;
		//this is the part of vaddr that isnt the vtag
	input logic [511:0] data_in;
		//this is the data to overwrite part of the cache
	input logic write_en;
		//this is the toggle to actually use data_in
	input logic [43:0] phys_tag_ret;
		//this is the incoming physical tag from the tlb in the retieval pipeline
        //NOTE: this arrives a cycle late
        //TODO USE THIS
	input logic tlb_miss;
		//this is true on a tlb miss
		//NOTE: this arrives a cycle late
        //TODO USE THIS
	input logic reset;
        //TODO USE THIS
    input logic clk;
		//this is the clk
        //TODO USE THIS

	output logic [7:0] byte_out;
		//the result of the victim cache search
		//TODO USE THIS
	output logic is_found;
		//triggered if data is actually found in the data cache
		//TODO USE THIS
	
    /* //////////////////////////////////////
	PRE TL
	////////////////////////////////////// */
    //declaring outputs of the pipeline (for use in next one)
    logic [5:0] pretl_tl_vindex_pipeline;
    logic [5:0] pretl_tl_offset_pipeline;
    logic [511:0] pretl_tl_dataIn_pipeline
    logic pre_tl_tl_writeEn_pipeline;

    //pipeline registers
    register #(.width(6)) pretl_tl_vindex_pipeline_reg (.data_out(pretl_tl_vindex_pipeline), .data_in(page_offset[11:6]), .write_en(1'b1), .reset(reset), .clk(clk));
    register #(.width(6)) pretl_tl_offset_pipeline_reg (.data_out(pretl_tl_offset_pipeline), .data_in(page_offset[5:0]), .write_en(1'b1), .reset(reset), .clk(clk));
    register #(.width(512)) pretl_tl_dataIn_pipeline_reg (.data_out(pretl_tl_dataIn_pipeline), .data_in(data_in), .write_en(1'b1), .reset(reset), .clk(clk));
    register #(.width(1)) pre_tl_tl_writeEn_pipeline_reg (.data_out(pre_tl_tl_writeEn_pipeline), .data_in(write_en), .write_en(1'b1), .reset(reset), .clk(clk));

    /* //////////////////////////////////////
	TL
	////////////////////////////////////// */
    //declaring logic signals

    //TODO: take phystagret input
    //TODO: take tlb miss input
    
    //TODO: scan vindex memory for hit
        //TODO: if so, output and update lru
    //TODO:

    //declaring outputs of the pipeline (for use in next one)


    /* //////////////////////////////////////
	TV
	////////////////////////////////////// */
    //declaring logic signals
    //TODO: select word

    //declaring outputs of the pipeline (for use in next one)


    /* //////////////////////////////////////
	DM
	////////////////////////////////////// */
    //declaring logic signals

    //TODO: select byte
    //TODO: output byte and isFound
    //MAYBE: output that stuff that was overrideden on a write?


endmodule

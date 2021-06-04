

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
        //TODO USE THIS
	input logic reset;
    input logic clk;
		//this is the clk

	output logic [7:0] byte_out;
		//the result of the victim cache search
		//TODO USE THIS
	output logic is_found;
		//triggered if data is actually found in the data cache
		//TODO USE THIS
    output logic [511:0] block_out;
        //used to contain evicted block
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
    logic reset_TL_TV_reg;
    assign reset_TL_TV_reg = reset || (tlb_miss && !pre_tl_tl_writeEn_pipeline);
        //the registers after this section reset on two occassions:
        //1. If the reset is triggered
        //2. If the TLB misses, and it is not in write mode

    logic [49:0] ptag_vindex;
    assign ptag_vindex = {phys_tag_ret, pretl_tl_vindex_pipeline};
        //this is the ptag+vindex



































    //TODO create data cache








    lru lru_controller (.lru_number(), .lru_update(), .add_cache(), .reset(), .clk());


    logic found_target;
    logic [511:0] target_block;
    logic offset;


    //TODO: take phystagret input
    //TODO: take tlb miss input
    
    //TODO: scan vindex memory for hit
        //TODO: if so, output and update lru
    //TODO:

    //declaring outputs of the pipeline (for use in next one)
    logic tl_tv_found_target_pipeline;
    logic [511:0] tl_tv_target_block_pipeline;
    logic [5:0] tl_tv_offset_pipeline;
        //on read, it holds the target output
        //on write, it holds the evicted block

    //TODO: make pipelines (reset them on a tlb miss if read)




    /* //////////////////////////////////////
	TV
	////////////////////////////////////// */
    //declaring logic signals
    //TODO: select word
    //TODO: passthrough target block














    //declaring outputs of the pipeline (for use in next one)
    logic tv_dm_found_target_pipeline;
    logic [511:0] tv_dm_target_block_pipeline;
    logic [2:0] tv_dm_byte_select_pipeline;
    logic [63:0] tv_dm_selected_work_pipeline;








    


    /* //////////////////////////////////////
	DM
	////////////////////////////////////// */
    //declaring logic signals

    //TODO: select byte
    //TODO: output byte and isFound
    //output















endmodule

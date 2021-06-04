

`timescale 1ns/10ps
module victim_cache (addr_in, data_in, write_en, phys_tag_ret, tlb_miss, reset, clk, byte_out, is_found);
	input logic [11:0] addr_in;
		//this is the part of vaddr that isnt the vtag
        //TODO USE THIS
	input logic [511:0] data_in;
		//this is the data to overwrite part of the cache
		//TODO USE THIS
	input logic write_en;
		//this is the toggle to actually use data_in
		//TODO USE THIS
	input logic [43:0] phys_tag_ret;
		//this is the incoming physical tag from the tlb in the retieval pipeline
        //NOTE: this arrives a cycle late
        //TODO USE THIS
	input logic tlb_miss;
		//this is true on a tlb miss
		//this DOES NOT COME A CYCLE LATE, but at the end of the cycle
        //NOTE: this arrives a cycle late
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

    /* //////////////////////////////////////
	TL
	////////////////////////////////////// */

    /* //////////////////////////////////////
	TV
	////////////////////////////////////// */

    /* //////////////////////////////////////
	DM
	////////////////////////////////////// */
endmodule

/*
    Lawrence Atienza
    EE 470

    This module is a 512 bit register that can store data. The data can be edited by passing in
	a value into the input and also triggering the write wire.

	Note: there is no reset, thus the register will show up as red (garbage) on modelsim until
	data is fed into it. I personally feel that this is closer to reality (a register holding random values
	from past use until given a value), and makes debugging easier due to the red line showing up
	if a calculation uses a value from a garbage filled register.
*/

module regx64 (data_out, data_in, write_en, clk);
	output logic [511:0] data_out;
	input logic [511:0] data_in;
	input logic write_en;
	input logic clk;
	
	logic [511:0] next;

	genvar i;
	generate
		for (i = 0; i < 512; i = i + 1) begin : reg_gen
			mux2_1 controller (.out(next[i]), .i0(data_out[i]), .i1(data_in[i]), .sel(write_en));
			D_FF singFF (.q(data_out[i]), .d(next[i]), .reset(1'b0), .clk(clk));
		end
	endgenerate
	//this is a line of 512 DFFs that have a mux on the input. The mux controls if the DFF's take a new
	//input value or stay steady.

endmodule

module regx64_testbench;
    parameter ClockDelay = 50;

    logic [511:0] data_out;
	logic [511:0] data_in;
	logic write_en;
	logic clk;
    initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
    regx64 dut (.data_out, .data_in, .write_en, .clk);
    
    

    initial begin
        @(posedge clk); data_in <= 64'h0000000000000000; write_en <= 1;
		@(posedge clk); data_in <= 64'h0000000000000000; write_en <= 0;
		@(posedge clk); data_in <= 64'h000000000000AA00; write_en <= 1;
		@(posedge clk); data_in <= 64'h000000000000AA00; write_en <= 0;
		@(posedge clk); data_in <= 64'h00000000BB000000; write_en <= 0;
		@(posedge clk); data_in <= 64'h00000000BB000000; write_en <= 1;
		@(posedge clk); data_in <= 64'h0000000000000000; write_en <= 0;
        @(posedge clk); 
		$stop;
    end

endmodule
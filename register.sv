
// register to store information between stages
// different info will have different width
// instr -> width = 32
// register info -> width = 5
// data -> width = 64
// control logics -> width = 1

module register #(parameter width = 1) (data_out, data_in, write_en, reset, clk);
	output logic [width-1:0] data_out;
	input logic [width-1:0] data_in;
    input logic write_en;
	input logic clk;
	input logic reset;
	
	genvar i;
	generate
		for (i = 0; i < width; i++) begin : eachDFF
            mux2_1 controller (.out(next[i]), .i0(data_out[i]), .i1(data_in[i]), .sel(write_en));
            D_FF singFF (.q(data_out[i]), .d(next[i]), .reset(reset), .clk(clk));
		end
	endgenerate
endmodule


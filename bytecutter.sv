
module bytecutter (block_in, offset, byte_out);
    input logic [511:0] block_in;
    input logic [5:0] offset;
    output logic [7:0] byte_out;

    logic [63:0] word;

    
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin
            mux8_1 muxer1 (.out(word[i]), 
                .data({
                    block_in[i+448],
                    block_in[i+384],
                    block_in[i+320],
                    block_in[i+256],
                    block_in[i+192],
                    block_in[i+128],
                    block_in[i+64],
                    block_in[i]}), 
                .sel(offset[5:3]));
        end
        //this generates the stuff that picks which word
    endgenerate

    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin
            mux8_1 muxer2 (.out(byte_out[j]), 
                .data({
                    word[j+56],
                    word[j+48],
                    word[j+40],
                    word[j+32],
                    word[j+24],
                    word[j+16],
                    word[j+8],
                    word[j]}), 
                .sel(offset[2:0]));
        end
        //this generates the stuff that picks which byte
    endgenerate
endmodule

module bytecutter_testbench;
    parameter ClockDelay = 50;
    logic clk;
    logic [511:0] block_in;
    logic [5:0] offset;
    logic [7:0] byte_out;

    initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

    bytecutter dut (.block_in, .offset, .byte_out);
    
    //remmebr, a byte is 2 hex digits

    initial begin //only 2 words here
             //word seperation           AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB                                                           
        @(posedge clk); block_in <= 512'hFFFFFFFFFFFFFFFFFFFFFFFFFF56AB0F; offset <= 6'b001000;
        @(posedge clk); block_in <= 512'hFFFFFFFFFFFFFFFFFFFFFFFFFF56AB0F; offset <= 6'b000000;
        @(posedge clk); block_in <= 512'hFFFFFFFFFFFFFFFFFFFFFFFFFF56AB0F; offset <= 6'b000001;
        @(posedge clk); block_in <= 512'hFFFFFFFFFFFFFFFFFFFFFFFFFF56AB0F; offset <= 6'b000010;
        @(posedge clk); 
		$stop;
    end

endmodule
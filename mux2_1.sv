/*
    Lawrence Atienza
    EE 469

    This module is a 2-to-1 decoder, taking one wire and outputting
    it to one of 32 output wires, controlled via 5 control wires
*/

module mux2_1(out, i0, i1, sel);
    output logic out;
    input logic i0, i1, sel;
    //from ee271


    assign out = (i1 & sel) | (i0 & ~sel);

endmodule

module mux2_1_testbench;
    parameter ClockDelay = 50;

    logic out;
    logic i0, i1, sel;

    mux2_1 dut (.out, .i0, .i1, .sel);
    
    logic clk;
    initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

    initial begin
        @(posedge clk); sel <= 0; i0 <= 0; i1 <= 0;
        @(posedge clk); sel <= 0; i0 <= 1; i1 <= 0;
        @(posedge clk); sel <= 1; i0 <= 0; i1 <= 0;
        @(posedge clk); sel <= 1; i0 <= 0; i1 <= 1;
        @(posedge clk); sel <= 0; i0 <= 0; i1 <= 0;
        @(posedge clk);
		$stop;
    end

endmodule
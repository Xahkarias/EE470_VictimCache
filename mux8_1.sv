
module mux8_1(out, data, sel);
    output logic out;
    input logic [2:0] sel;
    input logic [7:0] data;

    //000 sel corresponds to data[0]
    //001 data[1]
    //010 data[2]
    //011 data[3]
    //100 data[4]
    //101 data[5]
    //110 data[6]
    //111 data[7]
    logic first1, first2, first3, first4;
    logic second1, second2;

    mux2_1 firstEins (.out(first1), .i0(data[0]), .i1(data[1]), .sel(sel[0]));
    mux2_1 firstZwei (.out(first2), .i0(data[2]), .i1(data[3]), .sel(sel[0]));
    mux2_1 firstDrei (.out(first3), .i0(data[4]), .i1(data[5]), .sel(sel[0]));
    mux2_1 firstVier (.out(first4), .i0(data[6]), .i1(data[7]), .sel(sel[0]));

    mux2_1 secondEins (.out(second1), .i0(first1), .i1(first2), .sel(sel[1]));
    mux2_1 secondZwei (.out(second2), .i0(first3), .i1(first4), .sel(sel[1]));

    mux2_1 thirdEins (.out(out), .i0(second1), .i1(second2), .sel(sel[2]));

endmodule

module mux8_1_testbench;
    parameter ClockDelay = 50;

    logic out;
    logic [2:0] sel;
    logic [7:0] data;

    mux8_1 dut (.out, .data, .sel);
    
    logic clk;
    initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

    initial begin
        @(posedge clk); sel <= 0; data <= 8'b00000000;
        @(posedge clk); sel <= 1; data <= 8'b00000000;
        @(posedge clk); sel <= 2; data <= 8'b00000000;
        @(posedge clk); sel <= 3; data <= 8'b00000000;
        @(posedge clk); sel <= 4; data <= 8'b00000000;
        @(posedge clk); sel <= 5; data <= 8'b00000000;
        @(posedge clk); sel <= 6; data <= 8'b00000000;
        @(posedge clk); sel <= 7; data <= 8'b00000000;

        @(posedge clk); sel <= 0; data <= 8'b11010101;
        @(posedge clk); sel <= 1; data <= 8'b11010101;
        @(posedge clk); sel <= 2; data <= 8'b11010101;
        @(posedge clk); sel <= 3; data <= 8'b11010101;
        @(posedge clk); sel <= 4; data <= 8'b11010101;
        @(posedge clk); sel <= 5; data <= 8'b11010101;
        @(posedge clk); sel <= 6; data <= 8'b11010101;
        @(posedge clk); sel <= 7; data <= 8'b11010101;

        @(posedge clk);
        @(posedge clk);
		$stop;
    end

endmodule
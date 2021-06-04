module lru (lru_number, lru_update, add_cache, reset, clk);
    output logic [7:0] lru_number;
        //each bit corresponds to which thing is the lru
        //this is a constant output
    input logic [7:0] lru_update;
        //change one of these bits to 1 for 1 cycle in order
        //to represent a specific cache block being updated to be most recent
        //leave resting at zero
        //CANNOT BE ON AT THE SAME TIME AS ADD_CACHE
    input logic add_cache;
        ///change one of these bits to 1 for 1 cycle in order
        //to act as an eviction on oldest
        //CANNOT BE ON AT THE SAME TIME AS LRU_UPDATE
    input logic reset;
        //reset
        //7 is the oldest, 0 is the newest in lru
    input logic clk;
    
    //THIS LOOKS LIKE A MESS BUT IT MAKES SENSE (and doesnt use as much silicon as you'd think)
    //notes for myself:
        //triangle is arranged like so:
        /*
            0123456 is older than
            X       1
            XX      2
            XXX     3
            XXXX    4
            XXXXX   5
            XXXXXX  6
            XXXXXXX 7
        */
        //To mark a block as the newest, make all values on its row = 1, and all values on the column = 0
    //NOTE: since all of these are left justified, cache block zero is represented

    //input on wires (these are horizontal and left-justified) (labeled by row)
    logic on_1;
    logic [1:0] on_2;
    logic [2:0] on_3;
    logic [3:0] on_4;
    logic [4:0] on_5;
    logic [5:0] on_6;
    logic [6:0] on_7;
       //TODO: use these
    
    //input off wires (these are horizontal and left-justified) and will be ored with global reset (labeled by row)
    logic off_1;
    logic [1:0] off_2;
    logic [2:0] off_3;
    logic [3:0] off_4;
    logic [4:0] off_5;
    logic [5:0] off_6;
    logic [6:0] off_7;
       //TODO: use these

    //output wires (these are horizontal and left-justified) (labeled by row)
    logic output_1;
    logic [1:0] output_2;
    logic [2:0] output_3;
    logic [3:0] output_4;
    logic [4:0] output_5;
    logic [5:0] output_6;
    logic [6:0] output_7;
 
    //i apologize in advance for this mess
    //these are labeled in column_row notation
    //register is just the normal register, but the zero is the reset and the one is just sending the same signal to write and data in.
    //row 1
    register #(.width(1)) r0_1 (.data_out(output_1), .data_in(on_1), .write_en(on_1), .reset(reset | off_1), .clk(clk));
    //row 2
    register #(.width(1)) r0_2 (.data_out(output_2[1]), .data_in(on_2[1]), .write_en(on_2[1]), .reset(reset | off_2[1]), .clk(clk));
    register #(.width(1)) r1_2 (.data_out(output_2[0]), .data_in(on_2[0]), .write_en(on_2[0]), .reset(reset | off_2[0]), .clk(clk));
    //row 3
    register #(.width(1)) r0_3 (.data_out(output_3[2]), .data_in(on_3[2]), .write_en(on_3[2]), .reset(reset | off_3[2]), .clk(clk));
    register #(.width(1)) r1_3 (.data_out(output_3[1]), .data_in(on_3[1]), .write_en(on_3[1]), .reset(reset | off_3[1]), .clk(clk));
    register #(.width(1)) r2_3 (.data_out(output_3[0]), .data_in(on_3[0]), .write_en(on_3[0]), .reset(reset | off_3[0]), .clk(clk));
    //row 4
    register #(.width(1)) r0_4 (.data_out(output_4[3]), .data_in(on_4[3]), .write_en(on_4[3]), .reset(reset | off_4[3]), .clk(clk));
    register #(.width(1)) r1_4 (.data_out(output_4[2]), .data_in(on_4[2]), .write_en(on_4[2]), .reset(reset | off_4[2]), .clk(clk));
    register #(.width(1)) r2_4 (.data_out(output_4[1]), .data_in(on_4[1]), .write_en(on_4[1]), .reset(reset | off_4[1]), .clk(clk));
    register #(.width(1)) r3_4 (.data_out(output_4[0]), .data_in(on_4[0]), .write_en(on_4[0]), .reset(reset | off_4[0]), .clk(clk));
    //row 5
    register #(.width(1)) r0_5 (.data_out(output_5[4]), .data_in(on_5[4]), .write_en(on_5[4]), .reset(reset | off_5[4]), .clk(clk));
    register #(.width(1)) r1_5 (.data_out(output_5[3]), .data_in(on_5[3]), .write_en(on_5[3]), .reset(reset | off_5[3]), .clk(clk));
    register #(.width(1)) r2_5 (.data_out(output_5[2]), .data_in(on_5[2]), .write_en(on_5[2]), .reset(reset | off_5[2]), .clk(clk));
    register #(.width(1)) r3_5 (.data_out(output_5[1]), .data_in(on_5[1]), .write_en(on_5[1]), .reset(reset | off_5[1]), .clk(clk));
    register #(.width(1)) r4_5 (.data_out(output_5[0]), .data_in(on_5[0]), .write_en(on_5[0]), .reset(reset | off_5[0]), .clk(clk));
    //row 6
    register #(.width(1)) r0_6 (.data_out(output_6[5]), .data_in(on_6[5]), .write_en(on_6[5]), .reset(reset | off_6[5]), .clk(clk));
    register #(.width(1)) r1_6 (.data_out(output_6[4]), .data_in(on_6[4]), .write_en(on_6[4]), .reset(reset | off_6[4]), .clk(clk));
    register #(.width(1)) r2_6 (.data_out(output_6[3]), .data_in(on_6[3]), .write_en(on_6[3]), .reset(reset | off_6[3]), .clk(clk));
    register #(.width(1)) r3_6 (.data_out(output_6[2]), .data_in(on_6[2]), .write_en(on_6[2]), .reset(reset | off_6[2]), .clk(clk));
    register #(.width(1)) r4_6 (.data_out(output_6[1]), .data_in(on_6[1]), .write_en(on_6[1]), .reset(reset | off_6[1]), .clk(clk));
    register #(.width(1)) r5_6 (.data_out(output_6[0]), .data_in(on_6[0]), .write_en(on_6[0]), .reset(reset | off_6[0]), .clk(clk));
    //row 7
    register #(.width(1)) r0_7 (.data_out(output_7[6]), .data_in(on_7[6]), .write_en(on_7[6]), .reset(reset | off_7[6]), .clk(clk));
    register #(.width(1)) r1_7 (.data_out(output_7[5]), .data_in(on_7[5]), .write_en(on_7[5]), .reset(reset | off_7[5]), .clk(clk));
    register #(.width(1)) r2_7 (.data_out(output_7[4]), .data_in(on_7[4]), .write_en(on_7[4]), .reset(reset | off_7[4]), .clk(clk));
    register #(.width(1)) r3_7 (.data_out(output_7[3]), .data_in(on_7[3]), .write_en(on_7[3]), .reset(reset | off_7[3]), .clk(clk));
    register #(.width(1)) r4_7 (.data_out(output_7[2]), .data_in(on_7[2]), .write_en(on_7[2]), .reset(reset | off_7[2]), .clk(clk));
    register #(.width(1)) r5_7 (.data_out(output_7[1]), .data_in(on_7[1]), .write_en(on_7[1]), .reset(reset | off_7[1]), .clk(clk));
    register #(.width(1)) r6_7 (.data_out(output_7[0]), .data_in(on_7[0]), .write_en(on_7[0]), .reset(reset | off_7[0]), .clk(clk));


    /* //////////////////////////////////////
	THIS SECTIONS CONTROLS WHAT CACHE BLOCK IS "EVICTED" OR "UPDATED"
	////////////////////////////////////// */
    //also has the output assignment on the net line
    logic [7:0] lru_number_preout;
    assign lru_number = lru_number_preout;
        //output assigning
    logic [7:0] lru_number_input;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
			mux2_1 lru_ctrl (.out(lru_number_input[i]), .i0(lru_update[i]), .i1(lru_number_preout[i]), .sel(add_cache));
        end
        //if add_cache is 1: the output will be the current lru
        //if add_cache is 0: the output will be the current lru update input
    endgenerate


    /* //////////////////////////////////////
	THIS SECTION IS LOGIC TO TURN THE TRIANGULAR ARRAY INTO A 8 BIT OUTPUT
	////////////////////////////////////// */
    //NOTE THAT LSB REPRESETNS BLOCK 0
    assign lru_number_preout [0] = output_1 & output_2[1] & output_3[2] & output_4[3] & output_5[4] & output_6[5] & output_7[6];
    assign lru_number_preout [1] = ~output_1 & output_2[0] & output_3[1] & output_4[2] & output_5[3] & output_6[4] & output_7[5];
    assign lru_number_preout [2] = ~output_2[1] & ~output_2[0] & output_3[0] & output_4[1] & output_5[2] & output_6[3] & output_7[4];
    assign lru_number_preout [3] = ~output_3[2] & ~output_3[1] & ~output_3[0] & output_4[0] & output_5[1] & output_6[2] & output_7[3];
    assign lru_number_preout [4] = ~output_4[3] & ~output_4[2] & ~output_4[1] & ~output_4[0] & output_5[0] & output_6[1] & output_7[2];
    assign lru_number_preout [5] = ~output_5[4] & ~output_5[3] & ~output_5[2] & ~output_5[1] & ~output_5[0] & output_6[0] & output_7[1];
    assign lru_number_preout [6] = ~output_6[5] & ~output_6[4] & ~output_6[3] & ~output_6[2] & ~output_6[1] & ~output_6[0] & output_7[0];
    assign lru_number_preout [7] = ~output_7[6] & ~output_7[5] & ~output_7[4] & ~output_7[3] & ~output_7[2] & ~output_7[1] & ~output_7[0];
    
    /* //////////////////////////////////////
	THIS SECTION IS LOGIC TO TURN THE INPUT INTO BITS TO CONTROL THE TRIANGULAR ARRAY
    ////////////////////////////////////// */
    //TODO THIS
    
    //assigning on signals
        //(make left on)
    assign on_1 = lru_number_input[1];
    assign on_2 = {2{lru_number_input[2]}}; 
    assign on_3 = {3{lru_number_input[3]}};
    assign on_4 = {4{lru_number_input[4]}};
    assign on_5 = {5{lru_number_input[5]}};
    assign on_6 = {6{lru_number_input[6]}};
    assign on_7 = {7{lru_number_input[7]}};

    //assigning off signals
    
    assign off_1 = lru_number_input[0];
    assign off_2 = {lru_number_input[0], lru_number_input[1]};
    assign off_3 = {lru_number_input[0], lru_number_input[1], lru_number_input[2]};
    assign off_4 = {lru_number_input[0], lru_number_input[1], lru_number_input[2], lru_number_input[3]};
    assign off_5 = {lru_number_input[0], lru_number_input[1], lru_number_input[2], lru_number_input[3], lru_number_input[4]};
    assign off_6 = {lru_number_input[0], lru_number_input[1], lru_number_input[2], lru_number_input[3], lru_number_input[4], lru_number_input[5]};
    assign off_7 = {lru_number_input[0], lru_number_input[1], lru_number_input[2], lru_number_input[3], lru_number_input[4], lru_number_input[5], lru_number_input[6]};
    

endmodule

module lru_testbench;
    parameter ClockDelay = 50;

    logic [7:0] lru_number;
    logic [7:0] lru_update;
    logic add_cache;
    logic reset;
    
    logic clk;
    initial begin // Set up the clock
		clk <= 1;
		forever #(ClockDelay/2) clk <= ~clk;
	end

    lru dut (.lru_number, .lru_update, .add_cache, .reset, .clk);

    initial begin
        @(posedge clk); reset <= 1; lru_update <= 8'b00000000; add_cache <= 1'b0; 
        @(posedge clk); reset <= 0; 

        @(posedge clk); lru_update <= 8'b00000000; add_cache <= 1'b1; 
        @(posedge clk); lru_update <= 8'b00000000; add_cache <= 1'b1; 
        @(posedge clk); lru_update <= 8'b00000000; add_cache <= 1'b1; 
            
        @(posedge clk); lru_update <= 8'b00000000; add_cache <= 1'b0;  @(posedge clk); @(posedge clk);
            //order here oldest-newest: 43210765


        @(posedge clk); lru_update <= 8'b00000100; add_cache <= 1'b0; 
            //order here oldest-newest: 43107652
        @(posedge clk); lru_update <= 8'b00001000; add_cache <= 1'b0; 
            //order here oldest-newest: 41076523
        @(posedge clk); lru_update <= 8'b00000000; add_cache <= 1'b1; 
            //order here oldest-newest: 10765234
                    @(posedge clk); lru_update <= 8'b00000000; add_cache <= 1'b0;  @(posedge clk); @(posedge clk);
            

        @(posedge clk); lru_update <= 8'b00000001; add_cache <= 1'b0; 
            //order here oldest-newest: 17652340
        @(posedge clk); lru_update <= 8'b00000010; add_cache <= 1'b0; 
            //order here oldest-newest: 76523401
        @(posedge clk); lru_update <= 8'b01000000; add_cache <= 1'b0; 
            //order here oldest-newest: 75234016
        @(posedge clk); lru_update <= 8'b00000000; add_cache <= 1'b1; 
            //order here oldest-newest: 52340167
        @(posedge clk); lru_update <= 8'b00000000; add_cache <= 1'b1; 
            //order here oldest-newest: 23401675
                        @(posedge clk); lru_update <= 8'b00000000; add_cache <= 1'b0;  @(posedge clk); @(posedge clk);
                            //order here oldest-newest: 52340617
        @(posedge clk); @(posedge clk);@(posedge clk); @(posedge clk);@(posedge clk); @(posedge clk);@(posedge clk); @(posedge clk);
		$stop;
    end

endmodule
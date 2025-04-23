`timescale 1ns / 1ps

module decode_hamming(
    input  [12:1] in_data, 
    output [7:1]  decode_data, 
    output [3:0]  C,
    output        single_error,
    output        double_error
    );  
    wire c1, c2, c4, c8, c9, no_error;
    wire [11:1] corr_data;
    reg  [11:1] corrected_data;
    // Calculate syndrome bits
    assign c1 = in_data[1] ^ in_data[3] ^ in_data[5] ^ in_data[7] ^ in_data[9] ^ in_data[11];
    assign c2 = in_data[2] ^ in_data[3] ^ in_data[6] ^ in_data[7] ^ in_data[10] ^ in_data[11];
    assign c4 = in_data[4] ^ in_data[5] ^ in_data[6] ^ in_data[7] ;
    assign c8 = in_data[8] ^ in_data[9] ^ in_data[10] ^ in_data[11];
    assign c9 = ^ in_data[11:1]; 
    // Combine syndrome bits into a 4-bit value
    assign C = {c8, c4, c2, c1}; 
    assign single_error = (C != 0) && (in_data[12] != c9); 
    assign double_error = (C != 0) && (in_data[12] == c9); 
    assign no_error     = (C == 0) && (in_data[12] == c9); 
    
    // Correct the error based on the syndrome
   always @(*) begin
        corrected_data = in_data[11:1]; // Initialize with input
        if (single_error && (C <= 11)) begin // Only correct if valid position
            corrected_data[C] = ~corrected_data[C]; // Flip the erroneous bit
        end
    end  
    // Extract the original 8-bit data
    assign corr_data = corrected_data;
    assign decode_data = {corr_data[11:9], corr_data[7:5], corr_data[3]}; //d7 d6 d5 p8 d4 d3 d2 p4 d1 p2 p1
endmodule
`timescale 1ns / 1ps


module Hamming_encoder(
    input [7:1] in_data, 
    output [12:1] encode_data
    );
    
    wire p1, p2, p4, p8, p9;
 
    // Calculate parity bits
    assign p1 = in_data[1] ^ in_data[2] ^ in_data[4] ^ in_data[5] ^ in_data[7];  //   d7 d6 d5 p8 d4 d3 d2 p4 d1 p2 p1
    assign p2 = in_data[1] ^ in_data[3] ^ in_data[4] ^ in_data[6] ^ in_data[7];  //   11 10 9  8  7  6  5  4  3  2  1
    assign p4 = in_data[2] ^ in_data[3] ^ in_data[4];
    assign p8 = in_data[5] ^ in_data[6] ^ in_data[7];
    assign p9 = ^ encode_data[11:1];
    // Construct the encoded data with parity bits
    assign encode_data = {p9, in_data[7], in_data[6], in_data[5], p8, in_data[4], in_data[3], in_data[2], p4, in_data[1], p2, p1  };
endmodule

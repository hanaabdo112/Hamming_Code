`timescale 1ns / 1ps

module decode_hamming_tb();
    reg [12:1] in_data;
    wire [7:1] decode_data;
    wire [3:0] C;
    wire single_error, double_error;
    
    decode_hamming uut (
        .in_data(in_data),
        .decode_data(decode_data),
        .C(C),
        .single_error(single_error),
        .double_error(double_error)
    );
    
    task test_case;
        input [12:1] test_data;
        input [7:1] expected_data;
        input expected_single;
        input expected_double;
        input [3:0] expected_C;
        begin
            in_data = test_data;
            #10;
            $display("Test: Input=%12b, Output=%7b, C=%4b, SE=%b, DE=%b",
                     in_data, decode_data, C, single_error, double_error);
            
            if (expected_double) begin
                // For double errors, we only check the flags
                if (double_error === expected_double && C === expected_C) begin
                    $display("PASS: Double error detected as expected");
                end else begin
                    $display("FAIL: Double error detection failed");
                end
            end
            else begin
                // For single/no errors, check both data and flags
                if (decode_data === expected_data && 
                    single_error === expected_single && 
                    C === expected_C) begin
                    $display("PASS: Data and flags match expected values");
                end else begin
                    $display("FAIL: Data or flags incorrect");
                end
            end
        end
    endtask
    
    initial begin
        // ==============================================
        // Test Case 1: No errors (valid codeword)
        // Input: 12'b101110000110 (7-bit data: 1011001)
        // ==============================================
        test_case(12'b100000000111, 7'b0000001, 0, 0, 4'b0000);
        
        // ==============================================
        // Test Case 2-12: Single-bit errors (flip each bit)
        // ==============================================
        // Flip P1 (bit 1)
        test_case(12'b001110000110, 7'b0010001, 1, 0, 4'b1010);
        
        // Flip P2 (bit 2)
        test_case(12'b111110000110, 7'b1110001, 1, 0, 4'b0001);
        
        // Flip D1 (bit 3)
        test_case(12'b100110110110, 7'b0010110, 1, 0, 4'b0011);
        
        // Flip P4 (bit 4)
        test_case(12'b101010000110, 7'b0100000, 1, 0, 4'b0011);
        
        // Flip D2 (bit 5)
        test_case(12'b101100000110, 7'b0110001, 1, 0, 4'b0010);
        
        // Flip D3 (bit 6)
        test_case(12'b101111000110, 7'b0111001, 1, 0, 4'b1101);
        
        // Flip D4 (bit 7)
        test_case(12'b101110100110, 7'b0110101, 1, 0, 4'b1100);
        
        // Flip P8 (bit 8)
        test_case(12'b101110010110, 7'b0110011, 1, 0, 4'b1111);
        
        // Flip D5 (bit 9)
        test_case(12'b101110001110, 7'b0110001, 1, 0, 4'b1110);
        
        // Flip D6 (bit 10)
        test_case(12'b101110000010, 7'b0100000, 1, 0, 4'b1001);
        
        // Flip D7 (bit 11)
        test_case(12'b101110000100, 7'b0110001, 1, 0, 4'b1000);
        
        // ==============================================
        // Test Case 13-14: Double-bit errors (detection only)
        // ==============================================
        // Flip P1 (bit 1) + D6 (bit 10)
        test_case(12'b001110000010, 7'bxxxxxxx, 0, 1, 4'b1001);
        
        // Flip P2 (bit 2) + D7 (bit 11)
        test_case(12'b111110000100, 7'bxxxxxxx, 0, 1, 4'b0011);
        
        // ==============================================
        // Test Case 15: Another valid codeword
        // Input: 12'b011001101001 (7-bit data: 0110011)
        // ==============================================
        test_case(12'b011001101001, 7'b1101100, 0, 0, 4'b0101);
        
       
       
        
        $display("=========== All Tests Completed ===========");
        $finish;
    end
endmodule
`timescale 1ns / 1ps


module encode_hamming_tb(

    );
    
    reg [7:1]in_data;
   wire [12:1] encode_data;

    Hamming_encoder inst0(in_data,encode_data);
    
    initial 
    $monitor("in_data=%b,encode_data=%b", in_data,encode_data);

    // Function to display test results
    task display_result;
        input [7:1] expected_in;
        input [12:1] expected_encode;
        begin
            $display("--------------------------------------------------------------------------------");
            $display("Input Data  : %b (0x%0h)", expected_in, expected_in);
            $display("Encoded Data: %b (0x%0h)", encode_data, encode_data);
            $display("Expected Encoded Data: %b (0x%0h)", expected_encode, expected_encode);
            if (encode_data == expected_encode)
                $display("Result: PASS");
            else
                $display("Result: FAIL");

           $display("###########################################################################################################");     
        end
    endtask

    
    initial 
    begin

    // Test case 1
    $display("Test Case 1: 0000000");
    in_data = 7'b000_0000;
    #10 
    display_result(in_data, 12'b0000_0000_0000);
    #20 ;
     
    // Test case 2
    $display("Test Case 2: 0000001");
    in_data = 7'b000_0001;
    #10 
    display_result(in_data, 12'b1000_0000_0111);
    #20 ;

    // Test case 3
    $display("Test Case 3: 0000010");
    in_data = 7'b000_0010;
    #10 
    display_result(in_data, 12'b1000_0001_1001);
    #20 ;

    // Test case 4
    $display("Test Case 4: 0000011");
    in_data = 7'b000_0011;
    #10 
    display_result(in_data, 12'b0000_0001_1110);
    #20 ;

    // Test case 5
    $display("Test Case 5: 0000100");
    in_data = 7'b000_0100;
    #10 
    display_result(in_data, 12'b1000_0010_1010);
    #20 ;

    // Test case 6
    $display("Test Case 6: 0000101");
    in_data = 7'b000_0101;
    #10 
    display_result(in_data, 12'b0000_0010_1101);
    #20 ;

    // Test case 7
    $display("Test Case 7: 0000110");
    in_data = 7'b000_0110;
    #10 
    display_result(in_data, 12'b0000_0011_0011);
    #20 ;

    // Test case 8
    $display("Test Case 8: 0000111");
    in_data = 7'b000_0111;
    #10 
    display_result(in_data, 12'b1000_0011_0100);
    #20 ;

    // Test case 9
    $display("Test Case 9: 1111111");
    in_data = 7'b111_1111;
    #10 
    display_result(in_data, 12'b1111_1111_1111);
    #20 ;

    // Test case 10
    $display("Test Case 10: 0101001");
    in_data=7'b010_1001;
    #10 
    display_result(in_data, 12'b0010_1100_1110);
    #20 ;
    
    $stop;   // End the simulation
    end
endmodule


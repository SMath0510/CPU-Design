`timescale 1ns/1ns
`include "multiplier.v"

module Multiplier8Bit_Unsigned_tb;

    reg [7:0] A, B;
    wire [15:0] P;
    wire O;

    Multiplier8Bit_Unsigned UUT (A, B, P, O);

    initial begin
        
        $dumpfile("multiplier_tb.vcd");
        $dumpvars(0, Multiplier8Bit_Unsigned_tb);

        A = 8'b11001000;
        B = 8'b00111111;
        #10;

        A = 8'b10101001;
        B = 8'b00100110;
        #10;

        A = 8'b00001111;
        B = 8'b00001010;
        #10;

        A = 8'b10101110;
        B = 8'b11011011;
        #10;

        A = 8'b10100111;
        B = 8'b11100100;
        #10;

        A = 8'b00000001;
        B = 8'b01000110;
        #10;

        A = 8'b11000000;
        B = 8'b10010110;
        #10;

        A = 8'b00111110;
        B = 8'b00101011;
        #10;

        A = 8'b00011110;
        B = 8'b00101110;
        #10;

        A = 8'b10001000;
        B = 8'b11111111;
        #10;

        A = 8'b11101000;
        B = 8'b00100101;
        #10;
    
    end

endmodule

module Multiplier8Bit_Signed_tb;

    reg [7:0] A, B;
    wire [7:0] P;
    wire O;

    Multiplier8Bit_Signed UUT (A, B, P, O);

    initial begin
        
        $dumpfile("multiplier_tb.vcd");
        $dumpvars(0, Multiplier8Bit_Signed_tb);

        A = 8'b11111000;
        B = 8'b11111010;
        #10;

        A = 8'b11110110;
        B = 8'b00001010;
        #10;

        A = 8'b11001110;
        B = 8'b00000010;
        #10;

        A = 8'b00011110;
        B = 8'b00000011;
        #10;

        A = 8'b00000001;
        B = 8'b01000110;
        #10;

        A = 8'b11000000;
        B = 8'b10010110;
        #10;

        A = 8'b00111110;
        B = 8'b00101011;
        #10;

        A = 8'b00011110;
        B = 8'b00101110;
        #10;
    
    end

endmodule
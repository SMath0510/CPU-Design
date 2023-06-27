`timescale 1ns/1ns
`include "floating_multiplier.v"

module FloatMul_tb;

    reg [11:0] X, Y;
    wire [11:0] Z;

    Floating_Multiplier UUT (X, Y, Z);

    initial begin
        
        $dumpfile("floatmul_tb.vcd");
        $dumpvars(0, FloatMul_tb);

        X = 12'b001111000000;
        Y = 12'b001111000000;
        #10;

        X = 12'b001111000000;
        Y = 12'b101111000000;
        #10;

        X = 12'b001111000000;
        Y = 12'b001110100000;
        #10;

        X = 12'b001111000000;
        Y = 12'b101110100000;
        #10;

        X = 12'b011100000000;
        Y = 12'b011100000000;
        #10;

        X = 12'b000010000000;
        Y = 12'b100010000000;
        #10;
    
    end

endmodule
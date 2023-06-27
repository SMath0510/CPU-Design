`timescale 1ns/1ns
`include "floating.v"

module floating_tb;

    reg [11:0] X, Y;
    wire [11:0] Z;

    Float_Adder_12bit UUT (X, Y, Z);

    initial begin
        
        $dumpfile("floating_tb.vcd");
        $dumpvars(0, floating_tb);
        
        X = 12'b011101010101;
        Y = 12'b010001100110; #20

        X = 12'b010011111110;
        Y = 12'b010001101110; #20

        X = 12'b010010010001;
        Y = 12'b010000100010; #20

        X = 12'b011101001010;
        Y = 12'b001011101110; #20

        #100 $finish;
    end

endmodule
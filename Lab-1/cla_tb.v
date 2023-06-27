`timescale 1ns/1ns
`include "cla.v"

// Adder
module CLA16bit_tb;

    reg[15:0] A,B;
    reg C;

    wire[15:0] sum;
    wire carry;

    CLA16Bit uut(.A(A), .B(B), .C(C), .sum(sum), .carry(carry));

    initial begin

        $dumpfile("cla_tb.vcd");
        $dumpvars(0,CLA16bit_tb);

        A=16'b0101101101101101; B=16'b0000110011001100; C=0; #20 
        A=16'b0110101010101010; B=16'b0100000000000001; C=0; #20
        A=16'b1111111110000000; B=16'b1111111110111111; C=0; #20
        A=16'b1000000000000000; B=16'b1111111110000000; C=0; #20
        A=16'b0110000000000000; B=16'b1111111110000000; C=0; #20

        #100 $finish;
    end

endmodule

// Subtractor
module CLS16bit_sub_tb;

    reg[15:0] A,B;
    reg C;

    wire[15:0] diff;
    wire carry;

    CLS16Bit uut(.A(A), .B(B), .C(C), .diff(diff), .carry(carry));

    initial begin

        $dumpfile("cla_tb.vcd");
        $dumpvars(0,CLS16bit_sub_tb);

        A=16'b0101101101101101; B=16'b0000110011001100; C=0; #20 
        A=16'b0110101010101010; B=16'b0100000000000001; C=0; #20
        A=16'b1111111110000000; B=16'b1111111110111111; C=0; #20
        A=16'b1000000000000000; B=16'b1111111110000000; C=0; #20
        A=16'b0110000000000000; B=16'b1111111110000000; C=0; #20

        #100 $finish;
    end

endmodule

// Higher Order Adder
module CLA16bit_HigherOrder_tb;

    reg[15:0] A,B;
    reg C;

    wire[15:0] sum;
    wire carry;

    CLA16Bit_HigherOrder uut(.A(A), .B(B), .C(C), .sum(sum), .carry(carry));

    initial begin

        $dumpfile("cla_tb.vcd");
        $dumpvars(0,CLA16bit_HigherOrder_tb);

        A=16'b0101101101101101; B=16'b0000110011001100; C=0; #20 
        A=16'b0110101010101010; B=16'b0100000000000001; C=0; #20
        A=16'b1111111110000000; B=16'b1111111110111111; C=0; #20
        A=16'b1000000000000000; B=16'b1111111110000000; C=0; #20
        A=16'b0110000000000000; B=16'b1111111110000000; C=0; #20

        #100 $finish;
    end

endmodule

// Higher Order Subtractor
module CLS16bit_HigherOrder_tb;

    reg[15:0] A,B;
    reg C;

    wire[15:0] diff;
    wire carry;

    CLS16Bit_HigherOrder uut(.A(A), .B(B), .C(C), .diff(diff), .carry(carry));

    initial begin

        $dumpfile("cla_tb.vcd");
        $dumpvars(0,CLS16bit_HigherOrder_tb);

        A=16'b0101101101101101; B=16'b0000110011001100; C=0; #20 
        A=16'b0110101010101010; B=16'b0100000000000001; C=0; #20
        A=16'b1111111110000000; B=16'b1111111110111111; C=0; #20
        A=16'b1000000000000000; B=16'b1111111110000000; C=0; #20
        A=16'b0110000000000000; B=16'b1111111110000000; C=0; #20

        #100 $finish;
    end

endmodule

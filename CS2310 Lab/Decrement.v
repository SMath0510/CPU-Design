module decrement(B,A);

    input [7:0] A;
    output [7:0] B;
    wire Cout;

    // Adding the number and the twos complement of 1
    RCA8 r1(B,Cout,A,8'b11111111, 1'b0);

endmodule

// Adding the twos complement of 1 to the first number using the RCA - 8 bit adder
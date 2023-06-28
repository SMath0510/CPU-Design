module increment(B,A);

    input [7:0] A;
    output [7:0] B;
    wire Cout;

    // Adding the number and 1
    RCA8 r1(B,Cout,A,8'b00000001, 1'b0);

endmodule

// Adding 1 to the first number using the RCA Module
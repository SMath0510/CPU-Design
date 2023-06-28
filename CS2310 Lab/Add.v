module add(S,A,B);

    input [7:0] A,B;
    output [7:0] S;

    wire Cout;

    // Adding the two numbers 
    RCA8 r1 (S,Cout,A,B,1'b0);

endmodule

// Addition of the two number using the RCA - 8 bit adder
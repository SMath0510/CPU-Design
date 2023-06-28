module OR(Out,A,B);

    input [7:0] A,B;
    output [7:0] Out;

    // Taking the bitwise or
    or o[7:0] (Out[7:0], A[7:0], B[7:0]);   

endmodule

// Taking bitwise or of the two numbers
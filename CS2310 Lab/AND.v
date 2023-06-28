module AND(Out,A,B);

    input [7:0] A,B;
    output [7:0] Out;

    // Taking the bitwise and
    and a[7:0] (Out[7:0], A[7:0], B[7:0]);

endmodule

// Taking bitwise and of the two numbers
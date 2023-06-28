module NOT(Out,A);

    input [7:0] A;
    output [7:0] Out;

    // Taking the bitwise not
    not n[7:0](Out[7:0], A[7:0]);

endmodule

// Taking the bitwise not of the first Number
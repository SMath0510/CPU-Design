module RCA8(S,Cout,A,B,Cin);

    input [7:0] A,B;
    input Cin;
    output [7:0] S;
    output Cout;
    wire [6:0] C;

    // Ripple Carry Adder Logic Flow
    Full_Adder f0(S[0], C[0],A[0], B[0], Cin);
    Full_Adder f[6:1](S[6:1], C[6:1],A[6:1], B[6:1],C[5:0]);
    Full_Adder f7 (S[7], Cout, A[7], B[7], C[6]);

endmodule

// RCA - 8 bit adder that helps in the addition process in the CPU
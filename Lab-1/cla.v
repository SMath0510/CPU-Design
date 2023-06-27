`timescale 1ns/1ns

module halfAdder(A, B, sum, carry);

    input A,B;
    output sum,carry;

    and (carry, A, B);
    xor (sum, A, B);

endmodule;

module Increment16Bit(A, Aplus1, carry);

    input [15:0] A;
    output [15:0] Aplus1;
    output carry;

    wire [16:0] carry_forward;
    assign carry_forward[0] = 1;

    halfAdder h[15:0] (A[15:0], carry_forward[15:0], Aplus1[15:0], carry_forward[16:1]);
    buf(carry,carry_forward[16]);

endmodule

module CLA4Bit(A, B, C, sum, carry);

    input [3:0] A, B;
    input C;
    output [3:0] sum;
    output carry;

    wire [3:0] p, g;
    and a[3:0] (g[3:0], A[3:0], B[3:0]);
    xor x[3:0] (p[3:0], A[3:0], B[3:0]);

    wire car[4:0];
    buf (car[0], C);
    xor (sum[0], car[0], p[0]);

    // C1
    and (t1, p[0], C);
    or (car[1], g[0], t1);
    xor (sum[1], car[1], p[1]);

    // C2
    and (t2, p[0], p[1], C);
    and (t3, p[1], g[0]);
    or (car[2], g[1], t2, t3);
    xor (sum[2], car[2], p[2]);

    // C3
    and (t4, p[0], p[1], p[2], C);
    and (t5, p[1], p[2], g[0]);
    and (t6, p[2], g[1]);
    or (car[3], g[2], t4, t5, t6);
    xor (sum[3], car[3], p[3]);

    // C4
    and (t7, p[3], p[2], p[1], p[0], C);
    and (t8, p[3], p[2], p[1], g[0]);
    and (t9, p[3], p[2], g[1]);
    and (t10, p[3], g[2]);
    or (car[4], g[3], t7, t8, t9, t10);

    buf (carry, car[4]);

endmodule

module CLA4Bit_Generate(A, B, P, G);

    input [3:0] A, B;
    output P, G;

    wire [3:0] p, g;
    and a[3:0] (g[3:0], A[3:0], B[3:0]);
    xor x[3:0] (p[3:0], A[3:0], B[3:0]);

    // P
    and (P, p[0], p[1], p[2], p[3]);

    // G
    and (t1, p[3], p[2], p[1], g[0]);
    and (t2, p[3], p[2], g[1]);
    and (t3, p[3], g[2]);
    or (G, g[3], t1, t2, t3);

endmodule

module CLA16Bit(A, B, C, sum, carry);

    input [15:0] A, B;
    input C;
    output [15:0] sum;
    output carry;

    wire carry_forward [4:0];
    buf(carry_forward[0], C);
    CLA4Bit c1(A[3:0], B[3:0], carry_forward[0], sum[3:0], carry_forward[1]);
    CLA4Bit c2(A[7:4], B[7:4], carry_forward[1], sum[7:4], carry_forward[2]);
    CLA4Bit c3(A[11:8], B[11:8], carry_forward[2], sum[11:8], carry_forward[3]);
    CLA4Bit c4(A[15:12], B[15:12], carry_forward[3], sum[15:12], carry_forward[4]);

    buf(carry, carry_forward[4]);

endmodule

module CLA16Bit_HigherOrder(A, B, C, sum, carry);

    input [15:0] A, B;
    input C;
    output [15:0] sum;
    output carry;

    wire p0, p4, p8, p12;
    wire c0, c4, c8, c12;

    //Generating Higher Order Terms
    CLA4Bit_Generate cg1(A[3:0], B[3:0], p0, g0);
    CLA4Bit_Generate cg2(A[7:4], B[7:4], p4, g4);
    CLA4Bit_Generate cg3(A[11:8], B[11:8], p8, g8);
    CLA4Bit_Generate cg4(A[15:12], B[15:12], p12, g12);

    // C4
    and (t1, p0, C);
    or (c4, g0, t1);

    // C8
    and (t2, p0, p4, C);
    and (t3, p4, g0);
    or (c8, g4, t2, t3);

    // C12 
    and (t4, p0, p4, p8, C);
    and (t5, p4, p8, g0);
    and (t6, p8, g4);
    or (c12, g8, t4, t5, t6);

    // C16
    and (t7, p0, p4, p8, p12, C);
    and (t8, p4, p8, p12, g0);
    and (t9, p8, p12, g4);
    and (t10, p12, g8);
    or (c16, g12, t7, t8, t9, t10);

    CLA4Bit cc1(A[3:0], B[3:0], C, sum[3:0], temp1);
    CLA4Bit cc2(A[7:4], B[7:4], c4, sum[7:4], temp2);
    CLA4Bit cc3(A[11:8], B[11:8], c8, sum[11:8], temp3);
    CLA4Bit cc4(A[15:12], B[15:12], c12, sum[15:12], temp4);

    buf (carry, c16);

endmodule

module CLS16Bit(A, B, C, diff, carry);

    input [15:0] A, B;
    input C;
    output [15:0] diff;
    output carry;

    wire [15:0] D, E;
    wire carry_temp;
    not n[15:0] (D[15:0], B[15:0]);
    Increment16Bit i[15:0] (D[15:0], E[15:0], carry_temp);
    
    CLA16Bit c1(A, E, C, diff, carry);

endmodule

module CLS16Bit_HigherOrder(A, B, C, diff, carry);

    input [15:0] A, B;
    input C;
    output [15:0] diff;
    output carry;

    wire [15:0] D, E;
    wire carry_temp;
    not n[15:0] (D[15:0], B[15:0]);
    Increment16Bit i[15:0] (D[15:0], E[15:0], carry_temp);
    
    CLA16Bit_HigherOrder c1(A, E, C, diff, carry);

endmodule


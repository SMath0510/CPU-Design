module Decoder(Out, S);

    input [2:0] S;
    output[7:0] Out;

    and g1 (Out[1], notS[2], notS[1], S[0]);
    and g2 (Out[2], notS[2], S[1], notS[0]);
    and g3 (Out[3], notS[2], S[1], S[0]);
    and g4 (Out[4], S[2], notS[1], notS[0]);
    and g5 (Out[5], S[2], notS[1], S[0]);
    and g6 (Out[6], S[2], S[1], notS[0]);
    and g7 (Out[7], S[2], S[1], S[0]);

endmodule



module Full_Adder(S,Cout,A,B,Cin);

    input A,B,Cin;
    output S,Cout;
    wire Stemp, Ctemp1, Ctemp2;

    // Full Adder Logic using two half adders
    Half_Adder h1 (Stemp, Ctemp1, A,B);
    Half_Adder h2 (S, Ctemp2, Cin, Stemp);
    or o1 (Cout, Ctemp1, Ctemp2);

endmodule

// Full Adder Module that will be used to generate the RCA 8-bit adder
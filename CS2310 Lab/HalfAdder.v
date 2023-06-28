module Half_Adder(S,C,A,B);

    input A,B;
    output S,C;

    // Simple Half Adder Logic
    and a1(C,A,B);
    xor x1(S,A,B);

endmodule;

// Half Adder module that helps in the Full Adder Operation
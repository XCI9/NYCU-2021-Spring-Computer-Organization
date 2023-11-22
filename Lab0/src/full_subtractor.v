`timescale 1ns / 1ps

module Full_Subtractor(
    In_A, In_B, Borrow_in, Difference, Borrow_out
    );
    input In_A, In_B, Borrow_in;
    output Difference, Borrow_out;
    
    // implement full subtractor circuit, your code starts from here.
    // use half subtractor in this module, fulfill I/O ports connection.
    Half_Subtractor HSUB (
        .In_A(), 
        .In_B(), 
        .Difference(), 
        .Borrow_out()
    );

endmodule

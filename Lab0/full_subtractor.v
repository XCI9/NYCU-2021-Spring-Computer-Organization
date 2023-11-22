`timescale 1ns / 1ps

module Full_Subtractor(
    In_A, In_B, Borrow_in, Difference, Borrow_out
    );
    input In_A, In_B, Borrow_in;
    output Difference, Borrow_out;
    
    // implement full subtractor circuit, your code starts from here.
    // use half subtractor in this module, fulfill I/O ports connection.
	wire tempD, tempB1, tempB2;
	
    Half_Subtractor HSUB1 (
        .In_A(In_A), 
        .In_B(In_B), 
        .Difference(tempD), 
        .Borrow_out(tempB1)
    );
	
	Half_Subtractor HSUB2 (
        .In_A(tempD), 
        .In_B(Borrow_in), 
        .Difference(Difference), 
        .Borrow_out(tempB2)
    );
	
	or (Borrow_out, tempB1, tempB2);

endmodule

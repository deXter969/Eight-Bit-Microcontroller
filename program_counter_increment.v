module program_counter_increment #(
    parameter SIZE = 8 ) (
    output [SIZE-1:0] out,
    input [SIZE-1:0] in );
    assign out = in + 1'b1; 
endmodule
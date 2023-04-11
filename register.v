module register #(
    parameter SIZE = 8 ) (
    output [SIZE-1:0] out,
    input [SIZE-1:0] in,
    input enable );
    assign out = enable?in:0;
endmodule
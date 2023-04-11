module mux #(
    parameter SIZE = 8 ) (
    output [SIZE-1:0] out,
    input [SIZE-1:0] in1,
    input [SIZE-1:0] in2,
    input sel );
    assign out = sel?in1:in2;
endmodule
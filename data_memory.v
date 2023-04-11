module data_memory #(
    parameter WIDTH = 8, 
    parameter DEPTH = 16 ) (
    output [WIDTH-1:0] data_out,
    input enable,
    input write_enable,
    input [$clog2(DEPTH)-1:0] address,
    input [WIDTH-1:0] data_in,
    input clk );
    reg [WIDTH-1:0]dataMem[DEPTH-1:0];
    always @(posedge clk) begin
        if(enable && write_enable) dataMem[address] <= data_in;
    end
    assign data_out = enable?dataMem[address]:0;
endmodule
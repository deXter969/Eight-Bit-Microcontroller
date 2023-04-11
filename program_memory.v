module program_memory #(
    parameter WIDTH = 12, 
    parameter DEPTH = 256 ) (
    output [WIDTH-1:0]instruction,
    input enable,
    input [$clog2(DEPTH)-1:0]address,
    input [WIDTH-1:0]load_instruction,
    input load_enable,
    input [$clog2(DEPTH)-1:0]load_address,
    input clk );
    reg [WIDTH-1:0]progMem[DEPTH-1:0];
    always @(posedge clk) begin
        if (load_enable) begin
            progMem[load_address] <= load_instruction;
        end
    end
    assign instruction = enable?progMem[address]:0;
endmodule
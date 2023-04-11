module ArithmeticLogicUnit ( 
    output [7:0] out,
    input [7:0] op1,
    input [7:0] op2,
    input enable,
    input [3:0] mode,
    input [3:0] current_flags,
    output [3:0] flags );
    reg [7:0] out_ALU;
    reg z,c,o,s;
    always @(*) begin
        if(enable) begin
            case(mode)
                4'h0: begin
                    {c,out_ALU} = op1 + op2;
                end
                4'h1: begin
                    out_ALU = op1 - op2;
                    c = ~out_ALU[7];        // Not Follow
                end
                4'h2: begin
                    out_ALU = op1;
                end
                4'h3: begin
                    out_ALU = op2;
                end
                4'h4: begin
                    out_ALU = op1 & op2;
                end
                4'h5: begin
                    out_ALU = op1 | op2;
                end
                4'h6: begin
                    out_ALU = op1 ^ op2;
                end
                4'h7: begin
                    out_ALU = op2 - op1;
                    c = ~out_ALU[7];        // Not Follow
                end
                4'h8: begin
                    {c,out_ALU} = op2 + 1;
                end
                4'h9: begin
                    out_ALU = op2 - 1;
                    c = ~out_ALU[7];        // Not Follow
                end
                4'hA: begin
                    out_ALU = (op2 << op1[2:0])|(op2 >> 8-op1[2:0]);
                end
                4'hB: begin
                    out_ALU = (op2 >> op1[2:0])|(op2 << 8-op1[2:0]);
                end
                4'hC: begin
                    out_ALU = op2 << op1[2:0]; // carry
                end
                4'hD: begin
                    out_ALU = op2 >> op1[2:0]; // carry
                end
                4'hE: begin
                    out_ALU = op2 >>> op1[2:0]; // carry
                end
                4'hF: begin
                    out_ALU = 0 - op2;
                    c = ~out_ALU[7];        // Not Follow
                end
            endcase
            z = out_ALU == 0;
            s = out_ALU[7];
            o = out_ALU[6]^out_ALU[7];
        end
    end
    assign out = out_ALU;
    assign flags = {z,c,s,o};
endmodule
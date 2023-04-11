module control_unit (
    output reg PC_E,
    output reg Acc_E,
    output reg SR_E,
    output reg IR_E,
    output reg DR_E,
    output reg PMem_E,
    output reg DMem_E,
    output reg DMem_WE,
    output reg ALU_E,
    output reg [3:0] ALU_Mode,
    output reg Mux1_Sel,
    output reg Mux2_Sel,
    output reg PMem_LE,
    input [3:0] statusRegister,
    input [11:0] InstructionRegister,
    input rst,
    input clk );
    parameter LOAD = 0, FETCH = 1, DECODE = 2, EXECUTE = 3;
    reg [1:0] state,next;
    always @(posedge clk) begin
        if (rst) state <= LOAD;
        else state <= next;
    end
    always @(*) begin
        PC_E = 0;
        PC_E = 0;
        Acc_E = 0;
        SR_E = 0;
        IR_E = 0;
        DR_E = 0;
        PMem_E = 0;
        DMem_E = 0;
        DMem_WE = 0;
        ALU_E = 0;
        ALU_Mode = 0;
        Mux1_Sel = 0;
        Mux2_Sel = 0;
        PMem_LE = 0;
        case (state)
            LOAD: begin
                next = rst?LOAD:FETCH;
                PMem_LE = 1;
            end
            FETCH: begin
                next = DECODE;
                IR_E = 1;
                PMem_E = 1;
            end
            DECODE: begin
                next = EXECUTE;
                if (InstructionRegister[11:9] == 3'b001) begin
                    DR_E = 1;
                    DMem_E = 1;
                end
            end
            EXECUTE: begin
                next = FETCH;
                PC_E = 1;
                if (InstructionRegister[11:8] == 4'b0000) begin
                    Mux1_Sel = 1;
                end
                else if(InstructionRegister[11:9] == 3'b001) begin
                    Acc_E = InstructionRegister[8];
                    SR_E = 1;
                    DMem_E = ~InstructionRegister[8];
                    DMem_WE = ~InstructionRegister[8];
                    Acc_E = 1;
                    ALU_Mode = InstructionRegister[7:4];
                    Mux1_Sel = 1;
                    Mux2_Sel = 1;
                end
                else if(InstructionRegister[11:10] == 2'b01) begin
                    Mux1_Sel = statusRegister[~InstructionRegister[9:8]];
                end
                else if(InstructionRegister[11] == 1'b1) begin
                    Acc_E = 1;
                    SR_E = 1;
                    ALU_E = 1;
                    ALU_Mode =  InstructionRegister[10:8];
                    Mux1_Sel = 1;
                end
            end
        endcase
    end
endmodule
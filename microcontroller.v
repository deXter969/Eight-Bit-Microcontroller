`include "Microcontroller\control_unit.v"
`include "Microcontroller\ArithmeticLogicUnit.v"
`include "Microcontroller\data_memory.v"
`include "Microcontroller\mux.v"
`include "Microcontroller\program_counter_increment.v"
`include "Microcontroller\program_memory.v"
`include "Microcontroller\register.v"
module microcontroller (
    input rst,
    input clk );
    //////////////////////////////////////////////////////////////////////////////////////// VARIABLES
    wire [7:0] Mux1_out,Mux2_out,Adder_out,PC_out,DR_out,Acc_out,ALU_out,DMem_out;
    wire [11:0] IR_out,PMem_out;
    wire [3:0] SR_out,ALU_Mode,flag_out;
    wire PC_E,Acc_E,SR_E,IR_E,DR_E,PMem_E,DMem_E,DMem_WE,ALU_E,Mux1_Sel,Mux2_Sel,PMem_LE;
    //////////////////////////////////////////////////////////////////////////////////////// DATAPATH
    mux #(.SIZE(8)) MUX1(
        .out(Mux1_out),
        .in1(Adder_out),
        .in2(IR_out[7:0]),
        .sel(Mux1_Sel) 
    );
    mux #(.SIZE(8)) MUX2(
        .out(Mux2_out),
        .in1(IR_out[7:0]),
        .in2(DR_out),
        .sel(Mux2_Sel) 
    );
    program_counter_increment Adder(
        .out(Adder_out),
        .in(PC_out)
    );
    register #(.SIZE(8)) PC(
        .out(PC_out),
        .in(Mux1_out),
        .enable(PC_E)
    );
    register #(.SIZE(8)) Acc(
        .out(Acc_out),
        .in(ALU_out),
        .enable(Acc_E)
    );
    register #(.SIZE(4)) SR(
        .out(SR_out),
        .in(flag_out),
        .enable(SR_E)
    );
    register #(.SIZE(12)) IR(
        .out(IR_out),
        .in(PMem_out),
        .enable(IR_E)
    );
    register #(.SIZE(8)) DR(
        .out(DR_out),
        .in(DMem_out),
        .enable(DR_E)
    );
    program_memory PMem(
        .instruction(PMem_out),
        .enable(PMem_E),
        .address(),
        .load_instruction(),
        .load_enable(PMem_LE),
        .load_address(),
        .clk(clk) 
    );
    data_memory DMem(
        .data_out(DMem_out),
        .enable(DMem_E),
        .write_enable(DMem_WE),
        .address(),
        .data_in(),
        .clk(clk) 
    );
    ArithmeticLogicUnit ALU(
        .out(ALU_out),
        .op1(Acc_out),
        .op2(Mux2_out),
        .enable(ALU_E),
        .mode(ALU_Mode),
        .current_flags(SR_out),
        .flags(flag_out)
    );
    //////////////////////////////////////////////////////////////////////////////////////// CONTROLPATH
    control_unit CU(
        .PC_E(PC_E),
        .Acc_E(Acc_E),
        .SR_E(SR_E),
        .IR_E(IR_E),
        .DR_E(DR_E),
        .PMem_E(PMem_E),
        .DMem_E(DMem_E),
        .DMem_WE(DMem_WE),
        .ALU_E(ALU_E),
        .ALU_Mode(ALU_Mode),
        .Mux1_Sel(Mux1_Sel),
        .Mux2_Sel(Mux2_Sel),
        .PMem_LE(PMem_LE),
        .statusRegister(SR_out),
        .InstructionRegister(IR_out),
        .rst(rst),
        .clk(clk)
    );
endmodule
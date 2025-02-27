`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2025 02:10:52 PM
// Design Name: 
// Module Name: CPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "IdMapping.vh"
`define MOV 5'b01000
`define ADD 5'b01001
`define SUB 5'b01001
`define INC 5'b01011
`define DEC 5'b01100
`define CMP 5'b01101
`define JMP 5'b01110
`define LOAD 5'b00000
`define SAVE 5'b00001
`define STACKOP 5'b00010
`define OUTPUTID 5'b00011
`define OUTPUT 5'b00100

module CPU(
        input Clk,
        input Reset,
        inout [7:0] Data,
        output reg [7:0] Id,
        output reg RW = 0
    );

    typedef enum { BOOTSTRAPPING, READING_INSTRUCT, EXEC_INSTRUCT, EXEC_MICRO_INSTRUCT } CPU_STATE;

    CPU_STATE State = BOOTSTRAPPING;

    logic [15:0] PC = 0;
    logic [15:0] SP = 0;

    logic [7:0] R [3:0] = '{default:8'b00000000}; //General purpose

    logic [7:0] RP[1:0] ='{default:8'b00000000}; //16 bit Address

    logic CMPA, CMPB, CMPE;
    logic Carry = 0;

    logic [2:0] NrOfCyclesRemaining = 0;

    logic InstructionReady = 0;
    logic OpCodeRead = 0;

    logic [23:0] Instruction = 0;
    logic [7:0] InstructionExtra = 0;
    
    logic [7:0] TempData = 0;
    logic [7:0] OutputID = 0;

    logic [21:0] TempInstructions [14:0];
    logic [3:0] TempInstructionPC = 0;
    logic [2:0] InstructionByte = 0;
    
    logic [15:0] BootstrappingIndex = 0;
    logic DoneBootstrapping = 0;
    logic WriteBootstrapping = 0;
    logic InstructionReady = 0;

    assign Data = (RW == 1) ? TempData : 8'bzzzzzzzz; 

    task Add_MicroInstruction(input logic [3:0] index, 
                              input logic [7:0] data, 
                              input logic [7:0] id,
                              input logic [2:0] register,
                              input logic instructionP, 
                              input logic rw,
                              input logic wt);
        TempInstructions[index][20]<=instructionP;
        TempInstructions[index][19:17]<=register;
        TempInstructions[index][16]<=rw;
        TempInstructions[index][15:8]<=id;
        TempInstructions[index][7:0]<=data;
        TempInstructions[index][21]<=wt;
    endtask



    task Read_Instruction(input logic [3:0] index, 
                          input logic [15:0] address,
                          input logic [7:0] id);
        Add_MicroInstruction(index+6, address[15:8], id, 3'b000, 1, 1,0);
        Add_MicroInstruction(index+5, address[7:0], id, 3'b000, 1, 1,0);
        Add_MicroInstruction(index+4, 8'b00000000, id, 3'b000, 1, 0,1);
        Add_MicroInstruction(index+3, 8'b00000000, id, 3'b000, 1, 0,1);
        Add_MicroInstruction(index+2, 8'b00000000, id, 3'b000, 1, 0,1);
        Add_MicroInstruction(index+1, 8'b00000000, id, 3'b000, 1, 0,1);
        Add_MicroInstruction(index, 8'b00000000, `ID_NULL, 3'b000, 1, 0,0);
    endtask

    task Read_Variable(input logic [3:0] index,
                       input logic [15:0] address,
                       input logic [2:0] register,
                       input logic [7:0] id);
        Add_MicroInstruction(index+6, address[15:8], id, register, 0, 1,0);
        Add_MicroInstruction(index+5, address[7:0], id, register, 0, 1,0);
        Add_MicroInstruction(index+4, 8'b00000000, id, register, 0, 0,0);
        Add_MicroInstruction(index+3, 8'b00000000, id, register, 0, 0,0);
        Add_MicroInstruction(index+2, 8'b00000000, id, register, 0, 0,1);
        Add_MicroInstruction(index+1, 8'b00000000, id, register, 0, 0,1);
        Add_MicroInstruction(index, 8'b00000000, `ID_NULL, register, 0, 0,0);
    endtask

    task Write_Variable(input logic [3:0] index,
                        input logic [15:0] address,
                        input logic [7:0] data,
                        input logic [7:0] id);
        Add_MicroInstruction(index+6, address[15:8], id, 3'b000, 0, 1,0);
        Add_MicroInstruction(index+5, address[7:0], id, 3'b000, 0, 1,0);
        Add_MicroInstruction(index+4, data, id, 3'b000, 0, 1,0);
        Add_MicroInstruction(index+3, data, id, 3'b000, 0, 1,1);
        Add_MicroInstruction(index+2, data, id, 3'b000, 0, 1,1);
        Add_MicroInstruction(index+1, data, id, 3'b000, 0, 1,1);
        Add_MicroInstruction(index, data, `ID_NULL, 3'b000, 0, 1,0);
    endtask

    always_ff @(posedge Clk) begin
        if(Reset == 1) begin
            PC <= 0;
            Carry <= 0;
            CMPA <= 0;
            CMPB <= 0;
            CMPE <= 0;
            RP[0]<=0;
            RP[1]<=0;
            R[0]<=0;
            R[1]<=0;
            R[2]<=0;
            R[3]<=0;
            BootstrappingIndex <= 0;
            DoneBootstrapping <= 0;
            State<=BOOTSTRAPPING;
            TempInstructionPC<=0;
            WriteBootstrapping<=0;
            InstructionReady<=0;
            SP<=0;
        end
        begin
            case(State)
                BOOTSTRAPPING:
                begin
                    State<=EXEC_MICRO_INSTRUCT;
                    if(RP[0] == 0 && RP[1] == 0)
                    begin
                        Read_Variable(7,
                                        16'b0000000000000000,
                                        3'b100,
                                        `ID_ROM);
                        Read_Variable(0,
                                        16'b0000000000000001,
                                        3'b101,
                                        `ID_ROM);
                        PC<=16'b0000000000000010;
                        TempInstructionPC<=13;
                    end else 
                    begin
                        WriteBootstrapping <= !WriteBootstrapping;
                        if(WriteBootstrapping==0)
                        begin
                            Read_Variable(0,
                                        PC,
                                        3'b000,
                                        `ID_ROM);
                            TempInstructionPC<=6;
                        end else
                        begin
                            Write_Variable(0,
                                           PC-2,
                                           R[0],
                                           `ID_RAM);
                            PC<=PC+1;
                            TempInstructionPC<=6;
                            if(PC=={RP[1],RP[0]}+2)
                            begin
                                PC<=0;
                                DoneBootstrapping <= 1;
                                SP<=PC-1;
                            end
                        end
                    end
                end
                EXEC_INSTRUCT:
                begin
                    State<=READING_INSTRUCT;
                    InstructionReady<=0;
                    case(Instruction[23:19])
                        `MOV:
                        begin
                            case(Instruction[18:16])
                                0:
                                begin
                                    R[Instruction[15:14]] <= R[Instruction[13:12]];
                                end
                                1:
                                begin
                                    R[Instruction[15:14]] <= Instruction[7:0];
                                end
                                2:
                                begin
                                    Read_Variable(0, 
                                                 {Instruction[7:0], InstructionExtra}, 
                                                 {1'b0, Instruction[15:14]},
                                                 `ID_RAM);
                                    TempInstructionPC<=6;
                                    State<=EXEC_MICRO_INSTRUCT;
                                end
                                3:
                                begin
                                    R[Instruction[15:14]] <= RP[Instruction[13]];
                                end
                                4:
                                begin
                                    Read_Variable(0, 
                                                 {Instruction[7:0], InstructionExtra}, 
                                                 {1'b0, Instruction[15:14]},
                                                 `ID_RAM);
                                    TempInstructionPC<=6;
                                    State<=EXEC_MICRO_INSTRUCT;
                                end
                                5:
                                begin
                                    Write_Variable(0,
                                                   {Instruction[7:0], InstructionExtra},
                                                   R[Instruction[15:14]],
                                                   `ID_RAM);
                                    TempInstructionPC<=6;
                                    State<=EXEC_MICRO_INSTRUCT;
                                end
                                6:
                                begin
                                    Write_Variable(0,
                                                   {Instruction[7:0], InstructionExtra},
                                                   R[Instruction[15:14]],
                                                   `ID_RAM);
                                    TempInstructionPC<=6;
                                    State<=EXEC_MICRO_INSTRUCT;
                                end
                                7:
                                begin
                                    RP[Instruction[13]] <= R[Instruction[15:14]];
                                end
                            endcase
                        end
                        `ADD, `SUB: //DONE
                        begin
                            case(Instruction[18:16])
                                0:
                                begin
                                    if(Instruction[23:19] == `ADD) //RA, RB
                                    begin
                                        {Carry,R[Instruction[15:14]]} <= R[Instruction[15:14]] + R[Instruction[13:12]];
                                    end
                                    else
                                    begin
                                        {Carry,R[Instruction[15:14]]} <= R[Instruction[15:14]] - R[Instruction[13:12]];
                                    end
                                end
                                1:
                                begin
                                    if(Instruction[23:19] == `ADD) //RA, C
                                    begin
                                        {Carry,R[Instruction[15:14]]} <= R[Instruction[15:14]] + Instruction[7:0];
                                    end
                                    else
                                    begin
                                        {Carry,R[Instruction[15:14]]} <= R[Instruction[15:14]] - Instruction[7:0];
                                    end
                                end
                                2:
                                begin
                                    if(Instruction[23:19] == `ADD) //RP, RA
                                    begin
                                        {Carry,RP[1],RP[0]} <= {RP[1], RP[0]} + R[Instruction[15:14]];
                                    end
                                    else
                                    begin
                                        {Carry,RP[1],RP[0]} <= {RP[1], RP[0]} - R[Instruction[15:14]];
                                    end
                                end
                                3:
                                begin
                                    if(Instruction[23:19] == `ADD) //RP,C
                                    begin
                                        {Carry,RP[1],RP[0]} <= {RP[1], RP[0]} + Instruction[7:0];
                                    end
                                    else
                                    begin
                                        {Carry,RP[1],RP[0]} <= {RP[1], RP[0]} - Instruction[7:0];
                                    end
                                end
                                default:
                                begin
                                    // PANIC
                                end
                            endcase
                            InstructionReady<=0;
                        end
                        `INC: //DONE
                        begin
                            if(Instruction[16]==0)
                            begin
                                {Carry, R[Instruction[18:17]]} <= R[Instruction[18:17]] + 1;
                            end
                            else
                            begin
                                {Carry, RP[1], RP[0]} <= {RP[1], RP[0]} + 1;
                            end
                        end
                        `DEC: //DONE
                        begin
                            if(Instruction[16]==0)
                            begin
                                {Carry, R[Instruction[18:17]]} <= R[Instruction[18:17]] - 1;
                            end
                            else
                            begin
                                {Carry, RP[1], RP[0]} <= {RP[1], RP[0]} - 1;
                            end
                        end
                        `CMP: //DONE
                        begin
                            CMPA <= (R[Instruction[15:13]] > R[Instruction[12:11]]);
                            CMPB <= (R[Instruction[15:13]] < R[Instruction[12:11]]);
                            CMPE <= (R[Instruction[15:13]] == R[Instruction[12:11]]);
                        end
                        `JMP: //TBA
                        begin
                            case(Instruction[18:16])
                                3'b000:
                                begin
                                    PC<=Instruction[15:0];
                                end
                                3'b001:
                                begin
                                    if(CMPA == 1)
                                    begin
                                        PC<=Instruction[15:0];
                                    end
                                end
                                3'b010:
                                begin
                                    if(CMPE == 1)
                                    begin
                                        PC<=Instruction[15:0];
                                    end
                                end
                                3'b011:
                                begin
                                    if(CMPB == 1)
                                    begin
                                        PC<=Instruction[15:0];
                                    end
                                end
                                3'b100: //CALL
                                begin
                                    Write_Variable(0,
                                                   SP,
                                                   PC[15:8],
                                                   `ID_RAM);
                                    Write_Variable(6,
                                                   SP+1,
                                                   PC[7:0],
                                                   `ID_RAM);
                                    SP<=SP+2;
                                    TempInstructionPC<=13;
                                    State<=EXEC_MICRO_INSTRUCT;
                                    PC<=Instruction[15:0];
                                end
                                3'b101: //RET
                                begin
                                    Read_Variable(0,
                                                  SP,
                                                  3'b110,
                                                  `ID_RAM);
                                    Read_Variable(6,
                                                  SP-1,
                                                  3'b111,
                                                  `ID_RAM);
                                    TempInstructionPC<=13;
                                    SP<=SP-2;
                                    State<=EXEC_MICRO_INSTRUCT;
                                end
                            endcase
                        end
                        `LOAD:
                        begin
                        end
                        `STACKOP:
                        begin
                            State<=EXEC_MICRO_INSTRUCT;
                            if(Instruction[18]==1) //POP
                            begin
                                TempInstructionPC<=6;
                                Read_Variable(0,
                                              SP,
                                              {1'b0, Instruction[17:16]},
                                              `ID_RAM);
                                SP<=SP-1;
                            end
                            else //PUSH
                            begin
                                TempInstructionPC<=6;
                                Write_Variable(0,
                                               SP,
                                               R[Instruction[17:16]],
                                               `ID_RAM);
                                SP<=SP+1;
                            end
                        end
                        `OUTPUTID: //TBA
                        begin
                            if(Instruction[18]==0)
                            begin
                            end
                            else
                            begin
                            end
                        end
                        `OUTPUT:
                        begin
                        end
                        default:
                        begin
                            //PANIC
                        end
                    endcase
                end
                READING_INSTRUCT:
                begin
                    $display("time: %t", $time);
                    InstructionReady<=0;
                    if(InstructionReady==1)
                    begin
                        TempInstructionPC<=0;
                        State<=EXEC_INSTRUCT;
                        InstructionByte<=0;
                    end else
                    begin
                        if(TempInstructionPC==0 || TempInstructionPC == 15)
                        begin
                            InstructionByte<=0;
                            Read_Instruction(0, PC, `ID_RAM);
                            TempInstructionPC<=6;
                        end
                        State<=EXEC_MICRO_INSTRUCT;
                    end
                end
                EXEC_MICRO_INSTRUCT:
                begin
                    $display("time: %t, Instruct:%b", $time, TempInstructions[TempInstructionPC]);
                    TempInstructionPC<=TempInstructionPC-1;
                    RW<=TempInstructions[TempInstructionPC][16];
                    Id<=TempInstructions[TempInstructionPC][15:8];
                    if(TempInstructions[TempInstructionPC][21]==0)
                    begin
                        if(TempInstructions[TempInstructionPC][16] == 0)
                        begin
                            if(TempInstructions[TempInstructionPC][20]==1)
                            begin
                                PC<=PC+1;
                                if(InstructionByte==0)
                                begin
                                    InstructionByte<=InstructionByte+1;
                                    Instruction[23:16]<=Data;
                                    case(Data[7:3])
                                        5'b01000, 5'b01001, 5'b01010, 5'b01101, 5'b01110, 5'b00000:
                                        begin
                                            Read_Instruction(0, PC+1, `ID_RAM);
                                            TempInstructionPC<=6;
                                        end
                                        5'b00011:
                                        begin
                                            if(Data[18]==1)
                                            begin
                                                Read_Instruction(0, PC+1, `ID_RAM);
                                                TempInstructionPC<=6;
                                            end
                                        end
                                        default:
                                        begin
                                            State<=EXEC_INSTRUCT;
                                            InstructionReady<=1;
                                            RW<=0;
                                            Id<=`ID_NULL;
                                        end
                                    endcase
                                end
                                if(InstructionByte==1)
                                begin
                                    InstructionByte<=InstructionByte+1;
                                    Instruction[15:8]<=Data;
                                    case(Instruction[23:16])
                                        8'b01000001, 8'b01000010, 8'b01000100, 8'b01000101, 8'b01000110, 8'b01001001,
                                        8'b01010001, 8'b01110000, 8'b01110001, 8'b01110010, 8'b01110011, 8'b01110100, 
                                        8'b00000001:
                                        begin
                                            Read_Instruction(0, PC+1, `ID_RAM);
                                            TempInstructionPC<=6;
                                        end
                                        default:
                                        begin
                                            InstructionReady<=1;
                                            State<=EXEC_INSTRUCT;
                                            RW<=0;
                                            Id<=`ID_NULL;
                                        end
                                    endcase
                                end
                                if(InstructionByte==2)
                                begin
                                    InstructionByte<=InstructionByte+1;
                                    Instruction[7:0]<=Data;
                                    case (Instruction[23:16])
                                        8'b01000110, 8'b01000101, 8'b01000010, 8'b01000100:
                                        begin
                                            Read_Instruction(0, PC+1, `ID_RAM);
                                            TempInstructionPC<=6;
                                        end
                                        default:
                                        begin
                                            InstructionReady<=1;
                                            State<=EXEC_INSTRUCT;
                                            RW<=0;
                                            Id<=`ID_NULL;
                                        end
                                    endcase
                                end
                                if(InstructionByte==3)
                                begin
                                    InstructionExtra<=Data;
                                    InstructionReady<=1;
                                    State<=EXEC_INSTRUCT;
                                    RW<=0;
                                    Id<=`ID_NULL;
                                end
                            end 
                            else if(TempInstructions[TempInstructionPC][19]==1)
                            begin
                                if(TempInstructions[TempInstructionPC][18]==1)
                                begin
                                    if(TempInstructions[TempInstructionPC][17]==0)
                                        PC[7:0]<=Data;
                                    else
                                        PC[15:8]<=Data;
                                end
                                else
                                begin
                                    RP[TempInstructions[TempInstructionPC][17]]<=Data;
                                end
                            end
                            else
                            begin
                                R[TempInstructions[TempInstructionPC][18:17]]<=Data;
                            end
                        end
                        else
                        begin
                            TempData<=TempInstructions[TempInstructionPC][7:0];
                        end
                    end
                    if(TempInstructionPC == 0)
                    begin
                        if(DoneBootstrapping==1)
                        begin
                            State<=READING_INSTRUCT;
                        end    
                        else
                            State<=BOOTSTRAPPING;
                        RW<=0;
                        Id<=`ID_NULL;
                    end
                end
                default:
                begin
                    //TBA Panic
                end
            endcase
        end
    end

endmodule

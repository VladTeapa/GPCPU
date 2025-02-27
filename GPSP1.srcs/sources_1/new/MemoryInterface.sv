`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2025 03:06:20 PM
// Design Name: 
// Module Name: RAMInterface
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
`include "RomData.vh"

module MemoryInterface #(parameter RAM=0, Nr=1)( //RAM == 1 is RAM, else is ROM, ROM must be manually added
    input Clk,
    inout wire [7:0] Data, 
    input Activate,
    input Reset,
    input RW
    );

    logic [7:0] TempId = 0;
    logic [2:0] State = 0; // 0 Initial Read 8 Bit MemID, 1 Read 8 Bit Address, 2 Read 8 Bit Data, 3 Reset State (Used so that one cycle it remains active)
    logic [255:0] ActivateMultiple;
    logic [7:0] TempAddress;
    
assign ActivateMultiple = (Activate == 1 && (State >= 3 || (State>=2 && RW == 1))) ? (1<<TempId) : 0;        //Which stick to activate, max 256

    always_ff @(posedge Clk) begin
        if(Reset == 1) begin
            State <= 0;
        end else begin
            case (State)
                0:
                begin
                    if(Activate == 1) begin //Begin reading data
                        State <= 1;
                    end                     //Should be 0 if there is only 1 present
                end
                1:
                begin
                    State <= 2;             //Read the addres for stick x
                end
                2:
                begin
                    State <= 3;  
                end
                3:
                begin
                    State <= 4; 
                end
                4:
                begin
                    State <= 5; 
                end
                5:
                begin
                    State <= 0;
                end
            endcase
        end
    end
    always @(State) begin
        if(State == 1)
            TempId <= Data;   
        if(State == 2)
            TempAddress <= Data;
    end
    genvar i; //Variabila necesara pentru a genera automat
    generate
        for (i = 0;i<Nr && RAM==1;i++)
       
        begin
            RAM ram_stick(
                .Clk(Clk),
                .Activate(ActivateMultiple[i]),
                .RW(RW), // RW = 0 R, 1 W
                .Reset(Reset),
                .Address(TempAddress),
                .Data(Data)
            );
        end
    endgenerate

    generate
        if(RAM==0)
        begin
            ROM #(.Memory(ROM_STICK_0)) rom_stick_0(
                .Clk(Clk),
                .Activate(ActivateMultiple[0]),
                .Reset(Reset),
                .Address(TempAddress),
                .Data(Data)
            );
        end
    endgenerate
endmodule

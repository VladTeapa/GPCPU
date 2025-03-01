`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2025 03:19:22 PM
// Design Name: 
// Module Name: BCDControllerInterface
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


module BCDControllerInterface(
    input Clk,
    inout [7:0] Data,
    input Reset,
    input Load,
    output reg Finished,
    output reg [3:0] Numbers [7:0],
    output reg [7:0] AnodesEnabled
    );

    logic LoadState = 0;
    logic [7:0] TempData = 0;

    always_ff @(posedge Clk) begin
        Finished <= 0;
        case (LoadState)
            0:
            begin
                if(Reset == 1) begin
                    Numbers <= '{default: 4'b0000};
                    TempData <= 0;
                    AnodesEnabled <= 0;
                    Finished<=1;
                end if(Load == 1) begin
                    LoadState <= 1;
                    AnodesEnabled[Data[2:0]] <= Data[3];
                    TempData <= Data[2:0];
                end
            end
            1:
            begin
                Finished <= 1;
                LoadState <= 0;
                if(TempData <= 7)
                begin
                    Numbers[TempData] <= Data;
                end
            end
        endcase
    end
endmodule

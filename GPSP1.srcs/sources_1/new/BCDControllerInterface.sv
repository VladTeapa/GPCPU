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
    output Finished,
    output [3:0] Numbers [7:0],
    output [7:0] AnodesEnabled
    );

    logic LoadState = 0;
    logic FinishedTemp = 0;

    logic [7:0] TempData = 0;
    logic [3:0] NumbersTemp [7:0] = '{default:8'h00};
    logic [7:0] AnodesEnabledTemp = 8'h00;


    assign Numbers = NumbersTemp;
    assign AnodesEnabled = AnodesEnabledTemp;
    assign Finish = FinishedTemp;

    always_ff @(posedge Clk) begin
        FinishedTemp <= 0;
        case (LoadState)
            0:
            begin
                if(Reset == 1) begin
                    NumbersTemp <= '{default: 4'b0000};
                    TempData <= 0;
                    AnodesEnabledTemp <= 0;
                    FinishedTemp<=1;
                end if(Load == 1) begin
                    LoadState <= 1;
                    AnodesEnabledTemp[Data[2:0]] <= Data[3];
                    TempData <= Data[2:0];
                end
            end
            1:
            begin
                FinishedTemp <= 1;
                LoadState <= 0;
                if(TempData <= 7)
                begin
                    NumbersTemp[TempData] <= Data;
                end
            end
        endcase
    end
endmodule

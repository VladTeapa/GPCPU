`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2025 03:39:17 PM
// Design Name: 
// Module Name: OutputController
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

module OutputController(
        input Clk,
        input [7:0] Id,
        input [7:0] Data,
        input Reset,
        input Load,
        output reg Finish,
        output [7:0] Segments,
        output [7:0] Anodes
    );

    logic [3:0] Numbers [7:0];
    logic Finished;

    logic [255:0] Load_Internal;
    logic [255:0] Reset_Internal;
    logic [255:0] Finished_Internal = 0;

    assign Load_Internal = 0 | ((Load == 1) ? (1<<Id) : 256'b0);
    assign Reset_Internal = 0 | ((Reset == 1) ? (1<<Id) : 256'b0);
    assign Finish = Finished_Internal[Id];

    BCD #(1) BCD_Ouput(       
        .Clk(Clk),
        .Load(Load_Internal[`ID_BCD]),
        .Reset(Reset_Internal[`ID_BCD]),
        .Data(Data),
        .Finished(Finished_Internal[`ID_BCD]),
        .Segments(Segments),
        .Anodes(Anodes)
    );

endmodule

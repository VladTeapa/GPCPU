`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2025 12:50:07 PM
// Design Name: 
// Module Name: BCD
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


module BCD #(parameter CLK_NS_SWITCH = 3000000)(
        input Clk,
        input Load,
        input Reset,
        input [7:0] Data,
        output Finished,
        output [7:0] Segments,
        output [7:0] Anodes
    );

    logic [3:0] Numbers[7:0] = '{default:8'h00};
    logic [7:0] AllowedAnodes = 8'h00;

    BCDController #(CLK_NS_SWITCH) bcdControllerDisplay(
        .Clk(Clk),
        .Numbers(Numbers),
        .AllowedAnodes(AllowedAnodes),
        .Anodes(Anodes),
        .Segments(Segments)
    );

    BCDControllerInterface bcdMemoryInterface(
        .AnodesEnabled(AllowedAnodes),
        .Clk(Clk),
        .Reset(Reset),
        .Load(Load),
        .Numbers(Numbers),
        .Finished(Finished),
        .Data(Data)
    );
endmodule

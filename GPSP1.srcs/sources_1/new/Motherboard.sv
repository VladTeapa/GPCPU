`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 10:26:26 AM
// Design Name: 
// Module Name: Motherboard
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

module Motherboard(
    input Clk,
    input wire Reset,
    output RW
    );

    wire [7:0] Data;
    wire [7:0] Id;
    wire [255:0] ActivateLines;

    CPU cpu(
        .Clk(Clk),
        .Data(Data),
        .Id(Id),
        .Reset(Reset),
        .RW(RW)
    );

    Chipset chipset(
        .Id(Id),
        .Activate(ActivateLines)
    );

    MemoryInterface #(.RAM(1), .Nr(10)) ramMemoryInterface (
        .Clk(Clk),
        .Data(Data),
        .Activate(ActivateLines[`ID_RAM]),
        .RW(RW),
        .Reset(Reset)
    );

    MemoryInterface #(.RAM(0), .Nr(1)) romMemoryInterface (
        .Clk(Clk),
        .Data(Data),
        .Activate(ActivateLines[`ID_ROM]),
        .RW(RW),
        .Reset(Reset)
    );

endmodule

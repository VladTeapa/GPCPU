`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2024 11:17:13 AM
// Design Name: 
// Module Name: CounterBCD
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


module BCDController #(parameter CLK_NS_SWITCH = 3000000) (
    input Clk,
    input [3:0] Numbers [7:0],
    input [7:0] AllowedAnodes,
    output [7:0] Anodes,
    output [7:0] Segments
    );

    logic [2:0] SelBCD;
    logic [3:0] CurrentNumber;
    logic [3:0] SelBCDTemp = 0;
    logic [7:0] AnodesTemp;

    DecodificatorBCD BCD_Convert(
        .Number(CurrentNumber),
        .Enable(1),
        .Segments(Segments)
    );

    Mux81 #(8) Anodes_Mux(
        .Sel(SelBCD),
        .Q(AnodesTemp),
        .D0(8'b11111110),
        .D1(8'b11111101),
        .D2(8'b11111011),
        .D3(8'b11110111),
        .D4(8'b11101111),
        .D5(8'b11011111),
        .D6(8'b10111111),
        .D7(8'b01111111)
    );

    Mux81 #(8) Segments_Mux(
        .Sel(SelBCD),
        .Q(CurrentNumber),
        .D0(Numbers[0]),
        .D1(Numbers[1]),
        .D2(Numbers[2]),
        .D3(Numbers[3]),
        .D4(Numbers[4]),
        .D5(Numbers[5]),
        .D6(Numbers[6]),
        .D7(Numbers[7])
    );

    Counter #(.MODULO(8), .NS(CLK_NS_SWITCH)) BCD_Selector(
        .Clk(Clk),
        .Direction(1),
        .Enable(1),
        .Number(SelBCDTemp)
    );
    
    assign SelBCD = {1'b0,SelBCDTemp};
    assign Anodes = AnodesTemp | (~AllowedAnodes);
endmodule

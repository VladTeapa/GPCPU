`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 02:20:01 PM
// Design Name: 
// Module Name: Motherboard_TB
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


module Motherboard_TB(

    );

    logic Clk;

    Clock_TB uut_Clk(
        .Clk(Clk)
    );

    Motherboard motherboard(
        .Reset(0),
        .Clk(Clk)
    );

    initial
    begin
        #3000;
        $finish;
    end

endmodule

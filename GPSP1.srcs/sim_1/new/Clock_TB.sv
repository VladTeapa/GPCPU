`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2025 03:59:08 PM
// Design Name: 
// Module Name: Clock_TB
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


module Clock_TB(
        output logic Clk
    );

    initial begin
        Clk = 0;
        while(1) begin
            #1
            Clk = !Clk;
        end
    end
endmodule

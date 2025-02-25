`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2025 12:50:06 PM
// Design Name: 
// Module Name: Chipset
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


module Chipset(
    input [7:0] Id,
    output [255:0] Activate
    );

    assign Activate = (1<<Id);
    
endmodule

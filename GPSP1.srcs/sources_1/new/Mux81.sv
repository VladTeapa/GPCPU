`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2025 03:03:23 PM
// Design Name: 
// Module Name: Mux81
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


module Mux81 #(parameter WIDTH = 1)(
    input [WIDTH-1:0] D0,
    input [WIDTH-1:0] D1,
    input [WIDTH-1:0] D2,
    input [WIDTH-1:0] D3,
    input [WIDTH-1:0] D4,
    input [WIDTH-1:0] D5,
    input [WIDTH-1:0] D6,
    input [WIDTH-1:0] D7,
    input [2:0] Sel,
    output reg [WIDTH-1:0] Q
    );
    
    always_comb begin
        case (Sel) 
            3'b000: Q = D0;
            3'b001: Q = D1;
            3'b010: Q = D2;
            3'b011: Q = D3;
            3'b100: Q = D4;
            3'b101: Q = D5;
            3'b110: Q = D6;
            3'b111: Q = D7;
        endcase
    end
endmodule

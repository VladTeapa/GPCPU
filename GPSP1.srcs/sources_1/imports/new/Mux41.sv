`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/22/2024 02:29:36 PM
// Design Name: 
// Module Name: Mux41
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

//parameter este folosit pentru a face dimensiunea intrarilor generice. Spre exemplu putem avea un multiplexor 4:1 unde fiecare intrare are 8 biti
//bitstream-ul este generat in functie de ce este implicit in acest caz
module Mux41 #(parameter WIDTH = 1)(
    input [WIDTH-1:0] D0,
    input [WIDTH-1:0] D1,
    input [WIDTH-1:0] D2,
    input [WIDTH-1:0] D3,
    input [1:0] Sel,
    output reg [WIDTH-1:0] Q
    );
    
    always_comb begin
        case (Sel) 
            2'b00: Q = D0;
            2'b01: Q = D1;
            2'b10: Q = D2;
            2'b11: Q = D3;
        endcase
    end
endmodule

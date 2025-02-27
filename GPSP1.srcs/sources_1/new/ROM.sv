`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2025 02:26:32 PM
// Design Name: 
// Module Name: ROM
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




module ROM #(parameter logic[7:0] Memory [255:0] = '{default: 8'b00000000})(
        input Clk,
        input Activate,
        input Reset,
        input [7:0] Address,
        output wire [7:0] Data
    );

    logic [7:0] Rom_Data [255:0];
    logic [7:0] Temp_Data = 8'bzzzzzzzz;

    assign Rom_Data = Memory;

    assign Data = (Activate == 1) ? Temp_Data : 8'bzzzzzzzz;

    always_ff @(posedge Clk) begin
        if(Reset == 1) begin
            Temp_Data <= 8'bzzzzzzzz;
        end else begin
            if(Activate == 1) begin
                Temp_Data<=Rom_Data[Address];
            end else begin
                Temp_Data <= 8'bzzzzzzzz;
            end
        end

    end

endmodule
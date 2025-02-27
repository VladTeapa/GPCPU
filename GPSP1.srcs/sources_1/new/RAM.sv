`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2025 11:18:23 AM
// Design Name: 
// Module Name: RAM
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


module RAM (
        input Clk,
        input Activate,
        input RW, // RW = 0 R, 1 W
        input Reset,
        input [7:0] Address,
        inout wire [7:0] Data
    );

    logic [7:0] Ram_Data [255:0] ='{default: 8'b00000000};
    logic [7:0] Temp_Data;
    
    assign Data = (Activate == 1 && RW == 0) ? Temp_Data : 8'bzzzzzzzz;

    always_ff @(posedge Clk) begin
        if(Reset == 1) begin
            Ram_Data <= '{default: 8'b00000000};
        end else begin
            if(Activate == 1) begin
                if(RW == 1) begin
                    Ram_Data[Address]<=Data;
                end else begin
                    Temp_Data<=Ram_Data[Address];  
                end
            end
        end

    end

endmodule

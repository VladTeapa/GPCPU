`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2025 03:51:52 PM
// Design Name: 
// Module Name: BCDOutputTest
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


module BCDOutputTest(

    );

    logic Load;
    logic Reset;
    logic [7:0] Data;
    logic Finished;
   
    logic Clk;
    logic [3:0] Numbers[7:0];
    logic [7:0] AllowedAnodes;
    logic [7:0] Anodes;
    logic [7:0] Segments;

    BCDController #(1) uut_BCD(
        .Clk(Clk),
        .Numbers(Numbers),
        .AllowedAnodes(AllowedAnodes),
        .Anodes(Anodes),
        .Segments(Segments)
    );

    BCDControllerInterface uut_BCDInterface(
        .AnodesEnabled(AllowedAnodes),
        .Clk(Clk),
        .Reset(Reset),
        .Load(Load),
        .Numbers(Numbers),
        .Finished(Finished),
        .Data(Data)
    );

    Clock_TB uut_Clk(
        .Clk(Clk)
    );

    initial
    begin
        Reset = 0;
        Data = 0;
        Load = 0;
        #1
        Reset = 1;
        #5
        Reset = 0;
        #1
        while(Finished == 0) begin
            #1;
        end
        Data={4'b000,1'b1,3'b010};
        Load=1;
        #2
        Data=4;
        while(Finished == 0) begin
            #1;
        end
        Load=0;
        while(Finished == 0) begin
            #1;
        end
        Data={4'b000,1'b1,3'b000};
        Load=1;
        #2
        Data=3;
        while(Finished == 0) begin
            #1;
        end
        #20;
        $finish;
    end
endmodule

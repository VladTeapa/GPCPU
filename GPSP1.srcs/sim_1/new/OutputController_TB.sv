`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2025 12:59:59 PM
// Design Name: 
// Module Name: OutputController_TB
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


module OutputController_TB(

    );

    logic Clk;
    logic [7:0] Id;
    logic [7:0] Data;
    logic Reset;
    logic Load;
    logic Finish;
    logic [7:0] Segments;
    logic [7:0] Anodes;

    OutputController uut_OutputController(
        .Clk(Clk),
        .Id(Id),
        .Data(Data),
        .Reset(Reset),
        .Load(Load),
        .Finish(Finish),
        .Segments(Segments),
        .Anodes(Anodes));

    Clock_TB uut_Clk(
        .Clk(Clk)
    );

    initial begin
        Id = 1;
        Load = 0;
        Reset = 1;
        #3;
        Id = 0;
        #3;
        Reset = 0;
        #11;
        Load = 1;
        Data={4'b0000,1'b1,3'b010};
        #2;
        Data=3;
        Load = 0;
        #30;
        $finish;
    end
endmodule

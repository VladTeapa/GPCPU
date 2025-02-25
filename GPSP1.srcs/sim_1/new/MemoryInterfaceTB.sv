`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2025 01:51:25 PM
// Design Name: 
// Module Name: MemoryInterfaceTB
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


module MemoryInterfaceTB(

    );

    logic Clk;
    logic Activate;
    logic Reset;
    logic RW;
    logic [7:0] driver;
    wire [7:0] Data;

    assign Data = (Activate == 1 && RW == 1) ? driver : 8'bzzzzzzzz;
    
    MemoryInterface #(.RAM(1), .Nr(2)) uut_MemoryInterface(
        .Clk(Clk),
        .Data(Data),
        .Activate(Activate),
        .Reset(Reset),
        .RW(RW)
    );

    Clock_TB uut_Clk(
        .Clk(Clk)
    );

    initial begin
        Reset = 1;
        RW = 1;
        #1
        Reset = 0;
        driver = 1;
        Activate = 1;
        #1
        #1
        driver = 3;
        #1
        #1
        driver = 123;
        #1
        #1
        driver = 0;
        #1
        #1
        driver = 10;
        #1
        #1
        driver = 201;
        #2
        driver = 1;
        #2
        driver = 3;
        #2
        RW = 0;
        #2
        RW=1;
        driver = 0;
        #2
        driver = 10;
        #2
           RW = 0;
        #2
        Activate = 0;
        RW=1;
        #10
        $finish;
    end
endmodule

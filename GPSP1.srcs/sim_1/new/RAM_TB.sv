`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2025 11:58:49 AM
// Design Name: 
// Module Name: RAM_TB
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


module RAM_TB(

    );
    
    logic Clk;
    logic Activate;
    logic RW;
    logic Reset;
    logic [7:0] Address;
    logic [7:0] driver;
    wire [7:0] Data;

    assign Data = (Activate == 1 && RW == 1) ? driver : 8'bzzzzzzzz;

    Clock_TB uut_Clk(
        .Clk(Clk)
    );

    RAM uut_RAM(
        .Clk(Clk),
        .Activate(Activate),
        .RW(RW),
        .Reset(Reset),
        .Address(Address),
        .Data(Data)
    );
    initial begin
        RW=1;
        Activate=0;
        Reset=1;
        #4;
        Reset=0;
        for(int i =0;i<10;i++)
        begin
            Activate=0;
            #4
            Activate=1;
            Address=8'h10+i;
            driver=i;
            #2;
        end
        Activate=0;
        #4
        RW=0;
        for(int i =0;i<10;i++)
        begin
            Activate=0;
            #4
            Activate=1;
            Address=8'h10+i;
            #2;
        end
        $finish;
    end
endmodule

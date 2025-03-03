`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2024 12:44:00 PM
// Design Name: 
// Module Name: Counter
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

//Acest numarator practic contine doua in interior
//Unul pentru a numara o secunda sau cate NS sunt date prin parametru
//Unul pentru a numara de la 0 la 15
module Counter #(parameter NS=1000000000, parameter MODULO=16)( //NS=1000000000 = 1S
    input Clk,
    input Reset,
    input Direction,
    input Enable,
    output logic [3:0] Number,
    output logic TC
    );
    
    int temp = 0;
    logic TCTemp = 0;
    logic [3:0] NumberTemp = 0;

    assign TC = TCTemp;
    assign Number = NumberTemp;

    //Daca avem front crescator la ceas sau reset schimbam valorile
    always_ff @(posedge Clk or posedge Reset)
    begin
        TCTemp<=0;
        //Daca s-a dat reset nu ne intereseaza decat sa punem
        //Temp = 0 si Numar = Valoare initiala
        if(Reset == 1)
        begin
            NumberTemp<= (Direction == 0 ? MODULO-1: 0);
            temp<=0;
        end
        else if (Enable == 1)
        begin
            temp<=temp+1;
            //Se foloseste aceasta formula pentru ca 
            //Ceasul de pe E3 are 100MHZ
            if(temp>=(NS/10)-1)  //100000000*(NS/1000000)
            begin
                temp<=0;
                //Se incrementeaza sau decrementeaza
                NumberTemp<=NumberTemp + (Direction==0 ? -1 : 1);
                //Se da peste cap cand ajunge la final si se seteaza TC
                if(NumberTemp>=MODULO-1 && Direction == 1)
                begin
                    TCTemp<=1;
                    NumberTemp<=0;
                end
                if(NumberTemp == 0 && Direction == 0)
                begin
                    TCTemp<=1;
                    NumberTemp<=MODULO-1;
                end
            end
        end
    end
    
endmodule

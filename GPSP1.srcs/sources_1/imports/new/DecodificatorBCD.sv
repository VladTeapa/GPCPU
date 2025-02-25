`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/21/2024 01:10:41 PM
// Design Name: 
// Module Name: DecodificatorBCD
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


module DecodificatorBCD(
    input [3:0] Number,
    input Enable,
    input [7:0] AnodesInput, //Vom controla din input care ecran se aprinde
    output reg [7:0] Segments,
    output reg [7:0] Anodes
    );
    function logic [7:0] SegmentsDecode; //Pentru a vizualiza mai bine vom crea o functie
        input logic [3:0] value;
        begin
            case (value)
                0: SegmentsDecode=8'b00000011;
                1: SegmentsDecode=8'b10011110;
                2: SegmentsDecode=8'b00100101;
                3: SegmentsDecode=8'b00001100;
                4: SegmentsDecode=8'b10011001;
                5: SegmentsDecode=8'b01001000;
                6: SegmentsDecode=8'b01000001;
                7: SegmentsDecode=8'b00011110;
                8: SegmentsDecode=8'b00000001;
                9: SegmentsDecode=8'b00001000;
                10:SegmentsDecode=8'b00010001;
                11:SegmentsDecode=8'b11000000;
                12:SegmentsDecode=8'b01100011;
                13:SegmentsDecode=8'b10000100;
                14:SegmentsDecode=8'b01100001;
                15:SegmentsDecode=8'b01110000;
                default:SegmentsDecode=0;
            endcase 
        end
    endfunction
    
    //De fiecare data cand se modifica o intrare se va intra in acest bloc. 
    //Asignarile "=" sunt blocante. Always_comb suporta doar blocante.
    always_comb begin
        if(Enable == 0) begin
            Segments = 0;
            Anodes = 8'b11111111;
        end
        else begin
            Segments=SegmentsDecode(Number);
            Anodes = AnodesInput;
        end
    end
    
endmodule

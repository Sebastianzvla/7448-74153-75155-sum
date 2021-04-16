module SN7448 (Z, SEG, com);
 input [3:0] Z;
 output com;
 output reg [6:0] SEG;
 //                          GFEDCBA - LOS 1 APAGAN   
 parameter [6:0] cero   = 7'b1000000;
 parameter [6:0] uno    = 7'b1111001;
 parameter [6:0] dos    = 7'b0100100;
 parameter [6:0] tres   = 7'b0110000;
 parameter [6:0] cuatro = 7'b0011001;
 parameter [6:0] cinco  = 7'b0010010;
 parameter [6:0] seis   = 7'b0000010;
 parameter [6:0] siete  = 7'b1111000;
 parameter [6:0] ocho   = 7'b0000000;
 parameter [6:0] nueve  = 7'b0010000;
 parameter [6:0] A      = 7'b0001000;
 parameter [6:0] B      = 7'b0000011;
 parameter [6:0] C      = 7'b1000110;
 parameter [6:0] D      = 7'b0100001;
 parameter [6:0] E      = 7'b0000110;
 parameter [6:0] F      = 7'b0001110;
 parameter [6:0] guion  = 7'b0000001;
 
always @ (Z)
 begin
  case(Z)
    0: SEG = cero;
    1: SEG = uno;
    2: SEG = dos;
    3: SEG = tres;
    4: SEG = cuatro;
    5: SEG = cinco;
     6: SEG = seis;
     7: SEG = siete;
     8: SEG = ocho;
     9: SEG = nueve;
     10: SEG = A;
     11: SEG = B;
     12: SEG = C;
     13: SEG = D;
     14: SEG = E;
     15: SEG = F;
     default: SEG = guion;
  endcase
 end
 assign com = 0;
endmodule 
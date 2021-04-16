module Count(
   parameter N=3,       
   parameter Mod=20      
   input clk,           
   input clr,           
   output reg [N-1:0] Q 
   );

always @(posedge clk or posedge clr) begin
   if(clr) Q<=0;          //Si se presiona clr el proximo valor de Q sera 0 de forma asincrona.
   else if(Q==Mod) Q<=0;  //De lo contrario Si Q es igual a Mod (en este caso 9) el proximo valor de Q sera 0.
   else Q<=Q+1;           //De lo contrario el proximo valor de Q sera 0.
end

endmodule 
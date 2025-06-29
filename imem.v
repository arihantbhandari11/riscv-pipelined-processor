module imem (input [31:0] a,
             output [31:0] rd);
              
            reg [31:0] RAM[63:0]; 
            
            initial begin
        $readmemh("instruction.hex",RAM); 
        end
        
        assign rd = RAM[a[31:2]]; // last two bits of address is 00 
endmodule

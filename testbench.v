module testbench(); 
reg        clk; 
reg        reset; 
wire [31:0] WriteData, DataAdr; 
wire        MemWrite;  
 
pipeline_processor dut(.clk(clk), .reset(reset), .WriteDataM(WriteData),
     .DataAdrM(DataAdr), .MemWriteM(MemWrite)); 
 
initial 
begin 
reset <= 1; # 5; reset <= 0;
#500 $finish; 
end 
 
always 
begin 
clk <= 0; # 5; clk <= 1; # 5; 
end 
  

endmodule

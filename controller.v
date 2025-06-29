module controller (input clk, reset,
                   //Decode stage control signals
                   input [6:0] opD,
                   input [2:0] funct3D,
                   input funct7b5D,
                   output [2:0] ImmSrcD,
                   //Execute stage control signals 
                   input FlushE,
                   input ZeroE,
                   output PCSrcE, // for datapath and Hazard unit
                   output [2:0] ALUControlE,
                   output ALUSrcAE, 
                   output ALUSrcBE, //for lui              
                   output ResultSrcEb0, //for Hazard Unit
                   //Memory stage control signals
                   output MemWriteM,
                   output RegWriteM, //for Hazard Unit
                   //WriteBack stage control signals
                   output RegWriteW, //for datapath and hazard unit
                   output [1:0] ResultSrcW);
                   
  // pipelined control signals 
  wire      RegWriteD, RegWriteE; 
  wire [1:0] ResultSrcD, ResultSrcE, ResultSrcM; 
  wire       MemWriteD, MemWriteE; 
  wire      JumpD, JumpE; 
  wire      BranchD, BranchE; 
  wire [1:0] ALUOpD; 
  wire [2:0] ALUControlD; 
  wire      ALUSrcAD; 
  wire      ALUSrcBD;  // for lui 
      
 //Decode stage logic                                                         
 maindec md (.op(opD), .RegWrite(RegWriteD), .ResultSrc(ResultSrcD), .MemWrite(MemWriteD), .Jump(JumpD), 
             .Branch(BranchD), .ALUSrcA(ALUSrcAD), .ALUSrcB(ALUSrcBD), .ImmSrc(ImmSrcD), .ALUOp(ALUOpD));       
 aludec ad (.opb5(opD[5]), .funct3(funct3D), .funct7b5(funct7b5D), .ALUOp(ALUOpD), .ALUControl(ALUControlD));
 
 // Execute stage pipeline control register and logic 
  floprc #(11) controlregE (.clk(clk), .reset(reset), .clear(FlushE), 
                           .d({RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD,                   
                           ALUControlD, ALUSrcAD, ALUSrcBD}), .q({RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE,  
                           ALUControlE, ALUSrcAE, ALUSrcBE}));
                   
                     assign PCSrcE = (BranchE & ZeroE) | JumpE; 
                     assign ResultSrcEb0 = ResultSrcE[0];            

  // Memory stage pipeline control register 
  flopr #(4) controlregM (.clk(clk), .reset(reset), 
                         .d({RegWriteE, ResultSrcE, MemWriteE}), 
                         .q({RegWriteM, ResultSrcM, MemWriteM})); 
   
  // Writeback stage pipeline control register 
  flopr #(3) controlregW(.clk(clk), .reset(reset), 
                         .d({RegWriteM, ResultSrcM}), 
                         .q({RegWriteW, ResultSrcW}));
 
 
endmodule 

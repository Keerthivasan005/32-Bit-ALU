// Code your testbench here
// or browse Examples
/*
module t_mux;
  reg [1:0] sel;
  reg in0, in1, in2, in3;
  wire out;
  mux4_1 MUT0(sel,in0, in1, in2, in3, out);
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1,t_mux);
      sel = 0; in0 = 1; in1 = 0; in2 = 1; in3 = 0;
      #5 sel = 1;
      #5 sel = 2;
      #5 sel = 3;
      #5 in0 = 0; in1 = 1; in2 = 0; in3 = 1;
      #5 sel = 1;
      #5 sel = 2;
      #5 sel = 0;
      #5 $finish;
    end
endmodule
*/

/*
module t_arith_add;
  reg [31:0] a,b;
  reg sel;
  wire [31:0] out;
  wire Z, V, N;
  arith_add MUT1(a,b,sel,out,Z,V,N);
  
  initial 
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1,t_arith_add);
      sel = 0; a = 0; b = 0;
      #5 a = 24; b = 57;
      #5 sel = 1;
      #5 b= 24; a = 57;
      #5 a = -1; b = -2; sel = 0;
      #5 a = -3; b = 3;
      //#5 a = 1,07,37,41,821; b = 3;
      #5 b = -3;
      //#5 a = -1,07,37,41,821;
      #5 sel = 1;
      #5 b = 3;
      //#5 a = 1,07,37,41,821;
      #5 $finish;
    end
endmodule
*/
  
/*
module t_cmp;
  reg [31:0] a,b;
  reg [1:0] sel;
  wire [31:0] out;
  cmp MUT2(a, b, sel, out);
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1,t_cmp);
      sel = 0; a = 0; b = 0;
      #5 sel = 1; a= 4; b = 3;
      #5 b = 4;
      #5 b = 5;
      #5 sel = 2;
      #5 b = -1;
      #5 b = 4;
      #5 b = 5;
      #5 sel = 3;
      #5 b = -2;
      #5 b = 4;
      #5 b = 5;
      #5 $finish;
    end

endmodule
*/

/*
module t_bool;
  reg [31:0] a, b;
  reg [3:0] fn;
  wire [31:0] out;
  bitwise_bool MUT3(a, b, fn, out);
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1,t_bool);
      fn = 0; a = 0; b = 0;
      #5 fn = 14; a = 1; b = 2;		// fn = 1110 is OR gate
      #5 a = 3;
      #5 fn = 8;					// fn = 1000 is AND gate
      #5 fn = 6;					// fn = 0110 is XOR gate
      #5 $finish;
    end
  
endmodule
*/

module t_ALU;
  reg [31:0] a, b;
  reg [5:0] fn;
  wire [31:0] out;
  ALU MUT4(a, b, fn, out);
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1,t_ALU);
      $monitor($time, " a = %d, b = %d, fn=%d, out = %d",a,b,fn,out);
      fn = 0; a = 0; b = 0;
      #5 fn = 3; a = 5; b = 9;		// fn = 00_011 is CMPEQ
      #5 fn = 3; a = 9; b = 9;
      #5 fn = 3; a = -2; b = 9;
      #5 fn = 5; a = -2; b = 9;					// fn = 00_101 is CMPLT
      #5 fn = 5; a = -2; a = 9; b = 9;
      #5 fn = 5; a = 11; b = 9;
      #5 fn = 7; a = 11; b = 11; 			// fn = 00_111 is CMPLE
      #5 fn = 7; a = 11; b = 7;
      #5 fn = 7; a = 11; b = 13;
      #5 fn = 16; a = 9; b = 13;					// fn = 01___0 is ADD
      #5 fn = 16; a = -13; b = 13;
      #5 fn = 16; a = -15; b = 13;
      #5 fn = 16; a = -15; b = -15;
      #5 fn = 17;a = -15; b = -15; 					// fn = 01___1 is SUBTRACT
      #5 fn = 17; a = 8; b = -15;
      #5 fn = 17; a = -6; b = 14;
      #5 fn = 6'b101000; a = 3; b = 2;		// fn = 10abcd is Bitwise Boolean
      #5 fn = 6'b100110; a = 3; b = 2;
      #5 fn = 6'b101110; a = 3; b = 2;
      #5 fn = 48; a = 3; b = 1;		// fn = 11__00 is Logcial Left Shift
      #5 fn = 48; a = -1; b = 1;
      #5 fn = 48; a = -1; b = 2;	
      #5 fn = 49; a = -1; b = 2;	// fn = 11__01 is Logical Right Shift
      #5 fn = 49; a = -1; b = 1;
      #5 fn = 51; a = -1; b = 1;	// fn = 11__11 is Arithmetic Right Shift;
      #5 fn = 51; a = -1; b = 2;
      #5 fn = 51; a = -2; b = -1;
      #5 fn = 51; a = 7; b = -1;
      #5 $finish;
    end
  
endmodule
      
		      
  
    
// Code your design here
// 32-Bit ALU Designed by : Keerthivasan S K
module mux4_1(input [1:0] sel,
              input [3:0] in,
              output reg out);
  
  always @ (*)
    case(sel)
      2'b00: out = in[0];
      2'b01: out = in[1];
      2'b10: out = in[2];
      2'b11: out = in[3];
      default: out = 1'bx;
    endcase
  
endmodule

module arith_add(input [31:0] a,
                 input [31:0] b,
                 input sel,
                 output [31:0] out,
                 output Z,
                 output V,
                 output N);
  wire xb;
  xor g0(xb,b[31],sel);
  assign out = sel ? a - b : a + b;
  assign Z = !(out);
  assign V = (a[31] && xb && (!out[31])) || ((!a[31]) && (!xb) && out[31]);
  assign N = out[31];
              
endmodule

module cmp(input [31:0] a,
           input [31:0] b,
           input [1:0] sel,
           output reg [31:0] out);
  wire [31:0] Q;
  wire V, Z, N;
  wire lt, le;
  
  arith_add m0(a, b, 1'b1, Q, Z, V, N);
  xor g1(lt, V, N);
  or g2(le, Z, lt);
  always @(*)
      case(sel)
        2'b01: out = Z;
        2'b10: out = lt;
        2'b11: out = le;
        default: out = 1'bx;
      endcase
  

endmodule

module bitwise_bool(input [31:0] a,
                    input [31:0] b,
                    input [3:0] fn,
                    output [31:0] out);
  genvar i;
  generate
  for(i = 0; i < 32; i = i + 1)
    begin: mux4_1_gen_label
      mux4_1 mux_inst({b[i],a[i]}, fn, out[i]);
    end
  endgenerate
  
endmodule

module shift(input [31:0] a,
             input [31:0] b,
             input [1:0] sel,
             output reg [31:0] out);
  wire [31:0] t0, t1, t3;
  
  assign t0 = a << b;
  assign t1 = a >> b;
  assign t3 = a >>> b;
  always @ (*)
    case(sel)
      2'b00: out = t0;
      2'b01: out = t1;
      2'b11: out = t3;
      default: out = 1'bx;
    endcase
  
endmodule
  
  
  
module ALU(input [31:0] a,
           input [31:0] b,
           input [5:0] fn,
           output reg [31:0] out);
  wire Z, V, N;
  wire [31:0] t0, t1, t2, t3;
  
  genvar i;
  generate
  for(i = 0; i < 32; i = i + 1)
    begin: mux4_1_gen_label
      mux4_1 mux_inst({b[i],a[i]}, fn[3:0], t2[i]);
    end
  endgenerate
  
  cmp m1(a, b, {fn[2],fn[1]}, t0);
  arith_add m2(a, b, fn[0], t1, Z, V, N);
  shift m4(a, b, {fn[1],fn[0]}, t3);
  
  always @ (*)
    case({fn[5],fn[4]})
      2'b00: out = t0;
      2'b01: out = t1;
      2'b10: out = t2;  	
      2'b11: out = t3; 
    endcase
 
endmodule
       
          
        
  
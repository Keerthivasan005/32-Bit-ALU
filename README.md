# 32-Bit-ALU
Verilog code for 32 Bit ALU

The 32-bit ALU is a combinational circuit taking two 32-bit data words A and B as inputs, and producing a 32-bit output Y by performing a specified arithmetic or logical function on the A and B inputs. The particular function to be performed is specified by a 6-bit control input, FN, whose value encodes the function according to the following table:
FN[5:0]	Operation	Output value Y[31:0]
00-011	CMPEQ	Y=(A==B)
00-101	CMPLT	Y=(A<B)
00-111	CMPLE	Y=(A≤B)
01---0	32-bit ADD	Y=A+B
01---1	32-bit SUBTRACT	Y=A−B
10abcd	Bit-wise Boolean	Y[i]=Fabcd(A[i],B[i])
11--00	Logical Shift left (SHL)	Y=A<<B
11--01	Logical Shift right (SHR)	Y=A>>B
11--11	Arithmetic Shift right (SRA)	Y=A>>B (sign extended)
Note that by specifying an appropriate value for the 6-bit FN input, the ALU can perform a variety of arithmetic operations, comparisons, shifts, and bitwise Boolean combinations.


Bi	Ai	Yi
0	0	d
0	1	c
1	0	b
1	1	a
The bitwise Boolean operations are specified by FN[5:4]=10; in this case, the remaining FN bits abcd are taken as entries in the truth table describing how each bit of Y is determined by the corresponding bits of A and B, as shown to the right.

The three compare operations each produce a Boolean output. In these cases, Y[31:1] are all zero, and the low-order bit Y[0] is a 0 or 1 reflecting the outcome of the comparison between the 32-bit A and B operands.

We can approach the ALU design by breaking it down into subsystems devoted to arithmetic, comparison, Boolean, and shift operations as shown below:

Designing a complex system like an ALU is best done in stages, allowing individual subsystems to be designed and debugged one at a time. The steps below follow that approach to implementing the ALU block diagram shown above. We begin by implementing an ALU framework with dummy modules for each of the four major subsystems (BOOL, ARITH, CMP, and SHIFT); we then implement and debug real working versions of each subsystem. To help you follow this path, we provide separate tests for each of the four component modules.

NOTE: the FN signals used to control the operation of the ALU circuitry use an encoding chosen to make the design of the ALU circuitry simple. This encoding is typically not the same as the one used to encode the opcode field of the processor instruction and the processor circuitry will include logic to generate the appropriate ALU control bits for each instruction.

BOOL unit

Design the circuitry to implement the Boolean operations for your ALU and use it to replace the jumper and wire that connects the Y[31:0] output to ground.

The suggested implementation uses 32 copies of a 4-to-1 multiplexor (mux4) where BFN[3:0] encode the operation to be performed and A[31:0] and B[31:0] are hooked to the multiplexor's select inputs. This implementation can produce any of the 16 2-input Boolean functions.

For example, the MUX4 gate shown above has a 1-bit output signal, which in this schematic is hooked to Y[31:0], a signal of width 32. So we need to replicate the MUX4 32 times, the output of the first MUX4 connects to Y[31], the output of the second MUX4 connects to Y[30], and so on.

The input signals are then replicated (if necessary) to provide the inputs for each of the 32 MUX4 gates.

Each MUX4 gate requires 2 select signals, which are taken from the 64 signals provided. B[31] and A[31] connect to the select lines of the first MUX4, B[30] and A[30] connect to the select lines of the second MUX4, and so on.

Each MUX4 gate requires 4 data signals. The specified BFN inputs are only 1 bit wide, so the specified signals are each replicated 32 times, e.g., BFN[0] is used as the D0 input for each of the 32 MUX4s.
The following table shows the encodings for some of the BFN[3:0] control signals used by the test jig (and in our typical Beta implementations):
Operation	BFN[3:0]
AND	1000
OR	1110
XOR	0110
"A"	1010
The BOOL test actually checks all 16 boolean operations on a selection of arguments, and will report any errors that it finds.

ARITH unit

Design an adder/subtractor (ARITH) unit that operates on 32-bit two's complement inputs and generates a 32-bit output. It will be useful to generate three other output signals to be used by the CMP unit: Z which is true when the S outputs are all zero, V which is true when the addition operation overflows (i.e., the result is too large to be represented in 32 bits), and N which is true when the sum is negative (i.e., S[31] = 1). Overflow can never occur when the two operands to the addition have different signs; if the two operands have the same sign, then overflow can be detected if the sign of the result differs from the sign of the operands:
V=XA31⋅XB31⋅(!S31)+XA31⋅(!XB31)⋅(!S31)
Note that this equation uses XB[31], which is the high-order bit of the B operand to the adder itself (i.e., after the XOR gate -- see the schematic below). XA[31] is simply A[31].

The following schematic is one suggestion for how to go about the design:

AFN will be set to 0 for an ADD (S=A+B) and 1 for a SUBTRACT (S=A−B); A[31:0] and B[31:0] are the 32-bit two's complement input operands; S[31:0] is the 32-bit result; Z/V/N are the three condition code bits described above. We'll be using the "little-endian" bit numbering convention where bit 31 is the most-significant bit and bit 0 is the least-significant bit.

We've provided a FA module for entering the gate-level schematic for the full adder to be used in constructing the 32-bit ripple carry adder that forms the heart of the ARITH unit.

The AFN input signal selects whether the operation is an ADD or SUBTRACT. To do a SUBTRACT, the circuit first computes the two's complement negation of the B operand by inverting B and then adding one (which can be done by forcing the carry-in of the 32-bit add to be 1). Start by implementing the 32-bit add using a ripple-carry architecture (you'll get to improve on this later on in the course). You'll have to construct the 32-input NOR gate required to compute Z using a tree of smaller fan-in gates (the parts library only has gates with up to 4 inputs).

When entering your circuitry, remember to delete the original jumpers and wires that connected the outputs to ground!

The module test tries adding and subtracting various operands, ensuring that the Z, V and N outputs are correct after each operation.

CMP unit

The ALU provides three comparison operations for the A and B operands. We can use the adder unit designed above to compute A−B and then look at the result (actually just the Z, V and N condition codes) to determine if A=B, A<B or A≤B. The compare operations generate a 32-bit result using the number 0 to represent false and the number 1 to represent true.

Design a 32-bit compare (CMP) unit that generates one of two constants (0 or 1) depending on the CFN[1:0] control signals (used to select the comparison to be performed) and the Z, V, and N outputs of the adder/subtractor unit. Clearly the high order 31 bits of the output are always zero. The least significant bit (LSB) of the output is determined by the comparison being performed and the results of the subtraction carried out by the adder/subtractor:
Comparison	Equation for LSB	CFN[1:0]
A=B	LSB = Z	01
A<B	LSB = N⊕V	10
A≤B	LSB = Z+(N⊕V)	11
At the level of the ALU module, FN[2:1] are used to control the compare unit since we need to use FN[0] to control the adder/subtractor unit to force a subtract.

Performance note: the Z, V and N inputs to this circuit can only be calculated by the adder/subtractor unit after the 32-bit add is complete. This means they arrive quite late and then require further processing in this module, which in turn makes Y[0] show up very late in the game. You can speed things up considerably by thinking about the relative timing of Z, V and N and then designing your logic to minimize delay paths involving late-arriving signals.

The module test ensures that the correct answer is generated for all possible combinations of Z, V, N and CFN[1:0].

SHIFT unit

Design a 32-bit shifter that implements logical left shift (SHL), logical right shift (SHR) and arithmetic right shift (SRA) operations. The A operand supplies the data to be shifted and the low-order 5 bits of the B operand are used as the shift count (i.e., from 0 to 31 bits of shift). The desired operation will be encoded on SFN[1:0] as follows:
Operation	SFN[1:0]
SHL (shift left)	00
SHR (shift right)	01
SRA (shift right with sign extension )	11
With this encoding, SFN[0] is 0 for a left shift and 1 for a right shift and SFN[1] controls the sign extension logic on right shift. For SHL and SHR, 0's are shifted into the vacated bit positions. For SRA ("shift right arithmetic"), the vacated bit positions are all filled with A[31], the sign bit of the original data so that the result will be the same as dividing the original data by the appropriate power of 2.

The module test checks that all three types of shifts are working correctly.

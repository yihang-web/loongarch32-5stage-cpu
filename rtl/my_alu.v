`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/24 20:10:06
// Design Name: 
// Module Name: my_alu
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

// ALU模块（保持原有所有操作）
module adder_32(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output reg [31:0] f,
    output reg cout
);
    always @(*) begin
        {cout, f} = a + b + cin;
    end
endmodule
module my_alu(
    input [31:0] A,
    input [31:0] B,
    input Cin,
    input [4:0] Card,
    output reg [31:0] F,
    output reg Cout,
    output reg Zero
);

    reg [31:0] adder_a, adder_b;
    reg adder_cin;
    wire [31:0] adder_f;
    wire adder_cout;

    adder_32 adder_inst (
        .a(adder_a),
        .b(adder_b),
        .cin(adder_cin),
        .f(adder_f),
        .cout(adder_cout)
    );

    always @(*) begin
        adder_a = 32'b0;
        adder_b = 32'b0;
        adder_cin = 1'b0;
        F = 32'b0;
        Cout = 1'b0;

        case (Card)
            5'b00000: begin // A + B
                adder_a = A;
                adder_b = B;
                adder_cin = 1'b0;
                F = adder_f;
                Cout = adder_cout;
            end
            5'b00001: begin // A + B + Cin
                adder_a = A;
                adder_b = B;
                adder_cin = Cin;
                F = adder_f;
                Cout = adder_cout;
            end
            5'b00010: begin // A - B
                adder_a = A;
                adder_b = ~B;
                adder_cin = 1'b1;
                F = adder_f;
                Cout = adder_cout;
            end
            5'b00011: begin // A - B - Cin
                adder_a = A;
                adder_b = ~B;
                adder_cin = 1'b1 - Cin;
                F = adder_f;
                Cout = adder_cout;
            end
            5'b00100: begin // B - A
                adder_a = B;
                adder_b = ~A;
                adder_cin = 1'b1;
                F = adder_f;
                Cout = adder_cout;
            end
            5'b00101:begin
                adder_a=~A;
                adder_b=B;
                adder_cin=1'b1-Cin;
                F=adder_f;
                Cout=adder_cout;
            end
            5'b00110: F = A; // 传送A
            5'b00111: F = B; // 传送B
            5'b01000: F = ~A; // ~A
            5'b01001: F = ~B; // ~B
            5'b01010: F = A | B; // A | B
            5'b01011: F = A & B; // A & B
            5'b01100: F = A ~^ B; // 同或
            5'b01101: F = A ^ B; // 异或
            5'b01110: F = ~(A & B); // 与非
            5'b01111: F = 32'b0; // 输出0
            5'b10000: F = A << $unsigned(B); // 左移
            5'b10001: F = A + B; // a+sign12
            5'b10010: F = $signed(A) * $signed(B); // 乘法
            5'b10011: F = ($signed(A) < $signed(B)) ? 1'b1 : 1'b0; // 小于
            5'b10101: F = 32'b1; // 分支总是成立
            5'b10110: F = (A == B) ? 1'b1 : 1'b0; // 等于
        endcase
        Zero = (F == 32'b0) ? 1'b1 : 1'b0;
    end
endmodule

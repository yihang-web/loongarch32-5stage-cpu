// 寄存器模块（保持不变）
module mips_register(
input clk,
input we,
input [4:0] raddr1,
input [4:0] raddr2,
input [4:0] waddr,
input [31:0] wdata,
output [31:0] rdata1,
output [31:0] rdata2);
    reg [31:0] register[31:0];
    
    assign rdata1 = register[raddr1];
    assign rdata2 = register[raddr2];
    
    always @(posedge clk) begin
        if(we && waddr != 5'b0) begin // 0寄存器不可写
            register[waddr] <= wdata;
        end
    end
    
    integer i;
    initial begin // 仿真初始化
        for(i=0; i<32; i=i+1)
            register[i] = 0;  
    end  
endmodule
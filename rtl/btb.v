module my_btb (
    input clk,                  // 时钟
    input resetn,               // 异步复位（低有效）
    // 读端口（取指阶段查询BTB）
    input [31:0] check_pc,   
    output reg btb_hit,              // 命中信号（1:命中，0:未命中）
    output reg [31:0] btb_target_pc,
    
    // 写端口（更新BTB，如分支指令执行后）
    input btb_we,               // 写使能（1:更新BTB）
    input [31:0] pc_write,      // 待写入的分支指令PC
    input jump_valid,//pc执行时是否跳转
    input [31:0] target_pc_write
);

// BTB参数：512条目（2^9），索引9位，标签23位
// 声明BTB存储数组（512个条目）
reg [56:0] btb[511:0];
reg [56:0] btb_item;

// 组合逻辑：查询BTB并判断命中
always @(*) begin
    if (!resetn) begin
        btb_hit=1'b0;
        btb_target_pc=32'h0;
    end 
    else begin
           btb_item=btb[check_pc[8:0]];
        // 命中条件：有效位为1，且标签匹配
        if ((btb_item[56:55]==2'b10||btb_item[56:55]==2'b11)&&btb_item[54:32]==check_pc[31:9]) begin
            btb_hit = 1'b1;
            btb_target_pc=btb_item[31:0];
        end 
        else begin
            btb_hit = 1'b0;
            btb_target_pc= 32'h0;          
        end
    end
end
integer i;
// 时序逻辑：更新BTB（在时钟沿写入），hit为1执行未跳转和hit为0执行时跳转需写入
always @(posedge clk) begin
    if (!resetn) begin
        // 同步复位所有BTB条目
        for (i = 0; i < 512; i = i + 1) begin
            btb[i] <= 57'b0;
        end
    end
    else if (btb_we) begin
        if(btb[pc_write[8:0]][56:55]==2'b00)begin
            if(jump_valid)begin
                btb[pc_write[8:0]]<={2'b01,pc_write[31:9],target_pc_write};
            end
            else begin
                btb[pc_write[8:0]]<={2'b00,pc_write[31:9],target_pc_write};
            end
        end
        else if(btb[pc_write[8:0]][56:55]==2'b01)begin
            if(jump_valid)begin
                btb[pc_write[8:0]]<={2'b10,pc_write[31:9],target_pc_write};
            end
            else begin
                btb[pc_write[8:0]]<={2'b00,pc_write[31:9],target_pc_write};
            end
        end
        else if(btb[pc_write[8:0]][56:55]==2'b10)begin
            if(!jump_valid)begin
                btb[pc_write[8:0]]<={2'b01,pc_write[31:9],target_pc_write};
            end
            else begin
                btb[pc_write[8:0]]<={2'b11,pc_write[31:9],target_pc_write};
            end
        end
         else if(btb[pc_write[8:0]][56:55]==2'b11)begin
            if(jump_valid)begin
                btb[pc_write[8:0]]<={2'b11,pc_write[31:9],target_pc_write};
            end
            else begin
                btb[pc_write[8:0]]<={2'b10,pc_write[31:9],target_pc_write};
            end
        end
  end
end

endmodule

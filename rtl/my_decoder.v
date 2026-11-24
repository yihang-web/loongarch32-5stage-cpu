// 指令译码器
module my_decoder (
    input [31:0] inst,
    output reg [4:0] rf_raddr1,
    output reg [4:0] rf_raddr2,
    output reg rf_we,
    output reg [4:0] rf_waddr,
    output reg use_imm,
    output reg [31:0] imm,
    output reg [4:0] alu_op,
    output reg mem_en,
    output reg res_from_mem,
    output reg [3:0] mem_we,
    output reg br_taken,
    output reg invalid
);

always @(*) begin
    // 初始化所有控制信号为默认值
    rf_raddr1 = 5'b0;
    rf_raddr2 = 5'b0;
    rf_we = 1'b0;
    rf_waddr = 5'b0;
    use_imm = 1'b0;
    imm=32'b0;
    alu_op = 5'b0;
    mem_en = 1'b0;
    res_from_mem = 1'b0;
    mem_we = 4'b0;
    br_taken = 1'b0;
    invalid = 1'b1; // 先假设指令无效
    // R类型指令（add.w, sub.w, and, mul
    
   if (inst[31:22] == 10'b0) begin 
        case (inst[21:15])
            7'b0100000: begin // add.w
                rf_raddr1 = inst[9:5];
                rf_raddr2 = inst[14:10];
                rf_we = 1'b1;
                rf_waddr = inst[4:0];
                use_imm = 1'b0;
                alu_op = 5'b00000;
                mem_en = 1'b0;
                mem_we = 4'b0;
                br_taken = 1'b0;
                res_from_mem = 1'b0;
                invalid = 1'b0;
            end
            7'b0100010: begin // sub.w
                rf_raddr1 = inst[9:5];
                rf_raddr2 = inst[14:10];
                rf_we = 1'b1;
                rf_waddr = inst[4:0];
                use_imm = 1'b0;
                alu_op = 5'b00010;
                mem_en = 1'b0;
                mem_we = 4'b0;
                br_taken = 1'b0;
                res_from_mem = 1'b0;
                invalid = 1'b0;
            end
            7'b0101001: begin // and
                rf_raddr1 = inst[9:5];
                rf_raddr2 = inst[14:10];
                rf_we = 1'b1;
                rf_waddr = inst[4:0];
                use_imm = 1'b0;
                alu_op = 5'b01011;
                mem_en = 1'b0;
                mem_we = 4'b0;
                br_taken = 1'b0;
                res_from_mem = 1'b0;
                invalid = 1'b0;
            end
            7'b0111000: begin // mul.w
                rf_raddr1 = inst[9:5];
                rf_raddr2 = inst[14:10];
                rf_we = 1'b1;
                rf_waddr = inst[4:0];
                use_imm = 1'b0;
                alu_op = 5'b10010;
                mem_en = 1'b0;
                mem_we = 4'b0;
                br_taken = 1'b0;
                res_from_mem = 1'b0;
                invalid = 1'b0;
            end
        endcase
    end
    else if (inst[31:22] == 10'b0000000001) begin // slli.w
        rf_raddr1 = inst[9:5];
        rf_raddr2 = 5'b0;
        rf_we = 1'b1;
        rf_waddr = {27'b0,inst[4:0]};
        use_imm = 1'b1;
        imm = inst[14:10];
        alu_op = 5'b10000;
        mem_en = 1'b0;
        mem_we = 4'b0;
        br_taken = 1'b0;
        res_from_mem = 1'b0;
        invalid = 1'b0;
    end
    else if (inst[31:22] == 10'b0000001000) begin // slti
        rf_raddr1 = inst[9:5];
        rf_raddr2 = 5'b0;
        rf_we = 1'b1;
        rf_waddr = inst[4:0];
        use_imm = 1'b1;
        imm ={{20{inst[21]}},inst[21:10]};
        alu_op = 5'b10011;
        mem_en = 1'b0;
        mem_we = 4'b0;
        br_taken = 1'b0;
        res_from_mem = 1'b0;
        invalid = 1'b0;
    end
    else if (inst[31:22] == 10'b0000001110) begin // ori
        rf_raddr1 = inst[9:5];
        rf_raddr2 = 5'b0;
        rf_we = 1'b1;
        rf_waddr = inst[4:0];
        use_imm = 1'b1;
        imm = {20'b0,inst[21:10]};
        alu_op = 5'b01010;
        mem_en = 1'b0;
        mem_we = 4'b0;
        br_taken = 1'b0;
        res_from_mem = 1'b0;
        invalid = 1'b0;
    end
    else if (inst[31:22] == 10'b0000001010) begin // addi.w
        rf_raddr1 = inst[9:5];
        rf_raddr2 = 5'b0;
        rf_we = 1'b1;
        rf_waddr = inst[4:0];
        use_imm = 1'b1;
        imm = {{20{inst[21]}},inst[21:10]};
        alu_op = 5'b10001;
        mem_en = 1'b0;
        br_taken = 1'b0;
        res_from_mem = 1'b0;
        invalid = 1'b0;
    end
    else if (inst[31:22] == 10'b0010100010) begin // ld.w
        rf_raddr1 = inst[9:5];
        rf_raddr2 = 5'b0;
        rf_we = 1'b1;
        rf_waddr = inst[4:0];
        use_imm = 1'b1;
        imm = {{20{inst[21]}},inst[21:10]};
        alu_op = 5'b10001;
        mem_en = 1'b1;
        mem_we = 4'b0;
        br_taken = 1'b0;
        res_from_mem = 1'b1;
        invalid = 1'b0;
    end
    else if (inst[31:22] == 10'b0010100110) begin // st.w
        rf_raddr1 = inst[9:5];
        rf_raddr2 = inst[4:0];
        rf_we = 1'b0;
        rf_waddr = 5'b0;
        use_imm = 1'b1;
        imm = {{20{inst[21]}},inst[21:10]};
        alu_op = 5'b10001;
        res_from_mem = 1'b0;
        br_taken = 1'b0;
        mem_en = 1'b1;
        mem_we = 4'b1111;
        invalid = 1'b0;
    end
    else if (inst[31:26] == 6'b010100) begin // b（保留解析但不执行跳转）
        rf_raddr1 = 5'b0;
        rf_raddr2 = 5'b0;
        rf_we = 1'b0;
        rf_waddr = 5'b0;
        use_imm = 1'b0;
        imm ={{6{inst[9]}},inst[9:0],inst[25:10]}<<2;
        alu_op = 5'b10101;
        mem_en = 1'b0;
        mem_we = 4'b0;
        res_from_mem = 1'b0;
        br_taken = 1'b1;
        invalid = 1'b0;
    end
    else if (inst[31:26] == 6'b010110) begin // beq
        rf_raddr1 = inst[9:5];
        rf_raddr2 = inst[4:0];
        rf_we = 1'b0;
        rf_waddr = 5'b0;
        use_imm = 1'b0;
        imm ={{16{inst[25]}},inst[25:10]}<<2;
        alu_op = 5'b10110;
        mem_en = 1'b0;
        mem_we = 4'b0;
        res_from_mem = 1'b0;
        br_taken = 1'b1;
        invalid = 1'b0;
    end
    else begin
        // 默认情况
        rf_we = 1'b0;
        rf_raddr1 = 5'b0;
        rf_raddr2 =5'b0;
        rf_waddr = 5'b0;
        mem_en = 1'b0;
        mem_we = 4'b0;
        use_imm = 1'b0;
        imm=32'b0;
        br_taken = 1'b0;
         alu_op = 5'b00000;
        invalid = 1'b1;
    end
end
endmodule

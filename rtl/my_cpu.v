`timescale 1ns / 1ps

// 取指阶段到译码阶段的寄存器
module if_id_reg(
    input clk,
    input resetn,
    input stall2,
    input flush,
    input [31:0] if_pc,
    input [31:0] if_inst,
    input if_btb_hit,
    
    output reg [31:0] id_pc,
    output reg [31:0] id_inst,
    output reg id_btb_hit
);
    always @(posedge clk) begin
        if (!resetn) begin
            id_pc <= 32'h0;
            id_inst <= 32'h0;
            id_btb_hit<=1'b0;
        end 
       else if(stall2)begin
            id_pc<=id_pc;
            id_inst<=id_inst;
            id_btb_hit<=id_btb_hit;
       end
       else if(flush)begin
            id_pc <= 32'h0;
            id_inst <= 32'h0;
            id_btb_hit<=1'b0;
       end
      else begin
            id_pc<=if_pc;
            id_inst<=if_inst;//用的旧值
            id_btb_hit<=if_btb_hit;
     end
    end
endmodule

// 译码阶段到执行阶段的寄存器
module id_ex_reg(
    input clk,
    input resetn,
    input stall2,
    input flush,
    input id_rf_we,
    input [4:0] id_rf_raddr1,
    input [4:0] id_rf_raddr2,
    input id_use_imm,
    input [4:0] id_alu_op,
    input id_mem_en,
    input id_res_from_mem,
    input [3:0] id_mem_we,
    input id_br_taken,  
    input [31:0] id_pc,
    input [31:0] id_rdata1,
    input [31:0] id_rdata2,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] id_imm,
    input [4:0] id_rf_waddr,
    input [31:0] id_inst,
    
    input id_btb_hit,
    output reg ex_rf_we,
    output reg [4:0] ex_rf_raddr1,
    output reg [4:0] ex_rf_raddr2,
    output reg ex_use_imm,
    output reg [4:0] ex_alu_op,
    output reg ex_mem_en,
    output reg ex_res_from_mem,
    output reg [3:0] ex_mem_we,
    output reg ex_br_taken,  
    output reg [31:0] ex_pc,
    output reg [31:0] ex_rdata1,
    output reg [31:0] ex_rdata2,
    output reg [31:0] ex_imm,
    output reg [4:0] ex_rf_waddr,
    output reg [31:0] ex_inst,
    output reg ex_btb_hit
);
    always @(posedge clk) begin
        if (!resetn) begin
            ex_rf_we <= 1'b0;
            ex_rf_raddr1<=5'b0;
            ex_rf_raddr2<=5'b0;
            ex_use_imm <= 1'b0;
            ex_alu_op <= 5'b0;
            ex_mem_en <= 1'b0;
            ex_res_from_mem <= 1'b0;
            ex_mem_we <= 4'b0;
            ex_br_taken <= 1'b0;
            ex_pc <= 32'h0;
            ex_rdata1 <= 32'h0;
            ex_rdata2 <= 32'h0;
            ex_imm <= 32'h0;
            ex_rf_waddr <= 5'b0;
            ex_inst <= 32'b0;
            ex_btb_hit<=1'b0;
        end 
        else if(stall2)begin
            ex_rf_we <= ex_rf_we;
            ex_rf_raddr1<=ex_rf_raddr1;
            ex_rf_raddr2<=ex_rf_raddr2;
            ex_use_imm <= ex_use_imm;
            ex_alu_op <= ex_alu_op;
            ex_mem_en <= ex_mem_en;
            ex_res_from_mem <= ex_res_from_mem;
            ex_mem_we <= ex_mem_we;
            ex_br_taken <= ex_br_taken;
            ex_pc <= ex_pc;
            ex_rdata1 <=data1;
            ex_rdata2 <=data2;
            ex_imm <= ex_imm;
            ex_rf_waddr <= ex_rf_waddr;
            ex_inst <= ex_inst;
            ex_btb_hit<=ex_btb_hit;
        end
        else if(flush)begin
            ex_rf_we <= 1'b0;
            ex_rf_raddr1<=5'b0;
            ex_rf_raddr2<=5'b0;
            ex_use_imm <= 1'b0;
            ex_alu_op <= 5'b0;
            ex_mem_en <= 1'b0;
            ex_res_from_mem <= 1'b0;
            ex_mem_we <= 4'b0;
            ex_br_taken <= 1'b0;
            ex_pc <= 32'h0;
            ex_rdata1 <= 32'h0;
            ex_rdata2 <= 32'h0;
            ex_imm <= 32'h0;
            ex_rf_waddr <= 5'b0;
            ex_inst <= 32'b0;
            ex_btb_hit<=1'b0;
        end
        else begin
            ex_rf_we <= id_rf_we;
            ex_rf_raddr1<=id_rf_raddr1;
            ex_rf_raddr2<=id_rf_raddr2;
            ex_use_imm <= id_use_imm;
            ex_alu_op <= id_alu_op;
            ex_mem_en <= id_mem_en;
            ex_res_from_mem <= id_res_from_mem;
            ex_mem_we <= id_mem_we;
            ex_br_taken <= id_br_taken;
            ex_pc <= id_pc;
            ex_rdata1 <= id_rdata1;
            ex_rdata2 <= id_rdata2;
            ex_imm <= id_imm;
            ex_rf_waddr <= id_rf_waddr;
            ex_inst <= id_inst;
            ex_btb_hit<=id_btb_hit;
        end
    end
endmodule


// 执行阶段到访存阶段的寄存器
module ex_mem_reg(
    input clk,
    input resetn,
    input stall2,
    input ex_rf_we,
    input ex_mem_en,
    input ex_res_from_mem,
    input [3:0] ex_mem_we,
    input [31:0] ex_pc,
    input [31:0] ex_alu_result,
    input [31:0] ex_mem_wdata,
    input [4:0] ex_rf_waddr,
    input [31:0] ex_inst,
    input ex_jump_en,
    
    output reg mem_rf_we,
    output reg mem_mem_en,
    output reg mem_res_from_mem,
    output reg [3:0] mem_mem_we,
    output reg [31:0] mem_pc,
    output reg [31:0] mem_alu_result,
    output reg [31:0] mem_wdata,
    output reg [4:0] mem_rf_waddr,
    output reg [31:0] mem_inst,
    output reg mem_jump_en
);
    always @(posedge clk) begin
        if (!resetn) begin
            mem_rf_we <= 1'b0;
            mem_mem_en <= 1'b0;
            mem_res_from_mem <= 1'b0;
            mem_mem_we <= 4'b0;
            mem_pc <= 32'h0;
            mem_alu_result <= 32'h0;
            mem_wdata <= 32'h0;
            mem_rf_waddr <= 5'b0;
            mem_inst <= 32'b0;
            mem_jump_en<=1'b0;
        end
        else if(stall2)begin
            mem_rf_we <= 1'b0;
            mem_mem_en <= 1'b0;
            mem_res_from_mem <= 1'b0;
            mem_mem_we <= 4'b0;
            mem_pc <= 32'h0;
            mem_alu_result <= 32'h0;
            mem_wdata <= 32'h0;
            mem_rf_waddr <= 5'b0;
            mem_inst <= 32'b0;
            mem_jump_en<=1'b0;
         end
         else begin
            mem_rf_we <= ex_rf_we;
            mem_mem_en <= ex_mem_en;
            mem_res_from_mem <= ex_res_from_mem;
            mem_mem_we <= ex_mem_we;
            mem_pc <= ex_pc;
            mem_alu_result <= ex_alu_result;
            mem_wdata <= ex_mem_wdata;
            mem_rf_waddr <= ex_rf_waddr;
            mem_inst <= ex_inst;
            mem_jump_en<=ex_jump_en;
        end
    end
endmodule

// 访存阶段到写回阶段的寄存器（保持不变）
module mem_wb_reg(
    input clk,
    input resetn,
    input mem_rf_we,
    input mem_res_from_mem,
    input [31:0] mem_pc,
    input [31:0] mem_alu_result,
    input [4:0] mem_rf_waddr,
    input [31:0] mem_inst,
    output reg wb_rf_we,
    output reg wb_res_from_mem,
    output reg [31:0] wb_pc,
    output reg [31:0] wb_alu_result,
    output reg [4:0] wb_rf_waddr,
    output reg [31:0] wb_inst
);
    always @(posedge clk) begin
        if (!resetn) begin
            wb_rf_we <= 1'b0;
            wb_res_from_mem <= 1'b0;
            wb_pc <= 32'h0;
            wb_alu_result <= 32'h0;
            wb_rf_waddr <= 5'b0;
            wb_inst <= 32'b0;
        end 
        else begin
            wb_rf_we <= (mem_rf_waddr != 5'b0) ? mem_rf_we : 1'b0;
            wb_res_from_mem <= mem_res_from_mem;
            wb_pc <= mem_pc;
            wb_alu_result <= mem_alu_result;
            wb_rf_waddr <= mem_rf_waddr;
            wb_inst <= mem_inst;
        end
    end
endmodule

// PC模块
module get_op(
    input clk,
    input resetn,
    input stall1,
    input jump_en,
    input btb_hit,
    input [31:0] target_pc,
    input [31:0] offset,
    input [31:0] j_pc,
    
    output reg [31:0] pc,//送btb和inst_sram
    output reg [31:0] if_pc,
    output reg if_btb_hit
);
    always @(posedge clk) begin
        if (!resetn) begin
            pc <= 32'h0;
            if_pc <= 32'h0;
            if_btb_hit<=1'b0;
         end
       else if(stall1)begin
            pc <= pc; 
            if_pc<=if_pc;
            if_btb_hit<=if_btb_hit;
       end
       else if(jump_en)begin
            pc<=j_pc+offset;
            if_pc<=pc;
            if_btb_hit<=1'b0;
       end
       else if(btb_hit)begin
                pc<=target_pc;
                if_pc<=pc;
                if_btb_hit<=btb_hit;
       end
       else begin
            pc <= pc + 32'd4; 
            if_pc<=pc;
            if_btb_hit<=1'b0;
        end
    end
endmodule

// 5段流水CPU
module cpu(
    input           clk,               
    input           resetn,         
    output          inst_sram_en,       
    output [31:0]    inst_sram_addr,    
    input  [31:0]     inst_sram_rdata,
      
    output          data_sram_en,      
    output[3:0]     data_sram_wen,        
    output[31:0]    data_sram_addr,    
    output[31:0]    data_sram_wdata,    
    input[31:0]     data_sram_rdata,
     
    output[31:0]    debug_wb_pc,        
    output          debug_wb_rf_wen,    
    output[4:0]     debug_wb_rf_wnum,   
    output[31:0]    debug_wb_rf_wdata   
);
    
    // IF阶段信号
    wire [31:0] if_pc;
    
    // ID阶段信号
    wire [31:0] id_pc;
    wire [31:0] id_inst;
    wire [4:0] id_rf_raddr1;
    wire [4:0] id_rf_raddr2;
    wire id_rf_we;
    wire [4:0] id_rf_waddr;
    wire id_use_imm;
    wire [31:0] id_imm;
    wire [4:0] id_alu_op;
    wire id_mem_en;
    wire id_res_from_mem;
    wire [3:0] id_mem_we;
    wire id_br_taken;
    wire [31:0] id_rdata1;
    wire [31:0] id_rdata2;
    
    // EX阶段信号
    wire [31:0] ex_pc;
    wire ex_rf_we;
    wire [4:0] ex_rf_waddr;
    wire ex_use_imm;
    wire [31:0] ex_imm;
    wire [4:0] ex_alu_op;
    wire ex_mem_en;
    wire ex_res_from_mem;
    wire [3:0] ex_mem_we;
    wire ex_br_taken;
    wire [31:0] ex_rdata1;
    wire [31:0] ex_rdata2;
    wire [31:0] ex_alu_result;
    wire [31:0] ex_inst;
    
    // MEM阶段信号
    wire [31:0] mem_pc;
    wire mem_rf_we;
    wire [4:0] mem_rf_waddr;
    wire mem_mem_en;
    wire mem_res_from_mem;
    wire [3:0] mem_mem_we;
    wire [31:0] mem_alu_result;
    wire [31:0] mem_wdata;
    wire [31:0] mem_inst;
    
    // WB阶段信号
    wire [31:0] wb_pc;
    wire wb_rf_we;
    wire [4:0] wb_rf_waddr;
    wire wb_res_from_mem;
    wire [31:0] wb_alu_result;
    wire [31:0] wb_data_rdata;
    wire [31:0] wb_wdata;
    wire [31:0] wb_inst;
    
    wire forward_a;
    wire [4:0] ex_rf_raddr1;
    wire [4:0] ex_rf_raddr2;
    wire stall1,stall2;
    
    wire [31:0] id_ture_rdata1;
    wire [31:0] id_ture_rdata2;
    
    wire [31:0] data1,data2;
    
    wire true_jump_en,jump_en;//第一个为指令执行结果，第二个为预测后是否更改pc
    wire btb_hit,if_btb_hit,id_btb_hit,ex_btb_hit;
    wire flush;
    wire mem_jump_en;
    wire jump_valid,btb_we;
    wire [31:0] btb_target_pc,target_pc_write;
    wire [31:0] offset;
    // 1. 取指阶段（无分支，仅顺序取指）
    assign inst_sram_en = resetn;  // 复位时禁用
    
    
    get_op u_get_op(
        .clk        (clk),
        .resetn     (resetn),
        .stall1(stall1),
        .jump_en(jump_en),
        .btb_hit(btb_hit),
        .target_pc(btb_target_pc),
        .offset(offset),
        .j_pc(ex_pc),
        
        .pc(inst_sram_addr),
        .if_pc      (if_pc),
        .if_btb_hit(if_btb_hit)
    );
    
    my_btb u_my_btb(
         .clk(clk),                  
         .resetn(resetn),               
         .check_pc(inst_sram_addr),   
         .jump_valid(jump_valid),//pc执行时是否跳转
         
         .btb_hit(btb_hit),              // 命中信号（1:命中，0:未命中）
         .btb_target_pc(btb_target_pc),
         
         
         .btb_we(btb_we),               // 写使能（1:更新BTB）
         .pc_write(ex_pc),      // 待写入的分支指令PC
         .target_pc_write(target_pc_write)
 );
 
 
    // IF到ID的寄存器
    if_id_reg u_if_id_reg(
        .clk        (clk),
        .resetn     (resetn),
        .stall2(stall2),
        .flush(flush),
        .if_pc      (if_pc),
        .if_inst    (inst_sram_rdata),
        .if_btb_hit(if_btb_hit),
        
        .id_pc      (id_pc),
        .id_inst    (id_inst),
        .id_btb_hit(id_btb_hit)
    );
    
    // 2. 译码阶段（保留原有逻辑）
    my_decoder u_decoder(
        .inst        (id_inst),
        .rf_raddr1   (id_rf_raddr1),
        .rf_raddr2   (id_rf_raddr2),
        .rf_we       (id_rf_we),
        .rf_waddr    (id_rf_waddr),
        .use_imm     (id_use_imm),
        .imm         (id_imm),
        .alu_op      (id_alu_op),
        .mem_en      (id_mem_en),
        .res_from_mem(id_res_from_mem),
        .mem_we      (id_mem_we),
        .br_taken    (id_br_taken),
        .invalid     ()
    );
    
    mips_register u_regfile(
        .clk        (clk),
        .we         (wb_rf_we),
        .raddr1     (id_rf_raddr1),
        .raddr2     (id_rf_raddr2),
        .waddr      (wb_rf_waddr),
        .wdata      (wb_wdata),
        .rdata1     (id_rdata1),
        .rdata2     (id_rdata2)
    );
    
    // ID到EX的寄存器
    id_ex_reg u_id_ex_reg(
        .clk            (clk),
        .resetn         (resetn),
        .stall2(stall2),
        .flush(flush), 
        .id_rf_raddr1 (id_rf_raddr1),
        .id_rf_raddr2 (id_rf_raddr2),
        .id_rf_we       (id_rf_we),
        .id_use_imm     (id_use_imm),
        .id_alu_op      (id_alu_op),
        .id_mem_en      (id_mem_en),
        .id_res_from_mem(id_res_from_mem),
        .id_mem_we      (id_mem_we),
        .id_br_taken    (id_br_taken),
        .id_pc          (id_pc),
        .id_rdata1      (id_ture_rdata1),
        .id_rdata2      (id_ture_rdata2),
        .data1(data1),
        .data2(data2),
        .id_imm         (id_imm),
        .id_rf_waddr    (id_rf_waddr),
        .id_inst        (id_inst),
        .id_btb_hit(id_btb_hit),
        
        .ex_rf_raddr1 (ex_rf_raddr1),
        .ex_rf_raddr2 (ex_rf_raddr2),
        .ex_rf_we       (ex_rf_we),
        .ex_use_imm     (ex_use_imm),
        .ex_alu_op      (ex_alu_op),
        .ex_mem_en      (ex_mem_en),
        .ex_res_from_mem(ex_res_from_mem),
        .ex_mem_we      (ex_mem_we),
        .ex_br_taken    (ex_br_taken),
        .ex_pc          (ex_pc),
        .ex_rdata1      (ex_rdata1),
        .ex_rdata2      (ex_rdata2),
        .ex_imm         (ex_imm),
        .ex_rf_waddr    (ex_rf_waddr),
        .ex_inst        (ex_inst),
        .ex_btb_hit(ex_btb_hit)
    );
       assign true_jump_en=ex_br_taken&&ex_alu_result;
       assign jump_en=(true_jump_en^ex_btb_hit)&&!stall2;//保证load指令在前，发生数据冲突时，第二个ex周期生效，第一个无效
       assign flush=jump_en||mem_jump_en;
       assign btb_we=(ex_br_taken)&&!stall2;
      
       assign jump_valid=true_jump_en;//写入指令执行的结果
       assign target_pc_write=ex_pc+ex_imm;
       assign offset=(true_jump_en)?ex_imm:32'h4;//当预测出错时，恢复顺序执行
       
       
       
       
    // 3. 执行阶段（完善转发逻辑）
    // MEM阶段转发数据（load指令取内存数据，否则取ALU结果）
    wire [31:0] mem_forward_data = mem_res_from_mem ? data_sram_rdata : mem_alu_result;
    
    // 转发判断：优先MEM阶段（更近,更新），再WB阶段
    wire forward_a_mem = mem_rf_we && (mem_rf_waddr == ex_rf_raddr1) && (ex_rf_raddr1 != 5'd0);
    wire forward_a_wb  = wb_rf_we  && (wb_rf_waddr  == ex_rf_raddr1) && (ex_rf_raddr1 != 5'd0) && !forward_a_mem;
    
    wire forward_b_mem = mem_rf_we && (mem_rf_waddr == ex_rf_raddr2) && (ex_rf_raddr2 != 5'd0);
    wire forward_b_wb  = wb_rf_we  && (wb_rf_waddr  == ex_rf_raddr2) && (ex_rf_raddr2 != 5'd0) && !forward_b_mem;
    
   
    // ALU操作数选择
    wire [31:0] alu_a =(forward_a_mem )? mem_forward_data :( forward_a_wb  ? wb_wdata : ex_rdata1);
                        
    wire [31:0] alu_b = ex_use_imm ? ex_imm :(forward_b_mem ? mem_forward_data :  (forward_b_wb  ? wb_wdata :
                       ex_rdata2));
    
                        
    wire [31:0] ex_mem_wdata=(forward_b_mem ? mem_forward_data :  (forward_b_wb  ? wb_wdata :ex_rdata2));
    
    assign data1=alu_a;
    assign data2=(ex_use_imm)?ex_rdata2:alu_b;
    
    // load-use冲突检测：EX阶段需要的操作数来自MEM阶段的load指令
    assign stall1= !stall2&&ex_res_from_mem && ex_rf_we && ((ex_rf_waddr == id_rf_raddr1 && id_rf_raddr1 != 5'd0) || 
                   (ex_rf_waddr == id_rf_raddr2 && id_rf_raddr2 != 5'd0))&&(id_rf_waddr!=5'b0||id_br_taken||id_mem_en);//写0号寄存器无效，无需暂停
    assign stall2= mem_res_from_mem && mem_rf_we && ((mem_rf_waddr == ex_rf_raddr1 && ex_rf_raddr1 != 5'd0) || 
                   (mem_rf_waddr == ex_rf_raddr2 && ex_rf_raddr2 != 5'd0))&&(ex_rf_waddr!=5'b0||ex_br_taken||ex_mem_en);
    
    
    // ID阶段转发（解决EX/MEM/WB到ID的数据冲突）
    // 优先级：MEM阶段 > WB阶段（距离当前阶段越近优先级越高）
    assign id_ture_rdata1 = (mem_rf_we && mem_rf_waddr == id_rf_raddr1 && id_rf_raddr1 != 5'd0) ? mem_forward_data :
                           (wb_rf_we  && wb_rf_waddr  == id_rf_raddr1 && id_rf_raddr1 != 5'd0) ? wb_wdata :
                           id_rdata1;
                           
    assign id_ture_rdata2 = (mem_rf_we && mem_rf_waddr == id_rf_raddr2 && id_rf_raddr2 != 5'd0) ? mem_forward_data :
                           (wb_rf_we  && wb_rf_waddr  == id_rf_raddr2 && id_rf_raddr2 != 5'd0) ? wb_wdata :
                           id_rdata2;
    
    
    my_alu u_alu(
        .A      (alu_a),
        .B      (alu_b),
        .Cin    (1'b0),
        .Card   (ex_alu_op),
        .F      (ex_alu_result),
        .Cout   (),
        .Zero   ()
    );
    
    // 4. 访存阶段（保持不变）
    ex_mem_reg u_ex_mem_reg(
        .clk            (clk),
        .resetn         (resetn),
        .stall2(stall2),
        
        .ex_rf_we       (ex_rf_we),
        .ex_mem_en      (ex_mem_en),
        .ex_res_from_mem(ex_res_from_mem),
        .ex_mem_we      (ex_mem_we),
        .ex_pc          (ex_pc),
        .ex_alu_result  (ex_alu_result),
        .ex_mem_wdata   (ex_mem_wdata),     // 有转发，针对store指令
        .ex_rf_waddr    (ex_rf_waddr),
        .ex_inst        (ex_inst),
        .ex_jump_en(jump_en),
        
        .mem_rf_we      (mem_rf_we),
        .mem_mem_en     (mem_mem_en),
        .mem_res_from_mem(mem_res_from_mem),
        .mem_mem_we     (mem_mem_we),
        .mem_pc         (mem_pc),
        .mem_alu_result (mem_alu_result),
        .mem_wdata      (mem_wdata),
        .mem_rf_waddr   (mem_rf_waddr),
        .mem_inst       (mem_inst),
        .mem_jump_en(mem_jump_en)
    );
    
    assign data_sram_en = mem_mem_en;
    assign data_sram_wen = mem_mem_we;
    assign data_sram_addr = mem_alu_result;
    assign data_sram_wdata = mem_wdata;
    
   
    
    // 5. 写回阶段（保持不变）
    mem_wb_reg u_mem_wb_reg(
        .clk            (clk),
        .resetn         (resetn),
        .mem_rf_we      (mem_rf_we),
        .mem_res_from_mem(mem_res_from_mem),
        .mem_pc         (mem_pc),
        .mem_alu_result (mem_alu_result),
        .mem_rf_waddr   (mem_rf_waddr),
        .mem_inst       (mem_inst),
        .wb_rf_we       (wb_rf_we),
        .wb_res_from_mem(wb_res_from_mem),
        .wb_pc          (wb_pc),
        .wb_alu_result  (wb_alu_result),
        .wb_rf_waddr    (wb_rf_waddr),
        .wb_inst        (wb_inst)
    );
    
    assign wb_wdata = (wb_res_from_mem )? data_sram_rdata : wb_alu_result;
    
    // 调试信号
    assign debug_wb_pc = wb_pc;
    assign debug_wb_rf_wen = wb_rf_we;
    assign debug_wb_rf_wnum = wb_rf_waddr;
    assign debug_wb_rf_wdata = wb_wdata;
    
endmodule
 

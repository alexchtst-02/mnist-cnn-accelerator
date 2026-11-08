`timescale 1ns / 1ps

module tb_pool_engine_2;

    reg clk, rstn;
    
    reg clear_reset;
    wire enable_next_read_gff = ready_to_upstream_buff_2_ipt_k2;
    reg valid_in_gff;
    reg [23:0] din_gff0, din_gff1, din_gff2, din_gff3, din_gff4, din_gff5, din_gff6, din_gff7;
    wire [191:0] din_gff = {din_gff7, din_gff6, din_gff5, din_gff4, din_gff3, din_gff2, din_gff1, din_gff0};
    wire [9:0] wr_cnt_gff, rd_cnt_gff;
    wire valid_out_gff;
    wire [191:0] dout_gff;
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(1024),
        .MAX_OCCUPANCY(676),
        .ADDRESS_WIDTH(10)
    ) uut_gff (
        .clk(clk), .rstn(rstn),
        
        .clear(clear_reset),
        
        .enable_next_read(enable_next_read_gff),
        
        .valid_in(valid_in_gff),
        .din(din_gff),
        
        .wr_cnt(wr_cnt_gff),
        .rd_cnt(rd_cnt_gff),
        .valid_out(valid_out_gff),
        .dout(dout_gff)
    );
    
    
    wire ready_to_upstream_buff_2_ipt_k2;
    wire valid_out_buff_2_ipt_k2;
    wire [24*8*4-1:0] dout_buff_2_ipt_k2;
    buffer_2_input_k2 #(
        .DATA_WIDTH(24),
        .TMUX(2),
        .LINE_WIDTH(11)
    ) uut_buff_2ipt_k2 (
        .clk(clk), .rstn(rstn), .clear_reset(clear_reset),
        
        .enable(1'b1),
        
        .valid_in(valid_out_gff),
        .din(dout_gff),
        
        .ready_to_upstream(ready_to_upstream_buff_2_ipt_k2),
        
        .valid_out(valid_out_buff_2_ipt_k2),
        .dout(dout_buff_2_ipt_k2)
    );
    
    wire [191:0] dout_pool_engine_1;
    wire valid_out_pool_engine_1;
    wire [23:0] dout_pool_engine_1_0 = dout_pool_engine_1[24*0 +: 24];
    wire [23:0] dout_pool_engine_1_1 = dout_pool_engine_1[24*1 +: 24];
    wire [23:0] dout_pool_engine_1_2 = dout_pool_engine_1[24*2 +: 24];
    wire [23:0] dout_pool_engine_1_3 = dout_pool_engine_1[24*3 +: 24];
    wire [23:0] dout_pool_engine_1_4 = dout_pool_engine_1[24*4 +: 24];
    wire [23:0] dout_pool_engine_1_5 = dout_pool_engine_1[24*5 +: 24];
    wire [23:0] dout_pool_engine_1_6 = dout_pool_engine_1[24*6 +: 24];
    wire [23:0] dout_pool_engine_1_7 = dout_pool_engine_1[24*7 +: 24];
    pool_engine #( .DATA_WIDTH(24) ) uut_pool_engine_1 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_buff_2_ipt_k2),
        .din(dout_buff_2_ipt_k2),
        
        .valid_out(valid_out_pool_engine_1),
        .dout(dout_pool_engine_1)
    );
    
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    integer i;
    
    initial begin
        rstn = 0; 
        clear_reset = 0; 
        valid_in_gff = 0; 
        #10
        
        rstn = 1; #10
        
        for (i = 0; i < 700; i = i + 1) begin

            @(negedge clk);
    
            valid_in_gff = 1'b1;
    
            din_gff0 = (i + 1) * 10;
            din_gff1 = (i + 1) * 20;
            din_gff2 = (i + 1) * 30;
            din_gff3 = (i + 1) * 40;
            din_gff4 = (i + 1) * 50;
            din_gff5 = (i + 1) * 60;
            din_gff6 = (i + 1) * 70;
            din_gff7 = (i + 1) * 80;
    
        end
        
        $finish;
    end

endmodule

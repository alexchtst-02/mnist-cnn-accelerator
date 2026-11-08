`timescale 1ns / 1ps

module tb_buffer_1_input_k2;

    reg clk, rstn;
    
    reg clear_reset;
    wire enable_next_read_gff = ready_to_upstream_buff_1ipt_k2;
    reg valid_in_gff;
    reg [191:0] din_gff;
    
    wire [9:0] wr_cnt_gff, rd_cnt_gff;
    wire valid_out_gff;
    wire [191:0] dout_gff;
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(256),
        .MAX_OCCUPANCY(242),
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
    
    wire ready_to_upstream_buff_1ipt_k2;
    wire valid_out;
    wire [24*8*4-1:0] dout;
    wire [24*8-1:0] dout_0 = dout[24*8*0 +: 24*8];
    wire [24*8-1:0] dout_1 = dout[24*8*1 +: 24*8];
    wire [24*8-1:0] dout_2 = dout[24*8*2 +: 24*8];
    wire [24*8-1:0] dout_3 = dout[24*8*3 +: 24*8];
    buffer_1_input_k2 #(
        .DATA_WIDTH(24),
        .TMUX(1),
        .LINE_WIDTH(26)
    ) uut_buff_1ipt_k2 (
        .clk(clk), .rstn(rstn), .clear_reset(clear_reset),
        
        .enable(1'b1),
        
        .valid_in(valid_out_gff),
        .din(dout_gff),
        
        .ready_to_upstream(ready_to_upstream_buff_1ipt_k2),
        
        .valid_out(valid_out),
        .dout(dout)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    integer i, k;
    
    initial begin
        rstn = 0; 
        clear_reset = 0; 
        valid_in_gff = 0; 
        din_gff = 0;
        #10
        
        rstn = 1; #10
        
        for (i = 0; i < 300; i = i + 1) begin
            for (k = 0; k < 1; k = k + 1) begin
                @(negedge clk);
                valid_in_gff = 1;
                din_gff = (k + 1) * (i + 1) * 10;
            end
        end
        
        $finish;
    end

endmodule

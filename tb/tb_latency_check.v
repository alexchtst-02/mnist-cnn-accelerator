`timescale 1ns / 1ps

module tb_latency_check;

    reg clk, rstn;
    
    reg [191:0] din;
    reg valid_in;
    
    wire enable_next_read_gff;
    wire [9:0] wr_cnt_gff;
    wire [9:0] rd_cnt_gff;
    wire valid_out_gff;
    wire [191:0] dout_gff;
    
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(1024),
        .MAX_OCCUPANCY(28*28),
        .ADDRESS_WIDTH(10)
    ) uut_gff (
        .clk(clk), .rstn(rstn),
        
        .clear(1'b0),
        
        .enable_next_read(enable_next_read_gff),
        
        .valid_in(valid_in),
        .din(din),
        
        .wr_cnt(wr_cnt_gff),
        .rd_cnt(rd_cnt_gff),
        
        .valid_out(valid_out_gff),
        .dout(dout_gff)
    );
    
    wire valid_in_conv1 = valid_out_gff;
    wire [191:0] din_conv1 = dout_gff;
    wire raw_valid_out_conv1;
    wire [367:0] raw_dout_conv1;
    wire valid_out_conv1;
    wire [191:0] dout_conv1;
    
    // unused
    wire ready_to_upstream_conv1;
    
    conv1_layer uut_conv1 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_conv1),
        .din(din_conv1),
        
        .ready_to_upstream(ready_to_upstream_conv1),
        
        .raw_valid_out(raw_valid_out_conv1),
        .raw_dout(raw_dout_conv1),
        
        .valid_out(valid_out_conv1),
        .dout(dout_conv1)
    );
    
    wire valid_in_pool1 = valid_out_conv1;
    wire [191:0] din_pool1 = dout_conv1;
    wire valid_out_pool1;
    wire [191:0] dout_pool1;
    
    pool1_layer uut_pool1 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_pool1),
        .din(din_pool1),
        
        .ready_to_upstream(enable_next_read_gff),
        
        .valid_out(valid_out_pool1),
        .dout(dout_pool1)
    );
    
    wire enable_next_read_gff_1;
    wire [9:0] wr_cnt_gff_1;
    wire [9:0] rd_cnt_gff_1;
    wire valid_out_1;
    wire [191:0] dout_gff_1;
    
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(256),
        .MAX_OCCUPANCY(169),
        .ADDRESS_WIDTH(10)
    ) uut_gff_1 (
        .clk(clk), .rstn(rstn),
        
        .clear(1'b0),
        
        .enable_next_read(enable_next_read_gff_1),
        
        .valid_in(valid_out_pool1),
        .din(dout_pool1),
        
        .wr_cnt(wr_cnt_gff_1),
        .rd_cnt(rd_cnt_gff_1),
        
        .valid_out(valid_out_1),
        .dout(dout_gff_1)
    );
    
    wire valid_in_conv2 = valid_out_1;
    wire [191:0] din_conv2 = dout_gff_1;
    wire raw_valid_out_conv2;
    wire [391:0] raw_dout_conv2;
    wire valid_out_conv2;
    wire [191:0] dout_conv2;
    
    conv2_layer uut_conv2 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_conv2),
        .din(din_conv2),
        
        .ready_to_upstream(enable_next_read_gff_1),
        
        .raw_valid_out(raw_valid_out_conv2),
        .raw_dout(raw_dout_conv2),
        
        .valid_out(valid_out_conv2),
        .dout(dout_conv2)
    );
    
    wire enable_next_read_gff_2;
    
    wire [9:0] wr_cnt_gff_2;
    wire [9:0] rd_cnt_gff_2;
    wire valid_out_2;
    wire [191:0] dout_gff_2;
    
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(256),
        .MAX_OCCUPANCY(242),
        .ADDRESS_WIDTH(10)
    ) uut_gff_2 (
        .clk(clk), .rstn(rstn),
        
        .clear(1'b0),
        
        .enable_next_read(enable_next_read_gff_2),
        
        .valid_in(valid_out_conv2),
        .din(dout_conv2),
        
        .wr_cnt(wr_cnt_gff_2),
        .rd_cnt(rd_cnt_gff_2),
        
        .valid_out(valid_out_2),
        .dout(dout_gff_2)
    );
    
    wire valid_in_pool2 = valid_out_2;
    wire [191:0] din_pool2 = dout_gff_2;
    wire valid_out_pool2;
    wire [191:0] dout_pool2;
    
    pool2_layer uut_pool2 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_pool2),
        .din(din_pool2),
        
        .ready_to_upstream(enable_next_read_gff_2),
        
        .valid_out(valid_out_pool2),
        .dout(dout_pool2)
    );
    
    wire enable_next_read_gff_3;
    
    wire [9:0] wr_cnt_gff_3;
    wire [9:0] rd_cnt_gff_3;
    wire valid_out_3;
    wire [191:0] dout_gff_3;
    
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(256),
        .MAX_OCCUPANCY(50),
        .ADDRESS_WIDTH(10)
    ) uut_gff_3 (
        .clk(clk), .rstn(rstn),
        
        .clear(1'b0),
        
        .enable_next_read(enable_next_read_gff_3),
        
        .valid_in(valid_out_pool2),
        .din(dout_pool2),
        
        .wr_cnt(wr_cnt_gff_3),
        .rd_cnt(rd_cnt_gff_3),
        
        .valid_out(valid_out_3),
        .dout(dout_gff_3)
    );
    
    wire valid_in_conv3 = valid_out_3;
    wire [191:0] din_conv3 = dout_gff_3;
    wire raw_valid_out_conv3;
    wire [399:0] raw_dout_conv3;
    wire valid_out_conv3;
    wire [191:0] dout_conv3;
    
    conv3_layer uut_conv3 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_conv3),
        .din(din_conv3),
        
        .ready_to_upstream(enable_next_read_gff_3),
        
        .raw_valid_out(raw_valid_out_conv3),
        .raw_dout(raw_dout_conv3),
        
        .valid_out(valid_out_conv3),
        .dout(dout_conv3)
    );
    
    wire enable_next_read_gff_4;
    
    wire [9:0] wr_cnt_gff_4;
    wire [9:0] rd_cnt_gff_4;
    wire valid_out_4;
    wire [191:0] dout_gff_4;
    
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(256),
        .MAX_OCCUPANCY(36),
        .ADDRESS_WIDTH(10)
    ) uut_gff_4 (
        .clk(clk), .rstn(rstn),
        
        .clear(1'b0),
        
        .enable_next_read(enable_next_read_gff_4),
        
        .valid_in(valid_out_conv3),
        .din(dout_conv3),
        
        .wr_cnt(wr_cnt_gff_4),
        .rd_cnt(rd_cnt_gff_4),
        
        .valid_out(valid_out_4),
        .dout(dout_gff_4)
    );
    
    wire valid_in_pool3 = valid_out_4;
    wire [191:0] din_pool3 = dout_gff_4;
    wire valid_out_pool3;
    wire [191:0] dout_pool3;
    
    pool3_layer uut_pool3 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_pool3),
        .din(din_pool3),
        
        .ready_to_upstream(enable_next_read_gff_4),
        
        .valid_out(valid_out_pool3),
        .dout(dout_pool3)
    );
    
    wire enable_next_read_gff_5;
    
    wire [9:0] wr_cnt_gff_5;
    wire [9:0] rd_cnt_gff_5;
    wire valid_out_5;
    wire [191:0] dout_gff_5;
    
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(256),
        .MAX_OCCUPANCY(36),
        .ADDRESS_WIDTH(10)
    ) uut_gff_5 (
        .clk(clk), .rstn(rstn),
        
        .clear(1'b0),
        
        .enable_next_read(enable_next_read_gff_5),
        
        .valid_in(valid_out_pool3),
        .din(dout_pool3),
        
        .wr_cnt(wr_cnt_gff_5),
        .rd_cnt(rd_cnt_gff_5),
        
        .valid_out(valid_out_5),
        .dout(dout_gff_5)
    );
    
    wire valid_in_fc1 = valid_out_5;
    wire [191:0] din_fc1 = dout_gff_5;
    wire raw_valid_out_fc1;
    wire [367:0] raw_dout_fc1;
    wire valid_out_fc1;
    wire [191:0] dout_fc1;
    
    fully_connected_1_layer uut_fc1 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_fc1),
        .din(din_fc1),
        
        .ready_to_upstream(enable_next_read_gff_5),
        
        .raw_valid_out(raw_valid_out_fc1),
        .raw_dout(raw_dout_fc1),
        
        .valid_out(valid_out_fc1),
        .dout(dout_fc1)
    );
    
    wire valid_in_fc2 = valid_out_fc1;
    wire [191:0] din_fc2 = dout_fc1;
    wire raw_valid_out_fc2;
    wire [449:0] raw_dout_fc2;
    wire valid_out_fc2;
    wire [239:0] dout_fc2;
    
    // unused
    wire ready_to_upstream_fc2;
    
    fully_connected_2_layer uut_fc2 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_fc2),
        .din(din_fc2),
        
        .ready_to_upstream(ready_to_upstream_fc2),
        
        .raw_valid_out(raw_valid_out_fc2),
        .raw_dout(raw_dout_fc2),
        
        .valid_out(valid_out_fc2),
        .dout(dout_fc2)
    );
    

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    integer i;

    initial begin
        rstn = 0; 
        valid_in = 0;
        din = 0;
        #10
        
        rstn = 1; #10
        
        for (i = 0; i < 30*30; i = i + 1) begin
            @(negedge clk);
            valid_in = 1;
            din = (i + 1) * 10;
        end
        
        $finish;
    end

endmodule

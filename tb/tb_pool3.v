`timescale 1ns / 1ps

module tb_pool3;

    reg clk, rstn;
    
    reg [7:0] img_mem [0:783];
    reg [9:0] read_cnt;
    reg valid_data;
    reg [7:0] data;
    
    initial begin
        $readmemh("img_buff.mem", img_mem);
    end
    
    always @(posedge clk) begin
        if (!rstn) begin
            read_cnt <= 10'b0;
            valid_data <= 1'b0;
            data <= 192'b0;
        end
        else begin
            if (read_cnt < 784) begin
                read_cnt <= read_cnt + 1'b1;
                valid_data <= 1'b1;
                data <= img_mem[read_cnt];
            end
            else begin
                valid_data <= 1'b0;
            end
        end
    end
    
    wire [9:0] wr_cnt_gff;
    wire [9:0] rd_cnt_gff;
    
    wire [9:0] wr_cnt_gff_pool1;
    wire [9:0] rd_cnt_gff_pool1;
    
    wire [9:0] wr_cnt_gff_conv2;
    wire [9:0] rd_cnt_gff_conv2;
    
    wire [9:0] wr_cnt_gff_pool2;
    wire [9:0] rd_cnt_gff_pool2;
    
    wire [9:0] wr_cnt_gff_conv3;
    wire [9:0] rd_cnt_gff_conv3;
    
    wire enable_next_read_gff;
    wire valid_out_gff;
    wire [7:0] dout_gff;

    group_feature_fifo #(
        .WORD_WIDTH(8),
        .DEPTH(1024),
        .MAX_OCCUPANCY(784),
        .ADDRESS_WIDTH(10)
    ) uut_gff (
        .clk(clk), .rstn(rstn),

        .clear(1'b0),

        .enable_next_read(enable_next_read_gff),

        .valid_in(valid_data),
        .din(data),

        .wr_cnt(wr_cnt_gff),
        .rd_cnt(rd_cnt_gff),

        .valid_out(valid_out_gff),
        .dout(dout_gff)
    );

    wire valid_out_egp;
    wire [191:0] dout_egp;

    extend_grayscale_pixel uut_egp (
        .clk(clk), .rstn(rstn),

        .valid_in(valid_out_gff),
        .din(dout_gff),

        .valid_out(valid_out_egp),
        .dout(dout_egp)
    );
    
    
    wire valid_in_conv1 = valid_out_egp;
    wire [191:0] din_conv1 = dout_egp;
    wire raw_valid_out_conv1;
    wire [367:0] raw_dout_conv1;
    wire valid_out_conv1;
    wire [191:0] dout_conv1;
    conv1_layer uut_conv1 (
        .clk(clk), .rstn(rstn),

        .clear_reset(1'b0),

        .enable_input(1'b1),

        .valid_in(valid_in_conv1),
        .din(din_conv1),

        .ready_to_upstream(enable_next_read_gff),

        .raw_valid_out(raw_valid_out_conv1),
        .raw_dout(raw_dout_conv1),

        .valid_out(valid_out_conv1),
        .dout(dout_conv1)
    );
    
    wire ready_to_upstream_pool1;

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

        .ready_to_upstream(ready_to_upstream_pool1),

        .valid_out(valid_out_pool1),
        .dout(dout_pool1)
    );
    
    wire enable_next_read_gff_pool1;
    wire valid_out_gff_pool1;
    wire [191:0] dout_gff_pool1;
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(256),
        .MAX_OCCUPANCY(169),
        .ADDRESS_WIDTH(10)
    ) uut_gff_pool1 (
        .clk(clk), .rstn(rstn),

        .clear(1'b0),

        .enable_next_read(enable_next_read_gff_pool1),

        .valid_in(valid_out_pool1),
        .din(dout_pool1),

        .wr_cnt(wr_cnt_gff_pool1),
        .rd_cnt(rd_cnt_gff_pool1),

        .valid_out(valid_out_gff_pool1),
        .dout(dout_gff_pool1)
    );
    
    wire valid_in_conv2 = valid_out_gff_pool1;
    wire [191:0] din_conv2 = dout_gff_pool1;
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
        
        .ready_to_upstream(enable_next_read_gff_pool1),
        
        .raw_valid_out(raw_valid_out_conv2),
        .raw_dout(raw_dout_conv2),
        
        .valid_out(valid_out_conv2),
        .dout(dout_conv2)
    );
    
    wire enable_next_read_gff_conv2;
    wire valid_out_gff_conv2;
    wire [191:0] dout_gff_conv2;
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(256),
        .MAX_OCCUPANCY(242),
        .ADDRESS_WIDTH(10)
    ) uut_gff_conv2 (
        .clk(clk), .rstn(rstn),

        .clear(1'b0),

        .enable_next_read(enable_next_read_gff_conv2),

        .valid_in(valid_out_conv2),
        .din(dout_conv2),

        .wr_cnt(wr_cnt_gff_conv2),
        .rd_cnt(rd_cnt_gff_conv2),

        .valid_out(valid_out_gff_conv2),
        .dout(dout_gff_conv2)
    );
    
    wire valid_in_pool2 = valid_out_gff_conv2;
    wire [191:0] din_pool2 = dout_gff_conv2;
    wire valid_out_pool2;
    wire [191:0] dout_pool2;
    
    pool2_layer uut_pool2 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_pool2),
        .din(din_pool2),
        
        .ready_to_upstream(enable_next_read_gff_conv2),
        
        .valid_out(valid_out_pool2),
        .dout(dout_pool2)
    );
    
    wire enable_next_read_gff_pool2;
    wire valid_out_gff_pool2;
    wire [191:0] dout_gff_pool2;
    
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(256),
        .MAX_OCCUPANCY(50),
        .ADDRESS_WIDTH(10)
    ) uut_gff_pool2 (
        .clk(clk), .rstn(rstn),
        
        .clear(1'b0),
        
        .enable_next_read(enable_next_read_gff_pool2),
        
        .valid_in(valid_out_pool2),
        .din(dout_pool2),
        
        .wr_cnt(wr_cnt_gff_pool2),
        .rd_cnt(rd_cnt_gff_pool2),
        
        .valid_out(valid_out_gff_pool2),
        .dout(dout_gff_pool2)
    );
    
    wire valid_in_conv3 = valid_out_gff_pool2;
    wire [191:0] din_conv3 = dout_gff_pool2;
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
        
        .ready_to_upstream(enable_next_read_gff_pool2),
        
        .raw_valid_out(raw_valid_out_conv3),
        .raw_dout(raw_dout_conv3),
        
        .valid_out(valid_out_conv3),
        .dout(dout_conv3)
    );
    
    wire enable_next_read_gff_conv3;
    wire valid_out_gff_conv3;
    wire [191:0] dout_gff_conv3;
    
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(128),
        .MAX_OCCUPANCY(36),
        .ADDRESS_WIDTH(10)
    ) uut_gff_conv3 (
        .clk(clk), .rstn(rstn),
        
        .clear(1'b0),
        
        .enable_next_read(enable_next_read_gff_conv3),
        
        .valid_in(valid_out_conv3),
        .din(dout_conv3),
        
        .wr_cnt(wr_cnt_gff_conv3),
        .rd_cnt(rd_cnt_gff_conv3),
        
        .valid_out(valid_out_gff_conv3),
        .dout(dout_gff_conv3)
    );
    
    wire valid_out_ipt;
    wire [767:0] dout_ipt;
    pool3_ipt uut_ipt (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0), 
        .enable_buffer_input(1'b1),
        
        .valid_in(valid_out_gff_conv3), .din(dout_gff_conv3),
        
        .ready_to_upstream(enable_next_read_gff_conv3),
        
        .valid_out(valid_out_ipt), .dout(dout_ipt)
    );
    
    wire valid_out;
    wire [191:0] dout;
    
    pool_engine #(
        .DATA_WIDTH(24)
    ) uut_max_pool (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_ipt), .din(dout_ipt),
        
        .valid_out(valid_out), .dout(dout)
    );
    
    reg [9:0] cntr;
    
    integer file_pool3, file_pool3_kernel;
    
    wire valid_out_rck;
    wire [767:0] dout_rck;
    relayout_comparator_kernel #(
        .DATA_WIDTH(24)
    ) uut_rck (
        .valid_in(valid_out_ipt),
        .din(dout_ipt),
        .valid_out(valid_out_rck),
        .dout(dout_rck)
    );
    
    always @(posedge clk) begin
        if (!rstn) begin
            cntr <= 10'b0;
        end
        
        if (valid_out_rck) begin
            $fwrite(file_pool3_kernel, "%h\n", dout_rck);
            $fflush(file_pool3_kernel);
        end
        
        if (valid_out) begin
            $fwrite(file_pool3, "%h\n", dout);
            $fflush(file_pool3);
            cntr <= cntr + 1'b1;
        end
    end
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rstn = 0;
        #10
        
        rstn = 1; #10
        
        file_pool3 = $fopen("file_pool3.txt", "w");
        file_pool3_kernel = $fopen("file_pool3_kernel.txt", "w");
        
        #25000
        
        $finish;
    end

endmodule

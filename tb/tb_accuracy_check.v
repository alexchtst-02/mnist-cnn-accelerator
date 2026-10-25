`timescale 1ns / 1ps

module tb_accuracy_check;

    reg clk, rstn;

    wire ready_to_upstream_out_fcm;

    wire valid_pixel_imitate_stream;
    wire [7:0] pixel_imitate_stream;
    wire [23:0] px_cnt_fcm;
    
    imitate_stream_pixels #(
        .ADDR_W(24),
        .FRAME_PIXELS(784),
        .FRAME_NUM(1000)
    ) uut_imitate_stream (
        .clk(clk),
        .rstn(rstn),
    
        .ready_in(ready_to_upstream_out_fcm),
    
        .valid_out(valid_pixel_imitate_stream),
        .pixel_out(pixel_imitate_stream),
    
        .px_cnt(px_cnt_fcm)
    );

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
    
    wire [9:0] wr_cnt_gff_pool3;
    wire [9:0] rd_cnt_gff_pool3;
    
    reg [9:0] fc1_cnt, fc2_cnt;
    
    wire enable_next_read_gff;
    wire valid_out_gff;
    wire [7:0] dout_gff;

    wire valid_argmax;
    wire [3:0] class_out;

    wire global_flush_fcm;
    wire global_flush_imidiate_fcm;
    flush_control_mechanism #(
        .ADDRESS_WIDTH(10),
    
        .MAX_PIXELS(784),
        .CONV1_POOL1(169),
        .CONV2(242),
        .POOL2(50),
        .CONV3(36),
        .POOL3(4)
    ) uut_fcm (
    
        .rstn(rstn),
    
        .pixel_counter(wr_cnt_gff),
        .occ_conv1_pool1(rd_cnt_gff_pool1),
        .occ_conv2(rd_cnt_gff_conv2),
        .occ_pool2(rd_cnt_gff_pool2),
        .occ_conv3(rd_cnt_gff_conv3),
        .occ_pool3(rd_cnt_gff_pool3),
    
        .valid_argmax(valid_argmax),
    
        .ready_to_upstream_out(ready_to_upstream_out_fcm),
    
        .flush(global_flush_fcm),
        .flush_imidiate(global_flush_imidiate_fcm)
    );

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
    
    wire [9:0] wr_cnt_gff_pool3;
    wire [9:0] rd_cnt_gff_pool3;
    
    wire [7:0] pixel_data = pixel_imitate_stream;
    wire valid_pixel_data = valid_pixel_imitate_stream;
    
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

        .clear(global_flush_fcm),

        .enable_next_read(enable_next_read_gff),

        .valid_in(valid_pixel_data),
        .din(pixel_data),

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

        .clear_reset(global_flush_fcm),

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

        .clear_reset(global_flush_fcm),

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

        .clear(global_flush_fcm),

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

        .clear(global_flush_fcm),

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
        
        .clear_reset(global_flush_fcm),
        
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
        
        .clear(global_flush_fcm),
        
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
        
        .clear_reset(global_flush_fcm),
        
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
        
        .clear(global_flush_fcm),
        
        .enable_next_read(enable_next_read_gff_conv3),
        
        .valid_in(valid_out_conv3),
        .din(dout_conv3),
        
        .wr_cnt(wr_cnt_gff_conv3),
        .rd_cnt(rd_cnt_gff_conv3),
        
        .valid_out(valid_out_gff_conv3),
        .dout(dout_gff_conv3)
    );
    
    wire valid_in_pool3 = valid_out_gff_conv3;
    wire [191:0] din_pool3 = dout_gff_conv3;
    wire valid_out_pool3;
    wire [191:0] dout_pool3;
    
    pool3_layer uut_pool3 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(global_flush_fcm),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_pool3),
        .din(din_pool3),
        
        .ready_to_upstream(enable_next_read_gff_conv3),
        
        .valid_out(valid_out_pool3),
        .dout(dout_pool3)
    );
    
    wire enable_next_read_gff_pool3;
    wire valid_out_gff_pool3;
    wire [191:0] dout_gff_pool3;
    
    group_feature_fifo #(
        .WORD_WIDTH(192),
        .DEPTH(8),
        .MAX_OCCUPANCY(4),
        .ADDRESS_WIDTH(10)
    ) uut_gff_5 (
        .clk(clk), .rstn(rstn),
        
        .clear(global_flush_fcm),
        
        .enable_next_read(enable_next_read_gff_pool3),
        
        .valid_in(valid_out_pool3),
        .din(dout_pool3),
        
        .wr_cnt(wr_cnt_gff_pool3),
        .rd_cnt(rd_cnt_gff_pool3),
        
        .valid_out(valid_out_gff_pool3),
        .dout(dout_gff_pool3)
    );
    
    wire valid_in_fc1 = valid_out_gff_pool3;
    wire [191:0] din_fc1 = dout_gff_pool3;
    wire raw_valid_out_fc1;
    wire [367:0] raw_dout_fc1;
    wire valid_out_fc1;
    wire [191:0] dout_fc1;
    
    fully_connected_1_layer uut_fc1 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(global_flush_fcm),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_fc1),
        .din(din_fc1),
        
        .ready_to_upstream(enable_next_read_gff_pool3),
        
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
        
        .clear_reset(global_flush_fcm),
        
        .enable_input(1'b1),
        
        .valid_in(valid_in_fc2),
        .din(din_fc2),
        
        .ready_to_upstream(ready_to_upstream_fc2),
        
        .raw_valid_out(raw_valid_out_fc2),
        .raw_dout(raw_dout_fc2),
        
        .valid_out(valid_out_fc2),
        .dout(dout_fc2)
    );
    
    argmax_10_class uut_argmax (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_fc2),
        .din(dout_fc2),
        
        .valid_out(valid_argmax),
        .class_out(class_out)
    );
    
    integer gff_level;
    integer conv1_raw, conv1_req;
    integer pool1;
    integer conv2_raw, conv2_req;
    integer pool2;
    integer conv3_raw, conv3_req;
    integer pool3;
    integer fc1_raw, fc1_req;
    integer fc2_raw, fc2_req;
    
    integer argmax_prediction;
    
    always @(posedge clk) begin
        if (global_flush_fcm) begin
            fc1_cnt <= 0;
            fc2_cnt <= 0; 
        end
         
         $fwrite(gff_level, "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h\n", 
            wr_cnt_gff, rd_cnt_gff, 
            wr_cnt_gff_pool1, rd_cnt_gff_pool1,
            wr_cnt_gff_conv2, rd_cnt_gff_conv2,
            wr_cnt_gff_pool2, rd_cnt_gff_pool2,
            wr_cnt_gff_conv3, rd_cnt_gff_conv3,
            wr_cnt_gff_pool3, rd_cnt_gff_pool3,
            fc1_cnt,fc2_cnt,
            global_flush_fcm
            );

         $fflush(gff_level);
         
        if (raw_valid_out_conv1) begin
            $fwrite(conv1_raw, "%h\n", raw_dout_conv1);
            $fflush(conv1_raw);
        end

        if (valid_out_conv1) begin
            $fwrite(conv1_req, "%h\n", dout_conv1);
            $fflush(conv1_req);
        end

        if (valid_out_pool1) begin
            $fwrite(pool1, "%h\n", dout_pool1);
            $fflush(pool1);
        end

        if (raw_valid_out_conv2) begin
            $fwrite(conv2_raw, "%h\n", raw_dout_conv2);
            $fflush(conv2_raw);
        end

        if (valid_out_conv2) begin
            $fwrite(conv2_req, "%h\n", dout_conv2);
            $fflush(conv2_req);
        end

        if (valid_out_pool2) begin
            $fwrite(pool2, "%h\n", dout_pool2);
            $fflush(pool2);
        end

        if (raw_valid_out_conv3) begin
            $fwrite(conv3_raw, "%h\n", raw_dout_conv3);
            $fflush(conv3_raw);
        end

        if (valid_out_conv3) begin
            $fwrite(conv3_req, "%h\n", dout_conv3);
            $fflush(conv3_req);
        end

        if (valid_out_pool3) begin
            $fwrite(pool3, "%h\n", dout_pool3);
            $fflush(pool3);
        end

        if (raw_valid_out_fc1) begin
            $fwrite(fc1_raw, "%h\n", raw_dout_fc1);
            $fflush(fc1_raw);
        end

        if (valid_out_fc1) begin
            $fwrite(fc1_req, "%h\n", dout_fc1);
            fc1_cnt <= fc1_cnt + 1;
            $fflush(fc1_req);
        end

        if (raw_valid_out_fc2) begin
            $fwrite(fc2_raw, "%h\n", raw_dout_fc2);
            $fflush(fc2_raw);
        end

        if (valid_out_fc2) begin
            $fwrite(fc2_req, "%h\n", dout_fc2);
            fc2_cnt <= fc2_cnt + 1;
            $fflush(fc2_req);
        end
        
        if (valid_argmax) begin
            $fwrite(argmax_prediction, "%h\n", class_out);
            $fflush(argmax_prediction);
        end

    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn = 0;
        fc1_cnt = 0;
        fc2_cnt = 0; 
        #10
        rstn = 1; #10
        
        gff_level = $fopen("gff_level.txt", "w");
        
        conv1_raw = $fopen("conv1_raw.txt", "w");
        conv1_req = $fopen("conv1_req.txt", "w");
        
        pool1 = $fopen("pool1.txt", "w");
        
        conv2_raw = $fopen("conv2_raw.txt", "w");
        conv2_req = $fopen("conv2_req.txt", "w");
        
        pool2 = $fopen("pool2.txt", "w");
        
        conv3_raw = $fopen("conv3_raw.txt", "w");
        conv3_req = $fopen("conv3_req.txt", "w");
        
        pool3 = $fopen("pool3.txt", "w");
        
        fc1_raw = $fopen("fc1_raw.txt", "w");
        fc1_req = $fopen("fc1_req.txt", "w");
        
        fc2_raw = $fopen("fc2_raw.txt", "w");
        fc2_req = $fopen("fc2_req.txt", "w");
        
        argmax_prediction = $fopen("argmax_prediction.txt", "w");

        #22000000;

        $finish;
    end

endmodule
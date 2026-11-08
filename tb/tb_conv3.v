`timescale 1ns / 1ps

module tb_conv3;

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
    
    wire valid_out_ipt;
    wire [1727:0] dout_ipt;
    wire valid_param;
    wire signed [1151:0] weight_param;
    conv3_ipt uut_ipt (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0), 
        .enable_buffer_input(1'b1),
        
        .valid_in(valid_out_gff_pool2), .din(dout_gff_pool2),
        
        .ready_to_upstream(enable_next_read_gff_pool2),
        
        .valid_out(valid_out_ipt), .dout(dout_ipt),
        .valid_weight(valid_param), .weight(weight_param)
    );
    
    wire valid_out;
    wire [191:0] dout;
    
    wire raw_valid_out;
    wire [399:0] raw_dout;
    
    wire [359:0] dout_convolver;
    wire valid_out_convolver;
    convolver_engine #(
        .DATA_WIDTH(24)
    ) uut_convolver (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_ipt), .din(dout_ipt),
        .valid_weight(valid_param), .weight(weight_param),
        
        .valid_out(valid_out_convolver), .dout(dout_convolver)
    );
    
    // in ch = 16 and out ch = 32
    // the 8 channels resluts must be accumulated and produce 1/2 ch from 32 ch
    // there fore we need to buffer this 8 partialed from 16 ch 
    
    wire valid_out_acc_8ch;
    wire [47:0] dout_acc_8ch;
    accumulator_8ch #(
        .DATA_WIDTH(45)
    ) uut_acc_8ch (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_convolver), .din(dout_convolver),
        
        .valid_out(valid_out_acc_8ch), .dout(dout_acc_8ch)
    );
    
    wire valid_out_buff_acc_partial;
    wire [95:0] dout_buff_acc_partial;
    buffer_acc_partial #(
        .DATA_WIDTH(48)
    ) uut_buff_acc_partial (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_acc_8ch),
        .din(dout_acc_8ch),
        
        .valid_out(valid_out_buff_acc_partial),
        .dout(dout_buff_acc_partial)
    );
    
    // this is where we accumulate the acc(8) + acc(8) and produce 1 valid ch from 32 ch
    
    wire valid_out_acc_partial;
    wire [48:0] dout_acc_partial;
    accumulator_partial #(
        .DATA_WIDTH(48)
    ) uut_acc_partial (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_buff_acc_partial),
        .din(dout_buff_acc_partial),
        
        .valid_out(valid_out_acc_partial),
        .dout(dout_acc_partial)
    );
    
    wire valid_out_buff_acc_ch8;
    wire [391:0] dout_buff_acc_ch8;
    buffer_acc_8ch #(
        .DATA_WIDTH(49)
    ) uut_buff_acc_ch8 (
         .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_acc_partial), .din(dout_acc_partial),
        
        .valid_out(valid_out_buff_acc_ch8), .dout(dout_buff_acc_ch8)
    );
    
    // implement the sync because of delay
    
    wire valid_out_buff_reg;
    wire [391:0] dout_buff_reg;
    buffer_2_register #(
        .WORD_WIDTH(392)
    ) uut_buff_reg (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_buff_acc_ch8),
        .din(dout_buff_acc_ch8),
        
        .valid_out(valid_out_buff_reg),
        .dout(dout_buff_reg)
    );
    
    wire valid_bias;
    wire [127:0] param_bias;
    conv3_bias_gen uut_bias (
        .clk(clk), .rstn(rstn),
        
        .enable(valid_out_buff_acc_ch8),
        
        .valid_bias(valid_bias),
        .bias(param_bias)
    );
    
    
    bias_accumulator #(
        .DATA_WIDTH(49)
    ) uut_bias_acc (
         .clk(clk), .rstn(rstn),
        
        .valid_din(valid_out_buff_reg),
        .din(dout_buff_reg),
        
        .valid_bias(valid_bias),
        .bias(param_bias),
        
        .valid_out(raw_valid_out),
        .dout(raw_dout)
    );
    
    // implement relu 
    wire valid_out_bias_relu;
    wire [399:0] dout_bias_relu;
    relu #(
        .DATA_WIDTH(50)
    ) uut_relu (
        .valid_in(raw_valid_out),
        .din(raw_dout),
        .valid_out(valid_out_bias_relu),
        .dout(dout_bias_relu)
    );
    
    // requantitize
    
    requant_10_14 #(
        .DATA_FRACT_BIT(28),
        .DATA_INT_BIT(22)
    ) uut_req_10_14 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_bias_relu),
        .din(dout_bias_relu),
        
        .valid_out(valid_out),
        .dout(dout)
    );
    
    wire valid_out_rck;
    wire [1727:0] dout_rck;
    relayout_mac_kernel #(
        .DATA_WIDTH(24)
    ) uut_rck (
        .valid_in(valid_out_ipt),
        .din(dout_ipt),
        .valid_out(valid_out_rck),
        .dout(dout_rck)
    );
    
    integer file_conv3, file_conv3_kernel, file_raw_conv3;
    
    reg [9:0] cntr;
    
     always @(posedge clk) begin
        if (!rstn) begin
            cntr <= 10'b0;
        end
        
        if (valid_out_rck) begin
            $fwrite(file_conv3_kernel, "%h\n", dout_rck);
            $fflush(file_conv3_kernel);
        end
        
        if (valid_out) begin
            $fwrite(file_conv3, "%h\n", dout);
            $fflush(file_conv3);
            cntr <= cntr + 1'b1;
        end
        
        if (raw_valid_out) begin
            $fwrite(file_raw_conv3, "%h\n", raw_dout);
            $fflush(file_raw_conv3);
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
        
        file_conv3 = $fopen("file_conv3.txt", "w");
        file_raw_conv3 = $fopen("file_raw_conv3.txt", "w");
        file_conv3_kernel = $fopen("file_conv3_kernel.txt", "w");
        
        #25000
        
        $finish;
    end

endmodule

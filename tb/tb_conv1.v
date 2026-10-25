`timescale 1ns / 1ps

module tb_conv1;

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
    
    wire valid_out_ipt;
    wire [1727:0] dout_ipt;
    wire valid_param;
    wire signed [1151:0] weight_param;
    conv1_ipt uut_ipt (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(1'b0),
        .enable_buffer_input(1'b1),
        
        .valid_in(valid_out_egp), .din(dout_egp),
        
        .ready_to_upstream(enable_next_read_gff),
        
        .valid_out(valid_out_ipt), .dout(dout_ipt),
        .valid_param(valid_param), .weight_param(weight_param)
    );
    
    wire [367:0] raw_dout;
    wire raw_valid_out;
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
    
    // bias implementation => produce 8 channels pararel as 1 pixel contain 8 channels
    
    wire valid_bias;
    wire signed [127:0] param_bias;
    conv1_b uut_bias (
        .valid_out(valid_bias),
        .param_bias(param_bias)
    );
    
    
    bias_accumulator #(
        .DATA_WIDTH(45)
    ) uut_bias_acc (
        .clk(clk), .rstn(rstn),
        
        .valid_din(valid_out_convolver), .din(dout_convolver),
        .valid_bias(valid_bias), .bias(param_bias),
        
        .valid_out(raw_valid_out), .dout(raw_dout)
    );
    
    // implement relu 
    
    wire signed [367:0] dout_bias_relu;
    wire valid_out_bias_relu;
    
    relu #(
        .DATA_WIDTH(46)
    ) uut_relu (
        .valid_in(raw_valid_out),
        .din(raw_dout),
        .valid_out(valid_out_bias_relu),
        .dout(dout_bias_relu)
    );
    
    wire [191:0] requant_dout;
    wire requant_valid_out;
    requant_10_14 #(
        .DATA_FRACT_BIT(28),
        .DATA_INT_BIT(18)
    ) uut_req_10_14 (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_bias_relu),
        .din(dout_bias_relu),
        
        .valid_out(requant_valid_out),
        .dout(requant_dout)
    );
    
    integer file_conv1, file_conv1_kernel, file_raw_conv1;
    
    // this module already implemented in conv1_engine 
    // but for debug and match purpose we implement before store to txt file
    wire valid_out_rmk;
    wire [24*8*9-1:0] dout_rmk;
    relayout_mac_kernel #(
        .DATA_WIDTH(24)
    ) uut_rmk (
        .valid_in(valid_out_ipt),
        .din(dout_ipt),
        
        .valid_out(valid_out_rmk),
        .dout(dout_rmk)
    );
    
    always @(posedge clk) begin
        if (requant_valid_out) begin
            $fwrite(file_conv1, "%h\n", requant_dout);
        end
        
        if (raw_valid_out) begin
            $fwrite(file_raw_conv1, "%h\n", raw_dout);
        end
        
        if (valid_out_rmk) begin
            $fwrite(file_conv1_kernel, "%h\n", dout_rmk);
        end
    end
    
    initial begin
        file_conv1 = $fopen("file_conv1.txt", "w");
        file_conv1_kernel = $fopen("file_conv1_kernel.txt", "w");
        file_raw_conv1 = $fopen("file_raw_conv1.txt", "w");
    end
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rstn = 0;
        #10
        
        rstn = 1; #10
        
        #8000
        
        $fclose(file_conv1);
        $fclose(file_conv1_kernel);
        $fclose(file_raw_conv1);
        
        $finish;
    end

endmodule

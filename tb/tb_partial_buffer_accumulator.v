`timescale 1ns / 1ps

module tb_partial_buffer_accumulator;
    
    reg clk, rstn;
    
    reg valid_in;
    reg signed [23:0] din;
    
    wire valid_out_buf_acc_partial;
    wire signed [47:0] dout_buf_acc_partial;
    wire signed [23:0] dout_buf_acc_partial_0 = dout_buf_acc_partial[24*0 +: 24];
    wire signed [23:0] dout_buf_acc_partial_1 = dout_buf_acc_partial[24*1 +: 24];
    buffer_acc_partial #(
        .DATA_WIDTH(24)
    ) uut_buf_acc_partial (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_in), .din(din),
        
        .valid_out(valid_out_buf_acc_partial), .dout(dout_buf_acc_partial)
    );
    
    wire valid_out_acc_partial;
    wire signed [24:0] dout_acc_partial;
    accumulator_partial #(
        .DATA_WIDTH(24)
    ) uut_acc_partial (
        .clk(clk), .rstn(rstn),
        
        .valid_in(valid_out_buf_acc_partial), .din(dout_buf_acc_partial),
        
        .valid_out(valid_out_acc_partial), .dout(dout_acc_partial)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    integer i;
    
    initial begin
        rstn = 0;
        valid_in = 0;
        din = 24'sd0;
        #10
        
        rstn = 1; #10
        
        for (i = 0; i < 100; i = i + 1) begin
            @(negedge clk);
            valid_in = 1;
            din = i - 10*5;
        end
        
        $finish;
    end
    
endmodule

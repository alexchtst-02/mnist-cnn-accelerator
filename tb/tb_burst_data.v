`timescale 1ns / 1ps

module tb_burst_data;

    reg clk, rstn, clear_reset;
    
    reg valid_in_data;
    reg [23:0] data_in;
    
    wire valid_out0_b2d;
    wire [23:0] dut0_b2d;
    wire valid_out1_b2d;
    wire [23:0] dut1_b2d;
    burst_2_data #(
        .DATA_WIDTH(24)
    ) uut_b2d (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(clear_reset),
        
        .ready_from_downstream0(1'b1),
        .ready_from_downstream1(1'b1),
        
        .valid_in(valid_in_data), .din(data_in),
        
        .ready_to_upstream(ready_to_upstream_b2d),
        
        .valid_out0(valid_out0_b2d), .dout0(dut0_b2d),
        .valid_out1(valid_out1_b2d), .dout1(dut1_b2d)
    );
    
    wire valid_out0_b4d;
    wire [23:0] dut0_b4d;
    wire valid_out1_b4d;
    wire [23:0] dut1_b4d;
    wire valid_out2_b4d;
    wire [23:0] dut2_b4d;
    wire valid_out3_b4d;
    wire [23:0] dut3_b4d;
    burst_4_data #(
        .DATA_WIDTH(24)
    ) uut_b4d (
        .clk(clk), .rstn(rstn),
        
        .clear_reset(clear_reset),
        
        .ready_from_downstream0(1'b1),
        .ready_from_downstream1(1'b1),
        .ready_from_downstream2(1'b1),
        .ready_from_downstream3(1'b1),
        
        .valid_in(valid_in_data), .din(data_in),
        
        .ready_to_upstream(ready_to_upstream_b4d),
        
        .valid_out0(valid_out0_b4d), .dout0(dut0_b4d),
        .valid_out1(valid_out1_b4d), .dout1(dut1_b4d),
        .valid_out3(valid_out2_b4d), .dout2(dut2_b4d),
        .valid_out2(valid_out3_b4d), .dout3(dut3_b4d)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    integer i;
    
    initial begin
        rstn = 0;
        valid_in_data = 0;
        data_in = 0; 
        clear_reset = 0;
        #10
        rstn = 1; #10
        
        for (i = 0; i < 30; i = i + 1) begin
            @(negedge clk)
            valid_in_data = 1;
            data_in = (i+1) * 10;
        end
        
        $finish;
    end

endmodule

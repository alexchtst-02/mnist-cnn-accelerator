`timescale 1ns / 1ps
module tb_cirlular_input_multiplexed;

    reg clk, rstn, clear_reset, enable;
    
    reg valid_in_cim;
    reg [95:0] din_cim;
    reg [23:0] data0, data1, data2, data3;
    
    wire ready_to_upstream_cim;
    wire valid_out_cim;
    wire [23:0] dout_cim;
    cirlular_input_multiplexed #(
        .DATA_WIDTH(24),
        .DATA_NUM(4),
        .TIME_MULTIPLEX(16)
    ) uut_cim (
        .clk(clk), .rstn(rstn), .clear_reset(clear_reset),
        .enable(enable),
        
        .valid_in(valid_in_cim),
        .din(din_cim),
        
        .ready_to_upstream(ready_to_upstream_cim),
        .valid_out(valid_out_cim),
        .dout(dout_cim)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    
    integer k;
    initial begin
        rstn = 0;
        clear_reset = 0;
        enable = 0;
        valid_in_cim = 0;
        din_cim = 0;
        #10
        
        rstn = 1; #10
        enable = 1;
        for (k = 0; k < 300; k = k + 1) begin
            @(negedge clk)
            valid_in_cim = 0;
            if (ready_to_upstream_cim) begin
                valid_in_cim = 1;
                data0 = k; data1 = k + 1; data2 = k + 2; data3 = k + 3;
                din_cim = {data3, data2, data1, data0};
            end
        end
        
        $finish;
    end

endmodule

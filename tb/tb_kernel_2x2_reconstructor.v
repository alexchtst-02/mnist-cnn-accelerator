`timescale 1ns / 1ps

module tb_kernel_2x2_reconstructor;

    reg clk, rstn;
    
    reg ready_from_downsteram_k2r;
    reg clear_reset_kernel_k2r;
    reg valid_in_k2r;
    reg [191:0] din_k2r;
    wire ready_to_upstream_k2r;
    wire valid_out_k2r;
    wire [767:0] dout_k2r;
    wire [191:0] dout_k2r_0 = dout_k2r[192*0 +: 192];
    wire [191:0] dout_k2r_1 = dout_k2r[192*1 +: 192];
    wire [191:0] dout_k2r_2 = dout_k2r[192*2 +: 192];
    wire [191:0] dout_k2r_3 = dout_k2r[192*3 +: 192];
    kernel_2x2_reconstructor #(
        .DATA_WIDTH(24),
        .LINE_WIDTH(11)
    ) uut_k2r (
        .clk(clk), .rstn(rstn),
        
        .clear_reset_kernel(clear_reset_kernel_k2r),
        
        .ready_from_downstream(ready_from_downsteram_k2r),
        .valid_in(valid_in_k2r),
        .din(din_k2r),
        
        .ready_to_upstream(ready_to_upstream_k2r),
        .valid_out(valid_out_k2r),
        .dout(dout_k2r)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    integer r;
    initial begin
        rstn = 0;
        ready_from_downsteram_k2r = 0;
        valid_in_k2r = 0;
        din_k2r = 0; 
        clear_reset_kernel_k2r = 0;
        #10
        
        rstn = 1; #10
        
        for (r = 0; r < 30*30; r = r + 1) begin
            @(negedge clk);
            valid_in_k2r = 1;
            din_k2r = (r + 1) * 10;
            ready_from_downsteram_k2r = 1;
        end
        
        $finish;
    end

endmodule

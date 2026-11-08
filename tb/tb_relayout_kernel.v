`timescale 1ns / 1ps

module tb_relayout_kernel;

    reg clk, rstn;
    
    reg valid_in;
    reg [23:0] dinch0, dinch1, dinch2, dinch3, dinch4, dinch5, dinch6, dinch7;
    wire [191:0] din_mac = {dinch7, dinch6, dinch5, dinch4, dinch3, dinch2, dinch1, dinch0};
    wire [191:0] din_comp = {dinch7, dinch6, dinch5, dinch4, dinch3, dinch2, dinch1, dinch0};
    
    wire valid_out_k3r_0;
    wire [24*8*9-1:0] dout_k3r_0;
    wire [23:0] dout_k3r_0_0 = dout_k3r_0[24*0 +: 24];
    wire [23:0] dout_k3r_0_1 = dout_k3r_0[24*1 +: 24];
    wire [23:0] dout_k3r_0_2 = dout_k3r_0[24*2 +: 24];
    wire [23:0] dout_k3r_0_3 = dout_k3r_0[24*3 +: 24];
    wire [23:0] dout_k3r_0_4 = dout_k3r_0[24*4 +: 24];
    wire [23:0] dout_k3r_0_5 = dout_k3r_0[24*5 +: 24];
    wire [23:0] dout_k3r_0_6 = dout_k3r_0[24*6 +: 24];
    wire [23:0] dout_k3r_0_7 = dout_k3r_0[24*7 +: 24];
    wire [23:0] dout_k3r_0_8 = dout_k3r_0[24*8 +: 24];
    wire [23:0] dout_k3r_0_9 = dout_k3r_0[24*9 +: 24];
    wire [23:0] dout_k3r_0_10 = dout_k3r_0[24*10 +: 24];
    wire [23:0] dout_k3r_0_11 = dout_k3r_0[24*11 +: 24];
    wire [23:0] dout_k3r_0_12 = dout_k3r_0[24*12 +: 24];
    wire [23:0] dout_k3r_0_13 = dout_k3r_0[24*13 +: 24];
    wire [23:0] dout_k3r_0_14 = dout_k3r_0[24*14 +: 24];
    wire [23:0] dout_k3r_0_15 = dout_k3r_0[24*15 +: 24];
    wire [23:0] dout_k3r_0_16 = dout_k3r_0[24*16 +: 24];
    wire [23:0] dout_k3r_0_17 = dout_k3r_0[24*17 +: 24];
    wire [23:0] dout_k3r_0_18 = dout_k3r_0[24*18 +: 24];
    wire [23:0] dout_k3r_0_19 = dout_k3r_0[24*19 +: 24];
    wire [23:0] dout_k3r_0_20 = dout_k3r_0[24*20 +: 24];
    wire [23:0] dout_k3r_0_21 = dout_k3r_0[24*21 +: 24];
    wire [23:0] dout_k3r_0_22 = dout_k3r_0[24*22 +: 24];
    wire [23:0] dout_k3r_0_23 = dout_k3r_0[24*23 +: 24];
    wire [23:0] dout_k3r_0_24 = dout_k3r_0[24*24 +: 24];
    wire [23:0] dout_k3r_0_25 = dout_k3r_0[24*25 +: 24];
    wire [23:0] dout_k3r_0_26 = dout_k3r_0[24*26 +: 24];
    wire [23:0] dout_k3r_0_27 = dout_k3r_0[24*27 +: 24];
    wire [23:0] dout_k3r_0_28 = dout_k3r_0[24*28 +: 24];
    wire [23:0] dout_k3r_0_29 = dout_k3r_0[24*29 +: 24];
    wire [23:0] dout_k3r_0_30 = dout_k3r_0[24*30 +: 24];
    wire [23:0] dout_k3r_0_31 = dout_k3r_0[24*31 +: 24];
    wire [23:0] dout_k3r_0_32 = dout_k3r_0[24*32 +: 24];
    wire [23:0] dout_k3r_0_33 = dout_k3r_0[24*33 +: 24];
    wire [23:0] dout_k3r_0_34 = dout_k3r_0[24*34 +: 24];
    wire [23:0] dout_k3r_0_35 = dout_k3r_0[24*35 +: 24];
    wire [23:0] dout_k3r_0_36 = dout_k3r_0[24*36 +: 24];
    wire [23:0] dout_k3r_0_37 = dout_k3r_0[24*37 +: 24];
    wire [23:0] dout_k3r_0_38 = dout_k3r_0[24*38 +: 24];
    wire [23:0] dout_k3r_0_39 = dout_k3r_0[24*39 +: 24];
    wire [23:0] dout_k3r_0_40 = dout_k3r_0[24*40 +: 24];
    wire [23:0] dout_k3r_0_41 = dout_k3r_0[24*41 +: 24];
    wire [23:0] dout_k3r_0_42 = dout_k3r_0[24*42 +: 24];
    wire [23:0] dout_k3r_0_43 = dout_k3r_0[24*43 +: 24];
    wire [23:0] dout_k3r_0_44 = dout_k3r_0[24*44 +: 24];
    wire [23:0] dout_k3r_0_45 = dout_k3r_0[24*45 +: 24];
    wire [23:0] dout_k3r_0_46 = dout_k3r_0[24*46 +: 24];
    wire [23:0] dout_k3r_0_47 = dout_k3r_0[24*47 +: 24];
    wire [23:0] dout_k3r_0_48 = dout_k3r_0[24*48 +: 24];
    wire [23:0] dout_k3r_0_49 = dout_k3r_0[24*49 +: 24];
    wire [23:0] dout_k3r_0_50 = dout_k3r_0[24*50 +: 24];
    wire [23:0] dout_k3r_0_51 = dout_k3r_0[24*51 +: 24];
    wire [23:0] dout_k3r_0_52 = dout_k3r_0[24*52 +: 24];
    wire [23:0] dout_k3r_0_53 = dout_k3r_0[24*53 +: 24];
    wire [23:0] dout_k3r_0_54 = dout_k3r_0[24*54 +: 24];
    wire [23:0] dout_k3r_0_55 = dout_k3r_0[24*55 +: 24];
    wire [23:0] dout_k3r_0_56 = dout_k3r_0[24*56 +: 24];
    wire [23:0] dout_k3r_0_57 = dout_k3r_0[24*57 +: 24];
    wire [23:0] dout_k3r_0_58 = dout_k3r_0[24*58 +: 24];
    wire [23:0] dout_k3r_0_59 = dout_k3r_0[24*59 +: 24];
    wire [23:0] dout_k3r_0_60 = dout_k3r_0[24*60 +: 24];
    wire [23:0] dout_k3r_0_61 = dout_k3r_0[24*61 +: 24];
    wire [23:0] dout_k3r_0_62 = dout_k3r_0[24*62 +: 24];
    wire [23:0] dout_k3r_0_63 = dout_k3r_0[24*63 +: 24];
    wire [23:0] dout_k3r_0_64 = dout_k3r_0[24*64 +: 24];
    wire [23:0] dout_k3r_0_65 = dout_k3r_0[24*65 +: 24];
    wire [23:0] dout_k3r_0_66 = dout_k3r_0[24*66 +: 24];
    wire [23:0] dout_k3r_0_67 = dout_k3r_0[24*67 +: 24];
    wire [23:0] dout_k3r_0_68 = dout_k3r_0[24*68 +: 24];
    wire [23:0] dout_k3r_0_69 = dout_k3r_0[24*69 +: 24];
    wire [23:0] dout_k3r_0_70 = dout_k3r_0[24*70 +: 24];
    wire [23:0] dout_k3r_0_71 = dout_k3r_0[24*71 +: 24];
    wire ready_to_upstream_k3r_0;
    kernel_3x3_reconstructor #(
        .DATA_WIDTH(24),
        .LINE_WIDTH(3)
    ) uut_k3r_0 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset_kernel(1'b0),
        
        .ready_from_downstream(1'b1),
        .valid_in(valid_in),
        .din(din_mac),
        
        .ready_to_upstream(ready_to_upstream_k3r_0),
        .valid_out(valid_out_k3r_0),
        .dout(dout_k3r_0)
    );
    
    wire valid_out_k2r_0;
    wire [24*8*4-1:0] dout_k2r_0;
    wire [23:0] dout_k2r_0_0 = dout_k2r_0[24*0 +: 24];
    wire [23:0] dout_k2r_0_1 = dout_k2r_0[24*1 +: 24];
    wire [23:0] dout_k2r_0_2 = dout_k2r_0[24*2 +: 24];
    wire [23:0] dout_k2r_0_3 = dout_k2r_0[24*3 +: 24];
    wire [23:0] dout_k2r_0_4 = dout_k2r_0[24*4 +: 24];
    wire [23:0] dout_k2r_0_5 = dout_k2r_0[24*5 +: 24];
    wire [23:0] dout_k2r_0_6 = dout_k2r_0[24*6 +: 24];
    wire [23:0] dout_k2r_0_7 = dout_k2r_0[24*7 +: 24];
    wire [23:0] dout_k2r_0_8 = dout_k2r_0[24*8 +: 24];
    wire [23:0] dout_k2r_0_9 = dout_k2r_0[24*9 +: 24];
    wire [23:0] dout_k2r_0_10 = dout_k2r_0[24*10 +: 24];
    wire [23:0] dout_k2r_0_11 = dout_k2r_0[24*11 +: 24];
    wire [23:0] dout_k2r_0_12 = dout_k2r_0[24*12 +: 24];
    wire [23:0] dout_k2r_0_13 = dout_k2r_0[24*13 +: 24];
    wire [23:0] dout_k2r_0_14 = dout_k2r_0[24*14 +: 24];
    wire [23:0] dout_k2r_0_15 = dout_k2r_0[24*15 +: 24];
    wire [23:0] dout_k2r_0_16 = dout_k2r_0[24*16 +: 24];
    wire [23:0] dout_k2r_0_17 = dout_k2r_0[24*17 +: 24];
    wire [23:0] dout_k2r_0_18 = dout_k2r_0[24*18 +: 24];
    wire [23:0] dout_k2r_0_19 = dout_k2r_0[24*19 +: 24];
    wire [23:0] dout_k2r_0_20 = dout_k2r_0[24*20 +: 24];
    wire [23:0] dout_k2r_0_21 = dout_k2r_0[24*21 +: 24];
    wire [23:0] dout_k2r_0_22 = dout_k2r_0[24*22 +: 24];
    wire [23:0] dout_k2r_0_23 = dout_k2r_0[24*23 +: 24];
    wire [23:0] dout_k2r_0_24 = dout_k2r_0[24*24 +: 24];
    wire [23:0] dout_k2r_0_25 = dout_k2r_0[24*25 +: 24];
    wire [23:0] dout_k2r_0_26 = dout_k2r_0[24*26 +: 24];
    wire [23:0] dout_k2r_0_27 = dout_k2r_0[24*27 +: 24];
    wire [23:0] dout_k2r_0_28 = dout_k2r_0[24*28 +: 24];
    wire [23:0] dout_k2r_0_29 = dout_k2r_0[24*29 +: 24];
    wire [23:0] dout_k2r_0_30 = dout_k2r_0[24*30 +: 24];
    wire [23:0] dout_k2r_0_31 = dout_k2r_0[24*31 +: 24];
    wire ready_to_upstream_k2r_0;
    kernel_2x2_reconstructor #(
        .DATA_WIDTH(24),
        .LINE_WIDTH(3)
    ) uut_k2r_0 (
        .clk(clk), .rstn(rstn),
        
        .clear_reset_kernel(1'b0),
        
        .ready_from_downstream(1'b1),
        .valid_in(valid_in),
        .din(din_comp),
        
        .ready_to_upstream(ready_to_upstream_k2r_0),
        .valid_out(valid_out_k2r_0),
        .dout(dout_k2r_0)
    );
    
    wire valid_out_mac;
    wire [24*8*9-1:0] dout_mac;
    wire [23:0] dout_mac_0 = dout_mac[24*0 +: 24];
    wire [23:0] dout_mac_1 = dout_mac[24*1 +: 24];
    wire [23:0] dout_mac_2 = dout_mac[24*2 +: 24];
    wire [23:0] dout_mac_3 = dout_mac[24*3 +: 24];
    wire [23:0] dout_mac_4 = dout_mac[24*4 +: 24];
    wire [23:0] dout_mac_5 = dout_mac[24*5 +: 24];
    wire [23:0] dout_mac_6 = dout_mac[24*6 +: 24];
    wire [23:0] dout_mac_7 = dout_mac[24*7 +: 24];
    wire [23:0] dout_mac_8 = dout_mac[24*8 +: 24];
    wire [23:0] dout_mac_9 = dout_mac[24*9 +: 24];
    wire [23:0] dout_mac_10 = dout_mac[24*10 +: 24];
    wire [23:0] dout_mac_11 = dout_mac[24*11 +: 24];
    wire [23:0] dout_mac_12 = dout_mac[24*12 +: 24];
    wire [23:0] dout_mac_13 = dout_mac[24*13 +: 24];
    wire [23:0] dout_mac_14 = dout_mac[24*14 +: 24];
    wire [23:0] dout_mac_15 = dout_mac[24*15 +: 24];
    wire [23:0] dout_mac_16 = dout_mac[24*16 +: 24];
    wire [23:0] dout_mac_17 = dout_mac[24*17 +: 24];
    wire [23:0] dout_mac_18 = dout_mac[24*18 +: 24];
    wire [23:0] dout_mac_19 = dout_mac[24*19 +: 24];
    wire [23:0] dout_mac_20 = dout_mac[24*20 +: 24];
    wire [23:0] dout_mac_21 = dout_mac[24*21 +: 24];
    wire [23:0] dout_mac_22 = dout_mac[24*22 +: 24];
    wire [23:0] dout_mac_23 = dout_mac[24*23 +: 24];
    wire [23:0] dout_mac_24 = dout_mac[24*24 +: 24];
    wire [23:0] dout_mac_25 = dout_mac[24*25 +: 24];
    wire [23:0] dout_mac_26 = dout_mac[24*26 +: 24];
    wire [23:0] dout_mac_27 = dout_mac[24*27 +: 24];
    wire [23:0] dout_mac_28 = dout_mac[24*28 +: 24];
    wire [23:0] dout_mac_29 = dout_mac[24*29 +: 24];
    wire [23:0] dout_mac_30 = dout_mac[24*30 +: 24];
    wire [23:0] dout_mac_31 = dout_mac[24*31 +: 24];
    wire [23:0] dout_mac_32 = dout_mac[24*32 +: 24];
    wire [23:0] dout_mac_33 = dout_mac[24*33 +: 24];
    wire [23:0] dout_mac_34 = dout_mac[24*34 +: 24];
    wire [23:0] dout_mac_35 = dout_mac[24*35 +: 24];
    wire [23:0] dout_mac_36 = dout_mac[24*36 +: 24];
    wire [23:0] dout_mac_37 = dout_mac[24*37 +: 24];
    wire [23:0] dout_mac_38 = dout_mac[24*38 +: 24];
    wire [23:0] dout_mac_39 = dout_mac[24*39 +: 24];
    wire [23:0] dout_mac_40 = dout_mac[24*40 +: 24];
    wire [23:0] dout_mac_41 = dout_mac[24*41 +: 24];
    wire [23:0] dout_mac_42 = dout_mac[24*42 +: 24];
    wire [23:0] dout_mac_43 = dout_mac[24*43 +: 24];
    wire [23:0] dout_mac_44 = dout_mac[24*44 +: 24];
    wire [23:0] dout_mac_45 = dout_mac[24*45 +: 24];
    wire [23:0] dout_mac_46 = dout_mac[24*46 +: 24];
    wire [23:0] dout_mac_47 = dout_mac[24*47 +: 24];
    wire [23:0] dout_mac_48 = dout_mac[24*48 +: 24];
    wire [23:0] dout_mac_49 = dout_mac[24*49 +: 24];
    wire [23:0] dout_mac_50 = dout_mac[24*50 +: 24];
    wire [23:0] dout_mac_51 = dout_mac[24*51 +: 24];
    wire [23:0] dout_mac_52 = dout_mac[24*52 +: 24];
    wire [23:0] dout_mac_53 = dout_mac[24*53 +: 24];
    wire [23:0] dout_mac_54 = dout_mac[24*54 +: 24];
    wire [23:0] dout_mac_55 = dout_mac[24*55 +: 24];
    wire [23:0] dout_mac_56 = dout_mac[24*56 +: 24];
    wire [23:0] dout_mac_57 = dout_mac[24*57 +: 24];
    wire [23:0] dout_mac_58 = dout_mac[24*58 +: 24];
    wire [23:0] dout_mac_59 = dout_mac[24*59 +: 24];
    wire [23:0] dout_mac_60 = dout_mac[24*60 +: 24];
    wire [23:0] dout_mac_61 = dout_mac[24*61 +: 24];
    wire [23:0] dout_mac_62 = dout_mac[24*62 +: 24];
    wire [23:0] dout_mac_63 = dout_mac[24*63 +: 24];
    wire [23:0] dout_mac_64 = dout_mac[24*64 +: 24];
    wire [23:0] dout_mac_65 = dout_mac[24*65 +: 24];
    wire [23:0] dout_mac_66 = dout_mac[24*66 +: 24];
    wire [23:0] dout_mac_67 = dout_mac[24*67 +: 24];
    wire [23:0] dout_mac_68 = dout_mac[24*68 +: 24];
    wire [23:0] dout_mac_69 = dout_mac[24*69 +: 24];
    wire [23:0] dout_mac_70 = dout_mac[24*70 +: 24];
    wire [23:0] dout_mac_71 = dout_mac[24*71 +: 24];
    relayout_mac_kernel #(
        .DATA_WIDTH(24)
    ) uut_rmk (
        .valid_in(valid_out_k3r_0),
        .din(dout_k3r_0),
        
        .valid_out(valid_out_mac),
        .dout(dout_mac)
    );
    
    wire valid_out_comp;
    wire [24*8*4-1:0] dout_comp;
    wire [23:0] dout_comp_0 = dout_comp[24*0 +: 24];
    wire [23:0] dout_comp_1 = dout_comp[24*1 +: 24];
    wire [23:0] dout_comp_2 = dout_comp[24*2 +: 24];
    wire [23:0] dout_comp_3 = dout_comp[24*3 +: 24];
    wire [23:0] dout_comp_4 = dout_comp[24*4 +: 24];
    wire [23:0] dout_comp_5 = dout_comp[24*5 +: 24];
    wire [23:0] dout_comp_6 = dout_comp[24*6 +: 24];
    wire [23:0] dout_comp_7 = dout_comp[24*7 +: 24];
    wire [23:0] dout_comp_8 = dout_comp[24*8 +: 24];
    wire [23:0] dout_comp_9 = dout_comp[24*9 +: 24];
    wire [23:0] dout_comp_10 = dout_comp[24*10 +: 24];
    wire [23:0] dout_comp_11 = dout_comp[24*11 +: 24];
    wire [23:0] dout_comp_12 = dout_comp[24*12 +: 24];
    wire [23:0] dout_comp_13 = dout_comp[24*13 +: 24];
    wire [23:0] dout_comp_14 = dout_comp[24*14 +: 24];
    wire [23:0] dout_comp_15 = dout_comp[24*15 +: 24];
    wire [23:0] dout_comp_16 = dout_comp[24*16 +: 24];
    wire [23:0] dout_comp_17 = dout_comp[24*17 +: 24];
    wire [23:0] dout_comp_18 = dout_comp[24*18 +: 24];
    wire [23:0] dout_comp_19 = dout_comp[24*19 +: 24];
    wire [23:0] dout_comp_20 = dout_comp[24*20 +: 24];
    wire [23:0] dout_comp_21 = dout_comp[24*21 +: 24];
    wire [23:0] dout_comp_22 = dout_comp[24*22 +: 24];
    wire [23:0] dout_comp_23 = dout_comp[24*23 +: 24];
    wire [23:0] dout_comp_24 = dout_comp[24*24 +: 24];
    wire [23:0] dout_comp_25 = dout_comp[24*25 +: 24];
    wire [23:0] dout_comp_26 = dout_comp[24*26 +: 24];
    wire [23:0] dout_comp_27 = dout_comp[24*27 +: 24];
    wire [23:0] dout_comp_28 = dout_comp[24*28 +: 24];
    wire [23:0] dout_comp_29 = dout_comp[24*29 +: 24];
    wire [23:0] dout_comp_30 = dout_comp[24*30 +: 24];
    wire [23:0] dout_comp_31 = dout_comp[24*31 +: 24];
    relayout_comparator_kernel #(
        .DATA_WIDTH(24)
    ) uut_rck (
        .valid_in(valid_out_k2r_0),
        .din(dout_k2r_0),
        
        .valid_out(valid_out_comp),
        .dout(dout_comp)
    );
    
    
    task insert_data (
        input [23:0] val_ch0, val_ch1, val_ch2, val_ch3, 
        val_ch4, val_ch5, val_ch6, val_ch7
    );
        begin
            @(negedge clk)
            dinch0 = val_ch0;
            dinch1 = val_ch1;
            dinch2 = val_ch2;
            dinch3 = val_ch3;
            dinch4 = val_ch4;
            dinch5 = val_ch5;
            dinch6 = val_ch6;
            dinch7 = val_ch7;
    
            valid_in = 1'b1;
            @(negedge clk);
            valid_in = 1'b0;
        end
    
    endtask
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rstn = 0;
        valid_in = 1'b0;

        dinch0 = 24'd0;
        dinch1 = 24'd0;
        dinch2 = 24'd0;
        dinch3 = 24'd0;
        dinch4 = 24'd0;
        dinch5 = 24'd0;
        dinch6 = 24'd0;
        dinch7 = 24'd0;
        
        #10
        
        rstn = 1;
        
        @(posedge clk);
        
        insert_data( 24'd10, 24'd20, 24'd30, 24'd40, 24'd50, 24'd60, 24'd70, 24'd80 );
        insert_data( 24'd21, 24'd31, 24'd41, 24'd51, 24'd61, 24'd71, 24'd81, 24'd91 );
        insert_data( 24'd31, 24'd41, 24'd51, 24'd61, 24'd71, 24'd81, 24'd91, 24'd101 );
        insert_data( 24'd41, 24'd51, 24'd61, 24'd71, 24'd81, 24'd91, 24'd101, 24'd111 );
        insert_data( 24'd51, 24'd61, 24'd71, 24'd81, 24'd91, 24'd101, 24'd111, 24'd121 );
        insert_data( 24'd61, 24'd71, 24'd81, 24'd91, 24'd101, 24'd111, 24'd121, 24'd131 );
        insert_data( 24'd71, 24'd81, 24'd91, 24'd101, 24'd111, 24'd121, 24'd131, 24'd141 );
        insert_data( 24'd81, 24'd91, 24'd101, 24'd111, 24'd121, 24'd131, 24'd141, 24'd151 );
        insert_data( 24'd91, 24'd101, 24'd111, 24'd121, 24'd131, 24'd141, 24'd151, 24'd161 );
        insert_data( 24'd101, 24'd111, 24'd121, 24'd131, 24'd141, 24'd151, 24'd161, 24'd171 );
        
        $finish;
    end

endmodule

`timescale 1ns / 1ps

module imitate_stream_pixels #(
    parameter integer ADDR_W       = 16,
    parameter integer FRAME_PIXELS = 784,
    parameter integer FRAME_NUM    = 8
)(
    input wire clk,
    input wire rstn,

    input wire ready_in,

    output reg        valid_out,
    output wire [7:0] pixel_out,

    // debug:
    // jumlah pixel yang sudah diterima pada frame sekarang
    output reg [ADDR_W-1:0] px_cnt
);

    // ============================================================
    // Internal image memory
    //
    // ADDR_W = 16
    // DEPTH  = 65536 pixel
    //
    // img_buff.mem boleh berisi:
    // 2000 data
    // 3000 data
    // 6272 data
    // dst.
    //
    // File ini hanya digunakan untuk simulasi.
    // ============================================================

    localparam integer MEM_DEPTH = (1 << ADDR_W);

    reg [7:0] img_mem [0:MEM_DEPTH-1];


    // ============================================================
    // Load seluruh isi img_buff.mem
    // ============================================================

    initial begin
        $readmemh("img_test.mem", img_mem);
    end


    // ============================================================
    // State machine
    // ============================================================

    localparam [1:0]
        STATE_SEND            = 2'd0,
        STATE_WAIT_READY_LOW  = 2'd1,
        STATE_WAIT_READY_HIGH = 2'd2,
        STATE_DONE            = 2'd3;

    reg [1:0] state;


    // ============================================================
    // Global address ke img_mem
    //
    // Address ini TIDAK kembali ke 0 setiap pergantian frame.
    //
    // Contoh:
    //
    // frame 0 : address    0 -  783
    // frame 1 : address  784 - 1567
    // frame 2 : address 1568 - 2351
    // dst.
    // ============================================================

    reg [ADDR_W-1:0] img_addr;


    // ============================================================
    // Frame counter
    // ============================================================

    reg [ADDR_W-1:0] frame_cnt;


    // ============================================================
    // Pixel output
    //
    // Data benar-benar berasal dari img_buff.mem
    // ============================================================

    assign pixel_out = img_mem[img_addr];


    // ============================================================
    // Handshake
    //
    // Pixel hanya dianggap dikirim jika:
    //
    // valid_out == 1
    // ready_in  == 1
    // ============================================================

    wire pixel_fire;

    assign pixel_fire = valid_out && ready_in;


    // ============================================================
    // Main controller
    // ============================================================

    always @(posedge clk) begin

        if (!rstn) begin

            state <= STATE_SEND;

            valid_out <= 1'b1;

            px_cnt <= {ADDR_W{1'b0}};

            frame_cnt <= {ADDR_W{1'b0}};

            img_addr <= {ADDR_W{1'b0}};

        end
        else begin

            case (state)

                // =================================================
                // SEND ONE FRAME
                // =================================================

                STATE_SEND: begin

                    valid_out <= 1'b1;

                    if (pixel_fire) begin

                        // =========================================
                        // Pixel terakhir pada frame sekarang
                        //
                        // px_cnt:
                        //
                        // 0   = pixel pertama
                        // ...
                        // 783 = pixel ke-784
                        // =========================================

                        if (px_cnt == FRAME_PIXELS-1) begin

                            /*
                             * Pixel ke-784 sudah benar-benar
                             * diterima downstream.
                             *
                             * Untuk mempermudah debug waveform:
                             */
                            px_cnt <= FRAME_PIXELS;

                            /*
                             * Stop mengirim data.
                             */
                            valid_out <= 1'b0;


                            // =====================================
                            // Sudah frame terakhir
                            // =====================================

                            if (frame_cnt == FRAME_NUM-1) begin

                                state <= STATE_DONE;

                            end


                            // =====================================
                            // Masih ada frame berikutnya
                            // =====================================

                            else begin

                                state <= STATE_WAIT_READY_LOW;

                            end

                        end


                        // =========================================
                        // Masih di dalam frame
                        // =========================================

                        else begin

                            px_cnt <= px_cnt + 1'b1;

                            /*
                             * Address memory hanya bergerak
                             * ketika data benar-benar accepted.
                             */
                            img_addr <= img_addr + 1'b1;

                        end

                    end

                end


                // =================================================
                // WAIT READY LOW
                //
                // Setelah 784 pixel:
                //
                // wr_cnt_gff = 784
                //
                // FCM combinational membuat:
                //
                // ready_in = 0
                //
                // Tunggu kejadian tersebut.
                // =================================================

                STATE_WAIT_READY_LOW: begin

                    valid_out <= 1'b0;

                    if (!ready_in) begin

                        state <= STATE_WAIT_READY_HIGH;

                    end

                end


                // =================================================
                // WAIT READY HIGH
                //
                // CNN menyelesaikan seluruh frame.
                //
                // Setelah global flush:
                //
                // wr_cnt_gff = 0
                // ready_in   = 1
                //
                // kemudian kita mulai frame berikutnya.
                // =================================================

                STATE_WAIT_READY_HIGH: begin

                    valid_out <= 1'b0;

                    if (ready_in) begin

                        // -----------------------------------------
                        // pindah ke frame berikutnya
                        // -----------------------------------------

                        frame_cnt <= frame_cnt + 1'b1;


                        // -----------------------------------------
                        // counter pixel frame kembali ke 0
                        // -----------------------------------------

                        px_cnt <= {ADDR_W{1'b0}};


                        // -----------------------------------------
                        // Saat ini img_addr masih berada pada
                        // pixel terakhir frame sebelumnya.
                        //
                        // Contoh:
                        //
                        // frame 0 terakhir:
                        // img_addr = 783
                        //
                        // frame 1 pertama:
                        // img_addr = 784
                        //
                        // Maka cukup +1.
                        // -----------------------------------------

                        img_addr <= img_addr + 1'b1;


                        // -----------------------------------------
                        // aktifkan stream frame baru
                        // -----------------------------------------

                        valid_out <= 1'b1;

                        state <= STATE_SEND;

                    end

                end


                // =================================================
                // DONE
                //
                // Semua FRAME_NUM frame sudah dikirim.
                // =================================================

                STATE_DONE: begin

                    valid_out <= 1'b0;

                end


                // =================================================
                // DEFAULT
                // =================================================

                default: begin

                    valid_out <= 1'b0;

                    state <= STATE_DONE;

                end

            endcase

        end

    end

endmodule
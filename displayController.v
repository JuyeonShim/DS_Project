module displayController (input clk,
                          input nrst,
                          input[1:0]display,       // StAy, PLAy, PASS, FAIL
                          output reg[7:0] seg_com,
                          output reg[6:0] seg7);
    reg[6:0] segments[0:7];
    reg[2:0] cnt = 0;
    always @(posedge clk) begin
        cnt     <= cnt + 1;
        seg_com <= 8'b1111_1111 ^ (2 ** cnt);
        seg7    <= segments[7-cnt];
    end
    
    always @(*) begin
        if (!nrst)begin // ---rESEt
            segments[0] <= 7'b000_0001;
            segments[1] <= 7'b000_0001;
            segments[2] <= 7'b000_0001;
            segments[3] <= 7'b000_0101;
            segments[4] <= 7'b100_1111;
            segments[5] <= 7'b101_1011;
            segments[6] <= 7'b100_1111;
            segments[7] <= 7'b000_1111;
        end
        else begin
            case(display)
                2'd0:begin // ----StAy
                    segments[0] <= 7'b000_0001;
                    segments[1] <= 7'b000_0001;
                    segments[2] <= 7'b000_0001;
                    segments[3] <= 7'b000_0001;
                    segments[4] <= 7'b101_1011;
                    segments[5] <= 7'b000_1111;
                    segments[6] <= 7'b111_0111;
                    segments[7] <= 7'b011_0011;
                end
                2'd1:begin // ----PLAy
                    segments[0] <= 7'b000_0001;
                    segments[1] <= 7'b000_0001;
                    segments[2] <= 7'b000_0001;
                    segments[3] <= 7'b000_0001;
                    segments[4] <= 7'b110_0111;
                    segments[5] <= 7'b000_1110;
                    segments[6] <= 7'b111_0111;
                    segments[7] <= 7'b011_0011;
                end
                2'd2:begin // ----PASS
                    segments[0] <= 7'b000_0001;
                    segments[1] <= 7'b000_0001;
                    segments[2] <= 7'b000_0001;
                    segments[3] <= 7'b000_0001;
                    segments[4] <= 7'b110_0111;
                    segments[5] <= 7'b111_0111;
                    segments[6] <= 7'b101_1011;
                    segments[7] <= 7'b101_1011;
                end
                2'd3:begin // ----FAIL
                    segments[0] <= 7'b000_0001;
                    segments[1] <= 7'b000_0001;
                    segments[2] <= 7'b000_0001;
                    segments[3] <= 7'b000_0001;
                    segments[4] <= 7'b100_0111;
                    segments[5] <= 7'b111_0111;
                    segments[6] <= 7'b000_0110;
                    segments[7] <= 7'b000_1110;
                end
            endcase
        end
    end
endmodule

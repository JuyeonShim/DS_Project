module mainController #(parameter FRQ = 1_000_000) // 1MHz
                       (input clk,
                        input[7:0] key,
                        input nrst,
                        output[7:0] seg_com,
                        output[6:0] seg7,
                        output piezo_wire);
    reg[2:0] state   = 0;
    reg[2:0] octave  = 0; // do, re, me, pa, so, ra, si, do
    reg piezo_nOn    = 1;
    reg[1:0] display = 0; // StAy, PLAy, PASS, FAIL
    reg[29:0] cnt    = 0;
    reg[29:0] tmp_cnt    = 0;

    piezoController #(.FRQ(FRQ)) piezoController01(.octave(octave), .nOn(piezo_nOn), .clk(clk), .piezo_wire(piezo_wire));
    displayController displayController01(.clk(clk), .nrst(nrst), .display(display), .seg_com(seg_com), .seg7(seg7));

    always @(posedge clk) begin
        if (nrst == 0) begin
            cnt       <= 0;
            tmp_cnt   <= 0;
            state     <= 0;
            octave    <= 0;
            piezo_nOn <= 1;
            display   <= 0;
        end
        else begin
            case(state)
                3'd0: begin
                    cnt <= cnt+1;
                    piezo_nOn <= 1;
                    display <= 0;
                    if (key[4] == 1) begin
                        state <= 1;
                    end
                end
                3'd1: begin
                    octave <= cnt % 8;
                    piezo_nOn <= 0;
                    tmp_cnt <= cnt;
                    state <= 2;
                    display <=1;
                end
                3'd2:begin
                    cnt <= cnt+1;
                    if((cnt-tmp_cnt) > FRQ)begin
                        state <=3;
                    end
                end
                3'd3: begin
                    piezo_nOn <= 1;
                    cnt <= cnt+1;
                    if(key != 0)begin
                        state <= 4;
                    end
                end
                3'd4: begin
                    tmp_cnt <= cnt;
                    if(key[octave] == 1) begin
                        display <=2;
                        state <=5;
                    end
                    else begin
                        display <=3;
                        state <=5;
                    end
                end
                3'd5:begin
                    cnt <= cnt+1;
                    if((cnt-tmp_cnt) > FRQ)begin
                        state <=1;
                    end
                end
            endcase
        end
    end
    
endmodule

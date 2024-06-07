module piezoController #(parameter FRQ = 1_000_000)
                        (input[2:0] octave,
                         input nOn,
                         input clk,
                         output reg piezo_wire = 0);
    /* octave (Hz)
     do     re      mi      pa      so      la      si      do
     262    294     330     349     392     440     494     523
     */
    
    reg[29:0] cnt = 0;
    
    integer match_cnt [0:7];
    
    initial begin
        match_cnt[0] = FRQ / 262 / 2;
        match_cnt[1] = FRQ / 294 / 2;
        match_cnt[2] = FRQ / 330 / 2;
        match_cnt[3] = FRQ / 349 / 2;
        match_cnt[4] = FRQ / 392 / 2;
        match_cnt[5] = FRQ / 440 / 2;
        match_cnt[6] = FRQ / 494 / 2;
        match_cnt[7] = FRQ / 523 / 2;
    end
    
    always@(posedge clk)begin
        if (nOn == 0)begin
            if (match_cnt[octave] < cnt) begin
                piezo_wire <= ~piezo_wire;
                cnt        <= 0;
            end
            else begin
                cnt <= cnt+1;
            end
        end
    end
    
endmodule

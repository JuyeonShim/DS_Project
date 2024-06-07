`timescale 100ns/10ns
module tb_mainController;
    reg clk;
    reg[7:0] key;
    reg nrst;
    wire[7:0] seg_com;
    wire[6:0] seg7;
    wire piezo_wire;
mainController #(.FRQ(1_000_000))mainController01(.clk(clk), .key(key), .nrst(nrst), .seg_com(seg_com), .seg7(seg7), .piezo_wire(piezo_wire));

initial begin
    clk <=0;
    key <= 8'b0000_0000;
    nrst <= 1;
    #2000
    nrst <= 0;
    #2000
    nrst <= 1;
    #10000000
    key <= 8'b001_0101;
    #10000000
    key <= 8'b010_0001;
    #5000000
    $stop;
end

always @(*)begin
    #5
    clk <= ~clk;
end
endmodule

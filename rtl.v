//======================================================
// DAY 8
// 4-BIT REGISTER WITH ENABLE
// SYNCHRONOUS + ASYNCHRONOUS RESET
//======================================================


//======================================================
// 1. D FLIP-FLOP
//    SYNCHRONOUS RESET + ENABLE
//======================================================

module dff_sync_reset(
    input clk,
    input reset,
    input en,
    input d,
    output reg q
);

    always @(posedge clk) begin

        if (reset)
            q <= 1'b0;

        else if (en)
            q <= d;

        else
            q <= q;

    end

endmodule


//======================================================
// 2. D FLIP-FLOP
//    ASYNCHRONOUS RESET + ENABLE
//======================================================

module dff_async_reset(
    input clk,
    input reset,
    input en,
    input d,
    output reg q
);

    always @(posedge clk or posedge reset) begin

        if (reset)
            q <= 1'b0;

        else if (en)
            q <= d;

        else
            q <= q;

    end

endmodule


//======================================================
// 3. 4-BIT SYNCHRONOUS REGISTER
//
//    Four DFFs are connected in parallel.
//======================================================

module register_4bit_sync(
    input clk,
    input reset,
    input en,
    input [3:0] d,
    output [3:0] q
);

    // Bit 0
    dff_sync_reset DFF0(
        .clk(clk),
        .reset(reset),
        .en(en),
        .d(d[0]),
        .q(q[0])
    );

    // Bit 1
    dff_sync_reset DFF1(
        .clk(clk),
        .reset(reset),
        .en(en),
        .d(d[1]),
        .q(q[1])
    );

    // Bit 2
    dff_sync_reset DFF2(
        .clk(clk),
        .reset(reset),
        .en(en),
        .d(d[2]),
        .q(q[2])
    );

    // Bit 3
    dff_sync_reset DFF3(
        .clk(clk),
        .reset(reset),
        .en(en),
        .d(d[3]),
        .q(q[3])
    );

endmodule


//======================================================
// 4. 4-BIT ASYNCHRONOUS REGISTER
//
//    Four DFFs are connected in parallel.
//======================================================

module register_4bit_async(
    input clk,
    input reset,
    input en,
    input [3:0] d,
    output [3:0] q
);

    // Bit 0
    dff_async_reset DFF0(
        .clk(clk),
        .reset(reset),
        .en(en),
        .d(d[0]),
        .q(q[0])
    );

    // Bit 1
    dff_async_reset DFF1(
        .clk(clk),
        .reset(reset),
        .en(en),
        .d(d[1]),
        .q(q[1])
    );

    // Bit 2
    dff_async_reset DFF2(
        .clk(clk),
        .reset(reset),
        .en(en),
        .d(d[2]),
        .q(q[2])
    );

    // Bit 3
    dff_async_reset DFF3(
        .clk(clk),
        .reset(reset),
        .en(en),
        .d(d[3]),
        .q(q[3])
    );

endmodule


//======================================================
// 5. TOP MODULE
//    BOTH SYNCHRONOUS AND ASYNCHRONOUS REGISTERS
//======================================================

module register_4bit_top(

    input clk,

    input reset_sync,
    input reset_async,

    input en,

    input [3:0] d,

    output [3:0] q_sync,
    output [3:0] q_async

);

    //==================================================
    // SYNCHRONOUS REGISTER
    //==================================================

    register_4bit_sync SYNC_REG(

        .clk(clk),
        .reset(reset_sync),
        .en(en),
        .d(d),
        .q(q_sync)

    );


    //==================================================
    // ASYNCHRONOUS REGISTER
    //==================================================

    register_4bit_async ASYNC_REG(

        .clk(clk),
        .reset(reset_async),
        .en(en),
        .d(d),
        .q(q_async)

    );

endmodule

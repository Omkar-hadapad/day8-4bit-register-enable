//======================================================
// DAY 8 TESTBENCH
// 4-BIT REGISTER
// SYNCHRONOUS + ASYNCHRONOUS RESET
//======================================================

module day8_tb;

    //==================================================
    // INPUTS
    //==================================================

    reg clk;

    reg reset_sync;
    reg reset_async;

    reg en;

    reg [3:0] d;


    //==================================================
    // OUTPUTS
    //==================================================

    wire [3:0] q_sync;
    wire [3:0] q_async;


    //==================================================
    // DUT
    //==================================================

    register_4bit_top DUT(

        .clk(clk),

        .reset_sync(reset_sync),
        .reset_async(reset_async),

        .en(en),

        .d(d),

        .q_sync(q_sync),
        .q_async(q_async)

    );


    //==================================================
    // CLOCK
    // 10 ns PERIOD
    //==================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    //==================================================
    // TEST
    //==================================================

    initial begin

        //================================================
        // INITIAL VALUES
        //================================================

        reset_sync  = 1'b0;
        reset_async = 1'b0;

        en = 1'b0;
        d  = 4'b0000;


        //================================================
        // INITIAL RESET
        //================================================

        #2;

        reset_sync  = 1'b1;
        reset_async = 1'b1;

        #3;

        reset_sync  = 1'b0;
        reset_async = 1'b0;


        //================================================
        // LOAD 1010
        //================================================

        en = 1'b1;
        d  = 4'b1010;

        #10;


        $display("--------------------------------------");
        $display("LOAD TEST");
        $display("D      = %b", d);
        $display("Q_SYNC = %b", q_sync);
        $display("Q_ASYNC= %b", q_async);
        $display("--------------------------------------");


        //================================================
        // HOLD TEST
        //================================================

        en = 1'b0;
        d  = 4'b0101;

        #10;


        $display("--------------------------------------");
        $display("HOLD TEST");
        $display("D      = %b", d);
        $display("Q_SYNC = %b", q_sync);
        $display("Q_ASYNC= %b", q_async);
        $display("--------------------------------------");


        //================================================
        // LOAD NEW DATA
        //================================================

        en = 1'b1;
        d  = 4'b1100;

        #10;


        $display("--------------------------------------");
        $display("SECOND LOAD TEST");
        $display("D      = %b", d);
        $display("Q_SYNC = %b", q_sync);
        $display("Q_ASYNC= %b", q_async);
        $display("--------------------------------------");


        //================================================
        // ASYNCHRONOUS RESET TEST
        //================================================

        en = 1'b0;

        #2;

        $display("======================================");
        $display("ASYNC RESET TEST");
        $display("======================================");

        reset_async = 1'b1;

        #1;

        $display("Reset asserted WITHOUT clock edge");
        $display("TIME     = %0t", $time);
        $display("Q_ASYNC  = %b", q_async);

        reset_async = 1'b0;


        //================================================
        // LOAD AGAIN
        //================================================

        en = 1'b1;
        d  = 4'b0110;

        #10;


        //================================================
        // SYNCHRONOUS RESET TEST
        //================================================

        en = 1'b0;

        reset_sync = 1'b1;

        #2;

        $display("======================================");
        $display("SYNC RESET TEST");
        $display("======================================");

        $display("Before clock edge:");
        $display("TIME     = %0t", $time);
        $display("Q_SYNC   = %b", q_sync);

        #3;

        $display("After clock edge:");
        $display("TIME     = %0t", $time);
        $display("Q_SYNC   = %b", q_sync);

        reset_sync = 1'b0;


        //================================================
        // END
        //================================================

        #10;

        $display("======================================");
        $display("DAY 8 TEST COMPLETE");
        $display("======================================");

        $finish;

    end


    //==================================================
    // MONITOR
    //==================================================

    initial begin

        $monitor(
            "TIME=%0t CLK=%b SYNC_RST=%b ASYNC_RST=%b EN=%b D=%b Q_SYNC=%b Q_ASYNC=%b",
            $time,
            clk,
            reset_sync,
            reset_async,
            en,
            d,
            q_sync,
            q_async
        );

    end


    //==================================================
    // WAVEFORM
    //==================================================

    initial begin

        $dumpfile("day8.vcd");

        $dumpvars(0, day8_tb);

    end

endmodule

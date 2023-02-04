// Code your testbench here
// or browse Examples
`include "axi_txn.svh"

module test_bench();
    logic clk, rst;
    int no_of_wr_txns = 10;
  	axi_txn txn;

    // Instantiation
  	axi_wr_addr_intf m_intf(clk, rst);
    sample_dut sample_dut1(.axi_wr_addr_intf1(m_intf), .*);
    

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

    //Clock and reset generation
    initial begin
        clk = 1;
        forever #500 clk = ~clk;
    end

    initial begin
        rst = 1;
        repeat (1) @(posedge clk);
        rst = 0;
        repeat (4) @(posedge clk);
        rst = 1;
    end

    //TB functional code
    initial begin //{

        //Initialize signals
        init_signals();

        //wait_for_reset
        wait(!m_intf.rst);
        @(posedge m_intf.rst);

        //Drive txns
        for(int i=0;i<10;i++) begin
            txn = new();
            txn.randomize();
            drive_wr_addr(txn);
        end

        $finish("Completed sending all txns");
    end //}

    task drive_wr_addr(axi_txn txn);
        while( !m_intf.awready) @(posedge m_intf.clk);
        m_intf.awid <= txn.id;
        m_intf.awlen <= txn.length;
        m_intf.awaddr <= txn.addr;
        m_intf.awvalid <= 1'b1;
        @(posedge m_intf.clk);
        m_intf.awvalid <= 1'b0;

      	$display("drive_wr_addr: Send Write Txn. %s", txn.convert2string());
    endtask: drive_wr_addr

    task init_signals();
        m_intf.awvalid <= 1'b0;
    endtask: init_signals

endmodule: test_bench
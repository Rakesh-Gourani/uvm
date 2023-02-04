// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
`include "axi_txn.svh"
`include "axi_generator.svh"
`include "axi_wr_addr_driver.svh"

module test_bench();
    logic clk, rst;
    int no_of_wr_txns = 10;

    // Instantiation
  	axi_wr_addr_intf    m_intf(clk, rst);
    sample_dut          sample_dut1(.axi_wr_addr_intf1(m_intf), .*);
    axi_generator       gen;
    axi_wr_addr_driver  driver;

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
        mailbox mbox1 = new();
        gen           = new();
        driver        = new();

        //Connect generator and driver
        gen.mbox    = mbox1;
        driver.mbox = mbox1;
      	driver.m_intf = m_intf;

        gen.no_of_wr_txns = 10;
        driver.no_of_wr_txns = 10;

        fork
            driver.run();
            gen.run();
        join

        $finish("Completed sending all txns");
    end

endmodule: test_bench
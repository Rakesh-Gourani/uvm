class axi_wr_addr_driver;
    mailbox mbox;
    int no_of_wr_txns = 10;
    virtual axi_wr_addr_intf m_intf;
  	axi_txn txn;

  	function new();
        mbox = new();
    endfunction: new

    task init_signals();
        m_intf.awvalid <= 1'b0;
    endtask: init_signals

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
  
  virtual task run();

        init_signals();

        //wait_for_reset
        wait(!m_intf.rst);
        @(posedge m_intf.rst);
        
        //Drive txns
    for(int i=0;i<no_of_wr_txns;i++) begin
            mbox.get(txn);
            drive_wr_addr(txn);
        end

    endtask: run

endclass: axi_wr_addr_driver
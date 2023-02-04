class axi_txn;
    rand bit    [3:0]   id;
    rand bit    [3:0]   length;
    rand bit    [31:0]  addr;

function new();
    length = 0;
endfunction: new

constraint data_length {length <= 1;}

function void copy(axi_txn rhs);
    axi_txn l_rhs;

    if (!$cast(l_rhs, rhs)) begin
        $display("Copy: Error casting of rhs txn to AXI txn failed");
    end

    this.id = l_rhs.id;
    this.length = l_rhs.length;
    this.addr = l_rhs.addr;
endfunction: copy

function string convert2string();
    string rgt;
    $sformat(rgt, "id = %0h, addr = %0h, length = %0h", id, addr, length);
    return rgt;
endfunction: convert2string

endclass: axi_txn
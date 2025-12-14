interface riscv_if(input logic clk);
    
    logic        resetn;
    logic        mem_valid;
    logic        mem_instr;
    logic        mem_ready;
    logic [31:0] mem_addr;
    logic [31:0] mem_wdata;
    logic [3:0]  mem_wstrb;
    logic [31:0] mem_rdata;
    
    clocking driver_cb @(posedge clk);
        output resetn;
        output mem_ready;
        output mem_rdata;
        input  mem_valid;
        input  mem_instr;
        input  mem_addr;
        input  mem_wdata;
        input  mem_wstrb;
    endclocking
    
    clocking monitor_cb @(posedge clk);
        input resetn;
        input mem_valid;
        input mem_instr;
        input mem_ready;
        input mem_addr;
        input mem_wdata;
        input mem_wstrb;
        input mem_rdata;
    endclocking
    
    modport driver(clocking driver_cb);
    modport monitor(clocking monitor_cb);
    
endinterface

interface riscv_if(input logic clk);
    logic resetn;
    logic mem_valid;
    logic mem_instr;
    logic mem_ready;
    logic [31:0] mem_addr;
    logic [31:0] mem_wdata;
    logic [3:0] mem_wstrb;
    logic [31:0] mem_rdata;
endinterface

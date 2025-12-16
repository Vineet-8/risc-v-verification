`timescale 1ns/1ps

module top_uvm_tb;
    import uvm_pkg::*;
    import riscv_pkg::*;
    
    logic clk = 0;
    always #5 clk = ~clk;
    
    riscv_if vif(clk);
    
    picorv32 #(
        .ENABLE_COUNTERS(1),
        .ENABLE_REGS_16_31(1),
        .ENABLE_MUL(1),
        .ENABLE_DIV(1)
    ) dut (
        .clk(vif.clk), .resetn(vif.resetn),
        .mem_valid(vif.mem_valid), .mem_instr(vif.mem_instr),
        .mem_ready(vif.mem_ready), .mem_addr(vif.mem_addr),
        .mem_wdata(vif.mem_wdata), .mem_wstrb(vif.mem_wstrb),
        .mem_rdata(vif.mem_rdata),
        .mem_la_read(), .mem_la_write(), .mem_la_addr(),
        .mem_la_wdata(), .mem_la_wstrb(),
        .pcpi_valid(), .pcpi_insn(), .pcpi_rs1(), .pcpi_rs2(),
        .pcpi_wr(1'b0), .pcpi_rd(32'h0),
        .pcpi_wait(1'b0), .pcpi_ready(1'b0),
        .irq(32'h0), .eoi(), .trace_valid(), .trace_data()
    );
    
    logic [31:0] memory [0:4095];
    
    initial begin
        memory[0] = 32'h00500093; memory[1] = 32'h00A00113;
        memory[2] = 32'h002081B3; memory[3] = 32'h40110233;
        memory[4] = 32'h0020F2B3; memory[5] = 32'h0020E333;
        memory[6] = 32'h0020C3B3; memory[7] = 32'h02208433;
        memory[8] = 32'h0220C4B3; memory[9] = 32'h0000006F;
    end
    
    always @(posedge clk) begin
        vif.mem_ready <= 0;
        if (!vif.resetn) vif.mem_rdata <= 32'h0;
        else if (vif.mem_valid && !vif.mem_ready) begin
            if (|vif.mem_wstrb) begin
                if (vif.mem_wstrb[0]) memory[vif.mem_addr[13:2]][7:0] <= vif.mem_wdata[7:0];
                if (vif.mem_wstrb[1]) memory[vif.mem_addr[13:2]][15:8] <= vif.mem_wdata[15:8];
                if (vif.mem_wstrb[2]) memory[vif.mem_addr[13:2]][23:16] <= vif.mem_wdata[23:16];
                if (vif.mem_wstrb[3]) memory[vif.mem_addr[13:2]][31:24] <= vif.mem_wdata[31:24];
                vif.mem_ready <= 1;
            end else begin
                vif.mem_rdata <= memory[vif.mem_addr[13:2]];
                vif.mem_ready <= 1;
            end
        end
    end
    
    initial begin
        vif.resetn = 0;
        #100;
        vif.resetn = 1;
    end
    
    initial begin
        uvm_config_db#(virtual riscv_if)::set(null, "*", "vif", vif);
        run_test();
    end
    
    initial #500000 $finish;
endmodule

`timescale 1ns/1ps

module load_store_test;
    
    reg clk = 0;
    reg resetn = 0;
    
    wire        mem_valid;
    wire        mem_instr;
    reg         mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    reg  [31:0] mem_rdata;
    
    picorv32 #(
        .ENABLE_COUNTERS(1),
        .ENABLE_REGS_16_31(1)
    ) dut (
        .clk(clk),
        .resetn(resetn),
        .mem_valid(mem_valid),
        .mem_instr(mem_instr),
        .mem_ready(mem_ready),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb),
        .mem_rdata(mem_rdata),
        .mem_la_read(),
        .mem_la_write(),
        .mem_la_addr(),
        .mem_la_wdata(),
        .mem_la_wstrb(),
        .pcpi_valid(),
        .pcpi_insn(),
        .pcpi_rs1(),
        .pcpi_rs2(),
        .pcpi_wr(1'b0),
        .pcpi_rd(32'h0),
        .pcpi_wait(1'b0),
        .pcpi_ready(1'b0),
        .irq(32'h0),
        .eoi()
    );
    
    always #5 clk = ~clk;
    reg [31:0] memory [0:1023];
    integer pass_count = 0;
    integer store_count = 0;
    integer load_count = 0;
    
    initial begin
        // ADDI x1, x0, 255
        memory[0] = 32'h0FF00093;
        // ADDI x2, x0, 256 (address for store)
        memory[1] = 32'h10000113;
        // SW x1, 0(x2) - Store x1 to memory[64]
        memory[2] = 32'h00112023;
        // LW x3, 0(x2) - Load from memory[64] to x3
        memory[3] = 32'h00012183;
        // ADDI x4, x0, 42
        memory[4] = 32'h02A00213;
        // SW x4, 4(x2) - Store x4 to memory[65]
        memory[5] = 32'h00412223;
        // LW x5, 4(x2) - Load from memory[65] to x5
        memory[6] = 32'h00412283;
        // Loop
        memory[7] = 32'h0000006F;
    end
    
    always @(posedge clk) begin
        mem_ready <= 0;
        if (mem_valid && !mem_ready) begin
            if (|mem_wstrb) begin
                if (mem_wstrb[0]) memory[mem_addr >> 2][7:0]   <= mem_wdata[7:0];
                if (mem_wstrb[1]) memory[mem_addr >> 2][15:8]  <= mem_wdata[15:8];
                if (mem_wstrb[2]) memory[mem_addr >> 2][23:16] <= mem_wdata[23:16];
                if (mem_wstrb[3]) memory[mem_addr >> 2][31:24] <= mem_wdata[31:24];
                if (!mem_instr) store_count++;
            end else begin
                mem_rdata <= memory[mem_addr >> 2];
                if (!mem_instr) load_count++;
            end
            mem_ready <= 1;
        end
    end
    
    initial begin
        $dumpfile("load_store_test.vcd");
        $dumpvars(0, load_store_test);
        
        resetn = 0;
        #100;
        resetn = 1;
        #15000;
        
        $display("");
        $display("========================================");
        $display("  Load/Store Test Results");
        $display("========================================");
        
        $display("  Store operations: %0d", store_count);
        $display("  Load operations: %0d", load_count);
        
        check_result("Loaded value 1 (255)", dut.cpuregs[3], 255);
        check_result("Loaded value 2 (42)", dut.cpuregs[5], 42);
        
        $display("");
        $display("Results: %0d PASS, %0d FAIL", pass_count, pass_count > 1 ? 0 : 1);
        $display("========================================");
        
        if (pass_count == 2)
            $display("✓ ALL TESTS PASSED");
        
        $finish;
    end
    
    task check_result(input string name, input [31:0] actual, input [31:0] expected);
        if (actual == expected) begin
            $display("  ✓ %s: %0d PASS", name, actual);
            pass_count++;
        end else begin
            $display("  ✗ %s: %0d (expected %0d) FAIL", name, actual, expected);
        end
    endtask

endmodule

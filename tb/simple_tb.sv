`timescale 1ns/1ps

module simple_tb;
    
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
        .ENABLE_REGS_16_31(1),
        .ENABLE_REGS_DUALPORT(1),
        .ENABLE_MUL(1),
        .ENABLE_DIV(1)
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
    integer fail_count = 0;
    
    initial begin
        memory[0] = 32'h00500093;
        memory[1] = 32'h00A00113;
        memory[2] = 32'h002081B3;
        memory[3] = 32'h40110233;
        memory[4] = 32'h0020F2B3;
        memory[5] = 32'h0020E333;
        memory[6] = 32'h0020C3B3;
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
            end else begin
                mem_rdata <= memory[mem_addr >> 2];
            end
            mem_ready <= 1;
        end
    end
    
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, simple_tb);
        
        resetn = 0;
        #100;
        resetn = 1;
        
        #10000;
        
        $display("");
        $display("========================================");
        $display("  Simulation Completed Successfully!");
        $display("========================================");
        $display("");
        
        check_result("x1", dut.cpuregs[1], 5);
        check_result("x2", dut.cpuregs[2], 10);
        check_result("x3 (ADD)", dut.cpuregs[3], 15);
        check_result("x4 (SUB)", dut.cpuregs[4], 5);
        check_result("x5 (AND)", dut.cpuregs[5], 0);
        check_result("x6 (OR)", dut.cpuregs[6], 15);
        check_result("x7 (XOR)", dut.cpuregs[7], 15);
        
        $display("");
        $display("Results: %0d PASS, %0d FAIL", pass_count, fail_count);
        $display("========================================");
        $display("");
        
        if (fail_count == 0)
            $display("✓ ALL TESTS PASSED");
        else
            $display("✗ SOME TESTS FAILED");
        
        $finish;
    end
    
    task check_result(input string name, input [31:0] actual, input [31:0] expected);
        if (actual == expected) begin
            $display("  ✓ %s: %0d (expected %0d) PASS", name, actual, expected);
            pass_count = pass_count + 1;
        end else begin
            $display("  ✗ %s: %0d (expected %0d) FAIL", name, actual, expected);
            fail_count = fail_count + 1;
        end
    endtask

endmodule

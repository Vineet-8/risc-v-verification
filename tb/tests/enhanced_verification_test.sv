`timescale 1ns/1ps

module enhanced_verification_test;
    
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
    advanced_coverage cov();
    
    integer pass_count = 0;
    integer fail_count = 0;
    
    initial begin
        // Comprehensive test program
        memory[0]  = 32'h01400093;  // ADDI x1, x0, 20
        memory[1]  = 32'h00A00113;  // ADDI x2, x0, 10
        memory[2]  = 32'h002081B3;  // ADD  x3, x1, x2
        memory[3]  = 32'h40208233;  // SUB  x4, x1, x2
        memory[4]  = 32'h0020F2B3;  // AND  x5, x1, x2
        memory[5]  = 32'h0020E333;  // OR   x6, x1, x2
        memory[6]  = 32'h0020C3B3;  // XOR  x7, x1, x2
        memory[7]  = 32'h02208433;  // MUL  x8, x1, x2
        memory[8]  = 32'h0220C4B3;  // DIV  x9, x1, x2
        memory[9]  = 32'h10000513;  // ADDI x10, x0, 256
        memory[10] = 32'h00152023;  // SW   x1, 0(x10)
        memory[11] = 32'h00052583;  // LW   x11, 0(x10)
        memory[12] = 32'h00208663;  // BEQ  x1, x2, +12
        memory[13] = 32'h00100613;  // ADDI x12, x0, 1
        memory[14] = 32'h00C00693;  // ADDI x13, x0, 12
        memory[15] = 32'h0000006F;  // JAL  x0, 0
    end
    
    always @(posedge clk) begin
        mem_ready <= 0;
        if (mem_valid && !mem_ready) begin
            if (|mem_wstrb) begin
                if (mem_wstrb[0]) memory[mem_addr >> 2][7:0]   <= mem_wdata[7:0];
                if (mem_wstrb[1]) memory[mem_addr >> 2][15:8]  <= mem_wdata[15:8];
                if (mem_wstrb[2]) memory[mem_addr >> 2][23:16] <= mem_wdata[23:16];
                if (mem_wstrb[3]) memory[mem_addr >> 2][31:24] <= mem_wdata[31:24];
                cov.track_data_access(1);
            end else begin
                mem_rdata <= memory[mem_addr >> 2];
                if (mem_instr)
                    cov.track_instruction(mem_addr, memory[mem_addr >> 2]);
                else
                    cov.track_data_access(0);
            end
            mem_ready <= 1;
        end
    end
    
    initial begin
        $dumpfile("enhanced_test.vcd");
        $dumpvars(0, enhanced_verification_test);
        
        resetn = 0;
        #100;
        resetn = 1;
        
        #20000;
        
        $display("");
        $display("========================================");
        $display("  Enhanced Verification Test Results");
        $display("========================================");
        
        check_result("ADD (20+10)", dut.cpuregs[3], 30);
        check_result("SUB (20-10)", dut.cpuregs[4], 10);
        check_result("AND (20&10)", dut.cpuregs[5], 0);
        check_result("OR  (20|10)", dut.cpuregs[6], 30);
        check_result("XOR (20^10)", dut.cpuregs[7], 30);
        check_result("MUL (20*10)", dut.cpuregs[8], 200);
        check_result("DIV (20/10)", dut.cpuregs[9], 2);
        check_result("LW (loaded)", dut.cpuregs[11], 20);
        
        $display("");
        $display("Results: %0d PASS, %0d FAIL", pass_count, fail_count);
        $display("========================================");
        
        if (fail_count == 0)
            $display("✓ ALL TESTS PASSED");
        
        cov.print_report();
        
        $finish;
    end
    
    task check_result(input string name, input [31:0] actual, input [31:0] expected);
        if (actual == expected) begin
            $display("  ✓ %s: %0d PASS", name, actual);
            pass_count++;
        end else begin
            $display("  ✗ %s: %0d (expected %0d) FAIL", name, actual, expected);
            fail_count++;
        end
    endtask

endmodule

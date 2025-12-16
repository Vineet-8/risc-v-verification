package riscv_pkg;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    class mem_transaction extends uvm_sequence_item;
        rand bit [31:0] addr;
        rand bit [31:0] wdata;
        rand bit [31:0] rdata;
        rand bit [3:0]  wstrb;
        rand bit        is_write;
        bit             ready;
        bit             is_instr;
        
        constraint addr_range_c {
            addr inside {[0:32'h0FFF]};
            addr[1:0] == 2'b00;
        }
        
        constraint write_data_c {
            if (is_write) {
                wdata dist {[0:255] := 70, [256:65535] := 30};
                wstrb inside {4'b0001, 4'b0011, 4'b1111};
            } else {
                wstrb == 4'b0000;
            }
        }
        
        `uvm_object_utils_begin(mem_transaction)
            `uvm_field_int(addr, UVM_ALL_ON)
            `uvm_field_int(wdata, UVM_ALL_ON)
            `uvm_field_int(rdata, UVM_ALL_ON)
            `uvm_field_int(wstrb, UVM_ALL_ON)
            `uvm_field_int(is_write, UVM_ALL_ON)
        `uvm_object_utils_end
        
        function new(string name = "mem_transaction");
            super.new(name);
        endfunction
        
        function string convert2string();
            return $sformatf("addr=0x%0h, wdata=0x%0h, rdata=0x%0h, wr=%0b", addr, wdata, rdata, is_write);
        endfunction
    endclass
    
    class mem_sequencer extends uvm_sequencer #(mem_transaction);
        `uvm_component_utils(mem_sequencer)
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
    endclass
    
    class mem_driver extends uvm_driver #(mem_transaction);
        `uvm_component_utils(mem_driver)
        virtual riscv_if vif;
        int transaction_count;
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(virtual riscv_if)::get(this, "", "vif", vif))
                `uvm_fatal("NOVIF", "Virtual interface not set")
        endfunction
        
        task run_phase(uvm_phase phase);
            forever begin
                seq_item_port.get_next_item(req);
                drive_transaction(req);
                seq_item_port.item_done();
                transaction_count++;
            end
        endtask
        
        task drive_transaction(mem_transaction trans);
            @(posedge vif.clk);
            `uvm_info(get_type_name(), $sformatf("Driving: %s", trans.convert2string()), UVM_HIGH)
            repeat(2) @(posedge vif.clk);
        endtask
        
        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("Driver: %0d transactions", transaction_count), UVM_LOW)
        endfunction
    endclass
    
    class mem_monitor extends uvm_monitor;
        `uvm_component_utils(mem_monitor)
        virtual riscv_if vif;
        uvm_analysis_port #(mem_transaction) item_collected_port;
        int transaction_count;
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
            item_collected_port = new("item_collected_port", this);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(virtual riscv_if)::get(this, "", "vif", vif))
                `uvm_fatal("NOVIF", "Virtual interface not set")
        endfunction
        
        task run_phase(uvm_phase phase);
            mem_transaction trans;
            forever begin
                @(posedge vif.clk);
                if (vif.mem_valid && vif.mem_ready) begin
                    trans = mem_transaction::type_id::create("trans");
                    trans.addr = vif.mem_addr;
                    trans.is_instr = vif.mem_instr;
                    trans.is_write = |vif.mem_wstrb;
                    if (trans.is_write) begin
                        trans.wdata = vif.mem_wdata;
                        trans.wstrb = vif.mem_wstrb;
                    end else begin
                        trans.rdata = vif.mem_rdata;
                    end
                    `uvm_info(get_type_name(), $sformatf("Monitored: %s", trans.convert2string()), UVM_HIGH)
                    item_collected_port.write(trans);
                    transaction_count++;
                end
            end
        endtask
        
        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("Monitor: %0d transactions", transaction_count), UVM_LOW)
        endfunction
    endclass
    
    class riscv_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(riscv_scoreboard)
        uvm_analysis_imp #(mem_transaction, riscv_scoreboard) item_collected_export;
        int instruction_count, data_read_count, data_write_count, total_transactions;
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            item_collected_export = new("item_collected_export", this);
        endfunction
        
        function void write(mem_transaction trans);
            total_transactions++;
            if (trans.is_instr) instruction_count++;
            else if (trans.is_write) data_write_count++;
            else data_read_count++;
        endfunction
        
        function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "===========================================", UVM_LOW)
            `uvm_info(get_type_name(), "  SCOREBOARD REPORT", UVM_LOW)
            `uvm_info(get_type_name(), "===========================================", UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("Total: %0d", total_transactions), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("Instructions: %0d", instruction_count), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("Data reads: %0d", data_read_count), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("Data writes: %0d", data_write_count), UVM_LOW)
            `uvm_info(get_type_name(), "===========================================", UVM_LOW)
        endfunction
    endclass
    
    class functional_coverage extends uvm_subscriber #(mem_transaction);
        `uvm_component_utils(functional_coverage)
        mem_transaction trans;
        
        covergroup memory_cg;
            addr_cp: coverpoint trans.addr[11:0] {
                bins low  = {[0:255]};
                bins mid  = {[256:1023]};
                bins high = {[1024:4095]};
            }
            wstrb_cp: coverpoint trans.wstrb {
                bins byte = {4'b0001, 4'b0010, 4'b0100, 4'b1000};
                bins half = {4'b0011, 4'b1100};
                bins word = {4'b1111};
                bins read = {4'b0000};
            }
            access_cp: coverpoint trans.is_write {
                bins rd = {0};
                bins wr = {1};
            }
        endgroup
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
            memory_cg = new();
        endfunction
        
        function void write(mem_transaction t);
            trans = t;
            memory_cg.sample();
        endfunction
        
        function void report_phase(uvm_phase phase);
            real cov = memory_cg.get_coverage();
            `uvm_info(get_type_name(), "===========================================", UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("Functional Coverage: %.2f%%", cov), UVM_LOW)
            if (cov >= 85.0) `uvm_info(get_type_name(), "✓ Target achieved", UVM_LOW)
            `uvm_info(get_type_name(), "===========================================", UVM_LOW)
        endfunction
    endclass
    
    class mem_agent extends uvm_agent;
        `uvm_component_utils(mem_agent)
        mem_sequencer sequencer;
        mem_driver driver;
        mem_monitor monitor;
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            monitor = mem_monitor::type_id::create("monitor", this);
            if(is_active == UVM_ACTIVE) begin
                sequencer = mem_sequencer::type_id::create("sequencer", this);
                driver = mem_driver::type_id::create("driver", this);
            end
        endfunction
        
        function void connect_phase(uvm_phase phase);
            if(is_active == UVM_ACTIVE)
                driver.seq_item_port.connect(sequencer.seq_item_export);
        endfunction
    endclass
    
    class riscv_env extends uvm_env;
        `uvm_component_utils(riscv_env)
        mem_agent agent;
        riscv_scoreboard scoreboard;
        functional_coverage coverage;
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = mem_agent::type_id::create("agent", this);
            scoreboard = riscv_scoreboard::type_id::create("scoreboard", this);
            coverage = functional_coverage::type_id::create("coverage", this);
        endfunction
        
        function void connect_phase(uvm_phase phase);
            agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
            agent.monitor.item_collected_port.connect(coverage.analysis_export);
        endfunction
    endclass
    
    class base_sequence extends uvm_sequence #(mem_transaction);
        `uvm_object_utils(base_sequence)
        function new(string name = "base_sequence");
            super.new(name);
        endfunction
    endclass
    
    class reset_sequence extends base_sequence;
        `uvm_object_utils(reset_sequence)
        function new(string name = "reset_sequence");
            super.new(name);
        endfunction
        task body();
            `uvm_info(get_type_name(), "Reset sequence executing", UVM_MEDIUM)
            #100;
        endtask
    endclass
    
    class uvm_base_test extends uvm_test;
        `uvm_component_utils(uvm_base_test)
        riscv_env env;
        
        function new(string name = "uvm_base_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = riscv_env::type_id::create("env", this);
        endfunction
        
        function void end_of_elaboration_phase(uvm_phase phase);
            uvm_top.print_topology();
        endfunction
        
        task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            `uvm_info(get_type_name(), "========== TEST START ==========", UVM_LOW)
            #15000;
            `uvm_info(get_type_name(), "========== TEST DONE ==========", UVM_LOW)
            phase.drop_objection(this);
        endtask
        
        function void report_phase(uvm_phase phase);
            uvm_report_server svr = uvm_report_server::get_server();
            `uvm_info(get_type_name(), "===========================================", UVM_LOW)
            if(svr.get_severity_count(UVM_ERROR) == 0)
                `uvm_info(get_type_name(), "*** TEST PASSED ***", UVM_LOW)
            else
                `uvm_error(get_type_name(), "*** TEST FAILED ***")
            `uvm_info(get_type_name(), "===========================================", UVM_LOW)
        endfunction
    endclass
    
    class uvm_smoke_test extends uvm_base_test;
        `uvm_component_utils(uvm_smoke_test)
        function new(string name = "uvm_smoke_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        task run_phase(uvm_phase phase);
            reset_sequence rst_seq;
            phase.raise_objection(this);
            `uvm_info(get_type_name(), "========== SMOKE TEST ==========", UVM_LOW)
            rst_seq = reset_sequence::type_id::create("rst_seq");
            rst_seq.start(env.agent.sequencer);
            #15000;
            phase.drop_objection(this);
        endtask
    endclass
    
endpackage

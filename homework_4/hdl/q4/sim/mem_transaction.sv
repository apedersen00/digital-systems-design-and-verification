class mem_transaction;

  rand bit [31:0]   addr;
  rand bit [31:0]   data;
  rand bit [3:0]    write_en;
  rand bit          is_read;
  rand int unsigned burst_len;

  // burst length [2, 8]
  constraint c_burst_len {
    burst_len inside {[2:8]};
  }

  // word-aligned address
  constraint c_addr_align {
    addr[1:0] == 2'b00;
  }

  // address range
  constraint c_addr_range {
    if (is_read)
      addr inside {[32'h0000_0000 : 32'h0000_FFFF]};
    else
      addr inside {[32'h1000_0000 : 32'h1000_FFFF]};
  }

  // write enable
  constraint c_write_en {
    if (is_read)
      write_en == 4'b0000;
    else
      write_en inside {
        4'b1111, 4'b1100, 4'b0011, 4'b1000,
        4'b0100, 4'b0010, 4'b0001
      };
  }

  // weighted probability: 80% read, 20% write
  constraint c_rw_prob {
    is_read dist {1 := 80, 0 := 20};
  }

endclass
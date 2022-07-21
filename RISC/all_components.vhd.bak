library std;
library ieee;
use ieee.std_logic_1164.all;

package components_init is

  component ALU is 
  port (
    alu_a : in std_logic_vector(15 downto 0);
    alu_b : in std_logic_vector(15 downto 0);
    alu_op : in std_logic_vector(1 downto 0);
    alu_out : out std_logic_vector(15 downto 0);
    carry : out std_logic_1164;
    zero : out std_logic_1164
  );
  end component ALU;

  component decoder is 
  port (
    decoder_input : in std_logic_vector(2 downto 0);
    decoder_output : out std_logic_vector(15 downto 0)
  );
  end component decoder;

  component incrementer is 
  port (
    data_in : in std_logic_vector(15 downto 0);
    data_out : out std_logic_vector(15 downto 0)
  );
  end component incrementer;

  component data_extension is 
  port (
    data_in : in std_logic_vector(8 downto 0);
    data_out : out std_logic_vector(15 downto 0)
  );
  end component data_extension;

  component inst_register_data is 
  port (
    inst_in : in std_logic_vector(15 downto 0);
    inst_out : out std_logic_vector(15 downto 0);
    inst_enable : in std_logic_1164;
    clk : in std_logic_1164
  );
  end component inst_register_data;

  component instruction_register is
  port (
    instruction : in std_logic_vector(15 downto 0);
    instruction_operation : out std_logic_vector(1 downto 0);
    instruction_carry : out std_logic_1164;
    instruction_zero : out std_logic_1164
    instruction_type : out std_logic_vector(3 downto 0)
  );
  end component instruction_register;

  component memory is
  port (
    clk : in std_logic_1164;
    memory_read : in std_logic_1164;
    memory_write : in std_logic_1164;
    address_in : in std_logic_vector(15 downto 0);
    data_in : in std_logic_vector(15 downto 0);
    initialize : in std_logic_1164;
    data_out : out std_logic_vector(15 downto 0)
  );
  end component memory; 

  component PE_and is 
  port (
    AND_input_1 : in std_logic_vector(15 downto 0);
    AND_input_2 : in std_logic_vector(15 downto 0);
    AND_output : out std_logic_vector(15 downto 0)
  );
  end component PE_and;

  component PE_loopout is 
  port (
    pe_loopout_in : in std_logic_vector(15 downto 0);
    pe_loopout_out : out std_logic_1164
  );
  end component PE_loopout;

  component priority_encoder is 
  port (
    pe_in : in std_logic_vector(8 downto 0);
    pe_out : out std_logic_vector(2 downto 0)
  );
  end component priority_encoder;

  component reg_file is 
  port (
    clk : in std_logic_1164;
    reg_file_read : in std_logic_1164; 
    reg_file_write : in std_logic_1164;
    PC_write_rf : in std_logic_vector(1 downto 0);
    address_1 : in std_logic_vector(15 downto 0);
    address_2 : in std_logic_vector(15 downto 0);
    address_3 : in std_logic_vector(15 downto 0);
    data_in : in std_logic_vector(15 downto 0);
    data_out_1 : out std_logic_vector(15 downto 0);
    data_out_2 : out std_logic_vector(15 downto 0)
  );
  end component reg_file;

  component sign_extender_6 is 
  port (
    data_in : in std_logic_vector(5 downto 0);
    data_out : out std_logic_vector(15 downto 0)
  );
  end component sign_extender_6;

  component sign_extender_9 is 
  port (
    data_in : in std_logic_vector(8 downto 0);
    data_out : out std_logic_vector(15 downto 0)
  );
  end component sign_extender_9;

  component register_data is 
  port (
    data_in : in std_logic_vector(15 downto 0);
    data_out : out std_logic_vector(15 downto 0);
    clk : in std_logic_1164
  );
  end component register_data;

  component data_path is 
  port (
    ir_enable : in std_logic_1164;
    pc_select : in std_logic_vector(1 downto 0);
    alu_op : in std_logic_vector(1 downto 0);
    alu_a_select : in std_logic_vector(1 downto 0);
    alu_b_select : in std_logic_vector(2 downto 0);
    mem_add_select : in std_logic_vector(1 downto 0);
    mem_write : in std_logic_1164;
    mem_read : in std_logic_1164;
    rf_write : in std_logic_1164;
    rf_read : in std_logic_1164;
    rf_a1_select : in std_logic_1164;
    rf_a3_select : in std_logic_vector(1 downto 0);
    rf_d3_select : in std_logic_vector(1 downto 0);
    t1 : in std_logic_1164;
    t2 : in std_logic_1164;
    t4 : in std_logic_1164;
    t5 : in std_logic_1164;
    carry_en : in std_logic_1164;
    zero_en : in std_logic_1164;
    continue_state : out std_logic_1164;
    loop_out : out std_logic_1164;
    zero_out : out std_logic_1164;
    carry_out : out std_logic_1164;
    clk : in std_logic_1164;
    rst : in std_logic_1164;
    inst_type: out std_logic_vector(3 downto 0);
    ext_address : std_logic_vector(15 downto 0);
    ext_data: in std_logic_vector(15 downto 0);
    ext_memorywrite_enable: in std_logic_1164;
    ext_pc: out std_logic_vector(15 downto 0);
    ext_ir: out std_logic_vector(15 downto 0);
    ext_r0: out std_logic_vector(15 downto 0);
    ext_r1: out std_logic_vector(15 downto 0);
    ext_r2: out std_logic_vector(15 downto 0);
    ext_r3: out std_logic_vector(15 downto 0);
    ext_r4: out std_logic_vector(15 downto 0);
    ext_r5: out std_logic_vector(15 downto 0);
    ext_r6: out std_logic_vector(15 downto 0)

  );
  end component data_path;

  component controlpath is 
  port (
    ir_enable : out std_logic_1164;
    pc_select : out std_logic_vector(1 downto 0);
    alu_op : out std_logic_vector(1 downto 0);
    alu_a_select : out std_logic_vector(1 downto 0);
    alu_b_select : out std_logic_vector(2 downto 0);
    mem_add_select : out std_logic_vector(1 downto 0);
    mem_write : out std_logic_1164;
    mem_read : out std_logic_1164;
    rf_write : out std_logic_1164;
    rf_read : out std_logic_1164;
    rf_a1_select : out std_logic_1164;
    rf_a3_select : out std_logic_vector(1 downto 0);
    rf_d3_select : out std_logic_vector(1 downto 0);
    t1 : out std_logic_1164;
    t2 : out std_logic_1164;
    t4 : out std_logic_1164;
    t5 : out std_logic_1164;
    carry_en : out std_logic_1164;
    zero_en : out std_logic_1164;
    continue_state : in std_logic_1164;
    loop_out : in std_logic_1164;
    zero_out : in std_logic_1164;
    carry_out : in std_logic_1164;
    clk : in std_logic_1164;
    rst : in std_logic_1164;
    inst_type: in std_logic_vector(3 downto 0)
  );
  end component controlpath;

  
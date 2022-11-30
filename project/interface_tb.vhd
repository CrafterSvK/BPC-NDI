--------------------------------------------------------------------------------
-- SPI Interface test-bench
--------------------------------------------------------------------------------
LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use work.coprocessor.ALL;
use ieee.numeric_std.ALL;
 
ENTITY tb_spi IS
END tb_spi;
 
ARCHITECTURE behavior OF tb_spi IS 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT interface
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         CS_b : IN  std_logic;
         SCLK : IN  std_logic;
         MISO : OUT  std_logic;
         MOSI : IN  std_logic;
         fr_start : OUT  std_logic;
         fr_end : OUT  std_logic;
         fr_err : OUT  std_logic;
         data_out : OUT  std_logic_vector(15 downto 0);
         data_in : IN  std_logic_vector(15 downto 0);
         wr_data : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal CS_b : std_logic := '0';
   signal SCLK : std_logic := '0';
   signal MOSI : std_logic := '0';
   signal data_in : std_logic_vector(15 downto 0) := (others => '0');
   signal wr_data : std_logic := '0';

 	--Outputs
   signal MISO : std_logic;
   signal fr_start : std_logic;
   signal fr_end : std_logic;
   signal fr_err : std_logic;
   signal data_out : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 2 ns;
   
   signal bfm_cmd : t_BFM_CMD;
   signal bfm_rpl : t_BFM_RPL;
    
	
   signal test_number : unsigned(3 downto 0);
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: interface PORT MAP (
          clk => clk,
          rst => rst,
          CS_b => CS_b,
          SCLK => SCLK,
          MISO => MISO,
          MOSI => MOSI,
          fr_start => fr_start,
          fr_end => fr_end,
          fr_err => fr_err,
          data_out => data_out,
          data_in => data_in,
          wr_data => wr_data
        );
		
	bfm_m : entity work.bfm_spi_m(Behavioral)
		port map(
			CS_b => CS_b,
			SCLK => SCLK,
			MOSI => MOSI,
			MISO => MISO,
			bfm_cmd => bfm_cmd,
			bfm_rpl => bfm_rpl
		);

   -- Clock process definitions
   clk_gen : process
   begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
   end process;
 
   -- Stimulus process
   stim_proc : process
	variable packet_val_a : integer := 101;
	variable packet_val_b : integer := 201;
	
	variable frame_val_a : integer;
	variable frame_val_b : integer;
	
	variable reply : integer;
   begin
	  -- tc_spi_001
	  reset_dut(rst);
	  test_number <= to_unsigned(1, 4);
	  
	  frame_val_a := 100;
	  
	  task_send_frame(frame_val_a, reply, bfm_cmd, bfm_rpl);
	  task_send_short_frame(frame_val_a, reply, bfm_cmd, bfm_rpl);
	  task_send_frame(frame_val_a, reply, bfm_cmd, bfm_rpl);
      wait for 50 us;

	  -- tc_spi_002 (Znovu odoslanie packetu)
	  reset_dut(rst);
	  test_number <= to_unsigned(2, 4);
	  
	  frame_val_a := 100;
	  frame_val_b := 200;
	  
	  task_send_frame(frame_val_a, reply, bfm_cmd, bfm_rpl);
	  wait for 1 ms;
	  task_send_packet(frame_val_a, frame_val_b, reply, bfm_cmd, bfm_rpl);
	  task_send_packet(frame_val_b, frame_val_a, reply, bfm_cmd, bfm_rpl);
	  
	  wait for 50 us;

	  -- tc_spi_003
	  reset_dut(rst);
	  test_number <= to_unsigned(3, 4);

	  frame_val_a := 100;
	  frame_val_b := 200;
	  task_send_packet(frame_val_a, frame_val_b, reply, bfm_cmd, bfm_rpl);
	  -- 
	  frame_val_a := 111;
	  frame_val_b := 222;
	  task_send_packet(frame_val_a, frame_val_b, reply, bfm_cmd, bfm_rpl);
	  --
	  
--	  wait for 50 us;
--	  
--	  reset_dut(rst);
	  wait;
   end process;

END;

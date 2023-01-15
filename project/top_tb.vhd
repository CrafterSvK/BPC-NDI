--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use work.coprocessor.ALL;
use work.coprocessor_test.ALL;
use ieee.numeric_std.ALL;

ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         CS_b : IN  std_logic;
         SCLK : IN  std_logic;
         MOSI : IN  std_logic;
         MISO : OUT  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CS_b : std_logic := '0';
   signal SCLK : std_logic := '0';
   signal MOSI : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal MISO : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
		
	signal bfm_cmd : t_BFM_CMD;
	signal bfm_rpl : t_BFM_RPL;
    
	
   signal test_number : unsigned(3 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          CS_b => CS_b,
          SCLK => SCLK,
          MOSI => MOSI,
          MISO => MISO,
          clk => clk,
          rst => rst
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
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

-- Stimulus process
   stim_proc : process
	variable packet_val_a : integer := 101;
	variable packet_val_b : integer := 201;
	
	variable frame_val_a : integer := 100;
	variable frame_val_b : integer := 200;
	
	variable reply : integer;
   begin
   
--	  reset_dut(rst);
--	  wait for 100 us;
--	  test_number <= to_unsigned(3, 4);
--
--	  frame_val_a := 6592; -- 25.75
--	  frame_val_b := -256; -- -1
--	  task_send_packet(frame_val_a, frame_val_b, reply, bfm_cmd, bfm_rpl);
--	  wait for 10 us;
--	  -- 
--	  frame_val_a := 0; -- 0
--	  frame_val_b := 256; -- 1
--	  task_send_packet(frame_val_a, frame_val_b, reply, bfm_cmd, bfm_rpl);
--	  


--	  reset_dut(rst);
--	  wait for 100 us;
--	  frame_val_a := 6337;
--	  
--	  task_send_short_frame(frame_val_a, reply, bfm_cmd, bfm_rpl); -- bad
--	  wait for 10 ns;
--	  
--	  frame_val_a := 6337;
--	  task_send_frame(frame_val_a, reply, bfm_cmd, bfm_rpl); -- good
--	  wait for 10 ns;
--	  
--	  frame_val_b := 0;
--	  task_send_short_frame(frame_val_b, reply, bfm_cmd, bfm_rpl); -- bad
--	  wait for 10 ns;
--	  
--	  frame_val_a := 1088;
--	  task_send_frame(frame_val_a, reply, bfm_cmd, bfm_rpl); -- good
--	  
--	  frame_val_a := 0; -- 0
--	  frame_val_b := 256; -- 1
--	  wait for 10 ns;
--	  task_send_packet(frame_val_a, frame_val_b, reply, bfm_cmd, bfm_rpl);
	  reset_dut(rst);
	  wait for 100 us;
	  frame_val_a := 25600;
	  task_send_frame(frame_val_a, reply, bfm_cmd, bfm_rpl);
	  wait for 2 ms;
	  
	  frame_val_a := 30720; -- 100
	  frame_val_b := 512; -- 2
	  task_send_packet(frame_val_a, frame_val_b, reply, bfm_cmd, bfm_rpl);
	  frame_val_a := 0; -- 0
	  task_send_packet(frame_val_a, frame_val_a, reply, bfm_cmd, bfm_rpl);
	
	  wait;
   end process;

END;

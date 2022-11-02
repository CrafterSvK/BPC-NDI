--------------------------------------------------------------------------------
-- SPI Interface test-bench
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.coprocessor.ALL;
--USE ieee.numeric_std.ALL;
 
ENTITY interface_tb IS
END interface_tb;
 
ARCHITECTURE behavior OF interface_tb IS 
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
	variable input : integer := 1;
	variable bfm_rpl2 : integer;
   begin
      -- initialize
	  bfm_cmd.start <= '0';
	  rst <= '1';
	  wait for 10 ns;
	  rst <= '0';
	  wait for 10 ns;
	  
	  task_send_frame(input, bfm_rpl2, bfm_cmd, bfm_rpl);
      wait;
   end process;

END;

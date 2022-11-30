----------------------------------------------------------------------------------
-- Packet Controller, packet consists of 2 frames received from SPI/AU
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.coprocessor.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity packet_controller is
    Port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		fr_start : in STD_LOGIC;
		fr_end : in STD_LOGIC;
		fr_err : in STD_LOGIC;
		data_out : in t_FRAME;
		data_in : out t_FRAME;
		we_data_fr1 : out  STD_LOGIC;
		we_data_fr2 : out  STD_LOGIC;
		data_fr1 : out  t_FRAME;
		data_fr2 : out  t_FRAME;
		add_res : in  t_FRAME;
		mul_res : in  t_FRAME
	);
end packet_controller;

architecture Behavioral of packet_controller is
	-- state machine
	type state is (expect_first_frame, acquire_first_frame, expect_second_frame, acquire_second_frame);
	signal current_state, next_state : state;
	
	-- timer
	signal timer_en, timer_hit : STD_LOGIC;
begin
	-- state machine
	process (clk, rst) begin
		if (rst = '1') then
			current_state <= expect_first_frame;
		elsif (rising_edge(clk)) then
			current_state <= next_state;
		end if;
	end process;

	process (current_state, fr_err, fr_start, fr_end, add_res, mul_res, timer_hit) begin
		data_in <= (others=>'0');
		we_data_fr1 <= '0';
		we_data_fr2 <= '0';
		timer_en <= '0';
		
		case current_state is
			when expect_first_frame =>
				if (fr_start = '1') then 
					next_state <= acquire_first_frame;
				end if;
			when acquire_first_frame =>		
				data_in <= add_res;
				
				if (fr_err = '1') then 
					next_state <= expect_first_frame;
				end if;
				
				if (fr_end = '1') then 
					we_data_fr1 <= '1';
					next_state <= expect_second_frame;
				end if;
			when expect_second_frame =>
				timer_en <= '1';
			
				if (timer_hit <= '1') then
					next_state <= expect_first_frame;
				end if;
			
				if (fr_start = '1') then 
					next_state <= acquire_second_frame;
				end if;
			when acquire_second_frame =>
				data_in <= mul_res;
			
				if (fr_err = '1') then 
					next_state <= expect_second_frame;
				end if;
			
				if (fr_end = '1') then
					we_data_fr2 <= '1';
					next_state <= expect_first_frame;
				end if;
		end case;
	end process;
	
	timer_wait_for_frame : entity timer(Behavioral)
		port map(clk => clk, rst => rst, en => timer_en, done => timer_hit);
		
	-- map frame to both inputs
	data_fr1 <= data_out;
	data_fr2 <= data_out;
end Behavioral;

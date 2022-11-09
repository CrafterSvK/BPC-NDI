----------------------------------------------------------------------------------
-- Frame detection & check
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.coprocessor.ALL;

entity frame_detection is
    Port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		cs_b_r : in STD_LOGIC;
		cs_b_f : in STD_LOGIC;
		--sclk_r : in STD_LOGIC;
		sclk_f : in STD_LOGIC;
		fr_start : out STD_LOGIC;
		fr_end : out STD_LOGIC;
		fr_err : out STD_LOGIC
	);
end frame_detection;

architecture Behavioral of frame_detection is
	signal count_d, count_q : unsigned(4 downto 0);
	signal cs_d : STD_LOGIC;
	signal cs_q : STD_LOGIC;
begin
	-- frame count
	counter : process (clk, rst) begin
		if (rst = '1') then
			count_q <= (others=>'0');
		elsif rising_edge(clk) then
			count_q <= count_d;
		end if;
	end process;
	
	count_d <= (others=>'0') when cs_b_f = '1' else
				count_q + 1 when sclk_f = '1' else 
				count_q;

	-- hold cs from falling to rising edge
	frame_detect : process (clk, rst) begin
		if (rst = '1') then
			cs_q <= '0';
		elsif (rising_edge(clk)) then
			cs_q <= cs_d;
		end if;
	end process;
	
	cs_d <= '1' when (cs_q = '0' and cs_b_f = '1') else 
			'0' when (cs_q = '1' and cs_b_r = '1') else
			'0';

	-- output
	fr_start <= cs_b_f;
	fr_end <= cs_b_r;
	
	fr_err <= '1' when (count_q > c_FRAME_SIZE and cs_q = '1') else
			  '1' when (count_q < c_FRAME_SIZE and cs_b_r = '1') else
			  '0';
end Behavioral;

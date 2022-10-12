----------------------------------------------------------------------------------
-- Frame detection & check
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity frame_detection is
    Port (
		clk : in  STD_LOGIC;
		cs_r : in STD_LOGIC;
		cs_f : in STD_LOGIC;
		sclk_r : in STD_LOGIC;
		sclk_f : in STD_LOGIC;
		fr_start : out STD_LOGIC;
		fr_end : out STD_LOGIC;
		fr_err : out STD_LOGIC
	);
end frame_detection;

architecture Behavioral of frame_detection is
	signal count_q : unsigned(2 downto 0);
	signal count_d : unsigned(2 downto 0);
begin
	-- frame count
	counter : process (clk) begin
		if rising_edge(clk) then
			count_q <= count_d;
		end if;
	end process;
	
	count_d <= count_q + '1' when sclk_f else count_q;
	-- end frame count

	fr_start <= cs_r;
	fr_end <= cs_f;
	fr_err <= '0' when count_q = 7 and cs_f else '1';
end Behavioral;

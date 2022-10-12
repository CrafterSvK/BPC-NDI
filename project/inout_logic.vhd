----------------------------------------------------------------------------------
-- Input/Output Control for SPI interface
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inout_logic is
    Port (
		cs_b_r : in STD_LOGIC;
		cs_b_f : in STD_LOGIC;
		sclk_r : in STD_LOGIC;
		sclk_f : in STD_LOGIC;
		clk : in STD_LOGIC;
		en_out : out  STD_LOGIC;
        en_in : out  STD_LOGIC
	);
end inout_logic;

architecture Behavioral of inout_logic is
	signal active_q, active_d : STD_LOGIC;
begin
	process (clk, cs_b_r, cs_b_f) begin
		if rising_edge(clk) then
			active_q <= active_d;
		end if;
	end process;
	
	active_d <= cs_b_r and (not active_q);
	en_in <= sclk_f and active_q;
	en_out <= sclk_r and active_q;

end Behavioral;

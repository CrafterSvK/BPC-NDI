----------------------------------------------------------------------------------
-- Input/Output Control for SPI interface
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.coprocessor.ALL;

entity inout_logic is
    Port (
		cs_b_r : in STD_LOGIC;
		cs_b_f : in STD_LOGIC;
		sclk_r : in STD_LOGIC;
		sclk_f : in STD_LOGIC;
		clk : in STD_LOGIC;
		en_out : out  STD_LOGIC;
        en_in : out  STD_LOGIC;
		en_au_data_in : out t_FRAME
	);
end inout_logic;

architecture Behavioral of inout_logic is
	signal active_q, active_d : STD_LOGIC;
begin
	process (clk) begin
		if rising_edge(clk) then
			active_q <= active_d;
		end if;
	end process;
	
	active_d <= '0' when cs_b_r = '1' and active_q = '1' else
				'1' when cs_b_f = '1' and active_q = '0' else
				'0';

	en_in <= sclk_f and active_q; -- enable input serializer on falling edge of clock
	en_out <= sclk_r and active_q; -- enable deserializer output on rising edge of clock
end Behavioral;

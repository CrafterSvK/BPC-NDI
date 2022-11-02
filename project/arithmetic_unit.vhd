----------------------------------------------------------------------------------
-- Arithmetic unit WIP
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.coprocessor.ALL;
use IEEE.NUMERIC_STD.ALL;

entity arithmetic_unit is
    Port (
		clk : in STD_LOGIC;
		data_fr1 : in t_FRAME;
		we_data_fr1 : in STD_LOGIC;
		data_fr2 : in t_FRAME;
		we_data_fr2 : in STD_LOGIC;
		add_res : out t_FRAME;
		mul_res : out t_FRAME
	);
end arithmetic_unit;

architecture Behavioral of arithmetic_unit is
	signal frame1, frame2, add, mul : t_FRAME;
begin
	input_ff : process (clk, we_data_fr1, we_data_fr2) begin
		if (rising_edge(clk)) then
			if (we_data_fr1 = '1') then
				frame1 <= data_fr1;
			end if;
		
			if (we_data_fr2 = '1') then
				frame2 <= data_fr2;
			end if;
		end if;
	end process;
	
	output_ff : process (clk) begin
		if (rising_edge(clk)) then
			add_res <= add;
			mul_res <= mul;
		end if;
	end process;
	
	add <= t_FRAME(unsigned(frame1) + unsigned(frame2));
	mul <= t_FRAME(unsigned(frame1) + unsigned(frame2));
end Behavioral;

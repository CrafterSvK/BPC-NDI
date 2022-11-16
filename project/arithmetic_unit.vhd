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
	signal frame1, frame2 : t_FRAME;
	signal a, b : signed(15 downto 0);
	signal add : signed(15+1 downto 0);
	signal mul : signed((2*16)-1 downto 0);
begin
	input_ff : process (clk) begin
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
	
	a <= signed(frame1);
	b <= signed(frame2);
	
	add <= resize(a, 16) + b;
	add_res <= (others=>'1') when add(15) = '1' else add(15 downto 0);
	
	mul <= resize(a, 32) * b;
	mul_res <= mul(
	
end Behavioral;

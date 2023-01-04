----------------------------------------------------------------------------------
-- Deserializer (LSB first)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.coprocessor.ALL;

entity deserializer is
    Port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		en : in STD_LOGIC;
		input : in STD_LOGIC;
		output : out t_FRAME
	);
end deserializer;

architecture Behavioral of deserializer is
	signal q, d : t_FRAME;
begin
	process (clk, en, rst) begin
		if (rst = '1') then
			q <= (others=>'0');
		elsif (rising_edge(clk) and en = '1') then
			q <= d;
		end if;
	end process;
	
	d <= input&q(q'length - 1 downto 1);
	output <= q;
end Behavioral;

----------------------------------------------------------------------------------
-- Shift Register (LSB first it should be)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift is
    Port (
		clk : in  STD_LOGIC;
		rst : in STD_LOGIC;
        en : in  STD_LOGIC;
        input : in  STD_LOGIC;
        output : out  STD_LOGIC_VECTOR(7 downto 0)
	);
end shift;

architecture Behavioral of shift is
	signal q, d : STD_LOGIC_VECTOR(output'length-1 downto 0);
begin
	process (clk, en, rst) begin
		if (rst = '1') then
			q <= (others=>'0');
		elsif (rising_edge(clk) and en = '1') then
			q <= d;
		end if;
	end process;
	
	d <= input&q(q'length -1 downto 1);
	output <= q;
end Behavioral;

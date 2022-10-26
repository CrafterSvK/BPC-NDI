----------------------------------------------------------------------------------
-- 1 ms Timer (50 MHz clock)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    Port (
		clk : in  STD_LOGIC;
		en : in  STD_LOGIC;
		rst : in STD_LOGIC;
		done : out  STD_LOGIC
	);
end timer;

architecture Behavioral of timer is
	signal q, d : unsigned(5 downto 0);
begin
	process (clk, en) begin
		if (rst = '1') then
			q <= to_unsigned(0, 8);
		elsif (rising_edge(clk)) then
			q <= d;
		end if;
	end process;

	d <= q + 1 when (en = '1') else to_unsigned(0, 8);
	done <= '1' when (q = 50) else '0';
end Behavioral;

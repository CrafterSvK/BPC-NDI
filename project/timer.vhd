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
	signal q, d : unsigned(16 downto 0);
begin
	process (clk, rst) begin
		if (rst = '1') then
			q <= to_unsigned(0, 17);
		elsif (rising_edge(clk)) then
			q <= d;
		end if;
	end process;

	d <= q + 1 when (en = '1') else to_unsigned(0, 17);
	done <= '1' when (q = 100000) else '0';
end Behavioral;

----------------------------------------------------------------------------------
-- Data synchronization to new clock domain
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ddf is
    Port (
		clk : in  STD_LOGIC;
		input : in  STD_LOGIC;
        output : out  STD_LOGIC
	);
end ddf;

architecture Behavioral of ddf is
	signal q1 : STD_LOGIC;
	signal q2 : STD_LOGIC;
begin
	d_req1 : process (clk) begin
		if rising_edge(clk) then
			q1 <= input;
		end if;
	end process;

	d_req2 : process (clk) begin
		if rising_edge(clk) then
			q2 <= q1;
		end if;
	end process;

	output <= q2;
end Behavioral;

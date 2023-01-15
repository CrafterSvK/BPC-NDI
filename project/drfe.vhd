----------------------------------------------------------------------------------
-- detector of rising & falling edge
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity drfe is
    Port ( 
		clk : in STD_LOGIC;
        input : in STD_LOGIC;
        fe : out STD_LOGIC;
		re : out STD_LOGIC
	);
end drfe;

architecture Behavioral of drfe is
	signal q: STD_LOGIC;
begin
	d_reg : process (clk) begin
		if rising_edge(clk) then
			q <= input;
		end if;
	end process;

	re <= (q xor input) and input;
	fe <= '1' when (q = '1' and input = '0') else '0';
end Behavioral;

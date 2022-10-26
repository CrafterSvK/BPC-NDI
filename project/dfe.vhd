----------------------------------------------------------------------------------
-- detector of falling edge
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dfe is
    Port ( 
		clk : in  STD_LOGIC;
        input : in  STD_LOGIC;
        output : out  STD_LOGIC
	);
end dfe;

architecture Behavioral of dfe is
	signal q: STD_LOGIC;
begin
	d_reg : process (clk) begin
		if rising_edge(clk) then
			q <= input;
		end if;
	end process;

	output <= '1' when (q = '1' and input = '0') else '0';
end Behavioral;

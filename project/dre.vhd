----------------------------------------------------------------------------------
-- detector of rising edge
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dre is
    Port ( 
		clk : in  STD_LOGIC;
        input : in  STD_LOGIC;
        output : out  STD_LOGIC
	);
end dre;

architecture Behavioral of dre is
	signal q: STD_LOGIC;
begin
	d_reg : process (clk) begin
		if rising_edge(clk) then
			q <= input;
		end if;
	end process;

	output <= (q xor input) and input;
end Behavioral;

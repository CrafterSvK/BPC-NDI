library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;

entity sr is
   Port ( d : in  STD_LOGIC;
          clk : in  STD_LOGIC;
          output : out  STD_LOGIC_VECTOR(15 downto 0)
	);
end sr;

architecture Behavioral of sr is
	signal q : STD_LOGIC_VECTOR(15 downto 0);
begin

process (d, q, clk) begin
	if (rising_edge(clk)) then
		q <= d & q(q'length-1 downto 1);
	end if;
end process;

output <= q;

end Behavioral;

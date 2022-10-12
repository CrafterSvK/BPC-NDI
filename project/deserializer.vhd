----------------------------------------------------------------------------------
-- 8-bit shift-register serializer
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity deserializer is
    Port (
		clk : in STD_LOGIC;
        en_in : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        input : in STD_LOGIC_VECTOR(7 downto 0);
        output : out  STD_LOGIC
	);
end deserializer;

architecture Behavioral of deserializer is
	signal d, q : STD_LOGIC_VECTOR(7 downto 0);
begin
	process (clk, rst, en_in) begin
		if (rst = '1') then
			q <= (others=>'0');
		elsif (rising_edge(clk)) then
			q <= d;
		end if;
	end process;

	d <= input when en_in = '1' else '0'&q(q'length -1 downto 1);
	output <= q(0);
end Behavioral;

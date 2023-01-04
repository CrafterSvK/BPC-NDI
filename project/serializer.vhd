----------------------------------------------------------------------------------
-- 8-bit shift-register serializer
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.coprocessor.ALL;

entity serializer is
    Port (
		clk : in STD_LOGIC;
		en_shift : in STD_LOGIC;
		en_data_input : in STD_LOGIC;
		rst : in STD_LOGIC;
		input : in t_FRAME;
		output : out STD_LOGIC
	);
end serializer;

architecture Behavioral of serializer is
	signal d, q : t_FRAME;
begin
	process (clk, rst) begin
		if (rst = '1') then
			q <= (others => '0');
		elsif (rising_edge(clk)) then
			q <= d;
		end if;
	end process;

	d <= '0'&q(q'length-1 downto 1) when en_shift = '1' else
		  input when en_data_input = '1' else
		  q;
		  
	output <= q(0);
end Behavioral;

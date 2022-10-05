library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity counter is
    Port ( clk : in  STD_LOGIC;
			  rst : in STD_LOGIC;
           output : out  STD_LOGIC
	 );
end counter;

architecture Behavioral of counter is
	signal reg_q: unsigned(3 downto 0);
	signal reg_d: unsigned(3 downto 0);
begin
	process (clk, rst) begin
		if rst = '1' then
			reg_q <= (others=>'0');
		elsif (rising_edge(clk)) then
			reg_q <= reg_d;
		end if;
	end process;

	reg_d <= (others => '0') when (reg_q = 15) else reg_q + 1;
	
	output <= '1' when (reg_q = 15) else '0';
end Behavioral;


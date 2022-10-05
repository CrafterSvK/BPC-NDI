library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;

entity modul is
	Port (
		clk : in STD_LOGIC;
		sig_in : in STD_LOGIC;
		sig_out : out STD_LOGIC
	);
end modul;

architecture Behavioral of modul is
	signal q_out: STD_LOGIC;
begin

d_req : process (clk) begin
	if rising_edge(clk) then
		q_out <= sig_in;
	end if;
end process;

sig_out <= (q_out xor sig_in) and sig_in;

end Behavioral;

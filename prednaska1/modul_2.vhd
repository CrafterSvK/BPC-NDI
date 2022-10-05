library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;

entity modul_2 is
    Port ( clk : in  STD_LOGIC;
           sig_in : in  STD_LOGIC;
           sig_out : out  STD_LOGIC);
end modul_2;

architecture Behavioral of modul_2 is
	signal q_out : STD_LOGIC;
begin
	d_req : process (clk) begin
		if falling_edge(clk) then
			q_out <= sig_in;
		end if;
	end process;
	
	sig_out <= (not sig_in) and q_out;
end Behavioral;


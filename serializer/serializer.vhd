library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity serializer is
	Port (
		clk: in STD_LOGIC;
		input: in STD_LOGIC;
		rst: in STD_LOGIC;
		output: out STD_LOGIC_VECTOR(15 downto 0));
end serializer;

architecture Behavioral of serializer is
	component sr is 
	Port (
		d: in STD_LOGIC;
		clk: in STD_LOGIC;
		output: out STD_LOGIC_VECTOR(15 downto 0)
	);
	end component;
	
	component counter is
    Port ( clk : in  STD_LOGIC;
			  rst : in STD_LOGIC;
           output : out  STD_LOGIC
	 );
	end component;
	
	signal end_of_data : STD_LOGIC;
	signal data : STD_LOGIC_VECTOR(15 downto 0);
begin
	process (clk, data, end_of_data) begin
		if (rising_edge(clk) and end_of_data = '1') then
			output <= data;
		end if;
	end process;

	POCITADLO : counter
		port map (rst => rst, clk => clk, output => end_of_data);

	SHIFT_REGISTER : sr
		port map (clk => clk, d => input, output => data);

end Behavioral;

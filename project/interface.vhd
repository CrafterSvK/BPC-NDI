----------------------------------------------------------------------------------
-- SPI Interface
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity interface is
    Port ( 
		clk : in STD_LOGIC;
		CS_b : in  STD_LOGIC;
		SCLK : in  STD_LOGIC;
		MISO : out  STD_LOGIC;
		MOSI : in  STD_LOGIC;
		fr_start : out STD_LOGIC;
		fr_end : out STD_LOGIC;
		fr_err : out STD_LOGIC;
		data_out : out STD_LOGIC_VECTOR(7 downto 0);
		data_in : in STD_LOGIC;
		wr_data : in STD_LOGIC
	);
end interface;

architecture Behavioral of interface is
	signal rst : STD_LOGIC;

	signal en_out, en_in : STD_LOGIC;
	signal mosi_d, cs_b_d, sclk_d : STD_LOGIC;
	signal cs_b_r, cs_b_f, sclk_r, sclk_f : STD_LOGIC;
begin
	mosi_ddf : entity ddf(Behavioral)
		port map(clk => clk, input => MOSI, output => mosi_d);

	cs_b_ddf : entity ddf(Behavioral)
		port map(clk => clk, input => CS_b, output => cs_b_d);

	cs_dre : entity dre(Behavioral)
		port map(clk => clk, input => cs_b_d, output => cs_b_r);
	cs_dfe : entity dfe(Behavioral)
		port map(clk => clk, input => cs_b_d, output => cs_b_f);
		
	sclk_ddf : entity ddf(Behavioral)
		port map(clk => clk, input => SCLK, output => sclk_d);
	
	sclk_dre : entity dre(Behavioral)
		port map(clk => clk, input => cs_b_d, output => sclk_r);
	sclk_dfe : entity dfe(Behavioral)
		port map(clk => clk, input => cs_b_d, output => sclk_f);
		
	input_output_logic : entity inout_logic(Behavioral)
		port map(clk => clk, cs_b_r => cs_b_r, cs_b_f => cs_b_f, sclk_r => sclk_r, sclk_f => sclk_f, en_out => en_out, en_in => en_in);

	shift_reg_in : entity shift(Behavioral)
		port map(clk => clk, en => en_in, rst => rst, input => mosi_d, output => data_out);

end Behavioral;
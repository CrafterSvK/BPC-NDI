----------------------------------------------------------------------------------
-- SPI Interface
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.coprocessor.ALL;

entity interface is
    Port ( 
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		CS_b : in  STD_LOGIC;
		SCLK : in  STD_LOGIC;
		MISO : out  STD_LOGIC;
		MOSI : in  STD_LOGIC;
		fr_start : out STD_LOGIC;
		fr_end : out STD_LOGIC;
		fr_err : out STD_LOGIC;
		data_out : out t_FRAME;
		data_in : in t_FRAME;
		wr_data : in STD_LOGIC
	);
end interface;

architecture Behavioral of interface is
	signal en_out_shift, en_in : STD_LOGIC;
	signal mosi_d, cs_b_d, sclk_d : STD_LOGIC;
	signal cs_b_r, cs_b_f, sclk_r, sclk_f : STD_LOGIC;
begin
	-- MOSI
	mosi_ddf : entity work.ddf(Behavioral)
		port map(clk => clk, input => MOSI, output => mosi_d);

	-- CS_b
	cs_b_ddf : entity work.ddf(Behavioral)
		port map(clk => clk, input => CS_b, output => cs_b_d);
	cs_dre : entity work.dre(Behavioral)
		port map(clk => clk, input => cs_b_d, output => cs_b_r);
	cs_dfe : entity work.dfe(Behavioral)
		port map(clk => clk, input => cs_b_d, output => cs_b_f);
	
	-- SCLK
	sclk_ddf : entity work.ddf(Behavioral)
		port map(clk => clk, input => SCLK, output => sclk_d);
	sclk_dre : entity work.dre(Behavioral)
		port map(clk => clk, input => sclk_d, output => sclk_r);
	sclk_dfe : entity work.dfe(Behavioral)
		port map(clk => clk, input => sclk_d, output => sclk_f);
	
	
	input_output_logic : entity work.inout_logic(Behavioral)
		port map(
			clk => clk,
			cs_b_r => cs_b_r,
			cs_b_f => cs_b_f,
			CS_b => cs_b_d,
			sclk_r => sclk_r,
			sclk_f => sclk_f,
			en_out_shift => en_out_shift,
			en_in => en_in
		);

	-- input deserializer
	deserializer_e : entity work.deserializer(Behavioral)
		port map(clk => clk, rst => rst, en => en_in, input => mosi_d, output => data_out);

	-- output serializer
	serializer_e : entity work.serializer(Behavioral)
		port map(clk => clk, en_shift => en_out_shift, en_data_input => wr_data, rst => rst, input => data_in, output => MISO);

	frame_detection_e : entity work.frame_detection(Behavioral)
		port map(
			clk => clk,
			rst => rst,
			cs_b_r => cs_b_r,
			cs_b_f => cs_b_f,
	--		sclk_r => sclk_r,
			sclk_f => sclk_f,
			fr_start => fr_start,
			fr_end => fr_end,
			fr_err => fr_err
		);

end Behavioral;

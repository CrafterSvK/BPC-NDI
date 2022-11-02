----------------------------------------------------------------------------------
-- Top
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.coprocessor.ALL;

entity top is
    Port (
		CS_b : in  STD_LOGIC;
		SCLK : in  STD_LOGIC;
		MOSI : in  STD_LOGIC;
		MISO : out  STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC
	);
end top;

architecture Behavioral of top is
	signal fr_start, fr_end, fr_err, wr_data : STD_LOGIC;
	signal data_out, data_in : t_FRAME;
	
	signal data_fr1, data_fr2, add_res, mul_res : t_FRAME;
	signal we_data_fr1, we_data_fr2 : STD_LOGIC;
begin
	spi_interface: entity work.interface(Behavioral)
		port map(
			clk => clk,
			rst => rst,
			CS_b => CS_b,
			SCLK => SCLK,
			MISO => MISO,
			MOSI => MOSI,
			fr_start => fr_start,
			fr_end => fr_end,
			fr_err => fr_err,
			data_out => data_out,
			data_in => data_in,
			wr_data => wr_data
		);
		
	packet_controller_d : entity work.packet_controller(Behavioral)
		port map(
			clk => clk,
			rst => rst,
			fr_start => fr_start,
			fr_end => fr_end,
			fr_err => fr_err,
			data_out => data_out,
			wr_data => wr_data,
			data_in => data_in,
			we_data_fr1 => we_data_fr1,
			we_data_fr2 => we_data_fr2,
			data_fr1 => data_fr1,
			data_fr2 => data_fr2,
			add_res => add_res,
			mul_res => mul_res
		);

end Behavioral;

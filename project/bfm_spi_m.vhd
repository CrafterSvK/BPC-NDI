----------------------------------------------------------------------------------
-- BFM
----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.coprocessor.ALL;

entity bfm_spi_m is
	Port (
		CS_b : out STD_LOGIC;
		SCLK : out STD_LOGIC;
		MOSI : out STD_LOGIC;
		MISO : in STD_LOGIC;
		bfm_cmd : in t_BFM_CMD;
		bfm_rpl : out t_BFM_RPL
	);
end bfm_spi_m;

architecture Behavioral of bfm_spi_m is

begin
	process begin
		CS_b <= '1';
		SCLK <= '1';
		bfm_rpl.done <= '1';

		wait until bfm_cmd.start = '1';-- on bfm_cmd.start;-- until rising_edge(bfm_cmd.start);
		bfm_rpl.done <= '0';
	
		CS_b <= '0';
	
		for idx in 0 to c_FRAME_SIZE - 1 loop
			SCLK <= '0';
			MOSI <= bfm_cmd.data(idx);
			wait for 1 us;
			SCLK <= '1';
			bfm_rpl.data(idx) <= MISO;
			wait for 1 us;
		end loop;
	end process;
end Behavioral;

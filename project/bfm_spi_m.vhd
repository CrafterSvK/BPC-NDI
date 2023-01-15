----------------------------------------------------------------------------------
-- BFM
----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.coprocessor.ALL;
use work.coprocessor_test.ALL;

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

		wait until bfm_cmd.start = '1';
		bfm_rpl.data <= (others=>'0');
		bfm_rpl.done <= '0';
		
		wait for 10 ns;
		CS_b <= '0';
		wait for 500 ns;
	
		case bfm_cmd.error is
			when no_error =>
				for idx in 0 to c_FRAME_SIZE - 1 loop
					SCLK <= '0';
					MOSI <= bfm_cmd.data(idx);
					wait for 500 ns;
					SCLK <= '1';
					bfm_rpl.data(idx) <= MISO;
					wait for 500 ns;
				end loop;
			when missing_bits_error =>
				for idx in 0 to 6 loop
					SCLK <= '0';
					MOSI <= bfm_cmd.data(idx);
					wait for 500 ns;
					SCLK <= '1';
					bfm_rpl.data(idx) <= MISO;
					wait for 500 ns;
				end loop;
		end case;
	end process;
end Behavioral;

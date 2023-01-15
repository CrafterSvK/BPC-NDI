----------------------------------------------------------------------------------
-- Input/Output Control for SPI interface
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.coprocessor.ALL;

entity inout_logic is
    Port (
		CS_b : in STD_LOGIC;
		sclk_r : in STD_LOGIC;
		sclk_f : in STD_LOGIC;
		en_out_shift : out  STD_LOGIC;
        en_in : out  STD_LOGIC
	);
end inout_logic;

architecture Behavioral of inout_logic is

begin
	en_in <= sclk_f and (not CS_b); -- enable input serializer on falling edge of clock
	en_out_shift <= sclk_r and (not CS_b); -- enable deserializer output on rising edge of clock
end Behavioral;

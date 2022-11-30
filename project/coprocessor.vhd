library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package coprocessor is
	-- general
	constant c_FRAME_SIZE : integer := 16;

	subtype t_FRAME is STD_LOGIC_VECTOR(c_FRAME_SIZE - 1 downto 0);

	-- AU
	constant c_MAX_POSITIVE_NUMBER : STD_LOGIC_VECTOR := x"7FFF";
	constant c_MIN_NEGATIVE_NUMBER : STD_LOGIC_VECTOR := x"8000";	
end coprocessor;

package body coprocessor is

end coprocessor;

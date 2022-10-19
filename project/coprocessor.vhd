library IEEE;
use IEEE.STD_LOGIC_1164.all;

package coprocessor is
	constant c_FRAME_SIZE : integer := 16;

	subtype t_FRAME is STD_LOGIC_VECTOR(c_FRAME_SIZE - 1 downto 0);
end coprocessor;

package body coprocessor is
 
end coprocessor;

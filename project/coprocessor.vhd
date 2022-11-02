library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package coprocessor is
	-- general
	constant c_FRAME_SIZE : integer := 16;

	subtype t_FRAME is STD_LOGIC_VECTOR(c_FRAME_SIZE - 1 downto 0);

	-- testbench
	type t_BFM_CMD is
	record
		data	: t_FRAME;
		start	: STD_LOGIC;
	end record;
	
	type t_BFM_RPL is
	record
		data	: t_FRAME;
		done	: STD_LOGIC;
	end record;
	
	procedure task_send_frame (
		variable frame_cmd : in integer;
		variable frame_rpl : out integer;
		signal bfm_cmd : out t_BFM_CMD;
		signal bfm_rpl : in t_BFM_RPL
	);
end coprocessor;

package body coprocessor is
	-- testbench
	procedure task_send_frame (
		variable frame_cmd : in integer;
		variable frame_rpl : out integer;
		signal bfm_cmd : out t_BFM_CMD;
		signal bfm_rpl : in t_BFM_RPL
	) is begin
		bfm_cmd.data <= std_logic_vector(to_signed(frame_cmd, c_FRAME_SIZE));
		bfm_cmd.start <= '1';
		wait until bfm_rpl.done = '0';
		bfm_cmd.start <= '0';
		wait until rising_edge(bfm_rpl.done);
--		bfm_cmd.start <= '0';
		frame_rpl := to_integer(signed(bfm_rpl.data));
	end procedure;
 
end coprocessor;

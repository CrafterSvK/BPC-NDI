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

	-- testbench
	type t_bfm_error is (no_error, missing_bits_error);
	
	type t_BFM_CMD is
	record
		data	: t_FRAME;
		start	: STD_LOGIC;
		error   : t_bfm_error;
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
	
	procedure task_send_short_frame (
		variable val : in integer;
		variable rpl : out integer;
		signal bfm_cmd : out t_BFM_CMD;
		signal bfm_rpl : in t_BFM_RPL
	);
	
	procedure task_send_packet (
		variable frame1_val : in integer;
		variable frame2_val : in integer;
		variable rpl : out integer;
		signal bfm_cmd : out t_BFM_CMD;
		signal bfm_rpl : in t_BFM_RPL
	);
	
	procedure reset_dut (signal rst : out STD_LOGIC);
end coprocessor;

package body coprocessor is
	-- testbench
	procedure task_send_frame (
		variable frame_cmd : in integer;
		variable frame_rpl : out integer;
		signal bfm_cmd : out t_BFM_CMD;
		signal bfm_rpl : in t_BFM_RPL
	) is begin
		bfm_cmd.error <= no_error;
		bfm_cmd.data <= std_logic_vector(to_signed(frame_cmd, c_FRAME_SIZE));
		bfm_cmd.start <= '1';
		wait until bfm_rpl.done = '0';
		bfm_cmd.start <= '0';
		wait until rising_edge(bfm_rpl.done);
--		bfm_cmd.start <= '0';
		frame_rpl := to_integer(signed(bfm_rpl.data));
	end procedure;
	
	procedure task_send_short_frame (
		variable val : in integer;
		variable rpl : out integer;
		signal bfm_cmd : out t_BFM_CMD;
		signal bfm_rpl : in t_BFM_RPL
	) is begin
		bfm_cmd.error <= missing_bits_error;
		bfm_cmd.data <= std_logic_vector(to_signed(val, c_FRAME_SIZE));
		bfm_cmd.start <= '1';
		wait until bfm_rpl.done = '0';
		bfm_cmd.start <= '0';
		wait until rising_edge(bfm_rpl.done);
--		bfm_cmd.start <= '0';
		rpl := to_integer(signed(bfm_rpl.data));
	end procedure;
	
	procedure task_send_packet (
		variable frame1_val : in integer;
		variable frame2_val : in integer;
		variable rpl : out integer;
		signal bfm_cmd : out t_BFM_CMD;
		signal bfm_rpl : in t_BFM_RPL
	) is begin
		task_send_frame(frame1_val, rpl, bfm_cmd, bfm_rpl);
		wait for 10 ns;
		task_send_frame(frame2_val, rpl, bfm_cmd, bfm_rpl);
	end procedure;
	
	procedure reset_dut (signal rst : out STD_LOGIC) is begin
		rst <= '1';
		wait for 10 ns;
		rst <= '0';
		wait for 10 ns;
	end procedure;
end coprocessor;

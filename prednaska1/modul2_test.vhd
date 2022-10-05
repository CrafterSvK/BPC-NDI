--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:12:04 10/05/2022
-- Design Name:   
-- Module Name:   C:/Users/xjanek04/Documents/ISE/NDI/prednaska1/modul2_test.vhd
-- Project Name:  prednaska1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: modul_2
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY modul2_test IS
END modul2_test;
 
ARCHITECTURE behavior OF modul2_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT modul_2
    PORT(
         clk : IN  std_logic;
         sig_in : IN  std_logic;
         sig_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal sig_in : std_logic := '0';

 	--Outputs
   signal sig_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: modul_2 PORT MAP (
          clk => clk,
          sig_in => sig_in,
          sig_out => sig_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

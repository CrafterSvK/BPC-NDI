----------------------------------------------------------------------------------
-- Arithmetic unit WIP
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.coprocessor.ALL;
use IEEE.NUMERIC_STD.ALL;

entity arithmetic_unit is
    Port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		data_fr1 : in t_FRAME;
		we_data_fr1 : in STD_LOGIC;
		data_fr2 : in t_FRAME;
		we_data_fr2 : in STD_LOGIC;
		we_out_data : in STD_LOGIC;
		add_res : out t_FRAME;
		mul_res : out t_FRAME
	);
end arithmetic_unit;

architecture Behavioral of arithmetic_unit is
	signal frame1, frame2 : t_FRAME;
	signal a, b, add_d, mul_d : signed(15 downto 0);
	signal add : signed(15+1 downto 0);
	signal mul : signed((2*16)-1 downto 0);
begin
	input_ff : process (clk, rst) begin
		if (rst = '1') then
			frame1 <= (others => '0');
			frame2 <= (others => '0');
		elsif (rising_edge(clk)) then
			if (we_data_fr1 = '1') then
				frame1 <= data_fr1;
			end if;
		
			if (we_data_fr2 = '1') then
				frame2 <= data_fr2;
			end if;
		end if;
	end process;
	
	output_ff : process (clk, rst) begin
		if (rst = '1') then
			add_res <= (others=>'0');
			mul_res <= (others=>'0');
		elsif (rising_edge(clk) and we_out_data = '1') then
			add_res <= std_logic_vector(add_d);
			mul_res <= std_logic_vector(mul_d);
		end if;
	end process;
	
	a <= signed(frame1);
	b <= signed(frame2);
	
	add <= resize(a, 17) + b;
	add_d <= signed(c_MAX_POSITIVE_NUMBER) when (a(a'left) = '0' and b(b'left) = '0' and add(add'left) = '1') else 
			 signed(c_MIN_NEGATIVE_NUMBER) when (a(a'left) = '1' and b(b'left) = '1' and add(add'left) = '0') else
			 add(15 downto 0);
	
	mul <= a * b;
	mul_d <= signed(c_MAX_POSITIVE_NUMBER) when ( -- saturate to maximum positive number if sgn(a) == sgn(b)
				(a(a'left) xnor b(b'left)) = '1' and mul(31 downto 16) /= "00000000000000000"
			 ) else 
			 signed(c_MIN_NEGATIVE_NUMBER) when ( -- saturate to minimum negative number if sgn(a) != sgn(b)
				(a(a'left) xor b(b'left)) = '1' and mul(mul'left) = '0'
			 ) else
			 mul(mul'left)&mul(14 downto 0); -- contract to 16 bits with sgn
end Behavioral;

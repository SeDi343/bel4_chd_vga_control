-- Design: Patterngenerator 2 Architecture                                   --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 19.05.2018                                                         --
-- File : patterngenerator_2_architecture.vhd                                --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

architecture patterngenerator_2_architecture of patterngenerator_2_entity is
	-- Creating 10x10 matrix for pattern 2
	type MATRIXTYP is array (0 to 9, 0 to 9) of std_logic_vector(11 downto 0);

	constant R	: std_logic_vector(11 downto 0) := "111100000000";	-- Red Color Value
	constant G	: std_logic_vector(11 downto 0) := "000011110000";	-- Green Color Value
	constant B	: std_logic_vector(11 downto 0) := "000000001111";	-- Blue Color Value

	signal matrix	: MATRIXTYP := ((R, G, B, R, G, B, R, G, B, R),
																(G, B, R, G, B, R, G, B, R, G),
																(B, R, G, B, R, G, B, R, G, B),
																(R, G, B, R, G, B, R, G, B, R),
																(G, B, R, G, B, R, G, B, R, G),
																(B, R, G, B, R, G, B, R, G, B),
																(R, G, B, R, G, B, R, G, B, R),
																(G, B, R, G, B, R, G, B, R, G),
																(B, R, G, B, R, G, B, R, G, B),
																(R, G, B, R, G, B, R, G, B, R));

	signal s_rgb		: std_logic_vector(11 downto 0);	-- Internal RGB Signal

begin

	-----------------------------------------------------------------------------
	-- Pattern 2 Generator
	-----------------------------------------------------------------------------
	p_pattern_2 : process(clk_i, reset_i)
	variable h				: integer;												-- Horizontal Coordinates
	variable hnext		: integer;												-- Horizontal Coordinates with Offset
	variable v				: integer;												-- Vertical Coordinates
	variable vnext		: integer;												-- Vertical Coordinates with Offset

	begin
		if reset_i = '1' then
			-- Reset System
			s_rgb <= "000000000000";

		elsif clk_i'event and clk_i = '1' then
			-- Creating 2 for loops for matrix x and y coordinates
			for x in 0 to 9 loop
				for y in 0 to 9 loop
					h := x * 64;
					hnext := h + 64;

					v := y * 48;
					vnext := v + 48;

					if h_sync_counter_i >= h and h_sync_counter_i <= hnext then
						if v_sync_counter_i >= v and v_sync_counter_i <= vnext then
							s_rgb <= matrix(y,x);
						end if;
					end if;
				end loop;
			end loop;
		end if;
	end process p_pattern_2;

	-- Write Internal RGB Signal to Output
	rgb_o <= s_rgb;

end patterngenerator_2_architecture;

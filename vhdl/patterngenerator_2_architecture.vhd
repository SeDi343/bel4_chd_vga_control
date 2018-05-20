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
	type t_state is (NEWPAGE, RED, GREEN, BLUE, BLACK, NEWLINE); -- States for Pattern

	constant C_LINE				: integer := 640;		-- 640 pixels per line
	constant C_COLORLINE	: integer := 64;		-- 64 pixels per color
	constant C_ROW				: integer := 480;		-- 480 rows per page
	constant C_COLORROW		: integer := 48;		-- 48 pixels per color

	signal s_linecntr				: integer := 1;			-- Line Counter Signal
	signal s_colorlinecntr	: integer := 1;			-- Color Line Counter Signal
	signal s_rowcntr				: integer := 1;			-- Row Counter Signal
	signal s_colorrowcntr		: integer := 1;			-- Color Row Counter Signal

	signal s_state				: t_state := NEWPAGE;

	signal s_rgb					: std_logic_vector(11 downto 0);	-- Internal RGB Signal

begin

	p_pattern_2 : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_linecntr <= 1;
			s_colorlinecntr <= 1;
			s_rowcntr <= 1;
			s_rgb <= "000000000000";
			s_state <= NEWPAGE;

		elsif clk_i'event and clk_i = '1' then
			if en_25mhz_i = '1' then
				case s_state is
					-- New Page
					when NEWPAGE =>
						s_rgb <= "111100000000";

						-- If visible area is reached
						if rgb_enable_i = '1' then
							s_linecntr <= 1;
							s_colorlinecntr <= 1;
							s_rowcntr <= 1;
							s_state <= RED;
						end if;

					-- Red Color
					when RED =>
						s_rgb <= "111100000000";
						s_linecntr <= s_linecntr + 1;

						-- If red color has 40 pixels
						if s_colorlinecntr = C_COLOR then
							s_colorlinecntr <= 1;
							s_rgb <= "000011110000";
							s_state <= GREEN;
						else
						s_colorlinecntr <= s_colorlinecntr + 1;
						end if;

					-- Green Color
					when GREEN =>
						s_rgb <= "000011110000";
						s_linecntr <= s_linecntr + 1;

						-- If green color has 40 pixels
						if s_colorlinecntr = C_COLOR then
							s_colorlinecntr <= 1;
							s_rgb <= "000000001111";
							s_state <= BLUE;
						else
						s_colorlinecntr <= s_colorlinecntr + 1;
						end if;

					-- Blue Color
					when BLUE =>
						s_rgb <= "000000001111";
						s_linecntr <= s_linecntr + 1;

						-- If blue color has 40 pixels
						if s_colorlinecntr = C_COLOR then
							s_colorlinecntr <= 1;
							s_rgb <= "000000000000";
							s_state <= BLACK;
						else
						s_colorlinecntr <= s_colorlinecntr + 1;
						end if;

					-- Black Color
					when BLACK =>
						s_rgb <= "000000000000";
						s_linecntr <= s_linecntr + 1;

						-- If Line Counter reached 640
						if s_linecntr = C_LINE then
							s_state <= NEWLINE;
							s_linecntr <= 1;

						-- If Row Counter reached 480
						elsif s_rowcntr = C_ROW then
							s_state <= NEWPAGE;

						-- If Color Counter reached 40
						elsif s_colorlinecntr = C_COLOR then
							s_colorlinecntr <= 1;
							s_rgb <= "111100000000";
							s_state <= RED;
						else
						s_colorlinecntr <= s_colorlinecntr + 1;
						end if;

					-- New Line
					when NEWLINE =>
						s_rgb <= "111100000000";
						s_linecntr <= 1;
						s_colorlinecntr <= 1;
						s_rowcntr <= s_rowcntr + 1;

						if rgb_enable_i = '1' then
							s_state <= RED;
						end if;
				end case;
			end if;
		end if;
	end process p_pattern_2;

	-- Write Internal RGB Signal to Output
	rgb_o <= s_rgb;

end patterngenerator_2_architecture;

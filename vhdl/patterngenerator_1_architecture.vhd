-- Design: Patterngenerator 1 Architecture                                   --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 18.05.2018                                                         --
-- File : patterngenerator_1_architecture.vhd                                --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

architecture patterngenerator_1_architecture of patterngenerator_1_entity is
	signal s_rgb	: std_logic_vector(11 downto 0);	-- Internal RGB Signal

begin

	-----------------------------------------------------------------------------
	-- Pattern 1 Generator
	-----------------------------------------------------------------------------
	p_pattern_1 : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_rgb <= "000000000000";

		elsif clk_i'event and clk_i = '1' then

			-- RED Pixel Area
			if	(h_sync_counter_i >= "000000000001" and		-- 1
						h_sync_counter_i < "000000101001") or		-- 41
					(h_sync_counter_i >= "000010100001" and		-- 161
						h_sync_counter_i < "000011001001") or		-- 201
					(h_sync_counter_i >= "000101000001" and		-- 321
						h_sync_counter_i < "000101101001") or		-- 361
					(h_sync_counter_i >= "000111100001" and		-- 481
						h_sync_counter_i < "001000001001") then	-- 521

				s_rgb <= "111100000000";

			-- GREEN Pixel Area
			elsif	(h_sync_counter_i >= "000000101001" and		-- 41
							h_sync_counter_i < "000001010001") or		-- 81
						(h_sync_counter_i >= "000011001001" and		-- 201
							h_sync_counter_i < "000011110001") or		-- 241
						(h_sync_counter_i >= "000101101001" and		-- 361
							h_sync_counter_i < "000110010001") or		-- 401
						(h_sync_counter_i >= "001000001001" and		-- 521
							h_sync_counter_i < "001000110001") then	-- 561

				s_rgb <= "000011110000";

			-- BLUE Pixel Area
			elsif	(h_sync_counter_i >= "000001010001" and		-- 81
							h_sync_counter_i < "000001111001") or		-- 121
						(h_sync_counter_i >= "000011110001" and		-- 241
							h_sync_counter_i < "000100011001") or		-- 281
						(h_sync_counter_i >= "000110010001" and		-- 401
							h_sync_counter_i < "000110111001") or		-- 441
						(h_sync_counter_i >= "001000110001" and		-- 561
							h_sync_counter_i < "001001011001") then	-- 601

				s_rgb <= "000000001111";

			-- BLACK Pixel Area
			elsif	(h_sync_counter_i >= "000001111001" and		-- 121
							h_sync_counter_i < "000010100001") or		-- 161
						(h_sync_counter_i >= "000100011001" and		-- 281
							h_sync_counter_i < "000101000001") or		-- 321
						(h_sync_counter_i >= "000110111001" and		-- 441
							h_sync_counter_i < "000111100001") or		-- 481
						(h_sync_counter_i >= "001001011001" and		-- 601
							h_sync_counter_i < "001010000001") then	-- 641

				s_rgb <= "000000000000";
			end if;
		end if;
	end process p_pattern_1;

	-- Write Internal RGB Signal to Output
	rgb_o <= s_rgb;

end patterngenerator_1_architecture;

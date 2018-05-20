-------------------------------------------------------------------------------
-- Design: Source Multiplexer Architecture                                   --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 07.05.2018                                                         --
-- File : source_multiplex_architecture.vhd                                  --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture source_multiplexer_architecture of source_multiplexer_entity is
	signal s_rgb		: std_logic_vector(11 downto 0);	-- Internal Signal for the RGB

begin


	-----------------------------------------------------------------------------
	-- Use one RGB Source for Output
	-----------------------------------------------------------------------------
	p_multiplex : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_rgb <= "000000000000";

		elsif clk_i'event and clk_i = '1' then
			-- If SW2 (2) is 0 (No Moveable Object)
			if swsync_i(2) = '0' then
				case swsync_i(1 downto 0) is
					when "00" => s_rgb <= pattern_1_rgb_i;
					when "10" => s_rgb <= pattern_2_rgb_i;
					--when "01" => s_rgb <= mem_1_rgb_i;
					when others => s_rgb <= pattern_1_rgb_i;
				end case;
			end if;

			-- If SW2 (2) is 1 (Moveable Object)
			if swsync_i(2) = '1' then
				case swsync_i(1 downto 0) is
					when "00" => s_rgb <= pattern_1_rgb_i;
					when "10" => s_rgb <= pattern_2_rgb_i;
					--when "01" => s_rgb <= mem_1_rgb_i;
					when others => s_rgb <= pattern_1_rgb_i;
				end case;
			end if;
		end if;
	end process p_multiplex;

	rgb_o <= s_rgb;	-- Write defined pattern RGB input to RGB output
end source_multiplexer_architecture;

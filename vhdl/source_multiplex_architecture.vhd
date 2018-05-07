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
	signal s_rgb		: std_logic_vector(11 downto 0)		-- Internal Signal for the RGB
	signal s_ss_sel	: std_logic_vector(1 downto 0)		-- Switch signal (from IO Logic)

begin

	-----------------------------------------------------------------------------
	-- Use one RGB Source for Output
	-----------------------------------------------------------------------------
	p_multiplex : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_rgb <= "000000000000";
			s_ss_sel <= "00";

		elsif clk_i'event and clk_i = '1' then
			case s_ss_sel is
				when "00" => s_rgb <= pattern_1_rgb_i;
				when "01" => s_rgb <= pattern_2_rgb_i;
				when "10" => s_rgb <= mem_1_rgb_i;
				when "11" => s_rgb <= mem_2_rgb_i;
				when others => s_rgb <= pattern_1_rgb_i;
			end case;
		end if;
	end process p_multiplex;

	rgb_o <= s_rgb;	-- Write defined pattern RGB input to RGB output
end source_multiplexer_architecture;
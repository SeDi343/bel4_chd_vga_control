-------------------------------------------------------------------------------
-- Design: Source Multiplexer Entity                                         --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 07.05.2018                                                         --
-- File : source_multiplex_entity.vhd                                        --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity source_multiplexer_entity is
	port(	clk_i						:  in std_logic;											-- System Clock (100MHz)
				reset_i					:  in std_logic;											-- Asynchronous reset (BTNC)
				swsync_i				:  in std_logic_vector(2 downto 0);		-- State of debounced switches (from IO Logic)
				pbsync_i				:  in std_logic_vector(3 downto 0);		-- State of debounced push buttons (from IO Logic)
				pattern_1_rgb_i	:  in std_logic_vector(11 downto 0);	-- RGB input (from Patern Generator 1)
				pattern_2_rgb_i	:  in std_logic_vector(11 downto 0);	-- RGB input (from Patern Generator 2)
				--mem_1_rgb_i			:  in std_logic_vector(11 downto 0);	-- RGB input (from Memory 1)
				--mem_2_rgb_i			:  in std_logic_vector(11 downto 0);	-- RGB input (from Memory 2)
				rgb_o						: out std_logic_vector(11 downto 0));	-- Multiplexed RGB output depend on switch input (to VGA Control)
end source_multiplexer_entity;

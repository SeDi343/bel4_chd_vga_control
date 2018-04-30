-------------------------------------------------------------------------------
-- Design: VGA Control Entity                                                --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 09.04.2018                                                         --
-- File : vga_control_entity.vhd                                             --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity vga_control_entity is
	port(	clk_i				:  in std_logic;											-- System Clock (100MHz)
				reset_i			:  in std_logic;											-- Asynchronous reset (BTNC)
				en_25mhz_i	:  in std_logic;											-- Pixel Enable (25MHz) (from Prescaler)
				rgb_i				:  in std_logic_vector(11 downto 0);	-- RGB Color (from Source Multiplexer)
				rgb_o				: out std_logic_vector(11 downto 0);	-- RGB Color (to VGA) with sync
				h_sync_o		: out std_logic;											-- H-Sync
				v_sync_o		: out std_logic);											-- V-Sync
end vga_control_entity;

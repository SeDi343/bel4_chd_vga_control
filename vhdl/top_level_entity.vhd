-------------------------------------------------------------------------------
-- Design: Top Level Entity                                                  --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 19.05.2018                                                         --
-- File : top_level_entity.vhd                                               --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity top_level_entity is
	port (	clk_i						:  in std_logic;											-- System Clock (100MHz))
					reset_i					:  in std_logic;											-- Asynchronous reset (BTNC)
					sw_i						:  in std_logic_vector(2 downto 0);		-- State of 3 switches (from FPGA board)
					pb_i						:  in std_logic_vector(3 downto 0);		-- State of 4 push buttons (from FPGA board)
					rgb_o						: out std_logic_vector(11 downto 0);	-- RGB Color
					h_sync_o				: out std_logic;											-- H-Sync
					v_sync_o				: out std_logic);											-- V-Sync
end top_level_entity;

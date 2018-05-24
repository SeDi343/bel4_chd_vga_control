-------------------------------------------------------------------------------
-- Design: Memory Control 2 Entity                                           --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 22.05.2018                                                         --
-- File : memory_control_2_entity.vhd                                        --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity memory_control_2_entity is
	port(	clk_i							:  in std_logic;											-- System Clock (100MHz)
				reset_i						:  in std_logic;											-- Asynchronous reset (BTNC)
				en_25mhz_i				:  in std_logic;											-- Pixel Enable (25MHz) (from Prescaler)
				h_sync_counter_i	:  in std_logic_vector(9 downto 0);		-- H-Sync Counter
				v_sync_counter_i	:  in std_logic_vector(9 downto 0);		-- V-Sync Counter
				object_i					:  in std_logic;											-- Object
				change_i					:  in std_logic;											-- Change state
				rgb_o							: out std_logic_vector(11 downto 0));	-- RGB Output Stream (to Source Multiplex)
end memory_control_2_entity;

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
				object_i					:  in std_logic;											-- Object
				rgb_o							: out std_logic_vector(11 downto 0));	-- RGB Output Stream (to Source Multiplex)
end memory_control_2_entity;

-------------------------------------------------------------------------------
-- Design: Patterngenerator 1 Entity                                         --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 18.05.2018                                                         --
-- File : patterngenerator_1_entity.vhd                                      --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity patterngenerator_1_entity is
	port(	clk_i						:  in std_logic;											-- System Clock (100MHz)
				reset_i					:  in std_logic;											-- Asynchronous reset (BTNC)
				en_25mhz_i			:  in std_logic;											-- Pixel Enable (25MHz) (from Prescaler)
				rgb_enable_i		:  in std_logic;											-- RGB Stream Enable (from VGA Control)
				rgb_o						: out std_logic_vector(11 downto 0));	-- RGB Output Stream (to Source Multiplex)
end patterngenerator_1_entity;

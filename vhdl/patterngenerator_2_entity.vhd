-------------------------------------------------------------------------------
-- Design: Patterngenerator 2 Entity                                         --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 19.05.2018                                                         --
-- File : patterngenerator_2_entity.vhd                                      --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity patterngenerator_2_entity is
	port(	clk_i							:  in std_logic;											-- System Clock (100MHz)
				reset_i						:  in std_logic;											-- Asynchronous reset (BTNC)
				h_sync_counter_i	:  in std_logic_vector(9 downto 0);		-- H-Sync Counter
				v_sync_counter_i	:  in std_logic_vector(9 downto 0);		-- V-Sync Counter
				rgb_o							: out std_logic_vector(11 downto 0));	-- RGB Output Stream (to Source Multiplex)
end patterngenerator_2_entity;

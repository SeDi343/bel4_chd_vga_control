-------------------------------------------------------------------------------
-- Design: Prescaler Entity                                                  --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 09.04.2018                                                         --
-- File : prescaler_entity.vhd                                               --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity prescaler_entity is
	port(	clk_i				: in std_logic;				-- System Clock (100MHz)
				reset_i			: in std_logic;				-- Asynchronous reset (BTNC)
				en_25mhz_o	: out std_logic);			-- Pixel Enable (25MHz)
end prescaler_entity;

-------------------------------------------------------------------------------
-- Design: I/O Logic Entity                                                  --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 30.04.2018                                                         --
-- File : io_logic_entity.vhd                                                --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity io_logic_entity is
	port(	clk_i				:  in std_logic;											-- System Clock (100MHz)
				reset_i			:  in std_logic;											-- Asynchronous reset (BTNC)
				sw_i				:  in std_logic_vector(2 downto 0);		-- State of 3 switches (from FPGA board)
				pb_i				:  in std_logic_vector(3 downto 0);		-- State of 4 push buttons (from FPGA board)
				swsync_o		: out std_logic_vector(2 downto 0);		-- State of 3 debounced switches (to Source Multiplex)
				pbsync_o		: out std_logic_vector(3 downto 0));	-- State of 4 debounced push buttons (to Source Multiplex)
end io_logic_entity;

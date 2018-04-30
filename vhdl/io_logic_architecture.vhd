-------------------------------------------------------------------------------
-- Design: I/O Logic Architecture                                            --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 30.04.2018                                                         --
-- File : io_logic_architecture.vhd                                          --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture io_logic_architecture of io_logic_entity is
	constant C_ENCOUNTVAL		: std_logic_vector(16 downto 0) := "11000011010100000";	-- 1kHz

	signal s_enctr   : std_logic_vector(16 downto 0);	-- Counter for Debouncing
	signal s_1khzen  : std_logic;											-- 1kHz enable Signal
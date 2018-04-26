-------------------------------------------------------------------------------
-- Design: Testbench VGA Control                                             --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 26.04.2018                                                         --
-- File : tb_vga_control.vhd                                                 --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_vga_control_entity is
end tb_vga_control_entity;

architecture tb_vga_control_architecture of tb_vga_control_entity is
	component vga_control_entity
	port(	clk_i				: in std_logic;												-- System Clock (100MHz)
				reset_i			: in std_logic;												-- Asynchronous reset (BTNC)
				en_25mhz_i	: in std_logic;												-- Pixel Enable (25MHz) from Prescaler
				rgb_i				: in std_logic_vector(11 downto 0);		-- RGB Colour from Source Multiplexer
				rgb_o				: out std_logic_vector(11 downto 0);	-- RGB Color to VGA with sync
				h_sync_o		: out std_logic;											-- H-Sync
				v_sync_o		: out std_logic);											-- V-Sync
	end component;

	signal clk_i				: std_logic := '0';
	signal reset_i			: std_logic := '1';
	signal en_25mhz_i		: std_logic := '0';
	signal rgb_i				: std_logic_vector(11 downto 0) := "111111111111";

begin

	clk_i <= not(clk_i) after 5 ns;					-- 100MHz (10ns)
	reset_i <= '0' after 20 ns;

	i_vga_control_entity : vga_control_entity
	port map
	(	clk_i 			=> clk_i,
		reset_i			=> reset_i,
		en_25mhz_i	=> en_25mhz_i,
		rgb_i				=> rgb_i);

		p_test : process
		begin
			en_25mhz_i <= '1';
			wait for 10 ns;
			en_25mhz_i <= '0';
			wait for 30 ns;
		end process p_test;
end tb_vga_control_architecture;
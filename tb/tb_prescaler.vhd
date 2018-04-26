-------------------------------------------------------------------------------
-- Design: Testbench Prescaler                                               --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 26.04.2018                                                         --
-- File : tb_prescaler.vhd                                                   --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_prescaler_entity is
end tb_prescaler_entity;

architecture tb_prescaler_architecture of tb_prescaler_entity is
	component prescaler_entity
	port(	clk_i				: in std_logic;				-- System Clock (100MHz)
				reset_i			: in std_logic;				-- Asynchronous reset (BTNC)
				en_25mhz_o	: out std_logic);			-- Pixel Enable (25MHz)
	end component;

	signal clk_i			: std_logic := '0';
	signal reset_i		: std_logic := '1';
	signal en_25mhz_o	: std_logic;

begin

	clk_i <= not(clk_i) after 5 ns;					-- 100MHz (10ns)
	reset <= '0' after 20 ns;

	i_prescaler_entity : prescaler_entity
	port map
		(	clk_i				=> clk_i,
			reset_i			=> reset_i,
			en_25mhz_o	=> en_25_mhz_o);

	p_test : process
	begin
		wait for 500 ns;
	end process p_test;
end tb_prescaler_architecture;
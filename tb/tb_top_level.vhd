-------------------------------------------------------------------------------
-- Design: Testbench Top Level                                               --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 19.05.2018                                                         --
-- File : tb_top_level.vhd                                                   --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_top_level_entity is
end tb_top_level_entity;

architecture tb_top_level_architecture of tb_top_level_entity is
	component top_level_entity
	port (	clk_i						:  in std_logic;											-- System Clock (100MHz))
					reset_i					:  in std_logic;											-- Asynchronous reset (BTNC)
					sw_i						:  in std_logic_vector(2 downto 0);		-- State of 3 switches (from FPGA board)
					pb_i						:  in std_logic_vector(3 downto 0);		-- State of 4 push buttons (from FPGA board)
					rgb_o						: out std_logic_vector(11 downto 0);	-- RGB Color
					h_sync_o				: out std_logic;											-- H-Sync
					v_sync_o				: out std_logic);											-- V-Sync
	end component;

	signal clk_i			: std_logic := '0';
	signal reset_i		: std_logic := '1';
	signal sw_i				: std_logic_vector(2 downto 0);
	signal pb_i				: std_logic_vector(3 downto 0);
	signal rgb_o			: std_logic_vector(11 downto 0);
	signal h_sync_o		: std_logic;
	signal v_sync_o		: std_logic;

begin

	clk_i <= not(clk_i) after 5 ns;					-- 100MHz (10ns)
	reset_i <= '0' after 20 ns;

	i_top_level_entity : top_level_entity
	port map(	clk_i			=> clk_i,
						reset_i		=> reset_i,
						sw_i			=> sw_i,
						pb_i			=> pb_i,
						rgb_o			=> rgb_o,
						h_sync_o	=> h_sync_o,
						v_sync_o	=> v_sync_o);

	p_test : process
	begin
		if reset_i = '1' then
			sw_i <= "000";
			pb_i <= "0000";
		end if;
		--wait for 1 sec;
		--sw_i <= "010";
		wait for 1 sec;
	end process p_test;

end tb_top_level_architecture;

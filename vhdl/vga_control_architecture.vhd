-------------------------------------------------------------------------------
-- Design: VGA Control Architecture                                          --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 09.04.2018                                                         --
-- File : vga_control_architecture.vhd                                       --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture vga_control_architecture of vga_control_entity is
	-- Constants for the h-ysnc timing
	constant H_WHOLE_LINE			: std_logic_vector(9 downto 0) := "1100100000";	-- Whole Line		| 800
	constant H_FRONT_PORCH		: std_logic_vector(4 downto 0) := "10000";			-- Front Porch	| 16
	constant H_H_SYNC_PULSE		: std_logic_vector(6 downto 0) := "1100000";		-- H-Sync Pulse	| 96
	constant H_BACK_PORCH			: std_logic_vector(5 downto 0) := "110000";			-- Back Porch		| 48
	constant H_VISIBLE_AREA		: std_logic_vector(9 downto 0) := "1010000000";	-- Visible Area	| 640
	-- Constants for the v-sync timing
	constant V_WHOLE_LINE			: std_logic_vector(9 downto 0) := "1000001101";	-- Whole Line		| 525
	constant V_FRONT_PORCH		: std_logic_vector(3 downto 0) := "1010";				-- Front Porch	| 10
	constant V_V_SYNC_PULSE		: std_logic_vector(1 downto 0) := "10";					-- V-Sync Pulse	| 2
	constant V_BACK_PORCH			: std_logic_vector(5 downto 0) := "100001";			-- Back Porch		| 33
	constant V_VISIBLE_AREA		: std_logic_vector(8 downto 0) := "111100000";	-- Visible Area | 480

	signal s_h_sync						: std_logic;											-- H-Sync Signal
	signal s_v_sync						: std_logic;											-- V-Sync Signal
	signal s_rgb							: std_logic_vector(11 downto 0);	-- Signal RGB

	signal s_enctr_h_sync			: std_logic_vector(9 downto 0);		-- Counter for H-Sync
	signal s_enctr_v_sync			: std_logic_vector(9 downto 0);		-- Counter for V-Sync
	signal s_pixel_enable			: std_logic;											-- Internal Pixel-Enable Signal

begin

	-----------------------------------------------------------------------------
	-- Counters for H-Sync and V-Sync
	-----------------------------------------------------------------------------
	p_counter : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_pixel_enable <= '0';
			s_enctr_h_sync <= "0000000000";
			s_enctr_v_sync <= "0000000000";
			s_h_sync <= '0';
			s_v_sync <= '0';
			s_rgb <= "000000000000";

		elsif clk_i'event and clk_i = '1' then
			-- Get Pixel Enable State from Prescaler
			-- and write it to the internal pixel enable signal
			s_pixel_enable <= en_25mhz_i;

			-- If Pixel Enable equals 1
			if s_pixel_enable = '1' then
				s_enctr_h_sync <= unsigned(s_enctr_h_sync) + '1';
				s_enctr_v_sync <= unsigned(s_enctr_v_sync) + '1';

				-- If Counter for H-Sync equals the Whole Line
				if s_enctr_h_sync = H_WHOLE_LINE then
					s_enctr_h_sync <= "0000000000";
				end if;

				-- If Counter for V-Sync equals the Whole Line
				if s_enctr_v_sync = V_WHOLE_LINE then
					s_enctr_v_sync <= "0000000000";
				end if;
			end if;
		end if;
	end process p_counter;

	v_sync_o <= s_v_sync;
	h_sync_o <= s_h_sync;
	rgb_o <= s_rgb;
end vga_control_architecture;

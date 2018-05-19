-------------------------------------------------------------------------------
-- Design: VGA Control Architecture                                          --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 09.04.2018                                                         --
-- File : vga_control_architecture.vhd                                       --
-------------------------------------------------------------------------------

-- Comment: may use the en_25mhz_i signal directly instead of writing it into an internal
--          Counters start at 1 going to 800 instead of 0 to 799
--          Signal
--          p_rgb_enable Verwende möglicherweise kein clocking 

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
	--signal s_rgb							: std_logic_vector(11 downto 0);	-- Signal RGB
	signal s_rgb_enable				: std_logic;											-- RGB Enable Signal for Pattern and Memory

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
			s_enctr_h_sync <= "0000000001";
			s_enctr_v_sync <= "0000000001";

		elsif clk_i'event and clk_i = '1' then
			-- Get Pixel Enable State from Prescaler
			-- and write it to the internal pixel enable signal
			s_pixel_enable <= en_25mhz_i;

			-- If Pixel Enable equals 1
			if s_pixel_enable = '1' then
				-- Increment the H-Sync Counter with every pixel enable signal
				s_enctr_h_sync <= unsigned(s_enctr_h_sync) + '1';

				-- If Counter for H-Sync equals the Whole Line
				if s_enctr_h_sync = H_WHOLE_LINE then
					s_enctr_h_sync <= "0000000001";

					-- Increment the V-Sync Counter with every new line of the H-Sync Counter
					s_enctr_v_sync <= unsigned(s_enctr_v_sync) + '1';
				end if;

				-- If Counter for V-Sync equals the Whole Line
				if s_enctr_v_sync = V_WHOLE_LINE then
					s_enctr_v_sync <= "0000000001";
				end if;
			end if;
		end if;
	end process p_counter;

	-----------------------------------------------------------------------------
	-- Timing for H-Sync
	-----------------------------------------------------------------------------
	p_h_sync_timing : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_h_sync <= '0';

		elsif clk_i'event and clk_i = '1' then
			-- If Counter for H-Sync equals the Start
			if s_enctr_h_sync = "0000000001" then
				s_h_sync <= '1';
			end if;

			-- If Counter for H-Sync equals the H-Sync Pulse
			if s_enctr_h_sync = H_H_SYNC_PULSE then
				s_h_sync <= '0';
			end if;
		end if;
	end process p_h_sync_timing;

	-----------------------------------------------------------------------------
	-- Timing for V-Sync
	-----------------------------------------------------------------------------
	p_v_sync_timing : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_v_sync <= '0';

		elsif clk_i'event and clk_i = '1' then
			-- If Counter for V-Sync equals the Start
			if s_enctr_v_sync = "0000000001" then
				s_v_sync <= '1';
			end if;

			-- If Counter for V-Sync equals the V-Sync Pulse
			if s_enctr_v_sync = V_V_SYNC_PULSE then
				s_v_sync <= '0';
			end if;
		end if;
	end process p_v_sync_timing;

	-----------------------------------------------------------------------------
	-- RGB Enable Signal for Pattern and Memory
	-----------------------------------------------------------------------------
	p_rgb_enable : process(clk_i, reset_i)
	begin
		if reset = '1' then
			-- Reset System
			s_rgb_enable <= '0';

		elsif clk_i'event and clk_i = '1' then
			-- RGB Enable always 0
			s_rgb_enable <= '0';

			-- If Counter for V-Sync euqlas the V-Sync Visible area
			if s_enctr_v_sync >= (V_V_SYNC_PULSE + V_BACK_PORCH) and s_enctr_v_sync < (V_WHOLE_LINE - V_FRONT_PORCH) then
				-- If Counter for H-Sync euqls the H-Sync Visible area
				if s_enctr_h_sync >= (H_H_SYNC_PULSE + H_BACK_PORCH) and s_enctr_h_sync < (H_WHOLE_LINE - H_FRONT_PORCH) then
					s_rgb_enable <= '1';
				end if;
			end if;
		end if;
	end process p_rgb_enable;

	v_sync_o <= s_v_sync;					-- Write V-Sync to output
	h_sync_o <= s_h_sync;					-- Write H-Sync to output
	rgb_o <= rgb_i;								-- Write RGB inputs to output
	rgb_enable_o <= s_rgb_enable;	-- Write RGB Enable to output
end vga_control_architecture;

-------------------------------------------------------------------------------
-- Design: Source Multiplexer Architecture                                   --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 07.05.2018                                                         --
-- File : source_multiplex_architecture.vhd                                  --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

architecture source_multiplexer_architecture of source_multiplexer_entity is
	type t_state	is (BACKGROUND, OBJECT);

	constant OSIZE				: integer := 100;									-- Object Size

	signal s_rgb					: std_logic_vector(11 downto 0);	-- Internal Signal for the RGB
	signal s_pbstate_l		: std_logic_vector(1 downto 0);		-- Button state BTNL (press and release Button)
	signal s_pbstate_r		: std_logic_vector(1 downto 0);		-- Button state BTNR (press and release Button)
	signal s_pbstate_u		: std_logic_vector(1 downto 0);		-- Button state BTNU (press and release Button)
	signal s_pbstate_d		: std_logic_vector(1 downto 0);		-- Button state BTND (press and release Button)
	signal s_x_dir				: integer;												-- X Direction
	signal s_y_dir				: integer;												-- Y Direction
	signal s_switch				: std_logic;											-- Switch between Background and Object
	signal s_activate			: std_logic;											-- Activate Countering of Memory 2
	signal s_change				: std_logic;											-- Position has been changed, for memcontrol
	signal s_state				: t_state;												-- Switch between Background and Object state

begin


	-----------------------------------------------------------------------------
	-- Use one RGB Source for Output
	-----------------------------------------------------------------------------
	p_multiplex : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_rgb <= "000000000000";
			s_switch <= '0';
			s_activate <= '0';
			s_state <= BACKGROUND;

		elsif clk_i'event and clk_i = '1' then
			-- If SW2 (2) is 0 (No Moveable Object)
			if swsync_i(2) = '0' then
				case swsync_i(1 downto 0) is
					when "00" => s_rgb <= pattern_1_rgb_i;
					when "10" => s_rgb <= pattern_2_rgb_i;
					when "01" => s_rgb <= mem_1_rgb_i;
					when others => s_rgb <= mem_1_rgb_i;
				end case;
			end if;

			-- If SW2 (2) is 1 (Moveable Object)
			if swsync_i(2) = '1' then
				case s_state is
					when BACKGROUND =>
						case swsync_i(1 downto 0) is
							when "00" => s_rgb <= pattern_1_rgb_i;
							when "10" => s_rgb <= pattern_2_rgb_i;
							when "01" => s_rgb <= mem_1_rgb_i;
							when others => s_rgb <= mem_1_rgb_i;
						end case;

						-- Check if Counters are in Object area
						if h_sync_counter_i = (s_x_dir) and (v_sync_counter_i = (s_y_dir + 1) or s_switch = '1') then
							s_activate <= '1';
						end if;
						if h_sync_counter_i = (s_x_dir + 1) and (v_sync_counter_i = (s_y_dir + 1) or s_switch = '1') then
							s_switch <= '1';
							s_state <= OBJECT;
						end if;

					when OBJECT =>
						s_rgb <= mem_2_rgb_i;
						-- If Object Pixel Counter X equals 100
						if h_sync_counter_i = (s_x_dir + OSIZE) then
							s_activate <= '0';
						end if;
						if h_sync_counter_i = (s_x_dir + OSIZE + 1) then
							s_state <= BACKGROUND;
						end if;

						-- If Object Pixel Counter Y equals 100
						if v_sync_counter_i = (s_y_dir + OSIZE) then
							s_switch <= '0';
						end if;
				end case;
			end if;
		end if;
	end process p_multiplex;

	-----------------------------------------------------------------------------
	-- Button Input recognition
	-----------------------------------------------------------------------------
	p_buttons : process(clk_i, reset_i)
	variable v_temp_dir : integer; -- Value check variable
	begin
		if reset_i = '1' then
			s_pbstate_l <= "00";
			s_pbstate_r <= "00";
			s_pbstate_u <= "00";
			s_pbstate_d <= "00";
			v_temp_dir := 0;
			s_x_dir <= 270;
			s_y_dir <= 180;

		elsif clk_i'event and clk_i = '1' then
			s_change <= '0';

			if s_switch = '0' then
				-- If Button BTNL is pressed
				if pbsync_i = "1000" and s_pbstate_l = "00" then
					s_pbstate_l <= "01";
				end if;
				if pbsync_i = "0000" and s_pbstate_l = "01" then
					s_pbstate_l <= "11";
				end if;
				if s_pbstate_l = "11" then
					s_pbstate_l <= "00";
					-- Move moving Object on X Axis 30px to the left
					v_temp_dir := s_x_dir;
					if v_temp_dir - 30 > 0 then
						s_x_dir <= s_x_dir - 30;
						s_change <= '1';
					end if;
				end if;

				-- If Button BTNR is pressed
				if pbsync_i = "0100" and s_pbstate_r = "00" then
					s_pbstate_r <= "01";
				end if;
				if pbsync_i = "0000" and s_pbstate_r = "01" then
					s_pbstate_r <= "11";
				end if;
				if s_pbstate_r = "11" then
					s_pbstate_r <= "00";
					-- Move moving Object on X Axis 30px to the right
					v_temp_dir := s_x_dir;
					if v_temp_dir + OSIZE + 30 < 640 then
						s_x_dir <= s_x_dir + 30;
						s_change <= '1';
					end if;
				end if;

				-- If Button BTNU is pressed
				if pbsync_i = "0010" and s_pbstate_u = "00" then
					s_pbstate_u <= "01";
				end if;
				if pbsync_i = "0000" and s_pbstate_u = "01" then
					s_pbstate_u <= "11";
				end if;
				if s_pbstate_u = "11" then
					s_pbstate_u <= "00";
					-- Move moving Object on Y Axis 30px up
					v_temp_dir := s_y_dir;
					if v_temp_dir - 30 > 0 then
						s_y_dir <= s_y_dir - 30;
						s_change <= '1';
					end if;
				end if;

				-- If Button BTND is pressed
				if pbsync_i = "0001" and s_pbstate_d = "00" then
					s_pbstate_d <= "01";
				end if;
				if pbsync_i = "0000" and s_pbstate_d = "01" then
					s_pbstate_d <= "11";
				end if;
				if s_pbstate_d = "11" then
					s_pbstate_d <= "00";
					-- Move moving Object on Y Axis 30px down
					v_temp_dir := s_y_dir;
					if v_temp_dir + OSIZE + 30 < 480 then
						s_y_dir <= s_y_dir + 30;
						s_change <= '1';
					end if;
				end if;
			end if;
		end if;
	end process p_buttons;

	rgb_o <= s_rgb;					-- Write defined pattern RGB input to RGB output
	object_o <= s_activate;	-- Switch between Background and Object
	change_o <= s_change;		-- Connect the change state with output
end source_multiplexer_architecture;

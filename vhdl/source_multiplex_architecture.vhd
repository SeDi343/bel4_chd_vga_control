-------------------------------------------------------------------------------
-- Design: Source Multiplexer Architecture                                   --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 07.05.2018                                                         --
-- File : source_multiplex_architecture.vhd                                  --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture source_multiplexer_architecture of source_multiplexer_entity is
	signal s_rgb				: std_logic_vector(11 downto 0);	-- Internal Signal for the RGB
	signal s_pbstate_l	: std_logic_vector(1 downto 0);		-- Button state BTNL (press and release Button)
	signal s_pbstate_r	: std_logic_vector(1 downto 0);		-- Button state BTNR (press and release Button)
	signal s_pbstate_u	: std_logic_vector(1 downto 0);		-- Button state BTNU (press and release Button)
	signal s_pbstate_d	: std_logic_vector(1 downto 0);		-- Button state BTND (press and release Button)
	signal s_x_dir			: integer;												-- X Direction
	signal s_y_dir			: integer;												-- Y Direction

begin


	-----------------------------------------------------------------------------
	-- Use one RGB Source for Output
	-----------------------------------------------------------------------------
	p_multiplex : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_rgb <= "000000000000";

		elsif clk_i'event and clk_i = '1' then
			-- If SW2 (2) is 0 (No Moveable Object)
			if swsync_i(2) = '0' then
				case swsync_i(1 downto 0) is
					when "00" => s_rgb <= pattern_1_rgb_i;
					when "10" => s_rgb <= pattern_2_rgb_i;
					when "01" => s_rgb <= mem_1_rgb_i;
					when others => s_rgb <= pattern_1_rgb_i;
				end case;
			end if;

			-- If SW2 (2) is 1 (Moveable Object)
			if swsync_i(2) = '1' then
				case swsync_i(1 downto 0) is
					when "00" => s_rgb <= pattern_1_rgb_i;
					when "10" => s_rgb <= pattern_2_rgb_i;
					when "01" => s_rgb <= mem_2_rgb_i;
					when others => s_rgb <= pattern_1_rgb_i;
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
				if v_temp_dir - 30 >= 0 then
					s_x_dir <= s_x_dir - 30;
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
				if v_temp_dir + 100 + 30 <= 640 then
					s_x_dir <= s_x_dir + 30;
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
				if v_temp_dir - 30 >= 0 then
					s_y_dir <= s_y_dir - 30;
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
				if v_temp_dir + 100 + 30 <= 480 then
					s_y_dir <= s_y_dir + 30;
				end if;
			end if;
		end if;
	end process p_buttons;

	rgb_o <= s_rgb;	-- Write defined pattern RGB input to RGB output
end source_multiplexer_architecture;

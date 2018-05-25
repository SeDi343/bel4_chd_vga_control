-------------------------------------------------------------------------------
-- Design: Memory Control 2 Architecture                                     --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 22.05.2018                                                         --
-- File : memory_control_2_architecture.vhd                                  --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture memory_control_2_architecture of memory_control_2_entity is
	-- Import MEM2 ROM (generated via Xilinx Vivado IP Catalog/Block Memory Generator)
	component rom_mem2 is
	port (	clka	:  in std_logic;
					addra	:  in std_logic_vector(13 downto 0);
					douta	: out std_logic_vector(11 downto 0));
	end component;

	constant H_VISIBLE_AREA			: std_logic_vector(9 downto 0) := "1010000000";				-- Visible Area					| 640
	constant V_VISIBLE_AREA			: std_logic_vector(9 downto 0) := "0111100000";				-- Visible Area					| 480
	constant ROM_MAX_VALUE			: std_logic_vector(13 downto 0) := "10011100001111";	-- Rom max addr value		| 9999

	signal s_rom_addr					: std_logic_vector(13 downto 0);			-- Internal Address Signal
	signal s_rom_dout					: std_logic_vector(11 downto 0);			-- Internal Data Signal
	signal s_rgb							: std_logic_vector(11 downto 0);			-- Internal RGB Signal
	signal s_change				: std_logic;											-- Position has been changed, for memcontrol

begin

	i_rom_mem2 : rom_mem2
	port map(	clka		=> clk_i,
						addra		=> s_rom_addr,
						douta		=> s_rom_dout);

	-----------------------------------------------------------------------------
	-- Increment ROM Address if we are in Visible Area
	-----------------------------------------------------------------------------
	p_counter : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_rom_addr <= "00000000000000";

		elsif clk_i'event and clk_i = '1' then
			if object_i = '1' then
				-- If Counter for V-Sync is less or equals the V-Sync Visible area
				if v_sync_counter_i < V_VISIBLE_AREA then
					-- If Counter for H-Sync is less or equals the H-Sync Visible area
					if h_sync_counter_i <= H_VISIBLE_AREA then
						if en_25mhz_i = '1' then
							-- If Rom Address is on max value reset it otherwise increment it with 1
							if s_rom_addr = ROM_MAX_VALUE then
								s_rom_addr <= "00000000000000";
								s_change <= '1';
							else
								s_rom_addr <= unsigned(s_rom_addr) + '1';
								s_change <= '0';
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process p_counter;

	-----------------------------------------------------------------------------
	-- Put Data from ROM to RGB Output
	-----------------------------------------------------------------------------
	p_data : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_rgb <= "000000000000";

	elsif clk_i'event and clk_i = '1' then
		if object_i = '1' then
			-- If Counter for V-Sync is less or equals the V-Sync Visible area
			if v_sync_counter_i < V_VISIBLE_AREA then
				-- If Counter for H-Sync is less or equals the H-Sync Visible area
				if h_sync_counter_i <= H_VISIBLE_AREA then
					s_rgb <= s_rom_dout;
				end if;
			end if;
		end if;
	end if;
	end process p_data;

	rgb_o <= s_rgb;
	change_o <= s_change;		-- Connect the change state with output
end memory_control_2_architecture;

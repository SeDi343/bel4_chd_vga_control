-------------------------------------------------------------------------------
-- Design: Top Level Architecture                                            --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 19.05.2018                                                         --
-- File : top_level_architecture.vhd                                         --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture top_level_architecture of top_level_entity is

	-- VGA Monitor Simulator
	component vga_monitor
	port(	s_reset_i			:  in std_logic;
				s_vga_red_i		:  in std_logic_vector(3 downto 0);
				s_vga_green_i	:  in std_logic_vector(3 downto 0);
				s_vga_blue_i	:  in std_logic_vector(3 downto 0);
				s_vga_hsync_i	:  in std_logic;
				s_vga_vsync_i	:  in std_logic);
	end component;

	-- Prescaler
	component prescaler_entity
	port(	clk_i				:  in std_logic;	-- System Clock (100MHz)
				reset_i			:  in std_logic;	-- Asynchronous reset (BTNC)
				en_25mhz_o	: out std_logic);	-- Pixel Enable (25MHz)
	end component;

	-- IO Logic
	component io_logic_entity
	port(	clk_i				:  in std_logic;											-- System Clock (100MHz)
				reset_i			:  in std_logic;											-- Asynchronous reset (BTNC)
				sw_i				:  in std_logic_vector(2 downto 0);		-- State of 3 switches (from FPGA board)
				pb_i				:  in std_logic_vector(3 downto 0);		-- State of 4 push buttons (from FPGA board)
				swsync_o		: out std_logic_vector(2 downto 0);		-- State of 3 debounced switches (to Source Multiplex)
				pbsync_o		: out std_logic_vector(3 downto 0));	-- State of 4 debounced push buttons (to Source Multiplex)
	end component;

	-- VGA Control
	component vga_control_entity
	port(	clk_i							:  in std_logic;											-- System Clock (100MHz)
				reset_i						:  in std_logic;											-- Asynchronous reset (BTNC)
				en_25mhz_i				:  in std_logic;											-- Pixel Enable (25MHz) (from Prescaler)
				rgb_i							:  in std_logic_vector(11 downto 0);	-- RGB Colour (from Source Multiplexer)
				rgb_o							: out std_logic_vector(11 downto 0);	-- RGB Color
				h_sync_o					: out std_logic;											-- H-Sync
				v_sync_o					: out std_logic;											-- V-Sync
				h_sync_counter_o	: out std_logic_vector(9 downto 0);		-- H-Sync Counter
				v_sync_counter_o	: out std_logic_vector(9 downto 0));	-- V-Sync Counter
	end component;

	-- Source Mulitplexer
	component source_multiplexer_entity
	port(	clk_i							:  in std_logic;											-- System Clock (100MHz)
				reset_i						:  in std_logic;											-- Asynchronous reset (BTNC)
				swsync_i					:  in std_logic_vector(2 downto 0);		-- State of debounced switches (from IO Logic)
				pbsync_i					:  in std_logic_vector(3 downto 0);		-- State of debounced push buttons (from IO Logic)
				pattern_1_rgb_i		:  in std_logic_vector(11 downto 0);	-- RGB input (from Patern Generator 1)
				pattern_2_rgb_i		:  in std_logic_vector(11 downto 0);	-- RGB input (from Patern Generator 2)
				mem_1_rgb_i				:  in std_logic_vector(11 downto 0);	-- RGB input (from Memory 1)
				mem_2_rgb_i				:  in std_logic_vector(11 downto 0);	-- RGB input (from Memory 2)
				en_25mhz_i				:  in std_logic;											-- Pixel Enable (25MHz) (from Prescaler)
				h_sync_counter_i	:  in std_logic_vector(9 downto 0);		-- H-Sync Counter
				v_sync_counter_i	:  in std_logic_vector(9 downto 0);		-- V-Sync Counter
				object_o					: out std_logic;											-- Object
				rgb_o							: out std_logic_vector(11 downto 0));	-- Multiplexed RGB output depend on switch input (to VGA Control)
	end component;

	-- Patterngenerator 1
	component patterngenerator_1_entity
	port(	clk_i							:  in std_logic;											-- System Clock (100MHz)
				reset_i						:  in std_logic;											-- Asynchronous reset (BTNC)
				h_sync_counter_i	: in std_logic_vector(9 downto 0);		-- H-Sync Counter
				rgb_o							: out std_logic_vector(11 downto 0));	-- RGB Output Stream (to Source Multiplex)
	end component;

	-- Patterngenerator 2
	component patterngenerator_2_entity
	port(	clk_i							:  in std_logic;											-- System Clock (100MHz)
				reset_i						:  in std_logic;											-- Asynchronous reset (BTNC)
				h_sync_counter_i	:  in std_logic_vector(9 downto 0);		-- H-Sync Counter
				v_sync_counter_i	:  in std_logic_vector(9 downto 0);		-- V-Sync Counter
				rgb_o							: out std_logic_vector(11 downto 0));	-- RGB Output Stream (to Source Multiplex)
	end component;

	-- Memory Control 1
	component memory_control_1_entity
	port(	clk_i							:  in std_logic;											-- System Clock (100MHz)
				reset_i						:  in std_logic;											-- Asynchronous reset (BTNC)
				en_25mhz_i				:  in std_logic;											-- Pixel Enable (25MHz) (from Prescaler)
				h_sync_counter_i	:  in std_logic_vector(9 downto 0);		-- H-Sync Counter
				v_sync_counter_i	:  in std_logic_vector(9 downto 0);		-- V-Sync Counter
				rgb_o							: out std_logic_vector(11 downto 0));	-- RGB Output Stream (to Source Multiplex)
	end component;

	-- Memory Control 2
	component memory_control_2_entity
	port(	clk_i							:  in std_logic;											-- System Clock (100MHz)
				reset_i						:  in std_logic;											-- Asynchronous reset (BTNC)
				en_25mhz_i				:  in std_logic;											-- Pixel Enable (25MHz) (from Prescaler)
				object_i					:  in std_logic;											-- Object
				rgb_o							: out std_logic_vector(11 downto 0));	-- RGB Output Stream (to Source Multiplex)
	end component;

	-- Signals
	signal s_en_25mhz				: std_logic;
	signal s_h_sync_counter	: std_logic_vector(9 downto 0);
	signal s_v_sync_counter	: std_logic_vector(9 downto 0);
	signal s_rgb_p1_mux			: std_logic_vector(11 downto 0);
	signal s_rgb_p2_mux			: std_logic_vector(11 downto 0);
	signal s_rgb_m1_mux			: std_logic_vector(11 downto 0);
	signal s_rgb_m2_mux			: std_logic_vector(11 downto 0);
	signal s_rgb_mux_vga		: std_logic_vector(11 downto 0);
	signal s_rgb_vga_mon		: std_logic_vector(11 downto 0);
	signal s_swsync					: std_logic_vector(2 downto 0);
	signal s_pbsync					: std_logic_vector(3 downto 0);
	signal s_h_sync					: std_logic;
	signal s_v_sync					: std_logic;
	signal s_object					: std_logic;

begin

	i_vga_monitor : vga_monitor
	port map(	s_reset_i			=> reset_i,
						s_vga_red_i		=> s_rgb_vga_mon(11 downto 8),
						s_vga_green_i	=> s_rgb_vga_mon(7 downto 4),
						s_vga_blue_i	=> s_rgb_vga_mon(3 downto 0),
						s_vga_hsync_i	=> s_h_sync,
						s_vga_vsync_i => s_v_sync);

	i_prescaler_entity : prescaler_entity
	port map(	clk_i					=> clk_i,
						reset_i				=> reset_i,
						en_25mhz_o		=> s_en_25mhz);

	i_io_logic_entity : io_logic_entity
	port map(	clk_i			=> clk_i,
						reset_i		=> reset_i,
						sw_i			=> sw_i,
						pb_i			=> pb_i,
						swsync_o	=> s_swsync,
						pbsync_o	=> s_pbsync);

	i_vga_control_entity : vga_control_entity
	port map(	clk_i							=> clk_i,
						reset_i						=> reset_i,
						en_25mhz_i				=> s_en_25mhz,
						rgb_i							=> s_rgb_mux_vga,
						rgb_o							=> s_rgb_vga_mon,
						h_sync_o					=> s_h_sync,
						v_sync_o					=> s_v_sync,
						h_sync_counter_o	=> s_h_sync_counter,
						v_sync_counter_o	=> s_v_sync_counter);

	i_source_multiplexer_entity : source_multiplexer_entity
	port map(	clk_i							=> clk_i,
						reset_i						=> reset_i,
						swsync_i					=> s_swsync,
						pbsync_i					=> s_pbsync,
						pattern_1_rgb_i		=> s_rgb_p1_mux,
						pattern_2_rgb_i		=> s_rgb_p2_mux,
						mem_1_rgb_i				=> s_rgb_m1_mux,
						mem_2_rgb_i				=> s_rgb_m2_mux,
						en_25mhz_i				=> s_en_25mhz,
						h_sync_counter_i	=> s_h_sync_counter,
						v_sync_counter_i	=> s_v_sync_counter,
						object_o					=> s_object,
						rgb_o							=> s_rgb_mux_vga);

	i_patterngenerator_1_entity : patterngenerator_1_entity
	port map(	clk_i							=> clk_i,
						reset_i						=> reset_i,
						h_sync_counter_i	=> s_h_sync_counter,
						rgb_o							=> s_rgb_p1_mux);

	i_patterngenerator_2_entity : patterngenerator_2_entity
	port map(	clk_i							=> clk_i,
						reset_i						=> reset_i,
						h_sync_counter_i	=> s_h_sync_counter,
						v_sync_counter_i	=> s_v_sync_counter,
						rgb_o							=> s_rgb_p2_mux);

	i_memory_control_1_entity : memory_control_1_entity
	port map(	clk_i							=> clk_i,
						reset_i						=> reset_i,
						en_25mhz_i				=> s_en_25mhz,
						h_sync_counter_i	=> s_h_sync_counter,
						v_sync_counter_i	=> s_v_sync_counter,
						rgb_o							=> s_rgb_m1_mux);

	i_memory_control_2_entity : memory_control_2_entity
	port map(	clk_i							=> clk_i,
						reset_i						=> reset_i,
						en_25mhz_i				=> s_en_25mhz,
						object_i					=> s_object,
						rgb_o							=> s_rgb_m2_mux);

	rgb_o <= s_rgb_vga_mon;
	h_sync_o <= s_h_sync;
	v_sync_o <= s_v_sync;

end top_level_architecture;

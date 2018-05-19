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
	--constant C_ENCOUNTVAL		: std_logic_vector(16 downto 0) := "11000011010100000";	-- 1kHz
	constant C_ENCOUNTVAL		: std_logic_vector(17 downto 0) := "110000110101000000";	-- 500Hz

	signal s_enctr		: std_logic_vector(17 downto 0);	-- Counter for Debouncing
	signal s_500hzen	: std_logic;											-- 500Hz enable Signal
	signal swsync			: std_logic_vector(2 downto 0);		-- Debounced Switches signal
	signal pbsync			: std_logic_vector(3 downto 0);		-- Debounced push buttions signal

begin

	-----------------------------------------------------------------------------
	-- Generate the 500 Hz enable Signal
	-----------------------------------------------------------------------------
	p_500hzen : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_500hzen <= '0';
			s_enctr <= "000000000000000001";

		elsif clk_i'event and clk_i = '1' then
			-- Enable signal is inactive per default
			-- As long as the terminal count is not reached: increment the counter
			-- When the terminal count is reached, set enable signal and reset the counter

			-- 500hz signal allways low
			s_500hzen <= '0';

			-- If counter equals the requested value else increment the counter
			if s_enctr = C_ENCOUNTVAL then
				s_500hzen <= '1';
				s_enctr <= "000000000000000001";
			else
				s_enctr <= unsigned(s_enctr) + '1';
			end if;
		end if;
	end process p_500hzen;

	-----------------------------------------------------------------------------
	-- Debounce buttons and switches
	-----------------------------------------------------------------------------
	p_debounce : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			swsync <= "000";
			pbsync <= "0000";

		elsif clk_i'event and clk_i = '1' then
			-- The switches and buttons are debounced and forwarded to internal singals
			-- Both tasks are synchronous to the previously generated 500Hz enable signal

			-- If the 500Hz signal is high put input of buttons and switches to signal
			if s_500hzen = '1' then
				swsync <= sw_i;
				pbsync <= pb_i;
			end if;
		end if;
	end process p_debounce;

	swsync_o <= swsync;	-- Write debounced switches singal to output
	pbsync_o <= pbsync;	-- Write debounced push buttons signal to output
end io_logic_architecture;

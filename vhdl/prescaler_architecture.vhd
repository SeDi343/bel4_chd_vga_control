-------------------------------------------------------------------------------
-- Design: Prescaler Architecture                                            --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 09.04.2018                                                         --
-- File : prescaler_architecture.vhd                                         --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture prescaler_architecture of prescaler_entity is
	-- Constant value for the 25MHz enable signal for the counter
	constant C_ENCOUNTVAL	: std_logic_vector(1 downto 0) := "11";

	signal s_enctr				: std_logic_vector(1 downto 0);	-- Counter
	signal s_25mhz				: std_logic;										-- 25MHz enable signal

begin

	-----------------------------------------------------------------------------
	-- Generate the 25MHz enable signal
	-----------------------------------------------------------------------------
	p_s25mhz : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_25mhz <= '0';
			s_enctr <= "00";

		elsif clk_i'event and clk_i = '1' then
			-- Enable Signal is inactive per default
			-- Increment the counter as long as the constant value is not reached.
			-- When the constant value is reached, set enable signal and reset the
			-- counter.

			-- 25MHz signal allways low
			s_25mhz <= '0';

			-- If counter equals the constant value / Else increment the counter
			if s_enctr = C_ENCOUNTVAL then
				s_25mhz <= '1';
				s_enctr <= "00";

			else
				s_enctr <= unsigned(s_enctr) + '1';
			end if;
		end if;
	end process p_s25mhz;

	en_25mhz_o <= s_25mhz;
end prescaler_architecture;

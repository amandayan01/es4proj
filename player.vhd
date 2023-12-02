library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity player is 
	port (
		-- take in nes controller as input
		player_top : out unsigned(9 downto 0);
		player_bottom : out unsigned(9 downto 0);
		player_left : out unsigned(9 downto 0);
		player_right : out unsigned(9 downto 0)
	);
end player;

architecture synth of player is
begin
	process(clk60) begin 
		if rising_edge(clk60) then
			player_left <= (car_left + 1) mod 640;
			player_right <= (car_right + 1) mod 640;
		end if;
	end process;
end;;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity collision is
	port (
		clk60 : in std_logic;
		player_top : in unsigned(9 downto 0);
		player_bottom : in unsigned(9 downto 0);
		player_left : in unsigned(9 downto 0);
		player_right : in unsigned(9 downto 0);
		car_top : in unsigned(9 downto 0);
		car_bottom : in unsigned(9 downto 0);
		car_left : in unsigned(9 downto 0);
		car_right : in unsigned(9 downto 0);
		rgb : out unsigned(5 downto 0)
		-- TODO : figure out collisions with colors
		-- probs with rgb_car and rgb_player
		-- check that they are equal 
		-- and if so, that means the same pixel is being set to two different colors so there is a collision
	);
end collision;

architecture synth of collision is
begin 
	process(clk60) begin 
		if rising_edge(clk60) then 
			if (player_right = car_left) then 
				rgb <= "110000";
			elsif (player_bottom = car_top) then 
			-- change to object_top = car_bottom if player is moving up the screen
				rgb <= "000011";
			elsif (player_left = car_right) then
				rgb <= "110011";
			--else 
				--rgb <= "101010";
			end if;
		end if;
	end process;
end;
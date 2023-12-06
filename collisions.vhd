library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity collisions is 
	port (
		player_x : in unsigned(9 downto 0);
		player_y : in unsigned(9 downto 0);
		car_x : in unsigned(9 downto 0);
		car_y : in unsigned(9 downto 0);
		collided : out std_logic
	);
end collisions;

architecture synth of collisions is

	signal player_width : unsigned(9 downto 0) := 10d"10";
	signal player_height : unsigned(9 downto 0) := 10d"10";
	signal car_height : unsigned(9 downto 0) := 10d"15";
	signal car_width : unsigned(9 downto 0) := 10d"20";
	
begin
	collided <= '1' when (((player_x < car_x + car_width) and (player_x + player_width > car_x)) and ((player_y + player_height > car_y) and (player_y < car_y + car_height))) else '0';
end;

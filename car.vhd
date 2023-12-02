library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity car is 
	port (
		clk60 : in std_logic;
		car_top : out unsigned(9 downto 0);
		car_bottom : out unsigned(9 downto 0);
		car_left : out unsigned(9 downto 0);
		car_right : out unsigned(9 downto 0)
	);
end car;

architecture synth of car is
begin
	process(clk60) begin 
		if rising_edge(clk60) then
			car_left <= (car_left + 1) mod 480;
			car_right <= (car_right + 1) mod 480;
		end if;
	end process;
end;
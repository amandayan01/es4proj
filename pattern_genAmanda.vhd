library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is 
	port (
		--int25clk : in std_logic;
		clk60 : in std_logic;
		row : in unsigned(9 downto 0);
		col : in unsigned(9 downto 0);
		valid : in std_logic;
		rgb : out unsigned(5 downto 0);
		
		-- player positions from the character module
		player_x : in unsigned(9 downto 0);
		player_y : in unsigned(9 downto 0)
	);
end pattern_gen;

architecture synth of pattern_gen is 

	signal counter : unsigned(30 downto 0) := 31d"0";
	signal fast_counter : unsigned(30 downto 0) := 31d"0";
	
	signal car_height : unsigned(9 downto 0) := 10d"15";
	signal car_width : unsigned(9 downto 0) := 10d"20";
	
	-- car 0
	signal car0_top : unsigned(9 downto 0) := 10d"35";
	signal car0_left : unsigned(9 downto 0) := 10d"5";

	-- car 1
	signal car1_top : unsigned(9 downto 0) := 10d"80";
	signal car1_left : unsigned(9 downto 0) := 10d"50";

	signal car2_top : unsigned(9 downto 0) := 10d"380";
	signal car2_left : unsigned(9 downto 0) := 10d"410";
	
	--signal car3_top : unsigned(9 downto 0) := 10d"380";
	--signal car3_left : unsigned(9 downto 0) := 10d"410";
	
	-- top green stripe on screen
	signal topG_top : unsigned(9 downto 0) := 10d"0";
	signal topG_bottom : unsigned(9 downto 0) := 10d"20";
	
	-- middle green stripe on screen
	signal midG_top : unsigned(9 downto 0) := 10d"220";
	signal midG_bottom : unsigned(9 downto 0) := 10d"260";
	
	-- bottom green stripe on screen
	signal botG_top : unsigned(9 downto 0) := 10d"460";
	signal botG_bottom : unsigned(9 downto 0) := 10d"480";
	
	signal player_width : unsigned(9 downto 0) := 10d"10";
	signal player_height : unsigned(9 downto 0) := 10d"10";
	
begin
	
	process(clk60) begin
		if rising_edge(clk60) then 
			counter <= counter + 1;
			fast_counter <= fast_counter + 3;
			
			-- gives multiple instances of the blocks -> so fast that so many appear on the screen?
			--x_left <= (x_left + counter) mod 640;
			--x_right <= (x_right + counter) mod 640;
			--y_top <= (y_top + counter) mod 480;
			--y_bottom <= (y_bottom + 1) mod 480;
		end if;
	end process;

	-- horizontal motion of a block across the screen
	process(all) begin 
		-- checking if within valid viewable region
		if (valid = '0') then 
			rgb <= "000000";
		else 
			-- top green stripe
			if ((row >= topG_top and row <= topG_bottom)) then
				rgb <= "001100";
			end if;
			
			-- middle green stripe
			if ((row >= midG_top and row <= midG_bottom)) then
				rgb <= "001100";
			end if;
			
			 --bottom green stripe
			if ((row >= botG_top and row <= botG_bottom)) then
				rgb <= "001100";
			end if;
			
			 --player
			if (row >= player_y mod 480) and (row <= (player_y + player_height) mod 480) and (col >= (player_x mod 640)) and (col <= (player_x + player_width) mod 640) then
				-- generate a block
				rgb <= "111111";
			--else 
				--rgb <= "010101";
			end if;	
			
			 --horizontal motion of cars
			if ((row >= car0_top) and (row <= car0_top + car_height) and ((col >= (car0_left + counter + 100) mod 640)) and (col <= ((car0_left + car_width + counter + 100) mod 640))) then
				   rgb <= "000011";
			end if;

			if ((row >= car1_top) and (row <= car1_top + car_height) and ((col >= (car1_left + fast_counter) mod 640)) and (col <= ((car1_left + car_width + fast_counter) mod 640))) then
				   rgb <= "000011";
			end if;
			
			if ((row >= car2_top) and (row <= car2_top + car_height) and ((col >= (car2_left - fast_counter) mod 640)) and (col <= ((car2_left + car_width - fast_counter) mod 640))) then
				   rgb <= "000011";
			end if;
			
			--if ((row >= car3_top) and (row <= car3_top + car_height) and ((col >= (car3_left - counter) mod 640)) and (col <= ((car3_left + car_width - counter) mod 640))) then
				   --rgb <= "110011";
			--end if;
				--rgb <= "010101";
		end if;
		
		-- if the player hits the top green stripe they win TODO: test this
		if (player_y <= 10d"20") then
			rgb <= "001100";
		end if;
		
		 --collision
		--if (rgb = "110011" and rgb = "111111") then
			--rgb <= "110000";
		--end if;
		
	end process;
end;
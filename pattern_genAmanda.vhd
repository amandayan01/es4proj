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
		
		--input from controller
		--controller_input : in unsigned(7 downto 0)
	);
end pattern_gen;

architecture synth of pattern_gen is
	component collisions is 
		port (
			player_x : in unsigned(9 downto 0);
			player_y : in unsigned(9 downto 0);
			car_x : in unsigned(9 downto 0);
			car_y : in unsigned(9 downto 0);
			collided : out std_logic
		);
	end component;


-- try to make counter less bits, so the ripple carry is smaller?
	signal counter : unsigned(9 downto 0) := 10d"0";
	signal fast_counter : unsigned(30 downto 0) := 31d"0";
	
	signal car_height : unsigned(9 downto 0) := 10d"15";
	signal car_width : unsigned(9 downto 0) := 10d"20";
	
	-- car 0
	signal car0_top : unsigned(9 downto 0) := 10d"35";
	signal car0_left : unsigned(9 downto 0) := 10d"5";
	signal car0_collided : std_logic;

	-- car 1
	signal car1_top : unsigned(9 downto 0) := 10d"80";
	signal car1_left : unsigned(9 downto 0) := 10d"50";
	signal car1_collided : std_logic;

	signal car2_top : unsigned(9 downto 0) := 10d"380";
	signal car2_left : unsigned(9 downto 0) := 10d"410";
	signal car2_collided : std_logic;
	
	signal car3_top : unsigned(9 downto 0) := 10d"320";
	signal car3_left : unsigned(9 downto 0) := 10d"350";
	signal car3_collided : std_logic;
	
	signal player_width : unsigned(9 downto 0) := 10d"10";
	signal player_height : unsigned(9 downto 0) := 10d"10";
	
	--signal win : std_logic := '0';
	--signal playing : std_logic := '1';
	
	--signal game_over : std_logic := '0';
	--signal start : std_logic := '0';
	
begin
	--start <= controller_input(4);
	
	car0_collision : collisions port map(player_x, player_y, car0_left, car0_top, car0_collided);
	car1_collision : collisions port map(player_x, player_y, car1_left, car1_top, car1_collided);
	car2_collision : collisions port map(player_x, player_y, car2_left, car2_top, car2_collided);
	car3_collision : collisions port map(player_x, player_y, car3_left, car3_top, car3_collided);
	
	process(clk60) begin
		if rising_edge(clk60) then 
			--counter <= counter + 1;
			--fast_counter <= fast_counter + 3;
			
			-- gives multiple instances of the blocks -> so fast that so many appear on the screen?
			car0_left <= (car0_left + 1) mod 640;
			car1_left <= (car1_left + 1) mod 640;
			car2_left <= (car2_left + 3) mod 640;
			car3_left <= (car3_left - 3) mod 640;
		end if;
	end process;

	-- horizontal motion of a block across the screen
	process(all) begin 
		-- checking if within valid viewable region
		if (valid = '1') then 
			if (player_y <= 10d"20") then
				--win <= '1';
				rgb <= "001100";
				--playing <= '0';
			--player
			elsif (car0_collided or car1_collided or car2_collided or car3_collided) then
			-- make screen red
				rgb <= "110000";
				--game_over <= '1';
				
			elsif (row >= player_y mod 480) and (row <= (player_y + player_height) mod 480) and (col >= (player_x mod 640)) and (col <= (player_x + player_width) mod 640) then
				-- generate a block
				rgb <= "111111";
			--horizontal motion of cars
			elsif (((row >= car0_top) and (row <= car0_top + car_height)) and ((col >= (car0_left)) and (col <= (car0_left + car_width)))) then
				rgb <= "000011";

			elsif (((row >= car1_top) and (row <= car1_top + car_height)) and ((col >= (car1_left)) and (col <= (car1_left + car_width)))) then
				rgb <= "001001";
				
			elsif (((row >= car2_top) and (row <= car2_top + car_height)) and ((col >= (car2_left)) and (col <= (car2_left + car_width)))) then
				rgb <= "010011";
			
			elsif ((row >= car3_top) and (row <= car3_top + car_height) and ((col >= (car3_left)) and (col <= (car3_left + car_width)))) then
				   rgb <= "110011";
				   
			elsif((row >= 10d"0" and row <= 10d"20")) then 
			-- top green stripe
			rgb <= "001100";
			
			-- middle green stripe
			elsif ((row >= 10d"220" and row <= 10d"260")) then
				rgb <= "001100";
				
			--bottom green stripe
			elsif ((row >= 10d"460" and row <= 10d"480")) then
				rgb <= "001100";
			else
				rgb <= "000000";
			end if;
		--elsif (game_over) then
			--rgb <= "110000";				
		else
			rgb <= "000000";
		end if;

		
	end process;
end;
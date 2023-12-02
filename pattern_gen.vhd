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
		rgb : out unsigned(5 downto 0)
	);
end pattern_gen;

architecture synth of pattern_gen is 
	component collision is
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
		);
	end component;
	
	component car is 
		port (
			clk60 : in std_logic;
			car_top : out unsigned(9 downto 0);
			car_bottom : out unsigned(9 downto 0);
			car_left : out unsigned(9 downto 0);
			car_right : out unsigned(9 downto 0)
		);
	end component;

	signal counter : unsigned(30 downto 0) := 31d"0";
	-- signal count : unsigned(2 downto 0) := 3d"0";

	-- block x tracking
	--signal x_top : unsigned(9 downto 0) := 10d"200";
	--signal x_bottom : unsigned(9 downto 0) := 10d"219";
	--signal x_left : unsigned(9 downto 0) := 10d"100";
	--signal x_right : unsigned(9 downto 0) := 10d"119";

	-- player tracking
	signal player_top : unsigned(9 downto 0) := 10d"400";
	signal player_bottom : unsigned(9 downto 0) := 10d"419";
	signal player_left : unsigned(9 downto 0) := 10d"150";
	signal player_right : unsigned(9 downto 0) := 10d"169";
	
	-- car 0
	signal car0_top : unsigned(9 downto 0) := 10d"40";
	signal car0_bottom : unsigned(9 downto 0) := 10d"60";
	signal car0_left : unsigned(9 downto 0) := 10d"10";
	signal car0_right : unsigned(9 downto 0) := 10d"30";

	-- car 1
	signal car1_top : unsigned(9 downto 0) := 10d"80";
	signal car1_bottom : unsigned(9 downto 0) := 10d"100";
	signal car1_left : unsigned(9 downto 0) := 10d"50";
	signal car1_right : unsigned(9 downto 0) := 10d"70";

	
	-- top green stripe on screen
	signal topG_top : unsigned(9 downto 0) := 10d"0";
	signal topG_bottom : unsigned(9 downto 0) := 10d"20";
	
	-- middle green stripe on screen
	signal midG_top : unsigned(9 downto 0) := 10d"220";
	signal midG_bottom : unsigned(9 downto 0) := 10d"260";
	
	-- bottom green stripe on screen
	signal botG_top : unsigned(9 downto 0) := 10d"460";
	signal botG_bottom : unsigned(9 downto 0) := 10d"480";
	
begin 

	my_collision : collision port map (clk60 => clk60,
									   player_top => player_top, 
									   player_bottom => player_bottom, 
									   player_left => player_left, 
									   player_right => player_right,
									   car_top => car0_top, 
									   car_bottom => car0_bottom, 
									   car_left => car0_left, 
									   car_right => car0_right, 
									   rgb => rgb);
									   
	--car1 : car port map(clk60 => clk60, car_top => y_top, car_bottom => y_bottom, car_left => y_left, car_right => y_right);
	--car2 : car port map(clk60 => clk60, car_top => x_top, car_bottom => x_bottom, car_left => x_left, car_right => x_right);
	
	process(clk60) begin
		if rising_edge(clk60) then 
			counter <= counter + 1;
			
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
			rgb <= "010101";
		end if;
		
		-- top green stripe
		if ((row >= topG_top and row <= topG_bottom)) then
			rgb <= "001100";
		end if;
		
		-- middle green stripe
		if ((row >= midG_top and row <= midG_bottom)) then
			rgb <= "001100";
		end if;
		
		-- bottom green stripe
		if ((row >= botG_top and row <= botG_bottom)) then
			rgb <= "001100";
		end if;
		
		-- vertical motion for player
		-- TODO : make block go up the screen 
		if ((row >= ((player_top + counter) mod 480)) and (row <= ((player_bottom + counter)) mod 480) and 
		    (col >= player_left) and (col <= player_right)) then
			-- generate a block
			rgb <= "001110";
		--else 
			--rgb <= "010101";
		end if;	
		
		-- horizontal motion of cars
		--if ((row >= x_top) and (row <= x_bottom) and ((col >= (x_left + counter) mod 640)) and (col <= ((x_right + counter) mod 640))) then 	
			-- generate alien pattern hopefully please and thank you vhdl 
			--rgb(1 downto 0) <= (row(9 downto 8) xor col(9 downto 8)) mod 9; 
			--rgb(3 downto 2) <= (row(7 downto 6) xor col(7 downto 6)) mod 9; 
			--rgb(5 downto 4) <= (row(5 downto 4) xor col(5 downto 4)) mod 9;
			
			-- generate a block
			--rgb <= "110011";
			
			-- TODO : when pink block leaves, the screen flashes a dark green
			
		--else 
			--rgb <= "010101";
		--end if;
		
		-- horizontal motion of cars
		if ((row >= car0_top) and (row <= car0_bottom) and ((col >= (car0_left + counter + 100) mod 640)) and (col <= ((car0_right + counter + 100) mod 640))) then
		       rgb <= "110011";
		end if;

		if ((row >= car1_top) and (row <= car1_bottom) and ((col >= (car1_left + counter) mod 640)) and (col <= ((car1_right + counter) mod 640))) then
		       rgb <= "110011";
		end if;
	
		
	end process;
	--rgb <= "110011" when ((valid = '1') and (row >= x_top) and (row <= x_bottom) and (col >= (x_left)) and (col <= (x_right))) else "101010";
	--rgb <= "000111" when ((valid = '1') and (row >= (y_top)) and (row <= (y_bottom)) and (col >= y_left) and (col <= y_right)) else "101010";
end;
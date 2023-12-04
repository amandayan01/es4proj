-- 6 cars, 6 speeds, change direction midcourse ("randomly")
-- synthesizable: no?

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is
    port (    
        clk60 : in std_logic;                  -- 60 MHz clock input
        row : in unsigned(9 downto 0);         -- Current row being drawn
        col : in unsigned(9 downto 0);         -- Current column being drawn
        valid : in std_logic;                  -- Signal indicating if current position is within display area
        rgb : out unsigned(5 downto 0)         -- Output color (6-bit: RR GG BB)
    );
end entity pattern_gen;

architecture synth of pattern_gen is
    constant num_cars : natural := 6;
    
    -- Control the delay to change the direction pseudo-randomly
    constant direction_change_delay : array (0 to num_cars-1) of natural := (500000, 250000, 750000, 600000, 450000, 300000);
    signal direction_change_counter : array (0 to num_cars-1) of natural := (others => 0);
    signal direction : array (0 to num_cars-1) of std_logic := (others => '1');
    
    -- Car position counters
    type car_position_array is array (0 to num_cars-1) of unsigned(10 downto 0);
    signal counter : car_position_array := (others => (others => '0'));
    
    -- Car speeds, each car could have a different speed
    constant car_speeds : array (0 to num_cars-1) of unsigned(9 downto 0) := (10d"2", 10d"3", 10d"1", 10d"4", 10d"2", 10d"3");
    
    -- Car vertical positions (lanes), each lane has a different vertical position
    constant car_lane_y : array (0 to num_cars-1) of unsigned(9 downto 0) := (10d"50", 10d"150", 10d"250", 10d"350", 10d"450", 10d"550");
    
    -- Car dimensions
    constant car_width : unsigned(9 downto 0) := 10d"20";
    constant car_height : unsigned(9 downto 0) := 10d"30";
    
    -- Car color (6-bit: RR GG BB)
    constant car_color : unsigned(5 downto 0) := "001100";  -- Green car
    
begin
    -- Clock process to update cars positions and directions
    process(clk60)
    begin
        if rising_edge(clk60) then
            for i in 0 to num_cars-1 loop
                -- Increment the direction change counter for each car
                direction_change_counter(i) := direction_change_counter(i) + 1;
                
                -- Change the car's direction after a pseudo-random delay
                if direction_change_counter(i) >= direction_change_delay(i) then
                    direction_change_counter(i) := 0;
                    direction(i) <= not direction(i);
                end if;
                
                -- Update the car's horizontal position
                if direction(i) = '1' then
                    counter(i) <= counter(i) + car_speeds(i);  -- Move right
                else
                    counter(i) <= counter(i) - car_speeds(i);  -- Move left
                end if;
                
                -- Boundary condition - wrap car position
                if to_integer(counter(i)) >= 640 then
                    counter(i) <= counter(i) - 640;
                elsif to_integer(counter(i)) < 0 then
                    counter(i) <= counter(i) + 640;
                end if;
            end loop;
        end if;
    end process;

    -- Display process to draw the cars on the screen
    process(row, col, valid, counter, direction)
    begin
        if valid = '0' then
            rgb <= "000000";  -- Set color to black when outside the valid display area
        else
            rgb <= "010101";  -- Default background color
            for i in 0 to num_cars-1 loop
                -- Draw car only if within its vertical lane range and horizontal movement range
                if (row >= car_lane_y(i)) and (row < car_lane_y(i) + car_height) and
                   (col >= counter(i)) and (col < counter(i) + car_width) then
                    -- Set car color
                    rgb <= car_color;
                end if;
            end loop;
        end if;
    end process;

end architecture synth;
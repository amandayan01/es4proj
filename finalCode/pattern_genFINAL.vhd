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

        -- car 0 (blue) moving right
        signal car0_top : unsigned(9 downto 0) := 10d"35";
        signal car0_left : unsigned(9 downto 0) := 10d"0";
        signal car0_collided : std_logic;

        -- car 1 (green) moving right
        signal car1_top : unsigned(9 downto 0) := 10d"80";
        signal car1_left : unsigned(9 downto 0) := 10d"0";
        signal car1_collided : std_logic;

                -- car 7 (green) moving right
        signal car7_top : unsigned(9 downto 0) := 10d"80";
        signal car7_left : unsigned(9 downto 0) := 10d"0";
        signal car7_collided : std_logic;

        -- car 2 (purple) moving right
        signal car2_top : unsigned(9 downto 0) := 10d"364";
        signal car2_left : unsigned(9 downto 0) := 10d"0";
        signal car2_collided : std_logic;

        -- car 13 (purple) moving right
        signal car13_top : unsigned(9 downto 0) := 10d"364";
        signal car13_left : unsigned(9 downto 0) := 10d"0";
        signal car13_collided : std_logic;

        -- car 3 (pink) moving left
        signal car3_top : unsigned(9 downto 0) := 10d"320";
        signal car3_left : unsigned(9 downto 0) := 10d"0";
        signal car3_collided : std_logic;

        -- car 8 (purple) moving right
        signal car8_top : unsigned(9 downto 0) := 10d"400";
        signal car8_left : unsigned(9 downto 0) := 10d"0";
        signal car8_collided : std_logic;

        -- car 12 (purple) moving right
        signal car12_top : unsigned(9 downto 0) := 10d"400";
        signal car12_left : unsigned(9 downto 0) := 10d"0";
        signal car12_collided : std_logic;

        -- car 9 (pink) moving left
        signal car9_top : unsigned(9 downto 0) := 10d"280";
        signal car9_left : unsigned(9 downto 0) := 10d"0";
        signal car9_collided : std_logic;

        -- car 10 (pink) moving left
        signal car10_top : unsigned(9 downto 0) := 10d"280";
        signal car10_left : unsigned(9 downto 0) := 10d"0";
        signal car10_collided : std_logic;

        -- car 11 (pink) moving left
        signal car11_top : unsigned(9 downto 0) := 10d"280";
        signal car11_left : unsigned(9 downto 0) := 10d"0";
        signal car11_collided : std_logic;

        -- Car 4 (moving right)
        signal car4_top : unsigned(9 downto 0) := 10d"125"; -- Set the starting Y position for car 4
        signal car4_left : unsigned(9 downto 0) := 10d"0"; -- Set the starting X position for car 4
        signal car4_collided : std_logic;

        -- Car 5 (moving left)
        signal car5_top : unsigned(9 downto 0) := 10d"165"; -- Set the starting Y position for car 5
        signal car5_left : unsigned(9 downto 0) := 10d"0"; -- Set the starting X position for car 5
        signal car5_collided : std_logic;

        -- car 6 grey moving left
        signal car6_top : unsigned(9 downto 0) := 10d"165"; -- Set the starting Y position for car 6
        signal car6_left : unsigned(9 downto 0) := 10d"0"; -- Set the starting X position for car 6
        signal car6_collided : std_logic;

        signal cone1_top : unsigned(9 downto 0) := 10d"185"; -- Set the starting Y position for cone 1
        signal cone1_left : unsigned(9 downto 0) := 10d"60"; -- Set the starting X position for cone 1
        signal cone1_collided : std_logic;

        signal cone2_top : unsigned(9 downto 0) := 10d"430"; -- Set the starting Y position for cone 2
        signal cone2_left : unsigned(9 downto 0) := 10d"120"; -- Set the starting X position for cone 2
        signal cone2_collided : std_logic;

        signal cone3_top : unsigned(9 downto 0) := 10d"390"; -- Set the starting Y position for cone 3
        signal cone3_left : unsigned(9 downto 0) := 10d"450"; -- Set the starting X position for cone 3
        signal cone3_collided : std_logic;

        signal cone4_top : unsigned(9 downto 0) := 10d"300"; -- Set the starting Y position for cone 4
        signal cone4_left : unsigned(9 downto 0) := 10d"300"; -- Set the starting X position for cone 4
        signal cone4_collided : std_logic;

        signal cone5_top : unsigned(9 downto 0) := 10d"300"; -- Set the starting Y position for cone 5
        signal cone5_left : unsigned(9 downto 0) := 10d"250"; -- Set the starting X position for cone 5
        signal cone5_collided : std_logic;

        signal cone6_top : unsigned(9 downto 0) := 10d"300"; -- Set the starting Y position for cone 6
        signal cone6_left : unsigned(9 downto 0) := 10d"350"; -- Set the starting X position for cone 6
        signal cone6_collided : std_logic;

        signal cone_dim : unsigned(4 downto 0) := 5d"6"; -- dimension of square cone

        signal player_width : unsigned(9 downto 0) := 10d"10";
        signal player_height : unsigned(9 downto 0) := 10d"10";

        signal respawn_pos : unsigned(9 downto 0) := 10d"640";

        signal hit_counter : unsigned(6 downto 0) := 7d"0";

        signal hit_bar_top : unsigned(7 downto 0) := 8d"5";
        signal hit_bar_left : unsigned(7 downto 0) := 8d"5";

        signal game_over : std_logic := '0';

begin

        car0_collision : collisions port map(player_x, player_y, car0_left, car0_top, car0_collided);
        car1_collision : collisions port map(player_x, player_y, car1_left, car1_top, car1_collided);
        car2_collision : collisions port map(player_x, player_y, car2_left, car2_top, car2_collided);
        car3_collision : collisions port map(player_x, player_y, car3_left, car3_top, car3_collided);
        car4_collision : collisions port map(player_x, player_y, car4_left, car4_top, car4_collided);
        car5_collision : collisions port map(player_x, player_y, car5_left, car5_top, car5_collided);
        car6_collision : collisions port map(player_x, player_y, car6_left, car6_top, car6_collided);
        car7_collision : collisions port map(player_x, player_y, car7_left, car7_top, car7_collided);
        car8_collision : collisions port map(player_x, player_y, car8_left, car8_top, car8_collided);
        car9_collision : collisions port map(player_x, player_y, car9_left, car9_top, car9_collided);
        car10_collision : collisions port map(player_x, player_y, car10_left, car10_top, car10_collided);
        car11_collision : collisions port map(player_x, player_y, car11_left, car11_top, car11_collided);
        car12_collision : collisions port map(player_x, player_y, car12_left, car12_top, car12_collided);
        car13_collision : collisions port map(player_x, player_y, car13_left, car13_top, car13_collided);

        cone1_collision : collisions port map(player_x, player_y, cone1_left, cone1_top, cone1_collided);
        cone2_collision : collisions port map(player_x, player_y, cone2_left, cone2_top, cone2_collided);
        cone3_collision : collisions port map(player_x, player_y, cone3_left, cone3_top, cone3_collided);
        cone4_collision : collisions port map(player_x, player_y, cone4_left, cone4_top, cone4_collided);
        cone5_collision : collisions port map(player_x, player_y, cone5_left, cone5_top, cone5_collided);
        cone6_collision : collisions port map(player_x, player_y, cone6_left, cone6_top, cone6_collided);


        process(clk60) begin
                if rising_edge(clk60) then
                        --counter <= counter + 1;
                        --fast_counter <= fast_counter + 3;

                        -- gives multiple instances of the blocks -> so fast that so many appear on the screen?
                        car0_left <= (car0_left + 7) mod 640;
                        car1_left <= (car1_left + 1) mod 640;
                        car7_left <= (car7_left + 8) mod 640;
                        car2_left <= (car2_left + 3) mod 640;

                        if (car3_left = 10d"0") then
                                car3_left <= respawn_pos;
                        else
                                car3_left <= car3_left - 6;
                        end if;

                        car13_left <= car13_left + 9;

                                        -- Adding motion for car4 and car5 with different speeds
                        car4_left <= (car4_left + 2) mod 640; -- Speed for car 4

                        if (car5_left = 10d"0") then
                                car5_left <= respawn_pos;
                        else
                                car5_left <= car5_left - 2;
                        end if;

                        if (car6_left = 10d"0") then
                                car6_left <= respawn_pos;
                        else
                                car6_left <= car6_left - 5;
                        end if;

                        car8_left <= car8_left + 4;

                        car12_left <= car12_left + 6;

                        if (car9_left = 10d"0") then
                                car9_left <= respawn_pos;
                        else
                                car9_left <= car9_left - 6;
                        end if;

                        if (car10_left = 10d"0") then
                                car10_left <= respawn_pos;
                        else
                                car10_left <= car11_left - 2;
                        end if;

                        if (car11_left = 10d"0") then
                                car11_left <= respawn_pos;
                        else
                                car11_left <= car11_left - 4;
                        end if;

                        --hit bar counter
                        if (car0_collided or car1_collided or car2_collided or car3_collided or car4_collided or car5_collided or car6_collided or car7_collided or car8_collided or car9_collided or car10_collided or car11_collided or car12_collided or cone1_collided or cone2_collided or cone3_collided or cone4_collided or cone5_collided or cone6_collided or car13_collided) then
                                hit_counter <= hit_counter + 1;

                                if hit_counter >= 7d"5" then
                                        game_over <= '1';
                                end if;

                        end if;

                        if (player_x = 10d"320" and player_y = 10d"455") then
                                        hit_counter <= 7d"0";
                                        game_over <= '0';
                        end if;
                end if;
        end process;

        -- horizontal motion of a block across the screen
        process(all) begin
                -- checking if within valid viewable region
                if (valid = '1') then
                        -- at the top, win
                        if (player_y <= 10d"20") then
                                rgb <= "001100";

                        -- make screen red
                        elsif (game_over) then
                                rgb <= "110000";

                        elsif (car0_collided or car1_collided or car2_collided or car3_collided or car4_collided or car5_collided or car6_collided or car7_collided or car8_collided or car9_collided or car10_collided or car11_collided or car12_collided or cone1_collided or cone2_collided or cone3_collided or cone4_collided or cone5_collided or cone6_collided or car13_collided) then
                        -- make screen red
                                rgb <= "110000";

                        elsif (row >= player_y mod 480) and (row <= (player_y + player_height) mod 480) and (col >= (player_x mod 640)) and (col <= (player_x + player_width) mod 640) then
                                -- generate a block
                                rgb <= "111111";

                        --cones
                        elsif (((row >= cone1_top) and (row <= cone1_top + cone_dim)) and ((col >= (cone1_left)) and (col <= (cone1_left + cone_dim)))) then
                                rgb <= "110100";

                        elsif (((row >= cone2_top) and (row <= cone2_top + cone_dim)) and ((col >= (cone2_left)) and (col <= (cone2_left + cone_dim)))) then
                                rgb <= "110100";

                        elsif (((row >= cone3_top) and (row <= cone3_top + cone_dim)) and ((col >= (cone3_left)) and (col <= (cone3_left + cone_dim)))) then
                                rgb <= "110100";

                        elsif (((row >= cone4_top) and (row <= cone4_top + cone_dim)) and ((col >= (cone4_left)) and (col <= (cone4_left + cone_dim)))) then
                                rgb <= "110100";

                        elsif (((row >= cone5_top) and (row <= cone5_top + cone_dim)) and ((col >= (cone5_left)) and (col <= (cone5_left + cone_dim)))) then
                                rgb <= "110100";

                        elsif (((row >= cone6_top) and (row <= cone6_top + cone_dim)) and ((col >= (cone6_left)) and (col <= (cone6_left + cone_dim)))) then
                                rgb <= "110100";

                        --horizontal motion of cars
                        elsif (((row >= car0_top) and (row <= car0_top + car_height)) and ((col >= (car0_left)) and (col <= (car0_left + car_width)))) then
                                rgb <= "000011";

                        elsif (((row >= car1_top) and (row <= car1_top + car_height)) and ((col >= (car1_left)) and (col <= (car1_left + car_width)))) then
                                rgb <= "001001";

                        elsif (((row >= car7_top) and (row <= car7_top + car_height)) and ((col >= (car7_left)) and (col <= (car7_left + car_width)))) then
                                rgb <= "001001";

                        elsif (((row >= car2_top) and (row <= car2_top + car_height)) and ((col >= (car2_left)) and (col <= (car2_left + car_width)))) then
                                rgb <= "010011";

                        elsif (((row >= car13_top) and (row <= car13_top + car_height)) and ((col >= (car13_left)) and (col <= (car13_left + car_width)))) then
                                rgb <= "010011";

                        elsif (((row >= car8_top) and (row <= car8_top + car_height)) and ((col >= (car8_left)) and (col <= (car8_left + car_width)))) then
                                rgb <= "010111";

                        elsif (((row >= car12_top) and (row <= car12_top + car_height)) and ((col >= (car12_left)) and (col <= (car12_left + car_width)))) then
                                rgb <= "010110";

                        elsif ((row >= car3_top) and (row <= car3_top + car_height) and ((col >= (car3_left)) and (col <= (car3_left + car_width)))) then
                                rgb <= "110011";

                        elsif ((row >= car9_top) and (row <= car9_top + car_height) and ((col >= (car9_left)) and (col <= (car9_left + car_width)))) then
                                rgb <= "001111";

                        elsif ((row >= car10_top) and (row <= car10_top + car_height) and ((col >= (car10_left)) and (col <= (car10_left + car_width)))) then
                                rgb <= "101111";

                        elsif ((row >= car11_top) and (row <= car11_top + car_height) and ((col >= (car11_left)) and (col <= (car11_left + car_width)))) then
                                rgb <= "100101";

                        -- New car4 condition
                        elsif (((row >= car4_top) and (row <= car4_top + car_height)) and ((col >= (car4_left)) and (col <= (car4_left + car_width)))) then
                                rgb <= "010101"; -- Custom color code for car4

                        -- New car5 condition
                        elsif (((row >= car5_top) and (row <= car5_top + car_height)) and ((col >= (car5_left)) and (col <= (car5_left + car_width)))) then
                                rgb <= "101010"; -- Custom color code for car5

                        elsif (((row >= car6_top) and (row <= car6_top + car_height)) and ((col >= (car6_left)) and (col <= (car6_left + car_width)))) then
                                rgb <= "101010"; -- Custom color code for car5

                        elsif((row >= hit_bar_left and row <= hit_bar_left + 3) and col >= hit_bar_top and col <= hit_bar_top + hit_counter*3) then
                                -- hit bar
                                rgb <= "110000";

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

                else
                        rgb <= "000000";
                end if;


        end process;
end;

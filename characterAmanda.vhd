library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity character is
    port(
		clk60 : in std_logic;
        controller_ins : in unsigned(7 downto 0);
        positionXout : out unsigned(9 downto 0):= 10d"320";
        positionYout : out unsigned(9 downto 0):= 10d"455"
    );
end character;

architecture synth of character is
        -- Controller_in button mapping
    -- 0 <= rright
    -- 1 <= lleft
    -- 2 <= down
    -- 3 <= up
    -- 4 <= start
    -- 5 <= select
    -- 6 <= B
    -- 7 <= A
    signal rright : std_logic;
    signal lleft : std_logic;
    signal down : std_logic;
    signal up : std_logic;
    signal start : std_logic;
    signal sselect : std_logic;
    signal B : std_logic;
    signal A : std_logic;

begin
    lleft <= controller_ins(0);
    rright <= controller_ins(1);
    down <= controller_ins(2);
    up <= controller_ins(3);
    start <= controller_ins(4);
    sselect <= controller_ins(5);
    B <= controller_ins(6);
    A <= controller_ins(7);
	
    process(clk60) begin
		if rising_edge(clk60) then
			if (rright = '1' and positionXout <= 10d"640") then
				positionXout <= positionXout - 2;
			elsif (lleft = '1' and positionXout >= 10d"0") then
				positionXout <= positionXout + 2;
			elsif (down = '1' and positionYout <= 10d"460" and positionYout >= 10d"20") then -- keep player from travelling down/ looping back up TODO: test this
				positionYout <= positionYout + 2;
			elsif (up = '1' and positionYout >= 10d"20") then -- keep the player from travelling back down once they win
				positionYout <= positionYout - 2;
			elsif (start = '1') then
				-- put player back in the starting position
				positionXout <= 10d"320";
				positionYout <= 10d"455";
			else
				-- nothing
			end if;
		end if;
    end process;
end;
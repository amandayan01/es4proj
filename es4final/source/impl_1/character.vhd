library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity character is
    port(
        controller_ins : in std_logic_vector(7 downto 0);
        positionXin : in unsigned(9 downto 0);
        positionYin : in unsigned(9 downto 0);
        positionXout : out unsigned(9 downto 0):= 10b"0";
        positionYout : out unsigned(9 downto 0):= 10b"0"
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
    rright <= controller_ins(0);
    lleft <= controller_ins(1);
    down <= controller_ins(2);
    up <= controller_ins(3);
    start <= controller_ins(4);
    sselect <= controller_ins(5);
    B <= controller_ins(6);
    A <= controller_ins(7);
    process(all) begin
        if (rright = '1') then
            positionXout <= positionXin + 10;
        end if;
        if (lleft = '1') then
            positionXout <= positionXin - 10;
        end if;
        if (down = '1') then
            positionYout <= positionYin - 10;
        end if;
        if (up = '1') then
            positionYout <= positionYin + 10;
        end if;
        if (start = '1') then
            positionXout <= 0b"0101000000";
            positionYout <= 0b"0000001010";
        end if;
    end process;
end;
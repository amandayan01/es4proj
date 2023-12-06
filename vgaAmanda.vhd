library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is 
	port (
		int25clk : in std_logic;
		HSYNC : out std_logic;
		VSYNC : out std_logic;
		row : out unsigned(9 downto 0);
		col : out unsigned(9 downto 0);
		valid : out std_logic
	);
end vga;

architecture synth of vga is 
begin 
	process (int25clk) begin 
		if rising_edge(int25clk) then 
			-- row logic: if at right of screen, go back to left 
			if (col = 10d"799") then 
				col <= 10d"0";
				row <= row + 1;
			else 
				col <= col + 1;
			end if;

			-- col logic: if at bottom of screen, go back to top
			if (row = 10d"524") then 
				row <= 10d"0";
			end if;
		end if;
	end process;

	-- driving HSYNC and VSYNC signals 
	HSYNC <= '0' when ((col >= 656) and (col <= 751)) else '1';
	VSYNC <= '0' when ((row >= 490) and (row <= 491)) else '1';

	-- valid -> visible area
	valid <= '1' when ((col <= 639) and (row <= 479)) else '0';
end;
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

signal counter : unsigned(30 downto 0) := 31d"0";
-- signal count : unsigned(2 downto 0) := 3d"0";

-- TODO : create signals for block x and y locations
-- block x tracking
signal x_top : unsigned(9 downto 0) := 10d"200";
signal x_bottom : unsigned(9 downto 0) := 10d"219";
signal x_left : unsigned(9 downto 0) := 10d"100";
signal x_right : unsigned(9 downto 0) := 10d"119";

-- block y tracking
signal y_top : unsigned(9 downto 0) := 10d"400";
signal y_bottom : unsigned(9 downto 0) := 10d"419";
signal y_left : unsigned(9 downto 0) := 10d"150";
signal y_right : unsigned(9 downto 0) := 10d"169";

begin 
	process(clk60) begin
		if rising_edge(clk60) then 
			counter <= counter + 1;
		end if;
	end process;

	--process(clk60) begin 
		--if rising_edge(clk60) then 
			-- count <= counter(20 downto 18);
			-- counter <= counter + 1;
			
			-- checking for horizontal and vertical blanking periods and setting low if in that region 
			
		--end if;
	--end process;
	
	-- horizontal motion of a block across the screen
	process(all) begin 
		-- checking if within valid viewable region
		if (valid = '0') then 
			rgb <= "000000";
		else 
			rgb <= "010101";
		end if;
		
		
		if ((row >= 200) and (row <= 229) and (col >= (100 + counter) mod 799) and (col <= (119 + counter) mod 799)) then 	
			-- generate alien pattern hopefully please and thank you vhdl 
			--rgb(1 downto 0) <= (row(9 downto 8) xor col(9 downto 8)) mod 9; 
			--rgb(3 downto 2) <= (row(7 downto 6) xor col(7 downto 6)) mod 9; 
			--rgb(5 downto 4) <= (row(5 downto 4) xor col(5 downto 4)) mod 9;
			
			-- generate a block
			rgb <= "110011";
			
			-- TODO : when pink block leaves, the screen flashes a dark green
			
		--else 
			--rgb <= "010101";
		end if;
		
		-- vertical motion of a block
		if ((row >= (400 + counter) mod 524) and (row <= (429 + counter) mod 524) and (col >= 150) and (col <= 169)) then
			-- generate a block
			rgb <= "001100";
		--else 
			--rgb <= "010101";
		end if;	
	end process;

end;
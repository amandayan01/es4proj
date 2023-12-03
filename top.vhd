library IEEE;  
use IEEE.std_logic_1164.all;  
use std.textio.all;  
use IEEE.numeric_std.all;  

entity top is  

port(  
-- for controller
	data : in std_logic;
	clock : out std_logic; 
	latch : out std_logic;
-- for vga
	ext12clk : in std_logic;
	rgb : out unsigned(5 downto 0);
	HSYNC : out std_logic;
	VSYNC : out std_logic;
	test_out : out std_logic
);  

end; 

architecture synth of top is
	component character is
		port(
			clk60 : in std_logic;
			controller_ins : in unsigned(7 downto 0);
			positionXout : out unsigned(9 downto 0);
			positionYout : out unsigned(9 downto 0)
		);
	end component;

	component mypll is
		port(
			ref_clk_i: in std_logic;
			rst_n_i: in std_logic;
			outcore_o: out std_logic;
			outglobal_o: out std_logic
		);
	end component; 

	component vga is 
		port (
			int25clk : in std_logic;
			HSYNC : out std_logic;
			VSYNC : out std_logic;
			row : out unsigned(9 downto 0);
			col : out unsigned(9 downto 0);
			valid : out std_logic
		);
	end component;

	component pattern_gen is 
		port (
			--int25clk : in std_logic;
			clk60 : in std_logic;
			row : in unsigned(9 downto 0);
			col : in unsigned(9 downto 0);
			valid : in std_logic;
			rgb : out unsigned(5 downto 0);
			player_x : in unsigned(9 downto 0);
			player_y : in unsigned(9 downto 0)
		);
	end component;

	signal clk : std_logic;

	component HSOSC is  
		generic (  
		CLKHF_DIV : String := "0b00");  
		port( 
		CLKHFPU : in std_logic := 'X'; -- Set to 1 to power up  
		CLKHFEN : in std_logic := 'X'; -- Set to 1 to enable output  
		CLKHF : out std_logic := 'X'); -- Clock output  
	end component; 

	component controller is  
	port(  
		clk : in std_logic;
		latch : out std_logic;  
		output : out unsigned(7 downto 0); 
		clock : out std_logic;  
		data : in std_logic
	);  
	end component; 

	-- clock signals
	signal int25clk : std_logic;
	signal int60clk : std_logic;

	-- vga signals
	signal row : unsigned(9 downto 0);
	signal col : unsigned(9 downto 0);
	signal valid : std_logic;
	
	-- player tracking
	signal player_x : unsigned(9 downto 0) := 10b"0101000000";
	signal player_y : unsigned(9 downto 0) := 10b"0000001010";
	
	signal output : unsigned(7 downto 0);

begin

	osc : HSOSC generic map ( CLKHF_DIV => "0b00")  
		port map (CLKHFPU => '1',  
					CLKHFEN => '1', 
					CLKHF => clk); 
	control : controller port map (clk=>clk, latch=>latch, output=>output, clock=>clock, data=>data);
	
	player : character port map(clk60=>int60clk, controller_ins=>output, positionXout=>player_x, positionYout=>player_y);	
	
	-- use the current 25MHz clk to generate a slower 60Hz clock
	int60clk <= '1' when (row = 482) else '0';

	pll : mypll port map(ref_clk_i => ext12clk, rst_n_i => '1', outcore_o => test_out, outglobal_o => int25clk);
	myvga : vga port map(int25clk, HSYNC, VSYNC, row, col, valid);
	
	pg : pattern_gen port map(int60clk, row, col, valid, rgb, player_x, player_y);

end;

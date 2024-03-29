library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is 
	port (
		ext12clk : in std_logic;
		rgb : out unsigned(5 downto 0);
		HSYNC : out std_logic;
		VSYNC : out std_logic;
		test_out : out std_logic;
		nes_clock : out std_logic;
		nes_latch : out std_logic;
		nes_data : in std_logic;
		nes_outs : out std_logic_vector(7 downto 0)
	);
end top;

architecture synth of top is 
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
			rgb : out unsigned(5 downto 0)
		);
	end component;
	
	component NEScontroller is
		port(
			clock : out std_logic;
			latch : out std_logic;
			data : in std_logic;
			outs : out std_logic_vector(7 downto 0)
	);
	end component;
	
	component character is
		port(
        controller_ins : in std_logic_vector(7 downto 0);
        positionXin : in unsigned(9 downto 0);
        positionYin : in unsigned(9 downto 0);
        positionXout : out unsigned(9 downto 0):= 10b"0";
        positionYout : out unsigned(9 downto 0):= 10b"0"
		);
	end component;
	
	-- clock signals
	signal int25clk : std_logic;
	signal int60clk : std_logic;
	
	-- vga signals
	signal row : unsigned(9 downto 0);
	signal col : unsigned(9 downto 0);
	signal valid : std_logic;
	
begin
	-- use the current 25MHz clk to generate a slower 60Hz clock
	int60clk <= '1' when (row = 482) else '0';
	nes_control : NEScontroller port map(clock => nes_clock, latch => nes_latch, data => nes_data, outs => nes_outs);
	pll : mypll port map(ref_clk_i => ext12clk, rst_n_i => '1', outcore_o => test_out, outglobal_o => int25clk);
	myvga : vga port map(int25clk, HSYNC, VSYNC, row, col, valid);
	pg : pattern_gen port map(int60clk, row, col, valid, rgb);
	my_chararcter : character port map(controller_ins => nes_outs);
end;
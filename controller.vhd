library IEEE;  
use IEEE.std_logic_1164.all;  
use std.textio.all;  
use IEEE.numeric_std.all;  

entity controller is  
port(  
	clk : in std_logic;
    latch : out std_logic;  
	output : out unsigned(7 downto 0); 
	clock : out std_logic;  
    data : in std_logic 
);  
end; 
  

architecture synth of controller is   
  
signal count : unsigned(19 downto 0) := 20b"1";  
signal sum : unsigned(19 downto 0);  
signal NEScount : unsigned(10 downto 0);  
signal NESclk : std_logic;  
  
signal A : std_logic; 
signal B : std_logic; 
signal sel : std_logic; 
signal start : std_logic; 
signal up : std_logic; 
signal down : std_logic; 
signal lef : std_logic; 
signal righ : std_logic; 

begin

process(clk) begin  
    if rising_edge(clk) then  
        count <= count + 1; 
    end if;    
end process;  

process(clock) begin  
    if rising_edge(clock) then  
		A <= data; 
		B <= A; 
		sel <= B; 
		start <= sel; 
		up <= start; 
		down <= up; 
		lef <= down; 
		righ <= lef; 
    end if;    
end process;  

    --sum <= count + 1;  
	latch <= '1' when (NEScount = "11111111") else '0';  
	NESclk <= count(8);  
    NEScount <= count(19 downto 9);  
	clock <= NESclk when (NEScount < "1000") else '0';  
	
	output(0) <= not A; 
	output(1) <= not B; 
	output(2) <= not sel; 
	output(3) <= not start; 
	output(4) <= not up; 
	output(5) <= not down; 
	output(6) <= not lef; 
	output(7) <= not righ;	 

end; 
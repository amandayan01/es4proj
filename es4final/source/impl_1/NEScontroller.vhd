
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity NEScontroller is
  port(
      clock : out std_logic;
      latch : out std_logic;
      data : in std_logic;
      outs : out std_logic_vector(7 downto 0)
  );
end NEScontroller;

architecture synth of NEScontroller is
  signal clk : std_logic;
  signal clk_div_count : unsigned(16 downto 0) := 17b"0";

  signal NESclk : std_logic := '0';
  signal NEScount : unsigned(8 downto 0) := 9b"0";

  signal latch_signal : std_logic := '0';
  signal controller_clk_signal : std_logic;

  signal shift_reg : std_logic_vector(7 downto 0) := 8b"0";

component HSOSC is
generic (
  CLKHF_DIV : String := "0b00");
port(
  CLKHFPU : in std_logic := '1'; -- Set to 1 to power up
  CLKHFEN : in std_logic := '1'; -- Set to 1 to enable output
  CLKHF : out std_logic := 'X'); -- Clock output
end component;

begin
    osc : HSOSC generic map ( CLKHF_DIV => "0b11")
              port map (CLKHFPU => '1',
              CLKHFEN => '1',
              CLKHF => clk);
                             
  process (clk) begin
  if rising_edge(clk) then
        clk_div_count <= clk_div_count + '1';
      
        if clk_div_count(7) = '1' then
              NESclk <= '1'; -- running slower clock NESclk from normal clk
          else
                  NESclk <= '0';
        end if;
        
        NEScount <= clk_div_count(16 downto 8); -- Counter takes upper bits of clk so it is slower
        
  end if;
  end process;
  
--------------------------------------------------------------
  
  process (NESclk) begin
  if NEScount = "111111111" then
      latch_signal <= '1';
  else
      latch_signal <= '0';
  end if;
  end process;
  
  latch <= latch_signal;
  
  process(NESclk) begin
  if rising_edge(NESclk) then
        shift_reg <= shift_reg(6 downto 0) & data;
  end if;

  if rising_edge(NESclk) and NEScount = 9d"8" then
      outs <= shift_reg;
  end if;
  end process;

  clock <= NESclk;
end;
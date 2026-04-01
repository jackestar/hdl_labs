library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use ieee.numeric_std.all;

entity encoder_ledDriver is
  port (
   ABvector : in STD_LOGIC_VECTOR(1 downto 0);
    leds   : out STD_LOGIC_VECTOR(3 downto 0) := "1111";
    clk    : in  STD_LOGIC
  );
end entity;

architecture Behavioral of encoder_ledDriver is
  signal pulse_sig  : unsigned(1 downto 0) := "00";
  
  type encoder_state is (IDLE, state_A, state_B, wait_cw, wait_ccw);
  signal stat       : encoder_state := IDLE;
  
  signal ABvector_sync1 : STD_LOGIC_VECTOR(1 downto 0) := "00";
  signal ABvector_sync2 : STD_LOGIC_VECTOR(1 downto 0) := "00";

begin

process (clk)
begin
if rising_edge(clk) then

	--- Metastability fix
	ABvector_sync1 <= ABvector;
	ABvector_sync2 <= ABvector_sync1;
	
	if ABvector_sync2 = ABvector then
case stat is
  when IDLE =>
    if ABvector_sync2 = "01" then
      stat <= state_A;
    elsif ABvector_sync2 = "10" then
      stat <= state_B;
    end if;
	 
  when state_A => 
    if ABvector_sync2 = "11" then
      stat <= wait_cw;
    elsif ABvector_sync2 = "01" then
      null;
    else
      stat <= IDLE;
    end if;
	 
  when state_B =>
    if ABvector_sync2 = "11" then
      stat <= wait_ccw;
    elsif ABvector_sync2 = "10" then
      null;
    else
      stat <= IDLE;
    end if;
	 
  when wait_cw =>
    if ABvector_sync2 = "10" then
      pulse_sig <= pulse_sig + 1;
      stat <= IDLE;
    elsif ABvector_sync2 = "11" then
      null;
    else
      stat <= IDLE;
    end if;
	 
  when wait_ccw =>
    if ABvector_sync2 = "01" then
      pulse_sig <= pulse_sig - 1;
      stat <= IDLE;
    elsif ABvector_sync2 = "11" then
      null;
    else
      stat <= IDLE;
    end if;

  end case;
  end if;
  end if;
end process;

  leds <=   "1000" when pulse_sig = 0 else
				"0100" when pulse_sig = 1 else
				"0010" when pulse_sig = 2 else
				"0001" when pulse_sig = 3;
			
end architecture;


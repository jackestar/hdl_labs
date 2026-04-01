library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use ieee.numeric_std.all;

entity test_proyects is
  port (
    ABvector : in STD_LOGIC_VECTOR(1 downto 0);
	stepper : out STD_LOGIC_VECTOR(3 downto 0) := "0000";
    clk    : in  STD_LOGIC
  );
end entity;

architecture Behavioral of test_proyects is
  constant freq : natural := 2500000;
  signal count     : natural range 0 to freq;
  
  signal pulse_sig  : natural range 0 to 4 := 4;
  
  type encoder_state is (IDLE, state_A, state_B, wait_cw, wait_ccw);
  signal stat       : encoder_state := IDLE;
  
  type direction_state is (left_d,stop_d,right_d);
  signal direction : direction_state := stop_d;
  
  signal ABvector_sync1 : STD_LOGIC_VECTOR(1 downto 0) := "00";
  signal ABvector_sync2 : STD_LOGIC_VECTOR(1 downto 0) := "00";

begin

process (clk)
begin
if rising_edge(clk) then

	--- Metastability fix
	ABvector_sync1 <= ABvector;
	ABvector_sync2 <= ABvector_sync1;
	if direction /= stop_d then
      if count = freq then
			if pulse_sig = 4 then
					direction <= stop_d;
			elsif direction = right_d then
				pulse_sig <= pulse_sig  + 1;
			elsif direction = left_d then
				if pulse_sig = 0 then
					pulse_sig <= 4;
				else
					pulse_sig <= pulse_sig  - 1;
				end if;
			end if;
        count <= 0;
      else
        count <= count + 1;
      end if;
    end if;
	
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
		direction <= right_d;
		pulse_sig <= 0;
      stat <= IDLE;
    elsif ABvector_sync2 = "11" then
      null;
    else
      stat <= IDLE;
    end if;
	 
  when wait_ccw =>
    if ABvector_sync2 = "01" then
		direction <= left_d;
		pulse_sig <= 3;
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

  stepper <= "0000" when pulse_sig = 4 else
				"1010" when pulse_sig = 0 else
				"0110" when pulse_sig = 1 else
				"0101" when pulse_sig = 2 else
				"1001" when pulse_sig = 3;
end architecture;


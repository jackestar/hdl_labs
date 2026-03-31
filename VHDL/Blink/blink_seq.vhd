library IEEE;
  use IEEE.STD_LOGIC_1164.all;

entity blink_seq is
  port (
    leds   : out STD_LOGIC_VECTOR(3 downto 0) := "1111";
    clk    : in  STD_LOGIC
  );
end entity;

architecture Behavioral of blink_seq is
  constant freq : natural := 25000000;
  signal count     : natural range 0 to freq;
  signal stat      : STD_LOGIC := '0';
  signal pulse_sig : natural range 0 to 3;
begin

  process (pulse_sig)
  begin
    case pulse_sig is
      when 0 =>
							leds(0) <= '1';
                leds(1) <= '0';
					 leds(2) <= '0';
					 leds(3) <= '0';

      when 1 =>
					leds(0) <= '0';
                leds(1) <= '1';
					 leds(2) <= '0';
					 leds(3) <= '0';

      when 2 =>
					leds(0) <= '0';
                leds(1) <= '0';
					 leds(2) <= '1';
					 leds(3) <= '0';
		when 3 =>
					leds(0) <= '0';
                leds(1) <= '0';
					 leds(2) <= '0';
					 leds(3) <= '1';
    end case;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if count = freq then
        count <= 0;
         if pulse_sig = 3 then
				pulse_sig <= 0;
			else
				pulse_sig <= pulse_sig + 1;
			end if;
      else
        count <= count + 1;
        stat <= '0';
      end if;
    end if;
  end process;
end architecture;


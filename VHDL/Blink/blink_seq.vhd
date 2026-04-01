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

  leds <=   "1000" when pulse_sig = 0 else
			"0100" when pulse_sig = 1 else
			"0010" when pulse_sig = 2 else
			"0001" when pulse_sig = 3;

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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity delay is
    Port (
		leds 	: out STD_LOGIC_VECTOR (3 downto 0) := "1111";
		clk		: in STD_LOGIC
    );
end entity;
architecture Behavioral of delay is
	constant freq : natural := 50000000;
	
	signal count : natural range 0 to freq;
	signal stat: STD_LOGIC := '0';
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if count = freq then
				count <= 0;
				stat <= not stat;
			else
				count <= count + 1;
		end if;
		leds(0) <= stat;
		end if;
	end process;

end Behavioral;

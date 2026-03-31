library IEEE;
  use IEEE.NUMERIC_STD.all;
  use IEEE.STD_LOGIC_1164.all;

  -- ALU

  --- 0000 | AND
  --- 0001 | OR
  --- 0010 | XOR
  --- 0011 | NOT
  --- 0100 | ADD
  --- 0101 | SUS
  --- 0110 | BITSR
  --- 0111 | BITSL
  --- 1000 | A2
  --- 1001 | INC
  --- 1010 | DEC
  --- 1011 | NAND
  --- 1100 | NOR
  --- 1101 | XNOR
  --- 1110 | TRNSF
  --- 1111 | NOP

entity alu is
  port (
   esp_read  : in STD_LOGIC_VECTOR(11 downto 0);
	leds     : out STD_LOGIC_VECTOR(3 downto 0) := "1111";
	esp_writ	: out STD_LOGIC_VECTOR(1 downto 0) := "11");
      -- clk    : in     STD_LOGIC
end entity;

architecture Behavioral of alu is
   signal inst : std_logic_vector(3 downto 0);
   signal argA : std_logic_vector(3 downto 0);
   signal argB : std_logic_vector(3 downto 0);
begin
	inst <= esp_read(11 downto 8);
	argA <= esp_read(7 downto 4);
	argB <= esp_read(3 downto 0);
  leds <= argA and argB                                     when inst = "0000" else
          argA or argB                                      when inst = "0001" else
          argA xor argB                                     when inst = "0010" else
          not argA                                          when inst = "0011" else
          std_logic_vector(unsigned(argA) + unsigned(argB)) when inst = "0100" else
          std_logic_vector(unsigned(argA) - unsigned(argB)) when inst = "0101" else
          std_logic_vector(shift_right(unsigned(argA), 1))  when inst = "0110" else
          std_logic_vector(shift_left(unsigned(argA), 1))   when inst = "0111" else
          std_logic_vector(unsigned(not argA) + 1)          when inst = "1000" else
          std_logic_vector(unsigned(argA) + 1)              when inst = "1001" else
          std_logic_vector(unsigned(argA) - 1)              when inst = "1010" else
          argA nand argB                                    when inst = "1011" else
          argA nor argB                                     when inst = "1100" else
          argA xnor argB                                    when inst = "1101" else
          argA                                              when inst = "1110" else
          "0000"                                            when inst = "1111";
end architecture;


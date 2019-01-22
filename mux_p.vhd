library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity mux_p is
	generic(n_bits  : natural range 1 to 8 := 8);
	port(
		sel		: in  std_logic;
		input0	: in  std_logic_vector((n_bits-1) downto 0);
		input1	: in  std_logic_vector((n_bits-1) downto 0);
		output	: out std_logic_vector((n_bits-1) downto 0));

end mux_p;

architecture logic of mux_p is

begin
	output <= input1 when (sel = '1') else
				 input0;

end logic;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity sorter is
	port(
		clk	: in 	std_logic;
		x0		: in	std_logic_vector(5 downto 0);
		x1		: in	std_logic_vector(5 downto 0);
		y0		: out	std_logic_vector(5 downto 0);
		y1		: out	std_logic_vector(5 downto 0));
end sorter;

architecture sort of sorter is

	signal s_x0	: std_logic_vector(5 downto 0);
	signal s_x1	: std_logic_vector(5 downto 0);
	signal s_y0	: std_logic_vector(5 downto 0);
	signal s_y1	: std_logic_vector(5 downto 0);
	
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(s_x0 < s_x1) then
				s_y0 <= s_x0;
				s_y1 <= s_x1;
			else
				s_y0 <= s_x1;
				s_y1 <= s_x0;
			end if;
		end if;
		s_x0	<= x0;
		s_x1	<= x1;
		y0		<= s_y0;
		y1		<= s_y1;
	end process;

end sort;
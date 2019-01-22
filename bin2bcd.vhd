library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity bin2bcd is
	port(
		clk	: in std_logic;
		bin	: in 	std_logic_vector(5 downto 0);
		bcd	: out	std_logic_vector(7 downto 0));
		
end bin2bcd;

architecture convert of bin2bcd is
	
	signal s_bin2int	: integer := 0;
	signal s_bcd		: std_logic_vector(7 downto 0) := (Others => '0');

begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(s_bin2int = 0) then
				s_bcd <= (Others => '0');
			elsif(s_bin2int < 10) then
				s_bcd <= std_logic_vector(to_unsigned(s_bin2int,8));
			else
				s_bcd(3 downto 0) <= std_logic_vector(to_unsigned((s_bin2int mod 10),4));
				s_bcd(7 downto 4) <= std_logic_vector(to_unsigned((s_bin2int / 10),4));
			end if;
		end if;
		
		s_bin2int	<= to_integer(unsigned(bin));
		bcd 			<= s_bcd;
	end process;
end convert;
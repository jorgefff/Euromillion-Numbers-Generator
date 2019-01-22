library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Keys is
	port( 
		clk  		: in std_logic;
		reset  	: in std_logic;
		enable1	: in std_logic;
		randValN : in std_logic_vector(5 downto 0); -- 6 bits = possivel numeros ate 64 > 50
		randValE : in std_logic_vector(3 downto 0); -- 4 bits = possivel numeros ate 16 > 10
		full : out std_logic;
		n1   : out std_logic_vector(5 downto 0);
		n2   : out std_logic_vector(5 downto 0);
		n3   : out std_logic_vector(5 downto 0);
		n4   : out std_logic_vector(5 downto 0);
		n5   : out std_logic_vector(5 downto 0);
		e1   : out std_logic_vector(5 downto 0);
		e2   : out std_logic_vector(5 downto 0));
  
end Keys;

architecture Behav of Keys is
	type memN is array(0 to 4) of integer;
	type memE is array(0 to 1) of integer;
	signal nums   : memN := (0,0,0,0,0);
	signal estrelas : memE := (0,0);

	signal s_randValN : integer := to_integer(unsigned(randValN));
	signal s_randValE : integer := to_integer(unsigned(randValE));

	signal addrCheck : natural := 0; -- usado para verificar se está cheio
	signal addrPos  : natural := 0; -- usado para aceder

	signal s_full   : std_logic_vector(1 downto 0):=(Others => '0');
 
begin
	process(clk,reset)
	begin
		if(reset = '1') then
			s_full    <= (Others => '0');
			addrCheck  <= 0;
			addrPos  <= 0;
			addrCheck <= 0;
			addrPos  <= 0;
			nums   <= (0,0,0,0,0);
			estrelas  <= (0,0);
		elsif(rising_edge(clk) and (enable1 = '1')) then
		-- NUMEROS
			if(s_full(0) = '0') then
				if(s_randValN > 50) or (s_randValN < 1) then -- dentro do range?
					s_randValN <= to_integer(unsigned(randValN)); -- novo val
				elsif(addrCheck <= addrPos) then     
					if(nums(addrCheck) /= s_randValN) then -- repetido?
						addrCheck <= addrCheck +1;
					else
						s_randValN <= to_integer(unsigned(randValN)); -- novo val
						addrCheck <= 0;
					end if;
				elsif(addrPos <= 4) then
					nums(addrPos) <= s_randValN;
					addrPos <= addrPos +1;
					addrCheck <= 0;
				else
					s_full(0)   <= '1';
					addrCheck <= 0;
					addrPos   <= 0;
				end if;
		
			-- ESTRELAS
			elsif(s_full(1) = '0') then
				if(s_randValE > 11) or (s_randValE < 1) then
					s_randValE <= to_integer(unsigned(randValE));
				elsif(addrCheck <= addrPos) then
					if(estrelas(addrCheck) /= s_randValE) then
						addrCheck <= addrCheck +1;
					else
						s_randValE <= to_integer(unsigned(randValE));
						addrCheck <= 0;
					end if;
				elsif(addrPos <= 1) then
					estrelas(addrPos) <= s_randValE;
					addrPos <= addrPos +1;
					addrCheck <= 0;
				else
					s_full(1) <= '1';
					addrCheck <= 0;
					addrPos   <= 0;
				end if;
			else
			--
			end if;
		end if;
		
		full <= (s_full(1) and s_full(0));
		n1 <= std_logic_vector(to_unsigned(nums(0),6));
		n2 <= std_logic_vector(to_unsigned(nums(1),6));
		n3 <= std_logic_vector(to_unsigned(nums(2),6));
		n4 <= std_logic_vector(to_unsigned(nums(3),6));
		n5 <= std_logic_vector(to_unsigned(nums(4),6));
		e1 <= std_logic_vector(to_unsigned(estrelas(0),6));
		e2 <= std_logic_vector(to_unsigned(estrelas(1),6));
	end process;
	
end Behav;
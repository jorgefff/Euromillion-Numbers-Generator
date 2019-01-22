library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity DisplayManager2 is
	generic(val_to_second : natural := 3);		-- valor necessario para, na freq do clk
															-- atraves de incrementos durante os rising edge
															-- contar ate 1segundo
	port( 
			clk 			: in std_logic;
			enable		: in std_logic;
			pauseCount	: in std_logic;
			start			: in std_logic;
			
   	-- entrada de todas as chaves e estrelas(TODOS de 6 bits)
			n1				: in std_logic_vector(5 downto 0);
			n2				: in std_logic_vector(5 downto 0);
			n3				: in std_logic_vector(5 downto 0);
			n4				: in std_logic_vector(5 downto 0);
			n5				: in std_logic_vector(5 downto 0);
			e1				: in std_logic_vector(5 downto 0);
			e2				: in std_logic_vector(5 downto 0);
			
			
			bin7segEnabler : out std_logic;
			typeOfOutput	: out std_logic_vector(3 downto 0);	-- indica se num(n) ou estrela(E) (ver bin7seg)
			numOut			: out std_logic_vector(3 downto 0);	-- indica ordem do numero mostrado(ex:n2 5, n3 23, E1 7)
			n_eOut			: out std_logic_vector(5 downto 0);
			
--			stOutDEBUG		: out std_logic_vector(3 downto 0); -- ******* DEBUG ****
--			s_iDEBUG			: out std_logic_vector(10 downto 0); -- ******* DEBUG ****
--			timerDEBUG			: out std_logic_vector(10 downto 0); -- ******* DEBUG ****
   
			done				: out std_logic);
			
		  
		
end DisplayManager2;


architecture Behavioral of DisplayManager2 is
	
	type state is (stopped,showNum);
	signal PS, NS : state;
	
	type mem is array(0 to 6) of std_logic_vector(5 downto 0);
	signal s_mem 	: mem := (n1,n2,n3,n4,n5,e1,e2);

	
	--indices das chaves e vetores
	signal s_i			: natural :=0;
	signal s_ii			: natural :=0;
	signal s_numOut	: natural :=1;
	
	--sinais para temporizador
	signal s_count			: std_logic := '0';
	signal s_timer			: natural 	:= 0;
	signal s_pauseCount	: std_logic := '0';
	signal s_resetTimer	: std_logic := '0';
	
	signal s_typeOfOutput : std_logic_vector(3 downto 0);
	signal s_done			: std_logic := '0';
	
begin
	
	sync_process:process(clk)
	begin
		if(rising_edge(clk)) then
			if(enable = '1') then
				PS <= NS;
			else
				PS <= stopped;
			end if;
		end if;
		--UPDATE ***
		--timerDEBUG		<= std_logic_vector(to_unsigned(s_timer,11)); -- ******* DEBUG ****
		--s_iDEBUG 		<= std_logic_vector(to_unsigned(s_i,11)); -- ******* DEBUG ****
		
		s_pauseCount 	<= pauseCount;
		s_mem 			<= (n1,n2,n3,n4,n5,e1,e2);
		
		bin7segEnabler <= s_typeOfOutput(2);
		typeOfOutput	<= s_typeOfOutput;
		n_eOut			<= s_mem(s_i);
		numOut			<= std_logic_vector(to_unsigned(s_numOut,4));
		done				<= s_done;
	end process;

	
	comb_process:process(PS,start)
	begin
			case PS is
				when stopped  => --PARADO
					s_typeOfOutput <= "1010";
					s_count			<= '0';
					--stOutDEBUG 		<= "0001";
					s_i				<= 0;
					s_numOut			<= 1;
					
					if(start = '1') then
						NS <= showNum;
						s_done <= '0';
					else
						NS <= stopped;
					end if;
				when showNum  => --MOSTRA NUMEROS
					s_done <= '0';
					s_count <= '1';
					if(s_ii <= 4) then
						s_i 				<= s_ii;
						s_numOut 		<= s_ii +1;
						s_typeOfOutput <= "1110";
						--stOutDEBUG 		<= "0010";
						NS 				<= showNum;
					elsif(s_ii <= 6) then
						s_i 				<= s_ii;
						s_numOut			<= s_ii-4;
						s_typeOfOutput <= "1111";
						--stOutDEBUG 		<= "0100";
						NS 				<= showNum;
					else
						s_done	<= '1';
						NS 		<= stopped;
					end if;
				when others	=>
					s_done <= '0';
					s_count <= '0';
					NS <= stopped;
					--stOutDEBUG <= "1000";
			end case;
	end process;
	
	timerproc : process(clk)
	begin
		if(rising_edge(clk))then
			if(s_count = '1') then
				if(s_pauseCount = '0') then
					s_timer <= s_timer +1;
					if(s_timer = val_to_second) then
						s_timer	<= 0;
						s_ii		<= s_ii +1;
					end if;
				end if;
			else
				s_timer	<= 0;
				s_ii 		<= 0;
			end if;
		end if;
	end process;
		
		
	
		
end Behavioral;
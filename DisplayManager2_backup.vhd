library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity DisplayManager2 is
	port( 
			clk 			: in std_logic;
			enable		: in std_logic;
			pauseCount	: in std_logic;
			key			: in std_logic_vector(3 downto 0);
			
   	-- entrada de todas as chaves e estrelas(TODOS de 6 bits)
			n1				: in std_logic_vector(5 downto 0);
			n2				: in std_logic_vector(5 downto 0);
			n3				: in std_logic_vector(5 downto 0);
			n4				: in std_logic_vector(5 downto 0);
			n5				: in std_logic_vector(5 downto 0);
			e1				: in std_logic_vector(5 downto 0);
			e2				: in std_logic_vector(5 downto 0);
			
			stOutDEBUG		: out std_logic_vector(3 downto 0); -- ******* DEBUG ****
			s_iDEBUG			: out std_logic_vector(10 downto 0); -- ******* DEBUG ****
			timerDEBUG			: out std_logic_vector(10 downto 0); -- ******* DEBUG ****
       --saida das chaves
			n_eOut			: out std_logic_vector(5 downto 0);
			typeOfOutput	: out std_logic_vector(1 downto 0)--SINAL PARA INDICAR SE É ESTRELA OU NUM : out std_logic
				
			
		  );
		
end DisplayManager2;


architecture Behavioral of DisplayManager2 is
	
	type state is (stopped,showNum,showStar);
	signal PS, NS : state;
	
	type mem is array(0 to 6) of std_logic_vector(5 downto 0);
	signal s_mem 	: mem := (n1,n2,n3,n4,n5,e1,e2);

	
	--indices das chaves e vetores
	signal s_i 			   : natural :=0;
	
	--sinais para temporizador
	signal s_count			: std_logic := '0';
	signal s_timer			: natural 	:= 0;
	signal s_pauseCount	: std_logic := '0';
	signal s_resetTimer	: std_logic := '0';
	
	signal s_typeOfOutput : std_logic_vector(1 downto 0);
	
begin
	
	sync_process:process(clk)
	begin
		if(rising_edge(clk)) then
			--FSM ***
			PS <= NS;
		end if;
		--UPDATE ***
		timerDEBUG		<= std_logic_vector(to_unsigned(s_timer,11));
		s_iDEBUG 		<= std_logic_vector(to_unsigned(s_i,11));
		
		s_pauseCount 	<= pauseCount;
		s_mem 			<= (n1,n2,n3,n4,n5,e1,e2);
	end process;

	
	comb_process:process(PS,key)
	begin
			case PS is
				
				when stopped  => --PARADO
					s_typeOfOutput <= "00";
					s_count			<= '0';
					
					stOutDEBUG 		<= "0001";
					
					typeOfOutput	<= s_typeOfOutput;
					n_eOut			<= s_mem(s_i);
					
					
					if(key(0) = '1') then
						NS <= showNum;
					else
						NS <= stopped;
					end if;
					
				when showNum  => --MOSTRA NUMEROS
					s_typeOfOutput <= "01";
					s_count 			<= '1';

					stOutDEBUG 		<= "0010";
										
					if(s_i = 2) then
						NS <= showStar;
					else
						typeOfOutput	<= s_typeOfOutput;
						n_eOut			<= s_mem(s_i);
						NS <= showNum;
					end if;
		   	when showStar => --MOSTRA ESTRELAS
					s_typeOfOutput <= "10";
					s_count 			<= '1';
					
					stOutDEBUG 		<= "0100";
										
					if(key(2) = '1') then
						NS <= stopped;
					else
						typeOfOutput	<= s_typeOfOutput;
						n_eOut			<= s_mem(s_i);
						NS <= showStar;
					end if;
				when others	=>
					s_count <= '0';
					NS <= stopped;
					stOutDEBUG <= "1000";
			end case;
	end process;
	
	timerproc : process(clk)
	begin
		if(rising_edge(clk))then
			if(s_pauseCount = '0') then
				if(s_timer = 3) then
					s_timer <= 0;
					if(s_i <= 5) then
						s_i <= s_i +1;
					end if;
				elsif(s_count = '1') then
					s_timer <= s_timer +1;
				end if;
			end if;
		end if;
	end process;
		
		
	
		
end Behavioral;
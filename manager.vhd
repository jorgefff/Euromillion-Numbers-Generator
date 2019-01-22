LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity manager is
	port(	
			clk			: in	std_logic;
			button		: in	std_logic_vector(3 downto 0);
			
			--KeysINPUT
			keysFull		: in std_logic;
			--DisplayManagerINPUT
			disp1_done	: in std_logic;
			disp2_done	: in std_logic;
			
			--Multiplexer
			muxp_sel				: out std_logic;
			
			--KeysOUTPUT
			keysReset	: out std_logic;
			keysEn		: out std_logic;
			
			--DisplayManager
			disp1_enable		: out std_logic;
			disp1_pauseCount	: out std_logic;
			disp1_start			: out std_logic; 
			disp2_pauseCount	: out std_logic;
			disp2_enable		: out std_logic;
			disp2_start			: out std_logic
			--stOut : out std_logic_vector(4 downto 0) -- *** DEBUG
			
		);
		
end manager;

architecture FSM of manager is

	type state is (s0,s1,s2,s3,s4);
	signal PS,NS : state;
	
begin
	sync_proc : process(clk)
	begin
		if(rising_edge(clk)) then
			PS <= NS;
		end if;
	end process;
	
	
	
	
	
	comb_proc : process(PS,button)
	begin
		case PS is
		when s0 =>	--ESTADO inicial, espera
			if(button(0) = '1')then
				NS <= s1;
			else
				NS <= s0;
			end if;
			keysReset			<= '1';
			keysEn				<= '0';
			
			disp1_pauseCount	<= '1';
			disp1_enable		<= '0';
			disp1_start			<= '0';
			
			disp2_enable		<= '0';
			disp2_start			<= '0';
			disp2_pauseCount	<= '1';
			
			muxp_sel 			<= '0';
			
			
			
		when s1 =>	--ESTADO guarda nums aleatorios
			keysReset 	<= '0';
			keysEn		<= '1';
			if(keysFull = '1')then
				NS <= s2;
			else
				NS <= s1;
			end if;
			
			
		when s2 =>	--ESTADO manda pra display (1 em 1 seg)
		
			keysReset 			<= '0';
			keysEn 				<= '0';
			muxp_sel 			<= '0';
			disp1_enable		<= '1';
			disp1_start			<= '1';
			disp2_enable		<= '0';
			disp2_start			<= '0';
			disp2_pauseCount	<= '1';
			if(disp1_done = '1')then
				NS <= s3;
			elsif(button(1) = '1')then
				disp1_pauseCount <= '1';
				NS <= s2;
			else
				disp1_pauseCount	<= '0';
				NS <= s2;
			end if;
		
		
			keysReset 			<= '0';
			keysEn 				<= '0';
			muxp_sel 			<= '0';
			disp1_pauseCount	<= '0';
			disp1_enable		<= '1';
			disp1_start			<= '1';
			disp2_enable		<= '0';
			disp2_start			<= '0';
			disp2_pauseCount	<= '1';
			if(disp1_done = '1')then
				NS <= s3;
			elsif(button(1) = '1')then
				disp1_pauseCount <= '1';
				NS <= s2;
			else
				NS <= s2;
			end if;
			
			
		when s3 =>	--ESTADO espera2
			keysReset 			<= '0';
			muxp_sel 			<= '1';
			disp1_enable		<= '0';
			disp1_start			<= '0';
			disp2_enable		<= '0';
			disp2_start			<= '0';
			disp2_pauseCount	<= '1';
			if(button(0) = '1') then
				NS <= s1;
				keysReset 	<= '1';
			elsif(button(3) = '1') then
				NS <= s4;
			else
				NS <= s3;
			end if;
			
			
		when s4 =>	--ESTADO volta a mostrar numeros, mas ordenados
			keysReset 			<= '0';
			muxp_sel 			<= '1';
			disp1_enable		<= '0';
			disp1_start			<= '0';
			disp2_enable		<= '1';
			disp2_start			<= '1';
			disp2_pauseCount	<= '0';
			if(disp2_done = '1') then
				NS <= s3;
			elsif(button(1) = '1')then
				disp2_pauseCount	<= '1';
				NS <= s4;
			else
				NS <= s4;
			end if;
		when others => --SAFETY
			NS <= s0;
		end case;
	end process;
	
	
	
	
	
--	with PS select
--		stOut <=	"00001" when s0,
--					"00010" when s1,
--					"00100" when s2,
--					"01000" when s3,
--					"10000" when s4,
--					"00000" when others;
					
end FSM;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity DisplayManagerTb is		
end DisplayManagerTb;


architecture Stimulus of DisplayManagerTb is
	
	signal clk 			:  std_logic := '0';
	signal reset		:  std_logic := '0';
	signal enable		:  std_logic := '1';
	signal stopCount	:  std_logic := '0';
	
   	-- entrada de todas as chaves e estrelas(TODOS de 6 bits)
	signal n1				:  std_logic_vector(5 downto 0):= "000001";
	signal n2				:  std_logic_vector(5 downto 0):= "000010";
	signal n3				:  std_logic_vector(5 downto 0):= "000100";
	signal n4				:  std_logic_vector(5 downto 0):= "001000";
	signal n5				:  std_logic_vector(5 downto 0):= "010000";		
	signal e1				:  std_logic_vector(5 downto 0):= "100000";
	signal e2				:  std_logic_vector(5 downto 0):= "001001";
	signal n_eOut  		:  std_logic_vector(5 downto 0);
	signal NS				:  state;
	signal PS				:  state;
			
  
begin

   uut: entity work.DisplayManager(Behavioral)

	PORT MAP (
          clk 	=> clk,
          reset => reset,
			 enable	=> enable ,
			 stopCount => stopCount,
			 
			 n1 => n1,
			 n2=> n2,
			 n3=>n3,
			 n4=>n4,
			 n5=>n5,
			 e1=>e1,
			 e2=>e2,
			 NS => NS,
			 PS => PS,
			 n_eOut => n_eOut 			 
   );       

  
   clk_process :process
   begin
        clk <= '0';
        wait for 25ns;  
        clk <= '1';
        wait for 25ns;  
   end process;
	

  stim_proc: process
   begin         
		  enable <= '1';
        wait for 7 ns;
		  
        reset <='1';
        wait for 70 ns;
        reset <='0';
        wait for 70 ns;
        wait for 70 ns;
        reset <= '0';
        wait;
  end process;

				
		
end Stimulus;
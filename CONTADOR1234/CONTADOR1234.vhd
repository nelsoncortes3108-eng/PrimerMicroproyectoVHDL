library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CONTADOR1234 is
    port (
        Clock   : in  std_logic;
        Reset   : in  std_logic; 
        EN      : in  std_logic; 
        FIN_35S : out std_logic; 
        CNT     : out std_logic_vector(5 downto 0) 
    );
end entity CONTADOR1234;

architecture arch_CONTADOR1234 of CONTADOR1234 is
    signal CNT_int : integer range 0 to 35 := 0;
begin

    process (Clock, Reset)
    begin 
       
        if (Reset = '1') then 
            CNT_int <= 0;
        elsif rising_edge(Clock) then
            if (EN = '1') then
                if (CNT_int = 35) then
                    CNT_int <= 0; 
                else
                    CNT_int <= CNT_int + 1;
                end if;
            else
                CNT_int <= 0; 
            end if;
        end if;
    end process;

    
    FIN_35S <= '1' when (CNT_int = 35) else '0';

    
    CNT <= std_logic_vector(to_unsigned(CNT_int, 6));

end architecture arch_CONTADOR1234;

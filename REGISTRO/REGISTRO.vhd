library IEEE;
use IEEE.std_logic_1164.all;

entity RESGISTRO is
    port (
        clk   : in  std_logic;
        reset : in  std_logic;                    
        Dat   : in  std_logic_vector(5 downto 0); 
        Q1    : out std_logic_vector(5 downto 0)  
    );
end entity RESGISTRO;

architecture arch_RESGISTRO of RESGISTRO is
begin

    process (clk, reset)
    begin
        if reset = '1' then
            Q1 <= (others => '0');
        elsif rising_edge(clk) then
            Q1 <= Dat;
        end if;
    end process;

end architecture arch_RESGISTRO;

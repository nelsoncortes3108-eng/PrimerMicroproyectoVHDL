library ieee;
use ieee.std_logic_1164.all;

entity divisordefrecuencia3 is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic; 
        clk_out : out std_logic
    );
end entity divisordefrecuencia3;

architecture arch_divisordefrecuencia3 of divisordefrecuencia3 is
    signal count    : integer range 0 to 25000000 := 0;
    signal temporal : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                count    <= 0;
                temporal <= '0';
            elsif (count = 24999999) then
                temporal <= not temporal;
                count    <= 0;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    clk_out <= temporal;
end architecture arch_divisordefrecuencia3;
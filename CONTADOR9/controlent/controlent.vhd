library ieee;
use ieee.std_logic_1164.all;

entity controlent is
    port (
        clk   : in  std_logic;
        reset : in  std_logic; -- KEY0 (presionado = '0')
        start : in  std_logic; -- KEY1 (presionado = '0')
        stop  : in  std_logic; -- KEY2 (presionado = '0')
        run   : out std_logic
    );
end entity controlent;

architecture arch_controlent of controlent is
    signal run_reg : std_logic := '0';
begin

    process (clk, reset)
    begin
        -- Prioridad máxima al reset
        if (reset = '0') then
            run_reg <= '0';
            
        elsif rising_edge(clk) then
            if (start = '0') then
                run_reg <= '1';
            elsif (stop = '0') then
                run_reg <= '0';
            end if;
        end if;
    end process;

    run <= run_reg;

end architecture arch_controlent;
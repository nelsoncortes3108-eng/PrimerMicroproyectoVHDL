library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contadormin is
    port (
        clk_1hz     : in  std_logic;
        reset       : in  std_logic; -- KEY0 (Activo en '0')
        run         : in  std_logic;
        fin_60seg   : in  std_logic;
        cnt_min_out : out std_logic_vector(3 downto 0)
    );
end entity contadormin;

architecture arch_contadormin of contadormin is
    signal min_reg : integer range 0 to 9 := 0;
begin

    process (clk_1hz, reset)
    begin
        -- PRIORIDAD ABSOLUTA: Si se presiona RESET (KEY0 = '0'), borra los minutos
        if (reset = '0') then
            min_reg <= 0;
            
        elsif rising_edge(clk_1hz) then
            if (run = '1' and fin_60seg = '1') then
                if (min_reg = 9) then
                    min_reg <= 0;
                else
                    min_reg <= min_reg + 1;
                end if;
            end if;
        end if;
    end process;

    cnt_min_out <= std_logic_vector(to_unsigned(min_reg, 4));

end architecture arch_contadormin;
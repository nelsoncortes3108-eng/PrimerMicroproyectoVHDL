library ieee;
use ieee.std_logic_1164.all;

entity divisordefrecuencia3 is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic; -- KEY0 (Activo en '0')
        clk_out : out std_logic
    );
end entity divisordefrecuencia3;

architecture arch_divisordefrecuencia3 of divisordefrecuencia3 is
    signal cuenta : integer range 0 to 49999999 := 0;
begin

    process (clk, reset)
    begin
        -- Reset asíncrono activo en '0'
        if (reset = '0') then
            cuenta  <= 0;
            clk_out <= '0';
        elsif rising_edge(clk) then
            if (cuenta = 49999999) then
                cuenta  <= 0;
                clk_out <= '1';
            else
                cuenta  <= cuenta + 1;
                clk_out <= '0';
            end if;
        end if;
    end process;

end architecture arch_divisordefrecuencia3;
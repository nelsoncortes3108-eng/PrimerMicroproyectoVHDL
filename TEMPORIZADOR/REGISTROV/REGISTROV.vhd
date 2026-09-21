library ieee;
use ieee.std_logic_1164.all;

entity REGISTROV is
    port (
        Clock : in  std_logic;                    -- Pulso de reloj (1 Hz)
        Reset : in  std_logic;                    -- Reset maestro
        EN    : in  std_logic;                    -- Habilitación (persona presente)
        Dat   : in  std_logic_vector(9 downto 0); -- Entrada desde contador_visual
        Q2    : out std_logic_vector(9 downto 0)  -- Salida hacia el Separador BCD
    );
end entity REGISTROV;

architecture arch_REGISTROV of REGISTROV is
begin

    process (Clock, Reset)
    begin
        if (Reset = '1') then
            Q2 <= (others => '0'); -- Limpia los 10 bits a '0'
        elsif rising_edge(Clock) then
            if (EN = '1') then
                Q2 <= Dat;         -- Memoriza el valor del contador visual
            else
                Q2 <= (others => '0');
            end if;
        end if;
    end process;

end architecture arch_REGISTROV;
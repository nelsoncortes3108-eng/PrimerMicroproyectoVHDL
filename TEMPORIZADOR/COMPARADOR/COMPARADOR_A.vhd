library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity COMPARADOR_A is
    port (
        Q1             : in  std_logic_vector(9 downto 0); -- Bus de 10 bits desde registro_general
        EN             : in  std_logic;                    -- Persona presente
        rst_35s        : out std_logic;                    -- Pulso para reiniciar contador_visual
        led_felicidades: out std_logic;                    -- LED de tiempo dentro del límite
        led_alarma     : out std_logic                     -- LED de cobro / tiempo excedido
    );
end entity COMPARADOR_A;

architecture arch_COMPARADOR_A of COMPARADOR_A is
begin

    process (Q1, EN)
        variable tiempo : integer;
    begin
        tiempo := to_integer(unsigned(Q1));

        if (EN = '1') then
            -- Reset síncrono al contador visual al llegar exactamente a 35s
            if (tiempo = 35) then
                rst_35s <= '1';
            else
                rst_35s <= '0';
            end if;

            -- Control del LED Felicidades (0 a 35 segundos)
            if (tiempo <= 35) then
                led_felicidades <= '1';
            else
                led_felicidades <= '0';
            end if;

            -- Control del LED Alarma (mayor a 35 segundos)
            if (tiempo > 35) then
                led_alarma <= '1';
            else
                led_alarma <= '0';
            end if;

        else
            -- Si no hay persona presente, todo se apaga/desactiva
            rst_35s         <= '0';
            led_felicidades <= '0';
            led_alarma      <= '0';
        end if;
    end process;

end architecture arch_COMPARADOR_A;
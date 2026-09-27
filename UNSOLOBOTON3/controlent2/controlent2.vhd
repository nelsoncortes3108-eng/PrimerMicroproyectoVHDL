library ieee;
use ieee.std_logic_1164.all;

entity controlent2 is
    port (
        clk       : in  std_logic; -- Reloj rápido principal (50 MHz)
        clk_1hz   : in  std_logic; -- Pulso/Reloj de 1 Hz para medir los 2 segundos
        btn       : in  std_logic; -- Botón único (Start / Stop / Reset), activo en '0'
        run       : out std_logic; -- Control de marcha/paro
        reset_out : out std_logic  -- Señal de reset hacia los contadores (activo en '0')
    );
end entity controlent2;

architecture arch_controlent2 of controlent2 is

    -- Registro del botón para detector de flancos (transición '1' -> '0' y '0' -> '1')
    signal btn_sync0    : std_logic := '1';
    signal btn_sync1    : std_logic := '1';
    signal btn_prev     : std_logic := '1';
    
    -- Detección de flanco de subida del reloj de 1 Hz (para medir el tiempo transcurrido)
    signal clk_1hz_prev : std_logic := '0';

    -- Contador de segundos con el botón presionado
    signal hold_timer   : integer range 0 to 3 := 0;

    -- Registros de salida
    signal run_reg      : std_logic := '0';
    signal rst_reg      : std_logic := '1'; -- '1' inactivo, '0' activo (Reset)

begin

    process (clk)
        variable rising_edge_1hz : boolean;
    begin
        if rising_edge(clk) then
            -- 1. Sincronización básica del botón contra el reloj principal
            btn_sync0 <= btn;
            btn_sync1 <= btn_sync0;
            btn_prev  <= btn_sync1;

            -- Detectar flanco de subida de la señal de 1 Hz
            clk_1hz_prev <= clk_1hz;
            rising_edge_1hz := (clk_1hz = '1' and clk_1hz_prev = '0');

            -- 2. Lógica de lectura instantánea del botón (Activo en '0')
            if (btn_sync1 = '0') then
                -- Contar segundos transcurridos mientras se mantiene presionado
                if rising_edge_1hz then
                    if (hold_timer < 2) then
                        hold_timer <= hold_timer + 1;
                    end if;
                end if;

                -- Si se mantiene presionado 2 segundos o más -> RESET inmediato
                if (hold_timer >= 2) then
                    run_reg <= '0';
                    rst_reg <= '0'; -- Activa reset
                else
                    rst_reg <= '1';
                end if;

            else
                -- AL SOLTAR EL BOTÓN (Flanco de subida: '0' -> '1')
                if (btn_prev = '0' and btn_sync1 = '1') then
                    -- Si se soltó en menos de 2 segundos -> Conmuta Start / Stop al instante
                    if (hold_timer < 2) then
                        run_reg <= not run_reg;
                    end if;
                end if;

                -- Reiniciar contadores al liberar la pulsación
                hold_timer <= 0;
                rst_reg    <= '1'; -- Desactiva reset
            end if;

        end if;
    end process;

    run       <= run_reg;
    reset_out <= rst_reg;

end architecture arch_controlent2;
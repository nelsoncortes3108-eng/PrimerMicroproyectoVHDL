library ieee;
use ieee.std_logic_1164.all;

entity controlreloj is
    port (
        clk             : in  std_logic;                    -- Reloj principal de la tarjeta (ej. 50 MHz)
        reset           : in  std_logic;                    -- Reset maestro
        EN              : in  std_logic;                    -- Switch persona presente
        led_felicidades : out std_logic;                    -- LED indicando tiempo <= 35s
        led_alarma      : out std_logic;                    -- LED indicando tiempo > 35s
        Q2              : out std_logic_vector(9 downto 0)  -- Bus de 10 bits hacia el Separador BCD
    );
end entity controlreloj;

architecture arch_controlreloj of controlreloj is

    -- 1. Declaración del Divisor de Frecuencia
    component divisordefrecuencia3 is
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            clk_out : out std_logic
        );
    end component;

    -- 2. Declaración de Reloj 1 (Contador General + Registro General)
    component reloj1 is
        port (
            Clock : in  std_logic;
            Reset : in  std_logic;
            EN    : in  std_logic;
            Q1    : out std_logic_vector(9 downto 0)
        );
    end component;

    -- 3. Declaración del Comparador de Alarmas
    component COMPARADOR_A is
        port (
            Q1              : in  std_logic_vector(9 downto 0);
            EN              : in  std_logic;
            rst_35s         : out std_logic;
            led_felicidades : out std_logic;
            led_alarma      : out std_logic
        );
    end component;

    -- 4. Declaración de Reloj 2 (Contador Visual + Registro Visual)
    component reloj2 is
        port (
            Clock   : in  std_logic;
            Reset   : in  std_logic;
            rst_35s : in  std_logic;
            EN      : in  std_logic;
            Q2      : out std_logic_vector(9 downto 0)
        );
    end component;

    -- Señales internas de interconexión
    signal cable_clk_1hz : std_logic;                    -- Conecta la salida de 1 Hz del divisor a los relojes
    signal cable_q1      : std_logic_vector(9 downto 0); -- Conecta reloj1 con COMPARADOR_A
    signal cable_rst_35s : std_logic;                    -- Pulso enviado por COMPARADOR_A hacia reloj2

begin

    -- Instancia 1: Divisor de Frecuencia (Convierte clk principal a 1 Hz)
    u_divisor : divisordefrecuencia3
        port map (
            clk     => clk,
            reset   => reset,
            clk_out => cable_clk_1hz
        );

    -- Instancia 2: Sub-sistema Reloj 1 (Conteo continuo general)
    u_reloj1 : reloj1
        port map (
            Clock => cable_clk_1hz,
            Reset => reset,
            EN    => EN,
            Q1    => cable_q1
        );

    -- Instancia 3: Comparador de Alarmas (Evalúa Q1 y controla rst_35s y LEDs)
    u_comparador : COMPARADOR_A
        port map (
            Q1              => cable_q1,
            EN              => EN,
            rst_35s         => cable_rst_35s,
            led_felicidades => led_felicidades,
            led_alarma      => led_alarma
        );

    -- Instancia 4: Sub-sistema Reloj 2 (Conteo visual reseteable a los 35s)
    u_reloj2 : reloj2
        port map (
            Clock   => cable_clk_1hz,
            Reset   => reset,
            rst_35s => cable_rst_35s,
            EN      => EN,
            Q2      => Q2
        );

end architecture arch_controlreloj;
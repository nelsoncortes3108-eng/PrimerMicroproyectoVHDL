library ieee;
use ieee.std_logic_1164.all;

entity cronometro is
    port (
        clk         : in  std_logic;                    -- Reloj principal (50 MHz)
        reset       : in  std_logic;                    -- Reset maestro
        start       : in  std_logic;                    -- Señal/Botón de inicio
        stop        : in  std_logic;                    -- Señal/Botón de parada
        bcd_min_out : out std_logic_vector(3 downto 0); -- Minutos BCD (0 a 9)
        bcd_dec_out : out std_logic_vector(3 downto 0); -- Decenas de segundo BCD (0 a 5)
        bcd_uni_out : out std_logic_vector(3 downto 0); -- Unidades de segundo BCD (0 a 9)
        dp_out      : out std_logic                     -- Punto decimal (HEX2_DP)
    );
end entity cronometro;

architecture arch_cronometro of cronometro is

    -- 1. Declaración del Controlador de Entradas
    component controlent is
        port (
            clk   : in  std_logic;
            reset : in  std_logic;
            start : in  std_logic;
            stop  : in  std_logic;
            run   : out std_logic
        );
    end component;

    -- 2. Declaración del Sistema de Conteo (Divisor + Contador Seg + Contador Min)
    component systemcro is
        port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            run         : in  std_logic;
            cnt_seg_out : out std_logic_vector(5 downto 0);
            cnt_min_out : out std_logic_vector(3 downto 0)
        );
    end component;

    -- 3. Declaración del Separador de Decenas y Unidades
    component decunidades is
        port (
            cnt_seg : in  std_logic_vector(5 downto 0);
            bcd_dec : out std_logic_vector(3 downto 0);
            bcd_uni : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Cables internos de interconexión
    signal cable_run     : std_logic;
    signal cable_seg_bin : std_logic_vector(5 downto 0);
    signal cable_min_bcd : std_logic_vector(3 downto 0);

begin

    -- Instancia 1: Control de marcha/paro
    u_controlent : controlent
        port map (
            clk   => clk,
            reset => reset,
            start => start,
            stop  => stop,
            run   => cable_run
        );

    -- Instancia 2: Núcleo de conteo de tiempo
    u_systemcro : systemcro
        port map (
            clk         => clk,
            reset       => reset,
            run         => cable_run,
            cnt_seg_out => cable_seg_bin,
            cnt_min_out => cable_min_bcd
        );

    -- Instancia 3: Separador BCD para las decenas y unidades de segundo
    u_decunidades : decunidades
        port map (
            cnt_seg => cable_seg_bin,
            bcd_dec => bcd_dec_out,
            bcd_uni => bcd_uni_out
        );

    -- Salida de minutos BCD
    bcd_min_out <= cable_min_bcd;

    -- Lógica del Punto Decimal (Ánodo Común):
    -- Se enciende ('0') cuando transcurre 1 minuto o más (minutos > 0)
    dp_out <= '0' when (cable_min_bcd /= "0000") else '1';

end architecture arch_cronometro;
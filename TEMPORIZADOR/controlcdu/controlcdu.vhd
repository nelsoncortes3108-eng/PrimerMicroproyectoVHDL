library ieee;
use ieee.std_logic_1164.all;

entity controlcdu is
    port (
        clk             : in  std_logic;                    -- Reloj principal de la tarjeta (ej. 50 MHz)
        reset           : in  std_logic;                    -- Reset maestro
        EN              : in  std_logic;                    -- Switch persona presente
        led_felicidades : out std_logic;                    -- LED indicando tiempo <= 35s
        led_alarma      : out std_logic;                    -- LED indicando tiempo > 35s
        bcd_cen         : out std_logic_vector(3 downto 0); -- Bus BCD Centenas
        bcd_dec         : out std_logic_vector(3 downto 0); -- Bus BCD Decenas
        bcd_uni         : out std_logic_vector(3 downto 0)  -- Bus BCD Unidades
    );
end entity controlcdu;

architecture arch_controlcdu of controlcdu is

    -- 1. Declaración del componente Control Reloj
    component controlreloj is
        port (
            clk             : in  std_logic;
            reset           : in  std_logic;
            EN              : in  std_logic;
            led_felicidades : out std_logic;
            led_alarma      : out std_logic;
            Q2              : out std_logic_vector(9 downto 0)
        );
    end component;

    -- 2. Declaración del componente Separador BCD
    component CENTENASDEC is
        port (
            dato_bin : in  std_logic_vector(9 downto 0);
            bcd_cen  : out std_logic_vector(3 downto 0);
            bcd_dec  : out std_logic_vector(3 downto 0);
            bcd_uni  : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Cable interno de 10 bits que conecta la salida Q2 con la entrada dato_bin
    signal cable_q2_bin : std_logic_vector(9 downto 0);

begin

    -- Instancia 1: Sistema completo de control de relojes y comparador
    u_controlreloj : controlreloj
        port map (
            clk             => clk,
            reset           => reset,
            EN              => EN,
            led_felicidades => led_felicidades,
            led_alarma      => led_alarma,
            Q2              => cable_q2_bin
        );

    -- Instancia 2: Descomponedor binario a BCD (Centenas, Decenas, Unidades)
    u_centenasdec : CENTENASDEC
        port map (
            dato_bin => cable_q2_bin,
            bcd_cen  => bcd_cen,
            bcd_dec  => bcd_dec,
            bcd_uni  => bcd_uni
        );

end architecture arch_controlcdu;
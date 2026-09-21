library ieee;
use ieee.std_logic_1164.all;

entity TEMPTIENDA is
    port (
        clk             : in  std_logic;                    -- Reloj principal (50 MHz)
        reset           : in  std_logic;                    -- Reset maestro
        EN              : in  std_logic;                    -- Switch persona presente
        led_felicidades : out std_logic;                    -- LED indicador <= 35s
        led_alarma      : out std_logic;                    -- LED indicador > 35s
        HEX0            : out std_logic_vector(6 downto 0); -- Display 7 segmentos: Unidades
        HEX1            : out std_logic_vector(6 downto 0); -- Display 7 segmentos: Decenas
        HEX2            : out std_logic_vector(6 downto 0)  -- Display 7 segmentos: Centenas
    );
end entity TEMPTIENDA;

architecture arch_TEMPTIENDA of TEMPTIENDA is

    -- 1. Declaración del componente de control y separación BCD
    component controlcdu is
        port (
            clk             : in  std_logic;
            reset           : in  std_logic;
            EN              : in  std_logic;
            led_felicidades : out std_logic;
            led_alarma      : out std_logic;
            bcd_cen         : out std_logic_vector(3 downto 0);
            bcd_dec         : out std_logic_vector(3 downto 0);
            bcd_uni         : out std_logic_vector(3 downto 0)
        );
    end component;

    -- 2. Declaración del Decodificador BCD a 7 segmentos
    component decoder7segw is
        port (
            c : in  std_logic_vector(3 downto 0);
            s : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Buses BCD internos de interconexión
    signal cable_bcd_cen : std_logic_vector(3 downto 0);
    signal cable_bcd_dec : std_logic_vector(3 downto 0);
    signal cable_bcd_uni : std_logic_vector(3 downto 0);

begin

    -- Instancia del sistema de control principal
    u_controlcdu : controlcdu
        port map (
            clk             => clk,
            reset           => reset,
            EN              => EN,
            led_felicidades => led_felicidades,
            led_alarma      => led_alarma,
            bcd_cen         => cable_bcd_cen,
            bcd_dec         => cable_bcd_dec,
            bcd_uni         => cable_bcd_uni
        );

    -- Instancia 1: Decodificador para Unidades (HEX0)
    u_dec_unidades : decoder7segw
        port map (
            c => cable_bcd_uni,
            s => HEX0
        );

    -- Instancia 2: Decodificador para Decenas (HEX1)
    u_dec_decenas : decoder7segw
        port map (
            c => cable_bcd_dec,
            s => HEX1
        );

    -- Instancia 3: Decodificador para Centenas (HEX2)
    u_dec_centenas : decoder7segw
        port map (
            c => cable_bcd_cen,
            s => HEX2
        );

end architecture arch_TEMPTIENDA;
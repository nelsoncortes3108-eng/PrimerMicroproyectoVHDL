library ieee;
use ieee.std_logic_1164.all;

entity systemcronometro is
    port (
        clk      : in  std_logic;                    -- Reloj principal de la tarjeta (50 MHz)
        reset    : in  std_logic;                    -- Reset maestro
        start    : in  std_logic;                    -- Botón de arranque
        stop     : in  std_logic;                    -- Botón de parada
        disp_min : out std_logic_vector(6 downto 0); -- Display 7 segmentos para Minutos
        disp_dec : out std_logic_vector(6 downto 0); -- Display 7 segmentos para Decenas de segundo
        disp_uni : out std_logic_vector(6 downto 0); -- Display 7 segmentos para Unidades de segundo
        disp_dp  : out std_logic                     -- Punto decimal para indicador de minutos
    );
end entity systemcronometro;

architecture arch_systemcronometro of systemcronometro is

    -- 1. Declaración del módulo procesador/cronómetro
    component cronometro is
        port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            start       : in  std_logic;
            stop        : in  std_logic;
            bcd_min_out : out std_logic_vector(3 downto 0);
            bcd_dec_out : out std_logic_vector(3 downto 0);
            bcd_uni_out : out std_logic_vector(3 downto 0);
            dp_out      : out std_logic
        );
    end component;

    -- 2. Declaración del decodificador de 7 segmentos
    component decoder7segw is
        port (
            c : in  std_logic_vector(3 downto 0);
            s : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Cables internos BCD (4 bits cada uno)
    signal cable_bcd_min : std_logic_vector(3 downto 0);
    signal cable_bcd_dec : std_logic_vector(3 downto 0);
    signal cable_bcd_uni : std_logic_vector(3 downto 0);

begin

    -- Instancia del cronómetro (Control + Divisor + Contadores + Separador BCD + Punto)
    u_cronometro : cronometro
        port map (
            clk         => clk,
            reset       => reset,
            start       => start,
            stop        => stop,
            bcd_min_out => cable_bcd_min,
            bcd_dec_out => cable_bcd_dec,
            bcd_uni_out => cable_bcd_uni,
            dp_out      => disp_dp
        );

    -- Decodificador Display 1: Minutos
    u_dec_min : decoder7segw
        port map (
            c => cable_bcd_min,
            s => disp_min
        );

    -- Decodificador Display 2: Decenas de segundo
    u_dec_dec : decoder7segw
        port map (
            c => cable_bcd_dec,
            s => disp_dec
        );

    -- Decodificador Display 3: Unidades de segundo
    u_dec_uni : decoder7segw
        port map (
            c => cable_bcd_uni,
            s => disp_uni
        );

end architecture arch_systemcronometro;
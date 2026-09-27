library ieee;
use ieee.std_logic_1164.all;

entity systemcro is
    port (
        clk         : in  std_logic;                    -- Reloj de 50 MHz
        reset       : in  std_logic;                    -- Reset maestro
        run         : in  std_logic;                    -- Control de marcha/paro
        cnt_seg_out : out std_logic_vector(5 downto 0); -- Segundos (0 a 59)
        cnt_min_out : out std_logic_vector(3 downto 0); -- Minutos BCD (0 a 9)
        clk_1hz_out : out std_logic                     -- Salida de 1 Hz para el controlador
    );
end entity systemcro;

architecture arch_systemcro of systemcro is

    component divisordefrecuencia3 is
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            clk_out : out std_logic
        );
    end component;

    component contadorseg is
        port (
            clk_1hz     : in  std_logic;
            reset       : in  std_logic;
            run         : in  std_logic;
            fin_60seg   : out std_logic;
            cnt_seg_out : out std_logic_vector(5 downto 0)
        );
    end component;

    component contadormin is
        port (
            clk_1hz     : in  std_logic;
            reset       : in  std_logic;
            run         : in  std_logic;
            fin_60seg   : in  std_logic;
            cnt_min_out : out std_logic_vector(3 downto 0)
        );
    end component;

    signal cable_clk_1hz : std_logic;
    signal cable_fin_60s : std_logic;

begin

    u_divisor : divisordefrecuencia3
        port map (
            clk     => clk,
            reset   => reset,
            clk_out => cable_clk_1hz
        );

    u_contador_seg : contadorseg
        port map (
            clk_1hz     => cable_clk_1hz,
            reset       => reset,
            run         => run,
            fin_60seg   => cable_fin_60s,
            cnt_seg_out => cnt_seg_out
        );

    u_contador_min : contadormin
        port map (
            clk_1hz     => cable_clk_1hz,
            reset       => reset,
            run         => run,
            fin_60seg   => cable_fin_60s,
            cnt_min_out => cnt_min_out
        );

    -- Entrega del reloj de 1 Hz hacia la salida
    clk_1hz_out <= cable_clk_1hz;

end architecture arch_systemcro;
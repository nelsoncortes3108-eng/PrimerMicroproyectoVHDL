library ieee;
use ieee.std_logic_1164.all;

entity cronometro2 is
    port (
        clk         : in  std_logic;                    -- Reloj principal (50 MHz)
        btn         : in  std_logic;                    -- Botón único (Start/Stop/Reset)
        bcd_min_out : out std_logic_vector(3 downto 0);
        bcd_dec_out : out std_logic_vector(3 downto 0);
        bcd_uni_out : out std_logic_vector(3 downto 0);
        dp_out      : out std_logic
    );
end entity cronometro2;

architecture arch_cronometro2 of cronometro2 is

    -- En la declaración de componentes dentro de arch_cronometro2:
component controlent2 is
    port (
        clk       : in  std_logic;
        clk_1hz   : in  std_logic;
        btn       : in  std_logic;
        run       : out std_logic;
        reset_out : out std_logic
    );
end component;

    -- 2. Sistema de Conteo (Con el nombre de puerto corregido a clk_1hz_out)
    component systemcro is
        port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            run         : in  std_logic;
            cnt_seg_out : out std_logic_vector(5 downto 0);
            cnt_min_out : out std_logic_vector(3 downto 0);
            clk_1hz_out : out std_logic
        );
    end component;

    -- 3. Separador BCD
    component decunidades is
        port (
            cnt_seg : in  std_logic_vector(5 downto 0);
            bcd_dec : out std_logic_vector(3 downto 0);
            bcd_uni : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Cables de interconexión
    signal cable_run       : std_logic;
    signal cable_reset_int : std_logic;
    signal cable_clk_1hz   : std_logic;
    signal cable_seg_bin   : std_logic_vector(5 downto 0);
    signal cable_min_bcd   : std_logic_vector(3 downto 0);

begin

    -- Instancia 1: Sistema de Conteo y Generación del reloj 1 Hz
    u_systemcro : systemcro
        port map (
            clk         => clk,
            reset       => cable_reset_int,
            run         => cable_run,
            cnt_seg_out => cable_seg_bin,
            cnt_min_out => cable_min_bcd,
            clk_1hz_out => cable_clk_1hz
        );

    -- Instancia 2: Control de Botón Único
    u_controlent2 : controlent2
    port map (
        clk       => clk,            -- Reloj rápido de 50 MHz
        clk_1hz   => cable_clk_1hz,  -- Reloj de 1 Hz desde systemcro
        btn       => btn,
        run       => cable_run,
        reset_out => cable_reset_int
    );

    -- Instancia 3: Separador BCD
    u_decunidades : decunidades
        port map (
            cnt_seg => cable_seg_bin,
            bcd_dec => bcd_dec_out,
            bcd_uni => bcd_uni_out
        );

    bcd_min_out <= cable_min_bcd;
    dp_out      <= '0' when (cable_min_bcd /= "0000") else '1';

end architecture arch_cronometro2;
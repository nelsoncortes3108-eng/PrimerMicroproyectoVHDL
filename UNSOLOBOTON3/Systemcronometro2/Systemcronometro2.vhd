library ieee;
use ieee.std_logic_1164.all;

entity Systemcronometro2 is
    port (
        clk      : in  std_logic;                    -- Reloj principal (50 MHz)
        btn      : in  std_logic;                    -- Único botón (Start / Stop / Reset)[cite: 5]
        disp_min : out std_logic_vector(6 downto 0);
        disp_dec : out std_logic_vector(6 downto 0);
        disp_uni : out std_logic_vector(6 downto 0);
        disp_dp  : out std_logic
    );
end entity Systemcronometro2;

architecture arch_Systemcronometro2 of Systemcronometro2 is

    component cronometro2 is
        port (
            clk         : in  std_logic;
            btn         : in  std_logic;
            bcd_min_out : out std_logic_vector(3 downto 0);
            bcd_dec_out : out std_logic_vector(3 downto 0);
            bcd_uni_out : out std_logic_vector(3 downto 0);
            dp_out      : out std_logic
        );
    end component;

    component decoder7segw is
        port (
            c : in  std_logic_vector(3 downto 0);
            s : out std_logic_vector(6 downto 0)
        );
    end component;

    signal cable_bcd_min : std_logic_vector(3 downto 0);
    signal cable_bcd_dec : std_logic_vector(3 downto 0);
    signal cable_bcd_uni : std_logic_vector(3 downto 0);

begin

    u_cronometro : cronometro2
        port map (
            clk         => clk,
            btn         => btn,
            bcd_min_out => cable_bcd_min,
            bcd_dec_out => cable_bcd_dec,
            bcd_uni_out => cable_bcd_uni,
            dp_out      => disp_dp
        );

    u_dec_min : decoder7segw
        port map (
            c => cable_bcd_min,
            s => disp_min
        );

    u_dec_dec : decoder7segw
        port map (
            c => cable_bcd_dec,
            s => disp_dec
        );

    u_dec_uni : decoder7segw
        port map (
            c => cable_bcd_uni,
            s => disp_uni
        );

end architecture arch_Systemcronometro2;
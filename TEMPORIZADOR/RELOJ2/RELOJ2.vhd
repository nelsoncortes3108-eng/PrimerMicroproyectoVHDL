library ieee;
use ieee.std_logic_1164.all;

entity reloj2 is
    port (
        Clock   : in  std_logic;                    -- Pulso de reloj (1 Hz)
        Reset   : in  std_logic;                    -- Reset maestro
        rst_35s : in  std_logic;                    -- Reset síncrono del comparador
        EN      : in  std_logic;                    -- Switch persona presente
        Q2      : out std_logic_vector(9 downto 0)  -- Salida de 10 bits hacia el Separador BCD
    );
end entity reloj2;

architecture arch_reloj2 of reloj2 is

    -- Declaración del componente Contador Visual
    component CONTADOR1234S is
        port (
            Clock   : in  std_logic;
            Reset   : in  std_logic;
            rst_35s : in  std_logic;
            EN      : in  std_logic;
            CNT     : out std_logic_vector(9 downto 0)
        );
    end component;

    -- Declaración del componente Registro Visual
    component REGISTROV is
        port (
            Clock : in  std_logic;
            Reset : in  std_logic;
            EN    : in  std_logic;
            Dat   : in  std_logic_vector(9 downto 0);
            Q2    : out std_logic_vector(9 downto 0)
        );
    end component;

    -- Señal interna de interconexión
    signal cable_cnt_to_reg : std_logic_vector(9 downto 0);

begin

    -- Instanciación del Contador Visual
    u_contador_visual : CONTADOR1234S
        port map (
            Clock   => Clock,
            Reset   => Reset,
            rst_35s => rst_35s,
            EN      => EN,
            CNT     => cable_cnt_to_reg
        );

    -- Instanciación del Registro Visual
    u_registro_visual : REGISTROV
        port map (
            Clock => Clock,
            Reset => Reset,
            EN    => EN,
            Dat   => cable_cnt_to_reg,
            Q2    => Q2
        );

end architecture arch_reloj2;
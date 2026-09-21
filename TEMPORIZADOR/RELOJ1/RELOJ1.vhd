library ieee;
use ieee.std_logic_1164.all;

entity reloj1 is
    port (
        Clock : in  std_logic;
        Reset : in  std_logic;
        EN    : in  std_logic;
        Q1    : out std_logic_vector(9 downto 0)
    );
end entity reloj1;

architecture arch_reloj1 of reloj1 is

    -- Declaración de componentes
    component CONTADOR1234 is
        port (
            Clock : in  std_logic;
            Reset : in  std_logic;
            EN    : in  std_logic;
            CNT   : out std_logic_vector(9 downto 0)
        );
    end component;

    component REGISTROG is
        port (
            Clock : in  std_logic;
            Reset : in  std_logic;
            EN    : in  std_logic;
            Dat   : in  std_logic_vector(9 downto 0);
            Q1    : out std_logic_vector(9 downto 0)
        );
    end component;

    -- Señal interna para conectar contador y registro
    signal cable_cnt_to_reg : std_logic_vector(9 downto 0);

begin

    u_contador_gen: CONTADOR1234
        port map (
            Clock => Clock,
            Reset => Reset,
            EN    => EN,
            CNT   => cable_cnt_to_reg
        );

    u_registro_gen: REGISTROG 
        port map (
            Clock => Clock,
            Reset => Reset,
            EN    => EN,
            Dat   => cable_cnt_to_reg,
            Q1    => Q1
        );

end architecture arch_reloj1;
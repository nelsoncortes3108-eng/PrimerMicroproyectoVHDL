library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity COMPARADOR is
    port (
        clk_50MHz        : in  std_logic;                   
        reset_global     : in  std_logic;                   
        persona_presente : in  std_logic;                    
        led_normal       : out std_logic;                   
        led_alarma       : out std_logic;                    
        led_felicidades  : out std_logic;                    
        tiempo_registrado: out std_logic_vector(5 downto 0)  
    );
end entity COMPARADOR;

architecture arch_COMPARADOR of COMPARADOR is


    component divisordefrecuencia3 is
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            clk_out : out std_logic
        );
    end component;


    component CONTADOR1234 is
        port (
            Clock   : in  std_logic;
            Reset   : in  std_logic;
            EN      : in  std_logic;
            FIN_35S : out std_logic;
            CNT     : out std_logic_vector(5 downto 0)
        );
    end component;


    component RESGISTRO is
        port (
            clk   : in  std_logic;
            reset : in  std_logic;
            Dat   : in  std_logic_vector(5 downto 0);
            Q1    : out std_logic_vector(5 downto 0)
        );
    end component;


    signal s_clk_1hz       : std_logic;
    signal s_cnt_bin       : std_logic_vector(5 downto 0);
    signal s_fin_35s       : std_logic;
    signal s_tiempo_reg    : std_logic_vector(5 downto 0);
    signal s_modo_alarma   : std_logic := '0';
    signal s_val_seg       : integer range 0 to 63;

begin


    U1_DIV: divisordefrecuencia3
        port map (
            clk     => clk_50MHz,
            reset   => reset_global,
            clk_out => s_clk_1hz
        );


    U2_CNT: CONTADOR1234
        port map (
            Clock   => s_clk_1hz,
            Reset   => reset_global,
            EN      => persona_presente,
            FIN_35S => s_fin_35s,
            CNT     => s_cnt_bin
        );


    U3_REG: RESGISTRO
        port map (
            clk   => s_clk_1hz,
            reset => reset_global,
            Dat   => s_cnt_bin,
            Q1    => s_tiempo_reg
        );


    s_val_seg <= to_integer(unsigned(s_tiempo_reg));


    process (s_clk_1hz, reset_global, persona_presente)
    begin
        if reset_global = '1' then
            s_modo_alarma   <= '0';
            led_felicidades <= '0';
        elsif persona_presente = '0' then

            if (s_modo_alarma = '0') and (s_val_seg > 0) then
                led_felicidades <= '1';
            else
                led_felicidades <= '0';
            end if;
            s_modo_alarma <= '0';
        elsif rising_edge(s_clk_1hz) then
            led_felicidades <= '0';

            if s_fin_35s = '1' then
                s_modo_alarma <= '1';
            end if;
        end if;
    end process;


    led_alarma <= s_modo_alarma;
    led_normal <= persona_presente and (not s_modo_alarma);
    

    tiempo_registrado <= s_tiempo_reg;

end architecture arch_COMPARADOR;
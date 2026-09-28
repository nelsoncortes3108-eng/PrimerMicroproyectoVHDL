library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CONTADOR1234S is
    port (
        Clock   : in  std_logic;                    -- Pulso de 1 Hz
        Reset   : in  std_logic;                    -- Reset maestro
        rst_35s : in  std_logic;                    -- Reset síncrono enviado por el comparador
        EN      : in  std_logic;                    -- Switch persona presente
        CNT     : out std_logic_vector(9 downto 0)  -- Bus de 10 bits hacia Registro 2
    );
end entity CONTADOR1234S;

architecture arch_CONTADOR1234S of CONTADOR1234S is
    signal CNT_int : integer range 0 to 999 := 0;
begin

    process (Clock, Reset)
    begin
        if (Reset = '1') then
            CNT_int <= 0;
        elsif rising_edge(Clock) then
            if (rst_35s = '1') then
                CNT_int <= 0; -- Reinicio al alcanzar los 35s para tiempo de cobro/extra
            elsif (EN = '1') then
                if (CNT_int = 999) then
                    CNT_int <= 0;
                else
                    CNT_int <= CNT_int + 1;
                end if;
            else
                CNT_int <= 0; -- Si la persona sale, se borra la pantalla
            end if;
        end if;
    end process;

    CNT <= std_logic_vector(to_unsigned(CNT_int, 10));

end architecture arch_CONTADOR1234S;
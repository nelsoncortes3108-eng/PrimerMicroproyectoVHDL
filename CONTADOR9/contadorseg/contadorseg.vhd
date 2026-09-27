library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contadorseg is
    port (
        clk_1hz     : in  std_logic; -- Pulso de 1 Hz o clk principal
        reset       : in  std_logic; -- KEY0 (Activo en '0')
        run         : in  std_logic;
        fin_60seg   : out std_logic;
        cnt_seg_out : out std_logic_vector(5 downto 0)
    );
end entity contadorseg;

architecture arch_contadorseg of contadorseg is
    signal seg_reg : integer range 0 to 59 := 0;
begin

    process (clk_1hz, reset)
    begin
        -- PRIORIDAD ABSOLUTA: Si se presiona RESET (KEY0 = '0'), borra el contador inmediatamente
        if (reset = '0') then
            seg_reg   <= 0;
            fin_60seg <= '0';
            
        elsif rising_edge(clk_1hz) then
            -- Solo cuando RESET NO está activo, evalúa la marcha/paro
            if (run = '1') then
                if (seg_reg = 59) then
                    seg_reg   <= 0;
                    fin_60seg <= '1';
                else
                    seg_reg   <= seg_reg + 1;
                    fin_60seg <= '0';
                end if;
            else
                fin_60seg <= '0';
            end if;
        end if;
    end process;

    cnt_seg_out <= std_logic_vector(to_unsigned(seg_reg, 6));

end architecture arch_contadorseg;
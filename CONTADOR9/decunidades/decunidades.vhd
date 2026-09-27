library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decunidades is
    port (
        cnt_seg : in  std_logic_vector(5 downto 0); -- Entrada 0 a 59
        bcd_dec : out std_logic_vector(3 downto 0); -- Decenas (0 a 5)
        bcd_uni : out std_logic_vector(3 downto 0)  -- Unidades (0 a 9)
    );
end entity decunidades;

architecture arch_decunidades of decunidades is
begin
    process (cnt_seg)
        variable temp : integer;
    begin
        temp := to_integer(unsigned(cnt_seg));
        bcd_dec <= std_logic_vector(to_unsigned(temp / 10, 4));
        bcd_uni <= std_logic_vector(to_unsigned(temp rem 10, 4));
    end process;
end architecture arch_decunidades;
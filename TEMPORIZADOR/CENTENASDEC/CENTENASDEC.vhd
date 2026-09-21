library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CENTENASDEC is
    port (
        dato_bin : in  std_logic_vector(9 downto 0); -- Viene de Q2 del registro_visual
        bcd_cen  : out std_logic_vector(3 downto 0); -- Centenas (0-9)
        bcd_dec  : out std_logic_vector(3 downto 0); -- Decenas  (0-9)
        bcd_uni  : out std_logic_vector(3 downto 0)  -- Unidades (0-9)
    );
end entity CENTENASDEC;

architecture arch_CENTENASDEC of CENTENASDEC is
begin

    process (dato_bin)
        variable temp : integer;
    begin
        temp := to_integer(unsigned(dato_bin));

        -- Descomposición decimal limpia
        bcd_cen <= std_logic_vector(to_unsigned((temp / 100) rem 10, 4));
        bcd_dec <= std_logic_vector(to_unsigned((temp / 10) rem 10, 4));
        bcd_uni <= std_logic_vector(to_unsigned(temp rem 10, 4));
    end process;

end architecture arch_CENTENASDEC;
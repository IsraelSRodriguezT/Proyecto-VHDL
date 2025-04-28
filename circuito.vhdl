library IEEE;
use IEEE.std_logic_1164.all;

entity circuito is
    Port (
        a, b, c: in STD_LOGIC;
        d: out STD_LOGIC
    );
end circuito;

architecture Behavioral of circuito is
    signal na, nc: STD_LOGIC;
    signal and1, and2, and3: STD_LOGIC;
begin
    na <= not a after 5 ps;
    nc <= not c after 5 ps;
    
    and1 <= (a and b) after 30 ps;
    and2 <= (na and c) after 30 ps;
    and3 <= (b and nc) after 30 ps;

    d <= (and1 or and2 or and3) after 20 ps;
end Behavioral;

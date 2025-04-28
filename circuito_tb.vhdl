library IEEE;
use IEEE.std_logic_1164.all;

entity circuito_tb is
end circuito_tb;

architecture Behavioral of circuito_tb is
    signal a, b, c : std_logic := '0';
    signal d : std_logic;
begin
    uut: entity work.circuito
        port map (
            a => a,
            b => b,
            c => c,
            d => d
        );

    stim_proc: process
    begin
        a <= '0'; b <= '0'; c <= '0';
        wait for 50 ps;
        
        a <= '0'; b <= '0'; c <= '1';
        wait for 50 ps;
        
        a <= '0'; b <= '1'; c <= '0';
        wait for 50 ps;
        
        a <= '0'; b <= '1'; c <= '1';
        wait for 50 ps;
        
        a <= '1'; b <= '0'; c <= '0';
        wait for 50 ps;
        
        a <= '1'; b <= '0'; c <= '1';
        wait for 50 ps;
        
        a <= '1'; b <= '1'; c <= '0';
        wait for 50 ps;
        
        a <= '1'; b <= '1'; c <= '1';
        wait for 50 ps;
        
        wait;
    end process;
end Behavioral;

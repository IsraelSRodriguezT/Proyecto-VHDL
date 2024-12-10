library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_semaforos_con_pulsador is -- Entidad para la simulación
end tb_semaforos_con_pulsador;

architecture Behavioral of tb_semaforos_con_pulsador is
    -- Declaración de señales para conectar con el DUT (Device Under Test), es decir, el módulo principal
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '1';
    signal pulsador_1 : std_logic := '0';
    signal pulsador_2 : std_logic := '0';
    signal semaforo_1 : std_logic_vector(1 downto 0);
    signal semaforo_2 : std_logic_vector(1 downto 0);
    signal peatonal_1 : std_logic_vector(1 downto 0);
    signal peatonal_2 : std_logic_vector(1 downto 0);

    -- Período del reloj (10 ns para simulación)
    constant clk_period : time := 10 ns; -- 100 MHz -> 10 ns

begin
    -- Instancia del módulo principal
    UUT: entity work.semaforos_con_pulsador -- Aqui se instancia el modulo principal, es decir, el semaforo
        port map ( -- Aqui se conectan las señales con el modulo principal
            clk        => clk,
            reset      => reset,
            pulsador_1 => pulsador_1,
            pulsador_2 => pulsador_2,
            semaforo_1 => semaforo_1,
            semaforo_2 => semaforo_2,
            peatonal_1 => peatonal_1,
            peatonal_2 => peatonal_2
        );

    -- Proceso para generar el reloj
    clk_process: process -- Sirve para generar el reloj
    begin
        while true loop -- Bucle infinito
            clk <= '0'; -- Inicializa el reloj en bajo
            wait for clk_period / 2; -- Espera la mitad del periodo
            clk <= '1'; -- Cambia el reloj a alto
            wait for clk_period / 2; -- Espera la otra mitad del periodo
        end loop; -- Fin del bucle
    end process;
    -- Proceso de estímulo
    stimulus_process: process -- Sirve para generar los estímulos, es decir, los pulsos de los pulsadores
    begin
        -- Reset inicial
        reset <= '1'; -- Activa el reset
        wait for 20 ns;  -- Espera 20 ns
        reset <= '0'; -- Desactiva el reset

        -- Ciclo normal del semáforo sin pulsadores
        wait for 500 ns;  -- Simula 500 ns para observar transiciones normales

        -- Activar pulsador 1
        wait for 150 ns; -- Espera 150 ns
        pulsador_1 <= '1';  -- Activa pulsador 1
        wait for 10 ns;     -- Pulso breve
        pulsador_1 <= '0';  -- Desactiva pulsador 1
        wait for 300 ns;    -- Observa el cambio al estado peatonal y regreso

        -- Activar pulsador 2
        wait for 150 ns; -- Espera 150 ns
        pulsador_2 <= '1';  -- Activa pulsador 2
        wait for 10 ns;     -- Pulso breve
        pulsador_2 <= '0';  -- Desactiva pulsador 2
        wait for 300 ns;    -- Observa el cambio al estado peatonal y regreso

        -- Extender simulación para observar varios ciclos
        wait for 1000 ns;

        -- Finaliza la simulación
        wait;
    end process;

end Behavioral;
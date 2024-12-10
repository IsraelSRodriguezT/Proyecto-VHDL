library IEEE; -- Libreria de IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Libreria para los tipos de datos logicos
use IEEE.NUMERIC_STD.ALL; -- Libreria para los tipos de datos numericos

entity semaforos_con_pulsador is 
    Port (
        clk        : in  std_logic;  
        reset      : in  std_logic;  
        pulsador_1 : in  std_logic;  -- std_logic es un tipo de dato logico, es decir, puede ser 0 o 1
        pulsador_2 : in  std_logic;  
        semaforo_1 : out std_logic_vector(1 downto 0);  -- 00=Rojo, 01=Amarillo, 10=Verde
        semaforo_2 : out std_logic_vector(1 downto 0);  -- std_logic_vector(1 downto 0) es un vector de 2 bits, puede haber 4 combinaciones posibles
        peatonal_1 : out std_logic_vector(1 downto 0);  
        peatonal_2 : out std_logic_vector(1 downto 0)
    );
end semaforos_con_pulsador; 

architecture Behavioral of semaforos_con_pulsador is 
    type estado_t is (VERDE, AMARILLO, ROJO); -- Se define un tipo de dato enumerado con 3 posibles valores
    signal estado_semaforo_1 : estado_t := ROJO;  -- Inicialmente en ROJO
    signal estado_semaforo_2 : estado_t := VERDE;  -- Inicialmente en VERDE para estar desfasado
    signal estado_peatonal_1 : std_logic := '0'; -- Estado que indica si el boton peatonal se activo
    signal estado_peatonal_2 : std_logic := '0'; 
    signal contador_semaforo_1 : integer := 0; 
    signal contador_semaforo_2 : integer := 0; 
    signal contador_cpeatonal_1 : integer := 0; -- Contador para el tiempo desde que se activa el boton peatonal
    signal contador_cpeatonal_2 : integer := 0; 
    constant tiempo_verde    : integer := 450;  -- 450 ns -> 0.45 segundos 
    constant tiempo_amarillo : integer := 150;  -- 150 ns -> 0.15 segundos
    constant tiempo_rojo     : integer := 600;  -- 600 ns -> 0.6 segundos
    constant tiempo_peatonal : integer := 200;  -- 200 ns -> 0.2 segundos
begin 
    proceso_semaforo_1: process(clk, reset) -- process es un bloque de codigo que se ejecuta cuando el relploj sube de flanco
    begin 
        if reset = '1' then -- Si el reset esta activo
            estado_semaforo_1 <= ROJO; 
            contador_semaforo_1 <= 0;
            contador_cpeatonal_1 <= 0;
        elsif rising_edge(clk) then -- Sino, que se ejecute cuando el reloj sube de flanco
            case estado_semaforo_1 is -- case indica que se va a evaluar una variable
                when VERDE => 
                    if pulsador_1 = '1' and estado_peatonal_1 = '0' then -- Si el pulsador esta activo y el estado peatonal no esta activo 
                        estado_peatonal_1 <= '1'; 
                        estado_semaforo_1 <= AMARILLO; 
                        contador_semaforo_1 <= contador_semaforo_1 + 1; 
                    elsif contador_semaforo_1 = tiempo_verde then -- Cambio de estado
                        estado_semaforo_1 <= AMARILLO; 
                        contador_semaforo_1 <= 0;
                    else
                        contador_semaforo_1 <= contador_semaforo_1 + 1; 
                    end if;
                when AMARILLO => 
                    if estado_peatonal_1 = '1' then -- Si el estado peatonal esta activo
                        if contador_cpeatonal_1 = tiempo_peatonal/2 then -- Si el contador del peatonal es igual a la mitad del tiempo peatonal
                            estado_semaforo_1 <= ROJO; 
                        else -- Sino seguir incrementando los contadores
                            contador_semaforo_1 <= contador_semaforo_1 + 1; 
                            contador_cpeatonal_1 <= contador_cpeatonal_1 + 1;
                        end if; 
                    elsif contador_semaforo_1 >= tiempo_amarillo then -- Cambio de estado
                        estado_semaforo_1 <= ROJO; 
                        contador_semaforo_1 <= 0; 
                    else 
                        contador_semaforo_1 <= contador_semaforo_1 + 1; 
                    end if; 
                when ROJO => 
                    if estado_peatonal_1 = '1' then -- Si el estado peatonal esta activo
                        if contador_cpeatonal_1 = tiempo_peatonal then -- Si el contador del peatonal es igual al tiempo peatonal
                            contador_cpeatonal_1 <= 0; 
                            if contador_semaforo_1 >= tiempo_verde + tiempo_amarillo then -- Verifica si debe de ser rojo
                                estado_semaforo_1 <= ROJO; 
                                contador_semaforo_1 <= contador_semaforo_1 - 60; 
                            elsif contador_semaforo_1 >= tiempo_verde then -- Verifica si debe de ser amarillo
                                estado_semaforo_1 <= AMARILLO; 
                                contador_semaforo_1 <= contador_semaforo_1 - 45; 
                            elsif contador_semaforo_1 <= tiempo_verde then -- Verifica si debe de ser verde
                                estado_semaforo_1 <= VERDE; 
                            end if;
                            estado_peatonal_1 <= '0';
                        else 
                            contador_cpeatonal_1 <= contador_cpeatonal_1 + 1;
                            contador_semaforo_1 <= contador_semaforo_1 + 1;     
                        end if; 
                    elsif contador_semaforo_1 = tiempo_rojo then -- Cambio de estado
                        estado_semaforo_1 <= VERDE;
                        contador_semaforo_1 <= 0;
                    else
                        contador_semaforo_1 <= contador_semaforo_1 + 1;
                    end if;
            end case;
        end if;
    end process;
    proceso_semaforo_2: process(clk, reset) 
    begin 
        if reset = '1' then -- Si el reset esta activo
            estado_semaforo_2 <= VERDE; 
            contador_semaforo_2 <= 0;
            contador_cpeatonal_2 <= 0;
        elsif rising_edge(clk) then -- Sino, que se ejecute cuando el reloj sube de flanco
            case estado_semaforo_2 is -- case indica que se va a evaluar una variable
                when VERDE => 
                    if pulsador_2 = '1' and estado_peatonal_2 = '0' then -- Si el pulsador esta activo y el estado peatonal no esta activo 
                        estado_peatonal_2 <= '1'; 
                        estado_semaforo_2 <= AMARILLO; 
                        contador_semaforo_2 <= contador_semaforo_2 + 1; 
                    elsif contador_semaforo_2 = tiempo_verde then -- Cambio de estado
                        estado_semaforo_2 <= AMARILLO; 
                        contador_semaforo_2 <= 0;
                    else
                        contador_semaforo_2 <= contador_semaforo_2 + 1; 
                    end if;
                when AMARILLO => 
                    if estado_peatonal_2 = '1' then -- Si el estado peatonal esta activo
                        if contador_cpeatonal_2 = tiempo_peatonal/2 then -- Si el contador del peatonal es igual a la mitad del tiempo peatonal
                            estado_semaforo_2 <= ROJO; 
                        else -- Sino seguir incrementando los contadores
                            contador_semaforo_2 <= contador_semaforo_2 + 1; 
                            contador_cpeatonal_2 <= contador_cpeatonal_2 + 1;
                        end if; 
                    elsif contador_semaforo_2 >= tiempo_amarillo then -- Cambio de estado
                        estado_semaforo_2 <= ROJO; 
                        contador_semaforo_2 <= 0; 
                    else 
                        contador_semaforo_2 <= contador_semaforo_2 + 1; 
                    end if; 
                when ROJO => 
                    if estado_peatonal_2 = '1' then -- Si el estado peatonal esta activo
                        if contador_cpeatonal_2 = tiempo_peatonal then -- Si el contador del peatonal es igual al tiempo peatonal
                            contador_cpeatonal_2 <= 0; 
                            if contador_semaforo_2 >= tiempo_verde + tiempo_amarillo then -- Verifica si debe de ser rojo
                                estado_semaforo_2 <= ROJO; 
                                contador_semaforo_2 <= contador_semaforo_2 - 60; 
                            elsif contador_semaforo_2 >= tiempo_verde then -- Verifica si debe de ser amarillo
                                estado_semaforo_2 <= AMARILLO; 
                                contador_semaforo_2 <= contador_semaforo_2 - 45; 
                            elsif contador_semaforo_2 <= tiempo_verde then -- Verifica si debe de ser verde
                                estado_semaforo_2 <= VERDE; 
                            end if;
                            estado_peatonal_2 <= '0';
                        else 
                            contador_cpeatonal_2 <= contador_cpeatonal_2 + 1;
                            contador_semaforo_2 <= contador_semaforo_2 + 1;     
                        end if; 
                    elsif contador_semaforo_2 = tiempo_rojo then -- Cambio de estado
                        estado_semaforo_2 <= VERDE;
                        contador_semaforo_2 <= 0;
                    else
                        contador_semaforo_2 <= contador_semaforo_2 + 1;
                    end if;
            end case;
        end if;
    end process;
    semaforo_1 <= "10" when estado_semaforo_1 = VERDE else
                  "01" when estado_semaforo_1 = AMARILLO else
                  "00";
    peatonal_1 <= "10" when estado_semaforo_1 = ROJO else
                  "00";
    semaforo_2 <= "10" when estado_semaforo_2 = VERDE else
                  "01" when estado_semaforo_2 = AMARILLO else
                  "00";
    peatonal_2 <= "10" when estado_semaforo_2 = ROJO else
                  "00";
end Behavioral;
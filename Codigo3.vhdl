library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL; 

entity semaforos_con_pulsador is 
    Port (
        clk        : in  std_logic;  
        reset      : in  std_logic;  
        pulsador_1 : in  std_logic;  
        pulsador_2 : in  std_logic;  
        semaforo_1 : out std_logic_vector(1 downto 0);  -- 00=Rojo, 01=Amarillo, 10=Verde
        semaforo_2 : out std_logic_vector(1 downto 0);  
        peatonal_1 : out std_logic_vector(1 downto 0);  
        peatonal_2 : out std_logic_vector(1 downto 0)
    );
end semaforos_con_pulsador; 

architecture Behavioral of semaforos_con_pulsador is 
    type estado_t is (VERDE, AMARILLO, ROJO); 
    signal estado_semaforo_1 : estado_t := ROJO;  -- Inicialmente en ROJO
    signal estado_semaforo_2 : estado_t := VERDE;  -- Inicialmente en VERDE para estar desfasado
    signal estado_peatonal_1 : std_logic := '0'; 
    signal estado_peatonal_2 : std_logic := '0'; 
    signal contador_semaforo_1 : integer := 0; 
    signal contador_semaforo_2 : integer := 0; 
    signal contador_cpeatonal_1 : integer := 0; 
    signal contador_cpeatonal_2 : integer := 0; 
    constant tiempo_verde    : integer := 450;  
    constant tiempo_amarillo : integer := 150;  
    constant tiempo_rojo     : integer := 600;  
    constant tiempo_peatonal : integer := 200;  
begin 
    proceso_semaforo_1: process(clk, reset) 
    begin 
        if reset = '1' then 
            estado_semaforo_1 <= ROJO; 
            contador_semaforo_1 <= 0;
            contador_cpeatonal_1 <= 0;
        elsif rising_edge(clk) then 
            case estado_semaforo_1 is 
                when VERDE => 
                    if pulsador_1 = '1' and estado_peatonal_1 = '0' then 
                        estado_peatonal_1 <= '1'; 
                        estado_semaforo_1 <= AMARILLO; 
                        contador_semaforo_1 <= contador_semaforo_1 + 1; 
                    elsif contador_semaforo_1 = tiempo_verde then 
                        estado_semaforo_1 <= AMARILLO; 
                        contador_semaforo_1 <= 0;
                    else
                        contador_semaforo_1 <= contador_semaforo_1 + 1; 
                    end if;
                when AMARILLO => 
                    if estado_peatonal_1 = '1' then 
                        if contador_cpeatonal_1 = tiempo_peatonal/2 then 
                            estado_semaforo_1 <= ROJO; 
                        else 
                            contador_semaforo_1 <= contador_semaforo_1 + 1; 
                            contador_cpeatonal_1 <= contador_cpeatonal_1 + 1;
                        end if; 
                    elsif contador_semaforo_1 >= tiempo_amarillo then 
                        estado_semaforo_1 <= ROJO; 
                        contador_semaforo_1 <= 0; 
                    else 
                        contador_semaforo_1 <= contador_semaforo_1 + 1; 
                    end if; 
                when ROJO => 
                    if estado_peatonal_1 = '1' then 
                        if contador_cpeatonal_1 = tiempo_peatonal then 
                            contador_cpeatonal_1 <= 0; 
                            if contador_semaforo_1 >= tiempo_verde + tiempo_amarillo then 
                                estado_semaforo_1 <= ROJO; 
                                contador_semaforo_1 <= contador_semaforo_1 - 60; 
                            elsif contador_semaforo_1 >= tiempo_verde then 
                                estado_semaforo_1 <= AMARILLO; 
                                contador_semaforo_1 <= contador_semaforo_1 - 45; 
                            elsif contador_semaforo_1 <= tiempo_verde then 
                                estado_semaforo_1 <= VERDE; 
                            end if;
                            estado_peatonal_1 <= '0';
                        else 
                            contador_cpeatonal_1 <= contador_cpeatonal_1 + 1;
                            contador_semaforo_1 <= contador_semaforo_1 + 1;     
                        end if; 
                    elsif contador_semaforo_1 = tiempo_rojo then 
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
        if reset = '1' then 
            estado_semaforo_2 <= VERDE; 
            contador_semaforo_2 <= 0;
            contador_cpeatonal_2 <= 0;
        elsif rising_edge(clk) then 
            case estado_semaforo_2 is 
                when VERDE => 
                    if pulsador_2 = '1' and estado_peatonal_2 = '0' then 
                        estado_peatonal_2 <= '1'; 
                        estado_semaforo_2 <= AMARILLO; 
                        contador_semaforo_2 <= contador_semaforo_2 + 1; 
                    elsif contador_semaforo_2 = tiempo_verde then 
                        estado_semaforo_2 <= AMARILLO; 
                        contador_semaforo_2 <= 0;
                    else
                        contador_semaforo_2 <= contador_semaforo_2 + 1; 
                    end if;
                when AMARILLO => 
                    if estado_peatonal_2 = '1' then 
                        if contador_cpeatonal_2 = tiempo_peatonal/2 then 
                            estado_semaforo_2 <= ROJO; 
                        else 
                            contador_semaforo_2 <= contador_semaforo_2 + 1; 
                            contador_cpeatonal_2 <= contador_cpeatonal_2 + 1;
                        end if; 
                    elsif contador_semaforo_2 >= tiempo_amarillo then 
                        estado_semaforo_2 <= ROJO; 
                        contador_semaforo_2 <= 0; 
                    else 
                        contador_semaforo_2 <= contador_semaforo_2 + 1; 
                    end if; 
                when ROJO => 
                    if estado_peatonal_2 = '1' then 
                        if contador_cpeatonal_2 = tiempo_peatonal then 
                            contador_cpeatonal_2 <= 0; 
                            if contador_semaforo_2 >= tiempo_verde + tiempo_amarillo then 
                                estado_semaforo_2 <= ROJO; 
                                contador_semaforo_2 <= contador_semaforo_2 - 60; 
                            elsif contador_semaforo_2 >= tiempo_verde then 
                                estado_semaforo_2 <= AMARILLO; 
                                contador_semaforo_2 <= contador_semaforo_2 - 45; 
                            elsif contador_semaforo_2 <= tiempo_verde then 
                                estado_semaforo_2 <= VERDE; 
                            end if;
                            estado_peatonal_2 <= '0';
                        else 
                            contador_cpeatonal_2 <= contador_cpeatonal_2 + 1;
                            contador_semaforo_2 <= contador_semaforo_2 + 1;     
                        end if; 
                    elsif contador_semaforo_2 = tiempo_rojo then 
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
# Proyecto 2: Tennis for two

## Descripción

Tennis for two es un videojuego de tenis desarrollado por William Higinbotham en 1958. Es considerado el primer videojuego de la historia. El juego consiste en dos jugadores que controlan una raqueta cada uno, y deben golpear una pelota de tenis de un lado a otro de la pantalla, pasándola por encima de una red, hasta que uno de los jugadores no logre devolverla.

En este proyecto se implementará una versión de Tennis for two usando MIPS y el simulador MARS.

En particular, en esta versión se añadió un sistema de puntaje que es un extra crédito del proyecto. Cuando la pelota sale de la pantalla, el jugador que no logró pasarla pierde un llamado "game".
Con 4 "games" se gana un "set", y con 6 "sets" se gana un "match". El juego termina cuando un jugador gana 3 "matches".
Si al momento de ganar el 6to "set" el jugador contrario tiene 5 "sets", se juega un "set" adicional para desempatar, llamado "tiebreak".

El juego se juega con las teclas `d` para raquetear con el jugador 1, y `l` para raquetear con el jugador 2. Se pueden usar 3 modos de raqueteo para cada jugador: backhand, forehand y underhand. Para cambiar el modo de raqueteo se usan las teclas `w`, `s` y `x` para el jugador 1, y `o`, `k` y `m` para el jugador 2, respectivamente.

(En caso de no especificar el modo de raqueteo, se asume que es forehand).

También se añadió la opción de terminar el juego en cualquier momento, presionando la tecla `q`.

## Diseño de la estructura de datos

Este proyecto se apoya mucho en el uso de macros, para poder modularizar el código y hacerlo más legible. Por ejemplo, se usan macros para guardar la posición actual de la pelota, para leer la tecla presionada por el usuario, para refrescar la pantalla, etc.

Como se usan constantemente macros, es necesario pasarles parámetros, y que los cambios realizados a los parámetros dentro de la macro se reflejen fuera, en el programa principal. Para esto, se decidió reservar una serie de registros que representaran variables globales, y que cada macro cambiara el valor de estos registros. De esta manera, los cambios realizados por las macros se reflejan en el programa principal.

Los registros reservados para las variables globales son los siguientes:

1. `$s1`: Guarda la posición en x de la pelota.
2. `$s2`: Guarda la posición en y de la pelota.
3. `$s3`: Guarda la velocidad en x de la pelota.
4. `$s4`: Guarda la velocidad en y de la pelota.
5. `$s5`: Guarda el modo de raqueteo del jugador 1.
6. `$s6`: Guarda el modo de raqueteo del jugador 2.
7. `$s7`: Guarda la cantidad de veces que ha rebotado la pelota en el turno actual.
8. `$t4`: Guarda a qué jugador le toca raquetear en el turno actual.
9. `$k1`: Guarda si es el inicio de un servicio o no.
10. `$t9`: Es el reg donde cargaremos la dirección del espacio reservado para las estelas de la pelota.
11. `$t7`: Es el reg donde cargaremos la dirección del espacio reservado para el puntaje.

De estos 11 registros, los más interesantes son `$t9` y `$t7`. En `$t9` se guarda la dirección del espacio reservado para las estelas de la pelota. Este espacio reservado se comporta como una pila, con un tamaño de 11 posiciones. Cada vez que se guarda una nueva posición de la pelota, se guarda en la primera posición del arreglo, y se mueven todas las posiciones anteriores una posición hacia la derecha. Empezando por la penúltima posición, hasta la primera posición. Esto hace que se obtenga un comportamiento LIFO (Last In First Out), solo que cuando se llena la pila, se empieza a sobreescribir la posición más antigua de la pelota. Como una especie de pila circular.

En `$t7` se guarda la dirección del espacio reservado para el puntaje. Este espacio reservado utiliza los 3 primeros bytes para guardar el puntaje del jugador 1, y los 3 últimos bytes para guardar el puntaje del jugador 2. En el primer byte se guarda el puntaje de los "games", en el segundo byte se guarda el puntaje de los "sets", y en el tercer byte se guarda el puntaje de los "matches".

Cada vez que la pelota sale de la pantalla, se actualiza el o los bytes del puntaje correspondientes.
Lo interesante de usar un espacio reservado para el puntaje, es que se minimiza la cantidad de registros que se usan para guardar el puntaje. En vez de usar 3 registros para guardar el puntaje del jugador 1, y 3 registros para guardar el puntaje del jugador 2, se usa un solo registro para guardar el puntaje de ambos jugadores.

En caso de que se necesiten más registros, se adoptaría esta misma estrategia de usar un espacio reservado para guardar dos o más variables.

## Ejemplo de uso

Un ejemplo de uso del programa es el siguiente:

```
Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0






  O
            O
            O
            O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0



     O
    o
   o
  o
            O
            O
            O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0

       oO
      o
     o
    o
   o
  o
            O
            O
            O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0

       oo
      o
     o
    o
   o
  o
            O
            O
            O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0

       oo
      o
     o
    o


            O
            O
            O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0

       oo      ooO





            O
            O
            O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0

               ooo
                  o
                   oO



            O
            O
            O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0

               ooo
                  o
                 Oooo



            O
            O
            O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0

                oo
                  o
                 oooo
              Ooo


            O
            O
            O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0



                 oooo
              ooo
             o
           Oo
            O
            O
            O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0



                 oo
              ooo
             o
           oo
          o O
         o  O
        O   O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0



                 o
              ooo
             o
           oo
          o O
         o  O
        o   O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0




              o
             o
           oo
    Oo    o O
      o  o  O
        o   O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0






 Ooo       o
    oo    o O
      o  o  O
        o   O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  00
Set:   0        Set:   0
Match: 0        Match: 0






oooo
    oo      O
      o  o  O
        o   O
OOOOOOOOOOOOOOOOOOOOOOOOO

Game:  00       Game:  15
Set:   0        Set:   0
Match: 0        Match: 0






                      O
            O
            O
            O
OOOOOOOOOOOOOOOOOOOOOOOOO
```

Donde se puede apreciar que el jugador 2 ganó el primer "game".

**Nota:** Es importante usar el _keyboard and display MMIO simulator_ para poder jugar el juego. Este se puede encontrar en la pestaña _Tools_ del simulador MARS.

## Detalles de la implementación

Las mayores dificultades previstas para este proyecto eran las siguientes:
a. Leer la tecla presionada por el usuario, sin que el programa se detuviera a esperar que el usuario presionara una tecla, para poder refrescar la pantalla constantemente.
b. Ser capaz de diseñar un sistema para guardar las últimas 10 posiciones de la pelota, para poder dibujar las estelas de la pelota. Y que estas estelas se dibujaran en diagonal para que se viera como una pelota en movimiento.
c. Verificar que la pelota rebotara en la red y en el piso de la cancha. Y que se contara el número de veces que la pelota rebotaba en el turno actual.
d. Verificar cuando cada jugador podía raquetear, y cuando no podía raquetear.

La primera dificultad en ser abordada fue la de leer la tecla presionada por el usuario. Para esto, en vez de usar la syscall 8 (read string), se usó el sistema de interrupciones del teclado. Este sistema de interrupciones permite que el programa se ejecute constantemente, sin detenerse a esperar que el usuario presione una tecla. Y en cada refresco de la pantalla, se verifica si el usuario presionó una tecla, y si lo hizo, se lee la tecla presionada.

Este sistema de interrupciones del teclado se implementó usando el _keyboard and display MMIO simulator_ del simulador MARS. Y se revisó constantemente el espacio de memoria _0xffff0000_, que es donde se almacena un 1 cuando el usuario presiona una tecla. Si el valor en esa dirección de memoria es 1, entonces se revisa el espacio de memoria _0xffff0004_, que es donde se almacena la tecla presionada por el usuario. Y se lee la tecla presionada.

La segunda dificultad en ser abordada fue la de diseñar un sistema para guardar las últimas 10 posiciones de la pelota. Esta dificultad fue particularmente desafiante, porque primero se intentó calcular las estelas en el momento en que se dibujaba la pelota. Pero esto resultó ser muy complicado. Por lo que se debía diseñar un sistema que guardara las últimas posiciones de la pelota, en el momento en que sucedieran, y que luego se imprimieran las estelas registradas al momento de refrescar la pantalla.

Aquí es donde se decidió usar un espacio reservado para las estelas de la pelota, que se comportara como una pila circular. Fue un poco complicado implementar este sistema, sobre todo la parte de mover las posiciones anteriores una posición hacia la derecha. Pero a pesar de la complejidad, este sistema resultó ser muy útil, porque permitió llevar un registro en vivo de las posiciones de la pelota, y poder dibujar las estelas de la pelota en diagonal.

Gracias al sistema de monitoreo de la pelota, se pudo abordar la tercera dificultad, que era la de verificar que la pelota rebotara en la red y en el piso de la cancha. Y que se contara el número de veces que la pelota rebotaba en el turno actual. Para esto, cada vez que se guardaba una nueva posición de la pelota, se verificaba si la pelota estaba en la posición de la red o en la posición del piso de la cancha.

Si la pelota estaba en la red, entonces se invertía la velocidad en x de la pelota y si la pelota estaba en el piso de la cancha, entonces se invertía la velocidad en y de la pelota. Y en el caso de rebote en el piso de la cancha, se aumentaba el contador de rebotes en el turno actual.

Con toda la información que se tenía sobre la pelota y las teclas presionadas por el usuario, se pudo abordar la cuarta y última dificultad, que era la de verificar cuando cada jugador podía raquetear, y cuando no podía raquetear. Para esto, se llevó un registro de a qué jugador le tocaba raquetear en el turno actual, de forma que si un jugador intentaba raquetear cuando no le tocaba, se ignoraba la tecla presionada.

De esta forma, cuando se presionaba la tecla `d` o `l`, se verificaba si le tocaba raquetear al jugador 1 o al jugador 2, respectivamente. Y si le tocaba raquetear, entonces se verificaba si la pelota estaba en la cancha del jugador correspondiente, y si lo estaba, entonces se verificaba si la pelota había rebotado 2 veces o más en el turno actual. Si la pelota había rebotado 2 veces o más, se ignoraba la tecla presionada. Y si la pelota no había rebotado 2 veces o más, entonces se raqueteaba la pelota.

Como curiosidad, no hacía falta verificar si el jugador ya había raqueteado en el turno actual, porque si el jugador ya había raqueteado, entonces se indicaba que le tocaba raquetear al otro jugador. Así que no había forma de que un jugador raqueteara dos veces en el mismo turno.

Finalmente, se implementó el sistema de puntaje, que consiste en un espacio reservado para el puntaje. Fue relativamente sencillo implementar este sistema, porque se aprovechó el monitoreo de la pelota para verificar cuando la pelota salía de la pantalla, y cada vez que la pelota salía de la pantalla, se actualizaba el puntaje correspondiente.

Como dato curioso, cuando alguno de los jugadores gana 3 "matches", se muestra un mensaje de victoria en la pantalla y se agradece al usuario por jugar con una gran sonrisa `:D`.

## Conclusiones y lecciones aprendidas

Este proyecto fue muy interesante, porque permitió ilustrar la importancia de las interrupciones en los sistemas de cómputo. Donde no es necesario que el programa se detenga a esperar que ocurra un evento, sino que el programa puede seguir ejecutándose, y cuando ocurre un evento, el programa puede reaccionar a ese evento.

También fue interesante enfrentarse a la dificultad de diseñar un sistema para guardar las estelas de la pelota. Porque se tuvo que pensar en un sistema que permitiera sobreescribir las posiciones más antiguas de la pelota, cuando se llenara el espacio reservado para las estelas. Y se tuvo que repasar algunos conceptos de estructuras de datos vistas en la materia de Algoritmos y Estructuras de Datos II. Siempre es interesante ver cómo se pueden aplicar los conceptos aprendidos en otras materias en esta materia.

También se aprendió a llevar un registro del comportamiento de un objeto en movimiento, al monitorear cada nueva posición del objeto. Y verificando cualquier evento que pudiera ocurrir en esa nueva posición del objeto.

Y por último, se aprendió a crear un proyecto relativamente grande, usando una pequeña cantidad de registros. Lo cual es muy útil, porque permite aprovechar al máximo los recursos disponibles, incluso cuando se tienen pocos recursos. Y sobre todo, no desperdiciar recursos.

Y como nota personal, este proyecto es el primer videojuego que he desarrollado, y me siento muy contento con el resultado. Porque es un juego completamente funcional, y que se puede jugar sin problemas o errores. Y que además se puede jugar con otra persona, lo cual es muy divertido.

## Grupo del proyecto

- Luis Isea [@lmisea](https://github.com/lmisea) (19-10175).

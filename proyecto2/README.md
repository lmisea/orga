# Proyecto 2: Tennis for two

## Descripción

Tennis for two es un videojuego de tenis desarrollado por William Higinbotham en 1958. Es considerado el primer videojuego de la historia. El juego consiste en dos jugadores que controlan una raqueta cada uno, y deben golpear una pelota de tenis de un lado a otro de la pantalla, pasándola por encima de una red, hasta que uno de los jugadores no logre devolverla.

En este proyecto se implementará una versión de Tennis for two usando MIPS y el simulador MARS.

En particular, en esta versión se añadió un sistema de puntaje que es un extra crédito del proyecto. Cuando la pelota sale de la pantalla, el jugador que no logró pasarla pierde un llamado "game".
Con 4 "games" se gana un "set", y con 6 "sets" se gana un "match". El juego termina cuando un jugador gana 3 "matches".
Si al momento de ganar el 6to "set" el jugador contrario tiene 5 "sets", se juega un "set" adicional para desempatar, llamado "tiebreak".

El juego se juega con las teclas `d` para raquetear con el jugador 1, y `l` para raquetear con el jugador 2. Se pueden usar 3 modos de raqueteo para cada jugador: backhand, forehand y underhand. Para cambiar el modo de raqueteo se usan las teclas `w`, `s` y `x` para el jugador 1, y `o`, `k` y `m` para el jugador 2, respectivamente.

(En caso de no especificar el modo de raqueteo, se asume que es forehand).

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

arreglo de 11 posiciones para guardar la posición actual de la pelota, y las 10 posiciones anteriores a esta. Este arreglo tiene un comportamiento LIFO (Last In First Out), es decir, que cada nueva posición de la pelota se guarda en la primera posición del arreglo y es la primera en ser impresa, y así sucesivamente.
Por esto, tiene un funcionamiento similar a una pila.

Sin embargo, no es una pila porque cada vez que se guarda una nueva posición de la pelota, se debe mover cada una de las posiciones anteriores una posición hacia la derecha, para poder hacer espacio para la nueva posición. Esto se hace con un ciclo `for` que recorre el arreglo de derecha a izquierda, y mueve cada posición una posición hacia la derecha. Empezando por la penúltima posición, hasta la primera posición. Luego, se guarda la nueva posición de la pelota en la primera posición del arreglo.

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

## Conclusiones y lecciones aprendidas

Las mayores dificultades que se presentaron durante el desarrollo del proyecto fueron:
a. Leer la tecla presionada por el usuario, sin que el programa se detuviera a esperar que el usuario presionara una tecla.
b. Ser capaz de diseñar un sistema para guardar las últimas 10 posiciones de la pelota, para poder dibujar las estelas de la pelota. Y que estas estelas se dibujaran en diagonal para que se viera como una pelota en movimiento.
c. Verificar que la pelota rebotara en la red y en el piso de la cancha.

## Grupo del proyecto

- Luis Isea [@lmisea](https://github.com/lmisea) (19-10175).

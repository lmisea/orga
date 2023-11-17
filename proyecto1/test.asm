.include "horario.asm"
.include "macros.asm"

.data
newline: .asciiz "\n"

# Variables para almacenar CiN
codigo: .space 8
edificio: .space 8
nombre: .space 40  # Longitud maxima de "organizacion del computador"

.text
main:

    # Desestructurar y almacenar en las variables en el orden deseado
    la $t1, edificio     # Puntero al inicio de edificio
    la $t2, codigo       # Puntero al inicio de codigo
    la $t3, nombre       # Puntero al inicio de nombre

    # Copiar el nombre
    la $t4, C1N+16       # Puntero al inicio de "ALGORITMOS III"
    li $t5, 40           # Longitud máxima del nombre
    loop_nombre:
        lb $t6, 0($t4)   # Cargar un byte del nombre
        sb $t6, 0($t3)   # Almacenar el byte en la variable nombre
        addi $t4, $t4, 1  # Mover al siguiente byte
        addi $t3, $t3, 1  # Mover al siguiente byte en la variable nombre
        subi $t5, $t5, 1  # Decrementar la longitud
        bnez $t5, loop_nombre  # Repetir hasta que se alcance la longitud máxima

    # Copiar el edificio
    la $t4, C1N+8        # Puntero al inicio de "MEM-008"
    li $t5, 7            # Longitud del edificio
    loop_edificio:
        lb $t6, 0($t4)   # Cargar un byte del edificio
        sb $t6, 0($t1)   # Almacenar el byte en la variable edificio
        addi $t4, $t4, 1  # Mover al siguiente byte
        addi $t1, $t1, 1  # Mover al siguiente byte en la variable edificio
        subi $t5, $t5, 1  # Decrementar la longitud
        bnez $t5, loop_edificio  # Repetir hasta que se alcance la longitud

    # Copiar el código
    la $t0, C1N        # Puntero al inicio de "CI-2613"
    la $t1, codigo       # Puntero al inicio de codigo
    li $t5, 7            # Longitud del código
    loop_codigo:
        lb $t6, 0($t0)   # Cargar un byte del código
        sb $t6, 0($t1)   # Almacenar el byte en la variable codigo
        addi $t0, $t0, 1  # Mover al siguiente byte
        addi $t1, $t1, 1  # Mover al siguiente byte en la variable codigo
        subi $t5, $t5, 1  # Decrementar la longitud
        bnez $t5, loop_codigo  # Repetir hasta que se alcance la longitud

    # Imprimir las variables    
    print_space (nombre, 40)
    print_space (edificio, 8)
    print_space (codigo, 8)

    done

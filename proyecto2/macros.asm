#######################
#     Proyecto 2      #
#  Macros auxiliares  #
#      Luis Isea      #
#      19-10175       #
#######################

# Los macro son secuencias invocables que se definen una sola vez y se pueden usar varias veces

# Macro para imprimir un número entero
# Ya sea que el argumento es un valor immediate or un registro
# Ejemplo de uso: print_int ($s0) o print_int (10)
.macro 	print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro

# Macro para imprimir un string
# Ejemplo de uso: print_str ("Hola Mundo")
.macro print_str (%str)
	.data
text:	.asciiz %str
	.text
	li $v0, 4
	la $a0, text
	syscall
.end_macro

# Macro para imprimir un space de ascii
# %buffer: Label que se quiere imprimir
# %start: A partir de qué byte de %buffer se va a imprimir
# %length: Cuántos caracteres se quieren imprimir
.macro print_space (%buffer, %start, %length)
    .data
    buffer_str: .space %length  # Ajustar el tamaño según tus necesidades
    .text

    # Copiar el contenido del buffer al espacio reservado
    la $t0, %buffer
    la $t1, buffer_str
    li $t2, %length
    add $t0, $t0, %start  # Mover al inicio especificado
    loop_copy:
        lb $t3, 0($t0)
        sb $t3, 0($t1)
        addi $t0, $t0, 1
        addi $t1, $t1, 1
        subi $t2, $t2, 1
        bnez $t2, loop_copy

    # Imprimir el contenido del espacio reservado
    li $v0, 4
    la $a0, buffer_str
    syscall
.end_macro

# Terminar la ejecución del programa
.macro 	done
	li $v0,10
	syscall
.end_macro

# Macro para hacer una espera de %time milisegundos
.macro 	sleep (%time)
	li   $v0, 32 
	move $a0, %time
	syscall
.end_macro

# Macro para obtener la hora actual
.macro 	get_time
	li $v0, 30
	syscall
.end_macro

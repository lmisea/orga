# Los macro son secuencias invocables que se definen una sola vez y se pueden usar varias veces

# Macro para imprimir un n√∫mero entero
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
myLabel:.asciiz %str
	.text
	li $v0, 4
	la $a0, myLabel
	syscall
.end_macro

# Macro para imprimir un space
# Macro para imprimir un espacio reservado
.macro print_space(%buffer, %length)
    .data
    buffer_str: .space 40  # Ajustar el tamaÒo seg˙n tus necesidades
    .text

    # Copiar el contenido del buffer al espacio reservado
    la $t0, %buffer
    la $t1, buffer_str
    li $t2, %length
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

    li $v0, 4
    la $a0, newline  # Asumiendo que hay una cadena de nueva lÌnea definida
    syscall
.end_macro




# Macro para hacer un bucle for gen√©rico
# El bluce for tiene 4 par√°metros, %regIterator es el registro que itera
# desde %from hasta %to, y en cada iteraci√≥n se ejecuta %bodyMacroName, que a
# su vez es un macro
.macro 	for (%regIterator, %from, %to, %bodyMacroName)
	add %regIterator, $zero, %from
	Loop:
	%bodyMacroName ()
	add %regIterator, %regIterator, 1
	ble %regIterator, %to, Loop
.end_macro

# Ejemplo del ciclo for en acci√≥n para imprimir los n√∫meros
# del 1 al 10
# Macro para imprimir el iterador
# .macro 	print_iterator()
# 	print_int $t0
#	print_str "\n"
# .end_macro
	
# Imprimir los n√∫meros del 1 al 10
# for ($t0, 1, 10, print_iterator)

# Terminar la ejecuci√≥n del programa
.macro 	done
	li $v0,10
	syscall
.end_macro


# LEER CiN
# Macro para leer CiN
# %dest: Registro o direcciÛn donde se almacenar· la cadena
# %src: DirecciÛn de la cadena a copiar
# %start: PosiciÛn de inicio en la cadena (bit o byte)
# %length: Longitud de la cadena a copiar
.macro leerC(%dest, %src, %start, %length)
    .data
    buffer: .space %length
    .text

    # Copiar el contenido
    la $t0, %src
    la $t1, buffer
    li $t2, %length
    add $t0, $t0, %start  # Mover al inicio especificado
    loop_copy:
        lb $t3, 0($t0)
        sb $t3, 0($t1)
        addi $t0, $t0, 1
        addi $t1, $t1, 1
        subi $t2, $t2, 1
        bnez $t2, loop_copy

    # Imprimir el contenido
    print_space (buffer, %length)

    # Copiar el contenido al destino
    la $t0, %dest
    la $t1, buffer
    li $t2, %length
    loop_copy_dest:
        lb $t3, 0($t1)
        sb $t3, 0($t0)
        addi $t0, $t0, 1
        addi $t1, $t1, 1
        subi $t2, $t2, 1
        bnez $t2, loop_copy_dest
.end_macro

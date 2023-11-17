#######################
#     Proyecto 1      #
#  Archivo de Macros  #
#    Sergio Carillo   #
#      14-11315       #
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
    buffer_str: .space 40  # Ajustar el tama�o seg�n tus necesidades
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
    la $a0, newline  # Asumiendo que hay una cadena de nueva l�nea definida
    syscall
.end_macro

# Macro para leer qué tecla presionó el usuario
# Y poder realizar una acción dependiendo de la tecla presionada
# Ejemplo de uso: readKey()
.macro readKey()
	.data
	key: 	.space 2  # Aquí se guarda la tecla presionada
	 	.ascii "\0"
	 	.align 0
	w:	.asciiz "w"
	s:	.asciiz "s"
	a:	.asciiz "a"
	d:	.asciiz "d"
	x: 	.asciiz "x"

	.text
		# Se lee la tecla que presionó el usuario
		li  $v0, 8
		la  $a0, key
		li  $a1, 2
		syscall
		print_str ("\n") # Se imprime un salto de línea

		# Se compara la tecla presionada con las teclas válidas
		lb  $t0, key
		lb  $t1, w
		beq $t0, $t1, wKey
		lb  $t1, s
		beq $t0, $t1, sKey
		lb  $t1, a
		beq $t0, $t1, aKey
		lb  $t1, d
		beq $t0, $t1, dKey
		lb  $t1, x
		beq $t0, $t1, xKey
		print_str ("Tecla inválida")
		j end

	wKey:	print_str ("Se presionó w")
		j end

	sKey:	print_str ("Se presionó s")
		j end

	aKey:	print_str ("Se presionó a")
		j end

	dKey:	print_str ("Se presionó d")
		j end

	xKey:	print_str ("Cerrando agenda.")
		done

	end:
.end_macro

# Macro para hacer un bucle for genérico
# El bucle for tiene 4 parámetros, %regIterator es el registro que itera
# desde %from hasta %to, y en cada iteración se ejecuta %bodyMacroName, que a
# su vez es un macro
.macro 	for (%regIterator, %from, %to, %bodyMacroName)
	add %regIterator, $zero, %from
	Loop:
	%bodyMacroName ()
	add %regIterator, %regIterator, 1
	ble %regIterator, %to, Loop
.end_macro

# Ejemplo del ciclo for en acción para imprimir los números
# del 1 al 10
# Macro para imprimir el iterador
# .macro 	print_iterator()
# 	print_int $t0
#	print_str "\n"
# .end_macro

# Imprimir los números del 1 al 10
# for ($t0, 1, 10, print_iterator)

# Terminar la ejecución del programa
.macro 	done
	li $v0,10
	syscall
.end_macro


# LEER CiN
# Macro para leer CiN
# %dest: Registro o direcci�n donde se almacenar� la cadena
# %src: Direcci�n de la cadena a copiar
# %start: Posici�n de inicio en la cadena (bit o byte)
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

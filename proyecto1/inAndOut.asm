###############################
#         Proyecto 1          #
#  Macros para input/output   #
#        Sergio Carillo       #
#          14-11315           #
#          Luis Isea          #
#          19-10175           #
###############################

# Los macro son secuencias invocables que se definen una sola vez y se pueden usar varias veces

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

.macro imprimirBloqueDeHorario(%horario, %horConflictos, %dia, %hora)
	.data
	newline: 	.asciiz "\n"
	space_char:	.asciiz " "
	horizontalLine: .asciiz "---------------------------------------\n"
	thirdLine:	.asciiz "|                                     |W\n"
	separator: 	.asciiz "|"
	up:		.asciiz "|^"
	down:		.asciiz "|v"
	left_and_right: .asciiz "<-A | D->\n"
	hyphen: 	.asciiz "–"
	.text
	print_space (horizontalLine, 0, 40)
	print_space (thirdLine, 0, 41)
	print_space (horizontalLine, 0, 40)
	print_space (left_and_right, 0, 10)
.end_macro 
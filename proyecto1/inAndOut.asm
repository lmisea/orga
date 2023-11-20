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
.macro read_key ()
	.data
	key: 	.space  2  # Aquí se guarda la tecla presionada
	 	.ascii  "\0"
	 	.align  0
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
		beq $t0, $t1, w_key
		lb  $t1, s
		beq $t0, $t1, s_key
		lb  $t1, a
		beq $t0, $t1, a_key
		lb  $t1, d
		beq $t0, $t1, d_key
		lb  $t1, x
		beq $t0, $t1, x_key
		print_str ("Tecla inválida")
		j end

	w_key:	print_str ("Se presionó w")
		j end

	s_key:	print_str ("Se presionó s")
		j end

	a_key:	print_str ("Se presionó a")
		j end

	d_key:	print_str ("Se presionó d")
		j end

	x_key:	print_str ("Cerrando agenda.")
		done

	end:
.end_macro

.macro imprimir_bloque_de_horario (%horario, %hor_conflictos, %dia, %hora)
	.data
	horizontal_line:.asciiz "---------------------------------------\n"
	second_line:	.asciiz "|                                     |^\n"
	third_line:	.asciiz "|                                     |W\n"
	fourth_line:	.asciiz "|                                     |S\n"
	fifth_line:	.asciiz "|                                     |v\n"
	left_and_right: .asciiz "<-A | D->\n"
	hyphen: 	.asciiz "–"
	
	L:		.asciiz "Lunes"
	M:		.asciiz "Martes"
	Mi:		.asciiz "Miercoles"
	J:		.asciiz "Jueves"
	V:		.asciiz "Viernes"
	S:		.asciiz "Sabado"
	
	.text
	la  $t0, %horario
	la  $t1, %hor_conflictos
	add $t2, $zero, %dia
	add $t3, $zero, %hora
	 
	print_space (horizontal_line, 0, 40)
	print_space (second_line, 0, 41)
	
	#beq $t2, 0, lun
	#beq $t2, 1, mar
	#beq $t2, 2, mie
	#beq $t2, 3, jue
	#beq $t2, 4, vie
	#beq $t2, 5, sab
	
	print_space (third_line, 0, 41)
	print_space (fourth_line, 0, 41)
	print_space (fifth_line, 0, 41)
	print_space (horizontal_line, 0, 40)
	print_space (left_and_right, 0, 10)
.end_macro 

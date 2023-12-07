#######################
#     Proyecto 2      #
#    Input & Output   #
#      Luis Isea      #
#      19-10175       #
#######################

.include "ball.asm"
.include "macros.asm"

# Macro para leer qué tecla presionó el usuario
# Y poder realizar una acción dependiendo de la tecla presionada
.macro read_key (%ball_x, %ball_y, %vel_x, %vel_y, %mode, %previous_hit, %previous_touch)
	.data
		key: 	.space  2  # Aquí se guarda la tecla presionada
	 		.ascii  "\0"
	 		.align  0
	 	d:	.asciiz "d"
	 	D:	.asciiz "D"
	 	ele:	.asciiz "l"
	 	L:	.asciiz "L"
		x:	.asciiz "x"
		X:	.asciiz "X"
		m:	.asciiz "m"
		M:	.asciiz "M"
		s:	.asciiz "s"
		S:	.asciiz "S"
		k:	.asciiz "k"
		K:	.asciiz "K"
		w:	.asciiz "w"
		W:	.asciiz "W"
		o:	.asciiz "o"
		O:	.asciiz "O"
	.text
		# Se lee la tecla que presionó el usuario
		li  $v0, 8
		la  $a0, key
		li  $a1, 2
		syscall
		print_str ("\n") # Se imprime un salto de línea

		# Se compara la tecla presionada con las teclas válidas
		lb  $t0, key

		# Se compueba si la tecla presionada es la tecla 'd'
		lb  $t1, d
		beq $t0, $t1, d_key
		lb  $t1, D
		beq $t0, $t1, d_key

		# Se compueba si la tecla presionada es la tecla 'l'
		lb  $t1, ele
		beq $t0, $t1, l_key
		lb  $t1, L
		beq $t0, $t1, l_key

		# Se compueba si la tecla presionada es la tecla 'x'
		lb  $t1, x
		beq $t0, $t1, x_key
		lb  $t1, X
		beq $t0, $t1, x_key

		# Se compueba si la tecla presionada es la tecla 'm'
		lb  $t1, m
		beq $t0, $t1, m_key
		lb  $t1, M
		beq $t0, $t1, m_key

		# Se compueba si la tecla presionada es la tecla 's'
		lb  $t1, s
		beq $t0, $t1, s_key
		lb  $t1, S
		beq $t0, $t1, s_key

		# Se compueba si la tecla presionada es la tecla 'k'
		lb  $t1, k
		beq $t0, $t1, k_key
		lb  $t1, K
		beq $t0, $t1, k_key

		# Se compueba si la tecla presionada es la tecla 'w'
		lb  $t1, w
		beq $t0, $t1, w_key
		lb  $t1, w
		beq $t0, $t1, w_key

		# Se compueba si la tecla presionada es la tecla 'o'
		lb  $t1, o
		beq $t0, $t1, o_key
		lb  $t1, O
		beq $t0, $t1, o_key

		print_str ("Tecla inválida")
		j end

	d_key:	print_str ("Se presionó d")
		attempt_player_shot (0, %ball_x, %previous_hit, %previous_touch, %vel_x, %vel_y, %mode)
		j end

	l_key:	print_str ("Se presionó l")
		attempt_player_shot (1, %ball_x, %previous_hit, %previous_touch, %vel_x, %vel_y, %mode)
		j end

	x_key:	print_str ("Se presionó x")
		j end

	m_key:	print_str ("Se presionó m")
		j end

	s_key:	print_str ("Se presionó s")
		j end

	k_key:	print_str ("Se presionó k")
		j end

	w_key:	print_str ("Se presionó w")
		j end

	o_key:	print_str ("Se presionó o")
		j end

	end:
.end_macro

# Macro para realizar un refresh de la pantalla
.macro refresh_court (%ball_x, %ball_y, %vel_x, %vel_y)
	get_time
	move $s6, $a1

	draw_court (%ball_x, %ball_y, %vel_x, %vel_y)

	get_time
	sub $s6, $s6, $a1 #tiempo transcurrido
	li  $t7, 200
	sub $a0, $t7, $s6 #tiempo restante
	sleep ($a0)
.end_macro

# Macro para dibujar la cancha de tenis
# Recibe como argumentos la posición y la velocidad
# de la pelota
.macro draw_court (%ball_x, %ball_y, %vel_x, %vel_y)
	.data
		first_line:   .asciiz "                         \n"
		second_line:  .asciiz "                         \n"
		thrid_line:   .asciiz "                         \n"
		fourth_line:  .asciiz "                         \n"
		fifth_line:   .asciiz "                         \n"
		sixth_line:   .asciiz "                         \n"
		seventh_line: .asciiz "            O            \n"
		eigth_line:   .asciiz "            O            \n"
		nineth_line:  .asciiz "            O            \n"
		tenth_line:   .asciiz "OOOOOOOOOOOOOOOOOOOOOOOOO\n"
	.text
		print_space (first_line,   0, 26)
		print_space (second_line,  0, 26)
		print_space (thrid_line,   0, 26)
		print_space (fourth_line,  0, 26)
		print_space (sixth_line,   0, 26)
		print_space (seventh_line, 0, 26)
		print_space (eigth_line,   0, 26)
		print_space (nineth_line,  0, 26)
		print_space (tenth_line,   0, 26)
.end_macro

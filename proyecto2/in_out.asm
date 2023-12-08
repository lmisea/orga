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
.macro read_key (%ball_x, %ball_y, %vel_x, %vel_y, %mode, %previous_bounces, %turn, %service)
	lui $a2, 0xFFFF
	li $k1, 100000 	# El número de veces que vamos a verificar si se presionó
			# una tecla o no

	verify:
		lw $t1, 0($a2) # Leemos el byte de control
		andi $t1, $t1, 0x0001
		
		# Si el byte de control es 1, significa que sí se presionó una tecla
		bgtz $t1, key_interrumpt
		
		beqz %service, verify
		j no_service

	no_service:
		beqz $k1, end
		sub $k1, $k1, 1
		j verify
		
	
	key_interrumpt:
		# Leemos la letra que se escribió
		lw $t0, 4($a2)

		# Se compueba si la tecla presionada es la tecla 'd'
		li  $t1, 'd'
		beq $t0, $t1, d_key
		li  $t1, 'D'
		beq $t0, $t1, d_key

		# Se compueba si la tecla presionada es la tecla 'l'
		li $t1, 'l'
		beq $t0, $t1, l_key
		li  $t1, 'L'
		beq $t0, $t1, l_key

		# Se compueba si la tecla presionada es la tecla 'x'
		li  $t1, 'x'
		beq $t0, $t1, x_key
		li  $t1, 'X'
		beq $t0, $t1, x_key

		# Se compueba si la tecla presionada es la tecla 'm'
		li  $t1, 'm'
		beq $t0, $t1, m_key
		li  $t1, 'M'
		beq $t0, $t1, m_key

		# Se compueba si la tecla presionada es la tecla 's'
		li  $t1, 's'
		beq $t0, $t1, s_key
		li  $t1, 'S'
		beq $t0, $t1, s_key

		# Se compueba si la tecla presionada es la tecla 'k'
		li  $t1, 'k'
		beq $t0, $t1, k_key
		li  $t1, 'K'
		beq $t0, $t1, k_key

		# Se compueba si la tecla presionada es la tecla 'w'
		li  $t1, 'w'
		beq $t0, $t1, w_key
		li  $t1, 'W'
		beq $t0, $t1, w_key

		# Se compueba si la tecla presionada es la tecla 'o'
		li  $t1, 'o'
		beq $t0, $t1, o_key
		li  $t1, 'O'
		beq $t0, $t1, o_key

		# Se compueba si la tecla presionada es la tecla 'q'
		li  $t1, 'q'
		beq $t0, $t1, q_key
		li  $t1, 'Q'
		beq $t0, $t1, q_key

		j end

	d_key:	li $t1, 0
		print_str ("\n") # Se imprime un salto de línea
		attempt_player_shot ($t1, %ball_x, %previous_bounces, %vel_x, %vel_y, %mode, %turn)
		li %service, 1
		j end

	l_key:	li $t1, 1
		print_str ("\n") # Se imprime un salto de línea
		attempt_player_shot ($t1, %ball_x, %previous_bounces, %vel_x, %vel_y, %mode, %turn)
		li %service, 1
		j end

	x_key:	li $t1, 0
		change_mode ($t1, %mode, 1, %turn)
		j end

	m_key:	li $t1, 1
		change_mode ($t1, %mode, 1, %turn)
		j end

	s_key:	li $t1, 0
		change_mode ($t1, %mode, 0, %turn)
		j end

	k_key:	li $t1, 1
		change_mode ($t1, %mode, 0, %turn)
		j end

	w_key:	li $t1, 0
		change_mode ($t1, %mode, 2, %turn)
		j end

	o_key:	li $t1, 1
		change_mode ($t1, %mode, 2, %turn)
		j end

	q_key:	done

	end:
.end_macro

# Macro para realizar un refresh de la pantalla
.macro refresh_court (%ball_x, %ball_y, %vel_x, %vel_y)
	get_time
	move $a3, $a1

	draw_court (%ball_x, %ball_y, %vel_x, %vel_y)

	reduce_vel_y (%vel_y)

	get_time
	sub $a3, $a3, $a1 #tiempo transcurrido
	li  $t7, 200
	sub $a0, $t7, $s3 #tiempo restante
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

	# Agregamos la pelota a la cancha

	li $t5, 10
	beq %ball_y, $t5, primera_lin

	li $t5, 9
	beq %ball_y, $t5, segunda_lin

	li $t5, 8
	beq %ball_y, $t5, tercera_lin

	li $t5, 7
	beq %ball_y, $t5, cuarta_lin

	li $t5, 6
	beq %ball_y, $t5, quinta_lin

	li $t5, 5
	beq %ball_y, $t5, sexta_lin

	li $t5, 4
	beq %ball_y, $t5, septima_lin

	li $t5, 3
	beq %ball_y, $t5, octava_lin

	li $t5, 2
	beq %ball_y, $t5, novena_lin

	j end

	primera_lin:
		la $t6, first_line
		j draw_ball

	segunda_lin:
		la $t6, second_line
		j draw_ball

	tercera_lin:
		la $t6, thrid_line
		j draw_ball

	cuarta_lin:
		la $t6, fourth_line
		j draw_ball

	quinta_lin:
		la $t6, fifth_line
		j draw_ball

	sexta_lin:
		la $t6, sixth_line
		j draw_ball

	septima_lin:
		la $t6, seventh_line
		j draw_ball

	octava_lin:
		la $t6, eigth_line
		j draw_ball

	novena_lin:
		la $t6, nineth_line

	draw_ball:
		add $t6, $t6, %ball_x
		li $t8, 'O'
		sb $t8, 0($t6)

	imprimir:
		print_space (first_line,   0, 26)
		print_space (second_line,  0, 26)
		print_space (thrid_line,   0, 26)
		print_space (fourth_line,  0, 26)
		print_space (sixth_line,   0, 26)
		print_space (seventh_line, 0, 26)
		print_space (eigth_line,   0, 26)
		print_space (nineth_line,  0, 26)
		print_space (tenth_line,   0, 26)
	end:
.end_macro

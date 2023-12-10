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
	li  $k1, 1000 	# El número de veces que vamos a verificar si se presionó
			# una tecla o no

	verify:
		lw   $t1, 0($a2) # Leemos el byte de control
		andi $t1, $t1, 0x0001

		# Si el byte de control es 1, significa que sí se presionó una tecla
		bgtz $t1, key_interrumpt

		beqz %service, verify
		j    no_service

	no_service:
		beqz $k1, end
		sub  $k1, $k1, 1
		j    verify


	key_interrumpt:
		# Leemos la letra que se escribió
		lw  $t0, 4($a2)

		# Se compueba si la tecla presionada es la tecla 'd'
		li  $t1, 'd'
		beq $t0, $t1, d_key
		li  $t1, 'D'
		beq $t0, $t1, d_key

		# Se compueba si la tecla presionada es la tecla 'l'
		li  $t1, 'l'
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

		j   end

	d_key:	li  $t1, 0
		attempt_player_shot ($t1, %ball_x, %previous_bounces, %vel_x, %vel_y, %mode, %turn, %service)
		j   end

	l_key:	li  $t1, 1
		attempt_player_shot ($t1, %ball_x, %previous_bounces, %vel_x, %vel_y, %mode, %turn, %service)
		j   end

	x_key:	li  $t1, 0
		change_mode ($t1, %mode, 1, %turn)
		j   end

	m_key:	li  $t1, 1
		change_mode ($t1, %mode, 1, %turn)
		j   end

	s_key:	li  $t1, 0
		change_mode ($t1, %mode, 0, %turn)
		j   end

	k_key:	li  $t1, 1
		change_mode ($t1, %mode, 0, %turn)
		j   end

	w_key:	li  $t1, 0
		change_mode ($t1, %mode, 2, %turn)
		j   end

	o_key:	li  $t1, 1
		change_mode ($t1, %mode, 2, %turn)
		j   end

	q_key:	done ()

	end:
.end_macro

# Macro para realizar un refresh de la pantalla
.macro refresh_court (%ball_x, %ball_y, %vel_x, %vel_y, %mode, %previous_bounces, %turn, %service, %estelas)
	get_time ()
	move $a3, $a1

	#ball_next_pos (%ball_x, %ball_y, %vel_x, %vel_y)

	add  $k0, %ball_x, %vel_x
	add  $t2, %ball_y, %vel_y

	verificar_estela:
		bne  %ball_x, $k0, dibujar_estela_x
		bne  %ball_y, $t2, dibujar_estela_y
		j    continue

	dibujar_estela_x:
		bgtz %vel_x, vel_x_pos
		bltz %vel_x, vel_x_neg
		j    dibujar_estela

	vel_x_pos:
		add  %ball_x, %ball_x, 1
		j    dibujar_estela

	vel_x_neg:
		sub  %ball_x, %ball_x, 1
		j    dibujar_estela

	dibujar_estela_y:
		bgtz %vel_y, vel_y_pos
		bltz %vel_y, vel_y_neg
		j    dibujar_estela

	vel_y_pos:
		add  %ball_y, %ball_y, 1
		j    dibujar_estela

	vel_y_neg:
		sub  %ball_y, %ball_y, 1
		j    dibujar_estela

	dibujar_estela:
		add_trail (%ball_x, %ball_y, %estelas)
		j    verificar_estela

continue:
	is_ball_out_of_bounds (%ball_x, %ball_y, %vel_x, %vel_y, %mode, %previous_bounces, %turn, %service, %estelas)

	verify_ball_bounced (%ball_x, %ball_y, %vel_y, %previous_bounces)

	verify_ball_touched_net (%ball_x, %ball_y, %vel_x)

	draw_court (%estelas)

	reduce_vel_y (%vel_y)

	read_key (%ball_x, %ball_y, %vel_x, %vel_y, %mode, %previous_bounces, %turn, %service)

	get_time ()
	sub  $a3, $a3, $a1 #tiempo transcurrido
	li   $t1, 200
	sub  $a0, $t1, $s3 #tiempo restante
	sleep ($a0)
.end_macro

# Macro para dibujar la cancha de tenis
# Recibe como argumentos la posición y la velocidad
# de la pelota
.macro draw_court (%estelas)
	.data
		first_line:   	.asciiz "                         \n"
		second_line:  	.asciiz "                         \n"
		third_line:   	.asciiz "                         \n"
		fourth_line:  	.asciiz "                         \n"
		fifth_line:   	.asciiz "                         \n"
		sixth_line:   	.asciiz "                         \n"
		seventh_line: 	.asciiz "            O            \n"
		eighth_line:  	.asciiz "            O            \n"
		ninth_line:  	.asciiz "            O            \n"
		tenth_line:   	.asciiz "OOOOOOOOOOOOOOOOOOOOOOOOO\n\n"

		blank_line:	.asciiz "                         \n"
		net_line:	.asciiz "            O            \n"
	.text
	# En $t3 anotamos el número de estela que estamos dibujando
	li $t3, 0

trail:
	add $t3, $t3, 1
	# Verificamos si la estela existe
	lb  $t1, 2(%estelas)
	li  $t8, '-'
	# Si la estela no existe, entonces no la dibujamos
	beq $t1, $t8, next_trail

	# La estela existe, asi que calculamos la posición en y de la estela
	calcular_coordenada_estela ('y', $t8, %estelas) # En $t8 tenemos la posición en y de la estela
	j calcular_linea

	next_trail:
		blt $t3, 11, add_four
		sub %estelas, %estelas, 40
		j imprimir

	add_four:
		add %estelas, %estelas, 4
		j   trail

calcular_linea:
	li   $t1, 9
	beq  $t8, $t1, primera_lin

	li   $t1, 8
	beq  $t8, $t1, segunda_lin

	li   $t1, 7
	beq  $t8, $t1, tercera_lin

	li   $t1, 6
	beq  $t8, $t1, cuarta_lin

	li   $t1, 5
	beq  $t8, $t1, quinta_lin

	li   $t1, 4
	beq  $t8, $t1, sexta_lin

	li   $t1, 3
	beq  $t8, $t1, septima_lin

	li   $t1, 2
	beq  $t8, $t1, octava_lin

	li   $t1, 1
	beq  $t8, $t1, novena_lin

	beqz $t8, calcular_pos_x

	# Si no está entre 0 y 9, se salta a la siguiente estela
	j next_trail

	primera_lin:
		la $t6, first_line
		j  calcular_pos_x

	segunda_lin:
		la $t6, second_line
		j  calcular_pos_x

	tercera_lin:
		la $t6, third_line
		j  calcular_pos_x

	cuarta_lin:
		la $t6, fourth_line
		j  calcular_pos_x

	quinta_lin:
		la $t6, fifth_line
		j  calcular_pos_x

	sexta_lin:
		la $t6, sixth_line
		j  calcular_pos_x

	septima_lin:
		la $t6, seventh_line
		j  calcular_pos_x

	octava_lin:
		la $t6, eighth_line
		j  calcular_pos_x

	novena_lin:
		la $t6, ninth_line
		j  calcular_pos_x


	# Calculamos la posición x de la lin correspondiente
	calcular_pos_x:

		calcular_coordenada_estela ('x', $t8, %estelas) # En $t8 tenemos la posición en x de la estela
		
		# No se dibuja una estela que esté fuera de la cancha
		bgt  $t8, 24, next_trail
		bltz $t8, next_trail

		add $t6, $t6, $t8

		# Verificamos si estamos agregando la pelota
		# La pelota es la primera estela
		beq  $t3, 1, agregar_pelota

		# En caso contrario, estamos agregando una estela
		# que son las otras 4 estelas después de la primera
		agregar_estela:
			li  $t1, 'o'
			sb  $t1, 0($t6)
			j   next_trail

		agregar_pelota:
			li  $t1, 'O'
			sb  $t1, 0($t6)
			j   next_trail

	imprimir:
		print_space (first_line)
		print_space (second_line)
		print_space (third_line)
		print_space (fourth_line)
		print_space (sixth_line)
		print_space (seventh_line)
		print_space (eighth_line)
		print_space (ninth_line)
		print_space (tenth_line)

	# Reiniciamos la cancha para que no aparezcan pelotas o estelas de impresiones
	# anteriores cuando se imprima la cancha
	reiniciar_cancha:
		la $t3, first_line
		la $t6, blank_line
		# Reiniciamos la primera linea para que sea una linea blanca
		reescribir_linea ($t3, $t6)

		# Hacemos lo mismo con las demás líneas que deberían ser blancas
		la $t3, second_line
		reescribir_linea ($t3, $t6)

		la $t3, third_line
		reescribir_linea ($t3, $t6)

		la $t3, fourth_line
		reescribir_linea ($t3, $t6)

		la $t3, fifth_line
		reescribir_linea ($t3, $t6)

		la $t3, sixth_line
		reescribir_linea ($t3, $t6)

		# Ahora reiniciamos las lineas en las que aparece la red
		la $t3, seventh_line
		la $t6, net_line
		reescribir_linea ($t3, $t6)

		la $t3, eighth_line
		reescribir_linea ($t3, $t6)

		la $t3, ninth_line
		reescribir_linea ($t3, $t6)
	end:
.end_macro

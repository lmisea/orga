########################
#      Proyecto 2      #
#  Ball Behivior File  #
#       Luis Isea      #
#       19-10175       #
########################

# Macro para verificar si la pelota tocó el piso
.macro verify_ball_bounced (%ball_x, %ball_y, %vel_y, %previous_bounces, %bounced)
	blt %ball_y, 1, bounce
	j end

	bounce: li  %bounced, 1
		mul %vel_y, %vel_y, -1
		add %ball_y, %ball_y, 1
		sub %vel_y, %vel_y, 1
		add %previous_bounces, %previous_bounces, 1

	end:
.end_macro

# Macro para verificar si la pelota rebotó contra la red
.macro verify_ball_touched_net (%ball_x, %ball_y, %vel_x, %touched)
	li $t3, 12
	beq %ball_x, $t3, verify_height
	j end

	verify_height:  li $t3, 4
			blt %ball_y, $t3, touched_net
			j end

	touched_net:	li %touched, 1
			mul %vel_x, %vel_x, -1

	end:
.end_macro

# Macro para verificar si la pelota salió de la cancha en el eje x
.macro is_ball_out_of_bounds (%ball_x, %ball_y, %vel_x, %vel_y, %mode_one, %mode_two, %previous_bounces, %turn, %service, %estelas)
	bltz %ball_x, point_for_player_two
	li $t1, 24
	bgt %ball_x, $t1, point_for_player_one
	j end

	point_for_player_one:
		draw_court (%estelas, 1)
		new_service (0, %ball_x, %ball_y, %vel_x, %vel_y, %mode_one, %mode_two, %previous_bounces, %turn, %service, %estelas)
		j end

	point_for_player_two:
		draw_court (%estelas, 1)
		new_service (1, %ball_x, %ball_y, %vel_x, %vel_y, %mode_one, %mode_two, %previous_bounces, %turn, %service, %estelas)

	end:
.end_macro

# Macro para que un jugador intente raquetear la pelota
.macro attempt_player_shot (%player, %ball_x, %previous_bounces, %vel_x, %vel_y, %mode, %turn, %service)
	# Si %player es distinto de %turn, significa que el jugador que intentó
	# raquetear no está en su turno o ya raqueteó una vez y por ende, el
	# raqueteo no es válido
	bne %player, %turn, end

	li  $t3, 1
	bgt %previous_bounces, $t3, end

	li $t3, 12

	beqz %player, verify_ball_in_court_one
	j verify_ball_in_court_two

	verify_ball_in_court_one:
		blt %ball_x, $t3, shot
		j end

	verify_ball_in_court_two:
		bgt %ball_x, $t3, shot
		j end

	shot:	player_shot (%player, %vel_x, %vel_y, %mode)
		# Se marca que ya no se está al principio de un servicio
		li %service, 1
		# Se cambia el turno
		beqz %turn, turn_for_p_two
		j turn_for_p_one

	turn_for_p_one:
		move %turn, $zero
		j end

	turn_for_p_two:
		li %turn, 1

	end:
.end_macro

# Macro para calcula la velocidad de la pelota luego de que
# un jugador la raquete
# %mode es el modo en el que se raqueetea
# %mode = 0 para forehand
# %mode = 1 para underhand
# %mode = 2 para backhand
.macro player_shot (%player, %vel_x, %vel_y, %mode)
	# Se calcula la nueva velocidad en x de la pelota
	beqz %player, player_one
	j player_two

	player_one:	li %vel_x, 3
			j verify_mode

	player_two:	li %vel_x, -3

verify_mode:
	# Se calcula la nueva velocidad en y de la pelota
	beqz %mode, forehand

	li  $t1, 1
	beq %mode, $t1, underhand

	li  $t1, 2
	beq %mode, $t1, backhand

	j end

	forehand: 	li %vel_y, 3
			j end

	underhand: 	li %vel_y, 4
			j end

	backhand:	li %vel_y, 0

	end:
.end_macro

# Macro para calcular la siguiente posición de la pelota
.macro ball_next_pos (%ball_x, %ball_y, %vel_x, %vel_y)
	add %ball_x, %ball_x, %vel_x
	add %ball_y, %ball_y, %vel_y
.end_macro

# Macro para reducir en 1 la velocidad de y
.macro reduce_vel_y (%vel_y)
	sub %vel_y, %vel_y, 1
.end_macro

# Macro para cambiar el modo de raquetear la pelota
.macro change_mode (%mode, %new_mode)
	li %mode, %new_mode
.end_macro

# Macro para añadir una estela
.macro add_trail (%ball_x, %ball_y, %estelas)
	li   $t5, 0
	add  %estelas, %estelas, 36

	move_to_previous:
		add  $t5, $t5, 1
		lb   $t7, 0(%estelas)
		add  %estelas, %estelas, 4
		sb   $t7, 0(%estelas)
		sub  %estelas, %estelas, 3
		lb   $t7, 0(%estelas)
		add  %estelas, %estelas, 4
		sb   $t7, 0(%estelas)
		sub  %estelas, %estelas, 3
		lb   $t7, 0(%estelas)
		add  %estelas, %estelas, 4
		sb   $t7, 0(%estelas)
		sub  %estelas, %estelas, 3
		lb   $t7, 0(%estelas)
		add  %estelas, %estelas, 4
		sb   $t7, 0(%estelas)
		sub  %estelas, %estelas, 7
		beq  $t5, 10, guardar_estela
		sub  %estelas, %estelas, 4
		j move_to_previous

guardar_estela:
	# Escribimos las coordenadas de x de la posición de la estela

	# Dividimos entre 10 la coordenada x, 'lo' tiene el primer digito y 'hi'
	# tiene el segundo digito
	li $t0, 10
	div %ball_x, $t0
	mflo $t1
	mfhi $t3

	int_to_ascii ($t1)
	int_to_ascii ($t3)

	sb $t1, 0(%estelas)
	sb $t3, 1(%estelas)

	# Ahora escribimos las coordenadas de y de la posición de la estela

	# Dividimos entre 10 la coordenada y, 'lo' tiene el primer digito y 'hi'
	# tiene el segundo digito
	li $t0, 10
	div %ball_y, $t0
	mflo $t1
	mfhi $t3

	int_to_ascii ($t1)
	int_to_ascii ($t3)

	sb $t1, 2(%estelas)
	sb $t3, 3(%estelas)
.end_macro

# Macro para calcular una coordenada de una estela usando %estelas
.macro calcular_coordenada_estela (%eje, %reg, %estelas)
	li  $a1, 'x'
	li  $t1, %eje
	beq $a1, $t1, eje_x

	li  $a1, 'y'
	beq $a1, $t1, eje_y

	j end

	eje_x:
		lb  $t1, 0(%estelas)
		ascii_to_int ($t1)
		li  %reg, 10
		mul %reg, %reg, $t1
		lb  $t1, 1(%estelas)
		ascii_to_int ($t1)
		# En %reg guardamos la posición en x de la estela
		add %reg, %reg, $t1
		j end

	eje_y:
		lb  $t1, 2(%estelas)
		ascii_to_int ($t1)
		li  %reg, 10
		mul %reg, %reg, $t1
		lb  $t1, 3(%estelas)
		ascii_to_int ($t1)
		# En %reg guardamos la posición en y de la estela
		add %reg, %reg, $t1

	end:
.end_macro

# Macro para empezar un nuevo servicio
.macro new_service (%player, %ball_x, %ball_y, %vel_x, %vel_y, %mode_one, %mode_two, %previous_bounces, %turn, %service, %estelas)
	li  %ball_y, 4
	move %vel_x, $zero
	move %vel_y, $zero
	move %mode_one, $zero
	move %mode_two, $zero
	move %previous_bounces, $zero
	move %service, $zero

	li   $a1, 44

	inicializar_estelas:
		li   $t1, '-'
		sb   $t1, 0(%estelas)
		add  %estelas, %estelas, 1
		sub  $a1, $a1, 1
		bnez $a1, inicializar_estelas

	sub  %estelas, %estelas, 44

	li   $t1, %player

	beqz $t1, player_one
	j player_two

	player_one: 	li %ball_x, 2
			move %turn, $zero
			j trail

	player_two: 	li %ball_x, 22
			li %turn, 1

	trail: add_trail (%ball_x, %ball_y, %estelas)
.end_macro

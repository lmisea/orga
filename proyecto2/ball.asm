########################
#      Proyecto 2      #
#  Ball Behivior File  #
#       Luis Isea      #
#       19-10175       #
########################

# Macro para verificar si la pelota tocó el piso
.macro verify_ball_bounced (%ball_x, %ball_y, %vel_y, %previous_bounces)
	beqz %ball_y, bounce
	j end

	bounce: 	mul %vel_y, %vel_y, -1
			add %previous_bounces, %previous_bounces, 1

	end:
.end_macro

# Macro para verificar si la pelota rebotó contra la red
.macro verify_ball_touched_net (%ball_x, %ball_y, %vel_x)
	li $t3, 12
	beq %ball_x, $t3, verify_height
	j end

	verify_height:  li $t3, 4
			blt %ball_y, $t3, touched_net
			j end

	touched_net:	mul %vel_x, %vel_x, -1

	end:
.end_macro

# Macro para verificar si la pelota salió de la cancha en el eje x
.macro is_ball_out_of_bounds (%ball_x, %ball_y, %vel_x, %vel_y, %mode, %previous_bounces, %turn, %service)
	bltz %ball_x, point_for_player_two
	li $t1, 24
	bgt %ball_x, $t1, point_for_player_one
	j end

	point_for_player_one:
		new_service (0, %ball_x, %ball_y, %vel_x, %vel_y, %mode, %previous_bounces, %turn, %service)
		j end

	point_for_player_two:
		new_service (1, %ball_x, %ball_y, %vel_x, %vel_y, %mode, %previous_bounces, %turn, %service)

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

	shot:	print_str ("\n")
		player_shot (%player, %vel_x, %vel_y, %mode)
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

	forehand: 	li %vel_y, 4
			j end

	underhand: 	li %vel_y, 3
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
	sub %vel_y, %vel_y, 2
.end_macro

# Macro para cambiar el modo de raquetear la pelota
.macro change_mode (%player, %mode, %new_mode, %turn)
	bne %player, %turn, end

	li %mode, %new_mode

	end:
.end_macro

# Macro para empezar un nuevo servicio
.macro new_service (%player, %ball_x, %ball_y, %vel_x, %vel_y, %mode, %previous_bounces, %turn, %service)
	li  %ball_y, 4
	move %vel_x, $zero
	move %vel_y, $zero
	move %mode,  $zero
	move %previous_bounces, $zero
	move %service, $zero

	li $t4, %player

	beqz $t4, player_one
	j player_two

	player_one: 	li %ball_x, 3
			move %turn, $zero
			j end

	player_two: 	li %ball_x, 22
			li %turn, 1

	end:
.end_macro

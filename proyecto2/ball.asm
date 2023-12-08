########################
#      Proyecto 2      #
#  Ball Behivior File  #
#       Luis Isea      #
#       19-10175       #
########################

# Macro para verificar si la pelota tocó el piso
.macro verify_ball_touched_court (%ball_y, %vel_y, %previous_touch)
	beqz %ball_y, touched_court
	j end

	touched_court: 	mul %vel_y, %vel_y, -1
			add %previous_touch, %previous_touch, 1

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
.macro is_ball_out_of_bounds (%ball_x)
	bltz %ball_x, point_for_player_two
	li $t4, 24
	bgt %ball_x, $t4, point_for_player_one
	j end

	point_for_player_one:
		new_service (0, %ball_x, %ball_y, %vel_x, %vel_y, %mode, %previous_hit, %previous_touch)
		j end

	point_for_player_two:
		new_service (1, %ball_x, %ball_y, %vel_x, %vel_y, %mode, %previous_hit, %previous_touch)

	end:
.end_macro

# Macro para que un jugador intente raquetear la pelota
.macro attempt_player_shot (%player, %ball_x, %previous_hit, %previous_touch, %vel_x, %vel_y, %mode)
	# Si %previous_hit > 0, significa que el jugador ya ha raqueteado
	# en su cancha una vez y no puede volver a raquetear
	bgtz  %previous_hit, end

	li  $t3, 1
	bgt %previous_touch, $t3, end

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
		add %previous_hit, %previous_hit, 1

	end:
.end_macro

# Macro para calcula la velocidad de la pelota luego de que
# un jugador la raquete
# %mode es el modo en el que se raqueetea
.macro player_shot (%player, %vel_x, %vel_y, %mode)
	# Se calcula la nueva velocidad en x de la pelota
	beqz %player, player_one
	j player_two

	player_one:	li %vel_x, 3
	player_two:	li %vel_x, -3

	# Se calcula la nueva velocidad en y de la pelota
	beqz %mode, forehand

	li  $t2, 1
	beq %mode, $t2, underhand

	li  $t2, 2
	beq %mode, $t2, backhand

	j end

	forehand: 	print_str ("forehand")
			li %vel_y, 4
			j end

	underhand: 	print_str ("underhand")
			li %vel_y, 3
			j end

	backhand:	print_str ("backhand")
			li %vel_y, 0

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

# Macro para empezar un nuevo servicio
.macro new_service (%player, %ball_x, %ball_y, %vel_x, %vel_y, %mode, %previous_hit, %previous_touch)
	li  %ball_y, 5
	move %vel_x, $zero
	move %vel_y, $zero
	move %mode,  $zero
	move %previous_hit, $zero
	move %previous_touch, $zero

	beqz %player, player_one
	j player_two

	player_one: 	li %ball_x, 3
			j end

	player_two: 	li %ball_x, 23

	end:
.end_macro

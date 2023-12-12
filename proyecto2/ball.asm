########################
#      Proyecto 2      #
#  Ball Behivior File  #
#       Luis Isea      #
#       19-10175       #
########################

# Este archivo contiene las macros que se encargan de la lógica del movimiento
# de la pelota, así como también de la lógica del juego en general

# Macro para verificar si la pelota tocó el piso
.macro verify_ball_bounced (%ball_x, %ball_y, %vel_y, %previous_bounces, %bounced)
	blt %ball_y, 1, bounce
	j end

	# Si la pelota tocó el piso, se invierte su velocidad en y
	# y se aumenta en 1 el contador de rebotes
	bounce: li  %bounced, 1
		mul %vel_y, %vel_y, -1
		add %ball_y, %ball_y, 1
		sub %vel_y, %vel_y, 1
		add %previous_bounces, %previous_bounces, 1

	end:
.end_macro

# Macro para reiniciar la cuenta de rebotes en el turno
.macro reset_prevoius_bounces (%previous_bounces)
	move %previous_bounces, $zero
.end_macro

# Macro para calcular en qué cancha se encuentra la pelota en la pos actual
# En %reg se guardará la cancha en la que esté la pelota
# 0 para la cancha del jugador 1 y 1 para la cancha del jugador 2
.macro calcular_cancha_pelota (%ball_x, %estelas, %reg)
	beq  %ball_x, 12, leer_pos_anterior
	blt  %ball_x, 12, primera_cancha
	bgt  %ball_x, 12, segunda_cancha
	
	leer_pos_anterior:
			add %estelas, %estelas, 4
			calcular_coordenada_estela ('x', %reg, %estelas)
			sub %estelas, %estelas, 4
			blt %reg, 12, primera_cancha
			bgt %reg, 12, segunda_cancha
	
	primera_cancha: li  %reg, 0
			j   end
			
	segunda_cancha: li  %reg, 1
			
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

	# Si la pelota pegó en la red, se invierte su velocidad en x
	touched_net:	li %touched, 1
			mul %vel_x, %vel_x, -1

	end:
.end_macro

# Macro para verificar si la pelota salió de la cancha en el eje x
.macro is_ball_out_of_bounds (%ball_x, %ball_y, %vel_x, %vel_y, %mode_one, %mode_two, %previous_bounces, %turn, %service, %estelas, %puntaje)
	bltz %ball_x, point_for_player_two
	li $t1, 24
	bgt %ball_x, $t1, point_for_player_one
	j end

	point_for_player_one:
		draw_court  (%estelas, 1)
		new_service (0, %ball_x, %ball_y, %vel_x, %vel_y, %mode_one, %mode_two, %previous_bounces, %turn, %service, %estelas, %puntaje)
		imprimir_puntaje (%puntaje)
		j end

	point_for_player_two:
		draw_court  (%estelas, 1)
		new_service (1, %ball_x, %ball_y, %vel_x, %vel_y, %mode_one, %mode_two, %previous_bounces, %turn, %service, %estelas, %puntaje)
		imprimir_puntaje (%puntaje)

	end:
.end_macro

# Macro para verificar si un jugador puede raquetear la pelota
# En caso de que pueda, el jugador raquetea la pelota
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

# Macro para reducir en 1 la velocidad de y
.macro reduce_vel_y (%vel_y)
	sub %vel_y, %vel_y, 1
.end_macro

# Macro para cambiar el modo de raquetear la pelota
.macro change_mode (%mode, %new_mode)
	li %mode, %new_mode
.end_macro

# Macro para añadir una estela al arreglo de estelas
.macro add_trail (%ball_x, %ball_y, %estelas)
	li   $t5, 0
	add  %estelas, %estelas, 36

	# Movemos las estelas una posición hacia atrás
	move_to_previous:
		add  $t5, $t5, 1
		lb   $t1, 0(%estelas)
		add  %estelas, %estelas, 4
		sb   $t1, 0(%estelas)
		sub  %estelas, %estelas, 3
		lb   $t1, 0(%estelas)
		add  %estelas, %estelas, 4
		sb   $t1, 0(%estelas)
		sub  %estelas, %estelas, 3
		lb   $t1, 0(%estelas)
		add  %estelas, %estelas, 4
		sb   $t1, 0(%estelas)
		sub  %estelas, %estelas, 3
		lb   $t1, 0(%estelas)
		add  %estelas, %estelas, 4
		sb   $t1, 0(%estelas)
		sub  %estelas, %estelas, 7
		beq  $t5, 10, guardar_estela
		sub  %estelas, %estelas, 4
		j move_to_previous

# Y guardamos en la primera posición del arreglo de estelas la nueva estela
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
# Si %eje es igual a 'x', se calcula la coordenada en x
# Si %eje es igual a 'y', se calcula la coordenada en y
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
# En este macro no solo se acomoda la pelota en posición de servicio, sino
# que también se actualiza el puntaje del juego, set y match
.macro new_service (%player, %ball_x, %ball_y, %vel_x, %vel_y, %mode_one, %mode_two, %previous_bounces, %turn, %service, %estelas, %puntaje)
	# Se reinician las variables de la pelota
	li  %ball_y, 4
	move %vel_x, $zero
	move %vel_y, $zero
	move %mode_one, $zero
	move %mode_two, $zero
	move %previous_bounces, $zero
	move %service, $zero

	# Se reinician las estelas
	li   $a1, 44

	li   $t1, '-'
	inicializar_estelas:
		sb   $t1, 0(%estelas)
		add  %estelas, %estelas, 1
		sub  $a1, $a1, 1
		bnez $a1, inicializar_estelas

	sub  %estelas, %estelas, 44

	li   $t1, %player

	# Se acomoda la pelota en posición de servicio, se cambia el turno
	# y se actualiza el puntaje
	beqz $t1, player_one
	j player_two

	player_one: 	move %turn, $zero
			li   %ball_x, 2
			lb   $t1, 0(%puntaje)
			ascii_to_int ($t1)
			beq  $t1, 3, aumentar_set_p_one
			add  $t1, $t1, 1
			int_to_ascii ($t1)
			sb   $t1, 0(%puntaje)
			j    trail

	aumentar_set_p_one:
			li   $t1, 0
			sb   $t1, 0(%puntaje)
			sb   $t1, 3(%puntaje)
			lb   $t1, 1(%puntaje)
			ascii_to_int ($t1)
			beq  $t1, 5, verify_tiebreak_p_one
			beq  $t1, 6, aumentar_match_p_one
			add  $t1, $t1, 1
			int_to_ascii ($t1)
			sb   $t1, 1(%puntaje)
			j    trail

	verify_tiebreak_p_one:
			lb   $t1, 4(%puntaje)
			ascii_to_int ($t1)
			bgt  $t1, 4, tiebreak_p_one
			j    aumentar_match_p_one

	tiebreak_p_one:
			lb   $t1, 1(%puntaje)
			ascii_to_int ($t1)
			add  $t1, $t1, 1
			int_to_ascii ($t1)
			sb   $t1, 1(%puntaje)
			j    trail

	aumentar_match_p_one:
			li   $t1, 0
			sb   $t1, 1(%puntaje)
			sb   $t1, 4(%puntaje)
			lb   $t1, 2(%puntaje)
			ascii_to_int ($t1)
			add  $t1, $t1, 1
			int_to_ascii ($t1)
			sb   $t1, 2(%puntaje)
			j    trail

	player_two: 	li %turn, 1
			li %ball_x, 22
			lb   $t1, 3(%puntaje)
			ascii_to_int ($t1)
			beq  $t1, 3, aumentar_set_p_two
			add  $t1, $t1, 1
			int_to_ascii ($t1)
			sb   $t1, 3(%puntaje)
			j    trail

	aumentar_set_p_two:
			li   $t1, 0
			sb   $t1, 0(%puntaje)
			sb   $t1, 3(%puntaje)
			lb   $t1, 4(%puntaje)
			ascii_to_int ($t1)
			beq  $t1, 5, verify_tiebreak_p_two
			beq  $t1, 6, aumentar_match_p_two
			add  $t1, $t1, 1
			int_to_ascii ($t1)
			sb   $t1, 4(%puntaje)
			j    trail

	verify_tiebreak_p_two:
			lb   $t1, 1(%puntaje)
			ascii_to_int ($t1)
			bgt  $t1, 4, tiebreak_p_two
			j    aumentar_match_p_two

	tiebreak_p_two:
			lb   $t1, 4(%puntaje)
			ascii_to_int ($t1)
			add  $t1, $t1, 1
			int_to_ascii ($t1)
			sb   $t1, 4(%puntaje)
			j    trail

	aumentar_match_p_two:
			li   $t1, 0
			sb   $t1, 1(%puntaje)
			sb   $t1, 4(%puntaje)
			lb   $t1, 5(%puntaje)
			ascii_to_int ($t1)
			add  $t1, $t1, 1
			int_to_ascii ($t1)
			sb   $t1, 5(%puntaje)

	trail: add_trail (%ball_x, %ball_y, %estelas)
.end_macro

# Macro para inicializar el puntaje del juego, set y match en 0
.macro inicializar_puntaje (%puntaje)
	li   $a1, 6
	li   $t1, '0'

	inicializar:
		sb   $t1, 0(%puntaje)
		add  %puntaje, %puntaje, 1
		sub  $a1, $a1, 1
		bnez $a1, inicializar

	sub  %puntaje, %puntaje, 6
.end_macro

# Macro para imprimir el puntaje actual
# También se encarga de verificar si alguno de los jugadores ganó 3 matches
# con lo cual se termina el juego
.macro imprimir_puntaje (%puntaje)
	# Imprimimos la sección de game
	print_str ("Game:  ")
	lb   $t1, 0(%puntaje)
	ascii_to_int ($t1)
	beqz $t1, cero
	beq  $t1, 1, quince
	beq  $t1, 2, treinta
	beq  $t1, 3, cuarenta

	cero: 	  print_str ("00")
		  j game_p_two

	quince:   print_str ("15")
		  j game_p_two

	treinta:  print_str ("30")
		  j game_p_two

	cuarenta: print_str ("40")
		  j game_p_two

game_p_two:
	print_str ("       Game:  ")
	lb   $t1, 3(%puntaje)
	ascii_to_int ($t1)
	beqz $t1, zero
	beq  $t1, 1, fifteen
	beq  $t1, 2, thirty
	beq  $t1, 3, forty

	zero: 	 print_str ("00")
		 j sets

	fifteen: print_str ("15")
		 j sets

	thirty:  print_str ("30")
		 j sets

	forty:   print_str ("40")
		 j sets

sets:
	# Imprimimos la sección de set
	print_str ("\nSet:   ")
	lb  $t1, 1(%puntaje)
	ascii_to_int ($t1)
	print_int ($t1)
	print_str ("        Set:   ")
	lb  $t1, 4(%puntaje)
	ascii_to_int ($t1)
	print_int ($t1)

	# Imprimimos la sección de match
	print_str ("\nMatch: ")
	lb  $t1, 2(%puntaje)
	ascii_to_int ($t1)
	print_int ($t1)
	print_str ("        Match: ")
	lb  $t1, 5(%puntaje)
	ascii_to_int ($t1)
	print_int ($t1)
	print_str ("\n\n")

	# Verificamos si alguno de los jugadores ganó 3 matches
	lb  $t1, 2(%puntaje)
	ascii_to_int ($t1)
	beq $t1, 3, player_one_won
	lb  $t1, 5(%puntaje)
	ascii_to_int ($t1)
	beq $t1, 3, player_two_won
	# Si no, continuamos con el juego
	j   end

	player_one_won:
		print_str ("Player 1 won 3 matches.\n")
		print_str ("Player 1 won!\n")
		print_str ("Thanks for playing :D\n")
		done ()

	player_two_won:
		print_str ("Player 2 won 3 matches.\n")
		print_str ("Player 2 won!\n")
		print_str ("Thanks for playing :D\n")
		done ()

	end:
.end_macro

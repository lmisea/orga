#######################
#     Proyecto 2      #
#    Input & Output   #
#      Luis Isea      #
#      19-10175       #
#######################

# En este archivo se encuentran todos los macros que se encargan de
# la entrada y salida del programa

.include "ball.asm"
.include "macros.asm"

# Macro para leer qué tecla presionó el usuario
# Este macro espera cualquier key interrupt y lee la tecla presionada
# por el usuario, ejecutando la acción correspondiente
.macro read_key (%ball_x, %ball_y, %vel_x, %vel_y, %mode_one, %mode_two, %previous_bounces, %turn, %service)
	lui $a2, 0xFFFF
	li  $t6, 1000 	# El número de veces que vamos a verificar si se presionó
			# una tecla o no
			# Usamos 1000 para que el le pueda dar tiempo al usuario
			# de presionar una tecla y que se pueda leer

	verify:
		lw   $t1, 0($a2) # Leemos el byte de control
		andi $t1, $t1, 0x0001

		# Si el byte de control es 1, significa que sí se presionó una tecla
		bgtz $t1, key_interrumpt

		# Si el byte de control es 0, significa que no se presionó una tecla
		# y se verifica si se llegó al límite de verificaciones
		beqz %service, verify
		j    no_service

	no_service:
		beqz $t6, end # Si se llegó al límite de verificaciones, se termina
					  # la ejecución del macro
		sub  $t6, $t6, 1
		j    verify   # Si no se llegó al límite de verificaciones, se verifica
					  # de nuevo si se presionó una tecla

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

	# Si se presionó la tecla 'd', el jugador 1 intenta raquetear
	d_key:	li  $t1, 0
		attempt_player_shot ($t1, %ball_x, %previous_bounces, %vel_x, %vel_y, %mode_one, %turn, %service)
		j   end

	# Si se presionó la tecla 'l', el jugador 2 intenta raquetear
	l_key:	li  $t1, 1
		attempt_player_shot ($t1, %ball_x, %previous_bounces, %vel_x, %vel_y, %mode_two, %turn, %service)
		j   end

	# Si se presionó la tecla 's', el jugador 1 activa el modo forehand
	s_key:	change_mode (%mode_one, 0)
		j   end

	# Si se presionó la tecla 'k', el jugador 2 activa el modo forehand
	k_key:	change_mode (%mode_two, 0)
		j   end

	# Si se presionó la tecla 'x', el jugador 1 activa el modo underhand
	x_key:	change_mode (%mode_one, 1)
		j   end

	# Si se presionó la tecla 'm', el jugador 2 activa el modo underhand
	m_key:	change_mode (%mode_two, 1)
		j   end

	# Si se presionó la tecla 'w', el jugador 1 activa el modo backhand
	w_key:	change_mode (%mode_one, 2)
		j   end

	# Si se presionó la tecla 'o', el jugador 2 activa el modo backhand
	o_key:	change_mode (%mode_two, 2)
		j   end

	# Si se presionó la tecla 'q', terminamos la ejecución del programa
	q_key:	done ()

	end:
.end_macro

# Macro para realizar un refrescamiento de la cancha
# Este macro recibe numerosos parámetros, que proporcionan toda la información
# necesaria para realizar el refrescamiento
.macro refresh_court (%ball_x, %ball_y, %vel_x, %vel_y, %mode_one, %mode_two, %previous_bounces, %turn, %service, %estelas, %puntaje)
	# Obtenemos el tiempo actual
	get_time ()
	move $a3, $a1

	# Usaremos $t8 para poder saber cuándo llegamos a la posición final de la pelota
	li   $t8, 0

	# En $k0 está la posición x de la pelota al finalizar el refrescamiento
	add  $k0, %ball_x, %vel_x
	# En $t2 está la posición y de la pelota al finalizar el refrescamiento
	add  $t2, %ball_y, %vel_y

	# Vamos cambiando la posición de la pelota hasta que lleguemos a la posición final
	verificar_estela:
		# Verificamos si la pelota llegó a la posición x final
		bne  %ball_x, $k0, dibujar_estela_x # Si no llegó, dibujamos la estela en la posición actual
		# Hacemos lo mismo con la posición y
		bne  %ball_y, $t2, dibujar_estela_y
		# Si llegamos a la posición final, saltamos a las verificaciones y luego
		# a la impresión de la cancha
		li   $t8, 1
		j    verificaciones

	dibujar_estela_x:
		bgtz %vel_x, vel_x_pos
		bltz %vel_x, vel_x_neg
		j    dibujar_estela_y

	vel_x_pos:
		add  %ball_x, %ball_x, 1
		j    dibujar_estela_y

	vel_x_neg:
		sub  %ball_x, %ball_x, 1
		j    dibujar_estela_y

	dibujar_estela_y:
		bgtz %vel_y, vel_y_pos
		bltz %vel_y, vel_y_neg
		j    dibujar_estela

	vel_y_pos:
		# Si ya llegamos a la posición final de y, no seguimos aumentando la posición y
		beq  %ball_y, $t2, dibujar_estela
		add  %ball_y, %ball_y, 1
		j    dibujar_estela

	vel_y_neg:
		# Si ya llegamos a la posición final de y, no seguimos disminuyendo la posición y
		beq  %ball_y, $t2, dibujar_estela
		sub  %ball_y, %ball_y, 1
		j    dibujar_estela

	dibujar_estela:
		add_trail (%ball_x, %ball_y, %estelas)
		j    verificaciones

	# Realizamos las verificaciones correspondientes para saber si la pelota rebotó, si
	# se tocó la red o si la pelota se salió de la cancha
verificaciones:
	is_ball_out_of_bounds (%ball_x, %ball_y, %vel_x, %vel_y, %mode_one, %mode_two, %previous_bounces, %turn, %service, %estelas, %puntaje)

	verify_ball_bounced (%ball_x, %ball_y, %vel_y, %previous_bounces, $t8)

	verify_ball_touched_net (%ball_x, %ball_y, %vel_x, $t8)

	# En caso de que la pelota no haya rebotado ni se haya tocado la red, se continua
	# con la siguiente posición de la estela
	beqz $t8, verificar_estela
	# En caso contrario, se procede a dibujar la cancha y la pelota junto con las estelas

	draw_court (%estelas, 0)

	# Reducion de velocidad y de la pelota en 1 al finalizar el refrescamiento
	reduce_vel_y (%vel_y)

	# Se verifica si el usuario presionó una tecla
	read_key (%ball_x, %ball_y, %vel_x, %vel_y, %mode_one, %mode_two, %previous_bounces, %turn, %service)

	# Por último, se duerme el programa el tiempo restante de los 200 ms
	get_time ()
	sub  $a3, $a3, $a1 #tiempo transcurrido
	li   $t1, 200
	sub  $a0, $t1, $s3 #tiempo restante
	sleep ($a0)
.end_macro

# Macro para dibujar la cancha de tenis, junto con la pelota y las estelas
# Este macro recibe como parámetros la dirección de memoria donde se encuentra el
# arreglo de estelas y un valor que indica si se debe saltar la primera estela o no
.macro draw_court (%estelas, %skip_first)
	.data
		first_line:   	.asciiz "                         \n"
		second_line:  	.asciiz "                         \n"
		third_line:   	.asciiz "                         \n"
		fourth_line:  	.asciiz "                         \n"
		fifth_line:   	.asciiz "                         \n"
		sixth_line:   	.asciiz "                         \n"
		seventh_line: 	.asciiz "            O            \n"
		eighth_line: 	.asciiz "            O            \n"
		ninth_line:  	.asciiz "            O            \n"
		tenth_line:  	.asciiz "OOOOOOOOOOOOOOOOOOOOOOOOO\n\n"

		blank_line:	.asciiz "                         \n"
		net_line:	.asciiz "            O            \n"

	.text
	# En $t3 anotamos el número de estela que estamos dibujando
	li  $t3, 0
	# Usaremos $t5 para evitar dibujar una estela en la red
	li  $t5, 0

trail:
	# Aumentamos el número de estela que estamos dibujando
	add $t3, $t3, 1

	# Si estamos dibujando la primera estela, verificamos si debemos saltarla
	beq $t3, 1, verify_if_skip
	j   no_skip

verify_if_skip:
	# Verificamos si tenemos que saltarnos la primera estela
	li   $t1, %skip_first
	bgtz $t1, next_trail

no_skip:
	# Verificamos si la estela existe
	lb  $t1, 2(%estelas)
	li  $t8, '-'
	# Si la estela no existe, entonces no la dibujamos
	# Ya que '-' es el caracter que indica que la estela no existe
	beq $t1, $t8, next_trail # Si la estela no existe, saltamos a la siguiente estela

	# La estela existe, asi que calculamos la posición en y de la estela
	calcular_coordenada_estela ('y', $t8, %estelas) # En $t8 tenemos la posición en y de la estela
	j calcular_linea

	# Con esta etiqueta, podemos saltar a la siguiente estela
	next_trail:
		blt $t3, 11, add_four
		sub %estelas, %estelas, 40
		# Si ya dibujamos las 10 estelas, entonces saltamos a imprimir la cancha
		j   imprimir

	# Con esta etiqueta, podemos agregar 4 a la dirección de memoria de las estelas
	# para pasar a la siguiente estela
	add_four:
		li  $t5, 0
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

	beqz $t8, next_trail

	# Si la pos y no está entre 0 y 9, se salta a la siguiente estela
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
		li $t5, 1
		j  calcular_pos_x

	octava_lin:
		la $t6, eighth_line
		li $t5, 1
		j  calcular_pos_x

	novena_lin:
		la $t6, ninth_line
		li $t5, 1
		j  calcular_pos_x

	# Calculamos la posición x de la lin correspondiente
	calcular_pos_x:

		calcular_coordenada_estela ('x', $t8, %estelas) # En $t8 tenemos la posición en x de la estela

		# Verificamos si la estela está en la red
		beq  $t7, 1, verify_net
		j    continue

		verify_net:
			# Si la estela está en la red, entonces no la dibujamos
			# y saltamos a la siguiente estela
			beq $t8, 12, next_trail

	continue:
		# Colocamos la posición en x de la línea correspondiente
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

	# A este punto, o se agregaron todas las estelas o hubo una colisión
	# En cualquier caso, se procede a imprimir la cancha
	imprimir:
		print_space (first_line)
		print_space (second_line)
		print_space (third_line)
		print_space (fourth_line)
		print_space (fifth_line)
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
.end_macro

#######################
#     Proyecto 2      #
#    Tennis For Two   #
#      Luis Isea      #
#      19-10175       #
#######################

.include "in_out.asm"

.data
	estelas_array: .space 20

.text
main: 	# $s1 es el reg para la pos x de la pelota
	# $s2 es el reg para la pos y de la pelota
	# $s3 es el reg para la vel en x de la pelota
	# $s4 es el reg para la vel en y de la pelota
	# $s5 es el reg para el modo de golpe de la pelota
	# $s6 es el reg para contar cuantas veces ha rebotado la pelota en el turno
	# $s7 es el reg para saber a que jugador le toca raquetear
	# $t4 es el reg para marcar si se está al inicio de un servicio o no
	# $t9 es el reg donde cargaremos la dirección del space estelas

	la $t9, estelas_array

	# El partido empieza con el servicio para el player 1
	new_service (0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $t4, $t9)
	draw_court  ($t9)

	# Cuando empieza un servicio, se espera hasta que el jugador que le toca
	# sacar raquetee la pelota antes de refrescar la pantalla
	service_start:
		print_space (estelas_array)
		read_key ($s1, $s2, $s3, $s4, $s5, $s6, $s7, $t4)
		beqz  $t4, service_start

	# Una vez que se raqueteó la pelota en el servicio, se refresca la pantalla
	# hasta que la pelota salga del campo y empiece un nuevo servicio
	refresh_screen:
		print_space (estelas_array)
		refresh_court ($s1, $s2, $s3, $s4, $s5, $s6, $s7, $t4, $t9)
		beqz $t4, service_start
		j    refresh_screen

	# Se termina el programa cuando el usuario presione 'q' o 'Q'

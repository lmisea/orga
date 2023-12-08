#######################
#     Proyecto 2      #
#    Tennis For Two   #
#      Luis Isea      #
#      19-10175       #
#######################

.include "in_out.asm"

.data

.text
main: 	# $s1 es el reg para la pos x de la pelota
	# $s2 es el reg para la pos y de la pelota
	# $s3 es el reg para la vel en x de la pelota
	# $s4 es el reg para la vel en y de la pelota
	# $s5 es el reg para el modo de golpe de la pelota
	# $s6 es el reg para contar cuantas veces ha rebotado la pelota en el turno
	# $s7 es el reg para saber a que jugador le toca raquetear
	# $t9 es el reg para marcar si se está al inicio de un servicio o no

	# El partido empieza con el servicio para el player 1
	new_service (0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $t9)
	draw_court ($s1, $s2, $s3, $s4)
	
	read:
		read_key ($s1, $s2, $s3, $s4, $s5, $s6, $s7, $t9)
		bgtz $t9, refresh_screen
		j read

	refresh_screen:
		draw_court ($s1, $s2, $s3, $s4)
		read_key ($s1, $s2, $s3, $s4, $s5, $s6, $s7, $t9)

	done

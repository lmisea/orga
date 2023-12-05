#######################
#     Proyecto 2      #
#    Input & Output   #
#      Luis Isea      #
#      19-10175       #
#######################

.include "macros.asm"

# Macro para realizar un refresh de la pantalla
.macro refresh
	get_time
	move $s6, $a1

	print_str ("Hola Mundo\n")

	get_time
	sub $s6, $s6, $a1 #tiempo transcurrido
	li  $t7, 200
	sub $a0, $t7, $s6 #tiempo restante
	sleep ($a0)
.end_macro

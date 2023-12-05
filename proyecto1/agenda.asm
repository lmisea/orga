#######################
#     Proyecto 1      #
#  Agenda Estudiantil #
#    Sergio Carillo   #
#      14-11315       #
#      Luis Isea      #
#      19-10175       #
#######################

.include "cursos.asm"
.include "horario.asm"
.include "inAndOut.asm"
.include "macros.asm"

.data
horario: 	.space  96 	# Hay 6 días en la semana del calendario
				# Cada día tiene 8 bloques de clases posibles (01,02,...,08)
				# Y cada bloque tiene un carácter <T,L> y el núm del curso del
				# cual es la clase

hor_conflictos:	.space  96	# Horario donde se guardarán las clases que estén en el mismo
				# horario que una clase que ya esté en el horario

dia:		.byte    0
.text
main:		crear_horario_de_clases (horario, hor_conflictos)
		lb $a2, dia
		li $a3, '1'
		imprimir_bloque_de_horario (horario, hor_conflictos, $a2, $a3)
leer_tecla:	read_key (horario, hor_conflictos, $a2, $a3)
		j leer_tecla
		done

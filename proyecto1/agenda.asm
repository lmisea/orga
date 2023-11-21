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
horario: 	.space 96 	# Hay 6 días en la semana del calendario
				# Cada día tiene 8 bloques de clases posibles (01,02,...,08)
				# Y cada bloque tiene un carácter <T,L> y el núm del curso del
				# cual es la clase

hor_conflictos:	.space 96	# Horario donde se guardarán las clases que estén en el mismo
				# horario que una clase que ya esté en el horario

.text
main:	crear_horario_de_clases (horario, hor_conflictos)
	imprimir_bloque_de_horario (horario, hor_conflictos, 2, '3')
	read_key ()
	done

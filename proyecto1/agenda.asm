#######################
#     Proyecto 1      #
#  Agenda Estudiantil #
#    Sergio Carillo   #
#      14-11315       #
#      Luis Isea      #
#      19-10175       #
#######################

.include "macros.asm"
.include "horario.asm"

.data
newline: 	.asciiz "\n"
space_char:	.asciiz " "
horizontalLine: .asciiz "---------------------------------------\n"
separator: 	.asciiz "|"
up:		.asciiz "|^"
down:		.asciiz "|v"
left_and_right: .asciiz "<-A | D->"
hyphen: 	.asciiz "–"

T:		.asciiz "T"
L:		.asciiz "L"

lun: 		.space 16 	# Cada día tiene 8 bloques de clases posibles (01,02,...,08)
				# Y cada bloque tiene un carácter <T,L> y el núm del curso del
				# cual es la clase
mar: 		.space 16
mie: 		.space 16
jue:		.space 16
vie:		.space 16
sab:		.space 16

.text
main:	leerCOD(C1N)
	leerEDF(C1N)
	leerNOM(C1N)
	print_str ("\n")
	agregarCursoAlHorario(C1N, C1H, 1, lun, mar, mie, jue, vie, sab) 
	agregarCursoAlHorario(C2N, C2H, 2, lun, mar, mie, jue, vie, sab)
	print_str ("\n")
	readKey()
	done
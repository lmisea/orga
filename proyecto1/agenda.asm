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

lun: 		.asciiz "----------------" 	# Cada día tiene 8 bloques de clases posibles (01,02,...,08)
						# Y cada bloque tiene un carácter <T,L> y el núm del curso del
						# cual es la clase
mar: 		.asciiz "----------------" 
mie: 		.asciiz "----------------" 
jue:		.asciiz "----------------" 
vie:		.asciiz "----------------" 
sab:		.asciiz "----------------" 

.text
main:	print_str ("Primer curso: ")
	leerCOD(C1N)
	leerEDF(C1N)
	leerNOM(C1N)
	print_str ("\n\n")
	agregarCursoAlHorario(C1H,'1', lun, mar, mie, jue, vie, sab) 
	agregarCursoAlHorario(C2H,'2', lun, mar, mie, jue, vie, sab)
	agregarCursoAlHorario(C3H,'3', lun, mar, mie, jue, vie, sab)
	agregarCursoAlHorario(C4H,'4', lun, mar, mie, jue, vie, sab)
	agregarCursoAlHorario(C5H,'5', lun, mar, mie, jue, vie, sab)
	agregarCursoAlHorario(C6H,'6', lun, mar, mie, jue, vie, sab)
	agregarCursoAlHorario(C7H,'7', lun, mar, mie, jue, vie, sab)
	agregarCursoAlHorario(C8H,'8', lun, mar, mie, jue, vie, sab)
	print_str ("\n")
	print_space (lun, 0, 16)
	print_str ("\n")
	print_space (mar, 0, 16)
	print_str ("\n")
	print_space (mie, 0, 16)
	print_str ("\n")
	print_space (jue, 0, 16)
	print_str ("\n")
	print_space (vie, 0, 16)
	print_str ("\n")
	print_space (sab, 0, 16)
	print_str ("\n")
	readKey()
	done

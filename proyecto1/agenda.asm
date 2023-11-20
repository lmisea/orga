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

horario: 	.space 96 	# Hay 6 días en la semana del calendario
				# Cada día tiene 8 bloques de clases posibles (01,02,...,08)
				# Y cada bloque tiene un carácter <T,L> y el núm del curso del
				# cual es la clase
horConflictos:	.space 96	# Horario donde se guardarán las clases que estén en el mismo
				# horario que una clase que ya esté en el horario

.text
main:	inicializarHorario(horario)
	inicializarHorario(horConflictos)
	agregarCursoAlHorario(C1H,'1', horario, horConflictos) 
	agregarCursoAlHorario(C2H,'2', horario, horConflictos)
	agregarCursoAlHorario(C3H,'3', horario, horConflictos)
	agregarCursoAlHorario(C4H,'4', horario, horConflictos)
	agregarCursoAlHorario(C5H,'5', horario, horConflictos)
	agregarCursoAlHorario(C6H,'6', horario, horConflictos)
	agregarCursoAlHorario(C7H,'7', horario, horConflictos)
	agregarCursoAlHorario(C8H,'8', horario, horConflictos)
	print_str ("\n")
	print_str ("Lun: ")
	print_space (horario, 0, 16)
	print_str ("\n")
	print_space (horConflictos, 0, 16)
	print_str ("\n")
	print_str ("Mar: ")
	print_space (horario, 16, 16)
	print_str ("\n")
	print_space (horConflictos, 16, 16)
	print_str ("\n")
	print_str ("Mie: ")
	print_space (horario, 32, 16)
	print_str ("\n")
	print_space (horConflictos, 32, 16)
	print_str ("\n")
	print_str ("Jue: ")
	print_space (horario, 48, 16)
	print_str ("\n")
	print_space (horConflictos, 48, 16)
	print_str ("\n")
	print_str ("Vie: ")
	print_space (horario, 64, 16)
	print_str ("\n")
	print_space (horConflictos, 64, 16)
	print_str ("\n")
	print_str ("Sab: ")
	print_space (horario, 80, 16)
	print_str ("\n")
	print_space (horConflictos, 80, 16)
	print_str ("\n")
	readKey()
	done

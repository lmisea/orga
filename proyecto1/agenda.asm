#######################
#     Proyecto 1      #
#  Agenda Estudiantil #
#    Sergio Carillo   #
#      14-11315       #
#      Luis Isea      #
#      19-10175       #
#######################

.include "cn.asm"
.include "cursos.asm"
.include "horario.asm"
.include "inAndOut.asm"
.include "macros.asm"

.data
horario: 	.space 96 	# Hay 6 días en la semana del calendario
				# Cada día tiene 8 bloques de clases posibles (01,02,...,08)
				# Y cada bloque tiene un carácter <T,L> y el núm del curso del
				# cual es la clase

horConflictos:	.space 96	# Horario donde se guardarán las clases que estén en el mismo
				# horario que una clase que ya esté en el horario

.text
main:	crearHorarioClases(horario,horConflictos)
	imprimirBloqueDeHorario(horario, horConflictos, 0, 1)
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

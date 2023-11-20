#############################
#        Proyecto 1         #
#   Macros para leer un CN  #
#       Sergio Carillo      #
#         14-11315          #
#         Luis Isea         #
#         19-10175          #
#############################

# Los macro son secuencias invocables que se definen una sola vez y se pueden usar varias veces

# Macro para leer el COD-### de un CN
.macro leerCOD(%CN)
	print_space (%CN, 0, 8)
.end_macro 

# Macro para leer el EDF-### de un CN
.macro leerEDF(%CN)
	print_space (%CN, 8, 8)
.end_macro

# Macro para leer el NOMBRECURSO de un CN
.macro leerNOM(%CN)
	print_space (%CN, 16, 40)
.end_macro

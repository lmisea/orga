# Los macro son secuencias invocables que se definen una sola vez y se pueden usar varias veces

# Macro para imprimir un número entero
# Ya sea que el argumento es un valor immediate or un registro
# Ejemplo de uso: print_int ($s0) o print_int (10)
.macro 	print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro

# Macro para imprimir un string
# Ejemplo de uso: print_str ("Hola Mundo")
.macro print_str (%str)
	.data
myLabel:.asciiz %str
	.text
	li $v0, 4
	la $a0, myLabel
	syscall
.end_macro

# Macro para hacer un bucle for genérico
# El bluce for tiene 4 parámetros, %regIterator es el registro que itera
# desde %from hasta %to, y en cada iteración se ejecuta %bodyMacroName, que a
# su vez es un macro
.macro 	for (%regIterator, %from, %to, %bodyMacroName)
	add %regIterator, $zero, %from
	Loop:
	%bodyMacroName ()
	add %regIterator, %regIterator, 1
	ble %regIterator, %to, Loop
.end_macro

# Ejemplo del ciclo for en acción para imprimir los números
# del 1 al 10
# Macro para imprimir el iterador
# .macro 	print_iterator()
# 	print_int $t0
#	print_str "\n"
# .end_macro
	
# Imprimir los números del 1 al 10
# for ($t0, 1, 10, print_iterator)

# Terminar la ejecución del programa
.macro 	done
	li $v0,10
	syscall
.end_macro

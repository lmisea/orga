###############################
#         Proyecto 1          #
#  Macros para input/output   #
#        Sergio Carillo       #
#          14-11315           #
#          Luis Isea          #
#          19-10175           #
###############################

# Los macro son secuencias invocables que se definen una sola vez y se pueden usar varias veces

# Macro para leer qué tecla presionó el usuario
# Y poder realizar una acción dependiendo de la tecla presionada
# Ejemplo de uso: readKey()
.macro read_key ()
	.data
	key: 	.space  2  # Aquí se guarda la tecla presionada
	 	.ascii  "\0"
	 	.align  0
	w:	.asciiz "w"
	s:	.asciiz "s"
	a:	.asciiz "a"
	d:	.asciiz "d"
	x: 	.asciiz "x"

	.text
		# Se lee la tecla que presionó el usuario
		li  $v0, 8
		la  $a0, key
		li  $a1, 2
		syscall
		print_str ("\n") # Se imprime un salto de línea

		# Se compara la tecla presionada con las teclas válidas
		lb  $t0, key
		lb  $t1, w
		beq $t0, $t1, w_key
		lb  $t1, s
		beq $t0, $t1, s_key
		lb  $t1, a
		beq $t0, $t1, a_key
		lb  $t1, d
		beq $t0, $t1, d_key
		lb  $t1, x
		beq $t0, $t1, x_key
		print_str ("Tecla inválida")
		j end

	w_key:	print_str ("Se presionó w")
		j end

	s_key:	print_str ("Se presionó s")
		j end

	a_key:	print_str ("Se presionó a")
		j end

	d_key:	print_str ("Se presionó d")
		j end

	x_key:	print_str ("Cerrando agenda.")
		done

	end:
.end_macro

.macro imprimir_bloque_de_horario (%horario, %hor_conflictos, %dia, %hora)
		.data
			horizontal_line:.asciiz "---------------------------------------\n"
			second_line:	.asciiz "|                                     |^\n"
			third_line:	.asciiz "|                                     |W\n"
			fourth_line:	.asciiz "|                                     |S\n"
			fifth_line:	.asciiz "|                                     |v\n"
			left_and_right: .asciiz "<-A | D->\n"
	
			Lu:		.asciiz "Lunes"
			Ma:		.asciiz "Martes"
			Mi:		.asciiz "Miercoles"
			Ju:		.asciiz "Jueves"
			Vi:		.asciiz "Viernes"
			Sa:		.asciiz "Sabado"
			
			T:		.asciiz "T"
			L:		.asciiz "L"
			
			Li:		.asciiz "Libre"
		.text
			la  $t0, %horario
			la  $t1, %hor_conflictos
			add $t2, $zero, %dia
			li  $t3, %hora
	
			# Segunda línea
			
			la  $t4, second_line
			add $t4, $t4, 1
	
			beq $t2, 0, lun
			beq $t2, 1, mar
			beq $t2, 2, mie
			beq $t2, 3, jue
			beq $t2, 4, vie
			beq $t2, 5, sab
	
lun: 			li $t5, 5
			la $t6, Lu
			j agregar_dia

mar: 			li $t5, 6
			la $t6, Ma
			j agregar_dia

mie: 			li $t5, 9
			la $t6, Mi
			j agregar_dia
			
jue: 			li $t5, 6
			la $t6, Ju
			j agregar_dia
			
vie: 			li $t5, 7
			la $t6, Vi
			j agregar_dia
			
sab: 			li $t5, 6
			la $t6, Sa
			j agregar_dia

agregar_dia:	 	lb   $t7, 0($t6)
			sb   $t7, 0($t4)
			add  $t4, $t4, 1
			add  $t6, $t6, 1
			sub  $t5, $t5, 1
			bnez $t5, agregar_dia
			
agregar_hora:		add  $t4, $t4, 1
			li   $t7, '0'
			sb   $t7, 0($t4)
			add  $t4, $t4, 1
			sb   $t3, 0($t4)
			add  $t4, $t4, 2
			li   $t5, '-'
			sb   $t5, 0($t4)
			add  $t4, $t4, 2
			li   $t7, '0'
			sb   $t7, 0($t4)
			add  $t4, $t4, 1
			sb   $t3, 0($t4)
			
			# Cuarta línea
			
revisar_horario:        la   $s0, %horario
			mul  $t2, $t2, 16
			add  $s0, $s0, $t2
			andi $t3, $t3,0x0F 	# convertimos $t3 de ascii a un int
			mul  $t3, $t3, 2
			sub  $t3, $t3, 1
			sub  $t3, $t3, 1
			add  $s0, $s0, $t3
			lb   $t5, 0($s0)
			lb   $t6, T
			beq  $t5, $t6, hay_una_clase
			lb   $t6, L
			beq  $t5, $t6, hay_una_clase
			b hora_libre
			
hay_una_clase:		print_str ("Hay clase")
			j imprimir
			
hora_libre:		la  $s1, fourth_line
			add $s1, $s1, 10
			la  $s2, Li
			li  $s3, 5	
			
escribir_libre:		lb   $s4, 0($s2)
			sb   $s4, 0($s1)
			add  $s1, $s1, 1
			add  $s2, $s2, 1
			sub  $s3, $s3, 1
			bnez $s3, escribir_libre
			j imprimir
	 
imprimir:		print_space (horizontal_line, 0, 40)
			print_space (second_line, 0, 41)
			print_space (third_line, 0, 41)
			print_space (fourth_line, 0, 41)
			print_space (fifth_line, 0, 41)
			print_space (horizontal_line, 0, 40)
			print_space (left_and_right, 0, 10)
.end_macro 

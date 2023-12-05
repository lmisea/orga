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
.macro read_key (%hor_normal, %hor_conflictos, %dia, %hora)
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
		add $s1, $zero, %dia

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

	a_key:	sub  $a1, $a1, 1
		move %dia, $a1
		imprimir_bloque_de_horario (%hor_normal, %hor_conflictos, $a1, %hora)
		j end

	d_key:	add $a1, $a1, 1
		move %dia, $a1
		imprimir_bloque_de_horario (%hor_normal, %hor_conflictos, $a1, %hora)
		j end

	x_key:	print_str ("Cerrando agenda.")
		done

	end:
.end_macro

.macro imprimir_bloque_de_horario (%hor_normal, %hor_conflictos, %dia, %hora)
	imprimir_bloque (%hor_normal, %dia, %hora, 'N')
	imprimir_bloque (%hor_conflictos, %dia, %hora, 'C')
.end_macro 

.macro imprimir_bloque (%horario, %dia, %hora, %tipo)
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
			Teo:		.asciiz "Teoria"
			Lab:		.asciiz "Laboratorio"
		.text
			la   $t0, %horario
			add  $t2, $zero, %dia
			move $t3, %hora
	
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
			la  $s1, fourth_line
			
revisar_horario:        la   $s0, %horario
			mul  $t2, $t2, 16
			add  $s0, $s0, $t2
			andi $t3, $t3, 0x0F 	# convertimos $t3 de ascii a un int
			mul  $t3, $t3, 2
			sub  $t3, $t3, 1
			sub  $t3, $t3, 1
			add  $s0, $s0, $t3
			lb   $t5, 0($s0)
			lb   $t6, T
			beq  $t5, $t6, hay_teoria
			lb   $t6, L
			beq  $t5, $t6, hay_lab
			b hora_libre
			
hay_una_clase:		# Leer el num_curso de la clase
			add  $s0, $s0, 1
			lb   $s2, 0($s0)
			andi $s2, $s2, 0x0F	# convertimos $s2 de ascii a un int
			li   $t8, 4
			
cargar_CN:		beq  $s2, 1, c1
			beq  $s2, 2, c2
			beq  $s2, 3, c3
			beq  $s2, 4, c4
			beq  $s2, 5, c5
			beq  $s2, 6, c6
			beq  $s2, 7, c7
			beq  $s2, 8, c8
			
return:			add  $s1, $s1, 1
			li   $s4, 7
			
escribir_COD:		lb   $s5, 0($s3)
			sb   $s5, 0($s1)
			add  $s1, $s1, 1
			add  $s3, $s3, 1
			sub  $s4, $s4, 1
			bnez $s4, escribir_COD
			
			add  $s3, $s3, 9
			li   $s4, 25
			li   $s6, '\0'
			li   $s7, ' '
			sb   $s7, 0($s1)
			add  $s1, $s1, 1
			lb   $s5, 0($s3)
			li   $t9, 0
			
escribir_NOM:		bnez $t9, agregar_space_char
			lb   $s5, 0($s3)
			beq  $s5, $s6, agregar_space_char
guardar_char_NOM:	sb   $s5, 0($s1)
			add  $s1, $s1, 1
			add  $s3, $s3, 1
			sub  $s4, $s4, 1
			bnez $s4, escribir_NOM
			
			# Quinta linea
			
			la  $s1, fifth_line
			add $s1, $s1, 1
			li  $s4, 8
			li  $t8, 5
			j cargar_CN
return_EDF:		add $s3, $s3, 8
			
escribir_EDF:		lb   $s5, 0($s3)
			sb   $s5, 0($s1)
			add  $s1, $s1, 1
			add  $s3, $s3, 1
			sub  $s4, $s4, 1
			bnez $s4, escribir_EDF
			jr   $ra
			
agregar_space_char:	li   $s5, ' '
			li   $t9, 1
			j guardar_char_NOM
			
c1:			la  $s3, C1N
			beq $t8, 4, return
			j return_EDF

c2:			la  $s3, C2N
			beq $t8, 4, return
			j return_EDF

c3:			la  $s3, C3N
			beq $t8, 4, return
			j return_EDF

c4:			la  $s3, C4N
			beq $t8, 4, return
			j return_EDF

c5:			la  $s3, C5N
			beq $t8, 4, return
			j return_EDF

c6:			la  $s3, C6N
			beq $t8, 4, return
			j return_EDF

c7:			la  $s3, C7N
			beq $t8, 4, return
			j return_EDF

c8:			la  $s3, C8N
			beq $t8, 4, return
			j return_EDF
			
hay_teoria:		jal hay_una_clase
			la  $s3, Teo
			li  $s4, 6
			
escribir_Teo:		lb   $s5, 0($s3)
			sb   $s5, 0($s1)
			add  $s1, $s1, 1
			add  $s3, $s3, 1
			sub  $s4, $s4, 1
			bnez $s4, escribir_Teo
			j imprimir

hay_lab:		jal hay_una_clase
			la  $s3, Lab
			li  $s4, 11
			
escribir_Lab:		lb   $s5, 0($s3)
			sb   $s5, 0($s1)
			add  $s1, $s1, 1
			add  $s3, $s3, 1
			sub  $s4, $s4, 1
			bnez $s4, escribir_Lab
			j imprimir
			
hora_libre:		add $s1, $s1, 10
			li  $t1, %tipo
			li  $t9, 'C'
			beq $t1, $t9, end
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
			print_str ("\n")
end:
.end_macro 

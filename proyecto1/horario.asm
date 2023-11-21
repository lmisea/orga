#############################
#        Proyecto 1         #
#   Macros para el horario  #
#       Sergio Carillo      #
#         14-11315          #
#         Luis Isea         #
#         19-10175          #
#############################

# Los macro son secuencias invocables que se definen una sola vez y se pueden usar varias veces

.macro crear_horario_de_clases(%horario, %hor_conflictos)
	inicializar_horario (%horario)
	inicializar_horario (%hor_conflictos)
	agregar_curso_al_horario (C1H,'1', %horario, %hor_conflictos) 
	agregar_curso_al_horario (C2H,'2', %horario, %hor_conflictos)
	agregar_curso_al_horario (C3H,'3', %horario, %hor_conflictos)
	agregar_curso_al_horario (C4H,'4', %horario, %hor_conflictos)
	agregar_curso_al_horario (C5H,'5', %horario, %hor_conflictos)
	agregar_curso_al_horario (C6H,'6', %horario, %hor_conflictos)
	agregar_curso_al_horario (C7H,'7', %horario, %hor_conflictos)
	agregar_curso_al_horario (C8H,'8', %horario, %hor_conflictos)
.end_macro 

# Macro para inicializar todos los 96 caracteres de un horario a '-'
.macro inicializar_horario (%horario)
		la  $t0, %horario
		li  $t1, '-'
		li  $t2, 96

poner_char:	sb  $t1, 0($t0)
		add $t0, $t0, 1
		sub $t2, $t2, 1
		bnez $t2, poner_char
.end_macro

.macro agregar_curso_al_horario (%CH, %num_curso, %horario, %hor_conflictos)
	.data
		T:	.asciiz "T"
		L:	.asciiz "L"
	.text
		la  $t0, %CH
    		li  $t2, 0
revisar_dia:
    		bnez $t2, siguiente_dia
verificar: 	lb   $t3, 0($t0)
        	lb   $t4, T
        	beq  $t3, $t4, teoria
        	lb   $t4, L
        	beq  $t3, $t4, lab
continue:  	add  $t2, $t2, 1
       		bne  $t2, 6, revisar_dia
        	j end
        
teoria: 	# Agregamos en el día $t2 la clase T%num_curso
        	add  $t0, $t0, 2  	# Obtenemos la hora inicial
        	lb   $t5, 0($t0)
        	andi $t5, $t5,0x0F 	# convertimos $t5 de ascii a un int
        	
        	add  $t0, $t0, 2  	# Obtenemos la hora final
        	lb   $t6, 0($t0)
        	andi $t6, $t6,0x0F 	# convertimos $t6 de ascii a un int

        	sub $t0, $t0, 4 
		verificar_si_hay_conflicto ($t2, %horario, %hor_conflictos, 'T', %num_curso, $t5, $t6)
        	j continue
        
lab: 		# Agregamos en el día $t2 la clase L%numCurso
        	add  $t0, $t0, 2  	# Obtenemos la hora inicial
        	lb   $t5, 0($t0)
        	andi $t5, $t5,0x0F 	# convertimos $t5 de ascii a un int

        	add  $t0, $t0, 2  	# Obtenemos la hora final
        	lb   $t6, 0($t0)
        	andi $t6, $t6,0x0F 	# convertimos $t6 de ascii a un int

		sub $t0, $t0, 4 
        	verificar_si_hay_conflicto ($t2, %horario, %hor_conflictos, 'L', %num_curso, $t5, $t6)
        	j continue
        
siguiente_dia: 	add $t0, $t0, 5
        	j verificar
        
end:
.end_macro

.macro verificar_si_hay_conflicto (%dia, %horario, %hor_conflictos, %tipo, %num_curso, %hor_ini, %hor_fin)
		.data
			T:	.asciiz "T"
			L:	.asciiz "L"
		.text
			jal obtener_dia
			add $s1, $zero, %hor_ini
			add $s4, $zero, %hor_fin
			sub $s4, $s4, $s1  # %hor_fin - %hor_ini
			add $s4, $s4, 1
			li  $s5, 0

verificar:		mul $s1, $s1, 2
			sub $s1, $s1, 1
			sub $s1, $s1, 1
			add $s0, $s0, $s1
			lb  $s6, 0($s0)
			lb  $s7, T
			beq $s6, $s7, hay_conflicto
			lb  $s7, L
			beq $s6, $s7, hay_conflicto
			b no_hay_conflicto

continue:		add $s1, $zero, %hor_ini
			add $s1, $s1, $s5
			sub $s4, $s4, 1
			bnez $s4, siguiente
			j end

siguiente:		add $s1, $s1, 1
	   		add $s5, $s5, 1
	   		jal obtener_dia
	   		j verificar

obtener_dia:		la  $s0, %horario
			add $s7, $zero, %dia
			mul $s7, $s7, 16
			add $s0, $s0, $s7
			jr  $ra
		
no_hay_conflicto:	add $s1, $zero, %hor_ini
			add $s1, $s1, $s5
			agregar_clase (%dia, %horario, %tipo, %num_curso, $s1)
			j continue

hay_conflicto: 		add $s1, $zero, %hor_ini
			add $s1, $s1, $s5
			agregar_clase (%dia, %hor_conflictos, %tipo, %num_curso, $s1)
			j continue

end:
.end_macro

.macro agregar_clase (%dia, %horario, %tipo, %num_curso, %hora)
		la  $s0, %horario
		add $s7, $zero, %dia
		mul $s7, $s7, 16
		add $s0, $s0, $s7
		
		li  $s2, %tipo
		li  $s3, %num_curso
		add $s1, $zero, %hora

		mul $s1, $s1, 2
		sub $s1, $s1, 1
		sub $s1, $s1, 1
		add $s0, $s0, $s1
		sb  $s2, 0($s0)
		add $s0, $s0, 1
		sb  $s3, 0($s0)
.end_macro


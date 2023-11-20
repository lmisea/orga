#############################
#        Proyecto 1         #
#   Macros para el horario  #
#       Sergio Carillo      #
#         14-11315          #
#         Luis Isea         #
#         19-10175          #
#############################

# Los macro son secuencias invocables que se definen una sola vez y se pueden usar varias veces

# Macro para inicializar todos los 96 caracteres de un horario a '-'
.macro inicializarHorario(%horario)
		la  $t0, %horario
		li  $t1, '-'
		li  $t2, 96

ponerChar:	sb  $t1, 0($t0)
		add $t0, $t0, 1
		sub $t2, $t2, 1
		bnez $t2, ponerChar
.end_macro

.macro agregarCursoAlHorario(%CH, %numCurso, %horario, %horConflictos)
	.data
	T:	.asciiz "T"
	L:	.asciiz "L"
	.text
	la  $t0, %CH
    	li  $t2, 0
    	revisarDia:
    		   bnez $t2, siguienteDia
    	verificar: lb   $t3, 0($t0)
        	   lb   $t4, T
        	   beq  $t3, $t4, teoria
        	   lb   $t4, L
        	   beq  $t3, $t4, lab
        continue:  add  $t2, $t2, 1
       		   bne  $t2, 6, revisarDia
        	   j end
        
        teoria: # Agregamos en el día $t2 la clase T%numCurso
        	print_str ("T el ")
        	print_int ($t2)
        	print_str (", desde 0")
        	add $t0, $t0, 2  	# Obtenemos la hora inicial
        	lb  $t5, 0($t0)
        	andi $t5, $t5,0x0F 	# convertimos $t3 de ascii a un int
        	print_int ($t5)
        	print_str (" hasta 0")
        	add $t0, $t0, 2  	# Obtenemos la hora final
        	lb  $t6, 0($t0)
        	andi $t6, $t6,0x0F 	# convertimos $t3 de ascii a un int
        	print_int ($t6)
        	print_str ("\n")
        	sub $t0, $t0, 4 
		verificarSiHayConflicto($t2, %horario, %horConflictos, 'T', %numCurso, $t5, $t6)
        	j continue
        
        lab: 	# Agregamos en el día $t2 la clase L%numCurso
        	print_str ("L el ")
        	print_int ($t2)
        	print_str (", desde 0")
        	add $t0, $t0, 2  	# Obtenemos la hora inicial
        	lb  $t5, 0($t0)
        	andi $t5, $t5,0x0F 	# convertimos $t3 de ascii a un int
        	print_int ($t5)
        	print_str (" hasta 0")
        	add $t0, $t0, 2  	# Obtenemos la hora final
        	lb  $t6, 0($t0)
        	andi $t6, $t6,0x0F 	# convertimos $t3 de ascii a un int
        	print_int ($t6)
        	print_str ("\n")
        	verificarSiHayConflicto($t2, %horario, %horConflictos, 'L', %numCurso, $t5, $t6)
        	j continue
        
        siguienteDia: 	add $t0, $t0, 5
        		j verificar
        
        end:
.end_macro

.macro verificarSiHayConflicto(%dia, %horario, %horConflictos, %tipo, %numCurso, %horIni, %horFin)
		.data
		T:	.asciiz "T"
		L:	.asciiz "L"
		.text
		jal obtenerDia
		add $s1, $zero, %horIni
		add $s4, $zero, %horFin
		sub $s4, $s4, $s1  # %horFin - %horIni
		add $s4, $s4, 1
		li  $s5, 0

verificar:	mul $s1, $s1, 2
		sub $s1, $s1, 1
		sub $s1, $s1, 1
		add $s0, $s0, $s1
		lb  $s6, 0($s0)
		lb  $s7, T
		beq $s6, $s7, hayConflicto
		lb  $s7, L
		beq $s6, $s7, hayConflicto
		b noHayConflicto

continue:	add $s1, $zero, %horIni
		add $s1, $s1, $s5
		sub $s4, $s4, 1
		bnez $s4, siguiente
		j end

siguiente:	add $s1, $s1, 1
	   	add $s5, $s5, 1
	   	jal obtenerDia
	   	j verificar

obtenerDia:	la  $s0, %horario
		add $s7, $zero, %dia
		mul $s7, $s7, 16
		add $s0, $s0, $s7
		jr $ra
		
noHayConflicto:	add $s1, $zero, %horIni
		add $s1, $s1, $s5
		agregarClase(%dia, %horario, %tipo, %numCurso, $s1)
		j continue

hayConflicto: 	add $s1, $zero, %horIni
		add $s1, $s1, $s5
		agregarClase(%dia, %horConflictos, %tipo, %numCurso, $s1)
		j continue

end:
.end_macro

.macro agregarClase(%dia, %horario, %tipo, %numCurso, %hora)
		la  $s0, %horario
		add $s7, $zero, %dia
		mul $s7, $s7, 16
		add $s0, $s0, $s7
		
		li  $s2, %tipo
		li  $s3, %numCurso
		add $s1, $zero, %hora

agregar:	mul $s1, $s1, 2
		sub $s1, $s1, 1
		sub $s1, $s1, 1
		add $s0, $s0, $s1
		sb  $s2, 0($s0)
		add $s0, $s0, 1
		sb  $s3, 0($s0)
.end_macro

#######################
#     Proyecto 1      #
#  Archivo de Macros  #
#    Sergio Carillo   #
#      14-11315       #
#      Luis Isea      #
#      19-10175       #
#######################

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
text:	.asciiz %str
	.text
	li $v0, 4
	la $a0, text
	syscall
.end_macro

# Macro para imprimir un space de ascii
# %buffer: Label que se quiere imprimir
# %start: A partir de qué byte de %buffer se va a imprimir
# %length: Cuántos carácteres se quieren imprimir
.macro print_space(%buffer, %start, %length)
    .data
    buffer_str: .space %length  # Ajustar el tamaño según tus necesidades
    .text

    # Copiar el contenido del buffer al espacio reservado
    la $t0, %buffer
    la $t1, buffer_str
    li $t2, %length
    add $t0, $t0, %start  # Mover al inicio especificado
    loop_copy:
        lb $t3, 0($t0)
        sb $t3, 0($t1)
        addi $t0, $t0, 1
        addi $t1, $t1, 1
        subi $t2, $t2, 1
        bnez $t2, loop_copy

    # Imprimir el contenido del espacio reservado
    li $v0, 4
    la $a0, buffer_str
    syscall
.end_macro

# Macro para leer qué tecla presionó el usuario
# Y poder realizar una acción dependiendo de la tecla presionada
# Ejemplo de uso: readKey()
.macro readKey()
	.data
	key: 	.space 2  # Aquí se guarda la tecla presionada
	 	.ascii "\0"
	 	.align 0
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
		beq $t0, $t1, wKey
		lb  $t1, s
		beq $t0, $t1, sKey
		lb  $t1, a
		beq $t0, $t1, aKey
		lb  $t1, d
		beq $t0, $t1, dKey
		lb  $t1, x
		beq $t0, $t1, xKey
		print_str ("Tecla inválida")
		j end

	wKey:	print_str ("Se presionó w")
		j end

	sKey:	print_str ("Se presionó s")
		j end

	aKey:	print_str ("Se presionó a")
		j end

	dKey:	print_str ("Se presionó d")
		j end

	xKey:	print_str ("Cerrando agenda.")
		done

	end:
.end_macro

# Macro para hacer un bucle for genérico
# El bucle for tiene 4 parámetros, %regIterator es el registro que itera
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


# LEER Datos de un CN

# Macro para leer un atributo de un CiN
# %dest: Registro o dirección donde se almacenará la cadena
# %src: Direccián de la cadena a copiar
# %start: Posición de inicio en la cadena
# %length: Longitud de la cadena a copiar
.macro leerC(%dest, %destStart, %src, %srcStart, %length)
    .data
    buffer: .space %length
    .text

    # Copiar el contenido
    la  $t0, %src
    la  $t1, buffer
    li  $t2, %length
    add $t0, $t0, %srcStart  # Mover al inicio especificado
    loop_copy:
        lb   $t3, 0($t0)
        sb   $t3, 0($t1)
        addi $t0, $t0, 1
        addi $t1, $t1, 1
        subi $t2, $t2, 1
        bnez $t2, loop_copy

    # Copiar el contenido al destino
    la  $t0, %dest
    la  $t1, buffer
    li  $t2, %length
    add $t0, $t0, %destStart  # Mover al inicio especificado
    loop_copy_dest:
        lb   $t3, 0($t1)
        sb   $t3, 0($t0)
        addi $t0, $t0, 1
        addi $t1, $t1, 1
        subi $t2, $t2, 1
        bnez $t2, loop_copy_dest
.end_macro

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

.macro agregarCursoAlHorario(%CH, %numCurso, %lun, %mar, %mie, %jue, %vie, %sab)
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
        	beq $t2, 0, teoLun
		beq $t2, 1, teoMar
		beq $t2, 2, teoMie
		beq $t2, 3, teoJue
		beq $t2, 4, teoVie
		beq $t2, 5, teoSab
teoLun:        	agregarClase(%lun, 'T', %numCurso, $t5, $t6)
		j continue
teoMar:        	agregarClase(%mar, 'T', %numCurso, $t5, $t6)
		j continue
teoMie:        	agregarClase(%mie, 'T', %numCurso, $t5, $t6)
		j continue
teoJue:        	agregarClase(%jue, 'T', %numCurso, $t5, $t6)
		j continue
teoVie:		agregarClase(%vie, 'T', %numCurso, $t5, $t6)
		j continue
teoSab:		agregarClase(%sab, 'T', %numCurso, $t5, $t6)
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
        	sub $t0, $t0, 4 
        	beq $t2, 0, labLun
		beq $t2, 1, labMar
		beq $t2, 2, labMie
		beq $t2, 3, labJue
		beq $t2, 4, labVie
		beq $t2, 5, labSab
labLun:        	agregarClase(%lun, 'L', %numCurso, $t5, $t6)
		j continue
labMar:        	agregarClase(%mar, 'L', %numCurso, $t5, $t6)
		j continue
labMie:        	agregarClase(%mie, 'L', %numCurso, $t5, $t6)
		j continue
labJue:        	agregarClase(%jue, 'L', %numCurso, $t5, $t6)
		j continue
labVie:		agregarClase(%vie, 'L', %numCurso, $t5, $t6)
		j continue
labSab:		agregarClase(%sab, 'L', %numCurso, $t5, $t6)
        	j continue
        
        siguienteDia: 	add $t0, $t0, 5
        		j verificar
        
        end:
.end_macro

.macro agregarClase(%dia, %tipo, %numCurso, %horIni, %horFin)
	.data
	.text
	la  $s0, %dia
	li  $s2, %tipo
	li  $s3, %numCurso
	add $s1, $zero, %horIni
	add $s4, $zero, %horFin
	sub $s4, $s4, $s1  # %horFin - %horIni
	add $s4, $s4, 1
	li  $s5, 0

agregar:mul $s1, $s1, 2
	sub $s1, $s1, 1
	sub $s1, $s1, 1
	add $s0, $s0, $s1
	sb  $s2, 0($s0)
	add $s0, $s0, 1
	sb  $s3, 0($s0)
	add $s1, $zero, %horIni
	add $s1, $s1, $s5
	sub $s4, $s4, 1
	bnez $s4, siguiente
	j end

siguiente: add $s1, $s1, 1
	   add $s5, $s5, 1
	   la  $s0, %dia
	   j agregar

end:
.end_macro

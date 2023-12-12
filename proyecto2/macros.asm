#######################
#     Proyecto 2      #
#  Macros auxiliares  #
#      Luis Isea      #
#      19-10175       #
#######################

# Los macro son secuencias invocables que se definen una sola vez y se pueden usar varias veces
# En este archivo se definen los macro de uso general para el proyecto

# Macro para imprimir un número entero
# Ya sea que el argumento es un valor immediate or un registro
# Ejemplo de uso: print_int ($s0) o print_int (10)
.macro 	print_int (%x)
	li  $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro

# Macro para imprimir un string
# Ejemplo de uso: print_str ("Hola Mundo")
.macro print_str (%str)
	.data
texto:	.asciiz %str
	.text
	li $v0, 4
	la $a0, texto
	syscall
.end_macro

# Macro para imprimir un espacio reservado en memoria de caracteres ascii
.macro print_space (%space)
    	# Imprimir el contenido del espacio reservado
    	li $v0, 4
    	la $a0, %space
    	syscall
.end_macro

# Terminar la ejecución del programa
.macro 	done
	li $v0,10
	syscall
.end_macro

# Macro para hacer una espera de %time milisegundos
.macro 	sleep (%time)
	li   $v0, 32
	move $a0, %time
	syscall
.end_macro

# Macro para obtener la hora actual
.macro 	get_time
	li $v0, 30
	syscall
.end_macro

# Macro para convertir desde ascii a int
.macro ascii_to_int (%reg)
	andi %reg, %reg, 0x0F
.end_macro

# Macro para convertir desde int a un ascii
.macro int_to_ascii (%reg)
	beqz %reg, zero

	li  $t0, 1
	beq %reg, $t0, one

	li  $t0, 2
	beq %reg, $t0, two

	li  $t0, 3
	beq %reg, $t0, three

	li  $t0, 4
	beq %reg, $t0, four

	li  $t0, 5
	beq %reg, $t0, five

	li  $t0, 6
	beq %reg, $t0, six

	li  $t0, 7
	beq %reg, $t0, seven

	li  $t0, 8
	beq %reg, $t0, eight

	li  $t0, 9
	beq %reg, $t0, nine
	j   end

	zero: 	li %reg, '0'
		j  end

	one: 	li %reg, '1'
		j  end

	two: 	li %reg, '2'
		j  end

	three: 	li %reg, '3'
		j  end

	four: 	li %reg, '4'
		j  end

	five: 	li %reg, '5'
		j  end

	six: 	li %reg, '6'
		j  end

	seven: 	li %reg, '7'
		j  end

	eight: 	li %reg, '8'
		j  end

	nine: 	li %reg, '9'

	end:
.end_macro

# Macro para reescribir una linea de la cancha
# %line y %new_line deben tener 26 caracteres de longitud
.macro reescribir_linea (%line, %new_line)
	li $t8, 0
	copiar:
		add $t8, $t8, 1
		lb  $t1, 0(%new_line)
		sb  $t1, 0(%line)
		add %new_line, %new_line, 1
		add %line, %line, 1
		blt $t8, 26, copiar

	sub %new_line, %new_line, 26
.end_macro

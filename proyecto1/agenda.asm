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
key:  	.space 2
	.ascii "\0"
	.align 0
w:	.asciiz "w"
s:	.asciiz "s"
a:	.asciiz "a"
d:	.asciiz "d"

.text
main:	jal leerInput
	done

leerInput: 	li  $v0, 8
		la  $a0, key
		li  $a1, 2
		syscall
		print_str ("\n")
		lb  $t0, key
		lb  $t1, w
		beq $t0, $t1, wKey
		lb  $t1, s
		beq $t0, $t1, sKey
		lb  $t1, a
		beq $t0, $t1, aKey
		lb  $t1, d
		beq $t0, $t1, dKey
		print_str ("Tecla inválida")
returnToMain:	jr  $ra
		
wKey:	print_str ("Se presionó w")
	j returnToMain

sKey:	print_str ("Se presionó s")
	j returnToMain

aKey:	print_str ("Se presionó a")
	j returnToMain

dKey:	print_str ("Se presionó d")
	j returnToMain


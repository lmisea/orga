#######################
#     Proyecto 2      #
#    Tennis For Two   #
#      Luis Isea      #
#      19-10175       #
#######################

.include "in_out.asm"

.data

.text
main: 	li $s2, 2
	li $s3, 5
	li $s4, 0
	li $s5, 0
	draw_court ($s2, $s3, $s4, $s5)
	#read_key (3, 5, 0, 0, 0, 0, 0)
	done

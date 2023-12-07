#######################
#     Proyecto 2      #
#    Tennis For Two   #
#      Luis Isea      #
#      19-10175       #
#######################

.include "in_out.asm"

.data

.text
main: 	draw_court (3, 5, 0, 0)
	read_key (3, 5, 0, 0, 0, 0, 0)
	done

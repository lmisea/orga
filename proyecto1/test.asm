.include "horario.asm"
.include "macros.asm"

.data

# Variables para almacenar CiN
DatosCN: .space 448

.text
main:
    la $t3, DatosCN
    la $t4, C1N   
    leerC (DatosCN, C1N, 16, 40)
    leerC (DatosCN, C1N, 8, 7)
    leerC (DatosCN, C1N, 0, 7)
    done

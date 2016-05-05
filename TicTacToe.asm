

#Segmentul Data#

.data
tabla_joc:   .byte      '1', '2', '3', '4', '5', '6', '7', '8', '9'
nume_joc:      .asciiz   " \n\n X si 0 - varianta Multiplayer\n"
Oponenti:     .asciiz   " P 1 (X)  -  P 2 (0) \n\n"
b1:       .asciiz   "     |     |     \n"
b2:       .asciiz   "  "
b3:       .asciiz   "  |  "
b4:       .asciiz   "_____|_____|_____\n"
b5:       .asciiz   "  \n"
P1:       .asciiz   "P1, introdu un numar(1-9) : "
P2:       .asciiz   "P2, introdu un numar(1-9) : "
Gresit:  .asciiz   "\nMiscare gresita! Mai incearca : "
P1_castiga:      .asciiz   "P1 a castigat !!!"
P2_castiga:      .asciiz   "P2 a castigat !!!"
egalitate:        .asciiz   "Jocul s-a terminat la egalitate."

#    Segmentul Text   #

.text
.globl main

main:

     # Se incarca un vector care sa afiseze tabla_joc pentru X si 0 (O matrice 3x3)

     la $k0, tabla_joc
     addi $s0, $zero, 1
     addi $s3, $zero, 88
     addi $s4, $zero, 79

start:
      # Se face apel la functia de afisare a tablei de joc prin functia jal

      jal Tabla
      lb $t0, 0($k0)
      lb $t1, 1($k0)
      lb $t2, 2($k0)
      lb $t3, 3($k0)
      lb $t4, 4($k0)
      lb $t5, 5($k0)
      lb $t6, 6($k0)
      lb $t7, 7($k0)
      lb $t8, 8($k0)
      beq $s0, 2, Jucator2

      # Jucatorul cu numarul 1 va incepe intotdeauna jocul - el va folosi X

Jucator1:

       # Este randul Jucatorului 1 sa faca miscarea

       addi $s0, $zero, 2
       la $a0, P1
       addi $v0, $zero, 4
       syscall

       addi $s6, $zero, 88
       j condition


Jucator2:

       # Daca este randul Jucatorului 2 sa faca mutarea

       addi $s0, $zero, 1
       la $a0, P2
       addi $v0, $zero, 4
       syscall

       addi $s6, $zero, 79

condition:
         addi $v0, $zero, 12
         syscall

         addi $a3, $v0, 0
         beq $a3, $s3, m9
         beq $a3, $s4, m9
         bne $a3, $t0, m1
         sb  $s6, 0($k0)
         j m10

     # Bucla pentru conditionarea valorilor introduse, de fiecare daca se va face apel la m10 care este functia de check a starii jocului-
     # daca acesta este inca in desfasurare, se va trece la pasul urmator
     # In mod similar, conditionalele sunt verificate astfel incat jucatorii sa nu introduca valori mai mari de 9 sau mai mici de 0, ceea ce genereaza mesaj de eroare (m9)
     # si obliga jucatorul sa faca o selectie valida in matrice

m1:
         bne $a3, $t1, m2
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 1($k0)
         j m10
m2:
         bne $a3, $t2, m3
         beq $a3, $s6, m9
         sb  $s6, 2($k0)
         j m10
m3:
         bne $a3, $t3, m4
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 3($k0)
         j m10
m4:
         bne $a3, $t4, m5
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 4($k0)
         j m10
m5:
         bne $a3, $t5, m6
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 5($k0)
         j m10
m6:
         bne $a3, $t6, m7
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 6($k0)
         j m10
m7:
         bne $a3, $t7, m8
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 7($k0)
         j m10
m8:
         bne $a3, $t8, m9
         beq $a3, $s6, m9
         beq $a3, $s4, m9
         sb  $s6, 8($k0)
         j m10
m9:
         # In cazul in care jucatorul introduce o pozitie a matricei deja ocupata sau daca introduce o valoare mai mare decat 9 sau mai mica decat 1:

         la  $a0, Gresit
         addi $v0, $zero, 4
         syscall

         j condition
m10:
         # La fiecare pas, se apeleaza functia aceasta, care verifica daca vreunul dintre cei doi jucatori a castigat jocul

         jal CastigatorVerif
         addi $k1, $v0, 0
         beq $k1, -1, start
         jal Tabla
         beq $k1, 0, draw
         beq $s0, 1, Castiga_P2

Castiga_P1:

         # Functie care se apeleaza in cazul in care jucatorul 1 castiga jocul, afisand mesajul "P1 a castigat !!!"

         la  $a0, P1_castiga
         addi $v0, $zero, 4
         syscall
         j exit

Castiga_P2:

         # Functie care se apeleaza in cazul in care jucatorul 2 castiga jocul, afisand mesajul "P2 a castigat !!!"

         la  $a0, P2_castiga
         addi $v0, $zero, 4
         syscall
         j exit

draw:

         # Afisarea mesajului in caz de egalitate

         la $a0, egalitate
         addi $v0, $zero, 4
         syscall

exit:

         li $v0, 10
         syscall

CastigatorVerif:

         # Functie care verifica daca jocul este inca in desfasurare sau s-a terminat.
         # Rezultatul functiei va fi :
                                      # 1 - daca jocul se termina, unul dintre jucatori castigandu-l
                                      # 0 - daca jocul este in desfasurare
                                      # -1 - daca jocul se termina la egalitate

        lb $t0, 0($k0)
        lb $t1, 1($k0)
        lb $t2, 2($k0)
        lb $t3, 3($k0)
        lb $t4, 4($k0)
        lb $t5, 5($k0)
        lb $t6, 6($k0)
        lb $t7, 7($k0)
        lb $t8, 8($k0)
        bne $t0, $t1, C2
        bne $t1, $t2, C2
        addi $v0, $zero, 1
        jr $ra
C2:
        bne $t3, $t4, C3
        bne $t4, $t5, C3
        addi $v0, $zero, 1
        jr $ra
C3:
        bne $t6, $t7, C4
        bne $t7, $t8, C4
        addi $v0, $zero, 1
        jr $ra
C4:
        bne $t0, $t3, C5
        bne $t3, $t6, C5
        addi $v0, $zero, 1
        jr $ra
C5:
        bne $t1, $t4, C6
        bne $t4, $t7, C6
        addi $v0, $zero, 1
        jr $ra
C6:
        bne $t2, $t5, C7
        bne $t5, $t8, C7
        addi $v0, $zero, 1
        jr $ra
C7:
        bne $t0, $t4, C8
        bne $t4, $t8, C8
        addi $v0, $zero, 1
        jr $ra
C8:
        bne $t2, $t4, C9
        bne $t4, $t6, C9
        addi $v0, $zero, 1
        jr $ra
C9:
        beq $t0, '1', C10
        beq $t1, '2', C10
        beq $t2, '3', C10
        beq $t3, '4', C10
        beq $t4, '5', C10
        beq $t5, '6', C10
        beq $t6, '7', C10
        beq $t7, '8', C10
        beq $t8, '9', C10
        addi $v0, $zero, 0
        jr $ra
C10:
        addi $v0, $zero, -1
        jr $ra

Tabla:

     # Functie de desenare si afisare a tablei de joc ( matricea 3x3 )

     lb $t0, 0($k0)
     lb $t1, 1($k0)
     lb $t2, 2($k0)
     lb $t3, 3($k0)
     lb $t4, 4($k0)
     lb $t5, 5($k0)
     lb $t6, 6($k0)
     lb $t7, 7($k0)
     lb $t8, 8($k0)

     la $a0, nume_joc
     addi $v0, $zero, 4
     syscall

     la $a0, Oponenti
     syscall

     la $a0, b1
     syscall

     la $a0, b2
     syscall

B1:
     addi $a0, $t0, 0
     addi $v0, $zero, 11
     syscall

     la $a0, b3
     addi $v0, $zero, 4
     syscall

B2:
     addi $a0, $t1, 0
     addi $v0, $zero, 11
     syscall

     la $a0, b3
     addi $v0, $zero, 4
     syscall

B3:
     addi $a0, $t2, 0
     addi $v0, $zero, 11
     syscall

     la $a0, b5
     addi $v0, $zero, 4
     syscall

     la $a0, b4
     syscall

     la $a0, b1
     syscall

     la $a0, b2
     syscall

B4:
     addi $a0, $t3, 0
     addi $v0, $zero, 11
     syscall

     la $a0, b3
     addi $v0, $zero, 4
     syscall

B5:
     addi $a0, $t4, 0
     addi $v0, $zero, 11
     syscall

     la $a0, b3
     addi $v0, $zero, 4
     syscall

B6:
     addi $a0, $t5, 0
     addi $v0, $zero, 11
     syscall

     la $a0, b5
     addi $v0, $zero, 4
     syscall

     la $a0, b4
     syscall

     la $a0, b1
     syscall

     la $a0, b2
     syscall

B7:
     addi $a0, $t6, 0
     addi $v0, $zero, 11
     syscall

     la $a0, b3
     addi $v0, $zero, 4
     syscall

B8:
     addi $a0, $t7, 0
     addi $v0, $zero, 11
     syscall

     la $a0, b3
     addi $v0, $zero, 4
     syscall

B9:
     addi $a0, $t8, 0
     addi $v0, $zero, 11
     syscall

     la $a0, b5
     addi $v0, $zero, 4
     syscall

     la $a0, b1
     syscall

     jr $ra

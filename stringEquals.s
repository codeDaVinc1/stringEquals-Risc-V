
.data 

stringa_1: .string "Prova"
stringa_2: .string "prova"

.text

main:
  la s0, stringa_1
  la s1, stringa_2  
  mv a0, s0
  mv a1, s1
  jal stringEquals 
  mv t0, a0
  li a0, 70 
  li a7, 11
  beq t0, zero, m_res
  li a0, 84
  m_res:
  ecall 
  li a7, 10 # exit with 0
  ecall
    

stringEquals: 
  # salvo nello stack vari elementi perché farò chiamate ad altre procedure
  addi sp, sp, -12
  sw ra, 12(sp) # corrispondono a push(ra)
  sw a0, 8(sp) # corrispondono a push(a0: puntatore prima stringa)
  sw a1, 4(sp) # corrispondono a push(a1: puntatore seconda stringa)
  
  # stack dopo le precedenti tre istruzioni
  # [ra] coda
  # [a0]
  # [a1] testa
 
  jal stringLenght
  mv t3, a0
  
  # ripristino variabili della procedura
  lw a1, 4(sp)
  lw a0, 8(sp)
  lw ra, 12(sp)
  addi sp, sp, 12
  
  addi sp, sp, -16
  sw ra, 16(sp) 
  sw a0, 12(sp) 
  sw a1, 8(sp) 
  sw t3, 4(sp) 
  
  mv a0, a1
  jal stringLenght
  mv t4, a0
  
  lw t3, 4(sp)
  lw a1, 8(sp)
  lw a0, 12(sp)
  lw ra, 16(sp)
  addi sp, sp, 16
  
  # se le due stringhe hanno lunghezza diverse, ritorna falso: 0
  # t3: length stringa_1
  # t4: length stringa_2
  bne t3, t4, rf_se
  forSe:
      lb t1, 0(a0)
      lb t2, 0(a1)
      bne t1, t2, rf_se # se i due caratteri non sono uguali, torna false [1]
      beq t1, zero, end_forSe # se trovo fine stringa, esco con true [2]
      addi a0, a0, 1
      addi a1, a1, 1
      j forSe
  end_forSe:   
  li a0, 1 # [2]
  jr ra
  
  rf_se: #return false string equals [1]
  li a0, 0
  jr ra
  
stringLenght: 
    li t1, 0 # conta occorrenze
    while:
		lb t0, 0(a0)
		beq t0, zero, fn_while # esco quando trovo fine stringa
        addi t1, t1, 1 # aggiungo un'occorrenza
		addi a0, a0, 1 # scorro la stringa byte dopo byte
    j while
    fn_while:
    mv a0, t1
	jr ra

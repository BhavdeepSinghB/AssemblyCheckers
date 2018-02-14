    .data
row:    .asciiz "Row: "
col:    .asciiz "Column: "
val:    .asciiz "Value: "
nl:     .asciiz "\n"
r1: 	.asciiz "Enter source row"
r2: 	.asciiz "Enter destination row"
c1: 	.asciiz "Enter source column"
c2: 	.asciiz "Enter destination column"
nl: 	.asciiz "\n"
er: 	.asciiz "Error"
th: 	.asciiz "Problem lies here"
	.globl main
    
    .code
main:

    addi $sp,$sp,-400
    
    #-----Set Board----------------
    mov $s0,$sp
    mov $t1,$zero
    mov $s5,$zero
	
	addi $sp,$sp,-16
    mov $s1,$sp                     #s1 now points towards freed up memory
    
    j setlooptest
    
setloop:
    sll $t2,$t1,2
    add $t2,$t2,$s0
    sw $zero,0($t2)
    addi $t1,$t1,1
    
setlooptest:
    blt $t1,100,setloop
    
    mov $s3,$zero
    mov $t3,$zero
    mov $t6,$zero
    mov $t4,$zero
    #-----Loop to ask for numbers and set in board---------
    
    j mainlooptest
    
mainloop:
    jal displayboard
    
    la $a0,row
    syscall $print_string
    syscall $read_int
    mov $t3,$v0                         #t3 contains row number
    
    beq $t3,-1,next
    
    la $a0,col
    syscall $print_string
    syscall $read_int
    mov $t6,$v0                         #t6 contains column number
    
	mov $a1,$t3
	mov $a2,$t6
	
	jal isLegalPosition
	
	beq $v0,0,err
	
    la $a0,val
    syscall $print_string
    syscall $read_int
    mov $t4,$v0                         #t4 contains value
    
    mul $a1,$a1,10
    add $a1,$a1,$a2
    
    sll $t2,$a1,2                       
    add $t2,$t2,$s0                     #stores value of t4 into the position given in t3 in the array
    sw $t4,0($t2)
    
    
mainlooptest:
    j mainloop							#loop doesn't quit till row = -1

next:
	addi $sp,$sp,-16
    mov $s1,$sp                     	#s1 now points towards freed up memory

	jal reset
	
	j secondlooptest
	
secondloop:
    la $a0,r1
    syscall $print_string
    syscall $read_int
    
	beq $v0,-1,exit
	
    sw $v0,12($s1)
    
    la $a0,c1
    syscall $print_string
    syscall $read_int
    
    sw $v0,8($s1)
    
    
    la $a0,r2
    syscall $print_string
    syscall $read_int
    
    sw $v0,4($s1)
    
    la $a0,c2
    syscall $print_string
    syscall $read_int
    
    sw $v0,0($s1)
	
	jal isValidMove
	mov $a0,$v0
	syscall $print_int
	
	la $a0,nl
	syscall $print_string
	
	jal isValidJump
	mov $a0,$v1
	syscall $print_int
	
secondlooptest:
	j secondloop						#loop doesnt quit till row1 = -1	
	
exit:
    syscall $exit    
    
displayboard:
    mov $t9,$zero
    mov $t8,$zero
    
    li $t2,0
    li $s6,0
    li $s7,0
    li $t5,2
    li $t3,0
    li $t4,0
    li $t6,0
    
    j loopouttest
    
loopout:
    
loopin:
    mul $s5,$s7,10
    add $t9,$s5,$s6
    add $t7,$s6,$s7
    div $t4,$t7,$t5
    mfhi $t4
    
    beqz $t4,white
    beq  $t4,1,black
    
white:
    sll $s2,$t2,2
    add $s2,$s2,$s0
    lw  $s1,0($s2)
    
    beq $s1,3,w
    beq $s1,1,r
    beq $s1,5,bigW
    beq $s1,7,bigR
    
    
    la $a0,32
    syscall $print_char
    j increment
    
w:
    la $a0,119
    syscall $print_char
    j increment
    
r:
    la $a0,114
    syscall $print_char
    j increment
    
bigW:
    la $a0,87
    syscall $print_char
    j increment

bigR:
    la $a0,82
    syscall $print_char
    j increment
    
black:
    li $a0,219
    syscall $print_char

    j increment
    
increment:
    addi $s6,$s6,1
    addi $t2,$t2,1
    
loopintest:
    blt $s6,$t8,loopin
    
    addi $s7,$s7,1
    
    la $a0,nl
    syscall $print_string

loopouttest:
    addi $t8,$s6,10
    blt $s7,10,loopout
    
    jr $ra
	
isLegalPosition:
	blt $a1,0,return
	blt $a2,0,return
	bgt $a1,9,return
	bgt $a2,9,return
	
	li $t2,2
	
	add $t3,$a1,$a2
	div $t3,$t3,$t2
	mfhi $t3
	
	bnez $t3,return
	
	li $v0,1
	jr $ra
return:
	mov  $v0,$zero
	jr $ra
	


isValidJump:
    addi $sp,$sp,-4
    mov $s3,$sp
    sw $ra,0($s3)
	
    lw $a1,12($s1)
    lw $a2,8($s1)
    
    jal isLegalPosition
    
    beqz $v0,returnjump
    
    mov $t4,$a1                 #t4 contains r1
    mov $t5,$a2                 #t5 contains c1
    
    lw $a1,4($s1)
    lw $a2,0($s1)
    
    jal isLegalPosition
    
    beqz $v0,returnjump
    
    mov $t6,$a1                 #t6 contains r2
    mov $t7,$a2                 #t7 contains c2
    
    lw $ra,0($s3)
	
    add $s6,$t4,$t6
    div $s6,2
    mflo $s6                    #s6 contains rm
    
    add $s7,$t5,$t7                 
    div $s7,2
    mflo $s7                    #s7 contains cm
    
    #t0 = board[rm][cm]
    mul $s6,$s6,10
    add $s6,$s6,$s7
    sll $s7,$s6,2
    add $s7,$s7,$s0
    lw  $t0,0($s7)
   
    sub $t8,$t4,$t6
    abs $s4,$t8
    sub $t9,$t5,$t7
    abs $s5,$t9
  
    #t1 = board[r1][c1]
    mul $t4,$t4,10
    add $t4,$t4,$t5
    sll $t5,$t4,2
    add $t5,$t5,$s0
    lw  $t1,0($t5)
    
    
    #t2 = board[r2][c2]
    mul $t6,$t6,10
    add $t6,$t6,$t7
    sll $t7,$t6,2
    add $t7,$t7,$s0
    lw  $t2,0($t7)
    
    
    beq $t1,1,redgamepiece
    beq $t1,3,whitegamepiece
    beq $t1,5,redking
    beq $t1,7,whiteking
    beq $t1,0,returnjump
    
redgamepiece:
    bne $t8,-2,returnjump
    bne $s5,2,returnjump
    bne $t2,0,returnjump
    beq $t0,1,returnjump
    beq $t0,5,returnjump
    beq $t0,0,returnjump
    
    li $v1,1
    
    jr $ra

redking:
	
    bne $s4,2,returnjump
    bne $s5,2,returnjump
    bne $t2,0,returnjump
    beq $t0,1,returnjump
    beq $t0,5,returnjump
    beq $t0,0,returnjump
    
    li $v1,1
    
    jr $ra
    
whitegamepiece:
    bne $t8,2,returnjump
    bne $s5,2,returnjump
    bne $t2,0,returnjump
    beq $t0,3,returnjump
    beq $t0,7,returnjump
    beq $t0,0,returnjump    
    
    li $v1,1
    
    jr $ra
    
whiteking:
    bne $s4,2,returnjump
    bne $s5,2,returnjump
    bne $t2,0,returnjump
    beq $t0,3,returnjump
    beq $t0,7,returnjump
    beq $t0,0,returnjump
    
    li $v1,1
    
    jr $ra 
    
returnjump:
    lw $ra,0($s3)
    mov $v1,$zero
    jr $ra

	
err:
	la $a0,er
	syscall $print_string
	j mainloop
	
reset:
	mov $t0,$zero
	mov $t1,$zero
	mov $t2,$zero
	mov $t3,$zero
	mov $t4,$zero
	mov $t5,$zero
	mov $t6,$zero
	mov $t7,$zero
	mov $t8,$zero
	mov $t9,$zero
	
	mov $s2,$zero
	mov $s3,$zero
	mov $s4,$zero
	mov $s5,$zero
	mov $s6,$zero
	mov $s7,$zero
	
	jr $ra
	
isValidMove:
    addi $sp,$sp,-4
    mov $s3,$sp
    sw $ra,0($s3)
    
    lw $a1,12($s1)
    lw $a2,8($s1)
    
    jal isLegalPosition
    
    beqz $v0,returnmove
    
    mov $t4,$a1                 #t4 contains r1
    mov $t5,$a2                 #t5 contains c1
    
    lw $a1,4($s1)
    lw $a2,0($s1)
    
    jal isLegalPosition
    
    beqz $v0,returnmove
    
    mov $t6,$a1                 #t6 contains r2
    mov $t7,$a2                 #t7 contains c2
    
    lw $ra,0($s3)
    
    sub $t8,$t4,$t6
    abs $s4,$t8
    sub $t9,$t5,$t7
    abs $s5,$t9
  
    #t1 = boeard[r1][c1]
    mul $t4,$t4,10
    add $t4,$t4,$t5
    sll $t5,$t4,2
    add $t5,$t5,$s0
    lw  $t1,0($t5)
   
    
    #t2 = board[r2][c2]
    mul $t6,$t6,10
    add $t6,$t6,$t7
    sll $t7,$t6,2
    add $t7,$t7,$s0
    lw  $t2,0($t7)
   
    
    beq $t1,1,rgp
    beq $t1,3,wgp
    beq $t1,5,rking
    beq $t1,7,wking
    beq $t1,0,returnmove
    
rgp:
    bne $t8,-1,returnmove
    bne $s5,1,returnmove
    bne $t2,0,returnmove
    
    li $v0,1
    
    jr $ra

rking:
    bne $s4,1,returnmove
    bne $s5,1,returnmove
    bne $t2,0,returnmove
    
    li $v0,1
    
    jr $ra
    
wgp:
    bne $t8,1,returnmove
    bne $s5,1,returnmove
    bne $t2,0,returnmove
    
    li $v0,1
    
    jr $ra
    
wking:
    bne $s4,1,returnmove
    bne $s5,1,returnmove
    bne $t2,0,returnmove
    
    li $v0,1
    
    jr $ra 
    
returnmove:
    lw $ra,0($s3)
    mov $v0,$zero
    jr $ra
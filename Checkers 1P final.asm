   .data
nl:     .asciiz "\n"
rs:     .asciiz "Source Row: "
cs:     .asciiz "Source Column: "
rd:     .asciiz "Destination Row: "
cd:     .asciiz "Destinatin Column: "
fi:     .asciiz "Found it!"
nf:     .asciiz "Not Found!"
rw:     .asciiz "Red Won"
ww:     .asciiz "White Won"
ex:     .asciiz "Exiting"
erm:    .asciiz "Error: Invalid jump or move"
tp:     .asciiz "The possible moves are"
tb:     .asciiz "\t"
    .globl main
    
    .code
main:

    addi $sp,$sp,-400
    mov $s0,$sp
    addi $sp,$sp,-20
    mov $s1,$sp
    addi $sp,$sp,-8
    mov $k1,$sp
    addi $sp,$sp,-384
    mov $fp,$sp
    #-----Set Board----------------
    
    mov $t0,$zero
    
    j setlooptest
    
setloop:
    sll $t2,$t0,2
    add $t2,$t2,$s0
    sw $zero,0($t2)
    addi $t0,$t0,1
    
setlooptest:
    blt $t0,100,setloop
    
    li $t9,1
    li $t1,0
    mov $t2,$zero
    
    j setredouttest

setredout:  
    mov $t2,$zero
    
    j setredintest
    
setredin:
    
    mul $t3,$t1,10
    add $t3,$t3,$t2
    mul $t3,$t3,4
    
    add $t3,$t3,$s0
    
    mov $a1,$t1
    mov $a2,$t2
    
    jal isLegalPosition
    
    beq $v0,1,setred
    
    j addtocol
    
setred:
    sw $t9,0($t3)
    
addtocol:
    addi $t2,$t2,1
    
setredintest:
    blt $t2,10,setredin
    
    addi $t1,$t1,1

setredouttest:
    ble $t1,2,setredout
    
    li $t9,3
    li $t1,7
    mov $t2,$zero

    
    j setwhiteouttest

setwhiteout:  
    mov $t2,$zero
    
    j setwhiteintest
    
setwhitein:
    
    mul $t3,$t1,10
    add $t3,$t3,$t2
    mul $t3,$t3,4
    
    add $t3,$t3,$s0
    
    mov $a1,$t1
    mov $a2,$t2
    
    jal isLegalPosition
    
    beq $v0,1,setwhite
    
    j addtocol2
    
setwhite:
    sw $t9,0($t3)
    
addtocol2:
    addi $t2,$t2,1
    
setwhiteintest:
    blt $t2,10,setwhitein
    
    addi $t1,$t1,1

setwhiteouttest:
    ble $t1,9,setwhiteout
    
    mov $s3,$zero
    mov $t3,$zero
    mov $t6,$zero
    mov $t4,$zero
    
    mov $t0,$zero
    
    li $t0,15
    sw $t0,4($k1)                               #red count
    sw $t0,0($k1)                               #white count
    
    li $k0,0                                    #CurrColor - 0 //red

    li $t0,7
    sw $t0,220($s0)
    #-----Loop to ask for numbers and set in board---------
    
    
mainloop:
    jal displayboard
    li $t9,0x1
    
    beqz $k0,askuser
    beq $k0,1,askcomp

askuser:
    la $a0,rs
    syscall $print_string
    syscall $read_int
    sw $v0,12($s1)
    
    la $a0,cs
    syscall $print_string
    syscall $read_int
    sw $v0,8($s1)
    
    la $a0,rd
    syscall $print_string
    syscall $read_int
    sw $v0,4($s1)
    
    la $a0,cd
    syscall $print_string
    syscall $read_int
    sw $v0,0($s1)
    
    j nextmain
    
askcomp:
    jal getvalidjumps
 
    mov $t4,$v0
    
    beqz $t4,trymovesforcomp
    
    j tryjumps
    
trymovesforcomp:
    jal getvalidmoves
    
    mov $s7,$zero
    
    mul $t5,$s7,4
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    lw $a0,0($t6)
    sw $a0,12($s1)
    
    mul $t5,$s7,4
    addi $t5,$t5,1
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    lw $a0,0($t6)
    sw $a0,8($s1)
    
    
    mul $t5,$s7,4
    addi $t5,$t5,2
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    lw $a0,0($t6)
    sw $a0,4($s1)

    
    mul $t5,$s7,4
    addi $t5,$t5,3
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    lw $a0,0($t6)
    sw $a0,0($s1)
    
    la $a0,nl
    syscall $print_string
    jal printtuples
    jal executemove
    
    #jal displayboard
    
tryjumps:
    mov $s7,$zero
    
    mul $t5,$s7,4
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    lw $a0,0($t6)
    sw $a0,12($s1)
    
    mul $t5,$s7,4
    addi $t5,$t5,1
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    lw $a0,0($t6)
    sw $a0,8($s1)
    
    
    mul $t5,$s7,4
    addi $t5,$t5,2
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    lw $a0,0($t6)
    sw $a0,4($s1)

    
    mul $t5,$s7,4
    addi $t5,$t5,3
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    lw $a0,0($t6)
    sw $a0,0($s1)
    
    la $a0,nl
    syscall $print_string
    jal printtuples
    jal executejump
    
    j exit
    
nextmain:
    lw $t1,12($s1)
    lw $t2,8($s1)
    
    mul $t1,$t1,10
    add $t1,$t1,$t2
    mul $t1,$t1,4
    add $t1,$t1,$s0
    lw $t1,0($t1)
    srl $t1,$t1,1
    and $t1,$t1,$t9
    
    beq $t1,$k0,checkforjump
secondcheck:
    lw $t1,12($s1)
    lw $t2,8($s1)
    
    mul $t1,$t1,10
    add $t1,$t1,$t2
    mul $t1,$t1,4
    add $t1,$t1,$s0
    lw $t1,0($t1)
    srl $t1,$t1,1
    and $t1,$t1,$t9
    
    beq $t1,$k0,checkformove
    
ifinvalidthencontinue:
    j err
    
changecolor:
    beqz $k0,changered
    beq $k0,1,changewhite
    
changered:
    li $k0,1
    
    j mainloop
    
changewhite:
    li $k0,0
    
    j mainloop
    
checkformove:
    jal isValidMove
    
    beq $v0,1,executemove
    
    j ifinvalidthencontinue
    
executemove:
    lw $t0,12($s1)
    lw $t1,8($s1)
    
    mul $t0,$t0,10
    add $t0,$t0,$t1
    mul $t0,$t0,4
    add $t0,$t0,$s0
    
    lw $t2,0($t0)
    
    sw $zero,0($t0)
    
    lw $t3,4($s1)
    lw $t4,0($s1)
    
    mul $t3,$t3,10
    add $t3,$t3,$t4
    mul $t3,$t3,4
    add $t3,$t3,$s0
    
    sw $t2,0($t3)
    
    mov $a0,$k0
    lw $a1,4($s1)
    
    jal checkforking
    
    j changecolor
    
    j exit
    
    
    
checkforjump:
    jal isValidJump
    
    beq $v0,1,executejump

    j secondcheck
    
executejump:
    lw $t0,12($s1)
    lw $t1,8($s1)
    
    mul $t0,$t0,10
    add $t0,$t0,$t1
    mul $t0,$t0,4
    add $t0,$t0,$s0
    
    lw $t2,0($t0)
    
    sw $zero,0($t0)
    
    lw $t3,4($s1)
    lw $t4,0($s1)
    
    mul $t3,$t3,10
    add $t3,$t3,$t4
    mul $t3,$t3,4
    add $t3,$t3,$s0
    
    sw $t2,0($t3)
    li $t9,2
    
    lw $t0,12($s1)                              #r1
    lw $t1,8($s1)                               #c1
    lw $t2,4($s1)                               #r2
    lw $t3,0($s1)                               #c2
    
    add $t0,$t0,$t2
    div $t0,$t9
    mflo $t0                                    #rm
    
    add $t1,$t1,$t3
    div $t1,$t9
    mflo $t1                                    #cm
    
    mul $t0,$t0,10
    add $t0,$t0,$t1
    mul $t0,$t0,4
    add $t0,$t0,$s0
    
    sw $zero,0($t0)
    
    beqz $k0,decrementwhite
    beq $k0,1,decrementred
    
    j nextpart
    
decrementwhite:
    lw $t8,0($k1)
    addi $t8,$t8,-1
    sw $t8,0($k1)
    
    j nextpart

decrementred:
    lw $t8,4($k1)
    addi $t8,$t8,-1
    sw $t8,4($k1)
    
    j nextpart

nextpart:    
    
    mov $a0,$k0
    lw $a1,4($s1)
   
    jal checkforking
    
    lw $t8,4($k1)
    beqz $t8,printexit
    
    lw $t8,0($k1)
    beqz $t8,printexit
    
    j changecolor
    
    
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
    lw  $s4,0($s2)
    
    beq $s4,3,w
    beq $s4,1,r
    beq $s4,7,bigW
    beq $s4,5,bigR
    
    
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
	
	li $t8,2
	li $s4,9
	
    add $t7,$a1,$a2
	div $t7,$t7,$t8
	mfhi $t7
	
	bnez $t7,return
	
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
    mov $v0,$zero
    jr $ra
    
checkforking:
    #currcolor = a0, r2 = a1
    beq $a0,1,checkforwhiteking
    beq $a0,0,checkforredking
    
    jr $ra
    
checkforwhiteking:
    beq $a1,0,promotewhite
    jr $ra
    
promotewhite:
    li $s5,7
    lw $a2,0($s1)
    mul $a1,$a1,10
    add $a1,$a1,$a2
    mul $a1,$a1,4
    add $a1,$a1,$s0
    
    sw $s5,0($a1)
    
    jr $ra
    
checkforredking:
    beq $a1,7,promotered
    jr $ra

promotered:
    li $s5,5
    lw $a2,0($s1)
    mul $a1,$a1,10
    add $a1,$a1,$a2
    mul $a1,$a1,4
    add $a1,$a1,$s0
    
    sw $s5,0($a1)
    
    jr $ra
    
printexit:
    la $a0,ex
    syscall $print_string
    la $a0,nl
    syscall $print_string
    
    
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

err:
    la $a0,erm
    syscall $print_string
    la $a0,nl
    syscall $print_string
    
    j mainloop
    
getvalidmoves:
    addi $sp,$sp,-4
    sw $ra,0($sp)
    mov $a3,$sp
    
    mov $t0,$zero               #t0 = r1
    li  $t1,-1                  #t1 = r2
    mov $t2,$zero               #t2 = c1
    li  $t3,-1                  #t3 = c2
    mov $t4,$zero               #t4 = total
    
    li $t5,0                    #t5 = idxr1
    li $t6,0                    #t6 = idxc1
    #li $t8,1
    
    j forloop1test
    
forloop1:
    mov $t2,$zero
    
    j forloop2test
    
forloop2:
    addi $s6,$t0,1
   
    addi $t1,$t0,-1
    mov $t8,$k0
    mul $t7,$t0,10
    add $t7,$t7,$t2
    mul $t7,$t7,4
    add $t7,$t7,$s0
    lw $t7,0($t7)
    
    beq $t8,0,checkforred
    beq $t8,1,checkforwhite
    
    
checkforred:
    beq $t7,1,forloop3test
    beq $t7,5,forloop3test
    
    j addtoforloop2
    
checkforwhite:
    beq $t7,3,forloop3test
    beq $t7,7,forloop3test
    
    j addtoforloop2
    
forloop3:
    addi $t3,$t2,-1
    addi $s2,$t2,1
    
    
    
    j forloop4test

forloop4:

   

   sw $t0,12($s1)
   sw $t2,8($s1)
   sw $t1,4($s1)
   sw $t3,0($s1)
   sw $t4,16($s1)
  
   jal isValidMove
   
   lw $t0,12($s1)
   lw $t2,8($s1)
   lw $t1,4($s1)
   lw $t3,0($s1)
   lw $t4,16($s1)
 
   beq $v0,1,into
   j nextloop4

into:

    mul $t5,$t4,4
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    sw $t0,0($t6)
    
    mul $t5,$t4,4
    addi $t5,$t5,1
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    sw $t2,0($t6)
    
    mul $t5,$t4,4
    addi $t5,$t5,2
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    sw $t1,0($t6)
    
    mul $t5,$t4,4
    addi $t5,$t5,3
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    sw $t3,0($t6)
    
    addi $t4,$t4,1
    
    beq $t4,24,returnfunc
    
nextloop4:
     addi $t3,$t3,2
    
forloop4test:
    ble $t3,$s2,forloop4
    
    addi $t1,$t1,2
    
forloop3test:
    ble $t1,$s6,forloop3
    
addtoforloop2:    
    addi $t2,$t2,1
    
forloop2test:
    blt $t2,10,forloop2
    
    
    addi $t0,$t0,1
    
forloop1test:
    blt $t0,10,forloop1
    
returnfunc:
    mov $v0,$t4
    
    lw $ra,0($a3)
    jr $ra


    
printtuples:
    mov $s7,$zero
    j forlooptest
    
forloop:
    mov $a0,$s7
    syscall $print_int
    
    la $a0,tb
    syscall $print_string
    
    mul $t5,$s7,4
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    lw $a0,0($t6)
    
    syscall $print_int
    
    mul $t5,$s7,4
    addi $t5,$t5,1
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    lw $a0,0($t6)
    
    syscall $print_int
    
    mul $t5,$s7,4
    addi $t5,$t5,2
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    lw $a0,0($t6)
    
    syscall $print_int
    
    mul $t5,$s7,4
    addi $t5,$t5,3
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    lw $a0,0($t6)
    
    syscall $print_int
    
    la $a0,nl
    syscall $print_string
    
    addi $s7,$s7,1
forlooptest:
    blt $s7,$t4,forloop
    
    jr $ra
    
getvalidjumps:

    addi $sp,$sp,-4
    sw $ra,0($sp)
    mov $a3,$sp
   
    mov $t0,$zero               #t0 = r1
    li  $t1,-1                  #t1 = r2
    mov $t2,$zero               #t2 = c1
    li  $t3,-1                  #t3 = c2
    mov $t4,$zero               #t4 = total
    
    li $t5,0                    #t5 = idxr1
    li $t6,0                    #t6 = idxc1
 
    
    j fl1test
    
fl1:
    mov $t2,$zero
    
    j fl2test
    
fl2:
    addi $t3,$t2,-2
    addi $s6,$t0,2
    addi $t1,$t0,-2
    mov $t8,$k0
    mul $t7,$t0,10
    add $t7,$t7,$t2
    mul $t7,$t7,4
    add $t7,$t7,$s0
    lw $t7,0($t7)
    
    beq $t8,0,cfred
    beq $t8,1,cfwhite
    
    
cfred:
    beq $t7,1,fl3test
    beq $t7,5,fl3test
    
    j addtofl2
    
cfwhite:
    beq $t7,3,fl3test
    beq $t7,7,fl3test
    
    j addtofl2
    
fl3:
     addi $s2,$t2,2
    
    j fl4test

fl4:
   
   sw $t4,16($s1)
   sw $t0,12($s1)
   sw $t2,8($s1)
   sw $t1,4($s1)
   sw $t3,0($s1)  
  
   jal isValidJump
   
   lw $t4,16($s1)
   lw $t0,12($s1)
   lw $t2,8($s1)
   lw $t1,4($s1)
   lw $t3,0($s1)  
   
   addi $s6,$t0,2
 
 
   beq $v0,1,into2
   j nextl4

into2:
    mul $t5,$t4,4
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    sw $t0,0($t6)
    
    mul $t5,$t4,4
    addi $t5,$t5,1
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    sw $t2,0($t6)
    
    mul $t5,$t4,4
    addi $t5,$t5,2
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    sw $t1,0($t6)
    
    mul $t5,$t4,4
    addi $t5,$t5,3
    
    mul $t5,$t5,4
    
    add $t6,$t5,$fp
    sw $t3,0($t6)
    
    addi $t4,$t4,1
    
    beq $t4,24,returnfunc2
    
nextl4:
     addi $t3,$t3,2
    
fl4test:
    ble $t3,$s2,fl4
    
    addi $t1,$t1,2
    
fl3test:
    ble $t1,$s6,fl3
    
addtofl2:
    addi $t2,$t2,1
    
fl2test:
    blt $t2,10,fl2
    
    
    addi $t0,$t0,1
    
fl1test:
    blt $t0,10,fl1
    
returnfunc2:
    mov $v0,$t4
    
    lw $ra,0($a3)
    jr $ra
    

exit:
    syscall $exit
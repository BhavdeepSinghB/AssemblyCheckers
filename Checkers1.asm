    .data
row:    .asciiz "Row: "
col:    .asciiz "Column: "
val:    .asciiz "Value: "
nl:     .asciiz "\n"
    .globl main
    
    .code
main:

    addi $sp,$sp,-400
    
    #-----Set Board----------------
    mov $s0,$sp
    mov $t1,$zero
    mov $s5,$zero
    
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
    
    beq $t3,-1,exit
    
    la $a0,col
    syscall $print_string
    syscall $read_int
    mov $t6,$v0                         #t6 contains column number
    
    la $a0,val
    syscall $print_string
    syscall $read_int
    mov $t4,$v0                         #t4 contains value
    
    mul $t3,$t3,10
    add $t3,$t3,$t6
    
    sll $t2,$t3,2                       
    add $t2,$t2,$s0                     #stores value of t4 into the position given in t3 in the array
    sw $t4,0($t2)
    
    addi $s3,$s3,1
    
mainlooptest:
    bne $s3,10,mainloop
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
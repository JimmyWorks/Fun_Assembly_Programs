.data
	welcome: .asciiz "Welcome to Jimmy's Subtraction Calculator\n"
	askInt1: .asciiz "Enter the first integer: "
	askInt2: .asciiz "Enter the second integer: "
	printResult: .asciiz "The difference between A and B (A - B) is "
	.align 2
	A: .word 1 #Label for first integer
	B: .word 2 #Label for second integer
	D: .word 3 #Label for the calculated difference
	
	
.text
	#Print welcome message
	li $v0, 4
	la $a0, welcome
	syscall
	
	#Prompt the user for one integer
	li $v0, 4
	la $a0, askInt1
	syscall
	
	#Get the first integer
	li $v0, 5
	syscall
	
	#Store the result in A
	sw $v0, A
	
	#Prompt the user for one integer
	li $v0, 4
	la $a0, askInt2
	syscall
	
	#Get the second integer
	li $v0, 5
	syscall
	
	#Store the result in B
	sw $v0, B
	
	#Load integer A into $t0
	lw $t0, A
	
	#Load integer B into $t1
	lw $t1, B
	
	#Take the difference between A - B and store in $t3
	sub $t3, $t0, $t1
	
	#Store integer in $t3 into integer D
	sw $t3, D
	
	#Print the resulting message
	li $v0, 4
	la $a0, printResult
	syscall
	
	#Print the resulting value from D
	li $v0, 1
	lw $a0, D
	syscall

	#Close the program
	li $v0, 10
	syscall
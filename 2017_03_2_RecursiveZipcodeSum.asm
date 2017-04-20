
.data	

WelcomeMsg:	.asciiz			"Welcome to Jimmy's Recursive Zipcode Calculator.\nWhat's the sum of your zipcode?\n\n"
UserPrompt:	.asciiz			"Please enter a zipcode: \n"
ResultMsg:	.asciiz			"The sum of the integers in your zipcode is: "
newline:	.asciiz			"\n"
	
		.globl	main
		
.text		

main:
	jal	Welcome			#routine prints welcome message
	jal	UserInput		#routine prints user prompt and takes user input (stored in $s0)
	jal	SumZipcode		#routine recursively calculates the sum, digit by digit (stored sum in $s0)
	jal	PrintResult		#routine prints result message and sum
	j	Exit			#successfully exit

Welcome: # print welcome message
	li	$v0, 4			#system call for Print String
	la	$a0, WelcomeMsg		#load address of WelcomeMsg String
	syscall				#print Welcome message
	jr	$ra			#return to main

UserInput: # ask for a zipcode
	li	$v0, 4			#system call code for Print String
	la	$a0, UserPrompt 	#load address of UserPrompt String
	syscall				#print to prompt user for zipcode	
	  # read the integer
	li	$v0, 5			#system call to read integer
	syscall				#read and store in $v0
	
	add 	$s0, $v0, $0		#store zipcode integer in $s0
	jr	$ra			#return to main
	
SumZipcode:
RecursiveStep: # recursive call to sum zipcode integers
	slti	$t0, $s0, 10		#if current number is less than 10
	bne	$t0, $0, BasisStep	#branch to apply the basis step
	
	addi	$t0, $0, 10		#$t0 = 10
	div	$s0, $t0		#HI = $s0/10, LO = $s0%10
	mflo	$s0			#move LO (quotient) to $t1
	mfhi	$t2			#move HI (remainder) to $t2
	add	$sp, $sp, -8		#move stack pointer for two items (words)
	sw	$ra, 0($sp)		#store return address in stack at $sp
	sw	$t2, 4($sp)		#store remainder in stack at $sp + 4
	jal	RecursiveStep		#recursively call with new quotient in $s0
	
	# returning from recursive subroutine...
	# take values stored in stack and move stack pointer
	lw	$ra, 0($sp)		#load $ra for the caller
	lw	$t2, 4($sp)		#load last remainder
	add	$sp, $sp, 8		#move stack pointer back, pop 2 items
	# do the math
	add	$s0, $s0, $t2		#add remainder to sum
	jr	$ra			#jump return to previous recursive call or main if last recursive application
	
BasisStep: # basis step	
	jr	$ra			#jump return to main if one digit or previous recursive call

PrintResult:

	li	$v0, 4			#system call code for Print String
	la	$a0, ResultMsg 		#load address of Result String
	syscall				#print to show result message
	
	li	$v0, 1			#system call code to print integer
	add	$a0, $s0, $0		#store sum in $a0
	syscall				#print integer
	
	jr	$ra			#return to main


Exit:
	li	$v0, 17			#system call for ending program
	la	$a0, 0			#load value of 0 for success
	syscall				#end program

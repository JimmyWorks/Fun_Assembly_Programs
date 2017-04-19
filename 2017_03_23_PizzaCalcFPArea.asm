.data

small_pizza_rad:	.word	5 	#small pizza radius in inches
large_pizza_rad:	.word	8	#large pizza radius in inches
number_of_slices:	.float	8.0	#number of slices pizza is cut
pi:			.float	3.14159 #value of pi to 5 decimal places
round:			.float  100	#for rounding

welcome_msg:		.asciiz	"\n\nWelcome to Jimmy's Pizza Consumption Calculator!\n\n"
select_pizza_msg:	.asciiz	"Which pizza do you want to eat today?\n\nSelect from the following:\n\n1 - Small 10\" pizza\n2 - Large 16\" pizza\n3 - Exit\n\n>> "
selected_small_msg:	.asciiz "\nYou selected the small pizza!\n"
selected_large_msg:	.asciiz "\nYou selected the large pizza!\n"
error_select_msg:	.asciiz "You can only select a small or large pizza.\n\n"
eat_slices_msg:		.asciiz	"The pizza is cut into 8 slices...\n\nHow many slices do you want to eat?\n\n>> "
eaten_msg:		.asciiz "\nYou eat "
slices_msg:		.asciiz " slices...\n\n"
result_msg:		.asciiz	"That's this many square inches of pizza eaten: "
eat_error_msg:		.asciiz	"You cannot eat that many slices!  There are 1-8 slices of pizza.\nHow many slices do you want to eat?\n\n>> "
area_eat_msg:		.asciiz "You ate "
sq_in_msg:		.asciiz " square inches of pizza!\n\n"

debug:			.asciiz "Debug value: "
exit_msg:		.asciiz "\n\nThank you for visiting!\n\nFor all questions, contact me at:\n\n===============\n\nJimmy Nguyen\nJimmy@JimmyWorks.net\n\n===============\n"


.text
	l.s	$f3, pi			#store pi value in $f3
	l.s	$f8, number_of_slices	#store number of slices pizza is cut in $f8
	l.s	$f10, round		#store 10*n in $f10, where n is the number of decimal places for rounding

Main:

	jal	MainMenu		#ask for pizza selection
	jal	EatPizza		#ask for slices eaten
	jal	Calculate		#calculate sq inches eaten and print
	
	j	Main			#loop back to main menu until exit is selected

#====== Notes  =========================================================================
#	Register	Stored Value
#
#	$s0 		Selected Pizza Radius
#	$s1		Slices Selected
#=======================================================================================
MainMenu:

	li	$v0, 4			#print welcome message
	la	$a0, welcome_msg  	#load address 
	syscall				#print 
	
SelectPizza:
	li	$v0, 4			#print message to prompt for correct size pizza
	la	$a0, select_pizza_msg  	#load address 
	syscall				#print
	
	li	$v0, 5			#read the int
	syscall				#read user input
	
	beq	$v0, 1, SelectedSmall	#if small, branch to store value in radius in memory
	beq	$v0, 2, SelectedLarge	#if large, branch to store value in radius in memory
	beq	$v0, 3, EndProgram	#if exiting, branch to exit program
	
SelectionError:
	
	li	$v0, 4			#print invalid selection message
	la	$a0, error_select_msg  	#load address 
	syscall				#print
	
	j	SelectPizza		#jump back to select valid size
	
SelectedSmall:
	lw	$s0, small_pizza_rad	#store small pizza radius into selected pizza radius, $s0
	li	$v0, 4			#print small selection message
	la	$a0, selected_small_msg #load address 
	syscall				#print
	
	jr	$ra			#return to main	
SelectedLarge:
	lw	$s0, large_pizza_rad	#store large pizza radius into selected pizza radius, $s0
	
#For Debugging =========================================
#	li	$v0, 4			#print small selection message
#	la	$a0, debug		 #load address 
#	syscall	
#	
#	li	$v0, 1			#print small selection message
#	add	$a0, $s0, $0		 #load address 
#	syscall	
#=======================================================
	
	li	$v0, 4			#print large selection message
	la	$a0, selected_large_msg #load address 
	syscall				#print
	
	jr	$ra			#return to main

EatPizza:
	li	$v0, 4			#print eat message
	la	$a0, eat_slices_msg 	#load address 
	syscall				#print	
	RetryEat:
	li	$v0, 5			#system call code for Read Integer
	syscall				#Read user input
	
	beq	$v0, 0, Eaten		#User can decide to not eat any slices
	beq	$v0, 1, Eaten		#User must select to eat 1-8 slices
	beq	$v0, 2, Eaten		#User must select to eat 1-8 slices
	beq	$v0, 3, Eaten		#User must select to eat 1-8 slices
	beq	$v0, 4, Eaten		#User must select to eat 1-8 slices
	beq	$v0, 5, Eaten		#User must select to eat 1-8 slices
	beq	$v0, 6, Eaten		#User must select to eat 1-8 slices
	beq	$v0, 7, Eaten		#User must select to eat 1-8 slices
	beq	$v0, 8, Eaten		#User must select to eat 1-8 slices
	
EatError:
	
	li	$v0, 4			#print invalid number of slices message
	la	$a0, eat_error_msg  	#load address 
	syscall				#print
	
	j	RetryEat		#jump to try for correct slice amount again
	
Eaten:
	add	$s1, $v0, $0		#store integer in $s1
	
	li	$v0, 4			#print number of slices eaten message
	la	$a0, eaten_msg 		#load address 
	syscall				#print	
	
	li	$v0, 1			#print large selection message
	add	$a0, $s1, $0 		#load number of slices 
	syscall				#print			
							
	li	$v0, 4			#print remaining message
	la	$a0, slices_msg 	#load address 
	syscall				#print

	jr	$ra			#jump back to main
																								
Calculate:
	
	mtc1	$s0, $f0		#move radius binary to fp register $f0
	mtc1	$s1, $f1		#move number of slices binary eaten to fp register $f1
	cvt.s.w $f0, $f0		#convert binary to single precision fp
	cvt.s.w $f1, $f1		#convert binary to single precision fp
	
	mul.s	$f0, $f0, $f0		#multiply: radius*radius = r^2
	mul.s	$f0, $f0, $f3		#multiply: r^2 * pi = area
	
	div.s	$f0, $f0, $f8		#divide area by number of slices = area per slice
	mul.s	$f0, $f0, $f1		#multiply area per slice * number of slices eaten
	
	mul.s	$f0, $f0, $f10		#multiply by magnitude of rounding
	round.w.s $f0, $f0		#round to word
	cvt.s.w	$f0, $f0		#convert word to single precision fp
	div.s	$f0, $f0, $f10		#divide by magnitude of rounding
	
	li	$v0, 4			#print result
	la	$a0, area_eat_msg  	#load address 
	syscall				#print
	
	li	$v0, 2			#print value of sq inches
	mtc1	$0, $f12		#clear $f12, in case used prior
	add.s	$f12, $f0, $f30		#load value
	syscall				#print
	
	
	li	$v0, 4			#print remaining message for sq in result
	la	$a0, sq_in_msg  	#load address 
	syscall				#print
	
	jr	$ra			#jump back to main
	
EndProgram:	
	li	$v0, 4			#print exit message
	la	$a0, exit_msg  		#load address 
	syscall				#print
	
	li      $v0, 10              	# terminate program run
  	syscall                      	# Exit
	

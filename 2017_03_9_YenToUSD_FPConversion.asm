	.data

DefaultRate:	.float		112
MenuDisplay:	.asciiz		"\n\n=== Welcome to Jimmy's US/Japan Currency Converter ===\n\nPlease select from the following options:\n\n1 - Set US/Japan exchange rate\n2 - Convert US dollars to Japanese Yen\n3 - Convert Japanese Yen to US dollars\n4 - Exit Program\n\n"
InvalidMsg:	.asciiz		"\nYou selected an invalid option.\nPlease try again...\n"
SetRateMsg:	.asciiz		"Setting the exchange rate\n\nEnter the current exchange rate in Japanese Yen per US dollar:\n\n"
RateSetMsg:	.asciiz		"\nThe rate is now set to (yen/USD): "
ConvertToJPMsg:	.asciiz		"\nType the number of US dollars to convert to Japanese yen:\n\n"
ToYenResult:	.asciiz		"\nThe result in Japanese yen: ¥"
ConvertToUSMsg:	.asciiz		"\nConverting the yen to dollars here...\n"
ToUSDResult:	.asciiz		"\nThe result in US dollars: $"
ExitMsg:	.asciiz		"Ending program...\n"
	.global Main
	.text

Main:
	l.s	$f1, DefaultRate	#Set default conversion rate to 112 yen per $USD

	li 	$v0, 4			#Print menu options for the user
	la 	$a0, MenuDisplay	#Load message
	syscall				#Print
	
	li 	$v0, 5			#Get the input
	syscall				
	
	#Compare selection to branch to correct selection
	beq	$v0, 1, SetRate		# 1 = setting exchange rate
	beq	$v0, 2, ConvertToJP	# 2 = conversion from yen to USD
	beq	$v0, 3, ConvertToUS	# 3 = conversion from USD to yen
	beq	$v0, 4, Exit		# 4 = exit the program
	
	li 	$v0, 4			#Print invalid selection
	la 	$a0, InvalidMsg		#Load message
	syscall				#Print
	j	Main			#Invalid selection loops back to main

SetRate:

	li 	$v0, 4			#Ask for input to overwrite the exchange rate
	la 	$a0, SetRateMsg		#Load message
	syscall				#Print
	
	li 	$v0, 6			#Get the input float with result in $f0
	syscall
	add.s	$f1, $f0, $f31		#overwrite conversion rate in $f1
	
	li 	$v0, 4			#Print the confirmation of new exchange rate
	la 	$a0, RateSetMsg		#Load message
	syscall				#Print
	
	li 	$v0, 2			#Print new exchange rate
	add.s	$f12, $f1, $f31		#Load value	
	syscall				#Print
	
	j	Main			#Return to main menu
	
ConvertToJP:

	li 	$v0, 4			#Print message to get USD to convert to yen
	la 	$a0, ConvertToJPMsg	#Load message
	syscall				#Print
	
	li 	$v0, 6			#Get the input float with result in $f0
	syscall
	mul.s	$f0, $f0, $f1		#Multiply USD by yen/USD to get value in yen
	
	li	$v0, 4			#Print message to show yen result
	la	$a0, ToYenResult	#Load message
	syscall				#Print
	
	li	$v0, 2			#Print yen result
	add.s	$f12, $f0, $f31		#Load result
	syscall				#Show result
	
	j	Main			#Return to main menu
	
ConvertToUS:

	li 	$v0, 4			#Print message to get yen to convert to USD
	la 	$a0, ConvertToUSMsg	#Load the message
	syscall				#Print
	
	li 	$v0, 6			#Get the input float with result in $f0
	syscall
	div.s	$f0, $f0, $f1		#Divide yen by yen/USD to get value in USD
	
	li	$v0, 4			#Print message to show USD result
	la	$a0, ToUSDResult	#Load the message
	syscall				#Print
	
	li	$v0, 2			#Print USD result
	add.s	$f12, $f0, $f31		#Load result
	syscall				#Show result
	
	j	Main			#Return to main menu

Exit:
	li 	$v0, 4			#Print exit message
	la 	$a0, ExitMsg		#Load message
	syscall				#Print
	
	#Close the program
	li $v0, 10
	syscall

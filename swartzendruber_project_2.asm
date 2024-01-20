# Name: Travis Swartzendruber

# All memory structures are placed after the
# .data assembler directive
.data
generated:			.word 0, 0, 0   # These numbers will be randomly generated (1 ~ 9)
input:				.word 0, 0, 0	# These numbers will be user's inputs (1 ~ 9)
string_generated:		.asciiz "Generated Numbers: "
string_input_prompt:		.asciiz "Input numbers:\n"
input_buffer:			.space 50
string_out_of_range:		.asciiz "Input must be between 1 and 9.\n"
string_duplicates:		.asciiz "You cannot input duplicated numbers.\n"
string_win:			.asciiz "Good Job! Do you want to play again (Y/N)? "
string_out:			.asciiz "Out\n"
string_1_ball:			.asciiz "1 ball\n"
string_2_balls:			.asciiz "2 balls\n"
string_3_balls:			.asciiz "3 balls\n"
string_1_strike:		.asciiz "1 strike\n"
string_2_strikes:		.asciiz "2 strikes\n"
string_1_ball_1_strike:		.asciiz "1 ball, 1 strike\n"
string_2_balls_1_strike:	.asciiz "2 balls, 1 strike\n"

# Declare main as a global function
.globl main 

# All program code is placed after the
# .text assembler directive
.text 		

# The label 'main' represents the starting point
main:
	# Infinite loop until the correct sequence of numbers is guessed and the user quits the program
	main_while_1: 	bne $t0, $t0, main_end_while_1	# while (true)
			
			la $a0, generated	# $a0 based address of array
			li $a1, 3		# $a1 how many numbers are generated? 
			
			jal generate
			
			# Stack = fun
			subi $sp, $sp, 8		# Allocating 8 bytes on the stack (for $a0 and $a1)
			sw $a0, 4($sp)			# Storing the base address of the generated array
			sw $a1, 0($sp)			# Storing the number of generated values
			
			#You must print (show) the numbers generated after the function call for debugging (testing)
			li $v0, 4			# "print string" service for syscall: $a0 = address of null-terminated string to print
			la $a0, string_generated	# string to print
			syscall				# Printing "Generated Numbers: "
			
			li $t0, 0			# i = 0
			subi $t1, $a1, 1		# $t1 = cnt - 1
			
			# Iterating through 3 generated numbers
			main_for_1:	bge $t0, $t1, main_end_for_1	# for (int i = 0; i < (cnt - 1); i++)
							
					# Retrieving the number at positon generated[i]
					sll $t2, $t0, 2		# $t2 = i * 4
					lw $a0, 4($sp)		# Obtaining the base address of the generated array
					add $t2, $t2, $a0	# $t2 = (i * 4) + $a0
					lw $a0, 0($t2)		# $a0 = generated[i]
					
					# Printing the number at position generated[i]
					li $v0, 1		# "print integer" service for syscall: $a0 = integer to print
					syscall			# Printing generated[i]
					
					# Printing a comma
					li $v0, 11		# "print character" service for syscall: $a0 = character to print
					li $a0, 44		# $a0 = 44 (ascii 44 = ',')
					syscall			# Printing ','
					
					# Printing a space
					li $a0, 32		# #a0 = 32 (ascii 32 = ' ')
					syscall			# Printing ' '
					
					addi $t0, $t0, 1	# i++
					j main_for_1		# Move on to the next iteration of the for loop
					
			# Print the 3rd number in the generated array (no comma or space after)
			main_end_for_1:		sll $t2, $t1, 2		# $t2 = (cnt - 1) * 4
						lw $a0, 4($sp)		# Obtaining the base address of the generated array
						add $t2, $t2, $a0	# $t2 = ((cnt - 1) * 4) + $a0
						lw $a0, 0($t2)		# $a0 = generated[i]
						
						# Printing the number at the final position
						li $v0, 1		# "print integer" service for syscall: $a0 = integer to print
						syscall			# Printing generated[i]
						
						# Printing a newline
						li $v0, 11		# "print character" service for syscall: $a0 = character to print
						li $a0, 10		# $a0 = 10 (ascii 10 = '\n')
						syscall			# Printing '\n'
						
			#You need to get inputs from users and store it into the array input. 
			#la $, input 
			
			# Infinite loop until correct answer is guessed and the user quits the program
			main_while_2: 	bne $t0, $t0, main_end_while_2	# while (true)
			
					# Boolean variable for checking if the user's input was valid (0 = invalid, 1 = valid)
					li $t5, 1	# $t5 = 1
			
					# Prompting the user for input
					li $v0, 4			# "print string" service for syscall: $a0 = address of null-terminated string to print
					la $a0, string_input_prompt	# string to print
					syscall				# Printing "Input Numbers:\n"
					
					la $t3, input			# $t3 = Base address of the input array
					
					# Read input from the user (in one line)
					li $v0, 8			# "read string" service for syscall: $a0 = address of input buffer, $a1 = max number of characters to read
					li $a1, 50			# Allowing the user to enter up to 50 characters
					la $a0, input_buffer		# Setting the input string buffer to a string of 50 bytes
					syscall				# Reading a string of length 50 from the user
					
					li $t7, 0			# $t7 = 0 (iterator variable for index in input array)
					li $t0, 0			# $t0 = 0 (iterator variable for character in input_buffer string)
					li $t8, 0			# $t8 = 0 (boolean variable, = 1 if previous character was a digit)
					# Iterating through each character, delimiting by a space (ascii: 32)
					main_for_2:	bge $t0, 50, main_end_for_2		# for (int i = 0; i < 3; i++)
							add $t2, $t0, $a0			# $t2 = i + base address of the string
							lb $t6, 0($t2)				# $t2 = current character in string
							
							check_if_end_of_string:		beq $t6, 10, main_end_for_2			# if ($t2 !- '\n'
							check_if_space:			beq $t6, 32, move_to_next_index_input		# if ($t2 != space)
							subi $t6, $t6, 48		# Converting ascii to integer (ex. 48 -> 0, 49 -> 1)
							if_in_range_1:			blt $t6, 0, out_of_range
							if_in_range_2:			bgt $t6, 9, out_of_range
							
							beq $t8, 1, out_of_range	# Double digit number entered by user
							li $t8, 1			# Current character is a digit
							
							# Add current digit into input[i]
							sll $t9, $t7, 2		# $t9 = j * 4
							add $t9, $t9, $t3	# $t9 = (j * 4) + base address of the input array
							sw $t6, 0($t9)		# input[j] = input[j] + num
							
							addi $t0, $t0 1			# $t0++ --> next character in input_buffer string
							j main_for_2			# Continue to the next iteration in the for loop (iterating through the input string)
							
							move_to_next_index_input:
							li $t8, 0		# Current character is not a digit
							addi $t0, $t0 1		# $t0++ --> next character in input_buffer string
							addi $t7, $t7, 1	# $t7++ --> next index in input array
							j main_for_2		# Continue to the next iteration in the for loop (iterating through the input string)
							
					main_end_for_2:
					
					li $t0, 0	# i = 0
					# Checking if the inputs from the user are valid
					main_for_3:	bge $t0, 3, main_check_if_valid		# for (int i = 0; i < 3; i++)
					
							# Getting input[i]
							sll $t2, $t0, 2		# $t2 = i * 4
							add $t2, $t2, $t3	# $t2 = (i * 4) + base address of the input array
							lw $t2, 0($t2)		# #t2 = input[i]

							# Check if the input integer is in the range 1 ~ 9
							main_if_1:	bge $t2, 1, main_if_2	# if (inputNumber < 1)
									
									out_of_range:
									# Printing an error message
									li $v0, 4			# "print string" service for syscall: $a0 = address of null-terminated string to print
									la $a0, string_out_of_range	# string to print
									syscall				# Printing "Input must be between 1 and 9.\n"
									
									# Update the boolean variable to invalid (0 = invalid, 1 = valid)
									li $t5, 0	# $t5 = 0
									
									j main_check_if_valid
									
							main_if_2:	ble $t2, 9, checking_for_duplicates	# if (inputNumber > 9)
									
									# Printing an error message
									li $v0, 4			# "print string" service for syscall: $a0 = address of null-terminated string to print
									la $a0, string_out_of_range	# string to print
									syscall				# Printing "Input must be between 1 and 9.\n"
									
									# Update the boolean variable to invalid (0 = invalid, 1 = valid)
									li $t5, 0	# $t5 = 0
									
									j main_check_if_valid
							
							checking_for_duplicates:
							# Check if the input integer is already in the input array
							li $t1, 0	# j = 0
							main_for_4:	bge $t1, 3, main_end_for_4
									
									# Getting input[j]
									sll $t4, $t1, 2		# $t2 = j * 4
									add $t4, $t4, $t3	# $t2 = (j * 4) + base address of the input array
									lw $t4, 0($t4)		# #t2 = input[j]
									
									# If there are two of the same number in different indices (duplicates), print an error message (duplicates)
									main_if_3:	beq $t0, $t1, continue	# if (i != j)
									main_if_4:	bne $t2, $t4, continue	# if (input[i] == input[j]
											
											# Printing an error message
											li $v0, 4			# "print string" service for syscall: $a0 = address of null-terminated string to print
											la $a0, string_duplicates	# string to print
											syscall				# Printing "You cannot input duplicated numbers.\n"
											
											# Update the boolean variable to invalid (0 = invalid, 1 = valid)
											li $t5, 0	# $t5 = 0
											
											j main_check_if_valid
									
									continue:	addi $t1, $t1, 1	# j++
											j main_for_4
							
							main_end_for_4:
							
							addi $t0, $t0, 1	# i++
							j main_for_3
							
					# If any of the user's 3 inputs are invalid, prompt for 3 new inputs
					main_check_if_valid:	bne $t5, 0, balls_and_strikes	# if (inputs are invalid)
								
								# Prompt the user for another guess
								j main_while_2
								
					# Checking the number of balls and strikes
					balls_and_strikes:	
					
					# Setting the arguments for findBalls()
					lw $a0, 4($sp)		# $a0 = base address of the generated array
					addi $a1, $t3, 0	# $a1 = base address of the input array
					
					# Calling findBalls()
					jal findBalls
					addi $t4, $v0, 0	# $t4 = number of balls
					
					# Setting the arguments for findStrikes()
					lw $a0, 4($sp)		# $a0 = base address of the generated array
					addi $a1, $t3, 0	# $a1 = base address of the input array
					
					# Calling findStrikes()
					jal findStrikes
					addi $t5, $v0, 0	# $t5 = number of strikes
					
					# If there are 3 strikes...
					main_if_5:	bne $t5, 3, main_end_if_5	# if (numStrikes == 3)
							
							# Printing a message
							li $v0, 4		# "print string" service for syscall: $a0 = address of null-terminated string to print
							la $a0, string_win	# string to print
							syscall			# Printing "Good Job! Do you want to play again (Y/N)? "
							
							# Reading a character from the user
							li $v0, 12	# "read character" service for syscall: $v0 = character read
							syscall		# Reading a character from the user
							
							main_if_6:	bne $v0, 'Y', main_end_if_6	# if (response == 'Y')
									
									# Printing a newline
									li $v0, 11		# "print character" service for syscall: $a0 = character to print
									li $a0, 10		# $a0 = 10 (ascii 10 = '\n')
									syscall			# Printing '\n'
									
									j main_while_1	# Start a new game
							
							main_end_if_6:	j main_end_while_1	# Terminate the program
					
					# If the user did NOT correctly guess the sequence of numbers...
					main_end_if_5: 				
										# If there are no balls...
								main_if_7: 	bne $t4, 0, main_if_11
										
										# If there are no strikes...
										main_if_8:	bne $t5, 0, main_if_9
										
												# Printing a message
												li $v0, 4			# "print string" service for syscall: $a0 = address of null-terminated string to print
												la $a0, string_out		# string to print
												syscall				# Printing "Out\n"
												
												j new_guess
										
										# If there is 1 strike...			
										main_if_9:	bne $t5, 1, main_if_10
												
												# Printing a message
												li $v0, 4			# "print string" service for syscall: $a0 = address of null-terminated string to print
												la $a0, string_1_strike		# string to print
												syscall				# Printing "1 strike\n"
												
												j new_guess
										
										# If there are 2 strikes...
										main_if_10:	
												# Printing a message
												li $v0, 4			# "print string" service for syscall: $a0 = address of null-terminated string to print
												la $a0, string_2_strikes	# string to print
												syscall				# Printing "2 strikes\n"
												
												j new_guess
								
								# If there is 1 ball...
								main_if_11:	bne $t4, 1, main_if_14
										
										# If there are no strikes...
										main_if_12:	bne $t5, 0, main_if_13
										
												# Printing a message
												li $v0, 4			# "print string" service for syscall: $a0 = address of null-terminated string to print
												la $a0, string_1_ball		# string to print
												syscall				# Printing "1 ball\n"
												
												j new_guess
											
										# If there is 1 strike...
										main_if_13:	bne $t5, 1, main_if_14
										
												# Printing a message
												li $v0, 4			# "print string" service for syscall: $a0 = address of null-terminated string to print
												la $a0, string_1_ball_1_strike	# string to print
												syscall				# Printing "1 ball, 1 strike\n"
												
												j new_guess
								
								# If there are 2 balls...
								main_if_14:	bne $t4, 2, main_if_18
										
										# If there are no strikes...
										main_if_16:	bne $t5, 0, main_if_17
										
												# Printing a message
												li $v0, 4			# "print string" service for syscall: $a0 = address of null-terminated string to print
												la $a0, string_2_balls		# string to print
												syscall				# Printing "2 balls\n"
												
												j new_guess
											
										# If there is 1 strike...
										main_if_17:	bne $t5, 1, main_if_18
										
												# Printing a message
												li $v0, 4				# "print string" service for syscall: $a0 = address of null-terminated string to print
												la $a0, string_2_balls_1_strike		# string to print
												syscall					# Printing "2 balls, 1 strike\n"
												
												j new_guess
								
								# There are 3 balls
								main_if_18:	# Printing a message
										li $v0, 4		# "print string" service for syscall: $a0 = address of null-terminated string to print
										la $a0, string_3_balls	# string to print
										syscall			# Printing "3 balls\n"
										
										j new_guess
						
					# Prompt the user for another guess				
					new_guess:	j main_while_2	
					
			# Start a new game
			main_end_while_2:	j main_while_1

	#And you need to compare two arrays, generated and input, to check the numbers of balls and strikes 
	#jal findBalls 
	#jal findStrikes

	#Write your code here
	
	# Terminate the program
	main_end_while_1:	li, $v0, 10	# "terminate execution" service for syscall
				syscall		# Terminate the program


#generate() function starts here
generate:
	# Fun with the stack
	subi $sp, $sp, 12	# Allocating 12 bytes on the stack (for $a0, $a1, and $ra)
	sw $ra, 8($sp)		# Storing the current return address
	sw $a0, 4($sp)		# Storing the base address of the generated array
	sw $a1, 0($sp)		# Storing the number of generated values
	
	li $t0, 0	# i = 0
	# Iterating 'cnt' number of times
	generate_for_1:	lw $a1, 0($sp)
			bge $t0, $a1, generate_end_for_1	# for (int i = 0; i < cnt; i++)
		
			# Random number in the range 1~9
			li $v0, 42		# "random int range" service for syscall: $a0 = random number, $a1 = upper bound of range
			li $a1, 9		# Setting the random number range to 0~8 (first 9 integers starting with 0)
			syscall			# Generating a random number in range 0~8, storing in $a0
			addi $a0, $a0, 1	# Shifting the range by 1 ($a0 is now a random number in the range 1~9)
			
			# As long as the random number isn't already in the array, I can add it in
			generate_while_1:	bne $t0, $t0, generate_end_while_1	# while(true)
				
				# Setting the argument values before calling find
				move $a1, $a0	# Argument 2 = random number in range 1~9
				lw $a0, 4($sp)  # Argument 1 = the base address of the generated array
				lw $a2, 0($sp)	# Argument 3 = the number of generated values
				
				jal find	# Calling find (returns an integer stored in $v0)
				
				generate_if_1:	bne $v0, -1, generate_else_1	# if (find(generated, randomNumber, cnt) == -1)
				
					# This random number is okay to add to the array (is in range 1~9, and hasn't already been used)
					sll $t1, $t0, 2		# $t1 = i * 4
					add $t1, $t1, $a0	# $t1 = $t1 + $a0, $a0 = the base address of the generated array
					sw $a1, 0($t1)		# Storing $a1 (the random number) into $t1 (generated[i])
					
					j generate_end_while_1
				
				# Otherwise, I must generate a different random number
				generate_else_1:	# Random number in the range 1~9
							li $v0, 42		# "random int range" service for syscall: $a0 = random number, $a1 = upper bound of range
							li $a1, 9		# Setting the random number range to 0~8 (first 9 integers starting with 0)
							syscall			# Generating a random number in range 0~8, storing in $a0
							addi $a0, $a0, 1	# Shifting the range by 1 ($a0 is now a random number in the range 1~9)
							
							j generate_while_1	# Move on to the next iteration of the while loop
			
			generate_end_while_1:	addi $t0, $t0, 1	# i++
						j generate_for_1	# Move on to the next iteration of the for loop
			
	generate_end_for_1:	# More fun with the stack
				lw $ra, 8($sp)		# Obtaining the original return address
				lw $a0, 4($sp)		# Obtaining the base address of the generated array
				lw $a1, 0($sp)		# Obtaining the number of generated values
				addi $sp, $sp, 12	# Deallocating 12 bytes from the stack
	
				jr $ra			# Returning back to main
	

#findBalls () function starts here
findBalls:
	#Write your code here
	
	# Fun with the stack
	subi $sp, $sp, 12	# Allocating 12 bytes on the stack (for $a0, $a1, and $ra)
	sw $ra, 8($sp)		# Storing the current return address
	sw $a0, 4($sp)		# Storing the base address of the generated array
	sw $a1, 0($sp)		# Storing the base address of the input array
	
	li $t6, 0	# Initializing the number of balls to zero
	
	li $t0, 0	# i = 0
	# Iterating 3 times
	findBalls_for_1:	bge $t0, 3, findBalls_end_for_1		# for (int i = 0; i < 3; i++)
	
				# Getting generated[i]
				sll $t1, $t0, 2		# $t1 = i * 4
				lw $a0, 4($sp)		# $a0 = base address of the generated array
				add $t1, $t1, $a0	# $t1 = (i * 4) + base address of the generated array
				lw $t1, 0($t1)		# $t1 = generated[i]
	
				# Setting the arguments for find()
				lw $a0, 0($sp)		# $a0 = The base address of the input array
				addi $a1, $t1, 0	# $a1 = generated[i]
				li $a2, 3		# $a2 = 3
				
				jal find	# Calling find()
				
				# If the number is found in the input array, and the number is found at a different index in each array, then it's a ball
				findBalls_if_1:		beq $v0, -1, findBalls_continue		# if ($v0 != -1)
				findBalls_if_2:		beq $t0, $v0, findBalls_continue	# if (i != v0)
				
				# Increment the number of balls by 1
				addi $t6, $t6, 1	# (number of balls)++
				
				findBalls_continue:
				addi $t0, $t0, 1	# i++
				j findBalls_for_1
	
	findBalls_end_for_1:	# Return the number of balls found
				addi $v0, $t6, 0	# return variable = number of balls
				
				# Fun with the stack
				lw $ra, 8($sp)		# Storing the current return address
				lw $a0, 4($sp)		# Storing the base address of the generated array
				lw $a1, 0($sp)		# Storing the base address of the input array
				addi $sp, $sp, 12	# Deallocating 12 bytes on the stack
				
				jr $ra			# return to main()


#findfindStrikes () function starts here
findStrikes:
	#Write your code here
	
	# Fun with the stack
	subi $sp, $sp, 12	# Allocating 12 bytes on the stack (for $a0, $a1, and $ra)
	sw $ra, 8($sp)		# Storing the current return address
	sw $a0, 4($sp)		# Storing the base address of the generated array
	sw $a1, 0($sp)		# Storing the base address of the input array
	
	li $t6, 0	# Initializing the number of strikes to zero
	
	li $t0, 0	# i = 0
	# Iterating 3 times
	findStrikes_for_1:	bge $t0, 3, findStrikes_end_for_1		# for (int i = 0; i < 3; i++)
	
				# Getting generated[i]
				sll $t1, $t0, 2		# $t2 = i * 4
				lw $a0, 4($sp)		# $a0 = base address of the generated array
				add $t1, $t1, $a0	# $t1 = (i * 4) + base address of the generated array
				lw $t1, 0($t1)		# $t1 = generated[i]
	
				# Setting the arguments for find()
				lw $a0, 0($sp)		# $a0 = The base address of the input array
				addi $a1, $t1, 0	# $a1 = generated[i]
				li $a2, 3		# $a2 = 3
				
				jal find	# Calling find()
				
				# If the number is found in the input array, and the number is found at a different index in each array, then it's a ball
				findStrikes_if_1:		beq $v0, -1, findStrikes_continue		# if ($v0 != -1)
				findStrikes_if_2:		bne $t0, $v0, findStrikes_continue		# if (i == $v0)
				
				# Increment the number of strikes by 1
				addi $t6, $t6, 1	# (number of strikes)++
				
				findStrikes_continue:
				addi $t0, $t0, 1	# i++
				j findStrikes_for_1
	
	findStrikes_end_for_1:	# Return the number of strikes found
				addi $v0, $t6, 0	# return variable = number of strikes
				
				# Fun with the stack
				lw $ra, 8($sp)		# Storing the current return address
				lw $a0, 4($sp)		# Storing the base address of the generated array
				lw $a1, 0($sp)		# Storing the base address of the input array
				addi $sp, $sp, 12	# Deallocating 12 bytes on the stack
				
				jr $ra			# return to main()


###################################################
# find (int arr[], int num, int cnt) function is given. 
# This funtion must be used for all functions, i.e., generate, findBalls, findStrikes, to check duplicated numbers. 
# Note, this funtion change $t8 and $t9 registers' values. To keep the state these values are stored in the stack and restored at the end of function call.
# Please let the instructor knows that if you found any bugs from this function.
find:
	addi $sp, $sp, -8
	sw $t8, 4($sp)
	sw $t9, 0($sp)
	
	li $t8, 0
	li $v0, -1
find_loop_start:
	bge $t8, $a2, find_loop_end
	sll $t9, $t8, 2
	add $t9, $t9, $a0
	lw  $t9, 0($t9)
	beq $t9, $a1, find_loop_found
	addi $t8, $t8, 1
	j find_loop_start

find_loop_found:
	addi $v0, $t8, 0

find_loop_end:
	lw $t8, 4($sp)
	lw $t9, 0($sp)
	addi $sp, $sp, 8
	jr $ra

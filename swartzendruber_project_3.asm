# Name: Travis Swartzendruber

# All memory structures are placed after the
# .data assembler directive
.data
generated:		.word 0, 0, 0, 0, 0, 0    # These numbers will be randomly generated (1 ~ 45) for each iteration
input:			.word 0, 0, 0, 0, 0, 0, 0 # These numbers will be user's inputs (1 ~ 45)
input_numbers:		.asciiz "Input numbers: "
out_of_range:		.asciiz "Input must be between 1 and 45.\n"
duplicate:		.asciiz "No duplicate numbers allowed.\n"
how_many_drawings:	.asciiz "How many drawings: "
invalid_drawings:	.asciiz "Number of drawings must be between 1 and 100.\n"
drawings_start:		.asciiz "Drawings start!\n"
drawing_string:		.asciiz "Drawing "
start_of_drawing_string:	.asciiz ": ["
end_of_drawing_string:		.asciiz "]: "
matches:		.word 0, 0, 0, 0, 0, 0
no_matching_numbers:	.asciiz "No matching numbers. Lose :(\n"
all_matches:		.asciiz "All matches. 1st prize!!! :)\n"
matching_string:	.asciiz "Matching ["
comma_space:		.asciiz ", "
and_bonus:		.asciiz "] and bonus ["
second_prize:		.asciiz "]. 2nd prize!! :)\n"
third_prize:		.asciiz "]. 3rd prize! :)\n"
after_matches:		.asciiz "]. "
lose:			.asciiz "Lose :(\n"
fifth_prize:		.asciiz "5th prize.\n"
fourth_prize:		.asciiz "4th prize.\n"
you_won:		.asciiz "\nYou won "
game:			.asciiz " game!\n"
games:			.asciiz " games!\n"

# Declare main as a global function
.globl main 

# All program code is placed after the
# .text assembler directive
.text 		

# The label 'main' represents the starting point
main:
	# Write your code here
	
	li $s0, 7		# cnt = 7
	la $s1, input		# $s1 = base address of the input array
	la $s4, generated	# $s4 = base address of the generated array
	la $s5, matches		# $s5 = base address of the matches array
	
	main_while_1: bne $s0, $s0, end_main_while_1	# while (true)
	
		li $v0, 4			# syscall "Print String" service
		la $a0, input_numbers		# $a0 = address of string to print
		syscall				# printf ("Input numbers: ")
		
		# READING INTEGER INPUT FROM THE USER, STORING EACH INTEGER IN THE INPUT ARRAY
		li $t0, 0			# i = 0
		main_for_1: bge $t0, $s0, end_main_for_1	# for (int i = 0; i < cnt; i++)
		
			li $v0, 5		# syscall "Read Integer" service
			syscall			# reading an integer from the user ($v0 contains this integer)
			
			sll $t1, $t0, 2		# $t1 = i * 4
			add $t1, $t1, $s1	# $t1 = (i * 4) + base address of input array
			sw $v0, 0($t1)		# input[i] = integer read from the user
			
			addi $t0, $t0, 1	# i++
			j main_for_1		# continue in for() loop
		
		end_main_for_1:
		
		# CHECKING IF EACH INPUT INTEGER IS IN RANGE 1 ~ 45, ALSO CHECKING FOR DUPLICATES
		li $t2, 1	# declaring a boolean variable used for error checking the input integers, initializing to 1 (true)
		li $t0, 0	# i = 0
		main_for_2: bge $t0, $s0, check_if_valid	# for (int i = 0; i < cnt; i++)
		
			sll $t1, $t0, 2		# $t1 = i * 4
			add $t1, $t1, $s1	# $t1 = (i * 4) + base address of input array
			lw $t1, 0($t1)		# $t1 = input[i]
			
			main_if_1: blt $t1, 1, input_out_of_range
			main_if_2: ble $t1, 45, check_for_duplicates
			
			input_out_of_range:	li $v0, 4			# syscall "Print String" service
						la $a0, out_of_range		# $a0 = address of string to print
						syscall				# printf ("Input must be between 1 and 45.\n")
						
						li $t2, 0			# changing the boolean variable to 0 (false)
						j check_if_valid
			
			check_for_duplicates:
			li $t3, 0	# j = 0
			main_for_3: bge $t3, $s0, end_main_for_3	# for (int j = 0; j < cnt; j++)
			
				sll $t4, $t3, 2		# $t4 = j * 4
				add $t4, $t4, $s1	# $t4 = (j * 4) + base address of input array
				lw $t4, 0($t4)		# $t4 = input[j]
				
				main_if_3: bne $t1, $t4, not_a_duplicate
				main_if_4: beq $t0, $t3, not_a_duplicate
				
				li $v0, 4			# syscall "Print String" service
				la $a0, duplicate		# $a0 = address of string to print
				syscall				# printf ("No duplicate numbers allowed.\n")
				
				li $t2, 0			# changing the boolean variable to 0 (false)
				j end_main_for_3
				
				not_a_duplicate: addi $t3, $t3, 1		# j++
				j main_for_3				# continue in the for() loop
			
			end_main_for_3: bne $t2, 1, check_if_valid
					
					addi $t0, $t0, 1	# i++
					j main_for_2		# continue in the for() loop
		
		check_if_valid: beq $t2, 1, end_main_while_1
				j main_while_1		# continue in the while() loop
	
	# READING INTEGER INPUT (NUMBER OF DRAWINGS) FROM USER
	end_main_while_1:
	li $t2, 0	# Declaring an integer to store the number of drawings, initialized to 0
	
	main_while_2: bne $s0, $s0, end_main_while_2	# while (true)
	
		li $v0, 4			# syscall "Print String" service
		la $a0, how_many_drawings	# $a0 = address of string to print
		syscall				# printf ("How many drawings: ")
		
		li $v0, 5		# syscall "Read Integer" service
		syscall			# reading an integer from the user ($v0 contains this integer)
		
		move $t2, $v0		# moving the entered integer into the numDrawings variable
		
		main_if_5: blt $v0, 1, invalid_number_of_drawings
		main_if_6: ble $v0, 100, end_main_while_2
		
		invalid_number_of_drawings:
		li $v0, 4			# syscall "Print String" service
		la $a0, invalid_drawings	# $a0 = address of string to print
		syscall				# printf ("Number of drawings must be between 1 and 100.\n")
		
		j main_while_2			# continue in the while() loop
	
	end_main_while_2:
	li $v0, 4			# syscall "Print String" service
	la $a0, drawings_start		# $a0 = address of string to print
	syscall				# printf ("Drawings start!\n")
	
	li $t3, 0	# gamesWon = 0
	li $t0, 1	# i = 1
	
drawings_loop_start:

	# Write your code here
	
	bgt $t0, $t2, drawings_loop_end		# for (int i = 1; i <= numDrawings; i++)
	
	la $a0, generated	# $a0 based address of array
	li $a1, 6		# $a1 how many numbers are generated? 
	
	jal generate
	
	
	# EXTRA CREDIT SORTING FUNCTION
	la $a0, generated	# $a0 based address of array
	li $a1, 6		# $a1 how many numbers are generated?
	jal sort
	
	# PRINTING THE SORTED GENERARTED NUMBERS
	li $v0, 4			# syscall "Print String" service
	la $a0, drawing_string		# $a0 = address of string to print
	syscall				# printf ("Drawing ")
	
	li $v0, 1			# syscall "Print Integer" service
	move $a0, $t0			# $a0 = integer to print (i)
	syscall				# printf ("%d", i)
	
	li $v0, 4				# syscall "Print String" service
	la $a0, start_of_drawing_string		# $a0 = address of string to print
	syscall					# printf (": [")
	
	li $t9, 0	# j = 0
	subi $s3, $s0, 2	# $s3, cnt - 2
	main_for_4: bge $t9, $s3, end_main_for_4
	
		sll $t1, $t9, 2		# $t1 = j * 4
		la $a0, generated	# $a0 = base address of the generated array
		add $t1, $t1, $a0	# $t1 = (j * 4) + base address of the generated array
		lw $t1, 0($t1)		# $t1 = generated[j]
	
		li $v0, 1				# syscall "Print Integer" service
		move $a0, $t1				# $a0 = integer to print (generated[j])
		syscall					# printf (generated[j])
	
		li $v0, 11				# syscall "Print Character" service
		li $a0, 44				# $a0 = character to print (ASCII 44 -> comma (','))
		syscall					# printf (',')
		
		li $a0, 32				# $a0 = character to print (ASCII 32 -> space (' '))
		syscall					# printf (' ')
		
		addi $t9, $t9, 1	# j++
		j main_for_4
	
	end_main_for_4:
	
	subi $t1, $s0, 2		# $t1, cnt - 2
	la $a0, generated		# $a0 = base address of the generated array
	sll $t1, $t1, 2			# $t1 = (cnt - 2) * 45
	add $t1, $t1, $a0		# $t1 = ( (cnt - 2) * 4) + base address of the generated array
	lw $t1, 0($t1)			# $t1 = generated[cnt - 2]
	
	li $v0, 1			# syscall "Print Integer" service
	move $a0, $t1			# $a0 = integer to print (generated[cnt-2])
	syscall				# printf (generated[cnt-2])
	
	li $v0, 4			# syscall "Print String" service
	la $a0, end_of_drawing_string	# $a0 = address of string to print
	syscall				# printf ("]: ")
	
	#set a0 and a1 here for a drawing
	move $a0, $s1
	move $a1, $s4
	jal drawing
	
	add $t3, $t3, $v0		# gamesWon = gamesWon + drawing(input, generated)
	
	#############################
	#li $v0, 11				# syscall "Print Character" service
	#li $a0, 10				# $a0 = character to print (ASCII 10 -> newline ('\n'))
	#syscall				# printf ('\n')
	#############################
	
	addi $t0, $t0, 1	# i++
	j drawings_loop_start

drawings_loop_end:

	# Write your code here
	
	main_if_7: bne $t3, 1, end_main_if_7
	
		li $v0, 4				# syscall "Print String" service
		la $a0, you_won				# $a0 = address of string to print
		syscall					# printf ("\nYou won ")
		
		li $v0, 1				# syscall "Print Integer" service
		move $a0, $t3				# $a0 = integer to print (gamesWon)
		syscall					# printf ("%d", gamesWon)
		
		li $v0, 4				# syscall "Print String" service
		la $a0, game				# $a0 = address of string to print
		syscall					# printf (" game!\n")
		
		j terminate_program
	
	end_main_if_7:
	
		li $v0, 4				# syscall "Print String" service
		la $a0, you_won				# $a0 = address of string to print
		syscall					# printf ("\nYou won ")
		
		li $v0, 1				# syscall "Print Integer" service
		move $a0, $t3				# $a0 = integer to print (gamesWon)
		syscall					# printf ("%d", gamesWon)
		
		li $v0, 4				# syscall "Print String" service
		la $a0, games				# $a0 = address of string to print
		syscall					# printf (" games!\n")
	
	terminate_program:
	li $v0, 10		# terminate execution
	syscall


#drawing function starts here
drawing:
	#Write your code here
	#You must print (show) the generated numbers and if
	
	# Fun with the stack
	subi $sp, $sp, 48	# Allocating 48 bytes on the stack (for $a0, $a1, $ra, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, and $t8)
	sw $t8, 44($sp)		# Storing $t8
	sw $ra, 40($sp)		# Storing the current return address
	sw $a0, 36($sp)		# Storing the base address of the input array
	sw $a1, 32($sp)		# Storing the base address of the generated array
	sw $t0, 28($sp)		# Storing $t0
	sw $t1, 24($sp)		# Storing $t1
	sw $t2, 20($sp)		# Storing $t2
	sw $t3, 16($sp)		# Storing $t3
	sw $t4, 12($sp)		# Storing $t4
	sw $t5, 8($sp)		# Storing $t5
	sw $t6, 4($sp)		# Storing $t6
	sw $t7, 0($sp)		# Storing $t7
	
	li $t0, 0	# numGamesWon = 0
	li $t1, 0	# numMatches = 0
	li $t3, 0	# bonusNumber = 0
	li $t4, 0	# i = 0
	
	reset_to_zeros: bge $t4, 6, end_reset
		sll $t7, $t4, 2		# $t7 = i * 4
		add $t7, $t7, $s5	# $t7 (i * 4) + base address of the matches array		
		sw $t3, 0($t7)		# matches[i] = 0
		
		#lw $t7, 0($t7)
		#li $v0, 1		# syscall "Print Integer" service
		#move $a0, $t7		# $a0 = integer to print (matches[i])
		#syscall			# printf (matches[i])
		addi $t4, $t4, 1
		j reset_to_zeros
	end_reset:
	#li $v0, 4			# syscall "Print String" service
	#la $a0, debug			# $a0 = address of string to print
	#syscall				# printf ("\n")
	
	li $t4, 0	# i = 0
	li $t3, 0	# bonusNumber = 0
	
	drawing_for_1: bge $t4, 6, end_drawing_for_1
	
		sll $t6, $t4, 2		# $t6 = i * 4
		lw $a1, 32($sp)		# $a1 = base address of the generated array
		add $t6, $t6, $a1	# $t6 (i * 4) + base address of the generated array
		lw $t6, 0($t6)		# $t6 = generated[i]
	
		# Setting the argument values before calling find
		lw $a0, 36($sp) 	# Argument 1 = base address of the input array
		move $a1, $t6		# Argument 2 = generated[i]
		li $a2, 7		# Argument 3 = the number of input values (7)
		
		jal find	# Calling find (returns an integer stored in $v0)
		
		drawing_if_1: beq $v0, -1, end_drawing_if_1
		
			drawing_if_2: bne $v0, 6, end_drawing_if_2
			
				move $t3, $t6		# bonusNumber = generated[i]
				j end_drawing_if_1
			
			end_drawing_if_2:
				
				sll $t7, $t4, 2		# $t7 = i * 4
				add $t7, $t7, $s5	# $t7 (i * 4) + base address of the matches array		
				sw $t6, 0($t7)		# matches[i] = generated[i]
				addi $t1, $t1, 1	# numMatches++
				
				j end_drawing_if_1
		
		end_drawing_if_1: addi $t4, $t4, 1	# i++
				  j drawing_for_1	# continue in the for() loop
	
	end_drawing_for_1:
	
	drawing_if_3: bne $t1, 0, drawing_if_4
	
		li $v0, 4			# syscall "Print String" service
		la $a0, no_matching_numbers	# $a0 = address of string to print
		syscall				# printf ("No matching numbers. Lose :(\n")
		
		j return_numGamesWon
	
	drawing_if_4: bne $t1, 6, drawing_else_1
	
		li $v0, 4			# syscall "Print String" service
		la $a0, all_matches		# $a0 = address of string to print
		syscall				# printf ("All matches. 1st prize!!! :)\n")
		
		j return_numGamesWon
	
	drawing_else_1:
		
		li $t4, 0	# i = 0
		li $t5, 0	# numPrinted = 0
		
		li $v0, 4			# syscall "Print String" service
		la $a0, matching_string		# $a0 = address of string to print
		syscall				# printf ("Matching [")
		
		drawing_for_2: bge $t4, 6, return_numGamesWon
		
			sll $t7, $t4, 2		# $t7 = i * 4
			add $t7, $t7, $s5	# $t7 (i * 4) + base address of the matches array		
			lw $t7, 0($t7)		# $t7 = matches[i]
		
			drawing_if_5: beq $t7, 0, end_drawing_if_5
			
				subi $t8, $t1, 1	# $t8 = numMatches - 1
				drawing_if_6: beq $t5, $t8, drawing_else_2
				
					li $v0, 1			# syscall "Print Integer" service
					move $a0, $t7			# $a0 = integer to print (matches[i])
					syscall				# printf (matches[i])
					
					li $v0, 4			# syscall "Print String" service
					la $a0, comma_space		# $a0 = address of string to print
					syscall				# printf (", ")
					
					addi $t5, $t5, 1		# numPrinted++
					j end_drawing_if_5
				
				drawing_else_2:
				
				drawing_if_7: bne $t1, 5, drawing_else_3
				
					drawing_if_8: beq $t3, 0, drawing_else_4
					
						li $v0, 1			# syscall "Print Integer" service
						move $a0, $t7			# $a0 = integer to print (matches[i])
						syscall				# printf (matches[i])
						
						li $v0, 4			# syscall "Print String" service
						la $a0, and_bonus		# $a0 = address of string to print
						syscall				# printf ("] and bonus [")
						
						li $v0, 1			# syscall "Print Integer" service
						move $a0, $t3			# $a0 = integer to print (bonusNumber)
						syscall				# printf (bonusNumber)
						
						li $v0, 4			# syscall "Print String" service
						la $a0, second_prize		# $a0 = address of string to print
						syscall				# printf ("]. 2nd prize!! :)\n")
						
						addi $t0, $t0, 1		# numGamesWon++
						j return_numGamesWon
					
					drawing_else_4:
					
					li $v0, 1			# syscall "Print Integer" service
					move $a0, $t7			# $a0 = integer to print (matches[i])
					syscall				# printf (matches[i])
					
					li $v0, 4			# syscall "Print String" service
					la $a0, third_prize		# $a0 = address of string to print
					syscall				# printf ("]. 3rd prize! :)\n")
					
					j return_numGamesWon
				
				drawing_else_3:
				
				li $v0, 1			# syscall "Print Integer" service
				move $a0, $t7			# $a0 = integer to print (matches[i])
				syscall				# printf (matches[i])
				
				li $v0, 4			# syscall "Print String" service
				la $a0, after_matches		# $a0 = address of string to print
				syscall				# printf ("]. ")
				
				drawing_if_9: bge $t1, 3, drawing_else_9
				
					li $v0, 4			# syscall "Print String" service
					la $a0, lose		# $a0 = address of string to print
					syscall				# printf ("Lose :(\n")
					
					j return_numGamesWon
				
				drawing_else_9:
				
				addi $t0, $t0, 1	# numGamesWon++
				
				drawing_if_10: bne $t1, 3, drawing_if_11
				
					li $v0, 4		# syscall "Print String" service
					la $a0, fifth_prize	# $a0 = address of string to print
					syscall			# printf ("5th prize.\n")
					
					j return_numGamesWon
				
				drawing_if_11: bne $t1, 4, return_numGamesWon
				
					li $v0, 4		# syscall "Print String" service
					la $a0, fourth_prize	# $a0 = address of string to print
					syscall			# printf ("4th prize.\n")
					
					j return_numGamesWon
			
			end_drawing_if_5: addi $t4, $t4, 1	# i++
				  	  j drawing_for_2	# continue in the for() loop
		
	return_numGamesWon:
	
	move $v0, $t0		# $v0 = value to return to main = $t0 = numGamesWon
	
	# More fun with the stack
	lw $t8, 44($sp)		# Storing $t8
	lw $ra, 40($sp)		# Obtaining the original return address
	lw $a0, 36($sp)		# Obtaining the base address of the input array
	lw $a1, 32($sp)		# Obtaining the base address of the generated array
	lw $t0, 28($sp)		# Obtaining the original $t0
	lw $t1, 24($sp)		# Obtaining the original $t1
	lw $t2, 20($sp)		# Obtaining the original $t2
	lw $t3, 16($sp)		# Obtaining the original $t3
	lw $t4, 12($sp)		# Obtaining the original $t4
	lw $t5, 8($sp)		# Obtaining the original $t5
	lw $t6, 4($sp)		# Obtaining the original $t6
	lw $t7, 0($sp)		# Obtaining the original $t7
	
	addi $sp, $sp, 48	# Deallocating 48 bytes from the stack
	
	jr $ra
	
	




#void sort (int [] generated, int cnt) for extra credit
#sort function starts here. The array generated will be sorted by calling this function. 
#you can call this function anywhere before printing generated array. 
sort:
	#Write your code here
	
	# Fun with the stack
	subi $sp, $sp, 12	# Allocating 12 bytes on the stack (for $a0, $a1, and $ra)
	sw $ra, 8($sp)		# Storing the current return address
	sw $a0, 4($sp)		# Storing the base address of the generated array
	sw $a1, 0($sp)		# Storing the number of generated values
	
	li $t4, 0	# num = 0
	subi $s2, $a1, 1	# $s2 = cnt - 1
	
	sort_for_1: bge $t4, $a1, end_sort_for_1
	
		li $t5, 0	# i = 0
	
		sort_for_2: bge $t5, $s2, end_sort_for_2
		
			sll $t6, $t5, 2		# $t6 = i * 4
			la $a0, generated
			add $t6, $t6, $a0	# $t6 = (i * 4) + base address of generated array
			lw $t6, 0($t6)		# $t6 = generated[i]
			
			addi $t7, $t5, 1	# $t7 = i + 1
			sll $t7, $t7, 2		# $t7 = (i + 1) * 4
			add $t7, $t7, $a0	# $t7 = ( (i + 1) * 4 ) + base address of generated array
			lw $t7, 0($t7)		# $t7 = generated[i + 1]
			
			sort_if: ble, $t6, $t7, end_sort_if
			
				move $t8, $t6	# temp = generated[i]
				
				sll $t6, $t5, 2		# $t6 = i * 4
				add $t6, $t6, $a0	# $t6 = (i * 4) + base address of generated array
				
				sw $t7, 0($t6)		# generated[i] = generated[i + 1]
				
				addi $t7, $t5, 1	# $t7 = i + 1
				sll $t7, $t7, 2		# $t7 = (i + 1) * 4
				add $t7, $t7, $a0	# $t7 = ( (i + 1) * 4 ) + base address of generated array
				
				sw $t8, 0($t7)		# generated[i + 1] = temp
			
			end_sort_if: addi $t5, $t5, 1	# i++
				     j sort_for_2	# continue in the for() loop
		
		end_sort_for_2: addi $t4, $t4, 1	# num++
			 	j sort_for_1		# continue in the for() loop
	
	end_sort_for_1:		
	# More fun with the stack
	lw $ra, 8($sp)		# Obtaining the original return address
	lw $a0, 4($sp)		# Obtaining the base address of the generated array
	lw $a1, 0($sp)		# Obtaining the number of generated values
	addi $sp, $sp, 12	# Deallocating 12 bytes from the stack
	
	jr $ra			# Returning back to main
	

###################################################
#copy and paste your generate function here
generate:
	# Fun with the stack
	subi $sp, $sp, 20	# Allocating 20 bytes on the stack (for $ra, $a0, $a1, $t1, and $t0)
	sw $ra, 16($sp)		# Storing the current return address
	sw $a0, 12($sp)		# Storing the base address of the generated array
	sw $a1, 8($sp)		# Storing the number of generated values
	sw $t1, 4($sp)		# Storing $t1
	sw $t0, 0($sp)		# Storing $t0
	
	li $t0, 0	# i = 0
	# Iterating 'cnt' number of times
	generate_for_1:	
			lw $a1, 8($sp)
			bge $t0, $a1, generate_end_for_1	# for (int i = 0; i < cnt; i++)
		
			# Random number in the range 1~9
			li $v0, 42		# "random int range" service for syscall: $a0 = random number, $a1 = upper bound of range
			li $a1, 45		# Setting the random number range to 0 ~ 44 (first 45 integers starting with 0)
			syscall			# Generating a random number in range 0 ~ 44, storing in $a0
			addi $a0, $a0, 1	# Shifting the range by 1 ($a0 is now a random number in the range 1 ~ 45)
			
			# As long as the random number isn't already in the array, I can add it in
			generate_while_1:	bne $t0, $t0, generate_end_while_1	# while(true)
				
				# Setting the argument values before calling find
				move $a1, $a0	# Argument 2 = random number in range 1~45
				lw $a0, 12($sp)  # Argument 1 = the base address of the generated array
				lw $a2, 8($sp)	# Argument 3 = the number of generated values
				
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
							li $a1, 45		# Setting the random number range to 0 ~ 44 (first 45 integers starting with 0)
							syscall			# Generating a random number in range 0 ~ 44, storing in $a0
							addi $a0, $a0, 1	# Shifting the range by 1 ($a0 is now a random number in the range 1 ~ 45)
							
							j generate_while_1	# Move on to the next iteration of the while loop
			
			generate_end_while_1:	addi $t0, $t0, 1	# i++
						j generate_for_1	# Move on to the next iteration of the for loop
			
	generate_end_for_1:	# More fun with the stack
				lw $ra, 16($sp)		# Obtaining the original return address
				lw $a0, 12($sp)		# Obtaining the base address of the generated array
				lw $a1, 8($sp)		# Obtaining the number of generated values
				lw $t1, 4($sp)		# Obtaining the original $t1
				lw $t0, 0($sp)		# Obtaining the original $t0
				addi $sp, $sp, 20	# Deallocating 120 bytes from the stack
	
				jr $ra			# Returning back to main

###################################################
# find (int arr[], int num, int cnt) function is given. 
# This funtion must be used for all functions, i.e., generate, findBalls, findStrikes, to check duplicated numbers. 
# Note, this funtion will use $t8 and $t9 registers. If you keep important values in $t8, $t9 in other functions, 
# you may lose the states by calling this function.
# Please let the instructor knows that if you found any bugs from this function.
find:
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
	jr $ra

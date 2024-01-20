# Name: Travis Swartzendruber

# All memory structures are placed after the
# .data assembler directive
.data
input:		.word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 # change these values (and size) to test your program

# This will store the count for each number (The size of this output must be 50 regardless of input's size)
output:		.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 

error_message: .asciiz "ERROR: This number is not in the valid range!\n"

colon: .asciiz ":"

newline: .asciiz "\n"

# Declare main as a global function
.globl main 

# All program code is placed after the
# .text assembler directive
.text 		

# The label 'main' represents the starting point
main:
	la $a0, input	# $a0 based address of input array
	li $a1, 12	# $a1 how many numbers are in the array
	la $a2, output	# a2 address of the output array

	jal countNumbers

	#Write your code here
	
	#Print result 
	jal printResult


# countNumbers function starts here
countNumbers :
	#Write your code here
	addi $t0, $zero, 0	# $t0 (i) = 0
	
	subi $sp, $sp, 4	# opening up 4 bytes in the stack
	sw $ra, 0($sp)		# storing the current return address in the stack
	
	for: 	bge $t0, $a1, end_for		# for (i = 0; i < count; i++)
		
		sll $t3, $t0, 2			# $t3 = $t0 * 4
		add $t3, $a0, $t3		# $t3 = $a0 + $t3 (i*4 + base_address of input array)
		lw $a3, 0($t3)			# $a3 = number at index i*4 in the input array
		
		#You must use the jal instruction for function call
		jal increaseCnt
		
		move $t1, $ra		# $t1 = increaseCnt()
		
		if:	bne $t1, 0, end_if
		
			move $t2, $v0			# $t2 = $v0
			
			li $v0, 4			# Code for syscall: print_string
			la $a0, error_message		# Pointer to string (load the address of msg)
			syscall
			
			move $v0, $t2			# $v0 = $t2
		
		end_if:	addi $t0, $t0, 1
			j for
	
	end_for:
	
	lw $ra, 0($sp)		# obtaining the original return address

	#You must use the jr instruction for return 
	jr $ra


# increaseCnt function starts here
increaseCnt:
	#Write your code here	
	# output[] -> $a2
	# input[i] -> $a3
	
	if_one:	blt $a3, 0, end_if_fail			# if $a3 >= 0, continue checking
	
		if_two: bge $a3, 50, end_if_fail	# if $a3 < 50, number is in valid range
		
			sll $t4, $a3, 2			# $t4 = $a3 * 4
			add $t4, $a2, $t4		# $t4 = $a2 + $t4 (address of output[num])
			lw $t5, 0($t4)			# $t5 = output[num]
			addi $t5, $t5, 1		# $t5 = $t5 + 1
			sw $t5, 0($t4)			# storing number+1 back into the output array at the same index
			
			addi $v0, $zero, 1		# return 1 (in the valid range)
	
	end_if_fail: addi $v0, $zero, 0		# return 0 (not in the valid range)

	#You must use the jr instruction for return 
	jr $ra


# printResult function starts here
printResult:
	#Write your code here
	# output[] -> $a2
	# count -> $a1
	
	addi $t0, $zero, 0		# $t0 (i) = 0
	
	new_for:	bge $t0, $a1, end_new_for		# for (i = 0; i < count; i++)
			
			sll $t1, $t0, 2		# $t1 = $t0 (i) * 4
			add $t1, $a2, $t1	# $t1 = $a2 + $t4 (address of output[i])
			lw $t2, 0($t1)		# $t2 = output[i]
			
			new_if: ble $t2, 0, end_new_if		# if (output[i] > 0)
			
				move $t3, $v0			# $t3 = $v0
				
				li $v0, 1			# Code for syscall: print_int
				la $a0, ($t0)			# Pointer to integer
				syscall
				
				li $v0, 4			# Code for syscall: print_string
				la $a0, colon			# Pointer to string
				syscall
				
				li $v0, 1			# Code for syscall: print_int
				la $a0, ($t2)			# Pointer to integer
				syscall
				
				li $v0, 4			# Code for syscall: print_string
				la $a0, newline			# Pointer to string
				syscall
				
				move $v0, $t3			# $v0 = $t3
			
			end_new_if:	addi $t0, $t0, 1
					j new_for
	
	end_new_for:

	#You must use the jr instruction for return 
	jr $ra

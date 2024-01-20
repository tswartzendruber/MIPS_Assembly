# Name: Travis Swartzendruber

.data
array:		.word 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
not_msg:		.asciiz	"Not found"
found_msg:	.asciiz	"Found idx: "

# Declare main as a global function
.globl main 

# All program code is placed after the
# .text assembler directive
.text 		
main:
		# 1. Init parameters for a function call 
		la	$a0, array 			# this is the array base address, first parameter
		li	$a1, 11     		# This is the number you search
		li	$a2, 10    			# This is the size of the array
	
		# 2. Use jal to call a function ($ra = $pc + 4)
		jal	find

		# Print result 
		blt	$v0, $zero, non
		move	$t0, $v0
		li	$v0, 4				# Code for syscall: print_string
		la	$a0, found_msg		# Pointer to string (load the address of msg)
		syscall

		li	$v0, 1	 			#number that will be printed. 
		move	$a0, $t0		# Pointer to string (load the address of msg)
		syscall

		j done
# Exit
non:	
		li	$v0, 4				# Code for syscall: print_string
		la	$a0, not_msg		# Pointer to string (load the address of msg)
		syscall
done:	
		li	$v0, 10				# exit
		syscall

# find function starts here. 
# You only need to complete this function to get extra credit. 
# $a0 = base_address
# $a1 = value to search
# $a2 = cnt
find:	
		# 3. Create a stack if needed. 

		# i = 0 + 0
		addi $t0, $zero, 0

		# for ( !( i >= size ) )
		for_statement: bge $t0, $a2, end_for_statement
			
			# address = i * 4
			sll $t1, $t0, 2
			
			# address = address + base_address
			add $t1, $t1, $a0
			
			# number at index i = number at index i
			lw $t2, 0($t1)
			
			# if ( !(number at index i != value looking for) )
			if_statement: bne $t2, $a1, end_if_statement
			
				# return value = i + 0
				add $v0, $t0, $zero
				
				# actually returns the return value
				jr $ra
				
			# end if()
			end_if_statement:

			# i = i + 1
			addi $t0, $t0, 1
			
			# continue in loop
			j for_statement
			
		end_for_statement:

		# return value = 0 - 1
		subi $v0, $zero, 1
		
		# actually returns the return value
		jr $ra

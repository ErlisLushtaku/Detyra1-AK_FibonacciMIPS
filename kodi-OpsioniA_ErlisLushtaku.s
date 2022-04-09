.text
.globl main

main:
	
# Initialize registers
	li  	$s0, 0				# Reg $s0 = x = 0
	li		$s1, 0				# Reg $s1 = counter (i) = 0

# Print msg1 "Enter the number of terms of series : "
	li		$v0, 4				# print_string syscall code = 4
	la		$a0, msg1	
	syscall

# Get x from user and save
	li		$v0, 5				# read_int syscall code = 5
	syscall	
	move	$s0, $v0			# syscall results returned in $v0
	
# Print msg2 "\nFibonnaci Series : "
	li		$v0, 4				# print_string syscall code = 4
	la		$a0, msg2	
	syscall

	# Main loop body
	loop:	
		bge 	$s1, $s0, exit	# if(i >= x) jump to exit <=> while(i < x)
	
	# Print space " "
		li		$v0, 4			# print_string syscall code = 4
		la		$a0, space	
		syscall
	
	# Call function
		move	$a0, $s1		# Argument 1: i ($s1)
		jal		fib				# Save current PC in $ra, and jump to fib
		move	$s2, $v0		# Return value saved in $v0
		
	# Print result of fib
		li		$v0, 1			# print_int syscall code = 1
		move	$a0, $s2		# Load integer to print in $a0
		syscall
		
		addi	$s1, $s1, 1		# i++
		
		j		loop

exit:
	li		$v0, 10				# exit
	syscall
	
fib:
	li 		$t0, 1
	beq 	$a0, $t0, returnx	# if(x == 1)
	beq 	$a0, $zero, returnx	# if(x == 0)
	
# Adjust for calling fib(x - 1)
	addi 	$sp, $sp, -8		# Adjust stack pointer
	sw 		$ra, 0($sp)			# Save $ra
	
	addi 	$a0, $a0, -1		# x = x - 1
	jal fib						# Save current PC in $ra, and jump to fib
	
	sw 		$v0, 4($sp)			# Save $v0 (return value of fib(x - 1))
	
# Adjust for calling fib(x - 2)
	addi 	$a0, $a0, -1		# $a0 - 1 = (x - 1) - 1 = x - 2
	jal fib						# Save current PC in $ra, and jump to fib
	
	addi 	$a0, $a0, 2			# Reset $a0 to initial value (x)
	
# fib(x - 1) + fib(x - 2)
	lw 		$t1, 4($sp)			# $t1 = 4($sp) = fib(x - 1), $v0 = fib(x - 2)
	add 	$v0, $t1, $v0		# $v0 = fib(x - 1) + fib(x - 2)

# Return fib(x - 1) + fib(x - 2)
	lw 		$ra, 0($sp) 		# Retrieve return address
	addi 	$sp, $sp, 8			# Reset stack pointer
	jr 		$ra

	
	returnx:
	# Save the return value in $v0
		move 	$v0, $a0	
 
	# Return from function
		jr 		$ra				# Jump to address stored in $ra

.data
msg1:	.asciiz	"Enter the number of terms of series : "
msg2:	.asciiz "\nFibonnaci Series : "
space:	.asciiz " "
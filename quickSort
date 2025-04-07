.data
	# Actual information
	arr: .word 2, 5, 100, 33, 92, 6, 7, 11, 32, 69, 4444, 1
	arr_len: .word 12
	
	# Formatting
	arr_original_prompt: .asciiz "Original array: \n"
	arr_sorted_prompt: .asciiz "Sorted array: \n"
	spacer: .ascii ", "
	newline: .ascii "\n"
	
.text
.globl main

main:
	# formatting
	li $v0, 4
	la $a0, arr_original_prompt
	syscall 

	# print base arr
	li $a1, 0
	jal print_arr
	sll $zero, $zero, 0
	
	# newline for neatness
	li $v0, 4
	la $a0, newline
	syscall
	
	# set values of low and high for quicksort
	addi $a0, $zero, 0
	la $a1, arr_len
	lw $a1, 0($a1)
	addi $a1, $a1, -1
	
	jal quicksort
	sll $zero, $zero, 0
	
	# more formatting
	li $v0, 4
	la $a0, arr_sorted_prompt
	syscall
	
	# print sorted arr
	li $a1, 0
	jal print_arr
	sll $zero, $zero, 0
	
	# exit
	li $v0, 10
	syscall
	
# ---------------------------------
# a0 contains low, a1 contains high
# ---------------------------------
quicksort:
	# store return and input information
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	# if low > high return
	bge $a0, $a1, quicksort_return
	sll $zero, $zero, 0
	
	# partition and find pivot
	jal partition
	sll $zero, $zero, 0
	
	# get values of pivot+1 and pivot-1
	move $t0, $v0
	addi $t1, $t0, -1
	addi $t2, $t0, 1
	
	# quicksort on low = 0 high = pivot - 1
	lw $a0, 4($sp)
	move $a1, $t1
	
	jal quicksort
	sll $zero, $zero, 0
	
	# quicksort on low = pivot + 1 high = arr_len - 1
	move $a0, $t2
	lw $a1, 8($sp)
	
	jal quicksort
	sll $zero, $zero, 0
	
quicksort_return:
	# restore sp and return
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra

# ----------------------	
# a0 is low, a1 is high
# ----------------------
partition:
	# reserve space and store inputs
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	la $t0, arr  # get base address for arr
	
	# find arr[high] for pivot
	sll $s0, $a1, 2
	add $s0, $s0, $t0
	lw $s0, 0($s0)  # s0 is pivot
	
	# find other values used
	addi $s1, $a0, -1  # s1 is i
	addi $s2, $a1, 0  # s2 is high
	addi $s3, $a0, 0  # s3 is j
	
partition_loop:
	# i >= j return
	bge $s3, $s2, partition_return
	sll $zero, $zero, 0
	
	la $t0, arr  # get base address for arr
	
	# finding arr[j] and index of arr[j]
	sll $t1, $s3, 2
	add $t1, $t1, $t0  # t1 is the location of arr[j]
	lw $t3, 0($t1)  # t3 is arr[j]
	
	# arr[j] >= pivot, dont swap
	bge $t3, $s0, partition_skip_swap
	sll $zero, $zero, 0
	
	addi $s1, $s1, 1  # i++
	
	# finding arr[i] and index of arr[i]
	sll $t2, $s1, 2
	add $t2, $t2, $t0  # t2 is the location of arr[i]
	lw $t4, 0($t2)  # t4 is arr[i]
	
	# swap arr[i] and arr[j]
	sw $t3, 0($t2) 
	sw $t4, 0($t1)
	
	addi $s3, $s3, 1  # j++
	
	j partition_loop  # re-enter
	
partition_skip_swap:
	addi $s3, $s3, 1  # j++
	j partition_loop  # re-enter
	
partition_return:
	la $t0, arr  # get base address for arr
	
	addi $s1, $s1, 1  # i++
	
	# finding arr[i] and index of arr[i]
	sll $t1, $s1, 2
	add $t1, $t1, $t0
	lw $t3, 0($t1)
	
	# finding arr[j] and index of arr[j]
	sll $t2, $s2, 2
	add $t2, $t2, $t0
	lw $t4, 0($t2)
	
	# swap arr[i] and arr[j]
	sw $t3, 0($t2)
	sw $t4, 0($t1)
	
	# return i as pivot
	move $v0, $s1
	
	# restore sp and return
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra
	
# --------------------
# a1 contains i
# a0 free for syscalls
# --------------------
print_arr:
	la $t0, arr  # get arr pointer
	la $t1, arr_len  # get len pointer
	
	sll $t2, $a1, 2
	add $t0, $t0, $t2  # adjust index for word size
	
	lw $t0, 0($t0)  # obtain arr[i]
	lw $t1, 0($t1)  # obtain arr_len
	
	# print arr[i]
	li $v0, 1
	move $a0, $t0
	syscall
	
	# space out arr[i] prints
	li $v0, 4
	la $a0, spacer
	syscall
	
	addi $a1, $a1, 1  # inc
	
	blt $a1, $t1, print_arr  # call if i < arr_len
	
	jr $ra  # return	
	

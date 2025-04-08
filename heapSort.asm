.data
	# Actual information
	arr: .word 2, 5, 100, 33, 92, 6, 7, 11, 32, 69
	arr_len: .word 10
	
	# Formatting
	arr_original_prompt: .asciiz "Original array: \n"
	arr_sorted_prompt: .asciiz "Sorted array: \n"
	spacer: .ascii ", "
	newline: .ascii "\n"
	
.text
.globl main

main:
	addi $sp, $sp, -4
	lw $t0, arr_len
	sw $t0, 0($sp)  # store arr_len because it is reduced by heapsort_extraction
	
	li $v0, 4
	la $a0, arr_original_prompt  # print unsorted prompt
	syscall

	li $a1, 0  # init index to 0
	
	jal print_arr  # print base arr
	sll $zero, $zero, 0
	
	
	lw $a0, arr_len
	srl $a0, $a0, 1
	addi $a0, $a0, -1  # index of last non-leaf node
	
	jal heapsort
	sll $zero, $zero, 0
	
	lw $a0, arr_len
	addi $a0, $a0, -1  # index of last value
	
	jal heapsort_extraction
	sll $zero, $zero, 0
	
	li $v0, 4
	la $a0, arr_sorted_prompt  # print sorted prompt
	syscall
	
	lw $t0, 0($sp)
	la $t1, arr_len
	sw $t0, 0($t1)  # restore original value of arr_len
	
	addi $sp, $sp, 4  # restore memory
	
	li $a1, 0  # init index to 0
	
	jal print_arr  # print sorted array
	sll $zero, $zero, 0
	
	li $v0, 10  # exit
	syscall
	

# --------------------------------
# a0 = index of last non-leaf node
# --------------------------------
heapsort:
	addi $sp, $sp, -8
	sw $ra, 0($sp)  # store return for jal heapify
	sw $a0, 4($sp)  # store a0 for jal heapify

	jal heapify
	sll $zero, $zero, 0
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	
	addi $a0, $a0, -1  # move the index to the previous non-leaf node
	
	bgez $a0, heapsort  # if index is in array bounds, repeat
	sll $zero, $zero, 0
	
	jr $ra

# ------------------------------------------------------
# a0 contains the index of the last value in reduced arr
# ------------------------------------------------------
heapsort_extraction:
	addi $sp, $sp, -8
	sw $ra, 0($sp)  # store return for jal heapify
	sw $a0, 4($sp)  # store a0 for jal heapify
	
	la $t0, arr
	la $t1, arr_len
	
	sll $t2, $a0, 2
	add $t2, $t2, $t0  # location of last val in arr
	
	# swap arr[0] and arr[last]
	lw $t3, 0($t0)
	lw $t4, 0($t2)
	sw $t3, 0($t2)
	sw $t4, 0($t0)
	
	lw $t5, 0($t1)
	addi $t5, $t5, -1
	sw $t5, 0($t1)  # arr_length--
	
	add $a0, $zero, $zero
	jal heapify  # heapify at new root
	sll $zero, $zero, 0
	
	lw $ra, 0($sp)  # reobtain return address
	lw $a0, 4($sp)  # reobtain final index
	addi $sp, $sp, 8
	
	addi $a0, $a0, -1  # new final index
	
	bgtz $a0, heapsort_extraction  # arr_len > 0 repeat
	sll $zero, $zero, 0
	
	jr $ra

# -----------------------------
# a0 contains parent node index
# -----------------------------
heapify:
	addi $sp, $sp, -8
	sw $ra, 0($sp)  # store return for recursive calls
	sw $a0, 4($sp)  # store i for recursive calls & largest checks
	
	sll $s0, $a0, 1
	addi $s0, $s0, 1  # s0 contains index of i->left
	
	sll $s1, $a0, 1
	addi $s1, $s1, 2  # s1 contains index of i->right
	
	la $t0, arr  # store &arr[]
	
	sll $s2, $a0, 2
	add $s2, $s2, $t0
	lw $s2, 0($s2)  # s2 contains arr[largest]
	
	sll $s3, $s0, 2
	add $s3, $s3, $t0
	lw $s3, 0($s3)  # s3 contains arr[i->left] 
	
	sll $s4, $s1, 2
	add $s4, $s4, $t0
	lw $s4, 0($s4)  # s4 contains arr[i->right]
	
left_largest_checks:
	lw $t0, arr_len  # obtain arr_len
	la $t1, arr  # obtain arr address
	
	bge $s0, $t0, right_largest_checks  # skip swap if left >= n
	sll $zero, $zero, 0
	
	bge $s2, $s3, right_largest_checks  # skip swap if arr[largest] >= arr[i->left]
	sll $zero, $zero, 0
	
	move $a0, $s0  # largest = left
	
	sll $s2, $a0, 2
	add $s2, $s2, $t1
	lw $s2, 0($s2)  # set s2 to the new largest

right_largest_checks:
	lw $t0, arr_len  # obtain arr_len
	
	bge $s1, $t0, root_largest_checks  # skip swap if right >= n
	sll $zero, $zero, 0
	
	bge $s2, $s4, root_largest_checks  # skip swap if arr[largest] >= arr[i->right]
	sll $zero, $zero, 0
	
	move $a0, $s1  # largest = right
	
root_largest_checks:
	la $t0, arr  # store &arr[]
	lw $t1, 4($sp)  # reobtain original largest index
	
	beq $a0, $t1, heapify_return  # skip swap if root != largest
	
	sll $t2, $a0, 2
	add $t2, $t2, $t0  # arr[largest]
	
	sll $t3, $t1, 2
	add $t3, $t3, $t0  # arr[i]
	
	# swap arr[largest] and arr[i]
	lw $t4, 0($t2)
	lw $t5, 0($t3)
	sw $t4, 0($t3)
	sw $t5, 0($t2)
	
	add $t0, $zero, $zero  # reset t0 because jal
	add $t1, $zero, $zero  # reset t1 because jal
	
	jal heapify
	sll $zero, $zero, 0

heapify_return:
	lw $ra, 0($sp)  # restore return for... returning
	lw $a0, 4($sp)  # restore i for heapsort iteration
	addi $sp, $sp, 8
	
	jr $ra
	
	
# --------------------
# a1 contains i
# a0 free for syscalls
# --------------------
print_arr:
	la $t0, arr  # arr address
	la $t1, arr_len  # arr_len address
	
	sll $t2, $a1, 2
	add $t0, $t0, $t2  # adjust index for word size
	
	lw $t0, 0($t0)  # obtain arr[i]
	lw $t1, 0($t1)  # obtain arr_len
	
	li $v0, 1
	move $a0, $t0
	syscall  # print arr[i]
	
	li $v0, 4
	la $a0, spacer
	syscall  # format next print
	
	addi $a1, $a1, 1  # i++
	
	blt $a1, $t1, print_arr  # call if i < arr_len
	
	jr $ra  # return
	

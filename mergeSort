.data
	# actual data
	arr: .word 1, 5, 44, 32, 944, 2, 12, 43, 78, 8, 111111111, 21
	arr_len: .word 12
	
	# temporary arrays for merging
	arr_left: .space 44
	arr_right: .space 44
	
	# formatting
	unsorted_prompt: .asciiz "Original array: \n"
	sorted_prompt: .asciiz "Sorted array: \n"
	spacer: .ascii ", "
	nl: .ascii "\n"
	
.text
.globl main

main:
	# formatting
	li $v0, 4
	la $a0, unsorted_prompt
	syscall
	
	# print unsorted
	li $a1, 0
	jal print_arr
	sll $zero, $zero, 0
	
	add $a0, $zero, $zero  # set first index of arr
	lw $a1, arr_len
	addi $a1, $a1, -1  # set last index of arr
	
	jal mergesort
	sll $zero, $zero, 0
	
	# formatting
	li $v0, 4
	la $a0, sorted_prompt
	syscall
	
	# print sorted
	li $a1, 0
	jal print_arr
	sll $zero, $zero, 0
	
	# exit
	li $v0, 10
	syscall
	
# ---------------------------------
# a0 contains left, a1 contains right
# ---------------------------------
mergesort:
	# reserve memory space
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	# if left >= right return
	ble $a1, $a0, mergesort_return
	sll $zero, $zero, 0
	
	# calculate mid
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	add $t0, $a0, $a1
	srl $t0, $t0, 1
	
	lw $a0, 4($sp)  # a0 contains left
	addi $a1, $t0, 0  # a1 contains mid
	jal mergesort
	sll $zero, $zero, 0
	
	# recalculate mid
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	add $t0, $a0, $a1
	srl $t0, $t0, 1
	
	addi $a0, $t0, 1  # a0 contains mid + 1
	lw $a1, 8($sp)  # a1 contains right
	jal mergesort
	sll $zero, $zero, 0
	
	# recalculate mid
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	add $t0, $a0, $a1
	srl $t0, $t0, 1
	
	lw $a0, 4($sp)  # a0 contains left
	move $a1, $t0  # a1 contains mid
	lw $a2, 8($sp)  # a2 contains right
	jal merge
	sll $zero, $zero, 0

mergesort_return:
	# return memory space
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	
	# reset t0 and t1 bc jal
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	
	jr $ra  # return
	
# ----------------------------------------------------
# a0 contains left, a1 contains mid, a2 contains right
# ----------------------------------------------------
merge:
	# reserve memory space
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)

	sub $s0, $a1, $a0	
	addi $s0, $s0, 1  # n1
	sub $s1, $a2, $a1  # n2
	
	# fill left temporary subarray
	li $a0, 0  # set i to 0
	lw $a1, 4($sp)  # set a1 to left
	jal move_to_left
	sll $zero, $zero, 0
	
	# fill right temporary subarray
	li $a0, 0  # set i to 0
	lw $a1, 8($sp)  # set a1 to mid
	jal move_to_right
	sll $zero, $zero, 0
	
	# load initial values for the re-merge
	add $s2, $zero, $zero  # i = 0
	add $s3, $zero, $zero  # j = 0
	lw $s4, 4($sp)  # k = left

merge_temporary_arrays:
	bge $s2, $s0, merge_remaining_left  # leave loop on i >= n1
	sll $zero, $zero 0
	
	bge $s3, $s1, merge_remaining_left  # leave loop on j >= n2
	sll $zero, $zero, 0
	
	la $t0, arr_left
	la $t1, arr_right
	
	sll $t2, $s2, 2
	sll $t3, $s3, 2
	
	add $t2, $t2, $t0
	add $t3, $t3, $t1
	
	lw $t2, 0($t2)  # L[i]
	lw $t3, 0($t3)  # R[j]
	
	ble $t2, $t3, set_to_left
	sll $zero, $zero, 0
	
	# below is set_to_right
	
	la $t4, arr
	sll $t5, $s4, 2
	add $t4, $t4, $t5  # location of arr[k]
	
	sw $t3, 0($t4)  # arr[k] = R[j]
	
	addi $s3, $s3, 1  # j++
	addi $s4, $s4, 1  # k++
	
	j merge_temporary_arrays
		
set_to_left:
	la $t0, arr
	la $t1, arr_left
	
	sll $t2, $s4, 2
	sll $t3, $s2, 2
	
	add $t2, $t2, $t0  # location of arr[k]
	add $t3, $t3, $t1  # location of L[i]
	
	lw $t3, 0($t3)  # get L[i]
	sw $t3, 0($t2)  # arr[k] = L[i]

	addi $s2, $s2, 1  # i++
	addi $s4, $s4, 1  # k++
	
	j merge_temporary_arrays
	
merge_remaining_left:
	# once L is empty, merge R
	bge $s2, $s0, merge_remaining_right
	
	la $t0, arr
	la $t1, arr_left
	
	sll $t2, $s4, 2
	sll $t3, $s2, 2
	
	add $t2, $t2, $t0  # location of arr[k]
	add $t3, $t3, $t1  # location of L[i]
	
	lw $t3, 0($t3)  # get L[i]
	sw $t3, 0($t2)  # arr[k] = L[i]
	
	addi $s2, $s2, 1  # i++
	addi $s4, $s4, 1  # k++
	
	j merge_remaining_left
	
merge_remaining_right:
	# once R is empty, exit
	bge $s3, $s1, merge_exit
	
	la $t0, arr
	la $t1, arr_right
	
	sll $t2, $s4, 2
	sll $t3, $s3, 2
	
	add $t2, $t2, $t0  # location of arr[k]
	add $t3, $t3, $t1  # location of R[i]
	
	lw $t3, 0($t3)  # get R[i]
	sw $t3, 0($t2)  # arr[k] = R[i]
	
	addi $s3, $s3, 1  # j++
	addi $s4, $s4, 1  # k++
	
	j merge_remaining_right

merge_exit:
	# return memory space
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addi $sp, $sp, 16
	
	# reset t0 and t1 bc jal
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	
	jr $ra	
	
# -------------------------------
# a0 contains i, a1 contains left
# -------------------------------
move_to_left:
	la $t0, arr
	la $t1, arr_left
	
	# obtain arr[left + i] 
	add $t2, $a0, $a1
	sll $t2, $t2, 2
	add $t0, $t0, $t2
	lw $t0, 0($t0)
	
	# obtain L[i]
	sll $t3, $a0, 2
	add $t3, $t3, $t1
	
	sw $t0, 0($t3)  # L[i] = arr[left + i]
	
	addi $a0, $a0, 1  # j++
	
	# i < n1, call again
	blt $a0, $s0, move_to_left
	sll $zero, $zero, 0
	
	jr $ra  # return
	
# ------------------------------
# a0 contains j, a1 contains mid
# ------------------------------
move_to_right:
	la $t0, arr
	la $t1, arr_right
	
	# obtain arr[mid + j + 1] 
	add $t2, $a0, $a1
	addi $t2, $t2, 1
	sll $t2, $t2, 2
	add $t0, $t0, $t2
	lw $t0, 0($t0)
	
	# obtain R[i]
	sll $t3, $a0, 2
	add $t3, $t3, $t1
	
	sw $t0, 0($t3)  # R[j] = arr[right + j + 1]
	
	addi $a0, $a0, 1  # j++
	
	# j < n2 call again
	blt $a0, $s1, move_to_right
	sll $zero, $zero, 0
	
	jr $ra  # return


# ---------------------------
# a1 contains start index (i)
# ---------------------------
print_arr:
	# obtain arr_len
	la $t0, arr_len
	lw $t0, 0($t0)
	
	# obtain arr[i]
	la $t1, arr
	sll $t2, $a1, 2
	add $t1, $t1, $t2
	lw $t1, 0($t1)
	
	li $v0, 1
	move $a0, $t1  # print arr[i]
	syscall
	
	li $v0, 4
	la $a0, spacer  # format outputs
	syscall
	
	addi $a1, $a1, 1  # i++
	
	# if i < arr_len, repeat
	blt $a1, $t0, print_arr
	sll $zero, $zero, 0
	
	jr $ra  # return

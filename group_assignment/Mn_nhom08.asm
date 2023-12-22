# -----------------------------------------------------------
# Chuong trinh: Merge Sort so nguyen
# Tenn File: Mn_L07_08.asm
# Viet boi: Nguyen Duy Tung - Nguyen Thai Tan
# Mo ta: BTL mon Kien truc may tinh
# Viet chuong trinh sap xep 15 so nguyen bang giai thuat Merge Sort.
# File dau vao doc tu INT15.BIN va thuc hien in tung buoc cua qua trinh thuc hien
# -----------------------
# Data segment
# -----------------------
	.data
# Dia chi file:
	fileName:		.asciiz	"C:/Users/Tung Nguyen/Downloads/HK221/KTMT/Assignment/BTL_nhom/INT15.BIN"
# Dinh nghia cac bien va cau nhac nhap du lieu
	input_str:		.asciiz	"Initial array: "
	output_str:		.asciiz	"Sorted array: "
	comma:		.asciiz	", "
	space:		.asciiz	" "
	openBracket:	.asciiz	"["
	closeBracket:	.asciiz	"]"
	endline:		.asciiz	"\n"
	readFile_str:	.asciiz	"Doc du lieu dau vao tu file BIN tren dia INT15.BIN vao array:"
	aux_arr:		.word		0:15
	arr:			.space	60			# mang chua 15 phan tu
# ------------------------
# Code segment
# ------------------------
	.text
	.globl main
# main program body:
main:
	jal	read_file
	
	jal	initial_value
	
	# Bat dau code Merge Sort:
	la	$s7, arr			# load address cua arr vao $s7
	addi	$a1, $0, 0			# $a1 = left
	addi	$a2, $0, 14			# $a2 = right
	
	jal	mergeSort
	
	jal	final_result
	
	# Ket thuc chuong trinh:
	li	$v0, 10
	syscall
	
mergeSort:
	slt	$t0, $a1, $a2		# if (left < right) $t0 = 1 else $t0 = 0
	beq	$t0, $0, endMergeSort	# if (left >= right ($t0 = 0)) return;
	
	# Tao mot stack 4 ngan de luu tru ($ra, left, mid, right):
	addi	$sp, $sp, -16 		# phan bo 4 ngan tren stack
	sw	$ra, 12($sp)		# luu return address vao stack
	sw	$a1, 8($sp)	       	# luu $a1(left) vao stack
	sw	$a2, 4($sp)        	# luu $a2(right) vao stack
	
	add	$s0, $a1, $a2		# mid = left + right
	sra	$s0, $s0, 1			# mid = (left + right)/2
	sw	$s0, 0($sp) 		# luu $s0(mid) vao stack
	
	# In ra "["
	la	$a0, openBracket
	addi	$v0, $0, 4		
	syscall
	
	add	$t1, $a1, $0 		# $t1 = left
	add	$t2, $s0, $0		# $t2 = mid
	
	# In mang tu left -> mid:
	jal	print_array
	
	# In ra "]"
	la	$a0, closeBracket	
	addi	$v0, $0, 4		
	syscall
	
	# In ra khoang cach " "
	la	$a0, space	
	addi	$v0, $0, 4		
	syscall
	
	# In ra "["
	la	$a0, openBracket
	addi	$v0, $0, 4		
	syscall
	
	addi	$t1, $s0, 1 		# $t1 = mid + 1
	add	$t2, $a2, $0		# $t2 = right
	
	# In mang tu mid + 1 -> right:
	jal	print_array
	
	# In ra "]"
	la	$a0, closeBracket	
	addi	$v0, $0, 4		
	syscall
	
	# In ra khoang cach " "
	la	$a0, space	
	addi	$v0, $0, 4		
	syscall
	
	# In xuong dong
	la	$a0, endline
	addi	$v0, $0, 4
	syscall
	
	add	$a2, $s0, $0 		# truyen argument right = mid de goi de quy
	jal	mergeSort			# mergeSort(array, left, mid) cho nua dau arr
	
	lw	$s0, 0($sp)			# load mid tu stack da luu vao lai $s0
	addi	$s1, $s0, 1			# $s1 = mid + 1
	lw	$a2, 4($sp) 		# load right tu stack da luu vao lai $a2
	add	$a1, $s1, $0 		# truyen argument left = mid + 1 de goi de quy
	jal	mergeSort 			# mergeSort(array, mid + 1, right) cho nua sau arr
	
	lw	$a1, 8($sp) 		# load left tu stack da luu vao lai $a1
	lw	$a2, 4($sp)  		# load high tu stack da luu vao lai $a2
	lw	$a3, 0($sp) 		# load mid tu stack da luu vao $a3
	
	jal	mergeTwoSortedArray	# mergeTwoSortedArray(array, left, mid, right)
	
	# In ra "["
	la	$a0, openBracket
	addi	$v0, $0, 4		
	syscall
	
	add	$t1, $a1, $0 		# $t1 = left
	add	$t2, $a2, $0		# $t2 = right
	
	# In mang tu left -> right:
	jal	print_array
	
	# In ra "]"
	la	$a0, closeBracket	
	addi	$v0, $0, 4		
	syscall
	
	# In xuong dong:
	la	$a0, endline
	addi	$v0, $0, 4
	syscall
	
	lw	$ra, 12($sp)		# thu hoi thanh ghi $ra tu stack
	addi	$sp, $sp, 16 		# thu hoi stack pointer
	jr	$ra
	
endMergeSort:
	jr	$ra
	
mergeTwoSortedArray:
	add	$s0, $a1, $0			# $s0 = i = left
	add	$s1, $a1, $0			# $s1 = j = left
	addi	$s2, $a3, 1				# $s2 = k = mid + 1
	
while_1: 
	slt	$t7, $a3, $s0			# if(mid < i) $t7 = 1 else $t7 = 0
	bne	$t7, $0, while_2			# if($t7 = 1) <=> if(mid < i) => while_2
	
	slt	$t7, $a2, $s2			# if(right < j) $t7 = 1 else $t7 = 0
	bne	$t7, $0, while_2			# if($t7 = 1) <=> if(right < j) => while_2
	
	j	If					# if (i <= mid && j <= right)
	
If:
	sll	$t0, $s0, 2				# $t0 = i*4
	add	$t0, $t0, $s7			# $t0 = address arr[i]
	lw	$t1, 0($t0)				# $t1 = arr[i]
	sll	$t2, $s2, 2				# $t2 = j*4
	add	$t2, $t2, $s7			# $t2 = address arr[j]
	lw	$t3, 0($t2)				# $t3 = arr[j]
	
	slt	$t7, $t3, $t1			# if(arr[j] < arr[i]) $t7 = 1 else $t7 = 0
	bne	$t7, $0, Else			# if(arr[j] < arr[i]) => jump to Else
	
	la	$t4, aux_arr			# load address cua aux_arr vao $t4
	sll	$t5, $s1, 2				# $t5 = k*4
	add	$t4, $t4, $t5			# $t4 = address aux_arr[k]
	sw	$t1, 0($t4)				# arr[i] = aux_arr[k]
	addi	$s1, $s1, 1				# k++
	addi	$s0, $s0, 1				# i++
	j	while_1				# tiep tuc vong lap while_1
	
Else:
	sll	$t2, $s2, 2				# $t2 = j*4
	add	$t2, $t2, $s7			# $t2 = address arr[j]
	lw	$t3, 0($t2)				# $t3 = arr[j]
	
	la	$t4, aux_arr			# load address cua aux_arr vào $t4
	sll	$t5, $s1, 2				# $t5 = k*4
	add	$t4, $t4, $t5			# $t4 = address aux_arr[k]
	sw	$t3, 0($t4)				# arr[j] = aux_arr[k]
	addi	$s1, $s1, 1				# k++
	addi	$s2, $s2, 1				# j++
	j	while_1				# tiep tuc vong lap while_1

while_2:
	blt	$a3, $s0, while_3 		# if mid < i
	sll	$t0, $s0, 2				# $t0 = i*4
	add	$t0, $t0, $s7			# $t0 = address arr[i]
	lw	$t1, 0($t0)				# $t1 = arr[i]
	la	$t2, aux_arr			# load address cua aux_arr vao $t2
	sll	$t3, $s1, 2     			# $t3 = k*4
	add	$t3, $t3, $t2			# $t3 = address arr[k]
	sw	$t1, 0($t3) 			# arr[k] = $t1
	addi	$s1, $s1, 1   			# k++
	addi	$s0, $s0, 1   			# i++
	j	while_2				# tiep tuc vong lap while_2
	
while_3:
	blt	$a2,  $s1, for1			# if(right < j) => jump to for1
	sll	$t2, $s2, 2    			# $t0 = j*4
	add	$t2, $t2, $s7  			# $t0 = address arr[j]
	lw	$t3, 0($t2)     			# $t1 = arr[j]
	
	la	$t4, aux_arr			# load address cua aux_arr vao $t4
	sll	$t5, $s1, 2	   			# $t2 = k*4
	
	add	$t4, $t4, $t5  			# $t2 = address arr[k]
	sw	$t3, 0($t4)     			# aux_arr[k] = $t1
	addi	$s1, $s1, 1   			# k++
	addi	$s2, $s2, 1   			# j++
	j	while_3				# tiep tuc vong lap while_3

for1:
	add	$t0, $a1, $0			# $t1 = left
	addi	$t1, $a2, 1 			# $t2 = right + 1
	la	$t4, aux_arr			# load dia chi aux_arr
	j	for2					# jump to for2
for2:
	slt	$t7, $t0, $t1  			# if(left < right + 1) $t0 = 1
	beq	$t7, $0, end_sort			# if ($t0 == 0) ket thuc chuong trinh Merge sort
	sll	$t2, $t0, 2   			# $t2 = i*4
	add	$t3, $t2, $s7			# arr[$t7]
	add	$t5, $t2, $t4			# aux_arr[$t5]
	lw	$t6, 0($t5)				# $t6 = aux_arr[i]
	sw	$t6, 0($t3)   			# arr[i] = aux_arr[i]
	addi	$t0, $t0, 1 			# i++
	j	for2 					# tiep tuc vong lap for2
	
end_sort:
	jr	$ra
	
# read file INT15.BIN vao arr:
read_file:
	# open file:
	addi	$v0, $0, 13			# syscall code cua lenh mo file = 13
	la	$a0, fileName		# doc qua ten file
	addi	$a1, $0, 0			# flag = 0: read only
	addi	$a2, $0, 0			# flag = 0: read only
	syscall
	move	$s0, $v0			# luu tap tin mo ta $s0 = file
	
	# read file:
	addi	$v0, $0, 14			# syscall code cua lenh doc file = 14
	move	$a0, $s0			# $s0 chua tap tin mo ta
	la	$a1, arr			# bo dem chua du lieu cua toan bo file
	la 	$a2, 60			# ma cung chieu dai cua bo nho dem
	syscall
	
	# In ra cau lenh doc du lieu:
	la	$a0, readFile_str
	addi	$v0, $0, 4
	syscall
	
	# In xuong dong:
	la	$a0, endline
	addi	$v0, $0, 4
	syscall
	
	# close file:
	li	$v0, 16			# syscall code cua dong file = 16
	move	$a0, $s0
	syscall
	
	jr	$ra
	
# Ham in ra mang theo tung buoc cac qua trinh Merge Sort:
print_array:
	la	$t4, arr				# $t4 = address arr[]
	print_loop:
		beq	$t1, $t2, end_print	# if ($t1 == $t2) => end_print
		sll	$t3, $t1, 2			# $t3 = i*4
		add	$t3, $t3, $t4		# $t3 = address arr[i]
		lw	$t0, 0($t3)			# $t0 = arr[i]
		
		# In ra arr[i]
		add	$a0, $t0, $0
		addi	$v0, $0, 1				
		syscall
		
		# In ra ", "
		la	$a0, comma
		addi	$v0, $0, 4			
		syscall
		addi	$t1, $t1, 1			# i++
		
		j	print_loop			# tiep tuc vong lap print_loop
	end_print:
		sll	$t3, $t1, 2			# $t3 = i*4
		add	$t3, $t3, $t4		# $t3 = address arr[i]
		lw	$t0, 0($t3)			# $t0 = arr[i]
		# In ra phan tu cuoi cung
		add	$a0, $t0, $0
		addi	$v0, $0, 1				
		syscall
		
		jr $ra
		
# Ham in mang dau vao [..., ..., ...]:
initial_value:
	# In ra "Initial array: "
	la	$a0, input_str
	addi	$v0, $0, 4
	syscall
	
	# In ra "["
	la	$a0, openBracket
	addi	$v0, $0, 4
	syscall
		
	# index i = 0
	addi	$t0, $0, 0
	iv_while:
		# In lan luot cac phan tu trong mang toi so gan cuoi:
		beq	$t0, 56, iv_exit
		lw	$t6, arr($t0)
		addi	$t0, $t0, 4
		# In ra so hien tai tai vi tri index:
		li	$v0, 1
		move	$a0, $t6
		syscall
		# In ra khoang cach ", ":
		li	$v0, 4
		la	$a0, comma
		syscall
		# Tiep tuc vong lap khi chua hoan thanh dieu kien:
		j	iv_while
	iv_exit:
		# In ra so cuoi cung:
		lw	$t6, arr($t0)
		addi	$t0, $t0, 4
		li	$v0, 1
		move	$a0, $t6
		syscall
		# In ra "]"
		la	$a0, closeBracket
		addi	$v0, $0, 4
		syscall
		# In xuong dong
		la	$a0, endline
		addi	$v0, $0, 4
		syscall
		# In xuong dong
		la	$a0, endline
		addi	$v0, $0, 4
		syscall
		
		jr	$ra
	
# In ra ket qua cuoi cung (Sorted Array):
final_result:
	# In xuong dong
	la	$a0, endline
	addi	$v0, $0, 4
	syscall
	
	# In "Sorted array: "
	la	$a0, output_str
	addi	$v0, $0, 4
	syscall
	
	# In ra "["
	la	$a0, openBracket
	addi	$v0, $0, 4
	syscall
	
	# index i = 0
	addi	$t0, $0, 0
	fr_while:
		# In lan luot cac phan tu trong mang toi so gan cuoi:
		beq	$t0, 56, fr_exit
		lw	$t6, arr($t0)
		addi	$t0, $t0, 4
		# In ra so hien tai tai vi tri index:
		li	$v0, 1
		move	$a0, $t6
		syscall
		# In ra khoang cach ", ":
		li	$v0, 4
		la	$a0, comma
		syscall
		# Tiep tuc vong lap khi chua hoan thanh dieu kien:
		j	fr_while
	fr_exit:
		# In ra so cuoi cung:
		lw	$t6, arr($t0)
		addi	$t0, $t0, 4
		li	$v0, 1
		move	$a0, $t6
		syscall
		# In ra "]"
		la	$a0, closeBracket
		addi	$v0, $0, 4
		syscall
		
		jr	$ra

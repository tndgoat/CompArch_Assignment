# -----------------------------------------------------------
# Chuong trinh: Tinh xap xi so PI bang cach lay ngau nhien 100000 diem
# Ten File: Mn_2115232.asm
# Viet boi: Nguyen Duy Tung
# Mo ta: Bai tap lon ca nhan mon Kien Truc May Tinh (TH)
# Theo yeu cau de bai la in ket qua ra man hinh de kiem tra thi:
# trong phan code cho de bai nay em co thuc hien in ra cac gia tri lay ngau nhien
# de kiem tra tinh dung dan trong cac buoc tinh toan duoc luu tren nhung thanh ghi
# -----------------------------------------------------------
# Data segment:
	.data
	.align 0
numOfPoint:		.word			100000		# 100000 point(x, y)
floatNumOfPoint:	.float		100000.0
space:		.asciiz		"	"
endline:		.asciiz		"\n"
x4:			.float		4.0
radius:		.float		1.0
added_value:	.float		1.0
initial_value:	.float		0.0
output_str:		.asciiz		"PI ~= "
# Code segment:
	.text
	.globl main
main:
	# Khoi tao cac gia tri ban dau:
	la	$t4, numOfPoint			# address cua numOfPoint
	lw	$t4, 0($t4)				# $t4 = numOfPoint
	add	$t0, $0, $0				# Bien chay de thuc hien vong lap (i = 0)
	lwc1	$f4, floatNumOfPoint		# $f4 = 0 = (float) numOfPoint = 100000.0
	lwc1	$f5, initial_value		# $f5 = 0 = (float) so diem nam trong goc phan tu cua hinh tron
	lwc1	$f6, radius				# R = 1
	lwc1	$f7, added_value			# Gia tri gia tang = 1
	lwc1	$f8, x4				# x4 = 4 (4 goc phan tu cua hinh tron)
	
	loop:
		lwc1	$f2, initial_value	# $f2 = sum = 0
		# Lay ngau nhien toa do x:
		jal	random
		mov.s	$f12, $f0			# Copy $f0 vao $f12
		# In ra toa do x:
		li	$v0, 2			# Load 2 = print_float vao $v0
		syscall				# print value in $f12
		
		# In ra khoang cach
		li	$v0, 4			# Load 4 = print_string vao $v0
		la	$a0, space			# Load address cua space vao $a0
		syscall
		
		# Tinh toan sum:
		mul.s	$f12, $f12, $f12		# $f12 = x*x
		add.s	$f2, $f2, $f12		# sum = 0 + x*x = x*x luu vao $f2
		# In ra sum = x*x:
		li	$v0, 2			# Load 2 = print_float vao $v0
		syscall				# print value in $f12 = x*x
		
		# In ra khoang cach
		li	$v0, 4			# Load 4 = print_string vao $v0
		la	$a0, space			# Load address cua space vao $a0
		syscall
		
		# Lay ngau nhien toa do y:
		jal	random
		mov.s	$f12, $f0			# Copy $f0 vao $f12
		# In ra toa do y:
		li	$v0, 2			# Load 2 = print_float vao $v0
		syscall				# print value in $f12
		
		# In ra khoang cach
		li	$v0, 4			# Load 4 = print_string vao $v0
		la	$a0, space			# Load address cua space vao $a0
		syscall
		
		# Tinh toan sum:
		mul.s	$f12, $f12, $f12		# $f12 = y*y
		add.s	$f2, $f2, $f12		# sum = x*x + y*y
		mov.s	$f12, $f2			# Copy $f2 vao $f12 de thuc hien in ra
		# In ra sum = x*x + y*y:
		li	$v0, 2			# Load 2 = print_float vao $v0
		syscall				# print value in $f12
		
		# In xuong dong sau moi truong hop lay ngau nhien mot diem:
		li	$v0, 4			# Load 4 = print_string vao $v0
		la	$a0, endline		# Load address cua endline vao $a0
		syscall
		
		# Dieu kien diem nam trong hinh tron:
		# kiem tra dieu kien (sum = x*x + y*y) < (radius = 1)
		c.lt.s	$f2, $f6
		
		# if true:
		bc1t		true
	
		addi	$t0, $t0, 1		# i++
		slt	$t5, $t0, $t4	# if (i < numOfPoint) $t5 = 1 else $t5 = 0
		bne	$t5, $0, loop	# if ($t5 != 0 <=> $t5 = 1) => tiep tuc vong lap
		
		# Thuc hien neu dieu kien dung:
		true:		
			add.s	$f5, $f5, $f7	# $f5++ (so diem nam trong goc phan tu cua hinh tron)
			addi	$t0, $t0, 1		# i++
			slt	$t5, $t0, $t4	# if (i < numOfPoint) $t5 = 1 else $t5 = 0
			bne	$t5, $0, loop	# if ($t5 != 0 <=> $t5 = 1) => tiep tuc vong lap
	
	# 4 x so diem nam trong goc phan tu cua hinh tron => so diem nam trong toan hinh tron:
	mul.s	$f12, $f8, $f5
	# Tinh so PI = so diem nam trong hinh tron / tong so diem lay ngau nhien:
	div.s	$f12, $f12, $f4
	# In xuong dong:
	li	$v0, 4			# Load 4 = print_string vao $v0
	la	$a0, endline		# Load address cua endline vao $a0
	syscall
	# In ra output_str:
	li	$v0, 4			# Load 4 = print_string vao $v0
	la	$a0, output_str		# Load address cua output_str vao $a0
	syscall
	# In ra gia tri xap xi cua PI:
	li	$v0, 2
	syscall
	
	# Ket thuc chuong trinh:
	li	$v0, 10
	syscall

random:
	# set seed
	li $v0, 40
	syscall
	# theo time
	li $v0, 30
	syscall
	# random float:
	li $v0, 43
	syscall
	jr $ra
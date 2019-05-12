.data
str1: .asciiz "\n\n Welcome to Fibonacci Sequence Calculator"
str2: .asciiz "\n\n Please input an index(N): "
str31: .asciiz "\n\n Using iterateFib   : The "
str32: .asciiz "\n\n Using recursFib    : The "
str33: .asciiz "\n\n Using proRecursFib : The "
str4: .asciiz " item in Fibonacci Sequence is "
str5: .asciiz "\n\n Continue(Y is again , others is exit)?"
str6: .asciiz "\n\n Bye~ Have a good day!\n"
str7: .asciiz "\n\n Wrong input . No negative!"
buf: .word 0
.text
main:
	la $a0,str1 	# 输出欢迎提示语
	li $v0,4
	syscall
again:
	la $a0,str2 	# 输出提示语
	li $v0,4
	syscall
	li $v0,5 		# 读取要打印的项数
	syscall
	bgez $v0,goon 	# 先来一个判断
	la $a0,str7 	# 如果输入的是负数，重新输入
	li $v0,4  
	syscall
	b again
goon:
	move $t0,$v0 	# 输入的是非负数，则符合要求，把N值放到$t0
firts:	
					# iterateFib 迭代法
	la $a0,str31 	# 输出 迭代提示语
	li $v0,4
	syscall
	move $a0,$t0 	# 输出N值
	li $v0,1
	syscall 
	la $a0,str4 	# 输出 提示语
	li $v0,4 
	syscall
	move $a0,$t0 	# 将N值赋给$a0
	addi $sp,$sp,-12 # 为函数调用申请函数栈空间
	sw $ra,8($sp) 	# 保存返回地址
    sw $a0,4($sp) 	# 存入参数 $a0
	jal iterateFib 	# 调用 迭代 函数
	lw $v0,($sp) 	# 从栈中取回返回值放到$v0
    lw $ra,8($sp) 	# 取回返回地址
    addi $sp,$sp,12 # 平衡栈空间
	bltz $v0,second # 由于函数定义中不符合规定的N值会返回-1，因此此处判断是否正确
					# 若是-1，则跳过不输出
	move $a0,$v0 	# 输出结果
	li $v0,1
	syscall
second:	
					# recursFib 普通递归法
	la $a0,str32 	# 输出 普通递归 提示语
	li $v0,4
	syscall
	move $a0,$t0 	# 输出N值
	li $v0,1
	syscall
	la $a0,str4 	# 输出提示语
	li $v0,4
	syscall
	move $a0,$t0 	# 将N值赋给$a0
	addi $sp,$sp,-12 # 为函数调用申请函数栈空间
    sw $ra,8($sp) 	# 保存返回地址
    sw $a0,4($sp) 	# 存入参数 $a0
    jal recursFib 	# 调用 普通递归 函数
    lw $v0,($sp) 	# 从栈中取回返回值放到$v0
    lw $ra,8($sp) 	# 取回返回地址
    addi $sp,$sp,12 # 平衡栈空间
	bltz $v0,third 	# 若返回-1，则跳过不输出
	move $a0,$v0 	# 输出结果
	li $v0,1
	syscall
third:	
					# proRecursFib 优化递归法
	la $a0,str33 	# 输出 优化递归提示语
	li $v0,4
	syscall
	move $a0,$t0 	# 输出N值
	li $v0,1
	syscall
	la $a0,str4 	# 输出提示语
	li $v0,4
	syscall
	li $a0,0 		# 初始参数1=0
	li $a1,1 		# 初始参数2=1
	move $a2,$t0 	# 参数3=N
	addi $sp,$sp,-20 # 为函数调用申请函数栈空间
	sw $a0,4($sp) 	# 存入参数1
	sw $a1,8($sp) 	# 存入参数2
	sw $a2,12($sp) 	# 存入参数3
	sw $ra,16($sp) 	# 保存返回地址
	jal proRecursFib # 调用 优化递归 函数
	lw $v0,($sp) 	# 从栈中取回返回值放到$v0
	lw $ra,16($sp) 	# 取回返回地址
	addi $sp,$sp,20 # 平衡栈空间
	bltz $v0,ask 	# 若返回-1，则跳过不输出
	move $a0,$v0 	# 输出结果
	li $v0,1
	syscall
ask:
	la $a0,str5 	# 输出提示语，是否继续执行
	li $v0,4
	syscall
	la $a0,buf 		# 读入用户输入
	li $a1,2
	li $v0,8
	syscall
	lw $t0,($a0) 	# 与字符 Y 作比较
	addi $t0,$t0,-0x59
	beqz $t0,again 	# 若相等，则继续执行，否则退出
	la $a0,str6 	# 输出退出提示语
	li $v0,4
	syscall
	li $v0,10 		# 退出程序
	syscall
########################
.data
iterStr1: .asciiz "\n\n Sorry the 32-bits register can't save so large a number QAQ~"
.text
iterateFib:
	addi $sp,$sp,-16 # 为临时变量开辟栈空间
    sw $s0,($sp) 	 # 以$s0,作为临时变量(a)，保存原值
    sw $s1,4($sp) 	 # 以$s1,作为临时变量(b)，保存原值
	sw $s2,8($sp) 	 # 以$s2,作为临时变量(c)，保存原值
	sw $s3,12($sp) 	 # 以$s3,作为临时变量(i)，保存原值
    lw $a0,20($sp) 	 # 从栈中取到参数(N) 赋给$a0
	addi $s0,$a0,-47 # 因为32-bits有限，这里令其不能计算超过第46项的元素，否则结果有误
	bltz $s0,ido1 	 # N<47则继续执行
	la $a0,iterStr1  # 否则输出提示语句并返回-1
	li $v0,4
	syscall
	li $s0,-1 		 # 返回-1
	b ov
ido1: 		 		 # 继续执行
	li $s0,0 		 # 初始化 a=0
	li $s1,1 		 # 初始化 b=1
	li $s3,0 		 # 初始化 i=0
lp: 		 		 # 迭代
	bge $s3,$a0,ov 	 # 若达到迭代终止条件(i=N),则返回结果
	addi $s3,$s3,1 	 # i++
	move $s2,$s0 	 # 迭代操作 c=a
	addu $s0,$s1,$s0 # 迭代操作 a=a+b
	move $s1,$s2 	 # 迭代操作 b=c
	b lp
ov: 				 # 迭代完成准备返回结果
	move $v0,$s0 	 # 此处$s0即可由错误返回处的(li $s0,-1)决定，也可有迭代过程的(addu 
					 # $s0,$s1,$s0)决定，保证了一致性
	lw $s0,($sp) 	 # 释放临时变量，恢复$s0
    lw $s1,4($sp) 	 # 释放临时变量，恢复$s1
	lw $s2,8($sp) 	 # 释放临时变量，恢复$s2
	lw $s3,12($sp) 	 # 释放临时变量，恢复$s3
	addi $sp,$sp,16  # 回收临时变量栈空间
	sw $v0,($sp) 	 # 存入返回结果
	jr $ra 			 # 返回caller处
########################
.data
recStr1: .asciiz "\n\n Sorry due to the bad efficiency of ordinary recursFib , I don't want do do it QAQ~"
.text
recursFib:
    addi $sp,$sp,-4 # 为临时变量开辟栈空间
    sw $s0,($sp) 	# 以$s0,作为临时变量(a)，保存原值
    lw $a0,8($sp) 	# 从栈中取到参数(N) 赋给$a0
	addi $s0,$a0,-25 # 由于递归效率问题，当N太大时，PCSpim上运行起来很慢，这里取25，若是N>25
					#则不采用此算法，否则需要等几分钟甚至十几分钟
	bltz $s0,ido2 	# N<25继续执行
	la $a0,recStr1 	# 否则输出提示语句并返回-1
	li $v0,4
	syscall
	li $v0,-1
	b retn
ido2:				# 继续执行
    move $v0,$a0	# 
    slti $s0,$v0,2  # 如果参数N<2
    bnez $s0,retn   # 直接返回 (if n<2 : return n)
    addi $a0,$a0,-1 # 否则执行递归
    addi $sp,$sp,-12 # 为递归recursFib(n-1)做准备
    sw $ra,8($sp)
    sw $a0,4($sp)
    jal recursFib   # recursFib(n-1)
    lw $v0,($sp)    # 取得recursFib(n-1)的返回值
    lw $ra,8($sp)	# 函数收尾工作
    addi $sp,$sp,12
    move $s0,$v0    # 将recursFib(n-1)的返回值暂存入$s0
    lw $a0,8($sp)   # 为递归recursFib(n-2)做准备
    addi $a0,$a0,-2
    addi $sp,$sp,-12
    sw $ra,8($sp)
    sw $a0,4($sp)
    jal recursFib	# recursFib(n-2)
    lw $v0,($sp)    # 取得recursFib(n-2)的返回值
    lw $ra,8($sp)   # 函数收尾工作
    addi $sp,$sp,12
    addu $v0,$v0,$s0 # 将两个递归函数的返回值合并( recursFib(n - 1) + recursFib(n - 2) )
retn:
    lw $s0,($sp) 	# 释放临时变量，恢复$s0 
    addi $sp,$sp,4  # 回收临时变量栈空间
    sw $v0,($sp)    # 存入返回结果
    jr $ra			# 返回caller处 
########################
.data
proStr1: .asciiz "\n\n Sorry the 32-bits register can't save so large a number QAQ~"
.text
proRecursFib:
	lw $a0,4($sp)	 # 从栈中取到参数(a)
	lw $a1,8($sp)	 # 从栈中取到参数(b)
	lw $a2,12($sp)	 # 从栈中取到参数(N)
	addi $v0,$a2,-47 # 判断N大小是否符合要求
	bltz $v0,ido3	 # 符合则继续执行
	la $a0,proStr1	 # 否则输出提示语句并返回-1
	li $v0,4
	syscall
	li $a0,-1
	b over
ido3:				 # 继续执行
	slti $v0,$a2,1	 # 递归基 n<1
	bnez $v0,over	 # 达到递归基,则直接返回(return a)
	addu $a1,$a1,$a0 # 递归操作 递归参数参数1=a+b 
	addi $a2,$a2,-1	 # 递归操作 递归参数参数3=n-1
	sw $a1,4($sp)	 # 修改栈空间原参数1处为a+b 
	sw $a0,8($sp)	 # 修改栈空间原参数2处为a
	sw $a2,12($sp)	 # 修改栈空间原参数3处为n-1 
	b proRecursFib	 # 再次执行函数
over:				 # 返回
	move $v0,$a0	 # 返回值为参数一内容(return a)
	sw $v0,($sp)	 # 将返回值存入栈
	jr $ra			 # 返回caller处 
	
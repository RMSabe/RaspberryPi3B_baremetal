@Mini Kernel for Raspberry Pi 3B
@Author: Rafael Sabe
@Email: rafaelmsabe@gmail.com

.section .text

@FUNCTION: compare two text strings
@args: r0 (input text1 buffer addr), r1 (input text2 buffer addr)
@return value: r0 (1 == equal / 0 == not equal)
_str_compare:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r0} @r12 - 8
	push {r1} @r12 - 12

	eor r2, r2, r2
	push {r2} @r12 - 16
	push {r2} @r12 - 20

	mov r1, r12
	sub r1, r1, #8
	ldr r0, [r1]

	_str_compare_getlen1:
	ldrb r1, [r0]
	cmp r1, #0
	beq _str_compare_gotlen1
	add r2, r2, #1
	add r0, r0, #1
	b _str_compare_getlen1
	_str_compare_gotlen1:
	mov r1, r12
	sub r1, r1, #16
	str r2, [r1]

	mov r1, r12
	sub r1, r1, #12
	ldr r0, [r1]

	eor r2, r2, r2

	_str_compare_getlen2:
	ldrb r1, [r0]
	cmp r1, #0
	beq _str_compare_gotlen2
	add r2, r2, #1
	add r0, r0, #1
	b _str_compare_getlen2
	_str_compare_gotlen2:
	mov r1, r12
	sub r1, r1, #20
	str r2, [r1]

	mov r1, r12
	sub r1, r1, #16
	ldr r2, [r1]

	sub r1, r1, #4
	ldr r3, [r1]

	cmp r2, r3
	bne _str_compare_returnfalse

	mov r1, r12
	sub r1, r1, #16
	ldr r3, [r1]
	sub r1, r1, #4
	eor r2, r2, r2
	str r2, [r1]

	_str_compare_loop:
	cmp r2, r3
	bhs _str_compare_endloop
	mov r3, r12
	sub r3, r3, #8
	ldr r0, [r3]
	sub r3, r3, #4
	ldr r1, [r3]
	add r0, r0, r2
	add r1, r1, r2
	ldrb r2, [r0]
	ldrb r3, [r1]
	cmp r2, r3
	bne _str_compare_returnfalse
	mov r1, r12
	sub r1, r1, #16
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r2, [r1]
	add r2, r2, #1
	str r2, [r1]
	b _str_compare_loop
	_str_compare_endloop:

	_str_compare_returntrue:
	mov r0, #1
	b _str_compare_return

	_str_compare_returnfalse:
	eor r0, r0, r0

	_str_compare_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]

	mov sp, r12
	pop {r12}

	bx r3


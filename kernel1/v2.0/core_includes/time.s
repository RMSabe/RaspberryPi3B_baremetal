@Mini Kernel for Raspberry Pi 3B
@Author: Rafael Sabe
@Email: rafaelmsabe@gmail.com

.section .text

@FUNCTION: delay runtime for a given number of cycles
@args: r0 (delay time)
_delay32:
	push {r12}
	mov r12, sp
	push {lr}
	push {r0}

	eor r1, r1, r1

	_delay32_loop:
	cmp r1, r0
	bhs _delay32_endloop
	add r1, r1, #1
	b _delay32_loop
	_delay32_endloop:

	_delay32_return:
	mov sp, r12
	pop {r12}
	bx lr


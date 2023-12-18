@Mini Kernel for Raspberry Pi 3B
@Author: Rafael Sabe
@Email: rafaelmsabe@gmail.com

.section .text

@FUNCTION: delay runtime for a given number of cycles
@args (push order): delay time
_delay32:
	pop {r0}
	eor r1, r1, r1

	_delay32_loop:
	cmp r1, r0
	bhs _delay32_endloop
	add r1, r1, #1
	b _delay32_loop
	_delay32_endloop:

	_delay32_return:
	bx lr


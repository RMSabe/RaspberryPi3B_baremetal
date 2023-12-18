@Mini Kernel for Raspberry Pi 3B
@Author: Rafael Sabe
@Email: rafaelmsabe@gmail.com

.equ STACKLIST_SIZE, 32
.equ TEXTBUF_SIZE, 32
.equ STACK_BP_ADDR, 0x00100000

.global _start

.section .text
_start:
_sysstart:
	ldr sp, =STACK_BP_ADDR

_sysmain:
@Add main routine here

_sysend:
	_sysend_loop:
	nop
	nop
	nop
	nop
	b _sysend_loop

.section .data

.align 4
_stacklist_index:
.long 0

_stacklist:
.fill STACKLIST_SIZE, 4, 0

_textbuf:
.fill TEXTBUF_SIZE, 1, 0

.align 4
.include "core_includes/time.s"
.include "peripheral_includes/gpio_ctrl.s"


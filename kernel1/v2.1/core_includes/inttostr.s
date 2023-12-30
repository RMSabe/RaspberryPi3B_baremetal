@Mini Kernel for Raspberry Pi 3B
@Author: Rafael Sabe
@Email: rafaelmsabe@gmail.com

.section .text

@FUNCTION: load unsigned 32bit integer into text buffer
@args: r0 (input value), r1 (output text buffer addr)
_loadstr_dec_u32:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12
	push {r1} @r12 - 16

	mov r4, r1

	eor r3, r3, r3
	orr r3, r3, #0x3b
	lsl r3, r3, #8
	orr r3, r3, #0x9a
	lsl r3, r3, #8
	orr r3, r3, #0xca
	lsl r3, r3, #8

	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	eor r3, r3, r3
	orr r3, r3, #0x05
	lsl r3, r3, #8
	orr r3, r3, #0xf5
	lsl r3, r3, #8
	orr r3, r3, #0xe1
	lsl r3, r3, #8

	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	eor r3, r3, r3
	orr r3, r3, #0x98
	lsl r3, r3, #8
	orr r3, r3, #0x96
	lsl r3, r3, #8
	orr r3, r3, #0x80

	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	eor r3, r3, r3
	orr r3, r3, #0x0f
	lsl r3, r3, #8
	orr r3, r3, #0x42
	lsl r3, r3, #8
	orr r3, r3, #0x40

	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	eor r3, r3, r3
	orr r3, r3, #0x01
	lsl r3, r3, #8
	orr r3, r3, #0x86
	lsl r3, r3, #8
	orr r3, r3, #0xa0

	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	eor r3, r3, r3
	orr r3, r3, #0x27
	lsl r3, r3, #8
	orr r3, r3, #0x10

	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	eor r3, r3, r3
	orr r3, r3, #0x03
	lsl r3, r3, #8
	orr r3, r3, #0xe8

	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	mov r3, #0x64
	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	mov r3, #0x0a
	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	and r0, r0, #0xff
	add r0, r0, #0x30
	strb r0, [r4]
	add r4, r4, #1

	eor r0, r0, r0
	strb r0, [r4]

	_loadstr_dec_u32_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: load signed 32bit integer into text buffer
@args: r0 (input value), r1 (output text buffer addr)
_loadstr_dec_s32:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r0} @r12 - 8
	push {r1} @r12 - 12

	eor r2, r2, r2
	orr r2, r2, #0x80
	lsl r2, r2, #24

	tst r0, r2
	beq _loadstr_dec_s32_pos

	_loadstr_dec_s32_neg:
	mov r2, #0x2d
	strb r2, [r1]
	add r1, r1, #1

	mvn r0, r0
	add r0, r0, #1

	_loadstr_dec_s32_pos:
	bl _loadstr_dec_u32

	_loadstr_dec_s32_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: load unsigned 16bit integer into text buffer
@args: r0 (input value), r1 (output text buffer addr)
_loadstr_dec_u16:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12
	push {r1} @r12 - 16

	mov r4, r1

	eor r1, r1, r1
	orr r1, r1, #0xff
	lsl r1, r1, #8
	orr r1, r1, #0xff

	and r0, r0, r1

	eor r3, r3, r3
	orr r3, r3, #0x27
	lsl r3, r3, #8
	orr r3, r3, #0x10

	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	eor r3, r3, r3
	orr r3, r3, #0x03
	lsl r3, r3, #8
	orr r3, r3, #0xe8

	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	mov r3, #0x64
	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	mov r3, #0x0a
	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	and r0, r0, #0xff
	add r0, r0, #0x30
	strb r0, [r4]
	add r4, r4, #1

	eor r0, r0, r0
	strb r0, [r4]

	_loadstr_dec_u16_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: load signed 16bit integer into text buffer
@args: r0 (input value), r1 (output text buffer addr)
_loadstr_dec_s16:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r0} @r12 - 8
	push {r1} @r12 - 12

	eor r2, r2, r2
	orr r2, r2, #0xff
	lsl r2, r2, #8
	orr r2, r2, #0xff

	and r0, r0, r2

	eor r2, r2, r2
	orr r2, r2, #0x80
	lsl r2, r2, #8

	tst r0, r2
	beq _loadstr_dec_s16_pos

	_loadstr_dec_s16_neg:
	mov r2, #0x2d
	strb r2, [r1]
	add r1, r1, #1

	eor r2, r2, r2
	orr r2, r2, #0xff
	lsl r2, r2, #8
	orr r2, r2, #0xff
	lsl r2, r2, #16

	orr r0, r0, r2

	mvn r0, r0
	add r0, r0, #1

	eor r2, r2, r2
	orr r2, r2, #0xff
	lsl r2, r2, #8
	orr r2, r2, #0xff

	and r0, r0, r2

	_loadstr_dec_s16_pos:
	bl _loadstr_dec_u16

	_loadstr_dec_s16_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: load unsigned 8bit integer into text buffer
@args: r0 (input value), r1 (output text buffer addr)
_loadstr_dec_u8:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12
	push {r1} @r12 - 16

	mov r4, r1

	and r0, r0, #0xff

	mov r3, #0x64
	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	mov r3, #0x0a
	udiv r1, r0, r3
	mul r2, r1, r3
	sub r0, r0, r2
	and r1, r1, #0xff
	add r1, r1, #0x30
	strb r1, [r4]
	add r4, r4, #1

	and r0, r0, #0xff
	add r0, r0, #0x30
	strb r0, [r4]
	add r4, r4, #1

	eor r0, r0, r0
	strb r0, [r4]

	_loadstr_dec_u8_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: load signed 8bit integer into text buffer
@args: r0 (input value), r1 (output text buffer addr)
_loadstr_dec_s8:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r0} @r12 - 8
	push {r1} @r12 - 12

	and r0, r0, #0xff

	tst r0, #0x80
	beq _loadstr_dec_s8_pos

	_loadstr_dec_s8_neg:
	mov r2, #0x2d
	strb r2, [r1]
	add r1, r1, #1

	eor r2, r2, r2
	orr r2, r2, #0xff
	lsl r2, r2, #8
	orr r2, r2, #0xff
	lsl r2, r2, #8
	orr r2, r2, #0xff
	lsl r2, r2, #8

	orr r0, r0, r2

	mvn r0, r0
	add r0, r0, #1

	and r0, r0, #0xff

	_loadstr_dec_s8_pos:
	bl _loadstr_dec_u8

	_loadstr_dec_s8_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]

	mov sp, r12
	pop {r12}

	bx r3


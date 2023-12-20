@Mini Kernel for Raspberry Pi 3B
@Author: Rafael Sabe
@Email: rafaelmsabe@gmail.com

.equ GPIO_PINMODE_INPUT, 0
.equ GPIO_PINMODE_OUTPUT, 1
.equ GPIO_PINMODE_ALTFUNC0, 4
.equ GPIO_PINMODE_ALTFUNC1, 5
.equ GPIO_PINMODE_ALTFUNC2, 6
.equ GPIO_PINMODE_ALTFUNC3, 7
.equ GPIO_PINMODE_ALTFUNC4, 3
.equ GPIO_PINMODE_ALTFUNC5, 2

.equ GPIO_PUDCTRL_NOPULL, 0
.equ GPIO_PUDCTRL_PULLUP, 2
.equ GPIO_PUDCTRL_PULLDOWN, 1

.equ GPIO_BASE_ADDR, 0x3f200000

.equ GPIO_REGINDEX_FSEL0, 0x0
.equ GPIO_REGINDEX_FSEL1, 0x4
.equ GPIO_REGINDEX_FSEL2, 0x8
.equ GPIO_REGINDEX_FSEL3, 0xc
.equ GPIO_REGINDEX_FSEL4, 0x10
.equ GPIO_REGINDEX_FSEL5, 0x14
.equ GPIO_REGINDEX_OUTPUT0_SET, 0x1c
.equ GPIO_REGINDEX_OUTPUT1_SET, 0x20
.equ GPIO_REGINDEX_OUTPUT0_CLR, 0x28
.equ GPIO_REGINDEX_OUTPUT1_CLR, 0x2c
.equ GPIO_REGINDEX_INPUT0, 0x34
.equ GPIO_REGINDEX_INPUT1, 0x38
.equ GPIO_REGINDEX_EVENTDETECT0_STATUS, 0x40
.equ GPIO_REGINDEX_EVENTDETECT1_STATUS, 0x44
.equ GPIO_REGINDEX_REDGEDETECT0_ENABLE, 0x4c
.equ GPIO_REGINDEX_REDGEDETECT1_ENABLE, 0x50
.equ GPIO_REGINDEX_FEDGEDETECT0_ENABLE, 0x58
.equ GPIO_REGINDEX_FEDGEDETECT1_ENABLE, 0x5c
.equ GPIO_REGINDEX_HIGHDETECT0_ENABLE, 0x64
.equ GPIO_REGINDEX_HIGHDETECT1_ENABLE, 0x68
.equ GPIO_REGINDEX_LOWDETECT0_ENABLE, 0x70
.equ GPIO_REGINDEX_LOWDETECT1_ENABLE, 0x74
.equ GPIO_REGINDEX_ASYNC_REDGEDETECT0_ENABLE, 0x7c
.equ GPIO_REGINDEX_ASYNC_REDGEDETECT1_ENABLE, 0x80
.equ GPIO_REGINDEX_ASYNC_FEDGEDETECT0_ENABLE, 0x88
.equ GPIO_REGINDEX_ASYNC_FEDGEDETECT1_ENABLE, 0x8c
.equ GPIO_REGINDEX_PUDCTRL_ENABLE, 0x94
.equ GPIO_REGINDEX_PUDCTRL0, 0x98
.equ GPIO_REGINDEX_PUDCTRL1, 0x9c

.section .text

@FUNCTION: reset a GPIO pin
@args: r0 (pin number)
_gpio_reset_pin:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12

	mov r4, r0

	mov r1, #GPIO_PINMODE_INPUT
	bl _gpio_set_pinmode

	mov r0, r4
	mov r1, #GPIO_PUDCTRL_NOPULL
	bl _gpio_set_pudctrl

	mov r0, r4
	eor r1, r1, r1
	bl _gpio_enable_async_risingedge_detect

	mov r0, r4
	eor r1, r1, r1
	bl _gpio_enable_async_fallingedge_detect

	mov r0, r4
	eor r1, r1, r1
	bl _gpio_enable_risingedge_detect

	mov r0, r4
	eor r1, r1, r1
	bl _gpio_enable_fallingedge_detect

	mov r0, r4
	eor r1, r1, r1
	bl _gpio_enable_high_detect

	mov r0, r4
	eor r1, r1, r1
	bl _gpio_enable_low_detect

	mov r0, r4
	bl _gpio_get_event_detected

	_gpio_reset_pin_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: set pinmode of a GPIO pin
@args: r0 (pin number), r1 (pin mode)
_gpio_set_pinmode:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12
	push {r1} @r12 - 16

	and r1, r1, #0x7

	cmp r0, #53
	bhi _gpio_set_pinmode_return

	mov r2, #10
	udiv r3, r0, r2
	mul r4, r3, r2
	sub r0, r0, r4

	mov r2, #3
	mul r0, r0, r2

	ldr r4, =GPIO_BASE_ADDR

	teq r3, #0
	beq _gpio_set_pinmode_fsel0

	teq r3, #1
	beq _gpio_set_pinmode_fsel1

	teq r3, #2
	beq _gpio_set_pinmode_fsel2

	teq r3, #3
	beq _gpio_set_pinmode_fsel3

	teq r3, #4
	beq _gpio_set_pinmode_fsel4

	_gpio_set_pinmode_fsel5:
	add r4, r4, #GPIO_REGINDEX_FSEL5
	b _gpio_set_pinmode_l1

	_gpio_set_pinmode_fsel4:
	add r4, r4, #GPIO_REGINDEX_FSEL4
	b _gpio_set_pinmode_l1

	_gpio_set_pinmode_fsel3:
	add r4, r4, #GPIO_REGINDEX_FSEL3
	b _gpio_set_pinmode_l1

	_gpio_set_pinmode_fsel2:
	add r4, r4, #GPIO_REGINDEX_FSEL2
	b _gpio_set_pinmode_l1

	_gpio_set_pinmode_fsel1:
	add r4, r4, #GPIO_REGINDEX_FSEL1
	b _gpio_set_pinmode_l1

	_gpio_set_pinmode_fsel0:
	add r4, r4, #GPIO_REGINDEX_FSEL0

	_gpio_set_pinmode_l1:

	lsl r1, r1, r0
	mov r2, #0x7
	lsl r2, r2, r0
	mvn r2, r2

	ldr r3, [r4]
	and r3, r3, r2
	orr r3, r3, r1
	str r3, [r4]

	_gpio_set_pinmode_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: get current pinmode of a GPIO pin
@args: r0 (pin number)
@return value: r0 (pin mode)
_gpio_get_pinmode:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12

	cmp r0, #53
	bhi _gpio_get_pinmode_return

	mov r2, #10
	udiv r3, r0, r2
	mul r4, r3, r2
	sub r0, r0, r4

	mov r2, #3
	mul r0, r0, r2

	ldr r4, =GPIO_BASE_ADDR

	teq r3, #0
	beq _gpio_get_pinmode_fsel0

	teq r3, #1
	beq _gpio_get_pinmode_fsel1

	teq r3, #2
	beq _gpio_get_pinmode_fsel2

	teq r3, #3
	beq _gpio_get_pinmode_fsel3

	teq r3, #4
	beq _gpio_get_pinmode_fsel4

	_gpio_get_pinmode_fsel5:
	add r4, r4, #GPIO_REGINDEX_FSEL5
	b _gpio_get_pinmode_l1

	_gpio_get_pinmode_fsel4:
	add r4, r4, #GPIO_REGINDEX_FSEL4
	b _gpio_get_pinmode_l1

	_gpio_get_pinmode_fsel3:
	add r4, r4, #GPIO_REGINDEX_FSEL3
	b _gpio_get_pinmode_l1

	_gpio_get_pinmode_fsel2:
	add r4, r4, #GPIO_REGINDEX_FSEL2
	b _gpio_get_pinmode_l1

	_gpio_get_pinmode_fsel1:
	add r4, r4, #GPIO_REGINDEX_FSEL1
	b _gpio_get_pinmode_l1

	_gpio_get_pinmode_fsel0:
	add r4, r4, #GPIO_REGINDEX_FSEL0

	_gpio_get_pinmode_l1:

	mov r2, #0x7
	lsl r2, r2, r0

	ldr r1, [r4]
	and r1, r1, r2
	lsr r1, r1, r0

	mov r0, r1

	_gpio_get_pinmode_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: set pull up/down on a GPIO pin
@args: r0 (pin number), r1 (pudctrl)
_gpio_set_pudctrl:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12
	push {r1} @r12 - 16

	and r1, r1, #3

	cmp r0, #53
	bhi _gpio_set_pudctrl_return

	ldr r4, =GPIO_BASE_ADDR
	mov r3, r4

	cmp r0, #32
	bhs _gpio_set_pudctrl_reg1

	_gpio_set_pudctrl_reg0:
	add r4, r4, #GPIO_REGINDEX_PUDCTRL0
	b _gpio_set_pudctrl_l1

	_gpio_set_pudctrl_reg1:
	add r4, r4, #GPIO_REGINDEX_PUDCTRL1
	sub r0, r0, #32

	_gpio_set_pudctrl_l1:
	add r3, r3, #GPIO_REGINDEX_PUDCTRL_ENABLE

	mov r2, #1
	lsl r2, r2, r0

	str r1, [r3]
	str r2, [r4]

	_gpio_set_pudctrl_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: set level of a GPIO pin
@args: r0 (pin number), r1 (pin level)
_gpio_set_level:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12
	push {r1} @r12 - 16

	cmp r0, #53
	bhi _gpio_set_level_return

	ldr r4, =GPIO_BASE_ADDR

	eor r2, r2, r2
	mvn r2, r2

	cmp r0, #32
	bhs _gpio_set_level_output1

	_gpio_set_level_output0:

	tst r1, r2
	beq _gpio_set_level_output0_clr

	_gpio_set_level_output0_set:
	add r4, r4, #GPIO_REGINDEX_OUTPUT0_SET
	b _gpio_set_level_l1

	_gpio_set_level_output0_clr:
	add r4, r4, #GPIO_REGINDEX_OUTPUT0_CLR
	b _gpio_set_level_l1

	_gpio_set_level_output1:
	sub r0, r0, #32

	tst r1, r2
	beq _gpio_set_level_output1_clr

	_gpio_set_level_output1_set:
	add r4, r4, #GPIO_REGINDEX_OUTPUT1_SET
	b _gpio_set_level_l1

	_gpio_set_level_output1_clr:
	add r4, r4, #GPIO_REGINDEX_OUTPUT1_CLR

	_gpio_set_level_l1:

	mov r2, #1
	lsl r2, r2, r0

	str r2, [r4]

	_gpio_set_level_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: get level of a GPIO pin
@args: r0 (pin number)
@return value: r0 (pin level)
_gpio_get_level:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12

	cmp r0, #53
	bhi _gpio_get_level_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_get_level_input1

	_gpio_get_level_input0:
	add r4, r4, #GPIO_REGINDEX_INPUT0
	b _gpio_get_level_l1

	_gpio_get_level_input1:
	add r4, r4, #GPIO_REGINDEX_INPUT1
	sub r0, r0, #32

	_gpio_get_level_l1:
	mov r2, #1
	lsl r2, r2, r0

	ldr r3, [r4]

	tst r3, r2
	beq _gpio_get_level_returnfalse

	_gpio_get_level_returntrue:
	mov r0, #1
	b _gpio_get_level_return

	_gpio_get_level_returnfalse:
	eor r0, r0, r0

	_gpio_get_level_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: check if event was detected on GPIO pin
@args: r0 (pin number)
@return value: r0 (1 == event detected / 0 == no event detected)
_gpio_get_event_detected:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12

	cmp r0, #53
	bhi _gpio_get_event_detected_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_get_event_detected_reg1

	_gpio_get_event_detected_reg0:
	add r4, r4, #GPIO_REGINDEX_EVENTDETECT0_STATUS
	b _gpio_get_event_detected_l1

	_gpio_get_event_detected_reg1:
	add r4, r4, #GPIO_REGINDEX_EVENTDETECT1_STATUS
	sub r0, r0, #32

	_gpio_get_event_detected_l1:
	mov r2, #1
	lsl r2, r2, r0

	ldr r3, [r4]

	tst r3, r2
	beq _gpio_get_event_detected_returnfalse

	_gpio_get_event_detected_returntrue:
	str r2, [r4]
	mov r0, #1
	b _gpio_get_event_detected_return

	_gpio_get_event_detected_returnfalse:
	eor r0, r0, r0

	_gpio_get_event_detected_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: enable/disable rising edge detection on a GPIO pin
@args: r0 (pin number), r1 (bool enable)
_gpio_enable_risingedge_detect:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12
	push {r1} @r12 - 16

	cmp r0, #53
	bhi _gpio_enable_risingedge_detect_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_enable_risingedge_detect_reg1

	_gpio_enable_risingedge_detect_reg0:
	add r4, r4, #GPIO_REGINDEX_REDGEDETECT0_ENABLE
	b _gpio_enable_risingedge_detect_l1

	_gpio_enable_risingedge_detect_reg1:
	add r4, r4, #GPIO_REGINDEX_REDGEDETECT1_ENABLE
	sub r0, r0, #32

	_gpio_enable_risingedge_detect_l1:
	mov r2, #1
	lsl r2, r2, r0

	eor r3, r3, r3
	mvn r3, r3

	tst r1, r3
	beq _gpio_enable_risingedge_detect_disable

	_gpio_enable_risingedge_detect_enable:
	ldr r3, [r4]
	orr r3, r3, r2
	str r3, [r4]
	b _gpio_enable_risingedge_detect_return

	_gpio_enable_risingedge_detect_disable:
	mvn r2, r2
	ldr r3, [r4]
	and r3, r3, r2
	str r3, [r4]

	_gpio_enable_risingedge_detect_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: check if rising edge detection is enabled on a GPIO pin
@args: r0 (pin number)
@return value: r0 (1 == enabled / 0 == disabled)
_gpio_risingedge_detect_is_enabled:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12

	cmp r0, #53
	bhi _gpio_risingedge_detect_is_enabled_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_risingedge_detect_is_enabled_reg1

	_gpio_risingedge_detect_is_enabled_reg0:
	add r4, r4, #GPIO_REGINDEX_REDGEDETECT0_ENABLE
	b _gpio_risingedge_detect_is_enabled_l1

	_gpio_risingedge_detect_is_enabled_reg1:
	add r4, r4, #GPIO_REGINDEX_REDGEDETECT1_ENABLE
	sub r0, r0, #32

	_gpio_risingedge_detect_is_enabled_l1:
	mov r2, #1
	lsl r2, r2, r0

	ldr r3, [r4]

	tst r3, r2
	beq _gpio_risingedge_detect_is_enabled_returnfalse

	_gpio_risingedge_detect_is_enabled_returntrue:
	mov r0, #1
	b _gpio_risingedge_detect_is_enabled_return

	_gpio_risingedge_detect_is_enabled_returnfalse:
	eor r0, r0, r0

	_gpio_risingedge_detect_is_enabled_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: enable/disable falling edge detection on a GPIO pin
@args: r0 (pin number), r1 (bool enable)
_gpio_enable_fallingedge_detect:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12
	push {r1} @r12 - 16

	cmp r0, #53
	bhi _gpio_enable_fallingedge_detect_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_enable_fallingedge_detect_reg1

	_gpio_enable_fallingedge_detect_reg0:
	add r4, r4, #GPIO_REGINDEX_FEDGEDETECT0_ENABLE
	b _gpio_enable_fallingedge_detect_l1

	_gpio_enable_fallingedge_detect_reg1:
	add r4, r4, #GPIO_REGINDEX_FEDGEDETECT1_ENABLE
	sub r0, r0, #32

	_gpio_enable_fallingedge_detect_l1:
	mov r2, #1
	lsl r2, r2, r0

	eor r3, r3, r3
	mvn r3, r3

	tst r1, r3
	beq _gpio_enable_fallingedge_detect_disable

	_gpio_enable_fallingedge_detect_enable:
	ldr r3, [r4]
	orr r3, r3, r2
	str r3, [r4]
	b _gpio_enable_fallingedge_detect_return

	_gpio_enable_fallingedge_detect_disable:
	mvn r2, r2
	ldr r3, [r4]
	and r3, r3, r2
	str r3, [r4]

	_gpio_enable_fallingedge_detect_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: check if falling edge detection is enabled on a GPIO pin
@args: r0 (pin number)
@return value: r0 (1 == enabled / 0 == disabled)
_gpio_fallingedge_detect_is_enabled:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12

	cmp r0, #53
	bhi _gpio_fallingedge_detect_is_enabled_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_fallingedge_detect_is_enabled_reg1

	_gpio_fallingedge_detect_is_enabled_reg0:
	add r4, r4, #GPIO_REGINDEX_FEDGEDETECT0_ENABLE
	b _gpio_fallingedge_detect_is_enabled_l1

	_gpio_fallingedge_detect_is_enabled_reg1:
	add r4, r4, #GPIO_REGINDEX_FEDGEDETECT1_ENABLE
	sub r0, r0, #32

	_gpio_fallingedge_detect_is_enabled_l1:
	mov r2, #1
	lsl r2, r2, r0

	ldr r3, [r4]

	tst r3, r2
	beq _gpio_fallingedge_detect_is_enabled_returnfalse

	_gpio_fallingedge_detect_is_enabled_returntrue:
	mov r0, #1
	b _gpio_fallingedge_detect_is_enabled_return

	_gpio_fallingedge_detect_is_enabled_returnfalse:
	eor r0, r0, r0

	_gpio_fallingedge_detect_is_enabled_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: enable/disable asynchronous rising edge detection on a GPIO pin
@DESCRIPTION: asynchronous rising edge detection is like normal rising edge detection, however it's not synced to the main clock, making it suitable to detect very fast level changes in GPIO
@args: r0 (pin number), r1 (bool enable)
_gpio_enable_async_risingedge_detect:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12
	push {r1} @r12 - 16

	cmp r0, #53
	bhi _gpio_enable_async_risingedge_detect_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_enable_async_risingedge_detect_reg1

	_gpio_enable_async_risingedge_detect_reg0:
	add r4, r4, #GPIO_REGINDEX_ASYNC_REDGEDETECT0_ENABLE
	b _gpio_enable_async_risingedge_detect_l1

	_gpio_enable_async_risingedge_detect_reg1:
	add r4, r4, #GPIO_REGINDEX_ASYNC_REDGEDETECT1_ENABLE
	sub r0, r0, #32

	_gpio_enable_async_risingedge_detect_l1:
	mov r2, #1
	lsl r2, r2, r0

	eor r3, r3, r3
	mvn r3, r3

	tst r1, r3
	beq _gpio_enable_async_risingedge_detect_disable

	_gpio_enable_async_risingedge_detect_enable:
	ldr r3, [r4]
	orr r3, r3, r2
	str r3, [r4]
	b _gpio_enable_async_risingedge_detect_return

	_gpio_enable_async_risingedge_detect_disable:
	mvn r2, r2
	ldr r3, [r4]
	and r3, r3, r2
	str r3, [r4]

	_gpio_enable_async_risingedge_detect_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: check if asynchronous rising edge detection is enabled on a GPIO pin
@args: r0 (pin number)
@return value: r0 (1 == enabled / 0 == disabled)
_gpio_async_risingedge_detect_is_enabled:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12

	cmp r0, #53
	bhi _gpio_async_risingedge_detect_is_enabled_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_async_risingedge_detect_is_enabled_reg1

	_gpio_async_risingedge_detect_is_enabled_reg0:
	add r4, r4, #GPIO_REGINDEX_ASYNC_REDGEDETECT0_ENABLE
	b _gpio_async_risingedge_detect_is_enabled_l1

	_gpio_async_risingedge_detect_is_enabled_reg1:
	add r4, r4, #GPIO_REGINDEX_ASYNC_REDGEDETECT1_ENABLE
	sub r0, r0, #32

	_gpio_async_risingedge_detect_is_enabled_l1:
	mov r2, #1
	lsl r2, r2, r0

	ldr r3, [r4]

	tst r3, r2
	beq _gpio_async_risingedge_detect_is_enabled_returnfalse

	_gpio_async_risingedge_detect_is_enabled_returntrue:
	mov r0, #1
	b _gpio_async_risingedge_detect_is_enabled_return

	_gpio_async_risingedge_detect_is_enabled_returnfalse:
	eor r0, r0, r0

	_gpio_async_risingedge_detect_is_enabled_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: enable/disable asynchronous falling edge detection on a GPIO pin
@DESCRIPTION: asynchronous falling edge detection is like normal falling edge detection, however it's not synced to the main clock, making it suitable to detect very fast level changes in GPIO
@args: r0 (pin number), r1 (bool enable)
_gpio_enable_async_fallingedge_detect:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12
	push {r1} @r12 - 16

	cmp r0, #53
	bhi _gpio_enable_async_fallingedge_detect_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_enable_async_fallingedge_detect_reg1

	_gpio_enable_async_fallingedge_detect_reg0:
	add r4, r4, #GPIO_REGINDEX_ASYNC_FEDGEDETECT0_ENABLE
	b _gpio_enable_async_fallingedge_detect_l1

	_gpio_enable_async_fallingedge_detect_reg1:
	add r4, r4, #GPIO_REGINDEX_ASYNC_FEDGEDETECT1_ENABLE
	sub r0, r0, #32

	_gpio_enable_async_fallingedge_detect_l1:
	mov r2, #1
	lsl r2, r2, r0

	eor r3, r3, r3
	mvn r3, r3

	tst r1, r3
	beq _gpio_enable_async_fallingedge_detect_disable

	_gpio_enable_async_fallingedge_detect_enable:
	ldr r3, [r4]
	orr r3, r3, r2
	str r3, [r4]
	b _gpio_enable_async_fallingedge_detect_return

	_gpio_enable_async_fallingedge_detect_disable:
	mvn r2, r2
	ldr r3, [r4]
	and r3, r3, r2
	str r3, [r4]

	_gpio_enable_async_fallingedge_detect_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: check if asynchronous falling edge detection is enabled on a GPIO pin
@args: r0 (pin number)
@return value: r0 (1 == enabled / 0 == disabled)
_gpio_async_fallingedge_detect_is_enabled:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12

	cmp r0, #53
	bhi _gpio_async_fallingedge_detect_is_enabled_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_async_fallingedge_detect_is_enabled_reg1

	_gpio_async_fallingedge_detect_is_enabled_reg0:
	add r4, r4, #GPIO_REGINDEX_ASYNC_FEDGEDETECT0_ENABLE
	b _gpio_async_fallingedge_detect_is_enabled_l1

	_gpio_async_fallingedge_detect_is_enabled_reg1:
	add r4, r4, #GPIO_REGINDEX_ASYNC_FEDGEDETECT1_ENABLE
	sub r0, r0, #32

	_gpio_async_fallingedge_detect_is_enabled_l1:
	mov r2, #1
	lsl r2, r2, r0

	ldr r3, [r4]

	tst r3, r2
	beq _gpio_async_fallingedge_detect_is_enabled_returnfalse

	_gpio_async_fallingedge_detect_is_enabled_returntrue:
	mov r0, #1
	b _gpio_async_fallingedge_detect_is_enabled_return

	_gpio_async_fallingedge_detect_is_enabled_returnfalse:
	eor r0, r0, r0

	_gpio_async_fallingedge_detect_is_enabled_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: enable/disable high level detection on a GPIO pin
@args: r0 (pin number), r1 (bool enable)
_gpio_enable_high_detect:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12
	push {r1} @r12 - 16

	cmp r0, #53
	bhi _gpio_enable_high_detect_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_enable_high_detect_reg1

	_gpio_enable_high_detect_reg0:
	add r4, r4, #GPIO_REGINDEX_HIGHDETECT0_ENABLE
	b _gpio_enable_high_detect_l1

	_gpio_enable_high_detect_reg1:
	add r4, r4, #GPIO_REGINDEX_HIGHDETECT1_ENABLE
	sub r0, r0, #32

	_gpio_enable_high_detect_l1:
	mov r2, #1
	lsl r2, r2, r0

	eor r3, r3, r3
	mvn r3, r3

	tst r1, r3
	beq _gpio_enable_high_detect_disable

	_gpio_enable_high_detect_enable:
	ldr r3, [r4]
	orr r3, r3, r2
	str r3, [r4]
	b _gpio_enable_high_detect_return

	_gpio_enable_high_detect_disable:
	mvn r2, r2
	ldr r3, [r4]
	and r3, r3, r2
	str r3, [r4]

	_gpio_enable_high_detect_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: check if high level detection is enabled on a GPIO pin
@args: r0 (pin number)
@return value: r0 (1 == enabled / 0 == disabled)
_gpio_high_detect_is_enabled:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12

	cmp r0, #53
	bhi _gpio_high_detect_is_enabled_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_high_detect_is_enabled_reg1

	_gpio_high_detect_is_enabled_reg0:
	add r4, r4, #GPIO_REGINDEX_HIGHDETECT0_ENABLE
	b _gpio_high_detect_is_enabled_l1

	_gpio_high_detect_is_enabled_reg1:
	add r4, r4, #GPIO_REGINDEX_HIGHDETECT1_ENABLE
	sub r0, r0, #32

	_gpio_high_detect_is_enabled_l1:
	mov r2, #1
	lsl r2, r2, r0

	ldr r3, [r4]

	tst r3, r2
	beq _gpio_high_detect_is_enabled_returnfalse

	_gpio_high_detect_is_enabled_returntrue:
	mov r0, #1
	b _gpio_high_detect_is_enabled_return

	_gpio_high_detect_is_enabled_returnfalse:
	eor r0, r0, r0

	_gpio_high_detect_is_enabled_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: enable/disable low level detection on a GPIO pin
@args: r0 (pin number), r1 (bool enable)
_gpio_enable_low_detect:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12
	push {r1} @r12 - 16

	cmp r0, #53
	bhi _gpio_enable_low_detect_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_enable_low_detect_reg1

	_gpio_enable_low_detect_reg0:
	add r4, r4, #GPIO_REGINDEX_LOWDETECT0_ENABLE
	b _gpio_enable_low_detect_l1

	_gpio_enable_low_detect_reg1:
	add r4, r4, #GPIO_REGINDEX_LOWDETECT1_ENABLE
	sub r0, r0, #32

	_gpio_enable_low_detect_l1:
	mov r2, #1
	lsl r2, r2, r0

	eor r3, r3, r3
	mvn r3, r3

	tst r1, r3
	beq _gpio_enable_low_detect_disable

	_gpio_enable_low_detect_enable:
	ldr r3, [r4]
	orr r3, r3, r2
	str r3, [r4]
	b _gpio_enable_low_detect_return

	_gpio_enable_low_detect_disable:
	mvn r2, r2
	ldr r3, [r4]
	and r3, r3, r2
	str r3, [r4]

	_gpio_enable_low_detect_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: check if low level detection is enabled on a GPIO pin
@args: r0 (pin number)
@return value: r0 (1 == enabled / 0 == disabled)
_gpio_low_detect_is_enabled:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12

	cmp r0, #53
	bhi _gpio_low_detect_is_enabled_return

	ldr r4, =GPIO_BASE_ADDR

	cmp r0, #32
	bhs _gpio_low_detect_is_enabled_reg1

	_gpio_low_detect_is_enabled_reg0:
	add r4, r4, #GPIO_REGINDEX_LOWDETECT0_ENABLE
	b _gpio_low_detect_is_enabled_l1

	_gpio_low_detect_is_enabled_reg1:
	add r4, r4, #GPIO_REGINDEX_LOWDETECT1_ENABLE
	sub r0, r0, #32

	_gpio_low_detect_is_enabled_l1:
	mov r2, #1
	lsl r2, r2, r0

	ldr r3, [r4]

	tst r3, r2
	beq _gpio_low_detect_is_enabled_returnfalse

	_gpio_low_detect_is_enabled_returntrue:
	mov r0, #1
	b _gpio_low_detect_is_enabled_return

	_gpio_low_detect_is_enabled_returnfalse:
	eor r0, r0, r0

	_gpio_low_detect_is_enabled_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3



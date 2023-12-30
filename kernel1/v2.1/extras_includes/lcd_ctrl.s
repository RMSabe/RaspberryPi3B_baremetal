@Mini Kernel for Raspberry Pi 3B
@Author: Rafael Sabe
@Email: rafaelmsabe@gmail.com

.equ LCD_DISPLAYMODE_DISPLAY_OFF, 0
.equ LCD_DISPLAYMODE_CURSOR_OFF, 1
.equ LCD_DISPLAYMODE_CURSOR_ON, 2
.equ LCD_DISPLAYMODE_CURSOR_BLINK, 3

.equ LCD_DELAYTIME, 0x800

@LCD ID Structure Descriptor
@Every LCD device needs to use this structure:
@byte DB4 pin
@byte DB5 pin
@byte DB6 pin
@byte DB7 pin
@byte RS pin
@byte E pin
@byte NUMBER CHARACTERS PER LINE
@byte NUMBER LINES

.section .text

@FUNCTION: initializes GPIO and LCD controller
@args: r0 (LCD ID)
_lcd_init:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12

	mov r4, r0

	ldrb r0, [r4]
	bl _gpio_reset_pin

	ldrb r0, [r4]
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	add r4, r4, #1

	ldrb r0, [r4]
	bl _gpio_reset_pin

	ldrb r0, [r4]
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	add r4, r4, #1

	ldrb r0, [r4]
	bl _gpio_reset_pin

	ldrb r0, [r4]
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	add r4, r4, #1

	ldrb r0, [r4]
	bl _gpio_reset_pin

	ldrb r0, [r4]
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	add r4, r4, #1

	ldrb r0, [r4]
	bl _gpio_reset_pin

	ldrb r0, [r4]
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	add r4, r4, #1

	ldrb r0, [r4]
	bl _gpio_reset_pin

	ldrb r0, [r4]
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	mov r1, r12
	sub r1, r1, #12
	ldr r4, [r1]

	mov r0, r4
	bl _lcd_send_init_nibble

	mov r0, r4
	eor r1, r1, r1
	mov r2, #0x28
	bl _lcd_send_byte

	mov r0, r4
	eor r1, r1, r1
	mov r2, #0x0c
	bl _lcd_send_byte

	mov r0, r4
	eor r1, r1, r1
	mov r2, #0x01
	bl _lcd_send_byte

	mov r0, r4
	eor r1, r1, r1
	mov r2, #0x80
	bl _lcd_send_byte

	_lcd_init_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: set LCD display mode
@args: r0 (LCD ID), r1 (display mode)
_lcd_set_display_mode:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r0} @r12 - 8
	push {r1} @r12 - 12

	teq r1, #LCD_DISPLAYMODE_DISPLAY_OFF
	beq _lcd_set_display_mode_display_off

	teq r1, #LCD_DISPLAYMODE_CURSOR_OFF
	beq _lcd_set_display_mode_cursor_off

	teq r1, #LCD_DISPLAYMODE_CURSOR_ON
	beq _lcd_set_display_mode_cursor_on

	teq r1, #LCD_DISPLAYMODE_CURSOR_BLINK
	beq _lcd_set_display_mode_cursor_blink

	b _lcd_set_display_mode_return

	_lcd_set_display_mode_cursor_blink:
	mov r2, #0xf
	b _lcd_set_display_mode_l1

	_lcd_set_display_mode_cursor_on:
	mov r2, #0xe
	b _lcd_set_display_mode_l1

	_lcd_set_display_mode_cursor_off:
	mov r2, #0xc
	b _lcd_set_display_mode_l1

	_lcd_set_display_mode_display_off:
	mov r2, #0x8

	_lcd_set_display_mode_l1:
	eor r1, r1, r1

	bl _lcd_send_byte

	_lcd_set_display_mode_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: clear LCD screen
@args: r0 (LCD ID)
_lcd_clear:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r0} @r12 - 8

	eor r1, r1, r1
	mov r2, #0x1
	bl _lcd_send_byte

	_lcd_clear_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: return LCD cursor to beginning
@args: r0 (LCD ID)
_lcd_home:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r0} @r12 - 8

	eor r1, r1, r1
	mov r2, #0x2
	bl _lcd_send_byte

	_lcd_home_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: set LCD cursor position
@args: r0 (LCD ID), r1 (character position), r2 (line position)
_lcd_set_cursor:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r5} @r12 - 12
	push {r0} @r12 - 16
	push {r1} @r12 - 20
	push {r2} @r12 - 24

	add r0, r0, #6
	ldrb r3, [r0]
	push {r3} @r12 - 28

	add r0, r0, #1
	ldrb r3, [r0]
	push {r3} @r12 - 32

	eor r3, r3, r3
	push {r3} @r12 - 36

	mov r1, r12
	sub r1, r1, #16
	ldr r0, [r1]
	sub r1, r1, #8
	ldr r2, [r1]
	sub r1, r1, #8
	ldr r3, [r1]

	cmp r2, r3
	bhs _lcd_set_cursor_return

	tst r2, #0x1
	beq _lcd_set_cursor_evenline

	_lcd_set_cursor_oddline:
	mov r2, #0xc0
	b _lcd_set_cursor_l1
	_lcd_set_cursor_evenline:
	mov r2, #0x80

	_lcd_set_cursor_l1:
	eor r1, r1, r1
	bl _lcd_send_byte

	mov r1, r12
	sub r1, r1, #24
	ldr r2, [r1]

	cmp r2, #2
	blo _lcd_set_cursor_l2

	lsr r2, r2, #1
	str r2, [r1]

	ldr r3, [r1]
	sub r1, r1, #4
	ldr r5, [r1]
	sub r1, r1, #8
	eor r2, r2, r2
	str r2, [r1]

	_lcd_set_cursor_outloop1:
	cmp r2, r3
	bhs _lcd_set_cursor_endoutloop1

	eor r4, r4, r4

	_lcd_set_cursor_inloop1:
	cmp r4, r5
	bhs _lcd_set_cursor_endinloop1
	mov r1, r12
	sub r1, r1, #16
	ldr r0, [r1]
	eor r1, r1, r1
	mov r2, #0x14
	bl _lcd_send_byte
	add r4, r4, #1
	b _lcd_set_cursor_inloop1
	_lcd_set_cursor_endinloop1:

	mov r1, r12
	sub r1, r1, #24
	ldr r3, [r1]
	sub r1, r1, #12
	ldr r2, [r1]
	add r2, r2, #1
	str r2, [r1]

	b _lcd_set_cursor_outloop1
	_lcd_set_cursor_endoutloop1:

	_lcd_set_cursor_l2:

	mov r1, r12
	sub r1, r1, #20
	ldr r5, [r1]

	teq r5, #0
	beq _lcd_set_cursor_return

	eor r4, r4, r4

	_lcd_set_cursor_loop2:
	cmp r4, r5
	bhs _lcd_set_cursor_endloop2
	mov r1, r12
	sub r1, r1, #16
	ldr r0, [r1]
	eor r1, r1, r1
	mov r2, #0x14
	bl _lcd_send_byte
	add r4, r4, #1
	b _lcd_set_cursor_loop2
	_lcd_set_cursor_endloop2:

	_lcd_set_cursor_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]
	sub r1, r1, #4
	ldr r5, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: print text on LCD
@args: r0 (LCD ID), r1 (input text buffer addr)
_lcd_print_text:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r5} @r12 - 12
	push {r0} @r12 - 16
	push {r1} @r12 - 20

	eor r5, r5, r5

	_lcd_print_text_getlen:
	ldrb r2, [r1]
	cmp r2, #0
	beq _lcd_print_text_gotlen
	add r5, r5, #1
	add r1, r1, #1
	b _lcd_print_text_getlen
	_lcd_print_text_gotlen:
	sub r1, r1, r5

	eor r4, r4, r4
	_lcd_print_text_loop:
	cmp r4, r5
	bhs _lcd_print_text_endloop
	mov r1, r12
	sub r1, r1, #16
	ldr r0, [r1]
	sub r1, r1, #4
	ldr r3, [r1]
	add r3, r3, r4
	ldrb r2, [r3]
	mov r1, #1
	bl _lcd_send_byte
	add r4, r4, #1
	b _lcd_print_text_loop
	_lcd_print_text_endloop:

	_lcd_print_text_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]
	sub r1, r1, #4
	ldr r5, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: send initialization nibble to the LCD controller
@args: r0 (LCD ID)
_lcd_send_init_nibble:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r0} @r12 - 12

	mov r4, r0
	mov r2, r0

	add r2, r2, #5
	ldrb r0, [r2]
	eor r1, r1, r1
	bl _gpio_set_level

	mov r2, r4
	add r2, r2, #4
	ldrb r0, [r2]
	eor r1, r1, r1
	bl _gpio_set_level

	mov r0, r4
	mov r1, #0x2
	bl _lcd_print_binary

	mov r0, #LCD_DELAYTIME
	bl _delay32

	mov r2, r4
	add r2, r2, #5
	ldrb r0, [r2]
	mov r1, #1
	bl _gpio_set_level

	mov r0, #LCD_DELAYTIME
	bl _delay32

	mov r2, r4
	add r2, r2, #5
	ldrb r0, [r2]
	eor r1, r1, r1
	bl _gpio_set_level

	mov r0, #LCD_DELAYTIME
	lsl r0, r0, #1
	bl _delay32

	_lcd_send_init_nibble_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: send a byte to the LCD controller
@args: r0 (LCD ID), r1 (register selection), r2 (byte value)
_lcd_send_byte:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r5} @r12 - 12
	push {r0} @r12 - 16
	push {r1} @r12 - 20
	push {r2} @r12 - 24

	mov r4, r0
	mov r5, r2
	and r5, r5, #0xff

	mov r2, r4
	add r2, r2, #5
	ldrb r0, [r2]
	eor r1, r1, r1
	bl _gpio_set_level

	mov r3, r12
	sub r3, r3, #20
	ldr r1, [r3]

	eor r2, r2, r2
	mvn r2, r2

	tst r1, r2
	beq _lcd_send_byte_reg_clr

	_lcd_send_byte_reg_set:
	mov r1, #1
	b _lcd_send_byte_l1
	_lcd_send_byte_reg_clr:
	eor r1, r1, r1

	_lcd_send_byte_l1:
	mov r2, r4
	add r2, r2, #4
	ldrb r0, [r2]
	bl _gpio_set_level

	mov r0, r4
	mov r1, r5
	lsr r1, r1, #4
	bl _lcd_print_binary

	mov r0, #LCD_DELAYTIME
	bl _delay32

	mov r2, r4
	add r2, r2, #5
	ldrb r0, [r2]
	mov r1, #1
	bl _gpio_set_level

	mov r0, #LCD_DELAYTIME
	bl _delay32

	mov r2, r4
	add r2, r2, #5
	ldrb r0, [r2]
	eor r1, r1, r1
	bl _gpio_set_level

	mov r0, r4
	mov r1, r5
	and r1, r1, #0xf
	bl _lcd_print_binary

	mov r0, #LCD_DELAYTIME
	bl _delay32

	mov r2, r4
	add r2, r2, #5
	ldrb r0, [r2]
	mov r1, #1
	bl _gpio_set_level

	mov r0, #LCD_DELAYTIME
	bl _delay32

	mov r2, r4
	add r2, r2, #5
	ldrb r0, [r2]
	eor r1, r1, r1
	bl _gpio_set_level

	mov r0, #LCD_DELAYTIME
	bl _delay32

	_lcd_send_byte_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]
	sub r1, r1, #4
	ldr r5, [r1]

	mov sp, r12
	pop {r12}

	bx r3

@FUNCTION: print a 4bit value to the LCD data output
@args: r0 (LCD ID), r1 (binary value)
_lcd_print_binary:
	push {r12}
	mov r12, sp

	push {lr} @r12 - 4
	push {r4} @r12 - 8
	push {r5} @r12 - 12
	push {r0} @r12 - 16
	push {r1} @r12 - 20

	mov r4, r0
	mov r5, r1
	and r5, r5, #0xf

	tst r5, #0x1
	beq _lcd_print_binary_db4_clr

	_lcd_print_binary_db4_set:
	mov r1, #1
	b _lcd_print_binary_l1
	_lcd_print_binary_db4_clr:
	eor r1, r1, r1

	_lcd_print_binary_l1:
	mov r2, r4
	ldrb r0, [r2]
	bl _gpio_set_level

	tst r5, #0x2
	beq _lcd_print_binary_db5_clr

	_lcd_print_binary_db5_set:
	mov r1, #1
	b _lcd_print_binary_l2
	_lcd_print_binary_db5_clr:
	eor r1, r1, r1

	_lcd_print_binary_l2:
	mov r2, r4
	add r2, r2, #1
	ldrb r0, [r2]
	bl _gpio_set_level

	tst r5, #0x4
	beq _lcd_print_binary_db6_clr

	_lcd_print_binary_db6_set:
	mov r1, #1
	b _lcd_print_binary_l3
	_lcd_print_binary_db6_clr:
	eor r1, r1, r1

	_lcd_print_binary_l3:
	mov r2, r4
	add r2, r2, #2
	ldrb r0, [r2]
	bl _gpio_set_level

	tst r5, #0x8
	beq _lcd_print_binary_db7_clr

	_lcd_print_binary_db7_set:
	mov r1, #1
	b _lcd_print_binary_l4
	_lcd_print_binary_db7_clr:
	eor r1, r1, r1

	_lcd_print_binary_l4:
	mov r2, r4
	add r2, r2, #3
	ldrb r0, [r2]
	bl _gpio_set_level

	_lcd_print_binary_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]
	sub r1, r1, #4
	ldr r5, [r1]

	mov sp, r12
	pop {r12}

	bx r3


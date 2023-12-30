@Test 9: test print 32bit integers (signed and unsigned)

.equ TEST_LCD_DB4, 24
.equ TEST_LCD_DB5, 25
.equ TEST_LCD_DB6, 26
.equ TEST_LCD_DB7, 27
.equ TEST_LCD_RS, 23
.equ TEST_LCD_E, 22
.equ TEST_LCD_NCHARS, 20
.equ TEST_LCD_NLINES, 4

.equ TEST_U32_START, 0
.equ TEST_U32_STOP, 200
.equ TEST_S32_START, -100
.equ TEST_S32_STOP, 100

.equ TEST_DELAYTIME, 0x00100000

.section .text

_teststart:
	ldr r4, =_test_lcd1
	ldr r5, =_test_num32

	mov r0, r4
	bl _lcd_init

_test_l1:
	ldr r2, =TEST_U32_START
	str r2, [r5]

_test_loop1:
	ldr r0, [r5]
	ldr r1, =TEST_U32_STOP
	cmp r0, r1
	bhs _test_l2

	ldr r1, =_textbuf
	bl _loadstr_dec_u32

	mov r0, r4
	eor r1, r1, r1
	eor r2, r2, r2
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =_textbuf
	bl _lcd_print_text

	mov r0, r4
	ldr r1, =_test_whitespaces
	bl _lcd_print_text

	ldr r0, =TEST_DELAYTIME
	bl _delay32

	ldr r2, [r5]
	add r2, r2, #1
	str r2, [r5]

	b _test_loop1

_test_l2:
	ldr r2, =TEST_S32_START
	str r2, [r5]

_test_loop2:
	ldr r0, [r5]
	ldr r1, =TEST_S32_STOP
	cmp r0, r1
	bge _testend

	ldr r1, =_textbuf
	bl _loadstr_dec_s32

	mov r0, r4
	eor r1, r1, r1
	mov r2, #1
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =_textbuf
	bl _lcd_print_text

	mov r0, r4
	ldr r1, =_test_whitespaces
	bl _lcd_print_text

	ldr r0, =TEST_DELAYTIME
	bl _delay32

	ldr r2, [r5]
	add r2, r2, #1
	str r2, [r5]

	b _test_loop2

_testend:
	b _sysend

.section .data

.align 8
_test_lcd1:
.byte TEST_LCD_DB4
.byte TEST_LCD_DB5
.byte TEST_LCD_DB6
.byte TEST_LCD_DB7
.byte TEST_LCD_RS
.byte TEST_LCD_E
.byte TEST_LCD_NCHARS
.byte TEST_LCD_NLINES

_test_num32: .long 0

_test_whitespaces: .asciz "    "


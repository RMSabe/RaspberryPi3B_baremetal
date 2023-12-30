@Test 8: test print 16bit integers (signed and unsigned)

.equ TEST_LCD_DB4, 24
.equ TEST_LCD_DB5, 25
.equ TEST_LCD_DB6, 26
.equ TEST_LCD_DB7, 27
.equ TEST_LCD_RS, 23
.equ TEST_LCD_E, 22
.equ TEST_LCD_NCHARS, 20
.equ TEST_LCD_NLINES, 4

.equ TEST_U16_START, 0
.equ TEST_U16_STOP, 200
.equ TEST_S16_START, -100
.equ TEST_S16_STOP, 100

.equ TEST_DELAYTIME, 0x00100000

.section .text

_teststart:
	ldr r4, =_test_lcd1
	ldr r5, =_test_num16

	mov r0, r4
	bl _lcd_init

_test_l1:
	ldr r2, =TEST_U16_START
	strh r2, [r5]

_test_loop1:
	ldrh r0, [r5]
	ldr r1, =TEST_U16_STOP
	cmp r0, r1
	bhs _test_l2

	ldr r1, =_textbuf
	bl _loadstr_dec_u16

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

	ldrh r2, [r5]
	add r2, r2, #1
	strh r2, [r5]

	b _test_loop1

_test_l2:
	ldr r2, =TEST_S16_START
	strh r2, [r5]

_test_loop2:
	ldrsh r0, [r5]
	ldr r1, =TEST_S16_STOP
	cmp r0, r1
	bge _testend

	ldr r1, =_textbuf
	bl _loadstr_dec_s16

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

	ldrsh r2, [r5]
	add r2, r2, #1
	strh r2, [r5]

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

_test_num16: .word 0

_test_whitespaces: .asciz "    "


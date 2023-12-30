@Test 11: Test 2 LCDs

.equ TEST_LCD1_DB4, 24
.equ TEST_LCD1_DB5, 25
.equ TEST_LCD1_DB6, 26
.equ TEST_LCD1_DB7, 27
.equ TEST_LCD1_RS, 23
.equ TEST_LCD1_E, 22
.equ TEST_LCD1_NCHARS, 16
.equ TEST_LCD1_NLINES, 2

.equ TEST_LCD2_DB4, 24
.equ TEST_LCD2_DB5, 25
.equ TEST_LCD2_DB6, 26
.equ TEST_LCD2_DB7, 27
.equ TEST_LCD2_RS, 23
.equ TEST_LCD2_E, 4
.equ TEST_LCD2_NCHARS, 20
.equ TEST_LCD2_NLINES, 4

.section .text

_teststart:
	ldr r4, =_test_lcd1
	ldr r5, =_test_lcd2

	mov r0, r4
	bl _lcd_init

	mov r0, r5
	bl _lcd_init

	mov r0, r4
	ldr r1, =_test_lcd1_str0
	bl _lcd_print_text

	mov r0, r4
	eor r1, r1, r1
	mov r2, #1
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =_test_lcd1_str1
	bl _lcd_print_text

	mov r0, r5
	ldr r1, =_test_lcd2_str0
	bl _lcd_print_text

	mov r0, r5
	eor r1, r1, r1
	mov r2, #1
	bl _lcd_set_cursor

	mov r0, r5
	ldr r1, =_test_lcd2_str1
	bl _lcd_print_text

	mov r0, r5
	eor r1, r1, r1
	mov r2, #2
	bl _lcd_set_cursor

	mov r0, r5
	ldr r1, =_test_lcd2_str2
	bl _lcd_print_text

	mov r0, r5
	eor r1, r1, r1
	mov r2, #3
	bl _lcd_set_cursor

	mov r0, r5
	ldr r1, =_test_lcd2_str3
	bl _lcd_print_text

_testend:
	b _sysend

.section .data

.align 8

_test_lcd1:
.byte TEST_LCD1_DB4
.byte TEST_LCD1_DB5
.byte TEST_LCD1_DB6
.byte TEST_LCD1_DB7
.byte TEST_LCD1_RS
.byte TEST_LCD1_E
.byte TEST_LCD1_NCHARS
.byte TEST_LCD1_NLINES

_test_lcd2:
.byte TEST_LCD2_DB4
.byte TEST_LCD2_DB5
.byte TEST_LCD2_DB6
.byte TEST_LCD2_DB7
.byte TEST_LCD2_RS
.byte TEST_LCD2_E
.byte TEST_LCD2_NCHARS
.byte TEST_LCD2_NLINES

_test_lcd1_str0: .asciz "LCD 1 Line 0"
_test_lcd1_str1: .asciz "LCD 1 Line 1"

_test_lcd2_str0: .asciz "LCD 2 Line 00"
_test_lcd2_str1: .asciz "LCD 2 Line 01"
_test_lcd2_str2: .asciz "LCD 2 Line 02"
_test_lcd2_str3: .asciz "LCD 2 Line 03"


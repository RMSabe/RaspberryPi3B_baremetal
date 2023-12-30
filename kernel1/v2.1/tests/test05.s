@Test 5: Test LCD ctrl

.equ TEST_LCD_DB4, 24
.equ TEST_LCD_DB5, 25
.equ TEST_LCD_DB6, 26
.equ TEST_LCD_DB7, 27
.equ TEST_LCD_RS, 23
.equ TEST_LCD_E, 22
.equ TEST_LCD_NCHARS, 20
.equ TEST_LCD_NLINES, 4

.section .text

_teststart:
	ldr r0, =_lcd1
	bl _lcd_init

	ldr r0, =_lcd1
	ldr r1, =_test_str0
	bl _lcd_print_text

	ldr r0, =_lcd1
	eor r1, r1, r1
	mov r2, #1
	bl _lcd_set_cursor

	ldr r0, =_lcd1
	ldr r1, =_test_str1
	bl _lcd_print_text

	ldr r0, =_lcd1
	eor r1, r1, r1
	mov r2, #2
	bl _lcd_set_cursor

	ldr r0, =_lcd1
	ldr r1, =_test_str2
	bl _lcd_print_text

	ldr r0, =_lcd1
	eor r1, r1, r1
	mov r2, #3
	bl _lcd_set_cursor

	ldr r0, =_lcd1
	ldr r1, =_test_str3
	bl _lcd_print_text

_testend:
	b _sysend

.section .data

.align 8
_lcd1:
.byte TEST_LCD_DB4
.byte TEST_LCD_DB5
.byte TEST_LCD_DB6
.byte TEST_LCD_DB7
.byte TEST_LCD_RS
.byte TEST_LCD_E
.byte TEST_LCD_NCHARS
.byte TEST_LCD_NLINES

_test_str0: .asciz "This is line 0"
_test_str1: .asciz "This is line 1"
_test_str2: .asciz "This is line 2"
_test_str3: .asciz "This is line 3"


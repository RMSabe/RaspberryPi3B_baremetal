@Test 10: Mini kernel demo LCD

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
	ldr r4, =_test_lcd1

	mov r0, r4
	bl _lcd_init

	mov r0, r4
	mov r1, #7
	eor r2, r2, r2
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =_test_str1
	bl _lcd_print_text

	mov r0, r4
	mov r1, #3
	mov r2, #1
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =_test_str2
	bl _lcd_print_text

	mov r0, r4
	mov r1, #4
	mov r2, #2
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =_test_str3
	bl _lcd_print_text

	mov r0, r4
	mov r1, #3
	mov r2, #3
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =_test_str4
	bl _lcd_print_text

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

_test_str1: .asciz "Hello!"
_test_str2: .asciz "Welcome to my"
_test_str3: .asciz "Mini Kernel."
_test_str4: .asciz "by Rafael Sabe"


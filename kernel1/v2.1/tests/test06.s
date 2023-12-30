@Test 6: Test _str_compare

.equ TEST_LCD_DB4, 24
.equ TEST_LCD_DB5, 25
.equ TEST_LCD_DB6, 26
.equ TEST_LCD_DB7, 27
.equ TEST_LCD_RS, 23
.equ TEST_LCD_E, 22
.equ TEST_LCD_NCHARS, 20
.equ TEST_LCD_NLINES, 4

.equ TESTCOMP_0_0, _test_str4
.equ TESTCOMP_0_1, _test_str3
.equ TESTCOMP_1_0, _test_str1
.equ TESTCOMP_1_1, _test_str2
.equ TESTCOMP_2_0, _test_str2
.equ TESTCOMP_2_1, _test_str3
.equ TESTCOMP_3_0, _test_str4
.equ TESTCOMP_3_1, _test_str1

.section .text

_teststart:
	ldr r4, =_test_lcd1

	mov r0, r4
	bl _lcd_init

	mov r0, r4
	ldr r1, =TESTCOMP_0_0
	bl _lcd_print_text

	mov r0, r4
	mov r1, #8
	eor r2, r2, r2
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =TESTCOMP_0_1
	bl _lcd_print_text

	mov r0, r4
	mov r1, #16
	eor r2, r2, r2
	bl _lcd_set_cursor

	ldr r0, =TESTCOMP_0_0
	ldr r1, =TESTCOMP_0_1
	bl _str_compare

	ldr r1, =_textbuf

	eor r2, r2, r2
	mvn r2, r2

	tst r0, r2
	beq _test0_false

	_test0_true:
	mov r2, #0x31
	b _test_l1
	_test0_false:
	mov r2, #0x30

	_test_l1:
	strh r2, [r1]
	mov r0, r4
	bl _lcd_print_text

	mov r0, r4
	eor r1, r1, r1
	mov r2, #1
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =TESTCOMP_1_0
	bl _lcd_print_text

	mov r0, r4
	mov r1, #8
	mov r2, #1
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =TESTCOMP_1_1
	bl _lcd_print_text

	mov r0, r4
	mov r1, #16
	mov r2, #1
	bl _lcd_set_cursor

	ldr r0, =TESTCOMP_1_0
	ldr r1, =TESTCOMP_1_1
	bl _str_compare

	ldr r1, =_textbuf

	eor r2, r2, r2
	mvn r2, r2

	tst r0, r2
	beq _test1_false

	_test1_true:
	mov r2, #0x31
	b _test_l2
	_test1_false:
	mov r2, #0x30

	_test_l2:
	strh r2, [r1]
	mov r0, r4
	bl _lcd_print_text

	mov r0, r4
	eor r1, r1, r1
	mov r2, #2
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =TESTCOMP_2_0
	bl _lcd_print_text

	mov r0, r4
	mov r1, #8
	mov r2, #2
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =TESTCOMP_2_1
	bl _lcd_print_text

	mov r0, r4
	mov r1, #16
	mov r2, #2
	bl _lcd_set_cursor

	ldr r0, =TESTCOMP_2_0
	ldr r1, =TESTCOMP_2_1
	bl _str_compare

	ldr r1, =_textbuf

	eor r2, r2, r2
	mvn r2, r2

	tst r0, r2
	beq _test2_false

	_test2_true:
	mov r2, #0x31
	b _test_l3
	_test2_false:
	mov r2, #0x30

	_test_l3:
	strh r2, [r1]
	mov r0, r4
	bl _lcd_print_text

	mov r0, r4
	eor r1, r1, r1
	mov r2, #3
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =TESTCOMP_3_0
	bl _lcd_print_text

	mov r0, r4
	mov r1, #8
	mov r2, #3
	bl _lcd_set_cursor

	mov r0, r4
	ldr r1, =TESTCOMP_3_1
	bl _lcd_print_text

	mov r0, r4
	mov r1, #16
	mov r2, #3
	bl _lcd_set_cursor

	ldr r0, =TESTCOMP_3_0
	ldr r1, =TESTCOMP_3_1
	bl _str_compare

	ldr r1, =_textbuf

	eor r2, r2, r2
	mvn r2, r2

	tst r0, r2
	beq _test3_false

	_test3_true:
	mov r2, #0x31
	b _test_l4
	_test3_false:
	mov r2, #0x30

	_test_l4:
	strh r2, [r1]
	mov r0, r4
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

_test_str1: .asciz "sum"
_test_str2: .asciz "sub"
_test_str3: .asciz "mult"
_test_str4: .asciz "sum"


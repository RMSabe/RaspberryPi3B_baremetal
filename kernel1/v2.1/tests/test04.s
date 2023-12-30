@Test 4: Test LCD "Hello World"

.equ TEST_LCD_DB4, 24
.equ TEST_LCD_DB5, 25
.equ TEST_LCD_DB6, 26
.equ TEST_LCD_DB7, 27
.equ TEST_LCD_RS, 23
.equ TEST_LCD_E, 22
.equ TEST_LCD_NCHARS, 20
.equ TEST_LCD_NLINES, 4

.equ TEST_DELAYTIME, 0x00800000

.section .text

_teststart:
	ldr r0, =_lcd1
	bl _lcd_init

_testloop:
	ldr r0, =_lcd1
	ldr r1, =_test_str0
	bl _lcd_print_text

	ldr r0, =TEST_DELAYTIME
	bl _delay32

	ldr r0, =_lcd1
	bl _lcd_clear

	ldr r0, =TEST_DELAYTIME
	bl _delay32

	b _testloop

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

_test_str0: .asciz "Hello World"


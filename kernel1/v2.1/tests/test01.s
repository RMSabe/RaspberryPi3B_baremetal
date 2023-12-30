@Test 1: Blink

.equ LED_PIN, 24
.equ TEST_DELAYTIME, 0x00100000

.section .text

_teststart:
	mov r0, #LED_PIN
	bl _gpio_reset_pin

	mov r0, #LED_PIN
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

_testloop:
	mov r0, #LED_PIN
	mov r1, #1
	bl _gpio_set_level

	ldr r0, =TEST_DELAYTIME
	bl _delay32

	mov r0, #LED_PIN
	eor r1, r1, r1
	bl _gpio_set_level

	ldr r0, =TEST_DELAYTIME
	bl _delay32

	b _testloop

_testend:
	b _sysend


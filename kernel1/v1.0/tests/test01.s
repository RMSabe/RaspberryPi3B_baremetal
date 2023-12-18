@Test 1: Blink

.equ LED_PIN, 24
.equ DELAYTIME, 0x00100000

.section .text

_teststart:
	ldr r0, =LED_PIN
	push {r0}
	bl _gpio_reset_pin

	ldr r0, =LED_PIN
	ldr r1, =GPIO_PINMODE_OUTPUT
	push {r0}
	push {r1}
	bl _gpio_set_pinmode

_testloop:
	ldr r0, =LED_PIN
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level

	ldr r0, =DELAYTIME
	push {r0}
	bl _delay32

	ldr r0, =LED_PIN
	ldr r1, =0
	push {r0}
	push {r1}
	bl _gpio_set_level

	ldr r0, =DELAYTIME
	push {r0}
	bl _delay32

	b _testloop

_testend:
	b _sysend


@Test 3: LEDs

.equ LED_0, 12
.equ LED_1, 13
.equ LED_2, 16
.equ LED_3, 17
.equ LED_4, 24
.equ LED_5, 25
.equ LED_6, 26
.equ LED_7, 27

.equ DELAYTIME, 0x00100000

.section .text

_teststart:
	ldr r0, =LED_0
	push {r0}
	bl _gpio_reset_pin

	ldr r0, =LED_1
	push {r0}
	bl _gpio_reset_pin

	ldr r0, =LED_2
	push {r0}
	bl _gpio_reset_pin

	ldr r0, =LED_3
	push {r0}
	bl _gpio_reset_pin

	ldr r0, =LED_4
	push {r0}
	bl _gpio_reset_pin

	ldr r0, =LED_5
	push {r0}
	bl _gpio_reset_pin

	ldr r0, =LED_6
	push {r0}
	bl _gpio_reset_pin

	ldr r0, =LED_7
	push {r0}
	bl _gpio_reset_pin

	ldr r0, =LED_0
	ldr r1, =GPIO_PINMODE_OUTPUT
	push {r0}
	push {r1}
	bl _gpio_set_pinmode

	ldr r0, =LED_1
	ldr r1, =GPIO_PINMODE_OUTPUT
	push {r0}
	push {r1}
	bl _gpio_set_pinmode

	ldr r0, =LED_2
	ldr r1, =GPIO_PINMODE_OUTPUT
	push {r0}
	push {r1}
	bl _gpio_set_pinmode

	ldr r0, =LED_3
	ldr r1, =GPIO_PINMODE_OUTPUT
	push {r0}
	push {r1}
	bl _gpio_set_pinmode

	ldr r0, =LED_4
	ldr r1, =GPIO_PINMODE_OUTPUT
	push {r0}
	push {r1}
	bl _gpio_set_pinmode

	ldr r0, =LED_5
	ldr r1, =GPIO_PINMODE_OUTPUT
	push {r0}
	push {r1}
	bl _gpio_set_pinmode

	ldr r0, =LED_6
	ldr r1, =GPIO_PINMODE_OUTPUT
	push {r0}
	push {r1}
	bl _gpio_set_pinmode

	ldr r0, =LED_7
	ldr r1, =GPIO_PINMODE_OUTPUT
	push {r0}
	push {r1}
	bl _gpio_set_pinmode

	ldr r8, =0

_testloop:
	tst r8, #0x1
	beq _testloop_led0_off
	b _testloop_led0_on

	_testloop_led0_on:
	ldr r0, =LED_0
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level
	b _testloop_l1

	_testloop_led0_off:
	ldr r0, =LED_0
	eor r1, r1, r1
	push {r0}
	push {r1}
	bl _gpio_set_level

	_testloop_l1:
	tst r8, #0x2
	beq _testloop_led1_off
	b _testloop_led1_on

	_testloop_led1_on:
	ldr r0, =LED_1
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level
	b _testloop_l2

	_testloop_led1_off:
	ldr r0, =LED_1
	eor r1, r1, r1
	push {r0}
	push {r1}
	bl _gpio_set_level

	_testloop_l2:
	tst r8, #0x4
	beq _testloop_led2_off
	b _testloop_led2_on

	_testloop_led2_on:
	ldr r0, =LED_2
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level
	b _testloop_l3

	_testloop_led2_off:
	ldr r0, =LED_2
	eor r1, r1, r1
	push {r0}
	push {r1}
	bl _gpio_set_level

	_testloop_l3:
	tst r8, #0x8
	beq _testloop_led3_off
	b _testloop_led3_on

	_testloop_led3_on:
	ldr r0, =LED_3
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level
	b _testloop_l4

	_testloop_led3_off:
	ldr r0, =LED_3
	eor r1, r1, r1
	push {r0}
	push {r1}
	bl _gpio_set_level

	_testloop_l4:
	tst r8, #0x10
	beq _testloop_led4_off
	b _testloop_led4_on

	_testloop_led4_on:
	ldr r0, =LED_4
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level
	b _testloop_l5

	_testloop_led4_off:
	ldr r0, =LED_4
	eor r1, r1, r1
	push {r0}
	push {r1}
	bl _gpio_set_level

	_testloop_l5:
	tst r8, #0x20
	beq _testloop_led5_off
	b _testloop_led5_on

	_testloop_led5_on:
	ldr r0, =LED_5
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level
	b _testloop_l6

	_testloop_led5_off:
	ldr r0, =LED_5
	eor r1, r1, r1
	push {r0}
	push {r1}
	bl _gpio_set_level

	_testloop_l6:
	tst r8, #0x40
	beq _testloop_led6_off
	b _testloop_led6_on

	_testloop_led6_on:
	ldr r0, =LED_6
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level
	b _testloop_l7

	_testloop_led6_off:
	ldr r0, =LED_6
	eor r1, r1, r1
	push {r0}
	push {r1}
	bl _gpio_set_level

	_testloop_l7:
	tst r8, #0x80
	beq _testloop_led7_off
	b _testloop_led7_on

	_testloop_led7_on:
	ldr r0, =LED_7
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level
	b _testloop_l8

	_testloop_led7_off:
	ldr r0, =LED_7
	eor r1, r1, r1
	push {r0}
	push {r1}
	bl _gpio_set_level

	_testloop_l8:

	ldr r0, =DELAYTIME
	push {r0}
	bl _delay32

	add r8, r8, #1

	b _testloop

_testend:
	b _sysend


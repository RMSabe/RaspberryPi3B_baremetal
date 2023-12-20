@Test 3: LEDs

.equ LED_0, 12
.equ LED_1, 13
.equ LED_2, 16
.equ LED_3, 17
.equ LED_4, 24
.equ LED_5, 25
.equ LED_6, 26
.equ LED_7, 27

.equ TEST_DELAYTIME, 0x00100000

.section .text

_teststart:
	mov r0, #LED_0
	bl _gpio_reset_pin

	mov r0, #LED_1
	bl _gpio_reset_pin

	mov r0, #LED_2
	bl _gpio_reset_pin

	mov r0, #LED_3
	bl _gpio_reset_pin

	mov r0, #LED_4
	bl _gpio_reset_pin

	mov r0, #LED_5
	bl _gpio_reset_pin

	mov r0, #LED_6
	bl _gpio_reset_pin

	mov r0, #LED_7
	bl _gpio_reset_pin

	mov r0, #LED_0
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	mov r0, #LED_1
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	mov r0, #LED_2
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	mov r0, #LED_3
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	mov r0, #LED_4
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	mov r0, #LED_5
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	mov r0, #LED_6
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	mov r0, #LED_7
	mov r1, #GPIO_PINMODE_OUTPUT
	bl _gpio_set_pinmode

	mov r4, #0

_testloop:
	tst r4, #0x1
	beq _testloop_led0_off
	b _testloop_led0_on

	_testloop_led0_on:
	mov r1, #1
	b _testloop_l1

	_testloop_led0_off:
	eor r1, r1, r1

	_testloop_l1:
	mov r0, #LED_0
	bl _gpio_set_level

	tst r4, #0x2
	beq _testloop_led1_off
	b _testloop_led1_on

	_testloop_led1_on:
	mov r1, #1
	b _testloop_l2

	_testloop_led1_off:
	eor r1, r1, r1

	_testloop_l2:
	mov r0, #LED_1
	bl _gpio_set_level

	tst r4, #0x4
	beq _testloop_led2_off
	b _testloop_led2_on

	_testloop_led2_on:
	mov r1, #1
	b _testloop_l3

	_testloop_led2_off:
	eor r1, r1, r1

	_testloop_l3:
	mov r0, #LED_2
	bl _gpio_set_level

	tst r4, #0x8
	beq _testloop_led3_off
	b _testloop_led3_on

	_testloop_led3_on:
	mov r1, #1
	b _testloop_l4

	_testloop_led3_off:
	eor r1, r1, r1

	_testloop_l4:
	mov r0, #LED_3
	bl _gpio_set_level

	tst r4, #0x10
	beq _testloop_led4_off
	b _testloop_led4_on

	_testloop_led4_on:
	mov r1, #1
	b _testloop_l5

	_testloop_led4_off:
	eor r1, r1, r1

	_testloop_l5:
	mov r0, #LED_4
	bl _gpio_set_level

	tst r4, #0x20
	beq _testloop_led5_off
	b _testloop_led5_on

	_testloop_led5_on:
	mov r1, #1
	b _testloop_l6

	_testloop_led5_off:
	eor r1, r1, r1

	_testloop_l6:
	mov r0, #LED_5
	bl _gpio_set_level

	tst r4, #0x40
	beq _testloop_led6_off
	b _testloop_led6_on

	_testloop_led6_on:
	mov r1, #1
	b _testloop_l7

	_testloop_led6_off:
	eor r1, r1, r1

	_testloop_l7:
	mov r0, #LED_6
	bl _gpio_set_level

	tst r4, #0x80
	beq _testloop_led7_off
	b _testloop_led7_on

	_testloop_led7_on:
	mov r1, #1
	b _testloop_l8

	_testloop_led7_off:
	eor r1, r1, r1

	_testloop_l8:
	mov r0, #LED_7
	bl _gpio_set_level

	ldr r0, =TEST_DELAYTIME
	bl _delay32

	add r4, r4, #1

	b _testloop

_testend:
	b _sysend


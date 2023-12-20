@Test 2: Test GPIO

.equ BUTTON_0, 5
.equ BUTTON_1, 6
.equ LED_0, 24
.equ LED_1, 25
.equ LED_2, 26
.equ LED_3, 27

.equ TEST_DELAYTIME, 0x1000

.section .text

_teststart:
	mov r0, #BUTTON_0
	bl _gpio_reset_pin

	mov r0, #BUTTON_1
	bl _gpio_reset_pin

	mov r0, #LED_0
	bl _gpio_reset_pin

	mov r0, #LED_1
	bl _gpio_reset_pin

	mov r0, #LED_2
	bl _gpio_reset_pin

	mov r0, #LED_3
	bl _gpio_reset_pin

	mov r0, #BUTTON_0
	mov r1, #GPIO_PINMODE_INPUT
	bl _gpio_set_pinmode

	mov r0, #BUTTON_0
	mov r1, #GPIO_PUDCTRL_PULLUP
	bl _gpio_set_pudctrl

	mov r0, #BUTTON_1
	mov r1, #GPIO_PINMODE_INPUT
	bl _gpio_set_pinmode

	mov r0, #BUTTON_1
	mov r1, #GPIO_PUDCTRL_PULLUP
	bl _gpio_set_pudctrl

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

	bl _test_update_led_status

_testloop:
	mov r0, #BUTTON_0
	bl _gpio_get_level

	eor r1, r1, r1
	mvn r1, r1
	tst r0, r1
	beq _testloop_button0_clicked
	b _testloop_l1

	_testloop_button0_clicked:
	bl _test_button0_clicked

	_testloop_l1:

	mov r0, #BUTTON_1
	bl _gpio_get_level

	eor r1, r1, r1
	mvn r1, r1
	tst r0, r1
	beq _testloop_button1_clicked
	b _testloop_l2

	_testloop_button1_clicked:
	bl _test_button1_clicked

	_testloop_l2:

	ldr r0, =TEST_DELAYTIME
	bl _delay32

	b _testloop

_testend:
	b _sysend

_test_button0_clicked:
	push {r12}
	mov r12, sp

	push {lr}

	ldr r1, =_test_byte
	ldrb r0, [r1]

	sub r0, r0, #1
	strb r0, [r1]

	bl _test_update_led_status

	_test_button0_loop:
	ldr r0, =TEST_DELAYTIME
	bl _delay32
	mov r0, #BUTTON_0
	bl _gpio_get_level
	eor r1, r1, r1
	mvn r1, r1
	tst r0, r1
	beq _test_button0_loop
	_test_button0_endloop:

	_test_button0_clicked_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]

	mov sp, r12
	pop {r12}

	bx r3

_test_button1_clicked:
	push {r12}
	mov r12, sp

	push {lr}

	ldr r1, =_test_byte
	ldrb r0, [r1]

	add r0, r0, #1
	strb r0, [r1]

	bl _test_update_led_status

	_test_button1_loop:
	ldr r0, =TEST_DELAYTIME
	bl _delay32
	mov r0, #BUTTON_1
	bl _gpio_get_level
	eor r1, r1, r1
	mvn r1, r1
	tst r0, r1
	beq _test_button1_loop
	_test_button1_endloop:

	_test_button1_clicked_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]

	mov sp, r12
	pop {r12}

	bx r3

_test_update_led_status:
	push {r12}
	mov r12, sp

	push {lr}
	push {r4}

	ldr r1, =_test_byte
	ldrb r4, [r1]

	tst r4, #0x1
	beq _test_update_led_status_led0_off

	_test_update_led_status_led0_on:
	mov r1, #1
	b _test_update_led_status_l1

	_test_update_led_status_led0_off:
	eor r1, r1, r1

	_test_update_led_status_l1:
	mov r0, #LED_0
	bl _gpio_set_level

	tst r4, #0x2
	beq _test_update_led_status_led1_off

	_test_update_led_status_led1_on:
	mov r1, #1
	b _test_update_led_status_l2

	_test_update_led_status_led1_off:
	eor r1, r1, r1

	_test_update_led_status_l2:
	mov r0, #LED_1
	bl _gpio_set_level

	tst r4, #0x4
	beq _test_update_led_status_led2_off

	_test_update_led_status_led2_on:
	mov r1, #1
	b _test_update_led_status_l3

	_test_update_led_status_led2_off:
	eor r1, r1, r1

	_test_update_led_status_l3:
	mov r0, #LED_2
	bl _gpio_set_level

	tst r4, #0x8
	beq _test_update_led_status_led3_off

	_test_update_led_status_led3_on:
	mov r1, #1
	b _test_update_led_status_l4

	_test_update_led_status_led3_off:
	eor r1, r1, r1

	_test_update_led_status_l4:
	mov r0, #LED_3
	bl _gpio_set_level

	_test_update_led_status_return:
	mov r1, r12
	sub r1, r1, #4
	ldr r3, [r1]
	sub r1, r1, #4
	ldr r4, [r1]

	mov sp, r12
	pop {r12}

	bx r3

.section .data

_test_byte:
.byte 0


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
	ldr r0, =BUTTON_0
	push {r0}
	bl _gpio_reset_pin

	ldr r0, =BUTTON_1
	push {r0}
	bl _gpio_reset_pin

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

	ldr r0, =BUTTON_0
	ldr r1, =GPIO_PINMODE_INPUT
	push {r0}
	push {r1}
	bl _gpio_set_pinmode

	ldr r0, =BUTTON_0
	ldr r1, =GPIO_PUDCTRL_PULLUP
	push {r0}
	push {r1}
	bl _gpio_set_pudctrl

	ldr r0, =BUTTON_1
	ldr r1, =GPIO_PINMODE_INPUT
	push {r0}
	push {r1}
	bl _gpio_set_pinmode

	ldr r0, =BUTTON_1
	ldr r1, =GPIO_PUDCTRL_PULLUP
	push {r0}
	push {r1}
	bl _gpio_set_pudctrl

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

	bl _test_update_led_status

_testloop:
	ldr r0, =BUTTON_0
	push {r0}
	bl _gpio_get_level

	ldr r1, =0xffffffff
	tst r0, r1
	beq _testloop_button0_clicked
	b _testloop_l1

	_testloop_button0_clicked:
	bl _test_button0_clicked

	_testloop_l1:

	ldr r0, =BUTTON_1
	push {r0}
	bl _gpio_get_level

	ldr r1, =0xffffffff
	tst r0, r1
	beq _testloop_button1_clicked
	b _testloop_l2

	_testloop_button1_clicked:
	bl _test_button1_clicked

	_testloop_l2:

	ldr r0, =TEST_DELAYTIME
	push {r0}
	bl _delay32

	b _testloop

_testend:
	b _sysend

_test_button0_clicked:
	ldr r4, =_stacklist
	ldr r1, =_stacklist_index
	ldr r2, [r1]
	add r4, r4, r2
	str lr, [r4]
	add r2, r2, #4
	str r2, [r1]

	ldr r1, =_test_byte
	ldrb r0, [r1]

	sub r0, r0, #1
	strb r0, [r1]

	bl _test_update_led_status

	_test_button0_loop:
	ldr r1, =TEST_DELAYTIME
	push {r1}
	bl _delay32
	ldr r1, =BUTTON_0
	push {r1}
	bl _gpio_get_level
	ldr r1, =0xffffffff
	tst r0, r1
	beq _test_button0_loop
	_test_button0_endloop:

	_test_button0_clicked_return:
	ldr r4, =_stacklist
	ldr r1, =_stacklist_index
	ldr r2, [r1]
	sub r2, r2, #4
	add r4, r4, r2
	ldr r3, [r4]
	str r2, [r1]

	bx r3

_test_button1_clicked:
	ldr r4, =_stacklist
	ldr r1, =_stacklist_index
	ldr r2, [r1]
	add r4, r4, r2
	str lr, [r4]
	add r2, r2, #4
	str r2, [r1]

	ldr r1, =_test_byte
	ldrb r0, [r1]

	add r0, r0, #1
	strb r0, [r1]

	bl _test_update_led_status

	_test_button1_loop:
	ldr r1, =TEST_DELAYTIME
	push {r1}
	bl _delay32
	ldr r1, =BUTTON_1
	push {r1}
	bl _gpio_get_level
	ldr r1, =0xffffffff
	tst r0, r1
	beq _test_button1_loop
	_test_button1_endloop:

	_test_button1_clicked_return:
	ldr r4, =_stacklist
	ldr r1, =_stacklist_index
	ldr r2, [r1]
	sub r2, r2, #4
	add r4, r4, r2
	ldr r3, [r4]
	str r2, [r1]

	bx r3

_test_update_led_status:
	ldr r4, =_stacklist
	ldr r1, =_stacklist_index
	ldr r2, [r1]
	add r4, r4, r2
	str lr, [r4]
	add r2, r2, #4
	str r2, [r1]

	ldr r1, =_test_byte
	ldrb r8, [r1]

	tst r8, #0x1
	beq _test_update_led_status_led0_off

	_test_update_led_status_led0_on:
	ldr r0, =LED_0
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level
	b _test_update_led_status_l1

	_test_update_led_status_led0_off:
	ldr r0, =LED_0
	eor r1, r1, r1
	push {r0}
	push {r1}
	bl _gpio_set_level

	_test_update_led_status_l1:

	tst r8, #0x2
	beq _test_update_led_status_led1_off

	_test_update_led_status_led1_on:
	ldr r0, =LED_1
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level
	b _test_update_led_status_l2

	_test_update_led_status_led1_off:
	ldr r0, =LED_1
	eor r1, r1, r1
	push {r0}
	push {r1}
	bl _gpio_set_level

	_test_update_led_status_l2:

	tst r8, #0x4
	beq _test_update_led_status_led2_off

	_test_update_led_status_led2_on:
	ldr r0, =LED_2
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level
	b _test_update_led_status_l3

	_test_update_led_status_led2_off:
	ldr r0, =LED_2
	eor r1, r1, r1
	push {r0}
	push {r1}
	bl _gpio_set_level

	_test_update_led_status_l3:

	tst r8, #0x8
	beq _test_update_led_status_led3_off

	_test_update_led_status_led3_on:
	ldr r0, =LED_3
	ldr r1, =1
	push {r0}
	push {r1}
	bl _gpio_set_level
	b _test_update_led_status_l4

	_test_update_led_status_led3_off:
	ldr r0, =LED_3
	eor r1, r1, r1
	push {r0}
	push {r1}
	bl _gpio_set_level

	_test_update_led_status_l4:

	_test_update_led_status_return:
	ldr r4, =_stacklist
	ldr r1, =_stacklist_index
	ldr r2, [r1]
	sub r2, r2, #4
	add r4, r4, r2
	ldr r3, [r4]
	str r2, [r1]

	bx r3

.section .data

_test_byte:
.byte 0


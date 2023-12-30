#!/bin/bash

arm-none-eabi-as kernel.s -march=armv7 -mcpu=cortex-a53 -o kernel.o
arm-none-eabi-ld kernel.o -o kernel7.elf
arm-none-eabi-objcopy -O binary kernel7.elf kernel7.img

if [ -f "final/kernel7.img" ]; then
	rm final/kernel7.img
fi

cp kernel7.img final/


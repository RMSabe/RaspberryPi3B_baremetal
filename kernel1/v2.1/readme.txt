Mini Kernel aarch32 for Raspberry Pi 3B
Kernel 1 version 2.1

All subroutines/functions are called using "bl" instruction and "lr" register.

Arguments are passed by caller function to callee function using registers r0 through r3

Register r12 is used as a stack base pointer.

Just as in the call stack procedure, callee function will have its own stack base. Callee function must restore the values in r12 (stack base) and sp (stack top) before returning to the caller function.

When calling a function, the value in registers r0 through r3 must be saved by caller function before jumping to the callee function. The value in these registers will not be restored by callee function, if they're changed.

Callee function should always restore the values in registers r4 through r11, as well as r12 and sp, before returning to the caller function, in case those values are changed.

Updates:
Some minor changes in the code, to make it more versatile.
Added an LCD driver to the code.
Added some string functions to the code.

Assembly:
I used the ARM EABI assembler:
run "arm-none-eabi-as kernel.s -march=armv7 -mcpu=cortex-a53 -o kernel.o" to assemble the source into an object file.
run "arm-none-eabi-ld kernel.o -o kernel.elf" to generate the final ELF executable
run "arm-none-eabi-objcopy -O binary kernel.elf kernel7.img" to convert the ELF executable to raw binary. Notice: raw binary file must be named "kernel7.img".
Just in case, I left a "build.sh" file to help.

When loading the code, a few boot binaries will be needed to load and run the kernel.
These binaries can be found on the Raspberry Pi GitHub repo.
More specifically in this path: https://github.com/raspberrypi/firmware/tree/master/boot/

The 3 files needed to start Raspberry Pi are: "bootcode.bin" "fixup.dat" "start.elf"
A "config.txt" file will also be necessary, used to instruct the startup to an aarch32 or aarch64 system. In this case, it should be set to aarch32.
I left a copy of all these files in a folder called "final".

Loading the code:
Format an SD card to FAT file system.
Copy to the SD card the boot binaries used to start Raspberry Pi 3B
Copy to the SD card the "config.txt" file.
Copy to the SD card the "kernel7.img" file.

Author: Rafael Sabe
Email: rafaelmsabe@gmail.com


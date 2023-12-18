Mini Kernel aarch32 for Raspberry Pi 3B

A few things to know:

All subroutines/functions are called using "bl" instruction and "lr" register.

_stacklist and _stacklist_index: _stacklist is a memory buffer used as a "parallel stack". _stacklist_index holds the index to the _stacklist buffer.
_stacklist_index points to the next available space on _stacklist buffer, therefore, it must be updated whenever a value is pushed in/popped out of _stacklist

subroutines/functions may overwrite the values in registers r0 through r7. The values in these registers must be saved in memory before calling a subroutine/function.

Arguments are passed to subroutines/functions using the stack. All arguments must be popped out of the stack before returning to the caller routine.

WARNING:
Unfortunatelly, I found out there are limitations with values in the ARM architecture.
Apparently you may not use an immediate value or memory address that is further than 4kiB away from the code.
That basically means this kernel only works with codes smaller than 4kiB
Hopefully I will be able to fix that in a newer version.

Assembly:
I used the ARM EABI assembler:
run "arm-none-eabi-as kernel.s -march=armv7 -mcpu=cortex-a53 -o kernel.o" to assemble the source into an object file.
run "arm-none-eabi-ld kernel.o -o kernel.elf" to generate the final ELF executable
run "arm-none-eabi-objcopy -O binary kernel.elf kernel7.img" to convert the ELF executable to raw binary. Notice: raw binary file must be named "kernel7.img".
Just in case, I left a "build.sh" file to help.

When loading the code, I few boot binaries will be needed to load and run the kernel.
These binaries can be found on the Raspberry Pi GitHub repo.
More specifically in this path: https://github.com/raspberrypi/firmware/tree/master/boot/

The 3 files needed to start Raspberry Pi are: "bootcode.bin" "fixup.dat" "start.elf"
A "config.txt" file will also be necessary, to instruct the startup as an aarch32 or aarch64 system. In this case, it should be set to aarch32.
I left a copy of all these files in a folder called "final".

Loading the code:
Format an SD card to FAT file system.
Copy to the SD card the boot binaries used to start Raspberry Pi 3B
Copy to the SD card the "config.txt" file.
Copy to the SD card the "kernel7.img" file.

Author: Rafael Sabe
Email: rafaelmsabe@gmail.com


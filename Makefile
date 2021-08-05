# Automatically generate lists of sources using wildcards.
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

# TODO: Make sources dep on all header files.

# Convert the *.c filenames to *.o to give a list of object files to build
OBJ = $(C_SOURCES:.c=.o)

# Default build target
all: os-image

# Run qemu to stimulate booting of our code
run: all
	qemu-system-x86_64 os-image

# This is the actual disk image that the computer load,
# which is the combination of our compiled bootsector and kernel
os-image: boot_sect.bin kernel.bin
	cat $^ > $@

# Build the kernel binary
kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary --entry main

# Build the kernel object file
%.o: %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@

# Build the boot_sect_binary
boot_sect.bin: boot/boot_sect_kernel.asm
	nasm $< -f bin -o $@
	
	
# Build the kernel entry object file
%.o: %.asm
	nasm $< -f elf64 -o $@

# Clean the files except for source files
clean:
	rm -fr *.bin *.o os-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o

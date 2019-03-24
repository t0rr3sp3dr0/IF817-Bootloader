build: boot.img

boot.img: 7c00.bin 0500.bin 7e00.bin
	cat 7c00.bin 0500.bin 7e00.bin > boot.img

7c00.bin: 7c00.asm
	nasm -f bin -o 7c00.bin 7c00.asm

0500.bin: 0500.asm
	nasm -f bin -o 0500.bin 0500.asm

7e00.bin: 7e00.asm
	nasm -f bin -o 7e00.bin 7e00.asm

run: boot.img
	qemu-system-i386 boot.img

clean:
	rm -f *.bin boot.img

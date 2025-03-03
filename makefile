# first build evil_main and show it's exec size in bytes
build_evil:
	clang evil_main.c -o evil
	wc -c evil

# ------------------------- Compiling GCC asm files ----------------------------------- 
# compile w/o all link and helper to reduce the size at its lowest (can be still improved) 
# fun fact with clang it's a bit higher than gcc
# but for cmp purpose i choose clang
example_build_asm_atat:
	clang -nostdlib -s -O2 sys.s main.c -static -Wl,-nmagic -o good_atat 
	wc -c good_atat

example_build_asm_intel:
	clang -nostdlib -s -O2 sys_intel.s main.c -static -Wl,-nmagic -o good_intel
	wc -c good_intel
# ------------------------- Compiling GCC asm files -----------------------------------

nostd: syscall
	clang -nostdlib -O2 syscall.o main.c -static -o nostdex -fno-builtin

# build syscall.asm using nasm
syscall:
	nasm -felf64 syscall.asm

clean:
	rm -rf syscall.o good* evil nostdex


# first build evil_main and show it's exec size in bytes
build_evil:
	clang evil_main.c -o evil
	wc -c evil

# compile w/o all link and helper to reduce the size at its lowest (can be still improved) 
# fun fact with clang it's a bit higher than gcc
# but for cmp purpose i choose clang
build_good_atat:
	clang -nostdlib -s -O2 sys.s main.c -static -Wl,-nmagic -o good_atat 
	wc -c good_atat

build:
	clang -nostdlib -s -O2 sys_intel.s main.c -static -Wl,-nmagic -o good_intel -g
	wc -c good_intel

clean:
	rm -rf good* evil

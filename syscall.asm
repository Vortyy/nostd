extern main
	
section .note.GNU-stack noalloc noexec nowrite progbits

; cat /proc/id/maps
section .text

global _start, syscall5, brk_alloc, mmap_alloc

_start:
  xor rbp, rbp
  pop rdi
  mov rsi, rsp 
  call main
	
  mov rdi, rax
  mov rax, 60
  syscall

syscall5:
  mov rax,rdi
  mov rdi,rsi
  mov rsi,rdx
  mov rdx,rcx
  mov r10,r8
  mov r8,r9
  syscall
  ret
  
;; for virtual addr alloc can see them on /proc/id/maps
;; https://gist.github.com/nikAizuddin/f4132721126257ec4345 fuck clib ??why they change brk return??
brk_alloc:
  mov rax, 12 ; SYS_brk 
  mov rdi, 0
  syscall

  ;; NOTE : [] mov for var work as ptr references purely as C does [] <=> * <=> derefecing
  ;; NOTE : it's impossible change the addr of data element mov brk_firstpos, rax (forbidden)
  ;; here we store at the address 0x4025 the value of the first address of the heap
  ;; so brk_firstpos -> addr: 0x402500) val: 0x403000
  mov qword [brk_firstpos], rax

  ;; lea take the always the address of  
  ;; allocation with syscall brk
  lea rdi, [rax + 5000] 
  mov rax, 12
  syscall

  ;; we change content inside the value of the addr 0x403000
  mov rsi, brk_firstpos
  mov rdi, [brk_firstpos]
  mov byte [rdi], 'f'
  mov byte [rdi + 1], 'u'
  mov byte [rdi + 2], 0

  mov rax, [brk_firstpos]
  ret

;; ONLY diff between brk/mmap is memory fragmentation pb 
mmap_alloc:
  mov rax, 9 ; SYS_mmap 
  mov rdi, 0 ; addr NULL
  mov rsi, 50; size 1 pages 
  mov rdx, 0x3 ; prot READ_WRITE = 3 = 0x1 | 0x2 (READ | WRITE)
  mov r10, 0x22; flag MAP_ANON = 32 = 0x20
  mov r8, -1; fd
  mov r9 , 0; offset 
  syscall

  mov qword [brk_firstpos], rax

  ;; we change content inside the value of the addr 0x403000
  mov rsi, brk_firstpos
  mov rdi, [brk_firstpos]
  mov byte [rdi], 'f'
  mov byte [rdi + 1], 'u'
  mov byte [rdi + 2], 0

  ret

munmap: 
  ;; munmap --> unmap the complete pages
  mov rax, 11 ; SYS_munmap
  mov rdi, [brk_firstpos]
  mov rsi, 50
  syscall

  ret

section .bss 
brk_firstpos: resq 1
  
;;.data section add a padding of 4096 byte aligned address ??? seem to be a page
section .data

;the last number is append to end of string 
;here -> 10 = uincode '\n'
message: db "test", 10 

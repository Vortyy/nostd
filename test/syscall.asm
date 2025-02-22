extern main

section .text

global _start, syscall5, allocate

_start:
  xor rbp, rbp
  pop rdi
  mov rsi, rsp 
  call allocate 

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

;; https://gist.github.com/nikAizuddin/f4132721126257ec4345 fuck clib ??why they change brk return??
allocate:
  mov rax, 12 ; SYS_brk 
  mov rdi, 0
  syscall

  ;; NOTE : [] work as ptr references purely as C does [] <=> * <=> derefecing
  ;; NOTE : it's impossible change the addr of data element mov brk_firstpos, rax (forbidden)
  ;; here we store at the address 0x4025 the value of the first address of the heap
  ;; so brk_firstpos -> addr: 0x402500) val: 0x403000
  mov qword [brk_firstpos], rax

  ;; allocation with syscall brk
  lea rdi, [rax + 3]
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

  
;;.data section add a padding of 4096 byte aligned address ??? seem to be a page
section .data

;the last number is append to end of string 
;here -> 10 = uincode '\n'
message: db "test", 10 
brk_firstpos: dq 0 

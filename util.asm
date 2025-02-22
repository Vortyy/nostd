section .text

global _start,syscall5

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

section .data

;the last number is append to end of string 
;here -> 10 = uincode '\n'
message: db "test", 10 

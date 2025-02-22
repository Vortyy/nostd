.intel_syntax noprefix

.text:

.globl: _start

_start:
  mov rax, 60
  mov rdi, 69
  syscall

/* intel syntax version of syscall5 */

/*
  intel syntax change drastically the way asm is written, one of the major change
  is to change the order of action such as [mov dest, src] in intel or the removing
  of length precision like movb, movw, movl, movq (bytes 1, word 2, doubleword 4, 
  quadword 8)
*/
.intel_syntax noprefix

/* this marks the .text section of a PE executable, which contains
   program code */
.text
    /* exports syscall5 to other compilation units (files) */
.globl _start, syscall5

_start:
  xor rbp,rbp /* xoring a value with itself = 0 */
  pop rdi /* rdi = argc */
  /* the pop instruction already added 8 to rsp */
  mov rsi,rsp /* rest of the stack as an array of char ptr */

  /* in linux kernel rsp is already aligned to 16bytes
     but sometimes you need to align rsp manually
  and rsp, -16
  */
  call main

  mov rdi, rax
  mov rax, 60 /* SYS_exit */
  syscall

  ret /* should never be reach */

syscall5:
  mov rax,rdi
  mov rdi,rsi
  mov rsi,rdx
  mov rdx,rcx
  mov r10,r8
  mov r8,r9
  syscall
  ret

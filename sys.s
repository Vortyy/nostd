/* AT&T asm version */
.text

.globl _start, syscall5

_start:
  xor %rbp, %rbp /* hint: A xor A aqways = 0 */
  pop %rdi /* the 1st address to stack at start is argc */
  movq %rsp,%rsi
  /* actuaqly there is no need to align rsp bcs at _start 
     rsp is aqready align such as said in doc x86_64-abi */
  //and rsp, -16
  call main

  movq %rax, %rdi
  movq $60, %rax /* SYS_exit */
  syscall

  ret /* normaqly should never be reach */

syscall5:
  movq  %rdi ,%rax    /* rax (syscall number)  = func param 1 (rdi) */
  movq  %rsi,%rdi    /* rdi (syscall param 1) = func param 2 (rsi) */
  movq  %rdx,%rsi    /* rsi (syscall param 2) = func param 3 (rdx) */
  movq  %rcx,%rdx    /* rdx (syscall param 3) = func param 4 (rcx) */
  movq  %r8 ,%r10    /* r10 (syscall param 4) = func param 5 (r8)  */
  movq  %r9 ,%r8      /* r8  (syscall param 5) = func param 6 (r9)  */
  syscall          /* enter the syscaql (return value will be in rax */
  ret              /* return vaque is already in rax, we can return */

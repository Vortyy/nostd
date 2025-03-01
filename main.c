/****************************************************
 * Nostd:
 *
 * This code is purely to show an example, that is
 * possible to write C code w/o stdlib (or libc) and
 * and make it work and give some hint about how
 * memory allocation works under the hood.
 *
 * REF:
 *  - https://gist.github.com/tcoppex/443d1dd45f873d96260195d6431b0989#file-c_nostd-txt-L473
 **************************************************/

// ---------------- syscall.asm ------------------- //

typedef unsigned long int uintptr; /* size_t */
typedef long int intptr; /* ssize_t */

extern void* syscall5
(
  void* number,
  void* arg1,
  void* arg2,
  void* arg3,
  void* arg4,
  void* arg5
);

/* allocate a page on the .data segment using brk */
extern void* brk_alloc();

/* allocate a map using mmap from syscall */
extern void* mmap_alloc();
   
static intptr write(int fd, void const* data, uintptr nbytes)
{
  return (intptr)
    syscall5(
      (void *) 1, /* SYS_write */
      (void *) (intptr) fd,
      (void *) data,
      (void *) nbytes,
      0, /* ignored */
      0  /* ignored */
   );
}

// ---------------- syscall.asm ------------------- //

// ---------------- mystdio.h --------------------- //

#include <stdarg.h>
#define print(msg) write(stdout, msg, strlen(msg)) /* print a cst char to stdout w/o formatting */

#define NULL 0
#define EOF (-1)
#define BUFSIZ 5 

#define stdout 1

typedef struct _iob {
  int cnt;
  char *ptr;
  char *base;
} buffer;

char base[BUFSIZ];
buffer stdout_buffer = {
  .cnt = BUFSIZ,
  .base = base,
  .ptr = base 
};

/* _flushbuf : flush a buffer to stdout, reset buffer and if c add it at the buffer first position */
int _flushbuf(int c, buffer *buffer){  
  int nc = buffer->ptr - buffer->base;
  if(write(stdout, buffer->base, nc) != nc)
    return EOF;

  // Manually flushed
  if(c == EOF){
    buffer->cnt = BUFSIZ;
    buffer->ptr = buffer->base;
    return NULL;
  }

  buffer->cnt = BUFSIZ - 1;
  buffer->ptr = buffer->base;
  *buffer->ptr++ = (char) c;

  return c;
}

/* _flushout : manually flush stdout_buffer */
#define _flushout() _flushbuf(EOF, &stdout_buffer) 
#define putchar(x) (--stdout_buffer.cnt >= 0 ? *stdout_buffer.ptr++ = (x) : _flushbuf((x), &stdout_buffer))
#define abs(x) ((x < 0) ? -(x) : (x))

typedef union printf_var {
  int ival;
  float fval;
  char cval;
  void *pval;
} pfv;

int strlen(char *str){
  int i = 0;
  while(*str++)
    i++;
  return i;
}

void itoa(int n, char *s){
  int sign, i;
  sign = n;

  do {
    *s++ = abs(n % 10) + '0';
  } while ((n /= 10) != 0);

  if(sign < 0)
    *s++ = '-';

  *s = '\0';
}

void printf(const char *fmt, ...){
  va_list ap;
  pfv current_arg;
  char buff[100];
  char *p;
  
  va_start(ap, fmt);
  for(; *fmt; fmt++){
    if(*fmt != '%'){
      putchar(*fmt);
      continue;
    }

    switch(*++fmt){
    case 'd': /* int case */
      current_arg.ival = va_arg(ap, int);
      itoa(current_arg.ival, buff);
      int i = strlen(buff);
      while(i-- > 0){
        char c = *(buff + i);
        putchar(c);
      }
      break;
    default:
      print("error: not supported format");
    }
  }

  if(stdout_buffer.cnt != BUFSIZ)
    _flushout();
}

// ---------------- mystdio.h --------------------- //

int main(int argc, char *argv[]){
  if(argc-- > 1){
    char *str = *++argv;
    print(str);
  }

  //should print "fu" w/o break line
  char *brk_str = (char *) brk_alloc();
  print(brk_str);

  // should print "fu" w/o break line
  char *mmap_str = (char*) mmap_alloc();
  print(mmap_str);
  
  int test = -100;
  printf("testing this printf %d\n", test);
  return 0;
}

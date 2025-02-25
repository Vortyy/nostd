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

/* allocate 4 bytes into heap (<=> addr data segment +4 bytes ) thx to syscall brk */
extern void* allocate();

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

int strlen(char *str){
  int i = 0;
  while(*str++)
    i++;
  return i;
}

// ---------------- mystdio.h --------------------- //

int main(int argc, char *argv[]){
  if(argc-- > 1){
    char *str = *++argv;
    print(str);
  }

  for(int i = 0; i < 300; i++)
    putchar('c');

  _flushout();
  return 0;
}

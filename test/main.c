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

typedef unsigned long int uintptr; /* size_t */
typedef long int intptr; /* ssize_t */

#define stdout 1
#define print(msg) write(stdout, msg, strlen(msg)) /* print to stdout w/o formatting */

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

int strlen(char *str){
  int i = 0;
  while(*str++)
    i++;
  return i;
}

int main(int argc, char *argv[]){
  if(argc-- > 1){
    char *str = *++argv;
    print(str);
  }

  char* brk_res = (char *) allocate();
  print(brk_res);

  return 0;
}

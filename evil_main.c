#include<stdio.h>
#include<unistd.h>

void* counter();

int strlen(char *str){
  int i = 0;
  while(*str++)
    i++;
  return i;
}

int main(int argc, char* argv[]){
  printf("%lu\n", (long int) counter());
  printf("%lu\n", sizeof(long int));
  printf("%d\n", strlen("hello\n"));
  printf("hello\n");
  return 0;
}

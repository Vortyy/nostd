#include<stdio.h>

int strlen(char *str){
  int i = 0;
  while(*str++)
    i++;
  return i;
}

int main(int argc, char* argv[]){
  printf("%d\n", strlen("hello\n"));
  printf("hello\n");
  return 0;
}

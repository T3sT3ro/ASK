#include <stdio.h>
#include <stdlib.h>

int clz(long x);

int main(int argc, char **argv){
   if(argc < 2)
      return EXIT_FAILURE;
   long x = strtol(argv[1], NULL, 10);

   printf("CLZ %ld =  %d\n", x, clz(x));

   return EXIT_SUCCESS;
}

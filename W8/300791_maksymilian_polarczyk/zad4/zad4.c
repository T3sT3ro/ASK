#include <stdio.h>
#include <stdlib.h>

unsigned long fibonacci(unsigned long n);

int main(int argc, char **argv){
   if(argc < 2)
      return EXIT_FAILURE;
   
   unsigned long x = strtoul(argv[1], NULL, 10);

   printf("Fib(%lu) = %lu\n",x,  fibonacci(x));

   return EXIT_SUCCESS;
}

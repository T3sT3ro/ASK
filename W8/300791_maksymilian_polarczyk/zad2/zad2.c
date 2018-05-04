#include <stdio.h>
#include <stdlib.h>

typedef struct {
    unsigned long lcm, gcd;
} result_t;

result_t lcm_gcd(unsigned long , unsigned long);

int main(int argc, char **argv){
   if(argc < 3)
      return EXIT_FAILURE;
   
   unsigned long a = strtoul(argv[1], NULL, 10);
   unsigned long b = strtoul(argv[2], NULL, 10);


   result_t x = lcm_gcd(a,b);

   printf("a=%lu b=%lu gcd=%lu lcm=%lu\n", a, b, x.gcd, x.lcm);

   return EXIT_SUCCESS;
}

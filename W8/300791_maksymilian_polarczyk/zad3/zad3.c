#include <stdio.h>
#include <stdlib.h>

// last points to the last element in array
void insert_sort(long *first, long *last);

int main(int argc, char **argv){
   if(argc < 2)
      return EXIT_FAILURE;
   
   long* T = calloc(argc-1, sizeof(long));
   for(int i=0; i< argc-1; ++i) 
      T[i] = strtol(argv[i+1], NULL, 10);

   if(T == NULL) 
      return EXIT_FAILURE;

   insert_sort(T, T+argc-2);


   for(int i=0; i< argc-1; ++i)
      printf("%ld ", T[i]);
   printf("\n");

   return EXIT_SUCCESS;
}

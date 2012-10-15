#include <stdio.h>
#include <stdlib.h>
#include "timers.h"

#define MAX 10000000

int main() {
  srand(time(NULL));
  int *v1, *v2, *v3, i;
  v1 = (int*)malloc(sizeof(int)*MAX);
  v2 = (int*)malloc(sizeof(int)*MAX);
  v3 = (int*)malloc(sizeof(int)*MAX);
  for(i=0;i<MAX;i++) {
    v1[i] = rand();
    v2[i] = rand();
  }
  
  pTimer zegar = newTimer(); // make new timer
  
  startTimer(zegar); // store first timestamp
  // some long taking actions
  for(i=0;i<MAX;i++)
    v3[i] = v1[i] + v2[i];
  
  stopTimer(zegar);  // store second timestamp
  printf("Calkowity czas cpu: ");
  printTimer(zegar); // show time difference
  printf("\n");

  /* for(i=0;i<MAX;i++) */
  /*   printf("v3: %d ",v3[i]); */

  freeTimer(zegar);  // free occupied ram

  return 0;
}

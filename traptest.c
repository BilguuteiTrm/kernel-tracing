#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  printf(1, "traptest: starting, triggering page fault...\n");
  // Dereference NULL to trigger a page fault
  int *p = 0;
  *p = 123;
  printf(1, "traptest: should have been killed! result=%d\n", *p);
  exit();
}

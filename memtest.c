#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  char *p;
  printf(1, "memtest: starting\n");
  p = sbrk(4096);
  if(p == (char*)-1){
    printf(1, "sbrk failed\n");
    exit();
  }
  *p = 'a';
  printf(1, "memtest: sbrk(4096) ok, touching memory ok\n");
  sbrk(4096);
  printf(1, "memtest: done\n");
  exit();
}

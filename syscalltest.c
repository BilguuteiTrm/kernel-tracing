#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  printf(1, "syscalltest: starting\n");
  getpid();
  write(1, "hello\n", 6);
  open("nonexistentfile", 0);
  sleep(10);
  printf(1, "syscalltest: done\n");
  exit();
}

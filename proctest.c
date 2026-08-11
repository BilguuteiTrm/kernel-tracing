#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int pid;

  printf(1, "proctest: starting\n");
  pid = fork();
  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }
  if(pid == 0){
    printf(1, "child: sleeping\n");
    sleep(20);
    printf(1, "child: exiting\n");
    exit();
  } else {
    printf(1, "parent: waiting for child %d\n", pid);
    wait();
    printf(1, "parent: child exited\n");
  }
  printf(1, "proctest: done\n");
  exit();
}

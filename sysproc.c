#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "trace.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

addr_t
sys_sbrk(void)
{
  addr_t addr;
  addr_t n;

  argaddr(0, &n);
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}


int
sys_traceread(void){
  struct trace_event *event;
  int max_events;

  // Get the max_events count first
  if(argint(1, &max_events) < 0)
    return -1;

  if(max_events <= 0)
    return 0;

  // Get the destination buffer and check if it's large enough for max_events
  if(argptr(0, (char**)&event, max_events * sizeof(struct trace_event)) < 0)
    return -1;

  return traceread(event, max_events);
}


int sys_vidclear(void){
  vidclear();
  return 0;
}

int
sys_vidputc(void){
  int row, col, ch, color;

  if(argint(0, &row) < 0)
    return -1;
  if(argint(1, &col) < 0)
    return -1;
  if(argint(2, &ch) < 0)
    return -1;
  if(argint(3, &color) < 0)
    return -1;

  vidputc(row, col, ch, color);
  return 0;
}

int sys_vidputs(void){
  int row, col, color;
  char *s;

  if(argint(0, &row) < 0)
    return -1;
  if(argint(1, &col) < 0)
    return -1;
  if(argstr(2, &s) < 0)
    return -1;
  if(argint(3, &color) < 0)
    return -1;

  vidputs(row, col, s, color);
  return 0;
}
#include "types.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "trace.h"
#include "proc.h"

#define TRACE_BUF_SIZE 128      // Remember the most recent 128

struct {
    struct spinlock lock;  // Lock for syncronization
    int enabled;           // turn on or off 
    uint seq;              // where the event is written
    uint readseq;          // the next event the user program should read
    uint overwritten;      // count of overwritten events
    struct trace_event events[TRACE_BUF_SIZE];  // Ring buffer
} traceBuffer;

// Initalize the tracing event
void 
traceinit(void){
    initlock(&traceBuffer.lock, "trace");
    traceBuffer.enabled = 1;
    traceBuffer.seq = 0;
    traceBuffer.readseq = 0;
    traceBuffer.overwritten = 0;
}

// trace the current event
void 
traceevent(int type, int pid, int arg0, int arg1, int arg2, char *name){
    struct trace_event *event;

    // if the trace buffer is not enabled, then return nothing
    if(!traceBuffer.enabled)
        return;

    //aquire the lock
    acquire(&traceBuffer.lock);
    // debug
    //cprintf("debug: traceevent type %d pid %d name %s\n", type, pid, name);


    event = &traceBuffer.events[traceBuffer.seq % TRACE_BUF_SIZE]; // Allows ring to wrap

    // Set the event metadata
    event->seq = traceBuffer.seq;
    event->ticks = ticks;
    event->type = type;
    event->pid = pid;
    event->arg0 = arg0;
    event->arg1 = arg1;
    event->arg2 = arg2;
    event->overwritten = traceBuffer.overwritten;

    memset(event->comm, 0, sizeof(event->comm));
    if(proc && proc->pid > 0) {
        safestrcpy(event->comm, proc->name, sizeof(event->comm));
    } else {
        safestrcpy(event->comm, "kernel", sizeof(event->comm));
    }

    memset(event->event, 0, sizeof(event->event));
    if(name)
        safestrcpy(event->event, name, sizeof(event->event));

    traceBuffer.seq++; // Update sequence number

    // If the writer gets more than 128 events ahead, old events are gone, move readseq  foreward to the oldest event still available
    if(traceBuffer.seq - traceBuffer.readseq > TRACE_BUF_SIZE) {
        traceBuffer.readseq = traceBuffer.seq - TRACE_BUF_SIZE;
        traceBuffer.overwritten++;
    }

    // Release the lock
    release(&traceBuffer.lock);
}

int
traceread(struct trace_event *dst, int max_events){
    int count = 0;

    if(max_events <= 0)
        return 0;

    acquire(&traceBuffer.lock);

    while(count < max_events && traceBuffer.readseq != traceBuffer.seq){
        struct trace_event event = traceBuffer.events[traceBuffer.readseq % TRACE_BUF_SIZE];
        traceBuffer.readseq++;
        
        // Release lock while copying to avoid holding it too long if copyout is slow
        // but wait, we need to be careful with readseq.
        // Actually, for xv6, keeping the lock is simpler and usually okay.
        
        if(copyout(proc->pgdir, (addr_t)&dst[count], &event, sizeof(event)) < 0){
            release(&traceBuffer.lock);
            return count > 0 ? count : -1;
        }
        count++;
    }

    release(&traceBuffer.lock);
    return count;
}
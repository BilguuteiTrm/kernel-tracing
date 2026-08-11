#pragma once

#include "types.h"

#define TRACE_TYPE_SYSCALL 1
#define TRACE_TYPE_PROC    2
#define TRACE_TYPE_TRAP    3
#define TRACE_TYPE_MEM     4
#define TYPE_NAME_FILTER   5

#define TRACE_NAME_LEN     16


struct trace_event {
    uint seq;       // Sequence number, number of events
    uint ticks;     // timestamp
    int type;       // What kind of event is it?
    int pid;        // Process ID that is causing this event
    int arg0;       // Argument 0: syscall number
    int arg1;       // Argument 1: syscall return value
    int arg2;       // Argument 2: syscall latency
    char comm[TRACE_NAME_LEN];  // Process name
    char event[TRACE_NAME_LEN]; // Event name
    uint overwritten;           // Number of overwritten events
};
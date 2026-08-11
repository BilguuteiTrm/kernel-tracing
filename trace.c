#include "types.h"
#include "stat.h"
#include "user.h"
#include "trace.h"
#include "syscall.h"


#define MAX_TRACE_ROWS 32
#define DEFAULT_DISPLAY_ROWS 15
#define COLOR_NORMAL 0x07
#define COLOR_TITLE 0x0f
#define COLOR_GREEN 0x0a
#define COLOR_CYAN 0x0b
#define COLOR_YELLOW 0x0e
#define COLOR_RED 0x0c

#define GRAPH_WIDTH 50

int sys_count, proc_count, mem_count, trap_count = 0;
int t_sys_count, t_proc_count, t_mem_count, t_trap_count = 0;
int display_rows = DEFAULT_DISPLAY_ROWS;

// Move large array to data segment to avoid stack overflow
static struct trace_event recent[MAX_TRACE_ROWS];

static char*
typename(int type){
    switch(type){
        case TRACE_TYPE_SYSCALL:
            return "syscall";
        case TRACE_TYPE_PROC:
            return "proc";
        case TRACE_TYPE_TRAP:
            return "trap";
        case TRACE_TYPE_MEM:
            return "mem";
        default:
            return "all";
    }
}

static int
type_color(int type){
    switch(type){
        case TRACE_TYPE_SYSCALL:
            return COLOR_CYAN;
        case TRACE_TYPE_PROC:
            return COLOR_GREEN;
        case TRACE_TYPE_MEM:
            return COLOR_YELLOW;
        case TRACE_TYPE_TRAP:
            return COLOR_RED;
        default:
            return COLOR_NORMAL;
    }
}

static int
detail_color(struct trace_event *event){
    if(event->type == TRACE_TYPE_TRAP) return COLOR_RED;
    if(event->type == TRACE_TYPE_MEM) return COLOR_YELLOW;
    if(event->type == TRACE_TYPE_PROC) return COLOR_GREEN;
    if(event->type == TRACE_TYPE_SYSCALL) {
        if(event->arg1 < 0) return COLOR_RED;
        return COLOR_CYAN;
    }
    return COLOR_NORMAL;
}

static int
latency_color(int latency){
    if(latency >= 5) return COLOR_RED;
    if(latency >= 2) return COLOR_YELLOW;
    return COLOR_GREEN;
}

static int
want_event(struct trace_event *event, int type_filter, int pid_filter, int self_pid){
    // Exclude the dashboard's own events to avoid feedback loops
    if(event->pid == self_pid) return 0;
    
    if(type_filter != 0 && event->type != type_filter) return 0;
    if(pid_filter != -1 && event->pid != pid_filter) return 0;
    return 1;
}

static void
update_window_counts(struct trace_event *event){
    if(event->type == TRACE_TYPE_SYSCALL) sys_count++;
    else if(event->type == TRACE_TYPE_PROC) proc_count++;
    else if(event->type == TRACE_TYPE_MEM) mem_count++;
    else if(event->type == TRACE_TYPE_TRAP) trap_count++;
}

static void
update_total_counts(struct trace_event *event){
    if(event->type == TRACE_TYPE_SYSCALL) t_sys_count++;
    else if(event->type == TRACE_TYPE_PROC) t_proc_count++;
    else if(event->type == TRACE_TYPE_MEM) t_mem_count++;
    else if(event->type == TRACE_TYPE_TRAP) t_trap_count++;
}


static void
itoa( int val, char *buf){
    char temp[16];
    int i = 0, j = 0, neg = 0;

    if(val < 0){
        neg = 1;
        val = -val;
    }
    if(val == 0){
        buf[0] = '0';
        buf[1] = 0;
        return;
    }

    while(val > 0 && i < sizeof(temp)-1){
        temp[i++] = '0' + val % 10;
        val = val / 10;
    }

    if(neg && i < sizeof(temp)-1){
        temp[i++] = '-';
    }
    
    while(i > 0){
        buf[j++] = temp[--i];
    }
    buf[j] = 0;
}

static void
itox(uint val, char *buf){
    char *hex = "0123456789abcdef";
    int i = 0, j = 0;
    char temp[16];

    if(val == 0){
        buf[0] = '0';
        buf[1] = 0;
        return;
    }

    while(val > 0 && i < sizeof(temp)-1){
        temp[i++] = hex[val % 16];
        val = val / 16;
    }

    while(i > 0){
        buf[j++] = temp[--i];
    }
    buf[j] = 0;
}

static void
drawnum(int row, int col, int val, int color){
    char buf[16];
    itoa(val, buf);
    vidputs(row, col, buf, color);
}

static void
drawhex(int row, int col, uint val, int color){
    char buf[16];
    itox(val, buf);
    vidputs(row, col, "0x", color);
    vidputs(row, col+2, buf, color);
}

static void
draweventrow(int row, struct trace_event *event){
    vidputs(row, 0, "                                                                                ", COLOR_NORMAL);
    drawnum(row, 0, event->seq, COLOR_NORMAL);
    drawnum(row, 5, event->ticks, COLOR_NORMAL);
    drawnum(row, 12, event->pid, type_color(event->type));
    vidputs(row, 17, event->comm, type_color(event->type));
    vidputs(row, 34, typename(event->type), type_color(event->type));
    vidputs(row, 43, event->event, type_color(event->type));
    

    if(event->type == TRACE_TYPE_SYSCALL){
        vidputs(row, 54, "num = ", COLOR_NORMAL);
        drawnum(row, 60, event->arg0, COLOR_CYAN);
        vidputs(row, 64, "ret = ", COLOR_NORMAL);
        drawnum(row, 70, event->arg1, detail_color(event));
    } else if(event->type == TRACE_TYPE_PROC){
        vidputs(row, 54, "child = ", COLOR_NORMAL);
        drawnum(row, 62, event->arg0, COLOR_GREEN);
    } else if(event->type == TRACE_TYPE_MEM){
        vidputs(row, 54, "page = ", COLOR_NORMAL);
        drawhex(row, 61, event->arg0, COLOR_YELLOW);
    } else if(event->type == TRACE_TYPE_TRAP){
        vidputs(row, 54, "cause = ", COLOR_RED);
        drawnum(row, 62, event->arg0, COLOR_RED);
        vidputs(row, 66, "err = ", COLOR_RED);
        drawnum(row, 72, event->arg1, COLOR_RED);
    }
}

static void
draw_graph(int row, int col, int *activity, int activity_pos){
    int i, index, count, color;
    char bar[2];

    bar[1] = 0;
    vidputs(row, col, "event rate last 50 ticks: . none | - low | = medium | # high", COLOR_TITLE);

    for(i = 0; i < GRAPH_WIDTH; i++){
        index = (activity_pos + 1 + i) % GRAPH_WIDTH;
        count = activity[index];

        if(count == 0){
            bar[0] = '.';
            color = COLOR_NORMAL;
        } else if (count < 3){
            bar[0] = '-';
            color = COLOR_GREEN;
        } else if(count < 7){
            bar[0] = '=';
            color = COLOR_YELLOW;
        } else {
            bar[0] = '#';
            color = COLOR_RED;
        }

        vidputs(row + 1, col + i, bar, color);
    }
}

static void
drawBoard(struct trace_event *recent, int recent_count, int recent_start,
          int filter_type, int filter_pid, int overwritten, int seen, int limit)
{
    int i, index;

    vidclear();

    vidputs(0, 0, "XV6 LIVE KERNEL TRACE DASHBOARD", COLOR_TITLE);
    
    vidputs(0, 36, "FILTER:", COLOR_NORMAL);
    vidputs(0, 44, typename(filter_type), type_color(filter_type));
    vidputs(0, 52, "pid = ", COLOR_NORMAL);
    if(filter_pid == -1) vidputs(0, 58, "all", COLOR_NORMAL);
    else drawnum(0, 58, filter_pid, COLOR_NORMAL);

    vidputs(0, 64, "STATUS:", COLOR_NORMAL);
    if(limit == 0) vidputs(0, 72, "ONESHOT", COLOR_YELLOW);
    else vidputs(0, 72, "LIVE", COLOR_GREEN);

    vidputs(1, 0, "captured = ", COLOR_NORMAL);
    drawnum(1, 11, seen, COLOR_CYAN);
    vidputs(1, 15, "/ ", COLOR_NORMAL);
    if(limit == 0) drawnum(1, 17, 128, COLOR_CYAN); // Kernel buffer is 128
    else drawnum(1, 17, limit, COLOR_CYAN);

    vidputs(1, 26, "showing: syscall = ", COLOR_NORMAL);
    drawnum(1, 45, sys_count, COLOR_CYAN);
    vidputs(1, 48, " proc = ", COLOR_NORMAL);
    drawnum(1, 56, proc_count, COLOR_GREEN);
    vidputs(1, 59, " mem = ", COLOR_NORMAL);
    drawnum(1, 66, mem_count, COLOR_YELLOW);
    vidputs(1, 69, " trap = ", COLOR_NORMAL);
    drawnum(1, 77, trap_count, COLOR_RED);

    vidputs(2, 0, "overwritten = ", COLOR_NORMAL);
    drawnum(2, 14, overwritten, overwritten > 0 ? COLOR_RED : COLOR_NORMAL);

    vidputs(2, 26, "total:   syscall = ", COLOR_NORMAL);
    drawnum(2, 45, t_sys_count, COLOR_CYAN);
    vidputs(2, 48, " proc = ", COLOR_NORMAL);
    drawnum(2, 56, t_proc_count, COLOR_GREEN);
    vidputs(2, 59, " mem = ", COLOR_NORMAL);
    drawnum(2, 66, t_mem_count, COLOR_YELLOW);
    vidputs(2, 69, " trap = ", COLOR_NORMAL);
    drawnum(2, 77, t_trap_count, COLOR_RED);

    vidputs(6, 0, "SEQ  TICKS  PID  PROC             SUBSYS   EVENT      DETAILS", COLOR_TITLE);
    vidputs(7, 0, "---------------------------------------------------------------------------", COLOR_NORMAL);
   
    // Limit loop by recent_count, display_rows, AND MAX_TRACE_ROWS
    for(i = 0; i < recent_count && i < display_rows && i < MAX_TRACE_ROWS; i++){
        index = (recent_start + i) % MAX_TRACE_ROWS;
        draweventrow(8 + i, &recent[index]);
    }
}



int
main(int argc, char **argv){
    struct trace_event event;
    int recent_count = 0;
    int recent_start = 0;
    int limit = 0; // Default: drain buffer and exit
    int seen = 0;
    int activity[GRAPH_WIDTH];
    int activity_pos = 0;
    int last_tick = -1;
    int i;
    int filter_type = 0;
    int filter_pid = -1;
    int overwritten = 0;
    int arg_idx = 1;
    int self_pid = getpid();
    int limit_set = 0;

    while(arg_idx < argc) {
        if(strcmp(argv[arg_idx], "-n") == 0 && arg_idx + 1 < argc) {
            display_rows = atoi(argv[arg_idx + 1]);
            if(display_rows > MAX_TRACE_ROWS) display_rows = MAX_TRACE_ROWS;
            arg_idx += 2;
        } else if(strcmp(argv[arg_idx], "syscall") == 0) {
            filter_type = TRACE_TYPE_SYSCALL;
            arg_idx++;
        } else if(strcmp(argv[arg_idx], "proc") == 0) {
            filter_type = TRACE_TYPE_PROC;
            arg_idx++;
        } else if(strcmp(argv[arg_idx], "mem") == 0) {
            filter_type = TRACE_TYPE_MEM;
            arg_idx++;
        } else if(strcmp(argv[arg_idx], "trap") == 0) {
            filter_type = TRACE_TYPE_TRAP;
            arg_idx++;
        } else {
            // Must be a number (limit or PID)
            int val = atoi(argv[arg_idx]);
            // check if it's actually a number (or "0")
            if(val > 0 || strcmp(argv[arg_idx], "0") == 0) {
                if(!limit_set) {
                    limit = val;
                    limit_set = 1;
                } else if(filter_pid == -1) {
                    filter_pid = val;
                }
            }
            arg_idx++;
        }
    }

    // Flush console cursor to the bottom (row 24)
    // This prevents the shell prompt from scrolling our dashboard up
    for(i = 0; i < 25; i++) printf(1, "\n");
    vidclear();
    
    // initialize activity graph
    for(i = 0; i < GRAPH_WIDTH; i++){
        activity[i] = 0;
    }

    while(limit == 0 || seen < limit){
        int n = traceread(&event, 1);

        if(n < 0){
            printf(1, "traceread failed\n");
            exit();
        }

        if(n == 0){
            // If in drain mode (limit=0) and no unread events, we're done
            if(limit == 0 && recent_count > 0) break;
            if(limit == 0 && seen == 0) {
                 // if buffer was empty from start, give it a tiny bit of time
                 if(uptime() - last_tick > 10) break; 
            }

            // Idle loop for live mode: update current time and graph
            int now = uptime();
            if(last_tick == -1) last_tick = now;
            
            if(now > last_tick){
                int diff = now - last_tick;
                if(diff > 50) diff = 50;
                for(i = 0; i < diff; i++){
                    activity_pos = (activity_pos + 1) % GRAPH_WIDTH;
                    activity[activity_pos] = 0;
                }
                last_tick = now;
                drawBoard(recent, recent_count, recent_start, filter_type, filter_pid, overwritten, seen, limit);
                draw_graph(4, 0, activity, activity_pos);
            }
            sleep(10);
            continue;
        }

        update_total_counts(&event);
        overwritten = event.overwritten;

        // Skip events from the dashboard itself or those that don't match the filter
        if(!want_event(&event, filter_type, filter_pid, self_pid))
            continue;
        
        update_window_counts(&event);

        // Update the activity graph based on event time
        if(last_tick == -1)
            last_tick = event.ticks;

        if(event.ticks > last_tick){
            int diff = event.ticks - last_tick;
            if(diff > 50) diff = 50; 
            for(i = 0; i < diff; i++) {
                activity_pos = (activity_pos + 1) % GRAPH_WIDTH;
                activity[activity_pos] = 0;
            }
            last_tick = event.ticks;
        }
        activity[activity_pos]++;


        if(recent_count < MAX_TRACE_ROWS){
            recent[recent_count] = event;
            recent_count++;
        } else {
            recent[recent_start] = event;
            recent_start = (recent_start + 1) % MAX_TRACE_ROWS;
        }
        
        drawBoard(recent, recent_count, recent_start, filter_type, filter_pid, overwritten, seen, limit);
        draw_graph(4, 0, activity, activity_pos);

        seen++;
    }
    
    exit();
}

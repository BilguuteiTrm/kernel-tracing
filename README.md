# XV6 LIVE KERNEL TRACING DASHBOARD

This project implements a real-time kernel tracing dashboard for xv6. It captures and displays system calls, process events, memory allocations, and hardware traps in a centralized, color-coded UI.

## HOW TO BUILD AND RUN
1.  **COMPILE:** Run `make qemu` in your terminal.
2.  **GENERATE ACTIVITY:** Run one of the test programs (see below).
3.  **INSPECT:** Run `trace` to see the results.

---

## USING THE TRACE DASHBOARD

The `trace` command uses a strict argument order: **The first number is always the CAPTURE LIMIT, and the second number is always the PID FILTER.**

### 1. ONE-SHOT MODE (DRAIN AND EXIT)
By default, `trace` drains the kernel's 128-event ring buffer and exits immediately. Use `0` as the first number to keep this behavior while applying other filters.
*   `$ trace`: Shows all 128 recent events from the buffer.
*   `$ trace 0 2`: Shows all recent events specifically for **PID 2**.
*   `$ trace syscall`: Shows only recent system calls.
*   `$ trace 0 syscall 2`: Shows only recent system calls for **PID 2**.

### 2. LIVE MODE (MONITORING)
Provide a positive number as the first argument to capture a specific amount of *new* activity.
*   `$ trace 50`: Captures and displays the next 50 events, then exits.
*   `$ trace 2`: Captures only 2 events and exits.
*   `$ trace 100 2`: Captures the next 100 events specifically for **PID 2**.
*   **NOTE:** If the system is idle, the program will appear to "freeze" while waiting for events.

### 3. DISPLAY CONTROL
Use the `-n` flag anywhere in the command to control how many rows are drawn on the screen.
*   `$ trace -n 10`: Show only 10 rows from the 128-event buffer.
*   `$ trace -n 5 20`: Show 5 rows at a time, but capture 20 total events before exiting.

---

## TEST PROGRAMS (EVENT GENERATORS)

*   **`$ syscalltest`**: Triggers `write`, `getpid`, `open`, and `sleep`.
*   **`$ proctest`**: Triggers `fork` and `wait` events.
*   **`$ memtest`**: Triggers heap expansions (`sbrk`) and memory allocation (`kalloc`).
*   **`$ traptest`**: Intentionally triggers a `pagefault` (kernel will kill the process).

---

## DASHBOARD COLUMN GUIDE
*   **SEQ / TICKS**: Event sequence number and kernel timestamp.
*   **PID / PROC**: The process ID and name.
*   **SUBSYS**: The kernel subsystem (syscall, proc, mem, or trap).
*   **EVENT**: The specific action (e.g., `fork`, `kalloc`, `read`).
*   **DETAILS**: Data like return values (`ret = 0`) or memory addresses (`page = 0x...`).

---

## TECHNICAL DETAILS
-   **RING BUFFER:** The kernel maintains the most recent 128 events.
-   **STABILITY:** Uses static memory and bounds checking to prevent crashes.
-   **PID FILTERING:** Handled in user-space. Use `trace 0 <PID>` to filter history.

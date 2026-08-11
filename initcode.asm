
initcodetmp.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <start>:

# exec(init, argv)
.code64
.global start
start:
  mov $init, %rdi
    1000:	48 c7 c7 22 10 00 00 	mov    $0x1022,%rdi
  mov $argv, %rsi
    1007:	48 c7 c6 30 10 00 00 	mov    $0x1030,%rsi
  mov $SYS_exec, %rax
    100e:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
  syscall
    1015:	0f 05                	syscall

0000000000001017 <exit>:

# for(;;) exit();
exit:
  mov $SYS_exit, %rax
    1017:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
  syscall
    101e:	0f 05                	syscall
  jmp exit
    1020:	eb f5                	jmp    1017 <exit>

0000000000001022 <init>:
    1022:	2f                   	(bad)
    1023:	69 6e 69 74 00 00 90 	imul   $0x90000074,0x69(%rsi),%ebp
    102a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000001030 <argv>:
    1030:	22 10                	and    (%rax),%dl
	...


_trace:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <typename>:

// Move large array to data segment to avoid stack overflow
static struct trace_event recent[MAX_TRACE_ROWS];

static char*
typename(int type){
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 08          	sub    $0x8,%rsp
    1008:	89 7d fc             	mov    %edi,-0x4(%rbp)
    switch(type){
    100b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
    100f:	74 44                	je     1055 <typename+0x55>
    1011:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
    1015:	7f 4a                	jg     1061 <typename+0x61>
    1017:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
    101b:	74 2c                	je     1049 <typename+0x49>
    101d:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
    1021:	7f 3e                	jg     1061 <typename+0x61>
    1023:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
    1027:	74 08                	je     1031 <typename+0x31>
    1029:	83 7d fc 02          	cmpl   $0x2,-0x4(%rbp)
    102d:	74 0e                	je     103d <typename+0x3d>
    102f:	eb 30                	jmp    1061 <typename+0x61>
        case TRACE_TYPE_SYSCALL:
            return "syscall";
    1031:	48 b8 e8 34 00 00 00 	movabs $0x34e8,%rax
    1038:	00 00 00 
    103b:	eb 2e                	jmp    106b <typename+0x6b>
        case TRACE_TYPE_PROC:
            return "proc";
    103d:	48 b8 f0 34 00 00 00 	movabs $0x34f0,%rax
    1044:	00 00 00 
    1047:	eb 22                	jmp    106b <typename+0x6b>
        case TRACE_TYPE_TRAP:
            return "trap";
    1049:	48 b8 f5 34 00 00 00 	movabs $0x34f5,%rax
    1050:	00 00 00 
    1053:	eb 16                	jmp    106b <typename+0x6b>
        case TRACE_TYPE_MEM:
            return "mem";
    1055:	48 b8 fa 34 00 00 00 	movabs $0x34fa,%rax
    105c:	00 00 00 
    105f:	eb 0a                	jmp    106b <typename+0x6b>
        default:
            return "all";
    1061:	48 b8 fe 34 00 00 00 	movabs $0x34fe,%rax
    1068:	00 00 00 
    }
}
    106b:	c9                   	leave
    106c:	c3                   	ret

000000000000106d <type_color>:

static int
type_color(int type){
    106d:	55                   	push   %rbp
    106e:	48 89 e5             	mov    %rsp,%rbp
    1071:	48 83 ec 08          	sub    $0x8,%rsp
    1075:	89 7d fc             	mov    %edi,-0x4(%rbp)
    switch(type){
    1078:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
    107c:	74 2e                	je     10ac <type_color+0x3f>
    107e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
    1082:	7f 36                	jg     10ba <type_color+0x4d>
    1084:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
    1088:	74 29                	je     10b3 <type_color+0x46>
    108a:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
    108e:	7f 2a                	jg     10ba <type_color+0x4d>
    1090:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
    1094:	74 08                	je     109e <type_color+0x31>
    1096:	83 7d fc 02          	cmpl   $0x2,-0x4(%rbp)
    109a:	74 09                	je     10a5 <type_color+0x38>
    109c:	eb 1c                	jmp    10ba <type_color+0x4d>
        case TRACE_TYPE_SYSCALL:
            return COLOR_CYAN;
    109e:	b8 0b 00 00 00       	mov    $0xb,%eax
    10a3:	eb 1a                	jmp    10bf <type_color+0x52>
        case TRACE_TYPE_PROC:
            return COLOR_GREEN;
    10a5:	b8 0a 00 00 00       	mov    $0xa,%eax
    10aa:	eb 13                	jmp    10bf <type_color+0x52>
        case TRACE_TYPE_MEM:
            return COLOR_YELLOW;
    10ac:	b8 0e 00 00 00       	mov    $0xe,%eax
    10b1:	eb 0c                	jmp    10bf <type_color+0x52>
        case TRACE_TYPE_TRAP:
            return COLOR_RED;
    10b3:	b8 0c 00 00 00       	mov    $0xc,%eax
    10b8:	eb 05                	jmp    10bf <type_color+0x52>
        default:
            return COLOR_NORMAL;
    10ba:	b8 07 00 00 00       	mov    $0x7,%eax
    }
}
    10bf:	c9                   	leave
    10c0:	c3                   	ret

00000000000010c1 <detail_color>:

static int
detail_color(struct trace_event *event){
    10c1:	55                   	push   %rbp
    10c2:	48 89 e5             	mov    %rsp,%rbp
    10c5:	48 83 ec 08          	sub    $0x8,%rsp
    10c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    if(event->type == TRACE_TYPE_TRAP) return COLOR_RED;
    10cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10d1:	8b 40 08             	mov    0x8(%rax),%eax
    10d4:	83 f8 03             	cmp    $0x3,%eax
    10d7:	75 07                	jne    10e0 <detail_color+0x1f>
    10d9:	b8 0c 00 00 00       	mov    $0xc,%eax
    10de:	eb 50                	jmp    1130 <detail_color+0x6f>
    if(event->type == TRACE_TYPE_MEM) return COLOR_YELLOW;
    10e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10e4:	8b 40 08             	mov    0x8(%rax),%eax
    10e7:	83 f8 04             	cmp    $0x4,%eax
    10ea:	75 07                	jne    10f3 <detail_color+0x32>
    10ec:	b8 0e 00 00 00       	mov    $0xe,%eax
    10f1:	eb 3d                	jmp    1130 <detail_color+0x6f>
    if(event->type == TRACE_TYPE_PROC) return COLOR_GREEN;
    10f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10f7:	8b 40 08             	mov    0x8(%rax),%eax
    10fa:	83 f8 02             	cmp    $0x2,%eax
    10fd:	75 07                	jne    1106 <detail_color+0x45>
    10ff:	b8 0a 00 00 00       	mov    $0xa,%eax
    1104:	eb 2a                	jmp    1130 <detail_color+0x6f>
    if(event->type == TRACE_TYPE_SYSCALL) {
    1106:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    110a:	8b 40 08             	mov    0x8(%rax),%eax
    110d:	83 f8 01             	cmp    $0x1,%eax
    1110:	75 19                	jne    112b <detail_color+0x6a>
        if(event->arg1 < 0) return COLOR_RED;
    1112:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1116:	8b 40 14             	mov    0x14(%rax),%eax
    1119:	85 c0                	test   %eax,%eax
    111b:	79 07                	jns    1124 <detail_color+0x63>
    111d:	b8 0c 00 00 00       	mov    $0xc,%eax
    1122:	eb 0c                	jmp    1130 <detail_color+0x6f>
        return COLOR_CYAN;
    1124:	b8 0b 00 00 00       	mov    $0xb,%eax
    1129:	eb 05                	jmp    1130 <detail_color+0x6f>
    }
    return COLOR_NORMAL;
    112b:	b8 07 00 00 00       	mov    $0x7,%eax
}
    1130:	c9                   	leave
    1131:	c3                   	ret

0000000000001132 <latency_color>:

static int
latency_color(int latency){
    1132:	55                   	push   %rbp
    1133:	48 89 e5             	mov    %rsp,%rbp
    1136:	48 83 ec 08          	sub    $0x8,%rsp
    113a:	89 7d fc             	mov    %edi,-0x4(%rbp)
    if(latency >= 5) return COLOR_RED;
    113d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
    1141:	7e 07                	jle    114a <latency_color+0x18>
    1143:	b8 0c 00 00 00       	mov    $0xc,%eax
    1148:	eb 12                	jmp    115c <latency_color+0x2a>
    if(latency >= 2) return COLOR_YELLOW;
    114a:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
    114e:	7e 07                	jle    1157 <latency_color+0x25>
    1150:	b8 0e 00 00 00       	mov    $0xe,%eax
    1155:	eb 05                	jmp    115c <latency_color+0x2a>
    return COLOR_GREEN;
    1157:	b8 0a 00 00 00       	mov    $0xa,%eax
}
    115c:	c9                   	leave
    115d:	c3                   	ret

000000000000115e <want_event>:

static int
want_event(struct trace_event *event, int type_filter, int pid_filter, int self_pid){
    115e:	55                   	push   %rbp
    115f:	48 89 e5             	mov    %rsp,%rbp
    1162:	48 83 ec 18          	sub    $0x18,%rsp
    1166:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    116a:	89 75 f4             	mov    %esi,-0xc(%rbp)
    116d:	89 55 f0             	mov    %edx,-0x10(%rbp)
    1170:	89 4d ec             	mov    %ecx,-0x14(%rbp)
    // Exclude the dashboard's own events to avoid feedback loops
    if(event->pid == self_pid) return 0;
    1173:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1177:	8b 40 0c             	mov    0xc(%rax),%eax
    117a:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    117d:	75 07                	jne    1186 <want_event+0x28>
    117f:	b8 00 00 00 00       	mov    $0x0,%eax
    1184:	eb 37                	jmp    11bd <want_event+0x5f>
    
    if(type_filter != 0 && event->type != type_filter) return 0;
    1186:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    118a:	74 13                	je     119f <want_event+0x41>
    118c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1190:	8b 40 08             	mov    0x8(%rax),%eax
    1193:	39 45 f4             	cmp    %eax,-0xc(%rbp)
    1196:	74 07                	je     119f <want_event+0x41>
    1198:	b8 00 00 00 00       	mov    $0x0,%eax
    119d:	eb 1e                	jmp    11bd <want_event+0x5f>
    if(pid_filter != -1 && event->pid != pid_filter) return 0;
    119f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%rbp)
    11a3:	74 13                	je     11b8 <want_event+0x5a>
    11a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11a9:	8b 40 0c             	mov    0xc(%rax),%eax
    11ac:	39 45 f0             	cmp    %eax,-0x10(%rbp)
    11af:	74 07                	je     11b8 <want_event+0x5a>
    11b1:	b8 00 00 00 00       	mov    $0x0,%eax
    11b6:	eb 05                	jmp    11bd <want_event+0x5f>
    return 1;
    11b8:	b8 01 00 00 00       	mov    $0x1,%eax
}
    11bd:	c9                   	leave
    11be:	c3                   	ret

00000000000011bf <update_window_counts>:

static void
update_window_counts(struct trace_event *event){
    11bf:	55                   	push   %rbp
    11c0:	48 89 e5             	mov    %rsp,%rbp
    11c3:	48 83 ec 08          	sub    $0x8,%rsp
    11c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    if(event->type == TRACE_TYPE_SYSCALL) sys_count++;
    11cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11cf:	8b 40 08             	mov    0x8(%rax),%eax
    11d2:	83 f8 01             	cmp    $0x1,%eax
    11d5:	75 1d                	jne    11f4 <update_window_counts+0x35>
    11d7:	48 b8 60 37 00 00 00 	movabs $0x3760,%rax
    11de:	00 00 00 
    11e1:	8b 00                	mov    (%rax),%eax
    11e3:	8d 50 01             	lea    0x1(%rax),%edx
    11e6:	48 b8 60 37 00 00 00 	movabs $0x3760,%rax
    11ed:	00 00 00 
    11f0:	89 10                	mov    %edx,(%rax)
    else if(event->type == TRACE_TYPE_PROC) proc_count++;
    else if(event->type == TRACE_TYPE_MEM) mem_count++;
    else if(event->type == TRACE_TYPE_TRAP) trap_count++;
}
    11f2:	eb 79                	jmp    126d <update_window_counts+0xae>
    else if(event->type == TRACE_TYPE_PROC) proc_count++;
    11f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11f8:	8b 40 08             	mov    0x8(%rax),%eax
    11fb:	83 f8 02             	cmp    $0x2,%eax
    11fe:	75 1d                	jne    121d <update_window_counts+0x5e>
    1200:	48 b8 64 37 00 00 00 	movabs $0x3764,%rax
    1207:	00 00 00 
    120a:	8b 00                	mov    (%rax),%eax
    120c:	8d 50 01             	lea    0x1(%rax),%edx
    120f:	48 b8 64 37 00 00 00 	movabs $0x3764,%rax
    1216:	00 00 00 
    1219:	89 10                	mov    %edx,(%rax)
}
    121b:	eb 50                	jmp    126d <update_window_counts+0xae>
    else if(event->type == TRACE_TYPE_MEM) mem_count++;
    121d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1221:	8b 40 08             	mov    0x8(%rax),%eax
    1224:	83 f8 04             	cmp    $0x4,%eax
    1227:	75 1d                	jne    1246 <update_window_counts+0x87>
    1229:	48 b8 68 37 00 00 00 	movabs $0x3768,%rax
    1230:	00 00 00 
    1233:	8b 00                	mov    (%rax),%eax
    1235:	8d 50 01             	lea    0x1(%rax),%edx
    1238:	48 b8 68 37 00 00 00 	movabs $0x3768,%rax
    123f:	00 00 00 
    1242:	89 10                	mov    %edx,(%rax)
}
    1244:	eb 27                	jmp    126d <update_window_counts+0xae>
    else if(event->type == TRACE_TYPE_TRAP) trap_count++;
    1246:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    124a:	8b 40 08             	mov    0x8(%rax),%eax
    124d:	83 f8 03             	cmp    $0x3,%eax
    1250:	75 1b                	jne    126d <update_window_counts+0xae>
    1252:	48 b8 6c 37 00 00 00 	movabs $0x376c,%rax
    1259:	00 00 00 
    125c:	8b 00                	mov    (%rax),%eax
    125e:	8d 50 01             	lea    0x1(%rax),%edx
    1261:	48 b8 6c 37 00 00 00 	movabs $0x376c,%rax
    1268:	00 00 00 
    126b:	89 10                	mov    %edx,(%rax)
}
    126d:	90                   	nop
    126e:	c9                   	leave
    126f:	c3                   	ret

0000000000001270 <update_total_counts>:

static void
update_total_counts(struct trace_event *event){
    1270:	55                   	push   %rbp
    1271:	48 89 e5             	mov    %rsp,%rbp
    1274:	48 83 ec 08          	sub    $0x8,%rsp
    1278:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    if(event->type == TRACE_TYPE_SYSCALL) t_sys_count++;
    127c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1280:	8b 40 08             	mov    0x8(%rax),%eax
    1283:	83 f8 01             	cmp    $0x1,%eax
    1286:	75 1d                	jne    12a5 <update_total_counts+0x35>
    1288:	48 b8 70 37 00 00 00 	movabs $0x3770,%rax
    128f:	00 00 00 
    1292:	8b 00                	mov    (%rax),%eax
    1294:	8d 50 01             	lea    0x1(%rax),%edx
    1297:	48 b8 70 37 00 00 00 	movabs $0x3770,%rax
    129e:	00 00 00 
    12a1:	89 10                	mov    %edx,(%rax)
    else if(event->type == TRACE_TYPE_PROC) t_proc_count++;
    else if(event->type == TRACE_TYPE_MEM) t_mem_count++;
    else if(event->type == TRACE_TYPE_TRAP) t_trap_count++;
}
    12a3:	eb 79                	jmp    131e <update_total_counts+0xae>
    else if(event->type == TRACE_TYPE_PROC) t_proc_count++;
    12a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12a9:	8b 40 08             	mov    0x8(%rax),%eax
    12ac:	83 f8 02             	cmp    $0x2,%eax
    12af:	75 1d                	jne    12ce <update_total_counts+0x5e>
    12b1:	48 b8 74 37 00 00 00 	movabs $0x3774,%rax
    12b8:	00 00 00 
    12bb:	8b 00                	mov    (%rax),%eax
    12bd:	8d 50 01             	lea    0x1(%rax),%edx
    12c0:	48 b8 74 37 00 00 00 	movabs $0x3774,%rax
    12c7:	00 00 00 
    12ca:	89 10                	mov    %edx,(%rax)
}
    12cc:	eb 50                	jmp    131e <update_total_counts+0xae>
    else if(event->type == TRACE_TYPE_MEM) t_mem_count++;
    12ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12d2:	8b 40 08             	mov    0x8(%rax),%eax
    12d5:	83 f8 04             	cmp    $0x4,%eax
    12d8:	75 1d                	jne    12f7 <update_total_counts+0x87>
    12da:	48 b8 78 37 00 00 00 	movabs $0x3778,%rax
    12e1:	00 00 00 
    12e4:	8b 00                	mov    (%rax),%eax
    12e6:	8d 50 01             	lea    0x1(%rax),%edx
    12e9:	48 b8 78 37 00 00 00 	movabs $0x3778,%rax
    12f0:	00 00 00 
    12f3:	89 10                	mov    %edx,(%rax)
}
    12f5:	eb 27                	jmp    131e <update_total_counts+0xae>
    else if(event->type == TRACE_TYPE_TRAP) t_trap_count++;
    12f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12fb:	8b 40 08             	mov    0x8(%rax),%eax
    12fe:	83 f8 03             	cmp    $0x3,%eax
    1301:	75 1b                	jne    131e <update_total_counts+0xae>
    1303:	48 b8 7c 37 00 00 00 	movabs $0x377c,%rax
    130a:	00 00 00 
    130d:	8b 00                	mov    (%rax),%eax
    130f:	8d 50 01             	lea    0x1(%rax),%edx
    1312:	48 b8 7c 37 00 00 00 	movabs $0x377c,%rax
    1319:	00 00 00 
    131c:	89 10                	mov    %edx,(%rax)
}
    131e:	90                   	nop
    131f:	c9                   	leave
    1320:	c3                   	ret

0000000000001321 <itoa>:


static void
itoa( int val, char *buf){
    1321:	55                   	push   %rbp
    1322:	48 89 e5             	mov    %rsp,%rbp
    1325:	48 83 ec 30          	sub    $0x30,%rsp
    1329:	89 7d dc             	mov    %edi,-0x24(%rbp)
    132c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char temp[16];
    int i = 0, j = 0, neg = 0;
    1330:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1337:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    133e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)

    if(val < 0){
    1345:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    1349:	79 0a                	jns    1355 <itoa+0x34>
        neg = 1;
    134b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
        val = -val;
    1352:	f7 5d dc             	negl   -0x24(%rbp)
    }
    if(val == 0){
    1355:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    1359:	75 75                	jne    13d0 <itoa+0xaf>
        buf[0] = '0';
    135b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    135f:	c6 00 30             	movb   $0x30,(%rax)
        buf[1] = 0;
    1362:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1366:	48 83 c0 01          	add    $0x1,%rax
    136a:	c6 00 00             	movb   $0x0,(%rax)
    136d:	e9 c5 00 00 00       	jmp    1437 <itoa+0x116>
        return;
    }

    while(val > 0 && i < sizeof(temp)-1){
        temp[i++] = '0' + val % 10;
    1372:	8b 55 dc             	mov    -0x24(%rbp),%edx
    1375:	48 63 c2             	movslq %edx,%rax
    1378:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
    137f:	48 c1 e8 20          	shr    $0x20,%rax
    1383:	89 c1                	mov    %eax,%ecx
    1385:	c1 f9 02             	sar    $0x2,%ecx
    1388:	89 d0                	mov    %edx,%eax
    138a:	c1 f8 1f             	sar    $0x1f,%eax
    138d:	29 c1                	sub    %eax,%ecx
    138f:	89 c8                	mov    %ecx,%eax
    1391:	c1 e0 02             	shl    $0x2,%eax
    1394:	01 c8                	add    %ecx,%eax
    1396:	01 c0                	add    %eax,%eax
    1398:	89 d1                	mov    %edx,%ecx
    139a:	29 c1                	sub    %eax,%ecx
    139c:	89 c8                	mov    %ecx,%eax
    139e:	8d 48 30             	lea    0x30(%rax),%ecx
    13a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13a4:	8d 50 01             	lea    0x1(%rax),%edx
    13a7:	89 55 fc             	mov    %edx,-0x4(%rbp)
    13aa:	89 ca                	mov    %ecx,%edx
    13ac:	48 98                	cltq
    13ae:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
        val = val / 10;
    13b2:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13b5:	48 63 d0             	movslq %eax,%rdx
    13b8:	48 69 d2 67 66 66 66 	imul   $0x66666667,%rdx,%rdx
    13bf:	48 c1 ea 20          	shr    $0x20,%rdx
    13c3:	89 d1                	mov    %edx,%ecx
    13c5:	c1 f9 02             	sar    $0x2,%ecx
    13c8:	99                   	cltd
    13c9:	89 c8                	mov    %ecx,%eax
    13cb:	29 d0                	sub    %edx,%eax
    13cd:	89 45 dc             	mov    %eax,-0x24(%rbp)
    while(val > 0 && i < sizeof(temp)-1){
    13d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    13d4:	7e 08                	jle    13de <itoa+0xbd>
    13d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13d9:	83 f8 0e             	cmp    $0xe,%eax
    13dc:	76 94                	jbe    1372 <itoa+0x51>
    }

    if(neg && i < sizeof(temp)-1){
    13de:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    13e2:	74 3d                	je     1421 <itoa+0x100>
    13e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13e7:	83 f8 0e             	cmp    $0xe,%eax
    13ea:	77 35                	ja     1421 <itoa+0x100>
        temp[i++] = '-';
    13ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13ef:	8d 50 01             	lea    0x1(%rax),%edx
    13f2:	89 55 fc             	mov    %edx,-0x4(%rbp)
    13f5:	48 98                	cltq
    13f7:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)
    }
    
    while(i > 0){
    13fc:	eb 23                	jmp    1421 <itoa+0x100>
        buf[j++] = temp[--i];
    13fe:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
    1402:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1405:	8d 50 01             	lea    0x1(%rax),%edx
    1408:	89 55 f8             	mov    %edx,-0x8(%rbp)
    140b:	48 63 d0             	movslq %eax,%rdx
    140e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1412:	48 01 c2             	add    %rax,%rdx
    1415:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1418:	48 98                	cltq
    141a:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    141f:	88 02                	mov    %al,(%rdx)
    while(i > 0){
    1421:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1425:	7f d7                	jg     13fe <itoa+0xdd>
    }
    buf[j] = 0;
    1427:	8b 45 f8             	mov    -0x8(%rbp),%eax
    142a:	48 63 d0             	movslq %eax,%rdx
    142d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1431:	48 01 d0             	add    %rdx,%rax
    1434:	c6 00 00             	movb   $0x0,(%rax)
}
    1437:	c9                   	leave
    1438:	c3                   	ret

0000000000001439 <itox>:

static void
itox(uint val, char *buf){
    1439:	55                   	push   %rbp
    143a:	48 89 e5             	mov    %rsp,%rbp
    143d:	48 83 ec 30          	sub    $0x30,%rsp
    1441:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1444:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char *hex = "0123456789abcdef";
    1448:	48 b8 02 35 00 00 00 	movabs $0x3502,%rax
    144f:	00 00 00 
    1452:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    int i = 0, j = 0;
    1456:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    145d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    char temp[16];

    if(val == 0){
    1464:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    1468:	75 3b                	jne    14a5 <itox+0x6c>
        buf[0] = '0';
    146a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    146e:	c6 00 30             	movb   $0x30,(%rax)
        buf[1] = 0;
    1471:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1475:	48 83 c0 01          	add    $0x1,%rax
    1479:	c6 00 00             	movb   $0x0,(%rax)
    147c:	eb 70                	jmp    14ee <itox+0xb5>
        return;
    }

    while(val > 0 && i < sizeof(temp)-1){
        temp[i++] = hex[val % 16];
    147e:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1481:	83 e0 0f             	and    $0xf,%eax
    1484:	48 89 c2             	mov    %rax,%rdx
    1487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    148b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
    148f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1492:	8d 50 01             	lea    0x1(%rax),%edx
    1495:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1498:	0f b6 11             	movzbl (%rcx),%edx
    149b:	48 98                	cltq
    149d:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
        val = val / 16;
    14a1:	c1 6d dc 04          	shrl   $0x4,-0x24(%rbp)
    while(val > 0 && i < sizeof(temp)-1){
    14a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    14a9:	74 2d                	je     14d8 <itox+0x9f>
    14ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14ae:	83 f8 0e             	cmp    $0xe,%eax
    14b1:	76 cb                	jbe    147e <itox+0x45>
    }

    while(i > 0){
    14b3:	eb 23                	jmp    14d8 <itox+0x9f>
        buf[j++] = temp[--i];
    14b5:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
    14b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
    14bc:	8d 50 01             	lea    0x1(%rax),%edx
    14bf:	89 55 f8             	mov    %edx,-0x8(%rbp)
    14c2:	48 63 d0             	movslq %eax,%rdx
    14c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    14c9:	48 01 c2             	add    %rax,%rdx
    14cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14cf:	48 98                	cltq
    14d1:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    14d6:	88 02                	mov    %al,(%rdx)
    while(i > 0){
    14d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    14dc:	7f d7                	jg     14b5 <itox+0x7c>
    }
    buf[j] = 0;
    14de:	8b 45 f8             	mov    -0x8(%rbp),%eax
    14e1:	48 63 d0             	movslq %eax,%rdx
    14e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    14e8:	48 01 d0             	add    %rdx,%rax
    14eb:	c6 00 00             	movb   $0x0,(%rax)
}
    14ee:	c9                   	leave
    14ef:	c3                   	ret

00000000000014f0 <drawnum>:

static void
drawnum(int row, int col, int val, int color){
    14f0:	55                   	push   %rbp
    14f1:	48 89 e5             	mov    %rsp,%rbp
    14f4:	48 83 ec 20          	sub    $0x20,%rsp
    14f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
    14fb:	89 75 e8             	mov    %esi,-0x18(%rbp)
    14fe:	89 55 e4             	mov    %edx,-0x1c(%rbp)
    1501:	89 4d e0             	mov    %ecx,-0x20(%rbp)
    char buf[16];
    itoa(val, buf);
    1504:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
    1508:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    150b:	48 89 d6             	mov    %rdx,%rsi
    150e:	89 c7                	mov    %eax,%edi
    1510:	48 b8 21 13 00 00 00 	movabs $0x1321,%rax
    1517:	00 00 00 
    151a:	ff d0                	call   *%rax
    vidputs(row, col, buf, color);
    151c:	8b 4d e0             	mov    -0x20(%rbp),%ecx
    151f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
    1523:	8b 75 e8             	mov    -0x18(%rbp),%esi
    1526:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1529:	89 c7                	mov    %eax,%edi
    152b:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1532:	00 00 00 
    1535:	ff d0                	call   *%rax
}
    1537:	90                   	nop
    1538:	c9                   	leave
    1539:	c3                   	ret

000000000000153a <drawhex>:

static void
drawhex(int row, int col, uint val, int color){
    153a:	55                   	push   %rbp
    153b:	48 89 e5             	mov    %rsp,%rbp
    153e:	48 83 ec 20          	sub    $0x20,%rsp
    1542:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1545:	89 75 e8             	mov    %esi,-0x18(%rbp)
    1548:	89 55 e4             	mov    %edx,-0x1c(%rbp)
    154b:	89 4d e0             	mov    %ecx,-0x20(%rbp)
    char buf[16];
    itox(val, buf);
    154e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
    1552:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    1555:	48 89 d6             	mov    %rdx,%rsi
    1558:	89 c7                	mov    %eax,%edi
    155a:	48 b8 39 14 00 00 00 	movabs $0x1439,%rax
    1561:	00 00 00 
    1564:	ff d0                	call   *%rax
    vidputs(row, col, "0x", color);
    1566:	8b 55 e0             	mov    -0x20(%rbp),%edx
    1569:	48 bf 13 35 00 00 00 	movabs $0x3513,%rdi
    1570:	00 00 00 
    1573:	8b 75 e8             	mov    -0x18(%rbp),%esi
    1576:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1579:	89 d1                	mov    %edx,%ecx
    157b:	48 89 fa             	mov    %rdi,%rdx
    157e:	89 c7                	mov    %eax,%edi
    1580:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1587:	00 00 00 
    158a:	ff d0                	call   *%rax
    vidputs(row, col+2, buf, color);
    158c:	8b 45 e8             	mov    -0x18(%rbp),%eax
    158f:	8d 70 02             	lea    0x2(%rax),%esi
    1592:	8b 4d e0             	mov    -0x20(%rbp),%ecx
    1595:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
    1599:	8b 45 ec             	mov    -0x14(%rbp),%eax
    159c:	89 c7                	mov    %eax,%edi
    159e:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    15a5:	00 00 00 
    15a8:	ff d0                	call   *%rax
}
    15aa:	90                   	nop
    15ab:	c9                   	leave
    15ac:	c3                   	ret

00000000000015ad <draweventrow>:

static void
draweventrow(int row, struct trace_event *event){
    15ad:	55                   	push   %rbp
    15ae:	48 89 e5             	mov    %rsp,%rbp
    15b1:	53                   	push   %rbx
    15b2:	48 83 ec 18          	sub    $0x18,%rsp
    15b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    vidputs(row, 0, "                                                                                ", COLOR_NORMAL);
    15bd:	48 ba 18 35 00 00 00 	movabs $0x3518,%rdx
    15c4:	00 00 00 
    15c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15ca:	b9 07 00 00 00       	mov    $0x7,%ecx
    15cf:	be 00 00 00 00       	mov    $0x0,%esi
    15d4:	89 c7                	mov    %eax,%edi
    15d6:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    15dd:	00 00 00 
    15e0:	ff d0                	call   *%rax
    drawnum(row, 0, event->seq, COLOR_NORMAL);
    15e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    15e6:	8b 00                	mov    (%rax),%eax
    15e8:	89 c2                	mov    %eax,%edx
    15ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15ed:	b9 07 00 00 00       	mov    $0x7,%ecx
    15f2:	be 00 00 00 00       	mov    $0x0,%esi
    15f7:	89 c7                	mov    %eax,%edi
    15f9:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1600:	00 00 00 
    1603:	ff d0                	call   *%rax
    drawnum(row, 5, event->ticks, COLOR_NORMAL);
    1605:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1609:	8b 40 04             	mov    0x4(%rax),%eax
    160c:	89 c2                	mov    %eax,%edx
    160e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1611:	b9 07 00 00 00       	mov    $0x7,%ecx
    1616:	be 05 00 00 00       	mov    $0x5,%esi
    161b:	89 c7                	mov    %eax,%edi
    161d:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1624:	00 00 00 
    1627:	ff d0                	call   *%rax
    drawnum(row, 12, event->pid, type_color(event->type));
    1629:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    162d:	8b 40 08             	mov    0x8(%rax),%eax
    1630:	89 c7                	mov    %eax,%edi
    1632:	48 b8 6d 10 00 00 00 	movabs $0x106d,%rax
    1639:	00 00 00 
    163c:	ff d0                	call   *%rax
    163e:	89 c1                	mov    %eax,%ecx
    1640:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1644:	8b 50 0c             	mov    0xc(%rax),%edx
    1647:	8b 45 ec             	mov    -0x14(%rbp),%eax
    164a:	be 0c 00 00 00       	mov    $0xc,%esi
    164f:	89 c7                	mov    %eax,%edi
    1651:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1658:	00 00 00 
    165b:	ff d0                	call   *%rax
    vidputs(row, 17, event->comm, type_color(event->type));
    165d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1661:	8b 40 08             	mov    0x8(%rax),%eax
    1664:	89 c7                	mov    %eax,%edi
    1666:	48 b8 6d 10 00 00 00 	movabs $0x106d,%rax
    166d:	00 00 00 
    1670:	ff d0                	call   *%rax
    1672:	89 c1                	mov    %eax,%ecx
    1674:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1678:	48 8d 50 1c          	lea    0x1c(%rax),%rdx
    167c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    167f:	be 11 00 00 00       	mov    $0x11,%esi
    1684:	89 c7                	mov    %eax,%edi
    1686:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    168d:	00 00 00 
    1690:	ff d0                	call   *%rax
    vidputs(row, 34, typename(event->type), type_color(event->type));
    1692:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1696:	8b 40 08             	mov    0x8(%rax),%eax
    1699:	89 c7                	mov    %eax,%edi
    169b:	48 b8 6d 10 00 00 00 	movabs $0x106d,%rax
    16a2:	00 00 00 
    16a5:	ff d0                	call   *%rax
    16a7:	89 c3                	mov    %eax,%ebx
    16a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    16ad:	8b 40 08             	mov    0x8(%rax),%eax
    16b0:	89 c7                	mov    %eax,%edi
    16b2:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    16b9:	00 00 00 
    16bc:	ff d0                	call   *%rax
    16be:	48 89 c2             	mov    %rax,%rdx
    16c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16c4:	89 d9                	mov    %ebx,%ecx
    16c6:	be 22 00 00 00       	mov    $0x22,%esi
    16cb:	89 c7                	mov    %eax,%edi
    16cd:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    16d4:	00 00 00 
    16d7:	ff d0                	call   *%rax
    vidputs(row, 43, event->event, type_color(event->type));
    16d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    16dd:	8b 40 08             	mov    0x8(%rax),%eax
    16e0:	89 c7                	mov    %eax,%edi
    16e2:	48 b8 6d 10 00 00 00 	movabs $0x106d,%rax
    16e9:	00 00 00 
    16ec:	ff d0                	call   *%rax
    16ee:	89 c1                	mov    %eax,%ecx
    16f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    16f4:	48 8d 50 2c          	lea    0x2c(%rax),%rdx
    16f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16fb:	be 2b 00 00 00       	mov    $0x2b,%esi
    1700:	89 c7                	mov    %eax,%edi
    1702:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1709:	00 00 00 
    170c:	ff d0                	call   *%rax
    

    if(event->type == TRACE_TYPE_SYSCALL){
    170e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1712:	8b 40 08             	mov    0x8(%rax),%eax
    1715:	83 f8 01             	cmp    $0x1,%eax
    1718:	0f 85 a3 00 00 00    	jne    17c1 <draweventrow+0x214>
        vidputs(row, 54, "num = ", COLOR_NORMAL);
    171e:	48 ba 69 35 00 00 00 	movabs $0x3569,%rdx
    1725:	00 00 00 
    1728:	8b 45 ec             	mov    -0x14(%rbp),%eax
    172b:	b9 07 00 00 00       	mov    $0x7,%ecx
    1730:	be 36 00 00 00       	mov    $0x36,%esi
    1735:	89 c7                	mov    %eax,%edi
    1737:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    173e:	00 00 00 
    1741:	ff d0                	call   *%rax
        drawnum(row, 60, event->arg0, COLOR_CYAN);
    1743:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1747:	8b 50 10             	mov    0x10(%rax),%edx
    174a:	8b 45 ec             	mov    -0x14(%rbp),%eax
    174d:	b9 0b 00 00 00       	mov    $0xb,%ecx
    1752:	be 3c 00 00 00       	mov    $0x3c,%esi
    1757:	89 c7                	mov    %eax,%edi
    1759:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1760:	00 00 00 
    1763:	ff d0                	call   *%rax
        vidputs(row, 64, "ret = ", COLOR_NORMAL);
    1765:	48 ba 70 35 00 00 00 	movabs $0x3570,%rdx
    176c:	00 00 00 
    176f:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1772:	b9 07 00 00 00       	mov    $0x7,%ecx
    1777:	be 40 00 00 00       	mov    $0x40,%esi
    177c:	89 c7                	mov    %eax,%edi
    177e:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1785:	00 00 00 
    1788:	ff d0                	call   *%rax
        drawnum(row, 70, event->arg1, detail_color(event));
    178a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    178e:	48 89 c7             	mov    %rax,%rdi
    1791:	48 b8 c1 10 00 00 00 	movabs $0x10c1,%rax
    1798:	00 00 00 
    179b:	ff d0                	call   *%rax
    179d:	89 c1                	mov    %eax,%ecx
    179f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    17a3:	8b 50 14             	mov    0x14(%rax),%edx
    17a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
    17a9:	be 46 00 00 00       	mov    $0x46,%esi
    17ae:	89 c7                	mov    %eax,%edi
    17b0:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    17b7:	00 00 00 
    17ba:	ff d0                	call   *%rax
        vidputs(row, 54, "cause = ", COLOR_RED);
        drawnum(row, 62, event->arg0, COLOR_RED);
        vidputs(row, 66, "err = ", COLOR_RED);
        drawnum(row, 72, event->arg1, COLOR_RED);
    }
}
    17bc:	e9 50 01 00 00       	jmp    1911 <draweventrow+0x364>
    } else if(event->type == TRACE_TYPE_PROC){
    17c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    17c5:	8b 40 08             	mov    0x8(%rax),%eax
    17c8:	83 f8 02             	cmp    $0x2,%eax
    17cb:	75 4c                	jne    1819 <draweventrow+0x26c>
        vidputs(row, 54, "child = ", COLOR_NORMAL);
    17cd:	48 ba 77 35 00 00 00 	movabs $0x3577,%rdx
    17d4:	00 00 00 
    17d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    17da:	b9 07 00 00 00       	mov    $0x7,%ecx
    17df:	be 36 00 00 00       	mov    $0x36,%esi
    17e4:	89 c7                	mov    %eax,%edi
    17e6:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    17ed:	00 00 00 
    17f0:	ff d0                	call   *%rax
        drawnum(row, 62, event->arg0, COLOR_GREEN);
    17f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    17f6:	8b 50 10             	mov    0x10(%rax),%edx
    17f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
    17fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1801:	be 3e 00 00 00       	mov    $0x3e,%esi
    1806:	89 c7                	mov    %eax,%edi
    1808:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    180f:	00 00 00 
    1812:	ff d0                	call   *%rax
}
    1814:	e9 f8 00 00 00       	jmp    1911 <draweventrow+0x364>
    } else if(event->type == TRACE_TYPE_MEM){
    1819:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    181d:	8b 40 08             	mov    0x8(%rax),%eax
    1820:	83 f8 04             	cmp    $0x4,%eax
    1823:	75 4e                	jne    1873 <draweventrow+0x2c6>
        vidputs(row, 54, "page = ", COLOR_NORMAL);
    1825:	48 ba 80 35 00 00 00 	movabs $0x3580,%rdx
    182c:	00 00 00 
    182f:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1832:	b9 07 00 00 00       	mov    $0x7,%ecx
    1837:	be 36 00 00 00       	mov    $0x36,%esi
    183c:	89 c7                	mov    %eax,%edi
    183e:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1845:	00 00 00 
    1848:	ff d0                	call   *%rax
        drawhex(row, 61, event->arg0, COLOR_YELLOW);
    184a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    184e:	8b 40 10             	mov    0x10(%rax),%eax
    1851:	89 c2                	mov    %eax,%edx
    1853:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1856:	b9 0e 00 00 00       	mov    $0xe,%ecx
    185b:	be 3d 00 00 00       	mov    $0x3d,%esi
    1860:	89 c7                	mov    %eax,%edi
    1862:	48 b8 3a 15 00 00 00 	movabs $0x153a,%rax
    1869:	00 00 00 
    186c:	ff d0                	call   *%rax
}
    186e:	e9 9e 00 00 00       	jmp    1911 <draweventrow+0x364>
    } else if(event->type == TRACE_TYPE_TRAP){
    1873:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1877:	8b 40 08             	mov    0x8(%rax),%eax
    187a:	83 f8 03             	cmp    $0x3,%eax
    187d:	0f 85 8e 00 00 00    	jne    1911 <draweventrow+0x364>
        vidputs(row, 54, "cause = ", COLOR_RED);
    1883:	48 ba 88 35 00 00 00 	movabs $0x3588,%rdx
    188a:	00 00 00 
    188d:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1890:	b9 0c 00 00 00       	mov    $0xc,%ecx
    1895:	be 36 00 00 00       	mov    $0x36,%esi
    189a:	89 c7                	mov    %eax,%edi
    189c:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    18a3:	00 00 00 
    18a6:	ff d0                	call   *%rax
        drawnum(row, 62, event->arg0, COLOR_RED);
    18a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    18ac:	8b 50 10             	mov    0x10(%rax),%edx
    18af:	8b 45 ec             	mov    -0x14(%rbp),%eax
    18b2:	b9 0c 00 00 00       	mov    $0xc,%ecx
    18b7:	be 3e 00 00 00       	mov    $0x3e,%esi
    18bc:	89 c7                	mov    %eax,%edi
    18be:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    18c5:	00 00 00 
    18c8:	ff d0                	call   *%rax
        vidputs(row, 66, "err = ", COLOR_RED);
    18ca:	48 ba 91 35 00 00 00 	movabs $0x3591,%rdx
    18d1:	00 00 00 
    18d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
    18d7:	b9 0c 00 00 00       	mov    $0xc,%ecx
    18dc:	be 42 00 00 00       	mov    $0x42,%esi
    18e1:	89 c7                	mov    %eax,%edi
    18e3:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    18ea:	00 00 00 
    18ed:	ff d0                	call   *%rax
        drawnum(row, 72, event->arg1, COLOR_RED);
    18ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    18f3:	8b 50 14             	mov    0x14(%rax),%edx
    18f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
    18f9:	b9 0c 00 00 00       	mov    $0xc,%ecx
    18fe:	be 48 00 00 00       	mov    $0x48,%esi
    1903:	89 c7                	mov    %eax,%edi
    1905:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    190c:	00 00 00 
    190f:	ff d0                	call   *%rax
}
    1911:	90                   	nop
    1912:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
    1916:	c9                   	leave
    1917:	c3                   	ret

0000000000001918 <draw_graph>:

static void
draw_graph(int row, int col, int *activity, int activity_pos){
    1918:	55                   	push   %rbp
    1919:	48 89 e5             	mov    %rsp,%rbp
    191c:	48 83 ec 40          	sub    $0x40,%rsp
    1920:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1923:	89 75 d8             	mov    %esi,-0x28(%rbp)
    1926:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
    192a:	89 4d cc             	mov    %ecx,-0x34(%rbp)
    int i, index, count, color;
    char bar[2];

    bar[1] = 0;
    192d:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
    vidputs(row, col, "event rate last 50 ticks: . none | - low | = medium | # high", COLOR_TITLE);
    1931:	48 ba 98 35 00 00 00 	movabs $0x3598,%rdx
    1938:	00 00 00 
    193b:	8b 75 d8             	mov    -0x28(%rbp),%esi
    193e:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1941:	b9 0f 00 00 00       	mov    $0xf,%ecx
    1946:	89 c7                	mov    %eax,%edi
    1948:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    194f:	00 00 00 
    1952:	ff d0                	call   *%rax

    for(i = 0; i < GRAPH_WIDTH; i++){
    1954:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    195b:	e9 b9 00 00 00       	jmp    1a19 <draw_graph+0x101>
        index = (activity_pos + 1 + i) % GRAPH_WIDTH;
    1960:	8b 45 cc             	mov    -0x34(%rbp),%eax
    1963:	8d 50 01             	lea    0x1(%rax),%edx
    1966:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1969:	01 d0                	add    %edx,%eax
    196b:	48 63 d0             	movslq %eax,%rdx
    196e:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
    1975:	48 c1 ea 20          	shr    $0x20,%rdx
    1979:	c1 fa 04             	sar    $0x4,%edx
    197c:	89 c1                	mov    %eax,%ecx
    197e:	c1 f9 1f             	sar    $0x1f,%ecx
    1981:	29 ca                	sub    %ecx,%edx
    1983:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1986:	8b 55 f4             	mov    -0xc(%rbp),%edx
    1989:	6b d2 32             	imul   $0x32,%edx,%edx
    198c:	29 d0                	sub    %edx,%eax
    198e:	89 45 f4             	mov    %eax,-0xc(%rbp)
        count = activity[index];
    1991:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1994:	48 98                	cltq
    1996:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
    199d:	00 
    199e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    19a2:	48 01 d0             	add    %rdx,%rax
    19a5:	8b 00                	mov    (%rax),%eax
    19a7:	89 45 f0             	mov    %eax,-0x10(%rbp)

        if(count == 0){
    19aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    19ae:	75 0d                	jne    19bd <draw_graph+0xa5>
            bar[0] = '.';
    19b0:	c6 45 ee 2e          	movb   $0x2e,-0x12(%rbp)
            color = COLOR_NORMAL;
    19b4:	c7 45 f8 07 00 00 00 	movl   $0x7,-0x8(%rbp)
    19bb:	eb 31                	jmp    19ee <draw_graph+0xd6>
        } else if (count < 3){
    19bd:	83 7d f0 02          	cmpl   $0x2,-0x10(%rbp)
    19c1:	7f 0d                	jg     19d0 <draw_graph+0xb8>
            bar[0] = '-';
    19c3:	c6 45 ee 2d          	movb   $0x2d,-0x12(%rbp)
            color = COLOR_GREEN;
    19c7:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    19ce:	eb 1e                	jmp    19ee <draw_graph+0xd6>
        } else if(count < 7){
    19d0:	83 7d f0 06          	cmpl   $0x6,-0x10(%rbp)
    19d4:	7f 0d                	jg     19e3 <draw_graph+0xcb>
            bar[0] = '=';
    19d6:	c6 45 ee 3d          	movb   $0x3d,-0x12(%rbp)
            color = COLOR_YELLOW;
    19da:	c7 45 f8 0e 00 00 00 	movl   $0xe,-0x8(%rbp)
    19e1:	eb 0b                	jmp    19ee <draw_graph+0xd6>
        } else {
            bar[0] = '#';
    19e3:	c6 45 ee 23          	movb   $0x23,-0x12(%rbp)
            color = COLOR_RED;
    19e7:	c7 45 f8 0c 00 00 00 	movl   $0xc,-0x8(%rbp)
        }

        vidputs(row + 1, col + i, bar, color);
    19ee:	8b 55 d8             	mov    -0x28(%rbp),%edx
    19f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    19f4:	8d 34 02             	lea    (%rdx,%rax,1),%esi
    19f7:	8b 45 dc             	mov    -0x24(%rbp),%eax
    19fa:	8d 78 01             	lea    0x1(%rax),%edi
    19fd:	8b 55 f8             	mov    -0x8(%rbp),%edx
    1a00:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    1a04:	89 d1                	mov    %edx,%ecx
    1a06:	48 89 c2             	mov    %rax,%rdx
    1a09:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1a10:	00 00 00 
    1a13:	ff d0                	call   *%rax
    for(i = 0; i < GRAPH_WIDTH; i++){
    1a15:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1a19:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
    1a1d:	0f 8e 3d ff ff ff    	jle    1960 <draw_graph+0x48>
    }
}
    1a23:	90                   	nop
    1a24:	90                   	nop
    1a25:	c9                   	leave
    1a26:	c3                   	ret

0000000000001a27 <drawBoard>:

static void
drawBoard(struct trace_event *recent, int recent_count, int recent_start,
          int filter_type, int filter_pid, int overwritten, int seen, int limit)
{
    1a27:	55                   	push   %rbp
    1a28:	48 89 e5             	mov    %rsp,%rbp
    1a2b:	53                   	push   %rbx
    1a2c:	48 83 ec 38          	sub    $0x38,%rsp
    1a30:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
    1a34:	89 75 d4             	mov    %esi,-0x2c(%rbp)
    1a37:	89 55 d0             	mov    %edx,-0x30(%rbp)
    1a3a:	89 4d cc             	mov    %ecx,-0x34(%rbp)
    1a3d:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    1a41:	44 89 4d c4          	mov    %r9d,-0x3c(%rbp)
    int i, index;

    vidclear();
    1a45:	48 b8 c2 2b 00 00 00 	movabs $0x2bc2,%rax
    1a4c:	00 00 00 
    1a4f:	ff d0                	call   *%rax

    vidputs(0, 0, "XV6 LIVE KERNEL TRACE DASHBOARD", COLOR_TITLE);
    1a51:	48 b8 d8 35 00 00 00 	movabs $0x35d8,%rax
    1a58:	00 00 00 
    1a5b:	b9 0f 00 00 00       	mov    $0xf,%ecx
    1a60:	48 89 c2             	mov    %rax,%rdx
    1a63:	be 00 00 00 00       	mov    $0x0,%esi
    1a68:	bf 00 00 00 00       	mov    $0x0,%edi
    1a6d:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1a74:	00 00 00 
    1a77:	ff d0                	call   *%rax
    
    vidputs(0, 36, "FILTER:", COLOR_NORMAL);
    1a79:	48 b8 f8 35 00 00 00 	movabs $0x35f8,%rax
    1a80:	00 00 00 
    1a83:	b9 07 00 00 00       	mov    $0x7,%ecx
    1a88:	48 89 c2             	mov    %rax,%rdx
    1a8b:	be 24 00 00 00       	mov    $0x24,%esi
    1a90:	bf 00 00 00 00       	mov    $0x0,%edi
    1a95:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1a9c:	00 00 00 
    1a9f:	ff d0                	call   *%rax
    vidputs(0, 44, typename(filter_type), type_color(filter_type));
    1aa1:	8b 45 cc             	mov    -0x34(%rbp),%eax
    1aa4:	89 c7                	mov    %eax,%edi
    1aa6:	48 b8 6d 10 00 00 00 	movabs $0x106d,%rax
    1aad:	00 00 00 
    1ab0:	ff d0                	call   *%rax
    1ab2:	89 c3                	mov    %eax,%ebx
    1ab4:	8b 45 cc             	mov    -0x34(%rbp),%eax
    1ab7:	89 c7                	mov    %eax,%edi
    1ab9:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1ac0:	00 00 00 
    1ac3:	ff d0                	call   *%rax
    1ac5:	89 d9                	mov    %ebx,%ecx
    1ac7:	48 89 c2             	mov    %rax,%rdx
    1aca:	be 2c 00 00 00       	mov    $0x2c,%esi
    1acf:	bf 00 00 00 00       	mov    $0x0,%edi
    1ad4:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1adb:	00 00 00 
    1ade:	ff d0                	call   *%rax
    vidputs(0, 52, "pid = ", COLOR_NORMAL);
    1ae0:	48 b8 00 36 00 00 00 	movabs $0x3600,%rax
    1ae7:	00 00 00 
    1aea:	b9 07 00 00 00       	mov    $0x7,%ecx
    1aef:	48 89 c2             	mov    %rax,%rdx
    1af2:	be 34 00 00 00       	mov    $0x34,%esi
    1af7:	bf 00 00 00 00       	mov    $0x0,%edi
    1afc:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1b03:	00 00 00 
    1b06:	ff d0                	call   *%rax
    if(filter_pid == -1) vidputs(0, 58, "all", COLOR_NORMAL);
    1b08:	83 7d c8 ff          	cmpl   $0xffffffff,-0x38(%rbp)
    1b0c:	75 2a                	jne    1b38 <drawBoard+0x111>
    1b0e:	48 b8 fe 34 00 00 00 	movabs $0x34fe,%rax
    1b15:	00 00 00 
    1b18:	b9 07 00 00 00       	mov    $0x7,%ecx
    1b1d:	48 89 c2             	mov    %rax,%rdx
    1b20:	be 3a 00 00 00       	mov    $0x3a,%esi
    1b25:	bf 00 00 00 00       	mov    $0x0,%edi
    1b2a:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1b31:	00 00 00 
    1b34:	ff d0                	call   *%rax
    1b36:	eb 20                	jmp    1b58 <drawBoard+0x131>
    else drawnum(0, 58, filter_pid, COLOR_NORMAL);
    1b38:	8b 45 c8             	mov    -0x38(%rbp),%eax
    1b3b:	b9 07 00 00 00       	mov    $0x7,%ecx
    1b40:	89 c2                	mov    %eax,%edx
    1b42:	be 3a 00 00 00       	mov    $0x3a,%esi
    1b47:	bf 00 00 00 00       	mov    $0x0,%edi
    1b4c:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1b53:	00 00 00 
    1b56:	ff d0                	call   *%rax

    vidputs(0, 64, "STATUS:", COLOR_NORMAL);
    1b58:	48 b8 07 36 00 00 00 	movabs $0x3607,%rax
    1b5f:	00 00 00 
    1b62:	b9 07 00 00 00       	mov    $0x7,%ecx
    1b67:	48 89 c2             	mov    %rax,%rdx
    1b6a:	be 40 00 00 00       	mov    $0x40,%esi
    1b6f:	bf 00 00 00 00       	mov    $0x0,%edi
    1b74:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1b7b:	00 00 00 
    1b7e:	ff d0                	call   *%rax
    if(limit == 0) vidputs(0, 72, "ONESHOT", COLOR_YELLOW);
    1b80:	83 7d 18 00          	cmpl   $0x0,0x18(%rbp)
    1b84:	75 2a                	jne    1bb0 <drawBoard+0x189>
    1b86:	48 b8 0f 36 00 00 00 	movabs $0x360f,%rax
    1b8d:	00 00 00 
    1b90:	b9 0e 00 00 00       	mov    $0xe,%ecx
    1b95:	48 89 c2             	mov    %rax,%rdx
    1b98:	be 48 00 00 00       	mov    $0x48,%esi
    1b9d:	bf 00 00 00 00       	mov    $0x0,%edi
    1ba2:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1ba9:	00 00 00 
    1bac:	ff d0                	call   *%rax
    1bae:	eb 28                	jmp    1bd8 <drawBoard+0x1b1>
    else vidputs(0, 72, "LIVE", COLOR_GREEN);
    1bb0:	48 b8 17 36 00 00 00 	movabs $0x3617,%rax
    1bb7:	00 00 00 
    1bba:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1bbf:	48 89 c2             	mov    %rax,%rdx
    1bc2:	be 48 00 00 00       	mov    $0x48,%esi
    1bc7:	bf 00 00 00 00       	mov    $0x0,%edi
    1bcc:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1bd3:	00 00 00 
    1bd6:	ff d0                	call   *%rax

    vidputs(1, 0, "captured = ", COLOR_NORMAL);
    1bd8:	48 b8 1c 36 00 00 00 	movabs $0x361c,%rax
    1bdf:	00 00 00 
    1be2:	b9 07 00 00 00       	mov    $0x7,%ecx
    1be7:	48 89 c2             	mov    %rax,%rdx
    1bea:	be 00 00 00 00       	mov    $0x0,%esi
    1bef:	bf 01 00 00 00       	mov    $0x1,%edi
    1bf4:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1bfb:	00 00 00 
    1bfe:	ff d0                	call   *%rax
    drawnum(1, 11, seen, COLOR_CYAN);
    1c00:	8b 45 10             	mov    0x10(%rbp),%eax
    1c03:	b9 0b 00 00 00       	mov    $0xb,%ecx
    1c08:	89 c2                	mov    %eax,%edx
    1c0a:	be 0b 00 00 00       	mov    $0xb,%esi
    1c0f:	bf 01 00 00 00       	mov    $0x1,%edi
    1c14:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1c1b:	00 00 00 
    1c1e:	ff d0                	call   *%rax
    vidputs(1, 15, "/ ", COLOR_NORMAL);
    1c20:	48 b8 28 36 00 00 00 	movabs $0x3628,%rax
    1c27:	00 00 00 
    1c2a:	b9 07 00 00 00       	mov    $0x7,%ecx
    1c2f:	48 89 c2             	mov    %rax,%rdx
    1c32:	be 0f 00 00 00       	mov    $0xf,%esi
    1c37:	bf 01 00 00 00       	mov    $0x1,%edi
    1c3c:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1c43:	00 00 00 
    1c46:	ff d0                	call   *%rax
    if(limit == 0) drawnum(1, 17, 128, COLOR_CYAN); // Kernel buffer is 128
    1c48:	83 7d 18 00          	cmpl   $0x0,0x18(%rbp)
    1c4c:	75 22                	jne    1c70 <drawBoard+0x249>
    1c4e:	b9 0b 00 00 00       	mov    $0xb,%ecx
    1c53:	ba 80 00 00 00       	mov    $0x80,%edx
    1c58:	be 11 00 00 00       	mov    $0x11,%esi
    1c5d:	bf 01 00 00 00       	mov    $0x1,%edi
    1c62:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1c69:	00 00 00 
    1c6c:	ff d0                	call   *%rax
    1c6e:	eb 20                	jmp    1c90 <drawBoard+0x269>
    else drawnum(1, 17, limit, COLOR_CYAN);
    1c70:	8b 45 18             	mov    0x18(%rbp),%eax
    1c73:	b9 0b 00 00 00       	mov    $0xb,%ecx
    1c78:	89 c2                	mov    %eax,%edx
    1c7a:	be 11 00 00 00       	mov    $0x11,%esi
    1c7f:	bf 01 00 00 00       	mov    $0x1,%edi
    1c84:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1c8b:	00 00 00 
    1c8e:	ff d0                	call   *%rax

    vidputs(1, 26, "showing: syscall = ", COLOR_NORMAL);
    1c90:	48 b8 2b 36 00 00 00 	movabs $0x362b,%rax
    1c97:	00 00 00 
    1c9a:	b9 07 00 00 00       	mov    $0x7,%ecx
    1c9f:	48 89 c2             	mov    %rax,%rdx
    1ca2:	be 1a 00 00 00       	mov    $0x1a,%esi
    1ca7:	bf 01 00 00 00       	mov    $0x1,%edi
    1cac:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1cb3:	00 00 00 
    1cb6:	ff d0                	call   *%rax
    drawnum(1, 45, sys_count, COLOR_CYAN);
    1cb8:	48 b8 60 37 00 00 00 	movabs $0x3760,%rax
    1cbf:	00 00 00 
    1cc2:	8b 00                	mov    (%rax),%eax
    1cc4:	b9 0b 00 00 00       	mov    $0xb,%ecx
    1cc9:	89 c2                	mov    %eax,%edx
    1ccb:	be 2d 00 00 00       	mov    $0x2d,%esi
    1cd0:	bf 01 00 00 00       	mov    $0x1,%edi
    1cd5:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1cdc:	00 00 00 
    1cdf:	ff d0                	call   *%rax
    vidputs(1, 48, " proc = ", COLOR_NORMAL);
    1ce1:	48 b8 3f 36 00 00 00 	movabs $0x363f,%rax
    1ce8:	00 00 00 
    1ceb:	b9 07 00 00 00       	mov    $0x7,%ecx
    1cf0:	48 89 c2             	mov    %rax,%rdx
    1cf3:	be 30 00 00 00       	mov    $0x30,%esi
    1cf8:	bf 01 00 00 00       	mov    $0x1,%edi
    1cfd:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1d04:	00 00 00 
    1d07:	ff d0                	call   *%rax
    drawnum(1, 56, proc_count, COLOR_GREEN);
    1d09:	48 b8 64 37 00 00 00 	movabs $0x3764,%rax
    1d10:	00 00 00 
    1d13:	8b 00                	mov    (%rax),%eax
    1d15:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1d1a:	89 c2                	mov    %eax,%edx
    1d1c:	be 38 00 00 00       	mov    $0x38,%esi
    1d21:	bf 01 00 00 00       	mov    $0x1,%edi
    1d26:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1d2d:	00 00 00 
    1d30:	ff d0                	call   *%rax
    vidputs(1, 59, " mem = ", COLOR_NORMAL);
    1d32:	48 b8 48 36 00 00 00 	movabs $0x3648,%rax
    1d39:	00 00 00 
    1d3c:	b9 07 00 00 00       	mov    $0x7,%ecx
    1d41:	48 89 c2             	mov    %rax,%rdx
    1d44:	be 3b 00 00 00       	mov    $0x3b,%esi
    1d49:	bf 01 00 00 00       	mov    $0x1,%edi
    1d4e:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1d55:	00 00 00 
    1d58:	ff d0                	call   *%rax
    drawnum(1, 66, mem_count, COLOR_YELLOW);
    1d5a:	48 b8 68 37 00 00 00 	movabs $0x3768,%rax
    1d61:	00 00 00 
    1d64:	8b 00                	mov    (%rax),%eax
    1d66:	b9 0e 00 00 00       	mov    $0xe,%ecx
    1d6b:	89 c2                	mov    %eax,%edx
    1d6d:	be 42 00 00 00       	mov    $0x42,%esi
    1d72:	bf 01 00 00 00       	mov    $0x1,%edi
    1d77:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1d7e:	00 00 00 
    1d81:	ff d0                	call   *%rax
    vidputs(1, 69, " trap = ", COLOR_NORMAL);
    1d83:	48 b8 50 36 00 00 00 	movabs $0x3650,%rax
    1d8a:	00 00 00 
    1d8d:	b9 07 00 00 00       	mov    $0x7,%ecx
    1d92:	48 89 c2             	mov    %rax,%rdx
    1d95:	be 45 00 00 00       	mov    $0x45,%esi
    1d9a:	bf 01 00 00 00       	mov    $0x1,%edi
    1d9f:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1da6:	00 00 00 
    1da9:	ff d0                	call   *%rax
    drawnum(1, 77, trap_count, COLOR_RED);
    1dab:	48 b8 6c 37 00 00 00 	movabs $0x376c,%rax
    1db2:	00 00 00 
    1db5:	8b 00                	mov    (%rax),%eax
    1db7:	b9 0c 00 00 00       	mov    $0xc,%ecx
    1dbc:	89 c2                	mov    %eax,%edx
    1dbe:	be 4d 00 00 00       	mov    $0x4d,%esi
    1dc3:	bf 01 00 00 00       	mov    $0x1,%edi
    1dc8:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1dcf:	00 00 00 
    1dd2:	ff d0                	call   *%rax

    vidputs(2, 0, "overwritten = ", COLOR_NORMAL);
    1dd4:	48 b8 59 36 00 00 00 	movabs $0x3659,%rax
    1ddb:	00 00 00 
    1dde:	b9 07 00 00 00       	mov    $0x7,%ecx
    1de3:	48 89 c2             	mov    %rax,%rdx
    1de6:	be 00 00 00 00       	mov    $0x0,%esi
    1deb:	bf 02 00 00 00       	mov    $0x2,%edi
    1df0:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1df7:	00 00 00 
    1dfa:	ff d0                	call   *%rax
    drawnum(2, 14, overwritten, overwritten > 0 ? COLOR_RED : COLOR_NORMAL);
    1dfc:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
    1e00:	7e 07                	jle    1e09 <drawBoard+0x3e2>
    1e02:	ba 0c 00 00 00       	mov    $0xc,%edx
    1e07:	eb 05                	jmp    1e0e <drawBoard+0x3e7>
    1e09:	ba 07 00 00 00       	mov    $0x7,%edx
    1e0e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
    1e11:	89 d1                	mov    %edx,%ecx
    1e13:	89 c2                	mov    %eax,%edx
    1e15:	be 0e 00 00 00       	mov    $0xe,%esi
    1e1a:	bf 02 00 00 00       	mov    $0x2,%edi
    1e1f:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1e26:	00 00 00 
    1e29:	ff d0                	call   *%rax

    vidputs(2, 26, "total:   syscall = ", COLOR_NORMAL);
    1e2b:	48 b8 68 36 00 00 00 	movabs $0x3668,%rax
    1e32:	00 00 00 
    1e35:	b9 07 00 00 00       	mov    $0x7,%ecx
    1e3a:	48 89 c2             	mov    %rax,%rdx
    1e3d:	be 1a 00 00 00       	mov    $0x1a,%esi
    1e42:	bf 02 00 00 00       	mov    $0x2,%edi
    1e47:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1e4e:	00 00 00 
    1e51:	ff d0                	call   *%rax
    drawnum(2, 45, t_sys_count, COLOR_CYAN);
    1e53:	48 b8 70 37 00 00 00 	movabs $0x3770,%rax
    1e5a:	00 00 00 
    1e5d:	8b 00                	mov    (%rax),%eax
    1e5f:	b9 0b 00 00 00       	mov    $0xb,%ecx
    1e64:	89 c2                	mov    %eax,%edx
    1e66:	be 2d 00 00 00       	mov    $0x2d,%esi
    1e6b:	bf 02 00 00 00       	mov    $0x2,%edi
    1e70:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1e77:	00 00 00 
    1e7a:	ff d0                	call   *%rax
    vidputs(2, 48, " proc = ", COLOR_NORMAL);
    1e7c:	48 b8 3f 36 00 00 00 	movabs $0x363f,%rax
    1e83:	00 00 00 
    1e86:	b9 07 00 00 00       	mov    $0x7,%ecx
    1e8b:	48 89 c2             	mov    %rax,%rdx
    1e8e:	be 30 00 00 00       	mov    $0x30,%esi
    1e93:	bf 02 00 00 00       	mov    $0x2,%edi
    1e98:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1e9f:	00 00 00 
    1ea2:	ff d0                	call   *%rax
    drawnum(2, 56, t_proc_count, COLOR_GREEN);
    1ea4:	48 b8 74 37 00 00 00 	movabs $0x3774,%rax
    1eab:	00 00 00 
    1eae:	8b 00                	mov    (%rax),%eax
    1eb0:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1eb5:	89 c2                	mov    %eax,%edx
    1eb7:	be 38 00 00 00       	mov    $0x38,%esi
    1ebc:	bf 02 00 00 00       	mov    $0x2,%edi
    1ec1:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1ec8:	00 00 00 
    1ecb:	ff d0                	call   *%rax
    vidputs(2, 59, " mem = ", COLOR_NORMAL);
    1ecd:	48 b8 48 36 00 00 00 	movabs $0x3648,%rax
    1ed4:	00 00 00 
    1ed7:	b9 07 00 00 00       	mov    $0x7,%ecx
    1edc:	48 89 c2             	mov    %rax,%rdx
    1edf:	be 3b 00 00 00       	mov    $0x3b,%esi
    1ee4:	bf 02 00 00 00       	mov    $0x2,%edi
    1ee9:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1ef0:	00 00 00 
    1ef3:	ff d0                	call   *%rax
    drawnum(2, 66, t_mem_count, COLOR_YELLOW);
    1ef5:	48 b8 78 37 00 00 00 	movabs $0x3778,%rax
    1efc:	00 00 00 
    1eff:	8b 00                	mov    (%rax),%eax
    1f01:	b9 0e 00 00 00       	mov    $0xe,%ecx
    1f06:	89 c2                	mov    %eax,%edx
    1f08:	be 42 00 00 00       	mov    $0x42,%esi
    1f0d:	bf 02 00 00 00       	mov    $0x2,%edi
    1f12:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1f19:	00 00 00 
    1f1c:	ff d0                	call   *%rax
    vidputs(2, 69, " trap = ", COLOR_NORMAL);
    1f1e:	48 b8 50 36 00 00 00 	movabs $0x3650,%rax
    1f25:	00 00 00 
    1f28:	b9 07 00 00 00       	mov    $0x7,%ecx
    1f2d:	48 89 c2             	mov    %rax,%rdx
    1f30:	be 45 00 00 00       	mov    $0x45,%esi
    1f35:	bf 02 00 00 00       	mov    $0x2,%edi
    1f3a:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1f41:	00 00 00 
    1f44:	ff d0                	call   *%rax
    drawnum(2, 77, t_trap_count, COLOR_RED);
    1f46:	48 b8 7c 37 00 00 00 	movabs $0x377c,%rax
    1f4d:	00 00 00 
    1f50:	8b 00                	mov    (%rax),%eax
    1f52:	b9 0c 00 00 00       	mov    $0xc,%ecx
    1f57:	89 c2                	mov    %eax,%edx
    1f59:	be 4d 00 00 00       	mov    $0x4d,%esi
    1f5e:	bf 02 00 00 00       	mov    $0x2,%edi
    1f63:	48 b8 f0 14 00 00 00 	movabs $0x14f0,%rax
    1f6a:	00 00 00 
    1f6d:	ff d0                	call   *%rax

    vidputs(6, 0, "SEQ  TICKS  PID  PROC             SUBSYS   EVENT      DETAILS", COLOR_TITLE);
    1f6f:	48 b8 80 36 00 00 00 	movabs $0x3680,%rax
    1f76:	00 00 00 
    1f79:	b9 0f 00 00 00       	mov    $0xf,%ecx
    1f7e:	48 89 c2             	mov    %rax,%rdx
    1f81:	be 00 00 00 00       	mov    $0x0,%esi
    1f86:	bf 06 00 00 00       	mov    $0x6,%edi
    1f8b:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1f92:	00 00 00 
    1f95:	ff d0                	call   *%rax
    vidputs(7, 0, "---------------------------------------------------------------------------", COLOR_NORMAL);
    1f97:	48 b8 c0 36 00 00 00 	movabs $0x36c0,%rax
    1f9e:	00 00 00 
    1fa1:	b9 07 00 00 00       	mov    $0x7,%ecx
    1fa6:	48 89 c2             	mov    %rax,%rdx
    1fa9:	be 00 00 00 00       	mov    $0x0,%esi
    1fae:	bf 07 00 00 00       	mov    $0x7,%edi
    1fb3:	48 b8 dc 2b 00 00 00 	movabs $0x2bdc,%rax
    1fba:	00 00 00 
    1fbd:	ff d0                	call   *%rax
   
    // Limit loop by recent_count, display_rows, AND MAX_TRACE_ROWS
    for(i = 0; i < recent_count && i < display_rows && i < MAX_TRACE_ROWS; i++){
    1fbf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    1fc6:	eb 48                	jmp    2010 <drawBoard+0x5e9>
        index = (recent_start + i) % MAX_TRACE_ROWS;
    1fc8:	8b 55 d0             	mov    -0x30(%rbp),%edx
    1fcb:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1fce:	01 c2                	add    %eax,%edx
    1fd0:	89 d0                	mov    %edx,%eax
    1fd2:	c1 f8 1f             	sar    $0x1f,%eax
    1fd5:	c1 e8 1b             	shr    $0x1b,%eax
    1fd8:	01 c2                	add    %eax,%edx
    1fda:	83 e2 1f             	and    $0x1f,%edx
    1fdd:	29 c2                	sub    %eax,%edx
    1fdf:	89 55 e8             	mov    %edx,-0x18(%rbp)
        draweventrow(8 + i, &recent[index]);
    1fe2:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1fe5:	48 98                	cltq
    1fe7:	48 c1 e0 06          	shl    $0x6,%rax
    1feb:	48 89 c2             	mov    %rax,%rdx
    1fee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1ff2:	48 01 c2             	add    %rax,%rdx
    1ff5:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ff8:	83 c0 08             	add    $0x8,%eax
    1ffb:	48 89 d6             	mov    %rdx,%rsi
    1ffe:	89 c7                	mov    %eax,%edi
    2000:	48 b8 ad 15 00 00 00 	movabs $0x15ad,%rax
    2007:	00 00 00 
    200a:	ff d0                	call   *%rax
    for(i = 0; i < recent_count && i < display_rows && i < MAX_TRACE_ROWS; i++){
    200c:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
    2010:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2013:	3b 45 d4             	cmp    -0x2c(%rbp),%eax
    2016:	7d 17                	jge    202f <drawBoard+0x608>
    2018:	48 b8 30 37 00 00 00 	movabs $0x3730,%rax
    201f:	00 00 00 
    2022:	8b 00                	mov    (%rax),%eax
    2024:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    2027:	7d 06                	jge    202f <drawBoard+0x608>
    2029:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
    202d:	7e 99                	jle    1fc8 <drawBoard+0x5a1>
    }
}
    202f:	90                   	nop
    2030:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
    2034:	c9                   	leave
    2035:	c3                   	ret

0000000000002036 <main>:



int
main(int argc, char **argv){
    2036:	55                   	push   %rbp
    2037:	48 89 e5             	mov    %rsp,%rbp
    203a:	53                   	push   %rbx
    203b:	48 81 ec 78 01 00 00 	sub    $0x178,%rsp
    2042:	89 bd 8c fe ff ff    	mov    %edi,-0x174(%rbp)
    2048:	48 89 b5 80 fe ff ff 	mov    %rsi,-0x180(%rbp)
    struct trace_event event;
    int recent_count = 0;
    204f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    int recent_start = 0;
    2056:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
    int limit = 0; // Default: drain buffer and exit
    205d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
    int seen = 0;
    2064:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
    int activity[GRAPH_WIDTH];
    int activity_pos = 0;
    206b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
    int last_tick = -1;
    2072:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
    int i;
    int filter_type = 0;
    2079:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%rbp)
    int filter_pid = -1;
    2080:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%rbp)
    int overwritten = 0;
    2087:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
    int arg_idx = 1;
    208e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%rbp)
    int self_pid = getpid();
    2095:	48 b8 81 2b 00 00 00 	movabs $0x2b81,%rax
    209c:	00 00 00 
    209f:	ff d0                	call   *%rax
    20a1:	89 45 b4             	mov    %eax,-0x4c(%rbp)
    int limit_set = 0;
    20a4:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%rbp)

    while(arg_idx < argc) {
    20ab:	e9 64 02 00 00       	jmp    2314 <main+0x2de>
        if(strcmp(argv[arg_idx], "-n") == 0 && arg_idx + 1 < argc) {
    20b0:	8b 45 c4             	mov    -0x3c(%rbp),%eax
    20b3:	48 98                	cltq
    20b5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    20bc:	00 
    20bd:	48 8b 85 80 fe ff ff 	mov    -0x180(%rbp),%rax
    20c4:	48 01 d0             	add    %rdx,%rax
    20c7:	48 8b 00             	mov    (%rax),%rax
    20ca:	48 ba 0c 37 00 00 00 	movabs $0x370c,%rdx
    20d1:	00 00 00 
    20d4:	48 89 d6             	mov    %rdx,%rsi
    20d7:	48 89 c7             	mov    %rax,%rdi
    20da:	48 b8 0f 28 00 00 00 	movabs $0x280f,%rax
    20e1:	00 00 00 
    20e4:	ff d0                	call   *%rax
    20e6:	85 c0                	test   %eax,%eax
    20e8:	75 71                	jne    215b <main+0x125>
    20ea:	8b 45 c4             	mov    -0x3c(%rbp),%eax
    20ed:	83 c0 01             	add    $0x1,%eax
    20f0:	39 85 8c fe ff ff    	cmp    %eax,-0x174(%rbp)
    20f6:	7e 63                	jle    215b <main+0x125>
            display_rows = atoi(argv[arg_idx + 1]);
    20f8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
    20fb:	48 98                	cltq
    20fd:	48 83 c0 01          	add    $0x1,%rax
    2101:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    2108:	00 
    2109:	48 8b 85 80 fe ff ff 	mov    -0x180(%rbp),%rax
    2110:	48 01 d0             	add    %rdx,%rax
    2113:	48 8b 00             	mov    (%rax),%rax
    2116:	48 89 c7             	mov    %rax,%rdi
    2119:	48 b8 f7 29 00 00 00 	movabs $0x29f7,%rax
    2120:	00 00 00 
    2123:	ff d0                	call   *%rax
    2125:	48 ba 30 37 00 00 00 	movabs $0x3730,%rdx
    212c:	00 00 00 
    212f:	89 02                	mov    %eax,(%rdx)
            if(display_rows > MAX_TRACE_ROWS) display_rows = MAX_TRACE_ROWS;
    2131:	48 b8 30 37 00 00 00 	movabs $0x3730,%rax
    2138:	00 00 00 
    213b:	8b 00                	mov    (%rax),%eax
    213d:	83 f8 20             	cmp    $0x20,%eax
    2140:	7e 10                	jle    2152 <main+0x11c>
    2142:	48 b8 30 37 00 00 00 	movabs $0x3730,%rax
    2149:	00 00 00 
    214c:	c7 00 20 00 00 00    	movl   $0x20,(%rax)
            arg_idx += 2;
    2152:	83 45 c4 02          	addl   $0x2,-0x3c(%rbp)
    2156:	e9 b9 01 00 00       	jmp    2314 <main+0x2de>
        } else if(strcmp(argv[arg_idx], "syscall") == 0) {
    215b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
    215e:	48 98                	cltq
    2160:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    2167:	00 
    2168:	48 8b 85 80 fe ff ff 	mov    -0x180(%rbp),%rax
    216f:	48 01 d0             	add    %rdx,%rax
    2172:	48 8b 00             	mov    (%rax),%rax
    2175:	48 ba e8 34 00 00 00 	movabs $0x34e8,%rdx
    217c:	00 00 00 
    217f:	48 89 d6             	mov    %rdx,%rsi
    2182:	48 89 c7             	mov    %rax,%rdi
    2185:	48 b8 0f 28 00 00 00 	movabs $0x280f,%rax
    218c:	00 00 00 
    218f:	ff d0                	call   *%rax
    2191:	85 c0                	test   %eax,%eax
    2193:	75 10                	jne    21a5 <main+0x16f>
            filter_type = TRACE_TYPE_SYSCALL;
    2195:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%rbp)
            arg_idx++;
    219c:	83 45 c4 01          	addl   $0x1,-0x3c(%rbp)
    21a0:	e9 6f 01 00 00       	jmp    2314 <main+0x2de>
        } else if(strcmp(argv[arg_idx], "proc") == 0) {
    21a5:	8b 45 c4             	mov    -0x3c(%rbp),%eax
    21a8:	48 98                	cltq
    21aa:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    21b1:	00 
    21b2:	48 8b 85 80 fe ff ff 	mov    -0x180(%rbp),%rax
    21b9:	48 01 d0             	add    %rdx,%rax
    21bc:	48 8b 00             	mov    (%rax),%rax
    21bf:	48 ba f0 34 00 00 00 	movabs $0x34f0,%rdx
    21c6:	00 00 00 
    21c9:	48 89 d6             	mov    %rdx,%rsi
    21cc:	48 89 c7             	mov    %rax,%rdi
    21cf:	48 b8 0f 28 00 00 00 	movabs $0x280f,%rax
    21d6:	00 00 00 
    21d9:	ff d0                	call   *%rax
    21db:	85 c0                	test   %eax,%eax
    21dd:	75 10                	jne    21ef <main+0x1b9>
            filter_type = TRACE_TYPE_PROC;
    21df:	c7 45 d0 02 00 00 00 	movl   $0x2,-0x30(%rbp)
            arg_idx++;
    21e6:	83 45 c4 01          	addl   $0x1,-0x3c(%rbp)
    21ea:	e9 25 01 00 00       	jmp    2314 <main+0x2de>
        } else if(strcmp(argv[arg_idx], "mem") == 0) {
    21ef:	8b 45 c4             	mov    -0x3c(%rbp),%eax
    21f2:	48 98                	cltq
    21f4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    21fb:	00 
    21fc:	48 8b 85 80 fe ff ff 	mov    -0x180(%rbp),%rax
    2203:	48 01 d0             	add    %rdx,%rax
    2206:	48 8b 00             	mov    (%rax),%rax
    2209:	48 ba fa 34 00 00 00 	movabs $0x34fa,%rdx
    2210:	00 00 00 
    2213:	48 89 d6             	mov    %rdx,%rsi
    2216:	48 89 c7             	mov    %rax,%rdi
    2219:	48 b8 0f 28 00 00 00 	movabs $0x280f,%rax
    2220:	00 00 00 
    2223:	ff d0                	call   *%rax
    2225:	85 c0                	test   %eax,%eax
    2227:	75 10                	jne    2239 <main+0x203>
            filter_type = TRACE_TYPE_MEM;
    2229:	c7 45 d0 04 00 00 00 	movl   $0x4,-0x30(%rbp)
            arg_idx++;
    2230:	83 45 c4 01          	addl   $0x1,-0x3c(%rbp)
    2234:	e9 db 00 00 00       	jmp    2314 <main+0x2de>
        } else if(strcmp(argv[arg_idx], "trap") == 0) {
    2239:	8b 45 c4             	mov    -0x3c(%rbp),%eax
    223c:	48 98                	cltq
    223e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    2245:	00 
    2246:	48 8b 85 80 fe ff ff 	mov    -0x180(%rbp),%rax
    224d:	48 01 d0             	add    %rdx,%rax
    2250:	48 8b 00             	mov    (%rax),%rax
    2253:	48 ba f5 34 00 00 00 	movabs $0x34f5,%rdx
    225a:	00 00 00 
    225d:	48 89 d6             	mov    %rdx,%rsi
    2260:	48 89 c7             	mov    %rax,%rdi
    2263:	48 b8 0f 28 00 00 00 	movabs $0x280f,%rax
    226a:	00 00 00 
    226d:	ff d0                	call   *%rax
    226f:	85 c0                	test   %eax,%eax
    2271:	75 10                	jne    2283 <main+0x24d>
            filter_type = TRACE_TYPE_TRAP;
    2273:	c7 45 d0 03 00 00 00 	movl   $0x3,-0x30(%rbp)
            arg_idx++;
    227a:	83 45 c4 01          	addl   $0x1,-0x3c(%rbp)
    227e:	e9 91 00 00 00       	jmp    2314 <main+0x2de>
        } else {
            // Must be a number (limit or PID)
            int val = atoi(argv[arg_idx]);
    2283:	8b 45 c4             	mov    -0x3c(%rbp),%eax
    2286:	48 98                	cltq
    2288:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    228f:	00 
    2290:	48 8b 85 80 fe ff ff 	mov    -0x180(%rbp),%rax
    2297:	48 01 d0             	add    %rdx,%rax
    229a:	48 8b 00             	mov    (%rax),%rax
    229d:	48 89 c7             	mov    %rax,%rdi
    22a0:	48 b8 f7 29 00 00 00 	movabs $0x29f7,%rax
    22a7:	00 00 00 
    22aa:	ff d0                	call   *%rax
    22ac:	89 45 a8             	mov    %eax,-0x58(%rbp)
            // check if it's actually a number (or "0")
            if(val > 0 || strcmp(argv[arg_idx], "0") == 0) {
    22af:	83 7d a8 00          	cmpl   $0x0,-0x58(%rbp)
    22b3:	7f 3a                	jg     22ef <main+0x2b9>
    22b5:	8b 45 c4             	mov    -0x3c(%rbp),%eax
    22b8:	48 98                	cltq
    22ba:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    22c1:	00 
    22c2:	48 8b 85 80 fe ff ff 	mov    -0x180(%rbp),%rax
    22c9:	48 01 d0             	add    %rdx,%rax
    22cc:	48 8b 00             	mov    (%rax),%rax
    22cf:	48 ba 0f 37 00 00 00 	movabs $0x370f,%rdx
    22d6:	00 00 00 
    22d9:	48 89 d6             	mov    %rdx,%rsi
    22dc:	48 89 c7             	mov    %rax,%rdi
    22df:	48 b8 0f 28 00 00 00 	movabs $0x280f,%rax
    22e6:	00 00 00 
    22e9:	ff d0                	call   *%rax
    22eb:	85 c0                	test   %eax,%eax
    22ed:	75 21                	jne    2310 <main+0x2da>
                if(!limit_set) {
    22ef:	83 7d c0 00          	cmpl   $0x0,-0x40(%rbp)
    22f3:	75 0f                	jne    2304 <main+0x2ce>
                    limit = val;
    22f5:	8b 45 a8             	mov    -0x58(%rbp),%eax
    22f8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                    limit_set = 1;
    22fb:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%rbp)
    2302:	eb 0c                	jmp    2310 <main+0x2da>
                } else if(filter_pid == -1) {
    2304:	83 7d cc ff          	cmpl   $0xffffffff,-0x34(%rbp)
    2308:	75 06                	jne    2310 <main+0x2da>
                    filter_pid = val;
    230a:	8b 45 a8             	mov    -0x58(%rbp),%eax
    230d:	89 45 cc             	mov    %eax,-0x34(%rbp)
                }
            }
            arg_idx++;
    2310:	83 45 c4 01          	addl   $0x1,-0x3c(%rbp)
    while(arg_idx < argc) {
    2314:	8b 45 c4             	mov    -0x3c(%rbp),%eax
    2317:	3b 85 8c fe ff ff    	cmp    -0x174(%rbp),%eax
    231d:	0f 8c 8d fd ff ff    	jl     20b0 <main+0x7a>
        }
    }

    // Flush console cursor to the bottom (row 24)
    // This prevents the shell prompt from scrolling our dashboard up
    for(i = 0; i < 25; i++) printf(1, "\n");
    2323:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
    232a:	eb 27                	jmp    2353 <main+0x31d>
    232c:	48 b8 11 37 00 00 00 	movabs $0x3711,%rax
    2333:	00 00 00 
    2336:	48 89 c6             	mov    %rax,%rsi
    2339:	bf 01 00 00 00       	mov    $0x1,%edi
    233e:	b8 00 00 00 00       	mov    $0x0,%eax
    2343:	48 ba bf 2d 00 00 00 	movabs $0x2dbf,%rdx
    234a:	00 00 00 
    234d:	ff d2                	call   *%rdx
    234f:	83 45 d4 01          	addl   $0x1,-0x2c(%rbp)
    2353:	83 7d d4 18          	cmpl   $0x18,-0x2c(%rbp)
    2357:	7e d3                	jle    232c <main+0x2f6>
    vidclear();
    2359:	48 b8 c2 2b 00 00 00 	movabs $0x2bc2,%rax
    2360:	00 00 00 
    2363:	ff d0                	call   *%rax
    
    // initialize activity graph
    for(i = 0; i < GRAPH_WIDTH; i++){
    2365:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
    236c:	eb 14                	jmp    2382 <main+0x34c>
        activity[i] = 0;
    236e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    2371:	48 98                	cltq
    2373:	c7 84 85 90 fe ff ff 	movl   $0x0,-0x170(%rbp,%rax,4)
    237a:	00 00 00 00 
    for(i = 0; i < GRAPH_WIDTH; i++){
    237e:	83 45 d4 01          	addl   $0x1,-0x2c(%rbp)
    2382:	83 7d d4 31          	cmpl   $0x31,-0x2c(%rbp)
    2386:	7e e6                	jle    236e <main+0x338>
    }

    while(limit == 0 || seen < limit){
    2388:	e9 e1 03 00 00       	jmp    276e <main+0x738>
        int n = traceread(&event, 1);
    238d:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
    2394:	be 01 00 00 00       	mov    $0x1,%esi
    2399:	48 89 c7             	mov    %rax,%rdi
    239c:	48 b8 b5 2b 00 00 00 	movabs $0x2bb5,%rax
    23a3:	00 00 00 
    23a6:	ff d0                	call   *%rax
    23a8:	89 45 b0             	mov    %eax,-0x50(%rbp)

        if(n < 0){
    23ab:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
    23af:	79 2f                	jns    23e0 <main+0x3aa>
            printf(1, "traceread failed\n");
    23b1:	48 b8 13 37 00 00 00 	movabs $0x3713,%rax
    23b8:	00 00 00 
    23bb:	48 89 c6             	mov    %rax,%rsi
    23be:	bf 01 00 00 00       	mov    $0x1,%edi
    23c3:	b8 00 00 00 00       	mov    $0x0,%eax
    23c8:	48 ba bf 2d 00 00 00 	movabs $0x2dbf,%rdx
    23cf:	00 00 00 
    23d2:	ff d2                	call   *%rdx
            exit();
    23d4:	48 b8 b1 2a 00 00 00 	movabs $0x2ab1,%rax
    23db:	00 00 00 
    23de:	ff d0                	call   *%rax
        }

        if(n == 0){
    23e0:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
    23e4:	0f 85 38 01 00 00    	jne    2522 <main+0x4ec>
            // If in drain mode (limit=0) and no unread events, we're done
            if(limit == 0 && recent_count > 0) break;
    23ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    23ee:	75 0a                	jne    23fa <main+0x3c4>
    23f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    23f4:	0f 8f 8c 03 00 00    	jg     2786 <main+0x750>
            if(limit == 0 && seen == 0) {
    23fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    23fe:	75 1e                	jne    241e <main+0x3e8>
    2400:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
    2404:	75 18                	jne    241e <main+0x3e8>
                 // if buffer was empty from start, give it a tiny bit of time
                 if(uptime() - last_tick > 10) break; 
    2406:	48 b8 a8 2b 00 00 00 	movabs $0x2ba8,%rax
    240d:	00 00 00 
    2410:	ff d0                	call   *%rax
    2412:	2b 45 d8             	sub    -0x28(%rbp),%eax
    2415:	83 f8 0a             	cmp    $0xa,%eax
    2418:	0f 8f 6b 03 00 00    	jg     2789 <main+0x753>
            }

            // Idle loop for live mode: update current time and graph
            int now = uptime();
    241e:	48 b8 a8 2b 00 00 00 	movabs $0x2ba8,%rax
    2425:	00 00 00 
    2428:	ff d0                	call   *%rax
    242a:	89 45 ac             	mov    %eax,-0x54(%rbp)
            if(last_tick == -1) last_tick = now;
    242d:	83 7d d8 ff          	cmpl   $0xffffffff,-0x28(%rbp)
    2431:	75 06                	jne    2439 <main+0x403>
    2433:	8b 45 ac             	mov    -0x54(%rbp),%eax
    2436:	89 45 d8             	mov    %eax,-0x28(%rbp)
            
            if(now > last_tick){
    2439:	8b 45 ac             	mov    -0x54(%rbp),%eax
    243c:	3b 45 d8             	cmp    -0x28(%rbp),%eax
    243f:	0f 8e c7 00 00 00    	jle    250c <main+0x4d6>
                int diff = now - last_tick;
    2445:	8b 45 ac             	mov    -0x54(%rbp),%eax
    2448:	2b 45 d8             	sub    -0x28(%rbp),%eax
    244b:	89 45 bc             	mov    %eax,-0x44(%rbp)
                if(diff > 50) diff = 50;
    244e:	83 7d bc 32          	cmpl   $0x32,-0x44(%rbp)
    2452:	7e 07                	jle    245b <main+0x425>
    2454:	c7 45 bc 32 00 00 00 	movl   $0x32,-0x44(%rbp)
                for(i = 0; i < diff; i++){
    245b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
    2462:	eb 40                	jmp    24a4 <main+0x46e>
                    activity_pos = (activity_pos + 1) % GRAPH_WIDTH;
    2464:	8b 45 dc             	mov    -0x24(%rbp),%eax
    2467:	83 c0 01             	add    $0x1,%eax
    246a:	48 63 d0             	movslq %eax,%rdx
    246d:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
    2474:	48 c1 ea 20          	shr    $0x20,%rdx
    2478:	c1 fa 04             	sar    $0x4,%edx
    247b:	89 c1                	mov    %eax,%ecx
    247d:	c1 f9 1f             	sar    $0x1f,%ecx
    2480:	29 ca                	sub    %ecx,%edx
    2482:	89 55 dc             	mov    %edx,-0x24(%rbp)
    2485:	8b 55 dc             	mov    -0x24(%rbp),%edx
    2488:	6b d2 32             	imul   $0x32,%edx,%edx
    248b:	29 d0                	sub    %edx,%eax
    248d:	89 45 dc             	mov    %eax,-0x24(%rbp)
                    activity[activity_pos] = 0;
    2490:	8b 45 dc             	mov    -0x24(%rbp),%eax
    2493:	48 98                	cltq
    2495:	c7 84 85 90 fe ff ff 	movl   $0x0,-0x170(%rbp,%rax,4)
    249c:	00 00 00 00 
                for(i = 0; i < diff; i++){
    24a0:	83 45 d4 01          	addl   $0x1,-0x2c(%rbp)
    24a4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    24a7:	3b 45 bc             	cmp    -0x44(%rbp),%eax
    24aa:	7c b8                	jl     2464 <main+0x42e>
                }
                last_tick = now;
    24ac:	8b 45 ac             	mov    -0x54(%rbp),%eax
    24af:	89 45 d8             	mov    %eax,-0x28(%rbp)
                drawBoard(recent, recent_count, recent_start, filter_type, filter_pid, overwritten, seen, limit);
    24b2:	44 8b 4d c8          	mov    -0x38(%rbp),%r9d
    24b6:	44 8b 45 cc          	mov    -0x34(%rbp),%r8d
    24ba:	8b 4d d0             	mov    -0x30(%rbp),%ecx
    24bd:	8b 55 e8             	mov    -0x18(%rbp),%edx
    24c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
    24c3:	48 bf 80 37 00 00 00 	movabs $0x3780,%rdi
    24ca:	00 00 00 
    24cd:	8b 75 e4             	mov    -0x1c(%rbp),%esi
    24d0:	56                   	push   %rsi
    24d1:	8b 75 e0             	mov    -0x20(%rbp),%esi
    24d4:	56                   	push   %rsi
    24d5:	89 c6                	mov    %eax,%esi
    24d7:	48 b8 27 1a 00 00 00 	movabs $0x1a27,%rax
    24de:	00 00 00 
    24e1:	ff d0                	call   *%rax
    24e3:	48 83 c4 10          	add    $0x10,%rsp
                draw_graph(4, 0, activity, activity_pos);
    24e7:	8b 55 dc             	mov    -0x24(%rbp),%edx
    24ea:	48 8d 85 90 fe ff ff 	lea    -0x170(%rbp),%rax
    24f1:	89 d1                	mov    %edx,%ecx
    24f3:	48 89 c2             	mov    %rax,%rdx
    24f6:	be 00 00 00 00       	mov    $0x0,%esi
    24fb:	bf 04 00 00 00       	mov    $0x4,%edi
    2500:	48 b8 18 19 00 00 00 	movabs $0x1918,%rax
    2507:	00 00 00 
    250a:	ff d0                	call   *%rax
            }
            sleep(10);
    250c:	bf 0a 00 00 00       	mov    $0xa,%edi
    2511:	48 b8 9b 2b 00 00 00 	movabs $0x2b9b,%rax
    2518:	00 00 00 
    251b:	ff d0                	call   *%rax
            continue;
    251d:	e9 4c 02 00 00       	jmp    276e <main+0x738>
        }

        update_total_counts(&event);
    2522:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
    2529:	48 89 c7             	mov    %rax,%rdi
    252c:	48 b8 70 12 00 00 00 	movabs $0x1270,%rax
    2533:	00 00 00 
    2536:	ff d0                	call   *%rax
        overwritten = event.overwritten;
    2538:	8b 45 9c             	mov    -0x64(%rbp),%eax
    253b:	89 45 c8             	mov    %eax,-0x38(%rbp)

        // Skip events from the dashboard itself or those that don't match the filter
        if(!want_event(&event, filter_type, filter_pid, self_pid))
    253e:	8b 4d b4             	mov    -0x4c(%rbp),%ecx
    2541:	8b 55 cc             	mov    -0x34(%rbp),%edx
    2544:	8b 75 d0             	mov    -0x30(%rbp),%esi
    2547:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
    254e:	48 89 c7             	mov    %rax,%rdi
    2551:	48 b8 5e 11 00 00 00 	movabs $0x115e,%rax
    2558:	00 00 00 
    255b:	ff d0                	call   *%rax
    255d:	85 c0                	test   %eax,%eax
    255f:	0f 84 08 02 00 00    	je     276d <main+0x737>
            continue;
        
        update_window_counts(&event);
    2565:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
    256c:	48 89 c7             	mov    %rax,%rdi
    256f:	48 b8 bf 11 00 00 00 	movabs $0x11bf,%rax
    2576:	00 00 00 
    2579:	ff d0                	call   *%rax

        // Update the activity graph based on event time
        if(last_tick == -1)
    257b:	83 7d d8 ff          	cmpl   $0xffffffff,-0x28(%rbp)
    257f:	75 09                	jne    258a <main+0x554>
            last_tick = event.ticks;
    2581:	8b 85 64 ff ff ff    	mov    -0x9c(%rbp),%eax
    2587:	89 45 d8             	mov    %eax,-0x28(%rbp)

        if(event.ticks > last_tick){
    258a:	8b 85 64 ff ff ff    	mov    -0x9c(%rbp),%eax
    2590:	8b 55 d8             	mov    -0x28(%rbp),%edx
    2593:	39 c2                	cmp    %eax,%edx
    2595:	73 75                	jae    260c <main+0x5d6>
            int diff = event.ticks - last_tick;
    2597:	8b 95 64 ff ff ff    	mov    -0x9c(%rbp),%edx
    259d:	8b 45 d8             	mov    -0x28(%rbp),%eax
    25a0:	29 c2                	sub    %eax,%edx
    25a2:	89 55 b8             	mov    %edx,-0x48(%rbp)
            if(diff > 50) diff = 50; 
    25a5:	83 7d b8 32          	cmpl   $0x32,-0x48(%rbp)
    25a9:	7e 07                	jle    25b2 <main+0x57c>
    25ab:	c7 45 b8 32 00 00 00 	movl   $0x32,-0x48(%rbp)
            for(i = 0; i < diff; i++) {
    25b2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
    25b9:	eb 40                	jmp    25fb <main+0x5c5>
                activity_pos = (activity_pos + 1) % GRAPH_WIDTH;
    25bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
    25be:	83 c0 01             	add    $0x1,%eax
    25c1:	48 63 d0             	movslq %eax,%rdx
    25c4:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
    25cb:	48 c1 ea 20          	shr    $0x20,%rdx
    25cf:	c1 fa 04             	sar    $0x4,%edx
    25d2:	89 c1                	mov    %eax,%ecx
    25d4:	c1 f9 1f             	sar    $0x1f,%ecx
    25d7:	29 ca                	sub    %ecx,%edx
    25d9:	89 55 dc             	mov    %edx,-0x24(%rbp)
    25dc:	8b 55 dc             	mov    -0x24(%rbp),%edx
    25df:	6b d2 32             	imul   $0x32,%edx,%edx
    25e2:	29 d0                	sub    %edx,%eax
    25e4:	89 45 dc             	mov    %eax,-0x24(%rbp)
                activity[activity_pos] = 0;
    25e7:	8b 45 dc             	mov    -0x24(%rbp),%eax
    25ea:	48 98                	cltq
    25ec:	c7 84 85 90 fe ff ff 	movl   $0x0,-0x170(%rbp,%rax,4)
    25f3:	00 00 00 00 
            for(i = 0; i < diff; i++) {
    25f7:	83 45 d4 01          	addl   $0x1,-0x2c(%rbp)
    25fb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    25fe:	3b 45 b8             	cmp    -0x48(%rbp),%eax
    2601:	7c b8                	jl     25bb <main+0x585>
            }
            last_tick = event.ticks;
    2603:	8b 85 64 ff ff ff    	mov    -0x9c(%rbp),%eax
    2609:	89 45 d8             	mov    %eax,-0x28(%rbp)
        }
        activity[activity_pos]++;
    260c:	8b 45 dc             	mov    -0x24(%rbp),%eax
    260f:	48 98                	cltq
    2611:	8b 84 85 90 fe ff ff 	mov    -0x170(%rbp,%rax,4),%eax
    2618:	8d 50 01             	lea    0x1(%rax),%edx
    261b:	8b 45 dc             	mov    -0x24(%rbp),%eax
    261e:	48 98                	cltq
    2620:	89 94 85 90 fe ff ff 	mov    %edx,-0x170(%rbp,%rax,4)


        if(recent_count < MAX_TRACE_ROWS){
    2627:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
    262b:	7f 67                	jg     2694 <main+0x65e>
            recent[recent_count] = event;
    262d:	48 ba 80 37 00 00 00 	movabs $0x3780,%rdx
    2634:	00 00 00 
    2637:	8b 45 ec             	mov    -0x14(%rbp),%eax
    263a:	48 98                	cltq
    263c:	48 c1 e0 06          	shl    $0x6,%rax
    2640:	48 01 d0             	add    %rdx,%rax
    2643:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
    264a:	48 8b 9d 68 ff ff ff 	mov    -0x98(%rbp),%rbx
    2651:	48 89 08             	mov    %rcx,(%rax)
    2654:	48 89 58 08          	mov    %rbx,0x8(%rax)
    2658:	48 8b 8d 70 ff ff ff 	mov    -0x90(%rbp),%rcx
    265f:	48 8b 9d 78 ff ff ff 	mov    -0x88(%rbp),%rbx
    2666:	48 89 48 10          	mov    %rcx,0x10(%rax)
    266a:	48 89 58 18          	mov    %rbx,0x18(%rax)
    266e:	48 8b 4d 80          	mov    -0x80(%rbp),%rcx
    2672:	48 8b 5d 88          	mov    -0x78(%rbp),%rbx
    2676:	48 89 48 20          	mov    %rcx,0x20(%rax)
    267a:	48 89 58 28          	mov    %rbx,0x28(%rax)
    267e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
    2682:	48 8b 5d 98          	mov    -0x68(%rbp),%rbx
    2686:	48 89 48 30          	mov    %rcx,0x30(%rax)
    268a:	48 89 58 38          	mov    %rbx,0x38(%rax)
            recent_count++;
    268e:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
    2692:	eb 79                	jmp    270d <main+0x6d7>
        } else {
            recent[recent_start] = event;
    2694:	48 ba 80 37 00 00 00 	movabs $0x3780,%rdx
    269b:	00 00 00 
    269e:	8b 45 e8             	mov    -0x18(%rbp),%eax
    26a1:	48 98                	cltq
    26a3:	48 c1 e0 06          	shl    $0x6,%rax
    26a7:	48 01 d0             	add    %rdx,%rax
    26aa:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
    26b1:	48 8b 9d 68 ff ff ff 	mov    -0x98(%rbp),%rbx
    26b8:	48 89 08             	mov    %rcx,(%rax)
    26bb:	48 89 58 08          	mov    %rbx,0x8(%rax)
    26bf:	48 8b 8d 70 ff ff ff 	mov    -0x90(%rbp),%rcx
    26c6:	48 8b 9d 78 ff ff ff 	mov    -0x88(%rbp),%rbx
    26cd:	48 89 48 10          	mov    %rcx,0x10(%rax)
    26d1:	48 89 58 18          	mov    %rbx,0x18(%rax)
    26d5:	48 8b 4d 80          	mov    -0x80(%rbp),%rcx
    26d9:	48 8b 5d 88          	mov    -0x78(%rbp),%rbx
    26dd:	48 89 48 20          	mov    %rcx,0x20(%rax)
    26e1:	48 89 58 28          	mov    %rbx,0x28(%rax)
    26e5:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
    26e9:	48 8b 5d 98          	mov    -0x68(%rbp),%rbx
    26ed:	48 89 48 30          	mov    %rcx,0x30(%rax)
    26f1:	48 89 58 38          	mov    %rbx,0x38(%rax)
            recent_start = (recent_start + 1) % MAX_TRACE_ROWS;
    26f5:	8b 45 e8             	mov    -0x18(%rbp),%eax
    26f8:	8d 50 01             	lea    0x1(%rax),%edx
    26fb:	89 d0                	mov    %edx,%eax
    26fd:	c1 f8 1f             	sar    $0x1f,%eax
    2700:	c1 e8 1b             	shr    $0x1b,%eax
    2703:	01 c2                	add    %eax,%edx
    2705:	83 e2 1f             	and    $0x1f,%edx
    2708:	29 c2                	sub    %eax,%edx
    270a:	89 55 e8             	mov    %edx,-0x18(%rbp)
        }
        
        drawBoard(recent, recent_count, recent_start, filter_type, filter_pid, overwritten, seen, limit);
    270d:	44 8b 4d c8          	mov    -0x38(%rbp),%r9d
    2711:	44 8b 45 cc          	mov    -0x34(%rbp),%r8d
    2715:	8b 4d d0             	mov    -0x30(%rbp),%ecx
    2718:	8b 55 e8             	mov    -0x18(%rbp),%edx
    271b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    271e:	48 bf 80 37 00 00 00 	movabs $0x3780,%rdi
    2725:	00 00 00 
    2728:	8b 75 e4             	mov    -0x1c(%rbp),%esi
    272b:	56                   	push   %rsi
    272c:	8b 75 e0             	mov    -0x20(%rbp),%esi
    272f:	56                   	push   %rsi
    2730:	89 c6                	mov    %eax,%esi
    2732:	48 b8 27 1a 00 00 00 	movabs $0x1a27,%rax
    2739:	00 00 00 
    273c:	ff d0                	call   *%rax
    273e:	48 83 c4 10          	add    $0x10,%rsp
        draw_graph(4, 0, activity, activity_pos);
    2742:	8b 55 dc             	mov    -0x24(%rbp),%edx
    2745:	48 8d 85 90 fe ff ff 	lea    -0x170(%rbp),%rax
    274c:	89 d1                	mov    %edx,%ecx
    274e:	48 89 c2             	mov    %rax,%rdx
    2751:	be 00 00 00 00       	mov    $0x0,%esi
    2756:	bf 04 00 00 00       	mov    $0x4,%edi
    275b:	48 b8 18 19 00 00 00 	movabs $0x1918,%rax
    2762:	00 00 00 
    2765:	ff d0                	call   *%rax

        seen++;
    2767:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
    276b:	eb 01                	jmp    276e <main+0x738>
            continue;
    276d:	90                   	nop
    while(limit == 0 || seen < limit){
    276e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    2772:	0f 84 15 fc ff ff    	je     238d <main+0x357>
    2778:	8b 45 e0             	mov    -0x20(%rbp),%eax
    277b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
    277e:	0f 8c 09 fc ff ff    	jl     238d <main+0x357>
    2784:	eb 04                	jmp    278a <main+0x754>
            if(limit == 0 && recent_count > 0) break;
    2786:	90                   	nop
    2787:	eb 01                	jmp    278a <main+0x754>
                 if(uptime() - last_tick > 10) break; 
    2789:	90                   	nop
    }
    
    exit();
    278a:	48 b8 b1 2a 00 00 00 	movabs $0x2ab1,%rax
    2791:	00 00 00 
    2794:	ff d0                	call   *%rax

0000000000002796 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    2796:	55                   	push   %rbp
    2797:	48 89 e5             	mov    %rsp,%rbp
    279a:	48 83 ec 10          	sub    $0x10,%rsp
    279e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    27a2:	89 75 f4             	mov    %esi,-0xc(%rbp)
    27a5:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    27a8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    27ac:	8b 55 f0             	mov    -0x10(%rbp),%edx
    27af:	8b 45 f4             	mov    -0xc(%rbp),%eax
    27b2:	48 89 ce             	mov    %rcx,%rsi
    27b5:	48 89 f7             	mov    %rsi,%rdi
    27b8:	89 d1                	mov    %edx,%ecx
    27ba:	fc                   	cld
    27bb:	f3 aa                	rep stos %al,(%rdi)
    27bd:	89 ca                	mov    %ecx,%edx
    27bf:	48 89 fe             	mov    %rdi,%rsi
    27c2:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    27c6:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    27c9:	90                   	nop
    27ca:	c9                   	leave
    27cb:	c3                   	ret

00000000000027cc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    27cc:	55                   	push   %rbp
    27cd:	48 89 e5             	mov    %rsp,%rbp
    27d0:	48 83 ec 20          	sub    $0x20,%rsp
    27d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    27d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    27dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    27e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    27e4:	90                   	nop
    27e5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    27e9:	48 8d 42 01          	lea    0x1(%rdx),%rax
    27ed:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    27f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    27f5:	48 8d 48 01          	lea    0x1(%rax),%rcx
    27f9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    27fd:	0f b6 12             	movzbl (%rdx),%edx
    2800:	88 10                	mov    %dl,(%rax)
    2802:	0f b6 00             	movzbl (%rax),%eax
    2805:	84 c0                	test   %al,%al
    2807:	75 dc                	jne    27e5 <strcpy+0x19>
    ;
  return os;
    2809:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    280d:	c9                   	leave
    280e:	c3                   	ret

000000000000280f <strcmp>:

int
strcmp(const char *p, const char *q)
{
    280f:	55                   	push   %rbp
    2810:	48 89 e5             	mov    %rsp,%rbp
    2813:	48 83 ec 10          	sub    $0x10,%rsp
    2817:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    281b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    281f:	eb 0a                	jmp    282b <strcmp+0x1c>
    p++, q++;
    2821:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    2826:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    282b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    282f:	0f b6 00             	movzbl (%rax),%eax
    2832:	84 c0                	test   %al,%al
    2834:	74 12                	je     2848 <strcmp+0x39>
    2836:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    283a:	0f b6 10             	movzbl (%rax),%edx
    283d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2841:	0f b6 00             	movzbl (%rax),%eax
    2844:	38 c2                	cmp    %al,%dl
    2846:	74 d9                	je     2821 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    2848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    284c:	0f b6 00             	movzbl (%rax),%eax
    284f:	0f b6 d0             	movzbl %al,%edx
    2852:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2856:	0f b6 00             	movzbl (%rax),%eax
    2859:	0f b6 c0             	movzbl %al,%eax
    285c:	29 c2                	sub    %eax,%edx
    285e:	89 d0                	mov    %edx,%eax
}
    2860:	c9                   	leave
    2861:	c3                   	ret

0000000000002862 <strlen>:

uint
strlen(char *s)
{
    2862:	55                   	push   %rbp
    2863:	48 89 e5             	mov    %rsp,%rbp
    2866:	48 83 ec 18          	sub    $0x18,%rsp
    286a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    286e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2875:	eb 04                	jmp    287b <strlen+0x19>
    2877:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    287b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    287e:	48 63 d0             	movslq %eax,%rdx
    2881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2885:	48 01 d0             	add    %rdx,%rax
    2888:	0f b6 00             	movzbl (%rax),%eax
    288b:	84 c0                	test   %al,%al
    288d:	75 e8                	jne    2877 <strlen+0x15>
    ;
  return n;
    288f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    2892:	c9                   	leave
    2893:	c3                   	ret

0000000000002894 <memset>:

void*
memset(void *dst, int c, uint n)
{
    2894:	55                   	push   %rbp
    2895:	48 89 e5             	mov    %rsp,%rbp
    2898:	48 83 ec 10          	sub    $0x10,%rsp
    289c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    28a0:	89 75 f4             	mov    %esi,-0xc(%rbp)
    28a3:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    28a6:	8b 55 f0             	mov    -0x10(%rbp),%edx
    28a9:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    28ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    28b0:	89 ce                	mov    %ecx,%esi
    28b2:	48 89 c7             	mov    %rax,%rdi
    28b5:	48 b8 96 27 00 00 00 	movabs $0x2796,%rax
    28bc:	00 00 00 
    28bf:	ff d0                	call   *%rax
  return dst;
    28c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    28c5:	c9                   	leave
    28c6:	c3                   	ret

00000000000028c7 <strchr>:

char*
strchr(const char *s, char c)
{
    28c7:	55                   	push   %rbp
    28c8:	48 89 e5             	mov    %rsp,%rbp
    28cb:	48 83 ec 10          	sub    $0x10,%rsp
    28cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    28d3:	89 f0                	mov    %esi,%eax
    28d5:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    28d8:	eb 17                	jmp    28f1 <strchr+0x2a>
    if(*s == c)
    28da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    28de:	0f b6 00             	movzbl (%rax),%eax
    28e1:	38 45 f4             	cmp    %al,-0xc(%rbp)
    28e4:	75 06                	jne    28ec <strchr+0x25>
      return (char*)s;
    28e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    28ea:	eb 15                	jmp    2901 <strchr+0x3a>
  for(; *s; s++)
    28ec:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    28f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    28f5:	0f b6 00             	movzbl (%rax),%eax
    28f8:	84 c0                	test   %al,%al
    28fa:	75 de                	jne    28da <strchr+0x13>
  return 0;
    28fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
    2901:	c9                   	leave
    2902:	c3                   	ret

0000000000002903 <gets>:

char*
gets(char *buf, int max)
{
    2903:	55                   	push   %rbp
    2904:	48 89 e5             	mov    %rsp,%rbp
    2907:	48 83 ec 20          	sub    $0x20,%rsp
    290b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    290f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    2912:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2919:	eb 4f                	jmp    296a <gets+0x67>
    cc = read(0, &c, 1);
    291b:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    291f:	ba 01 00 00 00       	mov    $0x1,%edx
    2924:	48 89 c6             	mov    %rax,%rsi
    2927:	bf 00 00 00 00       	mov    $0x0,%edi
    292c:	48 b8 d8 2a 00 00 00 	movabs $0x2ad8,%rax
    2933:	00 00 00 
    2936:	ff d0                	call   *%rax
    2938:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    293b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    293f:	7e 36                	jle    2977 <gets+0x74>
      break;
    buf[i++] = c;
    2941:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2944:	8d 50 01             	lea    0x1(%rax),%edx
    2947:	89 55 fc             	mov    %edx,-0x4(%rbp)
    294a:	48 63 d0             	movslq %eax,%rdx
    294d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2951:	48 01 c2             	add    %rax,%rdx
    2954:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    2958:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    295a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    295e:	3c 0a                	cmp    $0xa,%al
    2960:	74 16                	je     2978 <gets+0x75>
    2962:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    2966:	3c 0d                	cmp    $0xd,%al
    2968:	74 0e                	je     2978 <gets+0x75>
  for(i=0; i+1 < max; ){
    296a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    296d:	83 c0 01             	add    $0x1,%eax
    2970:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    2973:	7f a6                	jg     291b <gets+0x18>
    2975:	eb 01                	jmp    2978 <gets+0x75>
      break;
    2977:	90                   	nop
      break;
  }
  buf[i] = '\0';
    2978:	8b 45 fc             	mov    -0x4(%rbp),%eax
    297b:	48 63 d0             	movslq %eax,%rdx
    297e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2982:	48 01 d0             	add    %rdx,%rax
    2985:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    2988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    298c:	c9                   	leave
    298d:	c3                   	ret

000000000000298e <stat>:

int
stat(char *n, struct stat *st)
{
    298e:	55                   	push   %rbp
    298f:	48 89 e5             	mov    %rsp,%rbp
    2992:	48 83 ec 20          	sub    $0x20,%rsp
    2996:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    299a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    299e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    29a2:	be 00 00 00 00       	mov    $0x0,%esi
    29a7:	48 89 c7             	mov    %rax,%rdi
    29aa:	48 b8 19 2b 00 00 00 	movabs $0x2b19,%rax
    29b1:	00 00 00 
    29b4:	ff d0                	call   *%rax
    29b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    29b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    29bd:	79 07                	jns    29c6 <stat+0x38>
    return -1;
    29bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    29c4:	eb 2f                	jmp    29f5 <stat+0x67>
  r = fstat(fd, st);
    29c6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    29ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
    29cd:	48 89 d6             	mov    %rdx,%rsi
    29d0:	89 c7                	mov    %eax,%edi
    29d2:	48 b8 40 2b 00 00 00 	movabs $0x2b40,%rax
    29d9:	00 00 00 
    29dc:	ff d0                	call   *%rax
    29de:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    29e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    29e4:	89 c7                	mov    %eax,%edi
    29e6:	48 b8 f2 2a 00 00 00 	movabs $0x2af2,%rax
    29ed:	00 00 00 
    29f0:	ff d0                	call   *%rax
  return r;
    29f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    29f5:	c9                   	leave
    29f6:	c3                   	ret

00000000000029f7 <atoi>:

int
atoi(const char *s)
{
    29f7:	55                   	push   %rbp
    29f8:	48 89 e5             	mov    %rsp,%rbp
    29fb:	48 83 ec 18          	sub    $0x18,%rsp
    29ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    2a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    2a0a:	eb 28                	jmp    2a34 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    2a0c:	8b 55 fc             	mov    -0x4(%rbp),%edx
    2a0f:	89 d0                	mov    %edx,%eax
    2a11:	c1 e0 02             	shl    $0x2,%eax
    2a14:	01 d0                	add    %edx,%eax
    2a16:	01 c0                	add    %eax,%eax
    2a18:	89 c1                	mov    %eax,%ecx
    2a1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2a1e:	48 8d 50 01          	lea    0x1(%rax),%rdx
    2a22:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    2a26:	0f b6 00             	movzbl (%rax),%eax
    2a29:	0f be c0             	movsbl %al,%eax
    2a2c:	01 c8                	add    %ecx,%eax
    2a2e:	83 e8 30             	sub    $0x30,%eax
    2a31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    2a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2a38:	0f b6 00             	movzbl (%rax),%eax
    2a3b:	3c 2f                	cmp    $0x2f,%al
    2a3d:	7e 0b                	jle    2a4a <atoi+0x53>
    2a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2a43:	0f b6 00             	movzbl (%rax),%eax
    2a46:	3c 39                	cmp    $0x39,%al
    2a48:	7e c2                	jle    2a0c <atoi+0x15>
  return n;
    2a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    2a4d:	c9                   	leave
    2a4e:	c3                   	ret

0000000000002a4f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    2a4f:	55                   	push   %rbp
    2a50:	48 89 e5             	mov    %rsp,%rbp
    2a53:	48 83 ec 28          	sub    $0x28,%rsp
    2a57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    2a5b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    2a5f:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    2a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2a66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    2a6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    2a6e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    2a72:	eb 1d                	jmp    2a91 <memmove+0x42>
    *dst++ = *src++;
    2a74:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    2a78:	48 8d 42 01          	lea    0x1(%rdx),%rax
    2a7c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    2a80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2a84:	48 8d 48 01          	lea    0x1(%rax),%rcx
    2a88:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    2a8c:	0f b6 12             	movzbl (%rdx),%edx
    2a8f:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    2a91:	8b 45 dc             	mov    -0x24(%rbp),%eax
    2a94:	8d 50 ff             	lea    -0x1(%rax),%edx
    2a97:	89 55 dc             	mov    %edx,-0x24(%rbp)
    2a9a:	85 c0                	test   %eax,%eax
    2a9c:	7f d6                	jg     2a74 <memmove+0x25>
  return vdst;
    2a9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    2aa2:	c9                   	leave
    2aa3:	c3                   	ret

0000000000002aa4 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    2aa4:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    2aab:	49 89 ca             	mov    %rcx,%r10
    2aae:	0f 05                	syscall
    2ab0:	c3                   	ret

0000000000002ab1 <exit>:
SYSCALL(exit)
    2ab1:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    2ab8:	49 89 ca             	mov    %rcx,%r10
    2abb:	0f 05                	syscall
    2abd:	c3                   	ret

0000000000002abe <wait>:
SYSCALL(wait)
    2abe:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    2ac5:	49 89 ca             	mov    %rcx,%r10
    2ac8:	0f 05                	syscall
    2aca:	c3                   	ret

0000000000002acb <pipe>:
SYSCALL(pipe)
    2acb:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    2ad2:	49 89 ca             	mov    %rcx,%r10
    2ad5:	0f 05                	syscall
    2ad7:	c3                   	ret

0000000000002ad8 <read>:
SYSCALL(read)
    2ad8:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    2adf:	49 89 ca             	mov    %rcx,%r10
    2ae2:	0f 05                	syscall
    2ae4:	c3                   	ret

0000000000002ae5 <write>:
SYSCALL(write)
    2ae5:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    2aec:	49 89 ca             	mov    %rcx,%r10
    2aef:	0f 05                	syscall
    2af1:	c3                   	ret

0000000000002af2 <close>:
SYSCALL(close)
    2af2:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    2af9:	49 89 ca             	mov    %rcx,%r10
    2afc:	0f 05                	syscall
    2afe:	c3                   	ret

0000000000002aff <kill>:
SYSCALL(kill)
    2aff:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    2b06:	49 89 ca             	mov    %rcx,%r10
    2b09:	0f 05                	syscall
    2b0b:	c3                   	ret

0000000000002b0c <exec>:
SYSCALL(exec)
    2b0c:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    2b13:	49 89 ca             	mov    %rcx,%r10
    2b16:	0f 05                	syscall
    2b18:	c3                   	ret

0000000000002b19 <open>:
SYSCALL(open)
    2b19:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    2b20:	49 89 ca             	mov    %rcx,%r10
    2b23:	0f 05                	syscall
    2b25:	c3                   	ret

0000000000002b26 <mknod>:
SYSCALL(mknod)
    2b26:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    2b2d:	49 89 ca             	mov    %rcx,%r10
    2b30:	0f 05                	syscall
    2b32:	c3                   	ret

0000000000002b33 <unlink>:
SYSCALL(unlink)
    2b33:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    2b3a:	49 89 ca             	mov    %rcx,%r10
    2b3d:	0f 05                	syscall
    2b3f:	c3                   	ret

0000000000002b40 <fstat>:
SYSCALL(fstat)
    2b40:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    2b47:	49 89 ca             	mov    %rcx,%r10
    2b4a:	0f 05                	syscall
    2b4c:	c3                   	ret

0000000000002b4d <link>:
SYSCALL(link)
    2b4d:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    2b54:	49 89 ca             	mov    %rcx,%r10
    2b57:	0f 05                	syscall
    2b59:	c3                   	ret

0000000000002b5a <mkdir>:
SYSCALL(mkdir)
    2b5a:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    2b61:	49 89 ca             	mov    %rcx,%r10
    2b64:	0f 05                	syscall
    2b66:	c3                   	ret

0000000000002b67 <chdir>:
SYSCALL(chdir)
    2b67:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    2b6e:	49 89 ca             	mov    %rcx,%r10
    2b71:	0f 05                	syscall
    2b73:	c3                   	ret

0000000000002b74 <dup>:
SYSCALL(dup)
    2b74:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    2b7b:	49 89 ca             	mov    %rcx,%r10
    2b7e:	0f 05                	syscall
    2b80:	c3                   	ret

0000000000002b81 <getpid>:
SYSCALL(getpid)
    2b81:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    2b88:	49 89 ca             	mov    %rcx,%r10
    2b8b:	0f 05                	syscall
    2b8d:	c3                   	ret

0000000000002b8e <sbrk>:
SYSCALL(sbrk)
    2b8e:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    2b95:	49 89 ca             	mov    %rcx,%r10
    2b98:	0f 05                	syscall
    2b9a:	c3                   	ret

0000000000002b9b <sleep>:
SYSCALL(sleep)
    2b9b:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    2ba2:	49 89 ca             	mov    %rcx,%r10
    2ba5:	0f 05                	syscall
    2ba7:	c3                   	ret

0000000000002ba8 <uptime>:
SYSCALL(uptime)
    2ba8:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    2baf:	49 89 ca             	mov    %rcx,%r10
    2bb2:	0f 05                	syscall
    2bb4:	c3                   	ret

0000000000002bb5 <traceread>:
SYSCALL(traceread)
    2bb5:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    2bbc:	49 89 ca             	mov    %rcx,%r10
    2bbf:	0f 05                	syscall
    2bc1:	c3                   	ret

0000000000002bc2 <vidclear>:
SYSCALL(vidclear)
    2bc2:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    2bc9:	49 89 ca             	mov    %rcx,%r10
    2bcc:	0f 05                	syscall
    2bce:	c3                   	ret

0000000000002bcf <vidputc>:
SYSCALL(vidputc)
    2bcf:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    2bd6:	49 89 ca             	mov    %rcx,%r10
    2bd9:	0f 05                	syscall
    2bdb:	c3                   	ret

0000000000002bdc <vidputs>:
SYSCALL(vidputs)
    2bdc:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    2be3:	49 89 ca             	mov    %rcx,%r10
    2be6:	0f 05                	syscall
    2be8:	c3                   	ret

0000000000002be9 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    2be9:	55                   	push   %rbp
    2bea:	48 89 e5             	mov    %rsp,%rbp
    2bed:	48 83 ec 10          	sub    $0x10,%rsp
    2bf1:	89 7d fc             	mov    %edi,-0x4(%rbp)
    2bf4:	89 f0                	mov    %esi,%eax
    2bf6:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    2bf9:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    2bfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2c00:	ba 01 00 00 00       	mov    $0x1,%edx
    2c05:	48 89 ce             	mov    %rcx,%rsi
    2c08:	89 c7                	mov    %eax,%edi
    2c0a:	48 b8 e5 2a 00 00 00 	movabs $0x2ae5,%rax
    2c11:	00 00 00 
    2c14:	ff d0                	call   *%rax
}
    2c16:	90                   	nop
    2c17:	c9                   	leave
    2c18:	c3                   	ret

0000000000002c19 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    2c19:	55                   	push   %rbp
    2c1a:	48 89 e5             	mov    %rsp,%rbp
    2c1d:	48 83 ec 20          	sub    $0x20,%rsp
    2c21:	89 7d ec             	mov    %edi,-0x14(%rbp)
    2c24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    2c28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2c2f:	eb 35                	jmp    2c66 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    2c31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    2c35:	48 c1 e8 3c          	shr    $0x3c,%rax
    2c39:	48 ba 40 37 00 00 00 	movabs $0x3740,%rdx
    2c40:	00 00 00 
    2c43:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    2c47:	0f be d0             	movsbl %al,%edx
    2c4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2c4d:	89 d6                	mov    %edx,%esi
    2c4f:	89 c7                	mov    %eax,%edi
    2c51:	48 b8 e9 2b 00 00 00 	movabs $0x2be9,%rax
    2c58:	00 00 00 
    2c5b:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    2c5d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2c61:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    2c66:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2c69:	83 f8 0f             	cmp    $0xf,%eax
    2c6c:	76 c3                	jbe    2c31 <print_x64+0x18>
}
    2c6e:	90                   	nop
    2c6f:	90                   	nop
    2c70:	c9                   	leave
    2c71:	c3                   	ret

0000000000002c72 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    2c72:	55                   	push   %rbp
    2c73:	48 89 e5             	mov    %rsp,%rbp
    2c76:	48 83 ec 20          	sub    $0x20,%rsp
    2c7a:	89 7d ec             	mov    %edi,-0x14(%rbp)
    2c7d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    2c80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2c87:	eb 36                	jmp    2cbf <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    2c89:	8b 45 e8             	mov    -0x18(%rbp),%eax
    2c8c:	c1 e8 1c             	shr    $0x1c,%eax
    2c8f:	89 c2                	mov    %eax,%edx
    2c91:	48 b8 40 37 00 00 00 	movabs $0x3740,%rax
    2c98:	00 00 00 
    2c9b:	89 d2                	mov    %edx,%edx
    2c9d:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    2ca1:	0f be d0             	movsbl %al,%edx
    2ca4:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2ca7:	89 d6                	mov    %edx,%esi
    2ca9:	89 c7                	mov    %eax,%edi
    2cab:	48 b8 e9 2b 00 00 00 	movabs $0x2be9,%rax
    2cb2:	00 00 00 
    2cb5:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    2cb7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2cbb:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    2cbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2cc2:	83 f8 07             	cmp    $0x7,%eax
    2cc5:	76 c2                	jbe    2c89 <print_x32+0x17>
}
    2cc7:	90                   	nop
    2cc8:	90                   	nop
    2cc9:	c9                   	leave
    2cca:	c3                   	ret

0000000000002ccb <print_d>:

  static void
print_d(int fd, int v)
{
    2ccb:	55                   	push   %rbp
    2ccc:	48 89 e5             	mov    %rsp,%rbp
    2ccf:	48 83 ec 30          	sub    $0x30,%rsp
    2cd3:	89 7d dc             	mov    %edi,-0x24(%rbp)
    2cd6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    2cd9:	8b 45 d8             	mov    -0x28(%rbp),%eax
    2cdc:	48 98                	cltq
    2cde:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    2ce2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    2ce6:	79 04                	jns    2cec <print_d+0x21>
    x = -x;
    2ce8:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    2cec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    2cf3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    2cf7:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    2cfe:	66 66 66 
    2d01:	48 89 c8             	mov    %rcx,%rax
    2d04:	48 f7 ea             	imul   %rdx
    2d07:	48 c1 fa 02          	sar    $0x2,%rdx
    2d0b:	48 89 c8             	mov    %rcx,%rax
    2d0e:	48 c1 f8 3f          	sar    $0x3f,%rax
    2d12:	48 29 c2             	sub    %rax,%rdx
    2d15:	48 89 d0             	mov    %rdx,%rax
    2d18:	48 c1 e0 02          	shl    $0x2,%rax
    2d1c:	48 01 d0             	add    %rdx,%rax
    2d1f:	48 01 c0             	add    %rax,%rax
    2d22:	48 29 c1             	sub    %rax,%rcx
    2d25:	48 89 ca             	mov    %rcx,%rdx
    2d28:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2d2b:	8d 48 01             	lea    0x1(%rax),%ecx
    2d2e:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    2d31:	48 b9 40 37 00 00 00 	movabs $0x3740,%rcx
    2d38:	00 00 00 
    2d3b:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    2d3f:	48 98                	cltq
    2d41:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    2d45:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    2d49:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    2d50:	66 66 66 
    2d53:	48 89 c8             	mov    %rcx,%rax
    2d56:	48 f7 ea             	imul   %rdx
    2d59:	48 89 d0             	mov    %rdx,%rax
    2d5c:	48 c1 f8 02          	sar    $0x2,%rax
    2d60:	48 c1 f9 3f          	sar    $0x3f,%rcx
    2d64:	48 89 ca             	mov    %rcx,%rdx
    2d67:	48 29 d0             	sub    %rdx,%rax
    2d6a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    2d6e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2d73:	0f 85 7a ff ff ff    	jne    2cf3 <print_d+0x28>

  if (v < 0)
    2d79:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    2d7d:	79 32                	jns    2db1 <print_d+0xe6>
    buf[i++] = '-';
    2d7f:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2d82:	8d 50 01             	lea    0x1(%rax),%edx
    2d85:	89 55 f4             	mov    %edx,-0xc(%rbp)
    2d88:	48 98                	cltq
    2d8a:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    2d8f:	eb 20                	jmp    2db1 <print_d+0xe6>
    putc(fd, buf[i]);
    2d91:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2d94:	48 98                	cltq
    2d96:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    2d9b:	0f be d0             	movsbl %al,%edx
    2d9e:	8b 45 dc             	mov    -0x24(%rbp),%eax
    2da1:	89 d6                	mov    %edx,%esi
    2da3:	89 c7                	mov    %eax,%edi
    2da5:	48 b8 e9 2b 00 00 00 	movabs $0x2be9,%rax
    2dac:	00 00 00 
    2daf:	ff d0                	call   *%rax
  while (--i >= 0)
    2db1:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    2db5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    2db9:	79 d6                	jns    2d91 <print_d+0xc6>
}
    2dbb:	90                   	nop
    2dbc:	90                   	nop
    2dbd:	c9                   	leave
    2dbe:	c3                   	ret

0000000000002dbf <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    2dbf:	55                   	push   %rbp
    2dc0:	48 89 e5             	mov    %rsp,%rbp
    2dc3:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    2dca:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    2dd0:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    2dd7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    2dde:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    2de5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    2dec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    2df3:	84 c0                	test   %al,%al
    2df5:	74 20                	je     2e17 <printf+0x58>
    2df7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    2dfb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    2dff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    2e03:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    2e07:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    2e0b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    2e0f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    2e13:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    2e17:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    2e1e:	00 00 00 
    2e21:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    2e28:	00 00 00 
    2e2b:	48 8d 45 10          	lea    0x10(%rbp),%rax
    2e2f:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    2e36:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    2e3d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    2e44:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    2e4b:	00 00 00 
    2e4e:	e9 60 03 00 00       	jmp    31b3 <printf+0x3f4>
    if (c != '%') {
    2e53:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    2e5a:	74 24                	je     2e80 <printf+0xc1>
      putc(fd, c);
    2e5c:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    2e62:	0f be d0             	movsbl %al,%edx
    2e65:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2e6b:	89 d6                	mov    %edx,%esi
    2e6d:	89 c7                	mov    %eax,%edi
    2e6f:	48 b8 e9 2b 00 00 00 	movabs $0x2be9,%rax
    2e76:	00 00 00 
    2e79:	ff d0                	call   *%rax
      continue;
    2e7b:	e9 2c 03 00 00       	jmp    31ac <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    2e80:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    2e87:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    2e8d:	48 63 d0             	movslq %eax,%rdx
    2e90:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    2e97:	48 01 d0             	add    %rdx,%rax
    2e9a:	0f b6 00             	movzbl (%rax),%eax
    2e9d:	0f be c0             	movsbl %al,%eax
    2ea0:	25 ff 00 00 00       	and    $0xff,%eax
    2ea5:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    2eab:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    2eb2:	0f 84 2e 03 00 00    	je     31e6 <printf+0x427>
      break;
    switch(c) {
    2eb8:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    2ebf:	0f 84 32 01 00 00    	je     2ff7 <printf+0x238>
    2ec5:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    2ecc:	0f 8f a1 02 00 00    	jg     3173 <printf+0x3b4>
    2ed2:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    2ed9:	0f 84 d4 01 00 00    	je     30b3 <printf+0x2f4>
    2edf:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    2ee6:	0f 8f 87 02 00 00    	jg     3173 <printf+0x3b4>
    2eec:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    2ef3:	0f 84 5b 01 00 00    	je     3054 <printf+0x295>
    2ef9:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    2f00:	0f 8f 6d 02 00 00    	jg     3173 <printf+0x3b4>
    2f06:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    2f0d:	0f 84 87 00 00 00    	je     2f9a <printf+0x1db>
    2f13:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    2f1a:	0f 8f 53 02 00 00    	jg     3173 <printf+0x3b4>
    2f20:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    2f27:	0f 84 2b 02 00 00    	je     3158 <printf+0x399>
    2f2d:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    2f34:	0f 85 39 02 00 00    	jne    3173 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    2f3a:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2f40:	83 f8 2f             	cmp    $0x2f,%eax
    2f43:	77 23                	ja     2f68 <printf+0x1a9>
    2f45:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2f4c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2f52:	89 d2                	mov    %edx,%edx
    2f54:	48 01 d0             	add    %rdx,%rax
    2f57:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2f5d:	83 c2 08             	add    $0x8,%edx
    2f60:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    2f66:	eb 12                	jmp    2f7a <printf+0x1bb>
    2f68:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2f6f:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2f73:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2f7a:	8b 00                	mov    (%rax),%eax
    2f7c:	0f be d0             	movsbl %al,%edx
    2f7f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2f85:	89 d6                	mov    %edx,%esi
    2f87:	89 c7                	mov    %eax,%edi
    2f89:	48 b8 e9 2b 00 00 00 	movabs $0x2be9,%rax
    2f90:	00 00 00 
    2f93:	ff d0                	call   *%rax
      break;
    2f95:	e9 12 02 00 00       	jmp    31ac <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    2f9a:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2fa0:	83 f8 2f             	cmp    $0x2f,%eax
    2fa3:	77 23                	ja     2fc8 <printf+0x209>
    2fa5:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2fac:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2fb2:	89 d2                	mov    %edx,%edx
    2fb4:	48 01 d0             	add    %rdx,%rax
    2fb7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2fbd:	83 c2 08             	add    $0x8,%edx
    2fc0:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    2fc6:	eb 12                	jmp    2fda <printf+0x21b>
    2fc8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2fcf:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2fd3:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2fda:	8b 10                	mov    (%rax),%edx
    2fdc:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2fe2:	89 d6                	mov    %edx,%esi
    2fe4:	89 c7                	mov    %eax,%edi
    2fe6:	48 b8 cb 2c 00 00 00 	movabs $0x2ccb,%rax
    2fed:	00 00 00 
    2ff0:	ff d0                	call   *%rax
      break;
    2ff2:	e9 b5 01 00 00       	jmp    31ac <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    2ff7:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2ffd:	83 f8 2f             	cmp    $0x2f,%eax
    3000:	77 23                	ja     3025 <printf+0x266>
    3002:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    3009:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    300f:	89 d2                	mov    %edx,%edx
    3011:	48 01 d0             	add    %rdx,%rax
    3014:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    301a:	83 c2 08             	add    $0x8,%edx
    301d:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    3023:	eb 12                	jmp    3037 <printf+0x278>
    3025:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    302c:	48 8d 50 08          	lea    0x8(%rax),%rdx
    3030:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    3037:	8b 10                	mov    (%rax),%edx
    3039:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    303f:	89 d6                	mov    %edx,%esi
    3041:	89 c7                	mov    %eax,%edi
    3043:	48 b8 72 2c 00 00 00 	movabs $0x2c72,%rax
    304a:	00 00 00 
    304d:	ff d0                	call   *%rax
      break;
    304f:	e9 58 01 00 00       	jmp    31ac <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    3054:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    305a:	83 f8 2f             	cmp    $0x2f,%eax
    305d:	77 23                	ja     3082 <printf+0x2c3>
    305f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    3066:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    306c:	89 d2                	mov    %edx,%edx
    306e:	48 01 d0             	add    %rdx,%rax
    3071:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    3077:	83 c2 08             	add    $0x8,%edx
    307a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    3080:	eb 12                	jmp    3094 <printf+0x2d5>
    3082:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    3089:	48 8d 50 08          	lea    0x8(%rax),%rdx
    308d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    3094:	48 8b 10             	mov    (%rax),%rdx
    3097:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    309d:	48 89 d6             	mov    %rdx,%rsi
    30a0:	89 c7                	mov    %eax,%edi
    30a2:	48 b8 19 2c 00 00 00 	movabs $0x2c19,%rax
    30a9:	00 00 00 
    30ac:	ff d0                	call   *%rax
      break;
    30ae:	e9 f9 00 00 00       	jmp    31ac <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    30b3:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    30b9:	83 f8 2f             	cmp    $0x2f,%eax
    30bc:	77 23                	ja     30e1 <printf+0x322>
    30be:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    30c5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    30cb:	89 d2                	mov    %edx,%edx
    30cd:	48 01 d0             	add    %rdx,%rax
    30d0:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    30d6:	83 c2 08             	add    $0x8,%edx
    30d9:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    30df:	eb 12                	jmp    30f3 <printf+0x334>
    30e1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    30e8:	48 8d 50 08          	lea    0x8(%rax),%rdx
    30ec:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    30f3:	48 8b 00             	mov    (%rax),%rax
    30f6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    30fd:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    3104:	00 
    3105:	75 41                	jne    3148 <printf+0x389>
        s = "(null)";
    3107:	48 b8 25 37 00 00 00 	movabs $0x3725,%rax
    310e:	00 00 00 
    3111:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    3118:	eb 2e                	jmp    3148 <printf+0x389>
        putc(fd, *(s++));
    311a:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    3121:	48 8d 50 01          	lea    0x1(%rax),%rdx
    3125:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    312c:	0f b6 00             	movzbl (%rax),%eax
    312f:	0f be d0             	movsbl %al,%edx
    3132:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    3138:	89 d6                	mov    %edx,%esi
    313a:	89 c7                	mov    %eax,%edi
    313c:	48 b8 e9 2b 00 00 00 	movabs $0x2be9,%rax
    3143:	00 00 00 
    3146:	ff d0                	call   *%rax
      while (*s)
    3148:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    314f:	0f b6 00             	movzbl (%rax),%eax
    3152:	84 c0                	test   %al,%al
    3154:	75 c4                	jne    311a <printf+0x35b>
      break;
    3156:	eb 54                	jmp    31ac <printf+0x3ed>
    case '%':
      putc(fd, '%');
    3158:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    315e:	be 25 00 00 00       	mov    $0x25,%esi
    3163:	89 c7                	mov    %eax,%edi
    3165:	48 b8 e9 2b 00 00 00 	movabs $0x2be9,%rax
    316c:	00 00 00 
    316f:	ff d0                	call   *%rax
      break;
    3171:	eb 39                	jmp    31ac <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    3173:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    3179:	be 25 00 00 00       	mov    $0x25,%esi
    317e:	89 c7                	mov    %eax,%edi
    3180:	48 b8 e9 2b 00 00 00 	movabs $0x2be9,%rax
    3187:	00 00 00 
    318a:	ff d0                	call   *%rax
      putc(fd, c);
    318c:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    3192:	0f be d0             	movsbl %al,%edx
    3195:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    319b:	89 d6                	mov    %edx,%esi
    319d:	89 c7                	mov    %eax,%edi
    319f:	48 b8 e9 2b 00 00 00 	movabs $0x2be9,%rax
    31a6:	00 00 00 
    31a9:	ff d0                	call   *%rax
      break;
    31ab:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    31ac:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    31b3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    31b9:	48 63 d0             	movslq %eax,%rdx
    31bc:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    31c3:	48 01 d0             	add    %rdx,%rax
    31c6:	0f b6 00             	movzbl (%rax),%eax
    31c9:	0f be c0             	movsbl %al,%eax
    31cc:	25 ff 00 00 00       	and    $0xff,%eax
    31d1:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    31d7:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    31de:	0f 85 6f fc ff ff    	jne    2e53 <printf+0x94>
    }
  }
}
    31e4:	eb 01                	jmp    31e7 <printf+0x428>
      break;
    31e6:	90                   	nop
}
    31e7:	90                   	nop
    31e8:	c9                   	leave
    31e9:	c3                   	ret

00000000000031ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    31ea:	55                   	push   %rbp
    31eb:	48 89 e5             	mov    %rsp,%rbp
    31ee:	48 83 ec 18          	sub    $0x18,%rsp
    31f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    31f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    31fa:	48 83 e8 10          	sub    $0x10,%rax
    31fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3202:	48 b8 90 3f 00 00 00 	movabs $0x3f90,%rax
    3209:	00 00 00 
    320c:	48 8b 00             	mov    (%rax),%rax
    320f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    3213:	eb 2f                	jmp    3244 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3215:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3219:	48 8b 00             	mov    (%rax),%rax
    321c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    3220:	72 17                	jb     3239 <free+0x4f>
    3222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    3226:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    322a:	72 2f                	jb     325b <free+0x71>
    322c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3230:	48 8b 00             	mov    (%rax),%rax
    3233:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    3237:	72 22                	jb     325b <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3239:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    323d:	48 8b 00             	mov    (%rax),%rax
    3240:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    3244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    3248:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    324c:	73 c7                	jae    3215 <free+0x2b>
    324e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3252:	48 8b 00             	mov    (%rax),%rax
    3255:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    3259:	73 ba                	jae    3215 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    325b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    325f:	8b 40 08             	mov    0x8(%rax),%eax
    3262:	89 c0                	mov    %eax,%eax
    3264:	48 c1 e0 04          	shl    $0x4,%rax
    3268:	48 89 c2             	mov    %rax,%rdx
    326b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    326f:	48 01 c2             	add    %rax,%rdx
    3272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3276:	48 8b 00             	mov    (%rax),%rax
    3279:	48 39 c2             	cmp    %rax,%rdx
    327c:	75 2d                	jne    32ab <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    327e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    3282:	8b 50 08             	mov    0x8(%rax),%edx
    3285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3289:	48 8b 00             	mov    (%rax),%rax
    328c:	8b 40 08             	mov    0x8(%rax),%eax
    328f:	01 c2                	add    %eax,%edx
    3291:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    3295:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    3298:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    329c:	48 8b 00             	mov    (%rax),%rax
    329f:	48 8b 10             	mov    (%rax),%rdx
    32a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    32a6:	48 89 10             	mov    %rdx,(%rax)
    32a9:	eb 0e                	jmp    32b9 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    32ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    32af:	48 8b 10             	mov    (%rax),%rdx
    32b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    32b6:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    32b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    32bd:	8b 40 08             	mov    0x8(%rax),%eax
    32c0:	89 c0                	mov    %eax,%eax
    32c2:	48 c1 e0 04          	shl    $0x4,%rax
    32c6:	48 89 c2             	mov    %rax,%rdx
    32c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    32cd:	48 01 d0             	add    %rdx,%rax
    32d0:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    32d4:	75 27                	jne    32fd <free+0x113>
    p->s.size += bp->s.size;
    32d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    32da:	8b 50 08             	mov    0x8(%rax),%edx
    32dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    32e1:	8b 40 08             	mov    0x8(%rax),%eax
    32e4:	01 c2                	add    %eax,%edx
    32e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    32ea:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    32ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    32f1:	48 8b 10             	mov    (%rax),%rdx
    32f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    32f8:	48 89 10             	mov    %rdx,(%rax)
    32fb:	eb 0b                	jmp    3308 <free+0x11e>
  } else
    p->s.ptr = bp;
    32fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3301:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    3305:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    3308:	48 ba 90 3f 00 00 00 	movabs $0x3f90,%rdx
    330f:	00 00 00 
    3312:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3316:	48 89 02             	mov    %rax,(%rdx)
}
    3319:	90                   	nop
    331a:	c9                   	leave
    331b:	c3                   	ret

000000000000331c <morecore>:

static Header*
morecore(uint nu)
{
    331c:	55                   	push   %rbp
    331d:	48 89 e5             	mov    %rsp,%rbp
    3320:	48 83 ec 20          	sub    $0x20,%rsp
    3324:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    3327:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    332e:	77 07                	ja     3337 <morecore+0x1b>
    nu = 4096;
    3330:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    3337:	8b 45 ec             	mov    -0x14(%rbp),%eax
    333a:	48 c1 e0 04          	shl    $0x4,%rax
    333e:	48 89 c7             	mov    %rax,%rdi
    3341:	48 b8 8e 2b 00 00 00 	movabs $0x2b8e,%rax
    3348:	00 00 00 
    334b:	ff d0                	call   *%rax
    334d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    3351:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    3356:	75 07                	jne    335f <morecore+0x43>
    return 0;
    3358:	b8 00 00 00 00       	mov    $0x0,%eax
    335d:	eb 36                	jmp    3395 <morecore+0x79>
  hp = (Header*)p;
    335f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3363:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    3367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    336b:	8b 55 ec             	mov    -0x14(%rbp),%edx
    336e:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    3371:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    3375:	48 83 c0 10          	add    $0x10,%rax
    3379:	48 89 c7             	mov    %rax,%rdi
    337c:	48 b8 ea 31 00 00 00 	movabs $0x31ea,%rax
    3383:	00 00 00 
    3386:	ff d0                	call   *%rax
  return freep;
    3388:	48 b8 90 3f 00 00 00 	movabs $0x3f90,%rax
    338f:	00 00 00 
    3392:	48 8b 00             	mov    (%rax),%rax
}
    3395:	c9                   	leave
    3396:	c3                   	ret

0000000000003397 <malloc>:

void*
malloc(uint nbytes)
{
    3397:	55                   	push   %rbp
    3398:	48 89 e5             	mov    %rsp,%rbp
    339b:	48 83 ec 30          	sub    $0x30,%rsp
    339f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    33a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
    33a5:	48 83 c0 0f          	add    $0xf,%rax
    33a9:	48 c1 e8 04          	shr    $0x4,%rax
    33ad:	83 c0 01             	add    $0x1,%eax
    33b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    33b3:	48 b8 90 3f 00 00 00 	movabs $0x3f90,%rax
    33ba:	00 00 00 
    33bd:	48 8b 00             	mov    (%rax),%rax
    33c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    33c4:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    33c9:	75 4a                	jne    3415 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    33cb:	48 b8 80 3f 00 00 00 	movabs $0x3f80,%rax
    33d2:	00 00 00 
    33d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    33d9:	48 ba 90 3f 00 00 00 	movabs $0x3f90,%rdx
    33e0:	00 00 00 
    33e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    33e7:	48 89 02             	mov    %rax,(%rdx)
    33ea:	48 b8 90 3f 00 00 00 	movabs $0x3f90,%rax
    33f1:	00 00 00 
    33f4:	48 8b 00             	mov    (%rax),%rax
    33f7:	48 ba 80 3f 00 00 00 	movabs $0x3f80,%rdx
    33fe:	00 00 00 
    3401:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    3404:	48 b8 80 3f 00 00 00 	movabs $0x3f80,%rax
    340b:	00 00 00 
    340e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3415:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    3419:	48 8b 00             	mov    (%rax),%rax
    341c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    3420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3424:	8b 40 08             	mov    0x8(%rax),%eax
    3427:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    342a:	72 65                	jb     3491 <malloc+0xfa>
      if(p->s.size == nunits)
    342c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3430:	8b 40 08             	mov    0x8(%rax),%eax
    3433:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    3436:	75 10                	jne    3448 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    3438:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    343c:	48 8b 10             	mov    (%rax),%rdx
    343f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    3443:	48 89 10             	mov    %rdx,(%rax)
    3446:	eb 2e                	jmp    3476 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    3448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    344c:	8b 40 08             	mov    0x8(%rax),%eax
    344f:	2b 45 ec             	sub    -0x14(%rbp),%eax
    3452:	89 c2                	mov    %eax,%edx
    3454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3458:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    345b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    345f:	8b 40 08             	mov    0x8(%rax),%eax
    3462:	89 c0                	mov    %eax,%eax
    3464:	48 c1 e0 04          	shl    $0x4,%rax
    3468:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    346c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3470:	8b 55 ec             	mov    -0x14(%rbp),%edx
    3473:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    3476:	48 ba 90 3f 00 00 00 	movabs $0x3f90,%rdx
    347d:	00 00 00 
    3480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    3484:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    3487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    348b:	48 83 c0 10          	add    $0x10,%rax
    348f:	eb 4e                	jmp    34df <malloc+0x148>
    }
    if(p == freep)
    3491:	48 b8 90 3f 00 00 00 	movabs $0x3f90,%rax
    3498:	00 00 00 
    349b:	48 8b 00             	mov    (%rax),%rax
    349e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    34a2:	75 23                	jne    34c7 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    34a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
    34a7:	89 c7                	mov    %eax,%edi
    34a9:	48 b8 1c 33 00 00 00 	movabs $0x331c,%rax
    34b0:	00 00 00 
    34b3:	ff d0                	call   *%rax
    34b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    34b9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    34be:	75 07                	jne    34c7 <malloc+0x130>
        return 0;
    34c0:	b8 00 00 00 00       	mov    $0x0,%eax
    34c5:	eb 18                	jmp    34df <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    34c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    34cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    34cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    34d3:	48 8b 00             	mov    (%rax),%rax
    34d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    34da:	e9 41 ff ff ff       	jmp    3420 <malloc+0x89>
  }
}
    34df:	c9                   	leave
    34e0:	c3                   	ret


_stressfs:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 81 ec 30 02 00 00 	sub    $0x230,%rsp
    100b:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
    1011:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
  int fd, i;
  char path[] = "stressfs0";
    1018:	48 b8 73 74 72 65 73 	movabs $0x7366737365727473,%rax
    101f:	73 66 73 
    1022:	48 89 45 ee          	mov    %rax,-0x12(%rbp)
    1026:	66 c7 45 f6 30 00    	movw   $0x30,-0xa(%rbp)
  char data[512];

  printf(1, "stressfs starting\n");
    102c:	48 b8 0f 1f 00 00 00 	movabs $0x1f0f,%rax
    1033:	00 00 00 
    1036:	48 89 c6             	mov    %rax,%rsi
    1039:	bf 01 00 00 00       	mov    $0x1,%edi
    103e:	b8 00 00 00 00       	mov    $0x0,%eax
    1043:	48 ba ed 17 00 00 00 	movabs $0x17ed,%rdx
    104a:	00 00 00 
    104d:	ff d2                	call   *%rdx
  memset(data, 'a', sizeof(data));
    104f:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
    1056:	ba 00 02 00 00       	mov    $0x200,%edx
    105b:	be 61 00 00 00       	mov    $0x61,%esi
    1060:	48 89 c7             	mov    %rax,%rdi
    1063:	48 b8 c2 12 00 00 00 	movabs $0x12c2,%rax
    106a:	00 00 00 
    106d:	ff d0                	call   *%rax

  for(i = 0; i < 4; i++)
    106f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1076:	eb 14                	jmp    108c <main+0x8c>
    if(fork() > 0)
    1078:	48 b8 d2 14 00 00 00 	movabs $0x14d2,%rax
    107f:	00 00 00 
    1082:	ff d0                	call   *%rax
    1084:	85 c0                	test   %eax,%eax
    1086:	7f 0c                	jg     1094 <main+0x94>
  for(i = 0; i < 4; i++)
    1088:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    108c:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
    1090:	7e e6                	jle    1078 <main+0x78>
    1092:	eb 01                	jmp    1095 <main+0x95>
      break;
    1094:	90                   	nop

  printf(1, "write %d\n", i);
    1095:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1098:	48 b9 22 1f 00 00 00 	movabs $0x1f22,%rcx
    109f:	00 00 00 
    10a2:	89 c2                	mov    %eax,%edx
    10a4:	48 89 ce             	mov    %rcx,%rsi
    10a7:	bf 01 00 00 00       	mov    $0x1,%edi
    10ac:	b8 00 00 00 00       	mov    $0x0,%eax
    10b1:	48 b9 ed 17 00 00 00 	movabs $0x17ed,%rcx
    10b8:	00 00 00 
    10bb:	ff d1                	call   *%rcx

  path[8] += i;
    10bd:	0f b6 45 f6          	movzbl -0xa(%rbp),%eax
    10c1:	89 c2                	mov    %eax,%edx
    10c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10c6:	01 d0                	add    %edx,%eax
    10c8:	88 45 f6             	mov    %al,-0xa(%rbp)
  fd = open(path, O_CREATE | O_RDWR);
    10cb:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    10cf:	be 02 02 00 00       	mov    $0x202,%esi
    10d4:	48 89 c7             	mov    %rax,%rdi
    10d7:	48 b8 47 15 00 00 00 	movabs $0x1547,%rax
    10de:	00 00 00 
    10e1:	ff d0                	call   *%rax
    10e3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for(i = 0; i < 20; i++)
    10e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    10ed:	eb 24                	jmp    1113 <main+0x113>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
    10ef:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
    10f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
    10f9:	ba 00 02 00 00       	mov    $0x200,%edx
    10fe:	48 89 ce             	mov    %rcx,%rsi
    1101:	89 c7                	mov    %eax,%edi
    1103:	48 b8 13 15 00 00 00 	movabs $0x1513,%rax
    110a:	00 00 00 
    110d:	ff d0                	call   *%rax
  for(i = 0; i < 20; i++)
    110f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1113:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    1117:	7e d6                	jle    10ef <main+0xef>
  close(fd);
    1119:	8b 45 f8             	mov    -0x8(%rbp),%eax
    111c:	89 c7                	mov    %eax,%edi
    111e:	48 b8 20 15 00 00 00 	movabs $0x1520,%rax
    1125:	00 00 00 
    1128:	ff d0                	call   *%rax

  printf(1, "read\n");
    112a:	48 b8 2c 1f 00 00 00 	movabs $0x1f2c,%rax
    1131:	00 00 00 
    1134:	48 89 c6             	mov    %rax,%rsi
    1137:	bf 01 00 00 00       	mov    $0x1,%edi
    113c:	b8 00 00 00 00       	mov    $0x0,%eax
    1141:	48 ba ed 17 00 00 00 	movabs $0x17ed,%rdx
    1148:	00 00 00 
    114b:	ff d2                	call   *%rdx

  fd = open(path, O_RDONLY);
    114d:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    1151:	be 00 00 00 00       	mov    $0x0,%esi
    1156:	48 89 c7             	mov    %rax,%rdi
    1159:	48 b8 47 15 00 00 00 	movabs $0x1547,%rax
    1160:	00 00 00 
    1163:	ff d0                	call   *%rax
    1165:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for (i = 0; i < 20; i++)
    1168:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    116f:	eb 24                	jmp    1195 <main+0x195>
    read(fd, data, sizeof(data));
    1171:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
    1178:	8b 45 f8             	mov    -0x8(%rbp),%eax
    117b:	ba 00 02 00 00       	mov    $0x200,%edx
    1180:	48 89 ce             	mov    %rcx,%rsi
    1183:	89 c7                	mov    %eax,%edi
    1185:	48 b8 06 15 00 00 00 	movabs $0x1506,%rax
    118c:	00 00 00 
    118f:	ff d0                	call   *%rax
  for (i = 0; i < 20; i++)
    1191:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1195:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    1199:	7e d6                	jle    1171 <main+0x171>
  close(fd);
    119b:	8b 45 f8             	mov    -0x8(%rbp),%eax
    119e:	89 c7                	mov    %eax,%edi
    11a0:	48 b8 20 15 00 00 00 	movabs $0x1520,%rax
    11a7:	00 00 00 
    11aa:	ff d0                	call   *%rax

  wait();
    11ac:	48 b8 ec 14 00 00 00 	movabs $0x14ec,%rax
    11b3:	00 00 00 
    11b6:	ff d0                	call   *%rax

  exit();
    11b8:	48 b8 df 14 00 00 00 	movabs $0x14df,%rax
    11bf:	00 00 00 
    11c2:	ff d0                	call   *%rax

00000000000011c4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11c4:	55                   	push   %rbp
    11c5:	48 89 e5             	mov    %rsp,%rbp
    11c8:	48 83 ec 10          	sub    $0x10,%rsp
    11cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11d0:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11d3:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    11d6:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    11da:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11e0:	48 89 ce             	mov    %rcx,%rsi
    11e3:	48 89 f7             	mov    %rsi,%rdi
    11e6:	89 d1                	mov    %edx,%ecx
    11e8:	fc                   	cld
    11e9:	f3 aa                	rep stos %al,(%rdi)
    11eb:	89 ca                	mov    %ecx,%edx
    11ed:	48 89 fe             	mov    %rdi,%rsi
    11f0:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11f4:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11f7:	90                   	nop
    11f8:	c9                   	leave
    11f9:	c3                   	ret

00000000000011fa <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11fa:	55                   	push   %rbp
    11fb:	48 89 e5             	mov    %rsp,%rbp
    11fe:	48 83 ec 20          	sub    $0x20,%rsp
    1202:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1206:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    120a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    120e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1212:	90                   	nop
    1213:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1217:	48 8d 42 01          	lea    0x1(%rdx),%rax
    121b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    121f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1223:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1227:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    122b:	0f b6 12             	movzbl (%rdx),%edx
    122e:	88 10                	mov    %dl,(%rax)
    1230:	0f b6 00             	movzbl (%rax),%eax
    1233:	84 c0                	test   %al,%al
    1235:	75 dc                	jne    1213 <strcpy+0x19>
    ;
  return os;
    1237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    123b:	c9                   	leave
    123c:	c3                   	ret

000000000000123d <strcmp>:

int
strcmp(const char *p, const char *q)
{
    123d:	55                   	push   %rbp
    123e:	48 89 e5             	mov    %rsp,%rbp
    1241:	48 83 ec 10          	sub    $0x10,%rsp
    1245:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1249:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    124d:	eb 0a                	jmp    1259 <strcmp+0x1c>
    p++, q++;
    124f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1254:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    125d:	0f b6 00             	movzbl (%rax),%eax
    1260:	84 c0                	test   %al,%al
    1262:	74 12                	je     1276 <strcmp+0x39>
    1264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1268:	0f b6 10             	movzbl (%rax),%edx
    126b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    126f:	0f b6 00             	movzbl (%rax),%eax
    1272:	38 c2                	cmp    %al,%dl
    1274:	74 d9                	je     124f <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    127a:	0f b6 00             	movzbl (%rax),%eax
    127d:	0f b6 d0             	movzbl %al,%edx
    1280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1284:	0f b6 00             	movzbl (%rax),%eax
    1287:	0f b6 c0             	movzbl %al,%eax
    128a:	29 c2                	sub    %eax,%edx
    128c:	89 d0                	mov    %edx,%eax
}
    128e:	c9                   	leave
    128f:	c3                   	ret

0000000000001290 <strlen>:

uint
strlen(char *s)
{
    1290:	55                   	push   %rbp
    1291:	48 89 e5             	mov    %rsp,%rbp
    1294:	48 83 ec 18          	sub    $0x18,%rsp
    1298:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    129c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12a3:	eb 04                	jmp    12a9 <strlen+0x19>
    12a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    12a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12ac:	48 63 d0             	movslq %eax,%rdx
    12af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12b3:	48 01 d0             	add    %rdx,%rax
    12b6:	0f b6 00             	movzbl (%rax),%eax
    12b9:	84 c0                	test   %al,%al
    12bb:	75 e8                	jne    12a5 <strlen+0x15>
    ;
  return n;
    12bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    12c0:	c9                   	leave
    12c1:	c3                   	ret

00000000000012c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
    12c2:	55                   	push   %rbp
    12c3:	48 89 e5             	mov    %rsp,%rbp
    12c6:	48 83 ec 10          	sub    $0x10,%rsp
    12ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12ce:	89 75 f4             	mov    %esi,-0xc(%rbp)
    12d1:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    12d4:	8b 55 f0             	mov    -0x10(%rbp),%edx
    12d7:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    12da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12de:	89 ce                	mov    %ecx,%esi
    12e0:	48 89 c7             	mov    %rax,%rdi
    12e3:	48 b8 c4 11 00 00 00 	movabs $0x11c4,%rax
    12ea:	00 00 00 
    12ed:	ff d0                	call   *%rax
  return dst;
    12ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12f3:	c9                   	leave
    12f4:	c3                   	ret

00000000000012f5 <strchr>:

char*
strchr(const char *s, char c)
{
    12f5:	55                   	push   %rbp
    12f6:	48 89 e5             	mov    %rsp,%rbp
    12f9:	48 83 ec 10          	sub    $0x10,%rsp
    12fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1301:	89 f0                	mov    %esi,%eax
    1303:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1306:	eb 17                	jmp    131f <strchr+0x2a>
    if(*s == c)
    1308:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    130c:	0f b6 00             	movzbl (%rax),%eax
    130f:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1312:	75 06                	jne    131a <strchr+0x25>
      return (char*)s;
    1314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1318:	eb 15                	jmp    132f <strchr+0x3a>
  for(; *s; s++)
    131a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    131f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1323:	0f b6 00             	movzbl (%rax),%eax
    1326:	84 c0                	test   %al,%al
    1328:	75 de                	jne    1308 <strchr+0x13>
  return 0;
    132a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    132f:	c9                   	leave
    1330:	c3                   	ret

0000000000001331 <gets>:

char*
gets(char *buf, int max)
{
    1331:	55                   	push   %rbp
    1332:	48 89 e5             	mov    %rsp,%rbp
    1335:	48 83 ec 20          	sub    $0x20,%rsp
    1339:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    133d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1340:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1347:	eb 4f                	jmp    1398 <gets+0x67>
    cc = read(0, &c, 1);
    1349:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    134d:	ba 01 00 00 00       	mov    $0x1,%edx
    1352:	48 89 c6             	mov    %rax,%rsi
    1355:	bf 00 00 00 00       	mov    $0x0,%edi
    135a:	48 b8 06 15 00 00 00 	movabs $0x1506,%rax
    1361:	00 00 00 
    1364:	ff d0                	call   *%rax
    1366:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1369:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    136d:	7e 36                	jle    13a5 <gets+0x74>
      break;
    buf[i++] = c;
    136f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1372:	8d 50 01             	lea    0x1(%rax),%edx
    1375:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1378:	48 63 d0             	movslq %eax,%rdx
    137b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    137f:	48 01 c2             	add    %rax,%rdx
    1382:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1386:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1388:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    138c:	3c 0a                	cmp    $0xa,%al
    138e:	74 16                	je     13a6 <gets+0x75>
    1390:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1394:	3c 0d                	cmp    $0xd,%al
    1396:	74 0e                	je     13a6 <gets+0x75>
  for(i=0; i+1 < max; ){
    1398:	8b 45 fc             	mov    -0x4(%rbp),%eax
    139b:	83 c0 01             	add    $0x1,%eax
    139e:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    13a1:	7f a6                	jg     1349 <gets+0x18>
    13a3:	eb 01                	jmp    13a6 <gets+0x75>
      break;
    13a5:	90                   	nop
      break;
  }
  buf[i] = '\0';
    13a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13a9:	48 63 d0             	movslq %eax,%rdx
    13ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13b0:	48 01 d0             	add    %rdx,%rax
    13b3:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    13b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13ba:	c9                   	leave
    13bb:	c3                   	ret

00000000000013bc <stat>:

int
stat(char *n, struct stat *st)
{
    13bc:	55                   	push   %rbp
    13bd:	48 89 e5             	mov    %rsp,%rbp
    13c0:	48 83 ec 20          	sub    $0x20,%rsp
    13c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13d0:	be 00 00 00 00       	mov    $0x0,%esi
    13d5:	48 89 c7             	mov    %rax,%rdi
    13d8:	48 b8 47 15 00 00 00 	movabs $0x1547,%rax
    13df:	00 00 00 
    13e2:	ff d0                	call   *%rax
    13e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    13e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    13eb:	79 07                	jns    13f4 <stat+0x38>
    return -1;
    13ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13f2:	eb 2f                	jmp    1423 <stat+0x67>
  r = fstat(fd, st);
    13f4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    13f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13fb:	48 89 d6             	mov    %rdx,%rsi
    13fe:	89 c7                	mov    %eax,%edi
    1400:	48 b8 6e 15 00 00 00 	movabs $0x156e,%rax
    1407:	00 00 00 
    140a:	ff d0                	call   *%rax
    140c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    140f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1412:	89 c7                	mov    %eax,%edi
    1414:	48 b8 20 15 00 00 00 	movabs $0x1520,%rax
    141b:	00 00 00 
    141e:	ff d0                	call   *%rax
  return r;
    1420:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1423:	c9                   	leave
    1424:	c3                   	ret

0000000000001425 <atoi>:

int
atoi(const char *s)
{
    1425:	55                   	push   %rbp
    1426:	48 89 e5             	mov    %rsp,%rbp
    1429:	48 83 ec 18          	sub    $0x18,%rsp
    142d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1431:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1438:	eb 28                	jmp    1462 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    143a:	8b 55 fc             	mov    -0x4(%rbp),%edx
    143d:	89 d0                	mov    %edx,%eax
    143f:	c1 e0 02             	shl    $0x2,%eax
    1442:	01 d0                	add    %edx,%eax
    1444:	01 c0                	add    %eax,%eax
    1446:	89 c1                	mov    %eax,%ecx
    1448:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    144c:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1450:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1454:	0f b6 00             	movzbl (%rax),%eax
    1457:	0f be c0             	movsbl %al,%eax
    145a:	01 c8                	add    %ecx,%eax
    145c:	83 e8 30             	sub    $0x30,%eax
    145f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1466:	0f b6 00             	movzbl (%rax),%eax
    1469:	3c 2f                	cmp    $0x2f,%al
    146b:	7e 0b                	jle    1478 <atoi+0x53>
    146d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1471:	0f b6 00             	movzbl (%rax),%eax
    1474:	3c 39                	cmp    $0x39,%al
    1476:	7e c2                	jle    143a <atoi+0x15>
  return n;
    1478:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    147b:	c9                   	leave
    147c:	c3                   	ret

000000000000147d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    147d:	55                   	push   %rbp
    147e:	48 89 e5             	mov    %rsp,%rbp
    1481:	48 83 ec 28          	sub    $0x28,%rsp
    1485:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1489:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    148d:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1490:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1494:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1498:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    149c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    14a0:	eb 1d                	jmp    14bf <memmove+0x42>
    *dst++ = *src++;
    14a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    14a6:	48 8d 42 01          	lea    0x1(%rdx),%rax
    14aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    14ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    14b2:	48 8d 48 01          	lea    0x1(%rax),%rcx
    14b6:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    14ba:	0f b6 12             	movzbl (%rdx),%edx
    14bd:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    14bf:	8b 45 dc             	mov    -0x24(%rbp),%eax
    14c2:	8d 50 ff             	lea    -0x1(%rax),%edx
    14c5:	89 55 dc             	mov    %edx,-0x24(%rbp)
    14c8:	85 c0                	test   %eax,%eax
    14ca:	7f d6                	jg     14a2 <memmove+0x25>
  return vdst;
    14cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14d0:	c9                   	leave
    14d1:	c3                   	ret

00000000000014d2 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14d2:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14d9:	49 89 ca             	mov    %rcx,%r10
    14dc:	0f 05                	syscall
    14de:	c3                   	ret

00000000000014df <exit>:
SYSCALL(exit)
    14df:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    14e6:	49 89 ca             	mov    %rcx,%r10
    14e9:	0f 05                	syscall
    14eb:	c3                   	ret

00000000000014ec <wait>:
SYSCALL(wait)
    14ec:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    14f3:	49 89 ca             	mov    %rcx,%r10
    14f6:	0f 05                	syscall
    14f8:	c3                   	ret

00000000000014f9 <pipe>:
SYSCALL(pipe)
    14f9:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1500:	49 89 ca             	mov    %rcx,%r10
    1503:	0f 05                	syscall
    1505:	c3                   	ret

0000000000001506 <read>:
SYSCALL(read)
    1506:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    150d:	49 89 ca             	mov    %rcx,%r10
    1510:	0f 05                	syscall
    1512:	c3                   	ret

0000000000001513 <write>:
SYSCALL(write)
    1513:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    151a:	49 89 ca             	mov    %rcx,%r10
    151d:	0f 05                	syscall
    151f:	c3                   	ret

0000000000001520 <close>:
SYSCALL(close)
    1520:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1527:	49 89 ca             	mov    %rcx,%r10
    152a:	0f 05                	syscall
    152c:	c3                   	ret

000000000000152d <kill>:
SYSCALL(kill)
    152d:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1534:	49 89 ca             	mov    %rcx,%r10
    1537:	0f 05                	syscall
    1539:	c3                   	ret

000000000000153a <exec>:
SYSCALL(exec)
    153a:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1541:	49 89 ca             	mov    %rcx,%r10
    1544:	0f 05                	syscall
    1546:	c3                   	ret

0000000000001547 <open>:
SYSCALL(open)
    1547:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    154e:	49 89 ca             	mov    %rcx,%r10
    1551:	0f 05                	syscall
    1553:	c3                   	ret

0000000000001554 <mknod>:
SYSCALL(mknod)
    1554:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    155b:	49 89 ca             	mov    %rcx,%r10
    155e:	0f 05                	syscall
    1560:	c3                   	ret

0000000000001561 <unlink>:
SYSCALL(unlink)
    1561:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1568:	49 89 ca             	mov    %rcx,%r10
    156b:	0f 05                	syscall
    156d:	c3                   	ret

000000000000156e <fstat>:
SYSCALL(fstat)
    156e:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1575:	49 89 ca             	mov    %rcx,%r10
    1578:	0f 05                	syscall
    157a:	c3                   	ret

000000000000157b <link>:
SYSCALL(link)
    157b:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1582:	49 89 ca             	mov    %rcx,%r10
    1585:	0f 05                	syscall
    1587:	c3                   	ret

0000000000001588 <mkdir>:
SYSCALL(mkdir)
    1588:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    158f:	49 89 ca             	mov    %rcx,%r10
    1592:	0f 05                	syscall
    1594:	c3                   	ret

0000000000001595 <chdir>:
SYSCALL(chdir)
    1595:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    159c:	49 89 ca             	mov    %rcx,%r10
    159f:	0f 05                	syscall
    15a1:	c3                   	ret

00000000000015a2 <dup>:
SYSCALL(dup)
    15a2:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    15a9:	49 89 ca             	mov    %rcx,%r10
    15ac:	0f 05                	syscall
    15ae:	c3                   	ret

00000000000015af <getpid>:
SYSCALL(getpid)
    15af:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    15b6:	49 89 ca             	mov    %rcx,%r10
    15b9:	0f 05                	syscall
    15bb:	c3                   	ret

00000000000015bc <sbrk>:
SYSCALL(sbrk)
    15bc:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    15c3:	49 89 ca             	mov    %rcx,%r10
    15c6:	0f 05                	syscall
    15c8:	c3                   	ret

00000000000015c9 <sleep>:
SYSCALL(sleep)
    15c9:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15d0:	49 89 ca             	mov    %rcx,%r10
    15d3:	0f 05                	syscall
    15d5:	c3                   	ret

00000000000015d6 <uptime>:
SYSCALL(uptime)
    15d6:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    15dd:	49 89 ca             	mov    %rcx,%r10
    15e0:	0f 05                	syscall
    15e2:	c3                   	ret

00000000000015e3 <traceread>:
SYSCALL(traceread)
    15e3:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    15ea:	49 89 ca             	mov    %rcx,%r10
    15ed:	0f 05                	syscall
    15ef:	c3                   	ret

00000000000015f0 <vidclear>:
SYSCALL(vidclear)
    15f0:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    15f7:	49 89 ca             	mov    %rcx,%r10
    15fa:	0f 05                	syscall
    15fc:	c3                   	ret

00000000000015fd <vidputc>:
SYSCALL(vidputc)
    15fd:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    1604:	49 89 ca             	mov    %rcx,%r10
    1607:	0f 05                	syscall
    1609:	c3                   	ret

000000000000160a <vidputs>:
SYSCALL(vidputs)
    160a:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    1611:	49 89 ca             	mov    %rcx,%r10
    1614:	0f 05                	syscall
    1616:	c3                   	ret

0000000000001617 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1617:	55                   	push   %rbp
    1618:	48 89 e5             	mov    %rsp,%rbp
    161b:	48 83 ec 10          	sub    $0x10,%rsp
    161f:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1622:	89 f0                	mov    %esi,%eax
    1624:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1627:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    162b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    162e:	ba 01 00 00 00       	mov    $0x1,%edx
    1633:	48 89 ce             	mov    %rcx,%rsi
    1636:	89 c7                	mov    %eax,%edi
    1638:	48 b8 13 15 00 00 00 	movabs $0x1513,%rax
    163f:	00 00 00 
    1642:	ff d0                	call   *%rax
}
    1644:	90                   	nop
    1645:	c9                   	leave
    1646:	c3                   	ret

0000000000001647 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1647:	55                   	push   %rbp
    1648:	48 89 e5             	mov    %rsp,%rbp
    164b:	48 83 ec 20          	sub    $0x20,%rsp
    164f:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1652:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1656:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    165d:	eb 35                	jmp    1694 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    165f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1663:	48 c1 e8 3c          	shr    $0x3c,%rax
    1667:	48 ba 40 1f 00 00 00 	movabs $0x1f40,%rdx
    166e:	00 00 00 
    1671:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1675:	0f be d0             	movsbl %al,%edx
    1678:	8b 45 ec             	mov    -0x14(%rbp),%eax
    167b:	89 d6                	mov    %edx,%esi
    167d:	89 c7                	mov    %eax,%edi
    167f:	48 b8 17 16 00 00 00 	movabs $0x1617,%rax
    1686:	00 00 00 
    1689:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    168b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    168f:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1694:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1697:	83 f8 0f             	cmp    $0xf,%eax
    169a:	76 c3                	jbe    165f <print_x64+0x18>
}
    169c:	90                   	nop
    169d:	90                   	nop
    169e:	c9                   	leave
    169f:	c3                   	ret

00000000000016a0 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    16a0:	55                   	push   %rbp
    16a1:	48 89 e5             	mov    %rsp,%rbp
    16a4:	48 83 ec 20          	sub    $0x20,%rsp
    16a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
    16ab:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    16b5:	eb 36                	jmp    16ed <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    16b7:	8b 45 e8             	mov    -0x18(%rbp),%eax
    16ba:	c1 e8 1c             	shr    $0x1c,%eax
    16bd:	89 c2                	mov    %eax,%edx
    16bf:	48 b8 40 1f 00 00 00 	movabs $0x1f40,%rax
    16c6:	00 00 00 
    16c9:	89 d2                	mov    %edx,%edx
    16cb:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    16cf:	0f be d0             	movsbl %al,%edx
    16d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16d5:	89 d6                	mov    %edx,%esi
    16d7:	89 c7                	mov    %eax,%edi
    16d9:	48 b8 17 16 00 00 00 	movabs $0x1617,%rax
    16e0:	00 00 00 
    16e3:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16e9:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    16ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16f0:	83 f8 07             	cmp    $0x7,%eax
    16f3:	76 c2                	jbe    16b7 <print_x32+0x17>
}
    16f5:	90                   	nop
    16f6:	90                   	nop
    16f7:	c9                   	leave
    16f8:	c3                   	ret

00000000000016f9 <print_d>:

  static void
print_d(int fd, int v)
{
    16f9:	55                   	push   %rbp
    16fa:	48 89 e5             	mov    %rsp,%rbp
    16fd:	48 83 ec 30          	sub    $0x30,%rsp
    1701:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1704:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1707:	8b 45 d8             	mov    -0x28(%rbp),%eax
    170a:	48 98                	cltq
    170c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1710:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1714:	79 04                	jns    171a <print_d+0x21>
    x = -x;
    1716:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    171a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1721:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1725:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    172c:	66 66 66 
    172f:	48 89 c8             	mov    %rcx,%rax
    1732:	48 f7 ea             	imul   %rdx
    1735:	48 c1 fa 02          	sar    $0x2,%rdx
    1739:	48 89 c8             	mov    %rcx,%rax
    173c:	48 c1 f8 3f          	sar    $0x3f,%rax
    1740:	48 29 c2             	sub    %rax,%rdx
    1743:	48 89 d0             	mov    %rdx,%rax
    1746:	48 c1 e0 02          	shl    $0x2,%rax
    174a:	48 01 d0             	add    %rdx,%rax
    174d:	48 01 c0             	add    %rax,%rax
    1750:	48 29 c1             	sub    %rax,%rcx
    1753:	48 89 ca             	mov    %rcx,%rdx
    1756:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1759:	8d 48 01             	lea    0x1(%rax),%ecx
    175c:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    175f:	48 b9 40 1f 00 00 00 	movabs $0x1f40,%rcx
    1766:	00 00 00 
    1769:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    176d:	48 98                	cltq
    176f:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1773:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1777:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    177e:	66 66 66 
    1781:	48 89 c8             	mov    %rcx,%rax
    1784:	48 f7 ea             	imul   %rdx
    1787:	48 89 d0             	mov    %rdx,%rax
    178a:	48 c1 f8 02          	sar    $0x2,%rax
    178e:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1792:	48 89 ca             	mov    %rcx,%rdx
    1795:	48 29 d0             	sub    %rdx,%rax
    1798:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    179c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    17a1:	0f 85 7a ff ff ff    	jne    1721 <print_d+0x28>

  if (v < 0)
    17a7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17ab:	79 32                	jns    17df <print_d+0xe6>
    buf[i++] = '-';
    17ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17b0:	8d 50 01             	lea    0x1(%rax),%edx
    17b3:	89 55 f4             	mov    %edx,-0xc(%rbp)
    17b6:	48 98                	cltq
    17b8:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    17bd:	eb 20                	jmp    17df <print_d+0xe6>
    putc(fd, buf[i]);
    17bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17c2:	48 98                	cltq
    17c4:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    17c9:	0f be d0             	movsbl %al,%edx
    17cc:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17cf:	89 d6                	mov    %edx,%esi
    17d1:	89 c7                	mov    %eax,%edi
    17d3:	48 b8 17 16 00 00 00 	movabs $0x1617,%rax
    17da:	00 00 00 
    17dd:	ff d0                	call   *%rax
  while (--i >= 0)
    17df:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    17e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    17e7:	79 d6                	jns    17bf <print_d+0xc6>
}
    17e9:	90                   	nop
    17ea:	90                   	nop
    17eb:	c9                   	leave
    17ec:	c3                   	ret

00000000000017ed <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    17ed:	55                   	push   %rbp
    17ee:	48 89 e5             	mov    %rsp,%rbp
    17f1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    17f8:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    17fe:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1805:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    180c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1813:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    181a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1821:	84 c0                	test   %al,%al
    1823:	74 20                	je     1845 <printf+0x58>
    1825:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1829:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    182d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1831:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1835:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1839:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    183d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1841:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1845:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    184c:	00 00 00 
    184f:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1856:	00 00 00 
    1859:	48 8d 45 10          	lea    0x10(%rbp),%rax
    185d:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1864:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    186b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1872:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1879:	00 00 00 
    187c:	e9 60 03 00 00       	jmp    1be1 <printf+0x3f4>
    if (c != '%') {
    1881:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1888:	74 24                	je     18ae <printf+0xc1>
      putc(fd, c);
    188a:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1890:	0f be d0             	movsbl %al,%edx
    1893:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1899:	89 d6                	mov    %edx,%esi
    189b:	89 c7                	mov    %eax,%edi
    189d:	48 b8 17 16 00 00 00 	movabs $0x1617,%rax
    18a4:	00 00 00 
    18a7:	ff d0                	call   *%rax
      continue;
    18a9:	e9 2c 03 00 00       	jmp    1bda <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    18ae:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    18b5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    18bb:	48 63 d0             	movslq %eax,%rdx
    18be:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    18c5:	48 01 d0             	add    %rdx,%rax
    18c8:	0f b6 00             	movzbl (%rax),%eax
    18cb:	0f be c0             	movsbl %al,%eax
    18ce:	25 ff 00 00 00       	and    $0xff,%eax
    18d3:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    18d9:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    18e0:	0f 84 2e 03 00 00    	je     1c14 <printf+0x427>
      break;
    switch(c) {
    18e6:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    18ed:	0f 84 32 01 00 00    	je     1a25 <printf+0x238>
    18f3:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    18fa:	0f 8f a1 02 00 00    	jg     1ba1 <printf+0x3b4>
    1900:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1907:	0f 84 d4 01 00 00    	je     1ae1 <printf+0x2f4>
    190d:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1914:	0f 8f 87 02 00 00    	jg     1ba1 <printf+0x3b4>
    191a:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1921:	0f 84 5b 01 00 00    	je     1a82 <printf+0x295>
    1927:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    192e:	0f 8f 6d 02 00 00    	jg     1ba1 <printf+0x3b4>
    1934:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    193b:	0f 84 87 00 00 00    	je     19c8 <printf+0x1db>
    1941:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1948:	0f 8f 53 02 00 00    	jg     1ba1 <printf+0x3b4>
    194e:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1955:	0f 84 2b 02 00 00    	je     1b86 <printf+0x399>
    195b:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1962:	0f 85 39 02 00 00    	jne    1ba1 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    1968:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    196e:	83 f8 2f             	cmp    $0x2f,%eax
    1971:	77 23                	ja     1996 <printf+0x1a9>
    1973:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    197a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1980:	89 d2                	mov    %edx,%edx
    1982:	48 01 d0             	add    %rdx,%rax
    1985:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    198b:	83 c2 08             	add    $0x8,%edx
    198e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1994:	eb 12                	jmp    19a8 <printf+0x1bb>
    1996:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    199d:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19a1:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19a8:	8b 00                	mov    (%rax),%eax
    19aa:	0f be d0             	movsbl %al,%edx
    19ad:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19b3:	89 d6                	mov    %edx,%esi
    19b5:	89 c7                	mov    %eax,%edi
    19b7:	48 b8 17 16 00 00 00 	movabs $0x1617,%rax
    19be:	00 00 00 
    19c1:	ff d0                	call   *%rax
      break;
    19c3:	e9 12 02 00 00       	jmp    1bda <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    19c8:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19ce:	83 f8 2f             	cmp    $0x2f,%eax
    19d1:	77 23                	ja     19f6 <printf+0x209>
    19d3:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19da:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19e0:	89 d2                	mov    %edx,%edx
    19e2:	48 01 d0             	add    %rdx,%rax
    19e5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19eb:	83 c2 08             	add    $0x8,%edx
    19ee:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19f4:	eb 12                	jmp    1a08 <printf+0x21b>
    19f6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19fd:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a01:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a08:	8b 10                	mov    (%rax),%edx
    1a0a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a10:	89 d6                	mov    %edx,%esi
    1a12:	89 c7                	mov    %eax,%edi
    1a14:	48 b8 f9 16 00 00 00 	movabs $0x16f9,%rax
    1a1b:	00 00 00 
    1a1e:	ff d0                	call   *%rax
      break;
    1a20:	e9 b5 01 00 00       	jmp    1bda <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1a25:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a2b:	83 f8 2f             	cmp    $0x2f,%eax
    1a2e:	77 23                	ja     1a53 <printf+0x266>
    1a30:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a37:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a3d:	89 d2                	mov    %edx,%edx
    1a3f:	48 01 d0             	add    %rdx,%rax
    1a42:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a48:	83 c2 08             	add    $0x8,%edx
    1a4b:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a51:	eb 12                	jmp    1a65 <printf+0x278>
    1a53:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a5a:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a5e:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a65:	8b 10                	mov    (%rax),%edx
    1a67:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a6d:	89 d6                	mov    %edx,%esi
    1a6f:	89 c7                	mov    %eax,%edi
    1a71:	48 b8 a0 16 00 00 00 	movabs $0x16a0,%rax
    1a78:	00 00 00 
    1a7b:	ff d0                	call   *%rax
      break;
    1a7d:	e9 58 01 00 00       	jmp    1bda <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a82:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a88:	83 f8 2f             	cmp    $0x2f,%eax
    1a8b:	77 23                	ja     1ab0 <printf+0x2c3>
    1a8d:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a94:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a9a:	89 d2                	mov    %edx,%edx
    1a9c:	48 01 d0             	add    %rdx,%rax
    1a9f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1aa5:	83 c2 08             	add    $0x8,%edx
    1aa8:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1aae:	eb 12                	jmp    1ac2 <printf+0x2d5>
    1ab0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ab7:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1abb:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ac2:	48 8b 10             	mov    (%rax),%rdx
    1ac5:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1acb:	48 89 d6             	mov    %rdx,%rsi
    1ace:	89 c7                	mov    %eax,%edi
    1ad0:	48 b8 47 16 00 00 00 	movabs $0x1647,%rax
    1ad7:	00 00 00 
    1ada:	ff d0                	call   *%rax
      break;
    1adc:	e9 f9 00 00 00       	jmp    1bda <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1ae1:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ae7:	83 f8 2f             	cmp    $0x2f,%eax
    1aea:	77 23                	ja     1b0f <printf+0x322>
    1aec:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1af3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1af9:	89 d2                	mov    %edx,%edx
    1afb:	48 01 d0             	add    %rdx,%rax
    1afe:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b04:	83 c2 08             	add    $0x8,%edx
    1b07:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b0d:	eb 12                	jmp    1b21 <printf+0x334>
    1b0f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b16:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b1a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b21:	48 8b 00             	mov    (%rax),%rax
    1b24:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1b2b:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1b32:	00 
    1b33:	75 41                	jne    1b76 <printf+0x389>
        s = "(null)";
    1b35:	48 b8 32 1f 00 00 00 	movabs $0x1f32,%rax
    1b3c:	00 00 00 
    1b3f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1b46:	eb 2e                	jmp    1b76 <printf+0x389>
        putc(fd, *(s++));
    1b48:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b4f:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1b53:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1b5a:	0f b6 00             	movzbl (%rax),%eax
    1b5d:	0f be d0             	movsbl %al,%edx
    1b60:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b66:	89 d6                	mov    %edx,%esi
    1b68:	89 c7                	mov    %eax,%edi
    1b6a:	48 b8 17 16 00 00 00 	movabs $0x1617,%rax
    1b71:	00 00 00 
    1b74:	ff d0                	call   *%rax
      while (*s)
    1b76:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b7d:	0f b6 00             	movzbl (%rax),%eax
    1b80:	84 c0                	test   %al,%al
    1b82:	75 c4                	jne    1b48 <printf+0x35b>
      break;
    1b84:	eb 54                	jmp    1bda <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1b86:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b8c:	be 25 00 00 00       	mov    $0x25,%esi
    1b91:	89 c7                	mov    %eax,%edi
    1b93:	48 b8 17 16 00 00 00 	movabs $0x1617,%rax
    1b9a:	00 00 00 
    1b9d:	ff d0                	call   *%rax
      break;
    1b9f:	eb 39                	jmp    1bda <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1ba1:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ba7:	be 25 00 00 00       	mov    $0x25,%esi
    1bac:	89 c7                	mov    %eax,%edi
    1bae:	48 b8 17 16 00 00 00 	movabs $0x1617,%rax
    1bb5:	00 00 00 
    1bb8:	ff d0                	call   *%rax
      putc(fd, c);
    1bba:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1bc0:	0f be d0             	movsbl %al,%edx
    1bc3:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1bc9:	89 d6                	mov    %edx,%esi
    1bcb:	89 c7                	mov    %eax,%edi
    1bcd:	48 b8 17 16 00 00 00 	movabs $0x1617,%rax
    1bd4:	00 00 00 
    1bd7:	ff d0                	call   *%rax
      break;
    1bd9:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1bda:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1be1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1be7:	48 63 d0             	movslq %eax,%rdx
    1bea:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bf1:	48 01 d0             	add    %rdx,%rax
    1bf4:	0f b6 00             	movzbl (%rax),%eax
    1bf7:	0f be c0             	movsbl %al,%eax
    1bfa:	25 ff 00 00 00       	and    $0xff,%eax
    1bff:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1c05:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1c0c:	0f 85 6f fc ff ff    	jne    1881 <printf+0x94>
    }
  }
}
    1c12:	eb 01                	jmp    1c15 <printf+0x428>
      break;
    1c14:	90                   	nop
}
    1c15:	90                   	nop
    1c16:	c9                   	leave
    1c17:	c3                   	ret

0000000000001c18 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1c18:	55                   	push   %rbp
    1c19:	48 89 e5             	mov    %rsp,%rbp
    1c1c:	48 83 ec 18          	sub    $0x18,%rsp
    1c20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1c24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c28:	48 83 e8 10          	sub    $0x10,%rax
    1c2c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c30:	48 b8 70 1f 00 00 00 	movabs $0x1f70,%rax
    1c37:	00 00 00 
    1c3a:	48 8b 00             	mov    (%rax),%rax
    1c3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c41:	eb 2f                	jmp    1c72 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1c43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c47:	48 8b 00             	mov    (%rax),%rax
    1c4a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c4e:	72 17                	jb     1c67 <free+0x4f>
    1c50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c54:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c58:	72 2f                	jb     1c89 <free+0x71>
    1c5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c5e:	48 8b 00             	mov    (%rax),%rax
    1c61:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c65:	72 22                	jb     1c89 <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c6b:	48 8b 00             	mov    (%rax),%rax
    1c6e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c76:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c7a:	73 c7                	jae    1c43 <free+0x2b>
    1c7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c80:	48 8b 00             	mov    (%rax),%rax
    1c83:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c87:	73 ba                	jae    1c43 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c8d:	8b 40 08             	mov    0x8(%rax),%eax
    1c90:	89 c0                	mov    %eax,%eax
    1c92:	48 c1 e0 04          	shl    $0x4,%rax
    1c96:	48 89 c2             	mov    %rax,%rdx
    1c99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c9d:	48 01 c2             	add    %rax,%rdx
    1ca0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ca4:	48 8b 00             	mov    (%rax),%rax
    1ca7:	48 39 c2             	cmp    %rax,%rdx
    1caa:	75 2d                	jne    1cd9 <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1cac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cb0:	8b 50 08             	mov    0x8(%rax),%edx
    1cb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb7:	48 8b 00             	mov    (%rax),%rax
    1cba:	8b 40 08             	mov    0x8(%rax),%eax
    1cbd:	01 c2                	add    %eax,%edx
    1cbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc3:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1cc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cca:	48 8b 00             	mov    (%rax),%rax
    1ccd:	48 8b 10             	mov    (%rax),%rdx
    1cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cd4:	48 89 10             	mov    %rdx,(%rax)
    1cd7:	eb 0e                	jmp    1ce7 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1cd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cdd:	48 8b 10             	mov    (%rax),%rdx
    1ce0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ce4:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1ce7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ceb:	8b 40 08             	mov    0x8(%rax),%eax
    1cee:	89 c0                	mov    %eax,%eax
    1cf0:	48 c1 e0 04          	shl    $0x4,%rax
    1cf4:	48 89 c2             	mov    %rax,%rdx
    1cf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cfb:	48 01 d0             	add    %rdx,%rax
    1cfe:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d02:	75 27                	jne    1d2b <free+0x113>
    p->s.size += bp->s.size;
    1d04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d08:	8b 50 08             	mov    0x8(%rax),%edx
    1d0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d0f:	8b 40 08             	mov    0x8(%rax),%eax
    1d12:	01 c2                	add    %eax,%edx
    1d14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d18:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1d1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d1f:	48 8b 10             	mov    (%rax),%rdx
    1d22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d26:	48 89 10             	mov    %rdx,(%rax)
    1d29:	eb 0b                	jmp    1d36 <free+0x11e>
  } else
    p->s.ptr = bp;
    1d2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1d33:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1d36:	48 ba 70 1f 00 00 00 	movabs $0x1f70,%rdx
    1d3d:	00 00 00 
    1d40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d44:	48 89 02             	mov    %rax,(%rdx)
}
    1d47:	90                   	nop
    1d48:	c9                   	leave
    1d49:	c3                   	ret

0000000000001d4a <morecore>:

static Header*
morecore(uint nu)
{
    1d4a:	55                   	push   %rbp
    1d4b:	48 89 e5             	mov    %rsp,%rbp
    1d4e:	48 83 ec 20          	sub    $0x20,%rsp
    1d52:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1d55:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1d5c:	77 07                	ja     1d65 <morecore+0x1b>
    nu = 4096;
    1d5e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d65:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d68:	48 c1 e0 04          	shl    $0x4,%rax
    1d6c:	48 89 c7             	mov    %rax,%rdi
    1d6f:	48 b8 bc 15 00 00 00 	movabs $0x15bc,%rax
    1d76:	00 00 00 
    1d79:	ff d0                	call   *%rax
    1d7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d7f:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d84:	75 07                	jne    1d8d <morecore+0x43>
    return 0;
    1d86:	b8 00 00 00 00       	mov    $0x0,%eax
    1d8b:	eb 36                	jmp    1dc3 <morecore+0x79>
  hp = (Header*)p;
    1d8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d91:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d99:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d9c:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1da3:	48 83 c0 10          	add    $0x10,%rax
    1da7:	48 89 c7             	mov    %rax,%rdi
    1daa:	48 b8 18 1c 00 00 00 	movabs $0x1c18,%rax
    1db1:	00 00 00 
    1db4:	ff d0                	call   *%rax
  return freep;
    1db6:	48 b8 70 1f 00 00 00 	movabs $0x1f70,%rax
    1dbd:	00 00 00 
    1dc0:	48 8b 00             	mov    (%rax),%rax
}
    1dc3:	c9                   	leave
    1dc4:	c3                   	ret

0000000000001dc5 <malloc>:

void*
malloc(uint nbytes)
{
    1dc5:	55                   	push   %rbp
    1dc6:	48 89 e5             	mov    %rsp,%rbp
    1dc9:	48 83 ec 30          	sub    $0x30,%rsp
    1dcd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1dd0:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1dd3:	48 83 c0 0f          	add    $0xf,%rax
    1dd7:	48 c1 e8 04          	shr    $0x4,%rax
    1ddb:	83 c0 01             	add    $0x1,%eax
    1dde:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1de1:	48 b8 70 1f 00 00 00 	movabs $0x1f70,%rax
    1de8:	00 00 00 
    1deb:	48 8b 00             	mov    (%rax),%rax
    1dee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1df2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1df7:	75 4a                	jne    1e43 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1df9:	48 b8 60 1f 00 00 00 	movabs $0x1f60,%rax
    1e00:	00 00 00 
    1e03:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e07:	48 ba 70 1f 00 00 00 	movabs $0x1f70,%rdx
    1e0e:	00 00 00 
    1e11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e15:	48 89 02             	mov    %rax,(%rdx)
    1e18:	48 b8 70 1f 00 00 00 	movabs $0x1f70,%rax
    1e1f:	00 00 00 
    1e22:	48 8b 00             	mov    (%rax),%rax
    1e25:	48 ba 60 1f 00 00 00 	movabs $0x1f60,%rdx
    1e2c:	00 00 00 
    1e2f:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1e32:	48 b8 60 1f 00 00 00 	movabs $0x1f60,%rax
    1e39:	00 00 00 
    1e3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e47:	48 8b 00             	mov    (%rax),%rax
    1e4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e52:	8b 40 08             	mov    0x8(%rax),%eax
    1e55:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1e58:	72 65                	jb     1ebf <malloc+0xfa>
      if(p->s.size == nunits)
    1e5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e5e:	8b 40 08             	mov    0x8(%rax),%eax
    1e61:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e64:	75 10                	jne    1e76 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1e66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e6a:	48 8b 10             	mov    (%rax),%rdx
    1e6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e71:	48 89 10             	mov    %rdx,(%rax)
    1e74:	eb 2e                	jmp    1ea4 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1e76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e7a:	8b 40 08             	mov    0x8(%rax),%eax
    1e7d:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e80:	89 c2                	mov    %eax,%edx
    1e82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e86:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e8d:	8b 40 08             	mov    0x8(%rax),%eax
    1e90:	89 c0                	mov    %eax,%eax
    1e92:	48 c1 e0 04          	shl    $0x4,%rax
    1e96:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e9e:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1ea1:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1ea4:	48 ba 70 1f 00 00 00 	movabs $0x1f70,%rdx
    1eab:	00 00 00 
    1eae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1eb2:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1eb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1eb9:	48 83 c0 10          	add    $0x10,%rax
    1ebd:	eb 4e                	jmp    1f0d <malloc+0x148>
    }
    if(p == freep)
    1ebf:	48 b8 70 1f 00 00 00 	movabs $0x1f70,%rax
    1ec6:	00 00 00 
    1ec9:	48 8b 00             	mov    (%rax),%rax
    1ecc:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ed0:	75 23                	jne    1ef5 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1ed2:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ed5:	89 c7                	mov    %eax,%edi
    1ed7:	48 b8 4a 1d 00 00 00 	movabs $0x1d4a,%rax
    1ede:	00 00 00 
    1ee1:	ff d0                	call   *%rax
    1ee3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ee7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1eec:	75 07                	jne    1ef5 <malloc+0x130>
        return 0;
    1eee:	b8 00 00 00 00       	mov    $0x0,%eax
    1ef3:	eb 18                	jmp    1f0d <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ef5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ef9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1efd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f01:	48 8b 00             	mov    (%rax),%rax
    1f04:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1f08:	e9 41 ff ff ff       	jmp    1e4e <malloc+0x89>
  }
}
    1f0d:	c9                   	leave
    1f0e:	c3                   	ret

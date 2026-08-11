
_syscalltest:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 10          	sub    $0x10,%rsp
    1008:	89 7d fc             	mov    %edi,-0x4(%rbp)
    100b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  printf(1, "syscalltest: starting\n");
    100f:	48 b8 0a 1e 00 00 00 	movabs $0x1e0a,%rax
    1016:	00 00 00 
    1019:	48 89 c6             	mov    %rax,%rsi
    101c:	bf 01 00 00 00       	mov    $0x1,%edi
    1021:	b8 00 00 00 00       	mov    $0x0,%eax
    1026:	48 ba e8 16 00 00 00 	movabs $0x16e8,%rdx
    102d:	00 00 00 
    1030:	ff d2                	call   *%rdx
  getpid();
    1032:	48 b8 aa 14 00 00 00 	movabs $0x14aa,%rax
    1039:	00 00 00 
    103c:	ff d0                	call   *%rax
  write(1, "hello\n", 6);
    103e:	48 b8 21 1e 00 00 00 	movabs $0x1e21,%rax
    1045:	00 00 00 
    1048:	ba 06 00 00 00       	mov    $0x6,%edx
    104d:	48 89 c6             	mov    %rax,%rsi
    1050:	bf 01 00 00 00       	mov    $0x1,%edi
    1055:	48 b8 0e 14 00 00 00 	movabs $0x140e,%rax
    105c:	00 00 00 
    105f:	ff d0                	call   *%rax
  open("nonexistentfile", 0);
    1061:	48 b8 28 1e 00 00 00 	movabs $0x1e28,%rax
    1068:	00 00 00 
    106b:	be 00 00 00 00       	mov    $0x0,%esi
    1070:	48 89 c7             	mov    %rax,%rdi
    1073:	48 b8 42 14 00 00 00 	movabs $0x1442,%rax
    107a:	00 00 00 
    107d:	ff d0                	call   *%rax
  sleep(10);
    107f:	bf 0a 00 00 00       	mov    $0xa,%edi
    1084:	48 b8 c4 14 00 00 00 	movabs $0x14c4,%rax
    108b:	00 00 00 
    108e:	ff d0                	call   *%rax
  printf(1, "syscalltest: done\n");
    1090:	48 b8 38 1e 00 00 00 	movabs $0x1e38,%rax
    1097:	00 00 00 
    109a:	48 89 c6             	mov    %rax,%rsi
    109d:	bf 01 00 00 00       	mov    $0x1,%edi
    10a2:	b8 00 00 00 00       	mov    $0x0,%eax
    10a7:	48 ba e8 16 00 00 00 	movabs $0x16e8,%rdx
    10ae:	00 00 00 
    10b1:	ff d2                	call   *%rdx
  exit();
    10b3:	48 b8 da 13 00 00 00 	movabs $0x13da,%rax
    10ba:	00 00 00 
    10bd:	ff d0                	call   *%rax

00000000000010bf <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10bf:	55                   	push   %rbp
    10c0:	48 89 e5             	mov    %rsp,%rbp
    10c3:	48 83 ec 10          	sub    $0x10,%rsp
    10c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10cb:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10ce:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10d1:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10d5:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10db:	48 89 ce             	mov    %rcx,%rsi
    10de:	48 89 f7             	mov    %rsi,%rdi
    10e1:	89 d1                	mov    %edx,%ecx
    10e3:	fc                   	cld
    10e4:	f3 aa                	rep stos %al,(%rdi)
    10e6:	89 ca                	mov    %ecx,%edx
    10e8:	48 89 fe             	mov    %rdi,%rsi
    10eb:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10ef:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10f2:	90                   	nop
    10f3:	c9                   	leave
    10f4:	c3                   	ret

00000000000010f5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10f5:	55                   	push   %rbp
    10f6:	48 89 e5             	mov    %rsp,%rbp
    10f9:	48 83 ec 20          	sub    $0x20,%rsp
    10fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1101:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1105:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1109:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    110d:	90                   	nop
    110e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1112:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1116:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    111e:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1122:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1126:	0f b6 12             	movzbl (%rdx),%edx
    1129:	88 10                	mov    %dl,(%rax)
    112b:	0f b6 00             	movzbl (%rax),%eax
    112e:	84 c0                	test   %al,%al
    1130:	75 dc                	jne    110e <strcpy+0x19>
    ;
  return os;
    1132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1136:	c9                   	leave
    1137:	c3                   	ret

0000000000001138 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1138:	55                   	push   %rbp
    1139:	48 89 e5             	mov    %rsp,%rbp
    113c:	48 83 ec 10          	sub    $0x10,%rsp
    1140:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1144:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1148:	eb 0a                	jmp    1154 <strcmp+0x1c>
    p++, q++;
    114a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    114f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1154:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1158:	0f b6 00             	movzbl (%rax),%eax
    115b:	84 c0                	test   %al,%al
    115d:	74 12                	je     1171 <strcmp+0x39>
    115f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1163:	0f b6 10             	movzbl (%rax),%edx
    1166:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    116a:	0f b6 00             	movzbl (%rax),%eax
    116d:	38 c2                	cmp    %al,%dl
    116f:	74 d9                	je     114a <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1171:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1175:	0f b6 00             	movzbl (%rax),%eax
    1178:	0f b6 d0             	movzbl %al,%edx
    117b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    117f:	0f b6 00             	movzbl (%rax),%eax
    1182:	0f b6 c0             	movzbl %al,%eax
    1185:	29 c2                	sub    %eax,%edx
    1187:	89 d0                	mov    %edx,%eax
}
    1189:	c9                   	leave
    118a:	c3                   	ret

000000000000118b <strlen>:

uint
strlen(char *s)
{
    118b:	55                   	push   %rbp
    118c:	48 89 e5             	mov    %rsp,%rbp
    118f:	48 83 ec 18          	sub    $0x18,%rsp
    1193:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1197:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    119e:	eb 04                	jmp    11a4 <strlen+0x19>
    11a0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11a7:	48 63 d0             	movslq %eax,%rdx
    11aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11ae:	48 01 d0             	add    %rdx,%rax
    11b1:	0f b6 00             	movzbl (%rax),%eax
    11b4:	84 c0                	test   %al,%al
    11b6:	75 e8                	jne    11a0 <strlen+0x15>
    ;
  return n;
    11b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11bb:	c9                   	leave
    11bc:	c3                   	ret

00000000000011bd <memset>:

void*
memset(void *dst, int c, uint n)
{
    11bd:	55                   	push   %rbp
    11be:	48 89 e5             	mov    %rsp,%rbp
    11c1:	48 83 ec 10          	sub    $0x10,%rsp
    11c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11c9:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11cc:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11cf:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11d2:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11d9:	89 ce                	mov    %ecx,%esi
    11db:	48 89 c7             	mov    %rax,%rdi
    11de:	48 b8 bf 10 00 00 00 	movabs $0x10bf,%rax
    11e5:	00 00 00 
    11e8:	ff d0                	call   *%rax
  return dst;
    11ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11ee:	c9                   	leave
    11ef:	c3                   	ret

00000000000011f0 <strchr>:

char*
strchr(const char *s, char c)
{
    11f0:	55                   	push   %rbp
    11f1:	48 89 e5             	mov    %rsp,%rbp
    11f4:	48 83 ec 10          	sub    $0x10,%rsp
    11f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11fc:	89 f0                	mov    %esi,%eax
    11fe:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1201:	eb 17                	jmp    121a <strchr+0x2a>
    if(*s == c)
    1203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1207:	0f b6 00             	movzbl (%rax),%eax
    120a:	38 45 f4             	cmp    %al,-0xc(%rbp)
    120d:	75 06                	jne    1215 <strchr+0x25>
      return (char*)s;
    120f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1213:	eb 15                	jmp    122a <strchr+0x3a>
  for(; *s; s++)
    1215:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    121a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    121e:	0f b6 00             	movzbl (%rax),%eax
    1221:	84 c0                	test   %al,%al
    1223:	75 de                	jne    1203 <strchr+0x13>
  return 0;
    1225:	b8 00 00 00 00       	mov    $0x0,%eax
}
    122a:	c9                   	leave
    122b:	c3                   	ret

000000000000122c <gets>:

char*
gets(char *buf, int max)
{
    122c:	55                   	push   %rbp
    122d:	48 89 e5             	mov    %rsp,%rbp
    1230:	48 83 ec 20          	sub    $0x20,%rsp
    1234:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1238:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    123b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1242:	eb 4f                	jmp    1293 <gets+0x67>
    cc = read(0, &c, 1);
    1244:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1248:	ba 01 00 00 00       	mov    $0x1,%edx
    124d:	48 89 c6             	mov    %rax,%rsi
    1250:	bf 00 00 00 00       	mov    $0x0,%edi
    1255:	48 b8 01 14 00 00 00 	movabs $0x1401,%rax
    125c:	00 00 00 
    125f:	ff d0                	call   *%rax
    1261:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1264:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1268:	7e 36                	jle    12a0 <gets+0x74>
      break;
    buf[i++] = c;
    126a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    126d:	8d 50 01             	lea    0x1(%rax),%edx
    1270:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1273:	48 63 d0             	movslq %eax,%rdx
    1276:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    127a:	48 01 c2             	add    %rax,%rdx
    127d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1281:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1283:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1287:	3c 0a                	cmp    $0xa,%al
    1289:	74 16                	je     12a1 <gets+0x75>
    128b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    128f:	3c 0d                	cmp    $0xd,%al
    1291:	74 0e                	je     12a1 <gets+0x75>
  for(i=0; i+1 < max; ){
    1293:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1296:	83 c0 01             	add    $0x1,%eax
    1299:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    129c:	7f a6                	jg     1244 <gets+0x18>
    129e:	eb 01                	jmp    12a1 <gets+0x75>
      break;
    12a0:	90                   	nop
      break;
  }
  buf[i] = '\0';
    12a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12a4:	48 63 d0             	movslq %eax,%rdx
    12a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12ab:	48 01 d0             	add    %rdx,%rax
    12ae:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12b5:	c9                   	leave
    12b6:	c3                   	ret

00000000000012b7 <stat>:

int
stat(char *n, struct stat *st)
{
    12b7:	55                   	push   %rbp
    12b8:	48 89 e5             	mov    %rsp,%rbp
    12bb:	48 83 ec 20          	sub    $0x20,%rsp
    12bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12cb:	be 00 00 00 00       	mov    $0x0,%esi
    12d0:	48 89 c7             	mov    %rax,%rdi
    12d3:	48 b8 42 14 00 00 00 	movabs $0x1442,%rax
    12da:	00 00 00 
    12dd:	ff d0                	call   *%rax
    12df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    12e6:	79 07                	jns    12ef <stat+0x38>
    return -1;
    12e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12ed:	eb 2f                	jmp    131e <stat+0x67>
  r = fstat(fd, st);
    12ef:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12f6:	48 89 d6             	mov    %rdx,%rsi
    12f9:	89 c7                	mov    %eax,%edi
    12fb:	48 b8 69 14 00 00 00 	movabs $0x1469,%rax
    1302:	00 00 00 
    1305:	ff d0                	call   *%rax
    1307:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    130a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    130d:	89 c7                	mov    %eax,%edi
    130f:	48 b8 1b 14 00 00 00 	movabs $0x141b,%rax
    1316:	00 00 00 
    1319:	ff d0                	call   *%rax
  return r;
    131b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    131e:	c9                   	leave
    131f:	c3                   	ret

0000000000001320 <atoi>:

int
atoi(const char *s)
{
    1320:	55                   	push   %rbp
    1321:	48 89 e5             	mov    %rsp,%rbp
    1324:	48 83 ec 18          	sub    $0x18,%rsp
    1328:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    132c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1333:	eb 28                	jmp    135d <atoi+0x3d>
    n = n*10 + *s++ - '0';
    1335:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1338:	89 d0                	mov    %edx,%eax
    133a:	c1 e0 02             	shl    $0x2,%eax
    133d:	01 d0                	add    %edx,%eax
    133f:	01 c0                	add    %eax,%eax
    1341:	89 c1                	mov    %eax,%ecx
    1343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1347:	48 8d 50 01          	lea    0x1(%rax),%rdx
    134b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    134f:	0f b6 00             	movzbl (%rax),%eax
    1352:	0f be c0             	movsbl %al,%eax
    1355:	01 c8                	add    %ecx,%eax
    1357:	83 e8 30             	sub    $0x30,%eax
    135a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    135d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1361:	0f b6 00             	movzbl (%rax),%eax
    1364:	3c 2f                	cmp    $0x2f,%al
    1366:	7e 0b                	jle    1373 <atoi+0x53>
    1368:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    136c:	0f b6 00             	movzbl (%rax),%eax
    136f:	3c 39                	cmp    $0x39,%al
    1371:	7e c2                	jle    1335 <atoi+0x15>
  return n;
    1373:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1376:	c9                   	leave
    1377:	c3                   	ret

0000000000001378 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1378:	55                   	push   %rbp
    1379:	48 89 e5             	mov    %rsp,%rbp
    137c:	48 83 ec 28          	sub    $0x28,%rsp
    1380:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1384:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1388:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    138b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    138f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1393:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1397:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    139b:	eb 1d                	jmp    13ba <memmove+0x42>
    *dst++ = *src++;
    139d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    13a1:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13ad:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13b1:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13b5:	0f b6 12             	movzbl (%rdx),%edx
    13b8:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13bd:	8d 50 ff             	lea    -0x1(%rax),%edx
    13c0:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13c3:	85 c0                	test   %eax,%eax
    13c5:	7f d6                	jg     139d <memmove+0x25>
  return vdst;
    13c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13cb:	c9                   	leave
    13cc:	c3                   	ret

00000000000013cd <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13cd:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13d4:	49 89 ca             	mov    %rcx,%r10
    13d7:	0f 05                	syscall
    13d9:	c3                   	ret

00000000000013da <exit>:
SYSCALL(exit)
    13da:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    13e1:	49 89 ca             	mov    %rcx,%r10
    13e4:	0f 05                	syscall
    13e6:	c3                   	ret

00000000000013e7 <wait>:
SYSCALL(wait)
    13e7:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    13ee:	49 89 ca             	mov    %rcx,%r10
    13f1:	0f 05                	syscall
    13f3:	c3                   	ret

00000000000013f4 <pipe>:
SYSCALL(pipe)
    13f4:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    13fb:	49 89 ca             	mov    %rcx,%r10
    13fe:	0f 05                	syscall
    1400:	c3                   	ret

0000000000001401 <read>:
SYSCALL(read)
    1401:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1408:	49 89 ca             	mov    %rcx,%r10
    140b:	0f 05                	syscall
    140d:	c3                   	ret

000000000000140e <write>:
SYSCALL(write)
    140e:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1415:	49 89 ca             	mov    %rcx,%r10
    1418:	0f 05                	syscall
    141a:	c3                   	ret

000000000000141b <close>:
SYSCALL(close)
    141b:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1422:	49 89 ca             	mov    %rcx,%r10
    1425:	0f 05                	syscall
    1427:	c3                   	ret

0000000000001428 <kill>:
SYSCALL(kill)
    1428:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    142f:	49 89 ca             	mov    %rcx,%r10
    1432:	0f 05                	syscall
    1434:	c3                   	ret

0000000000001435 <exec>:
SYSCALL(exec)
    1435:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    143c:	49 89 ca             	mov    %rcx,%r10
    143f:	0f 05                	syscall
    1441:	c3                   	ret

0000000000001442 <open>:
SYSCALL(open)
    1442:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1449:	49 89 ca             	mov    %rcx,%r10
    144c:	0f 05                	syscall
    144e:	c3                   	ret

000000000000144f <mknod>:
SYSCALL(mknod)
    144f:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1456:	49 89 ca             	mov    %rcx,%r10
    1459:	0f 05                	syscall
    145b:	c3                   	ret

000000000000145c <unlink>:
SYSCALL(unlink)
    145c:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1463:	49 89 ca             	mov    %rcx,%r10
    1466:	0f 05                	syscall
    1468:	c3                   	ret

0000000000001469 <fstat>:
SYSCALL(fstat)
    1469:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1470:	49 89 ca             	mov    %rcx,%r10
    1473:	0f 05                	syscall
    1475:	c3                   	ret

0000000000001476 <link>:
SYSCALL(link)
    1476:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    147d:	49 89 ca             	mov    %rcx,%r10
    1480:	0f 05                	syscall
    1482:	c3                   	ret

0000000000001483 <mkdir>:
SYSCALL(mkdir)
    1483:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    148a:	49 89 ca             	mov    %rcx,%r10
    148d:	0f 05                	syscall
    148f:	c3                   	ret

0000000000001490 <chdir>:
SYSCALL(chdir)
    1490:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1497:	49 89 ca             	mov    %rcx,%r10
    149a:	0f 05                	syscall
    149c:	c3                   	ret

000000000000149d <dup>:
SYSCALL(dup)
    149d:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    14a4:	49 89 ca             	mov    %rcx,%r10
    14a7:	0f 05                	syscall
    14a9:	c3                   	ret

00000000000014aa <getpid>:
SYSCALL(getpid)
    14aa:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14b1:	49 89 ca             	mov    %rcx,%r10
    14b4:	0f 05                	syscall
    14b6:	c3                   	ret

00000000000014b7 <sbrk>:
SYSCALL(sbrk)
    14b7:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14be:	49 89 ca             	mov    %rcx,%r10
    14c1:	0f 05                	syscall
    14c3:	c3                   	ret

00000000000014c4 <sleep>:
SYSCALL(sleep)
    14c4:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14cb:	49 89 ca             	mov    %rcx,%r10
    14ce:	0f 05                	syscall
    14d0:	c3                   	ret

00000000000014d1 <uptime>:
SYSCALL(uptime)
    14d1:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14d8:	49 89 ca             	mov    %rcx,%r10
    14db:	0f 05                	syscall
    14dd:	c3                   	ret

00000000000014de <traceread>:
SYSCALL(traceread)
    14de:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    14e5:	49 89 ca             	mov    %rcx,%r10
    14e8:	0f 05                	syscall
    14ea:	c3                   	ret

00000000000014eb <vidclear>:
SYSCALL(vidclear)
    14eb:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    14f2:	49 89 ca             	mov    %rcx,%r10
    14f5:	0f 05                	syscall
    14f7:	c3                   	ret

00000000000014f8 <vidputc>:
SYSCALL(vidputc)
    14f8:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    14ff:	49 89 ca             	mov    %rcx,%r10
    1502:	0f 05                	syscall
    1504:	c3                   	ret

0000000000001505 <vidputs>:
SYSCALL(vidputs)
    1505:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    150c:	49 89 ca             	mov    %rcx,%r10
    150f:	0f 05                	syscall
    1511:	c3                   	ret

0000000000001512 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1512:	55                   	push   %rbp
    1513:	48 89 e5             	mov    %rsp,%rbp
    1516:	48 83 ec 10          	sub    $0x10,%rsp
    151a:	89 7d fc             	mov    %edi,-0x4(%rbp)
    151d:	89 f0                	mov    %esi,%eax
    151f:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1522:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1526:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1529:	ba 01 00 00 00       	mov    $0x1,%edx
    152e:	48 89 ce             	mov    %rcx,%rsi
    1531:	89 c7                	mov    %eax,%edi
    1533:	48 b8 0e 14 00 00 00 	movabs $0x140e,%rax
    153a:	00 00 00 
    153d:	ff d0                	call   *%rax
}
    153f:	90                   	nop
    1540:	c9                   	leave
    1541:	c3                   	ret

0000000000001542 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1542:	55                   	push   %rbp
    1543:	48 89 e5             	mov    %rsp,%rbp
    1546:	48 83 ec 20          	sub    $0x20,%rsp
    154a:	89 7d ec             	mov    %edi,-0x14(%rbp)
    154d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1551:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1558:	eb 35                	jmp    158f <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    155a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    155e:	48 c1 e8 3c          	shr    $0x3c,%rax
    1562:	48 ba 60 1e 00 00 00 	movabs $0x1e60,%rdx
    1569:	00 00 00 
    156c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1570:	0f be d0             	movsbl %al,%edx
    1573:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1576:	89 d6                	mov    %edx,%esi
    1578:	89 c7                	mov    %eax,%edi
    157a:	48 b8 12 15 00 00 00 	movabs $0x1512,%rax
    1581:	00 00 00 
    1584:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1586:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    158a:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    158f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1592:	83 f8 0f             	cmp    $0xf,%eax
    1595:	76 c3                	jbe    155a <print_x64+0x18>
}
    1597:	90                   	nop
    1598:	90                   	nop
    1599:	c9                   	leave
    159a:	c3                   	ret

000000000000159b <print_x32>:

  static void
print_x32(int fd, uint x)
{
    159b:	55                   	push   %rbp
    159c:	48 89 e5             	mov    %rsp,%rbp
    159f:	48 83 ec 20          	sub    $0x20,%rsp
    15a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15a6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15b0:	eb 36                	jmp    15e8 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    15b2:	8b 45 e8             	mov    -0x18(%rbp),%eax
    15b5:	c1 e8 1c             	shr    $0x1c,%eax
    15b8:	89 c2                	mov    %eax,%edx
    15ba:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    15c1:	00 00 00 
    15c4:	89 d2                	mov    %edx,%edx
    15c6:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15ca:	0f be d0             	movsbl %al,%edx
    15cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15d0:	89 d6                	mov    %edx,%esi
    15d2:	89 c7                	mov    %eax,%edi
    15d4:	48 b8 12 15 00 00 00 	movabs $0x1512,%rax
    15db:	00 00 00 
    15de:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15e0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15e4:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15eb:	83 f8 07             	cmp    $0x7,%eax
    15ee:	76 c2                	jbe    15b2 <print_x32+0x17>
}
    15f0:	90                   	nop
    15f1:	90                   	nop
    15f2:	c9                   	leave
    15f3:	c3                   	ret

00000000000015f4 <print_d>:

  static void
print_d(int fd, int v)
{
    15f4:	55                   	push   %rbp
    15f5:	48 89 e5             	mov    %rsp,%rbp
    15f8:	48 83 ec 30          	sub    $0x30,%rsp
    15fc:	89 7d dc             	mov    %edi,-0x24(%rbp)
    15ff:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1602:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1605:	48 98                	cltq
    1607:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    160b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    160f:	79 04                	jns    1615 <print_d+0x21>
    x = -x;
    1611:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1615:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    161c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1620:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1627:	66 66 66 
    162a:	48 89 c8             	mov    %rcx,%rax
    162d:	48 f7 ea             	imul   %rdx
    1630:	48 c1 fa 02          	sar    $0x2,%rdx
    1634:	48 89 c8             	mov    %rcx,%rax
    1637:	48 c1 f8 3f          	sar    $0x3f,%rax
    163b:	48 29 c2             	sub    %rax,%rdx
    163e:	48 89 d0             	mov    %rdx,%rax
    1641:	48 c1 e0 02          	shl    $0x2,%rax
    1645:	48 01 d0             	add    %rdx,%rax
    1648:	48 01 c0             	add    %rax,%rax
    164b:	48 29 c1             	sub    %rax,%rcx
    164e:	48 89 ca             	mov    %rcx,%rdx
    1651:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1654:	8d 48 01             	lea    0x1(%rax),%ecx
    1657:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    165a:	48 b9 60 1e 00 00 00 	movabs $0x1e60,%rcx
    1661:	00 00 00 
    1664:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1668:	48 98                	cltq
    166a:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    166e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1672:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1679:	66 66 66 
    167c:	48 89 c8             	mov    %rcx,%rax
    167f:	48 f7 ea             	imul   %rdx
    1682:	48 89 d0             	mov    %rdx,%rax
    1685:	48 c1 f8 02          	sar    $0x2,%rax
    1689:	48 c1 f9 3f          	sar    $0x3f,%rcx
    168d:	48 89 ca             	mov    %rcx,%rdx
    1690:	48 29 d0             	sub    %rdx,%rax
    1693:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1697:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    169c:	0f 85 7a ff ff ff    	jne    161c <print_d+0x28>

  if (v < 0)
    16a2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16a6:	79 32                	jns    16da <print_d+0xe6>
    buf[i++] = '-';
    16a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16ab:	8d 50 01             	lea    0x1(%rax),%edx
    16ae:	89 55 f4             	mov    %edx,-0xc(%rbp)
    16b1:	48 98                	cltq
    16b3:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16b8:	eb 20                	jmp    16da <print_d+0xe6>
    putc(fd, buf[i]);
    16ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16bd:	48 98                	cltq
    16bf:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16c4:	0f be d0             	movsbl %al,%edx
    16c7:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16ca:	89 d6                	mov    %edx,%esi
    16cc:	89 c7                	mov    %eax,%edi
    16ce:	48 b8 12 15 00 00 00 	movabs $0x1512,%rax
    16d5:	00 00 00 
    16d8:	ff d0                	call   *%rax
  while (--i >= 0)
    16da:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16de:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16e2:	79 d6                	jns    16ba <print_d+0xc6>
}
    16e4:	90                   	nop
    16e5:	90                   	nop
    16e6:	c9                   	leave
    16e7:	c3                   	ret

00000000000016e8 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16e8:	55                   	push   %rbp
    16e9:	48 89 e5             	mov    %rsp,%rbp
    16ec:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    16f3:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    16f9:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1700:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1707:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    170e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1715:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    171c:	84 c0                	test   %al,%al
    171e:	74 20                	je     1740 <printf+0x58>
    1720:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1724:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1728:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    172c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1730:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1734:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1738:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    173c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1740:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1747:	00 00 00 
    174a:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1751:	00 00 00 
    1754:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1758:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    175f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1766:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    176d:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1774:	00 00 00 
    1777:	e9 60 03 00 00       	jmp    1adc <printf+0x3f4>
    if (c != '%') {
    177c:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1783:	74 24                	je     17a9 <printf+0xc1>
      putc(fd, c);
    1785:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    178b:	0f be d0             	movsbl %al,%edx
    178e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1794:	89 d6                	mov    %edx,%esi
    1796:	89 c7                	mov    %eax,%edi
    1798:	48 b8 12 15 00 00 00 	movabs $0x1512,%rax
    179f:	00 00 00 
    17a2:	ff d0                	call   *%rax
      continue;
    17a4:	e9 2c 03 00 00       	jmp    1ad5 <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    17a9:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17b0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17b6:	48 63 d0             	movslq %eax,%rdx
    17b9:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17c0:	48 01 d0             	add    %rdx,%rax
    17c3:	0f b6 00             	movzbl (%rax),%eax
    17c6:	0f be c0             	movsbl %al,%eax
    17c9:	25 ff 00 00 00       	and    $0xff,%eax
    17ce:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17d4:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17db:	0f 84 2e 03 00 00    	je     1b0f <printf+0x427>
      break;
    switch(c) {
    17e1:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17e8:	0f 84 32 01 00 00    	je     1920 <printf+0x238>
    17ee:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17f5:	0f 8f a1 02 00 00    	jg     1a9c <printf+0x3b4>
    17fb:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1802:	0f 84 d4 01 00 00    	je     19dc <printf+0x2f4>
    1808:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    180f:	0f 8f 87 02 00 00    	jg     1a9c <printf+0x3b4>
    1815:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    181c:	0f 84 5b 01 00 00    	je     197d <printf+0x295>
    1822:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1829:	0f 8f 6d 02 00 00    	jg     1a9c <printf+0x3b4>
    182f:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1836:	0f 84 87 00 00 00    	je     18c3 <printf+0x1db>
    183c:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1843:	0f 8f 53 02 00 00    	jg     1a9c <printf+0x3b4>
    1849:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1850:	0f 84 2b 02 00 00    	je     1a81 <printf+0x399>
    1856:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    185d:	0f 85 39 02 00 00    	jne    1a9c <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    1863:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1869:	83 f8 2f             	cmp    $0x2f,%eax
    186c:	77 23                	ja     1891 <printf+0x1a9>
    186e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1875:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    187b:	89 d2                	mov    %edx,%edx
    187d:	48 01 d0             	add    %rdx,%rax
    1880:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1886:	83 c2 08             	add    $0x8,%edx
    1889:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    188f:	eb 12                	jmp    18a3 <printf+0x1bb>
    1891:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1898:	48 8d 50 08          	lea    0x8(%rax),%rdx
    189c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18a3:	8b 00                	mov    (%rax),%eax
    18a5:	0f be d0             	movsbl %al,%edx
    18a8:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18ae:	89 d6                	mov    %edx,%esi
    18b0:	89 c7                	mov    %eax,%edi
    18b2:	48 b8 12 15 00 00 00 	movabs $0x1512,%rax
    18b9:	00 00 00 
    18bc:	ff d0                	call   *%rax
      break;
    18be:	e9 12 02 00 00       	jmp    1ad5 <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    18c3:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18c9:	83 f8 2f             	cmp    $0x2f,%eax
    18cc:	77 23                	ja     18f1 <printf+0x209>
    18ce:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18d5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18db:	89 d2                	mov    %edx,%edx
    18dd:	48 01 d0             	add    %rdx,%rax
    18e0:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18e6:	83 c2 08             	add    $0x8,%edx
    18e9:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18ef:	eb 12                	jmp    1903 <printf+0x21b>
    18f1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18f8:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18fc:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1903:	8b 10                	mov    (%rax),%edx
    1905:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    190b:	89 d6                	mov    %edx,%esi
    190d:	89 c7                	mov    %eax,%edi
    190f:	48 b8 f4 15 00 00 00 	movabs $0x15f4,%rax
    1916:	00 00 00 
    1919:	ff d0                	call   *%rax
      break;
    191b:	e9 b5 01 00 00       	jmp    1ad5 <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1920:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1926:	83 f8 2f             	cmp    $0x2f,%eax
    1929:	77 23                	ja     194e <printf+0x266>
    192b:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1932:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1938:	89 d2                	mov    %edx,%edx
    193a:	48 01 d0             	add    %rdx,%rax
    193d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1943:	83 c2 08             	add    $0x8,%edx
    1946:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    194c:	eb 12                	jmp    1960 <printf+0x278>
    194e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1955:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1959:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1960:	8b 10                	mov    (%rax),%edx
    1962:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1968:	89 d6                	mov    %edx,%esi
    196a:	89 c7                	mov    %eax,%edi
    196c:	48 b8 9b 15 00 00 00 	movabs $0x159b,%rax
    1973:	00 00 00 
    1976:	ff d0                	call   *%rax
      break;
    1978:	e9 58 01 00 00       	jmp    1ad5 <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    197d:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1983:	83 f8 2f             	cmp    $0x2f,%eax
    1986:	77 23                	ja     19ab <printf+0x2c3>
    1988:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    198f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1995:	89 d2                	mov    %edx,%edx
    1997:	48 01 d0             	add    %rdx,%rax
    199a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19a0:	83 c2 08             	add    $0x8,%edx
    19a3:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19a9:	eb 12                	jmp    19bd <printf+0x2d5>
    19ab:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19b2:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19b6:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19bd:	48 8b 10             	mov    (%rax),%rdx
    19c0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19c6:	48 89 d6             	mov    %rdx,%rsi
    19c9:	89 c7                	mov    %eax,%edi
    19cb:	48 b8 42 15 00 00 00 	movabs $0x1542,%rax
    19d2:	00 00 00 
    19d5:	ff d0                	call   *%rax
      break;
    19d7:	e9 f9 00 00 00       	jmp    1ad5 <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19dc:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19e2:	83 f8 2f             	cmp    $0x2f,%eax
    19e5:	77 23                	ja     1a0a <printf+0x322>
    19e7:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19ee:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19f4:	89 d2                	mov    %edx,%edx
    19f6:	48 01 d0             	add    %rdx,%rax
    19f9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19ff:	83 c2 08             	add    $0x8,%edx
    1a02:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a08:	eb 12                	jmp    1a1c <printf+0x334>
    1a0a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a11:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a15:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a1c:	48 8b 00             	mov    (%rax),%rax
    1a1f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1a26:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a2d:	00 
    1a2e:	75 41                	jne    1a71 <printf+0x389>
        s = "(null)";
    1a30:	48 b8 4b 1e 00 00 00 	movabs $0x1e4b,%rax
    1a37:	00 00 00 
    1a3a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a41:	eb 2e                	jmp    1a71 <printf+0x389>
        putc(fd, *(s++));
    1a43:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a4a:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a4e:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a55:	0f b6 00             	movzbl (%rax),%eax
    1a58:	0f be d0             	movsbl %al,%edx
    1a5b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a61:	89 d6                	mov    %edx,%esi
    1a63:	89 c7                	mov    %eax,%edi
    1a65:	48 b8 12 15 00 00 00 	movabs $0x1512,%rax
    1a6c:	00 00 00 
    1a6f:	ff d0                	call   *%rax
      while (*s)
    1a71:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a78:	0f b6 00             	movzbl (%rax),%eax
    1a7b:	84 c0                	test   %al,%al
    1a7d:	75 c4                	jne    1a43 <printf+0x35b>
      break;
    1a7f:	eb 54                	jmp    1ad5 <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1a81:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a87:	be 25 00 00 00       	mov    $0x25,%esi
    1a8c:	89 c7                	mov    %eax,%edi
    1a8e:	48 b8 12 15 00 00 00 	movabs $0x1512,%rax
    1a95:	00 00 00 
    1a98:	ff d0                	call   *%rax
      break;
    1a9a:	eb 39                	jmp    1ad5 <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a9c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aa2:	be 25 00 00 00       	mov    $0x25,%esi
    1aa7:	89 c7                	mov    %eax,%edi
    1aa9:	48 b8 12 15 00 00 00 	movabs $0x1512,%rax
    1ab0:	00 00 00 
    1ab3:	ff d0                	call   *%rax
      putc(fd, c);
    1ab5:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1abb:	0f be d0             	movsbl %al,%edx
    1abe:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ac4:	89 d6                	mov    %edx,%esi
    1ac6:	89 c7                	mov    %eax,%edi
    1ac8:	48 b8 12 15 00 00 00 	movabs $0x1512,%rax
    1acf:	00 00 00 
    1ad2:	ff d0                	call   *%rax
      break;
    1ad4:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1ad5:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1adc:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ae2:	48 63 d0             	movslq %eax,%rdx
    1ae5:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1aec:	48 01 d0             	add    %rdx,%rax
    1aef:	0f b6 00             	movzbl (%rax),%eax
    1af2:	0f be c0             	movsbl %al,%eax
    1af5:	25 ff 00 00 00       	and    $0xff,%eax
    1afa:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1b00:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1b07:	0f 85 6f fc ff ff    	jne    177c <printf+0x94>
    }
  }
}
    1b0d:	eb 01                	jmp    1b10 <printf+0x428>
      break;
    1b0f:	90                   	nop
}
    1b10:	90                   	nop
    1b11:	c9                   	leave
    1b12:	c3                   	ret

0000000000001b13 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1b13:	55                   	push   %rbp
    1b14:	48 89 e5             	mov    %rsp,%rbp
    1b17:	48 83 ec 18          	sub    $0x18,%rsp
    1b1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b23:	48 83 e8 10          	sub    $0x10,%rax
    1b27:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b2b:	48 b8 90 1e 00 00 00 	movabs $0x1e90,%rax
    1b32:	00 00 00 
    1b35:	48 8b 00             	mov    (%rax),%rax
    1b38:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b3c:	eb 2f                	jmp    1b6d <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b42:	48 8b 00             	mov    (%rax),%rax
    1b45:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b49:	72 17                	jb     1b62 <free+0x4f>
    1b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b4f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b53:	72 2f                	jb     1b84 <free+0x71>
    1b55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b59:	48 8b 00             	mov    (%rax),%rax
    1b5c:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b60:	72 22                	jb     1b84 <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b66:	48 8b 00             	mov    (%rax),%rax
    1b69:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b71:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b75:	73 c7                	jae    1b3e <free+0x2b>
    1b77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b7b:	48 8b 00             	mov    (%rax),%rax
    1b7e:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b82:	73 ba                	jae    1b3e <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b88:	8b 40 08             	mov    0x8(%rax),%eax
    1b8b:	89 c0                	mov    %eax,%eax
    1b8d:	48 c1 e0 04          	shl    $0x4,%rax
    1b91:	48 89 c2             	mov    %rax,%rdx
    1b94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b98:	48 01 c2             	add    %rax,%rdx
    1b9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b9f:	48 8b 00             	mov    (%rax),%rax
    1ba2:	48 39 c2             	cmp    %rax,%rdx
    1ba5:	75 2d                	jne    1bd4 <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1ba7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bab:	8b 50 08             	mov    0x8(%rax),%edx
    1bae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bb2:	48 8b 00             	mov    (%rax),%rax
    1bb5:	8b 40 08             	mov    0x8(%rax),%eax
    1bb8:	01 c2                	add    %eax,%edx
    1bba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bbe:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1bc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bc5:	48 8b 00             	mov    (%rax),%rax
    1bc8:	48 8b 10             	mov    (%rax),%rdx
    1bcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bcf:	48 89 10             	mov    %rdx,(%rax)
    1bd2:	eb 0e                	jmp    1be2 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1bd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bd8:	48 8b 10             	mov    (%rax),%rdx
    1bdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bdf:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1be2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be6:	8b 40 08             	mov    0x8(%rax),%eax
    1be9:	89 c0                	mov    %eax,%eax
    1beb:	48 c1 e0 04          	shl    $0x4,%rax
    1bef:	48 89 c2             	mov    %rax,%rdx
    1bf2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf6:	48 01 d0             	add    %rdx,%rax
    1bf9:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bfd:	75 27                	jne    1c26 <free+0x113>
    p->s.size += bp->s.size;
    1bff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c03:	8b 50 08             	mov    0x8(%rax),%edx
    1c06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c0a:	8b 40 08             	mov    0x8(%rax),%eax
    1c0d:	01 c2                	add    %eax,%edx
    1c0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c13:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1c16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c1a:	48 8b 10             	mov    (%rax),%rdx
    1c1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c21:	48 89 10             	mov    %rdx,(%rax)
    1c24:	eb 0b                	jmp    1c31 <free+0x11e>
  } else
    p->s.ptr = bp;
    1c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c2e:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c31:	48 ba 90 1e 00 00 00 	movabs $0x1e90,%rdx
    1c38:	00 00 00 
    1c3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c3f:	48 89 02             	mov    %rax,(%rdx)
}
    1c42:	90                   	nop
    1c43:	c9                   	leave
    1c44:	c3                   	ret

0000000000001c45 <morecore>:

static Header*
morecore(uint nu)
{
    1c45:	55                   	push   %rbp
    1c46:	48 89 e5             	mov    %rsp,%rbp
    1c49:	48 83 ec 20          	sub    $0x20,%rsp
    1c4d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c50:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c57:	77 07                	ja     1c60 <morecore+0x1b>
    nu = 4096;
    1c59:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c60:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c63:	48 c1 e0 04          	shl    $0x4,%rax
    1c67:	48 89 c7             	mov    %rax,%rdi
    1c6a:	48 b8 b7 14 00 00 00 	movabs $0x14b7,%rax
    1c71:	00 00 00 
    1c74:	ff d0                	call   *%rax
    1c76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c7a:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c7f:	75 07                	jne    1c88 <morecore+0x43>
    return 0;
    1c81:	b8 00 00 00 00       	mov    $0x0,%eax
    1c86:	eb 36                	jmp    1cbe <morecore+0x79>
  hp = (Header*)p;
    1c88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c8c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c94:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c97:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c9e:	48 83 c0 10          	add    $0x10,%rax
    1ca2:	48 89 c7             	mov    %rax,%rdi
    1ca5:	48 b8 13 1b 00 00 00 	movabs $0x1b13,%rax
    1cac:	00 00 00 
    1caf:	ff d0                	call   *%rax
  return freep;
    1cb1:	48 b8 90 1e 00 00 00 	movabs $0x1e90,%rax
    1cb8:	00 00 00 
    1cbb:	48 8b 00             	mov    (%rax),%rax
}
    1cbe:	c9                   	leave
    1cbf:	c3                   	ret

0000000000001cc0 <malloc>:

void*
malloc(uint nbytes)
{
    1cc0:	55                   	push   %rbp
    1cc1:	48 89 e5             	mov    %rsp,%rbp
    1cc4:	48 83 ec 30          	sub    $0x30,%rsp
    1cc8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1ccb:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1cce:	48 83 c0 0f          	add    $0xf,%rax
    1cd2:	48 c1 e8 04          	shr    $0x4,%rax
    1cd6:	83 c0 01             	add    $0x1,%eax
    1cd9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1cdc:	48 b8 90 1e 00 00 00 	movabs $0x1e90,%rax
    1ce3:	00 00 00 
    1ce6:	48 8b 00             	mov    (%rax),%rax
    1ce9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ced:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cf2:	75 4a                	jne    1d3e <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1cf4:	48 b8 80 1e 00 00 00 	movabs $0x1e80,%rax
    1cfb:	00 00 00 
    1cfe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d02:	48 ba 90 1e 00 00 00 	movabs $0x1e90,%rdx
    1d09:	00 00 00 
    1d0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d10:	48 89 02             	mov    %rax,(%rdx)
    1d13:	48 b8 90 1e 00 00 00 	movabs $0x1e90,%rax
    1d1a:	00 00 00 
    1d1d:	48 8b 00             	mov    (%rax),%rax
    1d20:	48 ba 80 1e 00 00 00 	movabs $0x1e80,%rdx
    1d27:	00 00 00 
    1d2a:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d2d:	48 b8 80 1e 00 00 00 	movabs $0x1e80,%rax
    1d34:	00 00 00 
    1d37:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d42:	48 8b 00             	mov    (%rax),%rax
    1d45:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4d:	8b 40 08             	mov    0x8(%rax),%eax
    1d50:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1d53:	72 65                	jb     1dba <malloc+0xfa>
      if(p->s.size == nunits)
    1d55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d59:	8b 40 08             	mov    0x8(%rax),%eax
    1d5c:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d5f:	75 10                	jne    1d71 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d65:	48 8b 10             	mov    (%rax),%rdx
    1d68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d6c:	48 89 10             	mov    %rdx,(%rax)
    1d6f:	eb 2e                	jmp    1d9f <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1d71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d75:	8b 40 08             	mov    0x8(%rax),%eax
    1d78:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d7b:	89 c2                	mov    %eax,%edx
    1d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d81:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d88:	8b 40 08             	mov    0x8(%rax),%eax
    1d8b:	89 c0                	mov    %eax,%eax
    1d8d:	48 c1 e0 04          	shl    $0x4,%rax
    1d91:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d99:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d9c:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d9f:	48 ba 90 1e 00 00 00 	movabs $0x1e90,%rdx
    1da6:	00 00 00 
    1da9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dad:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1db0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1db4:	48 83 c0 10          	add    $0x10,%rax
    1db8:	eb 4e                	jmp    1e08 <malloc+0x148>
    }
    if(p == freep)
    1dba:	48 b8 90 1e 00 00 00 	movabs $0x1e90,%rax
    1dc1:	00 00 00 
    1dc4:	48 8b 00             	mov    (%rax),%rax
    1dc7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1dcb:	75 23                	jne    1df0 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1dcd:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1dd0:	89 c7                	mov    %eax,%edi
    1dd2:	48 b8 45 1c 00 00 00 	movabs $0x1c45,%rax
    1dd9:	00 00 00 
    1ddc:	ff d0                	call   *%rax
    1dde:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1de2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1de7:	75 07                	jne    1df0 <malloc+0x130>
        return 0;
    1de9:	b8 00 00 00 00       	mov    $0x0,%eax
    1dee:	eb 18                	jmp    1e08 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1df0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1df4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1df8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dfc:	48 8b 00             	mov    (%rax),%rax
    1dff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e03:	e9 41 ff ff ff       	jmp    1d49 <malloc+0x89>
  }
}
    1e08:	c9                   	leave
    1e09:	c3                   	ret

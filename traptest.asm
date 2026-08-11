
_traptest:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 20          	sub    $0x20,%rsp
    1008:	89 7d ec             	mov    %edi,-0x14(%rbp)
    100b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  printf(1, "traptest: starting, triggering page fault...\n");
    100f:	48 b8 c8 1d 00 00 00 	movabs $0x1dc8,%rax
    1016:	00 00 00 
    1019:	48 89 c6             	mov    %rax,%rsi
    101c:	bf 01 00 00 00       	mov    $0x1,%edi
    1021:	b8 00 00 00 00       	mov    $0x0,%eax
    1026:	48 ba a4 16 00 00 00 	movabs $0x16a4,%rdx
    102d:	00 00 00 
    1030:	ff d2                	call   *%rdx
  // Dereference NULL to trigger a page fault
  int *p = 0;
    1032:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
    1039:	00 
  *p = 123;
    103a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    103e:	c7 00 7b 00 00 00    	movl   $0x7b,(%rax)
  printf(1, "traptest: should have been killed! result=%d\n", *p);
    1044:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1048:	8b 00                	mov    (%rax),%eax
    104a:	48 b9 f8 1d 00 00 00 	movabs $0x1df8,%rcx
    1051:	00 00 00 
    1054:	89 c2                	mov    %eax,%edx
    1056:	48 89 ce             	mov    %rcx,%rsi
    1059:	bf 01 00 00 00       	mov    $0x1,%edi
    105e:	b8 00 00 00 00       	mov    $0x0,%eax
    1063:	48 b9 a4 16 00 00 00 	movabs $0x16a4,%rcx
    106a:	00 00 00 
    106d:	ff d1                	call   *%rcx
  exit();
    106f:	48 b8 96 13 00 00 00 	movabs $0x1396,%rax
    1076:	00 00 00 
    1079:	ff d0                	call   *%rax

000000000000107b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    107b:	55                   	push   %rbp
    107c:	48 89 e5             	mov    %rsp,%rbp
    107f:	48 83 ec 10          	sub    $0x10,%rsp
    1083:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1087:	89 75 f4             	mov    %esi,-0xc(%rbp)
    108a:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    108d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1091:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1094:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1097:	48 89 ce             	mov    %rcx,%rsi
    109a:	48 89 f7             	mov    %rsi,%rdi
    109d:	89 d1                	mov    %edx,%ecx
    109f:	fc                   	cld
    10a0:	f3 aa                	rep stos %al,(%rdi)
    10a2:	89 ca                	mov    %ecx,%edx
    10a4:	48 89 fe             	mov    %rdi,%rsi
    10a7:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10ab:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10ae:	90                   	nop
    10af:	c9                   	leave
    10b0:	c3                   	ret

00000000000010b1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10b1:	55                   	push   %rbp
    10b2:	48 89 e5             	mov    %rsp,%rbp
    10b5:	48 83 ec 20          	sub    $0x20,%rsp
    10b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    10bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    10c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    10c9:	90                   	nop
    10ca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    10ce:	48 8d 42 01          	lea    0x1(%rdx),%rax
    10d2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10da:	48 8d 48 01          	lea    0x1(%rax),%rcx
    10de:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    10e2:	0f b6 12             	movzbl (%rdx),%edx
    10e5:	88 10                	mov    %dl,(%rax)
    10e7:	0f b6 00             	movzbl (%rax),%eax
    10ea:	84 c0                	test   %al,%al
    10ec:	75 dc                	jne    10ca <strcpy+0x19>
    ;
  return os;
    10ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    10f2:	c9                   	leave
    10f3:	c3                   	ret

00000000000010f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10f4:	55                   	push   %rbp
    10f5:	48 89 e5             	mov    %rsp,%rbp
    10f8:	48 83 ec 10          	sub    $0x10,%rsp
    10fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1100:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1104:	eb 0a                	jmp    1110 <strcmp+0x1c>
    p++, q++;
    1106:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    110b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1110:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1114:	0f b6 00             	movzbl (%rax),%eax
    1117:	84 c0                	test   %al,%al
    1119:	74 12                	je     112d <strcmp+0x39>
    111b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    111f:	0f b6 10             	movzbl (%rax),%edx
    1122:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1126:	0f b6 00             	movzbl (%rax),%eax
    1129:	38 c2                	cmp    %al,%dl
    112b:	74 d9                	je     1106 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    112d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1131:	0f b6 00             	movzbl (%rax),%eax
    1134:	0f b6 d0             	movzbl %al,%edx
    1137:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    113b:	0f b6 00             	movzbl (%rax),%eax
    113e:	0f b6 c0             	movzbl %al,%eax
    1141:	29 c2                	sub    %eax,%edx
    1143:	89 d0                	mov    %edx,%eax
}
    1145:	c9                   	leave
    1146:	c3                   	ret

0000000000001147 <strlen>:

uint
strlen(char *s)
{
    1147:	55                   	push   %rbp
    1148:	48 89 e5             	mov    %rsp,%rbp
    114b:	48 83 ec 18          	sub    $0x18,%rsp
    114f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1153:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    115a:	eb 04                	jmp    1160 <strlen+0x19>
    115c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1160:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1163:	48 63 d0             	movslq %eax,%rdx
    1166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    116a:	48 01 d0             	add    %rdx,%rax
    116d:	0f b6 00             	movzbl (%rax),%eax
    1170:	84 c0                	test   %al,%al
    1172:	75 e8                	jne    115c <strlen+0x15>
    ;
  return n;
    1174:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1177:	c9                   	leave
    1178:	c3                   	ret

0000000000001179 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1179:	55                   	push   %rbp
    117a:	48 89 e5             	mov    %rsp,%rbp
    117d:	48 83 ec 10          	sub    $0x10,%rsp
    1181:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1185:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1188:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    118b:	8b 55 f0             	mov    -0x10(%rbp),%edx
    118e:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    1191:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1195:	89 ce                	mov    %ecx,%esi
    1197:	48 89 c7             	mov    %rax,%rdi
    119a:	48 b8 7b 10 00 00 00 	movabs $0x107b,%rax
    11a1:	00 00 00 
    11a4:	ff d0                	call   *%rax
  return dst;
    11a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11aa:	c9                   	leave
    11ab:	c3                   	ret

00000000000011ac <strchr>:

char*
strchr(const char *s, char c)
{
    11ac:	55                   	push   %rbp
    11ad:	48 89 e5             	mov    %rsp,%rbp
    11b0:	48 83 ec 10          	sub    $0x10,%rsp
    11b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11b8:	89 f0                	mov    %esi,%eax
    11ba:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    11bd:	eb 17                	jmp    11d6 <strchr+0x2a>
    if(*s == c)
    11bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11c3:	0f b6 00             	movzbl (%rax),%eax
    11c6:	38 45 f4             	cmp    %al,-0xc(%rbp)
    11c9:	75 06                	jne    11d1 <strchr+0x25>
      return (char*)s;
    11cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11cf:	eb 15                	jmp    11e6 <strchr+0x3a>
  for(; *s; s++)
    11d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    11d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11da:	0f b6 00             	movzbl (%rax),%eax
    11dd:	84 c0                	test   %al,%al
    11df:	75 de                	jne    11bf <strchr+0x13>
  return 0;
    11e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11e6:	c9                   	leave
    11e7:	c3                   	ret

00000000000011e8 <gets>:

char*
gets(char *buf, int max)
{
    11e8:	55                   	push   %rbp
    11e9:	48 89 e5             	mov    %rsp,%rbp
    11ec:	48 83 ec 20          	sub    $0x20,%rsp
    11f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    11f4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11fe:	eb 4f                	jmp    124f <gets+0x67>
    cc = read(0, &c, 1);
    1200:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1204:	ba 01 00 00 00       	mov    $0x1,%edx
    1209:	48 89 c6             	mov    %rax,%rsi
    120c:	bf 00 00 00 00       	mov    $0x0,%edi
    1211:	48 b8 bd 13 00 00 00 	movabs $0x13bd,%rax
    1218:	00 00 00 
    121b:	ff d0                	call   *%rax
    121d:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1220:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1224:	7e 36                	jle    125c <gets+0x74>
      break;
    buf[i++] = c;
    1226:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1229:	8d 50 01             	lea    0x1(%rax),%edx
    122c:	89 55 fc             	mov    %edx,-0x4(%rbp)
    122f:	48 63 d0             	movslq %eax,%rdx
    1232:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1236:	48 01 c2             	add    %rax,%rdx
    1239:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    123d:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    123f:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1243:	3c 0a                	cmp    $0xa,%al
    1245:	74 16                	je     125d <gets+0x75>
    1247:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    124b:	3c 0d                	cmp    $0xd,%al
    124d:	74 0e                	je     125d <gets+0x75>
  for(i=0; i+1 < max; ){
    124f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1252:	83 c0 01             	add    $0x1,%eax
    1255:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1258:	7f a6                	jg     1200 <gets+0x18>
    125a:	eb 01                	jmp    125d <gets+0x75>
      break;
    125c:	90                   	nop
      break;
  }
  buf[i] = '\0';
    125d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1260:	48 63 d0             	movslq %eax,%rdx
    1263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1267:	48 01 d0             	add    %rdx,%rax
    126a:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    126d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1271:	c9                   	leave
    1272:	c3                   	ret

0000000000001273 <stat>:

int
stat(char *n, struct stat *st)
{
    1273:	55                   	push   %rbp
    1274:	48 89 e5             	mov    %rsp,%rbp
    1277:	48 83 ec 20          	sub    $0x20,%rsp
    127b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    127f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1287:	be 00 00 00 00       	mov    $0x0,%esi
    128c:	48 89 c7             	mov    %rax,%rdi
    128f:	48 b8 fe 13 00 00 00 	movabs $0x13fe,%rax
    1296:	00 00 00 
    1299:	ff d0                	call   *%rax
    129b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    129e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    12a2:	79 07                	jns    12ab <stat+0x38>
    return -1;
    12a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12a9:	eb 2f                	jmp    12da <stat+0x67>
  r = fstat(fd, st);
    12ab:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12af:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12b2:	48 89 d6             	mov    %rdx,%rsi
    12b5:	89 c7                	mov    %eax,%edi
    12b7:	48 b8 25 14 00 00 00 	movabs $0x1425,%rax
    12be:	00 00 00 
    12c1:	ff d0                	call   *%rax
    12c3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    12c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12c9:	89 c7                	mov    %eax,%edi
    12cb:	48 b8 d7 13 00 00 00 	movabs $0x13d7,%rax
    12d2:	00 00 00 
    12d5:	ff d0                	call   *%rax
  return r;
    12d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    12da:	c9                   	leave
    12db:	c3                   	ret

00000000000012dc <atoi>:

int
atoi(const char *s)
{
    12dc:	55                   	push   %rbp
    12dd:	48 89 e5             	mov    %rsp,%rbp
    12e0:	48 83 ec 18          	sub    $0x18,%rsp
    12e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    12e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    12ef:	eb 28                	jmp    1319 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    12f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
    12f4:	89 d0                	mov    %edx,%eax
    12f6:	c1 e0 02             	shl    $0x2,%eax
    12f9:	01 d0                	add    %edx,%eax
    12fb:	01 c0                	add    %eax,%eax
    12fd:	89 c1                	mov    %eax,%ecx
    12ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1303:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1307:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    130b:	0f b6 00             	movzbl (%rax),%eax
    130e:	0f be c0             	movsbl %al,%eax
    1311:	01 c8                	add    %ecx,%eax
    1313:	83 e8 30             	sub    $0x30,%eax
    1316:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1319:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    131d:	0f b6 00             	movzbl (%rax),%eax
    1320:	3c 2f                	cmp    $0x2f,%al
    1322:	7e 0b                	jle    132f <atoi+0x53>
    1324:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1328:	0f b6 00             	movzbl (%rax),%eax
    132b:	3c 39                	cmp    $0x39,%al
    132d:	7e c2                	jle    12f1 <atoi+0x15>
  return n;
    132f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1332:	c9                   	leave
    1333:	c3                   	ret

0000000000001334 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1334:	55                   	push   %rbp
    1335:	48 89 e5             	mov    %rsp,%rbp
    1338:	48 83 ec 28          	sub    $0x28,%rsp
    133c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1340:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1344:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    134b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    134f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1353:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1357:	eb 1d                	jmp    1376 <memmove+0x42>
    *dst++ = *src++;
    1359:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    135d:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1361:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1369:	48 8d 48 01          	lea    0x1(%rax),%rcx
    136d:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1371:	0f b6 12             	movzbl (%rdx),%edx
    1374:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1376:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1379:	8d 50 ff             	lea    -0x1(%rax),%edx
    137c:	89 55 dc             	mov    %edx,-0x24(%rbp)
    137f:	85 c0                	test   %eax,%eax
    1381:	7f d6                	jg     1359 <memmove+0x25>
  return vdst;
    1383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1387:	c9                   	leave
    1388:	c3                   	ret

0000000000001389 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1389:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1390:	49 89 ca             	mov    %rcx,%r10
    1393:	0f 05                	syscall
    1395:	c3                   	ret

0000000000001396 <exit>:
SYSCALL(exit)
    1396:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    139d:	49 89 ca             	mov    %rcx,%r10
    13a0:	0f 05                	syscall
    13a2:	c3                   	ret

00000000000013a3 <wait>:
SYSCALL(wait)
    13a3:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    13aa:	49 89 ca             	mov    %rcx,%r10
    13ad:	0f 05                	syscall
    13af:	c3                   	ret

00000000000013b0 <pipe>:
SYSCALL(pipe)
    13b0:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    13b7:	49 89 ca             	mov    %rcx,%r10
    13ba:	0f 05                	syscall
    13bc:	c3                   	ret

00000000000013bd <read>:
SYSCALL(read)
    13bd:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    13c4:	49 89 ca             	mov    %rcx,%r10
    13c7:	0f 05                	syscall
    13c9:	c3                   	ret

00000000000013ca <write>:
SYSCALL(write)
    13ca:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    13d1:	49 89 ca             	mov    %rcx,%r10
    13d4:	0f 05                	syscall
    13d6:	c3                   	ret

00000000000013d7 <close>:
SYSCALL(close)
    13d7:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    13de:	49 89 ca             	mov    %rcx,%r10
    13e1:	0f 05                	syscall
    13e3:	c3                   	ret

00000000000013e4 <kill>:
SYSCALL(kill)
    13e4:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    13eb:	49 89 ca             	mov    %rcx,%r10
    13ee:	0f 05                	syscall
    13f0:	c3                   	ret

00000000000013f1 <exec>:
SYSCALL(exec)
    13f1:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    13f8:	49 89 ca             	mov    %rcx,%r10
    13fb:	0f 05                	syscall
    13fd:	c3                   	ret

00000000000013fe <open>:
SYSCALL(open)
    13fe:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1405:	49 89 ca             	mov    %rcx,%r10
    1408:	0f 05                	syscall
    140a:	c3                   	ret

000000000000140b <mknod>:
SYSCALL(mknod)
    140b:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1412:	49 89 ca             	mov    %rcx,%r10
    1415:	0f 05                	syscall
    1417:	c3                   	ret

0000000000001418 <unlink>:
SYSCALL(unlink)
    1418:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    141f:	49 89 ca             	mov    %rcx,%r10
    1422:	0f 05                	syscall
    1424:	c3                   	ret

0000000000001425 <fstat>:
SYSCALL(fstat)
    1425:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    142c:	49 89 ca             	mov    %rcx,%r10
    142f:	0f 05                	syscall
    1431:	c3                   	ret

0000000000001432 <link>:
SYSCALL(link)
    1432:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1439:	49 89 ca             	mov    %rcx,%r10
    143c:	0f 05                	syscall
    143e:	c3                   	ret

000000000000143f <mkdir>:
SYSCALL(mkdir)
    143f:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1446:	49 89 ca             	mov    %rcx,%r10
    1449:	0f 05                	syscall
    144b:	c3                   	ret

000000000000144c <chdir>:
SYSCALL(chdir)
    144c:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1453:	49 89 ca             	mov    %rcx,%r10
    1456:	0f 05                	syscall
    1458:	c3                   	ret

0000000000001459 <dup>:
SYSCALL(dup)
    1459:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1460:	49 89 ca             	mov    %rcx,%r10
    1463:	0f 05                	syscall
    1465:	c3                   	ret

0000000000001466 <getpid>:
SYSCALL(getpid)
    1466:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    146d:	49 89 ca             	mov    %rcx,%r10
    1470:	0f 05                	syscall
    1472:	c3                   	ret

0000000000001473 <sbrk>:
SYSCALL(sbrk)
    1473:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    147a:	49 89 ca             	mov    %rcx,%r10
    147d:	0f 05                	syscall
    147f:	c3                   	ret

0000000000001480 <sleep>:
SYSCALL(sleep)
    1480:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1487:	49 89 ca             	mov    %rcx,%r10
    148a:	0f 05                	syscall
    148c:	c3                   	ret

000000000000148d <uptime>:
SYSCALL(uptime)
    148d:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1494:	49 89 ca             	mov    %rcx,%r10
    1497:	0f 05                	syscall
    1499:	c3                   	ret

000000000000149a <traceread>:
SYSCALL(traceread)
    149a:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    14a1:	49 89 ca             	mov    %rcx,%r10
    14a4:	0f 05                	syscall
    14a6:	c3                   	ret

00000000000014a7 <vidclear>:
SYSCALL(vidclear)
    14a7:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    14ae:	49 89 ca             	mov    %rcx,%r10
    14b1:	0f 05                	syscall
    14b3:	c3                   	ret

00000000000014b4 <vidputc>:
SYSCALL(vidputc)
    14b4:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    14bb:	49 89 ca             	mov    %rcx,%r10
    14be:	0f 05                	syscall
    14c0:	c3                   	ret

00000000000014c1 <vidputs>:
SYSCALL(vidputs)
    14c1:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    14c8:	49 89 ca             	mov    %rcx,%r10
    14cb:	0f 05                	syscall
    14cd:	c3                   	ret

00000000000014ce <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    14ce:	55                   	push   %rbp
    14cf:	48 89 e5             	mov    %rsp,%rbp
    14d2:	48 83 ec 10          	sub    $0x10,%rsp
    14d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
    14d9:	89 f0                	mov    %esi,%eax
    14db:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    14de:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    14e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14e5:	ba 01 00 00 00       	mov    $0x1,%edx
    14ea:	48 89 ce             	mov    %rcx,%rsi
    14ed:	89 c7                	mov    %eax,%edi
    14ef:	48 b8 ca 13 00 00 00 	movabs $0x13ca,%rax
    14f6:	00 00 00 
    14f9:	ff d0                	call   *%rax
}
    14fb:	90                   	nop
    14fc:	c9                   	leave
    14fd:	c3                   	ret

00000000000014fe <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    14fe:	55                   	push   %rbp
    14ff:	48 89 e5             	mov    %rsp,%rbp
    1502:	48 83 ec 20          	sub    $0x20,%rsp
    1506:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1509:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    150d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1514:	eb 35                	jmp    154b <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1516:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    151a:	48 c1 e8 3c          	shr    $0x3c,%rax
    151e:	48 ba 30 1e 00 00 00 	movabs $0x1e30,%rdx
    1525:	00 00 00 
    1528:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    152c:	0f be d0             	movsbl %al,%edx
    152f:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1532:	89 d6                	mov    %edx,%esi
    1534:	89 c7                	mov    %eax,%edi
    1536:	48 b8 ce 14 00 00 00 	movabs $0x14ce,%rax
    153d:	00 00 00 
    1540:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1542:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1546:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    154b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    154e:	83 f8 0f             	cmp    $0xf,%eax
    1551:	76 c3                	jbe    1516 <print_x64+0x18>
}
    1553:	90                   	nop
    1554:	90                   	nop
    1555:	c9                   	leave
    1556:	c3                   	ret

0000000000001557 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1557:	55                   	push   %rbp
    1558:	48 89 e5             	mov    %rsp,%rbp
    155b:	48 83 ec 20          	sub    $0x20,%rsp
    155f:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1562:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1565:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    156c:	eb 36                	jmp    15a4 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    156e:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1571:	c1 e8 1c             	shr    $0x1c,%eax
    1574:	89 c2                	mov    %eax,%edx
    1576:	48 b8 30 1e 00 00 00 	movabs $0x1e30,%rax
    157d:	00 00 00 
    1580:	89 d2                	mov    %edx,%edx
    1582:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1586:	0f be d0             	movsbl %al,%edx
    1589:	8b 45 ec             	mov    -0x14(%rbp),%eax
    158c:	89 d6                	mov    %edx,%esi
    158e:	89 c7                	mov    %eax,%edi
    1590:	48 b8 ce 14 00 00 00 	movabs $0x14ce,%rax
    1597:	00 00 00 
    159a:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    159c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15a0:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15a7:	83 f8 07             	cmp    $0x7,%eax
    15aa:	76 c2                	jbe    156e <print_x32+0x17>
}
    15ac:	90                   	nop
    15ad:	90                   	nop
    15ae:	c9                   	leave
    15af:	c3                   	ret

00000000000015b0 <print_d>:

  static void
print_d(int fd, int v)
{
    15b0:	55                   	push   %rbp
    15b1:	48 89 e5             	mov    %rsp,%rbp
    15b4:	48 83 ec 30          	sub    $0x30,%rsp
    15b8:	89 7d dc             	mov    %edi,-0x24(%rbp)
    15bb:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    15be:	8b 45 d8             	mov    -0x28(%rbp),%eax
    15c1:	48 98                	cltq
    15c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    15c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    15cb:	79 04                	jns    15d1 <print_d+0x21>
    x = -x;
    15cd:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    15d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    15d8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    15dc:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    15e3:	66 66 66 
    15e6:	48 89 c8             	mov    %rcx,%rax
    15e9:	48 f7 ea             	imul   %rdx
    15ec:	48 c1 fa 02          	sar    $0x2,%rdx
    15f0:	48 89 c8             	mov    %rcx,%rax
    15f3:	48 c1 f8 3f          	sar    $0x3f,%rax
    15f7:	48 29 c2             	sub    %rax,%rdx
    15fa:	48 89 d0             	mov    %rdx,%rax
    15fd:	48 c1 e0 02          	shl    $0x2,%rax
    1601:	48 01 d0             	add    %rdx,%rax
    1604:	48 01 c0             	add    %rax,%rax
    1607:	48 29 c1             	sub    %rax,%rcx
    160a:	48 89 ca             	mov    %rcx,%rdx
    160d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1610:	8d 48 01             	lea    0x1(%rax),%ecx
    1613:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1616:	48 b9 30 1e 00 00 00 	movabs $0x1e30,%rcx
    161d:	00 00 00 
    1620:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1624:	48 98                	cltq
    1626:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    162a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    162e:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1635:	66 66 66 
    1638:	48 89 c8             	mov    %rcx,%rax
    163b:	48 f7 ea             	imul   %rdx
    163e:	48 89 d0             	mov    %rdx,%rax
    1641:	48 c1 f8 02          	sar    $0x2,%rax
    1645:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1649:	48 89 ca             	mov    %rcx,%rdx
    164c:	48 29 d0             	sub    %rdx,%rax
    164f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1653:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1658:	0f 85 7a ff ff ff    	jne    15d8 <print_d+0x28>

  if (v < 0)
    165e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1662:	79 32                	jns    1696 <print_d+0xe6>
    buf[i++] = '-';
    1664:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1667:	8d 50 01             	lea    0x1(%rax),%edx
    166a:	89 55 f4             	mov    %edx,-0xc(%rbp)
    166d:	48 98                	cltq
    166f:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1674:	eb 20                	jmp    1696 <print_d+0xe6>
    putc(fd, buf[i]);
    1676:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1679:	48 98                	cltq
    167b:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1680:	0f be d0             	movsbl %al,%edx
    1683:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1686:	89 d6                	mov    %edx,%esi
    1688:	89 c7                	mov    %eax,%edi
    168a:	48 b8 ce 14 00 00 00 	movabs $0x14ce,%rax
    1691:	00 00 00 
    1694:	ff d0                	call   *%rax
  while (--i >= 0)
    1696:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    169a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    169e:	79 d6                	jns    1676 <print_d+0xc6>
}
    16a0:	90                   	nop
    16a1:	90                   	nop
    16a2:	c9                   	leave
    16a3:	c3                   	ret

00000000000016a4 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16a4:	55                   	push   %rbp
    16a5:	48 89 e5             	mov    %rsp,%rbp
    16a8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    16af:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    16b5:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    16bc:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    16c3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    16ca:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    16d1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    16d8:	84 c0                	test   %al,%al
    16da:	74 20                	je     16fc <printf+0x58>
    16dc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    16e0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    16e4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    16e8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    16ec:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    16f0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    16f4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    16f8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    16fc:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1703:	00 00 00 
    1706:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    170d:	00 00 00 
    1710:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1714:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    171b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1722:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1729:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1730:	00 00 00 
    1733:	e9 60 03 00 00       	jmp    1a98 <printf+0x3f4>
    if (c != '%') {
    1738:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    173f:	74 24                	je     1765 <printf+0xc1>
      putc(fd, c);
    1741:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1747:	0f be d0             	movsbl %al,%edx
    174a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1750:	89 d6                	mov    %edx,%esi
    1752:	89 c7                	mov    %eax,%edi
    1754:	48 b8 ce 14 00 00 00 	movabs $0x14ce,%rax
    175b:	00 00 00 
    175e:	ff d0                	call   *%rax
      continue;
    1760:	e9 2c 03 00 00       	jmp    1a91 <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    1765:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    176c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1772:	48 63 d0             	movslq %eax,%rdx
    1775:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    177c:	48 01 d0             	add    %rdx,%rax
    177f:	0f b6 00             	movzbl (%rax),%eax
    1782:	0f be c0             	movsbl %al,%eax
    1785:	25 ff 00 00 00       	and    $0xff,%eax
    178a:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1790:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1797:	0f 84 2e 03 00 00    	je     1acb <printf+0x427>
      break;
    switch(c) {
    179d:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17a4:	0f 84 32 01 00 00    	je     18dc <printf+0x238>
    17aa:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17b1:	0f 8f a1 02 00 00    	jg     1a58 <printf+0x3b4>
    17b7:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    17be:	0f 84 d4 01 00 00    	je     1998 <printf+0x2f4>
    17c4:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    17cb:	0f 8f 87 02 00 00    	jg     1a58 <printf+0x3b4>
    17d1:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    17d8:	0f 84 5b 01 00 00    	je     1939 <printf+0x295>
    17de:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    17e5:	0f 8f 6d 02 00 00    	jg     1a58 <printf+0x3b4>
    17eb:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    17f2:	0f 84 87 00 00 00    	je     187f <printf+0x1db>
    17f8:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    17ff:	0f 8f 53 02 00 00    	jg     1a58 <printf+0x3b4>
    1805:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    180c:	0f 84 2b 02 00 00    	je     1a3d <printf+0x399>
    1812:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1819:	0f 85 39 02 00 00    	jne    1a58 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    181f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1825:	83 f8 2f             	cmp    $0x2f,%eax
    1828:	77 23                	ja     184d <printf+0x1a9>
    182a:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1831:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1837:	89 d2                	mov    %edx,%edx
    1839:	48 01 d0             	add    %rdx,%rax
    183c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1842:	83 c2 08             	add    $0x8,%edx
    1845:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    184b:	eb 12                	jmp    185f <printf+0x1bb>
    184d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1854:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1858:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    185f:	8b 00                	mov    (%rax),%eax
    1861:	0f be d0             	movsbl %al,%edx
    1864:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    186a:	89 d6                	mov    %edx,%esi
    186c:	89 c7                	mov    %eax,%edi
    186e:	48 b8 ce 14 00 00 00 	movabs $0x14ce,%rax
    1875:	00 00 00 
    1878:	ff d0                	call   *%rax
      break;
    187a:	e9 12 02 00 00       	jmp    1a91 <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    187f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1885:	83 f8 2f             	cmp    $0x2f,%eax
    1888:	77 23                	ja     18ad <printf+0x209>
    188a:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1891:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1897:	89 d2                	mov    %edx,%edx
    1899:	48 01 d0             	add    %rdx,%rax
    189c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18a2:	83 c2 08             	add    $0x8,%edx
    18a5:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18ab:	eb 12                	jmp    18bf <printf+0x21b>
    18ad:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18b4:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18b8:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18bf:	8b 10                	mov    (%rax),%edx
    18c1:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18c7:	89 d6                	mov    %edx,%esi
    18c9:	89 c7                	mov    %eax,%edi
    18cb:	48 b8 b0 15 00 00 00 	movabs $0x15b0,%rax
    18d2:	00 00 00 
    18d5:	ff d0                	call   *%rax
      break;
    18d7:	e9 b5 01 00 00       	jmp    1a91 <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    18dc:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18e2:	83 f8 2f             	cmp    $0x2f,%eax
    18e5:	77 23                	ja     190a <printf+0x266>
    18e7:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18ee:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18f4:	89 d2                	mov    %edx,%edx
    18f6:	48 01 d0             	add    %rdx,%rax
    18f9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18ff:	83 c2 08             	add    $0x8,%edx
    1902:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1908:	eb 12                	jmp    191c <printf+0x278>
    190a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1911:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1915:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    191c:	8b 10                	mov    (%rax),%edx
    191e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1924:	89 d6                	mov    %edx,%esi
    1926:	89 c7                	mov    %eax,%edi
    1928:	48 b8 57 15 00 00 00 	movabs $0x1557,%rax
    192f:	00 00 00 
    1932:	ff d0                	call   *%rax
      break;
    1934:	e9 58 01 00 00       	jmp    1a91 <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1939:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    193f:	83 f8 2f             	cmp    $0x2f,%eax
    1942:	77 23                	ja     1967 <printf+0x2c3>
    1944:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    194b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1951:	89 d2                	mov    %edx,%edx
    1953:	48 01 d0             	add    %rdx,%rax
    1956:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    195c:	83 c2 08             	add    $0x8,%edx
    195f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1965:	eb 12                	jmp    1979 <printf+0x2d5>
    1967:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    196e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1972:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1979:	48 8b 10             	mov    (%rax),%rdx
    197c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1982:	48 89 d6             	mov    %rdx,%rsi
    1985:	89 c7                	mov    %eax,%edi
    1987:	48 b8 fe 14 00 00 00 	movabs $0x14fe,%rax
    198e:	00 00 00 
    1991:	ff d0                	call   *%rax
      break;
    1993:	e9 f9 00 00 00       	jmp    1a91 <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1998:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    199e:	83 f8 2f             	cmp    $0x2f,%eax
    19a1:	77 23                	ja     19c6 <printf+0x322>
    19a3:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19aa:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19b0:	89 d2                	mov    %edx,%edx
    19b2:	48 01 d0             	add    %rdx,%rax
    19b5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19bb:	83 c2 08             	add    $0x8,%edx
    19be:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19c4:	eb 12                	jmp    19d8 <printf+0x334>
    19c6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19cd:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19d1:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19d8:	48 8b 00             	mov    (%rax),%rax
    19db:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    19e2:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    19e9:	00 
    19ea:	75 41                	jne    1a2d <printf+0x389>
        s = "(null)";
    19ec:	48 b8 26 1e 00 00 00 	movabs $0x1e26,%rax
    19f3:	00 00 00 
    19f6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    19fd:	eb 2e                	jmp    1a2d <printf+0x389>
        putc(fd, *(s++));
    19ff:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a06:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a0a:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a11:	0f b6 00             	movzbl (%rax),%eax
    1a14:	0f be d0             	movsbl %al,%edx
    1a17:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a1d:	89 d6                	mov    %edx,%esi
    1a1f:	89 c7                	mov    %eax,%edi
    1a21:	48 b8 ce 14 00 00 00 	movabs $0x14ce,%rax
    1a28:	00 00 00 
    1a2b:	ff d0                	call   *%rax
      while (*s)
    1a2d:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a34:	0f b6 00             	movzbl (%rax),%eax
    1a37:	84 c0                	test   %al,%al
    1a39:	75 c4                	jne    19ff <printf+0x35b>
      break;
    1a3b:	eb 54                	jmp    1a91 <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1a3d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a43:	be 25 00 00 00       	mov    $0x25,%esi
    1a48:	89 c7                	mov    %eax,%edi
    1a4a:	48 b8 ce 14 00 00 00 	movabs $0x14ce,%rax
    1a51:	00 00 00 
    1a54:	ff d0                	call   *%rax
      break;
    1a56:	eb 39                	jmp    1a91 <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a58:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a5e:	be 25 00 00 00       	mov    $0x25,%esi
    1a63:	89 c7                	mov    %eax,%edi
    1a65:	48 b8 ce 14 00 00 00 	movabs $0x14ce,%rax
    1a6c:	00 00 00 
    1a6f:	ff d0                	call   *%rax
      putc(fd, c);
    1a71:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a77:	0f be d0             	movsbl %al,%edx
    1a7a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a80:	89 d6                	mov    %edx,%esi
    1a82:	89 c7                	mov    %eax,%edi
    1a84:	48 b8 ce 14 00 00 00 	movabs $0x14ce,%rax
    1a8b:	00 00 00 
    1a8e:	ff d0                	call   *%rax
      break;
    1a90:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1a91:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1a98:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1a9e:	48 63 d0             	movslq %eax,%rdx
    1aa1:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1aa8:	48 01 d0             	add    %rdx,%rax
    1aab:	0f b6 00             	movzbl (%rax),%eax
    1aae:	0f be c0             	movsbl %al,%eax
    1ab1:	25 ff 00 00 00       	and    $0xff,%eax
    1ab6:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1abc:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1ac3:	0f 85 6f fc ff ff    	jne    1738 <printf+0x94>
    }
  }
}
    1ac9:	eb 01                	jmp    1acc <printf+0x428>
      break;
    1acb:	90                   	nop
}
    1acc:	90                   	nop
    1acd:	c9                   	leave
    1ace:	c3                   	ret

0000000000001acf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1acf:	55                   	push   %rbp
    1ad0:	48 89 e5             	mov    %rsp,%rbp
    1ad3:	48 83 ec 18          	sub    $0x18,%rsp
    1ad7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1adb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1adf:	48 83 e8 10          	sub    $0x10,%rax
    1ae3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1ae7:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1aee:	00 00 00 
    1af1:	48 8b 00             	mov    (%rax),%rax
    1af4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1af8:	eb 2f                	jmp    1b29 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1afa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1afe:	48 8b 00             	mov    (%rax),%rax
    1b01:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b05:	72 17                	jb     1b1e <free+0x4f>
    1b07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b0b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b0f:	72 2f                	jb     1b40 <free+0x71>
    1b11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b15:	48 8b 00             	mov    (%rax),%rax
    1b18:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b1c:	72 22                	jb     1b40 <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b22:	48 8b 00             	mov    (%rax),%rax
    1b25:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b2d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b31:	73 c7                	jae    1afa <free+0x2b>
    1b33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b37:	48 8b 00             	mov    (%rax),%rax
    1b3a:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b3e:	73 ba                	jae    1afa <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b44:	8b 40 08             	mov    0x8(%rax),%eax
    1b47:	89 c0                	mov    %eax,%eax
    1b49:	48 c1 e0 04          	shl    $0x4,%rax
    1b4d:	48 89 c2             	mov    %rax,%rdx
    1b50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b54:	48 01 c2             	add    %rax,%rdx
    1b57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b5b:	48 8b 00             	mov    (%rax),%rax
    1b5e:	48 39 c2             	cmp    %rax,%rdx
    1b61:	75 2d                	jne    1b90 <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1b63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b67:	8b 50 08             	mov    0x8(%rax),%edx
    1b6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b6e:	48 8b 00             	mov    (%rax),%rax
    1b71:	8b 40 08             	mov    0x8(%rax),%eax
    1b74:	01 c2                	add    %eax,%edx
    1b76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b7a:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b81:	48 8b 00             	mov    (%rax),%rax
    1b84:	48 8b 10             	mov    (%rax),%rdx
    1b87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b8b:	48 89 10             	mov    %rdx,(%rax)
    1b8e:	eb 0e                	jmp    1b9e <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1b90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b94:	48 8b 10             	mov    (%rax),%rdx
    1b97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b9b:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1b9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ba2:	8b 40 08             	mov    0x8(%rax),%eax
    1ba5:	89 c0                	mov    %eax,%eax
    1ba7:	48 c1 e0 04          	shl    $0x4,%rax
    1bab:	48 89 c2             	mov    %rax,%rdx
    1bae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bb2:	48 01 d0             	add    %rdx,%rax
    1bb5:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bb9:	75 27                	jne    1be2 <free+0x113>
    p->s.size += bp->s.size;
    1bbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bbf:	8b 50 08             	mov    0x8(%rax),%edx
    1bc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bc6:	8b 40 08             	mov    0x8(%rax),%eax
    1bc9:	01 c2                	add    %eax,%edx
    1bcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bcf:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1bd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bd6:	48 8b 10             	mov    (%rax),%rdx
    1bd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bdd:	48 89 10             	mov    %rdx,(%rax)
    1be0:	eb 0b                	jmp    1bed <free+0x11e>
  } else
    p->s.ptr = bp;
    1be2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1bea:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1bed:	48 ba 60 1e 00 00 00 	movabs $0x1e60,%rdx
    1bf4:	00 00 00 
    1bf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bfb:	48 89 02             	mov    %rax,(%rdx)
}
    1bfe:	90                   	nop
    1bff:	c9                   	leave
    1c00:	c3                   	ret

0000000000001c01 <morecore>:

static Header*
morecore(uint nu)
{
    1c01:	55                   	push   %rbp
    1c02:	48 89 e5             	mov    %rsp,%rbp
    1c05:	48 83 ec 20          	sub    $0x20,%rsp
    1c09:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c0c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c13:	77 07                	ja     1c1c <morecore+0x1b>
    nu = 4096;
    1c15:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c1f:	48 c1 e0 04          	shl    $0x4,%rax
    1c23:	48 89 c7             	mov    %rax,%rdi
    1c26:	48 b8 73 14 00 00 00 	movabs $0x1473,%rax
    1c2d:	00 00 00 
    1c30:	ff d0                	call   *%rax
    1c32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c36:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c3b:	75 07                	jne    1c44 <morecore+0x43>
    return 0;
    1c3d:	b8 00 00 00 00       	mov    $0x0,%eax
    1c42:	eb 36                	jmp    1c7a <morecore+0x79>
  hp = (Header*)p;
    1c44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c48:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c50:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c53:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c5a:	48 83 c0 10          	add    $0x10,%rax
    1c5e:	48 89 c7             	mov    %rax,%rdi
    1c61:	48 b8 cf 1a 00 00 00 	movabs $0x1acf,%rax
    1c68:	00 00 00 
    1c6b:	ff d0                	call   *%rax
  return freep;
    1c6d:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1c74:	00 00 00 
    1c77:	48 8b 00             	mov    (%rax),%rax
}
    1c7a:	c9                   	leave
    1c7b:	c3                   	ret

0000000000001c7c <malloc>:

void*
malloc(uint nbytes)
{
    1c7c:	55                   	push   %rbp
    1c7d:	48 89 e5             	mov    %rsp,%rbp
    1c80:	48 83 ec 30          	sub    $0x30,%rsp
    1c84:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1c87:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1c8a:	48 83 c0 0f          	add    $0xf,%rax
    1c8e:	48 c1 e8 04          	shr    $0x4,%rax
    1c92:	83 c0 01             	add    $0x1,%eax
    1c95:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1c98:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1c9f:	00 00 00 
    1ca2:	48 8b 00             	mov    (%rax),%rax
    1ca5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ca9:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cae:	75 4a                	jne    1cfa <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1cb0:	48 b8 50 1e 00 00 00 	movabs $0x1e50,%rax
    1cb7:	00 00 00 
    1cba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cbe:	48 ba 60 1e 00 00 00 	movabs $0x1e60,%rdx
    1cc5:	00 00 00 
    1cc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ccc:	48 89 02             	mov    %rax,(%rdx)
    1ccf:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1cd6:	00 00 00 
    1cd9:	48 8b 00             	mov    (%rax),%rax
    1cdc:	48 ba 50 1e 00 00 00 	movabs $0x1e50,%rdx
    1ce3:	00 00 00 
    1ce6:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1ce9:	48 b8 50 1e 00 00 00 	movabs $0x1e50,%rax
    1cf0:	00 00 00 
    1cf3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1cfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cfe:	48 8b 00             	mov    (%rax),%rax
    1d01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d09:	8b 40 08             	mov    0x8(%rax),%eax
    1d0c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1d0f:	72 65                	jb     1d76 <malloc+0xfa>
      if(p->s.size == nunits)
    1d11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d15:	8b 40 08             	mov    0x8(%rax),%eax
    1d18:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d1b:	75 10                	jne    1d2d <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1d1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d21:	48 8b 10             	mov    (%rax),%rdx
    1d24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d28:	48 89 10             	mov    %rdx,(%rax)
    1d2b:	eb 2e                	jmp    1d5b <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d31:	8b 40 08             	mov    0x8(%rax),%eax
    1d34:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d37:	89 c2                	mov    %eax,%edx
    1d39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d3d:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d44:	8b 40 08             	mov    0x8(%rax),%eax
    1d47:	89 c0                	mov    %eax,%eax
    1d49:	48 c1 e0 04          	shl    $0x4,%rax
    1d4d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d55:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d58:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d5b:	48 ba 60 1e 00 00 00 	movabs $0x1e60,%rdx
    1d62:	00 00 00 
    1d65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d69:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d70:	48 83 c0 10          	add    $0x10,%rax
    1d74:	eb 4e                	jmp    1dc4 <malloc+0x148>
    }
    if(p == freep)
    1d76:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1d7d:	00 00 00 
    1d80:	48 8b 00             	mov    (%rax),%rax
    1d83:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1d87:	75 23                	jne    1dac <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1d89:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d8c:	89 c7                	mov    %eax,%edi
    1d8e:	48 b8 01 1c 00 00 00 	movabs $0x1c01,%rax
    1d95:	00 00 00 
    1d98:	ff d0                	call   *%rax
    1d9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1d9e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1da3:	75 07                	jne    1dac <malloc+0x130>
        return 0;
    1da5:	b8 00 00 00 00       	mov    $0x0,%eax
    1daa:	eb 18                	jmp    1dc4 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1db0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1db4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1db8:	48 8b 00             	mov    (%rax),%rax
    1dbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1dbf:	e9 41 ff ff ff       	jmp    1d05 <malloc+0x89>
  }
}
    1dc4:	c9                   	leave
    1dc5:	c3                   	ret

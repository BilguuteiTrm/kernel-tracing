
_ln:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 10          	sub    $0x10,%rsp
    1008:	89 7d fc             	mov    %edi,-0x4(%rbp)
    100b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(argc != 3){
    100f:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
    1013:	74 2f                	je     1044 <main+0x44>
    printf(2, "Usage: ln old new\n");
    1015:	48 b8 04 1e 00 00 00 	movabs $0x1e04,%rax
    101c:	00 00 00 
    101f:	48 89 c6             	mov    %rax,%rsi
    1022:	bf 02 00 00 00       	mov    $0x2,%edi
    1027:	b8 00 00 00 00       	mov    $0x0,%eax
    102c:	48 ba e2 16 00 00 00 	movabs $0x16e2,%rdx
    1033:	00 00 00 
    1036:	ff d2                	call   *%rdx
    exit();
    1038:	48 b8 d4 13 00 00 00 	movabs $0x13d4,%rax
    103f:	00 00 00 
    1042:	ff d0                	call   *%rax
  }
  if(link(argv[1], argv[2]) < 0)
    1044:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1048:	48 83 c0 10          	add    $0x10,%rax
    104c:	48 8b 10             	mov    (%rax),%rdx
    104f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1053:	48 83 c0 08          	add    $0x8,%rax
    1057:	48 8b 00             	mov    (%rax),%rax
    105a:	48 89 d6             	mov    %rdx,%rsi
    105d:	48 89 c7             	mov    %rax,%rdi
    1060:	48 b8 70 14 00 00 00 	movabs $0x1470,%rax
    1067:	00 00 00 
    106a:	ff d0                	call   *%rax
    106c:	85 c0                	test   %eax,%eax
    106e:	79 3d                	jns    10ad <main+0xad>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
    1070:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1074:	48 83 c0 10          	add    $0x10,%rax
    1078:	48 8b 10             	mov    (%rax),%rdx
    107b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    107f:	48 83 c0 08          	add    $0x8,%rax
    1083:	48 8b 00             	mov    (%rax),%rax
    1086:	48 be 17 1e 00 00 00 	movabs $0x1e17,%rsi
    108d:	00 00 00 
    1090:	48 89 d1             	mov    %rdx,%rcx
    1093:	48 89 c2             	mov    %rax,%rdx
    1096:	bf 02 00 00 00       	mov    $0x2,%edi
    109b:	b8 00 00 00 00       	mov    $0x0,%eax
    10a0:	49 b8 e2 16 00 00 00 	movabs $0x16e2,%r8
    10a7:	00 00 00 
    10aa:	41 ff d0             	call   *%r8
  exit();
    10ad:	48 b8 d4 13 00 00 00 	movabs $0x13d4,%rax
    10b4:	00 00 00 
    10b7:	ff d0                	call   *%rax

00000000000010b9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10b9:	55                   	push   %rbp
    10ba:	48 89 e5             	mov    %rsp,%rbp
    10bd:	48 83 ec 10          	sub    $0x10,%rsp
    10c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10c5:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10c8:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10cb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10cf:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10d5:	48 89 ce             	mov    %rcx,%rsi
    10d8:	48 89 f7             	mov    %rsi,%rdi
    10db:	89 d1                	mov    %edx,%ecx
    10dd:	fc                   	cld
    10de:	f3 aa                	rep stos %al,(%rdi)
    10e0:	89 ca                	mov    %ecx,%edx
    10e2:	48 89 fe             	mov    %rdi,%rsi
    10e5:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10e9:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10ec:	90                   	nop
    10ed:	c9                   	leave
    10ee:	c3                   	ret

00000000000010ef <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10ef:	55                   	push   %rbp
    10f0:	48 89 e5             	mov    %rsp,%rbp
    10f3:	48 83 ec 20          	sub    $0x20,%rsp
    10f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    10fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    10ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1103:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1107:	90                   	nop
    1108:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    110c:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1110:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1114:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1118:	48 8d 48 01          	lea    0x1(%rax),%rcx
    111c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1120:	0f b6 12             	movzbl (%rdx),%edx
    1123:	88 10                	mov    %dl,(%rax)
    1125:	0f b6 00             	movzbl (%rax),%eax
    1128:	84 c0                	test   %al,%al
    112a:	75 dc                	jne    1108 <strcpy+0x19>
    ;
  return os;
    112c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1130:	c9                   	leave
    1131:	c3                   	ret

0000000000001132 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1132:	55                   	push   %rbp
    1133:	48 89 e5             	mov    %rsp,%rbp
    1136:	48 83 ec 10          	sub    $0x10,%rsp
    113a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    113e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1142:	eb 0a                	jmp    114e <strcmp+0x1c>
    p++, q++;
    1144:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1149:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    114e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1152:	0f b6 00             	movzbl (%rax),%eax
    1155:	84 c0                	test   %al,%al
    1157:	74 12                	je     116b <strcmp+0x39>
    1159:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    115d:	0f b6 10             	movzbl (%rax),%edx
    1160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1164:	0f b6 00             	movzbl (%rax),%eax
    1167:	38 c2                	cmp    %al,%dl
    1169:	74 d9                	je     1144 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    116b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    116f:	0f b6 00             	movzbl (%rax),%eax
    1172:	0f b6 d0             	movzbl %al,%edx
    1175:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1179:	0f b6 00             	movzbl (%rax),%eax
    117c:	0f b6 c0             	movzbl %al,%eax
    117f:	29 c2                	sub    %eax,%edx
    1181:	89 d0                	mov    %edx,%eax
}
    1183:	c9                   	leave
    1184:	c3                   	ret

0000000000001185 <strlen>:

uint
strlen(char *s)
{
    1185:	55                   	push   %rbp
    1186:	48 89 e5             	mov    %rsp,%rbp
    1189:	48 83 ec 18          	sub    $0x18,%rsp
    118d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1191:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1198:	eb 04                	jmp    119e <strlen+0x19>
    119a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    119e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11a1:	48 63 d0             	movslq %eax,%rdx
    11a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11a8:	48 01 d0             	add    %rdx,%rax
    11ab:	0f b6 00             	movzbl (%rax),%eax
    11ae:	84 c0                	test   %al,%al
    11b0:	75 e8                	jne    119a <strlen+0x15>
    ;
  return n;
    11b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11b5:	c9                   	leave
    11b6:	c3                   	ret

00000000000011b7 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11b7:	55                   	push   %rbp
    11b8:	48 89 e5             	mov    %rsp,%rbp
    11bb:	48 83 ec 10          	sub    $0x10,%rsp
    11bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11c3:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11c6:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11c9:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11cc:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11d3:	89 ce                	mov    %ecx,%esi
    11d5:	48 89 c7             	mov    %rax,%rdi
    11d8:	48 b8 b9 10 00 00 00 	movabs $0x10b9,%rax
    11df:	00 00 00 
    11e2:	ff d0                	call   *%rax
  return dst;
    11e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11e8:	c9                   	leave
    11e9:	c3                   	ret

00000000000011ea <strchr>:

char*
strchr(const char *s, char c)
{
    11ea:	55                   	push   %rbp
    11eb:	48 89 e5             	mov    %rsp,%rbp
    11ee:	48 83 ec 10          	sub    $0x10,%rsp
    11f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11f6:	89 f0                	mov    %esi,%eax
    11f8:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    11fb:	eb 17                	jmp    1214 <strchr+0x2a>
    if(*s == c)
    11fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1201:	0f b6 00             	movzbl (%rax),%eax
    1204:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1207:	75 06                	jne    120f <strchr+0x25>
      return (char*)s;
    1209:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    120d:	eb 15                	jmp    1224 <strchr+0x3a>
  for(; *s; s++)
    120f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1214:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1218:	0f b6 00             	movzbl (%rax),%eax
    121b:	84 c0                	test   %al,%al
    121d:	75 de                	jne    11fd <strchr+0x13>
  return 0;
    121f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1224:	c9                   	leave
    1225:	c3                   	ret

0000000000001226 <gets>:

char*
gets(char *buf, int max)
{
    1226:	55                   	push   %rbp
    1227:	48 89 e5             	mov    %rsp,%rbp
    122a:	48 83 ec 20          	sub    $0x20,%rsp
    122e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1232:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1235:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    123c:	eb 4f                	jmp    128d <gets+0x67>
    cc = read(0, &c, 1);
    123e:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1242:	ba 01 00 00 00       	mov    $0x1,%edx
    1247:	48 89 c6             	mov    %rax,%rsi
    124a:	bf 00 00 00 00       	mov    $0x0,%edi
    124f:	48 b8 fb 13 00 00 00 	movabs $0x13fb,%rax
    1256:	00 00 00 
    1259:	ff d0                	call   *%rax
    125b:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    125e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1262:	7e 36                	jle    129a <gets+0x74>
      break;
    buf[i++] = c;
    1264:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1267:	8d 50 01             	lea    0x1(%rax),%edx
    126a:	89 55 fc             	mov    %edx,-0x4(%rbp)
    126d:	48 63 d0             	movslq %eax,%rdx
    1270:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1274:	48 01 c2             	add    %rax,%rdx
    1277:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    127b:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    127d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1281:	3c 0a                	cmp    $0xa,%al
    1283:	74 16                	je     129b <gets+0x75>
    1285:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1289:	3c 0d                	cmp    $0xd,%al
    128b:	74 0e                	je     129b <gets+0x75>
  for(i=0; i+1 < max; ){
    128d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1290:	83 c0 01             	add    $0x1,%eax
    1293:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1296:	7f a6                	jg     123e <gets+0x18>
    1298:	eb 01                	jmp    129b <gets+0x75>
      break;
    129a:	90                   	nop
      break;
  }
  buf[i] = '\0';
    129b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    129e:	48 63 d0             	movslq %eax,%rdx
    12a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12a5:	48 01 d0             	add    %rdx,%rax
    12a8:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12af:	c9                   	leave
    12b0:	c3                   	ret

00000000000012b1 <stat>:

int
stat(char *n, struct stat *st)
{
    12b1:	55                   	push   %rbp
    12b2:	48 89 e5             	mov    %rsp,%rbp
    12b5:	48 83 ec 20          	sub    $0x20,%rsp
    12b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12c5:	be 00 00 00 00       	mov    $0x0,%esi
    12ca:	48 89 c7             	mov    %rax,%rdi
    12cd:	48 b8 3c 14 00 00 00 	movabs $0x143c,%rax
    12d4:	00 00 00 
    12d7:	ff d0                	call   *%rax
    12d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    12e0:	79 07                	jns    12e9 <stat+0x38>
    return -1;
    12e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12e7:	eb 2f                	jmp    1318 <stat+0x67>
  r = fstat(fd, st);
    12e9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12f0:	48 89 d6             	mov    %rdx,%rsi
    12f3:	89 c7                	mov    %eax,%edi
    12f5:	48 b8 63 14 00 00 00 	movabs $0x1463,%rax
    12fc:	00 00 00 
    12ff:	ff d0                	call   *%rax
    1301:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1304:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1307:	89 c7                	mov    %eax,%edi
    1309:	48 b8 15 14 00 00 00 	movabs $0x1415,%rax
    1310:	00 00 00 
    1313:	ff d0                	call   *%rax
  return r;
    1315:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1318:	c9                   	leave
    1319:	c3                   	ret

000000000000131a <atoi>:

int
atoi(const char *s)
{
    131a:	55                   	push   %rbp
    131b:	48 89 e5             	mov    %rsp,%rbp
    131e:	48 83 ec 18          	sub    $0x18,%rsp
    1322:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1326:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    132d:	eb 28                	jmp    1357 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    132f:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1332:	89 d0                	mov    %edx,%eax
    1334:	c1 e0 02             	shl    $0x2,%eax
    1337:	01 d0                	add    %edx,%eax
    1339:	01 c0                	add    %eax,%eax
    133b:	89 c1                	mov    %eax,%ecx
    133d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1341:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1345:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1349:	0f b6 00             	movzbl (%rax),%eax
    134c:	0f be c0             	movsbl %al,%eax
    134f:	01 c8                	add    %ecx,%eax
    1351:	83 e8 30             	sub    $0x30,%eax
    1354:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1357:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    135b:	0f b6 00             	movzbl (%rax),%eax
    135e:	3c 2f                	cmp    $0x2f,%al
    1360:	7e 0b                	jle    136d <atoi+0x53>
    1362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1366:	0f b6 00             	movzbl (%rax),%eax
    1369:	3c 39                	cmp    $0x39,%al
    136b:	7e c2                	jle    132f <atoi+0x15>
  return n;
    136d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1370:	c9                   	leave
    1371:	c3                   	ret

0000000000001372 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1372:	55                   	push   %rbp
    1373:	48 89 e5             	mov    %rsp,%rbp
    1376:	48 83 ec 28          	sub    $0x28,%rsp
    137a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    137e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1382:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1389:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    138d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1391:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1395:	eb 1d                	jmp    13b4 <memmove+0x42>
    *dst++ = *src++;
    1397:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    139b:	48 8d 42 01          	lea    0x1(%rdx),%rax
    139f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13a7:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13ab:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13af:	0f b6 12             	movzbl (%rdx),%edx
    13b2:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13b7:	8d 50 ff             	lea    -0x1(%rax),%edx
    13ba:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13bd:	85 c0                	test   %eax,%eax
    13bf:	7f d6                	jg     1397 <memmove+0x25>
  return vdst;
    13c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13c5:	c9                   	leave
    13c6:	c3                   	ret

00000000000013c7 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13c7:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13ce:	49 89 ca             	mov    %rcx,%r10
    13d1:	0f 05                	syscall
    13d3:	c3                   	ret

00000000000013d4 <exit>:
SYSCALL(exit)
    13d4:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    13db:	49 89 ca             	mov    %rcx,%r10
    13de:	0f 05                	syscall
    13e0:	c3                   	ret

00000000000013e1 <wait>:
SYSCALL(wait)
    13e1:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    13e8:	49 89 ca             	mov    %rcx,%r10
    13eb:	0f 05                	syscall
    13ed:	c3                   	ret

00000000000013ee <pipe>:
SYSCALL(pipe)
    13ee:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    13f5:	49 89 ca             	mov    %rcx,%r10
    13f8:	0f 05                	syscall
    13fa:	c3                   	ret

00000000000013fb <read>:
SYSCALL(read)
    13fb:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1402:	49 89 ca             	mov    %rcx,%r10
    1405:	0f 05                	syscall
    1407:	c3                   	ret

0000000000001408 <write>:
SYSCALL(write)
    1408:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    140f:	49 89 ca             	mov    %rcx,%r10
    1412:	0f 05                	syscall
    1414:	c3                   	ret

0000000000001415 <close>:
SYSCALL(close)
    1415:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    141c:	49 89 ca             	mov    %rcx,%r10
    141f:	0f 05                	syscall
    1421:	c3                   	ret

0000000000001422 <kill>:
SYSCALL(kill)
    1422:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1429:	49 89 ca             	mov    %rcx,%r10
    142c:	0f 05                	syscall
    142e:	c3                   	ret

000000000000142f <exec>:
SYSCALL(exec)
    142f:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1436:	49 89 ca             	mov    %rcx,%r10
    1439:	0f 05                	syscall
    143b:	c3                   	ret

000000000000143c <open>:
SYSCALL(open)
    143c:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1443:	49 89 ca             	mov    %rcx,%r10
    1446:	0f 05                	syscall
    1448:	c3                   	ret

0000000000001449 <mknod>:
SYSCALL(mknod)
    1449:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1450:	49 89 ca             	mov    %rcx,%r10
    1453:	0f 05                	syscall
    1455:	c3                   	ret

0000000000001456 <unlink>:
SYSCALL(unlink)
    1456:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    145d:	49 89 ca             	mov    %rcx,%r10
    1460:	0f 05                	syscall
    1462:	c3                   	ret

0000000000001463 <fstat>:
SYSCALL(fstat)
    1463:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    146a:	49 89 ca             	mov    %rcx,%r10
    146d:	0f 05                	syscall
    146f:	c3                   	ret

0000000000001470 <link>:
SYSCALL(link)
    1470:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1477:	49 89 ca             	mov    %rcx,%r10
    147a:	0f 05                	syscall
    147c:	c3                   	ret

000000000000147d <mkdir>:
SYSCALL(mkdir)
    147d:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1484:	49 89 ca             	mov    %rcx,%r10
    1487:	0f 05                	syscall
    1489:	c3                   	ret

000000000000148a <chdir>:
SYSCALL(chdir)
    148a:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1491:	49 89 ca             	mov    %rcx,%r10
    1494:	0f 05                	syscall
    1496:	c3                   	ret

0000000000001497 <dup>:
SYSCALL(dup)
    1497:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    149e:	49 89 ca             	mov    %rcx,%r10
    14a1:	0f 05                	syscall
    14a3:	c3                   	ret

00000000000014a4 <getpid>:
SYSCALL(getpid)
    14a4:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14ab:	49 89 ca             	mov    %rcx,%r10
    14ae:	0f 05                	syscall
    14b0:	c3                   	ret

00000000000014b1 <sbrk>:
SYSCALL(sbrk)
    14b1:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14b8:	49 89 ca             	mov    %rcx,%r10
    14bb:	0f 05                	syscall
    14bd:	c3                   	ret

00000000000014be <sleep>:
SYSCALL(sleep)
    14be:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14c5:	49 89 ca             	mov    %rcx,%r10
    14c8:	0f 05                	syscall
    14ca:	c3                   	ret

00000000000014cb <uptime>:
SYSCALL(uptime)
    14cb:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14d2:	49 89 ca             	mov    %rcx,%r10
    14d5:	0f 05                	syscall
    14d7:	c3                   	ret

00000000000014d8 <traceread>:
SYSCALL(traceread)
    14d8:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    14df:	49 89 ca             	mov    %rcx,%r10
    14e2:	0f 05                	syscall
    14e4:	c3                   	ret

00000000000014e5 <vidclear>:
SYSCALL(vidclear)
    14e5:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    14ec:	49 89 ca             	mov    %rcx,%r10
    14ef:	0f 05                	syscall
    14f1:	c3                   	ret

00000000000014f2 <vidputc>:
SYSCALL(vidputc)
    14f2:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    14f9:	49 89 ca             	mov    %rcx,%r10
    14fc:	0f 05                	syscall
    14fe:	c3                   	ret

00000000000014ff <vidputs>:
SYSCALL(vidputs)
    14ff:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    1506:	49 89 ca             	mov    %rcx,%r10
    1509:	0f 05                	syscall
    150b:	c3                   	ret

000000000000150c <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    150c:	55                   	push   %rbp
    150d:	48 89 e5             	mov    %rsp,%rbp
    1510:	48 83 ec 10          	sub    $0x10,%rsp
    1514:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1517:	89 f0                	mov    %esi,%eax
    1519:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    151c:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1520:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1523:	ba 01 00 00 00       	mov    $0x1,%edx
    1528:	48 89 ce             	mov    %rcx,%rsi
    152b:	89 c7                	mov    %eax,%edi
    152d:	48 b8 08 14 00 00 00 	movabs $0x1408,%rax
    1534:	00 00 00 
    1537:	ff d0                	call   *%rax
}
    1539:	90                   	nop
    153a:	c9                   	leave
    153b:	c3                   	ret

000000000000153c <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    153c:	55                   	push   %rbp
    153d:	48 89 e5             	mov    %rsp,%rbp
    1540:	48 83 ec 20          	sub    $0x20,%rsp
    1544:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1547:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    154b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1552:	eb 35                	jmp    1589 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1554:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1558:	48 c1 e8 3c          	shr    $0x3c,%rax
    155c:	48 ba 40 1e 00 00 00 	movabs $0x1e40,%rdx
    1563:	00 00 00 
    1566:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    156a:	0f be d0             	movsbl %al,%edx
    156d:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1570:	89 d6                	mov    %edx,%esi
    1572:	89 c7                	mov    %eax,%edi
    1574:	48 b8 0c 15 00 00 00 	movabs $0x150c,%rax
    157b:	00 00 00 
    157e:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1580:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1584:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1589:	8b 45 fc             	mov    -0x4(%rbp),%eax
    158c:	83 f8 0f             	cmp    $0xf,%eax
    158f:	76 c3                	jbe    1554 <print_x64+0x18>
}
    1591:	90                   	nop
    1592:	90                   	nop
    1593:	c9                   	leave
    1594:	c3                   	ret

0000000000001595 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1595:	55                   	push   %rbp
    1596:	48 89 e5             	mov    %rsp,%rbp
    1599:	48 83 ec 20          	sub    $0x20,%rsp
    159d:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15a0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15aa:	eb 36                	jmp    15e2 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    15ac:	8b 45 e8             	mov    -0x18(%rbp),%eax
    15af:	c1 e8 1c             	shr    $0x1c,%eax
    15b2:	89 c2                	mov    %eax,%edx
    15b4:	48 b8 40 1e 00 00 00 	movabs $0x1e40,%rax
    15bb:	00 00 00 
    15be:	89 d2                	mov    %edx,%edx
    15c0:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15c4:	0f be d0             	movsbl %al,%edx
    15c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15ca:	89 d6                	mov    %edx,%esi
    15cc:	89 c7                	mov    %eax,%edi
    15ce:	48 b8 0c 15 00 00 00 	movabs $0x150c,%rax
    15d5:	00 00 00 
    15d8:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15da:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15de:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15e5:	83 f8 07             	cmp    $0x7,%eax
    15e8:	76 c2                	jbe    15ac <print_x32+0x17>
}
    15ea:	90                   	nop
    15eb:	90                   	nop
    15ec:	c9                   	leave
    15ed:	c3                   	ret

00000000000015ee <print_d>:

  static void
print_d(int fd, int v)
{
    15ee:	55                   	push   %rbp
    15ef:	48 89 e5             	mov    %rsp,%rbp
    15f2:	48 83 ec 30          	sub    $0x30,%rsp
    15f6:	89 7d dc             	mov    %edi,-0x24(%rbp)
    15f9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    15fc:	8b 45 d8             	mov    -0x28(%rbp),%eax
    15ff:	48 98                	cltq
    1601:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1605:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1609:	79 04                	jns    160f <print_d+0x21>
    x = -x;
    160b:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    160f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1616:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    161a:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1621:	66 66 66 
    1624:	48 89 c8             	mov    %rcx,%rax
    1627:	48 f7 ea             	imul   %rdx
    162a:	48 c1 fa 02          	sar    $0x2,%rdx
    162e:	48 89 c8             	mov    %rcx,%rax
    1631:	48 c1 f8 3f          	sar    $0x3f,%rax
    1635:	48 29 c2             	sub    %rax,%rdx
    1638:	48 89 d0             	mov    %rdx,%rax
    163b:	48 c1 e0 02          	shl    $0x2,%rax
    163f:	48 01 d0             	add    %rdx,%rax
    1642:	48 01 c0             	add    %rax,%rax
    1645:	48 29 c1             	sub    %rax,%rcx
    1648:	48 89 ca             	mov    %rcx,%rdx
    164b:	8b 45 f4             	mov    -0xc(%rbp),%eax
    164e:	8d 48 01             	lea    0x1(%rax),%ecx
    1651:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1654:	48 b9 40 1e 00 00 00 	movabs $0x1e40,%rcx
    165b:	00 00 00 
    165e:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1662:	48 98                	cltq
    1664:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1668:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    166c:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1673:	66 66 66 
    1676:	48 89 c8             	mov    %rcx,%rax
    1679:	48 f7 ea             	imul   %rdx
    167c:	48 89 d0             	mov    %rdx,%rax
    167f:	48 c1 f8 02          	sar    $0x2,%rax
    1683:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1687:	48 89 ca             	mov    %rcx,%rdx
    168a:	48 29 d0             	sub    %rdx,%rax
    168d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1691:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1696:	0f 85 7a ff ff ff    	jne    1616 <print_d+0x28>

  if (v < 0)
    169c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16a0:	79 32                	jns    16d4 <print_d+0xe6>
    buf[i++] = '-';
    16a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16a5:	8d 50 01             	lea    0x1(%rax),%edx
    16a8:	89 55 f4             	mov    %edx,-0xc(%rbp)
    16ab:	48 98                	cltq
    16ad:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16b2:	eb 20                	jmp    16d4 <print_d+0xe6>
    putc(fd, buf[i]);
    16b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16b7:	48 98                	cltq
    16b9:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16be:	0f be d0             	movsbl %al,%edx
    16c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16c4:	89 d6                	mov    %edx,%esi
    16c6:	89 c7                	mov    %eax,%edi
    16c8:	48 b8 0c 15 00 00 00 	movabs $0x150c,%rax
    16cf:	00 00 00 
    16d2:	ff d0                	call   *%rax
  while (--i >= 0)
    16d4:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16dc:	79 d6                	jns    16b4 <print_d+0xc6>
}
    16de:	90                   	nop
    16df:	90                   	nop
    16e0:	c9                   	leave
    16e1:	c3                   	ret

00000000000016e2 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16e2:	55                   	push   %rbp
    16e3:	48 89 e5             	mov    %rsp,%rbp
    16e6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    16ed:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    16f3:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    16fa:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1701:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1708:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    170f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1716:	84 c0                	test   %al,%al
    1718:	74 20                	je     173a <printf+0x58>
    171a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    171e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1722:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1726:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    172a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    172e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1732:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1736:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    173a:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1741:	00 00 00 
    1744:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    174b:	00 00 00 
    174e:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1752:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1759:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1760:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1767:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    176e:	00 00 00 
    1771:	e9 60 03 00 00       	jmp    1ad6 <printf+0x3f4>
    if (c != '%') {
    1776:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    177d:	74 24                	je     17a3 <printf+0xc1>
      putc(fd, c);
    177f:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1785:	0f be d0             	movsbl %al,%edx
    1788:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    178e:	89 d6                	mov    %edx,%esi
    1790:	89 c7                	mov    %eax,%edi
    1792:	48 b8 0c 15 00 00 00 	movabs $0x150c,%rax
    1799:	00 00 00 
    179c:	ff d0                	call   *%rax
      continue;
    179e:	e9 2c 03 00 00       	jmp    1acf <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    17a3:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17aa:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17b0:	48 63 d0             	movslq %eax,%rdx
    17b3:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17ba:	48 01 d0             	add    %rdx,%rax
    17bd:	0f b6 00             	movzbl (%rax),%eax
    17c0:	0f be c0             	movsbl %al,%eax
    17c3:	25 ff 00 00 00       	and    $0xff,%eax
    17c8:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17ce:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17d5:	0f 84 2e 03 00 00    	je     1b09 <printf+0x427>
      break;
    switch(c) {
    17db:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17e2:	0f 84 32 01 00 00    	je     191a <printf+0x238>
    17e8:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17ef:	0f 8f a1 02 00 00    	jg     1a96 <printf+0x3b4>
    17f5:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    17fc:	0f 84 d4 01 00 00    	je     19d6 <printf+0x2f4>
    1802:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1809:	0f 8f 87 02 00 00    	jg     1a96 <printf+0x3b4>
    180f:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1816:	0f 84 5b 01 00 00    	je     1977 <printf+0x295>
    181c:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1823:	0f 8f 6d 02 00 00    	jg     1a96 <printf+0x3b4>
    1829:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1830:	0f 84 87 00 00 00    	je     18bd <printf+0x1db>
    1836:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    183d:	0f 8f 53 02 00 00    	jg     1a96 <printf+0x3b4>
    1843:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    184a:	0f 84 2b 02 00 00    	je     1a7b <printf+0x399>
    1850:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1857:	0f 85 39 02 00 00    	jne    1a96 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    185d:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1863:	83 f8 2f             	cmp    $0x2f,%eax
    1866:	77 23                	ja     188b <printf+0x1a9>
    1868:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    186f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1875:	89 d2                	mov    %edx,%edx
    1877:	48 01 d0             	add    %rdx,%rax
    187a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1880:	83 c2 08             	add    $0x8,%edx
    1883:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1889:	eb 12                	jmp    189d <printf+0x1bb>
    188b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1892:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1896:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    189d:	8b 00                	mov    (%rax),%eax
    189f:	0f be d0             	movsbl %al,%edx
    18a2:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18a8:	89 d6                	mov    %edx,%esi
    18aa:	89 c7                	mov    %eax,%edi
    18ac:	48 b8 0c 15 00 00 00 	movabs $0x150c,%rax
    18b3:	00 00 00 
    18b6:	ff d0                	call   *%rax
      break;
    18b8:	e9 12 02 00 00       	jmp    1acf <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    18bd:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18c3:	83 f8 2f             	cmp    $0x2f,%eax
    18c6:	77 23                	ja     18eb <printf+0x209>
    18c8:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18cf:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18d5:	89 d2                	mov    %edx,%edx
    18d7:	48 01 d0             	add    %rdx,%rax
    18da:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18e0:	83 c2 08             	add    $0x8,%edx
    18e3:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18e9:	eb 12                	jmp    18fd <printf+0x21b>
    18eb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18f2:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18f6:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18fd:	8b 10                	mov    (%rax),%edx
    18ff:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1905:	89 d6                	mov    %edx,%esi
    1907:	89 c7                	mov    %eax,%edi
    1909:	48 b8 ee 15 00 00 00 	movabs $0x15ee,%rax
    1910:	00 00 00 
    1913:	ff d0                	call   *%rax
      break;
    1915:	e9 b5 01 00 00       	jmp    1acf <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    191a:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1920:	83 f8 2f             	cmp    $0x2f,%eax
    1923:	77 23                	ja     1948 <printf+0x266>
    1925:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    192c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1932:	89 d2                	mov    %edx,%edx
    1934:	48 01 d0             	add    %rdx,%rax
    1937:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    193d:	83 c2 08             	add    $0x8,%edx
    1940:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1946:	eb 12                	jmp    195a <printf+0x278>
    1948:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    194f:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1953:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    195a:	8b 10                	mov    (%rax),%edx
    195c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1962:	89 d6                	mov    %edx,%esi
    1964:	89 c7                	mov    %eax,%edi
    1966:	48 b8 95 15 00 00 00 	movabs $0x1595,%rax
    196d:	00 00 00 
    1970:	ff d0                	call   *%rax
      break;
    1972:	e9 58 01 00 00       	jmp    1acf <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1977:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    197d:	83 f8 2f             	cmp    $0x2f,%eax
    1980:	77 23                	ja     19a5 <printf+0x2c3>
    1982:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1989:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    198f:	89 d2                	mov    %edx,%edx
    1991:	48 01 d0             	add    %rdx,%rax
    1994:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    199a:	83 c2 08             	add    $0x8,%edx
    199d:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19a3:	eb 12                	jmp    19b7 <printf+0x2d5>
    19a5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19ac:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19b0:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19b7:	48 8b 10             	mov    (%rax),%rdx
    19ba:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19c0:	48 89 d6             	mov    %rdx,%rsi
    19c3:	89 c7                	mov    %eax,%edi
    19c5:	48 b8 3c 15 00 00 00 	movabs $0x153c,%rax
    19cc:	00 00 00 
    19cf:	ff d0                	call   *%rax
      break;
    19d1:	e9 f9 00 00 00       	jmp    1acf <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19d6:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19dc:	83 f8 2f             	cmp    $0x2f,%eax
    19df:	77 23                	ja     1a04 <printf+0x322>
    19e1:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19e8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19ee:	89 d2                	mov    %edx,%edx
    19f0:	48 01 d0             	add    %rdx,%rax
    19f3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19f9:	83 c2 08             	add    $0x8,%edx
    19fc:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a02:	eb 12                	jmp    1a16 <printf+0x334>
    1a04:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a0b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a0f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a16:	48 8b 00             	mov    (%rax),%rax
    1a19:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1a20:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a27:	00 
    1a28:	75 41                	jne    1a6b <printf+0x389>
        s = "(null)";
    1a2a:	48 b8 2b 1e 00 00 00 	movabs $0x1e2b,%rax
    1a31:	00 00 00 
    1a34:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a3b:	eb 2e                	jmp    1a6b <printf+0x389>
        putc(fd, *(s++));
    1a3d:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a44:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a48:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a4f:	0f b6 00             	movzbl (%rax),%eax
    1a52:	0f be d0             	movsbl %al,%edx
    1a55:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a5b:	89 d6                	mov    %edx,%esi
    1a5d:	89 c7                	mov    %eax,%edi
    1a5f:	48 b8 0c 15 00 00 00 	movabs $0x150c,%rax
    1a66:	00 00 00 
    1a69:	ff d0                	call   *%rax
      while (*s)
    1a6b:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a72:	0f b6 00             	movzbl (%rax),%eax
    1a75:	84 c0                	test   %al,%al
    1a77:	75 c4                	jne    1a3d <printf+0x35b>
      break;
    1a79:	eb 54                	jmp    1acf <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1a7b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a81:	be 25 00 00 00       	mov    $0x25,%esi
    1a86:	89 c7                	mov    %eax,%edi
    1a88:	48 b8 0c 15 00 00 00 	movabs $0x150c,%rax
    1a8f:	00 00 00 
    1a92:	ff d0                	call   *%rax
      break;
    1a94:	eb 39                	jmp    1acf <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a96:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a9c:	be 25 00 00 00       	mov    $0x25,%esi
    1aa1:	89 c7                	mov    %eax,%edi
    1aa3:	48 b8 0c 15 00 00 00 	movabs $0x150c,%rax
    1aaa:	00 00 00 
    1aad:	ff d0                	call   *%rax
      putc(fd, c);
    1aaf:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1ab5:	0f be d0             	movsbl %al,%edx
    1ab8:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1abe:	89 d6                	mov    %edx,%esi
    1ac0:	89 c7                	mov    %eax,%edi
    1ac2:	48 b8 0c 15 00 00 00 	movabs $0x150c,%rax
    1ac9:	00 00 00 
    1acc:	ff d0                	call   *%rax
      break;
    1ace:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1acf:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ad6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1adc:	48 63 d0             	movslq %eax,%rdx
    1adf:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ae6:	48 01 d0             	add    %rdx,%rax
    1ae9:	0f b6 00             	movzbl (%rax),%eax
    1aec:	0f be c0             	movsbl %al,%eax
    1aef:	25 ff 00 00 00       	and    $0xff,%eax
    1af4:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1afa:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1b01:	0f 85 6f fc ff ff    	jne    1776 <printf+0x94>
    }
  }
}
    1b07:	eb 01                	jmp    1b0a <printf+0x428>
      break;
    1b09:	90                   	nop
}
    1b0a:	90                   	nop
    1b0b:	c9                   	leave
    1b0c:	c3                   	ret

0000000000001b0d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1b0d:	55                   	push   %rbp
    1b0e:	48 89 e5             	mov    %rsp,%rbp
    1b11:	48 83 ec 18          	sub    $0x18,%rsp
    1b15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1b19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b1d:	48 83 e8 10          	sub    $0x10,%rax
    1b21:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b25:	48 b8 70 1e 00 00 00 	movabs $0x1e70,%rax
    1b2c:	00 00 00 
    1b2f:	48 8b 00             	mov    (%rax),%rax
    1b32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b36:	eb 2f                	jmp    1b67 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b3c:	48 8b 00             	mov    (%rax),%rax
    1b3f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b43:	72 17                	jb     1b5c <free+0x4f>
    1b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b49:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b4d:	72 2f                	jb     1b7e <free+0x71>
    1b4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b53:	48 8b 00             	mov    (%rax),%rax
    1b56:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b5a:	72 22                	jb     1b7e <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b60:	48 8b 00             	mov    (%rax),%rax
    1b63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b6b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b6f:	73 c7                	jae    1b38 <free+0x2b>
    1b71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b75:	48 8b 00             	mov    (%rax),%rax
    1b78:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b7c:	73 ba                	jae    1b38 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b82:	8b 40 08             	mov    0x8(%rax),%eax
    1b85:	89 c0                	mov    %eax,%eax
    1b87:	48 c1 e0 04          	shl    $0x4,%rax
    1b8b:	48 89 c2             	mov    %rax,%rdx
    1b8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b92:	48 01 c2             	add    %rax,%rdx
    1b95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b99:	48 8b 00             	mov    (%rax),%rax
    1b9c:	48 39 c2             	cmp    %rax,%rdx
    1b9f:	75 2d                	jne    1bce <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1ba1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ba5:	8b 50 08             	mov    0x8(%rax),%edx
    1ba8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bac:	48 8b 00             	mov    (%rax),%rax
    1baf:	8b 40 08             	mov    0x8(%rax),%eax
    1bb2:	01 c2                	add    %eax,%edx
    1bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bb8:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1bbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bbf:	48 8b 00             	mov    (%rax),%rax
    1bc2:	48 8b 10             	mov    (%rax),%rdx
    1bc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bc9:	48 89 10             	mov    %rdx,(%rax)
    1bcc:	eb 0e                	jmp    1bdc <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1bce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bd2:	48 8b 10             	mov    (%rax),%rdx
    1bd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bd9:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1bdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be0:	8b 40 08             	mov    0x8(%rax),%eax
    1be3:	89 c0                	mov    %eax,%eax
    1be5:	48 c1 e0 04          	shl    $0x4,%rax
    1be9:	48 89 c2             	mov    %rax,%rdx
    1bec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf0:	48 01 d0             	add    %rdx,%rax
    1bf3:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bf7:	75 27                	jne    1c20 <free+0x113>
    p->s.size += bp->s.size;
    1bf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bfd:	8b 50 08             	mov    0x8(%rax),%edx
    1c00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c04:	8b 40 08             	mov    0x8(%rax),%eax
    1c07:	01 c2                	add    %eax,%edx
    1c09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c0d:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1c10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c14:	48 8b 10             	mov    (%rax),%rdx
    1c17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c1b:	48 89 10             	mov    %rdx,(%rax)
    1c1e:	eb 0b                	jmp    1c2b <free+0x11e>
  } else
    p->s.ptr = bp;
    1c20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c28:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c2b:	48 ba 70 1e 00 00 00 	movabs $0x1e70,%rdx
    1c32:	00 00 00 
    1c35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c39:	48 89 02             	mov    %rax,(%rdx)
}
    1c3c:	90                   	nop
    1c3d:	c9                   	leave
    1c3e:	c3                   	ret

0000000000001c3f <morecore>:

static Header*
morecore(uint nu)
{
    1c3f:	55                   	push   %rbp
    1c40:	48 89 e5             	mov    %rsp,%rbp
    1c43:	48 83 ec 20          	sub    $0x20,%rsp
    1c47:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c4a:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c51:	77 07                	ja     1c5a <morecore+0x1b>
    nu = 4096;
    1c53:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c5d:	48 c1 e0 04          	shl    $0x4,%rax
    1c61:	48 89 c7             	mov    %rax,%rdi
    1c64:	48 b8 b1 14 00 00 00 	movabs $0x14b1,%rax
    1c6b:	00 00 00 
    1c6e:	ff d0                	call   *%rax
    1c70:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c74:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c79:	75 07                	jne    1c82 <morecore+0x43>
    return 0;
    1c7b:	b8 00 00 00 00       	mov    $0x0,%eax
    1c80:	eb 36                	jmp    1cb8 <morecore+0x79>
  hp = (Header*)p;
    1c82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c86:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c8e:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c91:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c98:	48 83 c0 10          	add    $0x10,%rax
    1c9c:	48 89 c7             	mov    %rax,%rdi
    1c9f:	48 b8 0d 1b 00 00 00 	movabs $0x1b0d,%rax
    1ca6:	00 00 00 
    1ca9:	ff d0                	call   *%rax
  return freep;
    1cab:	48 b8 70 1e 00 00 00 	movabs $0x1e70,%rax
    1cb2:	00 00 00 
    1cb5:	48 8b 00             	mov    (%rax),%rax
}
    1cb8:	c9                   	leave
    1cb9:	c3                   	ret

0000000000001cba <malloc>:

void*
malloc(uint nbytes)
{
    1cba:	55                   	push   %rbp
    1cbb:	48 89 e5             	mov    %rsp,%rbp
    1cbe:	48 83 ec 30          	sub    $0x30,%rsp
    1cc2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1cc5:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1cc8:	48 83 c0 0f          	add    $0xf,%rax
    1ccc:	48 c1 e8 04          	shr    $0x4,%rax
    1cd0:	83 c0 01             	add    $0x1,%eax
    1cd3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1cd6:	48 b8 70 1e 00 00 00 	movabs $0x1e70,%rax
    1cdd:	00 00 00 
    1ce0:	48 8b 00             	mov    (%rax),%rax
    1ce3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ce7:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cec:	75 4a                	jne    1d38 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1cee:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1cf5:	00 00 00 
    1cf8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cfc:	48 ba 70 1e 00 00 00 	movabs $0x1e70,%rdx
    1d03:	00 00 00 
    1d06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d0a:	48 89 02             	mov    %rax,(%rdx)
    1d0d:	48 b8 70 1e 00 00 00 	movabs $0x1e70,%rax
    1d14:	00 00 00 
    1d17:	48 8b 00             	mov    (%rax),%rax
    1d1a:	48 ba 60 1e 00 00 00 	movabs $0x1e60,%rdx
    1d21:	00 00 00 
    1d24:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d27:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1d2e:	00 00 00 
    1d31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d3c:	48 8b 00             	mov    (%rax),%rax
    1d3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d47:	8b 40 08             	mov    0x8(%rax),%eax
    1d4a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1d4d:	72 65                	jb     1db4 <malloc+0xfa>
      if(p->s.size == nunits)
    1d4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d53:	8b 40 08             	mov    0x8(%rax),%eax
    1d56:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d59:	75 10                	jne    1d6b <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1d5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d5f:	48 8b 10             	mov    (%rax),%rdx
    1d62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d66:	48 89 10             	mov    %rdx,(%rax)
    1d69:	eb 2e                	jmp    1d99 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1d6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d6f:	8b 40 08             	mov    0x8(%rax),%eax
    1d72:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d75:	89 c2                	mov    %eax,%edx
    1d77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d7b:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d82:	8b 40 08             	mov    0x8(%rax),%eax
    1d85:	89 c0                	mov    %eax,%eax
    1d87:	48 c1 e0 04          	shl    $0x4,%rax
    1d8b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d93:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d96:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d99:	48 ba 70 1e 00 00 00 	movabs $0x1e70,%rdx
    1da0:	00 00 00 
    1da3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1da7:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1daa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dae:	48 83 c0 10          	add    $0x10,%rax
    1db2:	eb 4e                	jmp    1e02 <malloc+0x148>
    }
    if(p == freep)
    1db4:	48 b8 70 1e 00 00 00 	movabs $0x1e70,%rax
    1dbb:	00 00 00 
    1dbe:	48 8b 00             	mov    (%rax),%rax
    1dc1:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1dc5:	75 23                	jne    1dea <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1dc7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1dca:	89 c7                	mov    %eax,%edi
    1dcc:	48 b8 3f 1c 00 00 00 	movabs $0x1c3f,%rax
    1dd3:	00 00 00 
    1dd6:	ff d0                	call   *%rax
    1dd8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ddc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1de1:	75 07                	jne    1dea <malloc+0x130>
        return 0;
    1de3:	b8 00 00 00 00       	mov    $0x0,%eax
    1de8:	eb 18                	jmp    1e02 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1df2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1df6:	48 8b 00             	mov    (%rax),%rax
    1df9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1dfd:	e9 41 ff ff ff       	jmp    1d43 <malloc+0x89>
  }
}
    1e02:	c9                   	leave
    1e03:	c3                   	ret

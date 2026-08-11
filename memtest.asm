
_memtest:     file format elf64-x86-64


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
  char *p;
  printf(1, "memtest: starting\n");
    100f:	48 b8 38 1e 00 00 00 	movabs $0x1e38,%rax
    1016:	00 00 00 
    1019:	48 89 c6             	mov    %rax,%rsi
    101c:	bf 01 00 00 00       	mov    $0x1,%edi
    1021:	b8 00 00 00 00       	mov    $0x0,%eax
    1026:	48 ba 10 17 00 00 00 	movabs $0x1710,%rdx
    102d:	00 00 00 
    1030:	ff d2                	call   *%rdx
  p = sbrk(4096);
    1032:	bf 00 10 00 00       	mov    $0x1000,%edi
    1037:	48 b8 df 14 00 00 00 	movabs $0x14df,%rax
    103e:	00 00 00 
    1041:	ff d0                	call   *%rax
    1043:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1){
    1047:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    104c:	75 2f                	jne    107d <main+0x7d>
    printf(1, "sbrk failed\n");
    104e:	48 b8 4b 1e 00 00 00 	movabs $0x1e4b,%rax
    1055:	00 00 00 
    1058:	48 89 c6             	mov    %rax,%rsi
    105b:	bf 01 00 00 00       	mov    $0x1,%edi
    1060:	b8 00 00 00 00       	mov    $0x0,%eax
    1065:	48 ba 10 17 00 00 00 	movabs $0x1710,%rdx
    106c:	00 00 00 
    106f:	ff d2                	call   *%rdx
    exit();
    1071:	48 b8 02 14 00 00 00 	movabs $0x1402,%rax
    1078:	00 00 00 
    107b:	ff d0                	call   *%rax
  }
  *p = 'a';
    107d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1081:	c6 00 61             	movb   $0x61,(%rax)
  printf(1, "memtest: sbrk(4096) ok, touching memory ok\n");
    1084:	48 b8 58 1e 00 00 00 	movabs $0x1e58,%rax
    108b:	00 00 00 
    108e:	48 89 c6             	mov    %rax,%rsi
    1091:	bf 01 00 00 00       	mov    $0x1,%edi
    1096:	b8 00 00 00 00       	mov    $0x0,%eax
    109b:	48 ba 10 17 00 00 00 	movabs $0x1710,%rdx
    10a2:	00 00 00 
    10a5:	ff d2                	call   *%rdx
  sbrk(4096);
    10a7:	bf 00 10 00 00       	mov    $0x1000,%edi
    10ac:	48 b8 df 14 00 00 00 	movabs $0x14df,%rax
    10b3:	00 00 00 
    10b6:	ff d0                	call   *%rax
  printf(1, "memtest: done\n");
    10b8:	48 b8 84 1e 00 00 00 	movabs $0x1e84,%rax
    10bf:	00 00 00 
    10c2:	48 89 c6             	mov    %rax,%rsi
    10c5:	bf 01 00 00 00       	mov    $0x1,%edi
    10ca:	b8 00 00 00 00       	mov    $0x0,%eax
    10cf:	48 ba 10 17 00 00 00 	movabs $0x1710,%rdx
    10d6:	00 00 00 
    10d9:	ff d2                	call   *%rdx
  exit();
    10db:	48 b8 02 14 00 00 00 	movabs $0x1402,%rax
    10e2:	00 00 00 
    10e5:	ff d0                	call   *%rax

00000000000010e7 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10e7:	55                   	push   %rbp
    10e8:	48 89 e5             	mov    %rsp,%rbp
    10eb:	48 83 ec 10          	sub    $0x10,%rsp
    10ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10f3:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10f6:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10f9:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10fd:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1100:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1103:	48 89 ce             	mov    %rcx,%rsi
    1106:	48 89 f7             	mov    %rsi,%rdi
    1109:	89 d1                	mov    %edx,%ecx
    110b:	fc                   	cld
    110c:	f3 aa                	rep stos %al,(%rdi)
    110e:	89 ca                	mov    %ecx,%edx
    1110:	48 89 fe             	mov    %rdi,%rsi
    1113:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1117:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    111a:	90                   	nop
    111b:	c9                   	leave
    111c:	c3                   	ret

000000000000111d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    111d:	55                   	push   %rbp
    111e:	48 89 e5             	mov    %rsp,%rbp
    1121:	48 83 ec 20          	sub    $0x20,%rsp
    1125:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1129:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    112d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1131:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1135:	90                   	nop
    1136:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    113a:	48 8d 42 01          	lea    0x1(%rdx),%rax
    113e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1146:	48 8d 48 01          	lea    0x1(%rax),%rcx
    114a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    114e:	0f b6 12             	movzbl (%rdx),%edx
    1151:	88 10                	mov    %dl,(%rax)
    1153:	0f b6 00             	movzbl (%rax),%eax
    1156:	84 c0                	test   %al,%al
    1158:	75 dc                	jne    1136 <strcpy+0x19>
    ;
  return os;
    115a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    115e:	c9                   	leave
    115f:	c3                   	ret

0000000000001160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1160:	55                   	push   %rbp
    1161:	48 89 e5             	mov    %rsp,%rbp
    1164:	48 83 ec 10          	sub    $0x10,%rsp
    1168:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    116c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1170:	eb 0a                	jmp    117c <strcmp+0x1c>
    p++, q++;
    1172:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1177:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    117c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1180:	0f b6 00             	movzbl (%rax),%eax
    1183:	84 c0                	test   %al,%al
    1185:	74 12                	je     1199 <strcmp+0x39>
    1187:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    118b:	0f b6 10             	movzbl (%rax),%edx
    118e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1192:	0f b6 00             	movzbl (%rax),%eax
    1195:	38 c2                	cmp    %al,%dl
    1197:	74 d9                	je     1172 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    119d:	0f b6 00             	movzbl (%rax),%eax
    11a0:	0f b6 d0             	movzbl %al,%edx
    11a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11a7:	0f b6 00             	movzbl (%rax),%eax
    11aa:	0f b6 c0             	movzbl %al,%eax
    11ad:	29 c2                	sub    %eax,%edx
    11af:	89 d0                	mov    %edx,%eax
}
    11b1:	c9                   	leave
    11b2:	c3                   	ret

00000000000011b3 <strlen>:

uint
strlen(char *s)
{
    11b3:	55                   	push   %rbp
    11b4:	48 89 e5             	mov    %rsp,%rbp
    11b7:	48 83 ec 18          	sub    $0x18,%rsp
    11bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    11bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11c6:	eb 04                	jmp    11cc <strlen+0x19>
    11c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11cf:	48 63 d0             	movslq %eax,%rdx
    11d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11d6:	48 01 d0             	add    %rdx,%rax
    11d9:	0f b6 00             	movzbl (%rax),%eax
    11dc:	84 c0                	test   %al,%al
    11de:	75 e8                	jne    11c8 <strlen+0x15>
    ;
  return n;
    11e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11e3:	c9                   	leave
    11e4:	c3                   	ret

00000000000011e5 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11e5:	55                   	push   %rbp
    11e6:	48 89 e5             	mov    %rsp,%rbp
    11e9:	48 83 ec 10          	sub    $0x10,%rsp
    11ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11f1:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11f4:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11f7:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11fa:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1201:	89 ce                	mov    %ecx,%esi
    1203:	48 89 c7             	mov    %rax,%rdi
    1206:	48 b8 e7 10 00 00 00 	movabs $0x10e7,%rax
    120d:	00 00 00 
    1210:	ff d0                	call   *%rax
  return dst;
    1212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1216:	c9                   	leave
    1217:	c3                   	ret

0000000000001218 <strchr>:

char*
strchr(const char *s, char c)
{
    1218:	55                   	push   %rbp
    1219:	48 89 e5             	mov    %rsp,%rbp
    121c:	48 83 ec 10          	sub    $0x10,%rsp
    1220:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1224:	89 f0                	mov    %esi,%eax
    1226:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1229:	eb 17                	jmp    1242 <strchr+0x2a>
    if(*s == c)
    122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    122f:	0f b6 00             	movzbl (%rax),%eax
    1232:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1235:	75 06                	jne    123d <strchr+0x25>
      return (char*)s;
    1237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    123b:	eb 15                	jmp    1252 <strchr+0x3a>
  for(; *s; s++)
    123d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1242:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1246:	0f b6 00             	movzbl (%rax),%eax
    1249:	84 c0                	test   %al,%al
    124b:	75 de                	jne    122b <strchr+0x13>
  return 0;
    124d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1252:	c9                   	leave
    1253:	c3                   	ret

0000000000001254 <gets>:

char*
gets(char *buf, int max)
{
    1254:	55                   	push   %rbp
    1255:	48 89 e5             	mov    %rsp,%rbp
    1258:	48 83 ec 20          	sub    $0x20,%rsp
    125c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1260:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    126a:	eb 4f                	jmp    12bb <gets+0x67>
    cc = read(0, &c, 1);
    126c:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1270:	ba 01 00 00 00       	mov    $0x1,%edx
    1275:	48 89 c6             	mov    %rax,%rsi
    1278:	bf 00 00 00 00       	mov    $0x0,%edi
    127d:	48 b8 29 14 00 00 00 	movabs $0x1429,%rax
    1284:	00 00 00 
    1287:	ff d0                	call   *%rax
    1289:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    128c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1290:	7e 36                	jle    12c8 <gets+0x74>
      break;
    buf[i++] = c;
    1292:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1295:	8d 50 01             	lea    0x1(%rax),%edx
    1298:	89 55 fc             	mov    %edx,-0x4(%rbp)
    129b:	48 63 d0             	movslq %eax,%rdx
    129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12a2:	48 01 c2             	add    %rax,%rdx
    12a5:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12a9:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    12ab:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12af:	3c 0a                	cmp    $0xa,%al
    12b1:	74 16                	je     12c9 <gets+0x75>
    12b3:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12b7:	3c 0d                	cmp    $0xd,%al
    12b9:	74 0e                	je     12c9 <gets+0x75>
  for(i=0; i+1 < max; ){
    12bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12be:	83 c0 01             	add    $0x1,%eax
    12c1:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    12c4:	7f a6                	jg     126c <gets+0x18>
    12c6:	eb 01                	jmp    12c9 <gets+0x75>
      break;
    12c8:	90                   	nop
      break;
  }
  buf[i] = '\0';
    12c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12cc:	48 63 d0             	movslq %eax,%rdx
    12cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12d3:	48 01 d0             	add    %rdx,%rax
    12d6:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12dd:	c9                   	leave
    12de:	c3                   	ret

00000000000012df <stat>:

int
stat(char *n, struct stat *st)
{
    12df:	55                   	push   %rbp
    12e0:	48 89 e5             	mov    %rsp,%rbp
    12e3:	48 83 ec 20          	sub    $0x20,%rsp
    12e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12f3:	be 00 00 00 00       	mov    $0x0,%esi
    12f8:	48 89 c7             	mov    %rax,%rdi
    12fb:	48 b8 6a 14 00 00 00 	movabs $0x146a,%rax
    1302:	00 00 00 
    1305:	ff d0                	call   *%rax
    1307:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    130a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    130e:	79 07                	jns    1317 <stat+0x38>
    return -1;
    1310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1315:	eb 2f                	jmp    1346 <stat+0x67>
  r = fstat(fd, st);
    1317:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    131b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    131e:	48 89 d6             	mov    %rdx,%rsi
    1321:	89 c7                	mov    %eax,%edi
    1323:	48 b8 91 14 00 00 00 	movabs $0x1491,%rax
    132a:	00 00 00 
    132d:	ff d0                	call   *%rax
    132f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1332:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1335:	89 c7                	mov    %eax,%edi
    1337:	48 b8 43 14 00 00 00 	movabs $0x1443,%rax
    133e:	00 00 00 
    1341:	ff d0                	call   *%rax
  return r;
    1343:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1346:	c9                   	leave
    1347:	c3                   	ret

0000000000001348 <atoi>:

int
atoi(const char *s)
{
    1348:	55                   	push   %rbp
    1349:	48 89 e5             	mov    %rsp,%rbp
    134c:	48 83 ec 18          	sub    $0x18,%rsp
    1350:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1354:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    135b:	eb 28                	jmp    1385 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    135d:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1360:	89 d0                	mov    %edx,%eax
    1362:	c1 e0 02             	shl    $0x2,%eax
    1365:	01 d0                	add    %edx,%eax
    1367:	01 c0                	add    %eax,%eax
    1369:	89 c1                	mov    %eax,%ecx
    136b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    136f:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1373:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1377:	0f b6 00             	movzbl (%rax),%eax
    137a:	0f be c0             	movsbl %al,%eax
    137d:	01 c8                	add    %ecx,%eax
    137f:	83 e8 30             	sub    $0x30,%eax
    1382:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1389:	0f b6 00             	movzbl (%rax),%eax
    138c:	3c 2f                	cmp    $0x2f,%al
    138e:	7e 0b                	jle    139b <atoi+0x53>
    1390:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1394:	0f b6 00             	movzbl (%rax),%eax
    1397:	3c 39                	cmp    $0x39,%al
    1399:	7e c2                	jle    135d <atoi+0x15>
  return n;
    139b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    139e:	c9                   	leave
    139f:	c3                   	ret

00000000000013a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13a0:	55                   	push   %rbp
    13a1:	48 89 e5             	mov    %rsp,%rbp
    13a4:	48 83 ec 28          	sub    $0x28,%rsp
    13a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    13b0:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    13b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    13bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    13bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    13c3:	eb 1d                	jmp    13e2 <memmove+0x42>
    *dst++ = *src++;
    13c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    13c9:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13d5:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13d9:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13dd:	0f b6 12             	movzbl (%rdx),%edx
    13e0:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13e5:	8d 50 ff             	lea    -0x1(%rax),%edx
    13e8:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13eb:	85 c0                	test   %eax,%eax
    13ed:	7f d6                	jg     13c5 <memmove+0x25>
  return vdst;
    13ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13f3:	c9                   	leave
    13f4:	c3                   	ret

00000000000013f5 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13f5:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13fc:	49 89 ca             	mov    %rcx,%r10
    13ff:	0f 05                	syscall
    1401:	c3                   	ret

0000000000001402 <exit>:
SYSCALL(exit)
    1402:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1409:	49 89 ca             	mov    %rcx,%r10
    140c:	0f 05                	syscall
    140e:	c3                   	ret

000000000000140f <wait>:
SYSCALL(wait)
    140f:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1416:	49 89 ca             	mov    %rcx,%r10
    1419:	0f 05                	syscall
    141b:	c3                   	ret

000000000000141c <pipe>:
SYSCALL(pipe)
    141c:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1423:	49 89 ca             	mov    %rcx,%r10
    1426:	0f 05                	syscall
    1428:	c3                   	ret

0000000000001429 <read>:
SYSCALL(read)
    1429:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1430:	49 89 ca             	mov    %rcx,%r10
    1433:	0f 05                	syscall
    1435:	c3                   	ret

0000000000001436 <write>:
SYSCALL(write)
    1436:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    143d:	49 89 ca             	mov    %rcx,%r10
    1440:	0f 05                	syscall
    1442:	c3                   	ret

0000000000001443 <close>:
SYSCALL(close)
    1443:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    144a:	49 89 ca             	mov    %rcx,%r10
    144d:	0f 05                	syscall
    144f:	c3                   	ret

0000000000001450 <kill>:
SYSCALL(kill)
    1450:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1457:	49 89 ca             	mov    %rcx,%r10
    145a:	0f 05                	syscall
    145c:	c3                   	ret

000000000000145d <exec>:
SYSCALL(exec)
    145d:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1464:	49 89 ca             	mov    %rcx,%r10
    1467:	0f 05                	syscall
    1469:	c3                   	ret

000000000000146a <open>:
SYSCALL(open)
    146a:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1471:	49 89 ca             	mov    %rcx,%r10
    1474:	0f 05                	syscall
    1476:	c3                   	ret

0000000000001477 <mknod>:
SYSCALL(mknod)
    1477:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    147e:	49 89 ca             	mov    %rcx,%r10
    1481:	0f 05                	syscall
    1483:	c3                   	ret

0000000000001484 <unlink>:
SYSCALL(unlink)
    1484:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    148b:	49 89 ca             	mov    %rcx,%r10
    148e:	0f 05                	syscall
    1490:	c3                   	ret

0000000000001491 <fstat>:
SYSCALL(fstat)
    1491:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1498:	49 89 ca             	mov    %rcx,%r10
    149b:	0f 05                	syscall
    149d:	c3                   	ret

000000000000149e <link>:
SYSCALL(link)
    149e:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    14a5:	49 89 ca             	mov    %rcx,%r10
    14a8:	0f 05                	syscall
    14aa:	c3                   	ret

00000000000014ab <mkdir>:
SYSCALL(mkdir)
    14ab:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    14b2:	49 89 ca             	mov    %rcx,%r10
    14b5:	0f 05                	syscall
    14b7:	c3                   	ret

00000000000014b8 <chdir>:
SYSCALL(chdir)
    14b8:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    14bf:	49 89 ca             	mov    %rcx,%r10
    14c2:	0f 05                	syscall
    14c4:	c3                   	ret

00000000000014c5 <dup>:
SYSCALL(dup)
    14c5:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    14cc:	49 89 ca             	mov    %rcx,%r10
    14cf:	0f 05                	syscall
    14d1:	c3                   	ret

00000000000014d2 <getpid>:
SYSCALL(getpid)
    14d2:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14d9:	49 89 ca             	mov    %rcx,%r10
    14dc:	0f 05                	syscall
    14de:	c3                   	ret

00000000000014df <sbrk>:
SYSCALL(sbrk)
    14df:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14e6:	49 89 ca             	mov    %rcx,%r10
    14e9:	0f 05                	syscall
    14eb:	c3                   	ret

00000000000014ec <sleep>:
SYSCALL(sleep)
    14ec:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14f3:	49 89 ca             	mov    %rcx,%r10
    14f6:	0f 05                	syscall
    14f8:	c3                   	ret

00000000000014f9 <uptime>:
SYSCALL(uptime)
    14f9:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1500:	49 89 ca             	mov    %rcx,%r10
    1503:	0f 05                	syscall
    1505:	c3                   	ret

0000000000001506 <traceread>:
SYSCALL(traceread)
    1506:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    150d:	49 89 ca             	mov    %rcx,%r10
    1510:	0f 05                	syscall
    1512:	c3                   	ret

0000000000001513 <vidclear>:
SYSCALL(vidclear)
    1513:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    151a:	49 89 ca             	mov    %rcx,%r10
    151d:	0f 05                	syscall
    151f:	c3                   	ret

0000000000001520 <vidputc>:
SYSCALL(vidputc)
    1520:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    1527:	49 89 ca             	mov    %rcx,%r10
    152a:	0f 05                	syscall
    152c:	c3                   	ret

000000000000152d <vidputs>:
SYSCALL(vidputs)
    152d:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    1534:	49 89 ca             	mov    %rcx,%r10
    1537:	0f 05                	syscall
    1539:	c3                   	ret

000000000000153a <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    153a:	55                   	push   %rbp
    153b:	48 89 e5             	mov    %rsp,%rbp
    153e:	48 83 ec 10          	sub    $0x10,%rsp
    1542:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1545:	89 f0                	mov    %esi,%eax
    1547:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    154a:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    154e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1551:	ba 01 00 00 00       	mov    $0x1,%edx
    1556:	48 89 ce             	mov    %rcx,%rsi
    1559:	89 c7                	mov    %eax,%edi
    155b:	48 b8 36 14 00 00 00 	movabs $0x1436,%rax
    1562:	00 00 00 
    1565:	ff d0                	call   *%rax
}
    1567:	90                   	nop
    1568:	c9                   	leave
    1569:	c3                   	ret

000000000000156a <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    156a:	55                   	push   %rbp
    156b:	48 89 e5             	mov    %rsp,%rbp
    156e:	48 83 ec 20          	sub    $0x20,%rsp
    1572:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1575:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1579:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1580:	eb 35                	jmp    15b7 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1582:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1586:	48 c1 e8 3c          	shr    $0x3c,%rax
    158a:	48 ba a0 1e 00 00 00 	movabs $0x1ea0,%rdx
    1591:	00 00 00 
    1594:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1598:	0f be d0             	movsbl %al,%edx
    159b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    159e:	89 d6                	mov    %edx,%esi
    15a0:	89 c7                	mov    %eax,%edi
    15a2:	48 b8 3a 15 00 00 00 	movabs $0x153a,%rax
    15a9:	00 00 00 
    15ac:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    15ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15b2:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    15b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15ba:	83 f8 0f             	cmp    $0xf,%eax
    15bd:	76 c3                	jbe    1582 <print_x64+0x18>
}
    15bf:	90                   	nop
    15c0:	90                   	nop
    15c1:	c9                   	leave
    15c2:	c3                   	ret

00000000000015c3 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    15c3:	55                   	push   %rbp
    15c4:	48 89 e5             	mov    %rsp,%rbp
    15c7:	48 83 ec 20          	sub    $0x20,%rsp
    15cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15ce:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15d8:	eb 36                	jmp    1610 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    15da:	8b 45 e8             	mov    -0x18(%rbp),%eax
    15dd:	c1 e8 1c             	shr    $0x1c,%eax
    15e0:	89 c2                	mov    %eax,%edx
    15e2:	48 b8 a0 1e 00 00 00 	movabs $0x1ea0,%rax
    15e9:	00 00 00 
    15ec:	89 d2                	mov    %edx,%edx
    15ee:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15f2:	0f be d0             	movsbl %al,%edx
    15f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15f8:	89 d6                	mov    %edx,%esi
    15fa:	89 c7                	mov    %eax,%edi
    15fc:	48 b8 3a 15 00 00 00 	movabs $0x153a,%rax
    1603:	00 00 00 
    1606:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1608:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    160c:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    1610:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1613:	83 f8 07             	cmp    $0x7,%eax
    1616:	76 c2                	jbe    15da <print_x32+0x17>
}
    1618:	90                   	nop
    1619:	90                   	nop
    161a:	c9                   	leave
    161b:	c3                   	ret

000000000000161c <print_d>:

  static void
print_d(int fd, int v)
{
    161c:	55                   	push   %rbp
    161d:	48 89 e5             	mov    %rsp,%rbp
    1620:	48 83 ec 30          	sub    $0x30,%rsp
    1624:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1627:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    162a:	8b 45 d8             	mov    -0x28(%rbp),%eax
    162d:	48 98                	cltq
    162f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1633:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1637:	79 04                	jns    163d <print_d+0x21>
    x = -x;
    1639:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    163d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1644:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1648:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    164f:	66 66 66 
    1652:	48 89 c8             	mov    %rcx,%rax
    1655:	48 f7 ea             	imul   %rdx
    1658:	48 c1 fa 02          	sar    $0x2,%rdx
    165c:	48 89 c8             	mov    %rcx,%rax
    165f:	48 c1 f8 3f          	sar    $0x3f,%rax
    1663:	48 29 c2             	sub    %rax,%rdx
    1666:	48 89 d0             	mov    %rdx,%rax
    1669:	48 c1 e0 02          	shl    $0x2,%rax
    166d:	48 01 d0             	add    %rdx,%rax
    1670:	48 01 c0             	add    %rax,%rax
    1673:	48 29 c1             	sub    %rax,%rcx
    1676:	48 89 ca             	mov    %rcx,%rdx
    1679:	8b 45 f4             	mov    -0xc(%rbp),%eax
    167c:	8d 48 01             	lea    0x1(%rax),%ecx
    167f:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1682:	48 b9 a0 1e 00 00 00 	movabs $0x1ea0,%rcx
    1689:	00 00 00 
    168c:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1690:	48 98                	cltq
    1692:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1696:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    169a:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    16a1:	66 66 66 
    16a4:	48 89 c8             	mov    %rcx,%rax
    16a7:	48 f7 ea             	imul   %rdx
    16aa:	48 89 d0             	mov    %rdx,%rax
    16ad:	48 c1 f8 02          	sar    $0x2,%rax
    16b1:	48 c1 f9 3f          	sar    $0x3f,%rcx
    16b5:	48 89 ca             	mov    %rcx,%rdx
    16b8:	48 29 d0             	sub    %rdx,%rax
    16bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    16bf:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    16c4:	0f 85 7a ff ff ff    	jne    1644 <print_d+0x28>

  if (v < 0)
    16ca:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16ce:	79 32                	jns    1702 <print_d+0xe6>
    buf[i++] = '-';
    16d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16d3:	8d 50 01             	lea    0x1(%rax),%edx
    16d6:	89 55 f4             	mov    %edx,-0xc(%rbp)
    16d9:	48 98                	cltq
    16db:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16e0:	eb 20                	jmp    1702 <print_d+0xe6>
    putc(fd, buf[i]);
    16e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16e5:	48 98                	cltq
    16e7:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16ec:	0f be d0             	movsbl %al,%edx
    16ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16f2:	89 d6                	mov    %edx,%esi
    16f4:	89 c7                	mov    %eax,%edi
    16f6:	48 b8 3a 15 00 00 00 	movabs $0x153a,%rax
    16fd:	00 00 00 
    1700:	ff d0                	call   *%rax
  while (--i >= 0)
    1702:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1706:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    170a:	79 d6                	jns    16e2 <print_d+0xc6>
}
    170c:	90                   	nop
    170d:	90                   	nop
    170e:	c9                   	leave
    170f:	c3                   	ret

0000000000001710 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1710:	55                   	push   %rbp
    1711:	48 89 e5             	mov    %rsp,%rbp
    1714:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    171b:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1721:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1728:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    172f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1736:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    173d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1744:	84 c0                	test   %al,%al
    1746:	74 20                	je     1768 <printf+0x58>
    1748:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    174c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1750:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1754:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1758:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    175c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1760:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1764:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1768:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    176f:	00 00 00 
    1772:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1779:	00 00 00 
    177c:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1780:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1787:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    178e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1795:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    179c:	00 00 00 
    179f:	e9 60 03 00 00       	jmp    1b04 <printf+0x3f4>
    if (c != '%') {
    17a4:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17ab:	74 24                	je     17d1 <printf+0xc1>
      putc(fd, c);
    17ad:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    17b3:	0f be d0             	movsbl %al,%edx
    17b6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    17bc:	89 d6                	mov    %edx,%esi
    17be:	89 c7                	mov    %eax,%edi
    17c0:	48 b8 3a 15 00 00 00 	movabs $0x153a,%rax
    17c7:	00 00 00 
    17ca:	ff d0                	call   *%rax
      continue;
    17cc:	e9 2c 03 00 00       	jmp    1afd <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    17d1:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17d8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17de:	48 63 d0             	movslq %eax,%rdx
    17e1:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17e8:	48 01 d0             	add    %rdx,%rax
    17eb:	0f b6 00             	movzbl (%rax),%eax
    17ee:	0f be c0             	movsbl %al,%eax
    17f1:	25 ff 00 00 00       	and    $0xff,%eax
    17f6:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17fc:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1803:	0f 84 2e 03 00 00    	je     1b37 <printf+0x427>
      break;
    switch(c) {
    1809:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1810:	0f 84 32 01 00 00    	je     1948 <printf+0x238>
    1816:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    181d:	0f 8f a1 02 00 00    	jg     1ac4 <printf+0x3b4>
    1823:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    182a:	0f 84 d4 01 00 00    	je     1a04 <printf+0x2f4>
    1830:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1837:	0f 8f 87 02 00 00    	jg     1ac4 <printf+0x3b4>
    183d:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1844:	0f 84 5b 01 00 00    	je     19a5 <printf+0x295>
    184a:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1851:	0f 8f 6d 02 00 00    	jg     1ac4 <printf+0x3b4>
    1857:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    185e:	0f 84 87 00 00 00    	je     18eb <printf+0x1db>
    1864:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    186b:	0f 8f 53 02 00 00    	jg     1ac4 <printf+0x3b4>
    1871:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1878:	0f 84 2b 02 00 00    	je     1aa9 <printf+0x399>
    187e:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1885:	0f 85 39 02 00 00    	jne    1ac4 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    188b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1891:	83 f8 2f             	cmp    $0x2f,%eax
    1894:	77 23                	ja     18b9 <printf+0x1a9>
    1896:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    189d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18a3:	89 d2                	mov    %edx,%edx
    18a5:	48 01 d0             	add    %rdx,%rax
    18a8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18ae:	83 c2 08             	add    $0x8,%edx
    18b1:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18b7:	eb 12                	jmp    18cb <printf+0x1bb>
    18b9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18c0:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18c4:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18cb:	8b 00                	mov    (%rax),%eax
    18cd:	0f be d0             	movsbl %al,%edx
    18d0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18d6:	89 d6                	mov    %edx,%esi
    18d8:	89 c7                	mov    %eax,%edi
    18da:	48 b8 3a 15 00 00 00 	movabs $0x153a,%rax
    18e1:	00 00 00 
    18e4:	ff d0                	call   *%rax
      break;
    18e6:	e9 12 02 00 00       	jmp    1afd <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    18eb:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18f1:	83 f8 2f             	cmp    $0x2f,%eax
    18f4:	77 23                	ja     1919 <printf+0x209>
    18f6:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18fd:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1903:	89 d2                	mov    %edx,%edx
    1905:	48 01 d0             	add    %rdx,%rax
    1908:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    190e:	83 c2 08             	add    $0x8,%edx
    1911:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1917:	eb 12                	jmp    192b <printf+0x21b>
    1919:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1920:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1924:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    192b:	8b 10                	mov    (%rax),%edx
    192d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1933:	89 d6                	mov    %edx,%esi
    1935:	89 c7                	mov    %eax,%edi
    1937:	48 b8 1c 16 00 00 00 	movabs $0x161c,%rax
    193e:	00 00 00 
    1941:	ff d0                	call   *%rax
      break;
    1943:	e9 b5 01 00 00       	jmp    1afd <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1948:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    194e:	83 f8 2f             	cmp    $0x2f,%eax
    1951:	77 23                	ja     1976 <printf+0x266>
    1953:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    195a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1960:	89 d2                	mov    %edx,%edx
    1962:	48 01 d0             	add    %rdx,%rax
    1965:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    196b:	83 c2 08             	add    $0x8,%edx
    196e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1974:	eb 12                	jmp    1988 <printf+0x278>
    1976:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    197d:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1981:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1988:	8b 10                	mov    (%rax),%edx
    198a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1990:	89 d6                	mov    %edx,%esi
    1992:	89 c7                	mov    %eax,%edi
    1994:	48 b8 c3 15 00 00 00 	movabs $0x15c3,%rax
    199b:	00 00 00 
    199e:	ff d0                	call   *%rax
      break;
    19a0:	e9 58 01 00 00       	jmp    1afd <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    19a5:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19ab:	83 f8 2f             	cmp    $0x2f,%eax
    19ae:	77 23                	ja     19d3 <printf+0x2c3>
    19b0:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19b7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19bd:	89 d2                	mov    %edx,%edx
    19bf:	48 01 d0             	add    %rdx,%rax
    19c2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19c8:	83 c2 08             	add    $0x8,%edx
    19cb:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19d1:	eb 12                	jmp    19e5 <printf+0x2d5>
    19d3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19da:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19de:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19e5:	48 8b 10             	mov    (%rax),%rdx
    19e8:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19ee:	48 89 d6             	mov    %rdx,%rsi
    19f1:	89 c7                	mov    %eax,%edi
    19f3:	48 b8 6a 15 00 00 00 	movabs $0x156a,%rax
    19fa:	00 00 00 
    19fd:	ff d0                	call   *%rax
      break;
    19ff:	e9 f9 00 00 00       	jmp    1afd <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1a04:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a0a:	83 f8 2f             	cmp    $0x2f,%eax
    1a0d:	77 23                	ja     1a32 <printf+0x322>
    1a0f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a16:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a1c:	89 d2                	mov    %edx,%edx
    1a1e:	48 01 d0             	add    %rdx,%rax
    1a21:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a27:	83 c2 08             	add    $0x8,%edx
    1a2a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a30:	eb 12                	jmp    1a44 <printf+0x334>
    1a32:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a39:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a3d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a44:	48 8b 00             	mov    (%rax),%rax
    1a47:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1a4e:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a55:	00 
    1a56:	75 41                	jne    1a99 <printf+0x389>
        s = "(null)";
    1a58:	48 b8 93 1e 00 00 00 	movabs $0x1e93,%rax
    1a5f:	00 00 00 
    1a62:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a69:	eb 2e                	jmp    1a99 <printf+0x389>
        putc(fd, *(s++));
    1a6b:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a72:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a76:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a7d:	0f b6 00             	movzbl (%rax),%eax
    1a80:	0f be d0             	movsbl %al,%edx
    1a83:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a89:	89 d6                	mov    %edx,%esi
    1a8b:	89 c7                	mov    %eax,%edi
    1a8d:	48 b8 3a 15 00 00 00 	movabs $0x153a,%rax
    1a94:	00 00 00 
    1a97:	ff d0                	call   *%rax
      while (*s)
    1a99:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1aa0:	0f b6 00             	movzbl (%rax),%eax
    1aa3:	84 c0                	test   %al,%al
    1aa5:	75 c4                	jne    1a6b <printf+0x35b>
      break;
    1aa7:	eb 54                	jmp    1afd <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1aa9:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aaf:	be 25 00 00 00       	mov    $0x25,%esi
    1ab4:	89 c7                	mov    %eax,%edi
    1ab6:	48 b8 3a 15 00 00 00 	movabs $0x153a,%rax
    1abd:	00 00 00 
    1ac0:	ff d0                	call   *%rax
      break;
    1ac2:	eb 39                	jmp    1afd <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1ac4:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aca:	be 25 00 00 00       	mov    $0x25,%esi
    1acf:	89 c7                	mov    %eax,%edi
    1ad1:	48 b8 3a 15 00 00 00 	movabs $0x153a,%rax
    1ad8:	00 00 00 
    1adb:	ff d0                	call   *%rax
      putc(fd, c);
    1add:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1ae3:	0f be d0             	movsbl %al,%edx
    1ae6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aec:	89 d6                	mov    %edx,%esi
    1aee:	89 c7                	mov    %eax,%edi
    1af0:	48 b8 3a 15 00 00 00 	movabs $0x153a,%rax
    1af7:	00 00 00 
    1afa:	ff d0                	call   *%rax
      break;
    1afc:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1afd:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b04:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1b0a:	48 63 d0             	movslq %eax,%rdx
    1b0d:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1b14:	48 01 d0             	add    %rdx,%rax
    1b17:	0f b6 00             	movzbl (%rax),%eax
    1b1a:	0f be c0             	movsbl %al,%eax
    1b1d:	25 ff 00 00 00       	and    $0xff,%eax
    1b22:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1b28:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1b2f:	0f 85 6f fc ff ff    	jne    17a4 <printf+0x94>
    }
  }
}
    1b35:	eb 01                	jmp    1b38 <printf+0x428>
      break;
    1b37:	90                   	nop
}
    1b38:	90                   	nop
    1b39:	c9                   	leave
    1b3a:	c3                   	ret

0000000000001b3b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1b3b:	55                   	push   %rbp
    1b3c:	48 89 e5             	mov    %rsp,%rbp
    1b3f:	48 83 ec 18          	sub    $0x18,%rsp
    1b43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1b47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b4b:	48 83 e8 10          	sub    $0x10,%rax
    1b4f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b53:	48 b8 d0 1e 00 00 00 	movabs $0x1ed0,%rax
    1b5a:	00 00 00 
    1b5d:	48 8b 00             	mov    (%rax),%rax
    1b60:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b64:	eb 2f                	jmp    1b95 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b6a:	48 8b 00             	mov    (%rax),%rax
    1b6d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b71:	72 17                	jb     1b8a <free+0x4f>
    1b73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b77:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b7b:	72 2f                	jb     1bac <free+0x71>
    1b7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b81:	48 8b 00             	mov    (%rax),%rax
    1b84:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b88:	72 22                	jb     1bac <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b8e:	48 8b 00             	mov    (%rax),%rax
    1b91:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b99:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b9d:	73 c7                	jae    1b66 <free+0x2b>
    1b9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ba3:	48 8b 00             	mov    (%rax),%rax
    1ba6:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1baa:	73 ba                	jae    1b66 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1bac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bb0:	8b 40 08             	mov    0x8(%rax),%eax
    1bb3:	89 c0                	mov    %eax,%eax
    1bb5:	48 c1 e0 04          	shl    $0x4,%rax
    1bb9:	48 89 c2             	mov    %rax,%rdx
    1bbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bc0:	48 01 c2             	add    %rax,%rdx
    1bc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bc7:	48 8b 00             	mov    (%rax),%rax
    1bca:	48 39 c2             	cmp    %rax,%rdx
    1bcd:	75 2d                	jne    1bfc <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1bcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bd3:	8b 50 08             	mov    0x8(%rax),%edx
    1bd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bda:	48 8b 00             	mov    (%rax),%rax
    1bdd:	8b 40 08             	mov    0x8(%rax),%eax
    1be0:	01 c2                	add    %eax,%edx
    1be2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1be6:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1be9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bed:	48 8b 00             	mov    (%rax),%rax
    1bf0:	48 8b 10             	mov    (%rax),%rdx
    1bf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bf7:	48 89 10             	mov    %rdx,(%rax)
    1bfa:	eb 0e                	jmp    1c0a <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1bfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c00:	48 8b 10             	mov    (%rax),%rdx
    1c03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c07:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1c0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c0e:	8b 40 08             	mov    0x8(%rax),%eax
    1c11:	89 c0                	mov    %eax,%eax
    1c13:	48 c1 e0 04          	shl    $0x4,%rax
    1c17:	48 89 c2             	mov    %rax,%rdx
    1c1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c1e:	48 01 d0             	add    %rdx,%rax
    1c21:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c25:	75 27                	jne    1c4e <free+0x113>
    p->s.size += bp->s.size;
    1c27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c2b:	8b 50 08             	mov    0x8(%rax),%edx
    1c2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c32:	8b 40 08             	mov    0x8(%rax),%eax
    1c35:	01 c2                	add    %eax,%edx
    1c37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c3b:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1c3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c42:	48 8b 10             	mov    (%rax),%rdx
    1c45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c49:	48 89 10             	mov    %rdx,(%rax)
    1c4c:	eb 0b                	jmp    1c59 <free+0x11e>
  } else
    p->s.ptr = bp;
    1c4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c56:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c59:	48 ba d0 1e 00 00 00 	movabs $0x1ed0,%rdx
    1c60:	00 00 00 
    1c63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c67:	48 89 02             	mov    %rax,(%rdx)
}
    1c6a:	90                   	nop
    1c6b:	c9                   	leave
    1c6c:	c3                   	ret

0000000000001c6d <morecore>:

static Header*
morecore(uint nu)
{
    1c6d:	55                   	push   %rbp
    1c6e:	48 89 e5             	mov    %rsp,%rbp
    1c71:	48 83 ec 20          	sub    $0x20,%rsp
    1c75:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c78:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c7f:	77 07                	ja     1c88 <morecore+0x1b>
    nu = 4096;
    1c81:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c88:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c8b:	48 c1 e0 04          	shl    $0x4,%rax
    1c8f:	48 89 c7             	mov    %rax,%rdi
    1c92:	48 b8 df 14 00 00 00 	movabs $0x14df,%rax
    1c99:	00 00 00 
    1c9c:	ff d0                	call   *%rax
    1c9e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1ca2:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1ca7:	75 07                	jne    1cb0 <morecore+0x43>
    return 0;
    1ca9:	b8 00 00 00 00       	mov    $0x0,%eax
    1cae:	eb 36                	jmp    1ce6 <morecore+0x79>
  hp = (Header*)p;
    1cb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1cb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cbc:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1cbf:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1cc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc6:	48 83 c0 10          	add    $0x10,%rax
    1cca:	48 89 c7             	mov    %rax,%rdi
    1ccd:	48 b8 3b 1b 00 00 00 	movabs $0x1b3b,%rax
    1cd4:	00 00 00 
    1cd7:	ff d0                	call   *%rax
  return freep;
    1cd9:	48 b8 d0 1e 00 00 00 	movabs $0x1ed0,%rax
    1ce0:	00 00 00 
    1ce3:	48 8b 00             	mov    (%rax),%rax
}
    1ce6:	c9                   	leave
    1ce7:	c3                   	ret

0000000000001ce8 <malloc>:

void*
malloc(uint nbytes)
{
    1ce8:	55                   	push   %rbp
    1ce9:	48 89 e5             	mov    %rsp,%rbp
    1cec:	48 83 ec 30          	sub    $0x30,%rsp
    1cf0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1cf3:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1cf6:	48 83 c0 0f          	add    $0xf,%rax
    1cfa:	48 c1 e8 04          	shr    $0x4,%rax
    1cfe:	83 c0 01             	add    $0x1,%eax
    1d01:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1d04:	48 b8 d0 1e 00 00 00 	movabs $0x1ed0,%rax
    1d0b:	00 00 00 
    1d0e:	48 8b 00             	mov    (%rax),%rax
    1d11:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d15:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1d1a:	75 4a                	jne    1d66 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1d1c:	48 b8 c0 1e 00 00 00 	movabs $0x1ec0,%rax
    1d23:	00 00 00 
    1d26:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d2a:	48 ba d0 1e 00 00 00 	movabs $0x1ed0,%rdx
    1d31:	00 00 00 
    1d34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d38:	48 89 02             	mov    %rax,(%rdx)
    1d3b:	48 b8 d0 1e 00 00 00 	movabs $0x1ed0,%rax
    1d42:	00 00 00 
    1d45:	48 8b 00             	mov    (%rax),%rax
    1d48:	48 ba c0 1e 00 00 00 	movabs $0x1ec0,%rdx
    1d4f:	00 00 00 
    1d52:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d55:	48 b8 c0 1e 00 00 00 	movabs $0x1ec0,%rax
    1d5c:	00 00 00 
    1d5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d6a:	48 8b 00             	mov    (%rax),%rax
    1d6d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d75:	8b 40 08             	mov    0x8(%rax),%eax
    1d78:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1d7b:	72 65                	jb     1de2 <malloc+0xfa>
      if(p->s.size == nunits)
    1d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d81:	8b 40 08             	mov    0x8(%rax),%eax
    1d84:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d87:	75 10                	jne    1d99 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1d89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d8d:	48 8b 10             	mov    (%rax),%rdx
    1d90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d94:	48 89 10             	mov    %rdx,(%rax)
    1d97:	eb 2e                	jmp    1dc7 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1d99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d9d:	8b 40 08             	mov    0x8(%rax),%eax
    1da0:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1da3:	89 c2                	mov    %eax,%edx
    1da5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1da9:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1dac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1db0:	8b 40 08             	mov    0x8(%rax),%eax
    1db3:	89 c0                	mov    %eax,%eax
    1db5:	48 c1 e0 04          	shl    $0x4,%rax
    1db9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dc1:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1dc4:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1dc7:	48 ba d0 1e 00 00 00 	movabs $0x1ed0,%rdx
    1dce:	00 00 00 
    1dd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dd5:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1dd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ddc:	48 83 c0 10          	add    $0x10,%rax
    1de0:	eb 4e                	jmp    1e30 <malloc+0x148>
    }
    if(p == freep)
    1de2:	48 b8 d0 1e 00 00 00 	movabs $0x1ed0,%rax
    1de9:	00 00 00 
    1dec:	48 8b 00             	mov    (%rax),%rax
    1def:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1df3:	75 23                	jne    1e18 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1df5:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1df8:	89 c7                	mov    %eax,%edi
    1dfa:	48 b8 6d 1c 00 00 00 	movabs $0x1c6d,%rax
    1e01:	00 00 00 
    1e04:	ff d0                	call   *%rax
    1e06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1e0a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1e0f:	75 07                	jne    1e18 <malloc+0x130>
        return 0;
    1e11:	b8 00 00 00 00       	mov    $0x0,%eax
    1e16:	eb 18                	jmp    1e30 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e1c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e24:	48 8b 00             	mov    (%rax),%rax
    1e27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e2b:	e9 41 ff ff ff       	jmp    1d71 <malloc+0x89>
  }
}
    1e30:	c9                   	leave
    1e31:	c3                   	ret

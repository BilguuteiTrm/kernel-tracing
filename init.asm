
_init:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 10          	sub    $0x10,%rsp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    1008:	48 b8 e6 1e 00 00 00 	movabs $0x1ee6,%rax
    100f:	00 00 00 
    1012:	be 02 00 00 00       	mov    $0x2,%esi
    1017:	48 89 c7             	mov    %rax,%rdi
    101a:	48 b8 1b 15 00 00 00 	movabs $0x151b,%rax
    1021:	00 00 00 
    1024:	ff d0                	call   *%rax
    1026:	85 c0                	test   %eax,%eax
    1028:	79 41                	jns    106b <main+0x6b>
    mknod("console", 1, 1);
    102a:	48 b8 e6 1e 00 00 00 	movabs $0x1ee6,%rax
    1031:	00 00 00 
    1034:	ba 01 00 00 00       	mov    $0x1,%edx
    1039:	be 01 00 00 00       	mov    $0x1,%esi
    103e:	48 89 c7             	mov    %rax,%rdi
    1041:	48 b8 28 15 00 00 00 	movabs $0x1528,%rax
    1048:	00 00 00 
    104b:	ff d0                	call   *%rax
    open("console", O_RDWR);
    104d:	48 b8 e6 1e 00 00 00 	movabs $0x1ee6,%rax
    1054:	00 00 00 
    1057:	be 02 00 00 00       	mov    $0x2,%esi
    105c:	48 89 c7             	mov    %rax,%rdi
    105f:	48 b8 1b 15 00 00 00 	movabs $0x151b,%rax
    1066:	00 00 00 
    1069:	ff d0                	call   *%rax
  }
  dup(0);  // stdout
    106b:	bf 00 00 00 00       	mov    $0x0,%edi
    1070:	48 b8 76 15 00 00 00 	movabs $0x1576,%rax
    1077:	00 00 00 
    107a:	ff d0                	call   *%rax
  dup(0);  // stderr
    107c:	bf 00 00 00 00       	mov    $0x0,%edi
    1081:	48 b8 76 15 00 00 00 	movabs $0x1576,%rax
    1088:	00 00 00 
    108b:	ff d0                	call   *%rax

  for(;;){
    printf(1, "init: starting sh\n");
    108d:	48 b8 ee 1e 00 00 00 	movabs $0x1eee,%rax
    1094:	00 00 00 
    1097:	48 89 c6             	mov    %rax,%rsi
    109a:	bf 01 00 00 00       	mov    $0x1,%edi
    109f:	b8 00 00 00 00       	mov    $0x0,%eax
    10a4:	48 ba c1 17 00 00 00 	movabs $0x17c1,%rdx
    10ab:	00 00 00 
    10ae:	ff d2                	call   *%rdx
    pid = fork();
    10b0:	48 b8 a6 14 00 00 00 	movabs $0x14a6,%rax
    10b7:	00 00 00 
    10ba:	ff d0                	call   *%rax
    10bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if(pid < 0){
    10bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    10c3:	79 2f                	jns    10f4 <main+0xf4>
      printf(1, "init: fork failed\n");
    10c5:	48 b8 01 1f 00 00 00 	movabs $0x1f01,%rax
    10cc:	00 00 00 
    10cf:	48 89 c6             	mov    %rax,%rsi
    10d2:	bf 01 00 00 00       	mov    $0x1,%edi
    10d7:	b8 00 00 00 00       	mov    $0x0,%eax
    10dc:	48 ba c1 17 00 00 00 	movabs $0x17c1,%rdx
    10e3:	00 00 00 
    10e6:	ff d2                	call   *%rdx
      exit();
    10e8:	48 b8 b3 14 00 00 00 	movabs $0x14b3,%rax
    10ef:	00 00 00 
    10f2:	ff d0                	call   *%rax
    }
    if(pid == 0){
    10f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    10f8:	75 78                	jne    1172 <main+0x172>
      exec("sh", argv);
    10fa:	48 ba 40 1f 00 00 00 	movabs $0x1f40,%rdx
    1101:	00 00 00 
    1104:	48 b8 e3 1e 00 00 00 	movabs $0x1ee3,%rax
    110b:	00 00 00 
    110e:	48 89 d6             	mov    %rdx,%rsi
    1111:	48 89 c7             	mov    %rax,%rdi
    1114:	48 b8 0e 15 00 00 00 	movabs $0x150e,%rax
    111b:	00 00 00 
    111e:	ff d0                	call   *%rax
      printf(1, "init: exec sh failed\n");
    1120:	48 b8 14 1f 00 00 00 	movabs $0x1f14,%rax
    1127:	00 00 00 
    112a:	48 89 c6             	mov    %rax,%rsi
    112d:	bf 01 00 00 00       	mov    $0x1,%edi
    1132:	b8 00 00 00 00       	mov    $0x0,%eax
    1137:	48 ba c1 17 00 00 00 	movabs $0x17c1,%rdx
    113e:	00 00 00 
    1141:	ff d2                	call   *%rdx
      exit();
    1143:	48 b8 b3 14 00 00 00 	movabs $0x14b3,%rax
    114a:	00 00 00 
    114d:	ff d0                	call   *%rax
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
    114f:	48 b8 2a 1f 00 00 00 	movabs $0x1f2a,%rax
    1156:	00 00 00 
    1159:	48 89 c6             	mov    %rax,%rsi
    115c:	bf 01 00 00 00       	mov    $0x1,%edi
    1161:	b8 00 00 00 00       	mov    $0x0,%eax
    1166:	48 ba c1 17 00 00 00 	movabs $0x17c1,%rdx
    116d:	00 00 00 
    1170:	ff d2                	call   *%rdx
    while((wpid=wait()) >= 0 && wpid != pid)
    1172:	48 b8 c0 14 00 00 00 	movabs $0x14c0,%rax
    1179:	00 00 00 
    117c:	ff d0                	call   *%rax
    117e:	89 45 f8             	mov    %eax,-0x8(%rbp)
    1181:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1185:	0f 88 02 ff ff ff    	js     108d <main+0x8d>
    118b:	8b 45 f8             	mov    -0x8(%rbp),%eax
    118e:	3b 45 fc             	cmp    -0x4(%rbp),%eax
    1191:	75 bc                	jne    114f <main+0x14f>
    printf(1, "init: starting sh\n");
    1193:	e9 f5 fe ff ff       	jmp    108d <main+0x8d>

0000000000001198 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1198:	55                   	push   %rbp
    1199:	48 89 e5             	mov    %rsp,%rbp
    119c:	48 83 ec 10          	sub    $0x10,%rsp
    11a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11a4:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11a7:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    11aa:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    11ae:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11b4:	48 89 ce             	mov    %rcx,%rsi
    11b7:	48 89 f7             	mov    %rsi,%rdi
    11ba:	89 d1                	mov    %edx,%ecx
    11bc:	fc                   	cld
    11bd:	f3 aa                	rep stos %al,(%rdi)
    11bf:	89 ca                	mov    %ecx,%edx
    11c1:	48 89 fe             	mov    %rdi,%rsi
    11c4:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11c8:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11cb:	90                   	nop
    11cc:	c9                   	leave
    11cd:	c3                   	ret

00000000000011ce <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11ce:	55                   	push   %rbp
    11cf:	48 89 e5             	mov    %rsp,%rbp
    11d2:	48 83 ec 20          	sub    $0x20,%rsp
    11d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    11da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    11de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    11e6:	90                   	nop
    11e7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    11eb:	48 8d 42 01          	lea    0x1(%rdx),%rax
    11ef:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    11f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11f7:	48 8d 48 01          	lea    0x1(%rax),%rcx
    11fb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    11ff:	0f b6 12             	movzbl (%rdx),%edx
    1202:	88 10                	mov    %dl,(%rax)
    1204:	0f b6 00             	movzbl (%rax),%eax
    1207:	84 c0                	test   %al,%al
    1209:	75 dc                	jne    11e7 <strcpy+0x19>
    ;
  return os;
    120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    120f:	c9                   	leave
    1210:	c3                   	ret

0000000000001211 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1211:	55                   	push   %rbp
    1212:	48 89 e5             	mov    %rsp,%rbp
    1215:	48 83 ec 10          	sub    $0x10,%rsp
    1219:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    121d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1221:	eb 0a                	jmp    122d <strcmp+0x1c>
    p++, q++;
    1223:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1228:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1231:	0f b6 00             	movzbl (%rax),%eax
    1234:	84 c0                	test   %al,%al
    1236:	74 12                	je     124a <strcmp+0x39>
    1238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    123c:	0f b6 10             	movzbl (%rax),%edx
    123f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1243:	0f b6 00             	movzbl (%rax),%eax
    1246:	38 c2                	cmp    %al,%dl
    1248:	74 d9                	je     1223 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    124a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    124e:	0f b6 00             	movzbl (%rax),%eax
    1251:	0f b6 d0             	movzbl %al,%edx
    1254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1258:	0f b6 00             	movzbl (%rax),%eax
    125b:	0f b6 c0             	movzbl %al,%eax
    125e:	29 c2                	sub    %eax,%edx
    1260:	89 d0                	mov    %edx,%eax
}
    1262:	c9                   	leave
    1263:	c3                   	ret

0000000000001264 <strlen>:

uint
strlen(char *s)
{
    1264:	55                   	push   %rbp
    1265:	48 89 e5             	mov    %rsp,%rbp
    1268:	48 83 ec 18          	sub    $0x18,%rsp
    126c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1270:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1277:	eb 04                	jmp    127d <strlen+0x19>
    1279:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    127d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1280:	48 63 d0             	movslq %eax,%rdx
    1283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1287:	48 01 d0             	add    %rdx,%rax
    128a:	0f b6 00             	movzbl (%rax),%eax
    128d:	84 c0                	test   %al,%al
    128f:	75 e8                	jne    1279 <strlen+0x15>
    ;
  return n;
    1291:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1294:	c9                   	leave
    1295:	c3                   	ret

0000000000001296 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1296:	55                   	push   %rbp
    1297:	48 89 e5             	mov    %rsp,%rbp
    129a:	48 83 ec 10          	sub    $0x10,%rsp
    129e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12a2:	89 75 f4             	mov    %esi,-0xc(%rbp)
    12a5:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    12a8:	8b 55 f0             	mov    -0x10(%rbp),%edx
    12ab:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    12ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12b2:	89 ce                	mov    %ecx,%esi
    12b4:	48 89 c7             	mov    %rax,%rdi
    12b7:	48 b8 98 11 00 00 00 	movabs $0x1198,%rax
    12be:	00 00 00 
    12c1:	ff d0                	call   *%rax
  return dst;
    12c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12c7:	c9                   	leave
    12c8:	c3                   	ret

00000000000012c9 <strchr>:

char*
strchr(const char *s, char c)
{
    12c9:	55                   	push   %rbp
    12ca:	48 89 e5             	mov    %rsp,%rbp
    12cd:	48 83 ec 10          	sub    $0x10,%rsp
    12d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12d5:	89 f0                	mov    %esi,%eax
    12d7:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    12da:	eb 17                	jmp    12f3 <strchr+0x2a>
    if(*s == c)
    12dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12e0:	0f b6 00             	movzbl (%rax),%eax
    12e3:	38 45 f4             	cmp    %al,-0xc(%rbp)
    12e6:	75 06                	jne    12ee <strchr+0x25>
      return (char*)s;
    12e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12ec:	eb 15                	jmp    1303 <strchr+0x3a>
  for(; *s; s++)
    12ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    12f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12f7:	0f b6 00             	movzbl (%rax),%eax
    12fa:	84 c0                	test   %al,%al
    12fc:	75 de                	jne    12dc <strchr+0x13>
  return 0;
    12fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1303:	c9                   	leave
    1304:	c3                   	ret

0000000000001305 <gets>:

char*
gets(char *buf, int max)
{
    1305:	55                   	push   %rbp
    1306:	48 89 e5             	mov    %rsp,%rbp
    1309:	48 83 ec 20          	sub    $0x20,%rsp
    130d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1311:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1314:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    131b:	eb 4f                	jmp    136c <gets+0x67>
    cc = read(0, &c, 1);
    131d:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1321:	ba 01 00 00 00       	mov    $0x1,%edx
    1326:	48 89 c6             	mov    %rax,%rsi
    1329:	bf 00 00 00 00       	mov    $0x0,%edi
    132e:	48 b8 da 14 00 00 00 	movabs $0x14da,%rax
    1335:	00 00 00 
    1338:	ff d0                	call   *%rax
    133a:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    133d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1341:	7e 36                	jle    1379 <gets+0x74>
      break;
    buf[i++] = c;
    1343:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1346:	8d 50 01             	lea    0x1(%rax),%edx
    1349:	89 55 fc             	mov    %edx,-0x4(%rbp)
    134c:	48 63 d0             	movslq %eax,%rdx
    134f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1353:	48 01 c2             	add    %rax,%rdx
    1356:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    135a:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    135c:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1360:	3c 0a                	cmp    $0xa,%al
    1362:	74 16                	je     137a <gets+0x75>
    1364:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1368:	3c 0d                	cmp    $0xd,%al
    136a:	74 0e                	je     137a <gets+0x75>
  for(i=0; i+1 < max; ){
    136c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    136f:	83 c0 01             	add    $0x1,%eax
    1372:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1375:	7f a6                	jg     131d <gets+0x18>
    1377:	eb 01                	jmp    137a <gets+0x75>
      break;
    1379:	90                   	nop
      break;
  }
  buf[i] = '\0';
    137a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    137d:	48 63 d0             	movslq %eax,%rdx
    1380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1384:	48 01 d0             	add    %rdx,%rax
    1387:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    138a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    138e:	c9                   	leave
    138f:	c3                   	ret

0000000000001390 <stat>:

int
stat(char *n, struct stat *st)
{
    1390:	55                   	push   %rbp
    1391:	48 89 e5             	mov    %rsp,%rbp
    1394:	48 83 ec 20          	sub    $0x20,%rsp
    1398:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    139c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13a4:	be 00 00 00 00       	mov    $0x0,%esi
    13a9:	48 89 c7             	mov    %rax,%rdi
    13ac:	48 b8 1b 15 00 00 00 	movabs $0x151b,%rax
    13b3:	00 00 00 
    13b6:	ff d0                	call   *%rax
    13b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    13bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    13bf:	79 07                	jns    13c8 <stat+0x38>
    return -1;
    13c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13c6:	eb 2f                	jmp    13f7 <stat+0x67>
  r = fstat(fd, st);
    13c8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    13cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13cf:	48 89 d6             	mov    %rdx,%rsi
    13d2:	89 c7                	mov    %eax,%edi
    13d4:	48 b8 42 15 00 00 00 	movabs $0x1542,%rax
    13db:	00 00 00 
    13de:	ff d0                	call   *%rax
    13e0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    13e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13e6:	89 c7                	mov    %eax,%edi
    13e8:	48 b8 f4 14 00 00 00 	movabs $0x14f4,%rax
    13ef:	00 00 00 
    13f2:	ff d0                	call   *%rax
  return r;
    13f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    13f7:	c9                   	leave
    13f8:	c3                   	ret

00000000000013f9 <atoi>:

int
atoi(const char *s)
{
    13f9:	55                   	push   %rbp
    13fa:	48 89 e5             	mov    %rsp,%rbp
    13fd:	48 83 ec 18          	sub    $0x18,%rsp
    1401:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1405:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    140c:	eb 28                	jmp    1436 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    140e:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1411:	89 d0                	mov    %edx,%eax
    1413:	c1 e0 02             	shl    $0x2,%eax
    1416:	01 d0                	add    %edx,%eax
    1418:	01 c0                	add    %eax,%eax
    141a:	89 c1                	mov    %eax,%ecx
    141c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1420:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1424:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1428:	0f b6 00             	movzbl (%rax),%eax
    142b:	0f be c0             	movsbl %al,%eax
    142e:	01 c8                	add    %ecx,%eax
    1430:	83 e8 30             	sub    $0x30,%eax
    1433:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    143a:	0f b6 00             	movzbl (%rax),%eax
    143d:	3c 2f                	cmp    $0x2f,%al
    143f:	7e 0b                	jle    144c <atoi+0x53>
    1441:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1445:	0f b6 00             	movzbl (%rax),%eax
    1448:	3c 39                	cmp    $0x39,%al
    144a:	7e c2                	jle    140e <atoi+0x15>
  return n;
    144c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    144f:	c9                   	leave
    1450:	c3                   	ret

0000000000001451 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1451:	55                   	push   %rbp
    1452:	48 89 e5             	mov    %rsp,%rbp
    1455:	48 83 ec 28          	sub    $0x28,%rsp
    1459:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    145d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1461:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1468:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    146c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1470:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1474:	eb 1d                	jmp    1493 <memmove+0x42>
    *dst++ = *src++;
    1476:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    147a:	48 8d 42 01          	lea    0x1(%rdx),%rax
    147e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1482:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1486:	48 8d 48 01          	lea    0x1(%rax),%rcx
    148a:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    148e:	0f b6 12             	movzbl (%rdx),%edx
    1491:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1493:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1496:	8d 50 ff             	lea    -0x1(%rax),%edx
    1499:	89 55 dc             	mov    %edx,-0x24(%rbp)
    149c:	85 c0                	test   %eax,%eax
    149e:	7f d6                	jg     1476 <memmove+0x25>
  return vdst;
    14a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14a4:	c9                   	leave
    14a5:	c3                   	ret

00000000000014a6 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14a6:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14ad:	49 89 ca             	mov    %rcx,%r10
    14b0:	0f 05                	syscall
    14b2:	c3                   	ret

00000000000014b3 <exit>:
SYSCALL(exit)
    14b3:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    14ba:	49 89 ca             	mov    %rcx,%r10
    14bd:	0f 05                	syscall
    14bf:	c3                   	ret

00000000000014c0 <wait>:
SYSCALL(wait)
    14c0:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    14c7:	49 89 ca             	mov    %rcx,%r10
    14ca:	0f 05                	syscall
    14cc:	c3                   	ret

00000000000014cd <pipe>:
SYSCALL(pipe)
    14cd:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    14d4:	49 89 ca             	mov    %rcx,%r10
    14d7:	0f 05                	syscall
    14d9:	c3                   	ret

00000000000014da <read>:
SYSCALL(read)
    14da:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    14e1:	49 89 ca             	mov    %rcx,%r10
    14e4:	0f 05                	syscall
    14e6:	c3                   	ret

00000000000014e7 <write>:
SYSCALL(write)
    14e7:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    14ee:	49 89 ca             	mov    %rcx,%r10
    14f1:	0f 05                	syscall
    14f3:	c3                   	ret

00000000000014f4 <close>:
SYSCALL(close)
    14f4:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    14fb:	49 89 ca             	mov    %rcx,%r10
    14fe:	0f 05                	syscall
    1500:	c3                   	ret

0000000000001501 <kill>:
SYSCALL(kill)
    1501:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1508:	49 89 ca             	mov    %rcx,%r10
    150b:	0f 05                	syscall
    150d:	c3                   	ret

000000000000150e <exec>:
SYSCALL(exec)
    150e:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1515:	49 89 ca             	mov    %rcx,%r10
    1518:	0f 05                	syscall
    151a:	c3                   	ret

000000000000151b <open>:
SYSCALL(open)
    151b:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1522:	49 89 ca             	mov    %rcx,%r10
    1525:	0f 05                	syscall
    1527:	c3                   	ret

0000000000001528 <mknod>:
SYSCALL(mknod)
    1528:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    152f:	49 89 ca             	mov    %rcx,%r10
    1532:	0f 05                	syscall
    1534:	c3                   	ret

0000000000001535 <unlink>:
SYSCALL(unlink)
    1535:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    153c:	49 89 ca             	mov    %rcx,%r10
    153f:	0f 05                	syscall
    1541:	c3                   	ret

0000000000001542 <fstat>:
SYSCALL(fstat)
    1542:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1549:	49 89 ca             	mov    %rcx,%r10
    154c:	0f 05                	syscall
    154e:	c3                   	ret

000000000000154f <link>:
SYSCALL(link)
    154f:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1556:	49 89 ca             	mov    %rcx,%r10
    1559:	0f 05                	syscall
    155b:	c3                   	ret

000000000000155c <mkdir>:
SYSCALL(mkdir)
    155c:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1563:	49 89 ca             	mov    %rcx,%r10
    1566:	0f 05                	syscall
    1568:	c3                   	ret

0000000000001569 <chdir>:
SYSCALL(chdir)
    1569:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1570:	49 89 ca             	mov    %rcx,%r10
    1573:	0f 05                	syscall
    1575:	c3                   	ret

0000000000001576 <dup>:
SYSCALL(dup)
    1576:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    157d:	49 89 ca             	mov    %rcx,%r10
    1580:	0f 05                	syscall
    1582:	c3                   	ret

0000000000001583 <getpid>:
SYSCALL(getpid)
    1583:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    158a:	49 89 ca             	mov    %rcx,%r10
    158d:	0f 05                	syscall
    158f:	c3                   	ret

0000000000001590 <sbrk>:
SYSCALL(sbrk)
    1590:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1597:	49 89 ca             	mov    %rcx,%r10
    159a:	0f 05                	syscall
    159c:	c3                   	ret

000000000000159d <sleep>:
SYSCALL(sleep)
    159d:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15a4:	49 89 ca             	mov    %rcx,%r10
    15a7:	0f 05                	syscall
    15a9:	c3                   	ret

00000000000015aa <uptime>:
SYSCALL(uptime)
    15aa:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    15b1:	49 89 ca             	mov    %rcx,%r10
    15b4:	0f 05                	syscall
    15b6:	c3                   	ret

00000000000015b7 <traceread>:
SYSCALL(traceread)
    15b7:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    15be:	49 89 ca             	mov    %rcx,%r10
    15c1:	0f 05                	syscall
    15c3:	c3                   	ret

00000000000015c4 <vidclear>:
SYSCALL(vidclear)
    15c4:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    15cb:	49 89 ca             	mov    %rcx,%r10
    15ce:	0f 05                	syscall
    15d0:	c3                   	ret

00000000000015d1 <vidputc>:
SYSCALL(vidputc)
    15d1:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    15d8:	49 89 ca             	mov    %rcx,%r10
    15db:	0f 05                	syscall
    15dd:	c3                   	ret

00000000000015de <vidputs>:
SYSCALL(vidputs)
    15de:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    15e5:	49 89 ca             	mov    %rcx,%r10
    15e8:	0f 05                	syscall
    15ea:	c3                   	ret

00000000000015eb <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    15eb:	55                   	push   %rbp
    15ec:	48 89 e5             	mov    %rsp,%rbp
    15ef:	48 83 ec 10          	sub    $0x10,%rsp
    15f3:	89 7d fc             	mov    %edi,-0x4(%rbp)
    15f6:	89 f0                	mov    %esi,%eax
    15f8:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    15fb:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    15ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1602:	ba 01 00 00 00       	mov    $0x1,%edx
    1607:	48 89 ce             	mov    %rcx,%rsi
    160a:	89 c7                	mov    %eax,%edi
    160c:	48 b8 e7 14 00 00 00 	movabs $0x14e7,%rax
    1613:	00 00 00 
    1616:	ff d0                	call   *%rax
}
    1618:	90                   	nop
    1619:	c9                   	leave
    161a:	c3                   	ret

000000000000161b <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    161b:	55                   	push   %rbp
    161c:	48 89 e5             	mov    %rsp,%rbp
    161f:	48 83 ec 20          	sub    $0x20,%rsp
    1623:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1626:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    162a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1631:	eb 35                	jmp    1668 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1633:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1637:	48 c1 e8 3c          	shr    $0x3c,%rax
    163b:	48 ba 50 1f 00 00 00 	movabs $0x1f50,%rdx
    1642:	00 00 00 
    1645:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1649:	0f be d0             	movsbl %al,%edx
    164c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    164f:	89 d6                	mov    %edx,%esi
    1651:	89 c7                	mov    %eax,%edi
    1653:	48 b8 eb 15 00 00 00 	movabs $0x15eb,%rax
    165a:	00 00 00 
    165d:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    165f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1663:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1668:	8b 45 fc             	mov    -0x4(%rbp),%eax
    166b:	83 f8 0f             	cmp    $0xf,%eax
    166e:	76 c3                	jbe    1633 <print_x64+0x18>
}
    1670:	90                   	nop
    1671:	90                   	nop
    1672:	c9                   	leave
    1673:	c3                   	ret

0000000000001674 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1674:	55                   	push   %rbp
    1675:	48 89 e5             	mov    %rsp,%rbp
    1678:	48 83 ec 20          	sub    $0x20,%rsp
    167c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    167f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1682:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1689:	eb 36                	jmp    16c1 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    168b:	8b 45 e8             	mov    -0x18(%rbp),%eax
    168e:	c1 e8 1c             	shr    $0x1c,%eax
    1691:	89 c2                	mov    %eax,%edx
    1693:	48 b8 50 1f 00 00 00 	movabs $0x1f50,%rax
    169a:	00 00 00 
    169d:	89 d2                	mov    %edx,%edx
    169f:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    16a3:	0f be d0             	movsbl %al,%edx
    16a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16a9:	89 d6                	mov    %edx,%esi
    16ab:	89 c7                	mov    %eax,%edi
    16ad:	48 b8 eb 15 00 00 00 	movabs $0x15eb,%rax
    16b4:	00 00 00 
    16b7:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16bd:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    16c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16c4:	83 f8 07             	cmp    $0x7,%eax
    16c7:	76 c2                	jbe    168b <print_x32+0x17>
}
    16c9:	90                   	nop
    16ca:	90                   	nop
    16cb:	c9                   	leave
    16cc:	c3                   	ret

00000000000016cd <print_d>:

  static void
print_d(int fd, int v)
{
    16cd:	55                   	push   %rbp
    16ce:	48 89 e5             	mov    %rsp,%rbp
    16d1:	48 83 ec 30          	sub    $0x30,%rsp
    16d5:	89 7d dc             	mov    %edi,-0x24(%rbp)
    16d8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    16db:	8b 45 d8             	mov    -0x28(%rbp),%eax
    16de:	48 98                	cltq
    16e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    16e4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16e8:	79 04                	jns    16ee <print_d+0x21>
    x = -x;
    16ea:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    16ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    16f5:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    16f9:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1700:	66 66 66 
    1703:	48 89 c8             	mov    %rcx,%rax
    1706:	48 f7 ea             	imul   %rdx
    1709:	48 c1 fa 02          	sar    $0x2,%rdx
    170d:	48 89 c8             	mov    %rcx,%rax
    1710:	48 c1 f8 3f          	sar    $0x3f,%rax
    1714:	48 29 c2             	sub    %rax,%rdx
    1717:	48 89 d0             	mov    %rdx,%rax
    171a:	48 c1 e0 02          	shl    $0x2,%rax
    171e:	48 01 d0             	add    %rdx,%rax
    1721:	48 01 c0             	add    %rax,%rax
    1724:	48 29 c1             	sub    %rax,%rcx
    1727:	48 89 ca             	mov    %rcx,%rdx
    172a:	8b 45 f4             	mov    -0xc(%rbp),%eax
    172d:	8d 48 01             	lea    0x1(%rax),%ecx
    1730:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1733:	48 b9 50 1f 00 00 00 	movabs $0x1f50,%rcx
    173a:	00 00 00 
    173d:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1741:	48 98                	cltq
    1743:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1747:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    174b:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1752:	66 66 66 
    1755:	48 89 c8             	mov    %rcx,%rax
    1758:	48 f7 ea             	imul   %rdx
    175b:	48 89 d0             	mov    %rdx,%rax
    175e:	48 c1 f8 02          	sar    $0x2,%rax
    1762:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1766:	48 89 ca             	mov    %rcx,%rdx
    1769:	48 29 d0             	sub    %rdx,%rax
    176c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1770:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1775:	0f 85 7a ff ff ff    	jne    16f5 <print_d+0x28>

  if (v < 0)
    177b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    177f:	79 32                	jns    17b3 <print_d+0xe6>
    buf[i++] = '-';
    1781:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1784:	8d 50 01             	lea    0x1(%rax),%edx
    1787:	89 55 f4             	mov    %edx,-0xc(%rbp)
    178a:	48 98                	cltq
    178c:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1791:	eb 20                	jmp    17b3 <print_d+0xe6>
    putc(fd, buf[i]);
    1793:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1796:	48 98                	cltq
    1798:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    179d:	0f be d0             	movsbl %al,%edx
    17a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17a3:	89 d6                	mov    %edx,%esi
    17a5:	89 c7                	mov    %eax,%edi
    17a7:	48 b8 eb 15 00 00 00 	movabs $0x15eb,%rax
    17ae:	00 00 00 
    17b1:	ff d0                	call   *%rax
  while (--i >= 0)
    17b3:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    17b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    17bb:	79 d6                	jns    1793 <print_d+0xc6>
}
    17bd:	90                   	nop
    17be:	90                   	nop
    17bf:	c9                   	leave
    17c0:	c3                   	ret

00000000000017c1 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    17c1:	55                   	push   %rbp
    17c2:	48 89 e5             	mov    %rsp,%rbp
    17c5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    17cc:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    17d2:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    17d9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    17e0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    17e7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    17ee:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    17f5:	84 c0                	test   %al,%al
    17f7:	74 20                	je     1819 <printf+0x58>
    17f9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    17fd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1801:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1805:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1809:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    180d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1811:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1815:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1819:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1820:	00 00 00 
    1823:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    182a:	00 00 00 
    182d:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1831:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1838:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    183f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1846:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    184d:	00 00 00 
    1850:	e9 60 03 00 00       	jmp    1bb5 <printf+0x3f4>
    if (c != '%') {
    1855:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    185c:	74 24                	je     1882 <printf+0xc1>
      putc(fd, c);
    185e:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1864:	0f be d0             	movsbl %al,%edx
    1867:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    186d:	89 d6                	mov    %edx,%esi
    186f:	89 c7                	mov    %eax,%edi
    1871:	48 b8 eb 15 00 00 00 	movabs $0x15eb,%rax
    1878:	00 00 00 
    187b:	ff d0                	call   *%rax
      continue;
    187d:	e9 2c 03 00 00       	jmp    1bae <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    1882:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1889:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    188f:	48 63 d0             	movslq %eax,%rdx
    1892:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1899:	48 01 d0             	add    %rdx,%rax
    189c:	0f b6 00             	movzbl (%rax),%eax
    189f:	0f be c0             	movsbl %al,%eax
    18a2:	25 ff 00 00 00       	and    $0xff,%eax
    18a7:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    18ad:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    18b4:	0f 84 2e 03 00 00    	je     1be8 <printf+0x427>
      break;
    switch(c) {
    18ba:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    18c1:	0f 84 32 01 00 00    	je     19f9 <printf+0x238>
    18c7:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    18ce:	0f 8f a1 02 00 00    	jg     1b75 <printf+0x3b4>
    18d4:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    18db:	0f 84 d4 01 00 00    	je     1ab5 <printf+0x2f4>
    18e1:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    18e8:	0f 8f 87 02 00 00    	jg     1b75 <printf+0x3b4>
    18ee:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    18f5:	0f 84 5b 01 00 00    	je     1a56 <printf+0x295>
    18fb:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1902:	0f 8f 6d 02 00 00    	jg     1b75 <printf+0x3b4>
    1908:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    190f:	0f 84 87 00 00 00    	je     199c <printf+0x1db>
    1915:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    191c:	0f 8f 53 02 00 00    	jg     1b75 <printf+0x3b4>
    1922:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1929:	0f 84 2b 02 00 00    	je     1b5a <printf+0x399>
    192f:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1936:	0f 85 39 02 00 00    	jne    1b75 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    193c:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1942:	83 f8 2f             	cmp    $0x2f,%eax
    1945:	77 23                	ja     196a <printf+0x1a9>
    1947:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    194e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1954:	89 d2                	mov    %edx,%edx
    1956:	48 01 d0             	add    %rdx,%rax
    1959:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    195f:	83 c2 08             	add    $0x8,%edx
    1962:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1968:	eb 12                	jmp    197c <printf+0x1bb>
    196a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1971:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1975:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    197c:	8b 00                	mov    (%rax),%eax
    197e:	0f be d0             	movsbl %al,%edx
    1981:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1987:	89 d6                	mov    %edx,%esi
    1989:	89 c7                	mov    %eax,%edi
    198b:	48 b8 eb 15 00 00 00 	movabs $0x15eb,%rax
    1992:	00 00 00 
    1995:	ff d0                	call   *%rax
      break;
    1997:	e9 12 02 00 00       	jmp    1bae <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    199c:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19a2:	83 f8 2f             	cmp    $0x2f,%eax
    19a5:	77 23                	ja     19ca <printf+0x209>
    19a7:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19ae:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19b4:	89 d2                	mov    %edx,%edx
    19b6:	48 01 d0             	add    %rdx,%rax
    19b9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19bf:	83 c2 08             	add    $0x8,%edx
    19c2:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19c8:	eb 12                	jmp    19dc <printf+0x21b>
    19ca:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19d1:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19d5:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19dc:	8b 10                	mov    (%rax),%edx
    19de:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19e4:	89 d6                	mov    %edx,%esi
    19e6:	89 c7                	mov    %eax,%edi
    19e8:	48 b8 cd 16 00 00 00 	movabs $0x16cd,%rax
    19ef:	00 00 00 
    19f2:	ff d0                	call   *%rax
      break;
    19f4:	e9 b5 01 00 00       	jmp    1bae <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    19f9:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19ff:	83 f8 2f             	cmp    $0x2f,%eax
    1a02:	77 23                	ja     1a27 <printf+0x266>
    1a04:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a0b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a11:	89 d2                	mov    %edx,%edx
    1a13:	48 01 d0             	add    %rdx,%rax
    1a16:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a1c:	83 c2 08             	add    $0x8,%edx
    1a1f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a25:	eb 12                	jmp    1a39 <printf+0x278>
    1a27:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a2e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a32:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a39:	8b 10                	mov    (%rax),%edx
    1a3b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a41:	89 d6                	mov    %edx,%esi
    1a43:	89 c7                	mov    %eax,%edi
    1a45:	48 b8 74 16 00 00 00 	movabs $0x1674,%rax
    1a4c:	00 00 00 
    1a4f:	ff d0                	call   *%rax
      break;
    1a51:	e9 58 01 00 00       	jmp    1bae <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a56:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a5c:	83 f8 2f             	cmp    $0x2f,%eax
    1a5f:	77 23                	ja     1a84 <printf+0x2c3>
    1a61:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a68:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a6e:	89 d2                	mov    %edx,%edx
    1a70:	48 01 d0             	add    %rdx,%rax
    1a73:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a79:	83 c2 08             	add    $0x8,%edx
    1a7c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a82:	eb 12                	jmp    1a96 <printf+0x2d5>
    1a84:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a8b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a8f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a96:	48 8b 10             	mov    (%rax),%rdx
    1a99:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a9f:	48 89 d6             	mov    %rdx,%rsi
    1aa2:	89 c7                	mov    %eax,%edi
    1aa4:	48 b8 1b 16 00 00 00 	movabs $0x161b,%rax
    1aab:	00 00 00 
    1aae:	ff d0                	call   *%rax
      break;
    1ab0:	e9 f9 00 00 00       	jmp    1bae <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1ab5:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1abb:	83 f8 2f             	cmp    $0x2f,%eax
    1abe:	77 23                	ja     1ae3 <printf+0x322>
    1ac0:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ac7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1acd:	89 d2                	mov    %edx,%edx
    1acf:	48 01 d0             	add    %rdx,%rax
    1ad2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ad8:	83 c2 08             	add    $0x8,%edx
    1adb:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1ae1:	eb 12                	jmp    1af5 <printf+0x334>
    1ae3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1aea:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1aee:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1af5:	48 8b 00             	mov    (%rax),%rax
    1af8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1aff:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1b06:	00 
    1b07:	75 41                	jne    1b4a <printf+0x389>
        s = "(null)";
    1b09:	48 b8 33 1f 00 00 00 	movabs $0x1f33,%rax
    1b10:	00 00 00 
    1b13:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1b1a:	eb 2e                	jmp    1b4a <printf+0x389>
        putc(fd, *(s++));
    1b1c:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b23:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1b27:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1b2e:	0f b6 00             	movzbl (%rax),%eax
    1b31:	0f be d0             	movsbl %al,%edx
    1b34:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b3a:	89 d6                	mov    %edx,%esi
    1b3c:	89 c7                	mov    %eax,%edi
    1b3e:	48 b8 eb 15 00 00 00 	movabs $0x15eb,%rax
    1b45:	00 00 00 
    1b48:	ff d0                	call   *%rax
      while (*s)
    1b4a:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b51:	0f b6 00             	movzbl (%rax),%eax
    1b54:	84 c0                	test   %al,%al
    1b56:	75 c4                	jne    1b1c <printf+0x35b>
      break;
    1b58:	eb 54                	jmp    1bae <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1b5a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b60:	be 25 00 00 00       	mov    $0x25,%esi
    1b65:	89 c7                	mov    %eax,%edi
    1b67:	48 b8 eb 15 00 00 00 	movabs $0x15eb,%rax
    1b6e:	00 00 00 
    1b71:	ff d0                	call   *%rax
      break;
    1b73:	eb 39                	jmp    1bae <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b75:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b7b:	be 25 00 00 00       	mov    $0x25,%esi
    1b80:	89 c7                	mov    %eax,%edi
    1b82:	48 b8 eb 15 00 00 00 	movabs $0x15eb,%rax
    1b89:	00 00 00 
    1b8c:	ff d0                	call   *%rax
      putc(fd, c);
    1b8e:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b94:	0f be d0             	movsbl %al,%edx
    1b97:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b9d:	89 d6                	mov    %edx,%esi
    1b9f:	89 c7                	mov    %eax,%edi
    1ba1:	48 b8 eb 15 00 00 00 	movabs $0x15eb,%rax
    1ba8:	00 00 00 
    1bab:	ff d0                	call   *%rax
      break;
    1bad:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1bae:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1bb5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1bbb:	48 63 d0             	movslq %eax,%rdx
    1bbe:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bc5:	48 01 d0             	add    %rdx,%rax
    1bc8:	0f b6 00             	movzbl (%rax),%eax
    1bcb:	0f be c0             	movsbl %al,%eax
    1bce:	25 ff 00 00 00       	and    $0xff,%eax
    1bd3:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1bd9:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1be0:	0f 85 6f fc ff ff    	jne    1855 <printf+0x94>
    }
  }
}
    1be6:	eb 01                	jmp    1be9 <printf+0x428>
      break;
    1be8:	90                   	nop
}
    1be9:	90                   	nop
    1bea:	c9                   	leave
    1beb:	c3                   	ret

0000000000001bec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1bec:	55                   	push   %rbp
    1bed:	48 89 e5             	mov    %rsp,%rbp
    1bf0:	48 83 ec 18          	sub    $0x18,%rsp
    1bf4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1bfc:	48 83 e8 10          	sub    $0x10,%rax
    1c00:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c04:	48 b8 80 1f 00 00 00 	movabs $0x1f80,%rax
    1c0b:	00 00 00 
    1c0e:	48 8b 00             	mov    (%rax),%rax
    1c11:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c15:	eb 2f                	jmp    1c46 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1c17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c1b:	48 8b 00             	mov    (%rax),%rax
    1c1e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c22:	72 17                	jb     1c3b <free+0x4f>
    1c24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c28:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c2c:	72 2f                	jb     1c5d <free+0x71>
    1c2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c32:	48 8b 00             	mov    (%rax),%rax
    1c35:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c39:	72 22                	jb     1c5d <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c3f:	48 8b 00             	mov    (%rax),%rax
    1c42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c4a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c4e:	73 c7                	jae    1c17 <free+0x2b>
    1c50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c54:	48 8b 00             	mov    (%rax),%rax
    1c57:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c5b:	73 ba                	jae    1c17 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c61:	8b 40 08             	mov    0x8(%rax),%eax
    1c64:	89 c0                	mov    %eax,%eax
    1c66:	48 c1 e0 04          	shl    $0x4,%rax
    1c6a:	48 89 c2             	mov    %rax,%rdx
    1c6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c71:	48 01 c2             	add    %rax,%rdx
    1c74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c78:	48 8b 00             	mov    (%rax),%rax
    1c7b:	48 39 c2             	cmp    %rax,%rdx
    1c7e:	75 2d                	jne    1cad <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1c80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c84:	8b 50 08             	mov    0x8(%rax),%edx
    1c87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c8b:	48 8b 00             	mov    (%rax),%rax
    1c8e:	8b 40 08             	mov    0x8(%rax),%eax
    1c91:	01 c2                	add    %eax,%edx
    1c93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c97:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1c9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c9e:	48 8b 00             	mov    (%rax),%rax
    1ca1:	48 8b 10             	mov    (%rax),%rdx
    1ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ca8:	48 89 10             	mov    %rdx,(%rax)
    1cab:	eb 0e                	jmp    1cbb <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1cad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb1:	48 8b 10             	mov    (%rax),%rdx
    1cb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cb8:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1cbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cbf:	8b 40 08             	mov    0x8(%rax),%eax
    1cc2:	89 c0                	mov    %eax,%eax
    1cc4:	48 c1 e0 04          	shl    $0x4,%rax
    1cc8:	48 89 c2             	mov    %rax,%rdx
    1ccb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ccf:	48 01 d0             	add    %rdx,%rax
    1cd2:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cd6:	75 27                	jne    1cff <free+0x113>
    p->s.size += bp->s.size;
    1cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cdc:	8b 50 08             	mov    0x8(%rax),%edx
    1cdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ce3:	8b 40 08             	mov    0x8(%rax),%eax
    1ce6:	01 c2                	add    %eax,%edx
    1ce8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cec:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1cef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cf3:	48 8b 10             	mov    (%rax),%rdx
    1cf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cfa:	48 89 10             	mov    %rdx,(%rax)
    1cfd:	eb 0b                	jmp    1d0a <free+0x11e>
  } else
    p->s.ptr = bp;
    1cff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1d07:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1d0a:	48 ba 80 1f 00 00 00 	movabs $0x1f80,%rdx
    1d11:	00 00 00 
    1d14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d18:	48 89 02             	mov    %rax,(%rdx)
}
    1d1b:	90                   	nop
    1d1c:	c9                   	leave
    1d1d:	c3                   	ret

0000000000001d1e <morecore>:

static Header*
morecore(uint nu)
{
    1d1e:	55                   	push   %rbp
    1d1f:	48 89 e5             	mov    %rsp,%rbp
    1d22:	48 83 ec 20          	sub    $0x20,%rsp
    1d26:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1d29:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1d30:	77 07                	ja     1d39 <morecore+0x1b>
    nu = 4096;
    1d32:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d39:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d3c:	48 c1 e0 04          	shl    $0x4,%rax
    1d40:	48 89 c7             	mov    %rax,%rdi
    1d43:	48 b8 90 15 00 00 00 	movabs $0x1590,%rax
    1d4a:	00 00 00 
    1d4d:	ff d0                	call   *%rax
    1d4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d53:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d58:	75 07                	jne    1d61 <morecore+0x43>
    return 0;
    1d5a:	b8 00 00 00 00       	mov    $0x0,%eax
    1d5f:	eb 36                	jmp    1d97 <morecore+0x79>
  hp = (Header*)p;
    1d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d65:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d6d:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d70:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d77:	48 83 c0 10          	add    $0x10,%rax
    1d7b:	48 89 c7             	mov    %rax,%rdi
    1d7e:	48 b8 ec 1b 00 00 00 	movabs $0x1bec,%rax
    1d85:	00 00 00 
    1d88:	ff d0                	call   *%rax
  return freep;
    1d8a:	48 b8 80 1f 00 00 00 	movabs $0x1f80,%rax
    1d91:	00 00 00 
    1d94:	48 8b 00             	mov    (%rax),%rax
}
    1d97:	c9                   	leave
    1d98:	c3                   	ret

0000000000001d99 <malloc>:

void*
malloc(uint nbytes)
{
    1d99:	55                   	push   %rbp
    1d9a:	48 89 e5             	mov    %rsp,%rbp
    1d9d:	48 83 ec 30          	sub    $0x30,%rsp
    1da1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1da4:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1da7:	48 83 c0 0f          	add    $0xf,%rax
    1dab:	48 c1 e8 04          	shr    $0x4,%rax
    1daf:	83 c0 01             	add    $0x1,%eax
    1db2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1db5:	48 b8 80 1f 00 00 00 	movabs $0x1f80,%rax
    1dbc:	00 00 00 
    1dbf:	48 8b 00             	mov    (%rax),%rax
    1dc2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dc6:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1dcb:	75 4a                	jne    1e17 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1dcd:	48 b8 70 1f 00 00 00 	movabs $0x1f70,%rax
    1dd4:	00 00 00 
    1dd7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ddb:	48 ba 80 1f 00 00 00 	movabs $0x1f80,%rdx
    1de2:	00 00 00 
    1de5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1de9:	48 89 02             	mov    %rax,(%rdx)
    1dec:	48 b8 80 1f 00 00 00 	movabs $0x1f80,%rax
    1df3:	00 00 00 
    1df6:	48 8b 00             	mov    (%rax),%rax
    1df9:	48 ba 70 1f 00 00 00 	movabs $0x1f70,%rdx
    1e00:	00 00 00 
    1e03:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1e06:	48 b8 70 1f 00 00 00 	movabs $0x1f70,%rax
    1e0d:	00 00 00 
    1e10:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e1b:	48 8b 00             	mov    (%rax),%rax
    1e1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e26:	8b 40 08             	mov    0x8(%rax),%eax
    1e29:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1e2c:	72 65                	jb     1e93 <malloc+0xfa>
      if(p->s.size == nunits)
    1e2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e32:	8b 40 08             	mov    0x8(%rax),%eax
    1e35:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e38:	75 10                	jne    1e4a <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1e3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e3e:	48 8b 10             	mov    (%rax),%rdx
    1e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e45:	48 89 10             	mov    %rdx,(%rax)
    1e48:	eb 2e                	jmp    1e78 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1e4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e4e:	8b 40 08             	mov    0x8(%rax),%eax
    1e51:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e54:	89 c2                	mov    %eax,%edx
    1e56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e5a:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e61:	8b 40 08             	mov    0x8(%rax),%eax
    1e64:	89 c0                	mov    %eax,%eax
    1e66:	48 c1 e0 04          	shl    $0x4,%rax
    1e6a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e72:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e75:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1e78:	48 ba 80 1f 00 00 00 	movabs $0x1f80,%rdx
    1e7f:	00 00 00 
    1e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e86:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1e89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e8d:	48 83 c0 10          	add    $0x10,%rax
    1e91:	eb 4e                	jmp    1ee1 <malloc+0x148>
    }
    if(p == freep)
    1e93:	48 b8 80 1f 00 00 00 	movabs $0x1f80,%rax
    1e9a:	00 00 00 
    1e9d:	48 8b 00             	mov    (%rax),%rax
    1ea0:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ea4:	75 23                	jne    1ec9 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1ea6:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ea9:	89 c7                	mov    %eax,%edi
    1eab:	48 b8 1e 1d 00 00 00 	movabs $0x1d1e,%rax
    1eb2:	00 00 00 
    1eb5:	ff d0                	call   *%rax
    1eb7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ebb:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1ec0:	75 07                	jne    1ec9 <malloc+0x130>
        return 0;
    1ec2:	b8 00 00 00 00       	mov    $0x0,%eax
    1ec7:	eb 18                	jmp    1ee1 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ec9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ecd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ed1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ed5:	48 8b 00             	mov    (%rax),%rax
    1ed8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1edc:	e9 41 ff ff ff       	jmp    1e22 <malloc+0x89>
  }
}
    1ee1:	c9                   	leave
    1ee2:	c3                   	ret

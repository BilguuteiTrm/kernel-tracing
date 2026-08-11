
_cat:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 20          	sub    $0x20,%rsp
    1008:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    100b:	eb 57                	jmp    1064 <cat+0x64>
    if (write(1, buf, n) != n) {
    100d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1010:	48 b9 80 1f 00 00 00 	movabs $0x1f80,%rcx
    1017:	00 00 00 
    101a:	89 c2                	mov    %eax,%edx
    101c:	48 89 ce             	mov    %rcx,%rsi
    101f:	bf 01 00 00 00       	mov    $0x1,%edi
    1024:	48 b8 14 15 00 00 00 	movabs $0x1514,%rax
    102b:	00 00 00 
    102e:	ff d0                	call   *%rax
    1030:	39 45 fc             	cmp    %eax,-0x4(%rbp)
    1033:	74 2f                	je     1064 <cat+0x64>
      printf(1, "cat: write error\n");
    1035:	48 b8 10 1f 00 00 00 	movabs $0x1f10,%rax
    103c:	00 00 00 
    103f:	48 89 c6             	mov    %rax,%rsi
    1042:	bf 01 00 00 00       	mov    $0x1,%edi
    1047:	b8 00 00 00 00       	mov    $0x0,%eax
    104c:	48 ba ee 17 00 00 00 	movabs $0x17ee,%rdx
    1053:	00 00 00 
    1056:	ff d2                	call   *%rdx
      exit();
    1058:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    105f:	00 00 00 
    1062:	ff d0                	call   *%rax
  while((n = read(fd, buf, sizeof(buf))) > 0) {
    1064:	48 b9 80 1f 00 00 00 	movabs $0x1f80,%rcx
    106b:	00 00 00 
    106e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1071:	ba 00 02 00 00       	mov    $0x200,%edx
    1076:	48 89 ce             	mov    %rcx,%rsi
    1079:	89 c7                	mov    %eax,%edi
    107b:	48 b8 07 15 00 00 00 	movabs $0x1507,%rax
    1082:	00 00 00 
    1085:	ff d0                	call   *%rax
    1087:	89 45 fc             	mov    %eax,-0x4(%rbp)
    108a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    108e:	0f 8f 79 ff ff ff    	jg     100d <cat+0xd>
    }
  }
  if(n < 0){
    1094:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1098:	79 2f                	jns    10c9 <cat+0xc9>
    printf(1, "cat: read error\n");
    109a:	48 b8 22 1f 00 00 00 	movabs $0x1f22,%rax
    10a1:	00 00 00 
    10a4:	48 89 c6             	mov    %rax,%rsi
    10a7:	bf 01 00 00 00       	mov    $0x1,%edi
    10ac:	b8 00 00 00 00       	mov    $0x0,%eax
    10b1:	48 ba ee 17 00 00 00 	movabs $0x17ee,%rdx
    10b8:	00 00 00 
    10bb:	ff d2                	call   *%rdx
    exit();
    10bd:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    10c4:	00 00 00 
    10c7:	ff d0                	call   *%rax
  }
}
    10c9:	90                   	nop
    10ca:	c9                   	leave
    10cb:	c3                   	ret

00000000000010cc <main>:

int
main(int argc, char *argv[])
{
    10cc:	55                   	push   %rbp
    10cd:	48 89 e5             	mov    %rsp,%rbp
    10d0:	48 83 ec 20          	sub    $0x20,%rsp
    10d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
    10d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd, i;

  if(argc <= 1){
    10db:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    10df:	7f 1d                	jg     10fe <main+0x32>
    cat(0);
    10e1:	bf 00 00 00 00       	mov    $0x0,%edi
    10e6:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    10ed:	00 00 00 
    10f0:	ff d0                	call   *%rax
    exit();
    10f2:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    10f9:	00 00 00 
    10fc:	ff d0                	call   *%rax
  }

  for(i = 1; i < argc; i++){
    10fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    1105:	e9 a3 00 00 00       	jmp    11ad <main+0xe1>
    if((fd = open(argv[i], 0)) < 0){
    110a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    110d:	48 98                	cltq
    110f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1116:	00 
    1117:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    111b:	48 01 d0             	add    %rdx,%rax
    111e:	48 8b 00             	mov    (%rax),%rax
    1121:	be 00 00 00 00       	mov    $0x0,%esi
    1126:	48 89 c7             	mov    %rax,%rdi
    1129:	48 b8 48 15 00 00 00 	movabs $0x1548,%rax
    1130:	00 00 00 
    1133:	ff d0                	call   *%rax
    1135:	89 45 f8             	mov    %eax,-0x8(%rbp)
    1138:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    113c:	79 49                	jns    1187 <main+0xbb>
      printf(1, "cat: cannot open %s\n", argv[i]);
    113e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1141:	48 98                	cltq
    1143:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    114a:	00 
    114b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    114f:	48 01 d0             	add    %rdx,%rax
    1152:	48 8b 00             	mov    (%rax),%rax
    1155:	48 b9 33 1f 00 00 00 	movabs $0x1f33,%rcx
    115c:	00 00 00 
    115f:	48 89 c2             	mov    %rax,%rdx
    1162:	48 89 ce             	mov    %rcx,%rsi
    1165:	bf 01 00 00 00       	mov    $0x1,%edi
    116a:	b8 00 00 00 00       	mov    $0x0,%eax
    116f:	48 b9 ee 17 00 00 00 	movabs $0x17ee,%rcx
    1176:	00 00 00 
    1179:	ff d1                	call   *%rcx
      exit();
    117b:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    1182:	00 00 00 
    1185:	ff d0                	call   *%rax
    }
    cat(fd);
    1187:	8b 45 f8             	mov    -0x8(%rbp),%eax
    118a:	89 c7                	mov    %eax,%edi
    118c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1193:	00 00 00 
    1196:	ff d0                	call   *%rax
    close(fd);
    1198:	8b 45 f8             	mov    -0x8(%rbp),%eax
    119b:	89 c7                	mov    %eax,%edi
    119d:	48 b8 21 15 00 00 00 	movabs $0x1521,%rax
    11a4:	00 00 00 
    11a7:	ff d0                	call   *%rax
  for(i = 1; i < argc; i++){
    11a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11b0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    11b3:	0f 8c 51 ff ff ff    	jl     110a <main+0x3e>
  }
  exit();
    11b9:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    11c0:	00 00 00 
    11c3:	ff d0                	call   *%rax

00000000000011c5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11c5:	55                   	push   %rbp
    11c6:	48 89 e5             	mov    %rsp,%rbp
    11c9:	48 83 ec 10          	sub    $0x10,%rsp
    11cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11d1:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11d4:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    11d7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    11db:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11de:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11e1:	48 89 ce             	mov    %rcx,%rsi
    11e4:	48 89 f7             	mov    %rsi,%rdi
    11e7:	89 d1                	mov    %edx,%ecx
    11e9:	fc                   	cld
    11ea:	f3 aa                	rep stos %al,(%rdi)
    11ec:	89 ca                	mov    %ecx,%edx
    11ee:	48 89 fe             	mov    %rdi,%rsi
    11f1:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11f5:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11f8:	90                   	nop
    11f9:	c9                   	leave
    11fa:	c3                   	ret

00000000000011fb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11fb:	55                   	push   %rbp
    11fc:	48 89 e5             	mov    %rsp,%rbp
    11ff:	48 83 ec 20          	sub    $0x20,%rsp
    1203:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1207:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    120b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    120f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1213:	90                   	nop
    1214:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1218:	48 8d 42 01          	lea    0x1(%rdx),%rax
    121c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1224:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1228:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    122c:	0f b6 12             	movzbl (%rdx),%edx
    122f:	88 10                	mov    %dl,(%rax)
    1231:	0f b6 00             	movzbl (%rax),%eax
    1234:	84 c0                	test   %al,%al
    1236:	75 dc                	jne    1214 <strcpy+0x19>
    ;
  return os;
    1238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    123c:	c9                   	leave
    123d:	c3                   	ret

000000000000123e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    123e:	55                   	push   %rbp
    123f:	48 89 e5             	mov    %rsp,%rbp
    1242:	48 83 ec 10          	sub    $0x10,%rsp
    1246:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    124a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    124e:	eb 0a                	jmp    125a <strcmp+0x1c>
    p++, q++;
    1250:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1255:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    125a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    125e:	0f b6 00             	movzbl (%rax),%eax
    1261:	84 c0                	test   %al,%al
    1263:	74 12                	je     1277 <strcmp+0x39>
    1265:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1269:	0f b6 10             	movzbl (%rax),%edx
    126c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1270:	0f b6 00             	movzbl (%rax),%eax
    1273:	38 c2                	cmp    %al,%dl
    1275:	74 d9                	je     1250 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    127b:	0f b6 00             	movzbl (%rax),%eax
    127e:	0f b6 d0             	movzbl %al,%edx
    1281:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1285:	0f b6 00             	movzbl (%rax),%eax
    1288:	0f b6 c0             	movzbl %al,%eax
    128b:	29 c2                	sub    %eax,%edx
    128d:	89 d0                	mov    %edx,%eax
}
    128f:	c9                   	leave
    1290:	c3                   	ret

0000000000001291 <strlen>:

uint
strlen(char *s)
{
    1291:	55                   	push   %rbp
    1292:	48 89 e5             	mov    %rsp,%rbp
    1295:	48 83 ec 18          	sub    $0x18,%rsp
    1299:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    129d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12a4:	eb 04                	jmp    12aa <strlen+0x19>
    12a6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    12aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12ad:	48 63 d0             	movslq %eax,%rdx
    12b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12b4:	48 01 d0             	add    %rdx,%rax
    12b7:	0f b6 00             	movzbl (%rax),%eax
    12ba:	84 c0                	test   %al,%al
    12bc:	75 e8                	jne    12a6 <strlen+0x15>
    ;
  return n;
    12be:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    12c1:	c9                   	leave
    12c2:	c3                   	ret

00000000000012c3 <memset>:

void*
memset(void *dst, int c, uint n)
{
    12c3:	55                   	push   %rbp
    12c4:	48 89 e5             	mov    %rsp,%rbp
    12c7:	48 83 ec 10          	sub    $0x10,%rsp
    12cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12cf:	89 75 f4             	mov    %esi,-0xc(%rbp)
    12d2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    12d5:	8b 55 f0             	mov    -0x10(%rbp),%edx
    12d8:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    12db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12df:	89 ce                	mov    %ecx,%esi
    12e1:	48 89 c7             	mov    %rax,%rdi
    12e4:	48 b8 c5 11 00 00 00 	movabs $0x11c5,%rax
    12eb:	00 00 00 
    12ee:	ff d0                	call   *%rax
  return dst;
    12f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12f4:	c9                   	leave
    12f5:	c3                   	ret

00000000000012f6 <strchr>:

char*
strchr(const char *s, char c)
{
    12f6:	55                   	push   %rbp
    12f7:	48 89 e5             	mov    %rsp,%rbp
    12fa:	48 83 ec 10          	sub    $0x10,%rsp
    12fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1302:	89 f0                	mov    %esi,%eax
    1304:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1307:	eb 17                	jmp    1320 <strchr+0x2a>
    if(*s == c)
    1309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    130d:	0f b6 00             	movzbl (%rax),%eax
    1310:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1313:	75 06                	jne    131b <strchr+0x25>
      return (char*)s;
    1315:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1319:	eb 15                	jmp    1330 <strchr+0x3a>
  for(; *s; s++)
    131b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1324:	0f b6 00             	movzbl (%rax),%eax
    1327:	84 c0                	test   %al,%al
    1329:	75 de                	jne    1309 <strchr+0x13>
  return 0;
    132b:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1330:	c9                   	leave
    1331:	c3                   	ret

0000000000001332 <gets>:

char*
gets(char *buf, int max)
{
    1332:	55                   	push   %rbp
    1333:	48 89 e5             	mov    %rsp,%rbp
    1336:	48 83 ec 20          	sub    $0x20,%rsp
    133a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    133e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1341:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1348:	eb 4f                	jmp    1399 <gets+0x67>
    cc = read(0, &c, 1);
    134a:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    134e:	ba 01 00 00 00       	mov    $0x1,%edx
    1353:	48 89 c6             	mov    %rax,%rsi
    1356:	bf 00 00 00 00       	mov    $0x0,%edi
    135b:	48 b8 07 15 00 00 00 	movabs $0x1507,%rax
    1362:	00 00 00 
    1365:	ff d0                	call   *%rax
    1367:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    136a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    136e:	7e 36                	jle    13a6 <gets+0x74>
      break;
    buf[i++] = c;
    1370:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1373:	8d 50 01             	lea    0x1(%rax),%edx
    1376:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1379:	48 63 d0             	movslq %eax,%rdx
    137c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1380:	48 01 c2             	add    %rax,%rdx
    1383:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1387:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1389:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    138d:	3c 0a                	cmp    $0xa,%al
    138f:	74 16                	je     13a7 <gets+0x75>
    1391:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1395:	3c 0d                	cmp    $0xd,%al
    1397:	74 0e                	je     13a7 <gets+0x75>
  for(i=0; i+1 < max; ){
    1399:	8b 45 fc             	mov    -0x4(%rbp),%eax
    139c:	83 c0 01             	add    $0x1,%eax
    139f:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    13a2:	7f a6                	jg     134a <gets+0x18>
    13a4:	eb 01                	jmp    13a7 <gets+0x75>
      break;
    13a6:	90                   	nop
      break;
  }
  buf[i] = '\0';
    13a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13aa:	48 63 d0             	movslq %eax,%rdx
    13ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13b1:	48 01 d0             	add    %rdx,%rax
    13b4:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    13b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13bb:	c9                   	leave
    13bc:	c3                   	ret

00000000000013bd <stat>:

int
stat(char *n, struct stat *st)
{
    13bd:	55                   	push   %rbp
    13be:	48 89 e5             	mov    %rsp,%rbp
    13c1:	48 83 ec 20          	sub    $0x20,%rsp
    13c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13d1:	be 00 00 00 00       	mov    $0x0,%esi
    13d6:	48 89 c7             	mov    %rax,%rdi
    13d9:	48 b8 48 15 00 00 00 	movabs $0x1548,%rax
    13e0:	00 00 00 
    13e3:	ff d0                	call   *%rax
    13e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    13e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    13ec:	79 07                	jns    13f5 <stat+0x38>
    return -1;
    13ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13f3:	eb 2f                	jmp    1424 <stat+0x67>
  r = fstat(fd, st);
    13f5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    13f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13fc:	48 89 d6             	mov    %rdx,%rsi
    13ff:	89 c7                	mov    %eax,%edi
    1401:	48 b8 6f 15 00 00 00 	movabs $0x156f,%rax
    1408:	00 00 00 
    140b:	ff d0                	call   *%rax
    140d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1410:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1413:	89 c7                	mov    %eax,%edi
    1415:	48 b8 21 15 00 00 00 	movabs $0x1521,%rax
    141c:	00 00 00 
    141f:	ff d0                	call   *%rax
  return r;
    1421:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1424:	c9                   	leave
    1425:	c3                   	ret

0000000000001426 <atoi>:

int
atoi(const char *s)
{
    1426:	55                   	push   %rbp
    1427:	48 89 e5             	mov    %rsp,%rbp
    142a:	48 83 ec 18          	sub    $0x18,%rsp
    142e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1432:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1439:	eb 28                	jmp    1463 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    143b:	8b 55 fc             	mov    -0x4(%rbp),%edx
    143e:	89 d0                	mov    %edx,%eax
    1440:	c1 e0 02             	shl    $0x2,%eax
    1443:	01 d0                	add    %edx,%eax
    1445:	01 c0                	add    %eax,%eax
    1447:	89 c1                	mov    %eax,%ecx
    1449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    144d:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1451:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1455:	0f b6 00             	movzbl (%rax),%eax
    1458:	0f be c0             	movsbl %al,%eax
    145b:	01 c8                	add    %ecx,%eax
    145d:	83 e8 30             	sub    $0x30,%eax
    1460:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1463:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1467:	0f b6 00             	movzbl (%rax),%eax
    146a:	3c 2f                	cmp    $0x2f,%al
    146c:	7e 0b                	jle    1479 <atoi+0x53>
    146e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1472:	0f b6 00             	movzbl (%rax),%eax
    1475:	3c 39                	cmp    $0x39,%al
    1477:	7e c2                	jle    143b <atoi+0x15>
  return n;
    1479:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    147c:	c9                   	leave
    147d:	c3                   	ret

000000000000147e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    147e:	55                   	push   %rbp
    147f:	48 89 e5             	mov    %rsp,%rbp
    1482:	48 83 ec 28          	sub    $0x28,%rsp
    1486:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    148a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    148e:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1491:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1495:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1499:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    149d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    14a1:	eb 1d                	jmp    14c0 <memmove+0x42>
    *dst++ = *src++;
    14a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    14a7:	48 8d 42 01          	lea    0x1(%rdx),%rax
    14ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    14af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    14b3:	48 8d 48 01          	lea    0x1(%rax),%rcx
    14b7:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    14bb:	0f b6 12             	movzbl (%rdx),%edx
    14be:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    14c0:	8b 45 dc             	mov    -0x24(%rbp),%eax
    14c3:	8d 50 ff             	lea    -0x1(%rax),%edx
    14c6:	89 55 dc             	mov    %edx,-0x24(%rbp)
    14c9:	85 c0                	test   %eax,%eax
    14cb:	7f d6                	jg     14a3 <memmove+0x25>
  return vdst;
    14cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14d1:	c9                   	leave
    14d2:	c3                   	ret

00000000000014d3 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14d3:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14da:	49 89 ca             	mov    %rcx,%r10
    14dd:	0f 05                	syscall
    14df:	c3                   	ret

00000000000014e0 <exit>:
SYSCALL(exit)
    14e0:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    14e7:	49 89 ca             	mov    %rcx,%r10
    14ea:	0f 05                	syscall
    14ec:	c3                   	ret

00000000000014ed <wait>:
SYSCALL(wait)
    14ed:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    14f4:	49 89 ca             	mov    %rcx,%r10
    14f7:	0f 05                	syscall
    14f9:	c3                   	ret

00000000000014fa <pipe>:
SYSCALL(pipe)
    14fa:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1501:	49 89 ca             	mov    %rcx,%r10
    1504:	0f 05                	syscall
    1506:	c3                   	ret

0000000000001507 <read>:
SYSCALL(read)
    1507:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    150e:	49 89 ca             	mov    %rcx,%r10
    1511:	0f 05                	syscall
    1513:	c3                   	ret

0000000000001514 <write>:
SYSCALL(write)
    1514:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    151b:	49 89 ca             	mov    %rcx,%r10
    151e:	0f 05                	syscall
    1520:	c3                   	ret

0000000000001521 <close>:
SYSCALL(close)
    1521:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1528:	49 89 ca             	mov    %rcx,%r10
    152b:	0f 05                	syscall
    152d:	c3                   	ret

000000000000152e <kill>:
SYSCALL(kill)
    152e:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1535:	49 89 ca             	mov    %rcx,%r10
    1538:	0f 05                	syscall
    153a:	c3                   	ret

000000000000153b <exec>:
SYSCALL(exec)
    153b:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1542:	49 89 ca             	mov    %rcx,%r10
    1545:	0f 05                	syscall
    1547:	c3                   	ret

0000000000001548 <open>:
SYSCALL(open)
    1548:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    154f:	49 89 ca             	mov    %rcx,%r10
    1552:	0f 05                	syscall
    1554:	c3                   	ret

0000000000001555 <mknod>:
SYSCALL(mknod)
    1555:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    155c:	49 89 ca             	mov    %rcx,%r10
    155f:	0f 05                	syscall
    1561:	c3                   	ret

0000000000001562 <unlink>:
SYSCALL(unlink)
    1562:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1569:	49 89 ca             	mov    %rcx,%r10
    156c:	0f 05                	syscall
    156e:	c3                   	ret

000000000000156f <fstat>:
SYSCALL(fstat)
    156f:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1576:	49 89 ca             	mov    %rcx,%r10
    1579:	0f 05                	syscall
    157b:	c3                   	ret

000000000000157c <link>:
SYSCALL(link)
    157c:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1583:	49 89 ca             	mov    %rcx,%r10
    1586:	0f 05                	syscall
    1588:	c3                   	ret

0000000000001589 <mkdir>:
SYSCALL(mkdir)
    1589:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1590:	49 89 ca             	mov    %rcx,%r10
    1593:	0f 05                	syscall
    1595:	c3                   	ret

0000000000001596 <chdir>:
SYSCALL(chdir)
    1596:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    159d:	49 89 ca             	mov    %rcx,%r10
    15a0:	0f 05                	syscall
    15a2:	c3                   	ret

00000000000015a3 <dup>:
SYSCALL(dup)
    15a3:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    15aa:	49 89 ca             	mov    %rcx,%r10
    15ad:	0f 05                	syscall
    15af:	c3                   	ret

00000000000015b0 <getpid>:
SYSCALL(getpid)
    15b0:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    15b7:	49 89 ca             	mov    %rcx,%r10
    15ba:	0f 05                	syscall
    15bc:	c3                   	ret

00000000000015bd <sbrk>:
SYSCALL(sbrk)
    15bd:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    15c4:	49 89 ca             	mov    %rcx,%r10
    15c7:	0f 05                	syscall
    15c9:	c3                   	ret

00000000000015ca <sleep>:
SYSCALL(sleep)
    15ca:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15d1:	49 89 ca             	mov    %rcx,%r10
    15d4:	0f 05                	syscall
    15d6:	c3                   	ret

00000000000015d7 <uptime>:
SYSCALL(uptime)
    15d7:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    15de:	49 89 ca             	mov    %rcx,%r10
    15e1:	0f 05                	syscall
    15e3:	c3                   	ret

00000000000015e4 <traceread>:
SYSCALL(traceread)
    15e4:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    15eb:	49 89 ca             	mov    %rcx,%r10
    15ee:	0f 05                	syscall
    15f0:	c3                   	ret

00000000000015f1 <vidclear>:
SYSCALL(vidclear)
    15f1:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    15f8:	49 89 ca             	mov    %rcx,%r10
    15fb:	0f 05                	syscall
    15fd:	c3                   	ret

00000000000015fe <vidputc>:
SYSCALL(vidputc)
    15fe:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    1605:	49 89 ca             	mov    %rcx,%r10
    1608:	0f 05                	syscall
    160a:	c3                   	ret

000000000000160b <vidputs>:
SYSCALL(vidputs)
    160b:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    1612:	49 89 ca             	mov    %rcx,%r10
    1615:	0f 05                	syscall
    1617:	c3                   	ret

0000000000001618 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1618:	55                   	push   %rbp
    1619:	48 89 e5             	mov    %rsp,%rbp
    161c:	48 83 ec 10          	sub    $0x10,%rsp
    1620:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1623:	89 f0                	mov    %esi,%eax
    1625:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1628:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    162c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    162f:	ba 01 00 00 00       	mov    $0x1,%edx
    1634:	48 89 ce             	mov    %rcx,%rsi
    1637:	89 c7                	mov    %eax,%edi
    1639:	48 b8 14 15 00 00 00 	movabs $0x1514,%rax
    1640:	00 00 00 
    1643:	ff d0                	call   *%rax
}
    1645:	90                   	nop
    1646:	c9                   	leave
    1647:	c3                   	ret

0000000000001648 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1648:	55                   	push   %rbp
    1649:	48 89 e5             	mov    %rsp,%rbp
    164c:	48 83 ec 20          	sub    $0x20,%rsp
    1650:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1653:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1657:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    165e:	eb 35                	jmp    1695 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1660:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1664:	48 c1 e8 3c          	shr    $0x3c,%rax
    1668:	48 ba 50 1f 00 00 00 	movabs $0x1f50,%rdx
    166f:	00 00 00 
    1672:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1676:	0f be d0             	movsbl %al,%edx
    1679:	8b 45 ec             	mov    -0x14(%rbp),%eax
    167c:	89 d6                	mov    %edx,%esi
    167e:	89 c7                	mov    %eax,%edi
    1680:	48 b8 18 16 00 00 00 	movabs $0x1618,%rax
    1687:	00 00 00 
    168a:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    168c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1690:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1695:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1698:	83 f8 0f             	cmp    $0xf,%eax
    169b:	76 c3                	jbe    1660 <print_x64+0x18>
}
    169d:	90                   	nop
    169e:	90                   	nop
    169f:	c9                   	leave
    16a0:	c3                   	ret

00000000000016a1 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    16a1:	55                   	push   %rbp
    16a2:	48 89 e5             	mov    %rsp,%rbp
    16a5:	48 83 ec 20          	sub    $0x20,%rsp
    16a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
    16ac:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    16b6:	eb 36                	jmp    16ee <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    16b8:	8b 45 e8             	mov    -0x18(%rbp),%eax
    16bb:	c1 e8 1c             	shr    $0x1c,%eax
    16be:	89 c2                	mov    %eax,%edx
    16c0:	48 b8 50 1f 00 00 00 	movabs $0x1f50,%rax
    16c7:	00 00 00 
    16ca:	89 d2                	mov    %edx,%edx
    16cc:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    16d0:	0f be d0             	movsbl %al,%edx
    16d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16d6:	89 d6                	mov    %edx,%esi
    16d8:	89 c7                	mov    %eax,%edi
    16da:	48 b8 18 16 00 00 00 	movabs $0x1618,%rax
    16e1:	00 00 00 
    16e4:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16e6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16ea:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    16ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16f1:	83 f8 07             	cmp    $0x7,%eax
    16f4:	76 c2                	jbe    16b8 <print_x32+0x17>
}
    16f6:	90                   	nop
    16f7:	90                   	nop
    16f8:	c9                   	leave
    16f9:	c3                   	ret

00000000000016fa <print_d>:

  static void
print_d(int fd, int v)
{
    16fa:	55                   	push   %rbp
    16fb:	48 89 e5             	mov    %rsp,%rbp
    16fe:	48 83 ec 30          	sub    $0x30,%rsp
    1702:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1705:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1708:	8b 45 d8             	mov    -0x28(%rbp),%eax
    170b:	48 98                	cltq
    170d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1711:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1715:	79 04                	jns    171b <print_d+0x21>
    x = -x;
    1717:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    171b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1722:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1726:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    172d:	66 66 66 
    1730:	48 89 c8             	mov    %rcx,%rax
    1733:	48 f7 ea             	imul   %rdx
    1736:	48 c1 fa 02          	sar    $0x2,%rdx
    173a:	48 89 c8             	mov    %rcx,%rax
    173d:	48 c1 f8 3f          	sar    $0x3f,%rax
    1741:	48 29 c2             	sub    %rax,%rdx
    1744:	48 89 d0             	mov    %rdx,%rax
    1747:	48 c1 e0 02          	shl    $0x2,%rax
    174b:	48 01 d0             	add    %rdx,%rax
    174e:	48 01 c0             	add    %rax,%rax
    1751:	48 29 c1             	sub    %rax,%rcx
    1754:	48 89 ca             	mov    %rcx,%rdx
    1757:	8b 45 f4             	mov    -0xc(%rbp),%eax
    175a:	8d 48 01             	lea    0x1(%rax),%ecx
    175d:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1760:	48 b9 50 1f 00 00 00 	movabs $0x1f50,%rcx
    1767:	00 00 00 
    176a:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    176e:	48 98                	cltq
    1770:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1774:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1778:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    177f:	66 66 66 
    1782:	48 89 c8             	mov    %rcx,%rax
    1785:	48 f7 ea             	imul   %rdx
    1788:	48 89 d0             	mov    %rdx,%rax
    178b:	48 c1 f8 02          	sar    $0x2,%rax
    178f:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1793:	48 89 ca             	mov    %rcx,%rdx
    1796:	48 29 d0             	sub    %rdx,%rax
    1799:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    179d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    17a2:	0f 85 7a ff ff ff    	jne    1722 <print_d+0x28>

  if (v < 0)
    17a8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17ac:	79 32                	jns    17e0 <print_d+0xe6>
    buf[i++] = '-';
    17ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17b1:	8d 50 01             	lea    0x1(%rax),%edx
    17b4:	89 55 f4             	mov    %edx,-0xc(%rbp)
    17b7:	48 98                	cltq
    17b9:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    17be:	eb 20                	jmp    17e0 <print_d+0xe6>
    putc(fd, buf[i]);
    17c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17c3:	48 98                	cltq
    17c5:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    17ca:	0f be d0             	movsbl %al,%edx
    17cd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17d0:	89 d6                	mov    %edx,%esi
    17d2:	89 c7                	mov    %eax,%edi
    17d4:	48 b8 18 16 00 00 00 	movabs $0x1618,%rax
    17db:	00 00 00 
    17de:	ff d0                	call   *%rax
  while (--i >= 0)
    17e0:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    17e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    17e8:	79 d6                	jns    17c0 <print_d+0xc6>
}
    17ea:	90                   	nop
    17eb:	90                   	nop
    17ec:	c9                   	leave
    17ed:	c3                   	ret

00000000000017ee <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    17ee:	55                   	push   %rbp
    17ef:	48 89 e5             	mov    %rsp,%rbp
    17f2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    17f9:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    17ff:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1806:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    180d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1814:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    181b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1822:	84 c0                	test   %al,%al
    1824:	74 20                	je     1846 <printf+0x58>
    1826:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    182a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    182e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1832:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1836:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    183a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    183e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1842:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1846:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    184d:	00 00 00 
    1850:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1857:	00 00 00 
    185a:	48 8d 45 10          	lea    0x10(%rbp),%rax
    185e:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1865:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    186c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1873:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    187a:	00 00 00 
    187d:	e9 60 03 00 00       	jmp    1be2 <printf+0x3f4>
    if (c != '%') {
    1882:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1889:	74 24                	je     18af <printf+0xc1>
      putc(fd, c);
    188b:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1891:	0f be d0             	movsbl %al,%edx
    1894:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    189a:	89 d6                	mov    %edx,%esi
    189c:	89 c7                	mov    %eax,%edi
    189e:	48 b8 18 16 00 00 00 	movabs $0x1618,%rax
    18a5:	00 00 00 
    18a8:	ff d0                	call   *%rax
      continue;
    18aa:	e9 2c 03 00 00       	jmp    1bdb <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    18af:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    18b6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    18bc:	48 63 d0             	movslq %eax,%rdx
    18bf:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    18c6:	48 01 d0             	add    %rdx,%rax
    18c9:	0f b6 00             	movzbl (%rax),%eax
    18cc:	0f be c0             	movsbl %al,%eax
    18cf:	25 ff 00 00 00       	and    $0xff,%eax
    18d4:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    18da:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    18e1:	0f 84 2e 03 00 00    	je     1c15 <printf+0x427>
      break;
    switch(c) {
    18e7:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    18ee:	0f 84 32 01 00 00    	je     1a26 <printf+0x238>
    18f4:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    18fb:	0f 8f a1 02 00 00    	jg     1ba2 <printf+0x3b4>
    1901:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1908:	0f 84 d4 01 00 00    	je     1ae2 <printf+0x2f4>
    190e:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1915:	0f 8f 87 02 00 00    	jg     1ba2 <printf+0x3b4>
    191b:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1922:	0f 84 5b 01 00 00    	je     1a83 <printf+0x295>
    1928:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    192f:	0f 8f 6d 02 00 00    	jg     1ba2 <printf+0x3b4>
    1935:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    193c:	0f 84 87 00 00 00    	je     19c9 <printf+0x1db>
    1942:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1949:	0f 8f 53 02 00 00    	jg     1ba2 <printf+0x3b4>
    194f:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1956:	0f 84 2b 02 00 00    	je     1b87 <printf+0x399>
    195c:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1963:	0f 85 39 02 00 00    	jne    1ba2 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    1969:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    196f:	83 f8 2f             	cmp    $0x2f,%eax
    1972:	77 23                	ja     1997 <printf+0x1a9>
    1974:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    197b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1981:	89 d2                	mov    %edx,%edx
    1983:	48 01 d0             	add    %rdx,%rax
    1986:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    198c:	83 c2 08             	add    $0x8,%edx
    198f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1995:	eb 12                	jmp    19a9 <printf+0x1bb>
    1997:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    199e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19a2:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19a9:	8b 00                	mov    (%rax),%eax
    19ab:	0f be d0             	movsbl %al,%edx
    19ae:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19b4:	89 d6                	mov    %edx,%esi
    19b6:	89 c7                	mov    %eax,%edi
    19b8:	48 b8 18 16 00 00 00 	movabs $0x1618,%rax
    19bf:	00 00 00 
    19c2:	ff d0                	call   *%rax
      break;
    19c4:	e9 12 02 00 00       	jmp    1bdb <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    19c9:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19cf:	83 f8 2f             	cmp    $0x2f,%eax
    19d2:	77 23                	ja     19f7 <printf+0x209>
    19d4:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19db:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19e1:	89 d2                	mov    %edx,%edx
    19e3:	48 01 d0             	add    %rdx,%rax
    19e6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19ec:	83 c2 08             	add    $0x8,%edx
    19ef:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19f5:	eb 12                	jmp    1a09 <printf+0x21b>
    19f7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19fe:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a02:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a09:	8b 10                	mov    (%rax),%edx
    1a0b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a11:	89 d6                	mov    %edx,%esi
    1a13:	89 c7                	mov    %eax,%edi
    1a15:	48 b8 fa 16 00 00 00 	movabs $0x16fa,%rax
    1a1c:	00 00 00 
    1a1f:	ff d0                	call   *%rax
      break;
    1a21:	e9 b5 01 00 00       	jmp    1bdb <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1a26:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a2c:	83 f8 2f             	cmp    $0x2f,%eax
    1a2f:	77 23                	ja     1a54 <printf+0x266>
    1a31:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a38:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a3e:	89 d2                	mov    %edx,%edx
    1a40:	48 01 d0             	add    %rdx,%rax
    1a43:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a49:	83 c2 08             	add    $0x8,%edx
    1a4c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a52:	eb 12                	jmp    1a66 <printf+0x278>
    1a54:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a5b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a5f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a66:	8b 10                	mov    (%rax),%edx
    1a68:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a6e:	89 d6                	mov    %edx,%esi
    1a70:	89 c7                	mov    %eax,%edi
    1a72:	48 b8 a1 16 00 00 00 	movabs $0x16a1,%rax
    1a79:	00 00 00 
    1a7c:	ff d0                	call   *%rax
      break;
    1a7e:	e9 58 01 00 00       	jmp    1bdb <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a83:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a89:	83 f8 2f             	cmp    $0x2f,%eax
    1a8c:	77 23                	ja     1ab1 <printf+0x2c3>
    1a8e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a95:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a9b:	89 d2                	mov    %edx,%edx
    1a9d:	48 01 d0             	add    %rdx,%rax
    1aa0:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1aa6:	83 c2 08             	add    $0x8,%edx
    1aa9:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1aaf:	eb 12                	jmp    1ac3 <printf+0x2d5>
    1ab1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ab8:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1abc:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ac3:	48 8b 10             	mov    (%rax),%rdx
    1ac6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1acc:	48 89 d6             	mov    %rdx,%rsi
    1acf:	89 c7                	mov    %eax,%edi
    1ad1:	48 b8 48 16 00 00 00 	movabs $0x1648,%rax
    1ad8:	00 00 00 
    1adb:	ff d0                	call   *%rax
      break;
    1add:	e9 f9 00 00 00       	jmp    1bdb <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1ae2:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ae8:	83 f8 2f             	cmp    $0x2f,%eax
    1aeb:	77 23                	ja     1b10 <printf+0x322>
    1aed:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1af4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1afa:	89 d2                	mov    %edx,%edx
    1afc:	48 01 d0             	add    %rdx,%rax
    1aff:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b05:	83 c2 08             	add    $0x8,%edx
    1b08:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b0e:	eb 12                	jmp    1b22 <printf+0x334>
    1b10:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b17:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b1b:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b22:	48 8b 00             	mov    (%rax),%rax
    1b25:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1b2c:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1b33:	00 
    1b34:	75 41                	jne    1b77 <printf+0x389>
        s = "(null)";
    1b36:	48 b8 48 1f 00 00 00 	movabs $0x1f48,%rax
    1b3d:	00 00 00 
    1b40:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1b47:	eb 2e                	jmp    1b77 <printf+0x389>
        putc(fd, *(s++));
    1b49:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b50:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1b54:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1b5b:	0f b6 00             	movzbl (%rax),%eax
    1b5e:	0f be d0             	movsbl %al,%edx
    1b61:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b67:	89 d6                	mov    %edx,%esi
    1b69:	89 c7                	mov    %eax,%edi
    1b6b:	48 b8 18 16 00 00 00 	movabs $0x1618,%rax
    1b72:	00 00 00 
    1b75:	ff d0                	call   *%rax
      while (*s)
    1b77:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b7e:	0f b6 00             	movzbl (%rax),%eax
    1b81:	84 c0                	test   %al,%al
    1b83:	75 c4                	jne    1b49 <printf+0x35b>
      break;
    1b85:	eb 54                	jmp    1bdb <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1b87:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b8d:	be 25 00 00 00       	mov    $0x25,%esi
    1b92:	89 c7                	mov    %eax,%edi
    1b94:	48 b8 18 16 00 00 00 	movabs $0x1618,%rax
    1b9b:	00 00 00 
    1b9e:	ff d0                	call   *%rax
      break;
    1ba0:	eb 39                	jmp    1bdb <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1ba2:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ba8:	be 25 00 00 00       	mov    $0x25,%esi
    1bad:	89 c7                	mov    %eax,%edi
    1baf:	48 b8 18 16 00 00 00 	movabs $0x1618,%rax
    1bb6:	00 00 00 
    1bb9:	ff d0                	call   *%rax
      putc(fd, c);
    1bbb:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1bc1:	0f be d0             	movsbl %al,%edx
    1bc4:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1bca:	89 d6                	mov    %edx,%esi
    1bcc:	89 c7                	mov    %eax,%edi
    1bce:	48 b8 18 16 00 00 00 	movabs $0x1618,%rax
    1bd5:	00 00 00 
    1bd8:	ff d0                	call   *%rax
      break;
    1bda:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1bdb:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1be2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1be8:	48 63 d0             	movslq %eax,%rdx
    1beb:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bf2:	48 01 d0             	add    %rdx,%rax
    1bf5:	0f b6 00             	movzbl (%rax),%eax
    1bf8:	0f be c0             	movsbl %al,%eax
    1bfb:	25 ff 00 00 00       	and    $0xff,%eax
    1c00:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1c06:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1c0d:	0f 85 6f fc ff ff    	jne    1882 <printf+0x94>
    }
  }
}
    1c13:	eb 01                	jmp    1c16 <printf+0x428>
      break;
    1c15:	90                   	nop
}
    1c16:	90                   	nop
    1c17:	c9                   	leave
    1c18:	c3                   	ret

0000000000001c19 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1c19:	55                   	push   %rbp
    1c1a:	48 89 e5             	mov    %rsp,%rbp
    1c1d:	48 83 ec 18          	sub    $0x18,%rsp
    1c21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1c25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c29:	48 83 e8 10          	sub    $0x10,%rax
    1c2d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c31:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    1c38:	00 00 00 
    1c3b:	48 8b 00             	mov    (%rax),%rax
    1c3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c42:	eb 2f                	jmp    1c73 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1c44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c48:	48 8b 00             	mov    (%rax),%rax
    1c4b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c4f:	72 17                	jb     1c68 <free+0x4f>
    1c51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c55:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c59:	72 2f                	jb     1c8a <free+0x71>
    1c5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c5f:	48 8b 00             	mov    (%rax),%rax
    1c62:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c66:	72 22                	jb     1c8a <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c6c:	48 8b 00             	mov    (%rax),%rax
    1c6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c77:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c7b:	73 c7                	jae    1c44 <free+0x2b>
    1c7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c81:	48 8b 00             	mov    (%rax),%rax
    1c84:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c88:	73 ba                	jae    1c44 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c8e:	8b 40 08             	mov    0x8(%rax),%eax
    1c91:	89 c0                	mov    %eax,%eax
    1c93:	48 c1 e0 04          	shl    $0x4,%rax
    1c97:	48 89 c2             	mov    %rax,%rdx
    1c9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c9e:	48 01 c2             	add    %rax,%rdx
    1ca1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ca5:	48 8b 00             	mov    (%rax),%rax
    1ca8:	48 39 c2             	cmp    %rax,%rdx
    1cab:	75 2d                	jne    1cda <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1cad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cb1:	8b 50 08             	mov    0x8(%rax),%edx
    1cb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb8:	48 8b 00             	mov    (%rax),%rax
    1cbb:	8b 40 08             	mov    0x8(%rax),%eax
    1cbe:	01 c2                	add    %eax,%edx
    1cc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc4:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1cc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ccb:	48 8b 00             	mov    (%rax),%rax
    1cce:	48 8b 10             	mov    (%rax),%rdx
    1cd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cd5:	48 89 10             	mov    %rdx,(%rax)
    1cd8:	eb 0e                	jmp    1ce8 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1cda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cde:	48 8b 10             	mov    (%rax),%rdx
    1ce1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ce5:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1ce8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cec:	8b 40 08             	mov    0x8(%rax),%eax
    1cef:	89 c0                	mov    %eax,%eax
    1cf1:	48 c1 e0 04          	shl    $0x4,%rax
    1cf5:	48 89 c2             	mov    %rax,%rdx
    1cf8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cfc:	48 01 d0             	add    %rdx,%rax
    1cff:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d03:	75 27                	jne    1d2c <free+0x113>
    p->s.size += bp->s.size;
    1d05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d09:	8b 50 08             	mov    0x8(%rax),%edx
    1d0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d10:	8b 40 08             	mov    0x8(%rax),%eax
    1d13:	01 c2                	add    %eax,%edx
    1d15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d19:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1d1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d20:	48 8b 10             	mov    (%rax),%rdx
    1d23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d27:	48 89 10             	mov    %rdx,(%rax)
    1d2a:	eb 0b                	jmp    1d37 <free+0x11e>
  } else
    p->s.ptr = bp;
    1d2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1d34:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1d37:	48 ba 90 21 00 00 00 	movabs $0x2190,%rdx
    1d3e:	00 00 00 
    1d41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d45:	48 89 02             	mov    %rax,(%rdx)
}
    1d48:	90                   	nop
    1d49:	c9                   	leave
    1d4a:	c3                   	ret

0000000000001d4b <morecore>:

static Header*
morecore(uint nu)
{
    1d4b:	55                   	push   %rbp
    1d4c:	48 89 e5             	mov    %rsp,%rbp
    1d4f:	48 83 ec 20          	sub    $0x20,%rsp
    1d53:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1d56:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1d5d:	77 07                	ja     1d66 <morecore+0x1b>
    nu = 4096;
    1d5f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d66:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d69:	48 c1 e0 04          	shl    $0x4,%rax
    1d6d:	48 89 c7             	mov    %rax,%rdi
    1d70:	48 b8 bd 15 00 00 00 	movabs $0x15bd,%rax
    1d77:	00 00 00 
    1d7a:	ff d0                	call   *%rax
    1d7c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d80:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d85:	75 07                	jne    1d8e <morecore+0x43>
    return 0;
    1d87:	b8 00 00 00 00       	mov    $0x0,%eax
    1d8c:	eb 36                	jmp    1dc4 <morecore+0x79>
  hp = (Header*)p;
    1d8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d9a:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d9d:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1da0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1da4:	48 83 c0 10          	add    $0x10,%rax
    1da8:	48 89 c7             	mov    %rax,%rdi
    1dab:	48 b8 19 1c 00 00 00 	movabs $0x1c19,%rax
    1db2:	00 00 00 
    1db5:	ff d0                	call   *%rax
  return freep;
    1db7:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    1dbe:	00 00 00 
    1dc1:	48 8b 00             	mov    (%rax),%rax
}
    1dc4:	c9                   	leave
    1dc5:	c3                   	ret

0000000000001dc6 <malloc>:

void*
malloc(uint nbytes)
{
    1dc6:	55                   	push   %rbp
    1dc7:	48 89 e5             	mov    %rsp,%rbp
    1dca:	48 83 ec 30          	sub    $0x30,%rsp
    1dce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1dd1:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1dd4:	48 83 c0 0f          	add    $0xf,%rax
    1dd8:	48 c1 e8 04          	shr    $0x4,%rax
    1ddc:	83 c0 01             	add    $0x1,%eax
    1ddf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1de2:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    1de9:	00 00 00 
    1dec:	48 8b 00             	mov    (%rax),%rax
    1def:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1df3:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1df8:	75 4a                	jne    1e44 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1dfa:	48 b8 80 21 00 00 00 	movabs $0x2180,%rax
    1e01:	00 00 00 
    1e04:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e08:	48 ba 90 21 00 00 00 	movabs $0x2190,%rdx
    1e0f:	00 00 00 
    1e12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e16:	48 89 02             	mov    %rax,(%rdx)
    1e19:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    1e20:	00 00 00 
    1e23:	48 8b 00             	mov    (%rax),%rax
    1e26:	48 ba 80 21 00 00 00 	movabs $0x2180,%rdx
    1e2d:	00 00 00 
    1e30:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1e33:	48 b8 80 21 00 00 00 	movabs $0x2180,%rax
    1e3a:	00 00 00 
    1e3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e48:	48 8b 00             	mov    (%rax),%rax
    1e4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e53:	8b 40 08             	mov    0x8(%rax),%eax
    1e56:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1e59:	72 65                	jb     1ec0 <malloc+0xfa>
      if(p->s.size == nunits)
    1e5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e5f:	8b 40 08             	mov    0x8(%rax),%eax
    1e62:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e65:	75 10                	jne    1e77 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1e67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e6b:	48 8b 10             	mov    (%rax),%rdx
    1e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e72:	48 89 10             	mov    %rdx,(%rax)
    1e75:	eb 2e                	jmp    1ea5 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1e77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e7b:	8b 40 08             	mov    0x8(%rax),%eax
    1e7e:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e81:	89 c2                	mov    %eax,%edx
    1e83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e87:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e8e:	8b 40 08             	mov    0x8(%rax),%eax
    1e91:	89 c0                	mov    %eax,%eax
    1e93:	48 c1 e0 04          	shl    $0x4,%rax
    1e97:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e9f:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1ea2:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1ea5:	48 ba 90 21 00 00 00 	movabs $0x2190,%rdx
    1eac:	00 00 00 
    1eaf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1eb3:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1eb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1eba:	48 83 c0 10          	add    $0x10,%rax
    1ebe:	eb 4e                	jmp    1f0e <malloc+0x148>
    }
    if(p == freep)
    1ec0:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    1ec7:	00 00 00 
    1eca:	48 8b 00             	mov    (%rax),%rax
    1ecd:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ed1:	75 23                	jne    1ef6 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1ed3:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ed6:	89 c7                	mov    %eax,%edi
    1ed8:	48 b8 4b 1d 00 00 00 	movabs $0x1d4b,%rax
    1edf:	00 00 00 
    1ee2:	ff d0                	call   *%rax
    1ee4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ee8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1eed:	75 07                	jne    1ef6 <malloc+0x130>
        return 0;
    1eef:	b8 00 00 00 00       	mov    $0x0,%eax
    1ef4:	eb 18                	jmp    1f0e <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ef6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1efa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1efe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f02:	48 8b 00             	mov    (%rax),%rax
    1f05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1f09:	e9 41 ff ff ff       	jmp    1e4f <malloc+0x89>
  }
}
    1f0e:	c9                   	leave
    1f0f:	c3                   	ret

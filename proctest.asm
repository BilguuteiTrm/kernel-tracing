
_proctest:     file format elf64-x86-64


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
  int pid;

  printf(1, "proctest: starting\n");
    100f:	48 b8 b0 1e 00 00 00 	movabs $0x1eb0,%rax
    1016:	00 00 00 
    1019:	48 89 c6             	mov    %rax,%rsi
    101c:	bf 01 00 00 00       	mov    $0x1,%edi
    1021:	b8 00 00 00 00       	mov    $0x0,%eax
    1026:	48 ba 8e 17 00 00 00 	movabs $0x178e,%rdx
    102d:	00 00 00 
    1030:	ff d2                	call   *%rdx
  pid = fork();
    1032:	48 b8 73 14 00 00 00 	movabs $0x1473,%rax
    1039:	00 00 00 
    103c:	ff d0                	call   *%rax
    103e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(pid < 0){
    1041:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1045:	79 2f                	jns    1076 <main+0x76>
    printf(1, "fork failed\n");
    1047:	48 b8 c4 1e 00 00 00 	movabs $0x1ec4,%rax
    104e:	00 00 00 
    1051:	48 89 c6             	mov    %rax,%rsi
    1054:	bf 01 00 00 00       	mov    $0x1,%edi
    1059:	b8 00 00 00 00       	mov    $0x0,%eax
    105e:	48 ba 8e 17 00 00 00 	movabs $0x178e,%rdx
    1065:	00 00 00 
    1068:	ff d2                	call   *%rdx
    exit();
    106a:	48 b8 80 14 00 00 00 	movabs $0x1480,%rax
    1071:	00 00 00 
    1074:	ff d0                	call   *%rax
  }
  if(pid == 0){
    1076:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    107a:	75 63                	jne    10df <main+0xdf>
    printf(1, "child: sleeping\n");
    107c:	48 b8 d1 1e 00 00 00 	movabs $0x1ed1,%rax
    1083:	00 00 00 
    1086:	48 89 c6             	mov    %rax,%rsi
    1089:	bf 01 00 00 00       	mov    $0x1,%edi
    108e:	b8 00 00 00 00       	mov    $0x0,%eax
    1093:	48 ba 8e 17 00 00 00 	movabs $0x178e,%rdx
    109a:	00 00 00 
    109d:	ff d2                	call   *%rdx
    sleep(20);
    109f:	bf 14 00 00 00       	mov    $0x14,%edi
    10a4:	48 b8 6a 15 00 00 00 	movabs $0x156a,%rax
    10ab:	00 00 00 
    10ae:	ff d0                	call   *%rax
    printf(1, "child: exiting\n");
    10b0:	48 b8 e2 1e 00 00 00 	movabs $0x1ee2,%rax
    10b7:	00 00 00 
    10ba:	48 89 c6             	mov    %rax,%rsi
    10bd:	bf 01 00 00 00       	mov    $0x1,%edi
    10c2:	b8 00 00 00 00       	mov    $0x0,%eax
    10c7:	48 ba 8e 17 00 00 00 	movabs $0x178e,%rdx
    10ce:	00 00 00 
    10d1:	ff d2                	call   *%rdx
    exit();
    10d3:	48 b8 80 14 00 00 00 	movabs $0x1480,%rax
    10da:	00 00 00 
    10dd:	ff d0                	call   *%rax
  } else {
    printf(1, "parent: waiting for child %d\n", pid);
    10df:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10e2:	48 b9 f2 1e 00 00 00 	movabs $0x1ef2,%rcx
    10e9:	00 00 00 
    10ec:	89 c2                	mov    %eax,%edx
    10ee:	48 89 ce             	mov    %rcx,%rsi
    10f1:	bf 01 00 00 00       	mov    $0x1,%edi
    10f6:	b8 00 00 00 00       	mov    $0x0,%eax
    10fb:	48 b9 8e 17 00 00 00 	movabs $0x178e,%rcx
    1102:	00 00 00 
    1105:	ff d1                	call   *%rcx
    wait();
    1107:	48 b8 8d 14 00 00 00 	movabs $0x148d,%rax
    110e:	00 00 00 
    1111:	ff d0                	call   *%rax
    printf(1, "parent: child exited\n");
    1113:	48 b8 10 1f 00 00 00 	movabs $0x1f10,%rax
    111a:	00 00 00 
    111d:	48 89 c6             	mov    %rax,%rsi
    1120:	bf 01 00 00 00       	mov    $0x1,%edi
    1125:	b8 00 00 00 00       	mov    $0x0,%eax
    112a:	48 ba 8e 17 00 00 00 	movabs $0x178e,%rdx
    1131:	00 00 00 
    1134:	ff d2                	call   *%rdx
  }
  printf(1, "proctest: done\n");
    1136:	48 b8 26 1f 00 00 00 	movabs $0x1f26,%rax
    113d:	00 00 00 
    1140:	48 89 c6             	mov    %rax,%rsi
    1143:	bf 01 00 00 00       	mov    $0x1,%edi
    1148:	b8 00 00 00 00       	mov    $0x0,%eax
    114d:	48 ba 8e 17 00 00 00 	movabs $0x178e,%rdx
    1154:	00 00 00 
    1157:	ff d2                	call   *%rdx
  exit();
    1159:	48 b8 80 14 00 00 00 	movabs $0x1480,%rax
    1160:	00 00 00 
    1163:	ff d0                	call   *%rax

0000000000001165 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1165:	55                   	push   %rbp
    1166:	48 89 e5             	mov    %rsp,%rbp
    1169:	48 83 ec 10          	sub    $0x10,%rsp
    116d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1171:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1174:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1177:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    117b:	8b 55 f0             	mov    -0x10(%rbp),%edx
    117e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1181:	48 89 ce             	mov    %rcx,%rsi
    1184:	48 89 f7             	mov    %rsi,%rdi
    1187:	89 d1                	mov    %edx,%ecx
    1189:	fc                   	cld
    118a:	f3 aa                	rep stos %al,(%rdi)
    118c:	89 ca                	mov    %ecx,%edx
    118e:	48 89 fe             	mov    %rdi,%rsi
    1191:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1195:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1198:	90                   	nop
    1199:	c9                   	leave
    119a:	c3                   	ret

000000000000119b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    119b:	55                   	push   %rbp
    119c:	48 89 e5             	mov    %rsp,%rbp
    119f:	48 83 ec 20          	sub    $0x20,%rsp
    11a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    11a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    11ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    11b3:	90                   	nop
    11b4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    11b8:	48 8d 42 01          	lea    0x1(%rdx),%rax
    11bc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    11c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11c4:	48 8d 48 01          	lea    0x1(%rax),%rcx
    11c8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    11cc:	0f b6 12             	movzbl (%rdx),%edx
    11cf:	88 10                	mov    %dl,(%rax)
    11d1:	0f b6 00             	movzbl (%rax),%eax
    11d4:	84 c0                	test   %al,%al
    11d6:	75 dc                	jne    11b4 <strcpy+0x19>
    ;
  return os;
    11d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11dc:	c9                   	leave
    11dd:	c3                   	ret

00000000000011de <strcmp>:

int
strcmp(const char *p, const char *q)
{
    11de:	55                   	push   %rbp
    11df:	48 89 e5             	mov    %rsp,%rbp
    11e2:	48 83 ec 10          	sub    $0x10,%rsp
    11e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    11ee:	eb 0a                	jmp    11fa <strcmp+0x1c>
    p++, q++;
    11f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    11f5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    11fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11fe:	0f b6 00             	movzbl (%rax),%eax
    1201:	84 c0                	test   %al,%al
    1203:	74 12                	je     1217 <strcmp+0x39>
    1205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1209:	0f b6 10             	movzbl (%rax),%edx
    120c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1210:	0f b6 00             	movzbl (%rax),%eax
    1213:	38 c2                	cmp    %al,%dl
    1215:	74 d9                	je     11f0 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    121b:	0f b6 00             	movzbl (%rax),%eax
    121e:	0f b6 d0             	movzbl %al,%edx
    1221:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1225:	0f b6 00             	movzbl (%rax),%eax
    1228:	0f b6 c0             	movzbl %al,%eax
    122b:	29 c2                	sub    %eax,%edx
    122d:	89 d0                	mov    %edx,%eax
}
    122f:	c9                   	leave
    1230:	c3                   	ret

0000000000001231 <strlen>:

uint
strlen(char *s)
{
    1231:	55                   	push   %rbp
    1232:	48 89 e5             	mov    %rsp,%rbp
    1235:	48 83 ec 18          	sub    $0x18,%rsp
    1239:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    123d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1244:	eb 04                	jmp    124a <strlen+0x19>
    1246:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    124a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    124d:	48 63 d0             	movslq %eax,%rdx
    1250:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1254:	48 01 d0             	add    %rdx,%rax
    1257:	0f b6 00             	movzbl (%rax),%eax
    125a:	84 c0                	test   %al,%al
    125c:	75 e8                	jne    1246 <strlen+0x15>
    ;
  return n;
    125e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1261:	c9                   	leave
    1262:	c3                   	ret

0000000000001263 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1263:	55                   	push   %rbp
    1264:	48 89 e5             	mov    %rsp,%rbp
    1267:	48 83 ec 10          	sub    $0x10,%rsp
    126b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    126f:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1272:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1275:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1278:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    127b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    127f:	89 ce                	mov    %ecx,%esi
    1281:	48 89 c7             	mov    %rax,%rdi
    1284:	48 b8 65 11 00 00 00 	movabs $0x1165,%rax
    128b:	00 00 00 
    128e:	ff d0                	call   *%rax
  return dst;
    1290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1294:	c9                   	leave
    1295:	c3                   	ret

0000000000001296 <strchr>:

char*
strchr(const char *s, char c)
{
    1296:	55                   	push   %rbp
    1297:	48 89 e5             	mov    %rsp,%rbp
    129a:	48 83 ec 10          	sub    $0x10,%rsp
    129e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12a2:	89 f0                	mov    %esi,%eax
    12a4:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    12a7:	eb 17                	jmp    12c0 <strchr+0x2a>
    if(*s == c)
    12a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12ad:	0f b6 00             	movzbl (%rax),%eax
    12b0:	38 45 f4             	cmp    %al,-0xc(%rbp)
    12b3:	75 06                	jne    12bb <strchr+0x25>
      return (char*)s;
    12b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12b9:	eb 15                	jmp    12d0 <strchr+0x3a>
  for(; *s; s++)
    12bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    12c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12c4:	0f b6 00             	movzbl (%rax),%eax
    12c7:	84 c0                	test   %al,%al
    12c9:	75 de                	jne    12a9 <strchr+0x13>
  return 0;
    12cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12d0:	c9                   	leave
    12d1:	c3                   	ret

00000000000012d2 <gets>:

char*
gets(char *buf, int max)
{
    12d2:	55                   	push   %rbp
    12d3:	48 89 e5             	mov    %rsp,%rbp
    12d6:	48 83 ec 20          	sub    $0x20,%rsp
    12da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12de:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12e8:	eb 4f                	jmp    1339 <gets+0x67>
    cc = read(0, &c, 1);
    12ea:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    12ee:	ba 01 00 00 00       	mov    $0x1,%edx
    12f3:	48 89 c6             	mov    %rax,%rsi
    12f6:	bf 00 00 00 00       	mov    $0x0,%edi
    12fb:	48 b8 a7 14 00 00 00 	movabs $0x14a7,%rax
    1302:	00 00 00 
    1305:	ff d0                	call   *%rax
    1307:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    130a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    130e:	7e 36                	jle    1346 <gets+0x74>
      break;
    buf[i++] = c;
    1310:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1313:	8d 50 01             	lea    0x1(%rax),%edx
    1316:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1319:	48 63 d0             	movslq %eax,%rdx
    131c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1320:	48 01 c2             	add    %rax,%rdx
    1323:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1327:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1329:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    132d:	3c 0a                	cmp    $0xa,%al
    132f:	74 16                	je     1347 <gets+0x75>
    1331:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1335:	3c 0d                	cmp    $0xd,%al
    1337:	74 0e                	je     1347 <gets+0x75>
  for(i=0; i+1 < max; ){
    1339:	8b 45 fc             	mov    -0x4(%rbp),%eax
    133c:	83 c0 01             	add    $0x1,%eax
    133f:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1342:	7f a6                	jg     12ea <gets+0x18>
    1344:	eb 01                	jmp    1347 <gets+0x75>
      break;
    1346:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1347:	8b 45 fc             	mov    -0x4(%rbp),%eax
    134a:	48 63 d0             	movslq %eax,%rdx
    134d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1351:	48 01 d0             	add    %rdx,%rax
    1354:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1357:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    135b:	c9                   	leave
    135c:	c3                   	ret

000000000000135d <stat>:

int
stat(char *n, struct stat *st)
{
    135d:	55                   	push   %rbp
    135e:	48 89 e5             	mov    %rsp,%rbp
    1361:	48 83 ec 20          	sub    $0x20,%rsp
    1365:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1369:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    136d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1371:	be 00 00 00 00       	mov    $0x0,%esi
    1376:	48 89 c7             	mov    %rax,%rdi
    1379:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    1380:	00 00 00 
    1383:	ff d0                	call   *%rax
    1385:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1388:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    138c:	79 07                	jns    1395 <stat+0x38>
    return -1;
    138e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1393:	eb 2f                	jmp    13c4 <stat+0x67>
  r = fstat(fd, st);
    1395:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1399:	8b 45 fc             	mov    -0x4(%rbp),%eax
    139c:	48 89 d6             	mov    %rdx,%rsi
    139f:	89 c7                	mov    %eax,%edi
    13a1:	48 b8 0f 15 00 00 00 	movabs $0x150f,%rax
    13a8:	00 00 00 
    13ab:	ff d0                	call   *%rax
    13ad:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    13b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13b3:	89 c7                	mov    %eax,%edi
    13b5:	48 b8 c1 14 00 00 00 	movabs $0x14c1,%rax
    13bc:	00 00 00 
    13bf:	ff d0                	call   *%rax
  return r;
    13c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    13c4:	c9                   	leave
    13c5:	c3                   	ret

00000000000013c6 <atoi>:

int
atoi(const char *s)
{
    13c6:	55                   	push   %rbp
    13c7:	48 89 e5             	mov    %rsp,%rbp
    13ca:	48 83 ec 18          	sub    $0x18,%rsp
    13ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    13d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    13d9:	eb 28                	jmp    1403 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    13db:	8b 55 fc             	mov    -0x4(%rbp),%edx
    13de:	89 d0                	mov    %edx,%eax
    13e0:	c1 e0 02             	shl    $0x2,%eax
    13e3:	01 d0                	add    %edx,%eax
    13e5:	01 c0                	add    %eax,%eax
    13e7:	89 c1                	mov    %eax,%ecx
    13e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
    13f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    13f5:	0f b6 00             	movzbl (%rax),%eax
    13f8:	0f be c0             	movsbl %al,%eax
    13fb:	01 c8                	add    %ecx,%eax
    13fd:	83 e8 30             	sub    $0x30,%eax
    1400:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1407:	0f b6 00             	movzbl (%rax),%eax
    140a:	3c 2f                	cmp    $0x2f,%al
    140c:	7e 0b                	jle    1419 <atoi+0x53>
    140e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1412:	0f b6 00             	movzbl (%rax),%eax
    1415:	3c 39                	cmp    $0x39,%al
    1417:	7e c2                	jle    13db <atoi+0x15>
  return n;
    1419:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    141c:	c9                   	leave
    141d:	c3                   	ret

000000000000141e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    141e:	55                   	push   %rbp
    141f:	48 89 e5             	mov    %rsp,%rbp
    1422:	48 83 ec 28          	sub    $0x28,%rsp
    1426:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    142a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    142e:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1431:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1435:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1439:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    143d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1441:	eb 1d                	jmp    1460 <memmove+0x42>
    *dst++ = *src++;
    1443:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1447:	48 8d 42 01          	lea    0x1(%rdx),%rax
    144b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    144f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1453:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1457:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    145b:	0f b6 12             	movzbl (%rdx),%edx
    145e:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1460:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1463:	8d 50 ff             	lea    -0x1(%rax),%edx
    1466:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1469:	85 c0                	test   %eax,%eax
    146b:	7f d6                	jg     1443 <memmove+0x25>
  return vdst;
    146d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1471:	c9                   	leave
    1472:	c3                   	ret

0000000000001473 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1473:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    147a:	49 89 ca             	mov    %rcx,%r10
    147d:	0f 05                	syscall
    147f:	c3                   	ret

0000000000001480 <exit>:
SYSCALL(exit)
    1480:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1487:	49 89 ca             	mov    %rcx,%r10
    148a:	0f 05                	syscall
    148c:	c3                   	ret

000000000000148d <wait>:
SYSCALL(wait)
    148d:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1494:	49 89 ca             	mov    %rcx,%r10
    1497:	0f 05                	syscall
    1499:	c3                   	ret

000000000000149a <pipe>:
SYSCALL(pipe)
    149a:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    14a1:	49 89 ca             	mov    %rcx,%r10
    14a4:	0f 05                	syscall
    14a6:	c3                   	ret

00000000000014a7 <read>:
SYSCALL(read)
    14a7:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    14ae:	49 89 ca             	mov    %rcx,%r10
    14b1:	0f 05                	syscall
    14b3:	c3                   	ret

00000000000014b4 <write>:
SYSCALL(write)
    14b4:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    14bb:	49 89 ca             	mov    %rcx,%r10
    14be:	0f 05                	syscall
    14c0:	c3                   	ret

00000000000014c1 <close>:
SYSCALL(close)
    14c1:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    14c8:	49 89 ca             	mov    %rcx,%r10
    14cb:	0f 05                	syscall
    14cd:	c3                   	ret

00000000000014ce <kill>:
SYSCALL(kill)
    14ce:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    14d5:	49 89 ca             	mov    %rcx,%r10
    14d8:	0f 05                	syscall
    14da:	c3                   	ret

00000000000014db <exec>:
SYSCALL(exec)
    14db:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    14e2:	49 89 ca             	mov    %rcx,%r10
    14e5:	0f 05                	syscall
    14e7:	c3                   	ret

00000000000014e8 <open>:
SYSCALL(open)
    14e8:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    14ef:	49 89 ca             	mov    %rcx,%r10
    14f2:	0f 05                	syscall
    14f4:	c3                   	ret

00000000000014f5 <mknod>:
SYSCALL(mknod)
    14f5:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    14fc:	49 89 ca             	mov    %rcx,%r10
    14ff:	0f 05                	syscall
    1501:	c3                   	ret

0000000000001502 <unlink>:
SYSCALL(unlink)
    1502:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1509:	49 89 ca             	mov    %rcx,%r10
    150c:	0f 05                	syscall
    150e:	c3                   	ret

000000000000150f <fstat>:
SYSCALL(fstat)
    150f:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1516:	49 89 ca             	mov    %rcx,%r10
    1519:	0f 05                	syscall
    151b:	c3                   	ret

000000000000151c <link>:
SYSCALL(link)
    151c:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1523:	49 89 ca             	mov    %rcx,%r10
    1526:	0f 05                	syscall
    1528:	c3                   	ret

0000000000001529 <mkdir>:
SYSCALL(mkdir)
    1529:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1530:	49 89 ca             	mov    %rcx,%r10
    1533:	0f 05                	syscall
    1535:	c3                   	ret

0000000000001536 <chdir>:
SYSCALL(chdir)
    1536:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    153d:	49 89 ca             	mov    %rcx,%r10
    1540:	0f 05                	syscall
    1542:	c3                   	ret

0000000000001543 <dup>:
SYSCALL(dup)
    1543:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    154a:	49 89 ca             	mov    %rcx,%r10
    154d:	0f 05                	syscall
    154f:	c3                   	ret

0000000000001550 <getpid>:
SYSCALL(getpid)
    1550:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1557:	49 89 ca             	mov    %rcx,%r10
    155a:	0f 05                	syscall
    155c:	c3                   	ret

000000000000155d <sbrk>:
SYSCALL(sbrk)
    155d:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1564:	49 89 ca             	mov    %rcx,%r10
    1567:	0f 05                	syscall
    1569:	c3                   	ret

000000000000156a <sleep>:
SYSCALL(sleep)
    156a:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1571:	49 89 ca             	mov    %rcx,%r10
    1574:	0f 05                	syscall
    1576:	c3                   	ret

0000000000001577 <uptime>:
SYSCALL(uptime)
    1577:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    157e:	49 89 ca             	mov    %rcx,%r10
    1581:	0f 05                	syscall
    1583:	c3                   	ret

0000000000001584 <traceread>:
SYSCALL(traceread)
    1584:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    158b:	49 89 ca             	mov    %rcx,%r10
    158e:	0f 05                	syscall
    1590:	c3                   	ret

0000000000001591 <vidclear>:
SYSCALL(vidclear)
    1591:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    1598:	49 89 ca             	mov    %rcx,%r10
    159b:	0f 05                	syscall
    159d:	c3                   	ret

000000000000159e <vidputc>:
SYSCALL(vidputc)
    159e:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    15a5:	49 89 ca             	mov    %rcx,%r10
    15a8:	0f 05                	syscall
    15aa:	c3                   	ret

00000000000015ab <vidputs>:
SYSCALL(vidputs)
    15ab:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    15b2:	49 89 ca             	mov    %rcx,%r10
    15b5:	0f 05                	syscall
    15b7:	c3                   	ret

00000000000015b8 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    15b8:	55                   	push   %rbp
    15b9:	48 89 e5             	mov    %rsp,%rbp
    15bc:	48 83 ec 10          	sub    $0x10,%rsp
    15c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
    15c3:	89 f0                	mov    %esi,%eax
    15c5:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    15c8:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    15cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15cf:	ba 01 00 00 00       	mov    $0x1,%edx
    15d4:	48 89 ce             	mov    %rcx,%rsi
    15d7:	89 c7                	mov    %eax,%edi
    15d9:	48 b8 b4 14 00 00 00 	movabs $0x14b4,%rax
    15e0:	00 00 00 
    15e3:	ff d0                	call   *%rax
}
    15e5:	90                   	nop
    15e6:	c9                   	leave
    15e7:	c3                   	ret

00000000000015e8 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    15e8:	55                   	push   %rbp
    15e9:	48 89 e5             	mov    %rsp,%rbp
    15ec:	48 83 ec 20          	sub    $0x20,%rsp
    15f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    15f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15fe:	eb 35                	jmp    1635 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1600:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1604:	48 c1 e8 3c          	shr    $0x3c,%rax
    1608:	48 ba 40 1f 00 00 00 	movabs $0x1f40,%rdx
    160f:	00 00 00 
    1612:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1616:	0f be d0             	movsbl %al,%edx
    1619:	8b 45 ec             	mov    -0x14(%rbp),%eax
    161c:	89 d6                	mov    %edx,%esi
    161e:	89 c7                	mov    %eax,%edi
    1620:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1627:	00 00 00 
    162a:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    162c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1630:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1635:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1638:	83 f8 0f             	cmp    $0xf,%eax
    163b:	76 c3                	jbe    1600 <print_x64+0x18>
}
    163d:	90                   	nop
    163e:	90                   	nop
    163f:	c9                   	leave
    1640:	c3                   	ret

0000000000001641 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1641:	55                   	push   %rbp
    1642:	48 89 e5             	mov    %rsp,%rbp
    1645:	48 83 ec 20          	sub    $0x20,%rsp
    1649:	89 7d ec             	mov    %edi,-0x14(%rbp)
    164c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    164f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1656:	eb 36                	jmp    168e <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1658:	8b 45 e8             	mov    -0x18(%rbp),%eax
    165b:	c1 e8 1c             	shr    $0x1c,%eax
    165e:	89 c2                	mov    %eax,%edx
    1660:	48 b8 40 1f 00 00 00 	movabs $0x1f40,%rax
    1667:	00 00 00 
    166a:	89 d2                	mov    %edx,%edx
    166c:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1670:	0f be d0             	movsbl %al,%edx
    1673:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1676:	89 d6                	mov    %edx,%esi
    1678:	89 c7                	mov    %eax,%edi
    167a:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1681:	00 00 00 
    1684:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1686:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    168a:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    168e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1691:	83 f8 07             	cmp    $0x7,%eax
    1694:	76 c2                	jbe    1658 <print_x32+0x17>
}
    1696:	90                   	nop
    1697:	90                   	nop
    1698:	c9                   	leave
    1699:	c3                   	ret

000000000000169a <print_d>:

  static void
print_d(int fd, int v)
{
    169a:	55                   	push   %rbp
    169b:	48 89 e5             	mov    %rsp,%rbp
    169e:	48 83 ec 30          	sub    $0x30,%rsp
    16a2:	89 7d dc             	mov    %edi,-0x24(%rbp)
    16a5:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    16a8:	8b 45 d8             	mov    -0x28(%rbp),%eax
    16ab:	48 98                	cltq
    16ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    16b1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16b5:	79 04                	jns    16bb <print_d+0x21>
    x = -x;
    16b7:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    16bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    16c2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    16c6:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    16cd:	66 66 66 
    16d0:	48 89 c8             	mov    %rcx,%rax
    16d3:	48 f7 ea             	imul   %rdx
    16d6:	48 c1 fa 02          	sar    $0x2,%rdx
    16da:	48 89 c8             	mov    %rcx,%rax
    16dd:	48 c1 f8 3f          	sar    $0x3f,%rax
    16e1:	48 29 c2             	sub    %rax,%rdx
    16e4:	48 89 d0             	mov    %rdx,%rax
    16e7:	48 c1 e0 02          	shl    $0x2,%rax
    16eb:	48 01 d0             	add    %rdx,%rax
    16ee:	48 01 c0             	add    %rax,%rax
    16f1:	48 29 c1             	sub    %rax,%rcx
    16f4:	48 89 ca             	mov    %rcx,%rdx
    16f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16fa:	8d 48 01             	lea    0x1(%rax),%ecx
    16fd:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1700:	48 b9 40 1f 00 00 00 	movabs $0x1f40,%rcx
    1707:	00 00 00 
    170a:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    170e:	48 98                	cltq
    1710:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1714:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1718:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    171f:	66 66 66 
    1722:	48 89 c8             	mov    %rcx,%rax
    1725:	48 f7 ea             	imul   %rdx
    1728:	48 89 d0             	mov    %rdx,%rax
    172b:	48 c1 f8 02          	sar    $0x2,%rax
    172f:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1733:	48 89 ca             	mov    %rcx,%rdx
    1736:	48 29 d0             	sub    %rdx,%rax
    1739:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    173d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1742:	0f 85 7a ff ff ff    	jne    16c2 <print_d+0x28>

  if (v < 0)
    1748:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    174c:	79 32                	jns    1780 <print_d+0xe6>
    buf[i++] = '-';
    174e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1751:	8d 50 01             	lea    0x1(%rax),%edx
    1754:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1757:	48 98                	cltq
    1759:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    175e:	eb 20                	jmp    1780 <print_d+0xe6>
    putc(fd, buf[i]);
    1760:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1763:	48 98                	cltq
    1765:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    176a:	0f be d0             	movsbl %al,%edx
    176d:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1770:	89 d6                	mov    %edx,%esi
    1772:	89 c7                	mov    %eax,%edi
    1774:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    177b:	00 00 00 
    177e:	ff d0                	call   *%rax
  while (--i >= 0)
    1780:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1784:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1788:	79 d6                	jns    1760 <print_d+0xc6>
}
    178a:	90                   	nop
    178b:	90                   	nop
    178c:	c9                   	leave
    178d:	c3                   	ret

000000000000178e <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    178e:	55                   	push   %rbp
    178f:	48 89 e5             	mov    %rsp,%rbp
    1792:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1799:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    179f:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    17a6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    17ad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    17b4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    17bb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    17c2:	84 c0                	test   %al,%al
    17c4:	74 20                	je     17e6 <printf+0x58>
    17c6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    17ca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    17ce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    17d2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    17d6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    17da:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    17de:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    17e2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    17e6:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    17ed:	00 00 00 
    17f0:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    17f7:	00 00 00 
    17fa:	48 8d 45 10          	lea    0x10(%rbp),%rax
    17fe:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1805:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    180c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1813:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    181a:	00 00 00 
    181d:	e9 60 03 00 00       	jmp    1b82 <printf+0x3f4>
    if (c != '%') {
    1822:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1829:	74 24                	je     184f <printf+0xc1>
      putc(fd, c);
    182b:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1831:	0f be d0             	movsbl %al,%edx
    1834:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    183a:	89 d6                	mov    %edx,%esi
    183c:	89 c7                	mov    %eax,%edi
    183e:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1845:	00 00 00 
    1848:	ff d0                	call   *%rax
      continue;
    184a:	e9 2c 03 00 00       	jmp    1b7b <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    184f:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1856:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    185c:	48 63 d0             	movslq %eax,%rdx
    185f:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1866:	48 01 d0             	add    %rdx,%rax
    1869:	0f b6 00             	movzbl (%rax),%eax
    186c:	0f be c0             	movsbl %al,%eax
    186f:	25 ff 00 00 00       	and    $0xff,%eax
    1874:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    187a:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1881:	0f 84 2e 03 00 00    	je     1bb5 <printf+0x427>
      break;
    switch(c) {
    1887:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    188e:	0f 84 32 01 00 00    	je     19c6 <printf+0x238>
    1894:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    189b:	0f 8f a1 02 00 00    	jg     1b42 <printf+0x3b4>
    18a1:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    18a8:	0f 84 d4 01 00 00    	je     1a82 <printf+0x2f4>
    18ae:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    18b5:	0f 8f 87 02 00 00    	jg     1b42 <printf+0x3b4>
    18bb:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    18c2:	0f 84 5b 01 00 00    	je     1a23 <printf+0x295>
    18c8:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    18cf:	0f 8f 6d 02 00 00    	jg     1b42 <printf+0x3b4>
    18d5:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    18dc:	0f 84 87 00 00 00    	je     1969 <printf+0x1db>
    18e2:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    18e9:	0f 8f 53 02 00 00    	jg     1b42 <printf+0x3b4>
    18ef:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18f6:	0f 84 2b 02 00 00    	je     1b27 <printf+0x399>
    18fc:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1903:	0f 85 39 02 00 00    	jne    1b42 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    1909:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    190f:	83 f8 2f             	cmp    $0x2f,%eax
    1912:	77 23                	ja     1937 <printf+0x1a9>
    1914:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    191b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1921:	89 d2                	mov    %edx,%edx
    1923:	48 01 d0             	add    %rdx,%rax
    1926:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    192c:	83 c2 08             	add    $0x8,%edx
    192f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1935:	eb 12                	jmp    1949 <printf+0x1bb>
    1937:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    193e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1942:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1949:	8b 00                	mov    (%rax),%eax
    194b:	0f be d0             	movsbl %al,%edx
    194e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1954:	89 d6                	mov    %edx,%esi
    1956:	89 c7                	mov    %eax,%edi
    1958:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    195f:	00 00 00 
    1962:	ff d0                	call   *%rax
      break;
    1964:	e9 12 02 00 00       	jmp    1b7b <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1969:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    196f:	83 f8 2f             	cmp    $0x2f,%eax
    1972:	77 23                	ja     1997 <printf+0x209>
    1974:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    197b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1981:	89 d2                	mov    %edx,%edx
    1983:	48 01 d0             	add    %rdx,%rax
    1986:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    198c:	83 c2 08             	add    $0x8,%edx
    198f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1995:	eb 12                	jmp    19a9 <printf+0x21b>
    1997:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    199e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19a2:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19a9:	8b 10                	mov    (%rax),%edx
    19ab:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19b1:	89 d6                	mov    %edx,%esi
    19b3:	89 c7                	mov    %eax,%edi
    19b5:	48 b8 9a 16 00 00 00 	movabs $0x169a,%rax
    19bc:	00 00 00 
    19bf:	ff d0                	call   *%rax
      break;
    19c1:	e9 b5 01 00 00       	jmp    1b7b <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    19c6:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19cc:	83 f8 2f             	cmp    $0x2f,%eax
    19cf:	77 23                	ja     19f4 <printf+0x266>
    19d1:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19d8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19de:	89 d2                	mov    %edx,%edx
    19e0:	48 01 d0             	add    %rdx,%rax
    19e3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19e9:	83 c2 08             	add    $0x8,%edx
    19ec:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19f2:	eb 12                	jmp    1a06 <printf+0x278>
    19f4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19fb:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19ff:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a06:	8b 10                	mov    (%rax),%edx
    1a08:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a0e:	89 d6                	mov    %edx,%esi
    1a10:	89 c7                	mov    %eax,%edi
    1a12:	48 b8 41 16 00 00 00 	movabs $0x1641,%rax
    1a19:	00 00 00 
    1a1c:	ff d0                	call   *%rax
      break;
    1a1e:	e9 58 01 00 00       	jmp    1b7b <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a23:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a29:	83 f8 2f             	cmp    $0x2f,%eax
    1a2c:	77 23                	ja     1a51 <printf+0x2c3>
    1a2e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a35:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a3b:	89 d2                	mov    %edx,%edx
    1a3d:	48 01 d0             	add    %rdx,%rax
    1a40:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a46:	83 c2 08             	add    $0x8,%edx
    1a49:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a4f:	eb 12                	jmp    1a63 <printf+0x2d5>
    1a51:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a58:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a5c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a63:	48 8b 10             	mov    (%rax),%rdx
    1a66:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a6c:	48 89 d6             	mov    %rdx,%rsi
    1a6f:	89 c7                	mov    %eax,%edi
    1a71:	48 b8 e8 15 00 00 00 	movabs $0x15e8,%rax
    1a78:	00 00 00 
    1a7b:	ff d0                	call   *%rax
      break;
    1a7d:	e9 f9 00 00 00       	jmp    1b7b <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1a82:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a88:	83 f8 2f             	cmp    $0x2f,%eax
    1a8b:	77 23                	ja     1ab0 <printf+0x322>
    1a8d:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a94:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a9a:	89 d2                	mov    %edx,%edx
    1a9c:	48 01 d0             	add    %rdx,%rax
    1a9f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1aa5:	83 c2 08             	add    $0x8,%edx
    1aa8:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1aae:	eb 12                	jmp    1ac2 <printf+0x334>
    1ab0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ab7:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1abb:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ac2:	48 8b 00             	mov    (%rax),%rax
    1ac5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1acc:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1ad3:	00 
    1ad4:	75 41                	jne    1b17 <printf+0x389>
        s = "(null)";
    1ad6:	48 b8 36 1f 00 00 00 	movabs $0x1f36,%rax
    1add:	00 00 00 
    1ae0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1ae7:	eb 2e                	jmp    1b17 <printf+0x389>
        putc(fd, *(s++));
    1ae9:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1af0:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1af4:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1afb:	0f b6 00             	movzbl (%rax),%eax
    1afe:	0f be d0             	movsbl %al,%edx
    1b01:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b07:	89 d6                	mov    %edx,%esi
    1b09:	89 c7                	mov    %eax,%edi
    1b0b:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1b12:	00 00 00 
    1b15:	ff d0                	call   *%rax
      while (*s)
    1b17:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b1e:	0f b6 00             	movzbl (%rax),%eax
    1b21:	84 c0                	test   %al,%al
    1b23:	75 c4                	jne    1ae9 <printf+0x35b>
      break;
    1b25:	eb 54                	jmp    1b7b <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1b27:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b2d:	be 25 00 00 00       	mov    $0x25,%esi
    1b32:	89 c7                	mov    %eax,%edi
    1b34:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1b3b:	00 00 00 
    1b3e:	ff d0                	call   *%rax
      break;
    1b40:	eb 39                	jmp    1b7b <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b42:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b48:	be 25 00 00 00       	mov    $0x25,%esi
    1b4d:	89 c7                	mov    %eax,%edi
    1b4f:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1b56:	00 00 00 
    1b59:	ff d0                	call   *%rax
      putc(fd, c);
    1b5b:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b61:	0f be d0             	movsbl %al,%edx
    1b64:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b6a:	89 d6                	mov    %edx,%esi
    1b6c:	89 c7                	mov    %eax,%edi
    1b6e:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1b75:	00 00 00 
    1b78:	ff d0                	call   *%rax
      break;
    1b7a:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b7b:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b82:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1b88:	48 63 d0             	movslq %eax,%rdx
    1b8b:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1b92:	48 01 d0             	add    %rdx,%rax
    1b95:	0f b6 00             	movzbl (%rax),%eax
    1b98:	0f be c0             	movsbl %al,%eax
    1b9b:	25 ff 00 00 00       	and    $0xff,%eax
    1ba0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ba6:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1bad:	0f 85 6f fc ff ff    	jne    1822 <printf+0x94>
    }
  }
}
    1bb3:	eb 01                	jmp    1bb6 <printf+0x428>
      break;
    1bb5:	90                   	nop
}
    1bb6:	90                   	nop
    1bb7:	c9                   	leave
    1bb8:	c3                   	ret

0000000000001bb9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1bb9:	55                   	push   %rbp
    1bba:	48 89 e5             	mov    %rsp,%rbp
    1bbd:	48 83 ec 18          	sub    $0x18,%rsp
    1bc1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1bc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1bc9:	48 83 e8 10          	sub    $0x10,%rax
    1bcd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1bd1:	48 b8 70 1f 00 00 00 	movabs $0x1f70,%rax
    1bd8:	00 00 00 
    1bdb:	48 8b 00             	mov    (%rax),%rax
    1bde:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1be2:	eb 2f                	jmp    1c13 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1be4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be8:	48 8b 00             	mov    (%rax),%rax
    1beb:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1bef:	72 17                	jb     1c08 <free+0x4f>
    1bf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bf5:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1bf9:	72 2f                	jb     1c2a <free+0x71>
    1bfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bff:	48 8b 00             	mov    (%rax),%rax
    1c02:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c06:	72 22                	jb     1c2a <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c0c:	48 8b 00             	mov    (%rax),%rax
    1c0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c17:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c1b:	73 c7                	jae    1be4 <free+0x2b>
    1c1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c21:	48 8b 00             	mov    (%rax),%rax
    1c24:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c28:	73 ba                	jae    1be4 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c2e:	8b 40 08             	mov    0x8(%rax),%eax
    1c31:	89 c0                	mov    %eax,%eax
    1c33:	48 c1 e0 04          	shl    $0x4,%rax
    1c37:	48 89 c2             	mov    %rax,%rdx
    1c3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c3e:	48 01 c2             	add    %rax,%rdx
    1c41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c45:	48 8b 00             	mov    (%rax),%rax
    1c48:	48 39 c2             	cmp    %rax,%rdx
    1c4b:	75 2d                	jne    1c7a <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1c4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c51:	8b 50 08             	mov    0x8(%rax),%edx
    1c54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c58:	48 8b 00             	mov    (%rax),%rax
    1c5b:	8b 40 08             	mov    0x8(%rax),%eax
    1c5e:	01 c2                	add    %eax,%edx
    1c60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c64:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1c67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c6b:	48 8b 00             	mov    (%rax),%rax
    1c6e:	48 8b 10             	mov    (%rax),%rdx
    1c71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c75:	48 89 10             	mov    %rdx,(%rax)
    1c78:	eb 0e                	jmp    1c88 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1c7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c7e:	48 8b 10             	mov    (%rax),%rdx
    1c81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c85:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1c88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c8c:	8b 40 08             	mov    0x8(%rax),%eax
    1c8f:	89 c0                	mov    %eax,%eax
    1c91:	48 c1 e0 04          	shl    $0x4,%rax
    1c95:	48 89 c2             	mov    %rax,%rdx
    1c98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c9c:	48 01 d0             	add    %rdx,%rax
    1c9f:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1ca3:	75 27                	jne    1ccc <free+0x113>
    p->s.size += bp->s.size;
    1ca5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ca9:	8b 50 08             	mov    0x8(%rax),%edx
    1cac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cb0:	8b 40 08             	mov    0x8(%rax),%eax
    1cb3:	01 c2                	add    %eax,%edx
    1cb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb9:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1cbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc0:	48 8b 10             	mov    (%rax),%rdx
    1cc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cc7:	48 89 10             	mov    %rdx,(%rax)
    1cca:	eb 0b                	jmp    1cd7 <free+0x11e>
  } else
    p->s.ptr = bp;
    1ccc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cd0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1cd4:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1cd7:	48 ba 70 1f 00 00 00 	movabs $0x1f70,%rdx
    1cde:	00 00 00 
    1ce1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ce5:	48 89 02             	mov    %rax,(%rdx)
}
    1ce8:	90                   	nop
    1ce9:	c9                   	leave
    1cea:	c3                   	ret

0000000000001ceb <morecore>:

static Header*
morecore(uint nu)
{
    1ceb:	55                   	push   %rbp
    1cec:	48 89 e5             	mov    %rsp,%rbp
    1cef:	48 83 ec 20          	sub    $0x20,%rsp
    1cf3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1cf6:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1cfd:	77 07                	ja     1d06 <morecore+0x1b>
    nu = 4096;
    1cff:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d06:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d09:	48 c1 e0 04          	shl    $0x4,%rax
    1d0d:	48 89 c7             	mov    %rax,%rdi
    1d10:	48 b8 5d 15 00 00 00 	movabs $0x155d,%rax
    1d17:	00 00 00 
    1d1a:	ff d0                	call   *%rax
    1d1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d20:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d25:	75 07                	jne    1d2e <morecore+0x43>
    return 0;
    1d27:	b8 00 00 00 00       	mov    $0x0,%eax
    1d2c:	eb 36                	jmp    1d64 <morecore+0x79>
  hp = (Header*)p;
    1d2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d32:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d3a:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d3d:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d44:	48 83 c0 10          	add    $0x10,%rax
    1d48:	48 89 c7             	mov    %rax,%rdi
    1d4b:	48 b8 b9 1b 00 00 00 	movabs $0x1bb9,%rax
    1d52:	00 00 00 
    1d55:	ff d0                	call   *%rax
  return freep;
    1d57:	48 b8 70 1f 00 00 00 	movabs $0x1f70,%rax
    1d5e:	00 00 00 
    1d61:	48 8b 00             	mov    (%rax),%rax
}
    1d64:	c9                   	leave
    1d65:	c3                   	ret

0000000000001d66 <malloc>:

void*
malloc(uint nbytes)
{
    1d66:	55                   	push   %rbp
    1d67:	48 89 e5             	mov    %rsp,%rbp
    1d6a:	48 83 ec 30          	sub    $0x30,%rsp
    1d6e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1d71:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1d74:	48 83 c0 0f          	add    $0xf,%rax
    1d78:	48 c1 e8 04          	shr    $0x4,%rax
    1d7c:	83 c0 01             	add    $0x1,%eax
    1d7f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1d82:	48 b8 70 1f 00 00 00 	movabs $0x1f70,%rax
    1d89:	00 00 00 
    1d8c:	48 8b 00             	mov    (%rax),%rax
    1d8f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d93:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1d98:	75 4a                	jne    1de4 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1d9a:	48 b8 60 1f 00 00 00 	movabs $0x1f60,%rax
    1da1:	00 00 00 
    1da4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1da8:	48 ba 70 1f 00 00 00 	movabs $0x1f70,%rdx
    1daf:	00 00 00 
    1db2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1db6:	48 89 02             	mov    %rax,(%rdx)
    1db9:	48 b8 70 1f 00 00 00 	movabs $0x1f70,%rax
    1dc0:	00 00 00 
    1dc3:	48 8b 00             	mov    (%rax),%rax
    1dc6:	48 ba 60 1f 00 00 00 	movabs $0x1f60,%rdx
    1dcd:	00 00 00 
    1dd0:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1dd3:	48 b8 60 1f 00 00 00 	movabs $0x1f60,%rax
    1dda:	00 00 00 
    1ddd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1de4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1de8:	48 8b 00             	mov    (%rax),%rax
    1deb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1def:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1df3:	8b 40 08             	mov    0x8(%rax),%eax
    1df6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1df9:	72 65                	jb     1e60 <malloc+0xfa>
      if(p->s.size == nunits)
    1dfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dff:	8b 40 08             	mov    0x8(%rax),%eax
    1e02:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e05:	75 10                	jne    1e17 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1e07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e0b:	48 8b 10             	mov    (%rax),%rdx
    1e0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e12:	48 89 10             	mov    %rdx,(%rax)
    1e15:	eb 2e                	jmp    1e45 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1e17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e1b:	8b 40 08             	mov    0x8(%rax),%eax
    1e1e:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e21:	89 c2                	mov    %eax,%edx
    1e23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e27:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e2e:	8b 40 08             	mov    0x8(%rax),%eax
    1e31:	89 c0                	mov    %eax,%eax
    1e33:	48 c1 e0 04          	shl    $0x4,%rax
    1e37:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e3f:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e42:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1e45:	48 ba 70 1f 00 00 00 	movabs $0x1f70,%rdx
    1e4c:	00 00 00 
    1e4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e53:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1e56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e5a:	48 83 c0 10          	add    $0x10,%rax
    1e5e:	eb 4e                	jmp    1eae <malloc+0x148>
    }
    if(p == freep)
    1e60:	48 b8 70 1f 00 00 00 	movabs $0x1f70,%rax
    1e67:	00 00 00 
    1e6a:	48 8b 00             	mov    (%rax),%rax
    1e6d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1e71:	75 23                	jne    1e96 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1e73:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1e76:	89 c7                	mov    %eax,%edi
    1e78:	48 b8 eb 1c 00 00 00 	movabs $0x1ceb,%rax
    1e7f:	00 00 00 
    1e82:	ff d0                	call   *%rax
    1e84:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1e88:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1e8d:	75 07                	jne    1e96 <malloc+0x130>
        return 0;
    1e8f:	b8 00 00 00 00       	mov    $0x0,%eax
    1e94:	eb 18                	jmp    1eae <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e9a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ea2:	48 8b 00             	mov    (%rax),%rax
    1ea5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ea9:	e9 41 ff ff ff       	jmp    1def <malloc+0x89>
  }
}
    1eae:	c9                   	leave
    1eaf:	c3                   	ret

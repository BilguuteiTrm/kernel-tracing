
_forktest:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 81 ec c0 00 00 00 	sub    $0xc0,%rsp
    100b:	89 bd 4c ff ff ff    	mov    %edi,-0xb4(%rbp)
    1011:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
    1018:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    101f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1026:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    102d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1034:	84 c0                	test   %al,%al
    1036:	74 20                	je     1058 <printf+0x58>
    1038:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    103c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1040:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1044:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1048:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    104c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1050:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1054:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  write(fd, s, strlen(s));
    1058:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    105f:	48 89 c7             	mov    %rax,%rdi
    1062:	48 b8 d0 12 00 00 00 	movabs $0x12d0,%rax
    1069:	00 00 00 
    106c:	ff d0                	call   *%rax
    106e:	89 c2                	mov    %eax,%edx
    1070:	48 8b 8d 40 ff ff ff 	mov    -0xc0(%rbp),%rcx
    1077:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    107d:	48 89 ce             	mov    %rcx,%rsi
    1080:	89 c7                	mov    %eax,%edi
    1082:	48 b8 53 15 00 00 00 	movabs $0x1553,%rax
    1089:	00 00 00 
    108c:	ff d0                	call   *%rax
}
    108e:	90                   	nop
    108f:	c9                   	leave
    1090:	c3                   	ret

0000000000001091 <forktest>:

void
forktest(void)
{
    1091:	55                   	push   %rbp
    1092:	48 89 e5             	mov    %rsp,%rbp
    1095:	48 83 ec 10          	sub    $0x10,%rsp
  int n, pid;

  printf(1, "fork test\n");
    1099:	48 b8 58 16 00 00 00 	movabs $0x1658,%rax
    10a0:	00 00 00 
    10a3:	48 89 c6             	mov    %rax,%rsi
    10a6:	bf 01 00 00 00       	mov    $0x1,%edi
    10ab:	b8 00 00 00 00       	mov    $0x0,%eax
    10b0:	48 ba 00 10 00 00 00 	movabs $0x1000,%rdx
    10b7:	00 00 00 
    10ba:	ff d2                	call   *%rdx

  for(n=0; n<N; n++){
    10bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    10c3:	eb 2b                	jmp    10f0 <forktest+0x5f>
    pid = fork();
    10c5:	48 b8 12 15 00 00 00 	movabs $0x1512,%rax
    10cc:	00 00 00 
    10cf:	ff d0                	call   *%rax
    10d1:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(pid < 0)
    10d4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    10d8:	78 21                	js     10fb <forktest+0x6a>
      break;
    if(pid == 0)
    10da:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    10de:	75 0c                	jne    10ec <forktest+0x5b>
      exit();
    10e0:	48 b8 1f 15 00 00 00 	movabs $0x151f,%rax
    10e7:	00 00 00 
    10ea:	ff d0                	call   *%rax
  for(n=0; n<N; n++){
    10ec:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    10f0:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
    10f7:	7e cc                	jle    10c5 <forktest+0x34>
    10f9:	eb 01                	jmp    10fc <forktest+0x6b>
      break;
    10fb:	90                   	nop
  }

  if(n == N){
    10fc:	81 7d fc e8 03 00 00 	cmpl   $0x3e8,-0x4(%rbp)
    1103:	75 77                	jne    117c <forktest+0xeb>
    printf(1, "fork claimed to work N times!\n", N);
    1105:	48 b8 68 16 00 00 00 	movabs $0x1668,%rax
    110c:	00 00 00 
    110f:	ba e8 03 00 00       	mov    $0x3e8,%edx
    1114:	48 89 c6             	mov    %rax,%rsi
    1117:	bf 01 00 00 00       	mov    $0x1,%edi
    111c:	b8 00 00 00 00       	mov    $0x0,%eax
    1121:	48 b9 00 10 00 00 00 	movabs $0x1000,%rcx
    1128:	00 00 00 
    112b:	ff d1                	call   *%rcx
    exit();
    112d:	48 b8 1f 15 00 00 00 	movabs $0x151f,%rax
    1134:	00 00 00 
    1137:	ff d0                	call   *%rax
  }

  for(; n > 0; n--){
    if(wait() < 0){
    1139:	48 b8 2c 15 00 00 00 	movabs $0x152c,%rax
    1140:	00 00 00 
    1143:	ff d0                	call   *%rax
    1145:	85 c0                	test   %eax,%eax
    1147:	79 2f                	jns    1178 <forktest+0xe7>
      printf(1, "wait stopped early\n");
    1149:	48 b8 87 16 00 00 00 	movabs $0x1687,%rax
    1150:	00 00 00 
    1153:	48 89 c6             	mov    %rax,%rsi
    1156:	bf 01 00 00 00       	mov    $0x1,%edi
    115b:	b8 00 00 00 00       	mov    $0x0,%eax
    1160:	48 ba 00 10 00 00 00 	movabs $0x1000,%rdx
    1167:	00 00 00 
    116a:	ff d2                	call   *%rdx
      exit();
    116c:	48 b8 1f 15 00 00 00 	movabs $0x151f,%rax
    1173:	00 00 00 
    1176:	ff d0                	call   *%rax
  for(; n > 0; n--){
    1178:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
    117c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1180:	7f b7                	jg     1139 <forktest+0xa8>
    }
  }

  if(wait() != -1){
    1182:	48 b8 2c 15 00 00 00 	movabs $0x152c,%rax
    1189:	00 00 00 
    118c:	ff d0                	call   *%rax
    118e:	83 f8 ff             	cmp    $0xffffffff,%eax
    1191:	74 2f                	je     11c2 <forktest+0x131>
    printf(1, "wait got too many\n");
    1193:	48 b8 9b 16 00 00 00 	movabs $0x169b,%rax
    119a:	00 00 00 
    119d:	48 89 c6             	mov    %rax,%rsi
    11a0:	bf 01 00 00 00       	mov    $0x1,%edi
    11a5:	b8 00 00 00 00       	mov    $0x0,%eax
    11aa:	48 ba 00 10 00 00 00 	movabs $0x1000,%rdx
    11b1:	00 00 00 
    11b4:	ff d2                	call   *%rdx
    exit();
    11b6:	48 b8 1f 15 00 00 00 	movabs $0x151f,%rax
    11bd:	00 00 00 
    11c0:	ff d0                	call   *%rax
  }

  printf(1, "fork test OK\n");
    11c2:	48 b8 ae 16 00 00 00 	movabs $0x16ae,%rax
    11c9:	00 00 00 
    11cc:	48 89 c6             	mov    %rax,%rsi
    11cf:	bf 01 00 00 00       	mov    $0x1,%edi
    11d4:	b8 00 00 00 00       	mov    $0x0,%eax
    11d9:	48 ba 00 10 00 00 00 	movabs $0x1000,%rdx
    11e0:	00 00 00 
    11e3:	ff d2                	call   *%rdx
}
    11e5:	90                   	nop
    11e6:	c9                   	leave
    11e7:	c3                   	ret

00000000000011e8 <main>:

int
main(void)
{
    11e8:	55                   	push   %rbp
    11e9:	48 89 e5             	mov    %rsp,%rbp
  forktest();
    11ec:	48 b8 91 10 00 00 00 	movabs $0x1091,%rax
    11f3:	00 00 00 
    11f6:	ff d0                	call   *%rax
  exit();
    11f8:	48 b8 1f 15 00 00 00 	movabs $0x151f,%rax
    11ff:	00 00 00 
    1202:	ff d0                	call   *%rax

0000000000001204 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1204:	55                   	push   %rbp
    1205:	48 89 e5             	mov    %rsp,%rbp
    1208:	48 83 ec 10          	sub    $0x10,%rsp
    120c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1210:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1213:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1216:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    121a:	8b 55 f0             	mov    -0x10(%rbp),%edx
    121d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1220:	48 89 ce             	mov    %rcx,%rsi
    1223:	48 89 f7             	mov    %rsi,%rdi
    1226:	89 d1                	mov    %edx,%ecx
    1228:	fc                   	cld
    1229:	f3 aa                	rep stos %al,(%rdi)
    122b:	89 ca                	mov    %ecx,%edx
    122d:	48 89 fe             	mov    %rdi,%rsi
    1230:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1234:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1237:	90                   	nop
    1238:	c9                   	leave
    1239:	c3                   	ret

000000000000123a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    123a:	55                   	push   %rbp
    123b:	48 89 e5             	mov    %rsp,%rbp
    123e:	48 83 ec 20          	sub    $0x20,%rsp
    1242:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1246:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    124a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    124e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1252:	90                   	nop
    1253:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1257:	48 8d 42 01          	lea    0x1(%rdx),%rax
    125b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    125f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1263:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1267:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    126b:	0f b6 12             	movzbl (%rdx),%edx
    126e:	88 10                	mov    %dl,(%rax)
    1270:	0f b6 00             	movzbl (%rax),%eax
    1273:	84 c0                	test   %al,%al
    1275:	75 dc                	jne    1253 <strcpy+0x19>
    ;
  return os;
    1277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    127b:	c9                   	leave
    127c:	c3                   	ret

000000000000127d <strcmp>:

int
strcmp(const char *p, const char *q)
{
    127d:	55                   	push   %rbp
    127e:	48 89 e5             	mov    %rsp,%rbp
    1281:	48 83 ec 10          	sub    $0x10,%rsp
    1285:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1289:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    128d:	eb 0a                	jmp    1299 <strcmp+0x1c>
    p++, q++;
    128f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1294:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1299:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    129d:	0f b6 00             	movzbl (%rax),%eax
    12a0:	84 c0                	test   %al,%al
    12a2:	74 12                	je     12b6 <strcmp+0x39>
    12a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12a8:	0f b6 10             	movzbl (%rax),%edx
    12ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    12af:	0f b6 00             	movzbl (%rax),%eax
    12b2:	38 c2                	cmp    %al,%dl
    12b4:	74 d9                	je     128f <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    12b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12ba:	0f b6 00             	movzbl (%rax),%eax
    12bd:	0f b6 d0             	movzbl %al,%edx
    12c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    12c4:	0f b6 00             	movzbl (%rax),%eax
    12c7:	0f b6 c0             	movzbl %al,%eax
    12ca:	29 c2                	sub    %eax,%edx
    12cc:	89 d0                	mov    %edx,%eax
}
    12ce:	c9                   	leave
    12cf:	c3                   	ret

00000000000012d0 <strlen>:

uint
strlen(char *s)
{
    12d0:	55                   	push   %rbp
    12d1:	48 89 e5             	mov    %rsp,%rbp
    12d4:	48 83 ec 18          	sub    $0x18,%rsp
    12d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    12dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12e3:	eb 04                	jmp    12e9 <strlen+0x19>
    12e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    12e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12ec:	48 63 d0             	movslq %eax,%rdx
    12ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12f3:	48 01 d0             	add    %rdx,%rax
    12f6:	0f b6 00             	movzbl (%rax),%eax
    12f9:	84 c0                	test   %al,%al
    12fb:	75 e8                	jne    12e5 <strlen+0x15>
    ;
  return n;
    12fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1300:	c9                   	leave
    1301:	c3                   	ret

0000000000001302 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1302:	55                   	push   %rbp
    1303:	48 89 e5             	mov    %rsp,%rbp
    1306:	48 83 ec 10          	sub    $0x10,%rsp
    130a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    130e:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1311:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1314:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1317:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    131a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    131e:	89 ce                	mov    %ecx,%esi
    1320:	48 89 c7             	mov    %rax,%rdi
    1323:	48 b8 04 12 00 00 00 	movabs $0x1204,%rax
    132a:	00 00 00 
    132d:	ff d0                	call   *%rax
  return dst;
    132f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1333:	c9                   	leave
    1334:	c3                   	ret

0000000000001335 <strchr>:

char*
strchr(const char *s, char c)
{
    1335:	55                   	push   %rbp
    1336:	48 89 e5             	mov    %rsp,%rbp
    1339:	48 83 ec 10          	sub    $0x10,%rsp
    133d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1341:	89 f0                	mov    %esi,%eax
    1343:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1346:	eb 17                	jmp    135f <strchr+0x2a>
    if(*s == c)
    1348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    134c:	0f b6 00             	movzbl (%rax),%eax
    134f:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1352:	75 06                	jne    135a <strchr+0x25>
      return (char*)s;
    1354:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1358:	eb 15                	jmp    136f <strchr+0x3a>
  for(; *s; s++)
    135a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    135f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1363:	0f b6 00             	movzbl (%rax),%eax
    1366:	84 c0                	test   %al,%al
    1368:	75 de                	jne    1348 <strchr+0x13>
  return 0;
    136a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    136f:	c9                   	leave
    1370:	c3                   	ret

0000000000001371 <gets>:

char*
gets(char *buf, int max)
{
    1371:	55                   	push   %rbp
    1372:	48 89 e5             	mov    %rsp,%rbp
    1375:	48 83 ec 20          	sub    $0x20,%rsp
    1379:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    137d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1380:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1387:	eb 4f                	jmp    13d8 <gets+0x67>
    cc = read(0, &c, 1);
    1389:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    138d:	ba 01 00 00 00       	mov    $0x1,%edx
    1392:	48 89 c6             	mov    %rax,%rsi
    1395:	bf 00 00 00 00       	mov    $0x0,%edi
    139a:	48 b8 46 15 00 00 00 	movabs $0x1546,%rax
    13a1:	00 00 00 
    13a4:	ff d0                	call   *%rax
    13a6:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    13a9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    13ad:	7e 36                	jle    13e5 <gets+0x74>
      break;
    buf[i++] = c;
    13af:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13b2:	8d 50 01             	lea    0x1(%rax),%edx
    13b5:	89 55 fc             	mov    %edx,-0x4(%rbp)
    13b8:	48 63 d0             	movslq %eax,%rdx
    13bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13bf:	48 01 c2             	add    %rax,%rdx
    13c2:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13c6:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    13c8:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13cc:	3c 0a                	cmp    $0xa,%al
    13ce:	74 16                	je     13e6 <gets+0x75>
    13d0:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13d4:	3c 0d                	cmp    $0xd,%al
    13d6:	74 0e                	je     13e6 <gets+0x75>
  for(i=0; i+1 < max; ){
    13d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13db:	83 c0 01             	add    $0x1,%eax
    13de:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    13e1:	7f a6                	jg     1389 <gets+0x18>
    13e3:	eb 01                	jmp    13e6 <gets+0x75>
      break;
    13e5:	90                   	nop
      break;
  }
  buf[i] = '\0';
    13e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13e9:	48 63 d0             	movslq %eax,%rdx
    13ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13f0:	48 01 d0             	add    %rdx,%rax
    13f3:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    13f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13fa:	c9                   	leave
    13fb:	c3                   	ret

00000000000013fc <stat>:

int
stat(char *n, struct stat *st)
{
    13fc:	55                   	push   %rbp
    13fd:	48 89 e5             	mov    %rsp,%rbp
    1400:	48 83 ec 20          	sub    $0x20,%rsp
    1404:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1408:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    140c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1410:	be 00 00 00 00       	mov    $0x0,%esi
    1415:	48 89 c7             	mov    %rax,%rdi
    1418:	48 b8 87 15 00 00 00 	movabs $0x1587,%rax
    141f:	00 00 00 
    1422:	ff d0                	call   *%rax
    1424:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1427:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    142b:	79 07                	jns    1434 <stat+0x38>
    return -1;
    142d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1432:	eb 2f                	jmp    1463 <stat+0x67>
  r = fstat(fd, st);
    1434:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1438:	8b 45 fc             	mov    -0x4(%rbp),%eax
    143b:	48 89 d6             	mov    %rdx,%rsi
    143e:	89 c7                	mov    %eax,%edi
    1440:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    1447:	00 00 00 
    144a:	ff d0                	call   *%rax
    144c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    144f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1452:	89 c7                	mov    %eax,%edi
    1454:	48 b8 60 15 00 00 00 	movabs $0x1560,%rax
    145b:	00 00 00 
    145e:	ff d0                	call   *%rax
  return r;
    1460:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1463:	c9                   	leave
    1464:	c3                   	ret

0000000000001465 <atoi>:

int
atoi(const char *s)
{
    1465:	55                   	push   %rbp
    1466:	48 89 e5             	mov    %rsp,%rbp
    1469:	48 83 ec 18          	sub    $0x18,%rsp
    146d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1471:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1478:	eb 28                	jmp    14a2 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    147a:	8b 55 fc             	mov    -0x4(%rbp),%edx
    147d:	89 d0                	mov    %edx,%eax
    147f:	c1 e0 02             	shl    $0x2,%eax
    1482:	01 d0                	add    %edx,%eax
    1484:	01 c0                	add    %eax,%eax
    1486:	89 c1                	mov    %eax,%ecx
    1488:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    148c:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1490:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1494:	0f b6 00             	movzbl (%rax),%eax
    1497:	0f be c0             	movsbl %al,%eax
    149a:	01 c8                	add    %ecx,%eax
    149c:	83 e8 30             	sub    $0x30,%eax
    149f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    14a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14a6:	0f b6 00             	movzbl (%rax),%eax
    14a9:	3c 2f                	cmp    $0x2f,%al
    14ab:	7e 0b                	jle    14b8 <atoi+0x53>
    14ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14b1:	0f b6 00             	movzbl (%rax),%eax
    14b4:	3c 39                	cmp    $0x39,%al
    14b6:	7e c2                	jle    147a <atoi+0x15>
  return n;
    14b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    14bb:	c9                   	leave
    14bc:	c3                   	ret

00000000000014bd <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    14bd:	55                   	push   %rbp
    14be:	48 89 e5             	mov    %rsp,%rbp
    14c1:	48 83 ec 28          	sub    $0x28,%rsp
    14c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    14cd:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    14d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    14d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    14dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    14e0:	eb 1d                	jmp    14ff <memmove+0x42>
    *dst++ = *src++;
    14e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    14e6:	48 8d 42 01          	lea    0x1(%rdx),%rax
    14ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    14ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    14f2:	48 8d 48 01          	lea    0x1(%rax),%rcx
    14f6:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    14fa:	0f b6 12             	movzbl (%rdx),%edx
    14fd:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    14ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1502:	8d 50 ff             	lea    -0x1(%rax),%edx
    1505:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1508:	85 c0                	test   %eax,%eax
    150a:	7f d6                	jg     14e2 <memmove+0x25>
  return vdst;
    150c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1510:	c9                   	leave
    1511:	c3                   	ret

0000000000001512 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1512:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1519:	49 89 ca             	mov    %rcx,%r10
    151c:	0f 05                	syscall
    151e:	c3                   	ret

000000000000151f <exit>:
SYSCALL(exit)
    151f:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1526:	49 89 ca             	mov    %rcx,%r10
    1529:	0f 05                	syscall
    152b:	c3                   	ret

000000000000152c <wait>:
SYSCALL(wait)
    152c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1533:	49 89 ca             	mov    %rcx,%r10
    1536:	0f 05                	syscall
    1538:	c3                   	ret

0000000000001539 <pipe>:
SYSCALL(pipe)
    1539:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1540:	49 89 ca             	mov    %rcx,%r10
    1543:	0f 05                	syscall
    1545:	c3                   	ret

0000000000001546 <read>:
SYSCALL(read)
    1546:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    154d:	49 89 ca             	mov    %rcx,%r10
    1550:	0f 05                	syscall
    1552:	c3                   	ret

0000000000001553 <write>:
SYSCALL(write)
    1553:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    155a:	49 89 ca             	mov    %rcx,%r10
    155d:	0f 05                	syscall
    155f:	c3                   	ret

0000000000001560 <close>:
SYSCALL(close)
    1560:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1567:	49 89 ca             	mov    %rcx,%r10
    156a:	0f 05                	syscall
    156c:	c3                   	ret

000000000000156d <kill>:
SYSCALL(kill)
    156d:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1574:	49 89 ca             	mov    %rcx,%r10
    1577:	0f 05                	syscall
    1579:	c3                   	ret

000000000000157a <exec>:
SYSCALL(exec)
    157a:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1581:	49 89 ca             	mov    %rcx,%r10
    1584:	0f 05                	syscall
    1586:	c3                   	ret

0000000000001587 <open>:
SYSCALL(open)
    1587:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    158e:	49 89 ca             	mov    %rcx,%r10
    1591:	0f 05                	syscall
    1593:	c3                   	ret

0000000000001594 <mknod>:
SYSCALL(mknod)
    1594:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    159b:	49 89 ca             	mov    %rcx,%r10
    159e:	0f 05                	syscall
    15a0:	c3                   	ret

00000000000015a1 <unlink>:
SYSCALL(unlink)
    15a1:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    15a8:	49 89 ca             	mov    %rcx,%r10
    15ab:	0f 05                	syscall
    15ad:	c3                   	ret

00000000000015ae <fstat>:
SYSCALL(fstat)
    15ae:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    15b5:	49 89 ca             	mov    %rcx,%r10
    15b8:	0f 05                	syscall
    15ba:	c3                   	ret

00000000000015bb <link>:
SYSCALL(link)
    15bb:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    15c2:	49 89 ca             	mov    %rcx,%r10
    15c5:	0f 05                	syscall
    15c7:	c3                   	ret

00000000000015c8 <mkdir>:
SYSCALL(mkdir)
    15c8:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    15cf:	49 89 ca             	mov    %rcx,%r10
    15d2:	0f 05                	syscall
    15d4:	c3                   	ret

00000000000015d5 <chdir>:
SYSCALL(chdir)
    15d5:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    15dc:	49 89 ca             	mov    %rcx,%r10
    15df:	0f 05                	syscall
    15e1:	c3                   	ret

00000000000015e2 <dup>:
SYSCALL(dup)
    15e2:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    15e9:	49 89 ca             	mov    %rcx,%r10
    15ec:	0f 05                	syscall
    15ee:	c3                   	ret

00000000000015ef <getpid>:
SYSCALL(getpid)
    15ef:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    15f6:	49 89 ca             	mov    %rcx,%r10
    15f9:	0f 05                	syscall
    15fb:	c3                   	ret

00000000000015fc <sbrk>:
SYSCALL(sbrk)
    15fc:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1603:	49 89 ca             	mov    %rcx,%r10
    1606:	0f 05                	syscall
    1608:	c3                   	ret

0000000000001609 <sleep>:
SYSCALL(sleep)
    1609:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1610:	49 89 ca             	mov    %rcx,%r10
    1613:	0f 05                	syscall
    1615:	c3                   	ret

0000000000001616 <uptime>:
SYSCALL(uptime)
    1616:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    161d:	49 89 ca             	mov    %rcx,%r10
    1620:	0f 05                	syscall
    1622:	c3                   	ret

0000000000001623 <traceread>:
SYSCALL(traceread)
    1623:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    162a:	49 89 ca             	mov    %rcx,%r10
    162d:	0f 05                	syscall
    162f:	c3                   	ret

0000000000001630 <vidclear>:
SYSCALL(vidclear)
    1630:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    1637:	49 89 ca             	mov    %rcx,%r10
    163a:	0f 05                	syscall
    163c:	c3                   	ret

000000000000163d <vidputc>:
SYSCALL(vidputc)
    163d:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    1644:	49 89 ca             	mov    %rcx,%r10
    1647:	0f 05                	syscall
    1649:	c3                   	ret

000000000000164a <vidputs>:
SYSCALL(vidputs)
    164a:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    1651:	49 89 ca             	mov    %rcx,%r10
    1654:	0f 05                	syscall
    1656:	c3                   	ret

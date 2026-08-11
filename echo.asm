
_echo:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 20          	sub    $0x20,%rsp
    1008:	89 7d ec             	mov    %edi,-0x14(%rbp)
    100b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  for(i = 1; i < argc; i++)
    100f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    1016:	eb 61                	jmp    1079 <main+0x79>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
    1018:	8b 45 fc             	mov    -0x4(%rbp),%eax
    101b:	83 c0 01             	add    $0x1,%eax
    101e:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1021:	7e 0c                	jle    102f <main+0x2f>
    1023:	48 b8 d8 1d 00 00 00 	movabs $0x1dd8,%rax
    102a:	00 00 00 
    102d:	eb 0a                	jmp    1039 <main+0x39>
    102f:	48 b8 da 1d 00 00 00 	movabs $0x1dda,%rax
    1036:	00 00 00 
    1039:	8b 55 fc             	mov    -0x4(%rbp),%edx
    103c:	48 63 d2             	movslq %edx,%rdx
    103f:	48 8d 0c d5 00 00 00 	lea    0x0(,%rdx,8),%rcx
    1046:	00 
    1047:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    104b:	48 01 ca             	add    %rcx,%rdx
    104e:	48 8b 12             	mov    (%rdx),%rdx
    1051:	48 be dc 1d 00 00 00 	movabs $0x1ddc,%rsi
    1058:	00 00 00 
    105b:	48 89 c1             	mov    %rax,%rcx
    105e:	bf 01 00 00 00       	mov    $0x1,%edi
    1063:	b8 00 00 00 00       	mov    $0x0,%eax
    1068:	49 b8 b6 16 00 00 00 	movabs $0x16b6,%r8
    106f:	00 00 00 
    1072:	41 ff d0             	call   *%r8
  for(i = 1; i < argc; i++)
    1075:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1079:	8b 45 fc             	mov    -0x4(%rbp),%eax
    107c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    107f:	7c 97                	jl     1018 <main+0x18>
  exit();
    1081:	48 b8 a8 13 00 00 00 	movabs $0x13a8,%rax
    1088:	00 00 00 
    108b:	ff d0                	call   *%rax

000000000000108d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    108d:	55                   	push   %rbp
    108e:	48 89 e5             	mov    %rsp,%rbp
    1091:	48 83 ec 10          	sub    $0x10,%rsp
    1095:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1099:	89 75 f4             	mov    %esi,-0xc(%rbp)
    109c:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    109f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10a3:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10a9:	48 89 ce             	mov    %rcx,%rsi
    10ac:	48 89 f7             	mov    %rsi,%rdi
    10af:	89 d1                	mov    %edx,%ecx
    10b1:	fc                   	cld
    10b2:	f3 aa                	rep stos %al,(%rdi)
    10b4:	89 ca                	mov    %ecx,%edx
    10b6:	48 89 fe             	mov    %rdi,%rsi
    10b9:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10bd:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10c0:	90                   	nop
    10c1:	c9                   	leave
    10c2:	c3                   	ret

00000000000010c3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10c3:	55                   	push   %rbp
    10c4:	48 89 e5             	mov    %rsp,%rbp
    10c7:	48 83 ec 20          	sub    $0x20,%rsp
    10cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    10cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    10d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    10db:	90                   	nop
    10dc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    10e0:	48 8d 42 01          	lea    0x1(%rdx),%rax
    10e4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10ec:	48 8d 48 01          	lea    0x1(%rax),%rcx
    10f0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    10f4:	0f b6 12             	movzbl (%rdx),%edx
    10f7:	88 10                	mov    %dl,(%rax)
    10f9:	0f b6 00             	movzbl (%rax),%eax
    10fc:	84 c0                	test   %al,%al
    10fe:	75 dc                	jne    10dc <strcpy+0x19>
    ;
  return os;
    1100:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1104:	c9                   	leave
    1105:	c3                   	ret

0000000000001106 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1106:	55                   	push   %rbp
    1107:	48 89 e5             	mov    %rsp,%rbp
    110a:	48 83 ec 10          	sub    $0x10,%rsp
    110e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1112:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1116:	eb 0a                	jmp    1122 <strcmp+0x1c>
    p++, q++;
    1118:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    111d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1122:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1126:	0f b6 00             	movzbl (%rax),%eax
    1129:	84 c0                	test   %al,%al
    112b:	74 12                	je     113f <strcmp+0x39>
    112d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1131:	0f b6 10             	movzbl (%rax),%edx
    1134:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1138:	0f b6 00             	movzbl (%rax),%eax
    113b:	38 c2                	cmp    %al,%dl
    113d:	74 d9                	je     1118 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    113f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1143:	0f b6 00             	movzbl (%rax),%eax
    1146:	0f b6 d0             	movzbl %al,%edx
    1149:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    114d:	0f b6 00             	movzbl (%rax),%eax
    1150:	0f b6 c0             	movzbl %al,%eax
    1153:	29 c2                	sub    %eax,%edx
    1155:	89 d0                	mov    %edx,%eax
}
    1157:	c9                   	leave
    1158:	c3                   	ret

0000000000001159 <strlen>:

uint
strlen(char *s)
{
    1159:	55                   	push   %rbp
    115a:	48 89 e5             	mov    %rsp,%rbp
    115d:	48 83 ec 18          	sub    $0x18,%rsp
    1161:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1165:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    116c:	eb 04                	jmp    1172 <strlen+0x19>
    116e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1172:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1175:	48 63 d0             	movslq %eax,%rdx
    1178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    117c:	48 01 d0             	add    %rdx,%rax
    117f:	0f b6 00             	movzbl (%rax),%eax
    1182:	84 c0                	test   %al,%al
    1184:	75 e8                	jne    116e <strlen+0x15>
    ;
  return n;
    1186:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1189:	c9                   	leave
    118a:	c3                   	ret

000000000000118b <memset>:

void*
memset(void *dst, int c, uint n)
{
    118b:	55                   	push   %rbp
    118c:	48 89 e5             	mov    %rsp,%rbp
    118f:	48 83 ec 10          	sub    $0x10,%rsp
    1193:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1197:	89 75 f4             	mov    %esi,-0xc(%rbp)
    119a:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    119d:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11a0:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11a7:	89 ce                	mov    %ecx,%esi
    11a9:	48 89 c7             	mov    %rax,%rdi
    11ac:	48 b8 8d 10 00 00 00 	movabs $0x108d,%rax
    11b3:	00 00 00 
    11b6:	ff d0                	call   *%rax
  return dst;
    11b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11bc:	c9                   	leave
    11bd:	c3                   	ret

00000000000011be <strchr>:

char*
strchr(const char *s, char c)
{
    11be:	55                   	push   %rbp
    11bf:	48 89 e5             	mov    %rsp,%rbp
    11c2:	48 83 ec 10          	sub    $0x10,%rsp
    11c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ca:	89 f0                	mov    %esi,%eax
    11cc:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    11cf:	eb 17                	jmp    11e8 <strchr+0x2a>
    if(*s == c)
    11d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11d5:	0f b6 00             	movzbl (%rax),%eax
    11d8:	38 45 f4             	cmp    %al,-0xc(%rbp)
    11db:	75 06                	jne    11e3 <strchr+0x25>
      return (char*)s;
    11dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11e1:	eb 15                	jmp    11f8 <strchr+0x3a>
  for(; *s; s++)
    11e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    11e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11ec:	0f b6 00             	movzbl (%rax),%eax
    11ef:	84 c0                	test   %al,%al
    11f1:	75 de                	jne    11d1 <strchr+0x13>
  return 0;
    11f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11f8:	c9                   	leave
    11f9:	c3                   	ret

00000000000011fa <gets>:

char*
gets(char *buf, int max)
{
    11fa:	55                   	push   %rbp
    11fb:	48 89 e5             	mov    %rsp,%rbp
    11fe:	48 83 ec 20          	sub    $0x20,%rsp
    1202:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1206:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1209:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1210:	eb 4f                	jmp    1261 <gets+0x67>
    cc = read(0, &c, 1);
    1212:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1216:	ba 01 00 00 00       	mov    $0x1,%edx
    121b:	48 89 c6             	mov    %rax,%rsi
    121e:	bf 00 00 00 00       	mov    $0x0,%edi
    1223:	48 b8 cf 13 00 00 00 	movabs $0x13cf,%rax
    122a:	00 00 00 
    122d:	ff d0                	call   *%rax
    122f:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1232:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1236:	7e 36                	jle    126e <gets+0x74>
      break;
    buf[i++] = c;
    1238:	8b 45 fc             	mov    -0x4(%rbp),%eax
    123b:	8d 50 01             	lea    0x1(%rax),%edx
    123e:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1241:	48 63 d0             	movslq %eax,%rdx
    1244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1248:	48 01 c2             	add    %rax,%rdx
    124b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    124f:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1251:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1255:	3c 0a                	cmp    $0xa,%al
    1257:	74 16                	je     126f <gets+0x75>
    1259:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    125d:	3c 0d                	cmp    $0xd,%al
    125f:	74 0e                	je     126f <gets+0x75>
  for(i=0; i+1 < max; ){
    1261:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1264:	83 c0 01             	add    $0x1,%eax
    1267:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    126a:	7f a6                	jg     1212 <gets+0x18>
    126c:	eb 01                	jmp    126f <gets+0x75>
      break;
    126e:	90                   	nop
      break;
  }
  buf[i] = '\0';
    126f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1272:	48 63 d0             	movslq %eax,%rdx
    1275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1279:	48 01 d0             	add    %rdx,%rax
    127c:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    127f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1283:	c9                   	leave
    1284:	c3                   	ret

0000000000001285 <stat>:

int
stat(char *n, struct stat *st)
{
    1285:	55                   	push   %rbp
    1286:	48 89 e5             	mov    %rsp,%rbp
    1289:	48 83 ec 20          	sub    $0x20,%rsp
    128d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1291:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1295:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1299:	be 00 00 00 00       	mov    $0x0,%esi
    129e:	48 89 c7             	mov    %rax,%rdi
    12a1:	48 b8 10 14 00 00 00 	movabs $0x1410,%rax
    12a8:	00 00 00 
    12ab:	ff d0                	call   *%rax
    12ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    12b4:	79 07                	jns    12bd <stat+0x38>
    return -1;
    12b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12bb:	eb 2f                	jmp    12ec <stat+0x67>
  r = fstat(fd, st);
    12bd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12c4:	48 89 d6             	mov    %rdx,%rsi
    12c7:	89 c7                	mov    %eax,%edi
    12c9:	48 b8 37 14 00 00 00 	movabs $0x1437,%rax
    12d0:	00 00 00 
    12d3:	ff d0                	call   *%rax
    12d5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    12d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12db:	89 c7                	mov    %eax,%edi
    12dd:	48 b8 e9 13 00 00 00 	movabs $0x13e9,%rax
    12e4:	00 00 00 
    12e7:	ff d0                	call   *%rax
  return r;
    12e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    12ec:	c9                   	leave
    12ed:	c3                   	ret

00000000000012ee <atoi>:

int
atoi(const char *s)
{
    12ee:	55                   	push   %rbp
    12ef:	48 89 e5             	mov    %rsp,%rbp
    12f2:	48 83 ec 18          	sub    $0x18,%rsp
    12f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    12fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1301:	eb 28                	jmp    132b <atoi+0x3d>
    n = n*10 + *s++ - '0';
    1303:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1306:	89 d0                	mov    %edx,%eax
    1308:	c1 e0 02             	shl    $0x2,%eax
    130b:	01 d0                	add    %edx,%eax
    130d:	01 c0                	add    %eax,%eax
    130f:	89 c1                	mov    %eax,%ecx
    1311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1315:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1319:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    131d:	0f b6 00             	movzbl (%rax),%eax
    1320:	0f be c0             	movsbl %al,%eax
    1323:	01 c8                	add    %ecx,%eax
    1325:	83 e8 30             	sub    $0x30,%eax
    1328:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    132b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    132f:	0f b6 00             	movzbl (%rax),%eax
    1332:	3c 2f                	cmp    $0x2f,%al
    1334:	7e 0b                	jle    1341 <atoi+0x53>
    1336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    133a:	0f b6 00             	movzbl (%rax),%eax
    133d:	3c 39                	cmp    $0x39,%al
    133f:	7e c2                	jle    1303 <atoi+0x15>
  return n;
    1341:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1344:	c9                   	leave
    1345:	c3                   	ret

0000000000001346 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1346:	55                   	push   %rbp
    1347:	48 89 e5             	mov    %rsp,%rbp
    134a:	48 83 ec 28          	sub    $0x28,%rsp
    134e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1352:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1356:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    135d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1365:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1369:	eb 1d                	jmp    1388 <memmove+0x42>
    *dst++ = *src++;
    136b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    136f:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1373:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    137b:	48 8d 48 01          	lea    0x1(%rax),%rcx
    137f:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1383:	0f b6 12             	movzbl (%rdx),%edx
    1386:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1388:	8b 45 dc             	mov    -0x24(%rbp),%eax
    138b:	8d 50 ff             	lea    -0x1(%rax),%edx
    138e:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1391:	85 c0                	test   %eax,%eax
    1393:	7f d6                	jg     136b <memmove+0x25>
  return vdst;
    1395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1399:	c9                   	leave
    139a:	c3                   	ret

000000000000139b <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    139b:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13a2:	49 89 ca             	mov    %rcx,%r10
    13a5:	0f 05                	syscall
    13a7:	c3                   	ret

00000000000013a8 <exit>:
SYSCALL(exit)
    13a8:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    13af:	49 89 ca             	mov    %rcx,%r10
    13b2:	0f 05                	syscall
    13b4:	c3                   	ret

00000000000013b5 <wait>:
SYSCALL(wait)
    13b5:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    13bc:	49 89 ca             	mov    %rcx,%r10
    13bf:	0f 05                	syscall
    13c1:	c3                   	ret

00000000000013c2 <pipe>:
SYSCALL(pipe)
    13c2:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    13c9:	49 89 ca             	mov    %rcx,%r10
    13cc:	0f 05                	syscall
    13ce:	c3                   	ret

00000000000013cf <read>:
SYSCALL(read)
    13cf:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    13d6:	49 89 ca             	mov    %rcx,%r10
    13d9:	0f 05                	syscall
    13db:	c3                   	ret

00000000000013dc <write>:
SYSCALL(write)
    13dc:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    13e3:	49 89 ca             	mov    %rcx,%r10
    13e6:	0f 05                	syscall
    13e8:	c3                   	ret

00000000000013e9 <close>:
SYSCALL(close)
    13e9:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    13f0:	49 89 ca             	mov    %rcx,%r10
    13f3:	0f 05                	syscall
    13f5:	c3                   	ret

00000000000013f6 <kill>:
SYSCALL(kill)
    13f6:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    13fd:	49 89 ca             	mov    %rcx,%r10
    1400:	0f 05                	syscall
    1402:	c3                   	ret

0000000000001403 <exec>:
SYSCALL(exec)
    1403:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    140a:	49 89 ca             	mov    %rcx,%r10
    140d:	0f 05                	syscall
    140f:	c3                   	ret

0000000000001410 <open>:
SYSCALL(open)
    1410:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1417:	49 89 ca             	mov    %rcx,%r10
    141a:	0f 05                	syscall
    141c:	c3                   	ret

000000000000141d <mknod>:
SYSCALL(mknod)
    141d:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1424:	49 89 ca             	mov    %rcx,%r10
    1427:	0f 05                	syscall
    1429:	c3                   	ret

000000000000142a <unlink>:
SYSCALL(unlink)
    142a:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1431:	49 89 ca             	mov    %rcx,%r10
    1434:	0f 05                	syscall
    1436:	c3                   	ret

0000000000001437 <fstat>:
SYSCALL(fstat)
    1437:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    143e:	49 89 ca             	mov    %rcx,%r10
    1441:	0f 05                	syscall
    1443:	c3                   	ret

0000000000001444 <link>:
SYSCALL(link)
    1444:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    144b:	49 89 ca             	mov    %rcx,%r10
    144e:	0f 05                	syscall
    1450:	c3                   	ret

0000000000001451 <mkdir>:
SYSCALL(mkdir)
    1451:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1458:	49 89 ca             	mov    %rcx,%r10
    145b:	0f 05                	syscall
    145d:	c3                   	ret

000000000000145e <chdir>:
SYSCALL(chdir)
    145e:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1465:	49 89 ca             	mov    %rcx,%r10
    1468:	0f 05                	syscall
    146a:	c3                   	ret

000000000000146b <dup>:
SYSCALL(dup)
    146b:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1472:	49 89 ca             	mov    %rcx,%r10
    1475:	0f 05                	syscall
    1477:	c3                   	ret

0000000000001478 <getpid>:
SYSCALL(getpid)
    1478:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    147f:	49 89 ca             	mov    %rcx,%r10
    1482:	0f 05                	syscall
    1484:	c3                   	ret

0000000000001485 <sbrk>:
SYSCALL(sbrk)
    1485:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    148c:	49 89 ca             	mov    %rcx,%r10
    148f:	0f 05                	syscall
    1491:	c3                   	ret

0000000000001492 <sleep>:
SYSCALL(sleep)
    1492:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1499:	49 89 ca             	mov    %rcx,%r10
    149c:	0f 05                	syscall
    149e:	c3                   	ret

000000000000149f <uptime>:
SYSCALL(uptime)
    149f:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14a6:	49 89 ca             	mov    %rcx,%r10
    14a9:	0f 05                	syscall
    14ab:	c3                   	ret

00000000000014ac <traceread>:
SYSCALL(traceread)
    14ac:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    14b3:	49 89 ca             	mov    %rcx,%r10
    14b6:	0f 05                	syscall
    14b8:	c3                   	ret

00000000000014b9 <vidclear>:
SYSCALL(vidclear)
    14b9:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    14c0:	49 89 ca             	mov    %rcx,%r10
    14c3:	0f 05                	syscall
    14c5:	c3                   	ret

00000000000014c6 <vidputc>:
SYSCALL(vidputc)
    14c6:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    14cd:	49 89 ca             	mov    %rcx,%r10
    14d0:	0f 05                	syscall
    14d2:	c3                   	ret

00000000000014d3 <vidputs>:
SYSCALL(vidputs)
    14d3:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    14da:	49 89 ca             	mov    %rcx,%r10
    14dd:	0f 05                	syscall
    14df:	c3                   	ret

00000000000014e0 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    14e0:	55                   	push   %rbp
    14e1:	48 89 e5             	mov    %rsp,%rbp
    14e4:	48 83 ec 10          	sub    $0x10,%rsp
    14e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
    14eb:	89 f0                	mov    %esi,%eax
    14ed:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    14f0:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    14f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14f7:	ba 01 00 00 00       	mov    $0x1,%edx
    14fc:	48 89 ce             	mov    %rcx,%rsi
    14ff:	89 c7                	mov    %eax,%edi
    1501:	48 b8 dc 13 00 00 00 	movabs $0x13dc,%rax
    1508:	00 00 00 
    150b:	ff d0                	call   *%rax
}
    150d:	90                   	nop
    150e:	c9                   	leave
    150f:	c3                   	ret

0000000000001510 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1510:	55                   	push   %rbp
    1511:	48 89 e5             	mov    %rsp,%rbp
    1514:	48 83 ec 20          	sub    $0x20,%rsp
    1518:	89 7d ec             	mov    %edi,-0x14(%rbp)
    151b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    151f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1526:	eb 35                	jmp    155d <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1528:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    152c:	48 c1 e8 3c          	shr    $0x3c,%rax
    1530:	48 ba f0 1d 00 00 00 	movabs $0x1df0,%rdx
    1537:	00 00 00 
    153a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    153e:	0f be d0             	movsbl %al,%edx
    1541:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1544:	89 d6                	mov    %edx,%esi
    1546:	89 c7                	mov    %eax,%edi
    1548:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    154f:	00 00 00 
    1552:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1554:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1558:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    155d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1560:	83 f8 0f             	cmp    $0xf,%eax
    1563:	76 c3                	jbe    1528 <print_x64+0x18>
}
    1565:	90                   	nop
    1566:	90                   	nop
    1567:	c9                   	leave
    1568:	c3                   	ret

0000000000001569 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1569:	55                   	push   %rbp
    156a:	48 89 e5             	mov    %rsp,%rbp
    156d:	48 83 ec 20          	sub    $0x20,%rsp
    1571:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1574:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1577:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    157e:	eb 36                	jmp    15b6 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1580:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1583:	c1 e8 1c             	shr    $0x1c,%eax
    1586:	89 c2                	mov    %eax,%edx
    1588:	48 b8 f0 1d 00 00 00 	movabs $0x1df0,%rax
    158f:	00 00 00 
    1592:	89 d2                	mov    %edx,%edx
    1594:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1598:	0f be d0             	movsbl %al,%edx
    159b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    159e:	89 d6                	mov    %edx,%esi
    15a0:	89 c7                	mov    %eax,%edi
    15a2:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    15a9:	00 00 00 
    15ac:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15b2:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15b9:	83 f8 07             	cmp    $0x7,%eax
    15bc:	76 c2                	jbe    1580 <print_x32+0x17>
}
    15be:	90                   	nop
    15bf:	90                   	nop
    15c0:	c9                   	leave
    15c1:	c3                   	ret

00000000000015c2 <print_d>:

  static void
print_d(int fd, int v)
{
    15c2:	55                   	push   %rbp
    15c3:	48 89 e5             	mov    %rsp,%rbp
    15c6:	48 83 ec 30          	sub    $0x30,%rsp
    15ca:	89 7d dc             	mov    %edi,-0x24(%rbp)
    15cd:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    15d0:	8b 45 d8             	mov    -0x28(%rbp),%eax
    15d3:	48 98                	cltq
    15d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    15d9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    15dd:	79 04                	jns    15e3 <print_d+0x21>
    x = -x;
    15df:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    15e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    15ea:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    15ee:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    15f5:	66 66 66 
    15f8:	48 89 c8             	mov    %rcx,%rax
    15fb:	48 f7 ea             	imul   %rdx
    15fe:	48 c1 fa 02          	sar    $0x2,%rdx
    1602:	48 89 c8             	mov    %rcx,%rax
    1605:	48 c1 f8 3f          	sar    $0x3f,%rax
    1609:	48 29 c2             	sub    %rax,%rdx
    160c:	48 89 d0             	mov    %rdx,%rax
    160f:	48 c1 e0 02          	shl    $0x2,%rax
    1613:	48 01 d0             	add    %rdx,%rax
    1616:	48 01 c0             	add    %rax,%rax
    1619:	48 29 c1             	sub    %rax,%rcx
    161c:	48 89 ca             	mov    %rcx,%rdx
    161f:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1622:	8d 48 01             	lea    0x1(%rax),%ecx
    1625:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1628:	48 b9 f0 1d 00 00 00 	movabs $0x1df0,%rcx
    162f:	00 00 00 
    1632:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1636:	48 98                	cltq
    1638:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    163c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1640:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1647:	66 66 66 
    164a:	48 89 c8             	mov    %rcx,%rax
    164d:	48 f7 ea             	imul   %rdx
    1650:	48 89 d0             	mov    %rdx,%rax
    1653:	48 c1 f8 02          	sar    $0x2,%rax
    1657:	48 c1 f9 3f          	sar    $0x3f,%rcx
    165b:	48 89 ca             	mov    %rcx,%rdx
    165e:	48 29 d0             	sub    %rdx,%rax
    1661:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1665:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    166a:	0f 85 7a ff ff ff    	jne    15ea <print_d+0x28>

  if (v < 0)
    1670:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1674:	79 32                	jns    16a8 <print_d+0xe6>
    buf[i++] = '-';
    1676:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1679:	8d 50 01             	lea    0x1(%rax),%edx
    167c:	89 55 f4             	mov    %edx,-0xc(%rbp)
    167f:	48 98                	cltq
    1681:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1686:	eb 20                	jmp    16a8 <print_d+0xe6>
    putc(fd, buf[i]);
    1688:	8b 45 f4             	mov    -0xc(%rbp),%eax
    168b:	48 98                	cltq
    168d:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1692:	0f be d0             	movsbl %al,%edx
    1695:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1698:	89 d6                	mov    %edx,%esi
    169a:	89 c7                	mov    %eax,%edi
    169c:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    16a3:	00 00 00 
    16a6:	ff d0                	call   *%rax
  while (--i >= 0)
    16a8:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16b0:	79 d6                	jns    1688 <print_d+0xc6>
}
    16b2:	90                   	nop
    16b3:	90                   	nop
    16b4:	c9                   	leave
    16b5:	c3                   	ret

00000000000016b6 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16b6:	55                   	push   %rbp
    16b7:	48 89 e5             	mov    %rsp,%rbp
    16ba:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    16c1:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    16c7:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    16ce:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    16d5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    16dc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    16e3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    16ea:	84 c0                	test   %al,%al
    16ec:	74 20                	je     170e <printf+0x58>
    16ee:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    16f2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    16f6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    16fa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    16fe:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1702:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1706:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    170a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    170e:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1715:	00 00 00 
    1718:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    171f:	00 00 00 
    1722:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1726:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    172d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1734:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    173b:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1742:	00 00 00 
    1745:	e9 60 03 00 00       	jmp    1aaa <printf+0x3f4>
    if (c != '%') {
    174a:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1751:	74 24                	je     1777 <printf+0xc1>
      putc(fd, c);
    1753:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1759:	0f be d0             	movsbl %al,%edx
    175c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1762:	89 d6                	mov    %edx,%esi
    1764:	89 c7                	mov    %eax,%edi
    1766:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    176d:	00 00 00 
    1770:	ff d0                	call   *%rax
      continue;
    1772:	e9 2c 03 00 00       	jmp    1aa3 <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    1777:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    177e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1784:	48 63 d0             	movslq %eax,%rdx
    1787:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    178e:	48 01 d0             	add    %rdx,%rax
    1791:	0f b6 00             	movzbl (%rax),%eax
    1794:	0f be c0             	movsbl %al,%eax
    1797:	25 ff 00 00 00       	and    $0xff,%eax
    179c:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17a2:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17a9:	0f 84 2e 03 00 00    	je     1add <printf+0x427>
      break;
    switch(c) {
    17af:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17b6:	0f 84 32 01 00 00    	je     18ee <printf+0x238>
    17bc:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17c3:	0f 8f a1 02 00 00    	jg     1a6a <printf+0x3b4>
    17c9:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    17d0:	0f 84 d4 01 00 00    	je     19aa <printf+0x2f4>
    17d6:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    17dd:	0f 8f 87 02 00 00    	jg     1a6a <printf+0x3b4>
    17e3:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    17ea:	0f 84 5b 01 00 00    	je     194b <printf+0x295>
    17f0:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    17f7:	0f 8f 6d 02 00 00    	jg     1a6a <printf+0x3b4>
    17fd:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1804:	0f 84 87 00 00 00    	je     1891 <printf+0x1db>
    180a:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1811:	0f 8f 53 02 00 00    	jg     1a6a <printf+0x3b4>
    1817:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    181e:	0f 84 2b 02 00 00    	je     1a4f <printf+0x399>
    1824:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    182b:	0f 85 39 02 00 00    	jne    1a6a <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    1831:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1837:	83 f8 2f             	cmp    $0x2f,%eax
    183a:	77 23                	ja     185f <printf+0x1a9>
    183c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1843:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1849:	89 d2                	mov    %edx,%edx
    184b:	48 01 d0             	add    %rdx,%rax
    184e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1854:	83 c2 08             	add    $0x8,%edx
    1857:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    185d:	eb 12                	jmp    1871 <printf+0x1bb>
    185f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1866:	48 8d 50 08          	lea    0x8(%rax),%rdx
    186a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1871:	8b 00                	mov    (%rax),%eax
    1873:	0f be d0             	movsbl %al,%edx
    1876:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    187c:	89 d6                	mov    %edx,%esi
    187e:	89 c7                	mov    %eax,%edi
    1880:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    1887:	00 00 00 
    188a:	ff d0                	call   *%rax
      break;
    188c:	e9 12 02 00 00       	jmp    1aa3 <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1891:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1897:	83 f8 2f             	cmp    $0x2f,%eax
    189a:	77 23                	ja     18bf <printf+0x209>
    189c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18a3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18a9:	89 d2                	mov    %edx,%edx
    18ab:	48 01 d0             	add    %rdx,%rax
    18ae:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18b4:	83 c2 08             	add    $0x8,%edx
    18b7:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18bd:	eb 12                	jmp    18d1 <printf+0x21b>
    18bf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18c6:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18ca:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18d1:	8b 10                	mov    (%rax),%edx
    18d3:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18d9:	89 d6                	mov    %edx,%esi
    18db:	89 c7                	mov    %eax,%edi
    18dd:	48 b8 c2 15 00 00 00 	movabs $0x15c2,%rax
    18e4:	00 00 00 
    18e7:	ff d0                	call   *%rax
      break;
    18e9:	e9 b5 01 00 00       	jmp    1aa3 <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    18ee:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18f4:	83 f8 2f             	cmp    $0x2f,%eax
    18f7:	77 23                	ja     191c <printf+0x266>
    18f9:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1900:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1906:	89 d2                	mov    %edx,%edx
    1908:	48 01 d0             	add    %rdx,%rax
    190b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1911:	83 c2 08             	add    $0x8,%edx
    1914:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    191a:	eb 12                	jmp    192e <printf+0x278>
    191c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1923:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1927:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    192e:	8b 10                	mov    (%rax),%edx
    1930:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1936:	89 d6                	mov    %edx,%esi
    1938:	89 c7                	mov    %eax,%edi
    193a:	48 b8 69 15 00 00 00 	movabs $0x1569,%rax
    1941:	00 00 00 
    1944:	ff d0                	call   *%rax
      break;
    1946:	e9 58 01 00 00       	jmp    1aa3 <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    194b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1951:	83 f8 2f             	cmp    $0x2f,%eax
    1954:	77 23                	ja     1979 <printf+0x2c3>
    1956:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    195d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1963:	89 d2                	mov    %edx,%edx
    1965:	48 01 d0             	add    %rdx,%rax
    1968:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    196e:	83 c2 08             	add    $0x8,%edx
    1971:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1977:	eb 12                	jmp    198b <printf+0x2d5>
    1979:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1980:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1984:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    198b:	48 8b 10             	mov    (%rax),%rdx
    198e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1994:	48 89 d6             	mov    %rdx,%rsi
    1997:	89 c7                	mov    %eax,%edi
    1999:	48 b8 10 15 00 00 00 	movabs $0x1510,%rax
    19a0:	00 00 00 
    19a3:	ff d0                	call   *%rax
      break;
    19a5:	e9 f9 00 00 00       	jmp    1aa3 <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19aa:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19b0:	83 f8 2f             	cmp    $0x2f,%eax
    19b3:	77 23                	ja     19d8 <printf+0x322>
    19b5:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19bc:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19c2:	89 d2                	mov    %edx,%edx
    19c4:	48 01 d0             	add    %rdx,%rax
    19c7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19cd:	83 c2 08             	add    $0x8,%edx
    19d0:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19d6:	eb 12                	jmp    19ea <printf+0x334>
    19d8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19df:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19e3:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19ea:	48 8b 00             	mov    (%rax),%rax
    19ed:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    19f4:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    19fb:	00 
    19fc:	75 41                	jne    1a3f <printf+0x389>
        s = "(null)";
    19fe:	48 b8 e1 1d 00 00 00 	movabs $0x1de1,%rax
    1a05:	00 00 00 
    1a08:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a0f:	eb 2e                	jmp    1a3f <printf+0x389>
        putc(fd, *(s++));
    1a11:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a18:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a1c:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a23:	0f b6 00             	movzbl (%rax),%eax
    1a26:	0f be d0             	movsbl %al,%edx
    1a29:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a2f:	89 d6                	mov    %edx,%esi
    1a31:	89 c7                	mov    %eax,%edi
    1a33:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    1a3a:	00 00 00 
    1a3d:	ff d0                	call   *%rax
      while (*s)
    1a3f:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a46:	0f b6 00             	movzbl (%rax),%eax
    1a49:	84 c0                	test   %al,%al
    1a4b:	75 c4                	jne    1a11 <printf+0x35b>
      break;
    1a4d:	eb 54                	jmp    1aa3 <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1a4f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a55:	be 25 00 00 00       	mov    $0x25,%esi
    1a5a:	89 c7                	mov    %eax,%edi
    1a5c:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    1a63:	00 00 00 
    1a66:	ff d0                	call   *%rax
      break;
    1a68:	eb 39                	jmp    1aa3 <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a6a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a70:	be 25 00 00 00       	mov    $0x25,%esi
    1a75:	89 c7                	mov    %eax,%edi
    1a77:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    1a7e:	00 00 00 
    1a81:	ff d0                	call   *%rax
      putc(fd, c);
    1a83:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a89:	0f be d0             	movsbl %al,%edx
    1a8c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a92:	89 d6                	mov    %edx,%esi
    1a94:	89 c7                	mov    %eax,%edi
    1a96:	48 b8 e0 14 00 00 00 	movabs $0x14e0,%rax
    1a9d:	00 00 00 
    1aa0:	ff d0                	call   *%rax
      break;
    1aa2:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1aa3:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1aaa:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ab0:	48 63 d0             	movslq %eax,%rdx
    1ab3:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1aba:	48 01 d0             	add    %rdx,%rax
    1abd:	0f b6 00             	movzbl (%rax),%eax
    1ac0:	0f be c0             	movsbl %al,%eax
    1ac3:	25 ff 00 00 00       	and    $0xff,%eax
    1ac8:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ace:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1ad5:	0f 85 6f fc ff ff    	jne    174a <printf+0x94>
    }
  }
}
    1adb:	eb 01                	jmp    1ade <printf+0x428>
      break;
    1add:	90                   	nop
}
    1ade:	90                   	nop
    1adf:	c9                   	leave
    1ae0:	c3                   	ret

0000000000001ae1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1ae1:	55                   	push   %rbp
    1ae2:	48 89 e5             	mov    %rsp,%rbp
    1ae5:	48 83 ec 18          	sub    $0x18,%rsp
    1ae9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1aed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1af1:	48 83 e8 10          	sub    $0x10,%rax
    1af5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1af9:	48 b8 20 1e 00 00 00 	movabs $0x1e20,%rax
    1b00:	00 00 00 
    1b03:	48 8b 00             	mov    (%rax),%rax
    1b06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b0a:	eb 2f                	jmp    1b3b <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b10:	48 8b 00             	mov    (%rax),%rax
    1b13:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b17:	72 17                	jb     1b30 <free+0x4f>
    1b19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b1d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b21:	72 2f                	jb     1b52 <free+0x71>
    1b23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b27:	48 8b 00             	mov    (%rax),%rax
    1b2a:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b2e:	72 22                	jb     1b52 <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b34:	48 8b 00             	mov    (%rax),%rax
    1b37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b3f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b43:	73 c7                	jae    1b0c <free+0x2b>
    1b45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b49:	48 8b 00             	mov    (%rax),%rax
    1b4c:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b50:	73 ba                	jae    1b0c <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b56:	8b 40 08             	mov    0x8(%rax),%eax
    1b59:	89 c0                	mov    %eax,%eax
    1b5b:	48 c1 e0 04          	shl    $0x4,%rax
    1b5f:	48 89 c2             	mov    %rax,%rdx
    1b62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b66:	48 01 c2             	add    %rax,%rdx
    1b69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b6d:	48 8b 00             	mov    (%rax),%rax
    1b70:	48 39 c2             	cmp    %rax,%rdx
    1b73:	75 2d                	jne    1ba2 <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1b75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b79:	8b 50 08             	mov    0x8(%rax),%edx
    1b7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b80:	48 8b 00             	mov    (%rax),%rax
    1b83:	8b 40 08             	mov    0x8(%rax),%eax
    1b86:	01 c2                	add    %eax,%edx
    1b88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b8c:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b93:	48 8b 00             	mov    (%rax),%rax
    1b96:	48 8b 10             	mov    (%rax),%rdx
    1b99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b9d:	48 89 10             	mov    %rdx,(%rax)
    1ba0:	eb 0e                	jmp    1bb0 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1ba2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ba6:	48 8b 10             	mov    (%rax),%rdx
    1ba9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bad:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1bb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bb4:	8b 40 08             	mov    0x8(%rax),%eax
    1bb7:	89 c0                	mov    %eax,%eax
    1bb9:	48 c1 e0 04          	shl    $0x4,%rax
    1bbd:	48 89 c2             	mov    %rax,%rdx
    1bc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bc4:	48 01 d0             	add    %rdx,%rax
    1bc7:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bcb:	75 27                	jne    1bf4 <free+0x113>
    p->s.size += bp->s.size;
    1bcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bd1:	8b 50 08             	mov    0x8(%rax),%edx
    1bd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bd8:	8b 40 08             	mov    0x8(%rax),%eax
    1bdb:	01 c2                	add    %eax,%edx
    1bdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be1:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1be4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1be8:	48 8b 10             	mov    (%rax),%rdx
    1beb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bef:	48 89 10             	mov    %rdx,(%rax)
    1bf2:	eb 0b                	jmp    1bff <free+0x11e>
  } else
    p->s.ptr = bp;
    1bf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1bfc:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1bff:	48 ba 20 1e 00 00 00 	movabs $0x1e20,%rdx
    1c06:	00 00 00 
    1c09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c0d:	48 89 02             	mov    %rax,(%rdx)
}
    1c10:	90                   	nop
    1c11:	c9                   	leave
    1c12:	c3                   	ret

0000000000001c13 <morecore>:

static Header*
morecore(uint nu)
{
    1c13:	55                   	push   %rbp
    1c14:	48 89 e5             	mov    %rsp,%rbp
    1c17:	48 83 ec 20          	sub    $0x20,%rsp
    1c1b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c1e:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c25:	77 07                	ja     1c2e <morecore+0x1b>
    nu = 4096;
    1c27:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c31:	48 c1 e0 04          	shl    $0x4,%rax
    1c35:	48 89 c7             	mov    %rax,%rdi
    1c38:	48 b8 85 14 00 00 00 	movabs $0x1485,%rax
    1c3f:	00 00 00 
    1c42:	ff d0                	call   *%rax
    1c44:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c48:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c4d:	75 07                	jne    1c56 <morecore+0x43>
    return 0;
    1c4f:	b8 00 00 00 00       	mov    $0x0,%eax
    1c54:	eb 36                	jmp    1c8c <morecore+0x79>
  hp = (Header*)p;
    1c56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c5a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c62:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c65:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c6c:	48 83 c0 10          	add    $0x10,%rax
    1c70:	48 89 c7             	mov    %rax,%rdi
    1c73:	48 b8 e1 1a 00 00 00 	movabs $0x1ae1,%rax
    1c7a:	00 00 00 
    1c7d:	ff d0                	call   *%rax
  return freep;
    1c7f:	48 b8 20 1e 00 00 00 	movabs $0x1e20,%rax
    1c86:	00 00 00 
    1c89:	48 8b 00             	mov    (%rax),%rax
}
    1c8c:	c9                   	leave
    1c8d:	c3                   	ret

0000000000001c8e <malloc>:

void*
malloc(uint nbytes)
{
    1c8e:	55                   	push   %rbp
    1c8f:	48 89 e5             	mov    %rsp,%rbp
    1c92:	48 83 ec 30          	sub    $0x30,%rsp
    1c96:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1c99:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1c9c:	48 83 c0 0f          	add    $0xf,%rax
    1ca0:	48 c1 e8 04          	shr    $0x4,%rax
    1ca4:	83 c0 01             	add    $0x1,%eax
    1ca7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1caa:	48 b8 20 1e 00 00 00 	movabs $0x1e20,%rax
    1cb1:	00 00 00 
    1cb4:	48 8b 00             	mov    (%rax),%rax
    1cb7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cbb:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cc0:	75 4a                	jne    1d0c <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1cc2:	48 b8 10 1e 00 00 00 	movabs $0x1e10,%rax
    1cc9:	00 00 00 
    1ccc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cd0:	48 ba 20 1e 00 00 00 	movabs $0x1e20,%rdx
    1cd7:	00 00 00 
    1cda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cde:	48 89 02             	mov    %rax,(%rdx)
    1ce1:	48 b8 20 1e 00 00 00 	movabs $0x1e20,%rax
    1ce8:	00 00 00 
    1ceb:	48 8b 00             	mov    (%rax),%rax
    1cee:	48 ba 10 1e 00 00 00 	movabs $0x1e10,%rdx
    1cf5:	00 00 00 
    1cf8:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1cfb:	48 b8 10 1e 00 00 00 	movabs $0x1e10,%rax
    1d02:	00 00 00 
    1d05:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d10:	48 8b 00             	mov    (%rax),%rax
    1d13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d1b:	8b 40 08             	mov    0x8(%rax),%eax
    1d1e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1d21:	72 65                	jb     1d88 <malloc+0xfa>
      if(p->s.size == nunits)
    1d23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d27:	8b 40 08             	mov    0x8(%rax),%eax
    1d2a:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d2d:	75 10                	jne    1d3f <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1d2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d33:	48 8b 10             	mov    (%rax),%rdx
    1d36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d3a:	48 89 10             	mov    %rdx,(%rax)
    1d3d:	eb 2e                	jmp    1d6d <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1d3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d43:	8b 40 08             	mov    0x8(%rax),%eax
    1d46:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d49:	89 c2                	mov    %eax,%edx
    1d4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4f:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d56:	8b 40 08             	mov    0x8(%rax),%eax
    1d59:	89 c0                	mov    %eax,%eax
    1d5b:	48 c1 e0 04          	shl    $0x4,%rax
    1d5f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d67:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d6a:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d6d:	48 ba 20 1e 00 00 00 	movabs $0x1e20,%rdx
    1d74:	00 00 00 
    1d77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d7b:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d82:	48 83 c0 10          	add    $0x10,%rax
    1d86:	eb 4e                	jmp    1dd6 <malloc+0x148>
    }
    if(p == freep)
    1d88:	48 b8 20 1e 00 00 00 	movabs $0x1e20,%rax
    1d8f:	00 00 00 
    1d92:	48 8b 00             	mov    (%rax),%rax
    1d95:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1d99:	75 23                	jne    1dbe <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1d9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d9e:	89 c7                	mov    %eax,%edi
    1da0:	48 b8 13 1c 00 00 00 	movabs $0x1c13,%rax
    1da7:	00 00 00 
    1daa:	ff d0                	call   *%rax
    1dac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1db0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1db5:	75 07                	jne    1dbe <malloc+0x130>
        return 0;
    1db7:	b8 00 00 00 00       	mov    $0x0,%eax
    1dbc:	eb 18                	jmp    1dd6 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dc2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dca:	48 8b 00             	mov    (%rax),%rax
    1dcd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1dd1:	e9 41 ff ff ff       	jmp    1d17 <malloc+0x89>
  }
}
    1dd6:	c9                   	leave
    1dd7:	c3                   	ret

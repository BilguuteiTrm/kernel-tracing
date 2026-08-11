
_wc:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 30          	sub    $0x30,%rsp
    1008:	89 7d dc             	mov    %edi,-0x24(%rbp)
    100b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
    100f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
    1016:	8b 45 f0             	mov    -0x10(%rbp),%eax
    1019:	89 45 f4             	mov    %eax,-0xc(%rbp)
    101c:	8b 45 f4             	mov    -0xc(%rbp),%eax
    101f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  inword = 0;
    1022:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1029:	e9 84 00 00 00       	jmp    10b2 <wc+0xb2>
    for(i=0; i<n; i++){
    102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1035:	eb 73                	jmp    10aa <wc+0xaa>
      c++;
    1037:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
      if(buf[i] == '\n')
    103b:	48 ba 20 20 00 00 00 	movabs $0x2020,%rdx
    1042:	00 00 00 
    1045:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1048:	48 98                	cltq
    104a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    104e:	3c 0a                	cmp    $0xa,%al
    1050:	75 04                	jne    1056 <wc+0x56>
        l++;
    1052:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
      if(strchr(" \r\t\n\v", buf[i]))
    1056:	48 ba 20 20 00 00 00 	movabs $0x2020,%rdx
    105d:	00 00 00 
    1060:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1063:	48 98                	cltq
    1065:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1069:	0f be c0             	movsbl %al,%eax
    106c:	48 ba bd 1f 00 00 00 	movabs $0x1fbd,%rdx
    1073:	00 00 00 
    1076:	89 c6                	mov    %eax,%esi
    1078:	48 89 d7             	mov    %rdx,%rdi
    107b:	48 b8 a3 13 00 00 00 	movabs $0x13a3,%rax
    1082:	00 00 00 
    1085:	ff d0                	call   *%rax
    1087:	48 85 c0             	test   %rax,%rax
    108a:	74 09                	je     1095 <wc+0x95>
        inword = 0;
    108c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    1093:	eb 11                	jmp    10a6 <wc+0xa6>
      else if(!inword){
    1095:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    1099:	75 0b                	jne    10a6 <wc+0xa6>
        w++;
    109b:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
        inword = 1;
    109f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
    for(i=0; i<n; i++){
    10a6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    10aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10ad:	3b 45 e8             	cmp    -0x18(%rbp),%eax
    10b0:	7c 85                	jl     1037 <wc+0x37>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    10b2:	48 b9 20 20 00 00 00 	movabs $0x2020,%rcx
    10b9:	00 00 00 
    10bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
    10bf:	ba 00 02 00 00       	mov    $0x200,%edx
    10c4:	48 89 ce             	mov    %rcx,%rsi
    10c7:	89 c7                	mov    %eax,%edi
    10c9:	48 b8 b4 15 00 00 00 	movabs $0x15b4,%rax
    10d0:	00 00 00 
    10d3:	ff d0                	call   *%rax
    10d5:	89 45 e8             	mov    %eax,-0x18(%rbp)
    10d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    10dc:	0f 8f 4c ff ff ff    	jg     102e <wc+0x2e>
      }
    }
  }
  if(n < 0){
    10e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    10e6:	79 2f                	jns    1117 <wc+0x117>
    printf(1, "wc: read error\n");
    10e8:	48 b8 c3 1f 00 00 00 	movabs $0x1fc3,%rax
    10ef:	00 00 00 
    10f2:	48 89 c6             	mov    %rax,%rsi
    10f5:	bf 01 00 00 00       	mov    $0x1,%edi
    10fa:	b8 00 00 00 00       	mov    $0x0,%eax
    10ff:	48 ba 9b 18 00 00 00 	movabs $0x189b,%rdx
    1106:	00 00 00 
    1109:	ff d2                	call   *%rdx
    exit();
    110b:	48 b8 8d 15 00 00 00 	movabs $0x158d,%rax
    1112:	00 00 00 
    1115:	ff d0                	call   *%rax
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
    1117:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
    111b:	8b 4d f0             	mov    -0x10(%rbp),%ecx
    111e:	8b 55 f4             	mov    -0xc(%rbp),%edx
    1121:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1124:	48 be d3 1f 00 00 00 	movabs $0x1fd3,%rsi
    112b:	00 00 00 
    112e:	49 89 f9             	mov    %rdi,%r9
    1131:	41 89 c8             	mov    %ecx,%r8d
    1134:	89 d1                	mov    %edx,%ecx
    1136:	89 c2                	mov    %eax,%edx
    1138:	bf 01 00 00 00       	mov    $0x1,%edi
    113d:	b8 00 00 00 00       	mov    $0x0,%eax
    1142:	49 ba 9b 18 00 00 00 	movabs $0x189b,%r10
    1149:	00 00 00 
    114c:	41 ff d2             	call   *%r10
}
    114f:	90                   	nop
    1150:	c9                   	leave
    1151:	c3                   	ret

0000000000001152 <main>:

int
main(int argc, char *argv[])
{
    1152:	55                   	push   %rbp
    1153:	48 89 e5             	mov    %rsp,%rbp
    1156:	48 83 ec 20          	sub    $0x20,%rsp
    115a:	89 7d ec             	mov    %edi,-0x14(%rbp)
    115d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd, i;

  if(argc <= 1){
    1161:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1165:	7f 2a                	jg     1191 <main+0x3f>
    wc(0, "");
    1167:	48 b8 e0 1f 00 00 00 	movabs $0x1fe0,%rax
    116e:	00 00 00 
    1171:	48 89 c6             	mov    %rax,%rsi
    1174:	bf 00 00 00 00       	mov    $0x0,%edi
    1179:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1180:	00 00 00 
    1183:	ff d0                	call   *%rax
    exit();
    1185:	48 b8 8d 15 00 00 00 	movabs $0x158d,%rax
    118c:	00 00 00 
    118f:	ff d0                	call   *%rax
  }

  for(i = 1; i < argc; i++){
    1191:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    1198:	e9 bd 00 00 00       	jmp    125a <main+0x108>
    if((fd = open(argv[i], 0)) < 0){
    119d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11a0:	48 98                	cltq
    11a2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    11a9:	00 
    11aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    11ae:	48 01 d0             	add    %rdx,%rax
    11b1:	48 8b 00             	mov    (%rax),%rax
    11b4:	be 00 00 00 00       	mov    $0x0,%esi
    11b9:	48 89 c7             	mov    %rax,%rdi
    11bc:	48 b8 f5 15 00 00 00 	movabs $0x15f5,%rax
    11c3:	00 00 00 
    11c6:	ff d0                	call   *%rax
    11c8:	89 45 f8             	mov    %eax,-0x8(%rbp)
    11cb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    11cf:	79 49                	jns    121a <main+0xc8>
      printf(1, "wc: cannot open %s\n", argv[i]);
    11d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11d4:	48 98                	cltq
    11d6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    11dd:	00 
    11de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    11e2:	48 01 d0             	add    %rdx,%rax
    11e5:	48 8b 00             	mov    (%rax),%rax
    11e8:	48 b9 e1 1f 00 00 00 	movabs $0x1fe1,%rcx
    11ef:	00 00 00 
    11f2:	48 89 c2             	mov    %rax,%rdx
    11f5:	48 89 ce             	mov    %rcx,%rsi
    11f8:	bf 01 00 00 00       	mov    $0x1,%edi
    11fd:	b8 00 00 00 00       	mov    $0x0,%eax
    1202:	48 b9 9b 18 00 00 00 	movabs $0x189b,%rcx
    1209:	00 00 00 
    120c:	ff d1                	call   *%rcx
      exit();
    120e:	48 b8 8d 15 00 00 00 	movabs $0x158d,%rax
    1215:	00 00 00 
    1218:	ff d0                	call   *%rax
    }
    wc(fd, argv[i]);
    121a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    121d:	48 98                	cltq
    121f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1226:	00 
    1227:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    122b:	48 01 d0             	add    %rdx,%rax
    122e:	48 8b 10             	mov    (%rax),%rdx
    1231:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1234:	48 89 d6             	mov    %rdx,%rsi
    1237:	89 c7                	mov    %eax,%edi
    1239:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1240:	00 00 00 
    1243:	ff d0                	call   *%rax
    close(fd);
    1245:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1248:	89 c7                	mov    %eax,%edi
    124a:	48 b8 ce 15 00 00 00 	movabs $0x15ce,%rax
    1251:	00 00 00 
    1254:	ff d0                	call   *%rax
  for(i = 1; i < argc; i++){
    1256:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    125a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    125d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1260:	0f 8c 37 ff ff ff    	jl     119d <main+0x4b>
  }
  exit();
    1266:	48 b8 8d 15 00 00 00 	movabs $0x158d,%rax
    126d:	00 00 00 
    1270:	ff d0                	call   *%rax

0000000000001272 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1272:	55                   	push   %rbp
    1273:	48 89 e5             	mov    %rsp,%rbp
    1276:	48 83 ec 10          	sub    $0x10,%rsp
    127a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    127e:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1281:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1284:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1288:	8b 55 f0             	mov    -0x10(%rbp),%edx
    128b:	8b 45 f4             	mov    -0xc(%rbp),%eax
    128e:	48 89 ce             	mov    %rcx,%rsi
    1291:	48 89 f7             	mov    %rsi,%rdi
    1294:	89 d1                	mov    %edx,%ecx
    1296:	fc                   	cld
    1297:	f3 aa                	rep stos %al,(%rdi)
    1299:	89 ca                	mov    %ecx,%edx
    129b:	48 89 fe             	mov    %rdi,%rsi
    129e:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    12a2:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    12a5:	90                   	nop
    12a6:	c9                   	leave
    12a7:	c3                   	ret

00000000000012a8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    12a8:	55                   	push   %rbp
    12a9:	48 89 e5             	mov    %rsp,%rbp
    12ac:	48 83 ec 20          	sub    $0x20,%rsp
    12b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    12b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    12c0:	90                   	nop
    12c1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12c5:	48 8d 42 01          	lea    0x1(%rdx),%rax
    12c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    12cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12d1:	48 8d 48 01          	lea    0x1(%rax),%rcx
    12d5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    12d9:	0f b6 12             	movzbl (%rdx),%edx
    12dc:	88 10                	mov    %dl,(%rax)
    12de:	0f b6 00             	movzbl (%rax),%eax
    12e1:	84 c0                	test   %al,%al
    12e3:	75 dc                	jne    12c1 <strcpy+0x19>
    ;
  return os;
    12e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12e9:	c9                   	leave
    12ea:	c3                   	ret

00000000000012eb <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12eb:	55                   	push   %rbp
    12ec:	48 89 e5             	mov    %rsp,%rbp
    12ef:	48 83 ec 10          	sub    $0x10,%rsp
    12f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    12fb:	eb 0a                	jmp    1307 <strcmp+0x1c>
    p++, q++;
    12fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1302:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    130b:	0f b6 00             	movzbl (%rax),%eax
    130e:	84 c0                	test   %al,%al
    1310:	74 12                	je     1324 <strcmp+0x39>
    1312:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1316:	0f b6 10             	movzbl (%rax),%edx
    1319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    131d:	0f b6 00             	movzbl (%rax),%eax
    1320:	38 c2                	cmp    %al,%dl
    1322:	74 d9                	je     12fd <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1328:	0f b6 00             	movzbl (%rax),%eax
    132b:	0f b6 d0             	movzbl %al,%edx
    132e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1332:	0f b6 00             	movzbl (%rax),%eax
    1335:	0f b6 c0             	movzbl %al,%eax
    1338:	29 c2                	sub    %eax,%edx
    133a:	89 d0                	mov    %edx,%eax
}
    133c:	c9                   	leave
    133d:	c3                   	ret

000000000000133e <strlen>:

uint
strlen(char *s)
{
    133e:	55                   	push   %rbp
    133f:	48 89 e5             	mov    %rsp,%rbp
    1342:	48 83 ec 18          	sub    $0x18,%rsp
    1346:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    134a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1351:	eb 04                	jmp    1357 <strlen+0x19>
    1353:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1357:	8b 45 fc             	mov    -0x4(%rbp),%eax
    135a:	48 63 d0             	movslq %eax,%rdx
    135d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1361:	48 01 d0             	add    %rdx,%rax
    1364:	0f b6 00             	movzbl (%rax),%eax
    1367:	84 c0                	test   %al,%al
    1369:	75 e8                	jne    1353 <strlen+0x15>
    ;
  return n;
    136b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    136e:	c9                   	leave
    136f:	c3                   	ret

0000000000001370 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1370:	55                   	push   %rbp
    1371:	48 89 e5             	mov    %rsp,%rbp
    1374:	48 83 ec 10          	sub    $0x10,%rsp
    1378:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    137c:	89 75 f4             	mov    %esi,-0xc(%rbp)
    137f:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1382:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1385:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    1388:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    138c:	89 ce                	mov    %ecx,%esi
    138e:	48 89 c7             	mov    %rax,%rdi
    1391:	48 b8 72 12 00 00 00 	movabs $0x1272,%rax
    1398:	00 00 00 
    139b:	ff d0                	call   *%rax
  return dst;
    139d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    13a1:	c9                   	leave
    13a2:	c3                   	ret

00000000000013a3 <strchr>:

char*
strchr(const char *s, char c)
{
    13a3:	55                   	push   %rbp
    13a4:	48 89 e5             	mov    %rsp,%rbp
    13a7:	48 83 ec 10          	sub    $0x10,%rsp
    13ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    13af:	89 f0                	mov    %esi,%eax
    13b1:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    13b4:	eb 17                	jmp    13cd <strchr+0x2a>
    if(*s == c)
    13b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13ba:	0f b6 00             	movzbl (%rax),%eax
    13bd:	38 45 f4             	cmp    %al,-0xc(%rbp)
    13c0:	75 06                	jne    13c8 <strchr+0x25>
      return (char*)s;
    13c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13c6:	eb 15                	jmp    13dd <strchr+0x3a>
  for(; *s; s++)
    13c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    13cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13d1:	0f b6 00             	movzbl (%rax),%eax
    13d4:	84 c0                	test   %al,%al
    13d6:	75 de                	jne    13b6 <strchr+0x13>
  return 0;
    13d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13dd:	c9                   	leave
    13de:	c3                   	ret

00000000000013df <gets>:

char*
gets(char *buf, int max)
{
    13df:	55                   	push   %rbp
    13e0:	48 89 e5             	mov    %rsp,%rbp
    13e3:	48 83 ec 20          	sub    $0x20,%rsp
    13e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    13ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    13f5:	eb 4f                	jmp    1446 <gets+0x67>
    cc = read(0, &c, 1);
    13f7:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    13fb:	ba 01 00 00 00       	mov    $0x1,%edx
    1400:	48 89 c6             	mov    %rax,%rsi
    1403:	bf 00 00 00 00       	mov    $0x0,%edi
    1408:	48 b8 b4 15 00 00 00 	movabs $0x15b4,%rax
    140f:	00 00 00 
    1412:	ff d0                	call   *%rax
    1414:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1417:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    141b:	7e 36                	jle    1453 <gets+0x74>
      break;
    buf[i++] = c;
    141d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1420:	8d 50 01             	lea    0x1(%rax),%edx
    1423:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1426:	48 63 d0             	movslq %eax,%rdx
    1429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    142d:	48 01 c2             	add    %rax,%rdx
    1430:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1434:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1436:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    143a:	3c 0a                	cmp    $0xa,%al
    143c:	74 16                	je     1454 <gets+0x75>
    143e:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1442:	3c 0d                	cmp    $0xd,%al
    1444:	74 0e                	je     1454 <gets+0x75>
  for(i=0; i+1 < max; ){
    1446:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1449:	83 c0 01             	add    $0x1,%eax
    144c:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    144f:	7f a6                	jg     13f7 <gets+0x18>
    1451:	eb 01                	jmp    1454 <gets+0x75>
      break;
    1453:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1454:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1457:	48 63 d0             	movslq %eax,%rdx
    145a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    145e:	48 01 d0             	add    %rdx,%rax
    1461:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1468:	c9                   	leave
    1469:	c3                   	ret

000000000000146a <stat>:

int
stat(char *n, struct stat *st)
{
    146a:	55                   	push   %rbp
    146b:	48 89 e5             	mov    %rsp,%rbp
    146e:	48 83 ec 20          	sub    $0x20,%rsp
    1472:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1476:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    147a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    147e:	be 00 00 00 00       	mov    $0x0,%esi
    1483:	48 89 c7             	mov    %rax,%rdi
    1486:	48 b8 f5 15 00 00 00 	movabs $0x15f5,%rax
    148d:	00 00 00 
    1490:	ff d0                	call   *%rax
    1492:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1495:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1499:	79 07                	jns    14a2 <stat+0x38>
    return -1;
    149b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    14a0:	eb 2f                	jmp    14d1 <stat+0x67>
  r = fstat(fd, st);
    14a2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    14a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14a9:	48 89 d6             	mov    %rdx,%rsi
    14ac:	89 c7                	mov    %eax,%edi
    14ae:	48 b8 1c 16 00 00 00 	movabs $0x161c,%rax
    14b5:	00 00 00 
    14b8:	ff d0                	call   *%rax
    14ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    14bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14c0:	89 c7                	mov    %eax,%edi
    14c2:	48 b8 ce 15 00 00 00 	movabs $0x15ce,%rax
    14c9:	00 00 00 
    14cc:	ff d0                	call   *%rax
  return r;
    14ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    14d1:	c9                   	leave
    14d2:	c3                   	ret

00000000000014d3 <atoi>:

int
atoi(const char *s)
{
    14d3:	55                   	push   %rbp
    14d4:	48 89 e5             	mov    %rsp,%rbp
    14d7:	48 83 ec 18          	sub    $0x18,%rsp
    14db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    14df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    14e6:	eb 28                	jmp    1510 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    14e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
    14eb:	89 d0                	mov    %edx,%eax
    14ed:	c1 e0 02             	shl    $0x2,%eax
    14f0:	01 d0                	add    %edx,%eax
    14f2:	01 c0                	add    %eax,%eax
    14f4:	89 c1                	mov    %eax,%ecx
    14f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
    14fe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1502:	0f b6 00             	movzbl (%rax),%eax
    1505:	0f be c0             	movsbl %al,%eax
    1508:	01 c8                	add    %ecx,%eax
    150a:	83 e8 30             	sub    $0x30,%eax
    150d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1514:	0f b6 00             	movzbl (%rax),%eax
    1517:	3c 2f                	cmp    $0x2f,%al
    1519:	7e 0b                	jle    1526 <atoi+0x53>
    151b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    151f:	0f b6 00             	movzbl (%rax),%eax
    1522:	3c 39                	cmp    $0x39,%al
    1524:	7e c2                	jle    14e8 <atoi+0x15>
  return n;
    1526:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1529:	c9                   	leave
    152a:	c3                   	ret

000000000000152b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    152b:	55                   	push   %rbp
    152c:	48 89 e5             	mov    %rsp,%rbp
    152f:	48 83 ec 28          	sub    $0x28,%rsp
    1533:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1537:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    153b:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    153e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1542:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1546:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    154a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    154e:	eb 1d                	jmp    156d <memmove+0x42>
    *dst++ = *src++;
    1550:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1554:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1558:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    155c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1560:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1564:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1568:	0f b6 12             	movzbl (%rdx),%edx
    156b:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    156d:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1570:	8d 50 ff             	lea    -0x1(%rax),%edx
    1573:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1576:	85 c0                	test   %eax,%eax
    1578:	7f d6                	jg     1550 <memmove+0x25>
  return vdst;
    157a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    157e:	c9                   	leave
    157f:	c3                   	ret

0000000000001580 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1580:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1587:	49 89 ca             	mov    %rcx,%r10
    158a:	0f 05                	syscall
    158c:	c3                   	ret

000000000000158d <exit>:
SYSCALL(exit)
    158d:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1594:	49 89 ca             	mov    %rcx,%r10
    1597:	0f 05                	syscall
    1599:	c3                   	ret

000000000000159a <wait>:
SYSCALL(wait)
    159a:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    15a1:	49 89 ca             	mov    %rcx,%r10
    15a4:	0f 05                	syscall
    15a6:	c3                   	ret

00000000000015a7 <pipe>:
SYSCALL(pipe)
    15a7:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    15ae:	49 89 ca             	mov    %rcx,%r10
    15b1:	0f 05                	syscall
    15b3:	c3                   	ret

00000000000015b4 <read>:
SYSCALL(read)
    15b4:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    15bb:	49 89 ca             	mov    %rcx,%r10
    15be:	0f 05                	syscall
    15c0:	c3                   	ret

00000000000015c1 <write>:
SYSCALL(write)
    15c1:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    15c8:	49 89 ca             	mov    %rcx,%r10
    15cb:	0f 05                	syscall
    15cd:	c3                   	ret

00000000000015ce <close>:
SYSCALL(close)
    15ce:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    15d5:	49 89 ca             	mov    %rcx,%r10
    15d8:	0f 05                	syscall
    15da:	c3                   	ret

00000000000015db <kill>:
SYSCALL(kill)
    15db:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    15e2:	49 89 ca             	mov    %rcx,%r10
    15e5:	0f 05                	syscall
    15e7:	c3                   	ret

00000000000015e8 <exec>:
SYSCALL(exec)
    15e8:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    15ef:	49 89 ca             	mov    %rcx,%r10
    15f2:	0f 05                	syscall
    15f4:	c3                   	ret

00000000000015f5 <open>:
SYSCALL(open)
    15f5:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    15fc:	49 89 ca             	mov    %rcx,%r10
    15ff:	0f 05                	syscall
    1601:	c3                   	ret

0000000000001602 <mknod>:
SYSCALL(mknod)
    1602:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1609:	49 89 ca             	mov    %rcx,%r10
    160c:	0f 05                	syscall
    160e:	c3                   	ret

000000000000160f <unlink>:
SYSCALL(unlink)
    160f:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1616:	49 89 ca             	mov    %rcx,%r10
    1619:	0f 05                	syscall
    161b:	c3                   	ret

000000000000161c <fstat>:
SYSCALL(fstat)
    161c:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1623:	49 89 ca             	mov    %rcx,%r10
    1626:	0f 05                	syscall
    1628:	c3                   	ret

0000000000001629 <link>:
SYSCALL(link)
    1629:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1630:	49 89 ca             	mov    %rcx,%r10
    1633:	0f 05                	syscall
    1635:	c3                   	ret

0000000000001636 <mkdir>:
SYSCALL(mkdir)
    1636:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    163d:	49 89 ca             	mov    %rcx,%r10
    1640:	0f 05                	syscall
    1642:	c3                   	ret

0000000000001643 <chdir>:
SYSCALL(chdir)
    1643:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    164a:	49 89 ca             	mov    %rcx,%r10
    164d:	0f 05                	syscall
    164f:	c3                   	ret

0000000000001650 <dup>:
SYSCALL(dup)
    1650:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1657:	49 89 ca             	mov    %rcx,%r10
    165a:	0f 05                	syscall
    165c:	c3                   	ret

000000000000165d <getpid>:
SYSCALL(getpid)
    165d:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1664:	49 89 ca             	mov    %rcx,%r10
    1667:	0f 05                	syscall
    1669:	c3                   	ret

000000000000166a <sbrk>:
SYSCALL(sbrk)
    166a:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1671:	49 89 ca             	mov    %rcx,%r10
    1674:	0f 05                	syscall
    1676:	c3                   	ret

0000000000001677 <sleep>:
SYSCALL(sleep)
    1677:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    167e:	49 89 ca             	mov    %rcx,%r10
    1681:	0f 05                	syscall
    1683:	c3                   	ret

0000000000001684 <uptime>:
SYSCALL(uptime)
    1684:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    168b:	49 89 ca             	mov    %rcx,%r10
    168e:	0f 05                	syscall
    1690:	c3                   	ret

0000000000001691 <traceread>:
SYSCALL(traceread)
    1691:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1698:	49 89 ca             	mov    %rcx,%r10
    169b:	0f 05                	syscall
    169d:	c3                   	ret

000000000000169e <vidclear>:
SYSCALL(vidclear)
    169e:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    16a5:	49 89 ca             	mov    %rcx,%r10
    16a8:	0f 05                	syscall
    16aa:	c3                   	ret

00000000000016ab <vidputc>:
SYSCALL(vidputc)
    16ab:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    16b2:	49 89 ca             	mov    %rcx,%r10
    16b5:	0f 05                	syscall
    16b7:	c3                   	ret

00000000000016b8 <vidputs>:
SYSCALL(vidputs)
    16b8:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    16bf:	49 89 ca             	mov    %rcx,%r10
    16c2:	0f 05                	syscall
    16c4:	c3                   	ret

00000000000016c5 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    16c5:	55                   	push   %rbp
    16c6:	48 89 e5             	mov    %rsp,%rbp
    16c9:	48 83 ec 10          	sub    $0x10,%rsp
    16cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
    16d0:	89 f0                	mov    %esi,%eax
    16d2:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    16d5:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    16d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16dc:	ba 01 00 00 00       	mov    $0x1,%edx
    16e1:	48 89 ce             	mov    %rcx,%rsi
    16e4:	89 c7                	mov    %eax,%edi
    16e6:	48 b8 c1 15 00 00 00 	movabs $0x15c1,%rax
    16ed:	00 00 00 
    16f0:	ff d0                	call   *%rax
}
    16f2:	90                   	nop
    16f3:	c9                   	leave
    16f4:	c3                   	ret

00000000000016f5 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    16f5:	55                   	push   %rbp
    16f6:	48 89 e5             	mov    %rsp,%rbp
    16f9:	48 83 ec 20          	sub    $0x20,%rsp
    16fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1700:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1704:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    170b:	eb 35                	jmp    1742 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    170d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1711:	48 c1 e8 3c          	shr    $0x3c,%rax
    1715:	48 ba 00 20 00 00 00 	movabs $0x2000,%rdx
    171c:	00 00 00 
    171f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1723:	0f be d0             	movsbl %al,%edx
    1726:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1729:	89 d6                	mov    %edx,%esi
    172b:	89 c7                	mov    %eax,%edi
    172d:	48 b8 c5 16 00 00 00 	movabs $0x16c5,%rax
    1734:	00 00 00 
    1737:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1739:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    173d:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1742:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1745:	83 f8 0f             	cmp    $0xf,%eax
    1748:	76 c3                	jbe    170d <print_x64+0x18>
}
    174a:	90                   	nop
    174b:	90                   	nop
    174c:	c9                   	leave
    174d:	c3                   	ret

000000000000174e <print_x32>:

  static void
print_x32(int fd, uint x)
{
    174e:	55                   	push   %rbp
    174f:	48 89 e5             	mov    %rsp,%rbp
    1752:	48 83 ec 20          	sub    $0x20,%rsp
    1756:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1759:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    175c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1763:	eb 36                	jmp    179b <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1765:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1768:	c1 e8 1c             	shr    $0x1c,%eax
    176b:	89 c2                	mov    %eax,%edx
    176d:	48 b8 00 20 00 00 00 	movabs $0x2000,%rax
    1774:	00 00 00 
    1777:	89 d2                	mov    %edx,%edx
    1779:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    177d:	0f be d0             	movsbl %al,%edx
    1780:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1783:	89 d6                	mov    %edx,%esi
    1785:	89 c7                	mov    %eax,%edi
    1787:	48 b8 c5 16 00 00 00 	movabs $0x16c5,%rax
    178e:	00 00 00 
    1791:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1793:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1797:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    179b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    179e:	83 f8 07             	cmp    $0x7,%eax
    17a1:	76 c2                	jbe    1765 <print_x32+0x17>
}
    17a3:	90                   	nop
    17a4:	90                   	nop
    17a5:	c9                   	leave
    17a6:	c3                   	ret

00000000000017a7 <print_d>:

  static void
print_d(int fd, int v)
{
    17a7:	55                   	push   %rbp
    17a8:	48 89 e5             	mov    %rsp,%rbp
    17ab:	48 83 ec 30          	sub    $0x30,%rsp
    17af:	89 7d dc             	mov    %edi,-0x24(%rbp)
    17b2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    17b5:	8b 45 d8             	mov    -0x28(%rbp),%eax
    17b8:	48 98                	cltq
    17ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    17be:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17c2:	79 04                	jns    17c8 <print_d+0x21>
    x = -x;
    17c4:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    17c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    17cf:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    17d3:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    17da:	66 66 66 
    17dd:	48 89 c8             	mov    %rcx,%rax
    17e0:	48 f7 ea             	imul   %rdx
    17e3:	48 c1 fa 02          	sar    $0x2,%rdx
    17e7:	48 89 c8             	mov    %rcx,%rax
    17ea:	48 c1 f8 3f          	sar    $0x3f,%rax
    17ee:	48 29 c2             	sub    %rax,%rdx
    17f1:	48 89 d0             	mov    %rdx,%rax
    17f4:	48 c1 e0 02          	shl    $0x2,%rax
    17f8:	48 01 d0             	add    %rdx,%rax
    17fb:	48 01 c0             	add    %rax,%rax
    17fe:	48 29 c1             	sub    %rax,%rcx
    1801:	48 89 ca             	mov    %rcx,%rdx
    1804:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1807:	8d 48 01             	lea    0x1(%rax),%ecx
    180a:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    180d:	48 b9 00 20 00 00 00 	movabs $0x2000,%rcx
    1814:	00 00 00 
    1817:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    181b:	48 98                	cltq
    181d:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1821:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1825:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    182c:	66 66 66 
    182f:	48 89 c8             	mov    %rcx,%rax
    1832:	48 f7 ea             	imul   %rdx
    1835:	48 89 d0             	mov    %rdx,%rax
    1838:	48 c1 f8 02          	sar    $0x2,%rax
    183c:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1840:	48 89 ca             	mov    %rcx,%rdx
    1843:	48 29 d0             	sub    %rdx,%rax
    1846:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    184a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    184f:	0f 85 7a ff ff ff    	jne    17cf <print_d+0x28>

  if (v < 0)
    1855:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1859:	79 32                	jns    188d <print_d+0xe6>
    buf[i++] = '-';
    185b:	8b 45 f4             	mov    -0xc(%rbp),%eax
    185e:	8d 50 01             	lea    0x1(%rax),%edx
    1861:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1864:	48 98                	cltq
    1866:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    186b:	eb 20                	jmp    188d <print_d+0xe6>
    putc(fd, buf[i]);
    186d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1870:	48 98                	cltq
    1872:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1877:	0f be d0             	movsbl %al,%edx
    187a:	8b 45 dc             	mov    -0x24(%rbp),%eax
    187d:	89 d6                	mov    %edx,%esi
    187f:	89 c7                	mov    %eax,%edi
    1881:	48 b8 c5 16 00 00 00 	movabs $0x16c5,%rax
    1888:	00 00 00 
    188b:	ff d0                	call   *%rax
  while (--i >= 0)
    188d:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1891:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1895:	79 d6                	jns    186d <print_d+0xc6>
}
    1897:	90                   	nop
    1898:	90                   	nop
    1899:	c9                   	leave
    189a:	c3                   	ret

000000000000189b <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    189b:	55                   	push   %rbp
    189c:	48 89 e5             	mov    %rsp,%rbp
    189f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    18a6:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    18ac:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    18b3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    18ba:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    18c1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    18c8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    18cf:	84 c0                	test   %al,%al
    18d1:	74 20                	je     18f3 <printf+0x58>
    18d3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    18d7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    18db:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    18df:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    18e3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    18e7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    18eb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    18ef:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    18f3:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    18fa:	00 00 00 
    18fd:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1904:	00 00 00 
    1907:	48 8d 45 10          	lea    0x10(%rbp),%rax
    190b:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1912:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1919:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1920:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1927:	00 00 00 
    192a:	e9 60 03 00 00       	jmp    1c8f <printf+0x3f4>
    if (c != '%') {
    192f:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1936:	74 24                	je     195c <printf+0xc1>
      putc(fd, c);
    1938:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    193e:	0f be d0             	movsbl %al,%edx
    1941:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1947:	89 d6                	mov    %edx,%esi
    1949:	89 c7                	mov    %eax,%edi
    194b:	48 b8 c5 16 00 00 00 	movabs $0x16c5,%rax
    1952:	00 00 00 
    1955:	ff d0                	call   *%rax
      continue;
    1957:	e9 2c 03 00 00       	jmp    1c88 <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    195c:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1963:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1969:	48 63 d0             	movslq %eax,%rdx
    196c:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1973:	48 01 d0             	add    %rdx,%rax
    1976:	0f b6 00             	movzbl (%rax),%eax
    1979:	0f be c0             	movsbl %al,%eax
    197c:	25 ff 00 00 00       	and    $0xff,%eax
    1981:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1987:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    198e:	0f 84 2e 03 00 00    	je     1cc2 <printf+0x427>
      break;
    switch(c) {
    1994:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    199b:	0f 84 32 01 00 00    	je     1ad3 <printf+0x238>
    19a1:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    19a8:	0f 8f a1 02 00 00    	jg     1c4f <printf+0x3b4>
    19ae:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    19b5:	0f 84 d4 01 00 00    	je     1b8f <printf+0x2f4>
    19bb:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    19c2:	0f 8f 87 02 00 00    	jg     1c4f <printf+0x3b4>
    19c8:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    19cf:	0f 84 5b 01 00 00    	je     1b30 <printf+0x295>
    19d5:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    19dc:	0f 8f 6d 02 00 00    	jg     1c4f <printf+0x3b4>
    19e2:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    19e9:	0f 84 87 00 00 00    	je     1a76 <printf+0x1db>
    19ef:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    19f6:	0f 8f 53 02 00 00    	jg     1c4f <printf+0x3b4>
    19fc:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1a03:	0f 84 2b 02 00 00    	je     1c34 <printf+0x399>
    1a09:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1a10:	0f 85 39 02 00 00    	jne    1c4f <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    1a16:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a1c:	83 f8 2f             	cmp    $0x2f,%eax
    1a1f:	77 23                	ja     1a44 <printf+0x1a9>
    1a21:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a28:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a2e:	89 d2                	mov    %edx,%edx
    1a30:	48 01 d0             	add    %rdx,%rax
    1a33:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a39:	83 c2 08             	add    $0x8,%edx
    1a3c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a42:	eb 12                	jmp    1a56 <printf+0x1bb>
    1a44:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a4b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a4f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a56:	8b 00                	mov    (%rax),%eax
    1a58:	0f be d0             	movsbl %al,%edx
    1a5b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a61:	89 d6                	mov    %edx,%esi
    1a63:	89 c7                	mov    %eax,%edi
    1a65:	48 b8 c5 16 00 00 00 	movabs $0x16c5,%rax
    1a6c:	00 00 00 
    1a6f:	ff d0                	call   *%rax
      break;
    1a71:	e9 12 02 00 00       	jmp    1c88 <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1a76:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a7c:	83 f8 2f             	cmp    $0x2f,%eax
    1a7f:	77 23                	ja     1aa4 <printf+0x209>
    1a81:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a88:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a8e:	89 d2                	mov    %edx,%edx
    1a90:	48 01 d0             	add    %rdx,%rax
    1a93:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a99:	83 c2 08             	add    $0x8,%edx
    1a9c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1aa2:	eb 12                	jmp    1ab6 <printf+0x21b>
    1aa4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1aab:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1aaf:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ab6:	8b 10                	mov    (%rax),%edx
    1ab8:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1abe:	89 d6                	mov    %edx,%esi
    1ac0:	89 c7                	mov    %eax,%edi
    1ac2:	48 b8 a7 17 00 00 00 	movabs $0x17a7,%rax
    1ac9:	00 00 00 
    1acc:	ff d0                	call   *%rax
      break;
    1ace:	e9 b5 01 00 00       	jmp    1c88 <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1ad3:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ad9:	83 f8 2f             	cmp    $0x2f,%eax
    1adc:	77 23                	ja     1b01 <printf+0x266>
    1ade:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ae5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1aeb:	89 d2                	mov    %edx,%edx
    1aed:	48 01 d0             	add    %rdx,%rax
    1af0:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1af6:	83 c2 08             	add    $0x8,%edx
    1af9:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1aff:	eb 12                	jmp    1b13 <printf+0x278>
    1b01:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b08:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b0c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b13:	8b 10                	mov    (%rax),%edx
    1b15:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b1b:	89 d6                	mov    %edx,%esi
    1b1d:	89 c7                	mov    %eax,%edi
    1b1f:	48 b8 4e 17 00 00 00 	movabs $0x174e,%rax
    1b26:	00 00 00 
    1b29:	ff d0                	call   *%rax
      break;
    1b2b:	e9 58 01 00 00       	jmp    1c88 <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1b30:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b36:	83 f8 2f             	cmp    $0x2f,%eax
    1b39:	77 23                	ja     1b5e <printf+0x2c3>
    1b3b:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b42:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b48:	89 d2                	mov    %edx,%edx
    1b4a:	48 01 d0             	add    %rdx,%rax
    1b4d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b53:	83 c2 08             	add    $0x8,%edx
    1b56:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b5c:	eb 12                	jmp    1b70 <printf+0x2d5>
    1b5e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b65:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b69:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b70:	48 8b 10             	mov    (%rax),%rdx
    1b73:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b79:	48 89 d6             	mov    %rdx,%rsi
    1b7c:	89 c7                	mov    %eax,%edi
    1b7e:	48 b8 f5 16 00 00 00 	movabs $0x16f5,%rax
    1b85:	00 00 00 
    1b88:	ff d0                	call   *%rax
      break;
    1b8a:	e9 f9 00 00 00       	jmp    1c88 <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1b8f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b95:	83 f8 2f             	cmp    $0x2f,%eax
    1b98:	77 23                	ja     1bbd <printf+0x322>
    1b9a:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ba1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ba7:	89 d2                	mov    %edx,%edx
    1ba9:	48 01 d0             	add    %rdx,%rax
    1bac:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1bb2:	83 c2 08             	add    $0x8,%edx
    1bb5:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1bbb:	eb 12                	jmp    1bcf <printf+0x334>
    1bbd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1bc4:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1bc8:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1bcf:	48 8b 00             	mov    (%rax),%rax
    1bd2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1bd9:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1be0:	00 
    1be1:	75 41                	jne    1c24 <printf+0x389>
        s = "(null)";
    1be3:	48 b8 f5 1f 00 00 00 	movabs $0x1ff5,%rax
    1bea:	00 00 00 
    1bed:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1bf4:	eb 2e                	jmp    1c24 <printf+0x389>
        putc(fd, *(s++));
    1bf6:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1bfd:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1c01:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1c08:	0f b6 00             	movzbl (%rax),%eax
    1c0b:	0f be d0             	movsbl %al,%edx
    1c0e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c14:	89 d6                	mov    %edx,%esi
    1c16:	89 c7                	mov    %eax,%edi
    1c18:	48 b8 c5 16 00 00 00 	movabs $0x16c5,%rax
    1c1f:	00 00 00 
    1c22:	ff d0                	call   *%rax
      while (*s)
    1c24:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1c2b:	0f b6 00             	movzbl (%rax),%eax
    1c2e:	84 c0                	test   %al,%al
    1c30:	75 c4                	jne    1bf6 <printf+0x35b>
      break;
    1c32:	eb 54                	jmp    1c88 <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1c34:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c3a:	be 25 00 00 00       	mov    $0x25,%esi
    1c3f:	89 c7                	mov    %eax,%edi
    1c41:	48 b8 c5 16 00 00 00 	movabs $0x16c5,%rax
    1c48:	00 00 00 
    1c4b:	ff d0                	call   *%rax
      break;
    1c4d:	eb 39                	jmp    1c88 <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1c4f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c55:	be 25 00 00 00       	mov    $0x25,%esi
    1c5a:	89 c7                	mov    %eax,%edi
    1c5c:	48 b8 c5 16 00 00 00 	movabs $0x16c5,%rax
    1c63:	00 00 00 
    1c66:	ff d0                	call   *%rax
      putc(fd, c);
    1c68:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1c6e:	0f be d0             	movsbl %al,%edx
    1c71:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c77:	89 d6                	mov    %edx,%esi
    1c79:	89 c7                	mov    %eax,%edi
    1c7b:	48 b8 c5 16 00 00 00 	movabs $0x16c5,%rax
    1c82:	00 00 00 
    1c85:	ff d0                	call   *%rax
      break;
    1c87:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1c88:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1c8f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1c95:	48 63 d0             	movslq %eax,%rdx
    1c98:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1c9f:	48 01 d0             	add    %rdx,%rax
    1ca2:	0f b6 00             	movzbl (%rax),%eax
    1ca5:	0f be c0             	movsbl %al,%eax
    1ca8:	25 ff 00 00 00       	and    $0xff,%eax
    1cad:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1cb3:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1cba:	0f 85 6f fc ff ff    	jne    192f <printf+0x94>
    }
  }
}
    1cc0:	eb 01                	jmp    1cc3 <printf+0x428>
      break;
    1cc2:	90                   	nop
}
    1cc3:	90                   	nop
    1cc4:	c9                   	leave
    1cc5:	c3                   	ret

0000000000001cc6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1cc6:	55                   	push   %rbp
    1cc7:	48 89 e5             	mov    %rsp,%rbp
    1cca:	48 83 ec 18          	sub    $0x18,%rsp
    1cce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1cd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1cd6:	48 83 e8 10          	sub    $0x10,%rax
    1cda:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1cde:	48 b8 30 22 00 00 00 	movabs $0x2230,%rax
    1ce5:	00 00 00 
    1ce8:	48 8b 00             	mov    (%rax),%rax
    1ceb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1cef:	eb 2f                	jmp    1d20 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1cf1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cf5:	48 8b 00             	mov    (%rax),%rax
    1cf8:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1cfc:	72 17                	jb     1d15 <free+0x4f>
    1cfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d02:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1d06:	72 2f                	jb     1d37 <free+0x71>
    1d08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d0c:	48 8b 00             	mov    (%rax),%rax
    1d0f:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d13:	72 22                	jb     1d37 <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1d15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d19:	48 8b 00             	mov    (%rax),%rax
    1d1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1d20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d24:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1d28:	73 c7                	jae    1cf1 <free+0x2b>
    1d2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d2e:	48 8b 00             	mov    (%rax),%rax
    1d31:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d35:	73 ba                	jae    1cf1 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1d37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d3b:	8b 40 08             	mov    0x8(%rax),%eax
    1d3e:	89 c0                	mov    %eax,%eax
    1d40:	48 c1 e0 04          	shl    $0x4,%rax
    1d44:	48 89 c2             	mov    %rax,%rdx
    1d47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d4b:	48 01 c2             	add    %rax,%rdx
    1d4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d52:	48 8b 00             	mov    (%rax),%rax
    1d55:	48 39 c2             	cmp    %rax,%rdx
    1d58:	75 2d                	jne    1d87 <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d5e:	8b 50 08             	mov    0x8(%rax),%edx
    1d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d65:	48 8b 00             	mov    (%rax),%rax
    1d68:	8b 40 08             	mov    0x8(%rax),%eax
    1d6b:	01 c2                	add    %eax,%edx
    1d6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d71:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1d74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d78:	48 8b 00             	mov    (%rax),%rax
    1d7b:	48 8b 10             	mov    (%rax),%rdx
    1d7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d82:	48 89 10             	mov    %rdx,(%rax)
    1d85:	eb 0e                	jmp    1d95 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1d87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d8b:	48 8b 10             	mov    (%rax),%rdx
    1d8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d92:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1d95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d99:	8b 40 08             	mov    0x8(%rax),%eax
    1d9c:	89 c0                	mov    %eax,%eax
    1d9e:	48 c1 e0 04          	shl    $0x4,%rax
    1da2:	48 89 c2             	mov    %rax,%rdx
    1da5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1da9:	48 01 d0             	add    %rdx,%rax
    1dac:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1db0:	75 27                	jne    1dd9 <free+0x113>
    p->s.size += bp->s.size;
    1db2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1db6:	8b 50 08             	mov    0x8(%rax),%edx
    1db9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dbd:	8b 40 08             	mov    0x8(%rax),%eax
    1dc0:	01 c2                	add    %eax,%edx
    1dc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dc6:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1dc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dcd:	48 8b 10             	mov    (%rax),%rdx
    1dd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd4:	48 89 10             	mov    %rdx,(%rax)
    1dd7:	eb 0b                	jmp    1de4 <free+0x11e>
  } else
    p->s.ptr = bp;
    1dd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ddd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1de1:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1de4:	48 ba 30 22 00 00 00 	movabs $0x2230,%rdx
    1deb:	00 00 00 
    1dee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1df2:	48 89 02             	mov    %rax,(%rdx)
}
    1df5:	90                   	nop
    1df6:	c9                   	leave
    1df7:	c3                   	ret

0000000000001df8 <morecore>:

static Header*
morecore(uint nu)
{
    1df8:	55                   	push   %rbp
    1df9:	48 89 e5             	mov    %rsp,%rbp
    1dfc:	48 83 ec 20          	sub    $0x20,%rsp
    1e00:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1e03:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1e0a:	77 07                	ja     1e13 <morecore+0x1b>
    nu = 4096;
    1e0c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1e13:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1e16:	48 c1 e0 04          	shl    $0x4,%rax
    1e1a:	48 89 c7             	mov    %rax,%rdi
    1e1d:	48 b8 6a 16 00 00 00 	movabs $0x166a,%rax
    1e24:	00 00 00 
    1e27:	ff d0                	call   *%rax
    1e29:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1e2d:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1e32:	75 07                	jne    1e3b <morecore+0x43>
    return 0;
    1e34:	b8 00 00 00 00       	mov    $0x0,%eax
    1e39:	eb 36                	jmp    1e71 <morecore+0x79>
  hp = (Header*)p;
    1e3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e3f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e47:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e4a:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e51:	48 83 c0 10          	add    $0x10,%rax
    1e55:	48 89 c7             	mov    %rax,%rdi
    1e58:	48 b8 c6 1c 00 00 00 	movabs $0x1cc6,%rax
    1e5f:	00 00 00 
    1e62:	ff d0                	call   *%rax
  return freep;
    1e64:	48 b8 30 22 00 00 00 	movabs $0x2230,%rax
    1e6b:	00 00 00 
    1e6e:	48 8b 00             	mov    (%rax),%rax
}
    1e71:	c9                   	leave
    1e72:	c3                   	ret

0000000000001e73 <malloc>:

void*
malloc(uint nbytes)
{
    1e73:	55                   	push   %rbp
    1e74:	48 89 e5             	mov    %rsp,%rbp
    1e77:	48 83 ec 30          	sub    $0x30,%rsp
    1e7b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1e7e:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1e81:	48 83 c0 0f          	add    $0xf,%rax
    1e85:	48 c1 e8 04          	shr    $0x4,%rax
    1e89:	83 c0 01             	add    $0x1,%eax
    1e8c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1e8f:	48 b8 30 22 00 00 00 	movabs $0x2230,%rax
    1e96:	00 00 00 
    1e99:	48 8b 00             	mov    (%rax),%rax
    1e9c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ea0:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1ea5:	75 4a                	jne    1ef1 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1ea7:	48 b8 20 22 00 00 00 	movabs $0x2220,%rax
    1eae:	00 00 00 
    1eb1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1eb5:	48 ba 30 22 00 00 00 	movabs $0x2230,%rdx
    1ebc:	00 00 00 
    1ebf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ec3:	48 89 02             	mov    %rax,(%rdx)
    1ec6:	48 b8 30 22 00 00 00 	movabs $0x2230,%rax
    1ecd:	00 00 00 
    1ed0:	48 8b 00             	mov    (%rax),%rax
    1ed3:	48 ba 20 22 00 00 00 	movabs $0x2220,%rdx
    1eda:	00 00 00 
    1edd:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1ee0:	48 b8 20 22 00 00 00 	movabs $0x2220,%rax
    1ee7:	00 00 00 
    1eea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ef1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ef5:	48 8b 00             	mov    (%rax),%rax
    1ef8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1efc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f00:	8b 40 08             	mov    0x8(%rax),%eax
    1f03:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1f06:	72 65                	jb     1f6d <malloc+0xfa>
      if(p->s.size == nunits)
    1f08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f0c:	8b 40 08             	mov    0x8(%rax),%eax
    1f0f:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1f12:	75 10                	jne    1f24 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1f14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f18:	48 8b 10             	mov    (%rax),%rdx
    1f1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f1f:	48 89 10             	mov    %rdx,(%rax)
    1f22:	eb 2e                	jmp    1f52 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1f24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f28:	8b 40 08             	mov    0x8(%rax),%eax
    1f2b:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1f2e:	89 c2                	mov    %eax,%edx
    1f30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f34:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f3b:	8b 40 08             	mov    0x8(%rax),%eax
    1f3e:	89 c0                	mov    %eax,%eax
    1f40:	48 c1 e0 04          	shl    $0x4,%rax
    1f44:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1f48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f4c:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1f4f:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1f52:	48 ba 30 22 00 00 00 	movabs $0x2230,%rdx
    1f59:	00 00 00 
    1f5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f60:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1f63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f67:	48 83 c0 10          	add    $0x10,%rax
    1f6b:	eb 4e                	jmp    1fbb <malloc+0x148>
    }
    if(p == freep)
    1f6d:	48 b8 30 22 00 00 00 	movabs $0x2230,%rax
    1f74:	00 00 00 
    1f77:	48 8b 00             	mov    (%rax),%rax
    1f7a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f7e:	75 23                	jne    1fa3 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1f80:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1f83:	89 c7                	mov    %eax,%edi
    1f85:	48 b8 f8 1d 00 00 00 	movabs $0x1df8,%rax
    1f8c:	00 00 00 
    1f8f:	ff d0                	call   *%rax
    1f91:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f95:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1f9a:	75 07                	jne    1fa3 <malloc+0x130>
        return 0;
    1f9c:	b8 00 00 00 00       	mov    $0x0,%eax
    1fa1:	eb 18                	jmp    1fbb <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fa7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1fab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1faf:	48 8b 00             	mov    (%rax),%rax
    1fb2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1fb6:	e9 41 ff ff ff       	jmp    1efc <malloc+0x89>
  }
}
    1fbb:	c9                   	leave
    1fbc:	c3                   	ret

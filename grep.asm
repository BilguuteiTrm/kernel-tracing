
_grep:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 30          	sub    $0x30,%rsp
    1008:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
    100c:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  int n, m;
  char *p, *q;

  m = 0;
    100f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    1016:	e9 09 01 00 00       	jmp    1124 <grep+0x124>
    m += n;
    101b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    101e:	01 45 fc             	add    %eax,-0x4(%rbp)
    buf[m] = '\0';
    1021:	48 ba 20 22 00 00 00 	movabs $0x2220,%rdx
    1028:	00 00 00 
    102b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    102e:	48 98                	cltq
    1030:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
    p = buf;
    1034:	48 b8 20 22 00 00 00 	movabs $0x2220,%rax
    103b:	00 00 00 
    103e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    while((q = strchr(p, '\n')) != 0){
    1042:	eb 5e                	jmp    10a2 <grep+0xa2>
      *q = 0;
    1044:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1048:	c6 00 00             	movb   $0x0,(%rax)
      if(match(pattern, p)){
    104b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    104f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1053:	48 89 d6             	mov    %rdx,%rsi
    1056:	48 89 c7             	mov    %rax,%rdi
    1059:	48 b8 b2 12 00 00 00 	movabs $0x12b2,%rax
    1060:	00 00 00 
    1063:	ff d0                	call   *%rax
    1065:	85 c0                	test   %eax,%eax
    1067:	74 2d                	je     1096 <grep+0x96>
        *q = '\n';
    1069:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    106d:	c6 00 0a             	movb   $0xa,(%rax)
        write(1, p, q+1 - p);
    1070:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1074:	48 83 c0 01          	add    $0x1,%rax
    1078:	48 2b 45 f0          	sub    -0x10(%rbp),%rax
    107c:	89 c2                	mov    %eax,%edx
    107e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1082:	48 89 c6             	mov    %rax,%rsi
    1085:	bf 01 00 00 00       	mov    $0x1,%edi
    108a:	48 b8 bd 17 00 00 00 	movabs $0x17bd,%rax
    1091:	00 00 00 
    1094:	ff d0                	call   *%rax
      }
      p = q+1;
    1096:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    109a:	48 83 c0 01          	add    $0x1,%rax
    109e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    while((q = strchr(p, '\n')) != 0){
    10a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    10a6:	be 0a 00 00 00       	mov    $0xa,%esi
    10ab:	48 89 c7             	mov    %rax,%rdi
    10ae:	48 b8 9f 15 00 00 00 	movabs $0x159f,%rax
    10b5:	00 00 00 
    10b8:	ff d0                	call   *%rax
    10ba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10be:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
    10c3:	0f 85 7b ff ff ff    	jne    1044 <grep+0x44>
    }
    if(p == buf)
    10c9:	48 b8 20 22 00 00 00 	movabs $0x2220,%rax
    10d0:	00 00 00 
    10d3:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    10d7:	75 07                	jne    10e0 <grep+0xe0>
      m = 0;
    10d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    if(m > 0){
    10e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    10e4:	7e 3e                	jle    1124 <grep+0x124>
      m -= p - buf;
    10e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10e9:	48 ba 20 22 00 00 00 	movabs $0x2220,%rdx
    10f0:	00 00 00 
    10f3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
    10f7:	48 29 d1             	sub    %rdx,%rcx
    10fa:	89 ca                	mov    %ecx,%edx
    10fc:	29 d0                	sub    %edx,%eax
    10fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
      memmove(buf, p, m);
    1101:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1104:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1108:	48 b9 20 22 00 00 00 	movabs $0x2220,%rcx
    110f:	00 00 00 
    1112:	48 89 c6             	mov    %rax,%rsi
    1115:	48 89 cf             	mov    %rcx,%rdi
    1118:	48 b8 27 17 00 00 00 	movabs $0x1727,%rax
    111f:	00 00 00 
    1122:	ff d0                	call   *%rax
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    1124:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1127:	ba ff 03 00 00       	mov    $0x3ff,%edx
    112c:	29 c2                	sub    %eax,%edx
    112e:	89 d6                	mov    %edx,%esi
    1130:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1133:	48 98                	cltq
    1135:	48 ba 20 22 00 00 00 	movabs $0x2220,%rdx
    113c:	00 00 00 
    113f:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
    1143:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    1146:	89 f2                	mov    %esi,%edx
    1148:	48 89 ce             	mov    %rcx,%rsi
    114b:	89 c7                	mov    %eax,%edi
    114d:	48 b8 b0 17 00 00 00 	movabs $0x17b0,%rax
    1154:	00 00 00 
    1157:	ff d0                	call   *%rax
    1159:	89 45 ec             	mov    %eax,-0x14(%rbp)
    115c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    1160:	0f 8f b5 fe ff ff    	jg     101b <grep+0x1b>
    }
  }
}
    1166:	90                   	nop
    1167:	90                   	nop
    1168:	c9                   	leave
    1169:	c3                   	ret

000000000000116a <main>:

int
main(int argc, char *argv[])
{
    116a:	55                   	push   %rbp
    116b:	48 89 e5             	mov    %rsp,%rbp
    116e:	48 83 ec 30          	sub    $0x30,%rsp
    1172:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1175:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  int fd, i;
  char *pattern;

  if(argc <= 1){
    1179:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
    117d:	7f 2f                	jg     11ae <main+0x44>
    printf(2, "usage: grep pattern [file ...]\n");
    117f:	48 b8 c0 21 00 00 00 	movabs $0x21c0,%rax
    1186:	00 00 00 
    1189:	48 89 c6             	mov    %rax,%rsi
    118c:	bf 02 00 00 00       	mov    $0x2,%edi
    1191:	b8 00 00 00 00       	mov    $0x0,%eax
    1196:	48 ba 97 1a 00 00 00 	movabs $0x1a97,%rdx
    119d:	00 00 00 
    11a0:	ff d2                	call   *%rdx
    exit();
    11a2:	48 b8 89 17 00 00 00 	movabs $0x1789,%rax
    11a9:	00 00 00 
    11ac:	ff d0                	call   *%rax
  }
  pattern = argv[1];
    11ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    11b2:	48 8b 40 08          	mov    0x8(%rax),%rax
    11b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

  if(argc <= 2){
    11ba:	83 7d dc 02          	cmpl   $0x2,-0x24(%rbp)
    11be:	7f 24                	jg     11e4 <main+0x7a>
    grep(pattern, 0);
    11c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11c4:	be 00 00 00 00       	mov    $0x0,%esi
    11c9:	48 89 c7             	mov    %rax,%rdi
    11cc:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    11d3:	00 00 00 
    11d6:	ff d0                	call   *%rax
    exit();
    11d8:	48 b8 89 17 00 00 00 	movabs $0x1789,%rax
    11df:	00 00 00 
    11e2:	ff d0                	call   *%rax
  }

  for(i = 2; i < argc; i++){
    11e4:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
    11eb:	e9 aa 00 00 00       	jmp    129a <main+0x130>
    if((fd = open(argv[i], 0)) < 0){
    11f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11f3:	48 98                	cltq
    11f5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    11fc:	00 
    11fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1201:	48 01 d0             	add    %rdx,%rax
    1204:	48 8b 00             	mov    (%rax),%rax
    1207:	be 00 00 00 00       	mov    $0x0,%esi
    120c:	48 89 c7             	mov    %rax,%rdi
    120f:	48 b8 f1 17 00 00 00 	movabs $0x17f1,%rax
    1216:	00 00 00 
    1219:	ff d0                	call   *%rax
    121b:	89 45 ec             	mov    %eax,-0x14(%rbp)
    121e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    1222:	79 49                	jns    126d <main+0x103>
      printf(1, "grep: cannot open %s\n", argv[i]);
    1224:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1227:	48 98                	cltq
    1229:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1230:	00 
    1231:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1235:	48 01 d0             	add    %rdx,%rax
    1238:	48 8b 00             	mov    (%rax),%rax
    123b:	48 b9 e0 21 00 00 00 	movabs $0x21e0,%rcx
    1242:	00 00 00 
    1245:	48 89 c2             	mov    %rax,%rdx
    1248:	48 89 ce             	mov    %rcx,%rsi
    124b:	bf 01 00 00 00       	mov    $0x1,%edi
    1250:	b8 00 00 00 00       	mov    $0x0,%eax
    1255:	48 b9 97 1a 00 00 00 	movabs $0x1a97,%rcx
    125c:	00 00 00 
    125f:	ff d1                	call   *%rcx
      exit();
    1261:	48 b8 89 17 00 00 00 	movabs $0x1789,%rax
    1268:	00 00 00 
    126b:	ff d0                	call   *%rax
    }
    grep(pattern, fd);
    126d:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1270:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1274:	89 d6                	mov    %edx,%esi
    1276:	48 89 c7             	mov    %rax,%rdi
    1279:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1280:	00 00 00 
    1283:	ff d0                	call   *%rax
    close(fd);
    1285:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1288:	89 c7                	mov    %eax,%edi
    128a:	48 b8 ca 17 00 00 00 	movabs $0x17ca,%rax
    1291:	00 00 00 
    1294:	ff d0                	call   *%rax
  for(i = 2; i < argc; i++){
    1296:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    129a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    129d:	3b 45 dc             	cmp    -0x24(%rbp),%eax
    12a0:	0f 8c 4a ff ff ff    	jl     11f0 <main+0x86>
  }
  exit();
    12a6:	48 b8 89 17 00 00 00 	movabs $0x1789,%rax
    12ad:	00 00 00 
    12b0:	ff d0                	call   *%rax

00000000000012b2 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
    12b2:	55                   	push   %rbp
    12b3:	48 89 e5             	mov    %rsp,%rbp
    12b6:	48 83 ec 10          	sub    $0x10,%rsp
    12ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(re[0] == '^')
    12c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12c6:	0f b6 00             	movzbl (%rax),%eax
    12c9:	3c 5e                	cmp    $0x5e,%al
    12cb:	75 20                	jne    12ed <match+0x3b>
    return matchhere(re+1, text);
    12cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12d1:	48 8d 50 01          	lea    0x1(%rax),%rdx
    12d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    12d9:	48 89 c6             	mov    %rax,%rsi
    12dc:	48 89 d7             	mov    %rdx,%rdi
    12df:	48 b8 2c 13 00 00 00 	movabs $0x132c,%rax
    12e6:	00 00 00 
    12e9:	ff d0                	call   *%rax
    12eb:	eb 3d                	jmp    132a <match+0x78>
  do{  // must look at empty string
    if(matchhere(re, text))
    12ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    12f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12f5:	48 89 d6             	mov    %rdx,%rsi
    12f8:	48 89 c7             	mov    %rax,%rdi
    12fb:	48 b8 2c 13 00 00 00 	movabs $0x132c,%rax
    1302:	00 00 00 
    1305:	ff d0                	call   *%rax
    1307:	85 c0                	test   %eax,%eax
    1309:	74 07                	je     1312 <match+0x60>
      return 1;
    130b:	b8 01 00 00 00       	mov    $0x1,%eax
    1310:	eb 18                	jmp    132a <match+0x78>
  }while(*text++ != '\0');
    1312:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1316:	48 8d 50 01          	lea    0x1(%rax),%rdx
    131a:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
    131e:	0f b6 00             	movzbl (%rax),%eax
    1321:	84 c0                	test   %al,%al
    1323:	75 c8                	jne    12ed <match+0x3b>
  return 0;
    1325:	b8 00 00 00 00       	mov    $0x0,%eax
}
    132a:	c9                   	leave
    132b:	c3                   	ret

000000000000132c <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
    132c:	55                   	push   %rbp
    132d:	48 89 e5             	mov    %rsp,%rbp
    1330:	48 83 ec 10          	sub    $0x10,%rsp
    1334:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1338:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(re[0] == '\0')
    133c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1340:	0f b6 00             	movzbl (%rax),%eax
    1343:	84 c0                	test   %al,%al
    1345:	75 0a                	jne    1351 <matchhere+0x25>
    return 1;
    1347:	b8 01 00 00 00       	mov    $0x1,%eax
    134c:	e9 b4 00 00 00       	jmp    1405 <matchhere+0xd9>
  if(re[1] == '*')
    1351:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1355:	48 83 c0 01          	add    $0x1,%rax
    1359:	0f b6 00             	movzbl (%rax),%eax
    135c:	3c 2a                	cmp    $0x2a,%al
    135e:	75 29                	jne    1389 <matchhere+0x5d>
    return matchstar(re[0], re+2, text);
    1360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1364:	48 8d 48 02          	lea    0x2(%rax),%rcx
    1368:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    136c:	0f b6 00             	movzbl (%rax),%eax
    136f:	0f be c0             	movsbl %al,%eax
    1372:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1376:	48 89 ce             	mov    %rcx,%rsi
    1379:	89 c7                	mov    %eax,%edi
    137b:	48 b8 07 14 00 00 00 	movabs $0x1407,%rax
    1382:	00 00 00 
    1385:	ff d0                	call   *%rax
    1387:	eb 7c                	jmp    1405 <matchhere+0xd9>
  if(re[0] == '$' && re[1] == '\0')
    1389:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    138d:	0f b6 00             	movzbl (%rax),%eax
    1390:	3c 24                	cmp    $0x24,%al
    1392:	75 20                	jne    13b4 <matchhere+0x88>
    1394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1398:	48 83 c0 01          	add    $0x1,%rax
    139c:	0f b6 00             	movzbl (%rax),%eax
    139f:	84 c0                	test   %al,%al
    13a1:	75 11                	jne    13b4 <matchhere+0x88>
    return *text == '\0';
    13a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13a7:	0f b6 00             	movzbl (%rax),%eax
    13aa:	84 c0                	test   %al,%al
    13ac:	0f 94 c0             	sete   %al
    13af:	0f b6 c0             	movzbl %al,%eax
    13b2:	eb 51                	jmp    1405 <matchhere+0xd9>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    13b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13b8:	0f b6 00             	movzbl (%rax),%eax
    13bb:	84 c0                	test   %al,%al
    13bd:	74 41                	je     1400 <matchhere+0xd4>
    13bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13c3:	0f b6 00             	movzbl (%rax),%eax
    13c6:	3c 2e                	cmp    $0x2e,%al
    13c8:	74 12                	je     13dc <matchhere+0xb0>
    13ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13ce:	0f b6 10             	movzbl (%rax),%edx
    13d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13d5:	0f b6 00             	movzbl (%rax),%eax
    13d8:	38 c2                	cmp    %al,%dl
    13da:	75 24                	jne    1400 <matchhere+0xd4>
    return matchhere(re+1, text+1);
    13dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13e0:	48 8d 50 01          	lea    0x1(%rax),%rdx
    13e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13e8:	48 83 c0 01          	add    $0x1,%rax
    13ec:	48 89 d6             	mov    %rdx,%rsi
    13ef:	48 89 c7             	mov    %rax,%rdi
    13f2:	48 b8 2c 13 00 00 00 	movabs $0x132c,%rax
    13f9:	00 00 00 
    13fc:	ff d0                	call   *%rax
    13fe:	eb 05                	jmp    1405 <matchhere+0xd9>
  return 0;
    1400:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1405:	c9                   	leave
    1406:	c3                   	ret

0000000000001407 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
    1407:	55                   	push   %rbp
    1408:	48 89 e5             	mov    %rsp,%rbp
    140b:	48 83 ec 20          	sub    $0x20,%rsp
    140f:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1412:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    1416:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
    141a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    141e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1422:	48 89 d6             	mov    %rdx,%rsi
    1425:	48 89 c7             	mov    %rax,%rdi
    1428:	48 b8 2c 13 00 00 00 	movabs $0x132c,%rax
    142f:	00 00 00 
    1432:	ff d0                	call   *%rax
    1434:	85 c0                	test   %eax,%eax
    1436:	74 07                	je     143f <matchstar+0x38>
      return 1;
    1438:	b8 01 00 00 00       	mov    $0x1,%eax
    143d:	eb 2d                	jmp    146c <matchstar+0x65>
  }while(*text!='\0' && (*text++==c || c=='.'));
    143f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1443:	0f b6 00             	movzbl (%rax),%eax
    1446:	84 c0                	test   %al,%al
    1448:	74 1d                	je     1467 <matchstar+0x60>
    144a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    144e:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1452:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1456:	0f b6 00             	movzbl (%rax),%eax
    1459:	0f be c0             	movsbl %al,%eax
    145c:	39 45 fc             	cmp    %eax,-0x4(%rbp)
    145f:	74 b9                	je     141a <matchstar+0x13>
    1461:	83 7d fc 2e          	cmpl   $0x2e,-0x4(%rbp)
    1465:	74 b3                	je     141a <matchstar+0x13>
  return 0;
    1467:	b8 00 00 00 00       	mov    $0x0,%eax
}
    146c:	c9                   	leave
    146d:	c3                   	ret

000000000000146e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    146e:	55                   	push   %rbp
    146f:	48 89 e5             	mov    %rsp,%rbp
    1472:	48 83 ec 10          	sub    $0x10,%rsp
    1476:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    147a:	89 75 f4             	mov    %esi,-0xc(%rbp)
    147d:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1480:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1484:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1487:	8b 45 f4             	mov    -0xc(%rbp),%eax
    148a:	48 89 ce             	mov    %rcx,%rsi
    148d:	48 89 f7             	mov    %rsi,%rdi
    1490:	89 d1                	mov    %edx,%ecx
    1492:	fc                   	cld
    1493:	f3 aa                	rep stos %al,(%rdi)
    1495:	89 ca                	mov    %ecx,%edx
    1497:	48 89 fe             	mov    %rdi,%rsi
    149a:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    149e:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    14a1:	90                   	nop
    14a2:	c9                   	leave
    14a3:	c3                   	ret

00000000000014a4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    14a4:	55                   	push   %rbp
    14a5:	48 89 e5             	mov    %rsp,%rbp
    14a8:	48 83 ec 20          	sub    $0x20,%rsp
    14ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    14b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    14bc:	90                   	nop
    14bd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    14c1:	48 8d 42 01          	lea    0x1(%rdx),%rax
    14c5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    14c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14cd:	48 8d 48 01          	lea    0x1(%rax),%rcx
    14d1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    14d5:	0f b6 12             	movzbl (%rdx),%edx
    14d8:	88 10                	mov    %dl,(%rax)
    14da:	0f b6 00             	movzbl (%rax),%eax
    14dd:	84 c0                	test   %al,%al
    14df:	75 dc                	jne    14bd <strcpy+0x19>
    ;
  return os;
    14e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    14e5:	c9                   	leave
    14e6:	c3                   	ret

00000000000014e7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    14e7:	55                   	push   %rbp
    14e8:	48 89 e5             	mov    %rsp,%rbp
    14eb:	48 83 ec 10          	sub    $0x10,%rsp
    14ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    14f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    14f7:	eb 0a                	jmp    1503 <strcmp+0x1c>
    p++, q++;
    14f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    14fe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1507:	0f b6 00             	movzbl (%rax),%eax
    150a:	84 c0                	test   %al,%al
    150c:	74 12                	je     1520 <strcmp+0x39>
    150e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1512:	0f b6 10             	movzbl (%rax),%edx
    1515:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1519:	0f b6 00             	movzbl (%rax),%eax
    151c:	38 c2                	cmp    %al,%dl
    151e:	74 d9                	je     14f9 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1520:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1524:	0f b6 00             	movzbl (%rax),%eax
    1527:	0f b6 d0             	movzbl %al,%edx
    152a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    152e:	0f b6 00             	movzbl (%rax),%eax
    1531:	0f b6 c0             	movzbl %al,%eax
    1534:	29 c2                	sub    %eax,%edx
    1536:	89 d0                	mov    %edx,%eax
}
    1538:	c9                   	leave
    1539:	c3                   	ret

000000000000153a <strlen>:

uint
strlen(char *s)
{
    153a:	55                   	push   %rbp
    153b:	48 89 e5             	mov    %rsp,%rbp
    153e:	48 83 ec 18          	sub    $0x18,%rsp
    1542:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1546:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    154d:	eb 04                	jmp    1553 <strlen+0x19>
    154f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1553:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1556:	48 63 d0             	movslq %eax,%rdx
    1559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    155d:	48 01 d0             	add    %rdx,%rax
    1560:	0f b6 00             	movzbl (%rax),%eax
    1563:	84 c0                	test   %al,%al
    1565:	75 e8                	jne    154f <strlen+0x15>
    ;
  return n;
    1567:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    156a:	c9                   	leave
    156b:	c3                   	ret

000000000000156c <memset>:

void*
memset(void *dst, int c, uint n)
{
    156c:	55                   	push   %rbp
    156d:	48 89 e5             	mov    %rsp,%rbp
    1570:	48 83 ec 10          	sub    $0x10,%rsp
    1574:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1578:	89 75 f4             	mov    %esi,-0xc(%rbp)
    157b:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    157e:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1581:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    1584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1588:	89 ce                	mov    %ecx,%esi
    158a:	48 89 c7             	mov    %rax,%rdi
    158d:	48 b8 6e 14 00 00 00 	movabs $0x146e,%rax
    1594:	00 00 00 
    1597:	ff d0                	call   *%rax
  return dst;
    1599:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    159d:	c9                   	leave
    159e:	c3                   	ret

000000000000159f <strchr>:

char*
strchr(const char *s, char c)
{
    159f:	55                   	push   %rbp
    15a0:	48 89 e5             	mov    %rsp,%rbp
    15a3:	48 83 ec 10          	sub    $0x10,%rsp
    15a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    15ab:	89 f0                	mov    %esi,%eax
    15ad:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    15b0:	eb 17                	jmp    15c9 <strchr+0x2a>
    if(*s == c)
    15b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15b6:	0f b6 00             	movzbl (%rax),%eax
    15b9:	38 45 f4             	cmp    %al,-0xc(%rbp)
    15bc:	75 06                	jne    15c4 <strchr+0x25>
      return (char*)s;
    15be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15c2:	eb 15                	jmp    15d9 <strchr+0x3a>
  for(; *s; s++)
    15c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    15c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15cd:	0f b6 00             	movzbl (%rax),%eax
    15d0:	84 c0                	test   %al,%al
    15d2:	75 de                	jne    15b2 <strchr+0x13>
  return 0;
    15d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
    15d9:	c9                   	leave
    15da:	c3                   	ret

00000000000015db <gets>:

char*
gets(char *buf, int max)
{
    15db:	55                   	push   %rbp
    15dc:	48 89 e5             	mov    %rsp,%rbp
    15df:	48 83 ec 20          	sub    $0x20,%rsp
    15e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    15e7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    15ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15f1:	eb 4f                	jmp    1642 <gets+0x67>
    cc = read(0, &c, 1);
    15f3:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    15f7:	ba 01 00 00 00       	mov    $0x1,%edx
    15fc:	48 89 c6             	mov    %rax,%rsi
    15ff:	bf 00 00 00 00       	mov    $0x0,%edi
    1604:	48 b8 b0 17 00 00 00 	movabs $0x17b0,%rax
    160b:	00 00 00 
    160e:	ff d0                	call   *%rax
    1610:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1613:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1617:	7e 36                	jle    164f <gets+0x74>
      break;
    buf[i++] = c;
    1619:	8b 45 fc             	mov    -0x4(%rbp),%eax
    161c:	8d 50 01             	lea    0x1(%rax),%edx
    161f:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1622:	48 63 d0             	movslq %eax,%rdx
    1625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1629:	48 01 c2             	add    %rax,%rdx
    162c:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1630:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1632:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1636:	3c 0a                	cmp    $0xa,%al
    1638:	74 16                	je     1650 <gets+0x75>
    163a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    163e:	3c 0d                	cmp    $0xd,%al
    1640:	74 0e                	je     1650 <gets+0x75>
  for(i=0; i+1 < max; ){
    1642:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1645:	83 c0 01             	add    $0x1,%eax
    1648:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    164b:	7f a6                	jg     15f3 <gets+0x18>
    164d:	eb 01                	jmp    1650 <gets+0x75>
      break;
    164f:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1650:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1653:	48 63 d0             	movslq %eax,%rdx
    1656:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    165a:	48 01 d0             	add    %rdx,%rax
    165d:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1664:	c9                   	leave
    1665:	c3                   	ret

0000000000001666 <stat>:

int
stat(char *n, struct stat *st)
{
    1666:	55                   	push   %rbp
    1667:	48 89 e5             	mov    %rsp,%rbp
    166a:	48 83 ec 20          	sub    $0x20,%rsp
    166e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1672:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    167a:	be 00 00 00 00       	mov    $0x0,%esi
    167f:	48 89 c7             	mov    %rax,%rdi
    1682:	48 b8 f1 17 00 00 00 	movabs $0x17f1,%rax
    1689:	00 00 00 
    168c:	ff d0                	call   *%rax
    168e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1691:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1695:	79 07                	jns    169e <stat+0x38>
    return -1;
    1697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    169c:	eb 2f                	jmp    16cd <stat+0x67>
  r = fstat(fd, st);
    169e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    16a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16a5:	48 89 d6             	mov    %rdx,%rsi
    16a8:	89 c7                	mov    %eax,%edi
    16aa:	48 b8 18 18 00 00 00 	movabs $0x1818,%rax
    16b1:	00 00 00 
    16b4:	ff d0                	call   *%rax
    16b6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    16b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16bc:	89 c7                	mov    %eax,%edi
    16be:	48 b8 ca 17 00 00 00 	movabs $0x17ca,%rax
    16c5:	00 00 00 
    16c8:	ff d0                	call   *%rax
  return r;
    16ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    16cd:	c9                   	leave
    16ce:	c3                   	ret

00000000000016cf <atoi>:

int
atoi(const char *s)
{
    16cf:	55                   	push   %rbp
    16d0:	48 89 e5             	mov    %rsp,%rbp
    16d3:	48 83 ec 18          	sub    $0x18,%rsp
    16d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    16db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    16e2:	eb 28                	jmp    170c <atoi+0x3d>
    n = n*10 + *s++ - '0';
    16e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
    16e7:	89 d0                	mov    %edx,%eax
    16e9:	c1 e0 02             	shl    $0x2,%eax
    16ec:	01 d0                	add    %edx,%eax
    16ee:	01 c0                	add    %eax,%eax
    16f0:	89 c1                	mov    %eax,%ecx
    16f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    16f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
    16fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    16fe:	0f b6 00             	movzbl (%rax),%eax
    1701:	0f be c0             	movsbl %al,%eax
    1704:	01 c8                	add    %ecx,%eax
    1706:	83 e8 30             	sub    $0x30,%eax
    1709:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    170c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1710:	0f b6 00             	movzbl (%rax),%eax
    1713:	3c 2f                	cmp    $0x2f,%al
    1715:	7e 0b                	jle    1722 <atoi+0x53>
    1717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    171b:	0f b6 00             	movzbl (%rax),%eax
    171e:	3c 39                	cmp    $0x39,%al
    1720:	7e c2                	jle    16e4 <atoi+0x15>
  return n;
    1722:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1725:	c9                   	leave
    1726:	c3                   	ret

0000000000001727 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1727:	55                   	push   %rbp
    1728:	48 89 e5             	mov    %rsp,%rbp
    172b:	48 83 ec 28          	sub    $0x28,%rsp
    172f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1733:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1737:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    173a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    173e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1742:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1746:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    174a:	eb 1d                	jmp    1769 <memmove+0x42>
    *dst++ = *src++;
    174c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1750:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1754:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    175c:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1760:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1764:	0f b6 12             	movzbl (%rdx),%edx
    1767:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1769:	8b 45 dc             	mov    -0x24(%rbp),%eax
    176c:	8d 50 ff             	lea    -0x1(%rax),%edx
    176f:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1772:	85 c0                	test   %eax,%eax
    1774:	7f d6                	jg     174c <memmove+0x25>
  return vdst;
    1776:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    177a:	c9                   	leave
    177b:	c3                   	ret

000000000000177c <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    177c:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1783:	49 89 ca             	mov    %rcx,%r10
    1786:	0f 05                	syscall
    1788:	c3                   	ret

0000000000001789 <exit>:
SYSCALL(exit)
    1789:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1790:	49 89 ca             	mov    %rcx,%r10
    1793:	0f 05                	syscall
    1795:	c3                   	ret

0000000000001796 <wait>:
SYSCALL(wait)
    1796:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    179d:	49 89 ca             	mov    %rcx,%r10
    17a0:	0f 05                	syscall
    17a2:	c3                   	ret

00000000000017a3 <pipe>:
SYSCALL(pipe)
    17a3:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    17aa:	49 89 ca             	mov    %rcx,%r10
    17ad:	0f 05                	syscall
    17af:	c3                   	ret

00000000000017b0 <read>:
SYSCALL(read)
    17b0:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    17b7:	49 89 ca             	mov    %rcx,%r10
    17ba:	0f 05                	syscall
    17bc:	c3                   	ret

00000000000017bd <write>:
SYSCALL(write)
    17bd:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    17c4:	49 89 ca             	mov    %rcx,%r10
    17c7:	0f 05                	syscall
    17c9:	c3                   	ret

00000000000017ca <close>:
SYSCALL(close)
    17ca:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    17d1:	49 89 ca             	mov    %rcx,%r10
    17d4:	0f 05                	syscall
    17d6:	c3                   	ret

00000000000017d7 <kill>:
SYSCALL(kill)
    17d7:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    17de:	49 89 ca             	mov    %rcx,%r10
    17e1:	0f 05                	syscall
    17e3:	c3                   	ret

00000000000017e4 <exec>:
SYSCALL(exec)
    17e4:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    17eb:	49 89 ca             	mov    %rcx,%r10
    17ee:	0f 05                	syscall
    17f0:	c3                   	ret

00000000000017f1 <open>:
SYSCALL(open)
    17f1:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    17f8:	49 89 ca             	mov    %rcx,%r10
    17fb:	0f 05                	syscall
    17fd:	c3                   	ret

00000000000017fe <mknod>:
SYSCALL(mknod)
    17fe:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1805:	49 89 ca             	mov    %rcx,%r10
    1808:	0f 05                	syscall
    180a:	c3                   	ret

000000000000180b <unlink>:
SYSCALL(unlink)
    180b:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1812:	49 89 ca             	mov    %rcx,%r10
    1815:	0f 05                	syscall
    1817:	c3                   	ret

0000000000001818 <fstat>:
SYSCALL(fstat)
    1818:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    181f:	49 89 ca             	mov    %rcx,%r10
    1822:	0f 05                	syscall
    1824:	c3                   	ret

0000000000001825 <link>:
SYSCALL(link)
    1825:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    182c:	49 89 ca             	mov    %rcx,%r10
    182f:	0f 05                	syscall
    1831:	c3                   	ret

0000000000001832 <mkdir>:
SYSCALL(mkdir)
    1832:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1839:	49 89 ca             	mov    %rcx,%r10
    183c:	0f 05                	syscall
    183e:	c3                   	ret

000000000000183f <chdir>:
SYSCALL(chdir)
    183f:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1846:	49 89 ca             	mov    %rcx,%r10
    1849:	0f 05                	syscall
    184b:	c3                   	ret

000000000000184c <dup>:
SYSCALL(dup)
    184c:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1853:	49 89 ca             	mov    %rcx,%r10
    1856:	0f 05                	syscall
    1858:	c3                   	ret

0000000000001859 <getpid>:
SYSCALL(getpid)
    1859:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1860:	49 89 ca             	mov    %rcx,%r10
    1863:	0f 05                	syscall
    1865:	c3                   	ret

0000000000001866 <sbrk>:
SYSCALL(sbrk)
    1866:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    186d:	49 89 ca             	mov    %rcx,%r10
    1870:	0f 05                	syscall
    1872:	c3                   	ret

0000000000001873 <sleep>:
SYSCALL(sleep)
    1873:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    187a:	49 89 ca             	mov    %rcx,%r10
    187d:	0f 05                	syscall
    187f:	c3                   	ret

0000000000001880 <uptime>:
SYSCALL(uptime)
    1880:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1887:	49 89 ca             	mov    %rcx,%r10
    188a:	0f 05                	syscall
    188c:	c3                   	ret

000000000000188d <traceread>:
SYSCALL(traceread)
    188d:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1894:	49 89 ca             	mov    %rcx,%r10
    1897:	0f 05                	syscall
    1899:	c3                   	ret

000000000000189a <vidclear>:
SYSCALL(vidclear)
    189a:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    18a1:	49 89 ca             	mov    %rcx,%r10
    18a4:	0f 05                	syscall
    18a6:	c3                   	ret

00000000000018a7 <vidputc>:
SYSCALL(vidputc)
    18a7:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    18ae:	49 89 ca             	mov    %rcx,%r10
    18b1:	0f 05                	syscall
    18b3:	c3                   	ret

00000000000018b4 <vidputs>:
SYSCALL(vidputs)
    18b4:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    18bb:	49 89 ca             	mov    %rcx,%r10
    18be:	0f 05                	syscall
    18c0:	c3                   	ret

00000000000018c1 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    18c1:	55                   	push   %rbp
    18c2:	48 89 e5             	mov    %rsp,%rbp
    18c5:	48 83 ec 10          	sub    $0x10,%rsp
    18c9:	89 7d fc             	mov    %edi,-0x4(%rbp)
    18cc:	89 f0                	mov    %esi,%eax
    18ce:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    18d1:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    18d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    18d8:	ba 01 00 00 00       	mov    $0x1,%edx
    18dd:	48 89 ce             	mov    %rcx,%rsi
    18e0:	89 c7                	mov    %eax,%edi
    18e2:	48 b8 bd 17 00 00 00 	movabs $0x17bd,%rax
    18e9:	00 00 00 
    18ec:	ff d0                	call   *%rax
}
    18ee:	90                   	nop
    18ef:	c9                   	leave
    18f0:	c3                   	ret

00000000000018f1 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    18f1:	55                   	push   %rbp
    18f2:	48 89 e5             	mov    %rsp,%rbp
    18f5:	48 83 ec 20          	sub    $0x20,%rsp
    18f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
    18fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1900:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1907:	eb 35                	jmp    193e <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1909:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    190d:	48 c1 e8 3c          	shr    $0x3c,%rax
    1911:	48 ba 00 22 00 00 00 	movabs $0x2200,%rdx
    1918:	00 00 00 
    191b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    191f:	0f be d0             	movsbl %al,%edx
    1922:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1925:	89 d6                	mov    %edx,%esi
    1927:	89 c7                	mov    %eax,%edi
    1929:	48 b8 c1 18 00 00 00 	movabs $0x18c1,%rax
    1930:	00 00 00 
    1933:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1935:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1939:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    193e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1941:	83 f8 0f             	cmp    $0xf,%eax
    1944:	76 c3                	jbe    1909 <print_x64+0x18>
}
    1946:	90                   	nop
    1947:	90                   	nop
    1948:	c9                   	leave
    1949:	c3                   	ret

000000000000194a <print_x32>:

  static void
print_x32(int fd, uint x)
{
    194a:	55                   	push   %rbp
    194b:	48 89 e5             	mov    %rsp,%rbp
    194e:	48 83 ec 20          	sub    $0x20,%rsp
    1952:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1955:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1958:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    195f:	eb 36                	jmp    1997 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1961:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1964:	c1 e8 1c             	shr    $0x1c,%eax
    1967:	89 c2                	mov    %eax,%edx
    1969:	48 b8 00 22 00 00 00 	movabs $0x2200,%rax
    1970:	00 00 00 
    1973:	89 d2                	mov    %edx,%edx
    1975:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1979:	0f be d0             	movsbl %al,%edx
    197c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    197f:	89 d6                	mov    %edx,%esi
    1981:	89 c7                	mov    %eax,%edi
    1983:	48 b8 c1 18 00 00 00 	movabs $0x18c1,%rax
    198a:	00 00 00 
    198d:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    198f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1993:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    1997:	8b 45 fc             	mov    -0x4(%rbp),%eax
    199a:	83 f8 07             	cmp    $0x7,%eax
    199d:	76 c2                	jbe    1961 <print_x32+0x17>
}
    199f:	90                   	nop
    19a0:	90                   	nop
    19a1:	c9                   	leave
    19a2:	c3                   	ret

00000000000019a3 <print_d>:

  static void
print_d(int fd, int v)
{
    19a3:	55                   	push   %rbp
    19a4:	48 89 e5             	mov    %rsp,%rbp
    19a7:	48 83 ec 30          	sub    $0x30,%rsp
    19ab:	89 7d dc             	mov    %edi,-0x24(%rbp)
    19ae:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    19b1:	8b 45 d8             	mov    -0x28(%rbp),%eax
    19b4:	48 98                	cltq
    19b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    19ba:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    19be:	79 04                	jns    19c4 <print_d+0x21>
    x = -x;
    19c0:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    19c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    19cb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    19cf:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    19d6:	66 66 66 
    19d9:	48 89 c8             	mov    %rcx,%rax
    19dc:	48 f7 ea             	imul   %rdx
    19df:	48 c1 fa 02          	sar    $0x2,%rdx
    19e3:	48 89 c8             	mov    %rcx,%rax
    19e6:	48 c1 f8 3f          	sar    $0x3f,%rax
    19ea:	48 29 c2             	sub    %rax,%rdx
    19ed:	48 89 d0             	mov    %rdx,%rax
    19f0:	48 c1 e0 02          	shl    $0x2,%rax
    19f4:	48 01 d0             	add    %rdx,%rax
    19f7:	48 01 c0             	add    %rax,%rax
    19fa:	48 29 c1             	sub    %rax,%rcx
    19fd:	48 89 ca             	mov    %rcx,%rdx
    1a00:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a03:	8d 48 01             	lea    0x1(%rax),%ecx
    1a06:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1a09:	48 b9 00 22 00 00 00 	movabs $0x2200,%rcx
    1a10:	00 00 00 
    1a13:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1a17:	48 98                	cltq
    1a19:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1a1d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a21:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a28:	66 66 66 
    1a2b:	48 89 c8             	mov    %rcx,%rax
    1a2e:	48 f7 ea             	imul   %rdx
    1a31:	48 89 d0             	mov    %rdx,%rax
    1a34:	48 c1 f8 02          	sar    $0x2,%rax
    1a38:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1a3c:	48 89 ca             	mov    %rcx,%rdx
    1a3f:	48 29 d0             	sub    %rdx,%rax
    1a42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1a46:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1a4b:	0f 85 7a ff ff ff    	jne    19cb <print_d+0x28>

  if (v < 0)
    1a51:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1a55:	79 32                	jns    1a89 <print_d+0xe6>
    buf[i++] = '-';
    1a57:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a5a:	8d 50 01             	lea    0x1(%rax),%edx
    1a5d:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1a60:	48 98                	cltq
    1a62:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1a67:	eb 20                	jmp    1a89 <print_d+0xe6>
    putc(fd, buf[i]);
    1a69:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a6c:	48 98                	cltq
    1a6e:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1a73:	0f be d0             	movsbl %al,%edx
    1a76:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1a79:	89 d6                	mov    %edx,%esi
    1a7b:	89 c7                	mov    %eax,%edi
    1a7d:	48 b8 c1 18 00 00 00 	movabs $0x18c1,%rax
    1a84:	00 00 00 
    1a87:	ff d0                	call   *%rax
  while (--i >= 0)
    1a89:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1a8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1a91:	79 d6                	jns    1a69 <print_d+0xc6>
}
    1a93:	90                   	nop
    1a94:	90                   	nop
    1a95:	c9                   	leave
    1a96:	c3                   	ret

0000000000001a97 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1a97:	55                   	push   %rbp
    1a98:	48 89 e5             	mov    %rsp,%rbp
    1a9b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1aa2:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1aa8:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1aaf:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1ab6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1abd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1ac4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1acb:	84 c0                	test   %al,%al
    1acd:	74 20                	je     1aef <printf+0x58>
    1acf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1ad3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1ad7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1adb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1adf:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1ae3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1ae7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1aeb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1aef:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1af6:	00 00 00 
    1af9:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1b00:	00 00 00 
    1b03:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1b07:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1b0e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1b15:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b1c:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1b23:	00 00 00 
    1b26:	e9 60 03 00 00       	jmp    1e8b <printf+0x3f4>
    if (c != '%') {
    1b2b:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1b32:	74 24                	je     1b58 <printf+0xc1>
      putc(fd, c);
    1b34:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b3a:	0f be d0             	movsbl %al,%edx
    1b3d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b43:	89 d6                	mov    %edx,%esi
    1b45:	89 c7                	mov    %eax,%edi
    1b47:	48 b8 c1 18 00 00 00 	movabs $0x18c1,%rax
    1b4e:	00 00 00 
    1b51:	ff d0                	call   *%rax
      continue;
    1b53:	e9 2c 03 00 00       	jmp    1e84 <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    1b58:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b5f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1b65:	48 63 d0             	movslq %eax,%rdx
    1b68:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1b6f:	48 01 d0             	add    %rdx,%rax
    1b72:	0f b6 00             	movzbl (%rax),%eax
    1b75:	0f be c0             	movsbl %al,%eax
    1b78:	25 ff 00 00 00       	and    $0xff,%eax
    1b7d:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1b83:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1b8a:	0f 84 2e 03 00 00    	je     1ebe <printf+0x427>
      break;
    switch(c) {
    1b90:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1b97:	0f 84 32 01 00 00    	je     1ccf <printf+0x238>
    1b9d:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1ba4:	0f 8f a1 02 00 00    	jg     1e4b <printf+0x3b4>
    1baa:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1bb1:	0f 84 d4 01 00 00    	je     1d8b <printf+0x2f4>
    1bb7:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1bbe:	0f 8f 87 02 00 00    	jg     1e4b <printf+0x3b4>
    1bc4:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1bcb:	0f 84 5b 01 00 00    	je     1d2c <printf+0x295>
    1bd1:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1bd8:	0f 8f 6d 02 00 00    	jg     1e4b <printf+0x3b4>
    1bde:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1be5:	0f 84 87 00 00 00    	je     1c72 <printf+0x1db>
    1beb:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1bf2:	0f 8f 53 02 00 00    	jg     1e4b <printf+0x3b4>
    1bf8:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1bff:	0f 84 2b 02 00 00    	je     1e30 <printf+0x399>
    1c05:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1c0c:	0f 85 39 02 00 00    	jne    1e4b <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    1c12:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c18:	83 f8 2f             	cmp    $0x2f,%eax
    1c1b:	77 23                	ja     1c40 <printf+0x1a9>
    1c1d:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c24:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c2a:	89 d2                	mov    %edx,%edx
    1c2c:	48 01 d0             	add    %rdx,%rax
    1c2f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c35:	83 c2 08             	add    $0x8,%edx
    1c38:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c3e:	eb 12                	jmp    1c52 <printf+0x1bb>
    1c40:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1c47:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1c4b:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1c52:	8b 00                	mov    (%rax),%eax
    1c54:	0f be d0             	movsbl %al,%edx
    1c57:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c5d:	89 d6                	mov    %edx,%esi
    1c5f:	89 c7                	mov    %eax,%edi
    1c61:	48 b8 c1 18 00 00 00 	movabs $0x18c1,%rax
    1c68:	00 00 00 
    1c6b:	ff d0                	call   *%rax
      break;
    1c6d:	e9 12 02 00 00       	jmp    1e84 <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1c72:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c78:	83 f8 2f             	cmp    $0x2f,%eax
    1c7b:	77 23                	ja     1ca0 <printf+0x209>
    1c7d:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c84:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c8a:	89 d2                	mov    %edx,%edx
    1c8c:	48 01 d0             	add    %rdx,%rax
    1c8f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c95:	83 c2 08             	add    $0x8,%edx
    1c98:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c9e:	eb 12                	jmp    1cb2 <printf+0x21b>
    1ca0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ca7:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1cab:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1cb2:	8b 10                	mov    (%rax),%edx
    1cb4:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1cba:	89 d6                	mov    %edx,%esi
    1cbc:	89 c7                	mov    %eax,%edi
    1cbe:	48 b8 a3 19 00 00 00 	movabs $0x19a3,%rax
    1cc5:	00 00 00 
    1cc8:	ff d0                	call   *%rax
      break;
    1cca:	e9 b5 01 00 00       	jmp    1e84 <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1ccf:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1cd5:	83 f8 2f             	cmp    $0x2f,%eax
    1cd8:	77 23                	ja     1cfd <printf+0x266>
    1cda:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ce1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ce7:	89 d2                	mov    %edx,%edx
    1ce9:	48 01 d0             	add    %rdx,%rax
    1cec:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1cf2:	83 c2 08             	add    $0x8,%edx
    1cf5:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1cfb:	eb 12                	jmp    1d0f <printf+0x278>
    1cfd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d04:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d08:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d0f:	8b 10                	mov    (%rax),%edx
    1d11:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d17:	89 d6                	mov    %edx,%esi
    1d19:	89 c7                	mov    %eax,%edi
    1d1b:	48 b8 4a 19 00 00 00 	movabs $0x194a,%rax
    1d22:	00 00 00 
    1d25:	ff d0                	call   *%rax
      break;
    1d27:	e9 58 01 00 00       	jmp    1e84 <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1d2c:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d32:	83 f8 2f             	cmp    $0x2f,%eax
    1d35:	77 23                	ja     1d5a <printf+0x2c3>
    1d37:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d3e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d44:	89 d2                	mov    %edx,%edx
    1d46:	48 01 d0             	add    %rdx,%rax
    1d49:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d4f:	83 c2 08             	add    $0x8,%edx
    1d52:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d58:	eb 12                	jmp    1d6c <printf+0x2d5>
    1d5a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d61:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d65:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d6c:	48 8b 10             	mov    (%rax),%rdx
    1d6f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d75:	48 89 d6             	mov    %rdx,%rsi
    1d78:	89 c7                	mov    %eax,%edi
    1d7a:	48 b8 f1 18 00 00 00 	movabs $0x18f1,%rax
    1d81:	00 00 00 
    1d84:	ff d0                	call   *%rax
      break;
    1d86:	e9 f9 00 00 00       	jmp    1e84 <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1d8b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d91:	83 f8 2f             	cmp    $0x2f,%eax
    1d94:	77 23                	ja     1db9 <printf+0x322>
    1d96:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d9d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1da3:	89 d2                	mov    %edx,%edx
    1da5:	48 01 d0             	add    %rdx,%rax
    1da8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1dae:	83 c2 08             	add    $0x8,%edx
    1db1:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1db7:	eb 12                	jmp    1dcb <printf+0x334>
    1db9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1dc0:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1dc4:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1dcb:	48 8b 00             	mov    (%rax),%rax
    1dce:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1dd5:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1ddc:	00 
    1ddd:	75 41                	jne    1e20 <printf+0x389>
        s = "(null)";
    1ddf:	48 b8 f6 21 00 00 00 	movabs $0x21f6,%rax
    1de6:	00 00 00 
    1de9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1df0:	eb 2e                	jmp    1e20 <printf+0x389>
        putc(fd, *(s++));
    1df2:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1df9:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1dfd:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1e04:	0f b6 00             	movzbl (%rax),%eax
    1e07:	0f be d0             	movsbl %al,%edx
    1e0a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e10:	89 d6                	mov    %edx,%esi
    1e12:	89 c7                	mov    %eax,%edi
    1e14:	48 b8 c1 18 00 00 00 	movabs $0x18c1,%rax
    1e1b:	00 00 00 
    1e1e:	ff d0                	call   *%rax
      while (*s)
    1e20:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e27:	0f b6 00             	movzbl (%rax),%eax
    1e2a:	84 c0                	test   %al,%al
    1e2c:	75 c4                	jne    1df2 <printf+0x35b>
      break;
    1e2e:	eb 54                	jmp    1e84 <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1e30:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e36:	be 25 00 00 00       	mov    $0x25,%esi
    1e3b:	89 c7                	mov    %eax,%edi
    1e3d:	48 b8 c1 18 00 00 00 	movabs $0x18c1,%rax
    1e44:	00 00 00 
    1e47:	ff d0                	call   *%rax
      break;
    1e49:	eb 39                	jmp    1e84 <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1e4b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e51:	be 25 00 00 00       	mov    $0x25,%esi
    1e56:	89 c7                	mov    %eax,%edi
    1e58:	48 b8 c1 18 00 00 00 	movabs $0x18c1,%rax
    1e5f:	00 00 00 
    1e62:	ff d0                	call   *%rax
      putc(fd, c);
    1e64:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1e6a:	0f be d0             	movsbl %al,%edx
    1e6d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e73:	89 d6                	mov    %edx,%esi
    1e75:	89 c7                	mov    %eax,%edi
    1e77:	48 b8 c1 18 00 00 00 	movabs $0x18c1,%rax
    1e7e:	00 00 00 
    1e81:	ff d0                	call   *%rax
      break;
    1e83:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1e84:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1e8b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1e91:	48 63 d0             	movslq %eax,%rdx
    1e94:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1e9b:	48 01 d0             	add    %rdx,%rax
    1e9e:	0f b6 00             	movzbl (%rax),%eax
    1ea1:	0f be c0             	movsbl %al,%eax
    1ea4:	25 ff 00 00 00       	and    $0xff,%eax
    1ea9:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1eaf:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1eb6:	0f 85 6f fc ff ff    	jne    1b2b <printf+0x94>
    }
  }
}
    1ebc:	eb 01                	jmp    1ebf <printf+0x428>
      break;
    1ebe:	90                   	nop
}
    1ebf:	90                   	nop
    1ec0:	c9                   	leave
    1ec1:	c3                   	ret

0000000000001ec2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1ec2:	55                   	push   %rbp
    1ec3:	48 89 e5             	mov    %rsp,%rbp
    1ec6:	48 83 ec 18          	sub    $0x18,%rsp
    1eca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1ece:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1ed2:	48 83 e8 10          	sub    $0x10,%rax
    1ed6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1eda:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    1ee1:	00 00 00 
    1ee4:	48 8b 00             	mov    (%rax),%rax
    1ee7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1eeb:	eb 2f                	jmp    1f1c <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1eed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ef1:	48 8b 00             	mov    (%rax),%rax
    1ef4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ef8:	72 17                	jb     1f11 <free+0x4f>
    1efa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1efe:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f02:	72 2f                	jb     1f33 <free+0x71>
    1f04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f08:	48 8b 00             	mov    (%rax),%rax
    1f0b:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f0f:	72 22                	jb     1f33 <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f15:	48 8b 00             	mov    (%rax),%rax
    1f18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f20:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f24:	73 c7                	jae    1eed <free+0x2b>
    1f26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f2a:	48 8b 00             	mov    (%rax),%rax
    1f2d:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f31:	73 ba                	jae    1eed <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1f33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f37:	8b 40 08             	mov    0x8(%rax),%eax
    1f3a:	89 c0                	mov    %eax,%eax
    1f3c:	48 c1 e0 04          	shl    $0x4,%rax
    1f40:	48 89 c2             	mov    %rax,%rdx
    1f43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f47:	48 01 c2             	add    %rax,%rdx
    1f4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f4e:	48 8b 00             	mov    (%rax),%rax
    1f51:	48 39 c2             	cmp    %rax,%rdx
    1f54:	75 2d                	jne    1f83 <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1f56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f5a:	8b 50 08             	mov    0x8(%rax),%edx
    1f5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f61:	48 8b 00             	mov    (%rax),%rax
    1f64:	8b 40 08             	mov    0x8(%rax),%eax
    1f67:	01 c2                	add    %eax,%edx
    1f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f6d:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1f70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f74:	48 8b 00             	mov    (%rax),%rax
    1f77:	48 8b 10             	mov    (%rax),%rdx
    1f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f7e:	48 89 10             	mov    %rdx,(%rax)
    1f81:	eb 0e                	jmp    1f91 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1f83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f87:	48 8b 10             	mov    (%rax),%rdx
    1f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f8e:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1f91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f95:	8b 40 08             	mov    0x8(%rax),%eax
    1f98:	89 c0                	mov    %eax,%eax
    1f9a:	48 c1 e0 04          	shl    $0x4,%rax
    1f9e:	48 89 c2             	mov    %rax,%rdx
    1fa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fa5:	48 01 d0             	add    %rdx,%rax
    1fa8:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1fac:	75 27                	jne    1fd5 <free+0x113>
    p->s.size += bp->s.size;
    1fae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fb2:	8b 50 08             	mov    0x8(%rax),%edx
    1fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fb9:	8b 40 08             	mov    0x8(%rax),%eax
    1fbc:	01 c2                	add    %eax,%edx
    1fbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fc2:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1fc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fc9:	48 8b 10             	mov    (%rax),%rdx
    1fcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fd0:	48 89 10             	mov    %rdx,(%rax)
    1fd3:	eb 0b                	jmp    1fe0 <free+0x11e>
  } else
    p->s.ptr = bp;
    1fd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1fdd:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1fe0:	48 ba 30 26 00 00 00 	movabs $0x2630,%rdx
    1fe7:	00 00 00 
    1fea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fee:	48 89 02             	mov    %rax,(%rdx)
}
    1ff1:	90                   	nop
    1ff2:	c9                   	leave
    1ff3:	c3                   	ret

0000000000001ff4 <morecore>:

static Header*
morecore(uint nu)
{
    1ff4:	55                   	push   %rbp
    1ff5:	48 89 e5             	mov    %rsp,%rbp
    1ff8:	48 83 ec 20          	sub    $0x20,%rsp
    1ffc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1fff:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    2006:	77 07                	ja     200f <morecore+0x1b>
    nu = 4096;
    2008:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    200f:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2012:	48 c1 e0 04          	shl    $0x4,%rax
    2016:	48 89 c7             	mov    %rax,%rdi
    2019:	48 b8 66 18 00 00 00 	movabs $0x1866,%rax
    2020:	00 00 00 
    2023:	ff d0                	call   *%rax
    2025:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    2029:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    202e:	75 07                	jne    2037 <morecore+0x43>
    return 0;
    2030:	b8 00 00 00 00       	mov    $0x0,%eax
    2035:	eb 36                	jmp    206d <morecore+0x79>
  hp = (Header*)p;
    2037:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    203b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    203f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2043:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2046:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    2049:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    204d:	48 83 c0 10          	add    $0x10,%rax
    2051:	48 89 c7             	mov    %rax,%rdi
    2054:	48 b8 c2 1e 00 00 00 	movabs $0x1ec2,%rax
    205b:	00 00 00 
    205e:	ff d0                	call   *%rax
  return freep;
    2060:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    2067:	00 00 00 
    206a:	48 8b 00             	mov    (%rax),%rax
}
    206d:	c9                   	leave
    206e:	c3                   	ret

000000000000206f <malloc>:

void*
malloc(uint nbytes)
{
    206f:	55                   	push   %rbp
    2070:	48 89 e5             	mov    %rsp,%rbp
    2073:	48 83 ec 30          	sub    $0x30,%rsp
    2077:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    207a:	8b 45 dc             	mov    -0x24(%rbp),%eax
    207d:	48 83 c0 0f          	add    $0xf,%rax
    2081:	48 c1 e8 04          	shr    $0x4,%rax
    2085:	83 c0 01             	add    $0x1,%eax
    2088:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    208b:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    2092:	00 00 00 
    2095:	48 8b 00             	mov    (%rax),%rax
    2098:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    209c:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    20a1:	75 4a                	jne    20ed <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    20a3:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    20aa:	00 00 00 
    20ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20b1:	48 ba 30 26 00 00 00 	movabs $0x2630,%rdx
    20b8:	00 00 00 
    20bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    20bf:	48 89 02             	mov    %rax,(%rdx)
    20c2:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    20c9:	00 00 00 
    20cc:	48 8b 00             	mov    (%rax),%rax
    20cf:	48 ba 20 26 00 00 00 	movabs $0x2620,%rdx
    20d6:	00 00 00 
    20d9:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    20dc:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    20e3:	00 00 00 
    20e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    20ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    20f1:	48 8b 00             	mov    (%rax),%rax
    20f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    20f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20fc:	8b 40 08             	mov    0x8(%rax),%eax
    20ff:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    2102:	72 65                	jb     2169 <malloc+0xfa>
      if(p->s.size == nunits)
    2104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2108:	8b 40 08             	mov    0x8(%rax),%eax
    210b:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    210e:	75 10                	jne    2120 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    2110:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2114:	48 8b 10             	mov    (%rax),%rdx
    2117:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    211b:	48 89 10             	mov    %rdx,(%rax)
    211e:	eb 2e                	jmp    214e <malloc+0xdf>
      else {
        p->s.size -= nunits;
    2120:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2124:	8b 40 08             	mov    0x8(%rax),%eax
    2127:	2b 45 ec             	sub    -0x14(%rbp),%eax
    212a:	89 c2                	mov    %eax,%edx
    212c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2130:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    2133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2137:	8b 40 08             	mov    0x8(%rax),%eax
    213a:	89 c0                	mov    %eax,%eax
    213c:	48 c1 e0 04          	shl    $0x4,%rax
    2140:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    2144:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2148:	8b 55 ec             	mov    -0x14(%rbp),%edx
    214b:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    214e:	48 ba 30 26 00 00 00 	movabs $0x2630,%rdx
    2155:	00 00 00 
    2158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    215c:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    215f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2163:	48 83 c0 10          	add    $0x10,%rax
    2167:	eb 4e                	jmp    21b7 <malloc+0x148>
    }
    if(p == freep)
    2169:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    2170:	00 00 00 
    2173:	48 8b 00             	mov    (%rax),%rax
    2176:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    217a:	75 23                	jne    219f <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    217c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    217f:	89 c7                	mov    %eax,%edi
    2181:	48 b8 f4 1f 00 00 00 	movabs $0x1ff4,%rax
    2188:	00 00 00 
    218b:	ff d0                	call   *%rax
    218d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    2191:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2196:	75 07                	jne    219f <malloc+0x130>
        return 0;
    2198:	b8 00 00 00 00       	mov    $0x0,%eax
    219d:	eb 18                	jmp    21b7 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    219f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    21a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21ab:	48 8b 00             	mov    (%rax),%rax
    21ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    21b2:	e9 41 ff ff ff       	jmp    20f8 <malloc+0x89>
  }
}
    21b7:	c9                   	leave
    21b8:	c3                   	ret


_sh:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <runcmd>:
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Winfinite-recursion"
// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 40          	sub    $0x40,%rsp
    1008:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    100c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
    1011:	75 0c                	jne    101f <runcmd+0x1f>
    exit();
    1013:	48 b8 8b 25 00 00 00 	movabs $0x258b,%rax
    101a:	00 00 00 
    101d:	ff d0                	call   *%rax

  switch(cmd->type){
    101f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    1023:	8b 00                	mov    (%rax),%eax
    1025:	83 f8 05             	cmp    $0x5,%eax
    1028:	0f 84 f6 02 00 00    	je     1324 <runcmd+0x324>
    102e:	83 f8 05             	cmp    $0x5,%eax
    1031:	7f 2a                	jg     105d <runcmd+0x5d>
    1033:	83 f8 04             	cmp    $0x4,%eax
    1036:	0f 84 47 01 00 00    	je     1183 <runcmd+0x183>
    103c:	83 f8 04             	cmp    $0x4,%eax
    103f:	7f 1c                	jg     105d <runcmd+0x5d>
    1041:	83 f8 03             	cmp    $0x3,%eax
    1044:	0f 84 90 01 00 00    	je     11da <runcmd+0x1da>
    104a:	83 f8 03             	cmp    $0x3,%eax
    104d:	7f 0e                	jg     105d <runcmd+0x5d>
    104f:	83 f8 01             	cmp    $0x1,%eax
    1052:	74 22                	je     1076 <runcmd+0x76>
    1054:	83 f8 02             	cmp    $0x2,%eax
    1057:	0f 84 8f 00 00 00    	je     10ec <runcmd+0xec>
  default:
    panic("runcmd");
    105d:	48 b8 bb 2f 00 00 00 	movabs $0x2fbb,%rax
    1064:	00 00 00 
    1067:	48 89 c7             	mov    %rax,%rdi
    106a:	48 b8 5b 15 00 00 00 	movabs $0x155b,%rax
    1071:	00 00 00 
    1074:	ff d0                	call   *%rax

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    1076:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    107a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    if(ecmd->argv[0] == 0)
    107e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1082:	48 8b 40 08          	mov    0x8(%rax),%rax
    1086:	48 85 c0             	test   %rax,%rax
    1089:	75 0c                	jne    1097 <runcmd+0x97>
      exit();
    108b:	48 b8 8b 25 00 00 00 	movabs $0x258b,%rax
    1092:	00 00 00 
    1095:	ff d0                	call   *%rax
    exec(ecmd->argv[0], ecmd->argv);
    1097:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    109b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    109f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    10a3:	48 8b 40 08          	mov    0x8(%rax),%rax
    10a7:	48 89 d6             	mov    %rdx,%rsi
    10aa:	48 89 c7             	mov    %rax,%rdi
    10ad:	48 b8 e6 25 00 00 00 	movabs $0x25e6,%rax
    10b4:	00 00 00 
    10b7:	ff d0                	call   *%rax
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    10b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    10bd:	48 8b 40 08          	mov    0x8(%rax),%rax
    10c1:	48 b9 c2 2f 00 00 00 	movabs $0x2fc2,%rcx
    10c8:	00 00 00 
    10cb:	48 89 c2             	mov    %rax,%rdx
    10ce:	48 89 ce             	mov    %rcx,%rsi
    10d1:	bf 02 00 00 00       	mov    $0x2,%edi
    10d6:	b8 00 00 00 00       	mov    $0x0,%eax
    10db:	48 b9 99 28 00 00 00 	movabs $0x2899,%rcx
    10e2:	00 00 00 
    10e5:	ff d1                	call   *%rcx
    break;
    10e7:	e9 68 02 00 00       	jmp    1354 <runcmd+0x354>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    10ec:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    10f0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    close(rcmd->fd);
    10f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    10f8:	8b 40 24             	mov    0x24(%rax),%eax
    10fb:	89 c7                	mov    %eax,%edi
    10fd:	48 b8 cc 25 00 00 00 	movabs $0x25cc,%rax
    1104:	00 00 00 
    1107:	ff d0                	call   *%rax
    if(open(rcmd->file, rcmd->mode) < 0){
    1109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    110d:	8b 50 20             	mov    0x20(%rax),%edx
    1110:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1114:	48 8b 40 10          	mov    0x10(%rax),%rax
    1118:	89 d6                	mov    %edx,%esi
    111a:	48 89 c7             	mov    %rax,%rdi
    111d:	48 b8 f3 25 00 00 00 	movabs $0x25f3,%rax
    1124:	00 00 00 
    1127:	ff d0                	call   *%rax
    1129:	85 c0                	test   %eax,%eax
    112b:	79 3a                	jns    1167 <runcmd+0x167>
      printf(2, "open %s failed\n", rcmd->file);
    112d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1131:	48 8b 40 10          	mov    0x10(%rax),%rax
    1135:	48 b9 d2 2f 00 00 00 	movabs $0x2fd2,%rcx
    113c:	00 00 00 
    113f:	48 89 c2             	mov    %rax,%rdx
    1142:	48 89 ce             	mov    %rcx,%rsi
    1145:	bf 02 00 00 00       	mov    $0x2,%edi
    114a:	b8 00 00 00 00       	mov    $0x0,%eax
    114f:	48 b9 99 28 00 00 00 	movabs $0x2899,%rcx
    1156:	00 00 00 
    1159:	ff d1                	call   *%rcx
      exit();
    115b:	48 b8 8b 25 00 00 00 	movabs $0x258b,%rax
    1162:	00 00 00 
    1165:	ff d0                	call   *%rax
    }
    runcmd(rcmd->cmd);
    1167:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    116b:	48 8b 40 08          	mov    0x8(%rax),%rax
    116f:	48 89 c7             	mov    %rax,%rdi
    1172:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1179:	00 00 00 
    117c:	ff d0                	call   *%rax
    break;
    117e:	e9 d1 01 00 00       	jmp    1354 <runcmd+0x354>

  case LIST:
    lcmd = (struct listcmd*)cmd;
    1183:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    1187:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(fork1() == 0)
    118b:	48 b8 9d 15 00 00 00 	movabs $0x159d,%rax
    1192:	00 00 00 
    1195:	ff d0                	call   *%rax
    1197:	85 c0                	test   %eax,%eax
    1199:	75 17                	jne    11b2 <runcmd+0x1b2>
      runcmd(lcmd->left);
    119b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    119f:	48 8b 40 08          	mov    0x8(%rax),%rax
    11a3:	48 89 c7             	mov    %rax,%rdi
    11a6:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    11ad:	00 00 00 
    11b0:	ff d0                	call   *%rax
    wait();
    11b2:	48 b8 98 25 00 00 00 	movabs $0x2598,%rax
    11b9:	00 00 00 
    11bc:	ff d0                	call   *%rax
    runcmd(lcmd->right);
    11be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11c2:	48 8b 40 10          	mov    0x10(%rax),%rax
    11c6:	48 89 c7             	mov    %rax,%rdi
    11c9:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    11d0:	00 00 00 
    11d3:	ff d0                	call   *%rax
    break;
    11d5:	e9 7a 01 00 00       	jmp    1354 <runcmd+0x354>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    11da:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    11de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(pipe(p) < 0)
    11e2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    11e6:	48 89 c7             	mov    %rax,%rdi
    11e9:	48 b8 a5 25 00 00 00 	movabs $0x25a5,%rax
    11f0:	00 00 00 
    11f3:	ff d0                	call   *%rax
    11f5:	85 c0                	test   %eax,%eax
    11f7:	79 19                	jns    1212 <runcmd+0x212>
      panic("pipe");
    11f9:	48 b8 e2 2f 00 00 00 	movabs $0x2fe2,%rax
    1200:	00 00 00 
    1203:	48 89 c7             	mov    %rax,%rdi
    1206:	48 b8 5b 15 00 00 00 	movabs $0x155b,%rax
    120d:	00 00 00 
    1210:	ff d0                	call   *%rax
    if(fork1() == 0){
    1212:	48 b8 9d 15 00 00 00 	movabs $0x159d,%rax
    1219:	00 00 00 
    121c:	ff d0                	call   *%rax
    121e:	85 c0                	test   %eax,%eax
    1220:	75 5b                	jne    127d <runcmd+0x27d>
      close(1);
    1222:	bf 01 00 00 00       	mov    $0x1,%edi
    1227:	48 b8 cc 25 00 00 00 	movabs $0x25cc,%rax
    122e:	00 00 00 
    1231:	ff d0                	call   *%rax
      dup(p[1]);
    1233:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    1236:	89 c7                	mov    %eax,%edi
    1238:	48 b8 4e 26 00 00 00 	movabs $0x264e,%rax
    123f:	00 00 00 
    1242:	ff d0                	call   *%rax
      close(p[0]);
    1244:	8b 45 d0             	mov    -0x30(%rbp),%eax
    1247:	89 c7                	mov    %eax,%edi
    1249:	48 b8 cc 25 00 00 00 	movabs $0x25cc,%rax
    1250:	00 00 00 
    1253:	ff d0                	call   *%rax
      close(p[1]);
    1255:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    1258:	89 c7                	mov    %eax,%edi
    125a:	48 b8 cc 25 00 00 00 	movabs $0x25cc,%rax
    1261:	00 00 00 
    1264:	ff d0                	call   *%rax
      runcmd(pcmd->left);
    1266:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    126a:	48 8b 40 08          	mov    0x8(%rax),%rax
    126e:	48 89 c7             	mov    %rax,%rdi
    1271:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1278:	00 00 00 
    127b:	ff d0                	call   *%rax
    }
    if(fork1() == 0){
    127d:	48 b8 9d 15 00 00 00 	movabs $0x159d,%rax
    1284:	00 00 00 
    1287:	ff d0                	call   *%rax
    1289:	85 c0                	test   %eax,%eax
    128b:	75 5b                	jne    12e8 <runcmd+0x2e8>
      close(0);
    128d:	bf 00 00 00 00       	mov    $0x0,%edi
    1292:	48 b8 cc 25 00 00 00 	movabs $0x25cc,%rax
    1299:	00 00 00 
    129c:	ff d0                	call   *%rax
      dup(p[0]);
    129e:	8b 45 d0             	mov    -0x30(%rbp),%eax
    12a1:	89 c7                	mov    %eax,%edi
    12a3:	48 b8 4e 26 00 00 00 	movabs $0x264e,%rax
    12aa:	00 00 00 
    12ad:	ff d0                	call   *%rax
      close(p[0]);
    12af:	8b 45 d0             	mov    -0x30(%rbp),%eax
    12b2:	89 c7                	mov    %eax,%edi
    12b4:	48 b8 cc 25 00 00 00 	movabs $0x25cc,%rax
    12bb:	00 00 00 
    12be:	ff d0                	call   *%rax
      close(p[1]);
    12c0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    12c3:	89 c7                	mov    %eax,%edi
    12c5:	48 b8 cc 25 00 00 00 	movabs $0x25cc,%rax
    12cc:	00 00 00 
    12cf:	ff d0                	call   *%rax
      runcmd(pcmd->right);
    12d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12d5:	48 8b 40 10          	mov    0x10(%rax),%rax
    12d9:	48 89 c7             	mov    %rax,%rdi
    12dc:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    12e3:	00 00 00 
    12e6:	ff d0                	call   *%rax
    }
    close(p[0]);
    12e8:	8b 45 d0             	mov    -0x30(%rbp),%eax
    12eb:	89 c7                	mov    %eax,%edi
    12ed:	48 b8 cc 25 00 00 00 	movabs $0x25cc,%rax
    12f4:	00 00 00 
    12f7:	ff d0                	call   *%rax
    close(p[1]);
    12f9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    12fc:	89 c7                	mov    %eax,%edi
    12fe:	48 b8 cc 25 00 00 00 	movabs $0x25cc,%rax
    1305:	00 00 00 
    1308:	ff d0                	call   *%rax
    wait();
    130a:	48 b8 98 25 00 00 00 	movabs $0x2598,%rax
    1311:	00 00 00 
    1314:	ff d0                	call   *%rax
    wait();
    1316:	48 b8 98 25 00 00 00 	movabs $0x2598,%rax
    131d:	00 00 00 
    1320:	ff d0                	call   *%rax
    break;
    1322:	eb 30                	jmp    1354 <runcmd+0x354>

  case BACK:
    bcmd = (struct backcmd*)cmd;
    1324:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    1328:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(fork1() == 0)
    132c:	48 b8 9d 15 00 00 00 	movabs $0x159d,%rax
    1333:	00 00 00 
    1336:	ff d0                	call   *%rax
    1338:	85 c0                	test   %eax,%eax
    133a:	75 17                	jne    1353 <runcmd+0x353>
      runcmd(bcmd->cmd);
    133c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1340:	48 8b 40 08          	mov    0x8(%rax),%rax
    1344:	48 89 c7             	mov    %rax,%rdi
    1347:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    134e:	00 00 00 
    1351:	ff d0                	call   *%rax
    break;
    1353:	90                   	nop
  }
  exit();
    1354:	48 b8 8b 25 00 00 00 	movabs $0x258b,%rax
    135b:	00 00 00 
    135e:	ff d0                	call   *%rax

0000000000001360 <getcmd>:
}
#pragma GCC diagnostic pop

int
getcmd(char *buf, int nbuf)
{
    1360:	55                   	push   %rbp
    1361:	48 89 e5             	mov    %rsp,%rbp
    1364:	48 83 ec 10          	sub    $0x10,%rsp
    1368:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    136c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  printf(2, "$ ");
    136f:	48 b8 e7 2f 00 00 00 	movabs $0x2fe7,%rax
    1376:	00 00 00 
    1379:	48 89 c6             	mov    %rax,%rsi
    137c:	bf 02 00 00 00       	mov    $0x2,%edi
    1381:	b8 00 00 00 00       	mov    $0x0,%eax
    1386:	48 ba 99 28 00 00 00 	movabs $0x2899,%rdx
    138d:	00 00 00 
    1390:	ff d2                	call   *%rdx
  memset(buf, 0, nbuf);
    1392:	8b 55 f4             	mov    -0xc(%rbp),%edx
    1395:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1399:	be 00 00 00 00       	mov    $0x0,%esi
    139e:	48 89 c7             	mov    %rax,%rdi
    13a1:	48 b8 6e 23 00 00 00 	movabs $0x236e,%rax
    13a8:	00 00 00 
    13ab:	ff d0                	call   *%rax
  gets(buf, nbuf);
    13ad:	8b 55 f4             	mov    -0xc(%rbp),%edx
    13b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13b4:	89 d6                	mov    %edx,%esi
    13b6:	48 89 c7             	mov    %rax,%rdi
    13b9:	48 b8 dd 23 00 00 00 	movabs $0x23dd,%rax
    13c0:	00 00 00 
    13c3:	ff d0                	call   *%rax
  if(buf[0] == 0) // EOF
    13c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13c9:	0f b6 00             	movzbl (%rax),%eax
    13cc:	84 c0                	test   %al,%al
    13ce:	75 07                	jne    13d7 <getcmd+0x77>
    return -1;
    13d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13d5:	eb 05                	jmp    13dc <getcmd+0x7c>
  return 0;
    13d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13dc:	c9                   	leave
    13dd:	c3                   	ret

00000000000013de <main>:

int
main(void)
{
    13de:	55                   	push   %rbp
    13df:	48 89 e5             	mov    %rsp,%rbp
    13e2:	48 83 ec 10          	sub    $0x10,%rsp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    13e6:	eb 19                	jmp    1401 <main+0x23>
    if(fd >= 3){
    13e8:	83 7d fc 02          	cmpl   $0x2,-0x4(%rbp)
    13ec:	7e 13                	jle    1401 <main+0x23>
      close(fd);
    13ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13f1:	89 c7                	mov    %eax,%edi
    13f3:	48 b8 cc 25 00 00 00 	movabs $0x25cc,%rax
    13fa:	00 00 00 
    13fd:	ff d0                	call   *%rax
      break;
    13ff:	eb 27                	jmp    1428 <main+0x4a>
  while((fd = open("console", O_RDWR)) >= 0){
    1401:	48 b8 ea 2f 00 00 00 	movabs $0x2fea,%rax
    1408:	00 00 00 
    140b:	be 02 00 00 00       	mov    $0x2,%esi
    1410:	48 89 c7             	mov    %rax,%rdi
    1413:	48 b8 f3 25 00 00 00 	movabs $0x25f3,%rax
    141a:	00 00 00 
    141d:	ff d0                	call   *%rax
    141f:	89 45 fc             	mov    %eax,-0x4(%rbp)
    1422:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1426:	79 c0                	jns    13e8 <main+0xa>
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    1428:	e9 fc 00 00 00       	jmp    1529 <main+0x14b>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
    142d:	48 b8 c0 30 00 00 00 	movabs $0x30c0,%rax
    1434:	00 00 00 
    1437:	0f b6 00             	movzbl (%rax),%eax
    143a:	3c 63                	cmp    $0x63,%al
    143c:	0f 85 a0 00 00 00    	jne    14e2 <main+0x104>
    1442:	48 b8 c0 30 00 00 00 	movabs $0x30c0,%rax
    1449:	00 00 00 
    144c:	0f b6 40 01          	movzbl 0x1(%rax),%eax
    1450:	3c 64                	cmp    $0x64,%al
    1452:	0f 85 8a 00 00 00    	jne    14e2 <main+0x104>
    1458:	48 b8 c0 30 00 00 00 	movabs $0x30c0,%rax
    145f:	00 00 00 
    1462:	0f b6 40 02          	movzbl 0x2(%rax),%eax
    1466:	3c 20                	cmp    $0x20,%al
    1468:	75 78                	jne    14e2 <main+0x104>
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
    146a:	48 b8 c0 30 00 00 00 	movabs $0x30c0,%rax
    1471:	00 00 00 
    1474:	48 89 c7             	mov    %rax,%rdi
    1477:	48 b8 3c 23 00 00 00 	movabs $0x233c,%rax
    147e:	00 00 00 
    1481:	ff d0                	call   *%rax
    1483:	8d 50 ff             	lea    -0x1(%rax),%edx
    1486:	48 b8 c0 30 00 00 00 	movabs $0x30c0,%rax
    148d:	00 00 00 
    1490:	89 d2                	mov    %edx,%edx
    1492:	c6 04 10 00          	movb   $0x0,(%rax,%rdx,1)
      if(chdir(buf+3) < 0)
    1496:	48 b8 c3 30 00 00 00 	movabs $0x30c3,%rax
    149d:	00 00 00 
    14a0:	48 89 c7             	mov    %rax,%rdi
    14a3:	48 b8 41 26 00 00 00 	movabs $0x2641,%rax
    14aa:	00 00 00 
    14ad:	ff d0                	call   *%rax
    14af:	85 c0                	test   %eax,%eax
    14b1:	79 75                	jns    1528 <main+0x14a>
        printf(2, "cannot cd %s\n", buf+3);
    14b3:	48 ba c3 30 00 00 00 	movabs $0x30c3,%rdx
    14ba:	00 00 00 
    14bd:	48 b8 f2 2f 00 00 00 	movabs $0x2ff2,%rax
    14c4:	00 00 00 
    14c7:	48 89 c6             	mov    %rax,%rsi
    14ca:	bf 02 00 00 00       	mov    $0x2,%edi
    14cf:	b8 00 00 00 00       	mov    $0x0,%eax
    14d4:	48 b9 99 28 00 00 00 	movabs $0x2899,%rcx
    14db:	00 00 00 
    14de:	ff d1                	call   *%rcx
      continue;
    14e0:	eb 46                	jmp    1528 <main+0x14a>
    }
    if(fork1() == 0)
    14e2:	48 b8 9d 15 00 00 00 	movabs $0x159d,%rax
    14e9:	00 00 00 
    14ec:	ff d0                	call   *%rax
    14ee:	85 c0                	test   %eax,%eax
    14f0:	75 28                	jne    151a <main+0x13c>
      runcmd(parsecmd(buf));
    14f2:	48 b8 c0 30 00 00 00 	movabs $0x30c0,%rax
    14f9:	00 00 00 
    14fc:	48 89 c7             	mov    %rax,%rdi
    14ff:	48 b8 3d 1a 00 00 00 	movabs $0x1a3d,%rax
    1506:	00 00 00 
    1509:	ff d0                	call   *%rax
    150b:	48 89 c7             	mov    %rax,%rdi
    150e:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1515:	00 00 00 
    1518:	ff d0                	call   *%rax
    wait();
    151a:	48 b8 98 25 00 00 00 	movabs $0x2598,%rax
    1521:	00 00 00 
    1524:	ff d0                	call   *%rax
    1526:	eb 01                	jmp    1529 <main+0x14b>
      continue;
    1528:	90                   	nop
  while(getcmd(buf, sizeof(buf)) >= 0){
    1529:	48 b8 c0 30 00 00 00 	movabs $0x30c0,%rax
    1530:	00 00 00 
    1533:	be 64 00 00 00       	mov    $0x64,%esi
    1538:	48 89 c7             	mov    %rax,%rdi
    153b:	48 b8 60 13 00 00 00 	movabs $0x1360,%rax
    1542:	00 00 00 
    1545:	ff d0                	call   *%rax
    1547:	85 c0                	test   %eax,%eax
    1549:	0f 89 de fe ff ff    	jns    142d <main+0x4f>
  }
  exit();
    154f:	48 b8 8b 25 00 00 00 	movabs $0x258b,%rax
    1556:	00 00 00 
    1559:	ff d0                	call   *%rax

000000000000155b <panic>:
}

void
panic(char *s)
{
    155b:	55                   	push   %rbp
    155c:	48 89 e5             	mov    %rsp,%rbp
    155f:	48 83 ec 10          	sub    $0x10,%rsp
    1563:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  printf(2, "%s\n", s);
    1567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    156b:	48 b9 00 30 00 00 00 	movabs $0x3000,%rcx
    1572:	00 00 00 
    1575:	48 89 c2             	mov    %rax,%rdx
    1578:	48 89 ce             	mov    %rcx,%rsi
    157b:	bf 02 00 00 00       	mov    $0x2,%edi
    1580:	b8 00 00 00 00       	mov    $0x0,%eax
    1585:	48 b9 99 28 00 00 00 	movabs $0x2899,%rcx
    158c:	00 00 00 
    158f:	ff d1                	call   *%rcx
  exit();
    1591:	48 b8 8b 25 00 00 00 	movabs $0x258b,%rax
    1598:	00 00 00 
    159b:	ff d0                	call   *%rax

000000000000159d <fork1>:
}

int
fork1(void)
{
    159d:	55                   	push   %rbp
    159e:	48 89 e5             	mov    %rsp,%rbp
    15a1:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;

  pid = fork();
    15a5:	48 b8 7e 25 00 00 00 	movabs $0x257e,%rax
    15ac:	00 00 00 
    15af:	ff d0                	call   *%rax
    15b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(pid == -1)
    15b4:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%rbp)
    15b8:	75 19                	jne    15d3 <fork1+0x36>
    panic("fork");
    15ba:	48 b8 04 30 00 00 00 	movabs $0x3004,%rax
    15c1:	00 00 00 
    15c4:	48 89 c7             	mov    %rax,%rdi
    15c7:	48 b8 5b 15 00 00 00 	movabs $0x155b,%rax
    15ce:	00 00 00 
    15d1:	ff d0                	call   *%rax
  return pid;
    15d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    15d6:	c9                   	leave
    15d7:	c3                   	ret

00000000000015d8 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
    15d8:	55                   	push   %rbp
    15d9:	48 89 e5             	mov    %rsp,%rbp
    15dc:	48 83 ec 10          	sub    $0x10,%rsp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    15e0:	bf a8 00 00 00       	mov    $0xa8,%edi
    15e5:	48 b8 71 2e 00 00 00 	movabs $0x2e71,%rax
    15ec:	00 00 00 
    15ef:	ff d0                	call   *%rax
    15f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(cmd, 0, sizeof(*cmd));
    15f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15f9:	ba a8 00 00 00       	mov    $0xa8,%edx
    15fe:	be 00 00 00 00       	mov    $0x0,%esi
    1603:	48 89 c7             	mov    %rax,%rdi
    1606:	48 b8 6e 23 00 00 00 	movabs $0x236e,%rax
    160d:	00 00 00 
    1610:	ff d0                	call   *%rax
  cmd->type = EXEC;
    1612:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1616:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  return (struct cmd*)cmd;
    161c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1620:	c9                   	leave
    1621:	c3                   	ret

0000000000001622 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
    1622:	55                   	push   %rbp
    1623:	48 89 e5             	mov    %rsp,%rbp
    1626:	48 83 ec 30          	sub    $0x30,%rsp
    162a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    162e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1632:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    1636:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
    1639:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
    163d:	bf 28 00 00 00       	mov    $0x28,%edi
    1642:	48 b8 71 2e 00 00 00 	movabs $0x2e71,%rax
    1649:	00 00 00 
    164c:	ff d0                	call   *%rax
    164e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(cmd, 0, sizeof(*cmd));
    1652:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1656:	ba 28 00 00 00       	mov    $0x28,%edx
    165b:	be 00 00 00 00       	mov    $0x0,%esi
    1660:	48 89 c7             	mov    %rax,%rdi
    1663:	48 b8 6e 23 00 00 00 	movabs $0x236e,%rax
    166a:	00 00 00 
    166d:	ff d0                	call   *%rax
  cmd->type = REDIR;
    166f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1673:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
  cmd->cmd = subcmd;
    1679:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    167d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1681:	48 89 50 08          	mov    %rdx,0x8(%rax)
  cmd->file = file;
    1685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1689:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    168d:	48 89 50 10          	mov    %rdx,0x10(%rax)
  cmd->efile = efile;
    1691:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1695:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
    1699:	48 89 50 18          	mov    %rdx,0x18(%rax)
  cmd->mode = mode;
    169d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    16a1:	8b 55 d4             	mov    -0x2c(%rbp),%edx
    16a4:	89 50 20             	mov    %edx,0x20(%rax)
  cmd->fd = fd;
    16a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    16ab:	8b 55 d0             	mov    -0x30(%rbp),%edx
    16ae:	89 50 24             	mov    %edx,0x24(%rax)
  return (struct cmd*)cmd;
    16b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    16b5:	c9                   	leave
    16b6:	c3                   	ret

00000000000016b7 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
    16b7:	55                   	push   %rbp
    16b8:	48 89 e5             	mov    %rsp,%rbp
    16bb:	48 83 ec 20          	sub    $0x20,%rsp
    16bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    16c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
    16c7:	bf 18 00 00 00       	mov    $0x18,%edi
    16cc:	48 b8 71 2e 00 00 00 	movabs $0x2e71,%rax
    16d3:	00 00 00 
    16d6:	ff d0                	call   *%rax
    16d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(cmd, 0, sizeof(*cmd));
    16dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    16e0:	ba 18 00 00 00       	mov    $0x18,%edx
    16e5:	be 00 00 00 00       	mov    $0x0,%esi
    16ea:	48 89 c7             	mov    %rax,%rdi
    16ed:	48 b8 6e 23 00 00 00 	movabs $0x236e,%rax
    16f4:	00 00 00 
    16f7:	ff d0                	call   *%rax
  cmd->type = PIPE;
    16f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    16fd:	c7 00 03 00 00 00    	movl   $0x3,(%rax)
  cmd->left = left;
    1703:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1707:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    170b:	48 89 50 08          	mov    %rdx,0x8(%rax)
  cmd->right = right;
    170f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1713:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1717:	48 89 50 10          	mov    %rdx,0x10(%rax)
  return (struct cmd*)cmd;
    171b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    171f:	c9                   	leave
    1720:	c3                   	ret

0000000000001721 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
    1721:	55                   	push   %rbp
    1722:	48 89 e5             	mov    %rsp,%rbp
    1725:	48 83 ec 20          	sub    $0x20,%rsp
    1729:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    172d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1731:	bf 18 00 00 00       	mov    $0x18,%edi
    1736:	48 b8 71 2e 00 00 00 	movabs $0x2e71,%rax
    173d:	00 00 00 
    1740:	ff d0                	call   *%rax
    1742:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(cmd, 0, sizeof(*cmd));
    1746:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    174a:	ba 18 00 00 00       	mov    $0x18,%edx
    174f:	be 00 00 00 00       	mov    $0x0,%esi
    1754:	48 89 c7             	mov    %rax,%rdi
    1757:	48 b8 6e 23 00 00 00 	movabs $0x236e,%rax
    175e:	00 00 00 
    1761:	ff d0                	call   *%rax
  cmd->type = LIST;
    1763:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1767:	c7 00 04 00 00 00    	movl   $0x4,(%rax)
  cmd->left = left;
    176d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1771:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1775:	48 89 50 08          	mov    %rdx,0x8(%rax)
  cmd->right = right;
    1779:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    177d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1781:	48 89 50 10          	mov    %rdx,0x10(%rax)
  return (struct cmd*)cmd;
    1785:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1789:	c9                   	leave
    178a:	c3                   	ret

000000000000178b <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
    178b:	55                   	push   %rbp
    178c:	48 89 e5             	mov    %rsp,%rbp
    178f:	48 83 ec 20          	sub    $0x20,%rsp
    1793:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1797:	bf 10 00 00 00       	mov    $0x10,%edi
    179c:	48 b8 71 2e 00 00 00 	movabs $0x2e71,%rax
    17a3:	00 00 00 
    17a6:	ff d0                	call   *%rax
    17a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(cmd, 0, sizeof(*cmd));
    17ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    17b0:	ba 10 00 00 00       	mov    $0x10,%edx
    17b5:	be 00 00 00 00       	mov    $0x0,%esi
    17ba:	48 89 c7             	mov    %rax,%rdi
    17bd:	48 b8 6e 23 00 00 00 	movabs $0x236e,%rax
    17c4:	00 00 00 
    17c7:	ff d0                	call   *%rax
  cmd->type = BACK;
    17c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    17cd:	c7 00 05 00 00 00    	movl   $0x5,(%rax)
  cmd->cmd = subcmd;
    17d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    17d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    17db:	48 89 50 08          	mov    %rdx,0x8(%rax)
  return (struct cmd*)cmd;
    17df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    17e3:	c9                   	leave
    17e4:	c3                   	ret

00000000000017e5 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
    17e5:	55                   	push   %rbp
    17e6:	48 89 e5             	mov    %rsp,%rbp
    17e9:	48 83 ec 30          	sub    $0x30,%rsp
    17ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    17f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    17f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    17f9:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  char *s;
  int ret;

  s = *ps;
    17fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1801:	48 8b 00             	mov    (%rax),%rax
    1804:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(s < es && strchr(whitespace, *s))
    1808:	eb 05                	jmp    180f <gettoken+0x2a>
    s++;
    180a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  while(s < es && strchr(whitespace, *s))
    180f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1813:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
    1817:	73 2a                	jae    1843 <gettoken+0x5e>
    1819:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    181d:	0f b6 00             	movzbl (%rax),%eax
    1820:	0f be c0             	movsbl %al,%eax
    1823:	48 ba 90 30 00 00 00 	movabs $0x3090,%rdx
    182a:	00 00 00 
    182d:	89 c6                	mov    %eax,%esi
    182f:	48 89 d7             	mov    %rdx,%rdi
    1832:	48 b8 a1 23 00 00 00 	movabs $0x23a1,%rax
    1839:	00 00 00 
    183c:	ff d0                	call   *%rax
    183e:	48 85 c0             	test   %rax,%rax
    1841:	75 c7                	jne    180a <gettoken+0x25>
  if(q)
    1843:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
    1848:	74 0b                	je     1855 <gettoken+0x70>
    *q = s;
    184a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    184e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    1852:	48 89 10             	mov    %rdx,(%rax)
  ret = *s;
    1855:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1859:	0f b6 00             	movzbl (%rax),%eax
    185c:	0f be c0             	movsbl %al,%eax
    185f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  switch(*s){
    1862:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1866:	0f b6 00             	movzbl (%rax),%eax
    1869:	0f be c0             	movsbl %al,%eax
    186c:	83 f8 7c             	cmp    $0x7c,%eax
    186f:	74 30                	je     18a1 <gettoken+0xbc>
    1871:	83 f8 7c             	cmp    $0x7c,%eax
    1874:	7f 53                	jg     18c9 <gettoken+0xe4>
    1876:	83 f8 3e             	cmp    $0x3e,%eax
    1879:	74 30                	je     18ab <gettoken+0xc6>
    187b:	83 f8 3e             	cmp    $0x3e,%eax
    187e:	7f 49                	jg     18c9 <gettoken+0xe4>
    1880:	83 f8 3c             	cmp    $0x3c,%eax
    1883:	7f 44                	jg     18c9 <gettoken+0xe4>
    1885:	83 f8 3b             	cmp    $0x3b,%eax
    1888:	7d 17                	jge    18a1 <gettoken+0xbc>
    188a:	83 f8 29             	cmp    $0x29,%eax
    188d:	7f 3a                	jg     18c9 <gettoken+0xe4>
    188f:	83 f8 28             	cmp    $0x28,%eax
    1892:	7d 0d                	jge    18a1 <gettoken+0xbc>
    1894:	85 c0                	test   %eax,%eax
    1896:	0f 84 9b 00 00 00    	je     1937 <gettoken+0x152>
    189c:	83 f8 26             	cmp    $0x26,%eax
    189f:	75 28                	jne    18c9 <gettoken+0xe4>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
    18a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    break;
    18a6:	e9 93 00 00 00       	jmp    193e <gettoken+0x159>
  case '>':
    s++;
    18ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    if(*s == '>'){
    18b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    18b4:	0f b6 00             	movzbl (%rax),%eax
    18b7:	3c 3e                	cmp    $0x3e,%al
    18b9:	75 7f                	jne    193a <gettoken+0x155>
      ret = '+';
    18bb:	c7 45 f4 2b 00 00 00 	movl   $0x2b,-0xc(%rbp)
      s++;
    18c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    }
    break;
    18c7:	eb 71                	jmp    193a <gettoken+0x155>
  default:
    ret = 'a';
    18c9:	c7 45 f4 61 00 00 00 	movl   $0x61,-0xc(%rbp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    18d0:	eb 05                	jmp    18d7 <gettoken+0xf2>
      s++;
    18d2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    18d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    18db:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
    18df:	73 5c                	jae    193d <gettoken+0x158>
    18e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    18e5:	0f b6 00             	movzbl (%rax),%eax
    18e8:	0f be c0             	movsbl %al,%eax
    18eb:	48 ba 90 30 00 00 00 	movabs $0x3090,%rdx
    18f2:	00 00 00 
    18f5:	89 c6                	mov    %eax,%esi
    18f7:	48 89 d7             	mov    %rdx,%rdi
    18fa:	48 b8 a1 23 00 00 00 	movabs $0x23a1,%rax
    1901:	00 00 00 
    1904:	ff d0                	call   *%rax
    1906:	48 85 c0             	test   %rax,%rax
    1909:	75 32                	jne    193d <gettoken+0x158>
    190b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    190f:	0f b6 00             	movzbl (%rax),%eax
    1912:	0f be c0             	movsbl %al,%eax
    1915:	48 ba 98 30 00 00 00 	movabs $0x3098,%rdx
    191c:	00 00 00 
    191f:	89 c6                	mov    %eax,%esi
    1921:	48 89 d7             	mov    %rdx,%rdi
    1924:	48 b8 a1 23 00 00 00 	movabs $0x23a1,%rax
    192b:	00 00 00 
    192e:	ff d0                	call   *%rax
    1930:	48 85 c0             	test   %rax,%rax
    1933:	74 9d                	je     18d2 <gettoken+0xed>
    break;
    1935:	eb 06                	jmp    193d <gettoken+0x158>
    break;
    1937:	90                   	nop
    1938:	eb 04                	jmp    193e <gettoken+0x159>
    break;
    193a:	90                   	nop
    193b:	eb 01                	jmp    193e <gettoken+0x159>
    break;
    193d:	90                   	nop
  }
  if(eq)
    193e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
    1943:	74 12                	je     1957 <gettoken+0x172>
    *eq = s;
    1945:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1949:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    194d:	48 89 10             	mov    %rdx,(%rax)

  while(s < es && strchr(whitespace, *s))
    1950:	eb 05                	jmp    1957 <gettoken+0x172>
    s++;
    1952:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  while(s < es && strchr(whitespace, *s))
    1957:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    195b:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
    195f:	73 2a                	jae    198b <gettoken+0x1a6>
    1961:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1965:	0f b6 00             	movzbl (%rax),%eax
    1968:	0f be c0             	movsbl %al,%eax
    196b:	48 ba 90 30 00 00 00 	movabs $0x3090,%rdx
    1972:	00 00 00 
    1975:	89 c6                	mov    %eax,%esi
    1977:	48 89 d7             	mov    %rdx,%rdi
    197a:	48 b8 a1 23 00 00 00 	movabs $0x23a1,%rax
    1981:	00 00 00 
    1984:	ff d0                	call   *%rax
    1986:	48 85 c0             	test   %rax,%rax
    1989:	75 c7                	jne    1952 <gettoken+0x16d>
  *ps = s;
    198b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    198f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    1993:	48 89 10             	mov    %rdx,(%rax)
  return ret;
    1996:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
    1999:	c9                   	leave
    199a:	c3                   	ret

000000000000199b <peek>:

int
peek(char **ps, char *es, char *toks)
{
    199b:	55                   	push   %rbp
    199c:	48 89 e5             	mov    %rsp,%rbp
    199f:	48 83 ec 30          	sub    $0x30,%rsp
    19a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    19a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    19ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  char *s;

  s = *ps;
    19af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    19b3:	48 8b 00             	mov    (%rax),%rax
    19b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(s < es && strchr(whitespace, *s))
    19ba:	eb 05                	jmp    19c1 <peek+0x26>
    s++;
    19bc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  while(s < es && strchr(whitespace, *s))
    19c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    19c5:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
    19c9:	73 2a                	jae    19f5 <peek+0x5a>
    19cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    19cf:	0f b6 00             	movzbl (%rax),%eax
    19d2:	0f be c0             	movsbl %al,%eax
    19d5:	48 ba 90 30 00 00 00 	movabs $0x3090,%rdx
    19dc:	00 00 00 
    19df:	89 c6                	mov    %eax,%esi
    19e1:	48 89 d7             	mov    %rdx,%rdi
    19e4:	48 b8 a1 23 00 00 00 	movabs $0x23a1,%rax
    19eb:	00 00 00 
    19ee:	ff d0                	call   *%rax
    19f0:	48 85 c0             	test   %rax,%rax
    19f3:	75 c7                	jne    19bc <peek+0x21>
  *ps = s;
    19f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    19f9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    19fd:	48 89 10             	mov    %rdx,(%rax)
  return *s && strchr(toks, *s);
    1a00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1a04:	0f b6 00             	movzbl (%rax),%eax
    1a07:	84 c0                	test   %al,%al
    1a09:	74 2b                	je     1a36 <peek+0x9b>
    1a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1a0f:	0f b6 00             	movzbl (%rax),%eax
    1a12:	0f be d0             	movsbl %al,%edx
    1a15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1a19:	89 d6                	mov    %edx,%esi
    1a1b:	48 89 c7             	mov    %rax,%rdi
    1a1e:	48 b8 a1 23 00 00 00 	movabs $0x23a1,%rax
    1a25:	00 00 00 
    1a28:	ff d0                	call   *%rax
    1a2a:	48 85 c0             	test   %rax,%rax
    1a2d:	74 07                	je     1a36 <peek+0x9b>
    1a2f:	b8 01 00 00 00       	mov    $0x1,%eax
    1a34:	eb 05                	jmp    1a3b <peek+0xa0>
    1a36:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1a3b:	c9                   	leave
    1a3c:	c3                   	ret

0000000000001a3d <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
    1a3d:	55                   	push   %rbp
    1a3e:	48 89 e5             	mov    %rsp,%rbp
    1a41:	53                   	push   %rbx
    1a42:	48 83 ec 28          	sub    $0x28,%rsp
    1a46:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
    1a4a:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx
    1a4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1a52:	48 89 c7             	mov    %rax,%rdi
    1a55:	48 b8 3c 23 00 00 00 	movabs $0x233c,%rax
    1a5c:	00 00 00 
    1a5f:	ff d0                	call   *%rax
    1a61:	89 c0                	mov    %eax,%eax
    1a63:	48 01 d8             	add    %rbx,%rax
    1a66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  cmd = parseline(&s, es);
    1a6a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1a6e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
    1a72:	48 89 d6             	mov    %rdx,%rsi
    1a75:	48 89 c7             	mov    %rax,%rdi
    1a78:	48 b8 16 1b 00 00 00 	movabs $0x1b16,%rax
    1a7f:	00 00 00 
    1a82:	ff d0                	call   *%rax
    1a84:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  peek(&s, es, "");
    1a88:	48 ba 09 30 00 00 00 	movabs $0x3009,%rdx
    1a8f:	00 00 00 
    1a92:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
    1a96:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
    1a9a:	48 89 ce             	mov    %rcx,%rsi
    1a9d:	48 89 c7             	mov    %rax,%rdi
    1aa0:	48 b8 9b 19 00 00 00 	movabs $0x199b,%rax
    1aa7:	00 00 00 
    1aaa:	ff d0                	call   *%rax
  if(s != es){
    1aac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1ab0:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
    1ab4:	74 43                	je     1af9 <parsecmd+0xbc>
    printf(2, "leftovers: %s\n", s);
    1ab6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1aba:	48 b9 0a 30 00 00 00 	movabs $0x300a,%rcx
    1ac1:	00 00 00 
    1ac4:	48 89 c2             	mov    %rax,%rdx
    1ac7:	48 89 ce             	mov    %rcx,%rsi
    1aca:	bf 02 00 00 00       	mov    $0x2,%edi
    1acf:	b8 00 00 00 00       	mov    $0x0,%eax
    1ad4:	48 b9 99 28 00 00 00 	movabs $0x2899,%rcx
    1adb:	00 00 00 
    1ade:	ff d1                	call   *%rcx
    panic("syntax");
    1ae0:	48 b8 19 30 00 00 00 	movabs $0x3019,%rax
    1ae7:	00 00 00 
    1aea:	48 89 c7             	mov    %rax,%rdi
    1aed:	48 b8 5b 15 00 00 00 	movabs $0x155b,%rax
    1af4:	00 00 00 
    1af7:	ff d0                	call   *%rax
  }
  nulterminate(cmd);
    1af9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1afd:	48 89 c7             	mov    %rax,%rdi
    1b00:	48 b8 ff 20 00 00 00 	movabs $0x20ff,%rax
    1b07:	00 00 00 
    1b0a:	ff d0                	call   *%rax
  return cmd;
    1b0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
}
    1b10:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
    1b14:	c9                   	leave
    1b15:	c3                   	ret

0000000000001b16 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
    1b16:	55                   	push   %rbp
    1b17:	48 89 e5             	mov    %rsp,%rbp
    1b1a:	48 83 ec 20          	sub    $0x20,%rsp
    1b1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1b22:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
    1b26:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1b2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b2e:	48 89 d6             	mov    %rdx,%rsi
    1b31:	48 89 c7             	mov    %rax,%rdi
    1b34:	48 b8 2c 1c 00 00 00 	movabs $0x1c2c,%rax
    1b3b:	00 00 00 
    1b3e:	ff d0                	call   *%rax
    1b40:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(peek(ps, es, "&")){
    1b44:	eb 38                	jmp    1b7e <parseline+0x68>
    gettoken(ps, es, 0, 0);
    1b46:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
    1b4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b4e:	b9 00 00 00 00       	mov    $0x0,%ecx
    1b53:	ba 00 00 00 00       	mov    $0x0,%edx
    1b58:	48 89 c7             	mov    %rax,%rdi
    1b5b:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    1b62:	00 00 00 
    1b65:	ff d0                	call   *%rax
    cmd = backcmd(cmd);
    1b67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b6b:	48 89 c7             	mov    %rax,%rdi
    1b6e:	48 b8 8b 17 00 00 00 	movabs $0x178b,%rax
    1b75:	00 00 00 
    1b78:	ff d0                	call   *%rax
    1b7a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(peek(ps, es, "&")){
    1b7e:	48 ba 20 30 00 00 00 	movabs $0x3020,%rdx
    1b85:	00 00 00 
    1b88:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
    1b8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b90:	48 89 ce             	mov    %rcx,%rsi
    1b93:	48 89 c7             	mov    %rax,%rdi
    1b96:	48 b8 9b 19 00 00 00 	movabs $0x199b,%rax
    1b9d:	00 00 00 
    1ba0:	ff d0                	call   *%rax
    1ba2:	85 c0                	test   %eax,%eax
    1ba4:	75 a0                	jne    1b46 <parseline+0x30>
  }
  if(peek(ps, es, ";")){
    1ba6:	48 ba 22 30 00 00 00 	movabs $0x3022,%rdx
    1bad:	00 00 00 
    1bb0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
    1bb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1bb8:	48 89 ce             	mov    %rcx,%rsi
    1bbb:	48 89 c7             	mov    %rax,%rdi
    1bbe:	48 b8 9b 19 00 00 00 	movabs $0x199b,%rax
    1bc5:	00 00 00 
    1bc8:	ff d0                	call   *%rax
    1bca:	85 c0                	test   %eax,%eax
    1bcc:	74 58                	je     1c26 <parseline+0x110>
    gettoken(ps, es, 0, 0);
    1bce:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
    1bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1bd6:	b9 00 00 00 00       	mov    $0x0,%ecx
    1bdb:	ba 00 00 00 00       	mov    $0x0,%edx
    1be0:	48 89 c7             	mov    %rax,%rdi
    1be3:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    1bea:	00 00 00 
    1bed:	ff d0                	call   *%rax
    cmd = listcmd(cmd, parseline(ps, es));
    1bef:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1bf7:	48 89 d6             	mov    %rdx,%rsi
    1bfa:	48 89 c7             	mov    %rax,%rdi
    1bfd:	48 b8 16 1b 00 00 00 	movabs $0x1b16,%rax
    1c04:	00 00 00 
    1c07:	ff d0                	call   *%rax
    1c09:	48 89 c2             	mov    %rax,%rdx
    1c0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c10:	48 89 d6             	mov    %rdx,%rsi
    1c13:	48 89 c7             	mov    %rax,%rdi
    1c16:	48 b8 21 17 00 00 00 	movabs $0x1721,%rax
    1c1d:	00 00 00 
    1c20:	ff d0                	call   *%rax
    1c22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  return cmd;
    1c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1c2a:	c9                   	leave
    1c2b:	c3                   	ret

0000000000001c2c <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
    1c2c:	55                   	push   %rbp
    1c2d:	48 89 e5             	mov    %rsp,%rbp
    1c30:	48 83 ec 20          	sub    $0x20,%rsp
    1c34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1c38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct cmd *cmd;

  cmd = parseexec(ps, es);
    1c3c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1c40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c44:	48 89 d6             	mov    %rdx,%rsi
    1c47:	48 89 c7             	mov    %rax,%rdi
    1c4a:	48 b8 49 1f 00 00 00 	movabs $0x1f49,%rax
    1c51:	00 00 00 
    1c54:	ff d0                	call   *%rax
    1c56:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(peek(ps, es, "|")){
    1c5a:	48 ba 24 30 00 00 00 	movabs $0x3024,%rdx
    1c61:	00 00 00 
    1c64:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
    1c68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c6c:	48 89 ce             	mov    %rcx,%rsi
    1c6f:	48 89 c7             	mov    %rax,%rdi
    1c72:	48 b8 9b 19 00 00 00 	movabs $0x199b,%rax
    1c79:	00 00 00 
    1c7c:	ff d0                	call   *%rax
    1c7e:	85 c0                	test   %eax,%eax
    1c80:	74 58                	je     1cda <parsepipe+0xae>
    gettoken(ps, es, 0, 0);
    1c82:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
    1c86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c8a:	b9 00 00 00 00       	mov    $0x0,%ecx
    1c8f:	ba 00 00 00 00       	mov    $0x0,%edx
    1c94:	48 89 c7             	mov    %rax,%rdi
    1c97:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    1c9e:	00 00 00 
    1ca1:	ff d0                	call   *%rax
    cmd = pipecmd(cmd, parsepipe(ps, es));
    1ca3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1ca7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1cab:	48 89 d6             	mov    %rdx,%rsi
    1cae:	48 89 c7             	mov    %rax,%rdi
    1cb1:	48 b8 2c 1c 00 00 00 	movabs $0x1c2c,%rax
    1cb8:	00 00 00 
    1cbb:	ff d0                	call   *%rax
    1cbd:	48 89 c2             	mov    %rax,%rdx
    1cc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cc4:	48 89 d6             	mov    %rdx,%rsi
    1cc7:	48 89 c7             	mov    %rax,%rdi
    1cca:	48 b8 b7 16 00 00 00 	movabs $0x16b7,%rax
    1cd1:	00 00 00 
    1cd4:	ff d0                	call   *%rax
    1cd6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  return cmd;
    1cda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1cde:	c9                   	leave
    1cdf:	c3                   	ret

0000000000001ce0 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
    1ce0:	55                   	push   %rbp
    1ce1:	48 89 e5             	mov    %rsp,%rbp
    1ce4:	48 83 ec 40          	sub    $0x40,%rsp
    1ce8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
    1cec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    1cf0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    1cf4:	e9 04 01 00 00       	jmp    1dfd <parseredirs+0x11d>
    tok = gettoken(ps, es, 0, 0);
    1cf9:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
    1cfd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1d01:	b9 00 00 00 00       	mov    $0x0,%ecx
    1d06:	ba 00 00 00 00       	mov    $0x0,%edx
    1d0b:	48 89 c7             	mov    %rax,%rdi
    1d0e:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    1d15:	00 00 00 
    1d18:	ff d0                	call   *%rax
    1d1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if(gettoken(ps, es, &q, &eq) != 'a')
    1d1d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
    1d21:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
    1d25:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
    1d29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1d2d:	48 89 c7             	mov    %rax,%rdi
    1d30:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    1d37:	00 00 00 
    1d3a:	ff d0                	call   *%rax
    1d3c:	83 f8 61             	cmp    $0x61,%eax
    1d3f:	74 19                	je     1d5a <parseredirs+0x7a>
      panic("missing file for redirection");
    1d41:	48 b8 26 30 00 00 00 	movabs $0x3026,%rax
    1d48:	00 00 00 
    1d4b:	48 89 c7             	mov    %rax,%rdi
    1d4e:	48 b8 5b 15 00 00 00 	movabs $0x155b,%rax
    1d55:	00 00 00 
    1d58:	ff d0                	call   *%rax
    switch(tok){
    1d5a:	83 7d fc 3e          	cmpl   $0x3e,-0x4(%rbp)
    1d5e:	74 46                	je     1da6 <parseredirs+0xc6>
    1d60:	83 7d fc 3e          	cmpl   $0x3e,-0x4(%rbp)
    1d64:	0f 8f 93 00 00 00    	jg     1dfd <parseredirs+0x11d>
    1d6a:	83 7d fc 2b          	cmpl   $0x2b,-0x4(%rbp)
    1d6e:	74 62                	je     1dd2 <parseredirs+0xf2>
    1d70:	83 7d fc 3c          	cmpl   $0x3c,-0x4(%rbp)
    1d74:	0f 85 83 00 00 00    	jne    1dfd <parseredirs+0x11d>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
    1d7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1d7e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
    1d82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1d86:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    1d8c:	b9 00 00 00 00       	mov    $0x0,%ecx
    1d91:	48 89 c7             	mov    %rax,%rdi
    1d94:	48 b8 22 16 00 00 00 	movabs $0x1622,%rax
    1d9b:	00 00 00 
    1d9e:	ff d0                	call   *%rax
    1da0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
      break;
    1da4:	eb 57                	jmp    1dfd <parseredirs+0x11d>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    1da6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1daa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
    1dae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1db2:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    1db8:	b9 01 02 00 00       	mov    $0x201,%ecx
    1dbd:	48 89 c7             	mov    %rax,%rdi
    1dc0:	48 b8 22 16 00 00 00 	movabs $0x1622,%rax
    1dc7:	00 00 00 
    1dca:	ff d0                	call   *%rax
    1dcc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
      break;
    1dd0:	eb 2b                	jmp    1dfd <parseredirs+0x11d>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    1dd2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1dd6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
    1dda:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1dde:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    1de4:	b9 01 02 00 00       	mov    $0x201,%ecx
    1de9:	48 89 c7             	mov    %rax,%rdi
    1dec:	48 b8 22 16 00 00 00 	movabs $0x1622,%rax
    1df3:	00 00 00 
    1df6:	ff d0                	call   *%rax
    1df8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
      break;
    1dfc:	90                   	nop
  while(peek(ps, es, "<>")){
    1dfd:	48 ba 43 30 00 00 00 	movabs $0x3043,%rdx
    1e04:	00 00 00 
    1e07:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
    1e0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1e0f:	48 89 ce             	mov    %rcx,%rsi
    1e12:	48 89 c7             	mov    %rax,%rdi
    1e15:	48 b8 9b 19 00 00 00 	movabs $0x199b,%rax
    1e1c:	00 00 00 
    1e1f:	ff d0                	call   *%rax
    1e21:	85 c0                	test   %eax,%eax
    1e23:	0f 85 d0 fe ff ff    	jne    1cf9 <parseredirs+0x19>
    }
  }
  return cmd;
    1e29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
}
    1e2d:	c9                   	leave
    1e2e:	c3                   	ret

0000000000001e2f <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
    1e2f:	55                   	push   %rbp
    1e30:	48 89 e5             	mov    %rsp,%rbp
    1e33:	48 83 ec 20          	sub    $0x20,%rsp
    1e37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1e3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    1e3f:	48 ba 46 30 00 00 00 	movabs $0x3046,%rdx
    1e46:	00 00 00 
    1e49:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
    1e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e51:	48 89 ce             	mov    %rcx,%rsi
    1e54:	48 89 c7             	mov    %rax,%rdi
    1e57:	48 b8 9b 19 00 00 00 	movabs $0x199b,%rax
    1e5e:	00 00 00 
    1e61:	ff d0                	call   *%rax
    1e63:	85 c0                	test   %eax,%eax
    1e65:	75 19                	jne    1e80 <parseblock+0x51>
    panic("parseblock");
    1e67:	48 b8 48 30 00 00 00 	movabs $0x3048,%rax
    1e6e:	00 00 00 
    1e71:	48 89 c7             	mov    %rax,%rdi
    1e74:	48 b8 5b 15 00 00 00 	movabs $0x155b,%rax
    1e7b:	00 00 00 
    1e7e:	ff d0                	call   *%rax
  gettoken(ps, es, 0, 0);
    1e80:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
    1e84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e88:	b9 00 00 00 00       	mov    $0x0,%ecx
    1e8d:	ba 00 00 00 00       	mov    $0x0,%edx
    1e92:	48 89 c7             	mov    %rax,%rdi
    1e95:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    1e9c:	00 00 00 
    1e9f:	ff d0                	call   *%rax
  cmd = parseline(ps, es);
    1ea1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1ea5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1ea9:	48 89 d6             	mov    %rdx,%rsi
    1eac:	48 89 c7             	mov    %rax,%rdi
    1eaf:	48 b8 16 1b 00 00 00 	movabs $0x1b16,%rax
    1eb6:	00 00 00 
    1eb9:	ff d0                	call   *%rax
    1ebb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(!peek(ps, es, ")"))
    1ebf:	48 ba 53 30 00 00 00 	movabs $0x3053,%rdx
    1ec6:	00 00 00 
    1ec9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
    1ecd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1ed1:	48 89 ce             	mov    %rcx,%rsi
    1ed4:	48 89 c7             	mov    %rax,%rdi
    1ed7:	48 b8 9b 19 00 00 00 	movabs $0x199b,%rax
    1ede:	00 00 00 
    1ee1:	ff d0                	call   *%rax
    1ee3:	85 c0                	test   %eax,%eax
    1ee5:	75 19                	jne    1f00 <parseblock+0xd1>
    panic("syntax - missing )");
    1ee7:	48 b8 55 30 00 00 00 	movabs $0x3055,%rax
    1eee:	00 00 00 
    1ef1:	48 89 c7             	mov    %rax,%rdi
    1ef4:	48 b8 5b 15 00 00 00 	movabs $0x155b,%rax
    1efb:	00 00 00 
    1efe:	ff d0                	call   *%rax
  gettoken(ps, es, 0, 0);
    1f00:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
    1f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f08:	b9 00 00 00 00       	mov    $0x0,%ecx
    1f0d:	ba 00 00 00 00       	mov    $0x0,%edx
    1f12:	48 89 c7             	mov    %rax,%rdi
    1f15:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    1f1c:	00 00 00 
    1f1f:	ff d0                	call   *%rax
  cmd = parseredirs(cmd, ps, es);
    1f21:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1f25:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
    1f29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f2d:	48 89 ce             	mov    %rcx,%rsi
    1f30:	48 89 c7             	mov    %rax,%rdi
    1f33:	48 b8 e0 1c 00 00 00 	movabs $0x1ce0,%rax
    1f3a:	00 00 00 
    1f3d:	ff d0                	call   *%rax
    1f3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return cmd;
    1f43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1f47:	c9                   	leave
    1f48:	c3                   	ret

0000000000001f49 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
    1f49:	55                   	push   %rbp
    1f4a:	48 89 e5             	mov    %rsp,%rbp
    1f4d:	48 83 ec 40          	sub    $0x40,%rsp
    1f51:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
    1f55:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    1f59:	48 ba 46 30 00 00 00 	movabs $0x3046,%rdx
    1f60:	00 00 00 
    1f63:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
    1f67:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    1f6b:	48 89 ce             	mov    %rcx,%rsi
    1f6e:	48 89 c7             	mov    %rax,%rdi
    1f71:	48 b8 9b 19 00 00 00 	movabs $0x199b,%rax
    1f78:	00 00 00 
    1f7b:	ff d0                	call   *%rax
    1f7d:	85 c0                	test   %eax,%eax
    1f7f:	74 1f                	je     1fa0 <parseexec+0x57>
    return parseblock(ps, es);
    1f81:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
    1f85:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    1f89:	48 89 d6             	mov    %rdx,%rsi
    1f8c:	48 89 c7             	mov    %rax,%rdi
    1f8f:	48 b8 2f 1e 00 00 00 	movabs $0x1e2f,%rax
    1f96:	00 00 00 
    1f99:	ff d0                	call   *%rax
    1f9b:	e9 5d 01 00 00       	jmp    20fd <parseexec+0x1b4>

  ret = execcmd();
    1fa0:	48 b8 d8 15 00 00 00 	movabs $0x15d8,%rax
    1fa7:	00 00 00 
    1faa:	ff d0                	call   *%rax
    1fac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  cmd = (struct execcmd*)ret;
    1fb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fb4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  argc = 0;
    1fb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  ret = parseredirs(ret, ps, es);
    1fbf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
    1fc3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
    1fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fcb:	48 89 ce             	mov    %rcx,%rsi
    1fce:	48 89 c7             	mov    %rax,%rdi
    1fd1:	48 b8 e0 1c 00 00 00 	movabs $0x1ce0,%rax
    1fd8:	00 00 00 
    1fdb:	ff d0                	call   *%rax
    1fdd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(!peek(ps, es, "|)&;")){
    1fe1:	e9 ba 00 00 00       	jmp    20a0 <parseexec+0x157>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
    1fe6:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
    1fea:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
    1fee:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
    1ff2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    1ff6:	48 89 c7             	mov    %rax,%rdi
    1ff9:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    2000:	00 00 00 
    2003:	ff d0                	call   *%rax
    2005:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    2008:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    200c:	0f 84 bc 00 00 00    	je     20ce <parseexec+0x185>
      break;
    if(tok != 'a')
    2012:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
    2016:	74 19                	je     2031 <parseexec+0xe8>
      panic("syntax");
    2018:	48 b8 19 30 00 00 00 	movabs $0x3019,%rax
    201f:	00 00 00 
    2022:	48 89 c7             	mov    %rax,%rdi
    2025:	48 b8 5b 15 00 00 00 	movabs $0x155b,%rax
    202c:	00 00 00 
    202f:	ff d0                	call   *%rax
    cmd->argv[argc] = q;
    2031:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
    2035:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2039:	8b 55 fc             	mov    -0x4(%rbp),%edx
    203c:	48 63 d2             	movslq %edx,%rdx
    203f:	48 89 4c d0 08       	mov    %rcx,0x8(%rax,%rdx,8)
    cmd->eargv[argc] = eq;
    2044:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
    2048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    204c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    204f:	48 63 c9             	movslq %ecx,%rcx
    2052:	48 83 c1 0a          	add    $0xa,%rcx
    2056:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
    argc++;
    205b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    if(argc >= MAXARGS)
    205f:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
    2063:	7e 19                	jle    207e <parseexec+0x135>
      panic("too many args");
    2065:	48 b8 68 30 00 00 00 	movabs $0x3068,%rax
    206c:	00 00 00 
    206f:	48 89 c7             	mov    %rax,%rdi
    2072:	48 b8 5b 15 00 00 00 	movabs $0x155b,%rax
    2079:	00 00 00 
    207c:	ff d0                	call   *%rax
    ret = parseredirs(ret, ps, es);
    207e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
    2082:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
    2086:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    208a:	48 89 ce             	mov    %rcx,%rsi
    208d:	48 89 c7             	mov    %rax,%rdi
    2090:	48 b8 e0 1c 00 00 00 	movabs $0x1ce0,%rax
    2097:	00 00 00 
    209a:	ff d0                	call   *%rax
    209c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(!peek(ps, es, "|)&;")){
    20a0:	48 ba 76 30 00 00 00 	movabs $0x3076,%rdx
    20a7:	00 00 00 
    20aa:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
    20ae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    20b2:	48 89 ce             	mov    %rcx,%rsi
    20b5:	48 89 c7             	mov    %rax,%rdi
    20b8:	48 b8 9b 19 00 00 00 	movabs $0x199b,%rax
    20bf:	00 00 00 
    20c2:	ff d0                	call   *%rax
    20c4:	85 c0                	test   %eax,%eax
    20c6:	0f 84 1a ff ff ff    	je     1fe6 <parseexec+0x9d>
    20cc:	eb 01                	jmp    20cf <parseexec+0x186>
      break;
    20ce:	90                   	nop
  }
  cmd->argv[argc] = 0;
    20cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    20d3:	8b 55 fc             	mov    -0x4(%rbp),%edx
    20d6:	48 63 d2             	movslq %edx,%rdx
    20d9:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
    20e0:	00 00 
  cmd->eargv[argc] = 0;
    20e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    20e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
    20e9:	48 63 d2             	movslq %edx,%rdx
    20ec:	48 83 c2 0a          	add    $0xa,%rdx
    20f0:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
    20f7:	00 00 
  return ret;
    20f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    20fd:	c9                   	leave
    20fe:	c3                   	ret

00000000000020ff <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
    20ff:	55                   	push   %rbp
    2100:	48 89 e5             	mov    %rsp,%rbp
    2103:	48 83 ec 40          	sub    $0x40,%rsp
    2107:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    210b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
    2110:	75 0a                	jne    211c <nulterminate+0x1d>
    return 0;
    2112:	b8 00 00 00 00       	mov    $0x0,%eax
    2117:	e9 52 01 00 00       	jmp    226e <nulterminate+0x16f>

  switch(cmd->type){
    211c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    2120:	8b 00                	mov    (%rax),%eax
    2122:	83 f8 05             	cmp    $0x5,%eax
    2125:	0f 84 1f 01 00 00    	je     224a <nulterminate+0x14b>
    212b:	83 f8 05             	cmp    $0x5,%eax
    212e:	0f 8f 36 01 00 00    	jg     226a <nulterminate+0x16b>
    2134:	83 f8 04             	cmp    $0x4,%eax
    2137:	0f 84 d5 00 00 00    	je     2212 <nulterminate+0x113>
    213d:	83 f8 04             	cmp    $0x4,%eax
    2140:	0f 8f 24 01 00 00    	jg     226a <nulterminate+0x16b>
    2146:	83 f8 03             	cmp    $0x3,%eax
    2149:	0f 84 8b 00 00 00    	je     21da <nulterminate+0xdb>
    214f:	83 f8 03             	cmp    $0x3,%eax
    2152:	0f 8f 12 01 00 00    	jg     226a <nulterminate+0x16b>
    2158:	83 f8 01             	cmp    $0x1,%eax
    215b:	74 0a                	je     2167 <nulterminate+0x68>
    215d:	83 f8 02             	cmp    $0x2,%eax
    2160:	74 49                	je     21ab <nulterminate+0xac>
    2162:	e9 03 01 00 00       	jmp    226a <nulterminate+0x16b>
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    2167:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    216b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    for(i=0; ecmd->argv[i]; i++)
    216f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2176:	eb 1a                	jmp    2192 <nulterminate+0x93>
      *ecmd->eargv[i] = 0;
    2178:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    217c:	8b 55 fc             	mov    -0x4(%rbp),%edx
    217f:	48 63 d2             	movslq %edx,%rdx
    2182:	48 83 c2 0a          	add    $0xa,%rdx
    2186:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
    218b:	c6 00 00             	movb   $0x0,(%rax)
    for(i=0; ecmd->argv[i]; i++)
    218e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2192:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    2196:	8b 55 fc             	mov    -0x4(%rbp),%edx
    2199:	48 63 d2             	movslq %edx,%rdx
    219c:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
    21a1:	48 85 c0             	test   %rax,%rax
    21a4:	75 d2                	jne    2178 <nulterminate+0x79>
    break;
    21a6:	e9 bf 00 00 00       	jmp    226a <nulterminate+0x16b>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    21ab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    21af:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    nulterminate(rcmd->cmd);
    21b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    21b7:	48 8b 40 08          	mov    0x8(%rax),%rax
    21bb:	48 89 c7             	mov    %rax,%rdi
    21be:	48 b8 ff 20 00 00 00 	movabs $0x20ff,%rax
    21c5:	00 00 00 
    21c8:	ff d0                	call   *%rax
    *rcmd->efile = 0;
    21ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    21ce:	48 8b 40 18          	mov    0x18(%rax),%rax
    21d2:	c6 00 00             	movb   $0x0,(%rax)
    break;
    21d5:	e9 90 00 00 00       	jmp    226a <nulterminate+0x16b>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    21da:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    21de:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    nulterminate(pcmd->left);
    21e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    21e6:	48 8b 40 08          	mov    0x8(%rax),%rax
    21ea:	48 89 c7             	mov    %rax,%rdi
    21ed:	48 b8 ff 20 00 00 00 	movabs $0x20ff,%rax
    21f4:	00 00 00 
    21f7:	ff d0                	call   *%rax
    nulterminate(pcmd->right);
    21f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    21fd:	48 8b 40 10          	mov    0x10(%rax),%rax
    2201:	48 89 c7             	mov    %rax,%rdi
    2204:	48 b8 ff 20 00 00 00 	movabs $0x20ff,%rax
    220b:	00 00 00 
    220e:	ff d0                	call   *%rax
    break;
    2210:	eb 58                	jmp    226a <nulterminate+0x16b>

  case LIST:
    lcmd = (struct listcmd*)cmd;
    2212:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    2216:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    nulterminate(lcmd->left);
    221a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    221e:	48 8b 40 08          	mov    0x8(%rax),%rax
    2222:	48 89 c7             	mov    %rax,%rdi
    2225:	48 b8 ff 20 00 00 00 	movabs $0x20ff,%rax
    222c:	00 00 00 
    222f:	ff d0                	call   *%rax
    nulterminate(lcmd->right);
    2231:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2235:	48 8b 40 10          	mov    0x10(%rax),%rax
    2239:	48 89 c7             	mov    %rax,%rdi
    223c:	48 b8 ff 20 00 00 00 	movabs $0x20ff,%rax
    2243:	00 00 00 
    2246:	ff d0                	call   *%rax
    break;
    2248:	eb 20                	jmp    226a <nulterminate+0x16b>

  case BACK:
    bcmd = (struct backcmd*)cmd;
    224a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    224e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    nulterminate(bcmd->cmd);
    2252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2256:	48 8b 40 08          	mov    0x8(%rax),%rax
    225a:	48 89 c7             	mov    %rax,%rdi
    225d:	48 b8 ff 20 00 00 00 	movabs $0x20ff,%rax
    2264:	00 00 00 
    2267:	ff d0                	call   *%rax
    break;
    2269:	90                   	nop
  }
  return cmd;
    226a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
    226e:	c9                   	leave
    226f:	c3                   	ret

0000000000002270 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    2270:	55                   	push   %rbp
    2271:	48 89 e5             	mov    %rsp,%rbp
    2274:	48 83 ec 10          	sub    $0x10,%rsp
    2278:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    227c:	89 75 f4             	mov    %esi,-0xc(%rbp)
    227f:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    2282:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    2286:	8b 55 f0             	mov    -0x10(%rbp),%edx
    2289:	8b 45 f4             	mov    -0xc(%rbp),%eax
    228c:	48 89 ce             	mov    %rcx,%rsi
    228f:	48 89 f7             	mov    %rsi,%rdi
    2292:	89 d1                	mov    %edx,%ecx
    2294:	fc                   	cld
    2295:	f3 aa                	rep stos %al,(%rdi)
    2297:	89 ca                	mov    %ecx,%edx
    2299:	48 89 fe             	mov    %rdi,%rsi
    229c:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    22a0:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    22a3:	90                   	nop
    22a4:	c9                   	leave
    22a5:	c3                   	ret

00000000000022a6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    22a6:	55                   	push   %rbp
    22a7:	48 89 e5             	mov    %rsp,%rbp
    22aa:	48 83 ec 20          	sub    $0x20,%rsp
    22ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    22b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    22b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    22ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    22be:	90                   	nop
    22bf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    22c3:	48 8d 42 01          	lea    0x1(%rdx),%rax
    22c7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    22cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    22cf:	48 8d 48 01          	lea    0x1(%rax),%rcx
    22d3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    22d7:	0f b6 12             	movzbl (%rdx),%edx
    22da:	88 10                	mov    %dl,(%rax)
    22dc:	0f b6 00             	movzbl (%rax),%eax
    22df:	84 c0                	test   %al,%al
    22e1:	75 dc                	jne    22bf <strcpy+0x19>
    ;
  return os;
    22e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    22e7:	c9                   	leave
    22e8:	c3                   	ret

00000000000022e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    22e9:	55                   	push   %rbp
    22ea:	48 89 e5             	mov    %rsp,%rbp
    22ed:	48 83 ec 10          	sub    $0x10,%rsp
    22f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    22f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    22f9:	eb 0a                	jmp    2305 <strcmp+0x1c>
    p++, q++;
    22fb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    2300:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    2305:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2309:	0f b6 00             	movzbl (%rax),%eax
    230c:	84 c0                	test   %al,%al
    230e:	74 12                	je     2322 <strcmp+0x39>
    2310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2314:	0f b6 10             	movzbl (%rax),%edx
    2317:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    231b:	0f b6 00             	movzbl (%rax),%eax
    231e:	38 c2                	cmp    %al,%dl
    2320:	74 d9                	je     22fb <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    2322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2326:	0f b6 00             	movzbl (%rax),%eax
    2329:	0f b6 d0             	movzbl %al,%edx
    232c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2330:	0f b6 00             	movzbl (%rax),%eax
    2333:	0f b6 c0             	movzbl %al,%eax
    2336:	29 c2                	sub    %eax,%edx
    2338:	89 d0                	mov    %edx,%eax
}
    233a:	c9                   	leave
    233b:	c3                   	ret

000000000000233c <strlen>:

uint
strlen(char *s)
{
    233c:	55                   	push   %rbp
    233d:	48 89 e5             	mov    %rsp,%rbp
    2340:	48 83 ec 18          	sub    $0x18,%rsp
    2344:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    2348:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    234f:	eb 04                	jmp    2355 <strlen+0x19>
    2351:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2355:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2358:	48 63 d0             	movslq %eax,%rdx
    235b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    235f:	48 01 d0             	add    %rdx,%rax
    2362:	0f b6 00             	movzbl (%rax),%eax
    2365:	84 c0                	test   %al,%al
    2367:	75 e8                	jne    2351 <strlen+0x15>
    ;
  return n;
    2369:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    236c:	c9                   	leave
    236d:	c3                   	ret

000000000000236e <memset>:

void*
memset(void *dst, int c, uint n)
{
    236e:	55                   	push   %rbp
    236f:	48 89 e5             	mov    %rsp,%rbp
    2372:	48 83 ec 10          	sub    $0x10,%rsp
    2376:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    237a:	89 75 f4             	mov    %esi,-0xc(%rbp)
    237d:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    2380:	8b 55 f0             	mov    -0x10(%rbp),%edx
    2383:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    2386:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    238a:	89 ce                	mov    %ecx,%esi
    238c:	48 89 c7             	mov    %rax,%rdi
    238f:	48 b8 70 22 00 00 00 	movabs $0x2270,%rax
    2396:	00 00 00 
    2399:	ff d0                	call   *%rax
  return dst;
    239b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    239f:	c9                   	leave
    23a0:	c3                   	ret

00000000000023a1 <strchr>:

char*
strchr(const char *s, char c)
{
    23a1:	55                   	push   %rbp
    23a2:	48 89 e5             	mov    %rsp,%rbp
    23a5:	48 83 ec 10          	sub    $0x10,%rsp
    23a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    23ad:	89 f0                	mov    %esi,%eax
    23af:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    23b2:	eb 17                	jmp    23cb <strchr+0x2a>
    if(*s == c)
    23b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    23b8:	0f b6 00             	movzbl (%rax),%eax
    23bb:	38 45 f4             	cmp    %al,-0xc(%rbp)
    23be:	75 06                	jne    23c6 <strchr+0x25>
      return (char*)s;
    23c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    23c4:	eb 15                	jmp    23db <strchr+0x3a>
  for(; *s; s++)
    23c6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    23cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    23cf:	0f b6 00             	movzbl (%rax),%eax
    23d2:	84 c0                	test   %al,%al
    23d4:	75 de                	jne    23b4 <strchr+0x13>
  return 0;
    23d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
    23db:	c9                   	leave
    23dc:	c3                   	ret

00000000000023dd <gets>:

char*
gets(char *buf, int max)
{
    23dd:	55                   	push   %rbp
    23de:	48 89 e5             	mov    %rsp,%rbp
    23e1:	48 83 ec 20          	sub    $0x20,%rsp
    23e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    23e9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    23ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    23f3:	eb 4f                	jmp    2444 <gets+0x67>
    cc = read(0, &c, 1);
    23f5:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    23f9:	ba 01 00 00 00       	mov    $0x1,%edx
    23fe:	48 89 c6             	mov    %rax,%rsi
    2401:	bf 00 00 00 00       	mov    $0x0,%edi
    2406:	48 b8 b2 25 00 00 00 	movabs $0x25b2,%rax
    240d:	00 00 00 
    2410:	ff d0                	call   *%rax
    2412:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    2415:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    2419:	7e 36                	jle    2451 <gets+0x74>
      break;
    buf[i++] = c;
    241b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    241e:	8d 50 01             	lea    0x1(%rax),%edx
    2421:	89 55 fc             	mov    %edx,-0x4(%rbp)
    2424:	48 63 d0             	movslq %eax,%rdx
    2427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    242b:	48 01 c2             	add    %rax,%rdx
    242e:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    2432:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    2434:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    2438:	3c 0a                	cmp    $0xa,%al
    243a:	74 16                	je     2452 <gets+0x75>
    243c:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    2440:	3c 0d                	cmp    $0xd,%al
    2442:	74 0e                	je     2452 <gets+0x75>
  for(i=0; i+1 < max; ){
    2444:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2447:	83 c0 01             	add    $0x1,%eax
    244a:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    244d:	7f a6                	jg     23f5 <gets+0x18>
    244f:	eb 01                	jmp    2452 <gets+0x75>
      break;
    2451:	90                   	nop
      break;
  }
  buf[i] = '\0';
    2452:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2455:	48 63 d0             	movslq %eax,%rdx
    2458:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    245c:	48 01 d0             	add    %rdx,%rax
    245f:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    2462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    2466:	c9                   	leave
    2467:	c3                   	ret

0000000000002468 <stat>:

int
stat(char *n, struct stat *st)
{
    2468:	55                   	push   %rbp
    2469:	48 89 e5             	mov    %rsp,%rbp
    246c:	48 83 ec 20          	sub    $0x20,%rsp
    2470:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    2474:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2478:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    247c:	be 00 00 00 00       	mov    $0x0,%esi
    2481:	48 89 c7             	mov    %rax,%rdi
    2484:	48 b8 f3 25 00 00 00 	movabs $0x25f3,%rax
    248b:	00 00 00 
    248e:	ff d0                	call   *%rax
    2490:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    2493:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2497:	79 07                	jns    24a0 <stat+0x38>
    return -1;
    2499:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    249e:	eb 2f                	jmp    24cf <stat+0x67>
  r = fstat(fd, st);
    24a0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    24a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    24a7:	48 89 d6             	mov    %rdx,%rsi
    24aa:	89 c7                	mov    %eax,%edi
    24ac:	48 b8 1a 26 00 00 00 	movabs $0x261a,%rax
    24b3:	00 00 00 
    24b6:	ff d0                	call   *%rax
    24b8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    24bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
    24be:	89 c7                	mov    %eax,%edi
    24c0:	48 b8 cc 25 00 00 00 	movabs $0x25cc,%rax
    24c7:	00 00 00 
    24ca:	ff d0                	call   *%rax
  return r;
    24cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    24cf:	c9                   	leave
    24d0:	c3                   	ret

00000000000024d1 <atoi>:

int
atoi(const char *s)
{
    24d1:	55                   	push   %rbp
    24d2:	48 89 e5             	mov    %rsp,%rbp
    24d5:	48 83 ec 18          	sub    $0x18,%rsp
    24d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    24dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    24e4:	eb 28                	jmp    250e <atoi+0x3d>
    n = n*10 + *s++ - '0';
    24e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
    24e9:	89 d0                	mov    %edx,%eax
    24eb:	c1 e0 02             	shl    $0x2,%eax
    24ee:	01 d0                	add    %edx,%eax
    24f0:	01 c0                	add    %eax,%eax
    24f2:	89 c1                	mov    %eax,%ecx
    24f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    24f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
    24fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    2500:	0f b6 00             	movzbl (%rax),%eax
    2503:	0f be c0             	movsbl %al,%eax
    2506:	01 c8                	add    %ecx,%eax
    2508:	83 e8 30             	sub    $0x30,%eax
    250b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    250e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2512:	0f b6 00             	movzbl (%rax),%eax
    2515:	3c 2f                	cmp    $0x2f,%al
    2517:	7e 0b                	jle    2524 <atoi+0x53>
    2519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    251d:	0f b6 00             	movzbl (%rax),%eax
    2520:	3c 39                	cmp    $0x39,%al
    2522:	7e c2                	jle    24e6 <atoi+0x15>
  return n;
    2524:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    2527:	c9                   	leave
    2528:	c3                   	ret

0000000000002529 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    2529:	55                   	push   %rbp
    252a:	48 89 e5             	mov    %rsp,%rbp
    252d:	48 83 ec 28          	sub    $0x28,%rsp
    2531:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    2535:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    2539:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    253c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2540:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    2544:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    2548:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    254c:	eb 1d                	jmp    256b <memmove+0x42>
    *dst++ = *src++;
    254e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    2552:	48 8d 42 01          	lea    0x1(%rdx),%rax
    2556:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    255a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    255e:	48 8d 48 01          	lea    0x1(%rax),%rcx
    2562:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    2566:	0f b6 12             	movzbl (%rdx),%edx
    2569:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    256b:	8b 45 dc             	mov    -0x24(%rbp),%eax
    256e:	8d 50 ff             	lea    -0x1(%rax),%edx
    2571:	89 55 dc             	mov    %edx,-0x24(%rbp)
    2574:	85 c0                	test   %eax,%eax
    2576:	7f d6                	jg     254e <memmove+0x25>
  return vdst;
    2578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    257c:	c9                   	leave
    257d:	c3                   	ret

000000000000257e <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    257e:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    2585:	49 89 ca             	mov    %rcx,%r10
    2588:	0f 05                	syscall
    258a:	c3                   	ret

000000000000258b <exit>:
SYSCALL(exit)
    258b:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    2592:	49 89 ca             	mov    %rcx,%r10
    2595:	0f 05                	syscall
    2597:	c3                   	ret

0000000000002598 <wait>:
SYSCALL(wait)
    2598:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    259f:	49 89 ca             	mov    %rcx,%r10
    25a2:	0f 05                	syscall
    25a4:	c3                   	ret

00000000000025a5 <pipe>:
SYSCALL(pipe)
    25a5:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    25ac:	49 89 ca             	mov    %rcx,%r10
    25af:	0f 05                	syscall
    25b1:	c3                   	ret

00000000000025b2 <read>:
SYSCALL(read)
    25b2:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    25b9:	49 89 ca             	mov    %rcx,%r10
    25bc:	0f 05                	syscall
    25be:	c3                   	ret

00000000000025bf <write>:
SYSCALL(write)
    25bf:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    25c6:	49 89 ca             	mov    %rcx,%r10
    25c9:	0f 05                	syscall
    25cb:	c3                   	ret

00000000000025cc <close>:
SYSCALL(close)
    25cc:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    25d3:	49 89 ca             	mov    %rcx,%r10
    25d6:	0f 05                	syscall
    25d8:	c3                   	ret

00000000000025d9 <kill>:
SYSCALL(kill)
    25d9:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    25e0:	49 89 ca             	mov    %rcx,%r10
    25e3:	0f 05                	syscall
    25e5:	c3                   	ret

00000000000025e6 <exec>:
SYSCALL(exec)
    25e6:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    25ed:	49 89 ca             	mov    %rcx,%r10
    25f0:	0f 05                	syscall
    25f2:	c3                   	ret

00000000000025f3 <open>:
SYSCALL(open)
    25f3:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    25fa:	49 89 ca             	mov    %rcx,%r10
    25fd:	0f 05                	syscall
    25ff:	c3                   	ret

0000000000002600 <mknod>:
SYSCALL(mknod)
    2600:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    2607:	49 89 ca             	mov    %rcx,%r10
    260a:	0f 05                	syscall
    260c:	c3                   	ret

000000000000260d <unlink>:
SYSCALL(unlink)
    260d:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    2614:	49 89 ca             	mov    %rcx,%r10
    2617:	0f 05                	syscall
    2619:	c3                   	ret

000000000000261a <fstat>:
SYSCALL(fstat)
    261a:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    2621:	49 89 ca             	mov    %rcx,%r10
    2624:	0f 05                	syscall
    2626:	c3                   	ret

0000000000002627 <link>:
SYSCALL(link)
    2627:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    262e:	49 89 ca             	mov    %rcx,%r10
    2631:	0f 05                	syscall
    2633:	c3                   	ret

0000000000002634 <mkdir>:
SYSCALL(mkdir)
    2634:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    263b:	49 89 ca             	mov    %rcx,%r10
    263e:	0f 05                	syscall
    2640:	c3                   	ret

0000000000002641 <chdir>:
SYSCALL(chdir)
    2641:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    2648:	49 89 ca             	mov    %rcx,%r10
    264b:	0f 05                	syscall
    264d:	c3                   	ret

000000000000264e <dup>:
SYSCALL(dup)
    264e:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    2655:	49 89 ca             	mov    %rcx,%r10
    2658:	0f 05                	syscall
    265a:	c3                   	ret

000000000000265b <getpid>:
SYSCALL(getpid)
    265b:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    2662:	49 89 ca             	mov    %rcx,%r10
    2665:	0f 05                	syscall
    2667:	c3                   	ret

0000000000002668 <sbrk>:
SYSCALL(sbrk)
    2668:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    266f:	49 89 ca             	mov    %rcx,%r10
    2672:	0f 05                	syscall
    2674:	c3                   	ret

0000000000002675 <sleep>:
SYSCALL(sleep)
    2675:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    267c:	49 89 ca             	mov    %rcx,%r10
    267f:	0f 05                	syscall
    2681:	c3                   	ret

0000000000002682 <uptime>:
SYSCALL(uptime)
    2682:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    2689:	49 89 ca             	mov    %rcx,%r10
    268c:	0f 05                	syscall
    268e:	c3                   	ret

000000000000268f <traceread>:
SYSCALL(traceread)
    268f:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    2696:	49 89 ca             	mov    %rcx,%r10
    2699:	0f 05                	syscall
    269b:	c3                   	ret

000000000000269c <vidclear>:
SYSCALL(vidclear)
    269c:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    26a3:	49 89 ca             	mov    %rcx,%r10
    26a6:	0f 05                	syscall
    26a8:	c3                   	ret

00000000000026a9 <vidputc>:
SYSCALL(vidputc)
    26a9:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    26b0:	49 89 ca             	mov    %rcx,%r10
    26b3:	0f 05                	syscall
    26b5:	c3                   	ret

00000000000026b6 <vidputs>:
SYSCALL(vidputs)
    26b6:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    26bd:	49 89 ca             	mov    %rcx,%r10
    26c0:	0f 05                	syscall
    26c2:	c3                   	ret

00000000000026c3 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    26c3:	55                   	push   %rbp
    26c4:	48 89 e5             	mov    %rsp,%rbp
    26c7:	48 83 ec 10          	sub    $0x10,%rsp
    26cb:	89 7d fc             	mov    %edi,-0x4(%rbp)
    26ce:	89 f0                	mov    %esi,%eax
    26d0:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    26d3:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    26d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
    26da:	ba 01 00 00 00       	mov    $0x1,%edx
    26df:	48 89 ce             	mov    %rcx,%rsi
    26e2:	89 c7                	mov    %eax,%edi
    26e4:	48 b8 bf 25 00 00 00 	movabs $0x25bf,%rax
    26eb:	00 00 00 
    26ee:	ff d0                	call   *%rax
}
    26f0:	90                   	nop
    26f1:	c9                   	leave
    26f2:	c3                   	ret

00000000000026f3 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    26f3:	55                   	push   %rbp
    26f4:	48 89 e5             	mov    %rsp,%rbp
    26f7:	48 83 ec 20          	sub    $0x20,%rsp
    26fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
    26fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    2702:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2709:	eb 35                	jmp    2740 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    270b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    270f:	48 c1 e8 3c          	shr    $0x3c,%rax
    2713:	48 ba a0 30 00 00 00 	movabs $0x30a0,%rdx
    271a:	00 00 00 
    271d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    2721:	0f be d0             	movsbl %al,%edx
    2724:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2727:	89 d6                	mov    %edx,%esi
    2729:	89 c7                	mov    %eax,%edi
    272b:	48 b8 c3 26 00 00 00 	movabs $0x26c3,%rax
    2732:	00 00 00 
    2735:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    2737:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    273b:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    2740:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2743:	83 f8 0f             	cmp    $0xf,%eax
    2746:	76 c3                	jbe    270b <print_x64+0x18>
}
    2748:	90                   	nop
    2749:	90                   	nop
    274a:	c9                   	leave
    274b:	c3                   	ret

000000000000274c <print_x32>:

  static void
print_x32(int fd, uint x)
{
    274c:	55                   	push   %rbp
    274d:	48 89 e5             	mov    %rsp,%rbp
    2750:	48 83 ec 20          	sub    $0x20,%rsp
    2754:	89 7d ec             	mov    %edi,-0x14(%rbp)
    2757:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    275a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2761:	eb 36                	jmp    2799 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    2763:	8b 45 e8             	mov    -0x18(%rbp),%eax
    2766:	c1 e8 1c             	shr    $0x1c,%eax
    2769:	89 c2                	mov    %eax,%edx
    276b:	48 b8 a0 30 00 00 00 	movabs $0x30a0,%rax
    2772:	00 00 00 
    2775:	89 d2                	mov    %edx,%edx
    2777:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    277b:	0f be d0             	movsbl %al,%edx
    277e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2781:	89 d6                	mov    %edx,%esi
    2783:	89 c7                	mov    %eax,%edi
    2785:	48 b8 c3 26 00 00 00 	movabs $0x26c3,%rax
    278c:	00 00 00 
    278f:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    2791:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2795:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    2799:	8b 45 fc             	mov    -0x4(%rbp),%eax
    279c:	83 f8 07             	cmp    $0x7,%eax
    279f:	76 c2                	jbe    2763 <print_x32+0x17>
}
    27a1:	90                   	nop
    27a2:	90                   	nop
    27a3:	c9                   	leave
    27a4:	c3                   	ret

00000000000027a5 <print_d>:

  static void
print_d(int fd, int v)
{
    27a5:	55                   	push   %rbp
    27a6:	48 89 e5             	mov    %rsp,%rbp
    27a9:	48 83 ec 30          	sub    $0x30,%rsp
    27ad:	89 7d dc             	mov    %edi,-0x24(%rbp)
    27b0:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    27b3:	8b 45 d8             	mov    -0x28(%rbp),%eax
    27b6:	48 98                	cltq
    27b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    27bc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    27c0:	79 04                	jns    27c6 <print_d+0x21>
    x = -x;
    27c2:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    27c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    27cd:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    27d1:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    27d8:	66 66 66 
    27db:	48 89 c8             	mov    %rcx,%rax
    27de:	48 f7 ea             	imul   %rdx
    27e1:	48 c1 fa 02          	sar    $0x2,%rdx
    27e5:	48 89 c8             	mov    %rcx,%rax
    27e8:	48 c1 f8 3f          	sar    $0x3f,%rax
    27ec:	48 29 c2             	sub    %rax,%rdx
    27ef:	48 89 d0             	mov    %rdx,%rax
    27f2:	48 c1 e0 02          	shl    $0x2,%rax
    27f6:	48 01 d0             	add    %rdx,%rax
    27f9:	48 01 c0             	add    %rax,%rax
    27fc:	48 29 c1             	sub    %rax,%rcx
    27ff:	48 89 ca             	mov    %rcx,%rdx
    2802:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2805:	8d 48 01             	lea    0x1(%rax),%ecx
    2808:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    280b:	48 b9 a0 30 00 00 00 	movabs $0x30a0,%rcx
    2812:	00 00 00 
    2815:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    2819:	48 98                	cltq
    281b:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    281f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    2823:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    282a:	66 66 66 
    282d:	48 89 c8             	mov    %rcx,%rax
    2830:	48 f7 ea             	imul   %rdx
    2833:	48 89 d0             	mov    %rdx,%rax
    2836:	48 c1 f8 02          	sar    $0x2,%rax
    283a:	48 c1 f9 3f          	sar    $0x3f,%rcx
    283e:	48 89 ca             	mov    %rcx,%rdx
    2841:	48 29 d0             	sub    %rdx,%rax
    2844:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    2848:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    284d:	0f 85 7a ff ff ff    	jne    27cd <print_d+0x28>

  if (v < 0)
    2853:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    2857:	79 32                	jns    288b <print_d+0xe6>
    buf[i++] = '-';
    2859:	8b 45 f4             	mov    -0xc(%rbp),%eax
    285c:	8d 50 01             	lea    0x1(%rax),%edx
    285f:	89 55 f4             	mov    %edx,-0xc(%rbp)
    2862:	48 98                	cltq
    2864:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    2869:	eb 20                	jmp    288b <print_d+0xe6>
    putc(fd, buf[i]);
    286b:	8b 45 f4             	mov    -0xc(%rbp),%eax
    286e:	48 98                	cltq
    2870:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    2875:	0f be d0             	movsbl %al,%edx
    2878:	8b 45 dc             	mov    -0x24(%rbp),%eax
    287b:	89 d6                	mov    %edx,%esi
    287d:	89 c7                	mov    %eax,%edi
    287f:	48 b8 c3 26 00 00 00 	movabs $0x26c3,%rax
    2886:	00 00 00 
    2889:	ff d0                	call   *%rax
  while (--i >= 0)
    288b:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    288f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    2893:	79 d6                	jns    286b <print_d+0xc6>
}
    2895:	90                   	nop
    2896:	90                   	nop
    2897:	c9                   	leave
    2898:	c3                   	ret

0000000000002899 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    2899:	55                   	push   %rbp
    289a:	48 89 e5             	mov    %rsp,%rbp
    289d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    28a4:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    28aa:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    28b1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    28b8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    28bf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    28c6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    28cd:	84 c0                	test   %al,%al
    28cf:	74 20                	je     28f1 <printf+0x58>
    28d1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    28d5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    28d9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    28dd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    28e1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    28e5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    28e9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    28ed:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    28f1:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    28f8:	00 00 00 
    28fb:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    2902:	00 00 00 
    2905:	48 8d 45 10          	lea    0x10(%rbp),%rax
    2909:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    2910:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    2917:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    291e:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    2925:	00 00 00 
    2928:	e9 60 03 00 00       	jmp    2c8d <printf+0x3f4>
    if (c != '%') {
    292d:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    2934:	74 24                	je     295a <printf+0xc1>
      putc(fd, c);
    2936:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    293c:	0f be d0             	movsbl %al,%edx
    293f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2945:	89 d6                	mov    %edx,%esi
    2947:	89 c7                	mov    %eax,%edi
    2949:	48 b8 c3 26 00 00 00 	movabs $0x26c3,%rax
    2950:	00 00 00 
    2953:	ff d0                	call   *%rax
      continue;
    2955:	e9 2c 03 00 00       	jmp    2c86 <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    295a:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    2961:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    2967:	48 63 d0             	movslq %eax,%rdx
    296a:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    2971:	48 01 d0             	add    %rdx,%rax
    2974:	0f b6 00             	movzbl (%rax),%eax
    2977:	0f be c0             	movsbl %al,%eax
    297a:	25 ff 00 00 00       	and    $0xff,%eax
    297f:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    2985:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    298c:	0f 84 2e 03 00 00    	je     2cc0 <printf+0x427>
      break;
    switch(c) {
    2992:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    2999:	0f 84 32 01 00 00    	je     2ad1 <printf+0x238>
    299f:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    29a6:	0f 8f a1 02 00 00    	jg     2c4d <printf+0x3b4>
    29ac:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    29b3:	0f 84 d4 01 00 00    	je     2b8d <printf+0x2f4>
    29b9:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    29c0:	0f 8f 87 02 00 00    	jg     2c4d <printf+0x3b4>
    29c6:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    29cd:	0f 84 5b 01 00 00    	je     2b2e <printf+0x295>
    29d3:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    29da:	0f 8f 6d 02 00 00    	jg     2c4d <printf+0x3b4>
    29e0:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    29e7:	0f 84 87 00 00 00    	je     2a74 <printf+0x1db>
    29ed:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    29f4:	0f 8f 53 02 00 00    	jg     2c4d <printf+0x3b4>
    29fa:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    2a01:	0f 84 2b 02 00 00    	je     2c32 <printf+0x399>
    2a07:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    2a0e:	0f 85 39 02 00 00    	jne    2c4d <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    2a14:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2a1a:	83 f8 2f             	cmp    $0x2f,%eax
    2a1d:	77 23                	ja     2a42 <printf+0x1a9>
    2a1f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2a26:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2a2c:	89 d2                	mov    %edx,%edx
    2a2e:	48 01 d0             	add    %rdx,%rax
    2a31:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2a37:	83 c2 08             	add    $0x8,%edx
    2a3a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    2a40:	eb 12                	jmp    2a54 <printf+0x1bb>
    2a42:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2a49:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2a4d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2a54:	8b 00                	mov    (%rax),%eax
    2a56:	0f be d0             	movsbl %al,%edx
    2a59:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2a5f:	89 d6                	mov    %edx,%esi
    2a61:	89 c7                	mov    %eax,%edi
    2a63:	48 b8 c3 26 00 00 00 	movabs $0x26c3,%rax
    2a6a:	00 00 00 
    2a6d:	ff d0                	call   *%rax
      break;
    2a6f:	e9 12 02 00 00       	jmp    2c86 <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    2a74:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2a7a:	83 f8 2f             	cmp    $0x2f,%eax
    2a7d:	77 23                	ja     2aa2 <printf+0x209>
    2a7f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2a86:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2a8c:	89 d2                	mov    %edx,%edx
    2a8e:	48 01 d0             	add    %rdx,%rax
    2a91:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2a97:	83 c2 08             	add    $0x8,%edx
    2a9a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    2aa0:	eb 12                	jmp    2ab4 <printf+0x21b>
    2aa2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2aa9:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2aad:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2ab4:	8b 10                	mov    (%rax),%edx
    2ab6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2abc:	89 d6                	mov    %edx,%esi
    2abe:	89 c7                	mov    %eax,%edi
    2ac0:	48 b8 a5 27 00 00 00 	movabs $0x27a5,%rax
    2ac7:	00 00 00 
    2aca:	ff d0                	call   *%rax
      break;
    2acc:	e9 b5 01 00 00       	jmp    2c86 <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    2ad1:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2ad7:	83 f8 2f             	cmp    $0x2f,%eax
    2ada:	77 23                	ja     2aff <printf+0x266>
    2adc:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2ae3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2ae9:	89 d2                	mov    %edx,%edx
    2aeb:	48 01 d0             	add    %rdx,%rax
    2aee:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2af4:	83 c2 08             	add    $0x8,%edx
    2af7:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    2afd:	eb 12                	jmp    2b11 <printf+0x278>
    2aff:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2b06:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2b0a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2b11:	8b 10                	mov    (%rax),%edx
    2b13:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2b19:	89 d6                	mov    %edx,%esi
    2b1b:	89 c7                	mov    %eax,%edi
    2b1d:	48 b8 4c 27 00 00 00 	movabs $0x274c,%rax
    2b24:	00 00 00 
    2b27:	ff d0                	call   *%rax
      break;
    2b29:	e9 58 01 00 00       	jmp    2c86 <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    2b2e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2b34:	83 f8 2f             	cmp    $0x2f,%eax
    2b37:	77 23                	ja     2b5c <printf+0x2c3>
    2b39:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2b40:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2b46:	89 d2                	mov    %edx,%edx
    2b48:	48 01 d0             	add    %rdx,%rax
    2b4b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2b51:	83 c2 08             	add    $0x8,%edx
    2b54:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    2b5a:	eb 12                	jmp    2b6e <printf+0x2d5>
    2b5c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2b63:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2b67:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2b6e:	48 8b 10             	mov    (%rax),%rdx
    2b71:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2b77:	48 89 d6             	mov    %rdx,%rsi
    2b7a:	89 c7                	mov    %eax,%edi
    2b7c:	48 b8 f3 26 00 00 00 	movabs $0x26f3,%rax
    2b83:	00 00 00 
    2b86:	ff d0                	call   *%rax
      break;
    2b88:	e9 f9 00 00 00       	jmp    2c86 <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    2b8d:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2b93:	83 f8 2f             	cmp    $0x2f,%eax
    2b96:	77 23                	ja     2bbb <printf+0x322>
    2b98:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2b9f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2ba5:	89 d2                	mov    %edx,%edx
    2ba7:	48 01 d0             	add    %rdx,%rax
    2baa:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2bb0:	83 c2 08             	add    $0x8,%edx
    2bb3:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    2bb9:	eb 12                	jmp    2bcd <printf+0x334>
    2bbb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2bc2:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2bc6:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2bcd:	48 8b 00             	mov    (%rax),%rax
    2bd0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    2bd7:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    2bde:	00 
    2bdf:	75 41                	jne    2c22 <printf+0x389>
        s = "(null)";
    2be1:	48 b8 7b 30 00 00 00 	movabs $0x307b,%rax
    2be8:	00 00 00 
    2beb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    2bf2:	eb 2e                	jmp    2c22 <printf+0x389>
        putc(fd, *(s++));
    2bf4:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    2bfb:	48 8d 50 01          	lea    0x1(%rax),%rdx
    2bff:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    2c06:	0f b6 00             	movzbl (%rax),%eax
    2c09:	0f be d0             	movsbl %al,%edx
    2c0c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2c12:	89 d6                	mov    %edx,%esi
    2c14:	89 c7                	mov    %eax,%edi
    2c16:	48 b8 c3 26 00 00 00 	movabs $0x26c3,%rax
    2c1d:	00 00 00 
    2c20:	ff d0                	call   *%rax
      while (*s)
    2c22:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    2c29:	0f b6 00             	movzbl (%rax),%eax
    2c2c:	84 c0                	test   %al,%al
    2c2e:	75 c4                	jne    2bf4 <printf+0x35b>
      break;
    2c30:	eb 54                	jmp    2c86 <printf+0x3ed>
    case '%':
      putc(fd, '%');
    2c32:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2c38:	be 25 00 00 00       	mov    $0x25,%esi
    2c3d:	89 c7                	mov    %eax,%edi
    2c3f:	48 b8 c3 26 00 00 00 	movabs $0x26c3,%rax
    2c46:	00 00 00 
    2c49:	ff d0                	call   *%rax
      break;
    2c4b:	eb 39                	jmp    2c86 <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    2c4d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2c53:	be 25 00 00 00       	mov    $0x25,%esi
    2c58:	89 c7                	mov    %eax,%edi
    2c5a:	48 b8 c3 26 00 00 00 	movabs $0x26c3,%rax
    2c61:	00 00 00 
    2c64:	ff d0                	call   *%rax
      putc(fd, c);
    2c66:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    2c6c:	0f be d0             	movsbl %al,%edx
    2c6f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2c75:	89 d6                	mov    %edx,%esi
    2c77:	89 c7                	mov    %eax,%edi
    2c79:	48 b8 c3 26 00 00 00 	movabs $0x26c3,%rax
    2c80:	00 00 00 
    2c83:	ff d0                	call   *%rax
      break;
    2c85:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    2c86:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    2c8d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    2c93:	48 63 d0             	movslq %eax,%rdx
    2c96:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    2c9d:	48 01 d0             	add    %rdx,%rax
    2ca0:	0f b6 00             	movzbl (%rax),%eax
    2ca3:	0f be c0             	movsbl %al,%eax
    2ca6:	25 ff 00 00 00       	and    $0xff,%eax
    2cab:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    2cb1:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    2cb8:	0f 85 6f fc ff ff    	jne    292d <printf+0x94>
    }
  }
}
    2cbe:	eb 01                	jmp    2cc1 <printf+0x428>
      break;
    2cc0:	90                   	nop
}
    2cc1:	90                   	nop
    2cc2:	c9                   	leave
    2cc3:	c3                   	ret

0000000000002cc4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    2cc4:	55                   	push   %rbp
    2cc5:	48 89 e5             	mov    %rsp,%rbp
    2cc8:	48 83 ec 18          	sub    $0x18,%rsp
    2ccc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    2cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2cd4:	48 83 e8 10          	sub    $0x10,%rax
    2cd8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2cdc:	48 b8 40 31 00 00 00 	movabs $0x3140,%rax
    2ce3:	00 00 00 
    2ce6:	48 8b 00             	mov    (%rax),%rax
    2ce9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    2ced:	eb 2f                	jmp    2d1e <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2cef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2cf3:	48 8b 00             	mov    (%rax),%rax
    2cf6:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2cfa:	72 17                	jb     2d13 <free+0x4f>
    2cfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d00:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2d04:	72 2f                	jb     2d35 <free+0x71>
    2d06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d0a:	48 8b 00             	mov    (%rax),%rax
    2d0d:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    2d11:	72 22                	jb     2d35 <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2d13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d17:	48 8b 00             	mov    (%rax),%rax
    2d1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    2d1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d22:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2d26:	73 c7                	jae    2cef <free+0x2b>
    2d28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d2c:	48 8b 00             	mov    (%rax),%rax
    2d2f:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    2d33:	73 ba                	jae    2cef <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    2d35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d39:	8b 40 08             	mov    0x8(%rax),%eax
    2d3c:	89 c0                	mov    %eax,%eax
    2d3e:	48 c1 e0 04          	shl    $0x4,%rax
    2d42:	48 89 c2             	mov    %rax,%rdx
    2d45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d49:	48 01 c2             	add    %rax,%rdx
    2d4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d50:	48 8b 00             	mov    (%rax),%rax
    2d53:	48 39 c2             	cmp    %rax,%rdx
    2d56:	75 2d                	jne    2d85 <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    2d58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d5c:	8b 50 08             	mov    0x8(%rax),%edx
    2d5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d63:	48 8b 00             	mov    (%rax),%rax
    2d66:	8b 40 08             	mov    0x8(%rax),%eax
    2d69:	01 c2                	add    %eax,%edx
    2d6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d6f:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    2d72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d76:	48 8b 00             	mov    (%rax),%rax
    2d79:	48 8b 10             	mov    (%rax),%rdx
    2d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d80:	48 89 10             	mov    %rdx,(%rax)
    2d83:	eb 0e                	jmp    2d93 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    2d85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d89:	48 8b 10             	mov    (%rax),%rdx
    2d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d90:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    2d93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d97:	8b 40 08             	mov    0x8(%rax),%eax
    2d9a:	89 c0                	mov    %eax,%eax
    2d9c:	48 c1 e0 04          	shl    $0x4,%rax
    2da0:	48 89 c2             	mov    %rax,%rdx
    2da3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2da7:	48 01 d0             	add    %rdx,%rax
    2daa:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    2dae:	75 27                	jne    2dd7 <free+0x113>
    p->s.size += bp->s.size;
    2db0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2db4:	8b 50 08             	mov    0x8(%rax),%edx
    2db7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2dbb:	8b 40 08             	mov    0x8(%rax),%eax
    2dbe:	01 c2                	add    %eax,%edx
    2dc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2dc4:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    2dc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2dcb:	48 8b 10             	mov    (%rax),%rdx
    2dce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2dd2:	48 89 10             	mov    %rdx,(%rax)
    2dd5:	eb 0b                	jmp    2de2 <free+0x11e>
  } else
    p->s.ptr = bp;
    2dd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2ddb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    2ddf:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    2de2:	48 ba 40 31 00 00 00 	movabs $0x3140,%rdx
    2de9:	00 00 00 
    2dec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2df0:	48 89 02             	mov    %rax,(%rdx)
}
    2df3:	90                   	nop
    2df4:	c9                   	leave
    2df5:	c3                   	ret

0000000000002df6 <morecore>:

static Header*
morecore(uint nu)
{
    2df6:	55                   	push   %rbp
    2df7:	48 89 e5             	mov    %rsp,%rbp
    2dfa:	48 83 ec 20          	sub    $0x20,%rsp
    2dfe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    2e01:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    2e08:	77 07                	ja     2e11 <morecore+0x1b>
    nu = 4096;
    2e0a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    2e11:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2e14:	48 c1 e0 04          	shl    $0x4,%rax
    2e18:	48 89 c7             	mov    %rax,%rdi
    2e1b:	48 b8 68 26 00 00 00 	movabs $0x2668,%rax
    2e22:	00 00 00 
    2e25:	ff d0                	call   *%rax
    2e27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    2e2b:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    2e30:	75 07                	jne    2e39 <morecore+0x43>
    return 0;
    2e32:	b8 00 00 00 00       	mov    $0x0,%eax
    2e37:	eb 36                	jmp    2e6f <morecore+0x79>
  hp = (Header*)p;
    2e39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2e3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    2e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2e45:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2e48:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    2e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2e4f:	48 83 c0 10          	add    $0x10,%rax
    2e53:	48 89 c7             	mov    %rax,%rdi
    2e56:	48 b8 c4 2c 00 00 00 	movabs $0x2cc4,%rax
    2e5d:	00 00 00 
    2e60:	ff d0                	call   *%rax
  return freep;
    2e62:	48 b8 40 31 00 00 00 	movabs $0x3140,%rax
    2e69:	00 00 00 
    2e6c:	48 8b 00             	mov    (%rax),%rax
}
    2e6f:	c9                   	leave
    2e70:	c3                   	ret

0000000000002e71 <malloc>:

void*
malloc(uint nbytes)
{
    2e71:	55                   	push   %rbp
    2e72:	48 89 e5             	mov    %rsp,%rbp
    2e75:	48 83 ec 30          	sub    $0x30,%rsp
    2e79:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    2e7c:	8b 45 dc             	mov    -0x24(%rbp),%eax
    2e7f:	48 83 c0 0f          	add    $0xf,%rax
    2e83:	48 c1 e8 04          	shr    $0x4,%rax
    2e87:	83 c0 01             	add    $0x1,%eax
    2e8a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    2e8d:	48 b8 40 31 00 00 00 	movabs $0x3140,%rax
    2e94:	00 00 00 
    2e97:	48 8b 00             	mov    (%rax),%rax
    2e9a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    2e9e:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    2ea3:	75 4a                	jne    2eef <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    2ea5:	48 b8 30 31 00 00 00 	movabs $0x3130,%rax
    2eac:	00 00 00 
    2eaf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    2eb3:	48 ba 40 31 00 00 00 	movabs $0x3140,%rdx
    2eba:	00 00 00 
    2ebd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2ec1:	48 89 02             	mov    %rax,(%rdx)
    2ec4:	48 b8 40 31 00 00 00 	movabs $0x3140,%rax
    2ecb:	00 00 00 
    2ece:	48 8b 00             	mov    (%rax),%rax
    2ed1:	48 ba 30 31 00 00 00 	movabs $0x3130,%rdx
    2ed8:	00 00 00 
    2edb:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    2ede:	48 b8 30 31 00 00 00 	movabs $0x3130,%rax
    2ee5:	00 00 00 
    2ee8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2ef3:	48 8b 00             	mov    (%rax),%rax
    2ef6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    2efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2efe:	8b 40 08             	mov    0x8(%rax),%eax
    2f01:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    2f04:	72 65                	jb     2f6b <malloc+0xfa>
      if(p->s.size == nunits)
    2f06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2f0a:	8b 40 08             	mov    0x8(%rax),%eax
    2f0d:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    2f10:	75 10                	jne    2f22 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    2f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2f16:	48 8b 10             	mov    (%rax),%rdx
    2f19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2f1d:	48 89 10             	mov    %rdx,(%rax)
    2f20:	eb 2e                	jmp    2f50 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    2f22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2f26:	8b 40 08             	mov    0x8(%rax),%eax
    2f29:	2b 45 ec             	sub    -0x14(%rbp),%eax
    2f2c:	89 c2                	mov    %eax,%edx
    2f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2f32:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    2f35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2f39:	8b 40 08             	mov    0x8(%rax),%eax
    2f3c:	89 c0                	mov    %eax,%eax
    2f3e:	48 c1 e0 04          	shl    $0x4,%rax
    2f42:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    2f46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2f4a:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2f4d:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    2f50:	48 ba 40 31 00 00 00 	movabs $0x3140,%rdx
    2f57:	00 00 00 
    2f5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2f5e:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    2f61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2f65:	48 83 c0 10          	add    $0x10,%rax
    2f69:	eb 4e                	jmp    2fb9 <malloc+0x148>
    }
    if(p == freep)
    2f6b:	48 b8 40 31 00 00 00 	movabs $0x3140,%rax
    2f72:	00 00 00 
    2f75:	48 8b 00             	mov    (%rax),%rax
    2f78:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2f7c:	75 23                	jne    2fa1 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    2f7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2f81:	89 c7                	mov    %eax,%edi
    2f83:	48 b8 f6 2d 00 00 00 	movabs $0x2df6,%rax
    2f8a:	00 00 00 
    2f8d:	ff d0                	call   *%rax
    2f8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    2f93:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2f98:	75 07                	jne    2fa1 <malloc+0x130>
        return 0;
    2f9a:	b8 00 00 00 00       	mov    $0x0,%eax
    2f9f:	eb 18                	jmp    2fb9 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2fa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2fa5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    2fa9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2fad:	48 8b 00             	mov    (%rax),%rax
    2fb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    2fb4:	e9 41 ff ff ff       	jmp    2efa <malloc+0x89>
  }
}
    2fb9:	c9                   	leave
    2fba:	c3                   	ret

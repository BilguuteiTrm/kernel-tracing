
_ls:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	53                   	push   %rbx
    1005:	48 83 ec 28          	sub    $0x28,%rsp
    1009:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    100d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1011:	48 89 c7             	mov    %rax,%rdi
    1014:	48 b8 7b 15 00 00 00 	movabs $0x157b,%rax
    101b:	00 00 00 
    101e:	ff d0                	call   *%rax
    1020:	89 c2                	mov    %eax,%edx
    1022:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1026:	48 01 d0             	add    %rdx,%rax
    1029:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    102d:	eb 05                	jmp    1034 <fmtname+0x34>
    102f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
    1034:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1038:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
    103c:	72 0b                	jb     1049 <fmtname+0x49>
    103e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1042:	0f b6 00             	movzbl (%rax),%eax
    1045:	3c 2f                	cmp    $0x2f,%al
    1047:	75 e6                	jne    102f <fmtname+0x2f>
    ;
  p++;
    1049:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    104e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1052:	48 89 c7             	mov    %rax,%rdi
    1055:	48 b8 7b 15 00 00 00 	movabs $0x157b,%rax
    105c:	00 00 00 
    105f:	ff d0                	call   *%rax
    1061:	83 f8 0d             	cmp    $0xd,%eax
    1064:	76 09                	jbe    106f <fmtname+0x6f>
    return p;
    1066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    106a:	e9 93 00 00 00       	jmp    1102 <fmtname+0x102>
  memmove(buf, p, strlen(p));
    106f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1073:	48 89 c7             	mov    %rax,%rdi
    1076:	48 b8 7b 15 00 00 00 	movabs $0x157b,%rax
    107d:	00 00 00 
    1080:	ff d0                	call   *%rax
    1082:	89 c2                	mov    %eax,%edx
    1084:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1088:	48 b9 70 22 00 00 00 	movabs $0x2270,%rcx
    108f:	00 00 00 
    1092:	48 89 c6             	mov    %rax,%rsi
    1095:	48 89 cf             	mov    %rcx,%rdi
    1098:	48 b8 68 17 00 00 00 	movabs $0x1768,%rax
    109f:	00 00 00 
    10a2:	ff d0                	call   *%rax
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
    10a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10a8:	48 89 c7             	mov    %rax,%rdi
    10ab:	48 b8 7b 15 00 00 00 	movabs $0x157b,%rax
    10b2:	00 00 00 
    10b5:	ff d0                	call   *%rax
    10b7:	ba 0e 00 00 00       	mov    $0xe,%edx
    10bc:	89 d3                	mov    %edx,%ebx
    10be:	29 c3                	sub    %eax,%ebx
    10c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10c4:	48 89 c7             	mov    %rax,%rdi
    10c7:	48 b8 7b 15 00 00 00 	movabs $0x157b,%rax
    10ce:	00 00 00 
    10d1:	ff d0                	call   *%rax
    10d3:	89 c2                	mov    %eax,%edx
    10d5:	48 b8 70 22 00 00 00 	movabs $0x2270,%rax
    10dc:	00 00 00 
    10df:	48 01 d0             	add    %rdx,%rax
    10e2:	89 da                	mov    %ebx,%edx
    10e4:	be 20 00 00 00       	mov    $0x20,%esi
    10e9:	48 89 c7             	mov    %rax,%rdi
    10ec:	48 b8 ad 15 00 00 00 	movabs $0x15ad,%rax
    10f3:	00 00 00 
    10f6:	ff d0                	call   *%rax
  return buf;
    10f8:	48 b8 70 22 00 00 00 	movabs $0x2270,%rax
    10ff:	00 00 00 
}
    1102:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
    1106:	c9                   	leave
    1107:	c3                   	ret

0000000000001108 <ls>:

void
ls(char *path)
{
    1108:	55                   	push   %rbp
    1109:	48 89 e5             	mov    %rsp,%rbp
    110c:	41 55                	push   %r13
    110e:	41 54                	push   %r12
    1110:	53                   	push   %rbx
    1111:	48 81 ec 58 02 00 00 	sub    $0x258,%rsp
    1118:	48 89 bd 98 fd ff ff 	mov    %rdi,-0x268(%rbp)
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    111f:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    1126:	be 00 00 00 00       	mov    $0x0,%esi
    112b:	48 89 c7             	mov    %rax,%rdi
    112e:	48 b8 32 18 00 00 00 	movabs $0x1832,%rax
    1135:	00 00 00 
    1138:	ff d0                	call   *%rax
    113a:	89 45 dc             	mov    %eax,-0x24(%rbp)
    113d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    1141:	79 32                	jns    1175 <ls+0x6d>
    printf(2, "ls: cannot open %s\n", path);
    1143:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    114a:	48 b9 fa 21 00 00 00 	movabs $0x21fa,%rcx
    1151:	00 00 00 
    1154:	48 89 c2             	mov    %rax,%rdx
    1157:	48 89 ce             	mov    %rcx,%rsi
    115a:	bf 02 00 00 00       	mov    $0x2,%edi
    115f:	b8 00 00 00 00       	mov    $0x0,%eax
    1164:	48 b9 d8 1a 00 00 00 	movabs $0x1ad8,%rcx
    116b:	00 00 00 
    116e:	ff d1                	call   *%rcx
    return;
    1170:	e9 ab 02 00 00       	jmp    1420 <ls+0x318>
  }

  if(fstat(fd, &st) < 0){
    1175:	48 8d 95 a0 fd ff ff 	lea    -0x260(%rbp),%rdx
    117c:	8b 45 dc             	mov    -0x24(%rbp),%eax
    117f:	48 89 d6             	mov    %rdx,%rsi
    1182:	89 c7                	mov    %eax,%edi
    1184:	48 b8 59 18 00 00 00 	movabs $0x1859,%rax
    118b:	00 00 00 
    118e:	ff d0                	call   *%rax
    1190:	85 c0                	test   %eax,%eax
    1192:	79 43                	jns    11d7 <ls+0xcf>
    printf(2, "ls: cannot stat %s\n", path);
    1194:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    119b:	48 b9 0e 22 00 00 00 	movabs $0x220e,%rcx
    11a2:	00 00 00 
    11a5:	48 89 c2             	mov    %rax,%rdx
    11a8:	48 89 ce             	mov    %rcx,%rsi
    11ab:	bf 02 00 00 00       	mov    $0x2,%edi
    11b0:	b8 00 00 00 00       	mov    $0x0,%eax
    11b5:	48 b9 d8 1a 00 00 00 	movabs $0x1ad8,%rcx
    11bc:	00 00 00 
    11bf:	ff d1                	call   *%rcx
    close(fd);
    11c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
    11c4:	89 c7                	mov    %eax,%edi
    11c6:	48 b8 0b 18 00 00 00 	movabs $0x180b,%rax
    11cd:	00 00 00 
    11d0:	ff d0                	call   *%rax
    return;
    11d2:	e9 49 02 00 00       	jmp    1420 <ls+0x318>
  }

  switch(st.type){
    11d7:	0f b7 85 a0 fd ff ff 	movzwl -0x260(%rbp),%eax
    11de:	98                   	cwtl
    11df:	83 f8 01             	cmp    $0x1,%eax
    11e2:	74 6b                	je     124f <ls+0x147>
    11e4:	83 f8 02             	cmp    $0x2,%eax
    11e7:	0f 85 22 02 00 00    	jne    140f <ls+0x307>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    11ed:	44 8b ad b0 fd ff ff 	mov    -0x250(%rbp),%r13d
    11f4:	44 8b a5 a8 fd ff ff 	mov    -0x258(%rbp),%r12d
    11fb:	0f b7 85 a0 fd ff ff 	movzwl -0x260(%rbp),%eax
    1202:	0f bf d8             	movswl %ax,%ebx
    1205:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    120c:	48 89 c7             	mov    %rax,%rdi
    120f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1216:	00 00 00 
    1219:	ff d0                	call   *%rax
    121b:	48 89 c2             	mov    %rax,%rdx
    121e:	48 b8 22 22 00 00 00 	movabs $0x2222,%rax
    1225:	00 00 00 
    1228:	45 89 e9             	mov    %r13d,%r9d
    122b:	45 89 e0             	mov    %r12d,%r8d
    122e:	89 d9                	mov    %ebx,%ecx
    1230:	48 89 c6             	mov    %rax,%rsi
    1233:	bf 01 00 00 00       	mov    $0x1,%edi
    1238:	b8 00 00 00 00       	mov    $0x0,%eax
    123d:	49 ba d8 1a 00 00 00 	movabs $0x1ad8,%r10
    1244:	00 00 00 
    1247:	41 ff d2             	call   *%r10
    break;
    124a:	e9 c0 01 00 00       	jmp    140f <ls+0x307>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
    124f:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    1256:	48 89 c7             	mov    %rax,%rdi
    1259:	48 b8 7b 15 00 00 00 	movabs $0x157b,%rax
    1260:	00 00 00 
    1263:	ff d0                	call   *%rax
    1265:	83 c0 10             	add    $0x10,%eax
    1268:	3d 00 02 00 00       	cmp    $0x200,%eax
    126d:	76 28                	jbe    1297 <ls+0x18f>
      printf(1, "ls: path too long\n");
    126f:	48 b8 2f 22 00 00 00 	movabs $0x222f,%rax
    1276:	00 00 00 
    1279:	48 89 c6             	mov    %rax,%rsi
    127c:	bf 01 00 00 00       	mov    $0x1,%edi
    1281:	b8 00 00 00 00       	mov    $0x0,%eax
    1286:	48 ba d8 1a 00 00 00 	movabs $0x1ad8,%rdx
    128d:	00 00 00 
    1290:	ff d2                	call   *%rdx
      break;
    1292:	e9 78 01 00 00       	jmp    140f <ls+0x307>
    }
    strcpy(buf, path);
    1297:	48 8b 95 98 fd ff ff 	mov    -0x268(%rbp),%rdx
    129e:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    12a5:	48 89 d6             	mov    %rdx,%rsi
    12a8:	48 89 c7             	mov    %rax,%rdi
    12ab:	48 b8 e5 14 00 00 00 	movabs $0x14e5,%rax
    12b2:	00 00 00 
    12b5:	ff d0                	call   *%rax
    p = buf+strlen(buf);
    12b7:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    12be:	48 89 c7             	mov    %rax,%rdi
    12c1:	48 b8 7b 15 00 00 00 	movabs $0x157b,%rax
    12c8:	00 00 00 
    12cb:	ff d0                	call   *%rax
    12cd:	89 c2                	mov    %eax,%edx
    12cf:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    12d6:	48 01 d0             	add    %rdx,%rax
    12d9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    *p++ = '/';
    12dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    12e1:	48 8d 50 01          	lea    0x1(%rax),%rdx
    12e5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
    12e9:	c6 00 2f             	movb   $0x2f,(%rax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    12ec:	e9 f4 00 00 00       	jmp    13e5 <ls+0x2dd>
      if(de.inum == 0)
    12f1:	0f b7 85 c0 fd ff ff 	movzwl -0x240(%rbp),%eax
    12f8:	66 85 c0             	test   %ax,%ax
    12fb:	0f 84 e3 00 00 00    	je     13e4 <ls+0x2dc>
        continue;
      memmove(p, de.name, DIRSIZ);
    1301:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
    1308:	48 8d 48 02          	lea    0x2(%rax),%rcx
    130c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1310:	ba 0e 00 00 00       	mov    $0xe,%edx
    1315:	48 89 ce             	mov    %rcx,%rsi
    1318:	48 89 c7             	mov    %rax,%rdi
    131b:	48 b8 68 17 00 00 00 	movabs $0x1768,%rax
    1322:	00 00 00 
    1325:	ff d0                	call   *%rax
      p[DIRSIZ] = 0;
    1327:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    132b:	48 83 c0 0e          	add    $0xe,%rax
    132f:	c6 00 00             	movb   $0x0,(%rax)
      if(stat(buf, &st) < 0){
    1332:	48 8d 95 a0 fd ff ff 	lea    -0x260(%rbp),%rdx
    1339:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    1340:	48 89 d6             	mov    %rdx,%rsi
    1343:	48 89 c7             	mov    %rax,%rdi
    1346:	48 b8 a7 16 00 00 00 	movabs $0x16a7,%rax
    134d:	00 00 00 
    1350:	ff d0                	call   *%rax
    1352:	85 c0                	test   %eax,%eax
    1354:	79 2f                	jns    1385 <ls+0x27d>
        printf(1, "ls: cannot stat %s\n", buf);
    1356:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    135d:	48 b9 0e 22 00 00 00 	movabs $0x220e,%rcx
    1364:	00 00 00 
    1367:	48 89 c2             	mov    %rax,%rdx
    136a:	48 89 ce             	mov    %rcx,%rsi
    136d:	bf 01 00 00 00       	mov    $0x1,%edi
    1372:	b8 00 00 00 00       	mov    $0x0,%eax
    1377:	48 b9 d8 1a 00 00 00 	movabs $0x1ad8,%rcx
    137e:	00 00 00 
    1381:	ff d1                	call   *%rcx
        continue;
    1383:	eb 60                	jmp    13e5 <ls+0x2dd>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    1385:	44 8b ad b0 fd ff ff 	mov    -0x250(%rbp),%r13d
    138c:	44 8b a5 a8 fd ff ff 	mov    -0x258(%rbp),%r12d
    1393:	0f b7 85 a0 fd ff ff 	movzwl -0x260(%rbp),%eax
    139a:	0f bf d8             	movswl %ax,%ebx
    139d:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    13a4:	48 89 c7             	mov    %rax,%rdi
    13a7:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    13ae:	00 00 00 
    13b1:	ff d0                	call   *%rax
    13b3:	48 89 c2             	mov    %rax,%rdx
    13b6:	48 b8 22 22 00 00 00 	movabs $0x2222,%rax
    13bd:	00 00 00 
    13c0:	45 89 e9             	mov    %r13d,%r9d
    13c3:	45 89 e0             	mov    %r12d,%r8d
    13c6:	89 d9                	mov    %ebx,%ecx
    13c8:	48 89 c6             	mov    %rax,%rsi
    13cb:	bf 01 00 00 00       	mov    $0x1,%edi
    13d0:	b8 00 00 00 00       	mov    $0x0,%eax
    13d5:	49 ba d8 1a 00 00 00 	movabs $0x1ad8,%r10
    13dc:	00 00 00 
    13df:	41 ff d2             	call   *%r10
    13e2:	eb 01                	jmp    13e5 <ls+0x2dd>
        continue;
    13e4:	90                   	nop
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    13e5:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
    13ec:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13ef:	ba 10 00 00 00       	mov    $0x10,%edx
    13f4:	48 89 ce             	mov    %rcx,%rsi
    13f7:	89 c7                	mov    %eax,%edi
    13f9:	48 b8 f1 17 00 00 00 	movabs $0x17f1,%rax
    1400:	00 00 00 
    1403:	ff d0                	call   *%rax
    1405:	83 f8 10             	cmp    $0x10,%eax
    1408:	0f 84 e3 fe ff ff    	je     12f1 <ls+0x1e9>
    }
    break;
    140e:	90                   	nop
  }
  close(fd);
    140f:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1412:	89 c7                	mov    %eax,%edi
    1414:	48 b8 0b 18 00 00 00 	movabs $0x180b,%rax
    141b:	00 00 00 
    141e:	ff d0                	call   *%rax
}
    1420:	48 81 c4 58 02 00 00 	add    $0x258,%rsp
    1427:	5b                   	pop    %rbx
    1428:	41 5c                	pop    %r12
    142a:	41 5d                	pop    %r13
    142c:	5d                   	pop    %rbp
    142d:	c3                   	ret

000000000000142e <main>:

int
main(int argc, char *argv[])
{
    142e:	55                   	push   %rbp
    142f:	48 89 e5             	mov    %rsp,%rbp
    1432:	48 83 ec 20          	sub    $0x20,%rsp
    1436:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1439:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  if(argc < 2){
    143d:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1441:	7f 25                	jg     1468 <main+0x3a>
    ls(".");
    1443:	48 b8 42 22 00 00 00 	movabs $0x2242,%rax
    144a:	00 00 00 
    144d:	48 89 c7             	mov    %rax,%rdi
    1450:	48 b8 08 11 00 00 00 	movabs $0x1108,%rax
    1457:	00 00 00 
    145a:	ff d0                	call   *%rax
    exit();
    145c:	48 b8 ca 17 00 00 00 	movabs $0x17ca,%rax
    1463:	00 00 00 
    1466:	ff d0                	call   *%rax
  }
  for(i=1; i<argc; i++)
    1468:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    146f:	eb 2a                	jmp    149b <main+0x6d>
    ls(argv[i]);
    1471:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1474:	48 98                	cltq
    1476:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    147d:	00 
    147e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1482:	48 01 d0             	add    %rdx,%rax
    1485:	48 8b 00             	mov    (%rax),%rax
    1488:	48 89 c7             	mov    %rax,%rdi
    148b:	48 b8 08 11 00 00 00 	movabs $0x1108,%rax
    1492:	00 00 00 
    1495:	ff d0                	call   *%rax
  for(i=1; i<argc; i++)
    1497:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    149b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    149e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    14a1:	7c ce                	jl     1471 <main+0x43>
  exit();
    14a3:	48 b8 ca 17 00 00 00 	movabs $0x17ca,%rax
    14aa:	00 00 00 
    14ad:	ff d0                	call   *%rax

00000000000014af <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    14af:	55                   	push   %rbp
    14b0:	48 89 e5             	mov    %rsp,%rbp
    14b3:	48 83 ec 10          	sub    $0x10,%rsp
    14b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    14bb:	89 75 f4             	mov    %esi,-0xc(%rbp)
    14be:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    14c1:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    14c5:	8b 55 f0             	mov    -0x10(%rbp),%edx
    14c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
    14cb:	48 89 ce             	mov    %rcx,%rsi
    14ce:	48 89 f7             	mov    %rsi,%rdi
    14d1:	89 d1                	mov    %edx,%ecx
    14d3:	fc                   	cld
    14d4:	f3 aa                	rep stos %al,(%rdi)
    14d6:	89 ca                	mov    %ecx,%edx
    14d8:	48 89 fe             	mov    %rdi,%rsi
    14db:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    14df:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    14e2:	90                   	nop
    14e3:	c9                   	leave
    14e4:	c3                   	ret

00000000000014e5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    14e5:	55                   	push   %rbp
    14e6:	48 89 e5             	mov    %rsp,%rbp
    14e9:	48 83 ec 20          	sub    $0x20,%rsp
    14ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    14f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    14fd:	90                   	nop
    14fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1502:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1506:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    150a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    150e:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1512:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1516:	0f b6 12             	movzbl (%rdx),%edx
    1519:	88 10                	mov    %dl,(%rax)
    151b:	0f b6 00             	movzbl (%rax),%eax
    151e:	84 c0                	test   %al,%al
    1520:	75 dc                	jne    14fe <strcpy+0x19>
    ;
  return os;
    1522:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1526:	c9                   	leave
    1527:	c3                   	ret

0000000000001528 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1528:	55                   	push   %rbp
    1529:	48 89 e5             	mov    %rsp,%rbp
    152c:	48 83 ec 10          	sub    $0x10,%rsp
    1530:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1534:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1538:	eb 0a                	jmp    1544 <strcmp+0x1c>
    p++, q++;
    153a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    153f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1544:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1548:	0f b6 00             	movzbl (%rax),%eax
    154b:	84 c0                	test   %al,%al
    154d:	74 12                	je     1561 <strcmp+0x39>
    154f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1553:	0f b6 10             	movzbl (%rax),%edx
    1556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    155a:	0f b6 00             	movzbl (%rax),%eax
    155d:	38 c2                	cmp    %al,%dl
    155f:	74 d9                	je     153a <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1565:	0f b6 00             	movzbl (%rax),%eax
    1568:	0f b6 d0             	movzbl %al,%edx
    156b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    156f:	0f b6 00             	movzbl (%rax),%eax
    1572:	0f b6 c0             	movzbl %al,%eax
    1575:	29 c2                	sub    %eax,%edx
    1577:	89 d0                	mov    %edx,%eax
}
    1579:	c9                   	leave
    157a:	c3                   	ret

000000000000157b <strlen>:

uint
strlen(char *s)
{
    157b:	55                   	push   %rbp
    157c:	48 89 e5             	mov    %rsp,%rbp
    157f:	48 83 ec 18          	sub    $0x18,%rsp
    1583:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1587:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    158e:	eb 04                	jmp    1594 <strlen+0x19>
    1590:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1594:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1597:	48 63 d0             	movslq %eax,%rdx
    159a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    159e:	48 01 d0             	add    %rdx,%rax
    15a1:	0f b6 00             	movzbl (%rax),%eax
    15a4:	84 c0                	test   %al,%al
    15a6:	75 e8                	jne    1590 <strlen+0x15>
    ;
  return n;
    15a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    15ab:	c9                   	leave
    15ac:	c3                   	ret

00000000000015ad <memset>:

void*
memset(void *dst, int c, uint n)
{
    15ad:	55                   	push   %rbp
    15ae:	48 89 e5             	mov    %rsp,%rbp
    15b1:	48 83 ec 10          	sub    $0x10,%rsp
    15b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    15b9:	89 75 f4             	mov    %esi,-0xc(%rbp)
    15bc:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    15bf:	8b 55 f0             	mov    -0x10(%rbp),%edx
    15c2:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    15c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15c9:	89 ce                	mov    %ecx,%esi
    15cb:	48 89 c7             	mov    %rax,%rdi
    15ce:	48 b8 af 14 00 00 00 	movabs $0x14af,%rax
    15d5:	00 00 00 
    15d8:	ff d0                	call   *%rax
  return dst;
    15da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    15de:	c9                   	leave
    15df:	c3                   	ret

00000000000015e0 <strchr>:

char*
strchr(const char *s, char c)
{
    15e0:	55                   	push   %rbp
    15e1:	48 89 e5             	mov    %rsp,%rbp
    15e4:	48 83 ec 10          	sub    $0x10,%rsp
    15e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    15ec:	89 f0                	mov    %esi,%eax
    15ee:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    15f1:	eb 17                	jmp    160a <strchr+0x2a>
    if(*s == c)
    15f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15f7:	0f b6 00             	movzbl (%rax),%eax
    15fa:	38 45 f4             	cmp    %al,-0xc(%rbp)
    15fd:	75 06                	jne    1605 <strchr+0x25>
      return (char*)s;
    15ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1603:	eb 15                	jmp    161a <strchr+0x3a>
  for(; *s; s++)
    1605:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    160a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    160e:	0f b6 00             	movzbl (%rax),%eax
    1611:	84 c0                	test   %al,%al
    1613:	75 de                	jne    15f3 <strchr+0x13>
  return 0;
    1615:	b8 00 00 00 00       	mov    $0x0,%eax
}
    161a:	c9                   	leave
    161b:	c3                   	ret

000000000000161c <gets>:

char*
gets(char *buf, int max)
{
    161c:	55                   	push   %rbp
    161d:	48 89 e5             	mov    %rsp,%rbp
    1620:	48 83 ec 20          	sub    $0x20,%rsp
    1624:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1628:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    162b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1632:	eb 4f                	jmp    1683 <gets+0x67>
    cc = read(0, &c, 1);
    1634:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1638:	ba 01 00 00 00       	mov    $0x1,%edx
    163d:	48 89 c6             	mov    %rax,%rsi
    1640:	bf 00 00 00 00       	mov    $0x0,%edi
    1645:	48 b8 f1 17 00 00 00 	movabs $0x17f1,%rax
    164c:	00 00 00 
    164f:	ff d0                	call   *%rax
    1651:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1654:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1658:	7e 36                	jle    1690 <gets+0x74>
      break;
    buf[i++] = c;
    165a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    165d:	8d 50 01             	lea    0x1(%rax),%edx
    1660:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1663:	48 63 d0             	movslq %eax,%rdx
    1666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    166a:	48 01 c2             	add    %rax,%rdx
    166d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1671:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1673:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1677:	3c 0a                	cmp    $0xa,%al
    1679:	74 16                	je     1691 <gets+0x75>
    167b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    167f:	3c 0d                	cmp    $0xd,%al
    1681:	74 0e                	je     1691 <gets+0x75>
  for(i=0; i+1 < max; ){
    1683:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1686:	83 c0 01             	add    $0x1,%eax
    1689:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    168c:	7f a6                	jg     1634 <gets+0x18>
    168e:	eb 01                	jmp    1691 <gets+0x75>
      break;
    1690:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1691:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1694:	48 63 d0             	movslq %eax,%rdx
    1697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    169b:	48 01 d0             	add    %rdx,%rax
    169e:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    16a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    16a5:	c9                   	leave
    16a6:	c3                   	ret

00000000000016a7 <stat>:

int
stat(char *n, struct stat *st)
{
    16a7:	55                   	push   %rbp
    16a8:	48 89 e5             	mov    %rsp,%rbp
    16ab:	48 83 ec 20          	sub    $0x20,%rsp
    16af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    16b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    16b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    16bb:	be 00 00 00 00       	mov    $0x0,%esi
    16c0:	48 89 c7             	mov    %rax,%rdi
    16c3:	48 b8 32 18 00 00 00 	movabs $0x1832,%rax
    16ca:	00 00 00 
    16cd:	ff d0                	call   *%rax
    16cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    16d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    16d6:	79 07                	jns    16df <stat+0x38>
    return -1;
    16d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    16dd:	eb 2f                	jmp    170e <stat+0x67>
  r = fstat(fd, st);
    16df:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    16e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16e6:	48 89 d6             	mov    %rdx,%rsi
    16e9:	89 c7                	mov    %eax,%edi
    16eb:	48 b8 59 18 00 00 00 	movabs $0x1859,%rax
    16f2:	00 00 00 
    16f5:	ff d0                	call   *%rax
    16f7:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    16fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16fd:	89 c7                	mov    %eax,%edi
    16ff:	48 b8 0b 18 00 00 00 	movabs $0x180b,%rax
    1706:	00 00 00 
    1709:	ff d0                	call   *%rax
  return r;
    170b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    170e:	c9                   	leave
    170f:	c3                   	ret

0000000000001710 <atoi>:

int
atoi(const char *s)
{
    1710:	55                   	push   %rbp
    1711:	48 89 e5             	mov    %rsp,%rbp
    1714:	48 83 ec 18          	sub    $0x18,%rsp
    1718:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    171c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1723:	eb 28                	jmp    174d <atoi+0x3d>
    n = n*10 + *s++ - '0';
    1725:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1728:	89 d0                	mov    %edx,%eax
    172a:	c1 e0 02             	shl    $0x2,%eax
    172d:	01 d0                	add    %edx,%eax
    172f:	01 c0                	add    %eax,%eax
    1731:	89 c1                	mov    %eax,%ecx
    1733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1737:	48 8d 50 01          	lea    0x1(%rax),%rdx
    173b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    173f:	0f b6 00             	movzbl (%rax),%eax
    1742:	0f be c0             	movsbl %al,%eax
    1745:	01 c8                	add    %ecx,%eax
    1747:	83 e8 30             	sub    $0x30,%eax
    174a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    174d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1751:	0f b6 00             	movzbl (%rax),%eax
    1754:	3c 2f                	cmp    $0x2f,%al
    1756:	7e 0b                	jle    1763 <atoi+0x53>
    1758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    175c:	0f b6 00             	movzbl (%rax),%eax
    175f:	3c 39                	cmp    $0x39,%al
    1761:	7e c2                	jle    1725 <atoi+0x15>
  return n;
    1763:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1766:	c9                   	leave
    1767:	c3                   	ret

0000000000001768 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1768:	55                   	push   %rbp
    1769:	48 89 e5             	mov    %rsp,%rbp
    176c:	48 83 ec 28          	sub    $0x28,%rsp
    1770:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1774:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1778:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    177b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    177f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1783:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1787:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    178b:	eb 1d                	jmp    17aa <memmove+0x42>
    *dst++ = *src++;
    178d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1791:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1795:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1799:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    179d:	48 8d 48 01          	lea    0x1(%rax),%rcx
    17a1:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    17a5:	0f b6 12             	movzbl (%rdx),%edx
    17a8:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    17aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17ad:	8d 50 ff             	lea    -0x1(%rax),%edx
    17b0:	89 55 dc             	mov    %edx,-0x24(%rbp)
    17b3:	85 c0                	test   %eax,%eax
    17b5:	7f d6                	jg     178d <memmove+0x25>
  return vdst;
    17b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    17bb:	c9                   	leave
    17bc:	c3                   	ret

00000000000017bd <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    17bd:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    17c4:	49 89 ca             	mov    %rcx,%r10
    17c7:	0f 05                	syscall
    17c9:	c3                   	ret

00000000000017ca <exit>:
SYSCALL(exit)
    17ca:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    17d1:	49 89 ca             	mov    %rcx,%r10
    17d4:	0f 05                	syscall
    17d6:	c3                   	ret

00000000000017d7 <wait>:
SYSCALL(wait)
    17d7:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    17de:	49 89 ca             	mov    %rcx,%r10
    17e1:	0f 05                	syscall
    17e3:	c3                   	ret

00000000000017e4 <pipe>:
SYSCALL(pipe)
    17e4:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    17eb:	49 89 ca             	mov    %rcx,%r10
    17ee:	0f 05                	syscall
    17f0:	c3                   	ret

00000000000017f1 <read>:
SYSCALL(read)
    17f1:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    17f8:	49 89 ca             	mov    %rcx,%r10
    17fb:	0f 05                	syscall
    17fd:	c3                   	ret

00000000000017fe <write>:
SYSCALL(write)
    17fe:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1805:	49 89 ca             	mov    %rcx,%r10
    1808:	0f 05                	syscall
    180a:	c3                   	ret

000000000000180b <close>:
SYSCALL(close)
    180b:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1812:	49 89 ca             	mov    %rcx,%r10
    1815:	0f 05                	syscall
    1817:	c3                   	ret

0000000000001818 <kill>:
SYSCALL(kill)
    1818:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    181f:	49 89 ca             	mov    %rcx,%r10
    1822:	0f 05                	syscall
    1824:	c3                   	ret

0000000000001825 <exec>:
SYSCALL(exec)
    1825:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    182c:	49 89 ca             	mov    %rcx,%r10
    182f:	0f 05                	syscall
    1831:	c3                   	ret

0000000000001832 <open>:
SYSCALL(open)
    1832:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1839:	49 89 ca             	mov    %rcx,%r10
    183c:	0f 05                	syscall
    183e:	c3                   	ret

000000000000183f <mknod>:
SYSCALL(mknod)
    183f:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1846:	49 89 ca             	mov    %rcx,%r10
    1849:	0f 05                	syscall
    184b:	c3                   	ret

000000000000184c <unlink>:
SYSCALL(unlink)
    184c:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1853:	49 89 ca             	mov    %rcx,%r10
    1856:	0f 05                	syscall
    1858:	c3                   	ret

0000000000001859 <fstat>:
SYSCALL(fstat)
    1859:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1860:	49 89 ca             	mov    %rcx,%r10
    1863:	0f 05                	syscall
    1865:	c3                   	ret

0000000000001866 <link>:
SYSCALL(link)
    1866:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    186d:	49 89 ca             	mov    %rcx,%r10
    1870:	0f 05                	syscall
    1872:	c3                   	ret

0000000000001873 <mkdir>:
SYSCALL(mkdir)
    1873:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    187a:	49 89 ca             	mov    %rcx,%r10
    187d:	0f 05                	syscall
    187f:	c3                   	ret

0000000000001880 <chdir>:
SYSCALL(chdir)
    1880:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1887:	49 89 ca             	mov    %rcx,%r10
    188a:	0f 05                	syscall
    188c:	c3                   	ret

000000000000188d <dup>:
SYSCALL(dup)
    188d:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1894:	49 89 ca             	mov    %rcx,%r10
    1897:	0f 05                	syscall
    1899:	c3                   	ret

000000000000189a <getpid>:
SYSCALL(getpid)
    189a:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    18a1:	49 89 ca             	mov    %rcx,%r10
    18a4:	0f 05                	syscall
    18a6:	c3                   	ret

00000000000018a7 <sbrk>:
SYSCALL(sbrk)
    18a7:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    18ae:	49 89 ca             	mov    %rcx,%r10
    18b1:	0f 05                	syscall
    18b3:	c3                   	ret

00000000000018b4 <sleep>:
SYSCALL(sleep)
    18b4:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    18bb:	49 89 ca             	mov    %rcx,%r10
    18be:	0f 05                	syscall
    18c0:	c3                   	ret

00000000000018c1 <uptime>:
SYSCALL(uptime)
    18c1:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    18c8:	49 89 ca             	mov    %rcx,%r10
    18cb:	0f 05                	syscall
    18cd:	c3                   	ret

00000000000018ce <traceread>:
SYSCALL(traceread)
    18ce:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    18d5:	49 89 ca             	mov    %rcx,%r10
    18d8:	0f 05                	syscall
    18da:	c3                   	ret

00000000000018db <vidclear>:
SYSCALL(vidclear)
    18db:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    18e2:	49 89 ca             	mov    %rcx,%r10
    18e5:	0f 05                	syscall
    18e7:	c3                   	ret

00000000000018e8 <vidputc>:
SYSCALL(vidputc)
    18e8:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    18ef:	49 89 ca             	mov    %rcx,%r10
    18f2:	0f 05                	syscall
    18f4:	c3                   	ret

00000000000018f5 <vidputs>:
SYSCALL(vidputs)
    18f5:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    18fc:	49 89 ca             	mov    %rcx,%r10
    18ff:	0f 05                	syscall
    1901:	c3                   	ret

0000000000001902 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1902:	55                   	push   %rbp
    1903:	48 89 e5             	mov    %rsp,%rbp
    1906:	48 83 ec 10          	sub    $0x10,%rsp
    190a:	89 7d fc             	mov    %edi,-0x4(%rbp)
    190d:	89 f0                	mov    %esi,%eax
    190f:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1912:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1916:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1919:	ba 01 00 00 00       	mov    $0x1,%edx
    191e:	48 89 ce             	mov    %rcx,%rsi
    1921:	89 c7                	mov    %eax,%edi
    1923:	48 b8 fe 17 00 00 00 	movabs $0x17fe,%rax
    192a:	00 00 00 
    192d:	ff d0                	call   *%rax
}
    192f:	90                   	nop
    1930:	c9                   	leave
    1931:	c3                   	ret

0000000000001932 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1932:	55                   	push   %rbp
    1933:	48 89 e5             	mov    %rsp,%rbp
    1936:	48 83 ec 20          	sub    $0x20,%rsp
    193a:	89 7d ec             	mov    %edi,-0x14(%rbp)
    193d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1941:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1948:	eb 35                	jmp    197f <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    194a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    194e:	48 c1 e8 3c          	shr    $0x3c,%rax
    1952:	48 ba 50 22 00 00 00 	movabs $0x2250,%rdx
    1959:	00 00 00 
    195c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1960:	0f be d0             	movsbl %al,%edx
    1963:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1966:	89 d6                	mov    %edx,%esi
    1968:	89 c7                	mov    %eax,%edi
    196a:	48 b8 02 19 00 00 00 	movabs $0x1902,%rax
    1971:	00 00 00 
    1974:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1976:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    197a:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    197f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1982:	83 f8 0f             	cmp    $0xf,%eax
    1985:	76 c3                	jbe    194a <print_x64+0x18>
}
    1987:	90                   	nop
    1988:	90                   	nop
    1989:	c9                   	leave
    198a:	c3                   	ret

000000000000198b <print_x32>:

  static void
print_x32(int fd, uint x)
{
    198b:	55                   	push   %rbp
    198c:	48 89 e5             	mov    %rsp,%rbp
    198f:	48 83 ec 20          	sub    $0x20,%rsp
    1993:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1996:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1999:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    19a0:	eb 36                	jmp    19d8 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    19a2:	8b 45 e8             	mov    -0x18(%rbp),%eax
    19a5:	c1 e8 1c             	shr    $0x1c,%eax
    19a8:	89 c2                	mov    %eax,%edx
    19aa:	48 b8 50 22 00 00 00 	movabs $0x2250,%rax
    19b1:	00 00 00 
    19b4:	89 d2                	mov    %edx,%edx
    19b6:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    19ba:	0f be d0             	movsbl %al,%edx
    19bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
    19c0:	89 d6                	mov    %edx,%esi
    19c2:	89 c7                	mov    %eax,%edi
    19c4:	48 b8 02 19 00 00 00 	movabs $0x1902,%rax
    19cb:	00 00 00 
    19ce:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    19d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    19d4:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    19d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    19db:	83 f8 07             	cmp    $0x7,%eax
    19de:	76 c2                	jbe    19a2 <print_x32+0x17>
}
    19e0:	90                   	nop
    19e1:	90                   	nop
    19e2:	c9                   	leave
    19e3:	c3                   	ret

00000000000019e4 <print_d>:

  static void
print_d(int fd, int v)
{
    19e4:	55                   	push   %rbp
    19e5:	48 89 e5             	mov    %rsp,%rbp
    19e8:	48 83 ec 30          	sub    $0x30,%rsp
    19ec:	89 7d dc             	mov    %edi,-0x24(%rbp)
    19ef:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    19f2:	8b 45 d8             	mov    -0x28(%rbp),%eax
    19f5:	48 98                	cltq
    19f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    19fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    19ff:	79 04                	jns    1a05 <print_d+0x21>
    x = -x;
    1a01:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1a05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1a0c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a10:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a17:	66 66 66 
    1a1a:	48 89 c8             	mov    %rcx,%rax
    1a1d:	48 f7 ea             	imul   %rdx
    1a20:	48 c1 fa 02          	sar    $0x2,%rdx
    1a24:	48 89 c8             	mov    %rcx,%rax
    1a27:	48 c1 f8 3f          	sar    $0x3f,%rax
    1a2b:	48 29 c2             	sub    %rax,%rdx
    1a2e:	48 89 d0             	mov    %rdx,%rax
    1a31:	48 c1 e0 02          	shl    $0x2,%rax
    1a35:	48 01 d0             	add    %rdx,%rax
    1a38:	48 01 c0             	add    %rax,%rax
    1a3b:	48 29 c1             	sub    %rax,%rcx
    1a3e:	48 89 ca             	mov    %rcx,%rdx
    1a41:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a44:	8d 48 01             	lea    0x1(%rax),%ecx
    1a47:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1a4a:	48 b9 50 22 00 00 00 	movabs $0x2250,%rcx
    1a51:	00 00 00 
    1a54:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1a58:	48 98                	cltq
    1a5a:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1a5e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a62:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a69:	66 66 66 
    1a6c:	48 89 c8             	mov    %rcx,%rax
    1a6f:	48 f7 ea             	imul   %rdx
    1a72:	48 89 d0             	mov    %rdx,%rax
    1a75:	48 c1 f8 02          	sar    $0x2,%rax
    1a79:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1a7d:	48 89 ca             	mov    %rcx,%rdx
    1a80:	48 29 d0             	sub    %rdx,%rax
    1a83:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1a87:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1a8c:	0f 85 7a ff ff ff    	jne    1a0c <print_d+0x28>

  if (v < 0)
    1a92:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1a96:	79 32                	jns    1aca <print_d+0xe6>
    buf[i++] = '-';
    1a98:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a9b:	8d 50 01             	lea    0x1(%rax),%edx
    1a9e:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1aa1:	48 98                	cltq
    1aa3:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1aa8:	eb 20                	jmp    1aca <print_d+0xe6>
    putc(fd, buf[i]);
    1aaa:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1aad:	48 98                	cltq
    1aaf:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1ab4:	0f be d0             	movsbl %al,%edx
    1ab7:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1aba:	89 d6                	mov    %edx,%esi
    1abc:	89 c7                	mov    %eax,%edi
    1abe:	48 b8 02 19 00 00 00 	movabs $0x1902,%rax
    1ac5:	00 00 00 
    1ac8:	ff d0                	call   *%rax
  while (--i >= 0)
    1aca:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1ace:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1ad2:	79 d6                	jns    1aaa <print_d+0xc6>
}
    1ad4:	90                   	nop
    1ad5:	90                   	nop
    1ad6:	c9                   	leave
    1ad7:	c3                   	ret

0000000000001ad8 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1ad8:	55                   	push   %rbp
    1ad9:	48 89 e5             	mov    %rsp,%rbp
    1adc:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1ae3:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1ae9:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1af0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1af7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1afe:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1b05:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1b0c:	84 c0                	test   %al,%al
    1b0e:	74 20                	je     1b30 <printf+0x58>
    1b10:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1b14:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1b18:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1b1c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1b20:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1b24:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1b28:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1b2c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1b30:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1b37:	00 00 00 
    1b3a:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1b41:	00 00 00 
    1b44:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1b48:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1b4f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1b56:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b5d:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1b64:	00 00 00 
    1b67:	e9 60 03 00 00       	jmp    1ecc <printf+0x3f4>
    if (c != '%') {
    1b6c:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1b73:	74 24                	je     1b99 <printf+0xc1>
      putc(fd, c);
    1b75:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b7b:	0f be d0             	movsbl %al,%edx
    1b7e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b84:	89 d6                	mov    %edx,%esi
    1b86:	89 c7                	mov    %eax,%edi
    1b88:	48 b8 02 19 00 00 00 	movabs $0x1902,%rax
    1b8f:	00 00 00 
    1b92:	ff d0                	call   *%rax
      continue;
    1b94:	e9 2c 03 00 00       	jmp    1ec5 <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    1b99:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ba0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ba6:	48 63 d0             	movslq %eax,%rdx
    1ba9:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bb0:	48 01 d0             	add    %rdx,%rax
    1bb3:	0f b6 00             	movzbl (%rax),%eax
    1bb6:	0f be c0             	movsbl %al,%eax
    1bb9:	25 ff 00 00 00       	and    $0xff,%eax
    1bbe:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1bc4:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1bcb:	0f 84 2e 03 00 00    	je     1eff <printf+0x427>
      break;
    switch(c) {
    1bd1:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1bd8:	0f 84 32 01 00 00    	je     1d10 <printf+0x238>
    1bde:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1be5:	0f 8f a1 02 00 00    	jg     1e8c <printf+0x3b4>
    1beb:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1bf2:	0f 84 d4 01 00 00    	je     1dcc <printf+0x2f4>
    1bf8:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1bff:	0f 8f 87 02 00 00    	jg     1e8c <printf+0x3b4>
    1c05:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1c0c:	0f 84 5b 01 00 00    	je     1d6d <printf+0x295>
    1c12:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1c19:	0f 8f 6d 02 00 00    	jg     1e8c <printf+0x3b4>
    1c1f:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1c26:	0f 84 87 00 00 00    	je     1cb3 <printf+0x1db>
    1c2c:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1c33:	0f 8f 53 02 00 00    	jg     1e8c <printf+0x3b4>
    1c39:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1c40:	0f 84 2b 02 00 00    	je     1e71 <printf+0x399>
    1c46:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1c4d:	0f 85 39 02 00 00    	jne    1e8c <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    1c53:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c59:	83 f8 2f             	cmp    $0x2f,%eax
    1c5c:	77 23                	ja     1c81 <printf+0x1a9>
    1c5e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c65:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c6b:	89 d2                	mov    %edx,%edx
    1c6d:	48 01 d0             	add    %rdx,%rax
    1c70:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c76:	83 c2 08             	add    $0x8,%edx
    1c79:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c7f:	eb 12                	jmp    1c93 <printf+0x1bb>
    1c81:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1c88:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1c8c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1c93:	8b 00                	mov    (%rax),%eax
    1c95:	0f be d0             	movsbl %al,%edx
    1c98:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c9e:	89 d6                	mov    %edx,%esi
    1ca0:	89 c7                	mov    %eax,%edi
    1ca2:	48 b8 02 19 00 00 00 	movabs $0x1902,%rax
    1ca9:	00 00 00 
    1cac:	ff d0                	call   *%rax
      break;
    1cae:	e9 12 02 00 00       	jmp    1ec5 <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1cb3:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1cb9:	83 f8 2f             	cmp    $0x2f,%eax
    1cbc:	77 23                	ja     1ce1 <printf+0x209>
    1cbe:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1cc5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ccb:	89 d2                	mov    %edx,%edx
    1ccd:	48 01 d0             	add    %rdx,%rax
    1cd0:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1cd6:	83 c2 08             	add    $0x8,%edx
    1cd9:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1cdf:	eb 12                	jmp    1cf3 <printf+0x21b>
    1ce1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ce8:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1cec:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1cf3:	8b 10                	mov    (%rax),%edx
    1cf5:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1cfb:	89 d6                	mov    %edx,%esi
    1cfd:	89 c7                	mov    %eax,%edi
    1cff:	48 b8 e4 19 00 00 00 	movabs $0x19e4,%rax
    1d06:	00 00 00 
    1d09:	ff d0                	call   *%rax
      break;
    1d0b:	e9 b5 01 00 00       	jmp    1ec5 <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1d10:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d16:	83 f8 2f             	cmp    $0x2f,%eax
    1d19:	77 23                	ja     1d3e <printf+0x266>
    1d1b:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d22:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d28:	89 d2                	mov    %edx,%edx
    1d2a:	48 01 d0             	add    %rdx,%rax
    1d2d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d33:	83 c2 08             	add    $0x8,%edx
    1d36:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d3c:	eb 12                	jmp    1d50 <printf+0x278>
    1d3e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d45:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d49:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d50:	8b 10                	mov    (%rax),%edx
    1d52:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d58:	89 d6                	mov    %edx,%esi
    1d5a:	89 c7                	mov    %eax,%edi
    1d5c:	48 b8 8b 19 00 00 00 	movabs $0x198b,%rax
    1d63:	00 00 00 
    1d66:	ff d0                	call   *%rax
      break;
    1d68:	e9 58 01 00 00       	jmp    1ec5 <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1d6d:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d73:	83 f8 2f             	cmp    $0x2f,%eax
    1d76:	77 23                	ja     1d9b <printf+0x2c3>
    1d78:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d7f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d85:	89 d2                	mov    %edx,%edx
    1d87:	48 01 d0             	add    %rdx,%rax
    1d8a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d90:	83 c2 08             	add    $0x8,%edx
    1d93:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d99:	eb 12                	jmp    1dad <printf+0x2d5>
    1d9b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1da2:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1da6:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1dad:	48 8b 10             	mov    (%rax),%rdx
    1db0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1db6:	48 89 d6             	mov    %rdx,%rsi
    1db9:	89 c7                	mov    %eax,%edi
    1dbb:	48 b8 32 19 00 00 00 	movabs $0x1932,%rax
    1dc2:	00 00 00 
    1dc5:	ff d0                	call   *%rax
      break;
    1dc7:	e9 f9 00 00 00       	jmp    1ec5 <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1dcc:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1dd2:	83 f8 2f             	cmp    $0x2f,%eax
    1dd5:	77 23                	ja     1dfa <printf+0x322>
    1dd7:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1dde:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1de4:	89 d2                	mov    %edx,%edx
    1de6:	48 01 d0             	add    %rdx,%rax
    1de9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1def:	83 c2 08             	add    $0x8,%edx
    1df2:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1df8:	eb 12                	jmp    1e0c <printf+0x334>
    1dfa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1e01:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1e05:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1e0c:	48 8b 00             	mov    (%rax),%rax
    1e0f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1e16:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1e1d:	00 
    1e1e:	75 41                	jne    1e61 <printf+0x389>
        s = "(null)";
    1e20:	48 b8 44 22 00 00 00 	movabs $0x2244,%rax
    1e27:	00 00 00 
    1e2a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1e31:	eb 2e                	jmp    1e61 <printf+0x389>
        putc(fd, *(s++));
    1e33:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e3a:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1e3e:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1e45:	0f b6 00             	movzbl (%rax),%eax
    1e48:	0f be d0             	movsbl %al,%edx
    1e4b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e51:	89 d6                	mov    %edx,%esi
    1e53:	89 c7                	mov    %eax,%edi
    1e55:	48 b8 02 19 00 00 00 	movabs $0x1902,%rax
    1e5c:	00 00 00 
    1e5f:	ff d0                	call   *%rax
      while (*s)
    1e61:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e68:	0f b6 00             	movzbl (%rax),%eax
    1e6b:	84 c0                	test   %al,%al
    1e6d:	75 c4                	jne    1e33 <printf+0x35b>
      break;
    1e6f:	eb 54                	jmp    1ec5 <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1e71:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e77:	be 25 00 00 00       	mov    $0x25,%esi
    1e7c:	89 c7                	mov    %eax,%edi
    1e7e:	48 b8 02 19 00 00 00 	movabs $0x1902,%rax
    1e85:	00 00 00 
    1e88:	ff d0                	call   *%rax
      break;
    1e8a:	eb 39                	jmp    1ec5 <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1e8c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e92:	be 25 00 00 00       	mov    $0x25,%esi
    1e97:	89 c7                	mov    %eax,%edi
    1e99:	48 b8 02 19 00 00 00 	movabs $0x1902,%rax
    1ea0:	00 00 00 
    1ea3:	ff d0                	call   *%rax
      putc(fd, c);
    1ea5:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1eab:	0f be d0             	movsbl %al,%edx
    1eae:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1eb4:	89 d6                	mov    %edx,%esi
    1eb6:	89 c7                	mov    %eax,%edi
    1eb8:	48 b8 02 19 00 00 00 	movabs $0x1902,%rax
    1ebf:	00 00 00 
    1ec2:	ff d0                	call   *%rax
      break;
    1ec4:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1ec5:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ecc:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ed2:	48 63 d0             	movslq %eax,%rdx
    1ed5:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1edc:	48 01 d0             	add    %rdx,%rax
    1edf:	0f b6 00             	movzbl (%rax),%eax
    1ee2:	0f be c0             	movsbl %al,%eax
    1ee5:	25 ff 00 00 00       	and    $0xff,%eax
    1eea:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ef0:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1ef7:	0f 85 6f fc ff ff    	jne    1b6c <printf+0x94>
    }
  }
}
    1efd:	eb 01                	jmp    1f00 <printf+0x428>
      break;
    1eff:	90                   	nop
}
    1f00:	90                   	nop
    1f01:	c9                   	leave
    1f02:	c3                   	ret

0000000000001f03 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1f03:	55                   	push   %rbp
    1f04:	48 89 e5             	mov    %rsp,%rbp
    1f07:	48 83 ec 18          	sub    $0x18,%rsp
    1f0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1f0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f13:	48 83 e8 10          	sub    $0x10,%rax
    1f17:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f1b:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    1f22:	00 00 00 
    1f25:	48 8b 00             	mov    (%rax),%rax
    1f28:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f2c:	eb 2f                	jmp    1f5d <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f32:	48 8b 00             	mov    (%rax),%rax
    1f35:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f39:	72 17                	jb     1f52 <free+0x4f>
    1f3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f3f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f43:	72 2f                	jb     1f74 <free+0x71>
    1f45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f49:	48 8b 00             	mov    (%rax),%rax
    1f4c:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f50:	72 22                	jb     1f74 <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f56:	48 8b 00             	mov    (%rax),%rax
    1f59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f61:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f65:	73 c7                	jae    1f2e <free+0x2b>
    1f67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f6b:	48 8b 00             	mov    (%rax),%rax
    1f6e:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f72:	73 ba                	jae    1f2e <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f78:	8b 40 08             	mov    0x8(%rax),%eax
    1f7b:	89 c0                	mov    %eax,%eax
    1f7d:	48 c1 e0 04          	shl    $0x4,%rax
    1f81:	48 89 c2             	mov    %rax,%rdx
    1f84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f88:	48 01 c2             	add    %rax,%rdx
    1f8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f8f:	48 8b 00             	mov    (%rax),%rax
    1f92:	48 39 c2             	cmp    %rax,%rdx
    1f95:	75 2d                	jne    1fc4 <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f9b:	8b 50 08             	mov    0x8(%rax),%edx
    1f9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fa2:	48 8b 00             	mov    (%rax),%rax
    1fa5:	8b 40 08             	mov    0x8(%rax),%eax
    1fa8:	01 c2                	add    %eax,%edx
    1faa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fae:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1fb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fb5:	48 8b 00             	mov    (%rax),%rax
    1fb8:	48 8b 10             	mov    (%rax),%rdx
    1fbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fbf:	48 89 10             	mov    %rdx,(%rax)
    1fc2:	eb 0e                	jmp    1fd2 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1fc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fc8:	48 8b 10             	mov    (%rax),%rdx
    1fcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fcf:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1fd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fd6:	8b 40 08             	mov    0x8(%rax),%eax
    1fd9:	89 c0                	mov    %eax,%eax
    1fdb:	48 c1 e0 04          	shl    $0x4,%rax
    1fdf:	48 89 c2             	mov    %rax,%rdx
    1fe2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fe6:	48 01 d0             	add    %rdx,%rax
    1fe9:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1fed:	75 27                	jne    2016 <free+0x113>
    p->s.size += bp->s.size;
    1fef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ff3:	8b 50 08             	mov    0x8(%rax),%edx
    1ff6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ffa:	8b 40 08             	mov    0x8(%rax),%eax
    1ffd:	01 c2                	add    %eax,%edx
    1fff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2003:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    2006:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    200a:	48 8b 10             	mov    (%rax),%rdx
    200d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2011:	48 89 10             	mov    %rdx,(%rax)
    2014:	eb 0b                	jmp    2021 <free+0x11e>
  } else
    p->s.ptr = bp;
    2016:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    201a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    201e:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    2021:	48 ba 90 22 00 00 00 	movabs $0x2290,%rdx
    2028:	00 00 00 
    202b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    202f:	48 89 02             	mov    %rax,(%rdx)
}
    2032:	90                   	nop
    2033:	c9                   	leave
    2034:	c3                   	ret

0000000000002035 <morecore>:

static Header*
morecore(uint nu)
{
    2035:	55                   	push   %rbp
    2036:	48 89 e5             	mov    %rsp,%rbp
    2039:	48 83 ec 20          	sub    $0x20,%rsp
    203d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    2040:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    2047:	77 07                	ja     2050 <morecore+0x1b>
    nu = 4096;
    2049:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    2050:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2053:	48 c1 e0 04          	shl    $0x4,%rax
    2057:	48 89 c7             	mov    %rax,%rdi
    205a:	48 b8 a7 18 00 00 00 	movabs $0x18a7,%rax
    2061:	00 00 00 
    2064:	ff d0                	call   *%rax
    2066:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    206a:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    206f:	75 07                	jne    2078 <morecore+0x43>
    return 0;
    2071:	b8 00 00 00 00       	mov    $0x0,%eax
    2076:	eb 36                	jmp    20ae <morecore+0x79>
  hp = (Header*)p;
    2078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    207c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    2080:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2084:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2087:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    208a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    208e:	48 83 c0 10          	add    $0x10,%rax
    2092:	48 89 c7             	mov    %rax,%rdi
    2095:	48 b8 03 1f 00 00 00 	movabs $0x1f03,%rax
    209c:	00 00 00 
    209f:	ff d0                	call   *%rax
  return freep;
    20a1:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    20a8:	00 00 00 
    20ab:	48 8b 00             	mov    (%rax),%rax
}
    20ae:	c9                   	leave
    20af:	c3                   	ret

00000000000020b0 <malloc>:

void*
malloc(uint nbytes)
{
    20b0:	55                   	push   %rbp
    20b1:	48 89 e5             	mov    %rsp,%rbp
    20b4:	48 83 ec 30          	sub    $0x30,%rsp
    20b8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    20bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
    20be:	48 83 c0 0f          	add    $0xf,%rax
    20c2:	48 c1 e8 04          	shr    $0x4,%rax
    20c6:	83 c0 01             	add    $0x1,%eax
    20c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    20cc:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    20d3:	00 00 00 
    20d6:	48 8b 00             	mov    (%rax),%rax
    20d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20dd:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    20e2:	75 4a                	jne    212e <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    20e4:	48 b8 80 22 00 00 00 	movabs $0x2280,%rax
    20eb:	00 00 00 
    20ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20f2:	48 ba 90 22 00 00 00 	movabs $0x2290,%rdx
    20f9:	00 00 00 
    20fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2100:	48 89 02             	mov    %rax,(%rdx)
    2103:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    210a:	00 00 00 
    210d:	48 8b 00             	mov    (%rax),%rax
    2110:	48 ba 80 22 00 00 00 	movabs $0x2280,%rdx
    2117:	00 00 00 
    211a:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    211d:	48 b8 80 22 00 00 00 	movabs $0x2280,%rax
    2124:	00 00 00 
    2127:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    212e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2132:	48 8b 00             	mov    (%rax),%rax
    2135:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    2139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    213d:	8b 40 08             	mov    0x8(%rax),%eax
    2140:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    2143:	72 65                	jb     21aa <malloc+0xfa>
      if(p->s.size == nunits)
    2145:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2149:	8b 40 08             	mov    0x8(%rax),%eax
    214c:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    214f:	75 10                	jne    2161 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    2151:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2155:	48 8b 10             	mov    (%rax),%rdx
    2158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    215c:	48 89 10             	mov    %rdx,(%rax)
    215f:	eb 2e                	jmp    218f <malloc+0xdf>
      else {
        p->s.size -= nunits;
    2161:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2165:	8b 40 08             	mov    0x8(%rax),%eax
    2168:	2b 45 ec             	sub    -0x14(%rbp),%eax
    216b:	89 c2                	mov    %eax,%edx
    216d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2171:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    2174:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2178:	8b 40 08             	mov    0x8(%rax),%eax
    217b:	89 c0                	mov    %eax,%eax
    217d:	48 c1 e0 04          	shl    $0x4,%rax
    2181:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    2185:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2189:	8b 55 ec             	mov    -0x14(%rbp),%edx
    218c:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    218f:	48 ba 90 22 00 00 00 	movabs $0x2290,%rdx
    2196:	00 00 00 
    2199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    219d:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    21a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21a4:	48 83 c0 10          	add    $0x10,%rax
    21a8:	eb 4e                	jmp    21f8 <malloc+0x148>
    }
    if(p == freep)
    21aa:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    21b1:	00 00 00 
    21b4:	48 8b 00             	mov    (%rax),%rax
    21b7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    21bb:	75 23                	jne    21e0 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    21bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
    21c0:	89 c7                	mov    %eax,%edi
    21c2:	48 b8 35 20 00 00 00 	movabs $0x2035,%rax
    21c9:	00 00 00 
    21cc:	ff d0                	call   *%rax
    21ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    21d2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    21d7:	75 07                	jne    21e0 <malloc+0x130>
        return 0;
    21d9:	b8 00 00 00 00       	mov    $0x0,%eax
    21de:	eb 18                	jmp    21f8 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    21e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    21e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21ec:	48 8b 00             	mov    (%rax),%rax
    21ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    21f3:	e9 41 ff ff ff       	jmp    2139 <malloc+0x89>
  }
}
    21f8:	c9                   	leave
    21f9:	c3                   	ret

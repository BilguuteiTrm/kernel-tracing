
bootblocktmp.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
    7c00:	fa                   	cli
    7c01:	31 c0                	xor    %eax,%eax
    7c03:	8e d8                	mov    %eax,%ds
    7c05:	8e c0                	mov    %eax,%es
    7c07:	8e d0                	mov    %eax,%ss

00007c09 <seta20.1>:
    7c09:	e4 64                	in     $0x64,%al
    7c0b:	a8 02                	test   $0x2,%al
    7c0d:	75 fa                	jne    7c09 <seta20.1>
    7c0f:	b0 d1                	mov    $0xd1,%al
    7c11:	e6 64                	out    %al,$0x64

00007c13 <seta20.2>:
    7c13:	e4 64                	in     $0x64,%al
    7c15:	a8 02                	test   $0x2,%al
    7c17:	75 fa                	jne    7c13 <seta20.2>
    7c19:	b0 df                	mov    $0xdf,%al
    7c1b:	e6 60                	out    %al,$0x60
    7c1d:	0f 01 16             	lgdtl  (%esi)
    7c20:	68 7c 0f 20 c0       	push   $0xc0200f7c
    7c25:	66 83 c8 01          	or     $0x1,%ax
    7c29:	0f 22 c0             	mov    %eax,%cr0
    7c2c:	ea                   	.byte 0xea
    7c2d:	31 7c 08 00          	xor    %edi,0x0(%eax,%ecx,1)

00007c31 <start32>:
    7c31:	66 b8 10 00          	mov    $0x10,%ax
    7c35:	8e d8                	mov    %eax,%ds
    7c37:	8e c0                	mov    %eax,%es
    7c39:	8e d0                	mov    %eax,%ss
    7c3b:	66 b8 00 00          	mov    $0x0,%ax
    7c3f:	8e e0                	mov    %eax,%fs
    7c41:	8e e8                	mov    %eax,%gs
    7c43:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    7c48:	e8 f4 00 00 00       	call   7d41 <bootmain>

00007c4d <spin>:
    7c4d:	eb fe                	jmp    7c4d <spin>
    7c4f:	90                   	nop

00007c50 <gdt>:
	...
    7c58:	ff                   	(bad)
    7c59:	ff 00                	incl   (%eax)
    7c5b:	00 00                	add    %al,(%eax)
    7c5d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c64:	00                   	.byte 0
    7c65:	92                   	xchg   %eax,%edx
    7c66:	cf                   	iret
	...

00007c68 <gdtdesc>:
    7c68:	17                   	pop    %ss
    7c69:	00 50 7c             	add    %dl,0x7c(%eax)
    7c6c:	00 00                	add    %al,(%eax)
    7c6e:	66 90                	xchg   %ax,%ax
    7c70:	66 90                	xchg   %ax,%ax
    7c72:	66 90                	xchg   %ax,%ax
    7c74:	66 90                	xchg   %ax,%ax
    7c76:	66 90                	xchg   %ax,%ax
    7c78:	66 90                	xchg   %ax,%ax
    7c7a:	66 90                	xchg   %ax,%ax
    7c7c:	66 90                	xchg   %ax,%ax
    7c7e:	66 90                	xchg   %ax,%ax

00007c80 <waitdisk>:
    7c80:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c85:	ec                   	in     (%dx),%al
    7c86:	83 e0 c0             	and    $0xffffffc0,%eax
    7c89:	3c 40                	cmp    $0x40,%al
    7c8b:	75 f8                	jne    7c85 <waitdisk+0x5>
    7c8d:	c3                   	ret

00007c8e <readsect>:
    7c8e:	55                   	push   %ebp
    7c8f:	89 e5                	mov    %esp,%ebp
    7c91:	57                   	push   %edi
    7c92:	53                   	push   %ebx
    7c93:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    7c96:	e8 e5 ff ff ff       	call   7c80 <waitdisk>
    7c9b:	b8 01 00 00 00       	mov    $0x1,%eax
    7ca0:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7ca5:	ee                   	out    %al,(%dx)
    7ca6:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7cab:	89 d8                	mov    %ebx,%eax
    7cad:	ee                   	out    %al,(%dx)
    7cae:	89 d8                	mov    %ebx,%eax
    7cb0:	c1 e8 08             	shr    $0x8,%eax
    7cb3:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cb8:	ee                   	out    %al,(%dx)
    7cb9:	89 d8                	mov    %ebx,%eax
    7cbb:	c1 e8 10             	shr    $0x10,%eax
    7cbe:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7cc3:	ee                   	out    %al,(%dx)
    7cc4:	89 d8                	mov    %ebx,%eax
    7cc6:	c1 e8 18             	shr    $0x18,%eax
    7cc9:	83 c8 e0             	or     $0xffffffe0,%eax
    7ccc:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7cd1:	ee                   	out    %al,(%dx)
    7cd2:	b8 20 00 00 00       	mov    $0x20,%eax
    7cd7:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cdc:	ee                   	out    %al,(%dx)
    7cdd:	e8 9e ff ff ff       	call   7c80 <waitdisk>
    7ce2:	8b 45 08             	mov    0x8(%ebp),%eax
    7ce5:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cea:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cef:	89 c7                	mov    %eax,%edi
    7cf1:	fc                   	cld
    7cf2:	f3 6d                	rep insl (%dx),%es:(%edi)
    7cf4:	5b                   	pop    %ebx
    7cf5:	5f                   	pop    %edi
    7cf6:	5d                   	pop    %ebp
    7cf7:	c3                   	ret

00007cf8 <readseg>:
    7cf8:	55                   	push   %ebp
    7cf9:	89 e5                	mov    %esp,%ebp
    7cfb:	57                   	push   %edi
    7cfc:	56                   	push   %esi
    7cfd:	53                   	push   %ebx
    7cfe:	83 ec 0c             	sub    $0xc,%esp
    7d01:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7d04:	8b 75 10             	mov    0x10(%ebp),%esi
    7d07:	89 df                	mov    %ebx,%edi
    7d09:	03 7d 0c             	add    0xc(%ebp),%edi
    7d0c:	89 f0                	mov    %esi,%eax
    7d0e:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d13:	29 c3                	sub    %eax,%ebx
    7d15:	39 fb                	cmp    %edi,%ebx
    7d17:	73 20                	jae    7d39 <readseg+0x41>
    7d19:	c1 ee 09             	shr    $0x9,%esi
    7d1c:	83 c6 01             	add    $0x1,%esi
    7d1f:	83 ec 08             	sub    $0x8,%esp
    7d22:	56                   	push   %esi
    7d23:	53                   	push   %ebx
    7d24:	e8 65 ff ff ff       	call   7c8e <readsect>
    7d29:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7d2f:	83 c6 01             	add    $0x1,%esi
    7d32:	83 c4 10             	add    $0x10,%esp
    7d35:	39 fb                	cmp    %edi,%ebx
    7d37:	72 e6                	jb     7d1f <readseg+0x27>
    7d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d3c:	5b                   	pop    %ebx
    7d3d:	5e                   	pop    %esi
    7d3e:	5f                   	pop    %edi
    7d3f:	5d                   	pop    %ebp
    7d40:	c3                   	ret

00007d41 <bootmain>:
    7d41:	55                   	push   %ebp
    7d42:	89 e5                	mov    %esp,%ebp
    7d44:	57                   	push   %edi
    7d45:	56                   	push   %esi
    7d46:	53                   	push   %ebx
    7d47:	83 ec 10             	sub    $0x10,%esp
    7d4a:	6a 00                	push   $0x0
    7d4c:	68 00 20 00 00       	push   $0x2000
    7d51:	68 00 00 01 00       	push   $0x10000
    7d56:	e8 9d ff ff ff       	call   7cf8 <readseg>
    7d5b:	83 c4 10             	add    $0x10,%esp
    7d5e:	bb 00 00 01 00       	mov    $0x10000,%ebx
    7d63:	eb 26                	jmp    7d8b <bootmain+0x4a>
    7d65:	eb 19                	jmp    7d80 <bootmain+0x3f>
    7d67:	90                   	nop
    7d68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    7d6f:	00 
    7d70:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    7d77:	00 
    7d78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    7d7f:	00 
    7d80:	83 c3 04             	add    $0x4,%ebx
    7d83:	81 fb 00 20 01 00    	cmp    $0x12000,%ebx
    7d89:	74 2e                	je     7db9 <bootmain+0x78>
    7d8b:	89 de                	mov    %ebx,%esi
    7d8d:	81 3b 02 b0 ad 1b    	cmpl   $0x1badb002,(%ebx)
    7d93:	75 eb                	jne    7d80 <bootmain+0x3f>
    7d95:	8b 43 08             	mov    0x8(%ebx),%eax
    7d98:	03 43 04             	add    0x4(%ebx),%eax
    7d9b:	3d fe 4f 52 e4       	cmp    $0xe4524ffe,%eax
    7da0:	75 de                	jne    7d80 <bootmain+0x3f>
    7da2:	f6 43 06 01          	testb  $0x1,0x6(%ebx)
    7da6:	74 11                	je     7db9 <bootmain+0x78>
    7da8:	8b 43 10             	mov    0x10(%ebx),%eax
    7dab:	8b 53 0c             	mov    0xc(%ebx),%edx
    7dae:	39 c2                	cmp    %eax,%edx
    7db0:	72 07                	jb     7db9 <bootmain+0x78>
    7db2:	8b 4b 14             	mov    0x14(%ebx),%ecx
    7db5:	39 c1                	cmp    %eax,%ecx
    7db7:	73 08                	jae    7dc1 <bootmain+0x80>
    7db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7dbc:	5b                   	pop    %ebx
    7dbd:	5e                   	pop    %esi
    7dbe:	5f                   	pop    %edi
    7dbf:	5d                   	pop    %ebp
    7dc0:	c3                   	ret
    7dc1:	83 ec 04             	sub    $0x4,%esp
    7dc4:	8d bc 18 00 00 ff ff 	lea    -0x10000(%eax,%ebx,1),%edi
    7dcb:	29 d7                	sub    %edx,%edi
    7dcd:	57                   	push   %edi
    7dce:	29 c1                	sub    %eax,%ecx
    7dd0:	51                   	push   %ecx
    7dd1:	50                   	push   %eax
    7dd2:	e8 21 ff ff ff       	call   7cf8 <readseg>
    7dd7:	8b 4b 18             	mov    0x18(%ebx),%ecx
    7dda:	8b 43 14             	mov    0x14(%ebx),%eax
    7ddd:	83 c4 10             	add    $0x10,%esp
    7de0:	39 c8                	cmp    %ecx,%eax
    7de2:	73 0e                	jae    7df2 <bootmain+0xb1>
    7de4:	29 c1                	sub    %eax,%ecx
    7de6:	89 c2                	mov    %eax,%edx
    7de8:	b8 00 00 00 00       	mov    $0x0,%eax
    7ded:	89 d7                	mov    %edx,%edi
    7def:	fc                   	cld
    7df0:	f3 aa                	rep stos %al,%es:(%edi)
    7df2:	ff 56 1c             	call   *0x1c(%esi)
    7df5:	eb c2                	jmp    7db9 <bootmain+0x78>

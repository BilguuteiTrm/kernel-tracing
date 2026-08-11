
kernel:     file format elf64-x86-64


Disassembly of section .text:

ffff800000100000 <begin>:
ffff800000100000:	02 b0 ad 1b 00 00    	add    0x1bad(%rax),%dh
ffff800000100006:	01 00                	add    %eax,(%rax)
ffff800000100008:	fe 4f 51             	decb   0x51(%rdi)
ffff80000010000b:	e4 00                	in     $0x0,%al
ffff80000010000d:	00 10                	add    %dl,(%rax)
ffff80000010000f:	00 00                	add    %al,(%rax)
ffff800000100011:	00 10                	add    %dl,(%rax)
ffff800000100013:	00 00                	add    %al,(%rax)
ffff800000100015:	f0 10 00             	lock adc %al,(%rax)
ffff800000100018:	00 e0                	add    %ah,%al
ffff80000010001a:	11 00                	adc    %eax,(%rax)
ffff80000010001c:	20 00                	and    %al,(%rax)
ffff80000010001e:	10 00                	adc    %al,(%rax)

ffff800000100020 <mboot_entry>:
  .long mboot_entry_addr

.code32
mboot_entry:
# zero 2 pages for our bootstrap page tables
  xor     %eax, %eax    # value=0
ffff800000100020:	31 c0                	xor    %eax,%eax
  mov     $0x1000, %edi # starting at 4096
ffff800000100022:	bf 00 10 00 00       	mov    $0x1000,%edi
  mov     $0x2000, %ecx # size=8192
ffff800000100027:	b9 00 20 00 00       	mov    $0x2000,%ecx
  rep     stosb         # memset(4096, 0, 8192)
ffff80000010002c:	f3 aa                	rep stos %al,(%rdi)

# map both virtual address 0 and KERNBASE to the same PDPT
# note: 32-bit operations manipulating 64-bit page table
# PML4T[0] -> 0x2000 (PDPT)
# PML4T[256] -> 0x2000 (PDPT)
  mov     $(0x2000 | PTE_P | PTE_W), %eax
ffff80000010002e:	b8 03 20 00 00       	mov    $0x2003,%eax
  mov     %eax, 0x1000  # PML4T[0]
ffff800000100033:	a3 00 10 00 00 a3 00 	movabs %eax,0x1800a300001000
ffff80000010003a:	18 00 
  mov     %eax, 0x1800  # PML4T[256]
ffff80000010003c:	00 b8 83 00 00 00    	add    %bh,0x83(%rax)

# PDPT[0] -> 0x0 (1 GB flat map page)
  mov     $(0x0 | PTE_P | PTE_PS | PTE_W), %eax
  mov     %eax, 0x2000  # PDPT[0]
ffff800000100042:	a3                   	.byte 0xa3
ffff800000100043:	00 20                	add    %ah,(%rax)
ffff800000100045:	00 00                	add    %al,(%rax)

# Clear ebx for initial processor boot.
# When secondary processors boot, they'll call through
# entry32mp (from entryother), but with a nonzero ebx.
# We'll reuse these bootstrap pagetables and GDT.
  xor     %ebx, %ebx
ffff800000100047:	31 db                	xor    %ebx,%ebx

ffff800000100049 <entry32mp>:

.global entry32mp
entry32mp:
# CR3 -> 0x1000 (PML4T)
  mov     $0x1000, %eax
ffff800000100049:	b8 00 10 00 00       	mov    $0x1000,%eax
  mov     %eax, %cr3
ffff80000010004e:	0f 22 d8             	mov    %rax,%cr3

  lgdt    (gdtr64 - mboot_header + mboot_load_addr)
ffff800000100051:	0f 01 15 90 00 10 00 	lgdt   0x100090(%rip)        # ffff8000002000e8 <end+0xe20e8>

# PAE is required for 64-bit paging: CR4.PAE=1
  mov     %cr4, %eax
ffff800000100058:	0f 20 e0             	mov    %cr4,%rax
  bts     $5, %eax
ffff80000010005b:	0f ba e8 05          	bts    $0x5,%eax
  mov     %eax, %cr4
ffff80000010005f:	0f 22 e0             	mov    %rax,%cr4

# access EFER Model specific register
  mov     $MSR_EFER, %ecx
ffff800000100062:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  rdmsr
ffff800000100067:	0f 32                	rdmsr
  bts     $0, %eax #enable system call extensions
ffff800000100069:	0f ba e8 00          	bts    $0x0,%eax
  bts     $8, %eax #enable long mode
ffff80000010006d:	0f ba e8 08          	bts    $0x8,%eax
  wrmsr
ffff800000100071:	0f 30                	wrmsr

# enable paging
  mov     %cr0, %eax
ffff800000100073:	0f 20 c0             	mov    %cr0,%rax
  orl     $(CR0_PG | CR0_WP | CR0_MP), %eax
ffff800000100076:	0d 02 00 01 80       	or     $0x80010002,%eax
  mov     %eax, %cr0
ffff80000010007b:	0f 22 c0             	mov    %rax,%cr0

# shift to 64bit segment
  ljmp    $8, $(entry64low - mboot_header + mboot_load_addr)
ffff80000010007e:	ea                   	(bad)
ffff80000010007f:	c0 00 10             	rolb   $0x10,(%rax)
ffff800000100082:	00 08                	add    %cl,(%rax)
ffff800000100084:	00 66 66             	add    %ah,0x66(%rsi)
ffff800000100087:	2e 0f 1f 84 00 00 00 	cs nopl 0x0(%rax,%rax,1)
ffff80000010008e:	00 00 

ffff800000100090 <gdtr64>:
ffff800000100090:	17                   	(bad)
ffff800000100091:	00 a0 00 10 00 00    	add    %ah,0x1000(%rax)
ffff800000100097:	00 00                	add    %al,(%rax)
ffff800000100099:	00 90 0f 1f 44 00    	add    %dl,0x441f0f(%rax)
	...

ffff8000001000a0 <gdt64_begin>:
	...
ffff8000001000ac:	00 98 20 00 00 00    	add    %bl,0x20(%rax)
ffff8000001000b2:	00 00                	add    %al,(%rax)
ffff8000001000b4:	00                   	.byte 0
ffff8000001000b5:	90                   	nop
	...

ffff8000001000b8 <gdt64_end>:
ffff8000001000b8:	90                   	nop
ffff8000001000b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

ffff8000001000c0 <entry64low>:
gdt64_end:

.align 16
.code64
entry64low:
  movabs  $entry64high, %rax
ffff8000001000c0:	48 b8 cc 00 10 00 00 	movabs $0xffff8000001000cc,%rax
ffff8000001000c7:	80 ff ff 
  jmp     *%rax
ffff8000001000ca:	ff e0                	jmp    *%rax

ffff8000001000cc <_start>:
.global _start
_start:
entry64high:

# ensure data segment registers are sane
  xor     %rax, %rax
ffff8000001000cc:	48 31 c0             	xor    %rax,%rax
  mov     %ax, %ss
ffff8000001000cf:	8e d0                	mov    %eax,%ss
  mov     %ax, %ds
ffff8000001000d1:	8e d8                	mov    %eax,%ds
  mov     %ax, %es
ffff8000001000d3:	8e c0                	mov    %eax,%es
  mov     %ax, %fs
ffff8000001000d5:	8e e0                	mov    %eax,%fs
  mov     %ax, %gs
ffff8000001000d7:	8e e8                	mov    %eax,%gs
  # mov     %cr4, %rax
  # or      $(CR4_PAE | CR4_OSXFSR | CR4_OSXMMEXCPT) , %rax
  # mov     %rax, %cr4

# check to see if we're booting a secondary core
  test    %ebx, %ebx
ffff8000001000d9:	85 db                	test   %ebx,%ebx
  jnz     entry64mp  # jump if booting a secondary code
ffff8000001000db:	75 14                	jne    ffff8000001000f1 <entry64mp>
# setup initial stack
  movabs  $0xFFFF800000010000, %rax
ffff8000001000dd:	48 b8 00 00 01 00 00 	movabs $0xffff800000010000,%rax
ffff8000001000e4:	80 ff ff 
  mov     %rax, %rsp
ffff8000001000e7:	48 89 c4             	mov    %rax,%rsp

# enter main()
  jmp     main  # end of initial (the first) core ASM
ffff8000001000ea:	e9 fc 54 00 00       	jmp    ffff8000001055eb <main>

ffff8000001000ef <__deadloop>:

.global __deadloop
__deadloop:
# we should never return here...
  jmp     .
ffff8000001000ef:	eb fe                	jmp    ffff8000001000ef <__deadloop>

ffff8000001000f1 <entry64mp>:

entry64mp:
# obtain kstack from data block before entryother
  mov     $0x7000, %rax
ffff8000001000f1:	48 c7 c0 00 70 00 00 	mov    $0x7000,%rax
  mov     -16(%rax), %rsp
ffff8000001000f8:	48 8b 60 f0          	mov    -0x10(%rax),%rsp
  jmp     mpenter  # end of secondary code ASM
ffff8000001000fc:	e9 1a 56 00 00       	jmp    ffff80000010571b <mpenter>

ffff800000100101 <wrmsr>:

.global wrmsr
wrmsr:
  mov     %rdi, %rcx     # arg0 -> msrnum
ffff800000100101:	48 89 f9             	mov    %rdi,%rcx
  mov     %rsi, %rax     # val.low -> eax
ffff800000100104:	48 89 f0             	mov    %rsi,%rax
  shr     $32, %rsi
ffff800000100107:	48 c1 ee 20          	shr    $0x20,%rsi
  mov     %rsi, %rdx     # val.high -> edx
ffff80000010010b:	48 89 f2             	mov    %rsi,%rdx
  wrmsr
ffff80000010010e:	0f 30                	wrmsr
  retq
ffff800000100110:	c3                   	ret

ffff800000100111 <ignore_sysret>:

.global ignore_sysret
ignore_sysret: #return error code 38, meaning function unimplemented
  mov     $-38, %rax
ffff800000100111:	48 c7 c0 da ff ff ff 	mov    $0xffffffffffffffda,%rax
  sysretq
ffff800000100118:	48 0f 07             	sysretq

ffff80000010011b <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
ffff80000010011b:	55                   	push   %rbp
ffff80000010011c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010011f:	48 83 ec 10          	sub    $0x10,%rsp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
ffff800000100123:	48 ba c0 c6 10 00 00 	movabs $0xffff80000010c6c0,%rdx
ffff80000010012a:	80 ff ff 
ffff80000010012d:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff800000100134:	80 ff ff 
ffff800000100137:	48 89 d6             	mov    %rdx,%rsi
ffff80000010013a:	48 89 c7             	mov    %rax,%rdi
ffff80000010013d:	48 b8 a5 76 10 00 00 	movabs $0xffff8000001076a5,%rax
ffff800000100144:	80 ff ff 
ffff800000100147:	ff d0                	call   *%rax
//PAGEBREAK!

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
ffff800000100149:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff800000100150:	80 ff ff 
ffff800000100153:	48 b9 08 41 11 00 00 	movabs $0xffff800000114108,%rcx
ffff80000010015a:	80 ff ff 
ffff80000010015d:	48 89 88 a0 51 00 00 	mov    %rcx,0x51a0(%rax)
  bcache.head.next = &bcache.head;
ffff800000100164:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff80000010016b:	80 ff ff 
ffff80000010016e:	48 89 88 a8 51 00 00 	mov    %rcx,0x51a8(%rax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
ffff800000100175:	48 b8 68 f0 10 00 00 	movabs $0xffff80000010f068,%rax
ffff80000010017c:	80 ff ff 
ffff80000010017f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100183:	e9 8e 00 00 00       	jmp    ffff800000100216 <binit+0xfb>
    b->next = bcache.head.next;
ffff800000100188:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff80000010018f:	80 ff ff 
ffff800000100192:	48 8b 90 a8 51 00 00 	mov    0x51a8(%rax),%rdx
ffff800000100199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010019d:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->prev = &bcache.head;
ffff8000001001a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001001a8:	48 be 08 41 11 00 00 	movabs $0xffff800000114108,%rsi
ffff8000001001af:	80 ff ff 
ffff8000001001b2:	48 89 b0 98 00 00 00 	mov    %rsi,0x98(%rax)
    initsleeplock(&b->lock, "buffer");
ffff8000001001b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001001bd:	48 83 c0 10          	add    $0x10,%rax
ffff8000001001c1:	48 ba c7 c6 10 00 00 	movabs $0xffff80000010c6c7,%rdx
ffff8000001001c8:	80 ff ff 
ffff8000001001cb:	48 89 d6             	mov    %rdx,%rsi
ffff8000001001ce:	48 89 c7             	mov    %rax,%rdi
ffff8000001001d1:	48 b8 cf 74 10 00 00 	movabs $0xffff8000001074cf,%rax
ffff8000001001d8:	80 ff ff 
ffff8000001001db:	ff d0                	call   *%rax
    bcache.head.next->prev = b;
ffff8000001001dd:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff8000001001e4:	80 ff ff 
ffff8000001001e7:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff8000001001ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001001f2:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    bcache.head.next = b;
ffff8000001001f9:	48 ba 00 f0 10 00 00 	movabs $0xffff80000010f000,%rdx
ffff800000100200:	80 ff ff 
ffff800000100203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100207:	48 89 82 a8 51 00 00 	mov    %rax,0x51a8(%rdx)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
ffff80000010020e:	48 81 45 f8 b0 02 00 	addq   $0x2b0,-0x8(%rbp)
ffff800000100215:	00 
ffff800000100216:	48 b8 08 41 11 00 00 	movabs $0xffff800000114108,%rax
ffff80000010021d:	80 ff ff 
ffff800000100220:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000100224:	0f 82 5e ff ff ff    	jb     ffff800000100188 <binit+0x6d>
  }
}
ffff80000010022a:	90                   	nop
ffff80000010022b:	90                   	nop
ffff80000010022c:	c9                   	leave
ffff80000010022d:	c3                   	ret

ffff80000010022e <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
ffff80000010022e:	55                   	push   %rbp
ffff80000010022f:	48 89 e5             	mov    %rsp,%rbp
ffff800000100232:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100236:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000100239:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *b;

  acquire(&bcache.lock);
ffff80000010023c:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff800000100243:	80 ff ff 
ffff800000100246:	48 89 c7             	mov    %rax,%rdi
ffff800000100249:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000100250:	80 ff ff 
ffff800000100253:	ff d0                	call   *%rax

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
ffff800000100255:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff80000010025c:	80 ff ff 
ffff80000010025f:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff800000100266:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010026a:	eb 77                	jmp    ffff8000001002e3 <bget+0xb5>
    if(b->dev == dev && b->blockno == blockno){
ffff80000010026c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100270:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000100273:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000100276:	75 5c                	jne    ffff8000001002d4 <bget+0xa6>
ffff800000100278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010027c:	8b 40 08             	mov    0x8(%rax),%eax
ffff80000010027f:	39 45 e8             	cmp    %eax,-0x18(%rbp)
ffff800000100282:	75 50                	jne    ffff8000001002d4 <bget+0xa6>
      b->refcnt++;
ffff800000100284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100288:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff80000010028e:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000100291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100295:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
      release(&bcache.lock);
ffff80000010029b:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff8000001002a2:	80 ff ff 
ffff8000001002a5:	48 89 c7             	mov    %rax,%rdi
ffff8000001002a8:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001002af:	80 ff ff 
ffff8000001002b2:	ff d0                	call   *%rax
      acquiresleep(&b->lock);
ffff8000001002b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002b8:	48 83 c0 10          	add    $0x10,%rax
ffff8000001002bc:	48 89 c7             	mov    %rax,%rdi
ffff8000001002bf:	48 b8 27 75 10 00 00 	movabs $0xffff800000107527,%rax
ffff8000001002c6:	80 ff ff 
ffff8000001002c9:	ff d0                	call   *%rax
      return b;
ffff8000001002cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002cf:	e9 f6 00 00 00       	jmp    ffff8000001003ca <bget+0x19c>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
ffff8000001002d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002d8:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff8000001002df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001002e3:	48 b8 08 41 11 00 00 	movabs $0xffff800000114108,%rax
ffff8000001002ea:	80 ff ff 
ffff8000001002ed:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001002f1:	0f 85 75 ff ff ff    	jne    ffff80000010026c <bget+0x3e>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
ffff8000001002f7:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff8000001002fe:	80 ff ff 
ffff800000100301:	48 8b 80 a0 51 00 00 	mov    0x51a0(%rax),%rax
ffff800000100308:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010030c:	e9 8c 00 00 00       	jmp    ffff80000010039d <bget+0x16f>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
ffff800000100311:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100315:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff80000010031b:	85 c0                	test   %eax,%eax
ffff80000010031d:	75 6f                	jne    ffff80000010038e <bget+0x160>
ffff80000010031f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100323:	8b 00                	mov    (%rax),%eax
ffff800000100325:	83 e0 04             	and    $0x4,%eax
ffff800000100328:	85 c0                	test   %eax,%eax
ffff80000010032a:	75 62                	jne    ffff80000010038e <bget+0x160>
      b->dev = dev;
ffff80000010032c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100330:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000100333:	89 50 04             	mov    %edx,0x4(%rax)
      b->blockno = blockno;
ffff800000100336:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010033a:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010033d:	89 50 08             	mov    %edx,0x8(%rax)
      b->flags = 0;
ffff800000100340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100344:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
      b->refcnt = 1;
ffff80000010034a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010034e:	c7 80 90 00 00 00 01 	movl   $0x1,0x90(%rax)
ffff800000100355:	00 00 00 
      release(&bcache.lock);
ffff800000100358:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff80000010035f:	80 ff ff 
ffff800000100362:	48 89 c7             	mov    %rax,%rdi
ffff800000100365:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010036c:	80 ff ff 
ffff80000010036f:	ff d0                	call   *%rax
      acquiresleep(&b->lock);
ffff800000100371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100375:	48 83 c0 10          	add    $0x10,%rax
ffff800000100379:	48 89 c7             	mov    %rax,%rdi
ffff80000010037c:	48 b8 27 75 10 00 00 	movabs $0xffff800000107527,%rax
ffff800000100383:	80 ff ff 
ffff800000100386:	ff d0                	call   *%rax
      return b;
ffff800000100388:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010038c:	eb 3c                	jmp    ffff8000001003ca <bget+0x19c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
ffff80000010038e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100392:	48 8b 80 98 00 00 00 	mov    0x98(%rax),%rax
ffff800000100399:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010039d:	48 b8 08 41 11 00 00 	movabs $0xffff800000114108,%rax
ffff8000001003a4:	80 ff ff 
ffff8000001003a7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001003ab:	0f 85 60 ff ff ff    	jne    ffff800000100311 <bget+0xe3>
    }
  }
  panic("bget: no buffers");
ffff8000001003b1:	48 b8 ce c6 10 00 00 	movabs $0xffff80000010c6ce,%rax
ffff8000001003b8:	80 ff ff 
ffff8000001003bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001003be:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001003c5:	80 ff ff 
ffff8000001003c8:	ff d0                	call   *%rax
}
ffff8000001003ca:	c9                   	leave
ffff8000001003cb:	c3                   	ret

ffff8000001003cc <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
ffff8000001003cc:	55                   	push   %rbp
ffff8000001003cd:	48 89 e5             	mov    %rsp,%rbp
ffff8000001003d0:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001003d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001003d7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *b;

  b = bget(dev, blockno);
ffff8000001003da:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff8000001003dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001003e0:	89 d6                	mov    %edx,%esi
ffff8000001003e2:	89 c7                	mov    %eax,%edi
ffff8000001003e4:	48 b8 2e 02 10 00 00 	movabs $0xffff80000010022e,%rax
ffff8000001003eb:	80 ff ff 
ffff8000001003ee:	ff d0                	call   *%rax
ffff8000001003f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(!(b->flags & B_VALID)) {
ffff8000001003f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001003f8:	8b 00                	mov    (%rax),%eax
ffff8000001003fa:	83 e0 02             	and    $0x2,%eax
ffff8000001003fd:	85 c0                	test   %eax,%eax
ffff8000001003ff:	75 13                	jne    ffff800000100414 <bread+0x48>
    iderw(b);
ffff800000100401:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100405:	48 89 c7             	mov    %rax,%rdi
ffff800000100408:	48 b8 e3 3d 10 00 00 	movabs $0xffff800000103de3,%rax
ffff80000010040f:	80 ff ff 
ffff800000100412:	ff d0                	call   *%rax
  }
  return b;
ffff800000100414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000100418:	c9                   	leave
ffff800000100419:	c3                   	ret

ffff80000010041a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
ffff80000010041a:	55                   	push   %rbp
ffff80000010041b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010041e:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000100422:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holdingsleep(&b->lock))
ffff800000100426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010042a:	48 83 c0 10          	add    $0x10,%rax
ffff80000010042e:	48 89 c7             	mov    %rax,%rdi
ffff800000100431:	48 b8 12 76 10 00 00 	movabs $0xffff800000107612,%rax
ffff800000100438:	80 ff ff 
ffff80000010043b:	ff d0                	call   *%rax
ffff80000010043d:	85 c0                	test   %eax,%eax
ffff80000010043f:	75 19                	jne    ffff80000010045a <bwrite+0x40>
    panic("bwrite");
ffff800000100441:	48 b8 df c6 10 00 00 	movabs $0xffff80000010c6df,%rax
ffff800000100448:	80 ff ff 
ffff80000010044b:	48 89 c7             	mov    %rax,%rdi
ffff80000010044e:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000100455:	80 ff ff 
ffff800000100458:	ff d0                	call   *%rax
  b->flags |= B_DIRTY;
ffff80000010045a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010045e:	8b 00                	mov    (%rax),%eax
ffff800000100460:	83 c8 04             	or     $0x4,%eax
ffff800000100463:	89 c2                	mov    %eax,%edx
ffff800000100465:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100469:	89 10                	mov    %edx,(%rax)
  iderw(b);
ffff80000010046b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010046f:	48 89 c7             	mov    %rax,%rdi
ffff800000100472:	48 b8 e3 3d 10 00 00 	movabs $0xffff800000103de3,%rax
ffff800000100479:	80 ff ff 
ffff80000010047c:	ff d0                	call   *%rax
}
ffff80000010047e:	90                   	nop
ffff80000010047f:	c9                   	leave
ffff800000100480:	c3                   	ret

ffff800000100481 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
ffff800000100481:	55                   	push   %rbp
ffff800000100482:	48 89 e5             	mov    %rsp,%rbp
ffff800000100485:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000100489:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holdingsleep(&b->lock))
ffff80000010048d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100491:	48 83 c0 10          	add    $0x10,%rax
ffff800000100495:	48 89 c7             	mov    %rax,%rdi
ffff800000100498:	48 b8 12 76 10 00 00 	movabs $0xffff800000107612,%rax
ffff80000010049f:	80 ff ff 
ffff8000001004a2:	ff d0                	call   *%rax
ffff8000001004a4:	85 c0                	test   %eax,%eax
ffff8000001004a6:	75 19                	jne    ffff8000001004c1 <brelse+0x40>
    panic("brelse");
ffff8000001004a8:	48 b8 e6 c6 10 00 00 	movabs $0xffff80000010c6e6,%rax
ffff8000001004af:	80 ff ff 
ffff8000001004b2:	48 89 c7             	mov    %rax,%rdi
ffff8000001004b5:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001004bc:	80 ff ff 
ffff8000001004bf:	ff d0                	call   *%rax

  releasesleep(&b->lock);
ffff8000001004c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004c5:	48 83 c0 10          	add    $0x10,%rax
ffff8000001004c9:	48 89 c7             	mov    %rax,%rdi
ffff8000001004cc:	48 b8 ad 75 10 00 00 	movabs $0xffff8000001075ad,%rax
ffff8000001004d3:	80 ff ff 
ffff8000001004d6:	ff d0                	call   *%rax

  acquire(&bcache.lock);
ffff8000001004d8:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff8000001004df:	80 ff ff 
ffff8000001004e2:	48 89 c7             	mov    %rax,%rdi
ffff8000001004e5:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff8000001004ec:	80 ff ff 
ffff8000001004ef:	ff d0                	call   *%rax
  b->refcnt--;
ffff8000001004f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004f5:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff8000001004fb:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001004fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100502:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
  if (b->refcnt == 0) {
ffff800000100508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010050c:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000100512:	85 c0                	test   %eax,%eax
ffff800000100514:	0f 85 9c 00 00 00    	jne    ffff8000001005b6 <brelse+0x135>
    // no one is waiting for it.
    b->next->prev = b->prev;
ffff80000010051a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010051e:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff800000100525:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000100529:	48 8b 92 98 00 00 00 	mov    0x98(%rdx),%rdx
ffff800000100530:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    b->prev->next = b->next;
ffff800000100537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010053b:	48 8b 80 98 00 00 00 	mov    0x98(%rax),%rax
ffff800000100542:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000100546:	48 8b 92 a0 00 00 00 	mov    0xa0(%rdx),%rdx
ffff80000010054d:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->next = bcache.head.next;
ffff800000100554:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff80000010055b:	80 ff ff 
ffff80000010055e:	48 8b 90 a8 51 00 00 	mov    0x51a8(%rax),%rdx
ffff800000100565:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100569:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->prev = &bcache.head;
ffff800000100570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100574:	48 b9 08 41 11 00 00 	movabs $0xffff800000114108,%rcx
ffff80000010057b:	80 ff ff 
ffff80000010057e:	48 89 88 98 00 00 00 	mov    %rcx,0x98(%rax)
    bcache.head.next->prev = b;
ffff800000100585:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff80000010058c:	80 ff ff 
ffff80000010058f:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff800000100596:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010059a:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    bcache.head.next = b;
ffff8000001005a1:	48 ba 00 f0 10 00 00 	movabs $0xffff80000010f000,%rdx
ffff8000001005a8:	80 ff ff 
ffff8000001005ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001005af:	48 89 82 a8 51 00 00 	mov    %rax,0x51a8(%rdx)
  }

  release(&bcache.lock);
ffff8000001005b6:	48 b8 00 f0 10 00 00 	movabs $0xffff80000010f000,%rax
ffff8000001005bd:	80 ff ff 
ffff8000001005c0:	48 89 c7             	mov    %rax,%rdi
ffff8000001005c3:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001005ca:	80 ff ff 
ffff8000001005cd:	ff d0                	call   *%rax
}
ffff8000001005cf:	90                   	nop
ffff8000001005d0:	c9                   	leave
ffff8000001005d1:	c3                   	ret

ffff8000001005d2 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
ffff8000001005d2:	55                   	push   %rbp
ffff8000001005d3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001005d6:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001005da:	89 f8                	mov    %edi,%eax
ffff8000001005dc:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff8000001005e0:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff8000001005e4:	89 c2                	mov    %eax,%edx
ffff8000001005e6:	ec                   	in     (%dx),%al
ffff8000001005e7:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff8000001005ea:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff8000001005ee:	c9                   	leave
ffff8000001005ef:	c3                   	ret

ffff8000001005f0 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
ffff8000001005f0:	55                   	push   %rbp
ffff8000001005f1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001005f4:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001005f8:	89 fa                	mov    %edi,%edx
ffff8000001005fa:	89 f0                	mov    %esi,%eax
ffff8000001005fc:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffff800000100600:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000100603:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000100607:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff80000010060b:	ee                   	out    %al,(%dx)
}
ffff80000010060c:	90                   	nop
ffff80000010060d:	c9                   	leave
ffff80000010060e:	c3                   	ret

ffff80000010060f <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
ffff80000010060f:	55                   	push   %rbp
ffff800000100610:	48 89 e5             	mov    %rsp,%rbp
ffff800000100613:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000100617:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010061b:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  volatile ushort pd[5];
  addr_t addr = (addr_t)p;
ffff80000010061e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000100622:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  pd[0] = size-1;
ffff800000100626:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000100629:	83 e8 01             	sub    $0x1,%eax
ffff80000010062c:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff800000100630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100634:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff800000100638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010063c:	48 c1 e8 10          	shr    $0x10,%rax
ffff800000100640:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff800000100644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100648:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010064c:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff800000100650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100654:	48 c1 e8 30          	shr    $0x30,%rax
ffff800000100658:	66 89 45 f6          	mov    %ax,-0xa(%rbp)

  asm volatile("lidt (%0)" : : "r" (pd));
ffff80000010065c:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff800000100660:	0f 01 18             	lidt   (%rax)
}
ffff800000100663:	90                   	nop
ffff800000100664:	c9                   	leave
ffff800000100665:	c3                   	ret

ffff800000100666 <cli>:
  return eflags;
}

static inline void
cli(void)
{
ffff800000100666:	55                   	push   %rbp
ffff800000100667:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("cli");
ffff80000010066a:	fa                   	cli
}
ffff80000010066b:	90                   	nop
ffff80000010066c:	5d                   	pop    %rbp
ffff80000010066d:	c3                   	ret

ffff80000010066e <hlt>:
  asm volatile("sti");
}

static inline void
hlt(void)
{
ffff80000010066e:	55                   	push   %rbp
ffff80000010066f:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("hlt");
ffff800000100672:	f4                   	hlt
}
ffff800000100673:	90                   	nop
ffff800000100674:	5d                   	pop    %rbp
ffff800000100675:	c3                   	ret

ffff800000100676 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(addr_t x)
{
ffff800000100676:	55                   	push   %rbp
ffff800000100677:	48 89 e5             	mov    %rsp,%rbp
ffff80000010067a:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010067e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
ffff800000100682:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000100689:	eb 30                	jmp    ffff8000001006bb <print_x64+0x45>
    consputc(digits[x >> (sizeof(addr_t) * 8 - 4)]);
ffff80000010068b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010068f:	48 c1 e8 3c          	shr    $0x3c,%rax
ffff800000100693:	48 ba 00 d0 10 00 00 	movabs $0xffff80000010d000,%rdx
ffff80000010069a:	80 ff ff 
ffff80000010069d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff8000001006a1:	0f be c0             	movsbl %al,%eax
ffff8000001006a4:	89 c7                	mov    %eax,%edi
ffff8000001006a6:	48 b8 ff 0f 10 00 00 	movabs $0xffff800000100fff,%rax
ffff8000001006ad:	80 ff ff 
ffff8000001006b0:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
ffff8000001006b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001006b6:	48 c1 65 e8 04       	shlq   $0x4,-0x18(%rbp)
ffff8000001006bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001006be:	83 f8 0f             	cmp    $0xf,%eax
ffff8000001006c1:	76 c8                	jbe    ffff80000010068b <print_x64+0x15>
}
ffff8000001006c3:	90                   	nop
ffff8000001006c4:	90                   	nop
ffff8000001006c5:	c9                   	leave
ffff8000001006c6:	c3                   	ret

ffff8000001006c7 <print_x32>:

  static void
print_x32(uint x)
{
ffff8000001006c7:	55                   	push   %rbp
ffff8000001006c8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001006cb:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001006cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
ffff8000001006d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001006d9:	eb 31                	jmp    ffff80000010070c <print_x32+0x45>
    consputc(digits[x >> (sizeof(uint) * 8 - 4)]);
ffff8000001006db:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001006de:	c1 e8 1c             	shr    $0x1c,%eax
ffff8000001006e1:	89 c2                	mov    %eax,%edx
ffff8000001006e3:	48 b8 00 d0 10 00 00 	movabs $0xffff80000010d000,%rax
ffff8000001006ea:	80 ff ff 
ffff8000001006ed:	89 d2                	mov    %edx,%edx
ffff8000001006ef:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
ffff8000001006f3:	0f be c0             	movsbl %al,%eax
ffff8000001006f6:	89 c7                	mov    %eax,%edi
ffff8000001006f8:	48 b8 ff 0f 10 00 00 	movabs $0xffff800000100fff,%rax
ffff8000001006ff:	80 ff ff 
ffff800000100702:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
ffff800000100704:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000100708:	c1 65 ec 04          	shll   $0x4,-0x14(%rbp)
ffff80000010070c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010070f:	83 f8 07             	cmp    $0x7,%eax
ffff800000100712:	76 c7                	jbe    ffff8000001006db <print_x32+0x14>
}
ffff800000100714:	90                   	nop
ffff800000100715:	90                   	nop
ffff800000100716:	c9                   	leave
ffff800000100717:	c3                   	ret

ffff800000100718 <print_d>:

  static void
print_d(int v)
{
ffff800000100718:	55                   	push   %rbp
ffff800000100719:	48 89 e5             	mov    %rsp,%rbp
ffff80000010071c:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000100720:	89 7d dc             	mov    %edi,-0x24(%rbp)
  char buf[16];
  int64 x = v;
ffff800000100723:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000100726:	48 98                	cltq
ffff800000100728:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
ffff80000010072c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000100730:	79 04                	jns    ffff800000100736 <print_d+0x1e>
    x = -x;
ffff800000100732:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
ffff800000100736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
ffff80000010073d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000100741:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
ffff800000100748:	66 66 66 
ffff80000010074b:	48 89 c8             	mov    %rcx,%rax
ffff80000010074e:	48 f7 ea             	imul   %rdx
ffff800000100751:	48 c1 fa 02          	sar    $0x2,%rdx
ffff800000100755:	48 89 c8             	mov    %rcx,%rax
ffff800000100758:	48 c1 f8 3f          	sar    $0x3f,%rax
ffff80000010075c:	48 29 c2             	sub    %rax,%rdx
ffff80000010075f:	48 89 d0             	mov    %rdx,%rax
ffff800000100762:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000100766:	48 01 d0             	add    %rdx,%rax
ffff800000100769:	48 01 c0             	add    %rax,%rax
ffff80000010076c:	48 29 c1             	sub    %rax,%rcx
ffff80000010076f:	48 89 ca             	mov    %rcx,%rdx
ffff800000100772:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000100775:	8d 48 01             	lea    0x1(%rax),%ecx
ffff800000100778:	89 4d f4             	mov    %ecx,-0xc(%rbp)
ffff80000010077b:	48 b9 00 d0 10 00 00 	movabs $0xffff80000010d000,%rcx
ffff800000100782:	80 ff ff 
ffff800000100785:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
ffff800000100789:	48 98                	cltq
ffff80000010078b:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
ffff80000010078f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000100793:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
ffff80000010079a:	66 66 66 
ffff80000010079d:	48 89 c8             	mov    %rcx,%rax
ffff8000001007a0:	48 f7 ea             	imul   %rdx
ffff8000001007a3:	48 89 d0             	mov    %rdx,%rax
ffff8000001007a6:	48 c1 f8 02          	sar    $0x2,%rax
ffff8000001007aa:	48 c1 f9 3f          	sar    $0x3f,%rcx
ffff8000001007ae:	48 89 ca             	mov    %rcx,%rdx
ffff8000001007b1:	48 29 d0             	sub    %rdx,%rax
ffff8000001007b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
ffff8000001007b8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001007bd:	0f 85 7a ff ff ff    	jne    ffff80000010073d <print_d+0x25>

  if (v < 0)
ffff8000001007c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff8000001007c7:	79 2d                	jns    ffff8000001007f6 <print_d+0xde>
    buf[i++] = '-';
ffff8000001007c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001007cc:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001007cf:	89 55 f4             	mov    %edx,-0xc(%rbp)
ffff8000001007d2:	48 98                	cltq
ffff8000001007d4:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
ffff8000001007d9:	eb 1b                	jmp    ffff8000001007f6 <print_d+0xde>
    consputc(buf[i]);
ffff8000001007db:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001007de:	48 98                	cltq
ffff8000001007e0:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
ffff8000001007e5:	0f be c0             	movsbl %al,%eax
ffff8000001007e8:	89 c7                	mov    %eax,%edi
ffff8000001007ea:	48 b8 ff 0f 10 00 00 	movabs $0xffff800000100fff,%rax
ffff8000001007f1:	80 ff ff 
ffff8000001007f4:	ff d0                	call   *%rax
  while (--i >= 0)
ffff8000001007f6:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
ffff8000001007fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff8000001007fe:	79 db                	jns    ffff8000001007db <print_d+0xc3>
}
ffff800000100800:	90                   	nop
ffff800000100801:	90                   	nop
ffff800000100802:	c9                   	leave
ffff800000100803:	c3                   	ret

ffff800000100804 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
  void
cprintf(char *fmt, ...)
{
ffff800000100804:	55                   	push   %rbp
ffff800000100805:	48 89 e5             	mov    %rsp,%rbp
ffff800000100808:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
ffff80000010080f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
ffff800000100816:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
ffff80000010081d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
ffff800000100824:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
ffff80000010082b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
ffff800000100832:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
ffff800000100839:	84 c0                	test   %al,%al
ffff80000010083b:	74 20                	je     ffff80000010085d <cprintf+0x59>
ffff80000010083d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
ffff800000100841:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
ffff800000100845:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
ffff800000100849:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
ffff80000010084d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
ffff800000100851:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
ffff800000100855:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
ffff800000100859:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c, locking;
  char *s;

  va_start(ap, fmt);
ffff80000010085d:	c7 85 20 ff ff ff 08 	movl   $0x8,-0xe0(%rbp)
ffff800000100864:	00 00 00 
ffff800000100867:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
ffff80000010086e:	00 00 00 
ffff800000100871:	48 8d 45 10          	lea    0x10(%rbp),%rax
ffff800000100875:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
ffff80000010087c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
ffff800000100883:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)

  locking = cons.locking;
ffff80000010088a:	48 b8 c0 44 11 00 00 	movabs $0xffff8000001144c0,%rax
ffff800000100891:	80 ff ff 
ffff800000100894:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000100897:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
  if (locking)
ffff80000010089d:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
ffff8000001008a4:	74 19                	je     ffff8000001008bf <cprintf+0xbb>
    acquire(&cons.lock);
ffff8000001008a6:	48 b8 c0 44 11 00 00 	movabs $0xffff8000001144c0,%rax
ffff8000001008ad:	80 ff ff 
ffff8000001008b0:	48 89 c7             	mov    %rax,%rdi
ffff8000001008b3:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff8000001008ba:	80 ff ff 
ffff8000001008bd:	ff d0                	call   *%rax

  if (fmt == 0)
ffff8000001008bf:	48 83 bd 18 ff ff ff 	cmpq   $0x0,-0xe8(%rbp)
ffff8000001008c6:	00 
ffff8000001008c7:	75 19                	jne    ffff8000001008e2 <cprintf+0xde>
    panic("null fmt");
ffff8000001008c9:	48 b8 ed c6 10 00 00 	movabs $0xffff80000010c6ed,%rax
ffff8000001008d0:	80 ff ff 
ffff8000001008d3:	48 89 c7             	mov    %rax,%rdi
ffff8000001008d6:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001008dd:	80 ff ff 
ffff8000001008e0:	ff d0                	call   *%rax

  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
ffff8000001008e2:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
ffff8000001008e9:	00 00 00 
ffff8000001008ec:	e9 a0 02 00 00       	jmp    ffff800000100b91 <cprintf+0x38d>
    if (c != '%') {
ffff8000001008f1:	83 bd 38 ff ff ff 25 	cmpl   $0x25,-0xc8(%rbp)
ffff8000001008f8:	74 19                	je     ffff800000100913 <cprintf+0x10f>
      consputc(c);
ffff8000001008fa:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffff800000100900:	89 c7                	mov    %eax,%edi
ffff800000100902:	48 b8 ff 0f 10 00 00 	movabs $0xffff800000100fff,%rax
ffff800000100909:	80 ff ff 
ffff80000010090c:	ff d0                	call   *%rax
      continue;
ffff80000010090e:	e9 77 02 00 00       	jmp    ffff800000100b8a <cprintf+0x386>
    }
    c = fmt[++i] & 0xff;
ffff800000100913:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffff80000010091a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000100920:	48 63 d0             	movslq %eax,%rdx
ffff800000100923:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
ffff80000010092a:	48 01 d0             	add    %rdx,%rax
ffff80000010092d:	0f b6 00             	movzbl (%rax),%eax
ffff800000100930:	0f be c0             	movsbl %al,%eax
ffff800000100933:	25 ff 00 00 00       	and    $0xff,%eax
ffff800000100938:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%rbp)
    if (c == 0)
ffff80000010093e:	83 bd 38 ff ff ff 00 	cmpl   $0x0,-0xc8(%rbp)
ffff800000100945:	0f 84 79 02 00 00    	je     ffff800000100bc4 <cprintf+0x3c0>
      break;
    switch(c) {
ffff80000010094b:	83 bd 38 ff ff ff 78 	cmpl   $0x78,-0xc8(%rbp)
ffff800000100952:	0f 84 b0 00 00 00    	je     ffff800000100a08 <cprintf+0x204>
ffff800000100958:	83 bd 38 ff ff ff 78 	cmpl   $0x78,-0xc8(%rbp)
ffff80000010095f:	0f 8f ff 01 00 00    	jg     ffff800000100b64 <cprintf+0x360>
ffff800000100965:	83 bd 38 ff ff ff 73 	cmpl   $0x73,-0xc8(%rbp)
ffff80000010096c:	0f 84 42 01 00 00    	je     ffff800000100ab4 <cprintf+0x2b0>
ffff800000100972:	83 bd 38 ff ff ff 73 	cmpl   $0x73,-0xc8(%rbp)
ffff800000100979:	0f 8f e5 01 00 00    	jg     ffff800000100b64 <cprintf+0x360>
ffff80000010097f:	83 bd 38 ff ff ff 70 	cmpl   $0x70,-0xc8(%rbp)
ffff800000100986:	0f 84 d1 00 00 00    	je     ffff800000100a5d <cprintf+0x259>
ffff80000010098c:	83 bd 38 ff ff ff 70 	cmpl   $0x70,-0xc8(%rbp)
ffff800000100993:	0f 8f cb 01 00 00    	jg     ffff800000100b64 <cprintf+0x360>
ffff800000100999:	83 bd 38 ff ff ff 25 	cmpl   $0x25,-0xc8(%rbp)
ffff8000001009a0:	0f 84 ab 01 00 00    	je     ffff800000100b51 <cprintf+0x34d>
ffff8000001009a6:	83 bd 38 ff ff ff 64 	cmpl   $0x64,-0xc8(%rbp)
ffff8000001009ad:	0f 85 b1 01 00 00    	jne    ffff800000100b64 <cprintf+0x360>
    case 'd':
      print_d(va_arg(ap, int));
ffff8000001009b3:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff8000001009b9:	83 f8 2f             	cmp    $0x2f,%eax
ffff8000001009bc:	77 23                	ja     ffff8000001009e1 <cprintf+0x1dd>
ffff8000001009be:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff8000001009c5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff8000001009cb:	89 d2                	mov    %edx,%edx
ffff8000001009cd:	48 01 d0             	add    %rdx,%rax
ffff8000001009d0:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff8000001009d6:	83 c2 08             	add    $0x8,%edx
ffff8000001009d9:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff8000001009df:	eb 12                	jmp    ffff8000001009f3 <cprintf+0x1ef>
ffff8000001009e1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff8000001009e8:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff8000001009ec:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff8000001009f3:	8b 00                	mov    (%rax),%eax
ffff8000001009f5:	89 c7                	mov    %eax,%edi
ffff8000001009f7:	48 b8 18 07 10 00 00 	movabs $0xffff800000100718,%rax
ffff8000001009fe:	80 ff ff 
ffff800000100a01:	ff d0                	call   *%rax
      break;
ffff800000100a03:	e9 82 01 00 00       	jmp    ffff800000100b8a <cprintf+0x386>
    case 'x':
      print_x32(va_arg(ap, uint));
ffff800000100a08:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100a0e:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100a11:	77 23                	ja     ffff800000100a36 <cprintf+0x232>
ffff800000100a13:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100a1a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a20:	89 d2                	mov    %edx,%edx
ffff800000100a22:	48 01 d0             	add    %rdx,%rax
ffff800000100a25:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a2b:	83 c2 08             	add    $0x8,%edx
ffff800000100a2e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100a34:	eb 12                	jmp    ffff800000100a48 <cprintf+0x244>
ffff800000100a36:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100a3d:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100a41:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100a48:	8b 00                	mov    (%rax),%eax
ffff800000100a4a:	89 c7                	mov    %eax,%edi
ffff800000100a4c:	48 b8 c7 06 10 00 00 	movabs $0xffff8000001006c7,%rax
ffff800000100a53:	80 ff ff 
ffff800000100a56:	ff d0                	call   *%rax
      break;
ffff800000100a58:	e9 2d 01 00 00       	jmp    ffff800000100b8a <cprintf+0x386>
    case 'p':
      print_x64(va_arg(ap, addr_t));
ffff800000100a5d:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100a63:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100a66:	77 23                	ja     ffff800000100a8b <cprintf+0x287>
ffff800000100a68:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100a6f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a75:	89 d2                	mov    %edx,%edx
ffff800000100a77:	48 01 d0             	add    %rdx,%rax
ffff800000100a7a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a80:	83 c2 08             	add    $0x8,%edx
ffff800000100a83:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100a89:	eb 12                	jmp    ffff800000100a9d <cprintf+0x299>
ffff800000100a8b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100a92:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100a96:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100a9d:	48 8b 00             	mov    (%rax),%rax
ffff800000100aa0:	48 89 c7             	mov    %rax,%rdi
ffff800000100aa3:	48 b8 76 06 10 00 00 	movabs $0xffff800000100676,%rax
ffff800000100aaa:	80 ff ff 
ffff800000100aad:	ff d0                	call   *%rax
      break;
ffff800000100aaf:	e9 d6 00 00 00       	jmp    ffff800000100b8a <cprintf+0x386>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
ffff800000100ab4:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100aba:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100abd:	77 23                	ja     ffff800000100ae2 <cprintf+0x2de>
ffff800000100abf:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100ac6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100acc:	89 d2                	mov    %edx,%edx
ffff800000100ace:	48 01 d0             	add    %rdx,%rax
ffff800000100ad1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100ad7:	83 c2 08             	add    $0x8,%edx
ffff800000100ada:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100ae0:	eb 12                	jmp    ffff800000100af4 <cprintf+0x2f0>
ffff800000100ae2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100ae9:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100aed:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100af4:	48 8b 00             	mov    (%rax),%rax
ffff800000100af7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
ffff800000100afe:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
ffff800000100b05:	00 
ffff800000100b06:	75 39                	jne    ffff800000100b41 <cprintf+0x33d>
        s = "(null)";
ffff800000100b08:	48 b8 f6 c6 10 00 00 	movabs $0xffff80000010c6f6,%rax
ffff800000100b0f:	80 ff ff 
ffff800000100b12:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
ffff800000100b19:	eb 26                	jmp    ffff800000100b41 <cprintf+0x33d>
        consputc(*(s++));
ffff800000100b1b:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
ffff800000100b22:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000100b26:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
ffff800000100b2d:	0f b6 00             	movzbl (%rax),%eax
ffff800000100b30:	0f be c0             	movsbl %al,%eax
ffff800000100b33:	89 c7                	mov    %eax,%edi
ffff800000100b35:	48 b8 ff 0f 10 00 00 	movabs $0xffff800000100fff,%rax
ffff800000100b3c:	80 ff ff 
ffff800000100b3f:	ff d0                	call   *%rax
      while (*s)
ffff800000100b41:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
ffff800000100b48:	0f b6 00             	movzbl (%rax),%eax
ffff800000100b4b:	84 c0                	test   %al,%al
ffff800000100b4d:	75 cc                	jne    ffff800000100b1b <cprintf+0x317>
      break;
ffff800000100b4f:	eb 39                	jmp    ffff800000100b8a <cprintf+0x386>
    case '%':
      consputc('%');
ffff800000100b51:	bf 25 00 00 00       	mov    $0x25,%edi
ffff800000100b56:	48 b8 ff 0f 10 00 00 	movabs $0xffff800000100fff,%rax
ffff800000100b5d:	80 ff ff 
ffff800000100b60:	ff d0                	call   *%rax
      break;
ffff800000100b62:	eb 26                	jmp    ffff800000100b8a <cprintf+0x386>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
ffff800000100b64:	bf 25 00 00 00       	mov    $0x25,%edi
ffff800000100b69:	48 b8 ff 0f 10 00 00 	movabs $0xffff800000100fff,%rax
ffff800000100b70:	80 ff ff 
ffff800000100b73:	ff d0                	call   *%rax
      consputc(c);
ffff800000100b75:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffff800000100b7b:	89 c7                	mov    %eax,%edi
ffff800000100b7d:	48 b8 ff 0f 10 00 00 	movabs $0xffff800000100fff,%rax
ffff800000100b84:	80 ff ff 
ffff800000100b87:	ff d0                	call   *%rax
      break;
ffff800000100b89:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
ffff800000100b8a:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffff800000100b91:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000100b97:	48 63 d0             	movslq %eax,%rdx
ffff800000100b9a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
ffff800000100ba1:	48 01 d0             	add    %rdx,%rax
ffff800000100ba4:	0f b6 00             	movzbl (%rax),%eax
ffff800000100ba7:	0f be c0             	movsbl %al,%eax
ffff800000100baa:	25 ff 00 00 00       	and    $0xff,%eax
ffff800000100baf:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%rbp)
ffff800000100bb5:	83 bd 38 ff ff ff 00 	cmpl   $0x0,-0xc8(%rbp)
ffff800000100bbc:	0f 85 2f fd ff ff    	jne    ffff8000001008f1 <cprintf+0xed>
ffff800000100bc2:	eb 01                	jmp    ffff800000100bc5 <cprintf+0x3c1>
      break;
ffff800000100bc4:	90                   	nop
    }
  }

  if (locking)
ffff800000100bc5:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
ffff800000100bcc:	74 19                	je     ffff800000100be7 <cprintf+0x3e3>
    release(&cons.lock);
ffff800000100bce:	48 b8 c0 44 11 00 00 	movabs $0xffff8000001144c0,%rax
ffff800000100bd5:	80 ff ff 
ffff800000100bd8:	48 89 c7             	mov    %rax,%rdi
ffff800000100bdb:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000100be2:	80 ff ff 
ffff800000100be5:	ff d0                	call   *%rax
}
ffff800000100be7:	90                   	nop
ffff800000100be8:	c9                   	leave
ffff800000100be9:	c3                   	ret

ffff800000100bea <panic>:

__attribute__((noreturn))
  void
panic(char *s)
{
ffff800000100bea:	55                   	push   %rbp
ffff800000100beb:	48 89 e5             	mov    %rsp,%rbp
ffff800000100bee:	48 83 ec 70          	sub    $0x70,%rsp
ffff800000100bf2:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
  int i;
  addr_t pcs[10];

  cli();
ffff800000100bf6:	48 b8 66 06 10 00 00 	movabs $0xffff800000100666,%rax
ffff800000100bfd:	80 ff ff 
ffff800000100c00:	ff d0                	call   *%rax
  cons.locking = 0;
ffff800000100c02:	48 b8 c0 44 11 00 00 	movabs $0xffff8000001144c0,%rax
ffff800000100c09:	80 ff ff 
ffff800000100c0c:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
  cprintf("cpu%d: panic: ", cpu->id);
ffff800000100c13:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000100c1a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000100c1e:	0f b6 00             	movzbl (%rax),%eax
ffff800000100c21:	0f b6 c0             	movzbl %al,%eax
ffff800000100c24:	48 ba fd c6 10 00 00 	movabs $0xffff80000010c6fd,%rdx
ffff800000100c2b:	80 ff ff 
ffff800000100c2e:	89 c6                	mov    %eax,%esi
ffff800000100c30:	48 89 d7             	mov    %rdx,%rdi
ffff800000100c33:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c38:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000100c3f:	80 ff ff 
ffff800000100c42:	ff d2                	call   *%rdx
  cprintf(s);
ffff800000100c44:	48 8b 45 98          	mov    -0x68(%rbp),%rax
ffff800000100c48:	48 89 c7             	mov    %rax,%rdi
ffff800000100c4b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c50:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000100c57:	80 ff ff 
ffff800000100c5a:	ff d2                	call   *%rdx
  cprintf("\n");
ffff800000100c5c:	48 b8 0c c7 10 00 00 	movabs $0xffff80000010c70c,%rax
ffff800000100c63:	80 ff ff 
ffff800000100c66:	48 89 c7             	mov    %rax,%rdi
ffff800000100c69:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c6e:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000100c75:	80 ff ff 
ffff800000100c78:	ff d2                	call   *%rdx
  getcallerpcs(&s, pcs);
ffff800000100c7a:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
ffff800000100c7e:	48 8d 45 98          	lea    -0x68(%rbp),%rax
ffff800000100c82:	48 89 d6             	mov    %rdx,%rsi
ffff800000100c85:	48 89 c7             	mov    %rax,%rdi
ffff800000100c88:	48 b8 f0 77 10 00 00 	movabs $0xffff8000001077f0,%rax
ffff800000100c8f:	80 ff ff 
ffff800000100c92:	ff d0                	call   *%rax
  for (i=0; i<10; i++)
ffff800000100c94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000100c9b:	eb 2f                	jmp    ffff800000100ccc <panic+0xe2>
    cprintf(" %p\n", pcs[i]);
ffff800000100c9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100ca0:	48 98                	cltq
ffff800000100ca2:	48 8b 44 c5 a0       	mov    -0x60(%rbp,%rax,8),%rax
ffff800000100ca7:	48 ba 0e c7 10 00 00 	movabs $0xffff80000010c70e,%rdx
ffff800000100cae:	80 ff ff 
ffff800000100cb1:	48 89 c6             	mov    %rax,%rsi
ffff800000100cb4:	48 89 d7             	mov    %rdx,%rdi
ffff800000100cb7:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100cbc:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000100cc3:	80 ff ff 
ffff800000100cc6:	ff d2                	call   *%rdx
  for (i=0; i<10; i++)
ffff800000100cc8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000100ccc:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff800000100cd0:	7e cb                	jle    ffff800000100c9d <panic+0xb3>
  panicked = 1; // freeze other CPU
ffff800000100cd2:	48 b8 b8 44 11 00 00 	movabs $0xffff8000001144b8,%rax
ffff800000100cd9:	80 ff ff 
ffff800000100cdc:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  for (;;)
    hlt();
ffff800000100ce2:	48 b8 6e 06 10 00 00 	movabs $0xffff80000010066e,%rax
ffff800000100ce9:	80 ff ff 
ffff800000100cec:	ff d0                	call   *%rax
ffff800000100cee:	eb f2                	jmp    ffff800000100ce2 <panic+0xf8>

ffff800000100cf0 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

  static void
cgaputc(int c)
{
ffff800000100cf0:	55                   	push   %rbp
ffff800000100cf1:	48 89 e5             	mov    %rsp,%rbp
ffff800000100cf4:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100cf8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
ffff800000100cfb:	be 0e 00 00 00       	mov    $0xe,%esi
ffff800000100d00:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100d05:	48 b8 f0 05 10 00 00 	movabs $0xffff8000001005f0,%rax
ffff800000100d0c:	80 ff ff 
ffff800000100d0f:	ff d0                	call   *%rax
  pos = inb(CRTPORT+1) << 8;
ffff800000100d11:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100d16:	48 b8 d2 05 10 00 00 	movabs $0xffff8000001005d2,%rax
ffff800000100d1d:	80 ff ff 
ffff800000100d20:	ff d0                	call   *%rax
ffff800000100d22:	0f b6 c0             	movzbl %al,%eax
ffff800000100d25:	c1 e0 08             	shl    $0x8,%eax
ffff800000100d28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  outb(CRTPORT, 15);
ffff800000100d2b:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000100d30:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100d35:	48 b8 f0 05 10 00 00 	movabs $0xffff8000001005f0,%rax
ffff800000100d3c:	80 ff ff 
ffff800000100d3f:	ff d0                	call   *%rax
  pos |= inb(CRTPORT+1);
ffff800000100d41:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100d46:	48 b8 d2 05 10 00 00 	movabs $0xffff8000001005d2,%rax
ffff800000100d4d:	80 ff ff 
ffff800000100d50:	ff d0                	call   *%rax
ffff800000100d52:	0f b6 c0             	movzbl %al,%eax
ffff800000100d55:	09 45 fc             	or     %eax,-0x4(%rbp)

  if (c == '\n')
ffff800000100d58:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
ffff800000100d5c:	75 37                	jne    ffff800000100d95 <cgaputc+0xa5>
    pos += 80 - pos%80;
ffff800000100d5e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000100d61:	48 63 c1             	movslq %ecx,%rax
ffff800000100d64:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
ffff800000100d6b:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000100d6f:	89 c2                	mov    %eax,%edx
ffff800000100d71:	c1 fa 05             	sar    $0x5,%edx
ffff800000100d74:	89 c8                	mov    %ecx,%eax
ffff800000100d76:	c1 f8 1f             	sar    $0x1f,%eax
ffff800000100d79:	29 c2                	sub    %eax,%edx
ffff800000100d7b:	89 d0                	mov    %edx,%eax
ffff800000100d7d:	c1 e0 02             	shl    $0x2,%eax
ffff800000100d80:	01 d0                	add    %edx,%eax
ffff800000100d82:	c1 e0 04             	shl    $0x4,%eax
ffff800000100d85:	29 c1                	sub    %eax,%ecx
ffff800000100d87:	89 ca                	mov    %ecx,%edx
ffff800000100d89:	b8 50 00 00 00       	mov    $0x50,%eax
ffff800000100d8e:	29 d0                	sub    %edx,%eax
ffff800000100d90:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff800000100d93:	eb 43                	jmp    ffff800000100dd8 <cgaputc+0xe8>
  else if (c == BACKSPACE) {
ffff800000100d95:	81 7d ec 00 01 00 00 	cmpl   $0x100,-0x14(%rbp)
ffff800000100d9c:	75 0c                	jne    ffff800000100daa <cgaputc+0xba>
    if (pos > 0) --pos;
ffff800000100d9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000100da2:	7e 34                	jle    ffff800000100dd8 <cgaputc+0xe8>
ffff800000100da4:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
ffff800000100da8:	eb 2e                	jmp    ffff800000100dd8 <cgaputc+0xe8>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // gray on black
ffff800000100daa:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000100dad:	0f b6 c0             	movzbl %al,%eax
ffff800000100db0:	80 cc 07             	or     $0x7,%ah
ffff800000100db3:	89 c6                	mov    %eax,%esi
ffff800000100db5:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100dbc:	80 ff ff 
ffff800000100dbf:	48 8b 08             	mov    (%rax),%rcx
ffff800000100dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100dc5:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000100dc8:	89 55 fc             	mov    %edx,-0x4(%rbp)
ffff800000100dcb:	48 98                	cltq
ffff800000100dcd:	48 01 c0             	add    %rax,%rax
ffff800000100dd0:	48 01 c8             	add    %rcx,%rax
ffff800000100dd3:	89 f2                	mov    %esi,%edx
ffff800000100dd5:	66 89 10             	mov    %dx,(%rax)

  if ((pos/80) >= 24){  // Scroll up.
ffff800000100dd8:	81 7d fc 7f 07 00 00 	cmpl   $0x77f,-0x4(%rbp)
ffff800000100ddf:	7e 74                	jle    ffff800000100e55 <cgaputc+0x165>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
ffff800000100de1:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100de8:	80 ff ff 
ffff800000100deb:	48 8b 00             	mov    (%rax),%rax
ffff800000100dee:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
ffff800000100df5:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100dfc:	80 ff ff 
ffff800000100dff:	48 8b 00             	mov    (%rax),%rax
ffff800000100e02:	ba 60 0e 00 00       	mov    $0xe60,%edx
ffff800000100e07:	48 89 ce             	mov    %rcx,%rsi
ffff800000100e0a:	48 89 c7             	mov    %rax,%rdi
ffff800000100e0d:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff800000100e14:	80 ff ff 
ffff800000100e17:	ff d0                	call   *%rax
    pos -= 80;
ffff800000100e19:	83 6d fc 50          	subl   $0x50,-0x4(%rbp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
ffff800000100e1d:	b8 80 07 00 00       	mov    $0x780,%eax
ffff800000100e22:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000100e25:	8d 14 00             	lea    (%rax,%rax,1),%edx
ffff800000100e28:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100e2f:	80 ff ff 
ffff800000100e32:	48 8b 00             	mov    (%rax),%rax
ffff800000100e35:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000100e38:	48 63 c9             	movslq %ecx,%rcx
ffff800000100e3b:	48 01 c9             	add    %rcx,%rcx
ffff800000100e3e:	48 01 c8             	add    %rcx,%rax
ffff800000100e41:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000100e46:	48 89 c7             	mov    %rax,%rdi
ffff800000100e49:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff800000100e50:	80 ff ff 
ffff800000100e53:	ff d0                	call   *%rax
  }

  outb(CRTPORT, 14);
ffff800000100e55:	be 0e 00 00 00       	mov    $0xe,%esi
ffff800000100e5a:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100e5f:	48 b8 f0 05 10 00 00 	movabs $0xffff8000001005f0,%rax
ffff800000100e66:	80 ff ff 
ffff800000100e69:	ff d0                	call   *%rax
  outb(CRTPORT+1, pos>>8);
ffff800000100e6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100e6e:	c1 f8 08             	sar    $0x8,%eax
ffff800000100e71:	0f b6 c0             	movzbl %al,%eax
ffff800000100e74:	89 c6                	mov    %eax,%esi
ffff800000100e76:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100e7b:	48 b8 f0 05 10 00 00 	movabs $0xffff8000001005f0,%rax
ffff800000100e82:	80 ff ff 
ffff800000100e85:	ff d0                	call   *%rax
  outb(CRTPORT, 15);
ffff800000100e87:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000100e8c:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100e91:	48 b8 f0 05 10 00 00 	movabs $0xffff8000001005f0,%rax
ffff800000100e98:	80 ff ff 
ffff800000100e9b:	ff d0                	call   *%rax
  outb(CRTPORT+1, pos);
ffff800000100e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100ea0:	0f b6 c0             	movzbl %al,%eax
ffff800000100ea3:	89 c6                	mov    %eax,%esi
ffff800000100ea5:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100eaa:	48 b8 f0 05 10 00 00 	movabs $0xffff8000001005f0,%rax
ffff800000100eb1:	80 ff ff 
ffff800000100eb4:	ff d0                	call   *%rax
  crt[pos] = ' ' | 0x0700;
ffff800000100eb6:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100ebd:	80 ff ff 
ffff800000100ec0:	48 8b 00             	mov    (%rax),%rax
ffff800000100ec3:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000100ec6:	48 63 d2             	movslq %edx,%rdx
ffff800000100ec9:	48 01 d2             	add    %rdx,%rdx
ffff800000100ecc:	48 01 d0             	add    %rdx,%rax
ffff800000100ecf:	66 c7 00 20 07       	movw   $0x720,(%rax)
}
ffff800000100ed4:	90                   	nop
ffff800000100ed5:	c9                   	leave
ffff800000100ed6:	c3                   	ret

ffff800000100ed7 <vidclear>:

void 
vidclear(void){
ffff800000100ed7:	55                   	push   %rbp
ffff800000100ed8:	48 89 e5             	mov    %rsp,%rbp
ffff800000100edb:	48 83 ec 10          	sub    $0x10,%rsp
  int i;
  for(i = 0; i < 80 * 25; i++)
ffff800000100edf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000100ee6:	eb 22                	jmp    ffff800000100f0a <vidclear+0x33>
    crt[i] = ' ' | 0x0700;
ffff800000100ee8:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100eef:	80 ff ff 
ffff800000100ef2:	48 8b 00             	mov    (%rax),%rax
ffff800000100ef5:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000100ef8:	48 63 d2             	movslq %edx,%rdx
ffff800000100efb:	48 01 d2             	add    %rdx,%rdx
ffff800000100efe:	48 01 d0             	add    %rdx,%rax
ffff800000100f01:	66 c7 00 20 07       	movw   $0x720,(%rax)
  for(i = 0; i < 80 * 25; i++)
ffff800000100f06:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000100f0a:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
ffff800000100f11:	7e d5                	jle    ffff800000100ee8 <vidclear+0x11>
}
ffff800000100f13:	90                   	nop
ffff800000100f14:	90                   	nop
ffff800000100f15:	c9                   	leave
ffff800000100f16:	c3                   	ret

ffff800000100f17 <vidputc>:

void
vidputc(int row, int col, int ch, int color){
ffff800000100f17:	55                   	push   %rbp
ffff800000100f18:	48 89 e5             	mov    %rsp,%rbp
ffff800000100f1b:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000100f1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000100f22:	89 75 f8             	mov    %esi,-0x8(%rbp)
ffff800000100f25:	89 55 f4             	mov    %edx,-0xc(%rbp)
ffff800000100f28:	89 4d f0             	mov    %ecx,-0x10(%rbp)
  if(row < 0 || row >= 25)
ffff800000100f2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000100f2f:	78 52                	js     ffff800000100f83 <vidputc+0x6c>
ffff800000100f31:	83 7d fc 18          	cmpl   $0x18,-0x4(%rbp)
ffff800000100f35:	7f 4c                	jg     ffff800000100f83 <vidputc+0x6c>
    return;
  if(col < 0 || col >= 80)
ffff800000100f37:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffff800000100f3b:	78 49                	js     ffff800000100f86 <vidputc+0x6f>
ffff800000100f3d:	83 7d f8 4f          	cmpl   $0x4f,-0x8(%rbp)
ffff800000100f41:	7f 43                	jg     ffff800000100f86 <vidputc+0x6f>
    return;

  crt[row * 80 + col] = (ch & 0xff) | ((color & 0xff) << 8);
ffff800000100f43:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000100f46:	0f b6 c0             	movzbl %al,%eax
ffff800000100f49:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff800000100f4c:	c1 e2 08             	shl    $0x8,%edx
ffff800000100f4f:	09 d0                	or     %edx,%eax
ffff800000100f51:	89 c6                	mov    %eax,%esi
ffff800000100f53:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100f5a:	80 ff ff 
ffff800000100f5d:	48 8b 08             	mov    (%rax),%rcx
ffff800000100f60:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000100f63:	89 d0                	mov    %edx,%eax
ffff800000100f65:	c1 e0 02             	shl    $0x2,%eax
ffff800000100f68:	01 d0                	add    %edx,%eax
ffff800000100f6a:	c1 e0 04             	shl    $0x4,%eax
ffff800000100f6d:	89 c2                	mov    %eax,%edx
ffff800000100f6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000100f72:	01 d0                	add    %edx,%eax
ffff800000100f74:	48 98                	cltq
ffff800000100f76:	48 01 c0             	add    %rax,%rax
ffff800000100f79:	48 01 c8             	add    %rcx,%rax
ffff800000100f7c:	89 f2                	mov    %esi,%edx
ffff800000100f7e:	66 89 10             	mov    %dx,(%rax)
ffff800000100f81:	eb 04                	jmp    ffff800000100f87 <vidputc+0x70>
    return;
ffff800000100f83:	90                   	nop
ffff800000100f84:	eb 01                	jmp    ffff800000100f87 <vidputc+0x70>
    return;
ffff800000100f86:	90                   	nop
}
ffff800000100f87:	c9                   	leave
ffff800000100f88:	c3                   	ret

ffff800000100f89 <vidputs>:

void 
vidputs(int row, int col, char *s, int color){
ffff800000100f89:	55                   	push   %rbp
ffff800000100f8a:	48 89 e5             	mov    %rsp,%rbp
ffff800000100f8d:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000100f91:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000100f94:	89 75 e8             	mov    %esi,-0x18(%rbp)
ffff800000100f97:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
ffff800000100f9b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
  int i;
  for(i = 0; s[i] != 0 && col + i < 80; i++)
ffff800000100f9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000100fa5:	eb 34                	jmp    ffff800000100fdb <vidputs+0x52>
    vidputc(row, col + i, s[i], color);
ffff800000100fa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100faa:	48 63 d0             	movslq %eax,%rdx
ffff800000100fad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000100fb1:	48 01 d0             	add    %rdx,%rax
ffff800000100fb4:	0f b6 00             	movzbl (%rax),%eax
ffff800000100fb7:	0f be d0             	movsbl %al,%edx
ffff800000100fba:	8b 4d e8             	mov    -0x18(%rbp),%ecx
ffff800000100fbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100fc0:	8d 34 01             	lea    (%rcx,%rax,1),%esi
ffff800000100fc3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
ffff800000100fc6:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000100fc9:	89 c7                	mov    %eax,%edi
ffff800000100fcb:	48 b8 17 0f 10 00 00 	movabs $0xffff800000100f17,%rax
ffff800000100fd2:	80 ff ff 
ffff800000100fd5:	ff d0                	call   *%rax
  for(i = 0; s[i] != 0 && col + i < 80; i++)
ffff800000100fd7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000100fdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100fde:	48 63 d0             	movslq %eax,%rdx
ffff800000100fe1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000100fe5:	48 01 d0             	add    %rdx,%rax
ffff800000100fe8:	0f b6 00             	movzbl (%rax),%eax
ffff800000100feb:	84 c0                	test   %al,%al
ffff800000100fed:	74 0d                	je     ffff800000100ffc <vidputs+0x73>
ffff800000100fef:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000100ff2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100ff5:	01 d0                	add    %edx,%eax
ffff800000100ff7:	83 f8 4f             	cmp    $0x4f,%eax
ffff800000100ffa:	7e ab                	jle    ffff800000100fa7 <vidputs+0x1e>
}
ffff800000100ffc:	90                   	nop
ffff800000100ffd:	c9                   	leave
ffff800000100ffe:	c3                   	ret

ffff800000100fff <consputc>:

  void
consputc(int c)
{
ffff800000100fff:	55                   	push   %rbp
ffff800000101000:	48 89 e5             	mov    %rsp,%rbp
ffff800000101003:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000101007:	89 7d fc             	mov    %edi,-0x4(%rbp)
  if (panicked) {
ffff80000010100a:	48 b8 b8 44 11 00 00 	movabs $0xffff8000001144b8,%rax
ffff800000101011:	80 ff ff 
ffff800000101014:	8b 00                	mov    (%rax),%eax
ffff800000101016:	85 c0                	test   %eax,%eax
ffff800000101018:	74 1a                	je     ffff800000101034 <consputc+0x35>
    cli();
ffff80000010101a:	48 b8 66 06 10 00 00 	movabs $0xffff800000100666,%rax
ffff800000101021:	80 ff ff 
ffff800000101024:	ff d0                	call   *%rax
    for(;;)
      hlt();
ffff800000101026:	48 b8 6e 06 10 00 00 	movabs $0xffff80000010066e,%rax
ffff80000010102d:	80 ff ff 
ffff800000101030:	ff d0                	call   *%rax
ffff800000101032:	eb f2                	jmp    ffff800000101026 <consputc+0x27>
  }

  if (c == BACKSPACE) {
ffff800000101034:	81 7d fc 00 01 00 00 	cmpl   $0x100,-0x4(%rbp)
ffff80000010103b:	75 35                	jne    ffff800000101072 <consputc+0x73>
    uartputc('\b'); uartputc(' '); uartputc('\b');
ffff80000010103d:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000101042:	48 b8 74 a2 10 00 00 	movabs $0xffff80000010a274,%rax
ffff800000101049:	80 ff ff 
ffff80000010104c:	ff d0                	call   *%rax
ffff80000010104e:	bf 20 00 00 00       	mov    $0x20,%edi
ffff800000101053:	48 b8 74 a2 10 00 00 	movabs $0xffff80000010a274,%rax
ffff80000010105a:	80 ff ff 
ffff80000010105d:	ff d0                	call   *%rax
ffff80000010105f:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000101064:	48 b8 74 a2 10 00 00 	movabs $0xffff80000010a274,%rax
ffff80000010106b:	80 ff ff 
ffff80000010106e:	ff d0                	call   *%rax
ffff800000101070:	eb 11                	jmp    ffff800000101083 <consputc+0x84>
  } else
    uartputc(c);
ffff800000101072:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101075:	89 c7                	mov    %eax,%edi
ffff800000101077:	48 b8 74 a2 10 00 00 	movabs $0xffff80000010a274,%rax
ffff80000010107e:	80 ff ff 
ffff800000101081:	ff d0                	call   *%rax
  cgaputc(c);
ffff800000101083:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101086:	89 c7                	mov    %eax,%edi
ffff800000101088:	48 b8 f0 0c 10 00 00 	movabs $0xffff800000100cf0,%rax
ffff80000010108f:	80 ff ff 
ffff800000101092:	ff d0                	call   *%rax
}
ffff800000101094:	90                   	nop
ffff800000101095:	c9                   	leave
ffff800000101096:	c3                   	ret

ffff800000101097 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

  void
consoleintr(int (*getc)(void))
{
ffff800000101097:	55                   	push   %rbp
ffff800000101098:	48 89 e5             	mov    %rsp,%rbp
ffff80000010109b:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010109f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int c;

  acquire(&input.lock);
ffff8000001010a3:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff8000001010aa:	80 ff ff 
ffff8000001010ad:	48 89 c7             	mov    %rax,%rdi
ffff8000001010b0:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff8000001010b7:	80 ff ff 
ffff8000001010ba:	ff d0                	call   *%rax
  while((c = getc()) >= 0){
ffff8000001010bc:	e9 6d 02 00 00       	jmp    ffff80000010132e <consoleintr+0x297>
    switch(c){
ffff8000001010c1:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff8000001010c5:	0f 84 fd 00 00 00    	je     ffff8000001011c8 <consoleintr+0x131>
ffff8000001010cb:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff8000001010cf:	0f 8f 54 01 00 00    	jg     ffff800000101229 <consoleintr+0x192>
ffff8000001010d5:	83 7d fc 1a          	cmpl   $0x1a,-0x4(%rbp)
ffff8000001010d9:	74 2f                	je     ffff80000010110a <consoleintr+0x73>
ffff8000001010db:	83 7d fc 1a          	cmpl   $0x1a,-0x4(%rbp)
ffff8000001010df:	0f 8f 44 01 00 00    	jg     ffff800000101229 <consoleintr+0x192>
ffff8000001010e5:	83 7d fc 15          	cmpl   $0x15,-0x4(%rbp)
ffff8000001010e9:	74 7f                	je     ffff80000010116a <consoleintr+0xd3>
ffff8000001010eb:	83 7d fc 15          	cmpl   $0x15,-0x4(%rbp)
ffff8000001010ef:	0f 8f 34 01 00 00    	jg     ffff800000101229 <consoleintr+0x192>
ffff8000001010f5:	83 7d fc 08          	cmpl   $0x8,-0x4(%rbp)
ffff8000001010f9:	0f 84 c9 00 00 00    	je     ffff8000001011c8 <consoleintr+0x131>
ffff8000001010ff:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
ffff800000101103:	74 20                	je     ffff800000101125 <consoleintr+0x8e>
ffff800000101105:	e9 1f 01 00 00       	jmp    ffff800000101229 <consoleintr+0x192>
    case C('Z'): // reboot
      lidt(0,0);
ffff80000010110a:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010110f:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000101114:	48 b8 0f 06 10 00 00 	movabs $0xffff80000010060f,%rax
ffff80000010111b:	80 ff ff 
ffff80000010111e:	ff d0                	call   *%rax
      break;
ffff800000101120:	e9 09 02 00 00       	jmp    ffff80000010132e <consoleintr+0x297>
    case C('P'):  // Process listing.
      procdump();
ffff800000101125:	48 b8 5b 73 10 00 00 	movabs $0xffff80000010735b,%rax
ffff80000010112c:	80 ff ff 
ffff80000010112f:	ff d0                	call   *%rax
      break;
ffff800000101131:	e9 f8 01 00 00       	jmp    ffff80000010132e <consoleintr+0x297>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
          input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
ffff800000101136:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff80000010113d:	80 ff ff 
ffff800000101140:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff800000101146:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000101149:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff800000101150:	80 ff ff 
ffff800000101153:	89 90 f0 00 00 00    	mov    %edx,0xf0(%rax)
        consputc(BACKSPACE);
ffff800000101159:	bf 00 01 00 00       	mov    $0x100,%edi
ffff80000010115e:	48 b8 ff 0f 10 00 00 	movabs $0xffff800000100fff,%rax
ffff800000101165:	80 ff ff 
ffff800000101168:	ff d0                	call   *%rax
      while(input.e != input.w &&
ffff80000010116a:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff800000101171:	80 ff ff 
ffff800000101174:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff80000010117a:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff800000101181:	80 ff ff 
ffff800000101184:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff80000010118a:	39 c2                	cmp    %eax,%edx
ffff80000010118c:	0f 84 95 01 00 00    	je     ffff800000101327 <consoleintr+0x290>
          input.buf[(input.e-1) % INPUT_BUF] != '\n'){
ffff800000101192:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff800000101199:	80 ff ff 
ffff80000010119c:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001011a2:	83 e8 01             	sub    $0x1,%eax
ffff8000001011a5:	83 e0 7f             	and    $0x7f,%eax
ffff8000001011a8:	89 c2                	mov    %eax,%edx
ffff8000001011aa:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff8000001011b1:	80 ff ff 
ffff8000001011b4:	89 d2                	mov    %edx,%edx
ffff8000001011b6:	0f b6 44 10 68       	movzbl 0x68(%rax,%rdx,1),%eax
      while(input.e != input.w &&
ffff8000001011bb:	3c 0a                	cmp    $0xa,%al
ffff8000001011bd:	0f 85 73 ff ff ff    	jne    ffff800000101136 <consoleintr+0x9f>
      }
      break;
ffff8000001011c3:	e9 5f 01 00 00       	jmp    ffff800000101327 <consoleintr+0x290>
    case C('H'): case '\x7f':  // Backspace
      if (input.e != input.w) {
ffff8000001011c8:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff8000001011cf:	80 ff ff 
ffff8000001011d2:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff8000001011d8:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff8000001011df:	80 ff ff 
ffff8000001011e2:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff8000001011e8:	39 c2                	cmp    %eax,%edx
ffff8000001011ea:	0f 84 3a 01 00 00    	je     ffff80000010132a <consoleintr+0x293>
        input.e--;
ffff8000001011f0:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff8000001011f7:	80 ff ff 
ffff8000001011fa:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff800000101200:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000101203:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff80000010120a:	80 ff ff 
ffff80000010120d:	89 90 f0 00 00 00    	mov    %edx,0xf0(%rax)
        consputc(BACKSPACE);
ffff800000101213:	bf 00 01 00 00       	mov    $0x100,%edi
ffff800000101218:	48 b8 ff 0f 10 00 00 	movabs $0xffff800000100fff,%rax
ffff80000010121f:	80 ff ff 
ffff800000101222:	ff d0                	call   *%rax
      }
      break;
ffff800000101224:	e9 01 01 00 00       	jmp    ffff80000010132a <consoleintr+0x293>
    default:
      if (c != 0 && input.e-input.r < INPUT_BUF) {
ffff800000101229:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff80000010122d:	0f 84 fa 00 00 00    	je     ffff80000010132d <consoleintr+0x296>
ffff800000101233:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff80000010123a:	80 ff ff 
ffff80000010123d:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff800000101243:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff80000010124a:	80 ff ff 
ffff80000010124d:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff800000101253:	29 c2                	sub    %eax,%edx
ffff800000101255:	83 fa 7f             	cmp    $0x7f,%edx
ffff800000101258:	0f 87 cf 00 00 00    	ja     ffff80000010132d <consoleintr+0x296>
        c = (c == '\r') ? '\n' : c;
ffff80000010125e:	83 7d fc 0d          	cmpl   $0xd,-0x4(%rbp)
ffff800000101262:	75 07                	jne    ffff80000010126b <consoleintr+0x1d4>
ffff800000101264:	c7 45 fc 0a 00 00 00 	movl   $0xa,-0x4(%rbp)
        input.buf[input.e++ % INPUT_BUF] = c;
ffff80000010126b:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff800000101272:	80 ff ff 
ffff800000101275:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff80000010127b:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010127e:	48 b9 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rcx
ffff800000101285:	80 ff ff 
ffff800000101288:	89 91 f0 00 00 00    	mov    %edx,0xf0(%rcx)
ffff80000010128e:	83 e0 7f             	and    $0x7f,%eax
ffff800000101291:	89 c2                	mov    %eax,%edx
ffff800000101293:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101296:	89 c1                	mov    %eax,%ecx
ffff800000101298:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff80000010129f:	80 ff ff 
ffff8000001012a2:	89 d2                	mov    %edx,%edx
ffff8000001012a4:	88 4c 10 68          	mov    %cl,0x68(%rax,%rdx,1)
        consputc(c);
ffff8000001012a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001012ab:	89 c7                	mov    %eax,%edi
ffff8000001012ad:	48 b8 ff 0f 10 00 00 	movabs $0xffff800000100fff,%rax
ffff8000001012b4:	80 ff ff 
ffff8000001012b7:	ff d0                	call   *%rax
        if (c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF) {
ffff8000001012b9:	83 7d fc 0a          	cmpl   $0xa,-0x4(%rbp)
ffff8000001012bd:	74 2d                	je     ffff8000001012ec <consoleintr+0x255>
ffff8000001012bf:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
ffff8000001012c3:	74 27                	je     ffff8000001012ec <consoleintr+0x255>
ffff8000001012c5:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff8000001012cc:	80 ff ff 
ffff8000001012cf:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff8000001012d5:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff8000001012dc:	80 ff ff 
ffff8000001012df:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff8000001012e5:	83 e8 80             	sub    $0xffffff80,%eax
ffff8000001012e8:	39 c2                	cmp    %eax,%edx
ffff8000001012ea:	75 41                	jne    ffff80000010132d <consoleintr+0x296>
          input.w = input.e;
ffff8000001012ec:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff8000001012f3:	80 ff ff 
ffff8000001012f6:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001012fc:	48 ba c0 43 11 00 00 	movabs $0xffff8000001143c0,%rdx
ffff800000101303:	80 ff ff 
ffff800000101306:	89 82 ec 00 00 00    	mov    %eax,0xec(%rdx)
          wakeup(&input.r);
ffff80000010130c:	48 b8 a8 44 11 00 00 	movabs $0xffff8000001144a8,%rax
ffff800000101313:	80 ff ff 
ffff800000101316:	48 89 c7             	mov    %rax,%rdi
ffff800000101319:	48 b8 4d 72 10 00 00 	movabs $0xffff80000010724d,%rax
ffff800000101320:	80 ff ff 
ffff800000101323:	ff d0                	call   *%rax
        }
      }
      break;
ffff800000101325:	eb 06                	jmp    ffff80000010132d <consoleintr+0x296>
      break;
ffff800000101327:	90                   	nop
ffff800000101328:	eb 04                	jmp    ffff80000010132e <consoleintr+0x297>
      break;
ffff80000010132a:	90                   	nop
ffff80000010132b:	eb 01                	jmp    ffff80000010132e <consoleintr+0x297>
      break;
ffff80000010132d:	90                   	nop
  while((c = getc()) >= 0){
ffff80000010132e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101332:	ff d0                	call   *%rax
ffff800000101334:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000101337:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff80000010133b:	0f 89 80 fd ff ff    	jns    ffff8000001010c1 <consoleintr+0x2a>
    }
  }
  release(&input.lock);
ffff800000101341:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff800000101348:	80 ff ff 
ffff80000010134b:	48 89 c7             	mov    %rax,%rdi
ffff80000010134e:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000101355:	80 ff ff 
ffff800000101358:	ff d0                	call   *%rax
}
ffff80000010135a:	90                   	nop
ffff80000010135b:	c9                   	leave
ffff80000010135c:	c3                   	ret

ffff80000010135d <consoleread>:

  int
consoleread(struct inode *ip, uint off, char *dst, int n)
{
ffff80000010135d:	55                   	push   %rbp
ffff80000010135e:	48 89 e5             	mov    %rsp,%rbp
ffff800000101361:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101365:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101369:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff80000010136c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff800000101370:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  uint target;
  int c;

  iunlock(ip);
ffff800000101373:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101377:	48 89 c7             	mov    %rax,%rdi
ffff80000010137a:	48 b8 4b 2b 10 00 00 	movabs $0xffff800000102b4b,%rax
ffff800000101381:	80 ff ff 
ffff800000101384:	ff d0                	call   *%rax
  target = n;
ffff800000101386:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000101389:	89 45 fc             	mov    %eax,-0x4(%rbp)
  acquire(&input.lock);
ffff80000010138c:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff800000101393:	80 ff ff 
ffff800000101396:	48 89 c7             	mov    %rax,%rdi
ffff800000101399:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff8000001013a0:	80 ff ff 
ffff8000001013a3:	ff d0                	call   *%rax
  while(n > 0){
ffff8000001013a5:	e9 23 01 00 00       	jmp    ffff8000001014cd <consoleread+0x170>
    while(input.r == input.w){
      if (proc->killed) {
ffff8000001013aa:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001013b1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001013b5:	8b 40 40             	mov    0x40(%rax),%eax
ffff8000001013b8:	85 c0                	test   %eax,%eax
ffff8000001013ba:	74 36                	je     ffff8000001013f2 <consoleread+0x95>
        release(&input.lock);
ffff8000001013bc:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff8000001013c3:	80 ff ff 
ffff8000001013c6:	48 89 c7             	mov    %rax,%rdi
ffff8000001013c9:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001013d0:	80 ff ff 
ffff8000001013d3:	ff d0                	call   *%rax
        ilock(ip);
ffff8000001013d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001013d9:	48 89 c7             	mov    %rax,%rdi
ffff8000001013dc:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff8000001013e3:	80 ff ff 
ffff8000001013e6:	ff d0                	call   *%rax
        return -1;
ffff8000001013e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001013ed:	e9 21 01 00 00       	jmp    ffff800000101513 <consoleread+0x1b6>
      }
      sleep(&input.r, &input.lock);
ffff8000001013f2:	48 ba c0 43 11 00 00 	movabs $0xffff8000001143c0,%rdx
ffff8000001013f9:	80 ff ff 
ffff8000001013fc:	48 b8 a8 44 11 00 00 	movabs $0xffff8000001144a8,%rax
ffff800000101403:	80 ff ff 
ffff800000101406:	48 89 d6             	mov    %rdx,%rsi
ffff800000101409:	48 89 c7             	mov    %rax,%rdi
ffff80000010140c:	48 b8 d8 70 10 00 00 	movabs $0xffff8000001070d8,%rax
ffff800000101413:	80 ff ff 
ffff800000101416:	ff d0                	call   *%rax
    while(input.r == input.w){
ffff800000101418:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff80000010141f:	80 ff ff 
ffff800000101422:	8b 90 e8 00 00 00    	mov    0xe8(%rax),%edx
ffff800000101428:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff80000010142f:	80 ff ff 
ffff800000101432:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff800000101438:	39 c2                	cmp    %eax,%edx
ffff80000010143a:	0f 84 6a ff ff ff    	je     ffff8000001013aa <consoleread+0x4d>
    }
    c = input.buf[input.r++ % INPUT_BUF];
ffff800000101440:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff800000101447:	80 ff ff 
ffff80000010144a:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff800000101450:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101453:	48 b9 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rcx
ffff80000010145a:	80 ff ff 
ffff80000010145d:	89 91 e8 00 00 00    	mov    %edx,0xe8(%rcx)
ffff800000101463:	83 e0 7f             	and    $0x7f,%eax
ffff800000101466:	89 c2                	mov    %eax,%edx
ffff800000101468:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff80000010146f:	80 ff ff 
ffff800000101472:	89 d2                	mov    %edx,%edx
ffff800000101474:	0f b6 44 10 68       	movzbl 0x68(%rax,%rdx,1),%eax
ffff800000101479:	0f be c0             	movsbl %al,%eax
ffff80000010147c:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if (c == C('D')) {  // EOF
ffff80000010147f:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
ffff800000101483:	75 2d                	jne    ffff8000001014b2 <consoleread+0x155>
      if (n < target) {
ffff800000101485:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000101488:	3b 45 fc             	cmp    -0x4(%rbp),%eax
ffff80000010148b:	73 4c                	jae    ffff8000001014d9 <consoleread+0x17c>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
ffff80000010148d:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff800000101494:	80 ff ff 
ffff800000101497:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff80000010149d:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001014a0:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff8000001014a7:	80 ff ff 
ffff8000001014aa:	89 90 e8 00 00 00    	mov    %edx,0xe8(%rax)
      }
      break;
ffff8000001014b0:	eb 27                	jmp    ffff8000001014d9 <consoleread+0x17c>
    }
    *dst++ = c;
ffff8000001014b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001014b6:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff8000001014ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff8000001014be:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff8000001014c1:	88 10                	mov    %dl,(%rax)
    --n;
ffff8000001014c3:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
    if (c == '\n')
ffff8000001014c7:	83 7d f8 0a          	cmpl   $0xa,-0x8(%rbp)
ffff8000001014cb:	74 0f                	je     ffff8000001014dc <consoleread+0x17f>
  while(n > 0){
ffff8000001014cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
ffff8000001014d1:	0f 8f 41 ff ff ff    	jg     ffff800000101418 <consoleread+0xbb>
ffff8000001014d7:	eb 04                	jmp    ffff8000001014dd <consoleread+0x180>
      break;
ffff8000001014d9:	90                   	nop
ffff8000001014da:	eb 01                	jmp    ffff8000001014dd <consoleread+0x180>
      break;
ffff8000001014dc:	90                   	nop
  }
  release(&input.lock);
ffff8000001014dd:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff8000001014e4:	80 ff ff 
ffff8000001014e7:	48 89 c7             	mov    %rax,%rdi
ffff8000001014ea:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001014f1:	80 ff ff 
ffff8000001014f4:	ff d0                	call   *%rax
  ilock(ip);
ffff8000001014f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001014fa:	48 89 c7             	mov    %rax,%rdi
ffff8000001014fd:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff800000101504:	80 ff ff 
ffff800000101507:	ff d0                	call   *%rax

  return target - n;
ffff800000101509:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff80000010150c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010150f:	29 c2                	sub    %eax,%edx
ffff800000101511:	89 d0                	mov    %edx,%eax
}
ffff800000101513:	c9                   	leave
ffff800000101514:	c3                   	ret

ffff800000101515 <consolewrite>:

  int
consolewrite(struct inode *ip, uint off, char *buf, int n)
{
ffff800000101515:	55                   	push   %rbp
ffff800000101516:	48 89 e5             	mov    %rsp,%rbp
ffff800000101519:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010151d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101521:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff800000101524:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff800000101528:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  int i;

  iunlock(ip);
ffff80000010152b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010152f:	48 89 c7             	mov    %rax,%rdi
ffff800000101532:	48 b8 4b 2b 10 00 00 	movabs $0xffff800000102b4b,%rax
ffff800000101539:	80 ff ff 
ffff80000010153c:	ff d0                	call   *%rax
  acquire(&cons.lock);
ffff80000010153e:	48 b8 c0 44 11 00 00 	movabs $0xffff8000001144c0,%rax
ffff800000101545:	80 ff ff 
ffff800000101548:	48 89 c7             	mov    %rax,%rdi
ffff80000010154b:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000101552:	80 ff ff 
ffff800000101555:	ff d0                	call   *%rax
  for(i = 0; i < n; i++)
ffff800000101557:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010155e:	eb 28                	jmp    ffff800000101588 <consolewrite+0x73>
    consputc(buf[i] & 0xff);
ffff800000101560:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101563:	48 63 d0             	movslq %eax,%rdx
ffff800000101566:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010156a:	48 01 d0             	add    %rdx,%rax
ffff80000010156d:	0f b6 00             	movzbl (%rax),%eax
ffff800000101570:	0f be c0             	movsbl %al,%eax
ffff800000101573:	0f b6 c0             	movzbl %al,%eax
ffff800000101576:	89 c7                	mov    %eax,%edi
ffff800000101578:	48 b8 ff 0f 10 00 00 	movabs $0xffff800000100fff,%rax
ffff80000010157f:	80 ff ff 
ffff800000101582:	ff d0                	call   *%rax
  for(i = 0; i < n; i++)
ffff800000101584:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000101588:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010158b:	3b 45 e0             	cmp    -0x20(%rbp),%eax
ffff80000010158e:	7c d0                	jl     ffff800000101560 <consolewrite+0x4b>
  release(&cons.lock);
ffff800000101590:	48 b8 c0 44 11 00 00 	movabs $0xffff8000001144c0,%rax
ffff800000101597:	80 ff ff 
ffff80000010159a:	48 89 c7             	mov    %rax,%rdi
ffff80000010159d:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001015a4:	80 ff ff 
ffff8000001015a7:	ff d0                	call   *%rax
  ilock(ip);
ffff8000001015a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001015ad:	48 89 c7             	mov    %rax,%rdi
ffff8000001015b0:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff8000001015b7:	80 ff ff 
ffff8000001015ba:	ff d0                	call   *%rax

  return n;
ffff8000001015bc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
ffff8000001015bf:	c9                   	leave
ffff8000001015c0:	c3                   	ret

ffff8000001015c1 <consoleinit>:

  void
consoleinit(void)
{
ffff8000001015c1:	55                   	push   %rbp
ffff8000001015c2:	48 89 e5             	mov    %rsp,%rbp
  initlock(&cons.lock, "console");
ffff8000001015c5:	48 ba 13 c7 10 00 00 	movabs $0xffff80000010c713,%rdx
ffff8000001015cc:	80 ff ff 
ffff8000001015cf:	48 b8 c0 44 11 00 00 	movabs $0xffff8000001144c0,%rax
ffff8000001015d6:	80 ff ff 
ffff8000001015d9:	48 89 d6             	mov    %rdx,%rsi
ffff8000001015dc:	48 89 c7             	mov    %rax,%rdi
ffff8000001015df:	48 b8 a5 76 10 00 00 	movabs $0xffff8000001076a5,%rax
ffff8000001015e6:	80 ff ff 
ffff8000001015e9:	ff d0                	call   *%rax
  initlock(&input.lock, "input");
ffff8000001015eb:	48 ba 1b c7 10 00 00 	movabs $0xffff80000010c71b,%rdx
ffff8000001015f2:	80 ff ff 
ffff8000001015f5:	48 b8 c0 43 11 00 00 	movabs $0xffff8000001143c0,%rax
ffff8000001015fc:	80 ff ff 
ffff8000001015ff:	48 89 d6             	mov    %rdx,%rsi
ffff800000101602:	48 89 c7             	mov    %rax,%rdi
ffff800000101605:	48 b8 a5 76 10 00 00 	movabs $0xffff8000001076a5,%rax
ffff80000010160c:	80 ff ff 
ffff80000010160f:	ff d0                	call   *%rax

  devsw[CONSOLE].write = consolewrite;
ffff800000101611:	48 b8 40 45 11 00 00 	movabs $0xffff800000114540,%rax
ffff800000101618:	80 ff ff 
ffff80000010161b:	48 b9 15 15 10 00 00 	movabs $0xffff800000101515,%rcx
ffff800000101622:	80 ff ff 
ffff800000101625:	48 89 48 18          	mov    %rcx,0x18(%rax)
  devsw[CONSOLE].read = consoleread;
ffff800000101629:	48 b8 40 45 11 00 00 	movabs $0xffff800000114540,%rax
ffff800000101630:	80 ff ff 
ffff800000101633:	48 b9 5d 13 10 00 00 	movabs $0xffff80000010135d,%rcx
ffff80000010163a:	80 ff ff 
ffff80000010163d:	48 89 48 10          	mov    %rcx,0x10(%rax)
  cons.locking = 1;
ffff800000101641:	48 b8 c0 44 11 00 00 	movabs $0xffff8000001144c0,%rax
ffff800000101648:	80 ff ff 
ffff80000010164b:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%rax)

  ioapicenable(IRQ_KBD, 0);
ffff800000101652:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000101657:	bf 01 00 00 00       	mov    $0x1,%edi
ffff80000010165c:	48 b8 96 40 10 00 00 	movabs $0xffff800000104096,%rax
ffff800000101663:	80 ff ff 
ffff800000101666:	ff d0                	call   *%rax
}
ffff800000101668:	90                   	nop
ffff800000101669:	5d                   	pop    %rbp
ffff80000010166a:	c3                   	ret

ffff80000010166b <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
ffff80000010166b:	55                   	push   %rbp
ffff80000010166c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010166f:	48 81 ec 00 02 00 00 	sub    $0x200,%rsp
ffff800000101676:	48 89 bd 08 fe ff ff 	mov    %rdi,-0x1f8(%rbp)
ffff80000010167d:	48 89 b5 00 fe ff ff 	mov    %rsi,-0x200(%rbp)
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  oldpgdir = proc->pgdir;
ffff800000101684:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010168b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010168f:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000101693:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

  begin_op();
ffff800000101697:	48 b8 be 50 10 00 00 	movabs $0xffff8000001050be,%rax
ffff80000010169e:	80 ff ff 
ffff8000001016a1:	ff d0                	call   *%rax

  if((ip = namei(path)) == 0){
ffff8000001016a3:	48 8b 85 08 fe ff ff 	mov    -0x1f8(%rbp),%rax
ffff8000001016aa:	48 89 c7             	mov    %rax,%rdi
ffff8000001016ad:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff8000001016b4:	80 ff ff 
ffff8000001016b7:	ff d0                	call   *%rax
ffff8000001016b9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
ffff8000001016bd:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff8000001016c2:	75 16                	jne    ffff8000001016da <exec+0x6f>
    end_op();
ffff8000001016c4:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff8000001016cb:	80 ff ff 
ffff8000001016ce:	ff d0                	call   *%rax
    return -1;
ffff8000001016d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001016d5:	e9 69 05 00 00       	jmp    ffff800000101c43 <exec+0x5d8>
  }
  ilock(ip);
ffff8000001016da:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001016de:	48 89 c7             	mov    %rax,%rdi
ffff8000001016e1:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff8000001016e8:	80 ff ff 
ffff8000001016eb:	ff d0                	call   *%rax
  pgdir = 0;
ffff8000001016ed:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
ffff8000001016f4:	00 

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
ffff8000001016f5:	48 8d b5 50 fe ff ff 	lea    -0x1b0(%rbp),%rsi
ffff8000001016fc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000101700:	b9 40 00 00 00       	mov    $0x40,%ecx
ffff800000101705:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010170a:	48 89 c7             	mov    %rax,%rdi
ffff80000010170d:	48 b8 1d 30 10 00 00 	movabs $0xffff80000010301d,%rax
ffff800000101714:	80 ff ff 
ffff800000101717:	ff d0                	call   *%rax
ffff800000101719:	83 f8 40             	cmp    $0x40,%eax
ffff80000010171c:	0f 85 b7 04 00 00    	jne    ffff800000101bd9 <exec+0x56e>
    goto bad;
  if(elf.magic != ELF_MAGIC)
ffff800000101722:	8b 85 50 fe ff ff    	mov    -0x1b0(%rbp),%eax
ffff800000101728:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
ffff80000010172d:	0f 85 a9 04 00 00    	jne    ffff800000101bdc <exec+0x571>
    goto bad;

  if((pgdir = setupkvm()) == 0)
ffff800000101733:	48 b8 3e b3 10 00 00 	movabs $0xffff80000010b33e,%rax
ffff80000010173a:	80 ff ff 
ffff80000010173d:	ff d0                	call   *%rax
ffff80000010173f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
ffff800000101743:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff800000101748:	0f 84 91 04 00 00    	je     ffff800000101bdf <exec+0x574>
    goto bad;

  // Load program into memory.
  sz = PGSIZE; // skip the first page
ffff80000010174e:	48 c7 45 d8 00 10 00 	movq   $0x1000,-0x28(%rbp)
ffff800000101755:	00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
ffff800000101756:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffff80000010175d:	48 8b 85 70 fe ff ff 	mov    -0x190(%rbp),%rax
ffff800000101764:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffff800000101767:	e9 0f 01 00 00       	jmp    ffff80000010187b <exec+0x210>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
ffff80000010176c:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010176f:	48 8d b5 10 fe ff ff 	lea    -0x1f0(%rbp),%rsi
ffff800000101776:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010177a:	b9 38 00 00 00       	mov    $0x38,%ecx
ffff80000010177f:	48 89 c7             	mov    %rax,%rdi
ffff800000101782:	48 b8 1d 30 10 00 00 	movabs $0xffff80000010301d,%rax
ffff800000101789:	80 ff ff 
ffff80000010178c:	ff d0                	call   *%rax
ffff80000010178e:	83 f8 38             	cmp    $0x38,%eax
ffff800000101791:	0f 85 4b 04 00 00    	jne    ffff800000101be2 <exec+0x577>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
ffff800000101797:	8b 85 10 fe ff ff    	mov    -0x1f0(%rbp),%eax
ffff80000010179d:	83 f8 01             	cmp    $0x1,%eax
ffff8000001017a0:	0f 85 c7 00 00 00    	jne    ffff80000010186d <exec+0x202>
      continue;
    if(ph.memsz < ph.filesz)
ffff8000001017a6:	48 8b 95 38 fe ff ff 	mov    -0x1c8(%rbp),%rdx
ffff8000001017ad:	48 8b 85 30 fe ff ff 	mov    -0x1d0(%rbp),%rax
ffff8000001017b4:	48 39 c2             	cmp    %rax,%rdx
ffff8000001017b7:	0f 82 28 04 00 00    	jb     ffff800000101be5 <exec+0x57a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
ffff8000001017bd:	48 8b 95 20 fe ff ff 	mov    -0x1e0(%rbp),%rdx
ffff8000001017c4:	48 8b 85 38 fe ff ff 	mov    -0x1c8(%rbp),%rax
ffff8000001017cb:	48 01 c2             	add    %rax,%rdx
ffff8000001017ce:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff8000001017d5:	48 39 c2             	cmp    %rax,%rdx
ffff8000001017d8:	0f 82 0a 04 00 00    	jb     ffff800000101be8 <exec+0x57d>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
ffff8000001017de:	48 8b 95 20 fe ff ff 	mov    -0x1e0(%rbp),%rdx
ffff8000001017e5:	48 8b 85 38 fe ff ff 	mov    -0x1c8(%rbp),%rax
ffff8000001017ec:	48 01 c2             	add    %rax,%rdx
ffff8000001017ef:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff8000001017f3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001017f7:	48 89 ce             	mov    %rcx,%rsi
ffff8000001017fa:	48 89 c7             	mov    %rax,%rdi
ffff8000001017fd:	48 b8 95 ba 10 00 00 	movabs $0xffff80000010ba95,%rax
ffff800000101804:	80 ff ff 
ffff800000101807:	ff d0                	call   *%rax
ffff800000101809:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffff80000010180d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff800000101812:	0f 84 d3 03 00 00    	je     ffff800000101beb <exec+0x580>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
ffff800000101818:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff80000010181f:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff800000101824:	48 85 c0             	test   %rax,%rax
ffff800000101827:	0f 85 c1 03 00 00    	jne    ffff800000101bee <exec+0x583>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
ffff80000010182d:	48 8b 85 30 fe ff ff 	mov    -0x1d0(%rbp),%rax
ffff800000101834:	89 c7                	mov    %eax,%edi
ffff800000101836:	48 8b 85 18 fe ff ff 	mov    -0x1e8(%rbp),%rax
ffff80000010183d:	89 c1                	mov    %eax,%ecx
ffff80000010183f:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff800000101846:	48 89 c6             	mov    %rax,%rsi
ffff800000101849:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
ffff80000010184d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff800000101851:	41 89 f8             	mov    %edi,%r8d
ffff800000101854:	48 89 c7             	mov    %rax,%rdi
ffff800000101857:	48 b8 6d b9 10 00 00 	movabs $0xffff80000010b96d,%rax
ffff80000010185e:	80 ff ff 
ffff800000101861:	ff d0                	call   *%rax
ffff800000101863:	85 c0                	test   %eax,%eax
ffff800000101865:	0f 88 86 03 00 00    	js     ffff800000101bf1 <exec+0x586>
ffff80000010186b:	eb 01                	jmp    ffff80000010186e <exec+0x203>
      continue;
ffff80000010186d:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
ffff80000010186e:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffff800000101872:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000101875:	83 c0 38             	add    $0x38,%eax
ffff800000101878:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffff80000010187b:	0f b7 85 88 fe ff ff 	movzwl -0x178(%rbp),%eax
ffff800000101882:	0f b7 c0             	movzwl %ax,%eax
ffff800000101885:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000101888:	0f 8c de fe ff ff    	jl     ffff80000010176c <exec+0x101>
      goto bad;
  }
  iunlockput(ip);
ffff80000010188e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000101892:	48 89 c7             	mov    %rax,%rdi
ffff800000101895:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff80000010189c:	80 ff ff 
ffff80000010189f:	ff d0                	call   *%rax
  end_op();
ffff8000001018a1:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff8000001018a8:	80 ff ff 
ffff8000001018ab:	ff d0                	call   *%rax
  ip = 0;
ffff8000001018ad:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
ffff8000001018b4:	00 

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
ffff8000001018b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001018b9:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff8000001018bf:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff8000001018c5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
ffff8000001018c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001018cd:	48 8d 90 00 20 00 00 	lea    0x2000(%rax),%rdx
ffff8000001018d4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff8000001018d8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001018dc:	48 89 ce             	mov    %rcx,%rsi
ffff8000001018df:	48 89 c7             	mov    %rax,%rdi
ffff8000001018e2:	48 b8 95 ba 10 00 00 	movabs $0xffff80000010ba95,%rax
ffff8000001018e9:	80 ff ff 
ffff8000001018ec:	ff d0                	call   *%rax
ffff8000001018ee:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffff8000001018f2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff8000001018f7:	0f 84 f7 02 00 00    	je     ffff800000101bf4 <exec+0x589>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
ffff8000001018fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101901:	48 2d 00 20 00 00    	sub    $0x2000,%rax
ffff800000101907:	48 89 c2             	mov    %rax,%rdx
ffff80000010190a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010190e:	48 89 d6             	mov    %rdx,%rsi
ffff800000101911:	48 89 c7             	mov    %rax,%rdi
ffff800000101914:	48 b8 09 bf 10 00 00 	movabs $0xffff80000010bf09,%rax
ffff80000010191b:	80 ff ff 
ffff80000010191e:	ff d0                	call   *%rax
  sp = sz;
ffff800000101920:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101924:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
ffff800000101928:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
ffff80000010192f:	00 
ffff800000101930:	e9 c9 00 00 00       	jmp    ffff8000001019fe <exec+0x393>
    if(argc >= MAXARG)
ffff800000101935:	48 83 7d e0 1f       	cmpq   $0x1f,-0x20(%rbp)
ffff80000010193a:	0f 87 b7 02 00 00    	ja     ffff800000101bf7 <exec+0x58c>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~(sizeof(addr_t)-1);
ffff800000101940:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101944:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010194b:	00 
ffff80000010194c:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff800000101953:	48 01 d0             	add    %rdx,%rax
ffff800000101956:	48 8b 00             	mov    (%rax),%rax
ffff800000101959:	48 89 c7             	mov    %rax,%rdi
ffff80000010195c:	48 b8 89 7d 10 00 00 	movabs $0xffff800000107d89,%rax
ffff800000101963:	80 ff ff 
ffff800000101966:	ff d0                	call   *%rax
ffff800000101968:	83 c0 01             	add    $0x1,%eax
ffff80000010196b:	48 98                	cltq
ffff80000010196d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101971:	48 29 c2             	sub    %rax,%rdx
ffff800000101974:	48 89 d0             	mov    %rdx,%rax
ffff800000101977:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
ffff80000010197b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
ffff80000010197f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101983:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010198a:	00 
ffff80000010198b:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff800000101992:	48 01 d0             	add    %rdx,%rax
ffff800000101995:	48 8b 00             	mov    (%rax),%rax
ffff800000101998:	48 89 c7             	mov    %rax,%rdi
ffff80000010199b:	48 b8 89 7d 10 00 00 	movabs $0xffff800000107d89,%rax
ffff8000001019a2:	80 ff ff 
ffff8000001019a5:	ff d0                	call   *%rax
ffff8000001019a7:	83 c0 01             	add    $0x1,%eax
ffff8000001019aa:	48 63 c8             	movslq %eax,%rcx
ffff8000001019ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001019b1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001019b8:	00 
ffff8000001019b9:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff8000001019c0:	48 01 d0             	add    %rdx,%rax
ffff8000001019c3:	48 8b 10             	mov    (%rax),%rdx
ffff8000001019c6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
ffff8000001019ca:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001019ce:	48 89 c7             	mov    %rax,%rdi
ffff8000001019d1:	48 b8 7b c1 10 00 00 	movabs $0xffff80000010c17b,%rax
ffff8000001019d8:	80 ff ff 
ffff8000001019db:	ff d0                	call   *%rax
ffff8000001019dd:	85 c0                	test   %eax,%eax
ffff8000001019df:	0f 88 15 02 00 00    	js     ffff800000101bfa <exec+0x58f>
      goto bad;
    ustack[1+argc] = sp;
ffff8000001019e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001019e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff8000001019ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001019f1:	48 89 84 d5 90 fe ff 	mov    %rax,-0x170(%rbp,%rdx,8)
ffff8000001019f8:	ff 
  for(argc = 0; argv[argc]; argc++) {
ffff8000001019f9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
ffff8000001019fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101a02:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000101a09:	00 
ffff800000101a0a:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff800000101a11:	48 01 d0             	add    %rdx,%rax
ffff800000101a14:	48 8b 00             	mov    (%rax),%rax
ffff800000101a17:	48 85 c0             	test   %rax,%rax
ffff800000101a1a:	0f 85 15 ff ff ff    	jne    ffff800000101935 <exec+0x2ca>
  }
  ustack[1+argc] = 0;
ffff800000101a20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101a24:	48 83 c0 01          	add    $0x1,%rax
ffff800000101a28:	48 c7 84 c5 90 fe ff 	movq   $0x0,-0x170(%rbp,%rax,8)
ffff800000101a2f:	ff 00 00 00 00 

  ustack[0] = 0xffffffffffffffff;  // fake return PC
ffff800000101a34:	48 c7 85 90 fe ff ff 	movq   $0xffffffffffffffff,-0x170(%rbp)
ffff800000101a3b:	ff ff ff ff 

	// argc and argv for main() entry point
  proc->tf->rdi = argc;
ffff800000101a3f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a46:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a4a:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101a4e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000101a52:	48 89 50 30          	mov    %rdx,0x30(%rax)
  proc->tf->rsi = sp - (argc+1)*sizeof(addr_t);
ffff800000101a56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101a5a:	48 83 c0 01          	add    $0x1,%rax
ffff800000101a5e:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
ffff800000101a65:	00 
ffff800000101a66:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a6d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a71:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101a75:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101a79:	48 29 ca             	sub    %rcx,%rdx
ffff800000101a7c:	48 89 50 28          	mov    %rdx,0x28(%rax)

  sp -= (1+argc+1) * sizeof(addr_t);
ffff800000101a80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101a84:	48 83 c0 02          	add    $0x2,%rax
ffff800000101a88:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000101a8c:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
  if(copyout(pgdir, sp, ustack, (1+argc+1)*sizeof(addr_t)) < 0)
ffff800000101a90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101a94:	48 83 c0 02          	add    $0x2,%rax
ffff800000101a98:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
ffff800000101a9f:	00 
ffff800000101aa0:	48 8d 95 90 fe ff ff 	lea    -0x170(%rbp),%rdx
ffff800000101aa7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
ffff800000101aab:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff800000101aaf:	48 89 c7             	mov    %rax,%rdi
ffff800000101ab2:	48 b8 7b c1 10 00 00 	movabs $0xffff80000010c17b,%rax
ffff800000101ab9:	80 ff ff 
ffff800000101abc:	ff d0                	call   *%rax
ffff800000101abe:	85 c0                	test   %eax,%eax
ffff800000101ac0:	0f 88 37 01 00 00    	js     ffff800000101bfd <exec+0x592>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
ffff800000101ac6:	48 8b 85 08 fe ff ff 	mov    -0x1f8(%rbp),%rax
ffff800000101acd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000101ad1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101ad5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000101ad9:	eb 1c                	jmp    ffff800000101af7 <exec+0x48c>
    if(*s == '/')
ffff800000101adb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101adf:	0f b6 00             	movzbl (%rax),%eax
ffff800000101ae2:	3c 2f                	cmp    $0x2f,%al
ffff800000101ae4:	75 0c                	jne    ffff800000101af2 <exec+0x487>
      last = s+1;
ffff800000101ae6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101aea:	48 83 c0 01          	add    $0x1,%rax
ffff800000101aee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(last=s=path; *s; s++)
ffff800000101af2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000101af7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101afb:	0f b6 00             	movzbl (%rax),%eax
ffff800000101afe:	84 c0                	test   %al,%al
ffff800000101b00:	75 d9                	jne    ffff800000101adb <exec+0x470>
  safestrcpy(proc->name, last, sizeof(proc->name));
ffff800000101b02:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101b09:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101b0d:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff800000101b14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000101b18:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000101b1d:	48 89 c6             	mov    %rax,%rsi
ffff800000101b20:	48 89 cf             	mov    %rcx,%rdi
ffff800000101b23:	48 b8 26 7d 10 00 00 	movabs $0xffff800000107d26,%rax
ffff800000101b2a:	80 ff ff 
ffff800000101b2d:	ff d0                	call   *%rax

  // Commit to the user image.
  proc->pgdir = pgdir;
ffff800000101b2f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101b36:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101b3a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
ffff800000101b3e:	48 89 50 08          	mov    %rdx,0x8(%rax)
  proc->sz = sz;
ffff800000101b42:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101b49:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101b4d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000101b51:	48 89 10             	mov    %rdx,(%rax)
  proc->tf->rip = elf.entry;  // main
ffff800000101b54:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101b5b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101b5f:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101b63:	48 8b 95 68 fe ff ff 	mov    -0x198(%rbp),%rdx
ffff800000101b6a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
  proc->tf->rcx = elf.entry;
ffff800000101b71:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101b78:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101b7c:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101b80:	48 8b 95 68 fe ff ff 	mov    -0x198(%rbp),%rdx
ffff800000101b87:	48 89 50 10          	mov    %rdx,0x10(%rax)
  proc->tf->rsp = sp;
ffff800000101b8b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101b92:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101b96:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101b9a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101b9e:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
  switchuvm(proc);
ffff800000101ba5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101bac:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101bb0:	48 89 c7             	mov    %rax,%rdi
ffff800000101bb3:	48 b8 9c b4 10 00 00 	movabs $0xffff80000010b49c,%rax
ffff800000101bba:	80 ff ff 
ffff800000101bbd:	ff d0                	call   *%rax
  freevm(oldpgdir);
ffff800000101bbf:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101bc3:	48 89 c7             	mov    %rax,%rdi
ffff800000101bc6:	48 b8 d2 bc 10 00 00 	movabs $0xffff80000010bcd2,%rax
ffff800000101bcd:	80 ff ff 
ffff800000101bd0:	ff d0                	call   *%rax
  return 0;
ffff800000101bd2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101bd7:	eb 6a                	jmp    ffff800000101c43 <exec+0x5d8>
    goto bad;
ffff800000101bd9:	90                   	nop
ffff800000101bda:	eb 22                	jmp    ffff800000101bfe <exec+0x593>
    goto bad;
ffff800000101bdc:	90                   	nop
ffff800000101bdd:	eb 1f                	jmp    ffff800000101bfe <exec+0x593>
    goto bad;
ffff800000101bdf:	90                   	nop
ffff800000101be0:	eb 1c                	jmp    ffff800000101bfe <exec+0x593>
      goto bad;
ffff800000101be2:	90                   	nop
ffff800000101be3:	eb 19                	jmp    ffff800000101bfe <exec+0x593>
      goto bad;
ffff800000101be5:	90                   	nop
ffff800000101be6:	eb 16                	jmp    ffff800000101bfe <exec+0x593>
      goto bad;
ffff800000101be8:	90                   	nop
ffff800000101be9:	eb 13                	jmp    ffff800000101bfe <exec+0x593>
      goto bad;
ffff800000101beb:	90                   	nop
ffff800000101bec:	eb 10                	jmp    ffff800000101bfe <exec+0x593>
      goto bad;
ffff800000101bee:	90                   	nop
ffff800000101bef:	eb 0d                	jmp    ffff800000101bfe <exec+0x593>
      goto bad;
ffff800000101bf1:	90                   	nop
ffff800000101bf2:	eb 0a                	jmp    ffff800000101bfe <exec+0x593>
    goto bad;
ffff800000101bf4:	90                   	nop
ffff800000101bf5:	eb 07                	jmp    ffff800000101bfe <exec+0x593>
      goto bad;
ffff800000101bf7:	90                   	nop
ffff800000101bf8:	eb 04                	jmp    ffff800000101bfe <exec+0x593>
      goto bad;
ffff800000101bfa:	90                   	nop
ffff800000101bfb:	eb 01                	jmp    ffff800000101bfe <exec+0x593>
    goto bad;
ffff800000101bfd:	90                   	nop

 bad:
  if(pgdir)
ffff800000101bfe:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff800000101c03:	74 13                	je     ffff800000101c18 <exec+0x5ad>
    freevm(pgdir);
ffff800000101c05:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff800000101c09:	48 89 c7             	mov    %rax,%rdi
ffff800000101c0c:	48 b8 d2 bc 10 00 00 	movabs $0xffff80000010bcd2,%rax
ffff800000101c13:	80 ff ff 
ffff800000101c16:	ff d0                	call   *%rax
  if(ip){
ffff800000101c18:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff800000101c1d:	74 1f                	je     ffff800000101c3e <exec+0x5d3>
    iunlockput(ip);
ffff800000101c1f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000101c23:	48 89 c7             	mov    %rax,%rdi
ffff800000101c26:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000101c2d:	80 ff ff 
ffff800000101c30:	ff d0                	call   *%rax
    end_op();
ffff800000101c32:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000101c39:	80 ff ff 
ffff800000101c3c:	ff d0                	call   *%rax
  }
  return -1;
ffff800000101c3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000101c43:	c9                   	leave
ffff800000101c44:	c3                   	ret

ffff800000101c45 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
ffff800000101c45:	55                   	push   %rbp
ffff800000101c46:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ftable.lock, "ftable");
ffff800000101c49:	48 ba 21 c7 10 00 00 	movabs $0xffff80000010c721,%rdx
ffff800000101c50:	80 ff ff 
ffff800000101c53:	48 b8 e0 45 11 00 00 	movabs $0xffff8000001145e0,%rax
ffff800000101c5a:	80 ff ff 
ffff800000101c5d:	48 89 d6             	mov    %rdx,%rsi
ffff800000101c60:	48 89 c7             	mov    %rax,%rdi
ffff800000101c63:	48 b8 a5 76 10 00 00 	movabs $0xffff8000001076a5,%rax
ffff800000101c6a:	80 ff ff 
ffff800000101c6d:	ff d0                	call   *%rax
}
ffff800000101c6f:	90                   	nop
ffff800000101c70:	5d                   	pop    %rbp
ffff800000101c71:	c3                   	ret

ffff800000101c72 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
ffff800000101c72:	55                   	push   %rbp
ffff800000101c73:	48 89 e5             	mov    %rsp,%rbp
ffff800000101c76:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;

  acquire(&ftable.lock);
ffff800000101c7a:	48 b8 e0 45 11 00 00 	movabs $0xffff8000001145e0,%rax
ffff800000101c81:	80 ff ff 
ffff800000101c84:	48 89 c7             	mov    %rax,%rdi
ffff800000101c87:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000101c8e:	80 ff ff 
ffff800000101c91:	ff d0                	call   *%rax
  for(f = ftable.file; f < ftable.file + NFILE; f++){
ffff800000101c93:	48 b8 48 46 11 00 00 	movabs $0xffff800000114648,%rax
ffff800000101c9a:	80 ff ff 
ffff800000101c9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000101ca1:	eb 3a                	jmp    ffff800000101cdd <filealloc+0x6b>
    if(f->ref == 0){
ffff800000101ca3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101ca7:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101caa:	85 c0                	test   %eax,%eax
ffff800000101cac:	75 2a                	jne    ffff800000101cd8 <filealloc+0x66>
      f->ref = 1;
ffff800000101cae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101cb2:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%rax)
      release(&ftable.lock);
ffff800000101cb9:	48 b8 e0 45 11 00 00 	movabs $0xffff8000001145e0,%rax
ffff800000101cc0:	80 ff ff 
ffff800000101cc3:	48 89 c7             	mov    %rax,%rdi
ffff800000101cc6:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000101ccd:	80 ff ff 
ffff800000101cd0:	ff d0                	call   *%rax
      return f;
ffff800000101cd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101cd6:	eb 33                	jmp    ffff800000101d0b <filealloc+0x99>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
ffff800000101cd8:	48 83 45 f8 28       	addq   $0x28,-0x8(%rbp)
ffff800000101cdd:	48 b8 e8 55 11 00 00 	movabs $0xffff8000001155e8,%rax
ffff800000101ce4:	80 ff ff 
ffff800000101ce7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000101ceb:	72 b6                	jb     ffff800000101ca3 <filealloc+0x31>
    }
  }
  release(&ftable.lock);
ffff800000101ced:	48 b8 e0 45 11 00 00 	movabs $0xffff8000001145e0,%rax
ffff800000101cf4:	80 ff ff 
ffff800000101cf7:	48 89 c7             	mov    %rax,%rdi
ffff800000101cfa:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000101d01:	80 ff ff 
ffff800000101d04:	ff d0                	call   *%rax
  return 0;
ffff800000101d06:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000101d0b:	c9                   	leave
ffff800000101d0c:	c3                   	ret

ffff800000101d0d <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
ffff800000101d0d:	55                   	push   %rbp
ffff800000101d0e:	48 89 e5             	mov    %rsp,%rbp
ffff800000101d11:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000101d15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&ftable.lock);
ffff800000101d19:	48 b8 e0 45 11 00 00 	movabs $0xffff8000001145e0,%rax
ffff800000101d20:	80 ff ff 
ffff800000101d23:	48 89 c7             	mov    %rax,%rdi
ffff800000101d26:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000101d2d:	80 ff ff 
ffff800000101d30:	ff d0                	call   *%rax
  if(f->ref < 1)
ffff800000101d32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101d36:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101d39:	85 c0                	test   %eax,%eax
ffff800000101d3b:	7f 19                	jg     ffff800000101d56 <filedup+0x49>
    panic("filedup");
ffff800000101d3d:	48 b8 28 c7 10 00 00 	movabs $0xffff80000010c728,%rax
ffff800000101d44:	80 ff ff 
ffff800000101d47:	48 89 c7             	mov    %rax,%rdi
ffff800000101d4a:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000101d51:	80 ff ff 
ffff800000101d54:	ff d0                	call   *%rax
  f->ref++;
ffff800000101d56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101d5a:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101d5d:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101d60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101d64:	89 50 04             	mov    %edx,0x4(%rax)
  release(&ftable.lock);
ffff800000101d67:	48 b8 e0 45 11 00 00 	movabs $0xffff8000001145e0,%rax
ffff800000101d6e:	80 ff ff 
ffff800000101d71:	48 89 c7             	mov    %rax,%rdi
ffff800000101d74:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000101d7b:	80 ff ff 
ffff800000101d7e:	ff d0                	call   *%rax
  return f;
ffff800000101d80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000101d84:	c9                   	leave
ffff800000101d85:	c3                   	ret

ffff800000101d86 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
ffff800000101d86:	55                   	push   %rbp
ffff800000101d87:	48 89 e5             	mov    %rsp,%rbp
ffff800000101d8a:	53                   	push   %rbx
ffff800000101d8b:	48 83 ec 48          	sub    $0x48,%rsp
ffff800000101d8f:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  struct file ff;

  acquire(&ftable.lock);
ffff800000101d93:	48 b8 e0 45 11 00 00 	movabs $0xffff8000001145e0,%rax
ffff800000101d9a:	80 ff ff 
ffff800000101d9d:	48 89 c7             	mov    %rax,%rdi
ffff800000101da0:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000101da7:	80 ff ff 
ffff800000101daa:	ff d0                	call   *%rax
  if(f->ref < 1)
ffff800000101dac:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101db0:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101db3:	85 c0                	test   %eax,%eax
ffff800000101db5:	7f 19                	jg     ffff800000101dd0 <fileclose+0x4a>
    panic("fileclose");
ffff800000101db7:	48 b8 30 c7 10 00 00 	movabs $0xffff80000010c730,%rax
ffff800000101dbe:	80 ff ff 
ffff800000101dc1:	48 89 c7             	mov    %rax,%rdi
ffff800000101dc4:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000101dcb:	80 ff ff 
ffff800000101dce:	ff d0                	call   *%rax
  if(--f->ref > 0){
ffff800000101dd0:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101dd4:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101dd7:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000101dda:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101dde:	89 50 04             	mov    %edx,0x4(%rax)
ffff800000101de1:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101de5:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101de8:	85 c0                	test   %eax,%eax
ffff800000101dea:	7e 1e                	jle    ffff800000101e0a <fileclose+0x84>
    release(&ftable.lock);
ffff800000101dec:	48 b8 e0 45 11 00 00 	movabs $0xffff8000001145e0,%rax
ffff800000101df3:	80 ff ff 
ffff800000101df6:	48 89 c7             	mov    %rax,%rdi
ffff800000101df9:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000101e00:	80 ff ff 
ffff800000101e03:	ff d0                	call   *%rax
ffff800000101e05:	e9 b2 00 00 00       	jmp    ffff800000101ebc <fileclose+0x136>
    return;
  }
  ff = *f;
ffff800000101e0a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101e0e:	48 8b 08             	mov    (%rax),%rcx
ffff800000101e11:	48 8b 58 08          	mov    0x8(%rax),%rbx
ffff800000101e15:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
ffff800000101e19:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
ffff800000101e1d:	48 8b 48 10          	mov    0x10(%rax),%rcx
ffff800000101e21:	48 8b 58 18          	mov    0x18(%rax),%rbx
ffff800000101e25:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
ffff800000101e29:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
ffff800000101e2d:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff800000101e31:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  f->ref = 0;
ffff800000101e35:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101e39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
  f->type = FD_NONE;
ffff800000101e40:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101e44:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  release(&ftable.lock);
ffff800000101e4a:	48 b8 e0 45 11 00 00 	movabs $0xffff8000001145e0,%rax
ffff800000101e51:	80 ff ff 
ffff800000101e54:	48 89 c7             	mov    %rax,%rdi
ffff800000101e57:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000101e5e:	80 ff ff 
ffff800000101e61:	ff d0                	call   *%rax

  if(ff.type == FD_PIPE)
ffff800000101e63:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff800000101e66:	83 f8 01             	cmp    $0x1,%eax
ffff800000101e69:	75 1e                	jne    ffff800000101e89 <fileclose+0x103>
    pipeclose(ff.pipe, ff.writable);
ffff800000101e6b:	0f b6 45 c9          	movzbl -0x37(%rbp),%eax
ffff800000101e6f:	0f be d0             	movsbl %al,%edx
ffff800000101e72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000101e76:	89 d6                	mov    %edx,%esi
ffff800000101e78:	48 89 c7             	mov    %rax,%rdi
ffff800000101e7b:	48 b8 cd 5f 10 00 00 	movabs $0xffff800000105fcd,%rax
ffff800000101e82:	80 ff ff 
ffff800000101e85:	ff d0                	call   *%rax
ffff800000101e87:	eb 33                	jmp    ffff800000101ebc <fileclose+0x136>
  else if(ff.type == FD_INODE){
ffff800000101e89:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff800000101e8c:	83 f8 02             	cmp    $0x2,%eax
ffff800000101e8f:	75 2b                	jne    ffff800000101ebc <fileclose+0x136>
    begin_op();
ffff800000101e91:	48 b8 be 50 10 00 00 	movabs $0xffff8000001050be,%rax
ffff800000101e98:	80 ff ff 
ffff800000101e9b:	ff d0                	call   *%rax
    iput(ff.ip);
ffff800000101e9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101ea1:	48 89 c7             	mov    %rax,%rdi
ffff800000101ea4:	48 b8 b7 2b 10 00 00 	movabs $0xffff800000102bb7,%rax
ffff800000101eab:	80 ff ff 
ffff800000101eae:	ff d0                	call   *%rax
    end_op();
ffff800000101eb0:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000101eb7:	80 ff ff 
ffff800000101eba:	ff d0                	call   *%rax
  }
}
ffff800000101ebc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
ffff800000101ec0:	c9                   	leave
ffff800000101ec1:	c3                   	ret

ffff800000101ec2 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
ffff800000101ec2:	55                   	push   %rbp
ffff800000101ec3:	48 89 e5             	mov    %rsp,%rbp
ffff800000101ec6:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000101eca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000101ece:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(f->type == FD_INODE){
ffff800000101ed2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101ed6:	8b 00                	mov    (%rax),%eax
ffff800000101ed8:	83 f8 02             	cmp    $0x2,%eax
ffff800000101edb:	75 53                	jne    ffff800000101f30 <filestat+0x6e>
    ilock(f->ip);
ffff800000101edd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101ee1:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101ee5:	48 89 c7             	mov    %rax,%rdi
ffff800000101ee8:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff800000101eef:	80 ff ff 
ffff800000101ef2:	ff d0                	call   *%rax
    stati(f->ip, st);
ffff800000101ef4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101ef8:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101efc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000101f00:	48 89 d6             	mov    %rdx,%rsi
ffff800000101f03:	48 89 c7             	mov    %rax,%rdi
ffff800000101f06:	48 b8 b7 2f 10 00 00 	movabs $0xffff800000102fb7,%rax
ffff800000101f0d:	80 ff ff 
ffff800000101f10:	ff d0                	call   *%rax
    iunlock(f->ip);
ffff800000101f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101f16:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101f1a:	48 89 c7             	mov    %rax,%rdi
ffff800000101f1d:	48 b8 4b 2b 10 00 00 	movabs $0xffff800000102b4b,%rax
ffff800000101f24:	80 ff ff 
ffff800000101f27:	ff d0                	call   *%rax
    return 0;
ffff800000101f29:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101f2e:	eb 05                	jmp    ffff800000101f35 <filestat+0x73>
  }
  return -1;
ffff800000101f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000101f35:	c9                   	leave
ffff800000101f36:	c3                   	ret

ffff800000101f37 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
ffff800000101f37:	55                   	push   %rbp
ffff800000101f38:	48 89 e5             	mov    %rsp,%rbp
ffff800000101f3b:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101f3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101f43:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000101f47:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int r;

  if(f->readable == 0)
ffff800000101f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f4e:	0f b6 40 08          	movzbl 0x8(%rax),%eax
ffff800000101f52:	84 c0                	test   %al,%al
ffff800000101f54:	75 0a                	jne    ffff800000101f60 <fileread+0x29>
    return -1;
ffff800000101f56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000101f5b:	e9 c9 00 00 00       	jmp    ffff800000102029 <fileread+0xf2>
  if(f->type == FD_PIPE)
ffff800000101f60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f64:	8b 00                	mov    (%rax),%eax
ffff800000101f66:	83 f8 01             	cmp    $0x1,%eax
ffff800000101f69:	75 26                	jne    ffff800000101f91 <fileread+0x5a>
    return piperead(f->pipe, addr, n);
ffff800000101f6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f6f:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000101f73:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff800000101f76:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff800000101f7a:	48 89 ce             	mov    %rcx,%rsi
ffff800000101f7d:	48 89 c7             	mov    %rax,%rdi
ffff800000101f80:	48 b8 e0 61 10 00 00 	movabs $0xffff8000001061e0,%rax
ffff800000101f87:	80 ff ff 
ffff800000101f8a:	ff d0                	call   *%rax
ffff800000101f8c:	e9 98 00 00 00       	jmp    ffff800000102029 <fileread+0xf2>
  if(f->type == FD_INODE){
ffff800000101f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f95:	8b 00                	mov    (%rax),%eax
ffff800000101f97:	83 f8 02             	cmp    $0x2,%eax
ffff800000101f9a:	75 74                	jne    ffff800000102010 <fileread+0xd9>
    ilock(f->ip);
ffff800000101f9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101fa0:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101fa4:	48 89 c7             	mov    %rax,%rdi
ffff800000101fa7:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff800000101fae:	80 ff ff 
ffff800000101fb1:	ff d0                	call   *%rax
    if((r = readi(f->ip, addr, f->off, n)) > 0)
ffff800000101fb3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
ffff800000101fb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101fba:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000101fbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101fc1:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101fc5:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
ffff800000101fc9:	48 89 c7             	mov    %rax,%rdi
ffff800000101fcc:	48 b8 1d 30 10 00 00 	movabs $0xffff80000010301d,%rax
ffff800000101fd3:	80 ff ff 
ffff800000101fd6:	ff d0                	call   *%rax
ffff800000101fd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000101fdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000101fdf:	7e 13                	jle    ffff800000101ff4 <fileread+0xbd>
      f->off += r;
ffff800000101fe1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101fe5:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000101fe8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101feb:	01 c2                	add    %eax,%edx
ffff800000101fed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ff1:	89 50 20             	mov    %edx,0x20(%rax)
    iunlock(f->ip);
ffff800000101ff4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ff8:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101ffc:	48 89 c7             	mov    %rax,%rdi
ffff800000101fff:	48 b8 4b 2b 10 00 00 	movabs $0xffff800000102b4b,%rax
ffff800000102006:	80 ff ff 
ffff800000102009:	ff d0                	call   *%rax
    return r;
ffff80000010200b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010200e:	eb 19                	jmp    ffff800000102029 <fileread+0xf2>
  }
  panic("fileread");
ffff800000102010:	48 b8 3a c7 10 00 00 	movabs $0xffff80000010c73a,%rax
ffff800000102017:	80 ff ff 
ffff80000010201a:	48 89 c7             	mov    %rax,%rdi
ffff80000010201d:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000102024:	80 ff ff 
ffff800000102027:	ff d0                	call   *%rax
}
ffff800000102029:	c9                   	leave
ffff80000010202a:	c3                   	ret

ffff80000010202b <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
ffff80000010202b:	55                   	push   %rbp
ffff80000010202c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010202f:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000102033:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000102037:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010203b:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int r;

  if(f->writable == 0)
ffff80000010203e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102042:	0f b6 40 09          	movzbl 0x9(%rax),%eax
ffff800000102046:	84 c0                	test   %al,%al
ffff800000102048:	75 0a                	jne    ffff800000102054 <filewrite+0x29>
    return -1;
ffff80000010204a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010204f:	e9 63 01 00 00       	jmp    ffff8000001021b7 <filewrite+0x18c>
  if(f->type == FD_PIPE)
ffff800000102054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102058:	8b 00                	mov    (%rax),%eax
ffff80000010205a:	83 f8 01             	cmp    $0x1,%eax
ffff80000010205d:	75 26                	jne    ffff800000102085 <filewrite+0x5a>
    return pipewrite(f->pipe, addr, n);
ffff80000010205f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102063:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000102067:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff80000010206a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010206e:	48 89 ce             	mov    %rcx,%rsi
ffff800000102071:	48 89 c7             	mov    %rax,%rdi
ffff800000102074:	48 b8 a0 60 10 00 00 	movabs $0xffff8000001060a0,%rax
ffff80000010207b:	80 ff ff 
ffff80000010207e:	ff d0                	call   *%rax
ffff800000102080:	e9 32 01 00 00       	jmp    ffff8000001021b7 <filewrite+0x18c>
  if(f->type == FD_INODE){
ffff800000102085:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102089:	8b 00                	mov    (%rax),%eax
ffff80000010208b:	83 f8 02             	cmp    $0x2,%eax
ffff80000010208e:	0f 85 0a 01 00 00    	jne    ffff80000010219e <filewrite+0x173>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
ffff800000102094:	c7 45 f4 00 1a 00 00 	movl   $0x1a00,-0xc(%rbp)
    int i = 0;
ffff80000010209b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    while(i < n){
ffff8000001020a2:	e9 d4 00 00 00       	jmp    ffff80000010217b <filewrite+0x150>
      int n1 = n - i;
ffff8000001020a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001020aa:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff8000001020ad:	89 45 f8             	mov    %eax,-0x8(%rbp)
      if(n1 > max)
ffff8000001020b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001020b3:	3b 45 f4             	cmp    -0xc(%rbp),%eax
ffff8000001020b6:	7e 06                	jle    ffff8000001020be <filewrite+0x93>
        n1 = max;
ffff8000001020b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001020bb:	89 45 f8             	mov    %eax,-0x8(%rbp)

      begin_op();
ffff8000001020be:	48 b8 be 50 10 00 00 	movabs $0xffff8000001050be,%rax
ffff8000001020c5:	80 ff ff 
ffff8000001020c8:	ff d0                	call   *%rax
      ilock(f->ip);
ffff8000001020ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001020ce:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff8000001020d2:	48 89 c7             	mov    %rax,%rdi
ffff8000001020d5:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff8000001020dc:	80 ff ff 
ffff8000001020df:	ff d0                	call   *%rax
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
ffff8000001020e1:	8b 4d f8             	mov    -0x8(%rbp),%ecx
ffff8000001020e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001020e8:	8b 50 20             	mov    0x20(%rax),%edx
ffff8000001020eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001020ee:	48 63 f0             	movslq %eax,%rsi
ffff8000001020f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001020f5:	48 01 c6             	add    %rax,%rsi
ffff8000001020f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001020fc:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000102100:	48 89 c7             	mov    %rax,%rdi
ffff800000102103:	48 b8 ea 31 10 00 00 	movabs $0xffff8000001031ea,%rax
ffff80000010210a:	80 ff ff 
ffff80000010210d:	ff d0                	call   *%rax
ffff80000010210f:	89 45 f0             	mov    %eax,-0x10(%rbp)
ffff800000102112:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
ffff800000102116:	7e 13                	jle    ffff80000010212b <filewrite+0x100>
        f->off += r;
ffff800000102118:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010211c:	8b 50 20             	mov    0x20(%rax),%edx
ffff80000010211f:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102122:	01 c2                	add    %eax,%edx
ffff800000102124:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102128:	89 50 20             	mov    %edx,0x20(%rax)
      iunlock(f->ip);
ffff80000010212b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010212f:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000102133:	48 89 c7             	mov    %rax,%rdi
ffff800000102136:	48 b8 4b 2b 10 00 00 	movabs $0xffff800000102b4b,%rax
ffff80000010213d:	80 ff ff 
ffff800000102140:	ff d0                	call   *%rax
      end_op();
ffff800000102142:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000102149:	80 ff ff 
ffff80000010214c:	ff d0                	call   *%rax

      if(r < 0)
ffff80000010214e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
ffff800000102152:	78 35                	js     ffff800000102189 <filewrite+0x15e>
        break;
      if(r != n1)
ffff800000102154:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102157:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffff80000010215a:	74 19                	je     ffff800000102175 <filewrite+0x14a>
        panic("short filewrite");
ffff80000010215c:	48 b8 43 c7 10 00 00 	movabs $0xffff80000010c743,%rax
ffff800000102163:	80 ff ff 
ffff800000102166:	48 89 c7             	mov    %rax,%rdi
ffff800000102169:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000102170:	80 ff ff 
ffff800000102173:	ff d0                	call   *%rax
      i += r;
ffff800000102175:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102178:	01 45 fc             	add    %eax,-0x4(%rbp)
    while(i < n){
ffff80000010217b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010217e:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff800000102181:	0f 8c 20 ff ff ff    	jl     ffff8000001020a7 <filewrite+0x7c>
ffff800000102187:	eb 01                	jmp    ffff80000010218a <filewrite+0x15f>
        break;
ffff800000102189:	90                   	nop
    }
    return i == n ? n : -1;
ffff80000010218a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010218d:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff800000102190:	75 05                	jne    ffff800000102197 <filewrite+0x16c>
ffff800000102192:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000102195:	eb 20                	jmp    ffff8000001021b7 <filewrite+0x18c>
ffff800000102197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010219c:	eb 19                	jmp    ffff8000001021b7 <filewrite+0x18c>
  }
  panic("filewrite");
ffff80000010219e:	48 b8 53 c7 10 00 00 	movabs $0xffff80000010c753,%rax
ffff8000001021a5:	80 ff ff 
ffff8000001021a8:	48 89 c7             	mov    %rax,%rdi
ffff8000001021ab:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001021b2:	80 ff ff 
ffff8000001021b5:	ff d0                	call   *%rax
}
ffff8000001021b7:	c9                   	leave
ffff8000001021b8:	c3                   	ret

ffff8000001021b9 <readsb>:
struct superblock sb;

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
ffff8000001021b9:	55                   	push   %rbp
ffff8000001021ba:	48 89 e5             	mov    %rsp,%rbp
ffff8000001021bd:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001021c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001021c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct buf *bp = bread(dev, 1);
ffff8000001021c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001021cb:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001021d0:	89 c7                	mov    %eax,%edi
ffff8000001021d2:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff8000001021d9:	80 ff ff 
ffff8000001021dc:	ff d0                	call   *%rax
ffff8000001021de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memmove(sb, bp->data, sizeof(*sb));
ffff8000001021e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001021e6:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff8000001021ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001021f1:	ba 1c 00 00 00       	mov    $0x1c,%edx
ffff8000001021f6:	48 89 ce             	mov    %rcx,%rsi
ffff8000001021f9:	48 89 c7             	mov    %rax,%rdi
ffff8000001021fc:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff800000102203:	80 ff ff 
ffff800000102206:	ff d0                	call   *%rax
  brelse(bp);
ffff800000102208:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010220c:	48 89 c7             	mov    %rax,%rdi
ffff80000010220f:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000102216:	80 ff ff 
ffff800000102219:	ff d0                	call   *%rax
}
ffff80000010221b:	90                   	nop
ffff80000010221c:	c9                   	leave
ffff80000010221d:	c3                   	ret

ffff80000010221e <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
ffff80000010221e:	55                   	push   %rbp
ffff80000010221f:	48 89 e5             	mov    %rsp,%rbp
ffff800000102222:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102226:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000102229:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *bp = bread(dev, bno);
ffff80000010222c:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010222f:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102232:	89 d6                	mov    %edx,%esi
ffff800000102234:	89 c7                	mov    %eax,%edi
ffff800000102236:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff80000010223d:	80 ff ff 
ffff800000102240:	ff d0                	call   *%rax
ffff800000102242:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(bp->data, 0, BSIZE);
ffff800000102246:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010224a:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102250:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000102255:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010225a:	48 89 c7             	mov    %rax,%rdi
ffff80000010225d:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff800000102264:	80 ff ff 
ffff800000102267:	ff d0                	call   *%rax
  log_write(bp);
ffff800000102269:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010226d:	48 89 c7             	mov    %rax,%rdi
ffff800000102270:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff800000102277:	80 ff ff 
ffff80000010227a:	ff d0                	call   *%rax
  brelse(bp);
ffff80000010227c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102280:	48 89 c7             	mov    %rax,%rdi
ffff800000102283:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff80000010228a:	80 ff ff 
ffff80000010228d:	ff d0                	call   *%rax
}
ffff80000010228f:	90                   	nop
ffff800000102290:	c9                   	leave
ffff800000102291:	c3                   	ret

ffff800000102292 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
ffff800000102292:	55                   	push   %rbp
ffff800000102293:	48 89 e5             	mov    %rsp,%rbp
ffff800000102296:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010229a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  int b, bi, m;
  struct buf *bp;
  for(b = 0; b < sb.size; b += BPB){
ffff80000010229d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001022a4:	e9 4a 01 00 00       	jmp    ffff8000001023f3 <balloc+0x161>
    bp = bread(dev, BBLOCK(b, sb));
ffff8000001022a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001022ac:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
ffff8000001022b2:	85 c0                	test   %eax,%eax
ffff8000001022b4:	0f 48 c2             	cmovs  %edx,%eax
ffff8000001022b7:	c1 f8 0c             	sar    $0xc,%eax
ffff8000001022ba:	89 c2                	mov    %eax,%edx
ffff8000001022bc:	48 b8 00 56 11 00 00 	movabs $0xffff800000115600,%rax
ffff8000001022c3:	80 ff ff 
ffff8000001022c6:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001022c9:	01 c2                	add    %eax,%edx
ffff8000001022cb:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001022ce:	89 d6                	mov    %edx,%esi
ffff8000001022d0:	89 c7                	mov    %eax,%edi
ffff8000001022d2:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff8000001022d9:	80 ff ff 
ffff8000001022dc:	ff d0                	call   *%rax
ffff8000001022de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
ffff8000001022e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff8000001022e9:	e9 c4 00 00 00       	jmp    ffff8000001023b2 <balloc+0x120>
      m = 1 << (bi % 8);
ffff8000001022ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001022f1:	83 e0 07             	and    $0x7,%eax
ffff8000001022f4:	ba 01 00 00 00       	mov    $0x1,%edx
ffff8000001022f9:	89 c1                	mov    %eax,%ecx
ffff8000001022fb:	d3 e2                	shl    %cl,%edx
ffff8000001022fd:	89 d0                	mov    %edx,%eax
ffff8000001022ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
ffff800000102302:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102305:	8d 50 07             	lea    0x7(%rax),%edx
ffff800000102308:	85 c0                	test   %eax,%eax
ffff80000010230a:	0f 48 c2             	cmovs  %edx,%eax
ffff80000010230d:	c1 f8 03             	sar    $0x3,%eax
ffff800000102310:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000102314:	48 98                	cltq
ffff800000102316:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff80000010231d:	00 
ffff80000010231e:	0f b6 c0             	movzbl %al,%eax
ffff800000102321:	23 45 ec             	and    -0x14(%rbp),%eax
ffff800000102324:	85 c0                	test   %eax,%eax
ffff800000102326:	0f 85 82 00 00 00    	jne    ffff8000001023ae <balloc+0x11c>
        bp->data[bi/8] |= m;  // Mark block in use.
ffff80000010232c:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010232f:	8d 50 07             	lea    0x7(%rax),%edx
ffff800000102332:	85 c0                	test   %eax,%eax
ffff800000102334:	0f 48 c2             	cmovs  %edx,%eax
ffff800000102337:	c1 f8 03             	sar    $0x3,%eax
ffff80000010233a:	89 c1                	mov    %eax,%ecx
ffff80000010233c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000102340:	48 63 c1             	movslq %ecx,%rax
ffff800000102343:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff80000010234a:	00 
ffff80000010234b:	89 c2                	mov    %eax,%edx
ffff80000010234d:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102350:	09 d0                	or     %edx,%eax
ffff800000102352:	89 c6                	mov    %eax,%esi
ffff800000102354:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000102358:	48 63 c1             	movslq %ecx,%rax
ffff80000010235b:	40 88 b4 02 b0 00 00 	mov    %sil,0xb0(%rdx,%rax,1)
ffff800000102362:	00 
        log_write(bp);
ffff800000102363:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102367:	48 89 c7             	mov    %rax,%rdi
ffff80000010236a:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff800000102371:	80 ff ff 
ffff800000102374:	ff d0                	call   *%rax
        brelse(bp);
ffff800000102376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010237a:	48 89 c7             	mov    %rax,%rdi
ffff80000010237d:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000102384:	80 ff ff 
ffff800000102387:	ff d0                	call   *%rax
        bzero(dev, b + bi);
ffff800000102389:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010238c:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010238f:	01 c2                	add    %eax,%edx
ffff800000102391:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000102394:	89 d6                	mov    %edx,%esi
ffff800000102396:	89 c7                	mov    %eax,%edi
ffff800000102398:	48 b8 1e 22 10 00 00 	movabs $0xffff80000010221e,%rax
ffff80000010239f:	80 ff ff 
ffff8000001023a2:	ff d0                	call   *%rax
        return b + bi;
ffff8000001023a4:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001023a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001023aa:	01 d0                	add    %edx,%eax
ffff8000001023ac:	eb 75                	jmp    ffff800000102423 <balloc+0x191>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
ffff8000001023ae:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff8000001023b2:	81 7d f8 ff 0f 00 00 	cmpl   $0xfff,-0x8(%rbp)
ffff8000001023b9:	7f 1e                	jg     ffff8000001023d9 <balloc+0x147>
ffff8000001023bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001023be:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001023c1:	01 d0                	add    %edx,%eax
ffff8000001023c3:	89 c2                	mov    %eax,%edx
ffff8000001023c5:	48 b8 00 56 11 00 00 	movabs $0xffff800000115600,%rax
ffff8000001023cc:	80 ff ff 
ffff8000001023cf:	8b 00                	mov    (%rax),%eax
ffff8000001023d1:	39 c2                	cmp    %eax,%edx
ffff8000001023d3:	0f 82 15 ff ff ff    	jb     ffff8000001022ee <balloc+0x5c>
      }
    }
    brelse(bp);
ffff8000001023d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001023dd:	48 89 c7             	mov    %rax,%rdi
ffff8000001023e0:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001023e7:	80 ff ff 
ffff8000001023ea:	ff d0                	call   *%rax
  for(b = 0; b < sb.size; b += BPB){
ffff8000001023ec:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
ffff8000001023f3:	48 b8 00 56 11 00 00 	movabs $0xffff800000115600,%rax
ffff8000001023fa:	80 ff ff 
ffff8000001023fd:	8b 00                	mov    (%rax),%eax
ffff8000001023ff:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102402:	39 c2                	cmp    %eax,%edx
ffff800000102404:	0f 82 9f fe ff ff    	jb     ffff8000001022a9 <balloc+0x17>
  }
  panic("balloc: out of blocks");
ffff80000010240a:	48 b8 5d c7 10 00 00 	movabs $0xffff80000010c75d,%rax
ffff800000102411:	80 ff ff 
ffff800000102414:	48 89 c7             	mov    %rax,%rdi
ffff800000102417:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010241e:	80 ff ff 
ffff800000102421:	ff d0                	call   *%rax
}
ffff800000102423:	c9                   	leave
ffff800000102424:	c3                   	ret

ffff800000102425 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
ffff800000102425:	55                   	push   %rbp
ffff800000102426:	48 89 e5             	mov    %rsp,%rbp
ffff800000102429:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010242d:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000102430:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int bi, m;

  readsb(dev, &sb);
ffff800000102433:	48 ba 00 56 11 00 00 	movabs $0xffff800000115600,%rdx
ffff80000010243a:	80 ff ff 
ffff80000010243d:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102440:	48 89 d6             	mov    %rdx,%rsi
ffff800000102443:	89 c7                	mov    %eax,%edi
ffff800000102445:	48 b8 b9 21 10 00 00 	movabs $0xffff8000001021b9,%rax
ffff80000010244c:	80 ff ff 
ffff80000010244f:	ff d0                	call   *%rax
  struct buf *bp = bread(dev, BBLOCK(b, sb));
ffff800000102451:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000102454:	c1 e8 0c             	shr    $0xc,%eax
ffff800000102457:	89 c2                	mov    %eax,%edx
ffff800000102459:	48 b8 00 56 11 00 00 	movabs $0xffff800000115600,%rax
ffff800000102460:	80 ff ff 
ffff800000102463:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000102466:	01 c2                	add    %eax,%edx
ffff800000102468:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010246b:	89 d6                	mov    %edx,%esi
ffff80000010246d:	89 c7                	mov    %eax,%edi
ffff80000010246f:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000102476:	80 ff ff 
ffff800000102479:	ff d0                	call   *%rax
ffff80000010247b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  bi = b % BPB;
ffff80000010247f:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000102482:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff800000102487:	89 45 f4             	mov    %eax,-0xc(%rbp)
  m = 1 << (bi % 8);
ffff80000010248a:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010248d:	83 e0 07             	and    $0x7,%eax
ffff800000102490:	ba 01 00 00 00       	mov    $0x1,%edx
ffff800000102495:	89 c1                	mov    %eax,%ecx
ffff800000102497:	d3 e2                	shl    %cl,%edx
ffff800000102499:	89 d0                	mov    %edx,%eax
ffff80000010249b:	89 45 f0             	mov    %eax,-0x10(%rbp)
  if((bp->data[bi/8] & m) == 0)
ffff80000010249e:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001024a1:	8d 50 07             	lea    0x7(%rax),%edx
ffff8000001024a4:	85 c0                	test   %eax,%eax
ffff8000001024a6:	0f 48 c2             	cmovs  %edx,%eax
ffff8000001024a9:	c1 f8 03             	sar    $0x3,%eax
ffff8000001024ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001024b0:	48 98                	cltq
ffff8000001024b2:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff8000001024b9:	00 
ffff8000001024ba:	0f b6 c0             	movzbl %al,%eax
ffff8000001024bd:	23 45 f0             	and    -0x10(%rbp),%eax
ffff8000001024c0:	85 c0                	test   %eax,%eax
ffff8000001024c2:	75 19                	jne    ffff8000001024dd <bfree+0xb8>
    panic("freeing free block");
ffff8000001024c4:	48 b8 73 c7 10 00 00 	movabs $0xffff80000010c773,%rax
ffff8000001024cb:	80 ff ff 
ffff8000001024ce:	48 89 c7             	mov    %rax,%rdi
ffff8000001024d1:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001024d8:	80 ff ff 
ffff8000001024db:	ff d0                	call   *%rax
  bp->data[bi/8] &= ~m;
ffff8000001024dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001024e0:	8d 50 07             	lea    0x7(%rax),%edx
ffff8000001024e3:	85 c0                	test   %eax,%eax
ffff8000001024e5:	0f 48 c2             	cmovs  %edx,%eax
ffff8000001024e8:	c1 f8 03             	sar    $0x3,%eax
ffff8000001024eb:	89 c1                	mov    %eax,%ecx
ffff8000001024ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001024f1:	48 63 c1             	movslq %ecx,%rax
ffff8000001024f4:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff8000001024fb:	00 
ffff8000001024fc:	89 c2                	mov    %eax,%edx
ffff8000001024fe:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102501:	f7 d0                	not    %eax
ffff800000102503:	21 d0                	and    %edx,%eax
ffff800000102505:	89 c6                	mov    %eax,%esi
ffff800000102507:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010250b:	48 63 c1             	movslq %ecx,%rax
ffff80000010250e:	40 88 b4 02 b0 00 00 	mov    %sil,0xb0(%rdx,%rax,1)
ffff800000102515:	00 
  log_write(bp);
ffff800000102516:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010251a:	48 89 c7             	mov    %rax,%rdi
ffff80000010251d:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff800000102524:	80 ff ff 
ffff800000102527:	ff d0                	call   *%rax
  brelse(bp);
ffff800000102529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010252d:	48 89 c7             	mov    %rax,%rdi
ffff800000102530:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000102537:	80 ff ff 
ffff80000010253a:	ff d0                	call   *%rax
}
ffff80000010253c:	90                   	nop
ffff80000010253d:	c9                   	leave
ffff80000010253e:	c3                   	ret

ffff80000010253f <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
ffff80000010253f:	55                   	push   %rbp
ffff800000102540:	48 89 e5             	mov    %rsp,%rbp
ffff800000102543:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102547:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i = 0;
ffff80000010254a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  initlock(&icache.lock, "icache");
ffff800000102551:	48 ba 86 c7 10 00 00 	movabs $0xffff80000010c786,%rdx
ffff800000102558:	80 ff ff 
ffff80000010255b:	48 b8 20 56 11 00 00 	movabs $0xffff800000115620,%rax
ffff800000102562:	80 ff ff 
ffff800000102565:	48 89 d6             	mov    %rdx,%rsi
ffff800000102568:	48 89 c7             	mov    %rax,%rdi
ffff80000010256b:	48 b8 a5 76 10 00 00 	movabs $0xffff8000001076a5,%rax
ffff800000102572:	80 ff ff 
ffff800000102575:	ff d0                	call   *%rax
  for(i = 0; i < NINODE; i++) {
ffff800000102577:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010257e:	eb 41                	jmp    ffff8000001025c1 <iinit+0x82>
    initsleeplock(&icache.inode[i].lock, "inode");
ffff800000102580:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102583:	48 98                	cltq
ffff800000102585:	48 69 c0 d8 00 00 00 	imul   $0xd8,%rax,%rax
ffff80000010258c:	48 8d 50 70          	lea    0x70(%rax),%rdx
ffff800000102590:	48 b8 20 56 11 00 00 	movabs $0xffff800000115620,%rax
ffff800000102597:	80 ff ff 
ffff80000010259a:	48 01 d0             	add    %rdx,%rax
ffff80000010259d:	48 83 c0 08          	add    $0x8,%rax
ffff8000001025a1:	48 ba 8d c7 10 00 00 	movabs $0xffff80000010c78d,%rdx
ffff8000001025a8:	80 ff ff 
ffff8000001025ab:	48 89 d6             	mov    %rdx,%rsi
ffff8000001025ae:	48 89 c7             	mov    %rax,%rdi
ffff8000001025b1:	48 b8 cf 74 10 00 00 	movabs $0xffff8000001074cf,%rax
ffff8000001025b8:	80 ff ff 
ffff8000001025bb:	ff d0                	call   *%rax
  for(i = 0; i < NINODE; i++) {
ffff8000001025bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001025c1:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
ffff8000001025c5:	7e b9                	jle    ffff800000102580 <iinit+0x41>
  }

  readsb(dev, &sb);
ffff8000001025c7:	48 ba 00 56 11 00 00 	movabs $0xffff800000115600,%rdx
ffff8000001025ce:	80 ff ff 
ffff8000001025d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001025d4:	48 89 d6             	mov    %rdx,%rsi
ffff8000001025d7:	89 c7                	mov    %eax,%edi
ffff8000001025d9:	48 b8 b9 21 10 00 00 	movabs $0xffff8000001021b9,%rax
ffff8000001025e0:	80 ff ff 
ffff8000001025e3:	ff d0                	call   *%rax
  /*cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);*/
}
ffff8000001025e5:	90                   	nop
ffff8000001025e6:	c9                   	leave
ffff8000001025e7:	c3                   	ret

ffff8000001025e8 <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
ffff8000001025e8:	55                   	push   %rbp
ffff8000001025e9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001025ec:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001025f0:	89 7d dc             	mov    %edi,-0x24(%rbp)
ffff8000001025f3:	89 f0                	mov    %esi,%eax
ffff8000001025f5:	66 89 45 d8          	mov    %ax,-0x28(%rbp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
ffff8000001025f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
ffff800000102600:	e9 d8 00 00 00       	jmp    ffff8000001026dd <ialloc+0xf5>
    bp = bread(dev, IBLOCK(inum, sb));
ffff800000102605:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102608:	48 98                	cltq
ffff80000010260a:	48 c1 e8 03          	shr    $0x3,%rax
ffff80000010260e:	89 c2                	mov    %eax,%edx
ffff800000102610:	48 b8 00 56 11 00 00 	movabs $0xffff800000115600,%rax
ffff800000102617:	80 ff ff 
ffff80000010261a:	8b 40 14             	mov    0x14(%rax),%eax
ffff80000010261d:	01 c2                	add    %eax,%edx
ffff80000010261f:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000102622:	89 d6                	mov    %edx,%esi
ffff800000102624:	89 c7                	mov    %eax,%edi
ffff800000102626:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff80000010262d:	80 ff ff 
ffff800000102630:	ff d0                	call   *%rax
ffff800000102632:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    dip = (struct dinode*)bp->data + inum%IPB;
ffff800000102636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010263a:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff800000102641:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102644:	48 98                	cltq
ffff800000102646:	83 e0 07             	and    $0x7,%eax
ffff800000102649:	48 c1 e0 06          	shl    $0x6,%rax
ffff80000010264d:	48 01 d0             	add    %rdx,%rax
ffff800000102650:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(dip->type == 0){  // a free inode
ffff800000102654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102658:	0f b7 00             	movzwl (%rax),%eax
ffff80000010265b:	66 85 c0             	test   %ax,%ax
ffff80000010265e:	75 66                	jne    ffff8000001026c6 <ialloc+0xde>
      memset(dip, 0, sizeof(*dip));
ffff800000102660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102664:	ba 40 00 00 00       	mov    $0x40,%edx
ffff800000102669:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010266e:	48 89 c7             	mov    %rax,%rdi
ffff800000102671:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff800000102678:	80 ff ff 
ffff80000010267b:	ff d0                	call   *%rax
      dip->type = type;
ffff80000010267d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102681:	0f b7 55 d8          	movzwl -0x28(%rbp),%edx
ffff800000102685:	66 89 10             	mov    %dx,(%rax)
      log_write(bp);   // mark it allocated on the disk
ffff800000102688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010268c:	48 89 c7             	mov    %rax,%rdi
ffff80000010268f:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff800000102696:	80 ff ff 
ffff800000102699:	ff d0                	call   *%rax
      brelse(bp);
ffff80000010269b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010269f:	48 89 c7             	mov    %rax,%rdi
ffff8000001026a2:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001026a9:	80 ff ff 
ffff8000001026ac:	ff d0                	call   *%rax
      return iget(dev, inum);
ffff8000001026ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001026b1:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001026b4:	89 d6                	mov    %edx,%esi
ffff8000001026b6:	89 c7                	mov    %eax,%edi
ffff8000001026b8:	48 b8 22 28 10 00 00 	movabs $0xffff800000102822,%rax
ffff8000001026bf:	80 ff ff 
ffff8000001026c2:	ff d0                	call   *%rax
ffff8000001026c4:	eb 48                	jmp    ffff80000010270e <ialloc+0x126>
    }
    brelse(bp);
ffff8000001026c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026ca:	48 89 c7             	mov    %rax,%rdi
ffff8000001026cd:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001026d4:	80 ff ff 
ffff8000001026d7:	ff d0                	call   *%rax
  for(inum = 1; inum < sb.ninodes; inum++){
ffff8000001026d9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001026dd:	48 b8 00 56 11 00 00 	movabs $0xffff800000115600,%rax
ffff8000001026e4:	80 ff ff 
ffff8000001026e7:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001026ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001026ed:	39 c2                	cmp    %eax,%edx
ffff8000001026ef:	0f 82 10 ff ff ff    	jb     ffff800000102605 <ialloc+0x1d>
  }
  panic("ialloc: no inodes");
ffff8000001026f5:	48 b8 93 c7 10 00 00 	movabs $0xffff80000010c793,%rax
ffff8000001026fc:	80 ff ff 
ffff8000001026ff:	48 89 c7             	mov    %rax,%rdi
ffff800000102702:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000102709:	80 ff ff 
ffff80000010270c:	ff d0                	call   *%rax
}
ffff80000010270e:	c9                   	leave
ffff80000010270f:	c3                   	ret

ffff800000102710 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
ffff800000102710:	55                   	push   %rbp
ffff800000102711:	48 89 e5             	mov    %rsp,%rbp
ffff800000102714:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102718:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
ffff80000010271c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102720:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102723:	c1 e8 03             	shr    $0x3,%eax
ffff800000102726:	89 c2                	mov    %eax,%edx
ffff800000102728:	48 b8 00 56 11 00 00 	movabs $0xffff800000115600,%rax
ffff80000010272f:	80 ff ff 
ffff800000102732:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000102735:	01 c2                	add    %eax,%edx
ffff800000102737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010273b:	8b 00                	mov    (%rax),%eax
ffff80000010273d:	89 d6                	mov    %edx,%esi
ffff80000010273f:	89 c7                	mov    %eax,%edi
ffff800000102741:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000102748:	80 ff ff 
ffff80000010274b:	ff d0                	call   *%rax
ffff80000010274d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
ffff800000102751:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102755:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010275c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102760:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102763:	89 c0                	mov    %eax,%eax
ffff800000102765:	83 e0 07             	and    $0x7,%eax
ffff800000102768:	48 c1 e0 06          	shl    $0x6,%rax
ffff80000010276c:	48 01 d0             	add    %rdx,%rax
ffff80000010276f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  dip->type = ip->type;
ffff800000102773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102777:	0f b7 90 94 00 00 00 	movzwl 0x94(%rax),%edx
ffff80000010277e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102782:	66 89 10             	mov    %dx,(%rax)
  dip->major = ip->major;
ffff800000102785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102789:	0f b7 90 96 00 00 00 	movzwl 0x96(%rax),%edx
ffff800000102790:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102794:	66 89 50 02          	mov    %dx,0x2(%rax)
  dip->minor = ip->minor;
ffff800000102798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010279c:	0f b7 90 98 00 00 00 	movzwl 0x98(%rax),%edx
ffff8000001027a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001027a7:	66 89 50 04          	mov    %dx,0x4(%rax)
  dip->nlink = ip->nlink;
ffff8000001027ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001027af:	0f b7 90 9a 00 00 00 	movzwl 0x9a(%rax),%edx
ffff8000001027b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001027ba:	66 89 50 06          	mov    %dx,0x6(%rax)
  dip->size = ip->size;
ffff8000001027be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001027c2:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff8000001027c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001027cc:	89 50 08             	mov    %edx,0x8(%rax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
ffff8000001027cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001027d3:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
ffff8000001027da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001027de:	48 83 c0 0c          	add    $0xc,%rax
ffff8000001027e2:	ba 34 00 00 00       	mov    $0x34,%edx
ffff8000001027e7:	48 89 ce             	mov    %rcx,%rsi
ffff8000001027ea:	48 89 c7             	mov    %rax,%rdi
ffff8000001027ed:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff8000001027f4:	80 ff ff 
ffff8000001027f7:	ff d0                	call   *%rax
  log_write(bp);
ffff8000001027f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027fd:	48 89 c7             	mov    %rax,%rdi
ffff800000102800:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff800000102807:	80 ff ff 
ffff80000010280a:	ff d0                	call   *%rax
  brelse(bp);
ffff80000010280c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102810:	48 89 c7             	mov    %rax,%rdi
ffff800000102813:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff80000010281a:	80 ff ff 
ffff80000010281d:	ff d0                	call   *%rax
}
ffff80000010281f:	90                   	nop
ffff800000102820:	c9                   	leave
ffff800000102821:	c3                   	ret

ffff800000102822 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
ffff800000102822:	55                   	push   %rbp
ffff800000102823:	48 89 e5             	mov    %rsp,%rbp
ffff800000102826:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010282a:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010282d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
ffff800000102830:	48 b8 20 56 11 00 00 	movabs $0xffff800000115620,%rax
ffff800000102837:	80 ff ff 
ffff80000010283a:	48 89 c7             	mov    %rax,%rdi
ffff80000010283d:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000102844:	80 ff ff 
ffff800000102847:	ff d0                	call   *%rax

  // Is the inode already cached?
  empty = 0;
ffff800000102849:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffff800000102850:	00 
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
ffff800000102851:	48 b8 88 56 11 00 00 	movabs $0xffff800000115688,%rax
ffff800000102858:	80 ff ff 
ffff80000010285b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010285f:	eb 77                	jmp    ffff8000001028d8 <iget+0xb6>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
ffff800000102861:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102865:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102868:	85 c0                	test   %eax,%eax
ffff80000010286a:	7e 4a                	jle    ffff8000001028b6 <iget+0x94>
ffff80000010286c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102870:	8b 00                	mov    (%rax),%eax
ffff800000102872:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000102875:	75 3f                	jne    ffff8000001028b6 <iget+0x94>
ffff800000102877:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010287b:	8b 40 04             	mov    0x4(%rax),%eax
ffff80000010287e:	39 45 e8             	cmp    %eax,-0x18(%rbp)
ffff800000102881:	75 33                	jne    ffff8000001028b6 <iget+0x94>
      ip->ref++;
ffff800000102883:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102887:	8b 40 08             	mov    0x8(%rax),%eax
ffff80000010288a:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010288d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102891:	89 50 08             	mov    %edx,0x8(%rax)
      release(&icache.lock);
ffff800000102894:	48 b8 20 56 11 00 00 	movabs $0xffff800000115620,%rax
ffff80000010289b:	80 ff ff 
ffff80000010289e:	48 89 c7             	mov    %rax,%rdi
ffff8000001028a1:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001028a8:	80 ff ff 
ffff8000001028ab:	ff d0                	call   *%rax
      return ip;
ffff8000001028ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001028b1:	e9 a7 00 00 00       	jmp    ffff80000010295d <iget+0x13b>
    }
    if(empty == 0 && ip->ref == 0) // Remember empty slot.
ffff8000001028b6:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001028bb:	75 13                	jne    ffff8000001028d0 <iget+0xae>
ffff8000001028bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001028c1:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001028c4:	85 c0                	test   %eax,%eax
ffff8000001028c6:	75 08                	jne    ffff8000001028d0 <iget+0xae>
      empty = ip;
ffff8000001028c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001028cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
ffff8000001028d0:	48 81 45 f8 d8 00 00 	addq   $0xd8,-0x8(%rbp)
ffff8000001028d7:	00 
ffff8000001028d8:	48 b8 b8 80 11 00 00 	movabs $0xffff8000001180b8,%rax
ffff8000001028df:	80 ff ff 
ffff8000001028e2:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001028e6:	0f 82 75 ff ff ff    	jb     ffff800000102861 <iget+0x3f>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
ffff8000001028ec:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001028f1:	75 19                	jne    ffff80000010290c <iget+0xea>
    panic("iget: no inodes");
ffff8000001028f3:	48 b8 a5 c7 10 00 00 	movabs $0xffff80000010c7a5,%rax
ffff8000001028fa:	80 ff ff 
ffff8000001028fd:	48 89 c7             	mov    %rax,%rdi
ffff800000102900:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000102907:	80 ff ff 
ffff80000010290a:	ff d0                	call   *%rax

  ip = empty;
ffff80000010290c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102910:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ip->dev = dev;
ffff800000102914:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102918:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff80000010291b:	89 10                	mov    %edx,(%rax)
  ip->inum = inum;
ffff80000010291d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102921:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000102924:	89 50 04             	mov    %edx,0x4(%rax)
  ip->ref = 1;
ffff800000102927:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010292b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
  ip->flags = 0;
ffff800000102932:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102936:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%rax)
ffff80000010293d:	00 00 00 
  release(&icache.lock);
ffff800000102940:	48 b8 20 56 11 00 00 	movabs $0xffff800000115620,%rax
ffff800000102947:	80 ff ff 
ffff80000010294a:	48 89 c7             	mov    %rax,%rdi
ffff80000010294d:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000102954:	80 ff ff 
ffff800000102957:	ff d0                	call   *%rax

  return ip;
ffff800000102959:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010295d:	c9                   	leave
ffff80000010295e:	c3                   	ret

ffff80000010295f <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
ffff80000010295f:	55                   	push   %rbp
ffff800000102960:	48 89 e5             	mov    %rsp,%rbp
ffff800000102963:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102967:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&icache.lock);
ffff80000010296b:	48 b8 20 56 11 00 00 	movabs $0xffff800000115620,%rax
ffff800000102972:	80 ff ff 
ffff800000102975:	48 89 c7             	mov    %rax,%rdi
ffff800000102978:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff80000010297f:	80 ff ff 
ffff800000102982:	ff d0                	call   *%rax
  ip->ref++;
ffff800000102984:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102988:	8b 40 08             	mov    0x8(%rax),%eax
ffff80000010298b:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010298e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102992:	89 50 08             	mov    %edx,0x8(%rax)
  release(&icache.lock);
ffff800000102995:	48 b8 20 56 11 00 00 	movabs $0xffff800000115620,%rax
ffff80000010299c:	80 ff ff 
ffff80000010299f:	48 89 c7             	mov    %rax,%rdi
ffff8000001029a2:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001029a9:	80 ff ff 
ffff8000001029ac:	ff d0                	call   *%rax
  return ip;
ffff8000001029ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001029b2:	c9                   	leave
ffff8000001029b3:	c3                   	ret

ffff8000001029b4 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
ffff8000001029b4:	55                   	push   %rbp
ffff8000001029b5:	48 89 e5             	mov    %rsp,%rbp
ffff8000001029b8:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001029bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
ffff8000001029c0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001029c5:	74 0b                	je     ffff8000001029d2 <ilock+0x1e>
ffff8000001029c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029cb:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001029ce:	85 c0                	test   %eax,%eax
ffff8000001029d0:	7f 19                	jg     ffff8000001029eb <ilock+0x37>
    panic("ilock");
ffff8000001029d2:	48 b8 b5 c7 10 00 00 	movabs $0xffff80000010c7b5,%rax
ffff8000001029d9:	80 ff ff 
ffff8000001029dc:	48 89 c7             	mov    %rax,%rdi
ffff8000001029df:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001029e6:	80 ff ff 
ffff8000001029e9:	ff d0                	call   *%rax

  acquiresleep(&ip->lock);
ffff8000001029eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029ef:	48 83 c0 10          	add    $0x10,%rax
ffff8000001029f3:	48 89 c7             	mov    %rax,%rdi
ffff8000001029f6:	48 b8 27 75 10 00 00 	movabs $0xffff800000107527,%rax
ffff8000001029fd:	80 ff ff 
ffff800000102a00:	ff d0                	call   *%rax

  if(!(ip->flags & I_VALID)){
ffff800000102a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a06:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102a0c:	83 e0 02             	and    $0x2,%eax
ffff800000102a0f:	85 c0                	test   %eax,%eax
ffff800000102a11:	0f 85 31 01 00 00    	jne    ffff800000102b48 <ilock+0x194>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
ffff800000102a17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a1b:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102a1e:	c1 e8 03             	shr    $0x3,%eax
ffff800000102a21:	89 c2                	mov    %eax,%edx
ffff800000102a23:	48 b8 00 56 11 00 00 	movabs $0xffff800000115600,%rax
ffff800000102a2a:	80 ff ff 
ffff800000102a2d:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000102a30:	01 c2                	add    %eax,%edx
ffff800000102a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a36:	8b 00                	mov    (%rax),%eax
ffff800000102a38:	89 d6                	mov    %edx,%esi
ffff800000102a3a:	89 c7                	mov    %eax,%edi
ffff800000102a3c:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000102a43:	80 ff ff 
ffff800000102a46:	ff d0                	call   *%rax
ffff800000102a48:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
ffff800000102a4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102a50:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff800000102a57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a5b:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102a5e:	89 c0                	mov    %eax,%eax
ffff800000102a60:	83 e0 07             	and    $0x7,%eax
ffff800000102a63:	48 c1 e0 06          	shl    $0x6,%rax
ffff800000102a67:	48 01 d0             	add    %rdx,%rax
ffff800000102a6a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    ip->type = dip->type;
ffff800000102a6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102a72:	0f b7 10             	movzwl (%rax),%edx
ffff800000102a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a79:	66 89 90 94 00 00 00 	mov    %dx,0x94(%rax)
    ip->major = dip->major;
ffff800000102a80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102a84:	0f b7 50 02          	movzwl 0x2(%rax),%edx
ffff800000102a88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a8c:	66 89 90 96 00 00 00 	mov    %dx,0x96(%rax)
    ip->minor = dip->minor;
ffff800000102a93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102a97:	0f b7 50 04          	movzwl 0x4(%rax),%edx
ffff800000102a9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a9f:	66 89 90 98 00 00 00 	mov    %dx,0x98(%rax)
    ip->nlink = dip->nlink;
ffff800000102aa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102aaa:	0f b7 50 06          	movzwl 0x6(%rax),%edx
ffff800000102aae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102ab2:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    ip->size = dip->size;
ffff800000102ab9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102abd:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000102ac0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102ac4:	89 90 9c 00 00 00    	mov    %edx,0x9c(%rax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
ffff800000102aca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102ace:	48 8d 48 0c          	lea    0xc(%rax),%rcx
ffff800000102ad2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102ad6:	48 05 a0 00 00 00    	add    $0xa0,%rax
ffff800000102adc:	ba 34 00 00 00       	mov    $0x34,%edx
ffff800000102ae1:	48 89 ce             	mov    %rcx,%rsi
ffff800000102ae4:	48 89 c7             	mov    %rax,%rdi
ffff800000102ae7:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff800000102aee:	80 ff ff 
ffff800000102af1:	ff d0                	call   *%rax
    brelse(bp);
ffff800000102af3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102af7:	48 89 c7             	mov    %rax,%rdi
ffff800000102afa:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000102b01:	80 ff ff 
ffff800000102b04:	ff d0                	call   *%rax
    ip->flags |= I_VALID;
ffff800000102b06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102b0a:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102b10:	83 c8 02             	or     $0x2,%eax
ffff800000102b13:	89 c2                	mov    %eax,%edx
ffff800000102b15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102b19:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
    if(ip->type == 0)
ffff800000102b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102b23:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000102b2a:	66 85 c0             	test   %ax,%ax
ffff800000102b2d:	75 19                	jne    ffff800000102b48 <ilock+0x194>
      panic("ilock: no type");
ffff800000102b2f:	48 b8 bb c7 10 00 00 	movabs $0xffff80000010c7bb,%rax
ffff800000102b36:	80 ff ff 
ffff800000102b39:	48 89 c7             	mov    %rax,%rdi
ffff800000102b3c:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000102b43:	80 ff ff 
ffff800000102b46:	ff d0                	call   *%rax
  }
}
ffff800000102b48:	90                   	nop
ffff800000102b49:	c9                   	leave
ffff800000102b4a:	c3                   	ret

ffff800000102b4b <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
ffff800000102b4b:	55                   	push   %rbp
ffff800000102b4c:	48 89 e5             	mov    %rsp,%rbp
ffff800000102b4f:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102b53:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
ffff800000102b57:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000102b5c:	74 26                	je     ffff800000102b84 <iunlock+0x39>
ffff800000102b5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b62:	48 83 c0 10          	add    $0x10,%rax
ffff800000102b66:	48 89 c7             	mov    %rax,%rdi
ffff800000102b69:	48 b8 12 76 10 00 00 	movabs $0xffff800000107612,%rax
ffff800000102b70:	80 ff ff 
ffff800000102b73:	ff d0                	call   *%rax
ffff800000102b75:	85 c0                	test   %eax,%eax
ffff800000102b77:	74 0b                	je     ffff800000102b84 <iunlock+0x39>
ffff800000102b79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b7d:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102b80:	85 c0                	test   %eax,%eax
ffff800000102b82:	7f 19                	jg     ffff800000102b9d <iunlock+0x52>
    panic("iunlock");
ffff800000102b84:	48 b8 ca c7 10 00 00 	movabs $0xffff80000010c7ca,%rax
ffff800000102b8b:	80 ff ff 
ffff800000102b8e:	48 89 c7             	mov    %rax,%rdi
ffff800000102b91:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000102b98:	80 ff ff 
ffff800000102b9b:	ff d0                	call   *%rax

  releasesleep(&ip->lock);
ffff800000102b9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ba1:	48 83 c0 10          	add    $0x10,%rax
ffff800000102ba5:	48 89 c7             	mov    %rax,%rdi
ffff800000102ba8:	48 b8 ad 75 10 00 00 	movabs $0xffff8000001075ad,%rax
ffff800000102baf:	80 ff ff 
ffff800000102bb2:	ff d0                	call   *%rax
}
ffff800000102bb4:	90                   	nop
ffff800000102bb5:	c9                   	leave
ffff800000102bb6:	c3                   	ret

ffff800000102bb7 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
ffff800000102bb7:	55                   	push   %rbp
ffff800000102bb8:	48 89 e5             	mov    %rsp,%rbp
ffff800000102bbb:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102bbf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&icache.lock);
ffff800000102bc3:	48 b8 20 56 11 00 00 	movabs $0xffff800000115620,%rax
ffff800000102bca:	80 ff ff 
ffff800000102bcd:	48 89 c7             	mov    %rax,%rdi
ffff800000102bd0:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000102bd7:	80 ff ff 
ffff800000102bda:	ff d0                	call   *%rax
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
ffff800000102bdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102be0:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102be3:	83 f8 01             	cmp    $0x1,%eax
ffff800000102be6:	0f 85 98 00 00 00    	jne    ffff800000102c84 <iput+0xcd>
ffff800000102bec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bf0:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102bf6:	83 e0 02             	and    $0x2,%eax
ffff800000102bf9:	85 c0                	test   %eax,%eax
ffff800000102bfb:	0f 84 83 00 00 00    	je     ffff800000102c84 <iput+0xcd>
ffff800000102c01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102c05:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000102c0c:	66 85 c0             	test   %ax,%ax
ffff800000102c0f:	75 73                	jne    ffff800000102c84 <iput+0xcd>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
ffff800000102c11:	48 b8 20 56 11 00 00 	movabs $0xffff800000115620,%rax
ffff800000102c18:	80 ff ff 
ffff800000102c1b:	48 89 c7             	mov    %rax,%rdi
ffff800000102c1e:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000102c25:	80 ff ff 
ffff800000102c28:	ff d0                	call   *%rax
    itrunc(ip);
ffff800000102c2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102c2e:	48 89 c7             	mov    %rax,%rdi
ffff800000102c31:	48 b8 43 2e 10 00 00 	movabs $0xffff800000102e43,%rax
ffff800000102c38:	80 ff ff 
ffff800000102c3b:	ff d0                	call   *%rax
    ip->type = 0;
ffff800000102c3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102c41:	66 c7 80 94 00 00 00 	movw   $0x0,0x94(%rax)
ffff800000102c48:	00 00 
    iupdate(ip);
ffff800000102c4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102c4e:	48 89 c7             	mov    %rax,%rdi
ffff800000102c51:	48 b8 10 27 10 00 00 	movabs $0xffff800000102710,%rax
ffff800000102c58:	80 ff ff 
ffff800000102c5b:	ff d0                	call   *%rax
    acquire(&icache.lock);
ffff800000102c5d:	48 b8 20 56 11 00 00 	movabs $0xffff800000115620,%rax
ffff800000102c64:	80 ff ff 
ffff800000102c67:	48 89 c7             	mov    %rax,%rdi
ffff800000102c6a:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000102c71:	80 ff ff 
ffff800000102c74:	ff d0                	call   *%rax
    ip->flags = 0;
ffff800000102c76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102c7a:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%rax)
ffff800000102c81:	00 00 00 
  }
  ip->ref--;
ffff800000102c84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102c88:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102c8b:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000102c8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102c92:	89 50 08             	mov    %edx,0x8(%rax)
  release(&icache.lock);
ffff800000102c95:	48 b8 20 56 11 00 00 	movabs $0xffff800000115620,%rax
ffff800000102c9c:	80 ff ff 
ffff800000102c9f:	48 89 c7             	mov    %rax,%rdi
ffff800000102ca2:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000102ca9:	80 ff ff 
ffff800000102cac:	ff d0                	call   *%rax
}
ffff800000102cae:	90                   	nop
ffff800000102caf:	c9                   	leave
ffff800000102cb0:	c3                   	ret

ffff800000102cb1 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
ffff800000102cb1:	55                   	push   %rbp
ffff800000102cb2:	48 89 e5             	mov    %rsp,%rbp
ffff800000102cb5:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102cb9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  iunlock(ip);
ffff800000102cbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102cc1:	48 89 c7             	mov    %rax,%rdi
ffff800000102cc4:	48 b8 4b 2b 10 00 00 	movabs $0xffff800000102b4b,%rax
ffff800000102ccb:	80 ff ff 
ffff800000102cce:	ff d0                	call   *%rax
  iput(ip);
ffff800000102cd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102cd4:	48 89 c7             	mov    %rax,%rdi
ffff800000102cd7:	48 b8 b7 2b 10 00 00 	movabs $0xffff800000102bb7,%rax
ffff800000102cde:	80 ff ff 
ffff800000102ce1:	ff d0                	call   *%rax
}
ffff800000102ce3:	90                   	nop
ffff800000102ce4:	c9                   	leave
ffff800000102ce5:	c3                   	ret

ffff800000102ce6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
ffff800000102ce6:	55                   	push   %rbp
ffff800000102ce7:	48 89 e5             	mov    %rsp,%rbp
ffff800000102cea:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000102cee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000102cf2:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
ffff800000102cf5:	83 7d d4 0b          	cmpl   $0xb,-0x2c(%rbp)
ffff800000102cf9:	77 47                	ja     ffff800000102d42 <bmap+0x5c>
    if((addr = ip->addrs[bn]) == 0)
ffff800000102cfb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102cff:	8b 55 d4             	mov    -0x2c(%rbp),%edx
ffff800000102d02:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102d06:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102d09:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102d0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102d10:	75 28                	jne    ffff800000102d3a <bmap+0x54>
      ip->addrs[bn] = addr = balloc(ip->dev);
ffff800000102d12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d16:	8b 00                	mov    (%rax),%eax
ffff800000102d18:	89 c7                	mov    %eax,%edi
ffff800000102d1a:	48 b8 92 22 10 00 00 	movabs $0xffff800000102292,%rax
ffff800000102d21:	80 ff ff 
ffff800000102d24:	ff d0                	call   *%rax
ffff800000102d26:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102d29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d2d:	8b 55 d4             	mov    -0x2c(%rbp),%edx
ffff800000102d30:	48 8d 4a 28          	lea    0x28(%rdx),%rcx
ffff800000102d34:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102d37:	89 14 88             	mov    %edx,(%rax,%rcx,4)
    return addr;
ffff800000102d3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102d3d:	e9 ff 00 00 00       	jmp    ffff800000102e41 <bmap+0x15b>
  }
  bn -= NDIRECT;
ffff800000102d42:	83 6d d4 0c          	subl   $0xc,-0x2c(%rbp)

  if(bn < NINDIRECT){
ffff800000102d46:	83 7d d4 7f          	cmpl   $0x7f,-0x2c(%rbp)
ffff800000102d4a:	0f 87 d8 00 00 00    	ja     ffff800000102e28 <bmap+0x142>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
ffff800000102d50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d54:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102d5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102d5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102d61:	75 24                	jne    ffff800000102d87 <bmap+0xa1>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
ffff800000102d63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d67:	8b 00                	mov    (%rax),%eax
ffff800000102d69:	89 c7                	mov    %eax,%edi
ffff800000102d6b:	48 b8 92 22 10 00 00 	movabs $0xffff800000102292,%rax
ffff800000102d72:	80 ff ff 
ffff800000102d75:	ff d0                	call   *%rax
ffff800000102d77:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102d7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d7e:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102d81:	89 90 d0 00 00 00    	mov    %edx,0xd0(%rax)
    bp = bread(ip->dev, addr);
ffff800000102d87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d8b:	8b 00                	mov    (%rax),%eax
ffff800000102d8d:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102d90:	89 d6                	mov    %edx,%esi
ffff800000102d92:	89 c7                	mov    %eax,%edi
ffff800000102d94:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000102d9b:	80 ff ff 
ffff800000102d9e:	ff d0                	call   *%rax
ffff800000102da0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    a = (uint*)bp->data;
ffff800000102da4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102da8:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102dae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if((addr = a[bn]) == 0){
ffff800000102db2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000102db5:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102dbc:	00 
ffff800000102dbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102dc1:	48 01 d0             	add    %rdx,%rax
ffff800000102dc4:	8b 00                	mov    (%rax),%eax
ffff800000102dc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102dc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102dcd:	75 41                	jne    ffff800000102e10 <bmap+0x12a>
      a[bn] = addr = balloc(ip->dev);
ffff800000102dcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102dd3:	8b 00                	mov    (%rax),%eax
ffff800000102dd5:	89 c7                	mov    %eax,%edi
ffff800000102dd7:	48 b8 92 22 10 00 00 	movabs $0xffff800000102292,%rax
ffff800000102dde:	80 ff ff 
ffff800000102de1:	ff d0                	call   *%rax
ffff800000102de3:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102de6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000102de9:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102df0:	00 
ffff800000102df1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102df5:	48 01 c2             	add    %rax,%rdx
ffff800000102df8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102dfb:	89 02                	mov    %eax,(%rdx)
      log_write(bp);
ffff800000102dfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102e01:	48 89 c7             	mov    %rax,%rdi
ffff800000102e04:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff800000102e0b:	80 ff ff 
ffff800000102e0e:	ff d0                	call   *%rax
    }
    brelse(bp);
ffff800000102e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102e14:	48 89 c7             	mov    %rax,%rdi
ffff800000102e17:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000102e1e:	80 ff ff 
ffff800000102e21:	ff d0                	call   *%rax
    return addr;
ffff800000102e23:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102e26:	eb 19                	jmp    ffff800000102e41 <bmap+0x15b>
  }

  panic("bmap: out of range");
ffff800000102e28:	48 b8 d2 c7 10 00 00 	movabs $0xffff80000010c7d2,%rax
ffff800000102e2f:	80 ff ff 
ffff800000102e32:	48 89 c7             	mov    %rax,%rdi
ffff800000102e35:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000102e3c:	80 ff ff 
ffff800000102e3f:	ff d0                	call   *%rax
}
ffff800000102e41:	c9                   	leave
ffff800000102e42:	c3                   	ret

ffff800000102e43 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
ffff800000102e43:	55                   	push   %rbp
ffff800000102e44:	48 89 e5             	mov    %rsp,%rbp
ffff800000102e47:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000102e4b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
ffff800000102e4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000102e56:	eb 55                	jmp    ffff800000102ead <itrunc+0x6a>
    if(ip->addrs[i]){
ffff800000102e58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e5c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102e5f:	48 63 d2             	movslq %edx,%rdx
ffff800000102e62:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102e66:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102e69:	85 c0                	test   %eax,%eax
ffff800000102e6b:	74 3c                	je     ffff800000102ea9 <itrunc+0x66>
      bfree(ip->dev, ip->addrs[i]);
ffff800000102e6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e71:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102e74:	48 63 d2             	movslq %edx,%rdx
ffff800000102e77:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102e7b:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102e7e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102e82:	8b 12                	mov    (%rdx),%edx
ffff800000102e84:	89 c6                	mov    %eax,%esi
ffff800000102e86:	89 d7                	mov    %edx,%edi
ffff800000102e88:	48 b8 25 24 10 00 00 	movabs $0xffff800000102425,%rax
ffff800000102e8f:	80 ff ff 
ffff800000102e92:	ff d0                	call   *%rax
      ip->addrs[i] = 0;
ffff800000102e94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e98:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102e9b:	48 63 d2             	movslq %edx,%rdx
ffff800000102e9e:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102ea2:	c7 04 90 00 00 00 00 	movl   $0x0,(%rax,%rdx,4)
  for(i = 0; i < NDIRECT; i++){
ffff800000102ea9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000102ead:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
ffff800000102eb1:	7e a5                	jle    ffff800000102e58 <itrunc+0x15>
    }
  }

  if(ip->addrs[NDIRECT]){
ffff800000102eb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102eb7:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102ebd:	85 c0                	test   %eax,%eax
ffff800000102ebf:	0f 84 ce 00 00 00    	je     ffff800000102f93 <itrunc+0x150>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
ffff800000102ec5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102ec9:	8b 90 d0 00 00 00    	mov    0xd0(%rax),%edx
ffff800000102ecf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102ed3:	8b 00                	mov    (%rax),%eax
ffff800000102ed5:	89 d6                	mov    %edx,%esi
ffff800000102ed7:	89 c7                	mov    %eax,%edi
ffff800000102ed9:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000102ee0:	80 ff ff 
ffff800000102ee3:	ff d0                	call   *%rax
ffff800000102ee5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    a = (uint*)bp->data;
ffff800000102ee9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102eed:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102ef3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    for(j = 0; j < NINDIRECT; j++){
ffff800000102ef7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff800000102efe:	eb 4a                	jmp    ffff800000102f4a <itrunc+0x107>
      if(a[j])
ffff800000102f00:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102f03:	48 98                	cltq
ffff800000102f05:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102f0c:	00 
ffff800000102f0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102f11:	48 01 d0             	add    %rdx,%rax
ffff800000102f14:	8b 00                	mov    (%rax),%eax
ffff800000102f16:	85 c0                	test   %eax,%eax
ffff800000102f18:	74 2c                	je     ffff800000102f46 <itrunc+0x103>
        bfree(ip->dev, a[j]);
ffff800000102f1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102f1d:	48 98                	cltq
ffff800000102f1f:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102f26:	00 
ffff800000102f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102f2b:	48 01 d0             	add    %rdx,%rax
ffff800000102f2e:	8b 00                	mov    (%rax),%eax
ffff800000102f30:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102f34:	8b 12                	mov    (%rdx),%edx
ffff800000102f36:	89 c6                	mov    %eax,%esi
ffff800000102f38:	89 d7                	mov    %edx,%edi
ffff800000102f3a:	48 b8 25 24 10 00 00 	movabs $0xffff800000102425,%rax
ffff800000102f41:	80 ff ff 
ffff800000102f44:	ff d0                	call   *%rax
    for(j = 0; j < NINDIRECT; j++){
ffff800000102f46:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff800000102f4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102f4d:	83 f8 7f             	cmp    $0x7f,%eax
ffff800000102f50:	76 ae                	jbe    ffff800000102f00 <itrunc+0xbd>
    }
    brelse(bp);
ffff800000102f52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f56:	48 89 c7             	mov    %rax,%rdi
ffff800000102f59:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000102f60:	80 ff ff 
ffff800000102f63:	ff d0                	call   *%rax
    bfree(ip->dev, ip->addrs[NDIRECT]);
ffff800000102f65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f69:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102f6f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102f73:	8b 12                	mov    (%rdx),%edx
ffff800000102f75:	89 c6                	mov    %eax,%esi
ffff800000102f77:	89 d7                	mov    %edx,%edi
ffff800000102f79:	48 b8 25 24 10 00 00 	movabs $0xffff800000102425,%rax
ffff800000102f80:	80 ff ff 
ffff800000102f83:	ff d0                	call   *%rax
    ip->addrs[NDIRECT] = 0;
ffff800000102f85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f89:	c7 80 d0 00 00 00 00 	movl   $0x0,0xd0(%rax)
ffff800000102f90:	00 00 00 
  }

  ip->size = 0;
ffff800000102f93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f97:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%rax)
ffff800000102f9e:	00 00 00 
  iupdate(ip);
ffff800000102fa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102fa5:	48 89 c7             	mov    %rax,%rdi
ffff800000102fa8:	48 b8 10 27 10 00 00 	movabs $0xffff800000102710,%rax
ffff800000102faf:	80 ff ff 
ffff800000102fb2:	ff d0                	call   *%rax
}
ffff800000102fb4:	90                   	nop
ffff800000102fb5:	c9                   	leave
ffff800000102fb6:	c3                   	ret

ffff800000102fb7 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
ffff800000102fb7:	55                   	push   %rbp
ffff800000102fb8:	48 89 e5             	mov    %rsp,%rbp
ffff800000102fbb:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102fbf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000102fc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  st->dev = ip->dev;
ffff800000102fc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102fcb:	8b 00                	mov    (%rax),%eax
ffff800000102fcd:	89 c2                	mov    %eax,%edx
ffff800000102fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102fd3:	89 50 04             	mov    %edx,0x4(%rax)
  st->ino = ip->inum;
ffff800000102fd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102fda:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000102fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102fe1:	89 50 08             	mov    %edx,0x8(%rax)
  st->type = ip->type;
ffff800000102fe4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102fe8:	0f b7 90 94 00 00 00 	movzwl 0x94(%rax),%edx
ffff800000102fef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102ff3:	66 89 10             	mov    %dx,(%rax)
  st->nlink = ip->nlink;
ffff800000102ff6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ffa:	0f b7 90 9a 00 00 00 	movzwl 0x9a(%rax),%edx
ffff800000103001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000103005:	66 89 50 0c          	mov    %dx,0xc(%rax)
  st->size = ip->size;
ffff800000103009:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010300d:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff800000103013:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000103017:	89 50 10             	mov    %edx,0x10(%rax)
}
ffff80000010301a:	90                   	nop
ffff80000010301b:	c9                   	leave
ffff80000010301c:	c3                   	ret

ffff80000010301d <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
ffff80000010301d:	55                   	push   %rbp
ffff80000010301e:	48 89 e5             	mov    %rsp,%rbp
ffff800000103021:	48 83 ec 40          	sub    $0x40,%rsp
ffff800000103025:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000103029:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010302d:	89 55 cc             	mov    %edx,-0x34(%rbp)
ffff800000103030:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
ffff800000103033:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103037:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff80000010303e:	66 83 f8 03          	cmp    $0x3,%ax
ffff800000103042:	0f 85 8d 00 00 00    	jne    ffff8000001030d5 <readi+0xb8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
ffff800000103048:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010304c:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000103053:	66 85 c0             	test   %ax,%ax
ffff800000103056:	78 38                	js     ffff800000103090 <readi+0x73>
ffff800000103058:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010305c:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000103063:	66 83 f8 09          	cmp    $0x9,%ax
ffff800000103067:	7f 27                	jg     ffff800000103090 <readi+0x73>
ffff800000103069:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010306d:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000103074:	98                   	cwtl
ffff800000103075:	48 ba 40 45 11 00 00 	movabs $0xffff800000114540,%rdx
ffff80000010307c:	80 ff ff 
ffff80000010307f:	48 98                	cltq
ffff800000103081:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000103085:	48 01 d0             	add    %rdx,%rax
ffff800000103088:	48 8b 00             	mov    (%rax),%rax
ffff80000010308b:	48 85 c0             	test   %rax,%rax
ffff80000010308e:	75 0a                	jne    ffff80000010309a <readi+0x7d>
      return -1;
ffff800000103090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000103095:	e9 4e 01 00 00       	jmp    ffff8000001031e8 <readi+0x1cb>
    return devsw[ip->major].read(ip, off, dst, n);
ffff80000010309a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010309e:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff8000001030a5:	98                   	cwtl
ffff8000001030a6:	48 ba 40 45 11 00 00 	movabs $0xffff800000114540,%rdx
ffff8000001030ad:	80 ff ff 
ffff8000001030b0:	48 98                	cltq
ffff8000001030b2:	48 c1 e0 04          	shl    $0x4,%rax
ffff8000001030b6:	48 01 d0             	add    %rdx,%rax
ffff8000001030b9:	4c 8b 00             	mov    (%rax),%r8
ffff8000001030bc:	8b 4d c8             	mov    -0x38(%rbp),%ecx
ffff8000001030bf:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff8000001030c3:	8b 75 cc             	mov    -0x34(%rbp),%esi
ffff8000001030c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001030ca:	48 89 c7             	mov    %rax,%rdi
ffff8000001030cd:	41 ff d0             	call   *%r8
ffff8000001030d0:	e9 13 01 00 00       	jmp    ffff8000001031e8 <readi+0x1cb>
  }

  if(off > ip->size || off + n < off)
ffff8000001030d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001030d9:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff8000001030df:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffff8000001030e2:	72 0d                	jb     ffff8000001030f1 <readi+0xd4>
ffff8000001030e4:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff8000001030e7:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff8000001030ea:	01 d0                	add    %edx,%eax
ffff8000001030ec:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffff8000001030ef:	73 0a                	jae    ffff8000001030fb <readi+0xde>
    return -1;
ffff8000001030f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001030f6:	e9 ed 00 00 00       	jmp    ffff8000001031e8 <readi+0x1cb>
  if(off + n > ip->size)
ffff8000001030fb:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff8000001030fe:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103101:	01 c2                	add    %eax,%edx
ffff800000103103:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103107:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff80000010310d:	39 d0                	cmp    %edx,%eax
ffff80000010310f:	73 10                	jae    ffff800000103121 <readi+0x104>
    n = ip->size - off;
ffff800000103111:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103115:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff80000010311b:	2b 45 cc             	sub    -0x34(%rbp),%eax
ffff80000010311e:	89 45 c8             	mov    %eax,-0x38(%rbp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
ffff800000103121:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103128:	e9 ac 00 00 00       	jmp    ffff8000001031d9 <readi+0x1bc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
ffff80000010312d:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103130:	c1 e8 09             	shr    $0x9,%eax
ffff800000103133:	89 c2                	mov    %eax,%edx
ffff800000103135:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103139:	89 d6                	mov    %edx,%esi
ffff80000010313b:	48 89 c7             	mov    %rax,%rdi
ffff80000010313e:	48 b8 e6 2c 10 00 00 	movabs $0xffff800000102ce6,%rax
ffff800000103145:	80 ff ff 
ffff800000103148:	ff d0                	call   *%rax
ffff80000010314a:	89 c2                	mov    %eax,%edx
ffff80000010314c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103150:	8b 00                	mov    (%rax),%eax
ffff800000103152:	89 d6                	mov    %edx,%esi
ffff800000103154:	89 c7                	mov    %eax,%edi
ffff800000103156:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff80000010315d:	80 ff ff 
ffff800000103160:	ff d0                	call   *%rax
ffff800000103162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    m = min(n - tot, BSIZE - off%BSIZE);
ffff800000103166:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103169:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010316e:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000103173:	29 c2                	sub    %eax,%edx
ffff800000103175:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103178:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010317b:	39 c2                	cmp    %eax,%edx
ffff80000010317d:	0f 46 c2             	cmovbe %edx,%eax
ffff800000103180:	89 45 ec             	mov    %eax,-0x14(%rbp)
    memmove(dst, bp->data + off%BSIZE, m);
ffff800000103183:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000103187:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010318e:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103191:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff800000103196:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010319a:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff80000010319d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001031a1:	48 89 ce             	mov    %rcx,%rsi
ffff8000001031a4:	48 89 c7             	mov    %rax,%rdi
ffff8000001031a7:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff8000001031ae:	80 ff ff 
ffff8000001031b1:	ff d0                	call   *%rax
    brelse(bp);
ffff8000001031b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001031b7:	48 89 c7             	mov    %rax,%rdi
ffff8000001031ba:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001031c1:	80 ff ff 
ffff8000001031c4:	ff d0                	call   *%rax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
ffff8000001031c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001031c9:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff8000001031cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001031cf:	01 45 cc             	add    %eax,-0x34(%rbp)
ffff8000001031d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001031d5:	48 01 45 d0          	add    %rax,-0x30(%rbp)
ffff8000001031d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001031dc:	3b 45 c8             	cmp    -0x38(%rbp),%eax
ffff8000001031df:	0f 82 48 ff ff ff    	jb     ffff80000010312d <readi+0x110>
  }
  return n;
ffff8000001031e5:	8b 45 c8             	mov    -0x38(%rbp),%eax
}
ffff8000001031e8:	c9                   	leave
ffff8000001031e9:	c3                   	ret

ffff8000001031ea <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
ffff8000001031ea:	55                   	push   %rbp
ffff8000001031eb:	48 89 e5             	mov    %rsp,%rbp
ffff8000001031ee:	48 83 ec 40          	sub    $0x40,%rsp
ffff8000001031f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff8000001031f6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff8000001031fa:	89 55 cc             	mov    %edx,-0x34(%rbp)
ffff8000001031fd:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
ffff800000103200:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103204:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff80000010320b:	66 83 f8 03          	cmp    $0x3,%ax
ffff80000010320f:	0f 85 95 00 00 00    	jne    ffff8000001032aa <writei+0xc0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
ffff800000103215:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103219:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000103220:	66 85 c0             	test   %ax,%ax
ffff800000103223:	78 3c                	js     ffff800000103261 <writei+0x77>
ffff800000103225:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103229:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000103230:	66 83 f8 09          	cmp    $0x9,%ax
ffff800000103234:	7f 2b                	jg     ffff800000103261 <writei+0x77>
ffff800000103236:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010323a:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000103241:	98                   	cwtl
ffff800000103242:	48 ba 40 45 11 00 00 	movabs $0xffff800000114540,%rdx
ffff800000103249:	80 ff ff 
ffff80000010324c:	48 98                	cltq
ffff80000010324e:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000103252:	48 01 d0             	add    %rdx,%rax
ffff800000103255:	48 83 c0 08          	add    $0x8,%rax
ffff800000103259:	48 8b 00             	mov    (%rax),%rax
ffff80000010325c:	48 85 c0             	test   %rax,%rax
ffff80000010325f:	75 0a                	jne    ffff80000010326b <writei+0x81>
      return -1;
ffff800000103261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000103266:	e9 8d 01 00 00       	jmp    ffff8000001033f8 <writei+0x20e>
    return devsw[ip->major].write(ip, off, src, n);
ffff80000010326b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010326f:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000103276:	98                   	cwtl
ffff800000103277:	48 ba 40 45 11 00 00 	movabs $0xffff800000114540,%rdx
ffff80000010327e:	80 ff ff 
ffff800000103281:	48 98                	cltq
ffff800000103283:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000103287:	48 01 d0             	add    %rdx,%rax
ffff80000010328a:	48 83 c0 08          	add    $0x8,%rax
ffff80000010328e:	4c 8b 00             	mov    (%rax),%r8
ffff800000103291:	8b 4d c8             	mov    -0x38(%rbp),%ecx
ffff800000103294:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000103298:	8b 75 cc             	mov    -0x34(%rbp),%esi
ffff80000010329b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010329f:	48 89 c7             	mov    %rax,%rdi
ffff8000001032a2:	41 ff d0             	call   *%r8
ffff8000001032a5:	e9 4e 01 00 00       	jmp    ffff8000001033f8 <writei+0x20e>
  }

  if(off > ip->size || off + n < off)
ffff8000001032aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001032ae:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff8000001032b4:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffff8000001032b7:	72 0d                	jb     ffff8000001032c6 <writei+0xdc>
ffff8000001032b9:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff8000001032bc:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff8000001032bf:	01 d0                	add    %edx,%eax
ffff8000001032c1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffff8000001032c4:	73 0a                	jae    ffff8000001032d0 <writei+0xe6>
    return -1;
ffff8000001032c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001032cb:	e9 28 01 00 00       	jmp    ffff8000001033f8 <writei+0x20e>
  if(off + n > MAXFILE*BSIZE)
ffff8000001032d0:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff8000001032d3:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff8000001032d6:	01 d0                	add    %edx,%eax
ffff8000001032d8:	3d 00 18 01 00       	cmp    $0x11800,%eax
ffff8000001032dd:	76 0a                	jbe    ffff8000001032e9 <writei+0xff>
    return -1;
ffff8000001032df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001032e4:	e9 0f 01 00 00       	jmp    ffff8000001033f8 <writei+0x20e>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
ffff8000001032e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001032f0:	e9 bf 00 00 00       	jmp    ffff8000001033b4 <writei+0x1ca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
ffff8000001032f5:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff8000001032f8:	c1 e8 09             	shr    $0x9,%eax
ffff8000001032fb:	89 c2                	mov    %eax,%edx
ffff8000001032fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103301:	89 d6                	mov    %edx,%esi
ffff800000103303:	48 89 c7             	mov    %rax,%rdi
ffff800000103306:	48 b8 e6 2c 10 00 00 	movabs $0xffff800000102ce6,%rax
ffff80000010330d:	80 ff ff 
ffff800000103310:	ff d0                	call   *%rax
ffff800000103312:	89 c2                	mov    %eax,%edx
ffff800000103314:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103318:	8b 00                	mov    (%rax),%eax
ffff80000010331a:	89 d6                	mov    %edx,%esi
ffff80000010331c:	89 c7                	mov    %eax,%edi
ffff80000010331e:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000103325:	80 ff ff 
ffff800000103328:	ff d0                	call   *%rax
ffff80000010332a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    m = min(n - tot, BSIZE - off%BSIZE);
ffff80000010332e:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103331:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff800000103336:	ba 00 02 00 00       	mov    $0x200,%edx
ffff80000010333b:	29 c2                	sub    %eax,%edx
ffff80000010333d:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103340:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000103343:	39 c2                	cmp    %eax,%edx
ffff800000103345:	0f 46 c2             	cmovbe %edx,%eax
ffff800000103348:	89 45 ec             	mov    %eax,-0x14(%rbp)
    memmove(bp->data + off%BSIZE, src, m);
ffff80000010334b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010334f:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff800000103356:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103359:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010335e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff800000103362:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000103365:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000103369:	48 89 c6             	mov    %rax,%rsi
ffff80000010336c:	48 89 cf             	mov    %rcx,%rdi
ffff80000010336f:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff800000103376:	80 ff ff 
ffff800000103379:	ff d0                	call   *%rax
    log_write(bp);
ffff80000010337b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010337f:	48 89 c7             	mov    %rax,%rdi
ffff800000103382:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff800000103389:	80 ff ff 
ffff80000010338c:	ff d0                	call   *%rax
    brelse(bp);
ffff80000010338e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000103392:	48 89 c7             	mov    %rax,%rdi
ffff800000103395:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff80000010339c:	80 ff ff 
ffff80000010339f:	ff d0                	call   *%rax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
ffff8000001033a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001033a4:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff8000001033a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001033aa:	01 45 cc             	add    %eax,-0x34(%rbp)
ffff8000001033ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001033b0:	48 01 45 d0          	add    %rax,-0x30(%rbp)
ffff8000001033b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001033b7:	3b 45 c8             	cmp    -0x38(%rbp),%eax
ffff8000001033ba:	0f 82 35 ff ff ff    	jb     ffff8000001032f5 <writei+0x10b>
  }

  if(n > 0 && off > ip->size){
ffff8000001033c0:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
ffff8000001033c4:	74 2f                	je     ffff8000001033f5 <writei+0x20b>
ffff8000001033c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001033ca:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff8000001033d0:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffff8000001033d3:	73 20                	jae    ffff8000001033f5 <writei+0x20b>
    ip->size = off;
ffff8000001033d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001033d9:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff8000001033dc:	89 90 9c 00 00 00    	mov    %edx,0x9c(%rax)
    iupdate(ip);
ffff8000001033e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001033e6:	48 89 c7             	mov    %rax,%rdi
ffff8000001033e9:	48 b8 10 27 10 00 00 	movabs $0xffff800000102710,%rax
ffff8000001033f0:	80 ff ff 
ffff8000001033f3:	ff d0                	call   *%rax
  }
  return n;
ffff8000001033f5:	8b 45 c8             	mov    -0x38(%rbp),%eax
}
ffff8000001033f8:	c9                   	leave
ffff8000001033f9:	c3                   	ret

ffff8000001033fa <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
ffff8000001033fa:	55                   	push   %rbp
ffff8000001033fb:	48 89 e5             	mov    %rsp,%rbp
ffff8000001033fe:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000103402:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000103406:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return strncmp(s, t, DIRSIZ);
ffff80000010340a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff80000010340e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103412:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff800000103417:	48 89 ce             	mov    %rcx,%rsi
ffff80000010341a:	48 89 c7             	mov    %rax,%rdi
ffff80000010341d:	48 b8 48 7c 10 00 00 	movabs $0xffff800000107c48,%rax
ffff800000103424:	80 ff ff 
ffff800000103427:	ff d0                	call   *%rax
}
ffff800000103429:	c9                   	leave
ffff80000010342a:	c3                   	ret

ffff80000010342b <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
ffff80000010342b:	55                   	push   %rbp
ffff80000010342c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010342f:	48 83 ec 40          	sub    $0x40,%rsp
ffff800000103433:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000103437:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010343b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
ffff80000010343f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103443:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff80000010344a:	66 83 f8 01          	cmp    $0x1,%ax
ffff80000010344e:	74 19                	je     ffff800000103469 <dirlookup+0x3e>
    panic("dirlookup not DIR");
ffff800000103450:	48 b8 e5 c7 10 00 00 	movabs $0xffff80000010c7e5,%rax
ffff800000103457:	80 ff ff 
ffff80000010345a:	48 89 c7             	mov    %rax,%rdi
ffff80000010345d:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103464:	80 ff ff 
ffff800000103467:	ff d0                	call   *%rax

  for(off = 0; off < dp->size; off += sizeof(de)){
ffff800000103469:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103470:	e9 a2 00 00 00       	jmp    ffff800000103517 <dirlookup+0xec>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000103475:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103478:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff80000010347c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103480:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000103485:	48 89 c7             	mov    %rax,%rdi
ffff800000103488:	48 b8 1d 30 10 00 00 	movabs $0xffff80000010301d,%rax
ffff80000010348f:	80 ff ff 
ffff800000103492:	ff d0                	call   *%rax
ffff800000103494:	83 f8 10             	cmp    $0x10,%eax
ffff800000103497:	74 19                	je     ffff8000001034b2 <dirlookup+0x87>
      panic("dirlookup read");
ffff800000103499:	48 b8 f7 c7 10 00 00 	movabs $0xffff80000010c7f7,%rax
ffff8000001034a0:	80 ff ff 
ffff8000001034a3:	48 89 c7             	mov    %rax,%rdi
ffff8000001034a6:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001034ad:	80 ff ff 
ffff8000001034b0:	ff d0                	call   *%rax
    if(de.inum == 0)
ffff8000001034b2:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff8000001034b6:	66 85 c0             	test   %ax,%ax
ffff8000001034b9:	74 57                	je     ffff800000103512 <dirlookup+0xe7>
      continue;
    if(namecmp(name, de.name) == 0){
ffff8000001034bb:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff8000001034bf:	48 8d 50 02          	lea    0x2(%rax),%rdx
ffff8000001034c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001034c7:	48 89 d6             	mov    %rdx,%rsi
ffff8000001034ca:	48 89 c7             	mov    %rax,%rdi
ffff8000001034cd:	48 b8 fa 33 10 00 00 	movabs $0xffff8000001033fa,%rax
ffff8000001034d4:	80 ff ff 
ffff8000001034d7:	ff d0                	call   *%rax
ffff8000001034d9:	85 c0                	test   %eax,%eax
ffff8000001034db:	75 36                	jne    ffff800000103513 <dirlookup+0xe8>
      // entry matches path element
      if(poff)
ffff8000001034dd:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff8000001034e2:	74 09                	je     ffff8000001034ed <dirlookup+0xc2>
        *poff = off;
ffff8000001034e4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001034e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001034eb:	89 10                	mov    %edx,(%rax)
      inum = de.inum;
ffff8000001034ed:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff8000001034f1:	0f b7 c0             	movzwl %ax,%eax
ffff8000001034f4:	89 45 f8             	mov    %eax,-0x8(%rbp)
      return iget(dp->dev, inum);
ffff8000001034f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001034fb:	8b 00                	mov    (%rax),%eax
ffff8000001034fd:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff800000103500:	89 d6                	mov    %edx,%esi
ffff800000103502:	89 c7                	mov    %eax,%edi
ffff800000103504:	48 b8 22 28 10 00 00 	movabs $0xffff800000102822,%rax
ffff80000010350b:	80 ff ff 
ffff80000010350e:	ff d0                	call   *%rax
ffff800000103510:	eb 1d                	jmp    ffff80000010352f <dirlookup+0x104>
      continue;
ffff800000103512:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff800000103513:	83 45 fc 10          	addl   $0x10,-0x4(%rbp)
ffff800000103517:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010351b:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000103521:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000103524:	0f 82 4b ff ff ff    	jb     ffff800000103475 <dirlookup+0x4a>
    }
  }

  return 0;
ffff80000010352a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010352f:	c9                   	leave
ffff800000103530:	c3                   	ret

ffff800000103531 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
ffff800000103531:	55                   	push   %rbp
ffff800000103532:	48 89 e5             	mov    %rsp,%rbp
ffff800000103535:	48 83 ec 40          	sub    $0x40,%rsp
ffff800000103539:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010353d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000103541:	89 55 cc             	mov    %edx,-0x34(%rbp)
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
ffff800000103544:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
ffff800000103548:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010354c:	ba 00 00 00 00       	mov    $0x0,%edx
ffff800000103551:	48 89 ce             	mov    %rcx,%rsi
ffff800000103554:	48 89 c7             	mov    %rax,%rdi
ffff800000103557:	48 b8 2b 34 10 00 00 	movabs $0xffff80000010342b,%rax
ffff80000010355e:	80 ff ff 
ffff800000103561:	ff d0                	call   *%rax
ffff800000103563:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000103567:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010356c:	74 1d                	je     ffff80000010358b <dirlink+0x5a>
    iput(ip);
ffff80000010356e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000103572:	48 89 c7             	mov    %rax,%rdi
ffff800000103575:	48 b8 b7 2b 10 00 00 	movabs $0xffff800000102bb7,%rax
ffff80000010357c:	80 ff ff 
ffff80000010357f:	ff d0                	call   *%rax
    return -1;
ffff800000103581:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000103586:	e9 d8 00 00 00       	jmp    ffff800000103663 <dirlink+0x132>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff80000010358b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103592:	eb 4f                	jmp    ffff8000001035e3 <dirlink+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000103594:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103597:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff80000010359b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010359f:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff8000001035a4:	48 89 c7             	mov    %rax,%rdi
ffff8000001035a7:	48 b8 1d 30 10 00 00 	movabs $0xffff80000010301d,%rax
ffff8000001035ae:	80 ff ff 
ffff8000001035b1:	ff d0                	call   *%rax
ffff8000001035b3:	83 f8 10             	cmp    $0x10,%eax
ffff8000001035b6:	74 19                	je     ffff8000001035d1 <dirlink+0xa0>
      panic("dirlink read");
ffff8000001035b8:	48 b8 06 c8 10 00 00 	movabs $0xffff80000010c806,%rax
ffff8000001035bf:	80 ff ff 
ffff8000001035c2:	48 89 c7             	mov    %rax,%rdi
ffff8000001035c5:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001035cc:	80 ff ff 
ffff8000001035cf:	ff d0                	call   *%rax
    if(de.inum == 0)
ffff8000001035d1:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff8000001035d5:	66 85 c0             	test   %ax,%ax
ffff8000001035d8:	74 1c                	je     ffff8000001035f6 <dirlink+0xc5>
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff8000001035da:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001035dd:	83 c0 10             	add    $0x10,%eax
ffff8000001035e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff8000001035e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001035e7:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff8000001035ed:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001035f0:	39 c2                	cmp    %eax,%edx
ffff8000001035f2:	72 a0                	jb     ffff800000103594 <dirlink+0x63>
ffff8000001035f4:	eb 01                	jmp    ffff8000001035f7 <dirlink+0xc6>
      break;
ffff8000001035f6:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
ffff8000001035f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001035fb:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff8000001035ff:	48 8d 4a 02          	lea    0x2(%rdx),%rcx
ffff800000103603:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff800000103608:	48 89 c6             	mov    %rax,%rsi
ffff80000010360b:	48 89 cf             	mov    %rcx,%rdi
ffff80000010360e:	48 b8 b5 7c 10 00 00 	movabs $0xffff800000107cb5,%rax
ffff800000103615:	80 ff ff 
ffff800000103618:	ff d0                	call   *%rax
  de.inum = inum;
ffff80000010361a:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff80000010361d:	66 89 45 e0          	mov    %ax,-0x20(%rbp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000103621:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103624:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000103628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010362c:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000103631:	48 89 c7             	mov    %rax,%rdi
ffff800000103634:	48 b8 ea 31 10 00 00 	movabs $0xffff8000001031ea,%rax
ffff80000010363b:	80 ff ff 
ffff80000010363e:	ff d0                	call   *%rax
ffff800000103640:	83 f8 10             	cmp    $0x10,%eax
ffff800000103643:	74 19                	je     ffff80000010365e <dirlink+0x12d>
    panic("dirlink");
ffff800000103645:	48 b8 13 c8 10 00 00 	movabs $0xffff80000010c813,%rax
ffff80000010364c:	80 ff ff 
ffff80000010364f:	48 89 c7             	mov    %rax,%rdi
ffff800000103652:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103659:	80 ff ff 
ffff80000010365c:	ff d0                	call   *%rax

  return 0;
ffff80000010365e:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000103663:	c9                   	leave
ffff800000103664:	c3                   	ret

ffff800000103665 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
ffff800000103665:	55                   	push   %rbp
ffff800000103666:	48 89 e5             	mov    %rsp,%rbp
ffff800000103669:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010366d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000103671:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *s;
  int len;

  while(*path == '/')
ffff800000103675:	eb 05                	jmp    ffff80000010367c <skipelem+0x17>
    path++;
ffff800000103677:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path == '/')
ffff80000010367c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103680:	0f b6 00             	movzbl (%rax),%eax
ffff800000103683:	3c 2f                	cmp    $0x2f,%al
ffff800000103685:	74 f0                	je     ffff800000103677 <skipelem+0x12>
  if(*path == 0)
ffff800000103687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010368b:	0f b6 00             	movzbl (%rax),%eax
ffff80000010368e:	84 c0                	test   %al,%al
ffff800000103690:	75 0a                	jne    ffff80000010369c <skipelem+0x37>
    return 0;
ffff800000103692:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000103697:	e9 9a 00 00 00       	jmp    ffff800000103736 <skipelem+0xd1>
  s = path;
ffff80000010369c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001036a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(*path != '/' && *path != 0)
ffff8000001036a4:	eb 05                	jmp    ffff8000001036ab <skipelem+0x46>
    path++;
ffff8000001036a6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path != '/' && *path != 0)
ffff8000001036ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001036af:	0f b6 00             	movzbl (%rax),%eax
ffff8000001036b2:	3c 2f                	cmp    $0x2f,%al
ffff8000001036b4:	74 0b                	je     ffff8000001036c1 <skipelem+0x5c>
ffff8000001036b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001036ba:	0f b6 00             	movzbl (%rax),%eax
ffff8000001036bd:	84 c0                	test   %al,%al
ffff8000001036bf:	75 e5                	jne    ffff8000001036a6 <skipelem+0x41>
  len = path - s;
ffff8000001036c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001036c5:	48 2b 45 f8          	sub    -0x8(%rbp),%rax
ffff8000001036c9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(len >= DIRSIZ)
ffff8000001036cc:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
ffff8000001036d0:	7e 21                	jle    ffff8000001036f3 <skipelem+0x8e>
    memmove(name, s, DIRSIZ);
ffff8000001036d2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff8000001036d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001036da:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff8000001036df:	48 89 ce             	mov    %rcx,%rsi
ffff8000001036e2:	48 89 c7             	mov    %rax,%rdi
ffff8000001036e5:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff8000001036ec:	80 ff ff 
ffff8000001036ef:	ff d0                	call   *%rax
ffff8000001036f1:	eb 34                	jmp    ffff800000103727 <skipelem+0xc2>
  else {
    memmove(name, s, len);
ffff8000001036f3:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff8000001036f6:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff8000001036fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001036fe:	48 89 ce             	mov    %rcx,%rsi
ffff800000103701:	48 89 c7             	mov    %rax,%rdi
ffff800000103704:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff80000010370b:	80 ff ff 
ffff80000010370e:	ff d0                	call   *%rax
    name[len] = 0;
ffff800000103710:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000103713:	48 63 d0             	movslq %eax,%rdx
ffff800000103716:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010371a:	48 01 d0             	add    %rdx,%rax
ffff80000010371d:	c6 00 00             	movb   $0x0,(%rax)
  }
  while(*path == '/')
ffff800000103720:	eb 05                	jmp    ffff800000103727 <skipelem+0xc2>
    path++;
ffff800000103722:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path == '/')
ffff800000103727:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010372b:	0f b6 00             	movzbl (%rax),%eax
ffff80000010372e:	3c 2f                	cmp    $0x2f,%al
ffff800000103730:	74 f0                	je     ffff800000103722 <skipelem+0xbd>
  return path;
ffff800000103732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
ffff800000103736:	c9                   	leave
ffff800000103737:	c3                   	ret

ffff800000103738 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
ffff800000103738:	55                   	push   %rbp
ffff800000103739:	48 89 e5             	mov    %rsp,%rbp
ffff80000010373c:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000103740:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000103744:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff800000103747:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  struct inode *ip, *next;

  if(*path == '/')
ffff80000010374b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010374f:	0f b6 00             	movzbl (%rax),%eax
ffff800000103752:	3c 2f                	cmp    $0x2f,%al
ffff800000103754:	75 1f                	jne    ffff800000103775 <namex+0x3d>
    ip = iget(ROOTDEV, ROOTINO);
ffff800000103756:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010375b:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000103760:	48 b8 22 28 10 00 00 	movabs $0xffff800000102822,%rax
ffff800000103767:	80 ff ff 
ffff80000010376a:	ff d0                	call   *%rax
ffff80000010376c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103770:	e9 f7 00 00 00       	jmp    ffff80000010386c <namex+0x134>
  else
    ip = idup(proc->cwd);
ffff800000103775:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010377c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000103780:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff800000103787:	48 89 c7             	mov    %rax,%rdi
ffff80000010378a:	48 b8 5f 29 10 00 00 	movabs $0xffff80000010295f,%rax
ffff800000103791:	80 ff ff 
ffff800000103794:	ff d0                	call   *%rax
ffff800000103796:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  while((path = skipelem(path, name)) != 0){
ffff80000010379a:	e9 cd 00 00 00       	jmp    ffff80000010386c <namex+0x134>
    ilock(ip);
ffff80000010379f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001037a3:	48 89 c7             	mov    %rax,%rdi
ffff8000001037a6:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff8000001037ad:	80 ff ff 
ffff8000001037b0:	ff d0                	call   *%rax
    if(ip->type != T_DIR){
ffff8000001037b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001037b6:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff8000001037bd:	66 83 f8 01          	cmp    $0x1,%ax
ffff8000001037c1:	74 1d                	je     ffff8000001037e0 <namex+0xa8>
      iunlockput(ip);
ffff8000001037c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001037c7:	48 89 c7             	mov    %rax,%rdi
ffff8000001037ca:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff8000001037d1:	80 ff ff 
ffff8000001037d4:	ff d0                	call   *%rax
      return 0;
ffff8000001037d6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001037db:	e9 d9 00 00 00       	jmp    ffff8000001038b9 <namex+0x181>
    }
    if(nameiparent && *path == '\0'){
ffff8000001037e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffff8000001037e4:	74 27                	je     ffff80000010380d <namex+0xd5>
ffff8000001037e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001037ea:	0f b6 00             	movzbl (%rax),%eax
ffff8000001037ed:	84 c0                	test   %al,%al
ffff8000001037ef:	75 1c                	jne    ffff80000010380d <namex+0xd5>
      iunlock(ip);  // Stop one level early.
ffff8000001037f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001037f5:	48 89 c7             	mov    %rax,%rdi
ffff8000001037f8:	48 b8 4b 2b 10 00 00 	movabs $0xffff800000102b4b,%rax
ffff8000001037ff:	80 ff ff 
ffff800000103802:	ff d0                	call   *%rax
      return ip;
ffff800000103804:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103808:	e9 ac 00 00 00       	jmp    ffff8000001038b9 <namex+0x181>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
ffff80000010380d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff800000103811:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103815:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010381a:	48 89 ce             	mov    %rcx,%rsi
ffff80000010381d:	48 89 c7             	mov    %rax,%rdi
ffff800000103820:	48 b8 2b 34 10 00 00 	movabs $0xffff80000010342b,%rax
ffff800000103827:	80 ff ff 
ffff80000010382a:	ff d0                	call   *%rax
ffff80000010382c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000103830:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000103835:	75 1a                	jne    ffff800000103851 <namex+0x119>
      iunlockput(ip);
ffff800000103837:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010383b:	48 89 c7             	mov    %rax,%rdi
ffff80000010383e:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000103845:	80 ff ff 
ffff800000103848:	ff d0                	call   *%rax
      return 0;
ffff80000010384a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010384f:	eb 68                	jmp    ffff8000001038b9 <namex+0x181>
    }
    iunlockput(ip);
ffff800000103851:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103855:	48 89 c7             	mov    %rax,%rdi
ffff800000103858:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff80000010385f:	80 ff ff 
ffff800000103862:	ff d0                	call   *%rax
    ip = next;
ffff800000103864:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000103868:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((path = skipelem(path, name)) != 0){
ffff80000010386c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000103870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103874:	48 89 d6             	mov    %rdx,%rsi
ffff800000103877:	48 89 c7             	mov    %rax,%rdi
ffff80000010387a:	48 b8 65 36 10 00 00 	movabs $0xffff800000103665,%rax
ffff800000103881:	80 ff ff 
ffff800000103884:	ff d0                	call   *%rax
ffff800000103886:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010388a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010388f:	0f 85 0a ff ff ff    	jne    ffff80000010379f <namex+0x67>
  }
  if(nameiparent){
ffff800000103895:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffff800000103899:	74 1a                	je     ffff8000001038b5 <namex+0x17d>
    iput(ip);
ffff80000010389b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010389f:	48 89 c7             	mov    %rax,%rdi
ffff8000001038a2:	48 b8 b7 2b 10 00 00 	movabs $0xffff800000102bb7,%rax
ffff8000001038a9:	80 ff ff 
ffff8000001038ac:	ff d0                	call   *%rax
    return 0;
ffff8000001038ae:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001038b3:	eb 04                	jmp    ffff8000001038b9 <namex+0x181>
  }
  return ip;
ffff8000001038b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001038b9:	c9                   	leave
ffff8000001038ba:	c3                   	ret

ffff8000001038bb <namei>:

struct inode*
namei(char *path)
{
ffff8000001038bb:	55                   	push   %rbp
ffff8000001038bc:	48 89 e5             	mov    %rsp,%rbp
ffff8000001038bf:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001038c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  char name[DIRSIZ];
  return namex(path, 0, name);
ffff8000001038c7:	48 8d 55 f2          	lea    -0xe(%rbp),%rdx
ffff8000001038cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001038cf:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001038d4:	48 89 c7             	mov    %rax,%rdi
ffff8000001038d7:	48 b8 38 37 10 00 00 	movabs $0xffff800000103738,%rax
ffff8000001038de:	80 ff ff 
ffff8000001038e1:	ff d0                	call   *%rax
}
ffff8000001038e3:	c9                   	leave
ffff8000001038e4:	c3                   	ret

ffff8000001038e5 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
ffff8000001038e5:	55                   	push   %rbp
ffff8000001038e6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001038e9:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001038ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001038f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return namex(path, 1, name);
ffff8000001038f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001038f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001038fd:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000103902:	48 89 c7             	mov    %rax,%rdi
ffff800000103905:	48 b8 38 37 10 00 00 	movabs $0xffff800000103738,%rax
ffff80000010390c:	80 ff ff 
ffff80000010390f:	ff d0                	call   *%rax
}
ffff800000103911:	c9                   	leave
ffff800000103912:	c3                   	ret

ffff800000103913 <inb>:
{
ffff800000103913:	55                   	push   %rbp
ffff800000103914:	48 89 e5             	mov    %rsp,%rbp
ffff800000103917:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010391b:	89 f8                	mov    %edi,%eax
ffff80000010391d:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff800000103921:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000103925:	89 c2                	mov    %eax,%edx
ffff800000103927:	ec                   	in     (%dx),%al
ffff800000103928:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff80000010392b:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010392f:	c9                   	leave
ffff800000103930:	c3                   	ret

ffff800000103931 <insl>:
{
ffff800000103931:	55                   	push   %rbp
ffff800000103932:	48 89 e5             	mov    %rsp,%rbp
ffff800000103935:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000103939:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff80000010393c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000103940:	89 55 f8             	mov    %edx,-0x8(%rbp)
  asm volatile("cld; rep insl" :
ffff800000103943:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103946:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff80000010394a:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010394d:	48 89 ce             	mov    %rcx,%rsi
ffff800000103950:	48 89 f7             	mov    %rsi,%rdi
ffff800000103953:	89 c1                	mov    %eax,%ecx
ffff800000103955:	fc                   	cld
ffff800000103956:	f3 6d                	rep insl (%dx),(%rdi)
ffff800000103958:	89 c8                	mov    %ecx,%eax
ffff80000010395a:	48 89 fe             	mov    %rdi,%rsi
ffff80000010395d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000103961:	89 45 f8             	mov    %eax,-0x8(%rbp)
}
ffff800000103964:	90                   	nop
ffff800000103965:	c9                   	leave
ffff800000103966:	c3                   	ret

ffff800000103967 <outb>:
{
ffff800000103967:	55                   	push   %rbp
ffff800000103968:	48 89 e5             	mov    %rsp,%rbp
ffff80000010396b:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010396f:	89 fa                	mov    %edi,%edx
ffff800000103971:	89 f0                	mov    %esi,%eax
ffff800000103973:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffff800000103977:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff80000010397a:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff80000010397e:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff800000103982:	ee                   	out    %al,(%dx)
}
ffff800000103983:	90                   	nop
ffff800000103984:	c9                   	leave
ffff800000103985:	c3                   	ret

ffff800000103986 <outsl>:
{
ffff800000103986:	55                   	push   %rbp
ffff800000103987:	48 89 e5             	mov    %rsp,%rbp
ffff80000010398a:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010398e:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103991:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000103995:	89 55 f8             	mov    %edx,-0x8(%rbp)
  asm volatile("cld; rep outsl" :
ffff800000103998:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010399b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff80000010399f:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001039a2:	48 89 ce             	mov    %rcx,%rsi
ffff8000001039a5:	89 c1                	mov    %eax,%ecx
ffff8000001039a7:	fc                   	cld
ffff8000001039a8:	f3 6f                	rep outsl (%rsi),(%dx)
ffff8000001039aa:	89 c8                	mov    %ecx,%eax
ffff8000001039ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001039b0:	89 45 f8             	mov    %eax,-0x8(%rbp)
}
ffff8000001039b3:	90                   	nop
ffff8000001039b4:	c9                   	leave
ffff8000001039b5:	c3                   	ret

ffff8000001039b6 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
ffff8000001039b6:	55                   	push   %rbp
ffff8000001039b7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001039ba:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001039be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
ffff8000001039c1:	90                   	nop
ffff8000001039c2:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff8000001039c7:	48 b8 13 39 10 00 00 	movabs $0xffff800000103913,%rax
ffff8000001039ce:	80 ff ff 
ffff8000001039d1:	ff d0                	call   *%rax
ffff8000001039d3:	0f b6 c0             	movzbl %al,%eax
ffff8000001039d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff8000001039d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001039dc:	25 c0 00 00 00       	and    $0xc0,%eax
ffff8000001039e1:	83 f8 40             	cmp    $0x40,%eax
ffff8000001039e4:	75 dc                	jne    ffff8000001039c2 <idewait+0xc>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
ffff8000001039e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff8000001039ea:	74 11                	je     ffff8000001039fd <idewait+0x47>
ffff8000001039ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001039ef:	83 e0 21             	and    $0x21,%eax
ffff8000001039f2:	85 c0                	test   %eax,%eax
ffff8000001039f4:	74 07                	je     ffff8000001039fd <idewait+0x47>
    return -1;
ffff8000001039f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001039fb:	eb 05                	jmp    ffff800000103a02 <idewait+0x4c>
  return 0;
ffff8000001039fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000103a02:	c9                   	leave
ffff800000103a03:	c3                   	ret

ffff800000103a04 <ideinit>:

void
ideinit(void)
{
ffff800000103a04:	55                   	push   %rbp
ffff800000103a05:	48 89 e5             	mov    %rsp,%rbp
ffff800000103a08:	48 83 ec 10          	sub    $0x10,%rsp
  initlock(&idelock, "ide");
ffff800000103a0c:	48 ba 1b c8 10 00 00 	movabs $0xffff80000010c81b,%rdx
ffff800000103a13:	80 ff ff 
ffff800000103a16:	48 b8 c0 80 11 00 00 	movabs $0xffff8000001180c0,%rax
ffff800000103a1d:	80 ff ff 
ffff800000103a20:	48 89 d6             	mov    %rdx,%rsi
ffff800000103a23:	48 89 c7             	mov    %rax,%rdi
ffff800000103a26:	48 b8 a5 76 10 00 00 	movabs $0xffff8000001076a5,%rax
ffff800000103a2d:	80 ff ff 
ffff800000103a30:	ff d0                	call   *%rax
  ioapicenable(IRQ_IDE, ncpu - 1);
ffff800000103a32:	48 b8 20 84 11 00 00 	movabs $0xffff800000118420,%rax
ffff800000103a39:	80 ff ff 
ffff800000103a3c:	8b 00                	mov    (%rax),%eax
ffff800000103a3e:	83 e8 01             	sub    $0x1,%eax
ffff800000103a41:	89 c6                	mov    %eax,%esi
ffff800000103a43:	bf 0e 00 00 00       	mov    $0xe,%edi
ffff800000103a48:	48 b8 96 40 10 00 00 	movabs $0xffff800000104096,%rax
ffff800000103a4f:	80 ff ff 
ffff800000103a52:	ff d0                	call   *%rax
  idewait(0);
ffff800000103a54:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000103a59:	48 b8 b6 39 10 00 00 	movabs $0xffff8000001039b6,%rax
ffff800000103a60:	80 ff ff 
ffff800000103a63:	ff d0                	call   *%rax

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
ffff800000103a65:	be f0 00 00 00       	mov    $0xf0,%esi
ffff800000103a6a:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff800000103a6f:	48 b8 67 39 10 00 00 	movabs $0xffff800000103967,%rax
ffff800000103a76:	80 ff ff 
ffff800000103a79:	ff d0                	call   *%rax
  for(int i=0; i<1000; i++){
ffff800000103a7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103a82:	eb 2b                	jmp    ffff800000103aaf <ideinit+0xab>
    if(inb(0x1f7) != 0){
ffff800000103a84:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103a89:	48 b8 13 39 10 00 00 	movabs $0xffff800000103913,%rax
ffff800000103a90:	80 ff ff 
ffff800000103a93:	ff d0                	call   *%rax
ffff800000103a95:	84 c0                	test   %al,%al
ffff800000103a97:	74 12                	je     ffff800000103aab <ideinit+0xa7>
      havedisk1 = 1;
ffff800000103a99:	48 b8 30 81 11 00 00 	movabs $0xffff800000118130,%rax
ffff800000103aa0:	80 ff ff 
ffff800000103aa3:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
      break;
ffff800000103aa9:	eb 0d                	jmp    ffff800000103ab8 <ideinit+0xb4>
  for(int i=0; i<1000; i++){
ffff800000103aab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000103aaf:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
ffff800000103ab6:	7e cc                	jle    ffff800000103a84 <ideinit+0x80>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
ffff800000103ab8:	be e0 00 00 00       	mov    $0xe0,%esi
ffff800000103abd:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff800000103ac2:	48 b8 67 39 10 00 00 	movabs $0xffff800000103967,%rax
ffff800000103ac9:	80 ff ff 
ffff800000103acc:	ff d0                	call   *%rax
}
ffff800000103ace:	90                   	nop
ffff800000103acf:	c9                   	leave
ffff800000103ad0:	c3                   	ret

ffff800000103ad1 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
ffff800000103ad1:	55                   	push   %rbp
ffff800000103ad2:	48 89 e5             	mov    %rsp,%rbp
ffff800000103ad5:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000103ad9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  if(b == 0)
ffff800000103add:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000103ae2:	75 19                	jne    ffff800000103afd <idestart+0x2c>
    panic("idestart");
ffff800000103ae4:	48 b8 1f c8 10 00 00 	movabs $0xffff80000010c81f,%rax
ffff800000103aeb:	80 ff ff 
ffff800000103aee:	48 89 c7             	mov    %rax,%rdi
ffff800000103af1:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103af8:	80 ff ff 
ffff800000103afb:	ff d0                	call   *%rax
  if(b->blockno >= FSSIZE)
ffff800000103afd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103b01:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000103b04:	3d e7 03 00 00       	cmp    $0x3e7,%eax
ffff800000103b09:	76 19                	jbe    ffff800000103b24 <idestart+0x53>
    panic("incorrect blockno");
ffff800000103b0b:	48 b8 28 c8 10 00 00 	movabs $0xffff80000010c828,%rax
ffff800000103b12:	80 ff ff 
ffff800000103b15:	48 89 c7             	mov    %rax,%rdi
ffff800000103b18:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103b1f:	80 ff ff 
ffff800000103b22:	ff d0                	call   *%rax
  int sector_per_block =  BSIZE/SECTOR_SIZE;
ffff800000103b24:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
  int sector = b->blockno * sector_per_block;
ffff800000103b2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103b2f:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000103b32:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000103b35:	0f af c2             	imul   %edx,%eax
ffff800000103b38:	89 45 f0             	mov    %eax,-0x10(%rbp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
ffff800000103b3b:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
ffff800000103b3f:	75 09                	jne    ffff800000103b4a <idestart+0x79>
ffff800000103b41:	c7 45 fc 20 00 00 00 	movl   $0x20,-0x4(%rbp)
ffff800000103b48:	eb 07                	jmp    ffff800000103b51 <idestart+0x80>
ffff800000103b4a:	c7 45 fc c4 00 00 00 	movl   $0xc4,-0x4(%rbp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
ffff800000103b51:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
ffff800000103b55:	75 09                	jne    ffff800000103b60 <idestart+0x8f>
ffff800000103b57:	c7 45 f8 30 00 00 00 	movl   $0x30,-0x8(%rbp)
ffff800000103b5e:	eb 07                	jmp    ffff800000103b67 <idestart+0x96>
ffff800000103b60:	c7 45 f8 c5 00 00 00 	movl   $0xc5,-0x8(%rbp)

  if (sector_per_block > 7) panic("idestart");
ffff800000103b67:	83 7d f4 07          	cmpl   $0x7,-0xc(%rbp)
ffff800000103b6b:	7e 19                	jle    ffff800000103b86 <idestart+0xb5>
ffff800000103b6d:	48 b8 1f c8 10 00 00 	movabs $0xffff80000010c81f,%rax
ffff800000103b74:	80 ff ff 
ffff800000103b77:	48 89 c7             	mov    %rax,%rdi
ffff800000103b7a:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103b81:	80 ff ff 
ffff800000103b84:	ff d0                	call   *%rax

  idewait(0);
ffff800000103b86:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000103b8b:	48 b8 b6 39 10 00 00 	movabs $0xffff8000001039b6,%rax
ffff800000103b92:	80 ff ff 
ffff800000103b95:	ff d0                	call   *%rax
  outb(0x3f6, 0);  // generate interrupt
ffff800000103b97:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000103b9c:	bf f6 03 00 00       	mov    $0x3f6,%edi
ffff800000103ba1:	48 b8 67 39 10 00 00 	movabs $0xffff800000103967,%rax
ffff800000103ba8:	80 ff ff 
ffff800000103bab:	ff d0                	call   *%rax
  outb(0x1f2, sector_per_block);  // number of sectors
ffff800000103bad:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000103bb0:	0f b6 c0             	movzbl %al,%eax
ffff800000103bb3:	89 c6                	mov    %eax,%esi
ffff800000103bb5:	bf f2 01 00 00       	mov    $0x1f2,%edi
ffff800000103bba:	48 b8 67 39 10 00 00 	movabs $0xffff800000103967,%rax
ffff800000103bc1:	80 ff ff 
ffff800000103bc4:	ff d0                	call   *%rax
  outb(0x1f3, sector & 0xff);
ffff800000103bc6:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000103bc9:	0f b6 c0             	movzbl %al,%eax
ffff800000103bcc:	89 c6                	mov    %eax,%esi
ffff800000103bce:	bf f3 01 00 00       	mov    $0x1f3,%edi
ffff800000103bd3:	48 b8 67 39 10 00 00 	movabs $0xffff800000103967,%rax
ffff800000103bda:	80 ff ff 
ffff800000103bdd:	ff d0                	call   *%rax
  outb(0x1f4, (sector >> 8) & 0xff);
ffff800000103bdf:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000103be2:	c1 f8 08             	sar    $0x8,%eax
ffff800000103be5:	0f b6 c0             	movzbl %al,%eax
ffff800000103be8:	89 c6                	mov    %eax,%esi
ffff800000103bea:	bf f4 01 00 00       	mov    $0x1f4,%edi
ffff800000103bef:	48 b8 67 39 10 00 00 	movabs $0xffff800000103967,%rax
ffff800000103bf6:	80 ff ff 
ffff800000103bf9:	ff d0                	call   *%rax
  outb(0x1f5, (sector >> 16) & 0xff);
ffff800000103bfb:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000103bfe:	c1 f8 10             	sar    $0x10,%eax
ffff800000103c01:	0f b6 c0             	movzbl %al,%eax
ffff800000103c04:	89 c6                	mov    %eax,%esi
ffff800000103c06:	bf f5 01 00 00       	mov    $0x1f5,%edi
ffff800000103c0b:	48 b8 67 39 10 00 00 	movabs $0xffff800000103967,%rax
ffff800000103c12:	80 ff ff 
ffff800000103c15:	ff d0                	call   *%rax
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
ffff800000103c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103c1b:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000103c1e:	c1 e0 04             	shl    $0x4,%eax
ffff800000103c21:	83 e0 10             	and    $0x10,%eax
ffff800000103c24:	89 c2                	mov    %eax,%edx
ffff800000103c26:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000103c29:	c1 f8 18             	sar    $0x18,%eax
ffff800000103c2c:	83 e0 0f             	and    $0xf,%eax
ffff800000103c2f:	09 d0                	or     %edx,%eax
ffff800000103c31:	83 c8 e0             	or     $0xffffffe0,%eax
ffff800000103c34:	0f b6 c0             	movzbl %al,%eax
ffff800000103c37:	89 c6                	mov    %eax,%esi
ffff800000103c39:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff800000103c3e:	48 b8 67 39 10 00 00 	movabs $0xffff800000103967,%rax
ffff800000103c45:	80 ff ff 
ffff800000103c48:	ff d0                	call   *%rax
  if(b->flags & B_DIRTY){
ffff800000103c4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103c4e:	8b 00                	mov    (%rax),%eax
ffff800000103c50:	83 e0 04             	and    $0x4,%eax
ffff800000103c53:	85 c0                	test   %eax,%eax
ffff800000103c55:	74 3e                	je     ffff800000103c95 <idestart+0x1c4>
    outb(0x1f7, write_cmd);
ffff800000103c57:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103c5a:	0f b6 c0             	movzbl %al,%eax
ffff800000103c5d:	89 c6                	mov    %eax,%esi
ffff800000103c5f:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103c64:	48 b8 67 39 10 00 00 	movabs $0xffff800000103967,%rax
ffff800000103c6b:	80 ff ff 
ffff800000103c6e:	ff d0                	call   *%rax
    outsl(0x1f0, b->data, BSIZE/4);
ffff800000103c70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103c74:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000103c7a:	ba 80 00 00 00       	mov    $0x80,%edx
ffff800000103c7f:	48 89 c6             	mov    %rax,%rsi
ffff800000103c82:	bf f0 01 00 00       	mov    $0x1f0,%edi
ffff800000103c87:	48 b8 86 39 10 00 00 	movabs $0xffff800000103986,%rax
ffff800000103c8e:	80 ff ff 
ffff800000103c91:	ff d0                	call   *%rax
  } else {
    outb(0x1f7, read_cmd);
  }
}
ffff800000103c93:	eb 19                	jmp    ffff800000103cae <idestart+0x1dd>
    outb(0x1f7, read_cmd);
ffff800000103c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103c98:	0f b6 c0             	movzbl %al,%eax
ffff800000103c9b:	89 c6                	mov    %eax,%esi
ffff800000103c9d:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103ca2:	48 b8 67 39 10 00 00 	movabs $0xffff800000103967,%rax
ffff800000103ca9:	80 ff ff 
ffff800000103cac:	ff d0                	call   *%rax
}
ffff800000103cae:	90                   	nop
ffff800000103caf:	c9                   	leave
ffff800000103cb0:	c3                   	ret

ffff800000103cb1 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
ffff800000103cb1:	55                   	push   %rbp
ffff800000103cb2:	48 89 e5             	mov    %rsp,%rbp
ffff800000103cb5:	48 83 ec 10          	sub    $0x10,%rsp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
ffff800000103cb9:	48 b8 c0 80 11 00 00 	movabs $0xffff8000001180c0,%rax
ffff800000103cc0:	80 ff ff 
ffff800000103cc3:	48 89 c7             	mov    %rax,%rdi
ffff800000103cc6:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000103ccd:	80 ff ff 
ffff800000103cd0:	ff d0                	call   *%rax
  if((b = idequeue) == 0){
ffff800000103cd2:	48 b8 28 81 11 00 00 	movabs $0xffff800000118128,%rax
ffff800000103cd9:	80 ff ff 
ffff800000103cdc:	48 8b 00             	mov    (%rax),%rax
ffff800000103cdf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103ce3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000103ce8:	75 1e                	jne    ffff800000103d08 <ideintr+0x57>
    release(&idelock);
ffff800000103cea:	48 b8 c0 80 11 00 00 	movabs $0xffff8000001180c0,%rax
ffff800000103cf1:	80 ff ff 
ffff800000103cf4:	48 89 c7             	mov    %rax,%rdi
ffff800000103cf7:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000103cfe:	80 ff ff 
ffff800000103d01:	ff d0                	call   *%rax
    // cprintf("spurious IDE interrupt\n");
    return;
ffff800000103d03:	e9 d9 00 00 00       	jmp    ffff800000103de1 <ideintr+0x130>
  }
  idequeue = b->qnext;
ffff800000103d08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103d0c:	48 8b 80 a8 00 00 00 	mov    0xa8(%rax),%rax
ffff800000103d13:	48 ba 28 81 11 00 00 	movabs $0xffff800000118128,%rdx
ffff800000103d1a:	80 ff ff 
ffff800000103d1d:	48 89 02             	mov    %rax,(%rdx)

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
ffff800000103d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103d24:	8b 00                	mov    (%rax),%eax
ffff800000103d26:	83 e0 04             	and    $0x4,%eax
ffff800000103d29:	85 c0                	test   %eax,%eax
ffff800000103d2b:	75 38                	jne    ffff800000103d65 <ideintr+0xb4>
ffff800000103d2d:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000103d32:	48 b8 b6 39 10 00 00 	movabs $0xffff8000001039b6,%rax
ffff800000103d39:	80 ff ff 
ffff800000103d3c:	ff d0                	call   *%rax
ffff800000103d3e:	85 c0                	test   %eax,%eax
ffff800000103d40:	78 23                	js     ffff800000103d65 <ideintr+0xb4>
    insl(0x1f0, b->data, BSIZE/4);
ffff800000103d42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103d46:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000103d4c:	ba 80 00 00 00       	mov    $0x80,%edx
ffff800000103d51:	48 89 c6             	mov    %rax,%rsi
ffff800000103d54:	bf f0 01 00 00       	mov    $0x1f0,%edi
ffff800000103d59:	48 b8 31 39 10 00 00 	movabs $0xffff800000103931,%rax
ffff800000103d60:	80 ff ff 
ffff800000103d63:	ff d0                	call   *%rax

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
ffff800000103d65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103d69:	8b 00                	mov    (%rax),%eax
ffff800000103d6b:	83 c8 02             	or     $0x2,%eax
ffff800000103d6e:	89 c2                	mov    %eax,%edx
ffff800000103d70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103d74:	89 10                	mov    %edx,(%rax)
  b->flags &= ~B_DIRTY;
ffff800000103d76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103d7a:	8b 00                	mov    (%rax),%eax
ffff800000103d7c:	83 e0 fb             	and    $0xfffffffb,%eax
ffff800000103d7f:	89 c2                	mov    %eax,%edx
ffff800000103d81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103d85:	89 10                	mov    %edx,(%rax)
  wakeup(b);
ffff800000103d87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103d8b:	48 89 c7             	mov    %rax,%rdi
ffff800000103d8e:	48 b8 4d 72 10 00 00 	movabs $0xffff80000010724d,%rax
ffff800000103d95:	80 ff ff 
ffff800000103d98:	ff d0                	call   *%rax

  // Start disk on next buf in queue.
  if(idequeue != 0)
ffff800000103d9a:	48 b8 28 81 11 00 00 	movabs $0xffff800000118128,%rax
ffff800000103da1:	80 ff ff 
ffff800000103da4:	48 8b 00             	mov    (%rax),%rax
ffff800000103da7:	48 85 c0             	test   %rax,%rax
ffff800000103daa:	74 1c                	je     ffff800000103dc8 <ideintr+0x117>
    idestart(idequeue);
ffff800000103dac:	48 b8 28 81 11 00 00 	movabs $0xffff800000118128,%rax
ffff800000103db3:	80 ff ff 
ffff800000103db6:	48 8b 00             	mov    (%rax),%rax
ffff800000103db9:	48 89 c7             	mov    %rax,%rdi
ffff800000103dbc:	48 b8 d1 3a 10 00 00 	movabs $0xffff800000103ad1,%rax
ffff800000103dc3:	80 ff ff 
ffff800000103dc6:	ff d0                	call   *%rax

  release(&idelock);
ffff800000103dc8:	48 b8 c0 80 11 00 00 	movabs $0xffff8000001180c0,%rax
ffff800000103dcf:	80 ff ff 
ffff800000103dd2:	48 89 c7             	mov    %rax,%rdi
ffff800000103dd5:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000103ddc:	80 ff ff 
ffff800000103ddf:	ff d0                	call   *%rax
}
ffff800000103de1:	c9                   	leave
ffff800000103de2:	c3                   	ret

ffff800000103de3 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
ffff800000103de3:	55                   	push   %rbp
ffff800000103de4:	48 89 e5             	mov    %rsp,%rbp
ffff800000103de7:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000103deb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf **pp;

  if(!holdingsleep(&b->lock))
ffff800000103def:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103df3:	48 83 c0 10          	add    $0x10,%rax
ffff800000103df7:	48 89 c7             	mov    %rax,%rdi
ffff800000103dfa:	48 b8 12 76 10 00 00 	movabs $0xffff800000107612,%rax
ffff800000103e01:	80 ff ff 
ffff800000103e04:	ff d0                	call   *%rax
ffff800000103e06:	85 c0                	test   %eax,%eax
ffff800000103e08:	75 19                	jne    ffff800000103e23 <iderw+0x40>
    panic("iderw: buf not locked");
ffff800000103e0a:	48 b8 3a c8 10 00 00 	movabs $0xffff80000010c83a,%rax
ffff800000103e11:	80 ff ff 
ffff800000103e14:	48 89 c7             	mov    %rax,%rdi
ffff800000103e17:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103e1e:	80 ff ff 
ffff800000103e21:	ff d0                	call   *%rax
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
ffff800000103e23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e27:	8b 00                	mov    (%rax),%eax
ffff800000103e29:	83 e0 06             	and    $0x6,%eax
ffff800000103e2c:	83 f8 02             	cmp    $0x2,%eax
ffff800000103e2f:	75 19                	jne    ffff800000103e4a <iderw+0x67>
    panic("iderw: nothing to do");
ffff800000103e31:	48 b8 50 c8 10 00 00 	movabs $0xffff80000010c850,%rax
ffff800000103e38:	80 ff ff 
ffff800000103e3b:	48 89 c7             	mov    %rax,%rdi
ffff800000103e3e:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103e45:	80 ff ff 
ffff800000103e48:	ff d0                	call   *%rax
  if(b->dev != 0 && !havedisk1)
ffff800000103e4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e4e:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000103e51:	85 c0                	test   %eax,%eax
ffff800000103e53:	74 29                	je     ffff800000103e7e <iderw+0x9b>
ffff800000103e55:	48 b8 30 81 11 00 00 	movabs $0xffff800000118130,%rax
ffff800000103e5c:	80 ff ff 
ffff800000103e5f:	8b 00                	mov    (%rax),%eax
ffff800000103e61:	85 c0                	test   %eax,%eax
ffff800000103e63:	75 19                	jne    ffff800000103e7e <iderw+0x9b>
    panic("iderw: ide disk 1 not present");
ffff800000103e65:	48 b8 65 c8 10 00 00 	movabs $0xffff80000010c865,%rax
ffff800000103e6c:	80 ff ff 
ffff800000103e6f:	48 89 c7             	mov    %rax,%rdi
ffff800000103e72:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103e79:	80 ff ff 
ffff800000103e7c:	ff d0                	call   *%rax

  acquire(&idelock);  //DOC:acquire-lock
ffff800000103e7e:	48 b8 c0 80 11 00 00 	movabs $0xffff8000001180c0,%rax
ffff800000103e85:	80 ff ff 
ffff800000103e88:	48 89 c7             	mov    %rax,%rdi
ffff800000103e8b:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000103e92:	80 ff ff 
ffff800000103e95:	ff d0                	call   *%rax

  // Append b to idequeue.
  b->qnext = 0;
ffff800000103e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e9b:	48 c7 80 a8 00 00 00 	movq   $0x0,0xa8(%rax)
ffff800000103ea2:	00 00 00 00 
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
ffff800000103ea6:	48 b8 28 81 11 00 00 	movabs $0xffff800000118128,%rax
ffff800000103ead:	80 ff ff 
ffff800000103eb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103eb4:	eb 11                	jmp    ffff800000103ec7 <iderw+0xe4>
ffff800000103eb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103eba:	48 8b 00             	mov    (%rax),%rax
ffff800000103ebd:	48 05 a8 00 00 00    	add    $0xa8,%rax
ffff800000103ec3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103ec7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103ecb:	48 8b 00             	mov    (%rax),%rax
ffff800000103ece:	48 85 c0             	test   %rax,%rax
ffff800000103ed1:	75 e3                	jne    ffff800000103eb6 <iderw+0xd3>
    ;
  *pp = b;
ffff800000103ed3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103ed7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000103edb:	48 89 10             	mov    %rdx,(%rax)

  // Start disk if necessary.
  if(idequeue == b)
ffff800000103ede:	48 b8 28 81 11 00 00 	movabs $0xffff800000118128,%rax
ffff800000103ee5:	80 ff ff 
ffff800000103ee8:	48 8b 00             	mov    (%rax),%rax
ffff800000103eeb:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000103eef:	75 35                	jne    ffff800000103f26 <iderw+0x143>
    idestart(b);
ffff800000103ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103ef5:	48 89 c7             	mov    %rax,%rdi
ffff800000103ef8:	48 b8 d1 3a 10 00 00 	movabs $0xffff800000103ad1,%rax
ffff800000103eff:	80 ff ff 
ffff800000103f02:	ff d0                	call   *%rax

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
ffff800000103f04:	eb 20                	jmp    ffff800000103f26 <iderw+0x143>
    sleep(b, &idelock);
ffff800000103f06:	48 ba c0 80 11 00 00 	movabs $0xffff8000001180c0,%rdx
ffff800000103f0d:	80 ff ff 
ffff800000103f10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103f14:	48 89 d6             	mov    %rdx,%rsi
ffff800000103f17:	48 89 c7             	mov    %rax,%rdi
ffff800000103f1a:	48 b8 d8 70 10 00 00 	movabs $0xffff8000001070d8,%rax
ffff800000103f21:	80 ff ff 
ffff800000103f24:	ff d0                	call   *%rax
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
ffff800000103f26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103f2a:	8b 00                	mov    (%rax),%eax
ffff800000103f2c:	83 e0 06             	and    $0x6,%eax
ffff800000103f2f:	83 f8 02             	cmp    $0x2,%eax
ffff800000103f32:	75 d2                	jne    ffff800000103f06 <iderw+0x123>
  }

  release(&idelock);
ffff800000103f34:	48 b8 c0 80 11 00 00 	movabs $0xffff8000001180c0,%rax
ffff800000103f3b:	80 ff ff 
ffff800000103f3e:	48 89 c7             	mov    %rax,%rdi
ffff800000103f41:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000103f48:	80 ff ff 
ffff800000103f4b:	ff d0                	call   *%rax
}
ffff800000103f4d:	90                   	nop
ffff800000103f4e:	c9                   	leave
ffff800000103f4f:	c3                   	ret

ffff800000103f50 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
ffff800000103f50:	55                   	push   %rbp
ffff800000103f51:	48 89 e5             	mov    %rsp,%rbp
ffff800000103f54:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103f58:	89 7d fc             	mov    %edi,-0x4(%rbp)
  ioapic->reg = reg;
ffff800000103f5b:	48 b8 38 81 11 00 00 	movabs $0xffff800000118138,%rax
ffff800000103f62:	80 ff ff 
ffff800000103f65:	48 8b 00             	mov    (%rax),%rax
ffff800000103f68:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103f6b:	89 10                	mov    %edx,(%rax)
  return ioapic->data;
ffff800000103f6d:	48 b8 38 81 11 00 00 	movabs $0xffff800000118138,%rax
ffff800000103f74:	80 ff ff 
ffff800000103f77:	48 8b 00             	mov    (%rax),%rax
ffff800000103f7a:	8b 40 10             	mov    0x10(%rax),%eax
}
ffff800000103f7d:	c9                   	leave
ffff800000103f7e:	c3                   	ret

ffff800000103f7f <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
ffff800000103f7f:	55                   	push   %rbp
ffff800000103f80:	48 89 e5             	mov    %rsp,%rbp
ffff800000103f83:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103f87:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103f8a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  ioapic->reg = reg;
ffff800000103f8d:	48 b8 38 81 11 00 00 	movabs $0xffff800000118138,%rax
ffff800000103f94:	80 ff ff 
ffff800000103f97:	48 8b 00             	mov    (%rax),%rax
ffff800000103f9a:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103f9d:	89 10                	mov    %edx,(%rax)
  ioapic->data = data;
ffff800000103f9f:	48 b8 38 81 11 00 00 	movabs $0xffff800000118138,%rax
ffff800000103fa6:	80 ff ff 
ffff800000103fa9:	48 8b 00             	mov    (%rax),%rax
ffff800000103fac:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff800000103faf:	89 50 10             	mov    %edx,0x10(%rax)
}
ffff800000103fb2:	90                   	nop
ffff800000103fb3:	c9                   	leave
ffff800000103fb4:	c3                   	ret

ffff800000103fb5 <ioapicinit>:

void
ioapicinit(void)
{
ffff800000103fb5:	55                   	push   %rbp
ffff800000103fb6:	48 89 e5             	mov    %rsp,%rbp
ffff800000103fb9:	48 83 ec 10          	sub    $0x10,%rsp
  int i, id, maxintr;

  ioapic = P2V((volatile struct ioapic*)IOAPIC);
ffff800000103fbd:	48 b8 38 81 11 00 00 	movabs $0xffff800000118138,%rax
ffff800000103fc4:	80 ff ff 
ffff800000103fc7:	48 b9 00 00 c0 fe 00 	movabs $0xffff8000fec00000,%rcx
ffff800000103fce:	80 ff ff 
ffff800000103fd1:	48 89 08             	mov    %rcx,(%rax)
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
ffff800000103fd4:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000103fd9:	48 b8 50 3f 10 00 00 	movabs $0xffff800000103f50,%rax
ffff800000103fe0:	80 ff ff 
ffff800000103fe3:	ff d0                	call   *%rax
ffff800000103fe5:	c1 e8 10             	shr    $0x10,%eax
ffff800000103fe8:	25 ff 00 00 00       	and    $0xff,%eax
ffff800000103fed:	89 45 f8             	mov    %eax,-0x8(%rbp)
  id = ioapicread(REG_ID) >> 24;
ffff800000103ff0:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000103ff5:	48 b8 50 3f 10 00 00 	movabs $0xffff800000103f50,%rax
ffff800000103ffc:	80 ff ff 
ffff800000103fff:	ff d0                	call   *%rax
ffff800000104001:	c1 e8 18             	shr    $0x18,%eax
ffff800000104004:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(id != ioapicid)
ffff800000104007:	48 b8 24 84 11 00 00 	movabs $0xffff800000118424,%rax
ffff80000010400e:	80 ff ff 
ffff800000104011:	0f b6 00             	movzbl (%rax),%eax
ffff800000104014:	0f b6 c0             	movzbl %al,%eax
ffff800000104017:	39 45 f4             	cmp    %eax,-0xc(%rbp)
ffff80000010401a:	74 1e                	je     ffff80000010403a <ioapicinit+0x85>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
ffff80000010401c:	48 b8 88 c8 10 00 00 	movabs $0xffff80000010c888,%rax
ffff800000104023:	80 ff ff 
ffff800000104026:	48 89 c7             	mov    %rax,%rdi
ffff800000104029:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010402e:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000104035:	80 ff ff 
ffff800000104038:	ff d2                	call   *%rdx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
ffff80000010403a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104041:	eb 47                	jmp    ffff80000010408a <ioapicinit+0xd5>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
ffff800000104043:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104046:	83 c0 20             	add    $0x20,%eax
ffff800000104049:	0d 00 00 01 00       	or     $0x10000,%eax
ffff80000010404e:	89 c2                	mov    %eax,%edx
ffff800000104050:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104053:	83 c0 08             	add    $0x8,%eax
ffff800000104056:	01 c0                	add    %eax,%eax
ffff800000104058:	89 d6                	mov    %edx,%esi
ffff80000010405a:	89 c7                	mov    %eax,%edi
ffff80000010405c:	48 b8 7f 3f 10 00 00 	movabs $0xffff800000103f7f,%rax
ffff800000104063:	80 ff ff 
ffff800000104066:	ff d0                	call   *%rax
    ioapicwrite(REG_TABLE+2*i+1, 0);
ffff800000104068:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010406b:	83 c0 08             	add    $0x8,%eax
ffff80000010406e:	01 c0                	add    %eax,%eax
ffff800000104070:	83 c0 01             	add    $0x1,%eax
ffff800000104073:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104078:	89 c7                	mov    %eax,%edi
ffff80000010407a:	48 b8 7f 3f 10 00 00 	movabs $0xffff800000103f7f,%rax
ffff800000104081:	80 ff ff 
ffff800000104084:	ff d0                	call   *%rax
  for(i = 0; i <= maxintr; i++){
ffff800000104086:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010408a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010408d:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffff800000104090:	7e b1                	jle    ffff800000104043 <ioapicinit+0x8e>
  }
}
ffff800000104092:	90                   	nop
ffff800000104093:	90                   	nop
ffff800000104094:	c9                   	leave
ffff800000104095:	c3                   	ret

ffff800000104096 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
ffff800000104096:	55                   	push   %rbp
ffff800000104097:	48 89 e5             	mov    %rsp,%rbp
ffff80000010409a:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010409e:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff8000001040a1:	89 75 f8             	mov    %esi,-0x8(%rbp)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
ffff8000001040a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001040a7:	83 c0 20             	add    $0x20,%eax
ffff8000001040aa:	89 c2                	mov    %eax,%edx
ffff8000001040ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001040af:	83 c0 08             	add    $0x8,%eax
ffff8000001040b2:	01 c0                	add    %eax,%eax
ffff8000001040b4:	89 d6                	mov    %edx,%esi
ffff8000001040b6:	89 c7                	mov    %eax,%edi
ffff8000001040b8:	48 b8 7f 3f 10 00 00 	movabs $0xffff800000103f7f,%rax
ffff8000001040bf:	80 ff ff 
ffff8000001040c2:	ff d0                	call   *%rax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
ffff8000001040c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001040c7:	c1 e0 18             	shl    $0x18,%eax
ffff8000001040ca:	89 c2                	mov    %eax,%edx
ffff8000001040cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001040cf:	83 c0 08             	add    $0x8,%eax
ffff8000001040d2:	01 c0                	add    %eax,%eax
ffff8000001040d4:	83 c0 01             	add    $0x1,%eax
ffff8000001040d7:	89 d6                	mov    %edx,%esi
ffff8000001040d9:	89 c7                	mov    %eax,%edi
ffff8000001040db:	48 b8 7f 3f 10 00 00 	movabs $0xffff800000103f7f,%rax
ffff8000001040e2:	80 ff ff 
ffff8000001040e5:	ff d0                	call   *%rax
}
ffff8000001040e7:	90                   	nop
ffff8000001040e8:	c9                   	leave
ffff8000001040e9:	c3                   	ret

ffff8000001040ea <kinit1>:
  struct run *freelist;
} kmem;

void
kinit1(void *vstart, void *vend)
{
ffff8000001040ea:	55                   	push   %rbp
ffff8000001040eb:	48 89 e5             	mov    %rsp,%rbp
ffff8000001040ee:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001040f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001040f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  initlock(&kmem.lock, "kmem");
ffff8000001040fa:	48 ba ba c8 10 00 00 	movabs $0xffff80000010c8ba,%rdx
ffff800000104101:	80 ff ff 
ffff800000104104:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff80000010410b:	80 ff ff 
ffff80000010410e:	48 89 d6             	mov    %rdx,%rsi
ffff800000104111:	48 89 c7             	mov    %rax,%rdi
ffff800000104114:	48 b8 a5 76 10 00 00 	movabs $0xffff8000001076a5,%rax
ffff80000010411b:	80 ff ff 
ffff80000010411e:	ff d0                	call   *%rax
  kmem.use_lock = 0;
ffff800000104120:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff800000104127:	80 ff ff 
ffff80000010412a:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
  kmem.freelist = 0; // empty
ffff800000104131:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff800000104138:	80 ff ff 
ffff80000010413b:	48 c7 40 70 00 00 00 	movq   $0x0,0x70(%rax)
ffff800000104142:	00 
  freerange(vstart, vend);
ffff800000104143:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000104147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010414b:	48 89 d6             	mov    %rdx,%rsi
ffff80000010414e:	48 89 c7             	mov    %rax,%rdi
ffff800000104151:	48 b8 78 41 10 00 00 	movabs $0xffff800000104178,%rax
ffff800000104158:	80 ff ff 
ffff80000010415b:	ff d0                	call   *%rax
}
ffff80000010415d:	90                   	nop
ffff80000010415e:	c9                   	leave
ffff80000010415f:	c3                   	ret

ffff800000104160 <kinit2>:

void
kinit2()
{
ffff800000104160:	55                   	push   %rbp
ffff800000104161:	48 89 e5             	mov    %rsp,%rbp
  kmem.use_lock = 1;
ffff800000104164:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff80000010416b:	80 ff ff 
ffff80000010416e:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%rax)
}
ffff800000104175:	90                   	nop
ffff800000104176:	5d                   	pop    %rbp
ffff800000104177:	c3                   	ret

ffff800000104178 <freerange>:

void
freerange(void *vstart, void *vend)
{
ffff800000104178:	55                   	push   %rbp
ffff800000104179:	48 89 e5             	mov    %rsp,%rbp
ffff80000010417c:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000104180:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000104184:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *p;
  p = (char*)PGROUNDUP((addr_t)vstart);
ffff800000104188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010418c:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff800000104192:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff800000104198:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
ffff80000010419c:	eb 1b                	jmp    ffff8000001041b9 <freerange+0x41>
    kfree(p);
ffff80000010419e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001041a2:	48 89 c7             	mov    %rax,%rdi
ffff8000001041a5:	48 b8 cd 41 10 00 00 	movabs $0xffff8000001041cd,%rax
ffff8000001041ac:	80 ff ff 
ffff8000001041af:	ff d0                	call   *%rax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
ffff8000001041b1:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff8000001041b8:	00 
ffff8000001041b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001041bd:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff8000001041c3:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
ffff8000001041c7:	73 d5                	jae    ffff80000010419e <freerange+0x26>
}
ffff8000001041c9:	90                   	nop
ffff8000001041ca:	90                   	nop
ffff8000001041cb:	c9                   	leave
ffff8000001041cc:	c3                   	ret

ffff8000001041cd <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
ffff8000001041cd:	55                   	push   %rbp
ffff8000001041ce:	48 89 e5             	mov    %rsp,%rbp
ffff8000001041d1:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001041d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct run *r;

  if((addr_t)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
ffff8000001041d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001041dd:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff8000001041e2:	48 85 c0             	test   %rax,%rax
ffff8000001041e5:	75 29                	jne    ffff800000104210 <kfree+0x43>
ffff8000001041e7:	48 b8 00 e0 11 00 00 	movabs $0xffff80000011e000,%rax
ffff8000001041ee:	80 ff ff 
ffff8000001041f1:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff8000001041f5:	72 19                	jb     ffff800000104210 <kfree+0x43>
ffff8000001041f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001041fb:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff800000104202:	80 00 00 
ffff800000104205:	48 01 d0             	add    %rdx,%rax
ffff800000104208:	48 3d ff ff ff 0d    	cmp    $0xdffffff,%rax
ffff80000010420e:	76 19                	jbe    ffff800000104229 <kfree+0x5c>
    panic("kfree");
ffff800000104210:	48 b8 bf c8 10 00 00 	movabs $0xffff80000010c8bf,%rax
ffff800000104217:	80 ff ff 
ffff80000010421a:	48 89 c7             	mov    %rax,%rdi
ffff80000010421d:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000104224:	80 ff ff 
ffff800000104227:	ff d0                	call   *%rax

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
ffff800000104229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010422d:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff800000104232:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000104237:	48 89 c7             	mov    %rax,%rdi
ffff80000010423a:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff800000104241:	80 ff ff 
ffff800000104244:	ff d0                	call   *%rax

  if(kmem.use_lock)
ffff800000104246:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff80000010424d:	80 ff ff 
ffff800000104250:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104253:	85 c0                	test   %eax,%eax
ffff800000104255:	74 19                	je     ffff800000104270 <kfree+0xa3>
    acquire(&kmem.lock);
ffff800000104257:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff80000010425e:	80 ff ff 
ffff800000104261:	48 89 c7             	mov    %rax,%rdi
ffff800000104264:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff80000010426b:	80 ff ff 
ffff80000010426e:	ff d0                	call   *%rax
  r = (struct run*)v;
ffff800000104270:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104274:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  r->next = kmem.freelist;
ffff800000104278:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff80000010427f:	80 ff ff 
ffff800000104282:	48 8b 50 70          	mov    0x70(%rax),%rdx
ffff800000104286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010428a:	48 89 10             	mov    %rdx,(%rax)
  kmem.freelist = r;
ffff80000010428d:	48 ba 40 81 11 00 00 	movabs $0xffff800000118140,%rdx
ffff800000104294:	80 ff ff 
ffff800000104297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010429b:	48 89 42 70          	mov    %rax,0x70(%rdx)
  if(kmem.use_lock)
ffff80000010429f:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff8000001042a6:	80 ff ff 
ffff8000001042a9:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001042ac:	85 c0                	test   %eax,%eax
ffff8000001042ae:	74 19                	je     ffff8000001042c9 <kfree+0xfc>
    release(&kmem.lock);
ffff8000001042b0:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff8000001042b7:	80 ff ff 
ffff8000001042ba:	48 89 c7             	mov    %rax,%rdi
ffff8000001042bd:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001042c4:	80 ff ff 
ffff8000001042c7:	ff d0                	call   *%rax
  if(kmem.use_lock)
ffff8000001042c9:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff8000001042d0:	80 ff ff 
ffff8000001042d3:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001042d6:	85 c0                	test   %eax,%eax
ffff8000001042d8:	74 58                	je     ffff800000104332 <kfree+0x165>
    traceevent(TRACE_TYPE_MEM, proc ? proc->pid : 0, V2P(v), 0, 0, "kfree");
ffff8000001042da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001042de:	89 c6                	mov    %eax,%esi
ffff8000001042e0:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001042e7:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001042eb:	48 85 c0             	test   %rax,%rax
ffff8000001042ee:	74 10                	je     ffff800000104300 <kfree+0x133>
ffff8000001042f0:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001042f7:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001042fb:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff8000001042fe:	eb 05                	jmp    ffff800000104305 <kfree+0x138>
ffff800000104300:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000104305:	48 ba bf c8 10 00 00 	movabs $0xffff80000010c8bf,%rdx
ffff80000010430c:	80 ff ff 
ffff80000010430f:	49 89 d1             	mov    %rdx,%r9
ffff800000104312:	41 b8 00 00 00 00    	mov    $0x0,%r8d
ffff800000104318:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff80000010431d:	89 f2                	mov    %esi,%edx
ffff80000010431f:	89 c6                	mov    %eax,%esi
ffff800000104321:	bf 04 00 00 00       	mov    $0x4,%edi
ffff800000104326:	48 b8 d3 c2 10 00 00 	movabs $0xffff80000010c2d3,%rax
ffff80000010432d:	80 ff ff 
ffff800000104330:	ff d0                	call   *%rax
}
ffff800000104332:	90                   	nop
ffff800000104333:	c9                   	leave
ffff800000104334:	c3                   	ret

ffff800000104335 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
ffff800000104335:	55                   	push   %rbp
ffff800000104336:	48 89 e5             	mov    %rsp,%rbp
ffff800000104339:	48 83 ec 10          	sub    $0x10,%rsp
  struct run *r;

  if(kmem.use_lock)
ffff80000010433d:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff800000104344:	80 ff ff 
ffff800000104347:	8b 40 68             	mov    0x68(%rax),%eax
ffff80000010434a:	85 c0                	test   %eax,%eax
ffff80000010434c:	74 19                	je     ffff800000104367 <kalloc+0x32>
    acquire(&kmem.lock);
ffff80000010434e:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff800000104355:	80 ff ff 
ffff800000104358:	48 89 c7             	mov    %rax,%rdi
ffff80000010435b:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000104362:	80 ff ff 
ffff800000104365:	ff d0                	call   *%rax
  r = kmem.freelist;
ffff800000104367:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff80000010436e:	80 ff ff 
ffff800000104371:	48 8b 40 70          	mov    0x70(%rax),%rax
ffff800000104375:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(r)
ffff800000104379:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010437e:	74 28                	je     ffff8000001043a8 <kalloc+0x73>
    kmem.freelist = r->next;
ffff800000104380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104384:	48 8b 00             	mov    (%rax),%rax
ffff800000104387:	48 ba 40 81 11 00 00 	movabs $0xffff800000118140,%rdx
ffff80000010438e:	80 ff ff 
ffff800000104391:	48 89 42 70          	mov    %rax,0x70(%rdx)
  else {
    panic("Out of memory!");
  }
  
  if(kmem.use_lock)
ffff800000104395:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff80000010439c:	80 ff ff 
ffff80000010439f:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001043a2:	85 c0                	test   %eax,%eax
ffff8000001043a4:	74 34                	je     ffff8000001043da <kalloc+0xa5>
ffff8000001043a6:	eb 19                	jmp    ffff8000001043c1 <kalloc+0x8c>
    panic("Out of memory!");
ffff8000001043a8:	48 b8 c5 c8 10 00 00 	movabs $0xffff80000010c8c5,%rax
ffff8000001043af:	80 ff ff 
ffff8000001043b2:	48 89 c7             	mov    %rax,%rdi
ffff8000001043b5:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001043bc:	80 ff ff 
ffff8000001043bf:	ff d0                	call   *%rax
    release(&kmem.lock);
ffff8000001043c1:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff8000001043c8:	80 ff ff 
ffff8000001043cb:	48 89 c7             	mov    %rax,%rdi
ffff8000001043ce:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001043d5:	80 ff ff 
ffff8000001043d8:	ff d0                	call   *%rax
  //need to call this conditional again because it uses a lock
  if(kmem.use_lock && r)
ffff8000001043da:	48 b8 40 81 11 00 00 	movabs $0xffff800000118140,%rax
ffff8000001043e1:	80 ff ff 
ffff8000001043e4:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001043e7:	85 c0                	test   %eax,%eax
ffff8000001043e9:	74 5f                	je     ffff80000010444a <kalloc+0x115>
ffff8000001043eb:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001043f0:	74 58                	je     ffff80000010444a <kalloc+0x115>
    traceevent(TRACE_TYPE_MEM, proc ? proc->pid : 0, V2P((char*)r), 0, 0, "kalloc");
ffff8000001043f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001043f6:	89 c6                	mov    %eax,%esi
ffff8000001043f8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001043ff:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000104403:	48 85 c0             	test   %rax,%rax
ffff800000104406:	74 10                	je     ffff800000104418 <kalloc+0xe3>
ffff800000104408:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010440f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000104413:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000104416:	eb 05                	jmp    ffff80000010441d <kalloc+0xe8>
ffff800000104418:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010441d:	48 ba d4 c8 10 00 00 	movabs $0xffff80000010c8d4,%rdx
ffff800000104424:	80 ff ff 
ffff800000104427:	49 89 d1             	mov    %rdx,%r9
ffff80000010442a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
ffff800000104430:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff800000104435:	89 f2                	mov    %esi,%edx
ffff800000104437:	89 c6                	mov    %eax,%esi
ffff800000104439:	bf 04 00 00 00       	mov    $0x4,%edi
ffff80000010443e:	48 b8 d3 c2 10 00 00 	movabs $0xffff80000010c2d3,%rax
ffff800000104445:	80 ff ff 
ffff800000104448:	ff d0                	call   *%rax

  return (char*)r;
ffff80000010444a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010444e:	c9                   	leave
ffff80000010444f:	c3                   	ret

ffff800000104450 <inb>:
{
ffff800000104450:	55                   	push   %rbp
ffff800000104451:	48 89 e5             	mov    %rsp,%rbp
ffff800000104454:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000104458:	89 f8                	mov    %edi,%eax
ffff80000010445a:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff80000010445e:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000104462:	89 c2                	mov    %eax,%edx
ffff800000104464:	ec                   	in     (%dx),%al
ffff800000104465:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff800000104468:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010446c:	c9                   	leave
ffff80000010446d:	c3                   	ret

ffff80000010446e <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
ffff80000010446e:	55                   	push   %rbp
ffff80000010446f:	48 89 e5             	mov    %rsp,%rbp
ffff800000104472:	48 83 ec 10          	sub    $0x10,%rsp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
ffff800000104476:	bf 64 00 00 00       	mov    $0x64,%edi
ffff80000010447b:	48 b8 50 44 10 00 00 	movabs $0xffff800000104450,%rax
ffff800000104482:	80 ff ff 
ffff800000104485:	ff d0                	call   *%rax
ffff800000104487:	0f b6 c0             	movzbl %al,%eax
ffff80000010448a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if((st & KBS_DIB) == 0)
ffff80000010448d:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000104490:	83 e0 01             	and    $0x1,%eax
ffff800000104493:	85 c0                	test   %eax,%eax
ffff800000104495:	75 0a                	jne    ffff8000001044a1 <kbdgetc+0x33>
    return -1;
ffff800000104497:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010449c:	e9 a4 01 00 00       	jmp    ffff800000104645 <kbdgetc+0x1d7>
  data = inb(KBDATAP);
ffff8000001044a1:	bf 60 00 00 00       	mov    $0x60,%edi
ffff8000001044a6:	48 b8 50 44 10 00 00 	movabs $0xffff800000104450,%rax
ffff8000001044ad:	80 ff ff 
ffff8000001044b0:	ff d0                	call   *%rax
ffff8000001044b2:	0f b6 c0             	movzbl %al,%eax
ffff8000001044b5:	89 45 fc             	mov    %eax,-0x4(%rbp)

  if(data == 0xE0){
ffff8000001044b8:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%rbp)
ffff8000001044bf:	75 27                	jne    ffff8000001044e8 <kbdgetc+0x7a>
    shift |= E0ESC;
ffff8000001044c1:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff8000001044c8:	80 ff ff 
ffff8000001044cb:	8b 00                	mov    (%rax),%eax
ffff8000001044cd:	83 c8 40             	or     $0x40,%eax
ffff8000001044d0:	89 c2                	mov    %eax,%edx
ffff8000001044d2:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff8000001044d9:	80 ff ff 
ffff8000001044dc:	89 10                	mov    %edx,(%rax)
    return 0;
ffff8000001044de:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001044e3:	e9 5d 01 00 00       	jmp    ffff800000104645 <kbdgetc+0x1d7>
  } else if(data & 0x80){
ffff8000001044e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001044eb:	25 80 00 00 00       	and    $0x80,%eax
ffff8000001044f0:	85 c0                	test   %eax,%eax
ffff8000001044f2:	74 56                	je     ffff80000010454a <kbdgetc+0xdc>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
ffff8000001044f4:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff8000001044fb:	80 ff ff 
ffff8000001044fe:	8b 00                	mov    (%rax),%eax
ffff800000104500:	83 e0 40             	and    $0x40,%eax
ffff800000104503:	85 c0                	test   %eax,%eax
ffff800000104505:	75 04                	jne    ffff80000010450b <kbdgetc+0x9d>
ffff800000104507:	83 65 fc 7f          	andl   $0x7f,-0x4(%rbp)
    shift &= ~(shiftcode[data] | E0ESC);
ffff80000010450b:	48 ba 20 d0 10 00 00 	movabs $0xffff80000010d020,%rdx
ffff800000104512:	80 ff ff 
ffff800000104515:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104518:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff80000010451c:	83 c8 40             	or     $0x40,%eax
ffff80000010451f:	0f b6 c0             	movzbl %al,%eax
ffff800000104522:	f7 d0                	not    %eax
ffff800000104524:	89 c2                	mov    %eax,%edx
ffff800000104526:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff80000010452d:	80 ff ff 
ffff800000104530:	8b 00                	mov    (%rax),%eax
ffff800000104532:	21 c2                	and    %eax,%edx
ffff800000104534:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff80000010453b:	80 ff ff 
ffff80000010453e:	89 10                	mov    %edx,(%rax)
    return 0;
ffff800000104540:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000104545:	e9 fb 00 00 00       	jmp    ffff800000104645 <kbdgetc+0x1d7>
  } else if(shift & E0ESC){
ffff80000010454a:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff800000104551:	80 ff ff 
ffff800000104554:	8b 00                	mov    (%rax),%eax
ffff800000104556:	83 e0 40             	and    $0x40,%eax
ffff800000104559:	85 c0                	test   %eax,%eax
ffff80000010455b:	74 24                	je     ffff800000104581 <kbdgetc+0x113>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
ffff80000010455d:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%rbp)
    shift &= ~E0ESC;
ffff800000104564:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff80000010456b:	80 ff ff 
ffff80000010456e:	8b 00                	mov    (%rax),%eax
ffff800000104570:	83 e0 bf             	and    $0xffffffbf,%eax
ffff800000104573:	89 c2                	mov    %eax,%edx
ffff800000104575:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff80000010457c:	80 ff ff 
ffff80000010457f:	89 10                	mov    %edx,(%rax)
  }

  shift |= shiftcode[data];
ffff800000104581:	48 ba 20 d0 10 00 00 	movabs $0xffff80000010d020,%rdx
ffff800000104588:	80 ff ff 
ffff80000010458b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010458e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff800000104592:	0f b6 d0             	movzbl %al,%edx
ffff800000104595:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff80000010459c:	80 ff ff 
ffff80000010459f:	8b 00                	mov    (%rax),%eax
ffff8000001045a1:	09 c2                	or     %eax,%edx
ffff8000001045a3:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff8000001045aa:	80 ff ff 
ffff8000001045ad:	89 10                	mov    %edx,(%rax)
  shift ^= togglecode[data];
ffff8000001045af:	48 ba 20 d1 10 00 00 	movabs $0xffff80000010d120,%rdx
ffff8000001045b6:	80 ff ff 
ffff8000001045b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001045bc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff8000001045c0:	0f b6 d0             	movzbl %al,%edx
ffff8000001045c3:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff8000001045ca:	80 ff ff 
ffff8000001045cd:	8b 00                	mov    (%rax),%eax
ffff8000001045cf:	31 c2                	xor    %eax,%edx
ffff8000001045d1:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff8000001045d8:	80 ff ff 
ffff8000001045db:	89 10                	mov    %edx,(%rax)
  c = charcode[shift & (CTL | SHIFT)][data];
ffff8000001045dd:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff8000001045e4:	80 ff ff 
ffff8000001045e7:	8b 00                	mov    (%rax),%eax
ffff8000001045e9:	83 e0 03             	and    $0x3,%eax
ffff8000001045ec:	89 c2                	mov    %eax,%edx
ffff8000001045ee:	48 b8 20 d5 10 00 00 	movabs $0xffff80000010d520,%rax
ffff8000001045f5:	80 ff ff 
ffff8000001045f8:	89 d2                	mov    %edx,%edx
ffff8000001045fa:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
ffff8000001045fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104601:	48 01 d0             	add    %rdx,%rax
ffff800000104604:	0f b6 00             	movzbl (%rax),%eax
ffff800000104607:	0f b6 c0             	movzbl %al,%eax
ffff80000010460a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(shift & CAPSLOCK){
ffff80000010460d:	48 b8 b8 81 11 00 00 	movabs $0xffff8000001181b8,%rax
ffff800000104614:	80 ff ff 
ffff800000104617:	8b 00                	mov    (%rax),%eax
ffff800000104619:	83 e0 08             	and    $0x8,%eax
ffff80000010461c:	85 c0                	test   %eax,%eax
ffff80000010461e:	74 22                	je     ffff800000104642 <kbdgetc+0x1d4>
    if('a' <= c && c <= 'z')
ffff800000104620:	83 7d f8 60          	cmpl   $0x60,-0x8(%rbp)
ffff800000104624:	76 0c                	jbe    ffff800000104632 <kbdgetc+0x1c4>
ffff800000104626:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%rbp)
ffff80000010462a:	77 06                	ja     ffff800000104632 <kbdgetc+0x1c4>
      c += 'A' - 'a';
ffff80000010462c:	83 6d f8 20          	subl   $0x20,-0x8(%rbp)
ffff800000104630:	eb 10                	jmp    ffff800000104642 <kbdgetc+0x1d4>
    else if('A' <= c && c <= 'Z')
ffff800000104632:	83 7d f8 40          	cmpl   $0x40,-0x8(%rbp)
ffff800000104636:	76 0a                	jbe    ffff800000104642 <kbdgetc+0x1d4>
ffff800000104638:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%rbp)
ffff80000010463c:	77 04                	ja     ffff800000104642 <kbdgetc+0x1d4>
      c += 'a' - 'A';
ffff80000010463e:	83 45 f8 20          	addl   $0x20,-0x8(%rbp)
  }
  return c;
ffff800000104642:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
ffff800000104645:	c9                   	leave
ffff800000104646:	c3                   	ret

ffff800000104647 <kbdintr>:

void
kbdintr(void)
{
ffff800000104647:	55                   	push   %rbp
ffff800000104648:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(kbdgetc);
ffff80000010464b:	48 b8 6e 44 10 00 00 	movabs $0xffff80000010446e,%rax
ffff800000104652:	80 ff ff 
ffff800000104655:	48 89 c7             	mov    %rax,%rdi
ffff800000104658:	48 b8 97 10 10 00 00 	movabs $0xffff800000101097,%rax
ffff80000010465f:	80 ff ff 
ffff800000104662:	ff d0                	call   *%rax
}
ffff800000104664:	90                   	nop
ffff800000104665:	5d                   	pop    %rbp
ffff800000104666:	c3                   	ret

ffff800000104667 <inb>:
{
ffff800000104667:	55                   	push   %rbp
ffff800000104668:	48 89 e5             	mov    %rsp,%rbp
ffff80000010466b:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010466f:	89 f8                	mov    %edi,%eax
ffff800000104671:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff800000104675:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000104679:	89 c2                	mov    %eax,%edx
ffff80000010467b:	ec                   	in     (%dx),%al
ffff80000010467c:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff80000010467f:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff800000104683:	c9                   	leave
ffff800000104684:	c3                   	ret

ffff800000104685 <outb>:
{
ffff800000104685:	55                   	push   %rbp
ffff800000104686:	48 89 e5             	mov    %rsp,%rbp
ffff800000104689:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010468d:	89 fa                	mov    %edi,%edx
ffff80000010468f:	89 f0                	mov    %esi,%eax
ffff800000104691:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffff800000104695:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000104698:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff80000010469c:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff8000001046a0:	ee                   	out    %al,(%dx)
}
ffff8000001046a1:	90                   	nop
ffff8000001046a2:	c9                   	leave
ffff8000001046a3:	c3                   	ret

ffff8000001046a4 <readeflags>:
{
ffff8000001046a4:	55                   	push   %rbp
ffff8000001046a5:	48 89 e5             	mov    %rsp,%rbp
ffff8000001046a8:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff8000001046ac:	9c                   	pushf
ffff8000001046ad:	58                   	pop    %rax
ffff8000001046ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff8000001046b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001046b6:	c9                   	leave
ffff8000001046b7:	c3                   	ret

ffff8000001046b8 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
ffff8000001046b8:	55                   	push   %rbp
ffff8000001046b9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001046bc:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001046c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff8000001046c3:	89 75 f8             	mov    %esi,-0x8(%rbp)
  lapic[index] = value;
ffff8000001046c6:	48 b8 c0 81 11 00 00 	movabs $0xffff8000001181c0,%rax
ffff8000001046cd:	80 ff ff 
ffff8000001046d0:	48 8b 00             	mov    (%rax),%rax
ffff8000001046d3:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001046d6:	48 63 d2             	movslq %edx,%rdx
ffff8000001046d9:	48 c1 e2 02          	shl    $0x2,%rdx
ffff8000001046dd:	48 01 c2             	add    %rax,%rdx
ffff8000001046e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001046e3:	89 02                	mov    %eax,(%rdx)
  lapic[ID];  // wait for write to finish, by reading
ffff8000001046e5:	48 b8 c0 81 11 00 00 	movabs $0xffff8000001181c0,%rax
ffff8000001046ec:	80 ff ff 
ffff8000001046ef:	48 8b 00             	mov    (%rax),%rax
ffff8000001046f2:	48 83 c0 20          	add    $0x20,%rax
ffff8000001046f6:	8b 00                	mov    (%rax),%eax
}
ffff8000001046f8:	90                   	nop
ffff8000001046f9:	c9                   	leave
ffff8000001046fa:	c3                   	ret

ffff8000001046fb <lapicinit>:

void
lapicinit(void)
{
ffff8000001046fb:	55                   	push   %rbp
ffff8000001046fc:	48 89 e5             	mov    %rsp,%rbp
  if(!lapic)
ffff8000001046ff:	48 b8 c0 81 11 00 00 	movabs $0xffff8000001181c0,%rax
ffff800000104706:	80 ff ff 
ffff800000104709:	48 8b 00             	mov    (%rax),%rax
ffff80000010470c:	48 85 c0             	test   %rax,%rax
ffff80000010470f:	0f 84 71 01 00 00    	je     ffff800000104886 <lapicinit+0x18b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
ffff800000104715:	be 3f 01 00 00       	mov    $0x13f,%esi
ffff80000010471a:	bf 3c 00 00 00       	mov    $0x3c,%edi
ffff80000010471f:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff800000104726:	80 ff ff 
ffff800000104729:	ff d0                	call   *%rax

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
ffff80000010472b:	be 0b 00 00 00       	mov    $0xb,%esi
ffff800000104730:	bf f8 00 00 00       	mov    $0xf8,%edi
ffff800000104735:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff80000010473c:	80 ff ff 
ffff80000010473f:	ff d0                	call   *%rax
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
ffff800000104741:	be 20 00 02 00       	mov    $0x20020,%esi
ffff800000104746:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff80000010474b:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff800000104752:	80 ff ff 
ffff800000104755:	ff d0                	call   *%rax
  lapicw(TICR, 10000000);
ffff800000104757:	be 80 96 98 00       	mov    $0x989680,%esi
ffff80000010475c:	bf e0 00 00 00       	mov    $0xe0,%edi
ffff800000104761:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff800000104768:	80 ff ff 
ffff80000010476b:	ff d0                	call   *%rax

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
ffff80000010476d:	be 00 00 01 00       	mov    $0x10000,%esi
ffff800000104772:	bf d4 00 00 00       	mov    $0xd4,%edi
ffff800000104777:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff80000010477e:	80 ff ff 
ffff800000104781:	ff d0                	call   *%rax
  lapicw(LINT1, MASKED);
ffff800000104783:	be 00 00 01 00       	mov    $0x10000,%esi
ffff800000104788:	bf d8 00 00 00       	mov    $0xd8,%edi
ffff80000010478d:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff800000104794:	80 ff ff 
ffff800000104797:	ff d0                	call   *%rax

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
ffff800000104799:	48 b8 c0 81 11 00 00 	movabs $0xffff8000001181c0,%rax
ffff8000001047a0:	80 ff ff 
ffff8000001047a3:	48 8b 00             	mov    (%rax),%rax
ffff8000001047a6:	48 83 c0 30          	add    $0x30,%rax
ffff8000001047aa:	8b 00                	mov    (%rax),%eax
ffff8000001047ac:	25 00 00 fc 00       	and    $0xfc0000,%eax
ffff8000001047b1:	85 c0                	test   %eax,%eax
ffff8000001047b3:	74 16                	je     ffff8000001047cb <lapicinit+0xd0>
    lapicw(PCINT, MASKED);
ffff8000001047b5:	be 00 00 01 00       	mov    $0x10000,%esi
ffff8000001047ba:	bf d0 00 00 00       	mov    $0xd0,%edi
ffff8000001047bf:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff8000001047c6:	80 ff ff 
ffff8000001047c9:	ff d0                	call   *%rax

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
ffff8000001047cb:	be 33 00 00 00       	mov    $0x33,%esi
ffff8000001047d0:	bf dc 00 00 00       	mov    $0xdc,%edi
ffff8000001047d5:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff8000001047dc:	80 ff ff 
ffff8000001047df:	ff d0                	call   *%rax

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
ffff8000001047e1:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001047e6:	bf a0 00 00 00       	mov    $0xa0,%edi
ffff8000001047eb:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff8000001047f2:	80 ff ff 
ffff8000001047f5:	ff d0                	call   *%rax
  lapicw(ESR, 0);
ffff8000001047f7:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001047fc:	bf a0 00 00 00       	mov    $0xa0,%edi
ffff800000104801:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff800000104808:	80 ff ff 
ffff80000010480b:	ff d0                	call   *%rax

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
ffff80000010480d:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104812:	bf 2c 00 00 00       	mov    $0x2c,%edi
ffff800000104817:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff80000010481e:	80 ff ff 
ffff800000104821:	ff d0                	call   *%rax

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
ffff800000104823:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104828:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff80000010482d:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff800000104834:	80 ff ff 
ffff800000104837:	ff d0                	call   *%rax
  lapicw(ICRLO, BCAST | INIT | LEVEL);
ffff800000104839:	be 00 85 08 00       	mov    $0x88500,%esi
ffff80000010483e:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104843:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff80000010484a:	80 ff ff 
ffff80000010484d:	ff d0                	call   *%rax
  while(lapic[ICRLO] & DELIVS)
ffff80000010484f:	90                   	nop
ffff800000104850:	48 b8 c0 81 11 00 00 	movabs $0xffff8000001181c0,%rax
ffff800000104857:	80 ff ff 
ffff80000010485a:	48 8b 00             	mov    (%rax),%rax
ffff80000010485d:	48 05 00 03 00 00    	add    $0x300,%rax
ffff800000104863:	8b 00                	mov    (%rax),%eax
ffff800000104865:	25 00 10 00 00       	and    $0x1000,%eax
ffff80000010486a:	85 c0                	test   %eax,%eax
ffff80000010486c:	75 e2                	jne    ffff800000104850 <lapicinit+0x155>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
ffff80000010486e:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104873:	bf 20 00 00 00       	mov    $0x20,%edi
ffff800000104878:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff80000010487f:	80 ff ff 
ffff800000104882:	ff d0                	call   *%rax
ffff800000104884:	eb 01                	jmp    ffff800000104887 <lapicinit+0x18c>
    return;
ffff800000104886:	90                   	nop
}
ffff800000104887:	5d                   	pop    %rbp
ffff800000104888:	c3                   	ret

ffff800000104889 <cpunum>:

int
cpunum(void)
{
ffff800000104889:	55                   	push   %rbp
ffff80000010488a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010488d:	48 83 ec 10          	sub    $0x10,%rsp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
ffff800000104891:	48 b8 a4 46 10 00 00 	movabs $0xffff8000001046a4,%rax
ffff800000104898:	80 ff ff 
ffff80000010489b:	ff d0                	call   *%rax
ffff80000010489d:	25 00 02 00 00       	and    $0x200,%eax
ffff8000001048a2:	48 85 c0             	test   %rax,%rax
ffff8000001048a5:	74 47                	je     ffff8000001048ee <cpunum+0x65>
    static int n;
    if(n++ == 0)
ffff8000001048a7:	48 b8 c8 81 11 00 00 	movabs $0xffff8000001181c8,%rax
ffff8000001048ae:	80 ff ff 
ffff8000001048b1:	8b 00                	mov    (%rax),%eax
ffff8000001048b3:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001048b6:	48 b9 c8 81 11 00 00 	movabs $0xffff8000001181c8,%rcx
ffff8000001048bd:	80 ff ff 
ffff8000001048c0:	89 11                	mov    %edx,(%rcx)
ffff8000001048c2:	85 c0                	test   %eax,%eax
ffff8000001048c4:	75 28                	jne    ffff8000001048ee <cpunum+0x65>
      cprintf("cpu called from %x with interrupts enabled\n",
ffff8000001048c6:	48 8b 45 08          	mov    0x8(%rbp),%rax
ffff8000001048ca:	48 89 c2             	mov    %rax,%rdx
ffff8000001048cd:	48 b8 e0 c8 10 00 00 	movabs $0xffff80000010c8e0,%rax
ffff8000001048d4:	80 ff ff 
ffff8000001048d7:	48 89 d6             	mov    %rdx,%rsi
ffff8000001048da:	48 89 c7             	mov    %rax,%rdi
ffff8000001048dd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001048e2:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff8000001048e9:	80 ff ff 
ffff8000001048ec:	ff d2                	call   *%rdx
        __builtin_return_address(0));
  }

  if (!lapic)
ffff8000001048ee:	48 b8 c0 81 11 00 00 	movabs $0xffff8000001181c0,%rax
ffff8000001048f5:	80 ff ff 
ffff8000001048f8:	48 8b 00             	mov    (%rax),%rax
ffff8000001048fb:	48 85 c0             	test   %rax,%rax
ffff8000001048fe:	75 0a                	jne    ffff80000010490a <cpunum+0x81>
    return 0;
ffff800000104900:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000104905:	e9 85 00 00 00       	jmp    ffff80000010498f <cpunum+0x106>

  apicid = lapic[ID] >> 24;
ffff80000010490a:	48 b8 c0 81 11 00 00 	movabs $0xffff8000001181c0,%rax
ffff800000104911:	80 ff ff 
ffff800000104914:	48 8b 00             	mov    (%rax),%rax
ffff800000104917:	48 83 c0 20          	add    $0x20,%rax
ffff80000010491b:	8b 00                	mov    (%rax),%eax
ffff80000010491d:	c1 e8 18             	shr    $0x18,%eax
ffff800000104920:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for (i = 0; i < ncpu; ++i) {
ffff800000104923:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010492a:	eb 39                	jmp    ffff800000104965 <cpunum+0xdc>
    if (cpus[i].apicid == apicid)
ffff80000010492c:	48 b9 e0 82 11 00 00 	movabs $0xffff8000001182e0,%rcx
ffff800000104933:	80 ff ff 
ffff800000104936:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104939:	48 63 d0             	movslq %eax,%rdx
ffff80000010493c:	48 89 d0             	mov    %rdx,%rax
ffff80000010493f:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000104943:	48 01 d0             	add    %rdx,%rax
ffff800000104946:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010494a:	48 01 c8             	add    %rcx,%rax
ffff80000010494d:	48 83 c0 01          	add    $0x1,%rax
ffff800000104951:	0f b6 00             	movzbl (%rax),%eax
ffff800000104954:	0f b6 c0             	movzbl %al,%eax
ffff800000104957:	39 45 f8             	cmp    %eax,-0x8(%rbp)
ffff80000010495a:	75 05                	jne    ffff800000104961 <cpunum+0xd8>
      return i;
ffff80000010495c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010495f:	eb 2e                	jmp    ffff80000010498f <cpunum+0x106>
  for (i = 0; i < ncpu; ++i) {
ffff800000104961:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104965:	48 b8 20 84 11 00 00 	movabs $0xffff800000118420,%rax
ffff80000010496c:	80 ff ff 
ffff80000010496f:	8b 00                	mov    (%rax),%eax
ffff800000104971:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104974:	7c b6                	jl     ffff80000010492c <cpunum+0xa3>
  }
  panic("unknown apicid\n");
ffff800000104976:	48 b8 0c c9 10 00 00 	movabs $0xffff80000010c90c,%rax
ffff80000010497d:	80 ff ff 
ffff800000104980:	48 89 c7             	mov    %rax,%rdi
ffff800000104983:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010498a:	80 ff ff 
ffff80000010498d:	ff d0                	call   *%rax
}
ffff80000010498f:	c9                   	leave
ffff800000104990:	c3                   	ret

ffff800000104991 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
ffff800000104991:	55                   	push   %rbp
ffff800000104992:	48 89 e5             	mov    %rsp,%rbp
  if(lapic)
ffff800000104995:	48 b8 c0 81 11 00 00 	movabs $0xffff8000001181c0,%rax
ffff80000010499c:	80 ff ff 
ffff80000010499f:	48 8b 00             	mov    (%rax),%rax
ffff8000001049a2:	48 85 c0             	test   %rax,%rax
ffff8000001049a5:	74 16                	je     ffff8000001049bd <lapiceoi+0x2c>
    lapicw(EOI, 0);
ffff8000001049a7:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001049ac:	bf 2c 00 00 00       	mov    $0x2c,%edi
ffff8000001049b1:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff8000001049b8:	80 ff ff 
ffff8000001049bb:	ff d0                	call   *%rax
}
ffff8000001049bd:	90                   	nop
ffff8000001049be:	5d                   	pop    %rbp
ffff8000001049bf:	c3                   	ret

ffff8000001049c0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
ffff8000001049c0:	55                   	push   %rbp
ffff8000001049c1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001049c4:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001049c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
}
ffff8000001049cb:	90                   	nop
ffff8000001049cc:	c9                   	leave
ffff8000001049cd:	c3                   	ret

ffff8000001049ce <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
ffff8000001049ce:	55                   	push   %rbp
ffff8000001049cf:	48 89 e5             	mov    %rsp,%rbp
ffff8000001049d2:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001049d6:	89 f8                	mov    %edi,%eax
ffff8000001049d8:	89 75 e8             	mov    %esi,-0x18(%rbp)
ffff8000001049db:	88 45 ec             	mov    %al,-0x14(%rbp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
ffff8000001049de:	be 0f 00 00 00       	mov    $0xf,%esi
ffff8000001049e3:	bf 70 00 00 00       	mov    $0x70,%edi
ffff8000001049e8:	48 b8 85 46 10 00 00 	movabs $0xffff800000104685,%rax
ffff8000001049ef:	80 ff ff 
ffff8000001049f2:	ff d0                	call   *%rax
  outb(CMOS_PORT+1, 0x0A);
ffff8000001049f4:	be 0a 00 00 00       	mov    $0xa,%esi
ffff8000001049f9:	bf 71 00 00 00       	mov    $0x71,%edi
ffff8000001049fe:	48 b8 85 46 10 00 00 	movabs $0xffff800000104685,%rax
ffff800000104a05:	80 ff ff 
ffff800000104a08:	ff d0                	call   *%rax
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
ffff800000104a0a:	48 b8 67 04 00 00 00 	movabs $0xffff800000000467,%rax
ffff800000104a11:	80 ff ff 
ffff800000104a14:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  wrv[0] = 0;
ffff800000104a18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104a1c:	66 c7 00 00 00       	movw   $0x0,(%rax)
  wrv[1] = addr >> 4;
ffff800000104a21:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104a24:	c1 e8 04             	shr    $0x4,%eax
ffff800000104a27:	89 c2                	mov    %eax,%edx
ffff800000104a29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104a2d:	48 83 c0 02          	add    $0x2,%rax
ffff800000104a31:	66 89 10             	mov    %dx,(%rax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
ffff800000104a34:	0f b6 45 ec          	movzbl -0x14(%rbp),%eax
ffff800000104a38:	c1 e0 18             	shl    $0x18,%eax
ffff800000104a3b:	89 c6                	mov    %eax,%esi
ffff800000104a3d:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff800000104a42:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff800000104a49:	80 ff ff 
ffff800000104a4c:	ff d0                	call   *%rax
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
ffff800000104a4e:	be 00 c5 00 00       	mov    $0xc500,%esi
ffff800000104a53:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104a58:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff800000104a5f:	80 ff ff 
ffff800000104a62:	ff d0                	call   *%rax
  microdelay(200);
ffff800000104a64:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff800000104a69:	48 b8 c0 49 10 00 00 	movabs $0xffff8000001049c0,%rax
ffff800000104a70:	80 ff ff 
ffff800000104a73:	ff d0                	call   *%rax
  lapicw(ICRLO, INIT | LEVEL);
ffff800000104a75:	be 00 85 00 00       	mov    $0x8500,%esi
ffff800000104a7a:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104a7f:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff800000104a86:	80 ff ff 
ffff800000104a89:	ff d0                	call   *%rax
  microdelay(100);    // should be 10ms, but too slow in Bochs!
ffff800000104a8b:	bf 64 00 00 00       	mov    $0x64,%edi
ffff800000104a90:	48 b8 c0 49 10 00 00 	movabs $0xffff8000001049c0,%rax
ffff800000104a97:	80 ff ff 
ffff800000104a9a:	ff d0                	call   *%rax
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
ffff800000104a9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104aa3:	eb 4b                	jmp    ffff800000104af0 <lapicstartap+0x122>
    lapicw(ICRHI, apicid<<24);
ffff800000104aa5:	0f b6 45 ec          	movzbl -0x14(%rbp),%eax
ffff800000104aa9:	c1 e0 18             	shl    $0x18,%eax
ffff800000104aac:	89 c6                	mov    %eax,%esi
ffff800000104aae:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff800000104ab3:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff800000104aba:	80 ff ff 
ffff800000104abd:	ff d0                	call   *%rax
    lapicw(ICRLO, STARTUP | (addr>>12));
ffff800000104abf:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104ac2:	c1 e8 0c             	shr    $0xc,%eax
ffff800000104ac5:	80 cc 06             	or     $0x6,%ah
ffff800000104ac8:	89 c6                	mov    %eax,%esi
ffff800000104aca:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104acf:	48 b8 b8 46 10 00 00 	movabs $0xffff8000001046b8,%rax
ffff800000104ad6:	80 ff ff 
ffff800000104ad9:	ff d0                	call   *%rax
    microdelay(200);
ffff800000104adb:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff800000104ae0:	48 b8 c0 49 10 00 00 	movabs $0xffff8000001049c0,%rax
ffff800000104ae7:	80 ff ff 
ffff800000104aea:	ff d0                	call   *%rax
  for(i = 0; i < 2; i++){
ffff800000104aec:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104af0:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff800000104af4:	7e af                	jle    ffff800000104aa5 <lapicstartap+0xd7>
  }
}
ffff800000104af6:	90                   	nop
ffff800000104af7:	90                   	nop
ffff800000104af8:	c9                   	leave
ffff800000104af9:	c3                   	ret

ffff800000104afa <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
ffff800000104afa:	55                   	push   %rbp
ffff800000104afb:	48 89 e5             	mov    %rsp,%rbp
ffff800000104afe:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000104b02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  outb(CMOS_PORT,  reg);
ffff800000104b05:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104b08:	0f b6 c0             	movzbl %al,%eax
ffff800000104b0b:	89 c6                	mov    %eax,%esi
ffff800000104b0d:	bf 70 00 00 00       	mov    $0x70,%edi
ffff800000104b12:	48 b8 85 46 10 00 00 	movabs $0xffff800000104685,%rax
ffff800000104b19:	80 ff ff 
ffff800000104b1c:	ff d0                	call   *%rax
  microdelay(200);
ffff800000104b1e:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff800000104b23:	48 b8 c0 49 10 00 00 	movabs $0xffff8000001049c0,%rax
ffff800000104b2a:	80 ff ff 
ffff800000104b2d:	ff d0                	call   *%rax

  return inb(CMOS_RETURN);
ffff800000104b2f:	bf 71 00 00 00       	mov    $0x71,%edi
ffff800000104b34:	48 b8 67 46 10 00 00 	movabs $0xffff800000104667,%rax
ffff800000104b3b:	80 ff ff 
ffff800000104b3e:	ff d0                	call   *%rax
ffff800000104b40:	0f b6 c0             	movzbl %al,%eax
}
ffff800000104b43:	c9                   	leave
ffff800000104b44:	c3                   	ret

ffff800000104b45 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
ffff800000104b45:	55                   	push   %rbp
ffff800000104b46:	48 89 e5             	mov    %rsp,%rbp
ffff800000104b49:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000104b4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  r->second = cmos_read(SECS);
ffff800000104b51:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000104b56:	48 b8 fa 4a 10 00 00 	movabs $0xffff800000104afa,%rax
ffff800000104b5d:	80 ff ff 
ffff800000104b60:	ff d0                	call   *%rax
ffff800000104b62:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104b66:	89 02                	mov    %eax,(%rdx)
  r->minute = cmos_read(MINS);
ffff800000104b68:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000104b6d:	48 b8 fa 4a 10 00 00 	movabs $0xffff800000104afa,%rax
ffff800000104b74:	80 ff ff 
ffff800000104b77:	ff d0                	call   *%rax
ffff800000104b79:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104b7d:	89 42 04             	mov    %eax,0x4(%rdx)
  r->hour   = cmos_read(HOURS);
ffff800000104b80:	bf 04 00 00 00       	mov    $0x4,%edi
ffff800000104b85:	48 b8 fa 4a 10 00 00 	movabs $0xffff800000104afa,%rax
ffff800000104b8c:	80 ff ff 
ffff800000104b8f:	ff d0                	call   *%rax
ffff800000104b91:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104b95:	89 42 08             	mov    %eax,0x8(%rdx)
  r->day    = cmos_read(DAY);
ffff800000104b98:	bf 07 00 00 00       	mov    $0x7,%edi
ffff800000104b9d:	48 b8 fa 4a 10 00 00 	movabs $0xffff800000104afa,%rax
ffff800000104ba4:	80 ff ff 
ffff800000104ba7:	ff d0                	call   *%rax
ffff800000104ba9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104bad:	89 42 0c             	mov    %eax,0xc(%rdx)
  r->month  = cmos_read(MONTH);
ffff800000104bb0:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000104bb5:	48 b8 fa 4a 10 00 00 	movabs $0xffff800000104afa,%rax
ffff800000104bbc:	80 ff ff 
ffff800000104bbf:	ff d0                	call   *%rax
ffff800000104bc1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104bc5:	89 42 10             	mov    %eax,0x10(%rdx)
  r->year   = cmos_read(YEAR);
ffff800000104bc8:	bf 09 00 00 00       	mov    $0x9,%edi
ffff800000104bcd:	48 b8 fa 4a 10 00 00 	movabs $0xffff800000104afa,%rax
ffff800000104bd4:	80 ff ff 
ffff800000104bd7:	ff d0                	call   *%rax
ffff800000104bd9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104bdd:	89 42 14             	mov    %eax,0x14(%rdx)
}
ffff800000104be0:	90                   	nop
ffff800000104be1:	c9                   	leave
ffff800000104be2:	c3                   	ret

ffff800000104be3 <cmostime>:
//PAGEBREAK!

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
ffff800000104be3:	55                   	push   %rbp
ffff800000104be4:	48 89 e5             	mov    %rsp,%rbp
ffff800000104be7:	48 83 ec 50          	sub    $0x50,%rsp
ffff800000104beb:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
ffff800000104bef:	bf 0b 00 00 00       	mov    $0xb,%edi
ffff800000104bf4:	48 b8 fa 4a 10 00 00 	movabs $0xffff800000104afa,%rax
ffff800000104bfb:	80 ff ff 
ffff800000104bfe:	ff d0                	call   *%rax
ffff800000104c00:	89 45 fc             	mov    %eax,-0x4(%rbp)

  bcd = (sb & (1 << 2)) == 0;
ffff800000104c03:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104c06:	83 e0 04             	and    $0x4,%eax
ffff800000104c09:	c1 e8 02             	shr    $0x2,%eax
ffff800000104c0c:	83 e0 01             	and    $0x1,%eax
ffff800000104c0f:	83 f0 01             	xor    $0x1,%eax
ffff800000104c12:	0f b6 c0             	movzbl %al,%eax
ffff800000104c15:	89 45 f8             	mov    %eax,-0x8(%rbp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
ffff800000104c18:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000104c1c:	48 89 c7             	mov    %rax,%rdi
ffff800000104c1f:	48 b8 45 4b 10 00 00 	movabs $0xffff800000104b45,%rax
ffff800000104c26:	80 ff ff 
ffff800000104c29:	ff d0                	call   *%rax
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
ffff800000104c2b:	bf 0a 00 00 00       	mov    $0xa,%edi
ffff800000104c30:	48 b8 fa 4a 10 00 00 	movabs $0xffff800000104afa,%rax
ffff800000104c37:	80 ff ff 
ffff800000104c3a:	ff d0                	call   *%rax
ffff800000104c3c:	25 80 00 00 00       	and    $0x80,%eax
ffff800000104c41:	85 c0                	test   %eax,%eax
ffff800000104c43:	75 38                	jne    ffff800000104c7d <cmostime+0x9a>
        continue;
    fill_rtcdate(&t2);
ffff800000104c45:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff800000104c49:	48 89 c7             	mov    %rax,%rdi
ffff800000104c4c:	48 b8 45 4b 10 00 00 	movabs $0xffff800000104b45,%rax
ffff800000104c53:	80 ff ff 
ffff800000104c56:	ff d0                	call   *%rax
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
ffff800000104c58:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
ffff800000104c5c:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000104c60:	ba 18 00 00 00       	mov    $0x18,%edx
ffff800000104c65:	48 89 ce             	mov    %rcx,%rsi
ffff800000104c68:	48 89 c7             	mov    %rax,%rdi
ffff800000104c6b:	48 b8 04 7b 10 00 00 	movabs $0xffff800000107b04,%rax
ffff800000104c72:	80 ff ff 
ffff800000104c75:	ff d0                	call   *%rax
ffff800000104c77:	85 c0                	test   %eax,%eax
ffff800000104c79:	74 05                	je     ffff800000104c80 <cmostime+0x9d>
ffff800000104c7b:	eb 9b                	jmp    ffff800000104c18 <cmostime+0x35>
        continue;
ffff800000104c7d:	90                   	nop
    fill_rtcdate(&t1);
ffff800000104c7e:	eb 98                	jmp    ffff800000104c18 <cmostime+0x35>
      break;
ffff800000104c80:	90                   	nop
  }

  // convert
  if(bcd) {
ffff800000104c81:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffff800000104c85:	0f 84 b4 00 00 00    	je     ffff800000104d3f <cmostime+0x15c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
ffff800000104c8b:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000104c8e:	c1 e8 04             	shr    $0x4,%eax
ffff800000104c91:	89 c2                	mov    %eax,%edx
ffff800000104c93:	89 d0                	mov    %edx,%eax
ffff800000104c95:	c1 e0 02             	shl    $0x2,%eax
ffff800000104c98:	01 d0                	add    %edx,%eax
ffff800000104c9a:	01 c0                	add    %eax,%eax
ffff800000104c9c:	89 c2                	mov    %eax,%edx
ffff800000104c9e:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000104ca1:	83 e0 0f             	and    $0xf,%eax
ffff800000104ca4:	01 d0                	add    %edx,%eax
ffff800000104ca6:	89 45 e0             	mov    %eax,-0x20(%rbp)
    CONV(minute);
ffff800000104ca9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000104cac:	c1 e8 04             	shr    $0x4,%eax
ffff800000104caf:	89 c2                	mov    %eax,%edx
ffff800000104cb1:	89 d0                	mov    %edx,%eax
ffff800000104cb3:	c1 e0 02             	shl    $0x2,%eax
ffff800000104cb6:	01 d0                	add    %edx,%eax
ffff800000104cb8:	01 c0                	add    %eax,%eax
ffff800000104cba:	89 c2                	mov    %eax,%edx
ffff800000104cbc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000104cbf:	83 e0 0f             	and    $0xf,%eax
ffff800000104cc2:	01 d0                	add    %edx,%eax
ffff800000104cc4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    CONV(hour  );
ffff800000104cc7:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104cca:	c1 e8 04             	shr    $0x4,%eax
ffff800000104ccd:	89 c2                	mov    %eax,%edx
ffff800000104ccf:	89 d0                	mov    %edx,%eax
ffff800000104cd1:	c1 e0 02             	shl    $0x2,%eax
ffff800000104cd4:	01 d0                	add    %edx,%eax
ffff800000104cd6:	01 c0                	add    %eax,%eax
ffff800000104cd8:	89 c2                	mov    %eax,%edx
ffff800000104cda:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104cdd:	83 e0 0f             	and    $0xf,%eax
ffff800000104ce0:	01 d0                	add    %edx,%eax
ffff800000104ce2:	89 45 e8             	mov    %eax,-0x18(%rbp)
    CONV(day   );
ffff800000104ce5:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104ce8:	c1 e8 04             	shr    $0x4,%eax
ffff800000104ceb:	89 c2                	mov    %eax,%edx
ffff800000104ced:	89 d0                	mov    %edx,%eax
ffff800000104cef:	c1 e0 02             	shl    $0x2,%eax
ffff800000104cf2:	01 d0                	add    %edx,%eax
ffff800000104cf4:	01 c0                	add    %eax,%eax
ffff800000104cf6:	89 c2                	mov    %eax,%edx
ffff800000104cf8:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104cfb:	83 e0 0f             	and    $0xf,%eax
ffff800000104cfe:	01 d0                	add    %edx,%eax
ffff800000104d00:	89 45 ec             	mov    %eax,-0x14(%rbp)
    CONV(month );
ffff800000104d03:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104d06:	c1 e8 04             	shr    $0x4,%eax
ffff800000104d09:	89 c2                	mov    %eax,%edx
ffff800000104d0b:	89 d0                	mov    %edx,%eax
ffff800000104d0d:	c1 e0 02             	shl    $0x2,%eax
ffff800000104d10:	01 d0                	add    %edx,%eax
ffff800000104d12:	01 c0                	add    %eax,%eax
ffff800000104d14:	89 c2                	mov    %eax,%edx
ffff800000104d16:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104d19:	83 e0 0f             	and    $0xf,%eax
ffff800000104d1c:	01 d0                	add    %edx,%eax
ffff800000104d1e:	89 45 f0             	mov    %eax,-0x10(%rbp)
    CONV(year  );
ffff800000104d21:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000104d24:	c1 e8 04             	shr    $0x4,%eax
ffff800000104d27:	89 c2                	mov    %eax,%edx
ffff800000104d29:	89 d0                	mov    %edx,%eax
ffff800000104d2b:	c1 e0 02             	shl    $0x2,%eax
ffff800000104d2e:	01 d0                	add    %edx,%eax
ffff800000104d30:	01 c0                	add    %eax,%eax
ffff800000104d32:	89 c2                	mov    %eax,%edx
ffff800000104d34:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000104d37:	83 e0 0f             	and    $0xf,%eax
ffff800000104d3a:	01 d0                	add    %edx,%eax
ffff800000104d3c:	89 45 f4             	mov    %eax,-0xc(%rbp)
#undef     CONV
  }

  *r = t1;
ffff800000104d3f:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
ffff800000104d43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000104d47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000104d4b:	48 89 01             	mov    %rax,(%rcx)
ffff800000104d4e:	48 89 51 08          	mov    %rdx,0x8(%rcx)
ffff800000104d52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104d56:	48 89 41 10          	mov    %rax,0x10(%rcx)
  r->year += 2000;
ffff800000104d5a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000104d5e:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000104d61:	8d 90 d0 07 00 00    	lea    0x7d0(%rax),%edx
ffff800000104d67:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000104d6b:	89 50 14             	mov    %edx,0x14(%rax)
}
ffff800000104d6e:	90                   	nop
ffff800000104d6f:	c9                   	leave
ffff800000104d70:	c3                   	ret

ffff800000104d71 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
ffff800000104d71:	55                   	push   %rbp
ffff800000104d72:	48 89 e5             	mov    %rsp,%rbp
ffff800000104d75:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000104d79:	89 7d dc             	mov    %edi,-0x24(%rbp)
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
ffff800000104d7c:	48 ba 1c c9 10 00 00 	movabs $0xffff80000010c91c,%rdx
ffff800000104d83:	80 ff ff 
ffff800000104d86:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104d8d:	80 ff ff 
ffff800000104d90:	48 89 d6             	mov    %rdx,%rsi
ffff800000104d93:	48 89 c7             	mov    %rax,%rdi
ffff800000104d96:	48 b8 a5 76 10 00 00 	movabs $0xffff8000001076a5,%rax
ffff800000104d9d:	80 ff ff 
ffff800000104da0:	ff d0                	call   *%rax
  readsb(dev, &sb);
ffff800000104da2:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff800000104da6:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000104da9:	48 89 d6             	mov    %rdx,%rsi
ffff800000104dac:	89 c7                	mov    %eax,%edi
ffff800000104dae:	48 b8 b9 21 10 00 00 	movabs $0xffff8000001021b9,%rax
ffff800000104db5:	80 ff ff 
ffff800000104db8:	ff d0                	call   *%rax
  log.start = sb.logstart;
ffff800000104dba:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104dbd:	89 c2                	mov    %eax,%edx
ffff800000104dbf:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104dc6:	80 ff ff 
ffff800000104dc9:	89 50 68             	mov    %edx,0x68(%rax)
  log.size = sb.nlog;
ffff800000104dcc:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104dcf:	89 c2                	mov    %eax,%edx
ffff800000104dd1:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104dd8:	80 ff ff 
ffff800000104ddb:	89 50 6c             	mov    %edx,0x6c(%rax)
  log.dev = dev;
ffff800000104dde:	48 ba e0 81 11 00 00 	movabs $0xffff8000001181e0,%rdx
ffff800000104de5:	80 ff ff 
ffff800000104de8:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000104deb:	89 42 78             	mov    %eax,0x78(%rdx)
  recover_from_log();
ffff800000104dee:	48 b8 82 50 10 00 00 	movabs $0xffff800000105082,%rax
ffff800000104df5:	80 ff ff 
ffff800000104df8:	ff d0                	call   *%rax
}
ffff800000104dfa:	90                   	nop
ffff800000104dfb:	c9                   	leave
ffff800000104dfc:	c3                   	ret

ffff800000104dfd <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
ffff800000104dfd:	55                   	push   %rbp
ffff800000104dfe:	48 89 e5             	mov    %rsp,%rbp
ffff800000104e01:	48 83 ec 20          	sub    $0x20,%rsp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000104e05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104e0c:	e9 dc 00 00 00       	jmp    ffff800000104eed <install_trans+0xf0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
ffff800000104e11:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104e18:	80 ff ff 
ffff800000104e1b:	8b 50 68             	mov    0x68(%rax),%edx
ffff800000104e1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104e21:	01 d0                	add    %edx,%eax
ffff800000104e23:	83 c0 01             	add    $0x1,%eax
ffff800000104e26:	89 c2                	mov    %eax,%edx
ffff800000104e28:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104e2f:	80 ff ff 
ffff800000104e32:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104e35:	89 d6                	mov    %edx,%esi
ffff800000104e37:	89 c7                	mov    %eax,%edi
ffff800000104e39:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000104e40:	80 ff ff 
ffff800000104e43:	ff d0                	call   *%rax
ffff800000104e45:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
ffff800000104e49:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104e50:	80 ff ff 
ffff800000104e53:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104e56:	48 63 d2             	movslq %edx,%rdx
ffff800000104e59:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000104e5d:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff800000104e61:	89 c2                	mov    %eax,%edx
ffff800000104e63:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104e6a:	80 ff ff 
ffff800000104e6d:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104e70:	89 d6                	mov    %edx,%esi
ffff800000104e72:	89 c7                	mov    %eax,%edi
ffff800000104e74:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000104e7b:	80 ff ff 
ffff800000104e7e:	ff d0                	call   *%rax
ffff800000104e80:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
ffff800000104e84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104e88:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff800000104e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104e93:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000104e99:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000104e9e:	48 89 ce             	mov    %rcx,%rsi
ffff800000104ea1:	48 89 c7             	mov    %rax,%rdi
ffff800000104ea4:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff800000104eab:	80 ff ff 
ffff800000104eae:	ff d0                	call   *%rax
    bwrite(dbuf);  // write dst to disk
ffff800000104eb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104eb4:	48 89 c7             	mov    %rax,%rdi
ffff800000104eb7:	48 b8 1a 04 10 00 00 	movabs $0xffff80000010041a,%rax
ffff800000104ebe:	80 ff ff 
ffff800000104ec1:	ff d0                	call   *%rax
    brelse(lbuf);
ffff800000104ec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104ec7:	48 89 c7             	mov    %rax,%rdi
ffff800000104eca:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000104ed1:	80 ff ff 
ffff800000104ed4:	ff d0                	call   *%rax
    brelse(dbuf);
ffff800000104ed6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104eda:	48 89 c7             	mov    %rax,%rdi
ffff800000104edd:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000104ee4:	80 ff ff 
ffff800000104ee7:	ff d0                	call   *%rax
  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000104ee9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104eed:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104ef4:	80 ff ff 
ffff800000104ef7:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000104efa:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104efd:	0f 8c 0e ff ff ff    	jl     ffff800000104e11 <install_trans+0x14>
  }
}
ffff800000104f03:	90                   	nop
ffff800000104f04:	90                   	nop
ffff800000104f05:	c9                   	leave
ffff800000104f06:	c3                   	ret

ffff800000104f07 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
ffff800000104f07:	55                   	push   %rbp
ffff800000104f08:	48 89 e5             	mov    %rsp,%rbp
ffff800000104f0b:	48 83 ec 20          	sub    $0x20,%rsp
  struct buf *buf = bread(log.dev, log.start);
ffff800000104f0f:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104f16:	80 ff ff 
ffff800000104f19:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104f1c:	89 c2                	mov    %eax,%edx
ffff800000104f1e:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104f25:	80 ff ff 
ffff800000104f28:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104f2b:	89 d6                	mov    %edx,%esi
ffff800000104f2d:	89 c7                	mov    %eax,%edi
ffff800000104f2f:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000104f36:	80 ff ff 
ffff800000104f39:	ff d0                	call   *%rax
ffff800000104f3b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  struct logheader *lh = (struct logheader *) (buf->data);
ffff800000104f3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104f43:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000104f49:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  int i;
  log.lh.n = lh->n;
ffff800000104f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104f51:	8b 00                	mov    (%rax),%eax
ffff800000104f53:	48 ba e0 81 11 00 00 	movabs $0xffff8000001181e0,%rdx
ffff800000104f5a:	80 ff ff 
ffff800000104f5d:	89 42 7c             	mov    %eax,0x7c(%rdx)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104f60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104f67:	eb 2a                	jmp    ffff800000104f93 <read_head+0x8c>
    log.lh.block[i] = lh->block[i];
ffff800000104f69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104f6d:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104f70:	48 63 d2             	movslq %edx,%rdx
ffff800000104f73:	8b 44 90 04          	mov    0x4(%rax,%rdx,4),%eax
ffff800000104f77:	48 ba e0 81 11 00 00 	movabs $0xffff8000001181e0,%rdx
ffff800000104f7e:	80 ff ff 
ffff800000104f81:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000104f84:	48 63 c9             	movslq %ecx,%rcx
ffff800000104f87:	48 83 c1 1c          	add    $0x1c,%rcx
ffff800000104f8b:	89 44 8a 10          	mov    %eax,0x10(%rdx,%rcx,4)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104f8f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104f93:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104f9a:	80 ff ff 
ffff800000104f9d:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000104fa0:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104fa3:	7c c4                	jl     ffff800000104f69 <read_head+0x62>
  }
  brelse(buf);
ffff800000104fa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104fa9:	48 89 c7             	mov    %rax,%rdi
ffff800000104fac:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000104fb3:	80 ff ff 
ffff800000104fb6:	ff d0                	call   *%rax
}
ffff800000104fb8:	90                   	nop
ffff800000104fb9:	c9                   	leave
ffff800000104fba:	c3                   	ret

ffff800000104fbb <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
ffff800000104fbb:	55                   	push   %rbp
ffff800000104fbc:	48 89 e5             	mov    %rsp,%rbp
ffff800000104fbf:	48 83 ec 20          	sub    $0x20,%rsp
  struct buf *buf = bread(log.dev, log.start);
ffff800000104fc3:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104fca:	80 ff ff 
ffff800000104fcd:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104fd0:	89 c2                	mov    %eax,%edx
ffff800000104fd2:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000104fd9:	80 ff ff 
ffff800000104fdc:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104fdf:	89 d6                	mov    %edx,%esi
ffff800000104fe1:	89 c7                	mov    %eax,%edi
ffff800000104fe3:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000104fea:	80 ff ff 
ffff800000104fed:	ff d0                	call   *%rax
ffff800000104fef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  struct logheader *hb = (struct logheader *) (buf->data);
ffff800000104ff3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104ff7:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000104ffd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  int i;
  hb->n = log.lh.n;
ffff800000105001:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105008:	80 ff ff 
ffff80000010500b:	8b 50 7c             	mov    0x7c(%rax),%edx
ffff80000010500e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105012:	89 10                	mov    %edx,(%rax)
  for (i = 0; i < log.lh.n; i++) {
ffff800000105014:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010501b:	eb 2a                	jmp    ffff800000105047 <write_head+0x8c>
    hb->block[i] = log.lh.block[i];
ffff80000010501d:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105024:	80 ff ff 
ffff800000105027:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010502a:	48 63 d2             	movslq %edx,%rdx
ffff80000010502d:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000105031:	8b 4c 90 10          	mov    0x10(%rax,%rdx,4),%ecx
ffff800000105035:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105039:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010503c:	48 63 d2             	movslq %edx,%rdx
ffff80000010503f:	89 4c 90 04          	mov    %ecx,0x4(%rax,%rdx,4)
  for (i = 0; i < log.lh.n; i++) {
ffff800000105043:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105047:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff80000010504e:	80 ff ff 
ffff800000105051:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000105054:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000105057:	7c c4                	jl     ffff80000010501d <write_head+0x62>
  }
  bwrite(buf);
ffff800000105059:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010505d:	48 89 c7             	mov    %rax,%rdi
ffff800000105060:	48 b8 1a 04 10 00 00 	movabs $0xffff80000010041a,%rax
ffff800000105067:	80 ff ff 
ffff80000010506a:	ff d0                	call   *%rax
  brelse(buf);
ffff80000010506c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105070:	48 89 c7             	mov    %rax,%rdi
ffff800000105073:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff80000010507a:	80 ff ff 
ffff80000010507d:	ff d0                	call   *%rax
}
ffff80000010507f:	90                   	nop
ffff800000105080:	c9                   	leave
ffff800000105081:	c3                   	ret

ffff800000105082 <recover_from_log>:

static void
recover_from_log(void)
{
ffff800000105082:	55                   	push   %rbp
ffff800000105083:	48 89 e5             	mov    %rsp,%rbp
  read_head();
ffff800000105086:	48 b8 07 4f 10 00 00 	movabs $0xffff800000104f07,%rax
ffff80000010508d:	80 ff ff 
ffff800000105090:	ff d0                	call   *%rax
  install_trans(); // if committed, copy from log to disk
ffff800000105092:	48 b8 fd 4d 10 00 00 	movabs $0xffff800000104dfd,%rax
ffff800000105099:	80 ff ff 
ffff80000010509c:	ff d0                	call   *%rax
  log.lh.n = 0;
ffff80000010509e:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001050a5:	80 ff ff 
ffff8000001050a8:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%rax)
  write_head(); // clear the log
ffff8000001050af:	48 b8 bb 4f 10 00 00 	movabs $0xffff800000104fbb,%rax
ffff8000001050b6:	80 ff ff 
ffff8000001050b9:	ff d0                	call   *%rax
}
ffff8000001050bb:	90                   	nop
ffff8000001050bc:	5d                   	pop    %rbp
ffff8000001050bd:	c3                   	ret

ffff8000001050be <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
ffff8000001050be:	55                   	push   %rbp
ffff8000001050bf:	48 89 e5             	mov    %rsp,%rbp
  acquire(&log.lock);
ffff8000001050c2:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001050c9:	80 ff ff 
ffff8000001050cc:	48 89 c7             	mov    %rax,%rdi
ffff8000001050cf:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff8000001050d6:	80 ff ff 
ffff8000001050d9:	ff d0                	call   *%rax
  while(1){
    if(log.committing){
ffff8000001050db:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001050e2:	80 ff ff 
ffff8000001050e5:	8b 40 74             	mov    0x74(%rax),%eax
ffff8000001050e8:	85 c0                	test   %eax,%eax
ffff8000001050ea:	74 28                	je     ffff800000105114 <begin_op+0x56>
      sleep(&log, &log.lock);
ffff8000001050ec:	48 ba e0 81 11 00 00 	movabs $0xffff8000001181e0,%rdx
ffff8000001050f3:	80 ff ff 
ffff8000001050f6:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001050fd:	80 ff ff 
ffff800000105100:	48 89 d6             	mov    %rdx,%rsi
ffff800000105103:	48 89 c7             	mov    %rax,%rdi
ffff800000105106:	48 b8 d8 70 10 00 00 	movabs $0xffff8000001070d8,%rax
ffff80000010510d:	80 ff ff 
ffff800000105110:	ff d0                	call   *%rax
ffff800000105112:	eb c7                	jmp    ffff8000001050db <begin_op+0x1d>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
ffff800000105114:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff80000010511b:	80 ff ff 
ffff80000010511e:	8b 48 7c             	mov    0x7c(%rax),%ecx
ffff800000105121:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105128:	80 ff ff 
ffff80000010512b:	8b 40 70             	mov    0x70(%rax),%eax
ffff80000010512e:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000105131:	89 d0                	mov    %edx,%eax
ffff800000105133:	c1 e0 02             	shl    $0x2,%eax
ffff800000105136:	01 d0                	add    %edx,%eax
ffff800000105138:	01 c0                	add    %eax,%eax
ffff80000010513a:	01 c8                	add    %ecx,%eax
ffff80000010513c:	83 f8 1e             	cmp    $0x1e,%eax
ffff80000010513f:	7e 2b                	jle    ffff80000010516c <begin_op+0xae>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
ffff800000105141:	48 ba e0 81 11 00 00 	movabs $0xffff8000001181e0,%rdx
ffff800000105148:	80 ff ff 
ffff80000010514b:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105152:	80 ff ff 
ffff800000105155:	48 89 d6             	mov    %rdx,%rsi
ffff800000105158:	48 89 c7             	mov    %rax,%rdi
ffff80000010515b:	48 b8 d8 70 10 00 00 	movabs $0xffff8000001070d8,%rax
ffff800000105162:	80 ff ff 
ffff800000105165:	ff d0                	call   *%rax
ffff800000105167:	e9 6f ff ff ff       	jmp    ffff8000001050db <begin_op+0x1d>
    } else {
      log.outstanding += 1;
ffff80000010516c:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105173:	80 ff ff 
ffff800000105176:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000105179:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010517c:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105183:	80 ff ff 
ffff800000105186:	89 50 70             	mov    %edx,0x70(%rax)
      release(&log.lock);
ffff800000105189:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105190:	80 ff ff 
ffff800000105193:	48 89 c7             	mov    %rax,%rdi
ffff800000105196:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010519d:	80 ff ff 
ffff8000001051a0:	ff d0                	call   *%rax
      break;
ffff8000001051a2:	90                   	nop
    }
  }
}
ffff8000001051a3:	90                   	nop
ffff8000001051a4:	5d                   	pop    %rbp
ffff8000001051a5:	c3                   	ret

ffff8000001051a6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
ffff8000001051a6:	55                   	push   %rbp
ffff8000001051a7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001051aa:	48 83 ec 10          	sub    $0x10,%rsp
  int do_commit = 0;
ffff8000001051ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  acquire(&log.lock);
ffff8000001051b5:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001051bc:	80 ff ff 
ffff8000001051bf:	48 89 c7             	mov    %rax,%rdi
ffff8000001051c2:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff8000001051c9:	80 ff ff 
ffff8000001051cc:	ff d0                	call   *%rax
  log.outstanding -= 1;
ffff8000001051ce:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001051d5:	80 ff ff 
ffff8000001051d8:	8b 40 70             	mov    0x70(%rax),%eax
ffff8000001051db:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001051de:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001051e5:	80 ff ff 
ffff8000001051e8:	89 50 70             	mov    %edx,0x70(%rax)
  if(log.committing)
ffff8000001051eb:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001051f2:	80 ff ff 
ffff8000001051f5:	8b 40 74             	mov    0x74(%rax),%eax
ffff8000001051f8:	85 c0                	test   %eax,%eax
ffff8000001051fa:	74 19                	je     ffff800000105215 <end_op+0x6f>
    panic("log.committing");
ffff8000001051fc:	48 b8 20 c9 10 00 00 	movabs $0xffff80000010c920,%rax
ffff800000105203:	80 ff ff 
ffff800000105206:	48 89 c7             	mov    %rax,%rdi
ffff800000105209:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000105210:	80 ff ff 
ffff800000105213:	ff d0                	call   *%rax
  if(log.outstanding == 0){
ffff800000105215:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff80000010521c:	80 ff ff 
ffff80000010521f:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000105222:	85 c0                	test   %eax,%eax
ffff800000105224:	75 1a                	jne    ffff800000105240 <end_op+0x9a>
    do_commit = 1;
ffff800000105226:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    log.committing = 1;
ffff80000010522d:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105234:	80 ff ff 
ffff800000105237:	c7 40 74 01 00 00 00 	movl   $0x1,0x74(%rax)
ffff80000010523e:	eb 19                	jmp    ffff800000105259 <end_op+0xb3>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
ffff800000105240:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105247:	80 ff ff 
ffff80000010524a:	48 89 c7             	mov    %rax,%rdi
ffff80000010524d:	48 b8 4d 72 10 00 00 	movabs $0xffff80000010724d,%rax
ffff800000105254:	80 ff ff 
ffff800000105257:	ff d0                	call   *%rax
  }
  release(&log.lock);
ffff800000105259:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105260:	80 ff ff 
ffff800000105263:	48 89 c7             	mov    %rax,%rdi
ffff800000105266:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010526d:	80 ff ff 
ffff800000105270:	ff d0                	call   *%rax

  if(do_commit){
ffff800000105272:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000105276:	74 68                	je     ffff8000001052e0 <end_op+0x13a>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
ffff800000105278:	48 b8 ed 53 10 00 00 	movabs $0xffff8000001053ed,%rax
ffff80000010527f:	80 ff ff 
ffff800000105282:	ff d0                	call   *%rax
    acquire(&log.lock);
ffff800000105284:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff80000010528b:	80 ff ff 
ffff80000010528e:	48 89 c7             	mov    %rax,%rdi
ffff800000105291:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000105298:	80 ff ff 
ffff80000010529b:	ff d0                	call   *%rax
    log.committing = 0;
ffff80000010529d:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001052a4:	80 ff ff 
ffff8000001052a7:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%rax)
    wakeup(&log);
ffff8000001052ae:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001052b5:	80 ff ff 
ffff8000001052b8:	48 89 c7             	mov    %rax,%rdi
ffff8000001052bb:	48 b8 4d 72 10 00 00 	movabs $0xffff80000010724d,%rax
ffff8000001052c2:	80 ff ff 
ffff8000001052c5:	ff d0                	call   *%rax
    release(&log.lock);
ffff8000001052c7:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001052ce:	80 ff ff 
ffff8000001052d1:	48 89 c7             	mov    %rax,%rdi
ffff8000001052d4:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001052db:	80 ff ff 
ffff8000001052de:	ff d0                	call   *%rax
  }
}
ffff8000001052e0:	90                   	nop
ffff8000001052e1:	c9                   	leave
ffff8000001052e2:	c3                   	ret

ffff8000001052e3 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
ffff8000001052e3:	55                   	push   %rbp
ffff8000001052e4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001052e7:	48 83 ec 20          	sub    $0x20,%rsp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffff8000001052eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001052f2:	e9 dc 00 00 00       	jmp    ffff8000001053d3 <write_log+0xf0>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
ffff8000001052f7:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001052fe:	80 ff ff 
ffff800000105301:	8b 50 68             	mov    0x68(%rax),%edx
ffff800000105304:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000105307:	01 d0                	add    %edx,%eax
ffff800000105309:	83 c0 01             	add    $0x1,%eax
ffff80000010530c:	89 c2                	mov    %eax,%edx
ffff80000010530e:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105315:	80 ff ff 
ffff800000105318:	8b 40 78             	mov    0x78(%rax),%eax
ffff80000010531b:	89 d6                	mov    %edx,%esi
ffff80000010531d:	89 c7                	mov    %eax,%edi
ffff80000010531f:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000105326:	80 ff ff 
ffff800000105329:	ff d0                	call   *%rax
ffff80000010532b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
ffff80000010532f:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105336:	80 ff ff 
ffff800000105339:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010533c:	48 63 d2             	movslq %edx,%rdx
ffff80000010533f:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000105343:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff800000105347:	89 c2                	mov    %eax,%edx
ffff800000105349:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105350:	80 ff ff 
ffff800000105353:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000105356:	89 d6                	mov    %edx,%esi
ffff800000105358:	89 c7                	mov    %eax,%edi
ffff80000010535a:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000105361:	80 ff ff 
ffff800000105364:	ff d0                	call   *%rax
ffff800000105366:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memmove(to->data, from->data, BSIZE);
ffff80000010536a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010536e:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff800000105375:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105379:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff80000010537f:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000105384:	48 89 ce             	mov    %rcx,%rsi
ffff800000105387:	48 89 c7             	mov    %rax,%rdi
ffff80000010538a:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff800000105391:	80 ff ff 
ffff800000105394:	ff d0                	call   *%rax
    bwrite(to);  // write the log
ffff800000105396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010539a:	48 89 c7             	mov    %rax,%rdi
ffff80000010539d:	48 b8 1a 04 10 00 00 	movabs $0xffff80000010041a,%rax
ffff8000001053a4:	80 ff ff 
ffff8000001053a7:	ff d0                	call   *%rax
    brelse(from);
ffff8000001053a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001053ad:	48 89 c7             	mov    %rax,%rdi
ffff8000001053b0:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001053b7:	80 ff ff 
ffff8000001053ba:	ff d0                	call   *%rax
    brelse(to);
ffff8000001053bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001053c0:	48 89 c7             	mov    %rax,%rdi
ffff8000001053c3:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001053ca:	80 ff ff 
ffff8000001053cd:	ff d0                	call   *%rax
  for (tail = 0; tail < log.lh.n; tail++) {
ffff8000001053cf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001053d3:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001053da:	80 ff ff 
ffff8000001053dd:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001053e0:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff8000001053e3:	0f 8c 0e ff ff ff    	jl     ffff8000001052f7 <write_log+0x14>
  }
}
ffff8000001053e9:	90                   	nop
ffff8000001053ea:	90                   	nop
ffff8000001053eb:	c9                   	leave
ffff8000001053ec:	c3                   	ret

ffff8000001053ed <commit>:

static void
commit()
{
ffff8000001053ed:	55                   	push   %rbp
ffff8000001053ee:	48 89 e5             	mov    %rsp,%rbp
  if (log.lh.n > 0) {
ffff8000001053f1:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001053f8:	80 ff ff 
ffff8000001053fb:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001053fe:	85 c0                	test   %eax,%eax
ffff800000105400:	7e 41                	jle    ffff800000105443 <commit+0x56>
    write_log();     // Write modified blocks from cache to log
ffff800000105402:	48 b8 e3 52 10 00 00 	movabs $0xffff8000001052e3,%rax
ffff800000105409:	80 ff ff 
ffff80000010540c:	ff d0                	call   *%rax
    write_head();    // Write header to disk -- the real commit
ffff80000010540e:	48 b8 bb 4f 10 00 00 	movabs $0xffff800000104fbb,%rax
ffff800000105415:	80 ff ff 
ffff800000105418:	ff d0                	call   *%rax
    install_trans(); // Now install writes to home locations
ffff80000010541a:	48 b8 fd 4d 10 00 00 	movabs $0xffff800000104dfd,%rax
ffff800000105421:	80 ff ff 
ffff800000105424:	ff d0                	call   *%rax
    log.lh.n = 0;
ffff800000105426:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff80000010542d:	80 ff ff 
ffff800000105430:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%rax)
    write_head();    // Erase the transaction from the log
ffff800000105437:	48 b8 bb 4f 10 00 00 	movabs $0xffff800000104fbb,%rax
ffff80000010543e:	80 ff ff 
ffff800000105441:	ff d0                	call   *%rax
  }
}
ffff800000105443:	90                   	nop
ffff800000105444:	5d                   	pop    %rbp
ffff800000105445:	c3                   	ret

ffff800000105446 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
ffff800000105446:	55                   	push   %rbp
ffff800000105447:	48 89 e5             	mov    %rsp,%rbp
ffff80000010544a:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010544e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
ffff800000105452:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105459:	80 ff ff 
ffff80000010545c:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010545f:	83 f8 1d             	cmp    $0x1d,%eax
ffff800000105462:	7f 21                	jg     ffff800000105485 <log_write+0x3f>
ffff800000105464:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff80000010546b:	80 ff ff 
ffff80000010546e:	8b 50 7c             	mov    0x7c(%rax),%edx
ffff800000105471:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105478:	80 ff ff 
ffff80000010547b:	8b 40 6c             	mov    0x6c(%rax),%eax
ffff80000010547e:	83 e8 01             	sub    $0x1,%eax
ffff800000105481:	39 c2                	cmp    %eax,%edx
ffff800000105483:	7c 19                	jl     ffff80000010549e <log_write+0x58>
    panic("too big a transaction");
ffff800000105485:	48 b8 2f c9 10 00 00 	movabs $0xffff80000010c92f,%rax
ffff80000010548c:	80 ff ff 
ffff80000010548f:	48 89 c7             	mov    %rax,%rdi
ffff800000105492:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000105499:	80 ff ff 
ffff80000010549c:	ff d0                	call   *%rax
  if (log.outstanding < 1)
ffff80000010549e:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001054a5:	80 ff ff 
ffff8000001054a8:	8b 40 70             	mov    0x70(%rax),%eax
ffff8000001054ab:	85 c0                	test   %eax,%eax
ffff8000001054ad:	7f 19                	jg     ffff8000001054c8 <log_write+0x82>
    panic("log_write outside of trans");
ffff8000001054af:	48 b8 45 c9 10 00 00 	movabs $0xffff80000010c945,%rax
ffff8000001054b6:	80 ff ff 
ffff8000001054b9:	48 89 c7             	mov    %rax,%rdi
ffff8000001054bc:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001054c3:	80 ff ff 
ffff8000001054c6:	ff d0                	call   *%rax

  acquire(&log.lock);
ffff8000001054c8:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001054cf:	80 ff ff 
ffff8000001054d2:	48 89 c7             	mov    %rax,%rdi
ffff8000001054d5:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff8000001054dc:	80 ff ff 
ffff8000001054df:	ff d0                	call   *%rax
  for (i = 0; i < log.lh.n; i++) {
ffff8000001054e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001054e8:	eb 29                	jmp    ffff800000105513 <log_write+0xcd>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
ffff8000001054ea:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff8000001054f1:	80 ff ff 
ffff8000001054f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001054f7:	48 63 d2             	movslq %edx,%rdx
ffff8000001054fa:	48 83 c2 1c          	add    $0x1c,%rdx
ffff8000001054fe:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff800000105502:	89 c2                	mov    %eax,%edx
ffff800000105504:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105508:	8b 40 08             	mov    0x8(%rax),%eax
ffff80000010550b:	39 c2                	cmp    %eax,%edx
ffff80000010550d:	74 18                	je     ffff800000105527 <log_write+0xe1>
  for (i = 0; i < log.lh.n; i++) {
ffff80000010550f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105513:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff80000010551a:	80 ff ff 
ffff80000010551d:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000105520:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000105523:	7c c5                	jl     ffff8000001054ea <log_write+0xa4>
ffff800000105525:	eb 01                	jmp    ffff800000105528 <log_write+0xe2>
      break;
ffff800000105527:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
ffff800000105528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010552c:	8b 40 08             	mov    0x8(%rax),%eax
ffff80000010552f:	89 c1                	mov    %eax,%ecx
ffff800000105531:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105538:	80 ff ff 
ffff80000010553b:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010553e:	48 63 d2             	movslq %edx,%rdx
ffff800000105541:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000105545:	89 4c 90 10          	mov    %ecx,0x10(%rax,%rdx,4)
  if (i == log.lh.n)
ffff800000105549:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105550:	80 ff ff 
ffff800000105553:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000105556:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000105559:	75 1d                	jne    ffff800000105578 <log_write+0x132>
    log.lh.n++;
ffff80000010555b:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105562:	80 ff ff 
ffff800000105565:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000105568:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010556b:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105572:	80 ff ff 
ffff800000105575:	89 50 7c             	mov    %edx,0x7c(%rax)
  b->flags |= B_DIRTY; // prevent eviction
ffff800000105578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010557c:	8b 00                	mov    (%rax),%eax
ffff80000010557e:	83 c8 04             	or     $0x4,%eax
ffff800000105581:	89 c2                	mov    %eax,%edx
ffff800000105583:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105587:	89 10                	mov    %edx,(%rax)
  release(&log.lock);
ffff800000105589:	48 b8 e0 81 11 00 00 	movabs $0xffff8000001181e0,%rax
ffff800000105590:	80 ff ff 
ffff800000105593:	48 89 c7             	mov    %rax,%rdi
ffff800000105596:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010559d:	80 ff ff 
ffff8000001055a0:	ff d0                	call   *%rax
}
ffff8000001055a2:	90                   	nop
ffff8000001055a3:	c9                   	leave
ffff8000001055a4:	c3                   	ret

ffff8000001055a5 <v2p>:
#define KERNBASE 0xFFFF800000000000 // First kernel virtual address

#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__
static inline addr_t v2p(void *a) {
ffff8000001055a5:	55                   	push   %rbp
ffff8000001055a6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001055a9:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001055ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return ((addr_t) (a)) - ((addr_t)KERNBASE);
ffff8000001055b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001055b5:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff8000001055bc:	80 00 00 
ffff8000001055bf:	48 01 d0             	add    %rdx,%rax
}
ffff8000001055c2:	c9                   	leave
ffff8000001055c3:	c3                   	ret

ffff8000001055c4 <xchg>:

static inline uint
xchg(volatile uint *addr, addr_t newval)
{
ffff8000001055c4:	55                   	push   %rbp
ffff8000001055c5:	48 89 e5             	mov    %rsp,%rbp
ffff8000001055c8:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001055cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001055d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
ffff8000001055d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001055d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001055dc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff8000001055e0:	f0 87 02             	lock xchg %eax,(%rdx)
ffff8000001055e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
ffff8000001055e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001055e9:	c9                   	leave
ffff8000001055ea:	c3                   	ret

ffff8000001055eb <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
ffff8000001055eb:	55                   	push   %rbp
ffff8000001055ec:	48 89 e5             	mov    %rsp,%rbp
  uartearlyinit();
ffff8000001055ef:	48 b8 1f a1 10 00 00 	movabs $0xffff80000010a11f,%rax
ffff8000001055f6:	80 ff ff 
ffff8000001055f9:	ff d0                	call   *%rax
  kinit1(end, P2V(PHYSTOP)); // phys page allocator
ffff8000001055fb:	48 ba 00 00 00 0e 00 	movabs $0xffff80000e000000,%rdx
ffff800000105602:	80 ff ff 
ffff800000105605:	48 b8 00 e0 11 00 00 	movabs $0xffff80000011e000,%rax
ffff80000010560c:	80 ff ff 
ffff80000010560f:	48 89 d6             	mov    %rdx,%rsi
ffff800000105612:	48 89 c7             	mov    %rax,%rdi
ffff800000105615:	48 b8 ea 40 10 00 00 	movabs $0xffff8000001040ea,%rax
ffff80000010561c:	80 ff ff 
ffff80000010561f:	ff d0                	call   *%rax
  kvmalloc();      // kernel page table
ffff800000105621:	48 b8 a7 b3 10 00 00 	movabs $0xffff80000010b3a7,%rax
ffff800000105628:	80 ff ff 
ffff80000010562b:	ff d0                	call   *%rax
  mpinit();        // detect other processors
ffff80000010562d:	48 b8 fb 5b 10 00 00 	movabs $0xffff800000105bfb,%rax
ffff800000105634:	80 ff ff 
ffff800000105637:	ff d0                	call   *%rax
  lapicinit();     // interrupt controller
ffff800000105639:	48 b8 fb 46 10 00 00 	movabs $0xffff8000001046fb,%rax
ffff800000105640:	80 ff ff 
ffff800000105643:	ff d0                	call   *%rax
  tvinit();        // trap vectors
ffff800000105645:	48 b8 3c 9b 10 00 00 	movabs $0xffff800000109b3c,%rax
ffff80000010564c:	80 ff ff 
ffff80000010564f:	ff d0                	call   *%rax
  seginit();       // segment descriptors
ffff800000105651:	48 b8 ec ae 10 00 00 	movabs $0xffff80000010aeec,%rax
ffff800000105658:	80 ff ff 
ffff80000010565b:	ff d0                	call   *%rax
  cprintf("\ncpu%d: starting Spring 2026 xv6\n\n", cpunum());
ffff80000010565d:	48 b8 89 48 10 00 00 	movabs $0xffff800000104889,%rax
ffff800000105664:	80 ff ff 
ffff800000105667:	ff d0                	call   *%rax
ffff800000105669:	89 c2                	mov    %eax,%edx
ffff80000010566b:	48 b8 60 c9 10 00 00 	movabs $0xffff80000010c960,%rax
ffff800000105672:	80 ff ff 
ffff800000105675:	89 d6                	mov    %edx,%esi
ffff800000105677:	48 89 c7             	mov    %rax,%rdi
ffff80000010567a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010567f:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000105686:	80 ff ff 
ffff800000105689:	ff d2                	call   *%rdx
  ioapicinit();    // another interrupt controller
ffff80000010568b:	48 b8 b5 3f 10 00 00 	movabs $0xffff800000103fb5,%rax
ffff800000105692:	80 ff ff 
ffff800000105695:	ff d0                	call   *%rax
  consoleinit();   // console hardware
ffff800000105697:	48 b8 c1 15 10 00 00 	movabs $0xffff8000001015c1,%rax
ffff80000010569e:	80 ff ff 
ffff8000001056a1:	ff d0                	call   *%rax
  uartinit();      // serial port
ffff8000001056a3:	48 b8 23 a2 10 00 00 	movabs $0xffff80000010a223,%rax
ffff8000001056aa:	80 ff ff 
ffff8000001056ad:	ff d0                	call   *%rax
  
  traceinit();     // trace buffer
ffff8000001056af:	48 b8 62 c2 10 00 00 	movabs $0xffff80000010c262,%rax
ffff8000001056b6:	80 ff ff 
ffff8000001056b9:	ff d0                	call   *%rax

  pinit();         // process table
ffff8000001056bb:	48 b8 3b 63 10 00 00 	movabs $0xffff80000010633b,%rax
ffff8000001056c2:	80 ff ff 
ffff8000001056c5:	ff d0                	call   *%rax
  binit();         // buffer cache
ffff8000001056c7:	48 b8 1b 01 10 00 00 	movabs $0xffff80000010011b,%rax
ffff8000001056ce:	80 ff ff 
ffff8000001056d1:	ff d0                	call   *%rax
  fileinit();      // file table
ffff8000001056d3:	48 b8 45 1c 10 00 00 	movabs $0xffff800000101c45,%rax
ffff8000001056da:	80 ff ff 
ffff8000001056dd:	ff d0                	call   *%rax
  ideinit();       // disk
ffff8000001056df:	48 b8 04 3a 10 00 00 	movabs $0xffff800000103a04,%rax
ffff8000001056e6:	80 ff ff 
ffff8000001056e9:	ff d0                	call   *%rax
  startothers();   // start other processors
ffff8000001056eb:	48 b8 c8 57 10 00 00 	movabs $0xffff8000001057c8,%rax
ffff8000001056f2:	80 ff ff 
ffff8000001056f5:	ff d0                	call   *%rax
  kinit2();
ffff8000001056f7:	48 b8 60 41 10 00 00 	movabs $0xffff800000104160,%rax
ffff8000001056fe:	80 ff ff 
ffff800000105701:	ff d0                	call   *%rax
  userinit();      // first user process
ffff800000105703:	48 b8 e6 64 10 00 00 	movabs $0xffff8000001064e6,%rax
ffff80000010570a:	80 ff ff 
ffff80000010570d:	ff d0                	call   *%rax
  mpmain();        // finish this processor's setup
ffff80000010570f:	48 b8 4f 57 10 00 00 	movabs $0xffff80000010574f,%rax
ffff800000105716:	80 ff ff 
ffff800000105719:	ff d0                	call   *%rax

ffff80000010571b <mpenter>:
}

// Other CPUs jump here from entryother.S.
void
mpenter(void)
{
ffff80000010571b:	55                   	push   %rbp
ffff80000010571c:	48 89 e5             	mov    %rsp,%rbp
  switchkvm();
ffff80000010571f:	48 b8 a8 b7 10 00 00 	movabs $0xffff80000010b7a8,%rax
ffff800000105726:	80 ff ff 
ffff800000105729:	ff d0                	call   *%rax
  seginit();
ffff80000010572b:	48 b8 ec ae 10 00 00 	movabs $0xffff80000010aeec,%rax
ffff800000105732:	80 ff ff 
ffff800000105735:	ff d0                	call   *%rax
  lapicinit();
ffff800000105737:	48 b8 fb 46 10 00 00 	movabs $0xffff8000001046fb,%rax
ffff80000010573e:	80 ff ff 
ffff800000105741:	ff d0                	call   *%rax
  mpmain();
ffff800000105743:	48 b8 4f 57 10 00 00 	movabs $0xffff80000010574f,%rax
ffff80000010574a:	80 ff ff 
ffff80000010574d:	ff d0                	call   *%rax

ffff80000010574f <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
ffff80000010574f:	55                   	push   %rbp
ffff800000105750:	48 89 e5             	mov    %rsp,%rbp
  cprintf("cpu%d: starting\n", cpunum());
ffff800000105753:	48 b8 89 48 10 00 00 	movabs $0xffff800000104889,%rax
ffff80000010575a:	80 ff ff 
ffff80000010575d:	ff d0                	call   *%rax
ffff80000010575f:	89 c2                	mov    %eax,%edx
ffff800000105761:	48 b8 83 c9 10 00 00 	movabs $0xffff80000010c983,%rax
ffff800000105768:	80 ff ff 
ffff80000010576b:	89 d6                	mov    %edx,%esi
ffff80000010576d:	48 89 c7             	mov    %rax,%rdi
ffff800000105770:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105775:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff80000010577c:	80 ff ff 
ffff80000010577f:	ff d2                	call   *%rdx
  idtinit();       // load idt register
ffff800000105781:	48 b8 14 9b 10 00 00 	movabs $0xffff800000109b14,%rax
ffff800000105788:	80 ff ff 
ffff80000010578b:	ff d0                	call   *%rax
  syscallinit();   // syscall set up
ffff80000010578d:	48 b8 75 ae 10 00 00 	movabs $0xffff80000010ae75,%rax
ffff800000105794:	80 ff ff 
ffff800000105797:	ff d0                	call   *%rax
  xchg(&cpu->started, 1); // tell startothers() we're up
ffff800000105799:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff8000001057a0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001057a4:	48 83 c0 10          	add    $0x10,%rax
ffff8000001057a8:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001057ad:	48 89 c7             	mov    %rax,%rdi
ffff8000001057b0:	48 b8 c4 55 10 00 00 	movabs $0xffff8000001055c4,%rax
ffff8000001057b7:	80 ff ff 
ffff8000001057ba:	ff d0                	call   *%rax
  scheduler();     // start running processes
ffff8000001057bc:	48 b8 d2 6d 10 00 00 	movabs $0xffff800000106dd2,%rax
ffff8000001057c3:	80 ff ff 
ffff8000001057c6:	ff d0                	call   *%rax

ffff8000001057c8 <startothers>:
void entry32mp(void);

// Start the non-boot (AP) processors.
static void
startothers(void)
{
ffff8000001057c8:	55                   	push   %rbp
ffff8000001057c9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001057cc:	48 83 ec 20          	sub    $0x20,%rsp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
ffff8000001057d0:	48 b8 00 70 00 00 00 	movabs $0xffff800000007000,%rax
ffff8000001057d7:	80 ff ff 
ffff8000001057da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  memmove(code, _binary_entryother_start,
ffff8000001057de:	48 b8 72 00 00 00 00 	movabs $0x72,%rax
ffff8000001057e5:	00 00 00 
ffff8000001057e8:	89 c2                	mov    %eax,%edx
ffff8000001057ea:	48 b9 90 df 10 00 00 	movabs $0xffff80000010df90,%rcx
ffff8000001057f1:	80 ff ff 
ffff8000001057f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001057f8:	48 89 ce             	mov    %rcx,%rsi
ffff8000001057fb:	48 89 c7             	mov    %rax,%rdi
ffff8000001057fe:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff800000105805:	80 ff ff 
ffff800000105808:	ff d0                	call   *%rax
          (addr_t)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
ffff80000010580a:	48 b8 e0 82 11 00 00 	movabs $0xffff8000001182e0,%rax
ffff800000105811:	80 ff ff 
ffff800000105814:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105818:	e9 c6 00 00 00       	jmp    ffff8000001058e3 <startothers+0x11b>
    if(c == cpus+cpunum())  // We've started already.
ffff80000010581d:	48 b8 89 48 10 00 00 	movabs $0xffff800000104889,%rax
ffff800000105824:	80 ff ff 
ffff800000105827:	ff d0                	call   *%rax
ffff800000105829:	48 63 d0             	movslq %eax,%rdx
ffff80000010582c:	48 89 d0             	mov    %rdx,%rax
ffff80000010582f:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000105833:	48 01 d0             	add    %rdx,%rax
ffff800000105836:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010583a:	48 89 c2             	mov    %rax,%rdx
ffff80000010583d:	48 b8 e0 82 11 00 00 	movabs $0xffff8000001182e0,%rax
ffff800000105844:	80 ff ff 
ffff800000105847:	48 01 d0             	add    %rdx,%rax
ffff80000010584a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010584e:	0f 84 89 00 00 00    	je     ffff8000001058dd <startothers+0x115>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
ffff800000105854:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff80000010585b:	80 ff ff 
ffff80000010585e:	ff d0                	call   *%rax
ffff800000105860:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    *(uint32*)(code-4) = 0x8000; // enough stack to get us to entry64mp
ffff800000105864:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105868:	48 83 e8 04          	sub    $0x4,%rax
ffff80000010586c:	c7 00 00 80 00 00    	movl   $0x8000,(%rax)
    *(uint32*)(code-8) = v2p(entry32mp);
ffff800000105872:	48 b8 49 00 10 00 00 	movabs $0xffff800000100049,%rax
ffff800000105879:	80 ff ff 
ffff80000010587c:	48 89 c7             	mov    %rax,%rdi
ffff80000010587f:	48 b8 a5 55 10 00 00 	movabs $0xffff8000001055a5,%rax
ffff800000105886:	80 ff ff 
ffff800000105889:	ff d0                	call   *%rax
ffff80000010588b:	48 89 c2             	mov    %rax,%rdx
ffff80000010588e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105892:	48 83 e8 08          	sub    $0x8,%rax
ffff800000105896:	89 10                	mov    %edx,(%rax)
    *(uint64*)(code-16) = (uint64) (stack + KSTACKSIZE);
ffff800000105898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010589c:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
ffff8000001058a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001058a7:	48 83 e8 10          	sub    $0x10,%rax
ffff8000001058ab:	48 89 10             	mov    %rdx,(%rax)

    lapicstartap(c->apicid, V2P(code));
ffff8000001058ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001058b2:	89 c2                	mov    %eax,%edx
ffff8000001058b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001058b8:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffff8000001058bc:	0f b6 c0             	movzbl %al,%eax
ffff8000001058bf:	89 d6                	mov    %edx,%esi
ffff8000001058c1:	89 c7                	mov    %eax,%edi
ffff8000001058c3:	48 b8 ce 49 10 00 00 	movabs $0xffff8000001049ce,%rax
ffff8000001058ca:	80 ff ff 
ffff8000001058cd:	ff d0                	call   *%rax

    // wait for cpu to finish mpmain()
    while(c->started == 0)
ffff8000001058cf:	90                   	nop
ffff8000001058d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001058d4:	8b 40 10             	mov    0x10(%rax),%eax
ffff8000001058d7:	85 c0                	test   %eax,%eax
ffff8000001058d9:	74 f5                	je     ffff8000001058d0 <startothers+0x108>
ffff8000001058db:	eb 01                	jmp    ffff8000001058de <startothers+0x116>
      continue;
ffff8000001058dd:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
ffff8000001058de:	48 83 45 f8 28       	addq   $0x28,-0x8(%rbp)
ffff8000001058e3:	48 b8 20 84 11 00 00 	movabs $0xffff800000118420,%rax
ffff8000001058ea:	80 ff ff 
ffff8000001058ed:	8b 00                	mov    (%rax),%eax
ffff8000001058ef:	48 63 d0             	movslq %eax,%rdx
ffff8000001058f2:	48 89 d0             	mov    %rdx,%rax
ffff8000001058f5:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001058f9:	48 01 d0             	add    %rdx,%rax
ffff8000001058fc:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000105900:	48 89 c2             	mov    %rax,%rdx
ffff800000105903:	48 b8 e0 82 11 00 00 	movabs $0xffff8000001182e0,%rax
ffff80000010590a:	80 ff ff 
ffff80000010590d:	48 01 d0             	add    %rdx,%rax
ffff800000105910:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000105914:	0f 82 03 ff ff ff    	jb     ffff80000010581d <startothers+0x55>
      ;
  }
}
ffff80000010591a:	90                   	nop
ffff80000010591b:	90                   	nop
ffff80000010591c:	c9                   	leave
ffff80000010591d:	c3                   	ret

ffff80000010591e <inb>:
{
ffff80000010591e:	55                   	push   %rbp
ffff80000010591f:	48 89 e5             	mov    %rsp,%rbp
ffff800000105922:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000105926:	89 f8                	mov    %edi,%eax
ffff800000105928:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff80000010592c:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000105930:	89 c2                	mov    %eax,%edx
ffff800000105932:	ec                   	in     (%dx),%al
ffff800000105933:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff800000105936:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010593a:	c9                   	leave
ffff80000010593b:	c3                   	ret

ffff80000010593c <outb>:
{
ffff80000010593c:	55                   	push   %rbp
ffff80000010593d:	48 89 e5             	mov    %rsp,%rbp
ffff800000105940:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000105944:	89 fa                	mov    %edi,%edx
ffff800000105946:	89 f0                	mov    %esi,%eax
ffff800000105948:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffff80000010594c:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff80000010594f:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000105953:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff800000105957:	ee                   	out    %al,(%dx)
}
ffff800000105958:	90                   	nop
ffff800000105959:	c9                   	leave
ffff80000010595a:	c3                   	ret

ffff80000010595b <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
ffff80000010595b:	55                   	push   %rbp
ffff80000010595c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010595f:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105963:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105967:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, sum;

  sum = 0;
ffff80000010596a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  for(i=0; i<len; i++)
ffff800000105971:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000105978:	eb 1a                	jmp    ffff800000105994 <sum+0x39>
    sum += addr[i];
ffff80000010597a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010597d:	48 63 d0             	movslq %eax,%rdx
ffff800000105980:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105984:	48 01 d0             	add    %rdx,%rax
ffff800000105987:	0f b6 00             	movzbl (%rax),%eax
ffff80000010598a:	0f b6 c0             	movzbl %al,%eax
ffff80000010598d:	01 45 f8             	add    %eax,-0x8(%rbp)
  for(i=0; i<len; i++)
ffff800000105990:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105994:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000105997:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
ffff80000010599a:	7c de                	jl     ffff80000010597a <sum+0x1f>
  return sum;
ffff80000010599c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
ffff80000010599f:	c9                   	leave
ffff8000001059a0:	c3                   	ret

ffff8000001059a1 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(addr_t a, int len)
{
ffff8000001059a1:	55                   	push   %rbp
ffff8000001059a2:	48 89 e5             	mov    %rsp,%rbp
ffff8000001059a5:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001059a9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff8000001059ad:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  uchar *e, *p, *addr;
  addr = P2V(a);
ffff8000001059b0:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff8000001059b7:	80 ff ff 
ffff8000001059ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001059be:	48 01 d0             	add    %rdx,%rax
ffff8000001059c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  e = addr+len;
ffff8000001059c5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff8000001059c8:	48 63 d0             	movslq %eax,%rdx
ffff8000001059cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001059cf:	48 01 d0             	add    %rdx,%rax
ffff8000001059d2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for(p = addr; p < e; p += sizeof(struct mp))
ffff8000001059d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001059da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001059de:	eb 50                	jmp    ffff800000105a30 <mpsearch1+0x8f>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
ffff8000001059e0:	48 b9 98 c9 10 00 00 	movabs $0xffff80000010c998,%rcx
ffff8000001059e7:	80 ff ff 
ffff8000001059ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001059ee:	ba 04 00 00 00       	mov    $0x4,%edx
ffff8000001059f3:	48 89 ce             	mov    %rcx,%rsi
ffff8000001059f6:	48 89 c7             	mov    %rax,%rdi
ffff8000001059f9:	48 b8 04 7b 10 00 00 	movabs $0xffff800000107b04,%rax
ffff800000105a00:	80 ff ff 
ffff800000105a03:	ff d0                	call   *%rax
ffff800000105a05:	85 c0                	test   %eax,%eax
ffff800000105a07:	75 22                	jne    ffff800000105a2b <mpsearch1+0x8a>
ffff800000105a09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a0d:	be 10 00 00 00       	mov    $0x10,%esi
ffff800000105a12:	48 89 c7             	mov    %rax,%rdi
ffff800000105a15:	48 b8 5b 59 10 00 00 	movabs $0xffff80000010595b,%rax
ffff800000105a1c:	80 ff ff 
ffff800000105a1f:	ff d0                	call   *%rax
ffff800000105a21:	84 c0                	test   %al,%al
ffff800000105a23:	75 06                	jne    ffff800000105a2b <mpsearch1+0x8a>
      return (struct mp*)p;
ffff800000105a25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a29:	eb 14                	jmp    ffff800000105a3f <mpsearch1+0x9e>
  for(p = addr; p < e; p += sizeof(struct mp))
ffff800000105a2b:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
ffff800000105a30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a34:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff800000105a38:	72 a6                	jb     ffff8000001059e0 <mpsearch1+0x3f>
  return 0;
ffff800000105a3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000105a3f:	c9                   	leave
ffff800000105a40:	c3                   	ret

ffff800000105a41 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
ffff800000105a41:	55                   	push   %rbp
ffff800000105a42:	48 89 e5             	mov    %rsp,%rbp
ffff800000105a45:	48 83 ec 20          	sub    $0x20,%rsp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
ffff800000105a49:	48 b8 00 04 00 00 00 	movabs $0xffff800000000400,%rax
ffff800000105a50:	80 ff ff 
ffff800000105a53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
ffff800000105a57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a5b:	48 83 c0 0f          	add    $0xf,%rax
ffff800000105a5f:	0f b6 00             	movzbl (%rax),%eax
ffff800000105a62:	0f b6 c0             	movzbl %al,%eax
ffff800000105a65:	c1 e0 08             	shl    $0x8,%eax
ffff800000105a68:	89 c2                	mov    %eax,%edx
ffff800000105a6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a6e:	48 83 c0 0e          	add    $0xe,%rax
ffff800000105a72:	0f b6 00             	movzbl (%rax),%eax
ffff800000105a75:	0f b6 c0             	movzbl %al,%eax
ffff800000105a78:	09 d0                	or     %edx,%eax
ffff800000105a7a:	c1 e0 04             	shl    $0x4,%eax
ffff800000105a7d:	89 45 f4             	mov    %eax,-0xc(%rbp)
ffff800000105a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000105a84:	74 28                	je     ffff800000105aae <mpsearch+0x6d>
    if((mp = mpsearch1(p, 1024)))
ffff800000105a86:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000105a89:	be 00 04 00 00       	mov    $0x400,%esi
ffff800000105a8e:	48 89 c7             	mov    %rax,%rdi
ffff800000105a91:	48 b8 a1 59 10 00 00 	movabs $0xffff8000001059a1,%rax
ffff800000105a98:	80 ff ff 
ffff800000105a9b:	ff d0                	call   *%rax
ffff800000105a9d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000105aa1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000105aa6:	74 5e                	je     ffff800000105b06 <mpsearch+0xc5>
      return mp;
ffff800000105aa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105aac:	eb 6e                	jmp    ffff800000105b1c <mpsearch+0xdb>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
ffff800000105aae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ab2:	48 83 c0 14          	add    $0x14,%rax
ffff800000105ab6:	0f b6 00             	movzbl (%rax),%eax
ffff800000105ab9:	0f b6 c0             	movzbl %al,%eax
ffff800000105abc:	c1 e0 08             	shl    $0x8,%eax
ffff800000105abf:	89 c2                	mov    %eax,%edx
ffff800000105ac1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ac5:	48 83 c0 13          	add    $0x13,%rax
ffff800000105ac9:	0f b6 00             	movzbl (%rax),%eax
ffff800000105acc:	0f b6 c0             	movzbl %al,%eax
ffff800000105acf:	09 d0                	or     %edx,%eax
ffff800000105ad1:	c1 e0 0a             	shl    $0xa,%eax
ffff800000105ad4:	89 45 f4             	mov    %eax,-0xc(%rbp)
    if((mp = mpsearch1(p-1024, 1024)))
ffff800000105ad7:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000105ada:	2d 00 04 00 00       	sub    $0x400,%eax
ffff800000105adf:	89 c0                	mov    %eax,%eax
ffff800000105ae1:	be 00 04 00 00       	mov    $0x400,%esi
ffff800000105ae6:	48 89 c7             	mov    %rax,%rdi
ffff800000105ae9:	48 b8 a1 59 10 00 00 	movabs $0xffff8000001059a1,%rax
ffff800000105af0:	80 ff ff 
ffff800000105af3:	ff d0                	call   *%rax
ffff800000105af5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000105af9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000105afe:	74 06                	je     ffff800000105b06 <mpsearch+0xc5>
      return mp;
ffff800000105b00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105b04:	eb 16                	jmp    ffff800000105b1c <mpsearch+0xdb>
  }
  return mpsearch1(0xF0000, 0x10000);
ffff800000105b06:	be 00 00 01 00       	mov    $0x10000,%esi
ffff800000105b0b:	bf 00 00 0f 00       	mov    $0xf0000,%edi
ffff800000105b10:	48 b8 a1 59 10 00 00 	movabs $0xffff8000001059a1,%rax
ffff800000105b17:	80 ff ff 
ffff800000105b1a:	ff d0                	call   *%rax
}
ffff800000105b1c:	c9                   	leave
ffff800000105b1d:	c3                   	ret

ffff800000105b1e <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
ffff800000105b1e:	55                   	push   %rbp
ffff800000105b1f:	48 89 e5             	mov    %rsp,%rbp
ffff800000105b22:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105b26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
ffff800000105b2a:	48 b8 41 5a 10 00 00 	movabs $0xffff800000105a41,%rax
ffff800000105b31:	80 ff ff 
ffff800000105b34:	ff d0                	call   *%rax
ffff800000105b36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105b3a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000105b3f:	74 0b                	je     ffff800000105b4c <mpconfig+0x2e>
ffff800000105b41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105b45:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000105b48:	85 c0                	test   %eax,%eax
ffff800000105b4a:	75 0a                	jne    ffff800000105b56 <mpconfig+0x38>
    return 0;
ffff800000105b4c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105b51:	e9 a3 00 00 00       	jmp    ffff800000105bf9 <mpconfig+0xdb>
  conf = (struct mpconf*) P2V((addr_t) mp->physaddr);
ffff800000105b56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105b5a:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000105b5d:	89 c2                	mov    %eax,%edx
ffff800000105b5f:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff800000105b66:	80 ff ff 
ffff800000105b69:	48 01 d0             	add    %rdx,%rax
ffff800000105b6c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(memcmp(conf, "PCMP", 4) != 0)
ffff800000105b70:	48 b9 9d c9 10 00 00 	movabs $0xffff80000010c99d,%rcx
ffff800000105b77:	80 ff ff 
ffff800000105b7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105b7e:	ba 04 00 00 00       	mov    $0x4,%edx
ffff800000105b83:	48 89 ce             	mov    %rcx,%rsi
ffff800000105b86:	48 89 c7             	mov    %rax,%rdi
ffff800000105b89:	48 b8 04 7b 10 00 00 	movabs $0xffff800000107b04,%rax
ffff800000105b90:	80 ff ff 
ffff800000105b93:	ff d0                	call   *%rax
ffff800000105b95:	85 c0                	test   %eax,%eax
ffff800000105b97:	74 07                	je     ffff800000105ba0 <mpconfig+0x82>
    return 0;
ffff800000105b99:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105b9e:	eb 59                	jmp    ffff800000105bf9 <mpconfig+0xdb>
  if(conf->version != 1 && conf->version != 4)
ffff800000105ba0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105ba4:	0f b6 40 06          	movzbl 0x6(%rax),%eax
ffff800000105ba8:	3c 01                	cmp    $0x1,%al
ffff800000105baa:	74 13                	je     ffff800000105bbf <mpconfig+0xa1>
ffff800000105bac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105bb0:	0f b6 40 06          	movzbl 0x6(%rax),%eax
ffff800000105bb4:	3c 04                	cmp    $0x4,%al
ffff800000105bb6:	74 07                	je     ffff800000105bbf <mpconfig+0xa1>
    return 0;
ffff800000105bb8:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105bbd:	eb 3a                	jmp    ffff800000105bf9 <mpconfig+0xdb>
  if(sum((uchar*)conf, conf->length) != 0)
ffff800000105bbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105bc3:	0f b7 40 04          	movzwl 0x4(%rax),%eax
ffff800000105bc7:	0f b7 d0             	movzwl %ax,%edx
ffff800000105bca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105bce:	89 d6                	mov    %edx,%esi
ffff800000105bd0:	48 89 c7             	mov    %rax,%rdi
ffff800000105bd3:	48 b8 5b 59 10 00 00 	movabs $0xffff80000010595b,%rax
ffff800000105bda:	80 ff ff 
ffff800000105bdd:	ff d0                	call   *%rax
ffff800000105bdf:	84 c0                	test   %al,%al
ffff800000105be1:	74 07                	je     ffff800000105bea <mpconfig+0xcc>
    return 0;
ffff800000105be3:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105be8:	eb 0f                	jmp    ffff800000105bf9 <mpconfig+0xdb>
  *pmp = mp;
ffff800000105bea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105bee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105bf2:	48 89 10             	mov    %rdx,(%rax)
  return conf;
ffff800000105bf5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
ffff800000105bf9:	c9                   	leave
ffff800000105bfa:	c3                   	ret

ffff800000105bfb <mpinit>:

void
mpinit(void)
{
ffff800000105bfb:	55                   	push   %rbp
ffff800000105bfc:	48 89 e5             	mov    %rsp,%rbp
ffff800000105bff:	48 83 ec 30          	sub    $0x30,%rsp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0) {
ffff800000105c03:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffff800000105c07:	48 89 c7             	mov    %rax,%rdi
ffff800000105c0a:	48 b8 1e 5b 10 00 00 	movabs $0xffff800000105b1e,%rax
ffff800000105c11:	80 ff ff 
ffff800000105c14:	ff d0                	call   *%rax
ffff800000105c16:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000105c1a:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000105c1f:	75 23                	jne    ffff800000105c44 <mpinit+0x49>
    cprintf("No other CPUs found.\n");
ffff800000105c21:	48 b8 a2 c9 10 00 00 	movabs $0xffff80000010c9a2,%rax
ffff800000105c28:	80 ff ff 
ffff800000105c2b:	48 89 c7             	mov    %rax,%rdi
ffff800000105c2e:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105c33:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000105c3a:	80 ff ff 
ffff800000105c3d:	ff d2                	call   *%rdx
ffff800000105c3f:	e9 c9 01 00 00       	jmp    ffff800000105e0d <mpinit+0x212>
    return;
  }
  lapic = P2V((addr_t)conf->lapicaddr_p);
ffff800000105c44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105c48:	8b 40 24             	mov    0x24(%rax),%eax
ffff800000105c4b:	89 c2                	mov    %eax,%edx
ffff800000105c4d:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff800000105c54:	80 ff ff 
ffff800000105c57:	48 01 d0             	add    %rdx,%rax
ffff800000105c5a:	48 89 c2             	mov    %rax,%rdx
ffff800000105c5d:	48 b8 c0 81 11 00 00 	movabs $0xffff8000001181c0,%rax
ffff800000105c64:	80 ff ff 
ffff800000105c67:	48 89 10             	mov    %rdx,(%rax)
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
ffff800000105c6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105c6e:	48 83 c0 2c          	add    $0x2c,%rax
ffff800000105c72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105c76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105c7a:	0f b7 40 04          	movzwl 0x4(%rax),%eax
ffff800000105c7e:	0f b7 d0             	movzwl %ax,%edx
ffff800000105c81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105c85:	48 01 d0             	add    %rdx,%rax
ffff800000105c88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000105c8c:	e9 f6 00 00 00       	jmp    ffff800000105d87 <mpinit+0x18c>
    switch(*p){
ffff800000105c91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105c95:	0f b6 00             	movzbl (%rax),%eax
ffff800000105c98:	0f b6 c0             	movzbl %al,%eax
ffff800000105c9b:	83 f8 04             	cmp    $0x4,%eax
ffff800000105c9e:	0f 8f ca 00 00 00    	jg     ffff800000105d6e <mpinit+0x173>
ffff800000105ca4:	83 f8 03             	cmp    $0x3,%eax
ffff800000105ca7:	0f 8d ba 00 00 00    	jge    ffff800000105d67 <mpinit+0x16c>
ffff800000105cad:	83 f8 02             	cmp    $0x2,%eax
ffff800000105cb0:	0f 84 8e 00 00 00    	je     ffff800000105d44 <mpinit+0x149>
ffff800000105cb6:	83 f8 02             	cmp    $0x2,%eax
ffff800000105cb9:	0f 8f af 00 00 00    	jg     ffff800000105d6e <mpinit+0x173>
ffff800000105cbf:	85 c0                	test   %eax,%eax
ffff800000105cc1:	74 0e                	je     ffff800000105cd1 <mpinit+0xd6>
ffff800000105cc3:	83 f8 01             	cmp    $0x1,%eax
ffff800000105cc6:	0f 84 9b 00 00 00    	je     ffff800000105d67 <mpinit+0x16c>
ffff800000105ccc:	e9 9d 00 00 00       	jmp    ffff800000105d6e <mpinit+0x173>
    case MPPROC:
      proc = (struct mpproc*)p;
ffff800000105cd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105cd5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
      if(ncpu < NCPU) {
ffff800000105cd9:	48 b8 20 84 11 00 00 	movabs $0xffff800000118420,%rax
ffff800000105ce0:	80 ff ff 
ffff800000105ce3:	8b 00                	mov    (%rax),%eax
ffff800000105ce5:	83 f8 07             	cmp    $0x7,%eax
ffff800000105ce8:	7f 53                	jg     ffff800000105d3d <mpinit+0x142>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
ffff800000105cea:	48 b8 20 84 11 00 00 	movabs $0xffff800000118420,%rax
ffff800000105cf1:	80 ff ff 
ffff800000105cf4:	8b 10                	mov    (%rax),%edx
ffff800000105cf6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000105cfa:	0f b6 48 01          	movzbl 0x1(%rax),%ecx
ffff800000105cfe:	48 be e0 82 11 00 00 	movabs $0xffff8000001182e0,%rsi
ffff800000105d05:	80 ff ff 
ffff800000105d08:	48 63 d2             	movslq %edx,%rdx
ffff800000105d0b:	48 89 d0             	mov    %rdx,%rax
ffff800000105d0e:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000105d12:	48 01 d0             	add    %rdx,%rax
ffff800000105d15:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000105d19:	48 01 f0             	add    %rsi,%rax
ffff800000105d1c:	48 83 c0 01          	add    $0x1,%rax
ffff800000105d20:	88 08                	mov    %cl,(%rax)
        ncpu++;
ffff800000105d22:	48 b8 20 84 11 00 00 	movabs $0xffff800000118420,%rax
ffff800000105d29:	80 ff ff 
ffff800000105d2c:	8b 00                	mov    (%rax),%eax
ffff800000105d2e:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000105d31:	48 b8 20 84 11 00 00 	movabs $0xffff800000118420,%rax
ffff800000105d38:	80 ff ff 
ffff800000105d3b:	89 10                	mov    %edx,(%rax)
      }
      p += sizeof(struct mpproc);
ffff800000105d3d:	48 83 45 f8 14       	addq   $0x14,-0x8(%rbp)
      continue;
ffff800000105d42:	eb 43                	jmp    ffff800000105d87 <mpinit+0x18c>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
ffff800000105d44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d48:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
      ioapicid = ioapic->apicno;
ffff800000105d4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105d50:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffff800000105d54:	48 ba 24 84 11 00 00 	movabs $0xffff800000118424,%rdx
ffff800000105d5b:	80 ff ff 
ffff800000105d5e:	88 02                	mov    %al,(%rdx)
      p += sizeof(struct mpioapic);
ffff800000105d60:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
      continue;
ffff800000105d65:	eb 20                	jmp    ffff800000105d87 <mpinit+0x18c>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
ffff800000105d67:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
      continue;
ffff800000105d6c:	eb 19                	jmp    ffff800000105d87 <mpinit+0x18c>
    default:
      panic("Major problem parsing mp config.");
ffff800000105d6e:	48 b8 b8 c9 10 00 00 	movabs $0xffff80000010c9b8,%rax
ffff800000105d75:	80 ff ff 
ffff800000105d78:	48 89 c7             	mov    %rax,%rdi
ffff800000105d7b:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000105d82:	80 ff ff 
ffff800000105d85:	ff d0                	call   *%rax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
ffff800000105d87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d8b:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff800000105d8f:	0f 82 fc fe ff ff    	jb     ffff800000105c91 <mpinit+0x96>
      break;
    }
  }
  cprintf("Seems we are SMP, ncpu = %d\n",ncpu);
ffff800000105d95:	48 b8 20 84 11 00 00 	movabs $0xffff800000118420,%rax
ffff800000105d9c:	80 ff ff 
ffff800000105d9f:	8b 00                	mov    (%rax),%eax
ffff800000105da1:	48 ba d9 c9 10 00 00 	movabs $0xffff80000010c9d9,%rdx
ffff800000105da8:	80 ff ff 
ffff800000105dab:	89 c6                	mov    %eax,%esi
ffff800000105dad:	48 89 d7             	mov    %rdx,%rdi
ffff800000105db0:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105db5:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000105dbc:	80 ff ff 
ffff800000105dbf:	ff d2                	call   *%rdx
  if(mp->imcrp){
ffff800000105dc1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000105dc5:	0f b6 40 0c          	movzbl 0xc(%rax),%eax
ffff800000105dc9:	84 c0                	test   %al,%al
ffff800000105dcb:	74 40                	je     ffff800000105e0d <mpinit+0x212>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
ffff800000105dcd:	be 70 00 00 00       	mov    $0x70,%esi
ffff800000105dd2:	bf 22 00 00 00       	mov    $0x22,%edi
ffff800000105dd7:	48 b8 3c 59 10 00 00 	movabs $0xffff80000010593c,%rax
ffff800000105dde:	80 ff ff 
ffff800000105de1:	ff d0                	call   *%rax
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
ffff800000105de3:	bf 23 00 00 00       	mov    $0x23,%edi
ffff800000105de8:	48 b8 1e 59 10 00 00 	movabs $0xffff80000010591e,%rax
ffff800000105def:	80 ff ff 
ffff800000105df2:	ff d0                	call   *%rax
ffff800000105df4:	83 c8 01             	or     $0x1,%eax
ffff800000105df7:	0f b6 c0             	movzbl %al,%eax
ffff800000105dfa:	89 c6                	mov    %eax,%esi
ffff800000105dfc:	bf 23 00 00 00       	mov    $0x23,%edi
ffff800000105e01:	48 b8 3c 59 10 00 00 	movabs $0xffff80000010593c,%rax
ffff800000105e08:	80 ff ff 
ffff800000105e0b:	ff d0                	call   *%rax
  }
}
ffff800000105e0d:	c9                   	leave
ffff800000105e0e:	c3                   	ret

ffff800000105e0f <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
ffff800000105e0f:	55                   	push   %rbp
ffff800000105e10:	48 89 e5             	mov    %rsp,%rbp
ffff800000105e13:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105e17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105e1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct pipe *p;

  p = 0;
ffff800000105e1f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
ffff800000105e26:	00 
  *f0 = *f1 = 0;
ffff800000105e27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105e2b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
ffff800000105e32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105e36:	48 8b 10             	mov    (%rax),%rdx
ffff800000105e39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105e3d:	48 89 10             	mov    %rdx,(%rax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
ffff800000105e40:	48 b8 72 1c 10 00 00 	movabs $0xffff800000101c72,%rax
ffff800000105e47:	80 ff ff 
ffff800000105e4a:	ff d0                	call   *%rax
ffff800000105e4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000105e50:	48 89 02             	mov    %rax,(%rdx)
ffff800000105e53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105e57:	48 8b 00             	mov    (%rax),%rax
ffff800000105e5a:	48 85 c0             	test   %rax,%rax
ffff800000105e5d:	0f 84 01 01 00 00    	je     ffff800000105f64 <pipealloc+0x155>
ffff800000105e63:	48 b8 72 1c 10 00 00 	movabs $0xffff800000101c72,%rax
ffff800000105e6a:	80 ff ff 
ffff800000105e6d:	ff d0                	call   *%rax
ffff800000105e6f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000105e73:	48 89 02             	mov    %rax,(%rdx)
ffff800000105e76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105e7a:	48 8b 00             	mov    (%rax),%rax
ffff800000105e7d:	48 85 c0             	test   %rax,%rax
ffff800000105e80:	0f 84 de 00 00 00    	je     ffff800000105f64 <pipealloc+0x155>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
ffff800000105e86:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff800000105e8d:	80 ff ff 
ffff800000105e90:	ff d0                	call   *%rax
ffff800000105e92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105e96:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000105e9b:	0f 84 c6 00 00 00    	je     ffff800000105f67 <pipealloc+0x158>
    goto bad;
  p->readopen = 1;
ffff800000105ea1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ea5:	c7 80 70 02 00 00 01 	movl   $0x1,0x270(%rax)
ffff800000105eac:	00 00 00 
  p->writeopen = 1;
ffff800000105eaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105eb3:	c7 80 74 02 00 00 01 	movl   $0x1,0x274(%rax)
ffff800000105eba:	00 00 00 
  p->nwrite = 0;
ffff800000105ebd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ec1:	c7 80 6c 02 00 00 00 	movl   $0x0,0x26c(%rax)
ffff800000105ec8:	00 00 00 
  p->nread = 0;
ffff800000105ecb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ecf:	c7 80 68 02 00 00 00 	movl   $0x0,0x268(%rax)
ffff800000105ed6:	00 00 00 
  initlock(&p->lock, "pipe");
ffff800000105ed9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105edd:	48 ba f6 c9 10 00 00 	movabs $0xffff80000010c9f6,%rdx
ffff800000105ee4:	80 ff ff 
ffff800000105ee7:	48 89 d6             	mov    %rdx,%rsi
ffff800000105eea:	48 89 c7             	mov    %rax,%rdi
ffff800000105eed:	48 b8 a5 76 10 00 00 	movabs $0xffff8000001076a5,%rax
ffff800000105ef4:	80 ff ff 
ffff800000105ef7:	ff d0                	call   *%rax
  (*f0)->type = FD_PIPE;
ffff800000105ef9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105efd:	48 8b 00             	mov    (%rax),%rax
ffff800000105f00:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f0)->readable = 1;
ffff800000105f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f0a:	48 8b 00             	mov    (%rax),%rax
ffff800000105f0d:	c6 40 08 01          	movb   $0x1,0x8(%rax)
  (*f0)->writable = 0;
ffff800000105f11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f15:	48 8b 00             	mov    (%rax),%rax
ffff800000105f18:	c6 40 09 00          	movb   $0x0,0x9(%rax)
  (*f0)->pipe = p;
ffff800000105f1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f20:	48 8b 00             	mov    (%rax),%rax
ffff800000105f23:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105f27:	48 89 50 10          	mov    %rdx,0x10(%rax)
  (*f1)->type = FD_PIPE;
ffff800000105f2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105f2f:	48 8b 00             	mov    (%rax),%rax
ffff800000105f32:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f1)->readable = 0;
ffff800000105f38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105f3c:	48 8b 00             	mov    (%rax),%rax
ffff800000105f3f:	c6 40 08 00          	movb   $0x0,0x8(%rax)
  (*f1)->writable = 1;
ffff800000105f43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105f47:	48 8b 00             	mov    (%rax),%rax
ffff800000105f4a:	c6 40 09 01          	movb   $0x1,0x9(%rax)
  (*f1)->pipe = p;
ffff800000105f4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105f52:	48 8b 00             	mov    (%rax),%rax
ffff800000105f55:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105f59:	48 89 50 10          	mov    %rdx,0x10(%rax)
  return 0;
ffff800000105f5d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105f62:	eb 67                	jmp    ffff800000105fcb <pipealloc+0x1bc>
    goto bad;
ffff800000105f64:	90                   	nop
ffff800000105f65:	eb 01                	jmp    ffff800000105f68 <pipealloc+0x159>
    goto bad;
ffff800000105f67:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
ffff800000105f68:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000105f6d:	74 13                	je     ffff800000105f82 <pipealloc+0x173>
    kfree((char*)p);
ffff800000105f6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f73:	48 89 c7             	mov    %rax,%rdi
ffff800000105f76:	48 b8 cd 41 10 00 00 	movabs $0xffff8000001041cd,%rax
ffff800000105f7d:	80 ff ff 
ffff800000105f80:	ff d0                	call   *%rax
  if(*f0)
ffff800000105f82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f86:	48 8b 00             	mov    (%rax),%rax
ffff800000105f89:	48 85 c0             	test   %rax,%rax
ffff800000105f8c:	74 16                	je     ffff800000105fa4 <pipealloc+0x195>
    fileclose(*f0);
ffff800000105f8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f92:	48 8b 00             	mov    (%rax),%rax
ffff800000105f95:	48 89 c7             	mov    %rax,%rdi
ffff800000105f98:	48 b8 86 1d 10 00 00 	movabs $0xffff800000101d86,%rax
ffff800000105f9f:	80 ff ff 
ffff800000105fa2:	ff d0                	call   *%rax
  if(*f1)
ffff800000105fa4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105fa8:	48 8b 00             	mov    (%rax),%rax
ffff800000105fab:	48 85 c0             	test   %rax,%rax
ffff800000105fae:	74 16                	je     ffff800000105fc6 <pipealloc+0x1b7>
    fileclose(*f1);
ffff800000105fb0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105fb4:	48 8b 00             	mov    (%rax),%rax
ffff800000105fb7:	48 89 c7             	mov    %rax,%rdi
ffff800000105fba:	48 b8 86 1d 10 00 00 	movabs $0xffff800000101d86,%rax
ffff800000105fc1:	80 ff ff 
ffff800000105fc4:	ff d0                	call   *%rax
  return -1;
ffff800000105fc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000105fcb:	c9                   	leave
ffff800000105fcc:	c3                   	ret

ffff800000105fcd <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
ffff800000105fcd:	55                   	push   %rbp
ffff800000105fce:	48 89 e5             	mov    %rsp,%rbp
ffff800000105fd1:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000105fd5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000105fd9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  acquire(&p->lock);
ffff800000105fdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105fe0:	48 89 c7             	mov    %rax,%rdi
ffff800000105fe3:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000105fea:	80 ff ff 
ffff800000105fed:	ff d0                	call   *%rax
  if(writable){
ffff800000105fef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000105ff3:	74 29                	je     ffff80000010601e <pipeclose+0x51>
    p->writeopen = 0;
ffff800000105ff5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ff9:	c7 80 74 02 00 00 00 	movl   $0x0,0x274(%rax)
ffff800000106000:	00 00 00 
    wakeup(&p->nread);
ffff800000106003:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106007:	48 05 68 02 00 00    	add    $0x268,%rax
ffff80000010600d:	48 89 c7             	mov    %rax,%rdi
ffff800000106010:	48 b8 4d 72 10 00 00 	movabs $0xffff80000010724d,%rax
ffff800000106017:	80 ff ff 
ffff80000010601a:	ff d0                	call   *%rax
ffff80000010601c:	eb 27                	jmp    ffff800000106045 <pipeclose+0x78>
  } else {
    p->readopen = 0;
ffff80000010601e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106022:	c7 80 70 02 00 00 00 	movl   $0x0,0x270(%rax)
ffff800000106029:	00 00 00 
    wakeup(&p->nwrite);
ffff80000010602c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106030:	48 05 6c 02 00 00    	add    $0x26c,%rax
ffff800000106036:	48 89 c7             	mov    %rax,%rdi
ffff800000106039:	48 b8 4d 72 10 00 00 	movabs $0xffff80000010724d,%rax
ffff800000106040:	80 ff ff 
ffff800000106043:	ff d0                	call   *%rax
  }
  if(p->readopen == 0 && p->writeopen == 0){
ffff800000106045:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106049:	8b 80 70 02 00 00    	mov    0x270(%rax),%eax
ffff80000010604f:	85 c0                	test   %eax,%eax
ffff800000106051:	75 36                	jne    ffff800000106089 <pipeclose+0xbc>
ffff800000106053:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106057:	8b 80 74 02 00 00    	mov    0x274(%rax),%eax
ffff80000010605d:	85 c0                	test   %eax,%eax
ffff80000010605f:	75 28                	jne    ffff800000106089 <pipeclose+0xbc>
    release(&p->lock);
ffff800000106061:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106065:	48 89 c7             	mov    %rax,%rdi
ffff800000106068:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010606f:	80 ff ff 
ffff800000106072:	ff d0                	call   *%rax
    kfree((char*)p);
ffff800000106074:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106078:	48 89 c7             	mov    %rax,%rdi
ffff80000010607b:	48 b8 cd 41 10 00 00 	movabs $0xffff8000001041cd,%rax
ffff800000106082:	80 ff ff 
ffff800000106085:	ff d0                	call   *%rax
ffff800000106087:	eb 14                	jmp    ffff80000010609d <pipeclose+0xd0>
  } else
    release(&p->lock);
ffff800000106089:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010608d:	48 89 c7             	mov    %rax,%rdi
ffff800000106090:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000106097:	80 ff ff 
ffff80000010609a:	ff d0                	call   *%rax
}
ffff80000010609c:	90                   	nop
ffff80000010609d:	90                   	nop
ffff80000010609e:	c9                   	leave
ffff80000010609f:	c3                   	ret

ffff8000001060a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
ffff8000001060a0:	55                   	push   %rbp
ffff8000001060a1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001060a4:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001060a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001060ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001060b0:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  acquire(&p->lock);
ffff8000001060b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060b7:	48 89 c7             	mov    %rax,%rdi
ffff8000001060ba:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff8000001060c1:	80 ff ff 
ffff8000001060c4:	ff d0                	call   *%rax
  for(i = 0; i < n; i++){
ffff8000001060c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001060cd:	e9 d5 00 00 00       	jmp    ffff8000001061a7 <pipewrite+0x107>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
ffff8000001060d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060d6:	8b 80 70 02 00 00    	mov    0x270(%rax),%eax
ffff8000001060dc:	85 c0                	test   %eax,%eax
ffff8000001060de:	74 12                	je     ffff8000001060f2 <pipewrite+0x52>
ffff8000001060e0:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001060e7:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001060eb:	8b 40 40             	mov    0x40(%rax),%eax
ffff8000001060ee:	85 c0                	test   %eax,%eax
ffff8000001060f0:	74 1d                	je     ffff80000010610f <pipewrite+0x6f>
        release(&p->lock);
ffff8000001060f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060f6:	48 89 c7             	mov    %rax,%rdi
ffff8000001060f9:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000106100:	80 ff ff 
ffff800000106103:	ff d0                	call   *%rax
        return -1;
ffff800000106105:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010610a:	e9 cf 00 00 00       	jmp    ffff8000001061de <pipewrite+0x13e>
      }
      wakeup(&p->nread);
ffff80000010610f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106113:	48 05 68 02 00 00    	add    $0x268,%rax
ffff800000106119:	48 89 c7             	mov    %rax,%rdi
ffff80000010611c:	48 b8 4d 72 10 00 00 	movabs $0xffff80000010724d,%rax
ffff800000106123:	80 ff ff 
ffff800000106126:	ff d0                	call   *%rax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
ffff800000106128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010612c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106130:	48 81 c2 6c 02 00 00 	add    $0x26c,%rdx
ffff800000106137:	48 89 c6             	mov    %rax,%rsi
ffff80000010613a:	48 89 d7             	mov    %rdx,%rdi
ffff80000010613d:	48 b8 d8 70 10 00 00 	movabs $0xffff8000001070d8,%rax
ffff800000106144:	80 ff ff 
ffff800000106147:	ff d0                	call   *%rax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
ffff800000106149:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010614d:	8b 90 6c 02 00 00    	mov    0x26c(%rax),%edx
ffff800000106153:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106157:	8b 80 68 02 00 00    	mov    0x268(%rax),%eax
ffff80000010615d:	05 00 02 00 00       	add    $0x200,%eax
ffff800000106162:	39 c2                	cmp    %eax,%edx
ffff800000106164:	0f 84 68 ff ff ff    	je     ffff8000001060d2 <pipewrite+0x32>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
ffff80000010616a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010616d:	48 63 d0             	movslq %eax,%rdx
ffff800000106170:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106174:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
ffff800000106178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010617c:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff800000106182:	8d 48 01             	lea    0x1(%rax),%ecx
ffff800000106185:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106189:	89 8a 6c 02 00 00    	mov    %ecx,0x26c(%rdx)
ffff80000010618f:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff800000106194:	89 c1                	mov    %eax,%ecx
ffff800000106196:	0f b6 16             	movzbl (%rsi),%edx
ffff800000106199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010619d:	89 c9                	mov    %ecx,%ecx
ffff80000010619f:	88 54 08 68          	mov    %dl,0x68(%rax,%rcx,1)
  for(i = 0; i < n; i++){
ffff8000001061a3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001061a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001061aa:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff8000001061ad:	7c 9a                	jl     ffff800000106149 <pipewrite+0xa9>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
ffff8000001061af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001061b3:	48 05 68 02 00 00    	add    $0x268,%rax
ffff8000001061b9:	48 89 c7             	mov    %rax,%rdi
ffff8000001061bc:	48 b8 4d 72 10 00 00 	movabs $0xffff80000010724d,%rax
ffff8000001061c3:	80 ff ff 
ffff8000001061c6:	ff d0                	call   *%rax
  release(&p->lock);
ffff8000001061c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001061cc:	48 89 c7             	mov    %rax,%rdi
ffff8000001061cf:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001061d6:	80 ff ff 
ffff8000001061d9:	ff d0                	call   *%rax
  return n;
ffff8000001061db:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
ffff8000001061de:	c9                   	leave
ffff8000001061df:	c3                   	ret

ffff8000001061e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
ffff8000001061e0:	55                   	push   %rbp
ffff8000001061e1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001061e4:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001061e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001061ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001061f0:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  acquire(&p->lock);
ffff8000001061f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001061f7:	48 89 c7             	mov    %rax,%rdi
ffff8000001061fa:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000106201:	80 ff ff 
ffff800000106204:	ff d0                	call   *%rax
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
ffff800000106206:	eb 50                	jmp    ffff800000106258 <piperead+0x78>
    if(proc->killed){
ffff800000106208:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010620f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106213:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000106216:	85 c0                	test   %eax,%eax
ffff800000106218:	74 1d                	je     ffff800000106237 <piperead+0x57>
      release(&p->lock);
ffff80000010621a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010621e:	48 89 c7             	mov    %rax,%rdi
ffff800000106221:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000106228:	80 ff ff 
ffff80000010622b:	ff d0                	call   *%rax
      return -1;
ffff80000010622d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106232:	e9 de 00 00 00       	jmp    ffff800000106315 <piperead+0x135>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
ffff800000106237:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010623b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010623f:	48 81 c2 68 02 00 00 	add    $0x268,%rdx
ffff800000106246:	48 89 c6             	mov    %rax,%rsi
ffff800000106249:	48 89 d7             	mov    %rdx,%rdi
ffff80000010624c:	48 b8 d8 70 10 00 00 	movabs $0xffff8000001070d8,%rax
ffff800000106253:	80 ff ff 
ffff800000106256:	ff d0                	call   *%rax
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
ffff800000106258:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010625c:	8b 90 68 02 00 00    	mov    0x268(%rax),%edx
ffff800000106262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106266:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff80000010626c:	39 c2                	cmp    %eax,%edx
ffff80000010626e:	75 0e                	jne    ffff80000010627e <piperead+0x9e>
ffff800000106270:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106274:	8b 80 74 02 00 00    	mov    0x274(%rax),%eax
ffff80000010627a:	85 c0                	test   %eax,%eax
ffff80000010627c:	75 8a                	jne    ffff800000106208 <piperead+0x28>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
ffff80000010627e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000106285:	eb 54                	jmp    ffff8000001062db <piperead+0xfb>
    if(p->nread == p->nwrite)
ffff800000106287:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010628b:	8b 90 68 02 00 00    	mov    0x268(%rax),%edx
ffff800000106291:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106295:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff80000010629b:	39 c2                	cmp    %eax,%edx
ffff80000010629d:	74 46                	je     ffff8000001062e5 <piperead+0x105>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
ffff80000010629f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001062a3:	8b 80 68 02 00 00    	mov    0x268(%rax),%eax
ffff8000001062a9:	8d 48 01             	lea    0x1(%rax),%ecx
ffff8000001062ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001062b0:	89 8a 68 02 00 00    	mov    %ecx,0x268(%rdx)
ffff8000001062b6:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff8000001062bb:	89 c1                	mov    %eax,%ecx
ffff8000001062bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001062c0:	48 63 d0             	movslq %eax,%rdx
ffff8000001062c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001062c7:	48 01 c2             	add    %rax,%rdx
ffff8000001062ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001062ce:	89 c9                	mov    %ecx,%ecx
ffff8000001062d0:	0f b6 44 08 68       	movzbl 0x68(%rax,%rcx,1),%eax
ffff8000001062d5:	88 02                	mov    %al,(%rdx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
ffff8000001062d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001062db:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001062de:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff8000001062e1:	7c a4                	jl     ffff800000106287 <piperead+0xa7>
ffff8000001062e3:	eb 01                	jmp    ffff8000001062e6 <piperead+0x106>
      break;
ffff8000001062e5:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
ffff8000001062e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001062ea:	48 05 6c 02 00 00    	add    $0x26c,%rax
ffff8000001062f0:	48 89 c7             	mov    %rax,%rdi
ffff8000001062f3:	48 b8 4d 72 10 00 00 	movabs $0xffff80000010724d,%rax
ffff8000001062fa:	80 ff ff 
ffff8000001062fd:	ff d0                	call   *%rax
  release(&p->lock);
ffff8000001062ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106303:	48 89 c7             	mov    %rax,%rdi
ffff800000106306:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010630d:	80 ff ff 
ffff800000106310:	ff d0                	call   *%rax
  return i;
ffff800000106312:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000106315:	c9                   	leave
ffff800000106316:	c3                   	ret

ffff800000106317 <readeflags>:
{
ffff800000106317:	55                   	push   %rbp
ffff800000106318:	48 89 e5             	mov    %rsp,%rbp
ffff80000010631b:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff80000010631f:	9c                   	pushf
ffff800000106320:	58                   	pop    %rax
ffff800000106321:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff800000106325:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000106329:	c9                   	leave
ffff80000010632a:	c3                   	ret

ffff80000010632b <sti>:
{
ffff80000010632b:	55                   	push   %rbp
ffff80000010632c:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("sti");
ffff80000010632f:	fb                   	sti
}
ffff800000106330:	90                   	nop
ffff800000106331:	5d                   	pop    %rbp
ffff800000106332:	c3                   	ret

ffff800000106333 <hlt>:
{
ffff800000106333:	55                   	push   %rbp
ffff800000106334:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("hlt");
ffff800000106337:	f4                   	hlt
}
ffff800000106338:	90                   	nop
ffff800000106339:	5d                   	pop    %rbp
ffff80000010633a:	c3                   	ret

ffff80000010633b <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
ffff80000010633b:	55                   	push   %rbp
ffff80000010633c:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ptable.lock, "ptable");
ffff80000010633f:	48 ba fb c9 10 00 00 	movabs $0xffff80000010c9fb,%rdx
ffff800000106346:	80 ff ff 
ffff800000106349:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000106350:	80 ff ff 
ffff800000106353:	48 89 d6             	mov    %rdx,%rsi
ffff800000106356:	48 89 c7             	mov    %rax,%rdi
ffff800000106359:	48 b8 a5 76 10 00 00 	movabs $0xffff8000001076a5,%rax
ffff800000106360:	80 ff ff 
ffff800000106363:	ff d0                	call   *%rax
}
ffff800000106365:	90                   	nop
ffff800000106366:	5d                   	pop    %rbp
ffff800000106367:	c3                   	ret

ffff800000106368 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
ffff800000106368:	55                   	push   %rbp
ffff800000106369:	48 89 e5             	mov    %rsp,%rbp
ffff80000010636c:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
ffff800000106370:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000106377:	80 ff ff 
ffff80000010637a:	48 89 c7             	mov    %rax,%rdi
ffff80000010637d:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000106384:	80 ff ff 
ffff800000106387:	ff d0                	call   *%rax

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff800000106389:	48 b8 a8 84 11 00 00 	movabs $0xffff8000001184a8,%rax
ffff800000106390:	80 ff ff 
ffff800000106393:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106397:	eb 13                	jmp    ffff8000001063ac <allocproc+0x44>
    if(p->state == UNUSED)
ffff800000106399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010639d:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001063a0:	85 c0                	test   %eax,%eax
ffff8000001063a2:	74 3b                	je     ffff8000001063df <allocproc+0x77>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff8000001063a4:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff8000001063ab:	00 
ffff8000001063ac:	48 b8 a8 bc 11 00 00 	movabs $0xffff80000011bca8,%rax
ffff8000001063b3:	80 ff ff 
ffff8000001063b6:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001063ba:	72 dd                	jb     ffff800000106399 <allocproc+0x31>
      goto found;

  release(&ptable.lock);
ffff8000001063bc:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff8000001063c3:	80 ff ff 
ffff8000001063c6:	48 89 c7             	mov    %rax,%rdi
ffff8000001063c9:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001063d0:	80 ff ff 
ffff8000001063d3:	ff d0                	call   *%rax
  return 0;
ffff8000001063d5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001063da:	e9 05 01 00 00       	jmp    ffff8000001064e4 <allocproc+0x17c>
      goto found;
ffff8000001063df:	90                   	nop

found:
  p->state = EMBRYO;
ffff8000001063e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001063e4:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%rax)
  p->pid = nextpid++;
ffff8000001063eb:	48 b8 40 d5 10 00 00 	movabs $0xffff80000010d540,%rax
ffff8000001063f2:	80 ff ff 
ffff8000001063f5:	8b 00                	mov    (%rax),%eax
ffff8000001063f7:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001063fa:	48 b9 40 d5 10 00 00 	movabs $0xffff80000010d540,%rcx
ffff800000106401:	80 ff ff 
ffff800000106404:	89 11                	mov    %edx,(%rcx)
ffff800000106406:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010640a:	89 42 1c             	mov    %eax,0x1c(%rdx)

  release(&ptable.lock);
ffff80000010640d:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000106414:	80 ff ff 
ffff800000106417:	48 89 c7             	mov    %rax,%rdi
ffff80000010641a:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000106421:	80 ff ff 
ffff800000106424:	ff d0                	call   *%rax

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
ffff800000106426:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff80000010642d:	80 ff ff 
ffff800000106430:	ff d0                	call   *%rax
ffff800000106432:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106436:	48 89 42 10          	mov    %rax,0x10(%rdx)
ffff80000010643a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010643e:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106442:	48 85 c0             	test   %rax,%rax
ffff800000106445:	75 15                	jne    ffff80000010645c <allocproc+0xf4>
    p->state = UNUSED;
ffff800000106447:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010644b:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return 0;
ffff800000106452:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106457:	e9 88 00 00 00       	jmp    ffff8000001064e4 <allocproc+0x17c>
  }
  sp = p->kstack + KSTACKSIZE;
ffff80000010645c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106460:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106464:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010646a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
ffff80000010646e:	48 81 6d f0 b0 00 00 	subq   $0xb0,-0x10(%rbp)
ffff800000106475:	00 
  p->tf = (struct trapframe*)sp;
ffff800000106476:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010647a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010647e:	48 89 50 28          	mov    %rdx,0x28(%rax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= sizeof(addr_t);
ffff800000106482:	48 83 6d f0 08       	subq   $0x8,-0x10(%rbp)
  *(addr_t*)sp = (addr_t)syscall_trapret;
ffff800000106487:	48 ba c9 99 10 00 00 	movabs $0xffff8000001099c9,%rdx
ffff80000010648e:	80 ff ff 
ffff800000106491:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106495:	48 89 10             	mov    %rdx,(%rax)

  sp -= sizeof *p->context;
ffff800000106498:	48 83 6d f0 38       	subq   $0x38,-0x10(%rbp)
  p->context = (struct context*)sp;
ffff80000010649d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001064a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001064a5:	48 89 50 30          	mov    %rdx,0x30(%rax)
  memset(p->context, 0, sizeof *p->context);
ffff8000001064a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001064ad:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff8000001064b1:	ba 38 00 00 00       	mov    $0x38,%edx
ffff8000001064b6:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001064bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001064be:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff8000001064c5:	80 ff ff 
ffff8000001064c8:	ff d0                	call   *%rax
  p->context->rip = (addr_t)forkret;
ffff8000001064ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001064ce:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff8000001064d2:	48 ba 76 70 10 00 00 	movabs $0xffff800000107076,%rdx
ffff8000001064d9:	80 ff ff 
ffff8000001064dc:	48 89 50 30          	mov    %rdx,0x30(%rax)

  return p;
ffff8000001064e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001064e4:	c9                   	leave
ffff8000001064e5:	c3                   	ret

ffff8000001064e6 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
ffff8000001064e6:	55                   	push   %rbp
ffff8000001064e7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001064ea:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  p = allocproc();
ffff8000001064ee:	48 b8 68 63 10 00 00 	movabs $0xffff800000106368,%rax
ffff8000001064f5:	80 ff ff 
ffff8000001064f8:	ff d0                	call   *%rax
ffff8000001064fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  initproc = p;
ffff8000001064fe:	48 ba a8 bc 11 00 00 	movabs $0xffff80000011bca8,%rdx
ffff800000106505:	80 ff ff 
ffff800000106508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010650c:	48 89 02             	mov    %rax,(%rdx)
  if((p->pgdir = setupkvm()) == 0)
ffff80000010650f:	48 b8 3e b3 10 00 00 	movabs $0xffff80000010b33e,%rax
ffff800000106516:	80 ff ff 
ffff800000106519:	ff d0                	call   *%rax
ffff80000010651b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010651f:	48 89 42 08          	mov    %rax,0x8(%rdx)
ffff800000106523:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106527:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010652b:	48 85 c0             	test   %rax,%rax
ffff80000010652e:	75 19                	jne    ffff800000106549 <userinit+0x63>
    panic("userinit: out of memory?");
ffff800000106530:	48 b8 02 ca 10 00 00 	movabs $0xffff80000010ca02,%rax
ffff800000106537:	80 ff ff 
ffff80000010653a:	48 89 c7             	mov    %rax,%rdi
ffff80000010653d:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106544:	80 ff ff 
ffff800000106547:	ff d0                	call   *%rax

  inituvm(p->pgdir, _binary_initcode_start,
ffff800000106549:	48 b8 40 00 00 00 00 	movabs $0x40,%rax
ffff800000106550:	00 00 00 
ffff800000106553:	89 c2                	mov    %eax,%edx
ffff800000106555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106559:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010655d:	48 b9 50 df 10 00 00 	movabs $0xffff80000010df50,%rcx
ffff800000106564:	80 ff ff 
ffff800000106567:	48 89 ce             	mov    %rcx,%rsi
ffff80000010656a:	48 89 c7             	mov    %rax,%rdi
ffff80000010656d:	48 b8 b4 b8 10 00 00 	movabs $0xffff80000010b8b4,%rax
ffff800000106574:	80 ff ff 
ffff800000106577:	ff d0                	call   *%rax
          (addr_t)_binary_initcode_size);
  p->sz = PGSIZE * 2;
ffff800000106579:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010657d:	48 c7 00 00 20 00 00 	movq   $0x2000,(%rax)
  memset(p->tf, 0, sizeof(*p->tf));
ffff800000106584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106588:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010658c:	ba b0 00 00 00       	mov    $0xb0,%edx
ffff800000106591:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000106596:	48 89 c7             	mov    %rax,%rdi
ffff800000106599:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff8000001065a0:	80 ff ff 
ffff8000001065a3:	ff d0                	call   *%rax

  p->tf->r11 = FL_IF;  // with SYSRET, EFLAGS is in R11
ffff8000001065a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001065a9:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001065ad:	48 c7 40 50 00 02 00 	movq   $0x200,0x50(%rax)
ffff8000001065b4:	00 
  p->tf->rsp = p->sz;
ffff8000001065b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001065b9:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001065bd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001065c1:	48 8b 12             	mov    (%rdx),%rdx
ffff8000001065c4:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
  p->tf->rcx = PGSIZE;  // with SYSRET, RIP is in RCX
ffff8000001065cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001065cf:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001065d3:	48 c7 40 10 00 10 00 	movq   $0x1000,0x10(%rax)
ffff8000001065da:	00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
ffff8000001065db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001065df:	48 05 d0 00 00 00    	add    $0xd0,%rax
ffff8000001065e5:	48 b9 1b ca 10 00 00 	movabs $0xffff80000010ca1b,%rcx
ffff8000001065ec:	80 ff ff 
ffff8000001065ef:	ba 10 00 00 00       	mov    $0x10,%edx
ffff8000001065f4:	48 89 ce             	mov    %rcx,%rsi
ffff8000001065f7:	48 89 c7             	mov    %rax,%rdi
ffff8000001065fa:	48 b8 26 7d 10 00 00 	movabs $0xffff800000107d26,%rax
ffff800000106601:	80 ff ff 
ffff800000106604:	ff d0                	call   *%rax
  p->cwd = namei("/");
ffff800000106606:	48 b8 24 ca 10 00 00 	movabs $0xffff80000010ca24,%rax
ffff80000010660d:	80 ff ff 
ffff800000106610:	48 89 c7             	mov    %rax,%rdi
ffff800000106613:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff80000010661a:	80 ff ff 
ffff80000010661d:	ff d0                	call   *%rax
ffff80000010661f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106623:	48 89 82 c8 00 00 00 	mov    %rax,0xc8(%rdx)

  __sync_synchronize();
ffff80000010662a:	f0 48 83 0c 24 00    	lock orq $0x0,(%rsp)
  p->state = RUNNABLE;
ffff800000106630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106634:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
}
ffff80000010663b:	90                   	nop
ffff80000010663c:	c9                   	leave
ffff80000010663d:	c3                   	ret

ffff80000010663e <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int64 n)
{
ffff80000010663e:	55                   	push   %rbp
ffff80000010663f:	48 89 e5             	mov    %rsp,%rbp
ffff800000106642:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000106646:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  addr_t sz;

  sz = proc->sz;
ffff80000010664a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106651:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106655:	48 8b 00             	mov    (%rax),%rax
ffff800000106658:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(n > 0){
ffff80000010665c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000106661:	7e 42                	jle    ffff8000001066a5 <growproc+0x67>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
ffff800000106663:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010666b:	48 01 c2             	add    %rax,%rdx
ffff80000010666e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106675:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106679:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010667d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000106681:	48 89 ce             	mov    %rcx,%rsi
ffff800000106684:	48 89 c7             	mov    %rax,%rdi
ffff800000106687:	48 b8 95 ba 10 00 00 	movabs $0xffff80000010ba95,%rax
ffff80000010668e:	80 ff ff 
ffff800000106691:	ff d0                	call   *%rax
ffff800000106693:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106697:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010669c:	75 50                	jne    ffff8000001066ee <growproc+0xb0>
      return -1;
ffff80000010669e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001066a3:	eb 7a                	jmp    ffff80000010671f <growproc+0xe1>
  } else if(n < 0){
ffff8000001066a5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001066aa:	79 42                	jns    ffff8000001066ee <growproc+0xb0>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
ffff8000001066ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001066b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001066b4:	48 01 c2             	add    %rax,%rdx
ffff8000001066b7:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001066be:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001066c2:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001066c6:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff8000001066ca:	48 89 ce             	mov    %rcx,%rsi
ffff8000001066cd:	48 89 c7             	mov    %rax,%rdi
ffff8000001066d0:	48 b8 d9 bb 10 00 00 	movabs $0xffff80000010bbd9,%rax
ffff8000001066d7:	80 ff ff 
ffff8000001066da:	ff d0                	call   *%rax
ffff8000001066dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001066e0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001066e5:	75 07                	jne    ffff8000001066ee <growproc+0xb0>
      return -1;
ffff8000001066e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001066ec:	eb 31                	jmp    ffff80000010671f <growproc+0xe1>
  }
  proc->sz = sz;
ffff8000001066ee:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001066f5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001066f9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001066fd:	48 89 10             	mov    %rdx,(%rax)
  switchuvm(proc);
ffff800000106700:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106707:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010670b:	48 89 c7             	mov    %rax,%rdi
ffff80000010670e:	48 b8 9c b4 10 00 00 	movabs $0xffff80000010b49c,%rax
ffff800000106715:	80 ff ff 
ffff800000106718:	ff d0                	call   *%rax
  return 0;
ffff80000010671a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010671f:	c9                   	leave
ffff800000106720:	c3                   	ret

ffff800000106721 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
ffff800000106721:	55                   	push   %rbp
ffff800000106722:	48 89 e5             	mov    %rsp,%rbp
ffff800000106725:	53                   	push   %rbx
ffff800000106726:	48 83 ec 28          	sub    $0x28,%rsp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
ffff80000010672a:	48 b8 68 63 10 00 00 	movabs $0xffff800000106368,%rax
ffff800000106731:	80 ff ff 
ffff800000106734:	ff d0                	call   *%rax
ffff800000106736:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff80000010673a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff80000010673f:	75 0a                	jne    ffff80000010674b <fork+0x2a>
    return -1;
ffff800000106741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106746:	e9 c4 02 00 00       	jmp    ffff800000106a0f <fork+0x2ee>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
ffff80000010674b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106752:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106756:	48 8b 00             	mov    (%rax),%rax
ffff800000106759:	89 c2                	mov    %eax,%edx
ffff80000010675b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106762:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106766:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010676a:	89 d6                	mov    %edx,%esi
ffff80000010676c:	48 89 c7             	mov    %rax,%rdi
ffff80000010676f:	48 b8 74 bf 10 00 00 	movabs $0xffff80000010bf74,%rax
ffff800000106776:	80 ff ff 
ffff800000106779:	ff d0                	call   *%rax
ffff80000010677b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010677f:	48 89 42 08          	mov    %rax,0x8(%rdx)
ffff800000106783:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106787:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010678b:	48 85 c0             	test   %rax,%rax
ffff80000010678e:	75 38                	jne    ffff8000001067c8 <fork+0xa7>
    kfree(np->kstack);
ffff800000106790:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106794:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106798:	48 89 c7             	mov    %rax,%rdi
ffff80000010679b:	48 b8 cd 41 10 00 00 	movabs $0xffff8000001041cd,%rax
ffff8000001067a2:	80 ff ff 
ffff8000001067a5:	ff d0                	call   *%rax
    np->kstack = 0;
ffff8000001067a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001067ab:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff8000001067b2:	00 
    np->state = UNUSED;
ffff8000001067b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001067b7:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return -1;
ffff8000001067be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001067c3:	e9 47 02 00 00       	jmp    ffff800000106a0f <fork+0x2ee>
  }
  np->sz = proc->sz;
ffff8000001067c8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001067cf:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001067d3:	48 8b 10             	mov    (%rax),%rdx
ffff8000001067d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001067da:	48 89 10             	mov    %rdx,(%rax)
  np->parent = proc;
ffff8000001067dd:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001067e4:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffff8000001067e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001067ec:	48 89 50 20          	mov    %rdx,0x20(%rax)
  *np->tf = *proc->tf;
ffff8000001067f0:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001067f7:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001067fb:	48 8b 50 28          	mov    0x28(%rax),%rdx
ffff8000001067ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106803:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000106807:	48 8b 0a             	mov    (%rdx),%rcx
ffff80000010680a:	48 8b 5a 08          	mov    0x8(%rdx),%rbx
ffff80000010680e:	48 89 08             	mov    %rcx,(%rax)
ffff800000106811:	48 89 58 08          	mov    %rbx,0x8(%rax)
ffff800000106815:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
ffff800000106819:	48 8b 5a 18          	mov    0x18(%rdx),%rbx
ffff80000010681d:	48 89 48 10          	mov    %rcx,0x10(%rax)
ffff800000106821:	48 89 58 18          	mov    %rbx,0x18(%rax)
ffff800000106825:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
ffff800000106829:	48 8b 5a 28          	mov    0x28(%rdx),%rbx
ffff80000010682d:	48 89 48 20          	mov    %rcx,0x20(%rax)
ffff800000106831:	48 89 58 28          	mov    %rbx,0x28(%rax)
ffff800000106835:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
ffff800000106839:	48 8b 5a 38          	mov    0x38(%rdx),%rbx
ffff80000010683d:	48 89 48 30          	mov    %rcx,0x30(%rax)
ffff800000106841:	48 89 58 38          	mov    %rbx,0x38(%rax)
ffff800000106845:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
ffff800000106849:	48 8b 5a 48          	mov    0x48(%rdx),%rbx
ffff80000010684d:	48 89 48 40          	mov    %rcx,0x40(%rax)
ffff800000106851:	48 89 58 48          	mov    %rbx,0x48(%rax)
ffff800000106855:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
ffff800000106859:	48 8b 5a 58          	mov    0x58(%rdx),%rbx
ffff80000010685d:	48 89 48 50          	mov    %rcx,0x50(%rax)
ffff800000106861:	48 89 58 58          	mov    %rbx,0x58(%rax)
ffff800000106865:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
ffff800000106869:	48 8b 5a 68          	mov    0x68(%rdx),%rbx
ffff80000010686d:	48 89 48 60          	mov    %rcx,0x60(%rax)
ffff800000106871:	48 89 58 68          	mov    %rbx,0x68(%rax)
ffff800000106875:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
ffff800000106879:	48 8b 5a 78          	mov    0x78(%rdx),%rbx
ffff80000010687d:	48 89 48 70          	mov    %rcx,0x70(%rax)
ffff800000106881:	48 89 58 78          	mov    %rbx,0x78(%rax)
ffff800000106885:	48 8b 8a 80 00 00 00 	mov    0x80(%rdx),%rcx
ffff80000010688c:	48 8b 9a 88 00 00 00 	mov    0x88(%rdx),%rbx
ffff800000106893:	48 89 88 80 00 00 00 	mov    %rcx,0x80(%rax)
ffff80000010689a:	48 89 98 88 00 00 00 	mov    %rbx,0x88(%rax)
ffff8000001068a1:	48 8b 8a 90 00 00 00 	mov    0x90(%rdx),%rcx
ffff8000001068a8:	48 8b 9a 98 00 00 00 	mov    0x98(%rdx),%rbx
ffff8000001068af:	48 89 88 90 00 00 00 	mov    %rcx,0x90(%rax)
ffff8000001068b6:	48 89 98 98 00 00 00 	mov    %rbx,0x98(%rax)
ffff8000001068bd:	48 8b 8a a0 00 00 00 	mov    0xa0(%rdx),%rcx
ffff8000001068c4:	48 8b 9a a8 00 00 00 	mov    0xa8(%rdx),%rbx
ffff8000001068cb:	48 89 88 a0 00 00 00 	mov    %rcx,0xa0(%rax)
ffff8000001068d2:	48 89 98 a8 00 00 00 	mov    %rbx,0xa8(%rax)

  // Clear %rax so that fork returns 0 in the child.
  np->tf->rax = 0;
ffff8000001068d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001068dd:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001068e1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  for(i = 0; i < NOFILE; i++)
ffff8000001068e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffff8000001068ef:	eb 5f                	jmp    ffff800000106950 <fork+0x22f>
    if(proc->ofile[i])
ffff8000001068f1:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001068f8:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001068fc:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff8000001068ff:	48 63 d2             	movslq %edx,%rdx
ffff800000106902:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106906:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010690b:	48 85 c0             	test   %rax,%rax
ffff80000010690e:	74 3c                	je     ffff80000010694c <fork+0x22b>
      np->ofile[i] = filedup(proc->ofile[i]);
ffff800000106910:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106917:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010691b:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff80000010691e:	48 63 d2             	movslq %edx,%rdx
ffff800000106921:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106925:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010692a:	48 89 c7             	mov    %rax,%rdi
ffff80000010692d:	48 b8 0d 1d 10 00 00 	movabs $0xffff800000101d0d,%rax
ffff800000106934:	80 ff ff 
ffff800000106937:	ff d0                	call   *%rax
ffff800000106939:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010693d:	8b 4d ec             	mov    -0x14(%rbp),%ecx
ffff800000106940:	48 63 c9             	movslq %ecx,%rcx
ffff800000106943:	48 83 c1 08          	add    $0x8,%rcx
ffff800000106947:	48 89 44 ca 08       	mov    %rax,0x8(%rdx,%rcx,8)
  for(i = 0; i < NOFILE; i++)
ffff80000010694c:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffff800000106950:	83 7d ec 0f          	cmpl   $0xf,-0x14(%rbp)
ffff800000106954:	7e 9b                	jle    ffff8000001068f1 <fork+0x1d0>
  np->cwd = idup(proc->cwd);
ffff800000106956:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010695d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106961:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff800000106968:	48 89 c7             	mov    %rax,%rdi
ffff80000010696b:	48 b8 5f 29 10 00 00 	movabs $0xffff80000010295f,%rax
ffff800000106972:	80 ff ff 
ffff800000106975:	ff d0                	call   *%rax
ffff800000106977:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010697b:	48 89 82 c8 00 00 00 	mov    %rax,0xc8(%rdx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
ffff800000106982:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106989:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010698d:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff800000106994:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106998:	48 05 d0 00 00 00    	add    $0xd0,%rax
ffff80000010699e:	ba 10 00 00 00       	mov    $0x10,%edx
ffff8000001069a3:	48 89 ce             	mov    %rcx,%rsi
ffff8000001069a6:	48 89 c7             	mov    %rax,%rdi
ffff8000001069a9:	48 b8 26 7d 10 00 00 	movabs $0xffff800000107d26,%rax
ffff8000001069b0:	80 ff ff 
ffff8000001069b3:	ff d0                	call   *%rax

  pid = np->pid;
ffff8000001069b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001069b9:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff8000001069bc:	89 45 dc             	mov    %eax,-0x24(%rbp)

  __sync_synchronize();
ffff8000001069bf:	f0 48 83 0c 24 00    	lock orq $0x0,(%rsp)
  np->state = RUNNABLE;
ffff8000001069c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001069c9:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)

  // Trace the event
  traceevent(TRACE_TYPE_PROC, pid, proc->pid, 0, 0, "fork");
ffff8000001069d0:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001069d7:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001069db:	8b 50 1c             	mov    0x1c(%rax),%edx
ffff8000001069de:	48 b9 26 ca 10 00 00 	movabs $0xffff80000010ca26,%rcx
ffff8000001069e5:	80 ff ff 
ffff8000001069e8:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001069eb:	49 89 c9             	mov    %rcx,%r9
ffff8000001069ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
ffff8000001069f4:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff8000001069f9:	89 c6                	mov    %eax,%esi
ffff8000001069fb:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000106a00:	48 b8 d3 c2 10 00 00 	movabs $0xffff80000010c2d3,%rax
ffff800000106a07:	80 ff ff 
ffff800000106a0a:	ff d0                	call   *%rax

  return pid;
ffff800000106a0c:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
ffff800000106a0f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
ffff800000106a13:	c9                   	leave
ffff800000106a14:	c3                   	ret

ffff800000106a15 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
ffff800000106a15:	55                   	push   %rbp
ffff800000106a16:	48 89 e5             	mov    %rsp,%rbp
ffff800000106a19:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int fd;

  if(proc == initproc)
ffff800000106a1d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106a24:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffff800000106a28:	48 b8 a8 bc 11 00 00 	movabs $0xffff80000011bca8,%rax
ffff800000106a2f:	80 ff ff 
ffff800000106a32:	48 8b 00             	mov    (%rax),%rax
ffff800000106a35:	48 39 c2             	cmp    %rax,%rdx
ffff800000106a38:	75 19                	jne    ffff800000106a53 <exit+0x3e>
    panic("init exiting");
ffff800000106a3a:	48 b8 2b ca 10 00 00 	movabs $0xffff80000010ca2b,%rax
ffff800000106a41:	80 ff ff 
ffff800000106a44:	48 89 c7             	mov    %rax,%rdi
ffff800000106a47:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106a4e:	80 ff ff 
ffff800000106a51:	ff d0                	call   *%rax

  traceevent(TRACE_TYPE_PROC, proc->pid, 0, 0, 0, "exit");
ffff800000106a53:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106a5a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106a5e:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000106a61:	48 ba 38 ca 10 00 00 	movabs $0xffff80000010ca38,%rdx
ffff800000106a68:	80 ff ff 
ffff800000106a6b:	49 89 d1             	mov    %rdx,%r9
ffff800000106a6e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
ffff800000106a74:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff800000106a79:	ba 00 00 00 00       	mov    $0x0,%edx
ffff800000106a7e:	89 c6                	mov    %eax,%esi
ffff800000106a80:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000106a85:	48 b8 d3 c2 10 00 00 	movabs $0xffff80000010c2d3,%rax
ffff800000106a8c:	80 ff ff 
ffff800000106a8f:	ff d0                	call   *%rax

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
ffff800000106a91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff800000106a98:	eb 6a                	jmp    ffff800000106b04 <exit+0xef>
    if(proc->ofile[fd]){
ffff800000106a9a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106aa1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106aa5:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000106aa8:	48 63 d2             	movslq %edx,%rdx
ffff800000106aab:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106aaf:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000106ab4:	48 85 c0             	test   %rax,%rax
ffff800000106ab7:	74 47                	je     ffff800000106b00 <exit+0xeb>
      fileclose(proc->ofile[fd]);
ffff800000106ab9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106ac0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106ac4:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000106ac7:	48 63 d2             	movslq %edx,%rdx
ffff800000106aca:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106ace:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000106ad3:	48 89 c7             	mov    %rax,%rdi
ffff800000106ad6:	48 b8 86 1d 10 00 00 	movabs $0xffff800000101d86,%rax
ffff800000106add:	80 ff ff 
ffff800000106ae0:	ff d0                	call   *%rax
      proc->ofile[fd] = 0;
ffff800000106ae2:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106ae9:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106aed:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000106af0:	48 63 d2             	movslq %edx,%rdx
ffff800000106af3:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106af7:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff800000106afe:	00 00 
  for(fd = 0; fd < NOFILE; fd++){
ffff800000106b00:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffff800000106b04:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
ffff800000106b08:	7e 90                	jle    ffff800000106a9a <exit+0x85>
    }
  }

  begin_op();
ffff800000106b0a:	48 b8 be 50 10 00 00 	movabs $0xffff8000001050be,%rax
ffff800000106b11:	80 ff ff 
ffff800000106b14:	ff d0                	call   *%rax
  iput(proc->cwd);
ffff800000106b16:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106b1d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106b21:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff800000106b28:	48 89 c7             	mov    %rax,%rdi
ffff800000106b2b:	48 b8 b7 2b 10 00 00 	movabs $0xffff800000102bb7,%rax
ffff800000106b32:	80 ff ff 
ffff800000106b35:	ff d0                	call   *%rax
  end_op();
ffff800000106b37:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000106b3e:	80 ff ff 
ffff800000106b41:	ff d0                	call   *%rax
  proc->cwd = 0;
ffff800000106b43:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106b4a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106b4e:	48 c7 80 c8 00 00 00 	movq   $0x0,0xc8(%rax)
ffff800000106b55:	00 00 00 00 

  acquire(&ptable.lock);
ffff800000106b59:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000106b60:	80 ff ff 
ffff800000106b63:	48 89 c7             	mov    %rax,%rdi
ffff800000106b66:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000106b6d:	80 ff ff 
ffff800000106b70:	ff d0                	call   *%rax

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
ffff800000106b72:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106b79:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106b7d:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff800000106b81:	48 89 c7             	mov    %rax,%rdi
ffff800000106b84:	48 b8 f0 71 10 00 00 	movabs $0xffff8000001071f0,%rax
ffff800000106b8b:	80 ff ff 
ffff800000106b8e:	ff d0                	call   *%rax

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106b90:	48 b8 a8 84 11 00 00 	movabs $0xffff8000001184a8,%rax
ffff800000106b97:	80 ff ff 
ffff800000106b9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106b9e:	eb 5d                	jmp    ffff800000106bfd <exit+0x1e8>
    if(p->parent == proc){
ffff800000106ba0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106ba4:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffff800000106ba8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106baf:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106bb3:	48 39 c2             	cmp    %rax,%rdx
ffff800000106bb6:	75 3d                	jne    ffff800000106bf5 <exit+0x1e0>
      p->parent = initproc;
ffff800000106bb8:	48 b8 a8 bc 11 00 00 	movabs $0xffff80000011bca8,%rax
ffff800000106bbf:	80 ff ff 
ffff800000106bc2:	48 8b 10             	mov    (%rax),%rdx
ffff800000106bc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106bc9:	48 89 50 20          	mov    %rdx,0x20(%rax)
      if(p->state == ZOMBIE)
ffff800000106bcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106bd1:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106bd4:	83 f8 05             	cmp    $0x5,%eax
ffff800000106bd7:	75 1c                	jne    ffff800000106bf5 <exit+0x1e0>
        wakeup1(initproc);
ffff800000106bd9:	48 b8 a8 bc 11 00 00 	movabs $0xffff80000011bca8,%rax
ffff800000106be0:	80 ff ff 
ffff800000106be3:	48 8b 00             	mov    (%rax),%rax
ffff800000106be6:	48 89 c7             	mov    %rax,%rdi
ffff800000106be9:	48 b8 f0 71 10 00 00 	movabs $0xffff8000001071f0,%rax
ffff800000106bf0:	80 ff ff 
ffff800000106bf3:	ff d0                	call   *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106bf5:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff800000106bfc:	00 
ffff800000106bfd:	48 b8 a8 bc 11 00 00 	movabs $0xffff80000011bca8,%rax
ffff800000106c04:	80 ff ff 
ffff800000106c07:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106c0b:	72 93                	jb     ffff800000106ba0 <exit+0x18b>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
ffff800000106c0d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106c14:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106c18:	c7 40 18 05 00 00 00 	movl   $0x5,0x18(%rax)
  sched();
ffff800000106c1f:	48 b8 05 6f 10 00 00 	movabs $0xffff800000106f05,%rax
ffff800000106c26:	80 ff ff 
ffff800000106c29:	ff d0                	call   *%rax
  panic("zombie exit");
ffff800000106c2b:	48 b8 3d ca 10 00 00 	movabs $0xffff80000010ca3d,%rax
ffff800000106c32:	80 ff ff 
ffff800000106c35:	48 89 c7             	mov    %rax,%rdi
ffff800000106c38:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106c3f:	80 ff ff 
ffff800000106c42:	ff d0                	call   *%rax

ffff800000106c44 <wait>:
//PAGEBREAK!
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
ffff800000106c44:	55                   	push   %rbp
ffff800000106c45:	48 89 e5             	mov    %rsp,%rbp
ffff800000106c48:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
ffff800000106c4c:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000106c53:	80 ff ff 
ffff800000106c56:	48 89 c7             	mov    %rax,%rdi
ffff800000106c59:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000106c60:	80 ff ff 
ffff800000106c63:	ff d0                	call   *%rax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
ffff800000106c65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106c6c:	48 b8 a8 84 11 00 00 	movabs $0xffff8000001184a8,%rax
ffff800000106c73:	80 ff ff 
ffff800000106c76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106c7a:	e9 d9 00 00 00       	jmp    ffff800000106d58 <wait+0x114>
      if(p->parent != proc)
ffff800000106c7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106c83:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffff800000106c87:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106c8e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106c92:	48 39 c2             	cmp    %rax,%rdx
ffff800000106c95:	0f 85 b4 00 00 00    	jne    ffff800000106d4f <wait+0x10b>
        continue;
      havekids = 1;
ffff800000106c9b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
      if(p->state == ZOMBIE){
ffff800000106ca2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106ca6:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106ca9:	83 f8 05             	cmp    $0x5,%eax
ffff800000106cac:	0f 85 9e 00 00 00    	jne    ffff800000106d50 <wait+0x10c>
        // Found one.
        pid = p->pid;
ffff800000106cb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106cb6:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000106cb9:	89 45 f0             	mov    %eax,-0x10(%rbp)
        kfree(p->kstack);
ffff800000106cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106cc0:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106cc4:	48 89 c7             	mov    %rax,%rdi
ffff800000106cc7:	48 b8 cd 41 10 00 00 	movabs $0xffff8000001041cd,%rax
ffff800000106cce:	80 ff ff 
ffff800000106cd1:	ff d0                	call   *%rax
        p->kstack = 0;
ffff800000106cd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106cd7:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000106cde:	00 
        freevm(p->pgdir);
ffff800000106cdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106ce3:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106ce7:	48 89 c7             	mov    %rax,%rdi
ffff800000106cea:	48 b8 d2 bc 10 00 00 	movabs $0xffff80000010bcd2,%rax
ffff800000106cf1:	80 ff ff 
ffff800000106cf4:	ff d0                	call   *%rax
        p->pid = 0;
ffff800000106cf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106cfa:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
        p->parent = 0;
ffff800000106d01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106d05:	48 c7 40 20 00 00 00 	movq   $0x0,0x20(%rax)
ffff800000106d0c:	00 
        p->name[0] = 0;
ffff800000106d0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106d11:	c6 80 d0 00 00 00 00 	movb   $0x0,0xd0(%rax)
        p->killed = 0;
ffff800000106d18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106d1c:	c7 40 40 00 00 00 00 	movl   $0x0,0x40(%rax)
        p->state = UNUSED;
ffff800000106d23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106d27:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
        release(&ptable.lock);
ffff800000106d2e:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000106d35:	80 ff ff 
ffff800000106d38:	48 89 c7             	mov    %rax,%rdi
ffff800000106d3b:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000106d42:	80 ff ff 
ffff800000106d45:	ff d0                	call   *%rax
        return pid;
ffff800000106d47:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000106d4a:	e9 81 00 00 00       	jmp    ffff800000106dd0 <wait+0x18c>
        continue;
ffff800000106d4f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106d50:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff800000106d57:	00 
ffff800000106d58:	48 b8 a8 bc 11 00 00 	movabs $0xffff80000011bca8,%rax
ffff800000106d5f:	80 ff ff 
ffff800000106d62:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106d66:	0f 82 13 ff ff ff    	jb     ffff800000106c7f <wait+0x3b>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
ffff800000106d6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000106d70:	74 12                	je     ffff800000106d84 <wait+0x140>
ffff800000106d72:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106d79:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d7d:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000106d80:	85 c0                	test   %eax,%eax
ffff800000106d82:	74 20                	je     ffff800000106da4 <wait+0x160>
      release(&ptable.lock);
ffff800000106d84:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000106d8b:	80 ff ff 
ffff800000106d8e:	48 89 c7             	mov    %rax,%rdi
ffff800000106d91:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000106d98:	80 ff ff 
ffff800000106d9b:	ff d0                	call   *%rax
      return -1;
ffff800000106d9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106da2:	eb 2c                	jmp    ffff800000106dd0 <wait+0x18c>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
ffff800000106da4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106dab:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106daf:	48 ba 40 84 11 00 00 	movabs $0xffff800000118440,%rdx
ffff800000106db6:	80 ff ff 
ffff800000106db9:	48 89 d6             	mov    %rdx,%rsi
ffff800000106dbc:	48 89 c7             	mov    %rax,%rdi
ffff800000106dbf:	48 b8 d8 70 10 00 00 	movabs $0xffff8000001070d8,%rax
ffff800000106dc6:	80 ff ff 
ffff800000106dc9:	ff d0                	call   *%rax
    havekids = 0;
ffff800000106dcb:	e9 95 fe ff ff       	jmp    ffff800000106c65 <wait+0x21>
  }
}
ffff800000106dd0:	c9                   	leave
ffff800000106dd1:	c3                   	ret

ffff800000106dd2 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
ffff800000106dd2:	55                   	push   %rbp
ffff800000106dd3:	48 89 e5             	mov    %rsp,%rbp
ffff800000106dd6:	48 83 ec 20          	sub    $0x20,%rsp
  int i = 0;
ffff800000106dda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  struct proc *p;
  int skipped = 0;
ffff800000106de1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  for(;;){
    ++i;
ffff800000106de8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    // Enable interrupts on this processor.
    sti();
ffff800000106dec:	48 b8 2b 63 10 00 00 	movabs $0xffff80000010632b,%rax
ffff800000106df3:	80 ff ff 
ffff800000106df6:	ff d0                	call   *%rax
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
ffff800000106df8:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000106dff:	80 ff ff 
ffff800000106e02:	48 89 c7             	mov    %rax,%rdi
ffff800000106e05:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000106e0c:	80 ff ff 
ffff800000106e0f:	ff d0                	call   *%rax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106e11:	48 b8 a8 84 11 00 00 	movabs $0xffff8000001184a8,%rax
ffff800000106e18:	80 ff ff 
ffff800000106e1b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000106e1f:	e9 92 00 00 00       	jmp    ffff800000106eb6 <scheduler+0xe4>
      if(p->state != RUNNABLE) {
ffff800000106e24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106e28:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106e2b:	83 f8 03             	cmp    $0x3,%eax
ffff800000106e2e:	74 06                	je     ffff800000106e36 <scheduler+0x64>
        skipped++;
ffff800000106e30:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
        continue;
ffff800000106e34:	eb 78                	jmp    ffff800000106eae <scheduler+0xdc>
      }
      skipped = 0;
ffff800000106e36:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
ffff800000106e3d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106e44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000106e48:	64 48 89 10          	mov    %rdx,%fs:(%rax)
      switchuvm(p);
ffff800000106e4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106e50:	48 89 c7             	mov    %rax,%rdi
ffff800000106e53:	48 b8 9c b4 10 00 00 	movabs $0xffff80000010b49c,%rax
ffff800000106e5a:	80 ff ff 
ffff800000106e5d:	ff d0                	call   *%rax
      p->state = RUNNING;
ffff800000106e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106e63:	c7 40 18 04 00 00 00 	movl   $0x4,0x18(%rax)
      swtch(&cpu->scheduler, p->context);
ffff800000106e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106e6e:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000106e72:	48 c7 c2 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rdx
ffff800000106e79:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000106e7d:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106e81:	48 89 c6             	mov    %rax,%rsi
ffff800000106e84:	48 89 d7             	mov    %rdx,%rdi
ffff800000106e87:	48 b8 bb 7d 10 00 00 	movabs $0xffff800000107dbb,%rax
ffff800000106e8e:	80 ff ff 
ffff800000106e91:	ff d0                	call   *%rax
      switchkvm();
ffff800000106e93:	48 b8 a8 b7 10 00 00 	movabs $0xffff80000010b7a8,%rax
ffff800000106e9a:	80 ff ff 
ffff800000106e9d:	ff d0                	call   *%rax

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
ffff800000106e9f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106ea6:	64 48 c7 00 00 00 00 	movq   $0x0,%fs:(%rax)
ffff800000106ead:	00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106eae:	48 81 45 f0 e0 00 00 	addq   $0xe0,-0x10(%rbp)
ffff800000106eb5:	00 
ffff800000106eb6:	48 b8 a8 bc 11 00 00 	movabs $0xffff80000011bca8,%rax
ffff800000106ebd:	80 ff ff 
ffff800000106ec0:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000106ec4:	0f 82 5a ff ff ff    	jb     ffff800000106e24 <scheduler+0x52>
    }
    release(&ptable.lock);
ffff800000106eca:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000106ed1:	80 ff ff 
ffff800000106ed4:	48 89 c7             	mov    %rax,%rdi
ffff800000106ed7:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000106ede:	80 ff ff 
ffff800000106ee1:	ff d0                	call   *%rax
    if (skipped > NPROC) {
ffff800000106ee3:	83 7d ec 40          	cmpl   $0x40,-0x14(%rbp)
ffff800000106ee7:	0f 8e fb fe ff ff    	jle    ffff800000106de8 <scheduler+0x16>
      hlt();
ffff800000106eed:	48 b8 33 63 10 00 00 	movabs $0xffff800000106333,%rax
ffff800000106ef4:	80 ff ff 
ffff800000106ef7:	ff d0                	call   *%rax
      skipped = 0;
ffff800000106ef9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    ++i;
ffff800000106f00:	e9 e3 fe ff ff       	jmp    ffff800000106de8 <scheduler+0x16>

ffff800000106f05 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
ffff800000106f05:	55                   	push   %rbp
ffff800000106f06:	48 89 e5             	mov    %rsp,%rbp
ffff800000106f09:	48 83 ec 10          	sub    $0x10,%rsp
  int intena;


  if(!holding(&ptable.lock))
ffff800000106f0d:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000106f14:	80 ff ff 
ffff800000106f17:	48 89 c7             	mov    %rax,%rdi
ffff800000106f1a:	48 b8 be 78 10 00 00 	movabs $0xffff8000001078be,%rax
ffff800000106f21:	80 ff ff 
ffff800000106f24:	ff d0                	call   *%rax
ffff800000106f26:	85 c0                	test   %eax,%eax
ffff800000106f28:	75 19                	jne    ffff800000106f43 <sched+0x3e>
    panic("sched ptable.lock");
ffff800000106f2a:	48 b8 49 ca 10 00 00 	movabs $0xffff80000010ca49,%rax
ffff800000106f31:	80 ff ff 
ffff800000106f34:	48 89 c7             	mov    %rax,%rdi
ffff800000106f37:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106f3e:	80 ff ff 
ffff800000106f41:	ff d0                	call   *%rax
  if(cpu->ncli != 1)
ffff800000106f43:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106f4a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106f4e:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000106f51:	83 f8 01             	cmp    $0x1,%eax
ffff800000106f54:	74 19                	je     ffff800000106f6f <sched+0x6a>
    panic("sched locks");
ffff800000106f56:	48 b8 5b ca 10 00 00 	movabs $0xffff80000010ca5b,%rax
ffff800000106f5d:	80 ff ff 
ffff800000106f60:	48 89 c7             	mov    %rax,%rdi
ffff800000106f63:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106f6a:	80 ff ff 
ffff800000106f6d:	ff d0                	call   *%rax
  if(proc->state == RUNNING)
ffff800000106f6f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106f76:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106f7a:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106f7d:	83 f8 04             	cmp    $0x4,%eax
ffff800000106f80:	75 19                	jne    ffff800000106f9b <sched+0x96>
    panic("sched running");
ffff800000106f82:	48 b8 67 ca 10 00 00 	movabs $0xffff80000010ca67,%rax
ffff800000106f89:	80 ff ff 
ffff800000106f8c:	48 89 c7             	mov    %rax,%rdi
ffff800000106f8f:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106f96:	80 ff ff 
ffff800000106f99:	ff d0                	call   *%rax
  if(readeflags()&FL_IF)
ffff800000106f9b:	48 b8 17 63 10 00 00 	movabs $0xffff800000106317,%rax
ffff800000106fa2:	80 ff ff 
ffff800000106fa5:	ff d0                	call   *%rax
ffff800000106fa7:	25 00 02 00 00       	and    $0x200,%eax
ffff800000106fac:	48 85 c0             	test   %rax,%rax
ffff800000106faf:	74 19                	je     ffff800000106fca <sched+0xc5>
    panic("sched interruptible");
ffff800000106fb1:	48 b8 75 ca 10 00 00 	movabs $0xffff80000010ca75,%rax
ffff800000106fb8:	80 ff ff 
ffff800000106fbb:	48 89 c7             	mov    %rax,%rdi
ffff800000106fbe:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106fc5:	80 ff ff 
ffff800000106fc8:	ff d0                	call   *%rax
  intena = cpu->intena;
ffff800000106fca:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106fd1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106fd5:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106fd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  swtch(&proc->context, cpu->scheduler);
ffff800000106fdb:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106fe2:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106fe6:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106fea:	48 c7 c2 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rdx
ffff800000106ff1:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000106ff5:	48 83 c2 30          	add    $0x30,%rdx
ffff800000106ff9:	48 89 c6             	mov    %rax,%rsi
ffff800000106ffc:	48 89 d7             	mov    %rdx,%rdi
ffff800000106fff:	48 b8 bb 7d 10 00 00 	movabs $0xffff800000107dbb,%rax
ffff800000107006:	80 ff ff 
ffff800000107009:	ff d0                	call   *%rax
  cpu->intena = intena;
ffff80000010700b:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107012:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107016:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000107019:	89 50 18             	mov    %edx,0x18(%rax)
}
ffff80000010701c:	90                   	nop
ffff80000010701d:	c9                   	leave
ffff80000010701e:	c3                   	ret

ffff80000010701f <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
ffff80000010701f:	55                   	push   %rbp
ffff800000107020:	48 89 e5             	mov    %rsp,%rbp
  acquire(&ptable.lock);  //DOC: yieldlock
ffff800000107023:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff80000010702a:	80 ff ff 
ffff80000010702d:	48 89 c7             	mov    %rax,%rdi
ffff800000107030:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000107037:	80 ff ff 
ffff80000010703a:	ff d0                	call   *%rax
  proc->state = RUNNABLE;
ffff80000010703c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107043:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107047:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  sched();
ffff80000010704e:	48 b8 05 6f 10 00 00 	movabs $0xffff800000106f05,%rax
ffff800000107055:	80 ff ff 
ffff800000107058:	ff d0                	call   *%rax
  release(&ptable.lock);
ffff80000010705a:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000107061:	80 ff ff 
ffff800000107064:	48 89 c7             	mov    %rax,%rdi
ffff800000107067:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010706e:	80 ff ff 
ffff800000107071:	ff d0                	call   *%rax
}
ffff800000107073:	90                   	nop
ffff800000107074:	5d                   	pop    %rbp
ffff800000107075:	c3                   	ret

ffff800000107076 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
ffff800000107076:	55                   	push   %rbp
ffff800000107077:	48 89 e5             	mov    %rsp,%rbp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
ffff80000010707a:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000107081:	80 ff ff 
ffff800000107084:	48 89 c7             	mov    %rax,%rdi
ffff800000107087:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010708e:	80 ff ff 
ffff800000107091:	ff d0                	call   *%rax

  if (first) {
ffff800000107093:	48 b8 44 d5 10 00 00 	movabs $0xffff80000010d544,%rax
ffff80000010709a:	80 ff ff 
ffff80000010709d:	8b 00                	mov    (%rax),%eax
ffff80000010709f:	85 c0                	test   %eax,%eax
ffff8000001070a1:	74 32                	je     ffff8000001070d5 <forkret+0x5f>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
ffff8000001070a3:	48 b8 44 d5 10 00 00 	movabs $0xffff80000010d544,%rax
ffff8000001070aa:	80 ff ff 
ffff8000001070ad:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    iinit(ROOTDEV);
ffff8000001070b3:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001070b8:	48 b8 3f 25 10 00 00 	movabs $0xffff80000010253f,%rax
ffff8000001070bf:	80 ff ff 
ffff8000001070c2:	ff d0                	call   *%rax
    initlog(ROOTDEV);
ffff8000001070c4:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001070c9:	48 b8 71 4d 10 00 00 	movabs $0xffff800000104d71,%rax
ffff8000001070d0:	80 ff ff 
ffff8000001070d3:	ff d0                	call   *%rax
  }

  // Return to "caller", actually trapret (see allocproc).
}
ffff8000001070d5:	90                   	nop
ffff8000001070d6:	5d                   	pop    %rbp
ffff8000001070d7:	c3                   	ret

ffff8000001070d8 <sleep>:
//PAGEBREAK!
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
ffff8000001070d8:	55                   	push   %rbp
ffff8000001070d9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001070dc:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001070e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001070e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(proc == 0)
ffff8000001070e8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001070ef:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001070f3:	48 85 c0             	test   %rax,%rax
ffff8000001070f6:	75 19                	jne    ffff800000107111 <sleep+0x39>
    panic("sleep");
ffff8000001070f8:	48 b8 89 ca 10 00 00 	movabs $0xffff80000010ca89,%rax
ffff8000001070ff:	80 ff ff 
ffff800000107102:	48 89 c7             	mov    %rax,%rdi
ffff800000107105:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010710c:	80 ff ff 
ffff80000010710f:	ff d0                	call   *%rax

  if(lk == 0)
ffff800000107111:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000107116:	75 19                	jne    ffff800000107131 <sleep+0x59>
    panic("sleep without lk");
ffff800000107118:	48 b8 8f ca 10 00 00 	movabs $0xffff80000010ca8f,%rax
ffff80000010711f:	80 ff ff 
ffff800000107122:	48 89 c7             	mov    %rax,%rdi
ffff800000107125:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010712c:	80 ff ff 
ffff80000010712f:	ff d0                	call   *%rax
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
ffff800000107131:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000107138:	80 ff ff 
ffff80000010713b:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff80000010713f:	74 2c                	je     ffff80000010716d <sleep+0x95>
    acquire(&ptable.lock);  //DOC: sleeplock1
ffff800000107141:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000107148:	80 ff ff 
ffff80000010714b:	48 89 c7             	mov    %rax,%rdi
ffff80000010714e:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000107155:	80 ff ff 
ffff800000107158:	ff d0                	call   *%rax
    release(lk);
ffff80000010715a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010715e:	48 89 c7             	mov    %rax,%rdi
ffff800000107161:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000107168:	80 ff ff 
ffff80000010716b:	ff d0                	call   *%rax
  }

  // Go to sleep.
  proc->chan = chan;
ffff80000010716d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107174:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107178:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010717c:	48 89 50 38          	mov    %rdx,0x38(%rax)
  proc->state = SLEEPING;
ffff800000107180:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107187:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010718b:	c7 40 18 02 00 00 00 	movl   $0x2,0x18(%rax)
  sched();
ffff800000107192:	48 b8 05 6f 10 00 00 	movabs $0xffff800000106f05,%rax
ffff800000107199:	80 ff ff 
ffff80000010719c:	ff d0                	call   *%rax

  // Tidy up.
  proc->chan = 0;
ffff80000010719e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001071a5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001071a9:	48 c7 40 38 00 00 00 	movq   $0x0,0x38(%rax)
ffff8000001071b0:	00 

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
ffff8000001071b1:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff8000001071b8:	80 ff ff 
ffff8000001071bb:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff8000001071bf:	74 2c                	je     ffff8000001071ed <sleep+0x115>
    release(&ptable.lock);
ffff8000001071c1:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff8000001071c8:	80 ff ff 
ffff8000001071cb:	48 89 c7             	mov    %rax,%rdi
ffff8000001071ce:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001071d5:	80 ff ff 
ffff8000001071d8:	ff d0                	call   *%rax
    acquire(lk);
ffff8000001071da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001071de:	48 89 c7             	mov    %rax,%rdi
ffff8000001071e1:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff8000001071e8:	80 ff ff 
ffff8000001071eb:	ff d0                	call   *%rax
  }
}
ffff8000001071ed:	90                   	nop
ffff8000001071ee:	c9                   	leave
ffff8000001071ef:	c3                   	ret

ffff8000001071f0 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
ffff8000001071f0:	55                   	push   %rbp
ffff8000001071f1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001071f4:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001071f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff8000001071fc:	48 b8 a8 84 11 00 00 	movabs $0xffff8000001184a8,%rax
ffff800000107203:	80 ff ff 
ffff800000107206:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010720a:	eb 2d                	jmp    ffff800000107239 <wakeup1+0x49>
    if(p->state == SLEEPING && p->chan == chan)
ffff80000010720c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107210:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000107213:	83 f8 02             	cmp    $0x2,%eax
ffff800000107216:	75 19                	jne    ffff800000107231 <wakeup1+0x41>
ffff800000107218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010721c:	48 8b 40 38          	mov    0x38(%rax),%rax
ffff800000107220:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000107224:	75 0b                	jne    ffff800000107231 <wakeup1+0x41>
      p->state = RUNNABLE;
ffff800000107226:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010722a:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff800000107231:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff800000107238:	00 
ffff800000107239:	48 b8 a8 bc 11 00 00 	movabs $0xffff80000011bca8,%rax
ffff800000107240:	80 ff ff 
ffff800000107243:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000107247:	72 c3                	jb     ffff80000010720c <wakeup1+0x1c>
}
ffff800000107249:	90                   	nop
ffff80000010724a:	90                   	nop
ffff80000010724b:	c9                   	leave
ffff80000010724c:	c3                   	ret

ffff80000010724d <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
ffff80000010724d:	55                   	push   %rbp
ffff80000010724e:	48 89 e5             	mov    %rsp,%rbp
ffff800000107251:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107255:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&ptable.lock);
ffff800000107259:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000107260:	80 ff ff 
ffff800000107263:	48 89 c7             	mov    %rax,%rdi
ffff800000107266:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff80000010726d:	80 ff ff 
ffff800000107270:	ff d0                	call   *%rax
  wakeup1(chan);
ffff800000107272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107276:	48 89 c7             	mov    %rax,%rdi
ffff800000107279:	48 b8 f0 71 10 00 00 	movabs $0xffff8000001071f0,%rax
ffff800000107280:	80 ff ff 
ffff800000107283:	ff d0                	call   *%rax
  release(&ptable.lock);
ffff800000107285:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff80000010728c:	80 ff ff 
ffff80000010728f:	48 89 c7             	mov    %rax,%rdi
ffff800000107292:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000107299:	80 ff ff 
ffff80000010729c:	ff d0                	call   *%rax
}
ffff80000010729e:	90                   	nop
ffff80000010729f:	c9                   	leave
ffff8000001072a0:	c3                   	ret

ffff8000001072a1 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
ffff8000001072a1:	55                   	push   %rbp
ffff8000001072a2:	48 89 e5             	mov    %rsp,%rbp
ffff8000001072a5:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001072a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  struct proc *p;

  acquire(&ptable.lock);
ffff8000001072ac:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff8000001072b3:	80 ff ff 
ffff8000001072b6:	48 89 c7             	mov    %rax,%rdi
ffff8000001072b9:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff8000001072c0:	80 ff ff 
ffff8000001072c3:	ff d0                	call   *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff8000001072c5:	48 b8 a8 84 11 00 00 	movabs $0xffff8000001184a8,%rax
ffff8000001072cc:	80 ff ff 
ffff8000001072cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001072d3:	eb 56                	jmp    ffff80000010732b <kill+0x8a>
    if(p->pid == pid){
ffff8000001072d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001072d9:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff8000001072dc:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff8000001072df:	75 42                	jne    ffff800000107323 <kill+0x82>
      p->killed = 1;
ffff8000001072e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001072e5:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
ffff8000001072ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001072f0:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001072f3:	83 f8 02             	cmp    $0x2,%eax
ffff8000001072f6:	75 0b                	jne    ffff800000107303 <kill+0x62>
        p->state = RUNNABLE;
ffff8000001072f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001072fc:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
      release(&ptable.lock);
ffff800000107303:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff80000010730a:	80 ff ff 
ffff80000010730d:	48 89 c7             	mov    %rax,%rdi
ffff800000107310:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000107317:	80 ff ff 
ffff80000010731a:	ff d0                	call   *%rax
      return 0;
ffff80000010731c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107321:	eb 36                	jmp    ffff800000107359 <kill+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000107323:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff80000010732a:	00 
ffff80000010732b:	48 b8 a8 bc 11 00 00 	movabs $0xffff80000011bca8,%rax
ffff800000107332:	80 ff ff 
ffff800000107335:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000107339:	72 9a                	jb     ffff8000001072d5 <kill+0x34>
    }
  }
  release(&ptable.lock);
ffff80000010733b:	48 b8 40 84 11 00 00 	movabs $0xffff800000118440,%rax
ffff800000107342:	80 ff ff 
ffff800000107345:	48 89 c7             	mov    %rax,%rdi
ffff800000107348:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010734f:	80 ff ff 
ffff800000107352:	ff d0                	call   *%rax
  return -1;
ffff800000107354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000107359:	c9                   	leave
ffff80000010735a:	c3                   	ret

ffff80000010735b <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
ffff80000010735b:	55                   	push   %rbp
ffff80000010735c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010735f:	48 83 ec 70          	sub    $0x70,%rsp
  int i;
  struct proc *p;
  char *state;
  addr_t pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000107363:	48 b8 a8 84 11 00 00 	movabs $0xffff8000001184a8,%rax
ffff80000010736a:	80 ff ff 
ffff80000010736d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000107371:	e9 41 01 00 00       	jmp    ffff8000001074b7 <procdump+0x15c>
    if(p->state == UNUSED)
ffff800000107376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010737a:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010737d:	85 c0                	test   %eax,%eax
ffff80000010737f:	0f 84 29 01 00 00    	je     ffff8000001074ae <procdump+0x153>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
ffff800000107385:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107389:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010738c:	83 f8 05             	cmp    $0x5,%eax
ffff80000010738f:	77 39                	ja     ffff8000001073ca <procdump+0x6f>
ffff800000107391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107395:	8b 50 18             	mov    0x18(%rax),%edx
ffff800000107398:	48 b8 60 d5 10 00 00 	movabs $0xffff80000010d560,%rax
ffff80000010739f:	80 ff ff 
ffff8000001073a2:	89 d2                	mov    %edx,%edx
ffff8000001073a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffff8000001073a8:	48 85 c0             	test   %rax,%rax
ffff8000001073ab:	74 1d                	je     ffff8000001073ca <procdump+0x6f>
      state = states[p->state];
ffff8000001073ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001073b1:	8b 50 18             	mov    0x18(%rax),%edx
ffff8000001073b4:	48 b8 60 d5 10 00 00 	movabs $0xffff80000010d560,%rax
ffff8000001073bb:	80 ff ff 
ffff8000001073be:	89 d2                	mov    %edx,%edx
ffff8000001073c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffff8000001073c4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff8000001073c8:	eb 0e                	jmp    ffff8000001073d8 <procdump+0x7d>
    else
      state = "???";
ffff8000001073ca:	48 b8 a0 ca 10 00 00 	movabs $0xffff80000010caa0,%rax
ffff8000001073d1:	80 ff ff 
ffff8000001073d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    cprintf("%d %s %s", p->pid, state, p->name);
ffff8000001073d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001073dc:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff8000001073e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001073e7:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff8000001073ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001073ee:	48 bf a4 ca 10 00 00 	movabs $0xffff80000010caa4,%rdi
ffff8000001073f5:	80 ff ff 
ffff8000001073f8:	89 c6                	mov    %eax,%esi
ffff8000001073fa:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001073ff:	49 b8 04 08 10 00 00 	movabs $0xffff800000100804,%r8
ffff800000107406:	80 ff ff 
ffff800000107409:	41 ff d0             	call   *%r8
    if(p->state == SLEEPING){
ffff80000010740c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107410:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000107413:	83 f8 02             	cmp    $0x2,%eax
ffff800000107416:	75 76                	jne    ffff80000010748e <procdump+0x133>
      getstackpcs((addr_t*)p->context->rbp+2, pc);
ffff800000107418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010741c:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000107420:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107424:	48 83 c0 10          	add    $0x10,%rax
ffff800000107428:	48 89 c2             	mov    %rax,%rdx
ffff80000010742b:	48 8d 45 90          	lea    -0x70(%rbp),%rax
ffff80000010742f:	48 89 c6             	mov    %rax,%rsi
ffff800000107432:	48 89 d7             	mov    %rdx,%rdi
ffff800000107435:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff80000010743c:	80 ff ff 
ffff80000010743f:	ff d0                	call   *%rax
      for(i=0; i<10 && pc[i] != 0; i++)
ffff800000107441:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000107448:	eb 2f                	jmp    ffff800000107479 <procdump+0x11e>
        cprintf(" %p", pc[i]);
ffff80000010744a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010744d:	48 98                	cltq
ffff80000010744f:	48 8b 44 c5 90       	mov    -0x70(%rbp,%rax,8),%rax
ffff800000107454:	48 ba ad ca 10 00 00 	movabs $0xffff80000010caad,%rdx
ffff80000010745b:	80 ff ff 
ffff80000010745e:	48 89 c6             	mov    %rax,%rsi
ffff800000107461:	48 89 d7             	mov    %rdx,%rdi
ffff800000107464:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107469:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000107470:	80 ff ff 
ffff800000107473:	ff d2                	call   *%rdx
      for(i=0; i<10 && pc[i] != 0; i++)
ffff800000107475:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000107479:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff80000010747d:	7f 0f                	jg     ffff80000010748e <procdump+0x133>
ffff80000010747f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107482:	48 98                	cltq
ffff800000107484:	48 8b 44 c5 90       	mov    -0x70(%rbp,%rax,8),%rax
ffff800000107489:	48 85 c0             	test   %rax,%rax
ffff80000010748c:	75 bc                	jne    ffff80000010744a <procdump+0xef>
    }
    cprintf("\n");
ffff80000010748e:	48 b8 b1 ca 10 00 00 	movabs $0xffff80000010cab1,%rax
ffff800000107495:	80 ff ff 
ffff800000107498:	48 89 c7             	mov    %rax,%rdi
ffff80000010749b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001074a0:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff8000001074a7:	80 ff ff 
ffff8000001074aa:	ff d2                	call   *%rdx
ffff8000001074ac:	eb 01                	jmp    ffff8000001074af <procdump+0x154>
      continue;
ffff8000001074ae:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff8000001074af:	48 81 45 f0 e0 00 00 	addq   $0xe0,-0x10(%rbp)
ffff8000001074b6:	00 
ffff8000001074b7:	48 b8 a8 bc 11 00 00 	movabs $0xffff80000011bca8,%rax
ffff8000001074be:	80 ff ff 
ffff8000001074c1:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff8000001074c5:	0f 82 ab fe ff ff    	jb     ffff800000107376 <procdump+0x1b>
  }
}
ffff8000001074cb:	90                   	nop
ffff8000001074cc:	90                   	nop
ffff8000001074cd:	c9                   	leave
ffff8000001074ce:	c3                   	ret

ffff8000001074cf <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
ffff8000001074cf:	55                   	push   %rbp
ffff8000001074d0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001074d3:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001074d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001074db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  initlock(&lk->lk, "sleep lock");
ffff8000001074df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001074e3:	48 83 c0 08          	add    $0x8,%rax
ffff8000001074e7:	48 ba dd ca 10 00 00 	movabs $0xffff80000010cadd,%rdx
ffff8000001074ee:	80 ff ff 
ffff8000001074f1:	48 89 d6             	mov    %rdx,%rsi
ffff8000001074f4:	48 89 c7             	mov    %rax,%rdi
ffff8000001074f7:	48 b8 a5 76 10 00 00 	movabs $0xffff8000001076a5,%rax
ffff8000001074fe:	80 ff ff 
ffff800000107501:	ff d0                	call   *%rax
  lk->name = name;
ffff800000107503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107507:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010750b:	48 89 50 70          	mov    %rdx,0x70(%rax)
  lk->locked = 0;
ffff80000010750f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107513:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->pid = 0;
ffff800000107519:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010751d:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%rax)
}
ffff800000107524:	90                   	nop
ffff800000107525:	c9                   	leave
ffff800000107526:	c3                   	ret

ffff800000107527 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
ffff800000107527:	55                   	push   %rbp
ffff800000107528:	48 89 e5             	mov    %rsp,%rbp
ffff80000010752b:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010752f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&lk->lk);
ffff800000107533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107537:	48 83 c0 08          	add    $0x8,%rax
ffff80000010753b:	48 89 c7             	mov    %rax,%rdi
ffff80000010753e:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000107545:	80 ff ff 
ffff800000107548:	ff d0                	call   *%rax
  while (lk->locked)
ffff80000010754a:	eb 1e                	jmp    ffff80000010756a <acquiresleep+0x43>
    sleep(lk, &lk->lk);
ffff80000010754c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107550:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000107554:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107558:	48 89 d6             	mov    %rdx,%rsi
ffff80000010755b:	48 89 c7             	mov    %rax,%rdi
ffff80000010755e:	48 b8 d8 70 10 00 00 	movabs $0xffff8000001070d8,%rax
ffff800000107565:	80 ff ff 
ffff800000107568:	ff d0                	call   *%rax
  while (lk->locked)
ffff80000010756a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010756e:	8b 00                	mov    (%rax),%eax
ffff800000107570:	85 c0                	test   %eax,%eax
ffff800000107572:	75 d8                	jne    ffff80000010754c <acquiresleep+0x25>
  lk->locked = 1;
ffff800000107574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107578:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  lk->pid = proc->pid;
ffff80000010757e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107585:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107589:	8b 50 1c             	mov    0x1c(%rax),%edx
ffff80000010758c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107590:	89 50 78             	mov    %edx,0x78(%rax)
  release(&lk->lk);
ffff800000107593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107597:	48 83 c0 08          	add    $0x8,%rax
ffff80000010759b:	48 89 c7             	mov    %rax,%rdi
ffff80000010759e:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001075a5:	80 ff ff 
ffff8000001075a8:	ff d0                	call   *%rax
}
ffff8000001075aa:	90                   	nop
ffff8000001075ab:	c9                   	leave
ffff8000001075ac:	c3                   	ret

ffff8000001075ad <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
ffff8000001075ad:	55                   	push   %rbp
ffff8000001075ae:	48 89 e5             	mov    %rsp,%rbp
ffff8000001075b1:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001075b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&lk->lk);
ffff8000001075b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075bd:	48 83 c0 08          	add    $0x8,%rax
ffff8000001075c1:	48 89 c7             	mov    %rax,%rdi
ffff8000001075c4:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff8000001075cb:	80 ff ff 
ffff8000001075ce:	ff d0                	call   *%rax
  lk->locked = 0;
ffff8000001075d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075d4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->pid = 0;
ffff8000001075da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075de:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%rax)
  wakeup(lk);
ffff8000001075e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075e9:	48 89 c7             	mov    %rax,%rdi
ffff8000001075ec:	48 b8 4d 72 10 00 00 	movabs $0xffff80000010724d,%rax
ffff8000001075f3:	80 ff ff 
ffff8000001075f6:	ff d0                	call   *%rax
  release(&lk->lk);
ffff8000001075f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075fc:	48 83 c0 08          	add    $0x8,%rax
ffff800000107600:	48 89 c7             	mov    %rax,%rdi
ffff800000107603:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010760a:	80 ff ff 
ffff80000010760d:	ff d0                	call   *%rax
}
ffff80000010760f:	90                   	nop
ffff800000107610:	c9                   	leave
ffff800000107611:	c3                   	ret

ffff800000107612 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
ffff800000107612:	55                   	push   %rbp
ffff800000107613:	48 89 e5             	mov    %rsp,%rbp
ffff800000107616:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010761a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  acquire(&lk->lk);
ffff80000010761e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107622:	48 83 c0 08          	add    $0x8,%rax
ffff800000107626:	48 89 c7             	mov    %rax,%rdi
ffff800000107629:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000107630:	80 ff ff 
ffff800000107633:	ff d0                	call   *%rax
  int r = lk->locked;
ffff800000107635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107639:	8b 00                	mov    (%rax),%eax
ffff80000010763b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  release(&lk->lk);
ffff80000010763e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107642:	48 83 c0 08          	add    $0x8,%rax
ffff800000107646:	48 89 c7             	mov    %rax,%rdi
ffff800000107649:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000107650:	80 ff ff 
ffff800000107653:	ff d0                	call   *%rax
  return r;
ffff800000107655:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000107658:	c9                   	leave
ffff800000107659:	c3                   	ret

ffff80000010765a <readeflags>:
{
ffff80000010765a:	55                   	push   %rbp
ffff80000010765b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010765e:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff800000107662:	9c                   	pushf
ffff800000107663:	58                   	pop    %rax
ffff800000107664:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff800000107668:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010766c:	c9                   	leave
ffff80000010766d:	c3                   	ret

ffff80000010766e <cli>:
{
ffff80000010766e:	55                   	push   %rbp
ffff80000010766f:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("cli");
ffff800000107672:	fa                   	cli
}
ffff800000107673:	90                   	nop
ffff800000107674:	5d                   	pop    %rbp
ffff800000107675:	c3                   	ret

ffff800000107676 <sti>:
{
ffff800000107676:	55                   	push   %rbp
ffff800000107677:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("sti");
ffff80000010767a:	fb                   	sti
}
ffff80000010767b:	90                   	nop
ffff80000010767c:	5d                   	pop    %rbp
ffff80000010767d:	c3                   	ret

ffff80000010767e <xchg>:
{
ffff80000010767e:	55                   	push   %rbp
ffff80000010767f:	48 89 e5             	mov    %rsp,%rbp
ffff800000107682:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107686:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010768a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  asm volatile("lock; xchgl %0, %1" :
ffff80000010768e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000107692:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107696:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff80000010769a:	f0 87 02             	lock xchg %eax,(%rdx)
ffff80000010769d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  return result;
ffff8000001076a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001076a3:	c9                   	leave
ffff8000001076a4:	c3                   	ret

ffff8000001076a5 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
ffff8000001076a5:	55                   	push   %rbp
ffff8000001076a6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001076a9:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001076ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001076b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  lk->name = name;
ffff8000001076b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001076bd:	48 89 50 08          	mov    %rdx,0x8(%rax)
  lk->locked = 0;
ffff8000001076c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076c5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->cpu = 0;
ffff8000001076cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076cf:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff8000001076d6:	00 
}
ffff8000001076d7:	90                   	nop
ffff8000001076d8:	c9                   	leave
ffff8000001076d9:	c3                   	ret

ffff8000001076da <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
ffff8000001076da:	55                   	push   %rbp
ffff8000001076db:	48 89 e5             	mov    %rsp,%rbp
ffff8000001076de:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001076e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  pushcli(); // disable interrupts to avoid deadlock.
ffff8000001076e6:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001076ed:	80 ff ff 
ffff8000001076f0:	ff d0                	call   *%rax
  if(holding(lk))
ffff8000001076f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076f6:	48 89 c7             	mov    %rax,%rdi
ffff8000001076f9:	48 b8 be 78 10 00 00 	movabs $0xffff8000001078be,%rax
ffff800000107700:	80 ff ff 
ffff800000107703:	ff d0                	call   *%rax
ffff800000107705:	85 c0                	test   %eax,%eax
ffff800000107707:	74 19                	je     ffff800000107722 <acquire+0x48>
    panic("acquire");
ffff800000107709:	48 b8 e8 ca 10 00 00 	movabs $0xffff80000010cae8,%rax
ffff800000107710:	80 ff ff 
ffff800000107713:	48 89 c7             	mov    %rax,%rdi
ffff800000107716:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010771d:	80 ff ff 
ffff800000107720:	ff d0                	call   *%rax

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
ffff800000107722:	90                   	nop
ffff800000107723:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107727:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010772c:	48 89 c7             	mov    %rax,%rdi
ffff80000010772f:	48 b8 7e 76 10 00 00 	movabs $0xffff80000010767e,%rax
ffff800000107736:	80 ff ff 
ffff800000107739:	ff d0                	call   *%rax
ffff80000010773b:	85 c0                	test   %eax,%eax
ffff80000010773d:	75 e4                	jne    ffff800000107723 <acquire+0x49>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
ffff80000010773f:	f0 48 83 0c 24 00    	lock orq $0x0,(%rsp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
ffff800000107745:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107749:	48 c7 c2 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rdx
ffff800000107750:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000107754:	48 89 50 10          	mov    %rdx,0x10(%rax)
  getcallerpcs(&lk, lk->pcs);
ffff800000107758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010775c:	48 8d 50 18          	lea    0x18(%rax),%rdx
ffff800000107760:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000107764:	48 89 d6             	mov    %rdx,%rsi
ffff800000107767:	48 89 c7             	mov    %rax,%rdi
ffff80000010776a:	48 b8 f0 77 10 00 00 	movabs $0xffff8000001077f0,%rax
ffff800000107771:	80 ff ff 
ffff800000107774:	ff d0                	call   *%rax
}
ffff800000107776:	90                   	nop
ffff800000107777:	c9                   	leave
ffff800000107778:	c3                   	ret

ffff800000107779 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
ffff800000107779:	55                   	push   %rbp
ffff80000010777a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010777d:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107781:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holding(lk))
ffff800000107785:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107789:	48 89 c7             	mov    %rax,%rdi
ffff80000010778c:	48 b8 be 78 10 00 00 	movabs $0xffff8000001078be,%rax
ffff800000107793:	80 ff ff 
ffff800000107796:	ff d0                	call   *%rax
ffff800000107798:	85 c0                	test   %eax,%eax
ffff80000010779a:	75 19                	jne    ffff8000001077b5 <release+0x3c>
    panic("release");
ffff80000010779c:	48 b8 f0 ca 10 00 00 	movabs $0xffff80000010caf0,%rax
ffff8000001077a3:	80 ff ff 
ffff8000001077a6:	48 89 c7             	mov    %rax,%rdi
ffff8000001077a9:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001077b0:	80 ff ff 
ffff8000001077b3:	ff d0                	call   *%rax

  lk->pcs[0] = 0;
ffff8000001077b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001077b9:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
ffff8000001077c0:	00 
  lk->cpu = 0;
ffff8000001077c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001077c5:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff8000001077cc:	00 
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
ffff8000001077cd:	f0 48 83 0c 24 00    	lock orq $0x0,(%rsp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
ffff8000001077d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001077d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001077db:	c7 00 00 00 00 00    	movl   $0x0,(%rax)

  popcli();
ffff8000001077e1:	48 b8 68 79 10 00 00 	movabs $0xffff800000107968,%rax
ffff8000001077e8:	80 ff ff 
ffff8000001077eb:	ff d0                	call   *%rax
}
ffff8000001077ed:	90                   	nop
ffff8000001077ee:	c9                   	leave
ffff8000001077ef:	c3                   	ret

ffff8000001077f0 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %rbp chain.
void
getcallerpcs(void *v, addr_t pcs[])
{
ffff8000001077f0:	55                   	push   %rbp
ffff8000001077f1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001077f4:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001077f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001077fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  addr_t *rbp;

  asm volatile("mov %%rbp, %0" : "=r" (rbp));
ffff800000107800:	48 89 e8             	mov    %rbp,%rax
ffff800000107803:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  getstackpcs(rbp, pcs);
ffff800000107807:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010780b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010780f:	48 89 d6             	mov    %rdx,%rsi
ffff800000107812:	48 89 c7             	mov    %rax,%rdi
ffff800000107815:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff80000010781c:	80 ff ff 
ffff80000010781f:	ff d0                	call   *%rax
}
ffff800000107821:	90                   	nop
ffff800000107822:	c9                   	leave
ffff800000107823:	c3                   	ret

ffff800000107824 <getstackpcs>:

void
getstackpcs(addr_t *rbp, addr_t pcs[])
{
ffff800000107824:	55                   	push   %rbp
ffff800000107825:	48 89 e5             	mov    %rsp,%rbp
ffff800000107828:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010782c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107830:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  for(i = 0; i < 10; i++){
ffff800000107834:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010783b:	eb 50                	jmp    ffff80000010788d <getstackpcs+0x69>
    if(rbp == 0 || rbp < (addr_t*)KERNBASE || rbp == (addr_t*)0xffffffff)
ffff80000010783d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000107842:	74 70                	je     ffff8000001078b4 <getstackpcs+0x90>
ffff800000107844:	48 b8 ff ff ff ff ff 	movabs $0xffff7fffffffffff,%rax
ffff80000010784b:	7f ff ff 
ffff80000010784e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff800000107852:	73 60                	jae    ffff8000001078b4 <getstackpcs+0x90>
ffff800000107854:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107859:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff80000010785d:	74 55                	je     ffff8000001078b4 <getstackpcs+0x90>
      break;
    pcs[i] = rbp[1];     // saved %rip
ffff80000010785f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107862:	48 98                	cltq
ffff800000107864:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010786b:	00 
ffff80000010786c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107870:	48 01 c2             	add    %rax,%rdx
ffff800000107873:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107877:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010787b:	48 89 02             	mov    %rax,(%rdx)
    rbp = (addr_t*)rbp[0]; // saved %rbp
ffff80000010787e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107882:	48 8b 00             	mov    (%rax),%rax
ffff800000107885:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for(i = 0; i < 10; i++){
ffff800000107889:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010788d:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff800000107891:	7e aa                	jle    ffff80000010783d <getstackpcs+0x19>
  }
  for(; i < 10; i++)
ffff800000107893:	eb 1f                	jmp    ffff8000001078b4 <getstackpcs+0x90>
    pcs[i] = 0;
ffff800000107895:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107898:	48 98                	cltq
ffff80000010789a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001078a1:	00 
ffff8000001078a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001078a6:	48 01 d0             	add    %rdx,%rax
ffff8000001078a9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  for(; i < 10; i++)
ffff8000001078b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001078b4:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff8000001078b8:	7e db                	jle    ffff800000107895 <getstackpcs+0x71>
}
ffff8000001078ba:	90                   	nop
ffff8000001078bb:	90                   	nop
ffff8000001078bc:	c9                   	leave
ffff8000001078bd:	c3                   	ret

ffff8000001078be <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
ffff8000001078be:	55                   	push   %rbp
ffff8000001078bf:	48 89 e5             	mov    %rsp,%rbp
ffff8000001078c2:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001078c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return lock->locked && lock->cpu == cpu;
ffff8000001078ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001078ce:	8b 00                	mov    (%rax),%eax
ffff8000001078d0:	85 c0                	test   %eax,%eax
ffff8000001078d2:	74 1f                	je     ffff8000001078f3 <holding+0x35>
ffff8000001078d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001078d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff8000001078dc:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff8000001078e3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001078e7:	48 39 c2             	cmp    %rax,%rdx
ffff8000001078ea:	75 07                	jne    ffff8000001078f3 <holding+0x35>
ffff8000001078ec:	b8 01 00 00 00       	mov    $0x1,%eax
ffff8000001078f1:	eb 05                	jmp    ffff8000001078f8 <holding+0x3a>
ffff8000001078f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001078f8:	c9                   	leave
ffff8000001078f9:	c3                   	ret

ffff8000001078fa <pushcli>:
// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.
void
pushcli(void)
{
ffff8000001078fa:	55                   	push   %rbp
ffff8000001078fb:	48 89 e5             	mov    %rsp,%rbp
ffff8000001078fe:	48 83 ec 10          	sub    $0x10,%rsp
  int eflags;

  eflags = readeflags();
ffff800000107902:	48 b8 5a 76 10 00 00 	movabs $0xffff80000010765a,%rax
ffff800000107909:	80 ff ff 
ffff80000010790c:	ff d0                	call   *%rax
ffff80000010790e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  cli();
ffff800000107911:	48 b8 6e 76 10 00 00 	movabs $0xffff80000010766e,%rax
ffff800000107918:	80 ff ff 
ffff80000010791b:	ff d0                	call   *%rax
  if(cpu->ncli == 0)
ffff80000010791d:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107924:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107928:	8b 40 14             	mov    0x14(%rax),%eax
ffff80000010792b:	85 c0                	test   %eax,%eax
ffff80000010792d:	75 17                	jne    ffff800000107946 <pushcli+0x4c>
    cpu->intena = eflags & FL_IF;
ffff80000010792f:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107936:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010793a:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010793d:	81 e2 00 02 00 00    	and    $0x200,%edx
ffff800000107943:	89 50 18             	mov    %edx,0x18(%rax)
  cpu->ncli += 1;
ffff800000107946:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff80000010794d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107951:	8b 50 14             	mov    0x14(%rax),%edx
ffff800000107954:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff80000010795b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010795f:	83 c2 01             	add    $0x1,%edx
ffff800000107962:	89 50 14             	mov    %edx,0x14(%rax)
}
ffff800000107965:	90                   	nop
ffff800000107966:	c9                   	leave
ffff800000107967:	c3                   	ret

ffff800000107968 <popcli>:

void
popcli(void)
{
ffff800000107968:	55                   	push   %rbp
ffff800000107969:	48 89 e5             	mov    %rsp,%rbp
  if(readeflags()&FL_IF)
ffff80000010796c:	48 b8 5a 76 10 00 00 	movabs $0xffff80000010765a,%rax
ffff800000107973:	80 ff ff 
ffff800000107976:	ff d0                	call   *%rax
ffff800000107978:	25 00 02 00 00       	and    $0x200,%eax
ffff80000010797d:	48 85 c0             	test   %rax,%rax
ffff800000107980:	74 19                	je     ffff80000010799b <popcli+0x33>
    panic("popcli - interruptible");
ffff800000107982:	48 b8 f8 ca 10 00 00 	movabs $0xffff80000010caf8,%rax
ffff800000107989:	80 ff ff 
ffff80000010798c:	48 89 c7             	mov    %rax,%rdi
ffff80000010798f:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000107996:	80 ff ff 
ffff800000107999:	ff d0                	call   *%rax
  if(--cpu->ncli < 0)
ffff80000010799b:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff8000001079a2:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001079a6:	8b 50 14             	mov    0x14(%rax),%edx
ffff8000001079a9:	83 ea 01             	sub    $0x1,%edx
ffff8000001079ac:	89 50 14             	mov    %edx,0x14(%rax)
ffff8000001079af:	8b 40 14             	mov    0x14(%rax),%eax
ffff8000001079b2:	85 c0                	test   %eax,%eax
ffff8000001079b4:	79 19                	jns    ffff8000001079cf <popcli+0x67>
    panic("popcli");
ffff8000001079b6:	48 b8 0f cb 10 00 00 	movabs $0xffff80000010cb0f,%rax
ffff8000001079bd:	80 ff ff 
ffff8000001079c0:	48 89 c7             	mov    %rax,%rdi
ffff8000001079c3:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001079ca:	80 ff ff 
ffff8000001079cd:	ff d0                	call   *%rax
  if(cpu->ncli == 0 && cpu->intena)
ffff8000001079cf:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff8000001079d6:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001079da:	8b 40 14             	mov    0x14(%rax),%eax
ffff8000001079dd:	85 c0                	test   %eax,%eax
ffff8000001079df:	75 1e                	jne    ffff8000001079ff <popcli+0x97>
ffff8000001079e1:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff8000001079e8:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001079ec:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001079ef:	85 c0                	test   %eax,%eax
ffff8000001079f1:	74 0c                	je     ffff8000001079ff <popcli+0x97>
    sti();
ffff8000001079f3:	48 b8 76 76 10 00 00 	movabs $0xffff800000107676,%rax
ffff8000001079fa:	80 ff ff 
ffff8000001079fd:	ff d0                	call   *%rax
}
ffff8000001079ff:	90                   	nop
ffff800000107a00:	5d                   	pop    %rbp
ffff800000107a01:	c3                   	ret

ffff800000107a02 <stosb>:
{
ffff800000107a02:	55                   	push   %rbp
ffff800000107a03:	48 89 e5             	mov    %rsp,%rbp
ffff800000107a06:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107a0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107a0e:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff800000107a11:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
ffff800000107a14:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000107a18:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff800000107a1b:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107a1e:	48 89 ce             	mov    %rcx,%rsi
ffff800000107a21:	48 89 f7             	mov    %rsi,%rdi
ffff800000107a24:	89 d1                	mov    %edx,%ecx
ffff800000107a26:	fc                   	cld
ffff800000107a27:	f3 aa                	rep stos %al,(%rdi)
ffff800000107a29:	89 ca                	mov    %ecx,%edx
ffff800000107a2b:	48 89 fe             	mov    %rdi,%rsi
ffff800000107a2e:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
ffff800000107a32:	89 55 f0             	mov    %edx,-0x10(%rbp)
}
ffff800000107a35:	90                   	nop
ffff800000107a36:	c9                   	leave
ffff800000107a37:	c3                   	ret

ffff800000107a38 <stosl>:
{
ffff800000107a38:	55                   	push   %rbp
ffff800000107a39:	48 89 e5             	mov    %rsp,%rbp
ffff800000107a3c:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107a40:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107a44:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff800000107a47:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosl" :
ffff800000107a4a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000107a4e:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff800000107a51:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107a54:	48 89 ce             	mov    %rcx,%rsi
ffff800000107a57:	48 89 f7             	mov    %rsi,%rdi
ffff800000107a5a:	89 d1                	mov    %edx,%ecx
ffff800000107a5c:	fc                   	cld
ffff800000107a5d:	f3 ab                	rep stos %eax,(%rdi)
ffff800000107a5f:	89 ca                	mov    %ecx,%edx
ffff800000107a61:	48 89 fe             	mov    %rdi,%rsi
ffff800000107a64:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
ffff800000107a68:	89 55 f0             	mov    %edx,-0x10(%rbp)
}
ffff800000107a6b:	90                   	nop
ffff800000107a6c:	c9                   	leave
ffff800000107a6d:	c3                   	ret

ffff800000107a6e <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint64 n)
{
ffff800000107a6e:	55                   	push   %rbp
ffff800000107a6f:	48 89 e5             	mov    %rsp,%rbp
ffff800000107a72:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107a76:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107a7a:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff800000107a7d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  if ((addr_t)dst%4 == 0 && n%4 == 0){
ffff800000107a81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a85:	83 e0 03             	and    $0x3,%eax
ffff800000107a88:	48 85 c0             	test   %rax,%rax
ffff800000107a8b:	75 53                	jne    ffff800000107ae0 <memset+0x72>
ffff800000107a8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107a91:	83 e0 03             	and    $0x3,%eax
ffff800000107a94:	48 85 c0             	test   %rax,%rax
ffff800000107a97:	75 47                	jne    ffff800000107ae0 <memset+0x72>
    c &= 0xFF;
ffff800000107a99:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
ffff800000107aa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107aa4:	48 c1 e8 02          	shr    $0x2,%rax
ffff800000107aa8:	89 c6                	mov    %eax,%esi
ffff800000107aaa:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107aad:	c1 e0 18             	shl    $0x18,%eax
ffff800000107ab0:	89 c2                	mov    %eax,%edx
ffff800000107ab2:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107ab5:	c1 e0 10             	shl    $0x10,%eax
ffff800000107ab8:	09 c2                	or     %eax,%edx
ffff800000107aba:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107abd:	c1 e0 08             	shl    $0x8,%eax
ffff800000107ac0:	09 d0                	or     %edx,%eax
ffff800000107ac2:	0b 45 f4             	or     -0xc(%rbp),%eax
ffff800000107ac5:	89 c1                	mov    %eax,%ecx
ffff800000107ac7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107acb:	89 f2                	mov    %esi,%edx
ffff800000107acd:	89 ce                	mov    %ecx,%esi
ffff800000107acf:	48 89 c7             	mov    %rax,%rdi
ffff800000107ad2:	48 b8 38 7a 10 00 00 	movabs $0xffff800000107a38,%rax
ffff800000107ad9:	80 ff ff 
ffff800000107adc:	ff d0                	call   *%rax
ffff800000107ade:	eb 1e                	jmp    ffff800000107afe <memset+0x90>
  } else
    stosb(dst, c, n);
ffff800000107ae0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107ae4:	89 c2                	mov    %eax,%edx
ffff800000107ae6:	8b 4d f4             	mov    -0xc(%rbp),%ecx
ffff800000107ae9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107aed:	89 ce                	mov    %ecx,%esi
ffff800000107aef:	48 89 c7             	mov    %rax,%rdi
ffff800000107af2:	48 b8 02 7a 10 00 00 	movabs $0xffff800000107a02,%rax
ffff800000107af9:	80 ff ff 
ffff800000107afc:	ff d0                	call   *%rax
  return dst;
ffff800000107afe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000107b02:	c9                   	leave
ffff800000107b03:	c3                   	ret

ffff800000107b04 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
ffff800000107b04:	55                   	push   %rbp
ffff800000107b05:	48 89 e5             	mov    %rsp,%rbp
ffff800000107b08:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000107b0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107b10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000107b14:	89 55 dc             	mov    %edx,-0x24(%rbp)
  const uchar *s1, *s2;

  s1 = v1;
ffff800000107b17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107b1b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  s2 = v2;
ffff800000107b1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107b23:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0){
ffff800000107b27:	eb 34                	jmp    ffff800000107b5d <memcmp+0x59>
    if(*s1 != *s2)
ffff800000107b29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107b2d:	0f b6 10             	movzbl (%rax),%edx
ffff800000107b30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107b34:	0f b6 00             	movzbl (%rax),%eax
ffff800000107b37:	38 c2                	cmp    %al,%dl
ffff800000107b39:	74 18                	je     ffff800000107b53 <memcmp+0x4f>
      return *s1 - *s2;
ffff800000107b3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107b3f:	0f b6 00             	movzbl (%rax),%eax
ffff800000107b42:	0f b6 d0             	movzbl %al,%edx
ffff800000107b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107b49:	0f b6 00             	movzbl (%rax),%eax
ffff800000107b4c:	0f b6 c0             	movzbl %al,%eax
ffff800000107b4f:	29 c2                	sub    %eax,%edx
ffff800000107b51:	eb 1c                	jmp    ffff800000107b6f <memcmp+0x6b>
    s1++, s2++;
ffff800000107b53:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000107b58:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(n-- > 0){
ffff800000107b5d:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107b60:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107b63:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107b66:	85 c0                	test   %eax,%eax
ffff800000107b68:	75 bf                	jne    ffff800000107b29 <memcmp+0x25>
  }

  return 0;
ffff800000107b6a:	ba 00 00 00 00       	mov    $0x0,%edx
}
ffff800000107b6f:	89 d0                	mov    %edx,%eax
ffff800000107b71:	c9                   	leave
ffff800000107b72:	c3                   	ret

ffff800000107b73 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
ffff800000107b73:	55                   	push   %rbp
ffff800000107b74:	48 89 e5             	mov    %rsp,%rbp
ffff800000107b77:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000107b7b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107b7f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000107b83:	89 55 dc             	mov    %edx,-0x24(%rbp)
  const char *s;
  char *d;

  s = src;
ffff800000107b86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107b8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  d = dst;
ffff800000107b8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107b92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(s < d && s + n > d){
ffff800000107b96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107b9a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff800000107b9e:	73 63                	jae    ffff800000107c03 <memmove+0x90>
ffff800000107ba0:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff800000107ba3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107ba7:	48 01 d0             	add    %rdx,%rax
ffff800000107baa:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000107bae:	73 53                	jae    ffff800000107c03 <memmove+0x90>
    s += n;
ffff800000107bb0:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107bb3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
    d += n;
ffff800000107bb7:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107bba:	48 01 45 f0          	add    %rax,-0x10(%rbp)
    while(n-- > 0)
ffff800000107bbe:	eb 17                	jmp    ffff800000107bd7 <memmove+0x64>
      *--d = *--s;
ffff800000107bc0:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
ffff800000107bc5:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
ffff800000107bca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107bce:	0f b6 10             	movzbl (%rax),%edx
ffff800000107bd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107bd5:	88 10                	mov    %dl,(%rax)
    while(n-- > 0)
ffff800000107bd7:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107bda:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107bdd:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107be0:	85 c0                	test   %eax,%eax
ffff800000107be2:	75 dc                	jne    ffff800000107bc0 <memmove+0x4d>
  if(s < d && s + n > d){
ffff800000107be4:	eb 2a                	jmp    ffff800000107c10 <memmove+0x9d>
  } else
    while(n-- > 0)
      *d++ = *s++;
ffff800000107be6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000107bea:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000107bee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000107bf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107bf6:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000107bfa:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
ffff800000107bfe:	0f b6 12             	movzbl (%rdx),%edx
ffff800000107c01:	88 10                	mov    %dl,(%rax)
    while(n-- > 0)
ffff800000107c03:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107c06:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107c09:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107c0c:	85 c0                	test   %eax,%eax
ffff800000107c0e:	75 d6                	jne    ffff800000107be6 <memmove+0x73>

  return dst;
ffff800000107c10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
ffff800000107c14:	c9                   	leave
ffff800000107c15:	c3                   	ret

ffff800000107c16 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
ffff800000107c16:	55                   	push   %rbp
ffff800000107c17:	48 89 e5             	mov    %rsp,%rbp
ffff800000107c1a:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107c1e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107c22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107c26:	89 55 ec             	mov    %edx,-0x14(%rbp)
  return memmove(dst, src, n);
ffff800000107c29:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000107c2c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff800000107c30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c34:	48 89 ce             	mov    %rcx,%rsi
ffff800000107c37:	48 89 c7             	mov    %rax,%rdi
ffff800000107c3a:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff800000107c41:	80 ff ff 
ffff800000107c44:	ff d0                	call   *%rax
}
ffff800000107c46:	c9                   	leave
ffff800000107c47:	c3                   	ret

ffff800000107c48 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
ffff800000107c48:	55                   	push   %rbp
ffff800000107c49:	48 89 e5             	mov    %rsp,%rbp
ffff800000107c4c:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107c50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107c54:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107c58:	89 55 ec             	mov    %edx,-0x14(%rbp)
  while(n > 0 && *p && *p == *q)
ffff800000107c5b:	eb 0e                	jmp    ffff800000107c6b <strncmp+0x23>
    n--, p++, q++;
ffff800000107c5d:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
ffff800000107c61:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000107c66:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(n > 0 && *p && *p == *q)
ffff800000107c6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff800000107c6f:	74 1d                	je     ffff800000107c8e <strncmp+0x46>
ffff800000107c71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c75:	0f b6 00             	movzbl (%rax),%eax
ffff800000107c78:	84 c0                	test   %al,%al
ffff800000107c7a:	74 12                	je     ffff800000107c8e <strncmp+0x46>
ffff800000107c7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c80:	0f b6 10             	movzbl (%rax),%edx
ffff800000107c83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107c87:	0f b6 00             	movzbl (%rax),%eax
ffff800000107c8a:	38 c2                	cmp    %al,%dl
ffff800000107c8c:	74 cf                	je     ffff800000107c5d <strncmp+0x15>
  if(n == 0)
ffff800000107c8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff800000107c92:	75 07                	jne    ffff800000107c9b <strncmp+0x53>
    return 0;
ffff800000107c94:	ba 00 00 00 00       	mov    $0x0,%edx
ffff800000107c99:	eb 16                	jmp    ffff800000107cb1 <strncmp+0x69>
  return (uchar)*p - (uchar)*q;
ffff800000107c9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c9f:	0f b6 00             	movzbl (%rax),%eax
ffff800000107ca2:	0f b6 d0             	movzbl %al,%edx
ffff800000107ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107ca9:	0f b6 00             	movzbl (%rax),%eax
ffff800000107cac:	0f b6 c0             	movzbl %al,%eax
ffff800000107caf:	29 c2                	sub    %eax,%edx
}
ffff800000107cb1:	89 d0                	mov    %edx,%eax
ffff800000107cb3:	c9                   	leave
ffff800000107cb4:	c3                   	ret

ffff800000107cb5 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
ffff800000107cb5:	55                   	push   %rbp
ffff800000107cb6:	48 89 e5             	mov    %rsp,%rbp
ffff800000107cb9:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000107cbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107cc1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000107cc5:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *os = s;
ffff800000107cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107ccc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(n-- > 0 && (*s++ = *t++) != 0)
ffff800000107cd0:	90                   	nop
ffff800000107cd1:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107cd4:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107cd7:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107cda:	85 c0                	test   %eax,%eax
ffff800000107cdc:	7e 35                	jle    ffff800000107d13 <strncpy+0x5e>
ffff800000107cde:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000107ce2:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000107ce6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff800000107cea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107cee:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000107cf2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
ffff800000107cf6:	0f b6 12             	movzbl (%rdx),%edx
ffff800000107cf9:	88 10                	mov    %dl,(%rax)
ffff800000107cfb:	0f b6 00             	movzbl (%rax),%eax
ffff800000107cfe:	84 c0                	test   %al,%al
ffff800000107d00:	75 cf                	jne    ffff800000107cd1 <strncpy+0x1c>
    ;
  while(n-- > 0)
ffff800000107d02:	eb 0f                	jmp    ffff800000107d13 <strncpy+0x5e>
    *s++ = 0;
ffff800000107d04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107d08:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000107d0c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffff800000107d10:	c6 00 00             	movb   $0x0,(%rax)
  while(n-- > 0)
ffff800000107d13:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107d16:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107d19:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107d1c:	85 c0                	test   %eax,%eax
ffff800000107d1e:	7f e4                	jg     ffff800000107d04 <strncpy+0x4f>
  return os;
ffff800000107d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000107d24:	c9                   	leave
ffff800000107d25:	c3                   	ret

ffff800000107d26 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
ffff800000107d26:	55                   	push   %rbp
ffff800000107d27:	48 89 e5             	mov    %rsp,%rbp
ffff800000107d2a:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000107d2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107d32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000107d36:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *os = s;
ffff800000107d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107d3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(n <= 0)
ffff800000107d41:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000107d45:	7f 06                	jg     ffff800000107d4d <safestrcpy+0x27>
    return os;
ffff800000107d47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d4b:	eb 3a                	jmp    ffff800000107d87 <safestrcpy+0x61>
  while(--n > 0 && (*s++ = *t++) != 0)
ffff800000107d4d:	90                   	nop
ffff800000107d4e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
ffff800000107d52:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000107d56:	7e 24                	jle    ffff800000107d7c <safestrcpy+0x56>
ffff800000107d58:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000107d5c:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000107d60:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff800000107d64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107d68:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000107d6c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
ffff800000107d70:	0f b6 12             	movzbl (%rdx),%edx
ffff800000107d73:	88 10                	mov    %dl,(%rax)
ffff800000107d75:	0f b6 00             	movzbl (%rax),%eax
ffff800000107d78:	84 c0                	test   %al,%al
ffff800000107d7a:	75 d2                	jne    ffff800000107d4e <safestrcpy+0x28>
    ;
  *s = 0;
ffff800000107d7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107d80:	c6 00 00             	movb   $0x0,(%rax)
  return os;
ffff800000107d83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000107d87:	c9                   	leave
ffff800000107d88:	c3                   	ret

ffff800000107d89 <strlen>:

int
strlen(const char *s)
{
ffff800000107d89:	55                   	push   %rbp
ffff800000107d8a:	48 89 e5             	mov    %rsp,%rbp
ffff800000107d8d:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107d91:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
ffff800000107d95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000107d9c:	eb 04                	jmp    ffff800000107da2 <strlen+0x19>
ffff800000107d9e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000107da2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107da5:	48 63 d0             	movslq %eax,%rdx
ffff800000107da8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107dac:	48 01 d0             	add    %rdx,%rax
ffff800000107daf:	0f b6 00             	movzbl (%rax),%eax
ffff800000107db2:	84 c0                	test   %al,%al
ffff800000107db4:	75 e8                	jne    ffff800000107d9e <strlen+0x15>
    ;
  return n;
ffff800000107db6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000107db9:	c9                   	leave
ffff800000107dba:	c3                   	ret

ffff800000107dbb <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
ffff800000107dbb:	55                   	push   %rbp
  pushq   %rbx
ffff800000107dbc:	53                   	push   %rbx
  pushq   %r12
ffff800000107dbd:	41 54                	push   %r12
  pushq   %r13
ffff800000107dbf:	41 55                	push   %r13
  pushq   %r14
ffff800000107dc1:	41 56                	push   %r14
  pushq   %r15
ffff800000107dc3:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
ffff800000107dc5:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
ffff800000107dc8:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
ffff800000107dcb:	41 5f                	pop    %r15
  popq    %r14
ffff800000107dcd:	41 5e                	pop    %r14
  popq    %r13
ffff800000107dcf:	41 5d                	pop    %r13
  popq    %r12
ffff800000107dd1:	41 5c                	pop    %r12
  popq    %rbx
ffff800000107dd3:	5b                   	pop    %rbx
  popq    %rbp
ffff800000107dd4:	5d                   	pop    %rbp

  retq #??
ffff800000107dd5:	c3                   	ret

ffff800000107dd6 <fetchint>:
#include "trace.h"

// Fetch the int at addr from the current process.
int
fetchint(addr_t addr, int *ip)
{
ffff800000107dd6:	55                   	push   %rbp
ffff800000107dd7:	48 89 e5             	mov    %rsp,%rbp
ffff800000107dda:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107dde:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107de2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(addr < PGSIZE || addr >= proc->sz || addr+sizeof(int) > proc->sz)
ffff800000107de6:	48 81 7d f8 ff 0f 00 	cmpq   $0xfff,-0x8(%rbp)
ffff800000107ded:	00 
ffff800000107dee:	76 2f                	jbe    ffff800000107e1f <fetchint+0x49>
ffff800000107df0:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107df7:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107dfb:	48 8b 00             	mov    (%rax),%rax
ffff800000107dfe:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000107e02:	73 1b                	jae    ffff800000107e1f <fetchint+0x49>
ffff800000107e04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107e08:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff800000107e0c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107e13:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107e17:	48 8b 00             	mov    (%rax),%rax
ffff800000107e1a:	48 39 d0             	cmp    %rdx,%rax
ffff800000107e1d:	73 07                	jae    ffff800000107e26 <fetchint+0x50>
    return -1;
ffff800000107e1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107e24:	eb 11                	jmp    ffff800000107e37 <fetchint+0x61>
  *ip = *(int*)(addr);
ffff800000107e26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107e2a:	8b 10                	mov    (%rax),%edx
ffff800000107e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107e30:	89 10                	mov    %edx,(%rax)
  return 0;
ffff800000107e32:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000107e37:	c9                   	leave
ffff800000107e38:	c3                   	ret

ffff800000107e39 <fetchaddr>:

int
fetchaddr(addr_t addr, addr_t *ip)
{
ffff800000107e39:	55                   	push   %rbp
ffff800000107e3a:	48 89 e5             	mov    %rsp,%rbp
ffff800000107e3d:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107e41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107e45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(addr < PGSIZE || addr >= proc->sz || addr+sizeof(addr_t) > proc->sz)
ffff800000107e49:	48 81 7d f8 ff 0f 00 	cmpq   $0xfff,-0x8(%rbp)
ffff800000107e50:	00 
ffff800000107e51:	76 2f                	jbe    ffff800000107e82 <fetchaddr+0x49>
ffff800000107e53:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107e5a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107e5e:	48 8b 00             	mov    (%rax),%rax
ffff800000107e61:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000107e65:	73 1b                	jae    ffff800000107e82 <fetchaddr+0x49>
ffff800000107e67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107e6b:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000107e6f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107e76:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107e7a:	48 8b 00             	mov    (%rax),%rax
ffff800000107e7d:	48 39 d0             	cmp    %rdx,%rax
ffff800000107e80:	73 07                	jae    ffff800000107e89 <fetchaddr+0x50>
    return -1;
ffff800000107e82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107e87:	eb 13                	jmp    ffff800000107e9c <fetchaddr+0x63>
  *ip = *(addr_t*)(addr);
ffff800000107e89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107e8d:	48 8b 10             	mov    (%rax),%rdx
ffff800000107e90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107e94:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff800000107e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000107e9c:	c9                   	leave
ffff800000107e9d:	c3                   	ret

ffff800000107e9e <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(addr_t addr, char **pp)
{
ffff800000107e9e:	55                   	push   %rbp
ffff800000107e9f:	48 89 e5             	mov    %rsp,%rbp
ffff800000107ea2:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107ea6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107eaa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *s, *ep;

  if(addr < PGSIZE || addr >= proc->sz)
ffff800000107eae:	48 81 7d e8 ff 0f 00 	cmpq   $0xfff,-0x18(%rbp)
ffff800000107eb5:	00 
ffff800000107eb6:	76 14                	jbe    ffff800000107ecc <fetchstr+0x2e>
ffff800000107eb8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107ebf:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107ec3:	48 8b 00             	mov    (%rax),%rax
ffff800000107ec6:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000107eca:	72 07                	jb     ffff800000107ed3 <fetchstr+0x35>
    return -1;
ffff800000107ecc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107ed1:	eb 5b                	jmp    ffff800000107f2e <fetchstr+0x90>
  *pp = (char*)addr;
ffff800000107ed3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000107ed7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107edb:	48 89 10             	mov    %rdx,(%rax)
  ep = (char*)proc->sz;
ffff800000107ede:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107ee5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107ee9:	48 8b 00             	mov    (%rax),%rax
ffff800000107eec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(s = *pp; s < ep; s++)
ffff800000107ef0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107ef4:	48 8b 00             	mov    (%rax),%rax
ffff800000107ef7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000107efb:	eb 22                	jmp    ffff800000107f1f <fetchstr+0x81>
    if(*s == 0)
ffff800000107efd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107f01:	0f b6 00             	movzbl (%rax),%eax
ffff800000107f04:	84 c0                	test   %al,%al
ffff800000107f06:	75 12                	jne    ffff800000107f1a <fetchstr+0x7c>
      return s - *pp;
ffff800000107f08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107f0c:	48 8b 00             	mov    (%rax),%rax
ffff800000107f0f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000107f13:	48 29 c2             	sub    %rax,%rdx
ffff800000107f16:	89 d0                	mov    %edx,%eax
ffff800000107f18:	eb 14                	jmp    ffff800000107f2e <fetchstr+0x90>
  for(s = *pp; s < ep; s++)
ffff800000107f1a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000107f1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107f23:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff800000107f27:	72 d4                	jb     ffff800000107efd <fetchstr+0x5f>
  return -1;
ffff800000107f29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000107f2e:	c9                   	leave
ffff800000107f2f:	c3                   	ret

ffff800000107f30 <fetcharg>:

static addr_t
fetcharg(int n)
{
ffff800000107f30:	55                   	push   %rbp
ffff800000107f31:	48 89 e5             	mov    %rsp,%rbp
ffff800000107f34:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107f38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  switch (n) {
ffff800000107f3b:	83 7d fc 05          	cmpl   $0x5,-0x4(%rbp)
ffff800000107f3f:	0f 84 bb 00 00 00    	je     ffff800000108000 <fetcharg+0xd0>
ffff800000107f45:	83 7d fc 05          	cmpl   $0x5,-0x4(%rbp)
ffff800000107f49:	0f 8f c6 00 00 00    	jg     ffff800000108015 <fetcharg+0xe5>
ffff800000107f4f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
ffff800000107f53:	0f 84 92 00 00 00    	je     ffff800000107feb <fetcharg+0xbb>
ffff800000107f59:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
ffff800000107f5d:	0f 8f b2 00 00 00    	jg     ffff800000108015 <fetcharg+0xe5>
ffff800000107f63:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
ffff800000107f67:	74 6d                	je     ffff800000107fd6 <fetcharg+0xa6>
ffff800000107f69:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
ffff800000107f6d:	0f 8f a2 00 00 00    	jg     ffff800000108015 <fetcharg+0xe5>
ffff800000107f73:	83 7d fc 02          	cmpl   $0x2,-0x4(%rbp)
ffff800000107f77:	74 48                	je     ffff800000107fc1 <fetcharg+0x91>
ffff800000107f79:	83 7d fc 02          	cmpl   $0x2,-0x4(%rbp)
ffff800000107f7d:	0f 8f 92 00 00 00    	jg     ffff800000108015 <fetcharg+0xe5>
ffff800000107f83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000107f87:	74 0b                	je     ffff800000107f94 <fetcharg+0x64>
ffff800000107f89:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff800000107f8d:	74 1d                	je     ffff800000107fac <fetcharg+0x7c>
ffff800000107f8f:	e9 81 00 00 00       	jmp    ffff800000108015 <fetcharg+0xe5>
  case 0: return proc->tf->rdi;
ffff800000107f94:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107f9b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107f9f:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107fa3:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000107fa7:	e9 82 00 00 00       	jmp    ffff80000010802e <fetcharg+0xfe>
  case 1: return proc->tf->rsi;
ffff800000107fac:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107fb3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107fb7:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107fbb:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107fbf:	eb 6d                	jmp    ffff80000010802e <fetcharg+0xfe>
  case 2: return proc->tf->rdx;
ffff800000107fc1:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107fc8:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107fcc:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107fd0:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000107fd4:	eb 58                	jmp    ffff80000010802e <fetcharg+0xfe>
  case 3: return proc->tf->r10;
ffff800000107fd6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107fdd:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107fe1:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107fe5:	48 8b 40 48          	mov    0x48(%rax),%rax
ffff800000107fe9:	eb 43                	jmp    ffff80000010802e <fetcharg+0xfe>
  case 4: return proc->tf->r8;
ffff800000107feb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107ff2:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107ff6:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107ffa:	48 8b 40 38          	mov    0x38(%rax),%rax
ffff800000107ffe:	eb 2e                	jmp    ffff80000010802e <fetcharg+0xfe>
  case 5: return proc->tf->r9;
ffff800000108000:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108007:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010800b:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010800f:	48 8b 40 40          	mov    0x40(%rax),%rax
ffff800000108013:	eb 19                	jmp    ffff80000010802e <fetcharg+0xfe>
  }
  panic("failed fetch");
ffff800000108015:	48 b8 16 cb 10 00 00 	movabs $0xffff80000010cb16,%rax
ffff80000010801c:	80 ff ff 
ffff80000010801f:	48 89 c7             	mov    %rax,%rdi
ffff800000108022:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000108029:	80 ff ff 
ffff80000010802c:	ff d0                	call   *%rax
}
ffff80000010802e:	c9                   	leave
ffff80000010802f:	c3                   	ret

ffff800000108030 <argint>:

int
argint(int n, int *ip)
{
ffff800000108030:	55                   	push   %rbp
ffff800000108031:	48 89 e5             	mov    %rsp,%rbp
ffff800000108034:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000108038:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff80000010803b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  *ip = fetcharg(n);
ffff80000010803f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108042:	89 c7                	mov    %eax,%edi
ffff800000108044:	48 b8 30 7f 10 00 00 	movabs $0xffff800000107f30,%rax
ffff80000010804b:	80 ff ff 
ffff80000010804e:	ff d0                	call   *%rax
ffff800000108050:	89 c2                	mov    %eax,%edx
ffff800000108052:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108056:	89 10                	mov    %edx,(%rax)
  return 0;
ffff800000108058:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010805d:	c9                   	leave
ffff80000010805e:	c3                   	ret

ffff80000010805f <argaddr>:

addr_t
argaddr(int n, addr_t *ip)
{
ffff80000010805f:	55                   	push   %rbp
ffff800000108060:	48 89 e5             	mov    %rsp,%rbp
ffff800000108063:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000108067:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff80000010806a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  *ip = fetcharg(n);
ffff80000010806e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108071:	89 c7                	mov    %eax,%edi
ffff800000108073:	48 b8 30 7f 10 00 00 	movabs $0xffff800000107f30,%rax
ffff80000010807a:	80 ff ff 
ffff80000010807d:	ff d0                	call   *%rax
ffff80000010807f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000108083:	48 89 02             	mov    %rax,(%rdx)
  return 0;
ffff800000108086:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010808b:	c9                   	leave
ffff80000010808c:	c3                   	ret

ffff80000010808d <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
addr_t
argptr(int n, char **pp, int size)
{
ffff80000010808d:	55                   	push   %rbp
ffff80000010808e:	48 89 e5             	mov    %rsp,%rbp
ffff800000108091:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000108095:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000108098:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010809c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  addr_t i;

  if(argaddr(n, &i) < 0)
ffff80000010809f:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
ffff8000001080a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001080a6:	48 89 d6             	mov    %rdx,%rsi
ffff8000001080a9:	89 c7                	mov    %eax,%edi
ffff8000001080ab:	48 b8 5f 80 10 00 00 	movabs $0xffff80000010805f,%rax
ffff8000001080b2:	80 ff ff 
ffff8000001080b5:	ff d0                	call   *%rax
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
ffff8000001080b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
ffff8000001080bb:	78 39                	js     ffff8000001080f6 <argptr+0x69>
ffff8000001080bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001080c1:	89 c2                	mov    %eax,%edx
ffff8000001080c3:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001080ca:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001080ce:	48 8b 00             	mov    (%rax),%rax
ffff8000001080d1:	48 39 c2             	cmp    %rax,%rdx
ffff8000001080d4:	73 20                	jae    ffff8000001080f6 <argptr+0x69>
ffff8000001080d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001080da:	89 c2                	mov    %eax,%edx
ffff8000001080dc:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff8000001080df:	01 d0                	add    %edx,%eax
ffff8000001080e1:	89 c2                	mov    %eax,%edx
ffff8000001080e3:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001080ea:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001080ee:	48 8b 00             	mov    (%rax),%rax
ffff8000001080f1:	48 39 d0             	cmp    %rdx,%rax
ffff8000001080f4:	73 09                	jae    ffff8000001080ff <argptr+0x72>
    return -1;
ffff8000001080f6:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
ffff8000001080fd:	eb 13                	jmp    ffff800000108112 <argptr+0x85>
  *pp = (char*)i;
ffff8000001080ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108103:	48 89 c2             	mov    %rax,%rdx
ffff800000108106:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010810a:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff80000010810d:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108112:	c9                   	leave
ffff800000108113:	c3                   	ret

ffff800000108114 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
ffff800000108114:	55                   	push   %rbp
ffff800000108115:	48 89 e5             	mov    %rsp,%rbp
ffff800000108118:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010811c:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010811f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int addr;
  if(argint(n, &addr) < 0)
ffff800000108123:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
ffff800000108127:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010812a:	48 89 d6             	mov    %rdx,%rsi
ffff80000010812d:	89 c7                	mov    %eax,%edi
ffff80000010812f:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff800000108136:	80 ff ff 
ffff800000108139:	ff d0                	call   *%rax
ffff80000010813b:	85 c0                	test   %eax,%eax
ffff80000010813d:	79 07                	jns    ffff800000108146 <argstr+0x32>
    return -1;
ffff80000010813f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108144:	eb 1b                	jmp    ffff800000108161 <argstr+0x4d>
  return fetchstr(addr, pp);
ffff800000108146:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108149:	48 98                	cltq
ffff80000010814b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010814f:	48 89 d6             	mov    %rdx,%rsi
ffff800000108152:	48 89 c7             	mov    %rax,%rdi
ffff800000108155:	48 b8 9e 7e 10 00 00 	movabs $0xffff800000107e9e,%rax
ffff80000010815c:	80 ff ff 
ffff80000010815f:	ff d0                	call   *%rax
}
ffff800000108161:	c9                   	leave
ffff800000108162:	c3                   	ret

ffff800000108163 <syscall>:
  [SYS_vidputs] "vidputs",
};

void
syscall(struct trapframe *tf)
{
ffff800000108163:	55                   	push   %rbp
ffff800000108164:	48 89 e5             	mov    %rsp,%rbp
ffff800000108167:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010816b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  proc->tf = tf;
ffff80000010816f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108176:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010817a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010817e:	48 89 50 28          	mov    %rdx,0x28(%rax)
  uint64 num = proc->tf->rax;
ffff800000108182:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108189:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010818d:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000108191:	48 8b 00             	mov    (%rax),%rax
ffff800000108194:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  uint start_ticks, end_ticks, latency;

  


  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
ffff800000108198:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010819d:	0f 84 06 01 00 00    	je     ffff8000001082a9 <syscall+0x146>
ffff8000001081a3:	48 83 7d f8 19       	cmpq   $0x19,-0x8(%rbp)
ffff8000001081a8:	0f 87 fb 00 00 00    	ja     ffff8000001082a9 <syscall+0x146>
ffff8000001081ae:	48 ba a0 d5 10 00 00 	movabs $0xffff80000010d5a0,%rdx
ffff8000001081b5:	80 ff ff 
ffff8000001081b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001081bc:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffff8000001081c0:	48 85 c0             	test   %rax,%rax
ffff8000001081c3:	0f 84 e0 00 00 00    	je     ffff8000001082a9 <syscall+0x146>
    start_ticks = ticks;
ffff8000001081c9:	48 b8 48 bd 11 00 00 	movabs $0xffff80000011bd48,%rax
ffff8000001081d0:	80 ff ff 
ffff8000001081d3:	8b 00                	mov    (%rax),%eax
ffff8000001081d5:	89 45 f4             	mov    %eax,-0xc(%rbp)
    tf->rax = syscalls[num]();
ffff8000001081d8:	48 ba a0 d5 10 00 00 	movabs $0xffff80000010d5a0,%rdx
ffff8000001081df:	80 ff ff 
ffff8000001081e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001081e6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffff8000001081ea:	ff d0                	call   *%rax
ffff8000001081ec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff8000001081f0:	48 89 02             	mov    %rax,(%rdx)
    end_ticks = ticks;
ffff8000001081f3:	48 b8 48 bd 11 00 00 	movabs $0xffff80000011bd48,%rax
ffff8000001081fa:	80 ff ff 
ffff8000001081fd:	8b 00                	mov    (%rax),%eax
ffff8000001081ff:	89 45 f0             	mov    %eax,-0x10(%rbp)
    latency = end_ticks - start_ticks;
ffff800000108202:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000108205:	2b 45 f4             	sub    -0xc(%rbp),%eax
ffff800000108208:	89 45 ec             	mov    %eax,-0x14(%rbp)

    //call trace event function 
    if(num != SYS_traceread && num != SYS_vidclear && num != SYS_vidputc && num != SYS_vidputs &&
ffff80000010820b:	48 83 7d f8 16       	cmpq   $0x16,-0x8(%rbp)
ffff800000108210:	0f 84 e8 00 00 00    	je     ffff8000001082fe <syscall+0x19b>
ffff800000108216:	48 83 7d f8 17       	cmpq   $0x17,-0x8(%rbp)
ffff80000010821b:	0f 84 dd 00 00 00    	je     ffff8000001082fe <syscall+0x19b>
ffff800000108221:	48 83 7d f8 18       	cmpq   $0x18,-0x8(%rbp)
ffff800000108226:	0f 84 d2 00 00 00    	je     ffff8000001082fe <syscall+0x19b>
ffff80000010822c:	48 83 7d f8 19       	cmpq   $0x19,-0x8(%rbp)
ffff800000108231:	0f 84 c7 00 00 00    	je     ffff8000001082fe <syscall+0x19b>
ffff800000108237:	48 83 7d f8 0d       	cmpq   $0xd,-0x8(%rbp)
ffff80000010823c:	0f 84 bc 00 00 00    	je     ffff8000001082fe <syscall+0x19b>
       num != SYS_sleep && num != SYS_getpid && num != SYS_uptime)
ffff800000108242:	48 83 7d f8 0b       	cmpq   $0xb,-0x8(%rbp)
ffff800000108247:	0f 84 b1 00 00 00    	je     ffff8000001082fe <syscall+0x19b>
ffff80000010824d:	48 83 7d f8 0e       	cmpq   $0xe,-0x8(%rbp)
ffff800000108252:	0f 84 a6 00 00 00    	je     ffff8000001082fe <syscall+0x19b>
      traceevent(TRACE_TYPE_SYSCALL, proc->pid, num, tf->rax, latency, syscallnames[num]);
ffff800000108258:	48 ba 80 d6 10 00 00 	movabs $0xffff80000010d680,%rdx
ffff80000010825f:	80 ff ff 
ffff800000108262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108266:	48 8b 0c c2          	mov    (%rdx,%rax,8),%rcx
ffff80000010826a:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff80000010826d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108271:	48 8b 00             	mov    (%rax),%rax
ffff800000108274:	89 c7                	mov    %eax,%edi
ffff800000108276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010827a:	89 c6                	mov    %eax,%esi
ffff80000010827c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108283:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108287:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff80000010828a:	49 89 c9             	mov    %rcx,%r9
ffff80000010828d:	41 89 d0             	mov    %edx,%r8d
ffff800000108290:	89 f9                	mov    %edi,%ecx
ffff800000108292:	89 f2                	mov    %esi,%edx
ffff800000108294:	89 c6                	mov    %eax,%esi
ffff800000108296:	bf 01 00 00 00       	mov    $0x1,%edi
ffff80000010829b:	48 b8 d3 c2 10 00 00 	movabs $0xffff80000010c2d3,%rax
ffff8000001082a2:	80 ff ff 
ffff8000001082a5:	ff d0                	call   *%rax
    if(num != SYS_traceread && num != SYS_vidclear && num != SYS_vidputc && num != SYS_vidputs &&
ffff8000001082a7:	eb 55                	jmp    ffff8000001082fe <syscall+0x19b>

    // DEBUG: Print the PID, system call number, and the return value from the syscall
    // cprintf("trace: pid %d syscall %s(%d) -> %d\n", proc->pid, syscallnames[num], num, tf->rax);
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
ffff8000001082a9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001082b0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001082b4:	48 8d b0 d0 00 00 00 	lea    0xd0(%rax),%rsi
ffff8000001082bb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001082c2:	64 48 8b 00          	mov    %fs:(%rax),%rax
    cprintf("%d %s: unknown sys call %d\n",
ffff8000001082c6:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff8000001082c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001082cd:	48 bf bb cb 10 00 00 	movabs $0xffff80000010cbbb,%rdi
ffff8000001082d4:	80 ff ff 
ffff8000001082d7:	48 89 d1             	mov    %rdx,%rcx
ffff8000001082da:	48 89 f2             	mov    %rsi,%rdx
ffff8000001082dd:	89 c6                	mov    %eax,%esi
ffff8000001082df:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001082e4:	49 b8 04 08 10 00 00 	movabs $0xffff800000100804,%r8
ffff8000001082eb:	80 ff ff 
ffff8000001082ee:	41 ff d0             	call   *%r8
    tf->rax = -1;
ffff8000001082f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001082f5:	48 c7 00 ff ff ff ff 	movq   $0xffffffffffffffff,(%rax)
ffff8000001082fc:	eb 01                	jmp    ffff8000001082ff <syscall+0x19c>
    if(num != SYS_traceread && num != SYS_vidclear && num != SYS_vidputc && num != SYS_vidputs &&
ffff8000001082fe:	90                   	nop
  }
  if (proc->killed)
ffff8000001082ff:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108306:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010830a:	8b 40 40             	mov    0x40(%rax),%eax
ffff80000010830d:	85 c0                	test   %eax,%eax
ffff80000010830f:	74 0c                	je     ffff80000010831d <syscall+0x1ba>
    exit();
ffff800000108311:	48 b8 15 6a 10 00 00 	movabs $0xffff800000106a15,%rax
ffff800000108318:	80 ff ff 
ffff80000010831b:	ff d0                	call   *%rax
}
ffff80000010831d:	90                   	nop
ffff80000010831e:	c9                   	leave
ffff80000010831f:	c3                   	ret

ffff800000108320 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
ffff800000108320:	55                   	push   %rbp
ffff800000108321:	48 89 e5             	mov    %rsp,%rbp
ffff800000108324:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000108328:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010832b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010832f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
ffff800000108333:	48 8d 55 f4          	lea    -0xc(%rbp),%rdx
ffff800000108337:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010833a:	48 89 d6             	mov    %rdx,%rsi
ffff80000010833d:	89 c7                	mov    %eax,%edi
ffff80000010833f:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff800000108346:	80 ff ff 
ffff800000108349:	ff d0                	call   *%rax
ffff80000010834b:	85 c0                	test   %eax,%eax
ffff80000010834d:	79 07                	jns    ffff800000108356 <argfd+0x36>
    return -1;
ffff80000010834f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108354:	eb 62                	jmp    ffff8000001083b8 <argfd+0x98>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
ffff800000108356:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000108359:	85 c0                	test   %eax,%eax
ffff80000010835b:	78 2d                	js     ffff80000010838a <argfd+0x6a>
ffff80000010835d:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000108360:	83 f8 0f             	cmp    $0xf,%eax
ffff800000108363:	7f 25                	jg     ffff80000010838a <argfd+0x6a>
ffff800000108365:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010836c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108370:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108373:	48 63 d2             	movslq %edx,%rdx
ffff800000108376:	48 83 c2 08          	add    $0x8,%rdx
ffff80000010837a:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010837f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108383:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108388:	75 07                	jne    ffff800000108391 <argfd+0x71>
    return -1;
ffff80000010838a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010838f:	eb 27                	jmp    ffff8000001083b8 <argfd+0x98>
  if(pfd)
ffff800000108391:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff800000108396:	74 09                	je     ffff8000001083a1 <argfd+0x81>
    *pfd = fd;
ffff800000108398:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff80000010839b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010839f:	89 10                	mov    %edx,(%rax)
  if(pf)
ffff8000001083a1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff8000001083a6:	74 0b                	je     ffff8000001083b3 <argfd+0x93>
    *pf = f;
ffff8000001083a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001083ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001083b0:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff8000001083b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001083b8:	c9                   	leave
ffff8000001083b9:	c3                   	ret

ffff8000001083ba <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
ffff8000001083ba:	55                   	push   %rbp
ffff8000001083bb:	48 89 e5             	mov    %rsp,%rbp
ffff8000001083be:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001083c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
ffff8000001083c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001083cd:	eb 46                	jmp    ffff800000108415 <fdalloc+0x5b>
    if(proc->ofile[fd] == 0){
ffff8000001083cf:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001083d6:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001083da:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001083dd:	48 63 d2             	movslq %edx,%rdx
ffff8000001083e0:	48 83 c2 08          	add    $0x8,%rdx
ffff8000001083e4:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff8000001083e9:	48 85 c0             	test   %rax,%rax
ffff8000001083ec:	75 23                	jne    ffff800000108411 <fdalloc+0x57>
      proc->ofile[fd] = f;
ffff8000001083ee:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001083f5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001083f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001083fc:	48 63 d2             	movslq %edx,%rdx
ffff8000001083ff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
ffff800000108403:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000108407:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
      return fd;
ffff80000010840c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010840f:	eb 0f                	jmp    ffff800000108420 <fdalloc+0x66>
  for(fd = 0; fd < NOFILE; fd++){
ffff800000108411:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000108415:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
ffff800000108419:	7e b4                	jle    ffff8000001083cf <fdalloc+0x15>
    }
  }
  return -1;
ffff80000010841b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108420:	c9                   	leave
ffff800000108421:	c3                   	ret

ffff800000108422 <sys_dup>:

int
sys_dup(void)
{
ffff800000108422:	55                   	push   %rbp
ffff800000108423:	48 89 e5             	mov    %rsp,%rbp
ffff800000108426:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
ffff80000010842a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff80000010842e:	48 89 c2             	mov    %rax,%rdx
ffff800000108431:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108436:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010843b:	48 b8 20 83 10 00 00 	movabs $0xffff800000108320,%rax
ffff800000108442:	80 ff ff 
ffff800000108445:	ff d0                	call   *%rax
ffff800000108447:	85 c0                	test   %eax,%eax
ffff800000108449:	79 07                	jns    ffff800000108452 <sys_dup+0x30>
    return -1;
ffff80000010844b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108450:	eb 39                	jmp    ffff80000010848b <sys_dup+0x69>
  if((fd=fdalloc(f)) < 0)
ffff800000108452:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108456:	48 89 c7             	mov    %rax,%rdi
ffff800000108459:	48 b8 ba 83 10 00 00 	movabs $0xffff8000001083ba,%rax
ffff800000108460:	80 ff ff 
ffff800000108463:	ff d0                	call   *%rax
ffff800000108465:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000108468:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff80000010846c:	79 07                	jns    ffff800000108475 <sys_dup+0x53>
    return -1;
ffff80000010846e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108473:	eb 16                	jmp    ffff80000010848b <sys_dup+0x69>
  filedup(f);
ffff800000108475:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108479:	48 89 c7             	mov    %rax,%rdi
ffff80000010847c:	48 b8 0d 1d 10 00 00 	movabs $0xffff800000101d0d,%rax
ffff800000108483:	80 ff ff 
ffff800000108486:	ff d0                	call   *%rax
  return fd;
ffff800000108488:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff80000010848b:	c9                   	leave
ffff80000010848c:	c3                   	ret

ffff80000010848d <sys_read>:

int
sys_read(void)
{
ffff80000010848d:	55                   	push   %rbp
ffff80000010848e:	48 89 e5             	mov    %rsp,%rbp
ffff800000108491:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
ffff800000108495:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000108499:	48 89 c2             	mov    %rax,%rdx
ffff80000010849c:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001084a1:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001084a6:	48 b8 20 83 10 00 00 	movabs $0xffff800000108320,%rax
ffff8000001084ad:	80 ff ff 
ffff8000001084b0:	ff d0                	call   *%rax
ffff8000001084b2:	85 c0                	test   %eax,%eax
ffff8000001084b4:	78 56                	js     ffff80000010850c <sys_read+0x7f>
ffff8000001084b6:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff8000001084ba:	48 89 c6             	mov    %rax,%rsi
ffff8000001084bd:	bf 02 00 00 00       	mov    $0x2,%edi
ffff8000001084c2:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff8000001084c9:	80 ff ff 
ffff8000001084cc:	ff d0                	call   *%rax
ffff8000001084ce:	85 c0                	test   %eax,%eax
ffff8000001084d0:	78 3a                	js     ffff80000010850c <sys_read+0x7f>
ffff8000001084d2:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff8000001084d5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff8000001084d9:	48 89 c6             	mov    %rax,%rsi
ffff8000001084dc:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001084e1:	48 b8 8d 80 10 00 00 	movabs $0xffff80000010808d,%rax
ffff8000001084e8:	80 ff ff 
ffff8000001084eb:	ff d0                	call   *%rax
    return -1;
  return fileread(f, p, n);
ffff8000001084ed:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff8000001084f0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff8000001084f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001084f8:	48 89 ce             	mov    %rcx,%rsi
ffff8000001084fb:	48 89 c7             	mov    %rax,%rdi
ffff8000001084fe:	48 b8 37 1f 10 00 00 	movabs $0xffff800000101f37,%rax
ffff800000108505:	80 ff ff 
ffff800000108508:	ff d0                	call   *%rax
ffff80000010850a:	eb 05                	jmp    ffff800000108511 <sys_read+0x84>
    return -1;
ffff80000010850c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108511:	c9                   	leave
ffff800000108512:	c3                   	ret

ffff800000108513 <sys_write>:

int
sys_write(void)
{
ffff800000108513:	55                   	push   %rbp
ffff800000108514:	48 89 e5             	mov    %rsp,%rbp
ffff800000108517:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
ffff80000010851b:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff80000010851f:	48 89 c2             	mov    %rax,%rdx
ffff800000108522:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108527:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010852c:	48 b8 20 83 10 00 00 	movabs $0xffff800000108320,%rax
ffff800000108533:	80 ff ff 
ffff800000108536:	ff d0                	call   *%rax
ffff800000108538:	85 c0                	test   %eax,%eax
ffff80000010853a:	78 56                	js     ffff800000108592 <sys_write+0x7f>
ffff80000010853c:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff800000108540:	48 89 c6             	mov    %rax,%rsi
ffff800000108543:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000108548:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff80000010854f:	80 ff ff 
ffff800000108552:	ff d0                	call   *%rax
ffff800000108554:	85 c0                	test   %eax,%eax
ffff800000108556:	78 3a                	js     ffff800000108592 <sys_write+0x7f>
ffff800000108558:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff80000010855b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff80000010855f:	48 89 c6             	mov    %rax,%rsi
ffff800000108562:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108567:	48 b8 8d 80 10 00 00 	movabs $0xffff80000010808d,%rax
ffff80000010856e:	80 ff ff 
ffff800000108571:	ff d0                	call   *%rax
    return -1;
  return filewrite(f, p, n);
ffff800000108573:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108576:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff80000010857a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010857e:	48 89 ce             	mov    %rcx,%rsi
ffff800000108581:	48 89 c7             	mov    %rax,%rdi
ffff800000108584:	48 b8 2b 20 10 00 00 	movabs $0xffff80000010202b,%rax
ffff80000010858b:	80 ff ff 
ffff80000010858e:	ff d0                	call   *%rax
ffff800000108590:	eb 05                	jmp    ffff800000108597 <sys_write+0x84>
    return -1;
ffff800000108592:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108597:	c9                   	leave
ffff800000108598:	c3                   	ret

ffff800000108599 <sys_close>:

int
sys_close(void)
{
ffff800000108599:	55                   	push   %rbp
ffff80000010859a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010859d:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
ffff8000001085a1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
ffff8000001085a5:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff8000001085a9:	48 89 c6             	mov    %rax,%rsi
ffff8000001085ac:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001085b1:	48 b8 20 83 10 00 00 	movabs $0xffff800000108320,%rax
ffff8000001085b8:	80 ff ff 
ffff8000001085bb:	ff d0                	call   *%rax
ffff8000001085bd:	85 c0                	test   %eax,%eax
ffff8000001085bf:	79 07                	jns    ffff8000001085c8 <sys_close+0x2f>
    return -1;
ffff8000001085c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001085c6:	eb 36                	jmp    ffff8000001085fe <sys_close+0x65>
  proc->ofile[fd] = 0;
ffff8000001085c8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001085cf:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001085d3:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001085d6:	48 63 d2             	movslq %edx,%rdx
ffff8000001085d9:	48 83 c2 08          	add    $0x8,%rdx
ffff8000001085dd:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff8000001085e4:	00 00 
  fileclose(f);
ffff8000001085e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001085ea:	48 89 c7             	mov    %rax,%rdi
ffff8000001085ed:	48 b8 86 1d 10 00 00 	movabs $0xffff800000101d86,%rax
ffff8000001085f4:	80 ff ff 
ffff8000001085f7:	ff d0                	call   *%rax
  return 0;
ffff8000001085f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001085fe:	c9                   	leave
ffff8000001085ff:	c3                   	ret

ffff800000108600 <sys_fstat>:

int
sys_fstat(void)
{
ffff800000108600:	55                   	push   %rbp
ffff800000108601:	48 89 e5             	mov    %rsp,%rbp
ffff800000108604:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
ffff800000108608:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff80000010860c:	48 89 c2             	mov    %rax,%rdx
ffff80000010860f:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108614:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108619:	48 b8 20 83 10 00 00 	movabs $0xffff800000108320,%rax
ffff800000108620:	80 ff ff 
ffff800000108623:	ff d0                	call   *%rax
ffff800000108625:	85 c0                	test   %eax,%eax
ffff800000108627:	78 39                	js     ffff800000108662 <sys_fstat+0x62>
ffff800000108629:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff80000010862d:	ba 14 00 00 00       	mov    $0x14,%edx
ffff800000108632:	48 89 c6             	mov    %rax,%rsi
ffff800000108635:	bf 01 00 00 00       	mov    $0x1,%edi
ffff80000010863a:	48 b8 8d 80 10 00 00 	movabs $0xffff80000010808d,%rax
ffff800000108641:	80 ff ff 
ffff800000108644:	ff d0                	call   *%rax
    return -1;
  return filestat(f, st);
ffff800000108646:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010864a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010864e:	48 89 d6             	mov    %rdx,%rsi
ffff800000108651:	48 89 c7             	mov    %rax,%rdi
ffff800000108654:	48 b8 c2 1e 10 00 00 	movabs $0xffff800000101ec2,%rax
ffff80000010865b:	80 ff ff 
ffff80000010865e:	ff d0                	call   *%rax
ffff800000108660:	eb 05                	jmp    ffff800000108667 <sys_fstat+0x67>
    return -1;
ffff800000108662:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108667:	c9                   	leave
ffff800000108668:	c3                   	ret

ffff800000108669 <isdirempty>:

static int
isdirempty(struct inode *dp)
{
ffff800000108669:	55                   	push   %rbp
ffff80000010866a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010866d:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000108671:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  int off;
  struct dirent de;
  // Is the directory dp empty except for "." and ".." ?
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
ffff800000108675:	c7 45 fc 20 00 00 00 	movl   $0x20,-0x4(%rbp)
ffff80000010867c:	eb 56                	jmp    ffff8000001086d4 <isdirempty+0x6b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff80000010867e:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000108681:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000108685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108689:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff80000010868e:	48 89 c7             	mov    %rax,%rdi
ffff800000108691:	48 b8 1d 30 10 00 00 	movabs $0xffff80000010301d,%rax
ffff800000108698:	80 ff ff 
ffff80000010869b:	ff d0                	call   *%rax
ffff80000010869d:	83 f8 10             	cmp    $0x10,%eax
ffff8000001086a0:	74 19                	je     ffff8000001086bb <isdirempty+0x52>
      panic("isdirempty: readi");
ffff8000001086a2:	48 b8 d7 cb 10 00 00 	movabs $0xffff80000010cbd7,%rax
ffff8000001086a9:	80 ff ff 
ffff8000001086ac:	48 89 c7             	mov    %rax,%rdi
ffff8000001086af:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001086b6:	80 ff ff 
ffff8000001086b9:	ff d0                	call   *%rax
    if(de.inum != 0)
ffff8000001086bb:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff8000001086bf:	66 85 c0             	test   %ax,%ax
ffff8000001086c2:	74 07                	je     ffff8000001086cb <isdirempty+0x62>
      return 0;
ffff8000001086c4:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001086c9:	eb 1f                	jmp    ffff8000001086ea <isdirempty+0x81>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
ffff8000001086cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001086ce:	83 c0 10             	add    $0x10,%eax
ffff8000001086d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff8000001086d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001086d8:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff8000001086de:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001086e1:	39 c2                	cmp    %eax,%edx
ffff8000001086e3:	72 99                	jb     ffff80000010867e <isdirempty+0x15>
  }
  return 1;
ffff8000001086e5:	b8 01 00 00 00       	mov    $0x1,%eax
}
ffff8000001086ea:	c9                   	leave
ffff8000001086eb:	c3                   	ret

ffff8000001086ec <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
ffff8000001086ec:	55                   	push   %rbp
ffff8000001086ed:	48 89 e5             	mov    %rsp,%rbp
ffff8000001086f0:	48 83 ec 30          	sub    $0x30,%rsp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
ffff8000001086f4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffff8000001086f8:	48 89 c6             	mov    %rax,%rsi
ffff8000001086fb:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108700:	48 b8 14 81 10 00 00 	movabs $0xffff800000108114,%rax
ffff800000108707:	80 ff ff 
ffff80000010870a:	ff d0                	call   *%rax
ffff80000010870c:	85 c0                	test   %eax,%eax
ffff80000010870e:	78 1c                	js     ffff80000010872c <sys_link+0x40>
ffff800000108710:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
ffff800000108714:	48 89 c6             	mov    %rax,%rsi
ffff800000108717:	bf 01 00 00 00       	mov    $0x1,%edi
ffff80000010871c:	48 b8 14 81 10 00 00 	movabs $0xffff800000108114,%rax
ffff800000108723:	80 ff ff 
ffff800000108726:	ff d0                	call   *%rax
ffff800000108728:	85 c0                	test   %eax,%eax
ffff80000010872a:	79 0a                	jns    ffff800000108736 <sys_link+0x4a>
    return -1;
ffff80000010872c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108731:	e9 f3 01 00 00       	jmp    ffff800000108929 <sys_link+0x23d>

  begin_op();
ffff800000108736:	48 b8 be 50 10 00 00 	movabs $0xffff8000001050be,%rax
ffff80000010873d:	80 ff ff 
ffff800000108740:	ff d0                	call   *%rax
  if((ip = namei(old)) == 0){
ffff800000108742:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000108746:	48 89 c7             	mov    %rax,%rdi
ffff800000108749:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000108750:	80 ff ff 
ffff800000108753:	ff d0                	call   *%rax
ffff800000108755:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108759:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010875e:	75 16                	jne    ffff800000108776 <sys_link+0x8a>
    end_op();
ffff800000108760:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000108767:	80 ff ff 
ffff80000010876a:	ff d0                	call   *%rax
    return -1;
ffff80000010876c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108771:	e9 b3 01 00 00       	jmp    ffff800000108929 <sys_link+0x23d>
  }

  ilock(ip);
ffff800000108776:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010877a:	48 89 c7             	mov    %rax,%rdi
ffff80000010877d:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff800000108784:	80 ff ff 
ffff800000108787:	ff d0                	call   *%rax
  if(ip->type == T_DIR){
ffff800000108789:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010878d:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108794:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108798:	75 29                	jne    ffff8000001087c3 <sys_link+0xd7>
    iunlockput(ip);
ffff80000010879a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010879e:	48 89 c7             	mov    %rax,%rdi
ffff8000001087a1:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff8000001087a8:	80 ff ff 
ffff8000001087ab:	ff d0                	call   *%rax
    end_op();
ffff8000001087ad:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff8000001087b4:	80 ff ff 
ffff8000001087b7:	ff d0                	call   *%rax
    return -1;
ffff8000001087b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001087be:	e9 66 01 00 00       	jmp    ffff800000108929 <sys_link+0x23d>
  }

  ip->nlink++;
ffff8000001087c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001087c7:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff8000001087ce:	83 c0 01             	add    $0x1,%eax
ffff8000001087d1:	89 c2                	mov    %eax,%edx
ffff8000001087d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001087d7:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff8000001087de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001087e2:	48 89 c7             	mov    %rax,%rdi
ffff8000001087e5:	48 b8 10 27 10 00 00 	movabs $0xffff800000102710,%rax
ffff8000001087ec:	80 ff ff 
ffff8000001087ef:	ff d0                	call   *%rax
  iunlock(ip);
ffff8000001087f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001087f5:	48 89 c7             	mov    %rax,%rdi
ffff8000001087f8:	48 b8 4b 2b 10 00 00 	movabs $0xffff800000102b4b,%rax
ffff8000001087ff:	80 ff ff 
ffff800000108802:	ff d0                	call   *%rax

  if((dp = nameiparent(new, name)) == 0)
ffff800000108804:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108808:	48 8d 55 e2          	lea    -0x1e(%rbp),%rdx
ffff80000010880c:	48 89 d6             	mov    %rdx,%rsi
ffff80000010880f:	48 89 c7             	mov    %rax,%rdi
ffff800000108812:	48 b8 e5 38 10 00 00 	movabs $0xffff8000001038e5,%rax
ffff800000108819:	80 ff ff 
ffff80000010881c:	ff d0                	call   *%rax
ffff80000010881e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108822:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108827:	0f 84 96 00 00 00    	je     ffff8000001088c3 <sys_link+0x1d7>
    goto bad;
  ilock(dp);
ffff80000010882d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108831:	48 89 c7             	mov    %rax,%rdi
ffff800000108834:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff80000010883b:	80 ff ff 
ffff80000010883e:	ff d0                	call   *%rax
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
ffff800000108840:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108844:	8b 10                	mov    (%rax),%edx
ffff800000108846:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010884a:	8b 00                	mov    (%rax),%eax
ffff80000010884c:	39 c2                	cmp    %eax,%edx
ffff80000010884e:	75 25                	jne    ffff800000108875 <sys_link+0x189>
ffff800000108850:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108854:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000108857:	48 8d 4d e2          	lea    -0x1e(%rbp),%rcx
ffff80000010885b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010885f:	48 89 ce             	mov    %rcx,%rsi
ffff800000108862:	48 89 c7             	mov    %rax,%rdi
ffff800000108865:	48 b8 31 35 10 00 00 	movabs $0xffff800000103531,%rax
ffff80000010886c:	80 ff ff 
ffff80000010886f:	ff d0                	call   *%rax
ffff800000108871:	85 c0                	test   %eax,%eax
ffff800000108873:	79 15                	jns    ffff80000010888a <sys_link+0x19e>
    iunlockput(dp);
ffff800000108875:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108879:	48 89 c7             	mov    %rax,%rdi
ffff80000010887c:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000108883:	80 ff ff 
ffff800000108886:	ff d0                	call   *%rax
    goto bad;
ffff800000108888:	eb 3a                	jmp    ffff8000001088c4 <sys_link+0x1d8>
  }
  iunlockput(dp);
ffff80000010888a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010888e:	48 89 c7             	mov    %rax,%rdi
ffff800000108891:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000108898:	80 ff ff 
ffff80000010889b:	ff d0                	call   *%rax
  iput(ip);
ffff80000010889d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001088a1:	48 89 c7             	mov    %rax,%rdi
ffff8000001088a4:	48 b8 b7 2b 10 00 00 	movabs $0xffff800000102bb7,%rax
ffff8000001088ab:	80 ff ff 
ffff8000001088ae:	ff d0                	call   *%rax

  end_op();
ffff8000001088b0:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff8000001088b7:	80 ff ff 
ffff8000001088ba:	ff d0                	call   *%rax

  return 0;
ffff8000001088bc:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001088c1:	eb 66                	jmp    ffff800000108929 <sys_link+0x23d>
    goto bad;
ffff8000001088c3:	90                   	nop

bad:
  ilock(ip);
ffff8000001088c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001088c8:	48 89 c7             	mov    %rax,%rdi
ffff8000001088cb:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff8000001088d2:	80 ff ff 
ffff8000001088d5:	ff d0                	call   *%rax
  ip->nlink--;
ffff8000001088d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001088db:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff8000001088e2:	83 e8 01             	sub    $0x1,%eax
ffff8000001088e5:	89 c2                	mov    %eax,%edx
ffff8000001088e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001088eb:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff8000001088f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001088f6:	48 89 c7             	mov    %rax,%rdi
ffff8000001088f9:	48 b8 10 27 10 00 00 	movabs $0xffff800000102710,%rax
ffff800000108900:	80 ff ff 
ffff800000108903:	ff d0                	call   *%rax
  iunlockput(ip);
ffff800000108905:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108909:	48 89 c7             	mov    %rax,%rdi
ffff80000010890c:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000108913:	80 ff ff 
ffff800000108916:	ff d0                	call   *%rax
  end_op();
ffff800000108918:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff80000010891f:	80 ff ff 
ffff800000108922:	ff d0                	call   *%rax
  return -1;
ffff800000108924:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108929:	c9                   	leave
ffff80000010892a:	c3                   	ret

ffff80000010892b <sys_unlink>:
//PAGEBREAK!

int
sys_unlink(void)
{
ffff80000010892b:	55                   	push   %rbp
ffff80000010892c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010892f:	48 83 ec 40          	sub    $0x40,%rsp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
ffff800000108933:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
ffff800000108937:	48 89 c6             	mov    %rax,%rsi
ffff80000010893a:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010893f:	48 b8 14 81 10 00 00 	movabs $0xffff800000108114,%rax
ffff800000108946:	80 ff ff 
ffff800000108949:	ff d0                	call   *%rax
ffff80000010894b:	85 c0                	test   %eax,%eax
ffff80000010894d:	79 0a                	jns    ffff800000108959 <sys_unlink+0x2e>
    return -1;
ffff80000010894f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108954:	e9 7b 02 00 00       	jmp    ffff800000108bd4 <sys_unlink+0x2a9>

  begin_op();
ffff800000108959:	48 b8 be 50 10 00 00 	movabs $0xffff8000001050be,%rax
ffff800000108960:	80 ff ff 
ffff800000108963:	ff d0                	call   *%rax
  if((dp = nameiparent(path, name)) == 0){
ffff800000108965:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000108969:	48 8d 55 d2          	lea    -0x2e(%rbp),%rdx
ffff80000010896d:	48 89 d6             	mov    %rdx,%rsi
ffff800000108970:	48 89 c7             	mov    %rax,%rdi
ffff800000108973:	48 b8 e5 38 10 00 00 	movabs $0xffff8000001038e5,%rax
ffff80000010897a:	80 ff ff 
ffff80000010897d:	ff d0                	call   *%rax
ffff80000010897f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108983:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108988:	75 16                	jne    ffff8000001089a0 <sys_unlink+0x75>
    end_op();
ffff80000010898a:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000108991:	80 ff ff 
ffff800000108994:	ff d0                	call   *%rax
    return -1;
ffff800000108996:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010899b:	e9 34 02 00 00       	jmp    ffff800000108bd4 <sys_unlink+0x2a9>
  }

  ilock(dp);
ffff8000001089a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001089a4:	48 89 c7             	mov    %rax,%rdi
ffff8000001089a7:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff8000001089ae:	80 ff ff 
ffff8000001089b1:	ff d0                	call   *%rax

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
ffff8000001089b3:	48 ba e9 cb 10 00 00 	movabs $0xffff80000010cbe9,%rdx
ffff8000001089ba:	80 ff ff 
ffff8000001089bd:	48 8d 45 d2          	lea    -0x2e(%rbp),%rax
ffff8000001089c1:	48 89 d6             	mov    %rdx,%rsi
ffff8000001089c4:	48 89 c7             	mov    %rax,%rdi
ffff8000001089c7:	48 b8 fa 33 10 00 00 	movabs $0xffff8000001033fa,%rax
ffff8000001089ce:	80 ff ff 
ffff8000001089d1:	ff d0                	call   *%rax
ffff8000001089d3:	85 c0                	test   %eax,%eax
ffff8000001089d5:	0f 84 d1 01 00 00    	je     ffff800000108bac <sys_unlink+0x281>
ffff8000001089db:	48 ba eb cb 10 00 00 	movabs $0xffff80000010cbeb,%rdx
ffff8000001089e2:	80 ff ff 
ffff8000001089e5:	48 8d 45 d2          	lea    -0x2e(%rbp),%rax
ffff8000001089e9:	48 89 d6             	mov    %rdx,%rsi
ffff8000001089ec:	48 89 c7             	mov    %rax,%rdi
ffff8000001089ef:	48 b8 fa 33 10 00 00 	movabs $0xffff8000001033fa,%rax
ffff8000001089f6:	80 ff ff 
ffff8000001089f9:	ff d0                	call   *%rax
ffff8000001089fb:	85 c0                	test   %eax,%eax
ffff8000001089fd:	0f 84 a9 01 00 00    	je     ffff800000108bac <sys_unlink+0x281>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
ffff800000108a03:	48 8d 55 c4          	lea    -0x3c(%rbp),%rdx
ffff800000108a07:	48 8d 4d d2          	lea    -0x2e(%rbp),%rcx
ffff800000108a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108a0f:	48 89 ce             	mov    %rcx,%rsi
ffff800000108a12:	48 89 c7             	mov    %rax,%rdi
ffff800000108a15:	48 b8 2b 34 10 00 00 	movabs $0xffff80000010342b,%rax
ffff800000108a1c:	80 ff ff 
ffff800000108a1f:	ff d0                	call   *%rax
ffff800000108a21:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108a25:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108a2a:	0f 84 7f 01 00 00    	je     ffff800000108baf <sys_unlink+0x284>
    goto bad;
  ilock(ip);
ffff800000108a30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108a34:	48 89 c7             	mov    %rax,%rdi
ffff800000108a37:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff800000108a3e:	80 ff ff 
ffff800000108a41:	ff d0                	call   *%rax

  if(ip->nlink < 1)
ffff800000108a43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108a47:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108a4e:	66 85 c0             	test   %ax,%ax
ffff800000108a51:	7f 19                	jg     ffff800000108a6c <sys_unlink+0x141>
    panic("unlink: nlink < 1");
ffff800000108a53:	48 b8 ee cb 10 00 00 	movabs $0xffff80000010cbee,%rax
ffff800000108a5a:	80 ff ff 
ffff800000108a5d:	48 89 c7             	mov    %rax,%rdi
ffff800000108a60:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000108a67:	80 ff ff 
ffff800000108a6a:	ff d0                	call   *%rax
  if(ip->type == T_DIR && !isdirempty(ip)){
ffff800000108a6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108a70:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108a77:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108a7b:	75 2f                	jne    ffff800000108aac <sys_unlink+0x181>
ffff800000108a7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108a81:	48 89 c7             	mov    %rax,%rdi
ffff800000108a84:	48 b8 69 86 10 00 00 	movabs $0xffff800000108669,%rax
ffff800000108a8b:	80 ff ff 
ffff800000108a8e:	ff d0                	call   *%rax
ffff800000108a90:	85 c0                	test   %eax,%eax
ffff800000108a92:	75 18                	jne    ffff800000108aac <sys_unlink+0x181>
    iunlockput(ip);
ffff800000108a94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108a98:	48 89 c7             	mov    %rax,%rdi
ffff800000108a9b:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000108aa2:	80 ff ff 
ffff800000108aa5:	ff d0                	call   *%rax
    goto bad;
ffff800000108aa7:	e9 04 01 00 00       	jmp    ffff800000108bb0 <sys_unlink+0x285>
  }

  memset(&de, 0, sizeof(de));
ffff800000108aac:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000108ab0:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000108ab5:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108aba:	48 89 c7             	mov    %rax,%rdi
ffff800000108abd:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff800000108ac4:	80 ff ff 
ffff800000108ac7:	ff d0                	call   *%rax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000108ac9:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffff800000108acc:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000108ad0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108ad4:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000108ad9:	48 89 c7             	mov    %rax,%rdi
ffff800000108adc:	48 b8 ea 31 10 00 00 	movabs $0xffff8000001031ea,%rax
ffff800000108ae3:	80 ff ff 
ffff800000108ae6:	ff d0                	call   *%rax
ffff800000108ae8:	83 f8 10             	cmp    $0x10,%eax
ffff800000108aeb:	74 19                	je     ffff800000108b06 <sys_unlink+0x1db>
    panic("unlink: writei");
ffff800000108aed:	48 b8 00 cc 10 00 00 	movabs $0xffff80000010cc00,%rax
ffff800000108af4:	80 ff ff 
ffff800000108af7:	48 89 c7             	mov    %rax,%rdi
ffff800000108afa:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000108b01:	80 ff ff 
ffff800000108b04:	ff d0                	call   *%rax
  if(ip->type == T_DIR){
ffff800000108b06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b0a:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108b11:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108b15:	75 2e                	jne    ffff800000108b45 <sys_unlink+0x21a>
    dp->nlink--;
ffff800000108b17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108b1b:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108b22:	83 e8 01             	sub    $0x1,%eax
ffff800000108b25:	89 c2                	mov    %eax,%edx
ffff800000108b27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108b2b:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    iupdate(dp);
ffff800000108b32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108b36:	48 89 c7             	mov    %rax,%rdi
ffff800000108b39:	48 b8 10 27 10 00 00 	movabs $0xffff800000102710,%rax
ffff800000108b40:	80 ff ff 
ffff800000108b43:	ff d0                	call   *%rax
  }
  iunlockput(dp);
ffff800000108b45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108b49:	48 89 c7             	mov    %rax,%rdi
ffff800000108b4c:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000108b53:	80 ff ff 
ffff800000108b56:	ff d0                	call   *%rax

  ip->nlink--;
ffff800000108b58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b5c:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108b63:	83 e8 01             	sub    $0x1,%eax
ffff800000108b66:	89 c2                	mov    %eax,%edx
ffff800000108b68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b6c:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff800000108b73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b77:	48 89 c7             	mov    %rax,%rdi
ffff800000108b7a:	48 b8 10 27 10 00 00 	movabs $0xffff800000102710,%rax
ffff800000108b81:	80 ff ff 
ffff800000108b84:	ff d0                	call   *%rax
  iunlockput(ip);
ffff800000108b86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b8a:	48 89 c7             	mov    %rax,%rdi
ffff800000108b8d:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000108b94:	80 ff ff 
ffff800000108b97:	ff d0                	call   *%rax

  end_op();
ffff800000108b99:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000108ba0:	80 ff ff 
ffff800000108ba3:	ff d0                	call   *%rax

  return 0;
ffff800000108ba5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108baa:	eb 28                	jmp    ffff800000108bd4 <sys_unlink+0x2a9>
    goto bad;
ffff800000108bac:	90                   	nop
ffff800000108bad:	eb 01                	jmp    ffff800000108bb0 <sys_unlink+0x285>
    goto bad;
ffff800000108baf:	90                   	nop

bad:
  iunlockput(dp);
ffff800000108bb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108bb4:	48 89 c7             	mov    %rax,%rdi
ffff800000108bb7:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000108bbe:	80 ff ff 
ffff800000108bc1:	ff d0                	call   *%rax
  end_op();
ffff800000108bc3:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000108bca:	80 ff ff 
ffff800000108bcd:	ff d0                	call   *%rax
  return -1;
ffff800000108bcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108bd4:	c9                   	leave
ffff800000108bd5:	c3                   	ret

ffff800000108bd6 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
ffff800000108bd6:	55                   	push   %rbp
ffff800000108bd7:	48 89 e5             	mov    %rsp,%rbp
ffff800000108bda:	48 83 ec 50          	sub    $0x50,%rsp
ffff800000108bde:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff800000108be2:	89 c8                	mov    %ecx,%eax
ffff800000108be4:	89 f1                	mov    %esi,%ecx
ffff800000108be6:	66 89 4d c4          	mov    %cx,-0x3c(%rbp)
ffff800000108bea:	66 89 55 c0          	mov    %dx,-0x40(%rbp)
ffff800000108bee:	66 89 45 bc          	mov    %ax,-0x44(%rbp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
ffff800000108bf2:	48 8d 55 de          	lea    -0x22(%rbp),%rdx
ffff800000108bf6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000108bfa:	48 89 d6             	mov    %rdx,%rsi
ffff800000108bfd:	48 89 c7             	mov    %rax,%rdi
ffff800000108c00:	48 b8 e5 38 10 00 00 	movabs $0xffff8000001038e5,%rax
ffff800000108c07:	80 ff ff 
ffff800000108c0a:	ff d0                	call   *%rax
ffff800000108c0c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108c10:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108c15:	75 0a                	jne    ffff800000108c21 <create+0x4b>
    return 0;
ffff800000108c17:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108c1c:	e9 2c 02 00 00       	jmp    ffff800000108e4d <create+0x277>
  ilock(dp);
ffff800000108c21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c25:	48 89 c7             	mov    %rax,%rdi
ffff800000108c28:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff800000108c2f:	80 ff ff 
ffff800000108c32:	ff d0                	call   *%rax

  if((ip = dirlookup(dp, name, &off)) != 0){
ffff800000108c34:	48 8d 55 ec          	lea    -0x14(%rbp),%rdx
ffff800000108c38:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
ffff800000108c3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c40:	48 89 ce             	mov    %rcx,%rsi
ffff800000108c43:	48 89 c7             	mov    %rax,%rdi
ffff800000108c46:	48 b8 2b 34 10 00 00 	movabs $0xffff80000010342b,%rax
ffff800000108c4d:	80 ff ff 
ffff800000108c50:	ff d0                	call   *%rax
ffff800000108c52:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108c56:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108c5b:	74 64                	je     ffff800000108cc1 <create+0xeb>
    iunlockput(dp);
ffff800000108c5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c61:	48 89 c7             	mov    %rax,%rdi
ffff800000108c64:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000108c6b:	80 ff ff 
ffff800000108c6e:	ff d0                	call   *%rax
    ilock(ip);
ffff800000108c70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108c74:	48 89 c7             	mov    %rax,%rdi
ffff800000108c77:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff800000108c7e:	80 ff ff 
ffff800000108c81:	ff d0                	call   *%rax
    if(type == T_FILE && ip->type == T_FILE)
ffff800000108c83:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%rbp)
ffff800000108c88:	75 1a                	jne    ffff800000108ca4 <create+0xce>
ffff800000108c8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108c8e:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108c95:	66 83 f8 02          	cmp    $0x2,%ax
ffff800000108c99:	75 09                	jne    ffff800000108ca4 <create+0xce>
      return ip;
ffff800000108c9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108c9f:	e9 a9 01 00 00       	jmp    ffff800000108e4d <create+0x277>
    iunlockput(ip);
ffff800000108ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108ca8:	48 89 c7             	mov    %rax,%rdi
ffff800000108cab:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000108cb2:	80 ff ff 
ffff800000108cb5:	ff d0                	call   *%rax
    return 0;
ffff800000108cb7:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108cbc:	e9 8c 01 00 00       	jmp    ffff800000108e4d <create+0x277>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
ffff800000108cc1:	0f bf 55 c4          	movswl -0x3c(%rbp),%edx
ffff800000108cc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108cc9:	8b 00                	mov    (%rax),%eax
ffff800000108ccb:	89 d6                	mov    %edx,%esi
ffff800000108ccd:	89 c7                	mov    %eax,%edi
ffff800000108ccf:	48 b8 e8 25 10 00 00 	movabs $0xffff8000001025e8,%rax
ffff800000108cd6:	80 ff ff 
ffff800000108cd9:	ff d0                	call   *%rax
ffff800000108cdb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108cdf:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108ce4:	75 19                	jne    ffff800000108cff <create+0x129>
    panic("create: ialloc");
ffff800000108ce6:	48 b8 0f cc 10 00 00 	movabs $0xffff80000010cc0f,%rax
ffff800000108ced:	80 ff ff 
ffff800000108cf0:	48 89 c7             	mov    %rax,%rdi
ffff800000108cf3:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000108cfa:	80 ff ff 
ffff800000108cfd:	ff d0                	call   *%rax

  ilock(ip);
ffff800000108cff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108d03:	48 89 c7             	mov    %rax,%rdi
ffff800000108d06:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff800000108d0d:	80 ff ff 
ffff800000108d10:	ff d0                	call   *%rax
  ip->major = major;
ffff800000108d12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108d16:	0f b7 55 c0          	movzwl -0x40(%rbp),%edx
ffff800000108d1a:	66 89 90 96 00 00 00 	mov    %dx,0x96(%rax)
  ip->minor = minor;
ffff800000108d21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108d25:	0f b7 55 bc          	movzwl -0x44(%rbp),%edx
ffff800000108d29:	66 89 90 98 00 00 00 	mov    %dx,0x98(%rax)
  ip->nlink = 1;
ffff800000108d30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108d34:	66 c7 80 9a 00 00 00 	movw   $0x1,0x9a(%rax)
ffff800000108d3b:	01 00 
  iupdate(ip);
ffff800000108d3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108d41:	48 89 c7             	mov    %rax,%rdi
ffff800000108d44:	48 b8 10 27 10 00 00 	movabs $0xffff800000102710,%rax
ffff800000108d4b:	80 ff ff 
ffff800000108d4e:	ff d0                	call   *%rax

  if(type == T_DIR){  // Create . and .. entries.
ffff800000108d50:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%rbp)
ffff800000108d55:	0f 85 9d 00 00 00    	jne    ffff800000108df8 <create+0x222>
    dp->nlink++;  // for ".."
ffff800000108d5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d5f:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108d66:	83 c0 01             	add    $0x1,%eax
ffff800000108d69:	89 c2                	mov    %eax,%edx
ffff800000108d6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d6f:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    iupdate(dp);
ffff800000108d76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d7a:	48 89 c7             	mov    %rax,%rdi
ffff800000108d7d:	48 b8 10 27 10 00 00 	movabs $0xffff800000102710,%rax
ffff800000108d84:	80 ff ff 
ffff800000108d87:	ff d0                	call   *%rax
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
ffff800000108d89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108d8d:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000108d90:	48 b9 e9 cb 10 00 00 	movabs $0xffff80000010cbe9,%rcx
ffff800000108d97:	80 ff ff 
ffff800000108d9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108d9e:	48 89 ce             	mov    %rcx,%rsi
ffff800000108da1:	48 89 c7             	mov    %rax,%rdi
ffff800000108da4:	48 b8 31 35 10 00 00 	movabs $0xffff800000103531,%rax
ffff800000108dab:	80 ff ff 
ffff800000108dae:	ff d0                	call   *%rax
ffff800000108db0:	85 c0                	test   %eax,%eax
ffff800000108db2:	78 2b                	js     ffff800000108ddf <create+0x209>
ffff800000108db4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108db8:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000108dbb:	48 b9 eb cb 10 00 00 	movabs $0xffff80000010cbeb,%rcx
ffff800000108dc2:	80 ff ff 
ffff800000108dc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108dc9:	48 89 ce             	mov    %rcx,%rsi
ffff800000108dcc:	48 89 c7             	mov    %rax,%rdi
ffff800000108dcf:	48 b8 31 35 10 00 00 	movabs $0xffff800000103531,%rax
ffff800000108dd6:	80 ff ff 
ffff800000108dd9:	ff d0                	call   *%rax
ffff800000108ddb:	85 c0                	test   %eax,%eax
ffff800000108ddd:	79 19                	jns    ffff800000108df8 <create+0x222>
      panic("create dots");
ffff800000108ddf:	48 b8 1e cc 10 00 00 	movabs $0xffff80000010cc1e,%rax
ffff800000108de6:	80 ff ff 
ffff800000108de9:	48 89 c7             	mov    %rax,%rdi
ffff800000108dec:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000108df3:	80 ff ff 
ffff800000108df6:	ff d0                	call   *%rax
  }

  if(dirlink(dp, name, ip->inum) < 0)
ffff800000108df8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108dfc:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000108dff:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
ffff800000108e03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108e07:	48 89 ce             	mov    %rcx,%rsi
ffff800000108e0a:	48 89 c7             	mov    %rax,%rdi
ffff800000108e0d:	48 b8 31 35 10 00 00 	movabs $0xffff800000103531,%rax
ffff800000108e14:	80 ff ff 
ffff800000108e17:	ff d0                	call   *%rax
ffff800000108e19:	85 c0                	test   %eax,%eax
ffff800000108e1b:	79 19                	jns    ffff800000108e36 <create+0x260>
    panic("create: dirlink");
ffff800000108e1d:	48 b8 2a cc 10 00 00 	movabs $0xffff80000010cc2a,%rax
ffff800000108e24:	80 ff ff 
ffff800000108e27:	48 89 c7             	mov    %rax,%rdi
ffff800000108e2a:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000108e31:	80 ff ff 
ffff800000108e34:	ff d0                	call   *%rax

  iunlockput(dp);
ffff800000108e36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108e3a:	48 89 c7             	mov    %rax,%rdi
ffff800000108e3d:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000108e44:	80 ff ff 
ffff800000108e47:	ff d0                	call   *%rax

  return ip;
ffff800000108e49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
ffff800000108e4d:	c9                   	leave
ffff800000108e4e:	c3                   	ret

ffff800000108e4f <sys_open>:

int
sys_open(void)
{
ffff800000108e4f:	55                   	push   %rbp
ffff800000108e50:	48 89 e5             	mov    %rsp,%rbp
ffff800000108e53:	48 83 ec 30          	sub    $0x30,%rsp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
ffff800000108e57:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000108e5b:	48 89 c6             	mov    %rax,%rsi
ffff800000108e5e:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108e63:	48 b8 14 81 10 00 00 	movabs $0xffff800000108114,%rax
ffff800000108e6a:	80 ff ff 
ffff800000108e6d:	ff d0                	call   *%rax
ffff800000108e6f:	85 c0                	test   %eax,%eax
ffff800000108e71:	78 1c                	js     ffff800000108e8f <sys_open+0x40>
ffff800000108e73:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
ffff800000108e77:	48 89 c6             	mov    %rax,%rsi
ffff800000108e7a:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108e7f:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff800000108e86:	80 ff ff 
ffff800000108e89:	ff d0                	call   *%rax
ffff800000108e8b:	85 c0                	test   %eax,%eax
ffff800000108e8d:	79 0a                	jns    ffff800000108e99 <sys_open+0x4a>
    return -1;
ffff800000108e8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108e94:	e9 de 01 00 00       	jmp    ffff800000109077 <sys_open+0x228>

  begin_op();
ffff800000108e99:	48 b8 be 50 10 00 00 	movabs $0xffff8000001050be,%rax
ffff800000108ea0:	80 ff ff 
ffff800000108ea3:	ff d0                	call   *%rax

  if(omode & O_CREATE){
ffff800000108ea5:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108ea8:	25 00 02 00 00       	and    $0x200,%eax
ffff800000108ead:	85 c0                	test   %eax,%eax
ffff800000108eaf:	74 47                	je     ffff800000108ef8 <sys_open+0xa9>
    ip = create(path, T_FILE, 0, 0);
ffff800000108eb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108eb5:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff800000108eba:	ba 00 00 00 00       	mov    $0x0,%edx
ffff800000108ebf:	be 02 00 00 00       	mov    $0x2,%esi
ffff800000108ec4:	48 89 c7             	mov    %rax,%rdi
ffff800000108ec7:	48 b8 d6 8b 10 00 00 	movabs $0xffff800000108bd6,%rax
ffff800000108ece:	80 ff ff 
ffff800000108ed1:	ff d0                	call   *%rax
ffff800000108ed3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(ip == 0){
ffff800000108ed7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108edc:	0f 85 9e 00 00 00    	jne    ffff800000108f80 <sys_open+0x131>
      end_op();
ffff800000108ee2:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000108ee9:	80 ff ff 
ffff800000108eec:	ff d0                	call   *%rax
      return -1;
ffff800000108eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108ef3:	e9 7f 01 00 00       	jmp    ffff800000109077 <sys_open+0x228>
    }
  } else {
    if((ip = namei(path)) == 0){
ffff800000108ef8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108efc:	48 89 c7             	mov    %rax,%rdi
ffff800000108eff:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000108f06:	80 ff ff 
ffff800000108f09:	ff d0                	call   *%rax
ffff800000108f0b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108f0f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108f14:	75 16                	jne    ffff800000108f2c <sys_open+0xdd>
      end_op();
ffff800000108f16:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000108f1d:	80 ff ff 
ffff800000108f20:	ff d0                	call   *%rax
      return -1;
ffff800000108f22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108f27:	e9 4b 01 00 00       	jmp    ffff800000109077 <sys_open+0x228>
    }
    ilock(ip);
ffff800000108f2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f30:	48 89 c7             	mov    %rax,%rdi
ffff800000108f33:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff800000108f3a:	80 ff ff 
ffff800000108f3d:	ff d0                	call   *%rax
    if(ip->type == T_DIR && omode != O_RDONLY){
ffff800000108f3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f43:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108f4a:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108f4e:	75 30                	jne    ffff800000108f80 <sys_open+0x131>
ffff800000108f50:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108f53:	85 c0                	test   %eax,%eax
ffff800000108f55:	74 29                	je     ffff800000108f80 <sys_open+0x131>
      iunlockput(ip);
ffff800000108f57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f5b:	48 89 c7             	mov    %rax,%rdi
ffff800000108f5e:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000108f65:	80 ff ff 
ffff800000108f68:	ff d0                	call   *%rax
      end_op();
ffff800000108f6a:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000108f71:	80 ff ff 
ffff800000108f74:	ff d0                	call   *%rax
      return -1;
ffff800000108f76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108f7b:	e9 f7 00 00 00       	jmp    ffff800000109077 <sys_open+0x228>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
ffff800000108f80:	48 b8 72 1c 10 00 00 	movabs $0xffff800000101c72,%rax
ffff800000108f87:	80 ff ff 
ffff800000108f8a:	ff d0                	call   *%rax
ffff800000108f8c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108f90:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108f95:	74 1c                	je     ffff800000108fb3 <sys_open+0x164>
ffff800000108f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108f9b:	48 89 c7             	mov    %rax,%rdi
ffff800000108f9e:	48 b8 ba 83 10 00 00 	movabs $0xffff8000001083ba,%rax
ffff800000108fa5:	80 ff ff 
ffff800000108fa8:	ff d0                	call   *%rax
ffff800000108faa:	89 45 ec             	mov    %eax,-0x14(%rbp)
ffff800000108fad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff800000108fb1:	79 43                	jns    ffff800000108ff6 <sys_open+0x1a7>
    if(f)
ffff800000108fb3:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108fb8:	74 13                	je     ffff800000108fcd <sys_open+0x17e>
      fileclose(f);
ffff800000108fba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108fbe:	48 89 c7             	mov    %rax,%rdi
ffff800000108fc1:	48 b8 86 1d 10 00 00 	movabs $0xffff800000101d86,%rax
ffff800000108fc8:	80 ff ff 
ffff800000108fcb:	ff d0                	call   *%rax
    iunlockput(ip);
ffff800000108fcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108fd1:	48 89 c7             	mov    %rax,%rdi
ffff800000108fd4:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000108fdb:	80 ff ff 
ffff800000108fde:	ff d0                	call   *%rax
    end_op();
ffff800000108fe0:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000108fe7:	80 ff ff 
ffff800000108fea:	ff d0                	call   *%rax
    return -1;
ffff800000108fec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108ff1:	e9 81 00 00 00       	jmp    ffff800000109077 <sys_open+0x228>
  }
  iunlock(ip);
ffff800000108ff6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108ffa:	48 89 c7             	mov    %rax,%rdi
ffff800000108ffd:	48 b8 4b 2b 10 00 00 	movabs $0xffff800000102b4b,%rax
ffff800000109004:	80 ff ff 
ffff800000109007:	ff d0                	call   *%rax
  end_op();
ffff800000109009:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000109010:	80 ff ff 
ffff800000109013:	ff d0                	call   *%rax

  f->type = FD_INODE;
ffff800000109015:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109019:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
  f->ip = ip;
ffff80000010901f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109023:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000109027:	48 89 50 18          	mov    %rdx,0x18(%rax)
  f->off = 0;
ffff80000010902b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010902f:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%rax)
  f->readable = !(omode & O_WRONLY);
ffff800000109036:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000109039:	83 e0 01             	and    $0x1,%eax
ffff80000010903c:	83 e0 01             	and    $0x1,%eax
ffff80000010903f:	83 f0 01             	xor    $0x1,%eax
ffff800000109042:	89 c2                	mov    %eax,%edx
ffff800000109044:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109048:	88 50 08             	mov    %dl,0x8(%rax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
ffff80000010904b:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010904e:	83 e0 01             	and    $0x1,%eax
ffff800000109051:	85 c0                	test   %eax,%eax
ffff800000109053:	75 0a                	jne    ffff80000010905f <sys_open+0x210>
ffff800000109055:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000109058:	83 e0 02             	and    $0x2,%eax
ffff80000010905b:	85 c0                	test   %eax,%eax
ffff80000010905d:	74 07                	je     ffff800000109066 <sys_open+0x217>
ffff80000010905f:	b8 01 00 00 00       	mov    $0x1,%eax
ffff800000109064:	eb 05                	jmp    ffff80000010906b <sys_open+0x21c>
ffff800000109066:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010906b:	89 c2                	mov    %eax,%edx
ffff80000010906d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109071:	88 50 09             	mov    %dl,0x9(%rax)
  return fd;
ffff800000109074:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
ffff800000109077:	c9                   	leave
ffff800000109078:	c3                   	ret

ffff800000109079 <sys_mkdir>:

int
sys_mkdir(void)
{
ffff800000109079:	55                   	push   %rbp
ffff80000010907a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010907d:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
ffff800000109081:	48 b8 be 50 10 00 00 	movabs $0xffff8000001050be,%rax
ffff800000109088:	80 ff ff 
ffff80000010908b:	ff d0                	call   *%rax
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
ffff80000010908d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109091:	48 89 c6             	mov    %rax,%rsi
ffff800000109094:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109099:	48 b8 14 81 10 00 00 	movabs $0xffff800000108114,%rax
ffff8000001090a0:	80 ff ff 
ffff8000001090a3:	ff d0                	call   *%rax
ffff8000001090a5:	85 c0                	test   %eax,%eax
ffff8000001090a7:	78 2d                	js     ffff8000001090d6 <sys_mkdir+0x5d>
ffff8000001090a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001090ad:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff8000001090b2:	ba 00 00 00 00       	mov    $0x0,%edx
ffff8000001090b7:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001090bc:	48 89 c7             	mov    %rax,%rdi
ffff8000001090bf:	48 b8 d6 8b 10 00 00 	movabs $0xffff800000108bd6,%rax
ffff8000001090c6:	80 ff ff 
ffff8000001090c9:	ff d0                	call   *%rax
ffff8000001090cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001090cf:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001090d4:	75 13                	jne    ffff8000001090e9 <sys_mkdir+0x70>
    end_op();
ffff8000001090d6:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff8000001090dd:	80 ff ff 
ffff8000001090e0:	ff d0                	call   *%rax
    return -1;
ffff8000001090e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001090e7:	eb 24                	jmp    ffff80000010910d <sys_mkdir+0x94>
  }
  iunlockput(ip);
ffff8000001090e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001090ed:	48 89 c7             	mov    %rax,%rdi
ffff8000001090f0:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff8000001090f7:	80 ff ff 
ffff8000001090fa:	ff d0                	call   *%rax
  end_op();
ffff8000001090fc:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000109103:	80 ff ff 
ffff800000109106:	ff d0                	call   *%rax
  return 0;
ffff800000109108:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010910d:	c9                   	leave
ffff80000010910e:	c3                   	ret

ffff80000010910f <sys_mknod>:

int
sys_mknod(void)
{
ffff80000010910f:	55                   	push   %rbp
ffff800000109110:	48 89 e5             	mov    %rsp,%rbp
ffff800000109113:	48 83 ec 20          	sub    $0x20,%rsp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
ffff800000109117:	48 b8 be 50 10 00 00 	movabs $0xffff8000001050be,%rax
ffff80000010911e:	80 ff ff 
ffff800000109121:	ff d0                	call   *%rax
  if((argstr(0, &path)) < 0 ||
ffff800000109123:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109127:	48 89 c6             	mov    %rax,%rsi
ffff80000010912a:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010912f:	48 b8 14 81 10 00 00 	movabs $0xffff800000108114,%rax
ffff800000109136:	80 ff ff 
ffff800000109139:	ff d0                	call   *%rax
ffff80000010913b:	85 c0                	test   %eax,%eax
ffff80000010913d:	78 67                	js     ffff8000001091a6 <sys_mknod+0x97>
     argint(1, &major) < 0 ||
ffff80000010913f:	48 8d 45 ec          	lea    -0x14(%rbp),%rax
ffff800000109143:	48 89 c6             	mov    %rax,%rsi
ffff800000109146:	bf 01 00 00 00       	mov    $0x1,%edi
ffff80000010914b:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff800000109152:	80 ff ff 
ffff800000109155:	ff d0                	call   *%rax
  if((argstr(0, &path)) < 0 ||
ffff800000109157:	85 c0                	test   %eax,%eax
ffff800000109159:	78 4b                	js     ffff8000001091a6 <sys_mknod+0x97>
     argint(2, &minor) < 0 ||
ffff80000010915b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff80000010915f:	48 89 c6             	mov    %rax,%rsi
ffff800000109162:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000109167:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff80000010916e:	80 ff ff 
ffff800000109171:	ff d0                	call   *%rax
     argint(1, &major) < 0 ||
ffff800000109173:	85 c0                	test   %eax,%eax
ffff800000109175:	78 2f                	js     ffff8000001091a6 <sys_mknod+0x97>
     (ip = create(path, T_DEV, major, minor)) == 0){
ffff800000109177:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff80000010917a:	0f bf c8             	movswl %ax,%ecx
ffff80000010917d:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000109180:	0f bf d0             	movswl %ax,%edx
ffff800000109183:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109187:	be 03 00 00 00       	mov    $0x3,%esi
ffff80000010918c:	48 89 c7             	mov    %rax,%rdi
ffff80000010918f:	48 b8 d6 8b 10 00 00 	movabs $0xffff800000108bd6,%rax
ffff800000109196:	80 ff ff 
ffff800000109199:	ff d0                	call   *%rax
ffff80000010919b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
     argint(2, &minor) < 0 ||
ffff80000010919f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001091a4:	75 13                	jne    ffff8000001091b9 <sys_mknod+0xaa>
    end_op();
ffff8000001091a6:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff8000001091ad:	80 ff ff 
ffff8000001091b0:	ff d0                	call   *%rax
    return -1;
ffff8000001091b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001091b7:	eb 24                	jmp    ffff8000001091dd <sys_mknod+0xce>
  }
  iunlockput(ip);
ffff8000001091b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001091bd:	48 89 c7             	mov    %rax,%rdi
ffff8000001091c0:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff8000001091c7:	80 ff ff 
ffff8000001091ca:	ff d0                	call   *%rax
  end_op();
ffff8000001091cc:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff8000001091d3:	80 ff ff 
ffff8000001091d6:	ff d0                	call   *%rax
  return 0;
ffff8000001091d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001091dd:	c9                   	leave
ffff8000001091de:	c3                   	ret

ffff8000001091df <sys_chdir>:

int
sys_chdir(void)
{
ffff8000001091df:	55                   	push   %rbp
ffff8000001091e0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001091e3:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
ffff8000001091e7:	48 b8 be 50 10 00 00 	movabs $0xffff8000001050be,%rax
ffff8000001091ee:	80 ff ff 
ffff8000001091f1:	ff d0                	call   *%rax
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
ffff8000001091f3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff8000001091f7:	48 89 c6             	mov    %rax,%rsi
ffff8000001091fa:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001091ff:	48 b8 14 81 10 00 00 	movabs $0xffff800000108114,%rax
ffff800000109206:	80 ff ff 
ffff800000109209:	ff d0                	call   *%rax
ffff80000010920b:	85 c0                	test   %eax,%eax
ffff80000010920d:	78 1e                	js     ffff80000010922d <sys_chdir+0x4e>
ffff80000010920f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109213:	48 89 c7             	mov    %rax,%rdi
ffff800000109216:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff80000010921d:	80 ff ff 
ffff800000109220:	ff d0                	call   *%rax
ffff800000109222:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000109226:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010922b:	75 16                	jne    ffff800000109243 <sys_chdir+0x64>
    end_op();
ffff80000010922d:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000109234:	80 ff ff 
ffff800000109237:	ff d0                	call   *%rax
    return -1;
ffff800000109239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010923e:	e9 a5 00 00 00       	jmp    ffff8000001092e8 <sys_chdir+0x109>
  }
  ilock(ip);
ffff800000109243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109247:	48 89 c7             	mov    %rax,%rdi
ffff80000010924a:	48 b8 b4 29 10 00 00 	movabs $0xffff8000001029b4,%rax
ffff800000109251:	80 ff ff 
ffff800000109254:	ff d0                	call   *%rax
  if(ip->type != T_DIR){
ffff800000109256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010925a:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000109261:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000109265:	74 26                	je     ffff80000010928d <sys_chdir+0xae>
    iunlockput(ip);
ffff800000109267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010926b:	48 89 c7             	mov    %rax,%rdi
ffff80000010926e:	48 b8 b1 2c 10 00 00 	movabs $0xffff800000102cb1,%rax
ffff800000109275:	80 ff ff 
ffff800000109278:	ff d0                	call   *%rax
    end_op();
ffff80000010927a:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff800000109281:	80 ff ff 
ffff800000109284:	ff d0                	call   *%rax
    return -1;
ffff800000109286:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010928b:	eb 5b                	jmp    ffff8000001092e8 <sys_chdir+0x109>
  }
  iunlock(ip);
ffff80000010928d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109291:	48 89 c7             	mov    %rax,%rdi
ffff800000109294:	48 b8 4b 2b 10 00 00 	movabs $0xffff800000102b4b,%rax
ffff80000010929b:	80 ff ff 
ffff80000010929e:	ff d0                	call   *%rax
  iput(proc->cwd);
ffff8000001092a0:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001092a7:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001092ab:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff8000001092b2:	48 89 c7             	mov    %rax,%rdi
ffff8000001092b5:	48 b8 b7 2b 10 00 00 	movabs $0xffff800000102bb7,%rax
ffff8000001092bc:	80 ff ff 
ffff8000001092bf:	ff d0                	call   *%rax
  end_op();
ffff8000001092c1:	48 b8 a6 51 10 00 00 	movabs $0xffff8000001051a6,%rax
ffff8000001092c8:	80 ff ff 
ffff8000001092cb:	ff d0                	call   *%rax
  proc->cwd = ip;
ffff8000001092cd:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001092d4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001092d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001092dc:	48 89 90 c8 00 00 00 	mov    %rdx,0xc8(%rax)
  return 0;
ffff8000001092e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001092e8:	c9                   	leave
ffff8000001092e9:	c3                   	ret

ffff8000001092ea <sys_exec>:

int
sys_exec(void)
{
ffff8000001092ea:	55                   	push   %rbp
ffff8000001092eb:	48 89 e5             	mov    %rsp,%rbp
ffff8000001092ee:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  char *path, *argv[MAXARG];
  int i;
  addr_t uargv, uarg;

  if(argstr(0, &path) < 0 || argaddr(1, &uargv) < 0){
ffff8000001092f5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff8000001092f9:	48 89 c6             	mov    %rax,%rsi
ffff8000001092fc:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109301:	48 b8 14 81 10 00 00 	movabs $0xffff800000108114,%rax
ffff800000109308:	80 ff ff 
ffff80000010930b:	ff d0                	call   *%rax
ffff80000010930d:	85 c0                	test   %eax,%eax
ffff80000010930f:	78 44                	js     ffff800000109355 <sys_exec+0x6b>
ffff800000109311:	48 8d 85 e8 fe ff ff 	lea    -0x118(%rbp),%rax
ffff800000109318:	48 89 c6             	mov    %rax,%rsi
ffff80000010931b:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000109320:	48 b8 5f 80 10 00 00 	movabs $0xffff80000010805f,%rax
ffff800000109327:	80 ff ff 
ffff80000010932a:	ff d0                	call   *%rax
    return -1;
  }
  memset(argv, 0, sizeof(argv));
ffff80000010932c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
ffff800000109333:	ba 00 01 00 00       	mov    $0x100,%edx
ffff800000109338:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010933d:	48 89 c7             	mov    %rax,%rdi
ffff800000109340:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff800000109347:	80 ff ff 
ffff80000010934a:	ff d0                	call   *%rax
  for(i=0;; i++){
ffff80000010934c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000109353:	eb 0a                	jmp    ffff80000010935f <sys_exec+0x75>
    return -1;
ffff800000109355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010935a:	e9 cb 00 00 00       	jmp    ffff80000010942a <sys_exec+0x140>
    if(i >= NELEM(argv))
ffff80000010935f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109362:	83 f8 1f             	cmp    $0x1f,%eax
ffff800000109365:	76 0a                	jbe    ffff800000109371 <sys_exec+0x87>
      return -1;
ffff800000109367:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010936c:	e9 b9 00 00 00       	jmp    ffff80000010942a <sys_exec+0x140>
    if(fetchaddr(uargv+(sizeof(addr_t))*i, (addr_t*)&uarg) < 0)
ffff800000109371:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109374:	48 98                	cltq
ffff800000109376:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010937d:	00 
ffff80000010937e:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
ffff800000109385:	48 01 c2             	add    %rax,%rdx
ffff800000109388:	48 8d 85 e0 fe ff ff 	lea    -0x120(%rbp),%rax
ffff80000010938f:	48 89 c6             	mov    %rax,%rsi
ffff800000109392:	48 89 d7             	mov    %rdx,%rdi
ffff800000109395:	48 b8 39 7e 10 00 00 	movabs $0xffff800000107e39,%rax
ffff80000010939c:	80 ff ff 
ffff80000010939f:	ff d0                	call   *%rax
ffff8000001093a1:	85 c0                	test   %eax,%eax
ffff8000001093a3:	79 07                	jns    ffff8000001093ac <sys_exec+0xc2>
      return -1;
ffff8000001093a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001093aa:	eb 7e                	jmp    ffff80000010942a <sys_exec+0x140>
    if(uarg == 0){
ffff8000001093ac:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
ffff8000001093b3:	48 85 c0             	test   %rax,%rax
ffff8000001093b6:	75 31                	jne    ffff8000001093e9 <sys_exec+0xff>
      argv[i] = 0;
ffff8000001093b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001093bb:	48 98                	cltq
ffff8000001093bd:	48 c7 84 c5 f0 fe ff 	movq   $0x0,-0x110(%rbp,%rax,8)
ffff8000001093c4:	ff 00 00 00 00 
      break;
ffff8000001093c9:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
ffff8000001093ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001093ce:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
ffff8000001093d5:	48 89 d6             	mov    %rdx,%rsi
ffff8000001093d8:	48 89 c7             	mov    %rax,%rdi
ffff8000001093db:	48 b8 6b 16 10 00 00 	movabs $0xffff80000010166b,%rax
ffff8000001093e2:	80 ff ff 
ffff8000001093e5:	ff d0                	call   *%rax
ffff8000001093e7:	eb 41                	jmp    ffff80000010942a <sys_exec+0x140>
    if(fetchstr(uarg, &argv[i]) < 0)
ffff8000001093e9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
ffff8000001093f0:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001093f3:	48 63 d2             	movslq %edx,%rdx
ffff8000001093f6:	48 c1 e2 03          	shl    $0x3,%rdx
ffff8000001093fa:	48 01 c2             	add    %rax,%rdx
ffff8000001093fd:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
ffff800000109404:	48 89 d6             	mov    %rdx,%rsi
ffff800000109407:	48 89 c7             	mov    %rax,%rdi
ffff80000010940a:	48 b8 9e 7e 10 00 00 	movabs $0xffff800000107e9e,%rax
ffff800000109411:	80 ff ff 
ffff800000109414:	ff d0                	call   *%rax
ffff800000109416:	85 c0                	test   %eax,%eax
ffff800000109418:	79 07                	jns    ffff800000109421 <sys_exec+0x137>
      return -1;
ffff80000010941a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010941f:	eb 09                	jmp    ffff80000010942a <sys_exec+0x140>
  for(i=0;; i++){
ffff800000109421:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    if(i >= NELEM(argv))
ffff800000109425:	e9 35 ff ff ff       	jmp    ffff80000010935f <sys_exec+0x75>
}
ffff80000010942a:	c9                   	leave
ffff80000010942b:	c3                   	ret

ffff80000010942c <sys_pipe>:

int
sys_pipe(void)
{
ffff80000010942c:	55                   	push   %rbp
ffff80000010942d:	48 89 e5             	mov    %rsp,%rbp
ffff800000109430:	48 83 ec 20          	sub    $0x20,%rsp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
ffff800000109434:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109438:	ba 08 00 00 00       	mov    $0x8,%edx
ffff80000010943d:	48 89 c6             	mov    %rax,%rsi
ffff800000109440:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109445:	48 b8 8d 80 10 00 00 	movabs $0xffff80000010808d,%rax
ffff80000010944c:	80 ff ff 
ffff80000010944f:	ff d0                	call   *%rax
    return -1;
  if(pipealloc(&rf, &wf) < 0)
ffff800000109451:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff800000109455:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff800000109459:	48 89 d6             	mov    %rdx,%rsi
ffff80000010945c:	48 89 c7             	mov    %rax,%rdi
ffff80000010945f:	48 b8 0f 5e 10 00 00 	movabs $0xffff800000105e0f,%rax
ffff800000109466:	80 ff ff 
ffff800000109469:	ff d0                	call   *%rax
ffff80000010946b:	85 c0                	test   %eax,%eax
ffff80000010946d:	79 0a                	jns    ffff800000109479 <sys_pipe+0x4d>
    return -1;
ffff80000010946f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109474:	e9 ab 00 00 00       	jmp    ffff800000109524 <sys_pipe+0xf8>
  fd0 = -1;
ffff800000109479:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
ffff800000109480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109484:	48 89 c7             	mov    %rax,%rdi
ffff800000109487:	48 b8 ba 83 10 00 00 	movabs $0xffff8000001083ba,%rax
ffff80000010948e:	80 ff ff 
ffff800000109491:	ff d0                	call   *%rax
ffff800000109493:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000109496:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff80000010949a:	78 1c                	js     ffff8000001094b8 <sys_pipe+0x8c>
ffff80000010949c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001094a0:	48 89 c7             	mov    %rax,%rdi
ffff8000001094a3:	48 b8 ba 83 10 00 00 	movabs $0xffff8000001083ba,%rax
ffff8000001094aa:	80 ff ff 
ffff8000001094ad:	ff d0                	call   *%rax
ffff8000001094af:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffff8000001094b2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffff8000001094b6:	79 51                	jns    ffff800000109509 <sys_pipe+0xdd>
    if(fd0 >= 0)
ffff8000001094b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff8000001094bc:	78 1e                	js     ffff8000001094dc <sys_pipe+0xb0>
      proc->ofile[fd0] = 0;
ffff8000001094be:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001094c5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001094c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001094cc:	48 63 d2             	movslq %edx,%rdx
ffff8000001094cf:	48 83 c2 08          	add    $0x8,%rdx
ffff8000001094d3:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff8000001094da:	00 00 
    fileclose(rf);
ffff8000001094dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001094e0:	48 89 c7             	mov    %rax,%rdi
ffff8000001094e3:	48 b8 86 1d 10 00 00 	movabs $0xffff800000101d86,%rax
ffff8000001094ea:	80 ff ff 
ffff8000001094ed:	ff d0                	call   *%rax
    fileclose(wf);
ffff8000001094ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001094f3:	48 89 c7             	mov    %rax,%rdi
ffff8000001094f6:	48 b8 86 1d 10 00 00 	movabs $0xffff800000101d86,%rax
ffff8000001094fd:	80 ff ff 
ffff800000109500:	ff d0                	call   *%rax
    return -1;
ffff800000109502:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109507:	eb 1b                	jmp    ffff800000109524 <sys_pipe+0xf8>
  }
  fd[0] = fd0;
ffff800000109509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010950d:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000109510:	89 10                	mov    %edx,(%rax)
  fd[1] = fd1;
ffff800000109512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109516:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff80000010951a:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010951d:	89 02                	mov    %eax,(%rdx)
  return 0;
ffff80000010951f:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109524:	c9                   	leave
ffff800000109525:	c3                   	ret

ffff800000109526 <sys_fork>:
#include "proc.h"
#include "trace.h"

int
sys_fork(void)
{
ffff800000109526:	55                   	push   %rbp
ffff800000109527:	48 89 e5             	mov    %rsp,%rbp
  return fork();
ffff80000010952a:	48 b8 21 67 10 00 00 	movabs $0xffff800000106721,%rax
ffff800000109531:	80 ff ff 
ffff800000109534:	ff d0                	call   *%rax
}
ffff800000109536:	5d                   	pop    %rbp
ffff800000109537:	c3                   	ret

ffff800000109538 <sys_exit>:

int
sys_exit(void)
{
ffff800000109538:	55                   	push   %rbp
ffff800000109539:	48 89 e5             	mov    %rsp,%rbp
  exit();
ffff80000010953c:	48 b8 15 6a 10 00 00 	movabs $0xffff800000106a15,%rax
ffff800000109543:	80 ff ff 
ffff800000109546:	ff d0                	call   *%rax
  return 0;  // not reached
ffff800000109548:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010954d:	5d                   	pop    %rbp
ffff80000010954e:	c3                   	ret

ffff80000010954f <sys_wait>:

int
sys_wait(void)
{
ffff80000010954f:	55                   	push   %rbp
ffff800000109550:	48 89 e5             	mov    %rsp,%rbp
  return wait();
ffff800000109553:	48 b8 44 6c 10 00 00 	movabs $0xffff800000106c44,%rax
ffff80000010955a:	80 ff ff 
ffff80000010955d:	ff d0                	call   *%rax
}
ffff80000010955f:	5d                   	pop    %rbp
ffff800000109560:	c3                   	ret

ffff800000109561 <sys_kill>:

int
sys_kill(void)
{
ffff800000109561:	55                   	push   %rbp
ffff800000109562:	48 89 e5             	mov    %rsp,%rbp
ffff800000109565:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;

  if(argint(0, &pid) < 0)
ffff800000109569:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff80000010956d:	48 89 c6             	mov    %rax,%rsi
ffff800000109570:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109575:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff80000010957c:	80 ff ff 
ffff80000010957f:	ff d0                	call   *%rax
ffff800000109581:	85 c0                	test   %eax,%eax
ffff800000109583:	79 07                	jns    ffff80000010958c <sys_kill+0x2b>
    return -1;
ffff800000109585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010958a:	eb 11                	jmp    ffff80000010959d <sys_kill+0x3c>
  return kill(pid);
ffff80000010958c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010958f:	89 c7                	mov    %eax,%edi
ffff800000109591:	48 b8 a1 72 10 00 00 	movabs $0xffff8000001072a1,%rax
ffff800000109598:	80 ff ff 
ffff80000010959b:	ff d0                	call   *%rax
}
ffff80000010959d:	c9                   	leave
ffff80000010959e:	c3                   	ret

ffff80000010959f <sys_getpid>:

int
sys_getpid(void)
{
ffff80000010959f:	55                   	push   %rbp
ffff8000001095a0:	48 89 e5             	mov    %rsp,%rbp
  return proc->pid;
ffff8000001095a3:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001095aa:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001095ae:	8b 40 1c             	mov    0x1c(%rax),%eax
}
ffff8000001095b1:	5d                   	pop    %rbp
ffff8000001095b2:	c3                   	ret

ffff8000001095b3 <sys_sbrk>:

addr_t
sys_sbrk(void)
{
ffff8000001095b3:	55                   	push   %rbp
ffff8000001095b4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001095b7:	48 83 ec 10          	sub    $0x10,%rsp
  addr_t addr;
  addr_t n;

  argaddr(0, &n);
ffff8000001095bb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff8000001095bf:	48 89 c6             	mov    %rax,%rsi
ffff8000001095c2:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001095c7:	48 b8 5f 80 10 00 00 	movabs $0xffff80000010805f,%rax
ffff8000001095ce:	80 ff ff 
ffff8000001095d1:	ff d0                	call   *%rax
  addr = proc->sz;
ffff8000001095d3:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001095da:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001095de:	48 8b 00             	mov    (%rax),%rax
ffff8000001095e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(growproc(n) < 0)
ffff8000001095e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001095e9:	48 89 c7             	mov    %rax,%rdi
ffff8000001095ec:	48 b8 3e 66 10 00 00 	movabs $0xffff80000010663e,%rax
ffff8000001095f3:	80 ff ff 
ffff8000001095f6:	ff d0                	call   *%rax
ffff8000001095f8:	85 c0                	test   %eax,%eax
ffff8000001095fa:	79 09                	jns    ffff800000109605 <sys_sbrk+0x52>
    return -1;
ffff8000001095fc:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
ffff800000109603:	eb 04                	jmp    ffff800000109609 <sys_sbrk+0x56>
  return addr;
ffff800000109605:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000109609:	c9                   	leave
ffff80000010960a:	c3                   	ret

ffff80000010960b <sys_sleep>:

int
sys_sleep(void)
{
ffff80000010960b:	55                   	push   %rbp
ffff80000010960c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010960f:	48 83 ec 10          	sub    $0x10,%rsp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
ffff800000109613:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000109617:	48 89 c6             	mov    %rax,%rsi
ffff80000010961a:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010961f:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff800000109626:	80 ff ff 
ffff800000109629:	ff d0                	call   *%rax
ffff80000010962b:	85 c0                	test   %eax,%eax
ffff80000010962d:	79 0a                	jns    ffff800000109639 <sys_sleep+0x2e>
    return -1;
ffff80000010962f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109634:	e9 b6 00 00 00       	jmp    ffff8000001096ef <sys_sleep+0xe4>
  acquire(&tickslock);
ffff800000109639:	48 b8 e0 bc 11 00 00 	movabs $0xffff80000011bce0,%rax
ffff800000109640:	80 ff ff 
ffff800000109643:	48 89 c7             	mov    %rax,%rdi
ffff800000109646:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff80000010964d:	80 ff ff 
ffff800000109650:	ff d0                	call   *%rax
  ticks0 = ticks;
ffff800000109652:	48 b8 48 bd 11 00 00 	movabs $0xffff80000011bd48,%rax
ffff800000109659:	80 ff ff 
ffff80000010965c:	8b 00                	mov    (%rax),%eax
ffff80000010965e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while(ticks - ticks0 < n){
ffff800000109661:	eb 58                	jmp    ffff8000001096bb <sys_sleep+0xb0>
    if(proc->killed){
ffff800000109663:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010966a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010966e:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000109671:	85 c0                	test   %eax,%eax
ffff800000109673:	74 20                	je     ffff800000109695 <sys_sleep+0x8a>
      release(&tickslock);
ffff800000109675:	48 b8 e0 bc 11 00 00 	movabs $0xffff80000011bce0,%rax
ffff80000010967c:	80 ff ff 
ffff80000010967f:	48 89 c7             	mov    %rax,%rdi
ffff800000109682:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000109689:	80 ff ff 
ffff80000010968c:	ff d0                	call   *%rax
      return -1;
ffff80000010968e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109693:	eb 5a                	jmp    ffff8000001096ef <sys_sleep+0xe4>
    }
    sleep(&ticks, &tickslock);
ffff800000109695:	48 ba e0 bc 11 00 00 	movabs $0xffff80000011bce0,%rdx
ffff80000010969c:	80 ff ff 
ffff80000010969f:	48 b8 48 bd 11 00 00 	movabs $0xffff80000011bd48,%rax
ffff8000001096a6:	80 ff ff 
ffff8000001096a9:	48 89 d6             	mov    %rdx,%rsi
ffff8000001096ac:	48 89 c7             	mov    %rax,%rdi
ffff8000001096af:	48 b8 d8 70 10 00 00 	movabs $0xffff8000001070d8,%rax
ffff8000001096b6:	80 ff ff 
ffff8000001096b9:	ff d0                	call   *%rax
  while(ticks - ticks0 < n){
ffff8000001096bb:	48 b8 48 bd 11 00 00 	movabs $0xffff80000011bd48,%rax
ffff8000001096c2:	80 ff ff 
ffff8000001096c5:	8b 00                	mov    (%rax),%eax
ffff8000001096c7:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff8000001096ca:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff8000001096cd:	39 d0                	cmp    %edx,%eax
ffff8000001096cf:	72 92                	jb     ffff800000109663 <sys_sleep+0x58>
  }
  release(&tickslock);
ffff8000001096d1:	48 b8 e0 bc 11 00 00 	movabs $0xffff80000011bce0,%rax
ffff8000001096d8:	80 ff ff 
ffff8000001096db:	48 89 c7             	mov    %rax,%rdi
ffff8000001096de:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff8000001096e5:	80 ff ff 
ffff8000001096e8:	ff d0                	call   *%rax
  return 0;
ffff8000001096ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001096ef:	c9                   	leave
ffff8000001096f0:	c3                   	ret

ffff8000001096f1 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
ffff8000001096f1:	55                   	push   %rbp
ffff8000001096f2:	48 89 e5             	mov    %rsp,%rbp
ffff8000001096f5:	48 83 ec 10          	sub    $0x10,%rsp
  uint xticks;

  acquire(&tickslock);
ffff8000001096f9:	48 b8 e0 bc 11 00 00 	movabs $0xffff80000011bce0,%rax
ffff800000109700:	80 ff ff 
ffff800000109703:	48 89 c7             	mov    %rax,%rdi
ffff800000109706:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff80000010970d:	80 ff ff 
ffff800000109710:	ff d0                	call   *%rax
  xticks = ticks;
ffff800000109712:	48 b8 48 bd 11 00 00 	movabs $0xffff80000011bd48,%rax
ffff800000109719:	80 ff ff 
ffff80000010971c:	8b 00                	mov    (%rax),%eax
ffff80000010971e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  release(&tickslock);
ffff800000109721:	48 b8 e0 bc 11 00 00 	movabs $0xffff80000011bce0,%rax
ffff800000109728:	80 ff ff 
ffff80000010972b:	48 89 c7             	mov    %rax,%rdi
ffff80000010972e:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000109735:	80 ff ff 
ffff800000109738:	ff d0                	call   *%rax
  return xticks;
ffff80000010973a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff80000010973d:	c9                   	leave
ffff80000010973e:	c3                   	ret

ffff80000010973f <sys_traceread>:


int
sys_traceread(void){
ffff80000010973f:	55                   	push   %rbp
ffff800000109740:	48 89 e5             	mov    %rsp,%rbp
ffff800000109743:	48 83 ec 10          	sub    $0x10,%rsp
  struct trace_event *event;
  int max_events;

  // Get the max_events count first
  if(argint(1, &max_events) < 0)
ffff800000109747:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff80000010974b:	48 89 c6             	mov    %rax,%rsi
ffff80000010974e:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000109753:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff80000010975a:	80 ff ff 
ffff80000010975d:	ff d0                	call   *%rax
ffff80000010975f:	85 c0                	test   %eax,%eax
ffff800000109761:	79 07                	jns    ffff80000010976a <sys_traceread+0x2b>
    return -1;
ffff800000109763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109768:	eb 46                	jmp    ffff8000001097b0 <sys_traceread+0x71>

  if(max_events <= 0)
ffff80000010976a:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010976d:	85 c0                	test   %eax,%eax
ffff80000010976f:	7f 07                	jg     ffff800000109778 <sys_traceread+0x39>
    return 0;
ffff800000109771:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109776:	eb 38                	jmp    ffff8000001097b0 <sys_traceread+0x71>

  // Get the destination buffer and check if it's large enough for max_events
  if(argptr(0, (char**)&event, max_events * sizeof(struct trace_event)) < 0)
ffff800000109778:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010977b:	c1 e0 06             	shl    $0x6,%eax
ffff80000010977e:	89 c2                	mov    %eax,%edx
ffff800000109780:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000109784:	48 89 c6             	mov    %rax,%rsi
ffff800000109787:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010978c:	48 b8 8d 80 10 00 00 	movabs $0xffff80000010808d,%rax
ffff800000109793:	80 ff ff 
ffff800000109796:	ff d0                	call   *%rax
    return -1;

  return traceread(event, max_events);
ffff800000109798:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff80000010979b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010979f:	89 d6                	mov    %edx,%esi
ffff8000001097a1:	48 89 c7             	mov    %rax,%rdi
ffff8000001097a4:	48 b8 3b c5 10 00 00 	movabs $0xffff80000010c53b,%rax
ffff8000001097ab:	80 ff ff 
ffff8000001097ae:	ff d0                	call   *%rax
}
ffff8000001097b0:	c9                   	leave
ffff8000001097b1:	c3                   	ret

ffff8000001097b2 <sys_vidclear>:


int sys_vidclear(void){
ffff8000001097b2:	55                   	push   %rbp
ffff8000001097b3:	48 89 e5             	mov    %rsp,%rbp
  vidclear();
ffff8000001097b6:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff8000001097bd:	80 ff ff 
ffff8000001097c0:	ff d0                	call   *%rax
  return 0;
ffff8000001097c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001097c7:	5d                   	pop    %rbp
ffff8000001097c8:	c3                   	ret

ffff8000001097c9 <sys_vidputc>:

int
sys_vidputc(void){
ffff8000001097c9:	55                   	push   %rbp
ffff8000001097ca:	48 89 e5             	mov    %rsp,%rbp
ffff8000001097cd:	48 83 ec 10          	sub    $0x10,%rsp
  int row, col, ch, color;

  if(argint(0, &row) < 0)
ffff8000001097d1:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff8000001097d5:	48 89 c6             	mov    %rax,%rsi
ffff8000001097d8:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001097dd:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff8000001097e4:	80 ff ff 
ffff8000001097e7:	ff d0                	call   *%rax
ffff8000001097e9:	85 c0                	test   %eax,%eax
ffff8000001097eb:	79 0a                	jns    ffff8000001097f7 <sys_vidputc+0x2e>
    return -1;
ffff8000001097ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001097f2:	e9 88 00 00 00       	jmp    ffff80000010987f <sys_vidputc+0xb6>
  if(argint(1, &col) < 0)
ffff8000001097f7:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff8000001097fb:	48 89 c6             	mov    %rax,%rsi
ffff8000001097fe:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000109803:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff80000010980a:	80 ff ff 
ffff80000010980d:	ff d0                	call   *%rax
ffff80000010980f:	85 c0                	test   %eax,%eax
ffff800000109811:	79 07                	jns    ffff80000010981a <sys_vidputc+0x51>
    return -1;
ffff800000109813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109818:	eb 65                	jmp    ffff80000010987f <sys_vidputc+0xb6>
  if(argint(2, &ch) < 0)
ffff80000010981a:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff80000010981e:	48 89 c6             	mov    %rax,%rsi
ffff800000109821:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000109826:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff80000010982d:	80 ff ff 
ffff800000109830:	ff d0                	call   *%rax
ffff800000109832:	85 c0                	test   %eax,%eax
ffff800000109834:	79 07                	jns    ffff80000010983d <sys_vidputc+0x74>
    return -1;
ffff800000109836:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010983b:	eb 42                	jmp    ffff80000010987f <sys_vidputc+0xb6>
  if(argint(3, &color) < 0)
ffff80000010983d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109841:	48 89 c6             	mov    %rax,%rsi
ffff800000109844:	bf 03 00 00 00       	mov    $0x3,%edi
ffff800000109849:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff800000109850:	80 ff ff 
ffff800000109853:	ff d0                	call   *%rax
ffff800000109855:	85 c0                	test   %eax,%eax
ffff800000109857:	79 07                	jns    ffff800000109860 <sys_vidputc+0x97>
    return -1;
ffff800000109859:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010985e:	eb 1f                	jmp    ffff80000010987f <sys_vidputc+0xb6>

  vidputc(row, col, ch, color);
ffff800000109860:	8b 4d f0             	mov    -0x10(%rbp),%ecx
ffff800000109863:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000109866:	8b 75 f8             	mov    -0x8(%rbp),%esi
ffff800000109869:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010986c:	89 c7                	mov    %eax,%edi
ffff80000010986e:	48 b8 17 0f 10 00 00 	movabs $0xffff800000100f17,%rax
ffff800000109875:	80 ff ff 
ffff800000109878:	ff d0                	call   *%rax
  return 0;
ffff80000010987a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010987f:	c9                   	leave
ffff800000109880:	c3                   	ret

ffff800000109881 <sys_vidputs>:

int sys_vidputs(void){
ffff800000109881:	55                   	push   %rbp
ffff800000109882:	48 89 e5             	mov    %rsp,%rbp
ffff800000109885:	48 83 ec 20          	sub    $0x20,%rsp
  int row, col, color;
  char *s;

  if(argint(0, &row) < 0)
ffff800000109889:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff80000010988d:	48 89 c6             	mov    %rax,%rsi
ffff800000109890:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109895:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff80000010989c:	80 ff ff 
ffff80000010989f:	ff d0                	call   *%rax
ffff8000001098a1:	85 c0                	test   %eax,%eax
ffff8000001098a3:	79 0a                	jns    ffff8000001098af <sys_vidputs+0x2e>
    return -1;
ffff8000001098a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001098aa:	e9 89 00 00 00       	jmp    ffff800000109938 <sys_vidputs+0xb7>
  if(argint(1, &col) < 0)
ffff8000001098af:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff8000001098b3:	48 89 c6             	mov    %rax,%rsi
ffff8000001098b6:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001098bb:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff8000001098c2:	80 ff ff 
ffff8000001098c5:	ff d0                	call   *%rax
ffff8000001098c7:	85 c0                	test   %eax,%eax
ffff8000001098c9:	79 07                	jns    ffff8000001098d2 <sys_vidputs+0x51>
    return -1;
ffff8000001098cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001098d0:	eb 66                	jmp    ffff800000109938 <sys_vidputs+0xb7>
  if(argstr(2, &s) < 0)
ffff8000001098d2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff8000001098d6:	48 89 c6             	mov    %rax,%rsi
ffff8000001098d9:	bf 02 00 00 00       	mov    $0x2,%edi
ffff8000001098de:	48 b8 14 81 10 00 00 	movabs $0xffff800000108114,%rax
ffff8000001098e5:	80 ff ff 
ffff8000001098e8:	ff d0                	call   *%rax
ffff8000001098ea:	85 c0                	test   %eax,%eax
ffff8000001098ec:	79 07                	jns    ffff8000001098f5 <sys_vidputs+0x74>
    return -1;
ffff8000001098ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001098f3:	eb 43                	jmp    ffff800000109938 <sys_vidputs+0xb7>
  if(argint(3, &color) < 0)
ffff8000001098f5:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff8000001098f9:	48 89 c6             	mov    %rax,%rsi
ffff8000001098fc:	bf 03 00 00 00       	mov    $0x3,%edi
ffff800000109901:	48 b8 30 80 10 00 00 	movabs $0xffff800000108030,%rax
ffff800000109908:	80 ff ff 
ffff80000010990b:	ff d0                	call   *%rax
ffff80000010990d:	85 c0                	test   %eax,%eax
ffff80000010990f:	79 07                	jns    ffff800000109918 <sys_vidputs+0x97>
    return -1;
ffff800000109911:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109916:	eb 20                	jmp    ffff800000109938 <sys_vidputs+0xb7>

  vidputs(row, col, s, color);
ffff800000109918:	8b 4d f4             	mov    -0xc(%rbp),%ecx
ffff80000010991b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010991f:	8b 75 f8             	mov    -0x8(%rbp),%esi
ffff800000109922:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109925:	89 c7                	mov    %eax,%edi
ffff800000109927:	48 b8 89 0f 10 00 00 	movabs $0xffff800000100f89,%rax
ffff80000010992e:	80 ff ff 
ffff800000109931:	ff d0                	call   *%rax
  return 0;
ffff800000109933:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109938:	c9                   	leave
ffff800000109939:	c3                   	ret

ffff80000010993a <alltraps>:
# vectors.S sends all traps here.
.global alltraps
alltraps:
  # Build trap frame.
  pushq   %r15
ffff80000010993a:	41 57                	push   %r15
  pushq   %r14
ffff80000010993c:	41 56                	push   %r14
  pushq   %r13
ffff80000010993e:	41 55                	push   %r13
  pushq   %r12
ffff800000109940:	41 54                	push   %r12
  pushq   %r11
ffff800000109942:	41 53                	push   %r11
  pushq   %r10
ffff800000109944:	41 52                	push   %r10
  pushq   %r9
ffff800000109946:	41 51                	push   %r9
  pushq   %r8
ffff800000109948:	41 50                	push   %r8
  pushq   %rdi
ffff80000010994a:	57                   	push   %rdi
  pushq   %rsi
ffff80000010994b:	56                   	push   %rsi
  pushq   %rbp
ffff80000010994c:	55                   	push   %rbp
  pushq   %rdx
ffff80000010994d:	52                   	push   %rdx
  pushq   %rcx
ffff80000010994e:	51                   	push   %rcx
  pushq   %rbx
ffff80000010994f:	53                   	push   %rbx
  pushq   %rax
ffff800000109950:	50                   	push   %rax

  movq    %rsp, %rdi  # frame in arg1
ffff800000109951:	48 89 e7             	mov    %rsp,%rdi
  callq   trap
ffff800000109954:	e8 7b 02 00 00       	call   ffff800000109bd4 <trap>

ffff800000109959 <trapret>:
# Return falls through to trapret...

.global trapret
trapret:
  popq    %rax
ffff800000109959:	58                   	pop    %rax
  popq    %rbx
ffff80000010995a:	5b                   	pop    %rbx
  popq    %rcx
ffff80000010995b:	59                   	pop    %rcx
  popq    %rdx
ffff80000010995c:	5a                   	pop    %rdx
  popq    %rbp
ffff80000010995d:	5d                   	pop    %rbp
  popq    %rsi
ffff80000010995e:	5e                   	pop    %rsi
  popq    %rdi
ffff80000010995f:	5f                   	pop    %rdi
  popq    %r8
ffff800000109960:	41 58                	pop    %r8
  popq    %r9
ffff800000109962:	41 59                	pop    %r9
  popq    %r10
ffff800000109964:	41 5a                	pop    %r10
  popq    %r11
ffff800000109966:	41 5b                	pop    %r11
  popq    %r12
ffff800000109968:	41 5c                	pop    %r12
  popq    %r13
ffff80000010996a:	41 5d                	pop    %r13
  popq    %r14
ffff80000010996c:	41 5e                	pop    %r14
  popq    %r15
ffff80000010996e:	41 5f                	pop    %r15

  addq    $16, %rsp  # discard trapnum and errorcode
ffff800000109970:	48 83 c4 10          	add    $0x10,%rsp
  iretq
ffff800000109974:	48 cf                	iretq

ffff800000109976 <syscall_entry>:
.global syscall_entry
syscall_entry:
  # switch to kernel stack. With the syscall instruction,
  # this is a kernel resposibility
  # store %rsp on the top of proc->kstack,
  movq    %rax, %fs:(0)      # save %rax above __thread vars
ffff800000109976:	64 48 89 04 25 00 00 	mov    %rax,%fs:0x0
ffff80000010997d:	00 00 
  movq    %fs:(-8), %rax     # %fs:(-8) is proc (the last __thread)
ffff80000010997f:	64 48 8b 04 25 f8 ff 	mov    %fs:0xfffffffffffffff8,%rax
ffff800000109986:	ff ff 
  movq    0x10(%rax), %rax   # get proc->kstack (see struct proc)
ffff800000109988:	48 8b 40 10          	mov    0x10(%rax),%rax
  addq    $(4096-16), %rax   # %rax points to tf->rsp
ffff80000010998c:	48 05 f0 0f 00 00    	add    $0xff0,%rax
  movq    %rsp, (%rax)       # save user rsp to tf->rsp
ffff800000109992:	48 89 20             	mov    %rsp,(%rax)
  movq    %rax, %rsp         # switch to the kstack
ffff800000109995:	48 89 c4             	mov    %rax,%rsp
  movq    %fs:(0), %rax      # restore %rax
ffff800000109998:	64 48 8b 04 25 00 00 	mov    %fs:0x0,%rax
ffff80000010999f:	00 00 

  pushq   %r11         # rflags
ffff8000001099a1:	41 53                	push   %r11
  pushq   $0           # cs is ignored
ffff8000001099a3:	6a 00                	push   $0x0
  pushq   %rcx         # rip (next user insn)
ffff8000001099a5:	51                   	push   %rcx

  pushq   $0           # err
ffff8000001099a6:	6a 00                	push   $0x0
  pushq   $0           # trapno ignored
ffff8000001099a8:	6a 00                	push   $0x0

  pushq   %r15
ffff8000001099aa:	41 57                	push   %r15
  pushq   %r14
ffff8000001099ac:	41 56                	push   %r14
  pushq   %r13
ffff8000001099ae:	41 55                	push   %r13
  pushq   %r12
ffff8000001099b0:	41 54                	push   %r12
  pushq   %r11
ffff8000001099b2:	41 53                	push   %r11
  pushq   %r10
ffff8000001099b4:	41 52                	push   %r10
  pushq   %r9
ffff8000001099b6:	41 51                	push   %r9
  pushq   %r8
ffff8000001099b8:	41 50                	push   %r8
  pushq   %rdi
ffff8000001099ba:	57                   	push   %rdi
  pushq   %rsi
ffff8000001099bb:	56                   	push   %rsi
  pushq   %rbp
ffff8000001099bc:	55                   	push   %rbp
  pushq   %rdx
ffff8000001099bd:	52                   	push   %rdx
  pushq   %rcx
ffff8000001099be:	51                   	push   %rcx
  pushq   %rbx
ffff8000001099bf:	53                   	push   %rbx
  pushq   %rax
ffff8000001099c0:	50                   	push   %rax

  movq    %rsp, %rdi  # frame in arg1
ffff8000001099c1:	48 89 e7             	mov    %rsp,%rdi
  callq   syscall
ffff8000001099c4:	e8 9a e7 ff ff       	call   ffff800000108163 <syscall>

ffff8000001099c9 <syscall_trapret>:
# Return falls through to syscall_trapret...
#PAGEBREAK!

.global syscall_trapret
syscall_trapret:
  popq    %rax
ffff8000001099c9:	58                   	pop    %rax
  popq    %rbx
ffff8000001099ca:	5b                   	pop    %rbx
  popq    %rcx
ffff8000001099cb:	59                   	pop    %rcx
  popq    %rdx
ffff8000001099cc:	5a                   	pop    %rdx
  popq    %rbp
ffff8000001099cd:	5d                   	pop    %rbp
  popq    %rsi
ffff8000001099ce:	5e                   	pop    %rsi
  popq    %rdi
ffff8000001099cf:	5f                   	pop    %rdi
  popq    %r8
ffff8000001099d0:	41 58                	pop    %r8
  popq    %r9
ffff8000001099d2:	41 59                	pop    %r9
  popq    %r10
ffff8000001099d4:	41 5a                	pop    %r10
  popq    %r11
ffff8000001099d6:	41 5b                	pop    %r11
  popq    %r12
ffff8000001099d8:	41 5c                	pop    %r12
  popq    %r13
ffff8000001099da:	41 5d                	pop    %r13
  popq    %r14
ffff8000001099dc:	41 5e                	pop    %r14
  popq    %r15
ffff8000001099de:	41 5f                	pop    %r15

  addq    $40, %rsp  # discard trapnum, errorcode, rip, cs and rflags
ffff8000001099e0:	48 83 c4 28          	add    $0x28,%rsp

  # to make sure we don't get any interrupts on the user stack while in
  # supervisor mode. this is actually slightly unsafe still,
  # since some interrupts are nonmaskable.
  # See https://www.felixcloutier.com/x86/sysret
  cli
ffff8000001099e4:	fa                   	cli
  movq    (%rsp), %rsp  # restore the user stack
ffff8000001099e5:	48 8b 24 24          	mov    (%rsp),%rsp
  sysretq
ffff8000001099e9:	48 0f 07             	sysretq

ffff8000001099ec <lidt>:
{
ffff8000001099ec:	55                   	push   %rbp
ffff8000001099ed:	48 89 e5             	mov    %rsp,%rbp
ffff8000001099f0:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001099f4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff8000001099f8:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  addr_t addr = (addr_t)p;
ffff8000001099fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001099ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  pd[0] = size-1;
ffff800000109a03:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000109a06:	83 e8 01             	sub    $0x1,%eax
ffff800000109a09:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff800000109a0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a11:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff800000109a15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a19:	48 c1 e8 10          	shr    $0x10,%rax
ffff800000109a1d:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff800000109a21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a25:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000109a29:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff800000109a2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a31:	48 c1 e8 30          	shr    $0x30,%rax
ffff800000109a35:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  asm volatile("lidt (%0)" : : "r" (pd));
ffff800000109a39:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff800000109a3d:	0f 01 18             	lidt   (%rax)
}
ffff800000109a40:	90                   	nop
ffff800000109a41:	c9                   	leave
ffff800000109a42:	c3                   	ret

ffff800000109a43 <rcr2>:

static inline addr_t
rcr2(void)
{
ffff800000109a43:	55                   	push   %rbp
ffff800000109a44:	48 89 e5             	mov    %rsp,%rbp
ffff800000109a47:	48 83 ec 10          	sub    $0x10,%rsp
  addr_t val;
  asm volatile("mov %%cr2,%0" : "=r" (val));
ffff800000109a4b:	0f 20 d0             	mov    %cr2,%rax
ffff800000109a4e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return val;
ffff800000109a52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000109a56:	c9                   	leave
ffff800000109a57:	c3                   	ret

ffff800000109a58 <mkgate>:
struct spinlock tickslock;
uint ticks;

static void
mkgate(uint *idt, uint n, addr_t kva, uint pl)
{
ffff800000109a58:	55                   	push   %rbp
ffff800000109a59:	48 89 e5             	mov    %rsp,%rbp
ffff800000109a5c:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000109a60:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000109a64:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff800000109a67:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff800000109a6b:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  uint64 addr = (uint64) kva;
ffff800000109a6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000109a72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  n *= 4;
ffff800000109a76:	c1 65 e4 02          	shll   $0x2,-0x1c(%rbp)
  idt[n+0] = (addr & 0xFFFF) | (KERNEL_CS << 16);
ffff800000109a7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a7e:	0f b7 d0             	movzwl %ax,%edx
ffff800000109a81:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109a84:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff800000109a8b:	00 
ffff800000109a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109a90:	48 01 c8             	add    %rcx,%rax
ffff800000109a93:	81 ca 00 00 08 00    	or     $0x80000,%edx
ffff800000109a99:	89 10                	mov    %edx,(%rax)
  idt[n+1] = (addr & 0xFFFF0000) | 0x8E00 | ((pl & 3) << 13);
ffff800000109a9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a9f:	66 b8 00 00          	mov    $0x0,%ax
ffff800000109aa3:	89 c2                	mov    %eax,%edx
ffff800000109aa5:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000109aa8:	c1 e0 0d             	shl    $0xd,%eax
ffff800000109aab:	25 00 60 00 00       	and    $0x6000,%eax
ffff800000109ab0:	09 c2                	or     %eax,%edx
ffff800000109ab2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109ab5:	83 c0 01             	add    $0x1,%eax
ffff800000109ab8:	89 c0                	mov    %eax,%eax
ffff800000109aba:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff800000109ac1:	00 
ffff800000109ac2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109ac6:	48 01 c8             	add    %rcx,%rax
ffff800000109ac9:	80 ce 8e             	or     $0x8e,%dh
ffff800000109acc:	89 10                	mov    %edx,(%rax)
  idt[n+2] = addr >> 32;
ffff800000109ace:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109ad2:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000109ad6:	48 89 c1             	mov    %rax,%rcx
ffff800000109ad9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109adc:	83 c0 02             	add    $0x2,%eax
ffff800000109adf:	89 c0                	mov    %eax,%eax
ffff800000109ae1:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000109ae8:	00 
ffff800000109ae9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109aed:	48 01 d0             	add    %rdx,%rax
ffff800000109af0:	89 ca                	mov    %ecx,%edx
ffff800000109af2:	89 10                	mov    %edx,(%rax)
  idt[n+3] = 0;
ffff800000109af4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109af7:	83 c0 03             	add    $0x3,%eax
ffff800000109afa:	89 c0                	mov    %eax,%eax
ffff800000109afc:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000109b03:	00 
ffff800000109b04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109b08:	48 01 d0             	add    %rdx,%rax
ffff800000109b0b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
ffff800000109b11:	90                   	nop
ffff800000109b12:	c9                   	leave
ffff800000109b13:	c3                   	ret

ffff800000109b14 <idtinit>:

void idtinit(void)
{
ffff800000109b14:	55                   	push   %rbp
ffff800000109b15:	48 89 e5             	mov    %rsp,%rbp
  lidt((void*) idt, PGSIZE);
ffff800000109b18:	48 b8 c0 bc 11 00 00 	movabs $0xffff80000011bcc0,%rax
ffff800000109b1f:	80 ff ff 
ffff800000109b22:	48 8b 00             	mov    (%rax),%rax
ffff800000109b25:	be 00 10 00 00       	mov    $0x1000,%esi
ffff800000109b2a:	48 89 c7             	mov    %rax,%rdi
ffff800000109b2d:	48 b8 ec 99 10 00 00 	movabs $0xffff8000001099ec,%rax
ffff800000109b34:	80 ff ff 
ffff800000109b37:	ff d0                	call   *%rax
}
ffff800000109b39:	90                   	nop
ffff800000109b3a:	5d                   	pop    %rbp
ffff800000109b3b:	c3                   	ret

ffff800000109b3c <tvinit>:

void tvinit(void)
{
ffff800000109b3c:	55                   	push   %rbp
ffff800000109b3d:	48 89 e5             	mov    %rsp,%rbp
ffff800000109b40:	48 83 ec 10          	sub    $0x10,%rsp
  int n;
  idt = (uint*) kalloc();
ffff800000109b44:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff800000109b4b:	80 ff ff 
ffff800000109b4e:	ff d0                	call   *%rax
ffff800000109b50:	48 ba c0 bc 11 00 00 	movabs $0xffff80000011bcc0,%rdx
ffff800000109b57:	80 ff ff 
ffff800000109b5a:	48 89 02             	mov    %rax,(%rdx)
  memset(idt, 0, PGSIZE);
ffff800000109b5d:	48 b8 c0 bc 11 00 00 	movabs $0xffff80000011bcc0,%rax
ffff800000109b64:	80 ff ff 
ffff800000109b67:	48 8b 00             	mov    (%rax),%rax
ffff800000109b6a:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff800000109b6f:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000109b74:	48 89 c7             	mov    %rax,%rdi
ffff800000109b77:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff800000109b7e:	80 ff ff 
ffff800000109b81:	ff d0                	call   *%rax

  for (n = 0; n < 256; n++)
ffff800000109b83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000109b8a:	eb 3b                	jmp    ffff800000109bc7 <tvinit+0x8b>
    mkgate(idt, n, vectors[n], 0);
ffff800000109b8c:	48 ba 50 d7 10 00 00 	movabs $0xffff80000010d750,%rdx
ffff800000109b93:	80 ff ff 
ffff800000109b96:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109b99:	48 98                	cltq
ffff800000109b9b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
ffff800000109b9f:	8b 75 fc             	mov    -0x4(%rbp),%esi
ffff800000109ba2:	48 b8 c0 bc 11 00 00 	movabs $0xffff80000011bcc0,%rax
ffff800000109ba9:	80 ff ff 
ffff800000109bac:	48 8b 00             	mov    (%rax),%rax
ffff800000109baf:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff800000109bb4:	48 89 c7             	mov    %rax,%rdi
ffff800000109bb7:	48 b8 58 9a 10 00 00 	movabs $0xffff800000109a58,%rax
ffff800000109bbe:	80 ff ff 
ffff800000109bc1:	ff d0                	call   *%rax
  for (n = 0; n < 256; n++)
ffff800000109bc3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000109bc7:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
ffff800000109bce:	7e bc                	jle    ffff800000109b8c <tvinit+0x50>
}
ffff800000109bd0:	90                   	nop
ffff800000109bd1:	90                   	nop
ffff800000109bd2:	c9                   	leave
ffff800000109bd3:	c3                   	ret

ffff800000109bd4 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
ffff800000109bd4:	55                   	push   %rbp
ffff800000109bd5:	48 89 e5             	mov    %rsp,%rbp
ffff800000109bd8:	41 54                	push   %r12
ffff800000109bda:	53                   	push   %rbx
ffff800000109bdb:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000109bdf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  switch(tf->trapno){
ffff800000109be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109be7:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109beb:	48 83 f8 3f          	cmp    $0x3f,%rax
ffff800000109bef:	0f 84 4d 01 00 00    	je     ffff800000109d42 <trap+0x16e>
ffff800000109bf5:	48 83 f8 3f          	cmp    $0x3f,%rax
ffff800000109bf9:	0f 87 9d 01 00 00    	ja     ffff800000109d9c <trap+0x1c8>
ffff800000109bff:	48 83 f8 2f          	cmp    $0x2f,%rax
ffff800000109c03:	0f 84 0d 04 00 00    	je     ffff80000010a016 <trap+0x442>
ffff800000109c09:	48 83 f8 2f          	cmp    $0x2f,%rax
ffff800000109c0d:	0f 87 89 01 00 00    	ja     ffff800000109d9c <trap+0x1c8>
ffff800000109c13:	48 83 f8 2e          	cmp    $0x2e,%rax
ffff800000109c17:	0f 84 ce 00 00 00    	je     ffff800000109ceb <trap+0x117>
ffff800000109c1d:	48 83 f8 2e          	cmp    $0x2e,%rax
ffff800000109c21:	0f 87 75 01 00 00    	ja     ffff800000109d9c <trap+0x1c8>
ffff800000109c27:	48 83 f8 27          	cmp    $0x27,%rax
ffff800000109c2b:	0f 84 11 01 00 00    	je     ffff800000109d42 <trap+0x16e>
ffff800000109c31:	48 83 f8 27          	cmp    $0x27,%rax
ffff800000109c35:	0f 87 61 01 00 00    	ja     ffff800000109d9c <trap+0x1c8>
ffff800000109c3b:	48 83 f8 24          	cmp    $0x24,%rax
ffff800000109c3f:	0f 84 e0 00 00 00    	je     ffff800000109d25 <trap+0x151>
ffff800000109c45:	48 83 f8 24          	cmp    $0x24,%rax
ffff800000109c49:	0f 87 4d 01 00 00    	ja     ffff800000109d9c <trap+0x1c8>
ffff800000109c4f:	48 83 f8 20          	cmp    $0x20,%rax
ffff800000109c53:	74 0f                	je     ffff800000109c64 <trap+0x90>
ffff800000109c55:	48 83 f8 21          	cmp    $0x21,%rax
ffff800000109c59:	0f 84 a9 00 00 00    	je     ffff800000109d08 <trap+0x134>
ffff800000109c5f:	e9 38 01 00 00       	jmp    ffff800000109d9c <trap+0x1c8>
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
ffff800000109c64:	48 b8 89 48 10 00 00 	movabs $0xffff800000104889,%rax
ffff800000109c6b:	80 ff ff 
ffff800000109c6e:	ff d0                	call   *%rax
ffff800000109c70:	85 c0                	test   %eax,%eax
ffff800000109c72:	75 66                	jne    ffff800000109cda <trap+0x106>
      acquire(&tickslock);
ffff800000109c74:	48 b8 e0 bc 11 00 00 	movabs $0xffff80000011bce0,%rax
ffff800000109c7b:	80 ff ff 
ffff800000109c7e:	48 89 c7             	mov    %rax,%rdi
ffff800000109c81:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff800000109c88:	80 ff ff 
ffff800000109c8b:	ff d0                	call   *%rax
      ticks++;
ffff800000109c8d:	48 b8 48 bd 11 00 00 	movabs $0xffff80000011bd48,%rax
ffff800000109c94:	80 ff ff 
ffff800000109c97:	8b 00                	mov    (%rax),%eax
ffff800000109c99:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000109c9c:	48 b8 48 bd 11 00 00 	movabs $0xffff80000011bd48,%rax
ffff800000109ca3:	80 ff ff 
ffff800000109ca6:	89 10                	mov    %edx,(%rax)
      wakeup(&ticks);
ffff800000109ca8:	48 b8 48 bd 11 00 00 	movabs $0xffff80000011bd48,%rax
ffff800000109caf:	80 ff ff 
ffff800000109cb2:	48 89 c7             	mov    %rax,%rdi
ffff800000109cb5:	48 b8 4d 72 10 00 00 	movabs $0xffff80000010724d,%rax
ffff800000109cbc:	80 ff ff 
ffff800000109cbf:	ff d0                	call   *%rax
      release(&tickslock);
ffff800000109cc1:	48 b8 e0 bc 11 00 00 	movabs $0xffff80000011bce0,%rax
ffff800000109cc8:	80 ff ff 
ffff800000109ccb:	48 89 c7             	mov    %rax,%rdi
ffff800000109cce:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff800000109cd5:	80 ff ff 
ffff800000109cd8:	ff d0                	call   *%rax
    }
    lapiceoi();
ffff800000109cda:	48 b8 91 49 10 00 00 	movabs $0xffff800000104991,%rax
ffff800000109ce1:	80 ff ff 
ffff800000109ce4:	ff d0                	call   *%rax
    break;
ffff800000109ce6:	e9 2c 03 00 00       	jmp    ffff80000010a017 <trap+0x443>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
ffff800000109ceb:	48 b8 b1 3c 10 00 00 	movabs $0xffff800000103cb1,%rax
ffff800000109cf2:	80 ff ff 
ffff800000109cf5:	ff d0                	call   *%rax
    lapiceoi();
ffff800000109cf7:	48 b8 91 49 10 00 00 	movabs $0xffff800000104991,%rax
ffff800000109cfe:	80 ff ff 
ffff800000109d01:	ff d0                	call   *%rax
    break;
ffff800000109d03:	e9 0f 03 00 00       	jmp    ffff80000010a017 <trap+0x443>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
ffff800000109d08:	48 b8 47 46 10 00 00 	movabs $0xffff800000104647,%rax
ffff800000109d0f:	80 ff ff 
ffff800000109d12:	ff d0                	call   *%rax
    lapiceoi();
ffff800000109d14:	48 b8 91 49 10 00 00 	movabs $0xffff800000104991,%rax
ffff800000109d1b:	80 ff ff 
ffff800000109d1e:	ff d0                	call   *%rax
    break;
ffff800000109d20:	e9 f2 02 00 00       	jmp    ffff80000010a017 <trap+0x443>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
ffff800000109d25:	48 b8 3f a3 10 00 00 	movabs $0xffff80000010a33f,%rax
ffff800000109d2c:	80 ff ff 
ffff800000109d2f:	ff d0                	call   *%rax
    lapiceoi();
ffff800000109d31:	48 b8 91 49 10 00 00 	movabs $0xffff800000104991,%rax
ffff800000109d38:	80 ff ff 
ffff800000109d3b:	ff d0                	call   *%rax
    break;
ffff800000109d3d:	e9 d5 02 00 00       	jmp    ffff80000010a017 <trap+0x443>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %p:%p\n",
ffff800000109d42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109d46:	4c 8b a0 88 00 00 00 	mov    0x88(%rax),%r12
ffff800000109d4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109d51:	48 8b 98 90 00 00 00 	mov    0x90(%rax),%rbx
ffff800000109d58:	48 b8 89 48 10 00 00 	movabs $0xffff800000104889,%rax
ffff800000109d5f:	80 ff ff 
ffff800000109d62:	ff d0                	call   *%rax
ffff800000109d64:	89 c6                	mov    %eax,%esi
ffff800000109d66:	48 b8 40 cc 10 00 00 	movabs $0xffff80000010cc40,%rax
ffff800000109d6d:	80 ff ff 
ffff800000109d70:	4c 89 e1             	mov    %r12,%rcx
ffff800000109d73:	48 89 da             	mov    %rbx,%rdx
ffff800000109d76:	48 89 c7             	mov    %rax,%rdi
ffff800000109d79:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109d7e:	49 b8 04 08 10 00 00 	movabs $0xffff800000100804,%r8
ffff800000109d85:	80 ff ff 
ffff800000109d88:	41 ff d0             	call   *%r8
            cpunum(), tf->cs, tf->rip);
    lapiceoi();
ffff800000109d8b:	48 b8 91 49 10 00 00 	movabs $0xffff800000104991,%rax
ffff800000109d92:	80 ff ff 
ffff800000109d95:	ff d0                	call   *%rax
    break;
ffff800000109d97:	e9 7b 02 00 00       	jmp    ffff80000010a017 <trap+0x443>

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
ffff800000109d9c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109da3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109da7:	48 85 c0             	test   %rax,%rax
ffff800000109daa:	74 17                	je     ffff800000109dc3 <trap+0x1ef>
ffff800000109dac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109db0:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff800000109db7:	83 e0 03             	and    $0x3,%eax
ffff800000109dba:	48 85 c0             	test   %rax,%rax
ffff800000109dbd:	0f 85 ac 00 00 00    	jne    ffff800000109e6f <trap+0x29b>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d rip %p (cr2=0x%p)\n",
ffff800000109dc3:	48 b8 43 9a 10 00 00 	movabs $0xffff800000109a43,%rax
ffff800000109dca:	80 ff ff 
ffff800000109dcd:	ff d0                	call   *%rax
ffff800000109dcf:	49 89 c4             	mov    %rax,%r12
ffff800000109dd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109dd6:	48 8b 98 88 00 00 00 	mov    0x88(%rax),%rbx
ffff800000109ddd:	48 b8 89 48 10 00 00 	movabs $0xffff800000104889,%rax
ffff800000109de4:	80 ff ff 
ffff800000109de7:	ff d0                	call   *%rax
ffff800000109de9:	89 c2                	mov    %eax,%edx
ffff800000109deb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109def:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109df3:	48 bf 68 cc 10 00 00 	movabs $0xffff80000010cc68,%rdi
ffff800000109dfa:	80 ff ff 
ffff800000109dfd:	4d 89 e0             	mov    %r12,%r8
ffff800000109e00:	48 89 d9             	mov    %rbx,%rcx
ffff800000109e03:	48 89 c6             	mov    %rax,%rsi
ffff800000109e06:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109e0b:	49 b9 04 08 10 00 00 	movabs $0xffff800000100804,%r9
ffff800000109e12:	80 ff ff 
ffff800000109e15:	41 ff d1             	call   *%r9
              tf->trapno, cpunum(), tf->rip, rcr2());
      if (proc)
ffff800000109e18:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109e1f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109e23:	48 85 c0             	test   %rax,%rax
ffff800000109e26:	74 2e                	je     ffff800000109e56 <trap+0x282>
        cprintf("proc id: %d\n", proc->pid);
ffff800000109e28:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109e2f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109e33:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000109e36:	48 ba 9a cc 10 00 00 	movabs $0xffff80000010cc9a,%rdx
ffff800000109e3d:	80 ff ff 
ffff800000109e40:	89 c6                	mov    %eax,%esi
ffff800000109e42:	48 89 d7             	mov    %rdx,%rdi
ffff800000109e45:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109e4a:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000109e51:	80 ff ff 
ffff800000109e54:	ff d2                	call   *%rdx
      panic("trap");
ffff800000109e56:	48 b8 a7 cc 10 00 00 	movabs $0xffff80000010cca7,%rax
ffff800000109e5d:	80 ff ff 
ffff800000109e60:	48 89 c7             	mov    %rax,%rdi
ffff800000109e63:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000109e6a:	80 ff ff 
ffff800000109e6d:	ff d0                	call   *%rax
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffff800000109e6f:	48 b8 43 9a 10 00 00 	movabs $0xffff800000109a43,%rax
ffff800000109e76:	80 ff ff 
ffff800000109e79:	ff d0                	call   *%rax
ffff800000109e7b:	48 89 c3             	mov    %rax,%rbx
ffff800000109e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109e82:	4c 8b a0 88 00 00 00 	mov    0x88(%rax),%r12
ffff800000109e89:	48 b8 89 48 10 00 00 	movabs $0xffff800000104889,%rax
ffff800000109e90:	80 ff ff 
ffff800000109e93:	ff d0                	call   *%rax
ffff800000109e95:	89 c1                	mov    %eax,%ecx
ffff800000109e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109e9b:	4c 8b 80 80 00 00 00 	mov    0x80(%rax),%r8
ffff800000109ea2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109ea6:	48 8b 50 78          	mov    0x78(%rax),%rdx
            "rip 0x%p addr 0x%p--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->rip,
ffff800000109eaa:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109eb1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109eb5:	48 8d b0 d0 00 00 00 	lea    0xd0(%rax),%rsi
ffff800000109ebc:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109ec3:	64 48 8b 00          	mov    %fs:(%rax),%rax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffff800000109ec7:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000109eca:	48 bf b0 cc 10 00 00 	movabs $0xffff80000010ccb0,%rdi
ffff800000109ed1:	80 ff ff 
ffff800000109ed4:	53                   	push   %rbx
ffff800000109ed5:	41 54                	push   %r12
ffff800000109ed7:	41 89 c9             	mov    %ecx,%r9d
ffff800000109eda:	48 89 d1             	mov    %rdx,%rcx
ffff800000109edd:	48 89 f2             	mov    %rsi,%rdx
ffff800000109ee0:	89 c6                	mov    %eax,%esi
ffff800000109ee2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109ee7:	49 ba 04 08 10 00 00 	movabs $0xffff800000100804,%r10
ffff800000109eee:	80 ff ff 
ffff800000109ef1:	41 ff d2             	call   *%r10
ffff800000109ef4:	48 83 c4 10          	add    $0x10,%rsp
            rcr2());
            
    // Log the trap event
    if(tf->trapno == T_PGFLT)
ffff800000109ef8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109efc:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109f00:	48 83 f8 0e          	cmp    $0xe,%rax
ffff800000109f04:	75 52                	jne    ffff800000109f58 <trap+0x384>
        traceevent(TRACE_TYPE_TRAP, proc->pid, tf->trapno, tf->err, 0, "pagefault");
ffff800000109f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109f0a:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
ffff800000109f11:	89 c1                	mov    %eax,%ecx
ffff800000109f13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109f17:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109f1b:	89 c6                	mov    %eax,%esi
ffff800000109f1d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109f24:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109f28:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000109f2b:	48 ba f3 cc 10 00 00 	movabs $0xffff80000010ccf3,%rdx
ffff800000109f32:	80 ff ff 
ffff800000109f35:	49 89 d1             	mov    %rdx,%r9
ffff800000109f38:	41 b8 00 00 00 00    	mov    $0x0,%r8d
ffff800000109f3e:	89 f2                	mov    %esi,%edx
ffff800000109f40:	89 c6                	mov    %eax,%esi
ffff800000109f42:	bf 03 00 00 00       	mov    $0x3,%edi
ffff800000109f47:	48 b8 d3 c2 10 00 00 	movabs $0xffff80000010c2d3,%rax
ffff800000109f4e:	80 ff ff 
ffff800000109f51:	ff d0                	call   *%rax
ffff800000109f53:	e9 aa 00 00 00       	jmp    ffff80000010a002 <trap+0x42e>
    else if(tf->trapno == T_ILLOP)
ffff800000109f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109f5c:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109f60:	48 83 f8 06          	cmp    $0x6,%rax
ffff800000109f64:	75 4f                	jne    ffff800000109fb5 <trap+0x3e1>
        traceevent(TRACE_TYPE_TRAP, proc->pid, tf->trapno, tf->err, 0, "illegalop");
ffff800000109f66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109f6a:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
ffff800000109f71:	89 c1                	mov    %eax,%ecx
ffff800000109f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109f77:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109f7b:	89 c6                	mov    %eax,%esi
ffff800000109f7d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109f84:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109f88:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000109f8b:	48 ba fd cc 10 00 00 	movabs $0xffff80000010ccfd,%rdx
ffff800000109f92:	80 ff ff 
ffff800000109f95:	49 89 d1             	mov    %rdx,%r9
ffff800000109f98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
ffff800000109f9e:	89 f2                	mov    %esi,%edx
ffff800000109fa0:	89 c6                	mov    %eax,%esi
ffff800000109fa2:	bf 03 00 00 00       	mov    $0x3,%edi
ffff800000109fa7:	48 b8 d3 c2 10 00 00 	movabs $0xffff80000010c2d3,%rax
ffff800000109fae:	80 ff ff 
ffff800000109fb1:	ff d0                	call   *%rax
ffff800000109fb3:	eb 4d                	jmp    ffff80000010a002 <trap+0x42e>
    else
        traceevent(TRACE_TYPE_TRAP, proc->pid, tf->trapno, tf->err, 0, "usertrap");
ffff800000109fb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109fb9:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
ffff800000109fc0:	89 c1                	mov    %eax,%ecx
ffff800000109fc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109fc6:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109fca:	89 c6                	mov    %eax,%esi
ffff800000109fcc:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109fd3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109fd7:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000109fda:	48 ba 07 cd 10 00 00 	movabs $0xffff80000010cd07,%rdx
ffff800000109fe1:	80 ff ff 
ffff800000109fe4:	49 89 d1             	mov    %rdx,%r9
ffff800000109fe7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
ffff800000109fed:	89 f2                	mov    %esi,%edx
ffff800000109fef:	89 c6                	mov    %eax,%esi
ffff800000109ff1:	bf 03 00 00 00       	mov    $0x3,%edi
ffff800000109ff6:	48 b8 d3 c2 10 00 00 	movabs $0xffff80000010c2d3,%rax
ffff800000109ffd:	80 ff ff 
ffff80000010a000:	ff d0                	call   *%rax
        
    proc->killed = 1;
ffff80000010a002:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a009:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a00d:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
ffff80000010a014:	eb 01                	jmp    ffff80000010a017 <trap+0x443>
    break;
ffff80000010a016:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
ffff80000010a017:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a01e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a022:	48 85 c0             	test   %rax,%rax
ffff80000010a025:	74 32                	je     ffff80000010a059 <trap+0x485>
ffff80000010a027:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a02e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a032:	8b 40 40             	mov    0x40(%rax),%eax
ffff80000010a035:	85 c0                	test   %eax,%eax
ffff80000010a037:	74 20                	je     ffff80000010a059 <trap+0x485>
ffff80000010a039:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a03d:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff80000010a044:	83 e0 03             	and    $0x3,%eax
ffff80000010a047:	48 83 f8 03          	cmp    $0x3,%rax
ffff80000010a04b:	75 0c                	jne    ffff80000010a059 <trap+0x485>
    exit();
ffff80000010a04d:	48 b8 15 6a 10 00 00 	movabs $0xffff800000106a15,%rax
ffff80000010a054:	80 ff ff 
ffff80000010a057:	ff d0                	call   *%rax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
ffff80000010a059:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a060:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a064:	48 85 c0             	test   %rax,%rax
ffff80000010a067:	74 2d                	je     ffff80000010a096 <trap+0x4c2>
ffff80000010a069:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a070:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a074:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010a077:	83 f8 04             	cmp    $0x4,%eax
ffff80000010a07a:	75 1a                	jne    ffff80000010a096 <trap+0x4c2>
ffff80000010a07c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a080:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff80000010a084:	48 83 f8 20          	cmp    $0x20,%rax
ffff80000010a088:	75 0c                	jne    ffff80000010a096 <trap+0x4c2>
    yield();
ffff80000010a08a:	48 b8 1f 70 10 00 00 	movabs $0xffff80000010701f,%rax
ffff80000010a091:	80 ff ff 
ffff80000010a094:	ff d0                	call   *%rax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
ffff80000010a096:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a09d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a0a1:	48 85 c0             	test   %rax,%rax
ffff80000010a0a4:	74 32                	je     ffff80000010a0d8 <trap+0x504>
ffff80000010a0a6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a0ad:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a0b1:	8b 40 40             	mov    0x40(%rax),%eax
ffff80000010a0b4:	85 c0                	test   %eax,%eax
ffff80000010a0b6:	74 20                	je     ffff80000010a0d8 <trap+0x504>
ffff80000010a0b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a0bc:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff80000010a0c3:	83 e0 03             	and    $0x3,%eax
ffff80000010a0c6:	48 83 f8 03          	cmp    $0x3,%rax
ffff80000010a0ca:	75 0c                	jne    ffff80000010a0d8 <trap+0x504>
    exit();
ffff80000010a0cc:	48 b8 15 6a 10 00 00 	movabs $0xffff800000106a15,%rax
ffff80000010a0d3:	80 ff ff 
ffff80000010a0d6:	ff d0                	call   *%rax
}
ffff80000010a0d8:	90                   	nop
ffff80000010a0d9:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
ffff80000010a0dd:	5b                   	pop    %rbx
ffff80000010a0de:	41 5c                	pop    %r12
ffff80000010a0e0:	5d                   	pop    %rbp
ffff80000010a0e1:	c3                   	ret

ffff80000010a0e2 <inb>:
{
ffff80000010a0e2:	55                   	push   %rbp
ffff80000010a0e3:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a0e6:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010a0ea:	89 f8                	mov    %edi,%eax
ffff80000010a0ec:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff80000010a0f0:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff80000010a0f4:	89 c2                	mov    %eax,%edx
ffff80000010a0f6:	ec                   	in     (%dx),%al
ffff80000010a0f7:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff80000010a0fa:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010a0fe:	c9                   	leave
ffff80000010a0ff:	c3                   	ret

ffff80000010a100 <outb>:
{
ffff80000010a100:	55                   	push   %rbp
ffff80000010a101:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a104:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010a108:	89 fa                	mov    %edi,%edx
ffff80000010a10a:	89 f0                	mov    %esi,%eax
ffff80000010a10c:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffff80000010a110:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff80000010a113:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff80000010a117:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff80000010a11b:	ee                   	out    %al,(%dx)
}
ffff80000010a11c:	90                   	nop
ffff80000010a11d:	c9                   	leave
ffff80000010a11e:	c3                   	ret

ffff80000010a11f <uartearlyinit>:

static int uart;    // is there a uart?

void
uartearlyinit(void)
{
ffff80000010a11f:	55                   	push   %rbp
ffff80000010a120:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a123:	48 83 ec 10          	sub    $0x10,%rsp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
ffff80000010a127:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a12c:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffff80000010a131:	48 b8 00 a1 10 00 00 	movabs $0xffff80000010a100,%rax
ffff80000010a138:	80 ff ff 
ffff80000010a13b:	ff d0                	call   *%rax

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
ffff80000010a13d:	be 80 00 00 00       	mov    $0x80,%esi
ffff80000010a142:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffff80000010a147:	48 b8 00 a1 10 00 00 	movabs $0xffff80000010a100,%rax
ffff80000010a14e:	80 ff ff 
ffff80000010a151:	ff d0                	call   *%rax
  outb(COM1+0, 115200/9600);
ffff80000010a153:	be 0c 00 00 00       	mov    $0xc,%esi
ffff80000010a158:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a15d:	48 b8 00 a1 10 00 00 	movabs $0xffff80000010a100,%rax
ffff80000010a164:	80 ff ff 
ffff80000010a167:	ff d0                	call   *%rax
  outb(COM1+1, 0);
ffff80000010a169:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a16e:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff80000010a173:	48 b8 00 a1 10 00 00 	movabs $0xffff80000010a100,%rax
ffff80000010a17a:	80 ff ff 
ffff80000010a17d:	ff d0                	call   *%rax
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
ffff80000010a17f:	be 03 00 00 00       	mov    $0x3,%esi
ffff80000010a184:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffff80000010a189:	48 b8 00 a1 10 00 00 	movabs $0xffff80000010a100,%rax
ffff80000010a190:	80 ff ff 
ffff80000010a193:	ff d0                	call   *%rax
  outb(COM1+4, 0);
ffff80000010a195:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a19a:	bf fc 03 00 00       	mov    $0x3fc,%edi
ffff80000010a19f:	48 b8 00 a1 10 00 00 	movabs $0xffff80000010a100,%rax
ffff80000010a1a6:	80 ff ff 
ffff80000010a1a9:	ff d0                	call   *%rax
  outb(COM1+1, 0x01);    // Enable receive interrupts.
ffff80000010a1ab:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010a1b0:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff80000010a1b5:	48 b8 00 a1 10 00 00 	movabs $0xffff80000010a100,%rax
ffff80000010a1bc:	80 ff ff 
ffff80000010a1bf:	ff d0                	call   *%rax

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
ffff80000010a1c1:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff80000010a1c6:	48 b8 e2 a0 10 00 00 	movabs $0xffff80000010a0e2,%rax
ffff80000010a1cd:	80 ff ff 
ffff80000010a1d0:	ff d0                	call   *%rax
ffff80000010a1d2:	3c ff                	cmp    $0xff,%al
ffff80000010a1d4:	74 4a                	je     ffff80000010a220 <uartearlyinit+0x101>
    return;
  uart = 1;
ffff80000010a1d6:	48 b8 4c bd 11 00 00 	movabs $0xffff80000011bd4c,%rax
ffff80000010a1dd:	80 ff ff 
ffff80000010a1e0:	c7 00 01 00 00 00    	movl   $0x1,(%rax)



  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
ffff80000010a1e6:	48 b8 10 cd 10 00 00 	movabs $0xffff80000010cd10,%rax
ffff80000010a1ed:	80 ff ff 
ffff80000010a1f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010a1f4:	eb 1d                	jmp    ffff80000010a213 <uartearlyinit+0xf4>
    uartputc(*p);
ffff80000010a1f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a1fa:	0f b6 00             	movzbl (%rax),%eax
ffff80000010a1fd:	0f be c0             	movsbl %al,%eax
ffff80000010a200:	89 c7                	mov    %eax,%edi
ffff80000010a202:	48 b8 74 a2 10 00 00 	movabs $0xffff80000010a274,%rax
ffff80000010a209:	80 ff ff 
ffff80000010a20c:	ff d0                	call   *%rax
  for(p="xv6...\n"; *p; p++)
ffff80000010a20e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff80000010a213:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a217:	0f b6 00             	movzbl (%rax),%eax
ffff80000010a21a:	84 c0                	test   %al,%al
ffff80000010a21c:	75 d8                	jne    ffff80000010a1f6 <uartearlyinit+0xd7>
ffff80000010a21e:	eb 01                	jmp    ffff80000010a221 <uartearlyinit+0x102>
    return;
ffff80000010a220:	90                   	nop
}
ffff80000010a221:	c9                   	leave
ffff80000010a222:	c3                   	ret

ffff80000010a223 <uartinit>:

void
uartinit(void)
{
ffff80000010a223:	55                   	push   %rbp
ffff80000010a224:	48 89 e5             	mov    %rsp,%rbp
  if(!uart)
ffff80000010a227:	48 b8 4c bd 11 00 00 	movabs $0xffff80000011bd4c,%rax
ffff80000010a22e:	80 ff ff 
ffff80000010a231:	8b 00                	mov    (%rax),%eax
ffff80000010a233:	85 c0                	test   %eax,%eax
ffff80000010a235:	74 3a                	je     ffff80000010a271 <uartinit+0x4e>
    return;

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
ffff80000010a237:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffff80000010a23c:	48 b8 e2 a0 10 00 00 	movabs $0xffff80000010a0e2,%rax
ffff80000010a243:	80 ff ff 
ffff80000010a246:	ff d0                	call   *%rax
  inb(COM1+0);
ffff80000010a248:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a24d:	48 b8 e2 a0 10 00 00 	movabs $0xffff80000010a0e2,%rax
ffff80000010a254:	80 ff ff 
ffff80000010a257:	ff d0                	call   *%rax
  ioapicenable(IRQ_COM1, 0);
ffff80000010a259:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a25e:	bf 04 00 00 00       	mov    $0x4,%edi
ffff80000010a263:	48 b8 96 40 10 00 00 	movabs $0xffff800000104096,%rax
ffff80000010a26a:	80 ff ff 
ffff80000010a26d:	ff d0                	call   *%rax
ffff80000010a26f:	eb 01                	jmp    ffff80000010a272 <uartinit+0x4f>
    return;
ffff80000010a271:	90                   	nop

}
ffff80000010a272:	5d                   	pop    %rbp
ffff80000010a273:	c3                   	ret

ffff80000010a274 <uartputc>:
void
uartputc(int c)
{
ffff80000010a274:	55                   	push   %rbp
ffff80000010a275:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a278:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010a27c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i;

  if(!uart)
ffff80000010a27f:	48 b8 4c bd 11 00 00 	movabs $0xffff80000011bd4c,%rax
ffff80000010a286:	80 ff ff 
ffff80000010a289:	8b 00                	mov    (%rax),%eax
ffff80000010a28b:	85 c0                	test   %eax,%eax
ffff80000010a28d:	74 5a                	je     ffff80000010a2e9 <uartputc+0x75>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
ffff80000010a28f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010a296:	eb 15                	jmp    ffff80000010a2ad <uartputc+0x39>
    microdelay(10);
ffff80000010a298:	bf 0a 00 00 00       	mov    $0xa,%edi
ffff80000010a29d:	48 b8 c0 49 10 00 00 	movabs $0xffff8000001049c0,%rax
ffff80000010a2a4:	80 ff ff 
ffff80000010a2a7:	ff d0                	call   *%rax
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
ffff80000010a2a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010a2ad:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff80000010a2b1:	7f 1b                	jg     ffff80000010a2ce <uartputc+0x5a>
ffff80000010a2b3:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff80000010a2b8:	48 b8 e2 a0 10 00 00 	movabs $0xffff80000010a0e2,%rax
ffff80000010a2bf:	80 ff ff 
ffff80000010a2c2:	ff d0                	call   *%rax
ffff80000010a2c4:	0f b6 c0             	movzbl %al,%eax
ffff80000010a2c7:	83 e0 20             	and    $0x20,%eax
ffff80000010a2ca:	85 c0                	test   %eax,%eax
ffff80000010a2cc:	74 ca                	je     ffff80000010a298 <uartputc+0x24>
  outb(COM1+0, c);
ffff80000010a2ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010a2d1:	0f b6 c0             	movzbl %al,%eax
ffff80000010a2d4:	89 c6                	mov    %eax,%esi
ffff80000010a2d6:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a2db:	48 b8 00 a1 10 00 00 	movabs $0xffff80000010a100,%rax
ffff80000010a2e2:	80 ff ff 
ffff80000010a2e5:	ff d0                	call   *%rax
ffff80000010a2e7:	eb 01                	jmp    ffff80000010a2ea <uartputc+0x76>
    return;
ffff80000010a2e9:	90                   	nop
}
ffff80000010a2ea:	c9                   	leave
ffff80000010a2eb:	c3                   	ret

ffff80000010a2ec <uartgetc>:

static int
uartgetc(void)
{
ffff80000010a2ec:	55                   	push   %rbp
ffff80000010a2ed:	48 89 e5             	mov    %rsp,%rbp
  if(!uart)
ffff80000010a2f0:	48 b8 4c bd 11 00 00 	movabs $0xffff80000011bd4c,%rax
ffff80000010a2f7:	80 ff ff 
ffff80000010a2fa:	8b 00                	mov    (%rax),%eax
ffff80000010a2fc:	85 c0                	test   %eax,%eax
ffff80000010a2fe:	75 07                	jne    ffff80000010a307 <uartgetc+0x1b>
    return -1;
ffff80000010a300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010a305:	eb 36                	jmp    ffff80000010a33d <uartgetc+0x51>
  if(!(inb(COM1+5) & 0x01))
ffff80000010a307:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff80000010a30c:	48 b8 e2 a0 10 00 00 	movabs $0xffff80000010a0e2,%rax
ffff80000010a313:	80 ff ff 
ffff80000010a316:	ff d0                	call   *%rax
ffff80000010a318:	0f b6 c0             	movzbl %al,%eax
ffff80000010a31b:	83 e0 01             	and    $0x1,%eax
ffff80000010a31e:	85 c0                	test   %eax,%eax
ffff80000010a320:	75 07                	jne    ffff80000010a329 <uartgetc+0x3d>
    return -1;
ffff80000010a322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010a327:	eb 14                	jmp    ffff80000010a33d <uartgetc+0x51>
  return inb(COM1+0);
ffff80000010a329:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a32e:	48 b8 e2 a0 10 00 00 	movabs $0xffff80000010a0e2,%rax
ffff80000010a335:	80 ff ff 
ffff80000010a338:	ff d0                	call   *%rax
ffff80000010a33a:	0f b6 c0             	movzbl %al,%eax
}
ffff80000010a33d:	5d                   	pop    %rbp
ffff80000010a33e:	c3                   	ret

ffff80000010a33f <uartintr>:

void
uartintr(void)
{
ffff80000010a33f:	55                   	push   %rbp
ffff80000010a340:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(uartgetc);
ffff80000010a343:	48 b8 ec a2 10 00 00 	movabs $0xffff80000010a2ec,%rax
ffff80000010a34a:	80 ff ff 
ffff80000010a34d:	48 89 c7             	mov    %rax,%rdi
ffff80000010a350:	48 b8 97 10 10 00 00 	movabs $0xffff800000101097,%rax
ffff80000010a357:	80 ff ff 
ffff80000010a35a:	ff d0                	call   *%rax
}
ffff80000010a35c:	90                   	nop
ffff80000010a35d:	5d                   	pop    %rbp
ffff80000010a35e:	c3                   	ret

ffff80000010a35f <vector0>:
# generated by vectors.pl - do not edit
# handlers
.global alltraps
vector0:
  push $0
ffff80000010a35f:	6a 00                	push   $0x0
  push $0
ffff80000010a361:	6a 00                	push   $0x0
  jmp alltraps
ffff80000010a363:	e9 d2 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a368 <vector1>:
vector1:
  push $0
ffff80000010a368:	6a 00                	push   $0x0
  push $1
ffff80000010a36a:	6a 01                	push   $0x1
  jmp alltraps
ffff80000010a36c:	e9 c9 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a371 <vector2>:
vector2:
  push $0
ffff80000010a371:	6a 00                	push   $0x0
  push $2
ffff80000010a373:	6a 02                	push   $0x2
  jmp alltraps
ffff80000010a375:	e9 c0 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a37a <vector3>:
vector3:
  push $0
ffff80000010a37a:	6a 00                	push   $0x0
  push $3
ffff80000010a37c:	6a 03                	push   $0x3
  jmp alltraps
ffff80000010a37e:	e9 b7 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a383 <vector4>:
vector4:
  push $0
ffff80000010a383:	6a 00                	push   $0x0
  push $4
ffff80000010a385:	6a 04                	push   $0x4
  jmp alltraps
ffff80000010a387:	e9 ae f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a38c <vector5>:
vector5:
  push $0
ffff80000010a38c:	6a 00                	push   $0x0
  push $5
ffff80000010a38e:	6a 05                	push   $0x5
  jmp alltraps
ffff80000010a390:	e9 a5 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a395 <vector6>:
vector6:
  push $0
ffff80000010a395:	6a 00                	push   $0x0
  push $6
ffff80000010a397:	6a 06                	push   $0x6
  jmp alltraps
ffff80000010a399:	e9 9c f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a39e <vector7>:
vector7:
  push $0
ffff80000010a39e:	6a 00                	push   $0x0
  push $7
ffff80000010a3a0:	6a 07                	push   $0x7
  jmp alltraps
ffff80000010a3a2:	e9 93 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a3a7 <vector8>:
vector8:
  push $8
ffff80000010a3a7:	6a 08                	push   $0x8
  jmp alltraps
ffff80000010a3a9:	e9 8c f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a3ae <vector9>:
vector9:
  push $0
ffff80000010a3ae:	6a 00                	push   $0x0
  push $9
ffff80000010a3b0:	6a 09                	push   $0x9
  jmp alltraps
ffff80000010a3b2:	e9 83 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a3b7 <vector10>:
vector10:
  push $10
ffff80000010a3b7:	6a 0a                	push   $0xa
  jmp alltraps
ffff80000010a3b9:	e9 7c f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a3be <vector11>:
vector11:
  push $11
ffff80000010a3be:	6a 0b                	push   $0xb
  jmp alltraps
ffff80000010a3c0:	e9 75 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a3c5 <vector12>:
vector12:
  push $12
ffff80000010a3c5:	6a 0c                	push   $0xc
  jmp alltraps
ffff80000010a3c7:	e9 6e f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a3cc <vector13>:
vector13:
  push $13
ffff80000010a3cc:	6a 0d                	push   $0xd
  jmp alltraps
ffff80000010a3ce:	e9 67 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a3d3 <vector14>:
vector14:
  push $14
ffff80000010a3d3:	6a 0e                	push   $0xe
  jmp alltraps
ffff80000010a3d5:	e9 60 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a3da <vector15>:
vector15:
  push $0
ffff80000010a3da:	6a 00                	push   $0x0
  push $15
ffff80000010a3dc:	6a 0f                	push   $0xf
  jmp alltraps
ffff80000010a3de:	e9 57 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a3e3 <vector16>:
vector16:
  push $0
ffff80000010a3e3:	6a 00                	push   $0x0
  push $16
ffff80000010a3e5:	6a 10                	push   $0x10
  jmp alltraps
ffff80000010a3e7:	e9 4e f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a3ec <vector17>:
vector17:
  push $17
ffff80000010a3ec:	6a 11                	push   $0x11
  jmp alltraps
ffff80000010a3ee:	e9 47 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a3f3 <vector18>:
vector18:
  push $0
ffff80000010a3f3:	6a 00                	push   $0x0
  push $18
ffff80000010a3f5:	6a 12                	push   $0x12
  jmp alltraps
ffff80000010a3f7:	e9 3e f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a3fc <vector19>:
vector19:
  push $0
ffff80000010a3fc:	6a 00                	push   $0x0
  push $19
ffff80000010a3fe:	6a 13                	push   $0x13
  jmp alltraps
ffff80000010a400:	e9 35 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a405 <vector20>:
vector20:
  push $0
ffff80000010a405:	6a 00                	push   $0x0
  push $20
ffff80000010a407:	6a 14                	push   $0x14
  jmp alltraps
ffff80000010a409:	e9 2c f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a40e <vector21>:
vector21:
  push $0
ffff80000010a40e:	6a 00                	push   $0x0
  push $21
ffff80000010a410:	6a 15                	push   $0x15
  jmp alltraps
ffff80000010a412:	e9 23 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a417 <vector22>:
vector22:
  push $0
ffff80000010a417:	6a 00                	push   $0x0
  push $22
ffff80000010a419:	6a 16                	push   $0x16
  jmp alltraps
ffff80000010a41b:	e9 1a f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a420 <vector23>:
vector23:
  push $0
ffff80000010a420:	6a 00                	push   $0x0
  push $23
ffff80000010a422:	6a 17                	push   $0x17
  jmp alltraps
ffff80000010a424:	e9 11 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a429 <vector24>:
vector24:
  push $0
ffff80000010a429:	6a 00                	push   $0x0
  push $24
ffff80000010a42b:	6a 18                	push   $0x18
  jmp alltraps
ffff80000010a42d:	e9 08 f5 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a432 <vector25>:
vector25:
  push $0
ffff80000010a432:	6a 00                	push   $0x0
  push $25
ffff80000010a434:	6a 19                	push   $0x19
  jmp alltraps
ffff80000010a436:	e9 ff f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a43b <vector26>:
vector26:
  push $0
ffff80000010a43b:	6a 00                	push   $0x0
  push $26
ffff80000010a43d:	6a 1a                	push   $0x1a
  jmp alltraps
ffff80000010a43f:	e9 f6 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a444 <vector27>:
vector27:
  push $0
ffff80000010a444:	6a 00                	push   $0x0
  push $27
ffff80000010a446:	6a 1b                	push   $0x1b
  jmp alltraps
ffff80000010a448:	e9 ed f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a44d <vector28>:
vector28:
  push $0
ffff80000010a44d:	6a 00                	push   $0x0
  push $28
ffff80000010a44f:	6a 1c                	push   $0x1c
  jmp alltraps
ffff80000010a451:	e9 e4 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a456 <vector29>:
vector29:
  push $0
ffff80000010a456:	6a 00                	push   $0x0
  push $29
ffff80000010a458:	6a 1d                	push   $0x1d
  jmp alltraps
ffff80000010a45a:	e9 db f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a45f <vector30>:
vector30:
  push $0
ffff80000010a45f:	6a 00                	push   $0x0
  push $30
ffff80000010a461:	6a 1e                	push   $0x1e
  jmp alltraps
ffff80000010a463:	e9 d2 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a468 <vector31>:
vector31:
  push $0
ffff80000010a468:	6a 00                	push   $0x0
  push $31
ffff80000010a46a:	6a 1f                	push   $0x1f
  jmp alltraps
ffff80000010a46c:	e9 c9 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a471 <vector32>:
vector32:
  push $0
ffff80000010a471:	6a 00                	push   $0x0
  push $32
ffff80000010a473:	6a 20                	push   $0x20
  jmp alltraps
ffff80000010a475:	e9 c0 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a47a <vector33>:
vector33:
  push $0
ffff80000010a47a:	6a 00                	push   $0x0
  push $33
ffff80000010a47c:	6a 21                	push   $0x21
  jmp alltraps
ffff80000010a47e:	e9 b7 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a483 <vector34>:
vector34:
  push $0
ffff80000010a483:	6a 00                	push   $0x0
  push $34
ffff80000010a485:	6a 22                	push   $0x22
  jmp alltraps
ffff80000010a487:	e9 ae f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a48c <vector35>:
vector35:
  push $0
ffff80000010a48c:	6a 00                	push   $0x0
  push $35
ffff80000010a48e:	6a 23                	push   $0x23
  jmp alltraps
ffff80000010a490:	e9 a5 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a495 <vector36>:
vector36:
  push $0
ffff80000010a495:	6a 00                	push   $0x0
  push $36
ffff80000010a497:	6a 24                	push   $0x24
  jmp alltraps
ffff80000010a499:	e9 9c f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a49e <vector37>:
vector37:
  push $0
ffff80000010a49e:	6a 00                	push   $0x0
  push $37
ffff80000010a4a0:	6a 25                	push   $0x25
  jmp alltraps
ffff80000010a4a2:	e9 93 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a4a7 <vector38>:
vector38:
  push $0
ffff80000010a4a7:	6a 00                	push   $0x0
  push $38
ffff80000010a4a9:	6a 26                	push   $0x26
  jmp alltraps
ffff80000010a4ab:	e9 8a f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a4b0 <vector39>:
vector39:
  push $0
ffff80000010a4b0:	6a 00                	push   $0x0
  push $39
ffff80000010a4b2:	6a 27                	push   $0x27
  jmp alltraps
ffff80000010a4b4:	e9 81 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a4b9 <vector40>:
vector40:
  push $0
ffff80000010a4b9:	6a 00                	push   $0x0
  push $40
ffff80000010a4bb:	6a 28                	push   $0x28
  jmp alltraps
ffff80000010a4bd:	e9 78 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a4c2 <vector41>:
vector41:
  push $0
ffff80000010a4c2:	6a 00                	push   $0x0
  push $41
ffff80000010a4c4:	6a 29                	push   $0x29
  jmp alltraps
ffff80000010a4c6:	e9 6f f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a4cb <vector42>:
vector42:
  push $0
ffff80000010a4cb:	6a 00                	push   $0x0
  push $42
ffff80000010a4cd:	6a 2a                	push   $0x2a
  jmp alltraps
ffff80000010a4cf:	e9 66 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a4d4 <vector43>:
vector43:
  push $0
ffff80000010a4d4:	6a 00                	push   $0x0
  push $43
ffff80000010a4d6:	6a 2b                	push   $0x2b
  jmp alltraps
ffff80000010a4d8:	e9 5d f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a4dd <vector44>:
vector44:
  push $0
ffff80000010a4dd:	6a 00                	push   $0x0
  push $44
ffff80000010a4df:	6a 2c                	push   $0x2c
  jmp alltraps
ffff80000010a4e1:	e9 54 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a4e6 <vector45>:
vector45:
  push $0
ffff80000010a4e6:	6a 00                	push   $0x0
  push $45
ffff80000010a4e8:	6a 2d                	push   $0x2d
  jmp alltraps
ffff80000010a4ea:	e9 4b f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a4ef <vector46>:
vector46:
  push $0
ffff80000010a4ef:	6a 00                	push   $0x0
  push $46
ffff80000010a4f1:	6a 2e                	push   $0x2e
  jmp alltraps
ffff80000010a4f3:	e9 42 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a4f8 <vector47>:
vector47:
  push $0
ffff80000010a4f8:	6a 00                	push   $0x0
  push $47
ffff80000010a4fa:	6a 2f                	push   $0x2f
  jmp alltraps
ffff80000010a4fc:	e9 39 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a501 <vector48>:
vector48:
  push $0
ffff80000010a501:	6a 00                	push   $0x0
  push $48
ffff80000010a503:	6a 30                	push   $0x30
  jmp alltraps
ffff80000010a505:	e9 30 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a50a <vector49>:
vector49:
  push $0
ffff80000010a50a:	6a 00                	push   $0x0
  push $49
ffff80000010a50c:	6a 31                	push   $0x31
  jmp alltraps
ffff80000010a50e:	e9 27 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a513 <vector50>:
vector50:
  push $0
ffff80000010a513:	6a 00                	push   $0x0
  push $50
ffff80000010a515:	6a 32                	push   $0x32
  jmp alltraps
ffff80000010a517:	e9 1e f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a51c <vector51>:
vector51:
  push $0
ffff80000010a51c:	6a 00                	push   $0x0
  push $51
ffff80000010a51e:	6a 33                	push   $0x33
  jmp alltraps
ffff80000010a520:	e9 15 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a525 <vector52>:
vector52:
  push $0
ffff80000010a525:	6a 00                	push   $0x0
  push $52
ffff80000010a527:	6a 34                	push   $0x34
  jmp alltraps
ffff80000010a529:	e9 0c f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a52e <vector53>:
vector53:
  push $0
ffff80000010a52e:	6a 00                	push   $0x0
  push $53
ffff80000010a530:	6a 35                	push   $0x35
  jmp alltraps
ffff80000010a532:	e9 03 f4 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a537 <vector54>:
vector54:
  push $0
ffff80000010a537:	6a 00                	push   $0x0
  push $54
ffff80000010a539:	6a 36                	push   $0x36
  jmp alltraps
ffff80000010a53b:	e9 fa f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a540 <vector55>:
vector55:
  push $0
ffff80000010a540:	6a 00                	push   $0x0
  push $55
ffff80000010a542:	6a 37                	push   $0x37
  jmp alltraps
ffff80000010a544:	e9 f1 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a549 <vector56>:
vector56:
  push $0
ffff80000010a549:	6a 00                	push   $0x0
  push $56
ffff80000010a54b:	6a 38                	push   $0x38
  jmp alltraps
ffff80000010a54d:	e9 e8 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a552 <vector57>:
vector57:
  push $0
ffff80000010a552:	6a 00                	push   $0x0
  push $57
ffff80000010a554:	6a 39                	push   $0x39
  jmp alltraps
ffff80000010a556:	e9 df f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a55b <vector58>:
vector58:
  push $0
ffff80000010a55b:	6a 00                	push   $0x0
  push $58
ffff80000010a55d:	6a 3a                	push   $0x3a
  jmp alltraps
ffff80000010a55f:	e9 d6 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a564 <vector59>:
vector59:
  push $0
ffff80000010a564:	6a 00                	push   $0x0
  push $59
ffff80000010a566:	6a 3b                	push   $0x3b
  jmp alltraps
ffff80000010a568:	e9 cd f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a56d <vector60>:
vector60:
  push $0
ffff80000010a56d:	6a 00                	push   $0x0
  push $60
ffff80000010a56f:	6a 3c                	push   $0x3c
  jmp alltraps
ffff80000010a571:	e9 c4 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a576 <vector61>:
vector61:
  push $0
ffff80000010a576:	6a 00                	push   $0x0
  push $61
ffff80000010a578:	6a 3d                	push   $0x3d
  jmp alltraps
ffff80000010a57a:	e9 bb f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a57f <vector62>:
vector62:
  push $0
ffff80000010a57f:	6a 00                	push   $0x0
  push $62
ffff80000010a581:	6a 3e                	push   $0x3e
  jmp alltraps
ffff80000010a583:	e9 b2 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a588 <vector63>:
vector63:
  push $0
ffff80000010a588:	6a 00                	push   $0x0
  push $63
ffff80000010a58a:	6a 3f                	push   $0x3f
  jmp alltraps
ffff80000010a58c:	e9 a9 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a591 <vector64>:
vector64:
  push $0
ffff80000010a591:	6a 00                	push   $0x0
  push $64
ffff80000010a593:	6a 40                	push   $0x40
  jmp alltraps
ffff80000010a595:	e9 a0 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a59a <vector65>:
vector65:
  push $0
ffff80000010a59a:	6a 00                	push   $0x0
  push $65
ffff80000010a59c:	6a 41                	push   $0x41
  jmp alltraps
ffff80000010a59e:	e9 97 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a5a3 <vector66>:
vector66:
  push $0
ffff80000010a5a3:	6a 00                	push   $0x0
  push $66
ffff80000010a5a5:	6a 42                	push   $0x42
  jmp alltraps
ffff80000010a5a7:	e9 8e f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a5ac <vector67>:
vector67:
  push $0
ffff80000010a5ac:	6a 00                	push   $0x0
  push $67
ffff80000010a5ae:	6a 43                	push   $0x43
  jmp alltraps
ffff80000010a5b0:	e9 85 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a5b5 <vector68>:
vector68:
  push $0
ffff80000010a5b5:	6a 00                	push   $0x0
  push $68
ffff80000010a5b7:	6a 44                	push   $0x44
  jmp alltraps
ffff80000010a5b9:	e9 7c f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a5be <vector69>:
vector69:
  push $0
ffff80000010a5be:	6a 00                	push   $0x0
  push $69
ffff80000010a5c0:	6a 45                	push   $0x45
  jmp alltraps
ffff80000010a5c2:	e9 73 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a5c7 <vector70>:
vector70:
  push $0
ffff80000010a5c7:	6a 00                	push   $0x0
  push $70
ffff80000010a5c9:	6a 46                	push   $0x46
  jmp alltraps
ffff80000010a5cb:	e9 6a f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a5d0 <vector71>:
vector71:
  push $0
ffff80000010a5d0:	6a 00                	push   $0x0
  push $71
ffff80000010a5d2:	6a 47                	push   $0x47
  jmp alltraps
ffff80000010a5d4:	e9 61 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a5d9 <vector72>:
vector72:
  push $0
ffff80000010a5d9:	6a 00                	push   $0x0
  push $72
ffff80000010a5db:	6a 48                	push   $0x48
  jmp alltraps
ffff80000010a5dd:	e9 58 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a5e2 <vector73>:
vector73:
  push $0
ffff80000010a5e2:	6a 00                	push   $0x0
  push $73
ffff80000010a5e4:	6a 49                	push   $0x49
  jmp alltraps
ffff80000010a5e6:	e9 4f f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a5eb <vector74>:
vector74:
  push $0
ffff80000010a5eb:	6a 00                	push   $0x0
  push $74
ffff80000010a5ed:	6a 4a                	push   $0x4a
  jmp alltraps
ffff80000010a5ef:	e9 46 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a5f4 <vector75>:
vector75:
  push $0
ffff80000010a5f4:	6a 00                	push   $0x0
  push $75
ffff80000010a5f6:	6a 4b                	push   $0x4b
  jmp alltraps
ffff80000010a5f8:	e9 3d f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a5fd <vector76>:
vector76:
  push $0
ffff80000010a5fd:	6a 00                	push   $0x0
  push $76
ffff80000010a5ff:	6a 4c                	push   $0x4c
  jmp alltraps
ffff80000010a601:	e9 34 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a606 <vector77>:
vector77:
  push $0
ffff80000010a606:	6a 00                	push   $0x0
  push $77
ffff80000010a608:	6a 4d                	push   $0x4d
  jmp alltraps
ffff80000010a60a:	e9 2b f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a60f <vector78>:
vector78:
  push $0
ffff80000010a60f:	6a 00                	push   $0x0
  push $78
ffff80000010a611:	6a 4e                	push   $0x4e
  jmp alltraps
ffff80000010a613:	e9 22 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a618 <vector79>:
vector79:
  push $0
ffff80000010a618:	6a 00                	push   $0x0
  push $79
ffff80000010a61a:	6a 4f                	push   $0x4f
  jmp alltraps
ffff80000010a61c:	e9 19 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a621 <vector80>:
vector80:
  push $0
ffff80000010a621:	6a 00                	push   $0x0
  push $80
ffff80000010a623:	6a 50                	push   $0x50
  jmp alltraps
ffff80000010a625:	e9 10 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a62a <vector81>:
vector81:
  push $0
ffff80000010a62a:	6a 00                	push   $0x0
  push $81
ffff80000010a62c:	6a 51                	push   $0x51
  jmp alltraps
ffff80000010a62e:	e9 07 f3 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a633 <vector82>:
vector82:
  push $0
ffff80000010a633:	6a 00                	push   $0x0
  push $82
ffff80000010a635:	6a 52                	push   $0x52
  jmp alltraps
ffff80000010a637:	e9 fe f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a63c <vector83>:
vector83:
  push $0
ffff80000010a63c:	6a 00                	push   $0x0
  push $83
ffff80000010a63e:	6a 53                	push   $0x53
  jmp alltraps
ffff80000010a640:	e9 f5 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a645 <vector84>:
vector84:
  push $0
ffff80000010a645:	6a 00                	push   $0x0
  push $84
ffff80000010a647:	6a 54                	push   $0x54
  jmp alltraps
ffff80000010a649:	e9 ec f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a64e <vector85>:
vector85:
  push $0
ffff80000010a64e:	6a 00                	push   $0x0
  push $85
ffff80000010a650:	6a 55                	push   $0x55
  jmp alltraps
ffff80000010a652:	e9 e3 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a657 <vector86>:
vector86:
  push $0
ffff80000010a657:	6a 00                	push   $0x0
  push $86
ffff80000010a659:	6a 56                	push   $0x56
  jmp alltraps
ffff80000010a65b:	e9 da f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a660 <vector87>:
vector87:
  push $0
ffff80000010a660:	6a 00                	push   $0x0
  push $87
ffff80000010a662:	6a 57                	push   $0x57
  jmp alltraps
ffff80000010a664:	e9 d1 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a669 <vector88>:
vector88:
  push $0
ffff80000010a669:	6a 00                	push   $0x0
  push $88
ffff80000010a66b:	6a 58                	push   $0x58
  jmp alltraps
ffff80000010a66d:	e9 c8 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a672 <vector89>:
vector89:
  push $0
ffff80000010a672:	6a 00                	push   $0x0
  push $89
ffff80000010a674:	6a 59                	push   $0x59
  jmp alltraps
ffff80000010a676:	e9 bf f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a67b <vector90>:
vector90:
  push $0
ffff80000010a67b:	6a 00                	push   $0x0
  push $90
ffff80000010a67d:	6a 5a                	push   $0x5a
  jmp alltraps
ffff80000010a67f:	e9 b6 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a684 <vector91>:
vector91:
  push $0
ffff80000010a684:	6a 00                	push   $0x0
  push $91
ffff80000010a686:	6a 5b                	push   $0x5b
  jmp alltraps
ffff80000010a688:	e9 ad f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a68d <vector92>:
vector92:
  push $0
ffff80000010a68d:	6a 00                	push   $0x0
  push $92
ffff80000010a68f:	6a 5c                	push   $0x5c
  jmp alltraps
ffff80000010a691:	e9 a4 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a696 <vector93>:
vector93:
  push $0
ffff80000010a696:	6a 00                	push   $0x0
  push $93
ffff80000010a698:	6a 5d                	push   $0x5d
  jmp alltraps
ffff80000010a69a:	e9 9b f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a69f <vector94>:
vector94:
  push $0
ffff80000010a69f:	6a 00                	push   $0x0
  push $94
ffff80000010a6a1:	6a 5e                	push   $0x5e
  jmp alltraps
ffff80000010a6a3:	e9 92 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a6a8 <vector95>:
vector95:
  push $0
ffff80000010a6a8:	6a 00                	push   $0x0
  push $95
ffff80000010a6aa:	6a 5f                	push   $0x5f
  jmp alltraps
ffff80000010a6ac:	e9 89 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a6b1 <vector96>:
vector96:
  push $0
ffff80000010a6b1:	6a 00                	push   $0x0
  push $96
ffff80000010a6b3:	6a 60                	push   $0x60
  jmp alltraps
ffff80000010a6b5:	e9 80 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a6ba <vector97>:
vector97:
  push $0
ffff80000010a6ba:	6a 00                	push   $0x0
  push $97
ffff80000010a6bc:	6a 61                	push   $0x61
  jmp alltraps
ffff80000010a6be:	e9 77 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a6c3 <vector98>:
vector98:
  push $0
ffff80000010a6c3:	6a 00                	push   $0x0
  push $98
ffff80000010a6c5:	6a 62                	push   $0x62
  jmp alltraps
ffff80000010a6c7:	e9 6e f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a6cc <vector99>:
vector99:
  push $0
ffff80000010a6cc:	6a 00                	push   $0x0
  push $99
ffff80000010a6ce:	6a 63                	push   $0x63
  jmp alltraps
ffff80000010a6d0:	e9 65 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a6d5 <vector100>:
vector100:
  push $0
ffff80000010a6d5:	6a 00                	push   $0x0
  push $100
ffff80000010a6d7:	6a 64                	push   $0x64
  jmp alltraps
ffff80000010a6d9:	e9 5c f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a6de <vector101>:
vector101:
  push $0
ffff80000010a6de:	6a 00                	push   $0x0
  push $101
ffff80000010a6e0:	6a 65                	push   $0x65
  jmp alltraps
ffff80000010a6e2:	e9 53 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a6e7 <vector102>:
vector102:
  push $0
ffff80000010a6e7:	6a 00                	push   $0x0
  push $102
ffff80000010a6e9:	6a 66                	push   $0x66
  jmp alltraps
ffff80000010a6eb:	e9 4a f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a6f0 <vector103>:
vector103:
  push $0
ffff80000010a6f0:	6a 00                	push   $0x0
  push $103
ffff80000010a6f2:	6a 67                	push   $0x67
  jmp alltraps
ffff80000010a6f4:	e9 41 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a6f9 <vector104>:
vector104:
  push $0
ffff80000010a6f9:	6a 00                	push   $0x0
  push $104
ffff80000010a6fb:	6a 68                	push   $0x68
  jmp alltraps
ffff80000010a6fd:	e9 38 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a702 <vector105>:
vector105:
  push $0
ffff80000010a702:	6a 00                	push   $0x0
  push $105
ffff80000010a704:	6a 69                	push   $0x69
  jmp alltraps
ffff80000010a706:	e9 2f f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a70b <vector106>:
vector106:
  push $0
ffff80000010a70b:	6a 00                	push   $0x0
  push $106
ffff80000010a70d:	6a 6a                	push   $0x6a
  jmp alltraps
ffff80000010a70f:	e9 26 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a714 <vector107>:
vector107:
  push $0
ffff80000010a714:	6a 00                	push   $0x0
  push $107
ffff80000010a716:	6a 6b                	push   $0x6b
  jmp alltraps
ffff80000010a718:	e9 1d f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a71d <vector108>:
vector108:
  push $0
ffff80000010a71d:	6a 00                	push   $0x0
  push $108
ffff80000010a71f:	6a 6c                	push   $0x6c
  jmp alltraps
ffff80000010a721:	e9 14 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a726 <vector109>:
vector109:
  push $0
ffff80000010a726:	6a 00                	push   $0x0
  push $109
ffff80000010a728:	6a 6d                	push   $0x6d
  jmp alltraps
ffff80000010a72a:	e9 0b f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a72f <vector110>:
vector110:
  push $0
ffff80000010a72f:	6a 00                	push   $0x0
  push $110
ffff80000010a731:	6a 6e                	push   $0x6e
  jmp alltraps
ffff80000010a733:	e9 02 f2 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a738 <vector111>:
vector111:
  push $0
ffff80000010a738:	6a 00                	push   $0x0
  push $111
ffff80000010a73a:	6a 6f                	push   $0x6f
  jmp alltraps
ffff80000010a73c:	e9 f9 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a741 <vector112>:
vector112:
  push $0
ffff80000010a741:	6a 00                	push   $0x0
  push $112
ffff80000010a743:	6a 70                	push   $0x70
  jmp alltraps
ffff80000010a745:	e9 f0 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a74a <vector113>:
vector113:
  push $0
ffff80000010a74a:	6a 00                	push   $0x0
  push $113
ffff80000010a74c:	6a 71                	push   $0x71
  jmp alltraps
ffff80000010a74e:	e9 e7 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a753 <vector114>:
vector114:
  push $0
ffff80000010a753:	6a 00                	push   $0x0
  push $114
ffff80000010a755:	6a 72                	push   $0x72
  jmp alltraps
ffff80000010a757:	e9 de f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a75c <vector115>:
vector115:
  push $0
ffff80000010a75c:	6a 00                	push   $0x0
  push $115
ffff80000010a75e:	6a 73                	push   $0x73
  jmp alltraps
ffff80000010a760:	e9 d5 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a765 <vector116>:
vector116:
  push $0
ffff80000010a765:	6a 00                	push   $0x0
  push $116
ffff80000010a767:	6a 74                	push   $0x74
  jmp alltraps
ffff80000010a769:	e9 cc f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a76e <vector117>:
vector117:
  push $0
ffff80000010a76e:	6a 00                	push   $0x0
  push $117
ffff80000010a770:	6a 75                	push   $0x75
  jmp alltraps
ffff80000010a772:	e9 c3 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a777 <vector118>:
vector118:
  push $0
ffff80000010a777:	6a 00                	push   $0x0
  push $118
ffff80000010a779:	6a 76                	push   $0x76
  jmp alltraps
ffff80000010a77b:	e9 ba f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a780 <vector119>:
vector119:
  push $0
ffff80000010a780:	6a 00                	push   $0x0
  push $119
ffff80000010a782:	6a 77                	push   $0x77
  jmp alltraps
ffff80000010a784:	e9 b1 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a789 <vector120>:
vector120:
  push $0
ffff80000010a789:	6a 00                	push   $0x0
  push $120
ffff80000010a78b:	6a 78                	push   $0x78
  jmp alltraps
ffff80000010a78d:	e9 a8 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a792 <vector121>:
vector121:
  push $0
ffff80000010a792:	6a 00                	push   $0x0
  push $121
ffff80000010a794:	6a 79                	push   $0x79
  jmp alltraps
ffff80000010a796:	e9 9f f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a79b <vector122>:
vector122:
  push $0
ffff80000010a79b:	6a 00                	push   $0x0
  push $122
ffff80000010a79d:	6a 7a                	push   $0x7a
  jmp alltraps
ffff80000010a79f:	e9 96 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a7a4 <vector123>:
vector123:
  push $0
ffff80000010a7a4:	6a 00                	push   $0x0
  push $123
ffff80000010a7a6:	6a 7b                	push   $0x7b
  jmp alltraps
ffff80000010a7a8:	e9 8d f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a7ad <vector124>:
vector124:
  push $0
ffff80000010a7ad:	6a 00                	push   $0x0
  push $124
ffff80000010a7af:	6a 7c                	push   $0x7c
  jmp alltraps
ffff80000010a7b1:	e9 84 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a7b6 <vector125>:
vector125:
  push $0
ffff80000010a7b6:	6a 00                	push   $0x0
  push $125
ffff80000010a7b8:	6a 7d                	push   $0x7d
  jmp alltraps
ffff80000010a7ba:	e9 7b f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a7bf <vector126>:
vector126:
  push $0
ffff80000010a7bf:	6a 00                	push   $0x0
  push $126
ffff80000010a7c1:	6a 7e                	push   $0x7e
  jmp alltraps
ffff80000010a7c3:	e9 72 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a7c8 <vector127>:
vector127:
  push $0
ffff80000010a7c8:	6a 00                	push   $0x0
  push $127
ffff80000010a7ca:	6a 7f                	push   $0x7f
  jmp alltraps
ffff80000010a7cc:	e9 69 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a7d1 <vector128>:
vector128:
  push $0
ffff80000010a7d1:	6a 00                	push   $0x0
  push $128
ffff80000010a7d3:	68 80 00 00 00       	push   $0x80
  jmp alltraps
ffff80000010a7d8:	e9 5d f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a7dd <vector129>:
vector129:
  push $0
ffff80000010a7dd:	6a 00                	push   $0x0
  push $129
ffff80000010a7df:	68 81 00 00 00       	push   $0x81
  jmp alltraps
ffff80000010a7e4:	e9 51 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a7e9 <vector130>:
vector130:
  push $0
ffff80000010a7e9:	6a 00                	push   $0x0
  push $130
ffff80000010a7eb:	68 82 00 00 00       	push   $0x82
  jmp alltraps
ffff80000010a7f0:	e9 45 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a7f5 <vector131>:
vector131:
  push $0
ffff80000010a7f5:	6a 00                	push   $0x0
  push $131
ffff80000010a7f7:	68 83 00 00 00       	push   $0x83
  jmp alltraps
ffff80000010a7fc:	e9 39 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a801 <vector132>:
vector132:
  push $0
ffff80000010a801:	6a 00                	push   $0x0
  push $132
ffff80000010a803:	68 84 00 00 00       	push   $0x84
  jmp alltraps
ffff80000010a808:	e9 2d f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a80d <vector133>:
vector133:
  push $0
ffff80000010a80d:	6a 00                	push   $0x0
  push $133
ffff80000010a80f:	68 85 00 00 00       	push   $0x85
  jmp alltraps
ffff80000010a814:	e9 21 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a819 <vector134>:
vector134:
  push $0
ffff80000010a819:	6a 00                	push   $0x0
  push $134
ffff80000010a81b:	68 86 00 00 00       	push   $0x86
  jmp alltraps
ffff80000010a820:	e9 15 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a825 <vector135>:
vector135:
  push $0
ffff80000010a825:	6a 00                	push   $0x0
  push $135
ffff80000010a827:	68 87 00 00 00       	push   $0x87
  jmp alltraps
ffff80000010a82c:	e9 09 f1 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a831 <vector136>:
vector136:
  push $0
ffff80000010a831:	6a 00                	push   $0x0
  push $136
ffff80000010a833:	68 88 00 00 00       	push   $0x88
  jmp alltraps
ffff80000010a838:	e9 fd f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a83d <vector137>:
vector137:
  push $0
ffff80000010a83d:	6a 00                	push   $0x0
  push $137
ffff80000010a83f:	68 89 00 00 00       	push   $0x89
  jmp alltraps
ffff80000010a844:	e9 f1 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a849 <vector138>:
vector138:
  push $0
ffff80000010a849:	6a 00                	push   $0x0
  push $138
ffff80000010a84b:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
ffff80000010a850:	e9 e5 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a855 <vector139>:
vector139:
  push $0
ffff80000010a855:	6a 00                	push   $0x0
  push $139
ffff80000010a857:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
ffff80000010a85c:	e9 d9 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a861 <vector140>:
vector140:
  push $0
ffff80000010a861:	6a 00                	push   $0x0
  push $140
ffff80000010a863:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
ffff80000010a868:	e9 cd f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a86d <vector141>:
vector141:
  push $0
ffff80000010a86d:	6a 00                	push   $0x0
  push $141
ffff80000010a86f:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
ffff80000010a874:	e9 c1 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a879 <vector142>:
vector142:
  push $0
ffff80000010a879:	6a 00                	push   $0x0
  push $142
ffff80000010a87b:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
ffff80000010a880:	e9 b5 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a885 <vector143>:
vector143:
  push $0
ffff80000010a885:	6a 00                	push   $0x0
  push $143
ffff80000010a887:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
ffff80000010a88c:	e9 a9 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a891 <vector144>:
vector144:
  push $0
ffff80000010a891:	6a 00                	push   $0x0
  push $144
ffff80000010a893:	68 90 00 00 00       	push   $0x90
  jmp alltraps
ffff80000010a898:	e9 9d f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a89d <vector145>:
vector145:
  push $0
ffff80000010a89d:	6a 00                	push   $0x0
  push $145
ffff80000010a89f:	68 91 00 00 00       	push   $0x91
  jmp alltraps
ffff80000010a8a4:	e9 91 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a8a9 <vector146>:
vector146:
  push $0
ffff80000010a8a9:	6a 00                	push   $0x0
  push $146
ffff80000010a8ab:	68 92 00 00 00       	push   $0x92
  jmp alltraps
ffff80000010a8b0:	e9 85 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a8b5 <vector147>:
vector147:
  push $0
ffff80000010a8b5:	6a 00                	push   $0x0
  push $147
ffff80000010a8b7:	68 93 00 00 00       	push   $0x93
  jmp alltraps
ffff80000010a8bc:	e9 79 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a8c1 <vector148>:
vector148:
  push $0
ffff80000010a8c1:	6a 00                	push   $0x0
  push $148
ffff80000010a8c3:	68 94 00 00 00       	push   $0x94
  jmp alltraps
ffff80000010a8c8:	e9 6d f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a8cd <vector149>:
vector149:
  push $0
ffff80000010a8cd:	6a 00                	push   $0x0
  push $149
ffff80000010a8cf:	68 95 00 00 00       	push   $0x95
  jmp alltraps
ffff80000010a8d4:	e9 61 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a8d9 <vector150>:
vector150:
  push $0
ffff80000010a8d9:	6a 00                	push   $0x0
  push $150
ffff80000010a8db:	68 96 00 00 00       	push   $0x96
  jmp alltraps
ffff80000010a8e0:	e9 55 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a8e5 <vector151>:
vector151:
  push $0
ffff80000010a8e5:	6a 00                	push   $0x0
  push $151
ffff80000010a8e7:	68 97 00 00 00       	push   $0x97
  jmp alltraps
ffff80000010a8ec:	e9 49 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a8f1 <vector152>:
vector152:
  push $0
ffff80000010a8f1:	6a 00                	push   $0x0
  push $152
ffff80000010a8f3:	68 98 00 00 00       	push   $0x98
  jmp alltraps
ffff80000010a8f8:	e9 3d f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a8fd <vector153>:
vector153:
  push $0
ffff80000010a8fd:	6a 00                	push   $0x0
  push $153
ffff80000010a8ff:	68 99 00 00 00       	push   $0x99
  jmp alltraps
ffff80000010a904:	e9 31 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a909 <vector154>:
vector154:
  push $0
ffff80000010a909:	6a 00                	push   $0x0
  push $154
ffff80000010a90b:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
ffff80000010a910:	e9 25 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a915 <vector155>:
vector155:
  push $0
ffff80000010a915:	6a 00                	push   $0x0
  push $155
ffff80000010a917:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
ffff80000010a91c:	e9 19 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a921 <vector156>:
vector156:
  push $0
ffff80000010a921:	6a 00                	push   $0x0
  push $156
ffff80000010a923:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
ffff80000010a928:	e9 0d f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a92d <vector157>:
vector157:
  push $0
ffff80000010a92d:	6a 00                	push   $0x0
  push $157
ffff80000010a92f:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
ffff80000010a934:	e9 01 f0 ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a939 <vector158>:
vector158:
  push $0
ffff80000010a939:	6a 00                	push   $0x0
  push $158
ffff80000010a93b:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
ffff80000010a940:	e9 f5 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a945 <vector159>:
vector159:
  push $0
ffff80000010a945:	6a 00                	push   $0x0
  push $159
ffff80000010a947:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
ffff80000010a94c:	e9 e9 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a951 <vector160>:
vector160:
  push $0
ffff80000010a951:	6a 00                	push   $0x0
  push $160
ffff80000010a953:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
ffff80000010a958:	e9 dd ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a95d <vector161>:
vector161:
  push $0
ffff80000010a95d:	6a 00                	push   $0x0
  push $161
ffff80000010a95f:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
ffff80000010a964:	e9 d1 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a969 <vector162>:
vector162:
  push $0
ffff80000010a969:	6a 00                	push   $0x0
  push $162
ffff80000010a96b:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
ffff80000010a970:	e9 c5 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a975 <vector163>:
vector163:
  push $0
ffff80000010a975:	6a 00                	push   $0x0
  push $163
ffff80000010a977:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
ffff80000010a97c:	e9 b9 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a981 <vector164>:
vector164:
  push $0
ffff80000010a981:	6a 00                	push   $0x0
  push $164
ffff80000010a983:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
ffff80000010a988:	e9 ad ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a98d <vector165>:
vector165:
  push $0
ffff80000010a98d:	6a 00                	push   $0x0
  push $165
ffff80000010a98f:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
ffff80000010a994:	e9 a1 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a999 <vector166>:
vector166:
  push $0
ffff80000010a999:	6a 00                	push   $0x0
  push $166
ffff80000010a99b:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
ffff80000010a9a0:	e9 95 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a9a5 <vector167>:
vector167:
  push $0
ffff80000010a9a5:	6a 00                	push   $0x0
  push $167
ffff80000010a9a7:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
ffff80000010a9ac:	e9 89 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a9b1 <vector168>:
vector168:
  push $0
ffff80000010a9b1:	6a 00                	push   $0x0
  push $168
ffff80000010a9b3:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
ffff80000010a9b8:	e9 7d ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a9bd <vector169>:
vector169:
  push $0
ffff80000010a9bd:	6a 00                	push   $0x0
  push $169
ffff80000010a9bf:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
ffff80000010a9c4:	e9 71 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a9c9 <vector170>:
vector170:
  push $0
ffff80000010a9c9:	6a 00                	push   $0x0
  push $170
ffff80000010a9cb:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
ffff80000010a9d0:	e9 65 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a9d5 <vector171>:
vector171:
  push $0
ffff80000010a9d5:	6a 00                	push   $0x0
  push $171
ffff80000010a9d7:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
ffff80000010a9dc:	e9 59 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a9e1 <vector172>:
vector172:
  push $0
ffff80000010a9e1:	6a 00                	push   $0x0
  push $172
ffff80000010a9e3:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
ffff80000010a9e8:	e9 4d ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a9ed <vector173>:
vector173:
  push $0
ffff80000010a9ed:	6a 00                	push   $0x0
  push $173
ffff80000010a9ef:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
ffff80000010a9f4:	e9 41 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010a9f9 <vector174>:
vector174:
  push $0
ffff80000010a9f9:	6a 00                	push   $0x0
  push $174
ffff80000010a9fb:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
ffff80000010aa00:	e9 35 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa05 <vector175>:
vector175:
  push $0
ffff80000010aa05:	6a 00                	push   $0x0
  push $175
ffff80000010aa07:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
ffff80000010aa0c:	e9 29 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa11 <vector176>:
vector176:
  push $0
ffff80000010aa11:	6a 00                	push   $0x0
  push $176
ffff80000010aa13:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
ffff80000010aa18:	e9 1d ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa1d <vector177>:
vector177:
  push $0
ffff80000010aa1d:	6a 00                	push   $0x0
  push $177
ffff80000010aa1f:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
ffff80000010aa24:	e9 11 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa29 <vector178>:
vector178:
  push $0
ffff80000010aa29:	6a 00                	push   $0x0
  push $178
ffff80000010aa2b:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
ffff80000010aa30:	e9 05 ef ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa35 <vector179>:
vector179:
  push $0
ffff80000010aa35:	6a 00                	push   $0x0
  push $179
ffff80000010aa37:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
ffff80000010aa3c:	e9 f9 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa41 <vector180>:
vector180:
  push $0
ffff80000010aa41:	6a 00                	push   $0x0
  push $180
ffff80000010aa43:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
ffff80000010aa48:	e9 ed ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa4d <vector181>:
vector181:
  push $0
ffff80000010aa4d:	6a 00                	push   $0x0
  push $181
ffff80000010aa4f:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
ffff80000010aa54:	e9 e1 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa59 <vector182>:
vector182:
  push $0
ffff80000010aa59:	6a 00                	push   $0x0
  push $182
ffff80000010aa5b:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
ffff80000010aa60:	e9 d5 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa65 <vector183>:
vector183:
  push $0
ffff80000010aa65:	6a 00                	push   $0x0
  push $183
ffff80000010aa67:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
ffff80000010aa6c:	e9 c9 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa71 <vector184>:
vector184:
  push $0
ffff80000010aa71:	6a 00                	push   $0x0
  push $184
ffff80000010aa73:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
ffff80000010aa78:	e9 bd ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa7d <vector185>:
vector185:
  push $0
ffff80000010aa7d:	6a 00                	push   $0x0
  push $185
ffff80000010aa7f:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
ffff80000010aa84:	e9 b1 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa89 <vector186>:
vector186:
  push $0
ffff80000010aa89:	6a 00                	push   $0x0
  push $186
ffff80000010aa8b:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
ffff80000010aa90:	e9 a5 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aa95 <vector187>:
vector187:
  push $0
ffff80000010aa95:	6a 00                	push   $0x0
  push $187
ffff80000010aa97:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
ffff80000010aa9c:	e9 99 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aaa1 <vector188>:
vector188:
  push $0
ffff80000010aaa1:	6a 00                	push   $0x0
  push $188
ffff80000010aaa3:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
ffff80000010aaa8:	e9 8d ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aaad <vector189>:
vector189:
  push $0
ffff80000010aaad:	6a 00                	push   $0x0
  push $189
ffff80000010aaaf:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
ffff80000010aab4:	e9 81 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aab9 <vector190>:
vector190:
  push $0
ffff80000010aab9:	6a 00                	push   $0x0
  push $190
ffff80000010aabb:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
ffff80000010aac0:	e9 75 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aac5 <vector191>:
vector191:
  push $0
ffff80000010aac5:	6a 00                	push   $0x0
  push $191
ffff80000010aac7:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
ffff80000010aacc:	e9 69 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aad1 <vector192>:
vector192:
  push $0
ffff80000010aad1:	6a 00                	push   $0x0
  push $192
ffff80000010aad3:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
ffff80000010aad8:	e9 5d ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aadd <vector193>:
vector193:
  push $0
ffff80000010aadd:	6a 00                	push   $0x0
  push $193
ffff80000010aadf:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
ffff80000010aae4:	e9 51 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aae9 <vector194>:
vector194:
  push $0
ffff80000010aae9:	6a 00                	push   $0x0
  push $194
ffff80000010aaeb:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
ffff80000010aaf0:	e9 45 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aaf5 <vector195>:
vector195:
  push $0
ffff80000010aaf5:	6a 00                	push   $0x0
  push $195
ffff80000010aaf7:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
ffff80000010aafc:	e9 39 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab01 <vector196>:
vector196:
  push $0
ffff80000010ab01:	6a 00                	push   $0x0
  push $196
ffff80000010ab03:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
ffff80000010ab08:	e9 2d ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab0d <vector197>:
vector197:
  push $0
ffff80000010ab0d:	6a 00                	push   $0x0
  push $197
ffff80000010ab0f:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
ffff80000010ab14:	e9 21 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab19 <vector198>:
vector198:
  push $0
ffff80000010ab19:	6a 00                	push   $0x0
  push $198
ffff80000010ab1b:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
ffff80000010ab20:	e9 15 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab25 <vector199>:
vector199:
  push $0
ffff80000010ab25:	6a 00                	push   $0x0
  push $199
ffff80000010ab27:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
ffff80000010ab2c:	e9 09 ee ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab31 <vector200>:
vector200:
  push $0
ffff80000010ab31:	6a 00                	push   $0x0
  push $200
ffff80000010ab33:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
ffff80000010ab38:	e9 fd ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab3d <vector201>:
vector201:
  push $0
ffff80000010ab3d:	6a 00                	push   $0x0
  push $201
ffff80000010ab3f:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
ffff80000010ab44:	e9 f1 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab49 <vector202>:
vector202:
  push $0
ffff80000010ab49:	6a 00                	push   $0x0
  push $202
ffff80000010ab4b:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
ffff80000010ab50:	e9 e5 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab55 <vector203>:
vector203:
  push $0
ffff80000010ab55:	6a 00                	push   $0x0
  push $203
ffff80000010ab57:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
ffff80000010ab5c:	e9 d9 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab61 <vector204>:
vector204:
  push $0
ffff80000010ab61:	6a 00                	push   $0x0
  push $204
ffff80000010ab63:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
ffff80000010ab68:	e9 cd ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab6d <vector205>:
vector205:
  push $0
ffff80000010ab6d:	6a 00                	push   $0x0
  push $205
ffff80000010ab6f:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
ffff80000010ab74:	e9 c1 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab79 <vector206>:
vector206:
  push $0
ffff80000010ab79:	6a 00                	push   $0x0
  push $206
ffff80000010ab7b:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
ffff80000010ab80:	e9 b5 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab85 <vector207>:
vector207:
  push $0
ffff80000010ab85:	6a 00                	push   $0x0
  push $207
ffff80000010ab87:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
ffff80000010ab8c:	e9 a9 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab91 <vector208>:
vector208:
  push $0
ffff80000010ab91:	6a 00                	push   $0x0
  push $208
ffff80000010ab93:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
ffff80000010ab98:	e9 9d ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ab9d <vector209>:
vector209:
  push $0
ffff80000010ab9d:	6a 00                	push   $0x0
  push $209
ffff80000010ab9f:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
ffff80000010aba4:	e9 91 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aba9 <vector210>:
vector210:
  push $0
ffff80000010aba9:	6a 00                	push   $0x0
  push $210
ffff80000010abab:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
ffff80000010abb0:	e9 85 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010abb5 <vector211>:
vector211:
  push $0
ffff80000010abb5:	6a 00                	push   $0x0
  push $211
ffff80000010abb7:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
ffff80000010abbc:	e9 79 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010abc1 <vector212>:
vector212:
  push $0
ffff80000010abc1:	6a 00                	push   $0x0
  push $212
ffff80000010abc3:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
ffff80000010abc8:	e9 6d ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010abcd <vector213>:
vector213:
  push $0
ffff80000010abcd:	6a 00                	push   $0x0
  push $213
ffff80000010abcf:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
ffff80000010abd4:	e9 61 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010abd9 <vector214>:
vector214:
  push $0
ffff80000010abd9:	6a 00                	push   $0x0
  push $214
ffff80000010abdb:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
ffff80000010abe0:	e9 55 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010abe5 <vector215>:
vector215:
  push $0
ffff80000010abe5:	6a 00                	push   $0x0
  push $215
ffff80000010abe7:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
ffff80000010abec:	e9 49 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010abf1 <vector216>:
vector216:
  push $0
ffff80000010abf1:	6a 00                	push   $0x0
  push $216
ffff80000010abf3:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
ffff80000010abf8:	e9 3d ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010abfd <vector217>:
vector217:
  push $0
ffff80000010abfd:	6a 00                	push   $0x0
  push $217
ffff80000010abff:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
ffff80000010ac04:	e9 31 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac09 <vector218>:
vector218:
  push $0
ffff80000010ac09:	6a 00                	push   $0x0
  push $218
ffff80000010ac0b:	68 da 00 00 00       	push   $0xda
  jmp alltraps
ffff80000010ac10:	e9 25 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac15 <vector219>:
vector219:
  push $0
ffff80000010ac15:	6a 00                	push   $0x0
  push $219
ffff80000010ac17:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
ffff80000010ac1c:	e9 19 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac21 <vector220>:
vector220:
  push $0
ffff80000010ac21:	6a 00                	push   $0x0
  push $220
ffff80000010ac23:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
ffff80000010ac28:	e9 0d ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac2d <vector221>:
vector221:
  push $0
ffff80000010ac2d:	6a 00                	push   $0x0
  push $221
ffff80000010ac2f:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
ffff80000010ac34:	e9 01 ed ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac39 <vector222>:
vector222:
  push $0
ffff80000010ac39:	6a 00                	push   $0x0
  push $222
ffff80000010ac3b:	68 de 00 00 00       	push   $0xde
  jmp alltraps
ffff80000010ac40:	e9 f5 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac45 <vector223>:
vector223:
  push $0
ffff80000010ac45:	6a 00                	push   $0x0
  push $223
ffff80000010ac47:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
ffff80000010ac4c:	e9 e9 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac51 <vector224>:
vector224:
  push $0
ffff80000010ac51:	6a 00                	push   $0x0
  push $224
ffff80000010ac53:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
ffff80000010ac58:	e9 dd ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac5d <vector225>:
vector225:
  push $0
ffff80000010ac5d:	6a 00                	push   $0x0
  push $225
ffff80000010ac5f:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
ffff80000010ac64:	e9 d1 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac69 <vector226>:
vector226:
  push $0
ffff80000010ac69:	6a 00                	push   $0x0
  push $226
ffff80000010ac6b:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
ffff80000010ac70:	e9 c5 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac75 <vector227>:
vector227:
  push $0
ffff80000010ac75:	6a 00                	push   $0x0
  push $227
ffff80000010ac77:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
ffff80000010ac7c:	e9 b9 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac81 <vector228>:
vector228:
  push $0
ffff80000010ac81:	6a 00                	push   $0x0
  push $228
ffff80000010ac83:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
ffff80000010ac88:	e9 ad ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac8d <vector229>:
vector229:
  push $0
ffff80000010ac8d:	6a 00                	push   $0x0
  push $229
ffff80000010ac8f:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
ffff80000010ac94:	e9 a1 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ac99 <vector230>:
vector230:
  push $0
ffff80000010ac99:	6a 00                	push   $0x0
  push $230
ffff80000010ac9b:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
ffff80000010aca0:	e9 95 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aca5 <vector231>:
vector231:
  push $0
ffff80000010aca5:	6a 00                	push   $0x0
  push $231
ffff80000010aca7:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
ffff80000010acac:	e9 89 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010acb1 <vector232>:
vector232:
  push $0
ffff80000010acb1:	6a 00                	push   $0x0
  push $232
ffff80000010acb3:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
ffff80000010acb8:	e9 7d ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010acbd <vector233>:
vector233:
  push $0
ffff80000010acbd:	6a 00                	push   $0x0
  push $233
ffff80000010acbf:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
ffff80000010acc4:	e9 71 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010acc9 <vector234>:
vector234:
  push $0
ffff80000010acc9:	6a 00                	push   $0x0
  push $234
ffff80000010accb:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
ffff80000010acd0:	e9 65 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010acd5 <vector235>:
vector235:
  push $0
ffff80000010acd5:	6a 00                	push   $0x0
  push $235
ffff80000010acd7:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
ffff80000010acdc:	e9 59 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ace1 <vector236>:
vector236:
  push $0
ffff80000010ace1:	6a 00                	push   $0x0
  push $236
ffff80000010ace3:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
ffff80000010ace8:	e9 4d ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010aced <vector237>:
vector237:
  push $0
ffff80000010aced:	6a 00                	push   $0x0
  push $237
ffff80000010acef:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
ffff80000010acf4:	e9 41 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010acf9 <vector238>:
vector238:
  push $0
ffff80000010acf9:	6a 00                	push   $0x0
  push $238
ffff80000010acfb:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
ffff80000010ad00:	e9 35 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad05 <vector239>:
vector239:
  push $0
ffff80000010ad05:	6a 00                	push   $0x0
  push $239
ffff80000010ad07:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
ffff80000010ad0c:	e9 29 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad11 <vector240>:
vector240:
  push $0
ffff80000010ad11:	6a 00                	push   $0x0
  push $240
ffff80000010ad13:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
ffff80000010ad18:	e9 1d ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad1d <vector241>:
vector241:
  push $0
ffff80000010ad1d:	6a 00                	push   $0x0
  push $241
ffff80000010ad1f:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
ffff80000010ad24:	e9 11 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad29 <vector242>:
vector242:
  push $0
ffff80000010ad29:	6a 00                	push   $0x0
  push $242
ffff80000010ad2b:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
ffff80000010ad30:	e9 05 ec ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad35 <vector243>:
vector243:
  push $0
ffff80000010ad35:	6a 00                	push   $0x0
  push $243
ffff80000010ad37:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
ffff80000010ad3c:	e9 f9 eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad41 <vector244>:
vector244:
  push $0
ffff80000010ad41:	6a 00                	push   $0x0
  push $244
ffff80000010ad43:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
ffff80000010ad48:	e9 ed eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad4d <vector245>:
vector245:
  push $0
ffff80000010ad4d:	6a 00                	push   $0x0
  push $245
ffff80000010ad4f:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
ffff80000010ad54:	e9 e1 eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad59 <vector246>:
vector246:
  push $0
ffff80000010ad59:	6a 00                	push   $0x0
  push $246
ffff80000010ad5b:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
ffff80000010ad60:	e9 d5 eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad65 <vector247>:
vector247:
  push $0
ffff80000010ad65:	6a 00                	push   $0x0
  push $247
ffff80000010ad67:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
ffff80000010ad6c:	e9 c9 eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad71 <vector248>:
vector248:
  push $0
ffff80000010ad71:	6a 00                	push   $0x0
  push $248
ffff80000010ad73:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
ffff80000010ad78:	e9 bd eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad7d <vector249>:
vector249:
  push $0
ffff80000010ad7d:	6a 00                	push   $0x0
  push $249
ffff80000010ad7f:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
ffff80000010ad84:	e9 b1 eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad89 <vector250>:
vector250:
  push $0
ffff80000010ad89:	6a 00                	push   $0x0
  push $250
ffff80000010ad8b:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
ffff80000010ad90:	e9 a5 eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ad95 <vector251>:
vector251:
  push $0
ffff80000010ad95:	6a 00                	push   $0x0
  push $251
ffff80000010ad97:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
ffff80000010ad9c:	e9 99 eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010ada1 <vector252>:
vector252:
  push $0
ffff80000010ada1:	6a 00                	push   $0x0
  push $252
ffff80000010ada3:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
ffff80000010ada8:	e9 8d eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010adad <vector253>:
vector253:
  push $0
ffff80000010adad:	6a 00                	push   $0x0
  push $253
ffff80000010adaf:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
ffff80000010adb4:	e9 81 eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010adb9 <vector254>:
vector254:
  push $0
ffff80000010adb9:	6a 00                	push   $0x0
  push $254
ffff80000010adbb:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
ffff80000010adc0:	e9 75 eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010adc5 <vector255>:
vector255:
  push $0
ffff80000010adc5:	6a 00                	push   $0x0
  push $255
ffff80000010adc7:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
ffff80000010adcc:	e9 69 eb ff ff       	jmp    ffff80000010993a <alltraps>

ffff80000010add1 <lgdt>:
{
ffff80000010add1:	55                   	push   %rbp
ffff80000010add2:	48 89 e5             	mov    %rsp,%rbp
ffff80000010add5:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010add9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010addd:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  addr_t addr = (addr_t)p;
ffff80000010ade0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010ade4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  pd[0] = size-1;
ffff80000010ade8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff80000010adeb:	83 e8 01             	sub    $0x1,%eax
ffff80000010adee:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff80000010adf2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010adf6:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff80000010adfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010adfe:	48 c1 e8 10          	shr    $0x10,%rax
ffff80000010ae02:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff80000010ae06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ae0a:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010ae0e:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff80000010ae12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ae16:	48 c1 e8 30          	shr    $0x30,%rax
ffff80000010ae1a:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  asm volatile("lgdt (%0)" : : "r" (pd));
ffff80000010ae1e:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff80000010ae22:	0f 01 10             	lgdt   (%rax)
}
ffff80000010ae25:	90                   	nop
ffff80000010ae26:	c9                   	leave
ffff80000010ae27:	c3                   	ret

ffff80000010ae28 <ltr>:
{
ffff80000010ae28:	55                   	push   %rbp
ffff80000010ae29:	48 89 e5             	mov    %rsp,%rbp
ffff80000010ae2c:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010ae30:	89 f8                	mov    %edi,%eax
ffff80000010ae32:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  asm volatile("ltr %0" : : "r" (sel));
ffff80000010ae36:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
ffff80000010ae3a:	0f 00 d8             	ltr    %eax
}
ffff80000010ae3d:	90                   	nop
ffff80000010ae3e:	c9                   	leave
ffff80000010ae3f:	c3                   	ret

ffff80000010ae40 <lcr3>:

static inline void
lcr3(addr_t val)
{
ffff80000010ae40:	55                   	push   %rbp
ffff80000010ae41:	48 89 e5             	mov    %rsp,%rbp
ffff80000010ae44:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010ae48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  asm volatile("mov %0,%%cr3" : : "r" (val));
ffff80000010ae4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ae50:	0f 22 d8             	mov    %rax,%cr3
}
ffff80000010ae53:	90                   	nop
ffff80000010ae54:	c9                   	leave
ffff80000010ae55:	c3                   	ret

ffff80000010ae56 <v2p>:
static inline addr_t v2p(void *a) {
ffff80000010ae56:	55                   	push   %rbp
ffff80000010ae57:	48 89 e5             	mov    %rsp,%rbp
ffff80000010ae5a:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010ae5e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return ((addr_t) (a)) - ((addr_t)KERNBASE);
ffff80000010ae62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ae66:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010ae6d:	80 00 00 
ffff80000010ae70:	48 01 d0             	add    %rdx,%rax
}
ffff80000010ae73:	c9                   	leave
ffff80000010ae74:	c3                   	ret

ffff80000010ae75 <syscallinit>:
static pml4e_t *kpml4;
static pdpe_t *kpdpt;

void
syscallinit(void)
{
ffff80000010ae75:	55                   	push   %rbp
ffff80000010ae76:	48 89 e5             	mov    %rsp,%rbp
  // the MSR/SYSRET wants the segment for 32-bit user data
  // next up is 64-bit user data, then code
  // This is simply the way the sysret instruction
  // is designed to work (it assumes they follow).
  wrmsr(MSR_STAR,
ffff80000010ae79:	48 b8 00 00 00 00 08 	movabs $0x1b000800000000,%rax
ffff80000010ae80:	00 1b 00 
ffff80000010ae83:	48 89 c6             	mov    %rax,%rsi
ffff80000010ae86:	bf 81 00 00 c0       	mov    $0xc0000081,%edi
ffff80000010ae8b:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010ae92:	80 ff ff 
ffff80000010ae95:	ff d0                	call   *%rax
    ((((uint64)USER32_CS) << 48) | ((uint64)KERNEL_CS << 32)));
  wrmsr(MSR_LSTAR, (addr_t)syscall_entry);
ffff80000010ae97:	48 b8 76 99 10 00 00 	movabs $0xffff800000109976,%rax
ffff80000010ae9e:	80 ff ff 
ffff80000010aea1:	48 89 c6             	mov    %rax,%rsi
ffff80000010aea4:	bf 82 00 00 c0       	mov    $0xc0000082,%edi
ffff80000010aea9:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010aeb0:	80 ff ff 
ffff80000010aeb3:	ff d0                	call   *%rax
  wrmsr(MSR_CSTAR, (addr_t)ignore_sysret);
ffff80000010aeb5:	48 b8 11 01 10 00 00 	movabs $0xffff800000100111,%rax
ffff80000010aebc:	80 ff ff 
ffff80000010aebf:	48 89 c6             	mov    %rax,%rsi
ffff80000010aec2:	bf 83 00 00 c0       	mov    $0xc0000083,%edi
ffff80000010aec7:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010aece:	80 ff ff 
ffff80000010aed1:	ff d0                	call   *%rax

  wrmsr(MSR_SFMASK, FL_TF|FL_DF|FL_IF|FL_IOPL_3|FL_AC|FL_NT);
ffff80000010aed3:	be 00 77 04 00       	mov    $0x47700,%esi
ffff80000010aed8:	bf 84 00 00 c0       	mov    $0xc0000084,%edi
ffff80000010aedd:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010aee4:	80 ff ff 
ffff80000010aee7:	ff d0                	call   *%rax
}
ffff80000010aee9:	90                   	nop
ffff80000010aeea:	5d                   	pop    %rbp
ffff80000010aeeb:	c3                   	ret

ffff80000010aeec <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
ffff80000010aeec:	55                   	push   %rbp
ffff80000010aeed:	48 89 e5             	mov    %rsp,%rbp
ffff80000010aef0:	48 83 ec 30          	sub    $0x30,%rsp
  uint64 addr;
  void *local;
  struct cpu *c;

  // create a page for cpu local storage
  local = kalloc();
ffff80000010aef4:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff80000010aefb:	80 ff ff 
ffff80000010aefe:	ff d0                	call   *%rax
ffff80000010af00:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(local, 0, PGSIZE);
ffff80000010af04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010af08:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010af0d:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010af12:	48 89 c7             	mov    %rax,%rdi
ffff80000010af15:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff80000010af1c:	80 ff ff 
ffff80000010af1f:	ff d0                	call   *%rax

  gdt = (struct segdesc*) local;
ffff80000010af21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010af25:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  tss = (uint*) (((char*) local) + 1024);
ffff80000010af29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010af2d:	48 05 00 04 00 00    	add    $0x400,%rax
ffff80000010af33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  tss[16] = 0x00680000; // IO Map Base = End of TSS
ffff80000010af37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010af3b:	48 83 c0 40          	add    $0x40,%rax
ffff80000010af3f:	c7 00 00 00 68 00    	movl   $0x680000,(%rax)

  // point FS smack in the middle of our local storage page
  wrmsr(0xC0000100, ((uint64) local) + 2048);
ffff80000010af45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010af49:	48 05 00 08 00 00    	add    $0x800,%rax
ffff80000010af4f:	48 89 c6             	mov    %rax,%rsi
ffff80000010af52:	bf 00 01 00 c0       	mov    $0xc0000100,%edi
ffff80000010af57:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010af5e:	80 ff ff 
ffff80000010af61:	ff d0                	call   *%rax

  c = &cpus[cpunum()];
ffff80000010af63:	48 b8 89 48 10 00 00 	movabs $0xffff800000104889,%rax
ffff80000010af6a:	80 ff ff 
ffff80000010af6d:	ff d0                	call   *%rax
ffff80000010af6f:	48 63 d0             	movslq %eax,%rdx
ffff80000010af72:	48 89 d0             	mov    %rdx,%rax
ffff80000010af75:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010af79:	48 01 d0             	add    %rdx,%rax
ffff80000010af7c:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010af80:	48 ba e0 82 11 00 00 	movabs $0xffff8000001182e0,%rdx
ffff80000010af87:	80 ff ff 
ffff80000010af8a:	48 01 d0             	add    %rdx,%rax
ffff80000010af8d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  c->local = local;
ffff80000010af91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010af95:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010af99:	48 89 50 20          	mov    %rdx,0x20(%rax)

  cpu = c;
ffff80000010af9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010afa1:	64 48 89 04 25 f0 ff 	mov    %rax,%fs:0xfffffffffffffff0
ffff80000010afa8:	ff ff 
  proc = 0;
ffff80000010afaa:	64 48 c7 04 25 f8 ff 	movq   $0x0,%fs:0xfffffffffffffff8
ffff80000010afb1:	ff ff 00 00 00 00 

  addr = (uint64) tss;
ffff80000010afb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010afbb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  gdt[0] =  (struct segdesc) {};
ffff80000010afbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010afc3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  gdt[SEG_KCODE] = SEG((STA_X|STA_R), 0, 0, APP_SEG, !DPL_USER, 1);
ffff80000010afca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010afce:	48 83 c0 08          	add    $0x8,%rax
ffff80000010afd2:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010afd7:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010afdd:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010afe1:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010afe5:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010afe8:	83 ca 0a             	or     $0xa,%edx
ffff80000010afeb:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010afee:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010aff2:	83 ca 10             	or     $0x10,%edx
ffff80000010aff5:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010aff8:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010affc:	83 e2 9f             	and    $0xffffff9f,%edx
ffff80000010afff:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b002:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b006:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b009:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b00c:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b010:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b013:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b016:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b01a:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b01d:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b020:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b024:	83 ca 20             	or     $0x20,%edx
ffff80000010b027:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b02a:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b02e:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b031:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b034:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b038:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b03b:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b03e:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_KDATA] = SEG(STA_W, 0, 0, APP_SEG, !DPL_USER, 0);
ffff80000010b042:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b046:	48 83 c0 10          	add    $0x10,%rax
ffff80000010b04a:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010b04f:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010b055:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010b059:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b05d:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b060:	83 ca 02             	or     $0x2,%edx
ffff80000010b063:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b066:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b06a:	83 ca 10             	or     $0x10,%edx
ffff80000010b06d:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b070:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b074:	83 e2 9f             	and    $0xffffff9f,%edx
ffff80000010b077:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b07a:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b07e:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b081:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b084:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b088:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b08b:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b08e:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b092:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b095:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b098:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b09c:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b09f:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b0a2:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b0a6:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b0a9:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b0ac:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b0b0:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b0b3:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b0b6:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_UCODE32] = (struct segdesc) {}; // required by syscall/sysret
ffff80000010b0ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b0be:	48 83 c0 18          	add    $0x18,%rax
ffff80000010b0c2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  gdt[SEG_UDATA] = SEG(STA_W, 0, 0, APP_SEG, DPL_USER, 0);
ffff80000010b0c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b0cd:	48 83 c0 20          	add    $0x20,%rax
ffff80000010b0d1:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010b0d6:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010b0dc:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010b0e0:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b0e4:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b0e7:	83 ca 02             	or     $0x2,%edx
ffff80000010b0ea:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b0ed:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b0f1:	83 ca 10             	or     $0x10,%edx
ffff80000010b0f4:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b0f7:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b0fb:	83 ca 60             	or     $0x60,%edx
ffff80000010b0fe:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b101:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b105:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b108:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b10b:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b10f:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b112:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b115:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b119:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b11c:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b11f:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b123:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b126:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b129:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b12d:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b130:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b133:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b137:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b13a:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b13d:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_UCODE] = SEG((STA_X|STA_R), 0, 0, APP_SEG, DPL_USER, 1);
ffff80000010b141:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b145:	48 83 c0 28          	add    $0x28,%rax
ffff80000010b149:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010b14e:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010b154:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010b158:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b15c:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b15f:	83 ca 0a             	or     $0xa,%edx
ffff80000010b162:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b165:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b169:	83 ca 10             	or     $0x10,%edx
ffff80000010b16c:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b16f:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b173:	83 ca 60             	or     $0x60,%edx
ffff80000010b176:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b179:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b17d:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b180:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b183:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b187:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b18a:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b18d:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b191:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b194:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b197:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b19b:	83 ca 20             	or     $0x20,%edx
ffff80000010b19e:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b1a1:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b1a5:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b1a8:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b1ab:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b1af:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b1b2:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b1b5:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_KCPU]  = (struct segdesc) {};
ffff80000010b1b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b1bd:	48 83 c0 30          	add    $0x30,%rax
ffff80000010b1c1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  // TSS: See IA32 SDM Figure 7-4
  gdt[SEG_TSS]   = SEG(STS_T64A, 0xb, addr, !APP_SEG, DPL_USER, 0);
ffff80000010b1c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b1cc:	48 83 c0 38          	add    $0x38,%rax
ffff80000010b1d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b1d4:	89 d7                	mov    %edx,%edi
ffff80000010b1d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b1da:	48 c1 ea 10          	shr    $0x10,%rdx
ffff80000010b1de:	89 d6                	mov    %edx,%esi
ffff80000010b1e0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b1e4:	48 c1 ea 18          	shr    $0x18,%rdx
ffff80000010b1e8:	89 d1                	mov    %edx,%ecx
ffff80000010b1ea:	66 c7 00 0b 00       	movw   $0xb,(%rax)
ffff80000010b1ef:	66 89 78 02          	mov    %di,0x2(%rax)
ffff80000010b1f3:	40 88 70 04          	mov    %sil,0x4(%rax)
ffff80000010b1f7:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b1fb:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b1fe:	83 ca 09             	or     $0x9,%edx
ffff80000010b201:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b204:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b208:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b20b:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b20e:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b212:	83 ca 60             	or     $0x60,%edx
ffff80000010b215:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b218:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b21c:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b21f:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b222:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b226:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b229:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b22c:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b230:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b233:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b236:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b23a:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b23d:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b240:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b244:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b247:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b24a:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b24e:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b251:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b254:	88 48 07             	mov    %cl,0x7(%rax)
  gdt[SEG_TSS+1] = SEG(0, addr >> 32, addr >> 48, 0, 0, 0);
ffff80000010b257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b25b:	48 83 c0 40          	add    $0x40,%rax
ffff80000010b25f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b263:	48 c1 ea 20          	shr    $0x20,%rdx
ffff80000010b267:	41 89 d1             	mov    %edx,%r9d
ffff80000010b26a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b26e:	48 c1 ea 30          	shr    $0x30,%rdx
ffff80000010b272:	41 89 d0             	mov    %edx,%r8d
ffff80000010b275:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b279:	48 c1 ea 30          	shr    $0x30,%rdx
ffff80000010b27d:	48 c1 ea 10          	shr    $0x10,%rdx
ffff80000010b281:	89 d7                	mov    %edx,%edi
ffff80000010b283:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b287:	48 c1 ea 20          	shr    $0x20,%rdx
ffff80000010b28b:	48 c1 ea 3c          	shr    $0x3c,%rdx
ffff80000010b28f:	83 e2 0f             	and    $0xf,%edx
ffff80000010b292:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010b296:	48 c1 e9 30          	shr    $0x30,%rcx
ffff80000010b29a:	48 c1 e9 18          	shr    $0x18,%rcx
ffff80000010b29e:	89 ce                	mov    %ecx,%esi
ffff80000010b2a0:	66 44 89 08          	mov    %r9w,(%rax)
ffff80000010b2a4:	66 44 89 40 02       	mov    %r8w,0x2(%rax)
ffff80000010b2a9:	40 88 78 04          	mov    %dil,0x4(%rax)
ffff80000010b2ad:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b2b1:	83 e1 f0             	and    $0xfffffff0,%ecx
ffff80000010b2b4:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b2b7:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b2bb:	83 e1 ef             	and    $0xffffffef,%ecx
ffff80000010b2be:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b2c1:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b2c5:	83 e1 9f             	and    $0xffffff9f,%ecx
ffff80000010b2c8:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b2cb:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b2cf:	83 c9 80             	or     $0xffffff80,%ecx
ffff80000010b2d2:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b2d5:	89 d1                	mov    %edx,%ecx
ffff80000010b2d7:	83 e1 0f             	and    $0xf,%ecx
ffff80000010b2da:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b2de:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b2e1:	09 ca                	or     %ecx,%edx
ffff80000010b2e3:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b2e6:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b2ea:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b2ed:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b2f0:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b2f4:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b2f7:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b2fa:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b2fe:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b301:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b304:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b308:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b30b:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b30e:	40 88 70 07          	mov    %sil,0x7(%rax)

  lgdt((void*) gdt, (NSEGS+1) * sizeof(struct segdesc));
ffff80000010b312:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b316:	be 48 00 00 00       	mov    $0x48,%esi
ffff80000010b31b:	48 89 c7             	mov    %rax,%rdi
ffff80000010b31e:	48 b8 d1 ad 10 00 00 	movabs $0xffff80000010add1,%rax
ffff80000010b325:	80 ff ff 
ffff80000010b328:	ff d0                	call   *%rax

  ltr(SEG_TSS << 3);
ffff80000010b32a:	bf 38 00 00 00       	mov    $0x38,%edi
ffff80000010b32f:	48 b8 28 ae 10 00 00 	movabs $0xffff80000010ae28,%rax
ffff80000010b336:	80 ff ff 
ffff80000010b339:	ff d0                	call   *%rax
};
ffff80000010b33b:	90                   	nop
ffff80000010b33c:	c9                   	leave
ffff80000010b33d:	c3                   	ret

ffff80000010b33e <setupkvm>:
// (directly addressable from end..P2V(PHYSTOP)).


pml4e_t*
setupkvm(void)
{
ffff80000010b33e:	55                   	push   %rbp
ffff80000010b33f:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b342:	48 83 ec 10          	sub    $0x10,%rsp
  pml4e_t *pml4 = (pml4e_t*) kalloc();
ffff80000010b346:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff80000010b34d:	80 ff ff 
ffff80000010b350:	ff d0                	call   *%rax
ffff80000010b352:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(pml4, 0, PGSIZE);
ffff80000010b356:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b35a:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b35f:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b364:	48 89 c7             	mov    %rax,%rdi
ffff80000010b367:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff80000010b36e:	80 ff ff 
ffff80000010b371:	ff d0                	call   *%rax
  pml4[256] = v2p(kpdpt) | PTE_P | PTE_W;
ffff80000010b373:	48 b8 60 bd 11 00 00 	movabs $0xffff80000011bd60,%rax
ffff80000010b37a:	80 ff ff 
ffff80000010b37d:	48 8b 00             	mov    (%rax),%rax
ffff80000010b380:	48 89 c7             	mov    %rax,%rdi
ffff80000010b383:	48 b8 56 ae 10 00 00 	movabs $0xffff80000010ae56,%rax
ffff80000010b38a:	80 ff ff 
ffff80000010b38d:	ff d0                	call   *%rax
ffff80000010b38f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010b393:	48 81 c2 00 08 00 00 	add    $0x800,%rdx
ffff80000010b39a:	48 83 c8 03          	or     $0x3,%rax
ffff80000010b39e:	48 89 02             	mov    %rax,(%rdx)
  return pml4;
ffff80000010b3a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
};
ffff80000010b3a5:	c9                   	leave
ffff80000010b3a6:	c3                   	ret

ffff80000010b3a7 <kvmalloc>:
//
// linear map the first 4GB of physical memory starting
// at 0xFFFF800000000000
void
kvmalloc(void)
{
ffff80000010b3a7:	55                   	push   %rbp
ffff80000010b3a8:	48 89 e5             	mov    %rsp,%rbp
  kpml4 = (pml4e_t*) kalloc();
ffff80000010b3ab:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff80000010b3b2:	80 ff ff 
ffff80000010b3b5:	ff d0                	call   *%rax
ffff80000010b3b7:	48 ba 58 bd 11 00 00 	movabs $0xffff80000011bd58,%rdx
ffff80000010b3be:	80 ff ff 
ffff80000010b3c1:	48 89 02             	mov    %rax,(%rdx)
  memset(kpml4, 0, PGSIZE);
ffff80000010b3c4:	48 b8 58 bd 11 00 00 	movabs $0xffff80000011bd58,%rax
ffff80000010b3cb:	80 ff ff 
ffff80000010b3ce:	48 8b 00             	mov    (%rax),%rax
ffff80000010b3d1:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b3d6:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b3db:	48 89 c7             	mov    %rax,%rdi
ffff80000010b3de:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff80000010b3e5:	80 ff ff 
ffff80000010b3e8:	ff d0                	call   *%rax

  // the kernel memory region starts at KERNBASE and up
  // allocate one PDPT at the bottom of that range.
  kpdpt = (pde_t*) kalloc();
ffff80000010b3ea:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff80000010b3f1:	80 ff ff 
ffff80000010b3f4:	ff d0                	call   *%rax
ffff80000010b3f6:	48 ba 60 bd 11 00 00 	movabs $0xffff80000011bd60,%rdx
ffff80000010b3fd:	80 ff ff 
ffff80000010b400:	48 89 02             	mov    %rax,(%rdx)
  memset(kpdpt, 0, PGSIZE);
ffff80000010b403:	48 b8 60 bd 11 00 00 	movabs $0xffff80000011bd60,%rax
ffff80000010b40a:	80 ff ff 
ffff80000010b40d:	48 8b 00             	mov    (%rax),%rax
ffff80000010b410:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b415:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b41a:	48 89 c7             	mov    %rax,%rdi
ffff80000010b41d:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff80000010b424:	80 ff ff 
ffff80000010b427:	ff d0                	call   *%rax
  kpml4[PMX(KERNBASE)] = v2p(kpdpt) | PTE_P | PTE_W;
ffff80000010b429:	48 b8 60 bd 11 00 00 	movabs $0xffff80000011bd60,%rax
ffff80000010b430:	80 ff ff 
ffff80000010b433:	48 8b 00             	mov    (%rax),%rax
ffff80000010b436:	48 89 c7             	mov    %rax,%rdi
ffff80000010b439:	48 b8 56 ae 10 00 00 	movabs $0xffff80000010ae56,%rax
ffff80000010b440:	80 ff ff 
ffff80000010b443:	ff d0                	call   *%rax
ffff80000010b445:	48 ba 58 bd 11 00 00 	movabs $0xffff80000011bd58,%rdx
ffff80000010b44c:	80 ff ff 
ffff80000010b44f:	48 8b 12             	mov    (%rdx),%rdx
ffff80000010b452:	48 81 c2 00 08 00 00 	add    $0x800,%rdx
ffff80000010b459:	48 83 c8 03          	or     $0x3,%rax
ffff80000010b45d:	48 89 02             	mov    %rax,(%rdx)

  // direct map first GB of physical addresses to KERNBASE
  kpdpt[0] = 0 | PTE_PS | PTE_P | PTE_W;
ffff80000010b460:	48 b8 60 bd 11 00 00 	movabs $0xffff80000011bd60,%rax
ffff80000010b467:	80 ff ff 
ffff80000010b46a:	48 8b 00             	mov    (%rax),%rax
ffff80000010b46d:	48 c7 00 83 00 00 00 	movq   $0x83,(%rax)

  // direct map 4th GB of physical addresses to KERNBASE+3GB
  // this is a very lazy way to map IO memory (for lapic and ioapic)
  // PTE_PWT and PTE_PCD for memory mapped I/O correctness.
  kpdpt[3] = 0xC0000000 | PTE_PS | PTE_P | PTE_W | PTE_PWT | PTE_PCD;
ffff80000010b474:	48 b8 60 bd 11 00 00 	movabs $0xffff80000011bd60,%rax
ffff80000010b47b:	80 ff ff 
ffff80000010b47e:	48 8b 00             	mov    (%rax),%rax
ffff80000010b481:	48 83 c0 18          	add    $0x18,%rax
ffff80000010b485:	b9 9b 00 00 c0       	mov    $0xc000009b,%ecx
ffff80000010b48a:	48 89 08             	mov    %rcx,(%rax)

  switchkvm();
ffff80000010b48d:	48 b8 a8 b7 10 00 00 	movabs $0xffff80000010b7a8,%rax
ffff80000010b494:	80 ff ff 
ffff80000010b497:	ff d0                	call   *%rax
}
ffff80000010b499:	90                   	nop
ffff80000010b49a:	5d                   	pop    %rbp
ffff80000010b49b:	c3                   	ret

ffff80000010b49c <switchuvm>:

void
switchuvm(struct proc *p)
{
ffff80000010b49c:	55                   	push   %rbp
ffff80000010b49d:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b4a0:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010b4a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  pushcli();
ffff80000010b4a8:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff80000010b4af:	80 ff ff 
ffff80000010b4b2:	ff d0                	call   *%rax
  if(p->pgdir == 0)
ffff80000010b4b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b4b8:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010b4bc:	48 85 c0             	test   %rax,%rax
ffff80000010b4bf:	75 19                	jne    ffff80000010b4da <switchuvm+0x3e>
    panic("switchuvm: no pgdir");
ffff80000010b4c1:	48 b8 18 cd 10 00 00 	movabs $0xffff80000010cd18,%rax
ffff80000010b4c8:	80 ff ff 
ffff80000010b4cb:	48 89 c7             	mov    %rax,%rdi
ffff80000010b4ce:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010b4d5:	80 ff ff 
ffff80000010b4d8:	ff d0                	call   *%rax
  uint *tss = (uint*) (((char*) cpu->local) + 1024);
ffff80000010b4da:	64 48 8b 04 25 f0 ff 	mov    %fs:0xfffffffffffffff0,%rax
ffff80000010b4e1:	ff ff 
ffff80000010b4e3:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff80000010b4e7:	48 05 00 04 00 00    	add    $0x400,%rax
ffff80000010b4ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  const addr_t stktop = (addr_t)p->kstack + KSTACKSIZE;
ffff80000010b4f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b4f5:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff80000010b4f9:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010b4ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  tss[1] = (uint)stktop; // https://wiki.osdev.org/Task_State_Segment
ffff80000010b503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b507:	48 83 c0 04          	add    $0x4,%rax
ffff80000010b50b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010b50f:	89 10                	mov    %edx,(%rax)
  tss[2] = (uint)(stktop >> 32);
ffff80000010b511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b515:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010b519:	48 89 c2             	mov    %rax,%rdx
ffff80000010b51c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b520:	48 83 c0 08          	add    $0x8,%rax
ffff80000010b524:	89 10                	mov    %edx,(%rax)
  lcr3(v2p(p->pgdir));
ffff80000010b526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b52a:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010b52e:	48 89 c7             	mov    %rax,%rdi
ffff80000010b531:	48 b8 56 ae 10 00 00 	movabs $0xffff80000010ae56,%rax
ffff80000010b538:	80 ff ff 
ffff80000010b53b:	ff d0                	call   *%rax
ffff80000010b53d:	48 89 c7             	mov    %rax,%rdi
ffff80000010b540:	48 b8 40 ae 10 00 00 	movabs $0xffff80000010ae40,%rax
ffff80000010b547:	80 ff ff 
ffff80000010b54a:	ff d0                	call   *%rax
  popcli();
ffff80000010b54c:	48 b8 68 79 10 00 00 	movabs $0xffff800000107968,%rax
ffff80000010b553:	80 ff ff 
ffff80000010b556:	ff d0                	call   *%rax
}
ffff80000010b558:	90                   	nop
ffff80000010b559:	c9                   	leave
ffff80000010b55a:	c3                   	ret

ffff80000010b55b <walkpgdir>:
// In 64-bit mode, the page table has four levels: PML4, PDPT, PD and PT
// For each level, we dereference the correct entry, or allocate and
// initialize entry if the PTE_P bit is not set
static pte_t *
walkpgdir(pde_t *pml4, const void *va, int alloc)
{
ffff80000010b55b:	55                   	push   %rbp
ffff80000010b55c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b55f:	48 83 ec 50          	sub    $0x50,%rsp
ffff80000010b563:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff80000010b567:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
ffff80000010b56b:	89 55 bc             	mov    %edx,-0x44(%rbp)
  pml4e_t *pml4e;
  pdpe_t *pdp, *pdpe;
  pde_t *pde, *pd, *pgtab;

  // from the PML4, find or allocate the appropriate PDP table
  pml4e = &pml4[PMX(va)];
ffff80000010b56e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010b572:	48 c1 e8 27          	shr    $0x27,%rax
ffff80000010b576:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010b57b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b582:	00 
ffff80000010b583:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010b587:	48 01 d0             	add    %rdx,%rax
ffff80000010b58a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  if(*pml4e & PTE_P)
ffff80000010b58e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b592:	48 8b 00             	mov    (%rax),%rax
ffff80000010b595:	83 e0 01             	and    $0x1,%eax
ffff80000010b598:	48 85 c0             	test   %rax,%rax
ffff80000010b59b:	74 23                	je     ffff80000010b5c0 <walkpgdir+0x65>
    pdp = (pdpe_t*)P2V(PTE_ADDR(*pml4e));
ffff80000010b59d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b5a1:	48 8b 00             	mov    (%rax),%rax
ffff80000010b5a4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b5aa:	48 89 c2             	mov    %rax,%rdx
ffff80000010b5ad:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b5b4:	80 ff ff 
ffff80000010b5b7:	48 01 d0             	add    %rdx,%rax
ffff80000010b5ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010b5be:	eb 63                	jmp    ffff80000010b623 <walkpgdir+0xc8>
  else {
    if(!alloc || (pdp = (pdpe_t*)kalloc()) == 0)
ffff80000010b5c0:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010b5c4:	74 17                	je     ffff80000010b5dd <walkpgdir+0x82>
ffff80000010b5c6:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff80000010b5cd:	80 ff ff 
ffff80000010b5d0:	ff d0                	call   *%rax
ffff80000010b5d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010b5d6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010b5db:	75 0a                	jne    ffff80000010b5e7 <walkpgdir+0x8c>
      return 0;
ffff80000010b5dd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b5e2:	e9 bf 01 00 00       	jmp    ffff80000010b7a6 <walkpgdir+0x24b>
    memset(pdp, 0, PGSIZE);
ffff80000010b5e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b5eb:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b5f0:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b5f5:	48 89 c7             	mov    %rax,%rdi
ffff80000010b5f8:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff80000010b5ff:	80 ff ff 
ffff80000010b602:	ff d0                	call   *%rax
    *pml4e = V2P(pdp) | PTE_P | PTE_W | PTE_U;
ffff80000010b604:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b608:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b60f:	80 00 00 
ffff80000010b612:	48 01 d0             	add    %rdx,%rax
ffff80000010b615:	48 83 c8 07          	or     $0x7,%rax
ffff80000010b619:	48 89 c2             	mov    %rax,%rdx
ffff80000010b61c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b620:	48 89 10             	mov    %rdx,(%rax)
  }

  //from the PDP, find or allocate the appropriate PD (page directory)
  pdpe = &pdp[PDPX(va)];
ffff80000010b623:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010b627:	48 c1 e8 1e          	shr    $0x1e,%rax
ffff80000010b62b:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010b630:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b637:	00 
ffff80000010b638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b63c:	48 01 d0             	add    %rdx,%rax
ffff80000010b63f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(*pdpe & PTE_P)
ffff80000010b643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b647:	48 8b 00             	mov    (%rax),%rax
ffff80000010b64a:	83 e0 01             	and    $0x1,%eax
ffff80000010b64d:	48 85 c0             	test   %rax,%rax
ffff80000010b650:	74 23                	je     ffff80000010b675 <walkpgdir+0x11a>
    pd = (pde_t*)P2V(PTE_ADDR(*pdpe));
ffff80000010b652:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b656:	48 8b 00             	mov    (%rax),%rax
ffff80000010b659:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b65f:	48 89 c2             	mov    %rax,%rdx
ffff80000010b662:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b669:	80 ff ff 
ffff80000010b66c:	48 01 d0             	add    %rdx,%rax
ffff80000010b66f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010b673:	eb 63                	jmp    ffff80000010b6d8 <walkpgdir+0x17d>
  else {
    if(!alloc || (pd = (pde_t*)kalloc()) == 0)//allocate page table
ffff80000010b675:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010b679:	74 17                	je     ffff80000010b692 <walkpgdir+0x137>
ffff80000010b67b:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff80000010b682:	80 ff ff 
ffff80000010b685:	ff d0                	call   *%rax
ffff80000010b687:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010b68b:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010b690:	75 0a                	jne    ffff80000010b69c <walkpgdir+0x141>
      return 0;
ffff80000010b692:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b697:	e9 0a 01 00 00       	jmp    ffff80000010b7a6 <walkpgdir+0x24b>
    memset(pd, 0, PGSIZE);
ffff80000010b69c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b6a0:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b6a5:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b6aa:	48 89 c7             	mov    %rax,%rdi
ffff80000010b6ad:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff80000010b6b4:	80 ff ff 
ffff80000010b6b7:	ff d0                	call   *%rax
    *pdpe = V2P(pd) | PTE_P | PTE_W | PTE_U;
ffff80000010b6b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b6bd:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b6c4:	80 00 00 
ffff80000010b6c7:	48 01 d0             	add    %rdx,%rax
ffff80000010b6ca:	48 83 c8 07          	or     $0x7,%rax
ffff80000010b6ce:	48 89 c2             	mov    %rax,%rdx
ffff80000010b6d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b6d5:	48 89 10             	mov    %rdx,(%rax)
  }

  // from the PD, find or allocate the appropriate page table
  pde = &pd[PDX(va)];
ffff80000010b6d8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010b6dc:	48 c1 e8 15          	shr    $0x15,%rax
ffff80000010b6e0:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010b6e5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b6ec:	00 
ffff80000010b6ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b6f1:	48 01 d0             	add    %rdx,%rax
ffff80000010b6f4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  if(*pde & PTE_P)
ffff80000010b6f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b6fc:	48 8b 00             	mov    (%rax),%rax
ffff80000010b6ff:	83 e0 01             	and    $0x1,%eax
ffff80000010b702:	48 85 c0             	test   %rax,%rax
ffff80000010b705:	74 23                	je     ffff80000010b72a <walkpgdir+0x1cf>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
ffff80000010b707:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b70b:	48 8b 00             	mov    (%rax),%rax
ffff80000010b70e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b714:	48 89 c2             	mov    %rax,%rdx
ffff80000010b717:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b71e:	80 ff ff 
ffff80000010b721:	48 01 d0             	add    %rdx,%rax
ffff80000010b724:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010b728:	eb 60                	jmp    ffff80000010b78a <walkpgdir+0x22f>
  else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)//allocate page table
ffff80000010b72a:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010b72e:	74 17                	je     ffff80000010b747 <walkpgdir+0x1ec>
ffff80000010b730:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff80000010b737:	80 ff ff 
ffff80000010b73a:	ff d0                	call   *%rax
ffff80000010b73c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010b740:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010b745:	75 07                	jne    ffff80000010b74e <walkpgdir+0x1f3>
      return 0;
ffff80000010b747:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b74c:	eb 58                	jmp    ffff80000010b7a6 <walkpgdir+0x24b>
    memset(pgtab, 0, PGSIZE);
ffff80000010b74e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b752:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b757:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b75c:	48 89 c7             	mov    %rax,%rdi
ffff80000010b75f:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff80000010b766:	80 ff ff 
ffff80000010b769:	ff d0                	call   *%rax
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
ffff80000010b76b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b76f:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b776:	80 00 00 
ffff80000010b779:	48 01 d0             	add    %rdx,%rax
ffff80000010b77c:	48 83 c8 07          	or     $0x7,%rax
ffff80000010b780:	48 89 c2             	mov    %rax,%rdx
ffff80000010b783:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b787:	48 89 10             	mov    %rdx,(%rax)
  }

  return &pgtab[PTX(va)];
ffff80000010b78a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010b78e:	48 c1 e8 0c          	shr    $0xc,%rax
ffff80000010b792:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010b797:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b79e:	00 
ffff80000010b79f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b7a3:	48 01 d0             	add    %rdx,%rax
}
ffff80000010b7a6:	c9                   	leave
ffff80000010b7a7:	c3                   	ret

ffff80000010b7a8 <switchkvm>:

void
switchkvm(void)
{
ffff80000010b7a8:	55                   	push   %rbp
ffff80000010b7a9:	48 89 e5             	mov    %rsp,%rbp
  lcr3(v2p(kpml4));
ffff80000010b7ac:	48 b8 58 bd 11 00 00 	movabs $0xffff80000011bd58,%rax
ffff80000010b7b3:	80 ff ff 
ffff80000010b7b6:	48 8b 00             	mov    (%rax),%rax
ffff80000010b7b9:	48 89 c7             	mov    %rax,%rdi
ffff80000010b7bc:	48 b8 56 ae 10 00 00 	movabs $0xffff80000010ae56,%rax
ffff80000010b7c3:	80 ff ff 
ffff80000010b7c6:	ff d0                	call   *%rax
ffff80000010b7c8:	48 89 c7             	mov    %rax,%rdi
ffff80000010b7cb:	48 b8 40 ae 10 00 00 	movabs $0xffff80000010ae40,%rax
ffff80000010b7d2:	80 ff ff 
ffff80000010b7d5:	ff d0                	call   *%rax
}
ffff80000010b7d7:	90                   	nop
ffff80000010b7d8:	5d                   	pop    %rbp
ffff80000010b7d9:	c3                   	ret

ffff80000010b7da <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, addr_t size, addr_t pa, int perm)
{
ffff80000010b7da:	55                   	push   %rbp
ffff80000010b7db:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b7de:	48 83 ec 50          	sub    $0x50,%rsp
ffff80000010b7e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010b7e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010b7ea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010b7ee:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
ffff80000010b7f2:	44 89 45 bc          	mov    %r8d,-0x44(%rbp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((addr_t)va);
ffff80000010b7f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b7fa:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b800:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  last = (char*)PGROUNDDOWN(((addr_t)va) + size - 1);
ffff80000010b804:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff80000010b808:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010b80c:	48 01 d0             	add    %rdx,%rax
ffff80000010b80f:	48 83 e8 01          	sub    $0x1,%rax
ffff80000010b813:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b819:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
ffff80000010b81d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010b821:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b825:	ba 01 00 00 00       	mov    $0x1,%edx
ffff80000010b82a:	48 89 ce             	mov    %rcx,%rsi
ffff80000010b82d:	48 89 c7             	mov    %rax,%rdi
ffff80000010b830:	48 b8 5b b5 10 00 00 	movabs $0xffff80000010b55b,%rax
ffff80000010b837:	80 ff ff 
ffff80000010b83a:	ff d0                	call   *%rax
ffff80000010b83c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010b840:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010b845:	75 07                	jne    ffff80000010b84e <mappages+0x74>
      return -1;
ffff80000010b847:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010b84c:	eb 64                	jmp    ffff80000010b8b2 <mappages+0xd8>
    if(*pte & PTE_P)
ffff80000010b84e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b852:	48 8b 00             	mov    (%rax),%rax
ffff80000010b855:	83 e0 01             	and    $0x1,%eax
ffff80000010b858:	48 85 c0             	test   %rax,%rax
ffff80000010b85b:	74 19                	je     ffff80000010b876 <mappages+0x9c>
      panic("remap");
ffff80000010b85d:	48 b8 2c cd 10 00 00 	movabs $0xffff80000010cd2c,%rax
ffff80000010b864:	80 ff ff 
ffff80000010b867:	48 89 c7             	mov    %rax,%rdi
ffff80000010b86a:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010b871:	80 ff ff 
ffff80000010b874:	ff d0                	call   *%rax
    *pte = pa | perm | PTE_P;
ffff80000010b876:	8b 45 bc             	mov    -0x44(%rbp),%eax
ffff80000010b879:	48 98                	cltq
ffff80000010b87b:	48 0b 45 c0          	or     -0x40(%rbp),%rax
ffff80000010b87f:	48 83 c8 01          	or     $0x1,%rax
ffff80000010b883:	48 89 c2             	mov    %rax,%rdx
ffff80000010b886:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b88a:	48 89 10             	mov    %rdx,(%rax)
    if(a == last)
ffff80000010b88d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b891:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff80000010b895:	74 15                	je     ffff80000010b8ac <mappages+0xd2>
      break;
    a += PGSIZE;
ffff80000010b897:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010b89e:	00 
    pa += PGSIZE;
ffff80000010b89f:	48 81 45 c0 00 10 00 	addq   $0x1000,-0x40(%rbp)
ffff80000010b8a6:	00 
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
ffff80000010b8a7:	e9 71 ff ff ff       	jmp    ffff80000010b81d <mappages+0x43>
      break;
ffff80000010b8ac:	90                   	nop
  }
  return 0;
ffff80000010b8ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010b8b2:	c9                   	leave
ffff80000010b8b3:	c3                   	ret

ffff80000010b8b4 <inituvm>:

// Load the initcode into address 0x1000 (4KB) of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
ffff80000010b8b4:	55                   	push   %rbp
ffff80000010b8b5:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b8b8:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010b8bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010b8c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010b8c4:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *mem;

  if(sz >= PGSIZE)
ffff80000010b8c7:	81 7d dc ff 0f 00 00 	cmpl   $0xfff,-0x24(%rbp)
ffff80000010b8ce:	76 19                	jbe    ffff80000010b8e9 <inituvm+0x35>
    panic("inituvm: more than a page");
ffff80000010b8d0:	48 b8 32 cd 10 00 00 	movabs $0xffff80000010cd32,%rax
ffff80000010b8d7:	80 ff ff 
ffff80000010b8da:	48 89 c7             	mov    %rax,%rdi
ffff80000010b8dd:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010b8e4:	80 ff ff 
ffff80000010b8e7:	ff d0                	call   *%rax

  mem = kalloc();
ffff80000010b8e9:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff80000010b8f0:	80 ff ff 
ffff80000010b8f3:	ff d0                	call   *%rax
ffff80000010b8f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(mem, 0, PGSIZE);
ffff80000010b8f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b8fd:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b902:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b907:	48 89 c7             	mov    %rax,%rdi
ffff80000010b90a:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff80000010b911:	80 ff ff 
ffff80000010b914:	ff d0                	call   *%rax
  mappages(pgdir, (void *)PGSIZE, PGSIZE, V2P(mem), PTE_W|PTE_U);
ffff80000010b916:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b91a:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b921:	80 00 00 
ffff80000010b924:	48 01 c2             	add    %rax,%rdx
ffff80000010b927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b92b:	41 b8 06 00 00 00    	mov    $0x6,%r8d
ffff80000010b931:	48 89 d1             	mov    %rdx,%rcx
ffff80000010b934:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b939:	be 00 10 00 00       	mov    $0x1000,%esi
ffff80000010b93e:	48 89 c7             	mov    %rax,%rdi
ffff80000010b941:	48 b8 da b7 10 00 00 	movabs $0xffff80000010b7da,%rax
ffff80000010b948:	80 ff ff 
ffff80000010b94b:	ff d0                	call   *%rax

  memmove(mem, init, sz);
ffff80000010b94d:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff80000010b950:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010b954:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b958:	48 89 ce             	mov    %rcx,%rsi
ffff80000010b95b:	48 89 c7             	mov    %rax,%rdi
ffff80000010b95e:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff80000010b965:	80 ff ff 
ffff80000010b968:	ff d0                	call   *%rax
}
ffff80000010b96a:	90                   	nop
ffff80000010b96b:	c9                   	leave
ffff80000010b96c:	c3                   	ret

ffff80000010b96d <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
ffff80000010b96d:	55                   	push   %rbp
ffff80000010b96e:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b971:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010b975:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010b979:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010b97d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010b981:	89 4d c4             	mov    %ecx,-0x3c(%rbp)
ffff80000010b984:	44 89 45 c0          	mov    %r8d,-0x40(%rbp)
  uint i, n;
  addr_t pa;
  pte_t *pte;

  if((addr_t) addr % PGSIZE != 0)
ffff80000010b988:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b98c:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff80000010b991:	48 85 c0             	test   %rax,%rax
ffff80000010b994:	74 19                	je     ffff80000010b9af <loaduvm+0x42>
    panic("loaduvm: addr must be page aligned");
ffff80000010b996:	48 b8 50 cd 10 00 00 	movabs $0xffff80000010cd50,%rax
ffff80000010b99d:	80 ff ff 
ffff80000010b9a0:	48 89 c7             	mov    %rax,%rdi
ffff80000010b9a3:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010b9aa:	80 ff ff 
ffff80000010b9ad:	ff d0                	call   *%rax
  for(i = 0; i < sz; i += PGSIZE){
ffff80000010b9af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010b9b6:	e9 c7 00 00 00       	jmp    ffff80000010ba82 <loaduvm+0x115>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
ffff80000010b9bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010b9be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b9c2:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010b9c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b9ca:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010b9cf:	48 89 ce             	mov    %rcx,%rsi
ffff80000010b9d2:	48 89 c7             	mov    %rax,%rdi
ffff80000010b9d5:	48 b8 5b b5 10 00 00 	movabs $0xffff80000010b55b,%rax
ffff80000010b9dc:	80 ff ff 
ffff80000010b9df:	ff d0                	call   *%rax
ffff80000010b9e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010b9e5:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010b9ea:	75 19                	jne    ffff80000010ba05 <loaduvm+0x98>
      panic("loaduvm: address should exist");
ffff80000010b9ec:	48 b8 73 cd 10 00 00 	movabs $0xffff80000010cd73,%rax
ffff80000010b9f3:	80 ff ff 
ffff80000010b9f6:	48 89 c7             	mov    %rax,%rdi
ffff80000010b9f9:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010ba00:	80 ff ff 
ffff80000010ba03:	ff d0                	call   *%rax
    pa = PTE_ADDR(*pte);
ffff80000010ba05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ba09:	48 8b 00             	mov    (%rax),%rax
ffff80000010ba0c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010ba12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(sz - i < PGSIZE)
ffff80000010ba16:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff80000010ba19:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010ba1c:	3d ff 0f 00 00       	cmp    $0xfff,%eax
ffff80000010ba21:	77 0b                	ja     ffff80000010ba2e <loaduvm+0xc1>
      n = sz - i;
ffff80000010ba23:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff80000010ba26:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010ba29:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffff80000010ba2c:	eb 07                	jmp    ffff80000010ba35 <loaduvm+0xc8>
    else
      n = PGSIZE;
ffff80000010ba2e:	c7 45 f8 00 10 00 00 	movl   $0x1000,-0x8(%rbp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
ffff80000010ba35:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffff80000010ba38:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010ba3b:	8d 34 02             	lea    (%rdx,%rax,1),%esi
ffff80000010ba3e:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010ba45:	80 ff ff 
ffff80000010ba48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010ba4c:	48 01 d0             	add    %rdx,%rax
ffff80000010ba4f:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba52:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff80000010ba55:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010ba59:	89 d1                	mov    %edx,%ecx
ffff80000010ba5b:	89 f2                	mov    %esi,%edx
ffff80000010ba5d:	48 89 fe             	mov    %rdi,%rsi
ffff80000010ba60:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba63:	48 b8 1d 30 10 00 00 	movabs $0xffff80000010301d,%rax
ffff80000010ba6a:	80 ff ff 
ffff80000010ba6d:	ff d0                	call   *%rax
ffff80000010ba6f:	39 45 f8             	cmp    %eax,-0x8(%rbp)
ffff80000010ba72:	74 07                	je     ffff80000010ba7b <loaduvm+0x10e>
      return -1;
ffff80000010ba74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010ba79:	eb 18                	jmp    ffff80000010ba93 <loaduvm+0x126>
  for(i = 0; i < sz; i += PGSIZE){
ffff80000010ba7b:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
ffff80000010ba82:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010ba85:	3b 45 c0             	cmp    -0x40(%rbp),%eax
ffff80000010ba88:	0f 82 2d ff ff ff    	jb     ffff80000010b9bb <loaduvm+0x4e>
  }
  return 0;
ffff80000010ba8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010ba93:	c9                   	leave
ffff80000010ba94:	c3                   	ret

ffff80000010ba95 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64
allocuvm(pde_t *pgdir, uint64 oldsz, uint64 newsz)
{
ffff80000010ba95:	55                   	push   %rbp
ffff80000010ba96:	48 89 e5             	mov    %rsp,%rbp
ffff80000010ba99:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010ba9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010baa1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010baa5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  char *mem;
  addr_t a;

  if(newsz >= KERNBASE)
ffff80000010baa9:	48 b8 ff ff ff ff ff 	movabs $0xffff7fffffffffff,%rax
ffff80000010bab0:	7f ff ff 
ffff80000010bab3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
ffff80000010bab7:	73 0a                	jae    ffff80000010bac3 <allocuvm+0x2e>
    return 0;
ffff80000010bab9:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010babe:	e9 14 01 00 00       	jmp    ffff80000010bbd7 <allocuvm+0x142>
  if(newsz < oldsz)
ffff80000010bac3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bac7:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
ffff80000010bacb:	73 09                	jae    ffff80000010bad6 <allocuvm+0x41>
    return oldsz;
ffff80000010bacd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bad1:	e9 01 01 00 00       	jmp    ffff80000010bbd7 <allocuvm+0x142>

  a = PGROUNDUP(oldsz);
ffff80000010bad6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bada:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff80000010bae0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bae6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; a < newsz; a += PGSIZE){
ffff80000010baea:	e9 d6 00 00 00       	jmp    ffff80000010bbc5 <allocuvm+0x130>
    mem = kalloc();
ffff80000010baef:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff80000010baf6:	80 ff ff 
ffff80000010baf9:	ff d0                	call   *%rax
ffff80000010bafb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(mem == 0){
ffff80000010baff:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010bb04:	75 28                	jne    ffff80000010bb2e <allocuvm+0x99>
      //cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
ffff80000010bb06:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010bb0a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010bb0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bb12:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bb15:	48 89 c7             	mov    %rax,%rdi
ffff80000010bb18:	48 b8 d9 bb 10 00 00 	movabs $0xffff80000010bbd9,%rax
ffff80000010bb1f:	80 ff ff 
ffff80000010bb22:	ff d0                	call   *%rax
      return 0;
ffff80000010bb24:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bb29:	e9 a9 00 00 00       	jmp    ffff80000010bbd7 <allocuvm+0x142>
    }
    memset(mem, 0, PGSIZE);
ffff80000010bb2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bb32:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bb37:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010bb3c:	48 89 c7             	mov    %rax,%rdi
ffff80000010bb3f:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff80000010bb46:	80 ff ff 
ffff80000010bb49:	ff d0                	call   *%rax
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
ffff80000010bb4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bb4f:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010bb56:	80 00 00 
ffff80000010bb59:	48 01 c2             	add    %rax,%rdx
ffff80000010bb5c:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
ffff80000010bb60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bb64:	41 b8 06 00 00 00    	mov    $0x6,%r8d
ffff80000010bb6a:	48 89 d1             	mov    %rdx,%rcx
ffff80000010bb6d:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bb72:	48 89 c7             	mov    %rax,%rdi
ffff80000010bb75:	48 b8 da b7 10 00 00 	movabs $0xffff80000010b7da,%rax
ffff80000010bb7c:	80 ff ff 
ffff80000010bb7f:	ff d0                	call   *%rax
ffff80000010bb81:	85 c0                	test   %eax,%eax
ffff80000010bb83:	79 38                	jns    ffff80000010bbbd <allocuvm+0x128>
      //cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
ffff80000010bb85:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010bb89:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010bb8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bb91:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bb94:	48 89 c7             	mov    %rax,%rdi
ffff80000010bb97:	48 b8 d9 bb 10 00 00 	movabs $0xffff80000010bbd9,%rax
ffff80000010bb9e:	80 ff ff 
ffff80000010bba1:	ff d0                	call   *%rax
      kfree(mem);
ffff80000010bba3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bba7:	48 89 c7             	mov    %rax,%rdi
ffff80000010bbaa:	48 b8 cd 41 10 00 00 	movabs $0xffff8000001041cd,%rax
ffff80000010bbb1:	80 ff ff 
ffff80000010bbb4:	ff d0                	call   *%rax
      return 0;
ffff80000010bbb6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bbbb:	eb 1a                	jmp    ffff80000010bbd7 <allocuvm+0x142>
  for(; a < newsz; a += PGSIZE){
ffff80000010bbbd:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010bbc4:	00 
ffff80000010bbc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bbc9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
ffff80000010bbcd:	0f 82 1c ff ff ff    	jb     ffff80000010baef <allocuvm+0x5a>
    }
  }
  return newsz;
ffff80000010bbd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
}
ffff80000010bbd7:	c9                   	leave
ffff80000010bbd8:	c3                   	ret

ffff80000010bbd9 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
deallocuvm(pde_t *pgdir, uint64 oldsz, uint64 newsz)
{
ffff80000010bbd9:	55                   	push   %rbp
ffff80000010bbda:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bbdd:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010bbe1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010bbe5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010bbe9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  pte_t *pte;
  addr_t a, pa;

  if(newsz >= oldsz)
ffff80000010bbed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bbf1:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
ffff80000010bbf5:	72 09                	jb     ffff80000010bc00 <deallocuvm+0x27>
    return oldsz;
ffff80000010bbf7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bbfb:	e9 d0 00 00 00       	jmp    ffff80000010bcd0 <deallocuvm+0xf7>

  a = PGROUNDUP(newsz);
ffff80000010bc00:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bc04:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff80000010bc0a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bc10:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; a  < oldsz; a += PGSIZE){
ffff80000010bc14:	e9 a5 00 00 00       	jmp    ffff80000010bcbe <deallocuvm+0xe5>
    pte = walkpgdir(pgdir, (char*)a, 0);
ffff80000010bc19:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010bc1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bc21:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010bc26:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bc29:	48 89 c7             	mov    %rax,%rdi
ffff80000010bc2c:	48 b8 5b b5 10 00 00 	movabs $0xffff80000010b55b,%rax
ffff80000010bc33:	80 ff ff 
ffff80000010bc36:	ff d0                	call   *%rax
ffff80000010bc38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(pte && (*pte & PTE_P) != 0){
ffff80000010bc3c:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010bc41:	74 73                	je     ffff80000010bcb6 <deallocuvm+0xdd>
ffff80000010bc43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bc47:	48 8b 00             	mov    (%rax),%rax
ffff80000010bc4a:	83 e0 01             	and    $0x1,%eax
ffff80000010bc4d:	48 85 c0             	test   %rax,%rax
ffff80000010bc50:	74 64                	je     ffff80000010bcb6 <deallocuvm+0xdd>
      pa = PTE_ADDR(*pte);
ffff80000010bc52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bc56:	48 8b 00             	mov    (%rax),%rax
ffff80000010bc59:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bc5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      if(pa == 0)
ffff80000010bc63:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010bc68:	75 19                	jne    ffff80000010bc83 <deallocuvm+0xaa>
        panic("kfree");
ffff80000010bc6a:	48 b8 91 cd 10 00 00 	movabs $0xffff80000010cd91,%rax
ffff80000010bc71:	80 ff ff 
ffff80000010bc74:	48 89 c7             	mov    %rax,%rdi
ffff80000010bc77:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010bc7e:	80 ff ff 
ffff80000010bc81:	ff d0                	call   *%rax
      char *v = P2V(pa);
ffff80000010bc83:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010bc8a:	80 ff ff 
ffff80000010bc8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bc91:	48 01 d0             	add    %rdx,%rax
ffff80000010bc94:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
      kfree(v);
ffff80000010bc98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bc9c:	48 89 c7             	mov    %rax,%rdi
ffff80000010bc9f:	48 b8 cd 41 10 00 00 	movabs $0xffff8000001041cd,%rax
ffff80000010bca6:	80 ff ff 
ffff80000010bca9:	ff d0                	call   *%rax
      *pte = 0;
ffff80000010bcab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bcaf:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  for(; a  < oldsz; a += PGSIZE){
ffff80000010bcb6:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010bcbd:	00 
ffff80000010bcbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bcc2:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
ffff80000010bcc6:	0f 82 4d ff ff ff    	jb     ffff80000010bc19 <deallocuvm+0x40>
    }
  }
  return newsz;
ffff80000010bccc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
ffff80000010bcd0:	c9                   	leave
ffff80000010bcd1:	c3                   	ret

ffff80000010bcd2 <freevm>:

// Free all the pages mapped by, and all the memory used for,
// this page table
void
freevm(pml4e_t *pml4)
{
ffff80000010bcd2:	55                   	push   %rbp
ffff80000010bcd3:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bcd6:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010bcda:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  uint i, j, k, l;
  pde_t *pdp, *pd, *pt;

  if(pml4 == 0)
ffff80000010bcde:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff80000010bce3:	75 19                	jne    ffff80000010bcfe <freevm+0x2c>
    panic("freevm: no pgdir");
ffff80000010bce5:	48 b8 97 cd 10 00 00 	movabs $0xffff80000010cd97,%rax
ffff80000010bcec:	80 ff ff 
ffff80000010bcef:	48 89 c7             	mov    %rax,%rdi
ffff80000010bcf2:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010bcf9:	80 ff ff 
ffff80000010bcfc:	ff d0                	call   *%rax

  // then need to loop through pml4 entry
  for(i = 0; i < (NPDENTRIES/2); i++){
ffff80000010bcfe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010bd05:	e9 dc 01 00 00       	jmp    ffff80000010bee6 <freevm+0x214>
    if(pml4[i] & PTE_P){
ffff80000010bd0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010bd0d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bd14:	00 
ffff80000010bd15:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bd19:	48 01 d0             	add    %rdx,%rax
ffff80000010bd1c:	48 8b 00             	mov    (%rax),%rax
ffff80000010bd1f:	83 e0 01             	and    $0x1,%eax
ffff80000010bd22:	48 85 c0             	test   %rax,%rax
ffff80000010bd25:	0f 84 b7 01 00 00    	je     ffff80000010bee2 <freevm+0x210>
      pdp = (pdpe_t*)P2V(PTE_ADDR(pml4[i]));
ffff80000010bd2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010bd2e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bd35:	00 
ffff80000010bd36:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bd3a:	48 01 d0             	add    %rdx,%rax
ffff80000010bd3d:	48 8b 00             	mov    (%rax),%rax
ffff80000010bd40:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bd46:	48 89 c2             	mov    %rax,%rdx
ffff80000010bd49:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010bd50:	80 ff ff 
ffff80000010bd53:	48 01 d0             	add    %rdx,%rax
ffff80000010bd56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

      // and every entry in the corresponding pdpt
      for(j = 0; j < NPDENTRIES; j++){
ffff80000010bd5a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff80000010bd61:	e9 5c 01 00 00       	jmp    ffff80000010bec2 <freevm+0x1f0>
        if(pdp[j] & PTE_P){
ffff80000010bd66:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010bd69:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bd70:	00 
ffff80000010bd71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bd75:	48 01 d0             	add    %rdx,%rax
ffff80000010bd78:	48 8b 00             	mov    (%rax),%rax
ffff80000010bd7b:	83 e0 01             	and    $0x1,%eax
ffff80000010bd7e:	48 85 c0             	test   %rax,%rax
ffff80000010bd81:	0f 84 37 01 00 00    	je     ffff80000010bebe <freevm+0x1ec>
          pd = (pde_t*)P2V(PTE_ADDR(pdp[j]));
ffff80000010bd87:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010bd8a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bd91:	00 
ffff80000010bd92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bd96:	48 01 d0             	add    %rdx,%rax
ffff80000010bd99:	48 8b 00             	mov    (%rax),%rax
ffff80000010bd9c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bda2:	48 89 c2             	mov    %rax,%rdx
ffff80000010bda5:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010bdac:	80 ff ff 
ffff80000010bdaf:	48 01 d0             	add    %rdx,%rax
ffff80000010bdb2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

          // and every entry in the corresponding page directory
          for(k = 0; k < (NPDENTRIES); k++){
ffff80000010bdb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff80000010bdbd:	e9 dc 00 00 00       	jmp    ffff80000010be9e <freevm+0x1cc>
            if(pd[k] & PTE_P) {
ffff80000010bdc2:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010bdc5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bdcc:	00 
ffff80000010bdcd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bdd1:	48 01 d0             	add    %rdx,%rax
ffff80000010bdd4:	48 8b 00             	mov    (%rax),%rax
ffff80000010bdd7:	83 e0 01             	and    $0x1,%eax
ffff80000010bdda:	48 85 c0             	test   %rax,%rax
ffff80000010bddd:	0f 84 b7 00 00 00    	je     ffff80000010be9a <freevm+0x1c8>
              pt = (pde_t*)P2V(PTE_ADDR(pd[k]));
ffff80000010bde3:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010bde6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bded:	00 
ffff80000010bdee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bdf2:	48 01 d0             	add    %rdx,%rax
ffff80000010bdf5:	48 8b 00             	mov    (%rax),%rax
ffff80000010bdf8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bdfe:	48 89 c2             	mov    %rax,%rdx
ffff80000010be01:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010be08:	80 ff ff 
ffff80000010be0b:	48 01 d0             	add    %rdx,%rax
ffff80000010be0e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

              // and every entry in the corresponding page table
              for(l = 0; l < (NPDENTRIES); l++){
ffff80000010be12:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
ffff80000010be19:	eb 63                	jmp    ffff80000010be7e <freevm+0x1ac>
                if(pt[l] & PTE_P) {
ffff80000010be1b:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010be1e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010be25:	00 
ffff80000010be26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010be2a:	48 01 d0             	add    %rdx,%rax
ffff80000010be2d:	48 8b 00             	mov    (%rax),%rax
ffff80000010be30:	83 e0 01             	and    $0x1,%eax
ffff80000010be33:	48 85 c0             	test   %rax,%rax
ffff80000010be36:	74 42                	je     ffff80000010be7a <freevm+0x1a8>
                  char * v = P2V(PTE_ADDR(pt[l]));
ffff80000010be38:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010be3b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010be42:	00 
ffff80000010be43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010be47:	48 01 d0             	add    %rdx,%rax
ffff80000010be4a:	48 8b 00             	mov    (%rax),%rax
ffff80000010be4d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010be53:	48 89 c2             	mov    %rax,%rdx
ffff80000010be56:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010be5d:	80 ff ff 
ffff80000010be60:	48 01 d0             	add    %rdx,%rax
ffff80000010be63:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

                  kfree((char*)v);
ffff80000010be67:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010be6b:	48 89 c7             	mov    %rax,%rdi
ffff80000010be6e:	48 b8 cd 41 10 00 00 	movabs $0xffff8000001041cd,%rax
ffff80000010be75:	80 ff ff 
ffff80000010be78:	ff d0                	call   *%rax
              for(l = 0; l < (NPDENTRIES); l++){
ffff80000010be7a:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
ffff80000010be7e:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
ffff80000010be85:	76 94                	jbe    ffff80000010be1b <freevm+0x149>
                }
              }
              //freeing every page table
              kfree((char*)pt);
ffff80000010be87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010be8b:	48 89 c7             	mov    %rax,%rdi
ffff80000010be8e:	48 b8 cd 41 10 00 00 	movabs $0xffff8000001041cd,%rax
ffff80000010be95:	80 ff ff 
ffff80000010be98:	ff d0                	call   *%rax
          for(k = 0; k < (NPDENTRIES); k++){
ffff80000010be9a:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffff80000010be9e:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
ffff80000010bea5:	0f 86 17 ff ff ff    	jbe    ffff80000010bdc2 <freevm+0xf0>
            }
          }
          // freeing every page directory
          kfree((char*)pd);
ffff80000010beab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010beaf:	48 89 c7             	mov    %rax,%rdi
ffff80000010beb2:	48 b8 cd 41 10 00 00 	movabs $0xffff8000001041cd,%rax
ffff80000010beb9:	80 ff ff 
ffff80000010bebc:	ff d0                	call   *%rax
      for(j = 0; j < NPDENTRIES; j++){
ffff80000010bebe:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff80000010bec2:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
ffff80000010bec9:	0f 86 97 fe ff ff    	jbe    ffff80000010bd66 <freevm+0x94>
        }
      }
      // freeing every page directory pointer table
      kfree((char*)pdp);
ffff80000010becf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bed3:	48 89 c7             	mov    %rax,%rdi
ffff80000010bed6:	48 b8 cd 41 10 00 00 	movabs $0xffff8000001041cd,%rax
ffff80000010bedd:	80 ff ff 
ffff80000010bee0:	ff d0                	call   *%rax
  for(i = 0; i < (NPDENTRIES/2); i++){
ffff80000010bee2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010bee6:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
ffff80000010beed:	0f 86 17 fe ff ff    	jbe    ffff80000010bd0a <freevm+0x38>
    }
  }
  // freeing the pml4
  kfree((char*)pml4);
ffff80000010bef3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bef7:	48 89 c7             	mov    %rax,%rdi
ffff80000010befa:	48 b8 cd 41 10 00 00 	movabs $0xffff8000001041cd,%rax
ffff80000010bf01:	80 ff ff 
ffff80000010bf04:	ff d0                	call   *%rax
}
ffff80000010bf06:	90                   	nop
ffff80000010bf07:	c9                   	leave
ffff80000010bf08:	c3                   	ret

ffff80000010bf09 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pml4e_t *pgdir, char *uva)
{
ffff80000010bf09:	55                   	push   %rbp
ffff80000010bf0a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bf0d:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010bf11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010bf15:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
ffff80000010bf19:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010bf1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bf21:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010bf26:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bf29:	48 89 c7             	mov    %rax,%rdi
ffff80000010bf2c:	48 b8 5b b5 10 00 00 	movabs $0xffff80000010b55b,%rax
ffff80000010bf33:	80 ff ff 
ffff80000010bf36:	ff d0                	call   *%rax
ffff80000010bf38:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(pte == 0)
ffff80000010bf3c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010bf41:	75 19                	jne    ffff80000010bf5c <clearpteu+0x53>
    panic("clearpteu");
ffff80000010bf43:	48 b8 a8 cd 10 00 00 	movabs $0xffff80000010cda8,%rax
ffff80000010bf4a:	80 ff ff 
ffff80000010bf4d:	48 89 c7             	mov    %rax,%rdi
ffff80000010bf50:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010bf57:	80 ff ff 
ffff80000010bf5a:	ff d0                	call   *%rax
  *pte &= ~PTE_U;
ffff80000010bf5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bf60:	48 8b 00             	mov    (%rax),%rax
ffff80000010bf63:	48 83 e0 fb          	and    $0xfffffffffffffffb,%rax
ffff80000010bf67:	48 89 c2             	mov    %rax,%rdx
ffff80000010bf6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bf6e:	48 89 10             	mov    %rdx,(%rax)
}
ffff80000010bf71:	90                   	nop
ffff80000010bf72:	c9                   	leave
ffff80000010bf73:	c3                   	ret

ffff80000010bf74 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pml4e_t *pgdir, uint sz)
{
ffff80000010bf74:	55                   	push   %rbp
ffff80000010bf75:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bf78:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010bf7c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff80000010bf80:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  pde_t *d;
  pte_t *pte;
  addr_t pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
ffff80000010bf83:	48 b8 3e b3 10 00 00 	movabs $0xffff80000010b33e,%rax
ffff80000010bf8a:	80 ff ff 
ffff80000010bf8d:	ff d0                	call   *%rax
ffff80000010bf8f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010bf93:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010bf98:	75 0a                	jne    ffff80000010bfa4 <copyuvm+0x30>
    return 0;
ffff80000010bf9a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bf9f:	e9 57 01 00 00       	jmp    ffff80000010c0fb <copyuvm+0x187>
  for(i = PGSIZE; i < sz; i += PGSIZE){
ffff80000010bfa4:	48 c7 45 f8 00 10 00 	movq   $0x1000,-0x8(%rbp)
ffff80000010bfab:	00 
ffff80000010bfac:	e9 1b 01 00 00       	jmp    ffff80000010c0cc <copyuvm+0x158>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
ffff80000010bfb1:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010bfb5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bfb9:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010bfbe:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bfc1:	48 89 c7             	mov    %rax,%rdi
ffff80000010bfc4:	48 b8 5b b5 10 00 00 	movabs $0xffff80000010b55b,%rax
ffff80000010bfcb:	80 ff ff 
ffff80000010bfce:	ff d0                	call   *%rax
ffff80000010bfd0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010bfd4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010bfd9:	75 19                	jne    ffff80000010bff4 <copyuvm+0x80>
      panic("copyuvm: pte should exist");
ffff80000010bfdb:	48 b8 b2 cd 10 00 00 	movabs $0xffff80000010cdb2,%rax
ffff80000010bfe2:	80 ff ff 
ffff80000010bfe5:	48 89 c7             	mov    %rax,%rdi
ffff80000010bfe8:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010bfef:	80 ff ff 
ffff80000010bff2:	ff d0                	call   *%rax
    if(!(*pte & PTE_P))
ffff80000010bff4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bff8:	48 8b 00             	mov    (%rax),%rax
ffff80000010bffb:	83 e0 01             	and    $0x1,%eax
ffff80000010bffe:	48 85 c0             	test   %rax,%rax
ffff80000010c001:	75 19                	jne    ffff80000010c01c <copyuvm+0xa8>
      panic("copyuvm: page not present");
ffff80000010c003:	48 b8 cc cd 10 00 00 	movabs $0xffff80000010cdcc,%rax
ffff80000010c00a:	80 ff ff 
ffff80000010c00d:	48 89 c7             	mov    %rax,%rdi
ffff80000010c010:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010c017:	80 ff ff 
ffff80000010c01a:	ff d0                	call   *%rax
    pa = PTE_ADDR(*pte);
ffff80000010c01c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c020:	48 8b 00             	mov    (%rax),%rax
ffff80000010c023:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c029:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    flags = PTE_FLAGS(*pte);
ffff80000010c02d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c031:	48 8b 00             	mov    (%rax),%rax
ffff80000010c034:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff80000010c039:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    if((mem = kalloc()) == 0)
ffff80000010c03d:	48 b8 35 43 10 00 00 	movabs $0xffff800000104335,%rax
ffff80000010c044:	80 ff ff 
ffff80000010c047:	ff d0                	call   *%rax
ffff80000010c049:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
ffff80000010c04d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
ffff80000010c052:	0f 84 87 00 00 00    	je     ffff80000010c0df <copyuvm+0x16b>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
ffff80000010c058:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010c05f:	80 ff ff 
ffff80000010c062:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c066:	48 01 d0             	add    %rdx,%rax
ffff80000010c069:	48 89 c1             	mov    %rax,%rcx
ffff80000010c06c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c070:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010c075:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c078:	48 89 c7             	mov    %rax,%rdi
ffff80000010c07b:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff80000010c082:	80 ff ff 
ffff80000010c085:	ff d0                	call   *%rax
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
ffff80000010c087:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c08b:	89 c1                	mov    %eax,%ecx
ffff80000010c08d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c091:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010c098:	80 00 00 
ffff80000010c09b:	48 01 c2             	add    %rax,%rdx
ffff80000010c09e:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
ffff80000010c0a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c0a6:	41 89 c8             	mov    %ecx,%r8d
ffff80000010c0a9:	48 89 d1             	mov    %rdx,%rcx
ffff80000010c0ac:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010c0b1:	48 89 c7             	mov    %rax,%rdi
ffff80000010c0b4:	48 b8 da b7 10 00 00 	movabs $0xffff80000010b7da,%rax
ffff80000010c0bb:	80 ff ff 
ffff80000010c0be:	ff d0                	call   *%rax
ffff80000010c0c0:	85 c0                	test   %eax,%eax
ffff80000010c0c2:	78 1e                	js     ffff80000010c0e2 <copyuvm+0x16e>
  for(i = PGSIZE; i < sz; i += PGSIZE){
ffff80000010c0c4:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010c0cb:	00 
ffff80000010c0cc:	8b 45 c4             	mov    -0x3c(%rbp),%eax
ffff80000010c0cf:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010c0d3:	0f 82 d8 fe ff ff    	jb     ffff80000010bfb1 <copyuvm+0x3d>
      goto bad;
  }
  return d;
ffff80000010c0d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c0dd:	eb 1c                	jmp    ffff80000010c0fb <copyuvm+0x187>
      goto bad;
ffff80000010c0df:	90                   	nop
ffff80000010c0e0:	eb 01                	jmp    ffff80000010c0e3 <copyuvm+0x16f>
      goto bad;
ffff80000010c0e2:	90                   	nop

bad:
  freevm(d);
ffff80000010c0e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c0e7:	48 89 c7             	mov    %rax,%rdi
ffff80000010c0ea:	48 b8 d2 bc 10 00 00 	movabs $0xffff80000010bcd2,%rax
ffff80000010c0f1:	80 ff ff 
ffff80000010c0f4:	ff d0                	call   *%rax
  return 0;
ffff80000010c0f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010c0fb:	c9                   	leave
ffff80000010c0fc:	c3                   	ret

ffff80000010c0fd <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pml4e_t *pgdir, char *uva)
{
ffff80000010c0fd:	55                   	push   %rbp
ffff80000010c0fe:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c101:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010c105:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010c109:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
ffff80000010c10d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010c111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c115:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c11a:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c11d:	48 89 c7             	mov    %rax,%rdi
ffff80000010c120:	48 b8 5b b5 10 00 00 	movabs $0xffff80000010b55b,%rax
ffff80000010c127:	80 ff ff 
ffff80000010c12a:	ff d0                	call   *%rax
ffff80000010c12c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if((*pte & PTE_P) == 0)
ffff80000010c130:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c134:	48 8b 00             	mov    (%rax),%rax
ffff80000010c137:	83 e0 01             	and    $0x1,%eax
ffff80000010c13a:	48 85 c0             	test   %rax,%rax
ffff80000010c13d:	75 07                	jne    ffff80000010c146 <uva2ka+0x49>
    return 0;
ffff80000010c13f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c144:	eb 33                	jmp    ffff80000010c179 <uva2ka+0x7c>
  if((*pte & PTE_U) == 0)
ffff80000010c146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c14a:	48 8b 00             	mov    (%rax),%rax
ffff80000010c14d:	83 e0 04             	and    $0x4,%eax
ffff80000010c150:	48 85 c0             	test   %rax,%rax
ffff80000010c153:	75 07                	jne    ffff80000010c15c <uva2ka+0x5f>
    return 0;
ffff80000010c155:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c15a:	eb 1d                	jmp    ffff80000010c179 <uva2ka+0x7c>
  return (char*)P2V(PTE_ADDR(*pte));
ffff80000010c15c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c160:	48 8b 00             	mov    (%rax),%rax
ffff80000010c163:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c169:	48 89 c2             	mov    %rax,%rdx
ffff80000010c16c:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010c173:	80 ff ff 
ffff80000010c176:	48 01 d0             	add    %rdx,%rax
}
ffff80000010c179:	c9                   	leave
ffff80000010c17a:	c3                   	ret

ffff80000010c17b <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pml4e_t *pgdir, addr_t va, void *p, uint64 len)
{
ffff80000010c17b:	55                   	push   %rbp
ffff80000010c17c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c17f:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010c183:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010c187:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010c18b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010c18f:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  char *buf, *pa0;
  addr_t n, va0;

  buf = (char*)p;
ffff80000010c193:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c197:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(len > 0){
ffff80000010c19b:	e9 b0 00 00 00       	jmp    ffff80000010c250 <copyout+0xd5>
    va0 = PGROUNDDOWN(va);
ffff80000010c1a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c1a4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c1aa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    pa0 = uva2ka(pgdir, (char*)va0);
ffff80000010c1ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010c1b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c1b6:	48 89 d6             	mov    %rdx,%rsi
ffff80000010c1b9:	48 89 c7             	mov    %rax,%rdi
ffff80000010c1bc:	48 b8 fd c0 10 00 00 	movabs $0xffff80000010c0fd,%rax
ffff80000010c1c3:	80 ff ff 
ffff80000010c1c6:	ff d0                	call   *%rax
ffff80000010c1c8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    if(pa0 == 0)
ffff80000010c1cc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff80000010c1d1:	75 0a                	jne    ffff80000010c1dd <copyout+0x62>
      return -1;
ffff80000010c1d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010c1d8:	e9 83 00 00 00       	jmp    ffff80000010c260 <copyout+0xe5>
    n = PGSIZE - (va - va0);
ffff80000010c1dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c1e1:	48 2b 45 d0          	sub    -0x30(%rbp),%rax
ffff80000010c1e5:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010c1eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(n > len)
ffff80000010c1ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c1f3:	48 39 45 c0          	cmp    %rax,-0x40(%rbp)
ffff80000010c1f7:	73 08                	jae    ffff80000010c201 <copyout+0x86>
      n = len;
ffff80000010c1f9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010c1fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    memmove(pa0 + (va - va0), buf, n);
ffff80000010c201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c205:	89 c6                	mov    %eax,%esi
ffff80000010c207:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c20b:	48 2b 45 e8          	sub    -0x18(%rbp),%rax
ffff80000010c20f:	48 89 c2             	mov    %rax,%rdx
ffff80000010c212:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c216:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010c21a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c21e:	89 f2                	mov    %esi,%edx
ffff80000010c220:	48 89 c6             	mov    %rax,%rsi
ffff80000010c223:	48 89 cf             	mov    %rcx,%rdi
ffff80000010c226:	48 b8 73 7b 10 00 00 	movabs $0xffff800000107b73,%rax
ffff80000010c22d:	80 ff ff 
ffff80000010c230:	ff d0                	call   *%rax
    len -= n;
ffff80000010c232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c236:	48 29 45 c0          	sub    %rax,-0x40(%rbp)
    buf += n;
ffff80000010c23a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c23e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
    va = va0 + PGSIZE;
ffff80000010c242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c246:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010c24c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  while(len > 0){
ffff80000010c250:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff80000010c255:	0f 85 45 ff ff ff    	jne    ffff80000010c1a0 <copyout+0x25>
  }
  return 0;
ffff80000010c25b:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010c260:	c9                   	leave
ffff80000010c261:	c3                   	ret

ffff80000010c262 <traceinit>:
    struct trace_event events[TRACE_BUF_SIZE];  // Ring buffer
} traceBuffer;

// Initalize the tracing event
void 
traceinit(void){
ffff80000010c262:	55                   	push   %rbp
ffff80000010c263:	48 89 e5             	mov    %rsp,%rbp
    initlock(&traceBuffer.lock, "trace");
ffff80000010c266:	48 ba e6 cd 10 00 00 	movabs $0xffff80000010cde6,%rdx
ffff80000010c26d:	80 ff ff 
ffff80000010c270:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c277:	80 ff ff 
ffff80000010c27a:	48 89 d6             	mov    %rdx,%rsi
ffff80000010c27d:	48 89 c7             	mov    %rax,%rdi
ffff80000010c280:	48 b8 a5 76 10 00 00 	movabs $0xffff8000001076a5,%rax
ffff80000010c287:	80 ff ff 
ffff80000010c28a:	ff d0                	call   *%rax
    traceBuffer.enabled = 1;
ffff80000010c28c:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c293:	80 ff ff 
ffff80000010c296:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%rax)
    traceBuffer.seq = 0;
ffff80000010c29d:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c2a4:	80 ff ff 
ffff80000010c2a7:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%rax)
    traceBuffer.readseq = 0;
ffff80000010c2ae:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c2b5:	80 ff ff 
ffff80000010c2b8:	c7 40 70 00 00 00 00 	movl   $0x0,0x70(%rax)
    traceBuffer.overwritten = 0;
ffff80000010c2bf:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c2c6:	80 ff ff 
ffff80000010c2c9:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%rax)
}
ffff80000010c2d0:	90                   	nop
ffff80000010c2d1:	5d                   	pop    %rbp
ffff80000010c2d2:	c3                   	ret

ffff80000010c2d3 <traceevent>:

// trace the current event
void 
traceevent(int type, int pid, int arg0, int arg1, int arg2, char *name){
ffff80000010c2d3:	55                   	push   %rbp
ffff80000010c2d4:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c2d7:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010c2db:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010c2de:	89 75 e8             	mov    %esi,-0x18(%rbp)
ffff80000010c2e1:	89 55 e4             	mov    %edx,-0x1c(%rbp)
ffff80000010c2e4:	89 4d e0             	mov    %ecx,-0x20(%rbp)
ffff80000010c2e7:	44 89 45 dc          	mov    %r8d,-0x24(%rbp)
ffff80000010c2eb:	4c 89 4d d0          	mov    %r9,-0x30(%rbp)
    struct trace_event *event;

    // if the trace buffer is not enabled, then return nothing
    if(!traceBuffer.enabled)
ffff80000010c2ef:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c2f6:	80 ff ff 
ffff80000010c2f9:	8b 40 68             	mov    0x68(%rax),%eax
ffff80000010c2fc:	85 c0                	test   %eax,%eax
ffff80000010c2fe:	0f 84 34 02 00 00    	je     ffff80000010c538 <traceevent+0x265>
        return;

    //aquire the lock
    acquire(&traceBuffer.lock);
ffff80000010c304:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c30b:	80 ff ff 
ffff80000010c30e:	48 89 c7             	mov    %rax,%rdi
ffff80000010c311:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff80000010c318:	80 ff ff 
ffff80000010c31b:	ff d0                	call   *%rax
    // debug
    //cprintf("debug: traceevent type %d pid %d name %s\n", type, pid, name);


    event = &traceBuffer.events[traceBuffer.seq % TRACE_BUF_SIZE]; // Allows ring to wrap
ffff80000010c31d:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c324:	80 ff ff 
ffff80000010c327:	8b 40 6c             	mov    0x6c(%rax),%eax
ffff80000010c32a:	83 e0 7f             	and    $0x7f,%eax
ffff80000010c32d:	89 c0                	mov    %eax,%eax
ffff80000010c32f:	48 c1 e0 06          	shl    $0x6,%rax
ffff80000010c333:	48 8d 50 70          	lea    0x70(%rax),%rdx
ffff80000010c337:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c33e:	80 ff ff 
ffff80000010c341:	48 01 d0             	add    %rdx,%rax
ffff80000010c344:	48 83 c0 08          	add    $0x8,%rax
ffff80000010c348:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

    // Set the event metadata
    event->seq = traceBuffer.seq;
ffff80000010c34c:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c353:	80 ff ff 
ffff80000010c356:	8b 50 6c             	mov    0x6c(%rax),%edx
ffff80000010c359:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c35d:	89 10                	mov    %edx,(%rax)
    event->ticks = ticks;
ffff80000010c35f:	48 b8 48 bd 11 00 00 	movabs $0xffff80000011bd48,%rax
ffff80000010c366:	80 ff ff 
ffff80000010c369:	8b 10                	mov    (%rax),%edx
ffff80000010c36b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c36f:	89 50 04             	mov    %edx,0x4(%rax)
    event->type = type;
ffff80000010c372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c376:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff80000010c379:	89 50 08             	mov    %edx,0x8(%rax)
    event->pid = pid;
ffff80000010c37c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c380:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010c383:	89 50 0c             	mov    %edx,0xc(%rax)
    event->arg0 = arg0;
ffff80000010c386:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c38a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
ffff80000010c38d:	89 50 10             	mov    %edx,0x10(%rax)
    event->arg1 = arg1;
ffff80000010c390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c394:	8b 55 e0             	mov    -0x20(%rbp),%edx
ffff80000010c397:	89 50 14             	mov    %edx,0x14(%rax)
    event->arg2 = arg2;
ffff80000010c39a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c39e:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff80000010c3a1:	89 50 18             	mov    %edx,0x18(%rax)
    event->overwritten = traceBuffer.overwritten;
ffff80000010c3a4:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c3ab:	80 ff ff 
ffff80000010c3ae:	8b 50 74             	mov    0x74(%rax),%edx
ffff80000010c3b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c3b5:	89 50 3c             	mov    %edx,0x3c(%rax)

    memset(event->comm, 0, sizeof(event->comm));
ffff80000010c3b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c3bc:	48 83 c0 1c          	add    $0x1c,%rax
ffff80000010c3c0:	ba 10 00 00 00       	mov    $0x10,%edx
ffff80000010c3c5:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010c3ca:	48 89 c7             	mov    %rax,%rdi
ffff80000010c3cd:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff80000010c3d4:	80 ff ff 
ffff80000010c3d7:	ff d0                	call   *%rax
    if(proc && proc->pid > 0) {
ffff80000010c3d9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010c3e0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010c3e4:	48 85 c0             	test   %rax,%rax
ffff80000010c3e7:	74 45                	je     ffff80000010c42e <traceevent+0x15b>
ffff80000010c3e9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010c3f0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010c3f4:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff80000010c3f7:	85 c0                	test   %eax,%eax
ffff80000010c3f9:	7e 33                	jle    ffff80000010c42e <traceevent+0x15b>
        safestrcpy(event->comm, proc->name, sizeof(event->comm));
ffff80000010c3fb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010c402:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010c406:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff80000010c40d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c411:	48 83 c0 1c          	add    $0x1c,%rax
ffff80000010c415:	ba 10 00 00 00       	mov    $0x10,%edx
ffff80000010c41a:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c41d:	48 89 c7             	mov    %rax,%rdi
ffff80000010c420:	48 b8 26 7d 10 00 00 	movabs $0xffff800000107d26,%rax
ffff80000010c427:	80 ff ff 
ffff80000010c42a:	ff d0                	call   *%rax
ffff80000010c42c:	eb 29                	jmp    ffff80000010c457 <traceevent+0x184>
    } else {
        safestrcpy(event->comm, "kernel", sizeof(event->comm));
ffff80000010c42e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c432:	48 83 c0 1c          	add    $0x1c,%rax
ffff80000010c436:	48 b9 ec cd 10 00 00 	movabs $0xffff80000010cdec,%rcx
ffff80000010c43d:	80 ff ff 
ffff80000010c440:	ba 10 00 00 00       	mov    $0x10,%edx
ffff80000010c445:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c448:	48 89 c7             	mov    %rax,%rdi
ffff80000010c44b:	48 b8 26 7d 10 00 00 	movabs $0xffff800000107d26,%rax
ffff80000010c452:	80 ff ff 
ffff80000010c455:	ff d0                	call   *%rax
    }

    memset(event->event, 0, sizeof(event->event));
ffff80000010c457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c45b:	48 83 c0 2c          	add    $0x2c,%rax
ffff80000010c45f:	ba 10 00 00 00       	mov    $0x10,%edx
ffff80000010c464:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010c469:	48 89 c7             	mov    %rax,%rdi
ffff80000010c46c:	48 b8 6e 7a 10 00 00 	movabs $0xffff800000107a6e,%rax
ffff80000010c473:	80 ff ff 
ffff80000010c476:	ff d0                	call   *%rax
    if(name)
ffff80000010c478:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
ffff80000010c47d:	74 23                	je     ffff80000010c4a2 <traceevent+0x1cf>
        safestrcpy(event->event, name, sizeof(event->event));
ffff80000010c47f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c483:	48 8d 48 2c          	lea    0x2c(%rax),%rcx
ffff80000010c487:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c48b:	ba 10 00 00 00       	mov    $0x10,%edx
ffff80000010c490:	48 89 c6             	mov    %rax,%rsi
ffff80000010c493:	48 89 cf             	mov    %rcx,%rdi
ffff80000010c496:	48 b8 26 7d 10 00 00 	movabs $0xffff800000107d26,%rax
ffff80000010c49d:	80 ff ff 
ffff80000010c4a0:	ff d0                	call   *%rax

    traceBuffer.seq++; // Update sequence number
ffff80000010c4a2:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c4a9:	80 ff ff 
ffff80000010c4ac:	8b 40 6c             	mov    0x6c(%rax),%eax
ffff80000010c4af:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010c4b2:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c4b9:	80 ff ff 
ffff80000010c4bc:	89 50 6c             	mov    %edx,0x6c(%rax)

    // If the writer gets more than 128 events ahead, old events are gone, move readseq  foreward to the oldest event still available
    if(traceBuffer.seq - traceBuffer.readseq > TRACE_BUF_SIZE) {
ffff80000010c4bf:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c4c6:	80 ff ff 
ffff80000010c4c9:	8b 50 6c             	mov    0x6c(%rax),%edx
ffff80000010c4cc:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c4d3:	80 ff ff 
ffff80000010c4d6:	8b 40 70             	mov    0x70(%rax),%eax
ffff80000010c4d9:	29 c2                	sub    %eax,%edx
ffff80000010c4db:	81 fa 80 00 00 00    	cmp    $0x80,%edx
ffff80000010c4e1:	76 3a                	jbe    ffff80000010c51d <traceevent+0x24a>
        traceBuffer.readseq = traceBuffer.seq - TRACE_BUF_SIZE;
ffff80000010c4e3:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c4ea:	80 ff ff 
ffff80000010c4ed:	8b 40 6c             	mov    0x6c(%rax),%eax
ffff80000010c4f0:	8d 50 80             	lea    -0x80(%rax),%edx
ffff80000010c4f3:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c4fa:	80 ff ff 
ffff80000010c4fd:	89 50 70             	mov    %edx,0x70(%rax)
        traceBuffer.overwritten++;
ffff80000010c500:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c507:	80 ff ff 
ffff80000010c50a:	8b 40 74             	mov    0x74(%rax),%eax
ffff80000010c50d:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010c510:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c517:	80 ff ff 
ffff80000010c51a:	89 50 74             	mov    %edx,0x74(%rax)
    }

    // Release the lock
    release(&traceBuffer.lock);
ffff80000010c51d:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c524:	80 ff ff 
ffff80000010c527:	48 89 c7             	mov    %rax,%rdi
ffff80000010c52a:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010c531:	80 ff ff 
ffff80000010c534:	ff d0                	call   *%rax
ffff80000010c536:	eb 01                	jmp    ffff80000010c539 <traceevent+0x266>
        return;
ffff80000010c538:	90                   	nop
}
ffff80000010c539:	c9                   	leave
ffff80000010c53a:	c3                   	ret

ffff80000010c53b <traceread>:

int
traceread(struct trace_event *dst, int max_events){
ffff80000010c53b:	55                   	push   %rbp
ffff80000010c53c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c53f:	53                   	push   %rbx
ffff80000010c540:	48 83 ec 68          	sub    $0x68,%rsp
ffff80000010c544:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
ffff80000010c548:	89 75 94             	mov    %esi,-0x6c(%rbp)
    int count = 0;
ffff80000010c54b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

    if(max_events <= 0)
ffff80000010c552:	83 7d 94 00          	cmpl   $0x0,-0x6c(%rbp)
ffff80000010c556:	7f 0a                	jg     ffff80000010c562 <traceread+0x27>
        return 0;
ffff80000010c558:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c55d:	e9 58 01 00 00       	jmp    ffff80000010c6ba <traceread+0x17f>

    acquire(&traceBuffer.lock);
ffff80000010c562:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c569:	80 ff ff 
ffff80000010c56c:	48 89 c7             	mov    %rax,%rdi
ffff80000010c56f:	48 b8 da 76 10 00 00 	movabs $0xffff8000001076da,%rax
ffff80000010c576:	80 ff ff 
ffff80000010c579:	ff d0                	call   *%rax

    while(count < max_events && traceBuffer.readseq != traceBuffer.seq){
ffff80000010c57b:	e9 f4 00 00 00       	jmp    ffff80000010c674 <traceread+0x139>
        struct trace_event event = traceBuffer.events[traceBuffer.readseq % TRACE_BUF_SIZE];
ffff80000010c580:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c587:	80 ff ff 
ffff80000010c58a:	8b 40 70             	mov    0x70(%rax),%eax
ffff80000010c58d:	83 e0 7f             	and    $0x7f,%eax
ffff80000010c590:	48 ba 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rdx
ffff80000010c597:	80 ff ff 
ffff80000010c59a:	89 c0                	mov    %eax,%eax
ffff80000010c59c:	48 c1 e0 06          	shl    $0x6,%rax
ffff80000010c5a0:	48 01 d0             	add    %rdx,%rax
ffff80000010c5a3:	48 83 c0 70          	add    $0x70,%rax
ffff80000010c5a7:	48 8b 48 08          	mov    0x8(%rax),%rcx
ffff80000010c5ab:	48 8b 58 10          	mov    0x10(%rax),%rbx
ffff80000010c5af:	48 89 4d a0          	mov    %rcx,-0x60(%rbp)
ffff80000010c5b3:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
ffff80000010c5b7:	48 8b 48 18          	mov    0x18(%rax),%rcx
ffff80000010c5bb:	48 8b 58 20          	mov    0x20(%rax),%rbx
ffff80000010c5bf:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
ffff80000010c5c3:	48 89 5d b8          	mov    %rbx,-0x48(%rbp)
ffff80000010c5c7:	48 8b 48 28          	mov    0x28(%rax),%rcx
ffff80000010c5cb:	48 8b 58 30          	mov    0x30(%rax),%rbx
ffff80000010c5cf:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
ffff80000010c5d3:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
ffff80000010c5d7:	48 8b 50 40          	mov    0x40(%rax),%rdx
ffff80000010c5db:	48 8b 40 38          	mov    0x38(%rax),%rax
ffff80000010c5df:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
ffff80000010c5e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
        traceBuffer.readseq++;
ffff80000010c5e7:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c5ee:	80 ff ff 
ffff80000010c5f1:	8b 40 70             	mov    0x70(%rax),%eax
ffff80000010c5f4:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010c5f7:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c5fe:	80 ff ff 
ffff80000010c601:	89 50 70             	mov    %edx,0x70(%rax)
        
        // Release lock while copying to avoid holding it too long if copyout is slow
        // but wait, we need to be careful with readseq.
        // Actually, for xv6, keeping the lock is simpler and usually okay.
        
        if(copyout(proc->pgdir, (addr_t)&dst[count], &event, sizeof(event)) < 0){
ffff80000010c604:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010c607:	48 98                	cltq
ffff80000010c609:	48 c1 e0 06          	shl    $0x6,%rax
ffff80000010c60d:	48 89 c2             	mov    %rax,%rdx
ffff80000010c610:	48 8b 45 98          	mov    -0x68(%rbp),%rax
ffff80000010c614:	48 01 d0             	add    %rdx,%rax
ffff80000010c617:	48 89 c6             	mov    %rax,%rsi
ffff80000010c61a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010c621:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010c625:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010c629:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
ffff80000010c62d:	b9 40 00 00 00       	mov    $0x40,%ecx
ffff80000010c632:	48 89 c7             	mov    %rax,%rdi
ffff80000010c635:	48 b8 7b c1 10 00 00 	movabs $0xffff80000010c17b,%rax
ffff80000010c63c:	80 ff ff 
ffff80000010c63f:	ff d0                	call   *%rax
ffff80000010c641:	85 c0                	test   %eax,%eax
ffff80000010c643:	79 2b                	jns    ffff80000010c670 <traceread+0x135>
            release(&traceBuffer.lock);
ffff80000010c645:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c64c:	80 ff ff 
ffff80000010c64f:	48 89 c7             	mov    %rax,%rdi
ffff80000010c652:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010c659:	80 ff ff 
ffff80000010c65c:	ff d0                	call   *%rax
            return count > 0 ? count : -1;
ffff80000010c65e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff80000010c662:	7e 05                	jle    ffff80000010c669 <traceread+0x12e>
ffff80000010c664:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010c667:	eb 51                	jmp    ffff80000010c6ba <traceread+0x17f>
ffff80000010c669:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010c66e:	eb 4a                	jmp    ffff80000010c6ba <traceread+0x17f>
        }
        count++;
ffff80000010c670:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
    while(count < max_events && traceBuffer.readseq != traceBuffer.seq){
ffff80000010c674:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010c677:	3b 45 94             	cmp    -0x6c(%rbp),%eax
ffff80000010c67a:	7d 22                	jge    ffff80000010c69e <traceread+0x163>
ffff80000010c67c:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c683:	80 ff ff 
ffff80000010c686:	8b 50 70             	mov    0x70(%rax),%edx
ffff80000010c689:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c690:	80 ff ff 
ffff80000010c693:	8b 40 6c             	mov    0x6c(%rax),%eax
ffff80000010c696:	39 c2                	cmp    %eax,%edx
ffff80000010c698:	0f 85 e2 fe ff ff    	jne    ffff80000010c580 <traceread+0x45>
    }

    release(&traceBuffer.lock);
ffff80000010c69e:	48 b8 80 bd 11 00 00 	movabs $0xffff80000011bd80,%rax
ffff80000010c6a5:	80 ff ff 
ffff80000010c6a8:	48 89 c7             	mov    %rax,%rdi
ffff80000010c6ab:	48 b8 79 77 10 00 00 	movabs $0xffff800000107779,%rax
ffff80000010c6b2:	80 ff ff 
ffff80000010c6b5:	ff d0                	call   *%rax
    return count;
ffff80000010c6b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010c6ba:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
ffff80000010c6be:	c9                   	leave
ffff80000010c6bf:	c3                   	ret

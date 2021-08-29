
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 20 12 00       	mov    $0x122000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 20 12 c0       	mov    %eax,0xc0122000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 10 12 c0       	mov    $0xc0121000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 04 51 12 c0       	mov    $0xc0125104,%edx
c0100041:	b8 00 40 12 c0       	mov    $0xc0124000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 40 12 c0 	movl   $0xc0124000,(%esp)
c010005d:	e8 a7 8a 00 00       	call   c0108b09 <memset>

    cons_init();                // init the console
c0100062:	e8 20 1e 00 00       	call   c0101e87 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 e0 93 10 c0 	movl   $0xc01093e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c010007c:	e8 2a 02 00 00       	call   c01002ab <cprintf>

    print_kerninfo();
c0100081:	e8 cb 08 00 00       	call   c0100951 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 98 00 00 00       	call   c0100123 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 56 72 00 00       	call   c01072e6 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 56 1f 00 00       	call   c0101feb <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 af 20 00 00       	call   c0102149 <idt_init>

    vmm_init();                 // init virtual memory management
c010009a:	e8 25 36 00 00       	call   c01036c4 <vmm_init>

    ide_init();                 // init ide devices
c010009f:	e8 87 0d 00 00       	call   c0100e2b <ide_init>
    swap_init();                // init swap
c01000a4:	e8 aa 40 00 00       	call   c0104153 <swap_init>

    clock_init();               // init clock interrupt
c01000a9:	e8 8c 15 00 00       	call   c010163a <clock_init>
    intr_enable();              // enable irq interrupt
c01000ae:	e8 6b 20 00 00       	call   c010211e <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    // lab1_switch_test();

    /* do nothing */
    while (1);
c01000b3:	eb fe                	jmp    c01000b3 <kern_init+0x7d>

c01000b5 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b5:	55                   	push   %ebp
c01000b6:	89 e5                	mov    %esp,%ebp
c01000b8:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000c2:	00 
c01000c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000ca:	00 
c01000cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000d2:	e8 e9 0c 00 00       	call   c0100dc0 <mon_backtrace>
}
c01000d7:	90                   	nop
c01000d8:	c9                   	leave  
c01000d9:	c3                   	ret    

c01000da <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000da:	55                   	push   %ebp
c01000db:	89 e5                	mov    %esp,%ebp
c01000dd:	53                   	push   %ebx
c01000de:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000e4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000e7:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ed:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000f1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000f9:	89 04 24             	mov    %eax,(%esp)
c01000fc:	e8 b4 ff ff ff       	call   c01000b5 <grade_backtrace2>
}
c0100101:	90                   	nop
c0100102:	83 c4 14             	add    $0x14,%esp
c0100105:	5b                   	pop    %ebx
c0100106:	5d                   	pop    %ebp
c0100107:	c3                   	ret    

c0100108 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100108:	55                   	push   %ebp
c0100109:	89 e5                	mov    %esp,%ebp
c010010b:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100111:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100115:	8b 45 08             	mov    0x8(%ebp),%eax
c0100118:	89 04 24             	mov    %eax,(%esp)
c010011b:	e8 ba ff ff ff       	call   c01000da <grade_backtrace1>
}
c0100120:	90                   	nop
c0100121:	c9                   	leave  
c0100122:	c3                   	ret    

c0100123 <grade_backtrace>:

void
grade_backtrace(void) {
c0100123:	55                   	push   %ebp
c0100124:	89 e5                	mov    %esp,%ebp
c0100126:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100129:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010012e:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100135:	ff 
c0100136:	89 44 24 04          	mov    %eax,0x4(%esp)
c010013a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100141:	e8 c2 ff ff ff       	call   c0100108 <grade_backtrace0>
}
c0100146:	90                   	nop
c0100147:	c9                   	leave  
c0100148:	c3                   	ret    

c0100149 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100149:	55                   	push   %ebp
c010014a:	89 e5                	mov    %esp,%ebp
c010014c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010014f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100152:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100155:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100158:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010015b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010015f:	83 e0 03             	and    $0x3,%eax
c0100162:	89 c2                	mov    %eax,%edx
c0100164:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c0100169:	89 54 24 08          	mov    %edx,0x8(%esp)
c010016d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100171:	c7 04 24 01 94 10 c0 	movl   $0xc0109401,(%esp)
c0100178:	e8 2e 01 00 00       	call   c01002ab <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010017d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100181:	89 c2                	mov    %eax,%edx
c0100183:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c0100188:	89 54 24 08          	mov    %edx,0x8(%esp)
c010018c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100190:	c7 04 24 0f 94 10 c0 	movl   $0xc010940f,(%esp)
c0100197:	e8 0f 01 00 00       	call   c01002ab <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010019c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a0:	89 c2                	mov    %eax,%edx
c01001a2:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001a7:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001af:	c7 04 24 1d 94 10 c0 	movl   $0xc010941d,(%esp)
c01001b6:	e8 f0 00 00 00       	call   c01002ab <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001bb:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bf:	89 c2                	mov    %eax,%edx
c01001c1:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001c6:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ce:	c7 04 24 2b 94 10 c0 	movl   $0xc010942b,(%esp)
c01001d5:	e8 d1 00 00 00       	call   c01002ab <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001da:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001de:	89 c2                	mov    %eax,%edx
c01001e0:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001e5:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ed:	c7 04 24 39 94 10 c0 	movl   $0xc0109439,(%esp)
c01001f4:	e8 b2 00 00 00       	call   c01002ab <cprintf>
    round ++;
c01001f9:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001fe:	40                   	inc    %eax
c01001ff:	a3 00 40 12 c0       	mov    %eax,0xc0124000
}
c0100204:	90                   	nop
c0100205:	c9                   	leave  
c0100206:	c3                   	ret    

c0100207 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100207:	55                   	push   %ebp
c0100208:	89 e5                	mov    %esp,%ebp
    asm volatile(
c010020a:	6a 23                	push   $0x23
c010020c:	54                   	push   %esp
c010020d:	cd 78                	int    $0x78
c010020f:	5d                   	pop    %ebp
        "int %0;"
        "popl %%ebp;"
        :
        :"i"(T_SWITCH_TOU)
    );
}
c0100210:	90                   	nop
c0100211:	5d                   	pop    %ebp
c0100212:	c3                   	ret    

c0100213 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100213:	55                   	push   %ebp
c0100214:	89 e5                	mov    %esp,%ebp
    asm volatile(
c0100216:	cd 79                	int    $0x79
c0100218:	89 ec                	mov    %ebp,%esp
        "int %0;"
        "movl %%ebp, %%esp;"
        :
        :"i"(T_SWITCH_TOK)
    );
}
c010021a:	90                   	nop
c010021b:	5d                   	pop    %ebp
c010021c:	c3                   	ret    

c010021d <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010021d:	55                   	push   %ebp
c010021e:	89 e5                	mov    %esp,%ebp
c0100220:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100223:	e8 21 ff ff ff       	call   c0100149 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100228:	c7 04 24 48 94 10 c0 	movl   $0xc0109448,(%esp)
c010022f:	e8 77 00 00 00       	call   c01002ab <cprintf>
    lab1_switch_to_user();
c0100234:	e8 ce ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100239:	e8 0b ff ff ff       	call   c0100149 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010023e:	c7 04 24 68 94 10 c0 	movl   $0xc0109468,(%esp)
c0100245:	e8 61 00 00 00       	call   c01002ab <cprintf>
    lab1_switch_to_kernel();
c010024a:	e8 c4 ff ff ff       	call   c0100213 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010024f:	e8 f5 fe ff ff       	call   c0100149 <lab1_print_cur_status>
}
c0100254:	90                   	nop
c0100255:	c9                   	leave  
c0100256:	c3                   	ret    

c0100257 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100257:	55                   	push   %ebp
c0100258:	89 e5                	mov    %esp,%ebp
c010025a:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010025d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100260:	89 04 24             	mov    %eax,(%esp)
c0100263:	e8 4c 1c 00 00       	call   c0101eb4 <cons_putc>
    (*cnt) ++;
c0100268:	8b 45 0c             	mov    0xc(%ebp),%eax
c010026b:	8b 00                	mov    (%eax),%eax
c010026d:	8d 50 01             	lea    0x1(%eax),%edx
c0100270:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100273:	89 10                	mov    %edx,(%eax)
}
c0100275:	90                   	nop
c0100276:	c9                   	leave  
c0100277:	c3                   	ret    

c0100278 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100278:	55                   	push   %ebp
c0100279:	89 e5                	mov    %esp,%ebp
c010027b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010027e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100285:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100288:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010028c:	8b 45 08             	mov    0x8(%ebp),%eax
c010028f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100293:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100296:	89 44 24 04          	mov    %eax,0x4(%esp)
c010029a:	c7 04 24 57 02 10 c0 	movl   $0xc0100257,(%esp)
c01002a1:	e8 b6 8b 00 00       	call   c0108e5c <vprintfmt>
    return cnt;
c01002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002a9:	c9                   	leave  
c01002aa:	c3                   	ret    

c01002ab <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002ab:	55                   	push   %ebp
c01002ac:	89 e5                	mov    %esp,%ebp
c01002ae:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002b1:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002be:	8b 45 08             	mov    0x8(%ebp),%eax
c01002c1:	89 04 24             	mov    %eax,(%esp)
c01002c4:	e8 af ff ff ff       	call   c0100278 <vcprintf>
c01002c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002cf:	c9                   	leave  
c01002d0:	c3                   	ret    

c01002d1 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002d1:	55                   	push   %ebp
c01002d2:	89 e5                	mov    %esp,%ebp
c01002d4:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01002da:	89 04 24             	mov    %eax,(%esp)
c01002dd:	e8 d2 1b 00 00       	call   c0101eb4 <cons_putc>
}
c01002e2:	90                   	nop
c01002e3:	c9                   	leave  
c01002e4:	c3                   	ret    

c01002e5 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002e5:	55                   	push   %ebp
c01002e6:	89 e5                	mov    %esp,%ebp
c01002e8:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002f2:	eb 13                	jmp    c0100307 <cputs+0x22>
        cputch(c, &cnt);
c01002f4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002f8:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002fb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002ff:	89 04 24             	mov    %eax,(%esp)
c0100302:	e8 50 ff ff ff       	call   c0100257 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100307:	8b 45 08             	mov    0x8(%ebp),%eax
c010030a:	8d 50 01             	lea    0x1(%eax),%edx
c010030d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100310:	0f b6 00             	movzbl (%eax),%eax
c0100313:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100316:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c010031a:	75 d8                	jne    c01002f4 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c010031c:	8d 45 f0             	lea    -0x10(%ebp),%eax
c010031f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100323:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c010032a:	e8 28 ff ff ff       	call   c0100257 <cputch>
    return cnt;
c010032f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100332:	c9                   	leave  
c0100333:	c3                   	ret    

c0100334 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100334:	55                   	push   %ebp
c0100335:	89 e5                	mov    %esp,%ebp
c0100337:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010033a:	e8 b2 1b 00 00       	call   c0101ef1 <cons_getc>
c010033f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100346:	74 f2                	je     c010033a <getchar+0x6>
        /* do nothing */;
    return c;
c0100348:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010034b:	c9                   	leave  
c010034c:	c3                   	ret    

c010034d <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010034d:	55                   	push   %ebp
c010034e:	89 e5                	mov    %esp,%ebp
c0100350:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100353:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100357:	74 13                	je     c010036c <readline+0x1f>
        cprintf("%s", prompt);
c0100359:	8b 45 08             	mov    0x8(%ebp),%eax
c010035c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100360:	c7 04 24 87 94 10 c0 	movl   $0xc0109487,(%esp)
c0100367:	e8 3f ff ff ff       	call   c01002ab <cprintf>
    }
    int i = 0, c;
c010036c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100373:	e8 bc ff ff ff       	call   c0100334 <getchar>
c0100378:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010037b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010037f:	79 07                	jns    c0100388 <readline+0x3b>
            return NULL;
c0100381:	b8 00 00 00 00       	mov    $0x0,%eax
c0100386:	eb 78                	jmp    c0100400 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100388:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010038c:	7e 28                	jle    c01003b6 <readline+0x69>
c010038e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100395:	7f 1f                	jg     c01003b6 <readline+0x69>
            cputchar(c);
c0100397:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010039a:	89 04 24             	mov    %eax,(%esp)
c010039d:	e8 2f ff ff ff       	call   c01002d1 <cputchar>
            buf[i ++] = c;
c01003a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003a5:	8d 50 01             	lea    0x1(%eax),%edx
c01003a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003ae:	88 90 20 40 12 c0    	mov    %dl,-0x3fedbfe0(%eax)
c01003b4:	eb 45                	jmp    c01003fb <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01003b6:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003ba:	75 16                	jne    c01003d2 <readline+0x85>
c01003bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003c0:	7e 10                	jle    c01003d2 <readline+0x85>
            cputchar(c);
c01003c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c5:	89 04 24             	mov    %eax,(%esp)
c01003c8:	e8 04 ff ff ff       	call   c01002d1 <cputchar>
            i --;
c01003cd:	ff 4d f4             	decl   -0xc(%ebp)
c01003d0:	eb 29                	jmp    c01003fb <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01003d2:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003d6:	74 06                	je     c01003de <readline+0x91>
c01003d8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003dc:	75 95                	jne    c0100373 <readline+0x26>
            cputchar(c);
c01003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003e1:	89 04 24             	mov    %eax,(%esp)
c01003e4:	e8 e8 fe ff ff       	call   c01002d1 <cputchar>
            buf[i] = '\0';
c01003e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003ec:	05 20 40 12 c0       	add    $0xc0124020,%eax
c01003f1:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003f4:	b8 20 40 12 c0       	mov    $0xc0124020,%eax
c01003f9:	eb 05                	jmp    c0100400 <readline+0xb3>
        }
    }
c01003fb:	e9 73 ff ff ff       	jmp    c0100373 <readline+0x26>
}
c0100400:	c9                   	leave  
c0100401:	c3                   	ret    

c0100402 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100402:	55                   	push   %ebp
c0100403:	89 e5                	mov    %esp,%ebp
c0100405:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100408:	a1 20 44 12 c0       	mov    0xc0124420,%eax
c010040d:	85 c0                	test   %eax,%eax
c010040f:	75 5b                	jne    c010046c <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100411:	c7 05 20 44 12 c0 01 	movl   $0x1,0xc0124420
c0100418:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c010041b:	8d 45 14             	lea    0x14(%ebp),%eax
c010041e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100421:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100424:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100428:	8b 45 08             	mov    0x8(%ebp),%eax
c010042b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010042f:	c7 04 24 8a 94 10 c0 	movl   $0xc010948a,(%esp)
c0100436:	e8 70 fe ff ff       	call   c01002ab <cprintf>
    vcprintf(fmt, ap);
c010043b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010043e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100442:	8b 45 10             	mov    0x10(%ebp),%eax
c0100445:	89 04 24             	mov    %eax,(%esp)
c0100448:	e8 2b fe ff ff       	call   c0100278 <vcprintf>
    cprintf("\n");
c010044d:	c7 04 24 a6 94 10 c0 	movl   $0xc01094a6,(%esp)
c0100454:	e8 52 fe ff ff       	call   c01002ab <cprintf>
    
    cprintf("stack trackback:\n");
c0100459:	c7 04 24 a8 94 10 c0 	movl   $0xc01094a8,(%esp)
c0100460:	e8 46 fe ff ff       	call   c01002ab <cprintf>
    print_stackframe();
c0100465:	e8 32 06 00 00       	call   c0100a9c <print_stackframe>
c010046a:	eb 01                	jmp    c010046d <__panic+0x6b>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c010046c:	90                   	nop
    print_stackframe();
    
    va_end(ap);

panic_dead:
    intr_disable();
c010046d:	e8 b3 1c 00 00       	call   c0102125 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100472:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100479:	e8 75 08 00 00       	call   c0100cf3 <kmonitor>
    }
c010047e:	eb f2                	jmp    c0100472 <__panic+0x70>

c0100480 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100480:	55                   	push   %ebp
c0100481:	89 e5                	mov    %esp,%ebp
c0100483:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100486:	8d 45 14             	lea    0x14(%ebp),%eax
c0100489:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010048c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100493:	8b 45 08             	mov    0x8(%ebp),%eax
c0100496:	89 44 24 04          	mov    %eax,0x4(%esp)
c010049a:	c7 04 24 ba 94 10 c0 	movl   $0xc01094ba,(%esp)
c01004a1:	e8 05 fe ff ff       	call   c01002ab <cprintf>
    vcprintf(fmt, ap);
c01004a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b0:	89 04 24             	mov    %eax,(%esp)
c01004b3:	e8 c0 fd ff ff       	call   c0100278 <vcprintf>
    cprintf("\n");
c01004b8:	c7 04 24 a6 94 10 c0 	movl   $0xc01094a6,(%esp)
c01004bf:	e8 e7 fd ff ff       	call   c01002ab <cprintf>
    va_end(ap);
}
c01004c4:	90                   	nop
c01004c5:	c9                   	leave  
c01004c6:	c3                   	ret    

c01004c7 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004c7:	55                   	push   %ebp
c01004c8:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004ca:	a1 20 44 12 c0       	mov    0xc0124420,%eax
}
c01004cf:	5d                   	pop    %ebp
c01004d0:	c3                   	ret    

c01004d1 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004d1:	55                   	push   %ebp
c01004d2:	89 e5                	mov    %esp,%ebp
c01004d4:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004da:	8b 00                	mov    (%eax),%eax
c01004dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004df:	8b 45 10             	mov    0x10(%ebp),%eax
c01004e2:	8b 00                	mov    (%eax),%eax
c01004e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004ee:	e9 ca 00 00 00       	jmp    c01005bd <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c01004f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004f9:	01 d0                	add    %edx,%eax
c01004fb:	89 c2                	mov    %eax,%edx
c01004fd:	c1 ea 1f             	shr    $0x1f,%edx
c0100500:	01 d0                	add    %edx,%eax
c0100502:	d1 f8                	sar    %eax
c0100504:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100507:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010050a:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010050d:	eb 03                	jmp    c0100512 <stab_binsearch+0x41>
            m --;
c010050f:	ff 4d f0             	decl   -0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100512:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100515:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100518:	7c 1f                	jl     c0100539 <stab_binsearch+0x68>
c010051a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010051d:	89 d0                	mov    %edx,%eax
c010051f:	01 c0                	add    %eax,%eax
c0100521:	01 d0                	add    %edx,%eax
c0100523:	c1 e0 02             	shl    $0x2,%eax
c0100526:	89 c2                	mov    %eax,%edx
c0100528:	8b 45 08             	mov    0x8(%ebp),%eax
c010052b:	01 d0                	add    %edx,%eax
c010052d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100531:	0f b6 c0             	movzbl %al,%eax
c0100534:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100537:	75 d6                	jne    c010050f <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100539:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010053c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010053f:	7d 09                	jge    c010054a <stab_binsearch+0x79>
            l = true_m + 1;
c0100541:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100544:	40                   	inc    %eax
c0100545:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100548:	eb 73                	jmp    c01005bd <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c010054a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100551:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100554:	89 d0                	mov    %edx,%eax
c0100556:	01 c0                	add    %eax,%eax
c0100558:	01 d0                	add    %edx,%eax
c010055a:	c1 e0 02             	shl    $0x2,%eax
c010055d:	89 c2                	mov    %eax,%edx
c010055f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100562:	01 d0                	add    %edx,%eax
c0100564:	8b 40 08             	mov    0x8(%eax),%eax
c0100567:	3b 45 18             	cmp    0x18(%ebp),%eax
c010056a:	73 11                	jae    c010057d <stab_binsearch+0xac>
            *region_left = m;
c010056c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100572:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100574:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100577:	40                   	inc    %eax
c0100578:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010057b:	eb 40                	jmp    c01005bd <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c010057d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100580:	89 d0                	mov    %edx,%eax
c0100582:	01 c0                	add    %eax,%eax
c0100584:	01 d0                	add    %edx,%eax
c0100586:	c1 e0 02             	shl    $0x2,%eax
c0100589:	89 c2                	mov    %eax,%edx
c010058b:	8b 45 08             	mov    0x8(%ebp),%eax
c010058e:	01 d0                	add    %edx,%eax
c0100590:	8b 40 08             	mov    0x8(%eax),%eax
c0100593:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100596:	76 14                	jbe    c01005ac <stab_binsearch+0xdb>
            *region_right = m - 1;
c0100598:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010059e:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005a6:	48                   	dec    %eax
c01005a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005aa:	eb 11                	jmp    c01005bd <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005af:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b2:	89 10                	mov    %edx,(%eax)
            l = m;
c01005b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005ba:	ff 45 18             	incl   0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01005bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005c3:	0f 8e 2a ff ff ff    	jle    c01004f3 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01005c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005cd:	75 0f                	jne    c01005de <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005d2:	8b 00                	mov    (%eax),%eax
c01005d4:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005d7:	8b 45 10             	mov    0x10(%ebp),%eax
c01005da:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005dc:	eb 3e                	jmp    c010061c <stab_binsearch+0x14b>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005de:	8b 45 10             	mov    0x10(%ebp),%eax
c01005e1:	8b 00                	mov    (%eax),%eax
c01005e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005e6:	eb 03                	jmp    c01005eb <stab_binsearch+0x11a>
c01005e8:	ff 4d fc             	decl   -0x4(%ebp)
c01005eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ee:	8b 00                	mov    (%eax),%eax
c01005f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005f3:	7d 1f                	jge    c0100614 <stab_binsearch+0x143>
c01005f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005f8:	89 d0                	mov    %edx,%eax
c01005fa:	01 c0                	add    %eax,%eax
c01005fc:	01 d0                	add    %edx,%eax
c01005fe:	c1 e0 02             	shl    $0x2,%eax
c0100601:	89 c2                	mov    %eax,%edx
c0100603:	8b 45 08             	mov    0x8(%ebp),%eax
c0100606:	01 d0                	add    %edx,%eax
c0100608:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010060c:	0f b6 c0             	movzbl %al,%eax
c010060f:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100612:	75 d4                	jne    c01005e8 <stab_binsearch+0x117>
            /* do nothing */;
        *region_left = l;
c0100614:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100617:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010061a:	89 10                	mov    %edx,(%eax)
    }
}
c010061c:	90                   	nop
c010061d:	c9                   	leave  
c010061e:	c3                   	ret    

c010061f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010061f:	55                   	push   %ebp
c0100620:	89 e5                	mov    %esp,%ebp
c0100622:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100625:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100628:	c7 00 d8 94 10 c0    	movl   $0xc01094d8,(%eax)
    info->eip_line = 0;
c010062e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100631:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100638:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063b:	c7 40 08 d8 94 10 c0 	movl   $0xc01094d8,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100642:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100645:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010064c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010064f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100652:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100655:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100658:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010065f:	c7 45 f4 ac b4 10 c0 	movl   $0xc010b4ac,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100666:	c7 45 f0 b0 af 11 c0 	movl   $0xc011afb0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010066d:	c7 45 ec b1 af 11 c0 	movl   $0xc011afb1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100674:	c7 45 e8 94 e9 11 c0 	movl   $0xc011e994,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010067b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010067e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100681:	76 0b                	jbe    c010068e <debuginfo_eip+0x6f>
c0100683:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100686:	48                   	dec    %eax
c0100687:	0f b6 00             	movzbl (%eax),%eax
c010068a:	84 c0                	test   %al,%al
c010068c:	74 0a                	je     c0100698 <debuginfo_eip+0x79>
        return -1;
c010068e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100693:	e9 b7 02 00 00       	jmp    c010094f <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100698:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010069f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006a5:	29 c2                	sub    %eax,%edx
c01006a7:	89 d0                	mov    %edx,%eax
c01006a9:	c1 f8 02             	sar    $0x2,%eax
c01006ac:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006b2:	48                   	dec    %eax
c01006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01006b9:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006bd:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006c4:	00 
c01006c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006c8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006d6:	89 04 24             	mov    %eax,(%esp)
c01006d9:	e8 f3 fd ff ff       	call   c01004d1 <stab_binsearch>
    if (lfile == 0)
c01006de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e1:	85 c0                	test   %eax,%eax
c01006e3:	75 0a                	jne    c01006ef <debuginfo_eip+0xd0>
        return -1;
c01006e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006ea:	e9 60 02 00 00       	jmp    c010094f <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01006fe:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100702:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100709:	00 
c010070a:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010070d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100711:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100714:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100718:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071b:	89 04 24             	mov    %eax,(%esp)
c010071e:	e8 ae fd ff ff       	call   c01004d1 <stab_binsearch>

    if (lfun <= rfun) {
c0100723:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100726:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100729:	39 c2                	cmp    %eax,%edx
c010072b:	7f 7c                	jg     c01007a9 <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010072d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100730:	89 c2                	mov    %eax,%edx
c0100732:	89 d0                	mov    %edx,%eax
c0100734:	01 c0                	add    %eax,%eax
c0100736:	01 d0                	add    %edx,%eax
c0100738:	c1 e0 02             	shl    $0x2,%eax
c010073b:	89 c2                	mov    %eax,%edx
c010073d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100740:	01 d0                	add    %edx,%eax
c0100742:	8b 00                	mov    (%eax),%eax
c0100744:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100747:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010074a:	29 d1                	sub    %edx,%ecx
c010074c:	89 ca                	mov    %ecx,%edx
c010074e:	39 d0                	cmp    %edx,%eax
c0100750:	73 22                	jae    c0100774 <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100752:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100755:	89 c2                	mov    %eax,%edx
c0100757:	89 d0                	mov    %edx,%eax
c0100759:	01 c0                	add    %eax,%eax
c010075b:	01 d0                	add    %edx,%eax
c010075d:	c1 e0 02             	shl    $0x2,%eax
c0100760:	89 c2                	mov    %eax,%edx
c0100762:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100765:	01 d0                	add    %edx,%eax
c0100767:	8b 10                	mov    (%eax),%edx
c0100769:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010076c:	01 c2                	add    %eax,%edx
c010076e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100771:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100774:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100777:	89 c2                	mov    %eax,%edx
c0100779:	89 d0                	mov    %edx,%eax
c010077b:	01 c0                	add    %eax,%eax
c010077d:	01 d0                	add    %edx,%eax
c010077f:	c1 e0 02             	shl    $0x2,%eax
c0100782:	89 c2                	mov    %eax,%edx
c0100784:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	8b 50 08             	mov    0x8(%eax),%edx
c010078c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078f:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100792:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100795:	8b 40 10             	mov    0x10(%eax),%eax
c0100798:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c010079b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010079e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007a7:	eb 15                	jmp    c01007be <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ac:	8b 55 08             	mov    0x8(%ebp),%edx
c01007af:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c1:	8b 40 08             	mov    0x8(%eax),%eax
c01007c4:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007cb:	00 
c01007cc:	89 04 24             	mov    %eax,(%esp)
c01007cf:	e8 b1 81 00 00       	call   c0108985 <strfind>
c01007d4:	89 c2                	mov    %eax,%edx
c01007d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d9:	8b 40 08             	mov    0x8(%eax),%eax
c01007dc:	29 c2                	sub    %eax,%edx
c01007de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e1:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01007e7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007eb:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007f2:	00 
c01007f3:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007fa:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100801:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100804:	89 04 24             	mov    %eax,(%esp)
c0100807:	e8 c5 fc ff ff       	call   c01004d1 <stab_binsearch>
    if (lline <= rline) {
c010080c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010080f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100812:	39 c2                	cmp    %eax,%edx
c0100814:	7f 23                	jg     c0100839 <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
c0100816:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100819:	89 c2                	mov    %eax,%edx
c010081b:	89 d0                	mov    %edx,%eax
c010081d:	01 c0                	add    %eax,%eax
c010081f:	01 d0                	add    %edx,%eax
c0100821:	c1 e0 02             	shl    $0x2,%eax
c0100824:	89 c2                	mov    %eax,%edx
c0100826:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100829:	01 d0                	add    %edx,%eax
c010082b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010082f:	89 c2                	mov    %eax,%edx
c0100831:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100834:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100837:	eb 11                	jmp    c010084a <debuginfo_eip+0x22b>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010083e:	e9 0c 01 00 00       	jmp    c010094f <debuginfo_eip+0x330>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100843:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100846:	48                   	dec    %eax
c0100847:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010084a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100850:	39 c2                	cmp    %eax,%edx
c0100852:	7c 56                	jl     c01008aa <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
c0100854:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100857:	89 c2                	mov    %eax,%edx
c0100859:	89 d0                	mov    %edx,%eax
c010085b:	01 c0                	add    %eax,%eax
c010085d:	01 d0                	add    %edx,%eax
c010085f:	c1 e0 02             	shl    $0x2,%eax
c0100862:	89 c2                	mov    %eax,%edx
c0100864:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100867:	01 d0                	add    %edx,%eax
c0100869:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086d:	3c 84                	cmp    $0x84,%al
c010086f:	74 39                	je     c01008aa <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100871:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100874:	89 c2                	mov    %eax,%edx
c0100876:	89 d0                	mov    %edx,%eax
c0100878:	01 c0                	add    %eax,%eax
c010087a:	01 d0                	add    %edx,%eax
c010087c:	c1 e0 02             	shl    $0x2,%eax
c010087f:	89 c2                	mov    %eax,%edx
c0100881:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100884:	01 d0                	add    %edx,%eax
c0100886:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010088a:	3c 64                	cmp    $0x64,%al
c010088c:	75 b5                	jne    c0100843 <debuginfo_eip+0x224>
c010088e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100891:	89 c2                	mov    %eax,%edx
c0100893:	89 d0                	mov    %edx,%eax
c0100895:	01 c0                	add    %eax,%eax
c0100897:	01 d0                	add    %edx,%eax
c0100899:	c1 e0 02             	shl    $0x2,%eax
c010089c:	89 c2                	mov    %eax,%edx
c010089e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a1:	01 d0                	add    %edx,%eax
c01008a3:	8b 40 08             	mov    0x8(%eax),%eax
c01008a6:	85 c0                	test   %eax,%eax
c01008a8:	74 99                	je     c0100843 <debuginfo_eip+0x224>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008b0:	39 c2                	cmp    %eax,%edx
c01008b2:	7c 46                	jl     c01008fa <debuginfo_eip+0x2db>
c01008b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008b7:	89 c2                	mov    %eax,%edx
c01008b9:	89 d0                	mov    %edx,%eax
c01008bb:	01 c0                	add    %eax,%eax
c01008bd:	01 d0                	add    %edx,%eax
c01008bf:	c1 e0 02             	shl    $0x2,%eax
c01008c2:	89 c2                	mov    %eax,%edx
c01008c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008c7:	01 d0                	add    %edx,%eax
c01008c9:	8b 00                	mov    (%eax),%eax
c01008cb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01008d1:	29 d1                	sub    %edx,%ecx
c01008d3:	89 ca                	mov    %ecx,%edx
c01008d5:	39 d0                	cmp    %edx,%eax
c01008d7:	73 21                	jae    c01008fa <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008dc:	89 c2                	mov    %eax,%edx
c01008de:	89 d0                	mov    %edx,%eax
c01008e0:	01 c0                	add    %eax,%eax
c01008e2:	01 d0                	add    %edx,%eax
c01008e4:	c1 e0 02             	shl    $0x2,%eax
c01008e7:	89 c2                	mov    %eax,%edx
c01008e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ec:	01 d0                	add    %edx,%eax
c01008ee:	8b 10                	mov    (%eax),%edx
c01008f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008f3:	01 c2                	add    %eax,%edx
c01008f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f8:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100900:	39 c2                	cmp    %eax,%edx
c0100902:	7d 46                	jge    c010094a <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
c0100904:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100907:	40                   	inc    %eax
c0100908:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010090b:	eb 16                	jmp    c0100923 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010090d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100910:	8b 40 14             	mov    0x14(%eax),%eax
c0100913:	8d 50 01             	lea    0x1(%eax),%edx
c0100916:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100919:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c010091c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010091f:	40                   	inc    %eax
c0100920:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100923:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100926:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100929:	39 c2                	cmp    %eax,%edx
c010092b:	7d 1d                	jge    c010094a <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010092d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100930:	89 c2                	mov    %eax,%edx
c0100932:	89 d0                	mov    %edx,%eax
c0100934:	01 c0                	add    %eax,%eax
c0100936:	01 d0                	add    %edx,%eax
c0100938:	c1 e0 02             	shl    $0x2,%eax
c010093b:	89 c2                	mov    %eax,%edx
c010093d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100940:	01 d0                	add    %edx,%eax
c0100942:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100946:	3c a0                	cmp    $0xa0,%al
c0100948:	74 c3                	je     c010090d <debuginfo_eip+0x2ee>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c010094a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010094f:	c9                   	leave  
c0100950:	c3                   	ret    

c0100951 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100951:	55                   	push   %ebp
c0100952:	89 e5                	mov    %esp,%ebp
c0100954:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100957:	c7 04 24 e2 94 10 c0 	movl   $0xc01094e2,(%esp)
c010095e:	e8 48 f9 ff ff       	call   c01002ab <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100963:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c010096a:	c0 
c010096b:	c7 04 24 fb 94 10 c0 	movl   $0xc01094fb,(%esp)
c0100972:	e8 34 f9 ff ff       	call   c01002ab <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100977:	c7 44 24 04 db 93 10 	movl   $0xc01093db,0x4(%esp)
c010097e:	c0 
c010097f:	c7 04 24 13 95 10 c0 	movl   $0xc0109513,(%esp)
c0100986:	e8 20 f9 ff ff       	call   c01002ab <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c010098b:	c7 44 24 04 00 40 12 	movl   $0xc0124000,0x4(%esp)
c0100992:	c0 
c0100993:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c010099a:	e8 0c f9 ff ff       	call   c01002ab <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c010099f:	c7 44 24 04 04 51 12 	movl   $0xc0125104,0x4(%esp)
c01009a6:	c0 
c01009a7:	c7 04 24 43 95 10 c0 	movl   $0xc0109543,(%esp)
c01009ae:	e8 f8 f8 ff ff       	call   c01002ab <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009b3:	b8 04 51 12 c0       	mov    $0xc0125104,%eax
c01009b8:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009be:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009c3:	29 c2                	sub    %eax,%edx
c01009c5:	89 d0                	mov    %edx,%eax
c01009c7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009cd:	85 c0                	test   %eax,%eax
c01009cf:	0f 48 c2             	cmovs  %edx,%eax
c01009d2:	c1 f8 0a             	sar    $0xa,%eax
c01009d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009d9:	c7 04 24 5c 95 10 c0 	movl   $0xc010955c,(%esp)
c01009e0:	e8 c6 f8 ff ff       	call   c01002ab <cprintf>
}
c01009e5:	90                   	nop
c01009e6:	c9                   	leave  
c01009e7:	c3                   	ret    

c01009e8 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009e8:	55                   	push   %ebp
c01009e9:	89 e5                	mov    %esp,%ebp
c01009eb:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009f1:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01009fb:	89 04 24             	mov    %eax,(%esp)
c01009fe:	e8 1c fc ff ff       	call   c010061f <debuginfo_eip>
c0100a03:	85 c0                	test   %eax,%eax
c0100a05:	74 15                	je     c0100a1c <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0e:	c7 04 24 86 95 10 c0 	movl   $0xc0109586,(%esp)
c0100a15:	e8 91 f8 ff ff       	call   c01002ab <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a1a:	eb 6c                	jmp    c0100a88 <print_debuginfo+0xa0>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a23:	eb 1b                	jmp    c0100a40 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100a25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a2b:	01 d0                	add    %edx,%eax
c0100a2d:	0f b6 00             	movzbl (%eax),%eax
c0100a30:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a39:	01 ca                	add    %ecx,%edx
c0100a3b:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a3d:	ff 45 f4             	incl   -0xc(%ebp)
c0100a40:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a43:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a46:	7f dd                	jg     c0100a25 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a48:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a51:	01 d0                	add    %edx,%eax
c0100a53:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a59:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a5c:	89 d1                	mov    %edx,%ecx
c0100a5e:	29 c1                	sub    %eax,%ecx
c0100a60:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a63:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a66:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a6a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a70:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a74:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a7c:	c7 04 24 a2 95 10 c0 	movl   $0xc01095a2,(%esp)
c0100a83:	e8 23 f8 ff ff       	call   c01002ab <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a88:	90                   	nop
c0100a89:	c9                   	leave  
c0100a8a:	c3                   	ret    

c0100a8b <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a8b:	55                   	push   %ebp
c0100a8c:	89 e5                	mov    %esp,%ebp
c0100a8e:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a91:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a94:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a9a:	c9                   	leave  
c0100a9b:	c3                   	ret    

c0100a9c <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a9c:	55                   	push   %ebp
c0100a9d:	89 e5                	mov    %esp,%ebp
c0100a9f:	53                   	push   %ebx
c0100aa0:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100aa3:	89 e8                	mov    %ebp,%eax
c0100aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
c0100aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uintptr_t ebp = read_ebp();
c0100aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t eip = read_eip();
c0100aae:	e8 d8 ff ff ff       	call   c0100a8b <read_eip>
c0100ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32_t args[4] = {0};
c0100ab6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0100abd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0100ac4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100acb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while(ebp != 0){
c0100ad2:	e9 9b 00 00 00       	jmp    c0100b72 <print_stackframe+0xd6>
        asm volatile("movl 8(%1), %0":"=r"(args[0]):"b"(ebp));
c0100ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ada:	89 c3                	mov    %eax,%ebx
c0100adc:	8b 43 08             	mov    0x8(%ebx),%eax
c0100adf:	89 45 dc             	mov    %eax,-0x24(%ebp)
        asm volatile("movl 12(%1), %0":"=r"(args[1]):"b"(ebp));
c0100ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae5:	89 c3                	mov    %eax,%ebx
c0100ae7:	8b 43 0c             	mov    0xc(%ebx),%eax
c0100aea:	89 45 e0             	mov    %eax,-0x20(%ebp)
        asm volatile("movl 16(%1), %0":"=r"(args[2]):"b"(ebp));
c0100aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af0:	89 c3                	mov    %eax,%ebx
c0100af2:	8b 43 10             	mov    0x10(%ebx),%eax
c0100af5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        asm volatile("movl 20(%1), %0":"=r"(args[3]):"b"(ebp));
c0100af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afb:	89 c3                	mov    %eax,%ebx
c0100afd:	8b 43 14             	mov    0x14(%ebx),%eax
c0100b00:	89 45 e8             	mov    %eax,-0x18(%ebp)
        cprintf("ebp:0x%x eip:0x%x ", ebp, eip);
c0100b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b06:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b11:	c7 04 24 b4 95 10 c0 	movl   $0xc01095b4,(%esp)
c0100b18:	e8 8e f7 ff ff       	call   c01002ab <cprintf>
        cprintf("args:0x%x 0x%x ", args[0], args[1]);
c0100b1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100b20:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100b23:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2b:	c7 04 24 c7 95 10 c0 	movl   $0xc01095c7,(%esp)
c0100b32:	e8 74 f7 ff ff       	call   c01002ab <cprintf>
        cprintf("0x%x 0x%x\n", args[2], args[3]);
c0100b37:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0100b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b3d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b45:	c7 04 24 d7 95 10 c0 	movl   $0xc01095d7,(%esp)
c0100b4c:	e8 5a f7 ff ff       	call   c01002ab <cprintf>
        print_debuginfo(eip-1);
c0100b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b54:	48                   	dec    %eax
c0100b55:	89 04 24             	mov    %eax,(%esp)
c0100b58:	e8 8b fe ff ff       	call   c01009e8 <print_debuginfo>

        // asm volatile("movl 4(%0), %1"::"a"(ebp), "b"(eip));
        asm volatile(
c0100b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b60:	89 c3                	mov    %eax,%ebx
c0100b62:	8b 43 04             	mov    0x4(%ebx),%eax
c0100b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
            "movl 4(%1), %0;"
            :"=a"(eip)
            :"b"(ebp)
        );
        // asm volatile("movl (%0), %1"::"=r"(ebp), "b"(ebp));
        asm volatile(
c0100b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b6b:	89 c3                	mov    %eax,%ebx
c0100b6d:	8b 03                	mov    (%ebx),%eax
c0100b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uintptr_t ebp = read_ebp();
    uintptr_t eip = read_eip();
    uint32_t args[4] = {0};
    while(ebp != 0){
c0100b72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b76:	0f 85 5b ff ff ff    	jne    c0100ad7 <print_stackframe+0x3b>
            "movl (%1), %0;"
            :"=a"(ebp)
            :"b"(ebp)
        );
    }
}
c0100b7c:	90                   	nop
c0100b7d:	83 c4 34             	add    $0x34,%esp
c0100b80:	5b                   	pop    %ebx
c0100b81:	5d                   	pop    %ebp
c0100b82:	c3                   	ret    

c0100b83 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b83:	55                   	push   %ebp
c0100b84:	89 e5                	mov    %esp,%ebp
c0100b86:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b90:	eb 0c                	jmp    c0100b9e <parse+0x1b>
            *buf ++ = '\0';
c0100b92:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b95:	8d 50 01             	lea    0x1(%eax),%edx
c0100b98:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b9b:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba1:	0f b6 00             	movzbl (%eax),%eax
c0100ba4:	84 c0                	test   %al,%al
c0100ba6:	74 1d                	je     c0100bc5 <parse+0x42>
c0100ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bab:	0f b6 00             	movzbl (%eax),%eax
c0100bae:	0f be c0             	movsbl %al,%eax
c0100bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bb5:	c7 04 24 64 96 10 c0 	movl   $0xc0109664,(%esp)
c0100bbc:	e8 92 7d 00 00       	call   c0108953 <strchr>
c0100bc1:	85 c0                	test   %eax,%eax
c0100bc3:	75 cd                	jne    c0100b92 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100bc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc8:	0f b6 00             	movzbl (%eax),%eax
c0100bcb:	84 c0                	test   %al,%al
c0100bcd:	74 69                	je     c0100c38 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bcf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bd3:	75 14                	jne    c0100be9 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bd5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bdc:	00 
c0100bdd:	c7 04 24 69 96 10 c0 	movl   $0xc0109669,(%esp)
c0100be4:	e8 c2 f6 ff ff       	call   c01002ab <cprintf>
        }
        argv[argc ++] = buf;
c0100be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bec:	8d 50 01             	lea    0x1(%eax),%edx
c0100bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bf2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bfc:	01 c2                	add    %eax,%edx
c0100bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c01:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c03:	eb 03                	jmp    c0100c08 <parse+0x85>
            buf ++;
c0100c05:	ff 45 08             	incl   0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c08:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0b:	0f b6 00             	movzbl (%eax),%eax
c0100c0e:	84 c0                	test   %al,%al
c0100c10:	0f 84 7a ff ff ff    	je     c0100b90 <parse+0xd>
c0100c16:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c19:	0f b6 00             	movzbl (%eax),%eax
c0100c1c:	0f be c0             	movsbl %al,%eax
c0100c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c23:	c7 04 24 64 96 10 c0 	movl   $0xc0109664,(%esp)
c0100c2a:	e8 24 7d 00 00       	call   c0108953 <strchr>
c0100c2f:	85 c0                	test   %eax,%eax
c0100c31:	74 d2                	je     c0100c05 <parse+0x82>
            buf ++;
        }
    }
c0100c33:	e9 58 ff ff ff       	jmp    c0100b90 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100c38:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c3c:	c9                   	leave  
c0100c3d:	c3                   	ret    

c0100c3e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c3e:	55                   	push   %ebp
c0100c3f:	89 e5                	mov    %esp,%ebp
c0100c41:	53                   	push   %ebx
c0100c42:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c45:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c4f:	89 04 24             	mov    %eax,(%esp)
c0100c52:	e8 2c ff ff ff       	call   c0100b83 <parse>
c0100c57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c5e:	75 0a                	jne    c0100c6a <runcmd+0x2c>
        return 0;
c0100c60:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c65:	e9 83 00 00 00       	jmp    c0100ced <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c71:	eb 5a                	jmp    c0100ccd <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c73:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c76:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c79:	89 d0                	mov    %edx,%eax
c0100c7b:	01 c0                	add    %eax,%eax
c0100c7d:	01 d0                	add    %edx,%eax
c0100c7f:	c1 e0 02             	shl    $0x2,%eax
c0100c82:	05 00 10 12 c0       	add    $0xc0121000,%eax
c0100c87:	8b 00                	mov    (%eax),%eax
c0100c89:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c8d:	89 04 24             	mov    %eax,(%esp)
c0100c90:	e8 21 7c 00 00       	call   c01088b6 <strcmp>
c0100c95:	85 c0                	test   %eax,%eax
c0100c97:	75 31                	jne    c0100cca <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c99:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c9c:	89 d0                	mov    %edx,%eax
c0100c9e:	01 c0                	add    %eax,%eax
c0100ca0:	01 d0                	add    %edx,%eax
c0100ca2:	c1 e0 02             	shl    $0x2,%eax
c0100ca5:	05 08 10 12 c0       	add    $0xc0121008,%eax
c0100caa:	8b 10                	mov    (%eax),%edx
c0100cac:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100caf:	83 c0 04             	add    $0x4,%eax
c0100cb2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100cb5:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100cb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100cbb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cc3:	89 1c 24             	mov    %ebx,(%esp)
c0100cc6:	ff d2                	call   *%edx
c0100cc8:	eb 23                	jmp    c0100ced <runcmd+0xaf>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cca:	ff 45 f4             	incl   -0xc(%ebp)
c0100ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cd0:	83 f8 02             	cmp    $0x2,%eax
c0100cd3:	76 9e                	jbe    c0100c73 <runcmd+0x35>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cd5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cdc:	c7 04 24 87 96 10 c0 	movl   $0xc0109687,(%esp)
c0100ce3:	e8 c3 f5 ff ff       	call   c01002ab <cprintf>
    return 0;
c0100ce8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ced:	83 c4 64             	add    $0x64,%esp
c0100cf0:	5b                   	pop    %ebx
c0100cf1:	5d                   	pop    %ebp
c0100cf2:	c3                   	ret    

c0100cf3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cf3:	55                   	push   %ebp
c0100cf4:	89 e5                	mov    %esp,%ebp
c0100cf6:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cf9:	c7 04 24 a0 96 10 c0 	movl   $0xc01096a0,(%esp)
c0100d00:	e8 a6 f5 ff ff       	call   c01002ab <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d05:	c7 04 24 c8 96 10 c0 	movl   $0xc01096c8,(%esp)
c0100d0c:	e8 9a f5 ff ff       	call   c01002ab <cprintf>

    if (tf != NULL) {
c0100d11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d15:	74 0b                	je     c0100d22 <kmonitor+0x2f>
        print_trapframe(tf);
c0100d17:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d1a:	89 04 24             	mov    %eax,(%esp)
c0100d1d:	e8 e4 15 00 00       	call   c0102306 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d22:	c7 04 24 ed 96 10 c0 	movl   $0xc01096ed,(%esp)
c0100d29:	e8 1f f6 ff ff       	call   c010034d <readline>
c0100d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d35:	74 eb                	je     c0100d22 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100d37:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d41:	89 04 24             	mov    %eax,(%esp)
c0100d44:	e8 f5 fe ff ff       	call   c0100c3e <runcmd>
c0100d49:	85 c0                	test   %eax,%eax
c0100d4b:	78 02                	js     c0100d4f <kmonitor+0x5c>
                break;
            }
        }
    }
c0100d4d:	eb d3                	jmp    c0100d22 <kmonitor+0x2f>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100d4f:	90                   	nop
            }
        }
    }
}
c0100d50:	90                   	nop
c0100d51:	c9                   	leave  
c0100d52:	c3                   	ret    

c0100d53 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d53:	55                   	push   %ebp
c0100d54:	89 e5                	mov    %esp,%ebp
c0100d56:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d60:	eb 3d                	jmp    c0100d9f <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d62:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d65:	89 d0                	mov    %edx,%eax
c0100d67:	01 c0                	add    %eax,%eax
c0100d69:	01 d0                	add    %edx,%eax
c0100d6b:	c1 e0 02             	shl    $0x2,%eax
c0100d6e:	05 04 10 12 c0       	add    $0xc0121004,%eax
c0100d73:	8b 08                	mov    (%eax),%ecx
c0100d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d78:	89 d0                	mov    %edx,%eax
c0100d7a:	01 c0                	add    %eax,%eax
c0100d7c:	01 d0                	add    %edx,%eax
c0100d7e:	c1 e0 02             	shl    $0x2,%eax
c0100d81:	05 00 10 12 c0       	add    $0xc0121000,%eax
c0100d86:	8b 00                	mov    (%eax),%eax
c0100d88:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d90:	c7 04 24 f1 96 10 c0 	movl   $0xc01096f1,(%esp)
c0100d97:	e8 0f f5 ff ff       	call   c01002ab <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d9c:	ff 45 f4             	incl   -0xc(%ebp)
c0100d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100da2:	83 f8 02             	cmp    $0x2,%eax
c0100da5:	76 bb                	jbe    c0100d62 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dac:	c9                   	leave  
c0100dad:	c3                   	ret    

c0100dae <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100dae:	55                   	push   %ebp
c0100daf:	89 e5                	mov    %esp,%ebp
c0100db1:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100db4:	e8 98 fb ff ff       	call   c0100951 <print_kerninfo>
    return 0;
c0100db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dbe:	c9                   	leave  
c0100dbf:	c3                   	ret    

c0100dc0 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100dc0:	55                   	push   %ebp
c0100dc1:	89 e5                	mov    %esp,%ebp
c0100dc3:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100dc6:	e8 d1 fc ff ff       	call   c0100a9c <print_stackframe>
    return 0;
c0100dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dd0:	c9                   	leave  
c0100dd1:	c3                   	ret    

c0100dd2 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c0100dd2:	55                   	push   %ebp
c0100dd3:	89 e5                	mov    %esp,%ebp
c0100dd5:	83 ec 14             	sub    $0x14,%esp
c0100dd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ddb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0100ddf:	90                   	nop
c0100de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100de3:	83 c0 07             	add    $0x7,%eax
c0100de6:	0f b7 c0             	movzwl %ax,%eax
c0100de9:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ded:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100df1:	89 c2                	mov    %eax,%edx
c0100df3:	ec                   	in     (%dx),%al
c0100df4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100df7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100dfb:	0f b6 c0             	movzbl %al,%eax
c0100dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e04:	25 80 00 00 00       	and    $0x80,%eax
c0100e09:	85 c0                	test   %eax,%eax
c0100e0b:	75 d3                	jne    c0100de0 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0100e0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0100e11:	74 11                	je     c0100e24 <ide_wait_ready+0x52>
c0100e13:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e16:	83 e0 21             	and    $0x21,%eax
c0100e19:	85 c0                	test   %eax,%eax
c0100e1b:	74 07                	je     c0100e24 <ide_wait_ready+0x52>
        return -1;
c0100e1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100e22:	eb 05                	jmp    c0100e29 <ide_wait_ready+0x57>
    }
    return 0;
c0100e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e29:	c9                   	leave  
c0100e2a:	c3                   	ret    

c0100e2b <ide_init>:

void
ide_init(void) {
c0100e2b:	55                   	push   %ebp
c0100e2c:	89 e5                	mov    %esp,%ebp
c0100e2e:	57                   	push   %edi
c0100e2f:	53                   	push   %ebx
c0100e30:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0100e36:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0100e3c:	e9 d4 02 00 00       	jmp    c0101115 <ide_init+0x2ea>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0100e41:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e45:	c1 e0 03             	shl    $0x3,%eax
c0100e48:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100e4f:	29 c2                	sub    %eax,%edx
c0100e51:	89 d0                	mov    %edx,%eax
c0100e53:	05 40 44 12 c0       	add    $0xc0124440,%eax
c0100e58:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0100e5b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e5f:	d1 e8                	shr    %eax
c0100e61:	0f b7 c0             	movzwl %ax,%eax
c0100e64:	8b 04 85 fc 96 10 c0 	mov    -0x3fef6904(,%eax,4),%eax
c0100e6b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0100e6f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e73:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100e7a:	00 
c0100e7b:	89 04 24             	mov    %eax,(%esp)
c0100e7e:	e8 4f ff ff ff       	call   c0100dd2 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0100e83:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e87:	83 e0 01             	and    $0x1,%eax
c0100e8a:	c1 e0 04             	shl    $0x4,%eax
c0100e8d:	0c e0                	or     $0xe0,%al
c0100e8f:	0f b6 c0             	movzbl %al,%eax
c0100e92:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e96:	83 c2 06             	add    $0x6,%edx
c0100e99:	0f b7 d2             	movzwl %dx,%edx
c0100e9c:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0100ea0:	88 45 c7             	mov    %al,-0x39(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ea3:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
c0100ea7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100eab:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100eac:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100eb0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100eb7:	00 
c0100eb8:	89 04 24             	mov    %eax,(%esp)
c0100ebb:	e8 12 ff ff ff       	call   c0100dd2 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c0100ec0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ec4:	83 c0 07             	add    $0x7,%eax
c0100ec7:	0f b7 c0             	movzwl %ax,%eax
c0100eca:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
c0100ece:	c6 45 c8 ec          	movb   $0xec,-0x38(%ebp)
c0100ed2:	0f b6 45 c8          	movzbl -0x38(%ebp),%eax
c0100ed6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100ed9:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100eda:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ede:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100ee5:	00 
c0100ee6:	89 04 24             	mov    %eax,(%esp)
c0100ee9:	e8 e4 fe ff ff       	call   c0100dd2 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0100eee:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ef2:	83 c0 07             	add    $0x7,%eax
c0100ef5:	0f b7 c0             	movzwl %ax,%eax
c0100ef8:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100efc:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c0100f00:	89 c2                	mov    %eax,%edx
c0100f02:	ec                   	in     (%dx),%al
c0100f03:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c0100f06:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0100f0a:	84 c0                	test   %al,%al
c0100f0c:	0f 84 f9 01 00 00    	je     c010110b <ide_init+0x2e0>
c0100f12:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f16:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0100f1d:	00 
c0100f1e:	89 04 24             	mov    %eax,(%esp)
c0100f21:	e8 ac fe ff ff       	call   c0100dd2 <ide_wait_ready>
c0100f26:	85 c0                	test   %eax,%eax
c0100f28:	0f 85 dd 01 00 00    	jne    c010110b <ide_init+0x2e0>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0100f2e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f32:	c1 e0 03             	shl    $0x3,%eax
c0100f35:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100f3c:	29 c2                	sub    %eax,%edx
c0100f3e:	89 d0                	mov    %edx,%eax
c0100f40:	05 40 44 12 c0       	add    $0xc0124440,%eax
c0100f45:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0100f48:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0100f4f:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f55:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0100f58:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0100f5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100f62:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0100f65:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0100f68:	89 cb                	mov    %ecx,%ebx
c0100f6a:	89 df                	mov    %ebx,%edi
c0100f6c:	89 c1                	mov    %eax,%ecx
c0100f6e:	fc                   	cld    
c0100f6f:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0100f71:	89 c8                	mov    %ecx,%eax
c0100f73:	89 fb                	mov    %edi,%ebx
c0100f75:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0100f78:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0100f7b:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f81:	89 45 dc             	mov    %eax,-0x24(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0100f84:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f87:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0100f8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0100f90:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100f93:	25 00 00 00 04       	and    $0x4000000,%eax
c0100f98:	85 c0                	test   %eax,%eax
c0100f9a:	74 0e                	je     c0100faa <ide_init+0x17f>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0100f9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f9f:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0100fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100fa8:	eb 09                	jmp    c0100fb3 <ide_init+0x188>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0100faa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100fad:	8b 40 78             	mov    0x78(%eax),%eax
c0100fb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0100fb3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100fb7:	c1 e0 03             	shl    $0x3,%eax
c0100fba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100fc1:	29 c2                	sub    %eax,%edx
c0100fc3:	89 d0                	mov    %edx,%eax
c0100fc5:	8d 90 44 44 12 c0    	lea    -0x3fedbbbc(%eax),%edx
c0100fcb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100fce:	89 02                	mov    %eax,(%edx)
        ide_devices[ideno].size = sectors;
c0100fd0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100fd4:	c1 e0 03             	shl    $0x3,%eax
c0100fd7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100fde:	29 c2                	sub    %eax,%edx
c0100fe0:	89 d0                	mov    %edx,%eax
c0100fe2:	8d 90 48 44 12 c0    	lea    -0x3fedbbb8(%eax),%edx
c0100fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100feb:	89 02                	mov    %eax,(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0100fed:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100ff0:	83 c0 62             	add    $0x62,%eax
c0100ff3:	0f b7 00             	movzwl (%eax),%eax
c0100ff6:	25 00 02 00 00       	and    $0x200,%eax
c0100ffb:	85 c0                	test   %eax,%eax
c0100ffd:	75 24                	jne    c0101023 <ide_init+0x1f8>
c0100fff:	c7 44 24 0c 04 97 10 	movl   $0xc0109704,0xc(%esp)
c0101006:	c0 
c0101007:	c7 44 24 08 47 97 10 	movl   $0xc0109747,0x8(%esp)
c010100e:	c0 
c010100f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101016:	00 
c0101017:	c7 04 24 5c 97 10 c0 	movl   $0xc010975c,(%esp)
c010101e:	e8 df f3 ff ff       	call   c0100402 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101023:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101027:	c1 e0 03             	shl    $0x3,%eax
c010102a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101031:	29 c2                	sub    %eax,%edx
c0101033:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c0101039:	83 c0 0c             	add    $0xc,%eax
c010103c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010103f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101042:	83 c0 36             	add    $0x36,%eax
c0101045:	89 45 d0             	mov    %eax,-0x30(%ebp)
        unsigned int i, length = 40;
c0101048:	c7 45 cc 28 00 00 00 	movl   $0x28,-0x34(%ebp)
        for (i = 0; i < length; i += 2) {
c010104f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101056:	eb 34                	jmp    c010108c <ide_init+0x261>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101058:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010105b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010105e:	01 c2                	add    %eax,%edx
c0101060:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101063:	8d 48 01             	lea    0x1(%eax),%ecx
c0101066:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101069:	01 c8                	add    %ecx,%eax
c010106b:	0f b6 00             	movzbl (%eax),%eax
c010106e:	88 02                	mov    %al,(%edx)
c0101070:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101073:	8d 50 01             	lea    0x1(%eax),%edx
c0101076:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101079:	01 c2                	add    %eax,%edx
c010107b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010107e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101081:	01 c8                	add    %ecx,%eax
c0101083:	0f b6 00             	movzbl (%eax),%eax
c0101086:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101088:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c010108c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010108f:	3b 45 cc             	cmp    -0x34(%ebp),%eax
c0101092:	72 c4                	jb     c0101058 <ide_init+0x22d>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101094:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101097:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010109a:	01 d0                	add    %edx,%eax
c010109c:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010109f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01010a2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01010a5:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01010a8:	85 c0                	test   %eax,%eax
c01010aa:	74 0f                	je     c01010bb <ide_init+0x290>
c01010ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01010af:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01010b2:	01 d0                	add    %edx,%eax
c01010b4:	0f b6 00             	movzbl (%eax),%eax
c01010b7:	3c 20                	cmp    $0x20,%al
c01010b9:	74 d9                	je     c0101094 <ide_init+0x269>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01010bb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010bf:	c1 e0 03             	shl    $0x3,%eax
c01010c2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01010c9:	29 c2                	sub    %eax,%edx
c01010cb:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c01010d1:	8d 48 0c             	lea    0xc(%eax),%ecx
c01010d4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010d8:	c1 e0 03             	shl    $0x3,%eax
c01010db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01010e2:	29 c2                	sub    %eax,%edx
c01010e4:	89 d0                	mov    %edx,%eax
c01010e6:	05 48 44 12 c0       	add    $0xc0124448,%eax
c01010eb:	8b 10                	mov    (%eax),%edx
c01010ed:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010f1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01010f5:	89 54 24 08          	mov    %edx,0x8(%esp)
c01010f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01010fd:	c7 04 24 6e 97 10 c0 	movl   $0xc010976e,(%esp)
c0101104:	e8 a2 f1 ff ff       	call   c01002ab <cprintf>
c0101109:	eb 01                	jmp    c010110c <ide_init+0x2e1>
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
        ide_wait_ready(iobase, 0);

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
            continue ;
c010110b:	90                   	nop

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010110c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101110:	40                   	inc    %eax
c0101111:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101115:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101119:	83 f8 03             	cmp    $0x3,%eax
c010111c:	0f 86 1f fd ff ff    	jbe    c0100e41 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101122:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101129:	e8 8a 0e 00 00       	call   c0101fb8 <pic_enable>
    pic_enable(IRQ_IDE2);
c010112e:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101135:	e8 7e 0e 00 00       	call   c0101fb8 <pic_enable>
}
c010113a:	90                   	nop
c010113b:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101141:	5b                   	pop    %ebx
c0101142:	5f                   	pop    %edi
c0101143:	5d                   	pop    %ebp
c0101144:	c3                   	ret    

c0101145 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101145:	55                   	push   %ebp
c0101146:	89 e5                	mov    %esp,%ebp
c0101148:	83 ec 04             	sub    $0x4,%esp
c010114b:	8b 45 08             	mov    0x8(%ebp),%eax
c010114e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101152:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101156:	83 f8 03             	cmp    $0x3,%eax
c0101159:	77 25                	ja     c0101180 <ide_device_valid+0x3b>
c010115b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c010115f:	c1 e0 03             	shl    $0x3,%eax
c0101162:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101169:	29 c2                	sub    %eax,%edx
c010116b:	89 d0                	mov    %edx,%eax
c010116d:	05 40 44 12 c0       	add    $0xc0124440,%eax
c0101172:	0f b6 00             	movzbl (%eax),%eax
c0101175:	84 c0                	test   %al,%al
c0101177:	74 07                	je     c0101180 <ide_device_valid+0x3b>
c0101179:	b8 01 00 00 00       	mov    $0x1,%eax
c010117e:	eb 05                	jmp    c0101185 <ide_device_valid+0x40>
c0101180:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101185:	c9                   	leave  
c0101186:	c3                   	ret    

c0101187 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101187:	55                   	push   %ebp
c0101188:	89 e5                	mov    %esp,%ebp
c010118a:	83 ec 08             	sub    $0x8,%esp
c010118d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101190:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101194:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101198:	89 04 24             	mov    %eax,(%esp)
c010119b:	e8 a5 ff ff ff       	call   c0101145 <ide_device_valid>
c01011a0:	85 c0                	test   %eax,%eax
c01011a2:	74 1b                	je     c01011bf <ide_device_size+0x38>
        return ide_devices[ideno].size;
c01011a4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c01011a8:	c1 e0 03             	shl    $0x3,%eax
c01011ab:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01011b2:	29 c2                	sub    %eax,%edx
c01011b4:	89 d0                	mov    %edx,%eax
c01011b6:	05 48 44 12 c0       	add    $0xc0124448,%eax
c01011bb:	8b 00                	mov    (%eax),%eax
c01011bd:	eb 05                	jmp    c01011c4 <ide_device_size+0x3d>
    }
    return 0;
c01011bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01011c4:	c9                   	leave  
c01011c5:	c3                   	ret    

c01011c6 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c01011c6:	55                   	push   %ebp
c01011c7:	89 e5                	mov    %esp,%ebp
c01011c9:	57                   	push   %edi
c01011ca:	53                   	push   %ebx
c01011cb:	83 ec 50             	sub    $0x50,%esp
c01011ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d1:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c01011d5:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c01011dc:	77 27                	ja     c0101205 <ide_read_secs+0x3f>
c01011de:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011e2:	83 f8 03             	cmp    $0x3,%eax
c01011e5:	77 1e                	ja     c0101205 <ide_read_secs+0x3f>
c01011e7:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011eb:	c1 e0 03             	shl    $0x3,%eax
c01011ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01011f5:	29 c2                	sub    %eax,%edx
c01011f7:	89 d0                	mov    %edx,%eax
c01011f9:	05 40 44 12 c0       	add    $0xc0124440,%eax
c01011fe:	0f b6 00             	movzbl (%eax),%eax
c0101201:	84 c0                	test   %al,%al
c0101203:	75 24                	jne    c0101229 <ide_read_secs+0x63>
c0101205:	c7 44 24 0c 8c 97 10 	movl   $0xc010978c,0xc(%esp)
c010120c:	c0 
c010120d:	c7 44 24 08 47 97 10 	movl   $0xc0109747,0x8(%esp)
c0101214:	c0 
c0101215:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c010121c:	00 
c010121d:	c7 04 24 5c 97 10 c0 	movl   $0xc010975c,(%esp)
c0101224:	e8 d9 f1 ff ff       	call   c0100402 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101229:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101230:	77 0f                	ja     c0101241 <ide_read_secs+0x7b>
c0101232:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101235:	8b 45 14             	mov    0x14(%ebp),%eax
c0101238:	01 d0                	add    %edx,%eax
c010123a:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c010123f:	76 24                	jbe    c0101265 <ide_read_secs+0x9f>
c0101241:	c7 44 24 0c b4 97 10 	movl   $0xc01097b4,0xc(%esp)
c0101248:	c0 
c0101249:	c7 44 24 08 47 97 10 	movl   $0xc0109747,0x8(%esp)
c0101250:	c0 
c0101251:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101258:	00 
c0101259:	c7 04 24 5c 97 10 c0 	movl   $0xc010975c,(%esp)
c0101260:	e8 9d f1 ff ff       	call   c0100402 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101265:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101269:	d1 e8                	shr    %eax
c010126b:	0f b7 c0             	movzwl %ax,%eax
c010126e:	8b 04 85 fc 96 10 c0 	mov    -0x3fef6904(,%eax,4),%eax
c0101275:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101279:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010127d:	d1 e8                	shr    %eax
c010127f:	0f b7 c0             	movzwl %ax,%eax
c0101282:	0f b7 04 85 fe 96 10 	movzwl -0x3fef6902(,%eax,4),%eax
c0101289:	c0 
c010128a:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c010128e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101292:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101299:	00 
c010129a:	89 04 24             	mov    %eax,(%esp)
c010129d:	e8 30 fb ff ff       	call   c0100dd2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c01012a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01012a5:	83 c0 02             	add    $0x2,%eax
c01012a8:	0f b7 c0             	movzwl %ax,%eax
c01012ab:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012af:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012b3:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c01012b7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012bb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c01012bc:	8b 45 14             	mov    0x14(%ebp),%eax
c01012bf:	0f b6 c0             	movzbl %al,%eax
c01012c2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012c6:	83 c2 02             	add    $0x2,%edx
c01012c9:	0f b7 d2             	movzwl %dx,%edx
c01012cc:	66 89 55 e8          	mov    %dx,-0x18(%ebp)
c01012d0:	88 45 d8             	mov    %al,-0x28(%ebp)
c01012d3:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c01012d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01012da:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c01012db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012de:	0f b6 c0             	movzbl %al,%eax
c01012e1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012e5:	83 c2 03             	add    $0x3,%edx
c01012e8:	0f b7 d2             	movzwl %dx,%edx
c01012eb:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ef:	88 45 d9             	mov    %al,-0x27(%ebp)
c01012f2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01012f6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012fa:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c01012fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012fe:	c1 e8 08             	shr    $0x8,%eax
c0101301:	0f b6 c0             	movzbl %al,%eax
c0101304:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101308:	83 c2 04             	add    $0x4,%edx
c010130b:	0f b7 d2             	movzwl %dx,%edx
c010130e:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
c0101312:	88 45 da             	mov    %al,-0x26(%ebp)
c0101315:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101319:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010131c:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c010131d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101320:	c1 e8 10             	shr    $0x10,%eax
c0101323:	0f b6 c0             	movzbl %al,%eax
c0101326:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010132a:	83 c2 05             	add    $0x5,%edx
c010132d:	0f b7 d2             	movzwl %dx,%edx
c0101330:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101334:	88 45 db             	mov    %al,-0x25(%ebp)
c0101337:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c010133b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010133f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101340:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101343:	24 01                	and    $0x1,%al
c0101345:	c0 e0 04             	shl    $0x4,%al
c0101348:	88 c2                	mov    %al,%dl
c010134a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010134d:	c1 e8 18             	shr    $0x18,%eax
c0101350:	24 0f                	and    $0xf,%al
c0101352:	08 d0                	or     %dl,%al
c0101354:	0c e0                	or     $0xe0,%al
c0101356:	0f b6 c0             	movzbl %al,%eax
c0101359:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010135d:	83 c2 06             	add    $0x6,%edx
c0101360:	0f b7 d2             	movzwl %dx,%edx
c0101363:	66 89 55 e0          	mov    %dx,-0x20(%ebp)
c0101367:	88 45 dc             	mov    %al,-0x24(%ebp)
c010136a:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c010136e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0101371:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101372:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101376:	83 c0 07             	add    $0x7,%eax
c0101379:	0f b7 c0             	movzwl %ax,%eax
c010137c:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c0101380:	c6 45 dd 20          	movb   $0x20,-0x23(%ebp)
c0101384:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101388:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010138c:	ee                   	out    %al,(%dx)

    int ret = 0;
c010138d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101394:	eb 57                	jmp    c01013ed <ide_read_secs+0x227>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101396:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010139a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01013a1:	00 
c01013a2:	89 04 24             	mov    %eax,(%esp)
c01013a5:	e8 28 fa ff ff       	call   c0100dd2 <ide_wait_ready>
c01013aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013b1:	75 42                	jne    c01013f5 <ide_read_secs+0x22f>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c01013b3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01013b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01013ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01013bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01013c0:	c7 45 cc 80 00 00 00 	movl   $0x80,-0x34(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c01013c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01013ca:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01013cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01013d0:	89 cb                	mov    %ecx,%ebx
c01013d2:	89 df                	mov    %ebx,%edi
c01013d4:	89 c1                	mov    %eax,%ecx
c01013d6:	fc                   	cld    
c01013d7:	f2 6d                	repnz insl (%dx),%es:(%edi)
c01013d9:	89 c8                	mov    %ecx,%eax
c01013db:	89 fb                	mov    %edi,%ebx
c01013dd:	89 5d d0             	mov    %ebx,-0x30(%ebp)
c01013e0:	89 45 cc             	mov    %eax,-0x34(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c01013e3:	ff 4d 14             	decl   0x14(%ebp)
c01013e6:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c01013ed:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01013f1:	75 a3                	jne    c0101396 <ide_read_secs+0x1d0>
c01013f3:	eb 01                	jmp    c01013f6 <ide_read_secs+0x230>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c01013f5:	90                   	nop
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c01013f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01013f9:	83 c4 50             	add    $0x50,%esp
c01013fc:	5b                   	pop    %ebx
c01013fd:	5f                   	pop    %edi
c01013fe:	5d                   	pop    %ebp
c01013ff:	c3                   	ret    

c0101400 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101400:	55                   	push   %ebp
c0101401:	89 e5                	mov    %esp,%ebp
c0101403:	56                   	push   %esi
c0101404:	53                   	push   %ebx
c0101405:	83 ec 50             	sub    $0x50,%esp
c0101408:	8b 45 08             	mov    0x8(%ebp),%eax
c010140b:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c010140f:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101416:	77 27                	ja     c010143f <ide_write_secs+0x3f>
c0101418:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010141c:	83 f8 03             	cmp    $0x3,%eax
c010141f:	77 1e                	ja     c010143f <ide_write_secs+0x3f>
c0101421:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101425:	c1 e0 03             	shl    $0x3,%eax
c0101428:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010142f:	29 c2                	sub    %eax,%edx
c0101431:	89 d0                	mov    %edx,%eax
c0101433:	05 40 44 12 c0       	add    $0xc0124440,%eax
c0101438:	0f b6 00             	movzbl (%eax),%eax
c010143b:	84 c0                	test   %al,%al
c010143d:	75 24                	jne    c0101463 <ide_write_secs+0x63>
c010143f:	c7 44 24 0c 8c 97 10 	movl   $0xc010978c,0xc(%esp)
c0101446:	c0 
c0101447:	c7 44 24 08 47 97 10 	movl   $0xc0109747,0x8(%esp)
c010144e:	c0 
c010144f:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101456:	00 
c0101457:	c7 04 24 5c 97 10 c0 	movl   $0xc010975c,(%esp)
c010145e:	e8 9f ef ff ff       	call   c0100402 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101463:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c010146a:	77 0f                	ja     c010147b <ide_write_secs+0x7b>
c010146c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010146f:	8b 45 14             	mov    0x14(%ebp),%eax
c0101472:	01 d0                	add    %edx,%eax
c0101474:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101479:	76 24                	jbe    c010149f <ide_write_secs+0x9f>
c010147b:	c7 44 24 0c b4 97 10 	movl   $0xc01097b4,0xc(%esp)
c0101482:	c0 
c0101483:	c7 44 24 08 47 97 10 	movl   $0xc0109747,0x8(%esp)
c010148a:	c0 
c010148b:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101492:	00 
c0101493:	c7 04 24 5c 97 10 c0 	movl   $0xc010975c,(%esp)
c010149a:	e8 63 ef ff ff       	call   c0100402 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c010149f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01014a3:	d1 e8                	shr    %eax
c01014a5:	0f b7 c0             	movzwl %ax,%eax
c01014a8:	8b 04 85 fc 96 10 c0 	mov    -0x3fef6904(,%eax,4),%eax
c01014af:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c01014b3:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01014b7:	d1 e8                	shr    %eax
c01014b9:	0f b7 c0             	movzwl %ax,%eax
c01014bc:	0f b7 04 85 fe 96 10 	movzwl -0x3fef6902(,%eax,4),%eax
c01014c3:	c0 
c01014c4:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c01014c8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01014cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01014d3:	00 
c01014d4:	89 04 24             	mov    %eax,(%esp)
c01014d7:	e8 f6 f8 ff ff       	call   c0100dd2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c01014dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014df:	83 c0 02             	add    $0x2,%eax
c01014e2:	0f b7 c0             	movzwl %ax,%eax
c01014e5:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01014e9:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01014ed:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c01014f1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01014f5:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c01014f6:	8b 45 14             	mov    0x14(%ebp),%eax
c01014f9:	0f b6 c0             	movzbl %al,%eax
c01014fc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101500:	83 c2 02             	add    $0x2,%edx
c0101503:	0f b7 d2             	movzwl %dx,%edx
c0101506:	66 89 55 e8          	mov    %dx,-0x18(%ebp)
c010150a:	88 45 d8             	mov    %al,-0x28(%ebp)
c010150d:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c0101511:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101514:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101515:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101518:	0f b6 c0             	movzbl %al,%eax
c010151b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010151f:	83 c2 03             	add    $0x3,%edx
c0101522:	0f b7 d2             	movzwl %dx,%edx
c0101525:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101529:	88 45 d9             	mov    %al,-0x27(%ebp)
c010152c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101530:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101534:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101535:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101538:	c1 e8 08             	shr    $0x8,%eax
c010153b:	0f b6 c0             	movzbl %al,%eax
c010153e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101542:	83 c2 04             	add    $0x4,%edx
c0101545:	0f b7 d2             	movzwl %dx,%edx
c0101548:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
c010154c:	88 45 da             	mov    %al,-0x26(%ebp)
c010154f:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101553:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0101556:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101557:	8b 45 0c             	mov    0xc(%ebp),%eax
c010155a:	c1 e8 10             	shr    $0x10,%eax
c010155d:	0f b6 c0             	movzbl %al,%eax
c0101560:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101564:	83 c2 05             	add    $0x5,%edx
c0101567:	0f b7 d2             	movzwl %dx,%edx
c010156a:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c010156e:	88 45 db             	mov    %al,-0x25(%ebp)
c0101571:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101575:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101579:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c010157a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010157d:	24 01                	and    $0x1,%al
c010157f:	c0 e0 04             	shl    $0x4,%al
c0101582:	88 c2                	mov    %al,%dl
c0101584:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101587:	c1 e8 18             	shr    $0x18,%eax
c010158a:	24 0f                	and    $0xf,%al
c010158c:	08 d0                	or     %dl,%al
c010158e:	0c e0                	or     $0xe0,%al
c0101590:	0f b6 c0             	movzbl %al,%eax
c0101593:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101597:	83 c2 06             	add    $0x6,%edx
c010159a:	0f b7 d2             	movzwl %dx,%edx
c010159d:	66 89 55 e0          	mov    %dx,-0x20(%ebp)
c01015a1:	88 45 dc             	mov    %al,-0x24(%ebp)
c01015a4:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01015a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01015ab:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c01015ac:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01015b0:	83 c0 07             	add    $0x7,%eax
c01015b3:	0f b7 c0             	movzwl %ax,%eax
c01015b6:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c01015ba:	c6 45 dd 30          	movb   $0x30,-0x23(%ebp)
c01015be:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01015c2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01015c6:	ee                   	out    %al,(%dx)

    int ret = 0;
c01015c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c01015ce:	eb 57                	jmp    c0101627 <ide_write_secs+0x227>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c01015d0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01015d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01015db:	00 
c01015dc:	89 04 24             	mov    %eax,(%esp)
c01015df:	e8 ee f7 ff ff       	call   c0100dd2 <ide_wait_ready>
c01015e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01015e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01015eb:	75 42                	jne    c010162f <ide_write_secs+0x22f>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c01015ed:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01015f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01015f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01015f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01015fa:	c7 45 cc 80 00 00 00 	movl   $0x80,-0x34(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101601:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101604:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0101607:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010160a:	89 cb                	mov    %ecx,%ebx
c010160c:	89 de                	mov    %ebx,%esi
c010160e:	89 c1                	mov    %eax,%ecx
c0101610:	fc                   	cld    
c0101611:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101613:	89 c8                	mov    %ecx,%eax
c0101615:	89 f3                	mov    %esi,%ebx
c0101617:	89 5d d0             	mov    %ebx,-0x30(%ebp)
c010161a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c010161d:	ff 4d 14             	decl   0x14(%ebp)
c0101620:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101627:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c010162b:	75 a3                	jne    c01015d0 <ide_write_secs+0x1d0>
c010162d:	eb 01                	jmp    c0101630 <ide_write_secs+0x230>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c010162f:	90                   	nop
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101630:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101633:	83 c4 50             	add    $0x50,%esp
c0101636:	5b                   	pop    %ebx
c0101637:	5e                   	pop    %esi
c0101638:	5d                   	pop    %ebp
c0101639:	c3                   	ret    

c010163a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c010163a:	55                   	push   %ebp
c010163b:	89 e5                	mov    %esp,%ebp
c010163d:	83 ec 28             	sub    $0x28,%esp
c0101640:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0101646:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010164a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c010164e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101652:	ee                   	out    %al,(%dx)
c0101653:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c0101659:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c010165d:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0101661:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101664:	ee                   	out    %al,(%dx)
c0101665:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c010166b:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c010166f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101673:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101677:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0101678:	c7 05 0c 50 12 c0 00 	movl   $0x0,0xc012500c
c010167f:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0101682:	c7 04 24 ee 97 10 c0 	movl   $0xc01097ee,(%esp)
c0101689:	e8 1d ec ff ff       	call   c01002ab <cprintf>
    pic_enable(IRQ_TIMER);
c010168e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0101695:	e8 1e 09 00 00       	call   c0101fb8 <pic_enable>
}
c010169a:	90                   	nop
c010169b:	c9                   	leave  
c010169c:	c3                   	ret    

c010169d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010169d:	55                   	push   %ebp
c010169e:	89 e5                	mov    %esp,%ebp
c01016a0:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01016a3:	9c                   	pushf  
c01016a4:	58                   	pop    %eax
c01016a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01016a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01016ab:	25 00 02 00 00       	and    $0x200,%eax
c01016b0:	85 c0                	test   %eax,%eax
c01016b2:	74 0c                	je     c01016c0 <__intr_save+0x23>
        intr_disable();
c01016b4:	e8 6c 0a 00 00       	call   c0102125 <intr_disable>
        return 1;
c01016b9:	b8 01 00 00 00       	mov    $0x1,%eax
c01016be:	eb 05                	jmp    c01016c5 <__intr_save+0x28>
    }
    return 0;
c01016c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01016c5:	c9                   	leave  
c01016c6:	c3                   	ret    

c01016c7 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01016c7:	55                   	push   %ebp
c01016c8:	89 e5                	mov    %esp,%ebp
c01016ca:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01016cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01016d1:	74 05                	je     c01016d8 <__intr_restore+0x11>
        intr_enable();
c01016d3:	e8 46 0a 00 00       	call   c010211e <intr_enable>
    }
}
c01016d8:	90                   	nop
c01016d9:	c9                   	leave  
c01016da:	c3                   	ret    

c01016db <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c01016db:	55                   	push   %ebp
c01016dc:	89 e5                	mov    %esp,%ebp
c01016de:	83 ec 10             	sub    $0x10,%esp
c01016e1:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016e7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01016eb:	89 c2                	mov    %eax,%edx
c01016ed:	ec                   	in     (%dx),%al
c01016ee:	88 45 f4             	mov    %al,-0xc(%ebp)
c01016f1:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c01016f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016fa:	89 c2                	mov    %eax,%edx
c01016fc:	ec                   	in     (%dx),%al
c01016fd:	88 45 f5             	mov    %al,-0xb(%ebp)
c0101700:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0101706:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010170a:	89 c2                	mov    %eax,%edx
c010170c:	ec                   	in     (%dx),%al
c010170d:	88 45 f6             	mov    %al,-0xa(%ebp)
c0101710:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c0101716:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101719:	89 c2                	mov    %eax,%edx
c010171b:	ec                   	in     (%dx),%al
c010171c:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c010171f:	90                   	nop
c0101720:	c9                   	leave  
c0101721:	c3                   	ret    

c0101722 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0101722:	55                   	push   %ebp
c0101723:	89 e5                	mov    %esp,%ebp
c0101725:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0101728:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c010172f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101732:	0f b7 00             	movzwl (%eax),%eax
c0101735:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0101739:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010173c:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0101741:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101744:	0f b7 00             	movzwl (%eax),%eax
c0101747:	0f b7 c0             	movzwl %ax,%eax
c010174a:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c010174f:	74 12                	je     c0101763 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0101751:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0101758:	66 c7 05 26 45 12 c0 	movw   $0x3b4,0xc0124526
c010175f:	b4 03 
c0101761:	eb 13                	jmp    c0101776 <cga_init+0x54>
    } else {
        *cp = was;
c0101763:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010176a:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c010176d:	66 c7 05 26 45 12 c0 	movw   $0x3d4,0xc0124526
c0101774:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0101776:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c010177d:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c0101781:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101785:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101789:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010178c:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c010178d:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101794:	40                   	inc    %eax
c0101795:	0f b7 c0             	movzwl %ax,%eax
c0101798:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010179c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01017a0:	89 c2                	mov    %eax,%edx
c01017a2:	ec                   	in     (%dx),%al
c01017a3:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01017a6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01017aa:	0f b6 c0             	movzbl %al,%eax
c01017ad:	c1 e0 08             	shl    $0x8,%eax
c01017b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c01017b3:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c01017ba:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c01017be:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017c2:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01017c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01017c9:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c01017ca:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c01017d1:	40                   	inc    %eax
c01017d2:	0f b7 c0             	movzwl %ax,%eax
c01017d5:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017d9:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c01017dd:	89 c2                	mov    %eax,%edx
c01017df:	ec                   	in     (%dx),%al
c01017e0:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c01017e3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017e7:	0f b6 c0             	movzbl %al,%eax
c01017ea:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c01017ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017f0:	a3 20 45 12 c0       	mov    %eax,0xc0124520
    crt_pos = pos;
c01017f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01017f8:	0f b7 c0             	movzwl %ax,%eax
c01017fb:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
}
c0101801:	90                   	nop
c0101802:	c9                   	leave  
c0101803:	c3                   	ret    

c0101804 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0101804:	55                   	push   %ebp
c0101805:	89 e5                	mov    %esp,%ebp
c0101807:	83 ec 38             	sub    $0x38,%esp
c010180a:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0101810:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101814:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101818:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010181c:	ee                   	out    %al,(%dx)
c010181d:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c0101823:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c0101827:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c010182b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010182e:	ee                   	out    %al,(%dx)
c010182f:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0101835:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c0101839:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c010183d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101841:	ee                   	out    %al,(%dx)
c0101842:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c0101848:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c010184c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101850:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101853:	ee                   	out    %al,(%dx)
c0101854:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c010185a:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c010185e:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0101862:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101866:	ee                   	out    %al,(%dx)
c0101867:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c010186d:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c0101871:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101875:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101878:	ee                   	out    %al,(%dx)
c0101879:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c010187f:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c0101883:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0101887:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010188b:	ee                   	out    %al,(%dx)
c010188c:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101892:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101895:	89 c2                	mov    %eax,%edx
c0101897:	ec                   	in     (%dx),%al
c0101898:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c010189b:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010189f:	3c ff                	cmp    $0xff,%al
c01018a1:	0f 95 c0             	setne  %al
c01018a4:	0f b6 c0             	movzbl %al,%eax
c01018a7:	a3 28 45 12 c0       	mov    %eax,0xc0124528
c01018ac:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01018b2:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01018b6:	89 c2                	mov    %eax,%edx
c01018b8:	ec                   	in     (%dx),%al
c01018b9:	88 45 e2             	mov    %al,-0x1e(%ebp)
c01018bc:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c01018c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018c5:	89 c2                	mov    %eax,%edx
c01018c7:	ec                   	in     (%dx),%al
c01018c8:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01018cb:	a1 28 45 12 c0       	mov    0xc0124528,%eax
c01018d0:	85 c0                	test   %eax,%eax
c01018d2:	74 0c                	je     c01018e0 <serial_init+0xdc>
        pic_enable(IRQ_COM1);
c01018d4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01018db:	e8 d8 06 00 00       	call   c0101fb8 <pic_enable>
    }
}
c01018e0:	90                   	nop
c01018e1:	c9                   	leave  
c01018e2:	c3                   	ret    

c01018e3 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01018e3:	55                   	push   %ebp
c01018e4:	89 e5                	mov    %esp,%ebp
c01018e6:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01018e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018f0:	eb 08                	jmp    c01018fa <lpt_putc_sub+0x17>
        delay();
c01018f2:	e8 e4 fd ff ff       	call   c01016db <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01018f7:	ff 45 fc             	incl   -0x4(%ebp)
c01018fa:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c0101900:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101903:	89 c2                	mov    %eax,%edx
c0101905:	ec                   	in     (%dx),%al
c0101906:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c0101909:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010190d:	84 c0                	test   %al,%al
c010190f:	78 09                	js     c010191a <lpt_putc_sub+0x37>
c0101911:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101918:	7e d8                	jle    c01018f2 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010191a:	8b 45 08             	mov    0x8(%ebp),%eax
c010191d:	0f b6 c0             	movzbl %al,%eax
c0101920:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c0101926:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101929:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c010192d:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101930:	ee                   	out    %al,(%dx)
c0101931:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101937:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010193b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010193f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101943:	ee                   	out    %al,(%dx)
c0101944:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c010194a:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c010194e:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c0101952:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101956:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101957:	90                   	nop
c0101958:	c9                   	leave  
c0101959:	c3                   	ret    

c010195a <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010195a:	55                   	push   %ebp
c010195b:	89 e5                	mov    %esp,%ebp
c010195d:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101960:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101964:	74 0d                	je     c0101973 <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101966:	8b 45 08             	mov    0x8(%ebp),%eax
c0101969:	89 04 24             	mov    %eax,(%esp)
c010196c:	e8 72 ff ff ff       	call   c01018e3 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101971:	eb 24                	jmp    c0101997 <lpt_putc+0x3d>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c0101973:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010197a:	e8 64 ff ff ff       	call   c01018e3 <lpt_putc_sub>
        lpt_putc_sub(' ');
c010197f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101986:	e8 58 ff ff ff       	call   c01018e3 <lpt_putc_sub>
        lpt_putc_sub('\b');
c010198b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101992:	e8 4c ff ff ff       	call   c01018e3 <lpt_putc_sub>
    }
}
c0101997:	90                   	nop
c0101998:	c9                   	leave  
c0101999:	c3                   	ret    

c010199a <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010199a:	55                   	push   %ebp
c010199b:	89 e5                	mov    %esp,%ebp
c010199d:	53                   	push   %ebx
c010199e:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01019a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a4:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01019a9:	85 c0                	test   %eax,%eax
c01019ab:	75 07                	jne    c01019b4 <cga_putc+0x1a>
        c |= 0x0700;
c01019ad:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01019b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b7:	0f b6 c0             	movzbl %al,%eax
c01019ba:	83 f8 0a             	cmp    $0xa,%eax
c01019bd:	74 54                	je     c0101a13 <cga_putc+0x79>
c01019bf:	83 f8 0d             	cmp    $0xd,%eax
c01019c2:	74 62                	je     c0101a26 <cga_putc+0x8c>
c01019c4:	83 f8 08             	cmp    $0x8,%eax
c01019c7:	0f 85 93 00 00 00    	jne    c0101a60 <cga_putc+0xc6>
    case '\b':
        if (crt_pos > 0) {
c01019cd:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c01019d4:	85 c0                	test   %eax,%eax
c01019d6:	0f 84 ae 00 00 00    	je     c0101a8a <cga_putc+0xf0>
            crt_pos --;
c01019dc:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c01019e3:	48                   	dec    %eax
c01019e4:	0f b7 c0             	movzwl %ax,%eax
c01019e7:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01019ed:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c01019f2:	0f b7 15 24 45 12 c0 	movzwl 0xc0124524,%edx
c01019f9:	01 d2                	add    %edx,%edx
c01019fb:	01 c2                	add    %eax,%edx
c01019fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a00:	98                   	cwtl   
c0101a01:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101a06:	98                   	cwtl   
c0101a07:	83 c8 20             	or     $0x20,%eax
c0101a0a:	98                   	cwtl   
c0101a0b:	0f b7 c0             	movzwl %ax,%eax
c0101a0e:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101a11:	eb 77                	jmp    c0101a8a <cga_putc+0xf0>
    case '\n':
        crt_pos += CRT_COLS;
c0101a13:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101a1a:	83 c0 50             	add    $0x50,%eax
c0101a1d:	0f b7 c0             	movzwl %ax,%eax
c0101a20:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101a26:	0f b7 1d 24 45 12 c0 	movzwl 0xc0124524,%ebx
c0101a2d:	0f b7 0d 24 45 12 c0 	movzwl 0xc0124524,%ecx
c0101a34:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c0101a39:	89 c8                	mov    %ecx,%eax
c0101a3b:	f7 e2                	mul    %edx
c0101a3d:	c1 ea 06             	shr    $0x6,%edx
c0101a40:	89 d0                	mov    %edx,%eax
c0101a42:	c1 e0 02             	shl    $0x2,%eax
c0101a45:	01 d0                	add    %edx,%eax
c0101a47:	c1 e0 04             	shl    $0x4,%eax
c0101a4a:	29 c1                	sub    %eax,%ecx
c0101a4c:	89 c8                	mov    %ecx,%eax
c0101a4e:	0f b7 c0             	movzwl %ax,%eax
c0101a51:	29 c3                	sub    %eax,%ebx
c0101a53:	89 d8                	mov    %ebx,%eax
c0101a55:	0f b7 c0             	movzwl %ax,%eax
c0101a58:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
        break;
c0101a5e:	eb 2b                	jmp    c0101a8b <cga_putc+0xf1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101a60:	8b 0d 20 45 12 c0    	mov    0xc0124520,%ecx
c0101a66:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101a6d:	8d 50 01             	lea    0x1(%eax),%edx
c0101a70:	0f b7 d2             	movzwl %dx,%edx
c0101a73:	66 89 15 24 45 12 c0 	mov    %dx,0xc0124524
c0101a7a:	01 c0                	add    %eax,%eax
c0101a7c:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a82:	0f b7 c0             	movzwl %ax,%eax
c0101a85:	66 89 02             	mov    %ax,(%edx)
        break;
c0101a88:	eb 01                	jmp    c0101a8b <cga_putc+0xf1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c0101a8a:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101a8b:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101a92:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101a97:	76 5d                	jbe    c0101af6 <cga_putc+0x15c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101a99:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101a9e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101aa4:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101aa9:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101ab0:	00 
c0101ab1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101ab5:	89 04 24             	mov    %eax,(%esp)
c0101ab8:	e8 8c 70 00 00       	call   c0108b49 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101abd:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101ac4:	eb 14                	jmp    c0101ada <cga_putc+0x140>
            crt_buf[i] = 0x0700 | ' ';
c0101ac6:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101acb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101ace:	01 d2                	add    %edx,%edx
c0101ad0:	01 d0                	add    %edx,%eax
c0101ad2:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101ad7:	ff 45 f4             	incl   -0xc(%ebp)
c0101ada:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101ae1:	7e e3                	jle    c0101ac6 <cga_putc+0x12c>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101ae3:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101aea:	83 e8 50             	sub    $0x50,%eax
c0101aed:	0f b7 c0             	movzwl %ax,%eax
c0101af0:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101af6:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101afd:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b01:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c0101b05:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c0101b09:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101b0d:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101b0e:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101b15:	c1 e8 08             	shr    $0x8,%eax
c0101b18:	0f b7 c0             	movzwl %ax,%eax
c0101b1b:	0f b6 c0             	movzbl %al,%eax
c0101b1e:	0f b7 15 26 45 12 c0 	movzwl 0xc0124526,%edx
c0101b25:	42                   	inc    %edx
c0101b26:	0f b7 d2             	movzwl %dx,%edx
c0101b29:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c0101b2d:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101b30:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101b34:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101b37:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101b38:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101b3f:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b43:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c0101b47:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101b4b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101b4f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101b50:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101b57:	0f b6 c0             	movzbl %al,%eax
c0101b5a:	0f b7 15 26 45 12 c0 	movzwl 0xc0124526,%edx
c0101b61:	42                   	inc    %edx
c0101b62:	0f b7 d2             	movzwl %dx,%edx
c0101b65:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101b69:	88 45 eb             	mov    %al,-0x15(%ebp)
c0101b6c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101b70:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101b73:	ee                   	out    %al,(%dx)
}
c0101b74:	90                   	nop
c0101b75:	83 c4 24             	add    $0x24,%esp
c0101b78:	5b                   	pop    %ebx
c0101b79:	5d                   	pop    %ebp
c0101b7a:	c3                   	ret    

c0101b7b <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101b7b:	55                   	push   %ebp
c0101b7c:	89 e5                	mov    %esp,%ebp
c0101b7e:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101b88:	eb 08                	jmp    c0101b92 <serial_putc_sub+0x17>
        delay();
c0101b8a:	e8 4c fb ff ff       	call   c01016db <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b8f:	ff 45 fc             	incl   -0x4(%ebp)
c0101b92:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b9b:	89 c2                	mov    %eax,%edx
c0101b9d:	ec                   	in     (%dx),%al
c0101b9e:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101ba1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101ba5:	0f b6 c0             	movzbl %al,%eax
c0101ba8:	83 e0 20             	and    $0x20,%eax
c0101bab:	85 c0                	test   %eax,%eax
c0101bad:	75 09                	jne    c0101bb8 <serial_putc_sub+0x3d>
c0101baf:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101bb6:	7e d2                	jle    c0101b8a <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbb:	0f b6 c0             	movzbl %al,%eax
c0101bbe:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c0101bc4:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101bc7:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c0101bcb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101bcf:	ee                   	out    %al,(%dx)
}
c0101bd0:	90                   	nop
c0101bd1:	c9                   	leave  
c0101bd2:	c3                   	ret    

c0101bd3 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101bd3:	55                   	push   %ebp
c0101bd4:	89 e5                	mov    %esp,%ebp
c0101bd6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101bd9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101bdd:	74 0d                	je     c0101bec <serial_putc+0x19>
        serial_putc_sub(c);
c0101bdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be2:	89 04 24             	mov    %eax,(%esp)
c0101be5:	e8 91 ff ff ff       	call   c0101b7b <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101bea:	eb 24                	jmp    c0101c10 <serial_putc+0x3d>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c0101bec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101bf3:	e8 83 ff ff ff       	call   c0101b7b <serial_putc_sub>
        serial_putc_sub(' ');
c0101bf8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101bff:	e8 77 ff ff ff       	call   c0101b7b <serial_putc_sub>
        serial_putc_sub('\b');
c0101c04:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101c0b:	e8 6b ff ff ff       	call   c0101b7b <serial_putc_sub>
    }
}
c0101c10:	90                   	nop
c0101c11:	c9                   	leave  
c0101c12:	c3                   	ret    

c0101c13 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101c13:	55                   	push   %ebp
c0101c14:	89 e5                	mov    %esp,%ebp
c0101c16:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101c19:	eb 33                	jmp    c0101c4e <cons_intr+0x3b>
        if (c != 0) {
c0101c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c1f:	74 2d                	je     c0101c4e <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101c21:	a1 44 47 12 c0       	mov    0xc0124744,%eax
c0101c26:	8d 50 01             	lea    0x1(%eax),%edx
c0101c29:	89 15 44 47 12 c0    	mov    %edx,0xc0124744
c0101c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101c32:	88 90 40 45 12 c0    	mov    %dl,-0x3fedbac0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101c38:	a1 44 47 12 c0       	mov    0xc0124744,%eax
c0101c3d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101c42:	75 0a                	jne    c0101c4e <cons_intr+0x3b>
                cons.wpos = 0;
c0101c44:	c7 05 44 47 12 c0 00 	movl   $0x0,0xc0124744
c0101c4b:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c51:	ff d0                	call   *%eax
c0101c53:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c56:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101c5a:	75 bf                	jne    c0101c1b <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101c5c:	90                   	nop
c0101c5d:	c9                   	leave  
c0101c5e:	c3                   	ret    

c0101c5f <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101c5f:	55                   	push   %ebp
c0101c60:	89 e5                	mov    %esp,%ebp
c0101c62:	83 ec 10             	sub    $0x10,%esp
c0101c65:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c6e:	89 c2                	mov    %eax,%edx
c0101c70:	ec                   	in     (%dx),%al
c0101c71:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101c74:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101c78:	0f b6 c0             	movzbl %al,%eax
c0101c7b:	83 e0 01             	and    $0x1,%eax
c0101c7e:	85 c0                	test   %eax,%eax
c0101c80:	75 07                	jne    c0101c89 <serial_proc_data+0x2a>
        return -1;
c0101c82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101c87:	eb 2a                	jmp    c0101cb3 <serial_proc_data+0x54>
c0101c89:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c8f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101c93:	89 c2                	mov    %eax,%edx
c0101c95:	ec                   	in     (%dx),%al
c0101c96:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c0101c99:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101c9d:	0f b6 c0             	movzbl %al,%eax
c0101ca0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101ca3:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101ca7:	75 07                	jne    c0101cb0 <serial_proc_data+0x51>
        c = '\b';
c0101ca9:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101cb3:	c9                   	leave  
c0101cb4:	c3                   	ret    

c0101cb5 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101cb5:	55                   	push   %ebp
c0101cb6:	89 e5                	mov    %esp,%ebp
c0101cb8:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101cbb:	a1 28 45 12 c0       	mov    0xc0124528,%eax
c0101cc0:	85 c0                	test   %eax,%eax
c0101cc2:	74 0c                	je     c0101cd0 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101cc4:	c7 04 24 5f 1c 10 c0 	movl   $0xc0101c5f,(%esp)
c0101ccb:	e8 43 ff ff ff       	call   c0101c13 <cons_intr>
    }
}
c0101cd0:	90                   	nop
c0101cd1:	c9                   	leave  
c0101cd2:	c3                   	ret    

c0101cd3 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101cd3:	55                   	push   %ebp
c0101cd4:	89 e5                	mov    %esp,%ebp
c0101cd6:	83 ec 28             	sub    $0x28,%esp
c0101cd9:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101ce2:	89 c2                	mov    %eax,%edx
c0101ce4:	ec                   	in     (%dx),%al
c0101ce5:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101ce8:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101cec:	0f b6 c0             	movzbl %al,%eax
c0101cef:	83 e0 01             	and    $0x1,%eax
c0101cf2:	85 c0                	test   %eax,%eax
c0101cf4:	75 0a                	jne    c0101d00 <kbd_proc_data+0x2d>
        return -1;
c0101cf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101cfb:	e9 56 01 00 00       	jmp    c0101e56 <kbd_proc_data+0x183>
c0101d00:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d09:	89 c2                	mov    %eax,%edx
c0101d0b:	ec                   	in     (%dx),%al
c0101d0c:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c0101d0f:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101d13:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101d16:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101d1a:	75 17                	jne    c0101d33 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c0101d1c:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d21:	83 c8 40             	or     $0x40,%eax
c0101d24:	a3 48 47 12 c0       	mov    %eax,0xc0124748
        return 0;
c0101d29:	b8 00 00 00 00       	mov    $0x0,%eax
c0101d2e:	e9 23 01 00 00       	jmp    c0101e56 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c0101d33:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d37:	84 c0                	test   %al,%al
c0101d39:	79 45                	jns    c0101d80 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101d3b:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d40:	83 e0 40             	and    $0x40,%eax
c0101d43:	85 c0                	test   %eax,%eax
c0101d45:	75 08                	jne    c0101d4f <kbd_proc_data+0x7c>
c0101d47:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d4b:	24 7f                	and    $0x7f,%al
c0101d4d:	eb 04                	jmp    c0101d53 <kbd_proc_data+0x80>
c0101d4f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d53:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101d56:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d5a:	0f b6 80 40 10 12 c0 	movzbl -0x3fedefc0(%eax),%eax
c0101d61:	0c 40                	or     $0x40,%al
c0101d63:	0f b6 c0             	movzbl %al,%eax
c0101d66:	f7 d0                	not    %eax
c0101d68:	89 c2                	mov    %eax,%edx
c0101d6a:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d6f:	21 d0                	and    %edx,%eax
c0101d71:	a3 48 47 12 c0       	mov    %eax,0xc0124748
        return 0;
c0101d76:	b8 00 00 00 00       	mov    $0x0,%eax
c0101d7b:	e9 d6 00 00 00       	jmp    c0101e56 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c0101d80:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d85:	83 e0 40             	and    $0x40,%eax
c0101d88:	85 c0                	test   %eax,%eax
c0101d8a:	74 11                	je     c0101d9d <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101d8c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101d90:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d95:	83 e0 bf             	and    $0xffffffbf,%eax
c0101d98:	a3 48 47 12 c0       	mov    %eax,0xc0124748
    }

    shift |= shiftcode[data];
c0101d9d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101da1:	0f b6 80 40 10 12 c0 	movzbl -0x3fedefc0(%eax),%eax
c0101da8:	0f b6 d0             	movzbl %al,%edx
c0101dab:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101db0:	09 d0                	or     %edx,%eax
c0101db2:	a3 48 47 12 c0       	mov    %eax,0xc0124748
    shift ^= togglecode[data];
c0101db7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101dbb:	0f b6 80 40 11 12 c0 	movzbl -0x3fedeec0(%eax),%eax
c0101dc2:	0f b6 d0             	movzbl %al,%edx
c0101dc5:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101dca:	31 d0                	xor    %edx,%eax
c0101dcc:	a3 48 47 12 c0       	mov    %eax,0xc0124748

    c = charcode[shift & (CTL | SHIFT)][data];
c0101dd1:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101dd6:	83 e0 03             	and    $0x3,%eax
c0101dd9:	8b 14 85 40 15 12 c0 	mov    -0x3fedeac0(,%eax,4),%edx
c0101de0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101de4:	01 d0                	add    %edx,%eax
c0101de6:	0f b6 00             	movzbl (%eax),%eax
c0101de9:	0f b6 c0             	movzbl %al,%eax
c0101dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101def:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101df4:	83 e0 08             	and    $0x8,%eax
c0101df7:	85 c0                	test   %eax,%eax
c0101df9:	74 22                	je     c0101e1d <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c0101dfb:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101dff:	7e 0c                	jle    c0101e0d <kbd_proc_data+0x13a>
c0101e01:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101e05:	7f 06                	jg     c0101e0d <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c0101e07:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101e0b:	eb 10                	jmp    c0101e1d <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c0101e0d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101e11:	7e 0a                	jle    c0101e1d <kbd_proc_data+0x14a>
c0101e13:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101e17:	7f 04                	jg     c0101e1d <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c0101e19:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101e1d:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101e22:	f7 d0                	not    %eax
c0101e24:	83 e0 06             	and    $0x6,%eax
c0101e27:	85 c0                	test   %eax,%eax
c0101e29:	75 28                	jne    c0101e53 <kbd_proc_data+0x180>
c0101e2b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101e32:	75 1f                	jne    c0101e53 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c0101e34:	c7 04 24 09 98 10 c0 	movl   $0xc0109809,(%esp)
c0101e3b:	e8 6b e4 ff ff       	call   c01002ab <cprintf>
c0101e40:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c0101e46:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e4a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101e4e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101e52:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101e56:	c9                   	leave  
c0101e57:	c3                   	ret    

c0101e58 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101e58:	55                   	push   %ebp
c0101e59:	89 e5                	mov    %esp,%ebp
c0101e5b:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101e5e:	c7 04 24 d3 1c 10 c0 	movl   $0xc0101cd3,(%esp)
c0101e65:	e8 a9 fd ff ff       	call   c0101c13 <cons_intr>
}
c0101e6a:	90                   	nop
c0101e6b:	c9                   	leave  
c0101e6c:	c3                   	ret    

c0101e6d <kbd_init>:

static void
kbd_init(void) {
c0101e6d:	55                   	push   %ebp
c0101e6e:	89 e5                	mov    %esp,%ebp
c0101e70:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101e73:	e8 e0 ff ff ff       	call   c0101e58 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101e78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101e7f:	e8 34 01 00 00       	call   c0101fb8 <pic_enable>
}
c0101e84:	90                   	nop
c0101e85:	c9                   	leave  
c0101e86:	c3                   	ret    

c0101e87 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101e87:	55                   	push   %ebp
c0101e88:	89 e5                	mov    %esp,%ebp
c0101e8a:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101e8d:	e8 90 f8 ff ff       	call   c0101722 <cga_init>
    serial_init();
c0101e92:	e8 6d f9 ff ff       	call   c0101804 <serial_init>
    kbd_init();
c0101e97:	e8 d1 ff ff ff       	call   c0101e6d <kbd_init>
    if (!serial_exists) {
c0101e9c:	a1 28 45 12 c0       	mov    0xc0124528,%eax
c0101ea1:	85 c0                	test   %eax,%eax
c0101ea3:	75 0c                	jne    c0101eb1 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101ea5:	c7 04 24 15 98 10 c0 	movl   $0xc0109815,(%esp)
c0101eac:	e8 fa e3 ff ff       	call   c01002ab <cprintf>
    }
}
c0101eb1:	90                   	nop
c0101eb2:	c9                   	leave  
c0101eb3:	c3                   	ret    

c0101eb4 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101eb4:	55                   	push   %ebp
c0101eb5:	89 e5                	mov    %esp,%ebp
c0101eb7:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101eba:	e8 de f7 ff ff       	call   c010169d <__intr_save>
c0101ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101ec2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec5:	89 04 24             	mov    %eax,(%esp)
c0101ec8:	e8 8d fa ff ff       	call   c010195a <lpt_putc>
        cga_putc(c);
c0101ecd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed0:	89 04 24             	mov    %eax,(%esp)
c0101ed3:	e8 c2 fa ff ff       	call   c010199a <cga_putc>
        serial_putc(c);
c0101ed8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101edb:	89 04 24             	mov    %eax,(%esp)
c0101ede:	e8 f0 fc ff ff       	call   c0101bd3 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ee6:	89 04 24             	mov    %eax,(%esp)
c0101ee9:	e8 d9 f7 ff ff       	call   c01016c7 <__intr_restore>
}
c0101eee:	90                   	nop
c0101eef:	c9                   	leave  
c0101ef0:	c3                   	ret    

c0101ef1 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101ef1:	55                   	push   %ebp
c0101ef2:	89 e5                	mov    %esp,%ebp
c0101ef4:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101ef7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101efe:	e8 9a f7 ff ff       	call   c010169d <__intr_save>
c0101f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101f06:	e8 aa fd ff ff       	call   c0101cb5 <serial_intr>
        kbd_intr();
c0101f0b:	e8 48 ff ff ff       	call   c0101e58 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101f10:	8b 15 40 47 12 c0    	mov    0xc0124740,%edx
c0101f16:	a1 44 47 12 c0       	mov    0xc0124744,%eax
c0101f1b:	39 c2                	cmp    %eax,%edx
c0101f1d:	74 31                	je     c0101f50 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101f1f:	a1 40 47 12 c0       	mov    0xc0124740,%eax
c0101f24:	8d 50 01             	lea    0x1(%eax),%edx
c0101f27:	89 15 40 47 12 c0    	mov    %edx,0xc0124740
c0101f2d:	0f b6 80 40 45 12 c0 	movzbl -0x3fedbac0(%eax),%eax
c0101f34:	0f b6 c0             	movzbl %al,%eax
c0101f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101f3a:	a1 40 47 12 c0       	mov    0xc0124740,%eax
c0101f3f:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101f44:	75 0a                	jne    c0101f50 <cons_getc+0x5f>
                cons.rpos = 0;
c0101f46:	c7 05 40 47 12 c0 00 	movl   $0x0,0xc0124740
c0101f4d:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f53:	89 04 24             	mov    %eax,(%esp)
c0101f56:	e8 6c f7 ff ff       	call   c01016c7 <__intr_restore>
    return c;
c0101f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f5e:	c9                   	leave  
c0101f5f:	c3                   	ret    

c0101f60 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f60:	55                   	push   %ebp
c0101f61:	89 e5                	mov    %esp,%ebp
c0101f63:	83 ec 14             	sub    $0x14,%esp
c0101f66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f69:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101f70:	66 a3 50 15 12 c0    	mov    %ax,0xc0121550
    if (did_init) {
c0101f76:	a1 4c 47 12 c0       	mov    0xc012474c,%eax
c0101f7b:	85 c0                	test   %eax,%eax
c0101f7d:	74 36                	je     c0101fb5 <pic_setmask+0x55>
        outb(IO_PIC1 + 1, mask);
c0101f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101f82:	0f b6 c0             	movzbl %al,%eax
c0101f85:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f8b:	88 45 fa             	mov    %al,-0x6(%ebp)
c0101f8e:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c0101f92:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f96:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f97:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f9b:	c1 e8 08             	shr    $0x8,%eax
c0101f9e:	0f b7 c0             	movzwl %ax,%eax
c0101fa1:	0f b6 c0             	movzbl %al,%eax
c0101fa4:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101faa:	88 45 fb             	mov    %al,-0x5(%ebp)
c0101fad:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101fb1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101fb4:	ee                   	out    %al,(%dx)
    }
}
c0101fb5:	90                   	nop
c0101fb6:	c9                   	leave  
c0101fb7:	c3                   	ret    

c0101fb8 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101fb8:	55                   	push   %ebp
c0101fb9:	89 e5                	mov    %esp,%ebp
c0101fbb:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101fbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fc1:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fc6:	88 c1                	mov    %al,%cl
c0101fc8:	d3 e2                	shl    %cl,%edx
c0101fca:	89 d0                	mov    %edx,%eax
c0101fcc:	98                   	cwtl   
c0101fcd:	f7 d0                	not    %eax
c0101fcf:	0f bf d0             	movswl %ax,%edx
c0101fd2:	0f b7 05 50 15 12 c0 	movzwl 0xc0121550,%eax
c0101fd9:	98                   	cwtl   
c0101fda:	21 d0                	and    %edx,%eax
c0101fdc:	98                   	cwtl   
c0101fdd:	0f b7 c0             	movzwl %ax,%eax
c0101fe0:	89 04 24             	mov    %eax,(%esp)
c0101fe3:	e8 78 ff ff ff       	call   c0101f60 <pic_setmask>
}
c0101fe8:	90                   	nop
c0101fe9:	c9                   	leave  
c0101fea:	c3                   	ret    

c0101feb <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101feb:	55                   	push   %ebp
c0101fec:	89 e5                	mov    %esp,%ebp
c0101fee:	83 ec 34             	sub    $0x34,%esp
    did_init = 1;
c0101ff1:	c7 05 4c 47 12 c0 01 	movl   $0x1,0xc012474c
c0101ff8:	00 00 00 
c0101ffb:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0102001:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c0102005:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c0102009:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010200d:	ee                   	out    %al,(%dx)
c010200e:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0102014:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c0102018:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c010201c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010201f:	ee                   	out    %al,(%dx)
c0102020:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c0102026:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c010202a:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c010202e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102032:	ee                   	out    %al,(%dx)
c0102033:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c0102039:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c010203d:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102041:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102044:	ee                   	out    %al,(%dx)
c0102045:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c010204b:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c010204f:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0102053:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102057:	ee                   	out    %al,(%dx)
c0102058:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c010205e:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0102062:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0102066:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102069:	ee                   	out    %al,(%dx)
c010206a:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c0102070:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c0102074:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0102078:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010207c:	ee                   	out    %al,(%dx)
c010207d:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c0102083:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c0102087:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010208b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010208e:	ee                   	out    %al,(%dx)
c010208f:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0102095:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c0102099:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c010209d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01020a1:	ee                   	out    %al,(%dx)
c01020a2:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c01020a8:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c01020ac:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01020b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01020b3:	ee                   	out    %al,(%dx)
c01020b4:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c01020ba:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c01020be:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c01020c2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01020c6:	ee                   	out    %al,(%dx)
c01020c7:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c01020cd:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c01020d1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01020d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01020d8:	ee                   	out    %al,(%dx)
c01020d9:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01020df:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c01020e3:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c01020e7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01020eb:	ee                   	out    %al,(%dx)
c01020ec:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c01020f2:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c01020f6:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01020fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01020fd:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020fe:	0f b7 05 50 15 12 c0 	movzwl 0xc0121550,%eax
c0102105:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010210a:	74 0f                	je     c010211b <pic_init+0x130>
        pic_setmask(irq_mask);
c010210c:	0f b7 05 50 15 12 c0 	movzwl 0xc0121550,%eax
c0102113:	89 04 24             	mov    %eax,(%esp)
c0102116:	e8 45 fe ff ff       	call   c0101f60 <pic_setmask>
    }
}
c010211b:	90                   	nop
c010211c:	c9                   	leave  
c010211d:	c3                   	ret    

c010211e <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010211e:	55                   	push   %ebp
c010211f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0102121:	fb                   	sti    
    sti();
}
c0102122:	90                   	nop
c0102123:	5d                   	pop    %ebp
c0102124:	c3                   	ret    

c0102125 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0102125:	55                   	push   %ebp
c0102126:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0102128:	fa                   	cli    
    cli();
}
c0102129:	90                   	nop
c010212a:	5d                   	pop    %ebp
c010212b:	c3                   	ret    

c010212c <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010212c:	55                   	push   %ebp
c010212d:	89 e5                	mov    %esp,%ebp
c010212f:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102132:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102139:	00 
c010213a:	c7 04 24 40 98 10 c0 	movl   $0xc0109840,(%esp)
c0102141:	e8 65 e1 ff ff       	call   c01002ab <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0102146:	90                   	nop
c0102147:	c9                   	leave  
c0102148:	c3                   	ret    

c0102149 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102149:	55                   	push   %ebp
c010214a:	89 e5                	mov    %esp,%ebp
c010214c:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[]; //256  ISR's entry addrs
     
    uintptr_t ISR_addr = __vectors[0];
c010214f:	a1 e0 15 12 c0       	mov    0xc01215e0,%eax
c0102154:	89 45 fc             	mov    %eax,-0x4(%ebp)
    for (int i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++, ISR_addr = __vectors[i]){
c0102157:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c010215e:	e9 c3 00 00 00       	jmp    c0102226 <idt_init+0xdd>
        SETGATE(idt[i], 0, GD_KTEXT, ISR_addr, DPL_USER);                   
c0102163:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102166:	0f b7 d0             	movzwl %ax,%edx
c0102169:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010216c:	66 89 14 c5 60 47 12 	mov    %dx,-0x3fedb8a0(,%eax,8)
c0102173:	c0 
c0102174:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102177:	66 c7 04 c5 62 47 12 	movw   $0x8,-0x3fedb89e(,%eax,8)
c010217e:	c0 08 00 
c0102181:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102184:	0f b6 14 c5 64 47 12 	movzbl -0x3fedb89c(,%eax,8),%edx
c010218b:	c0 
c010218c:	80 e2 e0             	and    $0xe0,%dl
c010218f:	88 14 c5 64 47 12 c0 	mov    %dl,-0x3fedb89c(,%eax,8)
c0102196:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102199:	0f b6 14 c5 64 47 12 	movzbl -0x3fedb89c(,%eax,8),%edx
c01021a0:	c0 
c01021a1:	80 e2 1f             	and    $0x1f,%dl
c01021a4:	88 14 c5 64 47 12 c0 	mov    %dl,-0x3fedb89c(,%eax,8)
c01021ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021ae:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c01021b5:	c0 
c01021b6:	80 e2 f0             	and    $0xf0,%dl
c01021b9:	80 ca 0e             	or     $0xe,%dl
c01021bc:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c01021c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021c6:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c01021cd:	c0 
c01021ce:	80 e2 ef             	and    $0xef,%dl
c01021d1:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c01021d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021db:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c01021e2:	c0 
c01021e3:	80 ca 60             	or     $0x60,%dl
c01021e6:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c01021ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021f0:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c01021f7:	c0 
c01021f8:	80 ca 80             	or     $0x80,%dl
c01021fb:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c0102202:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102205:	c1 e8 10             	shr    $0x10,%eax
c0102208:	0f b7 d0             	movzwl %ax,%edx
c010220b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010220e:	66 89 14 c5 66 47 12 	mov    %dx,-0x3fedb89a(,%eax,8)
c0102215:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[]; //256  ISR's entry addrs
     
    uintptr_t ISR_addr = __vectors[0];
    for (int i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++, ISR_addr = __vectors[i]){
c0102216:	ff 45 f8             	incl   -0x8(%ebp)
c0102219:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010221c:	8b 04 85 e0 15 12 c0 	mov    -0x3fedea20(,%eax,4),%eax
c0102223:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0102226:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102229:	3d ff 00 00 00       	cmp    $0xff,%eax
c010222e:	0f 86 2f ff ff ff    	jbe    c0102163 <idt_init+0x1a>
        SETGATE(idt[i], 0, GD_KTEXT, ISR_addr, DPL_USER);                   
    }
    /*开启陷阱门*/
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
c0102234:	a1 c4 17 12 c0       	mov    0xc01217c4,%eax
c0102239:	0f b7 c0             	movzwl %ax,%eax
c010223c:	66 a3 28 4b 12 c0    	mov    %ax,0xc0124b28
c0102242:	66 c7 05 2a 4b 12 c0 	movw   $0x8,0xc0124b2a
c0102249:	08 00 
c010224b:	0f b6 05 2c 4b 12 c0 	movzbl 0xc0124b2c,%eax
c0102252:	24 e0                	and    $0xe0,%al
c0102254:	a2 2c 4b 12 c0       	mov    %al,0xc0124b2c
c0102259:	0f b6 05 2c 4b 12 c0 	movzbl 0xc0124b2c,%eax
c0102260:	24 1f                	and    $0x1f,%al
c0102262:	a2 2c 4b 12 c0       	mov    %al,0xc0124b2c
c0102267:	0f b6 05 2d 4b 12 c0 	movzbl 0xc0124b2d,%eax
c010226e:	0c 0f                	or     $0xf,%al
c0102270:	a2 2d 4b 12 c0       	mov    %al,0xc0124b2d
c0102275:	0f b6 05 2d 4b 12 c0 	movzbl 0xc0124b2d,%eax
c010227c:	24 ef                	and    $0xef,%al
c010227e:	a2 2d 4b 12 c0       	mov    %al,0xc0124b2d
c0102283:	0f b6 05 2d 4b 12 c0 	movzbl 0xc0124b2d,%eax
c010228a:	0c 60                	or     $0x60,%al
c010228c:	a2 2d 4b 12 c0       	mov    %al,0xc0124b2d
c0102291:	0f b6 05 2d 4b 12 c0 	movzbl 0xc0124b2d,%eax
c0102298:	0c 80                	or     $0x80,%al
c010229a:	a2 2d 4b 12 c0       	mov    %al,0xc0124b2d
c010229f:	a1 c4 17 12 c0       	mov    0xc01217c4,%eax
c01022a4:	c1 e8 10             	shr    $0x10,%eax
c01022a7:	0f b7 c0             	movzwl %ax,%eax
c01022aa:	66 a3 2e 4b 12 c0    	mov    %ax,0xc0124b2e
c01022b0:	c7 45 f4 60 15 12 c0 	movl   $0xc0121560,-0xc(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01022ba:	0f 01 18             	lidtl  (%eax)

    lidt(&idt_pd); 
}
c01022bd:	90                   	nop
c01022be:	c9                   	leave  
c01022bf:	c3                   	ret    

c01022c0 <trapname>:

static const char *
trapname(int trapno) {
c01022c0:	55                   	push   %ebp
c01022c1:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01022c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01022c6:	83 f8 13             	cmp    $0x13,%eax
c01022c9:	77 0c                	ja     c01022d7 <trapname+0x17>
        return excnames[trapno];
c01022cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ce:	8b 04 85 00 9c 10 c0 	mov    -0x3fef6400(,%eax,4),%eax
c01022d5:	eb 18                	jmp    c01022ef <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01022d7:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01022db:	7e 0d                	jle    c01022ea <trapname+0x2a>
c01022dd:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022e1:	7f 07                	jg     c01022ea <trapname+0x2a>
        return "Hardware Interrupt";
c01022e3:	b8 4a 98 10 c0       	mov    $0xc010984a,%eax
c01022e8:	eb 05                	jmp    c01022ef <trapname+0x2f>
    }
    return "(unknown trap)";
c01022ea:	b8 5d 98 10 c0       	mov    $0xc010985d,%eax
}
c01022ef:	5d                   	pop    %ebp
c01022f0:	c3                   	ret    

c01022f1 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022f1:	55                   	push   %ebp
c01022f2:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022fb:	83 f8 08             	cmp    $0x8,%eax
c01022fe:	0f 94 c0             	sete   %al
c0102301:	0f b6 c0             	movzbl %al,%eax
}
c0102304:	5d                   	pop    %ebp
c0102305:	c3                   	ret    

c0102306 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102306:	55                   	push   %ebp
c0102307:	89 e5                	mov    %esp,%ebp
c0102309:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010230c:	8b 45 08             	mov    0x8(%ebp),%eax
c010230f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102313:	c7 04 24 9e 98 10 c0 	movl   $0xc010989e,(%esp)
c010231a:	e8 8c df ff ff       	call   c01002ab <cprintf>
    print_regs(&tf->tf_regs);
c010231f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102322:	89 04 24             	mov    %eax,(%esp)
c0102325:	e8 91 01 00 00       	call   c01024bb <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010232a:	8b 45 08             	mov    0x8(%ebp),%eax
c010232d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102331:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102335:	c7 04 24 af 98 10 c0 	movl   $0xc01098af,(%esp)
c010233c:	e8 6a df ff ff       	call   c01002ab <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102341:	8b 45 08             	mov    0x8(%ebp),%eax
c0102344:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102348:	89 44 24 04          	mov    %eax,0x4(%esp)
c010234c:	c7 04 24 c2 98 10 c0 	movl   $0xc01098c2,(%esp)
c0102353:	e8 53 df ff ff       	call   c01002ab <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102358:	8b 45 08             	mov    0x8(%ebp),%eax
c010235b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010235f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102363:	c7 04 24 d5 98 10 c0 	movl   $0xc01098d5,(%esp)
c010236a:	e8 3c df ff ff       	call   c01002ab <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010236f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102372:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102376:	89 44 24 04          	mov    %eax,0x4(%esp)
c010237a:	c7 04 24 e8 98 10 c0 	movl   $0xc01098e8,(%esp)
c0102381:	e8 25 df ff ff       	call   c01002ab <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102386:	8b 45 08             	mov    0x8(%ebp),%eax
c0102389:	8b 40 30             	mov    0x30(%eax),%eax
c010238c:	89 04 24             	mov    %eax,(%esp)
c010238f:	e8 2c ff ff ff       	call   c01022c0 <trapname>
c0102394:	89 c2                	mov    %eax,%edx
c0102396:	8b 45 08             	mov    0x8(%ebp),%eax
c0102399:	8b 40 30             	mov    0x30(%eax),%eax
c010239c:	89 54 24 08          	mov    %edx,0x8(%esp)
c01023a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023a4:	c7 04 24 fb 98 10 c0 	movl   $0xc01098fb,(%esp)
c01023ab:	e8 fb de ff ff       	call   c01002ab <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01023b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b3:	8b 40 34             	mov    0x34(%eax),%eax
c01023b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023ba:	c7 04 24 0d 99 10 c0 	movl   $0xc010990d,(%esp)
c01023c1:	e8 e5 de ff ff       	call   c01002ab <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01023c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01023c9:	8b 40 38             	mov    0x38(%eax),%eax
c01023cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023d0:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01023d7:	e8 cf de ff ff       	call   c01002ab <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01023df:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023e7:	c7 04 24 2b 99 10 c0 	movl   $0xc010992b,(%esp)
c01023ee:	e8 b8 de ff ff       	call   c01002ab <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f6:	8b 40 40             	mov    0x40(%eax),%eax
c01023f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023fd:	c7 04 24 3e 99 10 c0 	movl   $0xc010993e,(%esp)
c0102404:	e8 a2 de ff ff       	call   c01002ab <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102409:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102410:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102417:	eb 3d                	jmp    c0102456 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102419:	8b 45 08             	mov    0x8(%ebp),%eax
c010241c:	8b 50 40             	mov    0x40(%eax),%edx
c010241f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102422:	21 d0                	and    %edx,%eax
c0102424:	85 c0                	test   %eax,%eax
c0102426:	74 28                	je     c0102450 <print_trapframe+0x14a>
c0102428:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010242b:	8b 04 85 80 15 12 c0 	mov    -0x3fedea80(,%eax,4),%eax
c0102432:	85 c0                	test   %eax,%eax
c0102434:	74 1a                	je     c0102450 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c0102436:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102439:	8b 04 85 80 15 12 c0 	mov    -0x3fedea80(,%eax,4),%eax
c0102440:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102444:	c7 04 24 4d 99 10 c0 	movl   $0xc010994d,(%esp)
c010244b:	e8 5b de ff ff       	call   c01002ab <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102450:	ff 45 f4             	incl   -0xc(%ebp)
c0102453:	d1 65 f0             	shll   -0x10(%ebp)
c0102456:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102459:	83 f8 17             	cmp    $0x17,%eax
c010245c:	76 bb                	jbe    c0102419 <print_trapframe+0x113>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c010245e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102461:	8b 40 40             	mov    0x40(%eax),%eax
c0102464:	25 00 30 00 00       	and    $0x3000,%eax
c0102469:	c1 e8 0c             	shr    $0xc,%eax
c010246c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102470:	c7 04 24 51 99 10 c0 	movl   $0xc0109951,(%esp)
c0102477:	e8 2f de ff ff       	call   c01002ab <cprintf>

    if (!trap_in_kernel(tf)) {
c010247c:	8b 45 08             	mov    0x8(%ebp),%eax
c010247f:	89 04 24             	mov    %eax,(%esp)
c0102482:	e8 6a fe ff ff       	call   c01022f1 <trap_in_kernel>
c0102487:	85 c0                	test   %eax,%eax
c0102489:	75 2d                	jne    c01024b8 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c010248b:	8b 45 08             	mov    0x8(%ebp),%eax
c010248e:	8b 40 44             	mov    0x44(%eax),%eax
c0102491:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102495:	c7 04 24 5a 99 10 c0 	movl   $0xc010995a,(%esp)
c010249c:	e8 0a de ff ff       	call   c01002ab <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c01024a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a4:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01024a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024ac:	c7 04 24 69 99 10 c0 	movl   $0xc0109969,(%esp)
c01024b3:	e8 f3 dd ff ff       	call   c01002ab <cprintf>
    }
}
c01024b8:	90                   	nop
c01024b9:	c9                   	leave  
c01024ba:	c3                   	ret    

c01024bb <print_regs>:

void
print_regs(struct pushregs *regs) {
c01024bb:	55                   	push   %ebp
c01024bc:	89 e5                	mov    %esp,%ebp
c01024be:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01024c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c4:	8b 00                	mov    (%eax),%eax
c01024c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024ca:	c7 04 24 7c 99 10 c0 	movl   $0xc010997c,(%esp)
c01024d1:	e8 d5 dd ff ff       	call   c01002ab <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01024d9:	8b 40 04             	mov    0x4(%eax),%eax
c01024dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024e0:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c01024e7:	e8 bf dd ff ff       	call   c01002ab <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ef:	8b 40 08             	mov    0x8(%eax),%eax
c01024f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024f6:	c7 04 24 9a 99 10 c0 	movl   $0xc010999a,(%esp)
c01024fd:	e8 a9 dd ff ff       	call   c01002ab <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102502:	8b 45 08             	mov    0x8(%ebp),%eax
c0102505:	8b 40 0c             	mov    0xc(%eax),%eax
c0102508:	89 44 24 04          	mov    %eax,0x4(%esp)
c010250c:	c7 04 24 a9 99 10 c0 	movl   $0xc01099a9,(%esp)
c0102513:	e8 93 dd ff ff       	call   c01002ab <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102518:	8b 45 08             	mov    0x8(%ebp),%eax
c010251b:	8b 40 10             	mov    0x10(%eax),%eax
c010251e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102522:	c7 04 24 b8 99 10 c0 	movl   $0xc01099b8,(%esp)
c0102529:	e8 7d dd ff ff       	call   c01002ab <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c010252e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102531:	8b 40 14             	mov    0x14(%eax),%eax
c0102534:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102538:	c7 04 24 c7 99 10 c0 	movl   $0xc01099c7,(%esp)
c010253f:	e8 67 dd ff ff       	call   c01002ab <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102544:	8b 45 08             	mov    0x8(%ebp),%eax
c0102547:	8b 40 18             	mov    0x18(%eax),%eax
c010254a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010254e:	c7 04 24 d6 99 10 c0 	movl   $0xc01099d6,(%esp)
c0102555:	e8 51 dd ff ff       	call   c01002ab <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010255a:	8b 45 08             	mov    0x8(%ebp),%eax
c010255d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102560:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102564:	c7 04 24 e5 99 10 c0 	movl   $0xc01099e5,(%esp)
c010256b:	e8 3b dd ff ff       	call   c01002ab <cprintf>
}
c0102570:	90                   	nop
c0102571:	c9                   	leave  
c0102572:	c3                   	ret    

c0102573 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102573:	55                   	push   %ebp
c0102574:	89 e5                	mov    %esp,%ebp
c0102576:	53                   	push   %ebx
c0102577:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010257a:	8b 45 08             	mov    0x8(%ebp),%eax
c010257d:	8b 40 34             	mov    0x34(%eax),%eax
c0102580:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102583:	85 c0                	test   %eax,%eax
c0102585:	74 07                	je     c010258e <print_pgfault+0x1b>
c0102587:	bb f4 99 10 c0       	mov    $0xc01099f4,%ebx
c010258c:	eb 05                	jmp    c0102593 <print_pgfault+0x20>
c010258e:	bb 05 9a 10 c0       	mov    $0xc0109a05,%ebx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102593:	8b 45 08             	mov    0x8(%ebp),%eax
c0102596:	8b 40 34             	mov    0x34(%eax),%eax
c0102599:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010259c:	85 c0                	test   %eax,%eax
c010259e:	74 07                	je     c01025a7 <print_pgfault+0x34>
c01025a0:	b9 57 00 00 00       	mov    $0x57,%ecx
c01025a5:	eb 05                	jmp    c01025ac <print_pgfault+0x39>
c01025a7:	b9 52 00 00 00       	mov    $0x52,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
c01025ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01025af:	8b 40 34             	mov    0x34(%eax),%eax
c01025b2:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025b5:	85 c0                	test   %eax,%eax
c01025b7:	74 07                	je     c01025c0 <print_pgfault+0x4d>
c01025b9:	ba 55 00 00 00       	mov    $0x55,%edx
c01025be:	eb 05                	jmp    c01025c5 <print_pgfault+0x52>
c01025c0:	ba 4b 00 00 00       	mov    $0x4b,%edx
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025c5:	0f 20 d0             	mov    %cr2,%eax
c01025c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025ce:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c01025d2:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01025d6:	89 54 24 08          	mov    %edx,0x8(%esp)
c01025da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025de:	c7 04 24 14 9a 10 c0 	movl   $0xc0109a14,(%esp)
c01025e5:	e8 c1 dc ff ff       	call   c01002ab <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01025ea:	90                   	nop
c01025eb:	83 c4 34             	add    $0x34,%esp
c01025ee:	5b                   	pop    %ebx
c01025ef:	5d                   	pop    %ebp
c01025f0:	c3                   	ret    

c01025f1 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025f1:	55                   	push   %ebp
c01025f2:	89 e5                	mov    %esp,%ebp
c01025f4:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025fa:	89 04 24             	mov    %eax,(%esp)
c01025fd:	e8 71 ff ff ff       	call   c0102573 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102602:	a1 10 50 12 c0       	mov    0xc0125010,%eax
c0102607:	85 c0                	test   %eax,%eax
c0102609:	74 26                	je     c0102631 <pgfault_handler+0x40>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010260b:	0f 20 d0             	mov    %cr2,%eax
c010260e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c0102611:	8b 4d f4             	mov    -0xc(%ebp),%ecx
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102614:	8b 45 08             	mov    0x8(%ebp),%eax
c0102617:	8b 50 34             	mov    0x34(%eax),%edx
c010261a:	a1 10 50 12 c0       	mov    0xc0125010,%eax
c010261f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0102623:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102627:	89 04 24             	mov    %eax,(%esp)
c010262a:	e8 fc 17 00 00       	call   c0103e2b <do_pgfault>
c010262f:	eb 1c                	jmp    c010264d <pgfault_handler+0x5c>
    }
    panic("unhandled page fault.\n");
c0102631:	c7 44 24 08 37 9a 10 	movl   $0xc0109a37,0x8(%esp)
c0102638:	c0 
c0102639:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0102640:	00 
c0102641:	c7 04 24 4e 9a 10 c0 	movl   $0xc0109a4e,(%esp)
c0102648:	e8 b5 dd ff ff       	call   c0100402 <__panic>
}
c010264d:	c9                   	leave  
c010264e:	c3                   	ret    

c010264f <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c010264f:	55                   	push   %ebp
c0102650:	89 e5                	mov    %esp,%ebp
c0102652:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102655:	8b 45 08             	mov    0x8(%ebp),%eax
c0102658:	8b 40 30             	mov    0x30(%eax),%eax
c010265b:	83 f8 24             	cmp    $0x24,%eax
c010265e:	0f 84 bc 00 00 00    	je     c0102720 <trap_dispatch+0xd1>
c0102664:	83 f8 24             	cmp    $0x24,%eax
c0102667:	77 1c                	ja     c0102685 <trap_dispatch+0x36>
c0102669:	83 f8 20             	cmp    $0x20,%eax
c010266c:	0f 84 86 00 00 00    	je     c01026f8 <trap_dispatch+0xa9>
c0102672:	83 f8 21             	cmp    $0x21,%eax
c0102675:	0f 84 ce 00 00 00    	je     c0102749 <trap_dispatch+0xfa>
c010267b:	83 f8 0e             	cmp    $0xe,%eax
c010267e:	74 32                	je     c01026b2 <trap_dispatch+0x63>
c0102680:	e9 43 01 00 00       	jmp    c01027c8 <trap_dispatch+0x179>
c0102685:	83 f8 78             	cmp    $0x78,%eax
c0102688:	0f 84 e4 00 00 00    	je     c0102772 <trap_dispatch+0x123>
c010268e:	83 f8 78             	cmp    $0x78,%eax
c0102691:	77 11                	ja     c01026a4 <trap_dispatch+0x55>
c0102693:	83 e8 2e             	sub    $0x2e,%eax
c0102696:	83 f8 01             	cmp    $0x1,%eax
c0102699:	0f 87 29 01 00 00    	ja     c01027c8 <trap_dispatch+0x179>
        tf->tf_cs = KERNEL_CS;
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c010269f:	e9 5d 01 00 00       	jmp    c0102801 <trap_dispatch+0x1b2>
trap_dispatch(struct trapframe *tf) {
    char c;

    int ret;

    switch (tf->tf_trapno) {
c01026a4:	83 f8 79             	cmp    $0x79,%eax
c01026a7:	0f 84 fe 00 00 00    	je     c01027ab <trap_dispatch+0x15c>
c01026ad:	e9 16 01 00 00       	jmp    c01027c8 <trap_dispatch+0x179>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01026b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01026b5:	89 04 24             	mov    %eax,(%esp)
c01026b8:	e8 34 ff ff ff       	call   c01025f1 <pgfault_handler>
c01026bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01026c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01026c4:	0f 84 33 01 00 00    	je     c01027fd <trap_dispatch+0x1ae>
            print_trapframe(tf);
c01026ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01026cd:	89 04 24             	mov    %eax,(%esp)
c01026d0:	e8 31 fc ff ff       	call   c0102306 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c01026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01026dc:	c7 44 24 08 5f 9a 10 	movl   $0xc0109a5f,0x8(%esp)
c01026e3:	c0 
c01026e4:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01026eb:	00 
c01026ec:	c7 04 24 4e 9a 10 c0 	movl   $0xc0109a4e,(%esp)
c01026f3:	e8 0a dd ff ff       	call   c0100402 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        if(++ticks == TICK_NUM){
c01026f8:	a1 0c 50 12 c0       	mov    0xc012500c,%eax
c01026fd:	40                   	inc    %eax
c01026fe:	a3 0c 50 12 c0       	mov    %eax,0xc012500c
c0102703:	83 f8 64             	cmp    $0x64,%eax
c0102706:	0f 85 f4 00 00 00    	jne    c0102800 <trap_dispatch+0x1b1>
            print_ticks();
c010270c:	e8 1b fa ff ff       	call   c010212c <print_ticks>
            ticks = 0;
c0102711:	c7 05 0c 50 12 c0 00 	movl   $0x0,0xc012500c
c0102718:	00 00 00 
        }
        break;
c010271b:	e9 e0 00 00 00       	jmp    c0102800 <trap_dispatch+0x1b1>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102720:	e8 cc f7 ff ff       	call   c0101ef1 <cons_getc>
c0102725:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102728:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c010272c:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102730:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102734:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102738:	c7 04 24 7a 9a 10 c0 	movl   $0xc0109a7a,(%esp)
c010273f:	e8 67 db ff ff       	call   c01002ab <cprintf>
        break;
c0102744:	e9 b8 00 00 00       	jmp    c0102801 <trap_dispatch+0x1b2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102749:	e8 a3 f7 ff ff       	call   c0101ef1 <cons_getc>
c010274e:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102751:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102755:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102759:	89 54 24 08          	mov    %edx,0x8(%esp)
c010275d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102761:	c7 04 24 8c 9a 10 c0 	movl   $0xc0109a8c,(%esp)
c0102768:	e8 3e db ff ff       	call   c01002ab <cprintf>
        break;
c010276d:	e9 8f 00 00 00       	jmp    c0102801 <trap_dispatch+0x1b2>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        tf->tf_eflags |= FL_IOPL_MASK;//在trap_dispatch中转User态时，将调用io所需权限降低。
c0102772:	8b 45 08             	mov    0x8(%ebp),%eax
c0102775:	8b 40 40             	mov    0x40(%eax),%eax
c0102778:	0d 00 30 00 00       	or     $0x3000,%eax
c010277d:	89 c2                	mov    %eax,%edx
c010277f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102782:	89 50 40             	mov    %edx,0x40(%eax)
        tf->tf_es = USER_DS;
c0102785:	8b 45 08             	mov    0x8(%ebp),%eax
c0102788:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
        tf->tf_ds = USER_DS;
c010278e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102791:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
        tf->tf_ss = USER_DS;
c0102797:	8b 45 08             	mov    0x8(%ebp),%eax
c010279a:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
        tf->tf_cs = USER_CS;
c01027a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01027a3:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
        break;
c01027a9:	eb 56                	jmp    c0102801 <trap_dispatch+0x1b2>
    case T_SWITCH_TOK:
        tf->tf_es = KERNEL_DS;
c01027ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ae:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_ds = KERNEL_DS;
c01027b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01027b7:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        // tf->tf_ss = 0x10;
        tf->tf_cs = KERNEL_CS;
c01027bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c0:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        break;
c01027c6:	eb 39                	jmp    c0102801 <trap_dispatch+0x1b2>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01027c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01027cb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01027cf:	83 e0 03             	and    $0x3,%eax
c01027d2:	85 c0                	test   %eax,%eax
c01027d4:	75 2b                	jne    c0102801 <trap_dispatch+0x1b2>
            print_trapframe(tf);
c01027d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01027d9:	89 04 24             	mov    %eax,(%esp)
c01027dc:	e8 25 fb ff ff       	call   c0102306 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c01027e1:	c7 44 24 08 9b 9a 10 	movl   $0xc0109a9b,0x8(%esp)
c01027e8:	c0 
c01027e9:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c01027f0:	00 
c01027f1:	c7 04 24 4e 9a 10 c0 	movl   $0xc0109a4e,(%esp)
c01027f8:	e8 05 dc ff ff       	call   c0100402 <__panic>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
            print_trapframe(tf);
            panic("handle pgfault failed. %e\n", ret);
        }
        break;
c01027fd:	90                   	nop
c01027fe:	eb 01                	jmp    c0102801 <trap_dispatch+0x1b2>
         */
        if(++ticks == TICK_NUM){
            print_ticks();
            ticks = 0;
        }
        break;
c0102800:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102801:	90                   	nop
c0102802:	c9                   	leave  
c0102803:	c3                   	ret    

c0102804 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102804:	55                   	push   %ebp
c0102805:	89 e5                	mov    %esp,%ebp
c0102807:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010280a:	8b 45 08             	mov    0x8(%ebp),%eax
c010280d:	89 04 24             	mov    %eax,(%esp)
c0102810:	e8 3a fe ff ff       	call   c010264f <trap_dispatch>
}
c0102815:	90                   	nop
c0102816:	c9                   	leave  
c0102817:	c3                   	ret    

c0102818 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102818:	6a 00                	push   $0x0
  pushl $0
c010281a:	6a 00                	push   $0x0
  jmp __alltraps
c010281c:	e9 69 0a 00 00       	jmp    c010328a <__alltraps>

c0102821 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102821:	6a 00                	push   $0x0
  pushl $1
c0102823:	6a 01                	push   $0x1
  jmp __alltraps
c0102825:	e9 60 0a 00 00       	jmp    c010328a <__alltraps>

c010282a <vector2>:
.globl vector2
vector2:
  pushl $0
c010282a:	6a 00                	push   $0x0
  pushl $2
c010282c:	6a 02                	push   $0x2
  jmp __alltraps
c010282e:	e9 57 0a 00 00       	jmp    c010328a <__alltraps>

c0102833 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102833:	6a 00                	push   $0x0
  pushl $3
c0102835:	6a 03                	push   $0x3
  jmp __alltraps
c0102837:	e9 4e 0a 00 00       	jmp    c010328a <__alltraps>

c010283c <vector4>:
.globl vector4
vector4:
  pushl $0
c010283c:	6a 00                	push   $0x0
  pushl $4
c010283e:	6a 04                	push   $0x4
  jmp __alltraps
c0102840:	e9 45 0a 00 00       	jmp    c010328a <__alltraps>

c0102845 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102845:	6a 00                	push   $0x0
  pushl $5
c0102847:	6a 05                	push   $0x5
  jmp __alltraps
c0102849:	e9 3c 0a 00 00       	jmp    c010328a <__alltraps>

c010284e <vector6>:
.globl vector6
vector6:
  pushl $0
c010284e:	6a 00                	push   $0x0
  pushl $6
c0102850:	6a 06                	push   $0x6
  jmp __alltraps
c0102852:	e9 33 0a 00 00       	jmp    c010328a <__alltraps>

c0102857 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102857:	6a 00                	push   $0x0
  pushl $7
c0102859:	6a 07                	push   $0x7
  jmp __alltraps
c010285b:	e9 2a 0a 00 00       	jmp    c010328a <__alltraps>

c0102860 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102860:	6a 08                	push   $0x8
  jmp __alltraps
c0102862:	e9 23 0a 00 00       	jmp    c010328a <__alltraps>

c0102867 <vector9>:
.globl vector9
vector9:
  pushl $0
c0102867:	6a 00                	push   $0x0
  pushl $9
c0102869:	6a 09                	push   $0x9
  jmp __alltraps
c010286b:	e9 1a 0a 00 00       	jmp    c010328a <__alltraps>

c0102870 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102870:	6a 0a                	push   $0xa
  jmp __alltraps
c0102872:	e9 13 0a 00 00       	jmp    c010328a <__alltraps>

c0102877 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102877:	6a 0b                	push   $0xb
  jmp __alltraps
c0102879:	e9 0c 0a 00 00       	jmp    c010328a <__alltraps>

c010287e <vector12>:
.globl vector12
vector12:
  pushl $12
c010287e:	6a 0c                	push   $0xc
  jmp __alltraps
c0102880:	e9 05 0a 00 00       	jmp    c010328a <__alltraps>

c0102885 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102885:	6a 0d                	push   $0xd
  jmp __alltraps
c0102887:	e9 fe 09 00 00       	jmp    c010328a <__alltraps>

c010288c <vector14>:
.globl vector14
vector14:
  pushl $14
c010288c:	6a 0e                	push   $0xe
  jmp __alltraps
c010288e:	e9 f7 09 00 00       	jmp    c010328a <__alltraps>

c0102893 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102893:	6a 00                	push   $0x0
  pushl $15
c0102895:	6a 0f                	push   $0xf
  jmp __alltraps
c0102897:	e9 ee 09 00 00       	jmp    c010328a <__alltraps>

c010289c <vector16>:
.globl vector16
vector16:
  pushl $0
c010289c:	6a 00                	push   $0x0
  pushl $16
c010289e:	6a 10                	push   $0x10
  jmp __alltraps
c01028a0:	e9 e5 09 00 00       	jmp    c010328a <__alltraps>

c01028a5 <vector17>:
.globl vector17
vector17:
  pushl $17
c01028a5:	6a 11                	push   $0x11
  jmp __alltraps
c01028a7:	e9 de 09 00 00       	jmp    c010328a <__alltraps>

c01028ac <vector18>:
.globl vector18
vector18:
  pushl $0
c01028ac:	6a 00                	push   $0x0
  pushl $18
c01028ae:	6a 12                	push   $0x12
  jmp __alltraps
c01028b0:	e9 d5 09 00 00       	jmp    c010328a <__alltraps>

c01028b5 <vector19>:
.globl vector19
vector19:
  pushl $0
c01028b5:	6a 00                	push   $0x0
  pushl $19
c01028b7:	6a 13                	push   $0x13
  jmp __alltraps
c01028b9:	e9 cc 09 00 00       	jmp    c010328a <__alltraps>

c01028be <vector20>:
.globl vector20
vector20:
  pushl $0
c01028be:	6a 00                	push   $0x0
  pushl $20
c01028c0:	6a 14                	push   $0x14
  jmp __alltraps
c01028c2:	e9 c3 09 00 00       	jmp    c010328a <__alltraps>

c01028c7 <vector21>:
.globl vector21
vector21:
  pushl $0
c01028c7:	6a 00                	push   $0x0
  pushl $21
c01028c9:	6a 15                	push   $0x15
  jmp __alltraps
c01028cb:	e9 ba 09 00 00       	jmp    c010328a <__alltraps>

c01028d0 <vector22>:
.globl vector22
vector22:
  pushl $0
c01028d0:	6a 00                	push   $0x0
  pushl $22
c01028d2:	6a 16                	push   $0x16
  jmp __alltraps
c01028d4:	e9 b1 09 00 00       	jmp    c010328a <__alltraps>

c01028d9 <vector23>:
.globl vector23
vector23:
  pushl $0
c01028d9:	6a 00                	push   $0x0
  pushl $23
c01028db:	6a 17                	push   $0x17
  jmp __alltraps
c01028dd:	e9 a8 09 00 00       	jmp    c010328a <__alltraps>

c01028e2 <vector24>:
.globl vector24
vector24:
  pushl $0
c01028e2:	6a 00                	push   $0x0
  pushl $24
c01028e4:	6a 18                	push   $0x18
  jmp __alltraps
c01028e6:	e9 9f 09 00 00       	jmp    c010328a <__alltraps>

c01028eb <vector25>:
.globl vector25
vector25:
  pushl $0
c01028eb:	6a 00                	push   $0x0
  pushl $25
c01028ed:	6a 19                	push   $0x19
  jmp __alltraps
c01028ef:	e9 96 09 00 00       	jmp    c010328a <__alltraps>

c01028f4 <vector26>:
.globl vector26
vector26:
  pushl $0
c01028f4:	6a 00                	push   $0x0
  pushl $26
c01028f6:	6a 1a                	push   $0x1a
  jmp __alltraps
c01028f8:	e9 8d 09 00 00       	jmp    c010328a <__alltraps>

c01028fd <vector27>:
.globl vector27
vector27:
  pushl $0
c01028fd:	6a 00                	push   $0x0
  pushl $27
c01028ff:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102901:	e9 84 09 00 00       	jmp    c010328a <__alltraps>

c0102906 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102906:	6a 00                	push   $0x0
  pushl $28
c0102908:	6a 1c                	push   $0x1c
  jmp __alltraps
c010290a:	e9 7b 09 00 00       	jmp    c010328a <__alltraps>

c010290f <vector29>:
.globl vector29
vector29:
  pushl $0
c010290f:	6a 00                	push   $0x0
  pushl $29
c0102911:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102913:	e9 72 09 00 00       	jmp    c010328a <__alltraps>

c0102918 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102918:	6a 00                	push   $0x0
  pushl $30
c010291a:	6a 1e                	push   $0x1e
  jmp __alltraps
c010291c:	e9 69 09 00 00       	jmp    c010328a <__alltraps>

c0102921 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102921:	6a 00                	push   $0x0
  pushl $31
c0102923:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102925:	e9 60 09 00 00       	jmp    c010328a <__alltraps>

c010292a <vector32>:
.globl vector32
vector32:
  pushl $0
c010292a:	6a 00                	push   $0x0
  pushl $32
c010292c:	6a 20                	push   $0x20
  jmp __alltraps
c010292e:	e9 57 09 00 00       	jmp    c010328a <__alltraps>

c0102933 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102933:	6a 00                	push   $0x0
  pushl $33
c0102935:	6a 21                	push   $0x21
  jmp __alltraps
c0102937:	e9 4e 09 00 00       	jmp    c010328a <__alltraps>

c010293c <vector34>:
.globl vector34
vector34:
  pushl $0
c010293c:	6a 00                	push   $0x0
  pushl $34
c010293e:	6a 22                	push   $0x22
  jmp __alltraps
c0102940:	e9 45 09 00 00       	jmp    c010328a <__alltraps>

c0102945 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102945:	6a 00                	push   $0x0
  pushl $35
c0102947:	6a 23                	push   $0x23
  jmp __alltraps
c0102949:	e9 3c 09 00 00       	jmp    c010328a <__alltraps>

c010294e <vector36>:
.globl vector36
vector36:
  pushl $0
c010294e:	6a 00                	push   $0x0
  pushl $36
c0102950:	6a 24                	push   $0x24
  jmp __alltraps
c0102952:	e9 33 09 00 00       	jmp    c010328a <__alltraps>

c0102957 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102957:	6a 00                	push   $0x0
  pushl $37
c0102959:	6a 25                	push   $0x25
  jmp __alltraps
c010295b:	e9 2a 09 00 00       	jmp    c010328a <__alltraps>

c0102960 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102960:	6a 00                	push   $0x0
  pushl $38
c0102962:	6a 26                	push   $0x26
  jmp __alltraps
c0102964:	e9 21 09 00 00       	jmp    c010328a <__alltraps>

c0102969 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102969:	6a 00                	push   $0x0
  pushl $39
c010296b:	6a 27                	push   $0x27
  jmp __alltraps
c010296d:	e9 18 09 00 00       	jmp    c010328a <__alltraps>

c0102972 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102972:	6a 00                	push   $0x0
  pushl $40
c0102974:	6a 28                	push   $0x28
  jmp __alltraps
c0102976:	e9 0f 09 00 00       	jmp    c010328a <__alltraps>

c010297b <vector41>:
.globl vector41
vector41:
  pushl $0
c010297b:	6a 00                	push   $0x0
  pushl $41
c010297d:	6a 29                	push   $0x29
  jmp __alltraps
c010297f:	e9 06 09 00 00       	jmp    c010328a <__alltraps>

c0102984 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102984:	6a 00                	push   $0x0
  pushl $42
c0102986:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102988:	e9 fd 08 00 00       	jmp    c010328a <__alltraps>

c010298d <vector43>:
.globl vector43
vector43:
  pushl $0
c010298d:	6a 00                	push   $0x0
  pushl $43
c010298f:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102991:	e9 f4 08 00 00       	jmp    c010328a <__alltraps>

c0102996 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102996:	6a 00                	push   $0x0
  pushl $44
c0102998:	6a 2c                	push   $0x2c
  jmp __alltraps
c010299a:	e9 eb 08 00 00       	jmp    c010328a <__alltraps>

c010299f <vector45>:
.globl vector45
vector45:
  pushl $0
c010299f:	6a 00                	push   $0x0
  pushl $45
c01029a1:	6a 2d                	push   $0x2d
  jmp __alltraps
c01029a3:	e9 e2 08 00 00       	jmp    c010328a <__alltraps>

c01029a8 <vector46>:
.globl vector46
vector46:
  pushl $0
c01029a8:	6a 00                	push   $0x0
  pushl $46
c01029aa:	6a 2e                	push   $0x2e
  jmp __alltraps
c01029ac:	e9 d9 08 00 00       	jmp    c010328a <__alltraps>

c01029b1 <vector47>:
.globl vector47
vector47:
  pushl $0
c01029b1:	6a 00                	push   $0x0
  pushl $47
c01029b3:	6a 2f                	push   $0x2f
  jmp __alltraps
c01029b5:	e9 d0 08 00 00       	jmp    c010328a <__alltraps>

c01029ba <vector48>:
.globl vector48
vector48:
  pushl $0
c01029ba:	6a 00                	push   $0x0
  pushl $48
c01029bc:	6a 30                	push   $0x30
  jmp __alltraps
c01029be:	e9 c7 08 00 00       	jmp    c010328a <__alltraps>

c01029c3 <vector49>:
.globl vector49
vector49:
  pushl $0
c01029c3:	6a 00                	push   $0x0
  pushl $49
c01029c5:	6a 31                	push   $0x31
  jmp __alltraps
c01029c7:	e9 be 08 00 00       	jmp    c010328a <__alltraps>

c01029cc <vector50>:
.globl vector50
vector50:
  pushl $0
c01029cc:	6a 00                	push   $0x0
  pushl $50
c01029ce:	6a 32                	push   $0x32
  jmp __alltraps
c01029d0:	e9 b5 08 00 00       	jmp    c010328a <__alltraps>

c01029d5 <vector51>:
.globl vector51
vector51:
  pushl $0
c01029d5:	6a 00                	push   $0x0
  pushl $51
c01029d7:	6a 33                	push   $0x33
  jmp __alltraps
c01029d9:	e9 ac 08 00 00       	jmp    c010328a <__alltraps>

c01029de <vector52>:
.globl vector52
vector52:
  pushl $0
c01029de:	6a 00                	push   $0x0
  pushl $52
c01029e0:	6a 34                	push   $0x34
  jmp __alltraps
c01029e2:	e9 a3 08 00 00       	jmp    c010328a <__alltraps>

c01029e7 <vector53>:
.globl vector53
vector53:
  pushl $0
c01029e7:	6a 00                	push   $0x0
  pushl $53
c01029e9:	6a 35                	push   $0x35
  jmp __alltraps
c01029eb:	e9 9a 08 00 00       	jmp    c010328a <__alltraps>

c01029f0 <vector54>:
.globl vector54
vector54:
  pushl $0
c01029f0:	6a 00                	push   $0x0
  pushl $54
c01029f2:	6a 36                	push   $0x36
  jmp __alltraps
c01029f4:	e9 91 08 00 00       	jmp    c010328a <__alltraps>

c01029f9 <vector55>:
.globl vector55
vector55:
  pushl $0
c01029f9:	6a 00                	push   $0x0
  pushl $55
c01029fb:	6a 37                	push   $0x37
  jmp __alltraps
c01029fd:	e9 88 08 00 00       	jmp    c010328a <__alltraps>

c0102a02 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102a02:	6a 00                	push   $0x0
  pushl $56
c0102a04:	6a 38                	push   $0x38
  jmp __alltraps
c0102a06:	e9 7f 08 00 00       	jmp    c010328a <__alltraps>

c0102a0b <vector57>:
.globl vector57
vector57:
  pushl $0
c0102a0b:	6a 00                	push   $0x0
  pushl $57
c0102a0d:	6a 39                	push   $0x39
  jmp __alltraps
c0102a0f:	e9 76 08 00 00       	jmp    c010328a <__alltraps>

c0102a14 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102a14:	6a 00                	push   $0x0
  pushl $58
c0102a16:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102a18:	e9 6d 08 00 00       	jmp    c010328a <__alltraps>

c0102a1d <vector59>:
.globl vector59
vector59:
  pushl $0
c0102a1d:	6a 00                	push   $0x0
  pushl $59
c0102a1f:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102a21:	e9 64 08 00 00       	jmp    c010328a <__alltraps>

c0102a26 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102a26:	6a 00                	push   $0x0
  pushl $60
c0102a28:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102a2a:	e9 5b 08 00 00       	jmp    c010328a <__alltraps>

c0102a2f <vector61>:
.globl vector61
vector61:
  pushl $0
c0102a2f:	6a 00                	push   $0x0
  pushl $61
c0102a31:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102a33:	e9 52 08 00 00       	jmp    c010328a <__alltraps>

c0102a38 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102a38:	6a 00                	push   $0x0
  pushl $62
c0102a3a:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102a3c:	e9 49 08 00 00       	jmp    c010328a <__alltraps>

c0102a41 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102a41:	6a 00                	push   $0x0
  pushl $63
c0102a43:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102a45:	e9 40 08 00 00       	jmp    c010328a <__alltraps>

c0102a4a <vector64>:
.globl vector64
vector64:
  pushl $0
c0102a4a:	6a 00                	push   $0x0
  pushl $64
c0102a4c:	6a 40                	push   $0x40
  jmp __alltraps
c0102a4e:	e9 37 08 00 00       	jmp    c010328a <__alltraps>

c0102a53 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102a53:	6a 00                	push   $0x0
  pushl $65
c0102a55:	6a 41                	push   $0x41
  jmp __alltraps
c0102a57:	e9 2e 08 00 00       	jmp    c010328a <__alltraps>

c0102a5c <vector66>:
.globl vector66
vector66:
  pushl $0
c0102a5c:	6a 00                	push   $0x0
  pushl $66
c0102a5e:	6a 42                	push   $0x42
  jmp __alltraps
c0102a60:	e9 25 08 00 00       	jmp    c010328a <__alltraps>

c0102a65 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102a65:	6a 00                	push   $0x0
  pushl $67
c0102a67:	6a 43                	push   $0x43
  jmp __alltraps
c0102a69:	e9 1c 08 00 00       	jmp    c010328a <__alltraps>

c0102a6e <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a6e:	6a 00                	push   $0x0
  pushl $68
c0102a70:	6a 44                	push   $0x44
  jmp __alltraps
c0102a72:	e9 13 08 00 00       	jmp    c010328a <__alltraps>

c0102a77 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a77:	6a 00                	push   $0x0
  pushl $69
c0102a79:	6a 45                	push   $0x45
  jmp __alltraps
c0102a7b:	e9 0a 08 00 00       	jmp    c010328a <__alltraps>

c0102a80 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a80:	6a 00                	push   $0x0
  pushl $70
c0102a82:	6a 46                	push   $0x46
  jmp __alltraps
c0102a84:	e9 01 08 00 00       	jmp    c010328a <__alltraps>

c0102a89 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a89:	6a 00                	push   $0x0
  pushl $71
c0102a8b:	6a 47                	push   $0x47
  jmp __alltraps
c0102a8d:	e9 f8 07 00 00       	jmp    c010328a <__alltraps>

c0102a92 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102a92:	6a 00                	push   $0x0
  pushl $72
c0102a94:	6a 48                	push   $0x48
  jmp __alltraps
c0102a96:	e9 ef 07 00 00       	jmp    c010328a <__alltraps>

c0102a9b <vector73>:
.globl vector73
vector73:
  pushl $0
c0102a9b:	6a 00                	push   $0x0
  pushl $73
c0102a9d:	6a 49                	push   $0x49
  jmp __alltraps
c0102a9f:	e9 e6 07 00 00       	jmp    c010328a <__alltraps>

c0102aa4 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102aa4:	6a 00                	push   $0x0
  pushl $74
c0102aa6:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102aa8:	e9 dd 07 00 00       	jmp    c010328a <__alltraps>

c0102aad <vector75>:
.globl vector75
vector75:
  pushl $0
c0102aad:	6a 00                	push   $0x0
  pushl $75
c0102aaf:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102ab1:	e9 d4 07 00 00       	jmp    c010328a <__alltraps>

c0102ab6 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102ab6:	6a 00                	push   $0x0
  pushl $76
c0102ab8:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102aba:	e9 cb 07 00 00       	jmp    c010328a <__alltraps>

c0102abf <vector77>:
.globl vector77
vector77:
  pushl $0
c0102abf:	6a 00                	push   $0x0
  pushl $77
c0102ac1:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102ac3:	e9 c2 07 00 00       	jmp    c010328a <__alltraps>

c0102ac8 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102ac8:	6a 00                	push   $0x0
  pushl $78
c0102aca:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102acc:	e9 b9 07 00 00       	jmp    c010328a <__alltraps>

c0102ad1 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102ad1:	6a 00                	push   $0x0
  pushl $79
c0102ad3:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102ad5:	e9 b0 07 00 00       	jmp    c010328a <__alltraps>

c0102ada <vector80>:
.globl vector80
vector80:
  pushl $0
c0102ada:	6a 00                	push   $0x0
  pushl $80
c0102adc:	6a 50                	push   $0x50
  jmp __alltraps
c0102ade:	e9 a7 07 00 00       	jmp    c010328a <__alltraps>

c0102ae3 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102ae3:	6a 00                	push   $0x0
  pushl $81
c0102ae5:	6a 51                	push   $0x51
  jmp __alltraps
c0102ae7:	e9 9e 07 00 00       	jmp    c010328a <__alltraps>

c0102aec <vector82>:
.globl vector82
vector82:
  pushl $0
c0102aec:	6a 00                	push   $0x0
  pushl $82
c0102aee:	6a 52                	push   $0x52
  jmp __alltraps
c0102af0:	e9 95 07 00 00       	jmp    c010328a <__alltraps>

c0102af5 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102af5:	6a 00                	push   $0x0
  pushl $83
c0102af7:	6a 53                	push   $0x53
  jmp __alltraps
c0102af9:	e9 8c 07 00 00       	jmp    c010328a <__alltraps>

c0102afe <vector84>:
.globl vector84
vector84:
  pushl $0
c0102afe:	6a 00                	push   $0x0
  pushl $84
c0102b00:	6a 54                	push   $0x54
  jmp __alltraps
c0102b02:	e9 83 07 00 00       	jmp    c010328a <__alltraps>

c0102b07 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102b07:	6a 00                	push   $0x0
  pushl $85
c0102b09:	6a 55                	push   $0x55
  jmp __alltraps
c0102b0b:	e9 7a 07 00 00       	jmp    c010328a <__alltraps>

c0102b10 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102b10:	6a 00                	push   $0x0
  pushl $86
c0102b12:	6a 56                	push   $0x56
  jmp __alltraps
c0102b14:	e9 71 07 00 00       	jmp    c010328a <__alltraps>

c0102b19 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102b19:	6a 00                	push   $0x0
  pushl $87
c0102b1b:	6a 57                	push   $0x57
  jmp __alltraps
c0102b1d:	e9 68 07 00 00       	jmp    c010328a <__alltraps>

c0102b22 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102b22:	6a 00                	push   $0x0
  pushl $88
c0102b24:	6a 58                	push   $0x58
  jmp __alltraps
c0102b26:	e9 5f 07 00 00       	jmp    c010328a <__alltraps>

c0102b2b <vector89>:
.globl vector89
vector89:
  pushl $0
c0102b2b:	6a 00                	push   $0x0
  pushl $89
c0102b2d:	6a 59                	push   $0x59
  jmp __alltraps
c0102b2f:	e9 56 07 00 00       	jmp    c010328a <__alltraps>

c0102b34 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102b34:	6a 00                	push   $0x0
  pushl $90
c0102b36:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102b38:	e9 4d 07 00 00       	jmp    c010328a <__alltraps>

c0102b3d <vector91>:
.globl vector91
vector91:
  pushl $0
c0102b3d:	6a 00                	push   $0x0
  pushl $91
c0102b3f:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102b41:	e9 44 07 00 00       	jmp    c010328a <__alltraps>

c0102b46 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102b46:	6a 00                	push   $0x0
  pushl $92
c0102b48:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102b4a:	e9 3b 07 00 00       	jmp    c010328a <__alltraps>

c0102b4f <vector93>:
.globl vector93
vector93:
  pushl $0
c0102b4f:	6a 00                	push   $0x0
  pushl $93
c0102b51:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102b53:	e9 32 07 00 00       	jmp    c010328a <__alltraps>

c0102b58 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102b58:	6a 00                	push   $0x0
  pushl $94
c0102b5a:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102b5c:	e9 29 07 00 00       	jmp    c010328a <__alltraps>

c0102b61 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b61:	6a 00                	push   $0x0
  pushl $95
c0102b63:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102b65:	e9 20 07 00 00       	jmp    c010328a <__alltraps>

c0102b6a <vector96>:
.globl vector96
vector96:
  pushl $0
c0102b6a:	6a 00                	push   $0x0
  pushl $96
c0102b6c:	6a 60                	push   $0x60
  jmp __alltraps
c0102b6e:	e9 17 07 00 00       	jmp    c010328a <__alltraps>

c0102b73 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b73:	6a 00                	push   $0x0
  pushl $97
c0102b75:	6a 61                	push   $0x61
  jmp __alltraps
c0102b77:	e9 0e 07 00 00       	jmp    c010328a <__alltraps>

c0102b7c <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b7c:	6a 00                	push   $0x0
  pushl $98
c0102b7e:	6a 62                	push   $0x62
  jmp __alltraps
c0102b80:	e9 05 07 00 00       	jmp    c010328a <__alltraps>

c0102b85 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b85:	6a 00                	push   $0x0
  pushl $99
c0102b87:	6a 63                	push   $0x63
  jmp __alltraps
c0102b89:	e9 fc 06 00 00       	jmp    c010328a <__alltraps>

c0102b8e <vector100>:
.globl vector100
vector100:
  pushl $0
c0102b8e:	6a 00                	push   $0x0
  pushl $100
c0102b90:	6a 64                	push   $0x64
  jmp __alltraps
c0102b92:	e9 f3 06 00 00       	jmp    c010328a <__alltraps>

c0102b97 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102b97:	6a 00                	push   $0x0
  pushl $101
c0102b99:	6a 65                	push   $0x65
  jmp __alltraps
c0102b9b:	e9 ea 06 00 00       	jmp    c010328a <__alltraps>

c0102ba0 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102ba0:	6a 00                	push   $0x0
  pushl $102
c0102ba2:	6a 66                	push   $0x66
  jmp __alltraps
c0102ba4:	e9 e1 06 00 00       	jmp    c010328a <__alltraps>

c0102ba9 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102ba9:	6a 00                	push   $0x0
  pushl $103
c0102bab:	6a 67                	push   $0x67
  jmp __alltraps
c0102bad:	e9 d8 06 00 00       	jmp    c010328a <__alltraps>

c0102bb2 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102bb2:	6a 00                	push   $0x0
  pushl $104
c0102bb4:	6a 68                	push   $0x68
  jmp __alltraps
c0102bb6:	e9 cf 06 00 00       	jmp    c010328a <__alltraps>

c0102bbb <vector105>:
.globl vector105
vector105:
  pushl $0
c0102bbb:	6a 00                	push   $0x0
  pushl $105
c0102bbd:	6a 69                	push   $0x69
  jmp __alltraps
c0102bbf:	e9 c6 06 00 00       	jmp    c010328a <__alltraps>

c0102bc4 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102bc4:	6a 00                	push   $0x0
  pushl $106
c0102bc6:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102bc8:	e9 bd 06 00 00       	jmp    c010328a <__alltraps>

c0102bcd <vector107>:
.globl vector107
vector107:
  pushl $0
c0102bcd:	6a 00                	push   $0x0
  pushl $107
c0102bcf:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102bd1:	e9 b4 06 00 00       	jmp    c010328a <__alltraps>

c0102bd6 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102bd6:	6a 00                	push   $0x0
  pushl $108
c0102bd8:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102bda:	e9 ab 06 00 00       	jmp    c010328a <__alltraps>

c0102bdf <vector109>:
.globl vector109
vector109:
  pushl $0
c0102bdf:	6a 00                	push   $0x0
  pushl $109
c0102be1:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102be3:	e9 a2 06 00 00       	jmp    c010328a <__alltraps>

c0102be8 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102be8:	6a 00                	push   $0x0
  pushl $110
c0102bea:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102bec:	e9 99 06 00 00       	jmp    c010328a <__alltraps>

c0102bf1 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102bf1:	6a 00                	push   $0x0
  pushl $111
c0102bf3:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102bf5:	e9 90 06 00 00       	jmp    c010328a <__alltraps>

c0102bfa <vector112>:
.globl vector112
vector112:
  pushl $0
c0102bfa:	6a 00                	push   $0x0
  pushl $112
c0102bfc:	6a 70                	push   $0x70
  jmp __alltraps
c0102bfe:	e9 87 06 00 00       	jmp    c010328a <__alltraps>

c0102c03 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102c03:	6a 00                	push   $0x0
  pushl $113
c0102c05:	6a 71                	push   $0x71
  jmp __alltraps
c0102c07:	e9 7e 06 00 00       	jmp    c010328a <__alltraps>

c0102c0c <vector114>:
.globl vector114
vector114:
  pushl $0
c0102c0c:	6a 00                	push   $0x0
  pushl $114
c0102c0e:	6a 72                	push   $0x72
  jmp __alltraps
c0102c10:	e9 75 06 00 00       	jmp    c010328a <__alltraps>

c0102c15 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102c15:	6a 00                	push   $0x0
  pushl $115
c0102c17:	6a 73                	push   $0x73
  jmp __alltraps
c0102c19:	e9 6c 06 00 00       	jmp    c010328a <__alltraps>

c0102c1e <vector116>:
.globl vector116
vector116:
  pushl $0
c0102c1e:	6a 00                	push   $0x0
  pushl $116
c0102c20:	6a 74                	push   $0x74
  jmp __alltraps
c0102c22:	e9 63 06 00 00       	jmp    c010328a <__alltraps>

c0102c27 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102c27:	6a 00                	push   $0x0
  pushl $117
c0102c29:	6a 75                	push   $0x75
  jmp __alltraps
c0102c2b:	e9 5a 06 00 00       	jmp    c010328a <__alltraps>

c0102c30 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102c30:	6a 00                	push   $0x0
  pushl $118
c0102c32:	6a 76                	push   $0x76
  jmp __alltraps
c0102c34:	e9 51 06 00 00       	jmp    c010328a <__alltraps>

c0102c39 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102c39:	6a 00                	push   $0x0
  pushl $119
c0102c3b:	6a 77                	push   $0x77
  jmp __alltraps
c0102c3d:	e9 48 06 00 00       	jmp    c010328a <__alltraps>

c0102c42 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102c42:	6a 00                	push   $0x0
  pushl $120
c0102c44:	6a 78                	push   $0x78
  jmp __alltraps
c0102c46:	e9 3f 06 00 00       	jmp    c010328a <__alltraps>

c0102c4b <vector121>:
.globl vector121
vector121:
  pushl $0
c0102c4b:	6a 00                	push   $0x0
  pushl $121
c0102c4d:	6a 79                	push   $0x79
  jmp __alltraps
c0102c4f:	e9 36 06 00 00       	jmp    c010328a <__alltraps>

c0102c54 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102c54:	6a 00                	push   $0x0
  pushl $122
c0102c56:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102c58:	e9 2d 06 00 00       	jmp    c010328a <__alltraps>

c0102c5d <vector123>:
.globl vector123
vector123:
  pushl $0
c0102c5d:	6a 00                	push   $0x0
  pushl $123
c0102c5f:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c61:	e9 24 06 00 00       	jmp    c010328a <__alltraps>

c0102c66 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102c66:	6a 00                	push   $0x0
  pushl $124
c0102c68:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102c6a:	e9 1b 06 00 00       	jmp    c010328a <__alltraps>

c0102c6f <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c6f:	6a 00                	push   $0x0
  pushl $125
c0102c71:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c73:	e9 12 06 00 00       	jmp    c010328a <__alltraps>

c0102c78 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c78:	6a 00                	push   $0x0
  pushl $126
c0102c7a:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c7c:	e9 09 06 00 00       	jmp    c010328a <__alltraps>

c0102c81 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c81:	6a 00                	push   $0x0
  pushl $127
c0102c83:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c85:	e9 00 06 00 00       	jmp    c010328a <__alltraps>

c0102c8a <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c8a:	6a 00                	push   $0x0
  pushl $128
c0102c8c:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102c91:	e9 f4 05 00 00       	jmp    c010328a <__alltraps>

c0102c96 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102c96:	6a 00                	push   $0x0
  pushl $129
c0102c98:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102c9d:	e9 e8 05 00 00       	jmp    c010328a <__alltraps>

c0102ca2 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102ca2:	6a 00                	push   $0x0
  pushl $130
c0102ca4:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102ca9:	e9 dc 05 00 00       	jmp    c010328a <__alltraps>

c0102cae <vector131>:
.globl vector131
vector131:
  pushl $0
c0102cae:	6a 00                	push   $0x0
  pushl $131
c0102cb0:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102cb5:	e9 d0 05 00 00       	jmp    c010328a <__alltraps>

c0102cba <vector132>:
.globl vector132
vector132:
  pushl $0
c0102cba:	6a 00                	push   $0x0
  pushl $132
c0102cbc:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102cc1:	e9 c4 05 00 00       	jmp    c010328a <__alltraps>

c0102cc6 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102cc6:	6a 00                	push   $0x0
  pushl $133
c0102cc8:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102ccd:	e9 b8 05 00 00       	jmp    c010328a <__alltraps>

c0102cd2 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102cd2:	6a 00                	push   $0x0
  pushl $134
c0102cd4:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102cd9:	e9 ac 05 00 00       	jmp    c010328a <__alltraps>

c0102cde <vector135>:
.globl vector135
vector135:
  pushl $0
c0102cde:	6a 00                	push   $0x0
  pushl $135
c0102ce0:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102ce5:	e9 a0 05 00 00       	jmp    c010328a <__alltraps>

c0102cea <vector136>:
.globl vector136
vector136:
  pushl $0
c0102cea:	6a 00                	push   $0x0
  pushl $136
c0102cec:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102cf1:	e9 94 05 00 00       	jmp    c010328a <__alltraps>

c0102cf6 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102cf6:	6a 00                	push   $0x0
  pushl $137
c0102cf8:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102cfd:	e9 88 05 00 00       	jmp    c010328a <__alltraps>

c0102d02 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102d02:	6a 00                	push   $0x0
  pushl $138
c0102d04:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102d09:	e9 7c 05 00 00       	jmp    c010328a <__alltraps>

c0102d0e <vector139>:
.globl vector139
vector139:
  pushl $0
c0102d0e:	6a 00                	push   $0x0
  pushl $139
c0102d10:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102d15:	e9 70 05 00 00       	jmp    c010328a <__alltraps>

c0102d1a <vector140>:
.globl vector140
vector140:
  pushl $0
c0102d1a:	6a 00                	push   $0x0
  pushl $140
c0102d1c:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102d21:	e9 64 05 00 00       	jmp    c010328a <__alltraps>

c0102d26 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102d26:	6a 00                	push   $0x0
  pushl $141
c0102d28:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102d2d:	e9 58 05 00 00       	jmp    c010328a <__alltraps>

c0102d32 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102d32:	6a 00                	push   $0x0
  pushl $142
c0102d34:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102d39:	e9 4c 05 00 00       	jmp    c010328a <__alltraps>

c0102d3e <vector143>:
.globl vector143
vector143:
  pushl $0
c0102d3e:	6a 00                	push   $0x0
  pushl $143
c0102d40:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102d45:	e9 40 05 00 00       	jmp    c010328a <__alltraps>

c0102d4a <vector144>:
.globl vector144
vector144:
  pushl $0
c0102d4a:	6a 00                	push   $0x0
  pushl $144
c0102d4c:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102d51:	e9 34 05 00 00       	jmp    c010328a <__alltraps>

c0102d56 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102d56:	6a 00                	push   $0x0
  pushl $145
c0102d58:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102d5d:	e9 28 05 00 00       	jmp    c010328a <__alltraps>

c0102d62 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d62:	6a 00                	push   $0x0
  pushl $146
c0102d64:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102d69:	e9 1c 05 00 00       	jmp    c010328a <__alltraps>

c0102d6e <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d6e:	6a 00                	push   $0x0
  pushl $147
c0102d70:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d75:	e9 10 05 00 00       	jmp    c010328a <__alltraps>

c0102d7a <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d7a:	6a 00                	push   $0x0
  pushl $148
c0102d7c:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d81:	e9 04 05 00 00       	jmp    c010328a <__alltraps>

c0102d86 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d86:	6a 00                	push   $0x0
  pushl $149
c0102d88:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102d8d:	e9 f8 04 00 00       	jmp    c010328a <__alltraps>

c0102d92 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102d92:	6a 00                	push   $0x0
  pushl $150
c0102d94:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102d99:	e9 ec 04 00 00       	jmp    c010328a <__alltraps>

c0102d9e <vector151>:
.globl vector151
vector151:
  pushl $0
c0102d9e:	6a 00                	push   $0x0
  pushl $151
c0102da0:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102da5:	e9 e0 04 00 00       	jmp    c010328a <__alltraps>

c0102daa <vector152>:
.globl vector152
vector152:
  pushl $0
c0102daa:	6a 00                	push   $0x0
  pushl $152
c0102dac:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102db1:	e9 d4 04 00 00       	jmp    c010328a <__alltraps>

c0102db6 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102db6:	6a 00                	push   $0x0
  pushl $153
c0102db8:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102dbd:	e9 c8 04 00 00       	jmp    c010328a <__alltraps>

c0102dc2 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102dc2:	6a 00                	push   $0x0
  pushl $154
c0102dc4:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102dc9:	e9 bc 04 00 00       	jmp    c010328a <__alltraps>

c0102dce <vector155>:
.globl vector155
vector155:
  pushl $0
c0102dce:	6a 00                	push   $0x0
  pushl $155
c0102dd0:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102dd5:	e9 b0 04 00 00       	jmp    c010328a <__alltraps>

c0102dda <vector156>:
.globl vector156
vector156:
  pushl $0
c0102dda:	6a 00                	push   $0x0
  pushl $156
c0102ddc:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102de1:	e9 a4 04 00 00       	jmp    c010328a <__alltraps>

c0102de6 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102de6:	6a 00                	push   $0x0
  pushl $157
c0102de8:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102ded:	e9 98 04 00 00       	jmp    c010328a <__alltraps>

c0102df2 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102df2:	6a 00                	push   $0x0
  pushl $158
c0102df4:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102df9:	e9 8c 04 00 00       	jmp    c010328a <__alltraps>

c0102dfe <vector159>:
.globl vector159
vector159:
  pushl $0
c0102dfe:	6a 00                	push   $0x0
  pushl $159
c0102e00:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102e05:	e9 80 04 00 00       	jmp    c010328a <__alltraps>

c0102e0a <vector160>:
.globl vector160
vector160:
  pushl $0
c0102e0a:	6a 00                	push   $0x0
  pushl $160
c0102e0c:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102e11:	e9 74 04 00 00       	jmp    c010328a <__alltraps>

c0102e16 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102e16:	6a 00                	push   $0x0
  pushl $161
c0102e18:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102e1d:	e9 68 04 00 00       	jmp    c010328a <__alltraps>

c0102e22 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102e22:	6a 00                	push   $0x0
  pushl $162
c0102e24:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102e29:	e9 5c 04 00 00       	jmp    c010328a <__alltraps>

c0102e2e <vector163>:
.globl vector163
vector163:
  pushl $0
c0102e2e:	6a 00                	push   $0x0
  pushl $163
c0102e30:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102e35:	e9 50 04 00 00       	jmp    c010328a <__alltraps>

c0102e3a <vector164>:
.globl vector164
vector164:
  pushl $0
c0102e3a:	6a 00                	push   $0x0
  pushl $164
c0102e3c:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102e41:	e9 44 04 00 00       	jmp    c010328a <__alltraps>

c0102e46 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102e46:	6a 00                	push   $0x0
  pushl $165
c0102e48:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102e4d:	e9 38 04 00 00       	jmp    c010328a <__alltraps>

c0102e52 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102e52:	6a 00                	push   $0x0
  pushl $166
c0102e54:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102e59:	e9 2c 04 00 00       	jmp    c010328a <__alltraps>

c0102e5e <vector167>:
.globl vector167
vector167:
  pushl $0
c0102e5e:	6a 00                	push   $0x0
  pushl $167
c0102e60:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102e65:	e9 20 04 00 00       	jmp    c010328a <__alltraps>

c0102e6a <vector168>:
.globl vector168
vector168:
  pushl $0
c0102e6a:	6a 00                	push   $0x0
  pushl $168
c0102e6c:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e71:	e9 14 04 00 00       	jmp    c010328a <__alltraps>

c0102e76 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e76:	6a 00                	push   $0x0
  pushl $169
c0102e78:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e7d:	e9 08 04 00 00       	jmp    c010328a <__alltraps>

c0102e82 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e82:	6a 00                	push   $0x0
  pushl $170
c0102e84:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e89:	e9 fc 03 00 00       	jmp    c010328a <__alltraps>

c0102e8e <vector171>:
.globl vector171
vector171:
  pushl $0
c0102e8e:	6a 00                	push   $0x0
  pushl $171
c0102e90:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102e95:	e9 f0 03 00 00       	jmp    c010328a <__alltraps>

c0102e9a <vector172>:
.globl vector172
vector172:
  pushl $0
c0102e9a:	6a 00                	push   $0x0
  pushl $172
c0102e9c:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102ea1:	e9 e4 03 00 00       	jmp    c010328a <__alltraps>

c0102ea6 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102ea6:	6a 00                	push   $0x0
  pushl $173
c0102ea8:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102ead:	e9 d8 03 00 00       	jmp    c010328a <__alltraps>

c0102eb2 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102eb2:	6a 00                	push   $0x0
  pushl $174
c0102eb4:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102eb9:	e9 cc 03 00 00       	jmp    c010328a <__alltraps>

c0102ebe <vector175>:
.globl vector175
vector175:
  pushl $0
c0102ebe:	6a 00                	push   $0x0
  pushl $175
c0102ec0:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102ec5:	e9 c0 03 00 00       	jmp    c010328a <__alltraps>

c0102eca <vector176>:
.globl vector176
vector176:
  pushl $0
c0102eca:	6a 00                	push   $0x0
  pushl $176
c0102ecc:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102ed1:	e9 b4 03 00 00       	jmp    c010328a <__alltraps>

c0102ed6 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102ed6:	6a 00                	push   $0x0
  pushl $177
c0102ed8:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102edd:	e9 a8 03 00 00       	jmp    c010328a <__alltraps>

c0102ee2 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102ee2:	6a 00                	push   $0x0
  pushl $178
c0102ee4:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102ee9:	e9 9c 03 00 00       	jmp    c010328a <__alltraps>

c0102eee <vector179>:
.globl vector179
vector179:
  pushl $0
c0102eee:	6a 00                	push   $0x0
  pushl $179
c0102ef0:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102ef5:	e9 90 03 00 00       	jmp    c010328a <__alltraps>

c0102efa <vector180>:
.globl vector180
vector180:
  pushl $0
c0102efa:	6a 00                	push   $0x0
  pushl $180
c0102efc:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102f01:	e9 84 03 00 00       	jmp    c010328a <__alltraps>

c0102f06 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102f06:	6a 00                	push   $0x0
  pushl $181
c0102f08:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102f0d:	e9 78 03 00 00       	jmp    c010328a <__alltraps>

c0102f12 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102f12:	6a 00                	push   $0x0
  pushl $182
c0102f14:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102f19:	e9 6c 03 00 00       	jmp    c010328a <__alltraps>

c0102f1e <vector183>:
.globl vector183
vector183:
  pushl $0
c0102f1e:	6a 00                	push   $0x0
  pushl $183
c0102f20:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102f25:	e9 60 03 00 00       	jmp    c010328a <__alltraps>

c0102f2a <vector184>:
.globl vector184
vector184:
  pushl $0
c0102f2a:	6a 00                	push   $0x0
  pushl $184
c0102f2c:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102f31:	e9 54 03 00 00       	jmp    c010328a <__alltraps>

c0102f36 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102f36:	6a 00                	push   $0x0
  pushl $185
c0102f38:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102f3d:	e9 48 03 00 00       	jmp    c010328a <__alltraps>

c0102f42 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102f42:	6a 00                	push   $0x0
  pushl $186
c0102f44:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102f49:	e9 3c 03 00 00       	jmp    c010328a <__alltraps>

c0102f4e <vector187>:
.globl vector187
vector187:
  pushl $0
c0102f4e:	6a 00                	push   $0x0
  pushl $187
c0102f50:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102f55:	e9 30 03 00 00       	jmp    c010328a <__alltraps>

c0102f5a <vector188>:
.globl vector188
vector188:
  pushl $0
c0102f5a:	6a 00                	push   $0x0
  pushl $188
c0102f5c:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f61:	e9 24 03 00 00       	jmp    c010328a <__alltraps>

c0102f66 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102f66:	6a 00                	push   $0x0
  pushl $189
c0102f68:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102f6d:	e9 18 03 00 00       	jmp    c010328a <__alltraps>

c0102f72 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f72:	6a 00                	push   $0x0
  pushl $190
c0102f74:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f79:	e9 0c 03 00 00       	jmp    c010328a <__alltraps>

c0102f7e <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f7e:	6a 00                	push   $0x0
  pushl $191
c0102f80:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f85:	e9 00 03 00 00       	jmp    c010328a <__alltraps>

c0102f8a <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f8a:	6a 00                	push   $0x0
  pushl $192
c0102f8c:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102f91:	e9 f4 02 00 00       	jmp    c010328a <__alltraps>

c0102f96 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102f96:	6a 00                	push   $0x0
  pushl $193
c0102f98:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102f9d:	e9 e8 02 00 00       	jmp    c010328a <__alltraps>

c0102fa2 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102fa2:	6a 00                	push   $0x0
  pushl $194
c0102fa4:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102fa9:	e9 dc 02 00 00       	jmp    c010328a <__alltraps>

c0102fae <vector195>:
.globl vector195
vector195:
  pushl $0
c0102fae:	6a 00                	push   $0x0
  pushl $195
c0102fb0:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102fb5:	e9 d0 02 00 00       	jmp    c010328a <__alltraps>

c0102fba <vector196>:
.globl vector196
vector196:
  pushl $0
c0102fba:	6a 00                	push   $0x0
  pushl $196
c0102fbc:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102fc1:	e9 c4 02 00 00       	jmp    c010328a <__alltraps>

c0102fc6 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102fc6:	6a 00                	push   $0x0
  pushl $197
c0102fc8:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102fcd:	e9 b8 02 00 00       	jmp    c010328a <__alltraps>

c0102fd2 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102fd2:	6a 00                	push   $0x0
  pushl $198
c0102fd4:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102fd9:	e9 ac 02 00 00       	jmp    c010328a <__alltraps>

c0102fde <vector199>:
.globl vector199
vector199:
  pushl $0
c0102fde:	6a 00                	push   $0x0
  pushl $199
c0102fe0:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102fe5:	e9 a0 02 00 00       	jmp    c010328a <__alltraps>

c0102fea <vector200>:
.globl vector200
vector200:
  pushl $0
c0102fea:	6a 00                	push   $0x0
  pushl $200
c0102fec:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102ff1:	e9 94 02 00 00       	jmp    c010328a <__alltraps>

c0102ff6 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102ff6:	6a 00                	push   $0x0
  pushl $201
c0102ff8:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102ffd:	e9 88 02 00 00       	jmp    c010328a <__alltraps>

c0103002 <vector202>:
.globl vector202
vector202:
  pushl $0
c0103002:	6a 00                	push   $0x0
  pushl $202
c0103004:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0103009:	e9 7c 02 00 00       	jmp    c010328a <__alltraps>

c010300e <vector203>:
.globl vector203
vector203:
  pushl $0
c010300e:	6a 00                	push   $0x0
  pushl $203
c0103010:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0103015:	e9 70 02 00 00       	jmp    c010328a <__alltraps>

c010301a <vector204>:
.globl vector204
vector204:
  pushl $0
c010301a:	6a 00                	push   $0x0
  pushl $204
c010301c:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0103021:	e9 64 02 00 00       	jmp    c010328a <__alltraps>

c0103026 <vector205>:
.globl vector205
vector205:
  pushl $0
c0103026:	6a 00                	push   $0x0
  pushl $205
c0103028:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010302d:	e9 58 02 00 00       	jmp    c010328a <__alltraps>

c0103032 <vector206>:
.globl vector206
vector206:
  pushl $0
c0103032:	6a 00                	push   $0x0
  pushl $206
c0103034:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0103039:	e9 4c 02 00 00       	jmp    c010328a <__alltraps>

c010303e <vector207>:
.globl vector207
vector207:
  pushl $0
c010303e:	6a 00                	push   $0x0
  pushl $207
c0103040:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0103045:	e9 40 02 00 00       	jmp    c010328a <__alltraps>

c010304a <vector208>:
.globl vector208
vector208:
  pushl $0
c010304a:	6a 00                	push   $0x0
  pushl $208
c010304c:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103051:	e9 34 02 00 00       	jmp    c010328a <__alltraps>

c0103056 <vector209>:
.globl vector209
vector209:
  pushl $0
c0103056:	6a 00                	push   $0x0
  pushl $209
c0103058:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010305d:	e9 28 02 00 00       	jmp    c010328a <__alltraps>

c0103062 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103062:	6a 00                	push   $0x0
  pushl $210
c0103064:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0103069:	e9 1c 02 00 00       	jmp    c010328a <__alltraps>

c010306e <vector211>:
.globl vector211
vector211:
  pushl $0
c010306e:	6a 00                	push   $0x0
  pushl $211
c0103070:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0103075:	e9 10 02 00 00       	jmp    c010328a <__alltraps>

c010307a <vector212>:
.globl vector212
vector212:
  pushl $0
c010307a:	6a 00                	push   $0x0
  pushl $212
c010307c:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103081:	e9 04 02 00 00       	jmp    c010328a <__alltraps>

c0103086 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103086:	6a 00                	push   $0x0
  pushl $213
c0103088:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010308d:	e9 f8 01 00 00       	jmp    c010328a <__alltraps>

c0103092 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103092:	6a 00                	push   $0x0
  pushl $214
c0103094:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103099:	e9 ec 01 00 00       	jmp    c010328a <__alltraps>

c010309e <vector215>:
.globl vector215
vector215:
  pushl $0
c010309e:	6a 00                	push   $0x0
  pushl $215
c01030a0:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01030a5:	e9 e0 01 00 00       	jmp    c010328a <__alltraps>

c01030aa <vector216>:
.globl vector216
vector216:
  pushl $0
c01030aa:	6a 00                	push   $0x0
  pushl $216
c01030ac:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01030b1:	e9 d4 01 00 00       	jmp    c010328a <__alltraps>

c01030b6 <vector217>:
.globl vector217
vector217:
  pushl $0
c01030b6:	6a 00                	push   $0x0
  pushl $217
c01030b8:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01030bd:	e9 c8 01 00 00       	jmp    c010328a <__alltraps>

c01030c2 <vector218>:
.globl vector218
vector218:
  pushl $0
c01030c2:	6a 00                	push   $0x0
  pushl $218
c01030c4:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01030c9:	e9 bc 01 00 00       	jmp    c010328a <__alltraps>

c01030ce <vector219>:
.globl vector219
vector219:
  pushl $0
c01030ce:	6a 00                	push   $0x0
  pushl $219
c01030d0:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01030d5:	e9 b0 01 00 00       	jmp    c010328a <__alltraps>

c01030da <vector220>:
.globl vector220
vector220:
  pushl $0
c01030da:	6a 00                	push   $0x0
  pushl $220
c01030dc:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01030e1:	e9 a4 01 00 00       	jmp    c010328a <__alltraps>

c01030e6 <vector221>:
.globl vector221
vector221:
  pushl $0
c01030e6:	6a 00                	push   $0x0
  pushl $221
c01030e8:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01030ed:	e9 98 01 00 00       	jmp    c010328a <__alltraps>

c01030f2 <vector222>:
.globl vector222
vector222:
  pushl $0
c01030f2:	6a 00                	push   $0x0
  pushl $222
c01030f4:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01030f9:	e9 8c 01 00 00       	jmp    c010328a <__alltraps>

c01030fe <vector223>:
.globl vector223
vector223:
  pushl $0
c01030fe:	6a 00                	push   $0x0
  pushl $223
c0103100:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103105:	e9 80 01 00 00       	jmp    c010328a <__alltraps>

c010310a <vector224>:
.globl vector224
vector224:
  pushl $0
c010310a:	6a 00                	push   $0x0
  pushl $224
c010310c:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103111:	e9 74 01 00 00       	jmp    c010328a <__alltraps>

c0103116 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103116:	6a 00                	push   $0x0
  pushl $225
c0103118:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010311d:	e9 68 01 00 00       	jmp    c010328a <__alltraps>

c0103122 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103122:	6a 00                	push   $0x0
  pushl $226
c0103124:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103129:	e9 5c 01 00 00       	jmp    c010328a <__alltraps>

c010312e <vector227>:
.globl vector227
vector227:
  pushl $0
c010312e:	6a 00                	push   $0x0
  pushl $227
c0103130:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0103135:	e9 50 01 00 00       	jmp    c010328a <__alltraps>

c010313a <vector228>:
.globl vector228
vector228:
  pushl $0
c010313a:	6a 00                	push   $0x0
  pushl $228
c010313c:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103141:	e9 44 01 00 00       	jmp    c010328a <__alltraps>

c0103146 <vector229>:
.globl vector229
vector229:
  pushl $0
c0103146:	6a 00                	push   $0x0
  pushl $229
c0103148:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010314d:	e9 38 01 00 00       	jmp    c010328a <__alltraps>

c0103152 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103152:	6a 00                	push   $0x0
  pushl $230
c0103154:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103159:	e9 2c 01 00 00       	jmp    c010328a <__alltraps>

c010315e <vector231>:
.globl vector231
vector231:
  pushl $0
c010315e:	6a 00                	push   $0x0
  pushl $231
c0103160:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0103165:	e9 20 01 00 00       	jmp    c010328a <__alltraps>

c010316a <vector232>:
.globl vector232
vector232:
  pushl $0
c010316a:	6a 00                	push   $0x0
  pushl $232
c010316c:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103171:	e9 14 01 00 00       	jmp    c010328a <__alltraps>

c0103176 <vector233>:
.globl vector233
vector233:
  pushl $0
c0103176:	6a 00                	push   $0x0
  pushl $233
c0103178:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010317d:	e9 08 01 00 00       	jmp    c010328a <__alltraps>

c0103182 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103182:	6a 00                	push   $0x0
  pushl $234
c0103184:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0103189:	e9 fc 00 00 00       	jmp    c010328a <__alltraps>

c010318e <vector235>:
.globl vector235
vector235:
  pushl $0
c010318e:	6a 00                	push   $0x0
  pushl $235
c0103190:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103195:	e9 f0 00 00 00       	jmp    c010328a <__alltraps>

c010319a <vector236>:
.globl vector236
vector236:
  pushl $0
c010319a:	6a 00                	push   $0x0
  pushl $236
c010319c:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01031a1:	e9 e4 00 00 00       	jmp    c010328a <__alltraps>

c01031a6 <vector237>:
.globl vector237
vector237:
  pushl $0
c01031a6:	6a 00                	push   $0x0
  pushl $237
c01031a8:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01031ad:	e9 d8 00 00 00       	jmp    c010328a <__alltraps>

c01031b2 <vector238>:
.globl vector238
vector238:
  pushl $0
c01031b2:	6a 00                	push   $0x0
  pushl $238
c01031b4:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01031b9:	e9 cc 00 00 00       	jmp    c010328a <__alltraps>

c01031be <vector239>:
.globl vector239
vector239:
  pushl $0
c01031be:	6a 00                	push   $0x0
  pushl $239
c01031c0:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01031c5:	e9 c0 00 00 00       	jmp    c010328a <__alltraps>

c01031ca <vector240>:
.globl vector240
vector240:
  pushl $0
c01031ca:	6a 00                	push   $0x0
  pushl $240
c01031cc:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01031d1:	e9 b4 00 00 00       	jmp    c010328a <__alltraps>

c01031d6 <vector241>:
.globl vector241
vector241:
  pushl $0
c01031d6:	6a 00                	push   $0x0
  pushl $241
c01031d8:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01031dd:	e9 a8 00 00 00       	jmp    c010328a <__alltraps>

c01031e2 <vector242>:
.globl vector242
vector242:
  pushl $0
c01031e2:	6a 00                	push   $0x0
  pushl $242
c01031e4:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01031e9:	e9 9c 00 00 00       	jmp    c010328a <__alltraps>

c01031ee <vector243>:
.globl vector243
vector243:
  pushl $0
c01031ee:	6a 00                	push   $0x0
  pushl $243
c01031f0:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01031f5:	e9 90 00 00 00       	jmp    c010328a <__alltraps>

c01031fa <vector244>:
.globl vector244
vector244:
  pushl $0
c01031fa:	6a 00                	push   $0x0
  pushl $244
c01031fc:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103201:	e9 84 00 00 00       	jmp    c010328a <__alltraps>

c0103206 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103206:	6a 00                	push   $0x0
  pushl $245
c0103208:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010320d:	e9 78 00 00 00       	jmp    c010328a <__alltraps>

c0103212 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103212:	6a 00                	push   $0x0
  pushl $246
c0103214:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103219:	e9 6c 00 00 00       	jmp    c010328a <__alltraps>

c010321e <vector247>:
.globl vector247
vector247:
  pushl $0
c010321e:	6a 00                	push   $0x0
  pushl $247
c0103220:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0103225:	e9 60 00 00 00       	jmp    c010328a <__alltraps>

c010322a <vector248>:
.globl vector248
vector248:
  pushl $0
c010322a:	6a 00                	push   $0x0
  pushl $248
c010322c:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103231:	e9 54 00 00 00       	jmp    c010328a <__alltraps>

c0103236 <vector249>:
.globl vector249
vector249:
  pushl $0
c0103236:	6a 00                	push   $0x0
  pushl $249
c0103238:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010323d:	e9 48 00 00 00       	jmp    c010328a <__alltraps>

c0103242 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103242:	6a 00                	push   $0x0
  pushl $250
c0103244:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103249:	e9 3c 00 00 00       	jmp    c010328a <__alltraps>

c010324e <vector251>:
.globl vector251
vector251:
  pushl $0
c010324e:	6a 00                	push   $0x0
  pushl $251
c0103250:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0103255:	e9 30 00 00 00       	jmp    c010328a <__alltraps>

c010325a <vector252>:
.globl vector252
vector252:
  pushl $0
c010325a:	6a 00                	push   $0x0
  pushl $252
c010325c:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103261:	e9 24 00 00 00       	jmp    c010328a <__alltraps>

c0103266 <vector253>:
.globl vector253
vector253:
  pushl $0
c0103266:	6a 00                	push   $0x0
  pushl $253
c0103268:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010326d:	e9 18 00 00 00       	jmp    c010328a <__alltraps>

c0103272 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103272:	6a 00                	push   $0x0
  pushl $254
c0103274:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0103279:	e9 0c 00 00 00       	jmp    c010328a <__alltraps>

c010327e <vector255>:
.globl vector255
vector255:
  pushl $0
c010327e:	6a 00                	push   $0x0
  pushl $255
c0103280:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103285:	e9 00 00 00 00       	jmp    c010328a <__alltraps>

c010328a <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010328a:	1e                   	push   %ds
    pushl %es
c010328b:	06                   	push   %es
    pushl %fs
c010328c:	0f a0                	push   %fs
    pushl %gs
c010328e:	0f a8                	push   %gs
    pushal
c0103290:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0103291:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0103296:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0103298:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010329a:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010329b:	e8 64 f5 ff ff       	call   c0102804 <trap>

    # pop the pushed stack pointer
    popl %esp
c01032a0:	5c                   	pop    %esp

c01032a1 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01032a1:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01032a2:	0f a9                	pop    %gs
    popl %fs
c01032a4:	0f a1                	pop    %fs
    popl %es
c01032a6:	07                   	pop    %es
    popl %ds
c01032a7:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01032a8:	83 c4 08             	add    $0x8,%esp
    iret
c01032ab:	cf                   	iret   

c01032ac <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01032ac:	55                   	push   %ebp
c01032ad:	89 e5                	mov    %esp,%ebp
c01032af:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01032b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01032b5:	c1 e8 0c             	shr    $0xc,%eax
c01032b8:	89 c2                	mov    %eax,%edx
c01032ba:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01032bf:	39 c2                	cmp    %eax,%edx
c01032c1:	72 1c                	jb     c01032df <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01032c3:	c7 44 24 08 50 9c 10 	movl   $0xc0109c50,0x8(%esp)
c01032ca:	c0 
c01032cb:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01032d2:	00 
c01032d3:	c7 04 24 6f 9c 10 c0 	movl   $0xc0109c6f,(%esp)
c01032da:	e8 23 d1 ff ff       	call   c0100402 <__panic>
    }
    return &pages[PPN(pa)];
c01032df:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c01032e4:	8b 55 08             	mov    0x8(%ebp),%edx
c01032e7:	c1 ea 0c             	shr    $0xc,%edx
c01032ea:	c1 e2 05             	shl    $0x5,%edx
c01032ed:	01 d0                	add    %edx,%eax
}
c01032ef:	c9                   	leave  
c01032f0:	c3                   	ret    

c01032f1 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c01032f1:	55                   	push   %ebp
c01032f2:	89 e5                	mov    %esp,%ebp
c01032f4:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01032f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01032fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01032ff:	89 04 24             	mov    %eax,(%esp)
c0103302:	e8 a5 ff ff ff       	call   c01032ac <pa2page>
}
c0103307:	c9                   	leave  
c0103308:	c3                   	ret    

c0103309 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0103309:	55                   	push   %ebp
c010330a:	89 e5                	mov    %esp,%ebp
c010330c:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c010330f:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0103316:	e8 e9 51 00 00       	call   c0108504 <kmalloc>
c010331b:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c010331e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103322:	74 58                	je     c010337c <mm_create+0x73>
        list_init(&(mm->mmap_list));
c0103324:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103327:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010332a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010332d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103330:	89 50 04             	mov    %edx,0x4(%eax)
c0103333:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103336:	8b 50 04             	mov    0x4(%eax),%edx
c0103339:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010333c:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c010333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103341:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0103348:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010334b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0103352:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103355:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c010335c:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0103361:	85 c0                	test   %eax,%eax
c0103363:	74 0d                	je     c0103372 <mm_create+0x69>
c0103365:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103368:	89 04 24             	mov    %eax,(%esp)
c010336b:	e8 73 0e 00 00       	call   c01041e3 <swap_init_mm>
c0103370:	eb 0a                	jmp    c010337c <mm_create+0x73>
        else mm->sm_priv = NULL;
c0103372:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103375:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c010337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010337f:	c9                   	leave  
c0103380:	c3                   	ret    

c0103381 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)  创建一个vma区域
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0103381:	55                   	push   %ebp
c0103382:	89 e5                	mov    %esp,%ebp
c0103384:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0103387:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c010338e:	e8 71 51 00 00       	call   c0108504 <kmalloc>
c0103393:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0103396:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010339a:	74 1b                	je     c01033b7 <vma_create+0x36>
        vma->vm_start = vm_start;
c010339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010339f:	8b 55 08             	mov    0x8(%ebp),%edx
c01033a2:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033a8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01033ab:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033b1:	8b 55 10             	mov    0x10(%ebp),%edx
c01033b4:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c01033b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01033ba:	c9                   	leave  
c01033bb:	c3                   	ret    

c01033bc <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)  通过地址范围寻址对应的vma
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01033bc:	55                   	push   %ebp
c01033bd:	89 e5                	mov    %esp,%ebp
c01033bf:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c01033c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c01033c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01033cd:	0f 84 95 00 00 00    	je     c0103468 <find_vma+0xac>
        vma = mm->mmap_cache;
c01033d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01033d6:	8b 40 08             	mov    0x8(%eax),%eax
c01033d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c01033dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01033e0:	74 16                	je     c01033f8 <find_vma+0x3c>
c01033e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033e5:	8b 40 04             	mov    0x4(%eax),%eax
c01033e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01033eb:	77 0b                	ja     c01033f8 <find_vma+0x3c>
c01033ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033f0:	8b 40 08             	mov    0x8(%eax),%eax
c01033f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01033f6:	77 61                	ja     c0103459 <find_vma+0x9d>
                bool found = 0;
c01033f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c01033ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103402:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103405:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103408:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c010340b:	eb 28                	jmp    c0103435 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c010340d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103410:	83 e8 10             	sub    $0x10,%eax
c0103413:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0103416:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103419:	8b 40 04             	mov    0x4(%eax),%eax
c010341c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010341f:	77 14                	ja     c0103435 <find_vma+0x79>
c0103421:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103424:	8b 40 08             	mov    0x8(%eax),%eax
c0103427:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010342a:	76 09                	jbe    c0103435 <find_vma+0x79>
                        found = 1;
c010342c:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0103433:	eb 17                	jmp    c010344c <find_vma+0x90>
c0103435:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103438:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010343b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010343e:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0103441:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103444:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103447:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010344a:	75 c1                	jne    c010340d <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c010344c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103450:	75 07                	jne    c0103459 <find_vma+0x9d>
                    vma = NULL;
c0103452:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0103459:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010345d:	74 09                	je     c0103468 <find_vma+0xac>
            mm->mmap_cache = vma;
c010345f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103462:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103465:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0103468:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010346b:	c9                   	leave  
c010346c:	c3                   	ret    

c010346d <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c010346d:	55                   	push   %ebp
c010346e:	89 e5                	mov    %esp,%ebp
c0103470:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0103473:	8b 45 08             	mov    0x8(%ebp),%eax
c0103476:	8b 50 04             	mov    0x4(%eax),%edx
c0103479:	8b 45 08             	mov    0x8(%ebp),%eax
c010347c:	8b 40 08             	mov    0x8(%eax),%eax
c010347f:	39 c2                	cmp    %eax,%edx
c0103481:	72 24                	jb     c01034a7 <check_vma_overlap+0x3a>
c0103483:	c7 44 24 0c 7d 9c 10 	movl   $0xc0109c7d,0xc(%esp)
c010348a:	c0 
c010348b:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103492:	c0 
c0103493:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c010349a:	00 
c010349b:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c01034a2:	e8 5b cf ff ff       	call   c0100402 <__panic>
    assert(prev->vm_end <= next->vm_start);
c01034a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01034aa:	8b 50 08             	mov    0x8(%eax),%edx
c01034ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034b0:	8b 40 04             	mov    0x4(%eax),%eax
c01034b3:	39 c2                	cmp    %eax,%edx
c01034b5:	76 24                	jbe    c01034db <check_vma_overlap+0x6e>
c01034b7:	c7 44 24 0c c0 9c 10 	movl   $0xc0109cc0,0xc(%esp)
c01034be:	c0 
c01034bf:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c01034c6:	c0 
c01034c7:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c01034ce:	00 
c01034cf:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c01034d6:	e8 27 cf ff ff       	call   c0100402 <__panic>
    assert(next->vm_start < next->vm_end);
c01034db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034de:	8b 50 04             	mov    0x4(%eax),%edx
c01034e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034e4:	8b 40 08             	mov    0x8(%eax),%eax
c01034e7:	39 c2                	cmp    %eax,%edx
c01034e9:	72 24                	jb     c010350f <check_vma_overlap+0xa2>
c01034eb:	c7 44 24 0c df 9c 10 	movl   $0xc0109cdf,0xc(%esp)
c01034f2:	c0 
c01034f3:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c01034fa:	c0 
c01034fb:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0103502:	00 
c0103503:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c010350a:	e8 f3 ce ff ff       	call   c0100402 <__panic>
}
c010350f:	90                   	nop
c0103510:	c9                   	leave  
c0103511:	c3                   	ret    

c0103512 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link  向指定的mm插入一个vma
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0103512:	55                   	push   %ebp
c0103513:	89 e5                	mov    %esp,%ebp
c0103515:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0103518:	8b 45 0c             	mov    0xc(%ebp),%eax
c010351b:	8b 50 04             	mov    0x4(%eax),%edx
c010351e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103521:	8b 40 08             	mov    0x8(%eax),%eax
c0103524:	39 c2                	cmp    %eax,%edx
c0103526:	72 24                	jb     c010354c <insert_vma_struct+0x3a>
c0103528:	c7 44 24 0c fd 9c 10 	movl   $0xc0109cfd,0xc(%esp)
c010352f:	c0 
c0103530:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103537:	c0 
c0103538:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010353f:	00 
c0103540:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103547:	e8 b6 ce ff ff       	call   c0100402 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c010354c:	8b 45 08             	mov    0x8(%ebp),%eax
c010354f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0103552:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103555:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0103558:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010355b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c010355e:	eb 1f                	jmp    c010357f <insert_vma_struct+0x6d>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0103560:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103563:	83 e8 10             	sub    $0x10,%eax
c0103566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0103569:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010356c:	8b 50 04             	mov    0x4(%eax),%edx
c010356f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103572:	8b 40 04             	mov    0x4(%eax),%eax
c0103575:	39 c2                	cmp    %eax,%edx
c0103577:	77 1f                	ja     c0103598 <insert_vma_struct+0x86>
                break;
            }
            le_prev = le;
c0103579:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010357c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010357f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103582:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103585:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103588:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c010358b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010358e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103591:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103594:	75 ca                	jne    c0103560 <insert_vma_struct+0x4e>
c0103596:	eb 01                	jmp    c0103599 <insert_vma_struct+0x87>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
                break;
c0103598:	90                   	nop
c0103599:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010359c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010359f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035a2:	8b 40 04             	mov    0x4(%eax),%eax
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c01035a5:	89 45 dc             	mov    %eax,-0x24(%ebp)

    /* check overlap */
    if (le_prev != list) {
c01035a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035ab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01035ae:	74 15                	je     c01035c5 <insert_vma_struct+0xb3>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01035b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035b3:	8d 50 f0             	lea    -0x10(%eax),%edx
c01035b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035b9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01035bd:	89 14 24             	mov    %edx,(%esp)
c01035c0:	e8 a8 fe ff ff       	call   c010346d <check_vma_overlap>
    }
    if (le_next != list) {
c01035c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035c8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01035cb:	74 15                	je     c01035e2 <insert_vma_struct+0xd0>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c01035cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035d0:	83 e8 10             	sub    $0x10,%eax
c01035d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01035d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035da:	89 04 24             	mov    %eax,(%esp)
c01035dd:	e8 8b fe ff ff       	call   c010346d <check_vma_overlap>
    }

    vma->vm_mm = mm;
c01035e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035e5:	8b 55 08             	mov    0x8(%ebp),%edx
c01035e8:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01035ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035ed:	8d 50 10             	lea    0x10(%eax),%edx
c01035f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01035f6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01035f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035fc:	8b 40 04             	mov    0x4(%eax),%eax
c01035ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103602:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0103605:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103608:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010360b:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010360e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103611:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103614:	89 10                	mov    %edx,(%eax)
c0103616:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103619:	8b 10                	mov    (%eax),%edx
c010361b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010361e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103621:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103624:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103627:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010362a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010362d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103630:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0103632:	8b 45 08             	mov    0x8(%ebp),%eax
c0103635:	8b 40 10             	mov    0x10(%eax),%eax
c0103638:	8d 50 01             	lea    0x1(%eax),%edx
c010363b:	8b 45 08             	mov    0x8(%ebp),%eax
c010363e:	89 50 10             	mov    %edx,0x10(%eax)
}
c0103641:	90                   	nop
c0103642:	c9                   	leave  
c0103643:	c3                   	ret    

c0103644 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0103644:	55                   	push   %ebp
c0103645:	89 e5                	mov    %esp,%ebp
c0103647:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c010364a:	8b 45 08             	mov    0x8(%ebp),%eax
c010364d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0103650:	eb 3e                	jmp    c0103690 <mm_destroy+0x4c>
c0103652:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103655:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103658:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010365b:	8b 40 04             	mov    0x4(%eax),%eax
c010365e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0103661:	8b 12                	mov    (%edx),%edx
c0103663:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0103666:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010366c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010366f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103672:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103675:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103678:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c010367a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010367d:	83 e8 10             	sub    $0x10,%eax
c0103680:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0103687:	00 
c0103688:	89 04 24             	mov    %eax,(%esp)
c010368b:	e8 14 4f 00 00       	call   c01085a4 <kfree>
c0103690:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103693:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103696:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103699:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c010369c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010369f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036a5:	75 ab                	jne    c0103652 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c01036a7:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c01036ae:	00 
c01036af:	8b 45 08             	mov    0x8(%ebp),%eax
c01036b2:	89 04 24             	mov    %eax,(%esp)
c01036b5:	e8 ea 4e 00 00       	call   c01085a4 <kfree>
    mm=NULL;
c01036ba:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01036c1:	90                   	nop
c01036c2:	c9                   	leave  
c01036c3:	c3                   	ret    

c01036c4 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c01036c4:	55                   	push   %ebp
c01036c5:	89 e5                	mov    %esp,%ebp
c01036c7:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c01036ca:	e8 03 00 00 00       	call   c01036d2 <check_vmm>
}
c01036cf:	90                   	nop
c01036d0:	c9                   	leave  
c01036d1:	c3                   	ret    

c01036d2 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c01036d2:	55                   	push   %ebp
c01036d3:	89 e5                	mov    %esp,%ebp
c01036d5:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01036d8:	e8 c0 36 00 00       	call   c0106d9d <nr_free_pages>
c01036dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01036e0:	e8 42 00 00 00       	call   c0103727 <check_vma_struct>
    check_pgfault();
c01036e5:	e8 fd 04 00 00       	call   c0103be7 <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c01036ea:	e8 ae 36 00 00       	call   c0106d9d <nr_free_pages>
c01036ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036f2:	74 24                	je     c0103718 <check_vmm+0x46>
c01036f4:	c7 44 24 0c 1c 9d 10 	movl   $0xc0109d1c,0xc(%esp)
c01036fb:	c0 
c01036fc:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103703:	c0 
c0103704:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c010370b:	00 
c010370c:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103713:	e8 ea cc ff ff       	call   c0100402 <__panic>

    cprintf("check_vmm() succeeded.\n");
c0103718:	c7 04 24 43 9d 10 c0 	movl   $0xc0109d43,(%esp)
c010371f:	e8 87 cb ff ff       	call   c01002ab <cprintf>
}
c0103724:	90                   	nop
c0103725:	c9                   	leave  
c0103726:	c3                   	ret    

c0103727 <check_vma_struct>:

static void
check_vma_struct(void) {
c0103727:	55                   	push   %ebp
c0103728:	89 e5                	mov    %esp,%ebp
c010372a:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010372d:	e8 6b 36 00 00       	call   c0106d9d <nr_free_pages>
c0103732:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0103735:	e8 cf fb ff ff       	call   c0103309 <mm_create>
c010373a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c010373d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103741:	75 24                	jne    c0103767 <check_vma_struct+0x40>
c0103743:	c7 44 24 0c 5b 9d 10 	movl   $0xc0109d5b,0xc(%esp)
c010374a:	c0 
c010374b:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103752:	c0 
c0103753:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c010375a:	00 
c010375b:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103762:	e8 9b cc ff ff       	call   c0100402 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0103767:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c010376e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103771:	89 d0                	mov    %edx,%eax
c0103773:	c1 e0 02             	shl    $0x2,%eax
c0103776:	01 d0                	add    %edx,%eax
c0103778:	01 c0                	add    %eax,%eax
c010377a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c010377d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103780:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103783:	eb 6f                	jmp    c01037f4 <check_vma_struct+0xcd>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103785:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103788:	89 d0                	mov    %edx,%eax
c010378a:	c1 e0 02             	shl    $0x2,%eax
c010378d:	01 d0                	add    %edx,%eax
c010378f:	83 c0 02             	add    $0x2,%eax
c0103792:	89 c1                	mov    %eax,%ecx
c0103794:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103797:	89 d0                	mov    %edx,%eax
c0103799:	c1 e0 02             	shl    $0x2,%eax
c010379c:	01 d0                	add    %edx,%eax
c010379e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037a5:	00 
c01037a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01037aa:	89 04 24             	mov    %eax,(%esp)
c01037ad:	e8 cf fb ff ff       	call   c0103381 <vma_create>
c01037b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c01037b5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01037b9:	75 24                	jne    c01037df <check_vma_struct+0xb8>
c01037bb:	c7 44 24 0c 66 9d 10 	movl   $0xc0109d66,0xc(%esp)
c01037c2:	c0 
c01037c3:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c01037ca:	c0 
c01037cb:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c01037d2:	00 
c01037d3:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c01037da:	e8 23 cc ff ff       	call   c0100402 <__panic>
        insert_vma_struct(mm, vma);
c01037df:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037e9:	89 04 24             	mov    %eax,(%esp)
c01037ec:	e8 21 fd ff ff       	call   c0103512 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c01037f1:	ff 4d f4             	decl   -0xc(%ebp)
c01037f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01037f8:	7f 8b                	jg     c0103785 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01037fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037fd:	40                   	inc    %eax
c01037fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103801:	eb 6f                	jmp    c0103872 <check_vma_struct+0x14b>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103803:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103806:	89 d0                	mov    %edx,%eax
c0103808:	c1 e0 02             	shl    $0x2,%eax
c010380b:	01 d0                	add    %edx,%eax
c010380d:	83 c0 02             	add    $0x2,%eax
c0103810:	89 c1                	mov    %eax,%ecx
c0103812:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103815:	89 d0                	mov    %edx,%eax
c0103817:	c1 e0 02             	shl    $0x2,%eax
c010381a:	01 d0                	add    %edx,%eax
c010381c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103823:	00 
c0103824:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103828:	89 04 24             	mov    %eax,(%esp)
c010382b:	e8 51 fb ff ff       	call   c0103381 <vma_create>
c0103830:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0103833:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103837:	75 24                	jne    c010385d <check_vma_struct+0x136>
c0103839:	c7 44 24 0c 66 9d 10 	movl   $0xc0109d66,0xc(%esp)
c0103840:	c0 
c0103841:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103848:	c0 
c0103849:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103850:	00 
c0103851:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103858:	e8 a5 cb ff ff       	call   c0100402 <__panic>
        insert_vma_struct(mm, vma);
c010385d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103860:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103864:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103867:	89 04 24             	mov    %eax,(%esp)
c010386a:	e8 a3 fc ff ff       	call   c0103512 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c010386f:	ff 45 f4             	incl   -0xc(%ebp)
c0103872:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103875:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103878:	7e 89                	jle    c0103803 <check_vma_struct+0xdc>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c010387a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010387d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103880:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103883:	8b 40 04             	mov    0x4(%eax),%eax
c0103886:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0103889:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0103890:	e9 96 00 00 00       	jmp    c010392b <check_vma_struct+0x204>
        assert(le != &(mm->mmap_list));
c0103895:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103898:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010389b:	75 24                	jne    c01038c1 <check_vma_struct+0x19a>
c010389d:	c7 44 24 0c 72 9d 10 	movl   $0xc0109d72,0xc(%esp)
c01038a4:	c0 
c01038a5:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c01038ac:	c0 
c01038ad:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c01038b4:	00 
c01038b5:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c01038bc:	e8 41 cb ff ff       	call   c0100402 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c01038c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038c4:	83 e8 10             	sub    $0x10,%eax
c01038c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c01038ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01038cd:	8b 48 04             	mov    0x4(%eax),%ecx
c01038d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01038d3:	89 d0                	mov    %edx,%eax
c01038d5:	c1 e0 02             	shl    $0x2,%eax
c01038d8:	01 d0                	add    %edx,%eax
c01038da:	39 c1                	cmp    %eax,%ecx
c01038dc:	75 17                	jne    c01038f5 <check_vma_struct+0x1ce>
c01038de:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01038e1:	8b 48 08             	mov    0x8(%eax),%ecx
c01038e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01038e7:	89 d0                	mov    %edx,%eax
c01038e9:	c1 e0 02             	shl    $0x2,%eax
c01038ec:	01 d0                	add    %edx,%eax
c01038ee:	83 c0 02             	add    $0x2,%eax
c01038f1:	39 c1                	cmp    %eax,%ecx
c01038f3:	74 24                	je     c0103919 <check_vma_struct+0x1f2>
c01038f5:	c7 44 24 0c 8c 9d 10 	movl   $0xc0109d8c,0xc(%esp)
c01038fc:	c0 
c01038fd:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103904:	c0 
c0103905:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c010390c:	00 
c010390d:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103914:	e8 e9 ca ff ff       	call   c0100402 <__panic>
c0103919:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010391c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010391f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103922:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0103925:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0103928:	ff 45 f4             	incl   -0xc(%ebp)
c010392b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010392e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103931:	0f 8e 5e ff ff ff    	jle    c0103895 <check_vma_struct+0x16e>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0103937:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c010393e:	e9 cb 01 00 00       	jmp    c0103b0e <check_vma_struct+0x3e7>
        struct vma_struct *vma1 = find_vma(mm, i);
c0103943:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103946:	89 44 24 04          	mov    %eax,0x4(%esp)
c010394a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010394d:	89 04 24             	mov    %eax,(%esp)
c0103950:	e8 67 fa ff ff       	call   c01033bc <find_vma>
c0103955:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma1 != NULL);
c0103958:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010395c:	75 24                	jne    c0103982 <check_vma_struct+0x25b>
c010395e:	c7 44 24 0c c1 9d 10 	movl   $0xc0109dc1,0xc(%esp)
c0103965:	c0 
c0103966:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c010396d:	c0 
c010396e:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0103975:	00 
c0103976:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c010397d:	e8 80 ca ff ff       	call   c0100402 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0103982:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103985:	40                   	inc    %eax
c0103986:	89 44 24 04          	mov    %eax,0x4(%esp)
c010398a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010398d:	89 04 24             	mov    %eax,(%esp)
c0103990:	e8 27 fa ff ff       	call   c01033bc <find_vma>
c0103995:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma2 != NULL);
c0103998:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010399c:	75 24                	jne    c01039c2 <check_vma_struct+0x29b>
c010399e:	c7 44 24 0c ce 9d 10 	movl   $0xc0109dce,0xc(%esp)
c01039a5:	c0 
c01039a6:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c01039ad:	c0 
c01039ae:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01039b5:	00 
c01039b6:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c01039bd:	e8 40 ca ff ff       	call   c0100402 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c01039c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039c5:	83 c0 02             	add    $0x2,%eax
c01039c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01039cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01039cf:	89 04 24             	mov    %eax,(%esp)
c01039d2:	e8 e5 f9 ff ff       	call   c01033bc <find_vma>
c01039d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma3 == NULL);
c01039da:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01039de:	74 24                	je     c0103a04 <check_vma_struct+0x2dd>
c01039e0:	c7 44 24 0c db 9d 10 	movl   $0xc0109ddb,0xc(%esp)
c01039e7:	c0 
c01039e8:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c01039ef:	c0 
c01039f0:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01039f7:	00 
c01039f8:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c01039ff:	e8 fe c9 ff ff       	call   c0100402 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0103a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a07:	83 c0 03             	add    $0x3,%eax
c0103a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a11:	89 04 24             	mov    %eax,(%esp)
c0103a14:	e8 a3 f9 ff ff       	call   c01033bc <find_vma>
c0103a19:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma4 == NULL);
c0103a1c:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0103a20:	74 24                	je     c0103a46 <check_vma_struct+0x31f>
c0103a22:	c7 44 24 0c e8 9d 10 	movl   $0xc0109de8,0xc(%esp)
c0103a29:	c0 
c0103a2a:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103a31:	c0 
c0103a32:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0103a39:	00 
c0103a3a:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103a41:	e8 bc c9 ff ff       	call   c0100402 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0103a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a49:	83 c0 04             	add    $0x4,%eax
c0103a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103a50:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a53:	89 04 24             	mov    %eax,(%esp)
c0103a56:	e8 61 f9 ff ff       	call   c01033bc <find_vma>
c0103a5b:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma5 == NULL);
c0103a5e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103a62:	74 24                	je     c0103a88 <check_vma_struct+0x361>
c0103a64:	c7 44 24 0c f5 9d 10 	movl   $0xc0109df5,0xc(%esp)
c0103a6b:	c0 
c0103a6c:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103a73:	c0 
c0103a74:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103a7b:	00 
c0103a7c:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103a83:	e8 7a c9 ff ff       	call   c0100402 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0103a88:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103a8b:	8b 50 04             	mov    0x4(%eax),%edx
c0103a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a91:	39 c2                	cmp    %eax,%edx
c0103a93:	75 10                	jne    c0103aa5 <check_vma_struct+0x37e>
c0103a95:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103a98:	8b 40 08             	mov    0x8(%eax),%eax
c0103a9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103a9e:	83 c2 02             	add    $0x2,%edx
c0103aa1:	39 d0                	cmp    %edx,%eax
c0103aa3:	74 24                	je     c0103ac9 <check_vma_struct+0x3a2>
c0103aa5:	c7 44 24 0c 04 9e 10 	movl   $0xc0109e04,0xc(%esp)
c0103aac:	c0 
c0103aad:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103ab4:	c0 
c0103ab5:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0103abc:	00 
c0103abd:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103ac4:	e8 39 c9 ff ff       	call   c0100402 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0103ac9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103acc:	8b 50 04             	mov    0x4(%eax),%edx
c0103acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ad2:	39 c2                	cmp    %eax,%edx
c0103ad4:	75 10                	jne    c0103ae6 <check_vma_struct+0x3bf>
c0103ad6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103ad9:	8b 40 08             	mov    0x8(%eax),%eax
c0103adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103adf:	83 c2 02             	add    $0x2,%edx
c0103ae2:	39 d0                	cmp    %edx,%eax
c0103ae4:	74 24                	je     c0103b0a <check_vma_struct+0x3e3>
c0103ae6:	c7 44 24 0c 34 9e 10 	movl   $0xc0109e34,0xc(%esp)
c0103aed:	c0 
c0103aee:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103af5:	c0 
c0103af6:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0103afd:	00 
c0103afe:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103b05:	e8 f8 c8 ff ff       	call   c0100402 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0103b0a:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0103b0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103b11:	89 d0                	mov    %edx,%eax
c0103b13:	c1 e0 02             	shl    $0x2,%eax
c0103b16:	01 d0                	add    %edx,%eax
c0103b18:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103b1b:	0f 8d 22 fe ff ff    	jge    c0103943 <check_vma_struct+0x21c>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0103b21:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0103b28:	eb 6f                	jmp    c0103b99 <check_vma_struct+0x472>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0103b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103b31:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b34:	89 04 24             	mov    %eax,(%esp)
c0103b37:	e8 80 f8 ff ff       	call   c01033bc <find_vma>
c0103b3c:	89 45 b8             	mov    %eax,-0x48(%ebp)
        if (vma_below_5 != NULL ) {
c0103b3f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103b43:	74 27                	je     c0103b6c <check_vma_struct+0x445>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0103b45:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103b48:	8b 50 08             	mov    0x8(%eax),%edx
c0103b4b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103b4e:	8b 40 04             	mov    0x4(%eax),%eax
c0103b51:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0103b55:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103b60:	c7 04 24 64 9e 10 c0 	movl   $0xc0109e64,(%esp)
c0103b67:	e8 3f c7 ff ff       	call   c01002ab <cprintf>
        }
        assert(vma_below_5 == NULL);
c0103b6c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103b70:	74 24                	je     c0103b96 <check_vma_struct+0x46f>
c0103b72:	c7 44 24 0c 89 9e 10 	movl   $0xc0109e89,0xc(%esp)
c0103b79:	c0 
c0103b7a:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103b81:	c0 
c0103b82:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103b89:	00 
c0103b8a:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103b91:	e8 6c c8 ff ff       	call   c0100402 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0103b96:	ff 4d f4             	decl   -0xc(%ebp)
c0103b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b9d:	79 8b                	jns    c0103b2a <check_vma_struct+0x403>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0103b9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ba2:	89 04 24             	mov    %eax,(%esp)
c0103ba5:	e8 9a fa ff ff       	call   c0103644 <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c0103baa:	e8 ee 31 00 00       	call   c0106d9d <nr_free_pages>
c0103baf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103bb2:	74 24                	je     c0103bd8 <check_vma_struct+0x4b1>
c0103bb4:	c7 44 24 0c 1c 9d 10 	movl   $0xc0109d1c,0xc(%esp)
c0103bbb:	c0 
c0103bbc:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103bc3:	c0 
c0103bc4:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103bcb:	00 
c0103bcc:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103bd3:	e8 2a c8 ff ff       	call   c0100402 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0103bd8:	c7 04 24 a0 9e 10 c0 	movl   $0xc0109ea0,(%esp)
c0103bdf:	e8 c7 c6 ff ff       	call   c01002ab <cprintf>
}
c0103be4:	90                   	nop
c0103be5:	c9                   	leave  
c0103be6:	c3                   	ret    

c0103be7 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0103be7:	55                   	push   %ebp
c0103be8:	89 e5                	mov    %esp,%ebp
c0103bea:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103bed:	e8 ab 31 00 00       	call   c0106d9d <nr_free_pages>
c0103bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0103bf5:	e8 0f f7 ff ff       	call   c0103309 <mm_create>
c0103bfa:	a3 10 50 12 c0       	mov    %eax,0xc0125010
    assert(check_mm_struct != NULL);
c0103bff:	a1 10 50 12 c0       	mov    0xc0125010,%eax
c0103c04:	85 c0                	test   %eax,%eax
c0103c06:	75 24                	jne    c0103c2c <check_pgfault+0x45>
c0103c08:	c7 44 24 0c bf 9e 10 	movl   $0xc0109ebf,0xc(%esp)
c0103c0f:	c0 
c0103c10:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103c17:	c0 
c0103c18:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103c1f:	00 
c0103c20:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103c27:	e8 d6 c7 ff ff       	call   c0100402 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0103c2c:	a1 10 50 12 c0       	mov    0xc0125010,%eax
c0103c31:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0103c34:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0103c3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c3d:	89 50 0c             	mov    %edx,0xc(%eax)
c0103c40:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c43:	8b 40 0c             	mov    0xc(%eax),%eax
c0103c46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0103c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c4c:	8b 00                	mov    (%eax),%eax
c0103c4e:	85 c0                	test   %eax,%eax
c0103c50:	74 24                	je     c0103c76 <check_pgfault+0x8f>
c0103c52:	c7 44 24 0c d7 9e 10 	movl   $0xc0109ed7,0xc(%esp)
c0103c59:	c0 
c0103c5a:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103c61:	c0 
c0103c62:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103c69:	00 
c0103c6a:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103c71:	e8 8c c7 ff ff       	call   c0100402 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0103c76:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0103c7d:	00 
c0103c7e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0103c85:	00 
c0103c86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0103c8d:	e8 ef f6 ff ff       	call   c0103381 <vma_create>
c0103c92:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0103c95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103c99:	75 24                	jne    c0103cbf <check_pgfault+0xd8>
c0103c9b:	c7 44 24 0c 66 9d 10 	movl   $0xc0109d66,0xc(%esp)
c0103ca2:	c0 
c0103ca3:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103caa:	c0 
c0103cab:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103cb2:	00 
c0103cb3:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103cba:	e8 43 c7 ff ff       	call   c0100402 <__panic>

    insert_vma_struct(mm, vma);
c0103cbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103cc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cc9:	89 04 24             	mov    %eax,(%esp)
c0103ccc:	e8 41 f8 ff ff       	call   c0103512 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0103cd1:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0103cd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ce2:	89 04 24             	mov    %eax,(%esp)
c0103ce5:	e8 d2 f6 ff ff       	call   c01033bc <find_vma>
c0103cea:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103ced:	74 24                	je     c0103d13 <check_pgfault+0x12c>
c0103cef:	c7 44 24 0c e5 9e 10 	movl   $0xc0109ee5,0xc(%esp)
c0103cf6:	c0 
c0103cf7:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103cfe:	c0 
c0103cff:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103d06:	00 
c0103d07:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103d0e:	e8 ef c6 ff ff       	call   c0100402 <__panic>

    int i, sum = 0;
c0103d13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0103d1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103d21:	eb 16                	jmp    c0103d39 <check_pgfault+0x152>
        *(char *)(addr + i) = i;
c0103d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d26:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d29:	01 d0                	add    %edx,%eax
c0103d2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d2e:	88 10                	mov    %dl,(%eax)
        sum += i;
c0103d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d33:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0103d36:	ff 45 f4             	incl   -0xc(%ebp)
c0103d39:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0103d3d:	7e e4                	jle    c0103d23 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0103d3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103d46:	eb 14                	jmp    c0103d5c <check_pgfault+0x175>
        sum -= *(char *)(addr + i);
c0103d48:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d4e:	01 d0                	add    %edx,%eax
c0103d50:	0f b6 00             	movzbl (%eax),%eax
c0103d53:	0f be c0             	movsbl %al,%eax
c0103d56:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0103d59:	ff 45 f4             	incl   -0xc(%ebp)
c0103d5c:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0103d60:	7e e6                	jle    c0103d48 <check_pgfault+0x161>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0103d62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103d66:	74 24                	je     c0103d8c <check_pgfault+0x1a5>
c0103d68:	c7 44 24 0c ff 9e 10 	movl   $0xc0109eff,0xc(%esp)
c0103d6f:	c0 
c0103d70:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103d77:	c0 
c0103d78:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0103d7f:	00 
c0103d80:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103d87:	e8 76 c6 ff ff       	call   c0100402 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0103d8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103d92:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103d95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103da1:	89 04 24             	mov    %eax,(%esp)
c0103da4:	e8 8e 38 00 00       	call   c0107637 <page_remove>
    free_page(pde2page(pgdir[0]));
c0103da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dac:	8b 00                	mov    (%eax),%eax
c0103dae:	89 04 24             	mov    %eax,(%esp)
c0103db1:	e8 3b f5 ff ff       	call   c01032f1 <pde2page>
c0103db6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103dbd:	00 
c0103dbe:	89 04 24             	mov    %eax,(%esp)
c0103dc1:	e8 a4 2f 00 00       	call   c0106d6a <free_pages>
    pgdir[0] = 0;
c0103dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0103dcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103dd2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0103dd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ddc:	89 04 24             	mov    %eax,(%esp)
c0103ddf:	e8 60 f8 ff ff       	call   c0103644 <mm_destroy>
    check_mm_struct = NULL;
c0103de4:	c7 05 10 50 12 c0 00 	movl   $0x0,0xc0125010
c0103deb:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0103dee:	e8 aa 2f 00 00       	call   c0106d9d <nr_free_pages>
c0103df3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103df6:	74 24                	je     c0103e1c <check_pgfault+0x235>
c0103df8:	c7 44 24 0c 1c 9d 10 	movl   $0xc0109d1c,0xc(%esp)
c0103dff:	c0 
c0103e00:	c7 44 24 08 9b 9c 10 	movl   $0xc0109c9b,0x8(%esp)
c0103e07:	c0 
c0103e08:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0103e0f:	00 
c0103e10:	c7 04 24 b0 9c 10 c0 	movl   $0xc0109cb0,(%esp)
c0103e17:	e8 e6 c5 ff ff       	call   c0100402 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0103e1c:	c7 04 24 08 9f 10 c0 	movl   $0xc0109f08,(%esp)
c0103e23:	e8 83 c4 ff ff       	call   c01002ab <cprintf>
}
c0103e28:	90                   	nop
c0103e29:	c9                   	leave  
c0103e2a:	c3                   	ret    

c0103e2b <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)    idx_2表示当前处于内核态还是用户态
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0103e2b:	55                   	push   %ebp
c0103e2c:	89 e5                	mov    %esp,%ebp
c0103e2e:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0103e31:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0103e38:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103e3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e42:	89 04 24             	mov    %eax,(%esp)
c0103e45:	e8 72 f5 ff ff       	call   c01033bc <find_vma>
c0103e4a:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0103e4d:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0103e52:	40                   	inc    %eax
c0103e53:	a3 64 4f 12 c0       	mov    %eax,0xc0124f64
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0103e58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103e5c:	74 0b                	je     c0103e69 <do_pgfault+0x3e>
c0103e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e61:	8b 40 04             	mov    0x4(%eax),%eax
c0103e64:	3b 45 10             	cmp    0x10(%ebp),%eax
c0103e67:	76 18                	jbe    c0103e81 <do_pgfault+0x56>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0103e69:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103e70:	c7 04 24 24 9f 10 c0 	movl   $0xc0109f24,(%esp)
c0103e77:	e8 2f c4 ff ff       	call   c01002ab <cprintf>
        goto failed;
c0103e7c:	e9 cd 01 00 00       	jmp    c010404e <do_pgfault+0x223>
    }
    //check the error_code
    switch (error_code & 3) {
c0103e81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103e84:	83 e0 03             	and    $0x3,%eax
c0103e87:	83 f8 01             	cmp    $0x1,%eax
c0103e8a:	74 39                	je     c0103ec5 <do_pgfault+0x9a>
c0103e8c:	83 f8 01             	cmp    $0x1,%eax
c0103e8f:	72 45                	jb     c0103ed6 <do_pgfault+0xab>
c0103e91:	83 f8 02             	cmp    $0x2,%eax
c0103e94:	74 11                	je     c0103ea7 <do_pgfault+0x7c>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present mine*/
            cprintf("operation not allowed\n");
c0103e96:	c7 04 24 54 9f 10 c0 	movl   $0xc0109f54,(%esp)
c0103e9d:	e8 09 c4 ff ff       	call   c01002ab <cprintf>
            goto failed;
c0103ea2:	e9 a7 01 00 00       	jmp    c010404e <do_pgfault+0x223>
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0103ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103eaa:	8b 40 0c             	mov    0xc(%eax),%eax
c0103ead:	83 e0 02             	and    $0x2,%eax
c0103eb0:	85 c0                	test   %eax,%eax
c0103eb2:	75 40                	jne    c0103ef4 <do_pgfault+0xc9>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0103eb4:	c7 04 24 6c 9f 10 c0 	movl   $0xc0109f6c,(%esp)
c0103ebb:	e8 eb c3 ff ff       	call   c01002ab <cprintf>
            goto failed;
c0103ec0:	e9 89 01 00 00       	jmp    c010404e <do_pgfault+0x223>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0103ec5:	c7 04 24 cc 9f 10 c0 	movl   $0xc0109fcc,(%esp)
c0103ecc:	e8 da c3 ff ff       	call   c01002ab <cprintf>
        goto failed;
c0103ed1:	e9 78 01 00 00       	jmp    c010404e <do_pgfault+0x223>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0103ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ed9:	8b 40 0c             	mov    0xc(%eax),%eax
c0103edc:	83 e0 05             	and    $0x5,%eax
c0103edf:	85 c0                	test   %eax,%eax
c0103ee1:	75 12                	jne    c0103ef5 <do_pgfault+0xca>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0103ee3:	c7 04 24 04 a0 10 c0 	movl   $0xc010a004,(%esp)
c0103eea:	e8 bc c3 ff ff       	call   c01002ab <cprintf>
            goto failed;
c0103eef:	e9 5a 01 00 00       	jmp    c010404e <do_pgfault+0x223>
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
c0103ef4:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0103ef5:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0103efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103eff:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f02:	83 e0 02             	and    $0x2,%eax
c0103f05:	85 c0                	test   %eax,%eax
c0103f07:	74 04                	je     c0103f0d <do_pgfault+0xe2>
        perm |= PTE_W;
c0103f09:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0103f0d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f10:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103f13:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103f1b:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0103f1e:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0103f25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    // }else{
    //     /*pte不等于0说明该页在磁盘*/
    //     cprintf("FIFO: *pte ===> 0x%08x\n", *ptep);
        
    // }
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL){
c0103f2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f2f:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f32:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103f39:	00 
c0103f3a:	8b 55 10             	mov    0x10(%ebp),%edx
c0103f3d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f41:	89 04 24             	mov    %eax,(%esp)
c0103f44:	e8 83 34 00 00       	call   c01073cc <get_pte>
c0103f49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103f4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f50:	75 11                	jne    c0103f63 <do_pgfault+0x138>
        cprintf("get_pte in do_pgfualt failed\n");
c0103f52:	c7 04 24 67 a0 10 c0 	movl   $0xc010a067,(%esp)
c0103f59:	e8 4d c3 ff ff       	call   c01002ab <cprintf>
        goto failed;
c0103f5e:	e9 eb 00 00 00       	jmp    c010404e <do_pgfault+0x223>
    }
    /*没有分配物理页*/
    if(*ptep == 0){
c0103f63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f66:	8b 00                	mov    (%eax),%eax
c0103f68:	85 c0                	test   %eax,%eax
c0103f6a:	75 3a                	jne    c0103fa6 <do_pgfault+0x17b>
        /*alloc page 这里pgdir_alloc_page会自动将该页加入swapable链*/
        if(pgdir_alloc_page(mm->pgdir, addr, perm | PTE_P) == 0){
c0103f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f6f:	83 c8 01             	or     $0x1,%eax
c0103f72:	89 c2                	mov    %eax,%edx
c0103f74:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f77:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f7a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0103f7e:	8b 55 10             	mov    0x10(%ebp),%edx
c0103f81:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f85:	89 04 24             	mov    %eax,(%esp)
c0103f88:	e8 04 38 00 00       	call   c0107791 <pgdir_alloc_page>
c0103f8d:	85 c0                	test   %eax,%eax
c0103f8f:	0f 85 b2 00 00 00    	jne    c0104047 <do_pgfault+0x21c>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
c0103f95:	c7 04 24 88 a0 10 c0 	movl   $0xc010a088,(%esp)
c0103f9c:	e8 0a c3 ff ff       	call   c01002ab <cprintf>
            goto failed;
c0103fa1:	e9 a8 00 00 00       	jmp    c010404e <do_pgfault+0x223>
        }
    }else{
        /*页在磁盘中*/
        if (swap_init_ok){      //swap初始化完成
c0103fa6:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0103fab:	85 c0                	test   %eax,%eax
c0103fad:	0f 84 86 00 00 00    	je     c0104039 <do_pgfault+0x20e>
            struct Page *page = NULL;
c0103fb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            /*读入一个页中 该物理页可能是尚未分配的物理页，也可能是从别的已分配物理页中取的*/
            if((ret = swap_in(mm, addr, &page)) != 0){
c0103fba:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0103fbd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103fc1:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fc4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103fc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fcb:	89 04 24             	mov    %eax,(%esp)
c0103fce:	e8 28 04 00 00       	call   c01043fb <swap_in>
c0103fd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103fd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103fda:	74 0e                	je     c0103fea <do_pgfault+0x1bf>
                cprintf("swap_in in do_pgfault failed\n");
c0103fdc:	c7 04 24 af a0 10 c0 	movl   $0xc010a0af,(%esp)
c0103fe3:	e8 c3 c2 ff ff       	call   c01002ab <cprintf>
c0103fe8:	eb 64                	jmp    c010404e <do_pgfault+0x223>
                goto failed;
            }
            /*页表，设置虚拟地址和物理地址映射关系*/
            page_insert(mm->pgdir, page, addr, perm);
c0103fea:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103fed:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ff0:	8b 40 0c             	mov    0xc(%eax),%eax
c0103ff3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0103ff6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0103ffa:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0103ffd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104001:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104005:	89 04 24             	mov    %eax,(%esp)
c0104008:	e8 6f 36 00 00       	call   c010767c <page_insert>
            /*设置该页为swapable*/
            swap_map_swappable(mm, addr, page, 1);
c010400d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104010:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0104017:	00 
c0104018:	89 44 24 08          	mov    %eax,0x8(%esp)
c010401c:	8b 45 10             	mov    0x10(%ebp),%eax
c010401f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104023:	8b 45 08             	mov    0x8(%ebp),%eax
c0104026:	89 04 24             	mov    %eax,(%esp)
c0104029:	e8 e5 01 00 00       	call   c0104213 <swap_map_swappable>
            page->pra_vaddr = addr;
c010402e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104031:	8b 55 10             	mov    0x10(%ebp),%edx
c0104034:	89 50 1c             	mov    %edx,0x1c(%eax)
c0104037:	eb 0e                	jmp    c0104047 <do_pgfault+0x21c>
        }
        else{
            cprintf("swap_init is not ready\n");
c0104039:	c7 04 24 cd a0 10 c0 	movl   $0xc010a0cd,(%esp)
c0104040:	e8 66 c2 ff ff       	call   c01002ab <cprintf>
            goto failed;
c0104045:	eb 07                	jmp    c010404e <do_pgfault+0x223>
        }
    }
    ret = 0;
c0104047:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c010404e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104051:	c9                   	leave  
c0104052:	c3                   	ret    

c0104053 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104053:	55                   	push   %ebp
c0104054:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104056:	8b 45 08             	mov    0x8(%ebp),%eax
c0104059:	8b 15 00 51 12 c0    	mov    0xc0125100,%edx
c010405f:	29 d0                	sub    %edx,%eax
c0104061:	c1 f8 05             	sar    $0x5,%eax
}
c0104064:	5d                   	pop    %ebp
c0104065:	c3                   	ret    

c0104066 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104066:	55                   	push   %ebp
c0104067:	89 e5                	mov    %esp,%ebp
c0104069:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010406c:	8b 45 08             	mov    0x8(%ebp),%eax
c010406f:	89 04 24             	mov    %eax,(%esp)
c0104072:	e8 dc ff ff ff       	call   c0104053 <page2ppn>
c0104077:	c1 e0 0c             	shl    $0xc,%eax
}
c010407a:	c9                   	leave  
c010407b:	c3                   	ret    

c010407c <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010407c:	55                   	push   %ebp
c010407d:	89 e5                	mov    %esp,%ebp
c010407f:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104082:	8b 45 08             	mov    0x8(%ebp),%eax
c0104085:	c1 e8 0c             	shr    $0xc,%eax
c0104088:	89 c2                	mov    %eax,%edx
c010408a:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c010408f:	39 c2                	cmp    %eax,%edx
c0104091:	72 1c                	jb     c01040af <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104093:	c7 44 24 08 e8 a0 10 	movl   $0xc010a0e8,0x8(%esp)
c010409a:	c0 
c010409b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01040a2:	00 
c01040a3:	c7 04 24 07 a1 10 c0 	movl   $0xc010a107,(%esp)
c01040aa:	e8 53 c3 ff ff       	call   c0100402 <__panic>
    }
    return &pages[PPN(pa)];
c01040af:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c01040b4:	8b 55 08             	mov    0x8(%ebp),%edx
c01040b7:	c1 ea 0c             	shr    $0xc,%edx
c01040ba:	c1 e2 05             	shl    $0x5,%edx
c01040bd:	01 d0                	add    %edx,%eax
}
c01040bf:	c9                   	leave  
c01040c0:	c3                   	ret    

c01040c1 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01040c1:	55                   	push   %ebp
c01040c2:	89 e5                	mov    %esp,%ebp
c01040c4:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01040c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01040ca:	89 04 24             	mov    %eax,(%esp)
c01040cd:	e8 94 ff ff ff       	call   c0104066 <page2pa>
c01040d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01040d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040d8:	c1 e8 0c             	shr    $0xc,%eax
c01040db:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01040de:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01040e3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01040e6:	72 23                	jb     c010410b <page2kva+0x4a>
c01040e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040ef:	c7 44 24 08 18 a1 10 	movl   $0xc010a118,0x8(%esp)
c01040f6:	c0 
c01040f7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01040fe:	00 
c01040ff:	c7 04 24 07 a1 10 c0 	movl   $0xc010a107,(%esp)
c0104106:	e8 f7 c2 ff ff       	call   c0100402 <__panic>
c010410b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010410e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104113:	c9                   	leave  
c0104114:	c3                   	ret    

c0104115 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104115:	55                   	push   %ebp
c0104116:	89 e5                	mov    %esp,%ebp
c0104118:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c010411b:	8b 45 08             	mov    0x8(%ebp),%eax
c010411e:	83 e0 01             	and    $0x1,%eax
c0104121:	85 c0                	test   %eax,%eax
c0104123:	75 1c                	jne    c0104141 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104125:	c7 44 24 08 3c a1 10 	movl   $0xc010a13c,0x8(%esp)
c010412c:	c0 
c010412d:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0104134:	00 
c0104135:	c7 04 24 07 a1 10 c0 	movl   $0xc010a107,(%esp)
c010413c:	e8 c1 c2 ff ff       	call   c0100402 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104141:	8b 45 08             	mov    0x8(%ebp),%eax
c0104144:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104149:	89 04 24             	mov    %eax,(%esp)
c010414c:	e8 2b ff ff ff       	call   c010407c <pa2page>
}
c0104151:	c9                   	leave  
c0104152:	c3                   	ret    

c0104153 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0104153:	55                   	push   %ebp
c0104154:	89 e5                	mov    %esp,%ebp
c0104156:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0104159:	e8 5e 45 00 00       	call   c01086bc <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c010415e:	a1 bc 50 12 c0       	mov    0xc01250bc,%eax
c0104163:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0104168:	76 0c                	jbe    c0104176 <swap_init+0x23>
c010416a:	a1 bc 50 12 c0       	mov    0xc01250bc,%eax
c010416f:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0104174:	76 25                	jbe    c010419b <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0104176:	a1 bc 50 12 c0       	mov    0xc01250bc,%eax
c010417b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010417f:	c7 44 24 08 5d a1 10 	movl   $0xc010a15d,0x8(%esp)
c0104186:	c0 
c0104187:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c010418e:	00 
c010418f:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104196:	e8 67 c2 ff ff       	call   c0100402 <__panic>
     }
     

     sm = &swap_manager_fifo;
c010419b:	c7 05 70 4f 12 c0 00 	movl   $0xc0121a00,0xc0124f70
c01041a2:	1a 12 c0 
     int r = sm->init();
c01041a5:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c01041aa:	8b 40 04             	mov    0x4(%eax),%eax
c01041ad:	ff d0                	call   *%eax
c01041af:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01041b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01041b6:	75 26                	jne    c01041de <swap_init+0x8b>
     {
          swap_init_ok = 1;
c01041b8:	c7 05 68 4f 12 c0 01 	movl   $0x1,0xc0124f68
c01041bf:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01041c2:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c01041c7:	8b 00                	mov    (%eax),%eax
c01041c9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01041cd:	c7 04 24 87 a1 10 c0 	movl   $0xc010a187,(%esp)
c01041d4:	e8 d2 c0 ff ff       	call   c01002ab <cprintf>
          check_swap();
c01041d9:	e8 c4 04 00 00       	call   c01046a2 <check_swap>
     }

     return r;
c01041de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01041e1:	c9                   	leave  
c01041e2:	c3                   	ret    

c01041e3 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c01041e3:	55                   	push   %ebp
c01041e4:	89 e5                	mov    %esp,%ebp
c01041e6:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c01041e9:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c01041ee:	8b 40 08             	mov    0x8(%eax),%eax
c01041f1:	8b 55 08             	mov    0x8(%ebp),%edx
c01041f4:	89 14 24             	mov    %edx,(%esp)
c01041f7:	ff d0                	call   *%eax
}
c01041f9:	c9                   	leave  
c01041fa:	c3                   	ret    

c01041fb <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c01041fb:	55                   	push   %ebp
c01041fc:	89 e5                	mov    %esp,%ebp
c01041fe:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0104201:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104206:	8b 40 0c             	mov    0xc(%eax),%eax
c0104209:	8b 55 08             	mov    0x8(%ebp),%edx
c010420c:	89 14 24             	mov    %edx,(%esp)
c010420f:	ff d0                	call   *%eax
}
c0104211:	c9                   	leave  
c0104212:	c3                   	ret    

c0104213 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0104213:	55                   	push   %ebp
c0104214:	89 e5                	mov    %esp,%ebp
c0104216:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0104219:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c010421e:	8b 40 10             	mov    0x10(%eax),%eax
c0104221:	8b 55 14             	mov    0x14(%ebp),%edx
c0104224:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0104228:	8b 55 10             	mov    0x10(%ebp),%edx
c010422b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010422f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104232:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104236:	8b 55 08             	mov    0x8(%ebp),%edx
c0104239:	89 14 24             	mov    %edx,(%esp)
c010423c:	ff d0                	call   *%eax
}
c010423e:	c9                   	leave  
c010423f:	c3                   	ret    

c0104240 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0104240:	55                   	push   %ebp
c0104241:	89 e5                	mov    %esp,%ebp
c0104243:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0104246:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c010424b:	8b 40 14             	mov    0x14(%eax),%eax
c010424e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104251:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104255:	8b 55 08             	mov    0x8(%ebp),%edx
c0104258:	89 14 24             	mov    %edx,(%esp)
c010425b:	ff d0                	call   *%eax
}
c010425d:	c9                   	leave  
c010425e:	c3                   	ret    

c010425f <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c010425f:	55                   	push   %ebp
c0104260:	89 e5                	mov    %esp,%ebp
c0104262:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0104265:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010426c:	e9 79 01 00 00       	jmp    c01043ea <swap_out+0x18b>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0104271:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104276:	8b 40 18             	mov    0x18(%eax),%eax
c0104279:	8b 55 10             	mov    0x10(%ebp),%edx
c010427c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104280:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0104283:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104287:	8b 55 08             	mov    0x8(%ebp),%edx
c010428a:	89 14 24             	mov    %edx,(%esp)
c010428d:	ff d0                	call   *%eax
c010428f:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0104292:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104296:	74 18                	je     c01042b0 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0104298:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010429b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010429f:	c7 04 24 9c a1 10 c0 	movl   $0xc010a19c,(%esp)
c01042a6:	e8 00 c0 ff ff       	call   c01002ab <cprintf>
c01042ab:	e9 46 01 00 00       	jmp    c01043f6 <swap_out+0x197>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c01042b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042b3:	8b 40 1c             	mov    0x1c(%eax),%eax
c01042b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c01042b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01042bc:	8b 40 0c             	mov    0xc(%eax),%eax
c01042bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01042c6:	00 
c01042c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01042ca:	89 54 24 04          	mov    %edx,0x4(%esp)
c01042ce:	89 04 24             	mov    %eax,(%esp)
c01042d1:	e8 f6 30 00 00       	call   c01073cc <get_pte>
c01042d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01042d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042dc:	8b 00                	mov    (%eax),%eax
c01042de:	83 e0 01             	and    $0x1,%eax
c01042e1:	85 c0                	test   %eax,%eax
c01042e3:	75 24                	jne    c0104309 <swap_out+0xaa>
c01042e5:	c7 44 24 0c c9 a1 10 	movl   $0xc010a1c9,0xc(%esp)
c01042ec:	c0 
c01042ed:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c01042f4:	c0 
c01042f5:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01042fc:	00 
c01042fd:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104304:	e8 f9 c0 ff ff       	call   c0100402 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0104309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010430c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010430f:	8b 52 1c             	mov    0x1c(%edx),%edx
c0104312:	c1 ea 0c             	shr    $0xc,%edx
c0104315:	42                   	inc    %edx
c0104316:	c1 e2 08             	shl    $0x8,%edx
c0104319:	89 44 24 04          	mov    %eax,0x4(%esp)
c010431d:	89 14 24             	mov    %edx,(%esp)
c0104320:	e8 52 44 00 00       	call   c0108777 <swapfs_write>
c0104325:	85 c0                	test   %eax,%eax
c0104327:	74 37                	je     c0104360 <swap_out+0x101>
                    cprintf("SWAP: failed to save\n");
c0104329:	c7 04 24 f3 a1 10 c0 	movl   $0xc010a1f3,(%esp)
c0104330:	e8 76 bf ff ff       	call   c01002ab <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0104335:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c010433a:	8b 40 10             	mov    0x10(%eax),%eax
c010433d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104340:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104347:	00 
c0104348:	89 54 24 08          	mov    %edx,0x8(%esp)
c010434c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010434f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104353:	8b 55 08             	mov    0x8(%ebp),%edx
c0104356:	89 14 24             	mov    %edx,(%esp)
c0104359:	ff d0                	call   *%eax
c010435b:	e9 87 00 00 00       	jmp    c01043e7 <swap_out+0x188>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0104360:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104363:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104366:	c1 e8 0c             	shr    $0xc,%eax
c0104369:	40                   	inc    %eax
c010436a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010436e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104371:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104375:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104378:	89 44 24 04          	mov    %eax,0x4(%esp)
c010437c:	c7 04 24 0c a2 10 c0 	movl   $0xc010a20c,(%esp)
c0104383:	e8 23 bf ff ff       	call   c01002ab <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0104388:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010438b:	8b 40 1c             	mov    0x1c(%eax),%eax
c010438e:	c1 e8 0c             	shr    $0xc,%eax
c0104391:	40                   	inc    %eax
c0104392:	c1 e0 08             	shl    $0x8,%eax
c0104395:	89 c2                	mov    %eax,%edx
c0104397:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010439a:	89 10                	mov    %edx,(%eax)
                    memset(page2kva(page), 0, PGSIZE);
c010439c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010439f:	89 04 24             	mov    %eax,(%esp)
c01043a2:	e8 1a fd ff ff       	call   c01040c1 <page2kva>
c01043a7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01043ae:	00 
c01043af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01043b6:	00 
c01043b7:	89 04 24             	mov    %eax,(%esp)
c01043ba:	e8 4a 47 00 00       	call   c0108b09 <memset>
                    free_page(page);
c01043bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043c2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043c9:	00 
c01043ca:	89 04 24             	mov    %eax,(%esp)
c01043cd:	e8 98 29 00 00       	call   c0106d6a <free_pages>

          }
          
          tlb_invalidate(mm->pgdir, v);
c01043d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01043d5:	8b 40 0c             	mov    0xc(%eax),%eax
c01043d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01043db:	89 54 24 04          	mov    %edx,0x4(%esp)
c01043df:	89 04 24             	mov    %eax,(%esp)
c01043e2:	e8 4e 33 00 00       	call   c0107735 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c01043e7:	ff 45 f4             	incl   -0xc(%ebp)
c01043ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01043f0:	0f 85 7b fe ff ff    	jne    c0104271 <swap_out+0x12>

          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c01043f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01043f9:	c9                   	leave  
c01043fa:	c3                   	ret    

c01043fb <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01043fb:	55                   	push   %ebp
c01043fc:	89 e5                	mov    %esp,%ebp
c01043fe:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0104401:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104408:	e8 d8 28 00 00       	call   c0106ce5 <alloc_pages>
c010440d:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0104410:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104414:	75 24                	jne    c010443a <swap_in+0x3f>
c0104416:	c7 44 24 0c 4c a2 10 	movl   $0xc010a24c,0xc(%esp)
c010441d:	c0 
c010441e:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104425:	c0 
c0104426:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c010442d:	00 
c010442e:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104435:	e8 c8 bf ff ff       	call   c0100402 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c010443a:	8b 45 08             	mov    0x8(%ebp),%eax
c010443d:	8b 40 0c             	mov    0xc(%eax),%eax
c0104440:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104447:	00 
c0104448:	8b 55 0c             	mov    0xc(%ebp),%edx
c010444b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010444f:	89 04 24             	mov    %eax,(%esp)
c0104452:	e8 75 2f 00 00       	call   c01073cc <get_pte>
c0104457:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c010445a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010445d:	8b 00                	mov    (%eax),%eax
c010445f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104462:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104466:	89 04 24             	mov    %eax,(%esp)
c0104469:	e8 97 42 00 00       	call   c0108705 <swapfs_read>
c010446e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104471:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104475:	74 2a                	je     c01044a1 <swap_in+0xa6>
     {
        assert(r!=0);
c0104477:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010447b:	75 24                	jne    c01044a1 <swap_in+0xa6>
c010447d:	c7 44 24 0c 59 a2 10 	movl   $0xc010a259,0xc(%esp)
c0104484:	c0 
c0104485:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c010448c:	c0 
c010448d:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
c0104494:	00 
c0104495:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c010449c:	e8 61 bf ff ff       	call   c0100402 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01044a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044a4:	8b 00                	mov    (%eax),%eax
c01044a6:	c1 e8 08             	shr    $0x8,%eax
c01044a9:	89 c2                	mov    %eax,%edx
c01044ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044ae:	89 44 24 08          	mov    %eax,0x8(%esp)
c01044b2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01044b6:	c7 04 24 60 a2 10 c0 	movl   $0xc010a260,(%esp)
c01044bd:	e8 e9 bd ff ff       	call   c01002ab <cprintf>
     *ptr_result=result;
c01044c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01044c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01044c8:	89 10                	mov    %edx,(%eax)
     return 0;
c01044ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01044cf:	c9                   	leave  
c01044d0:	c3                   	ret    

c01044d1 <check_content_set>:



static inline void
check_content_set(void)
{
c01044d1:	55                   	push   %ebp
c01044d2:	89 e5                	mov    %esp,%ebp
c01044d4:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01044d7:	b8 00 10 00 00       	mov    $0x1000,%eax
c01044dc:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01044df:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01044e4:	83 f8 01             	cmp    $0x1,%eax
c01044e7:	74 24                	je     c010450d <check_content_set+0x3c>
c01044e9:	c7 44 24 0c 9e a2 10 	movl   $0xc010a29e,0xc(%esp)
c01044f0:	c0 
c01044f1:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c01044f8:	c0 
c01044f9:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0104500:	00 
c0104501:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104508:	e8 f5 be ff ff       	call   c0100402 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c010450d:	b8 10 10 00 00       	mov    $0x1010,%eax
c0104512:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0104515:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010451a:	83 f8 01             	cmp    $0x1,%eax
c010451d:	74 24                	je     c0104543 <check_content_set+0x72>
c010451f:	c7 44 24 0c 9e a2 10 	movl   $0xc010a29e,0xc(%esp)
c0104526:	c0 
c0104527:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c010452e:	c0 
c010452f:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0104536:	00 
c0104537:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c010453e:	e8 bf be ff ff       	call   c0100402 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0104543:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104548:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010454b:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104550:	83 f8 02             	cmp    $0x2,%eax
c0104553:	74 24                	je     c0104579 <check_content_set+0xa8>
c0104555:	c7 44 24 0c ad a2 10 	movl   $0xc010a2ad,0xc(%esp)
c010455c:	c0 
c010455d:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104564:	c0 
c0104565:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c010456c:	00 
c010456d:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104574:	e8 89 be ff ff       	call   c0100402 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0104579:	b8 10 20 00 00       	mov    $0x2010,%eax
c010457e:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0104581:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104586:	83 f8 02             	cmp    $0x2,%eax
c0104589:	74 24                	je     c01045af <check_content_set+0xde>
c010458b:	c7 44 24 0c ad a2 10 	movl   $0xc010a2ad,0xc(%esp)
c0104592:	c0 
c0104593:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c010459a:	c0 
c010459b:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c01045a2:	00 
c01045a3:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c01045aa:	e8 53 be ff ff       	call   c0100402 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c01045af:	b8 00 30 00 00       	mov    $0x3000,%eax
c01045b4:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01045b7:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01045bc:	83 f8 03             	cmp    $0x3,%eax
c01045bf:	74 24                	je     c01045e5 <check_content_set+0x114>
c01045c1:	c7 44 24 0c bc a2 10 	movl   $0xc010a2bc,0xc(%esp)
c01045c8:	c0 
c01045c9:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c01045d0:	c0 
c01045d1:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c01045d8:	00 
c01045d9:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c01045e0:	e8 1d be ff ff       	call   c0100402 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01045e5:	b8 10 30 00 00       	mov    $0x3010,%eax
c01045ea:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01045ed:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01045f2:	83 f8 03             	cmp    $0x3,%eax
c01045f5:	74 24                	je     c010461b <check_content_set+0x14a>
c01045f7:	c7 44 24 0c bc a2 10 	movl   $0xc010a2bc,0xc(%esp)
c01045fe:	c0 
c01045ff:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104606:	c0 
c0104607:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c010460e:	00 
c010460f:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104616:	e8 e7 bd ff ff       	call   c0100402 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c010461b:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104620:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0104623:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104628:	83 f8 04             	cmp    $0x4,%eax
c010462b:	74 24                	je     c0104651 <check_content_set+0x180>
c010462d:	c7 44 24 0c cb a2 10 	movl   $0xc010a2cb,0xc(%esp)
c0104634:	c0 
c0104635:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c010463c:	c0 
c010463d:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0104644:	00 
c0104645:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c010464c:	e8 b1 bd ff ff       	call   c0100402 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0104651:	b8 10 40 00 00       	mov    $0x4010,%eax
c0104656:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0104659:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010465e:	83 f8 04             	cmp    $0x4,%eax
c0104661:	74 24                	je     c0104687 <check_content_set+0x1b6>
c0104663:	c7 44 24 0c cb a2 10 	movl   $0xc010a2cb,0xc(%esp)
c010466a:	c0 
c010466b:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104672:	c0 
c0104673:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c010467a:	00 
c010467b:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104682:	e8 7b bd ff ff       	call   c0100402 <__panic>
}
c0104687:	90                   	nop
c0104688:	c9                   	leave  
c0104689:	c3                   	ret    

c010468a <check_content_access>:

static inline int
check_content_access(void)
{
c010468a:	55                   	push   %ebp
c010468b:	89 e5                	mov    %esp,%ebp
c010468d:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0104690:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104695:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104698:	ff d0                	call   *%eax
c010469a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c010469d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01046a0:	c9                   	leave  
c01046a1:	c3                   	ret    

c01046a2 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c01046a2:	55                   	push   %ebp
c01046a3:	89 e5                	mov    %esp,%ebp
c01046a5:	83 ec 78             	sub    $0x78,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c01046a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01046af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c01046b6:	c7 45 e8 ec 50 12 c0 	movl   $0xc01250ec,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01046bd:	eb 6a                	jmp    c0104729 <check_swap+0x87>
        struct Page *p = le2page(le, page_link);
c01046bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046c2:	83 e8 0c             	sub    $0xc,%eax
c01046c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(PageProperty(p));
c01046c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046cb:	83 c0 04             	add    $0x4,%eax
c01046ce:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c01046d5:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01046d8:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01046db:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01046de:	0f a3 10             	bt     %edx,(%eax)
c01046e1:	19 c0                	sbb    %eax,%eax
c01046e3:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c01046e6:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c01046ea:	0f 95 c0             	setne  %al
c01046ed:	0f b6 c0             	movzbl %al,%eax
c01046f0:	85 c0                	test   %eax,%eax
c01046f2:	75 24                	jne    c0104718 <check_swap+0x76>
c01046f4:	c7 44 24 0c da a2 10 	movl   $0xc010a2da,0xc(%esp)
c01046fb:	c0 
c01046fc:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104703:	c0 
c0104704:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c010470b:	00 
c010470c:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104713:	e8 ea bc ff ff       	call   c0100402 <__panic>
        count ++, total += p->property;
c0104718:	ff 45 f4             	incl   -0xc(%ebp)
c010471b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010471e:	8b 50 08             	mov    0x8(%eax),%edx
c0104721:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104724:	01 d0                	add    %edx,%eax
c0104726:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104729:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010472c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010472f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104732:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0104735:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104738:	81 7d e8 ec 50 12 c0 	cmpl   $0xc01250ec,-0x18(%ebp)
c010473f:	0f 85 7a ff ff ff    	jne    c01046bf <check_swap+0x1d>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0104745:	e8 53 26 00 00       	call   c0106d9d <nr_free_pages>
c010474a:	89 c2                	mov    %eax,%edx
c010474c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010474f:	39 c2                	cmp    %eax,%edx
c0104751:	74 24                	je     c0104777 <check_swap+0xd5>
c0104753:	c7 44 24 0c ea a2 10 	movl   $0xc010a2ea,0xc(%esp)
c010475a:	c0 
c010475b:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104762:	c0 
c0104763:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c010476a:	00 
c010476b:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104772:	e8 8b bc ff ff       	call   c0100402 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0104777:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010477a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010477e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104781:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104785:	c7 04 24 04 a3 10 c0 	movl   $0xc010a304,(%esp)
c010478c:	e8 1a bb ff ff       	call   c01002ab <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0104791:	e8 73 eb ff ff       	call   c0103309 <mm_create>
c0104796:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(mm != NULL);
c0104799:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010479d:	75 24                	jne    c01047c3 <check_swap+0x121>
c010479f:	c7 44 24 0c 2a a3 10 	movl   $0xc010a32a,0xc(%esp)
c01047a6:	c0 
c01047a7:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c01047ae:	c0 
c01047af:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c01047b6:	00 
c01047b7:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c01047be:	e8 3f bc ff ff       	call   c0100402 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c01047c3:	a1 10 50 12 c0       	mov    0xc0125010,%eax
c01047c8:	85 c0                	test   %eax,%eax
c01047ca:	74 24                	je     c01047f0 <check_swap+0x14e>
c01047cc:	c7 44 24 0c 35 a3 10 	movl   $0xc010a335,0xc(%esp)
c01047d3:	c0 
c01047d4:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c01047db:	c0 
c01047dc:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c01047e3:	00 
c01047e4:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c01047eb:	e8 12 bc ff ff       	call   c0100402 <__panic>

     check_mm_struct = mm;
c01047f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01047f3:	a3 10 50 12 c0       	mov    %eax,0xc0125010

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c01047f8:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c01047fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104801:	89 50 0c             	mov    %edx,0xc(%eax)
c0104804:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104807:	8b 40 0c             	mov    0xc(%eax),%eax
c010480a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(pgdir[0] == 0);
c010480d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104810:	8b 00                	mov    (%eax),%eax
c0104812:	85 c0                	test   %eax,%eax
c0104814:	74 24                	je     c010483a <check_swap+0x198>
c0104816:	c7 44 24 0c 4d a3 10 	movl   $0xc010a34d,0xc(%esp)
c010481d:	c0 
c010481e:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104825:	c0 
c0104826:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c010482d:	00 
c010482e:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104835:	e8 c8 bb ff ff       	call   c0100402 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c010483a:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0104841:	00 
c0104842:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0104849:	00 
c010484a:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0104851:	e8 2b eb ff ff       	call   c0103381 <vma_create>
c0104856:	89 45 d0             	mov    %eax,-0x30(%ebp)
     assert(vma != NULL);
c0104859:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010485d:	75 24                	jne    c0104883 <check_swap+0x1e1>
c010485f:	c7 44 24 0c 5b a3 10 	movl   $0xc010a35b,0xc(%esp)
c0104866:	c0 
c0104867:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c010486e:	c0 
c010486f:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0104876:	00 
c0104877:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c010487e:	e8 7f bb ff ff       	call   c0100402 <__panic>

     insert_vma_struct(mm, vma);
c0104883:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104886:	89 44 24 04          	mov    %eax,0x4(%esp)
c010488a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010488d:	89 04 24             	mov    %eax,(%esp)
c0104890:	e8 7d ec ff ff       	call   c0103512 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0104895:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c010489c:	e8 0a ba ff ff       	call   c01002ab <cprintf>
     pte_t *temp_ptep=NULL;
c01048a1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c01048a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01048ab:	8b 40 0c             	mov    0xc(%eax),%eax
c01048ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01048b5:	00 
c01048b6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01048bd:	00 
c01048be:	89 04 24             	mov    %eax,(%esp)
c01048c1:	e8 06 2b 00 00       	call   c01073cc <get_pte>
c01048c6:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(temp_ptep!= NULL);
c01048c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01048cd:	75 24                	jne    c01048f3 <check_swap+0x251>
c01048cf:	c7 44 24 0c 9c a3 10 	movl   $0xc010a39c,0xc(%esp)
c01048d6:	c0 
c01048d7:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c01048de:	c0 
c01048df:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01048e6:	00 
c01048e7:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c01048ee:	e8 0f bb ff ff       	call   c0100402 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01048f3:	c7 04 24 b0 a3 10 c0 	movl   $0xc010a3b0,(%esp)
c01048fa:	e8 ac b9 ff ff       	call   c01002ab <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01048ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104906:	e9 a4 00 00 00       	jmp    c01049af <check_swap+0x30d>
          check_rp[i] = alloc_page();
c010490b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104912:	e8 ce 23 00 00       	call   c0106ce5 <alloc_pages>
c0104917:	89 c2                	mov    %eax,%edx
c0104919:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010491c:	89 14 85 20 50 12 c0 	mov    %edx,-0x3fedafe0(,%eax,4)
          assert(check_rp[i] != NULL );
c0104923:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104926:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c010492d:	85 c0                	test   %eax,%eax
c010492f:	75 24                	jne    c0104955 <check_swap+0x2b3>
c0104931:	c7 44 24 0c d4 a3 10 	movl   $0xc010a3d4,0xc(%esp)
c0104938:	c0 
c0104939:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104940:	c0 
c0104941:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104948:	00 
c0104949:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104950:	e8 ad ba ff ff       	call   c0100402 <__panic>
          assert(!PageProperty(check_rp[i]));
c0104955:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104958:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c010495f:	83 c0 04             	add    $0x4,%eax
c0104962:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0104969:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010496c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010496f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104972:	0f a3 10             	bt     %edx,(%eax)
c0104975:	19 c0                	sbb    %eax,%eax
c0104977:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c010497a:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c010497e:	0f 95 c0             	setne  %al
c0104981:	0f b6 c0             	movzbl %al,%eax
c0104984:	85 c0                	test   %eax,%eax
c0104986:	74 24                	je     c01049ac <check_swap+0x30a>
c0104988:	c7 44 24 0c e8 a3 10 	movl   $0xc010a3e8,0xc(%esp)
c010498f:	c0 
c0104990:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104997:	c0 
c0104998:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010499f:	00 
c01049a0:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c01049a7:	e8 56 ba ff ff       	call   c0100402 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01049ac:	ff 45 ec             	incl   -0x14(%ebp)
c01049af:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01049b3:	0f 8e 52 ff ff ff    	jle    c010490b <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c01049b9:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c01049be:	8b 15 f0 50 12 c0    	mov    0xc01250f0,%edx
c01049c4:	89 45 98             	mov    %eax,-0x68(%ebp)
c01049c7:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01049ca:	c7 45 c0 ec 50 12 c0 	movl   $0xc01250ec,-0x40(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01049d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01049d4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01049d7:	89 50 04             	mov    %edx,0x4(%eax)
c01049da:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01049dd:	8b 50 04             	mov    0x4(%eax),%edx
c01049e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01049e3:	89 10                	mov    %edx,(%eax)
c01049e5:	c7 45 c8 ec 50 12 c0 	movl   $0xc01250ec,-0x38(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01049ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01049ef:	8b 40 04             	mov    0x4(%eax),%eax
c01049f2:	39 45 c8             	cmp    %eax,-0x38(%ebp)
c01049f5:	0f 94 c0             	sete   %al
c01049f8:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c01049fb:	85 c0                	test   %eax,%eax
c01049fd:	75 24                	jne    c0104a23 <check_swap+0x381>
c01049ff:	c7 44 24 0c 03 a4 10 	movl   $0xc010a403,0xc(%esp)
c0104a06:	c0 
c0104a07:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104a0e:	c0 
c0104a0f:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0104a16:	00 
c0104a17:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104a1e:	e8 df b9 ff ff       	call   c0100402 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0104a23:	a1 f4 50 12 c0       	mov    0xc01250f4,%eax
c0104a28:	89 45 bc             	mov    %eax,-0x44(%ebp)
     nr_free = 0;
c0104a2b:	c7 05 f4 50 12 c0 00 	movl   $0x0,0xc01250f4
c0104a32:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104a35:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104a3c:	eb 1d                	jmp    c0104a5b <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0104a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a41:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c0104a48:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104a4f:	00 
c0104a50:	89 04 24             	mov    %eax,(%esp)
c0104a53:	e8 12 23 00 00       	call   c0106d6a <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104a58:	ff 45 ec             	incl   -0x14(%ebp)
c0104a5b:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104a5f:	7e dd                	jle    c0104a3e <check_swap+0x39c>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0104a61:	a1 f4 50 12 c0       	mov    0xc01250f4,%eax
c0104a66:	83 f8 04             	cmp    $0x4,%eax
c0104a69:	74 24                	je     c0104a8f <check_swap+0x3ed>
c0104a6b:	c7 44 24 0c 1c a4 10 	movl   $0xc010a41c,0xc(%esp)
c0104a72:	c0 
c0104a73:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104a7a:	c0 
c0104a7b:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0104a82:	00 
c0104a83:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104a8a:	e8 73 b9 ff ff       	call   c0100402 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0104a8f:	c7 04 24 40 a4 10 c0 	movl   $0xc010a440,(%esp)
c0104a96:	e8 10 b8 ff ff       	call   c01002ab <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0104a9b:	c7 05 64 4f 12 c0 00 	movl   $0x0,0xc0124f64
c0104aa2:	00 00 00 
     
     check_content_set();
c0104aa5:	e8 27 fa ff ff       	call   c01044d1 <check_content_set>
     assert( nr_free == 0);         
c0104aaa:	a1 f4 50 12 c0       	mov    0xc01250f4,%eax
c0104aaf:	85 c0                	test   %eax,%eax
c0104ab1:	74 24                	je     c0104ad7 <check_swap+0x435>
c0104ab3:	c7 44 24 0c 67 a4 10 	movl   $0xc010a467,0xc(%esp)
c0104aba:	c0 
c0104abb:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104ac2:	c0 
c0104ac3:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0104aca:	00 
c0104acb:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104ad2:	e8 2b b9 ff ff       	call   c0100402 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0104ad7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104ade:	eb 25                	jmp    c0104b05 <check_swap+0x463>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0104ae0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ae3:	c7 04 85 40 50 12 c0 	movl   $0xffffffff,-0x3fedafc0(,%eax,4)
c0104aea:	ff ff ff ff 
c0104aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104af1:	8b 14 85 40 50 12 c0 	mov    -0x3fedafc0(,%eax,4),%edx
c0104af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104afb:	89 14 85 80 50 12 c0 	mov    %edx,-0x3fedaf80(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0104b02:	ff 45 ec             	incl   -0x14(%ebp)
c0104b05:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0104b09:	7e d5                	jle    c0104ae0 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104b0b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104b12:	e9 1d 01 00 00       	jmp    c0104c34 <check_swap+0x592>
         check_ptep[i]=0;
c0104b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b1a:	c7 04 85 d4 50 12 c0 	movl   $0x0,-0x3fedaf2c(,%eax,4)
c0104b21:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0104b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b28:	40                   	inc    %eax
c0104b29:	c1 e0 0c             	shl    $0xc,%eax
c0104b2c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b33:	00 
c0104b34:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104b3b:	89 04 24             	mov    %eax,(%esp)
c0104b3e:	e8 89 28 00 00       	call   c01073cc <get_pte>
c0104b43:	89 c2                	mov    %eax,%edx
c0104b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b48:	89 14 85 d4 50 12 c0 	mov    %edx,-0x3fedaf2c(,%eax,4)
         cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
c0104b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b52:	8b 04 85 d4 50 12 c0 	mov    -0x3fedaf2c(,%eax,4),%eax
c0104b59:	8b 10                	mov    (%eax),%edx
c0104b5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b5e:	8b 04 85 d4 50 12 c0 	mov    -0x3fedaf2c(,%eax,4),%eax
c0104b65:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0104b69:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104b6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b70:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b74:	c7 04 24 74 a4 10 c0 	movl   $0xc010a474,(%esp)
c0104b7b:	e8 2b b7 ff ff       	call   c01002ab <cprintf>
         assert(check_ptep[i] != NULL);
c0104b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b83:	8b 04 85 d4 50 12 c0 	mov    -0x3fedaf2c(,%eax,4),%eax
c0104b8a:	85 c0                	test   %eax,%eax
c0104b8c:	75 24                	jne    c0104bb2 <check_swap+0x510>
c0104b8e:	c7 44 24 0c 98 a4 10 	movl   $0xc010a498,0xc(%esp)
c0104b95:	c0 
c0104b96:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104b9d:	c0 
c0104b9e:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104ba5:	00 
c0104ba6:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104bad:	e8 50 b8 ff ff       	call   c0100402 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0104bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bb5:	8b 04 85 d4 50 12 c0 	mov    -0x3fedaf2c(,%eax,4),%eax
c0104bbc:	8b 00                	mov    (%eax),%eax
c0104bbe:	89 04 24             	mov    %eax,(%esp)
c0104bc1:	e8 4f f5 ff ff       	call   c0104115 <pte2page>
c0104bc6:	89 c2                	mov    %eax,%edx
c0104bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bcb:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c0104bd2:	39 c2                	cmp    %eax,%edx
c0104bd4:	74 24                	je     c0104bfa <check_swap+0x558>
c0104bd6:	c7 44 24 0c b0 a4 10 	movl   $0xc010a4b0,0xc(%esp)
c0104bdd:	c0 
c0104bde:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104be5:	c0 
c0104be6:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0104bed:	00 
c0104bee:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104bf5:	e8 08 b8 ff ff       	call   c0100402 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0104bfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bfd:	8b 04 85 d4 50 12 c0 	mov    -0x3fedaf2c(,%eax,4),%eax
c0104c04:	8b 00                	mov    (%eax),%eax
c0104c06:	83 e0 01             	and    $0x1,%eax
c0104c09:	85 c0                	test   %eax,%eax
c0104c0b:	75 24                	jne    c0104c31 <check_swap+0x58f>
c0104c0d:	c7 44 24 0c d8 a4 10 	movl   $0xc010a4d8,0xc(%esp)
c0104c14:	c0 
c0104c15:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104c1c:	c0 
c0104c1d:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0104c24:	00 
c0104c25:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104c2c:	e8 d1 b7 ff ff       	call   c0100402 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104c31:	ff 45 ec             	incl   -0x14(%ebp)
c0104c34:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104c38:	0f 8e d9 fe ff ff    	jle    c0104b17 <check_swap+0x475>
         cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0104c3e:	c7 04 24 f4 a4 10 c0 	movl   $0xc010a4f4,(%esp)
c0104c45:	e8 61 b6 ff ff       	call   c01002ab <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     //前面设置空闲页数量为4， mm大小为0x1000~0x6000共6页
     ret=check_content_access();
c0104c4a:	e8 3b fa ff ff       	call   c010468a <check_content_access>
c0104c4f:	89 45 b8             	mov    %eax,-0x48(%ebp)
     assert(ret==0);
c0104c52:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104c56:	74 24                	je     c0104c7c <check_swap+0x5da>
c0104c58:	c7 44 24 0c 1a a5 10 	movl   $0xc010a51a,0xc(%esp)
c0104c5f:	c0 
c0104c60:	c7 44 24 08 de a1 10 	movl   $0xc010a1de,0x8(%esp)
c0104c67:	c0 
c0104c68:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0104c6f:	00 
c0104c70:	c7 04 24 78 a1 10 c0 	movl   $0xc010a178,(%esp)
c0104c77:	e8 86 b7 ff ff       	call   c0100402 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104c7c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104c83:	eb 1d                	jmp    c0104ca2 <check_swap+0x600>
         free_pages(check_rp[i],1);
c0104c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c88:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c0104c8f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104c96:	00 
c0104c97:	89 04 24             	mov    %eax,(%esp)
c0104c9a:	e8 cb 20 00 00       	call   c0106d6a <free_pages>
     //前面设置空闲页数量为4， mm大小为0x1000~0x6000共6页
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104c9f:	ff 45 ec             	incl   -0x14(%ebp)
c0104ca2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104ca6:	7e dd                	jle    c0104c85 <check_swap+0x5e3>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0104ca8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104cab:	89 04 24             	mov    %eax,(%esp)
c0104cae:	e8 91 e9 ff ff       	call   c0103644 <mm_destroy>
         
     nr_free = nr_free_store;
c0104cb3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104cb6:	a3 f4 50 12 c0       	mov    %eax,0xc01250f4
     free_list = free_list_store;
c0104cbb:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104cbe:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104cc1:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec
c0104cc6:	89 15 f0 50 12 c0    	mov    %edx,0xc01250f0

     
     le = &free_list;
c0104ccc:	c7 45 e8 ec 50 12 c0 	movl   $0xc01250ec,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0104cd3:	eb 1c                	jmp    c0104cf1 <check_swap+0x64f>
         struct Page *p = le2page(le, page_link);
c0104cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cd8:	83 e8 0c             	sub    $0xc,%eax
c0104cdb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
         count --, total -= p->property;
c0104cde:	ff 4d f4             	decl   -0xc(%ebp)
c0104ce1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104ce4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104ce7:	8b 40 08             	mov    0x8(%eax),%eax
c0104cea:	29 c2                	sub    %eax,%edx
c0104cec:	89 d0                	mov    %edx,%eax
c0104cee:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cf4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104cf7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104cfa:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0104cfd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104d00:	81 7d e8 ec 50 12 c0 	cmpl   $0xc01250ec,-0x18(%ebp)
c0104d07:	75 cc                	jne    c0104cd5 <check_swap+0x633>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0104d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d0c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d17:	c7 04 24 21 a5 10 c0 	movl   $0xc010a521,(%esp)
c0104d1e:	e8 88 b5 ff ff       	call   c01002ab <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0104d23:	c7 04 24 3b a5 10 c0 	movl   $0xc010a53b,(%esp)
c0104d2a:	e8 7c b5 ff ff       	call   c01002ab <cprintf>
}
c0104d2f:	90                   	nop
c0104d30:	c9                   	leave  
c0104d31:	c3                   	ret    

c0104d32 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0104d32:	55                   	push   %ebp
c0104d33:	89 e5                	mov    %esp,%ebp
c0104d35:	83 ec 28             	sub    $0x28,%esp
c0104d38:	c7 45 f4 e4 50 12 c0 	movl   $0xc01250e4,-0xc(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104d45:	89 50 04             	mov    %edx,0x4(%eax)
c0104d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d4b:	8b 50 04             	mov    0x4(%eax),%edx
c0104d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d51:	89 10                	mov    %edx,(%eax)
    list_init(&pra_list_head);
    mm->sm_priv = &pra_list_head;
c0104d53:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d56:	c7 40 14 e4 50 12 c0 	movl   $0xc01250e4,0x14(%eax)
    cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
c0104d5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d60:	8b 40 14             	mov    0x14(%eax),%eax
c0104d63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d67:	c7 04 24 54 a5 10 c0 	movl   $0xc010a554,(%esp)
c0104d6e:	e8 38 b5 ff ff       	call   c01002ab <cprintf>
    return 0;
c0104d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104d78:	c9                   	leave  
c0104d79:	c3                   	ret    

c0104d7a <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0104d7a:	55                   	push   %ebp
c0104d7b:	89 e5                	mov    %esp,%ebp
c0104d7d:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0104d80:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d83:	8b 40 14             	mov    0x14(%eax),%eax
c0104d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0104d89:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d8c:	83 c0 14             	add    $0x14,%eax
c0104d8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0104d92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104d96:	74 06                	je     c0104d9e <_fifo_map_swappable+0x24>
c0104d98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d9c:	75 24                	jne    c0104dc2 <_fifo_map_swappable+0x48>
c0104d9e:	c7 44 24 0c 75 a5 10 	movl   $0xc010a575,0xc(%esp)
c0104da5:	c0 
c0104da6:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0104dad:	c0 
c0104dae:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0104db5:	00 
c0104db6:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0104dbd:	e8 40 b6 ff ff       	call   c0100402 <__panic>
c0104dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dcb:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104dd1:	8b 00                	mov    (%eax),%eax
c0104dd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104dd6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0104dd9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104ddc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ddf:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104de2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104de5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104de8:	89 10                	mov    %edx,(%eax)
c0104dea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ded:	8b 10                	mov    (%eax),%edx
c0104def:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104df2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104df5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104df8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104dfb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104dfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e01:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e04:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    
    list_add_before(head, entry);
    return 0;
c0104e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104e0b:	c9                   	leave  
c0104e0c:	c3                   	ret    

c0104e0d <_exclock_map_swappable>:

static int
_exclock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in){
c0104e0d:	55                   	push   %ebp
c0104e0e:	89 e5                	mov    %esp,%ebp
c0104e10:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
c0104e13:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e16:	8b 40 14             	mov    0x14(%eax),%eax
c0104e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry = &(page->pra_page_link);
c0104e1c:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e1f:	83 c0 14             	add    $0x14,%eax
c0104e22:	89 45 f0             	mov    %eax,-0x10(%ebp)

    assert(entry != NULL && head != NULL);
c0104e25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e29:	74 06                	je     c0104e31 <_exclock_map_swappable+0x24>
c0104e2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e2f:	75 24                	jne    c0104e55 <_exclock_map_swappable+0x48>
c0104e31:	c7 44 24 0c 75 a5 10 	movl   $0xc010a575,0xc(%esp)
c0104e38:	c0 
c0104e39:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0104e40:	c0 
c0104e41:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
c0104e48:	00 
c0104e49:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0104e50:	e8 ad b5 ff ff       	call   c0100402 <__panic>
c0104e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e58:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e64:	8b 00                	mov    (%eax),%eax
c0104e66:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104e69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0104e6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104e6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e72:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104e75:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104e7b:	89 10                	mov    %edx,(%eax)
c0104e7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e80:	8b 10                	mov    (%eax),%edx
c0104e82:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e85:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104e88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e8e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e94:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e97:	89 10                	mov    %edx,(%eax)
    list_add_before(head, entry);
    return 0;
c0104e99:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104e9e:	c9                   	leave  
c0104e9f:	c3                   	ret    

c0104ea0 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0104ea0:	55                   	push   %ebp
c0104ea1:	89 e5                	mov    %esp,%ebp
c0104ea3:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0104ea6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ea9:	8b 40 14             	mov    0x14(%eax),%eax
c0104eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(head != NULL);
c0104eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104eb3:	75 24                	jne    c0104ed9 <_fifo_swap_out_victim+0x39>
c0104eb5:	c7 44 24 0c bc a5 10 	movl   $0xc010a5bc,0xc(%esp)
c0104ebc:	c0 
c0104ebd:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0104ec4:	c0 
c0104ec5:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
c0104ecc:	00 
c0104ecd:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0104ed4:	e8 29 b5 ff ff       	call   c0100402 <__panic>
    assert(in_tick==0);
c0104ed9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104edd:	74 24                	je     c0104f03 <_fifo_swap_out_victim+0x63>
c0104edf:	c7 44 24 0c c9 a5 10 	movl   $0xc010a5c9,0xc(%esp)
c0104ee6:	c0 
c0104ee7:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0104eee:	c0 
c0104eef:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
c0104ef6:	00 
c0104ef7:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0104efe:	e8 ff b4 ff ff       	call   c0100402 <__panic>
    /* Select the victim */
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
    //(2)  assign the value of *ptr_page to the addr of this page
    list_entry_t *le = head->next;
c0104f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f06:	8b 40 04             	mov    0x4(%eax),%eax
c0104f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(le != head);
c0104f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f0f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104f12:	75 24                	jne    c0104f38 <_fifo_swap_out_victim+0x98>
c0104f14:	c7 44 24 0c d4 a5 10 	movl   $0xc010a5d4,0xc(%esp)
c0104f1b:	c0 
c0104f1c:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0104f23:	c0 
c0104f24:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
c0104f2b:	00 
c0104f2c:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0104f33:	e8 ca b4 ff ff       	call   c0100402 <__panic>
    struct Page *p = le2page(le, pra_page_link);
c0104f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f3b:	83 e8 14             	sub    $0x14,%eax
c0104f3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f44:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f4a:	8b 40 04             	mov    0x4(%eax),%eax
c0104f4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104f50:	8b 12                	mov    (%edx),%edx
c0104f52:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0104f55:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f5e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104f61:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104f67:	89 10                	mov    %edx,(%eax)
    list_del(le);
    assert(p != NULL);
c0104f69:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104f6d:	75 24                	jne    c0104f93 <_fifo_swap_out_victim+0xf3>
c0104f6f:	c7 44 24 0c df a5 10 	movl   $0xc010a5df,0xc(%esp)
c0104f76:	c0 
c0104f77:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0104f7e:	c0 
c0104f7f:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c0104f86:	00 
c0104f87:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0104f8e:	e8 6f b4 ff ff       	call   c0100402 <__panic>
    // memset(page2kva(p), 0, PGSIZE);
    *ptr_page = p;
c0104f93:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f96:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104f99:	89 10                	mov    %edx,(%eax)
    return 0;
c0104f9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104fa0:	c9                   	leave  
c0104fa1:	c3                   	ret    

c0104fa2 <_exclock_swap_out_victim>:

static list_entry_t *pointer = &pra_list_head;
static int 
_exclock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick){
c0104fa2:	55                   	push   %ebp
c0104fa3:	89 e5                	mov    %esp,%ebp
c0104fa5:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
c0104fa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fab:	8b 40 14             	mov    0x14(%eax),%eax
c0104fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(head != NULL);
c0104fb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104fb5:	75 24                	jne    c0104fdb <_exclock_swap_out_victim+0x39>
c0104fb7:	c7 44 24 0c bc a5 10 	movl   $0xc010a5bc,0xc(%esp)
c0104fbe:	c0 
c0104fbf:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0104fc6:	c0 
c0104fc7:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c0104fce:	00 
c0104fcf:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0104fd6:	e8 27 b4 ff ff       	call   c0100402 <__panic>
    assert(in_tick == 0);
c0104fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104fdf:	0f 84 4e 01 00 00    	je     c0105133 <_exclock_swap_out_victim+0x191>
c0104fe5:	c7 44 24 0c e9 a5 10 	movl   $0xc010a5e9,0xc(%esp)
c0104fec:	c0 
c0104fed:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0104ff4:	c0 
c0104ff5:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0104ffc:	00 
c0104ffd:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0105004:	e8 f9 b3 ff ff       	call   c0100402 <__panic>

    while ((pointer = list_next(pointer)) != NULL){
        if(pointer == head && list_next(pointer) != head)
c0105009:	a1 e0 19 12 c0       	mov    0xc01219e0,%eax
c010500e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105011:	75 18                	jne    c010502b <_exclock_swap_out_victim+0x89>
c0105013:	a1 e0 19 12 c0       	mov    0xc01219e0,%eax
c0105018:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010501b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010501e:	8b 40 04             	mov    0x4(%eax),%eax
c0105021:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105024:	74 05                	je     c010502b <_exclock_swap_out_victim+0x89>
            continue;
c0105026:	e9 08 01 00 00       	jmp    c0105133 <_exclock_swap_out_victim+0x191>
        else if(pointer == head)
c010502b:	a1 e0 19 12 c0       	mov    0xc01219e0,%eax
c0105030:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105033:	0f 84 1c 01 00 00    	je     c0105155 <_exclock_swap_out_victim+0x1b3>
            break;

        struct Page *p = le2page(pointer, pra_page_link);
c0105039:	a1 e0 19 12 c0       	mov    0xc01219e0,%eax
c010503e:	83 e8 14             	sub    $0x14,%eax
c0105041:	89 45 ec             	mov    %eax,-0x14(%ebp)
        pte_t *ptep = get_pte(mm->pgdir, p->pra_vaddr, 0);
c0105044:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105047:	8b 50 1c             	mov    0x1c(%eax),%edx
c010504a:	8b 45 08             	mov    0x8(%ebp),%eax
c010504d:	8b 40 0c             	mov    0xc(%eax),%eax
c0105050:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105057:	00 
c0105058:	89 54 24 04          	mov    %edx,0x4(%esp)
c010505c:	89 04 24             	mov    %eax,(%esp)
c010505f:	e8 68 23 00 00       	call   c01073cc <get_pte>
c0105064:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(ptep != NULL);
c0105067:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010506b:	75 24                	jne    c0105091 <_exclock_swap_out_victim+0xef>
c010506d:	c7 44 24 0c f6 a5 10 	movl   $0xc010a5f6,0xc(%esp)
c0105074:	c0 
c0105075:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c010507c:	c0 
c010507d:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0105084:	00 
c0105085:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c010508c:	e8 71 b3 ff ff       	call   c0100402 <__panic>

        if(*ptep & PTE_A){
c0105091:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105094:	8b 00                	mov    (%eax),%eax
c0105096:	83 e0 20             	and    $0x20,%eax
c0105099:	85 c0                	test   %eax,%eax
c010509b:	74 14                	je     c01050b1 <_exclock_swap_out_victim+0x10f>
            *ptep = *ptep & ~PTE_A;
c010509d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050a0:	8b 00                	mov    (%eax),%eax
c01050a2:	83 e0 df             	and    $0xffffffdf,%eax
c01050a5:	89 c2                	mov    %eax,%edx
c01050a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050aa:	89 10                	mov    %edx,(%eax)
            continue;
c01050ac:	e9 82 00 00 00       	jmp    c0105133 <_exclock_swap_out_victim+0x191>
        }else if(*ptep & PTE_D){
c01050b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050b4:	8b 00                	mov    (%eax),%eax
c01050b6:	83 e0 40             	and    $0x40,%eax
c01050b9:	85 c0                	test   %eax,%eax
c01050bb:	74 11                	je     c01050ce <_exclock_swap_out_victim+0x12c>
            *ptep = *ptep & ~PTE_D;
c01050bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050c0:	8b 00                	mov    (%eax),%eax
c01050c2:	83 e0 bf             	and    $0xffffffbf,%eax
c01050c5:	89 c2                	mov    %eax,%edx
c01050c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050ca:	89 10                	mov    %edx,(%eax)
            // swap_out(mm, 1, 0);
            continue;
c01050cc:	eb 65                	jmp    c0105133 <_exclock_swap_out_victim+0x191>
        }
        else{
            list_del(pointer);
c01050ce:	a1 e0 19 12 c0       	mov    0xc01219e0,%eax
c01050d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01050d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050d9:	8b 40 04             	mov    0x4(%eax),%eax
c01050dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01050df:	8b 12                	mov    (%edx),%edx
c01050e1:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01050e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01050e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01050ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01050ed:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01050f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01050f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01050f6:	89 10                	mov    %edx,(%eax)
            pointer = list_next(pointer);
c01050f8:	a1 e0 19 12 c0       	mov    0xc01219e0,%eax
c01050fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105100:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105103:	8b 40 04             	mov    0x4(%eax),%eax
c0105106:	a3 e0 19 12 c0       	mov    %eax,0xc01219e0

            *ptr_page = p;
c010510b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010510e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105111:	89 10                	mov    %edx,(%eax)
            // 遍历了一回，肯定修改了标志位，所以要刷新TLB
            tlb_invalidate(mm->pgdir, pointer);
c0105113:	a1 e0 19 12 c0       	mov    0xc01219e0,%eax
c0105118:	89 c2                	mov    %eax,%edx
c010511a:	8b 45 08             	mov    0x8(%ebp),%eax
c010511d:	8b 40 0c             	mov    0xc(%eax),%eax
c0105120:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105124:	89 04 24             	mov    %eax,(%esp)
c0105127:	e8 09 26 00 00       	call   c0107735 <tlb_invalidate>
            return 0;
c010512c:	b8 00 00 00 00       	mov    $0x0,%eax
c0105131:	eb 2c                	jmp    c010515f <_exclock_swap_out_victim+0x1bd>
_exclock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick){
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
    assert(head != NULL);
    assert(in_tick == 0);

    while ((pointer = list_next(pointer)) != NULL){
c0105133:	a1 e0 19 12 c0       	mov    0xc01219e0,%eax
c0105138:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010513b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010513e:	8b 40 04             	mov    0x4(%eax),%eax
c0105141:	a3 e0 19 12 c0       	mov    %eax,0xc01219e0
c0105146:	a1 e0 19 12 c0       	mov    0xc01219e0,%eax
c010514b:	85 c0                	test   %eax,%eax
c010514d:	0f 85 b6 fe ff ff    	jne    c0105009 <_exclock_swap_out_victim+0x67>
c0105153:	eb 01                	jmp    c0105156 <_exclock_swap_out_victim+0x1b4>
        if(pointer == head && list_next(pointer) != head)
            continue;
        else if(pointer == head)
            break;
c0105155:	90                   	nop
            tlb_invalidate(mm->pgdir, pointer);
            return 0;
        }
    }

    *ptr_page = NULL;
c0105156:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105159:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    
}
c010515f:	c9                   	leave  
c0105160:	c3                   	ret    

c0105161 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0105161:	55                   	push   %ebp
c0105162:	89 e5                	mov    %esp,%ebp
c0105164:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0105167:	c7 04 24 04 a6 10 c0 	movl   $0xc010a604,(%esp)
c010516e:	e8 38 b1 ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0105173:	b8 00 30 00 00       	mov    $0x3000,%eax
c0105178:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c010517b:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105180:	83 f8 04             	cmp    $0x4,%eax
c0105183:	74 24                	je     c01051a9 <_fifo_check_swap+0x48>
c0105185:	c7 44 24 0c 2a a6 10 	movl   $0xc010a62a,0xc(%esp)
c010518c:	c0 
c010518d:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0105194:	c0 
c0105195:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
c010519c:	00 
c010519d:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c01051a4:	e8 59 b2 ff ff       	call   c0100402 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01051a9:	c7 04 24 3c a6 10 c0 	movl   $0xc010a63c,(%esp)
c01051b0:	e8 f6 b0 ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01051b5:	b8 00 10 00 00       	mov    $0x1000,%eax
c01051ba:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c01051bd:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01051c2:	83 f8 04             	cmp    $0x4,%eax
c01051c5:	74 24                	je     c01051eb <_fifo_check_swap+0x8a>
c01051c7:	c7 44 24 0c 2a a6 10 	movl   $0xc010a62a,0xc(%esp)
c01051ce:	c0 
c01051cf:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c01051d6:	c0 
c01051d7:	c7 44 24 04 8b 00 00 	movl   $0x8b,0x4(%esp)
c01051de:	00 
c01051df:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c01051e6:	e8 17 b2 ff ff       	call   c0100402 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01051eb:	c7 04 24 64 a6 10 c0 	movl   $0xc010a664,(%esp)
c01051f2:	e8 b4 b0 ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c01051f7:	b8 00 40 00 00       	mov    $0x4000,%eax
c01051fc:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c01051ff:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105204:	83 f8 04             	cmp    $0x4,%eax
c0105207:	74 24                	je     c010522d <_fifo_check_swap+0xcc>
c0105209:	c7 44 24 0c 2a a6 10 	movl   $0xc010a62a,0xc(%esp)
c0105210:	c0 
c0105211:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0105218:	c0 
c0105219:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
c0105220:	00 
c0105221:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0105228:	e8 d5 b1 ff ff       	call   c0100402 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010522d:	c7 04 24 8c a6 10 c0 	movl   $0xc010a68c,(%esp)
c0105234:	e8 72 b0 ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0105239:	b8 00 20 00 00       	mov    $0x2000,%eax
c010523e:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0105241:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105246:	83 f8 04             	cmp    $0x4,%eax
c0105249:	74 24                	je     c010526f <_fifo_check_swap+0x10e>
c010524b:	c7 44 24 0c 2a a6 10 	movl   $0xc010a62a,0xc(%esp)
c0105252:	c0 
c0105253:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c010525a:	c0 
c010525b:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
c0105262:	00 
c0105263:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c010526a:	e8 93 b1 ff ff       	call   c0100402 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c010526f:	c7 04 24 b4 a6 10 c0 	movl   $0xc010a6b4,(%esp)
c0105276:	e8 30 b0 ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c010527b:	b8 00 50 00 00       	mov    $0x5000,%eax
c0105280:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0105283:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105288:	83 f8 05             	cmp    $0x5,%eax
c010528b:	74 24                	je     c01052b1 <_fifo_check_swap+0x150>
c010528d:	c7 44 24 0c da a6 10 	movl   $0xc010a6da,0xc(%esp)
c0105294:	c0 
c0105295:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c010529c:	c0 
c010529d:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01052a4:	00 
c01052a5:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c01052ac:	e8 51 b1 ff ff       	call   c0100402 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01052b1:	c7 04 24 8c a6 10 c0 	movl   $0xc010a68c,(%esp)
c01052b8:	e8 ee af ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01052bd:	b8 00 20 00 00       	mov    $0x2000,%eax
c01052c2:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c01052c5:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01052ca:	83 f8 05             	cmp    $0x5,%eax
c01052cd:	74 24                	je     c01052f3 <_fifo_check_swap+0x192>
c01052cf:	c7 44 24 0c da a6 10 	movl   $0xc010a6da,0xc(%esp)
c01052d6:	c0 
c01052d7:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c01052de:	c0 
c01052df:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c01052e6:	00 
c01052e7:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c01052ee:	e8 0f b1 ff ff       	call   c0100402 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01052f3:	c7 04 24 3c a6 10 c0 	movl   $0xc010a63c,(%esp)
c01052fa:	e8 ac af ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01052ff:	b8 00 10 00 00       	mov    $0x1000,%eax
c0105304:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0105307:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010530c:	83 f8 06             	cmp    $0x6,%eax
c010530f:	74 24                	je     c0105335 <_fifo_check_swap+0x1d4>
c0105311:	c7 44 24 0c e9 a6 10 	movl   $0xc010a6e9,0xc(%esp)
c0105318:	c0 
c0105319:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0105320:	c0 
c0105321:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0105328:	00 
c0105329:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0105330:	e8 cd b0 ff ff       	call   c0100402 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0105335:	c7 04 24 8c a6 10 c0 	movl   $0xc010a68c,(%esp)
c010533c:	e8 6a af ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0105341:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105346:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0105349:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010534e:	83 f8 07             	cmp    $0x7,%eax
c0105351:	74 24                	je     c0105377 <_fifo_check_swap+0x216>
c0105353:	c7 44 24 0c f8 a6 10 	movl   $0xc010a6f8,0xc(%esp)
c010535a:	c0 
c010535b:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0105362:	c0 
c0105363:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c010536a:	00 
c010536b:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0105372:	e8 8b b0 ff ff       	call   c0100402 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0105377:	c7 04 24 04 a6 10 c0 	movl   $0xc010a604,(%esp)
c010537e:	e8 28 af ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0105383:	b8 00 30 00 00       	mov    $0x3000,%eax
c0105388:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c010538b:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105390:	83 f8 08             	cmp    $0x8,%eax
c0105393:	74 24                	je     c01053b9 <_fifo_check_swap+0x258>
c0105395:	c7 44 24 0c 07 a7 10 	movl   $0xc010a707,0xc(%esp)
c010539c:	c0 
c010539d:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c01053a4:	c0 
c01053a5:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c01053ac:	00 
c01053ad:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c01053b4:	e8 49 b0 ff ff       	call   c0100402 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01053b9:	c7 04 24 64 a6 10 c0 	movl   $0xc010a664,(%esp)
c01053c0:	e8 e6 ae ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c01053c5:	b8 00 40 00 00       	mov    $0x4000,%eax
c01053ca:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c01053cd:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01053d2:	83 f8 09             	cmp    $0x9,%eax
c01053d5:	74 24                	je     c01053fb <_fifo_check_swap+0x29a>
c01053d7:	c7 44 24 0c 16 a7 10 	movl   $0xc010a716,0xc(%esp)
c01053de:	c0 
c01053df:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c01053e6:	c0 
c01053e7:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
c01053ee:	00 
c01053ef:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c01053f6:	e8 07 b0 ff ff       	call   c0100402 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01053fb:	c7 04 24 b4 a6 10 c0 	movl   $0xc010a6b4,(%esp)
c0105402:	e8 a4 ae ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0105407:	b8 00 50 00 00       	mov    $0x5000,%eax
c010540c:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c010540f:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105414:	83 f8 0a             	cmp    $0xa,%eax
c0105417:	74 24                	je     c010543d <_fifo_check_swap+0x2dc>
c0105419:	c7 44 24 0c 25 a7 10 	movl   $0xc010a725,0xc(%esp)
c0105420:	c0 
c0105421:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0105428:	c0 
c0105429:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c0105430:	00 
c0105431:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0105438:	e8 c5 af ff ff       	call   c0100402 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010543d:	c7 04 24 3c a6 10 c0 	movl   $0xc010a63c,(%esp)
c0105444:	e8 62 ae ff ff       	call   c01002ab <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c0105449:	b8 00 10 00 00       	mov    $0x1000,%eax
c010544e:	0f b6 00             	movzbl (%eax),%eax
c0105451:	3c 0a                	cmp    $0xa,%al
c0105453:	74 24                	je     c0105479 <_fifo_check_swap+0x318>
c0105455:	c7 44 24 0c 38 a7 10 	movl   $0xc010a738,0xc(%esp)
c010545c:	c0 
c010545d:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c0105464:	c0 
c0105465:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c010546c:	00 
c010546d:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0105474:	e8 89 af ff ff       	call   c0100402 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0105479:	b8 00 10 00 00       	mov    $0x1000,%eax
c010547e:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0105481:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105486:	83 f8 0b             	cmp    $0xb,%eax
c0105489:	74 24                	je     c01054af <_fifo_check_swap+0x34e>
c010548b:	c7 44 24 0c 59 a7 10 	movl   $0xc010a759,0xc(%esp)
c0105492:	c0 
c0105493:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c010549a:	c0 
c010549b:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c01054a2:	00 
c01054a3:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c01054aa:	e8 53 af ff ff       	call   c0100402 <__panic>
    return 0;
c01054af:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01054b4:	c9                   	leave  
c01054b5:	c3                   	ret    

c01054b6 <_exclock_check_swap>:

static int
_exclock_check_swap(void) {
c01054b6:	55                   	push   %ebp
c01054b7:	89 e5                	mov    %esp,%ebp
c01054b9:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c01054bc:	c7 04 24 04 a6 10 c0 	movl   $0xc010a604,(%esp)
c01054c3:	e8 e3 ad ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01054c8:	b8 00 30 00 00       	mov    $0x3000,%eax
c01054cd:	c6 00 0c             	movb   $0xc,(%eax)
    // assert(pgfault_num==4);
    cprintf("write Virt Page a in fifo_check_swap\n");
c01054d0:	c7 04 24 3c a6 10 c0 	movl   $0xc010a63c,(%esp)
c01054d7:	e8 cf ad ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01054dc:	b8 00 10 00 00       	mov    $0x1000,%eax
c01054e1:	c6 00 0a             	movb   $0xa,(%eax)
    // assert(pgfault_num==4);
    cprintf("write Virt Page d in fifo_check_swap\n");
c01054e4:	c7 04 24 64 a6 10 c0 	movl   $0xc010a664,(%esp)
c01054eb:	e8 bb ad ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c01054f0:	b8 00 40 00 00       	mov    $0x4000,%eax
c01054f5:	c6 00 0d             	movb   $0xd,(%eax)
    // assert(pgfault_num==4);
    cprintf("write Virt Page b in fifo_check_swap\n");
c01054f8:	c7 04 24 8c a6 10 c0 	movl   $0xc010a68c,(%esp)
c01054ff:	e8 a7 ad ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0105504:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105509:	c6 00 0b             	movb   $0xb,(%eax)
    // assert(pgfault_num==4);
    cprintf("write Virt Page e in fifo_check_swap\n");
c010550c:	c7 04 24 b4 a6 10 c0 	movl   $0xc010a6b4,(%esp)
c0105513:	e8 93 ad ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0105518:	b8 00 50 00 00       	mov    $0x5000,%eax
c010551d:	c6 00 0e             	movb   $0xe,(%eax)
    // assert(pgfault_num==5);
    cprintf("write Virt Page b in fifo_check_swap\n");
c0105520:	c7 04 24 8c a6 10 c0 	movl   $0xc010a68c,(%esp)
c0105527:	e8 7f ad ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010552c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105531:	c6 00 0b             	movb   $0xb,(%eax)
    // assert(pgfault_num==5);
    cprintf("write Virt Page a in fifo_check_swap\n");
c0105534:	c7 04 24 3c a6 10 c0 	movl   $0xc010a63c,(%esp)
c010553b:	e8 6b ad ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0105540:	b8 00 10 00 00       	mov    $0x1000,%eax
c0105545:	c6 00 0a             	movb   $0xa,(%eax)
    // assert(pgfault_num==6);
    cprintf("write Virt Page b in fifo_check_swap\n");
c0105548:	c7 04 24 8c a6 10 c0 	movl   $0xc010a68c,(%esp)
c010554f:	e8 57 ad ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0105554:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105559:	c6 00 0b             	movb   $0xb,(%eax)
    // assert(pgfault_num==7);
    cprintf("write Virt Page c in fifo_check_swap\n");
c010555c:	c7 04 24 04 a6 10 c0 	movl   $0xc010a604,(%esp)
c0105563:	e8 43 ad ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0105568:	b8 00 30 00 00       	mov    $0x3000,%eax
c010556d:	c6 00 0c             	movb   $0xc,(%eax)
    // assert(pgfault_num==8);
    cprintf("write Virt Page d in fifo_check_swap\n");
c0105570:	c7 04 24 64 a6 10 c0 	movl   $0xc010a664,(%esp)
c0105577:	e8 2f ad ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c010557c:	b8 00 40 00 00       	mov    $0x4000,%eax
c0105581:	c6 00 0d             	movb   $0xd,(%eax)
    // assert(pgfault_num==9);
    cprintf("write Virt Page e in fifo_check_swap\n");
c0105584:	c7 04 24 b4 a6 10 c0 	movl   $0xc010a6b4,(%esp)
c010558b:	e8 1b ad ff ff       	call   c01002ab <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0105590:	b8 00 50 00 00       	mov    $0x5000,%eax
c0105595:	c6 00 0e             	movb   $0xe,(%eax)
    // assert(pgfault_num==10);
    cprintf("write Virt Page a in fifo_check_swap\n");
c0105598:	c7 04 24 3c a6 10 c0 	movl   $0xc010a63c,(%esp)
c010559f:	e8 07 ad ff ff       	call   c01002ab <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c01055a4:	b8 00 10 00 00       	mov    $0x1000,%eax
c01055a9:	0f b6 00             	movzbl (%eax),%eax
c01055ac:	3c 0a                	cmp    $0xa,%al
c01055ae:	74 24                	je     c01055d4 <_exclock_check_swap+0x11e>
c01055b0:	c7 44 24 0c 38 a7 10 	movl   $0xc010a738,0xc(%esp)
c01055b7:	c0 
c01055b8:	c7 44 24 08 93 a5 10 	movl   $0xc010a593,0x8(%esp)
c01055bf:	c0 
c01055c0:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01055c7:	00 
c01055c8:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c01055cf:	e8 2e ae ff ff       	call   c0100402 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c01055d4:	b8 00 10 00 00       	mov    $0x1000,%eax
c01055d9:	c6 00 0a             	movb   $0xa,(%eax)
    // assert(pgfault_num==11);
    cprintf("pgfault_num == %d\n", pgfault_num);
c01055dc:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01055e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055e5:	c7 04 24 69 a7 10 c0 	movl   $0xc010a769,(%esp)
c01055ec:	e8 ba ac ff ff       	call   c01002ab <cprintf>
    return 0;
c01055f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01055f6:	c9                   	leave  
c01055f7:	c3                   	ret    

c01055f8 <_fifo_init>:


static int
_fifo_init(void)
{
c01055f8:	55                   	push   %ebp
c01055f9:	89 e5                	mov    %esp,%ebp
    return 0;
c01055fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105600:	5d                   	pop    %ebp
c0105601:	c3                   	ret    

c0105602 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0105602:	55                   	push   %ebp
c0105603:	89 e5                	mov    %esp,%ebp
    return 0;
c0105605:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010560a:	5d                   	pop    %ebp
c010560b:	c3                   	ret    

c010560c <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c010560c:	55                   	push   %ebp
c010560d:	89 e5                	mov    %esp,%ebp
c010560f:	b8 00 00 00 00       	mov    $0x0,%eax
c0105614:	5d                   	pop    %ebp
c0105615:	c3                   	ret    

c0105616 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0105616:	55                   	push   %ebp
c0105617:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0105619:	8b 45 08             	mov    0x8(%ebp),%eax
c010561c:	8b 15 00 51 12 c0    	mov    0xc0125100,%edx
c0105622:	29 d0                	sub    %edx,%eax
c0105624:	c1 f8 05             	sar    $0x5,%eax
}
c0105627:	5d                   	pop    %ebp
c0105628:	c3                   	ret    

c0105629 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0105629:	55                   	push   %ebp
c010562a:	89 e5                	mov    %esp,%ebp
c010562c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010562f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105632:	89 04 24             	mov    %eax,(%esp)
c0105635:	e8 dc ff ff ff       	call   c0105616 <page2ppn>
c010563a:	c1 e0 0c             	shl    $0xc,%eax
}
c010563d:	c9                   	leave  
c010563e:	c3                   	ret    

c010563f <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c010563f:	55                   	push   %ebp
c0105640:	89 e5                	mov    %esp,%ebp
c0105642:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0105645:	8b 45 08             	mov    0x8(%ebp),%eax
c0105648:	89 04 24             	mov    %eax,(%esp)
c010564b:	e8 d9 ff ff ff       	call   c0105629 <page2pa>
c0105650:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105653:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105656:	c1 e8 0c             	shr    $0xc,%eax
c0105659:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010565c:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0105661:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0105664:	72 23                	jb     c0105689 <page2kva+0x4a>
c0105666:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105669:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010566d:	c7 44 24 08 90 a7 10 	movl   $0xc010a790,0x8(%esp)
c0105674:	c0 
c0105675:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c010567c:	00 
c010567d:	c7 04 24 b3 a7 10 c0 	movl   $0xc010a7b3,(%esp)
c0105684:	e8 79 ad ff ff       	call   c0100402 <__panic>
c0105689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010568c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0105691:	c9                   	leave  
c0105692:	c3                   	ret    

c0105693 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0105693:	55                   	push   %ebp
c0105694:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0105696:	8b 45 08             	mov    0x8(%ebp),%eax
c0105699:	8b 00                	mov    (%eax),%eax
}
c010569b:	5d                   	pop    %ebp
c010569c:	c3                   	ret    

c010569d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010569d:	55                   	push   %ebp
c010569e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01056a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056a6:	89 10                	mov    %edx,(%eax)
}
c01056a8:	90                   	nop
c01056a9:	5d                   	pop    %ebp
c01056aa:	c3                   	ret    

c01056ab <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01056ab:	55                   	push   %ebp
c01056ac:	89 e5                	mov    %esp,%ebp
c01056ae:	83 ec 10             	sub    $0x10,%esp
c01056b1:	c7 45 fc ec 50 12 c0 	movl   $0xc01250ec,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01056b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01056bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01056be:	89 50 04             	mov    %edx,0x4(%eax)
c01056c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01056c4:	8b 50 04             	mov    0x4(%eax),%edx
c01056c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01056ca:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01056cc:	c7 05 f4 50 12 c0 00 	movl   $0x0,0xc01250f4
c01056d3:	00 00 00 
}
c01056d6:	90                   	nop
c01056d7:	c9                   	leave  
c01056d8:	c3                   	ret    

c01056d9 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01056d9:	55                   	push   %ebp
c01056da:	89 e5                	mov    %esp,%ebp
c01056dc:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01056df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01056e3:	75 24                	jne    c0105709 <default_init_memmap+0x30>
c01056e5:	c7 44 24 0c c1 a7 10 	movl   $0xc010a7c1,0xc(%esp)
c01056ec:	c0 
c01056ed:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c01056f4:	c0 
c01056f5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01056fc:	00 
c01056fd:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0105704:	e8 f9 ac ff ff       	call   c0100402 <__panic>
    struct Page *p = base;
c0105709:	8b 45 08             	mov    0x8(%ebp),%eax
c010570c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010570f:	e9 c1 00 00 00       	jmp    c01057d5 <default_init_memmap+0xfc>
        assert(PageReserved(p));
c0105714:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105717:	83 c0 04             	add    $0x4,%eax
c010571a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0105721:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105724:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105727:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010572a:	0f a3 10             	bt     %edx,(%eax)
c010572d:	19 c0                	sbb    %eax,%eax
c010572f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
c0105732:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105736:	0f 95 c0             	setne  %al
c0105739:	0f b6 c0             	movzbl %al,%eax
c010573c:	85 c0                	test   %eax,%eax
c010573e:	75 24                	jne    c0105764 <default_init_memmap+0x8b>
c0105740:	c7 44 24 0c f2 a7 10 	movl   $0xc010a7f2,0xc(%esp)
c0105747:	c0 
c0105748:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c010574f:	c0 
c0105750:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0105757:	00 
c0105758:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c010575f:	e8 9e ac ff ff       	call   c0100402 <__panic>
        ClearPageReserved(p);       //flag : PG_reserve to 0 
c0105764:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105767:	83 c0 04             	add    $0x4,%eax
c010576a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0105771:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105774:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105777:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010577a:	0f b3 10             	btr    %edx,(%eax)
        SetPageProperty(p);         //flag : PG_property to 1
c010577d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105780:	83 c0 04             	add    $0x4,%eax
c0105783:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c010578a:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010578d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105790:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105793:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;            //property
c0105796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105799:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);         //ref
c01057a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01057a7:	00 
c01057a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057ab:	89 04 24             	mov    %eax,(%esp)
c01057ae:	e8 ea fe ff ff       	call   c010569d <set_page_ref>
        memset(&(p->page_link), 0, sizeof(list_entry_t));
c01057b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057b6:	83 c0 0c             	add    $0xc,%eax
c01057b9:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
c01057c0:	00 
c01057c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01057c8:	00 
c01057c9:	89 04 24             	mov    %eax,(%esp)
c01057cc:	e8 38 33 00 00       	call   c0108b09 <memset>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01057d1:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01057d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057d8:	c1 e0 05             	shl    $0x5,%eax
c01057db:	89 c2                	mov    %eax,%edx
c01057dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e0:	01 d0                	add    %edx,%eax
c01057e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01057e5:	0f 85 29 ff ff ff    	jne    c0105714 <default_init_memmap+0x3b>
        SetPageProperty(p);         //flag : PG_property to 1
        p->property = 0;            //property
        set_page_ref(p, 0);         //ref
        memset(&(p->page_link), 0, sizeof(list_entry_t));
    }
    list_add_before(&free_list, &(base->page_link)); //lowAddr-->highAddr page
c01057eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ee:	83 c0 0c             	add    $0xc,%eax
c01057f1:	c7 45 ec ec 50 12 c0 	movl   $0xc01250ec,-0x14(%ebp)
c01057f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01057fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057fe:	8b 00                	mov    (%eax),%eax
c0105800:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105803:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0105806:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105809:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010580c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010580f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105812:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105815:	89 10                	mov    %edx,(%eax)
c0105817:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010581a:	8b 10                	mov    (%eax),%edx
c010581c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010581f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105822:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105825:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105828:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010582b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010582e:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105831:	89 10                	mov    %edx,(%eax)
    base->property = n;
c0105833:	8b 45 08             	mov    0x8(%ebp),%eax
c0105836:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105839:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c010583c:	8b 15 f4 50 12 c0    	mov    0xc01250f4,%edx
c0105842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105845:	01 d0                	add    %edx,%eax
c0105847:	a3 f4 50 12 c0       	mov    %eax,0xc01250f4
}
c010584c:	90                   	nop
c010584d:	c9                   	leave  
c010584e:	c3                   	ret    

c010584f <default_alloc_pages>:

/*first fit*/
static struct Page *
default_alloc_pages(size_t n) {
c010584f:	55                   	push   %ebp
c0105850:	89 e5                	mov    %esp,%ebp
c0105852:	53                   	push   %ebx
c0105853:	83 ec 64             	sub    $0x64,%esp
    assert(n > 0);
c0105856:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010585a:	75 24                	jne    c0105880 <default_alloc_pages+0x31>
c010585c:	c7 44 24 0c c1 a7 10 	movl   $0xc010a7c1,0xc(%esp)
c0105863:	c0 
c0105864:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c010586b:	c0 
c010586c:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
c0105873:	00 
c0105874:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c010587b:	e8 82 ab ff ff       	call   c0100402 <__panic>
    if (n > nr_free) {
c0105880:	a1 f4 50 12 c0       	mov    0xc01250f4,%eax
c0105885:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105888:	73 0a                	jae    c0105894 <default_alloc_pages+0x45>
        return NULL;
c010588a:	b8 00 00 00 00       	mov    $0x0,%eax
c010588f:	e9 8d 01 00 00       	jmp    c0105a21 <default_alloc_pages+0x1d2>
    }
    struct Page *page = NULL;
c0105894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c010589b:	c7 45 f0 ec 50 12 c0 	movl   $0xc01250ec,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01058a2:	eb 1c                	jmp    c01058c0 <default_alloc_pages+0x71>
        struct Page *p = le2page(le, page_link);
c01058a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058a7:	83 e8 0c             	sub    $0xc,%eax
c01058aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n) {
c01058ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058b0:	8b 40 08             	mov    0x8(%eax),%eax
c01058b3:	3b 45 08             	cmp    0x8(%ebp),%eax
c01058b6:	72 08                	jb     c01058c0 <default_alloc_pages+0x71>
            page = p;
c01058b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01058be:	eb 18                	jmp    c01058d8 <default_alloc_pages+0x89>
c01058c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01058c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01058c9:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01058cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058cf:	81 7d f0 ec 50 12 c0 	cmpl   $0xc01250ec,-0x10(%ebp)
c01058d6:	75 cc                	jne    c01058a4 <default_alloc_pages+0x55>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c01058d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01058dc:	0f 84 3c 01 00 00    	je     c0105a1e <default_alloc_pages+0x1cf>
        list_del(&(page->page_link));
c01058e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058e5:	83 c0 0c             	add    $0xc,%eax
c01058e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01058eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058ee:	8b 40 04             	mov    0x4(%eax),%eax
c01058f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01058f4:	8b 12                	mov    (%edx),%edx
c01058f6:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01058f9:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01058fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01058ff:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105902:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105905:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105908:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010590b:	89 10                	mov    %edx,(%eax)
       
        if (page->property > n) {
c010590d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105910:	8b 40 08             	mov    0x8(%eax),%eax
c0105913:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105916:	76 6c                	jbe    c0105984 <default_alloc_pages+0x135>
            struct Page *p = page + n;
c0105918:	8b 45 08             	mov    0x8(%ebp),%eax
c010591b:	c1 e0 05             	shl    $0x5,%eax
c010591e:	89 c2                	mov    %eax,%edx
c0105920:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105923:	01 d0                	add    %edx,%eax
c0105925:	89 45 dc             	mov    %eax,-0x24(%ebp)
            p->property = page->property - n;
c0105928:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010592b:	8b 40 08             	mov    0x8(%eax),%eax
c010592e:	2b 45 08             	sub    0x8(%ebp),%eax
c0105931:	89 c2                	mov    %eax,%edx
c0105933:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105936:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(page->page_link.prev, &(p->page_link));
c0105939:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010593c:	8d 50 0c             	lea    0xc(%eax),%edx
c010593f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105942:	8b 40 0c             	mov    0xc(%eax),%eax
c0105945:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105948:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010594b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010594e:	8b 40 04             	mov    0x4(%eax),%eax
c0105951:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105954:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0105957:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010595a:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010595d:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105960:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105963:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105966:	89 10                	mov    %edx,(%eax)
c0105968:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010596b:	8b 10                	mov    (%eax),%edx
c010596d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105970:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105973:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105976:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105979:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010597c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010597f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105982:	89 10                	mov    %edx,(%eax)
            
        }
        
        page->property = n;
c0105984:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105987:	8b 55 08             	mov    0x8(%ebp),%edx
c010598a:	89 50 08             	mov    %edx,0x8(%eax)
        for (int looper = 0; looper < n; looper++){
c010598d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105994:	eb 49                	jmp    c01059df <default_alloc_pages+0x190>
            SetPageReserved(&(page[looper]));
c0105996:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105999:	c1 e0 05             	shl    $0x5,%eax
c010599c:	89 c2                	mov    %eax,%edx
c010599e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059a1:	01 d0                	add    %edx,%eax
c01059a3:	83 c0 04             	add    $0x4,%eax
c01059a6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c01059ad:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01059b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01059b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01059b6:	0f ab 10             	bts    %edx,(%eax)
            ClearPageProperty(&(page[looper]));
c01059b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059bc:	c1 e0 05             	shl    $0x5,%eax
c01059bf:	89 c2                	mov    %eax,%edx
c01059c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059c4:	01 d0                	add    %edx,%eax
c01059c6:	83 c0 04             	add    $0x4,%eax
c01059c9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c01059d0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01059d3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01059d6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01059d9:	0f b3 10             	btr    %edx,(%eax)
            list_add_after(page->page_link.prev, &(p->page_link));
            
        }
        
        page->property = n;
        for (int looper = 0; looper < n; looper++){
c01059dc:	ff 45 ec             	incl   -0x14(%ebp)
c01059df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059e2:	3b 45 08             	cmp    0x8(%ebp),%eax
c01059e5:	72 af                	jb     c0105996 <default_alloc_pages+0x147>
            SetPageReserved(&(page[looper]));
            ClearPageProperty(&(page[looper]));
            // page_ref_inc(&(page[looper]));
        }
        
        nr_free -= n;
c01059e7:	a1 f4 50 12 c0       	mov    0xc01250f4,%eax
c01059ec:	2b 45 08             	sub    0x8(%ebp),%eax
c01059ef:	a3 f4 50 12 c0       	mov    %eax,0xc01250f4
        memset(page2kva(page), 0, PGSIZE * page->property);
c01059f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059f7:	8b 40 08             	mov    0x8(%eax),%eax
c01059fa:	c1 e0 0c             	shl    $0xc,%eax
c01059fd:	89 c3                	mov    %eax,%ebx
c01059ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a02:	89 04 24             	mov    %eax,(%esp)
c0105a05:	e8 35 fc ff ff       	call   c010563f <page2kva>
c0105a0a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0105a0e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105a15:	00 
c0105a16:	89 04 24             	mov    %eax,(%esp)
c0105a19:	e8 eb 30 00 00       	call   c0108b09 <memset>
    }
    return page;
c0105a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a21:	83 c4 64             	add    $0x64,%esp
c0105a24:	5b                   	pop    %ebx
c0105a25:	5d                   	pop    %ebp
c0105a26:	c3                   	ret    

c0105a27 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0105a27:	55                   	push   %ebp
c0105a28:	89 e5                	mov    %esp,%ebp
c0105a2a:	81 ec b8 00 00 00    	sub    $0xb8,%esp
    cprintf("   prev = %p,\n", base->page_link.prev);
    cprintf("   next = %p\n", base->page_link.next);
    cprintf("  },\n");
    cprintf("}\n");
#endif
    assert(n > 0);
c0105a30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105a34:	75 24                	jne    c0105a5a <default_free_pages+0x33>
c0105a36:	c7 44 24 0c c1 a7 10 	movl   $0xc010a7c1,0xc(%esp)
c0105a3d:	c0 
c0105a3e:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0105a45:	c0 
c0105a46:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0105a4d:	00 
c0105a4e:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0105a55:	e8 a8 a9 ff ff       	call   c0100402 <__panic>
    struct Page *p = base;
c0105a5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105a60:	e9 c5 00 00 00       	jmp    c0105b2a <default_free_pages+0x103>
        assert(PageReserved(p) && !PageProperty(p));
c0105a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a68:	83 c0 04             	add    $0x4,%eax
c0105a6b:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
c0105a72:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105a75:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105a78:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105a7b:	0f a3 10             	bt     %edx,(%eax)
c0105a7e:	19 c0                	sbb    %eax,%eax
c0105a80:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
c0105a83:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
c0105a87:	0f 95 c0             	setne  %al
c0105a8a:	0f b6 c0             	movzbl %al,%eax
c0105a8d:	85 c0                	test   %eax,%eax
c0105a8f:	74 2c                	je     c0105abd <default_free_pages+0x96>
c0105a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a94:	83 c0 04             	add    $0x4,%eax
c0105a97:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0105a9e:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105aa1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105aa4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105aa7:	0f a3 10             	bt     %edx,(%eax)
c0105aaa:	19 c0                	sbb    %eax,%eax
c0105aac:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0105aaf:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0105ab3:	0f 95 c0             	setne  %al
c0105ab6:	0f b6 c0             	movzbl %al,%eax
c0105ab9:	85 c0                	test   %eax,%eax
c0105abb:	74 24                	je     c0105ae1 <default_free_pages+0xba>
c0105abd:	c7 44 24 0c 04 a8 10 	movl   $0xc010a804,0xc(%esp)
c0105ac4:	c0 
c0105ac5:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0105acc:	c0 
c0105acd:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0105ad4:	00 
c0105ad5:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0105adc:	e8 21 a9 ff ff       	call   c0100402 <__panic>
        SetPageProperty(p);
c0105ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ae4:	83 c0 04             	add    $0x4,%eax
c0105ae7:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0105aee:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105af1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105af4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105af7:	0f ab 10             	bts    %edx,(%eax)
        ClearPageReserved(p);
c0105afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105afd:	83 c0 04             	add    $0x4,%eax
c0105b00:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0105b07:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105b0a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105b0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105b10:	0f b3 10             	btr    %edx,(%eax)
        set_page_ref(p, 0);
c0105b13:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105b1a:	00 
c0105b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b1e:	89 04 24             	mov    %eax,(%esp)
c0105b21:	e8 77 fb ff ff       	call   c010569d <set_page_ref>
    cprintf("  },\n");
    cprintf("}\n");
#endif
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0105b26:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0105b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b2d:	c1 e0 05             	shl    $0x5,%eax
c0105b30:	89 c2                	mov    %eax,%edx
c0105b32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b35:	01 d0                	add    %edx,%eax
c0105b37:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105b3a:	0f 85 25 ff ff ff    	jne    c0105a65 <default_free_pages+0x3e>
        assert(PageReserved(p) && !PageProperty(p));
        SetPageProperty(p);
        ClearPageReserved(p);
        set_page_ref(p, 0);
    }
    base->property = n;
c0105b40:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b43:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105b46:	89 50 08             	mov    %edx,0x8(%eax)
c0105b49:	c7 45 dc ec 50 12 c0 	movl   $0xc01250ec,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105b50:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b53:	8b 40 04             	mov    0x4(%eax),%eax
    
    list_entry_t *le = list_next(&free_list);
c0105b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *last = NULL, *next = 0xFFFFFFFF;
c0105b59:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105b60:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    while (le != &free_list) {
c0105b67:	eb 44                	jmp    c0105bad <default_free_pages+0x186>
        p = le2page(le, page_link);
c0105b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b6c:	83 e8 0c             	sub    $0xc,%eax
c0105b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b75:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0105b78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105b7b:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0105b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)

        if (p < base && p >= last ) last = p;
c0105b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b84:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105b87:	73 0e                	jae    c0105b97 <default_free_pages+0x170>
c0105b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b8c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105b8f:	72 06                	jb     c0105b97 <default_free_pages+0x170>
c0105b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b94:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p > base && p <= next) next = p;
c0105b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b9a:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105b9d:	76 0e                	jbe    c0105bad <default_free_pages+0x186>
c0105b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ba2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0105ba5:	77 06                	ja     c0105bad <default_free_pages+0x186>
c0105ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105baa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    }
    base->property = n;
    
    list_entry_t *le = list_next(&free_list);
    struct Page *last = NULL, *next = 0xFFFFFFFF;
    while (le != &free_list) {
c0105bad:	81 7d f0 ec 50 12 c0 	cmpl   $0xc01250ec,-0x10(%ebp)
c0105bb4:	75 b3                	jne    c0105b69 <default_free_pages+0x142>

        if (p < base && p >= last ) last = p;
        if (p > base && p <= next) next = p;
    }

    if (last < base && last != NULL){
c0105bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bb9:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105bbc:	0f 83 b9 00 00 00    	jae    c0105c7b <default_free_pages+0x254>
c0105bc2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105bc6:	0f 84 af 00 00 00    	je     c0105c7b <default_free_pages+0x254>
        list_add_after(&(last->page_link), &(base->page_link));
c0105bcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bcf:	83 c0 0c             	add    $0xc,%eax
c0105bd2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105bd5:	83 c2 0c             	add    $0xc,%edx
c0105bd8:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0105bdb:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0105bde:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105be1:	8b 40 04             	mov    0x4(%eax),%eax
c0105be4:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105be7:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0105bea:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105bed:	89 55 98             	mov    %edx,-0x68(%ebp)
c0105bf0:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105bf3:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105bf6:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0105bf9:	89 10                	mov    %edx,(%eax)
c0105bfb:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105bfe:	8b 10                	mov    (%eax),%edx
c0105c00:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105c03:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105c06:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105c09:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105c0c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105c0f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105c12:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105c15:	89 10                	mov    %edx,(%eax)
        if ((last + last->property) == base){
c0105c17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c1a:	8b 40 08             	mov    0x8(%eax),%eax
c0105c1d:	c1 e0 05             	shl    $0x5,%eax
c0105c20:	89 c2                	mov    %eax,%edx
c0105c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c25:	01 d0                	add    %edx,%eax
c0105c27:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105c2a:	75 4f                	jne    c0105c7b <default_free_pages+0x254>
            last->property += base->property;
c0105c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c2f:	8b 50 08             	mov    0x8(%eax),%edx
c0105c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c35:	8b 40 08             	mov    0x8(%eax),%eax
c0105c38:	01 c2                	add    %eax,%edx
c0105c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c3d:	89 50 08             	mov    %edx,0x8(%eax)
            list_del(&(base->page_link));
c0105c40:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c43:	83 c0 0c             	add    $0xc,%eax
c0105c46:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0105c49:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105c4c:	8b 40 04             	mov    0x4(%eax),%eax
c0105c4f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105c52:	8b 12                	mov    (%edx),%edx
c0105c54:	89 55 90             	mov    %edx,-0x70(%ebp)
c0105c57:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0105c5a:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105c5d:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0105c60:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105c63:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105c66:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105c69:	89 10                	mov    %edx,(%eax)
            base->property = 0;
c0105c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            base = last;
c0105c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c78:	89 45 08             	mov    %eax,0x8(%ebp)
        }
    }

    if (base < next && next != 0xFFFFFFFF){
c0105c7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c7e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0105c81:	0f 83 de 00 00 00    	jae    c0105d65 <default_free_pages+0x33e>
c0105c87:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
c0105c8b:	0f 84 d4 00 00 00    	je     c0105d65 <default_free_pages+0x33e>
        if (last > base || last == NULL)
c0105c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c94:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105c97:	77 06                	ja     c0105c9f <default_free_pages+0x278>
c0105c99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105c9d:	75 56                	jne    c0105cf5 <default_free_pages+0x2ce>
            list_add_before(&(next->page_link), &(base->page_link));
c0105c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca2:	83 c0 0c             	add    $0xc,%eax
c0105ca5:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105ca8:	83 c2 0c             	add    $0xc,%edx
c0105cab:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105cae:	89 45 88             	mov    %eax,-0x78(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0105cb1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105cb4:	8b 00                	mov    (%eax),%eax
c0105cb6:	8b 55 88             	mov    -0x78(%ebp),%edx
c0105cb9:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0105cbc:	89 45 80             	mov    %eax,-0x80(%ebp)
c0105cbf:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105cc2:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105cc8:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0105cce:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105cd1:	89 10                	mov    %edx,(%eax)
c0105cd3:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0105cd9:	8b 10                	mov    (%eax),%edx
c0105cdb:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105cde:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105ce1:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105ce4:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0105cea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105ced:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105cf0:	8b 55 80             	mov    -0x80(%ebp),%edx
c0105cf3:	89 10                	mov    %edx,(%eax)
        if ((base + base->property) == next){
c0105cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf8:	8b 40 08             	mov    0x8(%eax),%eax
c0105cfb:	c1 e0 05             	shl    $0x5,%eax
c0105cfe:	89 c2                	mov    %eax,%edx
c0105d00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d03:	01 d0                	add    %edx,%eax
c0105d05:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0105d08:	75 5b                	jne    c0105d65 <default_free_pages+0x33e>
            base->property += next->property;
c0105d0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d0d:	8b 50 08             	mov    0x8(%eax),%edx
c0105d10:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d13:	8b 40 08             	mov    0x8(%eax),%eax
c0105d16:	01 c2                	add    %eax,%edx
c0105d18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d1b:	89 50 08             	mov    %edx,0x8(%eax)
            list_del(&(next->page_link));
c0105d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d21:	83 c0 0c             	add    $0xc,%eax
c0105d24:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0105d27:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105d2a:	8b 40 04             	mov    0x4(%eax),%eax
c0105d2d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105d30:	8b 12                	mov    (%edx),%edx
c0105d32:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
c0105d38:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0105d3e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0105d44:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c0105d4a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105d4d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0105d53:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c0105d59:	89 10                	mov    %edx,(%eax)
            next->property = 0;
c0105d5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        }
    }

    if (last == NULL && next == 0xFFFFFFFF){
c0105d65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105d69:	75 76                	jne    c0105de1 <default_free_pages+0x3ba>
c0105d6b:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
c0105d6f:	75 70                	jne    c0105de1 <default_free_pages+0x3ba>
        list_add_after(&free_list, &(base->page_link));
c0105d71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d74:	83 c0 0c             	add    $0xc,%eax
c0105d77:	c7 45 c0 ec 50 12 c0 	movl   $0xc01250ec,-0x40(%ebp)
c0105d7e:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0105d84:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105d87:	8b 40 04             	mov    0x4(%eax),%eax
c0105d8a:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c0105d90:	89 95 6c ff ff ff    	mov    %edx,-0x94(%ebp)
c0105d96:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105d99:	89 95 68 ff ff ff    	mov    %edx,-0x98(%ebp)
c0105d9f:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105da5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
c0105dab:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c0105db1:	89 10                	mov    %edx,(%eax)
c0105db3:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
c0105db9:	8b 10                	mov    (%eax),%edx
c0105dbb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c0105dc1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105dc4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0105dca:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
c0105dd0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105dd3:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0105dd9:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
c0105ddf:	89 10                	mov    %edx,(%eax)
    }
    
    nr_free += n;
c0105de1:	8b 15 f4 50 12 c0    	mov    0xc01250f4,%edx
c0105de7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dea:	01 d0                	add    %edx,%eax
c0105dec:	a3 f4 50 12 c0       	mov    %eax,0xc01250f4
}
c0105df1:	90                   	nop
c0105df2:	c9                   	leave  
c0105df3:	c3                   	ret    

c0105df4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0105df4:	55                   	push   %ebp
c0105df5:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0105df7:	a1 f4 50 12 c0       	mov    0xc01250f4,%eax
}
c0105dfc:	5d                   	pop    %ebp
c0105dfd:	c3                   	ret    

c0105dfe <basic_check>:

static void
basic_check(void) {
c0105dfe:	55                   	push   %ebp
c0105dff:	89 e5                	mov    %esp,%ebp
c0105e01:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0105e04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e14:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0105e17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105e1e:	e8 c2 0e 00 00       	call   c0106ce5 <alloc_pages>
c0105e23:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105e2a:	75 24                	jne    c0105e50 <basic_check+0x52>
c0105e2c:	c7 44 24 0c 28 a8 10 	movl   $0xc010a828,0xc(%esp)
c0105e33:	c0 
c0105e34:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0105e3b:	c0 
c0105e3c:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0105e43:	00 
c0105e44:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0105e4b:	e8 b2 a5 ff ff       	call   c0100402 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105e50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105e57:	e8 89 0e 00 00       	call   c0106ce5 <alloc_pages>
c0105e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105e63:	75 24                	jne    c0105e89 <basic_check+0x8b>
c0105e65:	c7 44 24 0c 44 a8 10 	movl   $0xc010a844,0xc(%esp)
c0105e6c:	c0 
c0105e6d:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0105e74:	c0 
c0105e75:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0105e7c:	00 
c0105e7d:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0105e84:	e8 79 a5 ff ff       	call   c0100402 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105e89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105e90:	e8 50 0e 00 00       	call   c0106ce5 <alloc_pages>
c0105e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105e9c:	75 24                	jne    c0105ec2 <basic_check+0xc4>
c0105e9e:	c7 44 24 0c 60 a8 10 	movl   $0xc010a860,0xc(%esp)
c0105ea5:	c0 
c0105ea6:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0105ead:	c0 
c0105eae:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0105eb5:	00 
c0105eb6:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0105ebd:	e8 40 a5 ff ff       	call   c0100402 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0105ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ec5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105ec8:	74 10                	je     c0105eda <basic_check+0xdc>
c0105eca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ecd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105ed0:	74 08                	je     c0105eda <basic_check+0xdc>
c0105ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ed5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105ed8:	75 24                	jne    c0105efe <basic_check+0x100>
c0105eda:	c7 44 24 0c 7c a8 10 	movl   $0xc010a87c,0xc(%esp)
c0105ee1:	c0 
c0105ee2:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0105ee9:	c0 
c0105eea:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0105ef1:	00 
c0105ef2:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0105ef9:	e8 04 a5 ff ff       	call   c0100402 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0105efe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f01:	89 04 24             	mov    %eax,(%esp)
c0105f04:	e8 8a f7 ff ff       	call   c0105693 <page_ref>
c0105f09:	85 c0                	test   %eax,%eax
c0105f0b:	75 1e                	jne    c0105f2b <basic_check+0x12d>
c0105f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f10:	89 04 24             	mov    %eax,(%esp)
c0105f13:	e8 7b f7 ff ff       	call   c0105693 <page_ref>
c0105f18:	85 c0                	test   %eax,%eax
c0105f1a:	75 0f                	jne    c0105f2b <basic_check+0x12d>
c0105f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f1f:	89 04 24             	mov    %eax,(%esp)
c0105f22:	e8 6c f7 ff ff       	call   c0105693 <page_ref>
c0105f27:	85 c0                	test   %eax,%eax
c0105f29:	74 24                	je     c0105f4f <basic_check+0x151>
c0105f2b:	c7 44 24 0c a0 a8 10 	movl   $0xc010a8a0,0xc(%esp)
c0105f32:	c0 
c0105f33:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0105f3a:	c0 
c0105f3b:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0105f42:	00 
c0105f43:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0105f4a:	e8 b3 a4 ff ff       	call   c0100402 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0105f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f52:	89 04 24             	mov    %eax,(%esp)
c0105f55:	e8 cf f6 ff ff       	call   c0105629 <page2pa>
c0105f5a:	8b 15 80 4f 12 c0    	mov    0xc0124f80,%edx
c0105f60:	c1 e2 0c             	shl    $0xc,%edx
c0105f63:	39 d0                	cmp    %edx,%eax
c0105f65:	72 24                	jb     c0105f8b <basic_check+0x18d>
c0105f67:	c7 44 24 0c dc a8 10 	movl   $0xc010a8dc,0xc(%esp)
c0105f6e:	c0 
c0105f6f:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0105f76:	c0 
c0105f77:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0105f7e:	00 
c0105f7f:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0105f86:	e8 77 a4 ff ff       	call   c0100402 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0105f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f8e:	89 04 24             	mov    %eax,(%esp)
c0105f91:	e8 93 f6 ff ff       	call   c0105629 <page2pa>
c0105f96:	8b 15 80 4f 12 c0    	mov    0xc0124f80,%edx
c0105f9c:	c1 e2 0c             	shl    $0xc,%edx
c0105f9f:	39 d0                	cmp    %edx,%eax
c0105fa1:	72 24                	jb     c0105fc7 <basic_check+0x1c9>
c0105fa3:	c7 44 24 0c f9 a8 10 	movl   $0xc010a8f9,0xc(%esp)
c0105faa:	c0 
c0105fab:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0105fb2:	c0 
c0105fb3:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0105fba:	00 
c0105fbb:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0105fc2:	e8 3b a4 ff ff       	call   c0100402 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0105fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fca:	89 04 24             	mov    %eax,(%esp)
c0105fcd:	e8 57 f6 ff ff       	call   c0105629 <page2pa>
c0105fd2:	8b 15 80 4f 12 c0    	mov    0xc0124f80,%edx
c0105fd8:	c1 e2 0c             	shl    $0xc,%edx
c0105fdb:	39 d0                	cmp    %edx,%eax
c0105fdd:	72 24                	jb     c0106003 <basic_check+0x205>
c0105fdf:	c7 44 24 0c 16 a9 10 	movl   $0xc010a916,0xc(%esp)
c0105fe6:	c0 
c0105fe7:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0105fee:	c0 
c0105fef:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0105ff6:	00 
c0105ff7:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0105ffe:	e8 ff a3 ff ff       	call   c0100402 <__panic>

    list_entry_t free_list_store = free_list;
c0106003:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0106008:	8b 15 f0 50 12 c0    	mov    0xc01250f0,%edx
c010600e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106011:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106014:	c7 45 e4 ec 50 12 c0 	movl   $0xc01250ec,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010601b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010601e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106021:	89 50 04             	mov    %edx,0x4(%eax)
c0106024:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106027:	8b 50 04             	mov    0x4(%eax),%edx
c010602a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010602d:	89 10                	mov    %edx,(%eax)
c010602f:	c7 45 d8 ec 50 12 c0 	movl   $0xc01250ec,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106036:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106039:	8b 40 04             	mov    0x4(%eax),%eax
c010603c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010603f:	0f 94 c0             	sete   %al
c0106042:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0106045:	85 c0                	test   %eax,%eax
c0106047:	75 24                	jne    c010606d <basic_check+0x26f>
c0106049:	c7 44 24 0c 33 a9 10 	movl   $0xc010a933,0xc(%esp)
c0106050:	c0 
c0106051:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0106058:	c0 
c0106059:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c0106060:	00 
c0106061:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106068:	e8 95 a3 ff ff       	call   c0100402 <__panic>

    unsigned int nr_free_store = nr_free;
c010606d:	a1 f4 50 12 c0       	mov    0xc01250f4,%eax
c0106072:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0106075:	c7 05 f4 50 12 c0 00 	movl   $0x0,0xc01250f4
c010607c:	00 00 00 

    assert(alloc_page() == NULL);
c010607f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106086:	e8 5a 0c 00 00       	call   c0106ce5 <alloc_pages>
c010608b:	85 c0                	test   %eax,%eax
c010608d:	74 24                	je     c01060b3 <basic_check+0x2b5>
c010608f:	c7 44 24 0c 4a a9 10 	movl   $0xc010a94a,0xc(%esp)
c0106096:	c0 
c0106097:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c010609e:	c0 
c010609f:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01060a6:	00 
c01060a7:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c01060ae:	e8 4f a3 ff ff       	call   c0100402 <__panic>

    free_page(p0);
c01060b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01060ba:	00 
c01060bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060be:	89 04 24             	mov    %eax,(%esp)
c01060c1:	e8 a4 0c 00 00       	call   c0106d6a <free_pages>
    free_page(p1);
c01060c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01060cd:	00 
c01060ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060d1:	89 04 24             	mov    %eax,(%esp)
c01060d4:	e8 91 0c 00 00       	call   c0106d6a <free_pages>
    free_page(p2);
c01060d9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01060e0:	00 
c01060e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060e4:	89 04 24             	mov    %eax,(%esp)
c01060e7:	e8 7e 0c 00 00       	call   c0106d6a <free_pages>
    assert(nr_free == 3);
c01060ec:	a1 f4 50 12 c0       	mov    0xc01250f4,%eax
c01060f1:	83 f8 03             	cmp    $0x3,%eax
c01060f4:	74 24                	je     c010611a <basic_check+0x31c>
c01060f6:	c7 44 24 0c 5f a9 10 	movl   $0xc010a95f,0xc(%esp)
c01060fd:	c0 
c01060fe:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0106105:	c0 
c0106106:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c010610d:	00 
c010610e:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106115:	e8 e8 a2 ff ff       	call   c0100402 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010611a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106121:	e8 bf 0b 00 00       	call   c0106ce5 <alloc_pages>
c0106126:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106129:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010612d:	75 24                	jne    c0106153 <basic_check+0x355>
c010612f:	c7 44 24 0c 28 a8 10 	movl   $0xc010a828,0xc(%esp)
c0106136:	c0 
c0106137:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c010613e:	c0 
c010613f:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0106146:	00 
c0106147:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c010614e:	e8 af a2 ff ff       	call   c0100402 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0106153:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010615a:	e8 86 0b 00 00       	call   c0106ce5 <alloc_pages>
c010615f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106166:	75 24                	jne    c010618c <basic_check+0x38e>
c0106168:	c7 44 24 0c 44 a8 10 	movl   $0xc010a844,0xc(%esp)
c010616f:	c0 
c0106170:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0106177:	c0 
c0106178:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010617f:	00 
c0106180:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106187:	e8 76 a2 ff ff       	call   c0100402 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010618c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106193:	e8 4d 0b 00 00       	call   c0106ce5 <alloc_pages>
c0106198:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010619b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010619f:	75 24                	jne    c01061c5 <basic_check+0x3c7>
c01061a1:	c7 44 24 0c 60 a8 10 	movl   $0xc010a860,0xc(%esp)
c01061a8:	c0 
c01061a9:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c01061b0:	c0 
c01061b1:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01061b8:	00 
c01061b9:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c01061c0:	e8 3d a2 ff ff       	call   c0100402 <__panic>

    assert(alloc_page() == NULL);
c01061c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01061cc:	e8 14 0b 00 00       	call   c0106ce5 <alloc_pages>
c01061d1:	85 c0                	test   %eax,%eax
c01061d3:	74 24                	je     c01061f9 <basic_check+0x3fb>
c01061d5:	c7 44 24 0c 4a a9 10 	movl   $0xc010a94a,0xc(%esp)
c01061dc:	c0 
c01061dd:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c01061e4:	c0 
c01061e5:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c01061ec:	00 
c01061ed:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c01061f4:	e8 09 a2 ff ff       	call   c0100402 <__panic>

    free_page(p0);
c01061f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106200:	00 
c0106201:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106204:	89 04 24             	mov    %eax,(%esp)
c0106207:	e8 5e 0b 00 00       	call   c0106d6a <free_pages>
c010620c:	c7 45 e8 ec 50 12 c0 	movl   $0xc01250ec,-0x18(%ebp)
c0106213:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106216:	8b 40 04             	mov    0x4(%eax),%eax
c0106219:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010621c:	0f 94 c0             	sete   %al
c010621f:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0106222:	85 c0                	test   %eax,%eax
c0106224:	74 24                	je     c010624a <basic_check+0x44c>
c0106226:	c7 44 24 0c 6c a9 10 	movl   $0xc010a96c,0xc(%esp)
c010622d:	c0 
c010622e:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0106235:	c0 
c0106236:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c010623d:	00 
c010623e:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106245:	e8 b8 a1 ff ff       	call   c0100402 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010624a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106251:	e8 8f 0a 00 00       	call   c0106ce5 <alloc_pages>
c0106256:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106259:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010625c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010625f:	74 24                	je     c0106285 <basic_check+0x487>
c0106261:	c7 44 24 0c 84 a9 10 	movl   $0xc010a984,0xc(%esp)
c0106268:	c0 
c0106269:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0106270:	c0 
c0106271:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0106278:	00 
c0106279:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106280:	e8 7d a1 ff ff       	call   c0100402 <__panic>
    assert(alloc_page() == NULL);
c0106285:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010628c:	e8 54 0a 00 00       	call   c0106ce5 <alloc_pages>
c0106291:	85 c0                	test   %eax,%eax
c0106293:	74 24                	je     c01062b9 <basic_check+0x4bb>
c0106295:	c7 44 24 0c 4a a9 10 	movl   $0xc010a94a,0xc(%esp)
c010629c:	c0 
c010629d:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c01062a4:	c0 
c01062a5:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01062ac:	00 
c01062ad:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c01062b4:	e8 49 a1 ff ff       	call   c0100402 <__panic>

    assert(nr_free == 0);
c01062b9:	a1 f4 50 12 c0       	mov    0xc01250f4,%eax
c01062be:	85 c0                	test   %eax,%eax
c01062c0:	74 24                	je     c01062e6 <basic_check+0x4e8>
c01062c2:	c7 44 24 0c 9d a9 10 	movl   $0xc010a99d,0xc(%esp)
c01062c9:	c0 
c01062ca:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c01062d1:	c0 
c01062d2:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c01062d9:	00 
c01062da:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c01062e1:	e8 1c a1 ff ff       	call   c0100402 <__panic>
    free_list = free_list_store;
c01062e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01062e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01062ec:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec
c01062f1:	89 15 f0 50 12 c0    	mov    %edx,0xc01250f0
    nr_free = nr_free_store;
c01062f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01062fa:	a3 f4 50 12 c0       	mov    %eax,0xc01250f4

    free_page(p);
c01062ff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106306:	00 
c0106307:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010630a:	89 04 24             	mov    %eax,(%esp)
c010630d:	e8 58 0a 00 00       	call   c0106d6a <free_pages>
    free_page(p1);
c0106312:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106319:	00 
c010631a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010631d:	89 04 24             	mov    %eax,(%esp)
c0106320:	e8 45 0a 00 00       	call   c0106d6a <free_pages>
    free_page(p2);
c0106325:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010632c:	00 
c010632d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106330:	89 04 24             	mov    %eax,(%esp)
c0106333:	e8 32 0a 00 00       	call   c0106d6a <free_pages>
}
c0106338:	90                   	nop
c0106339:	c9                   	leave  
c010633a:	c3                   	ret    

c010633b <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010633b:	55                   	push   %ebp
c010633c:	89 e5                	mov    %esp,%ebp
c010633e:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0106344:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010634b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0106352:	c7 45 ec ec 50 12 c0 	movl   $0xc01250ec,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106359:	eb 6a                	jmp    c01063c5 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c010635b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010635e:	83 e8 0c             	sub    $0xc,%eax
c0106361:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106367:	83 c0 04             	add    $0x4,%eax
c010636a:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0106371:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106374:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106377:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010637a:	0f a3 10             	bt     %edx,(%eax)
c010637d:	19 c0                	sbb    %eax,%eax
c010637f:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0106382:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0106386:	0f 95 c0             	setne  %al
c0106389:	0f b6 c0             	movzbl %al,%eax
c010638c:	85 c0                	test   %eax,%eax
c010638e:	75 24                	jne    c01063b4 <default_check+0x79>
c0106390:	c7 44 24 0c aa a9 10 	movl   $0xc010a9aa,0xc(%esp)
c0106397:	c0 
c0106398:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c010639f:	c0 
c01063a0:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c01063a7:	00 
c01063a8:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c01063af:	e8 4e a0 ff ff       	call   c0100402 <__panic>
        count ++, total += p->property;
c01063b4:	ff 45 f4             	incl   -0xc(%ebp)
c01063b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063ba:	8b 50 08             	mov    0x8(%eax),%edx
c01063bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01063c0:	01 d0                	add    %edx,%eax
c01063c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01063c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01063c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01063cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01063ce:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01063d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01063d4:	81 7d ec ec 50 12 c0 	cmpl   $0xc01250ec,-0x14(%ebp)
c01063db:	0f 85 7a ff ff ff    	jne    c010635b <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01063e1:	e8 b7 09 00 00       	call   c0106d9d <nr_free_pages>
c01063e6:	89 c2                	mov    %eax,%edx
c01063e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01063eb:	39 c2                	cmp    %eax,%edx
c01063ed:	74 24                	je     c0106413 <default_check+0xd8>
c01063ef:	c7 44 24 0c ba a9 10 	movl   $0xc010a9ba,0xc(%esp)
c01063f6:	c0 
c01063f7:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c01063fe:	c0 
c01063ff:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0106406:	00 
c0106407:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c010640e:	e8 ef 9f ff ff       	call   c0100402 <__panic>

    basic_check();
c0106413:	e8 e6 f9 ff ff       	call   c0105dfe <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0106418:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010641f:	e8 c1 08 00 00       	call   c0106ce5 <alloc_pages>
c0106424:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c0106427:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010642b:	75 24                	jne    c0106451 <default_check+0x116>
c010642d:	c7 44 24 0c d3 a9 10 	movl   $0xc010a9d3,0xc(%esp)
c0106434:	c0 
c0106435:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c010643c:	c0 
c010643d:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c0106444:	00 
c0106445:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c010644c:	e8 b1 9f ff ff       	call   c0100402 <__panic>
    assert(!PageProperty(p0));
c0106451:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106454:	83 c0 04             	add    $0x4,%eax
c0106457:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c010645e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106461:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106464:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106467:	0f a3 10             	bt     %edx,(%eax)
c010646a:	19 c0                	sbb    %eax,%eax
c010646c:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c010646f:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0106473:	0f 95 c0             	setne  %al
c0106476:	0f b6 c0             	movzbl %al,%eax
c0106479:	85 c0                	test   %eax,%eax
c010647b:	74 24                	je     c01064a1 <default_check+0x166>
c010647d:	c7 44 24 0c de a9 10 	movl   $0xc010a9de,0xc(%esp)
c0106484:	c0 
c0106485:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c010648c:	c0 
c010648d:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0106494:	00 
c0106495:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c010649c:	e8 61 9f ff ff       	call   c0100402 <__panic>

    list_entry_t free_list_store = free_list;
c01064a1:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c01064a6:	8b 15 f0 50 12 c0    	mov    0xc01250f0,%edx
c01064ac:	89 45 80             	mov    %eax,-0x80(%ebp)
c01064af:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01064b2:	c7 45 d0 ec 50 12 c0 	movl   $0xc01250ec,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01064b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01064bc:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01064bf:	89 50 04             	mov    %edx,0x4(%eax)
c01064c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01064c5:	8b 50 04             	mov    0x4(%eax),%edx
c01064c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01064cb:	89 10                	mov    %edx,(%eax)
c01064cd:	c7 45 d8 ec 50 12 c0 	movl   $0xc01250ec,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01064d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01064d7:	8b 40 04             	mov    0x4(%eax),%eax
c01064da:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01064dd:	0f 94 c0             	sete   %al
c01064e0:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01064e3:	85 c0                	test   %eax,%eax
c01064e5:	75 24                	jne    c010650b <default_check+0x1d0>
c01064e7:	c7 44 24 0c 33 a9 10 	movl   $0xc010a933,0xc(%esp)
c01064ee:	c0 
c01064ef:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c01064f6:	c0 
c01064f7:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c01064fe:	00 
c01064ff:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106506:	e8 f7 9e ff ff       	call   c0100402 <__panic>
    assert(alloc_page() == NULL);
c010650b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106512:	e8 ce 07 00 00       	call   c0106ce5 <alloc_pages>
c0106517:	85 c0                	test   %eax,%eax
c0106519:	74 24                	je     c010653f <default_check+0x204>
c010651b:	c7 44 24 0c 4a a9 10 	movl   $0xc010a94a,0xc(%esp)
c0106522:	c0 
c0106523:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c010652a:	c0 
c010652b:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c0106532:	00 
c0106533:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c010653a:	e8 c3 9e ff ff       	call   c0100402 <__panic>

    unsigned int nr_free_store = nr_free;
c010653f:	a1 f4 50 12 c0       	mov    0xc01250f4,%eax
c0106544:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0106547:	c7 05 f4 50 12 c0 00 	movl   $0x0,0xc01250f4
c010654e:	00 00 00 

    free_pages(p0 + 2, 3);
c0106551:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106554:	83 c0 40             	add    $0x40,%eax
c0106557:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010655e:	00 
c010655f:	89 04 24             	mov    %eax,(%esp)
c0106562:	e8 03 08 00 00       	call   c0106d6a <free_pages>
    assert(alloc_pages(4) == NULL);
c0106567:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010656e:	e8 72 07 00 00       	call   c0106ce5 <alloc_pages>
c0106573:	85 c0                	test   %eax,%eax
c0106575:	74 24                	je     c010659b <default_check+0x260>
c0106577:	c7 44 24 0c f0 a9 10 	movl   $0xc010a9f0,0xc(%esp)
c010657e:	c0 
c010657f:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0106586:	c0 
c0106587:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c010658e:	00 
c010658f:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106596:	e8 67 9e ff ff       	call   c0100402 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010659b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010659e:	83 c0 40             	add    $0x40,%eax
c01065a1:	83 c0 04             	add    $0x4,%eax
c01065a4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01065ab:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01065ae:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01065b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01065b4:	0f a3 10             	bt     %edx,(%eax)
c01065b7:	19 c0                	sbb    %eax,%eax
c01065b9:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01065bc:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01065c0:	0f 95 c0             	setne  %al
c01065c3:	0f b6 c0             	movzbl %al,%eax
c01065c6:	85 c0                	test   %eax,%eax
c01065c8:	74 0e                	je     c01065d8 <default_check+0x29d>
c01065ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01065cd:	83 c0 40             	add    $0x40,%eax
c01065d0:	8b 40 08             	mov    0x8(%eax),%eax
c01065d3:	83 f8 03             	cmp    $0x3,%eax
c01065d6:	74 24                	je     c01065fc <default_check+0x2c1>
c01065d8:	c7 44 24 0c 08 aa 10 	movl   $0xc010aa08,0xc(%esp)
c01065df:	c0 
c01065e0:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c01065e7:	c0 
c01065e8:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c01065ef:	00 
c01065f0:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c01065f7:	e8 06 9e ff ff       	call   c0100402 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01065fc:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0106603:	e8 dd 06 00 00       	call   c0106ce5 <alloc_pages>
c0106608:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010660b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c010660f:	75 24                	jne    c0106635 <default_check+0x2fa>
c0106611:	c7 44 24 0c 34 aa 10 	movl   $0xc010aa34,0xc(%esp)
c0106618:	c0 
c0106619:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0106620:	c0 
c0106621:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c0106628:	00 
c0106629:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106630:	e8 cd 9d ff ff       	call   c0100402 <__panic>
    assert(alloc_page() == NULL);
c0106635:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010663c:	e8 a4 06 00 00       	call   c0106ce5 <alloc_pages>
c0106641:	85 c0                	test   %eax,%eax
c0106643:	74 24                	je     c0106669 <default_check+0x32e>
c0106645:	c7 44 24 0c 4a a9 10 	movl   $0xc010a94a,0xc(%esp)
c010664c:	c0 
c010664d:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0106654:	c0 
c0106655:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c010665c:	00 
c010665d:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106664:	e8 99 9d ff ff       	call   c0100402 <__panic>
    assert(p0 + 2 == p1);
c0106669:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010666c:	83 c0 40             	add    $0x40,%eax
c010666f:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0106672:	74 24                	je     c0106698 <default_check+0x35d>
c0106674:	c7 44 24 0c 52 aa 10 	movl   $0xc010aa52,0xc(%esp)
c010667b:	c0 
c010667c:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0106683:	c0 
c0106684:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c010668b:	00 
c010668c:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106693:	e8 6a 9d ff ff       	call   c0100402 <__panic>

    p2 = p0 + 1;
c0106698:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010669b:	83 c0 20             	add    $0x20,%eax
c010669e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c01066a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01066a8:	00 
c01066a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066ac:	89 04 24             	mov    %eax,(%esp)
c01066af:	e8 b6 06 00 00       	call   c0106d6a <free_pages>
    free_pages(p1, 3);
c01066b4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01066bb:	00 
c01066bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01066bf:	89 04 24             	mov    %eax,(%esp)
c01066c2:	e8 a3 06 00 00       	call   c0106d6a <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01066c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066ca:	83 c0 04             	add    $0x4,%eax
c01066cd:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c01066d4:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01066d7:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01066da:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01066dd:	0f a3 10             	bt     %edx,(%eax)
c01066e0:	19 c0                	sbb    %eax,%eax
c01066e2:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c01066e5:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c01066e9:	0f 95 c0             	setne  %al
c01066ec:	0f b6 c0             	movzbl %al,%eax
c01066ef:	85 c0                	test   %eax,%eax
c01066f1:	74 0b                	je     c01066fe <default_check+0x3c3>
c01066f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066f6:	8b 40 08             	mov    0x8(%eax),%eax
c01066f9:	83 f8 01             	cmp    $0x1,%eax
c01066fc:	74 24                	je     c0106722 <default_check+0x3e7>
c01066fe:	c7 44 24 0c 60 aa 10 	movl   $0xc010aa60,0xc(%esp)
c0106705:	c0 
c0106706:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c010670d:	c0 
c010670e:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c0106715:	00 
c0106716:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c010671d:	e8 e0 9c ff ff       	call   c0100402 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0106722:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106725:	83 c0 04             	add    $0x4,%eax
c0106728:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c010672f:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106732:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0106735:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0106738:	0f a3 10             	bt     %edx,(%eax)
c010673b:	19 c0                	sbb    %eax,%eax
c010673d:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0106740:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0106744:	0f 95 c0             	setne  %al
c0106747:	0f b6 c0             	movzbl %al,%eax
c010674a:	85 c0                	test   %eax,%eax
c010674c:	74 0b                	je     c0106759 <default_check+0x41e>
c010674e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106751:	8b 40 08             	mov    0x8(%eax),%eax
c0106754:	83 f8 03             	cmp    $0x3,%eax
c0106757:	74 24                	je     c010677d <default_check+0x442>
c0106759:	c7 44 24 0c 88 aa 10 	movl   $0xc010aa88,0xc(%esp)
c0106760:	c0 
c0106761:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0106768:	c0 
c0106769:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
c0106770:	00 
c0106771:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106778:	e8 85 9c ff ff       	call   c0100402 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010677d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106784:	e8 5c 05 00 00       	call   c0106ce5 <alloc_pages>
c0106789:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010678c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010678f:	83 e8 20             	sub    $0x20,%eax
c0106792:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0106795:	74 24                	je     c01067bb <default_check+0x480>
c0106797:	c7 44 24 0c ae aa 10 	movl   $0xc010aaae,0xc(%esp)
c010679e:	c0 
c010679f:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c01067a6:	c0 
c01067a7:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
c01067ae:	00 
c01067af:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c01067b6:	e8 47 9c ff ff       	call   c0100402 <__panic>
    free_page(p0);
c01067bb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01067c2:	00 
c01067c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01067c6:	89 04 24             	mov    %eax,(%esp)
c01067c9:	e8 9c 05 00 00       	call   c0106d6a <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01067ce:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01067d5:	e8 0b 05 00 00       	call   c0106ce5 <alloc_pages>
c01067da:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01067dd:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01067e0:	83 c0 20             	add    $0x20,%eax
c01067e3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01067e6:	74 24                	je     c010680c <default_check+0x4d1>
c01067e8:	c7 44 24 0c cc aa 10 	movl   $0xc010aacc,0xc(%esp)
c01067ef:	c0 
c01067f0:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c01067f7:	c0 
c01067f8:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c01067ff:	00 
c0106800:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106807:	e8 f6 9b ff ff       	call   c0100402 <__panic>

    free_pages(p0, 2);
c010680c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0106813:	00 
c0106814:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106817:	89 04 24             	mov    %eax,(%esp)
c010681a:	e8 4b 05 00 00       	call   c0106d6a <free_pages>
    free_page(p2);
c010681f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106826:	00 
c0106827:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010682a:	89 04 24             	mov    %eax,(%esp)
c010682d:	e8 38 05 00 00       	call   c0106d6a <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0106832:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0106839:	e8 a7 04 00 00       	call   c0106ce5 <alloc_pages>
c010683e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106841:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106845:	75 24                	jne    c010686b <default_check+0x530>
c0106847:	c7 44 24 0c ec aa 10 	movl   $0xc010aaec,0xc(%esp)
c010684e:	c0 
c010684f:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0106856:	c0 
c0106857:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
c010685e:	00 
c010685f:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106866:	e8 97 9b ff ff       	call   c0100402 <__panic>
    assert(alloc_page() == NULL);
c010686b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106872:	e8 6e 04 00 00       	call   c0106ce5 <alloc_pages>
c0106877:	85 c0                	test   %eax,%eax
c0106879:	74 24                	je     c010689f <default_check+0x564>
c010687b:	c7 44 24 0c 4a a9 10 	movl   $0xc010a94a,0xc(%esp)
c0106882:	c0 
c0106883:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c010688a:	c0 
c010688b:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
c0106892:	00 
c0106893:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c010689a:	e8 63 9b ff ff       	call   c0100402 <__panic>

    assert(nr_free == 0);
c010689f:	a1 f4 50 12 c0       	mov    0xc01250f4,%eax
c01068a4:	85 c0                	test   %eax,%eax
c01068a6:	74 24                	je     c01068cc <default_check+0x591>
c01068a8:	c7 44 24 0c 9d a9 10 	movl   $0xc010a99d,0xc(%esp)
c01068af:	c0 
c01068b0:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c01068b7:	c0 
c01068b8:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c01068bf:	00 
c01068c0:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c01068c7:	e8 36 9b ff ff       	call   c0100402 <__panic>
    nr_free = nr_free_store;
c01068cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01068cf:	a3 f4 50 12 c0       	mov    %eax,0xc01250f4

    free_list = free_list_store;
c01068d4:	8b 45 80             	mov    -0x80(%ebp),%eax
c01068d7:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01068da:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec
c01068df:	89 15 f0 50 12 c0    	mov    %edx,0xc01250f0
    free_pages(p0, 5);
c01068e5:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01068ec:	00 
c01068ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01068f0:	89 04 24             	mov    %eax,(%esp)
c01068f3:	e8 72 04 00 00       	call   c0106d6a <free_pages>

    le = &free_list;
c01068f8:	c7 45 ec ec 50 12 c0 	movl   $0xc01250ec,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01068ff:	eb 1c                	jmp    c010691d <default_check+0x5e2>
        struct Page *p = le2page(le, page_link);
c0106901:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106904:	83 e8 0c             	sub    $0xc,%eax
c0106907:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c010690a:	ff 4d f4             	decl   -0xc(%ebp)
c010690d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106910:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106913:	8b 40 08             	mov    0x8(%eax),%eax
c0106916:	29 c2                	sub    %eax,%edx
c0106918:	89 d0                	mov    %edx,%eax
c010691a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010691d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106920:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106923:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106926:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0106929:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010692c:	81 7d ec ec 50 12 c0 	cmpl   $0xc01250ec,-0x14(%ebp)
c0106933:	75 cc                	jne    c0106901 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0106935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106939:	74 24                	je     c010695f <default_check+0x624>
c010693b:	c7 44 24 0c 0a ab 10 	movl   $0xc010ab0a,0xc(%esp)
c0106942:	c0 
c0106943:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c010694a:	c0 
c010694b:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
c0106952:	00 
c0106953:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c010695a:	e8 a3 9a ff ff       	call   c0100402 <__panic>
    assert(total == 0);
c010695f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106963:	74 24                	je     c0106989 <default_check+0x64e>
c0106965:	c7 44 24 0c 15 ab 10 	movl   $0xc010ab15,0xc(%esp)
c010696c:	c0 
c010696d:	c7 44 24 08 c7 a7 10 	movl   $0xc010a7c7,0x8(%esp)
c0106974:	c0 
c0106975:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c010697c:	00 
c010697d:	c7 04 24 dc a7 10 c0 	movl   $0xc010a7dc,(%esp)
c0106984:	e8 79 9a ff ff       	call   c0100402 <__panic>
}
c0106989:	90                   	nop
c010698a:	c9                   	leave  
c010698b:	c3                   	ret    

c010698c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010698c:	55                   	push   %ebp
c010698d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010698f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106992:	8b 15 00 51 12 c0    	mov    0xc0125100,%edx
c0106998:	29 d0                	sub    %edx,%eax
c010699a:	c1 f8 05             	sar    $0x5,%eax
}
c010699d:	5d                   	pop    %ebp
c010699e:	c3                   	ret    

c010699f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010699f:	55                   	push   %ebp
c01069a0:	89 e5                	mov    %esp,%ebp
c01069a2:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01069a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01069a8:	89 04 24             	mov    %eax,(%esp)
c01069ab:	e8 dc ff ff ff       	call   c010698c <page2ppn>
c01069b0:	c1 e0 0c             	shl    $0xc,%eax
}
c01069b3:	c9                   	leave  
c01069b4:	c3                   	ret    

c01069b5 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01069b5:	55                   	push   %ebp
c01069b6:	89 e5                	mov    %esp,%ebp
c01069b8:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01069bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01069be:	c1 e8 0c             	shr    $0xc,%eax
c01069c1:	89 c2                	mov    %eax,%edx
c01069c3:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01069c8:	39 c2                	cmp    %eax,%edx
c01069ca:	72 1c                	jb     c01069e8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01069cc:	c7 44 24 08 50 ab 10 	movl   $0xc010ab50,0x8(%esp)
c01069d3:	c0 
c01069d4:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01069db:	00 
c01069dc:	c7 04 24 6f ab 10 c0 	movl   $0xc010ab6f,(%esp)
c01069e3:	e8 1a 9a ff ff       	call   c0100402 <__panic>
    }
    return &pages[PPN(pa)];
c01069e8:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c01069ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01069f0:	c1 ea 0c             	shr    $0xc,%edx
c01069f3:	c1 e2 05             	shl    $0x5,%edx
c01069f6:	01 d0                	add    %edx,%eax
}
c01069f8:	c9                   	leave  
c01069f9:	c3                   	ret    

c01069fa <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01069fa:	55                   	push   %ebp
c01069fb:	89 e5                	mov    %esp,%ebp
c01069fd:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0106a00:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a03:	89 04 24             	mov    %eax,(%esp)
c0106a06:	e8 94 ff ff ff       	call   c010699f <page2pa>
c0106a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a11:	c1 e8 0c             	shr    $0xc,%eax
c0106a14:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106a17:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106a1c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0106a1f:	72 23                	jb     c0106a44 <page2kva+0x4a>
c0106a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a24:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106a28:	c7 44 24 08 80 ab 10 	movl   $0xc010ab80,0x8(%esp)
c0106a2f:	c0 
c0106a30:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0106a37:	00 
c0106a38:	c7 04 24 6f ab 10 c0 	movl   $0xc010ab6f,(%esp)
c0106a3f:	e8 be 99 ff ff       	call   c0100402 <__panic>
c0106a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a47:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0106a4c:	c9                   	leave  
c0106a4d:	c3                   	ret    

c0106a4e <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0106a4e:	55                   	push   %ebp
c0106a4f:	89 e5                	mov    %esp,%ebp
c0106a51:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0106a54:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106a5a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0106a61:	77 23                	ja     c0106a86 <kva2page+0x38>
c0106a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a66:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106a6a:	c7 44 24 08 a4 ab 10 	movl   $0xc010aba4,0x8(%esp)
c0106a71:	c0 
c0106a72:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106a79:	00 
c0106a7a:	c7 04 24 6f ab 10 c0 	movl   $0xc010ab6f,(%esp)
c0106a81:	e8 7c 99 ff ff       	call   c0100402 <__panic>
c0106a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a89:	05 00 00 00 40       	add    $0x40000000,%eax
c0106a8e:	89 04 24             	mov    %eax,(%esp)
c0106a91:	e8 1f ff ff ff       	call   c01069b5 <pa2page>
}
c0106a96:	c9                   	leave  
c0106a97:	c3                   	ret    

c0106a98 <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c0106a98:	55                   	push   %ebp
c0106a99:	89 e5                	mov    %esp,%ebp
c0106a9b:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106aa1:	83 e0 01             	and    $0x1,%eax
c0106aa4:	85 c0                	test   %eax,%eax
c0106aa6:	75 1c                	jne    c0106ac4 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106aa8:	c7 44 24 08 c8 ab 10 	movl   $0xc010abc8,0x8(%esp)
c0106aaf:	c0 
c0106ab0:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106ab7:	00 
c0106ab8:	c7 04 24 6f ab 10 c0 	movl   $0xc010ab6f,(%esp)
c0106abf:	e8 3e 99 ff ff       	call   c0100402 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ac7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106acc:	89 04 24             	mov    %eax,(%esp)
c0106acf:	e8 e1 fe ff ff       	call   c01069b5 <pa2page>
}
c0106ad4:	c9                   	leave  
c0106ad5:	c3                   	ret    

c0106ad6 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0106ad6:	55                   	push   %ebp
c0106ad7:	89 e5                	mov    %esp,%ebp
c0106ad9:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0106adc:	8b 45 08             	mov    0x8(%ebp),%eax
c0106adf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106ae4:	89 04 24             	mov    %eax,(%esp)
c0106ae7:	e8 c9 fe ff ff       	call   c01069b5 <pa2page>
}
c0106aec:	c9                   	leave  
c0106aed:	c3                   	ret    

c0106aee <page_ref>:

static inline int
page_ref(struct Page *page) {
c0106aee:	55                   	push   %ebp
c0106aef:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0106af1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106af4:	8b 00                	mov    (%eax),%eax
}
c0106af6:	5d                   	pop    %ebp
c0106af7:	c3                   	ret    

c0106af8 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0106af8:	55                   	push   %ebp
c0106af9:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0106afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0106afe:	8b 00                	mov    (%eax),%eax
c0106b00:	8d 50 01             	lea    0x1(%eax),%edx
c0106b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b06:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b0b:	8b 00                	mov    (%eax),%eax
}
c0106b0d:	5d                   	pop    %ebp
c0106b0e:	c3                   	ret    

c0106b0f <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0106b0f:	55                   	push   %ebp
c0106b10:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0106b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b15:	8b 00                	mov    (%eax),%eax
c0106b17:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b1d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b22:	8b 00                	mov    (%eax),%eax
}
c0106b24:	5d                   	pop    %ebp
c0106b25:	c3                   	ret    

c0106b26 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0106b26:	55                   	push   %ebp
c0106b27:	89 e5                	mov    %esp,%ebp
c0106b29:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0106b2c:	9c                   	pushf  
c0106b2d:	58                   	pop    %eax
c0106b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0106b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0106b34:	25 00 02 00 00       	and    $0x200,%eax
c0106b39:	85 c0                	test   %eax,%eax
c0106b3b:	74 0c                	je     c0106b49 <__intr_save+0x23>
        intr_disable();
c0106b3d:	e8 e3 b5 ff ff       	call   c0102125 <intr_disable>
        return 1;
c0106b42:	b8 01 00 00 00       	mov    $0x1,%eax
c0106b47:	eb 05                	jmp    c0106b4e <__intr_save+0x28>
    }
    return 0;
c0106b49:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106b4e:	c9                   	leave  
c0106b4f:	c3                   	ret    

c0106b50 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0106b50:	55                   	push   %ebp
c0106b51:	89 e5                	mov    %esp,%ebp
c0106b53:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0106b56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106b5a:	74 05                	je     c0106b61 <__intr_restore+0x11>
        intr_enable();
c0106b5c:	e8 bd b5 ff ff       	call   c010211e <intr_enable>
    }
}
c0106b61:	90                   	nop
c0106b62:	c9                   	leave  
c0106b63:	c3                   	ret    

c0106b64 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0106b64:	55                   	push   %ebp
c0106b65:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0106b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b6a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0106b6d:	b8 23 00 00 00       	mov    $0x23,%eax
c0106b72:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0106b74:	b8 23 00 00 00       	mov    $0x23,%eax
c0106b79:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0106b7b:	b8 10 00 00 00       	mov    $0x10,%eax
c0106b80:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0106b82:	b8 10 00 00 00       	mov    $0x10,%eax
c0106b87:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0106b89:	b8 10 00 00 00       	mov    $0x10,%eax
c0106b8e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0106b90:	ea 97 6b 10 c0 08 00 	ljmp   $0x8,$0xc0106b97
}
c0106b97:	90                   	nop
c0106b98:	5d                   	pop    %ebp
c0106b99:	c3                   	ret    

c0106b9a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0106b9a:	55                   	push   %ebp
c0106b9b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0106b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ba0:	a3 a4 4f 12 c0       	mov    %eax,0xc0124fa4
}
c0106ba5:	90                   	nop
c0106ba6:	5d                   	pop    %ebp
c0106ba7:	c3                   	ret    

c0106ba8 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0106ba8:	55                   	push   %ebp
c0106ba9:	89 e5                	mov    %esp,%ebp
c0106bab:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0106bae:	b8 00 10 12 c0       	mov    $0xc0121000,%eax
c0106bb3:	89 04 24             	mov    %eax,(%esp)
c0106bb6:	e8 df ff ff ff       	call   c0106b9a <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0106bbb:	66 c7 05 a8 4f 12 c0 	movw   $0x10,0xc0124fa8
c0106bc2:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0106bc4:	66 c7 05 68 1a 12 c0 	movw   $0x68,0xc0121a68
c0106bcb:	68 00 
c0106bcd:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c0106bd2:	0f b7 c0             	movzwl %ax,%eax
c0106bd5:	66 a3 6a 1a 12 c0    	mov    %ax,0xc0121a6a
c0106bdb:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c0106be0:	c1 e8 10             	shr    $0x10,%eax
c0106be3:	a2 6c 1a 12 c0       	mov    %al,0xc0121a6c
c0106be8:	0f b6 05 6d 1a 12 c0 	movzbl 0xc0121a6d,%eax
c0106bef:	24 f0                	and    $0xf0,%al
c0106bf1:	0c 09                	or     $0x9,%al
c0106bf3:	a2 6d 1a 12 c0       	mov    %al,0xc0121a6d
c0106bf8:	0f b6 05 6d 1a 12 c0 	movzbl 0xc0121a6d,%eax
c0106bff:	24 ef                	and    $0xef,%al
c0106c01:	a2 6d 1a 12 c0       	mov    %al,0xc0121a6d
c0106c06:	0f b6 05 6d 1a 12 c0 	movzbl 0xc0121a6d,%eax
c0106c0d:	24 9f                	and    $0x9f,%al
c0106c0f:	a2 6d 1a 12 c0       	mov    %al,0xc0121a6d
c0106c14:	0f b6 05 6d 1a 12 c0 	movzbl 0xc0121a6d,%eax
c0106c1b:	0c 80                	or     $0x80,%al
c0106c1d:	a2 6d 1a 12 c0       	mov    %al,0xc0121a6d
c0106c22:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106c29:	24 f0                	and    $0xf0,%al
c0106c2b:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106c30:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106c37:	24 ef                	and    $0xef,%al
c0106c39:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106c3e:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106c45:	24 df                	and    $0xdf,%al
c0106c47:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106c4c:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106c53:	0c 40                	or     $0x40,%al
c0106c55:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106c5a:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106c61:	24 7f                	and    $0x7f,%al
c0106c63:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106c68:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c0106c6d:	c1 e8 18             	shr    $0x18,%eax
c0106c70:	a2 6f 1a 12 c0       	mov    %al,0xc0121a6f

    // reload all segment registers
    lgdt(&gdt_pd);
c0106c75:	c7 04 24 70 1a 12 c0 	movl   $0xc0121a70,(%esp)
c0106c7c:	e8 e3 fe ff ff       	call   c0106b64 <lgdt>
c0106c81:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0106c87:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0106c8b:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0106c8e:	90                   	nop
c0106c8f:	c9                   	leave  
c0106c90:	c3                   	ret    

c0106c91 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0106c91:	55                   	push   %ebp
c0106c92:	89 e5                	mov    %esp,%ebp
c0106c94:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0106c97:	c7 05 f8 50 12 c0 34 	movl   $0xc010ab34,0xc01250f8
c0106c9e:	ab 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0106ca1:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106ca6:	8b 00                	mov    (%eax),%eax
c0106ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cac:	c7 04 24 f4 ab 10 c0 	movl   $0xc010abf4,(%esp)
c0106cb3:	e8 f3 95 ff ff       	call   c01002ab <cprintf>
    pmm_manager->init();
c0106cb8:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106cbd:	8b 40 04             	mov    0x4(%eax),%eax
c0106cc0:	ff d0                	call   *%eax
}
c0106cc2:	90                   	nop
c0106cc3:	c9                   	leave  
c0106cc4:	c3                   	ret    

c0106cc5 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0106cc5:	55                   	push   %ebp
c0106cc6:	89 e5                	mov    %esp,%ebp
c0106cc8:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0106ccb:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106cd0:	8b 40 08             	mov    0x8(%eax),%eax
c0106cd3:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106cd6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106cda:	8b 55 08             	mov    0x8(%ebp),%edx
c0106cdd:	89 14 24             	mov    %edx,(%esp)
c0106ce0:	ff d0                	call   *%eax
}
c0106ce2:	90                   	nop
c0106ce3:	c9                   	leave  
c0106ce4:	c3                   	ret    

c0106ce5 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0106ce5:	55                   	push   %ebp
c0106ce6:	89 e5                	mov    %esp,%ebp
c0106ce8:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0106ceb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0106cf2:	e8 2f fe ff ff       	call   c0106b26 <__intr_save>
c0106cf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0106cfa:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106cff:	8b 40 0c             	mov    0xc(%eax),%eax
c0106d02:	8b 55 08             	mov    0x8(%ebp),%edx
c0106d05:	89 14 24             	mov    %edx,(%esp)
c0106d08:	ff d0                	call   *%eax
c0106d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0106d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d10:	89 04 24             	mov    %eax,(%esp)
c0106d13:	e8 38 fe ff ff       	call   c0106b50 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0106d18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106d1c:	75 47                	jne    c0106d65 <alloc_pages+0x80>
c0106d1e:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0106d22:	77 41                	ja     c0106d65 <alloc_pages+0x80>
c0106d24:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0106d29:	85 c0                	test   %eax,%eax
c0106d2b:	74 38                	je     c0106d65 <alloc_pages+0x80>
         
         extern struct mm_struct *check_mm_struct;
         cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
c0106d2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d30:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d3b:	c7 04 24 0c ac 10 c0 	movl   $0xc010ac0c,(%esp)
c0106d42:	e8 64 95 ff ff       	call   c01002ab <cprintf>
         swap_out(check_mm_struct, n, 0);
c0106d47:	8b 55 08             	mov    0x8(%ebp),%edx
c0106d4a:	a1 10 50 12 c0       	mov    0xc0125010,%eax
c0106d4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106d56:	00 
c0106d57:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106d5b:	89 04 24             	mov    %eax,(%esp)
c0106d5e:	e8 fc d4 ff ff       	call   c010425f <swap_out>
    }
c0106d63:	eb 8d                	jmp    c0106cf2 <alloc_pages+0xd>
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0106d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106d68:	c9                   	leave  
c0106d69:	c3                   	ret    

c0106d6a <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0106d6a:	55                   	push   %ebp
c0106d6b:	89 e5                	mov    %esp,%ebp
c0106d6d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0106d70:	e8 b1 fd ff ff       	call   c0106b26 <__intr_save>
c0106d75:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0106d78:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106d7d:	8b 40 10             	mov    0x10(%eax),%eax
c0106d80:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106d83:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106d87:	8b 55 08             	mov    0x8(%ebp),%edx
c0106d8a:	89 14 24             	mov    %edx,(%esp)
c0106d8d:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0106d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d92:	89 04 24             	mov    %eax,(%esp)
c0106d95:	e8 b6 fd ff ff       	call   c0106b50 <__intr_restore>
}
c0106d9a:	90                   	nop
c0106d9b:	c9                   	leave  
c0106d9c:	c3                   	ret    

c0106d9d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0106d9d:	55                   	push   %ebp
c0106d9e:	89 e5                	mov    %esp,%ebp
c0106da0:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0106da3:	e8 7e fd ff ff       	call   c0106b26 <__intr_save>
c0106da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0106dab:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106db0:	8b 40 14             	mov    0x14(%eax),%eax
c0106db3:	ff d0                	call   *%eax
c0106db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0106db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106dbb:	89 04 24             	mov    %eax,(%esp)
c0106dbe:	e8 8d fd ff ff       	call   c0106b50 <__intr_restore>
    return ret;
c0106dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0106dc6:	c9                   	leave  
c0106dc7:	c3                   	ret    

c0106dc8 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0106dc8:	55                   	push   %ebp
c0106dc9:	89 e5                	mov    %esp,%ebp
c0106dcb:	57                   	push   %edi
c0106dcc:	56                   	push   %esi
c0106dcd:	53                   	push   %ebx
c0106dce:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0106dd4:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0106ddb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0106de2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0106de9:	c7 04 24 36 ac 10 c0 	movl   $0xc010ac36,(%esp)
c0106df0:	e8 b6 94 ff ff       	call   c01002ab <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0106df5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106dfc:	e9 22 01 00 00       	jmp    c0106f23 <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106e01:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106e04:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106e07:	89 d0                	mov    %edx,%eax
c0106e09:	c1 e0 02             	shl    $0x2,%eax
c0106e0c:	01 d0                	add    %edx,%eax
c0106e0e:	c1 e0 02             	shl    $0x2,%eax
c0106e11:	01 c8                	add    %ecx,%eax
c0106e13:	8b 50 08             	mov    0x8(%eax),%edx
c0106e16:	8b 40 04             	mov    0x4(%eax),%eax
c0106e19:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106e1c:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0106e1f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106e22:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106e25:	89 d0                	mov    %edx,%eax
c0106e27:	c1 e0 02             	shl    $0x2,%eax
c0106e2a:	01 d0                	add    %edx,%eax
c0106e2c:	c1 e0 02             	shl    $0x2,%eax
c0106e2f:	01 c8                	add    %ecx,%eax
c0106e31:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106e34:	8b 58 10             	mov    0x10(%eax),%ebx
c0106e37:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106e3a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0106e3d:	01 c8                	add    %ecx,%eax
c0106e3f:	11 da                	adc    %ebx,%edx
c0106e41:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0106e44:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0106e47:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106e4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106e4d:	89 d0                	mov    %edx,%eax
c0106e4f:	c1 e0 02             	shl    $0x2,%eax
c0106e52:	01 d0                	add    %edx,%eax
c0106e54:	c1 e0 02             	shl    $0x2,%eax
c0106e57:	01 c8                	add    %ecx,%eax
c0106e59:	83 c0 14             	add    $0x14,%eax
c0106e5c:	8b 00                	mov    (%eax),%eax
c0106e5e:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0106e61:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106e64:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106e67:	83 c0 ff             	add    $0xffffffff,%eax
c0106e6a:	83 d2 ff             	adc    $0xffffffff,%edx
c0106e6d:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0106e73:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0106e79:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106e7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106e7f:	89 d0                	mov    %edx,%eax
c0106e81:	c1 e0 02             	shl    $0x2,%eax
c0106e84:	01 d0                	add    %edx,%eax
c0106e86:	c1 e0 02             	shl    $0x2,%eax
c0106e89:	01 c8                	add    %ecx,%eax
c0106e8b:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106e8e:	8b 58 10             	mov    0x10(%eax),%ebx
c0106e91:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0106e94:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0106e98:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0106e9e:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0106ea4:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106ea8:	89 54 24 18          	mov    %edx,0x18(%esp)
c0106eac:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106eaf:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0106eb2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106eb6:	89 54 24 10          	mov    %edx,0x10(%esp)
c0106eba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0106ebe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0106ec2:	c7 04 24 40 ac 10 c0 	movl   $0xc010ac40,(%esp)
c0106ec9:	e8 dd 93 ff ff       	call   c01002ab <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0106ece:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106ed1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106ed4:	89 d0                	mov    %edx,%eax
c0106ed6:	c1 e0 02             	shl    $0x2,%eax
c0106ed9:	01 d0                	add    %edx,%eax
c0106edb:	c1 e0 02             	shl    $0x2,%eax
c0106ede:	01 c8                	add    %ecx,%eax
c0106ee0:	83 c0 14             	add    $0x14,%eax
c0106ee3:	8b 00                	mov    (%eax),%eax
c0106ee5:	83 f8 01             	cmp    $0x1,%eax
c0106ee8:	75 36                	jne    c0106f20 <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
c0106eea:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106eed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106ef0:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0106ef3:	77 2b                	ja     c0106f20 <page_init+0x158>
c0106ef5:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0106ef8:	72 05                	jb     c0106eff <page_init+0x137>
c0106efa:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0106efd:	73 21                	jae    c0106f20 <page_init+0x158>
c0106eff:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106f03:	77 1b                	ja     c0106f20 <page_init+0x158>
c0106f05:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106f09:	72 09                	jb     c0106f14 <page_init+0x14c>
c0106f0b:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0106f12:	77 0c                	ja     c0106f20 <page_init+0x158>
                maxpa = end;
c0106f14:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106f17:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106f1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106f1d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0106f20:	ff 45 dc             	incl   -0x24(%ebp)
c0106f23:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106f26:	8b 00                	mov    (%eax),%eax
c0106f28:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0106f2b:	0f 8f d0 fe ff ff    	jg     c0106e01 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0106f31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106f35:	72 1d                	jb     c0106f54 <page_init+0x18c>
c0106f37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106f3b:	77 09                	ja     c0106f46 <page_init+0x17e>
c0106f3d:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0106f44:	76 0e                	jbe    c0106f54 <page_init+0x18c>
        maxpa = KMEMSIZE;
c0106f46:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0106f4d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0106f54:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106f57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106f5a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0106f5e:	c1 ea 0c             	shr    $0xc,%edx
c0106f61:	a3 80 4f 12 c0       	mov    %eax,0xc0124f80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0106f66:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0106f6d:	b8 04 51 12 c0       	mov    $0xc0125104,%eax
c0106f72:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106f75:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106f78:	01 d0                	add    %edx,%eax
c0106f7a:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0106f7d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106f80:	ba 00 00 00 00       	mov    $0x0,%edx
c0106f85:	f7 75 ac             	divl   -0x54(%ebp)
c0106f88:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106f8b:	29 d0                	sub    %edx,%eax
c0106f8d:	a3 00 51 12 c0       	mov    %eax,0xc0125100

    for (i = 0; i < npage; i ++) {
c0106f92:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106f99:	eb 26                	jmp    c0106fc1 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0106f9b:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c0106fa0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106fa3:	c1 e2 05             	shl    $0x5,%edx
c0106fa6:	01 d0                	add    %edx,%eax
c0106fa8:	83 c0 04             	add    $0x4,%eax
c0106fab:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0106fb2:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0106fb5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0106fb8:	8b 55 90             	mov    -0x70(%ebp),%edx
c0106fbb:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0106fbe:	ff 45 dc             	incl   -0x24(%ebp)
c0106fc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106fc4:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106fc9:	39 c2                	cmp    %eax,%edx
c0106fcb:	72 ce                	jb     c0106f9b <page_init+0x1d3>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0106fcd:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106fd2:	c1 e0 05             	shl    $0x5,%eax
c0106fd5:	89 c2                	mov    %eax,%edx
c0106fd7:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c0106fdc:	01 d0                	add    %edx,%eax
c0106fde:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0106fe1:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0106fe8:	77 23                	ja     c010700d <page_init+0x245>
c0106fea:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106fed:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106ff1:	c7 44 24 08 a4 ab 10 	movl   $0xc010aba4,0x8(%esp)
c0106ff8:	c0 
c0106ff9:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0107000:	00 
c0107001:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107008:	e8 f5 93 ff ff       	call   c0100402 <__panic>
c010700d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0107010:	05 00 00 00 40       	add    $0x40000000,%eax
c0107015:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0107018:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010701f:	e9 61 01 00 00       	jmp    c0107185 <page_init+0x3bd>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0107024:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0107027:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010702a:	89 d0                	mov    %edx,%eax
c010702c:	c1 e0 02             	shl    $0x2,%eax
c010702f:	01 d0                	add    %edx,%eax
c0107031:	c1 e0 02             	shl    $0x2,%eax
c0107034:	01 c8                	add    %ecx,%eax
c0107036:	8b 50 08             	mov    0x8(%eax),%edx
c0107039:	8b 40 04             	mov    0x4(%eax),%eax
c010703c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010703f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0107042:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0107045:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107048:	89 d0                	mov    %edx,%eax
c010704a:	c1 e0 02             	shl    $0x2,%eax
c010704d:	01 d0                	add    %edx,%eax
c010704f:	c1 e0 02             	shl    $0x2,%eax
c0107052:	01 c8                	add    %ecx,%eax
c0107054:	8b 48 0c             	mov    0xc(%eax),%ecx
c0107057:	8b 58 10             	mov    0x10(%eax),%ebx
c010705a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010705d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107060:	01 c8                	add    %ecx,%eax
c0107062:	11 da                	adc    %ebx,%edx
c0107064:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0107067:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010706a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010706d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107070:	89 d0                	mov    %edx,%eax
c0107072:	c1 e0 02             	shl    $0x2,%eax
c0107075:	01 d0                	add    %edx,%eax
c0107077:	c1 e0 02             	shl    $0x2,%eax
c010707a:	01 c8                	add    %ecx,%eax
c010707c:	83 c0 14             	add    $0x14,%eax
c010707f:	8b 00                	mov    (%eax),%eax
c0107081:	83 f8 01             	cmp    $0x1,%eax
c0107084:	0f 85 f8 00 00 00    	jne    c0107182 <page_init+0x3ba>
            if (begin < freemem) {
c010708a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010708d:	ba 00 00 00 00       	mov    $0x0,%edx
c0107092:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107095:	72 17                	jb     c01070ae <page_init+0x2e6>
c0107097:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010709a:	77 05                	ja     c01070a1 <page_init+0x2d9>
c010709c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010709f:	76 0d                	jbe    c01070ae <page_init+0x2e6>
                begin = freemem;
c01070a1:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01070a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01070a7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01070ae:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01070b2:	72 1d                	jb     c01070d1 <page_init+0x309>
c01070b4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01070b8:	77 09                	ja     c01070c3 <page_init+0x2fb>
c01070ba:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01070c1:	76 0e                	jbe    c01070d1 <page_init+0x309>
                end = KMEMSIZE;
c01070c3:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01070ca:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01070d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01070d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01070d7:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01070da:	0f 87 a2 00 00 00    	ja     c0107182 <page_init+0x3ba>
c01070e0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01070e3:	72 09                	jb     c01070ee <page_init+0x326>
c01070e5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01070e8:	0f 83 94 00 00 00    	jae    c0107182 <page_init+0x3ba>
                begin = ROUNDUP(begin, PGSIZE);
c01070ee:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01070f5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01070f8:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01070fb:	01 d0                	add    %edx,%eax
c01070fd:	48                   	dec    %eax
c01070fe:	89 45 98             	mov    %eax,-0x68(%ebp)
c0107101:	8b 45 98             	mov    -0x68(%ebp),%eax
c0107104:	ba 00 00 00 00       	mov    $0x0,%edx
c0107109:	f7 75 9c             	divl   -0x64(%ebp)
c010710c:	8b 45 98             	mov    -0x68(%ebp),%eax
c010710f:	29 d0                	sub    %edx,%eax
c0107111:	ba 00 00 00 00       	mov    $0x0,%edx
c0107116:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107119:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010711c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010711f:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0107122:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0107125:	ba 00 00 00 00       	mov    $0x0,%edx
c010712a:	89 c3                	mov    %eax,%ebx
c010712c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0107132:	89 de                	mov    %ebx,%esi
c0107134:	89 d0                	mov    %edx,%eax
c0107136:	83 e0 00             	and    $0x0,%eax
c0107139:	89 c7                	mov    %eax,%edi
c010713b:	89 75 c8             	mov    %esi,-0x38(%ebp)
c010713e:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0107141:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107144:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107147:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010714a:	77 36                	ja     c0107182 <page_init+0x3ba>
c010714c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010714f:	72 05                	jb     c0107156 <page_init+0x38e>
c0107151:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0107154:	73 2c                	jae    c0107182 <page_init+0x3ba>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0107156:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107159:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010715c:	2b 45 d0             	sub    -0x30(%ebp),%eax
c010715f:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0107162:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0107166:	c1 ea 0c             	shr    $0xc,%edx
c0107169:	89 c3                	mov    %eax,%ebx
c010716b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010716e:	89 04 24             	mov    %eax,(%esp)
c0107171:	e8 3f f8 ff ff       	call   c01069b5 <pa2page>
c0107176:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010717a:	89 04 24             	mov    %eax,(%esp)
c010717d:	e8 43 fb ff ff       	call   c0106cc5 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0107182:	ff 45 dc             	incl   -0x24(%ebp)
c0107185:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0107188:	8b 00                	mov    (%eax),%eax
c010718a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010718d:	0f 8f 91 fe ff ff    	jg     c0107024 <page_init+0x25c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0107193:	90                   	nop
c0107194:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010719a:	5b                   	pop    %ebx
c010719b:	5e                   	pop    %esi
c010719c:	5f                   	pop    %edi
c010719d:	5d                   	pop    %ebp
c010719e:	c3                   	ret    

c010719f <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010719f:	55                   	push   %ebp
c01071a0:	89 e5                	mov    %esp,%ebp
c01071a2:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01071a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071a8:	33 45 14             	xor    0x14(%ebp),%eax
c01071ab:	25 ff 0f 00 00       	and    $0xfff,%eax
c01071b0:	85 c0                	test   %eax,%eax
c01071b2:	74 24                	je     c01071d8 <boot_map_segment+0x39>
c01071b4:	c7 44 24 0c 7e ac 10 	movl   $0xc010ac7e,0xc(%esp)
c01071bb:	c0 
c01071bc:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c01071c3:	c0 
c01071c4:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c01071cb:	00 
c01071cc:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c01071d3:	e8 2a 92 ff ff       	call   c0100402 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01071d8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01071df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071e2:	25 ff 0f 00 00       	and    $0xfff,%eax
c01071e7:	89 c2                	mov    %eax,%edx
c01071e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01071ec:	01 c2                	add    %eax,%edx
c01071ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01071f1:	01 d0                	add    %edx,%eax
c01071f3:	48                   	dec    %eax
c01071f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01071f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01071fa:	ba 00 00 00 00       	mov    $0x0,%edx
c01071ff:	f7 75 f0             	divl   -0x10(%ebp)
c0107202:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107205:	29 d0                	sub    %edx,%eax
c0107207:	c1 e8 0c             	shr    $0xc,%eax
c010720a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010720d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107210:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107213:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107216:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010721b:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010721e:	8b 45 14             	mov    0x14(%ebp),%eax
c0107221:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107224:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107227:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010722c:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010722f:	eb 68                	jmp    c0107299 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0107231:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107238:	00 
c0107239:	8b 45 0c             	mov    0xc(%ebp),%eax
c010723c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107240:	8b 45 08             	mov    0x8(%ebp),%eax
c0107243:	89 04 24             	mov    %eax,(%esp)
c0107246:	e8 81 01 00 00       	call   c01073cc <get_pte>
c010724b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010724e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107252:	75 24                	jne    c0107278 <boot_map_segment+0xd9>
c0107254:	c7 44 24 0c aa ac 10 	movl   $0xc010acaa,0xc(%esp)
c010725b:	c0 
c010725c:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107263:	c0 
c0107264:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c010726b:	00 
c010726c:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107273:	e8 8a 91 ff ff       	call   c0100402 <__panic>
        *ptep = pa | PTE_P | perm;
c0107278:	8b 45 14             	mov    0x14(%ebp),%eax
c010727b:	0b 45 18             	or     0x18(%ebp),%eax
c010727e:	83 c8 01             	or     $0x1,%eax
c0107281:	89 c2                	mov    %eax,%edx
c0107283:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107286:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0107288:	ff 4d f4             	decl   -0xc(%ebp)
c010728b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0107292:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0107299:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010729d:	75 92                	jne    c0107231 <boot_map_segment+0x92>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010729f:	90                   	nop
c01072a0:	c9                   	leave  
c01072a1:	c3                   	ret    

c01072a2 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01072a2:	55                   	push   %ebp
c01072a3:	89 e5                	mov    %esp,%ebp
c01072a5:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01072a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01072af:	e8 31 fa ff ff       	call   c0106ce5 <alloc_pages>
c01072b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01072b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01072bb:	75 1c                	jne    c01072d9 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01072bd:	c7 44 24 08 b7 ac 10 	movl   $0xc010acb7,0x8(%esp)
c01072c4:	c0 
c01072c5:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01072cc:	00 
c01072cd:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c01072d4:	e8 29 91 ff ff       	call   c0100402 <__panic>
    }
    return page2kva(p);
c01072d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072dc:	89 04 24             	mov    %eax,(%esp)
c01072df:	e8 16 f7 ff ff       	call   c01069fa <page2kva>
}
c01072e4:	c9                   	leave  
c01072e5:	c3                   	ret    

c01072e6 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01072e6:	55                   	push   %ebp
c01072e7:	89 e5                	mov    %esp,%ebp
c01072e9:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01072ec:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01072f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01072f4:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01072fb:	77 23                	ja     c0107320 <pmm_init+0x3a>
c01072fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107300:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107304:	c7 44 24 08 a4 ab 10 	movl   $0xc010aba4,0x8(%esp)
c010730b:	c0 
c010730c:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0107313:	00 
c0107314:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c010731b:	e8 e2 90 ff ff       	call   c0100402 <__panic>
c0107320:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107323:	05 00 00 00 40       	add    $0x40000000,%eax
c0107328:	a3 fc 50 12 c0       	mov    %eax,0xc01250fc
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010732d:	e8 5f f9 ff ff       	call   c0106c91 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0107332:	e8 91 fa ff ff       	call   c0106dc8 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0107337:	e8 20 05 00 00       	call   c010785c <check_alloc_page>

    check_pgdir();
c010733c:	e8 3a 05 00 00       	call   c010787b <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0107341:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107346:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010734c:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107351:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107354:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010735b:	77 23                	ja     c0107380 <pmm_init+0x9a>
c010735d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107360:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107364:	c7 44 24 08 a4 ab 10 	movl   $0xc010aba4,0x8(%esp)
c010736b:	c0 
c010736c:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0107373:	00 
c0107374:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c010737b:	e8 82 90 ff ff       	call   c0100402 <__panic>
c0107380:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107383:	05 00 00 00 40       	add    $0x40000000,%eax
c0107388:	83 c8 03             	or     $0x3,%eax
c010738b:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010738d:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107392:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0107399:	00 
c010739a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01073a1:	00 
c01073a2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01073a9:	38 
c01073aa:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01073b1:	c0 
c01073b2:	89 04 24             	mov    %eax,(%esp)
c01073b5:	e8 e5 fd ff ff       	call   c010719f <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01073ba:	e8 e9 f7 ff ff       	call   c0106ba8 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01073bf:	e8 53 0b 00 00       	call   c0107f17 <check_boot_pgdir>

    print_pgdir();
c01073c4:	e8 cc 0f 00 00       	call   c0108395 <print_pgdir>

}
c01073c9:	90                   	nop
c01073ca:	c9                   	leave  
c01073cb:	c3                   	ret    

c01073cc <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01073cc:	55                   	push   %ebp
c01073cd:	89 e5                	mov    %esp,%ebp
c01073cf:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
	pde_t *pdep = NULL;
c01073d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    pde_t *base_addr = pgdir;       //第一个空闲页表
c01073d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01073dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

    pdep = &base_addr[PDX(la)];
c01073df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073e2:	c1 e8 16             	shr    $0x16,%eax
c01073e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01073ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073ef:	01 d0                	add    %edx,%eax
c01073f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep)&PTE_P) == 0){
c01073f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073f7:	8b 00                	mov    (%eax),%eax
c01073f9:	83 e0 01             	and    $0x1,%eax
c01073fc:	85 c0                	test   %eax,%eax
c01073fe:	0f 85 ae 00 00 00    	jne    c01074b2 <get_pte+0xe6>
        struct Page *page = NULL;
c0107404:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

        if (create == 0 || (page = alloc_page()) == NULL) return NULL;
c010740b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010740f:	74 15                	je     c0107426 <get_pte+0x5a>
c0107411:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107418:	e8 c8 f8 ff ff       	call   c0106ce5 <alloc_pages>
c010741d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107420:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107424:	75 0a                	jne    c0107430 <get_pte+0x64>
c0107426:	b8 00 00 00 00       	mov    $0x0,%eax
c010742b:	e9 df 00 00 00       	jmp    c010750f <get_pte+0x143>

        uintptr_t pa_page = page2pa(page);
c0107430:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107433:	89 04 24             	mov    %eax,(%esp)
c0107436:	e8 64 f5 ff ff       	call   c010699f <page2pa>
c010743b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        memset(KADDR(pa_page), 0, PGSIZE);
c010743e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107441:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107447:	c1 e8 0c             	shr    $0xc,%eax
c010744a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010744d:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107452:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0107455:	72 23                	jb     c010747a <get_pte+0xae>
c0107457:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010745a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010745e:	c7 44 24 08 80 ab 10 	movl   $0xc010ab80,0x8(%esp)
c0107465:	c0 
c0107466:	c7 44 24 04 81 01 00 	movl   $0x181,0x4(%esp)
c010746d:	00 
c010746e:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107475:	e8 88 8f ff ff       	call   c0100402 <__panic>
c010747a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010747d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107482:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107489:	00 
c010748a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107491:	00 
c0107492:	89 04 24             	mov    %eax,(%esp)
c0107495:	e8 6f 16 00 00       	call   c0108b09 <memset>
        *pdep = pa_page | PTE_P | PTE_U | PTE_W;
c010749a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010749d:	83 c8 07             	or     $0x7,%eax
c01074a0:	89 c2                	mov    %eax,%edx
c01074a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074a5:	89 10                	mov    %edx,(%eax)
        page_ref_inc(page);
c01074a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074aa:	89 04 24             	mov    %eax,(%esp)
c01074ad:	e8 46 f6 ff ff       	call   c0106af8 <page_ref_inc>
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01074b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074b5:	8b 00                	mov    (%eax),%eax
c01074b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01074bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01074bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01074c2:	c1 e8 0c             	shr    $0xc,%eax
c01074c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01074c8:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01074cd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01074d0:	72 23                	jb     c01074f5 <get_pte+0x129>
c01074d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01074d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01074d9:	c7 44 24 08 80 ab 10 	movl   $0xc010ab80,0x8(%esp)
c01074e0:	c0 
c01074e1:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
c01074e8:	00 
c01074e9:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c01074f0:	e8 0d 8f ff ff       	call   c0100402 <__panic>
c01074f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01074f8:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01074fd:	89 c2                	mov    %eax,%edx
c01074ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107502:	c1 e8 0c             	shr    $0xc,%eax
c0107505:	25 ff 03 00 00       	and    $0x3ff,%eax
c010750a:	c1 e0 02             	shl    $0x2,%eax
c010750d:	01 d0                	add    %edx,%eax
}
c010750f:	c9                   	leave  
c0107510:	c3                   	ret    

c0107511 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0107511:	55                   	push   %ebp
c0107512:	89 e5                	mov    %esp,%ebp
c0107514:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0107517:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010751e:	00 
c010751f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107522:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107526:	8b 45 08             	mov    0x8(%ebp),%eax
c0107529:	89 04 24             	mov    %eax,(%esp)
c010752c:	e8 9b fe ff ff       	call   c01073cc <get_pte>
c0107531:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0107534:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107538:	74 08                	je     c0107542 <get_page+0x31>
        *ptep_store = ptep;
c010753a:	8b 45 10             	mov    0x10(%ebp),%eax
c010753d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107540:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0107542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107546:	74 1b                	je     c0107563 <get_page+0x52>
c0107548:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010754b:	8b 00                	mov    (%eax),%eax
c010754d:	83 e0 01             	and    $0x1,%eax
c0107550:	85 c0                	test   %eax,%eax
c0107552:	74 0f                	je     c0107563 <get_page+0x52>
        return pte2page(*ptep);
c0107554:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107557:	8b 00                	mov    (%eax),%eax
c0107559:	89 04 24             	mov    %eax,(%esp)
c010755c:	e8 37 f5 ff ff       	call   c0106a98 <pte2page>
c0107561:	eb 05                	jmp    c0107568 <get_page+0x57>
    }
    return NULL;
c0107563:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107568:	c9                   	leave  
c0107569:	c3                   	ret    

c010756a <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010756a:	55                   	push   %ebp
c010756b:	89 e5                	mov    %esp,%ebp
c010756d:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    pde_t *pdep = NULL;
c0107570:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    pde_t *base_addr = pgdir;
c0107577:	8b 45 08             	mov    0x8(%ebp),%eax
c010757a:	89 45 f0             	mov    %eax,-0x10(%ebp)

    pdep = &base_addr[PDX(la)];
c010757d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107580:	c1 e8 16             	shr    $0x16,%eax
c0107583:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010758a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010758d:	01 d0                	add    %edx,%eax
c010758f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep)&PTE_P) == 0 || ((*ptep)&PTE_P) == 0){
c0107592:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107595:	8b 00                	mov    (%eax),%eax
c0107597:	83 e0 01             	and    $0x1,%eax
c010759a:	85 c0                	test   %eax,%eax
c010759c:	0f 84 92 00 00 00    	je     c0107634 <page_remove_pte+0xca>
c01075a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01075a5:	8b 00                	mov    (%eax),%eax
c01075a7:	83 e0 01             	and    $0x1,%eax
c01075aa:	85 c0                	test   %eax,%eax
c01075ac:	0f 84 82 00 00 00    	je     c0107634 <page_remove_pte+0xca>
        return;
    }else{
        struct Page *page = pte2page(*ptep);
c01075b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01075b5:	8b 00                	mov    (%eax),%eax
c01075b7:	89 04 24             	mov    %eax,(%esp)
c01075ba:	e8 d9 f4 ff ff       	call   c0106a98 <pte2page>
c01075bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        
        assert(page->ref != 0);
c01075c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01075c5:	8b 00                	mov    (%eax),%eax
c01075c7:	85 c0                	test   %eax,%eax
c01075c9:	75 24                	jne    c01075ef <page_remove_pte+0x85>
c01075cb:	c7 44 24 0c d0 ac 10 	movl   $0xc010acd0,0xc(%esp)
c01075d2:	c0 
c01075d3:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c01075da:	c0 
c01075db:	c7 44 24 04 bc 01 00 	movl   $0x1bc,0x4(%esp)
c01075e2:	00 
c01075e3:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c01075ea:	e8 13 8e ff ff       	call   c0100402 <__panic>
        if (page_ref_dec(page) == 0){
c01075ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01075f2:	89 04 24             	mov    %eax,(%esp)
c01075f5:	e8 15 f5 ff ff       	call   c0106b0f <page_ref_dec>
c01075fa:	85 c0                	test   %eax,%eax
c01075fc:	75 37                	jne    c0107635 <page_remove_pte+0xcb>
            free_page(page);
c01075fe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107605:	00 
c0107606:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107609:	89 04 24             	mov    %eax,(%esp)
c010760c:	e8 59 f7 ff ff       	call   c0106d6a <free_pages>
            *ptep = *ptep & ~PTE_P;
c0107611:	8b 45 10             	mov    0x10(%ebp),%eax
c0107614:	8b 00                	mov    (%eax),%eax
c0107616:	83 e0 fe             	and    $0xfffffffe,%eax
c0107619:	89 c2                	mov    %eax,%edx
c010761b:	8b 45 10             	mov    0x10(%ebp),%eax
c010761e:	89 10                	mov    %edx,(%eax)
            tlb_invalidate(base_addr, la);
c0107620:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107623:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107627:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010762a:	89 04 24             	mov    %eax,(%esp)
c010762d:	e8 03 01 00 00       	call   c0107735 <tlb_invalidate>
c0107632:	eb 01                	jmp    c0107635 <page_remove_pte+0xcb>
    pde_t *pdep = NULL;
    pde_t *base_addr = pgdir;

    pdep = &base_addr[PDX(la)];
    if (((*pdep)&PTE_P) == 0 || ((*ptep)&PTE_P) == 0){
        return;
c0107634:	90                   	nop
            free_page(page);
            *ptep = *ptep & ~PTE_P;
            tlb_invalidate(base_addr, la);
        } 
    }   
}
c0107635:	c9                   	leave  
c0107636:	c3                   	ret    

c0107637 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0107637:	55                   	push   %ebp
c0107638:	89 e5                	mov    %esp,%ebp
c010763a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010763d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107644:	00 
c0107645:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107648:	89 44 24 04          	mov    %eax,0x4(%esp)
c010764c:	8b 45 08             	mov    0x8(%ebp),%eax
c010764f:	89 04 24             	mov    %eax,(%esp)
c0107652:	e8 75 fd ff ff       	call   c01073cc <get_pte>
c0107657:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010765a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010765e:	74 19                	je     c0107679 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0107660:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107663:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107667:	8b 45 0c             	mov    0xc(%ebp),%eax
c010766a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010766e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107671:	89 04 24             	mov    %eax,(%esp)
c0107674:	e8 f1 fe ff ff       	call   c010756a <page_remove_pte>
    }
}
c0107679:	90                   	nop
c010767a:	c9                   	leave  
c010767b:	c3                   	ret    

c010767c <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010767c:	55                   	push   %ebp
c010767d:	89 e5                	mov    %esp,%ebp
c010767f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0107682:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107689:	00 
c010768a:	8b 45 10             	mov    0x10(%ebp),%eax
c010768d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107691:	8b 45 08             	mov    0x8(%ebp),%eax
c0107694:	89 04 24             	mov    %eax,(%esp)
c0107697:	e8 30 fd ff ff       	call   c01073cc <get_pte>
c010769c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010769f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01076a3:	75 0a                	jne    c01076af <page_insert+0x33>
        return -E_NO_MEM;
c01076a5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01076aa:	e9 84 00 00 00       	jmp    c0107733 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01076af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01076b2:	89 04 24             	mov    %eax,(%esp)
c01076b5:	e8 3e f4 ff ff       	call   c0106af8 <page_ref_inc>
    if (*ptep & PTE_P) {
c01076ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076bd:	8b 00                	mov    (%eax),%eax
c01076bf:	83 e0 01             	and    $0x1,%eax
c01076c2:	85 c0                	test   %eax,%eax
c01076c4:	74 3e                	je     c0107704 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01076c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076c9:	8b 00                	mov    (%eax),%eax
c01076cb:	89 04 24             	mov    %eax,(%esp)
c01076ce:	e8 c5 f3 ff ff       	call   c0106a98 <pte2page>
c01076d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01076d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01076d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01076dc:	75 0d                	jne    c01076eb <page_insert+0x6f>
            page_ref_dec(page);
c01076de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01076e1:	89 04 24             	mov    %eax,(%esp)
c01076e4:	e8 26 f4 ff ff       	call   c0106b0f <page_ref_dec>
c01076e9:	eb 19                	jmp    c0107704 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01076eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076ee:	89 44 24 08          	mov    %eax,0x8(%esp)
c01076f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01076f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01076fc:	89 04 24             	mov    %eax,(%esp)
c01076ff:	e8 66 fe ff ff       	call   c010756a <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0107704:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107707:	89 04 24             	mov    %eax,(%esp)
c010770a:	e8 90 f2 ff ff       	call   c010699f <page2pa>
c010770f:	0b 45 14             	or     0x14(%ebp),%eax
c0107712:	83 c8 01             	or     $0x1,%eax
c0107715:	89 c2                	mov    %eax,%edx
c0107717:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010771a:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010771c:	8b 45 10             	mov    0x10(%ebp),%eax
c010771f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107723:	8b 45 08             	mov    0x8(%ebp),%eax
c0107726:	89 04 24             	mov    %eax,(%esp)
c0107729:	e8 07 00 00 00       	call   c0107735 <tlb_invalidate>
    return 0;
c010772e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107733:	c9                   	leave  
c0107734:	c3                   	ret    

c0107735 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0107735:	55                   	push   %ebp
c0107736:	89 e5                	mov    %esp,%ebp
c0107738:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010773b:	0f 20 d8             	mov    %cr3,%eax
c010773e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c0107741:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0107744:	8b 45 08             	mov    0x8(%ebp),%eax
c0107747:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010774a:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0107751:	77 23                	ja     c0107776 <tlb_invalidate+0x41>
c0107753:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107756:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010775a:	c7 44 24 08 a4 ab 10 	movl   $0xc010aba4,0x8(%esp)
c0107761:	c0 
c0107762:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0107769:	00 
c010776a:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107771:	e8 8c 8c ff ff       	call   c0100402 <__panic>
c0107776:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107779:	05 00 00 00 40       	add    $0x40000000,%eax
c010777e:	39 c2                	cmp    %eax,%edx
c0107780:	75 0c                	jne    c010778e <tlb_invalidate+0x59>
        invlpg((void *)la);
c0107782:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107785:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0107788:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010778b:	0f 01 38             	invlpg (%eax)
    }
}
c010778e:	90                   	nop
c010778f:	c9                   	leave  
c0107790:	c3                   	ret    

c0107791 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0107791:	55                   	push   %ebp
c0107792:	89 e5                	mov    %esp,%ebp
c0107794:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0107797:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010779e:	e8 42 f5 ff ff       	call   c0106ce5 <alloc_pages>
c01077a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01077a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01077aa:	0f 84 a7 00 00 00    	je     c0107857 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01077b0:	8b 45 10             	mov    0x10(%ebp),%eax
c01077b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01077b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077ba:	89 44 24 08          	mov    %eax,0x8(%esp)
c01077be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01077c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01077c8:	89 04 24             	mov    %eax,(%esp)
c01077cb:	e8 ac fe ff ff       	call   c010767c <page_insert>
c01077d0:	85 c0                	test   %eax,%eax
c01077d2:	74 1a                	je     c01077ee <pgdir_alloc_page+0x5d>
            free_page(page);
c01077d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01077db:	00 
c01077dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077df:	89 04 24             	mov    %eax,(%esp)
c01077e2:	e8 83 f5 ff ff       	call   c0106d6a <free_pages>
            return NULL;
c01077e7:	b8 00 00 00 00       	mov    $0x0,%eax
c01077ec:	eb 6c                	jmp    c010785a <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c01077ee:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c01077f3:	85 c0                	test   %eax,%eax
c01077f5:	74 60                	je     c0107857 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c01077f7:	a1 10 50 12 c0       	mov    0xc0125010,%eax
c01077fc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107803:	00 
c0107804:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107807:	89 54 24 08          	mov    %edx,0x8(%esp)
c010780b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010780e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107812:	89 04 24             	mov    %eax,(%esp)
c0107815:	e8 f9 c9 ff ff       	call   c0104213 <swap_map_swappable>
            page->pra_vaddr=la;
c010781a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010781d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107820:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0107823:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107826:	89 04 24             	mov    %eax,(%esp)
c0107829:	e8 c0 f2 ff ff       	call   c0106aee <page_ref>
c010782e:	83 f8 01             	cmp    $0x1,%eax
c0107831:	74 24                	je     c0107857 <pgdir_alloc_page+0xc6>
c0107833:	c7 44 24 0c df ac 10 	movl   $0xc010acdf,0xc(%esp)
c010783a:	c0 
c010783b:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107842:	c0 
c0107843:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c010784a:	00 
c010784b:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107852:	e8 ab 8b ff ff       	call   c0100402 <__panic>
            // cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0107857:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010785a:	c9                   	leave  
c010785b:	c3                   	ret    

c010785c <check_alloc_page>:

static void
check_alloc_page(void) {
c010785c:	55                   	push   %ebp
c010785d:	89 e5                	mov    %esp,%ebp
c010785f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0107862:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0107867:	8b 40 18             	mov    0x18(%eax),%eax
c010786a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010786c:	c7 04 24 f4 ac 10 c0 	movl   $0xc010acf4,(%esp)
c0107873:	e8 33 8a ff ff       	call   c01002ab <cprintf>
}
c0107878:	90                   	nop
c0107879:	c9                   	leave  
c010787a:	c3                   	ret    

c010787b <check_pgdir>:

static void
check_pgdir(void) {
c010787b:	55                   	push   %ebp
c010787c:	89 e5                	mov    %esp,%ebp
c010787e:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0107881:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107886:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010788b:	76 24                	jbe    c01078b1 <check_pgdir+0x36>
c010788d:	c7 44 24 0c 13 ad 10 	movl   $0xc010ad13,0xc(%esp)
c0107894:	c0 
c0107895:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c010789c:	c0 
c010789d:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c01078a4:	00 
c01078a5:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c01078ac:	e8 51 8b ff ff       	call   c0100402 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01078b1:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01078b6:	85 c0                	test   %eax,%eax
c01078b8:	74 0e                	je     c01078c8 <check_pgdir+0x4d>
c01078ba:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01078bf:	25 ff 0f 00 00       	and    $0xfff,%eax
c01078c4:	85 c0                	test   %eax,%eax
c01078c6:	74 24                	je     c01078ec <check_pgdir+0x71>
c01078c8:	c7 44 24 0c 30 ad 10 	movl   $0xc010ad30,0xc(%esp)
c01078cf:	c0 
c01078d0:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c01078d7:	c0 
c01078d8:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c01078df:	00 
c01078e0:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c01078e7:	e8 16 8b ff ff       	call   c0100402 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01078ec:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01078f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01078f8:	00 
c01078f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107900:	00 
c0107901:	89 04 24             	mov    %eax,(%esp)
c0107904:	e8 08 fc ff ff       	call   c0107511 <get_page>
c0107909:	85 c0                	test   %eax,%eax
c010790b:	74 24                	je     c0107931 <check_pgdir+0xb6>
c010790d:	c7 44 24 0c 68 ad 10 	movl   $0xc010ad68,0xc(%esp)
c0107914:	c0 
c0107915:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c010791c:	c0 
c010791d:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0107924:	00 
c0107925:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c010792c:	e8 d1 8a ff ff       	call   c0100402 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0107931:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107938:	e8 a8 f3 ff ff       	call   c0106ce5 <alloc_pages>
c010793d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0107940:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107945:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010794c:	00 
c010794d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107954:	00 
c0107955:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107958:	89 54 24 04          	mov    %edx,0x4(%esp)
c010795c:	89 04 24             	mov    %eax,(%esp)
c010795f:	e8 18 fd ff ff       	call   c010767c <page_insert>
c0107964:	85 c0                	test   %eax,%eax
c0107966:	74 24                	je     c010798c <check_pgdir+0x111>
c0107968:	c7 44 24 0c 90 ad 10 	movl   $0xc010ad90,0xc(%esp)
c010796f:	c0 
c0107970:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107977:	c0 
c0107978:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c010797f:	00 
c0107980:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107987:	e8 76 8a ff ff       	call   c0100402 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010798c:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107991:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107998:	00 
c0107999:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01079a0:	00 
c01079a1:	89 04 24             	mov    %eax,(%esp)
c01079a4:	e8 23 fa ff ff       	call   c01073cc <get_pte>
c01079a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01079ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01079b0:	75 24                	jne    c01079d6 <check_pgdir+0x15b>
c01079b2:	c7 44 24 0c bc ad 10 	movl   $0xc010adbc,0xc(%esp)
c01079b9:	c0 
c01079ba:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c01079c1:	c0 
c01079c2:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c01079c9:	00 
c01079ca:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c01079d1:	e8 2c 8a ff ff       	call   c0100402 <__panic>
    assert(pte2page(*ptep) == p1);
c01079d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01079d9:	8b 00                	mov    (%eax),%eax
c01079db:	89 04 24             	mov    %eax,(%esp)
c01079de:	e8 b5 f0 ff ff       	call   c0106a98 <pte2page>
c01079e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01079e6:	74 24                	je     c0107a0c <check_pgdir+0x191>
c01079e8:	c7 44 24 0c e9 ad 10 	movl   $0xc010ade9,0xc(%esp)
c01079ef:	c0 
c01079f0:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c01079f7:	c0 
c01079f8:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c01079ff:	00 
c0107a00:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107a07:	e8 f6 89 ff ff       	call   c0100402 <__panic>
    assert(page_ref(p1) == 1);
c0107a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a0f:	89 04 24             	mov    %eax,(%esp)
c0107a12:	e8 d7 f0 ff ff       	call   c0106aee <page_ref>
c0107a17:	83 f8 01             	cmp    $0x1,%eax
c0107a1a:	74 24                	je     c0107a40 <check_pgdir+0x1c5>
c0107a1c:	c7 44 24 0c ff ad 10 	movl   $0xc010adff,0xc(%esp)
c0107a23:	c0 
c0107a24:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107a2b:	c0 
c0107a2c:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0107a33:	00 
c0107a34:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107a3b:	e8 c2 89 ff ff       	call   c0100402 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0107a40:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107a45:	8b 00                	mov    (%eax),%eax
c0107a47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107a4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107a52:	c1 e8 0c             	shr    $0xc,%eax
c0107a55:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107a58:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107a5d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0107a60:	72 23                	jb     c0107a85 <check_pgdir+0x20a>
c0107a62:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107a65:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107a69:	c7 44 24 08 80 ab 10 	movl   $0xc010ab80,0x8(%esp)
c0107a70:	c0 
c0107a71:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0107a78:	00 
c0107a79:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107a80:	e8 7d 89 ff ff       	call   c0100402 <__panic>
c0107a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107a88:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107a8d:	83 c0 04             	add    $0x4,%eax
c0107a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0107a93:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107a98:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107a9f:	00 
c0107aa0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107aa7:	00 
c0107aa8:	89 04 24             	mov    %eax,(%esp)
c0107aab:	e8 1c f9 ff ff       	call   c01073cc <get_pte>
c0107ab0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107ab3:	74 24                	je     c0107ad9 <check_pgdir+0x25e>
c0107ab5:	c7 44 24 0c 14 ae 10 	movl   $0xc010ae14,0xc(%esp)
c0107abc:	c0 
c0107abd:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107ac4:	c0 
c0107ac5:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0107acc:	00 
c0107acd:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107ad4:	e8 29 89 ff ff       	call   c0100402 <__panic>

    p2 = alloc_page();
c0107ad9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107ae0:	e8 00 f2 ff ff       	call   c0106ce5 <alloc_pages>
c0107ae5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0107ae8:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107aed:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0107af4:	00 
c0107af5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107afc:	00 
c0107afd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107b00:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107b04:	89 04 24             	mov    %eax,(%esp)
c0107b07:	e8 70 fb ff ff       	call   c010767c <page_insert>
c0107b0c:	85 c0                	test   %eax,%eax
c0107b0e:	74 24                	je     c0107b34 <check_pgdir+0x2b9>
c0107b10:	c7 44 24 0c 3c ae 10 	movl   $0xc010ae3c,0xc(%esp)
c0107b17:	c0 
c0107b18:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107b1f:	c0 
c0107b20:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0107b27:	00 
c0107b28:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107b2f:	e8 ce 88 ff ff       	call   c0100402 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107b34:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107b39:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107b40:	00 
c0107b41:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107b48:	00 
c0107b49:	89 04 24             	mov    %eax,(%esp)
c0107b4c:	e8 7b f8 ff ff       	call   c01073cc <get_pte>
c0107b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107b58:	75 24                	jne    c0107b7e <check_pgdir+0x303>
c0107b5a:	c7 44 24 0c 74 ae 10 	movl   $0xc010ae74,0xc(%esp)
c0107b61:	c0 
c0107b62:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107b69:	c0 
c0107b6a:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0107b71:	00 
c0107b72:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107b79:	e8 84 88 ff ff       	call   c0100402 <__panic>
    assert(*ptep & PTE_U);
c0107b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b81:	8b 00                	mov    (%eax),%eax
c0107b83:	83 e0 04             	and    $0x4,%eax
c0107b86:	85 c0                	test   %eax,%eax
c0107b88:	75 24                	jne    c0107bae <check_pgdir+0x333>
c0107b8a:	c7 44 24 0c a4 ae 10 	movl   $0xc010aea4,0xc(%esp)
c0107b91:	c0 
c0107b92:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107b99:	c0 
c0107b9a:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0107ba1:	00 
c0107ba2:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107ba9:	e8 54 88 ff ff       	call   c0100402 <__panic>
    assert(*ptep & PTE_W);
c0107bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107bb1:	8b 00                	mov    (%eax),%eax
c0107bb3:	83 e0 02             	and    $0x2,%eax
c0107bb6:	85 c0                	test   %eax,%eax
c0107bb8:	75 24                	jne    c0107bde <check_pgdir+0x363>
c0107bba:	c7 44 24 0c b2 ae 10 	movl   $0xc010aeb2,0xc(%esp)
c0107bc1:	c0 
c0107bc2:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107bc9:	c0 
c0107bca:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0107bd1:	00 
c0107bd2:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107bd9:	e8 24 88 ff ff       	call   c0100402 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0107bde:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107be3:	8b 00                	mov    (%eax),%eax
c0107be5:	83 e0 04             	and    $0x4,%eax
c0107be8:	85 c0                	test   %eax,%eax
c0107bea:	75 24                	jne    c0107c10 <check_pgdir+0x395>
c0107bec:	c7 44 24 0c c0 ae 10 	movl   $0xc010aec0,0xc(%esp)
c0107bf3:	c0 
c0107bf4:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107bfb:	c0 
c0107bfc:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0107c03:	00 
c0107c04:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107c0b:	e8 f2 87 ff ff       	call   c0100402 <__panic>
    assert(page_ref(p2) == 1);
c0107c10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c13:	89 04 24             	mov    %eax,(%esp)
c0107c16:	e8 d3 ee ff ff       	call   c0106aee <page_ref>
c0107c1b:	83 f8 01             	cmp    $0x1,%eax
c0107c1e:	74 24                	je     c0107c44 <check_pgdir+0x3c9>
c0107c20:	c7 44 24 0c d6 ae 10 	movl   $0xc010aed6,0xc(%esp)
c0107c27:	c0 
c0107c28:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107c2f:	c0 
c0107c30:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0107c37:	00 
c0107c38:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107c3f:	e8 be 87 ff ff       	call   c0100402 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0107c44:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107c49:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107c50:	00 
c0107c51:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107c58:	00 
c0107c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107c5c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107c60:	89 04 24             	mov    %eax,(%esp)
c0107c63:	e8 14 fa ff ff       	call   c010767c <page_insert>
c0107c68:	85 c0                	test   %eax,%eax
c0107c6a:	74 24                	je     c0107c90 <check_pgdir+0x415>
c0107c6c:	c7 44 24 0c e8 ae 10 	movl   $0xc010aee8,0xc(%esp)
c0107c73:	c0 
c0107c74:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107c7b:	c0 
c0107c7c:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0107c83:	00 
c0107c84:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107c8b:	e8 72 87 ff ff       	call   c0100402 <__panic>
    assert(page_ref(p1) == 2);
c0107c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c93:	89 04 24             	mov    %eax,(%esp)
c0107c96:	e8 53 ee ff ff       	call   c0106aee <page_ref>
c0107c9b:	83 f8 02             	cmp    $0x2,%eax
c0107c9e:	74 24                	je     c0107cc4 <check_pgdir+0x449>
c0107ca0:	c7 44 24 0c 14 af 10 	movl   $0xc010af14,0xc(%esp)
c0107ca7:	c0 
c0107ca8:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107caf:	c0 
c0107cb0:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0107cb7:	00 
c0107cb8:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107cbf:	e8 3e 87 ff ff       	call   c0100402 <__panic>
    assert(page_ref(p2) == 0);
c0107cc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107cc7:	89 04 24             	mov    %eax,(%esp)
c0107cca:	e8 1f ee ff ff       	call   c0106aee <page_ref>
c0107ccf:	85 c0                	test   %eax,%eax
c0107cd1:	74 24                	je     c0107cf7 <check_pgdir+0x47c>
c0107cd3:	c7 44 24 0c 26 af 10 	movl   $0xc010af26,0xc(%esp)
c0107cda:	c0 
c0107cdb:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107ce2:	c0 
c0107ce3:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0107cea:	00 
c0107ceb:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107cf2:	e8 0b 87 ff ff       	call   c0100402 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107cf7:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107cfc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107d03:	00 
c0107d04:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107d0b:	00 
c0107d0c:	89 04 24             	mov    %eax,(%esp)
c0107d0f:	e8 b8 f6 ff ff       	call   c01073cc <get_pte>
c0107d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107d17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107d1b:	75 24                	jne    c0107d41 <check_pgdir+0x4c6>
c0107d1d:	c7 44 24 0c 74 ae 10 	movl   $0xc010ae74,0xc(%esp)
c0107d24:	c0 
c0107d25:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107d2c:	c0 
c0107d2d:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0107d34:	00 
c0107d35:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107d3c:	e8 c1 86 ff ff       	call   c0100402 <__panic>
    assert(pte2page(*ptep) == p1);
c0107d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107d44:	8b 00                	mov    (%eax),%eax
c0107d46:	89 04 24             	mov    %eax,(%esp)
c0107d49:	e8 4a ed ff ff       	call   c0106a98 <pte2page>
c0107d4e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107d51:	74 24                	je     c0107d77 <check_pgdir+0x4fc>
c0107d53:	c7 44 24 0c e9 ad 10 	movl   $0xc010ade9,0xc(%esp)
c0107d5a:	c0 
c0107d5b:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107d62:	c0 
c0107d63:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0107d6a:	00 
c0107d6b:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107d72:	e8 8b 86 ff ff       	call   c0100402 <__panic>
    assert((*ptep & PTE_U) == 0);
c0107d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107d7a:	8b 00                	mov    (%eax),%eax
c0107d7c:	83 e0 04             	and    $0x4,%eax
c0107d7f:	85 c0                	test   %eax,%eax
c0107d81:	74 24                	je     c0107da7 <check_pgdir+0x52c>
c0107d83:	c7 44 24 0c 38 af 10 	movl   $0xc010af38,0xc(%esp)
c0107d8a:	c0 
c0107d8b:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107d92:	c0 
c0107d93:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0107d9a:	00 
c0107d9b:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107da2:	e8 5b 86 ff ff       	call   c0100402 <__panic>

    page_remove(boot_pgdir, 0x0);
c0107da7:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107dac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107db3:	00 
c0107db4:	89 04 24             	mov    %eax,(%esp)
c0107db7:	e8 7b f8 ff ff       	call   c0107637 <page_remove>
    assert(page_ref(p1) == 1);
c0107dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dbf:	89 04 24             	mov    %eax,(%esp)
c0107dc2:	e8 27 ed ff ff       	call   c0106aee <page_ref>
c0107dc7:	83 f8 01             	cmp    $0x1,%eax
c0107dca:	74 24                	je     c0107df0 <check_pgdir+0x575>
c0107dcc:	c7 44 24 0c ff ad 10 	movl   $0xc010adff,0xc(%esp)
c0107dd3:	c0 
c0107dd4:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107ddb:	c0 
c0107ddc:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0107de3:	00 
c0107de4:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107deb:	e8 12 86 ff ff       	call   c0100402 <__panic>
    assert(page_ref(p2) == 0);
c0107df0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107df3:	89 04 24             	mov    %eax,(%esp)
c0107df6:	e8 f3 ec ff ff       	call   c0106aee <page_ref>
c0107dfb:	85 c0                	test   %eax,%eax
c0107dfd:	74 24                	je     c0107e23 <check_pgdir+0x5a8>
c0107dff:	c7 44 24 0c 26 af 10 	movl   $0xc010af26,0xc(%esp)
c0107e06:	c0 
c0107e07:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107e0e:	c0 
c0107e0f:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0107e16:	00 
c0107e17:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107e1e:	e8 df 85 ff ff       	call   c0100402 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0107e23:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107e28:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107e2f:	00 
c0107e30:	89 04 24             	mov    %eax,(%esp)
c0107e33:	e8 ff f7 ff ff       	call   c0107637 <page_remove>
    assert(page_ref(p1) == 0);
c0107e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e3b:	89 04 24             	mov    %eax,(%esp)
c0107e3e:	e8 ab ec ff ff       	call   c0106aee <page_ref>
c0107e43:	85 c0                	test   %eax,%eax
c0107e45:	74 24                	je     c0107e6b <check_pgdir+0x5f0>
c0107e47:	c7 44 24 0c 4d af 10 	movl   $0xc010af4d,0xc(%esp)
c0107e4e:	c0 
c0107e4f:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107e56:	c0 
c0107e57:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0107e5e:	00 
c0107e5f:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107e66:	e8 97 85 ff ff       	call   c0100402 <__panic>
    assert(page_ref(p2) == 0);
c0107e6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e6e:	89 04 24             	mov    %eax,(%esp)
c0107e71:	e8 78 ec ff ff       	call   c0106aee <page_ref>
c0107e76:	85 c0                	test   %eax,%eax
c0107e78:	74 24                	je     c0107e9e <check_pgdir+0x623>
c0107e7a:	c7 44 24 0c 26 af 10 	movl   $0xc010af26,0xc(%esp)
c0107e81:	c0 
c0107e82:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107e89:	c0 
c0107e8a:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0107e91:	00 
c0107e92:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107e99:	e8 64 85 ff ff       	call   c0100402 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0107e9e:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107ea3:	8b 00                	mov    (%eax),%eax
c0107ea5:	89 04 24             	mov    %eax,(%esp)
c0107ea8:	e8 29 ec ff ff       	call   c0106ad6 <pde2page>
c0107ead:	89 04 24             	mov    %eax,(%esp)
c0107eb0:	e8 39 ec ff ff       	call   c0106aee <page_ref>
c0107eb5:	83 f8 01             	cmp    $0x1,%eax
c0107eb8:	74 24                	je     c0107ede <check_pgdir+0x663>
c0107eba:	c7 44 24 0c 60 af 10 	movl   $0xc010af60,0xc(%esp)
c0107ec1:	c0 
c0107ec2:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107ec9:	c0 
c0107eca:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0107ed1:	00 
c0107ed2:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107ed9:	e8 24 85 ff ff       	call   c0100402 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0107ede:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107ee3:	8b 00                	mov    (%eax),%eax
c0107ee5:	89 04 24             	mov    %eax,(%esp)
c0107ee8:	e8 e9 eb ff ff       	call   c0106ad6 <pde2page>
c0107eed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107ef4:	00 
c0107ef5:	89 04 24             	mov    %eax,(%esp)
c0107ef8:	e8 6d ee ff ff       	call   c0106d6a <free_pages>
    boot_pgdir[0] = 0;
c0107efd:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107f02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0107f08:	c7 04 24 87 af 10 c0 	movl   $0xc010af87,(%esp)
c0107f0f:	e8 97 83 ff ff       	call   c01002ab <cprintf>
}
c0107f14:	90                   	nop
c0107f15:	c9                   	leave  
c0107f16:	c3                   	ret    

c0107f17 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0107f17:	55                   	push   %ebp
c0107f18:	89 e5                	mov    %esp,%ebp
c0107f1a:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0107f1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107f24:	e9 ca 00 00 00       	jmp    c0107ff3 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0107f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f32:	c1 e8 0c             	shr    $0xc,%eax
c0107f35:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107f38:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107f3d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0107f40:	72 23                	jb     c0107f65 <check_boot_pgdir+0x4e>
c0107f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f45:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107f49:	c7 44 24 08 80 ab 10 	movl   $0xc010ab80,0x8(%esp)
c0107f50:	c0 
c0107f51:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c0107f58:	00 
c0107f59:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107f60:	e8 9d 84 ff ff       	call   c0100402 <__panic>
c0107f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f68:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107f6d:	89 c2                	mov    %eax,%edx
c0107f6f:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107f74:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107f7b:	00 
c0107f7c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107f80:	89 04 24             	mov    %eax,(%esp)
c0107f83:	e8 44 f4 ff ff       	call   c01073cc <get_pte>
c0107f88:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107f8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107f8f:	75 24                	jne    c0107fb5 <check_boot_pgdir+0x9e>
c0107f91:	c7 44 24 0c a4 af 10 	movl   $0xc010afa4,0xc(%esp)
c0107f98:	c0 
c0107f99:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107fa0:	c0 
c0107fa1:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c0107fa8:	00 
c0107fa9:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107fb0:	e8 4d 84 ff ff       	call   c0100402 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0107fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107fb8:	8b 00                	mov    (%eax),%eax
c0107fba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107fbf:	89 c2                	mov    %eax,%edx
c0107fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fc4:	39 c2                	cmp    %eax,%edx
c0107fc6:	74 24                	je     c0107fec <check_boot_pgdir+0xd5>
c0107fc8:	c7 44 24 0c e1 af 10 	movl   $0xc010afe1,0xc(%esp)
c0107fcf:	c0 
c0107fd0:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0107fd7:	c0 
c0107fd8:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0107fdf:	00 
c0107fe0:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0107fe7:	e8 16 84 ff ff       	call   c0100402 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0107fec:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0107ff3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107ff6:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107ffb:	39 c2                	cmp    %eax,%edx
c0107ffd:	0f 82 26 ff ff ff    	jb     c0107f29 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0108003:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0108008:	05 ac 0f 00 00       	add    $0xfac,%eax
c010800d:	8b 00                	mov    (%eax),%eax
c010800f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108014:	89 c2                	mov    %eax,%edx
c0108016:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010801b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010801e:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0108025:	77 23                	ja     c010804a <check_boot_pgdir+0x133>
c0108027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010802a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010802e:	c7 44 24 08 a4 ab 10 	movl   $0xc010aba4,0x8(%esp)
c0108035:	c0 
c0108036:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c010803d:	00 
c010803e:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0108045:	e8 b8 83 ff ff       	call   c0100402 <__panic>
c010804a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010804d:	05 00 00 00 40       	add    $0x40000000,%eax
c0108052:	39 c2                	cmp    %eax,%edx
c0108054:	74 24                	je     c010807a <check_boot_pgdir+0x163>
c0108056:	c7 44 24 0c f8 af 10 	movl   $0xc010aff8,0xc(%esp)
c010805d:	c0 
c010805e:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0108065:	c0 
c0108066:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c010806d:	00 
c010806e:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0108075:	e8 88 83 ff ff       	call   c0100402 <__panic>

    assert(boot_pgdir[0] == 0);
c010807a:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010807f:	8b 00                	mov    (%eax),%eax
c0108081:	85 c0                	test   %eax,%eax
c0108083:	74 24                	je     c01080a9 <check_boot_pgdir+0x192>
c0108085:	c7 44 24 0c 2c b0 10 	movl   $0xc010b02c,0xc(%esp)
c010808c:	c0 
c010808d:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0108094:	c0 
c0108095:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
c010809c:	00 
c010809d:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c01080a4:	e8 59 83 ff ff       	call   c0100402 <__panic>

    struct Page *p;
    p = alloc_page();
c01080a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01080b0:	e8 30 ec ff ff       	call   c0106ce5 <alloc_pages>
c01080b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01080b8:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01080bd:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01080c4:	00 
c01080c5:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01080cc:	00 
c01080cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01080d0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01080d4:	89 04 24             	mov    %eax,(%esp)
c01080d7:	e8 a0 f5 ff ff       	call   c010767c <page_insert>
c01080dc:	85 c0                	test   %eax,%eax
c01080de:	74 24                	je     c0108104 <check_boot_pgdir+0x1ed>
c01080e0:	c7 44 24 0c 40 b0 10 	movl   $0xc010b040,0xc(%esp)
c01080e7:	c0 
c01080e8:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c01080ef:	c0 
c01080f0:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
c01080f7:	00 
c01080f8:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c01080ff:	e8 fe 82 ff ff       	call   c0100402 <__panic>
    assert(page_ref(p) == 1);
c0108104:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108107:	89 04 24             	mov    %eax,(%esp)
c010810a:	e8 df e9 ff ff       	call   c0106aee <page_ref>
c010810f:	83 f8 01             	cmp    $0x1,%eax
c0108112:	74 24                	je     c0108138 <check_boot_pgdir+0x221>
c0108114:	c7 44 24 0c 6e b0 10 	movl   $0xc010b06e,0xc(%esp)
c010811b:	c0 
c010811c:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0108123:	c0 
c0108124:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
c010812b:	00 
c010812c:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0108133:	e8 ca 82 ff ff       	call   c0100402 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0108138:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010813d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0108144:	00 
c0108145:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010814c:	00 
c010814d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108150:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108154:	89 04 24             	mov    %eax,(%esp)
c0108157:	e8 20 f5 ff ff       	call   c010767c <page_insert>
c010815c:	85 c0                	test   %eax,%eax
c010815e:	74 24                	je     c0108184 <check_boot_pgdir+0x26d>
c0108160:	c7 44 24 0c 80 b0 10 	movl   $0xc010b080,0xc(%esp)
c0108167:	c0 
c0108168:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c010816f:	c0 
c0108170:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
c0108177:	00 
c0108178:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c010817f:	e8 7e 82 ff ff       	call   c0100402 <__panic>
    assert(page_ref(p) == 2);
c0108184:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108187:	89 04 24             	mov    %eax,(%esp)
c010818a:	e8 5f e9 ff ff       	call   c0106aee <page_ref>
c010818f:	83 f8 02             	cmp    $0x2,%eax
c0108192:	74 24                	je     c01081b8 <check_boot_pgdir+0x2a1>
c0108194:	c7 44 24 0c b7 b0 10 	movl   $0xc010b0b7,0xc(%esp)
c010819b:	c0 
c010819c:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c01081a3:	c0 
c01081a4:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c01081ab:	00 
c01081ac:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c01081b3:	e8 4a 82 ff ff       	call   c0100402 <__panic>

    const char *str = "ucore: Hello world!!";
c01081b8:	c7 45 dc c8 b0 10 c0 	movl   $0xc010b0c8,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01081bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01081c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081c6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01081cd:	e8 6d 06 00 00       	call   c010883f <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01081d2:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01081d9:	00 
c01081da:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01081e1:	e8 d0 06 00 00       	call   c01088b6 <strcmp>
c01081e6:	85 c0                	test   %eax,%eax
c01081e8:	74 24                	je     c010820e <check_boot_pgdir+0x2f7>
c01081ea:	c7 44 24 0c e0 b0 10 	movl   $0xc010b0e0,0xc(%esp)
c01081f1:	c0 
c01081f2:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c01081f9:	c0 
c01081fa:	c7 44 24 04 57 02 00 	movl   $0x257,0x4(%esp)
c0108201:	00 
c0108202:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0108209:	e8 f4 81 ff ff       	call   c0100402 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010820e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108211:	89 04 24             	mov    %eax,(%esp)
c0108214:	e8 e1 e7 ff ff       	call   c01069fa <page2kva>
c0108219:	05 00 01 00 00       	add    $0x100,%eax
c010821e:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0108221:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0108228:	e8 bc 05 00 00       	call   c01087e9 <strlen>
c010822d:	85 c0                	test   %eax,%eax
c010822f:	74 24                	je     c0108255 <check_boot_pgdir+0x33e>
c0108231:	c7 44 24 0c 18 b1 10 	movl   $0xc010b118,0xc(%esp)
c0108238:	c0 
c0108239:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0108240:	c0 
c0108241:	c7 44 24 04 5a 02 00 	movl   $0x25a,0x4(%esp)
c0108248:	00 
c0108249:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0108250:	e8 ad 81 ff ff       	call   c0100402 <__panic>

    free_page(p);
c0108255:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010825c:	00 
c010825d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108260:	89 04 24             	mov    %eax,(%esp)
c0108263:	e8 02 eb ff ff       	call   c0106d6a <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0108268:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010826d:	8b 00                	mov    (%eax),%eax
c010826f:	89 04 24             	mov    %eax,(%esp)
c0108272:	e8 5f e8 ff ff       	call   c0106ad6 <pde2page>
c0108277:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010827e:	00 
c010827f:	89 04 24             	mov    %eax,(%esp)
c0108282:	e8 e3 ea ff ff       	call   c0106d6a <free_pages>
    boot_pgdir[0] = 0;
c0108287:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010828c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0108292:	c7 04 24 3c b1 10 c0 	movl   $0xc010b13c,(%esp)
c0108299:	e8 0d 80 ff ff       	call   c01002ab <cprintf>
}
c010829e:	90                   	nop
c010829f:	c9                   	leave  
c01082a0:	c3                   	ret    

c01082a1 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01082a1:	55                   	push   %ebp
c01082a2:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01082a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01082a7:	83 e0 04             	and    $0x4,%eax
c01082aa:	85 c0                	test   %eax,%eax
c01082ac:	74 04                	je     c01082b2 <perm2str+0x11>
c01082ae:	b0 75                	mov    $0x75,%al
c01082b0:	eb 02                	jmp    c01082b4 <perm2str+0x13>
c01082b2:	b0 2d                	mov    $0x2d,%al
c01082b4:	a2 08 50 12 c0       	mov    %al,0xc0125008
    str[1] = 'r';
c01082b9:	c6 05 09 50 12 c0 72 	movb   $0x72,0xc0125009
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01082c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01082c3:	83 e0 02             	and    $0x2,%eax
c01082c6:	85 c0                	test   %eax,%eax
c01082c8:	74 04                	je     c01082ce <perm2str+0x2d>
c01082ca:	b0 77                	mov    $0x77,%al
c01082cc:	eb 02                	jmp    c01082d0 <perm2str+0x2f>
c01082ce:	b0 2d                	mov    $0x2d,%al
c01082d0:	a2 0a 50 12 c0       	mov    %al,0xc012500a
    str[3] = '\0';
c01082d5:	c6 05 0b 50 12 c0 00 	movb   $0x0,0xc012500b
    return str;
c01082dc:	b8 08 50 12 c0       	mov    $0xc0125008,%eax
}
c01082e1:	5d                   	pop    %ebp
c01082e2:	c3                   	ret    

c01082e3 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01082e3:	55                   	push   %ebp
c01082e4:	89 e5                	mov    %esp,%ebp
c01082e6:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01082e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01082ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01082ef:	72 0d                	jb     c01082fe <get_pgtable_items+0x1b>
        return 0;
c01082f1:	b8 00 00 00 00       	mov    $0x0,%eax
c01082f6:	e9 98 00 00 00       	jmp    c0108393 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01082fb:	ff 45 10             	incl   0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01082fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0108301:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108304:	73 18                	jae    c010831e <get_pgtable_items+0x3b>
c0108306:	8b 45 10             	mov    0x10(%ebp),%eax
c0108309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0108310:	8b 45 14             	mov    0x14(%ebp),%eax
c0108313:	01 d0                	add    %edx,%eax
c0108315:	8b 00                	mov    (%eax),%eax
c0108317:	83 e0 01             	and    $0x1,%eax
c010831a:	85 c0                	test   %eax,%eax
c010831c:	74 dd                	je     c01082fb <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c010831e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108321:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108324:	73 68                	jae    c010838e <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0108326:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010832a:	74 08                	je     c0108334 <get_pgtable_items+0x51>
            *left_store = start;
c010832c:	8b 45 18             	mov    0x18(%ebp),%eax
c010832f:	8b 55 10             	mov    0x10(%ebp),%edx
c0108332:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0108334:	8b 45 10             	mov    0x10(%ebp),%eax
c0108337:	8d 50 01             	lea    0x1(%eax),%edx
c010833a:	89 55 10             	mov    %edx,0x10(%ebp)
c010833d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0108344:	8b 45 14             	mov    0x14(%ebp),%eax
c0108347:	01 d0                	add    %edx,%eax
c0108349:	8b 00                	mov    (%eax),%eax
c010834b:	83 e0 07             	and    $0x7,%eax
c010834e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0108351:	eb 03                	jmp    c0108356 <get_pgtable_items+0x73>
            start ++;
c0108353:	ff 45 10             	incl   0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0108356:	8b 45 10             	mov    0x10(%ebp),%eax
c0108359:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010835c:	73 1d                	jae    c010837b <get_pgtable_items+0x98>
c010835e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108361:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0108368:	8b 45 14             	mov    0x14(%ebp),%eax
c010836b:	01 d0                	add    %edx,%eax
c010836d:	8b 00                	mov    (%eax),%eax
c010836f:	83 e0 07             	and    $0x7,%eax
c0108372:	89 c2                	mov    %eax,%edx
c0108374:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108377:	39 c2                	cmp    %eax,%edx
c0108379:	74 d8                	je     c0108353 <get_pgtable_items+0x70>
            start ++;
        }
        if (right_store != NULL) {
c010837b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010837f:	74 08                	je     c0108389 <get_pgtable_items+0xa6>
            *right_store = start;
c0108381:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108384:	8b 55 10             	mov    0x10(%ebp),%edx
c0108387:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0108389:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010838c:	eb 05                	jmp    c0108393 <get_pgtable_items+0xb0>
    }
    return 0;
c010838e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108393:	c9                   	leave  
c0108394:	c3                   	ret    

c0108395 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0108395:	55                   	push   %ebp
c0108396:	89 e5                	mov    %esp,%ebp
c0108398:	57                   	push   %edi
c0108399:	56                   	push   %esi
c010839a:	53                   	push   %ebx
c010839b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010839e:	c7 04 24 5c b1 10 c0 	movl   $0xc010b15c,(%esp)
c01083a5:	e8 01 7f ff ff       	call   c01002ab <cprintf>
    size_t left, right = 0, perm;
c01083aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01083b1:	e9 fa 00 00 00       	jmp    c01084b0 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01083b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01083b9:	89 04 24             	mov    %eax,(%esp)
c01083bc:	e8 e0 fe ff ff       	call   c01082a1 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01083c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01083c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01083c7:	29 d1                	sub    %edx,%ecx
c01083c9:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01083cb:	89 d6                	mov    %edx,%esi
c01083cd:	c1 e6 16             	shl    $0x16,%esi
c01083d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01083d3:	89 d3                	mov    %edx,%ebx
c01083d5:	c1 e3 16             	shl    $0x16,%ebx
c01083d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01083db:	89 d1                	mov    %edx,%ecx
c01083dd:	c1 e1 16             	shl    $0x16,%ecx
c01083e0:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01083e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01083e6:	29 d7                	sub    %edx,%edi
c01083e8:	89 fa                	mov    %edi,%edx
c01083ea:	89 44 24 14          	mov    %eax,0x14(%esp)
c01083ee:	89 74 24 10          	mov    %esi,0x10(%esp)
c01083f2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01083f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01083fa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01083fe:	c7 04 24 8d b1 10 c0 	movl   $0xc010b18d,(%esp)
c0108405:	e8 a1 7e ff ff       	call   c01002ab <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010840a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010840d:	c1 e0 0a             	shl    $0xa,%eax
c0108410:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0108413:	eb 54                	jmp    c0108469 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0108415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108418:	89 04 24             	mov    %eax,(%esp)
c010841b:	e8 81 fe ff ff       	call   c01082a1 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0108420:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0108423:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108426:	29 d1                	sub    %edx,%ecx
c0108428:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010842a:	89 d6                	mov    %edx,%esi
c010842c:	c1 e6 0c             	shl    $0xc,%esi
c010842f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108432:	89 d3                	mov    %edx,%ebx
c0108434:	c1 e3 0c             	shl    $0xc,%ebx
c0108437:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010843a:	89 d1                	mov    %edx,%ecx
c010843c:	c1 e1 0c             	shl    $0xc,%ecx
c010843f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0108442:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108445:	29 d7                	sub    %edx,%edi
c0108447:	89 fa                	mov    %edi,%edx
c0108449:	89 44 24 14          	mov    %eax,0x14(%esp)
c010844d:	89 74 24 10          	mov    %esi,0x10(%esp)
c0108451:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108455:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108459:	89 54 24 04          	mov    %edx,0x4(%esp)
c010845d:	c7 04 24 ac b1 10 c0 	movl   $0xc010b1ac,(%esp)
c0108464:	e8 42 7e ff ff       	call   c01002ab <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0108469:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c010846e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108471:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108474:	89 d3                	mov    %edx,%ebx
c0108476:	c1 e3 0a             	shl    $0xa,%ebx
c0108479:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010847c:	89 d1                	mov    %edx,%ecx
c010847e:	c1 e1 0a             	shl    $0xa,%ecx
c0108481:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0108484:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108488:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010848b:	89 54 24 10          	mov    %edx,0x10(%esp)
c010848f:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0108493:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108497:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010849b:	89 0c 24             	mov    %ecx,(%esp)
c010849e:	e8 40 fe ff ff       	call   c01082e3 <get_pgtable_items>
c01084a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01084a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01084aa:	0f 85 65 ff ff ff    	jne    c0108415 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01084b0:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01084b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01084b8:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01084bb:	89 54 24 14          	mov    %edx,0x14(%esp)
c01084bf:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01084c2:	89 54 24 10          	mov    %edx,0x10(%esp)
c01084c6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01084ca:	89 44 24 08          	mov    %eax,0x8(%esp)
c01084ce:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01084d5:	00 
c01084d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01084dd:	e8 01 fe ff ff       	call   c01082e3 <get_pgtable_items>
c01084e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01084e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01084e9:	0f 85 c7 fe ff ff    	jne    c01083b6 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01084ef:	c7 04 24 d0 b1 10 c0 	movl   $0xc010b1d0,(%esp)
c01084f6:	e8 b0 7d ff ff       	call   c01002ab <cprintf>
}
c01084fb:	90                   	nop
c01084fc:	83 c4 4c             	add    $0x4c,%esp
c01084ff:	5b                   	pop    %ebx
c0108500:	5e                   	pop    %esi
c0108501:	5f                   	pop    %edi
c0108502:	5d                   	pop    %ebp
c0108503:	c3                   	ret    

c0108504 <kmalloc>:

void *
kmalloc(size_t n) {
c0108504:	55                   	push   %ebp
c0108505:	89 e5                	mov    %esp,%ebp
c0108507:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c010850a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0108511:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0108518:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010851c:	74 09                	je     c0108527 <kmalloc+0x23>
c010851e:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0108525:	76 24                	jbe    c010854b <kmalloc+0x47>
c0108527:	c7 44 24 0c 01 b2 10 	movl   $0xc010b201,0xc(%esp)
c010852e:	c0 
c010852f:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c0108536:	c0 
c0108537:	c7 44 24 04 a6 02 00 	movl   $0x2a6,0x4(%esp)
c010853e:	00 
c010853f:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0108546:	e8 b7 7e ff ff       	call   c0100402 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c010854b:	8b 45 08             	mov    0x8(%ebp),%eax
c010854e:	05 ff 0f 00 00       	add    $0xfff,%eax
c0108553:	c1 e8 0c             	shr    $0xc,%eax
c0108556:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0108559:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010855c:	89 04 24             	mov    %eax,(%esp)
c010855f:	e8 81 e7 ff ff       	call   c0106ce5 <alloc_pages>
c0108564:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0108567:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010856b:	75 24                	jne    c0108591 <kmalloc+0x8d>
c010856d:	c7 44 24 0c 18 b2 10 	movl   $0xc010b218,0xc(%esp)
c0108574:	c0 
c0108575:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c010857c:	c0 
c010857d:	c7 44 24 04 a9 02 00 	movl   $0x2a9,0x4(%esp)
c0108584:	00 
c0108585:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c010858c:	e8 71 7e ff ff       	call   c0100402 <__panic>
    ptr=page2kva(base);
c0108591:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108594:	89 04 24             	mov    %eax,(%esp)
c0108597:	e8 5e e4 ff ff       	call   c01069fa <page2kva>
c010859c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c010859f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01085a2:	c9                   	leave  
c01085a3:	c3                   	ret    

c01085a4 <kfree>:

void 
kfree(void *ptr, size_t n) {
c01085a4:	55                   	push   %ebp
c01085a5:	89 e5                	mov    %esp,%ebp
c01085a7:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c01085aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01085ae:	74 09                	je     c01085b9 <kfree+0x15>
c01085b0:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c01085b7:	76 24                	jbe    c01085dd <kfree+0x39>
c01085b9:	c7 44 24 0c 01 b2 10 	movl   $0xc010b201,0xc(%esp)
c01085c0:	c0 
c01085c1:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c01085c8:	c0 
c01085c9:	c7 44 24 04 b0 02 00 	movl   $0x2b0,0x4(%esp)
c01085d0:	00 
c01085d1:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c01085d8:	e8 25 7e ff ff       	call   c0100402 <__panic>
    assert(ptr != NULL);
c01085dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01085e1:	75 24                	jne    c0108607 <kfree+0x63>
c01085e3:	c7 44 24 0c 25 b2 10 	movl   $0xc010b225,0xc(%esp)
c01085ea:	c0 
c01085eb:	c7 44 24 08 95 ac 10 	movl   $0xc010ac95,0x8(%esp)
c01085f2:	c0 
c01085f3:	c7 44 24 04 b1 02 00 	movl   $0x2b1,0x4(%esp)
c01085fa:	00 
c01085fb:	c7 04 24 70 ac 10 c0 	movl   $0xc010ac70,(%esp)
c0108602:	e8 fb 7d ff ff       	call   c0100402 <__panic>
    struct Page *base=NULL;
c0108607:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c010860e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108611:	05 ff 0f 00 00       	add    $0xfff,%eax
c0108616:	c1 e8 0c             	shr    $0xc,%eax
c0108619:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c010861c:	8b 45 08             	mov    0x8(%ebp),%eax
c010861f:	89 04 24             	mov    %eax,(%esp)
c0108622:	e8 27 e4 ff ff       	call   c0106a4e <kva2page>
c0108627:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c010862a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010862d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108631:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108634:	89 04 24             	mov    %eax,(%esp)
c0108637:	e8 2e e7 ff ff       	call   c0106d6a <free_pages>
}
c010863c:	90                   	nop
c010863d:	c9                   	leave  
c010863e:	c3                   	ret    

c010863f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010863f:	55                   	push   %ebp
c0108640:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108642:	8b 45 08             	mov    0x8(%ebp),%eax
c0108645:	8b 15 00 51 12 c0    	mov    0xc0125100,%edx
c010864b:	29 d0                	sub    %edx,%eax
c010864d:	c1 f8 05             	sar    $0x5,%eax
}
c0108650:	5d                   	pop    %ebp
c0108651:	c3                   	ret    

c0108652 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108652:	55                   	push   %ebp
c0108653:	89 e5                	mov    %esp,%ebp
c0108655:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108658:	8b 45 08             	mov    0x8(%ebp),%eax
c010865b:	89 04 24             	mov    %eax,(%esp)
c010865e:	e8 dc ff ff ff       	call   c010863f <page2ppn>
c0108663:	c1 e0 0c             	shl    $0xc,%eax
}
c0108666:	c9                   	leave  
c0108667:	c3                   	ret    

c0108668 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0108668:	55                   	push   %ebp
c0108669:	89 e5                	mov    %esp,%ebp
c010866b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010866e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108671:	89 04 24             	mov    %eax,(%esp)
c0108674:	e8 d9 ff ff ff       	call   c0108652 <page2pa>
c0108679:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010867c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010867f:	c1 e8 0c             	shr    $0xc,%eax
c0108682:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108685:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c010868a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010868d:	72 23                	jb     c01086b2 <page2kva+0x4a>
c010868f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108692:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108696:	c7 44 24 08 34 b2 10 	movl   $0xc010b234,0x8(%esp)
c010869d:	c0 
c010869e:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01086a5:	00 
c01086a6:	c7 04 24 57 b2 10 c0 	movl   $0xc010b257,(%esp)
c01086ad:	e8 50 7d ff ff       	call   c0100402 <__panic>
c01086b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086b5:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01086ba:	c9                   	leave  
c01086bb:	c3                   	ret    

c01086bc <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c01086bc:	55                   	push   %ebp
c01086bd:	89 e5                	mov    %esp,%ebp
c01086bf:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c01086c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01086c9:	e8 77 8a ff ff       	call   c0101145 <ide_device_valid>
c01086ce:	85 c0                	test   %eax,%eax
c01086d0:	75 1c                	jne    c01086ee <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c01086d2:	c7 44 24 08 65 b2 10 	movl   $0xc010b265,0x8(%esp)
c01086d9:	c0 
c01086da:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c01086e1:	00 
c01086e2:	c7 04 24 7f b2 10 c0 	movl   $0xc010b27f,(%esp)
c01086e9:	e8 14 7d ff ff       	call   c0100402 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c01086ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01086f5:	e8 8d 8a ff ff       	call   c0101187 <ide_device_size>
c01086fa:	c1 e8 03             	shr    $0x3,%eax
c01086fd:	a3 bc 50 12 c0       	mov    %eax,0xc01250bc
}
c0108702:	90                   	nop
c0108703:	c9                   	leave  
c0108704:	c3                   	ret    

c0108705 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0108705:	55                   	push   %ebp
c0108706:	89 e5                	mov    %esp,%ebp
c0108708:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010870b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010870e:	89 04 24             	mov    %eax,(%esp)
c0108711:	e8 52 ff ff ff       	call   c0108668 <page2kva>
c0108716:	8b 55 08             	mov    0x8(%ebp),%edx
c0108719:	c1 ea 08             	shr    $0x8,%edx
c010871c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010871f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108723:	74 0b                	je     c0108730 <swapfs_read+0x2b>
c0108725:	8b 15 bc 50 12 c0    	mov    0xc01250bc,%edx
c010872b:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010872e:	72 23                	jb     c0108753 <swapfs_read+0x4e>
c0108730:	8b 45 08             	mov    0x8(%ebp),%eax
c0108733:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108737:	c7 44 24 08 90 b2 10 	movl   $0xc010b290,0x8(%esp)
c010873e:	c0 
c010873f:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108746:	00 
c0108747:	c7 04 24 7f b2 10 c0 	movl   $0xc010b27f,(%esp)
c010874e:	e8 af 7c ff ff       	call   c0100402 <__panic>
c0108753:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108756:	c1 e2 03             	shl    $0x3,%edx
c0108759:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108760:	00 
c0108761:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108765:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108769:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108770:	e8 51 8a ff ff       	call   c01011c6 <ide_read_secs>
}
c0108775:	c9                   	leave  
c0108776:	c3                   	ret    

c0108777 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0108777:	55                   	push   %ebp
c0108778:	89 e5                	mov    %esp,%ebp
c010877a:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010877d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108780:	89 04 24             	mov    %eax,(%esp)
c0108783:	e8 e0 fe ff ff       	call   c0108668 <page2kva>
c0108788:	8b 55 08             	mov    0x8(%ebp),%edx
c010878b:	c1 ea 08             	shr    $0x8,%edx
c010878e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108795:	74 0b                	je     c01087a2 <swapfs_write+0x2b>
c0108797:	8b 15 bc 50 12 c0    	mov    0xc01250bc,%edx
c010879d:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01087a0:	72 23                	jb     c01087c5 <swapfs_write+0x4e>
c01087a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01087a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01087a9:	c7 44 24 08 90 b2 10 	movl   $0xc010b290,0x8(%esp)
c01087b0:	c0 
c01087b1:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c01087b8:	00 
c01087b9:	c7 04 24 7f b2 10 c0 	movl   $0xc010b27f,(%esp)
c01087c0:	e8 3d 7c ff ff       	call   c0100402 <__panic>
c01087c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01087c8:	c1 e2 03             	shl    $0x3,%edx
c01087cb:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01087d2:	00 
c01087d3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01087d7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01087db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01087e2:	e8 19 8c ff ff       	call   c0101400 <ide_write_secs>
}
c01087e7:	c9                   	leave  
c01087e8:	c3                   	ret    

c01087e9 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01087e9:	55                   	push   %ebp
c01087ea:	89 e5                	mov    %esp,%ebp
c01087ec:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01087ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01087f6:	eb 03                	jmp    c01087fb <strlen+0x12>
        cnt ++;
c01087f8:	ff 45 fc             	incl   -0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01087fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01087fe:	8d 50 01             	lea    0x1(%eax),%edx
c0108801:	89 55 08             	mov    %edx,0x8(%ebp)
c0108804:	0f b6 00             	movzbl (%eax),%eax
c0108807:	84 c0                	test   %al,%al
c0108809:	75 ed                	jne    c01087f8 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010880b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010880e:	c9                   	leave  
c010880f:	c3                   	ret    

c0108810 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0108810:	55                   	push   %ebp
c0108811:	89 e5                	mov    %esp,%ebp
c0108813:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108816:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010881d:	eb 03                	jmp    c0108822 <strnlen+0x12>
        cnt ++;
c010881f:	ff 45 fc             	incl   -0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0108822:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108825:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108828:	73 10                	jae    c010883a <strnlen+0x2a>
c010882a:	8b 45 08             	mov    0x8(%ebp),%eax
c010882d:	8d 50 01             	lea    0x1(%eax),%edx
c0108830:	89 55 08             	mov    %edx,0x8(%ebp)
c0108833:	0f b6 00             	movzbl (%eax),%eax
c0108836:	84 c0                	test   %al,%al
c0108838:	75 e5                	jne    c010881f <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010883a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010883d:	c9                   	leave  
c010883e:	c3                   	ret    

c010883f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010883f:	55                   	push   %ebp
c0108840:	89 e5                	mov    %esp,%ebp
c0108842:	57                   	push   %edi
c0108843:	56                   	push   %esi
c0108844:	83 ec 20             	sub    $0x20,%esp
c0108847:	8b 45 08             	mov    0x8(%ebp),%eax
c010884a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010884d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108850:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0108853:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108856:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108859:	89 d1                	mov    %edx,%ecx
c010885b:	89 c2                	mov    %eax,%edx
c010885d:	89 ce                	mov    %ecx,%esi
c010885f:	89 d7                	mov    %edx,%edi
c0108861:	ac                   	lods   %ds:(%esi),%al
c0108862:	aa                   	stos   %al,%es:(%edi)
c0108863:	84 c0                	test   %al,%al
c0108865:	75 fa                	jne    c0108861 <strcpy+0x22>
c0108867:	89 fa                	mov    %edi,%edx
c0108869:	89 f1                	mov    %esi,%ecx
c010886b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010886e:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108871:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0108874:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0108877:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0108878:	83 c4 20             	add    $0x20,%esp
c010887b:	5e                   	pop    %esi
c010887c:	5f                   	pop    %edi
c010887d:	5d                   	pop    %ebp
c010887e:	c3                   	ret    

c010887f <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010887f:	55                   	push   %ebp
c0108880:	89 e5                	mov    %esp,%ebp
c0108882:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0108885:	8b 45 08             	mov    0x8(%ebp),%eax
c0108888:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010888b:	eb 1e                	jmp    c01088ab <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c010888d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108890:	0f b6 10             	movzbl (%eax),%edx
c0108893:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108896:	88 10                	mov    %dl,(%eax)
c0108898:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010889b:	0f b6 00             	movzbl (%eax),%eax
c010889e:	84 c0                	test   %al,%al
c01088a0:	74 03                	je     c01088a5 <strncpy+0x26>
            src ++;
c01088a2:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01088a5:	ff 45 fc             	incl   -0x4(%ebp)
c01088a8:	ff 4d 10             	decl   0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01088ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01088af:	75 dc                	jne    c010888d <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01088b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01088b4:	c9                   	leave  
c01088b5:	c3                   	ret    

c01088b6 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01088b6:	55                   	push   %ebp
c01088b7:	89 e5                	mov    %esp,%ebp
c01088b9:	57                   	push   %edi
c01088ba:	56                   	push   %esi
c01088bb:	83 ec 20             	sub    $0x20,%esp
c01088be:	8b 45 08             	mov    0x8(%ebp),%eax
c01088c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01088c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01088ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01088cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01088d0:	89 d1                	mov    %edx,%ecx
c01088d2:	89 c2                	mov    %eax,%edx
c01088d4:	89 ce                	mov    %ecx,%esi
c01088d6:	89 d7                	mov    %edx,%edi
c01088d8:	ac                   	lods   %ds:(%esi),%al
c01088d9:	ae                   	scas   %es:(%edi),%al
c01088da:	75 08                	jne    c01088e4 <strcmp+0x2e>
c01088dc:	84 c0                	test   %al,%al
c01088de:	75 f8                	jne    c01088d8 <strcmp+0x22>
c01088e0:	31 c0                	xor    %eax,%eax
c01088e2:	eb 04                	jmp    c01088e8 <strcmp+0x32>
c01088e4:	19 c0                	sbb    %eax,%eax
c01088e6:	0c 01                	or     $0x1,%al
c01088e8:	89 fa                	mov    %edi,%edx
c01088ea:	89 f1                	mov    %esi,%ecx
c01088ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01088ef:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01088f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01088f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c01088f8:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01088f9:	83 c4 20             	add    $0x20,%esp
c01088fc:	5e                   	pop    %esi
c01088fd:	5f                   	pop    %edi
c01088fe:	5d                   	pop    %ebp
c01088ff:	c3                   	ret    

c0108900 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0108900:	55                   	push   %ebp
c0108901:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108903:	eb 09                	jmp    c010890e <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0108905:	ff 4d 10             	decl   0x10(%ebp)
c0108908:	ff 45 08             	incl   0x8(%ebp)
c010890b:	ff 45 0c             	incl   0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010890e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108912:	74 1a                	je     c010892e <strncmp+0x2e>
c0108914:	8b 45 08             	mov    0x8(%ebp),%eax
c0108917:	0f b6 00             	movzbl (%eax),%eax
c010891a:	84 c0                	test   %al,%al
c010891c:	74 10                	je     c010892e <strncmp+0x2e>
c010891e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108921:	0f b6 10             	movzbl (%eax),%edx
c0108924:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108927:	0f b6 00             	movzbl (%eax),%eax
c010892a:	38 c2                	cmp    %al,%dl
c010892c:	74 d7                	je     c0108905 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010892e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108932:	74 18                	je     c010894c <strncmp+0x4c>
c0108934:	8b 45 08             	mov    0x8(%ebp),%eax
c0108937:	0f b6 00             	movzbl (%eax),%eax
c010893a:	0f b6 d0             	movzbl %al,%edx
c010893d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108940:	0f b6 00             	movzbl (%eax),%eax
c0108943:	0f b6 c0             	movzbl %al,%eax
c0108946:	29 c2                	sub    %eax,%edx
c0108948:	89 d0                	mov    %edx,%eax
c010894a:	eb 05                	jmp    c0108951 <strncmp+0x51>
c010894c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108951:	5d                   	pop    %ebp
c0108952:	c3                   	ret    

c0108953 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0108953:	55                   	push   %ebp
c0108954:	89 e5                	mov    %esp,%ebp
c0108956:	83 ec 04             	sub    $0x4,%esp
c0108959:	8b 45 0c             	mov    0xc(%ebp),%eax
c010895c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010895f:	eb 13                	jmp    c0108974 <strchr+0x21>
        if (*s == c) {
c0108961:	8b 45 08             	mov    0x8(%ebp),%eax
c0108964:	0f b6 00             	movzbl (%eax),%eax
c0108967:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010896a:	75 05                	jne    c0108971 <strchr+0x1e>
            return (char *)s;
c010896c:	8b 45 08             	mov    0x8(%ebp),%eax
c010896f:	eb 12                	jmp    c0108983 <strchr+0x30>
        }
        s ++;
c0108971:	ff 45 08             	incl   0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0108974:	8b 45 08             	mov    0x8(%ebp),%eax
c0108977:	0f b6 00             	movzbl (%eax),%eax
c010897a:	84 c0                	test   %al,%al
c010897c:	75 e3                	jne    c0108961 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010897e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108983:	c9                   	leave  
c0108984:	c3                   	ret    

c0108985 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0108985:	55                   	push   %ebp
c0108986:	89 e5                	mov    %esp,%ebp
c0108988:	83 ec 04             	sub    $0x4,%esp
c010898b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010898e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108991:	eb 0e                	jmp    c01089a1 <strfind+0x1c>
        if (*s == c) {
c0108993:	8b 45 08             	mov    0x8(%ebp),%eax
c0108996:	0f b6 00             	movzbl (%eax),%eax
c0108999:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010899c:	74 0f                	je     c01089ad <strfind+0x28>
            break;
        }
        s ++;
c010899e:	ff 45 08             	incl   0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01089a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01089a4:	0f b6 00             	movzbl (%eax),%eax
c01089a7:	84 c0                	test   %al,%al
c01089a9:	75 e8                	jne    c0108993 <strfind+0xe>
c01089ab:	eb 01                	jmp    c01089ae <strfind+0x29>
        if (*s == c) {
            break;
c01089ad:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c01089ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01089b1:	c9                   	leave  
c01089b2:	c3                   	ret    

c01089b3 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01089b3:	55                   	push   %ebp
c01089b4:	89 e5                	mov    %esp,%ebp
c01089b6:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01089b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01089c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01089c7:	eb 03                	jmp    c01089cc <strtol+0x19>
        s ++;
c01089c9:	ff 45 08             	incl   0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01089cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01089cf:	0f b6 00             	movzbl (%eax),%eax
c01089d2:	3c 20                	cmp    $0x20,%al
c01089d4:	74 f3                	je     c01089c9 <strtol+0x16>
c01089d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01089d9:	0f b6 00             	movzbl (%eax),%eax
c01089dc:	3c 09                	cmp    $0x9,%al
c01089de:	74 e9                	je     c01089c9 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01089e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e3:	0f b6 00             	movzbl (%eax),%eax
c01089e6:	3c 2b                	cmp    $0x2b,%al
c01089e8:	75 05                	jne    c01089ef <strtol+0x3c>
        s ++;
c01089ea:	ff 45 08             	incl   0x8(%ebp)
c01089ed:	eb 14                	jmp    c0108a03 <strtol+0x50>
    }
    else if (*s == '-') {
c01089ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01089f2:	0f b6 00             	movzbl (%eax),%eax
c01089f5:	3c 2d                	cmp    $0x2d,%al
c01089f7:	75 0a                	jne    c0108a03 <strtol+0x50>
        s ++, neg = 1;
c01089f9:	ff 45 08             	incl   0x8(%ebp)
c01089fc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0108a03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108a07:	74 06                	je     c0108a0f <strtol+0x5c>
c0108a09:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0108a0d:	75 22                	jne    c0108a31 <strtol+0x7e>
c0108a0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a12:	0f b6 00             	movzbl (%eax),%eax
c0108a15:	3c 30                	cmp    $0x30,%al
c0108a17:	75 18                	jne    c0108a31 <strtol+0x7e>
c0108a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a1c:	40                   	inc    %eax
c0108a1d:	0f b6 00             	movzbl (%eax),%eax
c0108a20:	3c 78                	cmp    $0x78,%al
c0108a22:	75 0d                	jne    c0108a31 <strtol+0x7e>
        s += 2, base = 16;
c0108a24:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108a28:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0108a2f:	eb 29                	jmp    c0108a5a <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0108a31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108a35:	75 16                	jne    c0108a4d <strtol+0x9a>
c0108a37:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a3a:	0f b6 00             	movzbl (%eax),%eax
c0108a3d:	3c 30                	cmp    $0x30,%al
c0108a3f:	75 0c                	jne    c0108a4d <strtol+0x9a>
        s ++, base = 8;
c0108a41:	ff 45 08             	incl   0x8(%ebp)
c0108a44:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108a4b:	eb 0d                	jmp    c0108a5a <strtol+0xa7>
    }
    else if (base == 0) {
c0108a4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108a51:	75 07                	jne    c0108a5a <strtol+0xa7>
        base = 10;
c0108a53:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108a5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a5d:	0f b6 00             	movzbl (%eax),%eax
c0108a60:	3c 2f                	cmp    $0x2f,%al
c0108a62:	7e 1b                	jle    c0108a7f <strtol+0xcc>
c0108a64:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a67:	0f b6 00             	movzbl (%eax),%eax
c0108a6a:	3c 39                	cmp    $0x39,%al
c0108a6c:	7f 11                	jg     c0108a7f <strtol+0xcc>
            dig = *s - '0';
c0108a6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a71:	0f b6 00             	movzbl (%eax),%eax
c0108a74:	0f be c0             	movsbl %al,%eax
c0108a77:	83 e8 30             	sub    $0x30,%eax
c0108a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a7d:	eb 48                	jmp    c0108ac7 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0108a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a82:	0f b6 00             	movzbl (%eax),%eax
c0108a85:	3c 60                	cmp    $0x60,%al
c0108a87:	7e 1b                	jle    c0108aa4 <strtol+0xf1>
c0108a89:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a8c:	0f b6 00             	movzbl (%eax),%eax
c0108a8f:	3c 7a                	cmp    $0x7a,%al
c0108a91:	7f 11                	jg     c0108aa4 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0108a93:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a96:	0f b6 00             	movzbl (%eax),%eax
c0108a99:	0f be c0             	movsbl %al,%eax
c0108a9c:	83 e8 57             	sub    $0x57,%eax
c0108a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108aa2:	eb 23                	jmp    c0108ac7 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0108aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aa7:	0f b6 00             	movzbl (%eax),%eax
c0108aaa:	3c 40                	cmp    $0x40,%al
c0108aac:	7e 3b                	jle    c0108ae9 <strtol+0x136>
c0108aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ab1:	0f b6 00             	movzbl (%eax),%eax
c0108ab4:	3c 5a                	cmp    $0x5a,%al
c0108ab6:	7f 31                	jg     c0108ae9 <strtol+0x136>
            dig = *s - 'A' + 10;
c0108ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108abb:	0f b6 00             	movzbl (%eax),%eax
c0108abe:	0f be c0             	movsbl %al,%eax
c0108ac1:	83 e8 37             	sub    $0x37,%eax
c0108ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108aca:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108acd:	7d 19                	jge    c0108ae8 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0108acf:	ff 45 08             	incl   0x8(%ebp)
c0108ad2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108ad5:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108ad9:	89 c2                	mov    %eax,%edx
c0108adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ade:	01 d0                	add    %edx,%eax
c0108ae0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0108ae3:	e9 72 ff ff ff       	jmp    c0108a5a <strtol+0xa7>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0108ae8:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0108ae9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108aed:	74 08                	je     c0108af7 <strtol+0x144>
        *endptr = (char *) s;
c0108aef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108af2:	8b 55 08             	mov    0x8(%ebp),%edx
c0108af5:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108af7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108afb:	74 07                	je     c0108b04 <strtol+0x151>
c0108afd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108b00:	f7 d8                	neg    %eax
c0108b02:	eb 03                	jmp    c0108b07 <strtol+0x154>
c0108b04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108b07:	c9                   	leave  
c0108b08:	c3                   	ret    

c0108b09 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108b09:	55                   	push   %ebp
c0108b0a:	89 e5                	mov    %esp,%ebp
c0108b0c:	57                   	push   %edi
c0108b0d:	83 ec 24             	sub    $0x24,%esp
c0108b10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b13:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108b16:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108b1a:	8b 55 08             	mov    0x8(%ebp),%edx
c0108b1d:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0108b20:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108b23:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108b29:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108b2c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0108b30:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108b33:	89 d7                	mov    %edx,%edi
c0108b35:	f3 aa                	rep stos %al,%es:(%edi)
c0108b37:	89 fa                	mov    %edi,%edx
c0108b39:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108b3c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108b42:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108b43:	83 c4 24             	add    $0x24,%esp
c0108b46:	5f                   	pop    %edi
c0108b47:	5d                   	pop    %ebp
c0108b48:	c3                   	ret    

c0108b49 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108b49:	55                   	push   %ebp
c0108b4a:	89 e5                	mov    %esp,%ebp
c0108b4c:	57                   	push   %edi
c0108b4d:	56                   	push   %esi
c0108b4e:	53                   	push   %ebx
c0108b4f:	83 ec 30             	sub    $0x30,%esp
c0108b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b58:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108b5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b61:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b67:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108b6a:	73 42                	jae    c0108bae <memmove+0x65>
c0108b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b75:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108b78:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108b7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b81:	c1 e8 02             	shr    $0x2,%eax
c0108b84:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108b86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108b89:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108b8c:	89 d7                	mov    %edx,%edi
c0108b8e:	89 c6                	mov    %eax,%esi
c0108b90:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108b92:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108b95:	83 e1 03             	and    $0x3,%ecx
c0108b98:	74 02                	je     c0108b9c <memmove+0x53>
c0108b9a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108b9c:	89 f0                	mov    %esi,%eax
c0108b9e:	89 fa                	mov    %edi,%edx
c0108ba0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108ba3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108ba6:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108ba9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0108bac:	eb 36                	jmp    c0108be4 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bb1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108bb7:	01 c2                	add    %eax,%edx
c0108bb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bbc:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0108bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bc2:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0108bc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bc8:	89 c1                	mov    %eax,%ecx
c0108bca:	89 d8                	mov    %ebx,%eax
c0108bcc:	89 d6                	mov    %edx,%esi
c0108bce:	89 c7                	mov    %eax,%edi
c0108bd0:	fd                   	std    
c0108bd1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108bd3:	fc                   	cld    
c0108bd4:	89 f8                	mov    %edi,%eax
c0108bd6:	89 f2                	mov    %esi,%edx
c0108bd8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108bdb:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108bde:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0108be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108be4:	83 c4 30             	add    $0x30,%esp
c0108be7:	5b                   	pop    %ebx
c0108be8:	5e                   	pop    %esi
c0108be9:	5f                   	pop    %edi
c0108bea:	5d                   	pop    %ebp
c0108beb:	c3                   	ret    

c0108bec <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108bec:	55                   	push   %ebp
c0108bed:	89 e5                	mov    %esp,%ebp
c0108bef:	57                   	push   %edi
c0108bf0:	56                   	push   %esi
c0108bf1:	83 ec 20             	sub    $0x20,%esp
c0108bf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108bfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108c00:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c03:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c09:	c1 e8 02             	shr    $0x2,%eax
c0108c0c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c14:	89 d7                	mov    %edx,%edi
c0108c16:	89 c6                	mov    %eax,%esi
c0108c18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108c1a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108c1d:	83 e1 03             	and    $0x3,%ecx
c0108c20:	74 02                	je     c0108c24 <memcpy+0x38>
c0108c22:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108c24:	89 f0                	mov    %esi,%eax
c0108c26:	89 fa                	mov    %edi,%edx
c0108c28:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108c2b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108c2e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0108c34:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108c35:	83 c4 20             	add    $0x20,%esp
c0108c38:	5e                   	pop    %esi
c0108c39:	5f                   	pop    %edi
c0108c3a:	5d                   	pop    %ebp
c0108c3b:	c3                   	ret    

c0108c3c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108c3c:	55                   	push   %ebp
c0108c3d:	89 e5                	mov    %esp,%ebp
c0108c3f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108c42:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c45:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108c48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108c4e:	eb 2e                	jmp    c0108c7e <memcmp+0x42>
        if (*s1 != *s2) {
c0108c50:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108c53:	0f b6 10             	movzbl (%eax),%edx
c0108c56:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108c59:	0f b6 00             	movzbl (%eax),%eax
c0108c5c:	38 c2                	cmp    %al,%dl
c0108c5e:	74 18                	je     c0108c78 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108c63:	0f b6 00             	movzbl (%eax),%eax
c0108c66:	0f b6 d0             	movzbl %al,%edx
c0108c69:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108c6c:	0f b6 00             	movzbl (%eax),%eax
c0108c6f:	0f b6 c0             	movzbl %al,%eax
c0108c72:	29 c2                	sub    %eax,%edx
c0108c74:	89 d0                	mov    %edx,%eax
c0108c76:	eb 18                	jmp    c0108c90 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0108c78:	ff 45 fc             	incl   -0x4(%ebp)
c0108c7b:	ff 45 f8             	incl   -0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0108c7e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c81:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108c84:	89 55 10             	mov    %edx,0x10(%ebp)
c0108c87:	85 c0                	test   %eax,%eax
c0108c89:	75 c5                	jne    c0108c50 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108c8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108c90:	c9                   	leave  
c0108c91:	c3                   	ret    

c0108c92 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0108c92:	55                   	push   %ebp
c0108c93:	89 e5                	mov    %esp,%ebp
c0108c95:	83 ec 58             	sub    $0x58,%esp
c0108c98:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c9b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0108c9e:	8b 45 14             	mov    0x14(%ebp),%eax
c0108ca1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0108ca4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108ca7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108caa:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108cad:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0108cb0:	8b 45 18             	mov    0x18(%ebp),%eax
c0108cb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108cb9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108cbc:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108cbf:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0108cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108cc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108ccc:	74 1c                	je     c0108cea <printnum+0x58>
c0108cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108cd1:	ba 00 00 00 00       	mov    $0x0,%edx
c0108cd6:	f7 75 e4             	divl   -0x1c(%ebp)
c0108cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108cdf:	ba 00 00 00 00       	mov    $0x0,%edx
c0108ce4:	f7 75 e4             	divl   -0x1c(%ebp)
c0108ce7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108cea:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108cf0:	f7 75 e4             	divl   -0x1c(%ebp)
c0108cf3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108cf6:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0108cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108cfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108cff:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108d02:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108d05:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108d08:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0108d0b:	8b 45 18             	mov    0x18(%ebp),%eax
c0108d0e:	ba 00 00 00 00       	mov    $0x0,%edx
c0108d13:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108d16:	77 56                	ja     c0108d6e <printnum+0xdc>
c0108d18:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108d1b:	72 05                	jb     c0108d22 <printnum+0x90>
c0108d1d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0108d20:	77 4c                	ja     c0108d6e <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0108d22:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108d25:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108d28:	8b 45 20             	mov    0x20(%ebp),%eax
c0108d2b:	89 44 24 18          	mov    %eax,0x18(%esp)
c0108d2f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108d33:	8b 45 18             	mov    0x18(%ebp),%eax
c0108d36:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108d3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108d40:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108d44:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108d48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d52:	89 04 24             	mov    %eax,(%esp)
c0108d55:	e8 38 ff ff ff       	call   c0108c92 <printnum>
c0108d5a:	eb 1b                	jmp    c0108d77 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0108d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d63:	8b 45 20             	mov    0x20(%ebp),%eax
c0108d66:	89 04 24             	mov    %eax,(%esp)
c0108d69:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d6c:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0108d6e:	ff 4d 1c             	decl   0x1c(%ebp)
c0108d71:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0108d75:	7f e5                	jg     c0108d5c <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0108d77:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108d7a:	05 30 b3 10 c0       	add    $0xc010b330,%eax
c0108d7f:	0f b6 00             	movzbl (%eax),%eax
c0108d82:	0f be c0             	movsbl %al,%eax
c0108d85:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108d88:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108d8c:	89 04 24             	mov    %eax,(%esp)
c0108d8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d92:	ff d0                	call   *%eax
}
c0108d94:	90                   	nop
c0108d95:	c9                   	leave  
c0108d96:	c3                   	ret    

c0108d97 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0108d97:	55                   	push   %ebp
c0108d98:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108d9a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108d9e:	7e 14                	jle    c0108db4 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0108da0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108da3:	8b 00                	mov    (%eax),%eax
c0108da5:	8d 48 08             	lea    0x8(%eax),%ecx
c0108da8:	8b 55 08             	mov    0x8(%ebp),%edx
c0108dab:	89 0a                	mov    %ecx,(%edx)
c0108dad:	8b 50 04             	mov    0x4(%eax),%edx
c0108db0:	8b 00                	mov    (%eax),%eax
c0108db2:	eb 30                	jmp    c0108de4 <getuint+0x4d>
    }
    else if (lflag) {
c0108db4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108db8:	74 16                	je     c0108dd0 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0108dba:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dbd:	8b 00                	mov    (%eax),%eax
c0108dbf:	8d 48 04             	lea    0x4(%eax),%ecx
c0108dc2:	8b 55 08             	mov    0x8(%ebp),%edx
c0108dc5:	89 0a                	mov    %ecx,(%edx)
c0108dc7:	8b 00                	mov    (%eax),%eax
c0108dc9:	ba 00 00 00 00       	mov    $0x0,%edx
c0108dce:	eb 14                	jmp    c0108de4 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0108dd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dd3:	8b 00                	mov    (%eax),%eax
c0108dd5:	8d 48 04             	lea    0x4(%eax),%ecx
c0108dd8:	8b 55 08             	mov    0x8(%ebp),%edx
c0108ddb:	89 0a                	mov    %ecx,(%edx)
c0108ddd:	8b 00                	mov    (%eax),%eax
c0108ddf:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0108de4:	5d                   	pop    %ebp
c0108de5:	c3                   	ret    

c0108de6 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0108de6:	55                   	push   %ebp
c0108de7:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108de9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108ded:	7e 14                	jle    c0108e03 <getint+0x1d>
        return va_arg(*ap, long long);
c0108def:	8b 45 08             	mov    0x8(%ebp),%eax
c0108df2:	8b 00                	mov    (%eax),%eax
c0108df4:	8d 48 08             	lea    0x8(%eax),%ecx
c0108df7:	8b 55 08             	mov    0x8(%ebp),%edx
c0108dfa:	89 0a                	mov    %ecx,(%edx)
c0108dfc:	8b 50 04             	mov    0x4(%eax),%edx
c0108dff:	8b 00                	mov    (%eax),%eax
c0108e01:	eb 28                	jmp    c0108e2b <getint+0x45>
    }
    else if (lflag) {
c0108e03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108e07:	74 12                	je     c0108e1b <getint+0x35>
        return va_arg(*ap, long);
c0108e09:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e0c:	8b 00                	mov    (%eax),%eax
c0108e0e:	8d 48 04             	lea    0x4(%eax),%ecx
c0108e11:	8b 55 08             	mov    0x8(%ebp),%edx
c0108e14:	89 0a                	mov    %ecx,(%edx)
c0108e16:	8b 00                	mov    (%eax),%eax
c0108e18:	99                   	cltd   
c0108e19:	eb 10                	jmp    c0108e2b <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0108e1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e1e:	8b 00                	mov    (%eax),%eax
c0108e20:	8d 48 04             	lea    0x4(%eax),%ecx
c0108e23:	8b 55 08             	mov    0x8(%ebp),%edx
c0108e26:	89 0a                	mov    %ecx,(%edx)
c0108e28:	8b 00                	mov    (%eax),%eax
c0108e2a:	99                   	cltd   
    }
}
c0108e2b:	5d                   	pop    %ebp
c0108e2c:	c3                   	ret    

c0108e2d <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0108e2d:	55                   	push   %ebp
c0108e2e:	89 e5                	mov    %esp,%ebp
c0108e30:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0108e33:	8d 45 14             	lea    0x14(%ebp),%eax
c0108e36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0108e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108e3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108e40:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e43:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108e47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e51:	89 04 24             	mov    %eax,(%esp)
c0108e54:	e8 03 00 00 00       	call   c0108e5c <vprintfmt>
    va_end(ap);
}
c0108e59:	90                   	nop
c0108e5a:	c9                   	leave  
c0108e5b:	c3                   	ret    

c0108e5c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0108e5c:	55                   	push   %ebp
c0108e5d:	89 e5                	mov    %esp,%ebp
c0108e5f:	56                   	push   %esi
c0108e60:	53                   	push   %ebx
c0108e61:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108e64:	eb 17                	jmp    c0108e7d <vprintfmt+0x21>
            if (ch == '\0') {
c0108e66:	85 db                	test   %ebx,%ebx
c0108e68:	0f 84 bf 03 00 00    	je     c010922d <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0108e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108e71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e75:	89 1c 24             	mov    %ebx,(%esp)
c0108e78:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e7b:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108e7d:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e80:	8d 50 01             	lea    0x1(%eax),%edx
c0108e83:	89 55 10             	mov    %edx,0x10(%ebp)
c0108e86:	0f b6 00             	movzbl (%eax),%eax
c0108e89:	0f b6 d8             	movzbl %al,%ebx
c0108e8c:	83 fb 25             	cmp    $0x25,%ebx
c0108e8f:	75 d5                	jne    c0108e66 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0108e91:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0108e95:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0108e9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108e9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0108ea2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0108ea9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108eac:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0108eaf:	8b 45 10             	mov    0x10(%ebp),%eax
c0108eb2:	8d 50 01             	lea    0x1(%eax),%edx
c0108eb5:	89 55 10             	mov    %edx,0x10(%ebp)
c0108eb8:	0f b6 00             	movzbl (%eax),%eax
c0108ebb:	0f b6 d8             	movzbl %al,%ebx
c0108ebe:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0108ec1:	83 f8 55             	cmp    $0x55,%eax
c0108ec4:	0f 87 37 03 00 00    	ja     c0109201 <vprintfmt+0x3a5>
c0108eca:	8b 04 85 54 b3 10 c0 	mov    -0x3fef4cac(,%eax,4),%eax
c0108ed1:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0108ed3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0108ed7:	eb d6                	jmp    c0108eaf <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0108ed9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0108edd:	eb d0                	jmp    c0108eaf <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108edf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0108ee6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108ee9:	89 d0                	mov    %edx,%eax
c0108eeb:	c1 e0 02             	shl    $0x2,%eax
c0108eee:	01 d0                	add    %edx,%eax
c0108ef0:	01 c0                	add    %eax,%eax
c0108ef2:	01 d8                	add    %ebx,%eax
c0108ef4:	83 e8 30             	sub    $0x30,%eax
c0108ef7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0108efa:	8b 45 10             	mov    0x10(%ebp),%eax
c0108efd:	0f b6 00             	movzbl (%eax),%eax
c0108f00:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0108f03:	83 fb 2f             	cmp    $0x2f,%ebx
c0108f06:	7e 38                	jle    c0108f40 <vprintfmt+0xe4>
c0108f08:	83 fb 39             	cmp    $0x39,%ebx
c0108f0b:	7f 33                	jg     c0108f40 <vprintfmt+0xe4>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108f0d:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0108f10:	eb d4                	jmp    c0108ee6 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0108f12:	8b 45 14             	mov    0x14(%ebp),%eax
c0108f15:	8d 50 04             	lea    0x4(%eax),%edx
c0108f18:	89 55 14             	mov    %edx,0x14(%ebp)
c0108f1b:	8b 00                	mov    (%eax),%eax
c0108f1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0108f20:	eb 1f                	jmp    c0108f41 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0108f22:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108f26:	79 87                	jns    c0108eaf <vprintfmt+0x53>
                width = 0;
c0108f28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0108f2f:	e9 7b ff ff ff       	jmp    c0108eaf <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0108f34:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0108f3b:	e9 6f ff ff ff       	jmp    c0108eaf <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c0108f40:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c0108f41:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108f45:	0f 89 64 ff ff ff    	jns    c0108eaf <vprintfmt+0x53>
                width = precision, precision = -1;
c0108f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108f4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108f51:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0108f58:	e9 52 ff ff ff       	jmp    c0108eaf <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0108f5d:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0108f60:	e9 4a ff ff ff       	jmp    c0108eaf <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108f65:	8b 45 14             	mov    0x14(%ebp),%eax
c0108f68:	8d 50 04             	lea    0x4(%eax),%edx
c0108f6b:	89 55 14             	mov    %edx,0x14(%ebp)
c0108f6e:	8b 00                	mov    (%eax),%eax
c0108f70:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108f73:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108f77:	89 04 24             	mov    %eax,(%esp)
c0108f7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f7d:	ff d0                	call   *%eax
            break;
c0108f7f:	e9 a4 02 00 00       	jmp    c0109228 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0108f84:	8b 45 14             	mov    0x14(%ebp),%eax
c0108f87:	8d 50 04             	lea    0x4(%eax),%edx
c0108f8a:	89 55 14             	mov    %edx,0x14(%ebp)
c0108f8d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0108f8f:	85 db                	test   %ebx,%ebx
c0108f91:	79 02                	jns    c0108f95 <vprintfmt+0x139>
                err = -err;
c0108f93:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0108f95:	83 fb 06             	cmp    $0x6,%ebx
c0108f98:	7f 0b                	jg     c0108fa5 <vprintfmt+0x149>
c0108f9a:	8b 34 9d 14 b3 10 c0 	mov    -0x3fef4cec(,%ebx,4),%esi
c0108fa1:	85 f6                	test   %esi,%esi
c0108fa3:	75 23                	jne    c0108fc8 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0108fa5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108fa9:	c7 44 24 08 41 b3 10 	movl   $0xc010b341,0x8(%esp)
c0108fb0:	c0 
c0108fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108fb4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108fb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fbb:	89 04 24             	mov    %eax,(%esp)
c0108fbe:	e8 6a fe ff ff       	call   c0108e2d <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0108fc3:	e9 60 02 00 00       	jmp    c0109228 <vprintfmt+0x3cc>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0108fc8:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0108fcc:	c7 44 24 08 4a b3 10 	movl   $0xc010b34a,0x8(%esp)
c0108fd3:	c0 
c0108fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108fdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fde:	89 04 24             	mov    %eax,(%esp)
c0108fe1:	e8 47 fe ff ff       	call   c0108e2d <printfmt>
            }
            break;
c0108fe6:	e9 3d 02 00 00       	jmp    c0109228 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0108feb:	8b 45 14             	mov    0x14(%ebp),%eax
c0108fee:	8d 50 04             	lea    0x4(%eax),%edx
c0108ff1:	89 55 14             	mov    %edx,0x14(%ebp)
c0108ff4:	8b 30                	mov    (%eax),%esi
c0108ff6:	85 f6                	test   %esi,%esi
c0108ff8:	75 05                	jne    c0108fff <vprintfmt+0x1a3>
                p = "(null)";
c0108ffa:	be 4d b3 10 c0       	mov    $0xc010b34d,%esi
            }
            if (width > 0 && padc != '-') {
c0108fff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109003:	7e 76                	jle    c010907b <vprintfmt+0x21f>
c0109005:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0109009:	74 70                	je     c010907b <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010900b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010900e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109012:	89 34 24             	mov    %esi,(%esp)
c0109015:	e8 f6 f7 ff ff       	call   c0108810 <strnlen>
c010901a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010901d:	29 c2                	sub    %eax,%edx
c010901f:	89 d0                	mov    %edx,%eax
c0109021:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109024:	eb 16                	jmp    c010903c <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0109026:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010902a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010902d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109031:	89 04 24             	mov    %eax,(%esp)
c0109034:	8b 45 08             	mov    0x8(%ebp),%eax
c0109037:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109039:	ff 4d e8             	decl   -0x18(%ebp)
c010903c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109040:	7f e4                	jg     c0109026 <vprintfmt+0x1ca>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109042:	eb 37                	jmp    c010907b <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0109044:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0109048:	74 1f                	je     c0109069 <vprintfmt+0x20d>
c010904a:	83 fb 1f             	cmp    $0x1f,%ebx
c010904d:	7e 05                	jle    c0109054 <vprintfmt+0x1f8>
c010904f:	83 fb 7e             	cmp    $0x7e,%ebx
c0109052:	7e 15                	jle    c0109069 <vprintfmt+0x20d>
                    putch('?', putdat);
c0109054:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109057:	89 44 24 04          	mov    %eax,0x4(%esp)
c010905b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0109062:	8b 45 08             	mov    0x8(%ebp),%eax
c0109065:	ff d0                	call   *%eax
c0109067:	eb 0f                	jmp    c0109078 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0109069:	8b 45 0c             	mov    0xc(%ebp),%eax
c010906c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109070:	89 1c 24             	mov    %ebx,(%esp)
c0109073:	8b 45 08             	mov    0x8(%ebp),%eax
c0109076:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109078:	ff 4d e8             	decl   -0x18(%ebp)
c010907b:	89 f0                	mov    %esi,%eax
c010907d:	8d 70 01             	lea    0x1(%eax),%esi
c0109080:	0f b6 00             	movzbl (%eax),%eax
c0109083:	0f be d8             	movsbl %al,%ebx
c0109086:	85 db                	test   %ebx,%ebx
c0109088:	74 27                	je     c01090b1 <vprintfmt+0x255>
c010908a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010908e:	78 b4                	js     c0109044 <vprintfmt+0x1e8>
c0109090:	ff 4d e4             	decl   -0x1c(%ebp)
c0109093:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109097:	79 ab                	jns    c0109044 <vprintfmt+0x1e8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0109099:	eb 16                	jmp    c01090b1 <vprintfmt+0x255>
                putch(' ', putdat);
c010909b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010909e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01090a2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01090a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01090ac:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01090ae:	ff 4d e8             	decl   -0x18(%ebp)
c01090b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01090b5:	7f e4                	jg     c010909b <vprintfmt+0x23f>
                putch(' ', putdat);
            }
            break;
c01090b7:	e9 6c 01 00 00       	jmp    c0109228 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01090bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01090bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01090c3:	8d 45 14             	lea    0x14(%ebp),%eax
c01090c6:	89 04 24             	mov    %eax,(%esp)
c01090c9:	e8 18 fd ff ff       	call   c0108de6 <getint>
c01090ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01090d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01090d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01090da:	85 d2                	test   %edx,%edx
c01090dc:	79 26                	jns    c0109104 <vprintfmt+0x2a8>
                putch('-', putdat);
c01090de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01090e5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01090ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01090ef:	ff d0                	call   *%eax
                num = -(long long)num;
c01090f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01090f7:	f7 d8                	neg    %eax
c01090f9:	83 d2 00             	adc    $0x0,%edx
c01090fc:	f7 da                	neg    %edx
c01090fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109101:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0109104:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010910b:	e9 a8 00 00 00       	jmp    c01091b8 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109110:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109113:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109117:	8d 45 14             	lea    0x14(%ebp),%eax
c010911a:	89 04 24             	mov    %eax,(%esp)
c010911d:	e8 75 fc ff ff       	call   c0108d97 <getuint>
c0109122:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109125:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0109128:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010912f:	e9 84 00 00 00       	jmp    c01091b8 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109134:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109137:	89 44 24 04          	mov    %eax,0x4(%esp)
c010913b:	8d 45 14             	lea    0x14(%ebp),%eax
c010913e:	89 04 24             	mov    %eax,(%esp)
c0109141:	e8 51 fc ff ff       	call   c0108d97 <getuint>
c0109146:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109149:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010914c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0109153:	eb 63                	jmp    c01091b8 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0109155:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109158:	89 44 24 04          	mov    %eax,0x4(%esp)
c010915c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0109163:	8b 45 08             	mov    0x8(%ebp),%eax
c0109166:	ff d0                	call   *%eax
            putch('x', putdat);
c0109168:	8b 45 0c             	mov    0xc(%ebp),%eax
c010916b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010916f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0109176:	8b 45 08             	mov    0x8(%ebp),%eax
c0109179:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010917b:	8b 45 14             	mov    0x14(%ebp),%eax
c010917e:	8d 50 04             	lea    0x4(%eax),%edx
c0109181:	89 55 14             	mov    %edx,0x14(%ebp)
c0109184:	8b 00                	mov    (%eax),%eax
c0109186:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109190:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0109197:	eb 1f                	jmp    c01091b8 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0109199:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010919c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01091a0:	8d 45 14             	lea    0x14(%ebp),%eax
c01091a3:	89 04 24             	mov    %eax,(%esp)
c01091a6:	e8 ec fb ff ff       	call   c0108d97 <getuint>
c01091ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01091ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01091b1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01091b8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01091bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01091bf:	89 54 24 18          	mov    %edx,0x18(%esp)
c01091c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01091c6:	89 54 24 14          	mov    %edx,0x14(%esp)
c01091ca:	89 44 24 10          	mov    %eax,0x10(%esp)
c01091ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01091d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01091d4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01091d8:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01091dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01091e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01091e6:	89 04 24             	mov    %eax,(%esp)
c01091e9:	e8 a4 fa ff ff       	call   c0108c92 <printnum>
            break;
c01091ee:	eb 38                	jmp    c0109228 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01091f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01091f7:	89 1c 24             	mov    %ebx,(%esp)
c01091fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01091fd:	ff d0                	call   *%eax
            break;
c01091ff:	eb 27                	jmp    c0109228 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0109201:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109204:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109208:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010920f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109212:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0109214:	ff 4d 10             	decl   0x10(%ebp)
c0109217:	eb 03                	jmp    c010921c <vprintfmt+0x3c0>
c0109219:	ff 4d 10             	decl   0x10(%ebp)
c010921c:	8b 45 10             	mov    0x10(%ebp),%eax
c010921f:	48                   	dec    %eax
c0109220:	0f b6 00             	movzbl (%eax),%eax
c0109223:	3c 25                	cmp    $0x25,%al
c0109225:	75 f2                	jne    c0109219 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0109227:	90                   	nop
        }
    }
c0109228:	e9 37 fc ff ff       	jmp    c0108e64 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c010922d:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010922e:	83 c4 40             	add    $0x40,%esp
c0109231:	5b                   	pop    %ebx
c0109232:	5e                   	pop    %esi
c0109233:	5d                   	pop    %ebp
c0109234:	c3                   	ret    

c0109235 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0109235:	55                   	push   %ebp
c0109236:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109238:	8b 45 0c             	mov    0xc(%ebp),%eax
c010923b:	8b 40 08             	mov    0x8(%eax),%eax
c010923e:	8d 50 01             	lea    0x1(%eax),%edx
c0109241:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109244:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0109247:	8b 45 0c             	mov    0xc(%ebp),%eax
c010924a:	8b 10                	mov    (%eax),%edx
c010924c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010924f:	8b 40 04             	mov    0x4(%eax),%eax
c0109252:	39 c2                	cmp    %eax,%edx
c0109254:	73 12                	jae    c0109268 <sprintputch+0x33>
        *b->buf ++ = ch;
c0109256:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109259:	8b 00                	mov    (%eax),%eax
c010925b:	8d 48 01             	lea    0x1(%eax),%ecx
c010925e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109261:	89 0a                	mov    %ecx,(%edx)
c0109263:	8b 55 08             	mov    0x8(%ebp),%edx
c0109266:	88 10                	mov    %dl,(%eax)
    }
}
c0109268:	90                   	nop
c0109269:	5d                   	pop    %ebp
c010926a:	c3                   	ret    

c010926b <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010926b:	55                   	push   %ebp
c010926c:	89 e5                	mov    %esp,%ebp
c010926e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109271:	8d 45 14             	lea    0x14(%ebp),%eax
c0109274:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0109277:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010927a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010927e:	8b 45 10             	mov    0x10(%ebp),%eax
c0109281:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109285:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109288:	89 44 24 04          	mov    %eax,0x4(%esp)
c010928c:	8b 45 08             	mov    0x8(%ebp),%eax
c010928f:	89 04 24             	mov    %eax,(%esp)
c0109292:	e8 08 00 00 00       	call   c010929f <vsnprintf>
c0109297:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010929a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010929d:	c9                   	leave  
c010929e:	c3                   	ret    

c010929f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010929f:	55                   	push   %ebp
c01092a0:	89 e5                	mov    %esp,%ebp
c01092a2:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01092a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01092a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01092ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01092ae:	8d 50 ff             	lea    -0x1(%eax),%edx
c01092b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01092b4:	01 d0                	add    %edx,%eax
c01092b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01092b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01092c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01092c4:	74 0a                	je     c01092d0 <vsnprintf+0x31>
c01092c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01092c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01092cc:	39 c2                	cmp    %eax,%edx
c01092ce:	76 07                	jbe    c01092d7 <vsnprintf+0x38>
        return -E_INVAL;
c01092d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01092d5:	eb 2a                	jmp    c0109301 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01092d7:	8b 45 14             	mov    0x14(%ebp),%eax
c01092da:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01092de:	8b 45 10             	mov    0x10(%ebp),%eax
c01092e1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01092e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01092e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01092ec:	c7 04 24 35 92 10 c0 	movl   $0xc0109235,(%esp)
c01092f3:	e8 64 fb ff ff       	call   c0108e5c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01092f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01092fb:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01092fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109301:	c9                   	leave  
c0109302:	c3                   	ret    

c0109303 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0109303:	55                   	push   %ebp
c0109304:	89 e5                	mov    %esp,%ebp
c0109306:	57                   	push   %edi
c0109307:	56                   	push   %esi
c0109308:	53                   	push   %ebx
c0109309:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010930c:	a1 78 1a 12 c0       	mov    0xc0121a78,%eax
c0109311:	8b 15 7c 1a 12 c0    	mov    0xc0121a7c,%edx
c0109317:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010931d:	6b f0 05             	imul   $0x5,%eax,%esi
c0109320:	01 fe                	add    %edi,%esi
c0109322:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c0109327:	f7 e7                	mul    %edi
c0109329:	01 d6                	add    %edx,%esi
c010932b:	89 f2                	mov    %esi,%edx
c010932d:	83 c0 0b             	add    $0xb,%eax
c0109330:	83 d2 00             	adc    $0x0,%edx
c0109333:	89 c7                	mov    %eax,%edi
c0109335:	83 e7 ff             	and    $0xffffffff,%edi
c0109338:	89 f9                	mov    %edi,%ecx
c010933a:	0f b7 da             	movzwl %dx,%ebx
c010933d:	89 0d 78 1a 12 c0    	mov    %ecx,0xc0121a78
c0109343:	89 1d 7c 1a 12 c0    	mov    %ebx,0xc0121a7c
    unsigned long long result = (next >> 12);
c0109349:	a1 78 1a 12 c0       	mov    0xc0121a78,%eax
c010934e:	8b 15 7c 1a 12 c0    	mov    0xc0121a7c,%edx
c0109354:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109358:	c1 ea 0c             	shr    $0xc,%edx
c010935b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010935e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0109361:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0109368:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010936b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010936e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109371:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0109374:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109377:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010937a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010937e:	74 1c                	je     c010939c <rand+0x99>
c0109380:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109383:	ba 00 00 00 00       	mov    $0x0,%edx
c0109388:	f7 75 dc             	divl   -0x24(%ebp)
c010938b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010938e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109391:	ba 00 00 00 00       	mov    $0x0,%edx
c0109396:	f7 75 dc             	divl   -0x24(%ebp)
c0109399:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010939c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010939f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01093a2:	f7 75 dc             	divl   -0x24(%ebp)
c01093a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01093a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01093ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01093ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01093b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01093b4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01093b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c01093ba:	83 c4 24             	add    $0x24,%esp
c01093bd:	5b                   	pop    %ebx
c01093be:	5e                   	pop    %esi
c01093bf:	5f                   	pop    %edi
c01093c0:	5d                   	pop    %ebp
c01093c1:	c3                   	ret    

c01093c2 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c01093c2:	55                   	push   %ebp
c01093c3:	89 e5                	mov    %esp,%ebp
    next = seed;
c01093c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01093c8:	ba 00 00 00 00       	mov    $0x0,%edx
c01093cd:	a3 78 1a 12 c0       	mov    %eax,0xc0121a78
c01093d2:	89 15 7c 1a 12 c0    	mov    %edx,0xc0121a7c
}
c01093d8:	90                   	nop
c01093d9:	5d                   	pop    %ebp
c01093da:	c3                   	ret    


bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 30 80 11 00 	lgdtl  0x118030
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 80 11 c0       	mov    $0xc0118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 88 99 11 c0       	mov    $0xc0119988,%edx
c0100035:	b8 56 8a 11 c0       	mov    $0xc0118a56,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	83 ec 04             	sub    $0x4,%esp
c0100041:	50                   	push   %eax
c0100042:	6a 00                	push   $0x0
c0100044:	68 56 8a 11 c0       	push   $0xc0118a56
c0100049:	e8 95 5a 00 00       	call   c0105ae3 <memset>
c010004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100051:	e8 6a 15 00 00       	call   c01015c0 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100056:	c7 45 f4 80 62 10 c0 	movl   $0xc0106280,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010005d:	83 ec 08             	sub    $0x8,%esp
c0100060:	ff 75 f4             	pushl  -0xc(%ebp)
c0100063:	68 9c 62 10 c0       	push   $0xc010629c
c0100068:	e8 fe 01 00 00       	call   c010026b <cprintf>
c010006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100070:	e8 80 08 00 00       	call   c01008f5 <print_kerninfo>

    grade_backtrace();
c0100075:	e8 74 00 00 00       	call   c01000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007a:	e8 1f 31 00 00       	call   c010319e <pmm_init>

    pic_init();                 // init interrupt controller
c010007f:	e8 ae 16 00 00       	call   c0101732 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100084:	e8 0f 18 00 00       	call   c0101898 <idt_init>

    clock_init();               // init clock interrupt
c0100089:	e8 d9 0c 00 00       	call   c0100d67 <clock_init>
    intr_enable();              // enable irq interrupt
c010008e:	e8 dc 17 00 00       	call   c010186f <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    // lab1_switch_test();

    /* do nothing */
    while (1);
c0100093:	eb fe                	jmp    c0100093 <kern_init+0x69>

c0100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c0100095:	55                   	push   %ebp
c0100096:	89 e5                	mov    %esp,%ebp
c0100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c010009b:	83 ec 04             	sub    $0x4,%esp
c010009e:	6a 00                	push   $0x0
c01000a0:	6a 00                	push   $0x0
c01000a2:	6a 00                	push   $0x0
c01000a4:	e8 ac 0c 00 00       	call   c0100d55 <mon_backtrace>
c01000a9:	83 c4 10             	add    $0x10,%esp
}
c01000ac:	90                   	nop
c01000ad:	c9                   	leave  
c01000ae:	c3                   	ret    

c01000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000af:	55                   	push   %ebp
c01000b0:	89 e5                	mov    %esp,%ebp
c01000b2:	53                   	push   %ebx
c01000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01000c2:	51                   	push   %ecx
c01000c3:	52                   	push   %edx
c01000c4:	53                   	push   %ebx
c01000c5:	50                   	push   %eax
c01000c6:	e8 ca ff ff ff       	call   c0100095 <grade_backtrace2>
c01000cb:	83 c4 10             	add    $0x10,%esp
}
c01000ce:	90                   	nop
c01000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000d2:	c9                   	leave  
c01000d3:	c3                   	ret    

c01000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000d4:	55                   	push   %ebp
c01000d5:	89 e5                	mov    %esp,%ebp
c01000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000da:	83 ec 08             	sub    $0x8,%esp
c01000dd:	ff 75 10             	pushl  0x10(%ebp)
c01000e0:	ff 75 08             	pushl  0x8(%ebp)
c01000e3:	e8 c7 ff ff ff       	call   c01000af <grade_backtrace1>
c01000e8:	83 c4 10             	add    $0x10,%esp
}
c01000eb:	90                   	nop
c01000ec:	c9                   	leave  
c01000ed:	c3                   	ret    

c01000ee <grade_backtrace>:

void
grade_backtrace(void) {
c01000ee:	55                   	push   %ebp
c01000ef:	89 e5                	mov    %esp,%ebp
c01000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c01000f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01000f9:	83 ec 04             	sub    $0x4,%esp
c01000fc:	68 00 00 ff ff       	push   $0xffff0000
c0100101:	50                   	push   %eax
c0100102:	6a 00                	push   $0x0
c0100104:	e8 cb ff ff ff       	call   c01000d4 <grade_backtrace0>
c0100109:	83 c4 10             	add    $0x10,%esp
}
c010010c:	90                   	nop
c010010d:	c9                   	leave  
c010010e:	c3                   	ret    

c010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010010f:	55                   	push   %ebp
c0100110:	89 e5                	mov    %esp,%ebp
c0100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100125:	0f b7 c0             	movzwl %ax,%eax
c0100128:	83 e0 03             	and    $0x3,%eax
c010012b:	89 c2                	mov    %eax,%edx
c010012d:	a1 60 8a 11 c0       	mov    0xc0118a60,%eax
c0100132:	83 ec 04             	sub    $0x4,%esp
c0100135:	52                   	push   %edx
c0100136:	50                   	push   %eax
c0100137:	68 a1 62 10 c0       	push   $0xc01062a1
c010013c:	e8 2a 01 00 00       	call   c010026b <cprintf>
c0100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100148:	0f b7 d0             	movzwl %ax,%edx
c010014b:	a1 60 8a 11 c0       	mov    0xc0118a60,%eax
c0100150:	83 ec 04             	sub    $0x4,%esp
c0100153:	52                   	push   %edx
c0100154:	50                   	push   %eax
c0100155:	68 af 62 10 c0       	push   $0xc01062af
c010015a:	e8 0c 01 00 00       	call   c010026b <cprintf>
c010015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100166:	0f b7 d0             	movzwl %ax,%edx
c0100169:	a1 60 8a 11 c0       	mov    0xc0118a60,%eax
c010016e:	83 ec 04             	sub    $0x4,%esp
c0100171:	52                   	push   %edx
c0100172:	50                   	push   %eax
c0100173:	68 bd 62 10 c0       	push   $0xc01062bd
c0100178:	e8 ee 00 00 00       	call   c010026b <cprintf>
c010017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100184:	0f b7 d0             	movzwl %ax,%edx
c0100187:	a1 60 8a 11 c0       	mov    0xc0118a60,%eax
c010018c:	83 ec 04             	sub    $0x4,%esp
c010018f:	52                   	push   %edx
c0100190:	50                   	push   %eax
c0100191:	68 cb 62 10 c0       	push   $0xc01062cb
c0100196:	e8 d0 00 00 00       	call   c010026b <cprintf>
c010019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c010019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001a2:	0f b7 d0             	movzwl %ax,%edx
c01001a5:	a1 60 8a 11 c0       	mov    0xc0118a60,%eax
c01001aa:	83 ec 04             	sub    $0x4,%esp
c01001ad:	52                   	push   %edx
c01001ae:	50                   	push   %eax
c01001af:	68 d9 62 10 c0       	push   $0xc01062d9
c01001b4:	e8 b2 00 00 00       	call   c010026b <cprintf>
c01001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001bc:	a1 60 8a 11 c0       	mov    0xc0118a60,%eax
c01001c1:	83 c0 01             	add    $0x1,%eax
c01001c4:	a3 60 8a 11 c0       	mov    %eax,0xc0118a60
}
c01001c9:	90                   	nop
c01001ca:	c9                   	leave  
c01001cb:	c3                   	ret    

c01001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001cc:	55                   	push   %ebp
c01001cd:	89 e5                	mov    %esp,%ebp
    asm volatile (
c01001cf:	cd 78                	int    $0x78
        "int %0 \n"
        :
        : "i"(T_SWITCH_TOU)
    );
}
c01001d1:	90                   	nop
c01001d2:	5d                   	pop    %ebp
c01001d3:	c3                   	ret    

c01001d4 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001d4:	55                   	push   %ebp
c01001d5:	89 e5                	mov    %esp,%ebp
    asm volatile (
c01001d7:	cd 79                	int    $0x79
        "int %0 \n"
        :
        : "i"(T_SWITCH_TOK)
    );
}
c01001d9:	90                   	nop
c01001da:	5d                   	pop    %ebp
c01001db:	c3                   	ret    

c01001dc <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001dc:	55                   	push   %ebp
c01001dd:	89 e5                	mov    %esp,%ebp
c01001df:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001e2:	e8 28 ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001e7:	83 ec 0c             	sub    $0xc,%esp
c01001ea:	68 e8 62 10 c0       	push   $0xc01062e8
c01001ef:	e8 77 00 00 00       	call   c010026b <cprintf>
c01001f4:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001f7:	e8 d0 ff ff ff       	call   c01001cc <lab1_switch_to_user>
    lab1_print_cur_status();
c01001fc:	e8 0e ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100201:	83 ec 0c             	sub    $0xc,%esp
c0100204:	68 08 63 10 c0       	push   $0xc0106308
c0100209:	e8 5d 00 00 00       	call   c010026b <cprintf>
c010020e:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100211:	e8 be ff ff ff       	call   c01001d4 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100216:	e8 f4 fe ff ff       	call   c010010f <lab1_print_cur_status>
}
c010021b:	90                   	nop
c010021c:	c9                   	leave  
c010021d:	c3                   	ret    

c010021e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010021e:	55                   	push   %ebp
c010021f:	89 e5                	mov    %esp,%ebp
c0100221:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100224:	83 ec 0c             	sub    $0xc,%esp
c0100227:	ff 75 08             	pushl  0x8(%ebp)
c010022a:	e8 c2 13 00 00       	call   c01015f1 <cons_putc>
c010022f:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c0100232:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100235:	8b 00                	mov    (%eax),%eax
c0100237:	8d 50 01             	lea    0x1(%eax),%edx
c010023a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010023d:	89 10                	mov    %edx,(%eax)
}
c010023f:	90                   	nop
c0100240:	c9                   	leave  
c0100241:	c3                   	ret    

c0100242 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100242:	55                   	push   %ebp
c0100243:	89 e5                	mov    %esp,%ebp
c0100245:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100248:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010024f:	ff 75 0c             	pushl  0xc(%ebp)
c0100252:	ff 75 08             	pushl  0x8(%ebp)
c0100255:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100258:	50                   	push   %eax
c0100259:	68 1e 02 10 c0       	push   $0xc010021e
c010025e:	e8 b6 5b 00 00       	call   c0105e19 <vprintfmt>
c0100263:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100266:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100269:	c9                   	leave  
c010026a:	c3                   	ret    

c010026b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010026b:	55                   	push   %ebp
c010026c:	89 e5                	mov    %esp,%ebp
c010026e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100271:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100274:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100277:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010027a:	83 ec 08             	sub    $0x8,%esp
c010027d:	50                   	push   %eax
c010027e:	ff 75 08             	pushl  0x8(%ebp)
c0100281:	e8 bc ff ff ff       	call   c0100242 <vcprintf>
c0100286:	83 c4 10             	add    $0x10,%esp
c0100289:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010028c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010028f:	c9                   	leave  
c0100290:	c3                   	ret    

c0100291 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100291:	55                   	push   %ebp
c0100292:	89 e5                	mov    %esp,%ebp
c0100294:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100297:	83 ec 0c             	sub    $0xc,%esp
c010029a:	ff 75 08             	pushl  0x8(%ebp)
c010029d:	e8 4f 13 00 00       	call   c01015f1 <cons_putc>
c01002a2:	83 c4 10             	add    $0x10,%esp
}
c01002a5:	90                   	nop
c01002a6:	c9                   	leave  
c01002a7:	c3                   	ret    

c01002a8 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002a8:	55                   	push   %ebp
c01002a9:	89 e5                	mov    %esp,%ebp
c01002ab:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002b5:	eb 14                	jmp    c01002cb <cputs+0x23>
        cputch(c, &cnt);
c01002b7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002bb:	83 ec 08             	sub    $0x8,%esp
c01002be:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002c1:	52                   	push   %edx
c01002c2:	50                   	push   %eax
c01002c3:	e8 56 ff ff ff       	call   c010021e <cputch>
c01002c8:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01002cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ce:	8d 50 01             	lea    0x1(%eax),%edx
c01002d1:	89 55 08             	mov    %edx,0x8(%ebp)
c01002d4:	0f b6 00             	movzbl (%eax),%eax
c01002d7:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002da:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002de:	75 d7                	jne    c01002b7 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01002e0:	83 ec 08             	sub    $0x8,%esp
c01002e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01002e6:	50                   	push   %eax
c01002e7:	6a 0a                	push   $0xa
c01002e9:	e8 30 ff ff ff       	call   c010021e <cputch>
c01002ee:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01002f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01002f4:	c9                   	leave  
c01002f5:	c3                   	ret    

c01002f6 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01002f6:	55                   	push   %ebp
c01002f7:	89 e5                	mov    %esp,%ebp
c01002f9:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01002fc:	e8 39 13 00 00       	call   c010163a <cons_getc>
c0100301:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100304:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100308:	74 f2                	je     c01002fc <getchar+0x6>
        /* do nothing */;
    return c;
c010030a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010030d:	c9                   	leave  
c010030e:	c3                   	ret    

c010030f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010030f:	55                   	push   %ebp
c0100310:	89 e5                	mov    %esp,%ebp
c0100312:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100315:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100319:	74 13                	je     c010032e <readline+0x1f>
        cprintf("%s", prompt);
c010031b:	83 ec 08             	sub    $0x8,%esp
c010031e:	ff 75 08             	pushl  0x8(%ebp)
c0100321:	68 27 63 10 c0       	push   $0xc0106327
c0100326:	e8 40 ff ff ff       	call   c010026b <cprintf>
c010032b:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c010032e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100335:	e8 bc ff ff ff       	call   c01002f6 <getchar>
c010033a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010033d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100341:	79 0a                	jns    c010034d <readline+0x3e>
            return NULL;
c0100343:	b8 00 00 00 00       	mov    $0x0,%eax
c0100348:	e9 82 00 00 00       	jmp    c01003cf <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010034d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100351:	7e 2b                	jle    c010037e <readline+0x6f>
c0100353:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010035a:	7f 22                	jg     c010037e <readline+0x6f>
            cputchar(c);
c010035c:	83 ec 0c             	sub    $0xc,%esp
c010035f:	ff 75 f0             	pushl  -0x10(%ebp)
c0100362:	e8 2a ff ff ff       	call   c0100291 <cputchar>
c0100367:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c010036a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010036d:	8d 50 01             	lea    0x1(%eax),%edx
c0100370:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100373:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100376:	88 90 80 8a 11 c0    	mov    %dl,-0x3fee7580(%eax)
c010037c:	eb 4c                	jmp    c01003ca <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c010037e:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c0100382:	75 1a                	jne    c010039e <readline+0x8f>
c0100384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100388:	7e 14                	jle    c010039e <readline+0x8f>
            cputchar(c);
c010038a:	83 ec 0c             	sub    $0xc,%esp
c010038d:	ff 75 f0             	pushl  -0x10(%ebp)
c0100390:	e8 fc fe ff ff       	call   c0100291 <cputchar>
c0100395:	83 c4 10             	add    $0x10,%esp
            i --;
c0100398:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010039c:	eb 2c                	jmp    c01003ca <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c010039e:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003a2:	74 06                	je     c01003aa <readline+0x9b>
c01003a4:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003a8:	75 8b                	jne    c0100335 <readline+0x26>
            cputchar(c);
c01003aa:	83 ec 0c             	sub    $0xc,%esp
c01003ad:	ff 75 f0             	pushl  -0x10(%ebp)
c01003b0:	e8 dc fe ff ff       	call   c0100291 <cputchar>
c01003b5:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003bb:	05 80 8a 11 c0       	add    $0xc0118a80,%eax
c01003c0:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003c3:	b8 80 8a 11 c0       	mov    $0xc0118a80,%eax
c01003c8:	eb 05                	jmp    c01003cf <readline+0xc0>
        }
    }
c01003ca:	e9 66 ff ff ff       	jmp    c0100335 <readline+0x26>
}
c01003cf:	c9                   	leave  
c01003d0:	c3                   	ret    

c01003d1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003d1:	55                   	push   %ebp
c01003d2:	89 e5                	mov    %esp,%ebp
c01003d4:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003d7:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c01003dc:	85 c0                	test   %eax,%eax
c01003de:	75 4a                	jne    c010042a <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
c01003e0:	c7 05 80 8e 11 c0 01 	movl   $0x1,0xc0118e80
c01003e7:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003ea:	8d 45 14             	lea    0x14(%ebp),%eax
c01003ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c01003f0:	83 ec 04             	sub    $0x4,%esp
c01003f3:	ff 75 0c             	pushl  0xc(%ebp)
c01003f6:	ff 75 08             	pushl  0x8(%ebp)
c01003f9:	68 2a 63 10 c0       	push   $0xc010632a
c01003fe:	e8 68 fe ff ff       	call   c010026b <cprintf>
c0100403:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100406:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100409:	83 ec 08             	sub    $0x8,%esp
c010040c:	50                   	push   %eax
c010040d:	ff 75 10             	pushl  0x10(%ebp)
c0100410:	e8 2d fe ff ff       	call   c0100242 <vcprintf>
c0100415:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100418:	83 ec 0c             	sub    $0xc,%esp
c010041b:	68 46 63 10 c0       	push   $0xc0106346
c0100420:	e8 46 fe ff ff       	call   c010026b <cprintf>
c0100425:	83 c4 10             	add    $0x10,%esp
c0100428:	eb 01                	jmp    c010042b <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c010042a:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c010042b:	e8 46 14 00 00       	call   c0101876 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100430:	83 ec 0c             	sub    $0xc,%esp
c0100433:	6a 00                	push   $0x0
c0100435:	e8 41 08 00 00       	call   c0100c7b <kmonitor>
c010043a:	83 c4 10             	add    $0x10,%esp
    }
c010043d:	eb f1                	jmp    c0100430 <__panic+0x5f>

c010043f <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010043f:	55                   	push   %ebp
c0100440:	89 e5                	mov    %esp,%ebp
c0100442:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100445:	8d 45 14             	lea    0x14(%ebp),%eax
c0100448:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010044b:	83 ec 04             	sub    $0x4,%esp
c010044e:	ff 75 0c             	pushl  0xc(%ebp)
c0100451:	ff 75 08             	pushl  0x8(%ebp)
c0100454:	68 48 63 10 c0       	push   $0xc0106348
c0100459:	e8 0d fe ff ff       	call   c010026b <cprintf>
c010045e:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100461:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100464:	83 ec 08             	sub    $0x8,%esp
c0100467:	50                   	push   %eax
c0100468:	ff 75 10             	pushl  0x10(%ebp)
c010046b:	e8 d2 fd ff ff       	call   c0100242 <vcprintf>
c0100470:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100473:	83 ec 0c             	sub    $0xc,%esp
c0100476:	68 46 63 10 c0       	push   $0xc0106346
c010047b:	e8 eb fd ff ff       	call   c010026b <cprintf>
c0100480:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0100483:	90                   	nop
c0100484:	c9                   	leave  
c0100485:	c3                   	ret    

c0100486 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100486:	55                   	push   %ebp
c0100487:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100489:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
}
c010048e:	5d                   	pop    %ebp
c010048f:	c3                   	ret    

c0100490 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100490:	55                   	push   %ebp
c0100491:	89 e5                	mov    %esp,%ebp
c0100493:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100496:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100499:	8b 00                	mov    (%eax),%eax
c010049b:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049e:	8b 45 10             	mov    0x10(%ebp),%eax
c01004a1:	8b 00                	mov    (%eax),%eax
c01004a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004ad:	e9 d2 00 00 00       	jmp    c0100584 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004b8:	01 d0                	add    %edx,%eax
c01004ba:	89 c2                	mov    %eax,%edx
c01004bc:	c1 ea 1f             	shr    $0x1f,%edx
c01004bf:	01 d0                	add    %edx,%eax
c01004c1:	d1 f8                	sar    %eax
c01004c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004c9:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004cc:	eb 04                	jmp    c01004d2 <stab_binsearch+0x42>
            m --;
c01004ce:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004d8:	7c 1f                	jl     c01004f9 <stab_binsearch+0x69>
c01004da:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004dd:	89 d0                	mov    %edx,%eax
c01004df:	01 c0                	add    %eax,%eax
c01004e1:	01 d0                	add    %edx,%eax
c01004e3:	c1 e0 02             	shl    $0x2,%eax
c01004e6:	89 c2                	mov    %eax,%edx
c01004e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01004eb:	01 d0                	add    %edx,%eax
c01004ed:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01004f1:	0f b6 c0             	movzbl %al,%eax
c01004f4:	3b 45 14             	cmp    0x14(%ebp),%eax
c01004f7:	75 d5                	jne    c01004ce <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c01004f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004ff:	7d 0b                	jge    c010050c <stab_binsearch+0x7c>
            l = true_m + 1;
c0100501:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100504:	83 c0 01             	add    $0x1,%eax
c0100507:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010050a:	eb 78                	jmp    c0100584 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c010050c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100513:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100516:	89 d0                	mov    %edx,%eax
c0100518:	01 c0                	add    %eax,%eax
c010051a:	01 d0                	add    %edx,%eax
c010051c:	c1 e0 02             	shl    $0x2,%eax
c010051f:	89 c2                	mov    %eax,%edx
c0100521:	8b 45 08             	mov    0x8(%ebp),%eax
c0100524:	01 d0                	add    %edx,%eax
c0100526:	8b 40 08             	mov    0x8(%eax),%eax
c0100529:	3b 45 18             	cmp    0x18(%ebp),%eax
c010052c:	73 13                	jae    c0100541 <stab_binsearch+0xb1>
            *region_left = m;
c010052e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100531:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100534:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100536:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100539:	83 c0 01             	add    $0x1,%eax
c010053c:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010053f:	eb 43                	jmp    c0100584 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100541:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100544:	89 d0                	mov    %edx,%eax
c0100546:	01 c0                	add    %eax,%eax
c0100548:	01 d0                	add    %edx,%eax
c010054a:	c1 e0 02             	shl    $0x2,%eax
c010054d:	89 c2                	mov    %eax,%edx
c010054f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100552:	01 d0                	add    %edx,%eax
c0100554:	8b 40 08             	mov    0x8(%eax),%eax
c0100557:	3b 45 18             	cmp    0x18(%ebp),%eax
c010055a:	76 16                	jbe    c0100572 <stab_binsearch+0xe2>
            *region_right = m - 1;
c010055c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010055f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100562:	8b 45 10             	mov    0x10(%ebp),%eax
c0100565:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100567:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010056a:	83 e8 01             	sub    $0x1,%eax
c010056d:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100570:	eb 12                	jmp    c0100584 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c0100572:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100575:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100578:	89 10                	mov    %edx,(%eax)
            l = m;
c010057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057d:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c0100580:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c0100584:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100587:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010058a:	0f 8e 22 ff ff ff    	jle    c01004b2 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c0100590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100594:	75 0f                	jne    c01005a5 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c0100596:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100599:	8b 00                	mov    (%eax),%eax
c010059b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010059e:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a1:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005a3:	eb 3f                	jmp    c01005e4 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005a5:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a8:	8b 00                	mov    (%eax),%eax
c01005aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005ad:	eb 04                	jmp    c01005b3 <stab_binsearch+0x123>
c01005af:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b6:	8b 00                	mov    (%eax),%eax
c01005b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005bb:	7d 1f                	jge    c01005dc <stab_binsearch+0x14c>
c01005bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005c0:	89 d0                	mov    %edx,%eax
c01005c2:	01 c0                	add    %eax,%eax
c01005c4:	01 d0                	add    %edx,%eax
c01005c6:	c1 e0 02             	shl    $0x2,%eax
c01005c9:	89 c2                	mov    %eax,%edx
c01005cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ce:	01 d0                	add    %edx,%eax
c01005d0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005d4:	0f b6 c0             	movzbl %al,%eax
c01005d7:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005da:	75 d3                	jne    c01005af <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005df:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005e2:	89 10                	mov    %edx,(%eax)
    }
}
c01005e4:	90                   	nop
c01005e5:	c9                   	leave  
c01005e6:	c3                   	ret    

c01005e7 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005e7:	55                   	push   %ebp
c01005e8:	89 e5                	mov    %esp,%ebp
c01005ea:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c01005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f0:	c7 00 68 63 10 c0    	movl   $0xc0106368,(%eax)
    info->eip_line = 0;
c01005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100600:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100603:	c7 40 08 68 63 10 c0 	movl   $0xc0106368,0x8(%eax)
    info->eip_fn_namelen = 9;
c010060a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100614:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100617:	8b 55 08             	mov    0x8(%ebp),%edx
c010061a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010061d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100620:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100627:	c7 45 f4 b0 75 10 c0 	movl   $0xc01075b0,-0xc(%ebp)
    stab_end = __STAB_END__;
c010062e:	c7 45 f0 44 2f 11 c0 	movl   $0xc0112f44,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100635:	c7 45 ec 45 2f 11 c0 	movl   $0xc0112f45,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010063c:	c7 45 e8 94 5a 11 c0 	movl   $0xc0115a94,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100643:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100646:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100649:	76 0d                	jbe    c0100658 <debuginfo_eip+0x71>
c010064b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010064e:	83 e8 01             	sub    $0x1,%eax
c0100651:	0f b6 00             	movzbl (%eax),%eax
c0100654:	84 c0                	test   %al,%al
c0100656:	74 0a                	je     c0100662 <debuginfo_eip+0x7b>
        return -1;
c0100658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010065d:	e9 91 02 00 00       	jmp    c01008f3 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100662:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100669:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066f:	29 c2                	sub    %eax,%edx
c0100671:	89 d0                	mov    %edx,%eax
c0100673:	c1 f8 02             	sar    $0x2,%eax
c0100676:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c010067c:	83 e8 01             	sub    $0x1,%eax
c010067f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c0100682:	ff 75 08             	pushl  0x8(%ebp)
c0100685:	6a 64                	push   $0x64
c0100687:	8d 45 e0             	lea    -0x20(%ebp),%eax
c010068a:	50                   	push   %eax
c010068b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010068e:	50                   	push   %eax
c010068f:	ff 75 f4             	pushl  -0xc(%ebp)
c0100692:	e8 f9 fd ff ff       	call   c0100490 <stab_binsearch>
c0100697:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c010069a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010069d:	85 c0                	test   %eax,%eax
c010069f:	75 0a                	jne    c01006ab <debuginfo_eip+0xc4>
        return -1;
c01006a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006a6:	e9 48 02 00 00       	jmp    c01008f3 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006b7:	ff 75 08             	pushl  0x8(%ebp)
c01006ba:	6a 24                	push   $0x24
c01006bc:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006bf:	50                   	push   %eax
c01006c0:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006c3:	50                   	push   %eax
c01006c4:	ff 75 f4             	pushl  -0xc(%ebp)
c01006c7:	e8 c4 fd ff ff       	call   c0100490 <stab_binsearch>
c01006cc:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c01006cf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d5:	39 c2                	cmp    %eax,%edx
c01006d7:	7f 7c                	jg     c0100755 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c01006d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006dc:	89 c2                	mov    %eax,%edx
c01006de:	89 d0                	mov    %edx,%eax
c01006e0:	01 c0                	add    %eax,%eax
c01006e2:	01 d0                	add    %edx,%eax
c01006e4:	c1 e0 02             	shl    $0x2,%eax
c01006e7:	89 c2                	mov    %eax,%edx
c01006e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ec:	01 d0                	add    %edx,%eax
c01006ee:	8b 00                	mov    (%eax),%eax
c01006f0:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01006f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01006f6:	29 d1                	sub    %edx,%ecx
c01006f8:	89 ca                	mov    %ecx,%edx
c01006fa:	39 d0                	cmp    %edx,%eax
c01006fc:	73 22                	jae    c0100720 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c01006fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100701:	89 c2                	mov    %eax,%edx
c0100703:	89 d0                	mov    %edx,%eax
c0100705:	01 c0                	add    %eax,%eax
c0100707:	01 d0                	add    %edx,%eax
c0100709:	c1 e0 02             	shl    $0x2,%eax
c010070c:	89 c2                	mov    %eax,%edx
c010070e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100711:	01 d0                	add    %edx,%eax
c0100713:	8b 10                	mov    (%eax),%edx
c0100715:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100718:	01 c2                	add    %eax,%edx
c010071a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010071d:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100720:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100723:	89 c2                	mov    %eax,%edx
c0100725:	89 d0                	mov    %edx,%eax
c0100727:	01 c0                	add    %eax,%eax
c0100729:	01 d0                	add    %edx,%eax
c010072b:	c1 e0 02             	shl    $0x2,%eax
c010072e:	89 c2                	mov    %eax,%edx
c0100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100733:	01 d0                	add    %edx,%eax
c0100735:	8b 50 08             	mov    0x8(%eax),%edx
c0100738:	8b 45 0c             	mov    0xc(%ebp),%eax
c010073b:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010073e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100741:	8b 40 10             	mov    0x10(%eax),%eax
c0100744:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100747:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010074a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010074d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100750:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100753:	eb 15                	jmp    c010076a <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100755:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100758:	8b 55 08             	mov    0x8(%ebp),%edx
c010075b:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010075e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100761:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100764:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100767:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c010076a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010076d:	8b 40 08             	mov    0x8(%eax),%eax
c0100770:	83 ec 08             	sub    $0x8,%esp
c0100773:	6a 3a                	push   $0x3a
c0100775:	50                   	push   %eax
c0100776:	e8 dc 51 00 00       	call   c0105957 <strfind>
c010077b:	83 c4 10             	add    $0x10,%esp
c010077e:	89 c2                	mov    %eax,%edx
c0100780:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100783:	8b 40 08             	mov    0x8(%eax),%eax
c0100786:	29 c2                	sub    %eax,%edx
c0100788:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078b:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010078e:	83 ec 0c             	sub    $0xc,%esp
c0100791:	ff 75 08             	pushl  0x8(%ebp)
c0100794:	6a 44                	push   $0x44
c0100796:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100799:	50                   	push   %eax
c010079a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010079d:	50                   	push   %eax
c010079e:	ff 75 f4             	pushl  -0xc(%ebp)
c01007a1:	e8 ea fc ff ff       	call   c0100490 <stab_binsearch>
c01007a6:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007af:	39 c2                	cmp    %eax,%edx
c01007b1:	7f 24                	jg     c01007d7 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007b6:	89 c2                	mov    %eax,%edx
c01007b8:	89 d0                	mov    %edx,%eax
c01007ba:	01 c0                	add    %eax,%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	c1 e0 02             	shl    $0x2,%eax
c01007c1:	89 c2                	mov    %eax,%edx
c01007c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c6:	01 d0                	add    %edx,%eax
c01007c8:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c01007cc:	0f b7 d0             	movzwl %ax,%edx
c01007cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d2:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007d5:	eb 13                	jmp    c01007ea <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c01007d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007dc:	e9 12 01 00 00       	jmp    c01008f3 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c01007e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e4:	83 e8 01             	sub    $0x1,%eax
c01007e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	7c 56                	jl     c010084a <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010080d:	3c 84                	cmp    $0x84,%al
c010080f:	74 39                	je     c010084a <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100811:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100814:	89 c2                	mov    %eax,%edx
c0100816:	89 d0                	mov    %edx,%eax
c0100818:	01 c0                	add    %eax,%eax
c010081a:	01 d0                	add    %edx,%eax
c010081c:	c1 e0 02             	shl    $0x2,%eax
c010081f:	89 c2                	mov    %eax,%edx
c0100821:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100824:	01 d0                	add    %edx,%eax
c0100826:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010082a:	3c 64                	cmp    $0x64,%al
c010082c:	75 b3                	jne    c01007e1 <debuginfo_eip+0x1fa>
c010082e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100831:	89 c2                	mov    %eax,%edx
c0100833:	89 d0                	mov    %edx,%eax
c0100835:	01 c0                	add    %eax,%eax
c0100837:	01 d0                	add    %edx,%eax
c0100839:	c1 e0 02             	shl    $0x2,%eax
c010083c:	89 c2                	mov    %eax,%edx
c010083e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100841:	01 d0                	add    %edx,%eax
c0100843:	8b 40 08             	mov    0x8(%eax),%eax
c0100846:	85 c0                	test   %eax,%eax
c0100848:	74 97                	je     c01007e1 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c010084a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100850:	39 c2                	cmp    %eax,%edx
c0100852:	7c 46                	jl     c010089a <debuginfo_eip+0x2b3>
c0100854:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100857:	89 c2                	mov    %eax,%edx
c0100859:	89 d0                	mov    %edx,%eax
c010085b:	01 c0                	add    %eax,%eax
c010085d:	01 d0                	add    %edx,%eax
c010085f:	c1 e0 02             	shl    $0x2,%eax
c0100862:	89 c2                	mov    %eax,%edx
c0100864:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100867:	01 d0                	add    %edx,%eax
c0100869:	8b 00                	mov    (%eax),%eax
c010086b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010086e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100871:	29 d1                	sub    %edx,%ecx
c0100873:	89 ca                	mov    %ecx,%edx
c0100875:	39 d0                	cmp    %edx,%eax
c0100877:	73 21                	jae    c010089a <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100879:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010087c:	89 c2                	mov    %eax,%edx
c010087e:	89 d0                	mov    %edx,%eax
c0100880:	01 c0                	add    %eax,%eax
c0100882:	01 d0                	add    %edx,%eax
c0100884:	c1 e0 02             	shl    $0x2,%eax
c0100887:	89 c2                	mov    %eax,%edx
c0100889:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010088c:	01 d0                	add    %edx,%eax
c010088e:	8b 10                	mov    (%eax),%edx
c0100890:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100893:	01 c2                	add    %eax,%edx
c0100895:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100898:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010089a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010089d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008a0:	39 c2                	cmp    %eax,%edx
c01008a2:	7d 4a                	jge    c01008ee <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008a7:	83 c0 01             	add    $0x1,%eax
c01008aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008ad:	eb 18                	jmp    c01008c7 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008b2:	8b 40 14             	mov    0x14(%eax),%eax
c01008b5:	8d 50 01             	lea    0x1(%eax),%edx
c01008b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008bb:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c01008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008c1:	83 c0 01             	add    $0x1,%eax
c01008c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c01008cd:	39 c2                	cmp    %eax,%edx
c01008cf:	7d 1d                	jge    c01008ee <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d4:	89 c2                	mov    %eax,%edx
c01008d6:	89 d0                	mov    %edx,%eax
c01008d8:	01 c0                	add    %eax,%eax
c01008da:	01 d0                	add    %edx,%eax
c01008dc:	c1 e0 02             	shl    $0x2,%eax
c01008df:	89 c2                	mov    %eax,%edx
c01008e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e4:	01 d0                	add    %edx,%eax
c01008e6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008ea:	3c a0                	cmp    $0xa0,%al
c01008ec:	74 c1                	je     c01008af <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c01008ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01008f3:	c9                   	leave  
c01008f4:	c3                   	ret    

c01008f5 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c01008f5:	55                   	push   %ebp
c01008f6:	89 e5                	mov    %esp,%ebp
c01008f8:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c01008fb:	83 ec 0c             	sub    $0xc,%esp
c01008fe:	68 72 63 10 c0       	push   $0xc0106372
c0100903:	e8 63 f9 ff ff       	call   c010026b <cprintf>
c0100908:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010090b:	83 ec 08             	sub    $0x8,%esp
c010090e:	68 2a 00 10 c0       	push   $0xc010002a
c0100913:	68 8b 63 10 c0       	push   $0xc010638b
c0100918:	e8 4e f9 ff ff       	call   c010026b <cprintf>
c010091d:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100920:	83 ec 08             	sub    $0x8,%esp
c0100923:	68 7a 62 10 c0       	push   $0xc010627a
c0100928:	68 a3 63 10 c0       	push   $0xc01063a3
c010092d:	e8 39 f9 ff ff       	call   c010026b <cprintf>
c0100932:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100935:	83 ec 08             	sub    $0x8,%esp
c0100938:	68 56 8a 11 c0       	push   $0xc0118a56
c010093d:	68 bb 63 10 c0       	push   $0xc01063bb
c0100942:	e8 24 f9 ff ff       	call   c010026b <cprintf>
c0100947:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c010094a:	83 ec 08             	sub    $0x8,%esp
c010094d:	68 88 99 11 c0       	push   $0xc0119988
c0100952:	68 d3 63 10 c0       	push   $0xc01063d3
c0100957:	e8 0f f9 ff ff       	call   c010026b <cprintf>
c010095c:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010095f:	b8 88 99 11 c0       	mov    $0xc0119988,%eax
c0100964:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100969:	ba 2a 00 10 c0       	mov    $0xc010002a,%edx
c010096e:	29 d0                	sub    %edx,%eax
c0100970:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100976:	85 c0                	test   %eax,%eax
c0100978:	0f 48 c2             	cmovs  %edx,%eax
c010097b:	c1 f8 0a             	sar    $0xa,%eax
c010097e:	83 ec 08             	sub    $0x8,%esp
c0100981:	50                   	push   %eax
c0100982:	68 ec 63 10 c0       	push   $0xc01063ec
c0100987:	e8 df f8 ff ff       	call   c010026b <cprintf>
c010098c:	83 c4 10             	add    $0x10,%esp
}
c010098f:	90                   	nop
c0100990:	c9                   	leave  
c0100991:	c3                   	ret    

c0100992 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100992:	55                   	push   %ebp
c0100993:	89 e5                	mov    %esp,%ebp
c0100995:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010099b:	83 ec 08             	sub    $0x8,%esp
c010099e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009a1:	50                   	push   %eax
c01009a2:	ff 75 08             	pushl  0x8(%ebp)
c01009a5:	e8 3d fc ff ff       	call   c01005e7 <debuginfo_eip>
c01009aa:	83 c4 10             	add    $0x10,%esp
c01009ad:	85 c0                	test   %eax,%eax
c01009af:	74 15                	je     c01009c6 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009b1:	83 ec 08             	sub    $0x8,%esp
c01009b4:	ff 75 08             	pushl  0x8(%ebp)
c01009b7:	68 16 64 10 c0       	push   $0xc0106416
c01009bc:	e8 aa f8 ff ff       	call   c010026b <cprintf>
c01009c1:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009c4:	eb 65                	jmp    c0100a2b <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009cd:	eb 1c                	jmp    c01009eb <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c01009cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d5:	01 d0                	add    %edx,%eax
c01009d7:	0f b6 00             	movzbl (%eax),%eax
c01009da:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01009e3:	01 ca                	add    %ecx,%edx
c01009e5:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01009eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01009f1:	7f dc                	jg     c01009cf <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c01009f3:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c01009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fc:	01 d0                	add    %edx,%eax
c01009fe:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a01:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a04:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a07:	89 d1                	mov    %edx,%ecx
c0100a09:	29 c1                	sub    %eax,%ecx
c0100a0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a11:	83 ec 0c             	sub    $0xc,%esp
c0100a14:	51                   	push   %ecx
c0100a15:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a1b:	51                   	push   %ecx
c0100a1c:	52                   	push   %edx
c0100a1d:	50                   	push   %eax
c0100a1e:	68 32 64 10 c0       	push   $0xc0106432
c0100a23:	e8 43 f8 ff ff       	call   c010026b <cprintf>
c0100a28:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a2b:	90                   	nop
c0100a2c:	c9                   	leave  
c0100a2d:	c3                   	ret    

c0100a2e <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a2e:	55                   	push   %ebp
c0100a2f:	89 e5                	mov    %esp,%ebp
c0100a31:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a34:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a37:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a3d:	c9                   	leave  
c0100a3e:	c3                   	ret    

c0100a3f <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a3f:	55                   	push   %ebp
c0100a40:	89 e5                	mov    %esp,%ebp
c0100a42:	53                   	push   %ebx
c0100a43:	83 ec 24             	sub    $0x24,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a46:	89 e8                	mov    %ebp,%eax
c0100a48:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
c0100a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uintptr_t ebp = read_ebp();
c0100a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t eip = read_eip();
c0100a51:	e8 d8 ff ff ff       	call   c0100a2e <read_eip>
c0100a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32_t args[4] = {0};
c0100a59:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0100a60:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0100a67:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100a6e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while(ebp != 0){
c0100a75:	e9 85 00 00 00       	jmp    c0100aff <print_stackframe+0xc0>
        asm volatile("movl 8(%%ebp), %0":"=r"(args[0]));
c0100a7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        asm volatile("movl 12(%%ebp), %0":"=r"(args[1]));
c0100a80:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a83:	89 45 e0             	mov    %eax,-0x20(%ebp)
        asm volatile("movl 16(%%ebp), %0":"=r"(args[2]));
c0100a86:	8b 45 10             	mov    0x10(%ebp),%eax
c0100a89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        asm volatile("movl 20(%%ebp), %0":"=r"(args[3]));
c0100a8c:	8b 45 14             	mov    0x14(%ebp),%eax
c0100a8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        cprintf("ebp:0x%x eip:0x%x ", ebp, eip);
c0100a92:	83 ec 04             	sub    $0x4,%esp
c0100a95:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a98:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a9b:	68 44 64 10 c0       	push   $0xc0106444
c0100aa0:	e8 c6 f7 ff ff       	call   c010026b <cprintf>
c0100aa5:	83 c4 10             	add    $0x10,%esp
        cprintf("args:0x%x 0x%x ", args[0], args[1]);
c0100aa8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100aab:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100aae:	83 ec 04             	sub    $0x4,%esp
c0100ab1:	52                   	push   %edx
c0100ab2:	50                   	push   %eax
c0100ab3:	68 57 64 10 c0       	push   $0xc0106457
c0100ab8:	e8 ae f7 ff ff       	call   c010026b <cprintf>
c0100abd:	83 c4 10             	add    $0x10,%esp
        cprintf("0x%x 0x%x\n", args[2], args[3]);
c0100ac0:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0100ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100ac6:	83 ec 04             	sub    $0x4,%esp
c0100ac9:	52                   	push   %edx
c0100aca:	50                   	push   %eax
c0100acb:	68 67 64 10 c0       	push   $0xc0106467
c0100ad0:	e8 96 f7 ff ff       	call   c010026b <cprintf>
c0100ad5:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip-1);
c0100ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100adb:	83 e8 01             	sub    $0x1,%eax
c0100ade:	83 ec 0c             	sub    $0xc,%esp
c0100ae1:	50                   	push   %eax
c0100ae2:	e8 ab fe ff ff       	call   c0100992 <print_debuginfo>
c0100ae7:	83 c4 10             	add    $0x10,%esp

        // asm volatile("movl (%0), %1"::"=r"(ebp), "b"(ebp));
        asm volatile(
c0100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aed:	89 c3                	mov    %eax,%ebx
c0100aef:	8b 03                	mov    (%ebx),%eax
c0100af1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            "movl (%1), %0;"
            :"=a"(ebp)
            :"b"(ebp)
        );
        // asm volatile("movl 4(%0), %1"::"a"(ebp), "b"(eip));
        asm volatile(
c0100af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af7:	89 c3                	mov    %eax,%ebx
c0100af9:	8b 43 04             	mov    0x4(%ebx),%eax
c0100afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uintptr_t ebp = read_ebp();
    uintptr_t eip = read_eip();
    uint32_t args[4] = {0};
    while(ebp != 0){
c0100aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b03:	0f 85 71 ff ff ff    	jne    c0100a7a <print_stackframe+0x3b>
            "movl 4(%1), %0;"
            :"=a"(eip)
            :"b"(ebp)
        );
    } 
}
c0100b09:	90                   	nop
c0100b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100b0d:	c9                   	leave  
c0100b0e:	c3                   	ret    

c0100b0f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b0f:	55                   	push   %ebp
c0100b10:	89 e5                	mov    %esp,%ebp
c0100b12:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100b15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b1c:	eb 0c                	jmp    c0100b2a <parse+0x1b>
            *buf ++ = '\0';
c0100b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b21:	8d 50 01             	lea    0x1(%eax),%edx
c0100b24:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b27:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b2d:	0f b6 00             	movzbl (%eax),%eax
c0100b30:	84 c0                	test   %al,%al
c0100b32:	74 1e                	je     c0100b52 <parse+0x43>
c0100b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b37:	0f b6 00             	movzbl (%eax),%eax
c0100b3a:	0f be c0             	movsbl %al,%eax
c0100b3d:	83 ec 08             	sub    $0x8,%esp
c0100b40:	50                   	push   %eax
c0100b41:	68 f4 64 10 c0       	push   $0xc01064f4
c0100b46:	e8 d9 4d 00 00       	call   c0105924 <strchr>
c0100b4b:	83 c4 10             	add    $0x10,%esp
c0100b4e:	85 c0                	test   %eax,%eax
c0100b50:	75 cc                	jne    c0100b1e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b55:	0f b6 00             	movzbl (%eax),%eax
c0100b58:	84 c0                	test   %al,%al
c0100b5a:	74 69                	je     c0100bc5 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b5c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b60:	75 12                	jne    c0100b74 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b62:	83 ec 08             	sub    $0x8,%esp
c0100b65:	6a 10                	push   $0x10
c0100b67:	68 f9 64 10 c0       	push   $0xc01064f9
c0100b6c:	e8 fa f6 ff ff       	call   c010026b <cprintf>
c0100b71:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b77:	8d 50 01             	lea    0x1(%eax),%edx
c0100b7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b7d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b84:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b87:	01 c2                	add    %eax,%edx
c0100b89:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b8c:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b8e:	eb 04                	jmp    c0100b94 <parse+0x85>
            buf ++;
c0100b90:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b94:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b97:	0f b6 00             	movzbl (%eax),%eax
c0100b9a:	84 c0                	test   %al,%al
c0100b9c:	0f 84 7a ff ff ff    	je     c0100b1c <parse+0xd>
c0100ba2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba5:	0f b6 00             	movzbl (%eax),%eax
c0100ba8:	0f be c0             	movsbl %al,%eax
c0100bab:	83 ec 08             	sub    $0x8,%esp
c0100bae:	50                   	push   %eax
c0100baf:	68 f4 64 10 c0       	push   $0xc01064f4
c0100bb4:	e8 6b 4d 00 00       	call   c0105924 <strchr>
c0100bb9:	83 c4 10             	add    $0x10,%esp
c0100bbc:	85 c0                	test   %eax,%eax
c0100bbe:	74 d0                	je     c0100b90 <parse+0x81>
            buf ++;
        }
    }
c0100bc0:	e9 57 ff ff ff       	jmp    c0100b1c <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100bc5:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bc9:	c9                   	leave  
c0100bca:	c3                   	ret    

c0100bcb <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bcb:	55                   	push   %ebp
c0100bcc:	89 e5                	mov    %esp,%ebp
c0100bce:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bd1:	83 ec 08             	sub    $0x8,%esp
c0100bd4:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bd7:	50                   	push   %eax
c0100bd8:	ff 75 08             	pushl  0x8(%ebp)
c0100bdb:	e8 2f ff ff ff       	call   c0100b0f <parse>
c0100be0:	83 c4 10             	add    $0x10,%esp
c0100be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100be6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100bea:	75 0a                	jne    c0100bf6 <runcmd+0x2b>
        return 0;
c0100bec:	b8 00 00 00 00       	mov    $0x0,%eax
c0100bf1:	e9 83 00 00 00       	jmp    c0100c79 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100bfd:	eb 59                	jmp    c0100c58 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100bff:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c05:	89 d0                	mov    %edx,%eax
c0100c07:	01 c0                	add    %eax,%eax
c0100c09:	01 d0                	add    %edx,%eax
c0100c0b:	c1 e0 02             	shl    $0x2,%eax
c0100c0e:	05 40 80 11 c0       	add    $0xc0118040,%eax
c0100c13:	8b 00                	mov    (%eax),%eax
c0100c15:	83 ec 08             	sub    $0x8,%esp
c0100c18:	51                   	push   %ecx
c0100c19:	50                   	push   %eax
c0100c1a:	e8 65 4c 00 00       	call   c0105884 <strcmp>
c0100c1f:	83 c4 10             	add    $0x10,%esp
c0100c22:	85 c0                	test   %eax,%eax
c0100c24:	75 2e                	jne    c0100c54 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c29:	89 d0                	mov    %edx,%eax
c0100c2b:	01 c0                	add    %eax,%eax
c0100c2d:	01 d0                	add    %edx,%eax
c0100c2f:	c1 e0 02             	shl    $0x2,%eax
c0100c32:	05 48 80 11 c0       	add    $0xc0118048,%eax
c0100c37:	8b 10                	mov    (%eax),%edx
c0100c39:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c3c:	83 c0 04             	add    $0x4,%eax
c0100c3f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c42:	83 e9 01             	sub    $0x1,%ecx
c0100c45:	83 ec 04             	sub    $0x4,%esp
c0100c48:	ff 75 0c             	pushl  0xc(%ebp)
c0100c4b:	50                   	push   %eax
c0100c4c:	51                   	push   %ecx
c0100c4d:	ff d2                	call   *%edx
c0100c4f:	83 c4 10             	add    $0x10,%esp
c0100c52:	eb 25                	jmp    c0100c79 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c54:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c5b:	83 f8 02             	cmp    $0x2,%eax
c0100c5e:	76 9f                	jbe    c0100bff <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c60:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c63:	83 ec 08             	sub    $0x8,%esp
c0100c66:	50                   	push   %eax
c0100c67:	68 17 65 10 c0       	push   $0xc0106517
c0100c6c:	e8 fa f5 ff ff       	call   c010026b <cprintf>
c0100c71:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c79:	c9                   	leave  
c0100c7a:	c3                   	ret    

c0100c7b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c7b:	55                   	push   %ebp
c0100c7c:	89 e5                	mov    %esp,%ebp
c0100c7e:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c81:	83 ec 0c             	sub    $0xc,%esp
c0100c84:	68 30 65 10 c0       	push   $0xc0106530
c0100c89:	e8 dd f5 ff ff       	call   c010026b <cprintf>
c0100c8e:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c91:	83 ec 0c             	sub    $0xc,%esp
c0100c94:	68 58 65 10 c0       	push   $0xc0106558
c0100c99:	e8 cd f5 ff ff       	call   c010026b <cprintf>
c0100c9e:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100ca1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ca5:	74 0e                	je     c0100cb5 <kmonitor+0x3a>
        print_trapframe(tf);
c0100ca7:	83 ec 0c             	sub    $0xc,%esp
c0100caa:	ff 75 08             	pushl  0x8(%ebp)
c0100cad:	e8 a3 0d 00 00       	call   c0101a55 <print_trapframe>
c0100cb2:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cb5:	83 ec 0c             	sub    $0xc,%esp
c0100cb8:	68 7d 65 10 c0       	push   $0xc010657d
c0100cbd:	e8 4d f6 ff ff       	call   c010030f <readline>
c0100cc2:	83 c4 10             	add    $0x10,%esp
c0100cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100ccc:	74 e7                	je     c0100cb5 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100cce:	83 ec 08             	sub    $0x8,%esp
c0100cd1:	ff 75 08             	pushl  0x8(%ebp)
c0100cd4:	ff 75 f4             	pushl  -0xc(%ebp)
c0100cd7:	e8 ef fe ff ff       	call   c0100bcb <runcmd>
c0100cdc:	83 c4 10             	add    $0x10,%esp
c0100cdf:	85 c0                	test   %eax,%eax
c0100ce1:	78 02                	js     c0100ce5 <kmonitor+0x6a>
                break;
            }
        }
    }
c0100ce3:	eb d0                	jmp    c0100cb5 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100ce5:	90                   	nop
            }
        }
    }
}
c0100ce6:	90                   	nop
c0100ce7:	c9                   	leave  
c0100ce8:	c3                   	ret    

c0100ce9 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100ce9:	55                   	push   %ebp
c0100cea:	89 e5                	mov    %esp,%ebp
c0100cec:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100cf6:	eb 3c                	jmp    c0100d34 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100cf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cfb:	89 d0                	mov    %edx,%eax
c0100cfd:	01 c0                	add    %eax,%eax
c0100cff:	01 d0                	add    %edx,%eax
c0100d01:	c1 e0 02             	shl    $0x2,%eax
c0100d04:	05 44 80 11 c0       	add    $0xc0118044,%eax
c0100d09:	8b 08                	mov    (%eax),%ecx
c0100d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d0e:	89 d0                	mov    %edx,%eax
c0100d10:	01 c0                	add    %eax,%eax
c0100d12:	01 d0                	add    %edx,%eax
c0100d14:	c1 e0 02             	shl    $0x2,%eax
c0100d17:	05 40 80 11 c0       	add    $0xc0118040,%eax
c0100d1c:	8b 00                	mov    (%eax),%eax
c0100d1e:	83 ec 04             	sub    $0x4,%esp
c0100d21:	51                   	push   %ecx
c0100d22:	50                   	push   %eax
c0100d23:	68 81 65 10 c0       	push   $0xc0106581
c0100d28:	e8 3e f5 ff ff       	call   c010026b <cprintf>
c0100d2d:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d37:	83 f8 02             	cmp    $0x2,%eax
c0100d3a:	76 bc                	jbe    c0100cf8 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d41:	c9                   	leave  
c0100d42:	c3                   	ret    

c0100d43 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d43:	55                   	push   %ebp
c0100d44:	89 e5                	mov    %esp,%ebp
c0100d46:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d49:	e8 a7 fb ff ff       	call   c01008f5 <print_kerninfo>
    return 0;
c0100d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d53:	c9                   	leave  
c0100d54:	c3                   	ret    

c0100d55 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d55:	55                   	push   %ebp
c0100d56:	89 e5                	mov    %esp,%ebp
c0100d58:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d5b:	e8 df fc ff ff       	call   c0100a3f <print_stackframe>
    return 0;
c0100d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d65:	c9                   	leave  
c0100d66:	c3                   	ret    

c0100d67 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d67:	55                   	push   %ebp
c0100d68:	89 e5                	mov    %esp,%ebp
c0100d6a:	83 ec 18             	sub    $0x18,%esp
c0100d6d:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d73:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d77:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0100d7b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d7f:	ee                   	out    %al,(%dx)
c0100d80:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c0100d86:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c0100d8a:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0100d8e:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100d92:	ee                   	out    %al,(%dx)
c0100d93:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d99:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c0100d9d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100da1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100da5:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100da6:	c7 05 6c 99 11 c0 00 	movl   $0x0,0xc011996c
c0100dad:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100db0:	83 ec 0c             	sub    $0xc,%esp
c0100db3:	68 8a 65 10 c0       	push   $0xc010658a
c0100db8:	e8 ae f4 ff ff       	call   c010026b <cprintf>
c0100dbd:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100dc0:	83 ec 0c             	sub    $0xc,%esp
c0100dc3:	6a 00                	push   $0x0
c0100dc5:	e8 3b 09 00 00       	call   c0101705 <pic_enable>
c0100dca:	83 c4 10             	add    $0x10,%esp
}
c0100dcd:	90                   	nop
c0100dce:	c9                   	leave  
c0100dcf:	c3                   	ret    

c0100dd0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dd0:	55                   	push   %ebp
c0100dd1:	89 e5                	mov    %esp,%ebp
c0100dd3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dd6:	9c                   	pushf  
c0100dd7:	58                   	pop    %eax
c0100dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dde:	25 00 02 00 00       	and    $0x200,%eax
c0100de3:	85 c0                	test   %eax,%eax
c0100de5:	74 0c                	je     c0100df3 <__intr_save+0x23>
        intr_disable();
c0100de7:	e8 8a 0a 00 00       	call   c0101876 <intr_disable>
        return 1;
c0100dec:	b8 01 00 00 00       	mov    $0x1,%eax
c0100df1:	eb 05                	jmp    c0100df8 <__intr_save+0x28>
    }
    return 0;
c0100df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df8:	c9                   	leave  
c0100df9:	c3                   	ret    

c0100dfa <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100dfa:	55                   	push   %ebp
c0100dfb:	89 e5                	mov    %esp,%ebp
c0100dfd:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e04:	74 05                	je     c0100e0b <__intr_restore+0x11>
        intr_enable();
c0100e06:	e8 64 0a 00 00       	call   c010186f <intr_enable>
    }
}
c0100e0b:	90                   	nop
c0100e0c:	c9                   	leave  
c0100e0d:	c3                   	ret    

c0100e0e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e0e:	55                   	push   %ebp
c0100e0f:	89 e5                	mov    %esp,%ebp
c0100e11:	83 ec 10             	sub    $0x10,%esp
c0100e14:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e1a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e1e:	89 c2                	mov    %eax,%edx
c0100e20:	ec                   	in     (%dx),%al
c0100e21:	88 45 f4             	mov    %al,-0xc(%ebp)
c0100e24:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c0100e2a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0100e2e:	89 c2                	mov    %eax,%edx
c0100e30:	ec                   	in     (%dx),%al
c0100e31:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e34:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e3e:	89 c2                	mov    %eax,%edx
c0100e40:	ec                   	in     (%dx),%al
c0100e41:	88 45 f6             	mov    %al,-0xa(%ebp)
c0100e44:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c0100e4a:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0100e4e:	89 c2                	mov    %eax,%edx
c0100e50:	ec                   	in     (%dx),%al
c0100e51:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e54:	90                   	nop
c0100e55:	c9                   	leave  
c0100e56:	c3                   	ret    

c0100e57 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e57:	55                   	push   %ebp
c0100e58:	89 e5                	mov    %esp,%ebp
c0100e5a:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e5d:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e67:	0f b7 00             	movzwl (%eax),%eax
c0100e6a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e71:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e79:	0f b7 00             	movzwl (%eax),%eax
c0100e7c:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e80:	74 12                	je     c0100e94 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e82:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e89:	66 c7 05 a6 8e 11 c0 	movw   $0x3b4,0xc0118ea6
c0100e90:	b4 03 
c0100e92:	eb 13                	jmp    c0100ea7 <cga_init+0x50>
    } else {
        *cp = was;
c0100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e97:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e9b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e9e:	66 c7 05 a6 8e 11 c0 	movw   $0x3d4,0xc0118ea6
c0100ea5:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ea7:	0f b7 05 a6 8e 11 c0 	movzwl 0xc0118ea6,%eax
c0100eae:	0f b7 c0             	movzwl %ax,%eax
c0100eb1:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c0100eb5:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eb9:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0100ebd:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0100ec1:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ec2:	0f b7 05 a6 8e 11 c0 	movzwl 0xc0118ea6,%eax
c0100ec9:	83 c0 01             	add    $0x1,%eax
c0100ecc:	0f b7 c0             	movzwl %ax,%eax
c0100ecf:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ed3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ed7:	89 c2                	mov    %eax,%edx
c0100ed9:	ec                   	in     (%dx),%al
c0100eda:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0100edd:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0100ee1:	0f b6 c0             	movzbl %al,%eax
c0100ee4:	c1 e0 08             	shl    $0x8,%eax
c0100ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100eea:	0f b7 05 a6 8e 11 c0 	movzwl 0xc0118ea6,%eax
c0100ef1:	0f b7 c0             	movzwl %ax,%eax
c0100ef4:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c0100ef8:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100efc:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100f00:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100f04:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f05:	0f b7 05 a6 8e 11 c0 	movzwl 0xc0118ea6,%eax
c0100f0c:	83 c0 01             	add    $0x1,%eax
c0100f0f:	0f b7 c0             	movzwl %ax,%eax
c0100f12:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f16:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f1a:	89 c2                	mov    %eax,%edx
c0100f1c:	ec                   	in     (%dx),%al
c0100f1d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f20:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f24:	0f b6 c0             	movzbl %al,%eax
c0100f27:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f2d:	a3 a0 8e 11 c0       	mov    %eax,0xc0118ea0
    crt_pos = pos;
c0100f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f35:	66 a3 a4 8e 11 c0    	mov    %ax,0xc0118ea4
}
c0100f3b:	90                   	nop
c0100f3c:	c9                   	leave  
c0100f3d:	c3                   	ret    

c0100f3e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f3e:	55                   	push   %ebp
c0100f3f:	89 e5                	mov    %esp,%ebp
c0100f41:	83 ec 28             	sub    $0x28,%esp
c0100f44:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f4a:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f4e:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0100f52:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f56:	ee                   	out    %al,(%dx)
c0100f57:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c0100f5d:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c0100f61:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100f65:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100f69:	ee                   	out    %al,(%dx)
c0100f6a:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0100f70:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c0100f74:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0100f78:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f7c:	ee                   	out    %al,(%dx)
c0100f7d:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c0100f83:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100f87:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f8b:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100f8f:	ee                   	out    %al,(%dx)
c0100f90:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c0100f96:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c0100f9a:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0100f9e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa2:	ee                   	out    %al,(%dx)
c0100fa3:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c0100fa9:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c0100fad:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0100fb1:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0100fb5:	ee                   	out    %al,(%dx)
c0100fb6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fbc:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c0100fc0:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0100fc4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fc8:	ee                   	out    %al,(%dx)
c0100fc9:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fcf:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c0100fd3:	89 c2                	mov    %eax,%edx
c0100fd5:	ec                   	in     (%dx),%al
c0100fd6:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c0100fd9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fdd:	3c ff                	cmp    $0xff,%al
c0100fdf:	0f 95 c0             	setne  %al
c0100fe2:	0f b6 c0             	movzbl %al,%eax
c0100fe5:	a3 a8 8e 11 c0       	mov    %eax,0xc0118ea8
c0100fea:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff0:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100ff4:	89 c2                	mov    %eax,%edx
c0100ff6:	ec                   	in     (%dx),%al
c0100ff7:	88 45 e2             	mov    %al,-0x1e(%ebp)
c0100ffa:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c0101000:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
c0101004:	89 c2                	mov    %eax,%edx
c0101006:	ec                   	in     (%dx),%al
c0101007:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010100a:	a1 a8 8e 11 c0       	mov    0xc0118ea8,%eax
c010100f:	85 c0                	test   %eax,%eax
c0101011:	74 0d                	je     c0101020 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c0101013:	83 ec 0c             	sub    $0xc,%esp
c0101016:	6a 04                	push   $0x4
c0101018:	e8 e8 06 00 00       	call   c0101705 <pic_enable>
c010101d:	83 c4 10             	add    $0x10,%esp
    }
}
c0101020:	90                   	nop
c0101021:	c9                   	leave  
c0101022:	c3                   	ret    

c0101023 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101023:	55                   	push   %ebp
c0101024:	89 e5                	mov    %esp,%ebp
c0101026:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101029:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101030:	eb 09                	jmp    c010103b <lpt_putc_sub+0x18>
        delay();
c0101032:	e8 d7 fd ff ff       	call   c0100e0e <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101037:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010103b:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c0101041:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0101045:	89 c2                	mov    %eax,%edx
c0101047:	ec                   	in     (%dx),%al
c0101048:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c010104b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010104f:	84 c0                	test   %al,%al
c0101051:	78 09                	js     c010105c <lpt_putc_sub+0x39>
c0101053:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010105a:	7e d6                	jle    c0101032 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010105c:	8b 45 08             	mov    0x8(%ebp),%eax
c010105f:	0f b6 c0             	movzbl %al,%eax
c0101062:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c0101068:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010106b:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c010106f:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0101073:	ee                   	out    %al,(%dx)
c0101074:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c010107a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010107e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101082:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101086:	ee                   	out    %al,(%dx)
c0101087:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c010108d:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c0101091:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c0101095:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101099:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010109a:	90                   	nop
c010109b:	c9                   	leave  
c010109c:	c3                   	ret    

c010109d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010109d:	55                   	push   %ebp
c010109e:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01010a0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010a4:	74 0d                	je     c01010b3 <lpt_putc+0x16>
        lpt_putc_sub(c);
c01010a6:	ff 75 08             	pushl  0x8(%ebp)
c01010a9:	e8 75 ff ff ff       	call   c0101023 <lpt_putc_sub>
c01010ae:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010b1:	eb 1e                	jmp    c01010d1 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c01010b3:	6a 08                	push   $0x8
c01010b5:	e8 69 ff ff ff       	call   c0101023 <lpt_putc_sub>
c01010ba:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01010bd:	6a 20                	push   $0x20
c01010bf:	e8 5f ff ff ff       	call   c0101023 <lpt_putc_sub>
c01010c4:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010c7:	6a 08                	push   $0x8
c01010c9:	e8 55 ff ff ff       	call   c0101023 <lpt_putc_sub>
c01010ce:	83 c4 04             	add    $0x4,%esp
    }
}
c01010d1:	90                   	nop
c01010d2:	c9                   	leave  
c01010d3:	c3                   	ret    

c01010d4 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010d4:	55                   	push   %ebp
c01010d5:	89 e5                	mov    %esp,%ebp
c01010d7:	53                   	push   %ebx
c01010d8:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010db:	8b 45 08             	mov    0x8(%ebp),%eax
c01010de:	b0 00                	mov    $0x0,%al
c01010e0:	85 c0                	test   %eax,%eax
c01010e2:	75 07                	jne    c01010eb <cga_putc+0x17>
        c |= 0x0700;
c01010e4:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ee:	0f b6 c0             	movzbl %al,%eax
c01010f1:	83 f8 0a             	cmp    $0xa,%eax
c01010f4:	74 4e                	je     c0101144 <cga_putc+0x70>
c01010f6:	83 f8 0d             	cmp    $0xd,%eax
c01010f9:	74 59                	je     c0101154 <cga_putc+0x80>
c01010fb:	83 f8 08             	cmp    $0x8,%eax
c01010fe:	0f 85 8a 00 00 00    	jne    c010118e <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
c0101104:	0f b7 05 a4 8e 11 c0 	movzwl 0xc0118ea4,%eax
c010110b:	66 85 c0             	test   %ax,%ax
c010110e:	0f 84 a0 00 00 00    	je     c01011b4 <cga_putc+0xe0>
            crt_pos --;
c0101114:	0f b7 05 a4 8e 11 c0 	movzwl 0xc0118ea4,%eax
c010111b:	83 e8 01             	sub    $0x1,%eax
c010111e:	66 a3 a4 8e 11 c0    	mov    %ax,0xc0118ea4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101124:	a1 a0 8e 11 c0       	mov    0xc0118ea0,%eax
c0101129:	0f b7 15 a4 8e 11 c0 	movzwl 0xc0118ea4,%edx
c0101130:	0f b7 d2             	movzwl %dx,%edx
c0101133:	01 d2                	add    %edx,%edx
c0101135:	01 d0                	add    %edx,%eax
c0101137:	8b 55 08             	mov    0x8(%ebp),%edx
c010113a:	b2 00                	mov    $0x0,%dl
c010113c:	83 ca 20             	or     $0x20,%edx
c010113f:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c0101142:	eb 70                	jmp    c01011b4 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
c0101144:	0f b7 05 a4 8e 11 c0 	movzwl 0xc0118ea4,%eax
c010114b:	83 c0 50             	add    $0x50,%eax
c010114e:	66 a3 a4 8e 11 c0    	mov    %ax,0xc0118ea4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101154:	0f b7 1d a4 8e 11 c0 	movzwl 0xc0118ea4,%ebx
c010115b:	0f b7 0d a4 8e 11 c0 	movzwl 0xc0118ea4,%ecx
c0101162:	0f b7 c1             	movzwl %cx,%eax
c0101165:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010116b:	c1 e8 10             	shr    $0x10,%eax
c010116e:	89 c2                	mov    %eax,%edx
c0101170:	66 c1 ea 06          	shr    $0x6,%dx
c0101174:	89 d0                	mov    %edx,%eax
c0101176:	c1 e0 02             	shl    $0x2,%eax
c0101179:	01 d0                	add    %edx,%eax
c010117b:	c1 e0 04             	shl    $0x4,%eax
c010117e:	29 c1                	sub    %eax,%ecx
c0101180:	89 ca                	mov    %ecx,%edx
c0101182:	89 d8                	mov    %ebx,%eax
c0101184:	29 d0                	sub    %edx,%eax
c0101186:	66 a3 a4 8e 11 c0    	mov    %ax,0xc0118ea4
        break;
c010118c:	eb 27                	jmp    c01011b5 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010118e:	8b 0d a0 8e 11 c0    	mov    0xc0118ea0,%ecx
c0101194:	0f b7 05 a4 8e 11 c0 	movzwl 0xc0118ea4,%eax
c010119b:	8d 50 01             	lea    0x1(%eax),%edx
c010119e:	66 89 15 a4 8e 11 c0 	mov    %dx,0xc0118ea4
c01011a5:	0f b7 c0             	movzwl %ax,%eax
c01011a8:	01 c0                	add    %eax,%eax
c01011aa:	01 c8                	add    %ecx,%eax
c01011ac:	8b 55 08             	mov    0x8(%ebp),%edx
c01011af:	66 89 10             	mov    %dx,(%eax)
        break;
c01011b2:	eb 01                	jmp    c01011b5 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c01011b4:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011b5:	0f b7 05 a4 8e 11 c0 	movzwl 0xc0118ea4,%eax
c01011bc:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011c0:	76 59                	jbe    c010121b <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011c2:	a1 a0 8e 11 c0       	mov    0xc0118ea0,%eax
c01011c7:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011cd:	a1 a0 8e 11 c0       	mov    0xc0118ea0,%eax
c01011d2:	83 ec 04             	sub    $0x4,%esp
c01011d5:	68 00 0f 00 00       	push   $0xf00
c01011da:	52                   	push   %edx
c01011db:	50                   	push   %eax
c01011dc:	e8 42 49 00 00       	call   c0105b23 <memmove>
c01011e1:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011e4:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011eb:	eb 15                	jmp    c0101202 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
c01011ed:	a1 a0 8e 11 c0       	mov    0xc0118ea0,%eax
c01011f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01011f5:	01 d2                	add    %edx,%edx
c01011f7:	01 d0                	add    %edx,%eax
c01011f9:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101202:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101209:	7e e2                	jle    c01011ed <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010120b:	0f b7 05 a4 8e 11 c0 	movzwl 0xc0118ea4,%eax
c0101212:	83 e8 50             	sub    $0x50,%eax
c0101215:	66 a3 a4 8e 11 c0    	mov    %ax,0xc0118ea4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010121b:	0f b7 05 a6 8e 11 c0 	movzwl 0xc0118ea6,%eax
c0101222:	0f b7 c0             	movzwl %ax,%eax
c0101225:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101229:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c010122d:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c0101231:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101235:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101236:	0f b7 05 a4 8e 11 c0 	movzwl 0xc0118ea4,%eax
c010123d:	66 c1 e8 08          	shr    $0x8,%ax
c0101241:	0f b6 c0             	movzbl %al,%eax
c0101244:	0f b7 15 a6 8e 11 c0 	movzwl 0xc0118ea6,%edx
c010124b:	83 c2 01             	add    $0x1,%edx
c010124e:	0f b7 d2             	movzwl %dx,%edx
c0101251:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c0101255:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101258:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010125c:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101260:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101261:	0f b7 05 a6 8e 11 c0 	movzwl 0xc0118ea6,%eax
c0101268:	0f b7 c0             	movzwl %ax,%eax
c010126b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010126f:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c0101273:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101277:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010127b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010127c:	0f b7 05 a4 8e 11 c0 	movzwl 0xc0118ea4,%eax
c0101283:	0f b6 c0             	movzbl %al,%eax
c0101286:	0f b7 15 a6 8e 11 c0 	movzwl 0xc0118ea6,%edx
c010128d:	83 c2 01             	add    $0x1,%edx
c0101290:	0f b7 d2             	movzwl %dx,%edx
c0101293:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101297:	88 45 eb             	mov    %al,-0x15(%ebp)
c010129a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c010129e:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01012a2:	ee                   	out    %al,(%dx)
}
c01012a3:	90                   	nop
c01012a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01012a7:	c9                   	leave  
c01012a8:	c3                   	ret    

c01012a9 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012a9:	55                   	push   %ebp
c01012aa:	89 e5                	mov    %esp,%ebp
c01012ac:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012b6:	eb 09                	jmp    c01012c1 <serial_putc_sub+0x18>
        delay();
c01012b8:	e8 51 fb ff ff       	call   c0100e0e <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012c1:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012c7:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c01012cb:	89 c2                	mov    %eax,%edx
c01012cd:	ec                   	in     (%dx),%al
c01012ce:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c01012d1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01012d5:	0f b6 c0             	movzbl %al,%eax
c01012d8:	83 e0 20             	and    $0x20,%eax
c01012db:	85 c0                	test   %eax,%eax
c01012dd:	75 09                	jne    c01012e8 <serial_putc_sub+0x3f>
c01012df:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012e6:	7e d0                	jle    c01012b8 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01012eb:	0f b6 c0             	movzbl %al,%eax
c01012ee:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c01012f4:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012f7:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c01012fb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01012ff:	ee                   	out    %al,(%dx)
}
c0101300:	90                   	nop
c0101301:	c9                   	leave  
c0101302:	c3                   	ret    

c0101303 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101303:	55                   	push   %ebp
c0101304:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101306:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010130a:	74 0d                	je     c0101319 <serial_putc+0x16>
        serial_putc_sub(c);
c010130c:	ff 75 08             	pushl  0x8(%ebp)
c010130f:	e8 95 ff ff ff       	call   c01012a9 <serial_putc_sub>
c0101314:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101317:	eb 1e                	jmp    c0101337 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c0101319:	6a 08                	push   $0x8
c010131b:	e8 89 ff ff ff       	call   c01012a9 <serial_putc_sub>
c0101320:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101323:	6a 20                	push   $0x20
c0101325:	e8 7f ff ff ff       	call   c01012a9 <serial_putc_sub>
c010132a:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c010132d:	6a 08                	push   $0x8
c010132f:	e8 75 ff ff ff       	call   c01012a9 <serial_putc_sub>
c0101334:	83 c4 04             	add    $0x4,%esp
    }
}
c0101337:	90                   	nop
c0101338:	c9                   	leave  
c0101339:	c3                   	ret    

c010133a <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010133a:	55                   	push   %ebp
c010133b:	89 e5                	mov    %esp,%ebp
c010133d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101340:	eb 33                	jmp    c0101375 <cons_intr+0x3b>
        if (c != 0) {
c0101342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101346:	74 2d                	je     c0101375 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101348:	a1 c4 90 11 c0       	mov    0xc01190c4,%eax
c010134d:	8d 50 01             	lea    0x1(%eax),%edx
c0101350:	89 15 c4 90 11 c0    	mov    %edx,0xc01190c4
c0101356:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101359:	88 90 c0 8e 11 c0    	mov    %dl,-0x3fee7140(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010135f:	a1 c4 90 11 c0       	mov    0xc01190c4,%eax
c0101364:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101369:	75 0a                	jne    c0101375 <cons_intr+0x3b>
                cons.wpos = 0;
c010136b:	c7 05 c4 90 11 c0 00 	movl   $0x0,0xc01190c4
c0101372:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101375:	8b 45 08             	mov    0x8(%ebp),%eax
c0101378:	ff d0                	call   *%eax
c010137a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010137d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101381:	75 bf                	jne    c0101342 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101383:	90                   	nop
c0101384:	c9                   	leave  
c0101385:	c3                   	ret    

c0101386 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101386:	55                   	push   %ebp
c0101387:	89 e5                	mov    %esp,%ebp
c0101389:	83 ec 10             	sub    $0x10,%esp
c010138c:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101392:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0101396:	89 c2                	mov    %eax,%edx
c0101398:	ec                   	in     (%dx),%al
c0101399:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c010139c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013a0:	0f b6 c0             	movzbl %al,%eax
c01013a3:	83 e0 01             	and    $0x1,%eax
c01013a6:	85 c0                	test   %eax,%eax
c01013a8:	75 07                	jne    c01013b1 <serial_proc_data+0x2b>
        return -1;
c01013aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013af:	eb 2a                	jmp    c01013db <serial_proc_data+0x55>
c01013b1:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013bb:	89 c2                	mov    %eax,%edx
c01013bd:	ec                   	in     (%dx),%al
c01013be:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c01013c1:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013c5:	0f b6 c0             	movzbl %al,%eax
c01013c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013cb:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013cf:	75 07                	jne    c01013d8 <serial_proc_data+0x52>
        c = '\b';
c01013d1:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013db:	c9                   	leave  
c01013dc:	c3                   	ret    

c01013dd <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013dd:	55                   	push   %ebp
c01013de:	89 e5                	mov    %esp,%ebp
c01013e0:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01013e3:	a1 a8 8e 11 c0       	mov    0xc0118ea8,%eax
c01013e8:	85 c0                	test   %eax,%eax
c01013ea:	74 10                	je     c01013fc <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01013ec:	83 ec 0c             	sub    $0xc,%esp
c01013ef:	68 86 13 10 c0       	push   $0xc0101386
c01013f4:	e8 41 ff ff ff       	call   c010133a <cons_intr>
c01013f9:	83 c4 10             	add    $0x10,%esp
    }
}
c01013fc:	90                   	nop
c01013fd:	c9                   	leave  
c01013fe:	c3                   	ret    

c01013ff <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01013ff:	55                   	push   %ebp
c0101400:	89 e5                	mov    %esp,%ebp
c0101402:	83 ec 18             	sub    $0x18,%esp
c0101405:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010140b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010140f:	89 c2                	mov    %eax,%edx
c0101411:	ec                   	in     (%dx),%al
c0101412:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101415:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101419:	0f b6 c0             	movzbl %al,%eax
c010141c:	83 e0 01             	and    $0x1,%eax
c010141f:	85 c0                	test   %eax,%eax
c0101421:	75 0a                	jne    c010142d <kbd_proc_data+0x2e>
        return -1;
c0101423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101428:	e9 5d 01 00 00       	jmp    c010158a <kbd_proc_data+0x18b>
c010142d:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101433:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101437:	89 c2                	mov    %eax,%edx
c0101439:	ec                   	in     (%dx),%al
c010143a:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c010143d:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101441:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101444:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101448:	75 17                	jne    c0101461 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010144a:	a1 c8 90 11 c0       	mov    0xc01190c8,%eax
c010144f:	83 c8 40             	or     $0x40,%eax
c0101452:	a3 c8 90 11 c0       	mov    %eax,0xc01190c8
        return 0;
c0101457:	b8 00 00 00 00       	mov    $0x0,%eax
c010145c:	e9 29 01 00 00       	jmp    c010158a <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c0101461:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101465:	84 c0                	test   %al,%al
c0101467:	79 47                	jns    c01014b0 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101469:	a1 c8 90 11 c0       	mov    0xc01190c8,%eax
c010146e:	83 e0 40             	and    $0x40,%eax
c0101471:	85 c0                	test   %eax,%eax
c0101473:	75 09                	jne    c010147e <kbd_proc_data+0x7f>
c0101475:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101479:	83 e0 7f             	and    $0x7f,%eax
c010147c:	eb 04                	jmp    c0101482 <kbd_proc_data+0x83>
c010147e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101482:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101485:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101489:	0f b6 80 80 80 11 c0 	movzbl -0x3fee7f80(%eax),%eax
c0101490:	83 c8 40             	or     $0x40,%eax
c0101493:	0f b6 c0             	movzbl %al,%eax
c0101496:	f7 d0                	not    %eax
c0101498:	89 c2                	mov    %eax,%edx
c010149a:	a1 c8 90 11 c0       	mov    0xc01190c8,%eax
c010149f:	21 d0                	and    %edx,%eax
c01014a1:	a3 c8 90 11 c0       	mov    %eax,0xc01190c8
        return 0;
c01014a6:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ab:	e9 da 00 00 00       	jmp    c010158a <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c01014b0:	a1 c8 90 11 c0       	mov    0xc01190c8,%eax
c01014b5:	83 e0 40             	and    $0x40,%eax
c01014b8:	85 c0                	test   %eax,%eax
c01014ba:	74 11                	je     c01014cd <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014bc:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014c0:	a1 c8 90 11 c0       	mov    0xc01190c8,%eax
c01014c5:	83 e0 bf             	and    $0xffffffbf,%eax
c01014c8:	a3 c8 90 11 c0       	mov    %eax,0xc01190c8
    }

    shift |= shiftcode[data];
c01014cd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014d1:	0f b6 80 80 80 11 c0 	movzbl -0x3fee7f80(%eax),%eax
c01014d8:	0f b6 d0             	movzbl %al,%edx
c01014db:	a1 c8 90 11 c0       	mov    0xc01190c8,%eax
c01014e0:	09 d0                	or     %edx,%eax
c01014e2:	a3 c8 90 11 c0       	mov    %eax,0xc01190c8
    shift ^= togglecode[data];
c01014e7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014eb:	0f b6 80 80 81 11 c0 	movzbl -0x3fee7e80(%eax),%eax
c01014f2:	0f b6 d0             	movzbl %al,%edx
c01014f5:	a1 c8 90 11 c0       	mov    0xc01190c8,%eax
c01014fa:	31 d0                	xor    %edx,%eax
c01014fc:	a3 c8 90 11 c0       	mov    %eax,0xc01190c8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101501:	a1 c8 90 11 c0       	mov    0xc01190c8,%eax
c0101506:	83 e0 03             	and    $0x3,%eax
c0101509:	8b 14 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%edx
c0101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101514:	01 d0                	add    %edx,%eax
c0101516:	0f b6 00             	movzbl (%eax),%eax
c0101519:	0f b6 c0             	movzbl %al,%eax
c010151c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010151f:	a1 c8 90 11 c0       	mov    0xc01190c8,%eax
c0101524:	83 e0 08             	and    $0x8,%eax
c0101527:	85 c0                	test   %eax,%eax
c0101529:	74 22                	je     c010154d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010152b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010152f:	7e 0c                	jle    c010153d <kbd_proc_data+0x13e>
c0101531:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101535:	7f 06                	jg     c010153d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101537:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010153b:	eb 10                	jmp    c010154d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010153d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101541:	7e 0a                	jle    c010154d <kbd_proc_data+0x14e>
c0101543:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101547:	7f 04                	jg     c010154d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101549:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010154d:	a1 c8 90 11 c0       	mov    0xc01190c8,%eax
c0101552:	f7 d0                	not    %eax
c0101554:	83 e0 06             	and    $0x6,%eax
c0101557:	85 c0                	test   %eax,%eax
c0101559:	75 2c                	jne    c0101587 <kbd_proc_data+0x188>
c010155b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101562:	75 23                	jne    c0101587 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c0101564:	83 ec 0c             	sub    $0xc,%esp
c0101567:	68 a5 65 10 c0       	push   $0xc01065a5
c010156c:	e8 fa ec ff ff       	call   c010026b <cprintf>
c0101571:	83 c4 10             	add    $0x10,%esp
c0101574:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c010157a:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010157e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101582:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101586:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101587:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010158a:	c9                   	leave  
c010158b:	c3                   	ret    

c010158c <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010158c:	55                   	push   %ebp
c010158d:	89 e5                	mov    %esp,%ebp
c010158f:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c0101592:	83 ec 0c             	sub    $0xc,%esp
c0101595:	68 ff 13 10 c0       	push   $0xc01013ff
c010159a:	e8 9b fd ff ff       	call   c010133a <cons_intr>
c010159f:	83 c4 10             	add    $0x10,%esp
}
c01015a2:	90                   	nop
c01015a3:	c9                   	leave  
c01015a4:	c3                   	ret    

c01015a5 <kbd_init>:

static void
kbd_init(void) {
c01015a5:	55                   	push   %ebp
c01015a6:	89 e5                	mov    %esp,%ebp
c01015a8:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c01015ab:	e8 dc ff ff ff       	call   c010158c <kbd_intr>
    pic_enable(IRQ_KBD);
c01015b0:	83 ec 0c             	sub    $0xc,%esp
c01015b3:	6a 01                	push   $0x1
c01015b5:	e8 4b 01 00 00       	call   c0101705 <pic_enable>
c01015ba:	83 c4 10             	add    $0x10,%esp
}
c01015bd:	90                   	nop
c01015be:	c9                   	leave  
c01015bf:	c3                   	ret    

c01015c0 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015c0:	55                   	push   %ebp
c01015c1:	89 e5                	mov    %esp,%ebp
c01015c3:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015c6:	e8 8c f8 ff ff       	call   c0100e57 <cga_init>
    serial_init();
c01015cb:	e8 6e f9 ff ff       	call   c0100f3e <serial_init>
    kbd_init();
c01015d0:	e8 d0 ff ff ff       	call   c01015a5 <kbd_init>
    if (!serial_exists) {
c01015d5:	a1 a8 8e 11 c0       	mov    0xc0118ea8,%eax
c01015da:	85 c0                	test   %eax,%eax
c01015dc:	75 10                	jne    c01015ee <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01015de:	83 ec 0c             	sub    $0xc,%esp
c01015e1:	68 b1 65 10 c0       	push   $0xc01065b1
c01015e6:	e8 80 ec ff ff       	call   c010026b <cprintf>
c01015eb:	83 c4 10             	add    $0x10,%esp
    }
}
c01015ee:	90                   	nop
c01015ef:	c9                   	leave  
c01015f0:	c3                   	ret    

c01015f1 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015f1:	55                   	push   %ebp
c01015f2:	89 e5                	mov    %esp,%ebp
c01015f4:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015f7:	e8 d4 f7 ff ff       	call   c0100dd0 <__intr_save>
c01015fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01015ff:	83 ec 0c             	sub    $0xc,%esp
c0101602:	ff 75 08             	pushl  0x8(%ebp)
c0101605:	e8 93 fa ff ff       	call   c010109d <lpt_putc>
c010160a:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c010160d:	83 ec 0c             	sub    $0xc,%esp
c0101610:	ff 75 08             	pushl  0x8(%ebp)
c0101613:	e8 bc fa ff ff       	call   c01010d4 <cga_putc>
c0101618:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c010161b:	83 ec 0c             	sub    $0xc,%esp
c010161e:	ff 75 08             	pushl  0x8(%ebp)
c0101621:	e8 dd fc ff ff       	call   c0101303 <serial_putc>
c0101626:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0101629:	83 ec 0c             	sub    $0xc,%esp
c010162c:	ff 75 f4             	pushl  -0xc(%ebp)
c010162f:	e8 c6 f7 ff ff       	call   c0100dfa <__intr_restore>
c0101634:	83 c4 10             	add    $0x10,%esp
}
c0101637:	90                   	nop
c0101638:	c9                   	leave  
c0101639:	c3                   	ret    

c010163a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010163a:	55                   	push   %ebp
c010163b:	89 e5                	mov    %esp,%ebp
c010163d:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101640:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101647:	e8 84 f7 ff ff       	call   c0100dd0 <__intr_save>
c010164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010164f:	e8 89 fd ff ff       	call   c01013dd <serial_intr>
        kbd_intr();
c0101654:	e8 33 ff ff ff       	call   c010158c <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101659:	8b 15 c0 90 11 c0    	mov    0xc01190c0,%edx
c010165f:	a1 c4 90 11 c0       	mov    0xc01190c4,%eax
c0101664:	39 c2                	cmp    %eax,%edx
c0101666:	74 31                	je     c0101699 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101668:	a1 c0 90 11 c0       	mov    0xc01190c0,%eax
c010166d:	8d 50 01             	lea    0x1(%eax),%edx
c0101670:	89 15 c0 90 11 c0    	mov    %edx,0xc01190c0
c0101676:	0f b6 80 c0 8e 11 c0 	movzbl -0x3fee7140(%eax),%eax
c010167d:	0f b6 c0             	movzbl %al,%eax
c0101680:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101683:	a1 c0 90 11 c0       	mov    0xc01190c0,%eax
c0101688:	3d 00 02 00 00       	cmp    $0x200,%eax
c010168d:	75 0a                	jne    c0101699 <cons_getc+0x5f>
                cons.rpos = 0;
c010168f:	c7 05 c0 90 11 c0 00 	movl   $0x0,0xc01190c0
c0101696:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101699:	83 ec 0c             	sub    $0xc,%esp
c010169c:	ff 75 f0             	pushl  -0x10(%ebp)
c010169f:	e8 56 f7 ff ff       	call   c0100dfa <__intr_restore>
c01016a4:	83 c4 10             	add    $0x10,%esp
    return c;
c01016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016aa:	c9                   	leave  
c01016ab:	c3                   	ret    

c01016ac <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016ac:	55                   	push   %ebp
c01016ad:	89 e5                	mov    %esp,%ebp
c01016af:	83 ec 14             	sub    $0x14,%esp
c01016b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016b9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016bd:	66 a3 90 85 11 c0    	mov    %ax,0xc0118590
    if (did_init) {
c01016c3:	a1 cc 90 11 c0       	mov    0xc01190cc,%eax
c01016c8:	85 c0                	test   %eax,%eax
c01016ca:	74 36                	je     c0101702 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016cc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d0:	0f b6 c0             	movzbl %al,%eax
c01016d3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016d9:	88 45 fa             	mov    %al,-0x6(%ebp)
c01016dc:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c01016e0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016e4:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e9:	66 c1 e8 08          	shr    $0x8,%ax
c01016ed:	0f b6 c0             	movzbl %al,%eax
c01016f0:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c01016f6:	88 45 fb             	mov    %al,-0x5(%ebp)
c01016f9:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01016fd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101701:	ee                   	out    %al,(%dx)
    }
}
c0101702:	90                   	nop
c0101703:	c9                   	leave  
c0101704:	c3                   	ret    

c0101705 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101705:	55                   	push   %ebp
c0101706:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c0101708:	8b 45 08             	mov    0x8(%ebp),%eax
c010170b:	ba 01 00 00 00       	mov    $0x1,%edx
c0101710:	89 c1                	mov    %eax,%ecx
c0101712:	d3 e2                	shl    %cl,%edx
c0101714:	89 d0                	mov    %edx,%eax
c0101716:	f7 d0                	not    %eax
c0101718:	89 c2                	mov    %eax,%edx
c010171a:	0f b7 05 90 85 11 c0 	movzwl 0xc0118590,%eax
c0101721:	21 d0                	and    %edx,%eax
c0101723:	0f b7 c0             	movzwl %ax,%eax
c0101726:	50                   	push   %eax
c0101727:	e8 80 ff ff ff       	call   c01016ac <pic_setmask>
c010172c:	83 c4 04             	add    $0x4,%esp
}
c010172f:	90                   	nop
c0101730:	c9                   	leave  
c0101731:	c3                   	ret    

c0101732 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101732:	55                   	push   %ebp
c0101733:	89 e5                	mov    %esp,%ebp
c0101735:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
c0101738:	c7 05 cc 90 11 c0 01 	movl   $0x1,0xc01190cc
c010173f:	00 00 00 
c0101742:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101748:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c010174c:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c0101750:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101754:	ee                   	out    %al,(%dx)
c0101755:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c010175b:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c010175f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101763:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101767:	ee                   	out    %al,(%dx)
c0101768:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c010176e:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c0101772:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c0101776:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010177a:	ee                   	out    %al,(%dx)
c010177b:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c0101781:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c0101785:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101789:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c010178d:	ee                   	out    %al,(%dx)
c010178e:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c0101794:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c0101798:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c010179c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01017a0:	ee                   	out    %al,(%dx)
c01017a1:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c01017a7:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c01017ab:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01017af:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c01017b3:	ee                   	out    %al,(%dx)
c01017b4:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c01017ba:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c01017be:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01017c2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017c6:	ee                   	out    %al,(%dx)
c01017c7:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c01017cd:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c01017d1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017d5:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01017d9:	ee                   	out    %al,(%dx)
c01017da:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01017e0:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c01017e4:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c01017e8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017ec:	ee                   	out    %al,(%dx)
c01017ed:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c01017f3:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c01017f7:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01017fb:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01017ff:	ee                   	out    %al,(%dx)
c0101800:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c0101806:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c010180a:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c010180e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101812:	ee                   	out    %al,(%dx)
c0101813:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c0101819:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c010181d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101821:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101825:	ee                   	out    %al,(%dx)
c0101826:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c010182c:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c0101830:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c0101834:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101838:	ee                   	out    %al,(%dx)
c0101839:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c010183f:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c0101843:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101847:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c010184b:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010184c:	0f b7 05 90 85 11 c0 	movzwl 0xc0118590,%eax
c0101853:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101857:	74 13                	je     c010186c <pic_init+0x13a>
        pic_setmask(irq_mask);
c0101859:	0f b7 05 90 85 11 c0 	movzwl 0xc0118590,%eax
c0101860:	0f b7 c0             	movzwl %ax,%eax
c0101863:	50                   	push   %eax
c0101864:	e8 43 fe ff ff       	call   c01016ac <pic_setmask>
c0101869:	83 c4 04             	add    $0x4,%esp
    }
}
c010186c:	90                   	nop
c010186d:	c9                   	leave  
c010186e:	c3                   	ret    

c010186f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010186f:	55                   	push   %ebp
c0101870:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101872:	fb                   	sti    
    sti();
}
c0101873:	90                   	nop
c0101874:	5d                   	pop    %ebp
c0101875:	c3                   	ret    

c0101876 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101876:	55                   	push   %ebp
c0101877:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101879:	fa                   	cli    
    cli();
}
c010187a:	90                   	nop
c010187b:	5d                   	pop    %ebp
c010187c:	c3                   	ret    

c010187d <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010187d:	55                   	push   %ebp
c010187e:	89 e5                	mov    %esp,%ebp
c0101880:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101883:	83 ec 08             	sub    $0x8,%esp
c0101886:	6a 64                	push   $0x64
c0101888:	68 e0 65 10 c0       	push   $0xc01065e0
c010188d:	e8 d9 e9 ff ff       	call   c010026b <cprintf>
c0101892:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101895:	90                   	nop
c0101896:	c9                   	leave  
c0101897:	c3                   	ret    

c0101898 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101898:	55                   	push   %ebp
c0101899:	89 e5                	mov    %esp,%ebp
c010189b:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[]; //256  ISR's entry addrs
     
    uintptr_t ISR_addr = __vectors[0];
c010189e:	a1 20 86 11 c0       	mov    0xc0118620,%eax
c01018a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    for (int i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++, ISR_addr = __vectors[i]){
c01018a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c01018ad:	e9 c2 00 00 00       	jmp    c0101974 <idt_init+0xdc>
        SETGATE(idt[i], 0, GD_KTEXT, ISR_addr, DPL_USER);                   
c01018b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b5:	89 c2                	mov    %eax,%edx
c01018b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01018ba:	66 89 14 c5 e0 90 11 	mov    %dx,-0x3fee6f20(,%eax,8)
c01018c1:	c0 
c01018c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01018c5:	66 c7 04 c5 e2 90 11 	movw   $0x8,-0x3fee6f1e(,%eax,8)
c01018cc:	c0 08 00 
c01018cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01018d2:	0f b6 14 c5 e4 90 11 	movzbl -0x3fee6f1c(,%eax,8),%edx
c01018d9:	c0 
c01018da:	83 e2 e0             	and    $0xffffffe0,%edx
c01018dd:	88 14 c5 e4 90 11 c0 	mov    %dl,-0x3fee6f1c(,%eax,8)
c01018e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01018e7:	0f b6 14 c5 e4 90 11 	movzbl -0x3fee6f1c(,%eax,8),%edx
c01018ee:	c0 
c01018ef:	83 e2 1f             	and    $0x1f,%edx
c01018f2:	88 14 c5 e4 90 11 c0 	mov    %dl,-0x3fee6f1c(,%eax,8)
c01018f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01018fc:	0f b6 14 c5 e5 90 11 	movzbl -0x3fee6f1b(,%eax,8),%edx
c0101903:	c0 
c0101904:	83 e2 f0             	and    $0xfffffff0,%edx
c0101907:	83 ca 0e             	or     $0xe,%edx
c010190a:	88 14 c5 e5 90 11 c0 	mov    %dl,-0x3fee6f1b(,%eax,8)
c0101911:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101914:	0f b6 14 c5 e5 90 11 	movzbl -0x3fee6f1b(,%eax,8),%edx
c010191b:	c0 
c010191c:	83 e2 ef             	and    $0xffffffef,%edx
c010191f:	88 14 c5 e5 90 11 c0 	mov    %dl,-0x3fee6f1b(,%eax,8)
c0101926:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101929:	0f b6 14 c5 e5 90 11 	movzbl -0x3fee6f1b(,%eax,8),%edx
c0101930:	c0 
c0101931:	83 ca 60             	or     $0x60,%edx
c0101934:	88 14 c5 e5 90 11 c0 	mov    %dl,-0x3fee6f1b(,%eax,8)
c010193b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010193e:	0f b6 14 c5 e5 90 11 	movzbl -0x3fee6f1b(,%eax,8),%edx
c0101945:	c0 
c0101946:	83 ca 80             	or     $0xffffff80,%edx
c0101949:	88 14 c5 e5 90 11 c0 	mov    %dl,-0x3fee6f1b(,%eax,8)
c0101950:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101953:	c1 e8 10             	shr    $0x10,%eax
c0101956:	89 c2                	mov    %eax,%edx
c0101958:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010195b:	66 89 14 c5 e6 90 11 	mov    %dx,-0x3fee6f1a(,%eax,8)
c0101962:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[]; //256  ISR's entry addrs
     
    uintptr_t ISR_addr = __vectors[0];
    for (int i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++, ISR_addr = __vectors[i]){
c0101963:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101967:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010196a:	8b 04 85 20 86 11 c0 	mov    -0x3fee79e0(,%eax,4),%eax
c0101971:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0101974:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101977:	3d ff 00 00 00       	cmp    $0xff,%eax
c010197c:	0f 86 30 ff ff ff    	jbe    c01018b2 <idt_init+0x1a>
        SETGATE(idt[i], 0, GD_KTEXT, ISR_addr, DPL_USER);                   
    }
    /*开启陷阱门*/
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
c0101982:	a1 04 88 11 c0       	mov    0xc0118804,%eax
c0101987:	66 a3 a8 94 11 c0    	mov    %ax,0xc01194a8
c010198d:	66 c7 05 aa 94 11 c0 	movw   $0x8,0xc01194aa
c0101994:	08 00 
c0101996:	0f b6 05 ac 94 11 c0 	movzbl 0xc01194ac,%eax
c010199d:	83 e0 e0             	and    $0xffffffe0,%eax
c01019a0:	a2 ac 94 11 c0       	mov    %al,0xc01194ac
c01019a5:	0f b6 05 ac 94 11 c0 	movzbl 0xc01194ac,%eax
c01019ac:	83 e0 1f             	and    $0x1f,%eax
c01019af:	a2 ac 94 11 c0       	mov    %al,0xc01194ac
c01019b4:	0f b6 05 ad 94 11 c0 	movzbl 0xc01194ad,%eax
c01019bb:	83 c8 0f             	or     $0xf,%eax
c01019be:	a2 ad 94 11 c0       	mov    %al,0xc01194ad
c01019c3:	0f b6 05 ad 94 11 c0 	movzbl 0xc01194ad,%eax
c01019ca:	83 e0 ef             	and    $0xffffffef,%eax
c01019cd:	a2 ad 94 11 c0       	mov    %al,0xc01194ad
c01019d2:	0f b6 05 ad 94 11 c0 	movzbl 0xc01194ad,%eax
c01019d9:	83 c8 60             	or     $0x60,%eax
c01019dc:	a2 ad 94 11 c0       	mov    %al,0xc01194ad
c01019e1:	0f b6 05 ad 94 11 c0 	movzbl 0xc01194ad,%eax
c01019e8:	83 c8 80             	or     $0xffffff80,%eax
c01019eb:	a2 ad 94 11 c0       	mov    %al,0xc01194ad
c01019f0:	a1 04 88 11 c0       	mov    0xc0118804,%eax
c01019f5:	c1 e8 10             	shr    $0x10,%eax
c01019f8:	66 a3 ae 94 11 c0    	mov    %ax,0xc01194ae
c01019fe:	c7 45 f4 a0 85 11 c0 	movl   $0xc01185a0,-0xc(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a08:	0f 01 18             	lidtl  (%eax)

    lidt(&idt_pd); 
}
c0101a0b:	90                   	nop
c0101a0c:	c9                   	leave  
c0101a0d:	c3                   	ret    

c0101a0e <trapname>:

static const char *
trapname(int trapno) {
c0101a0e:	55                   	push   %ebp
c0101a0f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a14:	83 f8 13             	cmp    $0x13,%eax
c0101a17:	77 0c                	ja     c0101a25 <trapname+0x17>
        return excnames[trapno];
c0101a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a1c:	8b 04 85 40 69 10 c0 	mov    -0x3fef96c0(,%eax,4),%eax
c0101a23:	eb 18                	jmp    c0101a3d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a25:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a29:	7e 0d                	jle    c0101a38 <trapname+0x2a>
c0101a2b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a2f:	7f 07                	jg     c0101a38 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a31:	b8 ea 65 10 c0       	mov    $0xc01065ea,%eax
c0101a36:	eb 05                	jmp    c0101a3d <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a38:	b8 fd 65 10 c0       	mov    $0xc01065fd,%eax
}
c0101a3d:	5d                   	pop    %ebp
c0101a3e:	c3                   	ret    

c0101a3f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a3f:	55                   	push   %ebp
c0101a40:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a42:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a45:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a49:	66 83 f8 08          	cmp    $0x8,%ax
c0101a4d:	0f 94 c0             	sete   %al
c0101a50:	0f b6 c0             	movzbl %al,%eax
}
c0101a53:	5d                   	pop    %ebp
c0101a54:	c3                   	ret    

c0101a55 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a55:	55                   	push   %ebp
c0101a56:	89 e5                	mov    %esp,%ebp
c0101a58:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101a5b:	83 ec 08             	sub    $0x8,%esp
c0101a5e:	ff 75 08             	pushl  0x8(%ebp)
c0101a61:	68 3e 66 10 c0       	push   $0xc010663e
c0101a66:	e8 00 e8 ff ff       	call   c010026b <cprintf>
c0101a6b:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a71:	83 ec 0c             	sub    $0xc,%esp
c0101a74:	50                   	push   %eax
c0101a75:	e8 b8 01 00 00       	call   c0101c32 <print_regs>
c0101a7a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a80:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a84:	0f b7 c0             	movzwl %ax,%eax
c0101a87:	83 ec 08             	sub    $0x8,%esp
c0101a8a:	50                   	push   %eax
c0101a8b:	68 4f 66 10 c0       	push   $0xc010664f
c0101a90:	e8 d6 e7 ff ff       	call   c010026b <cprintf>
c0101a95:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a9f:	0f b7 c0             	movzwl %ax,%eax
c0101aa2:	83 ec 08             	sub    $0x8,%esp
c0101aa5:	50                   	push   %eax
c0101aa6:	68 62 66 10 c0       	push   $0xc0106662
c0101aab:	e8 bb e7 ff ff       	call   c010026b <cprintf>
c0101ab0:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab6:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aba:	0f b7 c0             	movzwl %ax,%eax
c0101abd:	83 ec 08             	sub    $0x8,%esp
c0101ac0:	50                   	push   %eax
c0101ac1:	68 75 66 10 c0       	push   $0xc0106675
c0101ac6:	e8 a0 e7 ff ff       	call   c010026b <cprintf>
c0101acb:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ace:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad1:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ad5:	0f b7 c0             	movzwl %ax,%eax
c0101ad8:	83 ec 08             	sub    $0x8,%esp
c0101adb:	50                   	push   %eax
c0101adc:	68 88 66 10 c0       	push   $0xc0106688
c0101ae1:	e8 85 e7 ff ff       	call   c010026b <cprintf>
c0101ae6:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aec:	8b 40 30             	mov    0x30(%eax),%eax
c0101aef:	83 ec 0c             	sub    $0xc,%esp
c0101af2:	50                   	push   %eax
c0101af3:	e8 16 ff ff ff       	call   c0101a0e <trapname>
c0101af8:	83 c4 10             	add    $0x10,%esp
c0101afb:	89 c2                	mov    %eax,%edx
c0101afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b00:	8b 40 30             	mov    0x30(%eax),%eax
c0101b03:	83 ec 04             	sub    $0x4,%esp
c0101b06:	52                   	push   %edx
c0101b07:	50                   	push   %eax
c0101b08:	68 9b 66 10 c0       	push   $0xc010669b
c0101b0d:	e8 59 e7 ff ff       	call   c010026b <cprintf>
c0101b12:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b15:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b18:	8b 40 34             	mov    0x34(%eax),%eax
c0101b1b:	83 ec 08             	sub    $0x8,%esp
c0101b1e:	50                   	push   %eax
c0101b1f:	68 ad 66 10 c0       	push   $0xc01066ad
c0101b24:	e8 42 e7 ff ff       	call   c010026b <cprintf>
c0101b29:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2f:	8b 40 38             	mov    0x38(%eax),%eax
c0101b32:	83 ec 08             	sub    $0x8,%esp
c0101b35:	50                   	push   %eax
c0101b36:	68 bc 66 10 c0       	push   $0xc01066bc
c0101b3b:	e8 2b e7 ff ff       	call   c010026b <cprintf>
c0101b40:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b46:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b4a:	0f b7 c0             	movzwl %ax,%eax
c0101b4d:	83 ec 08             	sub    $0x8,%esp
c0101b50:	50                   	push   %eax
c0101b51:	68 cb 66 10 c0       	push   $0xc01066cb
c0101b56:	e8 10 e7 ff ff       	call   c010026b <cprintf>
c0101b5b:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b61:	8b 40 40             	mov    0x40(%eax),%eax
c0101b64:	83 ec 08             	sub    $0x8,%esp
c0101b67:	50                   	push   %eax
c0101b68:	68 de 66 10 c0       	push   $0xc01066de
c0101b6d:	e8 f9 e6 ff ff       	call   c010026b <cprintf>
c0101b72:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b7c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b83:	eb 3f                	jmp    c0101bc4 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b88:	8b 50 40             	mov    0x40(%eax),%edx
c0101b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b8e:	21 d0                	and    %edx,%eax
c0101b90:	85 c0                	test   %eax,%eax
c0101b92:	74 29                	je     c0101bbd <print_trapframe+0x168>
c0101b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b97:	8b 04 85 c0 85 11 c0 	mov    -0x3fee7a40(,%eax,4),%eax
c0101b9e:	85 c0                	test   %eax,%eax
c0101ba0:	74 1b                	je     c0101bbd <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0101ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba5:	8b 04 85 c0 85 11 c0 	mov    -0x3fee7a40(,%eax,4),%eax
c0101bac:	83 ec 08             	sub    $0x8,%esp
c0101baf:	50                   	push   %eax
c0101bb0:	68 ed 66 10 c0       	push   $0xc01066ed
c0101bb5:	e8 b1 e6 ff ff       	call   c010026b <cprintf>
c0101bba:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bbd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bc1:	d1 65 f0             	shll   -0x10(%ebp)
c0101bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc7:	83 f8 17             	cmp    $0x17,%eax
c0101bca:	76 b9                	jbe    c0101b85 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bcf:	8b 40 40             	mov    0x40(%eax),%eax
c0101bd2:	25 00 30 00 00       	and    $0x3000,%eax
c0101bd7:	c1 e8 0c             	shr    $0xc,%eax
c0101bda:	83 ec 08             	sub    $0x8,%esp
c0101bdd:	50                   	push   %eax
c0101bde:	68 f1 66 10 c0       	push   $0xc01066f1
c0101be3:	e8 83 e6 ff ff       	call   c010026b <cprintf>
c0101be8:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101beb:	83 ec 0c             	sub    $0xc,%esp
c0101bee:	ff 75 08             	pushl  0x8(%ebp)
c0101bf1:	e8 49 fe ff ff       	call   c0101a3f <trap_in_kernel>
c0101bf6:	83 c4 10             	add    $0x10,%esp
c0101bf9:	85 c0                	test   %eax,%eax
c0101bfb:	75 32                	jne    c0101c2f <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c00:	8b 40 44             	mov    0x44(%eax),%eax
c0101c03:	83 ec 08             	sub    $0x8,%esp
c0101c06:	50                   	push   %eax
c0101c07:	68 fa 66 10 c0       	push   $0xc01066fa
c0101c0c:	e8 5a e6 ff ff       	call   c010026b <cprintf>
c0101c11:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c17:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c1b:	0f b7 c0             	movzwl %ax,%eax
c0101c1e:	83 ec 08             	sub    $0x8,%esp
c0101c21:	50                   	push   %eax
c0101c22:	68 09 67 10 c0       	push   $0xc0106709
c0101c27:	e8 3f e6 ff ff       	call   c010026b <cprintf>
c0101c2c:	83 c4 10             	add    $0x10,%esp
    }
}
c0101c2f:	90                   	nop
c0101c30:	c9                   	leave  
c0101c31:	c3                   	ret    

c0101c32 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c32:	55                   	push   %ebp
c0101c33:	89 e5                	mov    %esp,%ebp
c0101c35:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3b:	8b 00                	mov    (%eax),%eax
c0101c3d:	83 ec 08             	sub    $0x8,%esp
c0101c40:	50                   	push   %eax
c0101c41:	68 1c 67 10 c0       	push   $0xc010671c
c0101c46:	e8 20 e6 ff ff       	call   c010026b <cprintf>
c0101c4b:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c51:	8b 40 04             	mov    0x4(%eax),%eax
c0101c54:	83 ec 08             	sub    $0x8,%esp
c0101c57:	50                   	push   %eax
c0101c58:	68 2b 67 10 c0       	push   $0xc010672b
c0101c5d:	e8 09 e6 ff ff       	call   c010026b <cprintf>
c0101c62:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c65:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c68:	8b 40 08             	mov    0x8(%eax),%eax
c0101c6b:	83 ec 08             	sub    $0x8,%esp
c0101c6e:	50                   	push   %eax
c0101c6f:	68 3a 67 10 c0       	push   $0xc010673a
c0101c74:	e8 f2 e5 ff ff       	call   c010026b <cprintf>
c0101c79:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7f:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c82:	83 ec 08             	sub    $0x8,%esp
c0101c85:	50                   	push   %eax
c0101c86:	68 49 67 10 c0       	push   $0xc0106749
c0101c8b:	e8 db e5 ff ff       	call   c010026b <cprintf>
c0101c90:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c96:	8b 40 10             	mov    0x10(%eax),%eax
c0101c99:	83 ec 08             	sub    $0x8,%esp
c0101c9c:	50                   	push   %eax
c0101c9d:	68 58 67 10 c0       	push   $0xc0106758
c0101ca2:	e8 c4 e5 ff ff       	call   c010026b <cprintf>
c0101ca7:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101caa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cad:	8b 40 14             	mov    0x14(%eax),%eax
c0101cb0:	83 ec 08             	sub    $0x8,%esp
c0101cb3:	50                   	push   %eax
c0101cb4:	68 67 67 10 c0       	push   $0xc0106767
c0101cb9:	e8 ad e5 ff ff       	call   c010026b <cprintf>
c0101cbe:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc4:	8b 40 18             	mov    0x18(%eax),%eax
c0101cc7:	83 ec 08             	sub    $0x8,%esp
c0101cca:	50                   	push   %eax
c0101ccb:	68 76 67 10 c0       	push   $0xc0106776
c0101cd0:	e8 96 e5 ff ff       	call   c010026b <cprintf>
c0101cd5:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cdb:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cde:	83 ec 08             	sub    $0x8,%esp
c0101ce1:	50                   	push   %eax
c0101ce2:	68 85 67 10 c0       	push   $0xc0106785
c0101ce7:	e8 7f e5 ff ff       	call   c010026b <cprintf>
c0101cec:	83 c4 10             	add    $0x10,%esp
}
c0101cef:	90                   	nop
c0101cf0:	c9                   	leave  
c0101cf1:	c3                   	ret    

c0101cf2 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cf2:	55                   	push   %ebp
c0101cf3:	89 e5                	mov    %esp,%ebp
c0101cf5:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cfb:	8b 40 30             	mov    0x30(%eax),%eax
c0101cfe:	83 f8 2f             	cmp    $0x2f,%eax
c0101d01:	77 1d                	ja     c0101d20 <trap_dispatch+0x2e>
c0101d03:	83 f8 2e             	cmp    $0x2e,%eax
c0101d06:	0f 83 2d 01 00 00    	jae    c0101e39 <trap_dispatch+0x147>
c0101d0c:	83 f8 21             	cmp    $0x21,%eax
c0101d0f:	74 77                	je     c0101d88 <trap_dispatch+0x96>
c0101d11:	83 f8 24             	cmp    $0x24,%eax
c0101d14:	74 4b                	je     c0101d61 <trap_dispatch+0x6f>
c0101d16:	83 f8 20             	cmp    $0x20,%eax
c0101d19:	74 1c                	je     c0101d37 <trap_dispatch+0x45>
c0101d1b:	e9 e3 00 00 00       	jmp    c0101e03 <trap_dispatch+0x111>
c0101d20:	83 f8 78             	cmp    $0x78,%eax
c0101d23:	0f 84 86 00 00 00    	je     c0101daf <trap_dispatch+0xbd>
c0101d29:	83 f8 79             	cmp    $0x79,%eax
c0101d2c:	0f 84 b4 00 00 00    	je     c0101de6 <trap_dispatch+0xf4>
c0101d32:	e9 cc 00 00 00       	jmp    c0101e03 <trap_dispatch+0x111>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        if(++ticks == TICK_NUM){
c0101d37:	a1 6c 99 11 c0       	mov    0xc011996c,%eax
c0101d3c:	83 c0 01             	add    $0x1,%eax
c0101d3f:	a3 6c 99 11 c0       	mov    %eax,0xc011996c
c0101d44:	83 f8 64             	cmp    $0x64,%eax
c0101d47:	0f 85 ef 00 00 00    	jne    c0101e3c <trap_dispatch+0x14a>
            print_ticks();
c0101d4d:	e8 2b fb ff ff       	call   c010187d <print_ticks>
            ticks = 0;
c0101d52:	c7 05 6c 99 11 c0 00 	movl   $0x0,0xc011996c
c0101d59:	00 00 00 
        }

        break;
c0101d5c:	e9 db 00 00 00       	jmp    c0101e3c <trap_dispatch+0x14a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d61:	e8 d4 f8 ff ff       	call   c010163a <cons_getc>
c0101d66:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d69:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d6d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d71:	83 ec 04             	sub    $0x4,%esp
c0101d74:	52                   	push   %edx
c0101d75:	50                   	push   %eax
c0101d76:	68 94 67 10 c0       	push   $0xc0106794
c0101d7b:	e8 eb e4 ff ff       	call   c010026b <cprintf>
c0101d80:	83 c4 10             	add    $0x10,%esp
        break;
c0101d83:	e9 b5 00 00 00       	jmp    c0101e3d <trap_dispatch+0x14b>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d88:	e8 ad f8 ff ff       	call   c010163a <cons_getc>
c0101d8d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d90:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d94:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d98:	83 ec 04             	sub    $0x4,%esp
c0101d9b:	52                   	push   %edx
c0101d9c:	50                   	push   %eax
c0101d9d:	68 a6 67 10 c0       	push   $0xc01067a6
c0101da2:	e8 c4 e4 ff ff       	call   c010026b <cprintf>
c0101da7:	83 c4 10             	add    $0x10,%esp
        break;
c0101daa:	e9 8e 00 00 00       	jmp    c0101e3d <trap_dispatch+0x14b>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        tf->tf_eflags |= FL_IOPL_MASK;
c0101daf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101db2:	8b 40 40             	mov    0x40(%eax),%eax
c0101db5:	80 cc 30             	or     $0x30,%ah
c0101db8:	89 c2                	mov    %eax,%edx
c0101dba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dbd:	89 50 40             	mov    %edx,0x40(%eax)
        tf->tf_es = USER_DS;
c0101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dc3:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
        tf->tf_ds = USER_DS;
c0101dc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dcc:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
        tf->tf_ss = USER_DS;
c0101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dd5:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
        tf->tf_cs = USER_CS;
c0101ddb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dde:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
        break;
c0101de4:	eb 57                	jmp    c0101e3d <trap_dispatch+0x14b>
    case T_SWITCH_TOK:
        tf->tf_es = KERNEL_DS;
c0101de6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de9:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_ds = KERNEL_DS;
c0101def:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df2:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        // tf->tf_ss = 0x10;
        tf->tf_cs = KERNEL_CS;
c0101df8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dfb:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        break;
c0101e01:	eb 3a                	jmp    c0101e3d <trap_dispatch+0x14b>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e06:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e0a:	0f b7 c0             	movzwl %ax,%eax
c0101e0d:	83 e0 03             	and    $0x3,%eax
c0101e10:	85 c0                	test   %eax,%eax
c0101e12:	75 29                	jne    c0101e3d <trap_dispatch+0x14b>
            print_trapframe(tf);
c0101e14:	83 ec 0c             	sub    $0xc,%esp
c0101e17:	ff 75 08             	pushl  0x8(%ebp)
c0101e1a:	e8 36 fc ff ff       	call   c0101a55 <print_trapframe>
c0101e1f:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101e22:	83 ec 04             	sub    $0x4,%esp
c0101e25:	68 b5 67 10 c0       	push   $0xc01067b5
c0101e2a:	68 c6 00 00 00       	push   $0xc6
c0101e2f:	68 d1 67 10 c0       	push   $0xc01067d1
c0101e34:	e8 98 e5 ff ff       	call   c01003d1 <__panic>
        // panic("T_SWITCH_** ??\n");
        // break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e39:	90                   	nop
c0101e3a:	eb 01                	jmp    c0101e3d <trap_dispatch+0x14b>
        if(++ticks == TICK_NUM){
            print_ticks();
            ticks = 0;
        }

        break;
c0101e3c:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e3d:	90                   	nop
c0101e3e:	c9                   	leave  
c0101e3f:	c3                   	ret    

c0101e40 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e40:	55                   	push   %ebp
c0101e41:	89 e5                	mov    %esp,%ebp
c0101e43:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e46:	83 ec 0c             	sub    $0xc,%esp
c0101e49:	ff 75 08             	pushl  0x8(%ebp)
c0101e4c:	e8 a1 fe ff ff       	call   c0101cf2 <trap_dispatch>
c0101e51:	83 c4 10             	add    $0x10,%esp
}
c0101e54:	90                   	nop
c0101e55:	c9                   	leave  
c0101e56:	c3                   	ret    

c0101e57 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e57:	6a 00                	push   $0x0
  pushl $0
c0101e59:	6a 00                	push   $0x0
  jmp __alltraps
c0101e5b:	e9 67 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101e60 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e60:	6a 00                	push   $0x0
  pushl $1
c0101e62:	6a 01                	push   $0x1
  jmp __alltraps
c0101e64:	e9 5e 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101e69 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e69:	6a 00                	push   $0x0
  pushl $2
c0101e6b:	6a 02                	push   $0x2
  jmp __alltraps
c0101e6d:	e9 55 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101e72 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e72:	6a 00                	push   $0x0
  pushl $3
c0101e74:	6a 03                	push   $0x3
  jmp __alltraps
c0101e76:	e9 4c 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101e7b <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e7b:	6a 00                	push   $0x0
  pushl $4
c0101e7d:	6a 04                	push   $0x4
  jmp __alltraps
c0101e7f:	e9 43 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101e84 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e84:	6a 00                	push   $0x0
  pushl $5
c0101e86:	6a 05                	push   $0x5
  jmp __alltraps
c0101e88:	e9 3a 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101e8d <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e8d:	6a 00                	push   $0x0
  pushl $6
c0101e8f:	6a 06                	push   $0x6
  jmp __alltraps
c0101e91:	e9 31 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101e96 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e96:	6a 00                	push   $0x0
  pushl $7
c0101e98:	6a 07                	push   $0x7
  jmp __alltraps
c0101e9a:	e9 28 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101e9f <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e9f:	6a 08                	push   $0x8
  jmp __alltraps
c0101ea1:	e9 21 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101ea6 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101ea6:	6a 09                	push   $0x9
  jmp __alltraps
c0101ea8:	e9 1a 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101ead <vector10>:
.globl vector10
vector10:
  pushl $10
c0101ead:	6a 0a                	push   $0xa
  jmp __alltraps
c0101eaf:	e9 13 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101eb4 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101eb4:	6a 0b                	push   $0xb
  jmp __alltraps
c0101eb6:	e9 0c 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101ebb <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ebb:	6a 0c                	push   $0xc
  jmp __alltraps
c0101ebd:	e9 05 0a 00 00       	jmp    c01028c7 <__alltraps>

c0101ec2 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101ec2:	6a 0d                	push   $0xd
  jmp __alltraps
c0101ec4:	e9 fe 09 00 00       	jmp    c01028c7 <__alltraps>

c0101ec9 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ec9:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ecb:	e9 f7 09 00 00       	jmp    c01028c7 <__alltraps>

c0101ed0 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101ed0:	6a 00                	push   $0x0
  pushl $15
c0101ed2:	6a 0f                	push   $0xf
  jmp __alltraps
c0101ed4:	e9 ee 09 00 00       	jmp    c01028c7 <__alltraps>

c0101ed9 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101ed9:	6a 00                	push   $0x0
  pushl $16
c0101edb:	6a 10                	push   $0x10
  jmp __alltraps
c0101edd:	e9 e5 09 00 00       	jmp    c01028c7 <__alltraps>

c0101ee2 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ee2:	6a 11                	push   $0x11
  jmp __alltraps
c0101ee4:	e9 de 09 00 00       	jmp    c01028c7 <__alltraps>

c0101ee9 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101ee9:	6a 00                	push   $0x0
  pushl $18
c0101eeb:	6a 12                	push   $0x12
  jmp __alltraps
c0101eed:	e9 d5 09 00 00       	jmp    c01028c7 <__alltraps>

c0101ef2 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101ef2:	6a 00                	push   $0x0
  pushl $19
c0101ef4:	6a 13                	push   $0x13
  jmp __alltraps
c0101ef6:	e9 cc 09 00 00       	jmp    c01028c7 <__alltraps>

c0101efb <vector20>:
.globl vector20
vector20:
  pushl $0
c0101efb:	6a 00                	push   $0x0
  pushl $20
c0101efd:	6a 14                	push   $0x14
  jmp __alltraps
c0101eff:	e9 c3 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f04 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f04:	6a 00                	push   $0x0
  pushl $21
c0101f06:	6a 15                	push   $0x15
  jmp __alltraps
c0101f08:	e9 ba 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f0d <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f0d:	6a 00                	push   $0x0
  pushl $22
c0101f0f:	6a 16                	push   $0x16
  jmp __alltraps
c0101f11:	e9 b1 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f16 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f16:	6a 00                	push   $0x0
  pushl $23
c0101f18:	6a 17                	push   $0x17
  jmp __alltraps
c0101f1a:	e9 a8 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f1f <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f1f:	6a 00                	push   $0x0
  pushl $24
c0101f21:	6a 18                	push   $0x18
  jmp __alltraps
c0101f23:	e9 9f 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f28 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f28:	6a 00                	push   $0x0
  pushl $25
c0101f2a:	6a 19                	push   $0x19
  jmp __alltraps
c0101f2c:	e9 96 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f31 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f31:	6a 00                	push   $0x0
  pushl $26
c0101f33:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f35:	e9 8d 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f3a <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f3a:	6a 00                	push   $0x0
  pushl $27
c0101f3c:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f3e:	e9 84 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f43 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f43:	6a 00                	push   $0x0
  pushl $28
c0101f45:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f47:	e9 7b 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f4c <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f4c:	6a 00                	push   $0x0
  pushl $29
c0101f4e:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f50:	e9 72 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f55 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f55:	6a 00                	push   $0x0
  pushl $30
c0101f57:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f59:	e9 69 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f5e <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f5e:	6a 00                	push   $0x0
  pushl $31
c0101f60:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f62:	e9 60 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f67 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f67:	6a 00                	push   $0x0
  pushl $32
c0101f69:	6a 20                	push   $0x20
  jmp __alltraps
c0101f6b:	e9 57 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f70 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f70:	6a 00                	push   $0x0
  pushl $33
c0101f72:	6a 21                	push   $0x21
  jmp __alltraps
c0101f74:	e9 4e 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f79 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f79:	6a 00                	push   $0x0
  pushl $34
c0101f7b:	6a 22                	push   $0x22
  jmp __alltraps
c0101f7d:	e9 45 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f82 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f82:	6a 00                	push   $0x0
  pushl $35
c0101f84:	6a 23                	push   $0x23
  jmp __alltraps
c0101f86:	e9 3c 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f8b <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f8b:	6a 00                	push   $0x0
  pushl $36
c0101f8d:	6a 24                	push   $0x24
  jmp __alltraps
c0101f8f:	e9 33 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f94 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f94:	6a 00                	push   $0x0
  pushl $37
c0101f96:	6a 25                	push   $0x25
  jmp __alltraps
c0101f98:	e9 2a 09 00 00       	jmp    c01028c7 <__alltraps>

c0101f9d <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f9d:	6a 00                	push   $0x0
  pushl $38
c0101f9f:	6a 26                	push   $0x26
  jmp __alltraps
c0101fa1:	e9 21 09 00 00       	jmp    c01028c7 <__alltraps>

c0101fa6 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101fa6:	6a 00                	push   $0x0
  pushl $39
c0101fa8:	6a 27                	push   $0x27
  jmp __alltraps
c0101faa:	e9 18 09 00 00       	jmp    c01028c7 <__alltraps>

c0101faf <vector40>:
.globl vector40
vector40:
  pushl $0
c0101faf:	6a 00                	push   $0x0
  pushl $40
c0101fb1:	6a 28                	push   $0x28
  jmp __alltraps
c0101fb3:	e9 0f 09 00 00       	jmp    c01028c7 <__alltraps>

c0101fb8 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101fb8:	6a 00                	push   $0x0
  pushl $41
c0101fba:	6a 29                	push   $0x29
  jmp __alltraps
c0101fbc:	e9 06 09 00 00       	jmp    c01028c7 <__alltraps>

c0101fc1 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fc1:	6a 00                	push   $0x0
  pushl $42
c0101fc3:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101fc5:	e9 fd 08 00 00       	jmp    c01028c7 <__alltraps>

c0101fca <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fca:	6a 00                	push   $0x0
  pushl $43
c0101fcc:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fce:	e9 f4 08 00 00       	jmp    c01028c7 <__alltraps>

c0101fd3 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101fd3:	6a 00                	push   $0x0
  pushl $44
c0101fd5:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101fd7:	e9 eb 08 00 00       	jmp    c01028c7 <__alltraps>

c0101fdc <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fdc:	6a 00                	push   $0x0
  pushl $45
c0101fde:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fe0:	e9 e2 08 00 00       	jmp    c01028c7 <__alltraps>

c0101fe5 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101fe5:	6a 00                	push   $0x0
  pushl $46
c0101fe7:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101fe9:	e9 d9 08 00 00       	jmp    c01028c7 <__alltraps>

c0101fee <vector47>:
.globl vector47
vector47:
  pushl $0
c0101fee:	6a 00                	push   $0x0
  pushl $47
c0101ff0:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101ff2:	e9 d0 08 00 00       	jmp    c01028c7 <__alltraps>

c0101ff7 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101ff7:	6a 00                	push   $0x0
  pushl $48
c0101ff9:	6a 30                	push   $0x30
  jmp __alltraps
c0101ffb:	e9 c7 08 00 00       	jmp    c01028c7 <__alltraps>

c0102000 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102000:	6a 00                	push   $0x0
  pushl $49
c0102002:	6a 31                	push   $0x31
  jmp __alltraps
c0102004:	e9 be 08 00 00       	jmp    c01028c7 <__alltraps>

c0102009 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102009:	6a 00                	push   $0x0
  pushl $50
c010200b:	6a 32                	push   $0x32
  jmp __alltraps
c010200d:	e9 b5 08 00 00       	jmp    c01028c7 <__alltraps>

c0102012 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102012:	6a 00                	push   $0x0
  pushl $51
c0102014:	6a 33                	push   $0x33
  jmp __alltraps
c0102016:	e9 ac 08 00 00       	jmp    c01028c7 <__alltraps>

c010201b <vector52>:
.globl vector52
vector52:
  pushl $0
c010201b:	6a 00                	push   $0x0
  pushl $52
c010201d:	6a 34                	push   $0x34
  jmp __alltraps
c010201f:	e9 a3 08 00 00       	jmp    c01028c7 <__alltraps>

c0102024 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102024:	6a 00                	push   $0x0
  pushl $53
c0102026:	6a 35                	push   $0x35
  jmp __alltraps
c0102028:	e9 9a 08 00 00       	jmp    c01028c7 <__alltraps>

c010202d <vector54>:
.globl vector54
vector54:
  pushl $0
c010202d:	6a 00                	push   $0x0
  pushl $54
c010202f:	6a 36                	push   $0x36
  jmp __alltraps
c0102031:	e9 91 08 00 00       	jmp    c01028c7 <__alltraps>

c0102036 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102036:	6a 00                	push   $0x0
  pushl $55
c0102038:	6a 37                	push   $0x37
  jmp __alltraps
c010203a:	e9 88 08 00 00       	jmp    c01028c7 <__alltraps>

c010203f <vector56>:
.globl vector56
vector56:
  pushl $0
c010203f:	6a 00                	push   $0x0
  pushl $56
c0102041:	6a 38                	push   $0x38
  jmp __alltraps
c0102043:	e9 7f 08 00 00       	jmp    c01028c7 <__alltraps>

c0102048 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102048:	6a 00                	push   $0x0
  pushl $57
c010204a:	6a 39                	push   $0x39
  jmp __alltraps
c010204c:	e9 76 08 00 00       	jmp    c01028c7 <__alltraps>

c0102051 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102051:	6a 00                	push   $0x0
  pushl $58
c0102053:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102055:	e9 6d 08 00 00       	jmp    c01028c7 <__alltraps>

c010205a <vector59>:
.globl vector59
vector59:
  pushl $0
c010205a:	6a 00                	push   $0x0
  pushl $59
c010205c:	6a 3b                	push   $0x3b
  jmp __alltraps
c010205e:	e9 64 08 00 00       	jmp    c01028c7 <__alltraps>

c0102063 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102063:	6a 00                	push   $0x0
  pushl $60
c0102065:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102067:	e9 5b 08 00 00       	jmp    c01028c7 <__alltraps>

c010206c <vector61>:
.globl vector61
vector61:
  pushl $0
c010206c:	6a 00                	push   $0x0
  pushl $61
c010206e:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102070:	e9 52 08 00 00       	jmp    c01028c7 <__alltraps>

c0102075 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102075:	6a 00                	push   $0x0
  pushl $62
c0102077:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102079:	e9 49 08 00 00       	jmp    c01028c7 <__alltraps>

c010207e <vector63>:
.globl vector63
vector63:
  pushl $0
c010207e:	6a 00                	push   $0x0
  pushl $63
c0102080:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102082:	e9 40 08 00 00       	jmp    c01028c7 <__alltraps>

c0102087 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102087:	6a 00                	push   $0x0
  pushl $64
c0102089:	6a 40                	push   $0x40
  jmp __alltraps
c010208b:	e9 37 08 00 00       	jmp    c01028c7 <__alltraps>

c0102090 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102090:	6a 00                	push   $0x0
  pushl $65
c0102092:	6a 41                	push   $0x41
  jmp __alltraps
c0102094:	e9 2e 08 00 00       	jmp    c01028c7 <__alltraps>

c0102099 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102099:	6a 00                	push   $0x0
  pushl $66
c010209b:	6a 42                	push   $0x42
  jmp __alltraps
c010209d:	e9 25 08 00 00       	jmp    c01028c7 <__alltraps>

c01020a2 <vector67>:
.globl vector67
vector67:
  pushl $0
c01020a2:	6a 00                	push   $0x0
  pushl $67
c01020a4:	6a 43                	push   $0x43
  jmp __alltraps
c01020a6:	e9 1c 08 00 00       	jmp    c01028c7 <__alltraps>

c01020ab <vector68>:
.globl vector68
vector68:
  pushl $0
c01020ab:	6a 00                	push   $0x0
  pushl $68
c01020ad:	6a 44                	push   $0x44
  jmp __alltraps
c01020af:	e9 13 08 00 00       	jmp    c01028c7 <__alltraps>

c01020b4 <vector69>:
.globl vector69
vector69:
  pushl $0
c01020b4:	6a 00                	push   $0x0
  pushl $69
c01020b6:	6a 45                	push   $0x45
  jmp __alltraps
c01020b8:	e9 0a 08 00 00       	jmp    c01028c7 <__alltraps>

c01020bd <vector70>:
.globl vector70
vector70:
  pushl $0
c01020bd:	6a 00                	push   $0x0
  pushl $70
c01020bf:	6a 46                	push   $0x46
  jmp __alltraps
c01020c1:	e9 01 08 00 00       	jmp    c01028c7 <__alltraps>

c01020c6 <vector71>:
.globl vector71
vector71:
  pushl $0
c01020c6:	6a 00                	push   $0x0
  pushl $71
c01020c8:	6a 47                	push   $0x47
  jmp __alltraps
c01020ca:	e9 f8 07 00 00       	jmp    c01028c7 <__alltraps>

c01020cf <vector72>:
.globl vector72
vector72:
  pushl $0
c01020cf:	6a 00                	push   $0x0
  pushl $72
c01020d1:	6a 48                	push   $0x48
  jmp __alltraps
c01020d3:	e9 ef 07 00 00       	jmp    c01028c7 <__alltraps>

c01020d8 <vector73>:
.globl vector73
vector73:
  pushl $0
c01020d8:	6a 00                	push   $0x0
  pushl $73
c01020da:	6a 49                	push   $0x49
  jmp __alltraps
c01020dc:	e9 e6 07 00 00       	jmp    c01028c7 <__alltraps>

c01020e1 <vector74>:
.globl vector74
vector74:
  pushl $0
c01020e1:	6a 00                	push   $0x0
  pushl $74
c01020e3:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020e5:	e9 dd 07 00 00       	jmp    c01028c7 <__alltraps>

c01020ea <vector75>:
.globl vector75
vector75:
  pushl $0
c01020ea:	6a 00                	push   $0x0
  pushl $75
c01020ec:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020ee:	e9 d4 07 00 00       	jmp    c01028c7 <__alltraps>

c01020f3 <vector76>:
.globl vector76
vector76:
  pushl $0
c01020f3:	6a 00                	push   $0x0
  pushl $76
c01020f5:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020f7:	e9 cb 07 00 00       	jmp    c01028c7 <__alltraps>

c01020fc <vector77>:
.globl vector77
vector77:
  pushl $0
c01020fc:	6a 00                	push   $0x0
  pushl $77
c01020fe:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102100:	e9 c2 07 00 00       	jmp    c01028c7 <__alltraps>

c0102105 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102105:	6a 00                	push   $0x0
  pushl $78
c0102107:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102109:	e9 b9 07 00 00       	jmp    c01028c7 <__alltraps>

c010210e <vector79>:
.globl vector79
vector79:
  pushl $0
c010210e:	6a 00                	push   $0x0
  pushl $79
c0102110:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102112:	e9 b0 07 00 00       	jmp    c01028c7 <__alltraps>

c0102117 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102117:	6a 00                	push   $0x0
  pushl $80
c0102119:	6a 50                	push   $0x50
  jmp __alltraps
c010211b:	e9 a7 07 00 00       	jmp    c01028c7 <__alltraps>

c0102120 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102120:	6a 00                	push   $0x0
  pushl $81
c0102122:	6a 51                	push   $0x51
  jmp __alltraps
c0102124:	e9 9e 07 00 00       	jmp    c01028c7 <__alltraps>

c0102129 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102129:	6a 00                	push   $0x0
  pushl $82
c010212b:	6a 52                	push   $0x52
  jmp __alltraps
c010212d:	e9 95 07 00 00       	jmp    c01028c7 <__alltraps>

c0102132 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102132:	6a 00                	push   $0x0
  pushl $83
c0102134:	6a 53                	push   $0x53
  jmp __alltraps
c0102136:	e9 8c 07 00 00       	jmp    c01028c7 <__alltraps>

c010213b <vector84>:
.globl vector84
vector84:
  pushl $0
c010213b:	6a 00                	push   $0x0
  pushl $84
c010213d:	6a 54                	push   $0x54
  jmp __alltraps
c010213f:	e9 83 07 00 00       	jmp    c01028c7 <__alltraps>

c0102144 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102144:	6a 00                	push   $0x0
  pushl $85
c0102146:	6a 55                	push   $0x55
  jmp __alltraps
c0102148:	e9 7a 07 00 00       	jmp    c01028c7 <__alltraps>

c010214d <vector86>:
.globl vector86
vector86:
  pushl $0
c010214d:	6a 00                	push   $0x0
  pushl $86
c010214f:	6a 56                	push   $0x56
  jmp __alltraps
c0102151:	e9 71 07 00 00       	jmp    c01028c7 <__alltraps>

c0102156 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102156:	6a 00                	push   $0x0
  pushl $87
c0102158:	6a 57                	push   $0x57
  jmp __alltraps
c010215a:	e9 68 07 00 00       	jmp    c01028c7 <__alltraps>

c010215f <vector88>:
.globl vector88
vector88:
  pushl $0
c010215f:	6a 00                	push   $0x0
  pushl $88
c0102161:	6a 58                	push   $0x58
  jmp __alltraps
c0102163:	e9 5f 07 00 00       	jmp    c01028c7 <__alltraps>

c0102168 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102168:	6a 00                	push   $0x0
  pushl $89
c010216a:	6a 59                	push   $0x59
  jmp __alltraps
c010216c:	e9 56 07 00 00       	jmp    c01028c7 <__alltraps>

c0102171 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102171:	6a 00                	push   $0x0
  pushl $90
c0102173:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102175:	e9 4d 07 00 00       	jmp    c01028c7 <__alltraps>

c010217a <vector91>:
.globl vector91
vector91:
  pushl $0
c010217a:	6a 00                	push   $0x0
  pushl $91
c010217c:	6a 5b                	push   $0x5b
  jmp __alltraps
c010217e:	e9 44 07 00 00       	jmp    c01028c7 <__alltraps>

c0102183 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102183:	6a 00                	push   $0x0
  pushl $92
c0102185:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102187:	e9 3b 07 00 00       	jmp    c01028c7 <__alltraps>

c010218c <vector93>:
.globl vector93
vector93:
  pushl $0
c010218c:	6a 00                	push   $0x0
  pushl $93
c010218e:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102190:	e9 32 07 00 00       	jmp    c01028c7 <__alltraps>

c0102195 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102195:	6a 00                	push   $0x0
  pushl $94
c0102197:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102199:	e9 29 07 00 00       	jmp    c01028c7 <__alltraps>

c010219e <vector95>:
.globl vector95
vector95:
  pushl $0
c010219e:	6a 00                	push   $0x0
  pushl $95
c01021a0:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021a2:	e9 20 07 00 00       	jmp    c01028c7 <__alltraps>

c01021a7 <vector96>:
.globl vector96
vector96:
  pushl $0
c01021a7:	6a 00                	push   $0x0
  pushl $96
c01021a9:	6a 60                	push   $0x60
  jmp __alltraps
c01021ab:	e9 17 07 00 00       	jmp    c01028c7 <__alltraps>

c01021b0 <vector97>:
.globl vector97
vector97:
  pushl $0
c01021b0:	6a 00                	push   $0x0
  pushl $97
c01021b2:	6a 61                	push   $0x61
  jmp __alltraps
c01021b4:	e9 0e 07 00 00       	jmp    c01028c7 <__alltraps>

c01021b9 <vector98>:
.globl vector98
vector98:
  pushl $0
c01021b9:	6a 00                	push   $0x0
  pushl $98
c01021bb:	6a 62                	push   $0x62
  jmp __alltraps
c01021bd:	e9 05 07 00 00       	jmp    c01028c7 <__alltraps>

c01021c2 <vector99>:
.globl vector99
vector99:
  pushl $0
c01021c2:	6a 00                	push   $0x0
  pushl $99
c01021c4:	6a 63                	push   $0x63
  jmp __alltraps
c01021c6:	e9 fc 06 00 00       	jmp    c01028c7 <__alltraps>

c01021cb <vector100>:
.globl vector100
vector100:
  pushl $0
c01021cb:	6a 00                	push   $0x0
  pushl $100
c01021cd:	6a 64                	push   $0x64
  jmp __alltraps
c01021cf:	e9 f3 06 00 00       	jmp    c01028c7 <__alltraps>

c01021d4 <vector101>:
.globl vector101
vector101:
  pushl $0
c01021d4:	6a 00                	push   $0x0
  pushl $101
c01021d6:	6a 65                	push   $0x65
  jmp __alltraps
c01021d8:	e9 ea 06 00 00       	jmp    c01028c7 <__alltraps>

c01021dd <vector102>:
.globl vector102
vector102:
  pushl $0
c01021dd:	6a 00                	push   $0x0
  pushl $102
c01021df:	6a 66                	push   $0x66
  jmp __alltraps
c01021e1:	e9 e1 06 00 00       	jmp    c01028c7 <__alltraps>

c01021e6 <vector103>:
.globl vector103
vector103:
  pushl $0
c01021e6:	6a 00                	push   $0x0
  pushl $103
c01021e8:	6a 67                	push   $0x67
  jmp __alltraps
c01021ea:	e9 d8 06 00 00       	jmp    c01028c7 <__alltraps>

c01021ef <vector104>:
.globl vector104
vector104:
  pushl $0
c01021ef:	6a 00                	push   $0x0
  pushl $104
c01021f1:	6a 68                	push   $0x68
  jmp __alltraps
c01021f3:	e9 cf 06 00 00       	jmp    c01028c7 <__alltraps>

c01021f8 <vector105>:
.globl vector105
vector105:
  pushl $0
c01021f8:	6a 00                	push   $0x0
  pushl $105
c01021fa:	6a 69                	push   $0x69
  jmp __alltraps
c01021fc:	e9 c6 06 00 00       	jmp    c01028c7 <__alltraps>

c0102201 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102201:	6a 00                	push   $0x0
  pushl $106
c0102203:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102205:	e9 bd 06 00 00       	jmp    c01028c7 <__alltraps>

c010220a <vector107>:
.globl vector107
vector107:
  pushl $0
c010220a:	6a 00                	push   $0x0
  pushl $107
c010220c:	6a 6b                	push   $0x6b
  jmp __alltraps
c010220e:	e9 b4 06 00 00       	jmp    c01028c7 <__alltraps>

c0102213 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102213:	6a 00                	push   $0x0
  pushl $108
c0102215:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102217:	e9 ab 06 00 00       	jmp    c01028c7 <__alltraps>

c010221c <vector109>:
.globl vector109
vector109:
  pushl $0
c010221c:	6a 00                	push   $0x0
  pushl $109
c010221e:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102220:	e9 a2 06 00 00       	jmp    c01028c7 <__alltraps>

c0102225 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102225:	6a 00                	push   $0x0
  pushl $110
c0102227:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102229:	e9 99 06 00 00       	jmp    c01028c7 <__alltraps>

c010222e <vector111>:
.globl vector111
vector111:
  pushl $0
c010222e:	6a 00                	push   $0x0
  pushl $111
c0102230:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102232:	e9 90 06 00 00       	jmp    c01028c7 <__alltraps>

c0102237 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102237:	6a 00                	push   $0x0
  pushl $112
c0102239:	6a 70                	push   $0x70
  jmp __alltraps
c010223b:	e9 87 06 00 00       	jmp    c01028c7 <__alltraps>

c0102240 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102240:	6a 00                	push   $0x0
  pushl $113
c0102242:	6a 71                	push   $0x71
  jmp __alltraps
c0102244:	e9 7e 06 00 00       	jmp    c01028c7 <__alltraps>

c0102249 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102249:	6a 00                	push   $0x0
  pushl $114
c010224b:	6a 72                	push   $0x72
  jmp __alltraps
c010224d:	e9 75 06 00 00       	jmp    c01028c7 <__alltraps>

c0102252 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102252:	6a 00                	push   $0x0
  pushl $115
c0102254:	6a 73                	push   $0x73
  jmp __alltraps
c0102256:	e9 6c 06 00 00       	jmp    c01028c7 <__alltraps>

c010225b <vector116>:
.globl vector116
vector116:
  pushl $0
c010225b:	6a 00                	push   $0x0
  pushl $116
c010225d:	6a 74                	push   $0x74
  jmp __alltraps
c010225f:	e9 63 06 00 00       	jmp    c01028c7 <__alltraps>

c0102264 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102264:	6a 00                	push   $0x0
  pushl $117
c0102266:	6a 75                	push   $0x75
  jmp __alltraps
c0102268:	e9 5a 06 00 00       	jmp    c01028c7 <__alltraps>

c010226d <vector118>:
.globl vector118
vector118:
  pushl $0
c010226d:	6a 00                	push   $0x0
  pushl $118
c010226f:	6a 76                	push   $0x76
  jmp __alltraps
c0102271:	e9 51 06 00 00       	jmp    c01028c7 <__alltraps>

c0102276 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102276:	6a 00                	push   $0x0
  pushl $119
c0102278:	6a 77                	push   $0x77
  jmp __alltraps
c010227a:	e9 48 06 00 00       	jmp    c01028c7 <__alltraps>

c010227f <vector120>:
.globl vector120
vector120:
  pushl $0
c010227f:	6a 00                	push   $0x0
  pushl $120
c0102281:	6a 78                	push   $0x78
  jmp __alltraps
c0102283:	e9 3f 06 00 00       	jmp    c01028c7 <__alltraps>

c0102288 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102288:	6a 00                	push   $0x0
  pushl $121
c010228a:	6a 79                	push   $0x79
  jmp __alltraps
c010228c:	e9 36 06 00 00       	jmp    c01028c7 <__alltraps>

c0102291 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102291:	6a 00                	push   $0x0
  pushl $122
c0102293:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102295:	e9 2d 06 00 00       	jmp    c01028c7 <__alltraps>

c010229a <vector123>:
.globl vector123
vector123:
  pushl $0
c010229a:	6a 00                	push   $0x0
  pushl $123
c010229c:	6a 7b                	push   $0x7b
  jmp __alltraps
c010229e:	e9 24 06 00 00       	jmp    c01028c7 <__alltraps>

c01022a3 <vector124>:
.globl vector124
vector124:
  pushl $0
c01022a3:	6a 00                	push   $0x0
  pushl $124
c01022a5:	6a 7c                	push   $0x7c
  jmp __alltraps
c01022a7:	e9 1b 06 00 00       	jmp    c01028c7 <__alltraps>

c01022ac <vector125>:
.globl vector125
vector125:
  pushl $0
c01022ac:	6a 00                	push   $0x0
  pushl $125
c01022ae:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022b0:	e9 12 06 00 00       	jmp    c01028c7 <__alltraps>

c01022b5 <vector126>:
.globl vector126
vector126:
  pushl $0
c01022b5:	6a 00                	push   $0x0
  pushl $126
c01022b7:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022b9:	e9 09 06 00 00       	jmp    c01028c7 <__alltraps>

c01022be <vector127>:
.globl vector127
vector127:
  pushl $0
c01022be:	6a 00                	push   $0x0
  pushl $127
c01022c0:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022c2:	e9 00 06 00 00       	jmp    c01028c7 <__alltraps>

c01022c7 <vector128>:
.globl vector128
vector128:
  pushl $0
c01022c7:	6a 00                	push   $0x0
  pushl $128
c01022c9:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022ce:	e9 f4 05 00 00       	jmp    c01028c7 <__alltraps>

c01022d3 <vector129>:
.globl vector129
vector129:
  pushl $0
c01022d3:	6a 00                	push   $0x0
  pushl $129
c01022d5:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022da:	e9 e8 05 00 00       	jmp    c01028c7 <__alltraps>

c01022df <vector130>:
.globl vector130
vector130:
  pushl $0
c01022df:	6a 00                	push   $0x0
  pushl $130
c01022e1:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022e6:	e9 dc 05 00 00       	jmp    c01028c7 <__alltraps>

c01022eb <vector131>:
.globl vector131
vector131:
  pushl $0
c01022eb:	6a 00                	push   $0x0
  pushl $131
c01022ed:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022f2:	e9 d0 05 00 00       	jmp    c01028c7 <__alltraps>

c01022f7 <vector132>:
.globl vector132
vector132:
  pushl $0
c01022f7:	6a 00                	push   $0x0
  pushl $132
c01022f9:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022fe:	e9 c4 05 00 00       	jmp    c01028c7 <__alltraps>

c0102303 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102303:	6a 00                	push   $0x0
  pushl $133
c0102305:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010230a:	e9 b8 05 00 00       	jmp    c01028c7 <__alltraps>

c010230f <vector134>:
.globl vector134
vector134:
  pushl $0
c010230f:	6a 00                	push   $0x0
  pushl $134
c0102311:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102316:	e9 ac 05 00 00       	jmp    c01028c7 <__alltraps>

c010231b <vector135>:
.globl vector135
vector135:
  pushl $0
c010231b:	6a 00                	push   $0x0
  pushl $135
c010231d:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102322:	e9 a0 05 00 00       	jmp    c01028c7 <__alltraps>

c0102327 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102327:	6a 00                	push   $0x0
  pushl $136
c0102329:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010232e:	e9 94 05 00 00       	jmp    c01028c7 <__alltraps>

c0102333 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102333:	6a 00                	push   $0x0
  pushl $137
c0102335:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010233a:	e9 88 05 00 00       	jmp    c01028c7 <__alltraps>

c010233f <vector138>:
.globl vector138
vector138:
  pushl $0
c010233f:	6a 00                	push   $0x0
  pushl $138
c0102341:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102346:	e9 7c 05 00 00       	jmp    c01028c7 <__alltraps>

c010234b <vector139>:
.globl vector139
vector139:
  pushl $0
c010234b:	6a 00                	push   $0x0
  pushl $139
c010234d:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102352:	e9 70 05 00 00       	jmp    c01028c7 <__alltraps>

c0102357 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102357:	6a 00                	push   $0x0
  pushl $140
c0102359:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010235e:	e9 64 05 00 00       	jmp    c01028c7 <__alltraps>

c0102363 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102363:	6a 00                	push   $0x0
  pushl $141
c0102365:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010236a:	e9 58 05 00 00       	jmp    c01028c7 <__alltraps>

c010236f <vector142>:
.globl vector142
vector142:
  pushl $0
c010236f:	6a 00                	push   $0x0
  pushl $142
c0102371:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102376:	e9 4c 05 00 00       	jmp    c01028c7 <__alltraps>

c010237b <vector143>:
.globl vector143
vector143:
  pushl $0
c010237b:	6a 00                	push   $0x0
  pushl $143
c010237d:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102382:	e9 40 05 00 00       	jmp    c01028c7 <__alltraps>

c0102387 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102387:	6a 00                	push   $0x0
  pushl $144
c0102389:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010238e:	e9 34 05 00 00       	jmp    c01028c7 <__alltraps>

c0102393 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102393:	6a 00                	push   $0x0
  pushl $145
c0102395:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010239a:	e9 28 05 00 00       	jmp    c01028c7 <__alltraps>

c010239f <vector146>:
.globl vector146
vector146:
  pushl $0
c010239f:	6a 00                	push   $0x0
  pushl $146
c01023a1:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01023a6:	e9 1c 05 00 00       	jmp    c01028c7 <__alltraps>

c01023ab <vector147>:
.globl vector147
vector147:
  pushl $0
c01023ab:	6a 00                	push   $0x0
  pushl $147
c01023ad:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023b2:	e9 10 05 00 00       	jmp    c01028c7 <__alltraps>

c01023b7 <vector148>:
.globl vector148
vector148:
  pushl $0
c01023b7:	6a 00                	push   $0x0
  pushl $148
c01023b9:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023be:	e9 04 05 00 00       	jmp    c01028c7 <__alltraps>

c01023c3 <vector149>:
.globl vector149
vector149:
  pushl $0
c01023c3:	6a 00                	push   $0x0
  pushl $149
c01023c5:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023ca:	e9 f8 04 00 00       	jmp    c01028c7 <__alltraps>

c01023cf <vector150>:
.globl vector150
vector150:
  pushl $0
c01023cf:	6a 00                	push   $0x0
  pushl $150
c01023d1:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023d6:	e9 ec 04 00 00       	jmp    c01028c7 <__alltraps>

c01023db <vector151>:
.globl vector151
vector151:
  pushl $0
c01023db:	6a 00                	push   $0x0
  pushl $151
c01023dd:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023e2:	e9 e0 04 00 00       	jmp    c01028c7 <__alltraps>

c01023e7 <vector152>:
.globl vector152
vector152:
  pushl $0
c01023e7:	6a 00                	push   $0x0
  pushl $152
c01023e9:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023ee:	e9 d4 04 00 00       	jmp    c01028c7 <__alltraps>

c01023f3 <vector153>:
.globl vector153
vector153:
  pushl $0
c01023f3:	6a 00                	push   $0x0
  pushl $153
c01023f5:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023fa:	e9 c8 04 00 00       	jmp    c01028c7 <__alltraps>

c01023ff <vector154>:
.globl vector154
vector154:
  pushl $0
c01023ff:	6a 00                	push   $0x0
  pushl $154
c0102401:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102406:	e9 bc 04 00 00       	jmp    c01028c7 <__alltraps>

c010240b <vector155>:
.globl vector155
vector155:
  pushl $0
c010240b:	6a 00                	push   $0x0
  pushl $155
c010240d:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102412:	e9 b0 04 00 00       	jmp    c01028c7 <__alltraps>

c0102417 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102417:	6a 00                	push   $0x0
  pushl $156
c0102419:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010241e:	e9 a4 04 00 00       	jmp    c01028c7 <__alltraps>

c0102423 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102423:	6a 00                	push   $0x0
  pushl $157
c0102425:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010242a:	e9 98 04 00 00       	jmp    c01028c7 <__alltraps>

c010242f <vector158>:
.globl vector158
vector158:
  pushl $0
c010242f:	6a 00                	push   $0x0
  pushl $158
c0102431:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102436:	e9 8c 04 00 00       	jmp    c01028c7 <__alltraps>

c010243b <vector159>:
.globl vector159
vector159:
  pushl $0
c010243b:	6a 00                	push   $0x0
  pushl $159
c010243d:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102442:	e9 80 04 00 00       	jmp    c01028c7 <__alltraps>

c0102447 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102447:	6a 00                	push   $0x0
  pushl $160
c0102449:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010244e:	e9 74 04 00 00       	jmp    c01028c7 <__alltraps>

c0102453 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102453:	6a 00                	push   $0x0
  pushl $161
c0102455:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010245a:	e9 68 04 00 00       	jmp    c01028c7 <__alltraps>

c010245f <vector162>:
.globl vector162
vector162:
  pushl $0
c010245f:	6a 00                	push   $0x0
  pushl $162
c0102461:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102466:	e9 5c 04 00 00       	jmp    c01028c7 <__alltraps>

c010246b <vector163>:
.globl vector163
vector163:
  pushl $0
c010246b:	6a 00                	push   $0x0
  pushl $163
c010246d:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102472:	e9 50 04 00 00       	jmp    c01028c7 <__alltraps>

c0102477 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102477:	6a 00                	push   $0x0
  pushl $164
c0102479:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010247e:	e9 44 04 00 00       	jmp    c01028c7 <__alltraps>

c0102483 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102483:	6a 00                	push   $0x0
  pushl $165
c0102485:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010248a:	e9 38 04 00 00       	jmp    c01028c7 <__alltraps>

c010248f <vector166>:
.globl vector166
vector166:
  pushl $0
c010248f:	6a 00                	push   $0x0
  pushl $166
c0102491:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102496:	e9 2c 04 00 00       	jmp    c01028c7 <__alltraps>

c010249b <vector167>:
.globl vector167
vector167:
  pushl $0
c010249b:	6a 00                	push   $0x0
  pushl $167
c010249d:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024a2:	e9 20 04 00 00       	jmp    c01028c7 <__alltraps>

c01024a7 <vector168>:
.globl vector168
vector168:
  pushl $0
c01024a7:	6a 00                	push   $0x0
  pushl $168
c01024a9:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024ae:	e9 14 04 00 00       	jmp    c01028c7 <__alltraps>

c01024b3 <vector169>:
.globl vector169
vector169:
  pushl $0
c01024b3:	6a 00                	push   $0x0
  pushl $169
c01024b5:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024ba:	e9 08 04 00 00       	jmp    c01028c7 <__alltraps>

c01024bf <vector170>:
.globl vector170
vector170:
  pushl $0
c01024bf:	6a 00                	push   $0x0
  pushl $170
c01024c1:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024c6:	e9 fc 03 00 00       	jmp    c01028c7 <__alltraps>

c01024cb <vector171>:
.globl vector171
vector171:
  pushl $0
c01024cb:	6a 00                	push   $0x0
  pushl $171
c01024cd:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024d2:	e9 f0 03 00 00       	jmp    c01028c7 <__alltraps>

c01024d7 <vector172>:
.globl vector172
vector172:
  pushl $0
c01024d7:	6a 00                	push   $0x0
  pushl $172
c01024d9:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024de:	e9 e4 03 00 00       	jmp    c01028c7 <__alltraps>

c01024e3 <vector173>:
.globl vector173
vector173:
  pushl $0
c01024e3:	6a 00                	push   $0x0
  pushl $173
c01024e5:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024ea:	e9 d8 03 00 00       	jmp    c01028c7 <__alltraps>

c01024ef <vector174>:
.globl vector174
vector174:
  pushl $0
c01024ef:	6a 00                	push   $0x0
  pushl $174
c01024f1:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024f6:	e9 cc 03 00 00       	jmp    c01028c7 <__alltraps>

c01024fb <vector175>:
.globl vector175
vector175:
  pushl $0
c01024fb:	6a 00                	push   $0x0
  pushl $175
c01024fd:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102502:	e9 c0 03 00 00       	jmp    c01028c7 <__alltraps>

c0102507 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102507:	6a 00                	push   $0x0
  pushl $176
c0102509:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010250e:	e9 b4 03 00 00       	jmp    c01028c7 <__alltraps>

c0102513 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102513:	6a 00                	push   $0x0
  pushl $177
c0102515:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010251a:	e9 a8 03 00 00       	jmp    c01028c7 <__alltraps>

c010251f <vector178>:
.globl vector178
vector178:
  pushl $0
c010251f:	6a 00                	push   $0x0
  pushl $178
c0102521:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102526:	e9 9c 03 00 00       	jmp    c01028c7 <__alltraps>

c010252b <vector179>:
.globl vector179
vector179:
  pushl $0
c010252b:	6a 00                	push   $0x0
  pushl $179
c010252d:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102532:	e9 90 03 00 00       	jmp    c01028c7 <__alltraps>

c0102537 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102537:	6a 00                	push   $0x0
  pushl $180
c0102539:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010253e:	e9 84 03 00 00       	jmp    c01028c7 <__alltraps>

c0102543 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102543:	6a 00                	push   $0x0
  pushl $181
c0102545:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010254a:	e9 78 03 00 00       	jmp    c01028c7 <__alltraps>

c010254f <vector182>:
.globl vector182
vector182:
  pushl $0
c010254f:	6a 00                	push   $0x0
  pushl $182
c0102551:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102556:	e9 6c 03 00 00       	jmp    c01028c7 <__alltraps>

c010255b <vector183>:
.globl vector183
vector183:
  pushl $0
c010255b:	6a 00                	push   $0x0
  pushl $183
c010255d:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102562:	e9 60 03 00 00       	jmp    c01028c7 <__alltraps>

c0102567 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102567:	6a 00                	push   $0x0
  pushl $184
c0102569:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010256e:	e9 54 03 00 00       	jmp    c01028c7 <__alltraps>

c0102573 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102573:	6a 00                	push   $0x0
  pushl $185
c0102575:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010257a:	e9 48 03 00 00       	jmp    c01028c7 <__alltraps>

c010257f <vector186>:
.globl vector186
vector186:
  pushl $0
c010257f:	6a 00                	push   $0x0
  pushl $186
c0102581:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102586:	e9 3c 03 00 00       	jmp    c01028c7 <__alltraps>

c010258b <vector187>:
.globl vector187
vector187:
  pushl $0
c010258b:	6a 00                	push   $0x0
  pushl $187
c010258d:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102592:	e9 30 03 00 00       	jmp    c01028c7 <__alltraps>

c0102597 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102597:	6a 00                	push   $0x0
  pushl $188
c0102599:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010259e:	e9 24 03 00 00       	jmp    c01028c7 <__alltraps>

c01025a3 <vector189>:
.globl vector189
vector189:
  pushl $0
c01025a3:	6a 00                	push   $0x0
  pushl $189
c01025a5:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01025aa:	e9 18 03 00 00       	jmp    c01028c7 <__alltraps>

c01025af <vector190>:
.globl vector190
vector190:
  pushl $0
c01025af:	6a 00                	push   $0x0
  pushl $190
c01025b1:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025b6:	e9 0c 03 00 00       	jmp    c01028c7 <__alltraps>

c01025bb <vector191>:
.globl vector191
vector191:
  pushl $0
c01025bb:	6a 00                	push   $0x0
  pushl $191
c01025bd:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025c2:	e9 00 03 00 00       	jmp    c01028c7 <__alltraps>

c01025c7 <vector192>:
.globl vector192
vector192:
  pushl $0
c01025c7:	6a 00                	push   $0x0
  pushl $192
c01025c9:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025ce:	e9 f4 02 00 00       	jmp    c01028c7 <__alltraps>

c01025d3 <vector193>:
.globl vector193
vector193:
  pushl $0
c01025d3:	6a 00                	push   $0x0
  pushl $193
c01025d5:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025da:	e9 e8 02 00 00       	jmp    c01028c7 <__alltraps>

c01025df <vector194>:
.globl vector194
vector194:
  pushl $0
c01025df:	6a 00                	push   $0x0
  pushl $194
c01025e1:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025e6:	e9 dc 02 00 00       	jmp    c01028c7 <__alltraps>

c01025eb <vector195>:
.globl vector195
vector195:
  pushl $0
c01025eb:	6a 00                	push   $0x0
  pushl $195
c01025ed:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025f2:	e9 d0 02 00 00       	jmp    c01028c7 <__alltraps>

c01025f7 <vector196>:
.globl vector196
vector196:
  pushl $0
c01025f7:	6a 00                	push   $0x0
  pushl $196
c01025f9:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025fe:	e9 c4 02 00 00       	jmp    c01028c7 <__alltraps>

c0102603 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102603:	6a 00                	push   $0x0
  pushl $197
c0102605:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010260a:	e9 b8 02 00 00       	jmp    c01028c7 <__alltraps>

c010260f <vector198>:
.globl vector198
vector198:
  pushl $0
c010260f:	6a 00                	push   $0x0
  pushl $198
c0102611:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102616:	e9 ac 02 00 00       	jmp    c01028c7 <__alltraps>

c010261b <vector199>:
.globl vector199
vector199:
  pushl $0
c010261b:	6a 00                	push   $0x0
  pushl $199
c010261d:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102622:	e9 a0 02 00 00       	jmp    c01028c7 <__alltraps>

c0102627 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102627:	6a 00                	push   $0x0
  pushl $200
c0102629:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010262e:	e9 94 02 00 00       	jmp    c01028c7 <__alltraps>

c0102633 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102633:	6a 00                	push   $0x0
  pushl $201
c0102635:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010263a:	e9 88 02 00 00       	jmp    c01028c7 <__alltraps>

c010263f <vector202>:
.globl vector202
vector202:
  pushl $0
c010263f:	6a 00                	push   $0x0
  pushl $202
c0102641:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102646:	e9 7c 02 00 00       	jmp    c01028c7 <__alltraps>

c010264b <vector203>:
.globl vector203
vector203:
  pushl $0
c010264b:	6a 00                	push   $0x0
  pushl $203
c010264d:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102652:	e9 70 02 00 00       	jmp    c01028c7 <__alltraps>

c0102657 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102657:	6a 00                	push   $0x0
  pushl $204
c0102659:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010265e:	e9 64 02 00 00       	jmp    c01028c7 <__alltraps>

c0102663 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102663:	6a 00                	push   $0x0
  pushl $205
c0102665:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010266a:	e9 58 02 00 00       	jmp    c01028c7 <__alltraps>

c010266f <vector206>:
.globl vector206
vector206:
  pushl $0
c010266f:	6a 00                	push   $0x0
  pushl $206
c0102671:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102676:	e9 4c 02 00 00       	jmp    c01028c7 <__alltraps>

c010267b <vector207>:
.globl vector207
vector207:
  pushl $0
c010267b:	6a 00                	push   $0x0
  pushl $207
c010267d:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102682:	e9 40 02 00 00       	jmp    c01028c7 <__alltraps>

c0102687 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102687:	6a 00                	push   $0x0
  pushl $208
c0102689:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010268e:	e9 34 02 00 00       	jmp    c01028c7 <__alltraps>

c0102693 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102693:	6a 00                	push   $0x0
  pushl $209
c0102695:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010269a:	e9 28 02 00 00       	jmp    c01028c7 <__alltraps>

c010269f <vector210>:
.globl vector210
vector210:
  pushl $0
c010269f:	6a 00                	push   $0x0
  pushl $210
c01026a1:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01026a6:	e9 1c 02 00 00       	jmp    c01028c7 <__alltraps>

c01026ab <vector211>:
.globl vector211
vector211:
  pushl $0
c01026ab:	6a 00                	push   $0x0
  pushl $211
c01026ad:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026b2:	e9 10 02 00 00       	jmp    c01028c7 <__alltraps>

c01026b7 <vector212>:
.globl vector212
vector212:
  pushl $0
c01026b7:	6a 00                	push   $0x0
  pushl $212
c01026b9:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026be:	e9 04 02 00 00       	jmp    c01028c7 <__alltraps>

c01026c3 <vector213>:
.globl vector213
vector213:
  pushl $0
c01026c3:	6a 00                	push   $0x0
  pushl $213
c01026c5:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026ca:	e9 f8 01 00 00       	jmp    c01028c7 <__alltraps>

c01026cf <vector214>:
.globl vector214
vector214:
  pushl $0
c01026cf:	6a 00                	push   $0x0
  pushl $214
c01026d1:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026d6:	e9 ec 01 00 00       	jmp    c01028c7 <__alltraps>

c01026db <vector215>:
.globl vector215
vector215:
  pushl $0
c01026db:	6a 00                	push   $0x0
  pushl $215
c01026dd:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026e2:	e9 e0 01 00 00       	jmp    c01028c7 <__alltraps>

c01026e7 <vector216>:
.globl vector216
vector216:
  pushl $0
c01026e7:	6a 00                	push   $0x0
  pushl $216
c01026e9:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026ee:	e9 d4 01 00 00       	jmp    c01028c7 <__alltraps>

c01026f3 <vector217>:
.globl vector217
vector217:
  pushl $0
c01026f3:	6a 00                	push   $0x0
  pushl $217
c01026f5:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026fa:	e9 c8 01 00 00       	jmp    c01028c7 <__alltraps>

c01026ff <vector218>:
.globl vector218
vector218:
  pushl $0
c01026ff:	6a 00                	push   $0x0
  pushl $218
c0102701:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102706:	e9 bc 01 00 00       	jmp    c01028c7 <__alltraps>

c010270b <vector219>:
.globl vector219
vector219:
  pushl $0
c010270b:	6a 00                	push   $0x0
  pushl $219
c010270d:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102712:	e9 b0 01 00 00       	jmp    c01028c7 <__alltraps>

c0102717 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102717:	6a 00                	push   $0x0
  pushl $220
c0102719:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010271e:	e9 a4 01 00 00       	jmp    c01028c7 <__alltraps>

c0102723 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102723:	6a 00                	push   $0x0
  pushl $221
c0102725:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010272a:	e9 98 01 00 00       	jmp    c01028c7 <__alltraps>

c010272f <vector222>:
.globl vector222
vector222:
  pushl $0
c010272f:	6a 00                	push   $0x0
  pushl $222
c0102731:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102736:	e9 8c 01 00 00       	jmp    c01028c7 <__alltraps>

c010273b <vector223>:
.globl vector223
vector223:
  pushl $0
c010273b:	6a 00                	push   $0x0
  pushl $223
c010273d:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102742:	e9 80 01 00 00       	jmp    c01028c7 <__alltraps>

c0102747 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102747:	6a 00                	push   $0x0
  pushl $224
c0102749:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010274e:	e9 74 01 00 00       	jmp    c01028c7 <__alltraps>

c0102753 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102753:	6a 00                	push   $0x0
  pushl $225
c0102755:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010275a:	e9 68 01 00 00       	jmp    c01028c7 <__alltraps>

c010275f <vector226>:
.globl vector226
vector226:
  pushl $0
c010275f:	6a 00                	push   $0x0
  pushl $226
c0102761:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102766:	e9 5c 01 00 00       	jmp    c01028c7 <__alltraps>

c010276b <vector227>:
.globl vector227
vector227:
  pushl $0
c010276b:	6a 00                	push   $0x0
  pushl $227
c010276d:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102772:	e9 50 01 00 00       	jmp    c01028c7 <__alltraps>

c0102777 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102777:	6a 00                	push   $0x0
  pushl $228
c0102779:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010277e:	e9 44 01 00 00       	jmp    c01028c7 <__alltraps>

c0102783 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102783:	6a 00                	push   $0x0
  pushl $229
c0102785:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010278a:	e9 38 01 00 00       	jmp    c01028c7 <__alltraps>

c010278f <vector230>:
.globl vector230
vector230:
  pushl $0
c010278f:	6a 00                	push   $0x0
  pushl $230
c0102791:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102796:	e9 2c 01 00 00       	jmp    c01028c7 <__alltraps>

c010279b <vector231>:
.globl vector231
vector231:
  pushl $0
c010279b:	6a 00                	push   $0x0
  pushl $231
c010279d:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027a2:	e9 20 01 00 00       	jmp    c01028c7 <__alltraps>

c01027a7 <vector232>:
.globl vector232
vector232:
  pushl $0
c01027a7:	6a 00                	push   $0x0
  pushl $232
c01027a9:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027ae:	e9 14 01 00 00       	jmp    c01028c7 <__alltraps>

c01027b3 <vector233>:
.globl vector233
vector233:
  pushl $0
c01027b3:	6a 00                	push   $0x0
  pushl $233
c01027b5:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027ba:	e9 08 01 00 00       	jmp    c01028c7 <__alltraps>

c01027bf <vector234>:
.globl vector234
vector234:
  pushl $0
c01027bf:	6a 00                	push   $0x0
  pushl $234
c01027c1:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027c6:	e9 fc 00 00 00       	jmp    c01028c7 <__alltraps>

c01027cb <vector235>:
.globl vector235
vector235:
  pushl $0
c01027cb:	6a 00                	push   $0x0
  pushl $235
c01027cd:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027d2:	e9 f0 00 00 00       	jmp    c01028c7 <__alltraps>

c01027d7 <vector236>:
.globl vector236
vector236:
  pushl $0
c01027d7:	6a 00                	push   $0x0
  pushl $236
c01027d9:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027de:	e9 e4 00 00 00       	jmp    c01028c7 <__alltraps>

c01027e3 <vector237>:
.globl vector237
vector237:
  pushl $0
c01027e3:	6a 00                	push   $0x0
  pushl $237
c01027e5:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027ea:	e9 d8 00 00 00       	jmp    c01028c7 <__alltraps>

c01027ef <vector238>:
.globl vector238
vector238:
  pushl $0
c01027ef:	6a 00                	push   $0x0
  pushl $238
c01027f1:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027f6:	e9 cc 00 00 00       	jmp    c01028c7 <__alltraps>

c01027fb <vector239>:
.globl vector239
vector239:
  pushl $0
c01027fb:	6a 00                	push   $0x0
  pushl $239
c01027fd:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102802:	e9 c0 00 00 00       	jmp    c01028c7 <__alltraps>

c0102807 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102807:	6a 00                	push   $0x0
  pushl $240
c0102809:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010280e:	e9 b4 00 00 00       	jmp    c01028c7 <__alltraps>

c0102813 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102813:	6a 00                	push   $0x0
  pushl $241
c0102815:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010281a:	e9 a8 00 00 00       	jmp    c01028c7 <__alltraps>

c010281f <vector242>:
.globl vector242
vector242:
  pushl $0
c010281f:	6a 00                	push   $0x0
  pushl $242
c0102821:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102826:	e9 9c 00 00 00       	jmp    c01028c7 <__alltraps>

c010282b <vector243>:
.globl vector243
vector243:
  pushl $0
c010282b:	6a 00                	push   $0x0
  pushl $243
c010282d:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102832:	e9 90 00 00 00       	jmp    c01028c7 <__alltraps>

c0102837 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102837:	6a 00                	push   $0x0
  pushl $244
c0102839:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010283e:	e9 84 00 00 00       	jmp    c01028c7 <__alltraps>

c0102843 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102843:	6a 00                	push   $0x0
  pushl $245
c0102845:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010284a:	e9 78 00 00 00       	jmp    c01028c7 <__alltraps>

c010284f <vector246>:
.globl vector246
vector246:
  pushl $0
c010284f:	6a 00                	push   $0x0
  pushl $246
c0102851:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102856:	e9 6c 00 00 00       	jmp    c01028c7 <__alltraps>

c010285b <vector247>:
.globl vector247
vector247:
  pushl $0
c010285b:	6a 00                	push   $0x0
  pushl $247
c010285d:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102862:	e9 60 00 00 00       	jmp    c01028c7 <__alltraps>

c0102867 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102867:	6a 00                	push   $0x0
  pushl $248
c0102869:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010286e:	e9 54 00 00 00       	jmp    c01028c7 <__alltraps>

c0102873 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102873:	6a 00                	push   $0x0
  pushl $249
c0102875:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010287a:	e9 48 00 00 00       	jmp    c01028c7 <__alltraps>

c010287f <vector250>:
.globl vector250
vector250:
  pushl $0
c010287f:	6a 00                	push   $0x0
  pushl $250
c0102881:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102886:	e9 3c 00 00 00       	jmp    c01028c7 <__alltraps>

c010288b <vector251>:
.globl vector251
vector251:
  pushl $0
c010288b:	6a 00                	push   $0x0
  pushl $251
c010288d:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102892:	e9 30 00 00 00       	jmp    c01028c7 <__alltraps>

c0102897 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102897:	6a 00                	push   $0x0
  pushl $252
c0102899:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010289e:	e9 24 00 00 00       	jmp    c01028c7 <__alltraps>

c01028a3 <vector253>:
.globl vector253
vector253:
  pushl $0
c01028a3:	6a 00                	push   $0x0
  pushl $253
c01028a5:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01028aa:	e9 18 00 00 00       	jmp    c01028c7 <__alltraps>

c01028af <vector254>:
.globl vector254
vector254:
  pushl $0
c01028af:	6a 00                	push   $0x0
  pushl $254
c01028b1:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028b6:	e9 0c 00 00 00       	jmp    c01028c7 <__alltraps>

c01028bb <vector255>:
.globl vector255
vector255:
  pushl $0
c01028bb:	6a 00                	push   $0x0
  pushl $255
c01028bd:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028c2:	e9 00 00 00 00       	jmp    c01028c7 <__alltraps>

c01028c7 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01028c7:	1e                   	push   %ds
    pushl %es
c01028c8:	06                   	push   %es
    pushl %fs
c01028c9:	0f a0                	push   %fs
    pushl %gs
c01028cb:	0f a8                	push   %gs
    pushal
c01028cd:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01028ce:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01028d3:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01028d5:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01028d7:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01028d8:	e8 63 f5 ff ff       	call   c0101e40 <trap>

    # pop the pushed stack pointer
    popl %esp
c01028dd:	5c                   	pop    %esp

c01028de <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01028de:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01028df:	0f a9                	pop    %gs
    popl %fs
c01028e1:	0f a1                	pop    %fs
    popl %es
c01028e3:	07                   	pop    %es
    popl %ds
c01028e4:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01028e5:	83 c4 08             	add    $0x8,%esp
    iret
c01028e8:	cf                   	iret   

c01028e9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028e9:	55                   	push   %ebp
c01028ea:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01028ef:	8b 15 78 99 11 c0    	mov    0xc0119978,%edx
c01028f5:	29 d0                	sub    %edx,%eax
c01028f7:	c1 f8 02             	sar    $0x2,%eax
c01028fa:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102900:	5d                   	pop    %ebp
c0102901:	c3                   	ret    

c0102902 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102902:	55                   	push   %ebp
c0102903:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0102905:	ff 75 08             	pushl  0x8(%ebp)
c0102908:	e8 dc ff ff ff       	call   c01028e9 <page2ppn>
c010290d:	83 c4 04             	add    $0x4,%esp
c0102910:	c1 e0 0c             	shl    $0xc,%eax
}
c0102913:	c9                   	leave  
c0102914:	c3                   	ret    

c0102915 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102915:	55                   	push   %ebp
c0102916:	89 e5                	mov    %esp,%ebp
c0102918:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c010291b:	8b 45 08             	mov    0x8(%ebp),%eax
c010291e:	c1 e8 0c             	shr    $0xc,%eax
c0102921:	89 c2                	mov    %eax,%edx
c0102923:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0102928:	39 c2                	cmp    %eax,%edx
c010292a:	72 14                	jb     c0102940 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c010292c:	83 ec 04             	sub    $0x4,%esp
c010292f:	68 90 69 10 c0       	push   $0xc0106990
c0102934:	6a 5a                	push   $0x5a
c0102936:	68 af 69 10 c0       	push   $0xc01069af
c010293b:	e8 91 da ff ff       	call   c01003d1 <__panic>
    }
    return &pages[PPN(pa)];
c0102940:	8b 0d 78 99 11 c0    	mov    0xc0119978,%ecx
c0102946:	8b 45 08             	mov    0x8(%ebp),%eax
c0102949:	c1 e8 0c             	shr    $0xc,%eax
c010294c:	89 c2                	mov    %eax,%edx
c010294e:	89 d0                	mov    %edx,%eax
c0102950:	c1 e0 02             	shl    $0x2,%eax
c0102953:	01 d0                	add    %edx,%eax
c0102955:	c1 e0 02             	shl    $0x2,%eax
c0102958:	01 c8                	add    %ecx,%eax
}
c010295a:	c9                   	leave  
c010295b:	c3                   	ret    

c010295c <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010295c:	55                   	push   %ebp
c010295d:	89 e5                	mov    %esp,%ebp
c010295f:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0102962:	ff 75 08             	pushl  0x8(%ebp)
c0102965:	e8 98 ff ff ff       	call   c0102902 <page2pa>
c010296a:	83 c4 04             	add    $0x4,%esp
c010296d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102970:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102973:	c1 e8 0c             	shr    $0xc,%eax
c0102976:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102979:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c010297e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102981:	72 14                	jb     c0102997 <page2kva+0x3b>
c0102983:	ff 75 f4             	pushl  -0xc(%ebp)
c0102986:	68 c0 69 10 c0       	push   $0xc01069c0
c010298b:	6a 61                	push   $0x61
c010298d:	68 af 69 10 c0       	push   $0xc01069af
c0102992:	e8 3a da ff ff       	call   c01003d1 <__panic>
c0102997:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010299a:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010299f:	c9                   	leave  
c01029a0:	c3                   	ret    

c01029a1 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01029a1:	55                   	push   %ebp
c01029a2:	89 e5                	mov    %esp,%ebp
c01029a4:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c01029a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01029aa:	83 e0 01             	and    $0x1,%eax
c01029ad:	85 c0                	test   %eax,%eax
c01029af:	75 14                	jne    c01029c5 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c01029b1:	83 ec 04             	sub    $0x4,%esp
c01029b4:	68 e4 69 10 c0       	push   $0xc01069e4
c01029b9:	6a 6c                	push   $0x6c
c01029bb:	68 af 69 10 c0       	push   $0xc01069af
c01029c0:	e8 0c da ff ff       	call   c01003d1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01029c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01029cd:	83 ec 0c             	sub    $0xc,%esp
c01029d0:	50                   	push   %eax
c01029d1:	e8 3f ff ff ff       	call   c0102915 <pa2page>
c01029d6:	83 c4 10             	add    $0x10,%esp
}
c01029d9:	c9                   	leave  
c01029da:	c3                   	ret    

c01029db <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01029db:	55                   	push   %ebp
c01029dc:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01029de:	8b 45 08             	mov    0x8(%ebp),%eax
c01029e1:	8b 00                	mov    (%eax),%eax
}
c01029e3:	5d                   	pop    %ebp
c01029e4:	c3                   	ret    

c01029e5 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c01029e5:	55                   	push   %ebp
c01029e6:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01029e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01029eb:	8b 00                	mov    (%eax),%eax
c01029ed:	8d 50 01             	lea    0x1(%eax),%edx
c01029f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01029f3:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01029f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01029f8:	8b 00                	mov    (%eax),%eax
}
c01029fa:	5d                   	pop    %ebp
c01029fb:	c3                   	ret    

c01029fc <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01029fc:	55                   	push   %ebp
c01029fd:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01029ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a02:	8b 00                	mov    (%eax),%eax
c0102a04:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a0a:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102a0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a0f:	8b 00                	mov    (%eax),%eax
}
c0102a11:	5d                   	pop    %ebp
c0102a12:	c3                   	ret    

c0102a13 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0102a13:	55                   	push   %ebp
c0102a14:	89 e5                	mov    %esp,%ebp
c0102a16:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102a19:	9c                   	pushf  
c0102a1a:	58                   	pop    %eax
c0102a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102a21:	25 00 02 00 00       	and    $0x200,%eax
c0102a26:	85 c0                	test   %eax,%eax
c0102a28:	74 0c                	je     c0102a36 <__intr_save+0x23>
        intr_disable();
c0102a2a:	e8 47 ee ff ff       	call   c0101876 <intr_disable>
        return 1;
c0102a2f:	b8 01 00 00 00       	mov    $0x1,%eax
c0102a34:	eb 05                	jmp    c0102a3b <__intr_save+0x28>
    }
    return 0;
c0102a36:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102a3b:	c9                   	leave  
c0102a3c:	c3                   	ret    

c0102a3d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0102a3d:	55                   	push   %ebp
c0102a3e:	89 e5                	mov    %esp,%ebp
c0102a40:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102a43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a47:	74 05                	je     c0102a4e <__intr_restore+0x11>
        intr_enable();
c0102a49:	e8 21 ee ff ff       	call   c010186f <intr_enable>
    }
}
c0102a4e:	90                   	nop
c0102a4f:	c9                   	leave  
c0102a50:	c3                   	ret    

c0102a51 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102a51:	55                   	push   %ebp
c0102a52:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102a54:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a57:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102a5a:	b8 23 00 00 00       	mov    $0x23,%eax
c0102a5f:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102a61:	b8 23 00 00 00       	mov    $0x23,%eax
c0102a66:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102a68:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a6d:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102a6f:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a74:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102a76:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a7b:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102a7d:	ea 84 2a 10 c0 08 00 	ljmp   $0x8,$0xc0102a84
}
c0102a84:	90                   	nop
c0102a85:	5d                   	pop    %ebp
c0102a86:	c3                   	ret    

c0102a87 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102a87:	55                   	push   %ebp
c0102a88:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102a8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a8d:	a3 04 99 11 c0       	mov    %eax,0xc0119904
}
c0102a92:	90                   	nop
c0102a93:	5d                   	pop    %ebp
c0102a94:	c3                   	ret    

c0102a95 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102a95:	55                   	push   %ebp
c0102a96:	89 e5                	mov    %esp,%ebp
c0102a98:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102a9b:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0102aa0:	50                   	push   %eax
c0102aa1:	e8 e1 ff ff ff       	call   c0102a87 <load_esp0>
c0102aa6:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102aa9:	66 c7 05 08 99 11 c0 	movw   $0x10,0xc0119908
c0102ab0:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102ab2:	66 c7 05 48 8a 11 c0 	movw   $0x68,0xc0118a48
c0102ab9:	68 00 
c0102abb:	b8 00 99 11 c0       	mov    $0xc0119900,%eax
c0102ac0:	66 a3 4a 8a 11 c0    	mov    %ax,0xc0118a4a
c0102ac6:	b8 00 99 11 c0       	mov    $0xc0119900,%eax
c0102acb:	c1 e8 10             	shr    $0x10,%eax
c0102ace:	a2 4c 8a 11 c0       	mov    %al,0xc0118a4c
c0102ad3:	0f b6 05 4d 8a 11 c0 	movzbl 0xc0118a4d,%eax
c0102ada:	83 e0 f0             	and    $0xfffffff0,%eax
c0102add:	83 c8 09             	or     $0x9,%eax
c0102ae0:	a2 4d 8a 11 c0       	mov    %al,0xc0118a4d
c0102ae5:	0f b6 05 4d 8a 11 c0 	movzbl 0xc0118a4d,%eax
c0102aec:	83 e0 ef             	and    $0xffffffef,%eax
c0102aef:	a2 4d 8a 11 c0       	mov    %al,0xc0118a4d
c0102af4:	0f b6 05 4d 8a 11 c0 	movzbl 0xc0118a4d,%eax
c0102afb:	83 e0 9f             	and    $0xffffff9f,%eax
c0102afe:	a2 4d 8a 11 c0       	mov    %al,0xc0118a4d
c0102b03:	0f b6 05 4d 8a 11 c0 	movzbl 0xc0118a4d,%eax
c0102b0a:	83 c8 80             	or     $0xffffff80,%eax
c0102b0d:	a2 4d 8a 11 c0       	mov    %al,0xc0118a4d
c0102b12:	0f b6 05 4e 8a 11 c0 	movzbl 0xc0118a4e,%eax
c0102b19:	83 e0 f0             	and    $0xfffffff0,%eax
c0102b1c:	a2 4e 8a 11 c0       	mov    %al,0xc0118a4e
c0102b21:	0f b6 05 4e 8a 11 c0 	movzbl 0xc0118a4e,%eax
c0102b28:	83 e0 ef             	and    $0xffffffef,%eax
c0102b2b:	a2 4e 8a 11 c0       	mov    %al,0xc0118a4e
c0102b30:	0f b6 05 4e 8a 11 c0 	movzbl 0xc0118a4e,%eax
c0102b37:	83 e0 df             	and    $0xffffffdf,%eax
c0102b3a:	a2 4e 8a 11 c0       	mov    %al,0xc0118a4e
c0102b3f:	0f b6 05 4e 8a 11 c0 	movzbl 0xc0118a4e,%eax
c0102b46:	83 c8 40             	or     $0x40,%eax
c0102b49:	a2 4e 8a 11 c0       	mov    %al,0xc0118a4e
c0102b4e:	0f b6 05 4e 8a 11 c0 	movzbl 0xc0118a4e,%eax
c0102b55:	83 e0 7f             	and    $0x7f,%eax
c0102b58:	a2 4e 8a 11 c0       	mov    %al,0xc0118a4e
c0102b5d:	b8 00 99 11 c0       	mov    $0xc0119900,%eax
c0102b62:	c1 e8 18             	shr    $0x18,%eax
c0102b65:	a2 4f 8a 11 c0       	mov    %al,0xc0118a4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102b6a:	68 50 8a 11 c0       	push   $0xc0118a50
c0102b6f:	e8 dd fe ff ff       	call   c0102a51 <lgdt>
c0102b74:	83 c4 04             	add    $0x4,%esp
c0102b77:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102b7d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102b81:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102b84:	90                   	nop
c0102b85:	c9                   	leave  
c0102b86:	c3                   	ret    

c0102b87 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102b87:	55                   	push   %ebp
c0102b88:	89 e5                	mov    %esp,%ebp
c0102b8a:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102b8d:	c7 05 70 99 11 c0 98 	movl   $0xc0107398,0xc0119970
c0102b94:	73 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102b97:	a1 70 99 11 c0       	mov    0xc0119970,%eax
c0102b9c:	8b 00                	mov    (%eax),%eax
c0102b9e:	83 ec 08             	sub    $0x8,%esp
c0102ba1:	50                   	push   %eax
c0102ba2:	68 10 6a 10 c0       	push   $0xc0106a10
c0102ba7:	e8 bf d6 ff ff       	call   c010026b <cprintf>
c0102bac:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102baf:	a1 70 99 11 c0       	mov    0xc0119970,%eax
c0102bb4:	8b 40 04             	mov    0x4(%eax),%eax
c0102bb7:	ff d0                	call   *%eax
}
c0102bb9:	90                   	nop
c0102bba:	c9                   	leave  
c0102bbb:	c3                   	ret    

c0102bbc <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102bbc:	55                   	push   %ebp
c0102bbd:	89 e5                	mov    %esp,%ebp
c0102bbf:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102bc2:	a1 70 99 11 c0       	mov    0xc0119970,%eax
c0102bc7:	8b 40 08             	mov    0x8(%eax),%eax
c0102bca:	83 ec 08             	sub    $0x8,%esp
c0102bcd:	ff 75 0c             	pushl  0xc(%ebp)
c0102bd0:	ff 75 08             	pushl  0x8(%ebp)
c0102bd3:	ff d0                	call   *%eax
c0102bd5:	83 c4 10             	add    $0x10,%esp
}
c0102bd8:	90                   	nop
c0102bd9:	c9                   	leave  
c0102bda:	c3                   	ret    

c0102bdb <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102bdb:	55                   	push   %ebp
c0102bdc:	89 e5                	mov    %esp,%ebp
c0102bde:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102be1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102be8:	e8 26 fe ff ff       	call   c0102a13 <__intr_save>
c0102bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102bf0:	a1 70 99 11 c0       	mov    0xc0119970,%eax
c0102bf5:	8b 40 0c             	mov    0xc(%eax),%eax
c0102bf8:	83 ec 0c             	sub    $0xc,%esp
c0102bfb:	ff 75 08             	pushl  0x8(%ebp)
c0102bfe:	ff d0                	call   *%eax
c0102c00:	83 c4 10             	add    $0x10,%esp
c0102c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102c06:	83 ec 0c             	sub    $0xc,%esp
c0102c09:	ff 75 f0             	pushl  -0x10(%ebp)
c0102c0c:	e8 2c fe ff ff       	call   c0102a3d <__intr_restore>
c0102c11:	83 c4 10             	add    $0x10,%esp
    return page;
c0102c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102c17:	c9                   	leave  
c0102c18:	c3                   	ret    

c0102c19 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102c19:	55                   	push   %ebp
c0102c1a:	89 e5                	mov    %esp,%ebp
c0102c1c:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102c1f:	e8 ef fd ff ff       	call   c0102a13 <__intr_save>
c0102c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102c27:	a1 70 99 11 c0       	mov    0xc0119970,%eax
c0102c2c:	8b 40 10             	mov    0x10(%eax),%eax
c0102c2f:	83 ec 08             	sub    $0x8,%esp
c0102c32:	ff 75 0c             	pushl  0xc(%ebp)
c0102c35:	ff 75 08             	pushl  0x8(%ebp)
c0102c38:	ff d0                	call   *%eax
c0102c3a:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102c3d:	83 ec 0c             	sub    $0xc,%esp
c0102c40:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c43:	e8 f5 fd ff ff       	call   c0102a3d <__intr_restore>
c0102c48:	83 c4 10             	add    $0x10,%esp
}
c0102c4b:	90                   	nop
c0102c4c:	c9                   	leave  
c0102c4d:	c3                   	ret    

c0102c4e <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102c4e:	55                   	push   %ebp
c0102c4f:	89 e5                	mov    %esp,%ebp
c0102c51:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102c54:	e8 ba fd ff ff       	call   c0102a13 <__intr_save>
c0102c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102c5c:	a1 70 99 11 c0       	mov    0xc0119970,%eax
c0102c61:	8b 40 14             	mov    0x14(%eax),%eax
c0102c64:	ff d0                	call   *%eax
c0102c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102c69:	83 ec 0c             	sub    $0xc,%esp
c0102c6c:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c6f:	e8 c9 fd ff ff       	call   c0102a3d <__intr_restore>
c0102c74:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102c7a:	c9                   	leave  
c0102c7b:	c3                   	ret    

c0102c7c <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102c7c:	55                   	push   %ebp
c0102c7d:	89 e5                	mov    %esp,%ebp
c0102c7f:	57                   	push   %edi
c0102c80:	56                   	push   %esi
c0102c81:	53                   	push   %ebx
c0102c82:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102c85:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102c8c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102c93:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102c9a:	83 ec 0c             	sub    $0xc,%esp
c0102c9d:	68 27 6a 10 c0       	push   $0xc0106a27
c0102ca2:	e8 c4 d5 ff ff       	call   c010026b <cprintf>
c0102ca7:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102caa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102cb1:	e9 fc 00 00 00       	jmp    c0102db2 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102cb6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102cb9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cbc:	89 d0                	mov    %edx,%eax
c0102cbe:	c1 e0 02             	shl    $0x2,%eax
c0102cc1:	01 d0                	add    %edx,%eax
c0102cc3:	c1 e0 02             	shl    $0x2,%eax
c0102cc6:	01 c8                	add    %ecx,%eax
c0102cc8:	8b 50 08             	mov    0x8(%eax),%edx
c0102ccb:	8b 40 04             	mov    0x4(%eax),%eax
c0102cce:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102cd1:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102cd4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102cd7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cda:	89 d0                	mov    %edx,%eax
c0102cdc:	c1 e0 02             	shl    $0x2,%eax
c0102cdf:	01 d0                	add    %edx,%eax
c0102ce1:	c1 e0 02             	shl    $0x2,%eax
c0102ce4:	01 c8                	add    %ecx,%eax
c0102ce6:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102ce9:	8b 58 10             	mov    0x10(%eax),%ebx
c0102cec:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102cef:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102cf2:	01 c8                	add    %ecx,%eax
c0102cf4:	11 da                	adc    %ebx,%edx
c0102cf6:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102cf9:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102cfc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102cff:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d02:	89 d0                	mov    %edx,%eax
c0102d04:	c1 e0 02             	shl    $0x2,%eax
c0102d07:	01 d0                	add    %edx,%eax
c0102d09:	c1 e0 02             	shl    $0x2,%eax
c0102d0c:	01 c8                	add    %ecx,%eax
c0102d0e:	83 c0 14             	add    $0x14,%eax
c0102d11:	8b 00                	mov    (%eax),%eax
c0102d13:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102d16:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d19:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d1c:	83 c0 ff             	add    $0xffffffff,%eax
c0102d1f:	83 d2 ff             	adc    $0xffffffff,%edx
c0102d22:	89 c1                	mov    %eax,%ecx
c0102d24:	89 d3                	mov    %edx,%ebx
c0102d26:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d29:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102d2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d2f:	89 d0                	mov    %edx,%eax
c0102d31:	c1 e0 02             	shl    $0x2,%eax
c0102d34:	01 d0                	add    %edx,%eax
c0102d36:	c1 e0 02             	shl    $0x2,%eax
c0102d39:	03 45 80             	add    -0x80(%ebp),%eax
c0102d3c:	8b 50 10             	mov    0x10(%eax),%edx
c0102d3f:	8b 40 0c             	mov    0xc(%eax),%eax
c0102d42:	ff 75 84             	pushl  -0x7c(%ebp)
c0102d45:	53                   	push   %ebx
c0102d46:	51                   	push   %ecx
c0102d47:	ff 75 bc             	pushl  -0x44(%ebp)
c0102d4a:	ff 75 b8             	pushl  -0x48(%ebp)
c0102d4d:	52                   	push   %edx
c0102d4e:	50                   	push   %eax
c0102d4f:	68 34 6a 10 c0       	push   $0xc0106a34
c0102d54:	e8 12 d5 ff ff       	call   c010026b <cprintf>
c0102d59:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102d5c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d5f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d62:	89 d0                	mov    %edx,%eax
c0102d64:	c1 e0 02             	shl    $0x2,%eax
c0102d67:	01 d0                	add    %edx,%eax
c0102d69:	c1 e0 02             	shl    $0x2,%eax
c0102d6c:	01 c8                	add    %ecx,%eax
c0102d6e:	83 c0 14             	add    $0x14,%eax
c0102d71:	8b 00                	mov    (%eax),%eax
c0102d73:	83 f8 01             	cmp    $0x1,%eax
c0102d76:	75 36                	jne    c0102dae <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0102d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d7e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102d81:	77 2b                	ja     c0102dae <page_init+0x132>
c0102d83:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102d86:	72 05                	jb     c0102d8d <page_init+0x111>
c0102d88:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102d8b:	73 21                	jae    c0102dae <page_init+0x132>
c0102d8d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102d91:	77 1b                	ja     c0102dae <page_init+0x132>
c0102d93:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102d97:	72 09                	jb     c0102da2 <page_init+0x126>
c0102d99:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102da0:	77 0c                	ja     c0102dae <page_init+0x132>
                maxpa = end;        //memory: 07ee0000, [00100000, 07fdffff], type = 1.
c0102da2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102da5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102da8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102dab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102dae:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102db2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102db5:	8b 00                	mov    (%eax),%eax
c0102db7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102dba:	0f 8f f6 fe ff ff    	jg     c0102cb6 <page_init+0x3a>
                maxpa = end;        //memory: 07ee0000, [00100000, 07fdffff], type = 1.
                                    //memory: 0009fc00, [00000000, 0009fbff], type = 1.
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102dc0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102dc4:	72 1d                	jb     c0102de3 <page_init+0x167>
c0102dc6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102dca:	77 09                	ja     c0102dd5 <page_init+0x159>
c0102dcc:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102dd3:	76 0e                	jbe    c0102de3 <page_init+0x167>
        maxpa = KMEMSIZE;
c0102dd5:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102ddc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];          //虚拟地址结尾
    /*物理页数目*/
    npage = maxpa / PGSIZE;
c0102de3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102de6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102de9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102ded:	c1 ea 0c             	shr    $0xc,%edx
c0102df0:	a3 e0 98 11 c0       	mov    %eax,0xc01198e0
    /*页描述符结构，内核虚拟地址的尾部开始*/
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);    //页对其
c0102df5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102dfc:	b8 88 99 11 c0       	mov    $0xc0119988,%eax
c0102e01:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102e04:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e07:	01 d0                	add    %edx,%eax
c0102e09:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102e0c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e0f:	ba 00 00 00 00       	mov    $0x0,%edx
c0102e14:	f7 75 ac             	divl   -0x54(%ebp)
c0102e17:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e1a:	29 d0                	sub    %edx,%eax
c0102e1c:	a3 78 99 11 c0       	mov    %eax,0xc0119978
    /*页帧设置内核保留字段*/
    for (i = 0; i < npage; i ++) {
c0102e21:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e28:	eb 2f                	jmp    c0102e59 <page_init+0x1dd>
        SetPageReserved(pages + i);
c0102e2a:	8b 0d 78 99 11 c0    	mov    0xc0119978,%ecx
c0102e30:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e33:	89 d0                	mov    %edx,%eax
c0102e35:	c1 e0 02             	shl    $0x2,%eax
c0102e38:	01 d0                	add    %edx,%eax
c0102e3a:	c1 e0 02             	shl    $0x2,%eax
c0102e3d:	01 c8                	add    %ecx,%eax
c0102e3f:	83 c0 04             	add    $0x4,%eax
c0102e42:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102e49:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e4c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e4f:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e52:	0f ab 10             	bts    %edx,(%eax)
    /*物理页数目*/
    npage = maxpa / PGSIZE;
    /*页描述符结构，内核虚拟地址的尾部开始*/
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);    //页对其
    /*页帧设置内核保留字段*/
    for (i = 0; i < npage; i ++) {
c0102e55:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102e59:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e5c:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0102e61:	39 c2                	cmp    %eax,%edx
c0102e63:	72 c5                	jb     c0102e2a <page_init+0x1ae>
        SetPageReserved(pages + i);
    }
    /*页表空间之后的起始地址(物理)*/
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102e65:	8b 15 e0 98 11 c0    	mov    0xc01198e0,%edx
c0102e6b:	89 d0                	mov    %edx,%eax
c0102e6d:	c1 e0 02             	shl    $0x2,%eax
c0102e70:	01 d0                	add    %edx,%eax
c0102e72:	c1 e0 02             	shl    $0x2,%eax
c0102e75:	89 c2                	mov    %eax,%edx
c0102e77:	a1 78 99 11 c0       	mov    0xc0119978,%eax
c0102e7c:	01 d0                	add    %edx,%eax
c0102e7e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102e81:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102e88:	77 17                	ja     c0102ea1 <page_init+0x225>
c0102e8a:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102e8d:	68 64 6a 10 c0       	push   $0xc0106a64
c0102e92:	68 df 00 00 00       	push   $0xdf
c0102e97:	68 88 6a 10 c0       	push   $0xc0106a88
c0102e9c:	e8 30 d5 ff ff       	call   c01003d1 <__panic>
c0102ea1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102ea4:	05 00 00 00 40       	add    $0x40000000,%eax
c0102ea9:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102eac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102eb3:	e9 69 01 00 00       	jmp    c0103021 <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102eb8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ebb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ebe:	89 d0                	mov    %edx,%eax
c0102ec0:	c1 e0 02             	shl    $0x2,%eax
c0102ec3:	01 d0                	add    %edx,%eax
c0102ec5:	c1 e0 02             	shl    $0x2,%eax
c0102ec8:	01 c8                	add    %ecx,%eax
c0102eca:	8b 50 08             	mov    0x8(%eax),%edx
c0102ecd:	8b 40 04             	mov    0x4(%eax),%eax
c0102ed0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ed3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102ed6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ed9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102edc:	89 d0                	mov    %edx,%eax
c0102ede:	c1 e0 02             	shl    $0x2,%eax
c0102ee1:	01 d0                	add    %edx,%eax
c0102ee3:	c1 e0 02             	shl    $0x2,%eax
c0102ee6:	01 c8                	add    %ecx,%eax
c0102ee8:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102eeb:	8b 58 10             	mov    0x10(%eax),%ebx
c0102eee:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ef1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ef4:	01 c8                	add    %ecx,%eax
c0102ef6:	11 da                	adc    %ebx,%edx
c0102ef8:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102efb:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102efe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f01:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f04:	89 d0                	mov    %edx,%eax
c0102f06:	c1 e0 02             	shl    $0x2,%eax
c0102f09:	01 d0                	add    %edx,%eax
c0102f0b:	c1 e0 02             	shl    $0x2,%eax
c0102f0e:	01 c8                	add    %ecx,%eax
c0102f10:	83 c0 14             	add    $0x14,%eax
c0102f13:	8b 00                	mov    (%eax),%eax
c0102f15:	83 f8 01             	cmp    $0x1,%eax
c0102f18:	0f 85 ff 00 00 00    	jne    c010301d <page_init+0x3a1>
            if (begin < freemem) {
c0102f1e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f21:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f26:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102f29:	72 17                	jb     c0102f42 <page_init+0x2c6>
c0102f2b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102f2e:	77 05                	ja     c0102f35 <page_init+0x2b9>
c0102f30:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0102f33:	76 0d                	jbe    c0102f42 <page_init+0x2c6>
                begin = freemem;
c0102f35:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f38:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f3b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102f42:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102f46:	72 1d                	jb     c0102f65 <page_init+0x2e9>
c0102f48:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102f4c:	77 09                	ja     c0102f57 <page_init+0x2db>
c0102f4e:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102f55:	76 0e                	jbe    c0102f65 <page_init+0x2e9>
                end = KMEMSIZE;
c0102f57:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102f5e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102f65:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f68:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f6b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f6e:	0f 87 a9 00 00 00    	ja     c010301d <page_init+0x3a1>
c0102f74:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f77:	72 09                	jb     c0102f82 <page_init+0x306>
c0102f79:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f7c:	0f 83 9b 00 00 00    	jae    c010301d <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
c0102f82:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0102f89:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102f8c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102f8f:	01 d0                	add    %edx,%eax
c0102f91:	83 e8 01             	sub    $0x1,%eax
c0102f94:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102f97:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f9a:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f9f:	f7 75 9c             	divl   -0x64(%ebp)
c0102fa2:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102fa5:	29 d0                	sub    %edx,%eax
c0102fa7:	ba 00 00 00 00       	mov    $0x0,%edx
c0102fac:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102faf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0102fb2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102fb5:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102fb8:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102fbb:	ba 00 00 00 00       	mov    $0x0,%edx
c0102fc0:	89 c3                	mov    %eax,%ebx
c0102fc2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0102fc8:	89 de                	mov    %ebx,%esi
c0102fca:	89 d0                	mov    %edx,%eax
c0102fcc:	83 e0 00             	and    $0x0,%eax
c0102fcf:	89 c7                	mov    %eax,%edi
c0102fd1:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0102fd4:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0102fd7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fda:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102fdd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102fe0:	77 3b                	ja     c010301d <page_init+0x3a1>
c0102fe2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102fe5:	72 05                	jb     c0102fec <page_init+0x370>
c0102fe7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102fea:	73 31                	jae    c010301d <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0102fec:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102fef:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102ff2:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0102ff5:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0102ff8:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102ffc:	c1 ea 0c             	shr    $0xc,%edx
c0102fff:	89 c3                	mov    %eax,%ebx
c0103001:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103004:	83 ec 0c             	sub    $0xc,%esp
c0103007:	50                   	push   %eax
c0103008:	e8 08 f9 ff ff       	call   c0102915 <pa2page>
c010300d:	83 c4 10             	add    $0x10,%esp
c0103010:	83 ec 08             	sub    $0x8,%esp
c0103013:	53                   	push   %ebx
c0103014:	50                   	push   %eax
c0103015:	e8 a2 fb ff ff       	call   c0102bbc <init_memmap>
c010301a:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }
    /*页表空间之后的起始地址(物理)*/
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010301d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103021:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103024:	8b 00                	mov    (%eax),%eax
c0103026:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103029:	0f 8f 89 fe ff ff    	jg     c0102eb8 <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010302f:	90                   	nop
c0103030:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103033:	5b                   	pop    %ebx
c0103034:	5e                   	pop    %esi
c0103035:	5f                   	pop    %edi
c0103036:	5d                   	pop    %ebp
c0103037:	c3                   	ret    

c0103038 <enable_paging>:

static void
enable_paging(void) {
c0103038:	55                   	push   %ebp
c0103039:	89 e5                	mov    %esp,%ebp
c010303b:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010303e:	a1 74 99 11 c0       	mov    0xc0119974,%eax
c0103043:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0103046:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103049:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010304c:	0f 20 c0             	mov    %cr0,%eax
c010304f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0103052:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0103055:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0103058:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010305f:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c0103063:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103066:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0103069:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010306c:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010306f:	90                   	nop
c0103070:	c9                   	leave  
c0103071:	c3                   	ret    

c0103072 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103072:	55                   	push   %ebp
c0103073:	89 e5                	mov    %esp,%ebp
c0103075:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103078:	8b 45 0c             	mov    0xc(%ebp),%eax
c010307b:	33 45 14             	xor    0x14(%ebp),%eax
c010307e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103083:	85 c0                	test   %eax,%eax
c0103085:	74 19                	je     c01030a0 <boot_map_segment+0x2e>
c0103087:	68 96 6a 10 c0       	push   $0xc0106a96
c010308c:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103091:	68 08 01 00 00       	push   $0x108
c0103096:	68 88 6a 10 c0       	push   $0xc0106a88
c010309b:	e8 31 d3 ff ff       	call   c01003d1 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01030a0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01030a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030aa:	25 ff 0f 00 00       	and    $0xfff,%eax
c01030af:	89 c2                	mov    %eax,%edx
c01030b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01030b4:	01 c2                	add    %eax,%edx
c01030b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030b9:	01 d0                	add    %edx,%eax
c01030bb:	83 e8 01             	sub    $0x1,%eax
c01030be:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01030c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030c4:	ba 00 00 00 00       	mov    $0x0,%edx
c01030c9:	f7 75 f0             	divl   -0x10(%ebp)
c01030cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030cf:	29 d0                	sub    %edx,%eax
c01030d1:	c1 e8 0c             	shr    $0xc,%eax
c01030d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01030d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030da:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01030dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01030e5:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01030e8:	8b 45 14             	mov    0x14(%ebp),%eax
c01030eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01030ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01030f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01030f6:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01030f9:	eb 57                	jmp    c0103152 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01030fb:	83 ec 04             	sub    $0x4,%esp
c01030fe:	6a 01                	push   $0x1
c0103100:	ff 75 0c             	pushl  0xc(%ebp)
c0103103:	ff 75 08             	pushl  0x8(%ebp)
c0103106:	e8 98 01 00 00       	call   c01032a3 <get_pte>
c010310b:	83 c4 10             	add    $0x10,%esp
c010310e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103111:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103115:	75 19                	jne    c0103130 <boot_map_segment+0xbe>
c0103117:	68 c2 6a 10 c0       	push   $0xc0106ac2
c010311c:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103121:	68 0e 01 00 00       	push   $0x10e
c0103126:	68 88 6a 10 c0       	push   $0xc0106a88
c010312b:	e8 a1 d2 ff ff       	call   c01003d1 <__panic>
        *ptep = pa | PTE_P | perm;
c0103130:	8b 45 14             	mov    0x14(%ebp),%eax
c0103133:	0b 45 18             	or     0x18(%ebp),%eax
c0103136:	83 c8 01             	or     $0x1,%eax
c0103139:	89 c2                	mov    %eax,%edx
c010313b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010313e:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103140:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103144:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010314b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103152:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103156:	75 a3                	jne    c01030fb <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0103158:	90                   	nop
c0103159:	c9                   	leave  
c010315a:	c3                   	ret    

c010315b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010315b:	55                   	push   %ebp
c010315c:	89 e5                	mov    %esp,%ebp
c010315e:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c0103161:	83 ec 0c             	sub    $0xc,%esp
c0103164:	6a 01                	push   $0x1
c0103166:	e8 70 fa ff ff       	call   c0102bdb <alloc_pages>
c010316b:	83 c4 10             	add    $0x10,%esp
c010316e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103171:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103175:	75 17                	jne    c010318e <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c0103177:	83 ec 04             	sub    $0x4,%esp
c010317a:	68 cf 6a 10 c0       	push   $0xc0106acf
c010317f:	68 1a 01 00 00       	push   $0x11a
c0103184:	68 88 6a 10 c0       	push   $0xc0106a88
c0103189:	e8 43 d2 ff ff       	call   c01003d1 <__panic>
    }
    return page2kva(p);
c010318e:	83 ec 0c             	sub    $0xc,%esp
c0103191:	ff 75 f4             	pushl  -0xc(%ebp)
c0103194:	e8 c3 f7 ff ff       	call   c010295c <page2kva>
c0103199:	83 c4 10             	add    $0x10,%esp
}
c010319c:	c9                   	leave  
c010319d:	c3                   	ret    

c010319e <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010319e:	55                   	push   %ebp
c010319f:	89 e5                	mov    %esp,%ebp
c01031a1:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01031a4:	e8 de f9 ff ff       	call   c0102b87 <init_pmm_manager>

    // detect physical memory space, reserve already used memory, 
    // then use pmm->init_memmap to create free page list
    //建立物理页表
    page_init();
c01031a9:	e8 ce fa ff ff       	call   c0102c7c <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01031ae:	e8 78 04 00 00       	call   c010362b <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    //创建页目录
    boot_pgdir = boot_alloc_page();
c01031b3:	e8 a3 ff ff ff       	call   c010315b <boot_alloc_page>
c01031b8:	a3 e4 98 11 c0       	mov    %eax,0xc01198e4
    memset(boot_pgdir, 0, PGSIZE);
c01031bd:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01031c2:	83 ec 04             	sub    $0x4,%esp
c01031c5:	68 00 10 00 00       	push   $0x1000
c01031ca:	6a 00                	push   $0x0
c01031cc:	50                   	push   %eax
c01031cd:	e8 11 29 00 00       	call   c0105ae3 <memset>
c01031d2:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
c01031d5:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01031da:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031dd:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01031e4:	77 17                	ja     c01031fd <pmm_init+0x5f>
c01031e6:	ff 75 f4             	pushl  -0xc(%ebp)
c01031e9:	68 64 6a 10 c0       	push   $0xc0106a64
c01031ee:	68 36 01 00 00       	push   $0x136
c01031f3:	68 88 6a 10 c0       	push   $0xc0106a88
c01031f8:	e8 d4 d1 ff ff       	call   c01003d1 <__panic>
c01031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103200:	05 00 00 00 40       	add    $0x40000000,%eax
c0103205:	a3 74 99 11 c0       	mov    %eax,0xc0119974

    check_pgdir();
c010320a:	e8 3f 04 00 00       	call   c010364e <check_pgdir>
    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    //页目录插入虚拟页表
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010320f:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103214:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010321a:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c010321f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103222:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103229:	77 17                	ja     c0103242 <pmm_init+0xa4>
c010322b:	ff 75 f0             	pushl  -0x10(%ebp)
c010322e:	68 64 6a 10 c0       	push   $0xc0106a64
c0103233:	68 3f 01 00 00       	push   $0x13f
c0103238:	68 88 6a 10 c0       	push   $0xc0106a88
c010323d:	e8 8f d1 ff ff       	call   c01003d1 <__panic>
c0103242:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103245:	05 00 00 00 40       	add    $0x40000000,%eax
c010324a:	83 c8 03             	or     $0x3,%eax
c010324d:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = p    hy_addr 0~KMEMSIZE 物理地址0~0x38000000映射到线性地址0xC0000000~0xC0000000+0x38000000
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010324f:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103254:	83 ec 0c             	sub    $0xc,%esp
c0103257:	6a 02                	push   $0x2
c0103259:	6a 00                	push   $0x0
c010325b:	68 00 00 00 38       	push   $0x38000000
c0103260:	68 00 00 00 c0       	push   $0xc0000000
c0103265:	50                   	push   %eax
c0103266:	e8 07 fe ff ff       	call   c0103072 <boot_map_segment>
c010326b:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010326e:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103273:	8b 15 e4 98 11 c0    	mov    0xc01198e4,%edx
c0103279:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010327f:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0103281:	e8 b2 fd ff ff       	call   c0103038 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103286:	e8 0a f8 ff ff       	call   c0102a95 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c010328b:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103290:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103296:	e8 19 09 00 00       	call   c0103bb4 <check_boot_pgdir>

    print_pgdir();
c010329b:	e8 14 0d 00 00       	call   c0103fb4 <print_pgdir>

}
c01032a0:	90                   	nop
c01032a1:	c9                   	leave  
c01032a2:	c3                   	ret    

c01032a3 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
// 获取二级页表项地址
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01032a3:	55                   	push   %ebp
c01032a4:	89 e5                	mov    %esp,%ebp
c01032a6:	83 ec 28             	sub    $0x28,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = NULL;
c01032a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    pde_t *base_addr = pgdir;       //第一个空闲页表
c01032b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01032b3:	89 45 f0             	mov    %eax,-0x10(%ebp)

    pdep = &base_addr[PDX(la)];
c01032b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01032b9:	c1 e8 16             	shr    $0x16,%eax
c01032bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01032c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032c6:	01 d0                	add    %edx,%eax
c01032c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep)&PTE_P) == 0){
c01032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032ce:	8b 00                	mov    (%eax),%eax
c01032d0:	83 e0 01             	and    $0x1,%eax
c01032d3:	85 c0                	test   %eax,%eax
c01032d5:	0f 85 a4 00 00 00    	jne    c010337f <get_pte+0xdc>
        struct Page *page = NULL;
c01032db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

        if (create == 0 || (page = alloc_page()) == NULL) return NULL;
c01032e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01032e6:	74 16                	je     c01032fe <get_pte+0x5b>
c01032e8:	83 ec 0c             	sub    $0xc,%esp
c01032eb:	6a 01                	push   $0x1
c01032ed:	e8 e9 f8 ff ff       	call   c0102bdb <alloc_pages>
c01032f2:	83 c4 10             	add    $0x10,%esp
c01032f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01032f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01032fc:	75 0a                	jne    c0103308 <get_pte+0x65>
c01032fe:	b8 00 00 00 00       	mov    $0x0,%eax
c0103303:	e9 c8 00 00 00       	jmp    c01033d0 <get_pte+0x12d>

        uintptr_t pa_page = page2pa(page);
c0103308:	83 ec 0c             	sub    $0xc,%esp
c010330b:	ff 75 ec             	pushl  -0x14(%ebp)
c010330e:	e8 ef f5 ff ff       	call   c0102902 <page2pa>
c0103313:	83 c4 10             	add    $0x10,%esp
c0103316:	89 45 e8             	mov    %eax,-0x18(%ebp)
        memset(KADDR(pa_page), 0, PGSIZE);
c0103319:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010331c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010331f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103322:	c1 e8 0c             	shr    $0xc,%eax
c0103325:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103328:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c010332d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103330:	72 17                	jb     c0103349 <get_pte+0xa6>
c0103332:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103335:	68 c0 69 10 c0       	push   $0xc01069c0
c010333a:	68 91 01 00 00       	push   $0x191
c010333f:	68 88 6a 10 c0       	push   $0xc0106a88
c0103344:	e8 88 d0 ff ff       	call   c01003d1 <__panic>
c0103349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010334c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103351:	83 ec 04             	sub    $0x4,%esp
c0103354:	68 00 10 00 00       	push   $0x1000
c0103359:	6a 00                	push   $0x0
c010335b:	50                   	push   %eax
c010335c:	e8 82 27 00 00       	call   c0105ae3 <memset>
c0103361:	83 c4 10             	add    $0x10,%esp
        *pdep = pa_page | PTE_P | PTE_U | PTE_W;
c0103364:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103367:	83 c8 07             	or     $0x7,%eax
c010336a:	89 c2                	mov    %eax,%edx
c010336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010336f:	89 10                	mov    %edx,(%eax)
        page_ref_inc(page);
c0103371:	83 ec 0c             	sub    $0xc,%esp
c0103374:	ff 75 ec             	pushl  -0x14(%ebp)
c0103377:	e8 69 f6 ff ff       	call   c01029e5 <page_ref_inc>
c010337c:	83 c4 10             	add    $0x10,%esp
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c010337f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103382:	8b 00                	mov    (%eax),%eax
c0103384:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103389:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010338c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010338f:	c1 e8 0c             	shr    $0xc,%eax
c0103392:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103395:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c010339a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010339d:	72 17                	jb     c01033b6 <get_pte+0x113>
c010339f:	ff 75 dc             	pushl  -0x24(%ebp)
c01033a2:	68 c0 69 10 c0       	push   $0xc01069c0
c01033a7:	68 95 01 00 00       	push   $0x195
c01033ac:	68 88 6a 10 c0       	push   $0xc0106a88
c01033b1:	e8 1b d0 ff ff       	call   c01003d1 <__panic>
c01033b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01033b9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01033be:	89 c2                	mov    %eax,%edx
c01033c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033c3:	c1 e8 0c             	shr    $0xc,%eax
c01033c6:	25 ff 03 00 00       	and    $0x3ff,%eax
c01033cb:	c1 e0 02             	shl    $0x2,%eax
c01033ce:	01 d0                	add    %edx,%eax
}
c01033d0:	c9                   	leave  
c01033d1:	c3                   	ret    

c01033d2 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01033d2:	55                   	push   %ebp
c01033d3:	89 e5                	mov    %esp,%ebp
c01033d5:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01033d8:	83 ec 04             	sub    $0x4,%esp
c01033db:	6a 00                	push   $0x0
c01033dd:	ff 75 0c             	pushl  0xc(%ebp)
c01033e0:	ff 75 08             	pushl  0x8(%ebp)
c01033e3:	e8 bb fe ff ff       	call   c01032a3 <get_pte>
c01033e8:	83 c4 10             	add    $0x10,%esp
c01033eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01033ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01033f2:	74 08                	je     c01033fc <get_page+0x2a>
        *ptep_store = ptep;
c01033f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01033f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01033fa:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01033fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103400:	74 1f                	je     c0103421 <get_page+0x4f>
c0103402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103405:	8b 00                	mov    (%eax),%eax
c0103407:	83 e0 01             	and    $0x1,%eax
c010340a:	85 c0                	test   %eax,%eax
c010340c:	74 13                	je     c0103421 <get_page+0x4f>
        return pa2page(*ptep);
c010340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103411:	8b 00                	mov    (%eax),%eax
c0103413:	83 ec 0c             	sub    $0xc,%esp
c0103416:	50                   	push   %eax
c0103417:	e8 f9 f4 ff ff       	call   c0102915 <pa2page>
c010341c:	83 c4 10             	add    $0x10,%esp
c010341f:	eb 05                	jmp    c0103426 <get_page+0x54>
    }
    return NULL;
c0103421:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103426:	c9                   	leave  
c0103427:	c3                   	ret    

c0103428 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 删除一个页
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103428:	55                   	push   %ebp
c0103429:	89 e5                	mov    %esp,%ebp
c010342b:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    pde_t *pdep = NULL;
c010342e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    pde_t *base_addr = pgdir;
c0103435:	8b 45 08             	mov    0x8(%ebp),%eax
c0103438:	89 45 f0             	mov    %eax,-0x10(%ebp)

    pdep = &base_addr[PDX(la)];
c010343b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010343e:	c1 e8 16             	shr    $0x16,%eax
c0103441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103448:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010344b:	01 d0                	add    %edx,%eax
c010344d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep)&PTE_P) == 0 || ((*ptep)&PTE_P) == 0){
c0103450:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103453:	8b 00                	mov    (%eax),%eax
c0103455:	83 e0 01             	and    $0x1,%eax
c0103458:	85 c0                	test   %eax,%eax
c010345a:	0f 84 86 00 00 00    	je     c01034e6 <page_remove_pte+0xbe>
c0103460:	8b 45 10             	mov    0x10(%ebp),%eax
c0103463:	8b 00                	mov    (%eax),%eax
c0103465:	83 e0 01             	and    $0x1,%eax
c0103468:	85 c0                	test   %eax,%eax
c010346a:	74 7a                	je     c01034e6 <page_remove_pte+0xbe>
        return;
    }else{
        struct Page *page = pte2page(*ptep);
c010346c:	8b 45 10             	mov    0x10(%ebp),%eax
c010346f:	8b 00                	mov    (%eax),%eax
c0103471:	83 ec 0c             	sub    $0xc,%esp
c0103474:	50                   	push   %eax
c0103475:	e8 27 f5 ff ff       	call   c01029a1 <pte2page>
c010347a:	83 c4 10             	add    $0x10,%esp
c010347d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        
        assert(page->ref != 0);
c0103480:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103483:	8b 00                	mov    (%eax),%eax
c0103485:	85 c0                	test   %eax,%eax
c0103487:	75 19                	jne    c01034a2 <page_remove_pte+0x7a>
c0103489:	68 e8 6a 10 c0       	push   $0xc0106ae8
c010348e:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103493:	68 cc 01 00 00       	push   $0x1cc
c0103498:	68 88 6a 10 c0       	push   $0xc0106a88
c010349d:	e8 2f cf ff ff       	call   c01003d1 <__panic>
        if (page_ref_dec(page) == 0){
c01034a2:	83 ec 0c             	sub    $0xc,%esp
c01034a5:	ff 75 ec             	pushl  -0x14(%ebp)
c01034a8:	e8 4f f5 ff ff       	call   c01029fc <page_ref_dec>
c01034ad:	83 c4 10             	add    $0x10,%esp
c01034b0:	85 c0                	test   %eax,%eax
c01034b2:	75 33                	jne    c01034e7 <page_remove_pte+0xbf>
            free_page(page);
c01034b4:	83 ec 08             	sub    $0x8,%esp
c01034b7:	6a 01                	push   $0x1
c01034b9:	ff 75 ec             	pushl  -0x14(%ebp)
c01034bc:	e8 58 f7 ff ff       	call   c0102c19 <free_pages>
c01034c1:	83 c4 10             	add    $0x10,%esp
            *ptep = *ptep & ~PTE_P;
c01034c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01034c7:	8b 00                	mov    (%eax),%eax
c01034c9:	83 e0 fe             	and    $0xfffffffe,%eax
c01034cc:	89 c2                	mov    %eax,%edx
c01034ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01034d1:	89 10                	mov    %edx,(%eax)
            tlb_invalidate(base_addr, la);
c01034d3:	83 ec 08             	sub    $0x8,%esp
c01034d6:	ff 75 0c             	pushl  0xc(%ebp)
c01034d9:	ff 75 f0             	pushl  -0x10(%ebp)
c01034dc:	e8 fa 00 00 00       	call   c01035db <tlb_invalidate>
c01034e1:	83 c4 10             	add    $0x10,%esp
c01034e4:	eb 01                	jmp    c01034e7 <page_remove_pte+0xbf>
    pde_t *pdep = NULL;
    pde_t *base_addr = pgdir;

    pdep = &base_addr[PDX(la)];
    if (((*pdep)&PTE_P) == 0 || ((*ptep)&PTE_P) == 0){
        return;
c01034e6:	90                   	nop
            free_page(page);
            *ptep = *ptep & ~PTE_P;
            tlb_invalidate(base_addr, la);
        } 
    }
}
c01034e7:	c9                   	leave  
c01034e8:	c3                   	ret    

c01034e9 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01034e9:	55                   	push   %ebp
c01034ea:	89 e5                	mov    %esp,%ebp
c01034ec:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01034ef:	83 ec 04             	sub    $0x4,%esp
c01034f2:	6a 00                	push   $0x0
c01034f4:	ff 75 0c             	pushl  0xc(%ebp)
c01034f7:	ff 75 08             	pushl  0x8(%ebp)
c01034fa:	e8 a4 fd ff ff       	call   c01032a3 <get_pte>
c01034ff:	83 c4 10             	add    $0x10,%esp
c0103502:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103509:	74 14                	je     c010351f <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c010350b:	83 ec 04             	sub    $0x4,%esp
c010350e:	ff 75 f4             	pushl  -0xc(%ebp)
c0103511:	ff 75 0c             	pushl  0xc(%ebp)
c0103514:	ff 75 08             	pushl  0x8(%ebp)
c0103517:	e8 0c ff ff ff       	call   c0103428 <page_remove_pte>
c010351c:	83 c4 10             	add    $0x10,%esp
    }
}
c010351f:	90                   	nop
c0103520:	c9                   	leave  
c0103521:	c3                   	ret    

c0103522 <page_insert>:
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
//插入二级页表
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103522:	55                   	push   %ebp
c0103523:	89 e5                	mov    %esp,%ebp
c0103525:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103528:	83 ec 04             	sub    $0x4,%esp
c010352b:	6a 01                	push   $0x1
c010352d:	ff 75 10             	pushl  0x10(%ebp)
c0103530:	ff 75 08             	pushl  0x8(%ebp)
c0103533:	e8 6b fd ff ff       	call   c01032a3 <get_pte>
c0103538:	83 c4 10             	add    $0x10,%esp
c010353b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010353e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103542:	75 0a                	jne    c010354e <page_insert+0x2c>
        return -E_NO_MEM;
c0103544:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103549:	e9 8b 00 00 00       	jmp    c01035d9 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010354e:	83 ec 0c             	sub    $0xc,%esp
c0103551:	ff 75 0c             	pushl  0xc(%ebp)
c0103554:	e8 8c f4 ff ff       	call   c01029e5 <page_ref_inc>
c0103559:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c010355c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010355f:	8b 00                	mov    (%eax),%eax
c0103561:	83 e0 01             	and    $0x1,%eax
c0103564:	85 c0                	test   %eax,%eax
c0103566:	74 40                	je     c01035a8 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c0103568:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010356b:	8b 00                	mov    (%eax),%eax
c010356d:	83 ec 0c             	sub    $0xc,%esp
c0103570:	50                   	push   %eax
c0103571:	e8 2b f4 ff ff       	call   c01029a1 <pte2page>
c0103576:	83 c4 10             	add    $0x10,%esp
c0103579:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010357c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010357f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103582:	75 10                	jne    c0103594 <page_insert+0x72>
            page_ref_dec(page);
c0103584:	83 ec 0c             	sub    $0xc,%esp
c0103587:	ff 75 0c             	pushl  0xc(%ebp)
c010358a:	e8 6d f4 ff ff       	call   c01029fc <page_ref_dec>
c010358f:	83 c4 10             	add    $0x10,%esp
c0103592:	eb 14                	jmp    c01035a8 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103594:	83 ec 04             	sub    $0x4,%esp
c0103597:	ff 75 f4             	pushl  -0xc(%ebp)
c010359a:	ff 75 10             	pushl  0x10(%ebp)
c010359d:	ff 75 08             	pushl  0x8(%ebp)
c01035a0:	e8 83 fe ff ff       	call   c0103428 <page_remove_pte>
c01035a5:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01035a8:	83 ec 0c             	sub    $0xc,%esp
c01035ab:	ff 75 0c             	pushl  0xc(%ebp)
c01035ae:	e8 4f f3 ff ff       	call   c0102902 <page2pa>
c01035b3:	83 c4 10             	add    $0x10,%esp
c01035b6:	0b 45 14             	or     0x14(%ebp),%eax
c01035b9:	83 c8 01             	or     $0x1,%eax
c01035bc:	89 c2                	mov    %eax,%edx
c01035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c1:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01035c3:	83 ec 08             	sub    $0x8,%esp
c01035c6:	ff 75 10             	pushl  0x10(%ebp)
c01035c9:	ff 75 08             	pushl  0x8(%ebp)
c01035cc:	e8 0a 00 00 00       	call   c01035db <tlb_invalidate>
c01035d1:	83 c4 10             	add    $0x10,%esp
    return 0;
c01035d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01035d9:	c9                   	leave  
c01035da:	c3                   	ret    

c01035db <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.使某一个TLB中的对应的某一个页失效
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01035db:	55                   	push   %ebp
c01035dc:	89 e5                	mov    %esp,%ebp
c01035de:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01035e1:	0f 20 d8             	mov    %cr3,%eax
c01035e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c01035e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01035ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01035ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035f0:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01035f7:	77 17                	ja     c0103610 <tlb_invalidate+0x35>
c01035f9:	ff 75 f0             	pushl  -0x10(%ebp)
c01035fc:	68 64 6a 10 c0       	push   $0xc0106a64
c0103601:	68 00 02 00 00       	push   $0x200
c0103606:	68 88 6a 10 c0       	push   $0xc0106a88
c010360b:	e8 c1 cd ff ff       	call   c01003d1 <__panic>
c0103610:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103613:	05 00 00 00 40       	add    $0x40000000,%eax
c0103618:	39 c2                	cmp    %eax,%edx
c010361a:	75 0c                	jne    c0103628 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c010361c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010361f:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103622:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103625:	0f 01 38             	invlpg (%eax)
    }
}
c0103628:	90                   	nop
c0103629:	c9                   	leave  
c010362a:	c3                   	ret    

c010362b <check_alloc_page>:

static void
check_alloc_page(void) {
c010362b:	55                   	push   %ebp
c010362c:	89 e5                	mov    %esp,%ebp
c010362e:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0103631:	a1 70 99 11 c0       	mov    0xc0119970,%eax
c0103636:	8b 40 18             	mov    0x18(%eax),%eax
c0103639:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010363b:	83 ec 0c             	sub    $0xc,%esp
c010363e:	68 f8 6a 10 c0       	push   $0xc0106af8
c0103643:	e8 23 cc ff ff       	call   c010026b <cprintf>
c0103648:	83 c4 10             	add    $0x10,%esp
}
c010364b:	90                   	nop
c010364c:	c9                   	leave  
c010364d:	c3                   	ret    

c010364e <check_pgdir>:

static void
check_pgdir(void) {
c010364e:	55                   	push   %ebp
c010364f:	89 e5                	mov    %esp,%ebp
c0103651:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103654:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0103659:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010365e:	76 19                	jbe    c0103679 <check_pgdir+0x2b>
c0103660:	68 17 6b 10 c0       	push   $0xc0106b17
c0103665:	68 ad 6a 10 c0       	push   $0xc0106aad
c010366a:	68 0d 02 00 00       	push   $0x20d
c010366f:	68 88 6a 10 c0       	push   $0xc0106a88
c0103674:	e8 58 cd ff ff       	call   c01003d1 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103679:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c010367e:	85 c0                	test   %eax,%eax
c0103680:	74 0e                	je     c0103690 <check_pgdir+0x42>
c0103682:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103687:	25 ff 0f 00 00       	and    $0xfff,%eax
c010368c:	85 c0                	test   %eax,%eax
c010368e:	74 19                	je     c01036a9 <check_pgdir+0x5b>
c0103690:	68 34 6b 10 c0       	push   $0xc0106b34
c0103695:	68 ad 6a 10 c0       	push   $0xc0106aad
c010369a:	68 0e 02 00 00       	push   $0x20e
c010369f:	68 88 6a 10 c0       	push   $0xc0106a88
c01036a4:	e8 28 cd ff ff       	call   c01003d1 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01036a9:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01036ae:	83 ec 04             	sub    $0x4,%esp
c01036b1:	6a 00                	push   $0x0
c01036b3:	6a 00                	push   $0x0
c01036b5:	50                   	push   %eax
c01036b6:	e8 17 fd ff ff       	call   c01033d2 <get_page>
c01036bb:	83 c4 10             	add    $0x10,%esp
c01036be:	85 c0                	test   %eax,%eax
c01036c0:	74 19                	je     c01036db <check_pgdir+0x8d>
c01036c2:	68 6c 6b 10 c0       	push   $0xc0106b6c
c01036c7:	68 ad 6a 10 c0       	push   $0xc0106aad
c01036cc:	68 0f 02 00 00       	push   $0x20f
c01036d1:	68 88 6a 10 c0       	push   $0xc0106a88
c01036d6:	e8 f6 cc ff ff       	call   c01003d1 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01036db:	83 ec 0c             	sub    $0xc,%esp
c01036de:	6a 01                	push   $0x1
c01036e0:	e8 f6 f4 ff ff       	call   c0102bdb <alloc_pages>
c01036e5:	83 c4 10             	add    $0x10,%esp
c01036e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01036eb:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01036f0:	6a 00                	push   $0x0
c01036f2:	6a 00                	push   $0x0
c01036f4:	ff 75 f4             	pushl  -0xc(%ebp)
c01036f7:	50                   	push   %eax
c01036f8:	e8 25 fe ff ff       	call   c0103522 <page_insert>
c01036fd:	83 c4 10             	add    $0x10,%esp
c0103700:	85 c0                	test   %eax,%eax
c0103702:	74 19                	je     c010371d <check_pgdir+0xcf>
c0103704:	68 94 6b 10 c0       	push   $0xc0106b94
c0103709:	68 ad 6a 10 c0       	push   $0xc0106aad
c010370e:	68 13 02 00 00       	push   $0x213
c0103713:	68 88 6a 10 c0       	push   $0xc0106a88
c0103718:	e8 b4 cc ff ff       	call   c01003d1 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010371d:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103722:	83 ec 04             	sub    $0x4,%esp
c0103725:	6a 00                	push   $0x0
c0103727:	6a 00                	push   $0x0
c0103729:	50                   	push   %eax
c010372a:	e8 74 fb ff ff       	call   c01032a3 <get_pte>
c010372f:	83 c4 10             	add    $0x10,%esp
c0103732:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103735:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103739:	75 19                	jne    c0103754 <check_pgdir+0x106>
c010373b:	68 c0 6b 10 c0       	push   $0xc0106bc0
c0103740:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103745:	68 16 02 00 00       	push   $0x216
c010374a:	68 88 6a 10 c0       	push   $0xc0106a88
c010374f:	e8 7d cc ff ff       	call   c01003d1 <__panic>
    assert(pa2page(*ptep) == p1);
c0103754:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103757:	8b 00                	mov    (%eax),%eax
c0103759:	83 ec 0c             	sub    $0xc,%esp
c010375c:	50                   	push   %eax
c010375d:	e8 b3 f1 ff ff       	call   c0102915 <pa2page>
c0103762:	83 c4 10             	add    $0x10,%esp
c0103765:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103768:	74 19                	je     c0103783 <check_pgdir+0x135>
c010376a:	68 ed 6b 10 c0       	push   $0xc0106bed
c010376f:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103774:	68 17 02 00 00       	push   $0x217
c0103779:	68 88 6a 10 c0       	push   $0xc0106a88
c010377e:	e8 4e cc ff ff       	call   c01003d1 <__panic>
    assert(page_ref(p1) == 1);
c0103783:	83 ec 0c             	sub    $0xc,%esp
c0103786:	ff 75 f4             	pushl  -0xc(%ebp)
c0103789:	e8 4d f2 ff ff       	call   c01029db <page_ref>
c010378e:	83 c4 10             	add    $0x10,%esp
c0103791:	83 f8 01             	cmp    $0x1,%eax
c0103794:	74 19                	je     c01037af <check_pgdir+0x161>
c0103796:	68 02 6c 10 c0       	push   $0xc0106c02
c010379b:	68 ad 6a 10 c0       	push   $0xc0106aad
c01037a0:	68 18 02 00 00       	push   $0x218
c01037a5:	68 88 6a 10 c0       	push   $0xc0106a88
c01037aa:	e8 22 cc ff ff       	call   c01003d1 <__panic>
    
    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01037af:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01037b4:	8b 00                	mov    (%eax),%eax
c01037b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01037bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01037be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037c1:	c1 e8 0c             	shr    $0xc,%eax
c01037c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01037c7:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c01037cc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01037cf:	72 17                	jb     c01037e8 <check_pgdir+0x19a>
c01037d1:	ff 75 ec             	pushl  -0x14(%ebp)
c01037d4:	68 c0 69 10 c0       	push   $0xc01069c0
c01037d9:	68 1a 02 00 00       	push   $0x21a
c01037de:	68 88 6a 10 c0       	push   $0xc0106a88
c01037e3:	e8 e9 cb ff ff       	call   c01003d1 <__panic>
c01037e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037eb:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01037f0:	83 c0 04             	add    $0x4,%eax
c01037f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01037f6:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01037fb:	83 ec 04             	sub    $0x4,%esp
c01037fe:	6a 00                	push   $0x0
c0103800:	68 00 10 00 00       	push   $0x1000
c0103805:	50                   	push   %eax
c0103806:	e8 98 fa ff ff       	call   c01032a3 <get_pte>
c010380b:	83 c4 10             	add    $0x10,%esp
c010380e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103811:	74 19                	je     c010382c <check_pgdir+0x1de>
c0103813:	68 14 6c 10 c0       	push   $0xc0106c14
c0103818:	68 ad 6a 10 c0       	push   $0xc0106aad
c010381d:	68 1b 02 00 00       	push   $0x21b
c0103822:	68 88 6a 10 c0       	push   $0xc0106a88
c0103827:	e8 a5 cb ff ff       	call   c01003d1 <__panic>

    p2 = alloc_page();
c010382c:	83 ec 0c             	sub    $0xc,%esp
c010382f:	6a 01                	push   $0x1
c0103831:	e8 a5 f3 ff ff       	call   c0102bdb <alloc_pages>
c0103836:	83 c4 10             	add    $0x10,%esp
c0103839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010383c:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103841:	6a 06                	push   $0x6
c0103843:	68 00 10 00 00       	push   $0x1000
c0103848:	ff 75 e4             	pushl  -0x1c(%ebp)
c010384b:	50                   	push   %eax
c010384c:	e8 d1 fc ff ff       	call   c0103522 <page_insert>
c0103851:	83 c4 10             	add    $0x10,%esp
c0103854:	85 c0                	test   %eax,%eax
c0103856:	74 19                	je     c0103871 <check_pgdir+0x223>
c0103858:	68 3c 6c 10 c0       	push   $0xc0106c3c
c010385d:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103862:	68 1e 02 00 00       	push   $0x21e
c0103867:	68 88 6a 10 c0       	push   $0xc0106a88
c010386c:	e8 60 cb ff ff       	call   c01003d1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103871:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103876:	83 ec 04             	sub    $0x4,%esp
c0103879:	6a 00                	push   $0x0
c010387b:	68 00 10 00 00       	push   $0x1000
c0103880:	50                   	push   %eax
c0103881:	e8 1d fa ff ff       	call   c01032a3 <get_pte>
c0103886:	83 c4 10             	add    $0x10,%esp
c0103889:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010388c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103890:	75 19                	jne    c01038ab <check_pgdir+0x25d>
c0103892:	68 74 6c 10 c0       	push   $0xc0106c74
c0103897:	68 ad 6a 10 c0       	push   $0xc0106aad
c010389c:	68 1f 02 00 00       	push   $0x21f
c01038a1:	68 88 6a 10 c0       	push   $0xc0106a88
c01038a6:	e8 26 cb ff ff       	call   c01003d1 <__panic>
    assert(*ptep & PTE_U);
c01038ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038ae:	8b 00                	mov    (%eax),%eax
c01038b0:	83 e0 04             	and    $0x4,%eax
c01038b3:	85 c0                	test   %eax,%eax
c01038b5:	75 19                	jne    c01038d0 <check_pgdir+0x282>
c01038b7:	68 a4 6c 10 c0       	push   $0xc0106ca4
c01038bc:	68 ad 6a 10 c0       	push   $0xc0106aad
c01038c1:	68 20 02 00 00       	push   $0x220
c01038c6:	68 88 6a 10 c0       	push   $0xc0106a88
c01038cb:	e8 01 cb ff ff       	call   c01003d1 <__panic>
    assert(*ptep & PTE_W);
c01038d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038d3:	8b 00                	mov    (%eax),%eax
c01038d5:	83 e0 02             	and    $0x2,%eax
c01038d8:	85 c0                	test   %eax,%eax
c01038da:	75 19                	jne    c01038f5 <check_pgdir+0x2a7>
c01038dc:	68 b2 6c 10 c0       	push   $0xc0106cb2
c01038e1:	68 ad 6a 10 c0       	push   $0xc0106aad
c01038e6:	68 21 02 00 00       	push   $0x221
c01038eb:	68 88 6a 10 c0       	push   $0xc0106a88
c01038f0:	e8 dc ca ff ff       	call   c01003d1 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01038f5:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01038fa:	8b 00                	mov    (%eax),%eax
c01038fc:	83 e0 04             	and    $0x4,%eax
c01038ff:	85 c0                	test   %eax,%eax
c0103901:	75 19                	jne    c010391c <check_pgdir+0x2ce>
c0103903:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0103908:	68 ad 6a 10 c0       	push   $0xc0106aad
c010390d:	68 22 02 00 00       	push   $0x222
c0103912:	68 88 6a 10 c0       	push   $0xc0106a88
c0103917:	e8 b5 ca ff ff       	call   c01003d1 <__panic>
    assert(page_ref(p2) == 1);
c010391c:	83 ec 0c             	sub    $0xc,%esp
c010391f:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103922:	e8 b4 f0 ff ff       	call   c01029db <page_ref>
c0103927:	83 c4 10             	add    $0x10,%esp
c010392a:	83 f8 01             	cmp    $0x1,%eax
c010392d:	74 19                	je     c0103948 <check_pgdir+0x2fa>
c010392f:	68 d6 6c 10 c0       	push   $0xc0106cd6
c0103934:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103939:	68 23 02 00 00       	push   $0x223
c010393e:	68 88 6a 10 c0       	push   $0xc0106a88
c0103943:	e8 89 ca ff ff       	call   c01003d1 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103948:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c010394d:	6a 00                	push   $0x0
c010394f:	68 00 10 00 00       	push   $0x1000
c0103954:	ff 75 f4             	pushl  -0xc(%ebp)
c0103957:	50                   	push   %eax
c0103958:	e8 c5 fb ff ff       	call   c0103522 <page_insert>
c010395d:	83 c4 10             	add    $0x10,%esp
c0103960:	85 c0                	test   %eax,%eax
c0103962:	74 19                	je     c010397d <check_pgdir+0x32f>
c0103964:	68 e8 6c 10 c0       	push   $0xc0106ce8
c0103969:	68 ad 6a 10 c0       	push   $0xc0106aad
c010396e:	68 25 02 00 00       	push   $0x225
c0103973:	68 88 6a 10 c0       	push   $0xc0106a88
c0103978:	e8 54 ca ff ff       	call   c01003d1 <__panic>
    assert(page_ref(p1) == 2);
c010397d:	83 ec 0c             	sub    $0xc,%esp
c0103980:	ff 75 f4             	pushl  -0xc(%ebp)
c0103983:	e8 53 f0 ff ff       	call   c01029db <page_ref>
c0103988:	83 c4 10             	add    $0x10,%esp
c010398b:	83 f8 02             	cmp    $0x2,%eax
c010398e:	74 19                	je     c01039a9 <check_pgdir+0x35b>
c0103990:	68 14 6d 10 c0       	push   $0xc0106d14
c0103995:	68 ad 6a 10 c0       	push   $0xc0106aad
c010399a:	68 26 02 00 00       	push   $0x226
c010399f:	68 88 6a 10 c0       	push   $0xc0106a88
c01039a4:	e8 28 ca ff ff       	call   c01003d1 <__panic>
    assert(page_ref(p2) == 0);
c01039a9:	83 ec 0c             	sub    $0xc,%esp
c01039ac:	ff 75 e4             	pushl  -0x1c(%ebp)
c01039af:	e8 27 f0 ff ff       	call   c01029db <page_ref>
c01039b4:	83 c4 10             	add    $0x10,%esp
c01039b7:	85 c0                	test   %eax,%eax
c01039b9:	74 19                	je     c01039d4 <check_pgdir+0x386>
c01039bb:	68 26 6d 10 c0       	push   $0xc0106d26
c01039c0:	68 ad 6a 10 c0       	push   $0xc0106aad
c01039c5:	68 27 02 00 00       	push   $0x227
c01039ca:	68 88 6a 10 c0       	push   $0xc0106a88
c01039cf:	e8 fd c9 ff ff       	call   c01003d1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01039d4:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01039d9:	83 ec 04             	sub    $0x4,%esp
c01039dc:	6a 00                	push   $0x0
c01039de:	68 00 10 00 00       	push   $0x1000
c01039e3:	50                   	push   %eax
c01039e4:	e8 ba f8 ff ff       	call   c01032a3 <get_pte>
c01039e9:	83 c4 10             	add    $0x10,%esp
c01039ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039f3:	75 19                	jne    c0103a0e <check_pgdir+0x3c0>
c01039f5:	68 74 6c 10 c0       	push   $0xc0106c74
c01039fa:	68 ad 6a 10 c0       	push   $0xc0106aad
c01039ff:	68 28 02 00 00       	push   $0x228
c0103a04:	68 88 6a 10 c0       	push   $0xc0106a88
c0103a09:	e8 c3 c9 ff ff       	call   c01003d1 <__panic>
    assert(pa2page(*ptep) == p1);
c0103a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a11:	8b 00                	mov    (%eax),%eax
c0103a13:	83 ec 0c             	sub    $0xc,%esp
c0103a16:	50                   	push   %eax
c0103a17:	e8 f9 ee ff ff       	call   c0102915 <pa2page>
c0103a1c:	83 c4 10             	add    $0x10,%esp
c0103a1f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103a22:	74 19                	je     c0103a3d <check_pgdir+0x3ef>
c0103a24:	68 ed 6b 10 c0       	push   $0xc0106bed
c0103a29:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103a2e:	68 29 02 00 00       	push   $0x229
c0103a33:	68 88 6a 10 c0       	push   $0xc0106a88
c0103a38:	e8 94 c9 ff ff       	call   c01003d1 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a40:	8b 00                	mov    (%eax),%eax
c0103a42:	83 e0 04             	and    $0x4,%eax
c0103a45:	85 c0                	test   %eax,%eax
c0103a47:	74 19                	je     c0103a62 <check_pgdir+0x414>
c0103a49:	68 38 6d 10 c0       	push   $0xc0106d38
c0103a4e:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103a53:	68 2a 02 00 00       	push   $0x22a
c0103a58:	68 88 6a 10 c0       	push   $0xc0106a88
c0103a5d:	e8 6f c9 ff ff       	call   c01003d1 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103a62:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103a67:	83 ec 08             	sub    $0x8,%esp
c0103a6a:	6a 00                	push   $0x0
c0103a6c:	50                   	push   %eax
c0103a6d:	e8 77 fa ff ff       	call   c01034e9 <page_remove>
c0103a72:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103a75:	83 ec 0c             	sub    $0xc,%esp
c0103a78:	ff 75 f4             	pushl  -0xc(%ebp)
c0103a7b:	e8 5b ef ff ff       	call   c01029db <page_ref>
c0103a80:	83 c4 10             	add    $0x10,%esp
c0103a83:	83 f8 01             	cmp    $0x1,%eax
c0103a86:	74 19                	je     c0103aa1 <check_pgdir+0x453>
c0103a88:	68 02 6c 10 c0       	push   $0xc0106c02
c0103a8d:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103a92:	68 2d 02 00 00       	push   $0x22d
c0103a97:	68 88 6a 10 c0       	push   $0xc0106a88
c0103a9c:	e8 30 c9 ff ff       	call   c01003d1 <__panic>
    assert(page_ref(p2) == 0);
c0103aa1:	83 ec 0c             	sub    $0xc,%esp
c0103aa4:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103aa7:	e8 2f ef ff ff       	call   c01029db <page_ref>
c0103aac:	83 c4 10             	add    $0x10,%esp
c0103aaf:	85 c0                	test   %eax,%eax
c0103ab1:	74 19                	je     c0103acc <check_pgdir+0x47e>
c0103ab3:	68 26 6d 10 c0       	push   $0xc0106d26
c0103ab8:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103abd:	68 2e 02 00 00       	push   $0x22e
c0103ac2:	68 88 6a 10 c0       	push   $0xc0106a88
c0103ac7:	e8 05 c9 ff ff       	call   c01003d1 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103acc:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103ad1:	83 ec 08             	sub    $0x8,%esp
c0103ad4:	68 00 10 00 00       	push   $0x1000
c0103ad9:	50                   	push   %eax
c0103ada:	e8 0a fa ff ff       	call   c01034e9 <page_remove>
c0103adf:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103ae2:	83 ec 0c             	sub    $0xc,%esp
c0103ae5:	ff 75 f4             	pushl  -0xc(%ebp)
c0103ae8:	e8 ee ee ff ff       	call   c01029db <page_ref>
c0103aed:	83 c4 10             	add    $0x10,%esp
c0103af0:	85 c0                	test   %eax,%eax
c0103af2:	74 19                	je     c0103b0d <check_pgdir+0x4bf>
c0103af4:	68 4d 6d 10 c0       	push   $0xc0106d4d
c0103af9:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103afe:	68 31 02 00 00       	push   $0x231
c0103b03:	68 88 6a 10 c0       	push   $0xc0106a88
c0103b08:	e8 c4 c8 ff ff       	call   c01003d1 <__panic>
    assert(page_ref(p2) == 0);
c0103b0d:	83 ec 0c             	sub    $0xc,%esp
c0103b10:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103b13:	e8 c3 ee ff ff       	call   c01029db <page_ref>
c0103b18:	83 c4 10             	add    $0x10,%esp
c0103b1b:	85 c0                	test   %eax,%eax
c0103b1d:	74 19                	je     c0103b38 <check_pgdir+0x4ea>
c0103b1f:	68 26 6d 10 c0       	push   $0xc0106d26
c0103b24:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103b29:	68 32 02 00 00       	push   $0x232
c0103b2e:	68 88 6a 10 c0       	push   $0xc0106a88
c0103b33:	e8 99 c8 ff ff       	call   c01003d1 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0103b38:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103b3d:	8b 00                	mov    (%eax),%eax
c0103b3f:	83 ec 0c             	sub    $0xc,%esp
c0103b42:	50                   	push   %eax
c0103b43:	e8 cd ed ff ff       	call   c0102915 <pa2page>
c0103b48:	83 c4 10             	add    $0x10,%esp
c0103b4b:	83 ec 0c             	sub    $0xc,%esp
c0103b4e:	50                   	push   %eax
c0103b4f:	e8 87 ee ff ff       	call   c01029db <page_ref>
c0103b54:	83 c4 10             	add    $0x10,%esp
c0103b57:	83 f8 01             	cmp    $0x1,%eax
c0103b5a:	74 19                	je     c0103b75 <check_pgdir+0x527>
c0103b5c:	68 60 6d 10 c0       	push   $0xc0106d60
c0103b61:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103b66:	68 34 02 00 00       	push   $0x234
c0103b6b:	68 88 6a 10 c0       	push   $0xc0106a88
c0103b70:	e8 5c c8 ff ff       	call   c01003d1 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0103b75:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103b7a:	8b 00                	mov    (%eax),%eax
c0103b7c:	83 ec 0c             	sub    $0xc,%esp
c0103b7f:	50                   	push   %eax
c0103b80:	e8 90 ed ff ff       	call   c0102915 <pa2page>
c0103b85:	83 c4 10             	add    $0x10,%esp
c0103b88:	83 ec 08             	sub    $0x8,%esp
c0103b8b:	6a 01                	push   $0x1
c0103b8d:	50                   	push   %eax
c0103b8e:	e8 86 f0 ff ff       	call   c0102c19 <free_pages>
c0103b93:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103b96:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103b9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103ba1:	83 ec 0c             	sub    $0xc,%esp
c0103ba4:	68 86 6d 10 c0       	push   $0xc0106d86
c0103ba9:	e8 bd c6 ff ff       	call   c010026b <cprintf>
c0103bae:	83 c4 10             	add    $0x10,%esp
}
c0103bb1:	90                   	nop
c0103bb2:	c9                   	leave  
c0103bb3:	c3                   	ret    

c0103bb4 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103bb4:	55                   	push   %ebp
c0103bb5:	89 e5                	mov    %esp,%ebp
c0103bb7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103bba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103bc1:	e9 a3 00 00 00       	jmp    c0103c69 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bcf:	c1 e8 0c             	shr    $0xc,%eax
c0103bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103bd5:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0103bda:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103bdd:	72 17                	jb     c0103bf6 <check_boot_pgdir+0x42>
c0103bdf:	ff 75 f0             	pushl  -0x10(%ebp)
c0103be2:	68 c0 69 10 c0       	push   $0xc01069c0
c0103be7:	68 40 02 00 00       	push   $0x240
c0103bec:	68 88 6a 10 c0       	push   $0xc0106a88
c0103bf1:	e8 db c7 ff ff       	call   c01003d1 <__panic>
c0103bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bf9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103bfe:	89 c2                	mov    %eax,%edx
c0103c00:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103c05:	83 ec 04             	sub    $0x4,%esp
c0103c08:	6a 00                	push   $0x0
c0103c0a:	52                   	push   %edx
c0103c0b:	50                   	push   %eax
c0103c0c:	e8 92 f6 ff ff       	call   c01032a3 <get_pte>
c0103c11:	83 c4 10             	add    $0x10,%esp
c0103c14:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103c17:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103c1b:	75 19                	jne    c0103c36 <check_boot_pgdir+0x82>
c0103c1d:	68 a0 6d 10 c0       	push   $0xc0106da0
c0103c22:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103c27:	68 40 02 00 00       	push   $0x240
c0103c2c:	68 88 6a 10 c0       	push   $0xc0106a88
c0103c31:	e8 9b c7 ff ff       	call   c01003d1 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103c36:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c39:	8b 00                	mov    (%eax),%eax
c0103c3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c40:	89 c2                	mov    %eax,%edx
c0103c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c45:	39 c2                	cmp    %eax,%edx
c0103c47:	74 19                	je     c0103c62 <check_boot_pgdir+0xae>
c0103c49:	68 dd 6d 10 c0       	push   $0xc0106ddd
c0103c4e:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103c53:	68 41 02 00 00       	push   $0x241
c0103c58:	68 88 6a 10 c0       	push   $0xc0106a88
c0103c5d:	e8 6f c7 ff ff       	call   c01003d1 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103c62:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103c69:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103c6c:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0103c71:	39 c2                	cmp    %eax,%edx
c0103c73:	0f 82 4d ff ff ff    	jb     c0103bc6 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103c79:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103c7e:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103c83:	8b 00                	mov    (%eax),%eax
c0103c85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c8a:	89 c2                	mov    %eax,%edx
c0103c8c:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103c91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c94:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103c9b:	77 17                	ja     c0103cb4 <check_boot_pgdir+0x100>
c0103c9d:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103ca0:	68 64 6a 10 c0       	push   $0xc0106a64
c0103ca5:	68 44 02 00 00       	push   $0x244
c0103caa:	68 88 6a 10 c0       	push   $0xc0106a88
c0103caf:	e8 1d c7 ff ff       	call   c01003d1 <__panic>
c0103cb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cb7:	05 00 00 00 40       	add    $0x40000000,%eax
c0103cbc:	39 c2                	cmp    %eax,%edx
c0103cbe:	74 19                	je     c0103cd9 <check_boot_pgdir+0x125>
c0103cc0:	68 f4 6d 10 c0       	push   $0xc0106df4
c0103cc5:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103cca:	68 44 02 00 00       	push   $0x244
c0103ccf:	68 88 6a 10 c0       	push   $0xc0106a88
c0103cd4:	e8 f8 c6 ff ff       	call   c01003d1 <__panic>

    assert(boot_pgdir[0] == 0);
c0103cd9:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103cde:	8b 00                	mov    (%eax),%eax
c0103ce0:	85 c0                	test   %eax,%eax
c0103ce2:	74 19                	je     c0103cfd <check_boot_pgdir+0x149>
c0103ce4:	68 28 6e 10 c0       	push   $0xc0106e28
c0103ce9:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103cee:	68 46 02 00 00       	push   $0x246
c0103cf3:	68 88 6a 10 c0       	push   $0xc0106a88
c0103cf8:	e8 d4 c6 ff ff       	call   c01003d1 <__panic>

    struct Page *p;
    p = alloc_page();
c0103cfd:	83 ec 0c             	sub    $0xc,%esp
c0103d00:	6a 01                	push   $0x1
c0103d02:	e8 d4 ee ff ff       	call   c0102bdb <alloc_pages>
c0103d07:	83 c4 10             	add    $0x10,%esp
c0103d0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103d0d:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103d12:	6a 02                	push   $0x2
c0103d14:	68 00 01 00 00       	push   $0x100
c0103d19:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d1c:	50                   	push   %eax
c0103d1d:	e8 00 f8 ff ff       	call   c0103522 <page_insert>
c0103d22:	83 c4 10             	add    $0x10,%esp
c0103d25:	85 c0                	test   %eax,%eax
c0103d27:	74 19                	je     c0103d42 <check_boot_pgdir+0x18e>
c0103d29:	68 3c 6e 10 c0       	push   $0xc0106e3c
c0103d2e:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103d33:	68 4a 02 00 00       	push   $0x24a
c0103d38:	68 88 6a 10 c0       	push   $0xc0106a88
c0103d3d:	e8 8f c6 ff ff       	call   c01003d1 <__panic>
    assert(page_ref(p) == 1);
c0103d42:	83 ec 0c             	sub    $0xc,%esp
c0103d45:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d48:	e8 8e ec ff ff       	call   c01029db <page_ref>
c0103d4d:	83 c4 10             	add    $0x10,%esp
c0103d50:	83 f8 01             	cmp    $0x1,%eax
c0103d53:	74 19                	je     c0103d6e <check_boot_pgdir+0x1ba>
c0103d55:	68 6a 6e 10 c0       	push   $0xc0106e6a
c0103d5a:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103d5f:	68 4b 02 00 00       	push   $0x24b
c0103d64:	68 88 6a 10 c0       	push   $0xc0106a88
c0103d69:	e8 63 c6 ff ff       	call   c01003d1 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103d6e:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103d73:	6a 02                	push   $0x2
c0103d75:	68 00 11 00 00       	push   $0x1100
c0103d7a:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d7d:	50                   	push   %eax
c0103d7e:	e8 9f f7 ff ff       	call   c0103522 <page_insert>
c0103d83:	83 c4 10             	add    $0x10,%esp
c0103d86:	85 c0                	test   %eax,%eax
c0103d88:	74 19                	je     c0103da3 <check_boot_pgdir+0x1ef>
c0103d8a:	68 7c 6e 10 c0       	push   $0xc0106e7c
c0103d8f:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103d94:	68 4c 02 00 00       	push   $0x24c
c0103d99:	68 88 6a 10 c0       	push   $0xc0106a88
c0103d9e:	e8 2e c6 ff ff       	call   c01003d1 <__panic>
    assert(page_ref(p) == 2);
c0103da3:	83 ec 0c             	sub    $0xc,%esp
c0103da6:	ff 75 e0             	pushl  -0x20(%ebp)
c0103da9:	e8 2d ec ff ff       	call   c01029db <page_ref>
c0103dae:	83 c4 10             	add    $0x10,%esp
c0103db1:	83 f8 02             	cmp    $0x2,%eax
c0103db4:	74 19                	je     c0103dcf <check_boot_pgdir+0x21b>
c0103db6:	68 b3 6e 10 c0       	push   $0xc0106eb3
c0103dbb:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103dc0:	68 4d 02 00 00       	push   $0x24d
c0103dc5:	68 88 6a 10 c0       	push   $0xc0106a88
c0103dca:	e8 02 c6 ff ff       	call   c01003d1 <__panic>

    const char *str = "ucore: Hello world!!";
c0103dcf:	c7 45 dc c4 6e 10 c0 	movl   $0xc0106ec4,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0103dd6:	83 ec 08             	sub    $0x8,%esp
c0103dd9:	ff 75 dc             	pushl  -0x24(%ebp)
c0103ddc:	68 00 01 00 00       	push   $0x100
c0103de1:	e8 24 1a 00 00       	call   c010580a <strcpy>
c0103de6:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103de9:	83 ec 08             	sub    $0x8,%esp
c0103dec:	68 00 11 00 00       	push   $0x1100
c0103df1:	68 00 01 00 00       	push   $0x100
c0103df6:	e8 89 1a 00 00       	call   c0105884 <strcmp>
c0103dfb:	83 c4 10             	add    $0x10,%esp
c0103dfe:	85 c0                	test   %eax,%eax
c0103e00:	74 19                	je     c0103e1b <check_boot_pgdir+0x267>
c0103e02:	68 dc 6e 10 c0       	push   $0xc0106edc
c0103e07:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103e0c:	68 51 02 00 00       	push   $0x251
c0103e11:	68 88 6a 10 c0       	push   $0xc0106a88
c0103e16:	e8 b6 c5 ff ff       	call   c01003d1 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103e1b:	83 ec 0c             	sub    $0xc,%esp
c0103e1e:	ff 75 e0             	pushl  -0x20(%ebp)
c0103e21:	e8 36 eb ff ff       	call   c010295c <page2kva>
c0103e26:	83 c4 10             	add    $0x10,%esp
c0103e29:	05 00 01 00 00       	add    $0x100,%eax
c0103e2e:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103e31:	83 ec 0c             	sub    $0xc,%esp
c0103e34:	68 00 01 00 00       	push   $0x100
c0103e39:	e8 74 19 00 00       	call   c01057b2 <strlen>
c0103e3e:	83 c4 10             	add    $0x10,%esp
c0103e41:	85 c0                	test   %eax,%eax
c0103e43:	74 19                	je     c0103e5e <check_boot_pgdir+0x2aa>
c0103e45:	68 14 6f 10 c0       	push   $0xc0106f14
c0103e4a:	68 ad 6a 10 c0       	push   $0xc0106aad
c0103e4f:	68 54 02 00 00       	push   $0x254
c0103e54:	68 88 6a 10 c0       	push   $0xc0106a88
c0103e59:	e8 73 c5 ff ff       	call   c01003d1 <__panic>

    free_page(p);
c0103e5e:	83 ec 08             	sub    $0x8,%esp
c0103e61:	6a 01                	push   $0x1
c0103e63:	ff 75 e0             	pushl  -0x20(%ebp)
c0103e66:	e8 ae ed ff ff       	call   c0102c19 <free_pages>
c0103e6b:	83 c4 10             	add    $0x10,%esp
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0103e6e:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103e73:	8b 00                	mov    (%eax),%eax
c0103e75:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e7a:	83 ec 0c             	sub    $0xc,%esp
c0103e7d:	50                   	push   %eax
c0103e7e:	e8 92 ea ff ff       	call   c0102915 <pa2page>
c0103e83:	83 c4 10             	add    $0x10,%esp
c0103e86:	83 ec 08             	sub    $0x8,%esp
c0103e89:	6a 01                	push   $0x1
c0103e8b:	50                   	push   %eax
c0103e8c:	e8 88 ed ff ff       	call   c0102c19 <free_pages>
c0103e91:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103e94:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0103e99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103e9f:	83 ec 0c             	sub    $0xc,%esp
c0103ea2:	68 38 6f 10 c0       	push   $0xc0106f38
c0103ea7:	e8 bf c3 ff ff       	call   c010026b <cprintf>
c0103eac:	83 c4 10             	add    $0x10,%esp
}
c0103eaf:	90                   	nop
c0103eb0:	c9                   	leave  
c0103eb1:	c3                   	ret    

c0103eb2 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103eb2:	55                   	push   %ebp
c0103eb3:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103eb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103eb8:	83 e0 04             	and    $0x4,%eax
c0103ebb:	85 c0                	test   %eax,%eax
c0103ebd:	74 07                	je     c0103ec6 <perm2str+0x14>
c0103ebf:	b8 75 00 00 00       	mov    $0x75,%eax
c0103ec4:	eb 05                	jmp    c0103ecb <perm2str+0x19>
c0103ec6:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103ecb:	a2 68 99 11 c0       	mov    %al,0xc0119968
    str[1] = 'r';
c0103ed0:	c6 05 69 99 11 c0 72 	movb   $0x72,0xc0119969
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103ed7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103eda:	83 e0 02             	and    $0x2,%eax
c0103edd:	85 c0                	test   %eax,%eax
c0103edf:	74 07                	je     c0103ee8 <perm2str+0x36>
c0103ee1:	b8 77 00 00 00       	mov    $0x77,%eax
c0103ee6:	eb 05                	jmp    c0103eed <perm2str+0x3b>
c0103ee8:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103eed:	a2 6a 99 11 c0       	mov    %al,0xc011996a
    str[3] = '\0';
c0103ef2:	c6 05 6b 99 11 c0 00 	movb   $0x0,0xc011996b
    return str;
c0103ef9:	b8 68 99 11 c0       	mov    $0xc0119968,%eax
}
c0103efe:	5d                   	pop    %ebp
c0103eff:	c3                   	ret    

c0103f00 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103f00:	55                   	push   %ebp
c0103f01:	89 e5                	mov    %esp,%ebp
c0103f03:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103f06:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f09:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f0c:	72 0e                	jb     c0103f1c <get_pgtable_items+0x1c>
        return 0;
c0103f0e:	b8 00 00 00 00       	mov    $0x0,%eax
c0103f13:	e9 9a 00 00 00       	jmp    c0103fb2 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103f18:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0103f1c:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f1f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f22:	73 18                	jae    c0103f3c <get_pgtable_items+0x3c>
c0103f24:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f2e:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f31:	01 d0                	add    %edx,%eax
c0103f33:	8b 00                	mov    (%eax),%eax
c0103f35:	83 e0 01             	and    $0x1,%eax
c0103f38:	85 c0                	test   %eax,%eax
c0103f3a:	74 dc                	je     c0103f18 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0103f3c:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f3f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f42:	73 69                	jae    c0103fad <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0103f44:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103f48:	74 08                	je     c0103f52 <get_pgtable_items+0x52>
            *left_store = start;
c0103f4a:	8b 45 18             	mov    0x18(%ebp),%eax
c0103f4d:	8b 55 10             	mov    0x10(%ebp),%edx
c0103f50:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103f52:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f55:	8d 50 01             	lea    0x1(%eax),%edx
c0103f58:	89 55 10             	mov    %edx,0x10(%ebp)
c0103f5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f62:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f65:	01 d0                	add    %edx,%eax
c0103f67:	8b 00                	mov    (%eax),%eax
c0103f69:	83 e0 07             	and    $0x7,%eax
c0103f6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103f6f:	eb 04                	jmp    c0103f75 <get_pgtable_items+0x75>
            start ++;
c0103f71:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103f75:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f78:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f7b:	73 1d                	jae    c0103f9a <get_pgtable_items+0x9a>
c0103f7d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f80:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f87:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f8a:	01 d0                	add    %edx,%eax
c0103f8c:	8b 00                	mov    (%eax),%eax
c0103f8e:	83 e0 07             	and    $0x7,%eax
c0103f91:	89 c2                	mov    %eax,%edx
c0103f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f96:	39 c2                	cmp    %eax,%edx
c0103f98:	74 d7                	je     c0103f71 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c0103f9a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103f9e:	74 08                	je     c0103fa8 <get_pgtable_items+0xa8>
            *right_store = start;
c0103fa0:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0103fa3:	8b 55 10             	mov    0x10(%ebp),%edx
c0103fa6:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0103fa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103fab:	eb 05                	jmp    c0103fb2 <get_pgtable_items+0xb2>
    }
    return 0;
c0103fad:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103fb2:	c9                   	leave  
c0103fb3:	c3                   	ret    

c0103fb4 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0103fb4:	55                   	push   %ebp
c0103fb5:	89 e5                	mov    %esp,%ebp
c0103fb7:	57                   	push   %edi
c0103fb8:	56                   	push   %esi
c0103fb9:	53                   	push   %ebx
c0103fba:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0103fbd:	83 ec 0c             	sub    $0xc,%esp
c0103fc0:	68 58 6f 10 c0       	push   $0xc0106f58
c0103fc5:	e8 a1 c2 ff ff       	call   c010026b <cprintf>
c0103fca:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0103fcd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103fd4:	e9 e5 00 00 00       	jmp    c01040be <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fdc:	83 ec 0c             	sub    $0xc,%esp
c0103fdf:	50                   	push   %eax
c0103fe0:	e8 cd fe ff ff       	call   c0103eb2 <perm2str>
c0103fe5:	83 c4 10             	add    $0x10,%esp
c0103fe8:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0103fea:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ff0:	29 c2                	sub    %eax,%edx
c0103ff2:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103ff4:	c1 e0 16             	shl    $0x16,%eax
c0103ff7:	89 c3                	mov    %eax,%ebx
c0103ff9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ffc:	c1 e0 16             	shl    $0x16,%eax
c0103fff:	89 c1                	mov    %eax,%ecx
c0104001:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104004:	c1 e0 16             	shl    $0x16,%eax
c0104007:	89 c2                	mov    %eax,%edx
c0104009:	8b 75 dc             	mov    -0x24(%ebp),%esi
c010400c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010400f:	29 c6                	sub    %eax,%esi
c0104011:	89 f0                	mov    %esi,%eax
c0104013:	83 ec 08             	sub    $0x8,%esp
c0104016:	57                   	push   %edi
c0104017:	53                   	push   %ebx
c0104018:	51                   	push   %ecx
c0104019:	52                   	push   %edx
c010401a:	50                   	push   %eax
c010401b:	68 89 6f 10 c0       	push   $0xc0106f89
c0104020:	e8 46 c2 ff ff       	call   c010026b <cprintf>
c0104025:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0104028:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010402b:	c1 e0 0a             	shl    $0xa,%eax
c010402e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104031:	eb 4f                	jmp    c0104082 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104036:	83 ec 0c             	sub    $0xc,%esp
c0104039:	50                   	push   %eax
c010403a:	e8 73 fe ff ff       	call   c0103eb2 <perm2str>
c010403f:	83 c4 10             	add    $0x10,%esp
c0104042:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104044:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104047:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010404a:	29 c2                	sub    %eax,%edx
c010404c:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010404e:	c1 e0 0c             	shl    $0xc,%eax
c0104051:	89 c3                	mov    %eax,%ebx
c0104053:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104056:	c1 e0 0c             	shl    $0xc,%eax
c0104059:	89 c1                	mov    %eax,%ecx
c010405b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010405e:	c1 e0 0c             	shl    $0xc,%eax
c0104061:	89 c2                	mov    %eax,%edx
c0104063:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0104066:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104069:	29 c6                	sub    %eax,%esi
c010406b:	89 f0                	mov    %esi,%eax
c010406d:	83 ec 08             	sub    $0x8,%esp
c0104070:	57                   	push   %edi
c0104071:	53                   	push   %ebx
c0104072:	51                   	push   %ecx
c0104073:	52                   	push   %edx
c0104074:	50                   	push   %eax
c0104075:	68 a8 6f 10 c0       	push   $0xc0106fa8
c010407a:	e8 ec c1 ff ff       	call   c010026b <cprintf>
c010407f:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104082:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104087:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010408a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010408d:	89 d3                	mov    %edx,%ebx
c010408f:	c1 e3 0a             	shl    $0xa,%ebx
c0104092:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104095:	89 d1                	mov    %edx,%ecx
c0104097:	c1 e1 0a             	shl    $0xa,%ecx
c010409a:	83 ec 08             	sub    $0x8,%esp
c010409d:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01040a0:	52                   	push   %edx
c01040a1:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01040a4:	52                   	push   %edx
c01040a5:	56                   	push   %esi
c01040a6:	50                   	push   %eax
c01040a7:	53                   	push   %ebx
c01040a8:	51                   	push   %ecx
c01040a9:	e8 52 fe ff ff       	call   c0103f00 <get_pgtable_items>
c01040ae:	83 c4 20             	add    $0x20,%esp
c01040b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01040b8:	0f 85 75 ff ff ff    	jne    c0104033 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01040be:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01040c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040c6:	83 ec 08             	sub    $0x8,%esp
c01040c9:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01040cc:	52                   	push   %edx
c01040cd:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01040d0:	52                   	push   %edx
c01040d1:	51                   	push   %ecx
c01040d2:	50                   	push   %eax
c01040d3:	68 00 04 00 00       	push   $0x400
c01040d8:	6a 00                	push   $0x0
c01040da:	e8 21 fe ff ff       	call   c0103f00 <get_pgtable_items>
c01040df:	83 c4 20             	add    $0x20,%esp
c01040e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01040e9:	0f 85 ea fe ff ff    	jne    c0103fd9 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01040ef:	83 ec 0c             	sub    $0xc,%esp
c01040f2:	68 cc 6f 10 c0       	push   $0xc0106fcc
c01040f7:	e8 6f c1 ff ff       	call   c010026b <cprintf>
c01040fc:	83 c4 10             	add    $0x10,%esp
}
c01040ff:	90                   	nop
c0104100:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104103:	5b                   	pop    %ebx
c0104104:	5e                   	pop    %esi
c0104105:	5f                   	pop    %edi
c0104106:	5d                   	pop    %ebp
c0104107:	c3                   	ret    

c0104108 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104108:	55                   	push   %ebp
c0104109:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010410b:	8b 45 08             	mov    0x8(%ebp),%eax
c010410e:	8b 15 78 99 11 c0    	mov    0xc0119978,%edx
c0104114:	29 d0                	sub    %edx,%eax
c0104116:	c1 f8 02             	sar    $0x2,%eax
c0104119:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010411f:	5d                   	pop    %ebp
c0104120:	c3                   	ret    

c0104121 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104121:	55                   	push   %ebp
c0104122:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0104124:	ff 75 08             	pushl  0x8(%ebp)
c0104127:	e8 dc ff ff ff       	call   c0104108 <page2ppn>
c010412c:	83 c4 04             	add    $0x4,%esp
c010412f:	c1 e0 0c             	shl    $0xc,%eax
}
c0104132:	c9                   	leave  
c0104133:	c3                   	ret    

c0104134 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104134:	55                   	push   %ebp
c0104135:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104137:	8b 45 08             	mov    0x8(%ebp),%eax
c010413a:	8b 00                	mov    (%eax),%eax
}
c010413c:	5d                   	pop    %ebp
c010413d:	c3                   	ret    

c010413e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010413e:	55                   	push   %ebp
c010413f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104141:	8b 45 08             	mov    0x8(%ebp),%eax
c0104144:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104147:	89 10                	mov    %edx,(%eax)
}
c0104149:	90                   	nop
c010414a:	5d                   	pop    %ebp
c010414b:	c3                   	ret    

c010414c <get_power>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)


static size_t get_power(size_t n){
c010414c:	55                   	push   %ebp
c010414d:	89 e5                	mov    %esp,%ebp
c010414f:	83 ec 10             	sub    $0x10,%esp
    for (size_t i = 0;;){
c0104152:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        if((1 << i) <= n && (1 << ++i) > n ){
c0104159:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010415c:	ba 01 00 00 00       	mov    $0x1,%edx
c0104161:	89 c1                	mov    %eax,%ecx
c0104163:	d3 e2                	shl    %cl,%edx
c0104165:	89 d0                	mov    %edx,%eax
c0104167:	3b 45 08             	cmp    0x8(%ebp),%eax
c010416a:	77 ed                	ja     c0104159 <get_power+0xd>
c010416c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0104170:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104173:	ba 01 00 00 00       	mov    $0x1,%edx
c0104178:	89 c1                	mov    %eax,%ecx
c010417a:	d3 e2                	shl    %cl,%edx
c010417c:	89 d0                	mov    %edx,%eax
c010417e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104181:	76 d6                	jbe    c0104159 <get_power+0xd>
            return (1 << --i);
c0104183:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0104187:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010418a:	ba 01 00 00 00       	mov    $0x1,%edx
c010418f:	89 c1                	mov    %eax,%ecx
c0104191:	d3 e2                	shl    %cl,%edx
c0104193:	89 d0                	mov    %edx,%eax
c0104195:	90                   	nop
        }
    }
}
c0104196:	c9                   	leave  
c0104197:	c3                   	ret    

c0104198 <default_init>:

static void
default_init(void) {
c0104198:	55                   	push   %ebp
c0104199:	89 e5                	mov    %esp,%ebp
c010419b:	83 ec 10             	sub    $0x10,%esp
c010419e:	c7 45 fc 7c 99 11 c0 	movl   $0xc011997c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01041a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01041ab:	89 50 04             	mov    %edx,0x4(%eax)
c01041ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041b1:	8b 50 04             	mov    0x4(%eax),%edx
c01041b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041b7:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01041b9:	c7 05 84 99 11 c0 00 	movl   $0x0,0xc0119984
c01041c0:	00 00 00 
}
c01041c3:	90                   	nop
c01041c4:	c9                   	leave  
c01041c5:	c3                   	ret    

c01041c6 <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
c01041c6:	55                   	push   %ebp
c01041c7:	89 e5                	mov    %esp,%ebp
c01041c9:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01041cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01041d0:	75 16                	jne    c01041e8 <buddy_init_memmap+0x22>
c01041d2:	68 00 70 10 c0       	push   $0xc0107000
c01041d7:	68 06 70 10 c0       	push   $0xc0107006
c01041dc:	6a 50                	push   $0x50
c01041de:	68 1b 70 10 c0       	push   $0xc010701b
c01041e3:	e8 e9 c1 ff ff       	call   c01003d1 <__panic>
    struct Page *p = base;
c01041e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01041eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01041ee:	e9 a8 00 00 00       	jmp    c010429b <buddy_init_memmap+0xd5>
        assert(PageReserved(p));
c01041f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041f6:	83 c0 04             	add    $0x4,%eax
c01041f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104200:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104203:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104206:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104209:	0f a3 10             	bt     %edx,(%eax)
c010420c:	19 c0                	sbb    %eax,%eax
c010420e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c0104211:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104215:	0f 95 c0             	setne  %al
c0104218:	0f b6 c0             	movzbl %al,%eax
c010421b:	85 c0                	test   %eax,%eax
c010421d:	75 16                	jne    c0104235 <buddy_init_memmap+0x6f>
c010421f:	68 31 70 10 c0       	push   $0xc0107031
c0104224:	68 06 70 10 c0       	push   $0xc0107006
c0104229:	6a 53                	push   $0x53
c010422b:	68 1b 70 10 c0       	push   $0xc010701b
c0104230:	e8 9c c1 ff ff       	call   c01003d1 <__panic>
        ClearPageReserved(p);       //flag : PG_reserve to 0 
c0104235:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104238:	83 c0 04             	add    $0x4,%eax
c010423b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104242:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104245:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104248:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010424b:	0f b3 10             	btr    %edx,(%eax)
        SetPageProperty(p);         //flag : PG_property to 1
c010424e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104251:	83 c0 04             	add    $0x4,%eax
c0104254:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c010425b:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010425e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104261:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104264:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;            //property
c0104267:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010426a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);         //ref
c0104271:	83 ec 08             	sub    $0x8,%esp
c0104274:	6a 00                	push   $0x0
c0104276:	ff 75 f4             	pushl  -0xc(%ebp)
c0104279:	e8 c0 fe ff ff       	call   c010413e <set_page_ref>
c010427e:	83 c4 10             	add    $0x10,%esp
        memset(&(p->page_link), 0, sizeof(list_entry_t));
c0104281:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104284:	83 c0 0c             	add    $0xc,%eax
c0104287:	83 ec 04             	sub    $0x4,%esp
c010428a:	6a 08                	push   $0x8
c010428c:	6a 00                	push   $0x0
c010428e:	50                   	push   %eax
c010428f:	e8 4f 18 00 00       	call   c0105ae3 <memset>
c0104294:	83 c4 10             	add    $0x10,%esp

static void
buddy_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0104297:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010429b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010429e:	89 d0                	mov    %edx,%eax
c01042a0:	c1 e0 02             	shl    $0x2,%eax
c01042a3:	01 d0                	add    %edx,%eax
c01042a5:	c1 e0 02             	shl    $0x2,%eax
c01042a8:	89 c2                	mov    %eax,%edx
c01042aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01042ad:	01 d0                	add    %edx,%eax
c01042af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01042b2:	0f 85 3b ff ff ff    	jne    c01041f3 <buddy_init_memmap+0x2d>
        p->property = 0;            //property
        set_page_ref(p, 0);         //ref
        memset(&(p->page_link), 0, sizeof(list_entry_t));
    }

    struct Page *page = NULL;
c01042b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    size_t power_num = 0;
c01042bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    while (n != 0){
c01042c6:	e9 a9 00 00 00       	jmp    c0104374 <buddy_init_memmap+0x1ae>
        power_num = get_power(n);
c01042cb:	83 ec 0c             	sub    $0xc,%esp
c01042ce:	ff 75 0c             	pushl  0xc(%ebp)
c01042d1:	e8 76 fe ff ff       	call   c010414c <get_power>
c01042d6:	83 c4 10             	add    $0x10,%esp
c01042d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
        page = p + power_num;
c01042dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01042df:	89 d0                	mov    %edx,%eax
c01042e1:	c1 e0 02             	shl    $0x2,%eax
c01042e4:	01 d0                	add    %edx,%eax
c01042e6:	c1 e0 02             	shl    $0x2,%eax
c01042e9:	89 c2                	mov    %eax,%edx
c01042eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042ee:	01 d0                	add    %edx,%eax
c01042f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        p->property = power_num;
c01042f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01042f9:	89 50 08             	mov    %edx,0x8(%eax)
        n = page->property = nr_free - power_num;
c01042fc:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c0104301:	2b 45 e0             	sub    -0x20(%ebp),%eax
c0104304:	89 c2                	mov    %eax,%edx
c0104306:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104309:	89 50 08             	mov    %edx,0x8(%eax)
c010430c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010430f:	8b 40 08             	mov    0x8(%eax),%eax
c0104312:	89 45 0c             	mov    %eax,0xc(%ebp)
        
        list_add_after(&free_list, &(p->page_link));          //samll block to big block
c0104315:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104318:	83 c0 0c             	add    $0xc,%eax
c010431b:	c7 45 ec 7c 99 11 c0 	movl   $0xc011997c,-0x14(%ebp)
c0104322:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104325:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104328:	8b 40 04             	mov    0x4(%eax),%eax
c010432b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010432e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104331:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104334:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104337:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010433a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010433d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104340:	89 10                	mov    %edx,(%eax)
c0104342:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104345:	8b 10                	mov    (%eax),%edx
c0104347:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010434a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010434d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104350:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104353:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104356:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104359:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010435c:	89 10                	mov    %edx,(%eax)
        p = page;
c010435e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104361:	89 45 f4             	mov    %eax,-0xc(%ebp)
        nr_free += power_num;
c0104364:	8b 15 84 99 11 c0    	mov    0xc0119984,%edx
c010436a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010436d:	01 d0                	add    %edx,%eax
c010436f:	a3 84 99 11 c0       	mov    %eax,0xc0119984
        memset(&(p->page_link), 0, sizeof(list_entry_t));
    }

    struct Page *page = NULL;
    size_t power_num = 0;
    while (n != 0){
c0104374:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104378:	0f 85 4d ff ff ff    	jne    c01042cb <buddy_init_memmap+0x105>
        
        list_add_after(&free_list, &(p->page_link));          //samll block to big block
        p = page;
        nr_free += power_num;
    }
    return;
c010437e:	90                   	nop
}
c010437f:	c9                   	leave  
c0104380:	c3                   	ret    

c0104381 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0104381:	55                   	push   %ebp
c0104382:	89 e5                	mov    %esp,%ebp
c0104384:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0104387:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010438b:	75 16                	jne    c01043a3 <default_init_memmap+0x22>
c010438d:	68 00 70 10 c0       	push   $0xc0107000
c0104392:	68 06 70 10 c0       	push   $0xc0107006
c0104397:	6a 6c                	push   $0x6c
c0104399:	68 1b 70 10 c0       	push   $0xc010701b
c010439e:	e8 2e c0 ff ff       	call   c01003d1 <__panic>
    struct Page *p = base;
c01043a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01043a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01043a9:	e9 a8 00 00 00       	jmp    c0104456 <default_init_memmap+0xd5>
        assert(PageReserved(p));
c01043ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043b1:	83 c0 04             	add    $0x4,%eax
c01043b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01043bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01043be:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01043c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01043c4:	0f a3 10             	bt     %edx,(%eax)
c01043c7:	19 c0                	sbb    %eax,%eax
c01043c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
c01043cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01043d0:	0f 95 c0             	setne  %al
c01043d3:	0f b6 c0             	movzbl %al,%eax
c01043d6:	85 c0                	test   %eax,%eax
c01043d8:	75 16                	jne    c01043f0 <default_init_memmap+0x6f>
c01043da:	68 31 70 10 c0       	push   $0xc0107031
c01043df:	68 06 70 10 c0       	push   $0xc0107006
c01043e4:	6a 6f                	push   $0x6f
c01043e6:	68 1b 70 10 c0       	push   $0xc010701b
c01043eb:	e8 e1 bf ff ff       	call   c01003d1 <__panic>
        ClearPageReserved(p);       //flag : PG_reserve to 0 
c01043f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043f3:	83 c0 04             	add    $0x4,%eax
c01043f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01043fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104400:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104403:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104406:	0f b3 10             	btr    %edx,(%eax)
        SetPageProperty(p);         //flag : PG_property to 1
c0104409:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010440c:	83 c0 04             	add    $0x4,%eax
c010440f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0104416:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104419:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010441c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010441f:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;            //property
c0104422:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104425:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);         //ref
c010442c:	83 ec 08             	sub    $0x8,%esp
c010442f:	6a 00                	push   $0x0
c0104431:	ff 75 f4             	pushl  -0xc(%ebp)
c0104434:	e8 05 fd ff ff       	call   c010413e <set_page_ref>
c0104439:	83 c4 10             	add    $0x10,%esp
        memset(&(p->page_link), 0, sizeof(list_entry_t));
c010443c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010443f:	83 c0 0c             	add    $0xc,%eax
c0104442:	83 ec 04             	sub    $0x4,%esp
c0104445:	6a 08                	push   $0x8
c0104447:	6a 00                	push   $0x0
c0104449:	50                   	push   %eax
c010444a:	e8 94 16 00 00       	call   c0105ae3 <memset>
c010444f:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0104452:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104456:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104459:	89 d0                	mov    %edx,%eax
c010445b:	c1 e0 02             	shl    $0x2,%eax
c010445e:	01 d0                	add    %edx,%eax
c0104460:	c1 e0 02             	shl    $0x2,%eax
c0104463:	89 c2                	mov    %eax,%edx
c0104465:	8b 45 08             	mov    0x8(%ebp),%eax
c0104468:	01 d0                	add    %edx,%eax
c010446a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010446d:	0f 85 3b ff ff ff    	jne    c01043ae <default_init_memmap+0x2d>
        SetPageProperty(p);         //flag : PG_property to 1
        p->property = 0;            //property
        set_page_ref(p, 0);         //ref
        memset(&(p->page_link), 0, sizeof(list_entry_t));
    }
    list_add_before(&free_list, &(base->page_link)); //lowAddr-->highAddr page
c0104473:	8b 45 08             	mov    0x8(%ebp),%eax
c0104476:	83 c0 0c             	add    $0xc,%eax
c0104479:	c7 45 ec 7c 99 11 c0 	movl   $0xc011997c,-0x14(%ebp)
c0104480:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104486:	8b 00                	mov    (%eax),%eax
c0104488:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010448b:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010448e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104491:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104494:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104497:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010449a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010449d:	89 10                	mov    %edx,(%eax)
c010449f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01044a2:	8b 10                	mov    (%eax),%edx
c01044a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01044a7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01044aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01044ad:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01044b0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01044b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01044b6:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01044b9:	89 10                	mov    %edx,(%eax)
    base->property = n;
c01044bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01044be:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044c1:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c01044c4:	8b 15 84 99 11 c0    	mov    0xc0119984,%edx
c01044ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044cd:	01 d0                	add    %edx,%eax
c01044cf:	a3 84 99 11 c0       	mov    %eax,0xc0119984
    
    cprintf("nr_free : %d\n", nr_free);
c01044d4:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c01044d9:	83 ec 08             	sub    $0x8,%esp
c01044dc:	50                   	push   %eax
c01044dd:	68 41 70 10 c0       	push   $0xc0107041
c01044e2:	e8 84 bd ff ff       	call   c010026b <cprintf>
c01044e7:	83 c4 10             	add    $0x10,%esp
}
c01044ea:	90                   	nop
c01044eb:	c9                   	leave  
c01044ec:	c3                   	ret    

c01044ed <buddy_alloc_pages>:

/*Buddy system*/
static struct Page *
buddy_alloc_pages(size_t n){
c01044ed:	55                   	push   %ebp
c01044ee:	89 e5                	mov    %esp,%ebp
c01044f0:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01044f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01044f7:	75 19                	jne    c0104512 <buddy_alloc_pages+0x25>
c01044f9:	68 00 70 10 c0       	push   $0xc0107000
c01044fe:	68 06 70 10 c0       	push   $0xc0107006
c0104503:	68 80 00 00 00       	push   $0x80
c0104508:	68 1b 70 10 c0       	push   $0xc010701b
c010450d:	e8 bf be ff ff       	call   c01003d1 <__panic>
    if (n > nr_free) return NULL;
c0104512:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c0104517:	3b 45 08             	cmp    0x8(%ebp),%eax
c010451a:	73 0a                	jae    c0104526 <buddy_alloc_pages+0x39>
c010451c:	b8 00 00 00 00       	mov    $0x0,%eax
c0104521:	e9 8a 01 00 00       	jmp    c01046b0 <buddy_alloc_pages+0x1c3>

    struct Page *page = NULL;
c0104526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c010452d:	c7 45 f0 7c 99 11 c0 	movl   $0xc011997c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list){
c0104534:	eb 1c                	jmp    c0104552 <buddy_alloc_pages+0x65>
        struct Page *p = le2page(le, page_link);
c0104536:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104539:	83 e8 0c             	sub    $0xc,%eax
c010453c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    
        if (p->property >= n){
c010453f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104542:	8b 40 08             	mov    0x8(%eax),%eax
c0104545:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104548:	72 08                	jb     c0104552 <buddy_alloc_pages+0x65>
            page = p;
c010454a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010454d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0104550:	eb 18                	jmp    c010456a <buddy_alloc_pages+0x7d>
c0104552:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104555:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104558:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010455b:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    if (n > nr_free) return NULL;

    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list){
c010455e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104561:	81 7d f0 7c 99 11 c0 	cmpl   $0xc011997c,-0x10(%ebp)
c0104568:	75 cc                	jne    c0104536 <buddy_alloc_pages+0x49>
            page = p;
            break;
        }
    }

    if (page != NULL){
c010456a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010456e:	0f 84 39 01 00 00    	je     c01046ad <buddy_alloc_pages+0x1c0>
        list_del(&(page->page_link));
c0104574:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104577:	83 c0 0c             	add    $0xc,%eax
c010457a:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010457d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104580:	8b 40 04             	mov    0x4(%eax),%eax
c0104583:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104586:	8b 12                	mov    (%edx),%edx
c0104588:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010458b:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010458e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104591:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104594:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104597:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010459a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010459d:	89 10                	mov    %edx,(%eax)

        if (page->property == (n << 1)){
c010459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a2:	8b 40 08             	mov    0x8(%eax),%eax
c01045a5:	8b 55 08             	mov    0x8(%ebp),%edx
c01045a8:	01 d2                	add    %edx,%edx
c01045aa:	39 d0                	cmp    %edx,%eax
c01045ac:	75 7c                	jne    c010462a <buddy_alloc_pages+0x13d>
            struct Page *p = page + n;
c01045ae:	8b 55 08             	mov    0x8(%ebp),%edx
c01045b1:	89 d0                	mov    %edx,%eax
c01045b3:	c1 e0 02             	shl    $0x2,%eax
c01045b6:	01 d0                	add    %edx,%eax
c01045b8:	c1 e0 02             	shl    $0x2,%eax
c01045bb:	89 c2                	mov    %eax,%edx
c01045bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c0:	01 d0                	add    %edx,%eax
c01045c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
            p->property = page->property - n;
c01045c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c8:	8b 40 08             	mov    0x8(%eax),%eax
c01045cb:	2b 45 08             	sub    0x8(%ebp),%eax
c01045ce:	89 c2                	mov    %eax,%edx
c01045d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045d3:	89 50 08             	mov    %edx,0x8(%eax)
            page->property = n;
c01045d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045d9:	8b 55 08             	mov    0x8(%ebp),%edx
c01045dc:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(page->page_link.prev, &(p->page_link));
c01045df:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045e2:	8d 50 0c             	lea    0xc(%eax),%edx
c01045e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045e8:	8b 40 0c             	mov    0xc(%eax),%eax
c01045eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01045ee:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01045f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045f4:	8b 40 04             	mov    0x4(%eax),%eax
c01045f7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01045fa:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01045fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104600:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104603:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104606:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104609:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010460c:	89 10                	mov    %edx,(%eax)
c010460e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104611:	8b 10                	mov    (%eax),%edx
c0104613:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104616:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104619:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010461c:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010461f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104622:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104625:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104628:	89 10                	mov    %edx,(%eax)
        }

        for (int looper = 0; looper < page->property; looper++){
c010462a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104631:	eb 58                	jmp    c010468b <buddy_alloc_pages+0x19e>
            SetPageReserved(&(page[looper]));
c0104633:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104636:	89 d0                	mov    %edx,%eax
c0104638:	c1 e0 02             	shl    $0x2,%eax
c010463b:	01 d0                	add    %edx,%eax
c010463d:	c1 e0 02             	shl    $0x2,%eax
c0104640:	89 c2                	mov    %eax,%edx
c0104642:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104645:	01 d0                	add    %edx,%eax
c0104647:	83 c0 04             	add    $0x4,%eax
c010464a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c0104651:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104654:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104657:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010465a:	0f ab 10             	bts    %edx,(%eax)
            ClearPageProperty(&(page[looper]));
c010465d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104660:	89 d0                	mov    %edx,%eax
c0104662:	c1 e0 02             	shl    $0x2,%eax
c0104665:	01 d0                	add    %edx,%eax
c0104667:	c1 e0 02             	shl    $0x2,%eax
c010466a:	89 c2                	mov    %eax,%edx
c010466c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010466f:	01 d0                	add    %edx,%eax
c0104671:	83 c0 04             	add    $0x4,%eax
c0104674:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c010467b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010467e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104681:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104684:	0f b3 10             	btr    %edx,(%eax)
            p->property = page->property - n;
            page->property = n;
            list_add_after(page->page_link.prev, &(p->page_link));
        }

        for (int looper = 0; looper < page->property; looper++){
c0104687:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010468b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010468e:	8b 50 08             	mov    0x8(%eax),%edx
c0104691:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104694:	39 c2                	cmp    %eax,%edx
c0104696:	77 9b                	ja     c0104633 <buddy_alloc_pages+0x146>
            SetPageReserved(&(page[looper]));
            ClearPageProperty(&(page[looper]));
        }
        
        nr_free -= page->property;
c0104698:	8b 15 84 99 11 c0    	mov    0xc0119984,%edx
c010469e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a1:	8b 40 08             	mov    0x8(%eax),%eax
c01046a4:	29 c2                	sub    %eax,%edx
c01046a6:	89 d0                	mov    %edx,%eax
c01046a8:	a3 84 99 11 c0       	mov    %eax,0xc0119984
    }

    return page;
c01046ad:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
c01046b0:	c9                   	leave  
c01046b1:	c3                   	ret    

c01046b2 <default_alloc_pages>:
/*first fit 返回PA*/
static struct Page *
default_alloc_pages(size_t n) {
c01046b2:	55                   	push   %ebp
c01046b3:	89 e5                	mov    %esp,%ebp
c01046b5:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01046b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01046bc:	75 19                	jne    c01046d7 <default_alloc_pages+0x25>
c01046be:	68 00 70 10 c0       	push   $0xc0107000
c01046c3:	68 06 70 10 c0       	push   $0xc0107006
c01046c8:	68 a6 00 00 00       	push   $0xa6
c01046cd:	68 1b 70 10 c0       	push   $0xc010701b
c01046d2:	e8 fa bc ff ff       	call   c01003d1 <__panic>
    if (n > nr_free) {
c01046d7:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c01046dc:	3b 45 08             	cmp    0x8(%ebp),%eax
c01046df:	73 0a                	jae    c01046eb <default_alloc_pages+0x39>
        return NULL;
c01046e1:	b8 00 00 00 00       	mov    $0x0,%eax
c01046e6:	e9 79 01 00 00       	jmp    c0104864 <default_alloc_pages+0x1b2>
    }
    struct Page *page = NULL;
c01046eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01046f2:	c7 45 f0 7c 99 11 c0 	movl   $0xc011997c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01046f9:	eb 1c                	jmp    c0104717 <default_alloc_pages+0x65>
        struct Page *p = le2page(le, page_link);
c01046fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046fe:	83 e8 0c             	sub    $0xc,%eax
c0104701:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n) {
c0104704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104707:	8b 40 08             	mov    0x8(%eax),%eax
c010470a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010470d:	72 08                	jb     c0104717 <default_alloc_pages+0x65>
            page = p;
c010470f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104712:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0104715:	eb 18                	jmp    c010472f <default_alloc_pages+0x7d>
c0104717:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010471a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010471d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104720:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104723:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104726:	81 7d f0 7c 99 11 c0 	cmpl   $0xc011997c,-0x10(%ebp)
c010472d:	75 cc                	jne    c01046fb <default_alloc_pages+0x49>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c010472f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104733:	0f 84 28 01 00 00    	je     c0104861 <default_alloc_pages+0x1af>
        list_del(&(page->page_link));
c0104739:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010473c:	83 c0 0c             	add    $0xc,%eax
c010473f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104742:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104745:	8b 40 04             	mov    0x4(%eax),%eax
c0104748:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010474b:	8b 12                	mov    (%edx),%edx
c010474d:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0104750:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104753:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104756:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104759:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010475c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010475f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104762:	89 10                	mov    %edx,(%eax)
       
        if (page->property > n) {
c0104764:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104767:	8b 40 08             	mov    0x8(%eax),%eax
c010476a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010476d:	76 73                	jbe    c01047e2 <default_alloc_pages+0x130>
            struct Page *p = page + n;
c010476f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104772:	89 d0                	mov    %edx,%eax
c0104774:	c1 e0 02             	shl    $0x2,%eax
c0104777:	01 d0                	add    %edx,%eax
c0104779:	c1 e0 02             	shl    $0x2,%eax
c010477c:	89 c2                	mov    %eax,%edx
c010477e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104781:	01 d0                	add    %edx,%eax
c0104783:	89 45 dc             	mov    %eax,-0x24(%ebp)
            p->property = page->property - n;
c0104786:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104789:	8b 40 08             	mov    0x8(%eax),%eax
c010478c:	2b 45 08             	sub    0x8(%ebp),%eax
c010478f:	89 c2                	mov    %eax,%edx
c0104791:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104794:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(page->page_link.prev, &(p->page_link));
c0104797:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010479a:	8d 50 0c             	lea    0xc(%eax),%edx
c010479d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047a0:	8b 40 0c             	mov    0xc(%eax),%eax
c01047a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01047a6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01047a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047ac:	8b 40 04             	mov    0x4(%eax),%eax
c01047af:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01047b2:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01047b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01047b8:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01047bb:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01047be:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01047c1:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01047c4:	89 10                	mov    %edx,(%eax)
c01047c6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01047c9:	8b 10                	mov    (%eax),%edx
c01047cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01047ce:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01047d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01047d4:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01047d7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01047da:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01047dd:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01047e0:	89 10                	mov    %edx,(%eax)
        }
        
        page->property = n;
c01047e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e5:	8b 55 08             	mov    0x8(%ebp),%edx
c01047e8:	89 50 08             	mov    %edx,0x8(%eax)
        for (int looper = 0; looper < n; looper++){
c01047eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01047f2:	eb 58                	jmp    c010484c <default_alloc_pages+0x19a>
            SetPageReserved(&(page[looper]));
c01047f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01047f7:	89 d0                	mov    %edx,%eax
c01047f9:	c1 e0 02             	shl    $0x2,%eax
c01047fc:	01 d0                	add    %edx,%eax
c01047fe:	c1 e0 02             	shl    $0x2,%eax
c0104801:	89 c2                	mov    %eax,%edx
c0104803:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104806:	01 d0                	add    %edx,%eax
c0104808:	83 c0 04             	add    $0x4,%eax
c010480b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c0104812:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104815:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010481b:	0f ab 10             	bts    %edx,(%eax)
            ClearPageProperty(&(page[looper]));
c010481e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104821:	89 d0                	mov    %edx,%eax
c0104823:	c1 e0 02             	shl    $0x2,%eax
c0104826:	01 d0                	add    %edx,%eax
c0104828:	c1 e0 02             	shl    $0x2,%eax
c010482b:	89 c2                	mov    %eax,%edx
c010482d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104830:	01 d0                	add    %edx,%eax
c0104832:	83 c0 04             	add    $0x4,%eax
c0104835:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c010483c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010483f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104842:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104845:	0f b3 10             	btr    %edx,(%eax)
            p->property = page->property - n;
            list_add_after(page->page_link.prev, &(p->page_link));
        }
        
        page->property = n;
        for (int looper = 0; looper < n; looper++){
c0104848:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010484c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010484f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104852:	72 a0                	jb     c01047f4 <default_alloc_pages+0x142>
            SetPageReserved(&(page[looper]));
            ClearPageProperty(&(page[looper]));
            // page_ref_inc(&(page[looper]));
        }
        
        nr_free -= n;
c0104854:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c0104859:	2b 45 08             	sub    0x8(%ebp),%eax
c010485c:	a3 84 99 11 c0       	mov    %eax,0xc0119984
    }
    return page;
c0104861:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104864:	c9                   	leave  
c0104865:	c3                   	ret    

c0104866 <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n) {
c0104866:	55                   	push   %ebp
c0104867:	89 e5                	mov    %esp,%ebp
c0104869:	83 ec 48             	sub    $0x48,%esp
    assert(n % 2 == 0);
c010486c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010486f:	83 e0 01             	and    $0x1,%eax
c0104872:	85 c0                	test   %eax,%eax
c0104874:	74 19                	je     c010488f <buddy_free_pages+0x29>
c0104876:	68 4f 70 10 c0       	push   $0xc010704f
c010487b:	68 06 70 10 c0       	push   $0xc0107006
c0104880:	68 ca 00 00 00       	push   $0xca
c0104885:	68 1b 70 10 c0       	push   $0xc010701b
c010488a:	e8 42 bb ff ff       	call   c01003d1 <__panic>
    struct Page *p = base;
c010488f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104892:	89 45 f4             	mov    %eax,-0xc(%ebp)

    for (; p != base + n; p ++) {
c0104895:	e9 b7 00 00 00       	jmp    c0104951 <buddy_free_pages+0xeb>
        assert(PageReserved(p) && !PageProperty(p));
c010489a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010489d:	83 c0 04             	add    $0x4,%eax
c01048a0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
c01048a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01048aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01048ad:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01048b0:	0f a3 10             	bt     %edx,(%eax)
c01048b3:	19 c0                	sbb    %eax,%eax
c01048b5:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01048b8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01048bc:	0f 95 c0             	setne  %al
c01048bf:	0f b6 c0             	movzbl %al,%eax
c01048c2:	85 c0                	test   %eax,%eax
c01048c4:	74 2c                	je     c01048f2 <buddy_free_pages+0x8c>
c01048c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048c9:	83 c0 04             	add    $0x4,%eax
c01048cc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01048d3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01048d6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01048d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01048dc:	0f a3 10             	bt     %edx,(%eax)
c01048df:	19 c0                	sbb    %eax,%eax
c01048e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return oldbit != 0;
c01048e4:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01048e8:	0f 95 c0             	setne  %al
c01048eb:	0f b6 c0             	movzbl %al,%eax
c01048ee:	85 c0                	test   %eax,%eax
c01048f0:	74 19                	je     c010490b <buddy_free_pages+0xa5>
c01048f2:	68 5c 70 10 c0       	push   $0xc010705c
c01048f7:	68 06 70 10 c0       	push   $0xc0107006
c01048fc:	68 ce 00 00 00       	push   $0xce
c0104901:	68 1b 70 10 c0       	push   $0xc010701b
c0104906:	e8 c6 ba ff ff       	call   c01003d1 <__panic>
        SetPageProperty(p);
c010490b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010490e:	83 c0 04             	add    $0x4,%eax
c0104911:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0104918:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010491b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010491e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104921:	0f ab 10             	bts    %edx,(%eax)
        ClearPageReserved(p);
c0104924:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104927:	83 c0 04             	add    $0x4,%eax
c010492a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104931:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104934:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104937:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010493a:	0f b3 10             	btr    %edx,(%eax)
        set_page_ref(p, 0);
c010493d:	83 ec 08             	sub    $0x8,%esp
c0104940:	6a 00                	push   $0x0
c0104942:	ff 75 f4             	pushl  -0xc(%ebp)
c0104945:	e8 f4 f7 ff ff       	call   c010413e <set_page_ref>
c010494a:	83 c4 10             	add    $0x10,%esp
static void
buddy_free_pages(struct Page *base, size_t n) {
    assert(n % 2 == 0);
    struct Page *p = base;

    for (; p != base + n; p ++) {
c010494d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104951:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104954:	89 d0                	mov    %edx,%eax
c0104956:	c1 e0 02             	shl    $0x2,%eax
c0104959:	01 d0                	add    %edx,%eax
c010495b:	c1 e0 02             	shl    $0x2,%eax
c010495e:	89 c2                	mov    %eax,%edx
c0104960:	8b 45 08             	mov    0x8(%ebp),%eax
c0104963:	01 d0                	add    %edx,%eax
c0104965:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104968:	0f 85 2c ff ff ff    	jne    c010489a <buddy_free_pages+0x34>
        assert(PageReserved(p) && !PageProperty(p));
        SetPageProperty(p);
        ClearPageReserved(p);
        set_page_ref(p, 0);
    }
    base->property = n;
c010496e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104971:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104974:	89 50 08             	mov    %edx,0x8(%eax)
c0104977:	c7 45 dc 7c 99 11 c0 	movl   $0xc011997c,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010497e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104981:	8b 40 04             	mov    0x4(%eax),%eax

    list_entry_t *le = list_next(&free_list);
c0104984:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *last = NULL, *next = 0xFFFFFFFF;
c0104987:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010498e:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    while (le != &free_list) {
c0104995:	eb 44                	jmp    c01049db <buddy_free_pages+0x175>
        p = le2page(le, page_link);
c0104997:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010499a:	83 e8 0c             	sub    $0xc,%eax
c010499d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01049a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01049a9:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01049ac:	89 45 f0             	mov    %eax,-0x10(%ebp)

        if (p < base && p >= last ) last = p;
c01049af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049b2:	3b 45 08             	cmp    0x8(%ebp),%eax
c01049b5:	73 0e                	jae    c01049c5 <buddy_free_pages+0x15f>
c01049b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01049bd:	72 06                	jb     c01049c5 <buddy_free_pages+0x15f>
c01049bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p > base && p <= next) next = p;
c01049c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049c8:	3b 45 08             	cmp    0x8(%ebp),%eax
c01049cb:	76 0e                	jbe    c01049db <buddy_free_pages+0x175>
c01049cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c01049d3:	77 06                	ja     c01049db <buddy_free_pages+0x175>
c01049d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    }
    base->property = n;

    list_entry_t *le = list_next(&free_list);
    struct Page *last = NULL, *next = 0xFFFFFFFF;
    while (le != &free_list) {
c01049db:	81 7d f0 7c 99 11 c0 	cmpl   $0xc011997c,-0x10(%ebp)
c01049e2:	75 b3                	jne    c0104997 <buddy_free_pages+0x131>

        if (p < base && p >= last ) last = p;
        if (p > base && p <= next) next = p;
    }
    
}
c01049e4:	90                   	nop
c01049e5:	c9                   	leave  
c01049e6:	c3                   	ret    

c01049e7 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01049e7:	55                   	push   %ebp
c01049e8:	89 e5                	mov    %esp,%ebp
c01049ea:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    cprintf("   prev = %p,\n", base->page_link.prev);
    cprintf("   next = %p\n", base->page_link.next);
    cprintf("  },\n");
    cprintf("}\n");
#endif
    assert(n > 0);
c01049f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01049f4:	75 19                	jne    c0104a0f <default_free_pages+0x28>
c01049f6:	68 00 70 10 c0       	push   $0xc0107000
c01049fb:	68 06 70 10 c0       	push   $0xc0107006
c0104a00:	68 ef 00 00 00       	push   $0xef
c0104a05:	68 1b 70 10 c0       	push   $0xc010701b
c0104a0a:	e8 c2 b9 ff ff       	call   c01003d1 <__panic>
    struct Page *p = base;
c0104a0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104a15:	e9 b7 00 00 00       	jmp    c0104ad1 <default_free_pages+0xea>
        assert(PageReserved(p) && !PageProperty(p));
c0104a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a1d:	83 c0 04             	add    $0x4,%eax
c0104a20:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
c0104a27:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104a2a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104a2d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104a30:	0f a3 10             	bt     %edx,(%eax)
c0104a33:	19 c0                	sbb    %eax,%eax
c0104a35:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
c0104a38:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
c0104a3c:	0f 95 c0             	setne  %al
c0104a3f:	0f b6 c0             	movzbl %al,%eax
c0104a42:	85 c0                	test   %eax,%eax
c0104a44:	74 2c                	je     c0104a72 <default_free_pages+0x8b>
c0104a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a49:	83 c0 04             	add    $0x4,%eax
c0104a4c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0104a53:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104a56:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104a59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a5c:	0f a3 10             	bt     %edx,(%eax)
c0104a5f:	19 c0                	sbb    %eax,%eax
c0104a61:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0104a64:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0104a68:	0f 95 c0             	setne  %al
c0104a6b:	0f b6 c0             	movzbl %al,%eax
c0104a6e:	85 c0                	test   %eax,%eax
c0104a70:	74 19                	je     c0104a8b <default_free_pages+0xa4>
c0104a72:	68 5c 70 10 c0       	push   $0xc010705c
c0104a77:	68 06 70 10 c0       	push   $0xc0107006
c0104a7c:	68 f2 00 00 00       	push   $0xf2
c0104a81:	68 1b 70 10 c0       	push   $0xc010701b
c0104a86:	e8 46 b9 ff ff       	call   c01003d1 <__panic>
        SetPageProperty(p);
c0104a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a8e:	83 c0 04             	add    $0x4,%eax
c0104a91:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0104a98:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104a9b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104a9e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104aa1:	0f ab 10             	bts    %edx,(%eax)
        ClearPageReserved(p);
c0104aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aa7:	83 c0 04             	add    $0x4,%eax
c0104aaa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104ab1:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104ab4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104ab7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104aba:	0f b3 10             	btr    %edx,(%eax)
        set_page_ref(p, 0);
c0104abd:	83 ec 08             	sub    $0x8,%esp
c0104ac0:	6a 00                	push   $0x0
c0104ac2:	ff 75 f4             	pushl  -0xc(%ebp)
c0104ac5:	e8 74 f6 ff ff       	call   c010413e <set_page_ref>
c0104aca:	83 c4 10             	add    $0x10,%esp
    cprintf("  },\n");
    cprintf("}\n");
#endif
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0104acd:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104ad4:	89 d0                	mov    %edx,%eax
c0104ad6:	c1 e0 02             	shl    $0x2,%eax
c0104ad9:	01 d0                	add    %edx,%eax
c0104adb:	c1 e0 02             	shl    $0x2,%eax
c0104ade:	89 c2                	mov    %eax,%edx
c0104ae0:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ae3:	01 d0                	add    %edx,%eax
c0104ae5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ae8:	0f 85 2c ff ff ff    	jne    c0104a1a <default_free_pages+0x33>
        assert(PageReserved(p) && !PageProperty(p));
        SetPageProperty(p);
        ClearPageReserved(p);
        set_page_ref(p, 0);
    }
    base->property = n;
c0104aee:	8b 45 08             	mov    0x8(%ebp),%eax
c0104af1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104af4:	89 50 08             	mov    %edx,0x8(%eax)
c0104af7:	c7 45 dc 7c 99 11 c0 	movl   $0xc011997c,-0x24(%ebp)
c0104afe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b01:	8b 40 04             	mov    0x4(%eax),%eax
    
    list_entry_t *le = list_next(&free_list);
c0104b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *last = NULL, *next = 0xFFFFFFFF;
c0104b07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104b0e:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    while (le != &free_list) {
c0104b15:	eb 44                	jmp    c0104b5b <default_free_pages+0x174>
        p = le2page(le, page_link);
c0104b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b1a:	83 e8 0c             	sub    $0xc,%eax
c0104b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b23:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0104b26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104b29:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0104b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)

        if (p < base && p >= last ) last = p;
c0104b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b32:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104b35:	73 0e                	jae    c0104b45 <default_free_pages+0x15e>
c0104b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b3a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104b3d:	72 06                	jb     c0104b45 <default_free_pages+0x15e>
c0104b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b42:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p > base && p <= next) next = p;
c0104b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b48:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104b4b:	76 0e                	jbe    c0104b5b <default_free_pages+0x174>
c0104b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b50:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0104b53:	77 06                	ja     c0104b5b <default_free_pages+0x174>
c0104b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b58:	89 45 e8             	mov    %eax,-0x18(%ebp)
    }
    base->property = n;
    
    list_entry_t *le = list_next(&free_list);
    struct Page *last = NULL, *next = 0xFFFFFFFF;
    while (le != &free_list) {
c0104b5b:	81 7d f0 7c 99 11 c0 	cmpl   $0xc011997c,-0x10(%ebp)
c0104b62:	75 b3                	jne    c0104b17 <default_free_pages+0x130>

        if (p < base && p >= last ) last = p;
        if (p > base && p <= next) next = p;
    }

    if (last < base && last != NULL){
c0104b64:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b67:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104b6a:	0f 83 c0 00 00 00    	jae    c0104c30 <default_free_pages+0x249>
c0104b70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104b74:	0f 84 b6 00 00 00    	je     c0104c30 <default_free_pages+0x249>
        list_add_after(&(last->page_link), &(base->page_link));
c0104b7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b7d:	83 c0 0c             	add    $0xc,%eax
c0104b80:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104b83:	83 c2 0c             	add    $0xc,%edx
c0104b86:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104b89:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104b8c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b8f:	8b 40 04             	mov    0x4(%eax),%eax
c0104b92:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104b95:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0104b98:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104b9b:	89 55 98             	mov    %edx,-0x68(%ebp)
c0104b9e:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104ba1:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104ba4:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104ba7:	89 10                	mov    %edx,(%eax)
c0104ba9:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104bac:	8b 10                	mov    (%eax),%edx
c0104bae:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104bb1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104bb4:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104bb7:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104bba:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104bbd:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104bc0:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104bc3:	89 10                	mov    %edx,(%eax)
        if ((last + last->property) == base){
c0104bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bc8:	8b 50 08             	mov    0x8(%eax),%edx
c0104bcb:	89 d0                	mov    %edx,%eax
c0104bcd:	c1 e0 02             	shl    $0x2,%eax
c0104bd0:	01 d0                	add    %edx,%eax
c0104bd2:	c1 e0 02             	shl    $0x2,%eax
c0104bd5:	89 c2                	mov    %eax,%edx
c0104bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bda:	01 d0                	add    %edx,%eax
c0104bdc:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104bdf:	75 4f                	jne    c0104c30 <default_free_pages+0x249>
            last->property += base->property;
c0104be1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104be4:	8b 50 08             	mov    0x8(%eax),%edx
c0104be7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bea:	8b 40 08             	mov    0x8(%eax),%eax
c0104bed:	01 c2                	add    %eax,%edx
c0104bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bf2:	89 50 08             	mov    %edx,0x8(%eax)
            list_del(&(base->page_link));
c0104bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bf8:	83 c0 0c             	add    $0xc,%eax
c0104bfb:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104bfe:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104c01:	8b 40 04             	mov    0x4(%eax),%eax
c0104c04:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104c07:	8b 12                	mov    (%edx),%edx
c0104c09:	89 55 90             	mov    %edx,-0x70(%ebp)
c0104c0c:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104c0f:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104c12:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104c15:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104c18:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104c1b:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104c1e:	89 10                	mov    %edx,(%eax)
            base->property = 0;
c0104c20:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            base = last;
c0104c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c2d:	89 45 08             	mov    %eax,0x8(%ebp)
        }
    }

    if (base < next && next != 0xFFFFFFFF){
c0104c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c33:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0104c36:	0f 83 e5 00 00 00    	jae    c0104d21 <default_free_pages+0x33a>
c0104c3c:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
c0104c40:	0f 84 db 00 00 00    	je     c0104d21 <default_free_pages+0x33a>
        if (last > base || last == NULL)
c0104c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c49:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104c4c:	77 06                	ja     c0104c54 <default_free_pages+0x26d>
c0104c4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104c52:	75 56                	jne    c0104caa <default_free_pages+0x2c3>
            list_add_before(&(next->page_link), &(base->page_link));
c0104c54:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c57:	83 c0 0c             	add    $0xc,%eax
c0104c5a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104c5d:	83 c2 0c             	add    $0xc,%edx
c0104c60:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0104c63:	89 45 88             	mov    %eax,-0x78(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104c66:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104c69:	8b 00                	mov    (%eax),%eax
c0104c6b:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104c6e:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104c71:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104c74:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104c77:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104c7d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104c83:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104c86:	89 10                	mov    %edx,(%eax)
c0104c88:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104c8e:	8b 10                	mov    (%eax),%edx
c0104c90:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104c93:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104c96:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104c99:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0104c9f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104ca2:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104ca5:	8b 55 80             	mov    -0x80(%ebp),%edx
c0104ca8:	89 10                	mov    %edx,(%eax)
        if ((base + base->property) == next){
c0104caa:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cad:	8b 50 08             	mov    0x8(%eax),%edx
c0104cb0:	89 d0                	mov    %edx,%eax
c0104cb2:	c1 e0 02             	shl    $0x2,%eax
c0104cb5:	01 d0                	add    %edx,%eax
c0104cb7:	c1 e0 02             	shl    $0x2,%eax
c0104cba:	89 c2                	mov    %eax,%edx
c0104cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cbf:	01 d0                	add    %edx,%eax
c0104cc1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0104cc4:	75 5b                	jne    c0104d21 <default_free_pages+0x33a>
            base->property += next->property;
c0104cc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cc9:	8b 50 08             	mov    0x8(%eax),%edx
c0104ccc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ccf:	8b 40 08             	mov    0x8(%eax),%eax
c0104cd2:	01 c2                	add    %eax,%edx
c0104cd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cd7:	89 50 08             	mov    %edx,0x8(%eax)
            list_del(&(next->page_link));
c0104cda:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cdd:	83 c0 0c             	add    $0xc,%eax
c0104ce0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104ce3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104ce6:	8b 40 04             	mov    0x4(%eax),%eax
c0104ce9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104cec:	8b 12                	mov    (%edx),%edx
c0104cee:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
c0104cf4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104cfa:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0104d00:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c0104d06:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104d09:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0104d0f:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c0104d15:	89 10                	mov    %edx,(%eax)
            next->property = 0;
c0104d17:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d1a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        }
    }

    if (last == NULL && next == 0xFFFFFFFF){
c0104d21:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104d25:	75 76                	jne    c0104d9d <default_free_pages+0x3b6>
c0104d27:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
c0104d2b:	75 70                	jne    c0104d9d <default_free_pages+0x3b6>
        list_add_after(&free_list, &(base->page_link));
c0104d2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d30:	83 c0 0c             	add    $0xc,%eax
c0104d33:	c7 45 c0 7c 99 11 c0 	movl   $0xc011997c,-0x40(%ebp)
c0104d3a:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104d40:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104d43:	8b 40 04             	mov    0x4(%eax),%eax
c0104d46:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c0104d4c:	89 95 6c ff ff ff    	mov    %edx,-0x94(%ebp)
c0104d52:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104d55:	89 95 68 ff ff ff    	mov    %edx,-0x98(%ebp)
c0104d5b:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104d61:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
c0104d67:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c0104d6d:	89 10                	mov    %edx,(%eax)
c0104d6f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
c0104d75:	8b 10                	mov    (%eax),%edx
c0104d77:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c0104d7d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104d80:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0104d86:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
c0104d8c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104d8f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0104d95:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
c0104d9b:	89 10                	mov    %edx,(%eax)
    }
    
    nr_free += n;
c0104d9d:	8b 15 84 99 11 c0    	mov    0xc0119984,%edx
c0104da3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104da6:	01 d0                	add    %edx,%eax
c0104da8:	a3 84 99 11 c0       	mov    %eax,0xc0119984
}
c0104dad:	90                   	nop
c0104dae:	c9                   	leave  
c0104daf:	c3                   	ret    

c0104db0 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104db0:	55                   	push   %ebp
c0104db1:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104db3:	a1 84 99 11 c0       	mov    0xc0119984,%eax
}
c0104db8:	5d                   	pop    %ebp
c0104db9:	c3                   	ret    

c0104dba <basic_check>:

static void
basic_check(void) {
c0104dba:	55                   	push   %ebp
c0104dbb:	89 e5                	mov    %esp,%ebp
c0104dbd:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104dd3:	83 ec 0c             	sub    $0xc,%esp
c0104dd6:	6a 01                	push   $0x1
c0104dd8:	e8 fe dd ff ff       	call   c0102bdb <alloc_pages>
c0104ddd:	83 c4 10             	add    $0x10,%esp
c0104de0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104de3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104de7:	75 19                	jne    c0104e02 <basic_check+0x48>
c0104de9:	68 80 70 10 c0       	push   $0xc0107080
c0104dee:	68 06 70 10 c0       	push   $0xc0107006
c0104df3:	68 27 01 00 00       	push   $0x127
c0104df8:	68 1b 70 10 c0       	push   $0xc010701b
c0104dfd:	e8 cf b5 ff ff       	call   c01003d1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104e02:	83 ec 0c             	sub    $0xc,%esp
c0104e05:	6a 01                	push   $0x1
c0104e07:	e8 cf dd ff ff       	call   c0102bdb <alloc_pages>
c0104e0c:	83 c4 10             	add    $0x10,%esp
c0104e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e16:	75 19                	jne    c0104e31 <basic_check+0x77>
c0104e18:	68 9c 70 10 c0       	push   $0xc010709c
c0104e1d:	68 06 70 10 c0       	push   $0xc0107006
c0104e22:	68 28 01 00 00       	push   $0x128
c0104e27:	68 1b 70 10 c0       	push   $0xc010701b
c0104e2c:	e8 a0 b5 ff ff       	call   c01003d1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104e31:	83 ec 0c             	sub    $0xc,%esp
c0104e34:	6a 01                	push   $0x1
c0104e36:	e8 a0 dd ff ff       	call   c0102bdb <alloc_pages>
c0104e3b:	83 c4 10             	add    $0x10,%esp
c0104e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e45:	75 19                	jne    c0104e60 <basic_check+0xa6>
c0104e47:	68 b8 70 10 c0       	push   $0xc01070b8
c0104e4c:	68 06 70 10 c0       	push   $0xc0107006
c0104e51:	68 29 01 00 00       	push   $0x129
c0104e56:	68 1b 70 10 c0       	push   $0xc010701b
c0104e5b:	e8 71 b5 ff ff       	call   c01003d1 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e63:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104e66:	74 10                	je     c0104e78 <basic_check+0xbe>
c0104e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e6b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104e6e:	74 08                	je     c0104e78 <basic_check+0xbe>
c0104e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e73:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104e76:	75 19                	jne    c0104e91 <basic_check+0xd7>
c0104e78:	68 d4 70 10 c0       	push   $0xc01070d4
c0104e7d:	68 06 70 10 c0       	push   $0xc0107006
c0104e82:	68 2b 01 00 00       	push   $0x12b
c0104e87:	68 1b 70 10 c0       	push   $0xc010701b
c0104e8c:	e8 40 b5 ff ff       	call   c01003d1 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104e91:	83 ec 0c             	sub    $0xc,%esp
c0104e94:	ff 75 ec             	pushl  -0x14(%ebp)
c0104e97:	e8 98 f2 ff ff       	call   c0104134 <page_ref>
c0104e9c:	83 c4 10             	add    $0x10,%esp
c0104e9f:	85 c0                	test   %eax,%eax
c0104ea1:	75 24                	jne    c0104ec7 <basic_check+0x10d>
c0104ea3:	83 ec 0c             	sub    $0xc,%esp
c0104ea6:	ff 75 f0             	pushl  -0x10(%ebp)
c0104ea9:	e8 86 f2 ff ff       	call   c0104134 <page_ref>
c0104eae:	83 c4 10             	add    $0x10,%esp
c0104eb1:	85 c0                	test   %eax,%eax
c0104eb3:	75 12                	jne    c0104ec7 <basic_check+0x10d>
c0104eb5:	83 ec 0c             	sub    $0xc,%esp
c0104eb8:	ff 75 f4             	pushl  -0xc(%ebp)
c0104ebb:	e8 74 f2 ff ff       	call   c0104134 <page_ref>
c0104ec0:	83 c4 10             	add    $0x10,%esp
c0104ec3:	85 c0                	test   %eax,%eax
c0104ec5:	74 19                	je     c0104ee0 <basic_check+0x126>
c0104ec7:	68 f8 70 10 c0       	push   $0xc01070f8
c0104ecc:	68 06 70 10 c0       	push   $0xc0107006
c0104ed1:	68 2c 01 00 00       	push   $0x12c
c0104ed6:	68 1b 70 10 c0       	push   $0xc010701b
c0104edb:	e8 f1 b4 ff ff       	call   c01003d1 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104ee0:	83 ec 0c             	sub    $0xc,%esp
c0104ee3:	ff 75 ec             	pushl  -0x14(%ebp)
c0104ee6:	e8 36 f2 ff ff       	call   c0104121 <page2pa>
c0104eeb:	83 c4 10             	add    $0x10,%esp
c0104eee:	89 c2                	mov    %eax,%edx
c0104ef0:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0104ef5:	c1 e0 0c             	shl    $0xc,%eax
c0104ef8:	39 c2                	cmp    %eax,%edx
c0104efa:	72 19                	jb     c0104f15 <basic_check+0x15b>
c0104efc:	68 34 71 10 c0       	push   $0xc0107134
c0104f01:	68 06 70 10 c0       	push   $0xc0107006
c0104f06:	68 2e 01 00 00       	push   $0x12e
c0104f0b:	68 1b 70 10 c0       	push   $0xc010701b
c0104f10:	e8 bc b4 ff ff       	call   c01003d1 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104f15:	83 ec 0c             	sub    $0xc,%esp
c0104f18:	ff 75 f0             	pushl  -0x10(%ebp)
c0104f1b:	e8 01 f2 ff ff       	call   c0104121 <page2pa>
c0104f20:	83 c4 10             	add    $0x10,%esp
c0104f23:	89 c2                	mov    %eax,%edx
c0104f25:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0104f2a:	c1 e0 0c             	shl    $0xc,%eax
c0104f2d:	39 c2                	cmp    %eax,%edx
c0104f2f:	72 19                	jb     c0104f4a <basic_check+0x190>
c0104f31:	68 51 71 10 c0       	push   $0xc0107151
c0104f36:	68 06 70 10 c0       	push   $0xc0107006
c0104f3b:	68 2f 01 00 00       	push   $0x12f
c0104f40:	68 1b 70 10 c0       	push   $0xc010701b
c0104f45:	e8 87 b4 ff ff       	call   c01003d1 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104f4a:	83 ec 0c             	sub    $0xc,%esp
c0104f4d:	ff 75 f4             	pushl  -0xc(%ebp)
c0104f50:	e8 cc f1 ff ff       	call   c0104121 <page2pa>
c0104f55:	83 c4 10             	add    $0x10,%esp
c0104f58:	89 c2                	mov    %eax,%edx
c0104f5a:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0104f5f:	c1 e0 0c             	shl    $0xc,%eax
c0104f62:	39 c2                	cmp    %eax,%edx
c0104f64:	72 19                	jb     c0104f7f <basic_check+0x1c5>
c0104f66:	68 6e 71 10 c0       	push   $0xc010716e
c0104f6b:	68 06 70 10 c0       	push   $0xc0107006
c0104f70:	68 30 01 00 00       	push   $0x130
c0104f75:	68 1b 70 10 c0       	push   $0xc010701b
c0104f7a:	e8 52 b4 ff ff       	call   c01003d1 <__panic>

    list_entry_t free_list_store = free_list;
c0104f7f:	a1 7c 99 11 c0       	mov    0xc011997c,%eax
c0104f84:	8b 15 80 99 11 c0    	mov    0xc0119980,%edx
c0104f8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104f8d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104f90:	c7 45 e4 7c 99 11 c0 	movl   $0xc011997c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104f9d:	89 50 04             	mov    %edx,0x4(%eax)
c0104fa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fa3:	8b 50 04             	mov    0x4(%eax),%edx
c0104fa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fa9:	89 10                	mov    %edx,(%eax)
c0104fab:	c7 45 d8 7c 99 11 c0 	movl   $0xc011997c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104fb2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104fb5:	8b 40 04             	mov    0x4(%eax),%eax
c0104fb8:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104fbb:	0f 94 c0             	sete   %al
c0104fbe:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104fc1:	85 c0                	test   %eax,%eax
c0104fc3:	75 19                	jne    c0104fde <basic_check+0x224>
c0104fc5:	68 8b 71 10 c0       	push   $0xc010718b
c0104fca:	68 06 70 10 c0       	push   $0xc0107006
c0104fcf:	68 34 01 00 00       	push   $0x134
c0104fd4:	68 1b 70 10 c0       	push   $0xc010701b
c0104fd9:	e8 f3 b3 ff ff       	call   c01003d1 <__panic>

    unsigned int nr_free_store = nr_free;
c0104fde:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c0104fe3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0104fe6:	c7 05 84 99 11 c0 00 	movl   $0x0,0xc0119984
c0104fed:	00 00 00 

    assert(alloc_page() == NULL);
c0104ff0:	83 ec 0c             	sub    $0xc,%esp
c0104ff3:	6a 01                	push   $0x1
c0104ff5:	e8 e1 db ff ff       	call   c0102bdb <alloc_pages>
c0104ffa:	83 c4 10             	add    $0x10,%esp
c0104ffd:	85 c0                	test   %eax,%eax
c0104fff:	74 19                	je     c010501a <basic_check+0x260>
c0105001:	68 a2 71 10 c0       	push   $0xc01071a2
c0105006:	68 06 70 10 c0       	push   $0xc0107006
c010500b:	68 39 01 00 00       	push   $0x139
c0105010:	68 1b 70 10 c0       	push   $0xc010701b
c0105015:	e8 b7 b3 ff ff       	call   c01003d1 <__panic>

    free_page(p0);
c010501a:	83 ec 08             	sub    $0x8,%esp
c010501d:	6a 01                	push   $0x1
c010501f:	ff 75 ec             	pushl  -0x14(%ebp)
c0105022:	e8 f2 db ff ff       	call   c0102c19 <free_pages>
c0105027:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c010502a:	83 ec 08             	sub    $0x8,%esp
c010502d:	6a 01                	push   $0x1
c010502f:	ff 75 f0             	pushl  -0x10(%ebp)
c0105032:	e8 e2 db ff ff       	call   c0102c19 <free_pages>
c0105037:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010503a:	83 ec 08             	sub    $0x8,%esp
c010503d:	6a 01                	push   $0x1
c010503f:	ff 75 f4             	pushl  -0xc(%ebp)
c0105042:	e8 d2 db ff ff       	call   c0102c19 <free_pages>
c0105047:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c010504a:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c010504f:	83 f8 03             	cmp    $0x3,%eax
c0105052:	74 19                	je     c010506d <basic_check+0x2b3>
c0105054:	68 b7 71 10 c0       	push   $0xc01071b7
c0105059:	68 06 70 10 c0       	push   $0xc0107006
c010505e:	68 3e 01 00 00       	push   $0x13e
c0105063:	68 1b 70 10 c0       	push   $0xc010701b
c0105068:	e8 64 b3 ff ff       	call   c01003d1 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010506d:	83 ec 0c             	sub    $0xc,%esp
c0105070:	6a 01                	push   $0x1
c0105072:	e8 64 db ff ff       	call   c0102bdb <alloc_pages>
c0105077:	83 c4 10             	add    $0x10,%esp
c010507a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010507d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105081:	75 19                	jne    c010509c <basic_check+0x2e2>
c0105083:	68 80 70 10 c0       	push   $0xc0107080
c0105088:	68 06 70 10 c0       	push   $0xc0107006
c010508d:	68 40 01 00 00       	push   $0x140
c0105092:	68 1b 70 10 c0       	push   $0xc010701b
c0105097:	e8 35 b3 ff ff       	call   c01003d1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010509c:	83 ec 0c             	sub    $0xc,%esp
c010509f:	6a 01                	push   $0x1
c01050a1:	e8 35 db ff ff       	call   c0102bdb <alloc_pages>
c01050a6:	83 c4 10             	add    $0x10,%esp
c01050a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01050b0:	75 19                	jne    c01050cb <basic_check+0x311>
c01050b2:	68 9c 70 10 c0       	push   $0xc010709c
c01050b7:	68 06 70 10 c0       	push   $0xc0107006
c01050bc:	68 41 01 00 00       	push   $0x141
c01050c1:	68 1b 70 10 c0       	push   $0xc010701b
c01050c6:	e8 06 b3 ff ff       	call   c01003d1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01050cb:	83 ec 0c             	sub    $0xc,%esp
c01050ce:	6a 01                	push   $0x1
c01050d0:	e8 06 db ff ff       	call   c0102bdb <alloc_pages>
c01050d5:	83 c4 10             	add    $0x10,%esp
c01050d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01050db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050df:	75 19                	jne    c01050fa <basic_check+0x340>
c01050e1:	68 b8 70 10 c0       	push   $0xc01070b8
c01050e6:	68 06 70 10 c0       	push   $0xc0107006
c01050eb:	68 42 01 00 00       	push   $0x142
c01050f0:	68 1b 70 10 c0       	push   $0xc010701b
c01050f5:	e8 d7 b2 ff ff       	call   c01003d1 <__panic>

    assert(alloc_page() == NULL);
c01050fa:	83 ec 0c             	sub    $0xc,%esp
c01050fd:	6a 01                	push   $0x1
c01050ff:	e8 d7 da ff ff       	call   c0102bdb <alloc_pages>
c0105104:	83 c4 10             	add    $0x10,%esp
c0105107:	85 c0                	test   %eax,%eax
c0105109:	74 19                	je     c0105124 <basic_check+0x36a>
c010510b:	68 a2 71 10 c0       	push   $0xc01071a2
c0105110:	68 06 70 10 c0       	push   $0xc0107006
c0105115:	68 44 01 00 00       	push   $0x144
c010511a:	68 1b 70 10 c0       	push   $0xc010701b
c010511f:	e8 ad b2 ff ff       	call   c01003d1 <__panic>

    free_page(p0);
c0105124:	83 ec 08             	sub    $0x8,%esp
c0105127:	6a 01                	push   $0x1
c0105129:	ff 75 ec             	pushl  -0x14(%ebp)
c010512c:	e8 e8 da ff ff       	call   c0102c19 <free_pages>
c0105131:	83 c4 10             	add    $0x10,%esp
c0105134:	c7 45 e8 7c 99 11 c0 	movl   $0xc011997c,-0x18(%ebp)
c010513b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010513e:	8b 40 04             	mov    0x4(%eax),%eax
c0105141:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105144:	0f 94 c0             	sete   %al
c0105147:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010514a:	85 c0                	test   %eax,%eax
c010514c:	74 19                	je     c0105167 <basic_check+0x3ad>
c010514e:	68 c4 71 10 c0       	push   $0xc01071c4
c0105153:	68 06 70 10 c0       	push   $0xc0107006
c0105158:	68 47 01 00 00       	push   $0x147
c010515d:	68 1b 70 10 c0       	push   $0xc010701b
c0105162:	e8 6a b2 ff ff       	call   c01003d1 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0105167:	83 ec 0c             	sub    $0xc,%esp
c010516a:	6a 01                	push   $0x1
c010516c:	e8 6a da ff ff       	call   c0102bdb <alloc_pages>
c0105171:	83 c4 10             	add    $0x10,%esp
c0105174:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105177:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010517a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010517d:	74 19                	je     c0105198 <basic_check+0x3de>
c010517f:	68 dc 71 10 c0       	push   $0xc01071dc
c0105184:	68 06 70 10 c0       	push   $0xc0107006
c0105189:	68 4a 01 00 00       	push   $0x14a
c010518e:	68 1b 70 10 c0       	push   $0xc010701b
c0105193:	e8 39 b2 ff ff       	call   c01003d1 <__panic>
    assert(alloc_page() == NULL);
c0105198:	83 ec 0c             	sub    $0xc,%esp
c010519b:	6a 01                	push   $0x1
c010519d:	e8 39 da ff ff       	call   c0102bdb <alloc_pages>
c01051a2:	83 c4 10             	add    $0x10,%esp
c01051a5:	85 c0                	test   %eax,%eax
c01051a7:	74 19                	je     c01051c2 <basic_check+0x408>
c01051a9:	68 a2 71 10 c0       	push   $0xc01071a2
c01051ae:	68 06 70 10 c0       	push   $0xc0107006
c01051b3:	68 4b 01 00 00       	push   $0x14b
c01051b8:	68 1b 70 10 c0       	push   $0xc010701b
c01051bd:	e8 0f b2 ff ff       	call   c01003d1 <__panic>

    assert(nr_free == 0);
c01051c2:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c01051c7:	85 c0                	test   %eax,%eax
c01051c9:	74 19                	je     c01051e4 <basic_check+0x42a>
c01051cb:	68 f5 71 10 c0       	push   $0xc01071f5
c01051d0:	68 06 70 10 c0       	push   $0xc0107006
c01051d5:	68 4d 01 00 00       	push   $0x14d
c01051da:	68 1b 70 10 c0       	push   $0xc010701b
c01051df:	e8 ed b1 ff ff       	call   c01003d1 <__panic>
    free_list = free_list_store;
c01051e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01051e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01051ea:	a3 7c 99 11 c0       	mov    %eax,0xc011997c
c01051ef:	89 15 80 99 11 c0    	mov    %edx,0xc0119980
    nr_free = nr_free_store;
c01051f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051f8:	a3 84 99 11 c0       	mov    %eax,0xc0119984

    free_page(p);
c01051fd:	83 ec 08             	sub    $0x8,%esp
c0105200:	6a 01                	push   $0x1
c0105202:	ff 75 dc             	pushl  -0x24(%ebp)
c0105205:	e8 0f da ff ff       	call   c0102c19 <free_pages>
c010520a:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c010520d:	83 ec 08             	sub    $0x8,%esp
c0105210:	6a 01                	push   $0x1
c0105212:	ff 75 f0             	pushl  -0x10(%ebp)
c0105215:	e8 ff d9 ff ff       	call   c0102c19 <free_pages>
c010521a:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010521d:	83 ec 08             	sub    $0x8,%esp
c0105220:	6a 01                	push   $0x1
c0105222:	ff 75 f4             	pushl  -0xc(%ebp)
c0105225:	e8 ef d9 ff ff       	call   c0102c19 <free_pages>
c010522a:	83 c4 10             	add    $0x10,%esp
}
c010522d:	90                   	nop
c010522e:	c9                   	leave  
c010522f:	c3                   	ret    

c0105230 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions
static void
default_check(void) {
c0105230:	55                   	push   %ebp
c0105231:	89 e5                	mov    %esp,%ebp
c0105233:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0105239:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105240:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0105247:	c7 45 ec 7c 99 11 c0 	movl   $0xc011997c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010524e:	eb 76                	jmp    c01052c6 <default_check+0x96>
        struct Page *p = le2page(le, page_link);
c0105250:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105253:	83 e8 0c             	sub    $0xc,%eax
c0105256:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0105259:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010525c:	83 c0 04             	add    $0x4,%eax
c010525f:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0105266:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105269:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010526c:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010526f:	0f a3 10             	bt     %edx,(%eax)
c0105272:	19 c0                	sbb    %eax,%eax
c0105274:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0105277:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c010527b:	0f 95 c0             	setne  %al
c010527e:	0f b6 c0             	movzbl %al,%eax
c0105281:	85 c0                	test   %eax,%eax
c0105283:	75 19                	jne    c010529e <default_check+0x6e>
c0105285:	68 02 72 10 c0       	push   $0xc0107202
c010528a:	68 06 70 10 c0       	push   $0xc0107006
c010528f:	68 5e 01 00 00       	push   $0x15e
c0105294:	68 1b 70 10 c0       	push   $0xc010701b
c0105299:	e8 33 b1 ff ff       	call   c01003d1 <__panic>
        count ++, total += p->property;
c010529e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01052a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052a5:	8b 50 08             	mov    0x8(%eax),%edx
c01052a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052ab:	01 d0                	add    %edx,%eax
c01052ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
        cprintf("count %d total %d\n", count, total); //my
c01052b0:	83 ec 04             	sub    $0x4,%esp
c01052b3:	ff 75 f0             	pushl  -0x10(%ebp)
c01052b6:	ff 75 f4             	pushl  -0xc(%ebp)
c01052b9:	68 12 72 10 c0       	push   $0xc0107212
c01052be:	e8 a8 af ff ff       	call   c010026b <cprintf>
c01052c3:	83 c4 10             	add    $0x10,%esp
c01052c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01052cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052cf:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01052d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01052d5:	81 7d ec 7c 99 11 c0 	cmpl   $0xc011997c,-0x14(%ebp)
c01052dc:	0f 85 6e ff ff ff    	jne    c0105250 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
        cprintf("count %d total %d\n", count, total); //my
    }
    assert(total == nr_free_pages());
c01052e2:	e8 67 d9 ff ff       	call   c0102c4e <nr_free_pages>
c01052e7:	89 c2                	mov    %eax,%edx
c01052e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052ec:	39 c2                	cmp    %eax,%edx
c01052ee:	74 19                	je     c0105309 <default_check+0xd9>
c01052f0:	68 25 72 10 c0       	push   $0xc0107225
c01052f5:	68 06 70 10 c0       	push   $0xc0107006
c01052fa:	68 62 01 00 00       	push   $0x162
c01052ff:	68 1b 70 10 c0       	push   $0xc010701b
c0105304:	e8 c8 b0 ff ff       	call   c01003d1 <__panic>

    basic_check();
c0105309:	e8 ac fa ff ff       	call   c0104dba <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010530e:	83 ec 0c             	sub    $0xc,%esp
c0105311:	6a 05                	push   $0x5
c0105313:	e8 c3 d8 ff ff       	call   c0102bdb <alloc_pages>
c0105318:	83 c4 10             	add    $0x10,%esp
c010531b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c010531e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105322:	75 19                	jne    c010533d <default_check+0x10d>
c0105324:	68 3e 72 10 c0       	push   $0xc010723e
c0105329:	68 06 70 10 c0       	push   $0xc0107006
c010532e:	68 67 01 00 00       	push   $0x167
c0105333:	68 1b 70 10 c0       	push   $0xc010701b
c0105338:	e8 94 b0 ff ff       	call   c01003d1 <__panic>
    assert(!PageProperty(p0));
c010533d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105340:	83 c0 04             	add    $0x4,%eax
c0105343:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c010534a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010534d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105350:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105353:	0f a3 10             	bt     %edx,(%eax)
c0105356:	19 c0                	sbb    %eax,%eax
c0105358:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c010535b:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c010535f:	0f 95 c0             	setne  %al
c0105362:	0f b6 c0             	movzbl %al,%eax
c0105365:	85 c0                	test   %eax,%eax
c0105367:	74 19                	je     c0105382 <default_check+0x152>
c0105369:	68 49 72 10 c0       	push   $0xc0107249
c010536e:	68 06 70 10 c0       	push   $0xc0107006
c0105373:	68 68 01 00 00       	push   $0x168
c0105378:	68 1b 70 10 c0       	push   $0xc010701b
c010537d:	e8 4f b0 ff ff       	call   c01003d1 <__panic>

    list_entry_t free_list_store = free_list;
c0105382:	a1 7c 99 11 c0       	mov    0xc011997c,%eax
c0105387:	8b 15 80 99 11 c0    	mov    0xc0119980,%edx
c010538d:	89 45 80             	mov    %eax,-0x80(%ebp)
c0105390:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0105393:	c7 45 d0 7c 99 11 c0 	movl   $0xc011997c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010539a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010539d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01053a0:	89 50 04             	mov    %edx,0x4(%eax)
c01053a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01053a6:	8b 50 04             	mov    0x4(%eax),%edx
c01053a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01053ac:	89 10                	mov    %edx,(%eax)
c01053ae:	c7 45 d8 7c 99 11 c0 	movl   $0xc011997c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01053b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01053b8:	8b 40 04             	mov    0x4(%eax),%eax
c01053bb:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01053be:	0f 94 c0             	sete   %al
c01053c1:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01053c4:	85 c0                	test   %eax,%eax
c01053c6:	75 19                	jne    c01053e1 <default_check+0x1b1>
c01053c8:	68 8b 71 10 c0       	push   $0xc010718b
c01053cd:	68 06 70 10 c0       	push   $0xc0107006
c01053d2:	68 6c 01 00 00       	push   $0x16c
c01053d7:	68 1b 70 10 c0       	push   $0xc010701b
c01053dc:	e8 f0 af ff ff       	call   c01003d1 <__panic>
    assert(alloc_page() == NULL);
c01053e1:	83 ec 0c             	sub    $0xc,%esp
c01053e4:	6a 01                	push   $0x1
c01053e6:	e8 f0 d7 ff ff       	call   c0102bdb <alloc_pages>
c01053eb:	83 c4 10             	add    $0x10,%esp
c01053ee:	85 c0                	test   %eax,%eax
c01053f0:	74 19                	je     c010540b <default_check+0x1db>
c01053f2:	68 a2 71 10 c0       	push   $0xc01071a2
c01053f7:	68 06 70 10 c0       	push   $0xc0107006
c01053fc:	68 6d 01 00 00       	push   $0x16d
c0105401:	68 1b 70 10 c0       	push   $0xc010701b
c0105406:	e8 c6 af ff ff       	call   c01003d1 <__panic>

    unsigned int nr_free_store = nr_free;
c010540b:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c0105410:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0105413:	c7 05 84 99 11 c0 00 	movl   $0x0,0xc0119984
c010541a:	00 00 00 

    free_pages(p0 + 2, 3);
c010541d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105420:	83 c0 28             	add    $0x28,%eax
c0105423:	83 ec 08             	sub    $0x8,%esp
c0105426:	6a 03                	push   $0x3
c0105428:	50                   	push   %eax
c0105429:	e8 eb d7 ff ff       	call   c0102c19 <free_pages>
c010542e:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0105431:	83 ec 0c             	sub    $0xc,%esp
c0105434:	6a 04                	push   $0x4
c0105436:	e8 a0 d7 ff ff       	call   c0102bdb <alloc_pages>
c010543b:	83 c4 10             	add    $0x10,%esp
c010543e:	85 c0                	test   %eax,%eax
c0105440:	74 19                	je     c010545b <default_check+0x22b>
c0105442:	68 5b 72 10 c0       	push   $0xc010725b
c0105447:	68 06 70 10 c0       	push   $0xc0107006
c010544c:	68 73 01 00 00       	push   $0x173
c0105451:	68 1b 70 10 c0       	push   $0xc010701b
c0105456:	e8 76 af ff ff       	call   c01003d1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010545b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010545e:	83 c0 28             	add    $0x28,%eax
c0105461:	83 c0 04             	add    $0x4,%eax
c0105464:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010546b:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010546e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105471:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105474:	0f a3 10             	bt     %edx,(%eax)
c0105477:	19 c0                	sbb    %eax,%eax
c0105479:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010547c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105480:	0f 95 c0             	setne  %al
c0105483:	0f b6 c0             	movzbl %al,%eax
c0105486:	85 c0                	test   %eax,%eax
c0105488:	74 0e                	je     c0105498 <default_check+0x268>
c010548a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010548d:	83 c0 28             	add    $0x28,%eax
c0105490:	8b 40 08             	mov    0x8(%eax),%eax
c0105493:	83 f8 03             	cmp    $0x3,%eax
c0105496:	74 19                	je     c01054b1 <default_check+0x281>
c0105498:	68 74 72 10 c0       	push   $0xc0107274
c010549d:	68 06 70 10 c0       	push   $0xc0107006
c01054a2:	68 74 01 00 00       	push   $0x174
c01054a7:	68 1b 70 10 c0       	push   $0xc010701b
c01054ac:	e8 20 af ff ff       	call   c01003d1 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01054b1:	83 ec 0c             	sub    $0xc,%esp
c01054b4:	6a 03                	push   $0x3
c01054b6:	e8 20 d7 ff ff       	call   c0102bdb <alloc_pages>
c01054bb:	83 c4 10             	add    $0x10,%esp
c01054be:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01054c1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01054c5:	75 19                	jne    c01054e0 <default_check+0x2b0>
c01054c7:	68 a0 72 10 c0       	push   $0xc01072a0
c01054cc:	68 06 70 10 c0       	push   $0xc0107006
c01054d1:	68 75 01 00 00       	push   $0x175
c01054d6:	68 1b 70 10 c0       	push   $0xc010701b
c01054db:	e8 f1 ae ff ff       	call   c01003d1 <__panic>
    assert(alloc_page() == NULL);
c01054e0:	83 ec 0c             	sub    $0xc,%esp
c01054e3:	6a 01                	push   $0x1
c01054e5:	e8 f1 d6 ff ff       	call   c0102bdb <alloc_pages>
c01054ea:	83 c4 10             	add    $0x10,%esp
c01054ed:	85 c0                	test   %eax,%eax
c01054ef:	74 19                	je     c010550a <default_check+0x2da>
c01054f1:	68 a2 71 10 c0       	push   $0xc01071a2
c01054f6:	68 06 70 10 c0       	push   $0xc0107006
c01054fb:	68 76 01 00 00       	push   $0x176
c0105500:	68 1b 70 10 c0       	push   $0xc010701b
c0105505:	e8 c7 ae ff ff       	call   c01003d1 <__panic>
    assert(p0 + 2 == p1);
c010550a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010550d:	83 c0 28             	add    $0x28,%eax
c0105510:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0105513:	74 19                	je     c010552e <default_check+0x2fe>
c0105515:	68 be 72 10 c0       	push   $0xc01072be
c010551a:	68 06 70 10 c0       	push   $0xc0107006
c010551f:	68 77 01 00 00       	push   $0x177
c0105524:	68 1b 70 10 c0       	push   $0xc010701b
c0105529:	e8 a3 ae ff ff       	call   c01003d1 <__panic>

    p2 = p0 + 1;
c010552e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105531:	83 c0 14             	add    $0x14,%eax
c0105534:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0105537:	83 ec 08             	sub    $0x8,%esp
c010553a:	6a 01                	push   $0x1
c010553c:	ff 75 dc             	pushl  -0x24(%ebp)
c010553f:	e8 d5 d6 ff ff       	call   c0102c19 <free_pages>
c0105544:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0105547:	83 ec 08             	sub    $0x8,%esp
c010554a:	6a 03                	push   $0x3
c010554c:	ff 75 c4             	pushl  -0x3c(%ebp)
c010554f:	e8 c5 d6 ff ff       	call   c0102c19 <free_pages>
c0105554:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0105557:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010555a:	83 c0 04             	add    $0x4,%eax
c010555d:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0105564:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105567:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010556a:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010556d:	0f a3 10             	bt     %edx,(%eax)
c0105570:	19 c0                	sbb    %eax,%eax
c0105572:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0105575:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0105579:	0f 95 c0             	setne  %al
c010557c:	0f b6 c0             	movzbl %al,%eax
c010557f:	85 c0                	test   %eax,%eax
c0105581:	74 0b                	je     c010558e <default_check+0x35e>
c0105583:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105586:	8b 40 08             	mov    0x8(%eax),%eax
c0105589:	83 f8 01             	cmp    $0x1,%eax
c010558c:	74 19                	je     c01055a7 <default_check+0x377>
c010558e:	68 cc 72 10 c0       	push   $0xc01072cc
c0105593:	68 06 70 10 c0       	push   $0xc0107006
c0105598:	68 7c 01 00 00       	push   $0x17c
c010559d:	68 1b 70 10 c0       	push   $0xc010701b
c01055a2:	e8 2a ae ff ff       	call   c01003d1 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01055a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01055aa:	83 c0 04             	add    $0x4,%eax
c01055ad:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c01055b4:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01055b7:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01055ba:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01055bd:	0f a3 10             	bt     %edx,(%eax)
c01055c0:	19 c0                	sbb    %eax,%eax
c01055c2:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c01055c5:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c01055c9:	0f 95 c0             	setne  %al
c01055cc:	0f b6 c0             	movzbl %al,%eax
c01055cf:	85 c0                	test   %eax,%eax
c01055d1:	74 0b                	je     c01055de <default_check+0x3ae>
c01055d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01055d6:	8b 40 08             	mov    0x8(%eax),%eax
c01055d9:	83 f8 03             	cmp    $0x3,%eax
c01055dc:	74 19                	je     c01055f7 <default_check+0x3c7>
c01055de:	68 f4 72 10 c0       	push   $0xc01072f4
c01055e3:	68 06 70 10 c0       	push   $0xc0107006
c01055e8:	68 7d 01 00 00       	push   $0x17d
c01055ed:	68 1b 70 10 c0       	push   $0xc010701b
c01055f2:	e8 da ad ff ff       	call   c01003d1 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01055f7:	83 ec 0c             	sub    $0xc,%esp
c01055fa:	6a 01                	push   $0x1
c01055fc:	e8 da d5 ff ff       	call   c0102bdb <alloc_pages>
c0105601:	83 c4 10             	add    $0x10,%esp
c0105604:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105607:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010560a:	83 e8 14             	sub    $0x14,%eax
c010560d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105610:	74 19                	je     c010562b <default_check+0x3fb>
c0105612:	68 1a 73 10 c0       	push   $0xc010731a
c0105617:	68 06 70 10 c0       	push   $0xc0107006
c010561c:	68 7f 01 00 00       	push   $0x17f
c0105621:	68 1b 70 10 c0       	push   $0xc010701b
c0105626:	e8 a6 ad ff ff       	call   c01003d1 <__panic>
    free_page(p0);
c010562b:	83 ec 08             	sub    $0x8,%esp
c010562e:	6a 01                	push   $0x1
c0105630:	ff 75 dc             	pushl  -0x24(%ebp)
c0105633:	e8 e1 d5 ff ff       	call   c0102c19 <free_pages>
c0105638:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010563b:	83 ec 0c             	sub    $0xc,%esp
c010563e:	6a 02                	push   $0x2
c0105640:	e8 96 d5 ff ff       	call   c0102bdb <alloc_pages>
c0105645:	83 c4 10             	add    $0x10,%esp
c0105648:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010564b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010564e:	83 c0 14             	add    $0x14,%eax
c0105651:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105654:	74 19                	je     c010566f <default_check+0x43f>
c0105656:	68 38 73 10 c0       	push   $0xc0107338
c010565b:	68 06 70 10 c0       	push   $0xc0107006
c0105660:	68 81 01 00 00       	push   $0x181
c0105665:	68 1b 70 10 c0       	push   $0xc010701b
c010566a:	e8 62 ad ff ff       	call   c01003d1 <__panic>

    free_pages(p0, 2);
c010566f:	83 ec 08             	sub    $0x8,%esp
c0105672:	6a 02                	push   $0x2
c0105674:	ff 75 dc             	pushl  -0x24(%ebp)
c0105677:	e8 9d d5 ff ff       	call   c0102c19 <free_pages>
c010567c:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010567f:	83 ec 08             	sub    $0x8,%esp
c0105682:	6a 01                	push   $0x1
c0105684:	ff 75 c0             	pushl  -0x40(%ebp)
c0105687:	e8 8d d5 ff ff       	call   c0102c19 <free_pages>
c010568c:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c010568f:	83 ec 0c             	sub    $0xc,%esp
c0105692:	6a 05                	push   $0x5
c0105694:	e8 42 d5 ff ff       	call   c0102bdb <alloc_pages>
c0105699:	83 c4 10             	add    $0x10,%esp
c010569c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010569f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01056a3:	75 19                	jne    c01056be <default_check+0x48e>
c01056a5:	68 58 73 10 c0       	push   $0xc0107358
c01056aa:	68 06 70 10 c0       	push   $0xc0107006
c01056af:	68 86 01 00 00       	push   $0x186
c01056b4:	68 1b 70 10 c0       	push   $0xc010701b
c01056b9:	e8 13 ad ff ff       	call   c01003d1 <__panic>
    assert(alloc_page() == NULL);
c01056be:	83 ec 0c             	sub    $0xc,%esp
c01056c1:	6a 01                	push   $0x1
c01056c3:	e8 13 d5 ff ff       	call   c0102bdb <alloc_pages>
c01056c8:	83 c4 10             	add    $0x10,%esp
c01056cb:	85 c0                	test   %eax,%eax
c01056cd:	74 19                	je     c01056e8 <default_check+0x4b8>
c01056cf:	68 a2 71 10 c0       	push   $0xc01071a2
c01056d4:	68 06 70 10 c0       	push   $0xc0107006
c01056d9:	68 87 01 00 00       	push   $0x187
c01056de:	68 1b 70 10 c0       	push   $0xc010701b
c01056e3:	e8 e9 ac ff ff       	call   c01003d1 <__panic>

    assert(nr_free == 0);
c01056e8:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c01056ed:	85 c0                	test   %eax,%eax
c01056ef:	74 19                	je     c010570a <default_check+0x4da>
c01056f1:	68 f5 71 10 c0       	push   $0xc01071f5
c01056f6:	68 06 70 10 c0       	push   $0xc0107006
c01056fb:	68 89 01 00 00       	push   $0x189
c0105700:	68 1b 70 10 c0       	push   $0xc010701b
c0105705:	e8 c7 ac ff ff       	call   c01003d1 <__panic>
    nr_free = nr_free_store;
c010570a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010570d:	a3 84 99 11 c0       	mov    %eax,0xc0119984

    free_list = free_list_store;
c0105712:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105715:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105718:	a3 7c 99 11 c0       	mov    %eax,0xc011997c
c010571d:	89 15 80 99 11 c0    	mov    %edx,0xc0119980
    free_pages(p0, 5);
c0105723:	83 ec 08             	sub    $0x8,%esp
c0105726:	6a 05                	push   $0x5
c0105728:	ff 75 dc             	pushl  -0x24(%ebp)
c010572b:	e8 e9 d4 ff ff       	call   c0102c19 <free_pages>
c0105730:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0105733:	c7 45 ec 7c 99 11 c0 	movl   $0xc011997c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010573a:	eb 1d                	jmp    c0105759 <default_check+0x529>
        struct Page *p = le2page(le, page_link);
c010573c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010573f:	83 e8 0c             	sub    $0xc,%eax
c0105742:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c0105745:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0105749:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010574c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010574f:	8b 40 08             	mov    0x8(%eax),%eax
c0105752:	29 c2                	sub    %eax,%edx
c0105754:	89 d0                	mov    %edx,%eax
c0105756:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105759:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010575c:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010575f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105762:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0105765:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105768:	81 7d ec 7c 99 11 c0 	cmpl   $0xc011997c,-0x14(%ebp)
c010576f:	75 cb                	jne    c010573c <default_check+0x50c>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0105771:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105775:	74 19                	je     c0105790 <default_check+0x560>
c0105777:	68 76 73 10 c0       	push   $0xc0107376
c010577c:	68 06 70 10 c0       	push   $0xc0107006
c0105781:	68 94 01 00 00       	push   $0x194
c0105786:	68 1b 70 10 c0       	push   $0xc010701b
c010578b:	e8 41 ac ff ff       	call   c01003d1 <__panic>
    assert(total == 0);
c0105790:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105794:	74 19                	je     c01057af <default_check+0x57f>
c0105796:	68 81 73 10 c0       	push   $0xc0107381
c010579b:	68 06 70 10 c0       	push   $0xc0107006
c01057a0:	68 95 01 00 00       	push   $0x195
c01057a5:	68 1b 70 10 c0       	push   $0xc010701b
c01057aa:	e8 22 ac ff ff       	call   c01003d1 <__panic>
}
c01057af:	90                   	nop
c01057b0:	c9                   	leave  
c01057b1:	c3                   	ret    

c01057b2 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01057b2:	55                   	push   %ebp
c01057b3:	89 e5                	mov    %esp,%ebp
c01057b5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01057b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01057bf:	eb 04                	jmp    c01057c5 <strlen+0x13>
        cnt ++;
c01057c1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01057c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c8:	8d 50 01             	lea    0x1(%eax),%edx
c01057cb:	89 55 08             	mov    %edx,0x8(%ebp)
c01057ce:	0f b6 00             	movzbl (%eax),%eax
c01057d1:	84 c0                	test   %al,%al
c01057d3:	75 ec                	jne    c01057c1 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01057d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01057d8:	c9                   	leave  
c01057d9:	c3                   	ret    

c01057da <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01057da:	55                   	push   %ebp
c01057db:	89 e5                	mov    %esp,%ebp
c01057dd:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01057e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01057e7:	eb 04                	jmp    c01057ed <strnlen+0x13>
        cnt ++;
c01057e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01057ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01057f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01057f3:	73 10                	jae    c0105805 <strnlen+0x2b>
c01057f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f8:	8d 50 01             	lea    0x1(%eax),%edx
c01057fb:	89 55 08             	mov    %edx,0x8(%ebp)
c01057fe:	0f b6 00             	movzbl (%eax),%eax
c0105801:	84 c0                	test   %al,%al
c0105803:	75 e4                	jne    c01057e9 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105805:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105808:	c9                   	leave  
c0105809:	c3                   	ret    

c010580a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010580a:	55                   	push   %ebp
c010580b:	89 e5                	mov    %esp,%ebp
c010580d:	57                   	push   %edi
c010580e:	56                   	push   %esi
c010580f:	83 ec 20             	sub    $0x20,%esp
c0105812:	8b 45 08             	mov    0x8(%ebp),%eax
c0105815:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105818:	8b 45 0c             	mov    0xc(%ebp),%eax
c010581b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010581e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105821:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105824:	89 d1                	mov    %edx,%ecx
c0105826:	89 c2                	mov    %eax,%edx
c0105828:	89 ce                	mov    %ecx,%esi
c010582a:	89 d7                	mov    %edx,%edi
c010582c:	ac                   	lods   %ds:(%esi),%al
c010582d:	aa                   	stos   %al,%es:(%edi)
c010582e:	84 c0                	test   %al,%al
c0105830:	75 fa                	jne    c010582c <strcpy+0x22>
c0105832:	89 fa                	mov    %edi,%edx
c0105834:	89 f1                	mov    %esi,%ecx
c0105836:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105839:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010583c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010583f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0105842:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105843:	83 c4 20             	add    $0x20,%esp
c0105846:	5e                   	pop    %esi
c0105847:	5f                   	pop    %edi
c0105848:	5d                   	pop    %ebp
c0105849:	c3                   	ret    

c010584a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010584a:	55                   	push   %ebp
c010584b:	89 e5                	mov    %esp,%ebp
c010584d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105850:	8b 45 08             	mov    0x8(%ebp),%eax
c0105853:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105856:	eb 21                	jmp    c0105879 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105858:	8b 45 0c             	mov    0xc(%ebp),%eax
c010585b:	0f b6 10             	movzbl (%eax),%edx
c010585e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105861:	88 10                	mov    %dl,(%eax)
c0105863:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105866:	0f b6 00             	movzbl (%eax),%eax
c0105869:	84 c0                	test   %al,%al
c010586b:	74 04                	je     c0105871 <strncpy+0x27>
            src ++;
c010586d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105871:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105875:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105879:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010587d:	75 d9                	jne    c0105858 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010587f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105882:	c9                   	leave  
c0105883:	c3                   	ret    

c0105884 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105884:	55                   	push   %ebp
c0105885:	89 e5                	mov    %esp,%ebp
c0105887:	57                   	push   %edi
c0105888:	56                   	push   %esi
c0105889:	83 ec 20             	sub    $0x20,%esp
c010588c:	8b 45 08             	mov    0x8(%ebp),%eax
c010588f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105892:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105895:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105898:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010589b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010589e:	89 d1                	mov    %edx,%ecx
c01058a0:	89 c2                	mov    %eax,%edx
c01058a2:	89 ce                	mov    %ecx,%esi
c01058a4:	89 d7                	mov    %edx,%edi
c01058a6:	ac                   	lods   %ds:(%esi),%al
c01058a7:	ae                   	scas   %es:(%edi),%al
c01058a8:	75 08                	jne    c01058b2 <strcmp+0x2e>
c01058aa:	84 c0                	test   %al,%al
c01058ac:	75 f8                	jne    c01058a6 <strcmp+0x22>
c01058ae:	31 c0                	xor    %eax,%eax
c01058b0:	eb 04                	jmp    c01058b6 <strcmp+0x32>
c01058b2:	19 c0                	sbb    %eax,%eax
c01058b4:	0c 01                	or     $0x1,%al
c01058b6:	89 fa                	mov    %edi,%edx
c01058b8:	89 f1                	mov    %esi,%ecx
c01058ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01058bd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01058c0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01058c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c01058c6:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01058c7:	83 c4 20             	add    $0x20,%esp
c01058ca:	5e                   	pop    %esi
c01058cb:	5f                   	pop    %edi
c01058cc:	5d                   	pop    %ebp
c01058cd:	c3                   	ret    

c01058ce <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01058ce:	55                   	push   %ebp
c01058cf:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01058d1:	eb 0c                	jmp    c01058df <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01058d3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01058d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01058db:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01058df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01058e3:	74 1a                	je     c01058ff <strncmp+0x31>
c01058e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e8:	0f b6 00             	movzbl (%eax),%eax
c01058eb:	84 c0                	test   %al,%al
c01058ed:	74 10                	je     c01058ff <strncmp+0x31>
c01058ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f2:	0f b6 10             	movzbl (%eax),%edx
c01058f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f8:	0f b6 00             	movzbl (%eax),%eax
c01058fb:	38 c2                	cmp    %al,%dl
c01058fd:	74 d4                	je     c01058d3 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01058ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105903:	74 18                	je     c010591d <strncmp+0x4f>
c0105905:	8b 45 08             	mov    0x8(%ebp),%eax
c0105908:	0f b6 00             	movzbl (%eax),%eax
c010590b:	0f b6 d0             	movzbl %al,%edx
c010590e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105911:	0f b6 00             	movzbl (%eax),%eax
c0105914:	0f b6 c0             	movzbl %al,%eax
c0105917:	29 c2                	sub    %eax,%edx
c0105919:	89 d0                	mov    %edx,%eax
c010591b:	eb 05                	jmp    c0105922 <strncmp+0x54>
c010591d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105922:	5d                   	pop    %ebp
c0105923:	c3                   	ret    

c0105924 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105924:	55                   	push   %ebp
c0105925:	89 e5                	mov    %esp,%ebp
c0105927:	83 ec 04             	sub    $0x4,%esp
c010592a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010592d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105930:	eb 14                	jmp    c0105946 <strchr+0x22>
        if (*s == c) {
c0105932:	8b 45 08             	mov    0x8(%ebp),%eax
c0105935:	0f b6 00             	movzbl (%eax),%eax
c0105938:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010593b:	75 05                	jne    c0105942 <strchr+0x1e>
            return (char *)s;
c010593d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105940:	eb 13                	jmp    c0105955 <strchr+0x31>
        }
        s ++;
c0105942:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105946:	8b 45 08             	mov    0x8(%ebp),%eax
c0105949:	0f b6 00             	movzbl (%eax),%eax
c010594c:	84 c0                	test   %al,%al
c010594e:	75 e2                	jne    c0105932 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105950:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105955:	c9                   	leave  
c0105956:	c3                   	ret    

c0105957 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105957:	55                   	push   %ebp
c0105958:	89 e5                	mov    %esp,%ebp
c010595a:	83 ec 04             	sub    $0x4,%esp
c010595d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105960:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105963:	eb 0f                	jmp    c0105974 <strfind+0x1d>
        if (*s == c) {
c0105965:	8b 45 08             	mov    0x8(%ebp),%eax
c0105968:	0f b6 00             	movzbl (%eax),%eax
c010596b:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010596e:	74 10                	je     c0105980 <strfind+0x29>
            break;
        }
        s ++;
c0105970:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105974:	8b 45 08             	mov    0x8(%ebp),%eax
c0105977:	0f b6 00             	movzbl (%eax),%eax
c010597a:	84 c0                	test   %al,%al
c010597c:	75 e7                	jne    c0105965 <strfind+0xe>
c010597e:	eb 01                	jmp    c0105981 <strfind+0x2a>
        if (*s == c) {
            break;
c0105980:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0105981:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105984:	c9                   	leave  
c0105985:	c3                   	ret    

c0105986 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105986:	55                   	push   %ebp
c0105987:	89 e5                	mov    %esp,%ebp
c0105989:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010598c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105993:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010599a:	eb 04                	jmp    c01059a0 <strtol+0x1a>
        s ++;
c010599c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01059a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a3:	0f b6 00             	movzbl (%eax),%eax
c01059a6:	3c 20                	cmp    $0x20,%al
c01059a8:	74 f2                	je     c010599c <strtol+0x16>
c01059aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ad:	0f b6 00             	movzbl (%eax),%eax
c01059b0:	3c 09                	cmp    $0x9,%al
c01059b2:	74 e8                	je     c010599c <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01059b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b7:	0f b6 00             	movzbl (%eax),%eax
c01059ba:	3c 2b                	cmp    $0x2b,%al
c01059bc:	75 06                	jne    c01059c4 <strtol+0x3e>
        s ++;
c01059be:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01059c2:	eb 15                	jmp    c01059d9 <strtol+0x53>
    }
    else if (*s == '-') {
c01059c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c7:	0f b6 00             	movzbl (%eax),%eax
c01059ca:	3c 2d                	cmp    $0x2d,%al
c01059cc:	75 0b                	jne    c01059d9 <strtol+0x53>
        s ++, neg = 1;
c01059ce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01059d2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01059d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01059dd:	74 06                	je     c01059e5 <strtol+0x5f>
c01059df:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01059e3:	75 24                	jne    c0105a09 <strtol+0x83>
c01059e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01059e8:	0f b6 00             	movzbl (%eax),%eax
c01059eb:	3c 30                	cmp    $0x30,%al
c01059ed:	75 1a                	jne    c0105a09 <strtol+0x83>
c01059ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f2:	83 c0 01             	add    $0x1,%eax
c01059f5:	0f b6 00             	movzbl (%eax),%eax
c01059f8:	3c 78                	cmp    $0x78,%al
c01059fa:	75 0d                	jne    c0105a09 <strtol+0x83>
        s += 2, base = 16;
c01059fc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105a00:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105a07:	eb 2a                	jmp    c0105a33 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105a09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a0d:	75 17                	jne    c0105a26 <strtol+0xa0>
c0105a0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a12:	0f b6 00             	movzbl (%eax),%eax
c0105a15:	3c 30                	cmp    $0x30,%al
c0105a17:	75 0d                	jne    c0105a26 <strtol+0xa0>
        s ++, base = 8;
c0105a19:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105a1d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105a24:	eb 0d                	jmp    c0105a33 <strtol+0xad>
    }
    else if (base == 0) {
c0105a26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a2a:	75 07                	jne    c0105a33 <strtol+0xad>
        base = 10;
c0105a2c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a36:	0f b6 00             	movzbl (%eax),%eax
c0105a39:	3c 2f                	cmp    $0x2f,%al
c0105a3b:	7e 1b                	jle    c0105a58 <strtol+0xd2>
c0105a3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a40:	0f b6 00             	movzbl (%eax),%eax
c0105a43:	3c 39                	cmp    $0x39,%al
c0105a45:	7f 11                	jg     c0105a58 <strtol+0xd2>
            dig = *s - '0';
c0105a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a4a:	0f b6 00             	movzbl (%eax),%eax
c0105a4d:	0f be c0             	movsbl %al,%eax
c0105a50:	83 e8 30             	sub    $0x30,%eax
c0105a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a56:	eb 48                	jmp    c0105aa0 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105a58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a5b:	0f b6 00             	movzbl (%eax),%eax
c0105a5e:	3c 60                	cmp    $0x60,%al
c0105a60:	7e 1b                	jle    c0105a7d <strtol+0xf7>
c0105a62:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a65:	0f b6 00             	movzbl (%eax),%eax
c0105a68:	3c 7a                	cmp    $0x7a,%al
c0105a6a:	7f 11                	jg     c0105a7d <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105a6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a6f:	0f b6 00             	movzbl (%eax),%eax
c0105a72:	0f be c0             	movsbl %al,%eax
c0105a75:	83 e8 57             	sub    $0x57,%eax
c0105a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a7b:	eb 23                	jmp    c0105aa0 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105a7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a80:	0f b6 00             	movzbl (%eax),%eax
c0105a83:	3c 40                	cmp    $0x40,%al
c0105a85:	7e 3c                	jle    c0105ac3 <strtol+0x13d>
c0105a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8a:	0f b6 00             	movzbl (%eax),%eax
c0105a8d:	3c 5a                	cmp    $0x5a,%al
c0105a8f:	7f 32                	jg     c0105ac3 <strtol+0x13d>
            dig = *s - 'A' + 10;
c0105a91:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a94:	0f b6 00             	movzbl (%eax),%eax
c0105a97:	0f be c0             	movsbl %al,%eax
c0105a9a:	83 e8 37             	sub    $0x37,%eax
c0105a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105aa3:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105aa6:	7d 1a                	jge    c0105ac2 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c0105aa8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105aac:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105aaf:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105ab3:	89 c2                	mov    %eax,%edx
c0105ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ab8:	01 d0                	add    %edx,%eax
c0105aba:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105abd:	e9 71 ff ff ff       	jmp    c0105a33 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0105ac2:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105ac3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105ac7:	74 08                	je     c0105ad1 <strtol+0x14b>
        *endptr = (char *) s;
c0105ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105acc:	8b 55 08             	mov    0x8(%ebp),%edx
c0105acf:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105ad1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105ad5:	74 07                	je     c0105ade <strtol+0x158>
c0105ad7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105ada:	f7 d8                	neg    %eax
c0105adc:	eb 03                	jmp    c0105ae1 <strtol+0x15b>
c0105ade:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105ae1:	c9                   	leave  
c0105ae2:	c3                   	ret    

c0105ae3 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105ae3:	55                   	push   %ebp
c0105ae4:	89 e5                	mov    %esp,%ebp
c0105ae6:	57                   	push   %edi
c0105ae7:	83 ec 24             	sub    $0x24,%esp
c0105aea:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aed:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105af0:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105af4:	8b 55 08             	mov    0x8(%ebp),%edx
c0105af7:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105afa:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105afd:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105b03:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105b06:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105b0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105b0d:	89 d7                	mov    %edx,%edi
c0105b0f:	f3 aa                	rep stos %al,%es:(%edi)
c0105b11:	89 fa                	mov    %edi,%edx
c0105b13:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b16:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105b19:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105b1c:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105b1d:	83 c4 24             	add    $0x24,%esp
c0105b20:	5f                   	pop    %edi
c0105b21:	5d                   	pop    %ebp
c0105b22:	c3                   	ret    

c0105b23 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105b23:	55                   	push   %ebp
c0105b24:	89 e5                	mov    %esp,%ebp
c0105b26:	57                   	push   %edi
c0105b27:	56                   	push   %esi
c0105b28:	53                   	push   %ebx
c0105b29:	83 ec 30             	sub    $0x30,%esp
c0105b2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b35:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b38:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b3b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b41:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105b44:	73 42                	jae    c0105b88 <memmove+0x65>
c0105b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105b52:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b55:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105b58:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b5b:	c1 e8 02             	shr    $0x2,%eax
c0105b5e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105b60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b63:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b66:	89 d7                	mov    %edx,%edi
c0105b68:	89 c6                	mov    %eax,%esi
c0105b6a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105b6c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105b6f:	83 e1 03             	and    $0x3,%ecx
c0105b72:	74 02                	je     c0105b76 <memmove+0x53>
c0105b74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105b76:	89 f0                	mov    %esi,%eax
c0105b78:	89 fa                	mov    %edi,%edx
c0105b7a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105b7d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105b80:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0105b86:	eb 36                	jmp    c0105bbe <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b8b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b91:	01 c2                	add    %eax,%edx
c0105b93:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b96:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b9c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105b9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ba2:	89 c1                	mov    %eax,%ecx
c0105ba4:	89 d8                	mov    %ebx,%eax
c0105ba6:	89 d6                	mov    %edx,%esi
c0105ba8:	89 c7                	mov    %eax,%edi
c0105baa:	fd                   	std    
c0105bab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105bad:	fc                   	cld    
c0105bae:	89 f8                	mov    %edi,%eax
c0105bb0:	89 f2                	mov    %esi,%edx
c0105bb2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105bb5:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105bb8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105bbe:	83 c4 30             	add    $0x30,%esp
c0105bc1:	5b                   	pop    %ebx
c0105bc2:	5e                   	pop    %esi
c0105bc3:	5f                   	pop    %edi
c0105bc4:	5d                   	pop    %ebp
c0105bc5:	c3                   	ret    

c0105bc6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105bc6:	55                   	push   %ebp
c0105bc7:	89 e5                	mov    %esp,%ebp
c0105bc9:	57                   	push   %edi
c0105bca:	56                   	push   %esi
c0105bcb:	83 ec 20             	sub    $0x20,%esp
c0105bce:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bda:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105be3:	c1 e8 02             	shr    $0x2,%eax
c0105be6:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105be8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bee:	89 d7                	mov    %edx,%edi
c0105bf0:	89 c6                	mov    %eax,%esi
c0105bf2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105bf4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105bf7:	83 e1 03             	and    $0x3,%ecx
c0105bfa:	74 02                	je     c0105bfe <memcpy+0x38>
c0105bfc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105bfe:	89 f0                	mov    %esi,%eax
c0105c00:	89 fa                	mov    %edi,%edx
c0105c02:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105c05:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105c08:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0105c0e:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105c0f:	83 c4 20             	add    $0x20,%esp
c0105c12:	5e                   	pop    %esi
c0105c13:	5f                   	pop    %edi
c0105c14:	5d                   	pop    %ebp
c0105c15:	c3                   	ret    

c0105c16 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105c16:	55                   	push   %ebp
c0105c17:	89 e5                	mov    %esp,%ebp
c0105c19:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105c1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105c22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c25:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105c28:	eb 30                	jmp    c0105c5a <memcmp+0x44>
        if (*s1 != *s2) {
c0105c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c2d:	0f b6 10             	movzbl (%eax),%edx
c0105c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c33:	0f b6 00             	movzbl (%eax),%eax
c0105c36:	38 c2                	cmp    %al,%dl
c0105c38:	74 18                	je     c0105c52 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c3d:	0f b6 00             	movzbl (%eax),%eax
c0105c40:	0f b6 d0             	movzbl %al,%edx
c0105c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c46:	0f b6 00             	movzbl (%eax),%eax
c0105c49:	0f b6 c0             	movzbl %al,%eax
c0105c4c:	29 c2                	sub    %eax,%edx
c0105c4e:	89 d0                	mov    %edx,%eax
c0105c50:	eb 1a                	jmp    c0105c6c <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105c52:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105c56:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105c5a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c5d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105c60:	89 55 10             	mov    %edx,0x10(%ebp)
c0105c63:	85 c0                	test   %eax,%eax
c0105c65:	75 c3                	jne    c0105c2a <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105c67:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c6c:	c9                   	leave  
c0105c6d:	c3                   	ret    

c0105c6e <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105c6e:	55                   	push   %ebp
c0105c6f:	89 e5                	mov    %esp,%ebp
c0105c71:	83 ec 38             	sub    $0x38,%esp
c0105c74:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c77:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105c7a:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105c80:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105c83:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105c86:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105c89:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105c8c:	8b 45 18             	mov    0x18(%ebp),%eax
c0105c8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105c95:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c98:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105c9b:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ca1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ca4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105ca8:	74 1c                	je     c0105cc6 <printnum+0x58>
c0105caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cad:	ba 00 00 00 00       	mov    $0x0,%edx
c0105cb2:	f7 75 e4             	divl   -0x1c(%ebp)
c0105cb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cbb:	ba 00 00 00 00       	mov    $0x0,%edx
c0105cc0:	f7 75 e4             	divl   -0x1c(%ebp)
c0105cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ccc:	f7 75 e4             	divl   -0x1c(%ebp)
c0105ccf:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105cd2:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105cd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105cdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105cde:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105ce1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105ce4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105ce7:	8b 45 18             	mov    0x18(%ebp),%eax
c0105cea:	ba 00 00 00 00       	mov    $0x0,%edx
c0105cef:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105cf2:	77 41                	ja     c0105d35 <printnum+0xc7>
c0105cf4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105cf7:	72 05                	jb     c0105cfe <printnum+0x90>
c0105cf9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105cfc:	77 37                	ja     c0105d35 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105cfe:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105d01:	83 e8 01             	sub    $0x1,%eax
c0105d04:	83 ec 04             	sub    $0x4,%esp
c0105d07:	ff 75 20             	pushl  0x20(%ebp)
c0105d0a:	50                   	push   %eax
c0105d0b:	ff 75 18             	pushl  0x18(%ebp)
c0105d0e:	ff 75 ec             	pushl  -0x14(%ebp)
c0105d11:	ff 75 e8             	pushl  -0x18(%ebp)
c0105d14:	ff 75 0c             	pushl  0xc(%ebp)
c0105d17:	ff 75 08             	pushl  0x8(%ebp)
c0105d1a:	e8 4f ff ff ff       	call   c0105c6e <printnum>
c0105d1f:	83 c4 20             	add    $0x20,%esp
c0105d22:	eb 1b                	jmp    c0105d3f <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105d24:	83 ec 08             	sub    $0x8,%esp
c0105d27:	ff 75 0c             	pushl  0xc(%ebp)
c0105d2a:	ff 75 20             	pushl  0x20(%ebp)
c0105d2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d30:	ff d0                	call   *%eax
c0105d32:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105d35:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105d39:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105d3d:	7f e5                	jg     c0105d24 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105d3f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105d42:	05 34 74 10 c0       	add    $0xc0107434,%eax
c0105d47:	0f b6 00             	movzbl (%eax),%eax
c0105d4a:	0f be c0             	movsbl %al,%eax
c0105d4d:	83 ec 08             	sub    $0x8,%esp
c0105d50:	ff 75 0c             	pushl  0xc(%ebp)
c0105d53:	50                   	push   %eax
c0105d54:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d57:	ff d0                	call   *%eax
c0105d59:	83 c4 10             	add    $0x10,%esp
}
c0105d5c:	90                   	nop
c0105d5d:	c9                   	leave  
c0105d5e:	c3                   	ret    

c0105d5f <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105d5f:	55                   	push   %ebp
c0105d60:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105d62:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105d66:	7e 14                	jle    c0105d7c <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105d68:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d6b:	8b 00                	mov    (%eax),%eax
c0105d6d:	8d 48 08             	lea    0x8(%eax),%ecx
c0105d70:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d73:	89 0a                	mov    %ecx,(%edx)
c0105d75:	8b 50 04             	mov    0x4(%eax),%edx
c0105d78:	8b 00                	mov    (%eax),%eax
c0105d7a:	eb 30                	jmp    c0105dac <getuint+0x4d>
    }
    else if (lflag) {
c0105d7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d80:	74 16                	je     c0105d98 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105d82:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d85:	8b 00                	mov    (%eax),%eax
c0105d87:	8d 48 04             	lea    0x4(%eax),%ecx
c0105d8a:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d8d:	89 0a                	mov    %ecx,(%edx)
c0105d8f:	8b 00                	mov    (%eax),%eax
c0105d91:	ba 00 00 00 00       	mov    $0x0,%edx
c0105d96:	eb 14                	jmp    c0105dac <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105d98:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9b:	8b 00                	mov    (%eax),%eax
c0105d9d:	8d 48 04             	lea    0x4(%eax),%ecx
c0105da0:	8b 55 08             	mov    0x8(%ebp),%edx
c0105da3:	89 0a                	mov    %ecx,(%edx)
c0105da5:	8b 00                	mov    (%eax),%eax
c0105da7:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105dac:	5d                   	pop    %ebp
c0105dad:	c3                   	ret    

c0105dae <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105dae:	55                   	push   %ebp
c0105daf:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105db1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105db5:	7e 14                	jle    c0105dcb <getint+0x1d>
        return va_arg(*ap, long long);
c0105db7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dba:	8b 00                	mov    (%eax),%eax
c0105dbc:	8d 48 08             	lea    0x8(%eax),%ecx
c0105dbf:	8b 55 08             	mov    0x8(%ebp),%edx
c0105dc2:	89 0a                	mov    %ecx,(%edx)
c0105dc4:	8b 50 04             	mov    0x4(%eax),%edx
c0105dc7:	8b 00                	mov    (%eax),%eax
c0105dc9:	eb 28                	jmp    c0105df3 <getint+0x45>
    }
    else if (lflag) {
c0105dcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105dcf:	74 12                	je     c0105de3 <getint+0x35>
        return va_arg(*ap, long);
c0105dd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd4:	8b 00                	mov    (%eax),%eax
c0105dd6:	8d 48 04             	lea    0x4(%eax),%ecx
c0105dd9:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ddc:	89 0a                	mov    %ecx,(%edx)
c0105dde:	8b 00                	mov    (%eax),%eax
c0105de0:	99                   	cltd   
c0105de1:	eb 10                	jmp    c0105df3 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105de3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de6:	8b 00                	mov    (%eax),%eax
c0105de8:	8d 48 04             	lea    0x4(%eax),%ecx
c0105deb:	8b 55 08             	mov    0x8(%ebp),%edx
c0105dee:	89 0a                	mov    %ecx,(%edx)
c0105df0:	8b 00                	mov    (%eax),%eax
c0105df2:	99                   	cltd   
    }
}
c0105df3:	5d                   	pop    %ebp
c0105df4:	c3                   	ret    

c0105df5 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105df5:	55                   	push   %ebp
c0105df6:	89 e5                	mov    %esp,%ebp
c0105df8:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c0105dfb:	8d 45 14             	lea    0x14(%ebp),%eax
c0105dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e04:	50                   	push   %eax
c0105e05:	ff 75 10             	pushl  0x10(%ebp)
c0105e08:	ff 75 0c             	pushl  0xc(%ebp)
c0105e0b:	ff 75 08             	pushl  0x8(%ebp)
c0105e0e:	e8 06 00 00 00       	call   c0105e19 <vprintfmt>
c0105e13:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0105e16:	90                   	nop
c0105e17:	c9                   	leave  
c0105e18:	c3                   	ret    

c0105e19 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105e19:	55                   	push   %ebp
c0105e1a:	89 e5                	mov    %esp,%ebp
c0105e1c:	56                   	push   %esi
c0105e1d:	53                   	push   %ebx
c0105e1e:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105e21:	eb 17                	jmp    c0105e3a <vprintfmt+0x21>
            if (ch == '\0') {
c0105e23:	85 db                	test   %ebx,%ebx
c0105e25:	0f 84 8e 03 00 00    	je     c01061b9 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c0105e2b:	83 ec 08             	sub    $0x8,%esp
c0105e2e:	ff 75 0c             	pushl  0xc(%ebp)
c0105e31:	53                   	push   %ebx
c0105e32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e35:	ff d0                	call   *%eax
c0105e37:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105e3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e3d:	8d 50 01             	lea    0x1(%eax),%edx
c0105e40:	89 55 10             	mov    %edx,0x10(%ebp)
c0105e43:	0f b6 00             	movzbl (%eax),%eax
c0105e46:	0f b6 d8             	movzbl %al,%ebx
c0105e49:	83 fb 25             	cmp    $0x25,%ebx
c0105e4c:	75 d5                	jne    c0105e23 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105e4e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105e52:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105e59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105e5f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105e66:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e69:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105e6c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e6f:	8d 50 01             	lea    0x1(%eax),%edx
c0105e72:	89 55 10             	mov    %edx,0x10(%ebp)
c0105e75:	0f b6 00             	movzbl (%eax),%eax
c0105e78:	0f b6 d8             	movzbl %al,%ebx
c0105e7b:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105e7e:	83 f8 55             	cmp    $0x55,%eax
c0105e81:	0f 87 05 03 00 00    	ja     c010618c <vprintfmt+0x373>
c0105e87:	8b 04 85 58 74 10 c0 	mov    -0x3fef8ba8(,%eax,4),%eax
c0105e8e:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105e90:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105e94:	eb d6                	jmp    c0105e6c <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105e96:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105e9a:	eb d0                	jmp    c0105e6c <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105e9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105ea3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ea6:	89 d0                	mov    %edx,%eax
c0105ea8:	c1 e0 02             	shl    $0x2,%eax
c0105eab:	01 d0                	add    %edx,%eax
c0105ead:	01 c0                	add    %eax,%eax
c0105eaf:	01 d8                	add    %ebx,%eax
c0105eb1:	83 e8 30             	sub    $0x30,%eax
c0105eb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105eb7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105eba:	0f b6 00             	movzbl (%eax),%eax
c0105ebd:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105ec0:	83 fb 2f             	cmp    $0x2f,%ebx
c0105ec3:	7e 39                	jle    c0105efe <vprintfmt+0xe5>
c0105ec5:	83 fb 39             	cmp    $0x39,%ebx
c0105ec8:	7f 34                	jg     c0105efe <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105eca:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105ece:	eb d3                	jmp    c0105ea3 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105ed0:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ed3:	8d 50 04             	lea    0x4(%eax),%edx
c0105ed6:	89 55 14             	mov    %edx,0x14(%ebp)
c0105ed9:	8b 00                	mov    (%eax),%eax
c0105edb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105ede:	eb 1f                	jmp    c0105eff <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c0105ee0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105ee4:	79 86                	jns    c0105e6c <vprintfmt+0x53>
                width = 0;
c0105ee6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105eed:	e9 7a ff ff ff       	jmp    c0105e6c <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105ef2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105ef9:	e9 6e ff ff ff       	jmp    c0105e6c <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c0105efe:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c0105eff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105f03:	0f 89 63 ff ff ff    	jns    c0105e6c <vprintfmt+0x53>
                width = precision, precision = -1;
c0105f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105f0f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105f16:	e9 51 ff ff ff       	jmp    c0105e6c <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105f1b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105f1f:	e9 48 ff ff ff       	jmp    c0105e6c <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105f24:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f27:	8d 50 04             	lea    0x4(%eax),%edx
c0105f2a:	89 55 14             	mov    %edx,0x14(%ebp)
c0105f2d:	8b 00                	mov    (%eax),%eax
c0105f2f:	83 ec 08             	sub    $0x8,%esp
c0105f32:	ff 75 0c             	pushl  0xc(%ebp)
c0105f35:	50                   	push   %eax
c0105f36:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f39:	ff d0                	call   *%eax
c0105f3b:	83 c4 10             	add    $0x10,%esp
            break;
c0105f3e:	e9 71 02 00 00       	jmp    c01061b4 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105f43:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f46:	8d 50 04             	lea    0x4(%eax),%edx
c0105f49:	89 55 14             	mov    %edx,0x14(%ebp)
c0105f4c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105f4e:	85 db                	test   %ebx,%ebx
c0105f50:	79 02                	jns    c0105f54 <vprintfmt+0x13b>
                err = -err;
c0105f52:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105f54:	83 fb 06             	cmp    $0x6,%ebx
c0105f57:	7f 0b                	jg     c0105f64 <vprintfmt+0x14b>
c0105f59:	8b 34 9d 18 74 10 c0 	mov    -0x3fef8be8(,%ebx,4),%esi
c0105f60:	85 f6                	test   %esi,%esi
c0105f62:	75 19                	jne    c0105f7d <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c0105f64:	53                   	push   %ebx
c0105f65:	68 45 74 10 c0       	push   $0xc0107445
c0105f6a:	ff 75 0c             	pushl  0xc(%ebp)
c0105f6d:	ff 75 08             	pushl  0x8(%ebp)
c0105f70:	e8 80 fe ff ff       	call   c0105df5 <printfmt>
c0105f75:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105f78:	e9 37 02 00 00       	jmp    c01061b4 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105f7d:	56                   	push   %esi
c0105f7e:	68 4e 74 10 c0       	push   $0xc010744e
c0105f83:	ff 75 0c             	pushl  0xc(%ebp)
c0105f86:	ff 75 08             	pushl  0x8(%ebp)
c0105f89:	e8 67 fe ff ff       	call   c0105df5 <printfmt>
c0105f8e:	83 c4 10             	add    $0x10,%esp
            }
            break;
c0105f91:	e9 1e 02 00 00       	jmp    c01061b4 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105f96:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f99:	8d 50 04             	lea    0x4(%eax),%edx
c0105f9c:	89 55 14             	mov    %edx,0x14(%ebp)
c0105f9f:	8b 30                	mov    (%eax),%esi
c0105fa1:	85 f6                	test   %esi,%esi
c0105fa3:	75 05                	jne    c0105faa <vprintfmt+0x191>
                p = "(null)";
c0105fa5:	be 51 74 10 c0       	mov    $0xc0107451,%esi
            }
            if (width > 0 && padc != '-') {
c0105faa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105fae:	7e 76                	jle    c0106026 <vprintfmt+0x20d>
c0105fb0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105fb4:	74 70                	je     c0106026 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105fb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fb9:	83 ec 08             	sub    $0x8,%esp
c0105fbc:	50                   	push   %eax
c0105fbd:	56                   	push   %esi
c0105fbe:	e8 17 f8 ff ff       	call   c01057da <strnlen>
c0105fc3:	83 c4 10             	add    $0x10,%esp
c0105fc6:	89 c2                	mov    %eax,%edx
c0105fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105fcb:	29 d0                	sub    %edx,%eax
c0105fcd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105fd0:	eb 17                	jmp    c0105fe9 <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0105fd2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105fd6:	83 ec 08             	sub    $0x8,%esp
c0105fd9:	ff 75 0c             	pushl  0xc(%ebp)
c0105fdc:	50                   	push   %eax
c0105fdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fe0:	ff d0                	call   *%eax
c0105fe2:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105fe5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105fe9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105fed:	7f e3                	jg     c0105fd2 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105fef:	eb 35                	jmp    c0106026 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105ff1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105ff5:	74 1c                	je     c0106013 <vprintfmt+0x1fa>
c0105ff7:	83 fb 1f             	cmp    $0x1f,%ebx
c0105ffa:	7e 05                	jle    c0106001 <vprintfmt+0x1e8>
c0105ffc:	83 fb 7e             	cmp    $0x7e,%ebx
c0105fff:	7e 12                	jle    c0106013 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0106001:	83 ec 08             	sub    $0x8,%esp
c0106004:	ff 75 0c             	pushl  0xc(%ebp)
c0106007:	6a 3f                	push   $0x3f
c0106009:	8b 45 08             	mov    0x8(%ebp),%eax
c010600c:	ff d0                	call   *%eax
c010600e:	83 c4 10             	add    $0x10,%esp
c0106011:	eb 0f                	jmp    c0106022 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0106013:	83 ec 08             	sub    $0x8,%esp
c0106016:	ff 75 0c             	pushl  0xc(%ebp)
c0106019:	53                   	push   %ebx
c010601a:	8b 45 08             	mov    0x8(%ebp),%eax
c010601d:	ff d0                	call   *%eax
c010601f:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106022:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0106026:	89 f0                	mov    %esi,%eax
c0106028:	8d 70 01             	lea    0x1(%eax),%esi
c010602b:	0f b6 00             	movzbl (%eax),%eax
c010602e:	0f be d8             	movsbl %al,%ebx
c0106031:	85 db                	test   %ebx,%ebx
c0106033:	74 26                	je     c010605b <vprintfmt+0x242>
c0106035:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106039:	78 b6                	js     c0105ff1 <vprintfmt+0x1d8>
c010603b:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010603f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106043:	79 ac                	jns    c0105ff1 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0106045:	eb 14                	jmp    c010605b <vprintfmt+0x242>
                putch(' ', putdat);
c0106047:	83 ec 08             	sub    $0x8,%esp
c010604a:	ff 75 0c             	pushl  0xc(%ebp)
c010604d:	6a 20                	push   $0x20
c010604f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106052:	ff d0                	call   *%eax
c0106054:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0106057:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010605b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010605f:	7f e6                	jg     c0106047 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c0106061:	e9 4e 01 00 00       	jmp    c01061b4 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0106066:	83 ec 08             	sub    $0x8,%esp
c0106069:	ff 75 e0             	pushl  -0x20(%ebp)
c010606c:	8d 45 14             	lea    0x14(%ebp),%eax
c010606f:	50                   	push   %eax
c0106070:	e8 39 fd ff ff       	call   c0105dae <getint>
c0106075:	83 c4 10             	add    $0x10,%esp
c0106078:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010607b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010607e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106081:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106084:	85 d2                	test   %edx,%edx
c0106086:	79 23                	jns    c01060ab <vprintfmt+0x292>
                putch('-', putdat);
c0106088:	83 ec 08             	sub    $0x8,%esp
c010608b:	ff 75 0c             	pushl  0xc(%ebp)
c010608e:	6a 2d                	push   $0x2d
c0106090:	8b 45 08             	mov    0x8(%ebp),%eax
c0106093:	ff d0                	call   *%eax
c0106095:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0106098:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010609b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010609e:	f7 d8                	neg    %eax
c01060a0:	83 d2 00             	adc    $0x0,%edx
c01060a3:	f7 da                	neg    %edx
c01060a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01060ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01060b2:	e9 9f 00 00 00       	jmp    c0106156 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01060b7:	83 ec 08             	sub    $0x8,%esp
c01060ba:	ff 75 e0             	pushl  -0x20(%ebp)
c01060bd:	8d 45 14             	lea    0x14(%ebp),%eax
c01060c0:	50                   	push   %eax
c01060c1:	e8 99 fc ff ff       	call   c0105d5f <getuint>
c01060c6:	83 c4 10             	add    $0x10,%esp
c01060c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01060cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01060d6:	eb 7e                	jmp    c0106156 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01060d8:	83 ec 08             	sub    $0x8,%esp
c01060db:	ff 75 e0             	pushl  -0x20(%ebp)
c01060de:	8d 45 14             	lea    0x14(%ebp),%eax
c01060e1:	50                   	push   %eax
c01060e2:	e8 78 fc ff ff       	call   c0105d5f <getuint>
c01060e7:	83 c4 10             	add    $0x10,%esp
c01060ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01060f0:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01060f7:	eb 5d                	jmp    c0106156 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c01060f9:	83 ec 08             	sub    $0x8,%esp
c01060fc:	ff 75 0c             	pushl  0xc(%ebp)
c01060ff:	6a 30                	push   $0x30
c0106101:	8b 45 08             	mov    0x8(%ebp),%eax
c0106104:	ff d0                	call   *%eax
c0106106:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0106109:	83 ec 08             	sub    $0x8,%esp
c010610c:	ff 75 0c             	pushl  0xc(%ebp)
c010610f:	6a 78                	push   $0x78
c0106111:	8b 45 08             	mov    0x8(%ebp),%eax
c0106114:	ff d0                	call   *%eax
c0106116:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0106119:	8b 45 14             	mov    0x14(%ebp),%eax
c010611c:	8d 50 04             	lea    0x4(%eax),%edx
c010611f:	89 55 14             	mov    %edx,0x14(%ebp)
c0106122:	8b 00                	mov    (%eax),%eax
c0106124:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106127:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010612e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0106135:	eb 1f                	jmp    c0106156 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0106137:	83 ec 08             	sub    $0x8,%esp
c010613a:	ff 75 e0             	pushl  -0x20(%ebp)
c010613d:	8d 45 14             	lea    0x14(%ebp),%eax
c0106140:	50                   	push   %eax
c0106141:	e8 19 fc ff ff       	call   c0105d5f <getuint>
c0106146:	83 c4 10             	add    $0x10,%esp
c0106149:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010614c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010614f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0106156:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010615a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010615d:	83 ec 04             	sub    $0x4,%esp
c0106160:	52                   	push   %edx
c0106161:	ff 75 e8             	pushl  -0x18(%ebp)
c0106164:	50                   	push   %eax
c0106165:	ff 75 f4             	pushl  -0xc(%ebp)
c0106168:	ff 75 f0             	pushl  -0x10(%ebp)
c010616b:	ff 75 0c             	pushl  0xc(%ebp)
c010616e:	ff 75 08             	pushl  0x8(%ebp)
c0106171:	e8 f8 fa ff ff       	call   c0105c6e <printnum>
c0106176:	83 c4 20             	add    $0x20,%esp
            break;
c0106179:	eb 39                	jmp    c01061b4 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010617b:	83 ec 08             	sub    $0x8,%esp
c010617e:	ff 75 0c             	pushl  0xc(%ebp)
c0106181:	53                   	push   %ebx
c0106182:	8b 45 08             	mov    0x8(%ebp),%eax
c0106185:	ff d0                	call   *%eax
c0106187:	83 c4 10             	add    $0x10,%esp
            break;
c010618a:	eb 28                	jmp    c01061b4 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010618c:	83 ec 08             	sub    $0x8,%esp
c010618f:	ff 75 0c             	pushl  0xc(%ebp)
c0106192:	6a 25                	push   $0x25
c0106194:	8b 45 08             	mov    0x8(%ebp),%eax
c0106197:	ff d0                	call   *%eax
c0106199:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c010619c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01061a0:	eb 04                	jmp    c01061a6 <vprintfmt+0x38d>
c01061a2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01061a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01061a9:	83 e8 01             	sub    $0x1,%eax
c01061ac:	0f b6 00             	movzbl (%eax),%eax
c01061af:	3c 25                	cmp    $0x25,%al
c01061b1:	75 ef                	jne    c01061a2 <vprintfmt+0x389>
                /* do nothing */;
            break;
c01061b3:	90                   	nop
        }
    }
c01061b4:	e9 68 fc ff ff       	jmp    c0105e21 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c01061b9:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01061ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01061bd:	5b                   	pop    %ebx
c01061be:	5e                   	pop    %esi
c01061bf:	5d                   	pop    %ebp
c01061c0:	c3                   	ret    

c01061c1 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01061c1:	55                   	push   %ebp
c01061c2:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01061c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061c7:	8b 40 08             	mov    0x8(%eax),%eax
c01061ca:	8d 50 01             	lea    0x1(%eax),%edx
c01061cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061d0:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01061d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061d6:	8b 10                	mov    (%eax),%edx
c01061d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061db:	8b 40 04             	mov    0x4(%eax),%eax
c01061de:	39 c2                	cmp    %eax,%edx
c01061e0:	73 12                	jae    c01061f4 <sprintputch+0x33>
        *b->buf ++ = ch;
c01061e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061e5:	8b 00                	mov    (%eax),%eax
c01061e7:	8d 48 01             	lea    0x1(%eax),%ecx
c01061ea:	8b 55 0c             	mov    0xc(%ebp),%edx
c01061ed:	89 0a                	mov    %ecx,(%edx)
c01061ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01061f2:	88 10                	mov    %dl,(%eax)
    }
}
c01061f4:	90                   	nop
c01061f5:	5d                   	pop    %ebp
c01061f6:	c3                   	ret    

c01061f7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01061f7:	55                   	push   %ebp
c01061f8:	89 e5                	mov    %esp,%ebp
c01061fa:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01061fd:	8d 45 14             	lea    0x14(%ebp),%eax
c0106200:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0106203:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106206:	50                   	push   %eax
c0106207:	ff 75 10             	pushl  0x10(%ebp)
c010620a:	ff 75 0c             	pushl  0xc(%ebp)
c010620d:	ff 75 08             	pushl  0x8(%ebp)
c0106210:	e8 0b 00 00 00       	call   c0106220 <vsnprintf>
c0106215:	83 c4 10             	add    $0x10,%esp
c0106218:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010621b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010621e:	c9                   	leave  
c010621f:	c3                   	ret    

c0106220 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0106220:	55                   	push   %ebp
c0106221:	89 e5                	mov    %esp,%ebp
c0106223:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0106226:	8b 45 08             	mov    0x8(%ebp),%eax
c0106229:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010622c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010622f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106232:	8b 45 08             	mov    0x8(%ebp),%eax
c0106235:	01 d0                	add    %edx,%eax
c0106237:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010623a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0106241:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106245:	74 0a                	je     c0106251 <vsnprintf+0x31>
c0106247:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010624a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010624d:	39 c2                	cmp    %eax,%edx
c010624f:	76 07                	jbe    c0106258 <vsnprintf+0x38>
        return -E_INVAL;
c0106251:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0106256:	eb 20                	jmp    c0106278 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0106258:	ff 75 14             	pushl  0x14(%ebp)
c010625b:	ff 75 10             	pushl  0x10(%ebp)
c010625e:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0106261:	50                   	push   %eax
c0106262:	68 c1 61 10 c0       	push   $0xc01061c1
c0106267:	e8 ad fb ff ff       	call   c0105e19 <vprintfmt>
c010626c:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c010626f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106272:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0106275:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106278:	c9                   	leave  
c0106279:	c3                   	ret    

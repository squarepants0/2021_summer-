
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 30 80 11 40 	lgdtl  0x40118030
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 80 11 00       	mov    $0x118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 88 99 11 00       	mov    $0x119988,%edx
  100035:	b8 56 8a 11 00       	mov    $0x118a56,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	83 ec 04             	sub    $0x4,%esp
  100041:	50                   	push   %eax
  100042:	6a 00                	push   $0x0
  100044:	68 56 8a 11 00       	push   $0x118a56
  100049:	e8 95 5a 00 00       	call   105ae3 <memset>
  10004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100051:	e8 6a 15 00 00       	call   1015c0 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100056:	c7 45 f4 80 62 10 00 	movl   $0x106280,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10005d:	83 ec 08             	sub    $0x8,%esp
  100060:	ff 75 f4             	pushl  -0xc(%ebp)
  100063:	68 9c 62 10 00       	push   $0x10629c
  100068:	e8 fe 01 00 00       	call   10026b <cprintf>
  10006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100070:	e8 80 08 00 00       	call   1008f5 <print_kerninfo>

    grade_backtrace();
  100075:	e8 74 00 00 00       	call   1000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007a:	e8 1f 31 00 00       	call   10319e <pmm_init>

    pic_init();                 // init interrupt controller
  10007f:	e8 ae 16 00 00       	call   101732 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100084:	e8 0f 18 00 00       	call   101898 <idt_init>

    clock_init();               // init clock interrupt
  100089:	e8 d9 0c 00 00       	call   100d67 <clock_init>
    intr_enable();              // enable irq interrupt
  10008e:	e8 dc 17 00 00       	call   10186f <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    // lab1_switch_test();

    /* do nothing */
    while (1);
  100093:	eb fe                	jmp    100093 <kern_init+0x69>

00100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100095:	55                   	push   %ebp
  100096:	89 e5                	mov    %esp,%ebp
  100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  10009b:	83 ec 04             	sub    $0x4,%esp
  10009e:	6a 00                	push   $0x0
  1000a0:	6a 00                	push   $0x0
  1000a2:	6a 00                	push   $0x0
  1000a4:	e8 ac 0c 00 00       	call   100d55 <mon_backtrace>
  1000a9:	83 c4 10             	add    $0x10,%esp
}
  1000ac:	90                   	nop
  1000ad:	c9                   	leave  
  1000ae:	c3                   	ret    

001000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	53                   	push   %ebx
  1000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1000c2:	51                   	push   %ecx
  1000c3:	52                   	push   %edx
  1000c4:	53                   	push   %ebx
  1000c5:	50                   	push   %eax
  1000c6:	e8 ca ff ff ff       	call   100095 <grade_backtrace2>
  1000cb:	83 c4 10             	add    $0x10,%esp
}
  1000ce:	90                   	nop
  1000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000d2:	c9                   	leave  
  1000d3:	c3                   	ret    

001000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	83 ec 08             	sub    $0x8,%esp
  1000dd:	ff 75 10             	pushl  0x10(%ebp)
  1000e0:	ff 75 08             	pushl  0x8(%ebp)
  1000e3:	e8 c7 ff ff ff       	call   1000af <grade_backtrace1>
  1000e8:	83 c4 10             	add    $0x10,%esp
}
  1000eb:	90                   	nop
  1000ec:	c9                   	leave  
  1000ed:	c3                   	ret    

001000ee <grade_backtrace>:

void
grade_backtrace(void) {
  1000ee:	55                   	push   %ebp
  1000ef:	89 e5                	mov    %esp,%ebp
  1000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f4:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1000f9:	83 ec 04             	sub    $0x4,%esp
  1000fc:	68 00 00 ff ff       	push   $0xffff0000
  100101:	50                   	push   %eax
  100102:	6a 00                	push   $0x0
  100104:	e8 cb ff ff ff       	call   1000d4 <grade_backtrace0>
  100109:	83 c4 10             	add    $0x10,%esp
}
  10010c:	90                   	nop
  10010d:	c9                   	leave  
  10010e:	c3                   	ret    

0010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10010f:	55                   	push   %ebp
  100110:	89 e5                	mov    %esp,%ebp
  100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100125:	0f b7 c0             	movzwl %ax,%eax
  100128:	83 e0 03             	and    $0x3,%eax
  10012b:	89 c2                	mov    %eax,%edx
  10012d:	a1 60 8a 11 00       	mov    0x118a60,%eax
  100132:	83 ec 04             	sub    $0x4,%esp
  100135:	52                   	push   %edx
  100136:	50                   	push   %eax
  100137:	68 a1 62 10 00       	push   $0x1062a1
  10013c:	e8 2a 01 00 00       	call   10026b <cprintf>
  100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100148:	0f b7 d0             	movzwl %ax,%edx
  10014b:	a1 60 8a 11 00       	mov    0x118a60,%eax
  100150:	83 ec 04             	sub    $0x4,%esp
  100153:	52                   	push   %edx
  100154:	50                   	push   %eax
  100155:	68 af 62 10 00       	push   $0x1062af
  10015a:	e8 0c 01 00 00       	call   10026b <cprintf>
  10015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100166:	0f b7 d0             	movzwl %ax,%edx
  100169:	a1 60 8a 11 00       	mov    0x118a60,%eax
  10016e:	83 ec 04             	sub    $0x4,%esp
  100171:	52                   	push   %edx
  100172:	50                   	push   %eax
  100173:	68 bd 62 10 00       	push   $0x1062bd
  100178:	e8 ee 00 00 00       	call   10026b <cprintf>
  10017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100184:	0f b7 d0             	movzwl %ax,%edx
  100187:	a1 60 8a 11 00       	mov    0x118a60,%eax
  10018c:	83 ec 04             	sub    $0x4,%esp
  10018f:	52                   	push   %edx
  100190:	50                   	push   %eax
  100191:	68 cb 62 10 00       	push   $0x1062cb
  100196:	e8 d0 00 00 00       	call   10026b <cprintf>
  10019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  10019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a2:	0f b7 d0             	movzwl %ax,%edx
  1001a5:	a1 60 8a 11 00       	mov    0x118a60,%eax
  1001aa:	83 ec 04             	sub    $0x4,%esp
  1001ad:	52                   	push   %edx
  1001ae:	50                   	push   %eax
  1001af:	68 d9 62 10 00       	push   $0x1062d9
  1001b4:	e8 b2 00 00 00       	call   10026b <cprintf>
  1001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
  1001bc:	a1 60 8a 11 00       	mov    0x118a60,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 60 8a 11 00       	mov    %eax,0x118a60
}
  1001c9:	90                   	nop
  1001ca:	c9                   	leave  
  1001cb:	c3                   	ret    

001001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cc:	55                   	push   %ebp
  1001cd:	89 e5                	mov    %esp,%ebp
    asm volatile (
  1001cf:	cd 78                	int    $0x78
        "int %0 \n"
        :
        : "i"(T_SWITCH_TOU)
    );
}
  1001d1:	90                   	nop
  1001d2:	5d                   	pop    %ebp
  1001d3:	c3                   	ret    

001001d4 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d4:	55                   	push   %ebp
  1001d5:	89 e5                	mov    %esp,%ebp
    asm volatile (
  1001d7:	cd 79                	int    $0x79
        "int %0 \n"
        :
        : "i"(T_SWITCH_TOK)
    );
}
  1001d9:	90                   	nop
  1001da:	5d                   	pop    %ebp
  1001db:	c3                   	ret    

001001dc <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001dc:	55                   	push   %ebp
  1001dd:	89 e5                	mov    %esp,%ebp
  1001df:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001e2:	e8 28 ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e7:	83 ec 0c             	sub    $0xc,%esp
  1001ea:	68 e8 62 10 00       	push   $0x1062e8
  1001ef:	e8 77 00 00 00       	call   10026b <cprintf>
  1001f4:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001f7:	e8 d0 ff ff ff       	call   1001cc <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fc:	e8 0e ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100201:	83 ec 0c             	sub    $0xc,%esp
  100204:	68 08 63 10 00       	push   $0x106308
  100209:	e8 5d 00 00 00       	call   10026b <cprintf>
  10020e:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  100211:	e8 be ff ff ff       	call   1001d4 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100216:	e8 f4 fe ff ff       	call   10010f <lab1_print_cur_status>
}
  10021b:	90                   	nop
  10021c:	c9                   	leave  
  10021d:	c3                   	ret    

0010021e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10021e:	55                   	push   %ebp
  10021f:	89 e5                	mov    %esp,%ebp
  100221:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100224:	83 ec 0c             	sub    $0xc,%esp
  100227:	ff 75 08             	pushl  0x8(%ebp)
  10022a:	e8 c2 13 00 00       	call   1015f1 <cons_putc>
  10022f:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100232:	8b 45 0c             	mov    0xc(%ebp),%eax
  100235:	8b 00                	mov    (%eax),%eax
  100237:	8d 50 01             	lea    0x1(%eax),%edx
  10023a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10023d:	89 10                	mov    %edx,(%eax)
}
  10023f:	90                   	nop
  100240:	c9                   	leave  
  100241:	c3                   	ret    

00100242 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100242:	55                   	push   %ebp
  100243:	89 e5                	mov    %esp,%ebp
  100245:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100248:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10024f:	ff 75 0c             	pushl  0xc(%ebp)
  100252:	ff 75 08             	pushl  0x8(%ebp)
  100255:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100258:	50                   	push   %eax
  100259:	68 1e 02 10 00       	push   $0x10021e
  10025e:	e8 b6 5b 00 00       	call   105e19 <vprintfmt>
  100263:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100266:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100269:	c9                   	leave  
  10026a:	c3                   	ret    

0010026b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10026b:	55                   	push   %ebp
  10026c:	89 e5                	mov    %esp,%ebp
  10026e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100271:	8d 45 0c             	lea    0xc(%ebp),%eax
  100274:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10027a:	83 ec 08             	sub    $0x8,%esp
  10027d:	50                   	push   %eax
  10027e:	ff 75 08             	pushl  0x8(%ebp)
  100281:	e8 bc ff ff ff       	call   100242 <vcprintf>
  100286:	83 c4 10             	add    $0x10,%esp
  100289:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10028c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10028f:	c9                   	leave  
  100290:	c3                   	ret    

00100291 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100291:	55                   	push   %ebp
  100292:	89 e5                	mov    %esp,%ebp
  100294:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100297:	83 ec 0c             	sub    $0xc,%esp
  10029a:	ff 75 08             	pushl  0x8(%ebp)
  10029d:	e8 4f 13 00 00       	call   1015f1 <cons_putc>
  1002a2:	83 c4 10             	add    $0x10,%esp
}
  1002a5:	90                   	nop
  1002a6:	c9                   	leave  
  1002a7:	c3                   	ret    

001002a8 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a8:	55                   	push   %ebp
  1002a9:	89 e5                	mov    %esp,%ebp
  1002ab:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b5:	eb 14                	jmp    1002cb <cputs+0x23>
        cputch(c, &cnt);
  1002b7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002bb:	83 ec 08             	sub    $0x8,%esp
  1002be:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002c1:	52                   	push   %edx
  1002c2:	50                   	push   %eax
  1002c3:	e8 56 ff ff ff       	call   10021e <cputch>
  1002c8:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ce:	8d 50 01             	lea    0x1(%eax),%edx
  1002d1:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d4:	0f b6 00             	movzbl (%eax),%eax
  1002d7:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002da:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002de:	75 d7                	jne    1002b7 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002e0:	83 ec 08             	sub    $0x8,%esp
  1002e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e6:	50                   	push   %eax
  1002e7:	6a 0a                	push   $0xa
  1002e9:	e8 30 ff ff ff       	call   10021e <cputch>
  1002ee:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f4:	c9                   	leave  
  1002f5:	c3                   	ret    

001002f6 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f6:	55                   	push   %ebp
  1002f7:	89 e5                	mov    %esp,%ebp
  1002f9:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002fc:	e8 39 13 00 00       	call   10163a <cons_getc>
  100301:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100304:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100308:	74 f2                	je     1002fc <getchar+0x6>
        /* do nothing */;
    return c;
  10030a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10030d:	c9                   	leave  
  10030e:	c3                   	ret    

0010030f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10030f:	55                   	push   %ebp
  100310:	89 e5                	mov    %esp,%ebp
  100312:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100315:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100319:	74 13                	je     10032e <readline+0x1f>
        cprintf("%s", prompt);
  10031b:	83 ec 08             	sub    $0x8,%esp
  10031e:	ff 75 08             	pushl  0x8(%ebp)
  100321:	68 27 63 10 00       	push   $0x106327
  100326:	e8 40 ff ff ff       	call   10026b <cprintf>
  10032b:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10032e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100335:	e8 bc ff ff ff       	call   1002f6 <getchar>
  10033a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10033d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100341:	79 0a                	jns    10034d <readline+0x3e>
            return NULL;
  100343:	b8 00 00 00 00       	mov    $0x0,%eax
  100348:	e9 82 00 00 00       	jmp    1003cf <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10034d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100351:	7e 2b                	jle    10037e <readline+0x6f>
  100353:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10035a:	7f 22                	jg     10037e <readline+0x6f>
            cputchar(c);
  10035c:	83 ec 0c             	sub    $0xc,%esp
  10035f:	ff 75 f0             	pushl  -0x10(%ebp)
  100362:	e8 2a ff ff ff       	call   100291 <cputchar>
  100367:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10036a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10036d:	8d 50 01             	lea    0x1(%eax),%edx
  100370:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100373:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100376:	88 90 80 8a 11 00    	mov    %dl,0x118a80(%eax)
  10037c:	eb 4c                	jmp    1003ca <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10037e:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100382:	75 1a                	jne    10039e <readline+0x8f>
  100384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100388:	7e 14                	jle    10039e <readline+0x8f>
            cputchar(c);
  10038a:	83 ec 0c             	sub    $0xc,%esp
  10038d:	ff 75 f0             	pushl  -0x10(%ebp)
  100390:	e8 fc fe ff ff       	call   100291 <cputchar>
  100395:	83 c4 10             	add    $0x10,%esp
            i --;
  100398:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10039c:	eb 2c                	jmp    1003ca <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  10039e:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003a2:	74 06                	je     1003aa <readline+0x9b>
  1003a4:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003a8:	75 8b                	jne    100335 <readline+0x26>
            cputchar(c);
  1003aa:	83 ec 0c             	sub    $0xc,%esp
  1003ad:	ff 75 f0             	pushl  -0x10(%ebp)
  1003b0:	e8 dc fe ff ff       	call   100291 <cputchar>
  1003b5:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1003b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003bb:	05 80 8a 11 00       	add    $0x118a80,%eax
  1003c0:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003c3:	b8 80 8a 11 00       	mov    $0x118a80,%eax
  1003c8:	eb 05                	jmp    1003cf <readline+0xc0>
        }
    }
  1003ca:	e9 66 ff ff ff       	jmp    100335 <readline+0x26>
}
  1003cf:	c9                   	leave  
  1003d0:	c3                   	ret    

001003d1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003d1:	55                   	push   %ebp
  1003d2:	89 e5                	mov    %esp,%ebp
  1003d4:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003d7:	a1 80 8e 11 00       	mov    0x118e80,%eax
  1003dc:	85 c0                	test   %eax,%eax
  1003de:	75 4a                	jne    10042a <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003e0:	c7 05 80 8e 11 00 01 	movl   $0x1,0x118e80
  1003e7:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003ea:	8d 45 14             	lea    0x14(%ebp),%eax
  1003ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003f0:	83 ec 04             	sub    $0x4,%esp
  1003f3:	ff 75 0c             	pushl  0xc(%ebp)
  1003f6:	ff 75 08             	pushl  0x8(%ebp)
  1003f9:	68 2a 63 10 00       	push   $0x10632a
  1003fe:	e8 68 fe ff ff       	call   10026b <cprintf>
  100403:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100409:	83 ec 08             	sub    $0x8,%esp
  10040c:	50                   	push   %eax
  10040d:	ff 75 10             	pushl  0x10(%ebp)
  100410:	e8 2d fe ff ff       	call   100242 <vcprintf>
  100415:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100418:	83 ec 0c             	sub    $0xc,%esp
  10041b:	68 46 63 10 00       	push   $0x106346
  100420:	e8 46 fe ff ff       	call   10026b <cprintf>
  100425:	83 c4 10             	add    $0x10,%esp
  100428:	eb 01                	jmp    10042b <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  10042a:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  10042b:	e8 46 14 00 00       	call   101876 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100430:	83 ec 0c             	sub    $0xc,%esp
  100433:	6a 00                	push   $0x0
  100435:	e8 41 08 00 00       	call   100c7b <kmonitor>
  10043a:	83 c4 10             	add    $0x10,%esp
    }
  10043d:	eb f1                	jmp    100430 <__panic+0x5f>

0010043f <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10043f:	55                   	push   %ebp
  100440:	89 e5                	mov    %esp,%ebp
  100442:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100445:	8d 45 14             	lea    0x14(%ebp),%eax
  100448:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10044b:	83 ec 04             	sub    $0x4,%esp
  10044e:	ff 75 0c             	pushl  0xc(%ebp)
  100451:	ff 75 08             	pushl  0x8(%ebp)
  100454:	68 48 63 10 00       	push   $0x106348
  100459:	e8 0d fe ff ff       	call   10026b <cprintf>
  10045e:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100464:	83 ec 08             	sub    $0x8,%esp
  100467:	50                   	push   %eax
  100468:	ff 75 10             	pushl  0x10(%ebp)
  10046b:	e8 d2 fd ff ff       	call   100242 <vcprintf>
  100470:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100473:	83 ec 0c             	sub    $0xc,%esp
  100476:	68 46 63 10 00       	push   $0x106346
  10047b:	e8 eb fd ff ff       	call   10026b <cprintf>
  100480:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100483:	90                   	nop
  100484:	c9                   	leave  
  100485:	c3                   	ret    

00100486 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100486:	55                   	push   %ebp
  100487:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100489:	a1 80 8e 11 00       	mov    0x118e80,%eax
}
  10048e:	5d                   	pop    %ebp
  10048f:	c3                   	ret    

00100490 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100490:	55                   	push   %ebp
  100491:	89 e5                	mov    %esp,%ebp
  100493:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100496:	8b 45 0c             	mov    0xc(%ebp),%eax
  100499:	8b 00                	mov    (%eax),%eax
  10049b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10049e:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a1:	8b 00                	mov    (%eax),%eax
  1004a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004ad:	e9 d2 00 00 00       	jmp    100584 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004b8:	01 d0                	add    %edx,%eax
  1004ba:	89 c2                	mov    %eax,%edx
  1004bc:	c1 ea 1f             	shr    $0x1f,%edx
  1004bf:	01 d0                	add    %edx,%eax
  1004c1:	d1 f8                	sar    %eax
  1004c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004c9:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004cc:	eb 04                	jmp    1004d2 <stab_binsearch+0x42>
            m --;
  1004ce:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d8:	7c 1f                	jl     1004f9 <stab_binsearch+0x69>
  1004da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004dd:	89 d0                	mov    %edx,%eax
  1004df:	01 c0                	add    %eax,%eax
  1004e1:	01 d0                	add    %edx,%eax
  1004e3:	c1 e0 02             	shl    $0x2,%eax
  1004e6:	89 c2                	mov    %eax,%edx
  1004e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1004eb:	01 d0                	add    %edx,%eax
  1004ed:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f1:	0f b6 c0             	movzbl %al,%eax
  1004f4:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004f7:	75 d5                	jne    1004ce <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ff:	7d 0b                	jge    10050c <stab_binsearch+0x7c>
            l = true_m + 1;
  100501:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100504:	83 c0 01             	add    $0x1,%eax
  100507:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10050a:	eb 78                	jmp    100584 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10050c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100513:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100516:	89 d0                	mov    %edx,%eax
  100518:	01 c0                	add    %eax,%eax
  10051a:	01 d0                	add    %edx,%eax
  10051c:	c1 e0 02             	shl    $0x2,%eax
  10051f:	89 c2                	mov    %eax,%edx
  100521:	8b 45 08             	mov    0x8(%ebp),%eax
  100524:	01 d0                	add    %edx,%eax
  100526:	8b 40 08             	mov    0x8(%eax),%eax
  100529:	3b 45 18             	cmp    0x18(%ebp),%eax
  10052c:	73 13                	jae    100541 <stab_binsearch+0xb1>
            *region_left = m;
  10052e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100531:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100534:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100536:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100539:	83 c0 01             	add    $0x1,%eax
  10053c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10053f:	eb 43                	jmp    100584 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100541:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100544:	89 d0                	mov    %edx,%eax
  100546:	01 c0                	add    %eax,%eax
  100548:	01 d0                	add    %edx,%eax
  10054a:	c1 e0 02             	shl    $0x2,%eax
  10054d:	89 c2                	mov    %eax,%edx
  10054f:	8b 45 08             	mov    0x8(%ebp),%eax
  100552:	01 d0                	add    %edx,%eax
  100554:	8b 40 08             	mov    0x8(%eax),%eax
  100557:	3b 45 18             	cmp    0x18(%ebp),%eax
  10055a:	76 16                	jbe    100572 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10055c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055f:	8d 50 ff             	lea    -0x1(%eax),%edx
  100562:	8b 45 10             	mov    0x10(%ebp),%eax
  100565:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10056a:	83 e8 01             	sub    $0x1,%eax
  10056d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100570:	eb 12                	jmp    100584 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100572:	8b 45 0c             	mov    0xc(%ebp),%eax
  100575:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100578:	89 10                	mov    %edx,(%eax)
            l = m;
  10057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057d:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100580:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100584:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100587:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10058a:	0f 8e 22 ff ff ff    	jle    1004b2 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  100590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100594:	75 0f                	jne    1005a5 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100596:	8b 45 0c             	mov    0xc(%ebp),%eax
  100599:	8b 00                	mov    (%eax),%eax
  10059b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10059e:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a1:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005a3:	eb 3f                	jmp    1005e4 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005a5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a8:	8b 00                	mov    (%eax),%eax
  1005aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005ad:	eb 04                	jmp    1005b3 <stab_binsearch+0x123>
  1005af:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b6:	8b 00                	mov    (%eax),%eax
  1005b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005bb:	7d 1f                	jge    1005dc <stab_binsearch+0x14c>
  1005bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c0:	89 d0                	mov    %edx,%eax
  1005c2:	01 c0                	add    %eax,%eax
  1005c4:	01 d0                	add    %edx,%eax
  1005c6:	c1 e0 02             	shl    $0x2,%eax
  1005c9:	89 c2                	mov    %eax,%edx
  1005cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ce:	01 d0                	add    %edx,%eax
  1005d0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005d4:	0f b6 c0             	movzbl %al,%eax
  1005d7:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005da:	75 d3                	jne    1005af <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005e2:	89 10                	mov    %edx,(%eax)
    }
}
  1005e4:	90                   	nop
  1005e5:	c9                   	leave  
  1005e6:	c3                   	ret    

001005e7 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005e7:	55                   	push   %ebp
  1005e8:	89 e5                	mov    %esp,%ebp
  1005ea:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f0:	c7 00 68 63 10 00    	movl   $0x106368,(%eax)
    info->eip_line = 0;
  1005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100600:	8b 45 0c             	mov    0xc(%ebp),%eax
  100603:	c7 40 08 68 63 10 00 	movl   $0x106368,0x8(%eax)
    info->eip_fn_namelen = 9;
  10060a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100614:	8b 45 0c             	mov    0xc(%ebp),%eax
  100617:	8b 55 08             	mov    0x8(%ebp),%edx
  10061a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10061d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100620:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100627:	c7 45 f4 b0 75 10 00 	movl   $0x1075b0,-0xc(%ebp)
    stab_end = __STAB_END__;
  10062e:	c7 45 f0 44 2f 11 00 	movl   $0x112f44,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100635:	c7 45 ec 45 2f 11 00 	movl   $0x112f45,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10063c:	c7 45 e8 94 5a 11 00 	movl   $0x115a94,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100643:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100646:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100649:	76 0d                	jbe    100658 <debuginfo_eip+0x71>
  10064b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064e:	83 e8 01             	sub    $0x1,%eax
  100651:	0f b6 00             	movzbl (%eax),%eax
  100654:	84 c0                	test   %al,%al
  100656:	74 0a                	je     100662 <debuginfo_eip+0x7b>
        return -1;
  100658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10065d:	e9 91 02 00 00       	jmp    1008f3 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100662:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100669:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066f:	29 c2                	sub    %eax,%edx
  100671:	89 d0                	mov    %edx,%eax
  100673:	c1 f8 02             	sar    $0x2,%eax
  100676:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10067c:	83 e8 01             	sub    $0x1,%eax
  10067f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100682:	ff 75 08             	pushl  0x8(%ebp)
  100685:	6a 64                	push   $0x64
  100687:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10068a:	50                   	push   %eax
  10068b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10068e:	50                   	push   %eax
  10068f:	ff 75 f4             	pushl  -0xc(%ebp)
  100692:	e8 f9 fd ff ff       	call   100490 <stab_binsearch>
  100697:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10069a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10069d:	85 c0                	test   %eax,%eax
  10069f:	75 0a                	jne    1006ab <debuginfo_eip+0xc4>
        return -1;
  1006a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a6:	e9 48 02 00 00       	jmp    1008f3 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006b7:	ff 75 08             	pushl  0x8(%ebp)
  1006ba:	6a 24                	push   $0x24
  1006bc:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006bf:	50                   	push   %eax
  1006c0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006c3:	50                   	push   %eax
  1006c4:	ff 75 f4             	pushl  -0xc(%ebp)
  1006c7:	e8 c4 fd ff ff       	call   100490 <stab_binsearch>
  1006cc:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006cf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006d5:	39 c2                	cmp    %eax,%edx
  1006d7:	7f 7c                	jg     100755 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006dc:	89 c2                	mov    %eax,%edx
  1006de:	89 d0                	mov    %edx,%eax
  1006e0:	01 c0                	add    %eax,%eax
  1006e2:	01 d0                	add    %edx,%eax
  1006e4:	c1 e0 02             	shl    $0x2,%eax
  1006e7:	89 c2                	mov    %eax,%edx
  1006e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ec:	01 d0                	add    %edx,%eax
  1006ee:	8b 00                	mov    (%eax),%eax
  1006f0:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006f6:	29 d1                	sub    %edx,%ecx
  1006f8:	89 ca                	mov    %ecx,%edx
  1006fa:	39 d0                	cmp    %edx,%eax
  1006fc:	73 22                	jae    100720 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100701:	89 c2                	mov    %eax,%edx
  100703:	89 d0                	mov    %edx,%eax
  100705:	01 c0                	add    %eax,%eax
  100707:	01 d0                	add    %edx,%eax
  100709:	c1 e0 02             	shl    $0x2,%eax
  10070c:	89 c2                	mov    %eax,%edx
  10070e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100711:	01 d0                	add    %edx,%eax
  100713:	8b 10                	mov    (%eax),%edx
  100715:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100718:	01 c2                	add    %eax,%edx
  10071a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071d:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100720:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100723:	89 c2                	mov    %eax,%edx
  100725:	89 d0                	mov    %edx,%eax
  100727:	01 c0                	add    %eax,%eax
  100729:	01 d0                	add    %edx,%eax
  10072b:	c1 e0 02             	shl    $0x2,%eax
  10072e:	89 c2                	mov    %eax,%edx
  100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100733:	01 d0                	add    %edx,%eax
  100735:	8b 50 08             	mov    0x8(%eax),%edx
  100738:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073b:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10073e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100741:	8b 40 10             	mov    0x10(%eax),%eax
  100744:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100747:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10074a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10074d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100750:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100753:	eb 15                	jmp    10076a <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100755:	8b 45 0c             	mov    0xc(%ebp),%eax
  100758:	8b 55 08             	mov    0x8(%ebp),%edx
  10075b:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10075e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100761:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100764:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100767:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	8b 40 08             	mov    0x8(%eax),%eax
  100770:	83 ec 08             	sub    $0x8,%esp
  100773:	6a 3a                	push   $0x3a
  100775:	50                   	push   %eax
  100776:	e8 dc 51 00 00       	call   105957 <strfind>
  10077b:	83 c4 10             	add    $0x10,%esp
  10077e:	89 c2                	mov    %eax,%edx
  100780:	8b 45 0c             	mov    0xc(%ebp),%eax
  100783:	8b 40 08             	mov    0x8(%eax),%eax
  100786:	29 c2                	sub    %eax,%edx
  100788:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078b:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10078e:	83 ec 0c             	sub    $0xc,%esp
  100791:	ff 75 08             	pushl  0x8(%ebp)
  100794:	6a 44                	push   $0x44
  100796:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100799:	50                   	push   %eax
  10079a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10079d:	50                   	push   %eax
  10079e:	ff 75 f4             	pushl  -0xc(%ebp)
  1007a1:	e8 ea fc ff ff       	call   100490 <stab_binsearch>
  1007a6:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1007a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007af:	39 c2                	cmp    %eax,%edx
  1007b1:	7f 24                	jg     1007d7 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  1007b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007b6:	89 c2                	mov    %eax,%edx
  1007b8:	89 d0                	mov    %edx,%eax
  1007ba:	01 c0                	add    %eax,%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	c1 e0 02             	shl    $0x2,%eax
  1007c1:	89 c2                	mov    %eax,%edx
  1007c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c6:	01 d0                	add    %edx,%eax
  1007c8:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007cc:	0f b7 d0             	movzwl %ax,%edx
  1007cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d2:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007d5:	eb 13                	jmp    1007ea <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007dc:	e9 12 01 00 00       	jmp    1008f3 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e4:	83 e8 01             	sub    $0x1,%eax
  1007e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	7c 56                	jl     10084a <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10080d:	3c 84                	cmp    $0x84,%al
  10080f:	74 39                	je     10084a <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100811:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100814:	89 c2                	mov    %eax,%edx
  100816:	89 d0                	mov    %edx,%eax
  100818:	01 c0                	add    %eax,%eax
  10081a:	01 d0                	add    %edx,%eax
  10081c:	c1 e0 02             	shl    $0x2,%eax
  10081f:	89 c2                	mov    %eax,%edx
  100821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100824:	01 d0                	add    %edx,%eax
  100826:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10082a:	3c 64                	cmp    $0x64,%al
  10082c:	75 b3                	jne    1007e1 <debuginfo_eip+0x1fa>
  10082e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100831:	89 c2                	mov    %eax,%edx
  100833:	89 d0                	mov    %edx,%eax
  100835:	01 c0                	add    %eax,%eax
  100837:	01 d0                	add    %edx,%eax
  100839:	c1 e0 02             	shl    $0x2,%eax
  10083c:	89 c2                	mov    %eax,%edx
  10083e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100841:	01 d0                	add    %edx,%eax
  100843:	8b 40 08             	mov    0x8(%eax),%eax
  100846:	85 c0                	test   %eax,%eax
  100848:	74 97                	je     1007e1 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10084a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100850:	39 c2                	cmp    %eax,%edx
  100852:	7c 46                	jl     10089a <debuginfo_eip+0x2b3>
  100854:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100857:	89 c2                	mov    %eax,%edx
  100859:	89 d0                	mov    %edx,%eax
  10085b:	01 c0                	add    %eax,%eax
  10085d:	01 d0                	add    %edx,%eax
  10085f:	c1 e0 02             	shl    $0x2,%eax
  100862:	89 c2                	mov    %eax,%edx
  100864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100867:	01 d0                	add    %edx,%eax
  100869:	8b 00                	mov    (%eax),%eax
  10086b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10086e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100871:	29 d1                	sub    %edx,%ecx
  100873:	89 ca                	mov    %ecx,%edx
  100875:	39 d0                	cmp    %edx,%eax
  100877:	73 21                	jae    10089a <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100879:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10087c:	89 c2                	mov    %eax,%edx
  10087e:	89 d0                	mov    %edx,%eax
  100880:	01 c0                	add    %eax,%eax
  100882:	01 d0                	add    %edx,%eax
  100884:	c1 e0 02             	shl    $0x2,%eax
  100887:	89 c2                	mov    %eax,%edx
  100889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10088c:	01 d0                	add    %edx,%eax
  10088e:	8b 10                	mov    (%eax),%edx
  100890:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100893:	01 c2                	add    %eax,%edx
  100895:	8b 45 0c             	mov    0xc(%ebp),%eax
  100898:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10089a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10089d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008a0:	39 c2                	cmp    %eax,%edx
  1008a2:	7d 4a                	jge    1008ee <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  1008a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008a7:	83 c0 01             	add    $0x1,%eax
  1008aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008ad:	eb 18                	jmp    1008c7 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b2:	8b 40 14             	mov    0x14(%eax),%eax
  1008b5:	8d 50 01             	lea    0x1(%eax),%edx
  1008b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008bb:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c1:	83 c0 01             	add    $0x1,%eax
  1008c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008cd:	39 c2                	cmp    %eax,%edx
  1008cf:	7d 1d                	jge    1008ee <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d4:	89 c2                	mov    %eax,%edx
  1008d6:	89 d0                	mov    %edx,%eax
  1008d8:	01 c0                	add    %eax,%eax
  1008da:	01 d0                	add    %edx,%eax
  1008dc:	c1 e0 02             	shl    $0x2,%eax
  1008df:	89 c2                	mov    %eax,%edx
  1008e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e4:	01 d0                	add    %edx,%eax
  1008e6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008ea:	3c a0                	cmp    $0xa0,%al
  1008ec:	74 c1                	je     1008af <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008f3:	c9                   	leave  
  1008f4:	c3                   	ret    

001008f5 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008f5:	55                   	push   %ebp
  1008f6:	89 e5                	mov    %esp,%ebp
  1008f8:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008fb:	83 ec 0c             	sub    $0xc,%esp
  1008fe:	68 72 63 10 00       	push   $0x106372
  100903:	e8 63 f9 ff ff       	call   10026b <cprintf>
  100908:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10090b:	83 ec 08             	sub    $0x8,%esp
  10090e:	68 2a 00 10 00       	push   $0x10002a
  100913:	68 8b 63 10 00       	push   $0x10638b
  100918:	e8 4e f9 ff ff       	call   10026b <cprintf>
  10091d:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100920:	83 ec 08             	sub    $0x8,%esp
  100923:	68 7a 62 10 00       	push   $0x10627a
  100928:	68 a3 63 10 00       	push   $0x1063a3
  10092d:	e8 39 f9 ff ff       	call   10026b <cprintf>
  100932:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100935:	83 ec 08             	sub    $0x8,%esp
  100938:	68 56 8a 11 00       	push   $0x118a56
  10093d:	68 bb 63 10 00       	push   $0x1063bb
  100942:	e8 24 f9 ff ff       	call   10026b <cprintf>
  100947:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10094a:	83 ec 08             	sub    $0x8,%esp
  10094d:	68 88 99 11 00       	push   $0x119988
  100952:	68 d3 63 10 00       	push   $0x1063d3
  100957:	e8 0f f9 ff ff       	call   10026b <cprintf>
  10095c:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10095f:	b8 88 99 11 00       	mov    $0x119988,%eax
  100964:	05 ff 03 00 00       	add    $0x3ff,%eax
  100969:	ba 2a 00 10 00       	mov    $0x10002a,%edx
  10096e:	29 d0                	sub    %edx,%eax
  100970:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100976:	85 c0                	test   %eax,%eax
  100978:	0f 48 c2             	cmovs  %edx,%eax
  10097b:	c1 f8 0a             	sar    $0xa,%eax
  10097e:	83 ec 08             	sub    $0x8,%esp
  100981:	50                   	push   %eax
  100982:	68 ec 63 10 00       	push   $0x1063ec
  100987:	e8 df f8 ff ff       	call   10026b <cprintf>
  10098c:	83 c4 10             	add    $0x10,%esp
}
  10098f:	90                   	nop
  100990:	c9                   	leave  
  100991:	c3                   	ret    

00100992 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100992:	55                   	push   %ebp
  100993:	89 e5                	mov    %esp,%ebp
  100995:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10099b:	83 ec 08             	sub    $0x8,%esp
  10099e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009a1:	50                   	push   %eax
  1009a2:	ff 75 08             	pushl  0x8(%ebp)
  1009a5:	e8 3d fc ff ff       	call   1005e7 <debuginfo_eip>
  1009aa:	83 c4 10             	add    $0x10,%esp
  1009ad:	85 c0                	test   %eax,%eax
  1009af:	74 15                	je     1009c6 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009b1:	83 ec 08             	sub    $0x8,%esp
  1009b4:	ff 75 08             	pushl  0x8(%ebp)
  1009b7:	68 16 64 10 00       	push   $0x106416
  1009bc:	e8 aa f8 ff ff       	call   10026b <cprintf>
  1009c1:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009c4:	eb 65                	jmp    100a2b <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009cd:	eb 1c                	jmp    1009eb <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d5:	01 d0                	add    %edx,%eax
  1009d7:	0f b6 00             	movzbl (%eax),%eax
  1009da:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009e3:	01 ca                	add    %ecx,%edx
  1009e5:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009f1:	7f dc                	jg     1009cf <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009f3:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fc:	01 d0                	add    %edx,%eax
  1009fe:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a01:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a04:	8b 55 08             	mov    0x8(%ebp),%edx
  100a07:	89 d1                	mov    %edx,%ecx
  100a09:	29 c1                	sub    %eax,%ecx
  100a0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a11:	83 ec 0c             	sub    $0xc,%esp
  100a14:	51                   	push   %ecx
  100a15:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a1b:	51                   	push   %ecx
  100a1c:	52                   	push   %edx
  100a1d:	50                   	push   %eax
  100a1e:	68 32 64 10 00       	push   $0x106432
  100a23:	e8 43 f8 ff ff       	call   10026b <cprintf>
  100a28:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a2b:	90                   	nop
  100a2c:	c9                   	leave  
  100a2d:	c3                   	ret    

00100a2e <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a2e:	55                   	push   %ebp
  100a2f:	89 e5                	mov    %esp,%ebp
  100a31:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a34:	8b 45 04             	mov    0x4(%ebp),%eax
  100a37:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a3d:	c9                   	leave  
  100a3e:	c3                   	ret    

00100a3f <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a3f:	55                   	push   %ebp
  100a40:	89 e5                	mov    %esp,%ebp
  100a42:	53                   	push   %ebx
  100a43:	83 ec 24             	sub    $0x24,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a46:	89 e8                	mov    %ebp,%eax
  100a48:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
  100a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uintptr_t ebp = read_ebp();
  100a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t eip = read_eip();
  100a51:	e8 d8 ff ff ff       	call   100a2e <read_eip>
  100a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32_t args[4] = {0};
  100a59:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  100a60:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  100a67:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100a6e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while(ebp != 0){
  100a75:	e9 85 00 00 00       	jmp    100aff <print_stackframe+0xc0>
        asm volatile("movl 8(%%ebp), %0":"=r"(args[0]));
  100a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        asm volatile("movl 12(%%ebp), %0":"=r"(args[1]));
  100a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a83:	89 45 e0             	mov    %eax,-0x20(%ebp)
        asm volatile("movl 16(%%ebp), %0":"=r"(args[2]));
  100a86:	8b 45 10             	mov    0x10(%ebp),%eax
  100a89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        asm volatile("movl 20(%%ebp), %0":"=r"(args[3]));
  100a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  100a8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        cprintf("ebp:0x%x eip:0x%x ", ebp, eip);
  100a92:	83 ec 04             	sub    $0x4,%esp
  100a95:	ff 75 f0             	pushl  -0x10(%ebp)
  100a98:	ff 75 f4             	pushl  -0xc(%ebp)
  100a9b:	68 44 64 10 00       	push   $0x106444
  100aa0:	e8 c6 f7 ff ff       	call   10026b <cprintf>
  100aa5:	83 c4 10             	add    $0x10,%esp
        cprintf("args:0x%x 0x%x ", args[0], args[1]);
  100aa8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100aab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100aae:	83 ec 04             	sub    $0x4,%esp
  100ab1:	52                   	push   %edx
  100ab2:	50                   	push   %eax
  100ab3:	68 57 64 10 00       	push   $0x106457
  100ab8:	e8 ae f7 ff ff       	call   10026b <cprintf>
  100abd:	83 c4 10             	add    $0x10,%esp
        cprintf("0x%x 0x%x\n", args[2], args[3]);
  100ac0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  100ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100ac6:	83 ec 04             	sub    $0x4,%esp
  100ac9:	52                   	push   %edx
  100aca:	50                   	push   %eax
  100acb:	68 67 64 10 00       	push   $0x106467
  100ad0:	e8 96 f7 ff ff       	call   10026b <cprintf>
  100ad5:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip-1);
  100ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100adb:	83 e8 01             	sub    $0x1,%eax
  100ade:	83 ec 0c             	sub    $0xc,%esp
  100ae1:	50                   	push   %eax
  100ae2:	e8 ab fe ff ff       	call   100992 <print_debuginfo>
  100ae7:	83 c4 10             	add    $0x10,%esp

        // asm volatile("movl (%0), %1"::"=r"(ebp), "b"(ebp));
        asm volatile(
  100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aed:	89 c3                	mov    %eax,%ebx
  100aef:	8b 03                	mov    (%ebx),%eax
  100af1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            "movl (%1), %0;"
            :"=a"(ebp)
            :"b"(ebp)
        );
        // asm volatile("movl 4(%0), %1"::"a"(ebp), "b"(eip));
        asm volatile(
  100af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af7:	89 c3                	mov    %eax,%ebx
  100af9:	8b 43 04             	mov    0x4(%ebx),%eax
  100afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uintptr_t ebp = read_ebp();
    uintptr_t eip = read_eip();
    uint32_t args[4] = {0};
    while(ebp != 0){
  100aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b03:	0f 85 71 ff ff ff    	jne    100a7a <print_stackframe+0x3b>
            "movl 4(%1), %0;"
            :"=a"(eip)
            :"b"(ebp)
        );
    } 
}
  100b09:	90                   	nop
  100b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100b0d:	c9                   	leave  
  100b0e:	c3                   	ret    

00100b0f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b0f:	55                   	push   %ebp
  100b10:	89 e5                	mov    %esp,%ebp
  100b12:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100b15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b1c:	eb 0c                	jmp    100b2a <parse+0x1b>
            *buf ++ = '\0';
  100b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b21:	8d 50 01             	lea    0x1(%eax),%edx
  100b24:	89 55 08             	mov    %edx,0x8(%ebp)
  100b27:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2d:	0f b6 00             	movzbl (%eax),%eax
  100b30:	84 c0                	test   %al,%al
  100b32:	74 1e                	je     100b52 <parse+0x43>
  100b34:	8b 45 08             	mov    0x8(%ebp),%eax
  100b37:	0f b6 00             	movzbl (%eax),%eax
  100b3a:	0f be c0             	movsbl %al,%eax
  100b3d:	83 ec 08             	sub    $0x8,%esp
  100b40:	50                   	push   %eax
  100b41:	68 f4 64 10 00       	push   $0x1064f4
  100b46:	e8 d9 4d 00 00       	call   105924 <strchr>
  100b4b:	83 c4 10             	add    $0x10,%esp
  100b4e:	85 c0                	test   %eax,%eax
  100b50:	75 cc                	jne    100b1e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b52:	8b 45 08             	mov    0x8(%ebp),%eax
  100b55:	0f b6 00             	movzbl (%eax),%eax
  100b58:	84 c0                	test   %al,%al
  100b5a:	74 69                	je     100bc5 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b5c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b60:	75 12                	jne    100b74 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b62:	83 ec 08             	sub    $0x8,%esp
  100b65:	6a 10                	push   $0x10
  100b67:	68 f9 64 10 00       	push   $0x1064f9
  100b6c:	e8 fa f6 ff ff       	call   10026b <cprintf>
  100b71:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b77:	8d 50 01             	lea    0x1(%eax),%edx
  100b7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b7d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b87:	01 c2                	add    %eax,%edx
  100b89:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8c:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b8e:	eb 04                	jmp    100b94 <parse+0x85>
            buf ++;
  100b90:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b94:	8b 45 08             	mov    0x8(%ebp),%eax
  100b97:	0f b6 00             	movzbl (%eax),%eax
  100b9a:	84 c0                	test   %al,%al
  100b9c:	0f 84 7a ff ff ff    	je     100b1c <parse+0xd>
  100ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba5:	0f b6 00             	movzbl (%eax),%eax
  100ba8:	0f be c0             	movsbl %al,%eax
  100bab:	83 ec 08             	sub    $0x8,%esp
  100bae:	50                   	push   %eax
  100baf:	68 f4 64 10 00       	push   $0x1064f4
  100bb4:	e8 6b 4d 00 00       	call   105924 <strchr>
  100bb9:	83 c4 10             	add    $0x10,%esp
  100bbc:	85 c0                	test   %eax,%eax
  100bbe:	74 d0                	je     100b90 <parse+0x81>
            buf ++;
        }
    }
  100bc0:	e9 57 ff ff ff       	jmp    100b1c <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100bc5:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bc9:	c9                   	leave  
  100bca:	c3                   	ret    

00100bcb <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bcb:	55                   	push   %ebp
  100bcc:	89 e5                	mov    %esp,%ebp
  100bce:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bd1:	83 ec 08             	sub    $0x8,%esp
  100bd4:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bd7:	50                   	push   %eax
  100bd8:	ff 75 08             	pushl  0x8(%ebp)
  100bdb:	e8 2f ff ff ff       	call   100b0f <parse>
  100be0:	83 c4 10             	add    $0x10,%esp
  100be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100be6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bea:	75 0a                	jne    100bf6 <runcmd+0x2b>
        return 0;
  100bec:	b8 00 00 00 00       	mov    $0x0,%eax
  100bf1:	e9 83 00 00 00       	jmp    100c79 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bfd:	eb 59                	jmp    100c58 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bff:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c05:	89 d0                	mov    %edx,%eax
  100c07:	01 c0                	add    %eax,%eax
  100c09:	01 d0                	add    %edx,%eax
  100c0b:	c1 e0 02             	shl    $0x2,%eax
  100c0e:	05 40 80 11 00       	add    $0x118040,%eax
  100c13:	8b 00                	mov    (%eax),%eax
  100c15:	83 ec 08             	sub    $0x8,%esp
  100c18:	51                   	push   %ecx
  100c19:	50                   	push   %eax
  100c1a:	e8 65 4c 00 00       	call   105884 <strcmp>
  100c1f:	83 c4 10             	add    $0x10,%esp
  100c22:	85 c0                	test   %eax,%eax
  100c24:	75 2e                	jne    100c54 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c29:	89 d0                	mov    %edx,%eax
  100c2b:	01 c0                	add    %eax,%eax
  100c2d:	01 d0                	add    %edx,%eax
  100c2f:	c1 e0 02             	shl    $0x2,%eax
  100c32:	05 48 80 11 00       	add    $0x118048,%eax
  100c37:	8b 10                	mov    (%eax),%edx
  100c39:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c3c:	83 c0 04             	add    $0x4,%eax
  100c3f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c42:	83 e9 01             	sub    $0x1,%ecx
  100c45:	83 ec 04             	sub    $0x4,%esp
  100c48:	ff 75 0c             	pushl  0xc(%ebp)
  100c4b:	50                   	push   %eax
  100c4c:	51                   	push   %ecx
  100c4d:	ff d2                	call   *%edx
  100c4f:	83 c4 10             	add    $0x10,%esp
  100c52:	eb 25                	jmp    100c79 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c54:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c5b:	83 f8 02             	cmp    $0x2,%eax
  100c5e:	76 9f                	jbe    100bff <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c60:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c63:	83 ec 08             	sub    $0x8,%esp
  100c66:	50                   	push   %eax
  100c67:	68 17 65 10 00       	push   $0x106517
  100c6c:	e8 fa f5 ff ff       	call   10026b <cprintf>
  100c71:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c79:	c9                   	leave  
  100c7a:	c3                   	ret    

00100c7b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c7b:	55                   	push   %ebp
  100c7c:	89 e5                	mov    %esp,%ebp
  100c7e:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c81:	83 ec 0c             	sub    $0xc,%esp
  100c84:	68 30 65 10 00       	push   $0x106530
  100c89:	e8 dd f5 ff ff       	call   10026b <cprintf>
  100c8e:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c91:	83 ec 0c             	sub    $0xc,%esp
  100c94:	68 58 65 10 00       	push   $0x106558
  100c99:	e8 cd f5 ff ff       	call   10026b <cprintf>
  100c9e:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100ca1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ca5:	74 0e                	je     100cb5 <kmonitor+0x3a>
        print_trapframe(tf);
  100ca7:	83 ec 0c             	sub    $0xc,%esp
  100caa:	ff 75 08             	pushl  0x8(%ebp)
  100cad:	e8 a3 0d 00 00       	call   101a55 <print_trapframe>
  100cb2:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cb5:	83 ec 0c             	sub    $0xc,%esp
  100cb8:	68 7d 65 10 00       	push   $0x10657d
  100cbd:	e8 4d f6 ff ff       	call   10030f <readline>
  100cc2:	83 c4 10             	add    $0x10,%esp
  100cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ccc:	74 e7                	je     100cb5 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cce:	83 ec 08             	sub    $0x8,%esp
  100cd1:	ff 75 08             	pushl  0x8(%ebp)
  100cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  100cd7:	e8 ef fe ff ff       	call   100bcb <runcmd>
  100cdc:	83 c4 10             	add    $0x10,%esp
  100cdf:	85 c0                	test   %eax,%eax
  100ce1:	78 02                	js     100ce5 <kmonitor+0x6a>
                break;
            }
        }
    }
  100ce3:	eb d0                	jmp    100cb5 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100ce5:	90                   	nop
            }
        }
    }
}
  100ce6:	90                   	nop
  100ce7:	c9                   	leave  
  100ce8:	c3                   	ret    

00100ce9 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100ce9:	55                   	push   %ebp
  100cea:	89 e5                	mov    %esp,%ebp
  100cec:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cf6:	eb 3c                	jmp    100d34 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cfb:	89 d0                	mov    %edx,%eax
  100cfd:	01 c0                	add    %eax,%eax
  100cff:	01 d0                	add    %edx,%eax
  100d01:	c1 e0 02             	shl    $0x2,%eax
  100d04:	05 44 80 11 00       	add    $0x118044,%eax
  100d09:	8b 08                	mov    (%eax),%ecx
  100d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d0e:	89 d0                	mov    %edx,%eax
  100d10:	01 c0                	add    %eax,%eax
  100d12:	01 d0                	add    %edx,%eax
  100d14:	c1 e0 02             	shl    $0x2,%eax
  100d17:	05 40 80 11 00       	add    $0x118040,%eax
  100d1c:	8b 00                	mov    (%eax),%eax
  100d1e:	83 ec 04             	sub    $0x4,%esp
  100d21:	51                   	push   %ecx
  100d22:	50                   	push   %eax
  100d23:	68 81 65 10 00       	push   $0x106581
  100d28:	e8 3e f5 ff ff       	call   10026b <cprintf>
  100d2d:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d37:	83 f8 02             	cmp    $0x2,%eax
  100d3a:	76 bc                	jbe    100cf8 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d41:	c9                   	leave  
  100d42:	c3                   	ret    

00100d43 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d43:	55                   	push   %ebp
  100d44:	89 e5                	mov    %esp,%ebp
  100d46:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d49:	e8 a7 fb ff ff       	call   1008f5 <print_kerninfo>
    return 0;
  100d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d53:	c9                   	leave  
  100d54:	c3                   	ret    

00100d55 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d55:	55                   	push   %ebp
  100d56:	89 e5                	mov    %esp,%ebp
  100d58:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d5b:	e8 df fc ff ff       	call   100a3f <print_stackframe>
    return 0;
  100d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d65:	c9                   	leave  
  100d66:	c3                   	ret    

00100d67 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d67:	55                   	push   %ebp
  100d68:	89 e5                	mov    %esp,%ebp
  100d6a:	83 ec 18             	sub    $0x18,%esp
  100d6d:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d73:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d77:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d7b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d7f:	ee                   	out    %al,(%dx)
  100d80:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d86:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d8a:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d8e:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d92:	ee                   	out    %al,(%dx)
  100d93:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d99:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d9d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100da5:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100da6:	c7 05 6c 99 11 00 00 	movl   $0x0,0x11996c
  100dad:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db0:	83 ec 0c             	sub    $0xc,%esp
  100db3:	68 8a 65 10 00       	push   $0x10658a
  100db8:	e8 ae f4 ff ff       	call   10026b <cprintf>
  100dbd:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100dc0:	83 ec 0c             	sub    $0xc,%esp
  100dc3:	6a 00                	push   $0x0
  100dc5:	e8 3b 09 00 00       	call   101705 <pic_enable>
  100dca:	83 c4 10             	add    $0x10,%esp
}
  100dcd:	90                   	nop
  100dce:	c9                   	leave  
  100dcf:	c3                   	ret    

00100dd0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dd0:	55                   	push   %ebp
  100dd1:	89 e5                	mov    %esp,%ebp
  100dd3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dd6:	9c                   	pushf  
  100dd7:	58                   	pop    %eax
  100dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dde:	25 00 02 00 00       	and    $0x200,%eax
  100de3:	85 c0                	test   %eax,%eax
  100de5:	74 0c                	je     100df3 <__intr_save+0x23>
        intr_disable();
  100de7:	e8 8a 0a 00 00       	call   101876 <intr_disable>
        return 1;
  100dec:	b8 01 00 00 00       	mov    $0x1,%eax
  100df1:	eb 05                	jmp    100df8 <__intr_save+0x28>
    }
    return 0;
  100df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100df8:	c9                   	leave  
  100df9:	c3                   	ret    

00100dfa <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100dfa:	55                   	push   %ebp
  100dfb:	89 e5                	mov    %esp,%ebp
  100dfd:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e04:	74 05                	je     100e0b <__intr_restore+0x11>
        intr_enable();
  100e06:	e8 64 0a 00 00       	call   10186f <intr_enable>
    }
}
  100e0b:	90                   	nop
  100e0c:	c9                   	leave  
  100e0d:	c3                   	ret    

00100e0e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e0e:	55                   	push   %ebp
  100e0f:	89 e5                	mov    %esp,%ebp
  100e11:	83 ec 10             	sub    $0x10,%esp
  100e14:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e1a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e1e:	89 c2                	mov    %eax,%edx
  100e20:	ec                   	in     (%dx),%al
  100e21:	88 45 f4             	mov    %al,-0xc(%ebp)
  100e24:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100e2a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100e2e:	89 c2                	mov    %eax,%edx
  100e30:	ec                   	in     (%dx),%al
  100e31:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e34:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e3a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e3e:	89 c2                	mov    %eax,%edx
  100e40:	ec                   	in     (%dx),%al
  100e41:	88 45 f6             	mov    %al,-0xa(%ebp)
  100e44:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100e4a:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100e4e:	89 c2                	mov    %eax,%edx
  100e50:	ec                   	in     (%dx),%al
  100e51:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e54:	90                   	nop
  100e55:	c9                   	leave  
  100e56:	c3                   	ret    

00100e57 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e57:	55                   	push   %ebp
  100e58:	89 e5                	mov    %esp,%ebp
  100e5a:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e5d:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e67:	0f b7 00             	movzwl (%eax),%eax
  100e6a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e71:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e79:	0f b7 00             	movzwl (%eax),%eax
  100e7c:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e80:	74 12                	je     100e94 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e82:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e89:	66 c7 05 a6 8e 11 00 	movw   $0x3b4,0x118ea6
  100e90:	b4 03 
  100e92:	eb 13                	jmp    100ea7 <cga_init+0x50>
    } else {
        *cp = was;
  100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e97:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e9b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e9e:	66 c7 05 a6 8e 11 00 	movw   $0x3d4,0x118ea6
  100ea5:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ea7:	0f b7 05 a6 8e 11 00 	movzwl 0x118ea6,%eax
  100eae:	0f b7 c0             	movzwl %ax,%eax
  100eb1:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100eb5:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100eb9:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100ebd:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100ec1:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ec2:	0f b7 05 a6 8e 11 00 	movzwl 0x118ea6,%eax
  100ec9:	83 c0 01             	add    $0x1,%eax
  100ecc:	0f b7 c0             	movzwl %ax,%eax
  100ecf:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ed3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ed7:	89 c2                	mov    %eax,%edx
  100ed9:	ec                   	in     (%dx),%al
  100eda:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100edd:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100ee1:	0f b6 c0             	movzbl %al,%eax
  100ee4:	c1 e0 08             	shl    $0x8,%eax
  100ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eea:	0f b7 05 a6 8e 11 00 	movzwl 0x118ea6,%eax
  100ef1:	0f b7 c0             	movzwl %ax,%eax
  100ef4:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100ef8:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100efc:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100f00:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f04:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f05:	0f b7 05 a6 8e 11 00 	movzwl 0x118ea6,%eax
  100f0c:	83 c0 01             	add    $0x1,%eax
  100f0f:	0f b7 c0             	movzwl %ax,%eax
  100f12:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f16:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f1a:	89 c2                	mov    %eax,%edx
  100f1c:	ec                   	in     (%dx),%al
  100f1d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f20:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f24:	0f b6 c0             	movzbl %al,%eax
  100f27:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f2d:	a3 a0 8e 11 00       	mov    %eax,0x118ea0
    crt_pos = pos;
  100f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f35:	66 a3 a4 8e 11 00    	mov    %ax,0x118ea4
}
  100f3b:	90                   	nop
  100f3c:	c9                   	leave  
  100f3d:	c3                   	ret    

00100f3e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f3e:	55                   	push   %ebp
  100f3f:	89 e5                	mov    %esp,%ebp
  100f41:	83 ec 28             	sub    $0x28,%esp
  100f44:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f4a:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f4e:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100f52:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f56:	ee                   	out    %al,(%dx)
  100f57:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100f5d:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100f61:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f65:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f69:	ee                   	out    %al,(%dx)
  100f6a:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f70:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f74:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f78:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f7c:	ee                   	out    %al,(%dx)
  100f7d:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f83:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f87:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f8b:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f8f:	ee                   	out    %al,(%dx)
  100f90:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f96:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f9a:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f9e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fa2:	ee                   	out    %al,(%dx)
  100fa3:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100fa9:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100fad:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100fb1:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100fb5:	ee                   	out    %al,(%dx)
  100fb6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fbc:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100fc0:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100fc4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fc8:	ee                   	out    %al,(%dx)
  100fc9:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fcf:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100fd3:	89 c2                	mov    %eax,%edx
  100fd5:	ec                   	in     (%dx),%al
  100fd6:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100fd9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fdd:	3c ff                	cmp    $0xff,%al
  100fdf:	0f 95 c0             	setne  %al
  100fe2:	0f b6 c0             	movzbl %al,%eax
  100fe5:	a3 a8 8e 11 00       	mov    %eax,0x118ea8
  100fea:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ff0:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ff4:	89 c2                	mov    %eax,%edx
  100ff6:	ec                   	in     (%dx),%al
  100ff7:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100ffa:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  101000:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  101004:	89 c2                	mov    %eax,%edx
  101006:	ec                   	in     (%dx),%al
  101007:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10100a:	a1 a8 8e 11 00       	mov    0x118ea8,%eax
  10100f:	85 c0                	test   %eax,%eax
  101011:	74 0d                	je     101020 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  101013:	83 ec 0c             	sub    $0xc,%esp
  101016:	6a 04                	push   $0x4
  101018:	e8 e8 06 00 00       	call   101705 <pic_enable>
  10101d:	83 c4 10             	add    $0x10,%esp
    }
}
  101020:	90                   	nop
  101021:	c9                   	leave  
  101022:	c3                   	ret    

00101023 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101023:	55                   	push   %ebp
  101024:	89 e5                	mov    %esp,%ebp
  101026:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101029:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101030:	eb 09                	jmp    10103b <lpt_putc_sub+0x18>
        delay();
  101032:	e8 d7 fd ff ff       	call   100e0e <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101037:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10103b:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  101041:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  101045:	89 c2                	mov    %eax,%edx
  101047:	ec                   	in     (%dx),%al
  101048:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  10104b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10104f:	84 c0                	test   %al,%al
  101051:	78 09                	js     10105c <lpt_putc_sub+0x39>
  101053:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10105a:	7e d6                	jle    101032 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10105c:	8b 45 08             	mov    0x8(%ebp),%eax
  10105f:	0f b6 c0             	movzbl %al,%eax
  101062:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101068:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10106b:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  10106f:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101073:	ee                   	out    %al,(%dx)
  101074:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10107a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10107e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101082:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101086:	ee                   	out    %al,(%dx)
  101087:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  10108d:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  101091:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  101095:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101099:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10109a:	90                   	nop
  10109b:	c9                   	leave  
  10109c:	c3                   	ret    

0010109d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10109d:	55                   	push   %ebp
  10109e:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1010a0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010a4:	74 0d                	je     1010b3 <lpt_putc+0x16>
        lpt_putc_sub(c);
  1010a6:	ff 75 08             	pushl  0x8(%ebp)
  1010a9:	e8 75 ff ff ff       	call   101023 <lpt_putc_sub>
  1010ae:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010b1:	eb 1e                	jmp    1010d1 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  1010b3:	6a 08                	push   $0x8
  1010b5:	e8 69 ff ff ff       	call   101023 <lpt_putc_sub>
  1010ba:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  1010bd:	6a 20                	push   $0x20
  1010bf:	e8 5f ff ff ff       	call   101023 <lpt_putc_sub>
  1010c4:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  1010c7:	6a 08                	push   $0x8
  1010c9:	e8 55 ff ff ff       	call   101023 <lpt_putc_sub>
  1010ce:	83 c4 04             	add    $0x4,%esp
    }
}
  1010d1:	90                   	nop
  1010d2:	c9                   	leave  
  1010d3:	c3                   	ret    

001010d4 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010d4:	55                   	push   %ebp
  1010d5:	89 e5                	mov    %esp,%ebp
  1010d7:	53                   	push   %ebx
  1010d8:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010db:	8b 45 08             	mov    0x8(%ebp),%eax
  1010de:	b0 00                	mov    $0x0,%al
  1010e0:	85 c0                	test   %eax,%eax
  1010e2:	75 07                	jne    1010eb <cga_putc+0x17>
        c |= 0x0700;
  1010e4:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ee:	0f b6 c0             	movzbl %al,%eax
  1010f1:	83 f8 0a             	cmp    $0xa,%eax
  1010f4:	74 4e                	je     101144 <cga_putc+0x70>
  1010f6:	83 f8 0d             	cmp    $0xd,%eax
  1010f9:	74 59                	je     101154 <cga_putc+0x80>
  1010fb:	83 f8 08             	cmp    $0x8,%eax
  1010fe:	0f 85 8a 00 00 00    	jne    10118e <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  101104:	0f b7 05 a4 8e 11 00 	movzwl 0x118ea4,%eax
  10110b:	66 85 c0             	test   %ax,%ax
  10110e:	0f 84 a0 00 00 00    	je     1011b4 <cga_putc+0xe0>
            crt_pos --;
  101114:	0f b7 05 a4 8e 11 00 	movzwl 0x118ea4,%eax
  10111b:	83 e8 01             	sub    $0x1,%eax
  10111e:	66 a3 a4 8e 11 00    	mov    %ax,0x118ea4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101124:	a1 a0 8e 11 00       	mov    0x118ea0,%eax
  101129:	0f b7 15 a4 8e 11 00 	movzwl 0x118ea4,%edx
  101130:	0f b7 d2             	movzwl %dx,%edx
  101133:	01 d2                	add    %edx,%edx
  101135:	01 d0                	add    %edx,%eax
  101137:	8b 55 08             	mov    0x8(%ebp),%edx
  10113a:	b2 00                	mov    $0x0,%dl
  10113c:	83 ca 20             	or     $0x20,%edx
  10113f:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  101142:	eb 70                	jmp    1011b4 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  101144:	0f b7 05 a4 8e 11 00 	movzwl 0x118ea4,%eax
  10114b:	83 c0 50             	add    $0x50,%eax
  10114e:	66 a3 a4 8e 11 00    	mov    %ax,0x118ea4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101154:	0f b7 1d a4 8e 11 00 	movzwl 0x118ea4,%ebx
  10115b:	0f b7 0d a4 8e 11 00 	movzwl 0x118ea4,%ecx
  101162:	0f b7 c1             	movzwl %cx,%eax
  101165:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10116b:	c1 e8 10             	shr    $0x10,%eax
  10116e:	89 c2                	mov    %eax,%edx
  101170:	66 c1 ea 06          	shr    $0x6,%dx
  101174:	89 d0                	mov    %edx,%eax
  101176:	c1 e0 02             	shl    $0x2,%eax
  101179:	01 d0                	add    %edx,%eax
  10117b:	c1 e0 04             	shl    $0x4,%eax
  10117e:	29 c1                	sub    %eax,%ecx
  101180:	89 ca                	mov    %ecx,%edx
  101182:	89 d8                	mov    %ebx,%eax
  101184:	29 d0                	sub    %edx,%eax
  101186:	66 a3 a4 8e 11 00    	mov    %ax,0x118ea4
        break;
  10118c:	eb 27                	jmp    1011b5 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10118e:	8b 0d a0 8e 11 00    	mov    0x118ea0,%ecx
  101194:	0f b7 05 a4 8e 11 00 	movzwl 0x118ea4,%eax
  10119b:	8d 50 01             	lea    0x1(%eax),%edx
  10119e:	66 89 15 a4 8e 11 00 	mov    %dx,0x118ea4
  1011a5:	0f b7 c0             	movzwl %ax,%eax
  1011a8:	01 c0                	add    %eax,%eax
  1011aa:	01 c8                	add    %ecx,%eax
  1011ac:	8b 55 08             	mov    0x8(%ebp),%edx
  1011af:	66 89 10             	mov    %dx,(%eax)
        break;
  1011b2:	eb 01                	jmp    1011b5 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  1011b4:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011b5:	0f b7 05 a4 8e 11 00 	movzwl 0x118ea4,%eax
  1011bc:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011c0:	76 59                	jbe    10121b <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011c2:	a1 a0 8e 11 00       	mov    0x118ea0,%eax
  1011c7:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011cd:	a1 a0 8e 11 00       	mov    0x118ea0,%eax
  1011d2:	83 ec 04             	sub    $0x4,%esp
  1011d5:	68 00 0f 00 00       	push   $0xf00
  1011da:	52                   	push   %edx
  1011db:	50                   	push   %eax
  1011dc:	e8 42 49 00 00       	call   105b23 <memmove>
  1011e1:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011e4:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011eb:	eb 15                	jmp    101202 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  1011ed:	a1 a0 8e 11 00       	mov    0x118ea0,%eax
  1011f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011f5:	01 d2                	add    %edx,%edx
  1011f7:	01 d0                	add    %edx,%eax
  1011f9:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101202:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101209:	7e e2                	jle    1011ed <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10120b:	0f b7 05 a4 8e 11 00 	movzwl 0x118ea4,%eax
  101212:	83 e8 50             	sub    $0x50,%eax
  101215:	66 a3 a4 8e 11 00    	mov    %ax,0x118ea4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10121b:	0f b7 05 a6 8e 11 00 	movzwl 0x118ea6,%eax
  101222:	0f b7 c0             	movzwl %ax,%eax
  101225:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101229:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  10122d:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  101231:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101235:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101236:	0f b7 05 a4 8e 11 00 	movzwl 0x118ea4,%eax
  10123d:	66 c1 e8 08          	shr    $0x8,%ax
  101241:	0f b6 c0             	movzbl %al,%eax
  101244:	0f b7 15 a6 8e 11 00 	movzwl 0x118ea6,%edx
  10124b:	83 c2 01             	add    $0x1,%edx
  10124e:	0f b7 d2             	movzwl %dx,%edx
  101251:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  101255:	88 45 e9             	mov    %al,-0x17(%ebp)
  101258:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10125c:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101260:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101261:	0f b7 05 a6 8e 11 00 	movzwl 0x118ea6,%eax
  101268:	0f b7 c0             	movzwl %ax,%eax
  10126b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10126f:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  101273:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101277:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10127b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10127c:	0f b7 05 a4 8e 11 00 	movzwl 0x118ea4,%eax
  101283:	0f b6 c0             	movzbl %al,%eax
  101286:	0f b7 15 a6 8e 11 00 	movzwl 0x118ea6,%edx
  10128d:	83 c2 01             	add    $0x1,%edx
  101290:	0f b7 d2             	movzwl %dx,%edx
  101293:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101297:	88 45 eb             	mov    %al,-0x15(%ebp)
  10129a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10129e:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1012a2:	ee                   	out    %al,(%dx)
}
  1012a3:	90                   	nop
  1012a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012a7:	c9                   	leave  
  1012a8:	c3                   	ret    

001012a9 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012a9:	55                   	push   %ebp
  1012aa:	89 e5                	mov    %esp,%ebp
  1012ac:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012b6:	eb 09                	jmp    1012c1 <serial_putc_sub+0x18>
        delay();
  1012b8:	e8 51 fb ff ff       	call   100e0e <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012c1:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012c7:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1012cb:	89 c2                	mov    %eax,%edx
  1012cd:	ec                   	in     (%dx),%al
  1012ce:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1012d1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1012d5:	0f b6 c0             	movzbl %al,%eax
  1012d8:	83 e0 20             	and    $0x20,%eax
  1012db:	85 c0                	test   %eax,%eax
  1012dd:	75 09                	jne    1012e8 <serial_putc_sub+0x3f>
  1012df:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012e6:	7e d0                	jle    1012b8 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012eb:	0f b6 c0             	movzbl %al,%eax
  1012ee:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1012f4:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012f7:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1012fb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1012ff:	ee                   	out    %al,(%dx)
}
  101300:	90                   	nop
  101301:	c9                   	leave  
  101302:	c3                   	ret    

00101303 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101303:	55                   	push   %ebp
  101304:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101306:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10130a:	74 0d                	je     101319 <serial_putc+0x16>
        serial_putc_sub(c);
  10130c:	ff 75 08             	pushl  0x8(%ebp)
  10130f:	e8 95 ff ff ff       	call   1012a9 <serial_putc_sub>
  101314:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101317:	eb 1e                	jmp    101337 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  101319:	6a 08                	push   $0x8
  10131b:	e8 89 ff ff ff       	call   1012a9 <serial_putc_sub>
  101320:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101323:	6a 20                	push   $0x20
  101325:	e8 7f ff ff ff       	call   1012a9 <serial_putc_sub>
  10132a:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  10132d:	6a 08                	push   $0x8
  10132f:	e8 75 ff ff ff       	call   1012a9 <serial_putc_sub>
  101334:	83 c4 04             	add    $0x4,%esp
    }
}
  101337:	90                   	nop
  101338:	c9                   	leave  
  101339:	c3                   	ret    

0010133a <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10133a:	55                   	push   %ebp
  10133b:	89 e5                	mov    %esp,%ebp
  10133d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101340:	eb 33                	jmp    101375 <cons_intr+0x3b>
        if (c != 0) {
  101342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101346:	74 2d                	je     101375 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101348:	a1 c4 90 11 00       	mov    0x1190c4,%eax
  10134d:	8d 50 01             	lea    0x1(%eax),%edx
  101350:	89 15 c4 90 11 00    	mov    %edx,0x1190c4
  101356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101359:	88 90 c0 8e 11 00    	mov    %dl,0x118ec0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10135f:	a1 c4 90 11 00       	mov    0x1190c4,%eax
  101364:	3d 00 02 00 00       	cmp    $0x200,%eax
  101369:	75 0a                	jne    101375 <cons_intr+0x3b>
                cons.wpos = 0;
  10136b:	c7 05 c4 90 11 00 00 	movl   $0x0,0x1190c4
  101372:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101375:	8b 45 08             	mov    0x8(%ebp),%eax
  101378:	ff d0                	call   *%eax
  10137a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10137d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101381:	75 bf                	jne    101342 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101383:	90                   	nop
  101384:	c9                   	leave  
  101385:	c3                   	ret    

00101386 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101386:	55                   	push   %ebp
  101387:	89 e5                	mov    %esp,%ebp
  101389:	83 ec 10             	sub    $0x10,%esp
  10138c:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101392:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101396:	89 c2                	mov    %eax,%edx
  101398:	ec                   	in     (%dx),%al
  101399:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10139c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013a0:	0f b6 c0             	movzbl %al,%eax
  1013a3:	83 e0 01             	and    $0x1,%eax
  1013a6:	85 c0                	test   %eax,%eax
  1013a8:	75 07                	jne    1013b1 <serial_proc_data+0x2b>
        return -1;
  1013aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013af:	eb 2a                	jmp    1013db <serial_proc_data+0x55>
  1013b1:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013bb:	89 c2                	mov    %eax,%edx
  1013bd:	ec                   	in     (%dx),%al
  1013be:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  1013c1:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013c5:	0f b6 c0             	movzbl %al,%eax
  1013c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013cb:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013cf:	75 07                	jne    1013d8 <serial_proc_data+0x52>
        c = '\b';
  1013d1:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013db:	c9                   	leave  
  1013dc:	c3                   	ret    

001013dd <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013dd:	55                   	push   %ebp
  1013de:	89 e5                	mov    %esp,%ebp
  1013e0:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  1013e3:	a1 a8 8e 11 00       	mov    0x118ea8,%eax
  1013e8:	85 c0                	test   %eax,%eax
  1013ea:	74 10                	je     1013fc <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1013ec:	83 ec 0c             	sub    $0xc,%esp
  1013ef:	68 86 13 10 00       	push   $0x101386
  1013f4:	e8 41 ff ff ff       	call   10133a <cons_intr>
  1013f9:	83 c4 10             	add    $0x10,%esp
    }
}
  1013fc:	90                   	nop
  1013fd:	c9                   	leave  
  1013fe:	c3                   	ret    

001013ff <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013ff:	55                   	push   %ebp
  101400:	89 e5                	mov    %esp,%ebp
  101402:	83 ec 18             	sub    $0x18,%esp
  101405:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10140b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10140f:	89 c2                	mov    %eax,%edx
  101411:	ec                   	in     (%dx),%al
  101412:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101415:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101419:	0f b6 c0             	movzbl %al,%eax
  10141c:	83 e0 01             	and    $0x1,%eax
  10141f:	85 c0                	test   %eax,%eax
  101421:	75 0a                	jne    10142d <kbd_proc_data+0x2e>
        return -1;
  101423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101428:	e9 5d 01 00 00       	jmp    10158a <kbd_proc_data+0x18b>
  10142d:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101433:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101437:	89 c2                	mov    %eax,%edx
  101439:	ec                   	in     (%dx),%al
  10143a:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  10143d:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  101441:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101444:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101448:	75 17                	jne    101461 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10144a:	a1 c8 90 11 00       	mov    0x1190c8,%eax
  10144f:	83 c8 40             	or     $0x40,%eax
  101452:	a3 c8 90 11 00       	mov    %eax,0x1190c8
        return 0;
  101457:	b8 00 00 00 00       	mov    $0x0,%eax
  10145c:	e9 29 01 00 00       	jmp    10158a <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  101461:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101465:	84 c0                	test   %al,%al
  101467:	79 47                	jns    1014b0 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101469:	a1 c8 90 11 00       	mov    0x1190c8,%eax
  10146e:	83 e0 40             	and    $0x40,%eax
  101471:	85 c0                	test   %eax,%eax
  101473:	75 09                	jne    10147e <kbd_proc_data+0x7f>
  101475:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101479:	83 e0 7f             	and    $0x7f,%eax
  10147c:	eb 04                	jmp    101482 <kbd_proc_data+0x83>
  10147e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101482:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101485:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101489:	0f b6 80 80 80 11 00 	movzbl 0x118080(%eax),%eax
  101490:	83 c8 40             	or     $0x40,%eax
  101493:	0f b6 c0             	movzbl %al,%eax
  101496:	f7 d0                	not    %eax
  101498:	89 c2                	mov    %eax,%edx
  10149a:	a1 c8 90 11 00       	mov    0x1190c8,%eax
  10149f:	21 d0                	and    %edx,%eax
  1014a1:	a3 c8 90 11 00       	mov    %eax,0x1190c8
        return 0;
  1014a6:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ab:	e9 da 00 00 00       	jmp    10158a <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  1014b0:	a1 c8 90 11 00       	mov    0x1190c8,%eax
  1014b5:	83 e0 40             	and    $0x40,%eax
  1014b8:	85 c0                	test   %eax,%eax
  1014ba:	74 11                	je     1014cd <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014bc:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014c0:	a1 c8 90 11 00       	mov    0x1190c8,%eax
  1014c5:	83 e0 bf             	and    $0xffffffbf,%eax
  1014c8:	a3 c8 90 11 00       	mov    %eax,0x1190c8
    }

    shift |= shiftcode[data];
  1014cd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d1:	0f b6 80 80 80 11 00 	movzbl 0x118080(%eax),%eax
  1014d8:	0f b6 d0             	movzbl %al,%edx
  1014db:	a1 c8 90 11 00       	mov    0x1190c8,%eax
  1014e0:	09 d0                	or     %edx,%eax
  1014e2:	a3 c8 90 11 00       	mov    %eax,0x1190c8
    shift ^= togglecode[data];
  1014e7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014eb:	0f b6 80 80 81 11 00 	movzbl 0x118180(%eax),%eax
  1014f2:	0f b6 d0             	movzbl %al,%edx
  1014f5:	a1 c8 90 11 00       	mov    0x1190c8,%eax
  1014fa:	31 d0                	xor    %edx,%eax
  1014fc:	a3 c8 90 11 00       	mov    %eax,0x1190c8

    c = charcode[shift & (CTL | SHIFT)][data];
  101501:	a1 c8 90 11 00       	mov    0x1190c8,%eax
  101506:	83 e0 03             	and    $0x3,%eax
  101509:	8b 14 85 80 85 11 00 	mov    0x118580(,%eax,4),%edx
  101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101514:	01 d0                	add    %edx,%eax
  101516:	0f b6 00             	movzbl (%eax),%eax
  101519:	0f b6 c0             	movzbl %al,%eax
  10151c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10151f:	a1 c8 90 11 00       	mov    0x1190c8,%eax
  101524:	83 e0 08             	and    $0x8,%eax
  101527:	85 c0                	test   %eax,%eax
  101529:	74 22                	je     10154d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10152b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10152f:	7e 0c                	jle    10153d <kbd_proc_data+0x13e>
  101531:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101535:	7f 06                	jg     10153d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101537:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10153b:	eb 10                	jmp    10154d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10153d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101541:	7e 0a                	jle    10154d <kbd_proc_data+0x14e>
  101543:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101547:	7f 04                	jg     10154d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101549:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10154d:	a1 c8 90 11 00       	mov    0x1190c8,%eax
  101552:	f7 d0                	not    %eax
  101554:	83 e0 06             	and    $0x6,%eax
  101557:	85 c0                	test   %eax,%eax
  101559:	75 2c                	jne    101587 <kbd_proc_data+0x188>
  10155b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101562:	75 23                	jne    101587 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101564:	83 ec 0c             	sub    $0xc,%esp
  101567:	68 a5 65 10 00       	push   $0x1065a5
  10156c:	e8 fa ec ff ff       	call   10026b <cprintf>
  101571:	83 c4 10             	add    $0x10,%esp
  101574:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  10157a:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10157e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101582:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101586:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101587:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10158a:	c9                   	leave  
  10158b:	c3                   	ret    

0010158c <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10158c:	55                   	push   %ebp
  10158d:	89 e5                	mov    %esp,%ebp
  10158f:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  101592:	83 ec 0c             	sub    $0xc,%esp
  101595:	68 ff 13 10 00       	push   $0x1013ff
  10159a:	e8 9b fd ff ff       	call   10133a <cons_intr>
  10159f:	83 c4 10             	add    $0x10,%esp
}
  1015a2:	90                   	nop
  1015a3:	c9                   	leave  
  1015a4:	c3                   	ret    

001015a5 <kbd_init>:

static void
kbd_init(void) {
  1015a5:	55                   	push   %ebp
  1015a6:	89 e5                	mov    %esp,%ebp
  1015a8:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  1015ab:	e8 dc ff ff ff       	call   10158c <kbd_intr>
    pic_enable(IRQ_KBD);
  1015b0:	83 ec 0c             	sub    $0xc,%esp
  1015b3:	6a 01                	push   $0x1
  1015b5:	e8 4b 01 00 00       	call   101705 <pic_enable>
  1015ba:	83 c4 10             	add    $0x10,%esp
}
  1015bd:	90                   	nop
  1015be:	c9                   	leave  
  1015bf:	c3                   	ret    

001015c0 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015c0:	55                   	push   %ebp
  1015c1:	89 e5                	mov    %esp,%ebp
  1015c3:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  1015c6:	e8 8c f8 ff ff       	call   100e57 <cga_init>
    serial_init();
  1015cb:	e8 6e f9 ff ff       	call   100f3e <serial_init>
    kbd_init();
  1015d0:	e8 d0 ff ff ff       	call   1015a5 <kbd_init>
    if (!serial_exists) {
  1015d5:	a1 a8 8e 11 00       	mov    0x118ea8,%eax
  1015da:	85 c0                	test   %eax,%eax
  1015dc:	75 10                	jne    1015ee <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1015de:	83 ec 0c             	sub    $0xc,%esp
  1015e1:	68 b1 65 10 00       	push   $0x1065b1
  1015e6:	e8 80 ec ff ff       	call   10026b <cprintf>
  1015eb:	83 c4 10             	add    $0x10,%esp
    }
}
  1015ee:	90                   	nop
  1015ef:	c9                   	leave  
  1015f0:	c3                   	ret    

001015f1 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015f1:	55                   	push   %ebp
  1015f2:	89 e5                	mov    %esp,%ebp
  1015f4:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015f7:	e8 d4 f7 ff ff       	call   100dd0 <__intr_save>
  1015fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1015ff:	83 ec 0c             	sub    $0xc,%esp
  101602:	ff 75 08             	pushl  0x8(%ebp)
  101605:	e8 93 fa ff ff       	call   10109d <lpt_putc>
  10160a:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
  10160d:	83 ec 0c             	sub    $0xc,%esp
  101610:	ff 75 08             	pushl  0x8(%ebp)
  101613:	e8 bc fa ff ff       	call   1010d4 <cga_putc>
  101618:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
  10161b:	83 ec 0c             	sub    $0xc,%esp
  10161e:	ff 75 08             	pushl  0x8(%ebp)
  101621:	e8 dd fc ff ff       	call   101303 <serial_putc>
  101626:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  101629:	83 ec 0c             	sub    $0xc,%esp
  10162c:	ff 75 f4             	pushl  -0xc(%ebp)
  10162f:	e8 c6 f7 ff ff       	call   100dfa <__intr_restore>
  101634:	83 c4 10             	add    $0x10,%esp
}
  101637:	90                   	nop
  101638:	c9                   	leave  
  101639:	c3                   	ret    

0010163a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163a:	55                   	push   %ebp
  10163b:	89 e5                	mov    %esp,%ebp
  10163d:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
  101640:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101647:	e8 84 f7 ff ff       	call   100dd0 <__intr_save>
  10164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10164f:	e8 89 fd ff ff       	call   1013dd <serial_intr>
        kbd_intr();
  101654:	e8 33 ff ff ff       	call   10158c <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101659:	8b 15 c0 90 11 00    	mov    0x1190c0,%edx
  10165f:	a1 c4 90 11 00       	mov    0x1190c4,%eax
  101664:	39 c2                	cmp    %eax,%edx
  101666:	74 31                	je     101699 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101668:	a1 c0 90 11 00       	mov    0x1190c0,%eax
  10166d:	8d 50 01             	lea    0x1(%eax),%edx
  101670:	89 15 c0 90 11 00    	mov    %edx,0x1190c0
  101676:	0f b6 80 c0 8e 11 00 	movzbl 0x118ec0(%eax),%eax
  10167d:	0f b6 c0             	movzbl %al,%eax
  101680:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101683:	a1 c0 90 11 00       	mov    0x1190c0,%eax
  101688:	3d 00 02 00 00       	cmp    $0x200,%eax
  10168d:	75 0a                	jne    101699 <cons_getc+0x5f>
                cons.rpos = 0;
  10168f:	c7 05 c0 90 11 00 00 	movl   $0x0,0x1190c0
  101696:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101699:	83 ec 0c             	sub    $0xc,%esp
  10169c:	ff 75 f0             	pushl  -0x10(%ebp)
  10169f:	e8 56 f7 ff ff       	call   100dfa <__intr_restore>
  1016a4:	83 c4 10             	add    $0x10,%esp
    return c;
  1016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016aa:	c9                   	leave  
  1016ab:	c3                   	ret    

001016ac <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ac:	55                   	push   %ebp
  1016ad:	89 e5                	mov    %esp,%ebp
  1016af:	83 ec 14             	sub    $0x14,%esp
  1016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016b9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016bd:	66 a3 90 85 11 00    	mov    %ax,0x118590
    if (did_init) {
  1016c3:	a1 cc 90 11 00       	mov    0x1190cc,%eax
  1016c8:	85 c0                	test   %eax,%eax
  1016ca:	74 36                	je     101702 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016cc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d0:	0f b6 c0             	movzbl %al,%eax
  1016d3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016d9:	88 45 fa             	mov    %al,-0x6(%ebp)
  1016dc:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  1016e0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e4:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016e9:	66 c1 e8 08          	shr    $0x8,%ax
  1016ed:	0f b6 c0             	movzbl %al,%eax
  1016f0:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016f6:	88 45 fb             	mov    %al,-0x5(%ebp)
  1016f9:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  1016fd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101701:	ee                   	out    %al,(%dx)
    }
}
  101702:	90                   	nop
  101703:	c9                   	leave  
  101704:	c3                   	ret    

00101705 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101705:	55                   	push   %ebp
  101706:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101708:	8b 45 08             	mov    0x8(%ebp),%eax
  10170b:	ba 01 00 00 00       	mov    $0x1,%edx
  101710:	89 c1                	mov    %eax,%ecx
  101712:	d3 e2                	shl    %cl,%edx
  101714:	89 d0                	mov    %edx,%eax
  101716:	f7 d0                	not    %eax
  101718:	89 c2                	mov    %eax,%edx
  10171a:	0f b7 05 90 85 11 00 	movzwl 0x118590,%eax
  101721:	21 d0                	and    %edx,%eax
  101723:	0f b7 c0             	movzwl %ax,%eax
  101726:	50                   	push   %eax
  101727:	e8 80 ff ff ff       	call   1016ac <pic_setmask>
  10172c:	83 c4 04             	add    $0x4,%esp
}
  10172f:	90                   	nop
  101730:	c9                   	leave  
  101731:	c3                   	ret    

00101732 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101732:	55                   	push   %ebp
  101733:	89 e5                	mov    %esp,%ebp
  101735:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  101738:	c7 05 cc 90 11 00 01 	movl   $0x1,0x1190cc
  10173f:	00 00 00 
  101742:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101748:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  10174c:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  101750:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101754:	ee                   	out    %al,(%dx)
  101755:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  10175b:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  10175f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  101763:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101767:	ee                   	out    %al,(%dx)
  101768:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  10176e:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  101772:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  101776:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10177a:	ee                   	out    %al,(%dx)
  10177b:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  101781:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  101785:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101789:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10178d:	ee                   	out    %al,(%dx)
  10178e:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  101794:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101798:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  10179c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017a0:	ee                   	out    %al,(%dx)
  1017a1:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  1017a7:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  1017ab:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  1017af:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1017b3:	ee                   	out    %al,(%dx)
  1017b4:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  1017ba:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  1017be:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  1017c2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017c6:	ee                   	out    %al,(%dx)
  1017c7:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  1017cd:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  1017d1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017d5:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1017d9:	ee                   	out    %al,(%dx)
  1017da:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017e0:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  1017e4:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  1017e8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ec:	ee                   	out    %al,(%dx)
  1017ed:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  1017f3:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  1017f7:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  1017fb:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1017ff:	ee                   	out    %al,(%dx)
  101800:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  101806:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  10180a:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  10180e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101812:	ee                   	out    %al,(%dx)
  101813:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101819:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  10181d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101821:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101825:	ee                   	out    %al,(%dx)
  101826:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10182c:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  101830:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  101834:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101838:	ee                   	out    %al,(%dx)
  101839:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  10183f:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  101843:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  101847:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  10184b:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10184c:	0f b7 05 90 85 11 00 	movzwl 0x118590,%eax
  101853:	66 83 f8 ff          	cmp    $0xffff,%ax
  101857:	74 13                	je     10186c <pic_init+0x13a>
        pic_setmask(irq_mask);
  101859:	0f b7 05 90 85 11 00 	movzwl 0x118590,%eax
  101860:	0f b7 c0             	movzwl %ax,%eax
  101863:	50                   	push   %eax
  101864:	e8 43 fe ff ff       	call   1016ac <pic_setmask>
  101869:	83 c4 04             	add    $0x4,%esp
    }
}
  10186c:	90                   	nop
  10186d:	c9                   	leave  
  10186e:	c3                   	ret    

0010186f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10186f:	55                   	push   %ebp
  101870:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  101872:	fb                   	sti    
    sti();
}
  101873:	90                   	nop
  101874:	5d                   	pop    %ebp
  101875:	c3                   	ret    

00101876 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101876:	55                   	push   %ebp
  101877:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  101879:	fa                   	cli    
    cli();
}
  10187a:	90                   	nop
  10187b:	5d                   	pop    %ebp
  10187c:	c3                   	ret    

0010187d <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10187d:	55                   	push   %ebp
  10187e:	89 e5                	mov    %esp,%ebp
  101880:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101883:	83 ec 08             	sub    $0x8,%esp
  101886:	6a 64                	push   $0x64
  101888:	68 e0 65 10 00       	push   $0x1065e0
  10188d:	e8 d9 e9 ff ff       	call   10026b <cprintf>
  101892:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101895:	90                   	nop
  101896:	c9                   	leave  
  101897:	c3                   	ret    

00101898 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101898:	55                   	push   %ebp
  101899:	89 e5                	mov    %esp,%ebp
  10189b:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[]; //256  ISR's entry addrs
     
    uintptr_t ISR_addr = __vectors[0];
  10189e:	a1 20 86 11 00       	mov    0x118620,%eax
  1018a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    for (int i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++, ISR_addr = __vectors[i]){
  1018a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  1018ad:	e9 c2 00 00 00       	jmp    101974 <idt_init+0xdc>
        SETGATE(idt[i], 0, GD_KTEXT, ISR_addr, DPL_USER);                   
  1018b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b5:	89 c2                	mov    %eax,%edx
  1018b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018ba:	66 89 14 c5 e0 90 11 	mov    %dx,0x1190e0(,%eax,8)
  1018c1:	00 
  1018c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018c5:	66 c7 04 c5 e2 90 11 	movw   $0x8,0x1190e2(,%eax,8)
  1018cc:	00 08 00 
  1018cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018d2:	0f b6 14 c5 e4 90 11 	movzbl 0x1190e4(,%eax,8),%edx
  1018d9:	00 
  1018da:	83 e2 e0             	and    $0xffffffe0,%edx
  1018dd:	88 14 c5 e4 90 11 00 	mov    %dl,0x1190e4(,%eax,8)
  1018e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018e7:	0f b6 14 c5 e4 90 11 	movzbl 0x1190e4(,%eax,8),%edx
  1018ee:	00 
  1018ef:	83 e2 1f             	and    $0x1f,%edx
  1018f2:	88 14 c5 e4 90 11 00 	mov    %dl,0x1190e4(,%eax,8)
  1018f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018fc:	0f b6 14 c5 e5 90 11 	movzbl 0x1190e5(,%eax,8),%edx
  101903:	00 
  101904:	83 e2 f0             	and    $0xfffffff0,%edx
  101907:	83 ca 0e             	or     $0xe,%edx
  10190a:	88 14 c5 e5 90 11 00 	mov    %dl,0x1190e5(,%eax,8)
  101911:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101914:	0f b6 14 c5 e5 90 11 	movzbl 0x1190e5(,%eax,8),%edx
  10191b:	00 
  10191c:	83 e2 ef             	and    $0xffffffef,%edx
  10191f:	88 14 c5 e5 90 11 00 	mov    %dl,0x1190e5(,%eax,8)
  101926:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101929:	0f b6 14 c5 e5 90 11 	movzbl 0x1190e5(,%eax,8),%edx
  101930:	00 
  101931:	83 ca 60             	or     $0x60,%edx
  101934:	88 14 c5 e5 90 11 00 	mov    %dl,0x1190e5(,%eax,8)
  10193b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10193e:	0f b6 14 c5 e5 90 11 	movzbl 0x1190e5(,%eax,8),%edx
  101945:	00 
  101946:	83 ca 80             	or     $0xffffff80,%edx
  101949:	88 14 c5 e5 90 11 00 	mov    %dl,0x1190e5(,%eax,8)
  101950:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101953:	c1 e8 10             	shr    $0x10,%eax
  101956:	89 c2                	mov    %eax,%edx
  101958:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10195b:	66 89 14 c5 e6 90 11 	mov    %dx,0x1190e6(,%eax,8)
  101962:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[]; //256  ISR's entry addrs
     
    uintptr_t ISR_addr = __vectors[0];
    for (int i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++, ISR_addr = __vectors[i]){
  101963:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  101967:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10196a:	8b 04 85 20 86 11 00 	mov    0x118620(,%eax,4),%eax
  101971:	89 45 fc             	mov    %eax,-0x4(%ebp)
  101974:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101977:	3d ff 00 00 00       	cmp    $0xff,%eax
  10197c:	0f 86 30 ff ff ff    	jbe    1018b2 <idt_init+0x1a>
        SETGATE(idt[i], 0, GD_KTEXT, ISR_addr, DPL_USER);                   
    }
    /*开启陷阱门*/
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  101982:	a1 04 88 11 00       	mov    0x118804,%eax
  101987:	66 a3 a8 94 11 00    	mov    %ax,0x1194a8
  10198d:	66 c7 05 aa 94 11 00 	movw   $0x8,0x1194aa
  101994:	08 00 
  101996:	0f b6 05 ac 94 11 00 	movzbl 0x1194ac,%eax
  10199d:	83 e0 e0             	and    $0xffffffe0,%eax
  1019a0:	a2 ac 94 11 00       	mov    %al,0x1194ac
  1019a5:	0f b6 05 ac 94 11 00 	movzbl 0x1194ac,%eax
  1019ac:	83 e0 1f             	and    $0x1f,%eax
  1019af:	a2 ac 94 11 00       	mov    %al,0x1194ac
  1019b4:	0f b6 05 ad 94 11 00 	movzbl 0x1194ad,%eax
  1019bb:	83 c8 0f             	or     $0xf,%eax
  1019be:	a2 ad 94 11 00       	mov    %al,0x1194ad
  1019c3:	0f b6 05 ad 94 11 00 	movzbl 0x1194ad,%eax
  1019ca:	83 e0 ef             	and    $0xffffffef,%eax
  1019cd:	a2 ad 94 11 00       	mov    %al,0x1194ad
  1019d2:	0f b6 05 ad 94 11 00 	movzbl 0x1194ad,%eax
  1019d9:	83 c8 60             	or     $0x60,%eax
  1019dc:	a2 ad 94 11 00       	mov    %al,0x1194ad
  1019e1:	0f b6 05 ad 94 11 00 	movzbl 0x1194ad,%eax
  1019e8:	83 c8 80             	or     $0xffffff80,%eax
  1019eb:	a2 ad 94 11 00       	mov    %al,0x1194ad
  1019f0:	a1 04 88 11 00       	mov    0x118804,%eax
  1019f5:	c1 e8 10             	shr    $0x10,%eax
  1019f8:	66 a3 ae 94 11 00    	mov    %ax,0x1194ae
  1019fe:	c7 45 f4 a0 85 11 00 	movl   $0x1185a0,-0xc(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a08:	0f 01 18             	lidtl  (%eax)

    lidt(&idt_pd); 
}
  101a0b:	90                   	nop
  101a0c:	c9                   	leave  
  101a0d:	c3                   	ret    

00101a0e <trapname>:

static const char *
trapname(int trapno) {
  101a0e:	55                   	push   %ebp
  101a0f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a11:	8b 45 08             	mov    0x8(%ebp),%eax
  101a14:	83 f8 13             	cmp    $0x13,%eax
  101a17:	77 0c                	ja     101a25 <trapname+0x17>
        return excnames[trapno];
  101a19:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1c:	8b 04 85 40 69 10 00 	mov    0x106940(,%eax,4),%eax
  101a23:	eb 18                	jmp    101a3d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a25:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a29:	7e 0d                	jle    101a38 <trapname+0x2a>
  101a2b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a2f:	7f 07                	jg     101a38 <trapname+0x2a>
        return "Hardware Interrupt";
  101a31:	b8 ea 65 10 00       	mov    $0x1065ea,%eax
  101a36:	eb 05                	jmp    101a3d <trapname+0x2f>
    }
    return "(unknown trap)";
  101a38:	b8 fd 65 10 00       	mov    $0x1065fd,%eax
}
  101a3d:	5d                   	pop    %ebp
  101a3e:	c3                   	ret    

00101a3f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a3f:	55                   	push   %ebp
  101a40:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a42:	8b 45 08             	mov    0x8(%ebp),%eax
  101a45:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a49:	66 83 f8 08          	cmp    $0x8,%ax
  101a4d:	0f 94 c0             	sete   %al
  101a50:	0f b6 c0             	movzbl %al,%eax
}
  101a53:	5d                   	pop    %ebp
  101a54:	c3                   	ret    

00101a55 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a55:	55                   	push   %ebp
  101a56:	89 e5                	mov    %esp,%ebp
  101a58:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101a5b:	83 ec 08             	sub    $0x8,%esp
  101a5e:	ff 75 08             	pushl  0x8(%ebp)
  101a61:	68 3e 66 10 00       	push   $0x10663e
  101a66:	e8 00 e8 ff ff       	call   10026b <cprintf>
  101a6b:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a71:	83 ec 0c             	sub    $0xc,%esp
  101a74:	50                   	push   %eax
  101a75:	e8 b8 01 00 00       	call   101c32 <print_regs>
  101a7a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a80:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a84:	0f b7 c0             	movzwl %ax,%eax
  101a87:	83 ec 08             	sub    $0x8,%esp
  101a8a:	50                   	push   %eax
  101a8b:	68 4f 66 10 00       	push   $0x10664f
  101a90:	e8 d6 e7 ff ff       	call   10026b <cprintf>
  101a95:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a98:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a9f:	0f b7 c0             	movzwl %ax,%eax
  101aa2:	83 ec 08             	sub    $0x8,%esp
  101aa5:	50                   	push   %eax
  101aa6:	68 62 66 10 00       	push   $0x106662
  101aab:	e8 bb e7 ff ff       	call   10026b <cprintf>
  101ab0:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab6:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aba:	0f b7 c0             	movzwl %ax,%eax
  101abd:	83 ec 08             	sub    $0x8,%esp
  101ac0:	50                   	push   %eax
  101ac1:	68 75 66 10 00       	push   $0x106675
  101ac6:	e8 a0 e7 ff ff       	call   10026b <cprintf>
  101acb:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ace:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad1:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ad5:	0f b7 c0             	movzwl %ax,%eax
  101ad8:	83 ec 08             	sub    $0x8,%esp
  101adb:	50                   	push   %eax
  101adc:	68 88 66 10 00       	push   $0x106688
  101ae1:	e8 85 e7 ff ff       	call   10026b <cprintf>
  101ae6:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aec:	8b 40 30             	mov    0x30(%eax),%eax
  101aef:	83 ec 0c             	sub    $0xc,%esp
  101af2:	50                   	push   %eax
  101af3:	e8 16 ff ff ff       	call   101a0e <trapname>
  101af8:	83 c4 10             	add    $0x10,%esp
  101afb:	89 c2                	mov    %eax,%edx
  101afd:	8b 45 08             	mov    0x8(%ebp),%eax
  101b00:	8b 40 30             	mov    0x30(%eax),%eax
  101b03:	83 ec 04             	sub    $0x4,%esp
  101b06:	52                   	push   %edx
  101b07:	50                   	push   %eax
  101b08:	68 9b 66 10 00       	push   $0x10669b
  101b0d:	e8 59 e7 ff ff       	call   10026b <cprintf>
  101b12:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b15:	8b 45 08             	mov    0x8(%ebp),%eax
  101b18:	8b 40 34             	mov    0x34(%eax),%eax
  101b1b:	83 ec 08             	sub    $0x8,%esp
  101b1e:	50                   	push   %eax
  101b1f:	68 ad 66 10 00       	push   $0x1066ad
  101b24:	e8 42 e7 ff ff       	call   10026b <cprintf>
  101b29:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2f:	8b 40 38             	mov    0x38(%eax),%eax
  101b32:	83 ec 08             	sub    $0x8,%esp
  101b35:	50                   	push   %eax
  101b36:	68 bc 66 10 00       	push   $0x1066bc
  101b3b:	e8 2b e7 ff ff       	call   10026b <cprintf>
  101b40:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b43:	8b 45 08             	mov    0x8(%ebp),%eax
  101b46:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b4a:	0f b7 c0             	movzwl %ax,%eax
  101b4d:	83 ec 08             	sub    $0x8,%esp
  101b50:	50                   	push   %eax
  101b51:	68 cb 66 10 00       	push   $0x1066cb
  101b56:	e8 10 e7 ff ff       	call   10026b <cprintf>
  101b5b:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b61:	8b 40 40             	mov    0x40(%eax),%eax
  101b64:	83 ec 08             	sub    $0x8,%esp
  101b67:	50                   	push   %eax
  101b68:	68 de 66 10 00       	push   $0x1066de
  101b6d:	e8 f9 e6 ff ff       	call   10026b <cprintf>
  101b72:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b7c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b83:	eb 3f                	jmp    101bc4 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b85:	8b 45 08             	mov    0x8(%ebp),%eax
  101b88:	8b 50 40             	mov    0x40(%eax),%edx
  101b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b8e:	21 d0                	and    %edx,%eax
  101b90:	85 c0                	test   %eax,%eax
  101b92:	74 29                	je     101bbd <print_trapframe+0x168>
  101b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b97:	8b 04 85 c0 85 11 00 	mov    0x1185c0(,%eax,4),%eax
  101b9e:	85 c0                	test   %eax,%eax
  101ba0:	74 1b                	je     101bbd <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba5:	8b 04 85 c0 85 11 00 	mov    0x1185c0(,%eax,4),%eax
  101bac:	83 ec 08             	sub    $0x8,%esp
  101baf:	50                   	push   %eax
  101bb0:	68 ed 66 10 00       	push   $0x1066ed
  101bb5:	e8 b1 e6 ff ff       	call   10026b <cprintf>
  101bba:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bbd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bc1:	d1 65 f0             	shll   -0x10(%ebp)
  101bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc7:	83 f8 17             	cmp    $0x17,%eax
  101bca:	76 b9                	jbe    101b85 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcf:	8b 40 40             	mov    0x40(%eax),%eax
  101bd2:	25 00 30 00 00       	and    $0x3000,%eax
  101bd7:	c1 e8 0c             	shr    $0xc,%eax
  101bda:	83 ec 08             	sub    $0x8,%esp
  101bdd:	50                   	push   %eax
  101bde:	68 f1 66 10 00       	push   $0x1066f1
  101be3:	e8 83 e6 ff ff       	call   10026b <cprintf>
  101be8:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101beb:	83 ec 0c             	sub    $0xc,%esp
  101bee:	ff 75 08             	pushl  0x8(%ebp)
  101bf1:	e8 49 fe ff ff       	call   101a3f <trap_in_kernel>
  101bf6:	83 c4 10             	add    $0x10,%esp
  101bf9:	85 c0                	test   %eax,%eax
  101bfb:	75 32                	jne    101c2f <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  101c00:	8b 40 44             	mov    0x44(%eax),%eax
  101c03:	83 ec 08             	sub    $0x8,%esp
  101c06:	50                   	push   %eax
  101c07:	68 fa 66 10 00       	push   $0x1066fa
  101c0c:	e8 5a e6 ff ff       	call   10026b <cprintf>
  101c11:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c14:	8b 45 08             	mov    0x8(%ebp),%eax
  101c17:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c1b:	0f b7 c0             	movzwl %ax,%eax
  101c1e:	83 ec 08             	sub    $0x8,%esp
  101c21:	50                   	push   %eax
  101c22:	68 09 67 10 00       	push   $0x106709
  101c27:	e8 3f e6 ff ff       	call   10026b <cprintf>
  101c2c:	83 c4 10             	add    $0x10,%esp
    }
}
  101c2f:	90                   	nop
  101c30:	c9                   	leave  
  101c31:	c3                   	ret    

00101c32 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c32:	55                   	push   %ebp
  101c33:	89 e5                	mov    %esp,%ebp
  101c35:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c38:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3b:	8b 00                	mov    (%eax),%eax
  101c3d:	83 ec 08             	sub    $0x8,%esp
  101c40:	50                   	push   %eax
  101c41:	68 1c 67 10 00       	push   $0x10671c
  101c46:	e8 20 e6 ff ff       	call   10026b <cprintf>
  101c4b:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c51:	8b 40 04             	mov    0x4(%eax),%eax
  101c54:	83 ec 08             	sub    $0x8,%esp
  101c57:	50                   	push   %eax
  101c58:	68 2b 67 10 00       	push   $0x10672b
  101c5d:	e8 09 e6 ff ff       	call   10026b <cprintf>
  101c62:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c65:	8b 45 08             	mov    0x8(%ebp),%eax
  101c68:	8b 40 08             	mov    0x8(%eax),%eax
  101c6b:	83 ec 08             	sub    $0x8,%esp
  101c6e:	50                   	push   %eax
  101c6f:	68 3a 67 10 00       	push   $0x10673a
  101c74:	e8 f2 e5 ff ff       	call   10026b <cprintf>
  101c79:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7f:	8b 40 0c             	mov    0xc(%eax),%eax
  101c82:	83 ec 08             	sub    $0x8,%esp
  101c85:	50                   	push   %eax
  101c86:	68 49 67 10 00       	push   $0x106749
  101c8b:	e8 db e5 ff ff       	call   10026b <cprintf>
  101c90:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c93:	8b 45 08             	mov    0x8(%ebp),%eax
  101c96:	8b 40 10             	mov    0x10(%eax),%eax
  101c99:	83 ec 08             	sub    $0x8,%esp
  101c9c:	50                   	push   %eax
  101c9d:	68 58 67 10 00       	push   $0x106758
  101ca2:	e8 c4 e5 ff ff       	call   10026b <cprintf>
  101ca7:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101caa:	8b 45 08             	mov    0x8(%ebp),%eax
  101cad:	8b 40 14             	mov    0x14(%eax),%eax
  101cb0:	83 ec 08             	sub    $0x8,%esp
  101cb3:	50                   	push   %eax
  101cb4:	68 67 67 10 00       	push   $0x106767
  101cb9:	e8 ad e5 ff ff       	call   10026b <cprintf>
  101cbe:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc4:	8b 40 18             	mov    0x18(%eax),%eax
  101cc7:	83 ec 08             	sub    $0x8,%esp
  101cca:	50                   	push   %eax
  101ccb:	68 76 67 10 00       	push   $0x106776
  101cd0:	e8 96 e5 ff ff       	call   10026b <cprintf>
  101cd5:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdb:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cde:	83 ec 08             	sub    $0x8,%esp
  101ce1:	50                   	push   %eax
  101ce2:	68 85 67 10 00       	push   $0x106785
  101ce7:	e8 7f e5 ff ff       	call   10026b <cprintf>
  101cec:	83 c4 10             	add    $0x10,%esp
}
  101cef:	90                   	nop
  101cf0:	c9                   	leave  
  101cf1:	c3                   	ret    

00101cf2 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cf2:	55                   	push   %ebp
  101cf3:	89 e5                	mov    %esp,%ebp
  101cf5:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfb:	8b 40 30             	mov    0x30(%eax),%eax
  101cfe:	83 f8 2f             	cmp    $0x2f,%eax
  101d01:	77 1d                	ja     101d20 <trap_dispatch+0x2e>
  101d03:	83 f8 2e             	cmp    $0x2e,%eax
  101d06:	0f 83 2d 01 00 00    	jae    101e39 <trap_dispatch+0x147>
  101d0c:	83 f8 21             	cmp    $0x21,%eax
  101d0f:	74 77                	je     101d88 <trap_dispatch+0x96>
  101d11:	83 f8 24             	cmp    $0x24,%eax
  101d14:	74 4b                	je     101d61 <trap_dispatch+0x6f>
  101d16:	83 f8 20             	cmp    $0x20,%eax
  101d19:	74 1c                	je     101d37 <trap_dispatch+0x45>
  101d1b:	e9 e3 00 00 00       	jmp    101e03 <trap_dispatch+0x111>
  101d20:	83 f8 78             	cmp    $0x78,%eax
  101d23:	0f 84 86 00 00 00    	je     101daf <trap_dispatch+0xbd>
  101d29:	83 f8 79             	cmp    $0x79,%eax
  101d2c:	0f 84 b4 00 00 00    	je     101de6 <trap_dispatch+0xf4>
  101d32:	e9 cc 00 00 00       	jmp    101e03 <trap_dispatch+0x111>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        if(++ticks == TICK_NUM){
  101d37:	a1 6c 99 11 00       	mov    0x11996c,%eax
  101d3c:	83 c0 01             	add    $0x1,%eax
  101d3f:	a3 6c 99 11 00       	mov    %eax,0x11996c
  101d44:	83 f8 64             	cmp    $0x64,%eax
  101d47:	0f 85 ef 00 00 00    	jne    101e3c <trap_dispatch+0x14a>
            print_ticks();
  101d4d:	e8 2b fb ff ff       	call   10187d <print_ticks>
            ticks = 0;
  101d52:	c7 05 6c 99 11 00 00 	movl   $0x0,0x11996c
  101d59:	00 00 00 
        }

        break;
  101d5c:	e9 db 00 00 00       	jmp    101e3c <trap_dispatch+0x14a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d61:	e8 d4 f8 ff ff       	call   10163a <cons_getc>
  101d66:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d69:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d6d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d71:	83 ec 04             	sub    $0x4,%esp
  101d74:	52                   	push   %edx
  101d75:	50                   	push   %eax
  101d76:	68 94 67 10 00       	push   $0x106794
  101d7b:	e8 eb e4 ff ff       	call   10026b <cprintf>
  101d80:	83 c4 10             	add    $0x10,%esp
        break;
  101d83:	e9 b5 00 00 00       	jmp    101e3d <trap_dispatch+0x14b>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d88:	e8 ad f8 ff ff       	call   10163a <cons_getc>
  101d8d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d90:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d94:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d98:	83 ec 04             	sub    $0x4,%esp
  101d9b:	52                   	push   %edx
  101d9c:	50                   	push   %eax
  101d9d:	68 a6 67 10 00       	push   $0x1067a6
  101da2:	e8 c4 e4 ff ff       	call   10026b <cprintf>
  101da7:	83 c4 10             	add    $0x10,%esp
        break;
  101daa:	e9 8e 00 00 00       	jmp    101e3d <trap_dispatch+0x14b>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        tf->tf_eflags |= FL_IOPL_MASK;
  101daf:	8b 45 08             	mov    0x8(%ebp),%eax
  101db2:	8b 40 40             	mov    0x40(%eax),%eax
  101db5:	80 cc 30             	or     $0x30,%ah
  101db8:	89 c2                	mov    %eax,%edx
  101dba:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbd:	89 50 40             	mov    %edx,0x40(%eax)
        tf->tf_es = USER_DS;
  101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc3:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
        tf->tf_ds = USER_DS;
  101dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcc:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
        tf->tf_ss = USER_DS;
  101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd5:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
        tf->tf_cs = USER_CS;
  101ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dde:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
        break;
  101de4:	eb 57                	jmp    101e3d <trap_dispatch+0x14b>
    case T_SWITCH_TOK:
        tf->tf_es = KERNEL_DS;
  101de6:	8b 45 08             	mov    0x8(%ebp),%eax
  101de9:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_ds = KERNEL_DS;
  101def:	8b 45 08             	mov    0x8(%ebp),%eax
  101df2:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        // tf->tf_ss = 0x10;
        tf->tf_cs = KERNEL_CS;
  101df8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfb:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        break;
  101e01:	eb 3a                	jmp    101e3d <trap_dispatch+0x14b>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e03:	8b 45 08             	mov    0x8(%ebp),%eax
  101e06:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e0a:	0f b7 c0             	movzwl %ax,%eax
  101e0d:	83 e0 03             	and    $0x3,%eax
  101e10:	85 c0                	test   %eax,%eax
  101e12:	75 29                	jne    101e3d <trap_dispatch+0x14b>
            print_trapframe(tf);
  101e14:	83 ec 0c             	sub    $0xc,%esp
  101e17:	ff 75 08             	pushl  0x8(%ebp)
  101e1a:	e8 36 fc ff ff       	call   101a55 <print_trapframe>
  101e1f:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101e22:	83 ec 04             	sub    $0x4,%esp
  101e25:	68 b5 67 10 00       	push   $0x1067b5
  101e2a:	68 c6 00 00 00       	push   $0xc6
  101e2f:	68 d1 67 10 00       	push   $0x1067d1
  101e34:	e8 98 e5 ff ff       	call   1003d1 <__panic>
        // panic("T_SWITCH_** ??\n");
        // break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e39:	90                   	nop
  101e3a:	eb 01                	jmp    101e3d <trap_dispatch+0x14b>
        if(++ticks == TICK_NUM){
            print_ticks();
            ticks = 0;
        }

        break;
  101e3c:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e3d:	90                   	nop
  101e3e:	c9                   	leave  
  101e3f:	c3                   	ret    

00101e40 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e40:	55                   	push   %ebp
  101e41:	89 e5                	mov    %esp,%ebp
  101e43:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e46:	83 ec 0c             	sub    $0xc,%esp
  101e49:	ff 75 08             	pushl  0x8(%ebp)
  101e4c:	e8 a1 fe ff ff       	call   101cf2 <trap_dispatch>
  101e51:	83 c4 10             	add    $0x10,%esp
}
  101e54:	90                   	nop
  101e55:	c9                   	leave  
  101e56:	c3                   	ret    

00101e57 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e57:	6a 00                	push   $0x0
  pushl $0
  101e59:	6a 00                	push   $0x0
  jmp __alltraps
  101e5b:	e9 67 0a 00 00       	jmp    1028c7 <__alltraps>

00101e60 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e60:	6a 00                	push   $0x0
  pushl $1
  101e62:	6a 01                	push   $0x1
  jmp __alltraps
  101e64:	e9 5e 0a 00 00       	jmp    1028c7 <__alltraps>

00101e69 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e69:	6a 00                	push   $0x0
  pushl $2
  101e6b:	6a 02                	push   $0x2
  jmp __alltraps
  101e6d:	e9 55 0a 00 00       	jmp    1028c7 <__alltraps>

00101e72 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e72:	6a 00                	push   $0x0
  pushl $3
  101e74:	6a 03                	push   $0x3
  jmp __alltraps
  101e76:	e9 4c 0a 00 00       	jmp    1028c7 <__alltraps>

00101e7b <vector4>:
.globl vector4
vector4:
  pushl $0
  101e7b:	6a 00                	push   $0x0
  pushl $4
  101e7d:	6a 04                	push   $0x4
  jmp __alltraps
  101e7f:	e9 43 0a 00 00       	jmp    1028c7 <__alltraps>

00101e84 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e84:	6a 00                	push   $0x0
  pushl $5
  101e86:	6a 05                	push   $0x5
  jmp __alltraps
  101e88:	e9 3a 0a 00 00       	jmp    1028c7 <__alltraps>

00101e8d <vector6>:
.globl vector6
vector6:
  pushl $0
  101e8d:	6a 00                	push   $0x0
  pushl $6
  101e8f:	6a 06                	push   $0x6
  jmp __alltraps
  101e91:	e9 31 0a 00 00       	jmp    1028c7 <__alltraps>

00101e96 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e96:	6a 00                	push   $0x0
  pushl $7
  101e98:	6a 07                	push   $0x7
  jmp __alltraps
  101e9a:	e9 28 0a 00 00       	jmp    1028c7 <__alltraps>

00101e9f <vector8>:
.globl vector8
vector8:
  pushl $8
  101e9f:	6a 08                	push   $0x8
  jmp __alltraps
  101ea1:	e9 21 0a 00 00       	jmp    1028c7 <__alltraps>

00101ea6 <vector9>:
.globl vector9
vector9:
  pushl $9
  101ea6:	6a 09                	push   $0x9
  jmp __alltraps
  101ea8:	e9 1a 0a 00 00       	jmp    1028c7 <__alltraps>

00101ead <vector10>:
.globl vector10
vector10:
  pushl $10
  101ead:	6a 0a                	push   $0xa
  jmp __alltraps
  101eaf:	e9 13 0a 00 00       	jmp    1028c7 <__alltraps>

00101eb4 <vector11>:
.globl vector11
vector11:
  pushl $11
  101eb4:	6a 0b                	push   $0xb
  jmp __alltraps
  101eb6:	e9 0c 0a 00 00       	jmp    1028c7 <__alltraps>

00101ebb <vector12>:
.globl vector12
vector12:
  pushl $12
  101ebb:	6a 0c                	push   $0xc
  jmp __alltraps
  101ebd:	e9 05 0a 00 00       	jmp    1028c7 <__alltraps>

00101ec2 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ec2:	6a 0d                	push   $0xd
  jmp __alltraps
  101ec4:	e9 fe 09 00 00       	jmp    1028c7 <__alltraps>

00101ec9 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ec9:	6a 0e                	push   $0xe
  jmp __alltraps
  101ecb:	e9 f7 09 00 00       	jmp    1028c7 <__alltraps>

00101ed0 <vector15>:
.globl vector15
vector15:
  pushl $0
  101ed0:	6a 00                	push   $0x0
  pushl $15
  101ed2:	6a 0f                	push   $0xf
  jmp __alltraps
  101ed4:	e9 ee 09 00 00       	jmp    1028c7 <__alltraps>

00101ed9 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ed9:	6a 00                	push   $0x0
  pushl $16
  101edb:	6a 10                	push   $0x10
  jmp __alltraps
  101edd:	e9 e5 09 00 00       	jmp    1028c7 <__alltraps>

00101ee2 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ee2:	6a 11                	push   $0x11
  jmp __alltraps
  101ee4:	e9 de 09 00 00       	jmp    1028c7 <__alltraps>

00101ee9 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ee9:	6a 00                	push   $0x0
  pushl $18
  101eeb:	6a 12                	push   $0x12
  jmp __alltraps
  101eed:	e9 d5 09 00 00       	jmp    1028c7 <__alltraps>

00101ef2 <vector19>:
.globl vector19
vector19:
  pushl $0
  101ef2:	6a 00                	push   $0x0
  pushl $19
  101ef4:	6a 13                	push   $0x13
  jmp __alltraps
  101ef6:	e9 cc 09 00 00       	jmp    1028c7 <__alltraps>

00101efb <vector20>:
.globl vector20
vector20:
  pushl $0
  101efb:	6a 00                	push   $0x0
  pushl $20
  101efd:	6a 14                	push   $0x14
  jmp __alltraps
  101eff:	e9 c3 09 00 00       	jmp    1028c7 <__alltraps>

00101f04 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f04:	6a 00                	push   $0x0
  pushl $21
  101f06:	6a 15                	push   $0x15
  jmp __alltraps
  101f08:	e9 ba 09 00 00       	jmp    1028c7 <__alltraps>

00101f0d <vector22>:
.globl vector22
vector22:
  pushl $0
  101f0d:	6a 00                	push   $0x0
  pushl $22
  101f0f:	6a 16                	push   $0x16
  jmp __alltraps
  101f11:	e9 b1 09 00 00       	jmp    1028c7 <__alltraps>

00101f16 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f16:	6a 00                	push   $0x0
  pushl $23
  101f18:	6a 17                	push   $0x17
  jmp __alltraps
  101f1a:	e9 a8 09 00 00       	jmp    1028c7 <__alltraps>

00101f1f <vector24>:
.globl vector24
vector24:
  pushl $0
  101f1f:	6a 00                	push   $0x0
  pushl $24
  101f21:	6a 18                	push   $0x18
  jmp __alltraps
  101f23:	e9 9f 09 00 00       	jmp    1028c7 <__alltraps>

00101f28 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f28:	6a 00                	push   $0x0
  pushl $25
  101f2a:	6a 19                	push   $0x19
  jmp __alltraps
  101f2c:	e9 96 09 00 00       	jmp    1028c7 <__alltraps>

00101f31 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $26
  101f33:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f35:	e9 8d 09 00 00       	jmp    1028c7 <__alltraps>

00101f3a <vector27>:
.globl vector27
vector27:
  pushl $0
  101f3a:	6a 00                	push   $0x0
  pushl $27
  101f3c:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f3e:	e9 84 09 00 00       	jmp    1028c7 <__alltraps>

00101f43 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f43:	6a 00                	push   $0x0
  pushl $28
  101f45:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f47:	e9 7b 09 00 00       	jmp    1028c7 <__alltraps>

00101f4c <vector29>:
.globl vector29
vector29:
  pushl $0
  101f4c:	6a 00                	push   $0x0
  pushl $29
  101f4e:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f50:	e9 72 09 00 00       	jmp    1028c7 <__alltraps>

00101f55 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f55:	6a 00                	push   $0x0
  pushl $30
  101f57:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f59:	e9 69 09 00 00       	jmp    1028c7 <__alltraps>

00101f5e <vector31>:
.globl vector31
vector31:
  pushl $0
  101f5e:	6a 00                	push   $0x0
  pushl $31
  101f60:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f62:	e9 60 09 00 00       	jmp    1028c7 <__alltraps>

00101f67 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f67:	6a 00                	push   $0x0
  pushl $32
  101f69:	6a 20                	push   $0x20
  jmp __alltraps
  101f6b:	e9 57 09 00 00       	jmp    1028c7 <__alltraps>

00101f70 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f70:	6a 00                	push   $0x0
  pushl $33
  101f72:	6a 21                	push   $0x21
  jmp __alltraps
  101f74:	e9 4e 09 00 00       	jmp    1028c7 <__alltraps>

00101f79 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f79:	6a 00                	push   $0x0
  pushl $34
  101f7b:	6a 22                	push   $0x22
  jmp __alltraps
  101f7d:	e9 45 09 00 00       	jmp    1028c7 <__alltraps>

00101f82 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f82:	6a 00                	push   $0x0
  pushl $35
  101f84:	6a 23                	push   $0x23
  jmp __alltraps
  101f86:	e9 3c 09 00 00       	jmp    1028c7 <__alltraps>

00101f8b <vector36>:
.globl vector36
vector36:
  pushl $0
  101f8b:	6a 00                	push   $0x0
  pushl $36
  101f8d:	6a 24                	push   $0x24
  jmp __alltraps
  101f8f:	e9 33 09 00 00       	jmp    1028c7 <__alltraps>

00101f94 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f94:	6a 00                	push   $0x0
  pushl $37
  101f96:	6a 25                	push   $0x25
  jmp __alltraps
  101f98:	e9 2a 09 00 00       	jmp    1028c7 <__alltraps>

00101f9d <vector38>:
.globl vector38
vector38:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $38
  101f9f:	6a 26                	push   $0x26
  jmp __alltraps
  101fa1:	e9 21 09 00 00       	jmp    1028c7 <__alltraps>

00101fa6 <vector39>:
.globl vector39
vector39:
  pushl $0
  101fa6:	6a 00                	push   $0x0
  pushl $39
  101fa8:	6a 27                	push   $0x27
  jmp __alltraps
  101faa:	e9 18 09 00 00       	jmp    1028c7 <__alltraps>

00101faf <vector40>:
.globl vector40
vector40:
  pushl $0
  101faf:	6a 00                	push   $0x0
  pushl $40
  101fb1:	6a 28                	push   $0x28
  jmp __alltraps
  101fb3:	e9 0f 09 00 00       	jmp    1028c7 <__alltraps>

00101fb8 <vector41>:
.globl vector41
vector41:
  pushl $0
  101fb8:	6a 00                	push   $0x0
  pushl $41
  101fba:	6a 29                	push   $0x29
  jmp __alltraps
  101fbc:	e9 06 09 00 00       	jmp    1028c7 <__alltraps>

00101fc1 <vector42>:
.globl vector42
vector42:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $42
  101fc3:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fc5:	e9 fd 08 00 00       	jmp    1028c7 <__alltraps>

00101fca <vector43>:
.globl vector43
vector43:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $43
  101fcc:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fce:	e9 f4 08 00 00       	jmp    1028c7 <__alltraps>

00101fd3 <vector44>:
.globl vector44
vector44:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $44
  101fd5:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fd7:	e9 eb 08 00 00       	jmp    1028c7 <__alltraps>

00101fdc <vector45>:
.globl vector45
vector45:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $45
  101fde:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fe0:	e9 e2 08 00 00       	jmp    1028c7 <__alltraps>

00101fe5 <vector46>:
.globl vector46
vector46:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $46
  101fe7:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fe9:	e9 d9 08 00 00       	jmp    1028c7 <__alltraps>

00101fee <vector47>:
.globl vector47
vector47:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $47
  101ff0:	6a 2f                	push   $0x2f
  jmp __alltraps
  101ff2:	e9 d0 08 00 00       	jmp    1028c7 <__alltraps>

00101ff7 <vector48>:
.globl vector48
vector48:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $48
  101ff9:	6a 30                	push   $0x30
  jmp __alltraps
  101ffb:	e9 c7 08 00 00       	jmp    1028c7 <__alltraps>

00102000 <vector49>:
.globl vector49
vector49:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $49
  102002:	6a 31                	push   $0x31
  jmp __alltraps
  102004:	e9 be 08 00 00       	jmp    1028c7 <__alltraps>

00102009 <vector50>:
.globl vector50
vector50:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $50
  10200b:	6a 32                	push   $0x32
  jmp __alltraps
  10200d:	e9 b5 08 00 00       	jmp    1028c7 <__alltraps>

00102012 <vector51>:
.globl vector51
vector51:
  pushl $0
  102012:	6a 00                	push   $0x0
  pushl $51
  102014:	6a 33                	push   $0x33
  jmp __alltraps
  102016:	e9 ac 08 00 00       	jmp    1028c7 <__alltraps>

0010201b <vector52>:
.globl vector52
vector52:
  pushl $0
  10201b:	6a 00                	push   $0x0
  pushl $52
  10201d:	6a 34                	push   $0x34
  jmp __alltraps
  10201f:	e9 a3 08 00 00       	jmp    1028c7 <__alltraps>

00102024 <vector53>:
.globl vector53
vector53:
  pushl $0
  102024:	6a 00                	push   $0x0
  pushl $53
  102026:	6a 35                	push   $0x35
  jmp __alltraps
  102028:	e9 9a 08 00 00       	jmp    1028c7 <__alltraps>

0010202d <vector54>:
.globl vector54
vector54:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $54
  10202f:	6a 36                	push   $0x36
  jmp __alltraps
  102031:	e9 91 08 00 00       	jmp    1028c7 <__alltraps>

00102036 <vector55>:
.globl vector55
vector55:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $55
  102038:	6a 37                	push   $0x37
  jmp __alltraps
  10203a:	e9 88 08 00 00       	jmp    1028c7 <__alltraps>

0010203f <vector56>:
.globl vector56
vector56:
  pushl $0
  10203f:	6a 00                	push   $0x0
  pushl $56
  102041:	6a 38                	push   $0x38
  jmp __alltraps
  102043:	e9 7f 08 00 00       	jmp    1028c7 <__alltraps>

00102048 <vector57>:
.globl vector57
vector57:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $57
  10204a:	6a 39                	push   $0x39
  jmp __alltraps
  10204c:	e9 76 08 00 00       	jmp    1028c7 <__alltraps>

00102051 <vector58>:
.globl vector58
vector58:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $58
  102053:	6a 3a                	push   $0x3a
  jmp __alltraps
  102055:	e9 6d 08 00 00       	jmp    1028c7 <__alltraps>

0010205a <vector59>:
.globl vector59
vector59:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $59
  10205c:	6a 3b                	push   $0x3b
  jmp __alltraps
  10205e:	e9 64 08 00 00       	jmp    1028c7 <__alltraps>

00102063 <vector60>:
.globl vector60
vector60:
  pushl $0
  102063:	6a 00                	push   $0x0
  pushl $60
  102065:	6a 3c                	push   $0x3c
  jmp __alltraps
  102067:	e9 5b 08 00 00       	jmp    1028c7 <__alltraps>

0010206c <vector61>:
.globl vector61
vector61:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $61
  10206e:	6a 3d                	push   $0x3d
  jmp __alltraps
  102070:	e9 52 08 00 00       	jmp    1028c7 <__alltraps>

00102075 <vector62>:
.globl vector62
vector62:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $62
  102077:	6a 3e                	push   $0x3e
  jmp __alltraps
  102079:	e9 49 08 00 00       	jmp    1028c7 <__alltraps>

0010207e <vector63>:
.globl vector63
vector63:
  pushl $0
  10207e:	6a 00                	push   $0x0
  pushl $63
  102080:	6a 3f                	push   $0x3f
  jmp __alltraps
  102082:	e9 40 08 00 00       	jmp    1028c7 <__alltraps>

00102087 <vector64>:
.globl vector64
vector64:
  pushl $0
  102087:	6a 00                	push   $0x0
  pushl $64
  102089:	6a 40                	push   $0x40
  jmp __alltraps
  10208b:	e9 37 08 00 00       	jmp    1028c7 <__alltraps>

00102090 <vector65>:
.globl vector65
vector65:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $65
  102092:	6a 41                	push   $0x41
  jmp __alltraps
  102094:	e9 2e 08 00 00       	jmp    1028c7 <__alltraps>

00102099 <vector66>:
.globl vector66
vector66:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $66
  10209b:	6a 42                	push   $0x42
  jmp __alltraps
  10209d:	e9 25 08 00 00       	jmp    1028c7 <__alltraps>

001020a2 <vector67>:
.globl vector67
vector67:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $67
  1020a4:	6a 43                	push   $0x43
  jmp __alltraps
  1020a6:	e9 1c 08 00 00       	jmp    1028c7 <__alltraps>

001020ab <vector68>:
.globl vector68
vector68:
  pushl $0
  1020ab:	6a 00                	push   $0x0
  pushl $68
  1020ad:	6a 44                	push   $0x44
  jmp __alltraps
  1020af:	e9 13 08 00 00       	jmp    1028c7 <__alltraps>

001020b4 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $69
  1020b6:	6a 45                	push   $0x45
  jmp __alltraps
  1020b8:	e9 0a 08 00 00       	jmp    1028c7 <__alltraps>

001020bd <vector70>:
.globl vector70
vector70:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $70
  1020bf:	6a 46                	push   $0x46
  jmp __alltraps
  1020c1:	e9 01 08 00 00       	jmp    1028c7 <__alltraps>

001020c6 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $71
  1020c8:	6a 47                	push   $0x47
  jmp __alltraps
  1020ca:	e9 f8 07 00 00       	jmp    1028c7 <__alltraps>

001020cf <vector72>:
.globl vector72
vector72:
  pushl $0
  1020cf:	6a 00                	push   $0x0
  pushl $72
  1020d1:	6a 48                	push   $0x48
  jmp __alltraps
  1020d3:	e9 ef 07 00 00       	jmp    1028c7 <__alltraps>

001020d8 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $73
  1020da:	6a 49                	push   $0x49
  jmp __alltraps
  1020dc:	e9 e6 07 00 00       	jmp    1028c7 <__alltraps>

001020e1 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $74
  1020e3:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020e5:	e9 dd 07 00 00       	jmp    1028c7 <__alltraps>

001020ea <vector75>:
.globl vector75
vector75:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $75
  1020ec:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020ee:	e9 d4 07 00 00       	jmp    1028c7 <__alltraps>

001020f3 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $76
  1020f5:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020f7:	e9 cb 07 00 00       	jmp    1028c7 <__alltraps>

001020fc <vector77>:
.globl vector77
vector77:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $77
  1020fe:	6a 4d                	push   $0x4d
  jmp __alltraps
  102100:	e9 c2 07 00 00       	jmp    1028c7 <__alltraps>

00102105 <vector78>:
.globl vector78
vector78:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $78
  102107:	6a 4e                	push   $0x4e
  jmp __alltraps
  102109:	e9 b9 07 00 00       	jmp    1028c7 <__alltraps>

0010210e <vector79>:
.globl vector79
vector79:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $79
  102110:	6a 4f                	push   $0x4f
  jmp __alltraps
  102112:	e9 b0 07 00 00       	jmp    1028c7 <__alltraps>

00102117 <vector80>:
.globl vector80
vector80:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $80
  102119:	6a 50                	push   $0x50
  jmp __alltraps
  10211b:	e9 a7 07 00 00       	jmp    1028c7 <__alltraps>

00102120 <vector81>:
.globl vector81
vector81:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $81
  102122:	6a 51                	push   $0x51
  jmp __alltraps
  102124:	e9 9e 07 00 00       	jmp    1028c7 <__alltraps>

00102129 <vector82>:
.globl vector82
vector82:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $82
  10212b:	6a 52                	push   $0x52
  jmp __alltraps
  10212d:	e9 95 07 00 00       	jmp    1028c7 <__alltraps>

00102132 <vector83>:
.globl vector83
vector83:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $83
  102134:	6a 53                	push   $0x53
  jmp __alltraps
  102136:	e9 8c 07 00 00       	jmp    1028c7 <__alltraps>

0010213b <vector84>:
.globl vector84
vector84:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $84
  10213d:	6a 54                	push   $0x54
  jmp __alltraps
  10213f:	e9 83 07 00 00       	jmp    1028c7 <__alltraps>

00102144 <vector85>:
.globl vector85
vector85:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $85
  102146:	6a 55                	push   $0x55
  jmp __alltraps
  102148:	e9 7a 07 00 00       	jmp    1028c7 <__alltraps>

0010214d <vector86>:
.globl vector86
vector86:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $86
  10214f:	6a 56                	push   $0x56
  jmp __alltraps
  102151:	e9 71 07 00 00       	jmp    1028c7 <__alltraps>

00102156 <vector87>:
.globl vector87
vector87:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $87
  102158:	6a 57                	push   $0x57
  jmp __alltraps
  10215a:	e9 68 07 00 00       	jmp    1028c7 <__alltraps>

0010215f <vector88>:
.globl vector88
vector88:
  pushl $0
  10215f:	6a 00                	push   $0x0
  pushl $88
  102161:	6a 58                	push   $0x58
  jmp __alltraps
  102163:	e9 5f 07 00 00       	jmp    1028c7 <__alltraps>

00102168 <vector89>:
.globl vector89
vector89:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $89
  10216a:	6a 59                	push   $0x59
  jmp __alltraps
  10216c:	e9 56 07 00 00       	jmp    1028c7 <__alltraps>

00102171 <vector90>:
.globl vector90
vector90:
  pushl $0
  102171:	6a 00                	push   $0x0
  pushl $90
  102173:	6a 5a                	push   $0x5a
  jmp __alltraps
  102175:	e9 4d 07 00 00       	jmp    1028c7 <__alltraps>

0010217a <vector91>:
.globl vector91
vector91:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $91
  10217c:	6a 5b                	push   $0x5b
  jmp __alltraps
  10217e:	e9 44 07 00 00       	jmp    1028c7 <__alltraps>

00102183 <vector92>:
.globl vector92
vector92:
  pushl $0
  102183:	6a 00                	push   $0x0
  pushl $92
  102185:	6a 5c                	push   $0x5c
  jmp __alltraps
  102187:	e9 3b 07 00 00       	jmp    1028c7 <__alltraps>

0010218c <vector93>:
.globl vector93
vector93:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $93
  10218e:	6a 5d                	push   $0x5d
  jmp __alltraps
  102190:	e9 32 07 00 00       	jmp    1028c7 <__alltraps>

00102195 <vector94>:
.globl vector94
vector94:
  pushl $0
  102195:	6a 00                	push   $0x0
  pushl $94
  102197:	6a 5e                	push   $0x5e
  jmp __alltraps
  102199:	e9 29 07 00 00       	jmp    1028c7 <__alltraps>

0010219e <vector95>:
.globl vector95
vector95:
  pushl $0
  10219e:	6a 00                	push   $0x0
  pushl $95
  1021a0:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021a2:	e9 20 07 00 00       	jmp    1028c7 <__alltraps>

001021a7 <vector96>:
.globl vector96
vector96:
  pushl $0
  1021a7:	6a 00                	push   $0x0
  pushl $96
  1021a9:	6a 60                	push   $0x60
  jmp __alltraps
  1021ab:	e9 17 07 00 00       	jmp    1028c7 <__alltraps>

001021b0 <vector97>:
.globl vector97
vector97:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $97
  1021b2:	6a 61                	push   $0x61
  jmp __alltraps
  1021b4:	e9 0e 07 00 00       	jmp    1028c7 <__alltraps>

001021b9 <vector98>:
.globl vector98
vector98:
  pushl $0
  1021b9:	6a 00                	push   $0x0
  pushl $98
  1021bb:	6a 62                	push   $0x62
  jmp __alltraps
  1021bd:	e9 05 07 00 00       	jmp    1028c7 <__alltraps>

001021c2 <vector99>:
.globl vector99
vector99:
  pushl $0
  1021c2:	6a 00                	push   $0x0
  pushl $99
  1021c4:	6a 63                	push   $0x63
  jmp __alltraps
  1021c6:	e9 fc 06 00 00       	jmp    1028c7 <__alltraps>

001021cb <vector100>:
.globl vector100
vector100:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $100
  1021cd:	6a 64                	push   $0x64
  jmp __alltraps
  1021cf:	e9 f3 06 00 00       	jmp    1028c7 <__alltraps>

001021d4 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $101
  1021d6:	6a 65                	push   $0x65
  jmp __alltraps
  1021d8:	e9 ea 06 00 00       	jmp    1028c7 <__alltraps>

001021dd <vector102>:
.globl vector102
vector102:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $102
  1021df:	6a 66                	push   $0x66
  jmp __alltraps
  1021e1:	e9 e1 06 00 00       	jmp    1028c7 <__alltraps>

001021e6 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $103
  1021e8:	6a 67                	push   $0x67
  jmp __alltraps
  1021ea:	e9 d8 06 00 00       	jmp    1028c7 <__alltraps>

001021ef <vector104>:
.globl vector104
vector104:
  pushl $0
  1021ef:	6a 00                	push   $0x0
  pushl $104
  1021f1:	6a 68                	push   $0x68
  jmp __alltraps
  1021f3:	e9 cf 06 00 00       	jmp    1028c7 <__alltraps>

001021f8 <vector105>:
.globl vector105
vector105:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $105
  1021fa:	6a 69                	push   $0x69
  jmp __alltraps
  1021fc:	e9 c6 06 00 00       	jmp    1028c7 <__alltraps>

00102201 <vector106>:
.globl vector106
vector106:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $106
  102203:	6a 6a                	push   $0x6a
  jmp __alltraps
  102205:	e9 bd 06 00 00       	jmp    1028c7 <__alltraps>

0010220a <vector107>:
.globl vector107
vector107:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $107
  10220c:	6a 6b                	push   $0x6b
  jmp __alltraps
  10220e:	e9 b4 06 00 00       	jmp    1028c7 <__alltraps>

00102213 <vector108>:
.globl vector108
vector108:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $108
  102215:	6a 6c                	push   $0x6c
  jmp __alltraps
  102217:	e9 ab 06 00 00       	jmp    1028c7 <__alltraps>

0010221c <vector109>:
.globl vector109
vector109:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $109
  10221e:	6a 6d                	push   $0x6d
  jmp __alltraps
  102220:	e9 a2 06 00 00       	jmp    1028c7 <__alltraps>

00102225 <vector110>:
.globl vector110
vector110:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $110
  102227:	6a 6e                	push   $0x6e
  jmp __alltraps
  102229:	e9 99 06 00 00       	jmp    1028c7 <__alltraps>

0010222e <vector111>:
.globl vector111
vector111:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $111
  102230:	6a 6f                	push   $0x6f
  jmp __alltraps
  102232:	e9 90 06 00 00       	jmp    1028c7 <__alltraps>

00102237 <vector112>:
.globl vector112
vector112:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $112
  102239:	6a 70                	push   $0x70
  jmp __alltraps
  10223b:	e9 87 06 00 00       	jmp    1028c7 <__alltraps>

00102240 <vector113>:
.globl vector113
vector113:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $113
  102242:	6a 71                	push   $0x71
  jmp __alltraps
  102244:	e9 7e 06 00 00       	jmp    1028c7 <__alltraps>

00102249 <vector114>:
.globl vector114
vector114:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $114
  10224b:	6a 72                	push   $0x72
  jmp __alltraps
  10224d:	e9 75 06 00 00       	jmp    1028c7 <__alltraps>

00102252 <vector115>:
.globl vector115
vector115:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $115
  102254:	6a 73                	push   $0x73
  jmp __alltraps
  102256:	e9 6c 06 00 00       	jmp    1028c7 <__alltraps>

0010225b <vector116>:
.globl vector116
vector116:
  pushl $0
  10225b:	6a 00                	push   $0x0
  pushl $116
  10225d:	6a 74                	push   $0x74
  jmp __alltraps
  10225f:	e9 63 06 00 00       	jmp    1028c7 <__alltraps>

00102264 <vector117>:
.globl vector117
vector117:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $117
  102266:	6a 75                	push   $0x75
  jmp __alltraps
  102268:	e9 5a 06 00 00       	jmp    1028c7 <__alltraps>

0010226d <vector118>:
.globl vector118
vector118:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $118
  10226f:	6a 76                	push   $0x76
  jmp __alltraps
  102271:	e9 51 06 00 00       	jmp    1028c7 <__alltraps>

00102276 <vector119>:
.globl vector119
vector119:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $119
  102278:	6a 77                	push   $0x77
  jmp __alltraps
  10227a:	e9 48 06 00 00       	jmp    1028c7 <__alltraps>

0010227f <vector120>:
.globl vector120
vector120:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $120
  102281:	6a 78                	push   $0x78
  jmp __alltraps
  102283:	e9 3f 06 00 00       	jmp    1028c7 <__alltraps>

00102288 <vector121>:
.globl vector121
vector121:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $121
  10228a:	6a 79                	push   $0x79
  jmp __alltraps
  10228c:	e9 36 06 00 00       	jmp    1028c7 <__alltraps>

00102291 <vector122>:
.globl vector122
vector122:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $122
  102293:	6a 7a                	push   $0x7a
  jmp __alltraps
  102295:	e9 2d 06 00 00       	jmp    1028c7 <__alltraps>

0010229a <vector123>:
.globl vector123
vector123:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $123
  10229c:	6a 7b                	push   $0x7b
  jmp __alltraps
  10229e:	e9 24 06 00 00       	jmp    1028c7 <__alltraps>

001022a3 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022a3:	6a 00                	push   $0x0
  pushl $124
  1022a5:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022a7:	e9 1b 06 00 00       	jmp    1028c7 <__alltraps>

001022ac <vector125>:
.globl vector125
vector125:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $125
  1022ae:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022b0:	e9 12 06 00 00       	jmp    1028c7 <__alltraps>

001022b5 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $126
  1022b7:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022b9:	e9 09 06 00 00       	jmp    1028c7 <__alltraps>

001022be <vector127>:
.globl vector127
vector127:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $127
  1022c0:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022c2:	e9 00 06 00 00       	jmp    1028c7 <__alltraps>

001022c7 <vector128>:
.globl vector128
vector128:
  pushl $0
  1022c7:	6a 00                	push   $0x0
  pushl $128
  1022c9:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022ce:	e9 f4 05 00 00       	jmp    1028c7 <__alltraps>

001022d3 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $129
  1022d5:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022da:	e9 e8 05 00 00       	jmp    1028c7 <__alltraps>

001022df <vector130>:
.globl vector130
vector130:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $130
  1022e1:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022e6:	e9 dc 05 00 00       	jmp    1028c7 <__alltraps>

001022eb <vector131>:
.globl vector131
vector131:
  pushl $0
  1022eb:	6a 00                	push   $0x0
  pushl $131
  1022ed:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022f2:	e9 d0 05 00 00       	jmp    1028c7 <__alltraps>

001022f7 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $132
  1022f9:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022fe:	e9 c4 05 00 00       	jmp    1028c7 <__alltraps>

00102303 <vector133>:
.globl vector133
vector133:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $133
  102305:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10230a:	e9 b8 05 00 00       	jmp    1028c7 <__alltraps>

0010230f <vector134>:
.globl vector134
vector134:
  pushl $0
  10230f:	6a 00                	push   $0x0
  pushl $134
  102311:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102316:	e9 ac 05 00 00       	jmp    1028c7 <__alltraps>

0010231b <vector135>:
.globl vector135
vector135:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $135
  10231d:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102322:	e9 a0 05 00 00       	jmp    1028c7 <__alltraps>

00102327 <vector136>:
.globl vector136
vector136:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $136
  102329:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10232e:	e9 94 05 00 00       	jmp    1028c7 <__alltraps>

00102333 <vector137>:
.globl vector137
vector137:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $137
  102335:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10233a:	e9 88 05 00 00       	jmp    1028c7 <__alltraps>

0010233f <vector138>:
.globl vector138
vector138:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $138
  102341:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102346:	e9 7c 05 00 00       	jmp    1028c7 <__alltraps>

0010234b <vector139>:
.globl vector139
vector139:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $139
  10234d:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102352:	e9 70 05 00 00       	jmp    1028c7 <__alltraps>

00102357 <vector140>:
.globl vector140
vector140:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $140
  102359:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10235e:	e9 64 05 00 00       	jmp    1028c7 <__alltraps>

00102363 <vector141>:
.globl vector141
vector141:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $141
  102365:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10236a:	e9 58 05 00 00       	jmp    1028c7 <__alltraps>

0010236f <vector142>:
.globl vector142
vector142:
  pushl $0
  10236f:	6a 00                	push   $0x0
  pushl $142
  102371:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102376:	e9 4c 05 00 00       	jmp    1028c7 <__alltraps>

0010237b <vector143>:
.globl vector143
vector143:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $143
  10237d:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102382:	e9 40 05 00 00       	jmp    1028c7 <__alltraps>

00102387 <vector144>:
.globl vector144
vector144:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $144
  102389:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10238e:	e9 34 05 00 00       	jmp    1028c7 <__alltraps>

00102393 <vector145>:
.globl vector145
vector145:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $145
  102395:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10239a:	e9 28 05 00 00       	jmp    1028c7 <__alltraps>

0010239f <vector146>:
.globl vector146
vector146:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $146
  1023a1:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023a6:	e9 1c 05 00 00       	jmp    1028c7 <__alltraps>

001023ab <vector147>:
.globl vector147
vector147:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $147
  1023ad:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023b2:	e9 10 05 00 00       	jmp    1028c7 <__alltraps>

001023b7 <vector148>:
.globl vector148
vector148:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $148
  1023b9:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023be:	e9 04 05 00 00       	jmp    1028c7 <__alltraps>

001023c3 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023c3:	6a 00                	push   $0x0
  pushl $149
  1023c5:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023ca:	e9 f8 04 00 00       	jmp    1028c7 <__alltraps>

001023cf <vector150>:
.globl vector150
vector150:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $150
  1023d1:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023d6:	e9 ec 04 00 00       	jmp    1028c7 <__alltraps>

001023db <vector151>:
.globl vector151
vector151:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $151
  1023dd:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023e2:	e9 e0 04 00 00       	jmp    1028c7 <__alltraps>

001023e7 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $152
  1023e9:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023ee:	e9 d4 04 00 00       	jmp    1028c7 <__alltraps>

001023f3 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $153
  1023f5:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023fa:	e9 c8 04 00 00       	jmp    1028c7 <__alltraps>

001023ff <vector154>:
.globl vector154
vector154:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $154
  102401:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102406:	e9 bc 04 00 00       	jmp    1028c7 <__alltraps>

0010240b <vector155>:
.globl vector155
vector155:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $155
  10240d:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102412:	e9 b0 04 00 00       	jmp    1028c7 <__alltraps>

00102417 <vector156>:
.globl vector156
vector156:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $156
  102419:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10241e:	e9 a4 04 00 00       	jmp    1028c7 <__alltraps>

00102423 <vector157>:
.globl vector157
vector157:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $157
  102425:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10242a:	e9 98 04 00 00       	jmp    1028c7 <__alltraps>

0010242f <vector158>:
.globl vector158
vector158:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $158
  102431:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102436:	e9 8c 04 00 00       	jmp    1028c7 <__alltraps>

0010243b <vector159>:
.globl vector159
vector159:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $159
  10243d:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102442:	e9 80 04 00 00       	jmp    1028c7 <__alltraps>

00102447 <vector160>:
.globl vector160
vector160:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $160
  102449:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10244e:	e9 74 04 00 00       	jmp    1028c7 <__alltraps>

00102453 <vector161>:
.globl vector161
vector161:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $161
  102455:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10245a:	e9 68 04 00 00       	jmp    1028c7 <__alltraps>

0010245f <vector162>:
.globl vector162
vector162:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $162
  102461:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102466:	e9 5c 04 00 00       	jmp    1028c7 <__alltraps>

0010246b <vector163>:
.globl vector163
vector163:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $163
  10246d:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102472:	e9 50 04 00 00       	jmp    1028c7 <__alltraps>

00102477 <vector164>:
.globl vector164
vector164:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $164
  102479:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10247e:	e9 44 04 00 00       	jmp    1028c7 <__alltraps>

00102483 <vector165>:
.globl vector165
vector165:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $165
  102485:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10248a:	e9 38 04 00 00       	jmp    1028c7 <__alltraps>

0010248f <vector166>:
.globl vector166
vector166:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $166
  102491:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102496:	e9 2c 04 00 00       	jmp    1028c7 <__alltraps>

0010249b <vector167>:
.globl vector167
vector167:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $167
  10249d:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024a2:	e9 20 04 00 00       	jmp    1028c7 <__alltraps>

001024a7 <vector168>:
.globl vector168
vector168:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $168
  1024a9:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024ae:	e9 14 04 00 00       	jmp    1028c7 <__alltraps>

001024b3 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $169
  1024b5:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024ba:	e9 08 04 00 00       	jmp    1028c7 <__alltraps>

001024bf <vector170>:
.globl vector170
vector170:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $170
  1024c1:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024c6:	e9 fc 03 00 00       	jmp    1028c7 <__alltraps>

001024cb <vector171>:
.globl vector171
vector171:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $171
  1024cd:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024d2:	e9 f0 03 00 00       	jmp    1028c7 <__alltraps>

001024d7 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $172
  1024d9:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024de:	e9 e4 03 00 00       	jmp    1028c7 <__alltraps>

001024e3 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $173
  1024e5:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024ea:	e9 d8 03 00 00       	jmp    1028c7 <__alltraps>

001024ef <vector174>:
.globl vector174
vector174:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $174
  1024f1:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024f6:	e9 cc 03 00 00       	jmp    1028c7 <__alltraps>

001024fb <vector175>:
.globl vector175
vector175:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $175
  1024fd:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102502:	e9 c0 03 00 00       	jmp    1028c7 <__alltraps>

00102507 <vector176>:
.globl vector176
vector176:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $176
  102509:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10250e:	e9 b4 03 00 00       	jmp    1028c7 <__alltraps>

00102513 <vector177>:
.globl vector177
vector177:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $177
  102515:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10251a:	e9 a8 03 00 00       	jmp    1028c7 <__alltraps>

0010251f <vector178>:
.globl vector178
vector178:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $178
  102521:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102526:	e9 9c 03 00 00       	jmp    1028c7 <__alltraps>

0010252b <vector179>:
.globl vector179
vector179:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $179
  10252d:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102532:	e9 90 03 00 00       	jmp    1028c7 <__alltraps>

00102537 <vector180>:
.globl vector180
vector180:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $180
  102539:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10253e:	e9 84 03 00 00       	jmp    1028c7 <__alltraps>

00102543 <vector181>:
.globl vector181
vector181:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $181
  102545:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10254a:	e9 78 03 00 00       	jmp    1028c7 <__alltraps>

0010254f <vector182>:
.globl vector182
vector182:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $182
  102551:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102556:	e9 6c 03 00 00       	jmp    1028c7 <__alltraps>

0010255b <vector183>:
.globl vector183
vector183:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $183
  10255d:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102562:	e9 60 03 00 00       	jmp    1028c7 <__alltraps>

00102567 <vector184>:
.globl vector184
vector184:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $184
  102569:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10256e:	e9 54 03 00 00       	jmp    1028c7 <__alltraps>

00102573 <vector185>:
.globl vector185
vector185:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $185
  102575:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10257a:	e9 48 03 00 00       	jmp    1028c7 <__alltraps>

0010257f <vector186>:
.globl vector186
vector186:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $186
  102581:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102586:	e9 3c 03 00 00       	jmp    1028c7 <__alltraps>

0010258b <vector187>:
.globl vector187
vector187:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $187
  10258d:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102592:	e9 30 03 00 00       	jmp    1028c7 <__alltraps>

00102597 <vector188>:
.globl vector188
vector188:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $188
  102599:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10259e:	e9 24 03 00 00       	jmp    1028c7 <__alltraps>

001025a3 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $189
  1025a5:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025aa:	e9 18 03 00 00       	jmp    1028c7 <__alltraps>

001025af <vector190>:
.globl vector190
vector190:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $190
  1025b1:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025b6:	e9 0c 03 00 00       	jmp    1028c7 <__alltraps>

001025bb <vector191>:
.globl vector191
vector191:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $191
  1025bd:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025c2:	e9 00 03 00 00       	jmp    1028c7 <__alltraps>

001025c7 <vector192>:
.globl vector192
vector192:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $192
  1025c9:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025ce:	e9 f4 02 00 00       	jmp    1028c7 <__alltraps>

001025d3 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $193
  1025d5:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025da:	e9 e8 02 00 00       	jmp    1028c7 <__alltraps>

001025df <vector194>:
.globl vector194
vector194:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $194
  1025e1:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025e6:	e9 dc 02 00 00       	jmp    1028c7 <__alltraps>

001025eb <vector195>:
.globl vector195
vector195:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $195
  1025ed:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025f2:	e9 d0 02 00 00       	jmp    1028c7 <__alltraps>

001025f7 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $196
  1025f9:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025fe:	e9 c4 02 00 00       	jmp    1028c7 <__alltraps>

00102603 <vector197>:
.globl vector197
vector197:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $197
  102605:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10260a:	e9 b8 02 00 00       	jmp    1028c7 <__alltraps>

0010260f <vector198>:
.globl vector198
vector198:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $198
  102611:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102616:	e9 ac 02 00 00       	jmp    1028c7 <__alltraps>

0010261b <vector199>:
.globl vector199
vector199:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $199
  10261d:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102622:	e9 a0 02 00 00       	jmp    1028c7 <__alltraps>

00102627 <vector200>:
.globl vector200
vector200:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $200
  102629:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10262e:	e9 94 02 00 00       	jmp    1028c7 <__alltraps>

00102633 <vector201>:
.globl vector201
vector201:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $201
  102635:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10263a:	e9 88 02 00 00       	jmp    1028c7 <__alltraps>

0010263f <vector202>:
.globl vector202
vector202:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $202
  102641:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102646:	e9 7c 02 00 00       	jmp    1028c7 <__alltraps>

0010264b <vector203>:
.globl vector203
vector203:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $203
  10264d:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102652:	e9 70 02 00 00       	jmp    1028c7 <__alltraps>

00102657 <vector204>:
.globl vector204
vector204:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $204
  102659:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10265e:	e9 64 02 00 00       	jmp    1028c7 <__alltraps>

00102663 <vector205>:
.globl vector205
vector205:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $205
  102665:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10266a:	e9 58 02 00 00       	jmp    1028c7 <__alltraps>

0010266f <vector206>:
.globl vector206
vector206:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $206
  102671:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102676:	e9 4c 02 00 00       	jmp    1028c7 <__alltraps>

0010267b <vector207>:
.globl vector207
vector207:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $207
  10267d:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102682:	e9 40 02 00 00       	jmp    1028c7 <__alltraps>

00102687 <vector208>:
.globl vector208
vector208:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $208
  102689:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10268e:	e9 34 02 00 00       	jmp    1028c7 <__alltraps>

00102693 <vector209>:
.globl vector209
vector209:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $209
  102695:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10269a:	e9 28 02 00 00       	jmp    1028c7 <__alltraps>

0010269f <vector210>:
.globl vector210
vector210:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $210
  1026a1:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026a6:	e9 1c 02 00 00       	jmp    1028c7 <__alltraps>

001026ab <vector211>:
.globl vector211
vector211:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $211
  1026ad:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026b2:	e9 10 02 00 00       	jmp    1028c7 <__alltraps>

001026b7 <vector212>:
.globl vector212
vector212:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $212
  1026b9:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026be:	e9 04 02 00 00       	jmp    1028c7 <__alltraps>

001026c3 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $213
  1026c5:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026ca:	e9 f8 01 00 00       	jmp    1028c7 <__alltraps>

001026cf <vector214>:
.globl vector214
vector214:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $214
  1026d1:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026d6:	e9 ec 01 00 00       	jmp    1028c7 <__alltraps>

001026db <vector215>:
.globl vector215
vector215:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $215
  1026dd:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026e2:	e9 e0 01 00 00       	jmp    1028c7 <__alltraps>

001026e7 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $216
  1026e9:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026ee:	e9 d4 01 00 00       	jmp    1028c7 <__alltraps>

001026f3 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $217
  1026f5:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026fa:	e9 c8 01 00 00       	jmp    1028c7 <__alltraps>

001026ff <vector218>:
.globl vector218
vector218:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $218
  102701:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102706:	e9 bc 01 00 00       	jmp    1028c7 <__alltraps>

0010270b <vector219>:
.globl vector219
vector219:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $219
  10270d:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102712:	e9 b0 01 00 00       	jmp    1028c7 <__alltraps>

00102717 <vector220>:
.globl vector220
vector220:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $220
  102719:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10271e:	e9 a4 01 00 00       	jmp    1028c7 <__alltraps>

00102723 <vector221>:
.globl vector221
vector221:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $221
  102725:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10272a:	e9 98 01 00 00       	jmp    1028c7 <__alltraps>

0010272f <vector222>:
.globl vector222
vector222:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $222
  102731:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102736:	e9 8c 01 00 00       	jmp    1028c7 <__alltraps>

0010273b <vector223>:
.globl vector223
vector223:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $223
  10273d:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102742:	e9 80 01 00 00       	jmp    1028c7 <__alltraps>

00102747 <vector224>:
.globl vector224
vector224:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $224
  102749:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10274e:	e9 74 01 00 00       	jmp    1028c7 <__alltraps>

00102753 <vector225>:
.globl vector225
vector225:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $225
  102755:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10275a:	e9 68 01 00 00       	jmp    1028c7 <__alltraps>

0010275f <vector226>:
.globl vector226
vector226:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $226
  102761:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102766:	e9 5c 01 00 00       	jmp    1028c7 <__alltraps>

0010276b <vector227>:
.globl vector227
vector227:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $227
  10276d:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102772:	e9 50 01 00 00       	jmp    1028c7 <__alltraps>

00102777 <vector228>:
.globl vector228
vector228:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $228
  102779:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10277e:	e9 44 01 00 00       	jmp    1028c7 <__alltraps>

00102783 <vector229>:
.globl vector229
vector229:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $229
  102785:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10278a:	e9 38 01 00 00       	jmp    1028c7 <__alltraps>

0010278f <vector230>:
.globl vector230
vector230:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $230
  102791:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102796:	e9 2c 01 00 00       	jmp    1028c7 <__alltraps>

0010279b <vector231>:
.globl vector231
vector231:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $231
  10279d:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027a2:	e9 20 01 00 00       	jmp    1028c7 <__alltraps>

001027a7 <vector232>:
.globl vector232
vector232:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $232
  1027a9:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027ae:	e9 14 01 00 00       	jmp    1028c7 <__alltraps>

001027b3 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $233
  1027b5:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027ba:	e9 08 01 00 00       	jmp    1028c7 <__alltraps>

001027bf <vector234>:
.globl vector234
vector234:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $234
  1027c1:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027c6:	e9 fc 00 00 00       	jmp    1028c7 <__alltraps>

001027cb <vector235>:
.globl vector235
vector235:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $235
  1027cd:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027d2:	e9 f0 00 00 00       	jmp    1028c7 <__alltraps>

001027d7 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $236
  1027d9:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027de:	e9 e4 00 00 00       	jmp    1028c7 <__alltraps>

001027e3 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $237
  1027e5:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027ea:	e9 d8 00 00 00       	jmp    1028c7 <__alltraps>

001027ef <vector238>:
.globl vector238
vector238:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $238
  1027f1:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027f6:	e9 cc 00 00 00       	jmp    1028c7 <__alltraps>

001027fb <vector239>:
.globl vector239
vector239:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $239
  1027fd:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102802:	e9 c0 00 00 00       	jmp    1028c7 <__alltraps>

00102807 <vector240>:
.globl vector240
vector240:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $240
  102809:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10280e:	e9 b4 00 00 00       	jmp    1028c7 <__alltraps>

00102813 <vector241>:
.globl vector241
vector241:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $241
  102815:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10281a:	e9 a8 00 00 00       	jmp    1028c7 <__alltraps>

0010281f <vector242>:
.globl vector242
vector242:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $242
  102821:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102826:	e9 9c 00 00 00       	jmp    1028c7 <__alltraps>

0010282b <vector243>:
.globl vector243
vector243:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $243
  10282d:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102832:	e9 90 00 00 00       	jmp    1028c7 <__alltraps>

00102837 <vector244>:
.globl vector244
vector244:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $244
  102839:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10283e:	e9 84 00 00 00       	jmp    1028c7 <__alltraps>

00102843 <vector245>:
.globl vector245
vector245:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $245
  102845:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10284a:	e9 78 00 00 00       	jmp    1028c7 <__alltraps>

0010284f <vector246>:
.globl vector246
vector246:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $246
  102851:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102856:	e9 6c 00 00 00       	jmp    1028c7 <__alltraps>

0010285b <vector247>:
.globl vector247
vector247:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $247
  10285d:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102862:	e9 60 00 00 00       	jmp    1028c7 <__alltraps>

00102867 <vector248>:
.globl vector248
vector248:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $248
  102869:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10286e:	e9 54 00 00 00       	jmp    1028c7 <__alltraps>

00102873 <vector249>:
.globl vector249
vector249:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $249
  102875:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10287a:	e9 48 00 00 00       	jmp    1028c7 <__alltraps>

0010287f <vector250>:
.globl vector250
vector250:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $250
  102881:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102886:	e9 3c 00 00 00       	jmp    1028c7 <__alltraps>

0010288b <vector251>:
.globl vector251
vector251:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $251
  10288d:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102892:	e9 30 00 00 00       	jmp    1028c7 <__alltraps>

00102897 <vector252>:
.globl vector252
vector252:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $252
  102899:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10289e:	e9 24 00 00 00       	jmp    1028c7 <__alltraps>

001028a3 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028a3:	6a 00                	push   $0x0
  pushl $253
  1028a5:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028aa:	e9 18 00 00 00       	jmp    1028c7 <__alltraps>

001028af <vector254>:
.globl vector254
vector254:
  pushl $0
  1028af:	6a 00                	push   $0x0
  pushl $254
  1028b1:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028b6:	e9 0c 00 00 00       	jmp    1028c7 <__alltraps>

001028bb <vector255>:
.globl vector255
vector255:
  pushl $0
  1028bb:	6a 00                	push   $0x0
  pushl $255
  1028bd:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028c2:	e9 00 00 00 00       	jmp    1028c7 <__alltraps>

001028c7 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1028c7:	1e                   	push   %ds
    pushl %es
  1028c8:	06                   	push   %es
    pushl %fs
  1028c9:	0f a0                	push   %fs
    pushl %gs
  1028cb:	0f a8                	push   %gs
    pushal
  1028cd:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1028ce:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1028d3:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1028d5:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1028d7:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1028d8:	e8 63 f5 ff ff       	call   101e40 <trap>

    # pop the pushed stack pointer
    popl %esp
  1028dd:	5c                   	pop    %esp

001028de <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1028de:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1028df:	0f a9                	pop    %gs
    popl %fs
  1028e1:	0f a1                	pop    %fs
    popl %es
  1028e3:	07                   	pop    %es
    popl %ds
  1028e4:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1028e5:	83 c4 08             	add    $0x8,%esp
    iret
  1028e8:	cf                   	iret   

001028e9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028e9:	55                   	push   %ebp
  1028ea:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ef:	8b 15 78 99 11 00    	mov    0x119978,%edx
  1028f5:	29 d0                	sub    %edx,%eax
  1028f7:	c1 f8 02             	sar    $0x2,%eax
  1028fa:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102900:	5d                   	pop    %ebp
  102901:	c3                   	ret    

00102902 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102902:	55                   	push   %ebp
  102903:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  102905:	ff 75 08             	pushl  0x8(%ebp)
  102908:	e8 dc ff ff ff       	call   1028e9 <page2ppn>
  10290d:	83 c4 04             	add    $0x4,%esp
  102910:	c1 e0 0c             	shl    $0xc,%eax
}
  102913:	c9                   	leave  
  102914:	c3                   	ret    

00102915 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102915:	55                   	push   %ebp
  102916:	89 e5                	mov    %esp,%ebp
  102918:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
  10291b:	8b 45 08             	mov    0x8(%ebp),%eax
  10291e:	c1 e8 0c             	shr    $0xc,%eax
  102921:	89 c2                	mov    %eax,%edx
  102923:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  102928:	39 c2                	cmp    %eax,%edx
  10292a:	72 14                	jb     102940 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
  10292c:	83 ec 04             	sub    $0x4,%esp
  10292f:	68 90 69 10 00       	push   $0x106990
  102934:	6a 5a                	push   $0x5a
  102936:	68 af 69 10 00       	push   $0x1069af
  10293b:	e8 91 da ff ff       	call   1003d1 <__panic>
    }
    return &pages[PPN(pa)];
  102940:	8b 0d 78 99 11 00    	mov    0x119978,%ecx
  102946:	8b 45 08             	mov    0x8(%ebp),%eax
  102949:	c1 e8 0c             	shr    $0xc,%eax
  10294c:	89 c2                	mov    %eax,%edx
  10294e:	89 d0                	mov    %edx,%eax
  102950:	c1 e0 02             	shl    $0x2,%eax
  102953:	01 d0                	add    %edx,%eax
  102955:	c1 e0 02             	shl    $0x2,%eax
  102958:	01 c8                	add    %ecx,%eax
}
  10295a:	c9                   	leave  
  10295b:	c3                   	ret    

0010295c <page2kva>:

static inline void *
page2kva(struct Page *page) {
  10295c:	55                   	push   %ebp
  10295d:	89 e5                	mov    %esp,%ebp
  10295f:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
  102962:	ff 75 08             	pushl  0x8(%ebp)
  102965:	e8 98 ff ff ff       	call   102902 <page2pa>
  10296a:	83 c4 04             	add    $0x4,%esp
  10296d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102973:	c1 e8 0c             	shr    $0xc,%eax
  102976:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102979:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  10297e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102981:	72 14                	jb     102997 <page2kva+0x3b>
  102983:	ff 75 f4             	pushl  -0xc(%ebp)
  102986:	68 c0 69 10 00       	push   $0x1069c0
  10298b:	6a 61                	push   $0x61
  10298d:	68 af 69 10 00       	push   $0x1069af
  102992:	e8 3a da ff ff       	call   1003d1 <__panic>
  102997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10299a:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  10299f:	c9                   	leave  
  1029a0:	c3                   	ret    

001029a1 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  1029a1:	55                   	push   %ebp
  1029a2:	89 e5                	mov    %esp,%ebp
  1029a4:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
  1029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029aa:	83 e0 01             	and    $0x1,%eax
  1029ad:	85 c0                	test   %eax,%eax
  1029af:	75 14                	jne    1029c5 <pte2page+0x24>
        panic("pte2page called with invalid pte");
  1029b1:	83 ec 04             	sub    $0x4,%esp
  1029b4:	68 e4 69 10 00       	push   $0x1069e4
  1029b9:	6a 6c                	push   $0x6c
  1029bb:	68 af 69 10 00       	push   $0x1069af
  1029c0:	e8 0c da ff ff       	call   1003d1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  1029c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1029cd:	83 ec 0c             	sub    $0xc,%esp
  1029d0:	50                   	push   %eax
  1029d1:	e8 3f ff ff ff       	call   102915 <pa2page>
  1029d6:	83 c4 10             	add    $0x10,%esp
}
  1029d9:	c9                   	leave  
  1029da:	c3                   	ret    

001029db <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1029db:	55                   	push   %ebp
  1029dc:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1029de:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e1:	8b 00                	mov    (%eax),%eax
}
  1029e3:	5d                   	pop    %ebp
  1029e4:	c3                   	ret    

001029e5 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  1029e5:	55                   	push   %ebp
  1029e6:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  1029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1029eb:	8b 00                	mov    (%eax),%eax
  1029ed:	8d 50 01             	lea    0x1(%eax),%edx
  1029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f3:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f8:	8b 00                	mov    (%eax),%eax
}
  1029fa:	5d                   	pop    %ebp
  1029fb:	c3                   	ret    

001029fc <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  1029fc:	55                   	push   %ebp
  1029fd:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  1029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  102a02:	8b 00                	mov    (%eax),%eax
  102a04:	8d 50 ff             	lea    -0x1(%eax),%edx
  102a07:	8b 45 08             	mov    0x8(%ebp),%eax
  102a0a:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a0f:	8b 00                	mov    (%eax),%eax
}
  102a11:	5d                   	pop    %ebp
  102a12:	c3                   	ret    

00102a13 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  102a13:	55                   	push   %ebp
  102a14:	89 e5                	mov    %esp,%ebp
  102a16:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102a19:	9c                   	pushf  
  102a1a:	58                   	pop    %eax
  102a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102a21:	25 00 02 00 00       	and    $0x200,%eax
  102a26:	85 c0                	test   %eax,%eax
  102a28:	74 0c                	je     102a36 <__intr_save+0x23>
        intr_disable();
  102a2a:	e8 47 ee ff ff       	call   101876 <intr_disable>
        return 1;
  102a2f:	b8 01 00 00 00       	mov    $0x1,%eax
  102a34:	eb 05                	jmp    102a3b <__intr_save+0x28>
    }
    return 0;
  102a36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102a3b:	c9                   	leave  
  102a3c:	c3                   	ret    

00102a3d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  102a3d:	55                   	push   %ebp
  102a3e:	89 e5                	mov    %esp,%ebp
  102a40:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102a43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a47:	74 05                	je     102a4e <__intr_restore+0x11>
        intr_enable();
  102a49:	e8 21 ee ff ff       	call   10186f <intr_enable>
    }
}
  102a4e:	90                   	nop
  102a4f:	c9                   	leave  
  102a50:	c3                   	ret    

00102a51 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102a51:	55                   	push   %ebp
  102a52:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102a54:	8b 45 08             	mov    0x8(%ebp),%eax
  102a57:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102a5a:	b8 23 00 00 00       	mov    $0x23,%eax
  102a5f:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102a61:	b8 23 00 00 00       	mov    $0x23,%eax
  102a66:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102a68:	b8 10 00 00 00       	mov    $0x10,%eax
  102a6d:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102a6f:	b8 10 00 00 00       	mov    $0x10,%eax
  102a74:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102a76:	b8 10 00 00 00       	mov    $0x10,%eax
  102a7b:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a7d:	ea 84 2a 10 00 08 00 	ljmp   $0x8,$0x102a84
}
  102a84:	90                   	nop
  102a85:	5d                   	pop    %ebp
  102a86:	c3                   	ret    

00102a87 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102a87:	55                   	push   %ebp
  102a88:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8d:	a3 04 99 11 00       	mov    %eax,0x119904
}
  102a92:	90                   	nop
  102a93:	5d                   	pop    %ebp
  102a94:	c3                   	ret    

00102a95 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a95:	55                   	push   %ebp
  102a96:	89 e5                	mov    %esp,%ebp
  102a98:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102a9b:	b8 00 80 11 00       	mov    $0x118000,%eax
  102aa0:	50                   	push   %eax
  102aa1:	e8 e1 ff ff ff       	call   102a87 <load_esp0>
  102aa6:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
  102aa9:	66 c7 05 08 99 11 00 	movw   $0x10,0x119908
  102ab0:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102ab2:	66 c7 05 48 8a 11 00 	movw   $0x68,0x118a48
  102ab9:	68 00 
  102abb:	b8 00 99 11 00       	mov    $0x119900,%eax
  102ac0:	66 a3 4a 8a 11 00    	mov    %ax,0x118a4a
  102ac6:	b8 00 99 11 00       	mov    $0x119900,%eax
  102acb:	c1 e8 10             	shr    $0x10,%eax
  102ace:	a2 4c 8a 11 00       	mov    %al,0x118a4c
  102ad3:	0f b6 05 4d 8a 11 00 	movzbl 0x118a4d,%eax
  102ada:	83 e0 f0             	and    $0xfffffff0,%eax
  102add:	83 c8 09             	or     $0x9,%eax
  102ae0:	a2 4d 8a 11 00       	mov    %al,0x118a4d
  102ae5:	0f b6 05 4d 8a 11 00 	movzbl 0x118a4d,%eax
  102aec:	83 e0 ef             	and    $0xffffffef,%eax
  102aef:	a2 4d 8a 11 00       	mov    %al,0x118a4d
  102af4:	0f b6 05 4d 8a 11 00 	movzbl 0x118a4d,%eax
  102afb:	83 e0 9f             	and    $0xffffff9f,%eax
  102afe:	a2 4d 8a 11 00       	mov    %al,0x118a4d
  102b03:	0f b6 05 4d 8a 11 00 	movzbl 0x118a4d,%eax
  102b0a:	83 c8 80             	or     $0xffffff80,%eax
  102b0d:	a2 4d 8a 11 00       	mov    %al,0x118a4d
  102b12:	0f b6 05 4e 8a 11 00 	movzbl 0x118a4e,%eax
  102b19:	83 e0 f0             	and    $0xfffffff0,%eax
  102b1c:	a2 4e 8a 11 00       	mov    %al,0x118a4e
  102b21:	0f b6 05 4e 8a 11 00 	movzbl 0x118a4e,%eax
  102b28:	83 e0 ef             	and    $0xffffffef,%eax
  102b2b:	a2 4e 8a 11 00       	mov    %al,0x118a4e
  102b30:	0f b6 05 4e 8a 11 00 	movzbl 0x118a4e,%eax
  102b37:	83 e0 df             	and    $0xffffffdf,%eax
  102b3a:	a2 4e 8a 11 00       	mov    %al,0x118a4e
  102b3f:	0f b6 05 4e 8a 11 00 	movzbl 0x118a4e,%eax
  102b46:	83 c8 40             	or     $0x40,%eax
  102b49:	a2 4e 8a 11 00       	mov    %al,0x118a4e
  102b4e:	0f b6 05 4e 8a 11 00 	movzbl 0x118a4e,%eax
  102b55:	83 e0 7f             	and    $0x7f,%eax
  102b58:	a2 4e 8a 11 00       	mov    %al,0x118a4e
  102b5d:	b8 00 99 11 00       	mov    $0x119900,%eax
  102b62:	c1 e8 18             	shr    $0x18,%eax
  102b65:	a2 4f 8a 11 00       	mov    %al,0x118a4f

    // reload all segment registers
    lgdt(&gdt_pd);
  102b6a:	68 50 8a 11 00       	push   $0x118a50
  102b6f:	e8 dd fe ff ff       	call   102a51 <lgdt>
  102b74:	83 c4 04             	add    $0x4,%esp
  102b77:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102b7d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102b81:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102b84:	90                   	nop
  102b85:	c9                   	leave  
  102b86:	c3                   	ret    

00102b87 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102b87:	55                   	push   %ebp
  102b88:	89 e5                	mov    %esp,%ebp
  102b8a:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
  102b8d:	c7 05 70 99 11 00 98 	movl   $0x107398,0x119970
  102b94:	73 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102b97:	a1 70 99 11 00       	mov    0x119970,%eax
  102b9c:	8b 00                	mov    (%eax),%eax
  102b9e:	83 ec 08             	sub    $0x8,%esp
  102ba1:	50                   	push   %eax
  102ba2:	68 10 6a 10 00       	push   $0x106a10
  102ba7:	e8 bf d6 ff ff       	call   10026b <cprintf>
  102bac:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
  102baf:	a1 70 99 11 00       	mov    0x119970,%eax
  102bb4:	8b 40 04             	mov    0x4(%eax),%eax
  102bb7:	ff d0                	call   *%eax
}
  102bb9:	90                   	nop
  102bba:	c9                   	leave  
  102bbb:	c3                   	ret    

00102bbc <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102bbc:	55                   	push   %ebp
  102bbd:	89 e5                	mov    %esp,%ebp
  102bbf:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
  102bc2:	a1 70 99 11 00       	mov    0x119970,%eax
  102bc7:	8b 40 08             	mov    0x8(%eax),%eax
  102bca:	83 ec 08             	sub    $0x8,%esp
  102bcd:	ff 75 0c             	pushl  0xc(%ebp)
  102bd0:	ff 75 08             	pushl  0x8(%ebp)
  102bd3:	ff d0                	call   *%eax
  102bd5:	83 c4 10             	add    $0x10,%esp
}
  102bd8:	90                   	nop
  102bd9:	c9                   	leave  
  102bda:	c3                   	ret    

00102bdb <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102bdb:	55                   	push   %ebp
  102bdc:	89 e5                	mov    %esp,%ebp
  102bde:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
  102be1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102be8:	e8 26 fe ff ff       	call   102a13 <__intr_save>
  102bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102bf0:	a1 70 99 11 00       	mov    0x119970,%eax
  102bf5:	8b 40 0c             	mov    0xc(%eax),%eax
  102bf8:	83 ec 0c             	sub    $0xc,%esp
  102bfb:	ff 75 08             	pushl  0x8(%ebp)
  102bfe:	ff d0                	call   *%eax
  102c00:	83 c4 10             	add    $0x10,%esp
  102c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102c06:	83 ec 0c             	sub    $0xc,%esp
  102c09:	ff 75 f0             	pushl  -0x10(%ebp)
  102c0c:	e8 2c fe ff ff       	call   102a3d <__intr_restore>
  102c11:	83 c4 10             	add    $0x10,%esp
    return page;
  102c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102c17:	c9                   	leave  
  102c18:	c3                   	ret    

00102c19 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102c19:	55                   	push   %ebp
  102c1a:	89 e5                	mov    %esp,%ebp
  102c1c:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102c1f:	e8 ef fd ff ff       	call   102a13 <__intr_save>
  102c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102c27:	a1 70 99 11 00       	mov    0x119970,%eax
  102c2c:	8b 40 10             	mov    0x10(%eax),%eax
  102c2f:	83 ec 08             	sub    $0x8,%esp
  102c32:	ff 75 0c             	pushl  0xc(%ebp)
  102c35:	ff 75 08             	pushl  0x8(%ebp)
  102c38:	ff d0                	call   *%eax
  102c3a:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  102c3d:	83 ec 0c             	sub    $0xc,%esp
  102c40:	ff 75 f4             	pushl  -0xc(%ebp)
  102c43:	e8 f5 fd ff ff       	call   102a3d <__intr_restore>
  102c48:	83 c4 10             	add    $0x10,%esp
}
  102c4b:	90                   	nop
  102c4c:	c9                   	leave  
  102c4d:	c3                   	ret    

00102c4e <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102c4e:	55                   	push   %ebp
  102c4f:	89 e5                	mov    %esp,%ebp
  102c51:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102c54:	e8 ba fd ff ff       	call   102a13 <__intr_save>
  102c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102c5c:	a1 70 99 11 00       	mov    0x119970,%eax
  102c61:	8b 40 14             	mov    0x14(%eax),%eax
  102c64:	ff d0                	call   *%eax
  102c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102c69:	83 ec 0c             	sub    $0xc,%esp
  102c6c:	ff 75 f4             	pushl  -0xc(%ebp)
  102c6f:	e8 c9 fd ff ff       	call   102a3d <__intr_restore>
  102c74:	83 c4 10             	add    $0x10,%esp
    return ret;
  102c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102c7a:	c9                   	leave  
  102c7b:	c3                   	ret    

00102c7c <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102c7c:	55                   	push   %ebp
  102c7d:	89 e5                	mov    %esp,%ebp
  102c7f:	57                   	push   %edi
  102c80:	56                   	push   %esi
  102c81:	53                   	push   %ebx
  102c82:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102c85:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102c8c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102c93:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102c9a:	83 ec 0c             	sub    $0xc,%esp
  102c9d:	68 27 6a 10 00       	push   $0x106a27
  102ca2:	e8 c4 d5 ff ff       	call   10026b <cprintf>
  102ca7:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102caa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102cb1:	e9 fc 00 00 00       	jmp    102db2 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102cb6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102cb9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102cbc:	89 d0                	mov    %edx,%eax
  102cbe:	c1 e0 02             	shl    $0x2,%eax
  102cc1:	01 d0                	add    %edx,%eax
  102cc3:	c1 e0 02             	shl    $0x2,%eax
  102cc6:	01 c8                	add    %ecx,%eax
  102cc8:	8b 50 08             	mov    0x8(%eax),%edx
  102ccb:	8b 40 04             	mov    0x4(%eax),%eax
  102cce:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102cd1:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102cd4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102cd7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102cda:	89 d0                	mov    %edx,%eax
  102cdc:	c1 e0 02             	shl    $0x2,%eax
  102cdf:	01 d0                	add    %edx,%eax
  102ce1:	c1 e0 02             	shl    $0x2,%eax
  102ce4:	01 c8                	add    %ecx,%eax
  102ce6:	8b 48 0c             	mov    0xc(%eax),%ecx
  102ce9:	8b 58 10             	mov    0x10(%eax),%ebx
  102cec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102cef:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102cf2:	01 c8                	add    %ecx,%eax
  102cf4:	11 da                	adc    %ebx,%edx
  102cf6:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102cf9:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102cfc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102cff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d02:	89 d0                	mov    %edx,%eax
  102d04:	c1 e0 02             	shl    $0x2,%eax
  102d07:	01 d0                	add    %edx,%eax
  102d09:	c1 e0 02             	shl    $0x2,%eax
  102d0c:	01 c8                	add    %ecx,%eax
  102d0e:	83 c0 14             	add    $0x14,%eax
  102d11:	8b 00                	mov    (%eax),%eax
  102d13:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102d16:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102d19:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d1c:	83 c0 ff             	add    $0xffffffff,%eax
  102d1f:	83 d2 ff             	adc    $0xffffffff,%edx
  102d22:	89 c1                	mov    %eax,%ecx
  102d24:	89 d3                	mov    %edx,%ebx
  102d26:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d29:	89 55 80             	mov    %edx,-0x80(%ebp)
  102d2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d2f:	89 d0                	mov    %edx,%eax
  102d31:	c1 e0 02             	shl    $0x2,%eax
  102d34:	01 d0                	add    %edx,%eax
  102d36:	c1 e0 02             	shl    $0x2,%eax
  102d39:	03 45 80             	add    -0x80(%ebp),%eax
  102d3c:	8b 50 10             	mov    0x10(%eax),%edx
  102d3f:	8b 40 0c             	mov    0xc(%eax),%eax
  102d42:	ff 75 84             	pushl  -0x7c(%ebp)
  102d45:	53                   	push   %ebx
  102d46:	51                   	push   %ecx
  102d47:	ff 75 bc             	pushl  -0x44(%ebp)
  102d4a:	ff 75 b8             	pushl  -0x48(%ebp)
  102d4d:	52                   	push   %edx
  102d4e:	50                   	push   %eax
  102d4f:	68 34 6a 10 00       	push   $0x106a34
  102d54:	e8 12 d5 ff ff       	call   10026b <cprintf>
  102d59:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102d5c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d5f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d62:	89 d0                	mov    %edx,%eax
  102d64:	c1 e0 02             	shl    $0x2,%eax
  102d67:	01 d0                	add    %edx,%eax
  102d69:	c1 e0 02             	shl    $0x2,%eax
  102d6c:	01 c8                	add    %ecx,%eax
  102d6e:	83 c0 14             	add    $0x14,%eax
  102d71:	8b 00                	mov    (%eax),%eax
  102d73:	83 f8 01             	cmp    $0x1,%eax
  102d76:	75 36                	jne    102dae <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
  102d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d7e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102d81:	77 2b                	ja     102dae <page_init+0x132>
  102d83:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102d86:	72 05                	jb     102d8d <page_init+0x111>
  102d88:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102d8b:	73 21                	jae    102dae <page_init+0x132>
  102d8d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102d91:	77 1b                	ja     102dae <page_init+0x132>
  102d93:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102d97:	72 09                	jb     102da2 <page_init+0x126>
  102d99:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102da0:	77 0c                	ja     102dae <page_init+0x132>
                maxpa = end;        //memory: 07ee0000, [00100000, 07fdffff], type = 1.
  102da2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102da5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102da8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102dab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102dae:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102db2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102db5:	8b 00                	mov    (%eax),%eax
  102db7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102dba:	0f 8f f6 fe ff ff    	jg     102cb6 <page_init+0x3a>
                maxpa = end;        //memory: 07ee0000, [00100000, 07fdffff], type = 1.
                                    //memory: 0009fc00, [00000000, 0009fbff], type = 1.
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102dc0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102dc4:	72 1d                	jb     102de3 <page_init+0x167>
  102dc6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102dca:	77 09                	ja     102dd5 <page_init+0x159>
  102dcc:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102dd3:	76 0e                	jbe    102de3 <page_init+0x167>
        maxpa = KMEMSIZE;
  102dd5:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102ddc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];          //虚拟地址结尾
    /*物理页数目*/
    npage = maxpa / PGSIZE;
  102de3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102de6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102de9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102ded:	c1 ea 0c             	shr    $0xc,%edx
  102df0:	a3 e0 98 11 00       	mov    %eax,0x1198e0
    /*页描述符结构，内核虚拟地址的尾部开始*/
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);    //页对其
  102df5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102dfc:	b8 88 99 11 00       	mov    $0x119988,%eax
  102e01:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e04:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102e07:	01 d0                	add    %edx,%eax
  102e09:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102e0c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102e0f:	ba 00 00 00 00       	mov    $0x0,%edx
  102e14:	f7 75 ac             	divl   -0x54(%ebp)
  102e17:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102e1a:	29 d0                	sub    %edx,%eax
  102e1c:	a3 78 99 11 00       	mov    %eax,0x119978
    /*页帧设置内核保留字段*/
    for (i = 0; i < npage; i ++) {
  102e21:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e28:	eb 2f                	jmp    102e59 <page_init+0x1dd>
        SetPageReserved(pages + i);
  102e2a:	8b 0d 78 99 11 00    	mov    0x119978,%ecx
  102e30:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e33:	89 d0                	mov    %edx,%eax
  102e35:	c1 e0 02             	shl    $0x2,%eax
  102e38:	01 d0                	add    %edx,%eax
  102e3a:	c1 e0 02             	shl    $0x2,%eax
  102e3d:	01 c8                	add    %ecx,%eax
  102e3f:	83 c0 04             	add    $0x4,%eax
  102e42:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102e49:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e4c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102e4f:	8b 55 90             	mov    -0x70(%ebp),%edx
  102e52:	0f ab 10             	bts    %edx,(%eax)
    /*物理页数目*/
    npage = maxpa / PGSIZE;
    /*页描述符结构，内核虚拟地址的尾部开始*/
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);    //页对其
    /*页帧设置内核保留字段*/
    for (i = 0; i < npage; i ++) {
  102e55:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102e59:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e5c:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  102e61:	39 c2                	cmp    %eax,%edx
  102e63:	72 c5                	jb     102e2a <page_init+0x1ae>
        SetPageReserved(pages + i);
    }
    /*页表空间之后的起始地址(物理)*/
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102e65:	8b 15 e0 98 11 00    	mov    0x1198e0,%edx
  102e6b:	89 d0                	mov    %edx,%eax
  102e6d:	c1 e0 02             	shl    $0x2,%eax
  102e70:	01 d0                	add    %edx,%eax
  102e72:	c1 e0 02             	shl    $0x2,%eax
  102e75:	89 c2                	mov    %eax,%edx
  102e77:	a1 78 99 11 00       	mov    0x119978,%eax
  102e7c:	01 d0                	add    %edx,%eax
  102e7e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102e81:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  102e88:	77 17                	ja     102ea1 <page_init+0x225>
  102e8a:	ff 75 a4             	pushl  -0x5c(%ebp)
  102e8d:	68 64 6a 10 00       	push   $0x106a64
  102e92:	68 df 00 00 00       	push   $0xdf
  102e97:	68 88 6a 10 00       	push   $0x106a88
  102e9c:	e8 30 d5 ff ff       	call   1003d1 <__panic>
  102ea1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102ea4:	05 00 00 00 40       	add    $0x40000000,%eax
  102ea9:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102eac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102eb3:	e9 69 01 00 00       	jmp    103021 <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102eb8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ebb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ebe:	89 d0                	mov    %edx,%eax
  102ec0:	c1 e0 02             	shl    $0x2,%eax
  102ec3:	01 d0                	add    %edx,%eax
  102ec5:	c1 e0 02             	shl    $0x2,%eax
  102ec8:	01 c8                	add    %ecx,%eax
  102eca:	8b 50 08             	mov    0x8(%eax),%edx
  102ecd:	8b 40 04             	mov    0x4(%eax),%eax
  102ed0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ed3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102ed6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ed9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102edc:	89 d0                	mov    %edx,%eax
  102ede:	c1 e0 02             	shl    $0x2,%eax
  102ee1:	01 d0                	add    %edx,%eax
  102ee3:	c1 e0 02             	shl    $0x2,%eax
  102ee6:	01 c8                	add    %ecx,%eax
  102ee8:	8b 48 0c             	mov    0xc(%eax),%ecx
  102eeb:	8b 58 10             	mov    0x10(%eax),%ebx
  102eee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ef1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ef4:	01 c8                	add    %ecx,%eax
  102ef6:	11 da                	adc    %ebx,%edx
  102ef8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102efb:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102efe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f01:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f04:	89 d0                	mov    %edx,%eax
  102f06:	c1 e0 02             	shl    $0x2,%eax
  102f09:	01 d0                	add    %edx,%eax
  102f0b:	c1 e0 02             	shl    $0x2,%eax
  102f0e:	01 c8                	add    %ecx,%eax
  102f10:	83 c0 14             	add    $0x14,%eax
  102f13:	8b 00                	mov    (%eax),%eax
  102f15:	83 f8 01             	cmp    $0x1,%eax
  102f18:	0f 85 ff 00 00 00    	jne    10301d <page_init+0x3a1>
            if (begin < freemem) {
  102f1e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f21:	ba 00 00 00 00       	mov    $0x0,%edx
  102f26:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f29:	72 17                	jb     102f42 <page_init+0x2c6>
  102f2b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f2e:	77 05                	ja     102f35 <page_init+0x2b9>
  102f30:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102f33:	76 0d                	jbe    102f42 <page_init+0x2c6>
                begin = freemem;
  102f35:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f38:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f3b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  102f42:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102f46:	72 1d                	jb     102f65 <page_init+0x2e9>
  102f48:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102f4c:	77 09                	ja     102f57 <page_init+0x2db>
  102f4e:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  102f55:	76 0e                	jbe    102f65 <page_init+0x2e9>
                end = KMEMSIZE;
  102f57:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  102f5e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  102f65:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f68:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f6b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f6e:	0f 87 a9 00 00 00    	ja     10301d <page_init+0x3a1>
  102f74:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f77:	72 09                	jb     102f82 <page_init+0x306>
  102f79:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102f7c:	0f 83 9b 00 00 00    	jae    10301d <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
  102f82:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  102f89:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102f8c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102f8f:	01 d0                	add    %edx,%eax
  102f91:	83 e8 01             	sub    $0x1,%eax
  102f94:	89 45 98             	mov    %eax,-0x68(%ebp)
  102f97:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f9a:	ba 00 00 00 00       	mov    $0x0,%edx
  102f9f:	f7 75 9c             	divl   -0x64(%ebp)
  102fa2:	8b 45 98             	mov    -0x68(%ebp),%eax
  102fa5:	29 d0                	sub    %edx,%eax
  102fa7:	ba 00 00 00 00       	mov    $0x0,%edx
  102fac:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102faf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  102fb2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102fb5:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102fb8:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102fbb:	ba 00 00 00 00       	mov    $0x0,%edx
  102fc0:	89 c3                	mov    %eax,%ebx
  102fc2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  102fc8:	89 de                	mov    %ebx,%esi
  102fca:	89 d0                	mov    %edx,%eax
  102fcc:	83 e0 00             	and    $0x0,%eax
  102fcf:	89 c7                	mov    %eax,%edi
  102fd1:	89 75 c8             	mov    %esi,-0x38(%ebp)
  102fd4:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  102fd7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fda:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102fdd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102fe0:	77 3b                	ja     10301d <page_init+0x3a1>
  102fe2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102fe5:	72 05                	jb     102fec <page_init+0x370>
  102fe7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102fea:	73 31                	jae    10301d <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  102fec:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102fef:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102ff2:	2b 45 d0             	sub    -0x30(%ebp),%eax
  102ff5:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  102ff8:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102ffc:	c1 ea 0c             	shr    $0xc,%edx
  102fff:	89 c3                	mov    %eax,%ebx
  103001:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103004:	83 ec 0c             	sub    $0xc,%esp
  103007:	50                   	push   %eax
  103008:	e8 08 f9 ff ff       	call   102915 <pa2page>
  10300d:	83 c4 10             	add    $0x10,%esp
  103010:	83 ec 08             	sub    $0x8,%esp
  103013:	53                   	push   %ebx
  103014:	50                   	push   %eax
  103015:	e8 a2 fb ff ff       	call   102bbc <init_memmap>
  10301a:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }
    /*页表空间之后的起始地址(物理)*/
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  10301d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103021:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103024:	8b 00                	mov    (%eax),%eax
  103026:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103029:	0f 8f 89 fe ff ff    	jg     102eb8 <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  10302f:	90                   	nop
  103030:	8d 65 f4             	lea    -0xc(%ebp),%esp
  103033:	5b                   	pop    %ebx
  103034:	5e                   	pop    %esi
  103035:	5f                   	pop    %edi
  103036:	5d                   	pop    %ebp
  103037:	c3                   	ret    

00103038 <enable_paging>:

static void
enable_paging(void) {
  103038:	55                   	push   %ebp
  103039:	89 e5                	mov    %esp,%ebp
  10303b:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  10303e:	a1 74 99 11 00       	mov    0x119974,%eax
  103043:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  103046:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103049:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10304c:	0f 20 c0             	mov    %cr0,%eax
  10304f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  103052:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  103055:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  103058:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  10305f:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
  103063:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103066:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  103069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10306c:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  10306f:	90                   	nop
  103070:	c9                   	leave  
  103071:	c3                   	ret    

00103072 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103072:	55                   	push   %ebp
  103073:	89 e5                	mov    %esp,%ebp
  103075:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
  103078:	8b 45 0c             	mov    0xc(%ebp),%eax
  10307b:	33 45 14             	xor    0x14(%ebp),%eax
  10307e:	25 ff 0f 00 00       	and    $0xfff,%eax
  103083:	85 c0                	test   %eax,%eax
  103085:	74 19                	je     1030a0 <boot_map_segment+0x2e>
  103087:	68 96 6a 10 00       	push   $0x106a96
  10308c:	68 ad 6a 10 00       	push   $0x106aad
  103091:	68 08 01 00 00       	push   $0x108
  103096:	68 88 6a 10 00       	push   $0x106a88
  10309b:	e8 31 d3 ff ff       	call   1003d1 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1030a0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1030a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030aa:	25 ff 0f 00 00       	and    $0xfff,%eax
  1030af:	89 c2                	mov    %eax,%edx
  1030b1:	8b 45 10             	mov    0x10(%ebp),%eax
  1030b4:	01 c2                	add    %eax,%edx
  1030b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b9:	01 d0                	add    %edx,%eax
  1030bb:	83 e8 01             	sub    $0x1,%eax
  1030be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030c4:	ba 00 00 00 00       	mov    $0x0,%edx
  1030c9:	f7 75 f0             	divl   -0x10(%ebp)
  1030cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030cf:	29 d0                	sub    %edx,%eax
  1030d1:	c1 e8 0c             	shr    $0xc,%eax
  1030d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1030d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030da:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1030e5:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1030e8:	8b 45 14             	mov    0x14(%ebp),%eax
  1030eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1030ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1030f6:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1030f9:	eb 57                	jmp    103152 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1030fb:	83 ec 04             	sub    $0x4,%esp
  1030fe:	6a 01                	push   $0x1
  103100:	ff 75 0c             	pushl  0xc(%ebp)
  103103:	ff 75 08             	pushl  0x8(%ebp)
  103106:	e8 98 01 00 00       	call   1032a3 <get_pte>
  10310b:	83 c4 10             	add    $0x10,%esp
  10310e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103111:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103115:	75 19                	jne    103130 <boot_map_segment+0xbe>
  103117:	68 c2 6a 10 00       	push   $0x106ac2
  10311c:	68 ad 6a 10 00       	push   $0x106aad
  103121:	68 0e 01 00 00       	push   $0x10e
  103126:	68 88 6a 10 00       	push   $0x106a88
  10312b:	e8 a1 d2 ff ff       	call   1003d1 <__panic>
        *ptep = pa | PTE_P | perm;
  103130:	8b 45 14             	mov    0x14(%ebp),%eax
  103133:	0b 45 18             	or     0x18(%ebp),%eax
  103136:	83 c8 01             	or     $0x1,%eax
  103139:	89 c2                	mov    %eax,%edx
  10313b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10313e:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103140:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103144:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10314b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103152:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103156:	75 a3                	jne    1030fb <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  103158:	90                   	nop
  103159:	c9                   	leave  
  10315a:	c3                   	ret    

0010315b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10315b:	55                   	push   %ebp
  10315c:	89 e5                	mov    %esp,%ebp
  10315e:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
  103161:	83 ec 0c             	sub    $0xc,%esp
  103164:	6a 01                	push   $0x1
  103166:	e8 70 fa ff ff       	call   102bdb <alloc_pages>
  10316b:	83 c4 10             	add    $0x10,%esp
  10316e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  103171:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103175:	75 17                	jne    10318e <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
  103177:	83 ec 04             	sub    $0x4,%esp
  10317a:	68 cf 6a 10 00       	push   $0x106acf
  10317f:	68 1a 01 00 00       	push   $0x11a
  103184:	68 88 6a 10 00       	push   $0x106a88
  103189:	e8 43 d2 ff ff       	call   1003d1 <__panic>
    }
    return page2kva(p);
  10318e:	83 ec 0c             	sub    $0xc,%esp
  103191:	ff 75 f4             	pushl  -0xc(%ebp)
  103194:	e8 c3 f7 ff ff       	call   10295c <page2kva>
  103199:	83 c4 10             	add    $0x10,%esp
}
  10319c:	c9                   	leave  
  10319d:	c3                   	ret    

0010319e <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10319e:	55                   	push   %ebp
  10319f:	89 e5                	mov    %esp,%ebp
  1031a1:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1031a4:	e8 de f9 ff ff       	call   102b87 <init_pmm_manager>

    // detect physical memory space, reserve already used memory, 
    // then use pmm->init_memmap to create free page list
    //建立物理页表
    page_init();
  1031a9:	e8 ce fa ff ff       	call   102c7c <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1031ae:	e8 78 04 00 00       	call   10362b <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    //创建页目录
    boot_pgdir = boot_alloc_page();
  1031b3:	e8 a3 ff ff ff       	call   10315b <boot_alloc_page>
  1031b8:	a3 e4 98 11 00       	mov    %eax,0x1198e4
    memset(boot_pgdir, 0, PGSIZE);
  1031bd:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1031c2:	83 ec 04             	sub    $0x4,%esp
  1031c5:	68 00 10 00 00       	push   $0x1000
  1031ca:	6a 00                	push   $0x0
  1031cc:	50                   	push   %eax
  1031cd:	e8 11 29 00 00       	call   105ae3 <memset>
  1031d2:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
  1031d5:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1031da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031dd:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1031e4:	77 17                	ja     1031fd <pmm_init+0x5f>
  1031e6:	ff 75 f4             	pushl  -0xc(%ebp)
  1031e9:	68 64 6a 10 00       	push   $0x106a64
  1031ee:	68 36 01 00 00       	push   $0x136
  1031f3:	68 88 6a 10 00       	push   $0x106a88
  1031f8:	e8 d4 d1 ff ff       	call   1003d1 <__panic>
  1031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103200:	05 00 00 00 40       	add    $0x40000000,%eax
  103205:	a3 74 99 11 00       	mov    %eax,0x119974

    check_pgdir();
  10320a:	e8 3f 04 00 00       	call   10364e <check_pgdir>
    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    //页目录插入虚拟页表
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10320f:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103214:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  10321a:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  10321f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103222:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103229:	77 17                	ja     103242 <pmm_init+0xa4>
  10322b:	ff 75 f0             	pushl  -0x10(%ebp)
  10322e:	68 64 6a 10 00       	push   $0x106a64
  103233:	68 3f 01 00 00       	push   $0x13f
  103238:	68 88 6a 10 00       	push   $0x106a88
  10323d:	e8 8f d1 ff ff       	call   1003d1 <__panic>
  103242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103245:	05 00 00 00 40       	add    $0x40000000,%eax
  10324a:	83 c8 03             	or     $0x3,%eax
  10324d:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = p    hy_addr 0~KMEMSIZE 物理地址0~0x38000000映射到线性地址0xC0000000~0xC0000000+0x38000000
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10324f:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103254:	83 ec 0c             	sub    $0xc,%esp
  103257:	6a 02                	push   $0x2
  103259:	6a 00                	push   $0x0
  10325b:	68 00 00 00 38       	push   $0x38000000
  103260:	68 00 00 00 c0       	push   $0xc0000000
  103265:	50                   	push   %eax
  103266:	e8 07 fe ff ff       	call   103072 <boot_map_segment>
  10326b:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  10326e:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103273:	8b 15 e4 98 11 00    	mov    0x1198e4,%edx
  103279:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  10327f:	89 10                	mov    %edx,(%eax)

    enable_paging();
  103281:	e8 b2 fd ff ff       	call   103038 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103286:	e8 0a f8 ff ff       	call   102a95 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  10328b:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103290:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103296:	e8 19 09 00 00       	call   103bb4 <check_boot_pgdir>

    print_pgdir();
  10329b:	e8 14 0d 00 00       	call   103fb4 <print_pgdir>

}
  1032a0:	90                   	nop
  1032a1:	c9                   	leave  
  1032a2:	c3                   	ret    

001032a3 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
// 获取二级页表项地址
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1032a3:	55                   	push   %ebp
  1032a4:	89 e5                	mov    %esp,%ebp
  1032a6:	83 ec 28             	sub    $0x28,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = NULL;
  1032a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    pde_t *base_addr = pgdir;       //第一个空闲页表
  1032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b3:	89 45 f0             	mov    %eax,-0x10(%ebp)

    pdep = &base_addr[PDX(la)];
  1032b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032b9:	c1 e8 16             	shr    $0x16,%eax
  1032bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1032c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032c6:	01 d0                	add    %edx,%eax
  1032c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep)&PTE_P) == 0){
  1032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032ce:	8b 00                	mov    (%eax),%eax
  1032d0:	83 e0 01             	and    $0x1,%eax
  1032d3:	85 c0                	test   %eax,%eax
  1032d5:	0f 85 a4 00 00 00    	jne    10337f <get_pte+0xdc>
        struct Page *page = NULL;
  1032db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

        if (create == 0 || (page = alloc_page()) == NULL) return NULL;
  1032e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032e6:	74 16                	je     1032fe <get_pte+0x5b>
  1032e8:	83 ec 0c             	sub    $0xc,%esp
  1032eb:	6a 01                	push   $0x1
  1032ed:	e8 e9 f8 ff ff       	call   102bdb <alloc_pages>
  1032f2:	83 c4 10             	add    $0x10,%esp
  1032f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1032fc:	75 0a                	jne    103308 <get_pte+0x65>
  1032fe:	b8 00 00 00 00       	mov    $0x0,%eax
  103303:	e9 c8 00 00 00       	jmp    1033d0 <get_pte+0x12d>

        uintptr_t pa_page = page2pa(page);
  103308:	83 ec 0c             	sub    $0xc,%esp
  10330b:	ff 75 ec             	pushl  -0x14(%ebp)
  10330e:	e8 ef f5 ff ff       	call   102902 <page2pa>
  103313:	83 c4 10             	add    $0x10,%esp
  103316:	89 45 e8             	mov    %eax,-0x18(%ebp)
        memset(KADDR(pa_page), 0, PGSIZE);
  103319:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10331c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10331f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103322:	c1 e8 0c             	shr    $0xc,%eax
  103325:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103328:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  10332d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103330:	72 17                	jb     103349 <get_pte+0xa6>
  103332:	ff 75 e4             	pushl  -0x1c(%ebp)
  103335:	68 c0 69 10 00       	push   $0x1069c0
  10333a:	68 91 01 00 00       	push   $0x191
  10333f:	68 88 6a 10 00       	push   $0x106a88
  103344:	e8 88 d0 ff ff       	call   1003d1 <__panic>
  103349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10334c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103351:	83 ec 04             	sub    $0x4,%esp
  103354:	68 00 10 00 00       	push   $0x1000
  103359:	6a 00                	push   $0x0
  10335b:	50                   	push   %eax
  10335c:	e8 82 27 00 00       	call   105ae3 <memset>
  103361:	83 c4 10             	add    $0x10,%esp
        *pdep = pa_page | PTE_P | PTE_U | PTE_W;
  103364:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103367:	83 c8 07             	or     $0x7,%eax
  10336a:	89 c2                	mov    %eax,%edx
  10336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10336f:	89 10                	mov    %edx,(%eax)
        page_ref_inc(page);
  103371:	83 ec 0c             	sub    $0xc,%esp
  103374:	ff 75 ec             	pushl  -0x14(%ebp)
  103377:	e8 69 f6 ff ff       	call   1029e5 <page_ref_inc>
  10337c:	83 c4 10             	add    $0x10,%esp
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  10337f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103382:	8b 00                	mov    (%eax),%eax
  103384:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103389:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10338c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10338f:	c1 e8 0c             	shr    $0xc,%eax
  103392:	89 45 d8             	mov    %eax,-0x28(%ebp)
  103395:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  10339a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10339d:	72 17                	jb     1033b6 <get_pte+0x113>
  10339f:	ff 75 dc             	pushl  -0x24(%ebp)
  1033a2:	68 c0 69 10 00       	push   $0x1069c0
  1033a7:	68 95 01 00 00       	push   $0x195
  1033ac:	68 88 6a 10 00       	push   $0x106a88
  1033b1:	e8 1b d0 ff ff       	call   1003d1 <__panic>
  1033b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1033b9:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1033be:	89 c2                	mov    %eax,%edx
  1033c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033c3:	c1 e8 0c             	shr    $0xc,%eax
  1033c6:	25 ff 03 00 00       	and    $0x3ff,%eax
  1033cb:	c1 e0 02             	shl    $0x2,%eax
  1033ce:	01 d0                	add    %edx,%eax
}
  1033d0:	c9                   	leave  
  1033d1:	c3                   	ret    

001033d2 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1033d2:	55                   	push   %ebp
  1033d3:	89 e5                	mov    %esp,%ebp
  1033d5:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1033d8:	83 ec 04             	sub    $0x4,%esp
  1033db:	6a 00                	push   $0x0
  1033dd:	ff 75 0c             	pushl  0xc(%ebp)
  1033e0:	ff 75 08             	pushl  0x8(%ebp)
  1033e3:	e8 bb fe ff ff       	call   1032a3 <get_pte>
  1033e8:	83 c4 10             	add    $0x10,%esp
  1033eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1033ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033f2:	74 08                	je     1033fc <get_page+0x2a>
        *ptep_store = ptep;
  1033f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1033f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033fa:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1033fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103400:	74 1f                	je     103421 <get_page+0x4f>
  103402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103405:	8b 00                	mov    (%eax),%eax
  103407:	83 e0 01             	and    $0x1,%eax
  10340a:	85 c0                	test   %eax,%eax
  10340c:	74 13                	je     103421 <get_page+0x4f>
        return pa2page(*ptep);
  10340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103411:	8b 00                	mov    (%eax),%eax
  103413:	83 ec 0c             	sub    $0xc,%esp
  103416:	50                   	push   %eax
  103417:	e8 f9 f4 ff ff       	call   102915 <pa2page>
  10341c:	83 c4 10             	add    $0x10,%esp
  10341f:	eb 05                	jmp    103426 <get_page+0x54>
    }
    return NULL;
  103421:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103426:	c9                   	leave  
  103427:	c3                   	ret    

00103428 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 删除一个页
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  103428:	55                   	push   %ebp
  103429:	89 e5                	mov    %esp,%ebp
  10342b:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    pde_t *pdep = NULL;
  10342e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    pde_t *base_addr = pgdir;
  103435:	8b 45 08             	mov    0x8(%ebp),%eax
  103438:	89 45 f0             	mov    %eax,-0x10(%ebp)

    pdep = &base_addr[PDX(la)];
  10343b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10343e:	c1 e8 16             	shr    $0x16,%eax
  103441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10344b:	01 d0                	add    %edx,%eax
  10344d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep)&PTE_P) == 0 || ((*ptep)&PTE_P) == 0){
  103450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103453:	8b 00                	mov    (%eax),%eax
  103455:	83 e0 01             	and    $0x1,%eax
  103458:	85 c0                	test   %eax,%eax
  10345a:	0f 84 86 00 00 00    	je     1034e6 <page_remove_pte+0xbe>
  103460:	8b 45 10             	mov    0x10(%ebp),%eax
  103463:	8b 00                	mov    (%eax),%eax
  103465:	83 e0 01             	and    $0x1,%eax
  103468:	85 c0                	test   %eax,%eax
  10346a:	74 7a                	je     1034e6 <page_remove_pte+0xbe>
        return;
    }else{
        struct Page *page = pte2page(*ptep);
  10346c:	8b 45 10             	mov    0x10(%ebp),%eax
  10346f:	8b 00                	mov    (%eax),%eax
  103471:	83 ec 0c             	sub    $0xc,%esp
  103474:	50                   	push   %eax
  103475:	e8 27 f5 ff ff       	call   1029a1 <pte2page>
  10347a:	83 c4 10             	add    $0x10,%esp
  10347d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        
        assert(page->ref != 0);
  103480:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103483:	8b 00                	mov    (%eax),%eax
  103485:	85 c0                	test   %eax,%eax
  103487:	75 19                	jne    1034a2 <page_remove_pte+0x7a>
  103489:	68 e8 6a 10 00       	push   $0x106ae8
  10348e:	68 ad 6a 10 00       	push   $0x106aad
  103493:	68 cc 01 00 00       	push   $0x1cc
  103498:	68 88 6a 10 00       	push   $0x106a88
  10349d:	e8 2f cf ff ff       	call   1003d1 <__panic>
        if (page_ref_dec(page) == 0){
  1034a2:	83 ec 0c             	sub    $0xc,%esp
  1034a5:	ff 75 ec             	pushl  -0x14(%ebp)
  1034a8:	e8 4f f5 ff ff       	call   1029fc <page_ref_dec>
  1034ad:	83 c4 10             	add    $0x10,%esp
  1034b0:	85 c0                	test   %eax,%eax
  1034b2:	75 33                	jne    1034e7 <page_remove_pte+0xbf>
            free_page(page);
  1034b4:	83 ec 08             	sub    $0x8,%esp
  1034b7:	6a 01                	push   $0x1
  1034b9:	ff 75 ec             	pushl  -0x14(%ebp)
  1034bc:	e8 58 f7 ff ff       	call   102c19 <free_pages>
  1034c1:	83 c4 10             	add    $0x10,%esp
            *ptep = *ptep & ~PTE_P;
  1034c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1034c7:	8b 00                	mov    (%eax),%eax
  1034c9:	83 e0 fe             	and    $0xfffffffe,%eax
  1034cc:	89 c2                	mov    %eax,%edx
  1034ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1034d1:	89 10                	mov    %edx,(%eax)
            tlb_invalidate(base_addr, la);
  1034d3:	83 ec 08             	sub    $0x8,%esp
  1034d6:	ff 75 0c             	pushl  0xc(%ebp)
  1034d9:	ff 75 f0             	pushl  -0x10(%ebp)
  1034dc:	e8 fa 00 00 00       	call   1035db <tlb_invalidate>
  1034e1:	83 c4 10             	add    $0x10,%esp
  1034e4:	eb 01                	jmp    1034e7 <page_remove_pte+0xbf>
    pde_t *pdep = NULL;
    pde_t *base_addr = pgdir;

    pdep = &base_addr[PDX(la)];
    if (((*pdep)&PTE_P) == 0 || ((*ptep)&PTE_P) == 0){
        return;
  1034e6:	90                   	nop
            free_page(page);
            *ptep = *ptep & ~PTE_P;
            tlb_invalidate(base_addr, la);
        } 
    }
}
  1034e7:	c9                   	leave  
  1034e8:	c3                   	ret    

001034e9 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1034e9:	55                   	push   %ebp
  1034ea:	89 e5                	mov    %esp,%ebp
  1034ec:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1034ef:	83 ec 04             	sub    $0x4,%esp
  1034f2:	6a 00                	push   $0x0
  1034f4:	ff 75 0c             	pushl  0xc(%ebp)
  1034f7:	ff 75 08             	pushl  0x8(%ebp)
  1034fa:	e8 a4 fd ff ff       	call   1032a3 <get_pte>
  1034ff:	83 c4 10             	add    $0x10,%esp
  103502:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103509:	74 14                	je     10351f <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
  10350b:	83 ec 04             	sub    $0x4,%esp
  10350e:	ff 75 f4             	pushl  -0xc(%ebp)
  103511:	ff 75 0c             	pushl  0xc(%ebp)
  103514:	ff 75 08             	pushl  0x8(%ebp)
  103517:	e8 0c ff ff ff       	call   103428 <page_remove_pte>
  10351c:	83 c4 10             	add    $0x10,%esp
    }
}
  10351f:	90                   	nop
  103520:	c9                   	leave  
  103521:	c3                   	ret    

00103522 <page_insert>:
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
//插入二级页表
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103522:	55                   	push   %ebp
  103523:	89 e5                	mov    %esp,%ebp
  103525:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103528:	83 ec 04             	sub    $0x4,%esp
  10352b:	6a 01                	push   $0x1
  10352d:	ff 75 10             	pushl  0x10(%ebp)
  103530:	ff 75 08             	pushl  0x8(%ebp)
  103533:	e8 6b fd ff ff       	call   1032a3 <get_pte>
  103538:	83 c4 10             	add    $0x10,%esp
  10353b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10353e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103542:	75 0a                	jne    10354e <page_insert+0x2c>
        return -E_NO_MEM;
  103544:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103549:	e9 8b 00 00 00       	jmp    1035d9 <page_insert+0xb7>
    }
    page_ref_inc(page);
  10354e:	83 ec 0c             	sub    $0xc,%esp
  103551:	ff 75 0c             	pushl  0xc(%ebp)
  103554:	e8 8c f4 ff ff       	call   1029e5 <page_ref_inc>
  103559:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
  10355c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10355f:	8b 00                	mov    (%eax),%eax
  103561:	83 e0 01             	and    $0x1,%eax
  103564:	85 c0                	test   %eax,%eax
  103566:	74 40                	je     1035a8 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
  103568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10356b:	8b 00                	mov    (%eax),%eax
  10356d:	83 ec 0c             	sub    $0xc,%esp
  103570:	50                   	push   %eax
  103571:	e8 2b f4 ff ff       	call   1029a1 <pte2page>
  103576:	83 c4 10             	add    $0x10,%esp
  103579:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10357c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10357f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103582:	75 10                	jne    103594 <page_insert+0x72>
            page_ref_dec(page);
  103584:	83 ec 0c             	sub    $0xc,%esp
  103587:	ff 75 0c             	pushl  0xc(%ebp)
  10358a:	e8 6d f4 ff ff       	call   1029fc <page_ref_dec>
  10358f:	83 c4 10             	add    $0x10,%esp
  103592:	eb 14                	jmp    1035a8 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103594:	83 ec 04             	sub    $0x4,%esp
  103597:	ff 75 f4             	pushl  -0xc(%ebp)
  10359a:	ff 75 10             	pushl  0x10(%ebp)
  10359d:	ff 75 08             	pushl  0x8(%ebp)
  1035a0:	e8 83 fe ff ff       	call   103428 <page_remove_pte>
  1035a5:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1035a8:	83 ec 0c             	sub    $0xc,%esp
  1035ab:	ff 75 0c             	pushl  0xc(%ebp)
  1035ae:	e8 4f f3 ff ff       	call   102902 <page2pa>
  1035b3:	83 c4 10             	add    $0x10,%esp
  1035b6:	0b 45 14             	or     0x14(%ebp),%eax
  1035b9:	83 c8 01             	or     $0x1,%eax
  1035bc:	89 c2                	mov    %eax,%edx
  1035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035c1:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1035c3:	83 ec 08             	sub    $0x8,%esp
  1035c6:	ff 75 10             	pushl  0x10(%ebp)
  1035c9:	ff 75 08             	pushl  0x8(%ebp)
  1035cc:	e8 0a 00 00 00       	call   1035db <tlb_invalidate>
  1035d1:	83 c4 10             	add    $0x10,%esp
    return 0;
  1035d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035d9:	c9                   	leave  
  1035da:	c3                   	ret    

001035db <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.使某一个TLB中的对应的某一个页失效
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1035db:	55                   	push   %ebp
  1035dc:	89 e5                	mov    %esp,%ebp
  1035de:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1035e1:	0f 20 d8             	mov    %cr3,%eax
  1035e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
  1035e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1035ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035f0:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1035f7:	77 17                	ja     103610 <tlb_invalidate+0x35>
  1035f9:	ff 75 f0             	pushl  -0x10(%ebp)
  1035fc:	68 64 6a 10 00       	push   $0x106a64
  103601:	68 00 02 00 00       	push   $0x200
  103606:	68 88 6a 10 00       	push   $0x106a88
  10360b:	e8 c1 cd ff ff       	call   1003d1 <__panic>
  103610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103613:	05 00 00 00 40       	add    $0x40000000,%eax
  103618:	39 c2                	cmp    %eax,%edx
  10361a:	75 0c                	jne    103628 <tlb_invalidate+0x4d>
        invlpg((void *)la);
  10361c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10361f:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103625:	0f 01 38             	invlpg (%eax)
    }
}
  103628:	90                   	nop
  103629:	c9                   	leave  
  10362a:	c3                   	ret    

0010362b <check_alloc_page>:

static void
check_alloc_page(void) {
  10362b:	55                   	push   %ebp
  10362c:	89 e5                	mov    %esp,%ebp
  10362e:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
  103631:	a1 70 99 11 00       	mov    0x119970,%eax
  103636:	8b 40 18             	mov    0x18(%eax),%eax
  103639:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10363b:	83 ec 0c             	sub    $0xc,%esp
  10363e:	68 f8 6a 10 00       	push   $0x106af8
  103643:	e8 23 cc ff ff       	call   10026b <cprintf>
  103648:	83 c4 10             	add    $0x10,%esp
}
  10364b:	90                   	nop
  10364c:	c9                   	leave  
  10364d:	c3                   	ret    

0010364e <check_pgdir>:

static void
check_pgdir(void) {
  10364e:	55                   	push   %ebp
  10364f:	89 e5                	mov    %esp,%ebp
  103651:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103654:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  103659:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10365e:	76 19                	jbe    103679 <check_pgdir+0x2b>
  103660:	68 17 6b 10 00       	push   $0x106b17
  103665:	68 ad 6a 10 00       	push   $0x106aad
  10366a:	68 0d 02 00 00       	push   $0x20d
  10366f:	68 88 6a 10 00       	push   $0x106a88
  103674:	e8 58 cd ff ff       	call   1003d1 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103679:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  10367e:	85 c0                	test   %eax,%eax
  103680:	74 0e                	je     103690 <check_pgdir+0x42>
  103682:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103687:	25 ff 0f 00 00       	and    $0xfff,%eax
  10368c:	85 c0                	test   %eax,%eax
  10368e:	74 19                	je     1036a9 <check_pgdir+0x5b>
  103690:	68 34 6b 10 00       	push   $0x106b34
  103695:	68 ad 6a 10 00       	push   $0x106aad
  10369a:	68 0e 02 00 00       	push   $0x20e
  10369f:	68 88 6a 10 00       	push   $0x106a88
  1036a4:	e8 28 cd ff ff       	call   1003d1 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1036a9:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1036ae:	83 ec 04             	sub    $0x4,%esp
  1036b1:	6a 00                	push   $0x0
  1036b3:	6a 00                	push   $0x0
  1036b5:	50                   	push   %eax
  1036b6:	e8 17 fd ff ff       	call   1033d2 <get_page>
  1036bb:	83 c4 10             	add    $0x10,%esp
  1036be:	85 c0                	test   %eax,%eax
  1036c0:	74 19                	je     1036db <check_pgdir+0x8d>
  1036c2:	68 6c 6b 10 00       	push   $0x106b6c
  1036c7:	68 ad 6a 10 00       	push   $0x106aad
  1036cc:	68 0f 02 00 00       	push   $0x20f
  1036d1:	68 88 6a 10 00       	push   $0x106a88
  1036d6:	e8 f6 cc ff ff       	call   1003d1 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1036db:	83 ec 0c             	sub    $0xc,%esp
  1036de:	6a 01                	push   $0x1
  1036e0:	e8 f6 f4 ff ff       	call   102bdb <alloc_pages>
  1036e5:	83 c4 10             	add    $0x10,%esp
  1036e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1036eb:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1036f0:	6a 00                	push   $0x0
  1036f2:	6a 00                	push   $0x0
  1036f4:	ff 75 f4             	pushl  -0xc(%ebp)
  1036f7:	50                   	push   %eax
  1036f8:	e8 25 fe ff ff       	call   103522 <page_insert>
  1036fd:	83 c4 10             	add    $0x10,%esp
  103700:	85 c0                	test   %eax,%eax
  103702:	74 19                	je     10371d <check_pgdir+0xcf>
  103704:	68 94 6b 10 00       	push   $0x106b94
  103709:	68 ad 6a 10 00       	push   $0x106aad
  10370e:	68 13 02 00 00       	push   $0x213
  103713:	68 88 6a 10 00       	push   $0x106a88
  103718:	e8 b4 cc ff ff       	call   1003d1 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  10371d:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103722:	83 ec 04             	sub    $0x4,%esp
  103725:	6a 00                	push   $0x0
  103727:	6a 00                	push   $0x0
  103729:	50                   	push   %eax
  10372a:	e8 74 fb ff ff       	call   1032a3 <get_pte>
  10372f:	83 c4 10             	add    $0x10,%esp
  103732:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103735:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103739:	75 19                	jne    103754 <check_pgdir+0x106>
  10373b:	68 c0 6b 10 00       	push   $0x106bc0
  103740:	68 ad 6a 10 00       	push   $0x106aad
  103745:	68 16 02 00 00       	push   $0x216
  10374a:	68 88 6a 10 00       	push   $0x106a88
  10374f:	e8 7d cc ff ff       	call   1003d1 <__panic>
    assert(pa2page(*ptep) == p1);
  103754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103757:	8b 00                	mov    (%eax),%eax
  103759:	83 ec 0c             	sub    $0xc,%esp
  10375c:	50                   	push   %eax
  10375d:	e8 b3 f1 ff ff       	call   102915 <pa2page>
  103762:	83 c4 10             	add    $0x10,%esp
  103765:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103768:	74 19                	je     103783 <check_pgdir+0x135>
  10376a:	68 ed 6b 10 00       	push   $0x106bed
  10376f:	68 ad 6a 10 00       	push   $0x106aad
  103774:	68 17 02 00 00       	push   $0x217
  103779:	68 88 6a 10 00       	push   $0x106a88
  10377e:	e8 4e cc ff ff       	call   1003d1 <__panic>
    assert(page_ref(p1) == 1);
  103783:	83 ec 0c             	sub    $0xc,%esp
  103786:	ff 75 f4             	pushl  -0xc(%ebp)
  103789:	e8 4d f2 ff ff       	call   1029db <page_ref>
  10378e:	83 c4 10             	add    $0x10,%esp
  103791:	83 f8 01             	cmp    $0x1,%eax
  103794:	74 19                	je     1037af <check_pgdir+0x161>
  103796:	68 02 6c 10 00       	push   $0x106c02
  10379b:	68 ad 6a 10 00       	push   $0x106aad
  1037a0:	68 18 02 00 00       	push   $0x218
  1037a5:	68 88 6a 10 00       	push   $0x106a88
  1037aa:	e8 22 cc ff ff       	call   1003d1 <__panic>
    
    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1037af:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1037b4:	8b 00                	mov    (%eax),%eax
  1037b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1037bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1037be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037c1:	c1 e8 0c             	shr    $0xc,%eax
  1037c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1037c7:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  1037cc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1037cf:	72 17                	jb     1037e8 <check_pgdir+0x19a>
  1037d1:	ff 75 ec             	pushl  -0x14(%ebp)
  1037d4:	68 c0 69 10 00       	push   $0x1069c0
  1037d9:	68 1a 02 00 00       	push   $0x21a
  1037de:	68 88 6a 10 00       	push   $0x106a88
  1037e3:	e8 e9 cb ff ff       	call   1003d1 <__panic>
  1037e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037eb:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1037f0:	83 c0 04             	add    $0x4,%eax
  1037f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1037f6:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1037fb:	83 ec 04             	sub    $0x4,%esp
  1037fe:	6a 00                	push   $0x0
  103800:	68 00 10 00 00       	push   $0x1000
  103805:	50                   	push   %eax
  103806:	e8 98 fa ff ff       	call   1032a3 <get_pte>
  10380b:	83 c4 10             	add    $0x10,%esp
  10380e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103811:	74 19                	je     10382c <check_pgdir+0x1de>
  103813:	68 14 6c 10 00       	push   $0x106c14
  103818:	68 ad 6a 10 00       	push   $0x106aad
  10381d:	68 1b 02 00 00       	push   $0x21b
  103822:	68 88 6a 10 00       	push   $0x106a88
  103827:	e8 a5 cb ff ff       	call   1003d1 <__panic>

    p2 = alloc_page();
  10382c:	83 ec 0c             	sub    $0xc,%esp
  10382f:	6a 01                	push   $0x1
  103831:	e8 a5 f3 ff ff       	call   102bdb <alloc_pages>
  103836:	83 c4 10             	add    $0x10,%esp
  103839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10383c:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103841:	6a 06                	push   $0x6
  103843:	68 00 10 00 00       	push   $0x1000
  103848:	ff 75 e4             	pushl  -0x1c(%ebp)
  10384b:	50                   	push   %eax
  10384c:	e8 d1 fc ff ff       	call   103522 <page_insert>
  103851:	83 c4 10             	add    $0x10,%esp
  103854:	85 c0                	test   %eax,%eax
  103856:	74 19                	je     103871 <check_pgdir+0x223>
  103858:	68 3c 6c 10 00       	push   $0x106c3c
  10385d:	68 ad 6a 10 00       	push   $0x106aad
  103862:	68 1e 02 00 00       	push   $0x21e
  103867:	68 88 6a 10 00       	push   $0x106a88
  10386c:	e8 60 cb ff ff       	call   1003d1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103871:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103876:	83 ec 04             	sub    $0x4,%esp
  103879:	6a 00                	push   $0x0
  10387b:	68 00 10 00 00       	push   $0x1000
  103880:	50                   	push   %eax
  103881:	e8 1d fa ff ff       	call   1032a3 <get_pte>
  103886:	83 c4 10             	add    $0x10,%esp
  103889:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10388c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103890:	75 19                	jne    1038ab <check_pgdir+0x25d>
  103892:	68 74 6c 10 00       	push   $0x106c74
  103897:	68 ad 6a 10 00       	push   $0x106aad
  10389c:	68 1f 02 00 00       	push   $0x21f
  1038a1:	68 88 6a 10 00       	push   $0x106a88
  1038a6:	e8 26 cb ff ff       	call   1003d1 <__panic>
    assert(*ptep & PTE_U);
  1038ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038ae:	8b 00                	mov    (%eax),%eax
  1038b0:	83 e0 04             	and    $0x4,%eax
  1038b3:	85 c0                	test   %eax,%eax
  1038b5:	75 19                	jne    1038d0 <check_pgdir+0x282>
  1038b7:	68 a4 6c 10 00       	push   $0x106ca4
  1038bc:	68 ad 6a 10 00       	push   $0x106aad
  1038c1:	68 20 02 00 00       	push   $0x220
  1038c6:	68 88 6a 10 00       	push   $0x106a88
  1038cb:	e8 01 cb ff ff       	call   1003d1 <__panic>
    assert(*ptep & PTE_W);
  1038d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038d3:	8b 00                	mov    (%eax),%eax
  1038d5:	83 e0 02             	and    $0x2,%eax
  1038d8:	85 c0                	test   %eax,%eax
  1038da:	75 19                	jne    1038f5 <check_pgdir+0x2a7>
  1038dc:	68 b2 6c 10 00       	push   $0x106cb2
  1038e1:	68 ad 6a 10 00       	push   $0x106aad
  1038e6:	68 21 02 00 00       	push   $0x221
  1038eb:	68 88 6a 10 00       	push   $0x106a88
  1038f0:	e8 dc ca ff ff       	call   1003d1 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  1038f5:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1038fa:	8b 00                	mov    (%eax),%eax
  1038fc:	83 e0 04             	and    $0x4,%eax
  1038ff:	85 c0                	test   %eax,%eax
  103901:	75 19                	jne    10391c <check_pgdir+0x2ce>
  103903:	68 c0 6c 10 00       	push   $0x106cc0
  103908:	68 ad 6a 10 00       	push   $0x106aad
  10390d:	68 22 02 00 00       	push   $0x222
  103912:	68 88 6a 10 00       	push   $0x106a88
  103917:	e8 b5 ca ff ff       	call   1003d1 <__panic>
    assert(page_ref(p2) == 1);
  10391c:	83 ec 0c             	sub    $0xc,%esp
  10391f:	ff 75 e4             	pushl  -0x1c(%ebp)
  103922:	e8 b4 f0 ff ff       	call   1029db <page_ref>
  103927:	83 c4 10             	add    $0x10,%esp
  10392a:	83 f8 01             	cmp    $0x1,%eax
  10392d:	74 19                	je     103948 <check_pgdir+0x2fa>
  10392f:	68 d6 6c 10 00       	push   $0x106cd6
  103934:	68 ad 6a 10 00       	push   $0x106aad
  103939:	68 23 02 00 00       	push   $0x223
  10393e:	68 88 6a 10 00       	push   $0x106a88
  103943:	e8 89 ca ff ff       	call   1003d1 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103948:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  10394d:	6a 00                	push   $0x0
  10394f:	68 00 10 00 00       	push   $0x1000
  103954:	ff 75 f4             	pushl  -0xc(%ebp)
  103957:	50                   	push   %eax
  103958:	e8 c5 fb ff ff       	call   103522 <page_insert>
  10395d:	83 c4 10             	add    $0x10,%esp
  103960:	85 c0                	test   %eax,%eax
  103962:	74 19                	je     10397d <check_pgdir+0x32f>
  103964:	68 e8 6c 10 00       	push   $0x106ce8
  103969:	68 ad 6a 10 00       	push   $0x106aad
  10396e:	68 25 02 00 00       	push   $0x225
  103973:	68 88 6a 10 00       	push   $0x106a88
  103978:	e8 54 ca ff ff       	call   1003d1 <__panic>
    assert(page_ref(p1) == 2);
  10397d:	83 ec 0c             	sub    $0xc,%esp
  103980:	ff 75 f4             	pushl  -0xc(%ebp)
  103983:	e8 53 f0 ff ff       	call   1029db <page_ref>
  103988:	83 c4 10             	add    $0x10,%esp
  10398b:	83 f8 02             	cmp    $0x2,%eax
  10398e:	74 19                	je     1039a9 <check_pgdir+0x35b>
  103990:	68 14 6d 10 00       	push   $0x106d14
  103995:	68 ad 6a 10 00       	push   $0x106aad
  10399a:	68 26 02 00 00       	push   $0x226
  10399f:	68 88 6a 10 00       	push   $0x106a88
  1039a4:	e8 28 ca ff ff       	call   1003d1 <__panic>
    assert(page_ref(p2) == 0);
  1039a9:	83 ec 0c             	sub    $0xc,%esp
  1039ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  1039af:	e8 27 f0 ff ff       	call   1029db <page_ref>
  1039b4:	83 c4 10             	add    $0x10,%esp
  1039b7:	85 c0                	test   %eax,%eax
  1039b9:	74 19                	je     1039d4 <check_pgdir+0x386>
  1039bb:	68 26 6d 10 00       	push   $0x106d26
  1039c0:	68 ad 6a 10 00       	push   $0x106aad
  1039c5:	68 27 02 00 00       	push   $0x227
  1039ca:	68 88 6a 10 00       	push   $0x106a88
  1039cf:	e8 fd c9 ff ff       	call   1003d1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1039d4:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1039d9:	83 ec 04             	sub    $0x4,%esp
  1039dc:	6a 00                	push   $0x0
  1039de:	68 00 10 00 00       	push   $0x1000
  1039e3:	50                   	push   %eax
  1039e4:	e8 ba f8 ff ff       	call   1032a3 <get_pte>
  1039e9:	83 c4 10             	add    $0x10,%esp
  1039ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039f3:	75 19                	jne    103a0e <check_pgdir+0x3c0>
  1039f5:	68 74 6c 10 00       	push   $0x106c74
  1039fa:	68 ad 6a 10 00       	push   $0x106aad
  1039ff:	68 28 02 00 00       	push   $0x228
  103a04:	68 88 6a 10 00       	push   $0x106a88
  103a09:	e8 c3 c9 ff ff       	call   1003d1 <__panic>
    assert(pa2page(*ptep) == p1);
  103a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a11:	8b 00                	mov    (%eax),%eax
  103a13:	83 ec 0c             	sub    $0xc,%esp
  103a16:	50                   	push   %eax
  103a17:	e8 f9 ee ff ff       	call   102915 <pa2page>
  103a1c:	83 c4 10             	add    $0x10,%esp
  103a1f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103a22:	74 19                	je     103a3d <check_pgdir+0x3ef>
  103a24:	68 ed 6b 10 00       	push   $0x106bed
  103a29:	68 ad 6a 10 00       	push   $0x106aad
  103a2e:	68 29 02 00 00       	push   $0x229
  103a33:	68 88 6a 10 00       	push   $0x106a88
  103a38:	e8 94 c9 ff ff       	call   1003d1 <__panic>
    assert((*ptep & PTE_U) == 0);
  103a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a40:	8b 00                	mov    (%eax),%eax
  103a42:	83 e0 04             	and    $0x4,%eax
  103a45:	85 c0                	test   %eax,%eax
  103a47:	74 19                	je     103a62 <check_pgdir+0x414>
  103a49:	68 38 6d 10 00       	push   $0x106d38
  103a4e:	68 ad 6a 10 00       	push   $0x106aad
  103a53:	68 2a 02 00 00       	push   $0x22a
  103a58:	68 88 6a 10 00       	push   $0x106a88
  103a5d:	e8 6f c9 ff ff       	call   1003d1 <__panic>

    page_remove(boot_pgdir, 0x0);
  103a62:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103a67:	83 ec 08             	sub    $0x8,%esp
  103a6a:	6a 00                	push   $0x0
  103a6c:	50                   	push   %eax
  103a6d:	e8 77 fa ff ff       	call   1034e9 <page_remove>
  103a72:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
  103a75:	83 ec 0c             	sub    $0xc,%esp
  103a78:	ff 75 f4             	pushl  -0xc(%ebp)
  103a7b:	e8 5b ef ff ff       	call   1029db <page_ref>
  103a80:	83 c4 10             	add    $0x10,%esp
  103a83:	83 f8 01             	cmp    $0x1,%eax
  103a86:	74 19                	je     103aa1 <check_pgdir+0x453>
  103a88:	68 02 6c 10 00       	push   $0x106c02
  103a8d:	68 ad 6a 10 00       	push   $0x106aad
  103a92:	68 2d 02 00 00       	push   $0x22d
  103a97:	68 88 6a 10 00       	push   $0x106a88
  103a9c:	e8 30 c9 ff ff       	call   1003d1 <__panic>
    assert(page_ref(p2) == 0);
  103aa1:	83 ec 0c             	sub    $0xc,%esp
  103aa4:	ff 75 e4             	pushl  -0x1c(%ebp)
  103aa7:	e8 2f ef ff ff       	call   1029db <page_ref>
  103aac:	83 c4 10             	add    $0x10,%esp
  103aaf:	85 c0                	test   %eax,%eax
  103ab1:	74 19                	je     103acc <check_pgdir+0x47e>
  103ab3:	68 26 6d 10 00       	push   $0x106d26
  103ab8:	68 ad 6a 10 00       	push   $0x106aad
  103abd:	68 2e 02 00 00       	push   $0x22e
  103ac2:	68 88 6a 10 00       	push   $0x106a88
  103ac7:	e8 05 c9 ff ff       	call   1003d1 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103acc:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103ad1:	83 ec 08             	sub    $0x8,%esp
  103ad4:	68 00 10 00 00       	push   $0x1000
  103ad9:	50                   	push   %eax
  103ada:	e8 0a fa ff ff       	call   1034e9 <page_remove>
  103adf:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
  103ae2:	83 ec 0c             	sub    $0xc,%esp
  103ae5:	ff 75 f4             	pushl  -0xc(%ebp)
  103ae8:	e8 ee ee ff ff       	call   1029db <page_ref>
  103aed:	83 c4 10             	add    $0x10,%esp
  103af0:	85 c0                	test   %eax,%eax
  103af2:	74 19                	je     103b0d <check_pgdir+0x4bf>
  103af4:	68 4d 6d 10 00       	push   $0x106d4d
  103af9:	68 ad 6a 10 00       	push   $0x106aad
  103afe:	68 31 02 00 00       	push   $0x231
  103b03:	68 88 6a 10 00       	push   $0x106a88
  103b08:	e8 c4 c8 ff ff       	call   1003d1 <__panic>
    assert(page_ref(p2) == 0);
  103b0d:	83 ec 0c             	sub    $0xc,%esp
  103b10:	ff 75 e4             	pushl  -0x1c(%ebp)
  103b13:	e8 c3 ee ff ff       	call   1029db <page_ref>
  103b18:	83 c4 10             	add    $0x10,%esp
  103b1b:	85 c0                	test   %eax,%eax
  103b1d:	74 19                	je     103b38 <check_pgdir+0x4ea>
  103b1f:	68 26 6d 10 00       	push   $0x106d26
  103b24:	68 ad 6a 10 00       	push   $0x106aad
  103b29:	68 32 02 00 00       	push   $0x232
  103b2e:	68 88 6a 10 00       	push   $0x106a88
  103b33:	e8 99 c8 ff ff       	call   1003d1 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  103b38:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103b3d:	8b 00                	mov    (%eax),%eax
  103b3f:	83 ec 0c             	sub    $0xc,%esp
  103b42:	50                   	push   %eax
  103b43:	e8 cd ed ff ff       	call   102915 <pa2page>
  103b48:	83 c4 10             	add    $0x10,%esp
  103b4b:	83 ec 0c             	sub    $0xc,%esp
  103b4e:	50                   	push   %eax
  103b4f:	e8 87 ee ff ff       	call   1029db <page_ref>
  103b54:	83 c4 10             	add    $0x10,%esp
  103b57:	83 f8 01             	cmp    $0x1,%eax
  103b5a:	74 19                	je     103b75 <check_pgdir+0x527>
  103b5c:	68 60 6d 10 00       	push   $0x106d60
  103b61:	68 ad 6a 10 00       	push   $0x106aad
  103b66:	68 34 02 00 00       	push   $0x234
  103b6b:	68 88 6a 10 00       	push   $0x106a88
  103b70:	e8 5c c8 ff ff       	call   1003d1 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  103b75:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103b7a:	8b 00                	mov    (%eax),%eax
  103b7c:	83 ec 0c             	sub    $0xc,%esp
  103b7f:	50                   	push   %eax
  103b80:	e8 90 ed ff ff       	call   102915 <pa2page>
  103b85:	83 c4 10             	add    $0x10,%esp
  103b88:	83 ec 08             	sub    $0x8,%esp
  103b8b:	6a 01                	push   $0x1
  103b8d:	50                   	push   %eax
  103b8e:	e8 86 f0 ff ff       	call   102c19 <free_pages>
  103b93:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103b96:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103b9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103ba1:	83 ec 0c             	sub    $0xc,%esp
  103ba4:	68 86 6d 10 00       	push   $0x106d86
  103ba9:	e8 bd c6 ff ff       	call   10026b <cprintf>
  103bae:	83 c4 10             	add    $0x10,%esp
}
  103bb1:	90                   	nop
  103bb2:	c9                   	leave  
  103bb3:	c3                   	ret    

00103bb4 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103bb4:	55                   	push   %ebp
  103bb5:	89 e5                	mov    %esp,%ebp
  103bb7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103bba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103bc1:	e9 a3 00 00 00       	jmp    103c69 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103bc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bcf:	c1 e8 0c             	shr    $0xc,%eax
  103bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103bd5:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  103bda:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103bdd:	72 17                	jb     103bf6 <check_boot_pgdir+0x42>
  103bdf:	ff 75 f0             	pushl  -0x10(%ebp)
  103be2:	68 c0 69 10 00       	push   $0x1069c0
  103be7:	68 40 02 00 00       	push   $0x240
  103bec:	68 88 6a 10 00       	push   $0x106a88
  103bf1:	e8 db c7 ff ff       	call   1003d1 <__panic>
  103bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bf9:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103bfe:	89 c2                	mov    %eax,%edx
  103c00:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103c05:	83 ec 04             	sub    $0x4,%esp
  103c08:	6a 00                	push   $0x0
  103c0a:	52                   	push   %edx
  103c0b:	50                   	push   %eax
  103c0c:	e8 92 f6 ff ff       	call   1032a3 <get_pte>
  103c11:	83 c4 10             	add    $0x10,%esp
  103c14:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103c17:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103c1b:	75 19                	jne    103c36 <check_boot_pgdir+0x82>
  103c1d:	68 a0 6d 10 00       	push   $0x106da0
  103c22:	68 ad 6a 10 00       	push   $0x106aad
  103c27:	68 40 02 00 00       	push   $0x240
  103c2c:	68 88 6a 10 00       	push   $0x106a88
  103c31:	e8 9b c7 ff ff       	call   1003d1 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103c36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103c39:	8b 00                	mov    (%eax),%eax
  103c3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103c40:	89 c2                	mov    %eax,%edx
  103c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c45:	39 c2                	cmp    %eax,%edx
  103c47:	74 19                	je     103c62 <check_boot_pgdir+0xae>
  103c49:	68 dd 6d 10 00       	push   $0x106ddd
  103c4e:	68 ad 6a 10 00       	push   $0x106aad
  103c53:	68 41 02 00 00       	push   $0x241
  103c58:	68 88 6a 10 00       	push   $0x106a88
  103c5d:	e8 6f c7 ff ff       	call   1003d1 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103c62:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103c69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103c6c:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  103c71:	39 c2                	cmp    %eax,%edx
  103c73:	0f 82 4d ff ff ff    	jb     103bc6 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103c79:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103c7e:	05 ac 0f 00 00       	add    $0xfac,%eax
  103c83:	8b 00                	mov    (%eax),%eax
  103c85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103c8a:	89 c2                	mov    %eax,%edx
  103c8c:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103c91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103c94:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  103c9b:	77 17                	ja     103cb4 <check_boot_pgdir+0x100>
  103c9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  103ca0:	68 64 6a 10 00       	push   $0x106a64
  103ca5:	68 44 02 00 00       	push   $0x244
  103caa:	68 88 6a 10 00       	push   $0x106a88
  103caf:	e8 1d c7 ff ff       	call   1003d1 <__panic>
  103cb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103cb7:	05 00 00 00 40       	add    $0x40000000,%eax
  103cbc:	39 c2                	cmp    %eax,%edx
  103cbe:	74 19                	je     103cd9 <check_boot_pgdir+0x125>
  103cc0:	68 f4 6d 10 00       	push   $0x106df4
  103cc5:	68 ad 6a 10 00       	push   $0x106aad
  103cca:	68 44 02 00 00       	push   $0x244
  103ccf:	68 88 6a 10 00       	push   $0x106a88
  103cd4:	e8 f8 c6 ff ff       	call   1003d1 <__panic>

    assert(boot_pgdir[0] == 0);
  103cd9:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103cde:	8b 00                	mov    (%eax),%eax
  103ce0:	85 c0                	test   %eax,%eax
  103ce2:	74 19                	je     103cfd <check_boot_pgdir+0x149>
  103ce4:	68 28 6e 10 00       	push   $0x106e28
  103ce9:	68 ad 6a 10 00       	push   $0x106aad
  103cee:	68 46 02 00 00       	push   $0x246
  103cf3:	68 88 6a 10 00       	push   $0x106a88
  103cf8:	e8 d4 c6 ff ff       	call   1003d1 <__panic>

    struct Page *p;
    p = alloc_page();
  103cfd:	83 ec 0c             	sub    $0xc,%esp
  103d00:	6a 01                	push   $0x1
  103d02:	e8 d4 ee ff ff       	call   102bdb <alloc_pages>
  103d07:	83 c4 10             	add    $0x10,%esp
  103d0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103d0d:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103d12:	6a 02                	push   $0x2
  103d14:	68 00 01 00 00       	push   $0x100
  103d19:	ff 75 e0             	pushl  -0x20(%ebp)
  103d1c:	50                   	push   %eax
  103d1d:	e8 00 f8 ff ff       	call   103522 <page_insert>
  103d22:	83 c4 10             	add    $0x10,%esp
  103d25:	85 c0                	test   %eax,%eax
  103d27:	74 19                	je     103d42 <check_boot_pgdir+0x18e>
  103d29:	68 3c 6e 10 00       	push   $0x106e3c
  103d2e:	68 ad 6a 10 00       	push   $0x106aad
  103d33:	68 4a 02 00 00       	push   $0x24a
  103d38:	68 88 6a 10 00       	push   $0x106a88
  103d3d:	e8 8f c6 ff ff       	call   1003d1 <__panic>
    assert(page_ref(p) == 1);
  103d42:	83 ec 0c             	sub    $0xc,%esp
  103d45:	ff 75 e0             	pushl  -0x20(%ebp)
  103d48:	e8 8e ec ff ff       	call   1029db <page_ref>
  103d4d:	83 c4 10             	add    $0x10,%esp
  103d50:	83 f8 01             	cmp    $0x1,%eax
  103d53:	74 19                	je     103d6e <check_boot_pgdir+0x1ba>
  103d55:	68 6a 6e 10 00       	push   $0x106e6a
  103d5a:	68 ad 6a 10 00       	push   $0x106aad
  103d5f:	68 4b 02 00 00       	push   $0x24b
  103d64:	68 88 6a 10 00       	push   $0x106a88
  103d69:	e8 63 c6 ff ff       	call   1003d1 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103d6e:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103d73:	6a 02                	push   $0x2
  103d75:	68 00 11 00 00       	push   $0x1100
  103d7a:	ff 75 e0             	pushl  -0x20(%ebp)
  103d7d:	50                   	push   %eax
  103d7e:	e8 9f f7 ff ff       	call   103522 <page_insert>
  103d83:	83 c4 10             	add    $0x10,%esp
  103d86:	85 c0                	test   %eax,%eax
  103d88:	74 19                	je     103da3 <check_boot_pgdir+0x1ef>
  103d8a:	68 7c 6e 10 00       	push   $0x106e7c
  103d8f:	68 ad 6a 10 00       	push   $0x106aad
  103d94:	68 4c 02 00 00       	push   $0x24c
  103d99:	68 88 6a 10 00       	push   $0x106a88
  103d9e:	e8 2e c6 ff ff       	call   1003d1 <__panic>
    assert(page_ref(p) == 2);
  103da3:	83 ec 0c             	sub    $0xc,%esp
  103da6:	ff 75 e0             	pushl  -0x20(%ebp)
  103da9:	e8 2d ec ff ff       	call   1029db <page_ref>
  103dae:	83 c4 10             	add    $0x10,%esp
  103db1:	83 f8 02             	cmp    $0x2,%eax
  103db4:	74 19                	je     103dcf <check_boot_pgdir+0x21b>
  103db6:	68 b3 6e 10 00       	push   $0x106eb3
  103dbb:	68 ad 6a 10 00       	push   $0x106aad
  103dc0:	68 4d 02 00 00       	push   $0x24d
  103dc5:	68 88 6a 10 00       	push   $0x106a88
  103dca:	e8 02 c6 ff ff       	call   1003d1 <__panic>

    const char *str = "ucore: Hello world!!";
  103dcf:	c7 45 dc c4 6e 10 00 	movl   $0x106ec4,-0x24(%ebp)
    strcpy((void *)0x100, str);
  103dd6:	83 ec 08             	sub    $0x8,%esp
  103dd9:	ff 75 dc             	pushl  -0x24(%ebp)
  103ddc:	68 00 01 00 00       	push   $0x100
  103de1:	e8 24 1a 00 00       	call   10580a <strcpy>
  103de6:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103de9:	83 ec 08             	sub    $0x8,%esp
  103dec:	68 00 11 00 00       	push   $0x1100
  103df1:	68 00 01 00 00       	push   $0x100
  103df6:	e8 89 1a 00 00       	call   105884 <strcmp>
  103dfb:	83 c4 10             	add    $0x10,%esp
  103dfe:	85 c0                	test   %eax,%eax
  103e00:	74 19                	je     103e1b <check_boot_pgdir+0x267>
  103e02:	68 dc 6e 10 00       	push   $0x106edc
  103e07:	68 ad 6a 10 00       	push   $0x106aad
  103e0c:	68 51 02 00 00       	push   $0x251
  103e11:	68 88 6a 10 00       	push   $0x106a88
  103e16:	e8 b6 c5 ff ff       	call   1003d1 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103e1b:	83 ec 0c             	sub    $0xc,%esp
  103e1e:	ff 75 e0             	pushl  -0x20(%ebp)
  103e21:	e8 36 eb ff ff       	call   10295c <page2kva>
  103e26:	83 c4 10             	add    $0x10,%esp
  103e29:	05 00 01 00 00       	add    $0x100,%eax
  103e2e:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103e31:	83 ec 0c             	sub    $0xc,%esp
  103e34:	68 00 01 00 00       	push   $0x100
  103e39:	e8 74 19 00 00       	call   1057b2 <strlen>
  103e3e:	83 c4 10             	add    $0x10,%esp
  103e41:	85 c0                	test   %eax,%eax
  103e43:	74 19                	je     103e5e <check_boot_pgdir+0x2aa>
  103e45:	68 14 6f 10 00       	push   $0x106f14
  103e4a:	68 ad 6a 10 00       	push   $0x106aad
  103e4f:	68 54 02 00 00       	push   $0x254
  103e54:	68 88 6a 10 00       	push   $0x106a88
  103e59:	e8 73 c5 ff ff       	call   1003d1 <__panic>

    free_page(p);
  103e5e:	83 ec 08             	sub    $0x8,%esp
  103e61:	6a 01                	push   $0x1
  103e63:	ff 75 e0             	pushl  -0x20(%ebp)
  103e66:	e8 ae ed ff ff       	call   102c19 <free_pages>
  103e6b:	83 c4 10             	add    $0x10,%esp
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  103e6e:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103e73:	8b 00                	mov    (%eax),%eax
  103e75:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e7a:	83 ec 0c             	sub    $0xc,%esp
  103e7d:	50                   	push   %eax
  103e7e:	e8 92 ea ff ff       	call   102915 <pa2page>
  103e83:	83 c4 10             	add    $0x10,%esp
  103e86:	83 ec 08             	sub    $0x8,%esp
  103e89:	6a 01                	push   $0x1
  103e8b:	50                   	push   %eax
  103e8c:	e8 88 ed ff ff       	call   102c19 <free_pages>
  103e91:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103e94:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  103e99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103e9f:	83 ec 0c             	sub    $0xc,%esp
  103ea2:	68 38 6f 10 00       	push   $0x106f38
  103ea7:	e8 bf c3 ff ff       	call   10026b <cprintf>
  103eac:	83 c4 10             	add    $0x10,%esp
}
  103eaf:	90                   	nop
  103eb0:	c9                   	leave  
  103eb1:	c3                   	ret    

00103eb2 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103eb2:	55                   	push   %ebp
  103eb3:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  103eb8:	83 e0 04             	and    $0x4,%eax
  103ebb:	85 c0                	test   %eax,%eax
  103ebd:	74 07                	je     103ec6 <perm2str+0x14>
  103ebf:	b8 75 00 00 00       	mov    $0x75,%eax
  103ec4:	eb 05                	jmp    103ecb <perm2str+0x19>
  103ec6:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103ecb:	a2 68 99 11 00       	mov    %al,0x119968
    str[1] = 'r';
  103ed0:	c6 05 69 99 11 00 72 	movb   $0x72,0x119969
    str[2] = (perm & PTE_W) ? 'w' : '-';
  103ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  103eda:	83 e0 02             	and    $0x2,%eax
  103edd:	85 c0                	test   %eax,%eax
  103edf:	74 07                	je     103ee8 <perm2str+0x36>
  103ee1:	b8 77 00 00 00       	mov    $0x77,%eax
  103ee6:	eb 05                	jmp    103eed <perm2str+0x3b>
  103ee8:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103eed:	a2 6a 99 11 00       	mov    %al,0x11996a
    str[3] = '\0';
  103ef2:	c6 05 6b 99 11 00 00 	movb   $0x0,0x11996b
    return str;
  103ef9:	b8 68 99 11 00       	mov    $0x119968,%eax
}
  103efe:	5d                   	pop    %ebp
  103eff:	c3                   	ret    

00103f00 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  103f00:	55                   	push   %ebp
  103f01:	89 e5                	mov    %esp,%ebp
  103f03:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  103f06:	8b 45 10             	mov    0x10(%ebp),%eax
  103f09:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103f0c:	72 0e                	jb     103f1c <get_pgtable_items+0x1c>
        return 0;
  103f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  103f13:	e9 9a 00 00 00       	jmp    103fb2 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  103f18:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  103f1c:	8b 45 10             	mov    0x10(%ebp),%eax
  103f1f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103f22:	73 18                	jae    103f3c <get_pgtable_items+0x3c>
  103f24:	8b 45 10             	mov    0x10(%ebp),%eax
  103f27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  103f31:	01 d0                	add    %edx,%eax
  103f33:	8b 00                	mov    (%eax),%eax
  103f35:	83 e0 01             	and    $0x1,%eax
  103f38:	85 c0                	test   %eax,%eax
  103f3a:	74 dc                	je     103f18 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
  103f3c:	8b 45 10             	mov    0x10(%ebp),%eax
  103f3f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103f42:	73 69                	jae    103fad <get_pgtable_items+0xad>
        if (left_store != NULL) {
  103f44:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  103f48:	74 08                	je     103f52 <get_pgtable_items+0x52>
            *left_store = start;
  103f4a:	8b 45 18             	mov    0x18(%ebp),%eax
  103f4d:	8b 55 10             	mov    0x10(%ebp),%edx
  103f50:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  103f52:	8b 45 10             	mov    0x10(%ebp),%eax
  103f55:	8d 50 01             	lea    0x1(%eax),%edx
  103f58:	89 55 10             	mov    %edx,0x10(%ebp)
  103f5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103f62:	8b 45 14             	mov    0x14(%ebp),%eax
  103f65:	01 d0                	add    %edx,%eax
  103f67:	8b 00                	mov    (%eax),%eax
  103f69:	83 e0 07             	and    $0x7,%eax
  103f6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  103f6f:	eb 04                	jmp    103f75 <get_pgtable_items+0x75>
            start ++;
  103f71:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  103f75:	8b 45 10             	mov    0x10(%ebp),%eax
  103f78:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103f7b:	73 1d                	jae    103f9a <get_pgtable_items+0x9a>
  103f7d:	8b 45 10             	mov    0x10(%ebp),%eax
  103f80:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103f87:	8b 45 14             	mov    0x14(%ebp),%eax
  103f8a:	01 d0                	add    %edx,%eax
  103f8c:	8b 00                	mov    (%eax),%eax
  103f8e:	83 e0 07             	and    $0x7,%eax
  103f91:	89 c2                	mov    %eax,%edx
  103f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f96:	39 c2                	cmp    %eax,%edx
  103f98:	74 d7                	je     103f71 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
  103f9a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103f9e:	74 08                	je     103fa8 <get_pgtable_items+0xa8>
            *right_store = start;
  103fa0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103fa3:	8b 55 10             	mov    0x10(%ebp),%edx
  103fa6:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  103fa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103fab:	eb 05                	jmp    103fb2 <get_pgtable_items+0xb2>
    }
    return 0;
  103fad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103fb2:	c9                   	leave  
  103fb3:	c3                   	ret    

00103fb4 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  103fb4:	55                   	push   %ebp
  103fb5:	89 e5                	mov    %esp,%ebp
  103fb7:	57                   	push   %edi
  103fb8:	56                   	push   %esi
  103fb9:	53                   	push   %ebx
  103fba:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  103fbd:	83 ec 0c             	sub    $0xc,%esp
  103fc0:	68 58 6f 10 00       	push   $0x106f58
  103fc5:	e8 a1 c2 ff ff       	call   10026b <cprintf>
  103fca:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
  103fcd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  103fd4:	e9 e5 00 00 00       	jmp    1040be <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  103fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103fdc:	83 ec 0c             	sub    $0xc,%esp
  103fdf:	50                   	push   %eax
  103fe0:	e8 cd fe ff ff       	call   103eb2 <perm2str>
  103fe5:	83 c4 10             	add    $0x10,%esp
  103fe8:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  103fea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ff0:	29 c2                	sub    %eax,%edx
  103ff2:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  103ff4:	c1 e0 16             	shl    $0x16,%eax
  103ff7:	89 c3                	mov    %eax,%ebx
  103ff9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ffc:	c1 e0 16             	shl    $0x16,%eax
  103fff:	89 c1                	mov    %eax,%ecx
  104001:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104004:	c1 e0 16             	shl    $0x16,%eax
  104007:	89 c2                	mov    %eax,%edx
  104009:	8b 75 dc             	mov    -0x24(%ebp),%esi
  10400c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10400f:	29 c6                	sub    %eax,%esi
  104011:	89 f0                	mov    %esi,%eax
  104013:	83 ec 08             	sub    $0x8,%esp
  104016:	57                   	push   %edi
  104017:	53                   	push   %ebx
  104018:	51                   	push   %ecx
  104019:	52                   	push   %edx
  10401a:	50                   	push   %eax
  10401b:	68 89 6f 10 00       	push   $0x106f89
  104020:	e8 46 c2 ff ff       	call   10026b <cprintf>
  104025:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  104028:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10402b:	c1 e0 0a             	shl    $0xa,%eax
  10402e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104031:	eb 4f                	jmp    104082 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104036:	83 ec 0c             	sub    $0xc,%esp
  104039:	50                   	push   %eax
  10403a:	e8 73 fe ff ff       	call   103eb2 <perm2str>
  10403f:	83 c4 10             	add    $0x10,%esp
  104042:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104044:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104047:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10404a:	29 c2                	sub    %eax,%edx
  10404c:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10404e:	c1 e0 0c             	shl    $0xc,%eax
  104051:	89 c3                	mov    %eax,%ebx
  104053:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104056:	c1 e0 0c             	shl    $0xc,%eax
  104059:	89 c1                	mov    %eax,%ecx
  10405b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10405e:	c1 e0 0c             	shl    $0xc,%eax
  104061:	89 c2                	mov    %eax,%edx
  104063:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  104066:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104069:	29 c6                	sub    %eax,%esi
  10406b:	89 f0                	mov    %esi,%eax
  10406d:	83 ec 08             	sub    $0x8,%esp
  104070:	57                   	push   %edi
  104071:	53                   	push   %ebx
  104072:	51                   	push   %ecx
  104073:	52                   	push   %edx
  104074:	50                   	push   %eax
  104075:	68 a8 6f 10 00       	push   $0x106fa8
  10407a:	e8 ec c1 ff ff       	call   10026b <cprintf>
  10407f:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104082:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  104087:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10408a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10408d:	89 d3                	mov    %edx,%ebx
  10408f:	c1 e3 0a             	shl    $0xa,%ebx
  104092:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104095:	89 d1                	mov    %edx,%ecx
  104097:	c1 e1 0a             	shl    $0xa,%ecx
  10409a:	83 ec 08             	sub    $0x8,%esp
  10409d:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1040a0:	52                   	push   %edx
  1040a1:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1040a4:	52                   	push   %edx
  1040a5:	56                   	push   %esi
  1040a6:	50                   	push   %eax
  1040a7:	53                   	push   %ebx
  1040a8:	51                   	push   %ecx
  1040a9:	e8 52 fe ff ff       	call   103f00 <get_pgtable_items>
  1040ae:	83 c4 20             	add    $0x20,%esp
  1040b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1040b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1040b8:	0f 85 75 ff ff ff    	jne    104033 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1040be:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1040c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1040c6:	83 ec 08             	sub    $0x8,%esp
  1040c9:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1040cc:	52                   	push   %edx
  1040cd:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1040d0:	52                   	push   %edx
  1040d1:	51                   	push   %ecx
  1040d2:	50                   	push   %eax
  1040d3:	68 00 04 00 00       	push   $0x400
  1040d8:	6a 00                	push   $0x0
  1040da:	e8 21 fe ff ff       	call   103f00 <get_pgtable_items>
  1040df:	83 c4 20             	add    $0x20,%esp
  1040e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1040e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1040e9:	0f 85 ea fe ff ff    	jne    103fd9 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1040ef:	83 ec 0c             	sub    $0xc,%esp
  1040f2:	68 cc 6f 10 00       	push   $0x106fcc
  1040f7:	e8 6f c1 ff ff       	call   10026b <cprintf>
  1040fc:	83 c4 10             	add    $0x10,%esp
}
  1040ff:	90                   	nop
  104100:	8d 65 f4             	lea    -0xc(%ebp),%esp
  104103:	5b                   	pop    %ebx
  104104:	5e                   	pop    %esi
  104105:	5f                   	pop    %edi
  104106:	5d                   	pop    %ebp
  104107:	c3                   	ret    

00104108 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  104108:	55                   	push   %ebp
  104109:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10410b:	8b 45 08             	mov    0x8(%ebp),%eax
  10410e:	8b 15 78 99 11 00    	mov    0x119978,%edx
  104114:	29 d0                	sub    %edx,%eax
  104116:	c1 f8 02             	sar    $0x2,%eax
  104119:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10411f:	5d                   	pop    %ebp
  104120:	c3                   	ret    

00104121 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  104121:	55                   	push   %ebp
  104122:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  104124:	ff 75 08             	pushl  0x8(%ebp)
  104127:	e8 dc ff ff ff       	call   104108 <page2ppn>
  10412c:	83 c4 04             	add    $0x4,%esp
  10412f:	c1 e0 0c             	shl    $0xc,%eax
}
  104132:	c9                   	leave  
  104133:	c3                   	ret    

00104134 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  104134:	55                   	push   %ebp
  104135:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104137:	8b 45 08             	mov    0x8(%ebp),%eax
  10413a:	8b 00                	mov    (%eax),%eax
}
  10413c:	5d                   	pop    %ebp
  10413d:	c3                   	ret    

0010413e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  10413e:	55                   	push   %ebp
  10413f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104141:	8b 45 08             	mov    0x8(%ebp),%eax
  104144:	8b 55 0c             	mov    0xc(%ebp),%edx
  104147:	89 10                	mov    %edx,(%eax)
}
  104149:	90                   	nop
  10414a:	5d                   	pop    %ebp
  10414b:	c3                   	ret    

0010414c <get_power>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)


static size_t get_power(size_t n){
  10414c:	55                   	push   %ebp
  10414d:	89 e5                	mov    %esp,%ebp
  10414f:	83 ec 10             	sub    $0x10,%esp
    for (size_t i = 0;;){
  104152:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        if((1 << i) <= n && (1 << ++i) > n ){
  104159:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10415c:	ba 01 00 00 00       	mov    $0x1,%edx
  104161:	89 c1                	mov    %eax,%ecx
  104163:	d3 e2                	shl    %cl,%edx
  104165:	89 d0                	mov    %edx,%eax
  104167:	3b 45 08             	cmp    0x8(%ebp),%eax
  10416a:	77 ed                	ja     104159 <get_power+0xd>
  10416c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  104170:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104173:	ba 01 00 00 00       	mov    $0x1,%edx
  104178:	89 c1                	mov    %eax,%ecx
  10417a:	d3 e2                	shl    %cl,%edx
  10417c:	89 d0                	mov    %edx,%eax
  10417e:	3b 45 08             	cmp    0x8(%ebp),%eax
  104181:	76 d6                	jbe    104159 <get_power+0xd>
            return (1 << --i);
  104183:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  104187:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10418a:	ba 01 00 00 00       	mov    $0x1,%edx
  10418f:	89 c1                	mov    %eax,%ecx
  104191:	d3 e2                	shl    %cl,%edx
  104193:	89 d0                	mov    %edx,%eax
  104195:	90                   	nop
        }
    }
}
  104196:	c9                   	leave  
  104197:	c3                   	ret    

00104198 <default_init>:

static void
default_init(void) {
  104198:	55                   	push   %ebp
  104199:	89 e5                	mov    %esp,%ebp
  10419b:	83 ec 10             	sub    $0x10,%esp
  10419e:	c7 45 fc 7c 99 11 00 	movl   $0x11997c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1041a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1041ab:	89 50 04             	mov    %edx,0x4(%eax)
  1041ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041b1:	8b 50 04             	mov    0x4(%eax),%edx
  1041b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041b7:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1041b9:	c7 05 84 99 11 00 00 	movl   $0x0,0x119984
  1041c0:	00 00 00 
}
  1041c3:	90                   	nop
  1041c4:	c9                   	leave  
  1041c5:	c3                   	ret    

001041c6 <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
  1041c6:	55                   	push   %ebp
  1041c7:	89 e5                	mov    %esp,%ebp
  1041c9:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1041cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1041d0:	75 16                	jne    1041e8 <buddy_init_memmap+0x22>
  1041d2:	68 00 70 10 00       	push   $0x107000
  1041d7:	68 06 70 10 00       	push   $0x107006
  1041dc:	6a 50                	push   $0x50
  1041de:	68 1b 70 10 00       	push   $0x10701b
  1041e3:	e8 e9 c1 ff ff       	call   1003d1 <__panic>
    struct Page *p = base;
  1041e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1041eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1041ee:	e9 a8 00 00 00       	jmp    10429b <buddy_init_memmap+0xd5>
        assert(PageReserved(p));
  1041f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041f6:	83 c0 04             	add    $0x4,%eax
  1041f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104200:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104203:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104206:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104209:	0f a3 10             	bt     %edx,(%eax)
  10420c:	19 c0                	sbb    %eax,%eax
  10420e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
  104211:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  104215:	0f 95 c0             	setne  %al
  104218:	0f b6 c0             	movzbl %al,%eax
  10421b:	85 c0                	test   %eax,%eax
  10421d:	75 16                	jne    104235 <buddy_init_memmap+0x6f>
  10421f:	68 31 70 10 00       	push   $0x107031
  104224:	68 06 70 10 00       	push   $0x107006
  104229:	6a 53                	push   $0x53
  10422b:	68 1b 70 10 00       	push   $0x10701b
  104230:	e8 9c c1 ff ff       	call   1003d1 <__panic>
        ClearPageReserved(p);       //flag : PG_reserve to 0 
  104235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104238:	83 c0 04             	add    $0x4,%eax
  10423b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  104242:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104245:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104248:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10424b:	0f b3 10             	btr    %edx,(%eax)
        SetPageProperty(p);         //flag : PG_property to 1
  10424e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104251:	83 c0 04             	add    $0x4,%eax
  104254:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  10425b:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10425e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104261:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104264:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;            //property
  104267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10426a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);         //ref
  104271:	83 ec 08             	sub    $0x8,%esp
  104274:	6a 00                	push   $0x0
  104276:	ff 75 f4             	pushl  -0xc(%ebp)
  104279:	e8 c0 fe ff ff       	call   10413e <set_page_ref>
  10427e:	83 c4 10             	add    $0x10,%esp
        memset(&(p->page_link), 0, sizeof(list_entry_t));
  104281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104284:	83 c0 0c             	add    $0xc,%eax
  104287:	83 ec 04             	sub    $0x4,%esp
  10428a:	6a 08                	push   $0x8
  10428c:	6a 00                	push   $0x0
  10428e:	50                   	push   %eax
  10428f:	e8 4f 18 00 00       	call   105ae3 <memset>
  104294:	83 c4 10             	add    $0x10,%esp

static void
buddy_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  104297:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10429b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10429e:	89 d0                	mov    %edx,%eax
  1042a0:	c1 e0 02             	shl    $0x2,%eax
  1042a3:	01 d0                	add    %edx,%eax
  1042a5:	c1 e0 02             	shl    $0x2,%eax
  1042a8:	89 c2                	mov    %eax,%edx
  1042aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1042ad:	01 d0                	add    %edx,%eax
  1042af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1042b2:	0f 85 3b ff ff ff    	jne    1041f3 <buddy_init_memmap+0x2d>
        p->property = 0;            //property
        set_page_ref(p, 0);         //ref
        memset(&(p->page_link), 0, sizeof(list_entry_t));
    }

    struct Page *page = NULL;
  1042b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    size_t power_num = 0;
  1042bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    while (n != 0){
  1042c6:	e9 a9 00 00 00       	jmp    104374 <buddy_init_memmap+0x1ae>
        power_num = get_power(n);
  1042cb:	83 ec 0c             	sub    $0xc,%esp
  1042ce:	ff 75 0c             	pushl  0xc(%ebp)
  1042d1:	e8 76 fe ff ff       	call   10414c <get_power>
  1042d6:	83 c4 10             	add    $0x10,%esp
  1042d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
        page = p + power_num;
  1042dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042df:	89 d0                	mov    %edx,%eax
  1042e1:	c1 e0 02             	shl    $0x2,%eax
  1042e4:	01 d0                	add    %edx,%eax
  1042e6:	c1 e0 02             	shl    $0x2,%eax
  1042e9:	89 c2                	mov    %eax,%edx
  1042eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042ee:	01 d0                	add    %edx,%eax
  1042f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        p->property = power_num;
  1042f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042f9:	89 50 08             	mov    %edx,0x8(%eax)
        n = page->property = nr_free - power_num;
  1042fc:	a1 84 99 11 00       	mov    0x119984,%eax
  104301:	2b 45 e0             	sub    -0x20(%ebp),%eax
  104304:	89 c2                	mov    %eax,%edx
  104306:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104309:	89 50 08             	mov    %edx,0x8(%eax)
  10430c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10430f:	8b 40 08             	mov    0x8(%eax),%eax
  104312:	89 45 0c             	mov    %eax,0xc(%ebp)
        
        list_add_after(&free_list, &(p->page_link));          //samll block to big block
  104315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104318:	83 c0 0c             	add    $0xc,%eax
  10431b:	c7 45 ec 7c 99 11 00 	movl   $0x11997c,-0x14(%ebp)
  104322:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104325:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104328:	8b 40 04             	mov    0x4(%eax),%eax
  10432b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10432e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104331:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104334:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104337:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10433a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10433d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104340:	89 10                	mov    %edx,(%eax)
  104342:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104345:	8b 10                	mov    (%eax),%edx
  104347:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10434a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10434d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104350:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104353:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104356:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104359:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10435c:	89 10                	mov    %edx,(%eax)
        p = page;
  10435e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104361:	89 45 f4             	mov    %eax,-0xc(%ebp)
        nr_free += power_num;
  104364:	8b 15 84 99 11 00    	mov    0x119984,%edx
  10436a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10436d:	01 d0                	add    %edx,%eax
  10436f:	a3 84 99 11 00       	mov    %eax,0x119984
        memset(&(p->page_link), 0, sizeof(list_entry_t));
    }

    struct Page *page = NULL;
    size_t power_num = 0;
    while (n != 0){
  104374:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104378:	0f 85 4d ff ff ff    	jne    1042cb <buddy_init_memmap+0x105>
        
        list_add_after(&free_list, &(p->page_link));          //samll block to big block
        p = page;
        nr_free += power_num;
    }
    return;
  10437e:	90                   	nop
}
  10437f:	c9                   	leave  
  104380:	c3                   	ret    

00104381 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  104381:	55                   	push   %ebp
  104382:	89 e5                	mov    %esp,%ebp
  104384:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  104387:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10438b:	75 16                	jne    1043a3 <default_init_memmap+0x22>
  10438d:	68 00 70 10 00       	push   $0x107000
  104392:	68 06 70 10 00       	push   $0x107006
  104397:	6a 6c                	push   $0x6c
  104399:	68 1b 70 10 00       	push   $0x10701b
  10439e:	e8 2e c0 ff ff       	call   1003d1 <__panic>
    struct Page *p = base;
  1043a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1043a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1043a9:	e9 a8 00 00 00       	jmp    104456 <default_init_memmap+0xd5>
        assert(PageReserved(p));
  1043ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043b1:	83 c0 04             	add    $0x4,%eax
  1043b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1043bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1043be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1043c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1043c4:	0f a3 10             	bt     %edx,(%eax)
  1043c7:	19 c0                	sbb    %eax,%eax
  1043c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
  1043cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1043d0:	0f 95 c0             	setne  %al
  1043d3:	0f b6 c0             	movzbl %al,%eax
  1043d6:	85 c0                	test   %eax,%eax
  1043d8:	75 16                	jne    1043f0 <default_init_memmap+0x6f>
  1043da:	68 31 70 10 00       	push   $0x107031
  1043df:	68 06 70 10 00       	push   $0x107006
  1043e4:	6a 6f                	push   $0x6f
  1043e6:	68 1b 70 10 00       	push   $0x10701b
  1043eb:	e8 e1 bf ff ff       	call   1003d1 <__panic>
        ClearPageReserved(p);       //flag : PG_reserve to 0 
  1043f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043f3:	83 c0 04             	add    $0x4,%eax
  1043f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1043fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104400:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104403:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104406:	0f b3 10             	btr    %edx,(%eax)
        SetPageProperty(p);         //flag : PG_property to 1
  104409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10440c:	83 c0 04             	add    $0x4,%eax
  10440f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  104416:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104419:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10441c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10441f:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;            //property
  104422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104425:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);         //ref
  10442c:	83 ec 08             	sub    $0x8,%esp
  10442f:	6a 00                	push   $0x0
  104431:	ff 75 f4             	pushl  -0xc(%ebp)
  104434:	e8 05 fd ff ff       	call   10413e <set_page_ref>
  104439:	83 c4 10             	add    $0x10,%esp
        memset(&(p->page_link), 0, sizeof(list_entry_t));
  10443c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10443f:	83 c0 0c             	add    $0xc,%eax
  104442:	83 ec 04             	sub    $0x4,%esp
  104445:	6a 08                	push   $0x8
  104447:	6a 00                	push   $0x0
  104449:	50                   	push   %eax
  10444a:	e8 94 16 00 00       	call   105ae3 <memset>
  10444f:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  104452:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104456:	8b 55 0c             	mov    0xc(%ebp),%edx
  104459:	89 d0                	mov    %edx,%eax
  10445b:	c1 e0 02             	shl    $0x2,%eax
  10445e:	01 d0                	add    %edx,%eax
  104460:	c1 e0 02             	shl    $0x2,%eax
  104463:	89 c2                	mov    %eax,%edx
  104465:	8b 45 08             	mov    0x8(%ebp),%eax
  104468:	01 d0                	add    %edx,%eax
  10446a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10446d:	0f 85 3b ff ff ff    	jne    1043ae <default_init_memmap+0x2d>
        SetPageProperty(p);         //flag : PG_property to 1
        p->property = 0;            //property
        set_page_ref(p, 0);         //ref
        memset(&(p->page_link), 0, sizeof(list_entry_t));
    }
    list_add_before(&free_list, &(base->page_link)); //lowAddr-->highAddr page
  104473:	8b 45 08             	mov    0x8(%ebp),%eax
  104476:	83 c0 0c             	add    $0xc,%eax
  104479:	c7 45 ec 7c 99 11 00 	movl   $0x11997c,-0x14(%ebp)
  104480:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104486:	8b 00                	mov    (%eax),%eax
  104488:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10448b:	89 55 cc             	mov    %edx,-0x34(%ebp)
  10448e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104491:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104494:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104497:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10449a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10449d:	89 10                	mov    %edx,(%eax)
  10449f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1044a2:	8b 10                	mov    (%eax),%edx
  1044a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1044a7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1044aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1044ad:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1044b0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1044b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1044b6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1044b9:	89 10                	mov    %edx,(%eax)
    base->property = n;
  1044bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1044be:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044c1:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  1044c4:	8b 15 84 99 11 00    	mov    0x119984,%edx
  1044ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044cd:	01 d0                	add    %edx,%eax
  1044cf:	a3 84 99 11 00       	mov    %eax,0x119984
    
    cprintf("nr_free : %d\n", nr_free);
  1044d4:	a1 84 99 11 00       	mov    0x119984,%eax
  1044d9:	83 ec 08             	sub    $0x8,%esp
  1044dc:	50                   	push   %eax
  1044dd:	68 41 70 10 00       	push   $0x107041
  1044e2:	e8 84 bd ff ff       	call   10026b <cprintf>
  1044e7:	83 c4 10             	add    $0x10,%esp
}
  1044ea:	90                   	nop
  1044eb:	c9                   	leave  
  1044ec:	c3                   	ret    

001044ed <buddy_alloc_pages>:

/*Buddy system*/
static struct Page *
buddy_alloc_pages(size_t n){
  1044ed:	55                   	push   %ebp
  1044ee:	89 e5                	mov    %esp,%ebp
  1044f0:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  1044f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1044f7:	75 19                	jne    104512 <buddy_alloc_pages+0x25>
  1044f9:	68 00 70 10 00       	push   $0x107000
  1044fe:	68 06 70 10 00       	push   $0x107006
  104503:	68 80 00 00 00       	push   $0x80
  104508:	68 1b 70 10 00       	push   $0x10701b
  10450d:	e8 bf be ff ff       	call   1003d1 <__panic>
    if (n > nr_free) return NULL;
  104512:	a1 84 99 11 00       	mov    0x119984,%eax
  104517:	3b 45 08             	cmp    0x8(%ebp),%eax
  10451a:	73 0a                	jae    104526 <buddy_alloc_pages+0x39>
  10451c:	b8 00 00 00 00       	mov    $0x0,%eax
  104521:	e9 8a 01 00 00       	jmp    1046b0 <buddy_alloc_pages+0x1c3>

    struct Page *page = NULL;
  104526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  10452d:	c7 45 f0 7c 99 11 00 	movl   $0x11997c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list){
  104534:	eb 1c                	jmp    104552 <buddy_alloc_pages+0x65>
        struct Page *p = le2page(le, page_link);
  104536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104539:	83 e8 0c             	sub    $0xc,%eax
  10453c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    
        if (p->property >= n){
  10453f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104542:	8b 40 08             	mov    0x8(%eax),%eax
  104545:	3b 45 08             	cmp    0x8(%ebp),%eax
  104548:	72 08                	jb     104552 <buddy_alloc_pages+0x65>
            page = p;
  10454a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10454d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  104550:	eb 18                	jmp    10456a <buddy_alloc_pages+0x7d>
  104552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104555:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104558:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10455b:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    if (n > nr_free) return NULL;

    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list){
  10455e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104561:	81 7d f0 7c 99 11 00 	cmpl   $0x11997c,-0x10(%ebp)
  104568:	75 cc                	jne    104536 <buddy_alloc_pages+0x49>
            page = p;
            break;
        }
    }

    if (page != NULL){
  10456a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10456e:	0f 84 39 01 00 00    	je     1046ad <buddy_alloc_pages+0x1c0>
        list_del(&(page->page_link));
  104574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104577:	83 c0 0c             	add    $0xc,%eax
  10457a:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  10457d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104580:	8b 40 04             	mov    0x4(%eax),%eax
  104583:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104586:	8b 12                	mov    (%edx),%edx
  104588:	89 55 cc             	mov    %edx,-0x34(%ebp)
  10458b:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  10458e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104591:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104594:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104597:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10459a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10459d:	89 10                	mov    %edx,(%eax)

        if (page->property == (n << 1)){
  10459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045a2:	8b 40 08             	mov    0x8(%eax),%eax
  1045a5:	8b 55 08             	mov    0x8(%ebp),%edx
  1045a8:	01 d2                	add    %edx,%edx
  1045aa:	39 d0                	cmp    %edx,%eax
  1045ac:	75 7c                	jne    10462a <buddy_alloc_pages+0x13d>
            struct Page *p = page + n;
  1045ae:	8b 55 08             	mov    0x8(%ebp),%edx
  1045b1:	89 d0                	mov    %edx,%eax
  1045b3:	c1 e0 02             	shl    $0x2,%eax
  1045b6:	01 d0                	add    %edx,%eax
  1045b8:	c1 e0 02             	shl    $0x2,%eax
  1045bb:	89 c2                	mov    %eax,%edx
  1045bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045c0:	01 d0                	add    %edx,%eax
  1045c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
            p->property = page->property - n;
  1045c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045c8:	8b 40 08             	mov    0x8(%eax),%eax
  1045cb:	2b 45 08             	sub    0x8(%ebp),%eax
  1045ce:	89 c2                	mov    %eax,%edx
  1045d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1045d3:	89 50 08             	mov    %edx,0x8(%eax)
            page->property = n;
  1045d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045d9:	8b 55 08             	mov    0x8(%ebp),%edx
  1045dc:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(page->page_link.prev, &(p->page_link));
  1045df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1045e2:	8d 50 0c             	lea    0xc(%eax),%edx
  1045e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045e8:	8b 40 0c             	mov    0xc(%eax),%eax
  1045eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1045ee:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1045f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045f4:	8b 40 04             	mov    0x4(%eax),%eax
  1045f7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1045fa:	89 55 c0             	mov    %edx,-0x40(%ebp)
  1045fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104600:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104603:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104606:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104609:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10460c:	89 10                	mov    %edx,(%eax)
  10460e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104611:	8b 10                	mov    (%eax),%edx
  104613:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104616:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104619:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10461c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  10461f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104622:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104625:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104628:	89 10                	mov    %edx,(%eax)
        }

        for (int looper = 0; looper < page->property; looper++){
  10462a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104631:	eb 58                	jmp    10468b <buddy_alloc_pages+0x19e>
            SetPageReserved(&(page[looper]));
  104633:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104636:	89 d0                	mov    %edx,%eax
  104638:	c1 e0 02             	shl    $0x2,%eax
  10463b:	01 d0                	add    %edx,%eax
  10463d:	c1 e0 02             	shl    $0x2,%eax
  104640:	89 c2                	mov    %eax,%edx
  104642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104645:	01 d0                	add    %edx,%eax
  104647:	83 c0 04             	add    $0x4,%eax
  10464a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  104651:	89 45 b0             	mov    %eax,-0x50(%ebp)
  104654:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104657:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10465a:	0f ab 10             	bts    %edx,(%eax)
            ClearPageProperty(&(page[looper]));
  10465d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104660:	89 d0                	mov    %edx,%eax
  104662:	c1 e0 02             	shl    $0x2,%eax
  104665:	01 d0                	add    %edx,%eax
  104667:	c1 e0 02             	shl    $0x2,%eax
  10466a:	89 c2                	mov    %eax,%edx
  10466c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10466f:	01 d0                	add    %edx,%eax
  104671:	83 c0 04             	add    $0x4,%eax
  104674:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  10467b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10467e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104681:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104684:	0f b3 10             	btr    %edx,(%eax)
            p->property = page->property - n;
            page->property = n;
            list_add_after(page->page_link.prev, &(p->page_link));
        }

        for (int looper = 0; looper < page->property; looper++){
  104687:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  10468b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10468e:	8b 50 08             	mov    0x8(%eax),%edx
  104691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104694:	39 c2                	cmp    %eax,%edx
  104696:	77 9b                	ja     104633 <buddy_alloc_pages+0x146>
            SetPageReserved(&(page[looper]));
            ClearPageProperty(&(page[looper]));
        }
        
        nr_free -= page->property;
  104698:	8b 15 84 99 11 00    	mov    0x119984,%edx
  10469e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a1:	8b 40 08             	mov    0x8(%eax),%eax
  1046a4:	29 c2                	sub    %eax,%edx
  1046a6:	89 d0                	mov    %edx,%eax
  1046a8:	a3 84 99 11 00       	mov    %eax,0x119984
    }

    return page;
  1046ad:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  1046b0:	c9                   	leave  
  1046b1:	c3                   	ret    

001046b2 <default_alloc_pages>:
/*first fit 返回PA*/
static struct Page *
default_alloc_pages(size_t n) {
  1046b2:	55                   	push   %ebp
  1046b3:	89 e5                	mov    %esp,%ebp
  1046b5:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  1046b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1046bc:	75 19                	jne    1046d7 <default_alloc_pages+0x25>
  1046be:	68 00 70 10 00       	push   $0x107000
  1046c3:	68 06 70 10 00       	push   $0x107006
  1046c8:	68 a6 00 00 00       	push   $0xa6
  1046cd:	68 1b 70 10 00       	push   $0x10701b
  1046d2:	e8 fa bc ff ff       	call   1003d1 <__panic>
    if (n > nr_free) {
  1046d7:	a1 84 99 11 00       	mov    0x119984,%eax
  1046dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  1046df:	73 0a                	jae    1046eb <default_alloc_pages+0x39>
        return NULL;
  1046e1:	b8 00 00 00 00       	mov    $0x0,%eax
  1046e6:	e9 79 01 00 00       	jmp    104864 <default_alloc_pages+0x1b2>
    }
    struct Page *page = NULL;
  1046eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1046f2:	c7 45 f0 7c 99 11 00 	movl   $0x11997c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1046f9:	eb 1c                	jmp    104717 <default_alloc_pages+0x65>
        struct Page *p = le2page(le, page_link);
  1046fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046fe:	83 e8 0c             	sub    $0xc,%eax
  104701:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n) {
  104704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104707:	8b 40 08             	mov    0x8(%eax),%eax
  10470a:	3b 45 08             	cmp    0x8(%ebp),%eax
  10470d:	72 08                	jb     104717 <default_alloc_pages+0x65>
            page = p;
  10470f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104712:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  104715:	eb 18                	jmp    10472f <default_alloc_pages+0x7d>
  104717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10471a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10471d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104720:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104723:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104726:	81 7d f0 7c 99 11 00 	cmpl   $0x11997c,-0x10(%ebp)
  10472d:	75 cc                	jne    1046fb <default_alloc_pages+0x49>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  10472f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104733:	0f 84 28 01 00 00    	je     104861 <default_alloc_pages+0x1af>
        list_del(&(page->page_link));
  104739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10473c:	83 c0 0c             	add    $0xc,%eax
  10473f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  104742:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104745:	8b 40 04             	mov    0x4(%eax),%eax
  104748:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10474b:	8b 12                	mov    (%edx),%edx
  10474d:	89 55 cc             	mov    %edx,-0x34(%ebp)
  104750:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104753:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104756:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104759:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10475c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10475f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104762:	89 10                	mov    %edx,(%eax)
       
        if (page->property > n) {
  104764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104767:	8b 40 08             	mov    0x8(%eax),%eax
  10476a:	3b 45 08             	cmp    0x8(%ebp),%eax
  10476d:	76 73                	jbe    1047e2 <default_alloc_pages+0x130>
            struct Page *p = page + n;
  10476f:	8b 55 08             	mov    0x8(%ebp),%edx
  104772:	89 d0                	mov    %edx,%eax
  104774:	c1 e0 02             	shl    $0x2,%eax
  104777:	01 d0                	add    %edx,%eax
  104779:	c1 e0 02             	shl    $0x2,%eax
  10477c:	89 c2                	mov    %eax,%edx
  10477e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104781:	01 d0                	add    %edx,%eax
  104783:	89 45 dc             	mov    %eax,-0x24(%ebp)
            p->property = page->property - n;
  104786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104789:	8b 40 08             	mov    0x8(%eax),%eax
  10478c:	2b 45 08             	sub    0x8(%ebp),%eax
  10478f:	89 c2                	mov    %eax,%edx
  104791:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104794:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(page->page_link.prev, &(p->page_link));
  104797:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10479a:	8d 50 0c             	lea    0xc(%eax),%edx
  10479d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047a0:	8b 40 0c             	mov    0xc(%eax),%eax
  1047a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1047a6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1047a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1047ac:	8b 40 04             	mov    0x4(%eax),%eax
  1047af:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1047b2:	89 55 c0             	mov    %edx,-0x40(%ebp)
  1047b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1047b8:	89 55 bc             	mov    %edx,-0x44(%ebp)
  1047bb:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1047be:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1047c1:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1047c4:	89 10                	mov    %edx,(%eax)
  1047c6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1047c9:	8b 10                	mov    (%eax),%edx
  1047cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1047ce:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1047d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1047d4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1047d7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1047da:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1047dd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1047e0:	89 10                	mov    %edx,(%eax)
        }
        
        page->property = n;
  1047e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047e5:	8b 55 08             	mov    0x8(%ebp),%edx
  1047e8:	89 50 08             	mov    %edx,0x8(%eax)
        for (int looper = 0; looper < n; looper++){
  1047eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1047f2:	eb 58                	jmp    10484c <default_alloc_pages+0x19a>
            SetPageReserved(&(page[looper]));
  1047f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1047f7:	89 d0                	mov    %edx,%eax
  1047f9:	c1 e0 02             	shl    $0x2,%eax
  1047fc:	01 d0                	add    %edx,%eax
  1047fe:	c1 e0 02             	shl    $0x2,%eax
  104801:	89 c2                	mov    %eax,%edx
  104803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104806:	01 d0                	add    %edx,%eax
  104808:	83 c0 04             	add    $0x4,%eax
  10480b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  104812:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104815:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10481b:	0f ab 10             	bts    %edx,(%eax)
            ClearPageProperty(&(page[looper]));
  10481e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104821:	89 d0                	mov    %edx,%eax
  104823:	c1 e0 02             	shl    $0x2,%eax
  104826:	01 d0                	add    %edx,%eax
  104828:	c1 e0 02             	shl    $0x2,%eax
  10482b:	89 c2                	mov    %eax,%edx
  10482d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104830:	01 d0                	add    %edx,%eax
  104832:	83 c0 04             	add    $0x4,%eax
  104835:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  10483c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10483f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104842:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104845:	0f b3 10             	btr    %edx,(%eax)
            p->property = page->property - n;
            list_add_after(page->page_link.prev, &(p->page_link));
        }
        
        page->property = n;
        for (int looper = 0; looper < n; looper++){
  104848:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  10484c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10484f:	3b 45 08             	cmp    0x8(%ebp),%eax
  104852:	72 a0                	jb     1047f4 <default_alloc_pages+0x142>
            SetPageReserved(&(page[looper]));
            ClearPageProperty(&(page[looper]));
            // page_ref_inc(&(page[looper]));
        }
        
        nr_free -= n;
  104854:	a1 84 99 11 00       	mov    0x119984,%eax
  104859:	2b 45 08             	sub    0x8(%ebp),%eax
  10485c:	a3 84 99 11 00       	mov    %eax,0x119984
    }
    return page;
  104861:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104864:	c9                   	leave  
  104865:	c3                   	ret    

00104866 <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n) {
  104866:	55                   	push   %ebp
  104867:	89 e5                	mov    %esp,%ebp
  104869:	83 ec 48             	sub    $0x48,%esp
    assert(n % 2 == 0);
  10486c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10486f:	83 e0 01             	and    $0x1,%eax
  104872:	85 c0                	test   %eax,%eax
  104874:	74 19                	je     10488f <buddy_free_pages+0x29>
  104876:	68 4f 70 10 00       	push   $0x10704f
  10487b:	68 06 70 10 00       	push   $0x107006
  104880:	68 ca 00 00 00       	push   $0xca
  104885:	68 1b 70 10 00       	push   $0x10701b
  10488a:	e8 42 bb ff ff       	call   1003d1 <__panic>
    struct Page *p = base;
  10488f:	8b 45 08             	mov    0x8(%ebp),%eax
  104892:	89 45 f4             	mov    %eax,-0xc(%ebp)

    for (; p != base + n; p ++) {
  104895:	e9 b7 00 00 00       	jmp    104951 <buddy_free_pages+0xeb>
        assert(PageReserved(p) && !PageProperty(p));
  10489a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10489d:	83 c0 04             	add    $0x4,%eax
  1048a0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  1048a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1048aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1048ad:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1048b0:	0f a3 10             	bt     %edx,(%eax)
  1048b3:	19 c0                	sbb    %eax,%eax
  1048b5:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1048b8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1048bc:	0f 95 c0             	setne  %al
  1048bf:	0f b6 c0             	movzbl %al,%eax
  1048c2:	85 c0                	test   %eax,%eax
  1048c4:	74 2c                	je     1048f2 <buddy_free_pages+0x8c>
  1048c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048c9:	83 c0 04             	add    $0x4,%eax
  1048cc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1048d3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1048d6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1048d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1048dc:	0f a3 10             	bt     %edx,(%eax)
  1048df:	19 c0                	sbb    %eax,%eax
  1048e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return oldbit != 0;
  1048e4:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  1048e8:	0f 95 c0             	setne  %al
  1048eb:	0f b6 c0             	movzbl %al,%eax
  1048ee:	85 c0                	test   %eax,%eax
  1048f0:	74 19                	je     10490b <buddy_free_pages+0xa5>
  1048f2:	68 5c 70 10 00       	push   $0x10705c
  1048f7:	68 06 70 10 00       	push   $0x107006
  1048fc:	68 ce 00 00 00       	push   $0xce
  104901:	68 1b 70 10 00       	push   $0x10701b
  104906:	e8 c6 ba ff ff       	call   1003d1 <__panic>
        SetPageProperty(p);
  10490b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10490e:	83 c0 04             	add    $0x4,%eax
  104911:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  104918:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10491b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10491e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104921:	0f ab 10             	bts    %edx,(%eax)
        ClearPageReserved(p);
  104924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104927:	83 c0 04             	add    $0x4,%eax
  10492a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  104931:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104934:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104937:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10493a:	0f b3 10             	btr    %edx,(%eax)
        set_page_ref(p, 0);
  10493d:	83 ec 08             	sub    $0x8,%esp
  104940:	6a 00                	push   $0x0
  104942:	ff 75 f4             	pushl  -0xc(%ebp)
  104945:	e8 f4 f7 ff ff       	call   10413e <set_page_ref>
  10494a:	83 c4 10             	add    $0x10,%esp
static void
buddy_free_pages(struct Page *base, size_t n) {
    assert(n % 2 == 0);
    struct Page *p = base;

    for (; p != base + n; p ++) {
  10494d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104951:	8b 55 0c             	mov    0xc(%ebp),%edx
  104954:	89 d0                	mov    %edx,%eax
  104956:	c1 e0 02             	shl    $0x2,%eax
  104959:	01 d0                	add    %edx,%eax
  10495b:	c1 e0 02             	shl    $0x2,%eax
  10495e:	89 c2                	mov    %eax,%edx
  104960:	8b 45 08             	mov    0x8(%ebp),%eax
  104963:	01 d0                	add    %edx,%eax
  104965:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104968:	0f 85 2c ff ff ff    	jne    10489a <buddy_free_pages+0x34>
        assert(PageReserved(p) && !PageProperty(p));
        SetPageProperty(p);
        ClearPageReserved(p);
        set_page_ref(p, 0);
    }
    base->property = n;
  10496e:	8b 45 08             	mov    0x8(%ebp),%eax
  104971:	8b 55 0c             	mov    0xc(%ebp),%edx
  104974:	89 50 08             	mov    %edx,0x8(%eax)
  104977:	c7 45 dc 7c 99 11 00 	movl   $0x11997c,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10497e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104981:	8b 40 04             	mov    0x4(%eax),%eax

    list_entry_t *le = list_next(&free_list);
  104984:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *last = NULL, *next = 0xFFFFFFFF;
  104987:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  10498e:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    while (le != &free_list) {
  104995:	eb 44                	jmp    1049db <buddy_free_pages+0x175>
        p = le2page(le, page_link);
  104997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10499a:	83 e8 0c             	sub    $0xc,%eax
  10499d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1049a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1049a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1049a9:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1049ac:	89 45 f0             	mov    %eax,-0x10(%ebp)

        if (p < base && p >= last ) last = p;
  1049af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  1049b5:	73 0e                	jae    1049c5 <buddy_free_pages+0x15f>
  1049b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1049bd:	72 06                	jb     1049c5 <buddy_free_pages+0x15f>
  1049bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p > base && p <= next) next = p;
  1049c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  1049cb:	76 0e                	jbe    1049db <buddy_free_pages+0x175>
  1049cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049d0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  1049d3:	77 06                	ja     1049db <buddy_free_pages+0x175>
  1049d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    }
    base->property = n;

    list_entry_t *le = list_next(&free_list);
    struct Page *last = NULL, *next = 0xFFFFFFFF;
    while (le != &free_list) {
  1049db:	81 7d f0 7c 99 11 00 	cmpl   $0x11997c,-0x10(%ebp)
  1049e2:	75 b3                	jne    104997 <buddy_free_pages+0x131>

        if (p < base && p >= last ) last = p;
        if (p > base && p <= next) next = p;
    }
    
}
  1049e4:	90                   	nop
  1049e5:	c9                   	leave  
  1049e6:	c3                   	ret    

001049e7 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  1049e7:	55                   	push   %ebp
  1049e8:	89 e5                	mov    %esp,%ebp
  1049ea:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    cprintf("   prev = %p,\n", base->page_link.prev);
    cprintf("   next = %p\n", base->page_link.next);
    cprintf("  },\n");
    cprintf("}\n");
#endif
    assert(n > 0);
  1049f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1049f4:	75 19                	jne    104a0f <default_free_pages+0x28>
  1049f6:	68 00 70 10 00       	push   $0x107000
  1049fb:	68 06 70 10 00       	push   $0x107006
  104a00:	68 ef 00 00 00       	push   $0xef
  104a05:	68 1b 70 10 00       	push   $0x10701b
  104a0a:	e8 c2 b9 ff ff       	call   1003d1 <__panic>
    struct Page *p = base;
  104a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  104a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104a15:	e9 b7 00 00 00       	jmp    104ad1 <default_free_pages+0xea>
        assert(PageReserved(p) && !PageProperty(p));
  104a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a1d:	83 c0 04             	add    $0x4,%eax
  104a20:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  104a27:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104a2a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104a2d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104a30:	0f a3 10             	bt     %edx,(%eax)
  104a33:	19 c0                	sbb    %eax,%eax
  104a35:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
  104a38:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  104a3c:	0f 95 c0             	setne  %al
  104a3f:	0f b6 c0             	movzbl %al,%eax
  104a42:	85 c0                	test   %eax,%eax
  104a44:	74 2c                	je     104a72 <default_free_pages+0x8b>
  104a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a49:	83 c0 04             	add    $0x4,%eax
  104a4c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  104a53:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104a56:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104a59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a5c:	0f a3 10             	bt     %edx,(%eax)
  104a5f:	19 c0                	sbb    %eax,%eax
  104a61:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
  104a64:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  104a68:	0f 95 c0             	setne  %al
  104a6b:	0f b6 c0             	movzbl %al,%eax
  104a6e:	85 c0                	test   %eax,%eax
  104a70:	74 19                	je     104a8b <default_free_pages+0xa4>
  104a72:	68 5c 70 10 00       	push   $0x10705c
  104a77:	68 06 70 10 00       	push   $0x107006
  104a7c:	68 f2 00 00 00       	push   $0xf2
  104a81:	68 1b 70 10 00       	push   $0x10701b
  104a86:	e8 46 b9 ff ff       	call   1003d1 <__panic>
        SetPageProperty(p);
  104a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a8e:	83 c0 04             	add    $0x4,%eax
  104a91:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  104a98:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104a9b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104a9e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104aa1:	0f ab 10             	bts    %edx,(%eax)
        ClearPageReserved(p);
  104aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104aa7:	83 c0 04             	add    $0x4,%eax
  104aaa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  104ab1:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104ab4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104ab7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104aba:	0f b3 10             	btr    %edx,(%eax)
        set_page_ref(p, 0);
  104abd:	83 ec 08             	sub    $0x8,%esp
  104ac0:	6a 00                	push   $0x0
  104ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  104ac5:	e8 74 f6 ff ff       	call   10413e <set_page_ref>
  104aca:	83 c4 10             	add    $0x10,%esp
    cprintf("  },\n");
    cprintf("}\n");
#endif
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  104acd:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  104ad4:	89 d0                	mov    %edx,%eax
  104ad6:	c1 e0 02             	shl    $0x2,%eax
  104ad9:	01 d0                	add    %edx,%eax
  104adb:	c1 e0 02             	shl    $0x2,%eax
  104ade:	89 c2                	mov    %eax,%edx
  104ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  104ae3:	01 d0                	add    %edx,%eax
  104ae5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104ae8:	0f 85 2c ff ff ff    	jne    104a1a <default_free_pages+0x33>
        assert(PageReserved(p) && !PageProperty(p));
        SetPageProperty(p);
        ClearPageReserved(p);
        set_page_ref(p, 0);
    }
    base->property = n;
  104aee:	8b 45 08             	mov    0x8(%ebp),%eax
  104af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  104af4:	89 50 08             	mov    %edx,0x8(%eax)
  104af7:	c7 45 dc 7c 99 11 00 	movl   $0x11997c,-0x24(%ebp)
  104afe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b01:	8b 40 04             	mov    0x4(%eax),%eax
    
    list_entry_t *le = list_next(&free_list);
  104b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *last = NULL, *next = 0xFFFFFFFF;
  104b07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104b0e:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    while (le != &free_list) {
  104b15:	eb 44                	jmp    104b5b <default_free_pages+0x174>
        p = le2page(le, page_link);
  104b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b1a:	83 e8 0c             	sub    $0xc,%eax
  104b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b23:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  104b26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104b29:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  104b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)

        if (p < base && p >= last ) last = p;
  104b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b32:	3b 45 08             	cmp    0x8(%ebp),%eax
  104b35:	73 0e                	jae    104b45 <default_free_pages+0x15e>
  104b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b3a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104b3d:	72 06                	jb     104b45 <default_free_pages+0x15e>
  104b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b42:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p > base && p <= next) next = p;
  104b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b48:	3b 45 08             	cmp    0x8(%ebp),%eax
  104b4b:	76 0e                	jbe    104b5b <default_free_pages+0x174>
  104b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b50:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  104b53:	77 06                	ja     104b5b <default_free_pages+0x174>
  104b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b58:	89 45 e8             	mov    %eax,-0x18(%ebp)
    }
    base->property = n;
    
    list_entry_t *le = list_next(&free_list);
    struct Page *last = NULL, *next = 0xFFFFFFFF;
    while (le != &free_list) {
  104b5b:	81 7d f0 7c 99 11 00 	cmpl   $0x11997c,-0x10(%ebp)
  104b62:	75 b3                	jne    104b17 <default_free_pages+0x130>

        if (p < base && p >= last ) last = p;
        if (p > base && p <= next) next = p;
    }

    if (last < base && last != NULL){
  104b64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b67:	3b 45 08             	cmp    0x8(%ebp),%eax
  104b6a:	0f 83 c0 00 00 00    	jae    104c30 <default_free_pages+0x249>
  104b70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104b74:	0f 84 b6 00 00 00    	je     104c30 <default_free_pages+0x249>
        list_add_after(&(last->page_link), &(base->page_link));
  104b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  104b7d:	83 c0 0c             	add    $0xc,%eax
  104b80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104b83:	83 c2 0c             	add    $0xc,%edx
  104b86:	89 55 d0             	mov    %edx,-0x30(%ebp)
  104b89:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104b8c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104b8f:	8b 40 04             	mov    0x4(%eax),%eax
  104b92:	8b 55 a0             	mov    -0x60(%ebp),%edx
  104b95:	89 55 9c             	mov    %edx,-0x64(%ebp)
  104b98:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104b9b:	89 55 98             	mov    %edx,-0x68(%ebp)
  104b9e:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104ba1:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104ba4:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104ba7:	89 10                	mov    %edx,(%eax)
  104ba9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104bac:	8b 10                	mov    (%eax),%edx
  104bae:	8b 45 98             	mov    -0x68(%ebp),%eax
  104bb1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104bb4:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104bb7:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104bba:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104bbd:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104bc0:	8b 55 98             	mov    -0x68(%ebp),%edx
  104bc3:	89 10                	mov    %edx,(%eax)
        if ((last + last->property) == base){
  104bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bc8:	8b 50 08             	mov    0x8(%eax),%edx
  104bcb:	89 d0                	mov    %edx,%eax
  104bcd:	c1 e0 02             	shl    $0x2,%eax
  104bd0:	01 d0                	add    %edx,%eax
  104bd2:	c1 e0 02             	shl    $0x2,%eax
  104bd5:	89 c2                	mov    %eax,%edx
  104bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bda:	01 d0                	add    %edx,%eax
  104bdc:	3b 45 08             	cmp    0x8(%ebp),%eax
  104bdf:	75 4f                	jne    104c30 <default_free_pages+0x249>
            last->property += base->property;
  104be1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104be4:	8b 50 08             	mov    0x8(%eax),%edx
  104be7:	8b 45 08             	mov    0x8(%ebp),%eax
  104bea:	8b 40 08             	mov    0x8(%eax),%eax
  104bed:	01 c2                	add    %eax,%edx
  104bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bf2:	89 50 08             	mov    %edx,0x8(%eax)
            list_del(&(base->page_link));
  104bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  104bf8:	83 c0 0c             	add    $0xc,%eax
  104bfb:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  104bfe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104c01:	8b 40 04             	mov    0x4(%eax),%eax
  104c04:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104c07:	8b 12                	mov    (%edx),%edx
  104c09:	89 55 90             	mov    %edx,-0x70(%ebp)
  104c0c:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104c0f:	8b 45 90             	mov    -0x70(%ebp),%eax
  104c12:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104c15:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104c18:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104c1b:	8b 55 90             	mov    -0x70(%ebp),%edx
  104c1e:	89 10                	mov    %edx,(%eax)
            base->property = 0;
  104c20:	8b 45 08             	mov    0x8(%ebp),%eax
  104c23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            base = last;
  104c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c2d:	89 45 08             	mov    %eax,0x8(%ebp)
        }
    }

    if (base < next && next != 0xFFFFFFFF){
  104c30:	8b 45 08             	mov    0x8(%ebp),%eax
  104c33:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  104c36:	0f 83 e5 00 00 00    	jae    104d21 <default_free_pages+0x33a>
  104c3c:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  104c40:	0f 84 db 00 00 00    	je     104d21 <default_free_pages+0x33a>
        if (last > base || last == NULL)
  104c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c49:	3b 45 08             	cmp    0x8(%ebp),%eax
  104c4c:	77 06                	ja     104c54 <default_free_pages+0x26d>
  104c4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104c52:	75 56                	jne    104caa <default_free_pages+0x2c3>
            list_add_before(&(next->page_link), &(base->page_link));
  104c54:	8b 45 08             	mov    0x8(%ebp),%eax
  104c57:	83 c0 0c             	add    $0xc,%eax
  104c5a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104c5d:	83 c2 0c             	add    $0xc,%edx
  104c60:	89 55 c8             	mov    %edx,-0x38(%ebp)
  104c63:	89 45 88             	mov    %eax,-0x78(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104c66:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104c69:	8b 00                	mov    (%eax),%eax
  104c6b:	8b 55 88             	mov    -0x78(%ebp),%edx
  104c6e:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104c71:	89 45 80             	mov    %eax,-0x80(%ebp)
  104c74:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104c77:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104c7d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  104c83:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104c86:	89 10                	mov    %edx,(%eax)
  104c88:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  104c8e:	8b 10                	mov    (%eax),%edx
  104c90:	8b 45 80             	mov    -0x80(%ebp),%eax
  104c93:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104c96:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104c99:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  104c9f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104ca2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104ca5:	8b 55 80             	mov    -0x80(%ebp),%edx
  104ca8:	89 10                	mov    %edx,(%eax)
        if ((base + base->property) == next){
  104caa:	8b 45 08             	mov    0x8(%ebp),%eax
  104cad:	8b 50 08             	mov    0x8(%eax),%edx
  104cb0:	89 d0                	mov    %edx,%eax
  104cb2:	c1 e0 02             	shl    $0x2,%eax
  104cb5:	01 d0                	add    %edx,%eax
  104cb7:	c1 e0 02             	shl    $0x2,%eax
  104cba:	89 c2                	mov    %eax,%edx
  104cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  104cbf:	01 d0                	add    %edx,%eax
  104cc1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  104cc4:	75 5b                	jne    104d21 <default_free_pages+0x33a>
            base->property += next->property;
  104cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  104cc9:	8b 50 08             	mov    0x8(%eax),%edx
  104ccc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ccf:	8b 40 08             	mov    0x8(%eax),%eax
  104cd2:	01 c2                	add    %eax,%edx
  104cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  104cd7:	89 50 08             	mov    %edx,0x8(%eax)
            list_del(&(next->page_link));
  104cda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104cdd:	83 c0 0c             	add    $0xc,%eax
  104ce0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  104ce3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104ce6:	8b 40 04             	mov    0x4(%eax),%eax
  104ce9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104cec:	8b 12                	mov    (%edx),%edx
  104cee:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
  104cf4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104cfa:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  104d00:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  104d06:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104d09:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  104d0f:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  104d15:	89 10                	mov    %edx,(%eax)
            next->property = 0;
  104d17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104d1a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        }
    }

    if (last == NULL && next == 0xFFFFFFFF){
  104d21:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104d25:	75 76                	jne    104d9d <default_free_pages+0x3b6>
  104d27:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  104d2b:	75 70                	jne    104d9d <default_free_pages+0x3b6>
        list_add_after(&free_list, &(base->page_link));
  104d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  104d30:	83 c0 0c             	add    $0xc,%eax
  104d33:	c7 45 c0 7c 99 11 00 	movl   $0x11997c,-0x40(%ebp)
  104d3a:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104d40:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104d43:	8b 40 04             	mov    0x4(%eax),%eax
  104d46:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  104d4c:	89 95 6c ff ff ff    	mov    %edx,-0x94(%ebp)
  104d52:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104d55:	89 95 68 ff ff ff    	mov    %edx,-0x98(%ebp)
  104d5b:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104d61:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  104d67:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  104d6d:	89 10                	mov    %edx,(%eax)
  104d6f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  104d75:	8b 10                	mov    (%eax),%edx
  104d77:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  104d7d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104d80:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  104d86:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  104d8c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104d8f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  104d95:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
  104d9b:	89 10                	mov    %edx,(%eax)
    }
    
    nr_free += n;
  104d9d:	8b 15 84 99 11 00    	mov    0x119984,%edx
  104da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  104da6:	01 d0                	add    %edx,%eax
  104da8:	a3 84 99 11 00       	mov    %eax,0x119984
}
  104dad:	90                   	nop
  104dae:	c9                   	leave  
  104daf:	c3                   	ret    

00104db0 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104db0:	55                   	push   %ebp
  104db1:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104db3:	a1 84 99 11 00       	mov    0x119984,%eax
}
  104db8:	5d                   	pop    %ebp
  104db9:	c3                   	ret    

00104dba <basic_check>:

static void
basic_check(void) {
  104dba:	55                   	push   %ebp
  104dbb:	89 e5                	mov    %esp,%ebp
  104dbd:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104dd3:	83 ec 0c             	sub    $0xc,%esp
  104dd6:	6a 01                	push   $0x1
  104dd8:	e8 fe dd ff ff       	call   102bdb <alloc_pages>
  104ddd:	83 c4 10             	add    $0x10,%esp
  104de0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104de3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104de7:	75 19                	jne    104e02 <basic_check+0x48>
  104de9:	68 80 70 10 00       	push   $0x107080
  104dee:	68 06 70 10 00       	push   $0x107006
  104df3:	68 27 01 00 00       	push   $0x127
  104df8:	68 1b 70 10 00       	push   $0x10701b
  104dfd:	e8 cf b5 ff ff       	call   1003d1 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104e02:	83 ec 0c             	sub    $0xc,%esp
  104e05:	6a 01                	push   $0x1
  104e07:	e8 cf dd ff ff       	call   102bdb <alloc_pages>
  104e0c:	83 c4 10             	add    $0x10,%esp
  104e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104e16:	75 19                	jne    104e31 <basic_check+0x77>
  104e18:	68 9c 70 10 00       	push   $0x10709c
  104e1d:	68 06 70 10 00       	push   $0x107006
  104e22:	68 28 01 00 00       	push   $0x128
  104e27:	68 1b 70 10 00       	push   $0x10701b
  104e2c:	e8 a0 b5 ff ff       	call   1003d1 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104e31:	83 ec 0c             	sub    $0xc,%esp
  104e34:	6a 01                	push   $0x1
  104e36:	e8 a0 dd ff ff       	call   102bdb <alloc_pages>
  104e3b:	83 c4 10             	add    $0x10,%esp
  104e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104e41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104e45:	75 19                	jne    104e60 <basic_check+0xa6>
  104e47:	68 b8 70 10 00       	push   $0x1070b8
  104e4c:	68 06 70 10 00       	push   $0x107006
  104e51:	68 29 01 00 00       	push   $0x129
  104e56:	68 1b 70 10 00       	push   $0x10701b
  104e5b:	e8 71 b5 ff ff       	call   1003d1 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e63:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104e66:	74 10                	je     104e78 <basic_check+0xbe>
  104e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e6b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104e6e:	74 08                	je     104e78 <basic_check+0xbe>
  104e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e73:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104e76:	75 19                	jne    104e91 <basic_check+0xd7>
  104e78:	68 d4 70 10 00       	push   $0x1070d4
  104e7d:	68 06 70 10 00       	push   $0x107006
  104e82:	68 2b 01 00 00       	push   $0x12b
  104e87:	68 1b 70 10 00       	push   $0x10701b
  104e8c:	e8 40 b5 ff ff       	call   1003d1 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104e91:	83 ec 0c             	sub    $0xc,%esp
  104e94:	ff 75 ec             	pushl  -0x14(%ebp)
  104e97:	e8 98 f2 ff ff       	call   104134 <page_ref>
  104e9c:	83 c4 10             	add    $0x10,%esp
  104e9f:	85 c0                	test   %eax,%eax
  104ea1:	75 24                	jne    104ec7 <basic_check+0x10d>
  104ea3:	83 ec 0c             	sub    $0xc,%esp
  104ea6:	ff 75 f0             	pushl  -0x10(%ebp)
  104ea9:	e8 86 f2 ff ff       	call   104134 <page_ref>
  104eae:	83 c4 10             	add    $0x10,%esp
  104eb1:	85 c0                	test   %eax,%eax
  104eb3:	75 12                	jne    104ec7 <basic_check+0x10d>
  104eb5:	83 ec 0c             	sub    $0xc,%esp
  104eb8:	ff 75 f4             	pushl  -0xc(%ebp)
  104ebb:	e8 74 f2 ff ff       	call   104134 <page_ref>
  104ec0:	83 c4 10             	add    $0x10,%esp
  104ec3:	85 c0                	test   %eax,%eax
  104ec5:	74 19                	je     104ee0 <basic_check+0x126>
  104ec7:	68 f8 70 10 00       	push   $0x1070f8
  104ecc:	68 06 70 10 00       	push   $0x107006
  104ed1:	68 2c 01 00 00       	push   $0x12c
  104ed6:	68 1b 70 10 00       	push   $0x10701b
  104edb:	e8 f1 b4 ff ff       	call   1003d1 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104ee0:	83 ec 0c             	sub    $0xc,%esp
  104ee3:	ff 75 ec             	pushl  -0x14(%ebp)
  104ee6:	e8 36 f2 ff ff       	call   104121 <page2pa>
  104eeb:	83 c4 10             	add    $0x10,%esp
  104eee:	89 c2                	mov    %eax,%edx
  104ef0:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  104ef5:	c1 e0 0c             	shl    $0xc,%eax
  104ef8:	39 c2                	cmp    %eax,%edx
  104efa:	72 19                	jb     104f15 <basic_check+0x15b>
  104efc:	68 34 71 10 00       	push   $0x107134
  104f01:	68 06 70 10 00       	push   $0x107006
  104f06:	68 2e 01 00 00       	push   $0x12e
  104f0b:	68 1b 70 10 00       	push   $0x10701b
  104f10:	e8 bc b4 ff ff       	call   1003d1 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104f15:	83 ec 0c             	sub    $0xc,%esp
  104f18:	ff 75 f0             	pushl  -0x10(%ebp)
  104f1b:	e8 01 f2 ff ff       	call   104121 <page2pa>
  104f20:	83 c4 10             	add    $0x10,%esp
  104f23:	89 c2                	mov    %eax,%edx
  104f25:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  104f2a:	c1 e0 0c             	shl    $0xc,%eax
  104f2d:	39 c2                	cmp    %eax,%edx
  104f2f:	72 19                	jb     104f4a <basic_check+0x190>
  104f31:	68 51 71 10 00       	push   $0x107151
  104f36:	68 06 70 10 00       	push   $0x107006
  104f3b:	68 2f 01 00 00       	push   $0x12f
  104f40:	68 1b 70 10 00       	push   $0x10701b
  104f45:	e8 87 b4 ff ff       	call   1003d1 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104f4a:	83 ec 0c             	sub    $0xc,%esp
  104f4d:	ff 75 f4             	pushl  -0xc(%ebp)
  104f50:	e8 cc f1 ff ff       	call   104121 <page2pa>
  104f55:	83 c4 10             	add    $0x10,%esp
  104f58:	89 c2                	mov    %eax,%edx
  104f5a:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  104f5f:	c1 e0 0c             	shl    $0xc,%eax
  104f62:	39 c2                	cmp    %eax,%edx
  104f64:	72 19                	jb     104f7f <basic_check+0x1c5>
  104f66:	68 6e 71 10 00       	push   $0x10716e
  104f6b:	68 06 70 10 00       	push   $0x107006
  104f70:	68 30 01 00 00       	push   $0x130
  104f75:	68 1b 70 10 00       	push   $0x10701b
  104f7a:	e8 52 b4 ff ff       	call   1003d1 <__panic>

    list_entry_t free_list_store = free_list;
  104f7f:	a1 7c 99 11 00       	mov    0x11997c,%eax
  104f84:	8b 15 80 99 11 00    	mov    0x119980,%edx
  104f8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104f8d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104f90:	c7 45 e4 7c 99 11 00 	movl   $0x11997c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104f9d:	89 50 04             	mov    %edx,0x4(%eax)
  104fa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fa3:	8b 50 04             	mov    0x4(%eax),%edx
  104fa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fa9:	89 10                	mov    %edx,(%eax)
  104fab:	c7 45 d8 7c 99 11 00 	movl   $0x11997c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104fb2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104fb5:	8b 40 04             	mov    0x4(%eax),%eax
  104fb8:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104fbb:	0f 94 c0             	sete   %al
  104fbe:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104fc1:	85 c0                	test   %eax,%eax
  104fc3:	75 19                	jne    104fde <basic_check+0x224>
  104fc5:	68 8b 71 10 00       	push   $0x10718b
  104fca:	68 06 70 10 00       	push   $0x107006
  104fcf:	68 34 01 00 00       	push   $0x134
  104fd4:	68 1b 70 10 00       	push   $0x10701b
  104fd9:	e8 f3 b3 ff ff       	call   1003d1 <__panic>

    unsigned int nr_free_store = nr_free;
  104fde:	a1 84 99 11 00       	mov    0x119984,%eax
  104fe3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  104fe6:	c7 05 84 99 11 00 00 	movl   $0x0,0x119984
  104fed:	00 00 00 

    assert(alloc_page() == NULL);
  104ff0:	83 ec 0c             	sub    $0xc,%esp
  104ff3:	6a 01                	push   $0x1
  104ff5:	e8 e1 db ff ff       	call   102bdb <alloc_pages>
  104ffa:	83 c4 10             	add    $0x10,%esp
  104ffd:	85 c0                	test   %eax,%eax
  104fff:	74 19                	je     10501a <basic_check+0x260>
  105001:	68 a2 71 10 00       	push   $0x1071a2
  105006:	68 06 70 10 00       	push   $0x107006
  10500b:	68 39 01 00 00       	push   $0x139
  105010:	68 1b 70 10 00       	push   $0x10701b
  105015:	e8 b7 b3 ff ff       	call   1003d1 <__panic>

    free_page(p0);
  10501a:	83 ec 08             	sub    $0x8,%esp
  10501d:	6a 01                	push   $0x1
  10501f:	ff 75 ec             	pushl  -0x14(%ebp)
  105022:	e8 f2 db ff ff       	call   102c19 <free_pages>
  105027:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  10502a:	83 ec 08             	sub    $0x8,%esp
  10502d:	6a 01                	push   $0x1
  10502f:	ff 75 f0             	pushl  -0x10(%ebp)
  105032:	e8 e2 db ff ff       	call   102c19 <free_pages>
  105037:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  10503a:	83 ec 08             	sub    $0x8,%esp
  10503d:	6a 01                	push   $0x1
  10503f:	ff 75 f4             	pushl  -0xc(%ebp)
  105042:	e8 d2 db ff ff       	call   102c19 <free_pages>
  105047:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
  10504a:	a1 84 99 11 00       	mov    0x119984,%eax
  10504f:	83 f8 03             	cmp    $0x3,%eax
  105052:	74 19                	je     10506d <basic_check+0x2b3>
  105054:	68 b7 71 10 00       	push   $0x1071b7
  105059:	68 06 70 10 00       	push   $0x107006
  10505e:	68 3e 01 00 00       	push   $0x13e
  105063:	68 1b 70 10 00       	push   $0x10701b
  105068:	e8 64 b3 ff ff       	call   1003d1 <__panic>

    assert((p0 = alloc_page()) != NULL);
  10506d:	83 ec 0c             	sub    $0xc,%esp
  105070:	6a 01                	push   $0x1
  105072:	e8 64 db ff ff       	call   102bdb <alloc_pages>
  105077:	83 c4 10             	add    $0x10,%esp
  10507a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10507d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  105081:	75 19                	jne    10509c <basic_check+0x2e2>
  105083:	68 80 70 10 00       	push   $0x107080
  105088:	68 06 70 10 00       	push   $0x107006
  10508d:	68 40 01 00 00       	push   $0x140
  105092:	68 1b 70 10 00       	push   $0x10701b
  105097:	e8 35 b3 ff ff       	call   1003d1 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10509c:	83 ec 0c             	sub    $0xc,%esp
  10509f:	6a 01                	push   $0x1
  1050a1:	e8 35 db ff ff       	call   102bdb <alloc_pages>
  1050a6:	83 c4 10             	add    $0x10,%esp
  1050a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1050ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1050b0:	75 19                	jne    1050cb <basic_check+0x311>
  1050b2:	68 9c 70 10 00       	push   $0x10709c
  1050b7:	68 06 70 10 00       	push   $0x107006
  1050bc:	68 41 01 00 00       	push   $0x141
  1050c1:	68 1b 70 10 00       	push   $0x10701b
  1050c6:	e8 06 b3 ff ff       	call   1003d1 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1050cb:	83 ec 0c             	sub    $0xc,%esp
  1050ce:	6a 01                	push   $0x1
  1050d0:	e8 06 db ff ff       	call   102bdb <alloc_pages>
  1050d5:	83 c4 10             	add    $0x10,%esp
  1050d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1050db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1050df:	75 19                	jne    1050fa <basic_check+0x340>
  1050e1:	68 b8 70 10 00       	push   $0x1070b8
  1050e6:	68 06 70 10 00       	push   $0x107006
  1050eb:	68 42 01 00 00       	push   $0x142
  1050f0:	68 1b 70 10 00       	push   $0x10701b
  1050f5:	e8 d7 b2 ff ff       	call   1003d1 <__panic>

    assert(alloc_page() == NULL);
  1050fa:	83 ec 0c             	sub    $0xc,%esp
  1050fd:	6a 01                	push   $0x1
  1050ff:	e8 d7 da ff ff       	call   102bdb <alloc_pages>
  105104:	83 c4 10             	add    $0x10,%esp
  105107:	85 c0                	test   %eax,%eax
  105109:	74 19                	je     105124 <basic_check+0x36a>
  10510b:	68 a2 71 10 00       	push   $0x1071a2
  105110:	68 06 70 10 00       	push   $0x107006
  105115:	68 44 01 00 00       	push   $0x144
  10511a:	68 1b 70 10 00       	push   $0x10701b
  10511f:	e8 ad b2 ff ff       	call   1003d1 <__panic>

    free_page(p0);
  105124:	83 ec 08             	sub    $0x8,%esp
  105127:	6a 01                	push   $0x1
  105129:	ff 75 ec             	pushl  -0x14(%ebp)
  10512c:	e8 e8 da ff ff       	call   102c19 <free_pages>
  105131:	83 c4 10             	add    $0x10,%esp
  105134:	c7 45 e8 7c 99 11 00 	movl   $0x11997c,-0x18(%ebp)
  10513b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10513e:	8b 40 04             	mov    0x4(%eax),%eax
  105141:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105144:	0f 94 c0             	sete   %al
  105147:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10514a:	85 c0                	test   %eax,%eax
  10514c:	74 19                	je     105167 <basic_check+0x3ad>
  10514e:	68 c4 71 10 00       	push   $0x1071c4
  105153:	68 06 70 10 00       	push   $0x107006
  105158:	68 47 01 00 00       	push   $0x147
  10515d:	68 1b 70 10 00       	push   $0x10701b
  105162:	e8 6a b2 ff ff       	call   1003d1 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  105167:	83 ec 0c             	sub    $0xc,%esp
  10516a:	6a 01                	push   $0x1
  10516c:	e8 6a da ff ff       	call   102bdb <alloc_pages>
  105171:	83 c4 10             	add    $0x10,%esp
  105174:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105177:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10517a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10517d:	74 19                	je     105198 <basic_check+0x3de>
  10517f:	68 dc 71 10 00       	push   $0x1071dc
  105184:	68 06 70 10 00       	push   $0x107006
  105189:	68 4a 01 00 00       	push   $0x14a
  10518e:	68 1b 70 10 00       	push   $0x10701b
  105193:	e8 39 b2 ff ff       	call   1003d1 <__panic>
    assert(alloc_page() == NULL);
  105198:	83 ec 0c             	sub    $0xc,%esp
  10519b:	6a 01                	push   $0x1
  10519d:	e8 39 da ff ff       	call   102bdb <alloc_pages>
  1051a2:	83 c4 10             	add    $0x10,%esp
  1051a5:	85 c0                	test   %eax,%eax
  1051a7:	74 19                	je     1051c2 <basic_check+0x408>
  1051a9:	68 a2 71 10 00       	push   $0x1071a2
  1051ae:	68 06 70 10 00       	push   $0x107006
  1051b3:	68 4b 01 00 00       	push   $0x14b
  1051b8:	68 1b 70 10 00       	push   $0x10701b
  1051bd:	e8 0f b2 ff ff       	call   1003d1 <__panic>

    assert(nr_free == 0);
  1051c2:	a1 84 99 11 00       	mov    0x119984,%eax
  1051c7:	85 c0                	test   %eax,%eax
  1051c9:	74 19                	je     1051e4 <basic_check+0x42a>
  1051cb:	68 f5 71 10 00       	push   $0x1071f5
  1051d0:	68 06 70 10 00       	push   $0x107006
  1051d5:	68 4d 01 00 00       	push   $0x14d
  1051da:	68 1b 70 10 00       	push   $0x10701b
  1051df:	e8 ed b1 ff ff       	call   1003d1 <__panic>
    free_list = free_list_store;
  1051e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1051e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1051ea:	a3 7c 99 11 00       	mov    %eax,0x11997c
  1051ef:	89 15 80 99 11 00    	mov    %edx,0x119980
    nr_free = nr_free_store;
  1051f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051f8:	a3 84 99 11 00       	mov    %eax,0x119984

    free_page(p);
  1051fd:	83 ec 08             	sub    $0x8,%esp
  105200:	6a 01                	push   $0x1
  105202:	ff 75 dc             	pushl  -0x24(%ebp)
  105205:	e8 0f da ff ff       	call   102c19 <free_pages>
  10520a:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  10520d:	83 ec 08             	sub    $0x8,%esp
  105210:	6a 01                	push   $0x1
  105212:	ff 75 f0             	pushl  -0x10(%ebp)
  105215:	e8 ff d9 ff ff       	call   102c19 <free_pages>
  10521a:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  10521d:	83 ec 08             	sub    $0x8,%esp
  105220:	6a 01                	push   $0x1
  105222:	ff 75 f4             	pushl  -0xc(%ebp)
  105225:	e8 ef d9 ff ff       	call   102c19 <free_pages>
  10522a:	83 c4 10             	add    $0x10,%esp
}
  10522d:	90                   	nop
  10522e:	c9                   	leave  
  10522f:	c3                   	ret    

00105230 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions
static void
default_check(void) {
  105230:	55                   	push   %ebp
  105231:	89 e5                	mov    %esp,%ebp
  105233:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
  105239:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105240:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  105247:	c7 45 ec 7c 99 11 00 	movl   $0x11997c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10524e:	eb 76                	jmp    1052c6 <default_check+0x96>
        struct Page *p = le2page(le, page_link);
  105250:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105253:	83 e8 0c             	sub    $0xc,%eax
  105256:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
  105259:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10525c:	83 c0 04             	add    $0x4,%eax
  10525f:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  105266:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105269:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10526c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10526f:	0f a3 10             	bt     %edx,(%eax)
  105272:	19 c0                	sbb    %eax,%eax
  105274:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
  105277:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  10527b:	0f 95 c0             	setne  %al
  10527e:	0f b6 c0             	movzbl %al,%eax
  105281:	85 c0                	test   %eax,%eax
  105283:	75 19                	jne    10529e <default_check+0x6e>
  105285:	68 02 72 10 00       	push   $0x107202
  10528a:	68 06 70 10 00       	push   $0x107006
  10528f:	68 5e 01 00 00       	push   $0x15e
  105294:	68 1b 70 10 00       	push   $0x10701b
  105299:	e8 33 b1 ff ff       	call   1003d1 <__panic>
        count ++, total += p->property;
  10529e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1052a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052a5:	8b 50 08             	mov    0x8(%eax),%edx
  1052a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052ab:	01 d0                	add    %edx,%eax
  1052ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
        cprintf("count %d total %d\n", count, total); //my
  1052b0:	83 ec 04             	sub    $0x4,%esp
  1052b3:	ff 75 f0             	pushl  -0x10(%ebp)
  1052b6:	ff 75 f4             	pushl  -0xc(%ebp)
  1052b9:	68 12 72 10 00       	push   $0x107212
  1052be:	e8 a8 af ff ff       	call   10026b <cprintf>
  1052c3:	83 c4 10             	add    $0x10,%esp
  1052c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1052c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1052cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052cf:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1052d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1052d5:	81 7d ec 7c 99 11 00 	cmpl   $0x11997c,-0x14(%ebp)
  1052dc:	0f 85 6e ff ff ff    	jne    105250 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
        cprintf("count %d total %d\n", count, total); //my
    }
    assert(total == nr_free_pages());
  1052e2:	e8 67 d9 ff ff       	call   102c4e <nr_free_pages>
  1052e7:	89 c2                	mov    %eax,%edx
  1052e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052ec:	39 c2                	cmp    %eax,%edx
  1052ee:	74 19                	je     105309 <default_check+0xd9>
  1052f0:	68 25 72 10 00       	push   $0x107225
  1052f5:	68 06 70 10 00       	push   $0x107006
  1052fa:	68 62 01 00 00       	push   $0x162
  1052ff:	68 1b 70 10 00       	push   $0x10701b
  105304:	e8 c8 b0 ff ff       	call   1003d1 <__panic>

    basic_check();
  105309:	e8 ac fa ff ff       	call   104dba <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10530e:	83 ec 0c             	sub    $0xc,%esp
  105311:	6a 05                	push   $0x5
  105313:	e8 c3 d8 ff ff       	call   102bdb <alloc_pages>
  105318:	83 c4 10             	add    $0x10,%esp
  10531b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
  10531e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105322:	75 19                	jne    10533d <default_check+0x10d>
  105324:	68 3e 72 10 00       	push   $0x10723e
  105329:	68 06 70 10 00       	push   $0x107006
  10532e:	68 67 01 00 00       	push   $0x167
  105333:	68 1b 70 10 00       	push   $0x10701b
  105338:	e8 94 b0 ff ff       	call   1003d1 <__panic>
    assert(!PageProperty(p0));
  10533d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105340:	83 c0 04             	add    $0x4,%eax
  105343:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  10534a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10534d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105350:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105353:	0f a3 10             	bt     %edx,(%eax)
  105356:	19 c0                	sbb    %eax,%eax
  105358:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
  10535b:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
  10535f:	0f 95 c0             	setne  %al
  105362:	0f b6 c0             	movzbl %al,%eax
  105365:	85 c0                	test   %eax,%eax
  105367:	74 19                	je     105382 <default_check+0x152>
  105369:	68 49 72 10 00       	push   $0x107249
  10536e:	68 06 70 10 00       	push   $0x107006
  105373:	68 68 01 00 00       	push   $0x168
  105378:	68 1b 70 10 00       	push   $0x10701b
  10537d:	e8 4f b0 ff ff       	call   1003d1 <__panic>

    list_entry_t free_list_store = free_list;
  105382:	a1 7c 99 11 00       	mov    0x11997c,%eax
  105387:	8b 15 80 99 11 00    	mov    0x119980,%edx
  10538d:	89 45 80             	mov    %eax,-0x80(%ebp)
  105390:	89 55 84             	mov    %edx,-0x7c(%ebp)
  105393:	c7 45 d0 7c 99 11 00 	movl   $0x11997c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10539a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10539d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1053a0:	89 50 04             	mov    %edx,0x4(%eax)
  1053a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1053a6:	8b 50 04             	mov    0x4(%eax),%edx
  1053a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1053ac:	89 10                	mov    %edx,(%eax)
  1053ae:	c7 45 d8 7c 99 11 00 	movl   $0x11997c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1053b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1053b8:	8b 40 04             	mov    0x4(%eax),%eax
  1053bb:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1053be:	0f 94 c0             	sete   %al
  1053c1:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1053c4:	85 c0                	test   %eax,%eax
  1053c6:	75 19                	jne    1053e1 <default_check+0x1b1>
  1053c8:	68 8b 71 10 00       	push   $0x10718b
  1053cd:	68 06 70 10 00       	push   $0x107006
  1053d2:	68 6c 01 00 00       	push   $0x16c
  1053d7:	68 1b 70 10 00       	push   $0x10701b
  1053dc:	e8 f0 af ff ff       	call   1003d1 <__panic>
    assert(alloc_page() == NULL);
  1053e1:	83 ec 0c             	sub    $0xc,%esp
  1053e4:	6a 01                	push   $0x1
  1053e6:	e8 f0 d7 ff ff       	call   102bdb <alloc_pages>
  1053eb:	83 c4 10             	add    $0x10,%esp
  1053ee:	85 c0                	test   %eax,%eax
  1053f0:	74 19                	je     10540b <default_check+0x1db>
  1053f2:	68 a2 71 10 00       	push   $0x1071a2
  1053f7:	68 06 70 10 00       	push   $0x107006
  1053fc:	68 6d 01 00 00       	push   $0x16d
  105401:	68 1b 70 10 00       	push   $0x10701b
  105406:	e8 c6 af ff ff       	call   1003d1 <__panic>

    unsigned int nr_free_store = nr_free;
  10540b:	a1 84 99 11 00       	mov    0x119984,%eax
  105410:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
  105413:	c7 05 84 99 11 00 00 	movl   $0x0,0x119984
  10541a:	00 00 00 

    free_pages(p0 + 2, 3);
  10541d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105420:	83 c0 28             	add    $0x28,%eax
  105423:	83 ec 08             	sub    $0x8,%esp
  105426:	6a 03                	push   $0x3
  105428:	50                   	push   %eax
  105429:	e8 eb d7 ff ff       	call   102c19 <free_pages>
  10542e:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
  105431:	83 ec 0c             	sub    $0xc,%esp
  105434:	6a 04                	push   $0x4
  105436:	e8 a0 d7 ff ff       	call   102bdb <alloc_pages>
  10543b:	83 c4 10             	add    $0x10,%esp
  10543e:	85 c0                	test   %eax,%eax
  105440:	74 19                	je     10545b <default_check+0x22b>
  105442:	68 5b 72 10 00       	push   $0x10725b
  105447:	68 06 70 10 00       	push   $0x107006
  10544c:	68 73 01 00 00       	push   $0x173
  105451:	68 1b 70 10 00       	push   $0x10701b
  105456:	e8 76 af ff ff       	call   1003d1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10545b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10545e:	83 c0 28             	add    $0x28,%eax
  105461:	83 c0 04             	add    $0x4,%eax
  105464:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  10546b:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10546e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105471:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105474:	0f a3 10             	bt     %edx,(%eax)
  105477:	19 c0                	sbb    %eax,%eax
  105479:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10547c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105480:	0f 95 c0             	setne  %al
  105483:	0f b6 c0             	movzbl %al,%eax
  105486:	85 c0                	test   %eax,%eax
  105488:	74 0e                	je     105498 <default_check+0x268>
  10548a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10548d:	83 c0 28             	add    $0x28,%eax
  105490:	8b 40 08             	mov    0x8(%eax),%eax
  105493:	83 f8 03             	cmp    $0x3,%eax
  105496:	74 19                	je     1054b1 <default_check+0x281>
  105498:	68 74 72 10 00       	push   $0x107274
  10549d:	68 06 70 10 00       	push   $0x107006
  1054a2:	68 74 01 00 00       	push   $0x174
  1054a7:	68 1b 70 10 00       	push   $0x10701b
  1054ac:	e8 20 af ff ff       	call   1003d1 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1054b1:	83 ec 0c             	sub    $0xc,%esp
  1054b4:	6a 03                	push   $0x3
  1054b6:	e8 20 d7 ff ff       	call   102bdb <alloc_pages>
  1054bb:	83 c4 10             	add    $0x10,%esp
  1054be:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  1054c1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  1054c5:	75 19                	jne    1054e0 <default_check+0x2b0>
  1054c7:	68 a0 72 10 00       	push   $0x1072a0
  1054cc:	68 06 70 10 00       	push   $0x107006
  1054d1:	68 75 01 00 00       	push   $0x175
  1054d6:	68 1b 70 10 00       	push   $0x10701b
  1054db:	e8 f1 ae ff ff       	call   1003d1 <__panic>
    assert(alloc_page() == NULL);
  1054e0:	83 ec 0c             	sub    $0xc,%esp
  1054e3:	6a 01                	push   $0x1
  1054e5:	e8 f1 d6 ff ff       	call   102bdb <alloc_pages>
  1054ea:	83 c4 10             	add    $0x10,%esp
  1054ed:	85 c0                	test   %eax,%eax
  1054ef:	74 19                	je     10550a <default_check+0x2da>
  1054f1:	68 a2 71 10 00       	push   $0x1071a2
  1054f6:	68 06 70 10 00       	push   $0x107006
  1054fb:	68 76 01 00 00       	push   $0x176
  105500:	68 1b 70 10 00       	push   $0x10701b
  105505:	e8 c7 ae ff ff       	call   1003d1 <__panic>
    assert(p0 + 2 == p1);
  10550a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10550d:	83 c0 28             	add    $0x28,%eax
  105510:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  105513:	74 19                	je     10552e <default_check+0x2fe>
  105515:	68 be 72 10 00       	push   $0x1072be
  10551a:	68 06 70 10 00       	push   $0x107006
  10551f:	68 77 01 00 00       	push   $0x177
  105524:	68 1b 70 10 00       	push   $0x10701b
  105529:	e8 a3 ae ff ff       	call   1003d1 <__panic>

    p2 = p0 + 1;
  10552e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105531:	83 c0 14             	add    $0x14,%eax
  105534:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
  105537:	83 ec 08             	sub    $0x8,%esp
  10553a:	6a 01                	push   $0x1
  10553c:	ff 75 dc             	pushl  -0x24(%ebp)
  10553f:	e8 d5 d6 ff ff       	call   102c19 <free_pages>
  105544:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
  105547:	83 ec 08             	sub    $0x8,%esp
  10554a:	6a 03                	push   $0x3
  10554c:	ff 75 c4             	pushl  -0x3c(%ebp)
  10554f:	e8 c5 d6 ff ff       	call   102c19 <free_pages>
  105554:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
  105557:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10555a:	83 c0 04             	add    $0x4,%eax
  10555d:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  105564:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105567:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10556a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10556d:	0f a3 10             	bt     %edx,(%eax)
  105570:	19 c0                	sbb    %eax,%eax
  105572:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
  105575:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
  105579:	0f 95 c0             	setne  %al
  10557c:	0f b6 c0             	movzbl %al,%eax
  10557f:	85 c0                	test   %eax,%eax
  105581:	74 0b                	je     10558e <default_check+0x35e>
  105583:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105586:	8b 40 08             	mov    0x8(%eax),%eax
  105589:	83 f8 01             	cmp    $0x1,%eax
  10558c:	74 19                	je     1055a7 <default_check+0x377>
  10558e:	68 cc 72 10 00       	push   $0x1072cc
  105593:	68 06 70 10 00       	push   $0x107006
  105598:	68 7c 01 00 00       	push   $0x17c
  10559d:	68 1b 70 10 00       	push   $0x10701b
  1055a2:	e8 2a ae ff ff       	call   1003d1 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1055a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1055aa:	83 c0 04             	add    $0x4,%eax
  1055ad:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  1055b4:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1055b7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1055ba:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1055bd:	0f a3 10             	bt     %edx,(%eax)
  1055c0:	19 c0                	sbb    %eax,%eax
  1055c2:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
  1055c5:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
  1055c9:	0f 95 c0             	setne  %al
  1055cc:	0f b6 c0             	movzbl %al,%eax
  1055cf:	85 c0                	test   %eax,%eax
  1055d1:	74 0b                	je     1055de <default_check+0x3ae>
  1055d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1055d6:	8b 40 08             	mov    0x8(%eax),%eax
  1055d9:	83 f8 03             	cmp    $0x3,%eax
  1055dc:	74 19                	je     1055f7 <default_check+0x3c7>
  1055de:	68 f4 72 10 00       	push   $0x1072f4
  1055e3:	68 06 70 10 00       	push   $0x107006
  1055e8:	68 7d 01 00 00       	push   $0x17d
  1055ed:	68 1b 70 10 00       	push   $0x10701b
  1055f2:	e8 da ad ff ff       	call   1003d1 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1055f7:	83 ec 0c             	sub    $0xc,%esp
  1055fa:	6a 01                	push   $0x1
  1055fc:	e8 da d5 ff ff       	call   102bdb <alloc_pages>
  105601:	83 c4 10             	add    $0x10,%esp
  105604:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105607:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10560a:	83 e8 14             	sub    $0x14,%eax
  10560d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  105610:	74 19                	je     10562b <default_check+0x3fb>
  105612:	68 1a 73 10 00       	push   $0x10731a
  105617:	68 06 70 10 00       	push   $0x107006
  10561c:	68 7f 01 00 00       	push   $0x17f
  105621:	68 1b 70 10 00       	push   $0x10701b
  105626:	e8 a6 ad ff ff       	call   1003d1 <__panic>
    free_page(p0);
  10562b:	83 ec 08             	sub    $0x8,%esp
  10562e:	6a 01                	push   $0x1
  105630:	ff 75 dc             	pushl  -0x24(%ebp)
  105633:	e8 e1 d5 ff ff       	call   102c19 <free_pages>
  105638:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10563b:	83 ec 0c             	sub    $0xc,%esp
  10563e:	6a 02                	push   $0x2
  105640:	e8 96 d5 ff ff       	call   102bdb <alloc_pages>
  105645:	83 c4 10             	add    $0x10,%esp
  105648:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10564b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10564e:	83 c0 14             	add    $0x14,%eax
  105651:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  105654:	74 19                	je     10566f <default_check+0x43f>
  105656:	68 38 73 10 00       	push   $0x107338
  10565b:	68 06 70 10 00       	push   $0x107006
  105660:	68 81 01 00 00       	push   $0x181
  105665:	68 1b 70 10 00       	push   $0x10701b
  10566a:	e8 62 ad ff ff       	call   1003d1 <__panic>

    free_pages(p0, 2);
  10566f:	83 ec 08             	sub    $0x8,%esp
  105672:	6a 02                	push   $0x2
  105674:	ff 75 dc             	pushl  -0x24(%ebp)
  105677:	e8 9d d5 ff ff       	call   102c19 <free_pages>
  10567c:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  10567f:	83 ec 08             	sub    $0x8,%esp
  105682:	6a 01                	push   $0x1
  105684:	ff 75 c0             	pushl  -0x40(%ebp)
  105687:	e8 8d d5 ff ff       	call   102c19 <free_pages>
  10568c:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
  10568f:	83 ec 0c             	sub    $0xc,%esp
  105692:	6a 05                	push   $0x5
  105694:	e8 42 d5 ff ff       	call   102bdb <alloc_pages>
  105699:	83 c4 10             	add    $0x10,%esp
  10569c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10569f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1056a3:	75 19                	jne    1056be <default_check+0x48e>
  1056a5:	68 58 73 10 00       	push   $0x107358
  1056aa:	68 06 70 10 00       	push   $0x107006
  1056af:	68 86 01 00 00       	push   $0x186
  1056b4:	68 1b 70 10 00       	push   $0x10701b
  1056b9:	e8 13 ad ff ff       	call   1003d1 <__panic>
    assert(alloc_page() == NULL);
  1056be:	83 ec 0c             	sub    $0xc,%esp
  1056c1:	6a 01                	push   $0x1
  1056c3:	e8 13 d5 ff ff       	call   102bdb <alloc_pages>
  1056c8:	83 c4 10             	add    $0x10,%esp
  1056cb:	85 c0                	test   %eax,%eax
  1056cd:	74 19                	je     1056e8 <default_check+0x4b8>
  1056cf:	68 a2 71 10 00       	push   $0x1071a2
  1056d4:	68 06 70 10 00       	push   $0x107006
  1056d9:	68 87 01 00 00       	push   $0x187
  1056de:	68 1b 70 10 00       	push   $0x10701b
  1056e3:	e8 e9 ac ff ff       	call   1003d1 <__panic>

    assert(nr_free == 0);
  1056e8:	a1 84 99 11 00       	mov    0x119984,%eax
  1056ed:	85 c0                	test   %eax,%eax
  1056ef:	74 19                	je     10570a <default_check+0x4da>
  1056f1:	68 f5 71 10 00       	push   $0x1071f5
  1056f6:	68 06 70 10 00       	push   $0x107006
  1056fb:	68 89 01 00 00       	push   $0x189
  105700:	68 1b 70 10 00       	push   $0x10701b
  105705:	e8 c7 ac ff ff       	call   1003d1 <__panic>
    nr_free = nr_free_store;
  10570a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10570d:	a3 84 99 11 00       	mov    %eax,0x119984

    free_list = free_list_store;
  105712:	8b 45 80             	mov    -0x80(%ebp),%eax
  105715:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105718:	a3 7c 99 11 00       	mov    %eax,0x11997c
  10571d:	89 15 80 99 11 00    	mov    %edx,0x119980
    free_pages(p0, 5);
  105723:	83 ec 08             	sub    $0x8,%esp
  105726:	6a 05                	push   $0x5
  105728:	ff 75 dc             	pushl  -0x24(%ebp)
  10572b:	e8 e9 d4 ff ff       	call   102c19 <free_pages>
  105730:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
  105733:	c7 45 ec 7c 99 11 00 	movl   $0x11997c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10573a:	eb 1d                	jmp    105759 <default_check+0x529>
        struct Page *p = le2page(le, page_link);
  10573c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10573f:	83 e8 0c             	sub    $0xc,%eax
  105742:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
  105745:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  105749:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10574c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10574f:	8b 40 08             	mov    0x8(%eax),%eax
  105752:	29 c2                	sub    %eax,%edx
  105754:	89 d0                	mov    %edx,%eax
  105756:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10575c:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10575f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  105762:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  105765:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105768:	81 7d ec 7c 99 11 00 	cmpl   $0x11997c,-0x14(%ebp)
  10576f:	75 cb                	jne    10573c <default_check+0x50c>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  105771:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105775:	74 19                	je     105790 <default_check+0x560>
  105777:	68 76 73 10 00       	push   $0x107376
  10577c:	68 06 70 10 00       	push   $0x107006
  105781:	68 94 01 00 00       	push   $0x194
  105786:	68 1b 70 10 00       	push   $0x10701b
  10578b:	e8 41 ac ff ff       	call   1003d1 <__panic>
    assert(total == 0);
  105790:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105794:	74 19                	je     1057af <default_check+0x57f>
  105796:	68 81 73 10 00       	push   $0x107381
  10579b:	68 06 70 10 00       	push   $0x107006
  1057a0:	68 95 01 00 00       	push   $0x195
  1057a5:	68 1b 70 10 00       	push   $0x10701b
  1057aa:	e8 22 ac ff ff       	call   1003d1 <__panic>
}
  1057af:	90                   	nop
  1057b0:	c9                   	leave  
  1057b1:	c3                   	ret    

001057b2 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1057b2:	55                   	push   %ebp
  1057b3:	89 e5                	mov    %esp,%ebp
  1057b5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1057b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1057bf:	eb 04                	jmp    1057c5 <strlen+0x13>
        cnt ++;
  1057c1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1057c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c8:	8d 50 01             	lea    0x1(%eax),%edx
  1057cb:	89 55 08             	mov    %edx,0x8(%ebp)
  1057ce:	0f b6 00             	movzbl (%eax),%eax
  1057d1:	84 c0                	test   %al,%al
  1057d3:	75 ec                	jne    1057c1 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1057d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1057d8:	c9                   	leave  
  1057d9:	c3                   	ret    

001057da <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1057da:	55                   	push   %ebp
  1057db:	89 e5                	mov    %esp,%ebp
  1057dd:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1057e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1057e7:	eb 04                	jmp    1057ed <strnlen+0x13>
        cnt ++;
  1057e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  1057ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1057f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1057f3:	73 10                	jae    105805 <strnlen+0x2b>
  1057f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f8:	8d 50 01             	lea    0x1(%eax),%edx
  1057fb:	89 55 08             	mov    %edx,0x8(%ebp)
  1057fe:	0f b6 00             	movzbl (%eax),%eax
  105801:	84 c0                	test   %al,%al
  105803:	75 e4                	jne    1057e9 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105805:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105808:	c9                   	leave  
  105809:	c3                   	ret    

0010580a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10580a:	55                   	push   %ebp
  10580b:	89 e5                	mov    %esp,%ebp
  10580d:	57                   	push   %edi
  10580e:	56                   	push   %esi
  10580f:	83 ec 20             	sub    $0x20,%esp
  105812:	8b 45 08             	mov    0x8(%ebp),%eax
  105815:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105818:	8b 45 0c             	mov    0xc(%ebp),%eax
  10581b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10581e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105824:	89 d1                	mov    %edx,%ecx
  105826:	89 c2                	mov    %eax,%edx
  105828:	89 ce                	mov    %ecx,%esi
  10582a:	89 d7                	mov    %edx,%edi
  10582c:	ac                   	lods   %ds:(%esi),%al
  10582d:	aa                   	stos   %al,%es:(%edi)
  10582e:	84 c0                	test   %al,%al
  105830:	75 fa                	jne    10582c <strcpy+0x22>
  105832:	89 fa                	mov    %edi,%edx
  105834:	89 f1                	mov    %esi,%ecx
  105836:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105839:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10583c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  10583f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  105842:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105843:	83 c4 20             	add    $0x20,%esp
  105846:	5e                   	pop    %esi
  105847:	5f                   	pop    %edi
  105848:	5d                   	pop    %ebp
  105849:	c3                   	ret    

0010584a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10584a:	55                   	push   %ebp
  10584b:	89 e5                	mov    %esp,%ebp
  10584d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105850:	8b 45 08             	mov    0x8(%ebp),%eax
  105853:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105856:	eb 21                	jmp    105879 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105858:	8b 45 0c             	mov    0xc(%ebp),%eax
  10585b:	0f b6 10             	movzbl (%eax),%edx
  10585e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105861:	88 10                	mov    %dl,(%eax)
  105863:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105866:	0f b6 00             	movzbl (%eax),%eax
  105869:	84 c0                	test   %al,%al
  10586b:	74 04                	je     105871 <strncpy+0x27>
            src ++;
  10586d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105871:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105875:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105879:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10587d:	75 d9                	jne    105858 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  10587f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105882:	c9                   	leave  
  105883:	c3                   	ret    

00105884 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105884:	55                   	push   %ebp
  105885:	89 e5                	mov    %esp,%ebp
  105887:	57                   	push   %edi
  105888:	56                   	push   %esi
  105889:	83 ec 20             	sub    $0x20,%esp
  10588c:	8b 45 08             	mov    0x8(%ebp),%eax
  10588f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105892:	8b 45 0c             	mov    0xc(%ebp),%eax
  105895:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10589b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10589e:	89 d1                	mov    %edx,%ecx
  1058a0:	89 c2                	mov    %eax,%edx
  1058a2:	89 ce                	mov    %ecx,%esi
  1058a4:	89 d7                	mov    %edx,%edi
  1058a6:	ac                   	lods   %ds:(%esi),%al
  1058a7:	ae                   	scas   %es:(%edi),%al
  1058a8:	75 08                	jne    1058b2 <strcmp+0x2e>
  1058aa:	84 c0                	test   %al,%al
  1058ac:	75 f8                	jne    1058a6 <strcmp+0x22>
  1058ae:	31 c0                	xor    %eax,%eax
  1058b0:	eb 04                	jmp    1058b6 <strcmp+0x32>
  1058b2:	19 c0                	sbb    %eax,%eax
  1058b4:	0c 01                	or     $0x1,%al
  1058b6:	89 fa                	mov    %edi,%edx
  1058b8:	89 f1                	mov    %esi,%ecx
  1058ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1058bd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1058c0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  1058c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  1058c6:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1058c7:	83 c4 20             	add    $0x20,%esp
  1058ca:	5e                   	pop    %esi
  1058cb:	5f                   	pop    %edi
  1058cc:	5d                   	pop    %ebp
  1058cd:	c3                   	ret    

001058ce <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1058ce:	55                   	push   %ebp
  1058cf:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1058d1:	eb 0c                	jmp    1058df <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1058d3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1058d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1058db:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1058df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1058e3:	74 1a                	je     1058ff <strncmp+0x31>
  1058e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e8:	0f b6 00             	movzbl (%eax),%eax
  1058eb:	84 c0                	test   %al,%al
  1058ed:	74 10                	je     1058ff <strncmp+0x31>
  1058ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f2:	0f b6 10             	movzbl (%eax),%edx
  1058f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058f8:	0f b6 00             	movzbl (%eax),%eax
  1058fb:	38 c2                	cmp    %al,%dl
  1058fd:	74 d4                	je     1058d3 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1058ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105903:	74 18                	je     10591d <strncmp+0x4f>
  105905:	8b 45 08             	mov    0x8(%ebp),%eax
  105908:	0f b6 00             	movzbl (%eax),%eax
  10590b:	0f b6 d0             	movzbl %al,%edx
  10590e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105911:	0f b6 00             	movzbl (%eax),%eax
  105914:	0f b6 c0             	movzbl %al,%eax
  105917:	29 c2                	sub    %eax,%edx
  105919:	89 d0                	mov    %edx,%eax
  10591b:	eb 05                	jmp    105922 <strncmp+0x54>
  10591d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105922:	5d                   	pop    %ebp
  105923:	c3                   	ret    

00105924 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105924:	55                   	push   %ebp
  105925:	89 e5                	mov    %esp,%ebp
  105927:	83 ec 04             	sub    $0x4,%esp
  10592a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10592d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105930:	eb 14                	jmp    105946 <strchr+0x22>
        if (*s == c) {
  105932:	8b 45 08             	mov    0x8(%ebp),%eax
  105935:	0f b6 00             	movzbl (%eax),%eax
  105938:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10593b:	75 05                	jne    105942 <strchr+0x1e>
            return (char *)s;
  10593d:	8b 45 08             	mov    0x8(%ebp),%eax
  105940:	eb 13                	jmp    105955 <strchr+0x31>
        }
        s ++;
  105942:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105946:	8b 45 08             	mov    0x8(%ebp),%eax
  105949:	0f b6 00             	movzbl (%eax),%eax
  10594c:	84 c0                	test   %al,%al
  10594e:	75 e2                	jne    105932 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105955:	c9                   	leave  
  105956:	c3                   	ret    

00105957 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105957:	55                   	push   %ebp
  105958:	89 e5                	mov    %esp,%ebp
  10595a:	83 ec 04             	sub    $0x4,%esp
  10595d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105960:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105963:	eb 0f                	jmp    105974 <strfind+0x1d>
        if (*s == c) {
  105965:	8b 45 08             	mov    0x8(%ebp),%eax
  105968:	0f b6 00             	movzbl (%eax),%eax
  10596b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10596e:	74 10                	je     105980 <strfind+0x29>
            break;
        }
        s ++;
  105970:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105974:	8b 45 08             	mov    0x8(%ebp),%eax
  105977:	0f b6 00             	movzbl (%eax),%eax
  10597a:	84 c0                	test   %al,%al
  10597c:	75 e7                	jne    105965 <strfind+0xe>
  10597e:	eb 01                	jmp    105981 <strfind+0x2a>
        if (*s == c) {
            break;
  105980:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  105981:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105984:	c9                   	leave  
  105985:	c3                   	ret    

00105986 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105986:	55                   	push   %ebp
  105987:	89 e5                	mov    %esp,%ebp
  105989:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10598c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105993:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10599a:	eb 04                	jmp    1059a0 <strtol+0x1a>
        s ++;
  10599c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1059a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a3:	0f b6 00             	movzbl (%eax),%eax
  1059a6:	3c 20                	cmp    $0x20,%al
  1059a8:	74 f2                	je     10599c <strtol+0x16>
  1059aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ad:	0f b6 00             	movzbl (%eax),%eax
  1059b0:	3c 09                	cmp    $0x9,%al
  1059b2:	74 e8                	je     10599c <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1059b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b7:	0f b6 00             	movzbl (%eax),%eax
  1059ba:	3c 2b                	cmp    $0x2b,%al
  1059bc:	75 06                	jne    1059c4 <strtol+0x3e>
        s ++;
  1059be:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1059c2:	eb 15                	jmp    1059d9 <strtol+0x53>
    }
    else if (*s == '-') {
  1059c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c7:	0f b6 00             	movzbl (%eax),%eax
  1059ca:	3c 2d                	cmp    $0x2d,%al
  1059cc:	75 0b                	jne    1059d9 <strtol+0x53>
        s ++, neg = 1;
  1059ce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1059d2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1059d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1059dd:	74 06                	je     1059e5 <strtol+0x5f>
  1059df:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1059e3:	75 24                	jne    105a09 <strtol+0x83>
  1059e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1059e8:	0f b6 00             	movzbl (%eax),%eax
  1059eb:	3c 30                	cmp    $0x30,%al
  1059ed:	75 1a                	jne    105a09 <strtol+0x83>
  1059ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f2:	83 c0 01             	add    $0x1,%eax
  1059f5:	0f b6 00             	movzbl (%eax),%eax
  1059f8:	3c 78                	cmp    $0x78,%al
  1059fa:	75 0d                	jne    105a09 <strtol+0x83>
        s += 2, base = 16;
  1059fc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105a00:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105a07:	eb 2a                	jmp    105a33 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105a09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a0d:	75 17                	jne    105a26 <strtol+0xa0>
  105a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a12:	0f b6 00             	movzbl (%eax),%eax
  105a15:	3c 30                	cmp    $0x30,%al
  105a17:	75 0d                	jne    105a26 <strtol+0xa0>
        s ++, base = 8;
  105a19:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105a1d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105a24:	eb 0d                	jmp    105a33 <strtol+0xad>
    }
    else if (base == 0) {
  105a26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a2a:	75 07                	jne    105a33 <strtol+0xad>
        base = 10;
  105a2c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105a33:	8b 45 08             	mov    0x8(%ebp),%eax
  105a36:	0f b6 00             	movzbl (%eax),%eax
  105a39:	3c 2f                	cmp    $0x2f,%al
  105a3b:	7e 1b                	jle    105a58 <strtol+0xd2>
  105a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a40:	0f b6 00             	movzbl (%eax),%eax
  105a43:	3c 39                	cmp    $0x39,%al
  105a45:	7f 11                	jg     105a58 <strtol+0xd2>
            dig = *s - '0';
  105a47:	8b 45 08             	mov    0x8(%ebp),%eax
  105a4a:	0f b6 00             	movzbl (%eax),%eax
  105a4d:	0f be c0             	movsbl %al,%eax
  105a50:	83 e8 30             	sub    $0x30,%eax
  105a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a56:	eb 48                	jmp    105aa0 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105a58:	8b 45 08             	mov    0x8(%ebp),%eax
  105a5b:	0f b6 00             	movzbl (%eax),%eax
  105a5e:	3c 60                	cmp    $0x60,%al
  105a60:	7e 1b                	jle    105a7d <strtol+0xf7>
  105a62:	8b 45 08             	mov    0x8(%ebp),%eax
  105a65:	0f b6 00             	movzbl (%eax),%eax
  105a68:	3c 7a                	cmp    $0x7a,%al
  105a6a:	7f 11                	jg     105a7d <strtol+0xf7>
            dig = *s - 'a' + 10;
  105a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a6f:	0f b6 00             	movzbl (%eax),%eax
  105a72:	0f be c0             	movsbl %al,%eax
  105a75:	83 e8 57             	sub    $0x57,%eax
  105a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a7b:	eb 23                	jmp    105aa0 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a80:	0f b6 00             	movzbl (%eax),%eax
  105a83:	3c 40                	cmp    $0x40,%al
  105a85:	7e 3c                	jle    105ac3 <strtol+0x13d>
  105a87:	8b 45 08             	mov    0x8(%ebp),%eax
  105a8a:	0f b6 00             	movzbl (%eax),%eax
  105a8d:	3c 5a                	cmp    $0x5a,%al
  105a8f:	7f 32                	jg     105ac3 <strtol+0x13d>
            dig = *s - 'A' + 10;
  105a91:	8b 45 08             	mov    0x8(%ebp),%eax
  105a94:	0f b6 00             	movzbl (%eax),%eax
  105a97:	0f be c0             	movsbl %al,%eax
  105a9a:	83 e8 37             	sub    $0x37,%eax
  105a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105aa3:	3b 45 10             	cmp    0x10(%ebp),%eax
  105aa6:	7d 1a                	jge    105ac2 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  105aa8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105aac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105aaf:	0f af 45 10          	imul   0x10(%ebp),%eax
  105ab3:	89 c2                	mov    %eax,%edx
  105ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ab8:	01 d0                	add    %edx,%eax
  105aba:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105abd:	e9 71 ff ff ff       	jmp    105a33 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  105ac2:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  105ac3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105ac7:	74 08                	je     105ad1 <strtol+0x14b>
        *endptr = (char *) s;
  105ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105acc:	8b 55 08             	mov    0x8(%ebp),%edx
  105acf:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105ad1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105ad5:	74 07                	je     105ade <strtol+0x158>
  105ad7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105ada:	f7 d8                	neg    %eax
  105adc:	eb 03                	jmp    105ae1 <strtol+0x15b>
  105ade:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105ae1:	c9                   	leave  
  105ae2:	c3                   	ret    

00105ae3 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105ae3:	55                   	push   %ebp
  105ae4:	89 e5                	mov    %esp,%ebp
  105ae6:	57                   	push   %edi
  105ae7:	83 ec 24             	sub    $0x24,%esp
  105aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aed:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105af0:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105af4:	8b 55 08             	mov    0x8(%ebp),%edx
  105af7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105afa:	88 45 f7             	mov    %al,-0x9(%ebp)
  105afd:	8b 45 10             	mov    0x10(%ebp),%eax
  105b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105b03:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105b06:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105b0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105b0d:	89 d7                	mov    %edx,%edi
  105b0f:	f3 aa                	rep stos %al,%es:(%edi)
  105b11:	89 fa                	mov    %edi,%edx
  105b13:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b16:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105b19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105b1c:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105b1d:	83 c4 24             	add    $0x24,%esp
  105b20:	5f                   	pop    %edi
  105b21:	5d                   	pop    %ebp
  105b22:	c3                   	ret    

00105b23 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105b23:	55                   	push   %ebp
  105b24:	89 e5                	mov    %esp,%ebp
  105b26:	57                   	push   %edi
  105b27:	56                   	push   %esi
  105b28:	53                   	push   %ebx
  105b29:	83 ec 30             	sub    $0x30,%esp
  105b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b38:	8b 45 10             	mov    0x10(%ebp),%eax
  105b3b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b41:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105b44:	73 42                	jae    105b88 <memmove+0x65>
  105b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105b52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b55:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105b58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105b5b:	c1 e8 02             	shr    $0x2,%eax
  105b5e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105b60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105b63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b66:	89 d7                	mov    %edx,%edi
  105b68:	89 c6                	mov    %eax,%esi
  105b6a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105b6c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105b6f:	83 e1 03             	and    $0x3,%ecx
  105b72:	74 02                	je     105b76 <memmove+0x53>
  105b74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105b76:	89 f0                	mov    %esi,%eax
  105b78:	89 fa                	mov    %edi,%edx
  105b7a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105b7d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105b80:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  105b86:	eb 36                	jmp    105bbe <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  105b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b91:	01 c2                	add    %eax,%edx
  105b93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b96:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b9c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105b9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ba2:	89 c1                	mov    %eax,%ecx
  105ba4:	89 d8                	mov    %ebx,%eax
  105ba6:	89 d6                	mov    %edx,%esi
  105ba8:	89 c7                	mov    %eax,%edi
  105baa:	fd                   	std    
  105bab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105bad:	fc                   	cld    
  105bae:	89 f8                	mov    %edi,%eax
  105bb0:	89 f2                	mov    %esi,%edx
  105bb2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105bb5:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105bb8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105bbe:	83 c4 30             	add    $0x30,%esp
  105bc1:	5b                   	pop    %ebx
  105bc2:	5e                   	pop    %esi
  105bc3:	5f                   	pop    %edi
  105bc4:	5d                   	pop    %ebp
  105bc5:	c3                   	ret    

00105bc6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105bc6:	55                   	push   %ebp
  105bc7:	89 e5                	mov    %esp,%ebp
  105bc9:	57                   	push   %edi
  105bca:	56                   	push   %esi
  105bcb:	83 ec 20             	sub    $0x20,%esp
  105bce:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bda:	8b 45 10             	mov    0x10(%ebp),%eax
  105bdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105be3:	c1 e8 02             	shr    $0x2,%eax
  105be6:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105be8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bee:	89 d7                	mov    %edx,%edi
  105bf0:	89 c6                	mov    %eax,%esi
  105bf2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105bf4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105bf7:	83 e1 03             	and    $0x3,%ecx
  105bfa:	74 02                	je     105bfe <memcpy+0x38>
  105bfc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105bfe:	89 f0                	mov    %esi,%eax
  105c00:	89 fa                	mov    %edi,%edx
  105c02:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105c05:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105c08:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  105c0e:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105c0f:	83 c4 20             	add    $0x20,%esp
  105c12:	5e                   	pop    %esi
  105c13:	5f                   	pop    %edi
  105c14:	5d                   	pop    %ebp
  105c15:	c3                   	ret    

00105c16 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105c16:	55                   	push   %ebp
  105c17:	89 e5                	mov    %esp,%ebp
  105c19:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c25:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105c28:	eb 30                	jmp    105c5a <memcmp+0x44>
        if (*s1 != *s2) {
  105c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c2d:	0f b6 10             	movzbl (%eax),%edx
  105c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c33:	0f b6 00             	movzbl (%eax),%eax
  105c36:	38 c2                	cmp    %al,%dl
  105c38:	74 18                	je     105c52 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105c3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c3d:	0f b6 00             	movzbl (%eax),%eax
  105c40:	0f b6 d0             	movzbl %al,%edx
  105c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c46:	0f b6 00             	movzbl (%eax),%eax
  105c49:	0f b6 c0             	movzbl %al,%eax
  105c4c:	29 c2                	sub    %eax,%edx
  105c4e:	89 d0                	mov    %edx,%eax
  105c50:	eb 1a                	jmp    105c6c <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105c52:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105c56:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  105c5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  105c60:	89 55 10             	mov    %edx,0x10(%ebp)
  105c63:	85 c0                	test   %eax,%eax
  105c65:	75 c3                	jne    105c2a <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105c67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c6c:	c9                   	leave  
  105c6d:	c3                   	ret    

00105c6e <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105c6e:	55                   	push   %ebp
  105c6f:	89 e5                	mov    %esp,%ebp
  105c71:	83 ec 38             	sub    $0x38,%esp
  105c74:	8b 45 10             	mov    0x10(%ebp),%eax
  105c77:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105c7a:	8b 45 14             	mov    0x14(%ebp),%eax
  105c7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105c80:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105c83:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105c86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105c89:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105c8c:	8b 45 18             	mov    0x18(%ebp),%eax
  105c8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105c95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105c98:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105c9b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ca1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ca4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105ca8:	74 1c                	je     105cc6 <printnum+0x58>
  105caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cad:	ba 00 00 00 00       	mov    $0x0,%edx
  105cb2:	f7 75 e4             	divl   -0x1c(%ebp)
  105cb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  105cc0:	f7 75 e4             	divl   -0x1c(%ebp)
  105cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ccc:	f7 75 e4             	divl   -0x1c(%ebp)
  105ccf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105cd2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105cd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105cdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105cde:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105ce1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105ce4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105ce7:	8b 45 18             	mov    0x18(%ebp),%eax
  105cea:	ba 00 00 00 00       	mov    $0x0,%edx
  105cef:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105cf2:	77 41                	ja     105d35 <printnum+0xc7>
  105cf4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105cf7:	72 05                	jb     105cfe <printnum+0x90>
  105cf9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105cfc:	77 37                	ja     105d35 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  105cfe:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105d01:	83 e8 01             	sub    $0x1,%eax
  105d04:	83 ec 04             	sub    $0x4,%esp
  105d07:	ff 75 20             	pushl  0x20(%ebp)
  105d0a:	50                   	push   %eax
  105d0b:	ff 75 18             	pushl  0x18(%ebp)
  105d0e:	ff 75 ec             	pushl  -0x14(%ebp)
  105d11:	ff 75 e8             	pushl  -0x18(%ebp)
  105d14:	ff 75 0c             	pushl  0xc(%ebp)
  105d17:	ff 75 08             	pushl  0x8(%ebp)
  105d1a:	e8 4f ff ff ff       	call   105c6e <printnum>
  105d1f:	83 c4 20             	add    $0x20,%esp
  105d22:	eb 1b                	jmp    105d3f <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105d24:	83 ec 08             	sub    $0x8,%esp
  105d27:	ff 75 0c             	pushl  0xc(%ebp)
  105d2a:	ff 75 20             	pushl  0x20(%ebp)
  105d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d30:	ff d0                	call   *%eax
  105d32:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105d35:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105d39:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105d3d:	7f e5                	jg     105d24 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105d3f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105d42:	05 34 74 10 00       	add    $0x107434,%eax
  105d47:	0f b6 00             	movzbl (%eax),%eax
  105d4a:	0f be c0             	movsbl %al,%eax
  105d4d:	83 ec 08             	sub    $0x8,%esp
  105d50:	ff 75 0c             	pushl  0xc(%ebp)
  105d53:	50                   	push   %eax
  105d54:	8b 45 08             	mov    0x8(%ebp),%eax
  105d57:	ff d0                	call   *%eax
  105d59:	83 c4 10             	add    $0x10,%esp
}
  105d5c:	90                   	nop
  105d5d:	c9                   	leave  
  105d5e:	c3                   	ret    

00105d5f <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105d5f:	55                   	push   %ebp
  105d60:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105d62:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105d66:	7e 14                	jle    105d7c <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105d68:	8b 45 08             	mov    0x8(%ebp),%eax
  105d6b:	8b 00                	mov    (%eax),%eax
  105d6d:	8d 48 08             	lea    0x8(%eax),%ecx
  105d70:	8b 55 08             	mov    0x8(%ebp),%edx
  105d73:	89 0a                	mov    %ecx,(%edx)
  105d75:	8b 50 04             	mov    0x4(%eax),%edx
  105d78:	8b 00                	mov    (%eax),%eax
  105d7a:	eb 30                	jmp    105dac <getuint+0x4d>
    }
    else if (lflag) {
  105d7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105d80:	74 16                	je     105d98 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105d82:	8b 45 08             	mov    0x8(%ebp),%eax
  105d85:	8b 00                	mov    (%eax),%eax
  105d87:	8d 48 04             	lea    0x4(%eax),%ecx
  105d8a:	8b 55 08             	mov    0x8(%ebp),%edx
  105d8d:	89 0a                	mov    %ecx,(%edx)
  105d8f:	8b 00                	mov    (%eax),%eax
  105d91:	ba 00 00 00 00       	mov    $0x0,%edx
  105d96:	eb 14                	jmp    105dac <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105d98:	8b 45 08             	mov    0x8(%ebp),%eax
  105d9b:	8b 00                	mov    (%eax),%eax
  105d9d:	8d 48 04             	lea    0x4(%eax),%ecx
  105da0:	8b 55 08             	mov    0x8(%ebp),%edx
  105da3:	89 0a                	mov    %ecx,(%edx)
  105da5:	8b 00                	mov    (%eax),%eax
  105da7:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105dac:	5d                   	pop    %ebp
  105dad:	c3                   	ret    

00105dae <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105dae:	55                   	push   %ebp
  105daf:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105db1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105db5:	7e 14                	jle    105dcb <getint+0x1d>
        return va_arg(*ap, long long);
  105db7:	8b 45 08             	mov    0x8(%ebp),%eax
  105dba:	8b 00                	mov    (%eax),%eax
  105dbc:	8d 48 08             	lea    0x8(%eax),%ecx
  105dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  105dc2:	89 0a                	mov    %ecx,(%edx)
  105dc4:	8b 50 04             	mov    0x4(%eax),%edx
  105dc7:	8b 00                	mov    (%eax),%eax
  105dc9:	eb 28                	jmp    105df3 <getint+0x45>
    }
    else if (lflag) {
  105dcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105dcf:	74 12                	je     105de3 <getint+0x35>
        return va_arg(*ap, long);
  105dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd4:	8b 00                	mov    (%eax),%eax
  105dd6:	8d 48 04             	lea    0x4(%eax),%ecx
  105dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  105ddc:	89 0a                	mov    %ecx,(%edx)
  105dde:	8b 00                	mov    (%eax),%eax
  105de0:	99                   	cltd   
  105de1:	eb 10                	jmp    105df3 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105de3:	8b 45 08             	mov    0x8(%ebp),%eax
  105de6:	8b 00                	mov    (%eax),%eax
  105de8:	8d 48 04             	lea    0x4(%eax),%ecx
  105deb:	8b 55 08             	mov    0x8(%ebp),%edx
  105dee:	89 0a                	mov    %ecx,(%edx)
  105df0:	8b 00                	mov    (%eax),%eax
  105df2:	99                   	cltd   
    }
}
  105df3:	5d                   	pop    %ebp
  105df4:	c3                   	ret    

00105df5 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105df5:	55                   	push   %ebp
  105df6:	89 e5                	mov    %esp,%ebp
  105df8:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  105dfb:	8d 45 14             	lea    0x14(%ebp),%eax
  105dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e04:	50                   	push   %eax
  105e05:	ff 75 10             	pushl  0x10(%ebp)
  105e08:	ff 75 0c             	pushl  0xc(%ebp)
  105e0b:	ff 75 08             	pushl  0x8(%ebp)
  105e0e:	e8 06 00 00 00       	call   105e19 <vprintfmt>
  105e13:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  105e16:	90                   	nop
  105e17:	c9                   	leave  
  105e18:	c3                   	ret    

00105e19 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105e19:	55                   	push   %ebp
  105e1a:	89 e5                	mov    %esp,%ebp
  105e1c:	56                   	push   %esi
  105e1d:	53                   	push   %ebx
  105e1e:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105e21:	eb 17                	jmp    105e3a <vprintfmt+0x21>
            if (ch == '\0') {
  105e23:	85 db                	test   %ebx,%ebx
  105e25:	0f 84 8e 03 00 00    	je     1061b9 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  105e2b:	83 ec 08             	sub    $0x8,%esp
  105e2e:	ff 75 0c             	pushl  0xc(%ebp)
  105e31:	53                   	push   %ebx
  105e32:	8b 45 08             	mov    0x8(%ebp),%eax
  105e35:	ff d0                	call   *%eax
  105e37:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  105e3d:	8d 50 01             	lea    0x1(%eax),%edx
  105e40:	89 55 10             	mov    %edx,0x10(%ebp)
  105e43:	0f b6 00             	movzbl (%eax),%eax
  105e46:	0f b6 d8             	movzbl %al,%ebx
  105e49:	83 fb 25             	cmp    $0x25,%ebx
  105e4c:	75 d5                	jne    105e23 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105e4e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105e52:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105e59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105e5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105e5f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105e66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e69:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  105e6f:	8d 50 01             	lea    0x1(%eax),%edx
  105e72:	89 55 10             	mov    %edx,0x10(%ebp)
  105e75:	0f b6 00             	movzbl (%eax),%eax
  105e78:	0f b6 d8             	movzbl %al,%ebx
  105e7b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105e7e:	83 f8 55             	cmp    $0x55,%eax
  105e81:	0f 87 05 03 00 00    	ja     10618c <vprintfmt+0x373>
  105e87:	8b 04 85 58 74 10 00 	mov    0x107458(,%eax,4),%eax
  105e8e:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105e90:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105e94:	eb d6                	jmp    105e6c <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105e96:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105e9a:	eb d0                	jmp    105e6c <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105e9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105ea3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ea6:	89 d0                	mov    %edx,%eax
  105ea8:	c1 e0 02             	shl    $0x2,%eax
  105eab:	01 d0                	add    %edx,%eax
  105ead:	01 c0                	add    %eax,%eax
  105eaf:	01 d8                	add    %ebx,%eax
  105eb1:	83 e8 30             	sub    $0x30,%eax
  105eb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  105eba:	0f b6 00             	movzbl (%eax),%eax
  105ebd:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105ec0:	83 fb 2f             	cmp    $0x2f,%ebx
  105ec3:	7e 39                	jle    105efe <vprintfmt+0xe5>
  105ec5:	83 fb 39             	cmp    $0x39,%ebx
  105ec8:	7f 34                	jg     105efe <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105eca:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105ece:	eb d3                	jmp    105ea3 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105ed0:	8b 45 14             	mov    0x14(%ebp),%eax
  105ed3:	8d 50 04             	lea    0x4(%eax),%edx
  105ed6:	89 55 14             	mov    %edx,0x14(%ebp)
  105ed9:	8b 00                	mov    (%eax),%eax
  105edb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105ede:	eb 1f                	jmp    105eff <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  105ee0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105ee4:	79 86                	jns    105e6c <vprintfmt+0x53>
                width = 0;
  105ee6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105eed:	e9 7a ff ff ff       	jmp    105e6c <vprintfmt+0x53>

        case '#':
            altflag = 1;
  105ef2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105ef9:	e9 6e ff ff ff       	jmp    105e6c <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  105efe:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  105eff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105f03:	0f 89 63 ff ff ff    	jns    105e6c <vprintfmt+0x53>
                width = precision, precision = -1;
  105f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105f0f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105f16:	e9 51 ff ff ff       	jmp    105e6c <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105f1b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105f1f:	e9 48 ff ff ff       	jmp    105e6c <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105f24:	8b 45 14             	mov    0x14(%ebp),%eax
  105f27:	8d 50 04             	lea    0x4(%eax),%edx
  105f2a:	89 55 14             	mov    %edx,0x14(%ebp)
  105f2d:	8b 00                	mov    (%eax),%eax
  105f2f:	83 ec 08             	sub    $0x8,%esp
  105f32:	ff 75 0c             	pushl  0xc(%ebp)
  105f35:	50                   	push   %eax
  105f36:	8b 45 08             	mov    0x8(%ebp),%eax
  105f39:	ff d0                	call   *%eax
  105f3b:	83 c4 10             	add    $0x10,%esp
            break;
  105f3e:	e9 71 02 00 00       	jmp    1061b4 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105f43:	8b 45 14             	mov    0x14(%ebp),%eax
  105f46:	8d 50 04             	lea    0x4(%eax),%edx
  105f49:	89 55 14             	mov    %edx,0x14(%ebp)
  105f4c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105f4e:	85 db                	test   %ebx,%ebx
  105f50:	79 02                	jns    105f54 <vprintfmt+0x13b>
                err = -err;
  105f52:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105f54:	83 fb 06             	cmp    $0x6,%ebx
  105f57:	7f 0b                	jg     105f64 <vprintfmt+0x14b>
  105f59:	8b 34 9d 18 74 10 00 	mov    0x107418(,%ebx,4),%esi
  105f60:	85 f6                	test   %esi,%esi
  105f62:	75 19                	jne    105f7d <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  105f64:	53                   	push   %ebx
  105f65:	68 45 74 10 00       	push   $0x107445
  105f6a:	ff 75 0c             	pushl  0xc(%ebp)
  105f6d:	ff 75 08             	pushl  0x8(%ebp)
  105f70:	e8 80 fe ff ff       	call   105df5 <printfmt>
  105f75:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105f78:	e9 37 02 00 00       	jmp    1061b4 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105f7d:	56                   	push   %esi
  105f7e:	68 4e 74 10 00       	push   $0x10744e
  105f83:	ff 75 0c             	pushl  0xc(%ebp)
  105f86:	ff 75 08             	pushl  0x8(%ebp)
  105f89:	e8 67 fe ff ff       	call   105df5 <printfmt>
  105f8e:	83 c4 10             	add    $0x10,%esp
            }
            break;
  105f91:	e9 1e 02 00 00       	jmp    1061b4 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105f96:	8b 45 14             	mov    0x14(%ebp),%eax
  105f99:	8d 50 04             	lea    0x4(%eax),%edx
  105f9c:	89 55 14             	mov    %edx,0x14(%ebp)
  105f9f:	8b 30                	mov    (%eax),%esi
  105fa1:	85 f6                	test   %esi,%esi
  105fa3:	75 05                	jne    105faa <vprintfmt+0x191>
                p = "(null)";
  105fa5:	be 51 74 10 00       	mov    $0x107451,%esi
            }
            if (width > 0 && padc != '-') {
  105faa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105fae:	7e 76                	jle    106026 <vprintfmt+0x20d>
  105fb0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105fb4:	74 70                	je     106026 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105fb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105fb9:	83 ec 08             	sub    $0x8,%esp
  105fbc:	50                   	push   %eax
  105fbd:	56                   	push   %esi
  105fbe:	e8 17 f8 ff ff       	call   1057da <strnlen>
  105fc3:	83 c4 10             	add    $0x10,%esp
  105fc6:	89 c2                	mov    %eax,%edx
  105fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105fcb:	29 d0                	sub    %edx,%eax
  105fcd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105fd0:	eb 17                	jmp    105fe9 <vprintfmt+0x1d0>
                    putch(padc, putdat);
  105fd2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105fd6:	83 ec 08             	sub    $0x8,%esp
  105fd9:	ff 75 0c             	pushl  0xc(%ebp)
  105fdc:	50                   	push   %eax
  105fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  105fe0:	ff d0                	call   *%eax
  105fe2:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105fe5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105fe9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105fed:	7f e3                	jg     105fd2 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105fef:	eb 35                	jmp    106026 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  105ff1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105ff5:	74 1c                	je     106013 <vprintfmt+0x1fa>
  105ff7:	83 fb 1f             	cmp    $0x1f,%ebx
  105ffa:	7e 05                	jle    106001 <vprintfmt+0x1e8>
  105ffc:	83 fb 7e             	cmp    $0x7e,%ebx
  105fff:	7e 12                	jle    106013 <vprintfmt+0x1fa>
                    putch('?', putdat);
  106001:	83 ec 08             	sub    $0x8,%esp
  106004:	ff 75 0c             	pushl  0xc(%ebp)
  106007:	6a 3f                	push   $0x3f
  106009:	8b 45 08             	mov    0x8(%ebp),%eax
  10600c:	ff d0                	call   *%eax
  10600e:	83 c4 10             	add    $0x10,%esp
  106011:	eb 0f                	jmp    106022 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  106013:	83 ec 08             	sub    $0x8,%esp
  106016:	ff 75 0c             	pushl  0xc(%ebp)
  106019:	53                   	push   %ebx
  10601a:	8b 45 08             	mov    0x8(%ebp),%eax
  10601d:	ff d0                	call   *%eax
  10601f:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106022:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  106026:	89 f0                	mov    %esi,%eax
  106028:	8d 70 01             	lea    0x1(%eax),%esi
  10602b:	0f b6 00             	movzbl (%eax),%eax
  10602e:	0f be d8             	movsbl %al,%ebx
  106031:	85 db                	test   %ebx,%ebx
  106033:	74 26                	je     10605b <vprintfmt+0x242>
  106035:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106039:	78 b6                	js     105ff1 <vprintfmt+0x1d8>
  10603b:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10603f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106043:	79 ac                	jns    105ff1 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  106045:	eb 14                	jmp    10605b <vprintfmt+0x242>
                putch(' ', putdat);
  106047:	83 ec 08             	sub    $0x8,%esp
  10604a:	ff 75 0c             	pushl  0xc(%ebp)
  10604d:	6a 20                	push   $0x20
  10604f:	8b 45 08             	mov    0x8(%ebp),%eax
  106052:	ff d0                	call   *%eax
  106054:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  106057:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10605b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10605f:	7f e6                	jg     106047 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  106061:	e9 4e 01 00 00       	jmp    1061b4 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  106066:	83 ec 08             	sub    $0x8,%esp
  106069:	ff 75 e0             	pushl  -0x20(%ebp)
  10606c:	8d 45 14             	lea    0x14(%ebp),%eax
  10606f:	50                   	push   %eax
  106070:	e8 39 fd ff ff       	call   105dae <getint>
  106075:	83 c4 10             	add    $0x10,%esp
  106078:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10607b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10607e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106084:	85 d2                	test   %edx,%edx
  106086:	79 23                	jns    1060ab <vprintfmt+0x292>
                putch('-', putdat);
  106088:	83 ec 08             	sub    $0x8,%esp
  10608b:	ff 75 0c             	pushl  0xc(%ebp)
  10608e:	6a 2d                	push   $0x2d
  106090:	8b 45 08             	mov    0x8(%ebp),%eax
  106093:	ff d0                	call   *%eax
  106095:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  106098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10609b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10609e:	f7 d8                	neg    %eax
  1060a0:	83 d2 00             	adc    $0x0,%edx
  1060a3:	f7 da                	neg    %edx
  1060a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1060ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1060b2:	e9 9f 00 00 00       	jmp    106156 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1060b7:	83 ec 08             	sub    $0x8,%esp
  1060ba:	ff 75 e0             	pushl  -0x20(%ebp)
  1060bd:	8d 45 14             	lea    0x14(%ebp),%eax
  1060c0:	50                   	push   %eax
  1060c1:	e8 99 fc ff ff       	call   105d5f <getuint>
  1060c6:	83 c4 10             	add    $0x10,%esp
  1060c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1060cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1060d6:	eb 7e                	jmp    106156 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1060d8:	83 ec 08             	sub    $0x8,%esp
  1060db:	ff 75 e0             	pushl  -0x20(%ebp)
  1060de:	8d 45 14             	lea    0x14(%ebp),%eax
  1060e1:	50                   	push   %eax
  1060e2:	e8 78 fc ff ff       	call   105d5f <getuint>
  1060e7:	83 c4 10             	add    $0x10,%esp
  1060ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1060f0:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1060f7:	eb 5d                	jmp    106156 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  1060f9:	83 ec 08             	sub    $0x8,%esp
  1060fc:	ff 75 0c             	pushl  0xc(%ebp)
  1060ff:	6a 30                	push   $0x30
  106101:	8b 45 08             	mov    0x8(%ebp),%eax
  106104:	ff d0                	call   *%eax
  106106:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  106109:	83 ec 08             	sub    $0x8,%esp
  10610c:	ff 75 0c             	pushl  0xc(%ebp)
  10610f:	6a 78                	push   $0x78
  106111:	8b 45 08             	mov    0x8(%ebp),%eax
  106114:	ff d0                	call   *%eax
  106116:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  106119:	8b 45 14             	mov    0x14(%ebp),%eax
  10611c:	8d 50 04             	lea    0x4(%eax),%edx
  10611f:	89 55 14             	mov    %edx,0x14(%ebp)
  106122:	8b 00                	mov    (%eax),%eax
  106124:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106127:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10612e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  106135:	eb 1f                	jmp    106156 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  106137:	83 ec 08             	sub    $0x8,%esp
  10613a:	ff 75 e0             	pushl  -0x20(%ebp)
  10613d:	8d 45 14             	lea    0x14(%ebp),%eax
  106140:	50                   	push   %eax
  106141:	e8 19 fc ff ff       	call   105d5f <getuint>
  106146:	83 c4 10             	add    $0x10,%esp
  106149:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10614c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10614f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  106156:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10615a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10615d:	83 ec 04             	sub    $0x4,%esp
  106160:	52                   	push   %edx
  106161:	ff 75 e8             	pushl  -0x18(%ebp)
  106164:	50                   	push   %eax
  106165:	ff 75 f4             	pushl  -0xc(%ebp)
  106168:	ff 75 f0             	pushl  -0x10(%ebp)
  10616b:	ff 75 0c             	pushl  0xc(%ebp)
  10616e:	ff 75 08             	pushl  0x8(%ebp)
  106171:	e8 f8 fa ff ff       	call   105c6e <printnum>
  106176:	83 c4 20             	add    $0x20,%esp
            break;
  106179:	eb 39                	jmp    1061b4 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10617b:	83 ec 08             	sub    $0x8,%esp
  10617e:	ff 75 0c             	pushl  0xc(%ebp)
  106181:	53                   	push   %ebx
  106182:	8b 45 08             	mov    0x8(%ebp),%eax
  106185:	ff d0                	call   *%eax
  106187:	83 c4 10             	add    $0x10,%esp
            break;
  10618a:	eb 28                	jmp    1061b4 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10618c:	83 ec 08             	sub    $0x8,%esp
  10618f:	ff 75 0c             	pushl  0xc(%ebp)
  106192:	6a 25                	push   $0x25
  106194:	8b 45 08             	mov    0x8(%ebp),%eax
  106197:	ff d0                	call   *%eax
  106199:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  10619c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1061a0:	eb 04                	jmp    1061a6 <vprintfmt+0x38d>
  1061a2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1061a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1061a9:	83 e8 01             	sub    $0x1,%eax
  1061ac:	0f b6 00             	movzbl (%eax),%eax
  1061af:	3c 25                	cmp    $0x25,%al
  1061b1:	75 ef                	jne    1061a2 <vprintfmt+0x389>
                /* do nothing */;
            break;
  1061b3:	90                   	nop
        }
    }
  1061b4:	e9 68 fc ff ff       	jmp    105e21 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  1061b9:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1061ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1061bd:	5b                   	pop    %ebx
  1061be:	5e                   	pop    %esi
  1061bf:	5d                   	pop    %ebp
  1061c0:	c3                   	ret    

001061c1 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1061c1:	55                   	push   %ebp
  1061c2:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1061c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061c7:	8b 40 08             	mov    0x8(%eax),%eax
  1061ca:	8d 50 01             	lea    0x1(%eax),%edx
  1061cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061d0:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1061d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061d6:	8b 10                	mov    (%eax),%edx
  1061d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061db:	8b 40 04             	mov    0x4(%eax),%eax
  1061de:	39 c2                	cmp    %eax,%edx
  1061e0:	73 12                	jae    1061f4 <sprintputch+0x33>
        *b->buf ++ = ch;
  1061e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061e5:	8b 00                	mov    (%eax),%eax
  1061e7:	8d 48 01             	lea    0x1(%eax),%ecx
  1061ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  1061ed:	89 0a                	mov    %ecx,(%edx)
  1061ef:	8b 55 08             	mov    0x8(%ebp),%edx
  1061f2:	88 10                	mov    %dl,(%eax)
    }
}
  1061f4:	90                   	nop
  1061f5:	5d                   	pop    %ebp
  1061f6:	c3                   	ret    

001061f7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1061f7:	55                   	push   %ebp
  1061f8:	89 e5                	mov    %esp,%ebp
  1061fa:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1061fd:	8d 45 14             	lea    0x14(%ebp),%eax
  106200:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106206:	50                   	push   %eax
  106207:	ff 75 10             	pushl  0x10(%ebp)
  10620a:	ff 75 0c             	pushl  0xc(%ebp)
  10620d:	ff 75 08             	pushl  0x8(%ebp)
  106210:	e8 0b 00 00 00       	call   106220 <vsnprintf>
  106215:	83 c4 10             	add    $0x10,%esp
  106218:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10621b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10621e:	c9                   	leave  
  10621f:	c3                   	ret    

00106220 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  106220:	55                   	push   %ebp
  106221:	89 e5                	mov    %esp,%ebp
  106223:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  106226:	8b 45 08             	mov    0x8(%ebp),%eax
  106229:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10622c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10622f:	8d 50 ff             	lea    -0x1(%eax),%edx
  106232:	8b 45 08             	mov    0x8(%ebp),%eax
  106235:	01 d0                	add    %edx,%eax
  106237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10623a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  106241:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106245:	74 0a                	je     106251 <vsnprintf+0x31>
  106247:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10624a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10624d:	39 c2                	cmp    %eax,%edx
  10624f:	76 07                	jbe    106258 <vsnprintf+0x38>
        return -E_INVAL;
  106251:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  106256:	eb 20                	jmp    106278 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  106258:	ff 75 14             	pushl  0x14(%ebp)
  10625b:	ff 75 10             	pushl  0x10(%ebp)
  10625e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  106261:	50                   	push   %eax
  106262:	68 c1 61 10 00       	push   $0x1061c1
  106267:	e8 ad fb ff ff       	call   105e19 <vprintfmt>
  10626c:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  10626f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106272:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  106275:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106278:	c9                   	leave  
  106279:	c3                   	ret    

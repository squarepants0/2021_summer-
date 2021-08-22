
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 c9 2c 00 00       	call   102ced <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 32 15 00 00       	call   10155e <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 a0 34 10 00 	movl   $0x1034a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 bc 34 10 00       	push   $0x1034bc
  10003e:	e8 04 02 00 00       	call   100247 <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 86 08 00 00       	call   1008d1 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 74 00 00 00       	call   1000c4 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 5c 29 00 00       	call   1029b1 <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 47 16 00 00       	call   1016a1 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 c9 17 00 00       	call   101828 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 df 0c 00 00       	call   100d43 <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 75 17 00 00       	call   1017de <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    // lab1_switch_test();

    /* do nothing */
    while (1);
  100069:	eb fe                	jmp    100069 <kern_init+0x69>

0010006b <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10006b:	55                   	push   %ebp
  10006c:	89 e5                	mov    %esp,%ebp
  10006e:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100071:	83 ec 04             	sub    $0x4,%esp
  100074:	6a 00                	push   $0x0
  100076:	6a 00                	push   $0x0
  100078:	6a 00                	push   $0x0
  10007a:	e8 b2 0c 00 00       	call   100d31 <mon_backtrace>
  10007f:	83 c4 10             	add    $0x10,%esp
}
  100082:	90                   	nop
  100083:	c9                   	leave  
  100084:	c3                   	ret    

00100085 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100085:	55                   	push   %ebp
  100086:	89 e5                	mov    %esp,%ebp
  100088:	53                   	push   %ebx
  100089:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10008c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10008f:	8b 55 0c             	mov    0xc(%ebp),%edx
  100092:	8d 5d 08             	lea    0x8(%ebp),%ebx
  100095:	8b 45 08             	mov    0x8(%ebp),%eax
  100098:	51                   	push   %ecx
  100099:	52                   	push   %edx
  10009a:	53                   	push   %ebx
  10009b:	50                   	push   %eax
  10009c:	e8 ca ff ff ff       	call   10006b <grade_backtrace2>
  1000a1:	83 c4 10             	add    $0x10,%esp
}
  1000a4:	90                   	nop
  1000a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000a8:	c9                   	leave  
  1000a9:	c3                   	ret    

001000aa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000aa:	55                   	push   %ebp
  1000ab:	89 e5                	mov    %esp,%ebp
  1000ad:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b0:	83 ec 08             	sub    $0x8,%esp
  1000b3:	ff 75 10             	pushl  0x10(%ebp)
  1000b6:	ff 75 08             	pushl  0x8(%ebp)
  1000b9:	e8 c7 ff ff ff       	call   100085 <grade_backtrace1>
  1000be:	83 c4 10             	add    $0x10,%esp
}
  1000c1:	90                   	nop
  1000c2:	c9                   	leave  
  1000c3:	c3                   	ret    

001000c4 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c4:	55                   	push   %ebp
  1000c5:	89 e5                	mov    %esp,%ebp
  1000c7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000ca:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000cf:	83 ec 04             	sub    $0x4,%esp
  1000d2:	68 00 00 ff ff       	push   $0xffff0000
  1000d7:	50                   	push   %eax
  1000d8:	6a 00                	push   $0x0
  1000da:	e8 cb ff ff ff       	call   1000aa <grade_backtrace0>
  1000df:	83 c4 10             	add    $0x10,%esp
}
  1000e2:	90                   	nop
  1000e3:	c9                   	leave  
  1000e4:	c3                   	ret    

001000e5 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000e5:	55                   	push   %ebp
  1000e6:	89 e5                	mov    %esp,%ebp
  1000e8:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000eb:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000ee:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f1:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f4:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000f7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1000fb:	0f b7 c0             	movzwl %ax,%eax
  1000fe:	83 e0 03             	and    $0x3,%eax
  100101:	89 c2                	mov    %eax,%edx
  100103:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100108:	83 ec 04             	sub    $0x4,%esp
  10010b:	52                   	push   %edx
  10010c:	50                   	push   %eax
  10010d:	68 c1 34 10 00       	push   $0x1034c1
  100112:	e8 30 01 00 00       	call   100247 <cprintf>
  100117:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011e:	0f b7 d0             	movzwl %ax,%edx
  100121:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100126:	83 ec 04             	sub    $0x4,%esp
  100129:	52                   	push   %edx
  10012a:	50                   	push   %eax
  10012b:	68 cf 34 10 00       	push   $0x1034cf
  100130:	e8 12 01 00 00       	call   100247 <cprintf>
  100135:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100138:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10013c:	0f b7 d0             	movzwl %ax,%edx
  10013f:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100144:	83 ec 04             	sub    $0x4,%esp
  100147:	52                   	push   %edx
  100148:	50                   	push   %eax
  100149:	68 dd 34 10 00       	push   $0x1034dd
  10014e:	e8 f4 00 00 00       	call   100247 <cprintf>
  100153:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100156:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015a:	0f b7 d0             	movzwl %ax,%edx
  10015d:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100162:	83 ec 04             	sub    $0x4,%esp
  100165:	52                   	push   %edx
  100166:	50                   	push   %eax
  100167:	68 eb 34 10 00       	push   $0x1034eb
  10016c:	e8 d6 00 00 00       	call   100247 <cprintf>
  100171:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100174:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100178:	0f b7 d0             	movzwl %ax,%edx
  10017b:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100180:	83 ec 04             	sub    $0x4,%esp
  100183:	52                   	push   %edx
  100184:	50                   	push   %eax
  100185:	68 f9 34 10 00       	push   $0x1034f9
  10018a:	e8 b8 00 00 00       	call   100247 <cprintf>
  10018f:	83 c4 10             	add    $0x10,%esp
    round ++;
  100192:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100197:	83 c0 01             	add    $0x1,%eax
  10019a:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  10019f:	90                   	nop
  1001a0:	c9                   	leave  
  1001a1:	c3                   	ret    

001001a2 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a2:	55                   	push   %ebp
  1001a3:	89 e5                	mov    %esp,%ebp
    asm volatile(
  1001a5:	6a 23                	push   $0x23
  1001a7:	54                   	push   %esp
  1001a8:	cd 78                	int    $0x78
  1001aa:	5d                   	pop    %ebp
        "int %0;"
        "popl %%ebp;"
        :
        :"i"(T_SWITCH_TOU)
    );
}
  1001ab:	90                   	nop
  1001ac:	5d                   	pop    %ebp
  1001ad:	c3                   	ret    

001001ae <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001ae:	55                   	push   %ebp
  1001af:	89 e5                	mov    %esp,%ebp
    asm volatile(
  1001b1:	cd 79                	int    $0x79
  1001b3:	89 ec                	mov    %ebp,%esp
        "int %0;"
        "movl %%ebp, %%esp;"
        :
        :"i"(T_SWITCH_TOK)
    );
}
  1001b5:	90                   	nop
  1001b6:	5d                   	pop    %ebp
  1001b7:	c3                   	ret    

001001b8 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001b8:	55                   	push   %ebp
  1001b9:	89 e5                	mov    %esp,%ebp
  1001bb:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001be:	e8 22 ff ff ff       	call   1000e5 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001c3:	83 ec 0c             	sub    $0xc,%esp
  1001c6:	68 08 35 10 00       	push   $0x103508
  1001cb:	e8 77 00 00 00       	call   100247 <cprintf>
  1001d0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001d3:	e8 ca ff ff ff       	call   1001a2 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001d8:	e8 08 ff ff ff       	call   1000e5 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001dd:	83 ec 0c             	sub    $0xc,%esp
  1001e0:	68 28 35 10 00       	push   $0x103528
  1001e5:	e8 5d 00 00 00       	call   100247 <cprintf>
  1001ea:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001ed:	e8 bc ff ff ff       	call   1001ae <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001f2:	e8 ee fe ff ff       	call   1000e5 <lab1_print_cur_status>
}
  1001f7:	90                   	nop
  1001f8:	c9                   	leave  
  1001f9:	c3                   	ret    

001001fa <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100200:	83 ec 0c             	sub    $0xc,%esp
  100203:	ff 75 08             	pushl  0x8(%ebp)
  100206:	e8 84 13 00 00       	call   10158f <cons_putc>
  10020b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  10020e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100211:	8b 00                	mov    (%eax),%eax
  100213:	8d 50 01             	lea    0x1(%eax),%edx
  100216:	8b 45 0c             	mov    0xc(%ebp),%eax
  100219:	89 10                	mov    %edx,(%eax)
}
  10021b:	90                   	nop
  10021c:	c9                   	leave  
  10021d:	c3                   	ret    

0010021e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10021e:	55                   	push   %ebp
  10021f:	89 e5                	mov    %esp,%ebp
  100221:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10022b:	ff 75 0c             	pushl  0xc(%ebp)
  10022e:	ff 75 08             	pushl  0x8(%ebp)
  100231:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100234:	50                   	push   %eax
  100235:	68 fa 01 10 00       	push   $0x1001fa
  10023a:	e8 e4 2d 00 00       	call   103023 <vprintfmt>
  10023f:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100242:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100245:	c9                   	leave  
  100246:	c3                   	ret    

00100247 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100247:	55                   	push   %ebp
  100248:	89 e5                	mov    %esp,%ebp
  10024a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10024d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100250:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	83 ec 08             	sub    $0x8,%esp
  100259:	50                   	push   %eax
  10025a:	ff 75 08             	pushl  0x8(%ebp)
  10025d:	e8 bc ff ff ff       	call   10021e <vcprintf>
  100262:	83 c4 10             	add    $0x10,%esp
  100265:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100268:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10026b:	c9                   	leave  
  10026c:	c3                   	ret    

0010026d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10026d:	55                   	push   %ebp
  10026e:	89 e5                	mov    %esp,%ebp
  100270:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100273:	83 ec 0c             	sub    $0xc,%esp
  100276:	ff 75 08             	pushl  0x8(%ebp)
  100279:	e8 11 13 00 00       	call   10158f <cons_putc>
  10027e:	83 c4 10             	add    $0x10,%esp
}
  100281:	90                   	nop
  100282:	c9                   	leave  
  100283:	c3                   	ret    

00100284 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100284:	55                   	push   %ebp
  100285:	89 e5                	mov    %esp,%ebp
  100287:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10028a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100291:	eb 14                	jmp    1002a7 <cputs+0x23>
        cputch(c, &cnt);
  100293:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100297:	83 ec 08             	sub    $0x8,%esp
  10029a:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10029d:	52                   	push   %edx
  10029e:	50                   	push   %eax
  10029f:	e8 56 ff ff ff       	call   1001fa <cputch>
  1002a4:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002aa:	8d 50 01             	lea    0x1(%eax),%edx
  1002ad:	89 55 08             	mov    %edx,0x8(%ebp)
  1002b0:	0f b6 00             	movzbl (%eax),%eax
  1002b3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002b6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002ba:	75 d7                	jne    100293 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002bc:	83 ec 08             	sub    $0x8,%esp
  1002bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002c2:	50                   	push   %eax
  1002c3:	6a 0a                	push   $0xa
  1002c5:	e8 30 ff ff ff       	call   1001fa <cputch>
  1002ca:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002d0:	c9                   	leave  
  1002d1:	c3                   	ret    

001002d2 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002d2:	55                   	push   %ebp
  1002d3:	89 e5                	mov    %esp,%ebp
  1002d5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002d8:	e8 e2 12 00 00       	call   1015bf <cons_getc>
  1002dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002e4:	74 f2                	je     1002d8 <getchar+0x6>
        /* do nothing */;
    return c;
  1002e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002e9:	c9                   	leave  
  1002ea:	c3                   	ret    

001002eb <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002eb:	55                   	push   %ebp
  1002ec:	89 e5                	mov    %esp,%ebp
  1002ee:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1002f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002f5:	74 13                	je     10030a <readline+0x1f>
        cprintf("%s", prompt);
  1002f7:	83 ec 08             	sub    $0x8,%esp
  1002fa:	ff 75 08             	pushl  0x8(%ebp)
  1002fd:	68 47 35 10 00       	push   $0x103547
  100302:	e8 40 ff ff ff       	call   100247 <cprintf>
  100307:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10030a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100311:	e8 bc ff ff ff       	call   1002d2 <getchar>
  100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100319:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10031d:	79 0a                	jns    100329 <readline+0x3e>
            return NULL;
  10031f:	b8 00 00 00 00       	mov    $0x0,%eax
  100324:	e9 82 00 00 00       	jmp    1003ab <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100329:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10032d:	7e 2b                	jle    10035a <readline+0x6f>
  10032f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100336:	7f 22                	jg     10035a <readline+0x6f>
            cputchar(c);
  100338:	83 ec 0c             	sub    $0xc,%esp
  10033b:	ff 75 f0             	pushl  -0x10(%ebp)
  10033e:	e8 2a ff ff ff       	call   10026d <cputchar>
  100343:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100349:	8d 50 01             	lea    0x1(%eax),%edx
  10034c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10034f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100352:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100358:	eb 4c                	jmp    1003a6 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10035a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10035e:	75 1a                	jne    10037a <readline+0x8f>
  100360:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100364:	7e 14                	jle    10037a <readline+0x8f>
            cputchar(c);
  100366:	83 ec 0c             	sub    $0xc,%esp
  100369:	ff 75 f0             	pushl  -0x10(%ebp)
  10036c:	e8 fc fe ff ff       	call   10026d <cputchar>
  100371:	83 c4 10             	add    $0x10,%esp
            i --;
  100374:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100378:	eb 2c                	jmp    1003a6 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  10037a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10037e:	74 06                	je     100386 <readline+0x9b>
  100380:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100384:	75 8b                	jne    100311 <readline+0x26>
            cputchar(c);
  100386:	83 ec 0c             	sub    $0xc,%esp
  100389:	ff 75 f0             	pushl  -0x10(%ebp)
  10038c:	e8 dc fe ff ff       	call   10026d <cputchar>
  100391:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  100394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100397:	05 40 ea 10 00       	add    $0x10ea40,%eax
  10039c:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  10039f:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003a4:	eb 05                	jmp    1003ab <readline+0xc0>
        }
    }
  1003a6:	e9 66 ff ff ff       	jmp    100311 <readline+0x26>
}
  1003ab:	c9                   	leave  
  1003ac:	c3                   	ret    

001003ad <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003ad:	55                   	push   %ebp
  1003ae:	89 e5                	mov    %esp,%ebp
  1003b0:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003b3:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003b8:	85 c0                	test   %eax,%eax
  1003ba:	75 4a                	jne    100406 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003bc:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003c3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003c6:	8d 45 14             	lea    0x14(%ebp),%eax
  1003c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003cc:	83 ec 04             	sub    $0x4,%esp
  1003cf:	ff 75 0c             	pushl  0xc(%ebp)
  1003d2:	ff 75 08             	pushl  0x8(%ebp)
  1003d5:	68 4a 35 10 00       	push   $0x10354a
  1003da:	e8 68 fe ff ff       	call   100247 <cprintf>
  1003df:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003e5:	83 ec 08             	sub    $0x8,%esp
  1003e8:	50                   	push   %eax
  1003e9:	ff 75 10             	pushl  0x10(%ebp)
  1003ec:	e8 2d fe ff ff       	call   10021e <vcprintf>
  1003f1:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1003f4:	83 ec 0c             	sub    $0xc,%esp
  1003f7:	68 66 35 10 00       	push   $0x103566
  1003fc:	e8 46 fe ff ff       	call   100247 <cprintf>
  100401:	83 c4 10             	add    $0x10,%esp
  100404:	eb 01                	jmp    100407 <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  100406:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  100407:	e8 d9 13 00 00       	call   1017e5 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10040c:	83 ec 0c             	sub    $0xc,%esp
  10040f:	6a 00                	push   $0x0
  100411:	e8 41 08 00 00       	call   100c57 <kmonitor>
  100416:	83 c4 10             	add    $0x10,%esp
    }
  100419:	eb f1                	jmp    10040c <__panic+0x5f>

0010041b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10041b:	55                   	push   %ebp
  10041c:	89 e5                	mov    %esp,%ebp
  10041e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100421:	8d 45 14             	lea    0x14(%ebp),%eax
  100424:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100427:	83 ec 04             	sub    $0x4,%esp
  10042a:	ff 75 0c             	pushl  0xc(%ebp)
  10042d:	ff 75 08             	pushl  0x8(%ebp)
  100430:	68 68 35 10 00       	push   $0x103568
  100435:	e8 0d fe ff ff       	call   100247 <cprintf>
  10043a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10043d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100440:	83 ec 08             	sub    $0x8,%esp
  100443:	50                   	push   %eax
  100444:	ff 75 10             	pushl  0x10(%ebp)
  100447:	e8 d2 fd ff ff       	call   10021e <vcprintf>
  10044c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10044f:	83 ec 0c             	sub    $0xc,%esp
  100452:	68 66 35 10 00       	push   $0x103566
  100457:	e8 eb fd ff ff       	call   100247 <cprintf>
  10045c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10045f:	90                   	nop
  100460:	c9                   	leave  
  100461:	c3                   	ret    

00100462 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100462:	55                   	push   %ebp
  100463:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100465:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  10046a:	5d                   	pop    %ebp
  10046b:	c3                   	ret    

0010046c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10046c:	55                   	push   %ebp
  10046d:	89 e5                	mov    %esp,%ebp
  10046f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100472:	8b 45 0c             	mov    0xc(%ebp),%eax
  100475:	8b 00                	mov    (%eax),%eax
  100477:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10047a:	8b 45 10             	mov    0x10(%ebp),%eax
  10047d:	8b 00                	mov    (%eax),%eax
  10047f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100489:	e9 d2 00 00 00       	jmp    100560 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10048e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100491:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100494:	01 d0                	add    %edx,%eax
  100496:	89 c2                	mov    %eax,%edx
  100498:	c1 ea 1f             	shr    $0x1f,%edx
  10049b:	01 d0                	add    %edx,%eax
  10049d:	d1 f8                	sar    %eax
  10049f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004a5:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004a8:	eb 04                	jmp    1004ae <stab_binsearch+0x42>
            m --;
  1004aa:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004b4:	7c 1f                	jl     1004d5 <stab_binsearch+0x69>
  1004b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004b9:	89 d0                	mov    %edx,%eax
  1004bb:	01 c0                	add    %eax,%eax
  1004bd:	01 d0                	add    %edx,%eax
  1004bf:	c1 e0 02             	shl    $0x2,%eax
  1004c2:	89 c2                	mov    %eax,%edx
  1004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1004c7:	01 d0                	add    %edx,%eax
  1004c9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004cd:	0f b6 c0             	movzbl %al,%eax
  1004d0:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004d3:	75 d5                	jne    1004aa <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004db:	7d 0b                	jge    1004e8 <stab_binsearch+0x7c>
            l = true_m + 1;
  1004dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004e0:	83 c0 01             	add    $0x1,%eax
  1004e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004e6:	eb 78                	jmp    100560 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004e8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004f2:	89 d0                	mov    %edx,%eax
  1004f4:	01 c0                	add    %eax,%eax
  1004f6:	01 d0                	add    %edx,%eax
  1004f8:	c1 e0 02             	shl    $0x2,%eax
  1004fb:	89 c2                	mov    %eax,%edx
  1004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100500:	01 d0                	add    %edx,%eax
  100502:	8b 40 08             	mov    0x8(%eax),%eax
  100505:	3b 45 18             	cmp    0x18(%ebp),%eax
  100508:	73 13                	jae    10051d <stab_binsearch+0xb1>
            *region_left = m;
  10050a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100510:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100512:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100515:	83 c0 01             	add    $0x1,%eax
  100518:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10051b:	eb 43                	jmp    100560 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10051d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100520:	89 d0                	mov    %edx,%eax
  100522:	01 c0                	add    %eax,%eax
  100524:	01 d0                	add    %edx,%eax
  100526:	c1 e0 02             	shl    $0x2,%eax
  100529:	89 c2                	mov    %eax,%edx
  10052b:	8b 45 08             	mov    0x8(%ebp),%eax
  10052e:	01 d0                	add    %edx,%eax
  100530:	8b 40 08             	mov    0x8(%eax),%eax
  100533:	3b 45 18             	cmp    0x18(%ebp),%eax
  100536:	76 16                	jbe    10054e <stab_binsearch+0xe2>
            *region_right = m - 1;
  100538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10053b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10053e:	8b 45 10             	mov    0x10(%ebp),%eax
  100541:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100546:	83 e8 01             	sub    $0x1,%eax
  100549:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10054c:	eb 12                	jmp    100560 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100551:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100554:	89 10                	mov    %edx,(%eax)
            l = m;
  100556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100559:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10055c:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100560:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100563:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100566:	0f 8e 22 ff ff ff    	jle    10048e <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  10056c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100570:	75 0f                	jne    100581 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100572:	8b 45 0c             	mov    0xc(%ebp),%eax
  100575:	8b 00                	mov    (%eax),%eax
  100577:	8d 50 ff             	lea    -0x1(%eax),%edx
  10057a:	8b 45 10             	mov    0x10(%ebp),%eax
  10057d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10057f:	eb 3f                	jmp    1005c0 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100581:	8b 45 10             	mov    0x10(%ebp),%eax
  100584:	8b 00                	mov    (%eax),%eax
  100586:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100589:	eb 04                	jmp    10058f <stab_binsearch+0x123>
  10058b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10058f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100592:	8b 00                	mov    (%eax),%eax
  100594:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100597:	7d 1f                	jge    1005b8 <stab_binsearch+0x14c>
  100599:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10059c:	89 d0                	mov    %edx,%eax
  10059e:	01 c0                	add    %eax,%eax
  1005a0:	01 d0                	add    %edx,%eax
  1005a2:	c1 e0 02             	shl    $0x2,%eax
  1005a5:	89 c2                	mov    %eax,%edx
  1005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1005aa:	01 d0                	add    %edx,%eax
  1005ac:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005b0:	0f b6 c0             	movzbl %al,%eax
  1005b3:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005b6:	75 d3                	jne    10058b <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005be:	89 10                	mov    %edx,(%eax)
    }
}
  1005c0:	90                   	nop
  1005c1:	c9                   	leave  
  1005c2:	c3                   	ret    

001005c3 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005c3:	55                   	push   %ebp
  1005c4:	89 e5                	mov    %esp,%ebp
  1005c6:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cc:	c7 00 88 35 10 00    	movl   $0x103588,(%eax)
    info->eip_line = 0;
  1005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005df:	c7 40 08 88 35 10 00 	movl   $0x103588,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e9:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f3:	8b 55 08             	mov    0x8(%ebp),%edx
  1005f6:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100603:	c7 45 f4 cc 3d 10 00 	movl   $0x103dcc,-0xc(%ebp)
    stab_end = __STAB_END__;
  10060a:	c7 45 f0 94 b7 10 00 	movl   $0x10b794,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100611:	c7 45 ec 95 b7 10 00 	movl   $0x10b795,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100618:	c7 45 e8 f1 d7 10 00 	movl   $0x10d7f1,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10061f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100622:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100625:	76 0d                	jbe    100634 <debuginfo_eip+0x71>
  100627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10062a:	83 e8 01             	sub    $0x1,%eax
  10062d:	0f b6 00             	movzbl (%eax),%eax
  100630:	84 c0                	test   %al,%al
  100632:	74 0a                	je     10063e <debuginfo_eip+0x7b>
        return -1;
  100634:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100639:	e9 91 02 00 00       	jmp    1008cf <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10063e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100645:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10064b:	29 c2                	sub    %eax,%edx
  10064d:	89 d0                	mov    %edx,%eax
  10064f:	c1 f8 02             	sar    $0x2,%eax
  100652:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100658:	83 e8 01             	sub    $0x1,%eax
  10065b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10065e:	ff 75 08             	pushl  0x8(%ebp)
  100661:	6a 64                	push   $0x64
  100663:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100666:	50                   	push   %eax
  100667:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10066a:	50                   	push   %eax
  10066b:	ff 75 f4             	pushl  -0xc(%ebp)
  10066e:	e8 f9 fd ff ff       	call   10046c <stab_binsearch>
  100673:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  100676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100679:	85 c0                	test   %eax,%eax
  10067b:	75 0a                	jne    100687 <debuginfo_eip+0xc4>
        return -1;
  10067d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100682:	e9 48 02 00 00       	jmp    1008cf <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10068a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10068d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100690:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100693:	ff 75 08             	pushl  0x8(%ebp)
  100696:	6a 24                	push   $0x24
  100698:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10069b:	50                   	push   %eax
  10069c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10069f:	50                   	push   %eax
  1006a0:	ff 75 f4             	pushl  -0xc(%ebp)
  1006a3:	e8 c4 fd ff ff       	call   10046c <stab_binsearch>
  1006a8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006b1:	39 c2                	cmp    %eax,%edx
  1006b3:	7f 7c                	jg     100731 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b8:	89 c2                	mov    %eax,%edx
  1006ba:	89 d0                	mov    %edx,%eax
  1006bc:	01 c0                	add    %eax,%eax
  1006be:	01 d0                	add    %edx,%eax
  1006c0:	c1 e0 02             	shl    $0x2,%eax
  1006c3:	89 c2                	mov    %eax,%edx
  1006c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006c8:	01 d0                	add    %edx,%eax
  1006ca:	8b 00                	mov    (%eax),%eax
  1006cc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006d2:	29 d1                	sub    %edx,%ecx
  1006d4:	89 ca                	mov    %ecx,%edx
  1006d6:	39 d0                	cmp    %edx,%eax
  1006d8:	73 22                	jae    1006fc <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006dd:	89 c2                	mov    %eax,%edx
  1006df:	89 d0                	mov    %edx,%eax
  1006e1:	01 c0                	add    %eax,%eax
  1006e3:	01 d0                	add    %edx,%eax
  1006e5:	c1 e0 02             	shl    $0x2,%eax
  1006e8:	89 c2                	mov    %eax,%edx
  1006ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ed:	01 d0                	add    %edx,%eax
  1006ef:	8b 10                	mov    (%eax),%edx
  1006f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006f4:	01 c2                	add    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1006fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006ff:	89 c2                	mov    %eax,%edx
  100701:	89 d0                	mov    %edx,%eax
  100703:	01 c0                	add    %eax,%eax
  100705:	01 d0                	add    %edx,%eax
  100707:	c1 e0 02             	shl    $0x2,%eax
  10070a:	89 c2                	mov    %eax,%edx
  10070c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10070f:	01 d0                	add    %edx,%eax
  100711:	8b 50 08             	mov    0x8(%eax),%edx
  100714:	8b 45 0c             	mov    0xc(%ebp),%eax
  100717:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10071a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071d:	8b 40 10             	mov    0x10(%eax),%eax
  100720:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100723:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100726:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100729:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10072c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10072f:	eb 15                	jmp    100746 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100731:	8b 45 0c             	mov    0xc(%ebp),%eax
  100734:	8b 55 08             	mov    0x8(%ebp),%edx
  100737:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10073d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100740:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100743:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100746:	8b 45 0c             	mov    0xc(%ebp),%eax
  100749:	8b 40 08             	mov    0x8(%eax),%eax
  10074c:	83 ec 08             	sub    $0x8,%esp
  10074f:	6a 3a                	push   $0x3a
  100751:	50                   	push   %eax
  100752:	e8 0a 24 00 00       	call   102b61 <strfind>
  100757:	83 c4 10             	add    $0x10,%esp
  10075a:	89 c2                	mov    %eax,%edx
  10075c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075f:	8b 40 08             	mov    0x8(%eax),%eax
  100762:	29 c2                	sub    %eax,%edx
  100764:	8b 45 0c             	mov    0xc(%ebp),%eax
  100767:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10076a:	83 ec 0c             	sub    $0xc,%esp
  10076d:	ff 75 08             	pushl  0x8(%ebp)
  100770:	6a 44                	push   $0x44
  100772:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100775:	50                   	push   %eax
  100776:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100779:	50                   	push   %eax
  10077a:	ff 75 f4             	pushl  -0xc(%ebp)
  10077d:	e8 ea fc ff ff       	call   10046c <stab_binsearch>
  100782:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  100785:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100788:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10078b:	39 c2                	cmp    %eax,%edx
  10078d:	7f 24                	jg     1007b3 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  10078f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100792:	89 c2                	mov    %eax,%edx
  100794:	89 d0                	mov    %edx,%eax
  100796:	01 c0                	add    %eax,%eax
  100798:	01 d0                	add    %edx,%eax
  10079a:	c1 e0 02             	shl    $0x2,%eax
  10079d:	89 c2                	mov    %eax,%edx
  10079f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a2:	01 d0                	add    %edx,%eax
  1007a4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007a8:	0f b7 d0             	movzwl %ax,%edx
  1007ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ae:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007b1:	eb 13                	jmp    1007c6 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007b8:	e9 12 01 00 00       	jmp    1008cf <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c0:	83 e8 01             	sub    $0x1,%eax
  1007c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cc:	39 c2                	cmp    %eax,%edx
  1007ce:	7c 56                	jl     100826 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d3:	89 c2                	mov    %eax,%edx
  1007d5:	89 d0                	mov    %edx,%eax
  1007d7:	01 c0                	add    %eax,%eax
  1007d9:	01 d0                	add    %edx,%eax
  1007db:	c1 e0 02             	shl    $0x2,%eax
  1007de:	89 c2                	mov    %eax,%edx
  1007e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e3:	01 d0                	add    %edx,%eax
  1007e5:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007e9:	3c 84                	cmp    $0x84,%al
  1007eb:	74 39                	je     100826 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f0:	89 c2                	mov    %eax,%edx
  1007f2:	89 d0                	mov    %edx,%eax
  1007f4:	01 c0                	add    %eax,%eax
  1007f6:	01 d0                	add    %edx,%eax
  1007f8:	c1 e0 02             	shl    $0x2,%eax
  1007fb:	89 c2                	mov    %eax,%edx
  1007fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100800:	01 d0                	add    %edx,%eax
  100802:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100806:	3c 64                	cmp    $0x64,%al
  100808:	75 b3                	jne    1007bd <debuginfo_eip+0x1fa>
  10080a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10080d:	89 c2                	mov    %eax,%edx
  10080f:	89 d0                	mov    %edx,%eax
  100811:	01 c0                	add    %eax,%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	c1 e0 02             	shl    $0x2,%eax
  100818:	89 c2                	mov    %eax,%edx
  10081a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10081d:	01 d0                	add    %edx,%eax
  10081f:	8b 40 08             	mov    0x8(%eax),%eax
  100822:	85 c0                	test   %eax,%eax
  100824:	74 97                	je     1007bd <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100826:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10082c:	39 c2                	cmp    %eax,%edx
  10082e:	7c 46                	jl     100876 <debuginfo_eip+0x2b3>
  100830:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100833:	89 c2                	mov    %eax,%edx
  100835:	89 d0                	mov    %edx,%eax
  100837:	01 c0                	add    %eax,%eax
  100839:	01 d0                	add    %edx,%eax
  10083b:	c1 e0 02             	shl    $0x2,%eax
  10083e:	89 c2                	mov    %eax,%edx
  100840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100843:	01 d0                	add    %edx,%eax
  100845:	8b 00                	mov    (%eax),%eax
  100847:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10084a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10084d:	29 d1                	sub    %edx,%ecx
  10084f:	89 ca                	mov    %ecx,%edx
  100851:	39 d0                	cmp    %edx,%eax
  100853:	73 21                	jae    100876 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100855:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100858:	89 c2                	mov    %eax,%edx
  10085a:	89 d0                	mov    %edx,%eax
  10085c:	01 c0                	add    %eax,%eax
  10085e:	01 d0                	add    %edx,%eax
  100860:	c1 e0 02             	shl    $0x2,%eax
  100863:	89 c2                	mov    %eax,%edx
  100865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100868:	01 d0                	add    %edx,%eax
  10086a:	8b 10                	mov    (%eax),%edx
  10086c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10086f:	01 c2                	add    %eax,%edx
  100871:	8b 45 0c             	mov    0xc(%ebp),%eax
  100874:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100876:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100879:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10087c:	39 c2                	cmp    %eax,%edx
  10087e:	7d 4a                	jge    1008ca <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  100880:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100883:	83 c0 01             	add    $0x1,%eax
  100886:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100889:	eb 18                	jmp    1008a3 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10088b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10088e:	8b 40 14             	mov    0x14(%eax),%eax
  100891:	8d 50 01             	lea    0x1(%eax),%edx
  100894:	8b 45 0c             	mov    0xc(%ebp),%eax
  100897:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10089a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089d:	83 c0 01             	add    $0x1,%eax
  1008a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008a9:	39 c2                	cmp    %eax,%edx
  1008ab:	7d 1d                	jge    1008ca <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b0:	89 c2                	mov    %eax,%edx
  1008b2:	89 d0                	mov    %edx,%eax
  1008b4:	01 c0                	add    %eax,%eax
  1008b6:	01 d0                	add    %edx,%eax
  1008b8:	c1 e0 02             	shl    $0x2,%eax
  1008bb:	89 c2                	mov    %eax,%edx
  1008bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c0:	01 d0                	add    %edx,%eax
  1008c2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008c6:	3c a0                	cmp    $0xa0,%al
  1008c8:	74 c1                	je     10088b <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008cf:	c9                   	leave  
  1008d0:	c3                   	ret    

001008d1 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008d1:	55                   	push   %ebp
  1008d2:	89 e5                	mov    %esp,%ebp
  1008d4:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008d7:	83 ec 0c             	sub    $0xc,%esp
  1008da:	68 92 35 10 00       	push   $0x103592
  1008df:	e8 63 f9 ff ff       	call   100247 <cprintf>
  1008e4:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008e7:	83 ec 08             	sub    $0x8,%esp
  1008ea:	68 00 00 10 00       	push   $0x100000
  1008ef:	68 ab 35 10 00       	push   $0x1035ab
  1008f4:	e8 4e f9 ff ff       	call   100247 <cprintf>
  1008f9:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008fc:	83 ec 08             	sub    $0x8,%esp
  1008ff:	68 84 34 10 00       	push   $0x103484
  100904:	68 c3 35 10 00       	push   $0x1035c3
  100909:	e8 39 f9 ff ff       	call   100247 <cprintf>
  10090e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100911:	83 ec 08             	sub    $0x8,%esp
  100914:	68 16 ea 10 00       	push   $0x10ea16
  100919:	68 db 35 10 00       	push   $0x1035db
  10091e:	e8 24 f9 ff ff       	call   100247 <cprintf>
  100923:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100926:	83 ec 08             	sub    $0x8,%esp
  100929:	68 20 fd 10 00       	push   $0x10fd20
  10092e:	68 f3 35 10 00       	push   $0x1035f3
  100933:	e8 0f f9 ff ff       	call   100247 <cprintf>
  100938:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10093b:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  100940:	05 ff 03 00 00       	add    $0x3ff,%eax
  100945:	ba 00 00 10 00       	mov    $0x100000,%edx
  10094a:	29 d0                	sub    %edx,%eax
  10094c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100952:	85 c0                	test   %eax,%eax
  100954:	0f 48 c2             	cmovs  %edx,%eax
  100957:	c1 f8 0a             	sar    $0xa,%eax
  10095a:	83 ec 08             	sub    $0x8,%esp
  10095d:	50                   	push   %eax
  10095e:	68 0c 36 10 00       	push   $0x10360c
  100963:	e8 df f8 ff ff       	call   100247 <cprintf>
  100968:	83 c4 10             	add    $0x10,%esp
}
  10096b:	90                   	nop
  10096c:	c9                   	leave  
  10096d:	c3                   	ret    

0010096e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  10096e:	55                   	push   %ebp
  10096f:	89 e5                	mov    %esp,%ebp
  100971:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100977:	83 ec 08             	sub    $0x8,%esp
  10097a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10097d:	50                   	push   %eax
  10097e:	ff 75 08             	pushl  0x8(%ebp)
  100981:	e8 3d fc ff ff       	call   1005c3 <debuginfo_eip>
  100986:	83 c4 10             	add    $0x10,%esp
  100989:	85 c0                	test   %eax,%eax
  10098b:	74 15                	je     1009a2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10098d:	83 ec 08             	sub    $0x8,%esp
  100990:	ff 75 08             	pushl  0x8(%ebp)
  100993:	68 36 36 10 00       	push   $0x103636
  100998:	e8 aa f8 ff ff       	call   100247 <cprintf>
  10099d:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a0:	eb 65                	jmp    100a07 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009a9:	eb 1c                	jmp    1009c7 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009b1:	01 d0                	add    %edx,%eax
  1009b3:	0f b6 00             	movzbl (%eax),%eax
  1009b6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009bf:	01 ca                	add    %ecx,%edx
  1009c1:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009cd:	7f dc                	jg     1009ab <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009cf:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d8:	01 d0                	add    %edx,%eax
  1009da:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009e0:	8b 55 08             	mov    0x8(%ebp),%edx
  1009e3:	89 d1                	mov    %edx,%ecx
  1009e5:	29 c1                	sub    %eax,%ecx
  1009e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009ed:	83 ec 0c             	sub    $0xc,%esp
  1009f0:	51                   	push   %ecx
  1009f1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009f7:	51                   	push   %ecx
  1009f8:	52                   	push   %edx
  1009f9:	50                   	push   %eax
  1009fa:	68 52 36 10 00       	push   $0x103652
  1009ff:	e8 43 f8 ff ff       	call   100247 <cprintf>
  100a04:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a07:	90                   	nop
  100a08:	c9                   	leave  
  100a09:	c3                   	ret    

00100a0a <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a0a:	55                   	push   %ebp
  100a0b:	89 e5                	mov    %esp,%ebp
  100a0d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a10:	8b 45 04             	mov    0x4(%ebp),%eax
  100a13:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a19:	c9                   	leave  
  100a1a:	c3                   	ret    

00100a1b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a1b:	55                   	push   %ebp
  100a1c:	89 e5                	mov    %esp,%ebp
  100a1e:	53                   	push   %ebx
  100a1f:	83 ec 24             	sub    $0x24,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a22:	89 e8                	mov    %ebp,%eax
  100a24:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
  100a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uintptr_t ebp = read_ebp();
  100a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uintptr_t eip = read_eip();
  100a2d:	e8 d8 ff ff ff       	call   100a0a <read_eip>
  100a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
     uint32_t args[4] = {0};
  100a35:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  100a3c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  100a43:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100a4a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     while(ebp != 0){
  100a51:	e9 85 00 00 00       	jmp    100adb <print_stackframe+0xc0>
        asm volatile("movl 8(%%ebp), %0":"=r"(args[0]));
  100a56:	8b 45 08             	mov    0x8(%ebp),%eax
  100a59:	89 45 dc             	mov    %eax,-0x24(%ebp)
        asm volatile("movl 12(%%ebp), %0":"=r"(args[1]));
  100a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        asm volatile("movl 16(%%ebp), %0":"=r"(args[2]));
  100a62:	8b 45 10             	mov    0x10(%ebp),%eax
  100a65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        asm volatile("movl 20(%%ebp), %0":"=r"(args[3]));
  100a68:	8b 45 14             	mov    0x14(%ebp),%eax
  100a6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        cprintf("ebp:0x%x eip:0x%x ", ebp, eip);
  100a6e:	83 ec 04             	sub    $0x4,%esp
  100a71:	ff 75 f0             	pushl  -0x10(%ebp)
  100a74:	ff 75 f4             	pushl  -0xc(%ebp)
  100a77:	68 64 36 10 00       	push   $0x103664
  100a7c:	e8 c6 f7 ff ff       	call   100247 <cprintf>
  100a81:	83 c4 10             	add    $0x10,%esp
        cprintf("args:0x%x 0x%x ", args[0], args[1]);
  100a84:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a8a:	83 ec 04             	sub    $0x4,%esp
  100a8d:	52                   	push   %edx
  100a8e:	50                   	push   %eax
  100a8f:	68 77 36 10 00       	push   $0x103677
  100a94:	e8 ae f7 ff ff       	call   100247 <cprintf>
  100a99:	83 c4 10             	add    $0x10,%esp
        cprintf("0x%x 0x%x\n", args[2], args[3]);
  100a9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  100a9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100aa2:	83 ec 04             	sub    $0x4,%esp
  100aa5:	52                   	push   %edx
  100aa6:	50                   	push   %eax
  100aa7:	68 87 36 10 00       	push   $0x103687
  100aac:	e8 96 f7 ff ff       	call   100247 <cprintf>
  100ab1:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip-1);
  100ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ab7:	83 e8 01             	sub    $0x1,%eax
  100aba:	83 ec 0c             	sub    $0xc,%esp
  100abd:	50                   	push   %eax
  100abe:	e8 ab fe ff ff       	call   10096e <print_debuginfo>
  100ac3:	83 c4 10             	add    $0x10,%esp

        // asm volatile("movl (%0), %1"::"=r"(ebp), "b"(ebp));
        asm volatile(
  100ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac9:	89 c3                	mov    %eax,%ebx
  100acb:	8b 03                	mov    (%ebx),%eax
  100acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
            "movl (%1), %0;"
            :"=a"(ebp)
            :"b"(ebp)
        );
        // asm volatile("movl 4(%0), %1"::"a"(ebp), "b"(eip));
        asm volatile(
  100ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad3:	89 c3                	mov    %eax,%ebx
  100ad5:	8b 43 04             	mov    0x4(%ebx),%eax
  100ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uintptr_t ebp = read_ebp();
     uintptr_t eip = read_eip();
     uint32_t args[4] = {0};
     while(ebp != 0){
  100adb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100adf:	0f 85 71 ff ff ff    	jne    100a56 <print_stackframe+0x3b>
            "movl 4(%1), %0;"
            :"=a"(eip)
            :"b"(ebp)
        );
     }
}
  100ae5:	90                   	nop
  100ae6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100ae9:	c9                   	leave  
  100aea:	c3                   	ret    

00100aeb <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100aeb:	55                   	push   %ebp
  100aec:	89 e5                	mov    %esp,%ebp
  100aee:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100af1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af8:	eb 0c                	jmp    100b06 <parse+0x1b>
            *buf ++ = '\0';
  100afa:	8b 45 08             	mov    0x8(%ebp),%eax
  100afd:	8d 50 01             	lea    0x1(%eax),%edx
  100b00:	89 55 08             	mov    %edx,0x8(%ebp)
  100b03:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b06:	8b 45 08             	mov    0x8(%ebp),%eax
  100b09:	0f b6 00             	movzbl (%eax),%eax
  100b0c:	84 c0                	test   %al,%al
  100b0e:	74 1e                	je     100b2e <parse+0x43>
  100b10:	8b 45 08             	mov    0x8(%ebp),%eax
  100b13:	0f b6 00             	movzbl (%eax),%eax
  100b16:	0f be c0             	movsbl %al,%eax
  100b19:	83 ec 08             	sub    $0x8,%esp
  100b1c:	50                   	push   %eax
  100b1d:	68 14 37 10 00       	push   $0x103714
  100b22:	e8 07 20 00 00       	call   102b2e <strchr>
  100b27:	83 c4 10             	add    $0x10,%esp
  100b2a:	85 c0                	test   %eax,%eax
  100b2c:	75 cc                	jne    100afa <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b31:	0f b6 00             	movzbl (%eax),%eax
  100b34:	84 c0                	test   %al,%al
  100b36:	74 69                	je     100ba1 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b38:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b3c:	75 12                	jne    100b50 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b3e:	83 ec 08             	sub    $0x8,%esp
  100b41:	6a 10                	push   $0x10
  100b43:	68 19 37 10 00       	push   $0x103719
  100b48:	e8 fa f6 ff ff       	call   100247 <cprintf>
  100b4d:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b53:	8d 50 01             	lea    0x1(%eax),%edx
  100b56:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b63:	01 c2                	add    %eax,%edx
  100b65:	8b 45 08             	mov    0x8(%ebp),%eax
  100b68:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b6a:	eb 04                	jmp    100b70 <parse+0x85>
            buf ++;
  100b6c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b70:	8b 45 08             	mov    0x8(%ebp),%eax
  100b73:	0f b6 00             	movzbl (%eax),%eax
  100b76:	84 c0                	test   %al,%al
  100b78:	0f 84 7a ff ff ff    	je     100af8 <parse+0xd>
  100b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b81:	0f b6 00             	movzbl (%eax),%eax
  100b84:	0f be c0             	movsbl %al,%eax
  100b87:	83 ec 08             	sub    $0x8,%esp
  100b8a:	50                   	push   %eax
  100b8b:	68 14 37 10 00       	push   $0x103714
  100b90:	e8 99 1f 00 00       	call   102b2e <strchr>
  100b95:	83 c4 10             	add    $0x10,%esp
  100b98:	85 c0                	test   %eax,%eax
  100b9a:	74 d0                	je     100b6c <parse+0x81>
            buf ++;
        }
    }
  100b9c:	e9 57 ff ff ff       	jmp    100af8 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100ba1:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100ba5:	c9                   	leave  
  100ba6:	c3                   	ret    

00100ba7 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ba7:	55                   	push   %ebp
  100ba8:	89 e5                	mov    %esp,%ebp
  100baa:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bad:	83 ec 08             	sub    $0x8,%esp
  100bb0:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bb3:	50                   	push   %eax
  100bb4:	ff 75 08             	pushl  0x8(%ebp)
  100bb7:	e8 2f ff ff ff       	call   100aeb <parse>
  100bbc:	83 c4 10             	add    $0x10,%esp
  100bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bc2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bc6:	75 0a                	jne    100bd2 <runcmd+0x2b>
        return 0;
  100bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  100bcd:	e9 83 00 00 00       	jmp    100c55 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bd9:	eb 59                	jmp    100c34 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bdb:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100be1:	89 d0                	mov    %edx,%eax
  100be3:	01 c0                	add    %eax,%eax
  100be5:	01 d0                	add    %edx,%eax
  100be7:	c1 e0 02             	shl    $0x2,%eax
  100bea:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bef:	8b 00                	mov    (%eax),%eax
  100bf1:	83 ec 08             	sub    $0x8,%esp
  100bf4:	51                   	push   %ecx
  100bf5:	50                   	push   %eax
  100bf6:	e8 93 1e 00 00       	call   102a8e <strcmp>
  100bfb:	83 c4 10             	add    $0x10,%esp
  100bfe:	85 c0                	test   %eax,%eax
  100c00:	75 2e                	jne    100c30 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c05:	89 d0                	mov    %edx,%eax
  100c07:	01 c0                	add    %eax,%eax
  100c09:	01 d0                	add    %edx,%eax
  100c0b:	c1 e0 02             	shl    $0x2,%eax
  100c0e:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c13:	8b 10                	mov    (%eax),%edx
  100c15:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c18:	83 c0 04             	add    $0x4,%eax
  100c1b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c1e:	83 e9 01             	sub    $0x1,%ecx
  100c21:	83 ec 04             	sub    $0x4,%esp
  100c24:	ff 75 0c             	pushl  0xc(%ebp)
  100c27:	50                   	push   %eax
  100c28:	51                   	push   %ecx
  100c29:	ff d2                	call   *%edx
  100c2b:	83 c4 10             	add    $0x10,%esp
  100c2e:	eb 25                	jmp    100c55 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c37:	83 f8 02             	cmp    $0x2,%eax
  100c3a:	76 9f                	jbe    100bdb <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c3c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c3f:	83 ec 08             	sub    $0x8,%esp
  100c42:	50                   	push   %eax
  100c43:	68 37 37 10 00       	push   $0x103737
  100c48:	e8 fa f5 ff ff       	call   100247 <cprintf>
  100c4d:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c55:	c9                   	leave  
  100c56:	c3                   	ret    

00100c57 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c57:	55                   	push   %ebp
  100c58:	89 e5                	mov    %esp,%ebp
  100c5a:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c5d:	83 ec 0c             	sub    $0xc,%esp
  100c60:	68 50 37 10 00       	push   $0x103750
  100c65:	e8 dd f5 ff ff       	call   100247 <cprintf>
  100c6a:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c6d:	83 ec 0c             	sub    $0xc,%esp
  100c70:	68 78 37 10 00       	push   $0x103778
  100c75:	e8 cd f5 ff ff       	call   100247 <cprintf>
  100c7a:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c81:	74 0e                	je     100c91 <kmonitor+0x3a>
        print_trapframe(tf);
  100c83:	83 ec 0c             	sub    $0xc,%esp
  100c86:	ff 75 08             	pushl  0x8(%ebp)
  100c89:	e8 57 0d 00 00       	call   1019e5 <print_trapframe>
  100c8e:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c91:	83 ec 0c             	sub    $0xc,%esp
  100c94:	68 9d 37 10 00       	push   $0x10379d
  100c99:	e8 4d f6 ff ff       	call   1002eb <readline>
  100c9e:	83 c4 10             	add    $0x10,%esp
  100ca1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ca4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ca8:	74 e7                	je     100c91 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100caa:	83 ec 08             	sub    $0x8,%esp
  100cad:	ff 75 08             	pushl  0x8(%ebp)
  100cb0:	ff 75 f4             	pushl  -0xc(%ebp)
  100cb3:	e8 ef fe ff ff       	call   100ba7 <runcmd>
  100cb8:	83 c4 10             	add    $0x10,%esp
  100cbb:	85 c0                	test   %eax,%eax
  100cbd:	78 02                	js     100cc1 <kmonitor+0x6a>
                break;
            }
        }
    }
  100cbf:	eb d0                	jmp    100c91 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cc1:	90                   	nop
            }
        }
    }
}
  100cc2:	90                   	nop
  100cc3:	c9                   	leave  
  100cc4:	c3                   	ret    

00100cc5 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cc5:	55                   	push   %ebp
  100cc6:	89 e5                	mov    %esp,%ebp
  100cc8:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ccb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cd2:	eb 3c                	jmp    100d10 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cd7:	89 d0                	mov    %edx,%eax
  100cd9:	01 c0                	add    %eax,%eax
  100cdb:	01 d0                	add    %edx,%eax
  100cdd:	c1 e0 02             	shl    $0x2,%eax
  100ce0:	05 04 e0 10 00       	add    $0x10e004,%eax
  100ce5:	8b 08                	mov    (%eax),%ecx
  100ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cea:	89 d0                	mov    %edx,%eax
  100cec:	01 c0                	add    %eax,%eax
  100cee:	01 d0                	add    %edx,%eax
  100cf0:	c1 e0 02             	shl    $0x2,%eax
  100cf3:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cf8:	8b 00                	mov    (%eax),%eax
  100cfa:	83 ec 04             	sub    $0x4,%esp
  100cfd:	51                   	push   %ecx
  100cfe:	50                   	push   %eax
  100cff:	68 a1 37 10 00       	push   $0x1037a1
  100d04:	e8 3e f5 ff ff       	call   100247 <cprintf>
  100d09:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d0c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d13:	83 f8 02             	cmp    $0x2,%eax
  100d16:	76 bc                	jbe    100cd4 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d1d:	c9                   	leave  
  100d1e:	c3                   	ret    

00100d1f <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d1f:	55                   	push   %ebp
  100d20:	89 e5                	mov    %esp,%ebp
  100d22:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d25:	e8 a7 fb ff ff       	call   1008d1 <print_kerninfo>
    return 0;
  100d2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d2f:	c9                   	leave  
  100d30:	c3                   	ret    

00100d31 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d31:	55                   	push   %ebp
  100d32:	89 e5                	mov    %esp,%ebp
  100d34:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d37:	e8 df fc ff ff       	call   100a1b <print_stackframe>
    return 0;
  100d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d41:	c9                   	leave  
  100d42:	c3                   	ret    

00100d43 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d43:	55                   	push   %ebp
  100d44:	89 e5                	mov    %esp,%ebp
  100d46:	83 ec 18             	sub    $0x18,%esp
  100d49:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d4f:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d53:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d57:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d5b:	ee                   	out    %al,(%dx)
  100d5c:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d62:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d66:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d6a:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d6e:	ee                   	out    %al,(%dx)
  100d6f:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d75:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d79:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d7d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d81:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d82:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d89:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d8c:	83 ec 0c             	sub    $0xc,%esp
  100d8f:	68 aa 37 10 00       	push   $0x1037aa
  100d94:	e8 ae f4 ff ff       	call   100247 <cprintf>
  100d99:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d9c:	83 ec 0c             	sub    $0xc,%esp
  100d9f:	6a 00                	push   $0x0
  100da1:	e8 ce 08 00 00       	call   101674 <pic_enable>
  100da6:	83 c4 10             	add    $0x10,%esp
}
  100da9:	90                   	nop
  100daa:	c9                   	leave  
  100dab:	c3                   	ret    

00100dac <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dac:	55                   	push   %ebp
  100dad:	89 e5                	mov    %esp,%ebp
  100daf:	83 ec 10             	sub    $0x10,%esp
  100db2:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100db8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dbc:	89 c2                	mov    %eax,%edx
  100dbe:	ec                   	in     (%dx),%al
  100dbf:	88 45 f4             	mov    %al,-0xc(%ebp)
  100dc2:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100dc8:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100dcc:	89 c2                	mov    %eax,%edx
  100dce:	ec                   	in     (%dx),%al
  100dcf:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dd2:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ddc:	89 c2                	mov    %eax,%edx
  100dde:	ec                   	in     (%dx),%al
  100ddf:	88 45 f6             	mov    %al,-0xa(%ebp)
  100de2:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100de8:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100dec:	89 c2                	mov    %eax,%edx
  100dee:	ec                   	in     (%dx),%al
  100def:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100df2:	90                   	nop
  100df3:	c9                   	leave  
  100df4:	c3                   	ret    

00100df5 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100df5:	55                   	push   %ebp
  100df6:	89 e5                	mov    %esp,%ebp
  100df8:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100dfb:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e05:	0f b7 00             	movzwl (%eax),%eax
  100e08:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e17:	0f b7 00             	movzwl (%eax),%eax
  100e1a:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e1e:	74 12                	je     100e32 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e20:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e27:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e2e:	b4 03 
  100e30:	eb 13                	jmp    100e45 <cga_init+0x50>
    } else {
        *cp = was;
  100e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e35:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e39:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e3c:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e43:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e45:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e4c:	0f b7 c0             	movzwl %ax,%eax
  100e4f:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e53:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e57:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100e5b:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100e5f:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e60:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e67:	83 c0 01             	add    $0x1,%eax
  100e6a:	0f b7 c0             	movzwl %ax,%eax
  100e6d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e71:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e75:	89 c2                	mov    %eax,%edx
  100e77:	ec                   	in     (%dx),%al
  100e78:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100e7b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100e7f:	0f b6 c0             	movzbl %al,%eax
  100e82:	c1 e0 08             	shl    $0x8,%eax
  100e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e88:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e8f:	0f b7 c0             	movzwl %ax,%eax
  100e92:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100e96:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e9a:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100e9e:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100ea2:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100ea3:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eaa:	83 c0 01             	add    $0x1,%eax
  100ead:	0f b7 c0             	movzwl %ax,%eax
  100eb0:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb4:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eb8:	89 c2                	mov    %eax,%edx
  100eba:	ec                   	in     (%dx),%al
  100ebb:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ebe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ec2:	0f b6 c0             	movzbl %al,%eax
  100ec5:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecb:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ed3:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ed9:	90                   	nop
  100eda:	c9                   	leave  
  100edb:	c3                   	ret    

00100edc <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100edc:	55                   	push   %ebp
  100edd:	89 e5                	mov    %esp,%ebp
  100edf:	83 ec 28             	sub    $0x28,%esp
  100ee2:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ee8:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eec:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100ef0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ef4:	ee                   	out    %al,(%dx)
  100ef5:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100efb:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100eff:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f03:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f07:	ee                   	out    %al,(%dx)
  100f08:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f0e:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f12:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f16:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f1a:	ee                   	out    %al,(%dx)
  100f1b:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f21:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f25:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f29:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f2d:	ee                   	out    %al,(%dx)
  100f2e:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f34:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f38:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f3c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f40:	ee                   	out    %al,(%dx)
  100f41:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f47:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f4b:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f4f:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100f53:	ee                   	out    %al,(%dx)
  100f54:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f5a:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100f5e:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100f62:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f66:	ee                   	out    %al,(%dx)
  100f67:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f6d:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100f71:	89 c2                	mov    %eax,%edx
  100f73:	ec                   	in     (%dx),%al
  100f74:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100f77:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f7b:	3c ff                	cmp    $0xff,%al
  100f7d:	0f 95 c0             	setne  %al
  100f80:	0f b6 c0             	movzbl %al,%eax
  100f83:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f88:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f8e:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f92:	89 c2                	mov    %eax,%edx
  100f94:	ec                   	in     (%dx),%al
  100f95:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100f98:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100f9e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100fa2:	89 c2                	mov    %eax,%edx
  100fa4:	ec                   	in     (%dx),%al
  100fa5:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fa8:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fad:	85 c0                	test   %eax,%eax
  100faf:	74 0d                	je     100fbe <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100fb1:	83 ec 0c             	sub    $0xc,%esp
  100fb4:	6a 04                	push   $0x4
  100fb6:	e8 b9 06 00 00       	call   101674 <pic_enable>
  100fbb:	83 c4 10             	add    $0x10,%esp
    }
}
  100fbe:	90                   	nop
  100fbf:	c9                   	leave  
  100fc0:	c3                   	ret    

00100fc1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fc1:	55                   	push   %ebp
  100fc2:	89 e5                	mov    %esp,%ebp
  100fc4:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fce:	eb 09                	jmp    100fd9 <lpt_putc_sub+0x18>
        delay();
  100fd0:	e8 d7 fd ff ff       	call   100dac <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fd9:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100fdf:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100fe3:	89 c2                	mov    %eax,%edx
  100fe5:	ec                   	in     (%dx),%al
  100fe6:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100fe9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100fed:	84 c0                	test   %al,%al
  100fef:	78 09                	js     100ffa <lpt_putc_sub+0x39>
  100ff1:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ff8:	7e d6                	jle    100fd0 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  100ffd:	0f b6 c0             	movzbl %al,%eax
  101000:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101006:	88 45 f0             	mov    %al,-0x10(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101009:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  10100d:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101011:	ee                   	out    %al,(%dx)
  101012:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101018:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10101c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101020:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101024:	ee                   	out    %al,(%dx)
  101025:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  10102b:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  10102f:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  101033:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101037:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101038:	90                   	nop
  101039:	c9                   	leave  
  10103a:	c3                   	ret    

0010103b <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10103b:	55                   	push   %ebp
  10103c:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10103e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101042:	74 0d                	je     101051 <lpt_putc+0x16>
        lpt_putc_sub(c);
  101044:	ff 75 08             	pushl  0x8(%ebp)
  101047:	e8 75 ff ff ff       	call   100fc1 <lpt_putc_sub>
  10104c:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10104f:	eb 1e                	jmp    10106f <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  101051:	6a 08                	push   $0x8
  101053:	e8 69 ff ff ff       	call   100fc1 <lpt_putc_sub>
  101058:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  10105b:	6a 20                	push   $0x20
  10105d:	e8 5f ff ff ff       	call   100fc1 <lpt_putc_sub>
  101062:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101065:	6a 08                	push   $0x8
  101067:	e8 55 ff ff ff       	call   100fc1 <lpt_putc_sub>
  10106c:	83 c4 04             	add    $0x4,%esp
    }
}
  10106f:	90                   	nop
  101070:	c9                   	leave  
  101071:	c3                   	ret    

00101072 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101072:	55                   	push   %ebp
  101073:	89 e5                	mov    %esp,%ebp
  101075:	53                   	push   %ebx
  101076:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101079:	8b 45 08             	mov    0x8(%ebp),%eax
  10107c:	b0 00                	mov    $0x0,%al
  10107e:	85 c0                	test   %eax,%eax
  101080:	75 07                	jne    101089 <cga_putc+0x17>
        c |= 0x0700;
  101082:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101089:	8b 45 08             	mov    0x8(%ebp),%eax
  10108c:	0f b6 c0             	movzbl %al,%eax
  10108f:	83 f8 0a             	cmp    $0xa,%eax
  101092:	74 4e                	je     1010e2 <cga_putc+0x70>
  101094:	83 f8 0d             	cmp    $0xd,%eax
  101097:	74 59                	je     1010f2 <cga_putc+0x80>
  101099:	83 f8 08             	cmp    $0x8,%eax
  10109c:	0f 85 8a 00 00 00    	jne    10112c <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1010a2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010a9:	66 85 c0             	test   %ax,%ax
  1010ac:	0f 84 a0 00 00 00    	je     101152 <cga_putc+0xe0>
            crt_pos --;
  1010b2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b9:	83 e8 01             	sub    $0x1,%eax
  1010bc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010c2:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010c7:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010ce:	0f b7 d2             	movzwl %dx,%edx
  1010d1:	01 d2                	add    %edx,%edx
  1010d3:	01 d0                	add    %edx,%eax
  1010d5:	8b 55 08             	mov    0x8(%ebp),%edx
  1010d8:	b2 00                	mov    $0x0,%dl
  1010da:	83 ca 20             	or     $0x20,%edx
  1010dd:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010e0:	eb 70                	jmp    101152 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  1010e2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e9:	83 c0 50             	add    $0x50,%eax
  1010ec:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010f2:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010f9:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101100:	0f b7 c1             	movzwl %cx,%eax
  101103:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101109:	c1 e8 10             	shr    $0x10,%eax
  10110c:	89 c2                	mov    %eax,%edx
  10110e:	66 c1 ea 06          	shr    $0x6,%dx
  101112:	89 d0                	mov    %edx,%eax
  101114:	c1 e0 02             	shl    $0x2,%eax
  101117:	01 d0                	add    %edx,%eax
  101119:	c1 e0 04             	shl    $0x4,%eax
  10111c:	29 c1                	sub    %eax,%ecx
  10111e:	89 ca                	mov    %ecx,%edx
  101120:	89 d8                	mov    %ebx,%eax
  101122:	29 d0                	sub    %edx,%eax
  101124:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10112a:	eb 27                	jmp    101153 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10112c:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101132:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101139:	8d 50 01             	lea    0x1(%eax),%edx
  10113c:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101143:	0f b7 c0             	movzwl %ax,%eax
  101146:	01 c0                	add    %eax,%eax
  101148:	01 c8                	add    %ecx,%eax
  10114a:	8b 55 08             	mov    0x8(%ebp),%edx
  10114d:	66 89 10             	mov    %dx,(%eax)
        break;
  101150:	eb 01                	jmp    101153 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  101152:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101153:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10115a:	66 3d cf 07          	cmp    $0x7cf,%ax
  10115e:	76 59                	jbe    1011b9 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101160:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101165:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10116b:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101170:	83 ec 04             	sub    $0x4,%esp
  101173:	68 00 0f 00 00       	push   $0xf00
  101178:	52                   	push   %edx
  101179:	50                   	push   %eax
  10117a:	e8 ae 1b 00 00       	call   102d2d <memmove>
  10117f:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101182:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101189:	eb 15                	jmp    1011a0 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  10118b:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101190:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101193:	01 d2                	add    %edx,%edx
  101195:	01 d0                	add    %edx,%eax
  101197:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10119c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011a0:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011a7:	7e e2                	jle    10118b <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011a9:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011b0:	83 e8 50             	sub    $0x50,%eax
  1011b3:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011b9:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011c0:	0f b7 c0             	movzwl %ax,%eax
  1011c3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011c7:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1011cb:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1011cf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011d3:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011d4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011db:	66 c1 e8 08          	shr    $0x8,%ax
  1011df:	0f b6 c0             	movzbl %al,%eax
  1011e2:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011e9:	83 c2 01             	add    $0x1,%edx
  1011ec:	0f b7 d2             	movzwl %dx,%edx
  1011ef:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  1011f3:	88 45 e9             	mov    %al,-0x17(%ebp)
  1011f6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011fa:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1011fe:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011ff:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101206:	0f b7 c0             	movzwl %ax,%eax
  101209:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10120d:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  101211:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101215:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101219:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10121a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101221:	0f b6 c0             	movzbl %al,%eax
  101224:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10122b:	83 c2 01             	add    $0x1,%edx
  10122e:	0f b7 d2             	movzwl %dx,%edx
  101231:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101235:	88 45 eb             	mov    %al,-0x15(%ebp)
  101238:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10123c:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101240:	ee                   	out    %al,(%dx)
}
  101241:	90                   	nop
  101242:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101245:	c9                   	leave  
  101246:	c3                   	ret    

00101247 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101247:	55                   	push   %ebp
  101248:	89 e5                	mov    %esp,%ebp
  10124a:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10124d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101254:	eb 09                	jmp    10125f <serial_putc_sub+0x18>
        delay();
  101256:	e8 51 fb ff ff       	call   100dac <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10125b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10125f:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101265:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101269:	89 c2                	mov    %eax,%edx
  10126b:	ec                   	in     (%dx),%al
  10126c:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10126f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  101273:	0f b6 c0             	movzbl %al,%eax
  101276:	83 e0 20             	and    $0x20,%eax
  101279:	85 c0                	test   %eax,%eax
  10127b:	75 09                	jne    101286 <serial_putc_sub+0x3f>
  10127d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101284:	7e d0                	jle    101256 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101286:	8b 45 08             	mov    0x8(%ebp),%eax
  101289:	0f b6 c0             	movzbl %al,%eax
  10128c:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  101292:	88 45 f6             	mov    %al,-0xa(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101295:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  101299:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10129d:	ee                   	out    %al,(%dx)
}
  10129e:	90                   	nop
  10129f:	c9                   	leave  
  1012a0:	c3                   	ret    

001012a1 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012a1:	55                   	push   %ebp
  1012a2:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012a4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012a8:	74 0d                	je     1012b7 <serial_putc+0x16>
        serial_putc_sub(c);
  1012aa:	ff 75 08             	pushl  0x8(%ebp)
  1012ad:	e8 95 ff ff ff       	call   101247 <serial_putc_sub>
  1012b2:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012b5:	eb 1e                	jmp    1012d5 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  1012b7:	6a 08                	push   $0x8
  1012b9:	e8 89 ff ff ff       	call   101247 <serial_putc_sub>
  1012be:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012c1:	6a 20                	push   $0x20
  1012c3:	e8 7f ff ff ff       	call   101247 <serial_putc_sub>
  1012c8:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012cb:	6a 08                	push   $0x8
  1012cd:	e8 75 ff ff ff       	call   101247 <serial_putc_sub>
  1012d2:	83 c4 04             	add    $0x4,%esp
    }
}
  1012d5:	90                   	nop
  1012d6:	c9                   	leave  
  1012d7:	c3                   	ret    

001012d8 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012d8:	55                   	push   %ebp
  1012d9:	89 e5                	mov    %esp,%ebp
  1012db:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012de:	eb 33                	jmp    101313 <cons_intr+0x3b>
        if (c != 0) {
  1012e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012e4:	74 2d                	je     101313 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012e6:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012eb:	8d 50 01             	lea    0x1(%eax),%edx
  1012ee:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012f7:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012fd:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101302:	3d 00 02 00 00       	cmp    $0x200,%eax
  101307:	75 0a                	jne    101313 <cons_intr+0x3b>
                cons.wpos = 0;
  101309:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101310:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101313:	8b 45 08             	mov    0x8(%ebp),%eax
  101316:	ff d0                	call   *%eax
  101318:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10131b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10131f:	75 bf                	jne    1012e0 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101321:	90                   	nop
  101322:	c9                   	leave  
  101323:	c3                   	ret    

00101324 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101324:	55                   	push   %ebp
  101325:	89 e5                	mov    %esp,%ebp
  101327:	83 ec 10             	sub    $0x10,%esp
  10132a:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101330:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101334:	89 c2                	mov    %eax,%edx
  101336:	ec                   	in     (%dx),%al
  101337:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10133a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10133e:	0f b6 c0             	movzbl %al,%eax
  101341:	83 e0 01             	and    $0x1,%eax
  101344:	85 c0                	test   %eax,%eax
  101346:	75 07                	jne    10134f <serial_proc_data+0x2b>
        return -1;
  101348:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10134d:	eb 2a                	jmp    101379 <serial_proc_data+0x55>
  10134f:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101355:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101359:	89 c2                	mov    %eax,%edx
  10135b:	ec                   	in     (%dx),%al
  10135c:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  10135f:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101363:	0f b6 c0             	movzbl %al,%eax
  101366:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101369:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10136d:	75 07                	jne    101376 <serial_proc_data+0x52>
        c = '\b';
  10136f:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101376:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101379:	c9                   	leave  
  10137a:	c3                   	ret    

0010137b <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10137b:	55                   	push   %ebp
  10137c:	89 e5                	mov    %esp,%ebp
  10137e:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  101381:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101386:	85 c0                	test   %eax,%eax
  101388:	74 10                	je     10139a <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  10138a:	83 ec 0c             	sub    $0xc,%esp
  10138d:	68 24 13 10 00       	push   $0x101324
  101392:	e8 41 ff ff ff       	call   1012d8 <cons_intr>
  101397:	83 c4 10             	add    $0x10,%esp
    }
}
  10139a:	90                   	nop
  10139b:	c9                   	leave  
  10139c:	c3                   	ret    

0010139d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10139d:	55                   	push   %ebp
  10139e:	89 e5                	mov    %esp,%ebp
  1013a0:	83 ec 18             	sub    $0x18,%esp
  1013a3:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013a9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013ad:	89 c2                	mov    %eax,%edx
  1013af:	ec                   	in     (%dx),%al
  1013b0:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013b3:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013b7:	0f b6 c0             	movzbl %al,%eax
  1013ba:	83 e0 01             	and    $0x1,%eax
  1013bd:	85 c0                	test   %eax,%eax
  1013bf:	75 0a                	jne    1013cb <kbd_proc_data+0x2e>
        return -1;
  1013c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013c6:	e9 5d 01 00 00       	jmp    101528 <kbd_proc_data+0x18b>
  1013cb:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013d5:	89 c2                	mov    %eax,%edx
  1013d7:	ec                   	in     (%dx),%al
  1013d8:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  1013db:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013df:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013e2:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013e6:	75 17                	jne    1013ff <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013e8:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013ed:	83 c8 40             	or     $0x40,%eax
  1013f0:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013f5:	b8 00 00 00 00       	mov    $0x0,%eax
  1013fa:	e9 29 01 00 00       	jmp    101528 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  1013ff:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101403:	84 c0                	test   %al,%al
  101405:	79 47                	jns    10144e <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101407:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10140c:	83 e0 40             	and    $0x40,%eax
  10140f:	85 c0                	test   %eax,%eax
  101411:	75 09                	jne    10141c <kbd_proc_data+0x7f>
  101413:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101417:	83 e0 7f             	and    $0x7f,%eax
  10141a:	eb 04                	jmp    101420 <kbd_proc_data+0x83>
  10141c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101420:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101423:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101427:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10142e:	83 c8 40             	or     $0x40,%eax
  101431:	0f b6 c0             	movzbl %al,%eax
  101434:	f7 d0                	not    %eax
  101436:	89 c2                	mov    %eax,%edx
  101438:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10143d:	21 d0                	and    %edx,%eax
  10143f:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101444:	b8 00 00 00 00       	mov    $0x0,%eax
  101449:	e9 da 00 00 00       	jmp    101528 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10144e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101453:	83 e0 40             	and    $0x40,%eax
  101456:	85 c0                	test   %eax,%eax
  101458:	74 11                	je     10146b <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10145a:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10145e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101463:	83 e0 bf             	and    $0xffffffbf,%eax
  101466:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10146b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146f:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101476:	0f b6 d0             	movzbl %al,%edx
  101479:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147e:	09 d0                	or     %edx,%eax
  101480:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101485:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101489:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101490:	0f b6 d0             	movzbl %al,%edx
  101493:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101498:	31 d0                	xor    %edx,%eax
  10149a:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  10149f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a4:	83 e0 03             	and    $0x3,%eax
  1014a7:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014ae:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b2:	01 d0                	add    %edx,%eax
  1014b4:	0f b6 00             	movzbl (%eax),%eax
  1014b7:	0f b6 c0             	movzbl %al,%eax
  1014ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014bd:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c2:	83 e0 08             	and    $0x8,%eax
  1014c5:	85 c0                	test   %eax,%eax
  1014c7:	74 22                	je     1014eb <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014c9:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014cd:	7e 0c                	jle    1014db <kbd_proc_data+0x13e>
  1014cf:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014d3:	7f 06                	jg     1014db <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014d5:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014d9:	eb 10                	jmp    1014eb <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014db:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014df:	7e 0a                	jle    1014eb <kbd_proc_data+0x14e>
  1014e1:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014e5:	7f 04                	jg     1014eb <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014e7:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014eb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f0:	f7 d0                	not    %eax
  1014f2:	83 e0 06             	and    $0x6,%eax
  1014f5:	85 c0                	test   %eax,%eax
  1014f7:	75 2c                	jne    101525 <kbd_proc_data+0x188>
  1014f9:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101500:	75 23                	jne    101525 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101502:	83 ec 0c             	sub    $0xc,%esp
  101505:	68 c5 37 10 00       	push   $0x1037c5
  10150a:	e8 38 ed ff ff       	call   100247 <cprintf>
  10150f:	83 c4 10             	add    $0x10,%esp
  101512:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101518:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10151c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101520:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101524:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101525:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101528:	c9                   	leave  
  101529:	c3                   	ret    

0010152a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10152a:	55                   	push   %ebp
  10152b:	89 e5                	mov    %esp,%ebp
  10152d:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  101530:	83 ec 0c             	sub    $0xc,%esp
  101533:	68 9d 13 10 00       	push   $0x10139d
  101538:	e8 9b fd ff ff       	call   1012d8 <cons_intr>
  10153d:	83 c4 10             	add    $0x10,%esp
}
  101540:	90                   	nop
  101541:	c9                   	leave  
  101542:	c3                   	ret    

00101543 <kbd_init>:

static void
kbd_init(void) {
  101543:	55                   	push   %ebp
  101544:	89 e5                	mov    %esp,%ebp
  101546:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101549:	e8 dc ff ff ff       	call   10152a <kbd_intr>
    pic_enable(IRQ_KBD);
  10154e:	83 ec 0c             	sub    $0xc,%esp
  101551:	6a 01                	push   $0x1
  101553:	e8 1c 01 00 00       	call   101674 <pic_enable>
  101558:	83 c4 10             	add    $0x10,%esp
}
  10155b:	90                   	nop
  10155c:	c9                   	leave  
  10155d:	c3                   	ret    

0010155e <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10155e:	55                   	push   %ebp
  10155f:	89 e5                	mov    %esp,%ebp
  101561:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101564:	e8 8c f8 ff ff       	call   100df5 <cga_init>
    serial_init();
  101569:	e8 6e f9 ff ff       	call   100edc <serial_init>
    kbd_init();
  10156e:	e8 d0 ff ff ff       	call   101543 <kbd_init>
    if (!serial_exists) {
  101573:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101578:	85 c0                	test   %eax,%eax
  10157a:	75 10                	jne    10158c <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10157c:	83 ec 0c             	sub    $0xc,%esp
  10157f:	68 d1 37 10 00       	push   $0x1037d1
  101584:	e8 be ec ff ff       	call   100247 <cprintf>
  101589:	83 c4 10             	add    $0x10,%esp
    }
}
  10158c:	90                   	nop
  10158d:	c9                   	leave  
  10158e:	c3                   	ret    

0010158f <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10158f:	55                   	push   %ebp
  101590:	89 e5                	mov    %esp,%ebp
  101592:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  101595:	ff 75 08             	pushl  0x8(%ebp)
  101598:	e8 9e fa ff ff       	call   10103b <lpt_putc>
  10159d:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1015a0:	83 ec 0c             	sub    $0xc,%esp
  1015a3:	ff 75 08             	pushl  0x8(%ebp)
  1015a6:	e8 c7 fa ff ff       	call   101072 <cga_putc>
  1015ab:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015ae:	83 ec 0c             	sub    $0xc,%esp
  1015b1:	ff 75 08             	pushl  0x8(%ebp)
  1015b4:	e8 e8 fc ff ff       	call   1012a1 <serial_putc>
  1015b9:	83 c4 10             	add    $0x10,%esp
}
  1015bc:	90                   	nop
  1015bd:	c9                   	leave  
  1015be:	c3                   	ret    

001015bf <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015bf:	55                   	push   %ebp
  1015c0:	89 e5                	mov    %esp,%ebp
  1015c2:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015c5:	e8 b1 fd ff ff       	call   10137b <serial_intr>
    kbd_intr();
  1015ca:	e8 5b ff ff ff       	call   10152a <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015cf:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015d5:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015da:	39 c2                	cmp    %eax,%edx
  1015dc:	74 36                	je     101614 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015de:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015e3:	8d 50 01             	lea    0x1(%eax),%edx
  1015e6:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015ec:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015f3:	0f b6 c0             	movzbl %al,%eax
  1015f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015f9:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015fe:	3d 00 02 00 00       	cmp    $0x200,%eax
  101603:	75 0a                	jne    10160f <cons_getc+0x50>
            cons.rpos = 0;
  101605:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10160c:	00 00 00 
        }
        return c;
  10160f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101612:	eb 05                	jmp    101619 <cons_getc+0x5a>
    }
    return 0;
  101614:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101619:	c9                   	leave  
  10161a:	c3                   	ret    

0010161b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10161b:	55                   	push   %ebp
  10161c:	89 e5                	mov    %esp,%ebp
  10161e:	83 ec 14             	sub    $0x14,%esp
  101621:	8b 45 08             	mov    0x8(%ebp),%eax
  101624:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101628:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10162c:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101632:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101637:	85 c0                	test   %eax,%eax
  101639:	74 36                	je     101671 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10163b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163f:	0f b6 c0             	movzbl %al,%eax
  101642:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101648:	88 45 fa             	mov    %al,-0x6(%ebp)
  10164b:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  10164f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101653:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101654:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101658:	66 c1 e8 08          	shr    $0x8,%ax
  10165c:	0f b6 c0             	movzbl %al,%eax
  10165f:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101665:	88 45 fb             	mov    %al,-0x5(%ebp)
  101668:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  10166c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101670:	ee                   	out    %al,(%dx)
    }
}
  101671:	90                   	nop
  101672:	c9                   	leave  
  101673:	c3                   	ret    

00101674 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101674:	55                   	push   %ebp
  101675:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101677:	8b 45 08             	mov    0x8(%ebp),%eax
  10167a:	ba 01 00 00 00       	mov    $0x1,%edx
  10167f:	89 c1                	mov    %eax,%ecx
  101681:	d3 e2                	shl    %cl,%edx
  101683:	89 d0                	mov    %edx,%eax
  101685:	f7 d0                	not    %eax
  101687:	89 c2                	mov    %eax,%edx
  101689:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101690:	21 d0                	and    %edx,%eax
  101692:	0f b7 c0             	movzwl %ax,%eax
  101695:	50                   	push   %eax
  101696:	e8 80 ff ff ff       	call   10161b <pic_setmask>
  10169b:	83 c4 04             	add    $0x4,%esp
}
  10169e:	90                   	nop
  10169f:	c9                   	leave  
  1016a0:	c3                   	ret    

001016a1 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016a1:	55                   	push   %ebp
  1016a2:	89 e5                	mov    %esp,%ebp
  1016a4:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  1016a7:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016ae:	00 00 00 
  1016b1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016b7:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1016bb:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1016bf:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016c3:	ee                   	out    %al,(%dx)
  1016c4:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016ca:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1016ce:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1016d2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016d6:	ee                   	out    %al,(%dx)
  1016d7:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1016dd:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1016e1:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1016e5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e9:	ee                   	out    %al,(%dx)
  1016ea:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  1016f0:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  1016f4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1016f8:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1016fc:	ee                   	out    %al,(%dx)
  1016fd:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  101703:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101707:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  10170b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10170f:	ee                   	out    %al,(%dx)
  101710:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101716:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  10171a:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10171e:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  101722:	ee                   	out    %al,(%dx)
  101723:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  101729:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  10172d:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  101731:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101735:	ee                   	out    %al,(%dx)
  101736:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  10173c:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  101740:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101744:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101748:	ee                   	out    %al,(%dx)
  101749:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10174f:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  101753:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  101757:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10175b:	ee                   	out    %al,(%dx)
  10175c:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  101762:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  101766:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  10176a:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10176e:	ee                   	out    %al,(%dx)
  10176f:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  101775:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  101779:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  10177d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101781:	ee                   	out    %al,(%dx)
  101782:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101788:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  10178c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101790:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101794:	ee                   	out    %al,(%dx)
  101795:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10179b:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  10179f:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  1017a3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017a7:	ee                   	out    %al,(%dx)
  1017a8:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1017ae:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1017b2:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1017b6:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1017ba:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017bb:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c2:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017c6:	74 13                	je     1017db <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017c8:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017cf:	0f b7 c0             	movzwl %ax,%eax
  1017d2:	50                   	push   %eax
  1017d3:	e8 43 fe ff ff       	call   10161b <pic_setmask>
  1017d8:	83 c4 04             	add    $0x4,%esp
    }
}
  1017db:	90                   	nop
  1017dc:	c9                   	leave  
  1017dd:	c3                   	ret    

001017de <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017de:	55                   	push   %ebp
  1017df:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017e1:	fb                   	sti    
    sti();
}
  1017e2:	90                   	nop
  1017e3:	5d                   	pop    %ebp
  1017e4:	c3                   	ret    

001017e5 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017e5:	55                   	push   %ebp
  1017e6:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017e8:	fa                   	cli    
    cli();
}
  1017e9:	90                   	nop
  1017ea:	5d                   	pop    %ebp
  1017eb:	c3                   	ret    

001017ec <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017ec:	55                   	push   %ebp
  1017ed:	89 e5                	mov    %esp,%ebp
  1017ef:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017f2:	83 ec 08             	sub    $0x8,%esp
  1017f5:	6a 64                	push   $0x64
  1017f7:	68 00 38 10 00       	push   $0x103800
  1017fc:	e8 46 ea ff ff       	call   100247 <cprintf>
  101801:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101804:	83 ec 0c             	sub    $0xc,%esp
  101807:	68 0a 38 10 00       	push   $0x10380a
  10180c:	e8 36 ea ff ff       	call   100247 <cprintf>
  101811:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  101814:	83 ec 04             	sub    $0x4,%esp
  101817:	68 18 38 10 00       	push   $0x103818
  10181c:	6a 12                	push   $0x12
  10181e:	68 2e 38 10 00       	push   $0x10382e
  101823:	e8 85 eb ff ff       	call   1003ad <__panic>

00101828 <idt_init>:
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */

void
idt_init(void) {
  101828:	55                   	push   %ebp
  101829:	89 e5                	mov    %esp,%ebp
  10182b:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[]; //256  ISR's entry addrs
     
    uintptr_t ISR_addr = __vectors[0];
  10182e:	a1 e0 e5 10 00       	mov    0x10e5e0,%eax
  101833:	89 45 fc             	mov    %eax,-0x4(%ebp)
    for (int i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++, ISR_addr = __vectors[i]){
  101836:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  10183d:	e9 c2 00 00 00       	jmp    101904 <idt_init+0xdc>
        SETGATE(idt[i], 0, GD_KTEXT, ISR_addr, DPL_USER);                   
  101842:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101845:	89 c2                	mov    %eax,%edx
  101847:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10184a:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101851:	00 
  101852:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101855:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10185c:	00 08 00 
  10185f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101862:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101869:	00 
  10186a:	83 e2 e0             	and    $0xffffffe0,%edx
  10186d:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101874:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101877:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10187e:	00 
  10187f:	83 e2 1f             	and    $0x1f,%edx
  101882:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101889:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10188c:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101893:	00 
  101894:	83 e2 f0             	and    $0xfffffff0,%edx
  101897:	83 ca 0e             	or     $0xe,%edx
  10189a:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018a4:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018ab:	00 
  1018ac:	83 e2 ef             	and    $0xffffffef,%edx
  1018af:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018b9:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c0:	00 
  1018c1:	83 ca 60             	or     $0x60,%edx
  1018c4:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018ce:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d5:	00 
  1018d6:	83 ca 80             	or     $0xffffff80,%edx
  1018d9:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e3:	c1 e8 10             	shr    $0x10,%eax
  1018e6:	89 c2                	mov    %eax,%edx
  1018e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018eb:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018f2:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[]; //256  ISR's entry addrs
     
    uintptr_t ISR_addr = __vectors[0];
    for (int i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++, ISR_addr = __vectors[i]){
  1018f3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  1018f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018fa:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101901:	89 45 fc             	mov    %eax,-0x4(%ebp)
  101904:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101907:	3d ff 00 00 00       	cmp    $0xff,%eax
  10190c:	0f 86 30 ff ff ff    	jbe    101842 <idt_init+0x1a>
        SETGATE(idt[i], 0, GD_KTEXT, ISR_addr, DPL_USER);                   
    }
    /*开启陷阱门*/
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  101912:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101917:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  10191d:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101924:	08 00 
  101926:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10192d:	83 e0 e0             	and    $0xffffffe0,%eax
  101930:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101935:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10193c:	83 e0 1f             	and    $0x1f,%eax
  10193f:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101944:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10194b:	83 c8 0f             	or     $0xf,%eax
  10194e:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101953:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10195a:	83 e0 ef             	and    $0xffffffef,%eax
  10195d:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101962:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101969:	83 c8 60             	or     $0x60,%eax
  10196c:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101971:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101978:	83 c8 80             	or     $0xffffff80,%eax
  10197b:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101980:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101985:	c1 e8 10             	shr    $0x10,%eax
  101988:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  10198e:	c7 45 f4 60 e5 10 00 	movl   $0x10e560,-0xc(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101998:	0f 01 18             	lidtl  (%eax)

    lidt(&idt_pd);
     
}
  10199b:	90                   	nop
  10199c:	c9                   	leave  
  10199d:	c3                   	ret    

0010199e <trapname>:

static const char *
trapname(int trapno) {
  10199e:	55                   	push   %ebp
  10199f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a4:	83 f8 13             	cmp    $0x13,%eax
  1019a7:	77 0c                	ja     1019b5 <trapname+0x17>
        return excnames[trapno];
  1019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ac:	8b 04 85 80 3b 10 00 	mov    0x103b80(,%eax,4),%eax
  1019b3:	eb 18                	jmp    1019cd <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019b5:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019b9:	7e 0d                	jle    1019c8 <trapname+0x2a>
  1019bb:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019bf:	7f 07                	jg     1019c8 <trapname+0x2a>
        return "Hardware Interrupt";
  1019c1:	b8 3f 38 10 00       	mov    $0x10383f,%eax
  1019c6:	eb 05                	jmp    1019cd <trapname+0x2f>
    }
    return "(unknown trap)";
  1019c8:	b8 52 38 10 00       	mov    $0x103852,%eax
}
  1019cd:	5d                   	pop    %ebp
  1019ce:	c3                   	ret    

001019cf <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019cf:	55                   	push   %ebp
  1019d0:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019d9:	66 83 f8 08          	cmp    $0x8,%ax
  1019dd:	0f 94 c0             	sete   %al
  1019e0:	0f b6 c0             	movzbl %al,%eax
}
  1019e3:	5d                   	pop    %ebp
  1019e4:	c3                   	ret    

001019e5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019e5:	55                   	push   %ebp
  1019e6:	89 e5                	mov    %esp,%ebp
  1019e8:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  1019eb:	83 ec 08             	sub    $0x8,%esp
  1019ee:	ff 75 08             	pushl  0x8(%ebp)
  1019f1:	68 93 38 10 00       	push   $0x103893
  1019f6:	e8 4c e8 ff ff       	call   100247 <cprintf>
  1019fb:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  1019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101a01:	83 ec 0c             	sub    $0xc,%esp
  101a04:	50                   	push   %eax
  101a05:	e8 b8 01 00 00       	call   101bc2 <print_regs>
  101a0a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a10:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a14:	0f b7 c0             	movzwl %ax,%eax
  101a17:	83 ec 08             	sub    $0x8,%esp
  101a1a:	50                   	push   %eax
  101a1b:	68 a4 38 10 00       	push   $0x1038a4
  101a20:	e8 22 e8 ff ff       	call   100247 <cprintf>
  101a25:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a28:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a2f:	0f b7 c0             	movzwl %ax,%eax
  101a32:	83 ec 08             	sub    $0x8,%esp
  101a35:	50                   	push   %eax
  101a36:	68 b7 38 10 00       	push   $0x1038b7
  101a3b:	e8 07 e8 ff ff       	call   100247 <cprintf>
  101a40:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a43:	8b 45 08             	mov    0x8(%ebp),%eax
  101a46:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a4a:	0f b7 c0             	movzwl %ax,%eax
  101a4d:	83 ec 08             	sub    $0x8,%esp
  101a50:	50                   	push   %eax
  101a51:	68 ca 38 10 00       	push   $0x1038ca
  101a56:	e8 ec e7 ff ff       	call   100247 <cprintf>
  101a5b:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a61:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a65:	0f b7 c0             	movzwl %ax,%eax
  101a68:	83 ec 08             	sub    $0x8,%esp
  101a6b:	50                   	push   %eax
  101a6c:	68 dd 38 10 00       	push   $0x1038dd
  101a71:	e8 d1 e7 ff ff       	call   100247 <cprintf>
  101a76:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a79:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7c:	8b 40 30             	mov    0x30(%eax),%eax
  101a7f:	83 ec 0c             	sub    $0xc,%esp
  101a82:	50                   	push   %eax
  101a83:	e8 16 ff ff ff       	call   10199e <trapname>
  101a88:	83 c4 10             	add    $0x10,%esp
  101a8b:	89 c2                	mov    %eax,%edx
  101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a90:	8b 40 30             	mov    0x30(%eax),%eax
  101a93:	83 ec 04             	sub    $0x4,%esp
  101a96:	52                   	push   %edx
  101a97:	50                   	push   %eax
  101a98:	68 f0 38 10 00       	push   $0x1038f0
  101a9d:	e8 a5 e7 ff ff       	call   100247 <cprintf>
  101aa2:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa8:	8b 40 34             	mov    0x34(%eax),%eax
  101aab:	83 ec 08             	sub    $0x8,%esp
  101aae:	50                   	push   %eax
  101aaf:	68 02 39 10 00       	push   $0x103902
  101ab4:	e8 8e e7 ff ff       	call   100247 <cprintf>
  101ab9:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101abc:	8b 45 08             	mov    0x8(%ebp),%eax
  101abf:	8b 40 38             	mov    0x38(%eax),%eax
  101ac2:	83 ec 08             	sub    $0x8,%esp
  101ac5:	50                   	push   %eax
  101ac6:	68 11 39 10 00       	push   $0x103911
  101acb:	e8 77 e7 ff ff       	call   100247 <cprintf>
  101ad0:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ada:	0f b7 c0             	movzwl %ax,%eax
  101add:	83 ec 08             	sub    $0x8,%esp
  101ae0:	50                   	push   %eax
  101ae1:	68 20 39 10 00       	push   $0x103920
  101ae6:	e8 5c e7 ff ff       	call   100247 <cprintf>
  101aeb:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101aee:	8b 45 08             	mov    0x8(%ebp),%eax
  101af1:	8b 40 40             	mov    0x40(%eax),%eax
  101af4:	83 ec 08             	sub    $0x8,%esp
  101af7:	50                   	push   %eax
  101af8:	68 33 39 10 00       	push   $0x103933
  101afd:	e8 45 e7 ff ff       	call   100247 <cprintf>
  101b02:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b0c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b13:	eb 3f                	jmp    101b54 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b15:	8b 45 08             	mov    0x8(%ebp),%eax
  101b18:	8b 50 40             	mov    0x40(%eax),%edx
  101b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b1e:	21 d0                	and    %edx,%eax
  101b20:	85 c0                	test   %eax,%eax
  101b22:	74 29                	je     101b4d <print_trapframe+0x168>
  101b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b27:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b2e:	85 c0                	test   %eax,%eax
  101b30:	74 1b                	je     101b4d <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b35:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b3c:	83 ec 08             	sub    $0x8,%esp
  101b3f:	50                   	push   %eax
  101b40:	68 42 39 10 00       	push   $0x103942
  101b45:	e8 fd e6 ff ff       	call   100247 <cprintf>
  101b4a:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b4d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b51:	d1 65 f0             	shll   -0x10(%ebp)
  101b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b57:	83 f8 17             	cmp    $0x17,%eax
  101b5a:	76 b9                	jbe    101b15 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5f:	8b 40 40             	mov    0x40(%eax),%eax
  101b62:	25 00 30 00 00       	and    $0x3000,%eax
  101b67:	c1 e8 0c             	shr    $0xc,%eax
  101b6a:	83 ec 08             	sub    $0x8,%esp
  101b6d:	50                   	push   %eax
  101b6e:	68 46 39 10 00       	push   $0x103946
  101b73:	e8 cf e6 ff ff       	call   100247 <cprintf>
  101b78:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101b7b:	83 ec 0c             	sub    $0xc,%esp
  101b7e:	ff 75 08             	pushl  0x8(%ebp)
  101b81:	e8 49 fe ff ff       	call   1019cf <trap_in_kernel>
  101b86:	83 c4 10             	add    $0x10,%esp
  101b89:	85 c0                	test   %eax,%eax
  101b8b:	75 32                	jne    101bbf <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b90:	8b 40 44             	mov    0x44(%eax),%eax
  101b93:	83 ec 08             	sub    $0x8,%esp
  101b96:	50                   	push   %eax
  101b97:	68 4f 39 10 00       	push   $0x10394f
  101b9c:	e8 a6 e6 ff ff       	call   100247 <cprintf>
  101ba1:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba7:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bab:	0f b7 c0             	movzwl %ax,%eax
  101bae:	83 ec 08             	sub    $0x8,%esp
  101bb1:	50                   	push   %eax
  101bb2:	68 5e 39 10 00       	push   $0x10395e
  101bb7:	e8 8b e6 ff ff       	call   100247 <cprintf>
  101bbc:	83 c4 10             	add    $0x10,%esp
    }
}
  101bbf:	90                   	nop
  101bc0:	c9                   	leave  
  101bc1:	c3                   	ret    

00101bc2 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bc2:	55                   	push   %ebp
  101bc3:	89 e5                	mov    %esp,%ebp
  101bc5:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcb:	8b 00                	mov    (%eax),%eax
  101bcd:	83 ec 08             	sub    $0x8,%esp
  101bd0:	50                   	push   %eax
  101bd1:	68 71 39 10 00       	push   $0x103971
  101bd6:	e8 6c e6 ff ff       	call   100247 <cprintf>
  101bdb:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bde:	8b 45 08             	mov    0x8(%ebp),%eax
  101be1:	8b 40 04             	mov    0x4(%eax),%eax
  101be4:	83 ec 08             	sub    $0x8,%esp
  101be7:	50                   	push   %eax
  101be8:	68 80 39 10 00       	push   $0x103980
  101bed:	e8 55 e6 ff ff       	call   100247 <cprintf>
  101bf2:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf8:	8b 40 08             	mov    0x8(%eax),%eax
  101bfb:	83 ec 08             	sub    $0x8,%esp
  101bfe:	50                   	push   %eax
  101bff:	68 8f 39 10 00       	push   $0x10398f
  101c04:	e8 3e e6 ff ff       	call   100247 <cprintf>
  101c09:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0f:	8b 40 0c             	mov    0xc(%eax),%eax
  101c12:	83 ec 08             	sub    $0x8,%esp
  101c15:	50                   	push   %eax
  101c16:	68 9e 39 10 00       	push   $0x10399e
  101c1b:	e8 27 e6 ff ff       	call   100247 <cprintf>
  101c20:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c23:	8b 45 08             	mov    0x8(%ebp),%eax
  101c26:	8b 40 10             	mov    0x10(%eax),%eax
  101c29:	83 ec 08             	sub    $0x8,%esp
  101c2c:	50                   	push   %eax
  101c2d:	68 ad 39 10 00       	push   $0x1039ad
  101c32:	e8 10 e6 ff ff       	call   100247 <cprintf>
  101c37:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3d:	8b 40 14             	mov    0x14(%eax),%eax
  101c40:	83 ec 08             	sub    $0x8,%esp
  101c43:	50                   	push   %eax
  101c44:	68 bc 39 10 00       	push   $0x1039bc
  101c49:	e8 f9 e5 ff ff       	call   100247 <cprintf>
  101c4e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c51:	8b 45 08             	mov    0x8(%ebp),%eax
  101c54:	8b 40 18             	mov    0x18(%eax),%eax
  101c57:	83 ec 08             	sub    $0x8,%esp
  101c5a:	50                   	push   %eax
  101c5b:	68 cb 39 10 00       	push   $0x1039cb
  101c60:	e8 e2 e5 ff ff       	call   100247 <cprintf>
  101c65:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c68:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6b:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c6e:	83 ec 08             	sub    $0x8,%esp
  101c71:	50                   	push   %eax
  101c72:	68 da 39 10 00       	push   $0x1039da
  101c77:	e8 cb e5 ff ff       	call   100247 <cprintf>
  101c7c:	83 c4 10             	add    $0x10,%esp
}
  101c7f:	90                   	nop
  101c80:	c9                   	leave  
  101c81:	c3                   	ret    

00101c82 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c82:	55                   	push   %ebp
  101c83:	89 e5                	mov    %esp,%ebp
  101c85:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101c88:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8b:	8b 40 30             	mov    0x30(%eax),%eax
  101c8e:	83 f8 2f             	cmp    $0x2f,%eax
  101c91:	77 1d                	ja     101cb0 <trap_dispatch+0x2e>
  101c93:	83 f8 2e             	cmp    $0x2e,%eax
  101c96:	0f 83 2d 01 00 00    	jae    101dc9 <trap_dispatch+0x147>
  101c9c:	83 f8 21             	cmp    $0x21,%eax
  101c9f:	74 77                	je     101d18 <trap_dispatch+0x96>
  101ca1:	83 f8 24             	cmp    $0x24,%eax
  101ca4:	74 4b                	je     101cf1 <trap_dispatch+0x6f>
  101ca6:	83 f8 20             	cmp    $0x20,%eax
  101ca9:	74 1c                	je     101cc7 <trap_dispatch+0x45>
  101cab:	e9 e3 00 00 00       	jmp    101d93 <trap_dispatch+0x111>
  101cb0:	83 f8 78             	cmp    $0x78,%eax
  101cb3:	0f 84 86 00 00 00    	je     101d3f <trap_dispatch+0xbd>
  101cb9:	83 f8 79             	cmp    $0x79,%eax
  101cbc:	0f 84 b4 00 00 00    	je     101d76 <trap_dispatch+0xf4>
  101cc2:	e9 cc 00 00 00       	jmp    101d93 <trap_dispatch+0x111>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
        /*  #define TICK_NUM 100
         * (3) Too Simple? Yes, I think so!
         */

        if(++ticks == TICK_NUM){
  101cc7:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101ccc:	83 c0 01             	add    $0x1,%eax
  101ccf:	a3 08 f9 10 00       	mov    %eax,0x10f908
  101cd4:	83 f8 64             	cmp    $0x64,%eax
  101cd7:	0f 85 ef 00 00 00    	jne    101dcc <trap_dispatch+0x14a>
            print_ticks();
  101cdd:	e8 0a fb ff ff       	call   1017ec <print_ticks>
            ticks = 0;
  101ce2:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  101ce9:	00 00 00 
        }

        break;
  101cec:	e9 db 00 00 00       	jmp    101dcc <trap_dispatch+0x14a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cf1:	e8 c9 f8 ff ff       	call   1015bf <cons_getc>
  101cf6:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cf9:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cfd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d01:	83 ec 04             	sub    $0x4,%esp
  101d04:	52                   	push   %edx
  101d05:	50                   	push   %eax
  101d06:	68 e9 39 10 00       	push   $0x1039e9
  101d0b:	e8 37 e5 ff ff       	call   100247 <cprintf>
  101d10:	83 c4 10             	add    $0x10,%esp
        break;
  101d13:	e9 b5 00 00 00       	jmp    101dcd <trap_dispatch+0x14b>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d18:	e8 a2 f8 ff ff       	call   1015bf <cons_getc>
  101d1d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d20:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d24:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d28:	83 ec 04             	sub    $0x4,%esp
  101d2b:	52                   	push   %edx
  101d2c:	50                   	push   %eax
  101d2d:	68 fb 39 10 00       	push   $0x1039fb
  101d32:	e8 10 e5 ff ff       	call   100247 <cprintf>
  101d37:	83 c4 10             	add    $0x10,%esp
        break;
  101d3a:	e9 8e 00 00 00       	jmp    101dcd <trap_dispatch+0x14b>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        tf->tf_eflags |= FL_IOPL_MASK;
  101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d42:	8b 40 40             	mov    0x40(%eax),%eax
  101d45:	80 cc 30             	or     $0x30,%ah
  101d48:	89 c2                	mov    %eax,%edx
  101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4d:	89 50 40             	mov    %edx,0x40(%eax)
        tf->tf_es = USER_DS;
  101d50:	8b 45 08             	mov    0x8(%ebp),%eax
  101d53:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
        tf->tf_ds = USER_DS;
  101d59:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5c:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
        tf->tf_ss = USER_DS;
  101d62:	8b 45 08             	mov    0x8(%ebp),%eax
  101d65:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
        tf->tf_cs = USER_CS;
  101d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6e:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
        break;
  101d74:	eb 57                	jmp    101dcd <trap_dispatch+0x14b>
    case T_SWITCH_TOK:
        tf->tf_es = KERNEL_DS;
  101d76:	8b 45 08             	mov    0x8(%ebp),%eax
  101d79:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_ds = KERNEL_DS;
  101d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d82:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        // tf->tf_ss = 0x10;
        tf->tf_cs = KERNEL_CS;
  101d88:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8b:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        break;
  101d91:	eb 3a                	jmp    101dcd <trap_dispatch+0x14b>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d93:	8b 45 08             	mov    0x8(%ebp),%eax
  101d96:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d9a:	0f b7 c0             	movzwl %ax,%eax
  101d9d:	83 e0 03             	and    $0x3,%eax
  101da0:	85 c0                	test   %eax,%eax
  101da2:	75 29                	jne    101dcd <trap_dispatch+0x14b>
            print_trapframe(tf);
  101da4:	83 ec 0c             	sub    $0xc,%esp
  101da7:	ff 75 08             	pushl  0x8(%ebp)
  101daa:	e8 36 fc ff ff       	call   1019e5 <print_trapframe>
  101daf:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101db2:	83 ec 04             	sub    $0x4,%esp
  101db5:	68 0a 3a 10 00       	push   $0x103a0a
  101dba:	68 c9 00 00 00       	push   $0xc9
  101dbf:	68 2e 38 10 00       	push   $0x10382e
  101dc4:	e8 e4 e5 ff ff       	call   1003ad <__panic>
        tf->tf_cs = KERNEL_CS;
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101dc9:	90                   	nop
  101dca:	eb 01                	jmp    101dcd <trap_dispatch+0x14b>
        if(++ticks == TICK_NUM){
            print_ticks();
            ticks = 0;
        }

        break;
  101dcc:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101dcd:	90                   	nop
  101dce:	c9                   	leave  
  101dcf:	c3                   	ret    

00101dd0 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101dd0:	55                   	push   %ebp
  101dd1:	89 e5                	mov    %esp,%ebp
  101dd3:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101dd6:	83 ec 0c             	sub    $0xc,%esp
  101dd9:	ff 75 08             	pushl  0x8(%ebp)
  101ddc:	e8 a1 fe ff ff       	call   101c82 <trap_dispatch>
  101de1:	83 c4 10             	add    $0x10,%esp
}
  101de4:	90                   	nop
  101de5:	c9                   	leave  
  101de6:	c3                   	ret    

00101de7 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101de7:	6a 00                	push   $0x0
  pushl $0
  101de9:	6a 00                	push   $0x0
  jmp __alltraps
  101deb:	e9 67 0a 00 00       	jmp    102857 <__alltraps>

00101df0 <vector1>:
.globl vector1
vector1:
  pushl $0
  101df0:	6a 00                	push   $0x0
  pushl $1
  101df2:	6a 01                	push   $0x1
  jmp __alltraps
  101df4:	e9 5e 0a 00 00       	jmp    102857 <__alltraps>

00101df9 <vector2>:
.globl vector2
vector2:
  pushl $0
  101df9:	6a 00                	push   $0x0
  pushl $2
  101dfb:	6a 02                	push   $0x2
  jmp __alltraps
  101dfd:	e9 55 0a 00 00       	jmp    102857 <__alltraps>

00101e02 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e02:	6a 00                	push   $0x0
  pushl $3
  101e04:	6a 03                	push   $0x3
  jmp __alltraps
  101e06:	e9 4c 0a 00 00       	jmp    102857 <__alltraps>

00101e0b <vector4>:
.globl vector4
vector4:
  pushl $0
  101e0b:	6a 00                	push   $0x0
  pushl $4
  101e0d:	6a 04                	push   $0x4
  jmp __alltraps
  101e0f:	e9 43 0a 00 00       	jmp    102857 <__alltraps>

00101e14 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e14:	6a 00                	push   $0x0
  pushl $5
  101e16:	6a 05                	push   $0x5
  jmp __alltraps
  101e18:	e9 3a 0a 00 00       	jmp    102857 <__alltraps>

00101e1d <vector6>:
.globl vector6
vector6:
  pushl $0
  101e1d:	6a 00                	push   $0x0
  pushl $6
  101e1f:	6a 06                	push   $0x6
  jmp __alltraps
  101e21:	e9 31 0a 00 00       	jmp    102857 <__alltraps>

00101e26 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e26:	6a 00                	push   $0x0
  pushl $7
  101e28:	6a 07                	push   $0x7
  jmp __alltraps
  101e2a:	e9 28 0a 00 00       	jmp    102857 <__alltraps>

00101e2f <vector8>:
.globl vector8
vector8:
  pushl $8
  101e2f:	6a 08                	push   $0x8
  jmp __alltraps
  101e31:	e9 21 0a 00 00       	jmp    102857 <__alltraps>

00101e36 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e36:	6a 09                	push   $0x9
  jmp __alltraps
  101e38:	e9 1a 0a 00 00       	jmp    102857 <__alltraps>

00101e3d <vector10>:
.globl vector10
vector10:
  pushl $10
  101e3d:	6a 0a                	push   $0xa
  jmp __alltraps
  101e3f:	e9 13 0a 00 00       	jmp    102857 <__alltraps>

00101e44 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e44:	6a 0b                	push   $0xb
  jmp __alltraps
  101e46:	e9 0c 0a 00 00       	jmp    102857 <__alltraps>

00101e4b <vector12>:
.globl vector12
vector12:
  pushl $12
  101e4b:	6a 0c                	push   $0xc
  jmp __alltraps
  101e4d:	e9 05 0a 00 00       	jmp    102857 <__alltraps>

00101e52 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e52:	6a 0d                	push   $0xd
  jmp __alltraps
  101e54:	e9 fe 09 00 00       	jmp    102857 <__alltraps>

00101e59 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e59:	6a 0e                	push   $0xe
  jmp __alltraps
  101e5b:	e9 f7 09 00 00       	jmp    102857 <__alltraps>

00101e60 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e60:	6a 00                	push   $0x0
  pushl $15
  101e62:	6a 0f                	push   $0xf
  jmp __alltraps
  101e64:	e9 ee 09 00 00       	jmp    102857 <__alltraps>

00101e69 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e69:	6a 00                	push   $0x0
  pushl $16
  101e6b:	6a 10                	push   $0x10
  jmp __alltraps
  101e6d:	e9 e5 09 00 00       	jmp    102857 <__alltraps>

00101e72 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e72:	6a 11                	push   $0x11
  jmp __alltraps
  101e74:	e9 de 09 00 00       	jmp    102857 <__alltraps>

00101e79 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e79:	6a 00                	push   $0x0
  pushl $18
  101e7b:	6a 12                	push   $0x12
  jmp __alltraps
  101e7d:	e9 d5 09 00 00       	jmp    102857 <__alltraps>

00101e82 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e82:	6a 00                	push   $0x0
  pushl $19
  101e84:	6a 13                	push   $0x13
  jmp __alltraps
  101e86:	e9 cc 09 00 00       	jmp    102857 <__alltraps>

00101e8b <vector20>:
.globl vector20
vector20:
  pushl $0
  101e8b:	6a 00                	push   $0x0
  pushl $20
  101e8d:	6a 14                	push   $0x14
  jmp __alltraps
  101e8f:	e9 c3 09 00 00       	jmp    102857 <__alltraps>

00101e94 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e94:	6a 00                	push   $0x0
  pushl $21
  101e96:	6a 15                	push   $0x15
  jmp __alltraps
  101e98:	e9 ba 09 00 00       	jmp    102857 <__alltraps>

00101e9d <vector22>:
.globl vector22
vector22:
  pushl $0
  101e9d:	6a 00                	push   $0x0
  pushl $22
  101e9f:	6a 16                	push   $0x16
  jmp __alltraps
  101ea1:	e9 b1 09 00 00       	jmp    102857 <__alltraps>

00101ea6 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ea6:	6a 00                	push   $0x0
  pushl $23
  101ea8:	6a 17                	push   $0x17
  jmp __alltraps
  101eaa:	e9 a8 09 00 00       	jmp    102857 <__alltraps>

00101eaf <vector24>:
.globl vector24
vector24:
  pushl $0
  101eaf:	6a 00                	push   $0x0
  pushl $24
  101eb1:	6a 18                	push   $0x18
  jmp __alltraps
  101eb3:	e9 9f 09 00 00       	jmp    102857 <__alltraps>

00101eb8 <vector25>:
.globl vector25
vector25:
  pushl $0
  101eb8:	6a 00                	push   $0x0
  pushl $25
  101eba:	6a 19                	push   $0x19
  jmp __alltraps
  101ebc:	e9 96 09 00 00       	jmp    102857 <__alltraps>

00101ec1 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ec1:	6a 00                	push   $0x0
  pushl $26
  101ec3:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ec5:	e9 8d 09 00 00       	jmp    102857 <__alltraps>

00101eca <vector27>:
.globl vector27
vector27:
  pushl $0
  101eca:	6a 00                	push   $0x0
  pushl $27
  101ecc:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ece:	e9 84 09 00 00       	jmp    102857 <__alltraps>

00101ed3 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ed3:	6a 00                	push   $0x0
  pushl $28
  101ed5:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ed7:	e9 7b 09 00 00       	jmp    102857 <__alltraps>

00101edc <vector29>:
.globl vector29
vector29:
  pushl $0
  101edc:	6a 00                	push   $0x0
  pushl $29
  101ede:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ee0:	e9 72 09 00 00       	jmp    102857 <__alltraps>

00101ee5 <vector30>:
.globl vector30
vector30:
  pushl $0
  101ee5:	6a 00                	push   $0x0
  pushl $30
  101ee7:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ee9:	e9 69 09 00 00       	jmp    102857 <__alltraps>

00101eee <vector31>:
.globl vector31
vector31:
  pushl $0
  101eee:	6a 00                	push   $0x0
  pushl $31
  101ef0:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ef2:	e9 60 09 00 00       	jmp    102857 <__alltraps>

00101ef7 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ef7:	6a 00                	push   $0x0
  pushl $32
  101ef9:	6a 20                	push   $0x20
  jmp __alltraps
  101efb:	e9 57 09 00 00       	jmp    102857 <__alltraps>

00101f00 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f00:	6a 00                	push   $0x0
  pushl $33
  101f02:	6a 21                	push   $0x21
  jmp __alltraps
  101f04:	e9 4e 09 00 00       	jmp    102857 <__alltraps>

00101f09 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f09:	6a 00                	push   $0x0
  pushl $34
  101f0b:	6a 22                	push   $0x22
  jmp __alltraps
  101f0d:	e9 45 09 00 00       	jmp    102857 <__alltraps>

00101f12 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f12:	6a 00                	push   $0x0
  pushl $35
  101f14:	6a 23                	push   $0x23
  jmp __alltraps
  101f16:	e9 3c 09 00 00       	jmp    102857 <__alltraps>

00101f1b <vector36>:
.globl vector36
vector36:
  pushl $0
  101f1b:	6a 00                	push   $0x0
  pushl $36
  101f1d:	6a 24                	push   $0x24
  jmp __alltraps
  101f1f:	e9 33 09 00 00       	jmp    102857 <__alltraps>

00101f24 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f24:	6a 00                	push   $0x0
  pushl $37
  101f26:	6a 25                	push   $0x25
  jmp __alltraps
  101f28:	e9 2a 09 00 00       	jmp    102857 <__alltraps>

00101f2d <vector38>:
.globl vector38
vector38:
  pushl $0
  101f2d:	6a 00                	push   $0x0
  pushl $38
  101f2f:	6a 26                	push   $0x26
  jmp __alltraps
  101f31:	e9 21 09 00 00       	jmp    102857 <__alltraps>

00101f36 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $39
  101f38:	6a 27                	push   $0x27
  jmp __alltraps
  101f3a:	e9 18 09 00 00       	jmp    102857 <__alltraps>

00101f3f <vector40>:
.globl vector40
vector40:
  pushl $0
  101f3f:	6a 00                	push   $0x0
  pushl $40
  101f41:	6a 28                	push   $0x28
  jmp __alltraps
  101f43:	e9 0f 09 00 00       	jmp    102857 <__alltraps>

00101f48 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f48:	6a 00                	push   $0x0
  pushl $41
  101f4a:	6a 29                	push   $0x29
  jmp __alltraps
  101f4c:	e9 06 09 00 00       	jmp    102857 <__alltraps>

00101f51 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f51:	6a 00                	push   $0x0
  pushl $42
  101f53:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f55:	e9 fd 08 00 00       	jmp    102857 <__alltraps>

00101f5a <vector43>:
.globl vector43
vector43:
  pushl $0
  101f5a:	6a 00                	push   $0x0
  pushl $43
  101f5c:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f5e:	e9 f4 08 00 00       	jmp    102857 <__alltraps>

00101f63 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f63:	6a 00                	push   $0x0
  pushl $44
  101f65:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f67:	e9 eb 08 00 00       	jmp    102857 <__alltraps>

00101f6c <vector45>:
.globl vector45
vector45:
  pushl $0
  101f6c:	6a 00                	push   $0x0
  pushl $45
  101f6e:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f70:	e9 e2 08 00 00       	jmp    102857 <__alltraps>

00101f75 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f75:	6a 00                	push   $0x0
  pushl $46
  101f77:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f79:	e9 d9 08 00 00       	jmp    102857 <__alltraps>

00101f7e <vector47>:
.globl vector47
vector47:
  pushl $0
  101f7e:	6a 00                	push   $0x0
  pushl $47
  101f80:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f82:	e9 d0 08 00 00       	jmp    102857 <__alltraps>

00101f87 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $48
  101f89:	6a 30                	push   $0x30
  jmp __alltraps
  101f8b:	e9 c7 08 00 00       	jmp    102857 <__alltraps>

00101f90 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $49
  101f92:	6a 31                	push   $0x31
  jmp __alltraps
  101f94:	e9 be 08 00 00       	jmp    102857 <__alltraps>

00101f99 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $50
  101f9b:	6a 32                	push   $0x32
  jmp __alltraps
  101f9d:	e9 b5 08 00 00       	jmp    102857 <__alltraps>

00101fa2 <vector51>:
.globl vector51
vector51:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $51
  101fa4:	6a 33                	push   $0x33
  jmp __alltraps
  101fa6:	e9 ac 08 00 00       	jmp    102857 <__alltraps>

00101fab <vector52>:
.globl vector52
vector52:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $52
  101fad:	6a 34                	push   $0x34
  jmp __alltraps
  101faf:	e9 a3 08 00 00       	jmp    102857 <__alltraps>

00101fb4 <vector53>:
.globl vector53
vector53:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $53
  101fb6:	6a 35                	push   $0x35
  jmp __alltraps
  101fb8:	e9 9a 08 00 00       	jmp    102857 <__alltraps>

00101fbd <vector54>:
.globl vector54
vector54:
  pushl $0
  101fbd:	6a 00                	push   $0x0
  pushl $54
  101fbf:	6a 36                	push   $0x36
  jmp __alltraps
  101fc1:	e9 91 08 00 00       	jmp    102857 <__alltraps>

00101fc6 <vector55>:
.globl vector55
vector55:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $55
  101fc8:	6a 37                	push   $0x37
  jmp __alltraps
  101fca:	e9 88 08 00 00       	jmp    102857 <__alltraps>

00101fcf <vector56>:
.globl vector56
vector56:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $56
  101fd1:	6a 38                	push   $0x38
  jmp __alltraps
  101fd3:	e9 7f 08 00 00       	jmp    102857 <__alltraps>

00101fd8 <vector57>:
.globl vector57
vector57:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $57
  101fda:	6a 39                	push   $0x39
  jmp __alltraps
  101fdc:	e9 76 08 00 00       	jmp    102857 <__alltraps>

00101fe1 <vector58>:
.globl vector58
vector58:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $58
  101fe3:	6a 3a                	push   $0x3a
  jmp __alltraps
  101fe5:	e9 6d 08 00 00       	jmp    102857 <__alltraps>

00101fea <vector59>:
.globl vector59
vector59:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $59
  101fec:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fee:	e9 64 08 00 00       	jmp    102857 <__alltraps>

00101ff3 <vector60>:
.globl vector60
vector60:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $60
  101ff5:	6a 3c                	push   $0x3c
  jmp __alltraps
  101ff7:	e9 5b 08 00 00       	jmp    102857 <__alltraps>

00101ffc <vector61>:
.globl vector61
vector61:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $61
  101ffe:	6a 3d                	push   $0x3d
  jmp __alltraps
  102000:	e9 52 08 00 00       	jmp    102857 <__alltraps>

00102005 <vector62>:
.globl vector62
vector62:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $62
  102007:	6a 3e                	push   $0x3e
  jmp __alltraps
  102009:	e9 49 08 00 00       	jmp    102857 <__alltraps>

0010200e <vector63>:
.globl vector63
vector63:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $63
  102010:	6a 3f                	push   $0x3f
  jmp __alltraps
  102012:	e9 40 08 00 00       	jmp    102857 <__alltraps>

00102017 <vector64>:
.globl vector64
vector64:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $64
  102019:	6a 40                	push   $0x40
  jmp __alltraps
  10201b:	e9 37 08 00 00       	jmp    102857 <__alltraps>

00102020 <vector65>:
.globl vector65
vector65:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $65
  102022:	6a 41                	push   $0x41
  jmp __alltraps
  102024:	e9 2e 08 00 00       	jmp    102857 <__alltraps>

00102029 <vector66>:
.globl vector66
vector66:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $66
  10202b:	6a 42                	push   $0x42
  jmp __alltraps
  10202d:	e9 25 08 00 00       	jmp    102857 <__alltraps>

00102032 <vector67>:
.globl vector67
vector67:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $67
  102034:	6a 43                	push   $0x43
  jmp __alltraps
  102036:	e9 1c 08 00 00       	jmp    102857 <__alltraps>

0010203b <vector68>:
.globl vector68
vector68:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $68
  10203d:	6a 44                	push   $0x44
  jmp __alltraps
  10203f:	e9 13 08 00 00       	jmp    102857 <__alltraps>

00102044 <vector69>:
.globl vector69
vector69:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $69
  102046:	6a 45                	push   $0x45
  jmp __alltraps
  102048:	e9 0a 08 00 00       	jmp    102857 <__alltraps>

0010204d <vector70>:
.globl vector70
vector70:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $70
  10204f:	6a 46                	push   $0x46
  jmp __alltraps
  102051:	e9 01 08 00 00       	jmp    102857 <__alltraps>

00102056 <vector71>:
.globl vector71
vector71:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $71
  102058:	6a 47                	push   $0x47
  jmp __alltraps
  10205a:	e9 f8 07 00 00       	jmp    102857 <__alltraps>

0010205f <vector72>:
.globl vector72
vector72:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $72
  102061:	6a 48                	push   $0x48
  jmp __alltraps
  102063:	e9 ef 07 00 00       	jmp    102857 <__alltraps>

00102068 <vector73>:
.globl vector73
vector73:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $73
  10206a:	6a 49                	push   $0x49
  jmp __alltraps
  10206c:	e9 e6 07 00 00       	jmp    102857 <__alltraps>

00102071 <vector74>:
.globl vector74
vector74:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $74
  102073:	6a 4a                	push   $0x4a
  jmp __alltraps
  102075:	e9 dd 07 00 00       	jmp    102857 <__alltraps>

0010207a <vector75>:
.globl vector75
vector75:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $75
  10207c:	6a 4b                	push   $0x4b
  jmp __alltraps
  10207e:	e9 d4 07 00 00       	jmp    102857 <__alltraps>

00102083 <vector76>:
.globl vector76
vector76:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $76
  102085:	6a 4c                	push   $0x4c
  jmp __alltraps
  102087:	e9 cb 07 00 00       	jmp    102857 <__alltraps>

0010208c <vector77>:
.globl vector77
vector77:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $77
  10208e:	6a 4d                	push   $0x4d
  jmp __alltraps
  102090:	e9 c2 07 00 00       	jmp    102857 <__alltraps>

00102095 <vector78>:
.globl vector78
vector78:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $78
  102097:	6a 4e                	push   $0x4e
  jmp __alltraps
  102099:	e9 b9 07 00 00       	jmp    102857 <__alltraps>

0010209e <vector79>:
.globl vector79
vector79:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $79
  1020a0:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020a2:	e9 b0 07 00 00       	jmp    102857 <__alltraps>

001020a7 <vector80>:
.globl vector80
vector80:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $80
  1020a9:	6a 50                	push   $0x50
  jmp __alltraps
  1020ab:	e9 a7 07 00 00       	jmp    102857 <__alltraps>

001020b0 <vector81>:
.globl vector81
vector81:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $81
  1020b2:	6a 51                	push   $0x51
  jmp __alltraps
  1020b4:	e9 9e 07 00 00       	jmp    102857 <__alltraps>

001020b9 <vector82>:
.globl vector82
vector82:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $82
  1020bb:	6a 52                	push   $0x52
  jmp __alltraps
  1020bd:	e9 95 07 00 00       	jmp    102857 <__alltraps>

001020c2 <vector83>:
.globl vector83
vector83:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $83
  1020c4:	6a 53                	push   $0x53
  jmp __alltraps
  1020c6:	e9 8c 07 00 00       	jmp    102857 <__alltraps>

001020cb <vector84>:
.globl vector84
vector84:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $84
  1020cd:	6a 54                	push   $0x54
  jmp __alltraps
  1020cf:	e9 83 07 00 00       	jmp    102857 <__alltraps>

001020d4 <vector85>:
.globl vector85
vector85:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $85
  1020d6:	6a 55                	push   $0x55
  jmp __alltraps
  1020d8:	e9 7a 07 00 00       	jmp    102857 <__alltraps>

001020dd <vector86>:
.globl vector86
vector86:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $86
  1020df:	6a 56                	push   $0x56
  jmp __alltraps
  1020e1:	e9 71 07 00 00       	jmp    102857 <__alltraps>

001020e6 <vector87>:
.globl vector87
vector87:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $87
  1020e8:	6a 57                	push   $0x57
  jmp __alltraps
  1020ea:	e9 68 07 00 00       	jmp    102857 <__alltraps>

001020ef <vector88>:
.globl vector88
vector88:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $88
  1020f1:	6a 58                	push   $0x58
  jmp __alltraps
  1020f3:	e9 5f 07 00 00       	jmp    102857 <__alltraps>

001020f8 <vector89>:
.globl vector89
vector89:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $89
  1020fa:	6a 59                	push   $0x59
  jmp __alltraps
  1020fc:	e9 56 07 00 00       	jmp    102857 <__alltraps>

00102101 <vector90>:
.globl vector90
vector90:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $90
  102103:	6a 5a                	push   $0x5a
  jmp __alltraps
  102105:	e9 4d 07 00 00       	jmp    102857 <__alltraps>

0010210a <vector91>:
.globl vector91
vector91:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $91
  10210c:	6a 5b                	push   $0x5b
  jmp __alltraps
  10210e:	e9 44 07 00 00       	jmp    102857 <__alltraps>

00102113 <vector92>:
.globl vector92
vector92:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $92
  102115:	6a 5c                	push   $0x5c
  jmp __alltraps
  102117:	e9 3b 07 00 00       	jmp    102857 <__alltraps>

0010211c <vector93>:
.globl vector93
vector93:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $93
  10211e:	6a 5d                	push   $0x5d
  jmp __alltraps
  102120:	e9 32 07 00 00       	jmp    102857 <__alltraps>

00102125 <vector94>:
.globl vector94
vector94:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $94
  102127:	6a 5e                	push   $0x5e
  jmp __alltraps
  102129:	e9 29 07 00 00       	jmp    102857 <__alltraps>

0010212e <vector95>:
.globl vector95
vector95:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $95
  102130:	6a 5f                	push   $0x5f
  jmp __alltraps
  102132:	e9 20 07 00 00       	jmp    102857 <__alltraps>

00102137 <vector96>:
.globl vector96
vector96:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $96
  102139:	6a 60                	push   $0x60
  jmp __alltraps
  10213b:	e9 17 07 00 00       	jmp    102857 <__alltraps>

00102140 <vector97>:
.globl vector97
vector97:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $97
  102142:	6a 61                	push   $0x61
  jmp __alltraps
  102144:	e9 0e 07 00 00       	jmp    102857 <__alltraps>

00102149 <vector98>:
.globl vector98
vector98:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $98
  10214b:	6a 62                	push   $0x62
  jmp __alltraps
  10214d:	e9 05 07 00 00       	jmp    102857 <__alltraps>

00102152 <vector99>:
.globl vector99
vector99:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $99
  102154:	6a 63                	push   $0x63
  jmp __alltraps
  102156:	e9 fc 06 00 00       	jmp    102857 <__alltraps>

0010215b <vector100>:
.globl vector100
vector100:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $100
  10215d:	6a 64                	push   $0x64
  jmp __alltraps
  10215f:	e9 f3 06 00 00       	jmp    102857 <__alltraps>

00102164 <vector101>:
.globl vector101
vector101:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $101
  102166:	6a 65                	push   $0x65
  jmp __alltraps
  102168:	e9 ea 06 00 00       	jmp    102857 <__alltraps>

0010216d <vector102>:
.globl vector102
vector102:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $102
  10216f:	6a 66                	push   $0x66
  jmp __alltraps
  102171:	e9 e1 06 00 00       	jmp    102857 <__alltraps>

00102176 <vector103>:
.globl vector103
vector103:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $103
  102178:	6a 67                	push   $0x67
  jmp __alltraps
  10217a:	e9 d8 06 00 00       	jmp    102857 <__alltraps>

0010217f <vector104>:
.globl vector104
vector104:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $104
  102181:	6a 68                	push   $0x68
  jmp __alltraps
  102183:	e9 cf 06 00 00       	jmp    102857 <__alltraps>

00102188 <vector105>:
.globl vector105
vector105:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $105
  10218a:	6a 69                	push   $0x69
  jmp __alltraps
  10218c:	e9 c6 06 00 00       	jmp    102857 <__alltraps>

00102191 <vector106>:
.globl vector106
vector106:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $106
  102193:	6a 6a                	push   $0x6a
  jmp __alltraps
  102195:	e9 bd 06 00 00       	jmp    102857 <__alltraps>

0010219a <vector107>:
.globl vector107
vector107:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $107
  10219c:	6a 6b                	push   $0x6b
  jmp __alltraps
  10219e:	e9 b4 06 00 00       	jmp    102857 <__alltraps>

001021a3 <vector108>:
.globl vector108
vector108:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $108
  1021a5:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021a7:	e9 ab 06 00 00       	jmp    102857 <__alltraps>

001021ac <vector109>:
.globl vector109
vector109:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $109
  1021ae:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021b0:	e9 a2 06 00 00       	jmp    102857 <__alltraps>

001021b5 <vector110>:
.globl vector110
vector110:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $110
  1021b7:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021b9:	e9 99 06 00 00       	jmp    102857 <__alltraps>

001021be <vector111>:
.globl vector111
vector111:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $111
  1021c0:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021c2:	e9 90 06 00 00       	jmp    102857 <__alltraps>

001021c7 <vector112>:
.globl vector112
vector112:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $112
  1021c9:	6a 70                	push   $0x70
  jmp __alltraps
  1021cb:	e9 87 06 00 00       	jmp    102857 <__alltraps>

001021d0 <vector113>:
.globl vector113
vector113:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $113
  1021d2:	6a 71                	push   $0x71
  jmp __alltraps
  1021d4:	e9 7e 06 00 00       	jmp    102857 <__alltraps>

001021d9 <vector114>:
.globl vector114
vector114:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $114
  1021db:	6a 72                	push   $0x72
  jmp __alltraps
  1021dd:	e9 75 06 00 00       	jmp    102857 <__alltraps>

001021e2 <vector115>:
.globl vector115
vector115:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $115
  1021e4:	6a 73                	push   $0x73
  jmp __alltraps
  1021e6:	e9 6c 06 00 00       	jmp    102857 <__alltraps>

001021eb <vector116>:
.globl vector116
vector116:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $116
  1021ed:	6a 74                	push   $0x74
  jmp __alltraps
  1021ef:	e9 63 06 00 00       	jmp    102857 <__alltraps>

001021f4 <vector117>:
.globl vector117
vector117:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $117
  1021f6:	6a 75                	push   $0x75
  jmp __alltraps
  1021f8:	e9 5a 06 00 00       	jmp    102857 <__alltraps>

001021fd <vector118>:
.globl vector118
vector118:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $118
  1021ff:	6a 76                	push   $0x76
  jmp __alltraps
  102201:	e9 51 06 00 00       	jmp    102857 <__alltraps>

00102206 <vector119>:
.globl vector119
vector119:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $119
  102208:	6a 77                	push   $0x77
  jmp __alltraps
  10220a:	e9 48 06 00 00       	jmp    102857 <__alltraps>

0010220f <vector120>:
.globl vector120
vector120:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $120
  102211:	6a 78                	push   $0x78
  jmp __alltraps
  102213:	e9 3f 06 00 00       	jmp    102857 <__alltraps>

00102218 <vector121>:
.globl vector121
vector121:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $121
  10221a:	6a 79                	push   $0x79
  jmp __alltraps
  10221c:	e9 36 06 00 00       	jmp    102857 <__alltraps>

00102221 <vector122>:
.globl vector122
vector122:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $122
  102223:	6a 7a                	push   $0x7a
  jmp __alltraps
  102225:	e9 2d 06 00 00       	jmp    102857 <__alltraps>

0010222a <vector123>:
.globl vector123
vector123:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $123
  10222c:	6a 7b                	push   $0x7b
  jmp __alltraps
  10222e:	e9 24 06 00 00       	jmp    102857 <__alltraps>

00102233 <vector124>:
.globl vector124
vector124:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $124
  102235:	6a 7c                	push   $0x7c
  jmp __alltraps
  102237:	e9 1b 06 00 00       	jmp    102857 <__alltraps>

0010223c <vector125>:
.globl vector125
vector125:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $125
  10223e:	6a 7d                	push   $0x7d
  jmp __alltraps
  102240:	e9 12 06 00 00       	jmp    102857 <__alltraps>

00102245 <vector126>:
.globl vector126
vector126:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $126
  102247:	6a 7e                	push   $0x7e
  jmp __alltraps
  102249:	e9 09 06 00 00       	jmp    102857 <__alltraps>

0010224e <vector127>:
.globl vector127
vector127:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $127
  102250:	6a 7f                	push   $0x7f
  jmp __alltraps
  102252:	e9 00 06 00 00       	jmp    102857 <__alltraps>

00102257 <vector128>:
.globl vector128
vector128:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $128
  102259:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10225e:	e9 f4 05 00 00       	jmp    102857 <__alltraps>

00102263 <vector129>:
.globl vector129
vector129:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $129
  102265:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10226a:	e9 e8 05 00 00       	jmp    102857 <__alltraps>

0010226f <vector130>:
.globl vector130
vector130:
  pushl $0
  10226f:	6a 00                	push   $0x0
  pushl $130
  102271:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102276:	e9 dc 05 00 00       	jmp    102857 <__alltraps>

0010227b <vector131>:
.globl vector131
vector131:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $131
  10227d:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102282:	e9 d0 05 00 00       	jmp    102857 <__alltraps>

00102287 <vector132>:
.globl vector132
vector132:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $132
  102289:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10228e:	e9 c4 05 00 00       	jmp    102857 <__alltraps>

00102293 <vector133>:
.globl vector133
vector133:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $133
  102295:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10229a:	e9 b8 05 00 00       	jmp    102857 <__alltraps>

0010229f <vector134>:
.globl vector134
vector134:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $134
  1022a1:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022a6:	e9 ac 05 00 00       	jmp    102857 <__alltraps>

001022ab <vector135>:
.globl vector135
vector135:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $135
  1022ad:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022b2:	e9 a0 05 00 00       	jmp    102857 <__alltraps>

001022b7 <vector136>:
.globl vector136
vector136:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $136
  1022b9:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022be:	e9 94 05 00 00       	jmp    102857 <__alltraps>

001022c3 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $137
  1022c5:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022ca:	e9 88 05 00 00       	jmp    102857 <__alltraps>

001022cf <vector138>:
.globl vector138
vector138:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $138
  1022d1:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022d6:	e9 7c 05 00 00       	jmp    102857 <__alltraps>

001022db <vector139>:
.globl vector139
vector139:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $139
  1022dd:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022e2:	e9 70 05 00 00       	jmp    102857 <__alltraps>

001022e7 <vector140>:
.globl vector140
vector140:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $140
  1022e9:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022ee:	e9 64 05 00 00       	jmp    102857 <__alltraps>

001022f3 <vector141>:
.globl vector141
vector141:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $141
  1022f5:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022fa:	e9 58 05 00 00       	jmp    102857 <__alltraps>

001022ff <vector142>:
.globl vector142
vector142:
  pushl $0
  1022ff:	6a 00                	push   $0x0
  pushl $142
  102301:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102306:	e9 4c 05 00 00       	jmp    102857 <__alltraps>

0010230b <vector143>:
.globl vector143
vector143:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $143
  10230d:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102312:	e9 40 05 00 00       	jmp    102857 <__alltraps>

00102317 <vector144>:
.globl vector144
vector144:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $144
  102319:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10231e:	e9 34 05 00 00       	jmp    102857 <__alltraps>

00102323 <vector145>:
.globl vector145
vector145:
  pushl $0
  102323:	6a 00                	push   $0x0
  pushl $145
  102325:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10232a:	e9 28 05 00 00       	jmp    102857 <__alltraps>

0010232f <vector146>:
.globl vector146
vector146:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $146
  102331:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102336:	e9 1c 05 00 00       	jmp    102857 <__alltraps>

0010233b <vector147>:
.globl vector147
vector147:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $147
  10233d:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102342:	e9 10 05 00 00       	jmp    102857 <__alltraps>

00102347 <vector148>:
.globl vector148
vector148:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $148
  102349:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10234e:	e9 04 05 00 00       	jmp    102857 <__alltraps>

00102353 <vector149>:
.globl vector149
vector149:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $149
  102355:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10235a:	e9 f8 04 00 00       	jmp    102857 <__alltraps>

0010235f <vector150>:
.globl vector150
vector150:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $150
  102361:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102366:	e9 ec 04 00 00       	jmp    102857 <__alltraps>

0010236b <vector151>:
.globl vector151
vector151:
  pushl $0
  10236b:	6a 00                	push   $0x0
  pushl $151
  10236d:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102372:	e9 e0 04 00 00       	jmp    102857 <__alltraps>

00102377 <vector152>:
.globl vector152
vector152:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $152
  102379:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10237e:	e9 d4 04 00 00       	jmp    102857 <__alltraps>

00102383 <vector153>:
.globl vector153
vector153:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $153
  102385:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10238a:	e9 c8 04 00 00       	jmp    102857 <__alltraps>

0010238f <vector154>:
.globl vector154
vector154:
  pushl $0
  10238f:	6a 00                	push   $0x0
  pushl $154
  102391:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102396:	e9 bc 04 00 00       	jmp    102857 <__alltraps>

0010239b <vector155>:
.globl vector155
vector155:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $155
  10239d:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023a2:	e9 b0 04 00 00       	jmp    102857 <__alltraps>

001023a7 <vector156>:
.globl vector156
vector156:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $156
  1023a9:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023ae:	e9 a4 04 00 00       	jmp    102857 <__alltraps>

001023b3 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023b3:	6a 00                	push   $0x0
  pushl $157
  1023b5:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023ba:	e9 98 04 00 00       	jmp    102857 <__alltraps>

001023bf <vector158>:
.globl vector158
vector158:
  pushl $0
  1023bf:	6a 00                	push   $0x0
  pushl $158
  1023c1:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023c6:	e9 8c 04 00 00       	jmp    102857 <__alltraps>

001023cb <vector159>:
.globl vector159
vector159:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $159
  1023cd:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023d2:	e9 80 04 00 00       	jmp    102857 <__alltraps>

001023d7 <vector160>:
.globl vector160
vector160:
  pushl $0
  1023d7:	6a 00                	push   $0x0
  pushl $160
  1023d9:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023de:	e9 74 04 00 00       	jmp    102857 <__alltraps>

001023e3 <vector161>:
.globl vector161
vector161:
  pushl $0
  1023e3:	6a 00                	push   $0x0
  pushl $161
  1023e5:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023ea:	e9 68 04 00 00       	jmp    102857 <__alltraps>

001023ef <vector162>:
.globl vector162
vector162:
  pushl $0
  1023ef:	6a 00                	push   $0x0
  pushl $162
  1023f1:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023f6:	e9 5c 04 00 00       	jmp    102857 <__alltraps>

001023fb <vector163>:
.globl vector163
vector163:
  pushl $0
  1023fb:	6a 00                	push   $0x0
  pushl $163
  1023fd:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102402:	e9 50 04 00 00       	jmp    102857 <__alltraps>

00102407 <vector164>:
.globl vector164
vector164:
  pushl $0
  102407:	6a 00                	push   $0x0
  pushl $164
  102409:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10240e:	e9 44 04 00 00       	jmp    102857 <__alltraps>

00102413 <vector165>:
.globl vector165
vector165:
  pushl $0
  102413:	6a 00                	push   $0x0
  pushl $165
  102415:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10241a:	e9 38 04 00 00       	jmp    102857 <__alltraps>

0010241f <vector166>:
.globl vector166
vector166:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $166
  102421:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102426:	e9 2c 04 00 00       	jmp    102857 <__alltraps>

0010242b <vector167>:
.globl vector167
vector167:
  pushl $0
  10242b:	6a 00                	push   $0x0
  pushl $167
  10242d:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102432:	e9 20 04 00 00       	jmp    102857 <__alltraps>

00102437 <vector168>:
.globl vector168
vector168:
  pushl $0
  102437:	6a 00                	push   $0x0
  pushl $168
  102439:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10243e:	e9 14 04 00 00       	jmp    102857 <__alltraps>

00102443 <vector169>:
.globl vector169
vector169:
  pushl $0
  102443:	6a 00                	push   $0x0
  pushl $169
  102445:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10244a:	e9 08 04 00 00       	jmp    102857 <__alltraps>

0010244f <vector170>:
.globl vector170
vector170:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $170
  102451:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102456:	e9 fc 03 00 00       	jmp    102857 <__alltraps>

0010245b <vector171>:
.globl vector171
vector171:
  pushl $0
  10245b:	6a 00                	push   $0x0
  pushl $171
  10245d:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102462:	e9 f0 03 00 00       	jmp    102857 <__alltraps>

00102467 <vector172>:
.globl vector172
vector172:
  pushl $0
  102467:	6a 00                	push   $0x0
  pushl $172
  102469:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10246e:	e9 e4 03 00 00       	jmp    102857 <__alltraps>

00102473 <vector173>:
.globl vector173
vector173:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $173
  102475:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10247a:	e9 d8 03 00 00       	jmp    102857 <__alltraps>

0010247f <vector174>:
.globl vector174
vector174:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $174
  102481:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102486:	e9 cc 03 00 00       	jmp    102857 <__alltraps>

0010248b <vector175>:
.globl vector175
vector175:
  pushl $0
  10248b:	6a 00                	push   $0x0
  pushl $175
  10248d:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102492:	e9 c0 03 00 00       	jmp    102857 <__alltraps>

00102497 <vector176>:
.globl vector176
vector176:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $176
  102499:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10249e:	e9 b4 03 00 00       	jmp    102857 <__alltraps>

001024a3 <vector177>:
.globl vector177
vector177:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $177
  1024a5:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024aa:	e9 a8 03 00 00       	jmp    102857 <__alltraps>

001024af <vector178>:
.globl vector178
vector178:
  pushl $0
  1024af:	6a 00                	push   $0x0
  pushl $178
  1024b1:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024b6:	e9 9c 03 00 00       	jmp    102857 <__alltraps>

001024bb <vector179>:
.globl vector179
vector179:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $179
  1024bd:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024c2:	e9 90 03 00 00       	jmp    102857 <__alltraps>

001024c7 <vector180>:
.globl vector180
vector180:
  pushl $0
  1024c7:	6a 00                	push   $0x0
  pushl $180
  1024c9:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024ce:	e9 84 03 00 00       	jmp    102857 <__alltraps>

001024d3 <vector181>:
.globl vector181
vector181:
  pushl $0
  1024d3:	6a 00                	push   $0x0
  pushl $181
  1024d5:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024da:	e9 78 03 00 00       	jmp    102857 <__alltraps>

001024df <vector182>:
.globl vector182
vector182:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $182
  1024e1:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024e6:	e9 6c 03 00 00       	jmp    102857 <__alltraps>

001024eb <vector183>:
.globl vector183
vector183:
  pushl $0
  1024eb:	6a 00                	push   $0x0
  pushl $183
  1024ed:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024f2:	e9 60 03 00 00       	jmp    102857 <__alltraps>

001024f7 <vector184>:
.globl vector184
vector184:
  pushl $0
  1024f7:	6a 00                	push   $0x0
  pushl $184
  1024f9:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024fe:	e9 54 03 00 00       	jmp    102857 <__alltraps>

00102503 <vector185>:
.globl vector185
vector185:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $185
  102505:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10250a:	e9 48 03 00 00       	jmp    102857 <__alltraps>

0010250f <vector186>:
.globl vector186
vector186:
  pushl $0
  10250f:	6a 00                	push   $0x0
  pushl $186
  102511:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102516:	e9 3c 03 00 00       	jmp    102857 <__alltraps>

0010251b <vector187>:
.globl vector187
vector187:
  pushl $0
  10251b:	6a 00                	push   $0x0
  pushl $187
  10251d:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102522:	e9 30 03 00 00       	jmp    102857 <__alltraps>

00102527 <vector188>:
.globl vector188
vector188:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $188
  102529:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10252e:	e9 24 03 00 00       	jmp    102857 <__alltraps>

00102533 <vector189>:
.globl vector189
vector189:
  pushl $0
  102533:	6a 00                	push   $0x0
  pushl $189
  102535:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10253a:	e9 18 03 00 00       	jmp    102857 <__alltraps>

0010253f <vector190>:
.globl vector190
vector190:
  pushl $0
  10253f:	6a 00                	push   $0x0
  pushl $190
  102541:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102546:	e9 0c 03 00 00       	jmp    102857 <__alltraps>

0010254b <vector191>:
.globl vector191
vector191:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $191
  10254d:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102552:	e9 00 03 00 00       	jmp    102857 <__alltraps>

00102557 <vector192>:
.globl vector192
vector192:
  pushl $0
  102557:	6a 00                	push   $0x0
  pushl $192
  102559:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10255e:	e9 f4 02 00 00       	jmp    102857 <__alltraps>

00102563 <vector193>:
.globl vector193
vector193:
  pushl $0
  102563:	6a 00                	push   $0x0
  pushl $193
  102565:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10256a:	e9 e8 02 00 00       	jmp    102857 <__alltraps>

0010256f <vector194>:
.globl vector194
vector194:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $194
  102571:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102576:	e9 dc 02 00 00       	jmp    102857 <__alltraps>

0010257b <vector195>:
.globl vector195
vector195:
  pushl $0
  10257b:	6a 00                	push   $0x0
  pushl $195
  10257d:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102582:	e9 d0 02 00 00       	jmp    102857 <__alltraps>

00102587 <vector196>:
.globl vector196
vector196:
  pushl $0
  102587:	6a 00                	push   $0x0
  pushl $196
  102589:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10258e:	e9 c4 02 00 00       	jmp    102857 <__alltraps>

00102593 <vector197>:
.globl vector197
vector197:
  pushl $0
  102593:	6a 00                	push   $0x0
  pushl $197
  102595:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10259a:	e9 b8 02 00 00       	jmp    102857 <__alltraps>

0010259f <vector198>:
.globl vector198
vector198:
  pushl $0
  10259f:	6a 00                	push   $0x0
  pushl $198
  1025a1:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025a6:	e9 ac 02 00 00       	jmp    102857 <__alltraps>

001025ab <vector199>:
.globl vector199
vector199:
  pushl $0
  1025ab:	6a 00                	push   $0x0
  pushl $199
  1025ad:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025b2:	e9 a0 02 00 00       	jmp    102857 <__alltraps>

001025b7 <vector200>:
.globl vector200
vector200:
  pushl $0
  1025b7:	6a 00                	push   $0x0
  pushl $200
  1025b9:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025be:	e9 94 02 00 00       	jmp    102857 <__alltraps>

001025c3 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025c3:	6a 00                	push   $0x0
  pushl $201
  1025c5:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025ca:	e9 88 02 00 00       	jmp    102857 <__alltraps>

001025cf <vector202>:
.globl vector202
vector202:
  pushl $0
  1025cf:	6a 00                	push   $0x0
  pushl $202
  1025d1:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025d6:	e9 7c 02 00 00       	jmp    102857 <__alltraps>

001025db <vector203>:
.globl vector203
vector203:
  pushl $0
  1025db:	6a 00                	push   $0x0
  pushl $203
  1025dd:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025e2:	e9 70 02 00 00       	jmp    102857 <__alltraps>

001025e7 <vector204>:
.globl vector204
vector204:
  pushl $0
  1025e7:	6a 00                	push   $0x0
  pushl $204
  1025e9:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025ee:	e9 64 02 00 00       	jmp    102857 <__alltraps>

001025f3 <vector205>:
.globl vector205
vector205:
  pushl $0
  1025f3:	6a 00                	push   $0x0
  pushl $205
  1025f5:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025fa:	e9 58 02 00 00       	jmp    102857 <__alltraps>

001025ff <vector206>:
.globl vector206
vector206:
  pushl $0
  1025ff:	6a 00                	push   $0x0
  pushl $206
  102601:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102606:	e9 4c 02 00 00       	jmp    102857 <__alltraps>

0010260b <vector207>:
.globl vector207
vector207:
  pushl $0
  10260b:	6a 00                	push   $0x0
  pushl $207
  10260d:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102612:	e9 40 02 00 00       	jmp    102857 <__alltraps>

00102617 <vector208>:
.globl vector208
vector208:
  pushl $0
  102617:	6a 00                	push   $0x0
  pushl $208
  102619:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10261e:	e9 34 02 00 00       	jmp    102857 <__alltraps>

00102623 <vector209>:
.globl vector209
vector209:
  pushl $0
  102623:	6a 00                	push   $0x0
  pushl $209
  102625:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10262a:	e9 28 02 00 00       	jmp    102857 <__alltraps>

0010262f <vector210>:
.globl vector210
vector210:
  pushl $0
  10262f:	6a 00                	push   $0x0
  pushl $210
  102631:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102636:	e9 1c 02 00 00       	jmp    102857 <__alltraps>

0010263b <vector211>:
.globl vector211
vector211:
  pushl $0
  10263b:	6a 00                	push   $0x0
  pushl $211
  10263d:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102642:	e9 10 02 00 00       	jmp    102857 <__alltraps>

00102647 <vector212>:
.globl vector212
vector212:
  pushl $0
  102647:	6a 00                	push   $0x0
  pushl $212
  102649:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10264e:	e9 04 02 00 00       	jmp    102857 <__alltraps>

00102653 <vector213>:
.globl vector213
vector213:
  pushl $0
  102653:	6a 00                	push   $0x0
  pushl $213
  102655:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10265a:	e9 f8 01 00 00       	jmp    102857 <__alltraps>

0010265f <vector214>:
.globl vector214
vector214:
  pushl $0
  10265f:	6a 00                	push   $0x0
  pushl $214
  102661:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102666:	e9 ec 01 00 00       	jmp    102857 <__alltraps>

0010266b <vector215>:
.globl vector215
vector215:
  pushl $0
  10266b:	6a 00                	push   $0x0
  pushl $215
  10266d:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102672:	e9 e0 01 00 00       	jmp    102857 <__alltraps>

00102677 <vector216>:
.globl vector216
vector216:
  pushl $0
  102677:	6a 00                	push   $0x0
  pushl $216
  102679:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10267e:	e9 d4 01 00 00       	jmp    102857 <__alltraps>

00102683 <vector217>:
.globl vector217
vector217:
  pushl $0
  102683:	6a 00                	push   $0x0
  pushl $217
  102685:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10268a:	e9 c8 01 00 00       	jmp    102857 <__alltraps>

0010268f <vector218>:
.globl vector218
vector218:
  pushl $0
  10268f:	6a 00                	push   $0x0
  pushl $218
  102691:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102696:	e9 bc 01 00 00       	jmp    102857 <__alltraps>

0010269b <vector219>:
.globl vector219
vector219:
  pushl $0
  10269b:	6a 00                	push   $0x0
  pushl $219
  10269d:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026a2:	e9 b0 01 00 00       	jmp    102857 <__alltraps>

001026a7 <vector220>:
.globl vector220
vector220:
  pushl $0
  1026a7:	6a 00                	push   $0x0
  pushl $220
  1026a9:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026ae:	e9 a4 01 00 00       	jmp    102857 <__alltraps>

001026b3 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026b3:	6a 00                	push   $0x0
  pushl $221
  1026b5:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026ba:	e9 98 01 00 00       	jmp    102857 <__alltraps>

001026bf <vector222>:
.globl vector222
vector222:
  pushl $0
  1026bf:	6a 00                	push   $0x0
  pushl $222
  1026c1:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026c6:	e9 8c 01 00 00       	jmp    102857 <__alltraps>

001026cb <vector223>:
.globl vector223
vector223:
  pushl $0
  1026cb:	6a 00                	push   $0x0
  pushl $223
  1026cd:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026d2:	e9 80 01 00 00       	jmp    102857 <__alltraps>

001026d7 <vector224>:
.globl vector224
vector224:
  pushl $0
  1026d7:	6a 00                	push   $0x0
  pushl $224
  1026d9:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026de:	e9 74 01 00 00       	jmp    102857 <__alltraps>

001026e3 <vector225>:
.globl vector225
vector225:
  pushl $0
  1026e3:	6a 00                	push   $0x0
  pushl $225
  1026e5:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026ea:	e9 68 01 00 00       	jmp    102857 <__alltraps>

001026ef <vector226>:
.globl vector226
vector226:
  pushl $0
  1026ef:	6a 00                	push   $0x0
  pushl $226
  1026f1:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026f6:	e9 5c 01 00 00       	jmp    102857 <__alltraps>

001026fb <vector227>:
.globl vector227
vector227:
  pushl $0
  1026fb:	6a 00                	push   $0x0
  pushl $227
  1026fd:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102702:	e9 50 01 00 00       	jmp    102857 <__alltraps>

00102707 <vector228>:
.globl vector228
vector228:
  pushl $0
  102707:	6a 00                	push   $0x0
  pushl $228
  102709:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10270e:	e9 44 01 00 00       	jmp    102857 <__alltraps>

00102713 <vector229>:
.globl vector229
vector229:
  pushl $0
  102713:	6a 00                	push   $0x0
  pushl $229
  102715:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10271a:	e9 38 01 00 00       	jmp    102857 <__alltraps>

0010271f <vector230>:
.globl vector230
vector230:
  pushl $0
  10271f:	6a 00                	push   $0x0
  pushl $230
  102721:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102726:	e9 2c 01 00 00       	jmp    102857 <__alltraps>

0010272b <vector231>:
.globl vector231
vector231:
  pushl $0
  10272b:	6a 00                	push   $0x0
  pushl $231
  10272d:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102732:	e9 20 01 00 00       	jmp    102857 <__alltraps>

00102737 <vector232>:
.globl vector232
vector232:
  pushl $0
  102737:	6a 00                	push   $0x0
  pushl $232
  102739:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10273e:	e9 14 01 00 00       	jmp    102857 <__alltraps>

00102743 <vector233>:
.globl vector233
vector233:
  pushl $0
  102743:	6a 00                	push   $0x0
  pushl $233
  102745:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10274a:	e9 08 01 00 00       	jmp    102857 <__alltraps>

0010274f <vector234>:
.globl vector234
vector234:
  pushl $0
  10274f:	6a 00                	push   $0x0
  pushl $234
  102751:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102756:	e9 fc 00 00 00       	jmp    102857 <__alltraps>

0010275b <vector235>:
.globl vector235
vector235:
  pushl $0
  10275b:	6a 00                	push   $0x0
  pushl $235
  10275d:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102762:	e9 f0 00 00 00       	jmp    102857 <__alltraps>

00102767 <vector236>:
.globl vector236
vector236:
  pushl $0
  102767:	6a 00                	push   $0x0
  pushl $236
  102769:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10276e:	e9 e4 00 00 00       	jmp    102857 <__alltraps>

00102773 <vector237>:
.globl vector237
vector237:
  pushl $0
  102773:	6a 00                	push   $0x0
  pushl $237
  102775:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10277a:	e9 d8 00 00 00       	jmp    102857 <__alltraps>

0010277f <vector238>:
.globl vector238
vector238:
  pushl $0
  10277f:	6a 00                	push   $0x0
  pushl $238
  102781:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102786:	e9 cc 00 00 00       	jmp    102857 <__alltraps>

0010278b <vector239>:
.globl vector239
vector239:
  pushl $0
  10278b:	6a 00                	push   $0x0
  pushl $239
  10278d:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102792:	e9 c0 00 00 00       	jmp    102857 <__alltraps>

00102797 <vector240>:
.globl vector240
vector240:
  pushl $0
  102797:	6a 00                	push   $0x0
  pushl $240
  102799:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10279e:	e9 b4 00 00 00       	jmp    102857 <__alltraps>

001027a3 <vector241>:
.globl vector241
vector241:
  pushl $0
  1027a3:	6a 00                	push   $0x0
  pushl $241
  1027a5:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027aa:	e9 a8 00 00 00       	jmp    102857 <__alltraps>

001027af <vector242>:
.globl vector242
vector242:
  pushl $0
  1027af:	6a 00                	push   $0x0
  pushl $242
  1027b1:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027b6:	e9 9c 00 00 00       	jmp    102857 <__alltraps>

001027bb <vector243>:
.globl vector243
vector243:
  pushl $0
  1027bb:	6a 00                	push   $0x0
  pushl $243
  1027bd:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027c2:	e9 90 00 00 00       	jmp    102857 <__alltraps>

001027c7 <vector244>:
.globl vector244
vector244:
  pushl $0
  1027c7:	6a 00                	push   $0x0
  pushl $244
  1027c9:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027ce:	e9 84 00 00 00       	jmp    102857 <__alltraps>

001027d3 <vector245>:
.globl vector245
vector245:
  pushl $0
  1027d3:	6a 00                	push   $0x0
  pushl $245
  1027d5:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027da:	e9 78 00 00 00       	jmp    102857 <__alltraps>

001027df <vector246>:
.globl vector246
vector246:
  pushl $0
  1027df:	6a 00                	push   $0x0
  pushl $246
  1027e1:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027e6:	e9 6c 00 00 00       	jmp    102857 <__alltraps>

001027eb <vector247>:
.globl vector247
vector247:
  pushl $0
  1027eb:	6a 00                	push   $0x0
  pushl $247
  1027ed:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027f2:	e9 60 00 00 00       	jmp    102857 <__alltraps>

001027f7 <vector248>:
.globl vector248
vector248:
  pushl $0
  1027f7:	6a 00                	push   $0x0
  pushl $248
  1027f9:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027fe:	e9 54 00 00 00       	jmp    102857 <__alltraps>

00102803 <vector249>:
.globl vector249
vector249:
  pushl $0
  102803:	6a 00                	push   $0x0
  pushl $249
  102805:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10280a:	e9 48 00 00 00       	jmp    102857 <__alltraps>

0010280f <vector250>:
.globl vector250
vector250:
  pushl $0
  10280f:	6a 00                	push   $0x0
  pushl $250
  102811:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102816:	e9 3c 00 00 00       	jmp    102857 <__alltraps>

0010281b <vector251>:
.globl vector251
vector251:
  pushl $0
  10281b:	6a 00                	push   $0x0
  pushl $251
  10281d:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102822:	e9 30 00 00 00       	jmp    102857 <__alltraps>

00102827 <vector252>:
.globl vector252
vector252:
  pushl $0
  102827:	6a 00                	push   $0x0
  pushl $252
  102829:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10282e:	e9 24 00 00 00       	jmp    102857 <__alltraps>

00102833 <vector253>:
.globl vector253
vector253:
  pushl $0
  102833:	6a 00                	push   $0x0
  pushl $253
  102835:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10283a:	e9 18 00 00 00       	jmp    102857 <__alltraps>

0010283f <vector254>:
.globl vector254
vector254:
  pushl $0
  10283f:	6a 00                	push   $0x0
  pushl $254
  102841:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102846:	e9 0c 00 00 00       	jmp    102857 <__alltraps>

0010284b <vector255>:
.globl vector255
vector255:
  pushl $0
  10284b:	6a 00                	push   $0x0
  pushl $255
  10284d:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102852:	e9 00 00 00 00       	jmp    102857 <__alltraps>

00102857 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102857:	1e                   	push   %ds
    pushl %es
  102858:	06                   	push   %es
    pushl %fs
  102859:	0f a0                	push   %fs
    pushl %gs
  10285b:	0f a8                	push   %gs
    pushal
  10285d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  10285e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102863:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102865:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102867:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102868:	e8 63 f5 ff ff       	call   101dd0 <trap>

    # pop the pushed stack pointer
    popl %esp
  10286d:	5c                   	pop    %esp

0010286e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  10286e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  10286f:	0f a9                	pop    %gs
    popl %fs
  102871:	0f a1                	pop    %fs
    popl %es
  102873:	07                   	pop    %es
    popl %ds
  102874:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102875:	83 c4 08             	add    $0x8,%esp
    iret
  102878:	cf                   	iret   

00102879 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102879:	55                   	push   %ebp
  10287a:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10287c:	8b 45 08             	mov    0x8(%ebp),%eax
  10287f:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102882:	b8 23 00 00 00       	mov    $0x23,%eax
  102887:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102889:	b8 23 00 00 00       	mov    $0x23,%eax
  10288e:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102890:	b8 10 00 00 00       	mov    $0x10,%eax
  102895:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102897:	b8 10 00 00 00       	mov    $0x10,%eax
  10289c:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10289e:	b8 10 00 00 00       	mov    $0x10,%eax
  1028a3:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1028a5:	ea ac 28 10 00 08 00 	ljmp   $0x8,$0x1028ac
}
  1028ac:	90                   	nop
  1028ad:	5d                   	pop    %ebp
  1028ae:	c3                   	ret    

001028af <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1028af:	55                   	push   %ebp
  1028b0:	89 e5                	mov    %esp,%ebp
  1028b2:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1028b5:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  1028ba:	05 00 04 00 00       	add    $0x400,%eax
  1028bf:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1028c4:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1028cb:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1028cd:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1028d4:	68 00 
  1028d6:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028db:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1028e1:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028e6:	c1 e8 10             	shr    $0x10,%eax
  1028e9:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1028ee:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028f5:	83 e0 f0             	and    $0xfffffff0,%eax
  1028f8:	83 c8 09             	or     $0x9,%eax
  1028fb:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102900:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102907:	83 c8 10             	or     $0x10,%eax
  10290a:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10290f:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102916:	83 e0 9f             	and    $0xffffff9f,%eax
  102919:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10291e:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102925:	83 c8 80             	or     $0xffffff80,%eax
  102928:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10292d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102934:	83 e0 f0             	and    $0xfffffff0,%eax
  102937:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10293c:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102943:	83 e0 ef             	and    $0xffffffef,%eax
  102946:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10294b:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102952:	83 e0 df             	and    $0xffffffdf,%eax
  102955:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10295a:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102961:	83 c8 40             	or     $0x40,%eax
  102964:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102969:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102970:	83 e0 7f             	and    $0x7f,%eax
  102973:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102978:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10297d:	c1 e8 18             	shr    $0x18,%eax
  102980:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102985:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10298c:	83 e0 ef             	and    $0xffffffef,%eax
  10298f:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102994:	68 10 ea 10 00       	push   $0x10ea10
  102999:	e8 db fe ff ff       	call   102879 <lgdt>
  10299e:	83 c4 04             	add    $0x4,%esp
  1029a1:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  1029a7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1029ab:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1029ae:	90                   	nop
  1029af:	c9                   	leave  
  1029b0:	c3                   	ret    

001029b1 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1029b1:	55                   	push   %ebp
  1029b2:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1029b4:	e8 f6 fe ff ff       	call   1028af <gdt_init>
}
  1029b9:	90                   	nop
  1029ba:	5d                   	pop    %ebp
  1029bb:	c3                   	ret    

001029bc <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1029bc:	55                   	push   %ebp
  1029bd:	89 e5                	mov    %esp,%ebp
  1029bf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1029c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1029c9:	eb 04                	jmp    1029cf <strlen+0x13>
        cnt ++;
  1029cb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d2:	8d 50 01             	lea    0x1(%eax),%edx
  1029d5:	89 55 08             	mov    %edx,0x8(%ebp)
  1029d8:	0f b6 00             	movzbl (%eax),%eax
  1029db:	84 c0                	test   %al,%al
  1029dd:	75 ec                	jne    1029cb <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1029df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1029e2:	c9                   	leave  
  1029e3:	c3                   	ret    

001029e4 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1029e4:	55                   	push   %ebp
  1029e5:	89 e5                	mov    %esp,%ebp
  1029e7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1029ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1029f1:	eb 04                	jmp    1029f7 <strnlen+0x13>
        cnt ++;
  1029f3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  1029f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1029fd:	73 10                	jae    102a0f <strnlen+0x2b>
  1029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  102a02:	8d 50 01             	lea    0x1(%eax),%edx
  102a05:	89 55 08             	mov    %edx,0x8(%ebp)
  102a08:	0f b6 00             	movzbl (%eax),%eax
  102a0b:	84 c0                	test   %al,%al
  102a0d:	75 e4                	jne    1029f3 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102a0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102a12:	c9                   	leave  
  102a13:	c3                   	ret    

00102a14 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102a14:	55                   	push   %ebp
  102a15:	89 e5                	mov    %esp,%ebp
  102a17:	57                   	push   %edi
  102a18:	56                   	push   %esi
  102a19:	83 ec 20             	sub    $0x20,%esp
  102a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102a28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a2e:	89 d1                	mov    %edx,%ecx
  102a30:	89 c2                	mov    %eax,%edx
  102a32:	89 ce                	mov    %ecx,%esi
  102a34:	89 d7                	mov    %edx,%edi
  102a36:	ac                   	lods   %ds:(%esi),%al
  102a37:	aa                   	stos   %al,%es:(%edi)
  102a38:	84 c0                	test   %al,%al
  102a3a:	75 fa                	jne    102a36 <strcpy+0x22>
  102a3c:	89 fa                	mov    %edi,%edx
  102a3e:	89 f1                	mov    %esi,%ecx
  102a40:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102a43:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102a46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102a4c:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102a4d:	83 c4 20             	add    $0x20,%esp
  102a50:	5e                   	pop    %esi
  102a51:	5f                   	pop    %edi
  102a52:	5d                   	pop    %ebp
  102a53:	c3                   	ret    

00102a54 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102a54:	55                   	push   %ebp
  102a55:	89 e5                	mov    %esp,%ebp
  102a57:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102a60:	eb 21                	jmp    102a83 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a65:	0f b6 10             	movzbl (%eax),%edx
  102a68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a6b:	88 10                	mov    %dl,(%eax)
  102a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a70:	0f b6 00             	movzbl (%eax),%eax
  102a73:	84 c0                	test   %al,%al
  102a75:	74 04                	je     102a7b <strncpy+0x27>
            src ++;
  102a77:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102a7b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102a7f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102a83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a87:	75 d9                	jne    102a62 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102a89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102a8c:	c9                   	leave  
  102a8d:	c3                   	ret    

00102a8e <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102a8e:	55                   	push   %ebp
  102a8f:	89 e5                	mov    %esp,%ebp
  102a91:	57                   	push   %edi
  102a92:	56                   	push   %esi
  102a93:	83 ec 20             	sub    $0x20,%esp
  102a96:	8b 45 08             	mov    0x8(%ebp),%eax
  102a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102aa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aa8:	89 d1                	mov    %edx,%ecx
  102aaa:	89 c2                	mov    %eax,%edx
  102aac:	89 ce                	mov    %ecx,%esi
  102aae:	89 d7                	mov    %edx,%edi
  102ab0:	ac                   	lods   %ds:(%esi),%al
  102ab1:	ae                   	scas   %es:(%edi),%al
  102ab2:	75 08                	jne    102abc <strcmp+0x2e>
  102ab4:	84 c0                	test   %al,%al
  102ab6:	75 f8                	jne    102ab0 <strcmp+0x22>
  102ab8:	31 c0                	xor    %eax,%eax
  102aba:	eb 04                	jmp    102ac0 <strcmp+0x32>
  102abc:	19 c0                	sbb    %eax,%eax
  102abe:	0c 01                	or     $0x1,%al
  102ac0:	89 fa                	mov    %edi,%edx
  102ac2:	89 f1                	mov    %esi,%ecx
  102ac4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ac7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102aca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102ad0:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102ad1:	83 c4 20             	add    $0x20,%esp
  102ad4:	5e                   	pop    %esi
  102ad5:	5f                   	pop    %edi
  102ad6:	5d                   	pop    %ebp
  102ad7:	c3                   	ret    

00102ad8 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102ad8:	55                   	push   %ebp
  102ad9:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102adb:	eb 0c                	jmp    102ae9 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102add:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ae1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ae5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102ae9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102aed:	74 1a                	je     102b09 <strncmp+0x31>
  102aef:	8b 45 08             	mov    0x8(%ebp),%eax
  102af2:	0f b6 00             	movzbl (%eax),%eax
  102af5:	84 c0                	test   %al,%al
  102af7:	74 10                	je     102b09 <strncmp+0x31>
  102af9:	8b 45 08             	mov    0x8(%ebp),%eax
  102afc:	0f b6 10             	movzbl (%eax),%edx
  102aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b02:	0f b6 00             	movzbl (%eax),%eax
  102b05:	38 c2                	cmp    %al,%dl
  102b07:	74 d4                	je     102add <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102b09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b0d:	74 18                	je     102b27 <strncmp+0x4f>
  102b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b12:	0f b6 00             	movzbl (%eax),%eax
  102b15:	0f b6 d0             	movzbl %al,%edx
  102b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b1b:	0f b6 00             	movzbl (%eax),%eax
  102b1e:	0f b6 c0             	movzbl %al,%eax
  102b21:	29 c2                	sub    %eax,%edx
  102b23:	89 d0                	mov    %edx,%eax
  102b25:	eb 05                	jmp    102b2c <strncmp+0x54>
  102b27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b2c:	5d                   	pop    %ebp
  102b2d:	c3                   	ret    

00102b2e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102b2e:	55                   	push   %ebp
  102b2f:	89 e5                	mov    %esp,%ebp
  102b31:	83 ec 04             	sub    $0x4,%esp
  102b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b37:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102b3a:	eb 14                	jmp    102b50 <strchr+0x22>
        if (*s == c) {
  102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3f:	0f b6 00             	movzbl (%eax),%eax
  102b42:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102b45:	75 05                	jne    102b4c <strchr+0x1e>
            return (char *)s;
  102b47:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4a:	eb 13                	jmp    102b5f <strchr+0x31>
        }
        s ++;
  102b4c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102b50:	8b 45 08             	mov    0x8(%ebp),%eax
  102b53:	0f b6 00             	movzbl (%eax),%eax
  102b56:	84 c0                	test   %al,%al
  102b58:	75 e2                	jne    102b3c <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102b5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b5f:	c9                   	leave  
  102b60:	c3                   	ret    

00102b61 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102b61:	55                   	push   %ebp
  102b62:	89 e5                	mov    %esp,%ebp
  102b64:	83 ec 04             	sub    $0x4,%esp
  102b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b6a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102b6d:	eb 0f                	jmp    102b7e <strfind+0x1d>
        if (*s == c) {
  102b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b72:	0f b6 00             	movzbl (%eax),%eax
  102b75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102b78:	74 10                	je     102b8a <strfind+0x29>
            break;
        }
        s ++;
  102b7a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b81:	0f b6 00             	movzbl (%eax),%eax
  102b84:	84 c0                	test   %al,%al
  102b86:	75 e7                	jne    102b6f <strfind+0xe>
  102b88:	eb 01                	jmp    102b8b <strfind+0x2a>
        if (*s == c) {
            break;
  102b8a:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  102b8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102b8e:	c9                   	leave  
  102b8f:	c3                   	ret    

00102b90 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102b90:	55                   	push   %ebp
  102b91:	89 e5                	mov    %esp,%ebp
  102b93:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102b96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102b9d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102ba4:	eb 04                	jmp    102baa <strtol+0x1a>
        s ++;
  102ba6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102baa:	8b 45 08             	mov    0x8(%ebp),%eax
  102bad:	0f b6 00             	movzbl (%eax),%eax
  102bb0:	3c 20                	cmp    $0x20,%al
  102bb2:	74 f2                	je     102ba6 <strtol+0x16>
  102bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb7:	0f b6 00             	movzbl (%eax),%eax
  102bba:	3c 09                	cmp    $0x9,%al
  102bbc:	74 e8                	je     102ba6 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc1:	0f b6 00             	movzbl (%eax),%eax
  102bc4:	3c 2b                	cmp    $0x2b,%al
  102bc6:	75 06                	jne    102bce <strtol+0x3e>
        s ++;
  102bc8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102bcc:	eb 15                	jmp    102be3 <strtol+0x53>
    }
    else if (*s == '-') {
  102bce:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd1:	0f b6 00             	movzbl (%eax),%eax
  102bd4:	3c 2d                	cmp    $0x2d,%al
  102bd6:	75 0b                	jne    102be3 <strtol+0x53>
        s ++, neg = 1;
  102bd8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102bdc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102be3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102be7:	74 06                	je     102bef <strtol+0x5f>
  102be9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102bed:	75 24                	jne    102c13 <strtol+0x83>
  102bef:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf2:	0f b6 00             	movzbl (%eax),%eax
  102bf5:	3c 30                	cmp    $0x30,%al
  102bf7:	75 1a                	jne    102c13 <strtol+0x83>
  102bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfc:	83 c0 01             	add    $0x1,%eax
  102bff:	0f b6 00             	movzbl (%eax),%eax
  102c02:	3c 78                	cmp    $0x78,%al
  102c04:	75 0d                	jne    102c13 <strtol+0x83>
        s += 2, base = 16;
  102c06:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102c0a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102c11:	eb 2a                	jmp    102c3d <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102c13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c17:	75 17                	jne    102c30 <strtol+0xa0>
  102c19:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1c:	0f b6 00             	movzbl (%eax),%eax
  102c1f:	3c 30                	cmp    $0x30,%al
  102c21:	75 0d                	jne    102c30 <strtol+0xa0>
        s ++, base = 8;
  102c23:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c27:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102c2e:	eb 0d                	jmp    102c3d <strtol+0xad>
    }
    else if (base == 0) {
  102c30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c34:	75 07                	jne    102c3d <strtol+0xad>
        base = 10;
  102c36:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c40:	0f b6 00             	movzbl (%eax),%eax
  102c43:	3c 2f                	cmp    $0x2f,%al
  102c45:	7e 1b                	jle    102c62 <strtol+0xd2>
  102c47:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4a:	0f b6 00             	movzbl (%eax),%eax
  102c4d:	3c 39                	cmp    $0x39,%al
  102c4f:	7f 11                	jg     102c62 <strtol+0xd2>
            dig = *s - '0';
  102c51:	8b 45 08             	mov    0x8(%ebp),%eax
  102c54:	0f b6 00             	movzbl (%eax),%eax
  102c57:	0f be c0             	movsbl %al,%eax
  102c5a:	83 e8 30             	sub    $0x30,%eax
  102c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c60:	eb 48                	jmp    102caa <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102c62:	8b 45 08             	mov    0x8(%ebp),%eax
  102c65:	0f b6 00             	movzbl (%eax),%eax
  102c68:	3c 60                	cmp    $0x60,%al
  102c6a:	7e 1b                	jle    102c87 <strtol+0xf7>
  102c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6f:	0f b6 00             	movzbl (%eax),%eax
  102c72:	3c 7a                	cmp    $0x7a,%al
  102c74:	7f 11                	jg     102c87 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102c76:	8b 45 08             	mov    0x8(%ebp),%eax
  102c79:	0f b6 00             	movzbl (%eax),%eax
  102c7c:	0f be c0             	movsbl %al,%eax
  102c7f:	83 e8 57             	sub    $0x57,%eax
  102c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c85:	eb 23                	jmp    102caa <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102c87:	8b 45 08             	mov    0x8(%ebp),%eax
  102c8a:	0f b6 00             	movzbl (%eax),%eax
  102c8d:	3c 40                	cmp    $0x40,%al
  102c8f:	7e 3c                	jle    102ccd <strtol+0x13d>
  102c91:	8b 45 08             	mov    0x8(%ebp),%eax
  102c94:	0f b6 00             	movzbl (%eax),%eax
  102c97:	3c 5a                	cmp    $0x5a,%al
  102c99:	7f 32                	jg     102ccd <strtol+0x13d>
            dig = *s - 'A' + 10;
  102c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9e:	0f b6 00             	movzbl (%eax),%eax
  102ca1:	0f be c0             	movsbl %al,%eax
  102ca4:	83 e8 37             	sub    $0x37,%eax
  102ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cad:	3b 45 10             	cmp    0x10(%ebp),%eax
  102cb0:	7d 1a                	jge    102ccc <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102cb2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102cb9:	0f af 45 10          	imul   0x10(%ebp),%eax
  102cbd:	89 c2                	mov    %eax,%edx
  102cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cc2:	01 d0                	add    %edx,%eax
  102cc4:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102cc7:	e9 71 ff ff ff       	jmp    102c3d <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  102ccc:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  102ccd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102cd1:	74 08                	je     102cdb <strtol+0x14b>
        *endptr = (char *) s;
  102cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  102cd9:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102cdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102cdf:	74 07                	je     102ce8 <strtol+0x158>
  102ce1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ce4:	f7 d8                	neg    %eax
  102ce6:	eb 03                	jmp    102ceb <strtol+0x15b>
  102ce8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102ceb:	c9                   	leave  
  102cec:	c3                   	ret    

00102ced <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102ced:	55                   	push   %ebp
  102cee:	89 e5                	mov    %esp,%ebp
  102cf0:	57                   	push   %edi
  102cf1:	83 ec 24             	sub    $0x24,%esp
  102cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cf7:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102cfa:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  102d01:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102d04:	88 45 f7             	mov    %al,-0x9(%ebp)
  102d07:	8b 45 10             	mov    0x10(%ebp),%eax
  102d0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102d0d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102d10:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102d14:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102d17:	89 d7                	mov    %edx,%edi
  102d19:	f3 aa                	rep stos %al,%es:(%edi)
  102d1b:	89 fa                	mov    %edi,%edx
  102d1d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102d20:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102d23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d26:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102d27:	83 c4 24             	add    $0x24,%esp
  102d2a:	5f                   	pop    %edi
  102d2b:	5d                   	pop    %ebp
  102d2c:	c3                   	ret    

00102d2d <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102d2d:	55                   	push   %ebp
  102d2e:	89 e5                	mov    %esp,%ebp
  102d30:	57                   	push   %edi
  102d31:	56                   	push   %esi
  102d32:	53                   	push   %ebx
  102d33:	83 ec 30             	sub    $0x30,%esp
  102d36:	8b 45 08             	mov    0x8(%ebp),%eax
  102d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d42:	8b 45 10             	mov    0x10(%ebp),%eax
  102d45:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d4b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102d4e:	73 42                	jae    102d92 <memmove+0x65>
  102d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d59:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102d62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d65:	c1 e8 02             	shr    $0x2,%eax
  102d68:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102d6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d70:	89 d7                	mov    %edx,%edi
  102d72:	89 c6                	mov    %eax,%esi
  102d74:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102d76:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102d79:	83 e1 03             	and    $0x3,%ecx
  102d7c:	74 02                	je     102d80 <memmove+0x53>
  102d7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102d80:	89 f0                	mov    %esi,%eax
  102d82:	89 fa                	mov    %edi,%edx
  102d84:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102d87:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102d8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102d8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102d90:	eb 36                	jmp    102dc8 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102d92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d95:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d9b:	01 c2                	add    %eax,%edx
  102d9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102da0:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102da6:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102da9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dac:	89 c1                	mov    %eax,%ecx
  102dae:	89 d8                	mov    %ebx,%eax
  102db0:	89 d6                	mov    %edx,%esi
  102db2:	89 c7                	mov    %eax,%edi
  102db4:	fd                   	std    
  102db5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102db7:	fc                   	cld    
  102db8:	89 f8                	mov    %edi,%eax
  102dba:	89 f2                	mov    %esi,%edx
  102dbc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102dbf:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102dc2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102dc8:	83 c4 30             	add    $0x30,%esp
  102dcb:	5b                   	pop    %ebx
  102dcc:	5e                   	pop    %esi
  102dcd:	5f                   	pop    %edi
  102dce:	5d                   	pop    %ebp
  102dcf:	c3                   	ret    

00102dd0 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102dd0:	55                   	push   %ebp
  102dd1:	89 e5                	mov    %esp,%ebp
  102dd3:	57                   	push   %edi
  102dd4:	56                   	push   %esi
  102dd5:	83 ec 20             	sub    $0x20,%esp
  102dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  102de1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102de4:	8b 45 10             	mov    0x10(%ebp),%eax
  102de7:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ded:	c1 e8 02             	shr    $0x2,%eax
  102df0:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102df8:	89 d7                	mov    %edx,%edi
  102dfa:	89 c6                	mov    %eax,%esi
  102dfc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102dfe:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102e01:	83 e1 03             	and    $0x3,%ecx
  102e04:	74 02                	je     102e08 <memcpy+0x38>
  102e06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e08:	89 f0                	mov    %esi,%eax
  102e0a:	89 fa                	mov    %edi,%edx
  102e0c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102e0f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102e12:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102e18:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102e19:	83 c4 20             	add    $0x20,%esp
  102e1c:	5e                   	pop    %esi
  102e1d:	5f                   	pop    %edi
  102e1e:	5d                   	pop    %ebp
  102e1f:	c3                   	ret    

00102e20 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102e20:	55                   	push   %ebp
  102e21:	89 e5                	mov    %esp,%ebp
  102e23:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102e26:	8b 45 08             	mov    0x8(%ebp),%eax
  102e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102e32:	eb 30                	jmp    102e64 <memcmp+0x44>
        if (*s1 != *s2) {
  102e34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e37:	0f b6 10             	movzbl (%eax),%edx
  102e3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e3d:	0f b6 00             	movzbl (%eax),%eax
  102e40:	38 c2                	cmp    %al,%dl
  102e42:	74 18                	je     102e5c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e47:	0f b6 00             	movzbl (%eax),%eax
  102e4a:	0f b6 d0             	movzbl %al,%edx
  102e4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e50:	0f b6 00             	movzbl (%eax),%eax
  102e53:	0f b6 c0             	movzbl %al,%eax
  102e56:	29 c2                	sub    %eax,%edx
  102e58:	89 d0                	mov    %edx,%eax
  102e5a:	eb 1a                	jmp    102e76 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102e5c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102e60:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  102e64:	8b 45 10             	mov    0x10(%ebp),%eax
  102e67:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e6a:	89 55 10             	mov    %edx,0x10(%ebp)
  102e6d:	85 c0                	test   %eax,%eax
  102e6f:	75 c3                	jne    102e34 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  102e71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e76:	c9                   	leave  
  102e77:	c3                   	ret    

00102e78 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102e78:	55                   	push   %ebp
  102e79:	89 e5                	mov    %esp,%ebp
  102e7b:	83 ec 38             	sub    $0x38,%esp
  102e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  102e81:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102e84:	8b 45 14             	mov    0x14(%ebp),%eax
  102e87:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102e8a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102e8d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102e90:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e93:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102e96:	8b 45 18             	mov    0x18(%ebp),%eax
  102e99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ea2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ea5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102eb2:	74 1c                	je     102ed0 <printnum+0x58>
  102eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eb7:	ba 00 00 00 00       	mov    $0x0,%edx
  102ebc:	f7 75 e4             	divl   -0x1c(%ebp)
  102ebf:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec5:	ba 00 00 00 00       	mov    $0x0,%edx
  102eca:	f7 75 e4             	divl   -0x1c(%ebp)
  102ecd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ed3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ed6:	f7 75 e4             	divl   -0x1c(%ebp)
  102ed9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102edc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102edf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ee2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ee5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ee8:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102eeb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102eee:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102ef1:	8b 45 18             	mov    0x18(%ebp),%eax
  102ef4:	ba 00 00 00 00       	mov    $0x0,%edx
  102ef9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102efc:	77 41                	ja     102f3f <printnum+0xc7>
  102efe:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f01:	72 05                	jb     102f08 <printnum+0x90>
  102f03:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102f06:	77 37                	ja     102f3f <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102f08:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102f0b:	83 e8 01             	sub    $0x1,%eax
  102f0e:	83 ec 04             	sub    $0x4,%esp
  102f11:	ff 75 20             	pushl  0x20(%ebp)
  102f14:	50                   	push   %eax
  102f15:	ff 75 18             	pushl  0x18(%ebp)
  102f18:	ff 75 ec             	pushl  -0x14(%ebp)
  102f1b:	ff 75 e8             	pushl  -0x18(%ebp)
  102f1e:	ff 75 0c             	pushl  0xc(%ebp)
  102f21:	ff 75 08             	pushl  0x8(%ebp)
  102f24:	e8 4f ff ff ff       	call   102e78 <printnum>
  102f29:	83 c4 20             	add    $0x20,%esp
  102f2c:	eb 1b                	jmp    102f49 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102f2e:	83 ec 08             	sub    $0x8,%esp
  102f31:	ff 75 0c             	pushl  0xc(%ebp)
  102f34:	ff 75 20             	pushl  0x20(%ebp)
  102f37:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3a:	ff d0                	call   *%eax
  102f3c:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102f3f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102f43:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102f47:	7f e5                	jg     102f2e <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102f49:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102f4c:	05 50 3c 10 00       	add    $0x103c50,%eax
  102f51:	0f b6 00             	movzbl (%eax),%eax
  102f54:	0f be c0             	movsbl %al,%eax
  102f57:	83 ec 08             	sub    $0x8,%esp
  102f5a:	ff 75 0c             	pushl  0xc(%ebp)
  102f5d:	50                   	push   %eax
  102f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f61:	ff d0                	call   *%eax
  102f63:	83 c4 10             	add    $0x10,%esp
}
  102f66:	90                   	nop
  102f67:	c9                   	leave  
  102f68:	c3                   	ret    

00102f69 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102f69:	55                   	push   %ebp
  102f6a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102f6c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102f70:	7e 14                	jle    102f86 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102f72:	8b 45 08             	mov    0x8(%ebp),%eax
  102f75:	8b 00                	mov    (%eax),%eax
  102f77:	8d 48 08             	lea    0x8(%eax),%ecx
  102f7a:	8b 55 08             	mov    0x8(%ebp),%edx
  102f7d:	89 0a                	mov    %ecx,(%edx)
  102f7f:	8b 50 04             	mov    0x4(%eax),%edx
  102f82:	8b 00                	mov    (%eax),%eax
  102f84:	eb 30                	jmp    102fb6 <getuint+0x4d>
    }
    else if (lflag) {
  102f86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f8a:	74 16                	je     102fa2 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f8f:	8b 00                	mov    (%eax),%eax
  102f91:	8d 48 04             	lea    0x4(%eax),%ecx
  102f94:	8b 55 08             	mov    0x8(%ebp),%edx
  102f97:	89 0a                	mov    %ecx,(%edx)
  102f99:	8b 00                	mov    (%eax),%eax
  102f9b:	ba 00 00 00 00       	mov    $0x0,%edx
  102fa0:	eb 14                	jmp    102fb6 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa5:	8b 00                	mov    (%eax),%eax
  102fa7:	8d 48 04             	lea    0x4(%eax),%ecx
  102faa:	8b 55 08             	mov    0x8(%ebp),%edx
  102fad:	89 0a                	mov    %ecx,(%edx)
  102faf:	8b 00                	mov    (%eax),%eax
  102fb1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102fb6:	5d                   	pop    %ebp
  102fb7:	c3                   	ret    

00102fb8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102fb8:	55                   	push   %ebp
  102fb9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102fbb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102fbf:	7e 14                	jle    102fd5 <getint+0x1d>
        return va_arg(*ap, long long);
  102fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc4:	8b 00                	mov    (%eax),%eax
  102fc6:	8d 48 08             	lea    0x8(%eax),%ecx
  102fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  102fcc:	89 0a                	mov    %ecx,(%edx)
  102fce:	8b 50 04             	mov    0x4(%eax),%edx
  102fd1:	8b 00                	mov    (%eax),%eax
  102fd3:	eb 28                	jmp    102ffd <getint+0x45>
    }
    else if (lflag) {
  102fd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102fd9:	74 12                	je     102fed <getint+0x35>
        return va_arg(*ap, long);
  102fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  102fde:	8b 00                	mov    (%eax),%eax
  102fe0:	8d 48 04             	lea    0x4(%eax),%ecx
  102fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  102fe6:	89 0a                	mov    %ecx,(%edx)
  102fe8:	8b 00                	mov    (%eax),%eax
  102fea:	99                   	cltd   
  102feb:	eb 10                	jmp    102ffd <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102fed:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff0:	8b 00                	mov    (%eax),%eax
  102ff2:	8d 48 04             	lea    0x4(%eax),%ecx
  102ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  102ff8:	89 0a                	mov    %ecx,(%edx)
  102ffa:	8b 00                	mov    (%eax),%eax
  102ffc:	99                   	cltd   
    }
}
  102ffd:	5d                   	pop    %ebp
  102ffe:	c3                   	ret    

00102fff <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102fff:	55                   	push   %ebp
  103000:	89 e5                	mov    %esp,%ebp
  103002:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  103005:	8d 45 14             	lea    0x14(%ebp),%eax
  103008:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10300e:	50                   	push   %eax
  10300f:	ff 75 10             	pushl  0x10(%ebp)
  103012:	ff 75 0c             	pushl  0xc(%ebp)
  103015:	ff 75 08             	pushl  0x8(%ebp)
  103018:	e8 06 00 00 00       	call   103023 <vprintfmt>
  10301d:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  103020:	90                   	nop
  103021:	c9                   	leave  
  103022:	c3                   	ret    

00103023 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  103023:	55                   	push   %ebp
  103024:	89 e5                	mov    %esp,%ebp
  103026:	56                   	push   %esi
  103027:	53                   	push   %ebx
  103028:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10302b:	eb 17                	jmp    103044 <vprintfmt+0x21>
            if (ch == '\0') {
  10302d:	85 db                	test   %ebx,%ebx
  10302f:	0f 84 8e 03 00 00    	je     1033c3 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  103035:	83 ec 08             	sub    $0x8,%esp
  103038:	ff 75 0c             	pushl  0xc(%ebp)
  10303b:	53                   	push   %ebx
  10303c:	8b 45 08             	mov    0x8(%ebp),%eax
  10303f:	ff d0                	call   *%eax
  103041:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103044:	8b 45 10             	mov    0x10(%ebp),%eax
  103047:	8d 50 01             	lea    0x1(%eax),%edx
  10304a:	89 55 10             	mov    %edx,0x10(%ebp)
  10304d:	0f b6 00             	movzbl (%eax),%eax
  103050:	0f b6 d8             	movzbl %al,%ebx
  103053:	83 fb 25             	cmp    $0x25,%ebx
  103056:	75 d5                	jne    10302d <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  103058:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10305c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103063:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103066:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103069:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103070:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103073:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103076:	8b 45 10             	mov    0x10(%ebp),%eax
  103079:	8d 50 01             	lea    0x1(%eax),%edx
  10307c:	89 55 10             	mov    %edx,0x10(%ebp)
  10307f:	0f b6 00             	movzbl (%eax),%eax
  103082:	0f b6 d8             	movzbl %al,%ebx
  103085:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103088:	83 f8 55             	cmp    $0x55,%eax
  10308b:	0f 87 05 03 00 00    	ja     103396 <vprintfmt+0x373>
  103091:	8b 04 85 74 3c 10 00 	mov    0x103c74(,%eax,4),%eax
  103098:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10309a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10309e:	eb d6                	jmp    103076 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1030a0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1030a4:	eb d0                	jmp    103076 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1030a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1030ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1030b0:	89 d0                	mov    %edx,%eax
  1030b2:	c1 e0 02             	shl    $0x2,%eax
  1030b5:	01 d0                	add    %edx,%eax
  1030b7:	01 c0                	add    %eax,%eax
  1030b9:	01 d8                	add    %ebx,%eax
  1030bb:	83 e8 30             	sub    $0x30,%eax
  1030be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1030c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1030c4:	0f b6 00             	movzbl (%eax),%eax
  1030c7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1030ca:	83 fb 2f             	cmp    $0x2f,%ebx
  1030cd:	7e 39                	jle    103108 <vprintfmt+0xe5>
  1030cf:	83 fb 39             	cmp    $0x39,%ebx
  1030d2:	7f 34                	jg     103108 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1030d4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1030d8:	eb d3                	jmp    1030ad <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1030da:	8b 45 14             	mov    0x14(%ebp),%eax
  1030dd:	8d 50 04             	lea    0x4(%eax),%edx
  1030e0:	89 55 14             	mov    %edx,0x14(%ebp)
  1030e3:	8b 00                	mov    (%eax),%eax
  1030e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1030e8:	eb 1f                	jmp    103109 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  1030ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1030ee:	79 86                	jns    103076 <vprintfmt+0x53>
                width = 0;
  1030f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1030f7:	e9 7a ff ff ff       	jmp    103076 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1030fc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  103103:	e9 6e ff ff ff       	jmp    103076 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  103108:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  103109:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10310d:	0f 89 63 ff ff ff    	jns    103076 <vprintfmt+0x53>
                width = precision, precision = -1;
  103113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103116:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103119:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103120:	e9 51 ff ff ff       	jmp    103076 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  103125:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  103129:	e9 48 ff ff ff       	jmp    103076 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10312e:	8b 45 14             	mov    0x14(%ebp),%eax
  103131:	8d 50 04             	lea    0x4(%eax),%edx
  103134:	89 55 14             	mov    %edx,0x14(%ebp)
  103137:	8b 00                	mov    (%eax),%eax
  103139:	83 ec 08             	sub    $0x8,%esp
  10313c:	ff 75 0c             	pushl  0xc(%ebp)
  10313f:	50                   	push   %eax
  103140:	8b 45 08             	mov    0x8(%ebp),%eax
  103143:	ff d0                	call   *%eax
  103145:	83 c4 10             	add    $0x10,%esp
            break;
  103148:	e9 71 02 00 00       	jmp    1033be <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10314d:	8b 45 14             	mov    0x14(%ebp),%eax
  103150:	8d 50 04             	lea    0x4(%eax),%edx
  103153:	89 55 14             	mov    %edx,0x14(%ebp)
  103156:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103158:	85 db                	test   %ebx,%ebx
  10315a:	79 02                	jns    10315e <vprintfmt+0x13b>
                err = -err;
  10315c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10315e:	83 fb 06             	cmp    $0x6,%ebx
  103161:	7f 0b                	jg     10316e <vprintfmt+0x14b>
  103163:	8b 34 9d 34 3c 10 00 	mov    0x103c34(,%ebx,4),%esi
  10316a:	85 f6                	test   %esi,%esi
  10316c:	75 19                	jne    103187 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  10316e:	53                   	push   %ebx
  10316f:	68 61 3c 10 00       	push   $0x103c61
  103174:	ff 75 0c             	pushl  0xc(%ebp)
  103177:	ff 75 08             	pushl  0x8(%ebp)
  10317a:	e8 80 fe ff ff       	call   102fff <printfmt>
  10317f:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103182:	e9 37 02 00 00       	jmp    1033be <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  103187:	56                   	push   %esi
  103188:	68 6a 3c 10 00       	push   $0x103c6a
  10318d:	ff 75 0c             	pushl  0xc(%ebp)
  103190:	ff 75 08             	pushl  0x8(%ebp)
  103193:	e8 67 fe ff ff       	call   102fff <printfmt>
  103198:	83 c4 10             	add    $0x10,%esp
            }
            break;
  10319b:	e9 1e 02 00 00       	jmp    1033be <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1031a0:	8b 45 14             	mov    0x14(%ebp),%eax
  1031a3:	8d 50 04             	lea    0x4(%eax),%edx
  1031a6:	89 55 14             	mov    %edx,0x14(%ebp)
  1031a9:	8b 30                	mov    (%eax),%esi
  1031ab:	85 f6                	test   %esi,%esi
  1031ad:	75 05                	jne    1031b4 <vprintfmt+0x191>
                p = "(null)";
  1031af:	be 6d 3c 10 00       	mov    $0x103c6d,%esi
            }
            if (width > 0 && padc != '-') {
  1031b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031b8:	7e 76                	jle    103230 <vprintfmt+0x20d>
  1031ba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1031be:	74 70                	je     103230 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1031c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031c3:	83 ec 08             	sub    $0x8,%esp
  1031c6:	50                   	push   %eax
  1031c7:	56                   	push   %esi
  1031c8:	e8 17 f8 ff ff       	call   1029e4 <strnlen>
  1031cd:	83 c4 10             	add    $0x10,%esp
  1031d0:	89 c2                	mov    %eax,%edx
  1031d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031d5:	29 d0                	sub    %edx,%eax
  1031d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031da:	eb 17                	jmp    1031f3 <vprintfmt+0x1d0>
                    putch(padc, putdat);
  1031dc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1031e0:	83 ec 08             	sub    $0x8,%esp
  1031e3:	ff 75 0c             	pushl  0xc(%ebp)
  1031e6:	50                   	push   %eax
  1031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ea:	ff d0                	call   *%eax
  1031ec:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1031ef:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1031f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031f7:	7f e3                	jg     1031dc <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1031f9:	eb 35                	jmp    103230 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  1031fb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1031ff:	74 1c                	je     10321d <vprintfmt+0x1fa>
  103201:	83 fb 1f             	cmp    $0x1f,%ebx
  103204:	7e 05                	jle    10320b <vprintfmt+0x1e8>
  103206:	83 fb 7e             	cmp    $0x7e,%ebx
  103209:	7e 12                	jle    10321d <vprintfmt+0x1fa>
                    putch('?', putdat);
  10320b:	83 ec 08             	sub    $0x8,%esp
  10320e:	ff 75 0c             	pushl  0xc(%ebp)
  103211:	6a 3f                	push   $0x3f
  103213:	8b 45 08             	mov    0x8(%ebp),%eax
  103216:	ff d0                	call   *%eax
  103218:	83 c4 10             	add    $0x10,%esp
  10321b:	eb 0f                	jmp    10322c <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  10321d:	83 ec 08             	sub    $0x8,%esp
  103220:	ff 75 0c             	pushl  0xc(%ebp)
  103223:	53                   	push   %ebx
  103224:	8b 45 08             	mov    0x8(%ebp),%eax
  103227:	ff d0                	call   *%eax
  103229:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10322c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103230:	89 f0                	mov    %esi,%eax
  103232:	8d 70 01             	lea    0x1(%eax),%esi
  103235:	0f b6 00             	movzbl (%eax),%eax
  103238:	0f be d8             	movsbl %al,%ebx
  10323b:	85 db                	test   %ebx,%ebx
  10323d:	74 26                	je     103265 <vprintfmt+0x242>
  10323f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103243:	78 b6                	js     1031fb <vprintfmt+0x1d8>
  103245:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103249:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10324d:	79 ac                	jns    1031fb <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10324f:	eb 14                	jmp    103265 <vprintfmt+0x242>
                putch(' ', putdat);
  103251:	83 ec 08             	sub    $0x8,%esp
  103254:	ff 75 0c             	pushl  0xc(%ebp)
  103257:	6a 20                	push   $0x20
  103259:	8b 45 08             	mov    0x8(%ebp),%eax
  10325c:	ff d0                	call   *%eax
  10325e:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103261:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103265:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103269:	7f e6                	jg     103251 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  10326b:	e9 4e 01 00 00       	jmp    1033be <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103270:	83 ec 08             	sub    $0x8,%esp
  103273:	ff 75 e0             	pushl  -0x20(%ebp)
  103276:	8d 45 14             	lea    0x14(%ebp),%eax
  103279:	50                   	push   %eax
  10327a:	e8 39 fd ff ff       	call   102fb8 <getint>
  10327f:	83 c4 10             	add    $0x10,%esp
  103282:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103285:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10328b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10328e:	85 d2                	test   %edx,%edx
  103290:	79 23                	jns    1032b5 <vprintfmt+0x292>
                putch('-', putdat);
  103292:	83 ec 08             	sub    $0x8,%esp
  103295:	ff 75 0c             	pushl  0xc(%ebp)
  103298:	6a 2d                	push   $0x2d
  10329a:	8b 45 08             	mov    0x8(%ebp),%eax
  10329d:	ff d0                	call   *%eax
  10329f:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  1032a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032a8:	f7 d8                	neg    %eax
  1032aa:	83 d2 00             	adc    $0x0,%edx
  1032ad:	f7 da                	neg    %edx
  1032af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1032b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1032bc:	e9 9f 00 00 00       	jmp    103360 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1032c1:	83 ec 08             	sub    $0x8,%esp
  1032c4:	ff 75 e0             	pushl  -0x20(%ebp)
  1032c7:	8d 45 14             	lea    0x14(%ebp),%eax
  1032ca:	50                   	push   %eax
  1032cb:	e8 99 fc ff ff       	call   102f69 <getuint>
  1032d0:	83 c4 10             	add    $0x10,%esp
  1032d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1032d9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1032e0:	eb 7e                	jmp    103360 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1032e2:	83 ec 08             	sub    $0x8,%esp
  1032e5:	ff 75 e0             	pushl  -0x20(%ebp)
  1032e8:	8d 45 14             	lea    0x14(%ebp),%eax
  1032eb:	50                   	push   %eax
  1032ec:	e8 78 fc ff ff       	call   102f69 <getuint>
  1032f1:	83 c4 10             	add    $0x10,%esp
  1032f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1032fa:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103301:	eb 5d                	jmp    103360 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  103303:	83 ec 08             	sub    $0x8,%esp
  103306:	ff 75 0c             	pushl  0xc(%ebp)
  103309:	6a 30                	push   $0x30
  10330b:	8b 45 08             	mov    0x8(%ebp),%eax
  10330e:	ff d0                	call   *%eax
  103310:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  103313:	83 ec 08             	sub    $0x8,%esp
  103316:	ff 75 0c             	pushl  0xc(%ebp)
  103319:	6a 78                	push   $0x78
  10331b:	8b 45 08             	mov    0x8(%ebp),%eax
  10331e:	ff d0                	call   *%eax
  103320:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103323:	8b 45 14             	mov    0x14(%ebp),%eax
  103326:	8d 50 04             	lea    0x4(%eax),%edx
  103329:	89 55 14             	mov    %edx,0x14(%ebp)
  10332c:	8b 00                	mov    (%eax),%eax
  10332e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103331:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103338:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10333f:	eb 1f                	jmp    103360 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103341:	83 ec 08             	sub    $0x8,%esp
  103344:	ff 75 e0             	pushl  -0x20(%ebp)
  103347:	8d 45 14             	lea    0x14(%ebp),%eax
  10334a:	50                   	push   %eax
  10334b:	e8 19 fc ff ff       	call   102f69 <getuint>
  103350:	83 c4 10             	add    $0x10,%esp
  103353:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103356:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103359:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103360:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103367:	83 ec 04             	sub    $0x4,%esp
  10336a:	52                   	push   %edx
  10336b:	ff 75 e8             	pushl  -0x18(%ebp)
  10336e:	50                   	push   %eax
  10336f:	ff 75 f4             	pushl  -0xc(%ebp)
  103372:	ff 75 f0             	pushl  -0x10(%ebp)
  103375:	ff 75 0c             	pushl  0xc(%ebp)
  103378:	ff 75 08             	pushl  0x8(%ebp)
  10337b:	e8 f8 fa ff ff       	call   102e78 <printnum>
  103380:	83 c4 20             	add    $0x20,%esp
            break;
  103383:	eb 39                	jmp    1033be <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103385:	83 ec 08             	sub    $0x8,%esp
  103388:	ff 75 0c             	pushl  0xc(%ebp)
  10338b:	53                   	push   %ebx
  10338c:	8b 45 08             	mov    0x8(%ebp),%eax
  10338f:	ff d0                	call   *%eax
  103391:	83 c4 10             	add    $0x10,%esp
            break;
  103394:	eb 28                	jmp    1033be <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103396:	83 ec 08             	sub    $0x8,%esp
  103399:	ff 75 0c             	pushl  0xc(%ebp)
  10339c:	6a 25                	push   $0x25
  10339e:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a1:	ff d0                	call   *%eax
  1033a3:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  1033a6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1033aa:	eb 04                	jmp    1033b0 <vprintfmt+0x38d>
  1033ac:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1033b0:	8b 45 10             	mov    0x10(%ebp),%eax
  1033b3:	83 e8 01             	sub    $0x1,%eax
  1033b6:	0f b6 00             	movzbl (%eax),%eax
  1033b9:	3c 25                	cmp    $0x25,%al
  1033bb:	75 ef                	jne    1033ac <vprintfmt+0x389>
                /* do nothing */;
            break;
  1033bd:	90                   	nop
        }
    }
  1033be:	e9 68 fc ff ff       	jmp    10302b <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  1033c3:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1033c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1033c7:	5b                   	pop    %ebx
  1033c8:	5e                   	pop    %esi
  1033c9:	5d                   	pop    %ebp
  1033ca:	c3                   	ret    

001033cb <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1033cb:	55                   	push   %ebp
  1033cc:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1033ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033d1:	8b 40 08             	mov    0x8(%eax),%eax
  1033d4:	8d 50 01             	lea    0x1(%eax),%edx
  1033d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033da:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1033dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033e0:	8b 10                	mov    (%eax),%edx
  1033e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033e5:	8b 40 04             	mov    0x4(%eax),%eax
  1033e8:	39 c2                	cmp    %eax,%edx
  1033ea:	73 12                	jae    1033fe <sprintputch+0x33>
        *b->buf ++ = ch;
  1033ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033ef:	8b 00                	mov    (%eax),%eax
  1033f1:	8d 48 01             	lea    0x1(%eax),%ecx
  1033f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1033f7:	89 0a                	mov    %ecx,(%edx)
  1033f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1033fc:	88 10                	mov    %dl,(%eax)
    }
}
  1033fe:	90                   	nop
  1033ff:	5d                   	pop    %ebp
  103400:	c3                   	ret    

00103401 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103401:	55                   	push   %ebp
  103402:	89 e5                	mov    %esp,%ebp
  103404:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103407:	8d 45 14             	lea    0x14(%ebp),%eax
  10340a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10340d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103410:	50                   	push   %eax
  103411:	ff 75 10             	pushl  0x10(%ebp)
  103414:	ff 75 0c             	pushl  0xc(%ebp)
  103417:	ff 75 08             	pushl  0x8(%ebp)
  10341a:	e8 0b 00 00 00       	call   10342a <vsnprintf>
  10341f:	83 c4 10             	add    $0x10,%esp
  103422:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103425:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103428:	c9                   	leave  
  103429:	c3                   	ret    

0010342a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10342a:	55                   	push   %ebp
  10342b:	89 e5                	mov    %esp,%ebp
  10342d:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103430:	8b 45 08             	mov    0x8(%ebp),%eax
  103433:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103436:	8b 45 0c             	mov    0xc(%ebp),%eax
  103439:	8d 50 ff             	lea    -0x1(%eax),%edx
  10343c:	8b 45 08             	mov    0x8(%ebp),%eax
  10343f:	01 d0                	add    %edx,%eax
  103441:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103444:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10344b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10344f:	74 0a                	je     10345b <vsnprintf+0x31>
  103451:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103457:	39 c2                	cmp    %eax,%edx
  103459:	76 07                	jbe    103462 <vsnprintf+0x38>
        return -E_INVAL;
  10345b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103460:	eb 20                	jmp    103482 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103462:	ff 75 14             	pushl  0x14(%ebp)
  103465:	ff 75 10             	pushl  0x10(%ebp)
  103468:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10346b:	50                   	push   %eax
  10346c:	68 cb 33 10 00       	push   $0x1033cb
  103471:	e8 ad fb ff ff       	call   103023 <vprintfmt>
  103476:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10347c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103482:	c9                   	leave  
  103483:	c3                   	ret    

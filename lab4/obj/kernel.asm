
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 60 12 00       	mov    $0x126000,%eax
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
c0100020:	a3 00 60 12 c0       	mov    %eax,0xc0126000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 50 12 c0       	mov    $0xc0125000,%esp
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
c010003c:	ba 4c b1 12 c0       	mov    $0xc012b14c,%edx
c0100041:	b8 00 80 12 c0       	mov    $0xc0128000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 80 12 c0 	movl   $0xc0128000,(%esp)
c010005d:	e8 37 97 00 00       	call   c0109799 <memset>

    cons_init();                // init the console
c0100062:	e8 1e 1e 00 00       	call   c0101e85 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 a0 a0 10 c0 	movl   $0xc010a0a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 bc a0 10 c0 	movl   $0xc010a0bc,(%esp)
c010007c:	e8 28 02 00 00       	call   c01002a9 <cprintf>

    print_kerninfo();
c0100081:	e8 c9 08 00 00       	call   c010094f <print_kerninfo>

    grade_backtrace();
c0100086:	e8 a0 00 00 00       	call   c010012b <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 06 74 00 00       	call   c0107496 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 54 1f 00 00       	call   c0101fe9 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 ad 20 00 00       	call   c0102147 <idt_init>

    vmm_init();                 // init virtual memory management
c010009a:	e8 ce 35 00 00       	call   c010366d <vmm_init>
    proc_init();                // init process table
c010009f:	e8 af 90 00 00       	call   c0109153 <proc_init>
    
    ide_init();                 // init ide devices
c01000a4:	e8 80 0d 00 00       	call   c0100e29 <ide_init>
    swap_init();                // init swap
c01000a9:	e8 5e 3f 00 00       	call   c010400c <swap_init>

    clock_init();               // init clock interrupt
c01000ae:	e8 85 15 00 00       	call   c0101638 <clock_init>
    intr_enable();              // enable irq interrupt
c01000b3:	e8 64 20 00 00       	call   c010211c <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000b8:	e8 53 92 00 00       	call   c0109310 <cpu_idle>

c01000bd <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000bd:	55                   	push   %ebp
c01000be:	89 e5                	mov    %esp,%ebp
c01000c0:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000ca:	00 
c01000cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000d2:	00 
c01000d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000da:	e8 df 0c 00 00       	call   c0100dbe <mon_backtrace>
}
c01000df:	90                   	nop
c01000e0:	c9                   	leave  
c01000e1:	c3                   	ret    

c01000e2 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000e2:	55                   	push   %ebp
c01000e3:	89 e5                	mov    %esp,%ebp
c01000e5:	53                   	push   %ebx
c01000e6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000ec:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000ef:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01000f5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000f9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0100101:	89 04 24             	mov    %eax,(%esp)
c0100104:	e8 b4 ff ff ff       	call   c01000bd <grade_backtrace2>
}
c0100109:	90                   	nop
c010010a:	83 c4 14             	add    $0x14,%esp
c010010d:	5b                   	pop    %ebx
c010010e:	5d                   	pop    %ebp
c010010f:	c3                   	ret    

c0100110 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100110:	55                   	push   %ebp
c0100111:	89 e5                	mov    %esp,%ebp
c0100113:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100116:	8b 45 10             	mov    0x10(%ebp),%eax
c0100119:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100120:	89 04 24             	mov    %eax,(%esp)
c0100123:	e8 ba ff ff ff       	call   c01000e2 <grade_backtrace1>
}
c0100128:	90                   	nop
c0100129:	c9                   	leave  
c010012a:	c3                   	ret    

c010012b <grade_backtrace>:

void
grade_backtrace(void) {
c010012b:	55                   	push   %ebp
c010012c:	89 e5                	mov    %esp,%ebp
c010012e:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100131:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100136:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010013d:	ff 
c010013e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100142:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100149:	e8 c2 ff ff ff       	call   c0100110 <grade_backtrace0>
}
c010014e:	90                   	nop
c010014f:	c9                   	leave  
c0100150:	c3                   	ret    

c0100151 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100151:	55                   	push   %ebp
c0100152:	89 e5                	mov    %esp,%ebp
c0100154:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100157:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010015a:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010015d:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100160:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100163:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100167:	83 e0 03             	and    $0x3,%eax
c010016a:	89 c2                	mov    %eax,%edx
c010016c:	a1 00 80 12 c0       	mov    0xc0128000,%eax
c0100171:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100175:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100179:	c7 04 24 c1 a0 10 c0 	movl   $0xc010a0c1,(%esp)
c0100180:	e8 24 01 00 00       	call   c01002a9 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100185:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100189:	89 c2                	mov    %eax,%edx
c010018b:	a1 00 80 12 c0       	mov    0xc0128000,%eax
c0100190:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100194:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100198:	c7 04 24 cf a0 10 c0 	movl   $0xc010a0cf,(%esp)
c010019f:	e8 05 01 00 00       	call   c01002a9 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c01001a4:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a8:	89 c2                	mov    %eax,%edx
c01001aa:	a1 00 80 12 c0       	mov    0xc0128000,%eax
c01001af:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b7:	c7 04 24 dd a0 10 c0 	movl   $0xc010a0dd,(%esp)
c01001be:	e8 e6 00 00 00       	call   c01002a9 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001c3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c7:	89 c2                	mov    %eax,%edx
c01001c9:	a1 00 80 12 c0       	mov    0xc0128000,%eax
c01001ce:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d6:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c01001dd:	e8 c7 00 00 00       	call   c01002a9 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001e2:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e6:	89 c2                	mov    %eax,%edx
c01001e8:	a1 00 80 12 c0       	mov    0xc0128000,%eax
c01001ed:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f5:	c7 04 24 f9 a0 10 c0 	movl   $0xc010a0f9,(%esp)
c01001fc:	e8 a8 00 00 00       	call   c01002a9 <cprintf>
    round ++;
c0100201:	a1 00 80 12 c0       	mov    0xc0128000,%eax
c0100206:	40                   	inc    %eax
c0100207:	a3 00 80 12 c0       	mov    %eax,0xc0128000
}
c010020c:	90                   	nop
c010020d:	c9                   	leave  
c010020e:	c3                   	ret    

c010020f <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020f:	55                   	push   %ebp
c0100210:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100212:	90                   	nop
c0100213:	5d                   	pop    %ebp
c0100214:	c3                   	ret    

c0100215 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100215:	55                   	push   %ebp
c0100216:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100218:	90                   	nop
c0100219:	5d                   	pop    %ebp
c010021a:	c3                   	ret    

c010021b <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010021b:	55                   	push   %ebp
c010021c:	89 e5                	mov    %esp,%ebp
c010021e:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100221:	e8 2b ff ff ff       	call   c0100151 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100226:	c7 04 24 08 a1 10 c0 	movl   $0xc010a108,(%esp)
c010022d:	e8 77 00 00 00       	call   c01002a9 <cprintf>
    lab1_switch_to_user();
c0100232:	e8 d8 ff ff ff       	call   c010020f <lab1_switch_to_user>
    lab1_print_cur_status();
c0100237:	e8 15 ff ff ff       	call   c0100151 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010023c:	c7 04 24 28 a1 10 c0 	movl   $0xc010a128,(%esp)
c0100243:	e8 61 00 00 00       	call   c01002a9 <cprintf>
    lab1_switch_to_kernel();
c0100248:	e8 c8 ff ff ff       	call   c0100215 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010024d:	e8 ff fe ff ff       	call   c0100151 <lab1_print_cur_status>
}
c0100252:	90                   	nop
c0100253:	c9                   	leave  
c0100254:	c3                   	ret    

c0100255 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100255:	55                   	push   %ebp
c0100256:	89 e5                	mov    %esp,%ebp
c0100258:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010025b:	8b 45 08             	mov    0x8(%ebp),%eax
c010025e:	89 04 24             	mov    %eax,(%esp)
c0100261:	e8 4c 1c 00 00       	call   c0101eb2 <cons_putc>
    (*cnt) ++;
c0100266:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100269:	8b 00                	mov    (%eax),%eax
c010026b:	8d 50 01             	lea    0x1(%eax),%edx
c010026e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100271:	89 10                	mov    %edx,(%eax)
}
c0100273:	90                   	nop
c0100274:	c9                   	leave  
c0100275:	c3                   	ret    

c0100276 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100276:	55                   	push   %ebp
c0100277:	89 e5                	mov    %esp,%ebp
c0100279:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010027c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100283:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100286:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010028a:	8b 45 08             	mov    0x8(%ebp),%eax
c010028d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100291:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100294:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100298:	c7 04 24 55 02 10 c0 	movl   $0xc0100255,(%esp)
c010029f:	e8 48 98 00 00       	call   c0109aec <vprintfmt>
    return cnt;
c01002a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002a7:	c9                   	leave  
c01002a8:	c3                   	ret    

c01002a9 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002a9:	55                   	push   %ebp
c01002aa:	89 e5                	mov    %esp,%ebp
c01002ac:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002af:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01002bf:	89 04 24             	mov    %eax,(%esp)
c01002c2:	e8 af ff ff ff       	call   c0100276 <vcprintf>
c01002c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002cd:	c9                   	leave  
c01002ce:	c3                   	ret    

c01002cf <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002cf:	55                   	push   %ebp
c01002d0:	89 e5                	mov    %esp,%ebp
c01002d2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01002d8:	89 04 24             	mov    %eax,(%esp)
c01002db:	e8 d2 1b 00 00       	call   c0101eb2 <cons_putc>
}
c01002e0:	90                   	nop
c01002e1:	c9                   	leave  
c01002e2:	c3                   	ret    

c01002e3 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002e3:	55                   	push   %ebp
c01002e4:	89 e5                	mov    %esp,%ebp
c01002e6:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002f0:	eb 13                	jmp    c0100305 <cputs+0x22>
        cputch(c, &cnt);
c01002f2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002f6:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002f9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002fd:	89 04 24             	mov    %eax,(%esp)
c0100300:	e8 50 ff ff ff       	call   c0100255 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100305:	8b 45 08             	mov    0x8(%ebp),%eax
c0100308:	8d 50 01             	lea    0x1(%eax),%edx
c010030b:	89 55 08             	mov    %edx,0x8(%ebp)
c010030e:	0f b6 00             	movzbl (%eax),%eax
c0100311:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100314:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100318:	75 d8                	jne    c01002f2 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c010031a:	8d 45 f0             	lea    -0x10(%ebp),%eax
c010031d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100321:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100328:	e8 28 ff ff ff       	call   c0100255 <cputch>
    return cnt;
c010032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100330:	c9                   	leave  
c0100331:	c3                   	ret    

c0100332 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100332:	55                   	push   %ebp
c0100333:	89 e5                	mov    %esp,%ebp
c0100335:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100338:	e8 b2 1b 00 00       	call   c0101eef <cons_getc>
c010033d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100344:	74 f2                	je     c0100338 <getchar+0x6>
        /* do nothing */;
    return c;
c0100346:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100349:	c9                   	leave  
c010034a:	c3                   	ret    

c010034b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010034b:	55                   	push   %ebp
c010034c:	89 e5                	mov    %esp,%ebp
c010034e:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100355:	74 13                	je     c010036a <readline+0x1f>
        cprintf("%s", prompt);
c0100357:	8b 45 08             	mov    0x8(%ebp),%eax
c010035a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035e:	c7 04 24 47 a1 10 c0 	movl   $0xc010a147,(%esp)
c0100365:	e8 3f ff ff ff       	call   c01002a9 <cprintf>
    }
    int i = 0, c;
c010036a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100371:	e8 bc ff ff ff       	call   c0100332 <getchar>
c0100376:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100379:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010037d:	79 07                	jns    c0100386 <readline+0x3b>
            return NULL;
c010037f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100384:	eb 78                	jmp    c01003fe <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100386:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010038a:	7e 28                	jle    c01003b4 <readline+0x69>
c010038c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100393:	7f 1f                	jg     c01003b4 <readline+0x69>
            cputchar(c);
c0100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100398:	89 04 24             	mov    %eax,(%esp)
c010039b:	e8 2f ff ff ff       	call   c01002cf <cputchar>
            buf[i ++] = c;
c01003a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003a3:	8d 50 01             	lea    0x1(%eax),%edx
c01003a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003ac:	88 90 20 80 12 c0    	mov    %dl,-0x3fed7fe0(%eax)
c01003b2:	eb 45                	jmp    c01003f9 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01003b4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003b8:	75 16                	jne    c01003d0 <readline+0x85>
c01003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003be:	7e 10                	jle    c01003d0 <readline+0x85>
            cputchar(c);
c01003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c3:	89 04 24             	mov    %eax,(%esp)
c01003c6:	e8 04 ff ff ff       	call   c01002cf <cputchar>
            i --;
c01003cb:	ff 4d f4             	decl   -0xc(%ebp)
c01003ce:	eb 29                	jmp    c01003f9 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01003d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003d4:	74 06                	je     c01003dc <readline+0x91>
c01003d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003da:	75 95                	jne    c0100371 <readline+0x26>
            cputchar(c);
c01003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003df:	89 04 24             	mov    %eax,(%esp)
c01003e2:	e8 e8 fe ff ff       	call   c01002cf <cputchar>
            buf[i] = '\0';
c01003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003ea:	05 20 80 12 c0       	add    $0xc0128020,%eax
c01003ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003f2:	b8 20 80 12 c0       	mov    $0xc0128020,%eax
c01003f7:	eb 05                	jmp    c01003fe <readline+0xb3>
        }
    }
c01003f9:	e9 73 ff ff ff       	jmp    c0100371 <readline+0x26>
}
c01003fe:	c9                   	leave  
c01003ff:	c3                   	ret    

c0100400 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100400:	55                   	push   %ebp
c0100401:	89 e5                	mov    %esp,%ebp
c0100403:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100406:	a1 20 84 12 c0       	mov    0xc0128420,%eax
c010040b:	85 c0                	test   %eax,%eax
c010040d:	75 5b                	jne    c010046a <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c010040f:	c7 05 20 84 12 c0 01 	movl   $0x1,0xc0128420
c0100416:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100419:	8d 45 14             	lea    0x14(%ebp),%eax
c010041c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c010041f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100422:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100426:	8b 45 08             	mov    0x8(%ebp),%eax
c0100429:	89 44 24 04          	mov    %eax,0x4(%esp)
c010042d:	c7 04 24 4a a1 10 c0 	movl   $0xc010a14a,(%esp)
c0100434:	e8 70 fe ff ff       	call   c01002a9 <cprintf>
    vcprintf(fmt, ap);
c0100439:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010043c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100440:	8b 45 10             	mov    0x10(%ebp),%eax
c0100443:	89 04 24             	mov    %eax,(%esp)
c0100446:	e8 2b fe ff ff       	call   c0100276 <vcprintf>
    cprintf("\n");
c010044b:	c7 04 24 66 a1 10 c0 	movl   $0xc010a166,(%esp)
c0100452:	e8 52 fe ff ff       	call   c01002a9 <cprintf>
    
    cprintf("stack trackback:\n");
c0100457:	c7 04 24 68 a1 10 c0 	movl   $0xc010a168,(%esp)
c010045e:	e8 46 fe ff ff       	call   c01002a9 <cprintf>
    print_stackframe();
c0100463:	e8 32 06 00 00       	call   c0100a9a <print_stackframe>
c0100468:	eb 01                	jmp    c010046b <__panic+0x6b>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c010046a:	90                   	nop
    print_stackframe();
    
    va_end(ap);

panic_dead:
    intr_disable();
c010046b:	e8 b3 1c 00 00       	call   c0102123 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100470:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100477:	e8 75 08 00 00       	call   c0100cf1 <kmonitor>
    }
c010047c:	eb f2                	jmp    c0100470 <__panic+0x70>

c010047e <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010047e:	55                   	push   %ebp
c010047f:	89 e5                	mov    %esp,%ebp
c0100481:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100484:	8d 45 14             	lea    0x14(%ebp),%eax
c0100487:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010048a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100491:	8b 45 08             	mov    0x8(%ebp),%eax
c0100494:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100498:	c7 04 24 7a a1 10 c0 	movl   $0xc010a17a,(%esp)
c010049f:	e8 05 fe ff ff       	call   c01002a9 <cprintf>
    vcprintf(fmt, ap);
c01004a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004a7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004ab:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ae:	89 04 24             	mov    %eax,(%esp)
c01004b1:	e8 c0 fd ff ff       	call   c0100276 <vcprintf>
    cprintf("\n");
c01004b6:	c7 04 24 66 a1 10 c0 	movl   $0xc010a166,(%esp)
c01004bd:	e8 e7 fd ff ff       	call   c01002a9 <cprintf>
    va_end(ap);
}
c01004c2:	90                   	nop
c01004c3:	c9                   	leave  
c01004c4:	c3                   	ret    

c01004c5 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004c5:	55                   	push   %ebp
c01004c6:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004c8:	a1 20 84 12 c0       	mov    0xc0128420,%eax
}
c01004cd:	5d                   	pop    %ebp
c01004ce:	c3                   	ret    

c01004cf <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004cf:	55                   	push   %ebp
c01004d0:	89 e5                	mov    %esp,%ebp
c01004d2:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d8:	8b 00                	mov    (%eax),%eax
c01004da:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01004e0:	8b 00                	mov    (%eax),%eax
c01004e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004ec:	e9 ca 00 00 00       	jmp    c01005bb <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c01004f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004f7:	01 d0                	add    %edx,%eax
c01004f9:	89 c2                	mov    %eax,%edx
c01004fb:	c1 ea 1f             	shr    $0x1f,%edx
c01004fe:	01 d0                	add    %edx,%eax
c0100500:	d1 f8                	sar    %eax
c0100502:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100505:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100508:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010050b:	eb 03                	jmp    c0100510 <stab_binsearch+0x41>
            m --;
c010050d:	ff 4d f0             	decl   -0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100510:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100513:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100516:	7c 1f                	jl     c0100537 <stab_binsearch+0x68>
c0100518:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010051b:	89 d0                	mov    %edx,%eax
c010051d:	01 c0                	add    %eax,%eax
c010051f:	01 d0                	add    %edx,%eax
c0100521:	c1 e0 02             	shl    $0x2,%eax
c0100524:	89 c2                	mov    %eax,%edx
c0100526:	8b 45 08             	mov    0x8(%ebp),%eax
c0100529:	01 d0                	add    %edx,%eax
c010052b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010052f:	0f b6 c0             	movzbl %al,%eax
c0100532:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100535:	75 d6                	jne    c010050d <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100537:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010053a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010053d:	7d 09                	jge    c0100548 <stab_binsearch+0x79>
            l = true_m + 1;
c010053f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100542:	40                   	inc    %eax
c0100543:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100546:	eb 73                	jmp    c01005bb <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c0100548:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010054f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100552:	89 d0                	mov    %edx,%eax
c0100554:	01 c0                	add    %eax,%eax
c0100556:	01 d0                	add    %edx,%eax
c0100558:	c1 e0 02             	shl    $0x2,%eax
c010055b:	89 c2                	mov    %eax,%edx
c010055d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100560:	01 d0                	add    %edx,%eax
c0100562:	8b 40 08             	mov    0x8(%eax),%eax
c0100565:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100568:	73 11                	jae    c010057b <stab_binsearch+0xac>
            *region_left = m;
c010056a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100570:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100572:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100575:	40                   	inc    %eax
c0100576:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100579:	eb 40                	jmp    c01005bb <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c010057b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010057e:	89 d0                	mov    %edx,%eax
c0100580:	01 c0                	add    %eax,%eax
c0100582:	01 d0                	add    %edx,%eax
c0100584:	c1 e0 02             	shl    $0x2,%eax
c0100587:	89 c2                	mov    %eax,%edx
c0100589:	8b 45 08             	mov    0x8(%ebp),%eax
c010058c:	01 d0                	add    %edx,%eax
c010058e:	8b 40 08             	mov    0x8(%eax),%eax
c0100591:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100594:	76 14                	jbe    c01005aa <stab_binsearch+0xdb>
            *region_right = m - 1;
c0100596:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100599:	8d 50 ff             	lea    -0x1(%eax),%edx
c010059c:	8b 45 10             	mov    0x10(%ebp),%eax
c010059f:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005a4:	48                   	dec    %eax
c01005a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005a8:	eb 11                	jmp    c01005bb <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b0:	89 10                	mov    %edx,(%eax)
            l = m;
c01005b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005b8:	ff 45 18             	incl   0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01005bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005c1:	0f 8e 2a ff ff ff    	jle    c01004f1 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01005c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005cb:	75 0f                	jne    c01005dc <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005d0:	8b 00                	mov    (%eax),%eax
c01005d2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d8:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005da:	eb 3e                	jmp    c010061a <stab_binsearch+0x14b>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005dc:	8b 45 10             	mov    0x10(%ebp),%eax
c01005df:	8b 00                	mov    (%eax),%eax
c01005e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005e4:	eb 03                	jmp    c01005e9 <stab_binsearch+0x11a>
c01005e6:	ff 4d fc             	decl   -0x4(%ebp)
c01005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ec:	8b 00                	mov    (%eax),%eax
c01005ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005f1:	7d 1f                	jge    c0100612 <stab_binsearch+0x143>
c01005f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005f6:	89 d0                	mov    %edx,%eax
c01005f8:	01 c0                	add    %eax,%eax
c01005fa:	01 d0                	add    %edx,%eax
c01005fc:	c1 e0 02             	shl    $0x2,%eax
c01005ff:	89 c2                	mov    %eax,%edx
c0100601:	8b 45 08             	mov    0x8(%ebp),%eax
c0100604:	01 d0                	add    %edx,%eax
c0100606:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010060a:	0f b6 c0             	movzbl %al,%eax
c010060d:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100610:	75 d4                	jne    c01005e6 <stab_binsearch+0x117>
            /* do nothing */;
        *region_left = l;
c0100612:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100615:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100618:	89 10                	mov    %edx,(%eax)
    }
}
c010061a:	90                   	nop
c010061b:	c9                   	leave  
c010061c:	c3                   	ret    

c010061d <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010061d:	55                   	push   %ebp
c010061e:	89 e5                	mov    %esp,%ebp
c0100620:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100623:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100626:	c7 00 98 a1 10 c0    	movl   $0xc010a198,(%eax)
    info->eip_line = 0;
c010062c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100636:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100639:	c7 40 08 98 a1 10 c0 	movl   $0xc010a198,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100640:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100643:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010064a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010064d:	8b 55 08             	mov    0x8(%ebp),%edx
c0100650:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100653:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100656:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010065d:	c7 45 f4 a4 c3 10 c0 	movl   $0xc010c3a4,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100664:	c7 45 f0 20 dd 11 c0 	movl   $0xc011dd20,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010066b:	c7 45 ec 21 dd 11 c0 	movl   $0xc011dd21,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100672:	c7 45 e8 c5 25 12 c0 	movl   $0xc01225c5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100679:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010067c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010067f:	76 0b                	jbe    c010068c <debuginfo_eip+0x6f>
c0100681:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100684:	48                   	dec    %eax
c0100685:	0f b6 00             	movzbl (%eax),%eax
c0100688:	84 c0                	test   %al,%al
c010068a:	74 0a                	je     c0100696 <debuginfo_eip+0x79>
        return -1;
c010068c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100691:	e9 b7 02 00 00       	jmp    c010094d <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100696:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010069d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006a3:	29 c2                	sub    %eax,%edx
c01006a5:	89 d0                	mov    %edx,%eax
c01006a7:	c1 f8 02             	sar    $0x2,%eax
c01006aa:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006b0:	48                   	dec    %eax
c01006b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01006b7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006bb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006c2:	00 
c01006c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006c6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006d4:	89 04 24             	mov    %eax,(%esp)
c01006d7:	e8 f3 fd ff ff       	call   c01004cf <stab_binsearch>
    if (lfile == 0)
c01006dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006df:	85 c0                	test   %eax,%eax
c01006e1:	75 0a                	jne    c01006ed <debuginfo_eip+0xd0>
        return -1;
c01006e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006e8:	e9 60 02 00 00       	jmp    c010094d <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01006fc:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100700:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100707:	00 
c0100708:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010070b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010070f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100712:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100719:	89 04 24             	mov    %eax,(%esp)
c010071c:	e8 ae fd ff ff       	call   c01004cf <stab_binsearch>

    if (lfun <= rfun) {
c0100721:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100724:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100727:	39 c2                	cmp    %eax,%edx
c0100729:	7f 7c                	jg     c01007a7 <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010072b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010072e:	89 c2                	mov    %eax,%edx
c0100730:	89 d0                	mov    %edx,%eax
c0100732:	01 c0                	add    %eax,%eax
c0100734:	01 d0                	add    %edx,%eax
c0100736:	c1 e0 02             	shl    $0x2,%eax
c0100739:	89 c2                	mov    %eax,%edx
c010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010073e:	01 d0                	add    %edx,%eax
c0100740:	8b 00                	mov    (%eax),%eax
c0100742:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100745:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100748:	29 d1                	sub    %edx,%ecx
c010074a:	89 ca                	mov    %ecx,%edx
c010074c:	39 d0                	cmp    %edx,%eax
c010074e:	73 22                	jae    c0100772 <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100750:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100753:	89 c2                	mov    %eax,%edx
c0100755:	89 d0                	mov    %edx,%eax
c0100757:	01 c0                	add    %eax,%eax
c0100759:	01 d0                	add    %edx,%eax
c010075b:	c1 e0 02             	shl    $0x2,%eax
c010075e:	89 c2                	mov    %eax,%edx
c0100760:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100763:	01 d0                	add    %edx,%eax
c0100765:	8b 10                	mov    (%eax),%edx
c0100767:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010076a:	01 c2                	add    %eax,%edx
c010076c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010076f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100772:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100775:	89 c2                	mov    %eax,%edx
c0100777:	89 d0                	mov    %edx,%eax
c0100779:	01 c0                	add    %eax,%eax
c010077b:	01 d0                	add    %edx,%eax
c010077d:	c1 e0 02             	shl    $0x2,%eax
c0100780:	89 c2                	mov    %eax,%edx
c0100782:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100785:	01 d0                	add    %edx,%eax
c0100787:	8b 50 08             	mov    0x8(%eax),%edx
c010078a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100790:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100793:	8b 40 10             	mov    0x10(%eax),%eax
c0100796:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100799:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010079c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010079f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007a5:	eb 15                	jmp    c01007bc <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01007ad:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bf:	8b 40 08             	mov    0x8(%eax),%eax
c01007c2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007c9:	00 
c01007ca:	89 04 24             	mov    %eax,(%esp)
c01007cd:	e8 43 8e 00 00       	call   c0109615 <strfind>
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d7:	8b 40 08             	mov    0x8(%eax),%eax
c01007da:	29 c2                	sub    %eax,%edx
c01007dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007df:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01007e5:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007e9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007f0:	00 
c01007f1:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007f4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007f8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100802:	89 04 24             	mov    %eax,(%esp)
c0100805:	e8 c5 fc ff ff       	call   c01004cf <stab_binsearch>
    if (lline <= rline) {
c010080a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010080d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100810:	39 c2                	cmp    %eax,%edx
c0100812:	7f 23                	jg     c0100837 <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
c0100814:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100817:	89 c2                	mov    %eax,%edx
c0100819:	89 d0                	mov    %edx,%eax
c010081b:	01 c0                	add    %eax,%eax
c010081d:	01 d0                	add    %edx,%eax
c010081f:	c1 e0 02             	shl    $0x2,%eax
c0100822:	89 c2                	mov    %eax,%edx
c0100824:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100827:	01 d0                	add    %edx,%eax
c0100829:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010082d:	89 c2                	mov    %eax,%edx
c010082f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100832:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100835:	eb 11                	jmp    c0100848 <debuginfo_eip+0x22b>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100837:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010083c:	e9 0c 01 00 00       	jmp    c010094d <debuginfo_eip+0x330>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100841:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100844:	48                   	dec    %eax
c0100845:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100848:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010084e:	39 c2                	cmp    %eax,%edx
c0100850:	7c 56                	jl     c01008a8 <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
c0100852:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100855:	89 c2                	mov    %eax,%edx
c0100857:	89 d0                	mov    %edx,%eax
c0100859:	01 c0                	add    %eax,%eax
c010085b:	01 d0                	add    %edx,%eax
c010085d:	c1 e0 02             	shl    $0x2,%eax
c0100860:	89 c2                	mov    %eax,%edx
c0100862:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100865:	01 d0                	add    %edx,%eax
c0100867:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086b:	3c 84                	cmp    $0x84,%al
c010086d:	74 39                	je     c01008a8 <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010086f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100872:	89 c2                	mov    %eax,%edx
c0100874:	89 d0                	mov    %edx,%eax
c0100876:	01 c0                	add    %eax,%eax
c0100878:	01 d0                	add    %edx,%eax
c010087a:	c1 e0 02             	shl    $0x2,%eax
c010087d:	89 c2                	mov    %eax,%edx
c010087f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100882:	01 d0                	add    %edx,%eax
c0100884:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100888:	3c 64                	cmp    $0x64,%al
c010088a:	75 b5                	jne    c0100841 <debuginfo_eip+0x224>
c010088c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010088f:	89 c2                	mov    %eax,%edx
c0100891:	89 d0                	mov    %edx,%eax
c0100893:	01 c0                	add    %eax,%eax
c0100895:	01 d0                	add    %edx,%eax
c0100897:	c1 e0 02             	shl    $0x2,%eax
c010089a:	89 c2                	mov    %eax,%edx
c010089c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010089f:	01 d0                	add    %edx,%eax
c01008a1:	8b 40 08             	mov    0x8(%eax),%eax
c01008a4:	85 c0                	test   %eax,%eax
c01008a6:	74 99                	je     c0100841 <debuginfo_eip+0x224>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008ae:	39 c2                	cmp    %eax,%edx
c01008b0:	7c 46                	jl     c01008f8 <debuginfo_eip+0x2db>
c01008b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008b5:	89 c2                	mov    %eax,%edx
c01008b7:	89 d0                	mov    %edx,%eax
c01008b9:	01 c0                	add    %eax,%eax
c01008bb:	01 d0                	add    %edx,%eax
c01008bd:	c1 e0 02             	shl    $0x2,%eax
c01008c0:	89 c2                	mov    %eax,%edx
c01008c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008c5:	01 d0                	add    %edx,%eax
c01008c7:	8b 00                	mov    (%eax),%eax
c01008c9:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01008cf:	29 d1                	sub    %edx,%ecx
c01008d1:	89 ca                	mov    %ecx,%edx
c01008d3:	39 d0                	cmp    %edx,%eax
c01008d5:	73 21                	jae    c01008f8 <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008da:	89 c2                	mov    %eax,%edx
c01008dc:	89 d0                	mov    %edx,%eax
c01008de:	01 c0                	add    %eax,%eax
c01008e0:	01 d0                	add    %edx,%eax
c01008e2:	c1 e0 02             	shl    $0x2,%eax
c01008e5:	89 c2                	mov    %eax,%edx
c01008e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ea:	01 d0                	add    %edx,%eax
c01008ec:	8b 10                	mov    (%eax),%edx
c01008ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008f1:	01 c2                	add    %eax,%edx
c01008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f6:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008fe:	39 c2                	cmp    %eax,%edx
c0100900:	7d 46                	jge    c0100948 <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
c0100902:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100905:	40                   	inc    %eax
c0100906:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100909:	eb 16                	jmp    c0100921 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010090b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010090e:	8b 40 14             	mov    0x14(%eax),%eax
c0100911:	8d 50 01             	lea    0x1(%eax),%edx
c0100914:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100917:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c010091a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010091d:	40                   	inc    %eax
c010091e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100921:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100924:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100927:	39 c2                	cmp    %eax,%edx
c0100929:	7d 1d                	jge    c0100948 <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010092b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010092e:	89 c2                	mov    %eax,%edx
c0100930:	89 d0                	mov    %edx,%eax
c0100932:	01 c0                	add    %eax,%eax
c0100934:	01 d0                	add    %edx,%eax
c0100936:	c1 e0 02             	shl    $0x2,%eax
c0100939:	89 c2                	mov    %eax,%edx
c010093b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010093e:	01 d0                	add    %edx,%eax
c0100940:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100944:	3c a0                	cmp    $0xa0,%al
c0100946:	74 c3                	je     c010090b <debuginfo_eip+0x2ee>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100948:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010094d:	c9                   	leave  
c010094e:	c3                   	ret    

c010094f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010094f:	55                   	push   %ebp
c0100950:	89 e5                	mov    %esp,%ebp
c0100952:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100955:	c7 04 24 a2 a1 10 c0 	movl   $0xc010a1a2,(%esp)
c010095c:	e8 48 f9 ff ff       	call   c01002a9 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100961:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100968:	c0 
c0100969:	c7 04 24 bb a1 10 c0 	movl   $0xc010a1bb,(%esp)
c0100970:	e8 34 f9 ff ff       	call   c01002a9 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100975:	c7 44 24 04 90 a0 10 	movl   $0xc010a090,0x4(%esp)
c010097c:	c0 
c010097d:	c7 04 24 d3 a1 10 c0 	movl   $0xc010a1d3,(%esp)
c0100984:	e8 20 f9 ff ff       	call   c01002a9 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100989:	c7 44 24 04 00 80 12 	movl   $0xc0128000,0x4(%esp)
c0100990:	c0 
c0100991:	c7 04 24 eb a1 10 c0 	movl   $0xc010a1eb,(%esp)
c0100998:	e8 0c f9 ff ff       	call   c01002a9 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c010099d:	c7 44 24 04 4c b1 12 	movl   $0xc012b14c,0x4(%esp)
c01009a4:	c0 
c01009a5:	c7 04 24 03 a2 10 c0 	movl   $0xc010a203,(%esp)
c01009ac:	e8 f8 f8 ff ff       	call   c01002a9 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009b1:	b8 4c b1 12 c0       	mov    $0xc012b14c,%eax
c01009b6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009bc:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009c1:	29 c2                	sub    %eax,%edx
c01009c3:	89 d0                	mov    %edx,%eax
c01009c5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009cb:	85 c0                	test   %eax,%eax
c01009cd:	0f 48 c2             	cmovs  %edx,%eax
c01009d0:	c1 f8 0a             	sar    $0xa,%eax
c01009d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009d7:	c7 04 24 1c a2 10 c0 	movl   $0xc010a21c,(%esp)
c01009de:	e8 c6 f8 ff ff       	call   c01002a9 <cprintf>
}
c01009e3:	90                   	nop
c01009e4:	c9                   	leave  
c01009e5:	c3                   	ret    

c01009e6 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009e6:	55                   	push   %ebp
c01009e7:	89 e5                	mov    %esp,%ebp
c01009e9:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009ef:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01009f9:	89 04 24             	mov    %eax,(%esp)
c01009fc:	e8 1c fc ff ff       	call   c010061d <debuginfo_eip>
c0100a01:	85 c0                	test   %eax,%eax
c0100a03:	74 15                	je     c0100a1a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0c:	c7 04 24 46 a2 10 c0 	movl   $0xc010a246,(%esp)
c0100a13:	e8 91 f8 ff ff       	call   c01002a9 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a18:	eb 6c                	jmp    c0100a86 <print_debuginfo+0xa0>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a21:	eb 1b                	jmp    c0100a3e <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100a23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a29:	01 d0                	add    %edx,%eax
c0100a2b:	0f b6 00             	movzbl (%eax),%eax
c0100a2e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a37:	01 ca                	add    %ecx,%edx
c0100a39:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a3b:	ff 45 f4             	incl   -0xc(%ebp)
c0100a3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a41:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a44:	7f dd                	jg     c0100a23 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a46:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a4f:	01 d0                	add    %edx,%eax
c0100a51:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a57:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a5a:	89 d1                	mov    %edx,%ecx
c0100a5c:	29 c1                	sub    %eax,%ecx
c0100a5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a64:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a68:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a6e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a72:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a7a:	c7 04 24 62 a2 10 c0 	movl   $0xc010a262,(%esp)
c0100a81:	e8 23 f8 ff ff       	call   c01002a9 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a86:	90                   	nop
c0100a87:	c9                   	leave  
c0100a88:	c3                   	ret    

c0100a89 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a89:	55                   	push   %ebp
c0100a8a:	89 e5                	mov    %esp,%ebp
c0100a8c:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a8f:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a92:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a98:	c9                   	leave  
c0100a99:	c3                   	ret    

c0100a9a <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a9a:	55                   	push   %ebp
c0100a9b:	89 e5                	mov    %esp,%ebp
c0100a9d:	53                   	push   %ebx
c0100a9e:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100aa1:	89 e8                	mov    %ebp,%eax
c0100aa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
c0100aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uintptr_t ebp = read_ebp();
c0100aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t eip = read_eip();
c0100aac:	e8 d8 ff ff ff       	call   c0100a89 <read_eip>
c0100ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32_t args[4] = {0};
c0100ab4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0100abb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0100ac2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100ac9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while(ebp != 0){
c0100ad0:	e9 9b 00 00 00       	jmp    c0100b70 <print_stackframe+0xd6>
        asm volatile("movl 8(%1), %0":"=r"(args[0]):"b"(ebp));
c0100ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ad8:	89 c3                	mov    %eax,%ebx
c0100ada:	8b 43 08             	mov    0x8(%ebx),%eax
c0100add:	89 45 dc             	mov    %eax,-0x24(%ebp)
        asm volatile("movl 12(%1), %0":"=r"(args[1]):"b"(ebp));
c0100ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae3:	89 c3                	mov    %eax,%ebx
c0100ae5:	8b 43 0c             	mov    0xc(%ebx),%eax
c0100ae8:	89 45 e0             	mov    %eax,-0x20(%ebp)
        asm volatile("movl 16(%1), %0":"=r"(args[2]):"b"(ebp));
c0100aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aee:	89 c3                	mov    %eax,%ebx
c0100af0:	8b 43 10             	mov    0x10(%ebx),%eax
c0100af3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        asm volatile("movl 20(%1), %0":"=r"(args[3]):"b"(ebp));
c0100af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af9:	89 c3                	mov    %eax,%ebx
c0100afb:	8b 43 14             	mov    0x14(%ebx),%eax
c0100afe:	89 45 e8             	mov    %eax,-0x18(%ebp)
        cprintf("ebp:0x%x eip:0x%x ", ebp, eip);
c0100b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b04:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b0f:	c7 04 24 74 a2 10 c0 	movl   $0xc010a274,(%esp)
c0100b16:	e8 8e f7 ff ff       	call   c01002a9 <cprintf>
        cprintf("args:0x%x 0x%x ", args[0], args[1]);
c0100b1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100b1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100b21:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b29:	c7 04 24 87 a2 10 c0 	movl   $0xc010a287,(%esp)
c0100b30:	e8 74 f7 ff ff       	call   c01002a9 <cprintf>
        cprintf("0x%x 0x%x\n", args[2], args[3]);
c0100b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0100b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b3b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b43:	c7 04 24 97 a2 10 c0 	movl   $0xc010a297,(%esp)
c0100b4a:	e8 5a f7 ff ff       	call   c01002a9 <cprintf>
        print_debuginfo(eip-1);
c0100b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b52:	48                   	dec    %eax
c0100b53:	89 04 24             	mov    %eax,(%esp)
c0100b56:	e8 8b fe ff ff       	call   c01009e6 <print_debuginfo>

        // asm volatile("movl 4(%0), %1"::"a"(ebp), "b"(eip));
        asm volatile(
c0100b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b5e:	89 c3                	mov    %eax,%ebx
c0100b60:	8b 43 04             	mov    0x4(%ebx),%eax
c0100b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
            "movl 4(%1), %0;"
            :"=a"(eip)
            :"b"(ebp)
        );
        // asm volatile("movl (%0), %1"::"=r"(ebp), "b"(ebp));
        asm volatile(
c0100b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b69:	89 c3                	mov    %eax,%ebx
c0100b6b:	8b 03                	mov    (%ebx),%eax
c0100b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uintptr_t ebp = read_ebp();
    uintptr_t eip = read_eip();
    uint32_t args[4] = {0};
    while(ebp != 0){
c0100b70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b74:	0f 85 5b ff ff ff    	jne    c0100ad5 <print_stackframe+0x3b>
            :"=a"(ebp)
            :"b"(ebp)
        );
    }
 
}
c0100b7a:	90                   	nop
c0100b7b:	83 c4 34             	add    $0x34,%esp
c0100b7e:	5b                   	pop    %ebx
c0100b7f:	5d                   	pop    %ebp
c0100b80:	c3                   	ret    

c0100b81 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b81:	55                   	push   %ebp
c0100b82:	89 e5                	mov    %esp,%ebp
c0100b84:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b8e:	eb 0c                	jmp    c0100b9c <parse+0x1b>
            *buf ++ = '\0';
c0100b90:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b93:	8d 50 01             	lea    0x1(%eax),%edx
c0100b96:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b99:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b9f:	0f b6 00             	movzbl (%eax),%eax
c0100ba2:	84 c0                	test   %al,%al
c0100ba4:	74 1d                	je     c0100bc3 <parse+0x42>
c0100ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba9:	0f b6 00             	movzbl (%eax),%eax
c0100bac:	0f be c0             	movsbl %al,%eax
c0100baf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bb3:	c7 04 24 24 a3 10 c0 	movl   $0xc010a324,(%esp)
c0100bba:	e8 24 8a 00 00       	call   c01095e3 <strchr>
c0100bbf:	85 c0                	test   %eax,%eax
c0100bc1:	75 cd                	jne    c0100b90 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100bc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc6:	0f b6 00             	movzbl (%eax),%eax
c0100bc9:	84 c0                	test   %al,%al
c0100bcb:	74 69                	je     c0100c36 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bcd:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bd1:	75 14                	jne    c0100be7 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bd3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bda:	00 
c0100bdb:	c7 04 24 29 a3 10 c0 	movl   $0xc010a329,(%esp)
c0100be2:	e8 c2 f6 ff ff       	call   c01002a9 <cprintf>
        }
        argv[argc ++] = buf;
c0100be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bea:	8d 50 01             	lea    0x1(%eax),%edx
c0100bed:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bf0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bfa:	01 c2                	add    %eax,%edx
c0100bfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bff:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c01:	eb 03                	jmp    c0100c06 <parse+0x85>
            buf ++;
c0100c03:	ff 45 08             	incl   0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c06:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c09:	0f b6 00             	movzbl (%eax),%eax
c0100c0c:	84 c0                	test   %al,%al
c0100c0e:	0f 84 7a ff ff ff    	je     c0100b8e <parse+0xd>
c0100c14:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c17:	0f b6 00             	movzbl (%eax),%eax
c0100c1a:	0f be c0             	movsbl %al,%eax
c0100c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c21:	c7 04 24 24 a3 10 c0 	movl   $0xc010a324,(%esp)
c0100c28:	e8 b6 89 00 00       	call   c01095e3 <strchr>
c0100c2d:	85 c0                	test   %eax,%eax
c0100c2f:	74 d2                	je     c0100c03 <parse+0x82>
            buf ++;
        }
    }
c0100c31:	e9 58 ff ff ff       	jmp    c0100b8e <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100c36:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c3a:	c9                   	leave  
c0100c3b:	c3                   	ret    

c0100c3c <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c3c:	55                   	push   %ebp
c0100c3d:	89 e5                	mov    %esp,%ebp
c0100c3f:	53                   	push   %ebx
c0100c40:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c43:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c4d:	89 04 24             	mov    %eax,(%esp)
c0100c50:	e8 2c ff ff ff       	call   c0100b81 <parse>
c0100c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c5c:	75 0a                	jne    c0100c68 <runcmd+0x2c>
        return 0;
c0100c5e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c63:	e9 83 00 00 00       	jmp    c0100ceb <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c6f:	eb 5a                	jmp    c0100ccb <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c71:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c77:	89 d0                	mov    %edx,%eax
c0100c79:	01 c0                	add    %eax,%eax
c0100c7b:	01 d0                	add    %edx,%eax
c0100c7d:	c1 e0 02             	shl    $0x2,%eax
c0100c80:	05 00 50 12 c0       	add    $0xc0125000,%eax
c0100c85:	8b 00                	mov    (%eax),%eax
c0100c87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c8b:	89 04 24             	mov    %eax,(%esp)
c0100c8e:	e8 b3 88 00 00       	call   c0109546 <strcmp>
c0100c93:	85 c0                	test   %eax,%eax
c0100c95:	75 31                	jne    c0100cc8 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c97:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c9a:	89 d0                	mov    %edx,%eax
c0100c9c:	01 c0                	add    %eax,%eax
c0100c9e:	01 d0                	add    %edx,%eax
c0100ca0:	c1 e0 02             	shl    $0x2,%eax
c0100ca3:	05 08 50 12 c0       	add    $0xc0125008,%eax
c0100ca8:	8b 10                	mov    (%eax),%edx
c0100caa:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100cad:	83 c0 04             	add    $0x4,%eax
c0100cb0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100cb3:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100cb9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cc1:	89 1c 24             	mov    %ebx,(%esp)
c0100cc4:	ff d2                	call   *%edx
c0100cc6:	eb 23                	jmp    c0100ceb <runcmd+0xaf>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cc8:	ff 45 f4             	incl   -0xc(%ebp)
c0100ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cce:	83 f8 02             	cmp    $0x2,%eax
c0100cd1:	76 9e                	jbe    c0100c71 <runcmd+0x35>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cd3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cda:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0100ce1:	e8 c3 f5 ff ff       	call   c01002a9 <cprintf>
    return 0;
c0100ce6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ceb:	83 c4 64             	add    $0x64,%esp
c0100cee:	5b                   	pop    %ebx
c0100cef:	5d                   	pop    %ebp
c0100cf0:	c3                   	ret    

c0100cf1 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cf1:	55                   	push   %ebp
c0100cf2:	89 e5                	mov    %esp,%ebp
c0100cf4:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cf7:	c7 04 24 60 a3 10 c0 	movl   $0xc010a360,(%esp)
c0100cfe:	e8 a6 f5 ff ff       	call   c01002a9 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d03:	c7 04 24 88 a3 10 c0 	movl   $0xc010a388,(%esp)
c0100d0a:	e8 9a f5 ff ff       	call   c01002a9 <cprintf>

    if (tf != NULL) {
c0100d0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d13:	74 0b                	je     c0100d20 <kmonitor+0x2f>
        print_trapframe(tf);
c0100d15:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d18:	89 04 24             	mov    %eax,(%esp)
c0100d1b:	e8 e4 15 00 00       	call   c0102304 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d20:	c7 04 24 ad a3 10 c0 	movl   $0xc010a3ad,(%esp)
c0100d27:	e8 1f f6 ff ff       	call   c010034b <readline>
c0100d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d33:	74 eb                	je     c0100d20 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100d35:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d3f:	89 04 24             	mov    %eax,(%esp)
c0100d42:	e8 f5 fe ff ff       	call   c0100c3c <runcmd>
c0100d47:	85 c0                	test   %eax,%eax
c0100d49:	78 02                	js     c0100d4d <kmonitor+0x5c>
                break;
            }
        }
    }
c0100d4b:	eb d3                	jmp    c0100d20 <kmonitor+0x2f>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100d4d:	90                   	nop
            }
        }
    }
}
c0100d4e:	90                   	nop
c0100d4f:	c9                   	leave  
c0100d50:	c3                   	ret    

c0100d51 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d51:	55                   	push   %ebp
c0100d52:	89 e5                	mov    %esp,%ebp
c0100d54:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d5e:	eb 3d                	jmp    c0100d9d <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d60:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d63:	89 d0                	mov    %edx,%eax
c0100d65:	01 c0                	add    %eax,%eax
c0100d67:	01 d0                	add    %edx,%eax
c0100d69:	c1 e0 02             	shl    $0x2,%eax
c0100d6c:	05 04 50 12 c0       	add    $0xc0125004,%eax
c0100d71:	8b 08                	mov    (%eax),%ecx
c0100d73:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d76:	89 d0                	mov    %edx,%eax
c0100d78:	01 c0                	add    %eax,%eax
c0100d7a:	01 d0                	add    %edx,%eax
c0100d7c:	c1 e0 02             	shl    $0x2,%eax
c0100d7f:	05 00 50 12 c0       	add    $0xc0125000,%eax
c0100d84:	8b 00                	mov    (%eax),%eax
c0100d86:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d8e:	c7 04 24 b1 a3 10 c0 	movl   $0xc010a3b1,(%esp)
c0100d95:	e8 0f f5 ff ff       	call   c01002a9 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d9a:	ff 45 f4             	incl   -0xc(%ebp)
c0100d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100da0:	83 f8 02             	cmp    $0x2,%eax
c0100da3:	76 bb                	jbe    c0100d60 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100da5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100daa:	c9                   	leave  
c0100dab:	c3                   	ret    

c0100dac <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100dac:	55                   	push   %ebp
c0100dad:	89 e5                	mov    %esp,%ebp
c0100daf:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100db2:	e8 98 fb ff ff       	call   c010094f <print_kerninfo>
    return 0;
c0100db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dbc:	c9                   	leave  
c0100dbd:	c3                   	ret    

c0100dbe <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100dbe:	55                   	push   %ebp
c0100dbf:	89 e5                	mov    %esp,%ebp
c0100dc1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100dc4:	e8 d1 fc ff ff       	call   c0100a9a <print_stackframe>
    return 0;
c0100dc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dce:	c9                   	leave  
c0100dcf:	c3                   	ret    

c0100dd0 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c0100dd0:	55                   	push   %ebp
c0100dd1:	89 e5                	mov    %esp,%ebp
c0100dd3:	83 ec 14             	sub    $0x14,%esp
c0100dd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100dd9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0100ddd:	90                   	nop
c0100dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100de1:	83 c0 07             	add    $0x7,%eax
c0100de4:	0f b7 c0             	movzwl %ax,%eax
c0100de7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100deb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100def:	89 c2                	mov    %eax,%edx
c0100df1:	ec                   	in     (%dx),%al
c0100df2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100df5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100df9:	0f b6 c0             	movzbl %al,%eax
c0100dfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100dff:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e02:	25 80 00 00 00       	and    $0x80,%eax
c0100e07:	85 c0                	test   %eax,%eax
c0100e09:	75 d3                	jne    c0100dde <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0100e0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0100e0f:	74 11                	je     c0100e22 <ide_wait_ready+0x52>
c0100e11:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e14:	83 e0 21             	and    $0x21,%eax
c0100e17:	85 c0                	test   %eax,%eax
c0100e19:	74 07                	je     c0100e22 <ide_wait_ready+0x52>
        return -1;
c0100e1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100e20:	eb 05                	jmp    c0100e27 <ide_wait_ready+0x57>
    }
    return 0;
c0100e22:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e27:	c9                   	leave  
c0100e28:	c3                   	ret    

c0100e29 <ide_init>:

void
ide_init(void) {
c0100e29:	55                   	push   %ebp
c0100e2a:	89 e5                	mov    %esp,%ebp
c0100e2c:	57                   	push   %edi
c0100e2d:	53                   	push   %ebx
c0100e2e:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0100e34:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0100e3a:	e9 d4 02 00 00       	jmp    c0101113 <ide_init+0x2ea>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0100e3f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e43:	c1 e0 03             	shl    $0x3,%eax
c0100e46:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100e4d:	29 c2                	sub    %eax,%edx
c0100e4f:	89 d0                	mov    %edx,%eax
c0100e51:	05 40 84 12 c0       	add    $0xc0128440,%eax
c0100e56:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0100e59:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e5d:	d1 e8                	shr    %eax
c0100e5f:	0f b7 c0             	movzwl %ax,%eax
c0100e62:	8b 04 85 bc a3 10 c0 	mov    -0x3fef5c44(,%eax,4),%eax
c0100e69:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0100e6d:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e71:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100e78:	00 
c0100e79:	89 04 24             	mov    %eax,(%esp)
c0100e7c:	e8 4f ff ff ff       	call   c0100dd0 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0100e81:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e85:	83 e0 01             	and    $0x1,%eax
c0100e88:	c1 e0 04             	shl    $0x4,%eax
c0100e8b:	0c e0                	or     $0xe0,%al
c0100e8d:	0f b6 c0             	movzbl %al,%eax
c0100e90:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e94:	83 c2 06             	add    $0x6,%edx
c0100e97:	0f b7 d2             	movzwl %dx,%edx
c0100e9a:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0100e9e:	88 45 c7             	mov    %al,-0x39(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ea1:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
c0100ea5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100ea9:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100eaa:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100eae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100eb5:	00 
c0100eb6:	89 04 24             	mov    %eax,(%esp)
c0100eb9:	e8 12 ff ff ff       	call   c0100dd0 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c0100ebe:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ec2:	83 c0 07             	add    $0x7,%eax
c0100ec5:	0f b7 c0             	movzwl %ax,%eax
c0100ec8:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
c0100ecc:	c6 45 c8 ec          	movb   $0xec,-0x38(%ebp)
c0100ed0:	0f b6 45 c8          	movzbl -0x38(%ebp),%eax
c0100ed4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100ed7:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100ed8:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100edc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100ee3:	00 
c0100ee4:	89 04 24             	mov    %eax,(%esp)
c0100ee7:	e8 e4 fe ff ff       	call   c0100dd0 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0100eec:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ef0:	83 c0 07             	add    $0x7,%eax
c0100ef3:	0f b7 c0             	movzwl %ax,%eax
c0100ef6:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100efa:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c0100efe:	89 c2                	mov    %eax,%edx
c0100f00:	ec                   	in     (%dx),%al
c0100f01:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c0100f04:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0100f08:	84 c0                	test   %al,%al
c0100f0a:	0f 84 f9 01 00 00    	je     c0101109 <ide_init+0x2e0>
c0100f10:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f14:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0100f1b:	00 
c0100f1c:	89 04 24             	mov    %eax,(%esp)
c0100f1f:	e8 ac fe ff ff       	call   c0100dd0 <ide_wait_ready>
c0100f24:	85 c0                	test   %eax,%eax
c0100f26:	0f 85 dd 01 00 00    	jne    c0101109 <ide_init+0x2e0>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0100f2c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f30:	c1 e0 03             	shl    $0x3,%eax
c0100f33:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100f3a:	29 c2                	sub    %eax,%edx
c0100f3c:	89 d0                	mov    %edx,%eax
c0100f3e:	05 40 84 12 c0       	add    $0xc0128440,%eax
c0100f43:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0100f46:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0100f4d:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f53:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0100f56:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0100f5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100f60:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0100f63:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0100f66:	89 cb                	mov    %ecx,%ebx
c0100f68:	89 df                	mov    %ebx,%edi
c0100f6a:	89 c1                	mov    %eax,%ecx
c0100f6c:	fc                   	cld    
c0100f6d:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0100f6f:	89 c8                	mov    %ecx,%eax
c0100f71:	89 fb                	mov    %edi,%ebx
c0100f73:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0100f76:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0100f79:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f7f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0100f82:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f85:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0100f8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0100f8e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100f91:	25 00 00 00 04       	and    $0x4000000,%eax
c0100f96:	85 c0                	test   %eax,%eax
c0100f98:	74 0e                	je     c0100fa8 <ide_init+0x17f>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0100f9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f9d:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0100fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100fa6:	eb 09                	jmp    c0100fb1 <ide_init+0x188>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0100fa8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100fab:	8b 40 78             	mov    0x78(%eax),%eax
c0100fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0100fb1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100fb5:	c1 e0 03             	shl    $0x3,%eax
c0100fb8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100fbf:	29 c2                	sub    %eax,%edx
c0100fc1:	89 d0                	mov    %edx,%eax
c0100fc3:	8d 90 44 84 12 c0    	lea    -0x3fed7bbc(%eax),%edx
c0100fc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100fcc:	89 02                	mov    %eax,(%edx)
        ide_devices[ideno].size = sectors;
c0100fce:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100fd2:	c1 e0 03             	shl    $0x3,%eax
c0100fd5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100fdc:	29 c2                	sub    %eax,%edx
c0100fde:	89 d0                	mov    %edx,%eax
c0100fe0:	8d 90 48 84 12 c0    	lea    -0x3fed7bb8(%eax),%edx
c0100fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100fe9:	89 02                	mov    %eax,(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0100feb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100fee:	83 c0 62             	add    $0x62,%eax
c0100ff1:	0f b7 00             	movzwl (%eax),%eax
c0100ff4:	25 00 02 00 00       	and    $0x200,%eax
c0100ff9:	85 c0                	test   %eax,%eax
c0100ffb:	75 24                	jne    c0101021 <ide_init+0x1f8>
c0100ffd:	c7 44 24 0c c4 a3 10 	movl   $0xc010a3c4,0xc(%esp)
c0101004:	c0 
c0101005:	c7 44 24 08 07 a4 10 	movl   $0xc010a407,0x8(%esp)
c010100c:	c0 
c010100d:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101014:	00 
c0101015:	c7 04 24 1c a4 10 c0 	movl   $0xc010a41c,(%esp)
c010101c:	e8 df f3 ff ff       	call   c0100400 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101021:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101025:	c1 e0 03             	shl    $0x3,%eax
c0101028:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010102f:	29 c2                	sub    %eax,%edx
c0101031:	8d 82 40 84 12 c0    	lea    -0x3fed7bc0(%edx),%eax
c0101037:	83 c0 0c             	add    $0xc,%eax
c010103a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010103d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101040:	83 c0 36             	add    $0x36,%eax
c0101043:	89 45 d0             	mov    %eax,-0x30(%ebp)
        unsigned int i, length = 40;
c0101046:	c7 45 cc 28 00 00 00 	movl   $0x28,-0x34(%ebp)
        for (i = 0; i < length; i += 2) {
c010104d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101054:	eb 34                	jmp    c010108a <ide_init+0x261>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101056:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101059:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010105c:	01 c2                	add    %eax,%edx
c010105e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101061:	8d 48 01             	lea    0x1(%eax),%ecx
c0101064:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101067:	01 c8                	add    %ecx,%eax
c0101069:	0f b6 00             	movzbl (%eax),%eax
c010106c:	88 02                	mov    %al,(%edx)
c010106e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101071:	8d 50 01             	lea    0x1(%eax),%edx
c0101074:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101077:	01 c2                	add    %eax,%edx
c0101079:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010107c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010107f:	01 c8                	add    %ecx,%eax
c0101081:	0f b6 00             	movzbl (%eax),%eax
c0101084:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101086:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c010108a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010108d:	3b 45 cc             	cmp    -0x34(%ebp),%eax
c0101090:	72 c4                	jb     c0101056 <ide_init+0x22d>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101092:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101095:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101098:	01 d0                	add    %edx,%eax
c010109a:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010109d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01010a0:	8d 50 ff             	lea    -0x1(%eax),%edx
c01010a3:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01010a6:	85 c0                	test   %eax,%eax
c01010a8:	74 0f                	je     c01010b9 <ide_init+0x290>
c01010aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01010ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01010b0:	01 d0                	add    %edx,%eax
c01010b2:	0f b6 00             	movzbl (%eax),%eax
c01010b5:	3c 20                	cmp    $0x20,%al
c01010b7:	74 d9                	je     c0101092 <ide_init+0x269>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01010b9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010bd:	c1 e0 03             	shl    $0x3,%eax
c01010c0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01010c7:	29 c2                	sub    %eax,%edx
c01010c9:	8d 82 40 84 12 c0    	lea    -0x3fed7bc0(%edx),%eax
c01010cf:	8d 48 0c             	lea    0xc(%eax),%ecx
c01010d2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010d6:	c1 e0 03             	shl    $0x3,%eax
c01010d9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01010e0:	29 c2                	sub    %eax,%edx
c01010e2:	89 d0                	mov    %edx,%eax
c01010e4:	05 48 84 12 c0       	add    $0xc0128448,%eax
c01010e9:	8b 10                	mov    (%eax),%edx
c01010eb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01010f3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01010f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01010fb:	c7 04 24 2e a4 10 c0 	movl   $0xc010a42e,(%esp)
c0101102:	e8 a2 f1 ff ff       	call   c01002a9 <cprintf>
c0101107:	eb 01                	jmp    c010110a <ide_init+0x2e1>
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
        ide_wait_ready(iobase, 0);

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
            continue ;
c0101109:	90                   	nop

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010110a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010110e:	40                   	inc    %eax
c010110f:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101113:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101117:	83 f8 03             	cmp    $0x3,%eax
c010111a:	0f 86 1f fd ff ff    	jbe    c0100e3f <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101120:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101127:	e8 8a 0e 00 00       	call   c0101fb6 <pic_enable>
    pic_enable(IRQ_IDE2);
c010112c:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101133:	e8 7e 0e 00 00       	call   c0101fb6 <pic_enable>
}
c0101138:	90                   	nop
c0101139:	81 c4 50 02 00 00    	add    $0x250,%esp
c010113f:	5b                   	pop    %ebx
c0101140:	5f                   	pop    %edi
c0101141:	5d                   	pop    %ebp
c0101142:	c3                   	ret    

c0101143 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101143:	55                   	push   %ebp
c0101144:	89 e5                	mov    %esp,%ebp
c0101146:	83 ec 04             	sub    $0x4,%esp
c0101149:	8b 45 08             	mov    0x8(%ebp),%eax
c010114c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101150:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101154:	83 f8 03             	cmp    $0x3,%eax
c0101157:	77 25                	ja     c010117e <ide_device_valid+0x3b>
c0101159:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c010115d:	c1 e0 03             	shl    $0x3,%eax
c0101160:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101167:	29 c2                	sub    %eax,%edx
c0101169:	89 d0                	mov    %edx,%eax
c010116b:	05 40 84 12 c0       	add    $0xc0128440,%eax
c0101170:	0f b6 00             	movzbl (%eax),%eax
c0101173:	84 c0                	test   %al,%al
c0101175:	74 07                	je     c010117e <ide_device_valid+0x3b>
c0101177:	b8 01 00 00 00       	mov    $0x1,%eax
c010117c:	eb 05                	jmp    c0101183 <ide_device_valid+0x40>
c010117e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101183:	c9                   	leave  
c0101184:	c3                   	ret    

c0101185 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101185:	55                   	push   %ebp
c0101186:	89 e5                	mov    %esp,%ebp
c0101188:	83 ec 08             	sub    $0x8,%esp
c010118b:	8b 45 08             	mov    0x8(%ebp),%eax
c010118e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101192:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101196:	89 04 24             	mov    %eax,(%esp)
c0101199:	e8 a5 ff ff ff       	call   c0101143 <ide_device_valid>
c010119e:	85 c0                	test   %eax,%eax
c01011a0:	74 1b                	je     c01011bd <ide_device_size+0x38>
        return ide_devices[ideno].size;
c01011a2:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c01011a6:	c1 e0 03             	shl    $0x3,%eax
c01011a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01011b0:	29 c2                	sub    %eax,%edx
c01011b2:	89 d0                	mov    %edx,%eax
c01011b4:	05 48 84 12 c0       	add    $0xc0128448,%eax
c01011b9:	8b 00                	mov    (%eax),%eax
c01011bb:	eb 05                	jmp    c01011c2 <ide_device_size+0x3d>
    }
    return 0;
c01011bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01011c2:	c9                   	leave  
c01011c3:	c3                   	ret    

c01011c4 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c01011c4:	55                   	push   %ebp
c01011c5:	89 e5                	mov    %esp,%ebp
c01011c7:	57                   	push   %edi
c01011c8:	53                   	push   %ebx
c01011c9:	83 ec 50             	sub    $0x50,%esp
c01011cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01011cf:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c01011d3:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c01011da:	77 27                	ja     c0101203 <ide_read_secs+0x3f>
c01011dc:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011e0:	83 f8 03             	cmp    $0x3,%eax
c01011e3:	77 1e                	ja     c0101203 <ide_read_secs+0x3f>
c01011e5:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011e9:	c1 e0 03             	shl    $0x3,%eax
c01011ec:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01011f3:	29 c2                	sub    %eax,%edx
c01011f5:	89 d0                	mov    %edx,%eax
c01011f7:	05 40 84 12 c0       	add    $0xc0128440,%eax
c01011fc:	0f b6 00             	movzbl (%eax),%eax
c01011ff:	84 c0                	test   %al,%al
c0101201:	75 24                	jne    c0101227 <ide_read_secs+0x63>
c0101203:	c7 44 24 0c 4c a4 10 	movl   $0xc010a44c,0xc(%esp)
c010120a:	c0 
c010120b:	c7 44 24 08 07 a4 10 	movl   $0xc010a407,0x8(%esp)
c0101212:	c0 
c0101213:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c010121a:	00 
c010121b:	c7 04 24 1c a4 10 c0 	movl   $0xc010a41c,(%esp)
c0101222:	e8 d9 f1 ff ff       	call   c0100400 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101227:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c010122e:	77 0f                	ja     c010123f <ide_read_secs+0x7b>
c0101230:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101233:	8b 45 14             	mov    0x14(%ebp),%eax
c0101236:	01 d0                	add    %edx,%eax
c0101238:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c010123d:	76 24                	jbe    c0101263 <ide_read_secs+0x9f>
c010123f:	c7 44 24 0c 74 a4 10 	movl   $0xc010a474,0xc(%esp)
c0101246:	c0 
c0101247:	c7 44 24 08 07 a4 10 	movl   $0xc010a407,0x8(%esp)
c010124e:	c0 
c010124f:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101256:	00 
c0101257:	c7 04 24 1c a4 10 c0 	movl   $0xc010a41c,(%esp)
c010125e:	e8 9d f1 ff ff       	call   c0100400 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101263:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101267:	d1 e8                	shr    %eax
c0101269:	0f b7 c0             	movzwl %ax,%eax
c010126c:	8b 04 85 bc a3 10 c0 	mov    -0x3fef5c44(,%eax,4),%eax
c0101273:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101277:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010127b:	d1 e8                	shr    %eax
c010127d:	0f b7 c0             	movzwl %ax,%eax
c0101280:	0f b7 04 85 be a3 10 	movzwl -0x3fef5c42(,%eax,4),%eax
c0101287:	c0 
c0101288:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c010128c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101290:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101297:	00 
c0101298:	89 04 24             	mov    %eax,(%esp)
c010129b:	e8 30 fb ff ff       	call   c0100dd0 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c01012a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01012a3:	83 c0 02             	add    $0x2,%eax
c01012a6:	0f b7 c0             	movzwl %ax,%eax
c01012a9:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012ad:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012b1:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c01012b5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012b9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c01012ba:	8b 45 14             	mov    0x14(%ebp),%eax
c01012bd:	0f b6 c0             	movzbl %al,%eax
c01012c0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012c4:	83 c2 02             	add    $0x2,%edx
c01012c7:	0f b7 d2             	movzwl %dx,%edx
c01012ca:	66 89 55 e8          	mov    %dx,-0x18(%ebp)
c01012ce:	88 45 d8             	mov    %al,-0x28(%ebp)
c01012d1:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c01012d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01012d8:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c01012d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012dc:	0f b6 c0             	movzbl %al,%eax
c01012df:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012e3:	83 c2 03             	add    $0x3,%edx
c01012e6:	0f b7 d2             	movzwl %dx,%edx
c01012e9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ed:	88 45 d9             	mov    %al,-0x27(%ebp)
c01012f0:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01012f4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012f8:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c01012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012fc:	c1 e8 08             	shr    $0x8,%eax
c01012ff:	0f b6 c0             	movzbl %al,%eax
c0101302:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101306:	83 c2 04             	add    $0x4,%edx
c0101309:	0f b7 d2             	movzwl %dx,%edx
c010130c:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
c0101310:	88 45 da             	mov    %al,-0x26(%ebp)
c0101313:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101317:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010131a:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c010131b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010131e:	c1 e8 10             	shr    $0x10,%eax
c0101321:	0f b6 c0             	movzbl %al,%eax
c0101324:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101328:	83 c2 05             	add    $0x5,%edx
c010132b:	0f b7 d2             	movzwl %dx,%edx
c010132e:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101332:	88 45 db             	mov    %al,-0x25(%ebp)
c0101335:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101339:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010133d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c010133e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101341:	24 01                	and    $0x1,%al
c0101343:	c0 e0 04             	shl    $0x4,%al
c0101346:	88 c2                	mov    %al,%dl
c0101348:	8b 45 0c             	mov    0xc(%ebp),%eax
c010134b:	c1 e8 18             	shr    $0x18,%eax
c010134e:	24 0f                	and    $0xf,%al
c0101350:	08 d0                	or     %dl,%al
c0101352:	0c e0                	or     $0xe0,%al
c0101354:	0f b6 c0             	movzbl %al,%eax
c0101357:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010135b:	83 c2 06             	add    $0x6,%edx
c010135e:	0f b7 d2             	movzwl %dx,%edx
c0101361:	66 89 55 e0          	mov    %dx,-0x20(%ebp)
c0101365:	88 45 dc             	mov    %al,-0x24(%ebp)
c0101368:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c010136c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010136f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101370:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101374:	83 c0 07             	add    $0x7,%eax
c0101377:	0f b7 c0             	movzwl %ax,%eax
c010137a:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c010137e:	c6 45 dd 20          	movb   $0x20,-0x23(%ebp)
c0101382:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101386:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010138a:	ee                   	out    %al,(%dx)

    int ret = 0;
c010138b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101392:	eb 57                	jmp    c01013eb <ide_read_secs+0x227>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101394:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101398:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010139f:	00 
c01013a0:	89 04 24             	mov    %eax,(%esp)
c01013a3:	e8 28 fa ff ff       	call   c0100dd0 <ide_wait_ready>
c01013a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013af:	75 42                	jne    c01013f3 <ide_read_secs+0x22f>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c01013b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01013b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01013b8:	8b 45 10             	mov    0x10(%ebp),%eax
c01013bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01013be:	c7 45 cc 80 00 00 00 	movl   $0x80,-0x34(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c01013c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01013c8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01013cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01013ce:	89 cb                	mov    %ecx,%ebx
c01013d0:	89 df                	mov    %ebx,%edi
c01013d2:	89 c1                	mov    %eax,%ecx
c01013d4:	fc                   	cld    
c01013d5:	f2 6d                	repnz insl (%dx),%es:(%edi)
c01013d7:	89 c8                	mov    %ecx,%eax
c01013d9:	89 fb                	mov    %edi,%ebx
c01013db:	89 5d d0             	mov    %ebx,-0x30(%ebp)
c01013de:	89 45 cc             	mov    %eax,-0x34(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c01013e1:	ff 4d 14             	decl   0x14(%ebp)
c01013e4:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c01013eb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01013ef:	75 a3                	jne    c0101394 <ide_read_secs+0x1d0>
c01013f1:	eb 01                	jmp    c01013f4 <ide_read_secs+0x230>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c01013f3:	90                   	nop
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c01013f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01013f7:	83 c4 50             	add    $0x50,%esp
c01013fa:	5b                   	pop    %ebx
c01013fb:	5f                   	pop    %edi
c01013fc:	5d                   	pop    %ebp
c01013fd:	c3                   	ret    

c01013fe <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c01013fe:	55                   	push   %ebp
c01013ff:	89 e5                	mov    %esp,%ebp
c0101401:	56                   	push   %esi
c0101402:	53                   	push   %ebx
c0101403:	83 ec 50             	sub    $0x50,%esp
c0101406:	8b 45 08             	mov    0x8(%ebp),%eax
c0101409:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c010140d:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101414:	77 27                	ja     c010143d <ide_write_secs+0x3f>
c0101416:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010141a:	83 f8 03             	cmp    $0x3,%eax
c010141d:	77 1e                	ja     c010143d <ide_write_secs+0x3f>
c010141f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101423:	c1 e0 03             	shl    $0x3,%eax
c0101426:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010142d:	29 c2                	sub    %eax,%edx
c010142f:	89 d0                	mov    %edx,%eax
c0101431:	05 40 84 12 c0       	add    $0xc0128440,%eax
c0101436:	0f b6 00             	movzbl (%eax),%eax
c0101439:	84 c0                	test   %al,%al
c010143b:	75 24                	jne    c0101461 <ide_write_secs+0x63>
c010143d:	c7 44 24 0c 4c a4 10 	movl   $0xc010a44c,0xc(%esp)
c0101444:	c0 
c0101445:	c7 44 24 08 07 a4 10 	movl   $0xc010a407,0x8(%esp)
c010144c:	c0 
c010144d:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101454:	00 
c0101455:	c7 04 24 1c a4 10 c0 	movl   $0xc010a41c,(%esp)
c010145c:	e8 9f ef ff ff       	call   c0100400 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101461:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101468:	77 0f                	ja     c0101479 <ide_write_secs+0x7b>
c010146a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010146d:	8b 45 14             	mov    0x14(%ebp),%eax
c0101470:	01 d0                	add    %edx,%eax
c0101472:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101477:	76 24                	jbe    c010149d <ide_write_secs+0x9f>
c0101479:	c7 44 24 0c 74 a4 10 	movl   $0xc010a474,0xc(%esp)
c0101480:	c0 
c0101481:	c7 44 24 08 07 a4 10 	movl   $0xc010a407,0x8(%esp)
c0101488:	c0 
c0101489:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101490:	00 
c0101491:	c7 04 24 1c a4 10 c0 	movl   $0xc010a41c,(%esp)
c0101498:	e8 63 ef ff ff       	call   c0100400 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c010149d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01014a1:	d1 e8                	shr    %eax
c01014a3:	0f b7 c0             	movzwl %ax,%eax
c01014a6:	8b 04 85 bc a3 10 c0 	mov    -0x3fef5c44(,%eax,4),%eax
c01014ad:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c01014b1:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01014b5:	d1 e8                	shr    %eax
c01014b7:	0f b7 c0             	movzwl %ax,%eax
c01014ba:	0f b7 04 85 be a3 10 	movzwl -0x3fef5c42(,%eax,4),%eax
c01014c1:	c0 
c01014c2:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c01014c6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01014ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01014d1:	00 
c01014d2:	89 04 24             	mov    %eax,(%esp)
c01014d5:	e8 f6 f8 ff ff       	call   c0100dd0 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c01014da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014dd:	83 c0 02             	add    $0x2,%eax
c01014e0:	0f b7 c0             	movzwl %ax,%eax
c01014e3:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01014e7:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01014eb:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c01014ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01014f3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c01014f4:	8b 45 14             	mov    0x14(%ebp),%eax
c01014f7:	0f b6 c0             	movzbl %al,%eax
c01014fa:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014fe:	83 c2 02             	add    $0x2,%edx
c0101501:	0f b7 d2             	movzwl %dx,%edx
c0101504:	66 89 55 e8          	mov    %dx,-0x18(%ebp)
c0101508:	88 45 d8             	mov    %al,-0x28(%ebp)
c010150b:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c010150f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101512:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101513:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101516:	0f b6 c0             	movzbl %al,%eax
c0101519:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010151d:	83 c2 03             	add    $0x3,%edx
c0101520:	0f b7 d2             	movzwl %dx,%edx
c0101523:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101527:	88 45 d9             	mov    %al,-0x27(%ebp)
c010152a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010152e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101532:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101533:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101536:	c1 e8 08             	shr    $0x8,%eax
c0101539:	0f b6 c0             	movzbl %al,%eax
c010153c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101540:	83 c2 04             	add    $0x4,%edx
c0101543:	0f b7 d2             	movzwl %dx,%edx
c0101546:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
c010154a:	88 45 da             	mov    %al,-0x26(%ebp)
c010154d:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101551:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0101554:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101555:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101558:	c1 e8 10             	shr    $0x10,%eax
c010155b:	0f b6 c0             	movzbl %al,%eax
c010155e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101562:	83 c2 05             	add    $0x5,%edx
c0101565:	0f b7 d2             	movzwl %dx,%edx
c0101568:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c010156c:	88 45 db             	mov    %al,-0x25(%ebp)
c010156f:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101573:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101577:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101578:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010157b:	24 01                	and    $0x1,%al
c010157d:	c0 e0 04             	shl    $0x4,%al
c0101580:	88 c2                	mov    %al,%dl
c0101582:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101585:	c1 e8 18             	shr    $0x18,%eax
c0101588:	24 0f                	and    $0xf,%al
c010158a:	08 d0                	or     %dl,%al
c010158c:	0c e0                	or     $0xe0,%al
c010158e:	0f b6 c0             	movzbl %al,%eax
c0101591:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101595:	83 c2 06             	add    $0x6,%edx
c0101598:	0f b7 d2             	movzwl %dx,%edx
c010159b:	66 89 55 e0          	mov    %dx,-0x20(%ebp)
c010159f:	88 45 dc             	mov    %al,-0x24(%ebp)
c01015a2:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01015a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01015a9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c01015aa:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01015ae:	83 c0 07             	add    $0x7,%eax
c01015b1:	0f b7 c0             	movzwl %ax,%eax
c01015b4:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c01015b8:	c6 45 dd 30          	movb   $0x30,-0x23(%ebp)
c01015bc:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01015c0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01015c4:	ee                   	out    %al,(%dx)

    int ret = 0;
c01015c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c01015cc:	eb 57                	jmp    c0101625 <ide_write_secs+0x227>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c01015ce:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01015d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01015d9:	00 
c01015da:	89 04 24             	mov    %eax,(%esp)
c01015dd:	e8 ee f7 ff ff       	call   c0100dd0 <ide_wait_ready>
c01015e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01015e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01015e9:	75 42                	jne    c010162d <ide_write_secs+0x22f>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c01015eb:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01015ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01015f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01015f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01015f8:	c7 45 cc 80 00 00 00 	movl   $0x80,-0x34(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c01015ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101602:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0101605:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0101608:	89 cb                	mov    %ecx,%ebx
c010160a:	89 de                	mov    %ebx,%esi
c010160c:	89 c1                	mov    %eax,%ecx
c010160e:	fc                   	cld    
c010160f:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101611:	89 c8                	mov    %ecx,%eax
c0101613:	89 f3                	mov    %esi,%ebx
c0101615:	89 5d d0             	mov    %ebx,-0x30(%ebp)
c0101618:	89 45 cc             	mov    %eax,-0x34(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c010161b:	ff 4d 14             	decl   0x14(%ebp)
c010161e:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101625:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101629:	75 a3                	jne    c01015ce <ide_write_secs+0x1d0>
c010162b:	eb 01                	jmp    c010162e <ide_write_secs+0x230>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c010162d:	90                   	nop
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c010162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101631:	83 c4 50             	add    $0x50,%esp
c0101634:	5b                   	pop    %ebx
c0101635:	5e                   	pop    %esi
c0101636:	5d                   	pop    %ebp
c0101637:	c3                   	ret    

c0101638 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0101638:	55                   	push   %ebp
c0101639:	89 e5                	mov    %esp,%ebp
c010163b:	83 ec 28             	sub    $0x28,%esp
c010163e:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0101644:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101648:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c010164c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101650:	ee                   	out    %al,(%dx)
c0101651:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c0101657:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c010165b:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c010165f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101662:	ee                   	out    %al,(%dx)
c0101663:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0101669:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c010166d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101671:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101675:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0101676:	c7 05 54 b0 12 c0 00 	movl   $0x0,0xc012b054
c010167d:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0101680:	c7 04 24 ae a4 10 c0 	movl   $0xc010a4ae,(%esp)
c0101687:	e8 1d ec ff ff       	call   c01002a9 <cprintf>
    pic_enable(IRQ_TIMER);
c010168c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0101693:	e8 1e 09 00 00       	call   c0101fb6 <pic_enable>
}
c0101698:	90                   	nop
c0101699:	c9                   	leave  
c010169a:	c3                   	ret    

c010169b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010169b:	55                   	push   %ebp
c010169c:	89 e5                	mov    %esp,%ebp
c010169e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01016a1:	9c                   	pushf  
c01016a2:	58                   	pop    %eax
c01016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01016a9:	25 00 02 00 00       	and    $0x200,%eax
c01016ae:	85 c0                	test   %eax,%eax
c01016b0:	74 0c                	je     c01016be <__intr_save+0x23>
        intr_disable();
c01016b2:	e8 6c 0a 00 00       	call   c0102123 <intr_disable>
        return 1;
c01016b7:	b8 01 00 00 00       	mov    $0x1,%eax
c01016bc:	eb 05                	jmp    c01016c3 <__intr_save+0x28>
    }
    return 0;
c01016be:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01016c3:	c9                   	leave  
c01016c4:	c3                   	ret    

c01016c5 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01016c5:	55                   	push   %ebp
c01016c6:	89 e5                	mov    %esp,%ebp
c01016c8:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01016cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01016cf:	74 05                	je     c01016d6 <__intr_restore+0x11>
        intr_enable();
c01016d1:	e8 46 0a 00 00       	call   c010211c <intr_enable>
    }
}
c01016d6:	90                   	nop
c01016d7:	c9                   	leave  
c01016d8:	c3                   	ret    

c01016d9 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c01016d9:	55                   	push   %ebp
c01016da:	89 e5                	mov    %esp,%ebp
c01016dc:	83 ec 10             	sub    $0x10,%esp
c01016df:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016e5:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01016e9:	89 c2                	mov    %eax,%edx
c01016eb:	ec                   	in     (%dx),%al
c01016ec:	88 45 f4             	mov    %al,-0xc(%ebp)
c01016ef:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c01016f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016f8:	89 c2                	mov    %eax,%edx
c01016fa:	ec                   	in     (%dx),%al
c01016fb:	88 45 f5             	mov    %al,-0xb(%ebp)
c01016fe:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0101704:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101708:	89 c2                	mov    %eax,%edx
c010170a:	ec                   	in     (%dx),%al
c010170b:	88 45 f6             	mov    %al,-0xa(%ebp)
c010170e:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c0101714:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101717:	89 c2                	mov    %eax,%edx
c0101719:	ec                   	in     (%dx),%al
c010171a:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c010171d:	90                   	nop
c010171e:	c9                   	leave  
c010171f:	c3                   	ret    

c0101720 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0101720:	55                   	push   %ebp
c0101721:	89 e5                	mov    %esp,%ebp
c0101723:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0101726:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c010172d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101730:	0f b7 00             	movzwl (%eax),%eax
c0101733:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0101737:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010173a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c010173f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101742:	0f b7 00             	movzwl (%eax),%eax
c0101745:	0f b7 c0             	movzwl %ax,%eax
c0101748:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c010174d:	74 12                	je     c0101761 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c010174f:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0101756:	66 c7 05 26 85 12 c0 	movw   $0x3b4,0xc0128526
c010175d:	b4 03 
c010175f:	eb 13                	jmp    c0101774 <cga_init+0x54>
    } else {
        *cp = was;
c0101761:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101764:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101768:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c010176b:	66 c7 05 26 85 12 c0 	movw   $0x3d4,0xc0128526
c0101772:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0101774:	0f b7 05 26 85 12 c0 	movzwl 0xc0128526,%eax
c010177b:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c010177f:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101783:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101787:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010178a:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c010178b:	0f b7 05 26 85 12 c0 	movzwl 0xc0128526,%eax
c0101792:	40                   	inc    %eax
c0101793:	0f b7 c0             	movzwl %ax,%eax
c0101796:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010179a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010179e:	89 c2                	mov    %eax,%edx
c01017a0:	ec                   	in     (%dx),%al
c01017a1:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01017a4:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01017a8:	0f b6 c0             	movzbl %al,%eax
c01017ab:	c1 e0 08             	shl    $0x8,%eax
c01017ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c01017b1:	0f b7 05 26 85 12 c0 	movzwl 0xc0128526,%eax
c01017b8:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c01017bc:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017c0:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01017c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01017c7:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c01017c8:	0f b7 05 26 85 12 c0 	movzwl 0xc0128526,%eax
c01017cf:	40                   	inc    %eax
c01017d0:	0f b7 c0             	movzwl %ax,%eax
c01017d3:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017d7:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c01017db:	89 c2                	mov    %eax,%edx
c01017dd:	ec                   	in     (%dx),%al
c01017de:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c01017e1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017e5:	0f b6 c0             	movzbl %al,%eax
c01017e8:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c01017eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017ee:	a3 20 85 12 c0       	mov    %eax,0xc0128520
    crt_pos = pos;
c01017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01017f6:	0f b7 c0             	movzwl %ax,%eax
c01017f9:	66 a3 24 85 12 c0    	mov    %ax,0xc0128524
}
c01017ff:	90                   	nop
c0101800:	c9                   	leave  
c0101801:	c3                   	ret    

c0101802 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0101802:	55                   	push   %ebp
c0101803:	89 e5                	mov    %esp,%ebp
c0101805:	83 ec 38             	sub    $0x38,%esp
c0101808:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c010180e:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101812:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101816:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010181a:	ee                   	out    %al,(%dx)
c010181b:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c0101821:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c0101825:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101829:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010182c:	ee                   	out    %al,(%dx)
c010182d:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0101833:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c0101837:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c010183b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010183f:	ee                   	out    %al,(%dx)
c0101840:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c0101846:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c010184a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010184e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101851:	ee                   	out    %al,(%dx)
c0101852:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c0101858:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c010185c:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0101860:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101864:	ee                   	out    %al,(%dx)
c0101865:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c010186b:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c010186f:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101873:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101876:	ee                   	out    %al,(%dx)
c0101877:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c010187d:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c0101881:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0101885:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101889:	ee                   	out    %al,(%dx)
c010188a:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101890:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101893:	89 c2                	mov    %eax,%edx
c0101895:	ec                   	in     (%dx),%al
c0101896:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c0101899:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010189d:	3c ff                	cmp    $0xff,%al
c010189f:	0f 95 c0             	setne  %al
c01018a2:	0f b6 c0             	movzbl %al,%eax
c01018a5:	a3 28 85 12 c0       	mov    %eax,0xc0128528
c01018aa:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01018b0:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01018b4:	89 c2                	mov    %eax,%edx
c01018b6:	ec                   	in     (%dx),%al
c01018b7:	88 45 e2             	mov    %al,-0x1e(%ebp)
c01018ba:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c01018c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018c3:	89 c2                	mov    %eax,%edx
c01018c5:	ec                   	in     (%dx),%al
c01018c6:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01018c9:	a1 28 85 12 c0       	mov    0xc0128528,%eax
c01018ce:	85 c0                	test   %eax,%eax
c01018d0:	74 0c                	je     c01018de <serial_init+0xdc>
        pic_enable(IRQ_COM1);
c01018d2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01018d9:	e8 d8 06 00 00       	call   c0101fb6 <pic_enable>
    }
}
c01018de:	90                   	nop
c01018df:	c9                   	leave  
c01018e0:	c3                   	ret    

c01018e1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01018e1:	55                   	push   %ebp
c01018e2:	89 e5                	mov    %esp,%ebp
c01018e4:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01018e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018ee:	eb 08                	jmp    c01018f8 <lpt_putc_sub+0x17>
        delay();
c01018f0:	e8 e4 fd ff ff       	call   c01016d9 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01018f5:	ff 45 fc             	incl   -0x4(%ebp)
c01018f8:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c01018fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101901:	89 c2                	mov    %eax,%edx
c0101903:	ec                   	in     (%dx),%al
c0101904:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c0101907:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010190b:	84 c0                	test   %al,%al
c010190d:	78 09                	js     c0101918 <lpt_putc_sub+0x37>
c010190f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101916:	7e d8                	jle    c01018f0 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101918:	8b 45 08             	mov    0x8(%ebp),%eax
c010191b:	0f b6 c0             	movzbl %al,%eax
c010191e:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c0101924:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101927:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c010192b:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010192e:	ee                   	out    %al,(%dx)
c010192f:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101935:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101939:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010193d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101941:	ee                   	out    %al,(%dx)
c0101942:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c0101948:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c010194c:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c0101950:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101954:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101955:	90                   	nop
c0101956:	c9                   	leave  
c0101957:	c3                   	ret    

c0101958 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101958:	55                   	push   %ebp
c0101959:	89 e5                	mov    %esp,%ebp
c010195b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010195e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101962:	74 0d                	je     c0101971 <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101964:	8b 45 08             	mov    0x8(%ebp),%eax
c0101967:	89 04 24             	mov    %eax,(%esp)
c010196a:	e8 72 ff ff ff       	call   c01018e1 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010196f:	eb 24                	jmp    c0101995 <lpt_putc+0x3d>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c0101971:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101978:	e8 64 ff ff ff       	call   c01018e1 <lpt_putc_sub>
        lpt_putc_sub(' ');
c010197d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101984:	e8 58 ff ff ff       	call   c01018e1 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101989:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101990:	e8 4c ff ff ff       	call   c01018e1 <lpt_putc_sub>
    }
}
c0101995:	90                   	nop
c0101996:	c9                   	leave  
c0101997:	c3                   	ret    

c0101998 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101998:	55                   	push   %ebp
c0101999:	89 e5                	mov    %esp,%ebp
c010199b:	53                   	push   %ebx
c010199c:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010199f:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a2:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01019a7:	85 c0                	test   %eax,%eax
c01019a9:	75 07                	jne    c01019b2 <cga_putc+0x1a>
        c |= 0x0700;
c01019ab:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01019b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b5:	0f b6 c0             	movzbl %al,%eax
c01019b8:	83 f8 0a             	cmp    $0xa,%eax
c01019bb:	74 54                	je     c0101a11 <cga_putc+0x79>
c01019bd:	83 f8 0d             	cmp    $0xd,%eax
c01019c0:	74 62                	je     c0101a24 <cga_putc+0x8c>
c01019c2:	83 f8 08             	cmp    $0x8,%eax
c01019c5:	0f 85 93 00 00 00    	jne    c0101a5e <cga_putc+0xc6>
    case '\b':
        if (crt_pos > 0) {
c01019cb:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c01019d2:	85 c0                	test   %eax,%eax
c01019d4:	0f 84 ae 00 00 00    	je     c0101a88 <cga_putc+0xf0>
            crt_pos --;
c01019da:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c01019e1:	48                   	dec    %eax
c01019e2:	0f b7 c0             	movzwl %ax,%eax
c01019e5:	66 a3 24 85 12 c0    	mov    %ax,0xc0128524
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01019eb:	a1 20 85 12 c0       	mov    0xc0128520,%eax
c01019f0:	0f b7 15 24 85 12 c0 	movzwl 0xc0128524,%edx
c01019f7:	01 d2                	add    %edx,%edx
c01019f9:	01 c2                	add    %eax,%edx
c01019fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01019fe:	98                   	cwtl   
c01019ff:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101a04:	98                   	cwtl   
c0101a05:	83 c8 20             	or     $0x20,%eax
c0101a08:	98                   	cwtl   
c0101a09:	0f b7 c0             	movzwl %ax,%eax
c0101a0c:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101a0f:	eb 77                	jmp    c0101a88 <cga_putc+0xf0>
    case '\n':
        crt_pos += CRT_COLS;
c0101a11:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c0101a18:	83 c0 50             	add    $0x50,%eax
c0101a1b:	0f b7 c0             	movzwl %ax,%eax
c0101a1e:	66 a3 24 85 12 c0    	mov    %ax,0xc0128524
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101a24:	0f b7 1d 24 85 12 c0 	movzwl 0xc0128524,%ebx
c0101a2b:	0f b7 0d 24 85 12 c0 	movzwl 0xc0128524,%ecx
c0101a32:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c0101a37:	89 c8                	mov    %ecx,%eax
c0101a39:	f7 e2                	mul    %edx
c0101a3b:	c1 ea 06             	shr    $0x6,%edx
c0101a3e:	89 d0                	mov    %edx,%eax
c0101a40:	c1 e0 02             	shl    $0x2,%eax
c0101a43:	01 d0                	add    %edx,%eax
c0101a45:	c1 e0 04             	shl    $0x4,%eax
c0101a48:	29 c1                	sub    %eax,%ecx
c0101a4a:	89 c8                	mov    %ecx,%eax
c0101a4c:	0f b7 c0             	movzwl %ax,%eax
c0101a4f:	29 c3                	sub    %eax,%ebx
c0101a51:	89 d8                	mov    %ebx,%eax
c0101a53:	0f b7 c0             	movzwl %ax,%eax
c0101a56:	66 a3 24 85 12 c0    	mov    %ax,0xc0128524
        break;
c0101a5c:	eb 2b                	jmp    c0101a89 <cga_putc+0xf1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101a5e:	8b 0d 20 85 12 c0    	mov    0xc0128520,%ecx
c0101a64:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c0101a6b:	8d 50 01             	lea    0x1(%eax),%edx
c0101a6e:	0f b7 d2             	movzwl %dx,%edx
c0101a71:	66 89 15 24 85 12 c0 	mov    %dx,0xc0128524
c0101a78:	01 c0                	add    %eax,%eax
c0101a7a:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101a7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a80:	0f b7 c0             	movzwl %ax,%eax
c0101a83:	66 89 02             	mov    %ax,(%edx)
        break;
c0101a86:	eb 01                	jmp    c0101a89 <cga_putc+0xf1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c0101a88:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101a89:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c0101a90:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101a95:	76 5d                	jbe    c0101af4 <cga_putc+0x15c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101a97:	a1 20 85 12 c0       	mov    0xc0128520,%eax
c0101a9c:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101aa2:	a1 20 85 12 c0       	mov    0xc0128520,%eax
c0101aa7:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101aae:	00 
c0101aaf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101ab3:	89 04 24             	mov    %eax,(%esp)
c0101ab6:	e8 1e 7d 00 00       	call   c01097d9 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101abb:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101ac2:	eb 14                	jmp    c0101ad8 <cga_putc+0x140>
            crt_buf[i] = 0x0700 | ' ';
c0101ac4:	a1 20 85 12 c0       	mov    0xc0128520,%eax
c0101ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101acc:	01 d2                	add    %edx,%edx
c0101ace:	01 d0                	add    %edx,%eax
c0101ad0:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101ad5:	ff 45 f4             	incl   -0xc(%ebp)
c0101ad8:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101adf:	7e e3                	jle    c0101ac4 <cga_putc+0x12c>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101ae1:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c0101ae8:	83 e8 50             	sub    $0x50,%eax
c0101aeb:	0f b7 c0             	movzwl %ax,%eax
c0101aee:	66 a3 24 85 12 c0    	mov    %ax,0xc0128524
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101af4:	0f b7 05 26 85 12 c0 	movzwl 0xc0128526,%eax
c0101afb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101aff:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c0101b03:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c0101b07:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101b0b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101b0c:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c0101b13:	c1 e8 08             	shr    $0x8,%eax
c0101b16:	0f b7 c0             	movzwl %ax,%eax
c0101b19:	0f b6 c0             	movzbl %al,%eax
c0101b1c:	0f b7 15 26 85 12 c0 	movzwl 0xc0128526,%edx
c0101b23:	42                   	inc    %edx
c0101b24:	0f b7 d2             	movzwl %dx,%edx
c0101b27:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c0101b2b:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101b2e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101b32:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101b35:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101b36:	0f b7 05 26 85 12 c0 	movzwl 0xc0128526,%eax
c0101b3d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b41:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c0101b45:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101b49:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101b4d:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101b4e:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c0101b55:	0f b6 c0             	movzbl %al,%eax
c0101b58:	0f b7 15 26 85 12 c0 	movzwl 0xc0128526,%edx
c0101b5f:	42                   	inc    %edx
c0101b60:	0f b7 d2             	movzwl %dx,%edx
c0101b63:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101b67:	88 45 eb             	mov    %al,-0x15(%ebp)
c0101b6a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101b6e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101b71:	ee                   	out    %al,(%dx)
}
c0101b72:	90                   	nop
c0101b73:	83 c4 24             	add    $0x24,%esp
c0101b76:	5b                   	pop    %ebx
c0101b77:	5d                   	pop    %ebp
c0101b78:	c3                   	ret    

c0101b79 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101b79:	55                   	push   %ebp
c0101b7a:	89 e5                	mov    %esp,%ebp
c0101b7c:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101b86:	eb 08                	jmp    c0101b90 <serial_putc_sub+0x17>
        delay();
c0101b88:	e8 4c fb ff ff       	call   c01016d9 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b8d:	ff 45 fc             	incl   -0x4(%ebp)
c0101b90:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101b96:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b99:	89 c2                	mov    %eax,%edx
c0101b9b:	ec                   	in     (%dx),%al
c0101b9c:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101b9f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101ba3:	0f b6 c0             	movzbl %al,%eax
c0101ba6:	83 e0 20             	and    $0x20,%eax
c0101ba9:	85 c0                	test   %eax,%eax
c0101bab:	75 09                	jne    c0101bb6 <serial_putc_sub+0x3d>
c0101bad:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101bb4:	7e d2                	jle    c0101b88 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101bb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb9:	0f b6 c0             	movzbl %al,%eax
c0101bbc:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c0101bc2:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101bc5:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c0101bc9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101bcd:	ee                   	out    %al,(%dx)
}
c0101bce:	90                   	nop
c0101bcf:	c9                   	leave  
c0101bd0:	c3                   	ret    

c0101bd1 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101bd1:	55                   	push   %ebp
c0101bd2:	89 e5                	mov    %esp,%ebp
c0101bd4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101bd7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101bdb:	74 0d                	je     c0101bea <serial_putc+0x19>
        serial_putc_sub(c);
c0101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be0:	89 04 24             	mov    %eax,(%esp)
c0101be3:	e8 91 ff ff ff       	call   c0101b79 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101be8:	eb 24                	jmp    c0101c0e <serial_putc+0x3d>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c0101bea:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101bf1:	e8 83 ff ff ff       	call   c0101b79 <serial_putc_sub>
        serial_putc_sub(' ');
c0101bf6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101bfd:	e8 77 ff ff ff       	call   c0101b79 <serial_putc_sub>
        serial_putc_sub('\b');
c0101c02:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101c09:	e8 6b ff ff ff       	call   c0101b79 <serial_putc_sub>
    }
}
c0101c0e:	90                   	nop
c0101c0f:	c9                   	leave  
c0101c10:	c3                   	ret    

c0101c11 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101c11:	55                   	push   %ebp
c0101c12:	89 e5                	mov    %esp,%ebp
c0101c14:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101c17:	eb 33                	jmp    c0101c4c <cons_intr+0x3b>
        if (c != 0) {
c0101c19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c1d:	74 2d                	je     c0101c4c <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101c1f:	a1 44 87 12 c0       	mov    0xc0128744,%eax
c0101c24:	8d 50 01             	lea    0x1(%eax),%edx
c0101c27:	89 15 44 87 12 c0    	mov    %edx,0xc0128744
c0101c2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101c30:	88 90 40 85 12 c0    	mov    %dl,-0x3fed7ac0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101c36:	a1 44 87 12 c0       	mov    0xc0128744,%eax
c0101c3b:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101c40:	75 0a                	jne    c0101c4c <cons_intr+0x3b>
                cons.wpos = 0;
c0101c42:	c7 05 44 87 12 c0 00 	movl   $0x0,0xc0128744
c0101c49:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101c4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4f:	ff d0                	call   *%eax
c0101c51:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c54:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101c58:	75 bf                	jne    c0101c19 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101c5a:	90                   	nop
c0101c5b:	c9                   	leave  
c0101c5c:	c3                   	ret    

c0101c5d <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101c5d:	55                   	push   %ebp
c0101c5e:	89 e5                	mov    %esp,%ebp
c0101c60:	83 ec 10             	sub    $0x10,%esp
c0101c63:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c69:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c6c:	89 c2                	mov    %eax,%edx
c0101c6e:	ec                   	in     (%dx),%al
c0101c6f:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101c72:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101c76:	0f b6 c0             	movzbl %al,%eax
c0101c79:	83 e0 01             	and    $0x1,%eax
c0101c7c:	85 c0                	test   %eax,%eax
c0101c7e:	75 07                	jne    c0101c87 <serial_proc_data+0x2a>
        return -1;
c0101c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101c85:	eb 2a                	jmp    c0101cb1 <serial_proc_data+0x54>
c0101c87:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c8d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101c91:	89 c2                	mov    %eax,%edx
c0101c93:	ec                   	in     (%dx),%al
c0101c94:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c0101c97:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101c9b:	0f b6 c0             	movzbl %al,%eax
c0101c9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101ca1:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101ca5:	75 07                	jne    c0101cae <serial_proc_data+0x51>
        c = '\b';
c0101ca7:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101cb1:	c9                   	leave  
c0101cb2:	c3                   	ret    

c0101cb3 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101cb3:	55                   	push   %ebp
c0101cb4:	89 e5                	mov    %esp,%ebp
c0101cb6:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101cb9:	a1 28 85 12 c0       	mov    0xc0128528,%eax
c0101cbe:	85 c0                	test   %eax,%eax
c0101cc0:	74 0c                	je     c0101cce <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101cc2:	c7 04 24 5d 1c 10 c0 	movl   $0xc0101c5d,(%esp)
c0101cc9:	e8 43 ff ff ff       	call   c0101c11 <cons_intr>
    }
}
c0101cce:	90                   	nop
c0101ccf:	c9                   	leave  
c0101cd0:	c3                   	ret    

c0101cd1 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101cd1:	55                   	push   %ebp
c0101cd2:	89 e5                	mov    %esp,%ebp
c0101cd4:	83 ec 28             	sub    $0x28,%esp
c0101cd7:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101ce0:	89 c2                	mov    %eax,%edx
c0101ce2:	ec                   	in     (%dx),%al
c0101ce3:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101ce6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101cea:	0f b6 c0             	movzbl %al,%eax
c0101ced:	83 e0 01             	and    $0x1,%eax
c0101cf0:	85 c0                	test   %eax,%eax
c0101cf2:	75 0a                	jne    c0101cfe <kbd_proc_data+0x2d>
        return -1;
c0101cf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101cf9:	e9 56 01 00 00       	jmp    c0101e54 <kbd_proc_data+0x183>
c0101cfe:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d07:	89 c2                	mov    %eax,%edx
c0101d09:	ec                   	in     (%dx),%al
c0101d0a:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c0101d0d:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101d11:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101d14:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101d18:	75 17                	jne    c0101d31 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c0101d1a:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101d1f:	83 c8 40             	or     $0x40,%eax
c0101d22:	a3 48 87 12 c0       	mov    %eax,0xc0128748
        return 0;
c0101d27:	b8 00 00 00 00       	mov    $0x0,%eax
c0101d2c:	e9 23 01 00 00       	jmp    c0101e54 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c0101d31:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d35:	84 c0                	test   %al,%al
c0101d37:	79 45                	jns    c0101d7e <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101d39:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101d3e:	83 e0 40             	and    $0x40,%eax
c0101d41:	85 c0                	test   %eax,%eax
c0101d43:	75 08                	jne    c0101d4d <kbd_proc_data+0x7c>
c0101d45:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d49:	24 7f                	and    $0x7f,%al
c0101d4b:	eb 04                	jmp    c0101d51 <kbd_proc_data+0x80>
c0101d4d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d51:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101d54:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d58:	0f b6 80 40 50 12 c0 	movzbl -0x3fedafc0(%eax),%eax
c0101d5f:	0c 40                	or     $0x40,%al
c0101d61:	0f b6 c0             	movzbl %al,%eax
c0101d64:	f7 d0                	not    %eax
c0101d66:	89 c2                	mov    %eax,%edx
c0101d68:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101d6d:	21 d0                	and    %edx,%eax
c0101d6f:	a3 48 87 12 c0       	mov    %eax,0xc0128748
        return 0;
c0101d74:	b8 00 00 00 00       	mov    $0x0,%eax
c0101d79:	e9 d6 00 00 00       	jmp    c0101e54 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c0101d7e:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101d83:	83 e0 40             	and    $0x40,%eax
c0101d86:	85 c0                	test   %eax,%eax
c0101d88:	74 11                	je     c0101d9b <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101d8a:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101d8e:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101d93:	83 e0 bf             	and    $0xffffffbf,%eax
c0101d96:	a3 48 87 12 c0       	mov    %eax,0xc0128748
    }

    shift |= shiftcode[data];
c0101d9b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d9f:	0f b6 80 40 50 12 c0 	movzbl -0x3fedafc0(%eax),%eax
c0101da6:	0f b6 d0             	movzbl %al,%edx
c0101da9:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101dae:	09 d0                	or     %edx,%eax
c0101db0:	a3 48 87 12 c0       	mov    %eax,0xc0128748
    shift ^= togglecode[data];
c0101db5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101db9:	0f b6 80 40 51 12 c0 	movzbl -0x3fedaec0(%eax),%eax
c0101dc0:	0f b6 d0             	movzbl %al,%edx
c0101dc3:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101dc8:	31 d0                	xor    %edx,%eax
c0101dca:	a3 48 87 12 c0       	mov    %eax,0xc0128748

    c = charcode[shift & (CTL | SHIFT)][data];
c0101dcf:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101dd4:	83 e0 03             	and    $0x3,%eax
c0101dd7:	8b 14 85 40 55 12 c0 	mov    -0x3fedaac0(,%eax,4),%edx
c0101dde:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101de2:	01 d0                	add    %edx,%eax
c0101de4:	0f b6 00             	movzbl (%eax),%eax
c0101de7:	0f b6 c0             	movzbl %al,%eax
c0101dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101ded:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101df2:	83 e0 08             	and    $0x8,%eax
c0101df5:	85 c0                	test   %eax,%eax
c0101df7:	74 22                	je     c0101e1b <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c0101df9:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101dfd:	7e 0c                	jle    c0101e0b <kbd_proc_data+0x13a>
c0101dff:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101e03:	7f 06                	jg     c0101e0b <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c0101e05:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101e09:	eb 10                	jmp    c0101e1b <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c0101e0b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101e0f:	7e 0a                	jle    c0101e1b <kbd_proc_data+0x14a>
c0101e11:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101e15:	7f 04                	jg     c0101e1b <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c0101e17:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101e1b:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101e20:	f7 d0                	not    %eax
c0101e22:	83 e0 06             	and    $0x6,%eax
c0101e25:	85 c0                	test   %eax,%eax
c0101e27:	75 28                	jne    c0101e51 <kbd_proc_data+0x180>
c0101e29:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101e30:	75 1f                	jne    c0101e51 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c0101e32:	c7 04 24 c9 a4 10 c0 	movl   $0xc010a4c9,(%esp)
c0101e39:	e8 6b e4 ff ff       	call   c01002a9 <cprintf>
c0101e3e:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c0101e44:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e48:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101e4c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101e50:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101e54:	c9                   	leave  
c0101e55:	c3                   	ret    

c0101e56 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101e56:	55                   	push   %ebp
c0101e57:	89 e5                	mov    %esp,%ebp
c0101e59:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101e5c:	c7 04 24 d1 1c 10 c0 	movl   $0xc0101cd1,(%esp)
c0101e63:	e8 a9 fd ff ff       	call   c0101c11 <cons_intr>
}
c0101e68:	90                   	nop
c0101e69:	c9                   	leave  
c0101e6a:	c3                   	ret    

c0101e6b <kbd_init>:

static void
kbd_init(void) {
c0101e6b:	55                   	push   %ebp
c0101e6c:	89 e5                	mov    %esp,%ebp
c0101e6e:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101e71:	e8 e0 ff ff ff       	call   c0101e56 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101e76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101e7d:	e8 34 01 00 00       	call   c0101fb6 <pic_enable>
}
c0101e82:	90                   	nop
c0101e83:	c9                   	leave  
c0101e84:	c3                   	ret    

c0101e85 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101e85:	55                   	push   %ebp
c0101e86:	89 e5                	mov    %esp,%ebp
c0101e88:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101e8b:	e8 90 f8 ff ff       	call   c0101720 <cga_init>
    serial_init();
c0101e90:	e8 6d f9 ff ff       	call   c0101802 <serial_init>
    kbd_init();
c0101e95:	e8 d1 ff ff ff       	call   c0101e6b <kbd_init>
    if (!serial_exists) {
c0101e9a:	a1 28 85 12 c0       	mov    0xc0128528,%eax
c0101e9f:	85 c0                	test   %eax,%eax
c0101ea1:	75 0c                	jne    c0101eaf <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101ea3:	c7 04 24 d5 a4 10 c0 	movl   $0xc010a4d5,(%esp)
c0101eaa:	e8 fa e3 ff ff       	call   c01002a9 <cprintf>
    }
}
c0101eaf:	90                   	nop
c0101eb0:	c9                   	leave  
c0101eb1:	c3                   	ret    

c0101eb2 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101eb2:	55                   	push   %ebp
c0101eb3:	89 e5                	mov    %esp,%ebp
c0101eb5:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101eb8:	e8 de f7 ff ff       	call   c010169b <__intr_save>
c0101ebd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101ec0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec3:	89 04 24             	mov    %eax,(%esp)
c0101ec6:	e8 8d fa ff ff       	call   c0101958 <lpt_putc>
        cga_putc(c);
c0101ecb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ece:	89 04 24             	mov    %eax,(%esp)
c0101ed1:	e8 c2 fa ff ff       	call   c0101998 <cga_putc>
        serial_putc(c);
c0101ed6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed9:	89 04 24             	mov    %eax,(%esp)
c0101edc:	e8 f0 fc ff ff       	call   c0101bd1 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ee4:	89 04 24             	mov    %eax,(%esp)
c0101ee7:	e8 d9 f7 ff ff       	call   c01016c5 <__intr_restore>
}
c0101eec:	90                   	nop
c0101eed:	c9                   	leave  
c0101eee:	c3                   	ret    

c0101eef <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101eef:	55                   	push   %ebp
c0101ef0:	89 e5                	mov    %esp,%ebp
c0101ef2:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101ef5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101efc:	e8 9a f7 ff ff       	call   c010169b <__intr_save>
c0101f01:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101f04:	e8 aa fd ff ff       	call   c0101cb3 <serial_intr>
        kbd_intr();
c0101f09:	e8 48 ff ff ff       	call   c0101e56 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101f0e:	8b 15 40 87 12 c0    	mov    0xc0128740,%edx
c0101f14:	a1 44 87 12 c0       	mov    0xc0128744,%eax
c0101f19:	39 c2                	cmp    %eax,%edx
c0101f1b:	74 31                	je     c0101f4e <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101f1d:	a1 40 87 12 c0       	mov    0xc0128740,%eax
c0101f22:	8d 50 01             	lea    0x1(%eax),%edx
c0101f25:	89 15 40 87 12 c0    	mov    %edx,0xc0128740
c0101f2b:	0f b6 80 40 85 12 c0 	movzbl -0x3fed7ac0(%eax),%eax
c0101f32:	0f b6 c0             	movzbl %al,%eax
c0101f35:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101f38:	a1 40 87 12 c0       	mov    0xc0128740,%eax
c0101f3d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101f42:	75 0a                	jne    c0101f4e <cons_getc+0x5f>
                cons.rpos = 0;
c0101f44:	c7 05 40 87 12 c0 00 	movl   $0x0,0xc0128740
c0101f4b:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f51:	89 04 24             	mov    %eax,(%esp)
c0101f54:	e8 6c f7 ff ff       	call   c01016c5 <__intr_restore>
    return c;
c0101f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f5c:	c9                   	leave  
c0101f5d:	c3                   	ret    

c0101f5e <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f5e:	55                   	push   %ebp
c0101f5f:	89 e5                	mov    %esp,%ebp
c0101f61:	83 ec 14             	sub    $0x14,%esp
c0101f64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f67:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101f6e:	66 a3 50 55 12 c0    	mov    %ax,0xc0125550
    if (did_init) {
c0101f74:	a1 4c 87 12 c0       	mov    0xc012874c,%eax
c0101f79:	85 c0                	test   %eax,%eax
c0101f7b:	74 36                	je     c0101fb3 <pic_setmask+0x55>
        outb(IO_PIC1 + 1, mask);
c0101f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101f80:	0f b6 c0             	movzbl %al,%eax
c0101f83:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f89:	88 45 fa             	mov    %al,-0x6(%ebp)
c0101f8c:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c0101f90:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f94:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f95:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f99:	c1 e8 08             	shr    $0x8,%eax
c0101f9c:	0f b7 c0             	movzwl %ax,%eax
c0101f9f:	0f b6 c0             	movzbl %al,%eax
c0101fa2:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101fa8:	88 45 fb             	mov    %al,-0x5(%ebp)
c0101fab:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101faf:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101fb2:	ee                   	out    %al,(%dx)
    }
}
c0101fb3:	90                   	nop
c0101fb4:	c9                   	leave  
c0101fb5:	c3                   	ret    

c0101fb6 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101fb6:	55                   	push   %ebp
c0101fb7:	89 e5                	mov    %esp,%ebp
c0101fb9:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101fbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fbf:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fc4:	88 c1                	mov    %al,%cl
c0101fc6:	d3 e2                	shl    %cl,%edx
c0101fc8:	89 d0                	mov    %edx,%eax
c0101fca:	98                   	cwtl   
c0101fcb:	f7 d0                	not    %eax
c0101fcd:	0f bf d0             	movswl %ax,%edx
c0101fd0:	0f b7 05 50 55 12 c0 	movzwl 0xc0125550,%eax
c0101fd7:	98                   	cwtl   
c0101fd8:	21 d0                	and    %edx,%eax
c0101fda:	98                   	cwtl   
c0101fdb:	0f b7 c0             	movzwl %ax,%eax
c0101fde:	89 04 24             	mov    %eax,(%esp)
c0101fe1:	e8 78 ff ff ff       	call   c0101f5e <pic_setmask>
}
c0101fe6:	90                   	nop
c0101fe7:	c9                   	leave  
c0101fe8:	c3                   	ret    

c0101fe9 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fe9:	55                   	push   %ebp
c0101fea:	89 e5                	mov    %esp,%ebp
c0101fec:	83 ec 34             	sub    $0x34,%esp
    did_init = 1;
c0101fef:	c7 05 4c 87 12 c0 01 	movl   $0x1,0xc012874c
c0101ff6:	00 00 00 
c0101ff9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fff:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c0102003:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c0102007:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010200b:	ee                   	out    %al,(%dx)
c010200c:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0102012:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c0102016:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c010201a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010201d:	ee                   	out    %al,(%dx)
c010201e:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c0102024:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c0102028:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c010202c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102030:	ee                   	out    %al,(%dx)
c0102031:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c0102037:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c010203b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010203f:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102042:	ee                   	out    %al,(%dx)
c0102043:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c0102049:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c010204d:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0102051:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102055:	ee                   	out    %al,(%dx)
c0102056:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c010205c:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0102060:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0102064:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102067:	ee                   	out    %al,(%dx)
c0102068:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c010206e:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c0102072:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0102076:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010207a:	ee                   	out    %al,(%dx)
c010207b:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c0102081:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c0102085:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102089:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010208c:	ee                   	out    %al,(%dx)
c010208d:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0102093:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c0102097:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c010209b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010209f:	ee                   	out    %al,(%dx)
c01020a0:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c01020a6:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c01020aa:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01020ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01020b1:	ee                   	out    %al,(%dx)
c01020b2:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c01020b8:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c01020bc:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c01020c0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01020c4:	ee                   	out    %al,(%dx)
c01020c5:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c01020cb:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c01020cf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01020d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01020d6:	ee                   	out    %al,(%dx)
c01020d7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01020dd:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c01020e1:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c01020e5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01020e9:	ee                   	out    %al,(%dx)
c01020ea:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c01020f0:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c01020f4:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01020f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01020fb:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020fc:	0f b7 05 50 55 12 c0 	movzwl 0xc0125550,%eax
c0102103:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0102108:	74 0f                	je     c0102119 <pic_init+0x130>
        pic_setmask(irq_mask);
c010210a:	0f b7 05 50 55 12 c0 	movzwl 0xc0125550,%eax
c0102111:	89 04 24             	mov    %eax,(%esp)
c0102114:	e8 45 fe ff ff       	call   c0101f5e <pic_setmask>
    }
}
c0102119:	90                   	nop
c010211a:	c9                   	leave  
c010211b:	c3                   	ret    

c010211c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010211c:	55                   	push   %ebp
c010211d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010211f:	fb                   	sti    
    sti();
}
c0102120:	90                   	nop
c0102121:	5d                   	pop    %ebp
c0102122:	c3                   	ret    

c0102123 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0102123:	55                   	push   %ebp
c0102124:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0102126:	fa                   	cli    
    cli();
}
c0102127:	90                   	nop
c0102128:	5d                   	pop    %ebp
c0102129:	c3                   	ret    

c010212a <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010212a:	55                   	push   %ebp
c010212b:	89 e5                	mov    %esp,%ebp
c010212d:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102130:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102137:	00 
c0102138:	c7 04 24 00 a5 10 c0 	movl   $0xc010a500,(%esp)
c010213f:	e8 65 e1 ff ff       	call   c01002a9 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0102144:	90                   	nop
c0102145:	c9                   	leave  
c0102146:	c3                   	ret    

c0102147 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102147:	55                   	push   %ebp
c0102148:	89 e5                	mov    %esp,%ebp
c010214a:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[]; //256  ISR's entry addrs
     
    uintptr_t ISR_addr = __vectors[0];
c010214d:	a1 e0 55 12 c0       	mov    0xc01255e0,%eax
c0102152:	89 45 fc             	mov    %eax,-0x4(%ebp)
    for (int i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++, ISR_addr = __vectors[i]){
c0102155:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c010215c:	e9 c3 00 00 00       	jmp    c0102224 <idt_init+0xdd>
        SETGATE(idt[i], 0, GD_KTEXT, ISR_addr, DPL_USER);                   
c0102161:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102164:	0f b7 d0             	movzwl %ax,%edx
c0102167:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010216a:	66 89 14 c5 60 87 12 	mov    %dx,-0x3fed78a0(,%eax,8)
c0102171:	c0 
c0102172:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102175:	66 c7 04 c5 62 87 12 	movw   $0x8,-0x3fed789e(,%eax,8)
c010217c:	c0 08 00 
c010217f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102182:	0f b6 14 c5 64 87 12 	movzbl -0x3fed789c(,%eax,8),%edx
c0102189:	c0 
c010218a:	80 e2 e0             	and    $0xe0,%dl
c010218d:	88 14 c5 64 87 12 c0 	mov    %dl,-0x3fed789c(,%eax,8)
c0102194:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102197:	0f b6 14 c5 64 87 12 	movzbl -0x3fed789c(,%eax,8),%edx
c010219e:	c0 
c010219f:	80 e2 1f             	and    $0x1f,%dl
c01021a2:	88 14 c5 64 87 12 c0 	mov    %dl,-0x3fed789c(,%eax,8)
c01021a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021ac:	0f b6 14 c5 65 87 12 	movzbl -0x3fed789b(,%eax,8),%edx
c01021b3:	c0 
c01021b4:	80 e2 f0             	and    $0xf0,%dl
c01021b7:	80 ca 0e             	or     $0xe,%dl
c01021ba:	88 14 c5 65 87 12 c0 	mov    %dl,-0x3fed789b(,%eax,8)
c01021c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021c4:	0f b6 14 c5 65 87 12 	movzbl -0x3fed789b(,%eax,8),%edx
c01021cb:	c0 
c01021cc:	80 e2 ef             	and    $0xef,%dl
c01021cf:	88 14 c5 65 87 12 c0 	mov    %dl,-0x3fed789b(,%eax,8)
c01021d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021d9:	0f b6 14 c5 65 87 12 	movzbl -0x3fed789b(,%eax,8),%edx
c01021e0:	c0 
c01021e1:	80 ca 60             	or     $0x60,%dl
c01021e4:	88 14 c5 65 87 12 c0 	mov    %dl,-0x3fed789b(,%eax,8)
c01021eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021ee:	0f b6 14 c5 65 87 12 	movzbl -0x3fed789b(,%eax,8),%edx
c01021f5:	c0 
c01021f6:	80 ca 80             	or     $0x80,%dl
c01021f9:	88 14 c5 65 87 12 c0 	mov    %dl,-0x3fed789b(,%eax,8)
c0102200:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102203:	c1 e8 10             	shr    $0x10,%eax
c0102206:	0f b7 d0             	movzwl %ax,%edx
c0102209:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010220c:	66 89 14 c5 66 87 12 	mov    %dx,-0x3fed789a(,%eax,8)
c0102213:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[]; //256  ISR's entry addrs
     
    uintptr_t ISR_addr = __vectors[0];
    for (int i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++, ISR_addr = __vectors[i]){
c0102214:	ff 45 f8             	incl   -0x8(%ebp)
c0102217:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010221a:	8b 04 85 e0 55 12 c0 	mov    -0x3fedaa20(,%eax,4),%eax
c0102221:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0102224:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102227:	3d ff 00 00 00       	cmp    $0xff,%eax
c010222c:	0f 86 2f ff ff ff    	jbe    c0102161 <idt_init+0x1a>
        SETGATE(idt[i], 0, GD_KTEXT, ISR_addr, DPL_USER);                   
    }
    /*开启陷阱门*/
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
c0102232:	a1 c4 57 12 c0       	mov    0xc01257c4,%eax
c0102237:	0f b7 c0             	movzwl %ax,%eax
c010223a:	66 a3 28 8b 12 c0    	mov    %ax,0xc0128b28
c0102240:	66 c7 05 2a 8b 12 c0 	movw   $0x8,0xc0128b2a
c0102247:	08 00 
c0102249:	0f b6 05 2c 8b 12 c0 	movzbl 0xc0128b2c,%eax
c0102250:	24 e0                	and    $0xe0,%al
c0102252:	a2 2c 8b 12 c0       	mov    %al,0xc0128b2c
c0102257:	0f b6 05 2c 8b 12 c0 	movzbl 0xc0128b2c,%eax
c010225e:	24 1f                	and    $0x1f,%al
c0102260:	a2 2c 8b 12 c0       	mov    %al,0xc0128b2c
c0102265:	0f b6 05 2d 8b 12 c0 	movzbl 0xc0128b2d,%eax
c010226c:	0c 0f                	or     $0xf,%al
c010226e:	a2 2d 8b 12 c0       	mov    %al,0xc0128b2d
c0102273:	0f b6 05 2d 8b 12 c0 	movzbl 0xc0128b2d,%eax
c010227a:	24 ef                	and    $0xef,%al
c010227c:	a2 2d 8b 12 c0       	mov    %al,0xc0128b2d
c0102281:	0f b6 05 2d 8b 12 c0 	movzbl 0xc0128b2d,%eax
c0102288:	0c 60                	or     $0x60,%al
c010228a:	a2 2d 8b 12 c0       	mov    %al,0xc0128b2d
c010228f:	0f b6 05 2d 8b 12 c0 	movzbl 0xc0128b2d,%eax
c0102296:	0c 80                	or     $0x80,%al
c0102298:	a2 2d 8b 12 c0       	mov    %al,0xc0128b2d
c010229d:	a1 c4 57 12 c0       	mov    0xc01257c4,%eax
c01022a2:	c1 e8 10             	shr    $0x10,%eax
c01022a5:	0f b7 c0             	movzwl %ax,%eax
c01022a8:	66 a3 2e 8b 12 c0    	mov    %ax,0xc0128b2e
c01022ae:	c7 45 f4 60 55 12 c0 	movl   $0xc0125560,-0xc(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01022b8:	0f 01 18             	lidtl  (%eax)

    lidt(&idt_pd); 
}
c01022bb:	90                   	nop
c01022bc:	c9                   	leave  
c01022bd:	c3                   	ret    

c01022be <trapname>:

static const char *
trapname(int trapno) {
c01022be:	55                   	push   %ebp
c01022bf:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01022c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01022c4:	83 f8 13             	cmp    $0x13,%eax
c01022c7:	77 0c                	ja     c01022d5 <trapname+0x17>
        return excnames[trapno];
c01022c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01022cc:	8b 04 85 e0 a8 10 c0 	mov    -0x3fef5720(,%eax,4),%eax
c01022d3:	eb 18                	jmp    c01022ed <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01022d5:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01022d9:	7e 0d                	jle    c01022e8 <trapname+0x2a>
c01022db:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022df:	7f 07                	jg     c01022e8 <trapname+0x2a>
        return "Hardware Interrupt";
c01022e1:	b8 0a a5 10 c0       	mov    $0xc010a50a,%eax
c01022e6:	eb 05                	jmp    c01022ed <trapname+0x2f>
    }
    return "(unknown trap)";
c01022e8:	b8 1d a5 10 c0       	mov    $0xc010a51d,%eax
}
c01022ed:	5d                   	pop    %ebp
c01022ee:	c3                   	ret    

c01022ef <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022ef:	55                   	push   %ebp
c01022f0:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022f9:	83 f8 08             	cmp    $0x8,%eax
c01022fc:	0f 94 c0             	sete   %al
c01022ff:	0f b6 c0             	movzbl %al,%eax
}
c0102302:	5d                   	pop    %ebp
c0102303:	c3                   	ret    

c0102304 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102304:	55                   	push   %ebp
c0102305:	89 e5                	mov    %esp,%ebp
c0102307:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010230a:	8b 45 08             	mov    0x8(%ebp),%eax
c010230d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102311:	c7 04 24 5e a5 10 c0 	movl   $0xc010a55e,(%esp)
c0102318:	e8 8c df ff ff       	call   c01002a9 <cprintf>
    print_regs(&tf->tf_regs);
c010231d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102320:	89 04 24             	mov    %eax,(%esp)
c0102323:	e8 91 01 00 00       	call   c01024b9 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0102328:	8b 45 08             	mov    0x8(%ebp),%eax
c010232b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010232f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102333:	c7 04 24 6f a5 10 c0 	movl   $0xc010a56f,(%esp)
c010233a:	e8 6a df ff ff       	call   c01002a9 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c010233f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102342:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102346:	89 44 24 04          	mov    %eax,0x4(%esp)
c010234a:	c7 04 24 82 a5 10 c0 	movl   $0xc010a582,(%esp)
c0102351:	e8 53 df ff ff       	call   c01002a9 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102356:	8b 45 08             	mov    0x8(%ebp),%eax
c0102359:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010235d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102361:	c7 04 24 95 a5 10 c0 	movl   $0xc010a595,(%esp)
c0102368:	e8 3c df ff ff       	call   c01002a9 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010236d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102370:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102374:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102378:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c010237f:	e8 25 df ff ff       	call   c01002a9 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102384:	8b 45 08             	mov    0x8(%ebp),%eax
c0102387:	8b 40 30             	mov    0x30(%eax),%eax
c010238a:	89 04 24             	mov    %eax,(%esp)
c010238d:	e8 2c ff ff ff       	call   c01022be <trapname>
c0102392:	89 c2                	mov    %eax,%edx
c0102394:	8b 45 08             	mov    0x8(%ebp),%eax
c0102397:	8b 40 30             	mov    0x30(%eax),%eax
c010239a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010239e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023a2:	c7 04 24 bb a5 10 c0 	movl   $0xc010a5bb,(%esp)
c01023a9:	e8 fb de ff ff       	call   c01002a9 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01023ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b1:	8b 40 34             	mov    0x34(%eax),%eax
c01023b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023b8:	c7 04 24 cd a5 10 c0 	movl   $0xc010a5cd,(%esp)
c01023bf:	e8 e5 de ff ff       	call   c01002a9 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01023c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01023c7:	8b 40 38             	mov    0x38(%eax),%eax
c01023ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023ce:	c7 04 24 dc a5 10 c0 	movl   $0xc010a5dc,(%esp)
c01023d5:	e8 cf de ff ff       	call   c01002a9 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023da:	8b 45 08             	mov    0x8(%ebp),%eax
c01023dd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023e5:	c7 04 24 eb a5 10 c0 	movl   $0xc010a5eb,(%esp)
c01023ec:	e8 b8 de ff ff       	call   c01002a9 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f4:	8b 40 40             	mov    0x40(%eax),%eax
c01023f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023fb:	c7 04 24 fe a5 10 c0 	movl   $0xc010a5fe,(%esp)
c0102402:	e8 a2 de ff ff       	call   c01002a9 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102407:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010240e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102415:	eb 3d                	jmp    c0102454 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102417:	8b 45 08             	mov    0x8(%ebp),%eax
c010241a:	8b 50 40             	mov    0x40(%eax),%edx
c010241d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102420:	21 d0                	and    %edx,%eax
c0102422:	85 c0                	test   %eax,%eax
c0102424:	74 28                	je     c010244e <print_trapframe+0x14a>
c0102426:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102429:	8b 04 85 80 55 12 c0 	mov    -0x3fedaa80(,%eax,4),%eax
c0102430:	85 c0                	test   %eax,%eax
c0102432:	74 1a                	je     c010244e <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c0102434:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102437:	8b 04 85 80 55 12 c0 	mov    -0x3fedaa80(,%eax,4),%eax
c010243e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102442:	c7 04 24 0d a6 10 c0 	movl   $0xc010a60d,(%esp)
c0102449:	e8 5b de ff ff       	call   c01002a9 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010244e:	ff 45 f4             	incl   -0xc(%ebp)
c0102451:	d1 65 f0             	shll   -0x10(%ebp)
c0102454:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102457:	83 f8 17             	cmp    $0x17,%eax
c010245a:	76 bb                	jbe    c0102417 <print_trapframe+0x113>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c010245c:	8b 45 08             	mov    0x8(%ebp),%eax
c010245f:	8b 40 40             	mov    0x40(%eax),%eax
c0102462:	25 00 30 00 00       	and    $0x3000,%eax
c0102467:	c1 e8 0c             	shr    $0xc,%eax
c010246a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010246e:	c7 04 24 11 a6 10 c0 	movl   $0xc010a611,(%esp)
c0102475:	e8 2f de ff ff       	call   c01002a9 <cprintf>

    if (!trap_in_kernel(tf)) {
c010247a:	8b 45 08             	mov    0x8(%ebp),%eax
c010247d:	89 04 24             	mov    %eax,(%esp)
c0102480:	e8 6a fe ff ff       	call   c01022ef <trap_in_kernel>
c0102485:	85 c0                	test   %eax,%eax
c0102487:	75 2d                	jne    c01024b6 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102489:	8b 45 08             	mov    0x8(%ebp),%eax
c010248c:	8b 40 44             	mov    0x44(%eax),%eax
c010248f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102493:	c7 04 24 1a a6 10 c0 	movl   $0xc010a61a,(%esp)
c010249a:	e8 0a de ff ff       	call   c01002a9 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010249f:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a2:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01024a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024aa:	c7 04 24 29 a6 10 c0 	movl   $0xc010a629,(%esp)
c01024b1:	e8 f3 dd ff ff       	call   c01002a9 <cprintf>
    }
}
c01024b6:	90                   	nop
c01024b7:	c9                   	leave  
c01024b8:	c3                   	ret    

c01024b9 <print_regs>:

void
print_regs(struct pushregs *regs) {
c01024b9:	55                   	push   %ebp
c01024ba:	89 e5                	mov    %esp,%ebp
c01024bc:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01024bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c2:	8b 00                	mov    (%eax),%eax
c01024c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024c8:	c7 04 24 3c a6 10 c0 	movl   $0xc010a63c,(%esp)
c01024cf:	e8 d5 dd ff ff       	call   c01002a9 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01024d7:	8b 40 04             	mov    0x4(%eax),%eax
c01024da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024de:	c7 04 24 4b a6 10 c0 	movl   $0xc010a64b,(%esp)
c01024e5:	e8 bf dd ff ff       	call   c01002a9 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ed:	8b 40 08             	mov    0x8(%eax),%eax
c01024f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024f4:	c7 04 24 5a a6 10 c0 	movl   $0xc010a65a,(%esp)
c01024fb:	e8 a9 dd ff ff       	call   c01002a9 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102500:	8b 45 08             	mov    0x8(%ebp),%eax
c0102503:	8b 40 0c             	mov    0xc(%eax),%eax
c0102506:	89 44 24 04          	mov    %eax,0x4(%esp)
c010250a:	c7 04 24 69 a6 10 c0 	movl   $0xc010a669,(%esp)
c0102511:	e8 93 dd ff ff       	call   c01002a9 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102516:	8b 45 08             	mov    0x8(%ebp),%eax
c0102519:	8b 40 10             	mov    0x10(%eax),%eax
c010251c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102520:	c7 04 24 78 a6 10 c0 	movl   $0xc010a678,(%esp)
c0102527:	e8 7d dd ff ff       	call   c01002a9 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c010252c:	8b 45 08             	mov    0x8(%ebp),%eax
c010252f:	8b 40 14             	mov    0x14(%eax),%eax
c0102532:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102536:	c7 04 24 87 a6 10 c0 	movl   $0xc010a687,(%esp)
c010253d:	e8 67 dd ff ff       	call   c01002a9 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102542:	8b 45 08             	mov    0x8(%ebp),%eax
c0102545:	8b 40 18             	mov    0x18(%eax),%eax
c0102548:	89 44 24 04          	mov    %eax,0x4(%esp)
c010254c:	c7 04 24 96 a6 10 c0 	movl   $0xc010a696,(%esp)
c0102553:	e8 51 dd ff ff       	call   c01002a9 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102558:	8b 45 08             	mov    0x8(%ebp),%eax
c010255b:	8b 40 1c             	mov    0x1c(%eax),%eax
c010255e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102562:	c7 04 24 a5 a6 10 c0 	movl   $0xc010a6a5,(%esp)
c0102569:	e8 3b dd ff ff       	call   c01002a9 <cprintf>
}
c010256e:	90                   	nop
c010256f:	c9                   	leave  
c0102570:	c3                   	ret    

c0102571 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102571:	55                   	push   %ebp
c0102572:	89 e5                	mov    %esp,%ebp
c0102574:	53                   	push   %ebx
c0102575:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102578:	8b 45 08             	mov    0x8(%ebp),%eax
c010257b:	8b 40 34             	mov    0x34(%eax),%eax
c010257e:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102581:	85 c0                	test   %eax,%eax
c0102583:	74 07                	je     c010258c <print_pgfault+0x1b>
c0102585:	bb b4 a6 10 c0       	mov    $0xc010a6b4,%ebx
c010258a:	eb 05                	jmp    c0102591 <print_pgfault+0x20>
c010258c:	bb c5 a6 10 c0       	mov    $0xc010a6c5,%ebx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102591:	8b 45 08             	mov    0x8(%ebp),%eax
c0102594:	8b 40 34             	mov    0x34(%eax),%eax
c0102597:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010259a:	85 c0                	test   %eax,%eax
c010259c:	74 07                	je     c01025a5 <print_pgfault+0x34>
c010259e:	b9 57 00 00 00       	mov    $0x57,%ecx
c01025a3:	eb 05                	jmp    c01025aa <print_pgfault+0x39>
c01025a5:	b9 52 00 00 00       	mov    $0x52,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
c01025aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ad:	8b 40 34             	mov    0x34(%eax),%eax
c01025b0:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025b3:	85 c0                	test   %eax,%eax
c01025b5:	74 07                	je     c01025be <print_pgfault+0x4d>
c01025b7:	ba 55 00 00 00       	mov    $0x55,%edx
c01025bc:	eb 05                	jmp    c01025c3 <print_pgfault+0x52>
c01025be:	ba 4b 00 00 00       	mov    $0x4b,%edx
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025c3:	0f 20 d0             	mov    %cr2,%eax
c01025c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025cc:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c01025d0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01025d4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01025d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025dc:	c7 04 24 d4 a6 10 c0 	movl   $0xc010a6d4,(%esp)
c01025e3:	e8 c1 dc ff ff       	call   c01002a9 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01025e8:	90                   	nop
c01025e9:	83 c4 34             	add    $0x34,%esp
c01025ec:	5b                   	pop    %ebx
c01025ed:	5d                   	pop    %ebp
c01025ee:	c3                   	ret    

c01025ef <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025ef:	55                   	push   %ebp
c01025f0:	89 e5                	mov    %esp,%ebp
c01025f2:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f8:	89 04 24             	mov    %eax,(%esp)
c01025fb:	e8 71 ff ff ff       	call   c0102571 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102600:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c0102605:	85 c0                	test   %eax,%eax
c0102607:	74 26                	je     c010262f <pgfault_handler+0x40>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102609:	0f 20 d0             	mov    %cr2,%eax
c010260c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c010260f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102612:	8b 45 08             	mov    0x8(%ebp),%eax
c0102615:	8b 50 34             	mov    0x34(%eax),%edx
c0102618:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c010261d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0102621:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102625:	89 04 24             	mov    %eax,(%esp)
c0102628:	e8 4b 17 00 00       	call   c0103d78 <do_pgfault>
c010262d:	eb 1c                	jmp    c010264b <pgfault_handler+0x5c>
    }
    panic("unhandled page fault.\n");
c010262f:	c7 44 24 08 f7 a6 10 	movl   $0xc010a6f7,0x8(%esp)
c0102636:	c0 
c0102637:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c010263e:	00 
c010263f:	c7 04 24 0e a7 10 c0 	movl   $0xc010a70e,(%esp)
c0102646:	e8 b5 dd ff ff       	call   c0100400 <__panic>
}
c010264b:	c9                   	leave  
c010264c:	c3                   	ret    

c010264d <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c010264d:	55                   	push   %ebp
c010264e:	89 e5                	mov    %esp,%ebp
c0102650:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102653:	8b 45 08             	mov    0x8(%ebp),%eax
c0102656:	8b 40 30             	mov    0x30(%eax),%eax
c0102659:	83 f8 24             	cmp    $0x24,%eax
c010265c:	0f 84 ae 00 00 00    	je     c0102710 <trap_dispatch+0xc3>
c0102662:	83 f8 24             	cmp    $0x24,%eax
c0102665:	77 18                	ja     c010267f <trap_dispatch+0x32>
c0102667:	83 f8 20             	cmp    $0x20,%eax
c010266a:	74 7c                	je     c01026e8 <trap_dispatch+0x9b>
c010266c:	83 f8 21             	cmp    $0x21,%eax
c010266f:	0f 84 c1 00 00 00    	je     c0102736 <trap_dispatch+0xe9>
c0102675:	83 f8 0e             	cmp    $0xe,%eax
c0102678:	74 28                	je     c01026a2 <trap_dispatch+0x55>
c010267a:	e9 f9 00 00 00       	jmp    c0102778 <trap_dispatch+0x12b>
c010267f:	83 f8 2e             	cmp    $0x2e,%eax
c0102682:	0f 82 f0 00 00 00    	jb     c0102778 <trap_dispatch+0x12b>
c0102688:	83 f8 2f             	cmp    $0x2f,%eax
c010268b:	0f 86 1c 01 00 00    	jbe    c01027ad <trap_dispatch+0x160>
c0102691:	83 e8 78             	sub    $0x78,%eax
c0102694:	83 f8 01             	cmp    $0x1,%eax
c0102697:	0f 87 db 00 00 00    	ja     c0102778 <trap_dispatch+0x12b>
c010269d:	e9 ba 00 00 00       	jmp    c010275c <trap_dispatch+0x10f>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01026a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01026a5:	89 04 24             	mov    %eax,(%esp)
c01026a8:	e8 42 ff ff ff       	call   c01025ef <pgfault_handler>
c01026ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01026b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01026b4:	0f 84 f6 00 00 00    	je     c01027b0 <trap_dispatch+0x163>
            print_trapframe(tf);
c01026ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01026bd:	89 04 24             	mov    %eax,(%esp)
c01026c0:	e8 3f fc ff ff       	call   c0102304 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c01026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01026cc:	c7 44 24 08 1f a7 10 	movl   $0xc010a71f,0x8(%esp)
c01026d3:	c0 
c01026d4:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01026db:	00 
c01026dc:	c7 04 24 0e a7 10 c0 	movl   $0xc010a70e,(%esp)
c01026e3:	e8 18 dd ff ff       	call   c0100400 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        if(++ticks == TICK_NUM){
c01026e8:	a1 54 b0 12 c0       	mov    0xc012b054,%eax
c01026ed:	40                   	inc    %eax
c01026ee:	a3 54 b0 12 c0       	mov    %eax,0xc012b054
c01026f3:	83 f8 64             	cmp    $0x64,%eax
c01026f6:	0f 85 b7 00 00 00    	jne    c01027b3 <trap_dispatch+0x166>
            print_ticks();
c01026fc:	e8 29 fa ff ff       	call   c010212a <print_ticks>
            ticks = 0;
c0102701:	c7 05 54 b0 12 c0 00 	movl   $0x0,0xc012b054
c0102708:	00 00 00 
        }
        break;
c010270b:	e9 a3 00 00 00       	jmp    c01027b3 <trap_dispatch+0x166>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102710:	e8 da f7 ff ff       	call   c0101eef <cons_getc>
c0102715:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102718:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c010271c:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102720:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102724:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102728:	c7 04 24 3a a7 10 c0 	movl   $0xc010a73a,(%esp)
c010272f:	e8 75 db ff ff       	call   c01002a9 <cprintf>
        break;
c0102734:	eb 7e                	jmp    c01027b4 <trap_dispatch+0x167>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102736:	e8 b4 f7 ff ff       	call   c0101eef <cons_getc>
c010273b:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c010273e:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102742:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102746:	89 54 24 08          	mov    %edx,0x8(%esp)
c010274a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010274e:	c7 04 24 4c a7 10 c0 	movl   $0xc010a74c,(%esp)
c0102755:	e8 4f db ff ff       	call   c01002a9 <cprintf>
        break;
c010275a:	eb 58                	jmp    c01027b4 <trap_dispatch+0x167>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c010275c:	c7 44 24 08 5b a7 10 	movl   $0xc010a75b,0x8(%esp)
c0102763:	c0 
c0102764:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c010276b:	00 
c010276c:	c7 04 24 0e a7 10 c0 	movl   $0xc010a70e,(%esp)
c0102773:	e8 88 dc ff ff       	call   c0100400 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102778:	8b 45 08             	mov    0x8(%ebp),%eax
c010277b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010277f:	83 e0 03             	and    $0x3,%eax
c0102782:	85 c0                	test   %eax,%eax
c0102784:	75 2e                	jne    c01027b4 <trap_dispatch+0x167>
            print_trapframe(tf);
c0102786:	8b 45 08             	mov    0x8(%ebp),%eax
c0102789:	89 04 24             	mov    %eax,(%esp)
c010278c:	e8 73 fb ff ff       	call   c0102304 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0102791:	c7 44 24 08 6b a7 10 	movl   $0xc010a76b,0x8(%esp)
c0102798:	c0 
c0102799:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01027a0:	00 
c01027a1:	c7 04 24 0e a7 10 c0 	movl   $0xc010a70e,(%esp)
c01027a8:	e8 53 dc ff ff       	call   c0100400 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c01027ad:	90                   	nop
c01027ae:	eb 04                	jmp    c01027b4 <trap_dispatch+0x167>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
            print_trapframe(tf);
            panic("handle pgfault failed. %e\n", ret);
        }
        break;
c01027b0:	90                   	nop
c01027b1:	eb 01                	jmp    c01027b4 <trap_dispatch+0x167>
         */
        if(++ticks == TICK_NUM){
            print_ticks();
            ticks = 0;
        }
        break;
c01027b3:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c01027b4:	90                   	nop
c01027b5:	c9                   	leave  
c01027b6:	c3                   	ret    

c01027b7 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01027b7:	55                   	push   %ebp
c01027b8:	89 e5                	mov    %esp,%ebp
c01027ba:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c01027bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c0:	89 04 24             	mov    %eax,(%esp)
c01027c3:	e8 85 fe ff ff       	call   c010264d <trap_dispatch>
}
c01027c8:	90                   	nop
c01027c9:	c9                   	leave  
c01027ca:	c3                   	ret    

c01027cb <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01027cb:	6a 00                	push   $0x0
  pushl $0
c01027cd:	6a 00                	push   $0x0
  jmp __alltraps
c01027cf:	e9 69 0a 00 00       	jmp    c010323d <__alltraps>

c01027d4 <vector1>:
.globl vector1
vector1:
  pushl $0
c01027d4:	6a 00                	push   $0x0
  pushl $1
c01027d6:	6a 01                	push   $0x1
  jmp __alltraps
c01027d8:	e9 60 0a 00 00       	jmp    c010323d <__alltraps>

c01027dd <vector2>:
.globl vector2
vector2:
  pushl $0
c01027dd:	6a 00                	push   $0x0
  pushl $2
c01027df:	6a 02                	push   $0x2
  jmp __alltraps
c01027e1:	e9 57 0a 00 00       	jmp    c010323d <__alltraps>

c01027e6 <vector3>:
.globl vector3
vector3:
  pushl $0
c01027e6:	6a 00                	push   $0x0
  pushl $3
c01027e8:	6a 03                	push   $0x3
  jmp __alltraps
c01027ea:	e9 4e 0a 00 00       	jmp    c010323d <__alltraps>

c01027ef <vector4>:
.globl vector4
vector4:
  pushl $0
c01027ef:	6a 00                	push   $0x0
  pushl $4
c01027f1:	6a 04                	push   $0x4
  jmp __alltraps
c01027f3:	e9 45 0a 00 00       	jmp    c010323d <__alltraps>

c01027f8 <vector5>:
.globl vector5
vector5:
  pushl $0
c01027f8:	6a 00                	push   $0x0
  pushl $5
c01027fa:	6a 05                	push   $0x5
  jmp __alltraps
c01027fc:	e9 3c 0a 00 00       	jmp    c010323d <__alltraps>

c0102801 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102801:	6a 00                	push   $0x0
  pushl $6
c0102803:	6a 06                	push   $0x6
  jmp __alltraps
c0102805:	e9 33 0a 00 00       	jmp    c010323d <__alltraps>

c010280a <vector7>:
.globl vector7
vector7:
  pushl $0
c010280a:	6a 00                	push   $0x0
  pushl $7
c010280c:	6a 07                	push   $0x7
  jmp __alltraps
c010280e:	e9 2a 0a 00 00       	jmp    c010323d <__alltraps>

c0102813 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102813:	6a 08                	push   $0x8
  jmp __alltraps
c0102815:	e9 23 0a 00 00       	jmp    c010323d <__alltraps>

c010281a <vector9>:
.globl vector9
vector9:
  pushl $0
c010281a:	6a 00                	push   $0x0
  pushl $9
c010281c:	6a 09                	push   $0x9
  jmp __alltraps
c010281e:	e9 1a 0a 00 00       	jmp    c010323d <__alltraps>

c0102823 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102823:	6a 0a                	push   $0xa
  jmp __alltraps
c0102825:	e9 13 0a 00 00       	jmp    c010323d <__alltraps>

c010282a <vector11>:
.globl vector11
vector11:
  pushl $11
c010282a:	6a 0b                	push   $0xb
  jmp __alltraps
c010282c:	e9 0c 0a 00 00       	jmp    c010323d <__alltraps>

c0102831 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102831:	6a 0c                	push   $0xc
  jmp __alltraps
c0102833:	e9 05 0a 00 00       	jmp    c010323d <__alltraps>

c0102838 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102838:	6a 0d                	push   $0xd
  jmp __alltraps
c010283a:	e9 fe 09 00 00       	jmp    c010323d <__alltraps>

c010283f <vector14>:
.globl vector14
vector14:
  pushl $14
c010283f:	6a 0e                	push   $0xe
  jmp __alltraps
c0102841:	e9 f7 09 00 00       	jmp    c010323d <__alltraps>

c0102846 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102846:	6a 00                	push   $0x0
  pushl $15
c0102848:	6a 0f                	push   $0xf
  jmp __alltraps
c010284a:	e9 ee 09 00 00       	jmp    c010323d <__alltraps>

c010284f <vector16>:
.globl vector16
vector16:
  pushl $0
c010284f:	6a 00                	push   $0x0
  pushl $16
c0102851:	6a 10                	push   $0x10
  jmp __alltraps
c0102853:	e9 e5 09 00 00       	jmp    c010323d <__alltraps>

c0102858 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102858:	6a 11                	push   $0x11
  jmp __alltraps
c010285a:	e9 de 09 00 00       	jmp    c010323d <__alltraps>

c010285f <vector18>:
.globl vector18
vector18:
  pushl $0
c010285f:	6a 00                	push   $0x0
  pushl $18
c0102861:	6a 12                	push   $0x12
  jmp __alltraps
c0102863:	e9 d5 09 00 00       	jmp    c010323d <__alltraps>

c0102868 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102868:	6a 00                	push   $0x0
  pushl $19
c010286a:	6a 13                	push   $0x13
  jmp __alltraps
c010286c:	e9 cc 09 00 00       	jmp    c010323d <__alltraps>

c0102871 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102871:	6a 00                	push   $0x0
  pushl $20
c0102873:	6a 14                	push   $0x14
  jmp __alltraps
c0102875:	e9 c3 09 00 00       	jmp    c010323d <__alltraps>

c010287a <vector21>:
.globl vector21
vector21:
  pushl $0
c010287a:	6a 00                	push   $0x0
  pushl $21
c010287c:	6a 15                	push   $0x15
  jmp __alltraps
c010287e:	e9 ba 09 00 00       	jmp    c010323d <__alltraps>

c0102883 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102883:	6a 00                	push   $0x0
  pushl $22
c0102885:	6a 16                	push   $0x16
  jmp __alltraps
c0102887:	e9 b1 09 00 00       	jmp    c010323d <__alltraps>

c010288c <vector23>:
.globl vector23
vector23:
  pushl $0
c010288c:	6a 00                	push   $0x0
  pushl $23
c010288e:	6a 17                	push   $0x17
  jmp __alltraps
c0102890:	e9 a8 09 00 00       	jmp    c010323d <__alltraps>

c0102895 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102895:	6a 00                	push   $0x0
  pushl $24
c0102897:	6a 18                	push   $0x18
  jmp __alltraps
c0102899:	e9 9f 09 00 00       	jmp    c010323d <__alltraps>

c010289e <vector25>:
.globl vector25
vector25:
  pushl $0
c010289e:	6a 00                	push   $0x0
  pushl $25
c01028a0:	6a 19                	push   $0x19
  jmp __alltraps
c01028a2:	e9 96 09 00 00       	jmp    c010323d <__alltraps>

c01028a7 <vector26>:
.globl vector26
vector26:
  pushl $0
c01028a7:	6a 00                	push   $0x0
  pushl $26
c01028a9:	6a 1a                	push   $0x1a
  jmp __alltraps
c01028ab:	e9 8d 09 00 00       	jmp    c010323d <__alltraps>

c01028b0 <vector27>:
.globl vector27
vector27:
  pushl $0
c01028b0:	6a 00                	push   $0x0
  pushl $27
c01028b2:	6a 1b                	push   $0x1b
  jmp __alltraps
c01028b4:	e9 84 09 00 00       	jmp    c010323d <__alltraps>

c01028b9 <vector28>:
.globl vector28
vector28:
  pushl $0
c01028b9:	6a 00                	push   $0x0
  pushl $28
c01028bb:	6a 1c                	push   $0x1c
  jmp __alltraps
c01028bd:	e9 7b 09 00 00       	jmp    c010323d <__alltraps>

c01028c2 <vector29>:
.globl vector29
vector29:
  pushl $0
c01028c2:	6a 00                	push   $0x0
  pushl $29
c01028c4:	6a 1d                	push   $0x1d
  jmp __alltraps
c01028c6:	e9 72 09 00 00       	jmp    c010323d <__alltraps>

c01028cb <vector30>:
.globl vector30
vector30:
  pushl $0
c01028cb:	6a 00                	push   $0x0
  pushl $30
c01028cd:	6a 1e                	push   $0x1e
  jmp __alltraps
c01028cf:	e9 69 09 00 00       	jmp    c010323d <__alltraps>

c01028d4 <vector31>:
.globl vector31
vector31:
  pushl $0
c01028d4:	6a 00                	push   $0x0
  pushl $31
c01028d6:	6a 1f                	push   $0x1f
  jmp __alltraps
c01028d8:	e9 60 09 00 00       	jmp    c010323d <__alltraps>

c01028dd <vector32>:
.globl vector32
vector32:
  pushl $0
c01028dd:	6a 00                	push   $0x0
  pushl $32
c01028df:	6a 20                	push   $0x20
  jmp __alltraps
c01028e1:	e9 57 09 00 00       	jmp    c010323d <__alltraps>

c01028e6 <vector33>:
.globl vector33
vector33:
  pushl $0
c01028e6:	6a 00                	push   $0x0
  pushl $33
c01028e8:	6a 21                	push   $0x21
  jmp __alltraps
c01028ea:	e9 4e 09 00 00       	jmp    c010323d <__alltraps>

c01028ef <vector34>:
.globl vector34
vector34:
  pushl $0
c01028ef:	6a 00                	push   $0x0
  pushl $34
c01028f1:	6a 22                	push   $0x22
  jmp __alltraps
c01028f3:	e9 45 09 00 00       	jmp    c010323d <__alltraps>

c01028f8 <vector35>:
.globl vector35
vector35:
  pushl $0
c01028f8:	6a 00                	push   $0x0
  pushl $35
c01028fa:	6a 23                	push   $0x23
  jmp __alltraps
c01028fc:	e9 3c 09 00 00       	jmp    c010323d <__alltraps>

c0102901 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102901:	6a 00                	push   $0x0
  pushl $36
c0102903:	6a 24                	push   $0x24
  jmp __alltraps
c0102905:	e9 33 09 00 00       	jmp    c010323d <__alltraps>

c010290a <vector37>:
.globl vector37
vector37:
  pushl $0
c010290a:	6a 00                	push   $0x0
  pushl $37
c010290c:	6a 25                	push   $0x25
  jmp __alltraps
c010290e:	e9 2a 09 00 00       	jmp    c010323d <__alltraps>

c0102913 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102913:	6a 00                	push   $0x0
  pushl $38
c0102915:	6a 26                	push   $0x26
  jmp __alltraps
c0102917:	e9 21 09 00 00       	jmp    c010323d <__alltraps>

c010291c <vector39>:
.globl vector39
vector39:
  pushl $0
c010291c:	6a 00                	push   $0x0
  pushl $39
c010291e:	6a 27                	push   $0x27
  jmp __alltraps
c0102920:	e9 18 09 00 00       	jmp    c010323d <__alltraps>

c0102925 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102925:	6a 00                	push   $0x0
  pushl $40
c0102927:	6a 28                	push   $0x28
  jmp __alltraps
c0102929:	e9 0f 09 00 00       	jmp    c010323d <__alltraps>

c010292e <vector41>:
.globl vector41
vector41:
  pushl $0
c010292e:	6a 00                	push   $0x0
  pushl $41
c0102930:	6a 29                	push   $0x29
  jmp __alltraps
c0102932:	e9 06 09 00 00       	jmp    c010323d <__alltraps>

c0102937 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102937:	6a 00                	push   $0x0
  pushl $42
c0102939:	6a 2a                	push   $0x2a
  jmp __alltraps
c010293b:	e9 fd 08 00 00       	jmp    c010323d <__alltraps>

c0102940 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102940:	6a 00                	push   $0x0
  pushl $43
c0102942:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102944:	e9 f4 08 00 00       	jmp    c010323d <__alltraps>

c0102949 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102949:	6a 00                	push   $0x0
  pushl $44
c010294b:	6a 2c                	push   $0x2c
  jmp __alltraps
c010294d:	e9 eb 08 00 00       	jmp    c010323d <__alltraps>

c0102952 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102952:	6a 00                	push   $0x0
  pushl $45
c0102954:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102956:	e9 e2 08 00 00       	jmp    c010323d <__alltraps>

c010295b <vector46>:
.globl vector46
vector46:
  pushl $0
c010295b:	6a 00                	push   $0x0
  pushl $46
c010295d:	6a 2e                	push   $0x2e
  jmp __alltraps
c010295f:	e9 d9 08 00 00       	jmp    c010323d <__alltraps>

c0102964 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102964:	6a 00                	push   $0x0
  pushl $47
c0102966:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102968:	e9 d0 08 00 00       	jmp    c010323d <__alltraps>

c010296d <vector48>:
.globl vector48
vector48:
  pushl $0
c010296d:	6a 00                	push   $0x0
  pushl $48
c010296f:	6a 30                	push   $0x30
  jmp __alltraps
c0102971:	e9 c7 08 00 00       	jmp    c010323d <__alltraps>

c0102976 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102976:	6a 00                	push   $0x0
  pushl $49
c0102978:	6a 31                	push   $0x31
  jmp __alltraps
c010297a:	e9 be 08 00 00       	jmp    c010323d <__alltraps>

c010297f <vector50>:
.globl vector50
vector50:
  pushl $0
c010297f:	6a 00                	push   $0x0
  pushl $50
c0102981:	6a 32                	push   $0x32
  jmp __alltraps
c0102983:	e9 b5 08 00 00       	jmp    c010323d <__alltraps>

c0102988 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102988:	6a 00                	push   $0x0
  pushl $51
c010298a:	6a 33                	push   $0x33
  jmp __alltraps
c010298c:	e9 ac 08 00 00       	jmp    c010323d <__alltraps>

c0102991 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102991:	6a 00                	push   $0x0
  pushl $52
c0102993:	6a 34                	push   $0x34
  jmp __alltraps
c0102995:	e9 a3 08 00 00       	jmp    c010323d <__alltraps>

c010299a <vector53>:
.globl vector53
vector53:
  pushl $0
c010299a:	6a 00                	push   $0x0
  pushl $53
c010299c:	6a 35                	push   $0x35
  jmp __alltraps
c010299e:	e9 9a 08 00 00       	jmp    c010323d <__alltraps>

c01029a3 <vector54>:
.globl vector54
vector54:
  pushl $0
c01029a3:	6a 00                	push   $0x0
  pushl $54
c01029a5:	6a 36                	push   $0x36
  jmp __alltraps
c01029a7:	e9 91 08 00 00       	jmp    c010323d <__alltraps>

c01029ac <vector55>:
.globl vector55
vector55:
  pushl $0
c01029ac:	6a 00                	push   $0x0
  pushl $55
c01029ae:	6a 37                	push   $0x37
  jmp __alltraps
c01029b0:	e9 88 08 00 00       	jmp    c010323d <__alltraps>

c01029b5 <vector56>:
.globl vector56
vector56:
  pushl $0
c01029b5:	6a 00                	push   $0x0
  pushl $56
c01029b7:	6a 38                	push   $0x38
  jmp __alltraps
c01029b9:	e9 7f 08 00 00       	jmp    c010323d <__alltraps>

c01029be <vector57>:
.globl vector57
vector57:
  pushl $0
c01029be:	6a 00                	push   $0x0
  pushl $57
c01029c0:	6a 39                	push   $0x39
  jmp __alltraps
c01029c2:	e9 76 08 00 00       	jmp    c010323d <__alltraps>

c01029c7 <vector58>:
.globl vector58
vector58:
  pushl $0
c01029c7:	6a 00                	push   $0x0
  pushl $58
c01029c9:	6a 3a                	push   $0x3a
  jmp __alltraps
c01029cb:	e9 6d 08 00 00       	jmp    c010323d <__alltraps>

c01029d0 <vector59>:
.globl vector59
vector59:
  pushl $0
c01029d0:	6a 00                	push   $0x0
  pushl $59
c01029d2:	6a 3b                	push   $0x3b
  jmp __alltraps
c01029d4:	e9 64 08 00 00       	jmp    c010323d <__alltraps>

c01029d9 <vector60>:
.globl vector60
vector60:
  pushl $0
c01029d9:	6a 00                	push   $0x0
  pushl $60
c01029db:	6a 3c                	push   $0x3c
  jmp __alltraps
c01029dd:	e9 5b 08 00 00       	jmp    c010323d <__alltraps>

c01029e2 <vector61>:
.globl vector61
vector61:
  pushl $0
c01029e2:	6a 00                	push   $0x0
  pushl $61
c01029e4:	6a 3d                	push   $0x3d
  jmp __alltraps
c01029e6:	e9 52 08 00 00       	jmp    c010323d <__alltraps>

c01029eb <vector62>:
.globl vector62
vector62:
  pushl $0
c01029eb:	6a 00                	push   $0x0
  pushl $62
c01029ed:	6a 3e                	push   $0x3e
  jmp __alltraps
c01029ef:	e9 49 08 00 00       	jmp    c010323d <__alltraps>

c01029f4 <vector63>:
.globl vector63
vector63:
  pushl $0
c01029f4:	6a 00                	push   $0x0
  pushl $63
c01029f6:	6a 3f                	push   $0x3f
  jmp __alltraps
c01029f8:	e9 40 08 00 00       	jmp    c010323d <__alltraps>

c01029fd <vector64>:
.globl vector64
vector64:
  pushl $0
c01029fd:	6a 00                	push   $0x0
  pushl $64
c01029ff:	6a 40                	push   $0x40
  jmp __alltraps
c0102a01:	e9 37 08 00 00       	jmp    c010323d <__alltraps>

c0102a06 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102a06:	6a 00                	push   $0x0
  pushl $65
c0102a08:	6a 41                	push   $0x41
  jmp __alltraps
c0102a0a:	e9 2e 08 00 00       	jmp    c010323d <__alltraps>

c0102a0f <vector66>:
.globl vector66
vector66:
  pushl $0
c0102a0f:	6a 00                	push   $0x0
  pushl $66
c0102a11:	6a 42                	push   $0x42
  jmp __alltraps
c0102a13:	e9 25 08 00 00       	jmp    c010323d <__alltraps>

c0102a18 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102a18:	6a 00                	push   $0x0
  pushl $67
c0102a1a:	6a 43                	push   $0x43
  jmp __alltraps
c0102a1c:	e9 1c 08 00 00       	jmp    c010323d <__alltraps>

c0102a21 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a21:	6a 00                	push   $0x0
  pushl $68
c0102a23:	6a 44                	push   $0x44
  jmp __alltraps
c0102a25:	e9 13 08 00 00       	jmp    c010323d <__alltraps>

c0102a2a <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a2a:	6a 00                	push   $0x0
  pushl $69
c0102a2c:	6a 45                	push   $0x45
  jmp __alltraps
c0102a2e:	e9 0a 08 00 00       	jmp    c010323d <__alltraps>

c0102a33 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a33:	6a 00                	push   $0x0
  pushl $70
c0102a35:	6a 46                	push   $0x46
  jmp __alltraps
c0102a37:	e9 01 08 00 00       	jmp    c010323d <__alltraps>

c0102a3c <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a3c:	6a 00                	push   $0x0
  pushl $71
c0102a3e:	6a 47                	push   $0x47
  jmp __alltraps
c0102a40:	e9 f8 07 00 00       	jmp    c010323d <__alltraps>

c0102a45 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102a45:	6a 00                	push   $0x0
  pushl $72
c0102a47:	6a 48                	push   $0x48
  jmp __alltraps
c0102a49:	e9 ef 07 00 00       	jmp    c010323d <__alltraps>

c0102a4e <vector73>:
.globl vector73
vector73:
  pushl $0
c0102a4e:	6a 00                	push   $0x0
  pushl $73
c0102a50:	6a 49                	push   $0x49
  jmp __alltraps
c0102a52:	e9 e6 07 00 00       	jmp    c010323d <__alltraps>

c0102a57 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102a57:	6a 00                	push   $0x0
  pushl $74
c0102a59:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102a5b:	e9 dd 07 00 00       	jmp    c010323d <__alltraps>

c0102a60 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102a60:	6a 00                	push   $0x0
  pushl $75
c0102a62:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102a64:	e9 d4 07 00 00       	jmp    c010323d <__alltraps>

c0102a69 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102a69:	6a 00                	push   $0x0
  pushl $76
c0102a6b:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102a6d:	e9 cb 07 00 00       	jmp    c010323d <__alltraps>

c0102a72 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a72:	6a 00                	push   $0x0
  pushl $77
c0102a74:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a76:	e9 c2 07 00 00       	jmp    c010323d <__alltraps>

c0102a7b <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a7b:	6a 00                	push   $0x0
  pushl $78
c0102a7d:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a7f:	e9 b9 07 00 00       	jmp    c010323d <__alltraps>

c0102a84 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a84:	6a 00                	push   $0x0
  pushl $79
c0102a86:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a88:	e9 b0 07 00 00       	jmp    c010323d <__alltraps>

c0102a8d <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a8d:	6a 00                	push   $0x0
  pushl $80
c0102a8f:	6a 50                	push   $0x50
  jmp __alltraps
c0102a91:	e9 a7 07 00 00       	jmp    c010323d <__alltraps>

c0102a96 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a96:	6a 00                	push   $0x0
  pushl $81
c0102a98:	6a 51                	push   $0x51
  jmp __alltraps
c0102a9a:	e9 9e 07 00 00       	jmp    c010323d <__alltraps>

c0102a9f <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a9f:	6a 00                	push   $0x0
  pushl $82
c0102aa1:	6a 52                	push   $0x52
  jmp __alltraps
c0102aa3:	e9 95 07 00 00       	jmp    c010323d <__alltraps>

c0102aa8 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102aa8:	6a 00                	push   $0x0
  pushl $83
c0102aaa:	6a 53                	push   $0x53
  jmp __alltraps
c0102aac:	e9 8c 07 00 00       	jmp    c010323d <__alltraps>

c0102ab1 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102ab1:	6a 00                	push   $0x0
  pushl $84
c0102ab3:	6a 54                	push   $0x54
  jmp __alltraps
c0102ab5:	e9 83 07 00 00       	jmp    c010323d <__alltraps>

c0102aba <vector85>:
.globl vector85
vector85:
  pushl $0
c0102aba:	6a 00                	push   $0x0
  pushl $85
c0102abc:	6a 55                	push   $0x55
  jmp __alltraps
c0102abe:	e9 7a 07 00 00       	jmp    c010323d <__alltraps>

c0102ac3 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102ac3:	6a 00                	push   $0x0
  pushl $86
c0102ac5:	6a 56                	push   $0x56
  jmp __alltraps
c0102ac7:	e9 71 07 00 00       	jmp    c010323d <__alltraps>

c0102acc <vector87>:
.globl vector87
vector87:
  pushl $0
c0102acc:	6a 00                	push   $0x0
  pushl $87
c0102ace:	6a 57                	push   $0x57
  jmp __alltraps
c0102ad0:	e9 68 07 00 00       	jmp    c010323d <__alltraps>

c0102ad5 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102ad5:	6a 00                	push   $0x0
  pushl $88
c0102ad7:	6a 58                	push   $0x58
  jmp __alltraps
c0102ad9:	e9 5f 07 00 00       	jmp    c010323d <__alltraps>

c0102ade <vector89>:
.globl vector89
vector89:
  pushl $0
c0102ade:	6a 00                	push   $0x0
  pushl $89
c0102ae0:	6a 59                	push   $0x59
  jmp __alltraps
c0102ae2:	e9 56 07 00 00       	jmp    c010323d <__alltraps>

c0102ae7 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102ae7:	6a 00                	push   $0x0
  pushl $90
c0102ae9:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102aeb:	e9 4d 07 00 00       	jmp    c010323d <__alltraps>

c0102af0 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102af0:	6a 00                	push   $0x0
  pushl $91
c0102af2:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102af4:	e9 44 07 00 00       	jmp    c010323d <__alltraps>

c0102af9 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102af9:	6a 00                	push   $0x0
  pushl $92
c0102afb:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102afd:	e9 3b 07 00 00       	jmp    c010323d <__alltraps>

c0102b02 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102b02:	6a 00                	push   $0x0
  pushl $93
c0102b04:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102b06:	e9 32 07 00 00       	jmp    c010323d <__alltraps>

c0102b0b <vector94>:
.globl vector94
vector94:
  pushl $0
c0102b0b:	6a 00                	push   $0x0
  pushl $94
c0102b0d:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102b0f:	e9 29 07 00 00       	jmp    c010323d <__alltraps>

c0102b14 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b14:	6a 00                	push   $0x0
  pushl $95
c0102b16:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102b18:	e9 20 07 00 00       	jmp    c010323d <__alltraps>

c0102b1d <vector96>:
.globl vector96
vector96:
  pushl $0
c0102b1d:	6a 00                	push   $0x0
  pushl $96
c0102b1f:	6a 60                	push   $0x60
  jmp __alltraps
c0102b21:	e9 17 07 00 00       	jmp    c010323d <__alltraps>

c0102b26 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b26:	6a 00                	push   $0x0
  pushl $97
c0102b28:	6a 61                	push   $0x61
  jmp __alltraps
c0102b2a:	e9 0e 07 00 00       	jmp    c010323d <__alltraps>

c0102b2f <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b2f:	6a 00                	push   $0x0
  pushl $98
c0102b31:	6a 62                	push   $0x62
  jmp __alltraps
c0102b33:	e9 05 07 00 00       	jmp    c010323d <__alltraps>

c0102b38 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b38:	6a 00                	push   $0x0
  pushl $99
c0102b3a:	6a 63                	push   $0x63
  jmp __alltraps
c0102b3c:	e9 fc 06 00 00       	jmp    c010323d <__alltraps>

c0102b41 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102b41:	6a 00                	push   $0x0
  pushl $100
c0102b43:	6a 64                	push   $0x64
  jmp __alltraps
c0102b45:	e9 f3 06 00 00       	jmp    c010323d <__alltraps>

c0102b4a <vector101>:
.globl vector101
vector101:
  pushl $0
c0102b4a:	6a 00                	push   $0x0
  pushl $101
c0102b4c:	6a 65                	push   $0x65
  jmp __alltraps
c0102b4e:	e9 ea 06 00 00       	jmp    c010323d <__alltraps>

c0102b53 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102b53:	6a 00                	push   $0x0
  pushl $102
c0102b55:	6a 66                	push   $0x66
  jmp __alltraps
c0102b57:	e9 e1 06 00 00       	jmp    c010323d <__alltraps>

c0102b5c <vector103>:
.globl vector103
vector103:
  pushl $0
c0102b5c:	6a 00                	push   $0x0
  pushl $103
c0102b5e:	6a 67                	push   $0x67
  jmp __alltraps
c0102b60:	e9 d8 06 00 00       	jmp    c010323d <__alltraps>

c0102b65 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102b65:	6a 00                	push   $0x0
  pushl $104
c0102b67:	6a 68                	push   $0x68
  jmp __alltraps
c0102b69:	e9 cf 06 00 00       	jmp    c010323d <__alltraps>

c0102b6e <vector105>:
.globl vector105
vector105:
  pushl $0
c0102b6e:	6a 00                	push   $0x0
  pushl $105
c0102b70:	6a 69                	push   $0x69
  jmp __alltraps
c0102b72:	e9 c6 06 00 00       	jmp    c010323d <__alltraps>

c0102b77 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b77:	6a 00                	push   $0x0
  pushl $106
c0102b79:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b7b:	e9 bd 06 00 00       	jmp    c010323d <__alltraps>

c0102b80 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b80:	6a 00                	push   $0x0
  pushl $107
c0102b82:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b84:	e9 b4 06 00 00       	jmp    c010323d <__alltraps>

c0102b89 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b89:	6a 00                	push   $0x0
  pushl $108
c0102b8b:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b8d:	e9 ab 06 00 00       	jmp    c010323d <__alltraps>

c0102b92 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b92:	6a 00                	push   $0x0
  pushl $109
c0102b94:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b96:	e9 a2 06 00 00       	jmp    c010323d <__alltraps>

c0102b9b <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b9b:	6a 00                	push   $0x0
  pushl $110
c0102b9d:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b9f:	e9 99 06 00 00       	jmp    c010323d <__alltraps>

c0102ba4 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102ba4:	6a 00                	push   $0x0
  pushl $111
c0102ba6:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102ba8:	e9 90 06 00 00       	jmp    c010323d <__alltraps>

c0102bad <vector112>:
.globl vector112
vector112:
  pushl $0
c0102bad:	6a 00                	push   $0x0
  pushl $112
c0102baf:	6a 70                	push   $0x70
  jmp __alltraps
c0102bb1:	e9 87 06 00 00       	jmp    c010323d <__alltraps>

c0102bb6 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102bb6:	6a 00                	push   $0x0
  pushl $113
c0102bb8:	6a 71                	push   $0x71
  jmp __alltraps
c0102bba:	e9 7e 06 00 00       	jmp    c010323d <__alltraps>

c0102bbf <vector114>:
.globl vector114
vector114:
  pushl $0
c0102bbf:	6a 00                	push   $0x0
  pushl $114
c0102bc1:	6a 72                	push   $0x72
  jmp __alltraps
c0102bc3:	e9 75 06 00 00       	jmp    c010323d <__alltraps>

c0102bc8 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102bc8:	6a 00                	push   $0x0
  pushl $115
c0102bca:	6a 73                	push   $0x73
  jmp __alltraps
c0102bcc:	e9 6c 06 00 00       	jmp    c010323d <__alltraps>

c0102bd1 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102bd1:	6a 00                	push   $0x0
  pushl $116
c0102bd3:	6a 74                	push   $0x74
  jmp __alltraps
c0102bd5:	e9 63 06 00 00       	jmp    c010323d <__alltraps>

c0102bda <vector117>:
.globl vector117
vector117:
  pushl $0
c0102bda:	6a 00                	push   $0x0
  pushl $117
c0102bdc:	6a 75                	push   $0x75
  jmp __alltraps
c0102bde:	e9 5a 06 00 00       	jmp    c010323d <__alltraps>

c0102be3 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102be3:	6a 00                	push   $0x0
  pushl $118
c0102be5:	6a 76                	push   $0x76
  jmp __alltraps
c0102be7:	e9 51 06 00 00       	jmp    c010323d <__alltraps>

c0102bec <vector119>:
.globl vector119
vector119:
  pushl $0
c0102bec:	6a 00                	push   $0x0
  pushl $119
c0102bee:	6a 77                	push   $0x77
  jmp __alltraps
c0102bf0:	e9 48 06 00 00       	jmp    c010323d <__alltraps>

c0102bf5 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102bf5:	6a 00                	push   $0x0
  pushl $120
c0102bf7:	6a 78                	push   $0x78
  jmp __alltraps
c0102bf9:	e9 3f 06 00 00       	jmp    c010323d <__alltraps>

c0102bfe <vector121>:
.globl vector121
vector121:
  pushl $0
c0102bfe:	6a 00                	push   $0x0
  pushl $121
c0102c00:	6a 79                	push   $0x79
  jmp __alltraps
c0102c02:	e9 36 06 00 00       	jmp    c010323d <__alltraps>

c0102c07 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102c07:	6a 00                	push   $0x0
  pushl $122
c0102c09:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102c0b:	e9 2d 06 00 00       	jmp    c010323d <__alltraps>

c0102c10 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102c10:	6a 00                	push   $0x0
  pushl $123
c0102c12:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c14:	e9 24 06 00 00       	jmp    c010323d <__alltraps>

c0102c19 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102c19:	6a 00                	push   $0x0
  pushl $124
c0102c1b:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102c1d:	e9 1b 06 00 00       	jmp    c010323d <__alltraps>

c0102c22 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c22:	6a 00                	push   $0x0
  pushl $125
c0102c24:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c26:	e9 12 06 00 00       	jmp    c010323d <__alltraps>

c0102c2b <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c2b:	6a 00                	push   $0x0
  pushl $126
c0102c2d:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c2f:	e9 09 06 00 00       	jmp    c010323d <__alltraps>

c0102c34 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c34:	6a 00                	push   $0x0
  pushl $127
c0102c36:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c38:	e9 00 06 00 00       	jmp    c010323d <__alltraps>

c0102c3d <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c3d:	6a 00                	push   $0x0
  pushl $128
c0102c3f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102c44:	e9 f4 05 00 00       	jmp    c010323d <__alltraps>

c0102c49 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102c49:	6a 00                	push   $0x0
  pushl $129
c0102c4b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102c50:	e9 e8 05 00 00       	jmp    c010323d <__alltraps>

c0102c55 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102c55:	6a 00                	push   $0x0
  pushl $130
c0102c57:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102c5c:	e9 dc 05 00 00       	jmp    c010323d <__alltraps>

c0102c61 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102c61:	6a 00                	push   $0x0
  pushl $131
c0102c63:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102c68:	e9 d0 05 00 00       	jmp    c010323d <__alltraps>

c0102c6d <vector132>:
.globl vector132
vector132:
  pushl $0
c0102c6d:	6a 00                	push   $0x0
  pushl $132
c0102c6f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c74:	e9 c4 05 00 00       	jmp    c010323d <__alltraps>

c0102c79 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c79:	6a 00                	push   $0x0
  pushl $133
c0102c7b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c80:	e9 b8 05 00 00       	jmp    c010323d <__alltraps>

c0102c85 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c85:	6a 00                	push   $0x0
  pushl $134
c0102c87:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c8c:	e9 ac 05 00 00       	jmp    c010323d <__alltraps>

c0102c91 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c91:	6a 00                	push   $0x0
  pushl $135
c0102c93:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c98:	e9 a0 05 00 00       	jmp    c010323d <__alltraps>

c0102c9d <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c9d:	6a 00                	push   $0x0
  pushl $136
c0102c9f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102ca4:	e9 94 05 00 00       	jmp    c010323d <__alltraps>

c0102ca9 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102ca9:	6a 00                	push   $0x0
  pushl $137
c0102cab:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102cb0:	e9 88 05 00 00       	jmp    c010323d <__alltraps>

c0102cb5 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102cb5:	6a 00                	push   $0x0
  pushl $138
c0102cb7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102cbc:	e9 7c 05 00 00       	jmp    c010323d <__alltraps>

c0102cc1 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102cc1:	6a 00                	push   $0x0
  pushl $139
c0102cc3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102cc8:	e9 70 05 00 00       	jmp    c010323d <__alltraps>

c0102ccd <vector140>:
.globl vector140
vector140:
  pushl $0
c0102ccd:	6a 00                	push   $0x0
  pushl $140
c0102ccf:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102cd4:	e9 64 05 00 00       	jmp    c010323d <__alltraps>

c0102cd9 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102cd9:	6a 00                	push   $0x0
  pushl $141
c0102cdb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102ce0:	e9 58 05 00 00       	jmp    c010323d <__alltraps>

c0102ce5 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102ce5:	6a 00                	push   $0x0
  pushl $142
c0102ce7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102cec:	e9 4c 05 00 00       	jmp    c010323d <__alltraps>

c0102cf1 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102cf1:	6a 00                	push   $0x0
  pushl $143
c0102cf3:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102cf8:	e9 40 05 00 00       	jmp    c010323d <__alltraps>

c0102cfd <vector144>:
.globl vector144
vector144:
  pushl $0
c0102cfd:	6a 00                	push   $0x0
  pushl $144
c0102cff:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102d04:	e9 34 05 00 00       	jmp    c010323d <__alltraps>

c0102d09 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102d09:	6a 00                	push   $0x0
  pushl $145
c0102d0b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102d10:	e9 28 05 00 00       	jmp    c010323d <__alltraps>

c0102d15 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d15:	6a 00                	push   $0x0
  pushl $146
c0102d17:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102d1c:	e9 1c 05 00 00       	jmp    c010323d <__alltraps>

c0102d21 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d21:	6a 00                	push   $0x0
  pushl $147
c0102d23:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d28:	e9 10 05 00 00       	jmp    c010323d <__alltraps>

c0102d2d <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d2d:	6a 00                	push   $0x0
  pushl $148
c0102d2f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d34:	e9 04 05 00 00       	jmp    c010323d <__alltraps>

c0102d39 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d39:	6a 00                	push   $0x0
  pushl $149
c0102d3b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102d40:	e9 f8 04 00 00       	jmp    c010323d <__alltraps>

c0102d45 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102d45:	6a 00                	push   $0x0
  pushl $150
c0102d47:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102d4c:	e9 ec 04 00 00       	jmp    c010323d <__alltraps>

c0102d51 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102d51:	6a 00                	push   $0x0
  pushl $151
c0102d53:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102d58:	e9 e0 04 00 00       	jmp    c010323d <__alltraps>

c0102d5d <vector152>:
.globl vector152
vector152:
  pushl $0
c0102d5d:	6a 00                	push   $0x0
  pushl $152
c0102d5f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102d64:	e9 d4 04 00 00       	jmp    c010323d <__alltraps>

c0102d69 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102d69:	6a 00                	push   $0x0
  pushl $153
c0102d6b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d70:	e9 c8 04 00 00       	jmp    c010323d <__alltraps>

c0102d75 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d75:	6a 00                	push   $0x0
  pushl $154
c0102d77:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d7c:	e9 bc 04 00 00       	jmp    c010323d <__alltraps>

c0102d81 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d81:	6a 00                	push   $0x0
  pushl $155
c0102d83:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d88:	e9 b0 04 00 00       	jmp    c010323d <__alltraps>

c0102d8d <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d8d:	6a 00                	push   $0x0
  pushl $156
c0102d8f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d94:	e9 a4 04 00 00       	jmp    c010323d <__alltraps>

c0102d99 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d99:	6a 00                	push   $0x0
  pushl $157
c0102d9b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102da0:	e9 98 04 00 00       	jmp    c010323d <__alltraps>

c0102da5 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102da5:	6a 00                	push   $0x0
  pushl $158
c0102da7:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102dac:	e9 8c 04 00 00       	jmp    c010323d <__alltraps>

c0102db1 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102db1:	6a 00                	push   $0x0
  pushl $159
c0102db3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102db8:	e9 80 04 00 00       	jmp    c010323d <__alltraps>

c0102dbd <vector160>:
.globl vector160
vector160:
  pushl $0
c0102dbd:	6a 00                	push   $0x0
  pushl $160
c0102dbf:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102dc4:	e9 74 04 00 00       	jmp    c010323d <__alltraps>

c0102dc9 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102dc9:	6a 00                	push   $0x0
  pushl $161
c0102dcb:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102dd0:	e9 68 04 00 00       	jmp    c010323d <__alltraps>

c0102dd5 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102dd5:	6a 00                	push   $0x0
  pushl $162
c0102dd7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102ddc:	e9 5c 04 00 00       	jmp    c010323d <__alltraps>

c0102de1 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102de1:	6a 00                	push   $0x0
  pushl $163
c0102de3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102de8:	e9 50 04 00 00       	jmp    c010323d <__alltraps>

c0102ded <vector164>:
.globl vector164
vector164:
  pushl $0
c0102ded:	6a 00                	push   $0x0
  pushl $164
c0102def:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102df4:	e9 44 04 00 00       	jmp    c010323d <__alltraps>

c0102df9 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102df9:	6a 00                	push   $0x0
  pushl $165
c0102dfb:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102e00:	e9 38 04 00 00       	jmp    c010323d <__alltraps>

c0102e05 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102e05:	6a 00                	push   $0x0
  pushl $166
c0102e07:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102e0c:	e9 2c 04 00 00       	jmp    c010323d <__alltraps>

c0102e11 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102e11:	6a 00                	push   $0x0
  pushl $167
c0102e13:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102e18:	e9 20 04 00 00       	jmp    c010323d <__alltraps>

c0102e1d <vector168>:
.globl vector168
vector168:
  pushl $0
c0102e1d:	6a 00                	push   $0x0
  pushl $168
c0102e1f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e24:	e9 14 04 00 00       	jmp    c010323d <__alltraps>

c0102e29 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e29:	6a 00                	push   $0x0
  pushl $169
c0102e2b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e30:	e9 08 04 00 00       	jmp    c010323d <__alltraps>

c0102e35 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e35:	6a 00                	push   $0x0
  pushl $170
c0102e37:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e3c:	e9 fc 03 00 00       	jmp    c010323d <__alltraps>

c0102e41 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102e41:	6a 00                	push   $0x0
  pushl $171
c0102e43:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102e48:	e9 f0 03 00 00       	jmp    c010323d <__alltraps>

c0102e4d <vector172>:
.globl vector172
vector172:
  pushl $0
c0102e4d:	6a 00                	push   $0x0
  pushl $172
c0102e4f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102e54:	e9 e4 03 00 00       	jmp    c010323d <__alltraps>

c0102e59 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102e59:	6a 00                	push   $0x0
  pushl $173
c0102e5b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102e60:	e9 d8 03 00 00       	jmp    c010323d <__alltraps>

c0102e65 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102e65:	6a 00                	push   $0x0
  pushl $174
c0102e67:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e6c:	e9 cc 03 00 00       	jmp    c010323d <__alltraps>

c0102e71 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e71:	6a 00                	push   $0x0
  pushl $175
c0102e73:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e78:	e9 c0 03 00 00       	jmp    c010323d <__alltraps>

c0102e7d <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e7d:	6a 00                	push   $0x0
  pushl $176
c0102e7f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e84:	e9 b4 03 00 00       	jmp    c010323d <__alltraps>

c0102e89 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e89:	6a 00                	push   $0x0
  pushl $177
c0102e8b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e90:	e9 a8 03 00 00       	jmp    c010323d <__alltraps>

c0102e95 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e95:	6a 00                	push   $0x0
  pushl $178
c0102e97:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e9c:	e9 9c 03 00 00       	jmp    c010323d <__alltraps>

c0102ea1 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102ea1:	6a 00                	push   $0x0
  pushl $179
c0102ea3:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102ea8:	e9 90 03 00 00       	jmp    c010323d <__alltraps>

c0102ead <vector180>:
.globl vector180
vector180:
  pushl $0
c0102ead:	6a 00                	push   $0x0
  pushl $180
c0102eaf:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102eb4:	e9 84 03 00 00       	jmp    c010323d <__alltraps>

c0102eb9 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102eb9:	6a 00                	push   $0x0
  pushl $181
c0102ebb:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102ec0:	e9 78 03 00 00       	jmp    c010323d <__alltraps>

c0102ec5 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102ec5:	6a 00                	push   $0x0
  pushl $182
c0102ec7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102ecc:	e9 6c 03 00 00       	jmp    c010323d <__alltraps>

c0102ed1 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102ed1:	6a 00                	push   $0x0
  pushl $183
c0102ed3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102ed8:	e9 60 03 00 00       	jmp    c010323d <__alltraps>

c0102edd <vector184>:
.globl vector184
vector184:
  pushl $0
c0102edd:	6a 00                	push   $0x0
  pushl $184
c0102edf:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102ee4:	e9 54 03 00 00       	jmp    c010323d <__alltraps>

c0102ee9 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102ee9:	6a 00                	push   $0x0
  pushl $185
c0102eeb:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102ef0:	e9 48 03 00 00       	jmp    c010323d <__alltraps>

c0102ef5 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102ef5:	6a 00                	push   $0x0
  pushl $186
c0102ef7:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102efc:	e9 3c 03 00 00       	jmp    c010323d <__alltraps>

c0102f01 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102f01:	6a 00                	push   $0x0
  pushl $187
c0102f03:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102f08:	e9 30 03 00 00       	jmp    c010323d <__alltraps>

c0102f0d <vector188>:
.globl vector188
vector188:
  pushl $0
c0102f0d:	6a 00                	push   $0x0
  pushl $188
c0102f0f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f14:	e9 24 03 00 00       	jmp    c010323d <__alltraps>

c0102f19 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102f19:	6a 00                	push   $0x0
  pushl $189
c0102f1b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102f20:	e9 18 03 00 00       	jmp    c010323d <__alltraps>

c0102f25 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f25:	6a 00                	push   $0x0
  pushl $190
c0102f27:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f2c:	e9 0c 03 00 00       	jmp    c010323d <__alltraps>

c0102f31 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f31:	6a 00                	push   $0x0
  pushl $191
c0102f33:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f38:	e9 00 03 00 00       	jmp    c010323d <__alltraps>

c0102f3d <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f3d:	6a 00                	push   $0x0
  pushl $192
c0102f3f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102f44:	e9 f4 02 00 00       	jmp    c010323d <__alltraps>

c0102f49 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102f49:	6a 00                	push   $0x0
  pushl $193
c0102f4b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102f50:	e9 e8 02 00 00       	jmp    c010323d <__alltraps>

c0102f55 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102f55:	6a 00                	push   $0x0
  pushl $194
c0102f57:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102f5c:	e9 dc 02 00 00       	jmp    c010323d <__alltraps>

c0102f61 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102f61:	6a 00                	push   $0x0
  pushl $195
c0102f63:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102f68:	e9 d0 02 00 00       	jmp    c010323d <__alltraps>

c0102f6d <vector196>:
.globl vector196
vector196:
  pushl $0
c0102f6d:	6a 00                	push   $0x0
  pushl $196
c0102f6f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f74:	e9 c4 02 00 00       	jmp    c010323d <__alltraps>

c0102f79 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f79:	6a 00                	push   $0x0
  pushl $197
c0102f7b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f80:	e9 b8 02 00 00       	jmp    c010323d <__alltraps>

c0102f85 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f85:	6a 00                	push   $0x0
  pushl $198
c0102f87:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f8c:	e9 ac 02 00 00       	jmp    c010323d <__alltraps>

c0102f91 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f91:	6a 00                	push   $0x0
  pushl $199
c0102f93:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f98:	e9 a0 02 00 00       	jmp    c010323d <__alltraps>

c0102f9d <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f9d:	6a 00                	push   $0x0
  pushl $200
c0102f9f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102fa4:	e9 94 02 00 00       	jmp    c010323d <__alltraps>

c0102fa9 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102fa9:	6a 00                	push   $0x0
  pushl $201
c0102fab:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102fb0:	e9 88 02 00 00       	jmp    c010323d <__alltraps>

c0102fb5 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102fb5:	6a 00                	push   $0x0
  pushl $202
c0102fb7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102fbc:	e9 7c 02 00 00       	jmp    c010323d <__alltraps>

c0102fc1 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102fc1:	6a 00                	push   $0x0
  pushl $203
c0102fc3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102fc8:	e9 70 02 00 00       	jmp    c010323d <__alltraps>

c0102fcd <vector204>:
.globl vector204
vector204:
  pushl $0
c0102fcd:	6a 00                	push   $0x0
  pushl $204
c0102fcf:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102fd4:	e9 64 02 00 00       	jmp    c010323d <__alltraps>

c0102fd9 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102fd9:	6a 00                	push   $0x0
  pushl $205
c0102fdb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102fe0:	e9 58 02 00 00       	jmp    c010323d <__alltraps>

c0102fe5 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102fe5:	6a 00                	push   $0x0
  pushl $206
c0102fe7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102fec:	e9 4c 02 00 00       	jmp    c010323d <__alltraps>

c0102ff1 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102ff1:	6a 00                	push   $0x0
  pushl $207
c0102ff3:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102ff8:	e9 40 02 00 00       	jmp    c010323d <__alltraps>

c0102ffd <vector208>:
.globl vector208
vector208:
  pushl $0
c0102ffd:	6a 00                	push   $0x0
  pushl $208
c0102fff:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103004:	e9 34 02 00 00       	jmp    c010323d <__alltraps>

c0103009 <vector209>:
.globl vector209
vector209:
  pushl $0
c0103009:	6a 00                	push   $0x0
  pushl $209
c010300b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103010:	e9 28 02 00 00       	jmp    c010323d <__alltraps>

c0103015 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103015:	6a 00                	push   $0x0
  pushl $210
c0103017:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010301c:	e9 1c 02 00 00       	jmp    c010323d <__alltraps>

c0103021 <vector211>:
.globl vector211
vector211:
  pushl $0
c0103021:	6a 00                	push   $0x0
  pushl $211
c0103023:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0103028:	e9 10 02 00 00       	jmp    c010323d <__alltraps>

c010302d <vector212>:
.globl vector212
vector212:
  pushl $0
c010302d:	6a 00                	push   $0x0
  pushl $212
c010302f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103034:	e9 04 02 00 00       	jmp    c010323d <__alltraps>

c0103039 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103039:	6a 00                	push   $0x0
  pushl $213
c010303b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0103040:	e9 f8 01 00 00       	jmp    c010323d <__alltraps>

c0103045 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103045:	6a 00                	push   $0x0
  pushl $214
c0103047:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010304c:	e9 ec 01 00 00       	jmp    c010323d <__alltraps>

c0103051 <vector215>:
.globl vector215
vector215:
  pushl $0
c0103051:	6a 00                	push   $0x0
  pushl $215
c0103053:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0103058:	e9 e0 01 00 00       	jmp    c010323d <__alltraps>

c010305d <vector216>:
.globl vector216
vector216:
  pushl $0
c010305d:	6a 00                	push   $0x0
  pushl $216
c010305f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103064:	e9 d4 01 00 00       	jmp    c010323d <__alltraps>

c0103069 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103069:	6a 00                	push   $0x0
  pushl $217
c010306b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103070:	e9 c8 01 00 00       	jmp    c010323d <__alltraps>

c0103075 <vector218>:
.globl vector218
vector218:
  pushl $0
c0103075:	6a 00                	push   $0x0
  pushl $218
c0103077:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010307c:	e9 bc 01 00 00       	jmp    c010323d <__alltraps>

c0103081 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103081:	6a 00                	push   $0x0
  pushl $219
c0103083:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0103088:	e9 b0 01 00 00       	jmp    c010323d <__alltraps>

c010308d <vector220>:
.globl vector220
vector220:
  pushl $0
c010308d:	6a 00                	push   $0x0
  pushl $220
c010308f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103094:	e9 a4 01 00 00       	jmp    c010323d <__alltraps>

c0103099 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103099:	6a 00                	push   $0x0
  pushl $221
c010309b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01030a0:	e9 98 01 00 00       	jmp    c010323d <__alltraps>

c01030a5 <vector222>:
.globl vector222
vector222:
  pushl $0
c01030a5:	6a 00                	push   $0x0
  pushl $222
c01030a7:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01030ac:	e9 8c 01 00 00       	jmp    c010323d <__alltraps>

c01030b1 <vector223>:
.globl vector223
vector223:
  pushl $0
c01030b1:	6a 00                	push   $0x0
  pushl $223
c01030b3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01030b8:	e9 80 01 00 00       	jmp    c010323d <__alltraps>

c01030bd <vector224>:
.globl vector224
vector224:
  pushl $0
c01030bd:	6a 00                	push   $0x0
  pushl $224
c01030bf:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01030c4:	e9 74 01 00 00       	jmp    c010323d <__alltraps>

c01030c9 <vector225>:
.globl vector225
vector225:
  pushl $0
c01030c9:	6a 00                	push   $0x0
  pushl $225
c01030cb:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01030d0:	e9 68 01 00 00       	jmp    c010323d <__alltraps>

c01030d5 <vector226>:
.globl vector226
vector226:
  pushl $0
c01030d5:	6a 00                	push   $0x0
  pushl $226
c01030d7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01030dc:	e9 5c 01 00 00       	jmp    c010323d <__alltraps>

c01030e1 <vector227>:
.globl vector227
vector227:
  pushl $0
c01030e1:	6a 00                	push   $0x0
  pushl $227
c01030e3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01030e8:	e9 50 01 00 00       	jmp    c010323d <__alltraps>

c01030ed <vector228>:
.globl vector228
vector228:
  pushl $0
c01030ed:	6a 00                	push   $0x0
  pushl $228
c01030ef:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01030f4:	e9 44 01 00 00       	jmp    c010323d <__alltraps>

c01030f9 <vector229>:
.globl vector229
vector229:
  pushl $0
c01030f9:	6a 00                	push   $0x0
  pushl $229
c01030fb:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103100:	e9 38 01 00 00       	jmp    c010323d <__alltraps>

c0103105 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103105:	6a 00                	push   $0x0
  pushl $230
c0103107:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010310c:	e9 2c 01 00 00       	jmp    c010323d <__alltraps>

c0103111 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103111:	6a 00                	push   $0x0
  pushl $231
c0103113:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0103118:	e9 20 01 00 00       	jmp    c010323d <__alltraps>

c010311d <vector232>:
.globl vector232
vector232:
  pushl $0
c010311d:	6a 00                	push   $0x0
  pushl $232
c010311f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103124:	e9 14 01 00 00       	jmp    c010323d <__alltraps>

c0103129 <vector233>:
.globl vector233
vector233:
  pushl $0
c0103129:	6a 00                	push   $0x0
  pushl $233
c010312b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103130:	e9 08 01 00 00       	jmp    c010323d <__alltraps>

c0103135 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103135:	6a 00                	push   $0x0
  pushl $234
c0103137:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010313c:	e9 fc 00 00 00       	jmp    c010323d <__alltraps>

c0103141 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103141:	6a 00                	push   $0x0
  pushl $235
c0103143:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103148:	e9 f0 00 00 00       	jmp    c010323d <__alltraps>

c010314d <vector236>:
.globl vector236
vector236:
  pushl $0
c010314d:	6a 00                	push   $0x0
  pushl $236
c010314f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103154:	e9 e4 00 00 00       	jmp    c010323d <__alltraps>

c0103159 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103159:	6a 00                	push   $0x0
  pushl $237
c010315b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103160:	e9 d8 00 00 00       	jmp    c010323d <__alltraps>

c0103165 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103165:	6a 00                	push   $0x0
  pushl $238
c0103167:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010316c:	e9 cc 00 00 00       	jmp    c010323d <__alltraps>

c0103171 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103171:	6a 00                	push   $0x0
  pushl $239
c0103173:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0103178:	e9 c0 00 00 00       	jmp    c010323d <__alltraps>

c010317d <vector240>:
.globl vector240
vector240:
  pushl $0
c010317d:	6a 00                	push   $0x0
  pushl $240
c010317f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103184:	e9 b4 00 00 00       	jmp    c010323d <__alltraps>

c0103189 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103189:	6a 00                	push   $0x0
  pushl $241
c010318b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103190:	e9 a8 00 00 00       	jmp    c010323d <__alltraps>

c0103195 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103195:	6a 00                	push   $0x0
  pushl $242
c0103197:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010319c:	e9 9c 00 00 00       	jmp    c010323d <__alltraps>

c01031a1 <vector243>:
.globl vector243
vector243:
  pushl $0
c01031a1:	6a 00                	push   $0x0
  pushl $243
c01031a3:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01031a8:	e9 90 00 00 00       	jmp    c010323d <__alltraps>

c01031ad <vector244>:
.globl vector244
vector244:
  pushl $0
c01031ad:	6a 00                	push   $0x0
  pushl $244
c01031af:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01031b4:	e9 84 00 00 00       	jmp    c010323d <__alltraps>

c01031b9 <vector245>:
.globl vector245
vector245:
  pushl $0
c01031b9:	6a 00                	push   $0x0
  pushl $245
c01031bb:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01031c0:	e9 78 00 00 00       	jmp    c010323d <__alltraps>

c01031c5 <vector246>:
.globl vector246
vector246:
  pushl $0
c01031c5:	6a 00                	push   $0x0
  pushl $246
c01031c7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01031cc:	e9 6c 00 00 00       	jmp    c010323d <__alltraps>

c01031d1 <vector247>:
.globl vector247
vector247:
  pushl $0
c01031d1:	6a 00                	push   $0x0
  pushl $247
c01031d3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01031d8:	e9 60 00 00 00       	jmp    c010323d <__alltraps>

c01031dd <vector248>:
.globl vector248
vector248:
  pushl $0
c01031dd:	6a 00                	push   $0x0
  pushl $248
c01031df:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01031e4:	e9 54 00 00 00       	jmp    c010323d <__alltraps>

c01031e9 <vector249>:
.globl vector249
vector249:
  pushl $0
c01031e9:	6a 00                	push   $0x0
  pushl $249
c01031eb:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01031f0:	e9 48 00 00 00       	jmp    c010323d <__alltraps>

c01031f5 <vector250>:
.globl vector250
vector250:
  pushl $0
c01031f5:	6a 00                	push   $0x0
  pushl $250
c01031f7:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01031fc:	e9 3c 00 00 00       	jmp    c010323d <__alltraps>

c0103201 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103201:	6a 00                	push   $0x0
  pushl $251
c0103203:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0103208:	e9 30 00 00 00       	jmp    c010323d <__alltraps>

c010320d <vector252>:
.globl vector252
vector252:
  pushl $0
c010320d:	6a 00                	push   $0x0
  pushl $252
c010320f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103214:	e9 24 00 00 00       	jmp    c010323d <__alltraps>

c0103219 <vector253>:
.globl vector253
vector253:
  pushl $0
c0103219:	6a 00                	push   $0x0
  pushl $253
c010321b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103220:	e9 18 00 00 00       	jmp    c010323d <__alltraps>

c0103225 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103225:	6a 00                	push   $0x0
  pushl $254
c0103227:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010322c:	e9 0c 00 00 00       	jmp    c010323d <__alltraps>

c0103231 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103231:	6a 00                	push   $0x0
  pushl $255
c0103233:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103238:	e9 00 00 00 00       	jmp    c010323d <__alltraps>

c010323d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010323d:	1e                   	push   %ds
    pushl %es
c010323e:	06                   	push   %es
    pushl %fs
c010323f:	0f a0                	push   %fs
    pushl %gs
c0103241:	0f a8                	push   %gs
    pushal
c0103243:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0103244:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0103249:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010324b:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010324d:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010324e:	e8 64 f5 ff ff       	call   c01027b7 <trap>

    # pop the pushed stack pointer
    popl %esp
c0103253:	5c                   	pop    %esp

c0103254 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0103254:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0103255:	0f a9                	pop    %gs
    popl %fs
c0103257:	0f a1                	pop    %fs
    popl %es
c0103259:	07                   	pop    %es
    popl %ds
c010325a:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010325b:	83 c4 08             	add    $0x8,%esp
    iret
c010325e:	cf                   	iret   

c010325f <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c010325f:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c0103263:	eb ef                	jmp    c0103254 <__trapret>

c0103265 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0103265:	55                   	push   %ebp
c0103266:	89 e5                	mov    %esp,%ebp
c0103268:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010326b:	8b 45 08             	mov    0x8(%ebp),%eax
c010326e:	c1 e8 0c             	shr    $0xc,%eax
c0103271:	89 c2                	mov    %eax,%edx
c0103273:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0103278:	39 c2                	cmp    %eax,%edx
c010327a:	72 1c                	jb     c0103298 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010327c:	c7 44 24 08 30 a9 10 	movl   $0xc010a930,0x8(%esp)
c0103283:	c0 
c0103284:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c010328b:	00 
c010328c:	c7 04 24 4f a9 10 c0 	movl   $0xc010a94f,(%esp)
c0103293:	e8 68 d1 ff ff       	call   c0100400 <__panic>
    }
    return &pages[PPN(pa)];
c0103298:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c010329d:	8b 55 08             	mov    0x8(%ebp),%edx
c01032a0:	c1 ea 0c             	shr    $0xc,%edx
c01032a3:	c1 e2 05             	shl    $0x5,%edx
c01032a6:	01 d0                	add    %edx,%eax
}
c01032a8:	c9                   	leave  
c01032a9:	c3                   	ret    

c01032aa <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c01032aa:	55                   	push   %ebp
c01032ab:	89 e5                	mov    %esp,%ebp
c01032ad:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01032b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01032b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01032b8:	89 04 24             	mov    %eax,(%esp)
c01032bb:	e8 a5 ff ff ff       	call   c0103265 <pa2page>
}
c01032c0:	c9                   	leave  
c01032c1:	c3                   	ret    

c01032c2 <mm_create>:
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void)
{
c01032c2:	55                   	push   %ebp
c01032c3:	89 e5                	mov    %esp,%ebp
c01032c5:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c01032c8:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01032cf:	e8 c3 1e 00 00       	call   c0105197 <kmalloc>
c01032d4:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL)
c01032d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032db:	74 58                	je     c0103335 <mm_create+0x73>
    {
        list_init(&(mm->mmap_list));
c01032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01032e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01032e9:	89 50 04             	mov    %edx,0x4(%eax)
c01032ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032ef:	8b 50 04             	mov    0x4(%eax),%edx
c01032f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032f5:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c01032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0103301:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103304:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c010330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010330e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok)
c0103315:	a1 68 8f 12 c0       	mov    0xc0128f68,%eax
c010331a:	85 c0                	test   %eax,%eax
c010331c:	74 0d                	je     c010332b <mm_create+0x69>
            swap_init_mm(mm);
c010331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103321:	89 04 24             	mov    %eax,(%esp)
c0103324:	e8 73 0d 00 00       	call   c010409c <swap_init_mm>
c0103329:	eb 0a                	jmp    c0103335 <mm_create+0x73>
        else
            mm->sm_priv = NULL;
c010332b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010332e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0103335:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103338:	c9                   	leave  
c0103339:	c3                   	ret    

c010333a <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags)
{
c010333a:	55                   	push   %ebp
c010333b:	89 e5                	mov    %esp,%ebp
c010333d:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0103340:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0103347:	e8 4b 1e 00 00       	call   c0105197 <kmalloc>
c010334c:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL)
c010334f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103353:	74 1b                	je     c0103370 <vma_create+0x36>
    {
        vma->vm_start = vm_start;
c0103355:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103358:	8b 55 08             	mov    0x8(%ebp),%edx
c010335b:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c010335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103361:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103364:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0103367:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010336a:	8b 55 10             	mov    0x10(%ebp),%edx
c010336d:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0103370:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103373:	c9                   	leave  
c0103374:	c3                   	ret    

c0103375 <find_vma>:

// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr)
{
c0103375:	55                   	push   %ebp
c0103376:	89 e5                	mov    %esp,%ebp
c0103378:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c010337b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL)
c0103382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103386:	0f 84 95 00 00 00    	je     c0103421 <find_vma+0xac>
    {
        vma = mm->mmap_cache;
c010338c:	8b 45 08             	mov    0x8(%ebp),%eax
c010338f:	8b 40 08             	mov    0x8(%eax),%eax
c0103392:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
c0103395:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103399:	74 16                	je     c01033b1 <find_vma+0x3c>
c010339b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010339e:	8b 40 04             	mov    0x4(%eax),%eax
c01033a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01033a4:	77 0b                	ja     c01033b1 <find_vma+0x3c>
c01033a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033a9:	8b 40 08             	mov    0x8(%eax),%eax
c01033ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01033af:	77 61                	ja     c0103412 <find_vma+0x9d>
        {
            bool found = 0;
c01033b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
            list_entry_t *list = &(mm->mmap_list), *le = list;
c01033b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01033bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            while ((le = list_next(le)) != list)
c01033c4:	eb 28                	jmp    c01033ee <find_vma+0x79>
            {
                vma = le2vma(le, list_link);
c01033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033c9:	83 e8 10             	sub    $0x10,%eax
c01033cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
                if (vma->vm_start <= addr && addr < vma->vm_end)
c01033cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033d2:	8b 40 04             	mov    0x4(%eax),%eax
c01033d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01033d8:	77 14                	ja     c01033ee <find_vma+0x79>
c01033da:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033dd:	8b 40 08             	mov    0x8(%eax),%eax
c01033e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01033e3:	76 09                	jbe    c01033ee <find_vma+0x79>
                {
                    found = 1;
c01033e5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                    break;
c01033ec:	eb 17                	jmp    c0103405 <find_vma+0x90>
c01033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033f7:	8b 40 04             	mov    0x4(%eax),%eax
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
        {
            bool found = 0;
            list_entry_t *list = &(mm->mmap_list), *le = list;
            while ((le = list_next(le)) != list)
c01033fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103400:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103403:	75 c1                	jne    c01033c6 <find_vma+0x51>
                {
                    found = 1;
                    break;
                }
            }
            if (!found)
c0103405:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103409:	75 07                	jne    c0103412 <find_vma+0x9d>
            {
                vma = NULL;
c010340b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
            }
        }
        if (vma != NULL)
c0103412:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103416:	74 09                	je     c0103421 <find_vma+0xac>
        {
            mm->mmap_cache = vma;
c0103418:	8b 45 08             	mov    0x8(%ebp),%eax
c010341b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010341e:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0103421:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103424:	c9                   	leave  
c0103425:	c3                   	ret    

c0103426 <check_vma_overlap>:

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
{
c0103426:	55                   	push   %ebp
c0103427:	89 e5                	mov    %esp,%ebp
c0103429:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c010342c:	8b 45 08             	mov    0x8(%ebp),%eax
c010342f:	8b 50 04             	mov    0x4(%eax),%edx
c0103432:	8b 45 08             	mov    0x8(%ebp),%eax
c0103435:	8b 40 08             	mov    0x8(%eax),%eax
c0103438:	39 c2                	cmp    %eax,%edx
c010343a:	72 24                	jb     c0103460 <check_vma_overlap+0x3a>
c010343c:	c7 44 24 0c 5d a9 10 	movl   $0xc010a95d,0xc(%esp)
c0103443:	c0 
c0103444:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c010344b:	c0 
c010344c:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0103453:	00 
c0103454:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c010345b:	e8 a0 cf ff ff       	call   c0100400 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0103460:	8b 45 08             	mov    0x8(%ebp),%eax
c0103463:	8b 50 08             	mov    0x8(%eax),%edx
c0103466:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103469:	8b 40 04             	mov    0x4(%eax),%eax
c010346c:	39 c2                	cmp    %eax,%edx
c010346e:	76 24                	jbe    c0103494 <check_vma_overlap+0x6e>
c0103470:	c7 44 24 0c a0 a9 10 	movl   $0xc010a9a0,0xc(%esp)
c0103477:	c0 
c0103478:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c010347f:	c0 
c0103480:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
c0103487:	00 
c0103488:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c010348f:	e8 6c cf ff ff       	call   c0100400 <__panic>
    assert(next->vm_start < next->vm_end);
c0103494:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103497:	8b 50 04             	mov    0x4(%eax),%edx
c010349a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010349d:	8b 40 08             	mov    0x8(%eax),%eax
c01034a0:	39 c2                	cmp    %eax,%edx
c01034a2:	72 24                	jb     c01034c8 <check_vma_overlap+0xa2>
c01034a4:	c7 44 24 0c bf a9 10 	movl   $0xc010a9bf,0xc(%esp)
c01034ab:	c0 
c01034ac:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c01034b3:	c0 
c01034b4:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c01034bb:	00 
c01034bc:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c01034c3:	e8 38 cf ff ff       	call   c0100400 <__panic>
}
c01034c8:	90                   	nop
c01034c9:	c9                   	leave  
c01034ca:	c3                   	ret    

c01034cb <insert_vma_struct>:

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
c01034cb:	55                   	push   %ebp
c01034cc:	89 e5                	mov    %esp,%ebp
c01034ce:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c01034d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034d4:	8b 50 04             	mov    0x4(%eax),%edx
c01034d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034da:	8b 40 08             	mov    0x8(%eax),%eax
c01034dd:	39 c2                	cmp    %eax,%edx
c01034df:	72 24                	jb     c0103505 <insert_vma_struct+0x3a>
c01034e1:	c7 44 24 0c dd a9 10 	movl   $0xc010a9dd,0xc(%esp)
c01034e8:	c0 
c01034e9:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c01034f0:	c0 
c01034f1:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c01034f8:	00 
c01034f9:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103500:	e8 fb ce ff ff       	call   c0100400 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0103505:	8b 45 08             	mov    0x8(%ebp),%eax
c0103508:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c010350b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010350e:	89 45 f4             	mov    %eax,-0xc(%ebp)

    list_entry_t *le = list;
c0103511:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103514:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while ((le = list_next(le)) != list)
c0103517:	eb 1f                	jmp    c0103538 <insert_vma_struct+0x6d>
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
c0103519:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010351c:	83 e8 10             	sub    $0x10,%eax
c010351f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (mmap_prev->vm_start > vma->vm_start)
c0103522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103525:	8b 50 04             	mov    0x4(%eax),%edx
c0103528:	8b 45 0c             	mov    0xc(%ebp),%eax
c010352b:	8b 40 04             	mov    0x4(%eax),%eax
c010352e:	39 c2                	cmp    %eax,%edx
c0103530:	77 1f                	ja     c0103551 <insert_vma_struct+0x86>
        {
            break;
        }
        le_prev = le;
c0103532:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103535:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103538:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010353b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010353e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103541:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
c0103544:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103547:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010354a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010354d:	75 ca                	jne    c0103519 <insert_vma_struct+0x4e>
c010354f:	eb 01                	jmp    c0103552 <insert_vma_struct+0x87>
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
        {
            break;
c0103551:	90                   	nop
c0103552:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103555:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103558:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010355b:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le_prev = le;
    }

    le_next = list_next(le_prev);
c010355e:	89 45 dc             	mov    %eax,-0x24(%ebp)

    /* check overlap */
    if (le_prev != list)
c0103561:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103564:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103567:	74 15                	je     c010357e <insert_vma_struct+0xb3>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0103569:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010356c:	8d 50 f0             	lea    -0x10(%eax),%edx
c010356f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103572:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103576:	89 14 24             	mov    %edx,(%esp)
c0103579:	e8 a8 fe ff ff       	call   c0103426 <check_vma_overlap>
    }
    if (le_next != list)
c010357e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103581:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103584:	74 15                	je     c010359b <insert_vma_struct+0xd0>
    {
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0103586:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103589:	83 e8 10             	sub    $0x10,%eax
c010358c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103590:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103593:	89 04 24             	mov    %eax,(%esp)
c0103596:	e8 8b fe ff ff       	call   c0103426 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c010359b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010359e:	8b 55 08             	mov    0x8(%ebp),%edx
c01035a1:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01035a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035a6:	8d 50 10             	lea    0x10(%eax),%edx
c01035a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01035af:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01035b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035b5:	8b 40 04             	mov    0x4(%eax),%eax
c01035b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01035bb:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01035be:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01035c1:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01035c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01035c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01035ca:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01035cd:	89 10                	mov    %edx,(%eax)
c01035cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01035d2:	8b 10                	mov    (%eax),%edx
c01035d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035d7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01035da:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01035dd:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01035e0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01035e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01035e6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01035e9:	89 10                	mov    %edx,(%eax)

    mm->map_count++;
c01035eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01035ee:	8b 40 10             	mov    0x10(%eax),%eax
c01035f1:	8d 50 01             	lea    0x1(%eax),%edx
c01035f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01035f7:	89 50 10             	mov    %edx,0x10(%eax)
}
c01035fa:	90                   	nop
c01035fb:	c9                   	leave  
c01035fc:	c3                   	ret    

c01035fd <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
c01035fd:	55                   	push   %ebp
c01035fe:	89 e5                	mov    %esp,%ebp
c0103600:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0103603:	8b 45 08             	mov    0x8(%ebp),%eax
c0103606:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list)
c0103609:	eb 36                	jmp    c0103641 <mm_destroy+0x44>
c010360b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010360e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103611:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103614:	8b 40 04             	mov    0x4(%eax),%eax
c0103617:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010361a:	8b 12                	mov    (%edx),%edx
c010361c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010361f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103625:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103628:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010362b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010362e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103631:	89 10                	mov    %edx,(%eax)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); //kfree vma
c0103633:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103636:	83 e8 10             	sub    $0x10,%eax
c0103639:	89 04 24             	mov    %eax,(%esp)
c010363c:	e8 71 1b 00 00       	call   c01051b2 <kfree>
c0103641:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103644:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103647:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010364a:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
c010364d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103650:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103653:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103656:	75 b3                	jne    c010360b <mm_destroy+0xe>
    {
        list_del(le);
        kfree(le2vma(le, list_link)); //kfree vma
    }
    kfree(mm); //kfree mm
c0103658:	8b 45 08             	mov    0x8(%ebp),%eax
c010365b:	89 04 24             	mov    %eax,(%esp)
c010365e:	e8 4f 1b 00 00       	call   c01051b2 <kfree>
    mm = NULL;
c0103663:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c010366a:	90                   	nop
c010366b:	c9                   	leave  
c010366c:	c3                   	ret    

c010366d <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
c010366d:	55                   	push   %ebp
c010366e:	89 e5                	mov    %esp,%ebp
c0103670:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0103673:	e8 03 00 00 00       	call   c010367b <check_vmm>
}
c0103678:	90                   	nop
c0103679:	c9                   	leave  
c010367a:	c3                   	ret    

c010367b <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void)
{
c010367b:	55                   	push   %ebp
c010367c:	89 e5                	mov    %esp,%ebp
c010367e:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103681:	e8 c7 38 00 00       	call   c0106f4d <nr_free_pages>
c0103686:	89 45 f4             	mov    %eax,-0xc(%ebp)

    check_vma_struct();
c0103689:	e8 14 00 00 00       	call   c01036a2 <check_vma_struct>
    check_pgfault();
c010368e:	e8 a1 04 00 00       	call   c0103b34 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c0103693:	c7 04 24 f9 a9 10 c0 	movl   $0xc010a9f9,(%esp)
c010369a:	e8 0a cc ff ff       	call   c01002a9 <cprintf>
}
c010369f:	90                   	nop
c01036a0:	c9                   	leave  
c01036a1:	c3                   	ret    

c01036a2 <check_vma_struct>:

static void
check_vma_struct(void)
{
c01036a2:	55                   	push   %ebp
c01036a3:	89 e5                	mov    %esp,%ebp
c01036a5:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01036a8:	e8 a0 38 00 00       	call   c0106f4d <nr_free_pages>
c01036ad:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01036b0:	e8 0d fc ff ff       	call   c01032c2 <mm_create>
c01036b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01036b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01036bc:	75 24                	jne    c01036e2 <check_vma_struct+0x40>
c01036be:	c7 44 24 0c 11 aa 10 	movl   $0xc010aa11,0xc(%esp)
c01036c5:	c0 
c01036c6:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c01036cd:	c0 
c01036ce:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01036d5:	00 
c01036d6:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c01036dd:	e8 1e cd ff ff       	call   c0100400 <__panic>

    int step1 = 10, step2 = step1 * 10;
c01036e2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c01036e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01036ec:	89 d0                	mov    %edx,%eax
c01036ee:	c1 e0 02             	shl    $0x2,%eax
c01036f1:	01 d0                	add    %edx,%eax
c01036f3:	01 c0                	add    %eax,%eax
c01036f5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i--)
c01036f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01036fe:	eb 6f                	jmp    c010376f <check_vma_struct+0xcd>
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103700:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103703:	89 d0                	mov    %edx,%eax
c0103705:	c1 e0 02             	shl    $0x2,%eax
c0103708:	01 d0                	add    %edx,%eax
c010370a:	83 c0 02             	add    $0x2,%eax
c010370d:	89 c1                	mov    %eax,%ecx
c010370f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103712:	89 d0                	mov    %edx,%eax
c0103714:	c1 e0 02             	shl    $0x2,%eax
c0103717:	01 d0                	add    %edx,%eax
c0103719:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103720:	00 
c0103721:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103725:	89 04 24             	mov    %eax,(%esp)
c0103728:	e8 0d fc ff ff       	call   c010333a <vma_create>
c010372d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0103730:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103734:	75 24                	jne    c010375a <check_vma_struct+0xb8>
c0103736:	c7 44 24 0c 1c aa 10 	movl   $0xc010aa1c,0xc(%esp)
c010373d:	c0 
c010373e:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c0103745:	c0 
c0103746:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010374d:	00 
c010374e:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103755:	e8 a6 cc ff ff       	call   c0100400 <__panic>
        insert_vma_struct(mm, vma);
c010375a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010375d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103761:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103764:	89 04 24             	mov    %eax,(%esp)
c0103767:	e8 5f fd ff ff       	call   c01034cb <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
c010376c:	ff 4d f4             	decl   -0xc(%ebp)
c010376f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103773:	7f 8b                	jg     c0103700 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i++)
c0103775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103778:	40                   	inc    %eax
c0103779:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010377c:	eb 6f                	jmp    c01037ed <check_vma_struct+0x14b>
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c010377e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103781:	89 d0                	mov    %edx,%eax
c0103783:	c1 e0 02             	shl    $0x2,%eax
c0103786:	01 d0                	add    %edx,%eax
c0103788:	83 c0 02             	add    $0x2,%eax
c010378b:	89 c1                	mov    %eax,%ecx
c010378d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103790:	89 d0                	mov    %edx,%eax
c0103792:	c1 e0 02             	shl    $0x2,%eax
c0103795:	01 d0                	add    %edx,%eax
c0103797:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010379e:	00 
c010379f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01037a3:	89 04 24             	mov    %eax,(%esp)
c01037a6:	e8 8f fb ff ff       	call   c010333a <vma_create>
c01037ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c01037ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01037b2:	75 24                	jne    c01037d8 <check_vma_struct+0x136>
c01037b4:	c7 44 24 0c 1c aa 10 	movl   $0xc010aa1c,0xc(%esp)
c01037bb:	c0 
c01037bc:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c01037c3:	c0 
c01037c4:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01037cb:	00 
c01037cc:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c01037d3:	e8 28 cc ff ff       	call   c0100400 <__panic>
        insert_vma_struct(mm, vma);
c01037d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037e2:	89 04 24             	mov    %eax,(%esp)
c01037e5:	e8 e1 fc ff ff       	call   c01034cb <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i++)
c01037ea:	ff 45 f4             	incl   -0xc(%ebp)
c01037ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037f0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01037f3:	7e 89                	jle    c010377e <check_vma_struct+0xdc>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c01037f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037f8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01037fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01037fe:	8b 40 04             	mov    0x4(%eax),%eax
c0103801:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i++)
c0103804:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c010380b:	e9 96 00 00 00       	jmp    c01038a6 <check_vma_struct+0x204>
    {
        assert(le != &(mm->mmap_list));
c0103810:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103813:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103816:	75 24                	jne    c010383c <check_vma_struct+0x19a>
c0103818:	c7 44 24 0c 28 aa 10 	movl   $0xc010aa28,0xc(%esp)
c010381f:	c0 
c0103820:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c0103827:	c0 
c0103828:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c010382f:	00 
c0103830:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103837:	e8 c4 cb ff ff       	call   c0100400 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c010383c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010383f:	83 e8 10             	sub    $0x10,%eax
c0103842:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0103845:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103848:	8b 48 04             	mov    0x4(%eax),%ecx
c010384b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010384e:	89 d0                	mov    %edx,%eax
c0103850:	c1 e0 02             	shl    $0x2,%eax
c0103853:	01 d0                	add    %edx,%eax
c0103855:	39 c1                	cmp    %eax,%ecx
c0103857:	75 17                	jne    c0103870 <check_vma_struct+0x1ce>
c0103859:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010385c:	8b 48 08             	mov    0x8(%eax),%ecx
c010385f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103862:	89 d0                	mov    %edx,%eax
c0103864:	c1 e0 02             	shl    $0x2,%eax
c0103867:	01 d0                	add    %edx,%eax
c0103869:	83 c0 02             	add    $0x2,%eax
c010386c:	39 c1                	cmp    %eax,%ecx
c010386e:	74 24                	je     c0103894 <check_vma_struct+0x1f2>
c0103870:	c7 44 24 0c 40 aa 10 	movl   $0xc010aa40,0xc(%esp)
c0103877:	c0 
c0103878:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c010387f:	c0 
c0103880:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0103887:	00 
c0103888:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c010388f:	e8 6c cb ff ff       	call   c0100400 <__panic>
c0103894:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103897:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010389a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010389d:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01038a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
c01038a3:	ff 45 f4             	incl   -0xc(%ebp)
c01038a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01038ac:	0f 8e 5e ff ff ff    	jle    c0103810 <check_vma_struct+0x16e>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
c01038b2:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01038b9:	e9 cb 01 00 00       	jmp    c0103a89 <check_vma_struct+0x3e7>
    {
        struct vma_struct *vma1 = find_vma(mm, i);
c01038be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01038c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038c8:	89 04 24             	mov    %eax,(%esp)
c01038cb:	e8 a5 fa ff ff       	call   c0103375 <find_vma>
c01038d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma1 != NULL);
c01038d3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01038d7:	75 24                	jne    c01038fd <check_vma_struct+0x25b>
c01038d9:	c7 44 24 0c 75 aa 10 	movl   $0xc010aa75,0xc(%esp)
c01038e0:	c0 
c01038e1:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c01038e8:	c0 
c01038e9:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c01038f0:	00 
c01038f1:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c01038f8:	e8 03 cb ff ff       	call   c0100400 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
c01038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103900:	40                   	inc    %eax
c0103901:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103905:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103908:	89 04 24             	mov    %eax,(%esp)
c010390b:	e8 65 fa ff ff       	call   c0103375 <find_vma>
c0103910:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma2 != NULL);
c0103913:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103917:	75 24                	jne    c010393d <check_vma_struct+0x29b>
c0103919:	c7 44 24 0c 82 aa 10 	movl   $0xc010aa82,0xc(%esp)
c0103920:	c0 
c0103921:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c0103928:	c0 
c0103929:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0103930:	00 
c0103931:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103938:	e8 c3 ca ff ff       	call   c0100400 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
c010393d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103940:	83 c0 02             	add    $0x2,%eax
c0103943:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103947:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010394a:	89 04 24             	mov    %eax,(%esp)
c010394d:	e8 23 fa ff ff       	call   c0103375 <find_vma>
c0103952:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma3 == NULL);
c0103955:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0103959:	74 24                	je     c010397f <check_vma_struct+0x2dd>
c010395b:	c7 44 24 0c 8f aa 10 	movl   $0xc010aa8f,0xc(%esp)
c0103962:	c0 
c0103963:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c010396a:	c0 
c010396b:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0103972:	00 
c0103973:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c010397a:	e8 81 ca ff ff       	call   c0100400 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
c010397f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103982:	83 c0 03             	add    $0x3,%eax
c0103985:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103989:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010398c:	89 04 24             	mov    %eax,(%esp)
c010398f:	e8 e1 f9 ff ff       	call   c0103375 <find_vma>
c0103994:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma4 == NULL);
c0103997:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c010399b:	74 24                	je     c01039c1 <check_vma_struct+0x31f>
c010399d:	c7 44 24 0c 9c aa 10 	movl   $0xc010aa9c,0xc(%esp)
c01039a4:	c0 
c01039a5:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c01039ac:	c0 
c01039ad:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c01039b4:	00 
c01039b5:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c01039bc:	e8 3f ca ff ff       	call   c0100400 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
c01039c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039c4:	83 c0 04             	add    $0x4,%eax
c01039c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01039cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01039ce:	89 04 24             	mov    %eax,(%esp)
c01039d1:	e8 9f f9 ff ff       	call   c0103375 <find_vma>
c01039d6:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma5 == NULL);
c01039d9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01039dd:	74 24                	je     c0103a03 <check_vma_struct+0x361>
c01039df:	c7 44 24 0c a9 aa 10 	movl   $0xc010aaa9,0xc(%esp)
c01039e6:	c0 
c01039e7:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c01039ee:	c0 
c01039ef:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01039f6:	00 
c01039f7:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c01039fe:	e8 fd c9 ff ff       	call   c0100400 <__panic>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
c0103a03:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103a06:	8b 50 04             	mov    0x4(%eax),%edx
c0103a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a0c:	39 c2                	cmp    %eax,%edx
c0103a0e:	75 10                	jne    c0103a20 <check_vma_struct+0x37e>
c0103a10:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103a13:	8b 40 08             	mov    0x8(%eax),%eax
c0103a16:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103a19:	83 c2 02             	add    $0x2,%edx
c0103a1c:	39 d0                	cmp    %edx,%eax
c0103a1e:	74 24                	je     c0103a44 <check_vma_struct+0x3a2>
c0103a20:	c7 44 24 0c b8 aa 10 	movl   $0xc010aab8,0xc(%esp)
c0103a27:	c0 
c0103a28:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c0103a2f:	c0 
c0103a30:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103a37:	00 
c0103a38:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103a3f:	e8 bc c9 ff ff       	call   c0100400 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
c0103a44:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103a47:	8b 50 04             	mov    0x4(%eax),%edx
c0103a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a4d:	39 c2                	cmp    %eax,%edx
c0103a4f:	75 10                	jne    c0103a61 <check_vma_struct+0x3bf>
c0103a51:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103a54:	8b 40 08             	mov    0x8(%eax),%eax
c0103a57:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103a5a:	83 c2 02             	add    $0x2,%edx
c0103a5d:	39 d0                	cmp    %edx,%eax
c0103a5f:	74 24                	je     c0103a85 <check_vma_struct+0x3e3>
c0103a61:	c7 44 24 0c e8 aa 10 	movl   $0xc010aae8,0xc(%esp)
c0103a68:	c0 
c0103a69:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c0103a70:	c0 
c0103a71:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103a78:	00 
c0103a79:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103a80:	e8 7b c9 ff ff       	call   c0100400 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
c0103a85:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0103a89:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103a8c:	89 d0                	mov    %edx,%eax
c0103a8e:	c1 e0 02             	shl    $0x2,%eax
c0103a91:	01 d0                	add    %edx,%eax
c0103a93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103a96:	0f 8d 22 fe ff ff    	jge    c01038be <check_vma_struct+0x21c>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
    }

    for (i = 4; i >= 0; i--)
c0103a9c:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0103aa3:	eb 6f                	jmp    c0103b14 <check_vma_struct+0x472>
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
c0103aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103aac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103aaf:	89 04 24             	mov    %eax,(%esp)
c0103ab2:	e8 be f8 ff ff       	call   c0103375 <find_vma>
c0103ab7:	89 45 b8             	mov    %eax,-0x48(%ebp)
        if (vma_below_5 != NULL)
c0103aba:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103abe:	74 27                	je     c0103ae7 <check_vma_struct+0x445>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
c0103ac0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ac3:	8b 50 08             	mov    0x8(%eax),%edx
c0103ac6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ac9:	8b 40 04             	mov    0x4(%eax),%eax
c0103acc:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0103ad0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103adb:	c7 04 24 18 ab 10 c0 	movl   $0xc010ab18,(%esp)
c0103ae2:	e8 c2 c7 ff ff       	call   c01002a9 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0103ae7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103aeb:	74 24                	je     c0103b11 <check_vma_struct+0x46f>
c0103aed:	c7 44 24 0c 3d ab 10 	movl   $0xc010ab3d,0xc(%esp)
c0103af4:	c0 
c0103af5:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c0103afc:	c0 
c0103afd:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103b04:	00 
c0103b05:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103b0c:	e8 ef c8 ff ff       	call   c0100400 <__panic>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
    }

    for (i = 4; i >= 0; i--)
c0103b11:	ff 4d f4             	decl   -0xc(%ebp)
c0103b14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b18:	79 8b                	jns    c0103aa5 <check_vma_struct+0x403>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0103b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b1d:	89 04 24             	mov    %eax,(%esp)
c0103b20:	e8 d8 fa ff ff       	call   c01035fd <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0103b25:	c7 04 24 54 ab 10 c0 	movl   $0xc010ab54,(%esp)
c0103b2c:	e8 78 c7 ff ff       	call   c01002a9 <cprintf>
}
c0103b31:	90                   	nop
c0103b32:	c9                   	leave  
c0103b33:	c3                   	ret    

c0103b34 <check_pgfault>:
struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void)
{
c0103b34:	55                   	push   %ebp
c0103b35:	89 e5                	mov    %esp,%ebp
c0103b37:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103b3a:	e8 0e 34 00 00       	call   c0106f4d <nr_free_pages>
c0103b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0103b42:	e8 7b f7 ff ff       	call   c01032c2 <mm_create>
c0103b47:	a3 58 b0 12 c0       	mov    %eax,0xc012b058
    assert(check_mm_struct != NULL);
c0103b4c:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c0103b51:	85 c0                	test   %eax,%eax
c0103b53:	75 24                	jne    c0103b79 <check_pgfault+0x45>
c0103b55:	c7 44 24 0c 73 ab 10 	movl   $0xc010ab73,0xc(%esp)
c0103b5c:	c0 
c0103b5d:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c0103b64:	c0 
c0103b65:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0103b6c:	00 
c0103b6d:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103b74:	e8 87 c8 ff ff       	call   c0100400 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0103b79:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c0103b7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0103b81:	8b 15 20 5a 12 c0    	mov    0xc0125a20,%edx
c0103b87:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b8a:	89 50 0c             	mov    %edx,0xc(%eax)
c0103b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b90:	8b 40 0c             	mov    0xc(%eax),%eax
c0103b93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0103b96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b99:	8b 00                	mov    (%eax),%eax
c0103b9b:	85 c0                	test   %eax,%eax
c0103b9d:	74 24                	je     c0103bc3 <check_pgfault+0x8f>
c0103b9f:	c7 44 24 0c 8b ab 10 	movl   $0xc010ab8b,0xc(%esp)
c0103ba6:	c0 
c0103ba7:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c0103bae:	c0 
c0103baf:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0103bb6:	00 
c0103bb7:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103bbe:	e8 3d c8 ff ff       	call   c0100400 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0103bc3:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0103bca:	00 
c0103bcb:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0103bd2:	00 
c0103bd3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0103bda:	e8 5b f7 ff ff       	call   c010333a <vma_create>
c0103bdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0103be2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103be6:	75 24                	jne    c0103c0c <check_pgfault+0xd8>
c0103be8:	c7 44 24 0c 1c aa 10 	movl   $0xc010aa1c,0xc(%esp)
c0103bef:	c0 
c0103bf0:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c0103bf7:	c0 
c0103bf8:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0103bff:	00 
c0103c00:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103c07:	e8 f4 c7 ff ff       	call   c0100400 <__panic>

    insert_vma_struct(mm, vma);
c0103c0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c13:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c16:	89 04 24             	mov    %eax,(%esp)
c0103c19:	e8 ad f8 ff ff       	call   c01034cb <insert_vma_struct>

    uintptr_t addr = 0x100;
c0103c1e:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0103c25:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103c28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c2f:	89 04 24             	mov    %eax,(%esp)
c0103c32:	e8 3e f7 ff ff       	call   c0103375 <find_vma>
c0103c37:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103c3a:	74 24                	je     c0103c60 <check_pgfault+0x12c>
c0103c3c:	c7 44 24 0c 99 ab 10 	movl   $0xc010ab99,0xc(%esp)
c0103c43:	c0 
c0103c44:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c0103c4b:	c0 
c0103c4c:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0103c53:	00 
c0103c54:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103c5b:	e8 a0 c7 ff ff       	call   c0100400 <__panic>

    int i, sum = 0;
c0103c60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i++)
c0103c67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c6e:	eb 16                	jmp    c0103c86 <check_pgfault+0x152>
    {
        *(char *)(addr + i) = i;
c0103c70:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103c73:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103c76:	01 d0                	add    %edx,%eax
c0103c78:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103c7b:	88 10                	mov    %dl,(%eax)
        sum += i;
c0103c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c80:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i++)
c0103c83:	ff 45 f4             	incl   -0xc(%ebp)
c0103c86:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0103c8a:	7e e4                	jle    c0103c70 <check_pgfault+0x13c>
    {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i++)
c0103c8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c93:	eb 14                	jmp    c0103ca9 <check_pgfault+0x175>
    {
        sum -= *(char *)(addr + i);
c0103c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103c98:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103c9b:	01 d0                	add    %edx,%eax
c0103c9d:	0f b6 00             	movzbl (%eax),%eax
c0103ca0:	0f be c0             	movsbl %al,%eax
c0103ca3:	29 45 f0             	sub    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i++)
    {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i++)
c0103ca6:	ff 45 f4             	incl   -0xc(%ebp)
c0103ca9:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0103cad:	7e e6                	jle    c0103c95 <check_pgfault+0x161>
    {
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0103caf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103cb3:	74 24                	je     c0103cd9 <check_pgfault+0x1a5>
c0103cb5:	c7 44 24 0c b3 ab 10 	movl   $0xc010abb3,0xc(%esp)
c0103cbc:	c0 
c0103cbd:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c0103cc4:	c0 
c0103cc5:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c0103ccc:	00 
c0103ccd:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103cd4:	e8 27 c7 ff ff       	call   c0100400 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0103cd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103cdc:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103cdf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103ce2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ce7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ceb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cee:	89 04 24             	mov    %eax,(%esp)
c0103cf1:	e8 f6 3a 00 00       	call   c01077ec <page_remove>
    free_page(pde2page(pgdir[0]));
c0103cf6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cf9:	8b 00                	mov    (%eax),%eax
c0103cfb:	89 04 24             	mov    %eax,(%esp)
c0103cfe:	e8 a7 f5 ff ff       	call   c01032aa <pde2page>
c0103d03:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d0a:	00 
c0103d0b:	89 04 24             	mov    %eax,(%esp)
c0103d0e:	e8 07 32 00 00       	call   c0106f1a <free_pages>
    pgdir[0] = 0;
c0103d13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0103d1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d1f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0103d26:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d29:	89 04 24             	mov    %eax,(%esp)
c0103d2c:	e8 cc f8 ff ff       	call   c01035fd <mm_destroy>
    check_mm_struct = NULL;
c0103d31:	c7 05 58 b0 12 c0 00 	movl   $0x0,0xc012b058
c0103d38:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0103d3b:	e8 0d 32 00 00       	call   c0106f4d <nr_free_pages>
c0103d40:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103d43:	74 24                	je     c0103d69 <check_pgfault+0x235>
c0103d45:	c7 44 24 0c bc ab 10 	movl   $0xc010abbc,0xc(%esp)
c0103d4c:	c0 
c0103d4d:	c7 44 24 08 7b a9 10 	movl   $0xc010a97b,0x8(%esp)
c0103d54:	c0 
c0103d55:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0103d5c:	00 
c0103d5d:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103d64:	e8 97 c6 ff ff       	call   c0100400 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0103d69:	c7 04 24 e3 ab 10 c0 	movl   $0xc010abe3,(%esp)
c0103d70:	e8 34 c5 ff ff       	call   c01002a9 <cprintf>
}
c0103d75:	90                   	nop
c0103d76:	c9                   	leave  
c0103d77:	c3                   	ret    

c0103d78 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr)
{
c0103d78:	55                   	push   %ebp
c0103d79:	89 e5                	mov    %esp,%ebp
c0103d7b:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0103d7e:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0103d85:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d8f:	89 04 24             	mov    %eax,(%esp)
c0103d92:	e8 de f5 ff ff       	call   c0103375 <find_vma>
c0103d97:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0103d9a:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0103d9f:	40                   	inc    %eax
c0103da0:	a3 64 8f 12 c0       	mov    %eax,0xc0128f64
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr)
c0103da5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103da9:	74 0b                	je     c0103db6 <do_pgfault+0x3e>
c0103dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103dae:	8b 40 04             	mov    0x4(%eax),%eax
c0103db1:	3b 45 10             	cmp    0x10(%ebp),%eax
c0103db4:	76 18                	jbe    c0103dce <do_pgfault+0x56>
    {
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0103db6:	8b 45 10             	mov    0x10(%ebp),%eax
c0103db9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103dbd:	c7 04 24 00 ac 10 c0 	movl   $0xc010ac00,(%esp)
c0103dc4:	e8 e0 c4 ff ff       	call   c01002a9 <cprintf>
        goto failed;
c0103dc9:	e9 b6 01 00 00       	jmp    c0103f84 <do_pgfault+0x20c>
    }
    //check the error_code
    switch (error_code & 3)
c0103dce:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103dd1:	83 e0 03             	and    $0x3,%eax
c0103dd4:	85 c0                	test   %eax,%eax
c0103dd6:	74 34                	je     c0103e0c <do_pgfault+0x94>
c0103dd8:	83 f8 01             	cmp    $0x1,%eax
c0103ddb:	74 1e                	je     c0103dfb <do_pgfault+0x83>
    {
    default:
        /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE))
c0103ddd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103de0:	8b 40 0c             	mov    0xc(%eax),%eax
c0103de3:	83 e0 02             	and    $0x2,%eax
c0103de6:	85 c0                	test   %eax,%eax
c0103de8:	75 40                	jne    c0103e2a <do_pgfault+0xb2>
        {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0103dea:	c7 04 24 30 ac 10 c0 	movl   $0xc010ac30,(%esp)
c0103df1:	e8 b3 c4 ff ff       	call   c01002a9 <cprintf>
            goto failed;
c0103df6:	e9 89 01 00 00       	jmp    c0103f84 <do_pgfault+0x20c>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0103dfb:	c7 04 24 90 ac 10 c0 	movl   $0xc010ac90,(%esp)
c0103e02:	e8 a2 c4 ff ff       	call   c01002a9 <cprintf>
        goto failed;
c0103e07:	e9 78 01 00 00       	jmp    c0103f84 <do_pgfault+0x20c>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
c0103e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e0f:	8b 40 0c             	mov    0xc(%eax),%eax
c0103e12:	83 e0 05             	and    $0x5,%eax
c0103e15:	85 c0                	test   %eax,%eax
c0103e17:	75 12                	jne    c0103e2b <do_pgfault+0xb3>
        {
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0103e19:	c7 04 24 c8 ac 10 c0 	movl   $0xc010acc8,(%esp)
c0103e20:	e8 84 c4 ff ff       	call   c01002a9 <cprintf>
            goto failed;
c0103e25:	e9 5a 01 00 00       	jmp    c0103f84 <do_pgfault+0x20c>
        if (!(vma->vm_flags & VM_WRITE))
        {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
c0103e2a:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0103e2b:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE)
c0103e32:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e35:	8b 40 0c             	mov    0xc(%eax),%eax
c0103e38:	83 e0 02             	and    $0x2,%eax
c0103e3b:	85 c0                	test   %eax,%eax
c0103e3d:	74 04                	je     c0103e43 <do_pgfault+0xcb>
    {
        perm |= PTE_W;
c0103e3f:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0103e43:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e46:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e51:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0103e54:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep = NULL;
c0103e5b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL)
c0103e62:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e65:	8b 40 0c             	mov    0xc(%eax),%eax
c0103e68:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103e6f:	00 
c0103e70:	8b 55 10             	mov    0x10(%ebp),%edx
c0103e73:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e77:	89 04 24             	mov    %eax,(%esp)
c0103e7a:	e8 02 37 00 00       	call   c0107581 <get_pte>
c0103e7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103e82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e86:	75 11                	jne    c0103e99 <do_pgfault+0x121>
    {
        cprintf("get_pte in do_pgfualt failed\n");
c0103e88:	c7 04 24 2b ad 10 c0 	movl   $0xc010ad2b,(%esp)
c0103e8f:	e8 15 c4 ff ff       	call   c01002a9 <cprintf>
        goto failed;
c0103e94:	e9 eb 00 00 00       	jmp    c0103f84 <do_pgfault+0x20c>
    }
    /*没有分配物理页*/
    if (*ptep == 0)
c0103e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e9c:	8b 00                	mov    (%eax),%eax
c0103e9e:	85 c0                	test   %eax,%eax
c0103ea0:	75 3a                	jne    c0103edc <do_pgfault+0x164>
    {
        /*alloc page 这里pgdir_alloc_page会自动将该页加入swapable链*/
        if (pgdir_alloc_page(mm->pgdir, addr, perm | PTE_P) == 0)
c0103ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ea5:	83 c8 01             	or     $0x1,%eax
c0103ea8:	89 c2                	mov    %eax,%edx
c0103eaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ead:	8b 40 0c             	mov    0xc(%eax),%eax
c0103eb0:	89 54 24 08          	mov    %edx,0x8(%esp)
c0103eb4:	8b 55 10             	mov    0x10(%ebp),%edx
c0103eb7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ebb:	89 04 24             	mov    %eax,(%esp)
c0103ebe:	e8 83 3a 00 00       	call   c0107946 <pgdir_alloc_page>
c0103ec3:	85 c0                	test   %eax,%eax
c0103ec5:	0f 85 b2 00 00 00    	jne    c0103f7d <do_pgfault+0x205>
        {
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
c0103ecb:	c7 04 24 4c ad 10 c0 	movl   $0xc010ad4c,(%esp)
c0103ed2:	e8 d2 c3 ff ff       	call   c01002a9 <cprintf>
            goto failed;
c0103ed7:	e9 a8 00 00 00       	jmp    c0103f84 <do_pgfault+0x20c>
        }
    }
    else
    {
        /*页在磁盘中*/
        if (swap_init_ok)
c0103edc:	a1 68 8f 12 c0       	mov    0xc0128f68,%eax
c0103ee1:	85 c0                	test   %eax,%eax
c0103ee3:	0f 84 86 00 00 00    	je     c0103f6f <do_pgfault+0x1f7>
        { //swap初始化完成
            struct Page *page = NULL;
c0103ee9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            /*读入一个页中 该物理页可能是尚未分配的物理页，也可能是从别的已分配物理页中取的*/
            if ((ret = swap_in(mm, addr, &page)) != 0)
c0103ef0:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0103ef3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103ef7:	8b 45 10             	mov    0x10(%ebp),%eax
c0103efa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103efe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f01:	89 04 24             	mov    %eax,(%esp)
c0103f04:	e8 85 03 00 00       	call   c010428e <swap_in>
c0103f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103f0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103f10:	74 0e                	je     c0103f20 <do_pgfault+0x1a8>
            {
                cprintf("swap_in in do_pgfault failed\n");
c0103f12:	c7 04 24 73 ad 10 c0 	movl   $0xc010ad73,(%esp)
c0103f19:	e8 8b c3 ff ff       	call   c01002a9 <cprintf>
c0103f1e:	eb 64                	jmp    c0103f84 <do_pgfault+0x20c>
                goto failed;
            }
            /*页表，设置虚拟地址和物理地址映射关系*/
            page_insert(mm->pgdir, page, addr, perm);
c0103f20:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103f23:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f26:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f29:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0103f2c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0103f30:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0103f33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0103f37:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f3b:	89 04 24             	mov    %eax,(%esp)
c0103f3e:	e8 ee 38 00 00       	call   c0107831 <page_insert>
            /*设置该页为swapable*/
            swap_map_swappable(mm, addr, page, 1);
c0103f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f46:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0103f4d:	00 
c0103f4e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103f52:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f59:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f5c:	89 04 24             	mov    %eax,(%esp)
c0103f5f:	e8 68 01 00 00       	call   c01040cc <swap_map_swappable>
            page->pra_vaddr = addr;
c0103f64:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f67:	8b 55 10             	mov    0x10(%ebp),%edx
c0103f6a:	89 50 1c             	mov    %edx,0x1c(%eax)
c0103f6d:	eb 0e                	jmp    c0103f7d <do_pgfault+0x205>
        }
        else
        {
            cprintf("swap_init is not ready\n");
c0103f6f:	c7 04 24 91 ad 10 c0 	movl   $0xc010ad91,(%esp)
c0103f76:	e8 2e c3 ff ff       	call   c01002a9 <cprintf>
            goto failed;
c0103f7b:	eb 07                	jmp    c0103f84 <do_pgfault+0x20c>
        }
    }

    ret = 0;
c0103f7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0103f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f87:	c9                   	leave  
c0103f88:	c3                   	ret    

c0103f89 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0103f89:	55                   	push   %ebp
c0103f8a:	89 e5                	mov    %esp,%ebp
c0103f8c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103f8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f92:	c1 e8 0c             	shr    $0xc,%eax
c0103f95:	89 c2                	mov    %eax,%edx
c0103f97:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0103f9c:	39 c2                	cmp    %eax,%edx
c0103f9e:	72 1c                	jb     c0103fbc <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103fa0:	c7 44 24 08 ac ad 10 	movl   $0xc010adac,0x8(%esp)
c0103fa7:	c0 
c0103fa8:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0103faf:	00 
c0103fb0:	c7 04 24 cb ad 10 c0 	movl   $0xc010adcb,(%esp)
c0103fb7:	e8 44 c4 ff ff       	call   c0100400 <__panic>
    }
    return &pages[PPN(pa)];
c0103fbc:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c0103fc1:	8b 55 08             	mov    0x8(%ebp),%edx
c0103fc4:	c1 ea 0c             	shr    $0xc,%edx
c0103fc7:	c1 e2 05             	shl    $0x5,%edx
c0103fca:	01 d0                	add    %edx,%eax
}
c0103fcc:	c9                   	leave  
c0103fcd:	c3                   	ret    

c0103fce <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103fce:	55                   	push   %ebp
c0103fcf:	89 e5                	mov    %esp,%ebp
c0103fd1:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103fd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fd7:	83 e0 01             	and    $0x1,%eax
c0103fda:	85 c0                	test   %eax,%eax
c0103fdc:	75 1c                	jne    c0103ffa <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103fde:	c7 44 24 08 dc ad 10 	movl   $0xc010addc,0x8(%esp)
c0103fe5:	c0 
c0103fe6:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0103fed:	00 
c0103fee:	c7 04 24 cb ad 10 c0 	movl   $0xc010adcb,(%esp)
c0103ff5:	e8 06 c4 ff ff       	call   c0100400 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103ffa:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ffd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104002:	89 04 24             	mov    %eax,(%esp)
c0104005:	e8 7f ff ff ff       	call   c0103f89 <pa2page>
}
c010400a:	c9                   	leave  
c010400b:	c3                   	ret    

c010400c <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c010400c:	55                   	push   %ebp
c010400d:	89 e5                	mov    %esp,%ebp
c010400f:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0104012:	e8 1f 47 00 00       	call   c0108736 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0104017:	a1 fc b0 12 c0       	mov    0xc012b0fc,%eax
c010401c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0104021:	76 0c                	jbe    c010402f <swap_init+0x23>
c0104023:	a1 fc b0 12 c0       	mov    0xc012b0fc,%eax
c0104028:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c010402d:	76 25                	jbe    c0104054 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c010402f:	a1 fc b0 12 c0       	mov    0xc012b0fc,%eax
c0104034:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104038:	c7 44 24 08 fd ad 10 	movl   $0xc010adfd,0x8(%esp)
c010403f:	c0 
c0104040:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c0104047:	00 
c0104048:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c010404f:	e8 ac c3 ff ff       	call   c0100400 <__panic>
     }
     

     sm = &swap_manager_fifo;
c0104054:	c7 05 70 8f 12 c0 00 	movl   $0xc0125a00,0xc0128f70
c010405b:	5a 12 c0 
     int r = sm->init();
c010405e:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c0104063:	8b 40 04             	mov    0x4(%eax),%eax
c0104066:	ff d0                	call   *%eax
c0104068:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c010406b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010406f:	75 26                	jne    c0104097 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0104071:	c7 05 68 8f 12 c0 01 	movl   $0x1,0xc0128f68
c0104078:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c010407b:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c0104080:	8b 00                	mov    (%eax),%eax
c0104082:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104086:	c7 04 24 27 ae 10 c0 	movl   $0xc010ae27,(%esp)
c010408d:	e8 17 c2 ff ff       	call   c01002a9 <cprintf>
          check_swap();
c0104092:	e8 9e 04 00 00       	call   c0104535 <check_swap>
     }

     return r;
c0104097:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010409a:	c9                   	leave  
c010409b:	c3                   	ret    

c010409c <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c010409c:	55                   	push   %ebp
c010409d:	89 e5                	mov    %esp,%ebp
c010409f:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c01040a2:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c01040a7:	8b 40 08             	mov    0x8(%eax),%eax
c01040aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01040ad:	89 14 24             	mov    %edx,(%esp)
c01040b0:	ff d0                	call   *%eax
}
c01040b2:	c9                   	leave  
c01040b3:	c3                   	ret    

c01040b4 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c01040b4:	55                   	push   %ebp
c01040b5:	89 e5                	mov    %esp,%ebp
c01040b7:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c01040ba:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c01040bf:	8b 40 0c             	mov    0xc(%eax),%eax
c01040c2:	8b 55 08             	mov    0x8(%ebp),%edx
c01040c5:	89 14 24             	mov    %edx,(%esp)
c01040c8:	ff d0                	call   *%eax
}
c01040ca:	c9                   	leave  
c01040cb:	c3                   	ret    

c01040cc <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01040cc:	55                   	push   %ebp
c01040cd:	89 e5                	mov    %esp,%ebp
c01040cf:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c01040d2:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c01040d7:	8b 40 10             	mov    0x10(%eax),%eax
c01040da:	8b 55 14             	mov    0x14(%ebp),%edx
c01040dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01040e1:	8b 55 10             	mov    0x10(%ebp),%edx
c01040e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01040e8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040eb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01040ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01040f2:	89 14 24             	mov    %edx,(%esp)
c01040f5:	ff d0                	call   *%eax
}
c01040f7:	c9                   	leave  
c01040f8:	c3                   	ret    

c01040f9 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01040f9:	55                   	push   %ebp
c01040fa:	89 e5                	mov    %esp,%ebp
c01040fc:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c01040ff:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c0104104:	8b 40 14             	mov    0x14(%eax),%eax
c0104107:	8b 55 0c             	mov    0xc(%ebp),%edx
c010410a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010410e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104111:	89 14 24             	mov    %edx,(%esp)
c0104114:	ff d0                	call   *%eax
}
c0104116:	c9                   	leave  
c0104117:	c3                   	ret    

c0104118 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0104118:	55                   	push   %ebp
c0104119:	89 e5                	mov    %esp,%ebp
c010411b:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c010411e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104125:	e9 53 01 00 00       	jmp    c010427d <swap_out+0x165>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c010412a:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c010412f:	8b 40 18             	mov    0x18(%eax),%eax
c0104132:	8b 55 10             	mov    0x10(%ebp),%edx
c0104135:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104139:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c010413c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104140:	8b 55 08             	mov    0x8(%ebp),%edx
c0104143:	89 14 24             	mov    %edx,(%esp)
c0104146:	ff d0                	call   *%eax
c0104148:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c010414b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010414f:	74 18                	je     c0104169 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0104151:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104154:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104158:	c7 04 24 3c ae 10 c0 	movl   $0xc010ae3c,(%esp)
c010415f:	e8 45 c1 ff ff       	call   c01002a9 <cprintf>
c0104164:	e9 20 01 00 00       	jmp    c0104289 <swap_out+0x171>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0104169:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010416c:	8b 40 1c             	mov    0x1c(%eax),%eax
c010416f:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0104172:	8b 45 08             	mov    0x8(%ebp),%eax
c0104175:	8b 40 0c             	mov    0xc(%eax),%eax
c0104178:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010417f:	00 
c0104180:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104183:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104187:	89 04 24             	mov    %eax,(%esp)
c010418a:	e8 f2 33 00 00       	call   c0107581 <get_pte>
c010418f:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0104192:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104195:	8b 00                	mov    (%eax),%eax
c0104197:	83 e0 01             	and    $0x1,%eax
c010419a:	85 c0                	test   %eax,%eax
c010419c:	75 24                	jne    c01041c2 <swap_out+0xaa>
c010419e:	c7 44 24 0c 69 ae 10 	movl   $0xc010ae69,0xc(%esp)
c01041a5:	c0 
c01041a6:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c01041ad:	c0 
c01041ae:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01041b5:	00 
c01041b6:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c01041bd:	e8 3e c2 ff ff       	call   c0100400 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c01041c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01041c8:	8b 52 1c             	mov    0x1c(%edx),%edx
c01041cb:	c1 ea 0c             	shr    $0xc,%edx
c01041ce:	42                   	inc    %edx
c01041cf:	c1 e2 08             	shl    $0x8,%edx
c01041d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01041d6:	89 14 24             	mov    %edx,(%esp)
c01041d9:	e8 13 46 00 00       	call   c01087f1 <swapfs_write>
c01041de:	85 c0                	test   %eax,%eax
c01041e0:	74 34                	je     c0104216 <swap_out+0xfe>
                    cprintf("SWAP: failed to save\n");
c01041e2:	c7 04 24 93 ae 10 c0 	movl   $0xc010ae93,(%esp)
c01041e9:	e8 bb c0 ff ff       	call   c01002a9 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c01041ee:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c01041f3:	8b 40 10             	mov    0x10(%eax),%eax
c01041f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01041f9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104200:	00 
c0104201:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104205:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104208:	89 54 24 04          	mov    %edx,0x4(%esp)
c010420c:	8b 55 08             	mov    0x8(%ebp),%edx
c010420f:	89 14 24             	mov    %edx,(%esp)
c0104212:	ff d0                	call   *%eax
c0104214:	eb 64                	jmp    c010427a <swap_out+0x162>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0104216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104219:	8b 40 1c             	mov    0x1c(%eax),%eax
c010421c:	c1 e8 0c             	shr    $0xc,%eax
c010421f:	40                   	inc    %eax
c0104220:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104224:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104227:	89 44 24 08          	mov    %eax,0x8(%esp)
c010422b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010422e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104232:	c7 04 24 ac ae 10 c0 	movl   $0xc010aeac,(%esp)
c0104239:	e8 6b c0 ff ff       	call   c01002a9 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c010423e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104241:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104244:	c1 e8 0c             	shr    $0xc,%eax
c0104247:	40                   	inc    %eax
c0104248:	c1 e0 08             	shl    $0x8,%eax
c010424b:	89 c2                	mov    %eax,%edx
c010424d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104250:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0104252:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104255:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010425c:	00 
c010425d:	89 04 24             	mov    %eax,(%esp)
c0104260:	e8 b5 2c 00 00       	call   c0106f1a <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0104265:	8b 45 08             	mov    0x8(%ebp),%eax
c0104268:	8b 40 0c             	mov    0xc(%eax),%eax
c010426b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010426e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104272:	89 04 24             	mov    %eax,(%esp)
c0104275:	e8 70 36 00 00       	call   c01078ea <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c010427a:	ff 45 f4             	incl   -0xc(%ebp)
c010427d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104280:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104283:	0f 85 a1 fe ff ff    	jne    c010412a <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0104289:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010428c:	c9                   	leave  
c010428d:	c3                   	ret    

c010428e <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c010428e:	55                   	push   %ebp
c010428f:	89 e5                	mov    %esp,%ebp
c0104291:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0104294:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010429b:	e8 0f 2c 00 00       	call   c0106eaf <alloc_pages>
c01042a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c01042a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042a7:	75 24                	jne    c01042cd <swap_in+0x3f>
c01042a9:	c7 44 24 0c ec ae 10 	movl   $0xc010aeec,0xc(%esp)
c01042b0:	c0 
c01042b1:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c01042b8:	c0 
c01042b9:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c01042c0:	00 
c01042c1:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c01042c8:	e8 33 c1 ff ff       	call   c0100400 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c01042cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01042d0:	8b 40 0c             	mov    0xc(%eax),%eax
c01042d3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01042da:	00 
c01042db:	8b 55 0c             	mov    0xc(%ebp),%edx
c01042de:	89 54 24 04          	mov    %edx,0x4(%esp)
c01042e2:	89 04 24             	mov    %eax,(%esp)
c01042e5:	e8 97 32 00 00       	call   c0107581 <get_pte>
c01042ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c01042ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042f0:	8b 00                	mov    (%eax),%eax
c01042f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01042f5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01042f9:	89 04 24             	mov    %eax,(%esp)
c01042fc:	e8 7e 44 00 00       	call   c010877f <swapfs_read>
c0104301:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104304:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104308:	74 2a                	je     c0104334 <swap_in+0xa6>
     {
        assert(r!=0);
c010430a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010430e:	75 24                	jne    c0104334 <swap_in+0xa6>
c0104310:	c7 44 24 0c f9 ae 10 	movl   $0xc010aef9,0xc(%esp)
c0104317:	c0 
c0104318:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c010431f:	c0 
c0104320:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c0104327:	00 
c0104328:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c010432f:	e8 cc c0 ff ff       	call   c0100400 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0104334:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104337:	8b 00                	mov    (%eax),%eax
c0104339:	c1 e8 08             	shr    $0x8,%eax
c010433c:	89 c2                	mov    %eax,%edx
c010433e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104341:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104345:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104349:	c7 04 24 00 af 10 c0 	movl   $0xc010af00,(%esp)
c0104350:	e8 54 bf ff ff       	call   c01002a9 <cprintf>
     *ptr_result=result;
c0104355:	8b 45 10             	mov    0x10(%ebp),%eax
c0104358:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010435b:	89 10                	mov    %edx,(%eax)
     return 0;
c010435d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104362:	c9                   	leave  
c0104363:	c3                   	ret    

c0104364 <check_content_set>:



static inline void
check_content_set(void)
{
c0104364:	55                   	push   %ebp
c0104365:	89 e5                	mov    %esp,%ebp
c0104367:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c010436a:	b8 00 10 00 00       	mov    $0x1000,%eax
c010436f:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0104372:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0104377:	83 f8 01             	cmp    $0x1,%eax
c010437a:	74 24                	je     c01043a0 <check_content_set+0x3c>
c010437c:	c7 44 24 0c 3e af 10 	movl   $0xc010af3e,0xc(%esp)
c0104383:	c0 
c0104384:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c010438b:	c0 
c010438c:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0104393:	00 
c0104394:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c010439b:	e8 60 c0 ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01043a0:	b8 10 10 00 00       	mov    $0x1010,%eax
c01043a5:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01043a8:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01043ad:	83 f8 01             	cmp    $0x1,%eax
c01043b0:	74 24                	je     c01043d6 <check_content_set+0x72>
c01043b2:	c7 44 24 0c 3e af 10 	movl   $0xc010af3e,0xc(%esp)
c01043b9:	c0 
c01043ba:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c01043c1:	c0 
c01043c2:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c01043c9:	00 
c01043ca:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c01043d1:	e8 2a c0 ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c01043d6:	b8 00 20 00 00       	mov    $0x2000,%eax
c01043db:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01043de:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01043e3:	83 f8 02             	cmp    $0x2,%eax
c01043e6:	74 24                	je     c010440c <check_content_set+0xa8>
c01043e8:	c7 44 24 0c 4d af 10 	movl   $0xc010af4d,0xc(%esp)
c01043ef:	c0 
c01043f0:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c01043f7:	c0 
c01043f8:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01043ff:	00 
c0104400:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c0104407:	e8 f4 bf ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c010440c:	b8 10 20 00 00       	mov    $0x2010,%eax
c0104411:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0104414:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0104419:	83 f8 02             	cmp    $0x2,%eax
c010441c:	74 24                	je     c0104442 <check_content_set+0xde>
c010441e:	c7 44 24 0c 4d af 10 	movl   $0xc010af4d,0xc(%esp)
c0104425:	c0 
c0104426:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c010442d:	c0 
c010442e:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0104435:	00 
c0104436:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c010443d:	e8 be bf ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0104442:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104447:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c010444a:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c010444f:	83 f8 03             	cmp    $0x3,%eax
c0104452:	74 24                	je     c0104478 <check_content_set+0x114>
c0104454:	c7 44 24 0c 5c af 10 	movl   $0xc010af5c,0xc(%esp)
c010445b:	c0 
c010445c:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c0104463:	c0 
c0104464:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c010446b:	00 
c010446c:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c0104473:	e8 88 bf ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0104478:	b8 10 30 00 00       	mov    $0x3010,%eax
c010447d:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0104480:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0104485:	83 f8 03             	cmp    $0x3,%eax
c0104488:	74 24                	je     c01044ae <check_content_set+0x14a>
c010448a:	c7 44 24 0c 5c af 10 	movl   $0xc010af5c,0xc(%esp)
c0104491:	c0 
c0104492:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c0104499:	c0 
c010449a:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c01044a1:	00 
c01044a2:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c01044a9:	e8 52 bf ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01044ae:	b8 00 40 00 00       	mov    $0x4000,%eax
c01044b3:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01044b6:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01044bb:	83 f8 04             	cmp    $0x4,%eax
c01044be:	74 24                	je     c01044e4 <check_content_set+0x180>
c01044c0:	c7 44 24 0c 6b af 10 	movl   $0xc010af6b,0xc(%esp)
c01044c7:	c0 
c01044c8:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c01044cf:	c0 
c01044d0:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01044d7:	00 
c01044d8:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c01044df:	e8 1c bf ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c01044e4:	b8 10 40 00 00       	mov    $0x4010,%eax
c01044e9:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01044ec:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01044f1:	83 f8 04             	cmp    $0x4,%eax
c01044f4:	74 24                	je     c010451a <check_content_set+0x1b6>
c01044f6:	c7 44 24 0c 6b af 10 	movl   $0xc010af6b,0xc(%esp)
c01044fd:	c0 
c01044fe:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c0104505:	c0 
c0104506:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c010450d:	00 
c010450e:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c0104515:	e8 e6 be ff ff       	call   c0100400 <__panic>
}
c010451a:	90                   	nop
c010451b:	c9                   	leave  
c010451c:	c3                   	ret    

c010451d <check_content_access>:

static inline int
check_content_access(void)
{
c010451d:	55                   	push   %ebp
c010451e:	89 e5                	mov    %esp,%ebp
c0104520:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0104523:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c0104528:	8b 40 1c             	mov    0x1c(%eax),%eax
c010452b:	ff d0                	call   *%eax
c010452d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0104530:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104533:	c9                   	leave  
c0104534:	c3                   	ret    

c0104535 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0104535:	55                   	push   %ebp
c0104536:	89 e5                	mov    %esp,%ebp
c0104538:	83 ec 78             	sub    $0x78,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c010453b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104542:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0104549:	c7 45 e8 2c b1 12 c0 	movl   $0xc012b12c,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0104550:	eb 6a                	jmp    c01045bc <check_swap+0x87>
        struct Page *p = le2page(le, page_link);
c0104552:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104555:	83 e8 0c             	sub    $0xc,%eax
c0104558:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(PageProperty(p));
c010455b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010455e:	83 c0 04             	add    $0x4,%eax
c0104561:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0104568:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010456b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010456e:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104571:	0f a3 10             	bt     %edx,(%eax)
c0104574:	19 c0                	sbb    %eax,%eax
c0104576:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0104579:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c010457d:	0f 95 c0             	setne  %al
c0104580:	0f b6 c0             	movzbl %al,%eax
c0104583:	85 c0                	test   %eax,%eax
c0104585:	75 24                	jne    c01045ab <check_swap+0x76>
c0104587:	c7 44 24 0c 7a af 10 	movl   $0xc010af7a,0xc(%esp)
c010458e:	c0 
c010458f:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c0104596:	c0 
c0104597:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c010459e:	00 
c010459f:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c01045a6:	e8 55 be ff ff       	call   c0100400 <__panic>
        count ++, total += p->property;
c01045ab:	ff 45 f4             	incl   -0xc(%ebp)
c01045ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045b1:	8b 50 08             	mov    0x8(%eax),%edx
c01045b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045b7:	01 d0                	add    %edx,%eax
c01045b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01045bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01045c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045c5:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01045c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01045cb:	81 7d e8 2c b1 12 c0 	cmpl   $0xc012b12c,-0x18(%ebp)
c01045d2:	0f 85 7a ff ff ff    	jne    c0104552 <check_swap+0x1d>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c01045d8:	e8 70 29 00 00       	call   c0106f4d <nr_free_pages>
c01045dd:	89 c2                	mov    %eax,%edx
c01045df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045e2:	39 c2                	cmp    %eax,%edx
c01045e4:	74 24                	je     c010460a <check_swap+0xd5>
c01045e6:	c7 44 24 0c 8a af 10 	movl   $0xc010af8a,0xc(%esp)
c01045ed:	c0 
c01045ee:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c01045f5:	c0 
c01045f6:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01045fd:	00 
c01045fe:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c0104605:	e8 f6 bd ff ff       	call   c0100400 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c010460a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010460d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104611:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104614:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104618:	c7 04 24 a4 af 10 c0 	movl   $0xc010afa4,(%esp)
c010461f:	e8 85 bc ff ff       	call   c01002a9 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0104624:	e8 99 ec ff ff       	call   c01032c2 <mm_create>
c0104629:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(mm != NULL);
c010462c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104630:	75 24                	jne    c0104656 <check_swap+0x121>
c0104632:	c7 44 24 0c ca af 10 	movl   $0xc010afca,0xc(%esp)
c0104639:	c0 
c010463a:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c0104641:	c0 
c0104642:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0104649:	00 
c010464a:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c0104651:	e8 aa bd ff ff       	call   c0100400 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0104656:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c010465b:	85 c0                	test   %eax,%eax
c010465d:	74 24                	je     c0104683 <check_swap+0x14e>
c010465f:	c7 44 24 0c d5 af 10 	movl   $0xc010afd5,0xc(%esp)
c0104666:	c0 
c0104667:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c010466e:	c0 
c010466f:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0104676:	00 
c0104677:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c010467e:	e8 7d bd ff ff       	call   c0100400 <__panic>

     check_mm_struct = mm;
c0104683:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104686:	a3 58 b0 12 c0       	mov    %eax,0xc012b058

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c010468b:	8b 15 20 5a 12 c0    	mov    0xc0125a20,%edx
c0104691:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104694:	89 50 0c             	mov    %edx,0xc(%eax)
c0104697:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010469a:	8b 40 0c             	mov    0xc(%eax),%eax
c010469d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(pgdir[0] == 0);
c01046a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01046a3:	8b 00                	mov    (%eax),%eax
c01046a5:	85 c0                	test   %eax,%eax
c01046a7:	74 24                	je     c01046cd <check_swap+0x198>
c01046a9:	c7 44 24 0c ed af 10 	movl   $0xc010afed,0xc(%esp)
c01046b0:	c0 
c01046b1:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c01046b8:	c0 
c01046b9:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01046c0:	00 
c01046c1:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c01046c8:	e8 33 bd ff ff       	call   c0100400 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01046cd:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c01046d4:	00 
c01046d5:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c01046dc:	00 
c01046dd:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c01046e4:	e8 51 ec ff ff       	call   c010333a <vma_create>
c01046e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
     assert(vma != NULL);
c01046ec:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01046f0:	75 24                	jne    c0104716 <check_swap+0x1e1>
c01046f2:	c7 44 24 0c fb af 10 	movl   $0xc010affb,0xc(%esp)
c01046f9:	c0 
c01046fa:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c0104701:	c0 
c0104702:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0104709:	00 
c010470a:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c0104711:	e8 ea bc ff ff       	call   c0100400 <__panic>

     insert_vma_struct(mm, vma);
c0104716:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104719:	89 44 24 04          	mov    %eax,0x4(%esp)
c010471d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104720:	89 04 24             	mov    %eax,(%esp)
c0104723:	e8 a3 ed ff ff       	call   c01034cb <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0104728:	c7 04 24 08 b0 10 c0 	movl   $0xc010b008,(%esp)
c010472f:	e8 75 bb ff ff       	call   c01002a9 <cprintf>
     pte_t *temp_ptep=NULL;
c0104734:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c010473b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010473e:	8b 40 0c             	mov    0xc(%eax),%eax
c0104741:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104748:	00 
c0104749:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104750:	00 
c0104751:	89 04 24             	mov    %eax,(%esp)
c0104754:	e8 28 2e 00 00       	call   c0107581 <get_pte>
c0104759:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(temp_ptep!= NULL);
c010475c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104760:	75 24                	jne    c0104786 <check_swap+0x251>
c0104762:	c7 44 24 0c 3c b0 10 	movl   $0xc010b03c,0xc(%esp)
c0104769:	c0 
c010476a:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c0104771:	c0 
c0104772:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0104779:	00 
c010477a:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c0104781:	e8 7a bc ff ff       	call   c0100400 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0104786:	c7 04 24 50 b0 10 c0 	movl   $0xc010b050,(%esp)
c010478d:	e8 17 bb ff ff       	call   c01002a9 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104792:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104799:	e9 a4 00 00 00       	jmp    c0104842 <check_swap+0x30d>
          check_rp[i] = alloc_page();
c010479e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01047a5:	e8 05 27 00 00       	call   c0106eaf <alloc_pages>
c01047aa:	89 c2                	mov    %eax,%edx
c01047ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047af:	89 14 85 60 b0 12 c0 	mov    %edx,-0x3fed4fa0(,%eax,4)
          assert(check_rp[i] != NULL );
c01047b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047b9:	8b 04 85 60 b0 12 c0 	mov    -0x3fed4fa0(,%eax,4),%eax
c01047c0:	85 c0                	test   %eax,%eax
c01047c2:	75 24                	jne    c01047e8 <check_swap+0x2b3>
c01047c4:	c7 44 24 0c 74 b0 10 	movl   $0xc010b074,0xc(%esp)
c01047cb:	c0 
c01047cc:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c01047d3:	c0 
c01047d4:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01047db:	00 
c01047dc:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c01047e3:	e8 18 bc ff ff       	call   c0100400 <__panic>
          assert(!PageProperty(check_rp[i]));
c01047e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047eb:	8b 04 85 60 b0 12 c0 	mov    -0x3fed4fa0(,%eax,4),%eax
c01047f2:	83 c0 04             	add    $0x4,%eax
c01047f5:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01047fc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01047ff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104802:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104805:	0f a3 10             	bt     %edx,(%eax)
c0104808:	19 c0                	sbb    %eax,%eax
c010480a:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c010480d:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0104811:	0f 95 c0             	setne  %al
c0104814:	0f b6 c0             	movzbl %al,%eax
c0104817:	85 c0                	test   %eax,%eax
c0104819:	74 24                	je     c010483f <check_swap+0x30a>
c010481b:	c7 44 24 0c 88 b0 10 	movl   $0xc010b088,0xc(%esp)
c0104822:	c0 
c0104823:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c010482a:	c0 
c010482b:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0104832:	00 
c0104833:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c010483a:	e8 c1 bb ff ff       	call   c0100400 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010483f:	ff 45 ec             	incl   -0x14(%ebp)
c0104842:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104846:	0f 8e 52 ff ff ff    	jle    c010479e <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c010484c:	a1 2c b1 12 c0       	mov    0xc012b12c,%eax
c0104851:	8b 15 30 b1 12 c0    	mov    0xc012b130,%edx
c0104857:	89 45 98             	mov    %eax,-0x68(%ebp)
c010485a:	89 55 9c             	mov    %edx,-0x64(%ebp)
c010485d:	c7 45 c0 2c b1 12 c0 	movl   $0xc012b12c,-0x40(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104864:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104867:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010486a:	89 50 04             	mov    %edx,0x4(%eax)
c010486d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104870:	8b 50 04             	mov    0x4(%eax),%edx
c0104873:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104876:	89 10                	mov    %edx,(%eax)
c0104878:	c7 45 c8 2c b1 12 c0 	movl   $0xc012b12c,-0x38(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010487f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104882:	8b 40 04             	mov    0x4(%eax),%eax
c0104885:	39 45 c8             	cmp    %eax,-0x38(%ebp)
c0104888:	0f 94 c0             	sete   %al
c010488b:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c010488e:	85 c0                	test   %eax,%eax
c0104890:	75 24                	jne    c01048b6 <check_swap+0x381>
c0104892:	c7 44 24 0c a3 b0 10 	movl   $0xc010b0a3,0xc(%esp)
c0104899:	c0 
c010489a:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c01048a1:	c0 
c01048a2:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01048a9:	00 
c01048aa:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c01048b1:	e8 4a bb ff ff       	call   c0100400 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c01048b6:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c01048bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
     nr_free = 0;
c01048be:	c7 05 34 b1 12 c0 00 	movl   $0x0,0xc012b134
c01048c5:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01048c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01048cf:	eb 1d                	jmp    c01048ee <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c01048d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048d4:	8b 04 85 60 b0 12 c0 	mov    -0x3fed4fa0(,%eax,4),%eax
c01048db:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01048e2:	00 
c01048e3:	89 04 24             	mov    %eax,(%esp)
c01048e6:	e8 2f 26 00 00       	call   c0106f1a <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01048eb:	ff 45 ec             	incl   -0x14(%ebp)
c01048ee:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01048f2:	7e dd                	jle    c01048d1 <check_swap+0x39c>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c01048f4:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c01048f9:	83 f8 04             	cmp    $0x4,%eax
c01048fc:	74 24                	je     c0104922 <check_swap+0x3ed>
c01048fe:	c7 44 24 0c bc b0 10 	movl   $0xc010b0bc,0xc(%esp)
c0104905:	c0 
c0104906:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c010490d:	c0 
c010490e:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0104915:	00 
c0104916:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c010491d:	e8 de ba ff ff       	call   c0100400 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0104922:	c7 04 24 e0 b0 10 c0 	movl   $0xc010b0e0,(%esp)
c0104929:	e8 7b b9 ff ff       	call   c01002a9 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c010492e:	c7 05 64 8f 12 c0 00 	movl   $0x0,0xc0128f64
c0104935:	00 00 00 
     
     check_content_set();
c0104938:	e8 27 fa ff ff       	call   c0104364 <check_content_set>
     assert( nr_free == 0);         
c010493d:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0104942:	85 c0                	test   %eax,%eax
c0104944:	74 24                	je     c010496a <check_swap+0x435>
c0104946:	c7 44 24 0c 07 b1 10 	movl   $0xc010b107,0xc(%esp)
c010494d:	c0 
c010494e:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c0104955:	c0 
c0104956:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c010495d:	00 
c010495e:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c0104965:	e8 96 ba ff ff       	call   c0100400 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010496a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104971:	eb 25                	jmp    c0104998 <check_swap+0x463>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0104973:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104976:	c7 04 85 80 b0 12 c0 	movl   $0xffffffff,-0x3fed4f80(,%eax,4)
c010497d:	ff ff ff ff 
c0104981:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104984:	8b 14 85 80 b0 12 c0 	mov    -0x3fed4f80(,%eax,4),%edx
c010498b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010498e:	89 14 85 c0 b0 12 c0 	mov    %edx,-0x3fed4f40(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0104995:	ff 45 ec             	incl   -0x14(%ebp)
c0104998:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c010499c:	7e d5                	jle    c0104973 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010499e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01049a5:	e9 ec 00 00 00       	jmp    c0104a96 <check_swap+0x561>
         check_ptep[i]=0;
c01049aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049ad:	c7 04 85 14 b1 12 c0 	movl   $0x0,-0x3fed4eec(,%eax,4)
c01049b4:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c01049b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049bb:	40                   	inc    %eax
c01049bc:	c1 e0 0c             	shl    $0xc,%eax
c01049bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049c6:	00 
c01049c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01049cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01049ce:	89 04 24             	mov    %eax,(%esp)
c01049d1:	e8 ab 2b 00 00       	call   c0107581 <get_pte>
c01049d6:	89 c2                	mov    %eax,%edx
c01049d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049db:	89 14 85 14 b1 12 c0 	mov    %edx,-0x3fed4eec(,%eax,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c01049e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049e5:	8b 04 85 14 b1 12 c0 	mov    -0x3fed4eec(,%eax,4),%eax
c01049ec:	85 c0                	test   %eax,%eax
c01049ee:	75 24                	jne    c0104a14 <check_swap+0x4df>
c01049f0:	c7 44 24 0c 14 b1 10 	movl   $0xc010b114,0xc(%esp)
c01049f7:	c0 
c01049f8:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c01049ff:	c0 
c0104a00:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0104a07:	00 
c0104a08:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c0104a0f:	e8 ec b9 ff ff       	call   c0100400 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0104a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a17:	8b 04 85 14 b1 12 c0 	mov    -0x3fed4eec(,%eax,4),%eax
c0104a1e:	8b 00                	mov    (%eax),%eax
c0104a20:	89 04 24             	mov    %eax,(%esp)
c0104a23:	e8 a6 f5 ff ff       	call   c0103fce <pte2page>
c0104a28:	89 c2                	mov    %eax,%edx
c0104a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a2d:	8b 04 85 60 b0 12 c0 	mov    -0x3fed4fa0(,%eax,4),%eax
c0104a34:	39 c2                	cmp    %eax,%edx
c0104a36:	74 24                	je     c0104a5c <check_swap+0x527>
c0104a38:	c7 44 24 0c 2c b1 10 	movl   $0xc010b12c,0xc(%esp)
c0104a3f:	c0 
c0104a40:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c0104a47:	c0 
c0104a48:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0104a4f:	00 
c0104a50:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c0104a57:	e8 a4 b9 ff ff       	call   c0100400 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0104a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a5f:	8b 04 85 14 b1 12 c0 	mov    -0x3fed4eec(,%eax,4),%eax
c0104a66:	8b 00                	mov    (%eax),%eax
c0104a68:	83 e0 01             	and    $0x1,%eax
c0104a6b:	85 c0                	test   %eax,%eax
c0104a6d:	75 24                	jne    c0104a93 <check_swap+0x55e>
c0104a6f:	c7 44 24 0c 54 b1 10 	movl   $0xc010b154,0xc(%esp)
c0104a76:	c0 
c0104a77:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c0104a7e:	c0 
c0104a7f:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104a86:	00 
c0104a87:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c0104a8e:	e8 6d b9 ff ff       	call   c0100400 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104a93:	ff 45 ec             	incl   -0x14(%ebp)
c0104a96:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104a9a:	0f 8e 0a ff ff ff    	jle    c01049aa <check_swap+0x475>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0104aa0:	c7 04 24 70 b1 10 c0 	movl   $0xc010b170,(%esp)
c0104aa7:	e8 fd b7 ff ff       	call   c01002a9 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0104aac:	e8 6c fa ff ff       	call   c010451d <check_content_access>
c0104ab1:	89 45 b8             	mov    %eax,-0x48(%ebp)
     assert(ret==0);
c0104ab4:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104ab8:	74 24                	je     c0104ade <check_swap+0x5a9>
c0104aba:	c7 44 24 0c 96 b1 10 	movl   $0xc010b196,0xc(%esp)
c0104ac1:	c0 
c0104ac2:	c7 44 24 08 7e ae 10 	movl   $0xc010ae7e,0x8(%esp)
c0104ac9:	c0 
c0104aca:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0104ad1:	00 
c0104ad2:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c0104ad9:	e8 22 b9 ff ff       	call   c0100400 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104ade:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104ae5:	eb 1d                	jmp    c0104b04 <check_swap+0x5cf>
         free_pages(check_rp[i],1);
c0104ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104aea:	8b 04 85 60 b0 12 c0 	mov    -0x3fed4fa0(,%eax,4),%eax
c0104af1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104af8:	00 
c0104af9:	89 04 24             	mov    %eax,(%esp)
c0104afc:	e8 19 24 00 00       	call   c0106f1a <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104b01:	ff 45 ec             	incl   -0x14(%ebp)
c0104b04:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104b08:	7e dd                	jle    c0104ae7 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0104b0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104b0d:	89 04 24             	mov    %eax,(%esp)
c0104b10:	e8 e8 ea ff ff       	call   c01035fd <mm_destroy>
         
     nr_free = nr_free_store;
c0104b15:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104b18:	a3 34 b1 12 c0       	mov    %eax,0xc012b134
     free_list = free_list_store;
c0104b1d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104b20:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104b23:	a3 2c b1 12 c0       	mov    %eax,0xc012b12c
c0104b28:	89 15 30 b1 12 c0    	mov    %edx,0xc012b130

     
     le = &free_list;
c0104b2e:	c7 45 e8 2c b1 12 c0 	movl   $0xc012b12c,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0104b35:	eb 1c                	jmp    c0104b53 <check_swap+0x61e>
         struct Page *p = le2page(le, page_link);
c0104b37:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b3a:	83 e8 0c             	sub    $0xc,%eax
c0104b3d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
         count --, total -= p->property;
c0104b40:	ff 4d f4             	decl   -0xc(%ebp)
c0104b43:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104b46:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104b49:	8b 40 08             	mov    0x8(%eax),%eax
c0104b4c:	29 c2                	sub    %eax,%edx
c0104b4e:	89 d0                	mov    %edx,%eax
c0104b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b53:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b56:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104b59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104b5c:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0104b5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b62:	81 7d e8 2c b1 12 c0 	cmpl   $0xc012b12c,-0x18(%ebp)
c0104b69:	75 cc                	jne    c0104b37 <check_swap+0x602>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0104b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b6e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b79:	c7 04 24 9d b1 10 c0 	movl   $0xc010b19d,(%esp)
c0104b80:	e8 24 b7 ff ff       	call   c01002a9 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0104b85:	c7 04 24 b7 b1 10 c0 	movl   $0xc010b1b7,(%esp)
c0104b8c:	e8 18 b7 ff ff       	call   c01002a9 <cprintf>
}
c0104b91:	90                   	nop
c0104b92:	c9                   	leave  
c0104b93:	c3                   	ret    

c0104b94 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104b94:	55                   	push   %ebp
c0104b95:	89 e5                	mov    %esp,%ebp
c0104b97:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104b9a:	9c                   	pushf  
c0104b9b:	58                   	pop    %eax
c0104b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104ba2:	25 00 02 00 00       	and    $0x200,%eax
c0104ba7:	85 c0                	test   %eax,%eax
c0104ba9:	74 0c                	je     c0104bb7 <__intr_save+0x23>
        intr_disable();
c0104bab:	e8 73 d5 ff ff       	call   c0102123 <intr_disable>
        return 1;
c0104bb0:	b8 01 00 00 00       	mov    $0x1,%eax
c0104bb5:	eb 05                	jmp    c0104bbc <__intr_save+0x28>
    }
    return 0;
c0104bb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104bbc:	c9                   	leave  
c0104bbd:	c3                   	ret    

c0104bbe <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104bbe:	55                   	push   %ebp
c0104bbf:	89 e5                	mov    %esp,%ebp
c0104bc1:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104bc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104bc8:	74 05                	je     c0104bcf <__intr_restore+0x11>
        intr_enable();
c0104bca:	e8 4d d5 ff ff       	call   c010211c <intr_enable>
    }
}
c0104bcf:	90                   	nop
c0104bd0:	c9                   	leave  
c0104bd1:	c3                   	ret    

c0104bd2 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104bd2:	55                   	push   %ebp
c0104bd3:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bd8:	8b 15 40 b1 12 c0    	mov    0xc012b140,%edx
c0104bde:	29 d0                	sub    %edx,%eax
c0104be0:	c1 f8 05             	sar    $0x5,%eax
}
c0104be3:	5d                   	pop    %ebp
c0104be4:	c3                   	ret    

c0104be5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104be5:	55                   	push   %ebp
c0104be6:	89 e5                	mov    %esp,%ebp
c0104be8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104beb:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bee:	89 04 24             	mov    %eax,(%esp)
c0104bf1:	e8 dc ff ff ff       	call   c0104bd2 <page2ppn>
c0104bf6:	c1 e0 0c             	shl    $0xc,%eax
}
c0104bf9:	c9                   	leave  
c0104bfa:	c3                   	ret    

c0104bfb <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104bfb:	55                   	push   %ebp
c0104bfc:	89 e5                	mov    %esp,%ebp
c0104bfe:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104c01:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c04:	c1 e8 0c             	shr    $0xc,%eax
c0104c07:	89 c2                	mov    %eax,%edx
c0104c09:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0104c0e:	39 c2                	cmp    %eax,%edx
c0104c10:	72 1c                	jb     c0104c2e <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104c12:	c7 44 24 08 d0 b1 10 	movl   $0xc010b1d0,0x8(%esp)
c0104c19:	c0 
c0104c1a:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104c21:	00 
c0104c22:	c7 04 24 ef b1 10 c0 	movl   $0xc010b1ef,(%esp)
c0104c29:	e8 d2 b7 ff ff       	call   c0100400 <__panic>
    }
    return &pages[PPN(pa)];
c0104c2e:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c0104c33:	8b 55 08             	mov    0x8(%ebp),%edx
c0104c36:	c1 ea 0c             	shr    $0xc,%edx
c0104c39:	c1 e2 05             	shl    $0x5,%edx
c0104c3c:	01 d0                	add    %edx,%eax
}
c0104c3e:	c9                   	leave  
c0104c3f:	c3                   	ret    

c0104c40 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104c40:	55                   	push   %ebp
c0104c41:	89 e5                	mov    %esp,%ebp
c0104c43:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104c46:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c49:	89 04 24             	mov    %eax,(%esp)
c0104c4c:	e8 94 ff ff ff       	call   c0104be5 <page2pa>
c0104c51:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c57:	c1 e8 0c             	shr    $0xc,%eax
c0104c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c5d:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0104c62:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104c65:	72 23                	jb     c0104c8a <page2kva+0x4a>
c0104c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104c6e:	c7 44 24 08 00 b2 10 	movl   $0xc010b200,0x8(%esp)
c0104c75:	c0 
c0104c76:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104c7d:	00 
c0104c7e:	c7 04 24 ef b1 10 c0 	movl   $0xc010b1ef,(%esp)
c0104c85:	e8 76 b7 ff ff       	call   c0100400 <__panic>
c0104c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c8d:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104c92:	c9                   	leave  
c0104c93:	c3                   	ret    

c0104c94 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0104c94:	55                   	push   %ebp
c0104c95:	89 e5                	mov    %esp,%ebp
c0104c97:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104c9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ca0:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104ca7:	77 23                	ja     c0104ccc <kva2page+0x38>
c0104ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cac:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104cb0:	c7 44 24 08 24 b2 10 	movl   $0xc010b224,0x8(%esp)
c0104cb7:	c0 
c0104cb8:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0104cbf:	00 
c0104cc0:	c7 04 24 ef b1 10 c0 	movl   $0xc010b1ef,(%esp)
c0104cc7:	e8 34 b7 ff ff       	call   c0100400 <__panic>
c0104ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ccf:	05 00 00 00 40       	add    $0x40000000,%eax
c0104cd4:	89 04 24             	mov    %eax,(%esp)
c0104cd7:	e8 1f ff ff ff       	call   c0104bfb <pa2page>
}
c0104cdc:	c9                   	leave  
c0104cdd:	c3                   	ret    

c0104cde <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c0104cde:	55                   	push   %ebp
c0104cdf:	89 e5                	mov    %esp,%ebp
c0104ce1:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c0104ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ce7:	ba 01 00 00 00       	mov    $0x1,%edx
c0104cec:	88 c1                	mov    %al,%cl
c0104cee:	d3 e2                	shl    %cl,%edx
c0104cf0:	89 d0                	mov    %edx,%eax
c0104cf2:	89 04 24             	mov    %eax,(%esp)
c0104cf5:	e8 b5 21 00 00       	call   c0106eaf <alloc_pages>
c0104cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104cfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d01:	75 07                	jne    c0104d0a <__slob_get_free_pages+0x2c>
    return NULL;
c0104d03:	b8 00 00 00 00       	mov    $0x0,%eax
c0104d08:	eb 0b                	jmp    c0104d15 <__slob_get_free_pages+0x37>
  return page2kva(page);
c0104d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d0d:	89 04 24             	mov    %eax,(%esp)
c0104d10:	e8 2b ff ff ff       	call   c0104c40 <page2kva>
}
c0104d15:	c9                   	leave  
c0104d16:	c3                   	ret    

c0104d17 <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c0104d17:	55                   	push   %ebp
c0104d18:	89 e5                	mov    %esp,%ebp
c0104d1a:	53                   	push   %ebx
c0104d1b:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c0104d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d21:	ba 01 00 00 00       	mov    $0x1,%edx
c0104d26:	88 c1                	mov    %al,%cl
c0104d28:	d3 e2                	shl    %cl,%edx
c0104d2a:	89 d0                	mov    %edx,%eax
c0104d2c:	89 c3                	mov    %eax,%ebx
c0104d2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d31:	89 04 24             	mov    %eax,(%esp)
c0104d34:	e8 5b ff ff ff       	call   c0104c94 <kva2page>
c0104d39:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104d3d:	89 04 24             	mov    %eax,(%esp)
c0104d40:	e8 d5 21 00 00       	call   c0106f1a <free_pages>
}
c0104d45:	90                   	nop
c0104d46:	83 c4 14             	add    $0x14,%esp
c0104d49:	5b                   	pop    %ebx
c0104d4a:	5d                   	pop    %ebp
c0104d4b:	c3                   	ret    

c0104d4c <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c0104d4c:	55                   	push   %ebp
c0104d4d:	89 e5                	mov    %esp,%ebp
c0104d4f:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0104d52:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d55:	83 c0 08             	add    $0x8,%eax
c0104d58:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0104d5d:	76 24                	jbe    c0104d83 <slob_alloc+0x37>
c0104d5f:	c7 44 24 0c 48 b2 10 	movl   $0xc010b248,0xc(%esp)
c0104d66:	c0 
c0104d67:	c7 44 24 08 67 b2 10 	movl   $0xc010b267,0x8(%esp)
c0104d6e:	c0 
c0104d6f:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0104d76:	00 
c0104d77:	c7 04 24 7c b2 10 c0 	movl   $0xc010b27c,(%esp)
c0104d7e:	e8 7d b6 ff ff       	call   c0100400 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c0104d83:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c0104d8a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104d91:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d94:	83 c0 07             	add    $0x7,%eax
c0104d97:	c1 e8 03             	shr    $0x3,%eax
c0104d9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c0104d9d:	e8 f2 fd ff ff       	call   c0104b94 <__intr_save>
c0104da2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c0104da5:	a1 e8 59 12 c0       	mov    0xc01259e8,%eax
c0104daa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104db0:	8b 40 04             	mov    0x4(%eax),%eax
c0104db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c0104db6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104dba:	74 25                	je     c0104de1 <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c0104dbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104dbf:	8b 45 10             	mov    0x10(%ebp),%eax
c0104dc2:	01 d0                	add    %edx,%eax
c0104dc4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104dc7:	8b 45 10             	mov    0x10(%ebp),%eax
c0104dca:	f7 d8                	neg    %eax
c0104dcc:	21 d0                	and    %edx,%eax
c0104dce:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c0104dd1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dd7:	29 c2                	sub    %eax,%edx
c0104dd9:	89 d0                	mov    %edx,%eax
c0104ddb:	c1 f8 03             	sar    $0x3,%eax
c0104dde:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c0104de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104de4:	8b 00                	mov    (%eax),%eax
c0104de6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104de9:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104dec:	01 ca                	add    %ecx,%edx
c0104dee:	39 d0                	cmp    %edx,%eax
c0104df0:	0f 8c aa 00 00 00    	jl     c0104ea0 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c0104df6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104dfa:	74 38                	je     c0104e34 <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c0104dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dff:	8b 00                	mov    (%eax),%eax
c0104e01:	2b 45 e8             	sub    -0x18(%ebp),%eax
c0104e04:	89 c2                	mov    %eax,%edx
c0104e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e09:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e0e:	8b 50 04             	mov    0x4(%eax),%edx
c0104e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e14:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c0104e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104e1d:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e23:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104e26:	89 10                	mov    %edx,(%eax)
				prev = cur;
c0104e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0104e2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e31:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c0104e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e37:	8b 00                	mov    (%eax),%eax
c0104e39:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104e3c:	75 0e                	jne    c0104e4c <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c0104e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e41:	8b 50 04             	mov    0x4(%eax),%edx
c0104e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e47:	89 50 04             	mov    %edx,0x4(%eax)
c0104e4a:	eb 3c                	jmp    c0104e88 <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c0104e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e4f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e59:	01 c2                	add    %eax,%edx
c0104e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e5e:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0104e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e64:	8b 40 04             	mov    0x4(%eax),%eax
c0104e67:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104e6a:	8b 12                	mov    (%edx),%edx
c0104e6c:	2b 55 e0             	sub    -0x20(%ebp),%edx
c0104e6f:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c0104e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e74:	8b 40 04             	mov    0x4(%eax),%eax
c0104e77:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104e7a:	8b 52 04             	mov    0x4(%edx),%edx
c0104e7d:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c0104e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e83:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e86:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c0104e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e8b:	a3 e8 59 12 c0       	mov    %eax,0xc01259e8
			spin_unlock_irqrestore(&slob_lock, flags);
c0104e90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e93:	89 04 24             	mov    %eax,(%esp)
c0104e96:	e8 23 fd ff ff       	call   c0104bbe <__intr_restore>
			return cur;
c0104e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e9e:	eb 7f                	jmp    c0104f1f <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c0104ea0:	a1 e8 59 12 c0       	mov    0xc01259e8,%eax
c0104ea5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104ea8:	75 61                	jne    c0104f0b <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c0104eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ead:	89 04 24             	mov    %eax,(%esp)
c0104eb0:	e8 09 fd ff ff       	call   c0104bbe <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c0104eb5:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104ebc:	75 07                	jne    c0104ec5 <slob_alloc+0x179>
				return 0;
c0104ebe:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ec3:	eb 5a                	jmp    c0104f1f <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c0104ec5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ecc:	00 
c0104ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ed0:	89 04 24             	mov    %eax,(%esp)
c0104ed3:	e8 06 fe ff ff       	call   c0104cde <__slob_get_free_pages>
c0104ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104edb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104edf:	75 07                	jne    c0104ee8 <slob_alloc+0x19c>
				return 0;
c0104ee1:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ee6:	eb 37                	jmp    c0104f1f <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c0104ee8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104eef:	00 
c0104ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ef3:	89 04 24             	mov    %eax,(%esp)
c0104ef6:	e8 26 00 00 00       	call   c0104f21 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c0104efb:	e8 94 fc ff ff       	call   c0104b94 <__intr_save>
c0104f00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c0104f03:	a1 e8 59 12 c0       	mov    0xc01259e8,%eax
c0104f08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f14:	8b 40 04             	mov    0x4(%eax),%eax
c0104f17:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c0104f1a:	e9 97 fe ff ff       	jmp    c0104db6 <slob_alloc+0x6a>
}
c0104f1f:	c9                   	leave  
c0104f20:	c3                   	ret    

c0104f21 <slob_free>:

static void slob_free(void *block, int size)
{
c0104f21:	55                   	push   %ebp
c0104f22:	89 e5                	mov    %esp,%ebp
c0104f24:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c0104f27:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104f2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104f31:	0f 84 01 01 00 00    	je     c0105038 <slob_free+0x117>
		return;

	if (size)
c0104f37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104f3b:	74 10                	je     c0104f4d <slob_free+0x2c>
		b->units = SLOB_UNITS(size);
c0104f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f40:	83 c0 07             	add    $0x7,%eax
c0104f43:	c1 e8 03             	shr    $0x3,%eax
c0104f46:	89 c2                	mov    %eax,%edx
c0104f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f4b:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104f4d:	e8 42 fc ff ff       	call   c0104b94 <__intr_save>
c0104f52:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104f55:	a1 e8 59 12 c0       	mov    0xc01259e8,%eax
c0104f5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104f5d:	eb 27                	jmp    c0104f86 <slob_free+0x65>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f62:	8b 40 04             	mov    0x4(%eax),%eax
c0104f65:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104f68:	77 13                	ja     c0104f7d <slob_free+0x5c>
c0104f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f6d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104f70:	77 27                	ja     c0104f99 <slob_free+0x78>
c0104f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f75:	8b 40 04             	mov    0x4(%eax),%eax
c0104f78:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104f7b:	77 1c                	ja     c0104f99 <slob_free+0x78>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f80:	8b 40 04             	mov    0x4(%eax),%eax
c0104f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f89:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104f8c:	76 d1                	jbe    c0104f5f <slob_free+0x3e>
c0104f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f91:	8b 40 04             	mov    0x4(%eax),%eax
c0104f94:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104f97:	76 c6                	jbe    c0104f5f <slob_free+0x3e>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c0104f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f9c:	8b 00                	mov    (%eax),%eax
c0104f9e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fa8:	01 c2                	add    %eax,%edx
c0104faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fad:	8b 40 04             	mov    0x4(%eax),%eax
c0104fb0:	39 c2                	cmp    %eax,%edx
c0104fb2:	75 25                	jne    c0104fd9 <slob_free+0xb8>
		b->units += cur->next->units;
c0104fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fb7:	8b 10                	mov    (%eax),%edx
c0104fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fbc:	8b 40 04             	mov    0x4(%eax),%eax
c0104fbf:	8b 00                	mov    (%eax),%eax
c0104fc1:	01 c2                	add    %eax,%edx
c0104fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fc6:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fcb:	8b 40 04             	mov    0x4(%eax),%eax
c0104fce:	8b 50 04             	mov    0x4(%eax),%edx
c0104fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fd4:	89 50 04             	mov    %edx,0x4(%eax)
c0104fd7:	eb 0c                	jmp    c0104fe5 <slob_free+0xc4>
	} else
		b->next = cur->next;
c0104fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fdc:	8b 50 04             	mov    0x4(%eax),%edx
c0104fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fe2:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c0104fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fe8:	8b 00                	mov    (%eax),%eax
c0104fea:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ff4:	01 d0                	add    %edx,%eax
c0104ff6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104ff9:	75 1f                	jne    c010501a <slob_free+0xf9>
		cur->units += b->units;
c0104ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ffe:	8b 10                	mov    (%eax),%edx
c0105000:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105003:	8b 00                	mov    (%eax),%eax
c0105005:	01 c2                	add    %eax,%edx
c0105007:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010500a:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c010500c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010500f:	8b 50 04             	mov    0x4(%eax),%edx
c0105012:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105015:	89 50 04             	mov    %edx,0x4(%eax)
c0105018:	eb 09                	jmp    c0105023 <slob_free+0x102>
	} else
		cur->next = b;
c010501a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010501d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105020:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0105023:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105026:	a3 e8 59 12 c0       	mov    %eax,0xc01259e8

	spin_unlock_irqrestore(&slob_lock, flags);
c010502b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010502e:	89 04 24             	mov    %eax,(%esp)
c0105031:	e8 88 fb ff ff       	call   c0104bbe <__intr_restore>
c0105036:	eb 01                	jmp    c0105039 <slob_free+0x118>
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
		return;
c0105038:	90                   	nop
		cur->next = b;

	slobfree = cur;

	spin_unlock_irqrestore(&slob_lock, flags);
}
c0105039:	c9                   	leave  
c010503a:	c3                   	ret    

c010503b <slob_init>:



void
slob_init(void) {
c010503b:	55                   	push   %ebp
c010503c:	89 e5                	mov    %esp,%ebp
c010503e:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c0105041:	c7 04 24 8e b2 10 c0 	movl   $0xc010b28e,(%esp)
c0105048:	e8 5c b2 ff ff       	call   c01002a9 <cprintf>
}
c010504d:	90                   	nop
c010504e:	c9                   	leave  
c010504f:	c3                   	ret    

c0105050 <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0105050:	55                   	push   %ebp
c0105051:	89 e5                	mov    %esp,%ebp
c0105053:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c0105056:	e8 e0 ff ff ff       	call   c010503b <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c010505b:	c7 04 24 a2 b2 10 c0 	movl   $0xc010b2a2,(%esp)
c0105062:	e8 42 b2 ff ff       	call   c01002a9 <cprintf>
}
c0105067:	90                   	nop
c0105068:	c9                   	leave  
c0105069:	c3                   	ret    

c010506a <slob_allocated>:

size_t
slob_allocated(void) {
c010506a:	55                   	push   %ebp
c010506b:	89 e5                	mov    %esp,%ebp
  return 0;
c010506d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105072:	5d                   	pop    %ebp
c0105073:	c3                   	ret    

c0105074 <kallocated>:

size_t
kallocated(void) {
c0105074:	55                   	push   %ebp
c0105075:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0105077:	e8 ee ff ff ff       	call   c010506a <slob_allocated>
}
c010507c:	5d                   	pop    %ebp
c010507d:	c3                   	ret    

c010507e <find_order>:

static int find_order(int size)
{
c010507e:	55                   	push   %ebp
c010507f:	89 e5                	mov    %esp,%ebp
c0105081:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0105084:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c010508b:	eb 06                	jmp    c0105093 <find_order+0x15>
		order++;
c010508d:	ff 45 fc             	incl   -0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0105090:	d1 7d 08             	sarl   0x8(%ebp)
c0105093:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c010509a:	7f f1                	jg     c010508d <find_order+0xf>
		order++;
	return order;
c010509c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010509f:	c9                   	leave  
c01050a0:	c3                   	ret    

c01050a1 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c01050a1:	55                   	push   %ebp
c01050a2:	89 e5                	mov    %esp,%ebp
c01050a4:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c01050a7:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c01050ae:	77 3b                	ja     c01050eb <__kmalloc+0x4a>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c01050b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01050b3:	8d 50 08             	lea    0x8(%eax),%edx
c01050b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01050bd:	00 
c01050be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050c5:	89 14 24             	mov    %edx,(%esp)
c01050c8:	e8 7f fc ff ff       	call   c0104d4c <slob_alloc>
c01050cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c01050d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050d4:	74 0b                	je     c01050e1 <__kmalloc+0x40>
c01050d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050d9:	83 c0 08             	add    $0x8,%eax
c01050dc:	e9 b4 00 00 00       	jmp    c0105195 <__kmalloc+0xf4>
c01050e1:	b8 00 00 00 00       	mov    $0x0,%eax
c01050e6:	e9 aa 00 00 00       	jmp    c0105195 <__kmalloc+0xf4>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c01050eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01050f2:	00 
c01050f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050fa:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0105101:	e8 46 fc ff ff       	call   c0104d4c <slob_alloc>
c0105106:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c0105109:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010510d:	75 07                	jne    c0105116 <__kmalloc+0x75>
		return 0;
c010510f:	b8 00 00 00 00       	mov    $0x0,%eax
c0105114:	eb 7f                	jmp    c0105195 <__kmalloc+0xf4>

	bb->order = find_order(size);
c0105116:	8b 45 08             	mov    0x8(%ebp),%eax
c0105119:	89 04 24             	mov    %eax,(%esp)
c010511c:	e8 5d ff ff ff       	call   c010507e <find_order>
c0105121:	89 c2                	mov    %eax,%edx
c0105123:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105126:	89 10                	mov    %edx,(%eax)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0105128:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010512b:	8b 00                	mov    (%eax),%eax
c010512d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105131:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105134:	89 04 24             	mov    %eax,(%esp)
c0105137:	e8 a2 fb ff ff       	call   c0104cde <__slob_get_free_pages>
c010513c:	89 c2                	mov    %eax,%edx
c010513e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105141:	89 50 04             	mov    %edx,0x4(%eax)

	if (bb->pages) {
c0105144:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105147:	8b 40 04             	mov    0x4(%eax),%eax
c010514a:	85 c0                	test   %eax,%eax
c010514c:	74 2f                	je     c010517d <__kmalloc+0xdc>
		spin_lock_irqsave(&block_lock, flags);
c010514e:	e8 41 fa ff ff       	call   c0104b94 <__intr_save>
c0105153:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c0105156:	8b 15 74 8f 12 c0    	mov    0xc0128f74,%edx
c010515c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010515f:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c0105162:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105165:	a3 74 8f 12 c0       	mov    %eax,0xc0128f74
		spin_unlock_irqrestore(&block_lock, flags);
c010516a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010516d:	89 04 24             	mov    %eax,(%esp)
c0105170:	e8 49 fa ff ff       	call   c0104bbe <__intr_restore>
		return bb->pages;
c0105175:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105178:	8b 40 04             	mov    0x4(%eax),%eax
c010517b:	eb 18                	jmp    c0105195 <__kmalloc+0xf4>
	}

	slob_free(bb, sizeof(bigblock_t));
c010517d:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0105184:	00 
c0105185:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105188:	89 04 24             	mov    %eax,(%esp)
c010518b:	e8 91 fd ff ff       	call   c0104f21 <slob_free>
	return 0;
c0105190:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105195:	c9                   	leave  
c0105196:	c3                   	ret    

c0105197 <kmalloc>:

void *
kmalloc(size_t size)
{
c0105197:	55                   	push   %ebp
c0105198:	89 e5                	mov    %esp,%ebp
c010519a:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c010519d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01051a4:	00 
c01051a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01051a8:	89 04 24             	mov    %eax,(%esp)
c01051ab:	e8 f1 fe ff ff       	call   c01050a1 <__kmalloc>
}
c01051b0:	c9                   	leave  
c01051b1:	c3                   	ret    

c01051b2 <kfree>:


void kfree(void *block)
{
c01051b2:	55                   	push   %ebp
c01051b3:	89 e5                	mov    %esp,%ebp
c01051b5:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c01051b8:	c7 45 f0 74 8f 12 c0 	movl   $0xc0128f74,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01051bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01051c3:	0f 84 a4 00 00 00    	je     c010526d <kfree+0xbb>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c01051c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051cc:	25 ff 0f 00 00       	and    $0xfff,%eax
c01051d1:	85 c0                	test   %eax,%eax
c01051d3:	75 7f                	jne    c0105254 <kfree+0xa2>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c01051d5:	e8 ba f9 ff ff       	call   c0104b94 <__intr_save>
c01051da:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c01051dd:	a1 74 8f 12 c0       	mov    0xc0128f74,%eax
c01051e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051e5:	eb 5c                	jmp    c0105243 <kfree+0x91>
			if (bb->pages == block) {
c01051e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051ea:	8b 40 04             	mov    0x4(%eax),%eax
c01051ed:	3b 45 08             	cmp    0x8(%ebp),%eax
c01051f0:	75 3f                	jne    c0105231 <kfree+0x7f>
				*last = bb->next;
c01051f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051f5:	8b 50 08             	mov    0x8(%eax),%edx
c01051f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051fb:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c01051fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105200:	89 04 24             	mov    %eax,(%esp)
c0105203:	e8 b6 f9 ff ff       	call   c0104bbe <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0105208:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010520b:	8b 10                	mov    (%eax),%edx
c010520d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105210:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105214:	89 04 24             	mov    %eax,(%esp)
c0105217:	e8 fb fa ff ff       	call   c0104d17 <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c010521c:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0105223:	00 
c0105224:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105227:	89 04 24             	mov    %eax,(%esp)
c010522a:	e8 f2 fc ff ff       	call   c0104f21 <slob_free>
				return;
c010522f:	eb 3d                	jmp    c010526e <kfree+0xbc>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0105231:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105234:	83 c0 08             	add    $0x8,%eax
c0105237:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010523a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010523d:	8b 40 08             	mov    0x8(%eax),%eax
c0105240:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105247:	75 9e                	jne    c01051e7 <kfree+0x35>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0105249:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010524c:	89 04 24             	mov    %eax,(%esp)
c010524f:	e8 6a f9 ff ff       	call   c0104bbe <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0105254:	8b 45 08             	mov    0x8(%ebp),%eax
c0105257:	83 e8 08             	sub    $0x8,%eax
c010525a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105261:	00 
c0105262:	89 04 24             	mov    %eax,(%esp)
c0105265:	e8 b7 fc ff ff       	call   c0104f21 <slob_free>
	return;
c010526a:	90                   	nop
c010526b:	eb 01                	jmp    c010526e <kfree+0xbc>
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
		return;
c010526d:	90                   	nop
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
c010526e:	c9                   	leave  
c010526f:	c3                   	ret    

c0105270 <ksize>:


unsigned int ksize(const void *block)
{
c0105270:	55                   	push   %ebp
c0105271:	89 e5                	mov    %esp,%ebp
c0105273:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0105276:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010527a:	75 07                	jne    c0105283 <ksize+0x13>
		return 0;
c010527c:	b8 00 00 00 00       	mov    $0x0,%eax
c0105281:	eb 6b                	jmp    c01052ee <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0105283:	8b 45 08             	mov    0x8(%ebp),%eax
c0105286:	25 ff 0f 00 00       	and    $0xfff,%eax
c010528b:	85 c0                	test   %eax,%eax
c010528d:	75 54                	jne    c01052e3 <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c010528f:	e8 00 f9 ff ff       	call   c0104b94 <__intr_save>
c0105294:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0105297:	a1 74 8f 12 c0       	mov    0xc0128f74,%eax
c010529c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010529f:	eb 31                	jmp    c01052d2 <ksize+0x62>
			if (bb->pages == block) {
c01052a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052a4:	8b 40 04             	mov    0x4(%eax),%eax
c01052a7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01052aa:	75 1d                	jne    c01052c9 <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c01052ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052af:	89 04 24             	mov    %eax,(%esp)
c01052b2:	e8 07 f9 ff ff       	call   c0104bbe <__intr_restore>
				return PAGE_SIZE << bb->order;
c01052b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052ba:	8b 00                	mov    (%eax),%eax
c01052bc:	ba 00 10 00 00       	mov    $0x1000,%edx
c01052c1:	88 c1                	mov    %al,%cl
c01052c3:	d3 e2                	shl    %cl,%edx
c01052c5:	89 d0                	mov    %edx,%eax
c01052c7:	eb 25                	jmp    c01052ee <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c01052c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052cc:	8b 40 08             	mov    0x8(%eax),%eax
c01052cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01052d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01052d6:	75 c9                	jne    c01052a1 <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c01052d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052db:	89 04 24             	mov    %eax,(%esp)
c01052de:	e8 db f8 ff ff       	call   c0104bbe <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c01052e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01052e6:	83 e8 08             	sub    $0x8,%eax
c01052e9:	8b 00                	mov    (%eax),%eax
c01052eb:	c1 e0 03             	shl    $0x3,%eax
}
c01052ee:	c9                   	leave  
c01052ef:	c3                   	ret    

c01052f0 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{
c01052f0:	55                   	push   %ebp
c01052f1:	89 e5                	mov    %esp,%ebp
c01052f3:	83 ec 10             	sub    $0x10,%esp
c01052f6:	c7 45 fc 24 b1 12 c0 	movl   $0xc012b124,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01052fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105300:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0105303:	89 50 04             	mov    %edx,0x4(%eax)
c0105306:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105309:	8b 50 04             	mov    0x4(%eax),%edx
c010530c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010530f:	89 10                	mov    %edx,(%eax)
    list_init(&pra_list_head);
    mm->sm_priv = &pra_list_head;
c0105311:	8b 45 08             	mov    0x8(%ebp),%eax
c0105314:	c7 40 14 24 b1 12 c0 	movl   $0xc012b124,0x14(%eax)
    //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
    return 0;
c010531b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105320:	c9                   	leave  
c0105321:	c3                   	ret    

c0105322 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0105322:	55                   	push   %ebp
c0105323:	89 e5                	mov    %esp,%ebp
c0105325:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
c0105328:	8b 45 08             	mov    0x8(%ebp),%eax
c010532b:	8b 40 14             	mov    0x14(%eax),%eax
c010532e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry = &(page->pra_page_link);
c0105331:	8b 45 10             	mov    0x10(%ebp),%eax
c0105334:	83 c0 14             	add    $0x14,%eax
c0105337:	89 45 f0             	mov    %eax,-0x10(%ebp)

    assert(entry != NULL && head != NULL);
c010533a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010533e:	74 06                	je     c0105346 <_fifo_map_swappable+0x24>
c0105340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105344:	75 24                	jne    c010536a <_fifo_map_swappable+0x48>
c0105346:	c7 44 24 0c c0 b2 10 	movl   $0xc010b2c0,0xc(%esp)
c010534d:	c0 
c010534e:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c0105355:	c0 
c0105356:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c010535d:	00 
c010535e:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c0105365:	e8 96 b0 ff ff       	call   c0100400 <__panic>
c010536a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010536d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105370:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105373:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0105376:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105379:	8b 00                	mov    (%eax),%eax
c010537b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010537e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105381:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105384:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105387:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010538a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010538d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105390:	89 10                	mov    %edx,(%eax)
c0105392:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105395:	8b 10                	mov    (%eax),%edx
c0105397:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010539a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010539d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053a3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01053a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053ac:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
c01053ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01053b3:	c9                   	leave  
c01053b4:	c3                   	ret    

c01053b5 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page **ptr_page, int in_tick)
{
c01053b5:	55                   	push   %ebp
c01053b6:	89 e5                	mov    %esp,%ebp
c01053b8:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
c01053bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01053be:	8b 40 14             	mov    0x14(%eax),%eax
c01053c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(head != NULL);
c01053c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01053c8:	75 24                	jne    c01053ee <_fifo_swap_out_victim+0x39>
c01053ca:	c7 44 24 0c 07 b3 10 	movl   $0xc010b307,0xc(%esp)
c01053d1:	c0 
c01053d2:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c01053d9:	c0 
c01053da:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c01053e1:	00 
c01053e2:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c01053e9:	e8 12 b0 ff ff       	call   c0100400 <__panic>
    assert(in_tick == 0);
c01053ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01053f2:	74 24                	je     c0105418 <_fifo_swap_out_victim+0x63>
c01053f4:	c7 44 24 0c 14 b3 10 	movl   $0xc010b314,0xc(%esp)
c01053fb:	c0 
c01053fc:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c0105403:	c0 
c0105404:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c010540b:	00 
c010540c:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c0105413:	e8 e8 af ff ff       	call   c0100400 <__panic>
    /* Select the victim */
    /*LAB3 EXERCISE 2: YOUR CODE*/
    //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
    //(2)  assign the value of *ptr_page to the addr of this page
    list_entry_t *le = head->next;
c0105418:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010541b:	8b 40 04             	mov    0x4(%eax),%eax
c010541e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(le != head);
c0105421:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105424:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105427:	75 24                	jne    c010544d <_fifo_swap_out_victim+0x98>
c0105429:	c7 44 24 0c 21 b3 10 	movl   $0xc010b321,0xc(%esp)
c0105430:	c0 
c0105431:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c0105438:	c0 
c0105439:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
c0105440:	00 
c0105441:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c0105448:	e8 b3 af ff ff       	call   c0100400 <__panic>
    struct Page *p = le2page(le, pra_page_link);
c010544d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105450:	83 e8 14             	sub    $0x14,%eax
c0105453:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105456:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105459:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010545c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010545f:	8b 40 04             	mov    0x4(%eax),%eax
c0105462:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105465:	8b 12                	mov    (%edx),%edx
c0105467:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010546a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010546d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105470:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105473:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105476:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105479:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010547c:	89 10                	mov    %edx,(%eax)
    list_del(le);
    assert(p != NULL);
c010547e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105482:	75 24                	jne    c01054a8 <_fifo_swap_out_victim+0xf3>
c0105484:	c7 44 24 0c 2c b3 10 	movl   $0xc010b32c,0xc(%esp)
c010548b:	c0 
c010548c:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c0105493:	c0 
c0105494:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
c010549b:	00 
c010549c:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c01054a3:	e8 58 af ff ff       	call   c0100400 <__panic>
    // memset(page2kva(p), 0, PGSIZE);
    *ptr_page = p;
c01054a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054ae:	89 10                	mov    %edx,(%eax)
    return 0;
c01054b0:	b8 00 00 00 00       	mov    $0x0,%eax

}
c01054b5:	c9                   	leave  
c01054b6:	c3                   	ret    

c01054b7 <_fifo_check_swap>:

static int
_fifo_check_swap(void)
{
c01054b7:	55                   	push   %ebp
c01054b8:	89 e5                	mov    %esp,%ebp
c01054ba:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c01054bd:	c7 04 24 38 b3 10 c0 	movl   $0xc010b338,(%esp)
c01054c4:	e8 e0 ad ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01054c9:	b8 00 30 00 00       	mov    $0x3000,%eax
c01054ce:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num == 4);
c01054d1:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01054d6:	83 f8 04             	cmp    $0x4,%eax
c01054d9:	74 24                	je     c01054ff <_fifo_check_swap+0x48>
c01054db:	c7 44 24 0c 5e b3 10 	movl   $0xc010b35e,0xc(%esp)
c01054e2:	c0 
c01054e3:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c01054ea:	c0 
c01054eb:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c01054f2:	00 
c01054f3:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c01054fa:	e8 01 af ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01054ff:	c7 04 24 70 b3 10 c0 	movl   $0xc010b370,(%esp)
c0105506:	e8 9e ad ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c010550b:	b8 00 10 00 00       	mov    $0x1000,%eax
c0105510:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num == 4);
c0105513:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0105518:	83 f8 04             	cmp    $0x4,%eax
c010551b:	74 24                	je     c0105541 <_fifo_check_swap+0x8a>
c010551d:	c7 44 24 0c 5e b3 10 	movl   $0xc010b35e,0xc(%esp)
c0105524:	c0 
c0105525:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c010552c:	c0 
c010552d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0105534:	00 
c0105535:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c010553c:	e8 bf ae ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0105541:	c7 04 24 98 b3 10 c0 	movl   $0xc010b398,(%esp)
c0105548:	e8 5c ad ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c010554d:	b8 00 40 00 00       	mov    $0x4000,%eax
c0105552:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num == 4);
c0105555:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c010555a:	83 f8 04             	cmp    $0x4,%eax
c010555d:	74 24                	je     c0105583 <_fifo_check_swap+0xcc>
c010555f:	c7 44 24 0c 5e b3 10 	movl   $0xc010b35e,0xc(%esp)
c0105566:	c0 
c0105567:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c010556e:	c0 
c010556f:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c0105576:	00 
c0105577:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c010557e:	e8 7d ae ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0105583:	c7 04 24 c0 b3 10 c0 	movl   $0xc010b3c0,(%esp)
c010558a:	e8 1a ad ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010558f:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105594:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num == 4);
c0105597:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c010559c:	83 f8 04             	cmp    $0x4,%eax
c010559f:	74 24                	je     c01055c5 <_fifo_check_swap+0x10e>
c01055a1:	c7 44 24 0c 5e b3 10 	movl   $0xc010b35e,0xc(%esp)
c01055a8:	c0 
c01055a9:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c01055b0:	c0 
c01055b1:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c01055b8:	00 
c01055b9:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c01055c0:	e8 3b ae ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01055c5:	c7 04 24 e8 b3 10 c0 	movl   $0xc010b3e8,(%esp)
c01055cc:	e8 d8 ac ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01055d1:	b8 00 50 00 00       	mov    $0x5000,%eax
c01055d6:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num == 5);
c01055d9:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01055de:	83 f8 05             	cmp    $0x5,%eax
c01055e1:	74 24                	je     c0105607 <_fifo_check_swap+0x150>
c01055e3:	c7 44 24 0c 0e b4 10 	movl   $0xc010b40e,0xc(%esp)
c01055ea:	c0 
c01055eb:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c01055f2:	c0 
c01055f3:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c01055fa:	00 
c01055fb:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c0105602:	e8 f9 ad ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0105607:	c7 04 24 c0 b3 10 c0 	movl   $0xc010b3c0,(%esp)
c010560e:	e8 96 ac ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0105613:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105618:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num == 5);
c010561b:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0105620:	83 f8 05             	cmp    $0x5,%eax
c0105623:	74 24                	je     c0105649 <_fifo_check_swap+0x192>
c0105625:	c7 44 24 0c 0e b4 10 	movl   $0xc010b40e,0xc(%esp)
c010562c:	c0 
c010562d:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c0105634:	c0 
c0105635:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c010563c:	00 
c010563d:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c0105644:	e8 b7 ad ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0105649:	c7 04 24 70 b3 10 c0 	movl   $0xc010b370,(%esp)
c0105650:	e8 54 ac ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0105655:	b8 00 10 00 00       	mov    $0x1000,%eax
c010565a:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num == 6);
c010565d:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0105662:	83 f8 06             	cmp    $0x6,%eax
c0105665:	74 24                	je     c010568b <_fifo_check_swap+0x1d4>
c0105667:	c7 44 24 0c 1f b4 10 	movl   $0xc010b41f,0xc(%esp)
c010566e:	c0 
c010566f:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c0105676:	c0 
c0105677:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c010567e:	00 
c010567f:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c0105686:	e8 75 ad ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010568b:	c7 04 24 c0 b3 10 c0 	movl   $0xc010b3c0,(%esp)
c0105692:	e8 12 ac ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0105697:	b8 00 20 00 00       	mov    $0x2000,%eax
c010569c:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num == 7);
c010569f:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01056a4:	83 f8 07             	cmp    $0x7,%eax
c01056a7:	74 24                	je     c01056cd <_fifo_check_swap+0x216>
c01056a9:	c7 44 24 0c 30 b4 10 	movl   $0xc010b430,0xc(%esp)
c01056b0:	c0 
c01056b1:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c01056b8:	c0 
c01056b9:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c01056c0:	00 
c01056c1:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c01056c8:	e8 33 ad ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01056cd:	c7 04 24 38 b3 10 c0 	movl   $0xc010b338,(%esp)
c01056d4:	e8 d0 ab ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01056d9:	b8 00 30 00 00       	mov    $0x3000,%eax
c01056de:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num == 8);
c01056e1:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01056e6:	83 f8 08             	cmp    $0x8,%eax
c01056e9:	74 24                	je     c010570f <_fifo_check_swap+0x258>
c01056eb:	c7 44 24 0c 41 b4 10 	movl   $0xc010b441,0xc(%esp)
c01056f2:	c0 
c01056f3:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c01056fa:	c0 
c01056fb:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0105702:	00 
c0105703:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c010570a:	e8 f1 ac ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c010570f:	c7 04 24 98 b3 10 c0 	movl   $0xc010b398,(%esp)
c0105716:	e8 8e ab ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c010571b:	b8 00 40 00 00       	mov    $0x4000,%eax
c0105720:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num == 9);
c0105723:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0105728:	83 f8 09             	cmp    $0x9,%eax
c010572b:	74 24                	je     c0105751 <_fifo_check_swap+0x29a>
c010572d:	c7 44 24 0c 52 b4 10 	movl   $0xc010b452,0xc(%esp)
c0105734:	c0 
c0105735:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c010573c:	c0 
c010573d:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
c0105744:	00 
c0105745:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c010574c:	e8 af ac ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0105751:	c7 04 24 e8 b3 10 c0 	movl   $0xc010b3e8,(%esp)
c0105758:	e8 4c ab ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c010575d:	b8 00 50 00 00       	mov    $0x5000,%eax
c0105762:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num == 10);
c0105765:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c010576a:	83 f8 0a             	cmp    $0xa,%eax
c010576d:	74 24                	je     c0105793 <_fifo_check_swap+0x2dc>
c010576f:	c7 44 24 0c 63 b4 10 	movl   $0xc010b463,0xc(%esp)
c0105776:	c0 
c0105777:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c010577e:	c0 
c010577f:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
c0105786:	00 
c0105787:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c010578e:	e8 6d ac ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0105793:	c7 04 24 70 b3 10 c0 	movl   $0xc010b370,(%esp)
c010579a:	e8 0a ab ff ff       	call   c01002a9 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c010579f:	b8 00 10 00 00       	mov    $0x1000,%eax
c01057a4:	0f b6 00             	movzbl (%eax),%eax
c01057a7:	3c 0a                	cmp    $0xa,%al
c01057a9:	74 24                	je     c01057cf <_fifo_check_swap+0x318>
c01057ab:	c7 44 24 0c 78 b4 10 	movl   $0xc010b478,0xc(%esp)
c01057b2:	c0 
c01057b3:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c01057ba:	c0 
c01057bb:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
c01057c2:	00 
c01057c3:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c01057ca:	e8 31 ac ff ff       	call   c0100400 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c01057cf:	b8 00 10 00 00       	mov    $0x1000,%eax
c01057d4:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num == 11);
c01057d7:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01057dc:	83 f8 0b             	cmp    $0xb,%eax
c01057df:	74 24                	je     c0105805 <_fifo_check_swap+0x34e>
c01057e1:	c7 44 24 0c 99 b4 10 	movl   $0xc010b499,0xc(%esp)
c01057e8:	c0 
c01057e9:	c7 44 24 08 de b2 10 	movl   $0xc010b2de,0x8(%esp)
c01057f0:	c0 
c01057f1:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c01057f8:	00 
c01057f9:	c7 04 24 f3 b2 10 c0 	movl   $0xc010b2f3,(%esp)
c0105800:	e8 fb ab ff ff       	call   c0100400 <__panic>
    return 0;
c0105805:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010580a:	c9                   	leave  
c010580b:	c3                   	ret    

c010580c <_fifo_init>:

static int
_fifo_init(void)
{
c010580c:	55                   	push   %ebp
c010580d:	89 e5                	mov    %esp,%ebp
    return 0;
c010580f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105814:	5d                   	pop    %ebp
c0105815:	c3                   	ret    

c0105816 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0105816:	55                   	push   %ebp
c0105817:	89 e5                	mov    %esp,%ebp
    return 0;
c0105819:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010581e:	5d                   	pop    %ebp
c010581f:	c3                   	ret    

c0105820 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{
c0105820:	55                   	push   %ebp
c0105821:	89 e5                	mov    %esp,%ebp
    return 0;
c0105823:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105828:	5d                   	pop    %ebp
c0105829:	c3                   	ret    

c010582a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010582a:	55                   	push   %ebp
c010582b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010582d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105830:	8b 15 40 b1 12 c0    	mov    0xc012b140,%edx
c0105836:	29 d0                	sub    %edx,%eax
c0105838:	c1 f8 05             	sar    $0x5,%eax
}
c010583b:	5d                   	pop    %ebp
c010583c:	c3                   	ret    

c010583d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010583d:	55                   	push   %ebp
c010583e:	89 e5                	mov    %esp,%ebp
c0105840:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0105843:	8b 45 08             	mov    0x8(%ebp),%eax
c0105846:	89 04 24             	mov    %eax,(%esp)
c0105849:	e8 dc ff ff ff       	call   c010582a <page2ppn>
c010584e:	c1 e0 0c             	shl    $0xc,%eax
}
c0105851:	c9                   	leave  
c0105852:	c3                   	ret    

c0105853 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0105853:	55                   	push   %ebp
c0105854:	89 e5                	mov    %esp,%ebp
c0105856:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0105859:	8b 45 08             	mov    0x8(%ebp),%eax
c010585c:	89 04 24             	mov    %eax,(%esp)
c010585f:	e8 d9 ff ff ff       	call   c010583d <page2pa>
c0105864:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105867:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010586a:	c1 e8 0c             	shr    $0xc,%eax
c010586d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105870:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0105875:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0105878:	72 23                	jb     c010589d <page2kva+0x4a>
c010587a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010587d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105881:	c7 44 24 08 c0 b4 10 	movl   $0xc010b4c0,0x8(%esp)
c0105888:	c0 
c0105889:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0105890:	00 
c0105891:	c7 04 24 e3 b4 10 c0 	movl   $0xc010b4e3,(%esp)
c0105898:	e8 63 ab ff ff       	call   c0100400 <__panic>
c010589d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058a0:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01058a5:	c9                   	leave  
c01058a6:	c3                   	ret    

c01058a7 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01058a7:	55                   	push   %ebp
c01058a8:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01058aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ad:	8b 00                	mov    (%eax),%eax
}
c01058af:	5d                   	pop    %ebp
c01058b0:	c3                   	ret    

c01058b1 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01058b1:	55                   	push   %ebp
c01058b2:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01058b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058ba:	89 10                	mov    %edx,(%eax)
}
c01058bc:	90                   	nop
c01058bd:	5d                   	pop    %ebp
c01058be:	c3                   	ret    

c01058bf <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01058bf:	55                   	push   %ebp
c01058c0:	89 e5                	mov    %esp,%ebp
c01058c2:	83 ec 10             	sub    $0x10,%esp
c01058c5:	c7 45 fc 2c b1 12 c0 	movl   $0xc012b12c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01058cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01058cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01058d2:	89 50 04             	mov    %edx,0x4(%eax)
c01058d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01058d8:	8b 50 04             	mov    0x4(%eax),%edx
c01058db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01058de:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01058e0:	c7 05 34 b1 12 c0 00 	movl   $0x0,0xc012b134
c01058e7:	00 00 00 
}
c01058ea:	90                   	nop
c01058eb:	c9                   	leave  
c01058ec:	c3                   	ret    

c01058ed <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01058ed:	55                   	push   %ebp
c01058ee:	89 e5                	mov    %esp,%ebp
c01058f0:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01058f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01058f7:	75 24                	jne    c010591d <default_init_memmap+0x30>
c01058f9:	c7 44 24 0c f1 b4 10 	movl   $0xc010b4f1,0xc(%esp)
c0105900:	c0 
c0105901:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0105908:	c0 
c0105909:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0105910:	00 
c0105911:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0105918:	e8 e3 aa ff ff       	call   c0100400 <__panic>
    struct Page *p = base;
c010591d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105920:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105923:	e9 c1 00 00 00       	jmp    c01059e9 <default_init_memmap+0xfc>
        assert(PageReserved(p));
c0105928:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010592b:	83 c0 04             	add    $0x4,%eax
c010592e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0105935:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105938:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010593b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010593e:	0f a3 10             	bt     %edx,(%eax)
c0105941:	19 c0                	sbb    %eax,%eax
c0105943:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
c0105946:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010594a:	0f 95 c0             	setne  %al
c010594d:	0f b6 c0             	movzbl %al,%eax
c0105950:	85 c0                	test   %eax,%eax
c0105952:	75 24                	jne    c0105978 <default_init_memmap+0x8b>
c0105954:	c7 44 24 0c 22 b5 10 	movl   $0xc010b522,0xc(%esp)
c010595b:	c0 
c010595c:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0105963:	c0 
c0105964:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010596b:	00 
c010596c:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0105973:	e8 88 aa ff ff       	call   c0100400 <__panic>
        ClearPageReserved(p);       //flag : PG_reserve to 0 
c0105978:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010597b:	83 c0 04             	add    $0x4,%eax
c010597e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0105985:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105988:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010598b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010598e:	0f b3 10             	btr    %edx,(%eax)
        SetPageProperty(p);         //flag : PG_property to 1
c0105991:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105994:	83 c0 04             	add    $0x4,%eax
c0105997:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c010599e:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01059a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01059a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01059a7:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;            //property
c01059aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);         //ref
c01059b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01059bb:	00 
c01059bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059bf:	89 04 24             	mov    %eax,(%esp)
c01059c2:	e8 ea fe ff ff       	call   c01058b1 <set_page_ref>
        memset(&(p->page_link), 0, sizeof(list_entry_t));
c01059c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059ca:	83 c0 0c             	add    $0xc,%eax
c01059cd:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
c01059d4:	00 
c01059d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01059dc:	00 
c01059dd:	89 04 24             	mov    %eax,(%esp)
c01059e0:	e8 b4 3d 00 00       	call   c0109799 <memset>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01059e5:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01059e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ec:	c1 e0 05             	shl    $0x5,%eax
c01059ef:	89 c2                	mov    %eax,%edx
c01059f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f4:	01 d0                	add    %edx,%eax
c01059f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01059f9:	0f 85 29 ff ff ff    	jne    c0105928 <default_init_memmap+0x3b>
        SetPageProperty(p);         //flag : PG_property to 1
        p->property = 0;            //property
        set_page_ref(p, 0);         //ref
        memset(&(p->page_link), 0, sizeof(list_entry_t));
    }
    list_add_before(&free_list, &(base->page_link)); //lowAddr-->highAddr page
c01059ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a02:	83 c0 0c             	add    $0xc,%eax
c0105a05:	c7 45 ec 2c b1 12 c0 	movl   $0xc012b12c,-0x14(%ebp)
c0105a0c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0105a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a12:	8b 00                	mov    (%eax),%eax
c0105a14:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105a17:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0105a1a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a20:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105a23:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105a26:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105a29:	89 10                	mov    %edx,(%eax)
c0105a2b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105a2e:	8b 10                	mov    (%eax),%edx
c0105a30:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105a33:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105a36:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105a39:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105a3c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105a3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105a42:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105a45:	89 10                	mov    %edx,(%eax)
    base->property = n;
c0105a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a4d:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0105a50:	8b 15 34 b1 12 c0    	mov    0xc012b134,%edx
c0105a56:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a59:	01 d0                	add    %edx,%eax
c0105a5b:	a3 34 b1 12 c0       	mov    %eax,0xc012b134
}
c0105a60:	90                   	nop
c0105a61:	c9                   	leave  
c0105a62:	c3                   	ret    

c0105a63 <default_alloc_pages>:

/*first fit*/
static struct Page *
default_alloc_pages(size_t n) {
c0105a63:	55                   	push   %ebp
c0105a64:	89 e5                	mov    %esp,%ebp
c0105a66:	53                   	push   %ebx
c0105a67:	83 ec 64             	sub    $0x64,%esp
    assert(n > 0);
c0105a6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a6e:	75 24                	jne    c0105a94 <default_alloc_pages+0x31>
c0105a70:	c7 44 24 0c f1 b4 10 	movl   $0xc010b4f1,0xc(%esp)
c0105a77:	c0 
c0105a78:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0105a7f:	c0 
c0105a80:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
c0105a87:	00 
c0105a88:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0105a8f:	e8 6c a9 ff ff       	call   c0100400 <__panic>
    if (n > nr_free) {
c0105a94:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0105a99:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105a9c:	73 0a                	jae    c0105aa8 <default_alloc_pages+0x45>
        return NULL;
c0105a9e:	b8 00 00 00 00       	mov    $0x0,%eax
c0105aa3:	e9 8d 01 00 00       	jmp    c0105c35 <default_alloc_pages+0x1d2>
    }
    struct Page *page = NULL;
c0105aa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0105aaf:	c7 45 f0 2c b1 12 c0 	movl   $0xc012b12c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105ab6:	eb 1c                	jmp    c0105ad4 <default_alloc_pages+0x71>
        struct Page *p = le2page(le, page_link);
c0105ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105abb:	83 e8 0c             	sub    $0xc,%eax
c0105abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n) {
c0105ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ac4:	8b 40 08             	mov    0x8(%eax),%eax
c0105ac7:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105aca:	72 08                	jb     c0105ad4 <default_alloc_pages+0x71>
            page = p;
c0105acc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0105ad2:	eb 18                	jmp    c0105aec <default_alloc_pages+0x89>
c0105ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ad7:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105ada:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105add:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0105ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ae3:	81 7d f0 2c b1 12 c0 	cmpl   $0xc012b12c,-0x10(%ebp)
c0105aea:	75 cc                	jne    c0105ab8 <default_alloc_pages+0x55>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0105aec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105af0:	0f 84 3c 01 00 00    	je     c0105c32 <default_alloc_pages+0x1cf>
        list_del(&(page->page_link));
c0105af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105af9:	83 c0 0c             	add    $0xc,%eax
c0105afc:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0105aff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b02:	8b 40 04             	mov    0x4(%eax),%eax
c0105b05:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105b08:	8b 12                	mov    (%edx),%edx
c0105b0a:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0105b0d:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0105b10:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105b13:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105b16:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105b19:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105b1c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105b1f:	89 10                	mov    %edx,(%eax)
       
        if (page->property > n) {
c0105b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b24:	8b 40 08             	mov    0x8(%eax),%eax
c0105b27:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105b2a:	76 6c                	jbe    c0105b98 <default_alloc_pages+0x135>
            struct Page *p = page + n;
c0105b2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b2f:	c1 e0 05             	shl    $0x5,%eax
c0105b32:	89 c2                	mov    %eax,%edx
c0105b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b37:	01 d0                	add    %edx,%eax
c0105b39:	89 45 dc             	mov    %eax,-0x24(%ebp)
            p->property = page->property - n;
c0105b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b3f:	8b 40 08             	mov    0x8(%eax),%eax
c0105b42:	2b 45 08             	sub    0x8(%ebp),%eax
c0105b45:	89 c2                	mov    %eax,%edx
c0105b47:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b4a:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(page->page_link.prev, &(p->page_link));
c0105b4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b50:	8d 50 0c             	lea    0xc(%eax),%edx
c0105b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b56:	8b 40 0c             	mov    0xc(%eax),%eax
c0105b59:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105b5c:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0105b5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b62:	8b 40 04             	mov    0x4(%eax),%eax
c0105b65:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105b68:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0105b6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105b6e:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0105b71:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105b74:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105b77:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105b7a:	89 10                	mov    %edx,(%eax)
c0105b7c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105b7f:	8b 10                	mov    (%eax),%edx
c0105b81:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105b84:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105b87:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105b8a:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105b8d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105b90:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105b93:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105b96:	89 10                	mov    %edx,(%eax)
            
        }
        
        page->property = n;
c0105b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b9b:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b9e:	89 50 08             	mov    %edx,0x8(%eax)
        for (int looper = 0; looper < n; looper++){
c0105ba1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105ba8:	eb 49                	jmp    c0105bf3 <default_alloc_pages+0x190>
            SetPageReserved(&(page[looper]));
c0105baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bad:	c1 e0 05             	shl    $0x5,%eax
c0105bb0:	89 c2                	mov    %eax,%edx
c0105bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bb5:	01 d0                	add    %edx,%eax
c0105bb7:	83 c0 04             	add    $0x4,%eax
c0105bba:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c0105bc1:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0105bc4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105bc7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105bca:	0f ab 10             	bts    %edx,(%eax)
            ClearPageProperty(&(page[looper]));
c0105bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bd0:	c1 e0 05             	shl    $0x5,%eax
c0105bd3:	89 c2                	mov    %eax,%edx
c0105bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bd8:	01 d0                	add    %edx,%eax
c0105bda:	83 c0 04             	add    $0x4,%eax
c0105bdd:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0105be4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105be7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105bea:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105bed:	0f b3 10             	btr    %edx,(%eax)
            list_add_after(page->page_link.prev, &(p->page_link));
            
        }
        
        page->property = n;
        for (int looper = 0; looper < n; looper++){
c0105bf0:	ff 45 ec             	incl   -0x14(%ebp)
c0105bf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bf6:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105bf9:	72 af                	jb     c0105baa <default_alloc_pages+0x147>
            SetPageReserved(&(page[looper]));
            ClearPageProperty(&(page[looper]));
            // page_ref_inc(&(page[looper]));
        }
        
        nr_free -= n;
c0105bfb:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0105c00:	2b 45 08             	sub    0x8(%ebp),%eax
c0105c03:	a3 34 b1 12 c0       	mov    %eax,0xc012b134
        memset(page2kva(page), 0, PGSIZE * page->property);
c0105c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c0b:	8b 40 08             	mov    0x8(%eax),%eax
c0105c0e:	c1 e0 0c             	shl    $0xc,%eax
c0105c11:	89 c3                	mov    %eax,%ebx
c0105c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c16:	89 04 24             	mov    %eax,(%esp)
c0105c19:	e8 35 fc ff ff       	call   c0105853 <page2kva>
c0105c1e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0105c22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105c29:	00 
c0105c2a:	89 04 24             	mov    %eax,(%esp)
c0105c2d:	e8 67 3b 00 00       	call   c0109799 <memset>
    }
    return page;
c0105c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c35:	83 c4 64             	add    $0x64,%esp
c0105c38:	5b                   	pop    %ebx
c0105c39:	5d                   	pop    %ebp
c0105c3a:	c3                   	ret    

c0105c3b <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0105c3b:	55                   	push   %ebp
c0105c3c:	89 e5                	mov    %esp,%ebp
c0105c3e:	81 ec b8 00 00 00    	sub    $0xb8,%esp
    cprintf("   prev = %p,\n", base->page_link.prev);
    cprintf("   next = %p\n", base->page_link.next);
    cprintf("  },\n");
    cprintf("}\n");
#endif
    assert(n > 0);
c0105c44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c48:	75 24                	jne    c0105c6e <default_free_pages+0x33>
c0105c4a:	c7 44 24 0c f1 b4 10 	movl   $0xc010b4f1,0xc(%esp)
c0105c51:	c0 
c0105c52:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0105c59:	c0 
c0105c5a:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0105c61:	00 
c0105c62:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0105c69:	e8 92 a7 ff ff       	call   c0100400 <__panic>
    struct Page *p = base;
c0105c6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c71:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105c74:	e9 c5 00 00 00       	jmp    c0105d3e <default_free_pages+0x103>
        assert(PageReserved(p) && !PageProperty(p));
c0105c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c7c:	83 c0 04             	add    $0x4,%eax
c0105c7f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
c0105c86:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105c89:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105c8c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105c8f:	0f a3 10             	bt     %edx,(%eax)
c0105c92:	19 c0                	sbb    %eax,%eax
c0105c94:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
c0105c97:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
c0105c9b:	0f 95 c0             	setne  %al
c0105c9e:	0f b6 c0             	movzbl %al,%eax
c0105ca1:	85 c0                	test   %eax,%eax
c0105ca3:	74 2c                	je     c0105cd1 <default_free_pages+0x96>
c0105ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ca8:	83 c0 04             	add    $0x4,%eax
c0105cab:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0105cb2:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105cb5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105cb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105cbb:	0f a3 10             	bt     %edx,(%eax)
c0105cbe:	19 c0                	sbb    %eax,%eax
c0105cc0:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0105cc3:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0105cc7:	0f 95 c0             	setne  %al
c0105cca:	0f b6 c0             	movzbl %al,%eax
c0105ccd:	85 c0                	test   %eax,%eax
c0105ccf:	74 24                	je     c0105cf5 <default_free_pages+0xba>
c0105cd1:	c7 44 24 0c 34 b5 10 	movl   $0xc010b534,0xc(%esp)
c0105cd8:	c0 
c0105cd9:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0105ce0:	c0 
c0105ce1:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0105ce8:	00 
c0105ce9:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0105cf0:	e8 0b a7 ff ff       	call   c0100400 <__panic>
        SetPageProperty(p);
c0105cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cf8:	83 c0 04             	add    $0x4,%eax
c0105cfb:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0105d02:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105d05:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105d08:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105d0b:	0f ab 10             	bts    %edx,(%eax)
        ClearPageReserved(p);
c0105d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d11:	83 c0 04             	add    $0x4,%eax
c0105d14:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0105d1b:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105d1e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105d21:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d24:	0f b3 10             	btr    %edx,(%eax)
        set_page_ref(p, 0);
c0105d27:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105d2e:	00 
c0105d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d32:	89 04 24             	mov    %eax,(%esp)
c0105d35:	e8 77 fb ff ff       	call   c01058b1 <set_page_ref>
    cprintf("  },\n");
    cprintf("}\n");
#endif
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0105d3a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0105d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d41:	c1 e0 05             	shl    $0x5,%eax
c0105d44:	89 c2                	mov    %eax,%edx
c0105d46:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d49:	01 d0                	add    %edx,%eax
c0105d4b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105d4e:	0f 85 25 ff ff ff    	jne    c0105c79 <default_free_pages+0x3e>
        assert(PageReserved(p) && !PageProperty(p));
        SetPageProperty(p);
        ClearPageReserved(p);
        set_page_ref(p, 0);
    }
    base->property = n;
c0105d54:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d57:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105d5a:	89 50 08             	mov    %edx,0x8(%eax)
c0105d5d:	c7 45 dc 2c b1 12 c0 	movl   $0xc012b12c,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105d64:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105d67:	8b 40 04             	mov    0x4(%eax),%eax
    
    list_entry_t *le = list_next(&free_list);
c0105d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *last = NULL, *next = 0xFFFFFFFF;
c0105d6d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105d74:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    while (le != &free_list) {
c0105d7b:	eb 44                	jmp    c0105dc1 <default_free_pages+0x186>
        p = le2page(le, page_link);
c0105d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d80:	83 e8 0c             	sub    $0xc,%eax
c0105d83:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d89:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0105d8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105d8f:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0105d92:	89 45 f0             	mov    %eax,-0x10(%ebp)

        if (p < base && p >= last ) last = p;
c0105d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d98:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105d9b:	73 0e                	jae    c0105dab <default_free_pages+0x170>
c0105d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105da0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105da3:	72 06                	jb     c0105dab <default_free_pages+0x170>
c0105da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105da8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p > base && p <= next) next = p;
c0105dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dae:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105db1:	76 0e                	jbe    c0105dc1 <default_free_pages+0x186>
c0105db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105db6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0105db9:	77 06                	ja     c0105dc1 <default_free_pages+0x186>
c0105dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
    }
    base->property = n;
    
    list_entry_t *le = list_next(&free_list);
    struct Page *last = NULL, *next = 0xFFFFFFFF;
    while (le != &free_list) {
c0105dc1:	81 7d f0 2c b1 12 c0 	cmpl   $0xc012b12c,-0x10(%ebp)
c0105dc8:	75 b3                	jne    c0105d7d <default_free_pages+0x142>

        if (p < base && p >= last ) last = p;
        if (p > base && p <= next) next = p;
    }

    if (last < base && last != NULL){
c0105dca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105dcd:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105dd0:	0f 83 b9 00 00 00    	jae    c0105e8f <default_free_pages+0x254>
c0105dd6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105dda:	0f 84 af 00 00 00    	je     c0105e8f <default_free_pages+0x254>
        list_add_after(&(last->page_link), &(base->page_link));
c0105de0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de3:	83 c0 0c             	add    $0xc,%eax
c0105de6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105de9:	83 c2 0c             	add    $0xc,%edx
c0105dec:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0105def:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0105df2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105df5:	8b 40 04             	mov    0x4(%eax),%eax
c0105df8:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105dfb:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0105dfe:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105e01:	89 55 98             	mov    %edx,-0x68(%ebp)
c0105e04:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105e07:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105e0a:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0105e0d:	89 10                	mov    %edx,(%eax)
c0105e0f:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105e12:	8b 10                	mov    (%eax),%edx
c0105e14:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105e17:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105e1a:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105e1d:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105e20:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105e23:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105e26:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105e29:	89 10                	mov    %edx,(%eax)
        if ((last + last->property) == base){
c0105e2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e2e:	8b 40 08             	mov    0x8(%eax),%eax
c0105e31:	c1 e0 05             	shl    $0x5,%eax
c0105e34:	89 c2                	mov    %eax,%edx
c0105e36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e39:	01 d0                	add    %edx,%eax
c0105e3b:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105e3e:	75 4f                	jne    c0105e8f <default_free_pages+0x254>
            last->property += base->property;
c0105e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e43:	8b 50 08             	mov    0x8(%eax),%edx
c0105e46:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e49:	8b 40 08             	mov    0x8(%eax),%eax
c0105e4c:	01 c2                	add    %eax,%edx
c0105e4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e51:	89 50 08             	mov    %edx,0x8(%eax)
            list_del(&(base->page_link));
c0105e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e57:	83 c0 0c             	add    $0xc,%eax
c0105e5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0105e5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105e60:	8b 40 04             	mov    0x4(%eax),%eax
c0105e63:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105e66:	8b 12                	mov    (%edx),%edx
c0105e68:	89 55 90             	mov    %edx,-0x70(%ebp)
c0105e6b:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0105e6e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105e71:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0105e74:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105e77:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105e7a:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105e7d:	89 10                	mov    %edx,(%eax)
            base->property = 0;
c0105e7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            base = last;
c0105e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e8c:	89 45 08             	mov    %eax,0x8(%ebp)
        }
    }

    if (base < next && next != 0xFFFFFFFF){
c0105e8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e92:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0105e95:	0f 83 de 00 00 00    	jae    c0105f79 <default_free_pages+0x33e>
c0105e9b:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
c0105e9f:	0f 84 d4 00 00 00    	je     c0105f79 <default_free_pages+0x33e>
        if (last > base || last == NULL)
c0105ea5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ea8:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105eab:	77 06                	ja     c0105eb3 <default_free_pages+0x278>
c0105ead:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105eb1:	75 56                	jne    c0105f09 <default_free_pages+0x2ce>
            list_add_before(&(next->page_link), &(base->page_link));
c0105eb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eb6:	83 c0 0c             	add    $0xc,%eax
c0105eb9:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105ebc:	83 c2 0c             	add    $0xc,%edx
c0105ebf:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105ec2:	89 45 88             	mov    %eax,-0x78(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0105ec5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105ec8:	8b 00                	mov    (%eax),%eax
c0105eca:	8b 55 88             	mov    -0x78(%ebp),%edx
c0105ecd:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0105ed0:	89 45 80             	mov    %eax,-0x80(%ebp)
c0105ed3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105ed6:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105edc:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0105ee2:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105ee5:	89 10                	mov    %edx,(%eax)
c0105ee7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0105eed:	8b 10                	mov    (%eax),%edx
c0105eef:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105ef2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105ef5:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105ef8:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0105efe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105f01:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105f04:	8b 55 80             	mov    -0x80(%ebp),%edx
c0105f07:	89 10                	mov    %edx,(%eax)
        if ((base + base->property) == next){
c0105f09:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f0c:	8b 40 08             	mov    0x8(%eax),%eax
c0105f0f:	c1 e0 05             	shl    $0x5,%eax
c0105f12:	89 c2                	mov    %eax,%edx
c0105f14:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f17:	01 d0                	add    %edx,%eax
c0105f19:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0105f1c:	75 5b                	jne    c0105f79 <default_free_pages+0x33e>
            base->property += next->property;
c0105f1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f21:	8b 50 08             	mov    0x8(%eax),%edx
c0105f24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f27:	8b 40 08             	mov    0x8(%eax),%eax
c0105f2a:	01 c2                	add    %eax,%edx
c0105f2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f2f:	89 50 08             	mov    %edx,0x8(%eax)
            list_del(&(next->page_link));
c0105f32:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f35:	83 c0 0c             	add    $0xc,%eax
c0105f38:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0105f3b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105f3e:	8b 40 04             	mov    0x4(%eax),%eax
c0105f41:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105f44:	8b 12                	mov    (%edx),%edx
c0105f46:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
c0105f4c:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0105f52:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0105f58:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c0105f5e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105f61:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0105f67:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c0105f6d:	89 10                	mov    %edx,(%eax)
            next->property = 0;
c0105f6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        }
    }

    if (last == NULL && next == 0xFFFFFFFF){
c0105f79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105f7d:	75 76                	jne    c0105ff5 <default_free_pages+0x3ba>
c0105f7f:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
c0105f83:	75 70                	jne    c0105ff5 <default_free_pages+0x3ba>
        list_add_after(&free_list, &(base->page_link));
c0105f85:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f88:	83 c0 0c             	add    $0xc,%eax
c0105f8b:	c7 45 c0 2c b1 12 c0 	movl   $0xc012b12c,-0x40(%ebp)
c0105f92:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0105f98:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105f9b:	8b 40 04             	mov    0x4(%eax),%eax
c0105f9e:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c0105fa4:	89 95 6c ff ff ff    	mov    %edx,-0x94(%ebp)
c0105faa:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105fad:	89 95 68 ff ff ff    	mov    %edx,-0x98(%ebp)
c0105fb3:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105fb9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
c0105fbf:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c0105fc5:	89 10                	mov    %edx,(%eax)
c0105fc7:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
c0105fcd:	8b 10                	mov    (%eax),%edx
c0105fcf:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c0105fd5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105fd8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0105fde:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
c0105fe4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105fe7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0105fed:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
c0105ff3:	89 10                	mov    %edx,(%eax)
    }
    
    nr_free += n;
c0105ff5:	8b 15 34 b1 12 c0    	mov    0xc012b134,%edx
c0105ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ffe:	01 d0                	add    %edx,%eax
c0106000:	a3 34 b1 12 c0       	mov    %eax,0xc012b134
}
c0106005:	90                   	nop
c0106006:	c9                   	leave  
c0106007:	c3                   	ret    

c0106008 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0106008:	55                   	push   %ebp
c0106009:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010600b:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
}
c0106010:	5d                   	pop    %ebp
c0106011:	c3                   	ret    

c0106012 <basic_check>:

static void
basic_check(void) {
c0106012:	55                   	push   %ebp
c0106013:	89 e5                	mov    %esp,%ebp
c0106015:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0106018:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010601f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106022:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106025:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106028:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010602b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106032:	e8 78 0e 00 00       	call   c0106eaf <alloc_pages>
c0106037:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010603a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010603e:	75 24                	jne    c0106064 <basic_check+0x52>
c0106040:	c7 44 24 0c 58 b5 10 	movl   $0xc010b558,0xc(%esp)
c0106047:	c0 
c0106048:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c010604f:	c0 
c0106050:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0106057:	00 
c0106058:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c010605f:	e8 9c a3 ff ff       	call   c0100400 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0106064:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010606b:	e8 3f 0e 00 00       	call   c0106eaf <alloc_pages>
c0106070:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106073:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106077:	75 24                	jne    c010609d <basic_check+0x8b>
c0106079:	c7 44 24 0c 74 b5 10 	movl   $0xc010b574,0xc(%esp)
c0106080:	c0 
c0106081:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106088:	c0 
c0106089:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0106090:	00 
c0106091:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106098:	e8 63 a3 ff ff       	call   c0100400 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010609d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01060a4:	e8 06 0e 00 00       	call   c0106eaf <alloc_pages>
c01060a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01060ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01060b0:	75 24                	jne    c01060d6 <basic_check+0xc4>
c01060b2:	c7 44 24 0c 90 b5 10 	movl   $0xc010b590,0xc(%esp)
c01060b9:	c0 
c01060ba:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c01060c1:	c0 
c01060c2:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01060c9:	00 
c01060ca:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c01060d1:	e8 2a a3 ff ff       	call   c0100400 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01060d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01060dc:	74 10                	je     c01060ee <basic_check+0xdc>
c01060de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060e1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01060e4:	74 08                	je     c01060ee <basic_check+0xdc>
c01060e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01060ec:	75 24                	jne    c0106112 <basic_check+0x100>
c01060ee:	c7 44 24 0c ac b5 10 	movl   $0xc010b5ac,0xc(%esp)
c01060f5:	c0 
c01060f6:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c01060fd:	c0 
c01060fe:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0106105:	00 
c0106106:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c010610d:	e8 ee a2 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0106112:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106115:	89 04 24             	mov    %eax,(%esp)
c0106118:	e8 8a f7 ff ff       	call   c01058a7 <page_ref>
c010611d:	85 c0                	test   %eax,%eax
c010611f:	75 1e                	jne    c010613f <basic_check+0x12d>
c0106121:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106124:	89 04 24             	mov    %eax,(%esp)
c0106127:	e8 7b f7 ff ff       	call   c01058a7 <page_ref>
c010612c:	85 c0                	test   %eax,%eax
c010612e:	75 0f                	jne    c010613f <basic_check+0x12d>
c0106130:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106133:	89 04 24             	mov    %eax,(%esp)
c0106136:	e8 6c f7 ff ff       	call   c01058a7 <page_ref>
c010613b:	85 c0                	test   %eax,%eax
c010613d:	74 24                	je     c0106163 <basic_check+0x151>
c010613f:	c7 44 24 0c d0 b5 10 	movl   $0xc010b5d0,0xc(%esp)
c0106146:	c0 
c0106147:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c010614e:	c0 
c010614f:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0106156:	00 
c0106157:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c010615e:	e8 9d a2 ff ff       	call   c0100400 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0106163:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106166:	89 04 24             	mov    %eax,(%esp)
c0106169:	e8 cf f6 ff ff       	call   c010583d <page2pa>
c010616e:	8b 15 80 8f 12 c0    	mov    0xc0128f80,%edx
c0106174:	c1 e2 0c             	shl    $0xc,%edx
c0106177:	39 d0                	cmp    %edx,%eax
c0106179:	72 24                	jb     c010619f <basic_check+0x18d>
c010617b:	c7 44 24 0c 0c b6 10 	movl   $0xc010b60c,0xc(%esp)
c0106182:	c0 
c0106183:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c010618a:	c0 
c010618b:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0106192:	00 
c0106193:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c010619a:	e8 61 a2 ff ff       	call   c0100400 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010619f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061a2:	89 04 24             	mov    %eax,(%esp)
c01061a5:	e8 93 f6 ff ff       	call   c010583d <page2pa>
c01061aa:	8b 15 80 8f 12 c0    	mov    0xc0128f80,%edx
c01061b0:	c1 e2 0c             	shl    $0xc,%edx
c01061b3:	39 d0                	cmp    %edx,%eax
c01061b5:	72 24                	jb     c01061db <basic_check+0x1c9>
c01061b7:	c7 44 24 0c 29 b6 10 	movl   $0xc010b629,0xc(%esp)
c01061be:	c0 
c01061bf:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c01061c6:	c0 
c01061c7:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c01061ce:	00 
c01061cf:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c01061d6:	e8 25 a2 ff ff       	call   c0100400 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01061db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061de:	89 04 24             	mov    %eax,(%esp)
c01061e1:	e8 57 f6 ff ff       	call   c010583d <page2pa>
c01061e6:	8b 15 80 8f 12 c0    	mov    0xc0128f80,%edx
c01061ec:	c1 e2 0c             	shl    $0xc,%edx
c01061ef:	39 d0                	cmp    %edx,%eax
c01061f1:	72 24                	jb     c0106217 <basic_check+0x205>
c01061f3:	c7 44 24 0c 46 b6 10 	movl   $0xc010b646,0xc(%esp)
c01061fa:	c0 
c01061fb:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106202:	c0 
c0106203:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c010620a:	00 
c010620b:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106212:	e8 e9 a1 ff ff       	call   c0100400 <__panic>

    list_entry_t free_list_store = free_list;
c0106217:	a1 2c b1 12 c0       	mov    0xc012b12c,%eax
c010621c:	8b 15 30 b1 12 c0    	mov    0xc012b130,%edx
c0106222:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106225:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106228:	c7 45 e4 2c b1 12 c0 	movl   $0xc012b12c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010622f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106235:	89 50 04             	mov    %edx,0x4(%eax)
c0106238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010623b:	8b 50 04             	mov    0x4(%eax),%edx
c010623e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106241:	89 10                	mov    %edx,(%eax)
c0106243:	c7 45 d8 2c b1 12 c0 	movl   $0xc012b12c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010624a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010624d:	8b 40 04             	mov    0x4(%eax),%eax
c0106250:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0106253:	0f 94 c0             	sete   %al
c0106256:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0106259:	85 c0                	test   %eax,%eax
c010625b:	75 24                	jne    c0106281 <basic_check+0x26f>
c010625d:	c7 44 24 0c 63 b6 10 	movl   $0xc010b663,0xc(%esp)
c0106264:	c0 
c0106265:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c010626c:	c0 
c010626d:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c0106274:	00 
c0106275:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c010627c:	e8 7f a1 ff ff       	call   c0100400 <__panic>

    unsigned int nr_free_store = nr_free;
c0106281:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0106286:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0106289:	c7 05 34 b1 12 c0 00 	movl   $0x0,0xc012b134
c0106290:	00 00 00 

    assert(alloc_page() == NULL);
c0106293:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010629a:	e8 10 0c 00 00       	call   c0106eaf <alloc_pages>
c010629f:	85 c0                	test   %eax,%eax
c01062a1:	74 24                	je     c01062c7 <basic_check+0x2b5>
c01062a3:	c7 44 24 0c 7a b6 10 	movl   $0xc010b67a,0xc(%esp)
c01062aa:	c0 
c01062ab:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c01062b2:	c0 
c01062b3:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01062ba:	00 
c01062bb:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c01062c2:	e8 39 a1 ff ff       	call   c0100400 <__panic>

    free_page(p0);
c01062c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062ce:	00 
c01062cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01062d2:	89 04 24             	mov    %eax,(%esp)
c01062d5:	e8 40 0c 00 00       	call   c0106f1a <free_pages>
    free_page(p1);
c01062da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062e1:	00 
c01062e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062e5:	89 04 24             	mov    %eax,(%esp)
c01062e8:	e8 2d 0c 00 00       	call   c0106f1a <free_pages>
    free_page(p2);
c01062ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062f4:	00 
c01062f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062f8:	89 04 24             	mov    %eax,(%esp)
c01062fb:	e8 1a 0c 00 00       	call   c0106f1a <free_pages>
    assert(nr_free == 3);
c0106300:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0106305:	83 f8 03             	cmp    $0x3,%eax
c0106308:	74 24                	je     c010632e <basic_check+0x31c>
c010630a:	c7 44 24 0c 8f b6 10 	movl   $0xc010b68f,0xc(%esp)
c0106311:	c0 
c0106312:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106319:	c0 
c010631a:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0106321:	00 
c0106322:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106329:	e8 d2 a0 ff ff       	call   c0100400 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010632e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106335:	e8 75 0b 00 00       	call   c0106eaf <alloc_pages>
c010633a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010633d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106341:	75 24                	jne    c0106367 <basic_check+0x355>
c0106343:	c7 44 24 0c 58 b5 10 	movl   $0xc010b558,0xc(%esp)
c010634a:	c0 
c010634b:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106352:	c0 
c0106353:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c010635a:	00 
c010635b:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106362:	e8 99 a0 ff ff       	call   c0100400 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0106367:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010636e:	e8 3c 0b 00 00       	call   c0106eaf <alloc_pages>
c0106373:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106376:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010637a:	75 24                	jne    c01063a0 <basic_check+0x38e>
c010637c:	c7 44 24 0c 74 b5 10 	movl   $0xc010b574,0xc(%esp)
c0106383:	c0 
c0106384:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c010638b:	c0 
c010638c:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0106393:	00 
c0106394:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c010639b:	e8 60 a0 ff ff       	call   c0100400 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01063a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01063a7:	e8 03 0b 00 00       	call   c0106eaf <alloc_pages>
c01063ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01063af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01063b3:	75 24                	jne    c01063d9 <basic_check+0x3c7>
c01063b5:	c7 44 24 0c 90 b5 10 	movl   $0xc010b590,0xc(%esp)
c01063bc:	c0 
c01063bd:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c01063c4:	c0 
c01063c5:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01063cc:	00 
c01063cd:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c01063d4:	e8 27 a0 ff ff       	call   c0100400 <__panic>

    assert(alloc_page() == NULL);
c01063d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01063e0:	e8 ca 0a 00 00       	call   c0106eaf <alloc_pages>
c01063e5:	85 c0                	test   %eax,%eax
c01063e7:	74 24                	je     c010640d <basic_check+0x3fb>
c01063e9:	c7 44 24 0c 7a b6 10 	movl   $0xc010b67a,0xc(%esp)
c01063f0:	c0 
c01063f1:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c01063f8:	c0 
c01063f9:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0106400:	00 
c0106401:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106408:	e8 f3 9f ff ff       	call   c0100400 <__panic>

    free_page(p0);
c010640d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106414:	00 
c0106415:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106418:	89 04 24             	mov    %eax,(%esp)
c010641b:	e8 fa 0a 00 00       	call   c0106f1a <free_pages>
c0106420:	c7 45 e8 2c b1 12 c0 	movl   $0xc012b12c,-0x18(%ebp)
c0106427:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010642a:	8b 40 04             	mov    0x4(%eax),%eax
c010642d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0106430:	0f 94 c0             	sete   %al
c0106433:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0106436:	85 c0                	test   %eax,%eax
c0106438:	74 24                	je     c010645e <basic_check+0x44c>
c010643a:	c7 44 24 0c 9c b6 10 	movl   $0xc010b69c,0xc(%esp)
c0106441:	c0 
c0106442:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106449:	c0 
c010644a:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0106451:	00 
c0106452:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106459:	e8 a2 9f ff ff       	call   c0100400 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010645e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106465:	e8 45 0a 00 00       	call   c0106eaf <alloc_pages>
c010646a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010646d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106470:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106473:	74 24                	je     c0106499 <basic_check+0x487>
c0106475:	c7 44 24 0c b4 b6 10 	movl   $0xc010b6b4,0xc(%esp)
c010647c:	c0 
c010647d:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106484:	c0 
c0106485:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c010648c:	00 
c010648d:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106494:	e8 67 9f ff ff       	call   c0100400 <__panic>
    assert(alloc_page() == NULL);
c0106499:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01064a0:	e8 0a 0a 00 00       	call   c0106eaf <alloc_pages>
c01064a5:	85 c0                	test   %eax,%eax
c01064a7:	74 24                	je     c01064cd <basic_check+0x4bb>
c01064a9:	c7 44 24 0c 7a b6 10 	movl   $0xc010b67a,0xc(%esp)
c01064b0:	c0 
c01064b1:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c01064b8:	c0 
c01064b9:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01064c0:	00 
c01064c1:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c01064c8:	e8 33 9f ff ff       	call   c0100400 <__panic>

    assert(nr_free == 0);
c01064cd:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c01064d2:	85 c0                	test   %eax,%eax
c01064d4:	74 24                	je     c01064fa <basic_check+0x4e8>
c01064d6:	c7 44 24 0c cd b6 10 	movl   $0xc010b6cd,0xc(%esp)
c01064dd:	c0 
c01064de:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c01064e5:	c0 
c01064e6:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c01064ed:	00 
c01064ee:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c01064f5:	e8 06 9f ff ff       	call   c0100400 <__panic>
    free_list = free_list_store;
c01064fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01064fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106500:	a3 2c b1 12 c0       	mov    %eax,0xc012b12c
c0106505:	89 15 30 b1 12 c0    	mov    %edx,0xc012b130
    nr_free = nr_free_store;
c010650b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010650e:	a3 34 b1 12 c0       	mov    %eax,0xc012b134

    free_page(p);
c0106513:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010651a:	00 
c010651b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010651e:	89 04 24             	mov    %eax,(%esp)
c0106521:	e8 f4 09 00 00       	call   c0106f1a <free_pages>
    free_page(p1);
c0106526:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010652d:	00 
c010652e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106531:	89 04 24             	mov    %eax,(%esp)
c0106534:	e8 e1 09 00 00       	call   c0106f1a <free_pages>
    free_page(p2);
c0106539:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106540:	00 
c0106541:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106544:	89 04 24             	mov    %eax,(%esp)
c0106547:	e8 ce 09 00 00       	call   c0106f1a <free_pages>
}
c010654c:	90                   	nop
c010654d:	c9                   	leave  
c010654e:	c3                   	ret    

c010654f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010654f:	55                   	push   %ebp
c0106550:	89 e5                	mov    %esp,%ebp
c0106552:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0106558:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010655f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0106566:	c7 45 ec 2c b1 12 c0 	movl   $0xc012b12c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010656d:	eb 6a                	jmp    c01065d9 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c010656f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106572:	83 e8 0c             	sub    $0xc,%eax
c0106575:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010657b:	83 c0 04             	add    $0x4,%eax
c010657e:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0106585:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106588:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010658b:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010658e:	0f a3 10             	bt     %edx,(%eax)
c0106591:	19 c0                	sbb    %eax,%eax
c0106593:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0106596:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c010659a:	0f 95 c0             	setne  %al
c010659d:	0f b6 c0             	movzbl %al,%eax
c01065a0:	85 c0                	test   %eax,%eax
c01065a2:	75 24                	jne    c01065c8 <default_check+0x79>
c01065a4:	c7 44 24 0c da b6 10 	movl   $0xc010b6da,0xc(%esp)
c01065ab:	c0 
c01065ac:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c01065b3:	c0 
c01065b4:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c01065bb:	00 
c01065bc:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c01065c3:	e8 38 9e ff ff       	call   c0100400 <__panic>
        count ++, total += p->property;
c01065c8:	ff 45 f4             	incl   -0xc(%ebp)
c01065cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065ce:	8b 50 08             	mov    0x8(%eax),%edx
c01065d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01065d4:	01 d0                	add    %edx,%eax
c01065d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01065d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01065dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01065df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01065e2:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01065e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01065e8:	81 7d ec 2c b1 12 c0 	cmpl   $0xc012b12c,-0x14(%ebp)
c01065ef:	0f 85 7a ff ff ff    	jne    c010656f <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01065f5:	e8 53 09 00 00       	call   c0106f4d <nr_free_pages>
c01065fa:	89 c2                	mov    %eax,%edx
c01065fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01065ff:	39 c2                	cmp    %eax,%edx
c0106601:	74 24                	je     c0106627 <default_check+0xd8>
c0106603:	c7 44 24 0c ea b6 10 	movl   $0xc010b6ea,0xc(%esp)
c010660a:	c0 
c010660b:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106612:	c0 
c0106613:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010661a:	00 
c010661b:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106622:	e8 d9 9d ff ff       	call   c0100400 <__panic>

    basic_check();
c0106627:	e8 e6 f9 ff ff       	call   c0106012 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010662c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0106633:	e8 77 08 00 00       	call   c0106eaf <alloc_pages>
c0106638:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c010663b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010663f:	75 24                	jne    c0106665 <default_check+0x116>
c0106641:	c7 44 24 0c 03 b7 10 	movl   $0xc010b703,0xc(%esp)
c0106648:	c0 
c0106649:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106650:	c0 
c0106651:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c0106658:	00 
c0106659:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106660:	e8 9b 9d ff ff       	call   c0100400 <__panic>
    assert(!PageProperty(p0));
c0106665:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106668:	83 c0 04             	add    $0x4,%eax
c010666b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0106672:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106675:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106678:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010667b:	0f a3 10             	bt     %edx,(%eax)
c010667e:	19 c0                	sbb    %eax,%eax
c0106680:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0106683:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0106687:	0f 95 c0             	setne  %al
c010668a:	0f b6 c0             	movzbl %al,%eax
c010668d:	85 c0                	test   %eax,%eax
c010668f:	74 24                	je     c01066b5 <default_check+0x166>
c0106691:	c7 44 24 0c 0e b7 10 	movl   $0xc010b70e,0xc(%esp)
c0106698:	c0 
c0106699:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c01066a0:	c0 
c01066a1:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c01066a8:	00 
c01066a9:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c01066b0:	e8 4b 9d ff ff       	call   c0100400 <__panic>

    list_entry_t free_list_store = free_list;
c01066b5:	a1 2c b1 12 c0       	mov    0xc012b12c,%eax
c01066ba:	8b 15 30 b1 12 c0    	mov    0xc012b130,%edx
c01066c0:	89 45 80             	mov    %eax,-0x80(%ebp)
c01066c3:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01066c6:	c7 45 d0 2c b1 12 c0 	movl   $0xc012b12c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01066cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01066d0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01066d3:	89 50 04             	mov    %edx,0x4(%eax)
c01066d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01066d9:	8b 50 04             	mov    0x4(%eax),%edx
c01066dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01066df:	89 10                	mov    %edx,(%eax)
c01066e1:	c7 45 d8 2c b1 12 c0 	movl   $0xc012b12c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01066e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01066eb:	8b 40 04             	mov    0x4(%eax),%eax
c01066ee:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01066f1:	0f 94 c0             	sete   %al
c01066f4:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01066f7:	85 c0                	test   %eax,%eax
c01066f9:	75 24                	jne    c010671f <default_check+0x1d0>
c01066fb:	c7 44 24 0c 63 b6 10 	movl   $0xc010b663,0xc(%esp)
c0106702:	c0 
c0106703:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c010670a:	c0 
c010670b:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0106712:	00 
c0106713:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c010671a:	e8 e1 9c ff ff       	call   c0100400 <__panic>
    assert(alloc_page() == NULL);
c010671f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106726:	e8 84 07 00 00       	call   c0106eaf <alloc_pages>
c010672b:	85 c0                	test   %eax,%eax
c010672d:	74 24                	je     c0106753 <default_check+0x204>
c010672f:	c7 44 24 0c 7a b6 10 	movl   $0xc010b67a,0xc(%esp)
c0106736:	c0 
c0106737:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c010673e:	c0 
c010673f:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c0106746:	00 
c0106747:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c010674e:	e8 ad 9c ff ff       	call   c0100400 <__panic>

    unsigned int nr_free_store = nr_free;
c0106753:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0106758:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c010675b:	c7 05 34 b1 12 c0 00 	movl   $0x0,0xc012b134
c0106762:	00 00 00 

    free_pages(p0 + 2, 3);
c0106765:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106768:	83 c0 40             	add    $0x40,%eax
c010676b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0106772:	00 
c0106773:	89 04 24             	mov    %eax,(%esp)
c0106776:	e8 9f 07 00 00       	call   c0106f1a <free_pages>
    assert(alloc_pages(4) == NULL);
c010677b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0106782:	e8 28 07 00 00       	call   c0106eaf <alloc_pages>
c0106787:	85 c0                	test   %eax,%eax
c0106789:	74 24                	je     c01067af <default_check+0x260>
c010678b:	c7 44 24 0c 20 b7 10 	movl   $0xc010b720,0xc(%esp)
c0106792:	c0 
c0106793:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c010679a:	c0 
c010679b:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c01067a2:	00 
c01067a3:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c01067aa:	e8 51 9c ff ff       	call   c0100400 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01067af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01067b2:	83 c0 40             	add    $0x40,%eax
c01067b5:	83 c0 04             	add    $0x4,%eax
c01067b8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01067bf:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01067c2:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01067c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01067c8:	0f a3 10             	bt     %edx,(%eax)
c01067cb:	19 c0                	sbb    %eax,%eax
c01067cd:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01067d0:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01067d4:	0f 95 c0             	setne  %al
c01067d7:	0f b6 c0             	movzbl %al,%eax
c01067da:	85 c0                	test   %eax,%eax
c01067dc:	74 0e                	je     c01067ec <default_check+0x29d>
c01067de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01067e1:	83 c0 40             	add    $0x40,%eax
c01067e4:	8b 40 08             	mov    0x8(%eax),%eax
c01067e7:	83 f8 03             	cmp    $0x3,%eax
c01067ea:	74 24                	je     c0106810 <default_check+0x2c1>
c01067ec:	c7 44 24 0c 38 b7 10 	movl   $0xc010b738,0xc(%esp)
c01067f3:	c0 
c01067f4:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c01067fb:	c0 
c01067fc:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c0106803:	00 
c0106804:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c010680b:	e8 f0 9b ff ff       	call   c0100400 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0106810:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0106817:	e8 93 06 00 00       	call   c0106eaf <alloc_pages>
c010681c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010681f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0106823:	75 24                	jne    c0106849 <default_check+0x2fa>
c0106825:	c7 44 24 0c 64 b7 10 	movl   $0xc010b764,0xc(%esp)
c010682c:	c0 
c010682d:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106834:	c0 
c0106835:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c010683c:	00 
c010683d:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106844:	e8 b7 9b ff ff       	call   c0100400 <__panic>
    assert(alloc_page() == NULL);
c0106849:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106850:	e8 5a 06 00 00       	call   c0106eaf <alloc_pages>
c0106855:	85 c0                	test   %eax,%eax
c0106857:	74 24                	je     c010687d <default_check+0x32e>
c0106859:	c7 44 24 0c 7a b6 10 	movl   $0xc010b67a,0xc(%esp)
c0106860:	c0 
c0106861:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106868:	c0 
c0106869:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0106870:	00 
c0106871:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106878:	e8 83 9b ff ff       	call   c0100400 <__panic>
    assert(p0 + 2 == p1);
c010687d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106880:	83 c0 40             	add    $0x40,%eax
c0106883:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0106886:	74 24                	je     c01068ac <default_check+0x35d>
c0106888:	c7 44 24 0c 82 b7 10 	movl   $0xc010b782,0xc(%esp)
c010688f:	c0 
c0106890:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106897:	c0 
c0106898:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c010689f:	00 
c01068a0:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c01068a7:	e8 54 9b ff ff       	call   c0100400 <__panic>

    p2 = p0 + 1;
c01068ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01068af:	83 c0 20             	add    $0x20,%eax
c01068b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c01068b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01068bc:	00 
c01068bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01068c0:	89 04 24             	mov    %eax,(%esp)
c01068c3:	e8 52 06 00 00       	call   c0106f1a <free_pages>
    free_pages(p1, 3);
c01068c8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01068cf:	00 
c01068d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01068d3:	89 04 24             	mov    %eax,(%esp)
c01068d6:	e8 3f 06 00 00       	call   c0106f1a <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01068db:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01068de:	83 c0 04             	add    $0x4,%eax
c01068e1:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c01068e8:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01068eb:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01068ee:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01068f1:	0f a3 10             	bt     %edx,(%eax)
c01068f4:	19 c0                	sbb    %eax,%eax
c01068f6:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c01068f9:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c01068fd:	0f 95 c0             	setne  %al
c0106900:	0f b6 c0             	movzbl %al,%eax
c0106903:	85 c0                	test   %eax,%eax
c0106905:	74 0b                	je     c0106912 <default_check+0x3c3>
c0106907:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010690a:	8b 40 08             	mov    0x8(%eax),%eax
c010690d:	83 f8 01             	cmp    $0x1,%eax
c0106910:	74 24                	je     c0106936 <default_check+0x3e7>
c0106912:	c7 44 24 0c 90 b7 10 	movl   $0xc010b790,0xc(%esp)
c0106919:	c0 
c010691a:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106921:	c0 
c0106922:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c0106929:	00 
c010692a:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106931:	e8 ca 9a ff ff       	call   c0100400 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0106936:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106939:	83 c0 04             	add    $0x4,%eax
c010693c:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0106943:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106946:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0106949:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010694c:	0f a3 10             	bt     %edx,(%eax)
c010694f:	19 c0                	sbb    %eax,%eax
c0106951:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0106954:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0106958:	0f 95 c0             	setne  %al
c010695b:	0f b6 c0             	movzbl %al,%eax
c010695e:	85 c0                	test   %eax,%eax
c0106960:	74 0b                	je     c010696d <default_check+0x41e>
c0106962:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106965:	8b 40 08             	mov    0x8(%eax),%eax
c0106968:	83 f8 03             	cmp    $0x3,%eax
c010696b:	74 24                	je     c0106991 <default_check+0x442>
c010696d:	c7 44 24 0c b8 b7 10 	movl   $0xc010b7b8,0xc(%esp)
c0106974:	c0 
c0106975:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c010697c:	c0 
c010697d:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
c0106984:	00 
c0106985:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c010698c:	e8 6f 9a ff ff       	call   c0100400 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0106991:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106998:	e8 12 05 00 00       	call   c0106eaf <alloc_pages>
c010699d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01069a0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01069a3:	83 e8 20             	sub    $0x20,%eax
c01069a6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01069a9:	74 24                	je     c01069cf <default_check+0x480>
c01069ab:	c7 44 24 0c de b7 10 	movl   $0xc010b7de,0xc(%esp)
c01069b2:	c0 
c01069b3:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c01069ba:	c0 
c01069bb:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
c01069c2:	00 
c01069c3:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c01069ca:	e8 31 9a ff ff       	call   c0100400 <__panic>
    free_page(p0);
c01069cf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01069d6:	00 
c01069d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01069da:	89 04 24             	mov    %eax,(%esp)
c01069dd:	e8 38 05 00 00       	call   c0106f1a <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01069e2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01069e9:	e8 c1 04 00 00       	call   c0106eaf <alloc_pages>
c01069ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01069f1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01069f4:	83 c0 20             	add    $0x20,%eax
c01069f7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01069fa:	74 24                	je     c0106a20 <default_check+0x4d1>
c01069fc:	c7 44 24 0c fc b7 10 	movl   $0xc010b7fc,0xc(%esp)
c0106a03:	c0 
c0106a04:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106a0b:	c0 
c0106a0c:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c0106a13:	00 
c0106a14:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106a1b:	e8 e0 99 ff ff       	call   c0100400 <__panic>

    free_pages(p0, 2);
c0106a20:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0106a27:	00 
c0106a28:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a2b:	89 04 24             	mov    %eax,(%esp)
c0106a2e:	e8 e7 04 00 00       	call   c0106f1a <free_pages>
    free_page(p2);
c0106a33:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106a3a:	00 
c0106a3b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106a3e:	89 04 24             	mov    %eax,(%esp)
c0106a41:	e8 d4 04 00 00       	call   c0106f1a <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0106a46:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0106a4d:	e8 5d 04 00 00       	call   c0106eaf <alloc_pages>
c0106a52:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106a55:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106a59:	75 24                	jne    c0106a7f <default_check+0x530>
c0106a5b:	c7 44 24 0c 1c b8 10 	movl   $0xc010b81c,0xc(%esp)
c0106a62:	c0 
c0106a63:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106a6a:	c0 
c0106a6b:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
c0106a72:	00 
c0106a73:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106a7a:	e8 81 99 ff ff       	call   c0100400 <__panic>
    assert(alloc_page() == NULL);
c0106a7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106a86:	e8 24 04 00 00       	call   c0106eaf <alloc_pages>
c0106a8b:	85 c0                	test   %eax,%eax
c0106a8d:	74 24                	je     c0106ab3 <default_check+0x564>
c0106a8f:	c7 44 24 0c 7a b6 10 	movl   $0xc010b67a,0xc(%esp)
c0106a96:	c0 
c0106a97:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106a9e:	c0 
c0106a9f:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
c0106aa6:	00 
c0106aa7:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106aae:	e8 4d 99 ff ff       	call   c0100400 <__panic>

    assert(nr_free == 0);
c0106ab3:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0106ab8:	85 c0                	test   %eax,%eax
c0106aba:	74 24                	je     c0106ae0 <default_check+0x591>
c0106abc:	c7 44 24 0c cd b6 10 	movl   $0xc010b6cd,0xc(%esp)
c0106ac3:	c0 
c0106ac4:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106acb:	c0 
c0106acc:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c0106ad3:	00 
c0106ad4:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106adb:	e8 20 99 ff ff       	call   c0100400 <__panic>
    nr_free = nr_free_store;
c0106ae0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106ae3:	a3 34 b1 12 c0       	mov    %eax,0xc012b134

    free_list = free_list_store;
c0106ae8:	8b 45 80             	mov    -0x80(%ebp),%eax
c0106aeb:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0106aee:	a3 2c b1 12 c0       	mov    %eax,0xc012b12c
c0106af3:	89 15 30 b1 12 c0    	mov    %edx,0xc012b130
    free_pages(p0, 5);
c0106af9:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0106b00:	00 
c0106b01:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106b04:	89 04 24             	mov    %eax,(%esp)
c0106b07:	e8 0e 04 00 00       	call   c0106f1a <free_pages>

    le = &free_list;
c0106b0c:	c7 45 ec 2c b1 12 c0 	movl   $0xc012b12c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106b13:	eb 1c                	jmp    c0106b31 <default_check+0x5e2>
        struct Page *p = le2page(le, page_link);
c0106b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b18:	83 e8 0c             	sub    $0xc,%eax
c0106b1b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c0106b1e:	ff 4d f4             	decl   -0xc(%ebp)
c0106b21:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106b24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106b27:	8b 40 08             	mov    0x8(%eax),%eax
c0106b2a:	29 c2                	sub    %eax,%edx
c0106b2c:	89 d0                	mov    %edx,%eax
c0106b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b34:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106b37:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106b3a:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0106b3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106b40:	81 7d ec 2c b1 12 c0 	cmpl   $0xc012b12c,-0x14(%ebp)
c0106b47:	75 cc                	jne    c0106b15 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0106b49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106b4d:	74 24                	je     c0106b73 <default_check+0x624>
c0106b4f:	c7 44 24 0c 3a b8 10 	movl   $0xc010b83a,0xc(%esp)
c0106b56:	c0 
c0106b57:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106b5e:	c0 
c0106b5f:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
c0106b66:	00 
c0106b67:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106b6e:	e8 8d 98 ff ff       	call   c0100400 <__panic>
    assert(total == 0);
c0106b73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106b77:	74 24                	je     c0106b9d <default_check+0x64e>
c0106b79:	c7 44 24 0c 45 b8 10 	movl   $0xc010b845,0xc(%esp)
c0106b80:	c0 
c0106b81:	c7 44 24 08 f7 b4 10 	movl   $0xc010b4f7,0x8(%esp)
c0106b88:	c0 
c0106b89:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c0106b90:	00 
c0106b91:	c7 04 24 0c b5 10 c0 	movl   $0xc010b50c,(%esp)
c0106b98:	e8 63 98 ff ff       	call   c0100400 <__panic>
}
c0106b9d:	90                   	nop
c0106b9e:	c9                   	leave  
c0106b9f:	c3                   	ret    

c0106ba0 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0106ba0:	55                   	push   %ebp
c0106ba1:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0106ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ba6:	8b 15 40 b1 12 c0    	mov    0xc012b140,%edx
c0106bac:	29 d0                	sub    %edx,%eax
c0106bae:	c1 f8 05             	sar    $0x5,%eax
}
c0106bb1:	5d                   	pop    %ebp
c0106bb2:	c3                   	ret    

c0106bb3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0106bb3:	55                   	push   %ebp
c0106bb4:	89 e5                	mov    %esp,%ebp
c0106bb6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0106bb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bbc:	89 04 24             	mov    %eax,(%esp)
c0106bbf:	e8 dc ff ff ff       	call   c0106ba0 <page2ppn>
c0106bc4:	c1 e0 0c             	shl    $0xc,%eax
}
c0106bc7:	c9                   	leave  
c0106bc8:	c3                   	ret    

c0106bc9 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0106bc9:	55                   	push   %ebp
c0106bca:	89 e5                	mov    %esp,%ebp
c0106bcc:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106bcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bd2:	c1 e8 0c             	shr    $0xc,%eax
c0106bd5:	89 c2                	mov    %eax,%edx
c0106bd7:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0106bdc:	39 c2                	cmp    %eax,%edx
c0106bde:	72 1c                	jb     c0106bfc <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106be0:	c7 44 24 08 80 b8 10 	movl   $0xc010b880,0x8(%esp)
c0106be7:	c0 
c0106be8:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0106bef:	00 
c0106bf0:	c7 04 24 9f b8 10 c0 	movl   $0xc010b89f,(%esp)
c0106bf7:	e8 04 98 ff ff       	call   c0100400 <__panic>
    }
    return &pages[PPN(pa)];
c0106bfc:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c0106c01:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c04:	c1 ea 0c             	shr    $0xc,%edx
c0106c07:	c1 e2 05             	shl    $0x5,%edx
c0106c0a:	01 d0                	add    %edx,%eax
}
c0106c0c:	c9                   	leave  
c0106c0d:	c3                   	ret    

c0106c0e <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0106c0e:	55                   	push   %ebp
c0106c0f:	89 e5                	mov    %esp,%ebp
c0106c11:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0106c14:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c17:	89 04 24             	mov    %eax,(%esp)
c0106c1a:	e8 94 ff ff ff       	call   c0106bb3 <page2pa>
c0106c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c25:	c1 e8 0c             	shr    $0xc,%eax
c0106c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c2b:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0106c30:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0106c33:	72 23                	jb     c0106c58 <page2kva+0x4a>
c0106c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c38:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106c3c:	c7 44 24 08 b0 b8 10 	movl   $0xc010b8b0,0x8(%esp)
c0106c43:	c0 
c0106c44:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0106c4b:	00 
c0106c4c:	c7 04 24 9f b8 10 c0 	movl   $0xc010b89f,(%esp)
c0106c53:	e8 a8 97 ff ff       	call   c0100400 <__panic>
c0106c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c5b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0106c60:	c9                   	leave  
c0106c61:	c3                   	ret    

c0106c62 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106c62:	55                   	push   %ebp
c0106c63:	89 e5                	mov    %esp,%ebp
c0106c65:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106c68:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c6b:	83 e0 01             	and    $0x1,%eax
c0106c6e:	85 c0                	test   %eax,%eax
c0106c70:	75 1c                	jne    c0106c8e <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106c72:	c7 44 24 08 d4 b8 10 	movl   $0xc010b8d4,0x8(%esp)
c0106c79:	c0 
c0106c7a:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0106c81:	00 
c0106c82:	c7 04 24 9f b8 10 c0 	movl   $0xc010b89f,(%esp)
c0106c89:	e8 72 97 ff ff       	call   c0100400 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106c96:	89 04 24             	mov    %eax,(%esp)
c0106c99:	e8 2b ff ff ff       	call   c0106bc9 <pa2page>
}
c0106c9e:	c9                   	leave  
c0106c9f:	c3                   	ret    

c0106ca0 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0106ca0:	55                   	push   %ebp
c0106ca1:	89 e5                	mov    %esp,%ebp
c0106ca3:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0106ca6:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ca9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106cae:	89 04 24             	mov    %eax,(%esp)
c0106cb1:	e8 13 ff ff ff       	call   c0106bc9 <pa2page>
}
c0106cb6:	c9                   	leave  
c0106cb7:	c3                   	ret    

c0106cb8 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0106cb8:	55                   	push   %ebp
c0106cb9:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0106cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cbe:	8b 00                	mov    (%eax),%eax
}
c0106cc0:	5d                   	pop    %ebp
c0106cc1:	c3                   	ret    

c0106cc2 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0106cc2:	55                   	push   %ebp
c0106cc3:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0106cc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cc8:	8b 00                	mov    (%eax),%eax
c0106cca:	8d 50 01             	lea    0x1(%eax),%edx
c0106ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cd0:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106cd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cd5:	8b 00                	mov    (%eax),%eax
}
c0106cd7:	5d                   	pop    %ebp
c0106cd8:	c3                   	ret    

c0106cd9 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0106cd9:	55                   	push   %ebp
c0106cda:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0106cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cdf:	8b 00                	mov    (%eax),%eax
c0106ce1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106ce4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ce7:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106ce9:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cec:	8b 00                	mov    (%eax),%eax
}
c0106cee:	5d                   	pop    %ebp
c0106cef:	c3                   	ret    

c0106cf0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0106cf0:	55                   	push   %ebp
c0106cf1:	89 e5                	mov    %esp,%ebp
c0106cf3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0106cf6:	9c                   	pushf  
c0106cf7:	58                   	pop    %eax
c0106cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0106cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0106cfe:	25 00 02 00 00       	and    $0x200,%eax
c0106d03:	85 c0                	test   %eax,%eax
c0106d05:	74 0c                	je     c0106d13 <__intr_save+0x23>
        intr_disable();
c0106d07:	e8 17 b4 ff ff       	call   c0102123 <intr_disable>
        return 1;
c0106d0c:	b8 01 00 00 00       	mov    $0x1,%eax
c0106d11:	eb 05                	jmp    c0106d18 <__intr_save+0x28>
    }
    return 0;
c0106d13:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d18:	c9                   	leave  
c0106d19:	c3                   	ret    

c0106d1a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0106d1a:	55                   	push   %ebp
c0106d1b:	89 e5                	mov    %esp,%ebp
c0106d1d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0106d20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106d24:	74 05                	je     c0106d2b <__intr_restore+0x11>
        intr_enable();
c0106d26:	e8 f1 b3 ff ff       	call   c010211c <intr_enable>
    }
}
c0106d2b:	90                   	nop
c0106d2c:	c9                   	leave  
c0106d2d:	c3                   	ret    

c0106d2e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0106d2e:	55                   	push   %ebp
c0106d2f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0106d31:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d34:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0106d37:	b8 23 00 00 00       	mov    $0x23,%eax
c0106d3c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0106d3e:	b8 23 00 00 00       	mov    $0x23,%eax
c0106d43:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0106d45:	b8 10 00 00 00       	mov    $0x10,%eax
c0106d4a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0106d4c:	b8 10 00 00 00       	mov    $0x10,%eax
c0106d51:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0106d53:	b8 10 00 00 00       	mov    $0x10,%eax
c0106d58:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0106d5a:	ea 61 6d 10 c0 08 00 	ljmp   $0x8,$0xc0106d61
}
c0106d61:	90                   	nop
c0106d62:	5d                   	pop    %ebp
c0106d63:	c3                   	ret    

c0106d64 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0106d64:	55                   	push   %ebp
c0106d65:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0106d67:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d6a:	a3 a4 8f 12 c0       	mov    %eax,0xc0128fa4
}
c0106d6f:	90                   	nop
c0106d70:	5d                   	pop    %ebp
c0106d71:	c3                   	ret    

c0106d72 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0106d72:	55                   	push   %ebp
c0106d73:	89 e5                	mov    %esp,%ebp
c0106d75:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0106d78:	b8 00 50 12 c0       	mov    $0xc0125000,%eax
c0106d7d:	89 04 24             	mov    %eax,(%esp)
c0106d80:	e8 df ff ff ff       	call   c0106d64 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0106d85:	66 c7 05 a8 8f 12 c0 	movw   $0x10,0xc0128fa8
c0106d8c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0106d8e:	66 c7 05 68 5a 12 c0 	movw   $0x68,0xc0125a68
c0106d95:	68 00 
c0106d97:	b8 a0 8f 12 c0       	mov    $0xc0128fa0,%eax
c0106d9c:	0f b7 c0             	movzwl %ax,%eax
c0106d9f:	66 a3 6a 5a 12 c0    	mov    %ax,0xc0125a6a
c0106da5:	b8 a0 8f 12 c0       	mov    $0xc0128fa0,%eax
c0106daa:	c1 e8 10             	shr    $0x10,%eax
c0106dad:	a2 6c 5a 12 c0       	mov    %al,0xc0125a6c
c0106db2:	0f b6 05 6d 5a 12 c0 	movzbl 0xc0125a6d,%eax
c0106db9:	24 f0                	and    $0xf0,%al
c0106dbb:	0c 09                	or     $0x9,%al
c0106dbd:	a2 6d 5a 12 c0       	mov    %al,0xc0125a6d
c0106dc2:	0f b6 05 6d 5a 12 c0 	movzbl 0xc0125a6d,%eax
c0106dc9:	24 ef                	and    $0xef,%al
c0106dcb:	a2 6d 5a 12 c0       	mov    %al,0xc0125a6d
c0106dd0:	0f b6 05 6d 5a 12 c0 	movzbl 0xc0125a6d,%eax
c0106dd7:	24 9f                	and    $0x9f,%al
c0106dd9:	a2 6d 5a 12 c0       	mov    %al,0xc0125a6d
c0106dde:	0f b6 05 6d 5a 12 c0 	movzbl 0xc0125a6d,%eax
c0106de5:	0c 80                	or     $0x80,%al
c0106de7:	a2 6d 5a 12 c0       	mov    %al,0xc0125a6d
c0106dec:	0f b6 05 6e 5a 12 c0 	movzbl 0xc0125a6e,%eax
c0106df3:	24 f0                	and    $0xf0,%al
c0106df5:	a2 6e 5a 12 c0       	mov    %al,0xc0125a6e
c0106dfa:	0f b6 05 6e 5a 12 c0 	movzbl 0xc0125a6e,%eax
c0106e01:	24 ef                	and    $0xef,%al
c0106e03:	a2 6e 5a 12 c0       	mov    %al,0xc0125a6e
c0106e08:	0f b6 05 6e 5a 12 c0 	movzbl 0xc0125a6e,%eax
c0106e0f:	24 df                	and    $0xdf,%al
c0106e11:	a2 6e 5a 12 c0       	mov    %al,0xc0125a6e
c0106e16:	0f b6 05 6e 5a 12 c0 	movzbl 0xc0125a6e,%eax
c0106e1d:	0c 40                	or     $0x40,%al
c0106e1f:	a2 6e 5a 12 c0       	mov    %al,0xc0125a6e
c0106e24:	0f b6 05 6e 5a 12 c0 	movzbl 0xc0125a6e,%eax
c0106e2b:	24 7f                	and    $0x7f,%al
c0106e2d:	a2 6e 5a 12 c0       	mov    %al,0xc0125a6e
c0106e32:	b8 a0 8f 12 c0       	mov    $0xc0128fa0,%eax
c0106e37:	c1 e8 18             	shr    $0x18,%eax
c0106e3a:	a2 6f 5a 12 c0       	mov    %al,0xc0125a6f

    // reload all segment registers
    lgdt(&gdt_pd);
c0106e3f:	c7 04 24 70 5a 12 c0 	movl   $0xc0125a70,(%esp)
c0106e46:	e8 e3 fe ff ff       	call   c0106d2e <lgdt>
c0106e4b:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0106e51:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0106e55:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0106e58:	90                   	nop
c0106e59:	c9                   	leave  
c0106e5a:	c3                   	ret    

c0106e5b <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0106e5b:	55                   	push   %ebp
c0106e5c:	89 e5                	mov    %esp,%ebp
c0106e5e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0106e61:	c7 05 38 b1 12 c0 64 	movl   $0xc010b864,0xc012b138
c0106e68:	b8 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0106e6b:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0106e70:	8b 00                	mov    (%eax),%eax
c0106e72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e76:	c7 04 24 00 b9 10 c0 	movl   $0xc010b900,(%esp)
c0106e7d:	e8 27 94 ff ff       	call   c01002a9 <cprintf>
    pmm_manager->init();
c0106e82:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0106e87:	8b 40 04             	mov    0x4(%eax),%eax
c0106e8a:	ff d0                	call   *%eax
}
c0106e8c:	90                   	nop
c0106e8d:	c9                   	leave  
c0106e8e:	c3                   	ret    

c0106e8f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0106e8f:	55                   	push   %ebp
c0106e90:	89 e5                	mov    %esp,%ebp
c0106e92:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0106e95:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0106e9a:	8b 40 08             	mov    0x8(%eax),%eax
c0106e9d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106ea0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106ea4:	8b 55 08             	mov    0x8(%ebp),%edx
c0106ea7:	89 14 24             	mov    %edx,(%esp)
c0106eaa:	ff d0                	call   *%eax
}
c0106eac:	90                   	nop
c0106ead:	c9                   	leave  
c0106eae:	c3                   	ret    

c0106eaf <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0106eaf:	55                   	push   %ebp
c0106eb0:	89 e5                	mov    %esp,%ebp
c0106eb2:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0106eb5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0106ebc:	e8 2f fe ff ff       	call   c0106cf0 <__intr_save>
c0106ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0106ec4:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0106ec9:	8b 40 0c             	mov    0xc(%eax),%eax
c0106ecc:	8b 55 08             	mov    0x8(%ebp),%edx
c0106ecf:	89 14 24             	mov    %edx,(%esp)
c0106ed2:	ff d0                	call   *%eax
c0106ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0106ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106eda:	89 04 24             	mov    %eax,(%esp)
c0106edd:	e8 38 fe ff ff       	call   c0106d1a <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0106ee2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106ee6:	75 2d                	jne    c0106f15 <alloc_pages+0x66>
c0106ee8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0106eec:	77 27                	ja     c0106f15 <alloc_pages+0x66>
c0106eee:	a1 68 8f 12 c0       	mov    0xc0128f68,%eax
c0106ef3:	85 c0                	test   %eax,%eax
c0106ef5:	74 1e                	je     c0106f15 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0106ef7:	8b 55 08             	mov    0x8(%ebp),%edx
c0106efa:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c0106eff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106f06:	00 
c0106f07:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106f0b:	89 04 24             	mov    %eax,(%esp)
c0106f0e:	e8 05 d2 ff ff       	call   c0104118 <swap_out>
    }
c0106f13:	eb a7                	jmp    c0106ebc <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0106f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106f18:	c9                   	leave  
c0106f19:	c3                   	ret    

c0106f1a <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0106f1a:	55                   	push   %ebp
c0106f1b:	89 e5                	mov    %esp,%ebp
c0106f1d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0106f20:	e8 cb fd ff ff       	call   c0106cf0 <__intr_save>
c0106f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0106f28:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0106f2d:	8b 40 10             	mov    0x10(%eax),%eax
c0106f30:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106f33:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106f37:	8b 55 08             	mov    0x8(%ebp),%edx
c0106f3a:	89 14 24             	mov    %edx,(%esp)
c0106f3d:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0106f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f42:	89 04 24             	mov    %eax,(%esp)
c0106f45:	e8 d0 fd ff ff       	call   c0106d1a <__intr_restore>
}
c0106f4a:	90                   	nop
c0106f4b:	c9                   	leave  
c0106f4c:	c3                   	ret    

c0106f4d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0106f4d:	55                   	push   %ebp
c0106f4e:	89 e5                	mov    %esp,%ebp
c0106f50:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0106f53:	e8 98 fd ff ff       	call   c0106cf0 <__intr_save>
c0106f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0106f5b:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0106f60:	8b 40 14             	mov    0x14(%eax),%eax
c0106f63:	ff d0                	call   *%eax
c0106f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0106f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f6b:	89 04 24             	mov    %eax,(%esp)
c0106f6e:	e8 a7 fd ff ff       	call   c0106d1a <__intr_restore>
    return ret;
c0106f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0106f76:	c9                   	leave  
c0106f77:	c3                   	ret    

c0106f78 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0106f78:	55                   	push   %ebp
c0106f79:	89 e5                	mov    %esp,%ebp
c0106f7b:	57                   	push   %edi
c0106f7c:	56                   	push   %esi
c0106f7d:	53                   	push   %ebx
c0106f7e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0106f84:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0106f8b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0106f92:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0106f99:	c7 04 24 17 b9 10 c0 	movl   $0xc010b917,(%esp)
c0106fa0:	e8 04 93 ff ff       	call   c01002a9 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0106fa5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106fac:	e9 22 01 00 00       	jmp    c01070d3 <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106fb1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106fb4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106fb7:	89 d0                	mov    %edx,%eax
c0106fb9:	c1 e0 02             	shl    $0x2,%eax
c0106fbc:	01 d0                	add    %edx,%eax
c0106fbe:	c1 e0 02             	shl    $0x2,%eax
c0106fc1:	01 c8                	add    %ecx,%eax
c0106fc3:	8b 50 08             	mov    0x8(%eax),%edx
c0106fc6:	8b 40 04             	mov    0x4(%eax),%eax
c0106fc9:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106fcc:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0106fcf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106fd2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106fd5:	89 d0                	mov    %edx,%eax
c0106fd7:	c1 e0 02             	shl    $0x2,%eax
c0106fda:	01 d0                	add    %edx,%eax
c0106fdc:	c1 e0 02             	shl    $0x2,%eax
c0106fdf:	01 c8                	add    %ecx,%eax
c0106fe1:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106fe4:	8b 58 10             	mov    0x10(%eax),%ebx
c0106fe7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106fea:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0106fed:	01 c8                	add    %ecx,%eax
c0106fef:	11 da                	adc    %ebx,%edx
c0106ff1:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0106ff4:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0106ff7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106ffa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106ffd:	89 d0                	mov    %edx,%eax
c0106fff:	c1 e0 02             	shl    $0x2,%eax
c0107002:	01 d0                	add    %edx,%eax
c0107004:	c1 e0 02             	shl    $0x2,%eax
c0107007:	01 c8                	add    %ecx,%eax
c0107009:	83 c0 14             	add    $0x14,%eax
c010700c:	8b 00                	mov    (%eax),%eax
c010700e:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0107011:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0107014:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0107017:	83 c0 ff             	add    $0xffffffff,%eax
c010701a:	83 d2 ff             	adc    $0xffffffff,%edx
c010701d:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0107023:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0107029:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010702c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010702f:	89 d0                	mov    %edx,%eax
c0107031:	c1 e0 02             	shl    $0x2,%eax
c0107034:	01 d0                	add    %edx,%eax
c0107036:	c1 e0 02             	shl    $0x2,%eax
c0107039:	01 c8                	add    %ecx,%eax
c010703b:	8b 48 0c             	mov    0xc(%eax),%ecx
c010703e:	8b 58 10             	mov    0x10(%eax),%ebx
c0107041:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0107044:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0107048:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c010704e:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0107054:	89 44 24 14          	mov    %eax,0x14(%esp)
c0107058:	89 54 24 18          	mov    %edx,0x18(%esp)
c010705c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010705f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0107062:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107066:	89 54 24 10          	mov    %edx,0x10(%esp)
c010706a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010706e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0107072:	c7 04 24 24 b9 10 c0 	movl   $0xc010b924,(%esp)
c0107079:	e8 2b 92 ff ff       	call   c01002a9 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c010707e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0107081:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107084:	89 d0                	mov    %edx,%eax
c0107086:	c1 e0 02             	shl    $0x2,%eax
c0107089:	01 d0                	add    %edx,%eax
c010708b:	c1 e0 02             	shl    $0x2,%eax
c010708e:	01 c8                	add    %ecx,%eax
c0107090:	83 c0 14             	add    $0x14,%eax
c0107093:	8b 00                	mov    (%eax),%eax
c0107095:	83 f8 01             	cmp    $0x1,%eax
c0107098:	75 36                	jne    c01070d0 <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
c010709a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010709d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01070a0:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01070a3:	77 2b                	ja     c01070d0 <page_init+0x158>
c01070a5:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01070a8:	72 05                	jb     c01070af <page_init+0x137>
c01070aa:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01070ad:	73 21                	jae    c01070d0 <page_init+0x158>
c01070af:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01070b3:	77 1b                	ja     c01070d0 <page_init+0x158>
c01070b5:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01070b9:	72 09                	jb     c01070c4 <page_init+0x14c>
c01070bb:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01070c2:	77 0c                	ja     c01070d0 <page_init+0x158>
                maxpa = end;
c01070c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01070c7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01070ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01070cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01070d0:	ff 45 dc             	incl   -0x24(%ebp)
c01070d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01070d6:	8b 00                	mov    (%eax),%eax
c01070d8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01070db:	0f 8f d0 fe ff ff    	jg     c0106fb1 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01070e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01070e5:	72 1d                	jb     c0107104 <page_init+0x18c>
c01070e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01070eb:	77 09                	ja     c01070f6 <page_init+0x17e>
c01070ed:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01070f4:	76 0e                	jbe    c0107104 <page_init+0x18c>
        maxpa = KMEMSIZE;
c01070f6:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01070fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0107104:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107107:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010710a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010710e:	c1 ea 0c             	shr    $0xc,%edx
c0107111:	a3 80 8f 12 c0       	mov    %eax,0xc0128f80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0107116:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c010711d:	b8 4c b1 12 c0       	mov    $0xc012b14c,%eax
c0107122:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107125:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0107128:	01 d0                	add    %edx,%eax
c010712a:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010712d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107130:	ba 00 00 00 00       	mov    $0x0,%edx
c0107135:	f7 75 ac             	divl   -0x54(%ebp)
c0107138:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010713b:	29 d0                	sub    %edx,%eax
c010713d:	a3 40 b1 12 c0       	mov    %eax,0xc012b140

    for (i = 0; i < npage; i ++) {
c0107142:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0107149:	eb 26                	jmp    c0107171 <page_init+0x1f9>
        SetPageReserved(pages + i);
c010714b:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c0107150:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107153:	c1 e2 05             	shl    $0x5,%edx
c0107156:	01 d0                	add    %edx,%eax
c0107158:	83 c0 04             	add    $0x4,%eax
c010715b:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0107162:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0107165:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0107168:	8b 55 90             	mov    -0x70(%ebp),%edx
c010716b:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c010716e:	ff 45 dc             	incl   -0x24(%ebp)
c0107171:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107174:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0107179:	39 c2                	cmp    %eax,%edx
c010717b:	72 ce                	jb     c010714b <page_init+0x1d3>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010717d:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0107182:	c1 e0 05             	shl    $0x5,%eax
c0107185:	89 c2                	mov    %eax,%edx
c0107187:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c010718c:	01 d0                	add    %edx,%eax
c010718e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0107191:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0107198:	77 23                	ja     c01071bd <page_init+0x245>
c010719a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010719d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01071a1:	c7 44 24 08 54 b9 10 	movl   $0xc010b954,0x8(%esp)
c01071a8:	c0 
c01071a9:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c01071b0:	00 
c01071b1:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c01071b8:	e8 43 92 ff ff       	call   c0100400 <__panic>
c01071bd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01071c0:	05 00 00 00 40       	add    $0x40000000,%eax
c01071c5:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01071c8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01071cf:	e9 61 01 00 00       	jmp    c0107335 <page_init+0x3bd>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01071d4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01071d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01071da:	89 d0                	mov    %edx,%eax
c01071dc:	c1 e0 02             	shl    $0x2,%eax
c01071df:	01 d0                	add    %edx,%eax
c01071e1:	c1 e0 02             	shl    $0x2,%eax
c01071e4:	01 c8                	add    %ecx,%eax
c01071e6:	8b 50 08             	mov    0x8(%eax),%edx
c01071e9:	8b 40 04             	mov    0x4(%eax),%eax
c01071ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01071ef:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01071f2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01071f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01071f8:	89 d0                	mov    %edx,%eax
c01071fa:	c1 e0 02             	shl    $0x2,%eax
c01071fd:	01 d0                	add    %edx,%eax
c01071ff:	c1 e0 02             	shl    $0x2,%eax
c0107202:	01 c8                	add    %ecx,%eax
c0107204:	8b 48 0c             	mov    0xc(%eax),%ecx
c0107207:	8b 58 10             	mov    0x10(%eax),%ebx
c010720a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010720d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107210:	01 c8                	add    %ecx,%eax
c0107212:	11 da                	adc    %ebx,%edx
c0107214:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0107217:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010721a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010721d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107220:	89 d0                	mov    %edx,%eax
c0107222:	c1 e0 02             	shl    $0x2,%eax
c0107225:	01 d0                	add    %edx,%eax
c0107227:	c1 e0 02             	shl    $0x2,%eax
c010722a:	01 c8                	add    %ecx,%eax
c010722c:	83 c0 14             	add    $0x14,%eax
c010722f:	8b 00                	mov    (%eax),%eax
c0107231:	83 f8 01             	cmp    $0x1,%eax
c0107234:	0f 85 f8 00 00 00    	jne    c0107332 <page_init+0x3ba>
            if (begin < freemem) {
c010723a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010723d:	ba 00 00 00 00       	mov    $0x0,%edx
c0107242:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107245:	72 17                	jb     c010725e <page_init+0x2e6>
c0107247:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010724a:	77 05                	ja     c0107251 <page_init+0x2d9>
c010724c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010724f:	76 0d                	jbe    c010725e <page_init+0x2e6>
                begin = freemem;
c0107251:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107254:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107257:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010725e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107262:	72 1d                	jb     c0107281 <page_init+0x309>
c0107264:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107268:	77 09                	ja     c0107273 <page_init+0x2fb>
c010726a:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0107271:	76 0e                	jbe    c0107281 <page_init+0x309>
                end = KMEMSIZE;
c0107273:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010727a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0107281:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107284:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107287:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010728a:	0f 87 a2 00 00 00    	ja     c0107332 <page_init+0x3ba>
c0107290:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0107293:	72 09                	jb     c010729e <page_init+0x326>
c0107295:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0107298:	0f 83 94 00 00 00    	jae    c0107332 <page_init+0x3ba>
                begin = ROUNDUP(begin, PGSIZE);
c010729e:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01072a5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01072a8:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01072ab:	01 d0                	add    %edx,%eax
c01072ad:	48                   	dec    %eax
c01072ae:	89 45 98             	mov    %eax,-0x68(%ebp)
c01072b1:	8b 45 98             	mov    -0x68(%ebp),%eax
c01072b4:	ba 00 00 00 00       	mov    $0x0,%edx
c01072b9:	f7 75 9c             	divl   -0x64(%ebp)
c01072bc:	8b 45 98             	mov    -0x68(%ebp),%eax
c01072bf:	29 d0                	sub    %edx,%eax
c01072c1:	ba 00 00 00 00       	mov    $0x0,%edx
c01072c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01072c9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01072cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01072cf:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01072d2:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01072d5:	ba 00 00 00 00       	mov    $0x0,%edx
c01072da:	89 c3                	mov    %eax,%ebx
c01072dc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c01072e2:	89 de                	mov    %ebx,%esi
c01072e4:	89 d0                	mov    %edx,%eax
c01072e6:	83 e0 00             	and    $0x0,%eax
c01072e9:	89 c7                	mov    %eax,%edi
c01072eb:	89 75 c8             	mov    %esi,-0x38(%ebp)
c01072ee:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c01072f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01072f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01072f7:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01072fa:	77 36                	ja     c0107332 <page_init+0x3ba>
c01072fc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01072ff:	72 05                	jb     c0107306 <page_init+0x38e>
c0107301:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0107304:	73 2c                	jae    c0107332 <page_init+0x3ba>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0107306:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107309:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010730c:	2b 45 d0             	sub    -0x30(%ebp),%eax
c010730f:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0107312:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0107316:	c1 ea 0c             	shr    $0xc,%edx
c0107319:	89 c3                	mov    %eax,%ebx
c010731b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010731e:	89 04 24             	mov    %eax,(%esp)
c0107321:	e8 a3 f8 ff ff       	call   c0106bc9 <pa2page>
c0107326:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010732a:	89 04 24             	mov    %eax,(%esp)
c010732d:	e8 5d fb ff ff       	call   c0106e8f <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0107332:	ff 45 dc             	incl   -0x24(%ebp)
c0107335:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0107338:	8b 00                	mov    (%eax),%eax
c010733a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010733d:	0f 8f 91 fe ff ff    	jg     c01071d4 <page_init+0x25c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0107343:	90                   	nop
c0107344:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010734a:	5b                   	pop    %ebx
c010734b:	5e                   	pop    %esi
c010734c:	5f                   	pop    %edi
c010734d:	5d                   	pop    %ebp
c010734e:	c3                   	ret    

c010734f <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010734f:	55                   	push   %ebp
c0107350:	89 e5                	mov    %esp,%ebp
c0107352:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0107355:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107358:	33 45 14             	xor    0x14(%ebp),%eax
c010735b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0107360:	85 c0                	test   %eax,%eax
c0107362:	74 24                	je     c0107388 <boot_map_segment+0x39>
c0107364:	c7 44 24 0c 86 b9 10 	movl   $0xc010b986,0xc(%esp)
c010736b:	c0 
c010736c:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107373:	c0 
c0107374:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c010737b:	00 
c010737c:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107383:	e8 78 90 ff ff       	call   c0100400 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0107388:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010738f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107392:	25 ff 0f 00 00       	and    $0xfff,%eax
c0107397:	89 c2                	mov    %eax,%edx
c0107399:	8b 45 10             	mov    0x10(%ebp),%eax
c010739c:	01 c2                	add    %eax,%edx
c010739e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073a1:	01 d0                	add    %edx,%eax
c01073a3:	48                   	dec    %eax
c01073a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01073a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01073aa:	ba 00 00 00 00       	mov    $0x0,%edx
c01073af:	f7 75 f0             	divl   -0x10(%ebp)
c01073b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01073b5:	29 d0                	sub    %edx,%eax
c01073b7:	c1 e8 0c             	shr    $0xc,%eax
c01073ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01073bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01073c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01073c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01073cb:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01073ce:	8b 45 14             	mov    0x14(%ebp),%eax
c01073d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01073d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01073d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01073dc:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01073df:	eb 68                	jmp    c0107449 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01073e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01073e8:	00 
c01073e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01073f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01073f3:	89 04 24             	mov    %eax,(%esp)
c01073f6:	e8 86 01 00 00       	call   c0107581 <get_pte>
c01073fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01073fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107402:	75 24                	jne    c0107428 <boot_map_segment+0xd9>
c0107404:	c7 44 24 0c b2 b9 10 	movl   $0xc010b9b2,0xc(%esp)
c010740b:	c0 
c010740c:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107413:	c0 
c0107414:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c010741b:	00 
c010741c:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107423:	e8 d8 8f ff ff       	call   c0100400 <__panic>
        *ptep = pa | PTE_P | perm;
c0107428:	8b 45 14             	mov    0x14(%ebp),%eax
c010742b:	0b 45 18             	or     0x18(%ebp),%eax
c010742e:	83 c8 01             	or     $0x1,%eax
c0107431:	89 c2                	mov    %eax,%edx
c0107433:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107436:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0107438:	ff 4d f4             	decl   -0xc(%ebp)
c010743b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0107442:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0107449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010744d:	75 92                	jne    c01073e1 <boot_map_segment+0x92>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010744f:	90                   	nop
c0107450:	c9                   	leave  
c0107451:	c3                   	ret    

c0107452 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0107452:	55                   	push   %ebp
c0107453:	89 e5                	mov    %esp,%ebp
c0107455:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0107458:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010745f:	e8 4b fa ff ff       	call   c0106eaf <alloc_pages>
c0107464:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0107467:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010746b:	75 1c                	jne    c0107489 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010746d:	c7 44 24 08 bf b9 10 	movl   $0xc010b9bf,0x8(%esp)
c0107474:	c0 
c0107475:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c010747c:	00 
c010747d:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107484:	e8 77 8f ff ff       	call   c0100400 <__panic>
    }
    return page2kva(p);
c0107489:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010748c:	89 04 24             	mov    %eax,(%esp)
c010748f:	e8 7a f7 ff ff       	call   c0106c0e <page2kva>
}
c0107494:	c9                   	leave  
c0107495:	c3                   	ret    

c0107496 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0107496:	55                   	push   %ebp
c0107497:	89 e5                	mov    %esp,%ebp
c0107499:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010749c:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c01074a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01074a4:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01074ab:	77 23                	ja     c01074d0 <pmm_init+0x3a>
c01074ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01074b4:	c7 44 24 08 54 b9 10 	movl   $0xc010b954,0x8(%esp)
c01074bb:	c0 
c01074bc:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01074c3:	00 
c01074c4:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c01074cb:	e8 30 8f ff ff       	call   c0100400 <__panic>
c01074d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074d3:	05 00 00 00 40       	add    $0x40000000,%eax
c01074d8:	a3 3c b1 12 c0       	mov    %eax,0xc012b13c
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01074dd:	e8 79 f9 ff ff       	call   c0106e5b <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01074e2:	e8 91 fa ff ff       	call   c0106f78 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01074e7:	e8 25 05 00 00       	call   c0107a11 <check_alloc_page>

    check_pgdir();
c01074ec:	e8 3f 05 00 00       	call   c0107a30 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01074f1:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c01074f6:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01074fc:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107501:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107504:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010750b:	77 23                	ja     c0107530 <pmm_init+0x9a>
c010750d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107510:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107514:	c7 44 24 08 54 b9 10 	movl   $0xc010b954,0x8(%esp)
c010751b:	c0 
c010751c:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
c0107523:	00 
c0107524:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c010752b:	e8 d0 8e ff ff       	call   c0100400 <__panic>
c0107530:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107533:	05 00 00 00 40       	add    $0x40000000,%eax
c0107538:	83 c8 03             	or     $0x3,%eax
c010753b:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010753d:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107542:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0107549:	00 
c010754a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107551:	00 
c0107552:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0107559:	38 
c010755a:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0107561:	c0 
c0107562:	89 04 24             	mov    %eax,(%esp)
c0107565:	e8 e5 fd ff ff       	call   c010734f <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010756a:	e8 03 f8 ff ff       	call   c0106d72 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010756f:	e8 58 0b 00 00       	call   c01080cc <check_boot_pgdir>

    print_pgdir();
c0107574:	e8 d1 0f 00 00       	call   c010854a <print_pgdir>
    
    kmalloc_init();
c0107579:	e8 d2 da ff ff       	call   c0105050 <kmalloc_init>

}
c010757e:	90                   	nop
c010757f:	c9                   	leave  
c0107580:	c3                   	ret    

c0107581 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0107581:	55                   	push   %ebp
c0107582:	89 e5                	mov    %esp,%ebp
c0107584:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = NULL;
c0107587:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    pde_t *base_addr = pgdir;       //第一个空闲页表
c010758e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107591:	89 45 f0             	mov    %eax,-0x10(%ebp)

    pdep = &base_addr[PDX(la)];
c0107594:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107597:	c1 e8 16             	shr    $0x16,%eax
c010759a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01075a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075a4:	01 d0                	add    %edx,%eax
c01075a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep)&PTE_P) == 0){
c01075a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01075ac:	8b 00                	mov    (%eax),%eax
c01075ae:	83 e0 01             	and    $0x1,%eax
c01075b1:	85 c0                	test   %eax,%eax
c01075b3:	0f 85 ae 00 00 00    	jne    c0107667 <get_pte+0xe6>
        struct Page *page = NULL;
c01075b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

        if (create == 0 || (page = alloc_page()) == NULL) return NULL;
c01075c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01075c4:	74 15                	je     c01075db <get_pte+0x5a>
c01075c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01075cd:	e8 dd f8 ff ff       	call   c0106eaf <alloc_pages>
c01075d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01075d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01075d9:	75 0a                	jne    c01075e5 <get_pte+0x64>
c01075db:	b8 00 00 00 00       	mov    $0x0,%eax
c01075e0:	e9 df 00 00 00       	jmp    c01076c4 <get_pte+0x143>

        uintptr_t pa_page = page2pa(page);
c01075e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01075e8:	89 04 24             	mov    %eax,(%esp)
c01075eb:	e8 c3 f5 ff ff       	call   c0106bb3 <page2pa>
c01075f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        memset(KADDR(pa_page), 0, PGSIZE);
c01075f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01075f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01075f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01075fc:	c1 e8 0c             	shr    $0xc,%eax
c01075ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107602:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0107607:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010760a:	72 23                	jb     c010762f <get_pte+0xae>
c010760c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010760f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107613:	c7 44 24 08 b0 b8 10 	movl   $0xc010b8b0,0x8(%esp)
c010761a:	c0 
c010761b:	c7 44 24 04 84 01 00 	movl   $0x184,0x4(%esp)
c0107622:	00 
c0107623:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c010762a:	e8 d1 8d ff ff       	call   c0100400 <__panic>
c010762f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107632:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107637:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010763e:	00 
c010763f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107646:	00 
c0107647:	89 04 24             	mov    %eax,(%esp)
c010764a:	e8 4a 21 00 00       	call   c0109799 <memset>
        *pdep = pa_page | PTE_P | PTE_U | PTE_W;
c010764f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107652:	83 c8 07             	or     $0x7,%eax
c0107655:	89 c2                	mov    %eax,%edx
c0107657:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010765a:	89 10                	mov    %edx,(%eax)
        page_ref_inc(page);
c010765c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010765f:	89 04 24             	mov    %eax,(%esp)
c0107662:	e8 5b f6 ff ff       	call   c0106cc2 <page_ref_inc>
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0107667:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010766a:	8b 00                	mov    (%eax),%eax
c010766c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107671:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107674:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107677:	c1 e8 0c             	shr    $0xc,%eax
c010767a:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010767d:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0107682:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0107685:	72 23                	jb     c01076aa <get_pte+0x129>
c0107687:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010768a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010768e:	c7 44 24 08 b0 b8 10 	movl   $0xc010b8b0,0x8(%esp)
c0107695:	c0 
c0107696:	c7 44 24 04 88 01 00 	movl   $0x188,0x4(%esp)
c010769d:	00 
c010769e:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c01076a5:	e8 56 8d ff ff       	call   c0100400 <__panic>
c01076aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01076ad:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01076b2:	89 c2                	mov    %eax,%edx
c01076b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01076b7:	c1 e8 0c             	shr    $0xc,%eax
c01076ba:	25 ff 03 00 00       	and    $0x3ff,%eax
c01076bf:	c1 e0 02             	shl    $0x2,%eax
c01076c2:	01 d0                	add    %edx,%eax
}
c01076c4:	c9                   	leave  
c01076c5:	c3                   	ret    

c01076c6 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01076c6:	55                   	push   %ebp
c01076c7:	89 e5                	mov    %esp,%ebp
c01076c9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01076cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01076d3:	00 
c01076d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01076d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076db:	8b 45 08             	mov    0x8(%ebp),%eax
c01076de:	89 04 24             	mov    %eax,(%esp)
c01076e1:	e8 9b fe ff ff       	call   c0107581 <get_pte>
c01076e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01076e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01076ed:	74 08                	je     c01076f7 <get_page+0x31>
        *ptep_store = ptep;
c01076ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01076f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01076f5:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01076f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01076fb:	74 1b                	je     c0107718 <get_page+0x52>
c01076fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107700:	8b 00                	mov    (%eax),%eax
c0107702:	83 e0 01             	and    $0x1,%eax
c0107705:	85 c0                	test   %eax,%eax
c0107707:	74 0f                	je     c0107718 <get_page+0x52>
        return pte2page(*ptep);
c0107709:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010770c:	8b 00                	mov    (%eax),%eax
c010770e:	89 04 24             	mov    %eax,(%esp)
c0107711:	e8 4c f5 ff ff       	call   c0106c62 <pte2page>
c0107716:	eb 05                	jmp    c010771d <get_page+0x57>
    }
    return NULL;
c0107718:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010771d:	c9                   	leave  
c010771e:	c3                   	ret    

c010771f <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010771f:	55                   	push   %ebp
c0107720:	89 e5                	mov    %esp,%ebp
c0107722:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    pde_t *pdep = NULL;
c0107725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    pde_t *base_addr = pgdir;
c010772c:	8b 45 08             	mov    0x8(%ebp),%eax
c010772f:	89 45 f0             	mov    %eax,-0x10(%ebp)

    pdep = &base_addr[PDX(la)];
c0107732:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107735:	c1 e8 16             	shr    $0x16,%eax
c0107738:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010773f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107742:	01 d0                	add    %edx,%eax
c0107744:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep)&PTE_P) == 0 || ((*ptep)&PTE_P) == 0){
c0107747:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010774a:	8b 00                	mov    (%eax),%eax
c010774c:	83 e0 01             	and    $0x1,%eax
c010774f:	85 c0                	test   %eax,%eax
c0107751:	0f 84 92 00 00 00    	je     c01077e9 <page_remove_pte+0xca>
c0107757:	8b 45 10             	mov    0x10(%ebp),%eax
c010775a:	8b 00                	mov    (%eax),%eax
c010775c:	83 e0 01             	and    $0x1,%eax
c010775f:	85 c0                	test   %eax,%eax
c0107761:	0f 84 82 00 00 00    	je     c01077e9 <page_remove_pte+0xca>
        return;
    }else{
        struct Page *page = pte2page(*ptep);
c0107767:	8b 45 10             	mov    0x10(%ebp),%eax
c010776a:	8b 00                	mov    (%eax),%eax
c010776c:	89 04 24             	mov    %eax,(%esp)
c010776f:	e8 ee f4 ff ff       	call   c0106c62 <pte2page>
c0107774:	89 45 ec             	mov    %eax,-0x14(%ebp)
        
        assert(page->ref != 0);
c0107777:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010777a:	8b 00                	mov    (%eax),%eax
c010777c:	85 c0                	test   %eax,%eax
c010777e:	75 24                	jne    c01077a4 <page_remove_pte+0x85>
c0107780:	c7 44 24 0c d8 b9 10 	movl   $0xc010b9d8,0xc(%esp)
c0107787:	c0 
c0107788:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c010778f:	c0 
c0107790:	c7 44 24 04 bf 01 00 	movl   $0x1bf,0x4(%esp)
c0107797:	00 
c0107798:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c010779f:	e8 5c 8c ff ff       	call   c0100400 <__panic>
        if (page_ref_dec(page) == 0){
c01077a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01077a7:	89 04 24             	mov    %eax,(%esp)
c01077aa:	e8 2a f5 ff ff       	call   c0106cd9 <page_ref_dec>
c01077af:	85 c0                	test   %eax,%eax
c01077b1:	75 37                	jne    c01077ea <page_remove_pte+0xcb>
            free_page(page);
c01077b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01077ba:	00 
c01077bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01077be:	89 04 24             	mov    %eax,(%esp)
c01077c1:	e8 54 f7 ff ff       	call   c0106f1a <free_pages>
            *ptep = *ptep & ~PTE_P;
c01077c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01077c9:	8b 00                	mov    (%eax),%eax
c01077cb:	83 e0 fe             	and    $0xfffffffe,%eax
c01077ce:	89 c2                	mov    %eax,%edx
c01077d0:	8b 45 10             	mov    0x10(%ebp),%eax
c01077d3:	89 10                	mov    %edx,(%eax)
            tlb_invalidate(base_addr, la);
c01077d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01077dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01077df:	89 04 24             	mov    %eax,(%esp)
c01077e2:	e8 03 01 00 00       	call   c01078ea <tlb_invalidate>
c01077e7:	eb 01                	jmp    c01077ea <page_remove_pte+0xcb>
    pde_t *pdep = NULL;
    pde_t *base_addr = pgdir;

    pdep = &base_addr[PDX(la)];
    if (((*pdep)&PTE_P) == 0 || ((*ptep)&PTE_P) == 0){
        return;
c01077e9:	90                   	nop
            *ptep = *ptep & ~PTE_P;
            tlb_invalidate(base_addr, la);
        } 
    }   

}
c01077ea:	c9                   	leave  
c01077eb:	c3                   	ret    

c01077ec <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01077ec:	55                   	push   %ebp
c01077ed:	89 e5                	mov    %esp,%ebp
c01077ef:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01077f2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01077f9:	00 
c01077fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107801:	8b 45 08             	mov    0x8(%ebp),%eax
c0107804:	89 04 24             	mov    %eax,(%esp)
c0107807:	e8 75 fd ff ff       	call   c0107581 <get_pte>
c010780c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010780f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107813:	74 19                	je     c010782e <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0107815:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107818:	89 44 24 08          	mov    %eax,0x8(%esp)
c010781c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010781f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107823:	8b 45 08             	mov    0x8(%ebp),%eax
c0107826:	89 04 24             	mov    %eax,(%esp)
c0107829:	e8 f1 fe ff ff       	call   c010771f <page_remove_pte>
    }
}
c010782e:	90                   	nop
c010782f:	c9                   	leave  
c0107830:	c3                   	ret    

c0107831 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0107831:	55                   	push   %ebp
c0107832:	89 e5                	mov    %esp,%ebp
c0107834:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0107837:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010783e:	00 
c010783f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107842:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107846:	8b 45 08             	mov    0x8(%ebp),%eax
c0107849:	89 04 24             	mov    %eax,(%esp)
c010784c:	e8 30 fd ff ff       	call   c0107581 <get_pte>
c0107851:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0107854:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107858:	75 0a                	jne    c0107864 <page_insert+0x33>
        return -E_NO_MEM;
c010785a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010785f:	e9 84 00 00 00       	jmp    c01078e8 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0107864:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107867:	89 04 24             	mov    %eax,(%esp)
c010786a:	e8 53 f4 ff ff       	call   c0106cc2 <page_ref_inc>
    if (*ptep & PTE_P) {
c010786f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107872:	8b 00                	mov    (%eax),%eax
c0107874:	83 e0 01             	and    $0x1,%eax
c0107877:	85 c0                	test   %eax,%eax
c0107879:	74 3e                	je     c01078b9 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010787b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010787e:	8b 00                	mov    (%eax),%eax
c0107880:	89 04 24             	mov    %eax,(%esp)
c0107883:	e8 da f3 ff ff       	call   c0106c62 <pte2page>
c0107888:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010788b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010788e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107891:	75 0d                	jne    c01078a0 <page_insert+0x6f>
            page_ref_dec(page);
c0107893:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107896:	89 04 24             	mov    %eax,(%esp)
c0107899:	e8 3b f4 ff ff       	call   c0106cd9 <page_ref_dec>
c010789e:	eb 19                	jmp    c01078b9 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01078a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078a3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01078a7:	8b 45 10             	mov    0x10(%ebp),%eax
c01078aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01078b1:	89 04 24             	mov    %eax,(%esp)
c01078b4:	e8 66 fe ff ff       	call   c010771f <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01078b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078bc:	89 04 24             	mov    %eax,(%esp)
c01078bf:	e8 ef f2 ff ff       	call   c0106bb3 <page2pa>
c01078c4:	0b 45 14             	or     0x14(%ebp),%eax
c01078c7:	83 c8 01             	or     $0x1,%eax
c01078ca:	89 c2                	mov    %eax,%edx
c01078cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078cf:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01078d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01078d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01078db:	89 04 24             	mov    %eax,(%esp)
c01078de:	e8 07 00 00 00       	call   c01078ea <tlb_invalidate>
    return 0;
c01078e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01078e8:	c9                   	leave  
c01078e9:	c3                   	ret    

c01078ea <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01078ea:	55                   	push   %ebp
c01078eb:	89 e5                	mov    %esp,%ebp
c01078ed:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01078f0:	0f 20 d8             	mov    %cr3,%eax
c01078f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c01078f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01078f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01078fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01078ff:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0107906:	77 23                	ja     c010792b <tlb_invalidate+0x41>
c0107908:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010790b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010790f:	c7 44 24 08 54 b9 10 	movl   $0xc010b954,0x8(%esp)
c0107916:	c0 
c0107917:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c010791e:	00 
c010791f:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107926:	e8 d5 8a ff ff       	call   c0100400 <__panic>
c010792b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010792e:	05 00 00 00 40       	add    $0x40000000,%eax
c0107933:	39 c2                	cmp    %eax,%edx
c0107935:	75 0c                	jne    c0107943 <tlb_invalidate+0x59>
        invlpg((void *)la);
c0107937:	8b 45 0c             	mov    0xc(%ebp),%eax
c010793a:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010793d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107940:	0f 01 38             	invlpg (%eax)
    }
}
c0107943:	90                   	nop
c0107944:	c9                   	leave  
c0107945:	c3                   	ret    

c0107946 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0107946:	55                   	push   %ebp
c0107947:	89 e5                	mov    %esp,%ebp
c0107949:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c010794c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107953:	e8 57 f5 ff ff       	call   c0106eaf <alloc_pages>
c0107958:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c010795b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010795f:	0f 84 a7 00 00 00    	je     c0107a0c <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0107965:	8b 45 10             	mov    0x10(%ebp),%eax
c0107968:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010796c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010796f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107973:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107976:	89 44 24 04          	mov    %eax,0x4(%esp)
c010797a:	8b 45 08             	mov    0x8(%ebp),%eax
c010797d:	89 04 24             	mov    %eax,(%esp)
c0107980:	e8 ac fe ff ff       	call   c0107831 <page_insert>
c0107985:	85 c0                	test   %eax,%eax
c0107987:	74 1a                	je     c01079a3 <pgdir_alloc_page+0x5d>
            free_page(page);
c0107989:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107990:	00 
c0107991:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107994:	89 04 24             	mov    %eax,(%esp)
c0107997:	e8 7e f5 ff ff       	call   c0106f1a <free_pages>
            return NULL;
c010799c:	b8 00 00 00 00       	mov    $0x0,%eax
c01079a1:	eb 6c                	jmp    c0107a0f <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c01079a3:	a1 68 8f 12 c0       	mov    0xc0128f68,%eax
c01079a8:	85 c0                	test   %eax,%eax
c01079aa:	74 60                	je     c0107a0c <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c01079ac:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c01079b1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01079b8:	00 
c01079b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01079bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01079c0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01079c3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01079c7:	89 04 24             	mov    %eax,(%esp)
c01079ca:	e8 fd c6 ff ff       	call   c01040cc <swap_map_swappable>
            page->pra_vaddr=la;
c01079cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079d2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01079d5:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01079d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079db:	89 04 24             	mov    %eax,(%esp)
c01079de:	e8 d5 f2 ff ff       	call   c0106cb8 <page_ref>
c01079e3:	83 f8 01             	cmp    $0x1,%eax
c01079e6:	74 24                	je     c0107a0c <pgdir_alloc_page+0xc6>
c01079e8:	c7 44 24 0c e7 b9 10 	movl   $0xc010b9e7,0xc(%esp)
c01079ef:	c0 
c01079f0:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c01079f7:	c0 
c01079f8:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c01079ff:	00 
c0107a00:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107a07:	e8 f4 89 ff ff       	call   c0100400 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0107a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107a0f:	c9                   	leave  
c0107a10:	c3                   	ret    

c0107a11 <check_alloc_page>:

static void
check_alloc_page(void) {
c0107a11:	55                   	push   %ebp
c0107a12:	89 e5                	mov    %esp,%ebp
c0107a14:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0107a17:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0107a1c:	8b 40 18             	mov    0x18(%eax),%eax
c0107a1f:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0107a21:	c7 04 24 fc b9 10 c0 	movl   $0xc010b9fc,(%esp)
c0107a28:	e8 7c 88 ff ff       	call   c01002a9 <cprintf>
}
c0107a2d:	90                   	nop
c0107a2e:	c9                   	leave  
c0107a2f:	c3                   	ret    

c0107a30 <check_pgdir>:

static void
check_pgdir(void) {
c0107a30:	55                   	push   %ebp
c0107a31:	89 e5                	mov    %esp,%ebp
c0107a33:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0107a36:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0107a3b:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0107a40:	76 24                	jbe    c0107a66 <check_pgdir+0x36>
c0107a42:	c7 44 24 0c 1b ba 10 	movl   $0xc010ba1b,0xc(%esp)
c0107a49:	c0 
c0107a4a:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107a51:	c0 
c0107a52:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0107a59:	00 
c0107a5a:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107a61:	e8 9a 89 ff ff       	call   c0100400 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0107a66:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107a6b:	85 c0                	test   %eax,%eax
c0107a6d:	74 0e                	je     c0107a7d <check_pgdir+0x4d>
c0107a6f:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107a74:	25 ff 0f 00 00       	and    $0xfff,%eax
c0107a79:	85 c0                	test   %eax,%eax
c0107a7b:	74 24                	je     c0107aa1 <check_pgdir+0x71>
c0107a7d:	c7 44 24 0c 38 ba 10 	movl   $0xc010ba38,0xc(%esp)
c0107a84:	c0 
c0107a85:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107a8c:	c0 
c0107a8d:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0107a94:	00 
c0107a95:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107a9c:	e8 5f 89 ff ff       	call   c0100400 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0107aa1:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107aa6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107aad:	00 
c0107aae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107ab5:	00 
c0107ab6:	89 04 24             	mov    %eax,(%esp)
c0107ab9:	e8 08 fc ff ff       	call   c01076c6 <get_page>
c0107abe:	85 c0                	test   %eax,%eax
c0107ac0:	74 24                	je     c0107ae6 <check_pgdir+0xb6>
c0107ac2:	c7 44 24 0c 70 ba 10 	movl   $0xc010ba70,0xc(%esp)
c0107ac9:	c0 
c0107aca:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107ad1:	c0 
c0107ad2:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0107ad9:	00 
c0107ada:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107ae1:	e8 1a 89 ff ff       	call   c0100400 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0107ae6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107aed:	e8 bd f3 ff ff       	call   c0106eaf <alloc_pages>
c0107af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0107af5:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107afa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107b01:	00 
c0107b02:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107b09:	00 
c0107b0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b0d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107b11:	89 04 24             	mov    %eax,(%esp)
c0107b14:	e8 18 fd ff ff       	call   c0107831 <page_insert>
c0107b19:	85 c0                	test   %eax,%eax
c0107b1b:	74 24                	je     c0107b41 <check_pgdir+0x111>
c0107b1d:	c7 44 24 0c 98 ba 10 	movl   $0xc010ba98,0xc(%esp)
c0107b24:	c0 
c0107b25:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107b2c:	c0 
c0107b2d:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0107b34:	00 
c0107b35:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107b3c:	e8 bf 88 ff ff       	call   c0100400 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0107b41:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107b46:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107b4d:	00 
c0107b4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107b55:	00 
c0107b56:	89 04 24             	mov    %eax,(%esp)
c0107b59:	e8 23 fa ff ff       	call   c0107581 <get_pte>
c0107b5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107b65:	75 24                	jne    c0107b8b <check_pgdir+0x15b>
c0107b67:	c7 44 24 0c c4 ba 10 	movl   $0xc010bac4,0xc(%esp)
c0107b6e:	c0 
c0107b6f:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107b76:	c0 
c0107b77:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0107b7e:	00 
c0107b7f:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107b86:	e8 75 88 ff ff       	call   c0100400 <__panic>
    assert(pte2page(*ptep) == p1);
c0107b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b8e:	8b 00                	mov    (%eax),%eax
c0107b90:	89 04 24             	mov    %eax,(%esp)
c0107b93:	e8 ca f0 ff ff       	call   c0106c62 <pte2page>
c0107b98:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107b9b:	74 24                	je     c0107bc1 <check_pgdir+0x191>
c0107b9d:	c7 44 24 0c f1 ba 10 	movl   $0xc010baf1,0xc(%esp)
c0107ba4:	c0 
c0107ba5:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107bac:	c0 
c0107bad:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0107bb4:	00 
c0107bb5:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107bbc:	e8 3f 88 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p1) == 1);
c0107bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107bc4:	89 04 24             	mov    %eax,(%esp)
c0107bc7:	e8 ec f0 ff ff       	call   c0106cb8 <page_ref>
c0107bcc:	83 f8 01             	cmp    $0x1,%eax
c0107bcf:	74 24                	je     c0107bf5 <check_pgdir+0x1c5>
c0107bd1:	c7 44 24 0c 07 bb 10 	movl   $0xc010bb07,0xc(%esp)
c0107bd8:	c0 
c0107bd9:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107be0:	c0 
c0107be1:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0107be8:	00 
c0107be9:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107bf0:	e8 0b 88 ff ff       	call   c0100400 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0107bf5:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107bfa:	8b 00                	mov    (%eax),%eax
c0107bfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107c01:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c07:	c1 e8 0c             	shr    $0xc,%eax
c0107c0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107c0d:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0107c12:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0107c15:	72 23                	jb     c0107c3a <check_pgdir+0x20a>
c0107c17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107c1e:	c7 44 24 08 b0 b8 10 	movl   $0xc010b8b0,0x8(%esp)
c0107c25:	c0 
c0107c26:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0107c2d:	00 
c0107c2e:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107c35:	e8 c6 87 ff ff       	call   c0100400 <__panic>
c0107c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c3d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107c42:	83 c0 04             	add    $0x4,%eax
c0107c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0107c48:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107c4d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107c54:	00 
c0107c55:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107c5c:	00 
c0107c5d:	89 04 24             	mov    %eax,(%esp)
c0107c60:	e8 1c f9 ff ff       	call   c0107581 <get_pte>
c0107c65:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107c68:	74 24                	je     c0107c8e <check_pgdir+0x25e>
c0107c6a:	c7 44 24 0c 1c bb 10 	movl   $0xc010bb1c,0xc(%esp)
c0107c71:	c0 
c0107c72:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107c79:	c0 
c0107c7a:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0107c81:	00 
c0107c82:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107c89:	e8 72 87 ff ff       	call   c0100400 <__panic>

    p2 = alloc_page();
c0107c8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107c95:	e8 15 f2 ff ff       	call   c0106eaf <alloc_pages>
c0107c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0107c9d:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107ca2:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0107ca9:	00 
c0107caa:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107cb1:	00 
c0107cb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107cb5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107cb9:	89 04 24             	mov    %eax,(%esp)
c0107cbc:	e8 70 fb ff ff       	call   c0107831 <page_insert>
c0107cc1:	85 c0                	test   %eax,%eax
c0107cc3:	74 24                	je     c0107ce9 <check_pgdir+0x2b9>
c0107cc5:	c7 44 24 0c 44 bb 10 	movl   $0xc010bb44,0xc(%esp)
c0107ccc:	c0 
c0107ccd:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107cd4:	c0 
c0107cd5:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0107cdc:	00 
c0107cdd:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107ce4:	e8 17 87 ff ff       	call   c0100400 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107ce9:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107cee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107cf5:	00 
c0107cf6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107cfd:	00 
c0107cfe:	89 04 24             	mov    %eax,(%esp)
c0107d01:	e8 7b f8 ff ff       	call   c0107581 <get_pte>
c0107d06:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107d09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107d0d:	75 24                	jne    c0107d33 <check_pgdir+0x303>
c0107d0f:	c7 44 24 0c 7c bb 10 	movl   $0xc010bb7c,0xc(%esp)
c0107d16:	c0 
c0107d17:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107d1e:	c0 
c0107d1f:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0107d26:	00 
c0107d27:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107d2e:	e8 cd 86 ff ff       	call   c0100400 <__panic>
    assert(*ptep & PTE_U);
c0107d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107d36:	8b 00                	mov    (%eax),%eax
c0107d38:	83 e0 04             	and    $0x4,%eax
c0107d3b:	85 c0                	test   %eax,%eax
c0107d3d:	75 24                	jne    c0107d63 <check_pgdir+0x333>
c0107d3f:	c7 44 24 0c ac bb 10 	movl   $0xc010bbac,0xc(%esp)
c0107d46:	c0 
c0107d47:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107d4e:	c0 
c0107d4f:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0107d56:	00 
c0107d57:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107d5e:	e8 9d 86 ff ff       	call   c0100400 <__panic>
    assert(*ptep & PTE_W);
c0107d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107d66:	8b 00                	mov    (%eax),%eax
c0107d68:	83 e0 02             	and    $0x2,%eax
c0107d6b:	85 c0                	test   %eax,%eax
c0107d6d:	75 24                	jne    c0107d93 <check_pgdir+0x363>
c0107d6f:	c7 44 24 0c ba bb 10 	movl   $0xc010bbba,0xc(%esp)
c0107d76:	c0 
c0107d77:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107d7e:	c0 
c0107d7f:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0107d86:	00 
c0107d87:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107d8e:	e8 6d 86 ff ff       	call   c0100400 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0107d93:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107d98:	8b 00                	mov    (%eax),%eax
c0107d9a:	83 e0 04             	and    $0x4,%eax
c0107d9d:	85 c0                	test   %eax,%eax
c0107d9f:	75 24                	jne    c0107dc5 <check_pgdir+0x395>
c0107da1:	c7 44 24 0c c8 bb 10 	movl   $0xc010bbc8,0xc(%esp)
c0107da8:	c0 
c0107da9:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107db0:	c0 
c0107db1:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0107db8:	00 
c0107db9:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107dc0:	e8 3b 86 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p2) == 1);
c0107dc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107dc8:	89 04 24             	mov    %eax,(%esp)
c0107dcb:	e8 e8 ee ff ff       	call   c0106cb8 <page_ref>
c0107dd0:	83 f8 01             	cmp    $0x1,%eax
c0107dd3:	74 24                	je     c0107df9 <check_pgdir+0x3c9>
c0107dd5:	c7 44 24 0c de bb 10 	movl   $0xc010bbde,0xc(%esp)
c0107ddc:	c0 
c0107ddd:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107de4:	c0 
c0107de5:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0107dec:	00 
c0107ded:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107df4:	e8 07 86 ff ff       	call   c0100400 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0107df9:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107dfe:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107e05:	00 
c0107e06:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107e0d:	00 
c0107e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107e11:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e15:	89 04 24             	mov    %eax,(%esp)
c0107e18:	e8 14 fa ff ff       	call   c0107831 <page_insert>
c0107e1d:	85 c0                	test   %eax,%eax
c0107e1f:	74 24                	je     c0107e45 <check_pgdir+0x415>
c0107e21:	c7 44 24 0c f0 bb 10 	movl   $0xc010bbf0,0xc(%esp)
c0107e28:	c0 
c0107e29:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107e30:	c0 
c0107e31:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0107e38:	00 
c0107e39:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107e40:	e8 bb 85 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p1) == 2);
c0107e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e48:	89 04 24             	mov    %eax,(%esp)
c0107e4b:	e8 68 ee ff ff       	call   c0106cb8 <page_ref>
c0107e50:	83 f8 02             	cmp    $0x2,%eax
c0107e53:	74 24                	je     c0107e79 <check_pgdir+0x449>
c0107e55:	c7 44 24 0c 1c bc 10 	movl   $0xc010bc1c,0xc(%esp)
c0107e5c:	c0 
c0107e5d:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107e64:	c0 
c0107e65:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0107e6c:	00 
c0107e6d:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107e74:	e8 87 85 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p2) == 0);
c0107e79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e7c:	89 04 24             	mov    %eax,(%esp)
c0107e7f:	e8 34 ee ff ff       	call   c0106cb8 <page_ref>
c0107e84:	85 c0                	test   %eax,%eax
c0107e86:	74 24                	je     c0107eac <check_pgdir+0x47c>
c0107e88:	c7 44 24 0c 2e bc 10 	movl   $0xc010bc2e,0xc(%esp)
c0107e8f:	c0 
c0107e90:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107e97:	c0 
c0107e98:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0107e9f:	00 
c0107ea0:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107ea7:	e8 54 85 ff ff       	call   c0100400 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107eac:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107eb1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107eb8:	00 
c0107eb9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107ec0:	00 
c0107ec1:	89 04 24             	mov    %eax,(%esp)
c0107ec4:	e8 b8 f6 ff ff       	call   c0107581 <get_pte>
c0107ec9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107ecc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107ed0:	75 24                	jne    c0107ef6 <check_pgdir+0x4c6>
c0107ed2:	c7 44 24 0c 7c bb 10 	movl   $0xc010bb7c,0xc(%esp)
c0107ed9:	c0 
c0107eda:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107ee1:	c0 
c0107ee2:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0107ee9:	00 
c0107eea:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107ef1:	e8 0a 85 ff ff       	call   c0100400 <__panic>
    assert(pte2page(*ptep) == p1);
c0107ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ef9:	8b 00                	mov    (%eax),%eax
c0107efb:	89 04 24             	mov    %eax,(%esp)
c0107efe:	e8 5f ed ff ff       	call   c0106c62 <pte2page>
c0107f03:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107f06:	74 24                	je     c0107f2c <check_pgdir+0x4fc>
c0107f08:	c7 44 24 0c f1 ba 10 	movl   $0xc010baf1,0xc(%esp)
c0107f0f:	c0 
c0107f10:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107f17:	c0 
c0107f18:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0107f1f:	00 
c0107f20:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107f27:	e8 d4 84 ff ff       	call   c0100400 <__panic>
    assert((*ptep & PTE_U) == 0);
c0107f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f2f:	8b 00                	mov    (%eax),%eax
c0107f31:	83 e0 04             	and    $0x4,%eax
c0107f34:	85 c0                	test   %eax,%eax
c0107f36:	74 24                	je     c0107f5c <check_pgdir+0x52c>
c0107f38:	c7 44 24 0c 40 bc 10 	movl   $0xc010bc40,0xc(%esp)
c0107f3f:	c0 
c0107f40:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107f47:	c0 
c0107f48:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0107f4f:	00 
c0107f50:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107f57:	e8 a4 84 ff ff       	call   c0100400 <__panic>

    page_remove(boot_pgdir, 0x0);
c0107f5c:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107f61:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107f68:	00 
c0107f69:	89 04 24             	mov    %eax,(%esp)
c0107f6c:	e8 7b f8 ff ff       	call   c01077ec <page_remove>
    assert(page_ref(p1) == 1);
c0107f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f74:	89 04 24             	mov    %eax,(%esp)
c0107f77:	e8 3c ed ff ff       	call   c0106cb8 <page_ref>
c0107f7c:	83 f8 01             	cmp    $0x1,%eax
c0107f7f:	74 24                	je     c0107fa5 <check_pgdir+0x575>
c0107f81:	c7 44 24 0c 07 bb 10 	movl   $0xc010bb07,0xc(%esp)
c0107f88:	c0 
c0107f89:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107f90:	c0 
c0107f91:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0107f98:	00 
c0107f99:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107fa0:	e8 5b 84 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p2) == 0);
c0107fa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107fa8:	89 04 24             	mov    %eax,(%esp)
c0107fab:	e8 08 ed ff ff       	call   c0106cb8 <page_ref>
c0107fb0:	85 c0                	test   %eax,%eax
c0107fb2:	74 24                	je     c0107fd8 <check_pgdir+0x5a8>
c0107fb4:	c7 44 24 0c 2e bc 10 	movl   $0xc010bc2e,0xc(%esp)
c0107fbb:	c0 
c0107fbc:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0107fc3:	c0 
c0107fc4:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0107fcb:	00 
c0107fcc:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0107fd3:	e8 28 84 ff ff       	call   c0100400 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0107fd8:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107fdd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107fe4:	00 
c0107fe5:	89 04 24             	mov    %eax,(%esp)
c0107fe8:	e8 ff f7 ff ff       	call   c01077ec <page_remove>
    assert(page_ref(p1) == 0);
c0107fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ff0:	89 04 24             	mov    %eax,(%esp)
c0107ff3:	e8 c0 ec ff ff       	call   c0106cb8 <page_ref>
c0107ff8:	85 c0                	test   %eax,%eax
c0107ffa:	74 24                	je     c0108020 <check_pgdir+0x5f0>
c0107ffc:	c7 44 24 0c 55 bc 10 	movl   $0xc010bc55,0xc(%esp)
c0108003:	c0 
c0108004:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c010800b:	c0 
c010800c:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0108013:	00 
c0108014:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c010801b:	e8 e0 83 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p2) == 0);
c0108020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108023:	89 04 24             	mov    %eax,(%esp)
c0108026:	e8 8d ec ff ff       	call   c0106cb8 <page_ref>
c010802b:	85 c0                	test   %eax,%eax
c010802d:	74 24                	je     c0108053 <check_pgdir+0x623>
c010802f:	c7 44 24 0c 2e bc 10 	movl   $0xc010bc2e,0xc(%esp)
c0108036:	c0 
c0108037:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c010803e:	c0 
c010803f:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0108046:	00 
c0108047:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c010804e:	e8 ad 83 ff ff       	call   c0100400 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0108053:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0108058:	8b 00                	mov    (%eax),%eax
c010805a:	89 04 24             	mov    %eax,(%esp)
c010805d:	e8 3e ec ff ff       	call   c0106ca0 <pde2page>
c0108062:	89 04 24             	mov    %eax,(%esp)
c0108065:	e8 4e ec ff ff       	call   c0106cb8 <page_ref>
c010806a:	83 f8 01             	cmp    $0x1,%eax
c010806d:	74 24                	je     c0108093 <check_pgdir+0x663>
c010806f:	c7 44 24 0c 68 bc 10 	movl   $0xc010bc68,0xc(%esp)
c0108076:	c0 
c0108077:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c010807e:	c0 
c010807f:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0108086:	00 
c0108087:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c010808e:	e8 6d 83 ff ff       	call   c0100400 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0108093:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0108098:	8b 00                	mov    (%eax),%eax
c010809a:	89 04 24             	mov    %eax,(%esp)
c010809d:	e8 fe eb ff ff       	call   c0106ca0 <pde2page>
c01080a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01080a9:	00 
c01080aa:	89 04 24             	mov    %eax,(%esp)
c01080ad:	e8 68 ee ff ff       	call   c0106f1a <free_pages>
    boot_pgdir[0] = 0;
c01080b2:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c01080b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01080bd:	c7 04 24 8f bc 10 c0 	movl   $0xc010bc8f,(%esp)
c01080c4:	e8 e0 81 ff ff       	call   c01002a9 <cprintf>
}
c01080c9:	90                   	nop
c01080ca:	c9                   	leave  
c01080cb:	c3                   	ret    

c01080cc <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01080cc:	55                   	push   %ebp
c01080cd:	89 e5                	mov    %esp,%ebp
c01080cf:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01080d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01080d9:	e9 ca 00 00 00       	jmp    c01081a8 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01080de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01080e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080e7:	c1 e8 0c             	shr    $0xc,%eax
c01080ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01080ed:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c01080f2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01080f5:	72 23                	jb     c010811a <check_boot_pgdir+0x4e>
c01080f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01080fe:	c7 44 24 08 b0 b8 10 	movl   $0xc010b8b0,0x8(%esp)
c0108105:	c0 
c0108106:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c010810d:	00 
c010810e:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0108115:	e8 e6 82 ff ff       	call   c0100400 <__panic>
c010811a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010811d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0108122:	89 c2                	mov    %eax,%edx
c0108124:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0108129:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0108130:	00 
c0108131:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108135:	89 04 24             	mov    %eax,(%esp)
c0108138:	e8 44 f4 ff ff       	call   c0107581 <get_pte>
c010813d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108140:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108144:	75 24                	jne    c010816a <check_boot_pgdir+0x9e>
c0108146:	c7 44 24 0c ac bc 10 	movl   $0xc010bcac,0xc(%esp)
c010814d:	c0 
c010814e:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0108155:	c0 
c0108156:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c010815d:	00 
c010815e:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0108165:	e8 96 82 ff ff       	call   c0100400 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010816a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010816d:	8b 00                	mov    (%eax),%eax
c010816f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108174:	89 c2                	mov    %eax,%edx
c0108176:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108179:	39 c2                	cmp    %eax,%edx
c010817b:	74 24                	je     c01081a1 <check_boot_pgdir+0xd5>
c010817d:	c7 44 24 0c e9 bc 10 	movl   $0xc010bce9,0xc(%esp)
c0108184:	c0 
c0108185:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c010818c:	c0 
c010818d:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0108194:	00 
c0108195:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c010819c:	e8 5f 82 ff ff       	call   c0100400 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01081a1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01081a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01081ab:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c01081b0:	39 c2                	cmp    %eax,%edx
c01081b2:	0f 82 26 ff ff ff    	jb     c01080de <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01081b8:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c01081bd:	05 ac 0f 00 00       	add    $0xfac,%eax
c01081c2:	8b 00                	mov    (%eax),%eax
c01081c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01081c9:	89 c2                	mov    %eax,%edx
c01081cb:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c01081d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01081d3:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01081da:	77 23                	ja     c01081ff <check_boot_pgdir+0x133>
c01081dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081df:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01081e3:	c7 44 24 08 54 b9 10 	movl   $0xc010b954,0x8(%esp)
c01081ea:	c0 
c01081eb:	c7 44 24 04 4e 02 00 	movl   $0x24e,0x4(%esp)
c01081f2:	00 
c01081f3:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c01081fa:	e8 01 82 ff ff       	call   c0100400 <__panic>
c01081ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108202:	05 00 00 00 40       	add    $0x40000000,%eax
c0108207:	39 c2                	cmp    %eax,%edx
c0108209:	74 24                	je     c010822f <check_boot_pgdir+0x163>
c010820b:	c7 44 24 0c 00 bd 10 	movl   $0xc010bd00,0xc(%esp)
c0108212:	c0 
c0108213:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c010821a:	c0 
c010821b:	c7 44 24 04 4e 02 00 	movl   $0x24e,0x4(%esp)
c0108222:	00 
c0108223:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c010822a:	e8 d1 81 ff ff       	call   c0100400 <__panic>

    assert(boot_pgdir[0] == 0);
c010822f:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0108234:	8b 00                	mov    (%eax),%eax
c0108236:	85 c0                	test   %eax,%eax
c0108238:	74 24                	je     c010825e <check_boot_pgdir+0x192>
c010823a:	c7 44 24 0c 34 bd 10 	movl   $0xc010bd34,0xc(%esp)
c0108241:	c0 
c0108242:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0108249:	c0 
c010824a:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
c0108251:	00 
c0108252:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0108259:	e8 a2 81 ff ff       	call   c0100400 <__panic>

    struct Page *p;
    p = alloc_page();
c010825e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108265:	e8 45 ec ff ff       	call   c0106eaf <alloc_pages>
c010826a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010826d:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0108272:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0108279:	00 
c010827a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0108281:	00 
c0108282:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108285:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108289:	89 04 24             	mov    %eax,(%esp)
c010828c:	e8 a0 f5 ff ff       	call   c0107831 <page_insert>
c0108291:	85 c0                	test   %eax,%eax
c0108293:	74 24                	je     c01082b9 <check_boot_pgdir+0x1ed>
c0108295:	c7 44 24 0c 48 bd 10 	movl   $0xc010bd48,0xc(%esp)
c010829c:	c0 
c010829d:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c01082a4:	c0 
c01082a5:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c01082ac:	00 
c01082ad:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c01082b4:	e8 47 81 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p) == 1);
c01082b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082bc:	89 04 24             	mov    %eax,(%esp)
c01082bf:	e8 f4 e9 ff ff       	call   c0106cb8 <page_ref>
c01082c4:	83 f8 01             	cmp    $0x1,%eax
c01082c7:	74 24                	je     c01082ed <check_boot_pgdir+0x221>
c01082c9:	c7 44 24 0c 76 bd 10 	movl   $0xc010bd76,0xc(%esp)
c01082d0:	c0 
c01082d1:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c01082d8:	c0 
c01082d9:	c7 44 24 04 55 02 00 	movl   $0x255,0x4(%esp)
c01082e0:	00 
c01082e1:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c01082e8:	e8 13 81 ff ff       	call   c0100400 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01082ed:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c01082f2:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01082f9:	00 
c01082fa:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0108301:	00 
c0108302:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108305:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108309:	89 04 24             	mov    %eax,(%esp)
c010830c:	e8 20 f5 ff ff       	call   c0107831 <page_insert>
c0108311:	85 c0                	test   %eax,%eax
c0108313:	74 24                	je     c0108339 <check_boot_pgdir+0x26d>
c0108315:	c7 44 24 0c 88 bd 10 	movl   $0xc010bd88,0xc(%esp)
c010831c:	c0 
c010831d:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0108324:	c0 
c0108325:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c010832c:	00 
c010832d:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0108334:	e8 c7 80 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p) == 2);
c0108339:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010833c:	89 04 24             	mov    %eax,(%esp)
c010833f:	e8 74 e9 ff ff       	call   c0106cb8 <page_ref>
c0108344:	83 f8 02             	cmp    $0x2,%eax
c0108347:	74 24                	je     c010836d <check_boot_pgdir+0x2a1>
c0108349:	c7 44 24 0c bf bd 10 	movl   $0xc010bdbf,0xc(%esp)
c0108350:	c0 
c0108351:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c0108358:	c0 
c0108359:	c7 44 24 04 57 02 00 	movl   $0x257,0x4(%esp)
c0108360:	00 
c0108361:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0108368:	e8 93 80 ff ff       	call   c0100400 <__panic>

    const char *str = "ucore: Hello world!!";
c010836d:	c7 45 dc d0 bd 10 c0 	movl   $0xc010bdd0,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0108374:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108377:	89 44 24 04          	mov    %eax,0x4(%esp)
c010837b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0108382:	e8 48 11 00 00       	call   c01094cf <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0108387:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010838e:	00 
c010838f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0108396:	e8 ab 11 00 00       	call   c0109546 <strcmp>
c010839b:	85 c0                	test   %eax,%eax
c010839d:	74 24                	je     c01083c3 <check_boot_pgdir+0x2f7>
c010839f:	c7 44 24 0c e8 bd 10 	movl   $0xc010bde8,0xc(%esp)
c01083a6:	c0 
c01083a7:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c01083ae:	c0 
c01083af:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c01083b6:	00 
c01083b7:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c01083be:	e8 3d 80 ff ff       	call   c0100400 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01083c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01083c6:	89 04 24             	mov    %eax,(%esp)
c01083c9:	e8 40 e8 ff ff       	call   c0106c0e <page2kva>
c01083ce:	05 00 01 00 00       	add    $0x100,%eax
c01083d3:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01083d6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01083dd:	e8 97 10 00 00       	call   c0109479 <strlen>
c01083e2:	85 c0                	test   %eax,%eax
c01083e4:	74 24                	je     c010840a <check_boot_pgdir+0x33e>
c01083e6:	c7 44 24 0c 20 be 10 	movl   $0xc010be20,0xc(%esp)
c01083ed:	c0 
c01083ee:	c7 44 24 08 9d b9 10 	movl   $0xc010b99d,0x8(%esp)
c01083f5:	c0 
c01083f6:	c7 44 24 04 5e 02 00 	movl   $0x25e,0x4(%esp)
c01083fd:	00 
c01083fe:	c7 04 24 78 b9 10 c0 	movl   $0xc010b978,(%esp)
c0108405:	e8 f6 7f ff ff       	call   c0100400 <__panic>

    free_page(p);
c010840a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108411:	00 
c0108412:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108415:	89 04 24             	mov    %eax,(%esp)
c0108418:	e8 fd ea ff ff       	call   c0106f1a <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c010841d:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0108422:	8b 00                	mov    (%eax),%eax
c0108424:	89 04 24             	mov    %eax,(%esp)
c0108427:	e8 74 e8 ff ff       	call   c0106ca0 <pde2page>
c010842c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108433:	00 
c0108434:	89 04 24             	mov    %eax,(%esp)
c0108437:	e8 de ea ff ff       	call   c0106f1a <free_pages>
    boot_pgdir[0] = 0;
c010843c:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0108441:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0108447:	c7 04 24 44 be 10 c0 	movl   $0xc010be44,(%esp)
c010844e:	e8 56 7e ff ff       	call   c01002a9 <cprintf>
}
c0108453:	90                   	nop
c0108454:	c9                   	leave  
c0108455:	c3                   	ret    

c0108456 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0108456:	55                   	push   %ebp
c0108457:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0108459:	8b 45 08             	mov    0x8(%ebp),%eax
c010845c:	83 e0 04             	and    $0x4,%eax
c010845f:	85 c0                	test   %eax,%eax
c0108461:	74 04                	je     c0108467 <perm2str+0x11>
c0108463:	b0 75                	mov    $0x75,%al
c0108465:	eb 02                	jmp    c0108469 <perm2str+0x13>
c0108467:	b0 2d                	mov    $0x2d,%al
c0108469:	a2 08 90 12 c0       	mov    %al,0xc0129008
    str[1] = 'r';
c010846e:	c6 05 09 90 12 c0 72 	movb   $0x72,0xc0129009
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0108475:	8b 45 08             	mov    0x8(%ebp),%eax
c0108478:	83 e0 02             	and    $0x2,%eax
c010847b:	85 c0                	test   %eax,%eax
c010847d:	74 04                	je     c0108483 <perm2str+0x2d>
c010847f:	b0 77                	mov    $0x77,%al
c0108481:	eb 02                	jmp    c0108485 <perm2str+0x2f>
c0108483:	b0 2d                	mov    $0x2d,%al
c0108485:	a2 0a 90 12 c0       	mov    %al,0xc012900a
    str[3] = '\0';
c010848a:	c6 05 0b 90 12 c0 00 	movb   $0x0,0xc012900b
    return str;
c0108491:	b8 08 90 12 c0       	mov    $0xc0129008,%eax
}
c0108496:	5d                   	pop    %ebp
c0108497:	c3                   	ret    

c0108498 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0108498:	55                   	push   %ebp
c0108499:	89 e5                	mov    %esp,%ebp
c010849b:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010849e:	8b 45 10             	mov    0x10(%ebp),%eax
c01084a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01084a4:	72 0d                	jb     c01084b3 <get_pgtable_items+0x1b>
        return 0;
c01084a6:	b8 00 00 00 00       	mov    $0x0,%eax
c01084ab:	e9 98 00 00 00       	jmp    c0108548 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01084b0:	ff 45 10             	incl   0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01084b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01084b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01084b9:	73 18                	jae    c01084d3 <get_pgtable_items+0x3b>
c01084bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01084be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01084c5:	8b 45 14             	mov    0x14(%ebp),%eax
c01084c8:	01 d0                	add    %edx,%eax
c01084ca:	8b 00                	mov    (%eax),%eax
c01084cc:	83 e0 01             	and    $0x1,%eax
c01084cf:	85 c0                	test   %eax,%eax
c01084d1:	74 dd                	je     c01084b0 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c01084d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01084d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01084d9:	73 68                	jae    c0108543 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c01084db:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01084df:	74 08                	je     c01084e9 <get_pgtable_items+0x51>
            *left_store = start;
c01084e1:	8b 45 18             	mov    0x18(%ebp),%eax
c01084e4:	8b 55 10             	mov    0x10(%ebp),%edx
c01084e7:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01084e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01084ec:	8d 50 01             	lea    0x1(%eax),%edx
c01084ef:	89 55 10             	mov    %edx,0x10(%ebp)
c01084f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01084f9:	8b 45 14             	mov    0x14(%ebp),%eax
c01084fc:	01 d0                	add    %edx,%eax
c01084fe:	8b 00                	mov    (%eax),%eax
c0108500:	83 e0 07             	and    $0x7,%eax
c0108503:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0108506:	eb 03                	jmp    c010850b <get_pgtable_items+0x73>
            start ++;
c0108508:	ff 45 10             	incl   0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010850b:	8b 45 10             	mov    0x10(%ebp),%eax
c010850e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108511:	73 1d                	jae    c0108530 <get_pgtable_items+0x98>
c0108513:	8b 45 10             	mov    0x10(%ebp),%eax
c0108516:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010851d:	8b 45 14             	mov    0x14(%ebp),%eax
c0108520:	01 d0                	add    %edx,%eax
c0108522:	8b 00                	mov    (%eax),%eax
c0108524:	83 e0 07             	and    $0x7,%eax
c0108527:	89 c2                	mov    %eax,%edx
c0108529:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010852c:	39 c2                	cmp    %eax,%edx
c010852e:	74 d8                	je     c0108508 <get_pgtable_items+0x70>
            start ++;
        }
        if (right_store != NULL) {
c0108530:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0108534:	74 08                	je     c010853e <get_pgtable_items+0xa6>
            *right_store = start;
c0108536:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108539:	8b 55 10             	mov    0x10(%ebp),%edx
c010853c:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010853e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108541:	eb 05                	jmp    c0108548 <get_pgtable_items+0xb0>
    }
    return 0;
c0108543:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108548:	c9                   	leave  
c0108549:	c3                   	ret    

c010854a <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010854a:	55                   	push   %ebp
c010854b:	89 e5                	mov    %esp,%ebp
c010854d:	57                   	push   %edi
c010854e:	56                   	push   %esi
c010854f:	53                   	push   %ebx
c0108550:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0108553:	c7 04 24 64 be 10 c0 	movl   $0xc010be64,(%esp)
c010855a:	e8 4a 7d ff ff       	call   c01002a9 <cprintf>
    size_t left, right = 0, perm;
c010855f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0108566:	e9 fa 00 00 00       	jmp    c0108665 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010856b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010856e:	89 04 24             	mov    %eax,(%esp)
c0108571:	e8 e0 fe ff ff       	call   c0108456 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0108576:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108579:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010857c:	29 d1                	sub    %edx,%ecx
c010857e:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0108580:	89 d6                	mov    %edx,%esi
c0108582:	c1 e6 16             	shl    $0x16,%esi
c0108585:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108588:	89 d3                	mov    %edx,%ebx
c010858a:	c1 e3 16             	shl    $0x16,%ebx
c010858d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108590:	89 d1                	mov    %edx,%ecx
c0108592:	c1 e1 16             	shl    $0x16,%ecx
c0108595:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0108598:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010859b:	29 d7                	sub    %edx,%edi
c010859d:	89 fa                	mov    %edi,%edx
c010859f:	89 44 24 14          	mov    %eax,0x14(%esp)
c01085a3:	89 74 24 10          	mov    %esi,0x10(%esp)
c01085a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01085ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01085af:	89 54 24 04          	mov    %edx,0x4(%esp)
c01085b3:	c7 04 24 95 be 10 c0 	movl   $0xc010be95,(%esp)
c01085ba:	e8 ea 7c ff ff       	call   c01002a9 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01085bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01085c2:	c1 e0 0a             	shl    $0xa,%eax
c01085c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01085c8:	eb 54                	jmp    c010861e <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01085ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01085cd:	89 04 24             	mov    %eax,(%esp)
c01085d0:	e8 81 fe ff ff       	call   c0108456 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01085d5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01085d8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01085db:	29 d1                	sub    %edx,%ecx
c01085dd:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01085df:	89 d6                	mov    %edx,%esi
c01085e1:	c1 e6 0c             	shl    $0xc,%esi
c01085e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01085e7:	89 d3                	mov    %edx,%ebx
c01085e9:	c1 e3 0c             	shl    $0xc,%ebx
c01085ec:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01085ef:	89 d1                	mov    %edx,%ecx
c01085f1:	c1 e1 0c             	shl    $0xc,%ecx
c01085f4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01085f7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01085fa:	29 d7                	sub    %edx,%edi
c01085fc:	89 fa                	mov    %edi,%edx
c01085fe:	89 44 24 14          	mov    %eax,0x14(%esp)
c0108602:	89 74 24 10          	mov    %esi,0x10(%esp)
c0108606:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010860a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010860e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108612:	c7 04 24 b4 be 10 c0 	movl   $0xc010beb4,(%esp)
c0108619:	e8 8b 7c ff ff       	call   c01002a9 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010861e:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0108623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108626:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108629:	89 d3                	mov    %edx,%ebx
c010862b:	c1 e3 0a             	shl    $0xa,%ebx
c010862e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108631:	89 d1                	mov    %edx,%ecx
c0108633:	c1 e1 0a             	shl    $0xa,%ecx
c0108636:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0108639:	89 54 24 14          	mov    %edx,0x14(%esp)
c010863d:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0108640:	89 54 24 10          	mov    %edx,0x10(%esp)
c0108644:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0108648:	89 44 24 08          	mov    %eax,0x8(%esp)
c010864c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0108650:	89 0c 24             	mov    %ecx,(%esp)
c0108653:	e8 40 fe ff ff       	call   c0108498 <get_pgtable_items>
c0108658:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010865b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010865f:	0f 85 65 ff ff ff    	jne    c01085ca <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0108665:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010866a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010866d:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0108670:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108674:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0108677:	89 54 24 10          	mov    %edx,0x10(%esp)
c010867b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010867f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108683:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010868a:	00 
c010868b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0108692:	e8 01 fe ff ff       	call   c0108498 <get_pgtable_items>
c0108697:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010869a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010869e:	0f 85 c7 fe ff ff    	jne    c010856b <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01086a4:	c7 04 24 d8 be 10 c0 	movl   $0xc010bed8,(%esp)
c01086ab:	e8 f9 7b ff ff       	call   c01002a9 <cprintf>
}
c01086b0:	90                   	nop
c01086b1:	83 c4 4c             	add    $0x4c,%esp
c01086b4:	5b                   	pop    %ebx
c01086b5:	5e                   	pop    %esi
c01086b6:	5f                   	pop    %edi
c01086b7:	5d                   	pop    %ebp
c01086b8:	c3                   	ret    

c01086b9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01086b9:	55                   	push   %ebp
c01086ba:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01086bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01086bf:	8b 15 40 b1 12 c0    	mov    0xc012b140,%edx
c01086c5:	29 d0                	sub    %edx,%eax
c01086c7:	c1 f8 05             	sar    $0x5,%eax
}
c01086ca:	5d                   	pop    %ebp
c01086cb:	c3                   	ret    

c01086cc <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01086cc:	55                   	push   %ebp
c01086cd:	89 e5                	mov    %esp,%ebp
c01086cf:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01086d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01086d5:	89 04 24             	mov    %eax,(%esp)
c01086d8:	e8 dc ff ff ff       	call   c01086b9 <page2ppn>
c01086dd:	c1 e0 0c             	shl    $0xc,%eax
}
c01086e0:	c9                   	leave  
c01086e1:	c3                   	ret    

c01086e2 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c01086e2:	55                   	push   %ebp
c01086e3:	89 e5                	mov    %esp,%ebp
c01086e5:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01086e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01086eb:	89 04 24             	mov    %eax,(%esp)
c01086ee:	e8 d9 ff ff ff       	call   c01086cc <page2pa>
c01086f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01086f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086f9:	c1 e8 0c             	shr    $0xc,%eax
c01086fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01086ff:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0108704:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108707:	72 23                	jb     c010872c <page2kva+0x4a>
c0108709:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010870c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108710:	c7 44 24 08 0c bf 10 	movl   $0xc010bf0c,0x8(%esp)
c0108717:	c0 
c0108718:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c010871f:	00 
c0108720:	c7 04 24 2f bf 10 c0 	movl   $0xc010bf2f,(%esp)
c0108727:	e8 d4 7c ff ff       	call   c0100400 <__panic>
c010872c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010872f:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108734:	c9                   	leave  
c0108735:	c3                   	ret    

c0108736 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108736:	55                   	push   %ebp
c0108737:	89 e5                	mov    %esp,%ebp
c0108739:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c010873c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108743:	e8 fb 89 ff ff       	call   c0101143 <ide_device_valid>
c0108748:	85 c0                	test   %eax,%eax
c010874a:	75 1c                	jne    c0108768 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c010874c:	c7 44 24 08 3d bf 10 	movl   $0xc010bf3d,0x8(%esp)
c0108753:	c0 
c0108754:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c010875b:	00 
c010875c:	c7 04 24 57 bf 10 c0 	movl   $0xc010bf57,(%esp)
c0108763:	e8 98 7c ff ff       	call   c0100400 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0108768:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010876f:	e8 11 8a ff ff       	call   c0101185 <ide_device_size>
c0108774:	c1 e8 03             	shr    $0x3,%eax
c0108777:	a3 fc b0 12 c0       	mov    %eax,0xc012b0fc
}
c010877c:	90                   	nop
c010877d:	c9                   	leave  
c010877e:	c3                   	ret    

c010877f <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c010877f:	55                   	push   %ebp
c0108780:	89 e5                	mov    %esp,%ebp
c0108782:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108785:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108788:	89 04 24             	mov    %eax,(%esp)
c010878b:	e8 52 ff ff ff       	call   c01086e2 <page2kva>
c0108790:	8b 55 08             	mov    0x8(%ebp),%edx
c0108793:	c1 ea 08             	shr    $0x8,%edx
c0108796:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108799:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010879d:	74 0b                	je     c01087aa <swapfs_read+0x2b>
c010879f:	8b 15 fc b0 12 c0    	mov    0xc012b0fc,%edx
c01087a5:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01087a8:	72 23                	jb     c01087cd <swapfs_read+0x4e>
c01087aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01087ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01087b1:	c7 44 24 08 68 bf 10 	movl   $0xc010bf68,0x8(%esp)
c01087b8:	c0 
c01087b9:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01087c0:	00 
c01087c1:	c7 04 24 57 bf 10 c0 	movl   $0xc010bf57,(%esp)
c01087c8:	e8 33 7c ff ff       	call   c0100400 <__panic>
c01087cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01087d0:	c1 e2 03             	shl    $0x3,%edx
c01087d3:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01087da:	00 
c01087db:	89 44 24 08          	mov    %eax,0x8(%esp)
c01087df:	89 54 24 04          	mov    %edx,0x4(%esp)
c01087e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01087ea:	e8 d5 89 ff ff       	call   c01011c4 <ide_read_secs>
}
c01087ef:	c9                   	leave  
c01087f0:	c3                   	ret    

c01087f1 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c01087f1:	55                   	push   %ebp
c01087f2:	89 e5                	mov    %esp,%ebp
c01087f4:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01087f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087fa:	89 04 24             	mov    %eax,(%esp)
c01087fd:	e8 e0 fe ff ff       	call   c01086e2 <page2kva>
c0108802:	8b 55 08             	mov    0x8(%ebp),%edx
c0108805:	c1 ea 08             	shr    $0x8,%edx
c0108808:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010880b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010880f:	74 0b                	je     c010881c <swapfs_write+0x2b>
c0108811:	8b 15 fc b0 12 c0    	mov    0xc012b0fc,%edx
c0108817:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010881a:	72 23                	jb     c010883f <swapfs_write+0x4e>
c010881c:	8b 45 08             	mov    0x8(%ebp),%eax
c010881f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108823:	c7 44 24 08 68 bf 10 	movl   $0xc010bf68,0x8(%esp)
c010882a:	c0 
c010882b:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0108832:	00 
c0108833:	c7 04 24 57 bf 10 c0 	movl   $0xc010bf57,(%esp)
c010883a:	e8 c1 7b ff ff       	call   c0100400 <__panic>
c010883f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108842:	c1 e2 03             	shl    $0x3,%edx
c0108845:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010884c:	00 
c010884d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108851:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108855:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010885c:	e8 9d 8b ff ff       	call   c01013fe <ide_write_secs>
}
c0108861:	c9                   	leave  
c0108862:	c3                   	ret    

c0108863 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c0108863:	52                   	push   %edx
    call *%ebx              # call fn
c0108864:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c0108866:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c0108867:	e8 6e 08 00 00       	call   c01090da <do_exit>

c010886c <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c010886c:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c0108870:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)          # save esp::context of from
c0108872:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)          # save ebx::context of from
c0108875:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)         # save ecx::context of from
c0108878:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)         # save edx::context of from
c010887b:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)         # save esi::context of from
c010887e:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)         # save edi::context of from
c0108881:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)         # save ebp::context of from
c0108884:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c0108887:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp         # restore ebp::context of to
c010888b:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi         # restore edi::context of to
c010888e:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi         # restore esi::context of to
c0108891:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx         # restore edx::context of to
c0108894:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx         # restore ecx::context of to
c0108897:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx          # restore ebx::context of to
c010889a:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp          # restore esp::context of to
c010889d:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c01088a0:	ff 30                	pushl  (%eax)

    ret
c01088a2:	c3                   	ret    

c01088a3 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01088a3:	55                   	push   %ebp
c01088a4:	89 e5                	mov    %esp,%ebp
c01088a6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01088a9:	9c                   	pushf  
c01088aa:	58                   	pop    %eax
c01088ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01088ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01088b1:	25 00 02 00 00       	and    $0x200,%eax
c01088b6:	85 c0                	test   %eax,%eax
c01088b8:	74 0c                	je     c01088c6 <__intr_save+0x23>
        intr_disable();
c01088ba:	e8 64 98 ff ff       	call   c0102123 <intr_disable>
        return 1;
c01088bf:	b8 01 00 00 00       	mov    $0x1,%eax
c01088c4:	eb 05                	jmp    c01088cb <__intr_save+0x28>
    }
    return 0;
c01088c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01088cb:	c9                   	leave  
c01088cc:	c3                   	ret    

c01088cd <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01088cd:	55                   	push   %ebp
c01088ce:	89 e5                	mov    %esp,%ebp
c01088d0:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01088d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01088d7:	74 05                	je     c01088de <__intr_restore+0x11>
        intr_enable();
c01088d9:	e8 3e 98 ff ff       	call   c010211c <intr_enable>
    }
}
c01088de:	90                   	nop
c01088df:	c9                   	leave  
c01088e0:	c3                   	ret    

c01088e1 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01088e1:	55                   	push   %ebp
c01088e2:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01088e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01088e7:	8b 15 40 b1 12 c0    	mov    0xc012b140,%edx
c01088ed:	29 d0                	sub    %edx,%eax
c01088ef:	c1 f8 05             	sar    $0x5,%eax
}
c01088f2:	5d                   	pop    %ebp
c01088f3:	c3                   	ret    

c01088f4 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01088f4:	55                   	push   %ebp
c01088f5:	89 e5                	mov    %esp,%ebp
c01088f7:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01088fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01088fd:	89 04 24             	mov    %eax,(%esp)
c0108900:	e8 dc ff ff ff       	call   c01088e1 <page2ppn>
c0108905:	c1 e0 0c             	shl    $0xc,%eax
}
c0108908:	c9                   	leave  
c0108909:	c3                   	ret    

c010890a <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010890a:	55                   	push   %ebp
c010890b:	89 e5                	mov    %esp,%ebp
c010890d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0108910:	8b 45 08             	mov    0x8(%ebp),%eax
c0108913:	c1 e8 0c             	shr    $0xc,%eax
c0108916:	89 c2                	mov    %eax,%edx
c0108918:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c010891d:	39 c2                	cmp    %eax,%edx
c010891f:	72 1c                	jb     c010893d <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0108921:	c7 44 24 08 88 bf 10 	movl   $0xc010bf88,0x8(%esp)
c0108928:	c0 
c0108929:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0108930:	00 
c0108931:	c7 04 24 a7 bf 10 c0 	movl   $0xc010bfa7,(%esp)
c0108938:	e8 c3 7a ff ff       	call   c0100400 <__panic>
    }
    return &pages[PPN(pa)];
c010893d:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c0108942:	8b 55 08             	mov    0x8(%ebp),%edx
c0108945:	c1 ea 0c             	shr    $0xc,%edx
c0108948:	c1 e2 05             	shl    $0x5,%edx
c010894b:	01 d0                	add    %edx,%eax
}
c010894d:	c9                   	leave  
c010894e:	c3                   	ret    

c010894f <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010894f:	55                   	push   %ebp
c0108950:	89 e5                	mov    %esp,%ebp
c0108952:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108955:	8b 45 08             	mov    0x8(%ebp),%eax
c0108958:	89 04 24             	mov    %eax,(%esp)
c010895b:	e8 94 ff ff ff       	call   c01088f4 <page2pa>
c0108960:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108963:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108966:	c1 e8 0c             	shr    $0xc,%eax
c0108969:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010896c:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0108971:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108974:	72 23                	jb     c0108999 <page2kva+0x4a>
c0108976:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108979:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010897d:	c7 44 24 08 b8 bf 10 	movl   $0xc010bfb8,0x8(%esp)
c0108984:	c0 
c0108985:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c010898c:	00 
c010898d:	c7 04 24 a7 bf 10 c0 	movl   $0xc010bfa7,(%esp)
c0108994:	e8 67 7a ff ff       	call   c0100400 <__panic>
c0108999:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010899c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01089a1:	c9                   	leave  
c01089a2:	c3                   	ret    

c01089a3 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01089a3:	55                   	push   %ebp
c01089a4:	89 e5                	mov    %esp,%ebp
c01089a6:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01089a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01089ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01089af:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01089b6:	77 23                	ja     c01089db <kva2page+0x38>
c01089b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01089bf:	c7 44 24 08 dc bf 10 	movl   $0xc010bfdc,0x8(%esp)
c01089c6:	c0 
c01089c7:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c01089ce:	00 
c01089cf:	c7 04 24 a7 bf 10 c0 	movl   $0xc010bfa7,(%esp)
c01089d6:	e8 25 7a ff ff       	call   c0100400 <__panic>
c01089db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089de:	05 00 00 00 40       	add    $0x40000000,%eax
c01089e3:	89 04 24             	mov    %eax,(%esp)
c01089e6:	e8 1f ff ff ff       	call   c010890a <pa2page>
}
c01089eb:	c9                   	leave  
c01089ec:	c3                   	ret    

c01089ed <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c01089ed:	55                   	push   %ebp
c01089ee:	89 e5                	mov    %esp,%ebp
c01089f0:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c01089f3:	c7 04 24 68 00 00 00 	movl   $0x68,(%esp)
c01089fa:	e8 98 c7 ff ff       	call   c0105197 <kmalloc>
c01089ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c0108a02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108a06:	0f 84 a1 00 00 00    	je     c0108aad <alloc_proc+0xc0>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
        proc->state = PROC_UNINIT;
c0108a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        proc->pid = 0;
c0108a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        proc->runs = 0;
c0108a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        proc->kstack = 0;
c0108a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a2c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        proc->need_resched = 0;
c0108a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a36:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        proc->parent = current;
c0108a3d:	8b 15 28 90 12 c0    	mov    0xc0129028,%edx
c0108a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a46:	89 50 14             	mov    %edx,0x14(%eax)
        proc->mm = NULL;
c0108a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a4c:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        memset(&(proc->context), 0, sizeof(struct context));
c0108a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a56:	83 c0 1c             	add    $0x1c,%eax
c0108a59:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c0108a60:	00 
c0108a61:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108a68:	00 
c0108a69:	89 04 24             	mov    %eax,(%esp)
c0108a6c:	e8 28 0d 00 00       	call   c0109799 <memset>
        proc->tf = NULL;
c0108a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a74:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
        proc->cr3 = 0;
c0108a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a7e:	c7 40 40 00 00 00 00 	movl   $0x0,0x40(%eax)
        proc->flags = 0;
c0108a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a88:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
        memset(proc->name, 0, PROC_NAME_LEN + 1);
c0108a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a92:	83 c0 48             	add    $0x48,%eax
c0108a95:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0108a9c:	00 
c0108a9d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108aa4:	00 
c0108aa5:	89 04 24             	mov    %eax,(%esp)
c0108aa8:	e8 ec 0c 00 00       	call   c0109799 <memset>
    }
    return proc;
c0108aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108ab0:	c9                   	leave  
c0108ab1:	c3                   	ret    

c0108ab2 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c0108ab2:	55                   	push   %ebp
c0108ab3:	89 e5                	mov    %esp,%ebp
c0108ab5:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c0108ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108abb:	83 c0 48             	add    $0x48,%eax
c0108abe:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0108ac5:	00 
c0108ac6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108acd:	00 
c0108ace:	89 04 24             	mov    %eax,(%esp)
c0108ad1:	e8 c3 0c 00 00       	call   c0109799 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c0108ad6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ad9:	8d 50 48             	lea    0x48(%eax),%edx
c0108adc:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108ae3:	00 
c0108ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108aeb:	89 14 24             	mov    %edx,(%esp)
c0108aee:	e8 89 0d 00 00       	call   c010987c <memcpy>
}
c0108af3:	c9                   	leave  
c0108af4:	c3                   	ret    

c0108af5 <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c0108af5:	55                   	push   %ebp
c0108af6:	89 e5                	mov    %esp,%ebp
c0108af8:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c0108afb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0108b02:	00 
c0108b03:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108b0a:	00 
c0108b0b:	c7 04 24 44 b0 12 c0 	movl   $0xc012b044,(%esp)
c0108b12:	e8 82 0c 00 00       	call   c0109799 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c0108b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b1a:	83 c0 48             	add    $0x48,%eax
c0108b1d:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108b24:	00 
c0108b25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108b29:	c7 04 24 44 b0 12 c0 	movl   $0xc012b044,(%esp)
c0108b30:	e8 47 0d 00 00       	call   c010987c <memcpy>
}
c0108b35:	c9                   	leave  
c0108b36:	c3                   	ret    

c0108b37 <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c0108b37:	55                   	push   %ebp
c0108b38:	89 e5                	mov    %esp,%ebp
c0108b3a:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c0108b3d:	c7 45 f8 44 b1 12 c0 	movl   $0xc012b144,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c0108b44:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
c0108b49:	40                   	inc    %eax
c0108b4a:	a3 78 5a 12 c0       	mov    %eax,0xc0125a78
c0108b4f:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
c0108b54:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108b59:	7e 0c                	jle    c0108b67 <get_pid+0x30>
        last_pid = 1;
c0108b5b:	c7 05 78 5a 12 c0 01 	movl   $0x1,0xc0125a78
c0108b62:	00 00 00 
        goto inside;
c0108b65:	eb 13                	jmp    c0108b7a <get_pid+0x43>
    }
    if (last_pid >= next_safe) {
c0108b67:	8b 15 78 5a 12 c0    	mov    0xc0125a78,%edx
c0108b6d:	a1 7c 5a 12 c0       	mov    0xc0125a7c,%eax
c0108b72:	39 c2                	cmp    %eax,%edx
c0108b74:	0f 8c aa 00 00 00    	jl     c0108c24 <get_pid+0xed>
    inside:
        next_safe = MAX_PID;
c0108b7a:	c7 05 7c 5a 12 c0 00 	movl   $0x2000,0xc0125a7c
c0108b81:	20 00 00 
    repeat:
        le = list;
c0108b84:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108b87:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c0108b8a:	eb 7d                	jmp    c0108c09 <get_pid+0xd2>
            proc = le2proc(le, list_link);
c0108b8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108b8f:	83 e8 58             	sub    $0x58,%eax
c0108b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c0108b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b98:	8b 50 04             	mov    0x4(%eax),%edx
c0108b9b:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
c0108ba0:	39 c2                	cmp    %eax,%edx
c0108ba2:	75 3c                	jne    c0108be0 <get_pid+0xa9>
                if (++ last_pid >= next_safe) {
c0108ba4:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
c0108ba9:	40                   	inc    %eax
c0108baa:	a3 78 5a 12 c0       	mov    %eax,0xc0125a78
c0108baf:	8b 15 78 5a 12 c0    	mov    0xc0125a78,%edx
c0108bb5:	a1 7c 5a 12 c0       	mov    0xc0125a7c,%eax
c0108bba:	39 c2                	cmp    %eax,%edx
c0108bbc:	7c 4b                	jl     c0108c09 <get_pid+0xd2>
                    if (last_pid >= MAX_PID) {
c0108bbe:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
c0108bc3:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108bc8:	7e 0a                	jle    c0108bd4 <get_pid+0x9d>
                        last_pid = 1;
c0108bca:	c7 05 78 5a 12 c0 01 	movl   $0x1,0xc0125a78
c0108bd1:	00 00 00 
                    }
                    next_safe = MAX_PID;
c0108bd4:	c7 05 7c 5a 12 c0 00 	movl   $0x2000,0xc0125a7c
c0108bdb:	20 00 00 
                    goto repeat;
c0108bde:	eb a4                	jmp    c0108b84 <get_pid+0x4d>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c0108be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108be3:	8b 50 04             	mov    0x4(%eax),%edx
c0108be6:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
c0108beb:	39 c2                	cmp    %eax,%edx
c0108bed:	7e 1a                	jle    c0108c09 <get_pid+0xd2>
c0108bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108bf2:	8b 50 04             	mov    0x4(%eax),%edx
c0108bf5:	a1 7c 5a 12 c0       	mov    0xc0125a7c,%eax
c0108bfa:	39 c2                	cmp    %eax,%edx
c0108bfc:	7d 0b                	jge    c0108c09 <get_pid+0xd2>
                next_safe = proc->pid;
c0108bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c01:	8b 40 04             	mov    0x4(%eax),%eax
c0108c04:	a3 7c 5a 12 c0       	mov    %eax,0xc0125a7c
c0108c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108c0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c12:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c0108c15:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0108c18:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108c1b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108c1e:	0f 85 68 ff ff ff    	jne    c0108b8c <get_pid+0x55>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c0108c24:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
}
c0108c29:	c9                   	leave  
c0108c2a:	c3                   	ret    

c0108c2b <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c0108c2b:	55                   	push   %ebp
c0108c2c:	89 e5                	mov    %esp,%ebp
c0108c2e:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c0108c31:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0108c36:	39 45 08             	cmp    %eax,0x8(%ebp)
c0108c39:	74 63                	je     c0108c9e <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c0108c3b:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0108c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108c43:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c46:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c0108c49:	e8 55 fc ff ff       	call   c01088a3 <__intr_save>
c0108c4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c0108c51:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c54:	a3 28 90 12 c0       	mov    %eax,0xc0129028
            load_esp0(next->kstack + KSTACKSIZE);
c0108c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c5c:	8b 40 0c             	mov    0xc(%eax),%eax
c0108c5f:	05 00 20 00 00       	add    $0x2000,%eax
c0108c64:	89 04 24             	mov    %eax,(%esp)
c0108c67:	e8 f8 e0 ff ff       	call   c0106d64 <load_esp0>
            lcr3(next->cr3);
c0108c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c6f:	8b 40 40             	mov    0x40(%eax),%eax
c0108c72:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0108c75:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c78:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c0108c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c7e:	8d 50 1c             	lea    0x1c(%eax),%edx
c0108c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c84:	83 c0 1c             	add    $0x1c,%eax
c0108c87:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108c8b:	89 04 24             	mov    %eax,(%esp)
c0108c8e:	e8 d9 fb ff ff       	call   c010886c <switch_to>
        }
        local_intr_restore(intr_flag);
c0108c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c96:	89 04 24             	mov    %eax,(%esp)
c0108c99:	e8 2f fc ff ff       	call   c01088cd <__intr_restore>
    }
}
c0108c9e:	90                   	nop
c0108c9f:	c9                   	leave  
c0108ca0:	c3                   	ret    

c0108ca1 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0108ca1:	55                   	push   %ebp
c0108ca2:	89 e5                	mov    %esp,%ebp
c0108ca4:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c0108ca7:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0108cac:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108caf:	89 04 24             	mov    %eax,(%esp)
c0108cb2:	e8 a8 a5 ff ff       	call   c010325f <forkrets>
}
c0108cb7:	90                   	nop
c0108cb8:	c9                   	leave  
c0108cb9:	c3                   	ret    

c0108cba <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c0108cba:	55                   	push   %ebp
c0108cbb:	89 e5                	mov    %esp,%ebp
c0108cbd:	53                   	push   %ebx
c0108cbe:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c0108cc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cc4:	8d 58 60             	lea    0x60(%eax),%ebx
c0108cc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cca:	8b 40 04             	mov    0x4(%eax),%eax
c0108ccd:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0108cd4:	00 
c0108cd5:	89 04 24             	mov    %eax,(%esp)
c0108cd8:	e8 b6 12 00 00       	call   c0109f93 <hash32>
c0108cdd:	c1 e0 03             	shl    $0x3,%eax
c0108ce0:	05 40 90 12 c0       	add    $0xc0129040,%eax
c0108ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108ce8:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0108ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108cee:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108cf4:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108cfa:	8b 40 04             	mov    0x4(%eax),%eax
c0108cfd:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108d00:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108d03:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108d06:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0108d09:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108d0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108d0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108d12:	89 10                	mov    %edx,(%eax)
c0108d14:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108d17:	8b 10                	mov    (%eax),%edx
c0108d19:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108d1c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108d22:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108d25:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108d2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108d2e:	89 10                	mov    %edx,(%eax)
}
c0108d30:	90                   	nop
c0108d31:	83 c4 34             	add    $0x34,%esp
c0108d34:	5b                   	pop    %ebx
c0108d35:	5d                   	pop    %ebp
c0108d36:	c3                   	ret    

c0108d37 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0108d37:	55                   	push   %ebp
c0108d38:	89 e5                	mov    %esp,%ebp
c0108d3a:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c0108d3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108d41:	7e 5f                	jle    c0108da2 <find_proc+0x6b>
c0108d43:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0108d4a:	7f 56                	jg     c0108da2 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0108d4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d4f:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0108d56:	00 
c0108d57:	89 04 24             	mov    %eax,(%esp)
c0108d5a:	e8 34 12 00 00       	call   c0109f93 <hash32>
c0108d5f:	c1 e0 03             	shl    $0x3,%eax
c0108d62:	05 40 90 12 c0       	add    $0xc0129040,%eax
c0108d67:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0108d70:	eb 19                	jmp    c0108d8b <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c0108d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d75:	83 e8 60             	sub    $0x60,%eax
c0108d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0108d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d7e:	8b 40 04             	mov    0x4(%eax),%eax
c0108d81:	3b 45 08             	cmp    0x8(%ebp),%eax
c0108d84:	75 05                	jne    c0108d8b <find_proc+0x54>
                return proc;
c0108d86:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d89:	eb 1c                	jmp    c0108da7 <find_proc+0x70>
c0108d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108d91:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d94:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0108d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d9d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108da0:	75 d0                	jne    c0108d72 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0108da2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108da7:	c9                   	leave  
c0108da8:	c3                   	ret    

c0108da9 <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0108da9:	55                   	push   %ebp
c0108daa:	89 e5                	mov    %esp,%ebp
c0108dac:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0108daf:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c0108db6:	00 
c0108db7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108dbe:	00 
c0108dbf:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108dc2:	89 04 24             	mov    %eax,(%esp)
c0108dc5:	e8 cf 09 00 00       	call   c0109799 <memset>
    tf.tf_cs = KERNEL_CS;
c0108dca:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0108dd0:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0108dd6:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0108dda:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0108dde:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0108de2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0108de6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108de9:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0108dec:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108def:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0108df2:	b8 63 88 10 c0       	mov    $0xc0108863,%eax
c0108df7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0108dfa:	8b 45 10             	mov    0x10(%ebp),%eax
c0108dfd:	0d 00 01 00 00       	or     $0x100,%eax
c0108e02:	89 c2                	mov    %eax,%edx
c0108e04:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108e07:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108e0b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108e12:	00 
c0108e13:	89 14 24             	mov    %edx,(%esp)
c0108e16:	e8 88 01 00 00       	call   c0108fa3 <do_fork>
}
c0108e1b:	c9                   	leave  
c0108e1c:	c3                   	ret    

c0108e1d <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0108e1d:	55                   	push   %ebp
c0108e1e:	89 e5                	mov    %esp,%ebp
c0108e20:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0108e23:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0108e2a:	e8 80 e0 ff ff       	call   c0106eaf <alloc_pages>
c0108e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0108e32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108e36:	74 1a                	je     c0108e52 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c0108e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108e3b:	89 04 24             	mov    %eax,(%esp)
c0108e3e:	e8 0c fb ff ff       	call   c010894f <page2kva>
c0108e43:	89 c2                	mov    %eax,%edx
c0108e45:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e48:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0108e4b:	b8 00 00 00 00       	mov    $0x0,%eax
c0108e50:	eb 05                	jmp    c0108e57 <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0108e52:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0108e57:	c9                   	leave  
c0108e58:	c3                   	ret    

c0108e59 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0108e59:	55                   	push   %ebp
c0108e5a:	89 e5                	mov    %esp,%ebp
c0108e5c:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108e5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e62:	8b 40 0c             	mov    0xc(%eax),%eax
c0108e65:	89 04 24             	mov    %eax,(%esp)
c0108e68:	e8 36 fb ff ff       	call   c01089a3 <kva2page>
c0108e6d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0108e74:	00 
c0108e75:	89 04 24             	mov    %eax,(%esp)
c0108e78:	e8 9d e0 ff ff       	call   c0106f1a <free_pages>
}
c0108e7d:	90                   	nop
c0108e7e:	c9                   	leave  
c0108e7f:	c3                   	ret    

c0108e80 <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108e80:	55                   	push   %ebp
c0108e81:	89 e5                	mov    %esp,%ebp
c0108e83:	83 ec 18             	sub    $0x18,%esp
    assert(current->mm == NULL);
c0108e86:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0108e8b:	8b 40 18             	mov    0x18(%eax),%eax
c0108e8e:	85 c0                	test   %eax,%eax
c0108e90:	74 24                	je     c0108eb6 <copy_mm+0x36>
c0108e92:	c7 44 24 0c 00 c0 10 	movl   $0xc010c000,0xc(%esp)
c0108e99:	c0 
c0108e9a:	c7 44 24 08 14 c0 10 	movl   $0xc010c014,0x8(%esp)
c0108ea1:	c0 
c0108ea2:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0108ea9:	00 
c0108eaa:	c7 04 24 29 c0 10 c0 	movl   $0xc010c029,(%esp)
c0108eb1:	e8 4a 75 ff ff       	call   c0100400 <__panic>
    /* do nothing in this project */
    return 0;
c0108eb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108ebb:	c9                   	leave  
c0108ebc:	c3                   	ret    

c0108ebd <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108ebd:	55                   	push   %ebp
c0108ebe:	89 e5                	mov    %esp,%ebp
c0108ec0:	57                   	push   %edi
c0108ec1:	56                   	push   %esi
c0108ec2:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0108ec3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ec6:	8b 40 0c             	mov    0xc(%eax),%eax
c0108ec9:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108ece:	89 c2                	mov    %eax,%edx
c0108ed0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ed3:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108ed6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ed9:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108edc:	8b 55 10             	mov    0x10(%ebp),%edx
c0108edf:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0108ee4:	89 c1                	mov    %eax,%ecx
c0108ee6:	83 e1 01             	and    $0x1,%ecx
c0108ee9:	85 c9                	test   %ecx,%ecx
c0108eeb:	74 0c                	je     c0108ef9 <copy_thread+0x3c>
c0108eed:	0f b6 0a             	movzbl (%edx),%ecx
c0108ef0:	88 08                	mov    %cl,(%eax)
c0108ef2:	8d 40 01             	lea    0x1(%eax),%eax
c0108ef5:	8d 52 01             	lea    0x1(%edx),%edx
c0108ef8:	4b                   	dec    %ebx
c0108ef9:	89 c1                	mov    %eax,%ecx
c0108efb:	83 e1 02             	and    $0x2,%ecx
c0108efe:	85 c9                	test   %ecx,%ecx
c0108f00:	74 0f                	je     c0108f11 <copy_thread+0x54>
c0108f02:	0f b7 0a             	movzwl (%edx),%ecx
c0108f05:	66 89 08             	mov    %cx,(%eax)
c0108f08:	8d 40 02             	lea    0x2(%eax),%eax
c0108f0b:	8d 52 02             	lea    0x2(%edx),%edx
c0108f0e:	83 eb 02             	sub    $0x2,%ebx
c0108f11:	89 df                	mov    %ebx,%edi
c0108f13:	83 e7 fc             	and    $0xfffffffc,%edi
c0108f16:	b9 00 00 00 00       	mov    $0x0,%ecx
c0108f1b:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0108f1e:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0108f21:	83 c1 04             	add    $0x4,%ecx
c0108f24:	39 f9                	cmp    %edi,%ecx
c0108f26:	72 f3                	jb     c0108f1b <copy_thread+0x5e>
c0108f28:	01 c8                	add    %ecx,%eax
c0108f2a:	01 ca                	add    %ecx,%edx
c0108f2c:	b9 00 00 00 00       	mov    $0x0,%ecx
c0108f31:	89 de                	mov    %ebx,%esi
c0108f33:	83 e6 02             	and    $0x2,%esi
c0108f36:	85 f6                	test   %esi,%esi
c0108f38:	74 0b                	je     c0108f45 <copy_thread+0x88>
c0108f3a:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0108f3e:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0108f42:	83 c1 02             	add    $0x2,%ecx
c0108f45:	83 e3 01             	and    $0x1,%ebx
c0108f48:	85 db                	test   %ebx,%ebx
c0108f4a:	74 07                	je     c0108f53 <copy_thread+0x96>
c0108f4c:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0108f50:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0108f53:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f56:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108f59:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108f60:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f63:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108f66:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108f69:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108f6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f6f:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108f72:	8b 55 08             	mov    0x8(%ebp),%edx
c0108f75:	8b 52 3c             	mov    0x3c(%edx),%edx
c0108f78:	8b 52 40             	mov    0x40(%edx),%edx
c0108f7b:	81 ca 00 02 00 00    	or     $0x200,%edx
c0108f81:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0108f84:	ba a1 8c 10 c0       	mov    $0xc0108ca1,%edx
c0108f89:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f8c:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0108f8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f92:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108f95:	89 c2                	mov    %eax,%edx
c0108f97:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f9a:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108f9d:	90                   	nop
c0108f9e:	5b                   	pop    %ebx
c0108f9f:	5e                   	pop    %esi
c0108fa0:	5f                   	pop    %edi
c0108fa1:	5d                   	pop    %ebp
c0108fa2:	c3                   	ret    

c0108fa3 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108fa3:	55                   	push   %ebp
c0108fa4:	89 e5                	mov    %esp,%ebp
c0108fa6:	83 ec 48             	sub    $0x48,%esp
    int ret = -E_NO_FREE_PROC;
c0108fa9:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108fb0:	a1 40 b0 12 c0       	mov    0xc012b040,%eax
c0108fb5:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108fba:	0f 8f 01 01 00 00    	jg     c01090c1 <do_fork+0x11e>
        goto fork_out;
    }
    ret = -E_NO_MEM;
c0108fc0:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    //    4. call copy_thread to setup tf & context in proc_struct
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakeup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid

    if ((proc = alloc_proc()) == NULL)
c0108fc7:	e8 21 fa ff ff       	call   c01089ed <alloc_proc>
c0108fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108fcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108fd3:	0f 84 eb 00 00 00    	je     c01090c4 <do_fork+0x121>
        goto fork_out;
    if (setup_kstack(proc) != 0)
c0108fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108fdc:	89 04 24             	mov    %eax,(%esp)
c0108fdf:	e8 39 fe ff ff       	call   c0108e1d <setup_kstack>
c0108fe4:	85 c0                	test   %eax,%eax
c0108fe6:	0f 85 de 00 00 00    	jne    c01090ca <do_fork+0x127>
        goto bad_fork_cleanup_proc;
    copy_mm(clone_flags, proc);
c0108fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108fef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ff3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ff6:	89 04 24             	mov    %eax,(%esp)
c0108ff9:	e8 82 fe ff ff       	call   c0108e80 <copy_mm>
    copy_thread(proc, stack, tf);
c0108ffe:	8b 45 10             	mov    0x10(%ebp),%eax
c0109001:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109005:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109008:	89 44 24 04          	mov    %eax,0x4(%esp)
c010900c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010900f:	89 04 24             	mov    %eax,(%esp)
c0109012:	e8 a6 fe ff ff       	call   c0108ebd <copy_thread>
    proc->pid = get_pid();
c0109017:	e8 1b fb ff ff       	call   c0108b37 <get_pid>
c010901c:	89 c2                	mov    %eax,%edx
c010901e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109021:	89 50 04             	mov    %edx,0x4(%eax)
    proc->state = PROC_RUNNABLE;
c0109024:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109027:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    proc->need_resched = 1;
c010902d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109030:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    proc->cr3 = boot_cr3;
c0109037:	8b 15 3c b1 12 c0    	mov    0xc012b13c,%edx
c010903d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109040:	89 50 40             	mov    %edx,0x40(%eax)
    set_proc_name(proc, "child");
c0109043:	c7 44 24 04 3d c0 10 	movl   $0xc010c03d,0x4(%esp)
c010904a:	c0 
c010904b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010904e:	89 04 24             	mov    %eax,(%esp)
c0109051:	e8 5c fa ff ff       	call   c0108ab2 <set_proc_name>
    hash_proc(proc);
c0109056:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109059:	89 04 24             	mov    %eax,(%esp)
c010905c:	e8 59 fc ff ff       	call   c0108cba <hash_proc>
    list_add(&(proc_list), &(proc->list_link));
c0109061:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109064:	83 c0 58             	add    $0x58,%eax
c0109067:	c7 45 ec 44 b1 12 c0 	movl   $0xc012b144,-0x14(%ebp)
c010906e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109071:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109074:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109077:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010907a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010907d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109080:	8b 40 04             	mov    0x4(%eax),%eax
c0109083:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0109086:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0109089:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010908c:	89 55 d8             	mov    %edx,-0x28(%ebp)
c010908f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0109092:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0109095:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0109098:	89 10                	mov    %edx,(%eax)
c010909a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010909d:	8b 10                	mov    (%eax),%edx
c010909f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01090a2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01090a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01090a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01090ab:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01090ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01090b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01090b4:	89 10                	mov    %edx,(%eax)
    ret = proc->pid;
c01090b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090b9:	8b 40 04             	mov    0x4(%eax),%eax
c01090bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01090bf:	eb 04                	jmp    c01090c5 <do_fork+0x122>
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
c01090c1:	90                   	nop
c01090c2:	eb 01                	jmp    c01090c5 <do_fork+0x122>
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakeup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid

    if ((proc = alloc_proc()) == NULL)
        goto fork_out;
c01090c4:	90                   	nop
    set_proc_name(proc, "child");
    hash_proc(proc);
    list_add(&(proc_list), &(proc->list_link));
    ret = proc->pid;
fork_out:
    return ret;
c01090c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01090c8:	eb 0e                	jmp    c01090d8 <do_fork+0x135>
    //    7. set ret vaule using child proc's pid

    if ((proc = alloc_proc()) == NULL)
        goto fork_out;
    if (setup_kstack(proc) != 0)
        goto bad_fork_cleanup_proc;
c01090ca:	90                   	nop
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c01090cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090ce:	89 04 24             	mov    %eax,(%esp)
c01090d1:	e8 dc c0 ff ff       	call   c01051b2 <kfree>
    goto fork_out;
c01090d6:	eb ed                	jmp    c01090c5 <do_fork+0x122>
}
c01090d8:	c9                   	leave  
c01090d9:	c3                   	ret    

c01090da <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c01090da:	55                   	push   %ebp
c01090db:	89 e5                	mov    %esp,%ebp
c01090dd:	83 ec 18             	sub    $0x18,%esp
    panic("process exit!!.\n");
c01090e0:	c7 44 24 08 43 c0 10 	movl   $0xc010c043,0x8(%esp)
c01090e7:	c0 
c01090e8:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
c01090ef:	00 
c01090f0:	c7 04 24 29 c0 10 c0 	movl   $0xc010c029,(%esp)
c01090f7:	e8 04 73 ff ff       	call   c0100400 <__panic>

c01090fc <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c01090fc:	55                   	push   %ebp
c01090fd:	89 e5                	mov    %esp,%ebp
c01090ff:	83 ec 18             	sub    $0x18,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0109102:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0109107:	89 04 24             	mov    %eax,(%esp)
c010910a:	e8 e6 f9 ff ff       	call   c0108af5 <get_proc_name>
c010910f:	89 c2                	mov    %eax,%edx
c0109111:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0109116:	8b 40 04             	mov    0x4(%eax),%eax
c0109119:	89 54 24 08          	mov    %edx,0x8(%esp)
c010911d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109121:	c7 04 24 54 c0 10 c0 	movl   $0xc010c054,(%esp)
c0109128:	e8 7c 71 ff ff       	call   c01002a9 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
c010912d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109130:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109134:	c7 04 24 7a c0 10 c0 	movl   $0xc010c07a,(%esp)
c010913b:	e8 69 71 ff ff       	call   c01002a9 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c0109140:	c7 04 24 87 c0 10 c0 	movl   $0xc010c087,(%esp)
c0109147:	e8 5d 71 ff ff       	call   c01002a9 <cprintf>
    return 0;
c010914c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109151:	c9                   	leave  
c0109152:	c3                   	ret    

c0109153 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c0109153:	55                   	push   %ebp
c0109154:	89 e5                	mov    %esp,%ebp
c0109156:	83 ec 28             	sub    $0x28,%esp
c0109159:	c7 45 e8 44 b1 12 c0 	movl   $0xc012b144,-0x18(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0109160:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109163:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109166:	89 50 04             	mov    %edx,0x4(%eax)
c0109169:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010916c:	8b 50 04             	mov    0x4(%eax),%edx
c010916f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109172:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0109174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010917b:	eb 25                	jmp    c01091a2 <proc_init+0x4f>
        list_init(hash_list + i);
c010917d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109180:	c1 e0 03             	shl    $0x3,%eax
c0109183:	05 40 90 12 c0       	add    $0xc0129040,%eax
c0109188:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010918b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010918e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109191:	89 50 04             	mov    %edx,0x4(%eax)
c0109194:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109197:	8b 50 04             	mov    0x4(%eax),%edx
c010919a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010919d:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010919f:	ff 45 f4             	incl   -0xc(%ebp)
c01091a2:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c01091a9:	7e d2                	jle    c010917d <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c01091ab:	e8 3d f8 ff ff       	call   c01089ed <alloc_proc>
c01091b0:	a3 20 90 12 c0       	mov    %eax,0xc0129020
c01091b5:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c01091ba:	85 c0                	test   %eax,%eax
c01091bc:	75 1c                	jne    c01091da <proc_init+0x87>
        panic("cannot alloc idleproc.\n");
c01091be:	c7 44 24 08 a3 c0 10 	movl   $0xc010c0a3,0x8(%esp)
c01091c5:	c0 
c01091c6:	c7 44 24 04 6e 01 00 	movl   $0x16e,0x4(%esp)
c01091cd:	00 
c01091ce:	c7 04 24 29 c0 10 c0 	movl   $0xc010c029,(%esp)
c01091d5:	e8 26 72 ff ff       	call   c0100400 <__panic>
    }

    idleproc->pid = 0;
c01091da:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c01091df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c01091e6:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c01091eb:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c01091f1:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c01091f6:	ba 00 30 12 c0       	mov    $0xc0123000,%edx
c01091fb:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c01091fe:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c0109203:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c010920a:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c010920f:	c7 44 24 04 bb c0 10 	movl   $0xc010c0bb,0x4(%esp)
c0109216:	c0 
c0109217:	89 04 24             	mov    %eax,(%esp)
c010921a:	e8 93 f8 ff ff       	call   c0108ab2 <set_proc_name>
    nr_process ++;
c010921f:	a1 40 b0 12 c0       	mov    0xc012b040,%eax
c0109224:	40                   	inc    %eax
c0109225:	a3 40 b0 12 c0       	mov    %eax,0xc012b040

    current = idleproc;
c010922a:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c010922f:	a3 28 90 12 c0       	mov    %eax,0xc0129028

    int pid = kernel_thread(init_main, "Hello world!!", 0);
c0109234:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010923b:	00 
c010923c:	c7 44 24 04 c0 c0 10 	movl   $0xc010c0c0,0x4(%esp)
c0109243:	c0 
c0109244:	c7 04 24 fc 90 10 c0 	movl   $0xc01090fc,(%esp)
c010924b:	e8 59 fb ff ff       	call   c0108da9 <kernel_thread>
c0109250:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pid <= 0) {
c0109253:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0109257:	7f 1c                	jg     c0109275 <proc_init+0x122>
        panic("create init_main failed.\n");
c0109259:	c7 44 24 08 ce c0 10 	movl   $0xc010c0ce,0x8(%esp)
c0109260:	c0 
c0109261:	c7 44 24 04 7c 01 00 	movl   $0x17c,0x4(%esp)
c0109268:	00 
c0109269:	c7 04 24 29 c0 10 c0 	movl   $0xc010c029,(%esp)
c0109270:	e8 8b 71 ff ff       	call   c0100400 <__panic>
    }

    initproc = find_proc(pid);
c0109275:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109278:	89 04 24             	mov    %eax,(%esp)
c010927b:	e8 b7 fa ff ff       	call   c0108d37 <find_proc>
c0109280:	a3 24 90 12 c0       	mov    %eax,0xc0129024
    set_proc_name(initproc, "init");
c0109285:	a1 24 90 12 c0       	mov    0xc0129024,%eax
c010928a:	c7 44 24 04 e8 c0 10 	movl   $0xc010c0e8,0x4(%esp)
c0109291:	c0 
c0109292:	89 04 24             	mov    %eax,(%esp)
c0109295:	e8 18 f8 ff ff       	call   c0108ab2 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c010929a:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c010929f:	85 c0                	test   %eax,%eax
c01092a1:	74 0c                	je     c01092af <proc_init+0x15c>
c01092a3:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c01092a8:	8b 40 04             	mov    0x4(%eax),%eax
c01092ab:	85 c0                	test   %eax,%eax
c01092ad:	74 24                	je     c01092d3 <proc_init+0x180>
c01092af:	c7 44 24 0c f0 c0 10 	movl   $0xc010c0f0,0xc(%esp)
c01092b6:	c0 
c01092b7:	c7 44 24 08 14 c0 10 	movl   $0xc010c014,0x8(%esp)
c01092be:	c0 
c01092bf:	c7 44 24 04 82 01 00 	movl   $0x182,0x4(%esp)
c01092c6:	00 
c01092c7:	c7 04 24 29 c0 10 c0 	movl   $0xc010c029,(%esp)
c01092ce:	e8 2d 71 ff ff       	call   c0100400 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c01092d3:	a1 24 90 12 c0       	mov    0xc0129024,%eax
c01092d8:	85 c0                	test   %eax,%eax
c01092da:	74 0d                	je     c01092e9 <proc_init+0x196>
c01092dc:	a1 24 90 12 c0       	mov    0xc0129024,%eax
c01092e1:	8b 40 04             	mov    0x4(%eax),%eax
c01092e4:	83 f8 01             	cmp    $0x1,%eax
c01092e7:	74 24                	je     c010930d <proc_init+0x1ba>
c01092e9:	c7 44 24 0c 18 c1 10 	movl   $0xc010c118,0xc(%esp)
c01092f0:	c0 
c01092f1:	c7 44 24 08 14 c0 10 	movl   $0xc010c014,0x8(%esp)
c01092f8:	c0 
c01092f9:	c7 44 24 04 83 01 00 	movl   $0x183,0x4(%esp)
c0109300:	00 
c0109301:	c7 04 24 29 c0 10 c0 	movl   $0xc010c029,(%esp)
c0109308:	e8 f3 70 ff ff       	call   c0100400 <__panic>
}
c010930d:	90                   	nop
c010930e:	c9                   	leave  
c010930f:	c3                   	ret    

c0109310 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c0109310:	55                   	push   %ebp
c0109311:	89 e5                	mov    %esp,%ebp
c0109313:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c0109316:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c010931b:	8b 40 10             	mov    0x10(%eax),%eax
c010931e:	85 c0                	test   %eax,%eax
c0109320:	74 f4                	je     c0109316 <cpu_idle+0x6>
            schedule();
c0109322:	e8 8a 00 00 00       	call   c01093b1 <schedule>
        }
    }
c0109327:	eb ed                	jmp    c0109316 <cpu_idle+0x6>

c0109329 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0109329:	55                   	push   %ebp
c010932a:	89 e5                	mov    %esp,%ebp
c010932c:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010932f:	9c                   	pushf  
c0109330:	58                   	pop    %eax
c0109331:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0109334:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0109337:	25 00 02 00 00       	and    $0x200,%eax
c010933c:	85 c0                	test   %eax,%eax
c010933e:	74 0c                	je     c010934c <__intr_save+0x23>
        intr_disable();
c0109340:	e8 de 8d ff ff       	call   c0102123 <intr_disable>
        return 1;
c0109345:	b8 01 00 00 00       	mov    $0x1,%eax
c010934a:	eb 05                	jmp    c0109351 <__intr_save+0x28>
    }
    return 0;
c010934c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109351:	c9                   	leave  
c0109352:	c3                   	ret    

c0109353 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0109353:	55                   	push   %ebp
c0109354:	89 e5                	mov    %esp,%ebp
c0109356:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0109359:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010935d:	74 05                	je     c0109364 <__intr_restore+0x11>
        intr_enable();
c010935f:	e8 b8 8d ff ff       	call   c010211c <intr_enable>
    }
}
c0109364:	90                   	nop
c0109365:	c9                   	leave  
c0109366:	c3                   	ret    

c0109367 <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c0109367:	55                   	push   %ebp
c0109368:	89 e5                	mov    %esp,%ebp
c010936a:	83 ec 18             	sub    $0x18,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c010936d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109370:	8b 00                	mov    (%eax),%eax
c0109372:	83 f8 03             	cmp    $0x3,%eax
c0109375:	74 0a                	je     c0109381 <wakeup_proc+0x1a>
c0109377:	8b 45 08             	mov    0x8(%ebp),%eax
c010937a:	8b 00                	mov    (%eax),%eax
c010937c:	83 f8 02             	cmp    $0x2,%eax
c010937f:	75 24                	jne    c01093a5 <wakeup_proc+0x3e>
c0109381:	c7 44 24 0c 40 c1 10 	movl   $0xc010c140,0xc(%esp)
c0109388:	c0 
c0109389:	c7 44 24 08 7b c1 10 	movl   $0xc010c17b,0x8(%esp)
c0109390:	c0 
c0109391:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c0109398:	00 
c0109399:	c7 04 24 90 c1 10 c0 	movl   $0xc010c190,(%esp)
c01093a0:	e8 5b 70 ff ff       	call   c0100400 <__panic>
    proc->state = PROC_RUNNABLE;
c01093a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01093a8:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c01093ae:	90                   	nop
c01093af:	c9                   	leave  
c01093b0:	c3                   	ret    

c01093b1 <schedule>:

void
schedule(void) {
c01093b1:	55                   	push   %ebp
c01093b2:	89 e5                	mov    %esp,%ebp
c01093b4:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c01093b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c01093be:	e8 66 ff ff ff       	call   c0109329 <__intr_save>
c01093c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c01093c6:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c01093cb:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c01093d2:	8b 15 28 90 12 c0    	mov    0xc0129028,%edx
c01093d8:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c01093dd:	39 c2                	cmp    %eax,%edx
c01093df:	74 0a                	je     c01093eb <schedule+0x3a>
c01093e1:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c01093e6:	83 c0 58             	add    $0x58,%eax
c01093e9:	eb 05                	jmp    c01093f0 <schedule+0x3f>
c01093eb:	b8 44 b1 12 c0       	mov    $0xc012b144,%eax
c01093f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c01093f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01093f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01093f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01093fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01093ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109402:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c0109405:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109408:	81 7d f4 44 b1 12 c0 	cmpl   $0xc012b144,-0xc(%ebp)
c010940f:	74 13                	je     c0109424 <schedule+0x73>
                next = le2proc(le, list_link);
c0109411:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109414:	83 e8 58             	sub    $0x58,%eax
c0109417:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c010941a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010941d:	8b 00                	mov    (%eax),%eax
c010941f:	83 f8 02             	cmp    $0x2,%eax
c0109422:	74 0a                	je     c010942e <schedule+0x7d>
                    break;
                }
            }
        } while (le != last);
c0109424:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109427:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010942a:	75 cd                	jne    c01093f9 <schedule+0x48>
c010942c:	eb 01                	jmp    c010942f <schedule+0x7e>
        le = last;
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
                    break;
c010942e:	90                   	nop
                }
            }
        } while (le != last);
        if (next == NULL || next->state != PROC_RUNNABLE) {
c010942f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109433:	74 0a                	je     c010943f <schedule+0x8e>
c0109435:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109438:	8b 00                	mov    (%eax),%eax
c010943a:	83 f8 02             	cmp    $0x2,%eax
c010943d:	74 08                	je     c0109447 <schedule+0x96>
            next = idleproc;
c010943f:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c0109444:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c0109447:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010944a:	8b 40 08             	mov    0x8(%eax),%eax
c010944d:	8d 50 01             	lea    0x1(%eax),%edx
c0109450:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109453:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c0109456:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c010945b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010945e:	74 0b                	je     c010946b <schedule+0xba>
            proc_run(next);
c0109460:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109463:	89 04 24             	mov    %eax,(%esp)
c0109466:	e8 c0 f7 ff ff       	call   c0108c2b <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c010946b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010946e:	89 04 24             	mov    %eax,(%esp)
c0109471:	e8 dd fe ff ff       	call   c0109353 <__intr_restore>
}
c0109476:	90                   	nop
c0109477:	c9                   	leave  
c0109478:	c3                   	ret    

c0109479 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0109479:	55                   	push   %ebp
c010947a:	89 e5                	mov    %esp,%ebp
c010947c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010947f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0109486:	eb 03                	jmp    c010948b <strlen+0x12>
        cnt ++;
c0109488:	ff 45 fc             	incl   -0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010948b:	8b 45 08             	mov    0x8(%ebp),%eax
c010948e:	8d 50 01             	lea    0x1(%eax),%edx
c0109491:	89 55 08             	mov    %edx,0x8(%ebp)
c0109494:	0f b6 00             	movzbl (%eax),%eax
c0109497:	84 c0                	test   %al,%al
c0109499:	75 ed                	jne    c0109488 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010949b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010949e:	c9                   	leave  
c010949f:	c3                   	ret    

c01094a0 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01094a0:	55                   	push   %ebp
c01094a1:	89 e5                	mov    %esp,%ebp
c01094a3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01094a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01094ad:	eb 03                	jmp    c01094b2 <strnlen+0x12>
        cnt ++;
c01094af:	ff 45 fc             	incl   -0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01094b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01094b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01094b8:	73 10                	jae    c01094ca <strnlen+0x2a>
c01094ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01094bd:	8d 50 01             	lea    0x1(%eax),%edx
c01094c0:	89 55 08             	mov    %edx,0x8(%ebp)
c01094c3:	0f b6 00             	movzbl (%eax),%eax
c01094c6:	84 c0                	test   %al,%al
c01094c8:	75 e5                	jne    c01094af <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01094ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01094cd:	c9                   	leave  
c01094ce:	c3                   	ret    

c01094cf <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01094cf:	55                   	push   %ebp
c01094d0:	89 e5                	mov    %esp,%ebp
c01094d2:	57                   	push   %edi
c01094d3:	56                   	push   %esi
c01094d4:	83 ec 20             	sub    $0x20,%esp
c01094d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01094da:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01094dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01094e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01094e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094e9:	89 d1                	mov    %edx,%ecx
c01094eb:	89 c2                	mov    %eax,%edx
c01094ed:	89 ce                	mov    %ecx,%esi
c01094ef:	89 d7                	mov    %edx,%edi
c01094f1:	ac                   	lods   %ds:(%esi),%al
c01094f2:	aa                   	stos   %al,%es:(%edi)
c01094f3:	84 c0                	test   %al,%al
c01094f5:	75 fa                	jne    c01094f1 <strcpy+0x22>
c01094f7:	89 fa                	mov    %edi,%edx
c01094f9:	89 f1                	mov    %esi,%ecx
c01094fb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01094fe:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0109501:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0109504:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0109507:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0109508:	83 c4 20             	add    $0x20,%esp
c010950b:	5e                   	pop    %esi
c010950c:	5f                   	pop    %edi
c010950d:	5d                   	pop    %ebp
c010950e:	c3                   	ret    

c010950f <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010950f:	55                   	push   %ebp
c0109510:	89 e5                	mov    %esp,%ebp
c0109512:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0109515:	8b 45 08             	mov    0x8(%ebp),%eax
c0109518:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010951b:	eb 1e                	jmp    c010953b <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c010951d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109520:	0f b6 10             	movzbl (%eax),%edx
c0109523:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109526:	88 10                	mov    %dl,(%eax)
c0109528:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010952b:	0f b6 00             	movzbl (%eax),%eax
c010952e:	84 c0                	test   %al,%al
c0109530:	74 03                	je     c0109535 <strncpy+0x26>
            src ++;
c0109532:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0109535:	ff 45 fc             	incl   -0x4(%ebp)
c0109538:	ff 4d 10             	decl   0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010953b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010953f:	75 dc                	jne    c010951d <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0109541:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109544:	c9                   	leave  
c0109545:	c3                   	ret    

c0109546 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0109546:	55                   	push   %ebp
c0109547:	89 e5                	mov    %esp,%ebp
c0109549:	57                   	push   %edi
c010954a:	56                   	push   %esi
c010954b:	83 ec 20             	sub    $0x20,%esp
c010954e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109551:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109554:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109557:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010955a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010955d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109560:	89 d1                	mov    %edx,%ecx
c0109562:	89 c2                	mov    %eax,%edx
c0109564:	89 ce                	mov    %ecx,%esi
c0109566:	89 d7                	mov    %edx,%edi
c0109568:	ac                   	lods   %ds:(%esi),%al
c0109569:	ae                   	scas   %es:(%edi),%al
c010956a:	75 08                	jne    c0109574 <strcmp+0x2e>
c010956c:	84 c0                	test   %al,%al
c010956e:	75 f8                	jne    c0109568 <strcmp+0x22>
c0109570:	31 c0                	xor    %eax,%eax
c0109572:	eb 04                	jmp    c0109578 <strcmp+0x32>
c0109574:	19 c0                	sbb    %eax,%eax
c0109576:	0c 01                	or     $0x1,%al
c0109578:	89 fa                	mov    %edi,%edx
c010957a:	89 f1                	mov    %esi,%ecx
c010957c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010957f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109582:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0109585:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0109588:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0109589:	83 c4 20             	add    $0x20,%esp
c010958c:	5e                   	pop    %esi
c010958d:	5f                   	pop    %edi
c010958e:	5d                   	pop    %ebp
c010958f:	c3                   	ret    

c0109590 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0109590:	55                   	push   %ebp
c0109591:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109593:	eb 09                	jmp    c010959e <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0109595:	ff 4d 10             	decl   0x10(%ebp)
c0109598:	ff 45 08             	incl   0x8(%ebp)
c010959b:	ff 45 0c             	incl   0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010959e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01095a2:	74 1a                	je     c01095be <strncmp+0x2e>
c01095a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01095a7:	0f b6 00             	movzbl (%eax),%eax
c01095aa:	84 c0                	test   %al,%al
c01095ac:	74 10                	je     c01095be <strncmp+0x2e>
c01095ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01095b1:	0f b6 10             	movzbl (%eax),%edx
c01095b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095b7:	0f b6 00             	movzbl (%eax),%eax
c01095ba:	38 c2                	cmp    %al,%dl
c01095bc:	74 d7                	je     c0109595 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01095be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01095c2:	74 18                	je     c01095dc <strncmp+0x4c>
c01095c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01095c7:	0f b6 00             	movzbl (%eax),%eax
c01095ca:	0f b6 d0             	movzbl %al,%edx
c01095cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095d0:	0f b6 00             	movzbl (%eax),%eax
c01095d3:	0f b6 c0             	movzbl %al,%eax
c01095d6:	29 c2                	sub    %eax,%edx
c01095d8:	89 d0                	mov    %edx,%eax
c01095da:	eb 05                	jmp    c01095e1 <strncmp+0x51>
c01095dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01095e1:	5d                   	pop    %ebp
c01095e2:	c3                   	ret    

c01095e3 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01095e3:	55                   	push   %ebp
c01095e4:	89 e5                	mov    %esp,%ebp
c01095e6:	83 ec 04             	sub    $0x4,%esp
c01095e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095ec:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01095ef:	eb 13                	jmp    c0109604 <strchr+0x21>
        if (*s == c) {
c01095f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01095f4:	0f b6 00             	movzbl (%eax),%eax
c01095f7:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01095fa:	75 05                	jne    c0109601 <strchr+0x1e>
            return (char *)s;
c01095fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01095ff:	eb 12                	jmp    c0109613 <strchr+0x30>
        }
        s ++;
c0109601:	ff 45 08             	incl   0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0109604:	8b 45 08             	mov    0x8(%ebp),%eax
c0109607:	0f b6 00             	movzbl (%eax),%eax
c010960a:	84 c0                	test   %al,%al
c010960c:	75 e3                	jne    c01095f1 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010960e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109613:	c9                   	leave  
c0109614:	c3                   	ret    

c0109615 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0109615:	55                   	push   %ebp
c0109616:	89 e5                	mov    %esp,%ebp
c0109618:	83 ec 04             	sub    $0x4,%esp
c010961b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010961e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109621:	eb 0e                	jmp    c0109631 <strfind+0x1c>
        if (*s == c) {
c0109623:	8b 45 08             	mov    0x8(%ebp),%eax
c0109626:	0f b6 00             	movzbl (%eax),%eax
c0109629:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010962c:	74 0f                	je     c010963d <strfind+0x28>
            break;
        }
        s ++;
c010962e:	ff 45 08             	incl   0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0109631:	8b 45 08             	mov    0x8(%ebp),%eax
c0109634:	0f b6 00             	movzbl (%eax),%eax
c0109637:	84 c0                	test   %al,%al
c0109639:	75 e8                	jne    c0109623 <strfind+0xe>
c010963b:	eb 01                	jmp    c010963e <strfind+0x29>
        if (*s == c) {
            break;
c010963d:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c010963e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109641:	c9                   	leave  
c0109642:	c3                   	ret    

c0109643 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0109643:	55                   	push   %ebp
c0109644:	89 e5                	mov    %esp,%ebp
c0109646:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0109649:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0109650:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109657:	eb 03                	jmp    c010965c <strtol+0x19>
        s ++;
c0109659:	ff 45 08             	incl   0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010965c:	8b 45 08             	mov    0x8(%ebp),%eax
c010965f:	0f b6 00             	movzbl (%eax),%eax
c0109662:	3c 20                	cmp    $0x20,%al
c0109664:	74 f3                	je     c0109659 <strtol+0x16>
c0109666:	8b 45 08             	mov    0x8(%ebp),%eax
c0109669:	0f b6 00             	movzbl (%eax),%eax
c010966c:	3c 09                	cmp    $0x9,%al
c010966e:	74 e9                	je     c0109659 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0109670:	8b 45 08             	mov    0x8(%ebp),%eax
c0109673:	0f b6 00             	movzbl (%eax),%eax
c0109676:	3c 2b                	cmp    $0x2b,%al
c0109678:	75 05                	jne    c010967f <strtol+0x3c>
        s ++;
c010967a:	ff 45 08             	incl   0x8(%ebp)
c010967d:	eb 14                	jmp    c0109693 <strtol+0x50>
    }
    else if (*s == '-') {
c010967f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109682:	0f b6 00             	movzbl (%eax),%eax
c0109685:	3c 2d                	cmp    $0x2d,%al
c0109687:	75 0a                	jne    c0109693 <strtol+0x50>
        s ++, neg = 1;
c0109689:	ff 45 08             	incl   0x8(%ebp)
c010968c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0109693:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109697:	74 06                	je     c010969f <strtol+0x5c>
c0109699:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010969d:	75 22                	jne    c01096c1 <strtol+0x7e>
c010969f:	8b 45 08             	mov    0x8(%ebp),%eax
c01096a2:	0f b6 00             	movzbl (%eax),%eax
c01096a5:	3c 30                	cmp    $0x30,%al
c01096a7:	75 18                	jne    c01096c1 <strtol+0x7e>
c01096a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01096ac:	40                   	inc    %eax
c01096ad:	0f b6 00             	movzbl (%eax),%eax
c01096b0:	3c 78                	cmp    $0x78,%al
c01096b2:	75 0d                	jne    c01096c1 <strtol+0x7e>
        s += 2, base = 16;
c01096b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01096b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01096bf:	eb 29                	jmp    c01096ea <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c01096c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01096c5:	75 16                	jne    c01096dd <strtol+0x9a>
c01096c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01096ca:	0f b6 00             	movzbl (%eax),%eax
c01096cd:	3c 30                	cmp    $0x30,%al
c01096cf:	75 0c                	jne    c01096dd <strtol+0x9a>
        s ++, base = 8;
c01096d1:	ff 45 08             	incl   0x8(%ebp)
c01096d4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01096db:	eb 0d                	jmp    c01096ea <strtol+0xa7>
    }
    else if (base == 0) {
c01096dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01096e1:	75 07                	jne    c01096ea <strtol+0xa7>
        base = 10;
c01096e3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01096ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01096ed:	0f b6 00             	movzbl (%eax),%eax
c01096f0:	3c 2f                	cmp    $0x2f,%al
c01096f2:	7e 1b                	jle    c010970f <strtol+0xcc>
c01096f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01096f7:	0f b6 00             	movzbl (%eax),%eax
c01096fa:	3c 39                	cmp    $0x39,%al
c01096fc:	7f 11                	jg     c010970f <strtol+0xcc>
            dig = *s - '0';
c01096fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0109701:	0f b6 00             	movzbl (%eax),%eax
c0109704:	0f be c0             	movsbl %al,%eax
c0109707:	83 e8 30             	sub    $0x30,%eax
c010970a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010970d:	eb 48                	jmp    c0109757 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010970f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109712:	0f b6 00             	movzbl (%eax),%eax
c0109715:	3c 60                	cmp    $0x60,%al
c0109717:	7e 1b                	jle    c0109734 <strtol+0xf1>
c0109719:	8b 45 08             	mov    0x8(%ebp),%eax
c010971c:	0f b6 00             	movzbl (%eax),%eax
c010971f:	3c 7a                	cmp    $0x7a,%al
c0109721:	7f 11                	jg     c0109734 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0109723:	8b 45 08             	mov    0x8(%ebp),%eax
c0109726:	0f b6 00             	movzbl (%eax),%eax
c0109729:	0f be c0             	movsbl %al,%eax
c010972c:	83 e8 57             	sub    $0x57,%eax
c010972f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109732:	eb 23                	jmp    c0109757 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0109734:	8b 45 08             	mov    0x8(%ebp),%eax
c0109737:	0f b6 00             	movzbl (%eax),%eax
c010973a:	3c 40                	cmp    $0x40,%al
c010973c:	7e 3b                	jle    c0109779 <strtol+0x136>
c010973e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109741:	0f b6 00             	movzbl (%eax),%eax
c0109744:	3c 5a                	cmp    $0x5a,%al
c0109746:	7f 31                	jg     c0109779 <strtol+0x136>
            dig = *s - 'A' + 10;
c0109748:	8b 45 08             	mov    0x8(%ebp),%eax
c010974b:	0f b6 00             	movzbl (%eax),%eax
c010974e:	0f be c0             	movsbl %al,%eax
c0109751:	83 e8 37             	sub    $0x37,%eax
c0109754:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0109757:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010975a:	3b 45 10             	cmp    0x10(%ebp),%eax
c010975d:	7d 19                	jge    c0109778 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c010975f:	ff 45 08             	incl   0x8(%ebp)
c0109762:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109765:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109769:	89 c2                	mov    %eax,%edx
c010976b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010976e:	01 d0                	add    %edx,%eax
c0109770:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0109773:	e9 72 ff ff ff       	jmp    c01096ea <strtol+0xa7>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0109778:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0109779:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010977d:	74 08                	je     c0109787 <strtol+0x144>
        *endptr = (char *) s;
c010977f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109782:	8b 55 08             	mov    0x8(%ebp),%edx
c0109785:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109787:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010978b:	74 07                	je     c0109794 <strtol+0x151>
c010978d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109790:	f7 d8                	neg    %eax
c0109792:	eb 03                	jmp    c0109797 <strtol+0x154>
c0109794:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109797:	c9                   	leave  
c0109798:	c3                   	ret    

c0109799 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109799:	55                   	push   %ebp
c010979a:	89 e5                	mov    %esp,%ebp
c010979c:	57                   	push   %edi
c010979d:	83 ec 24             	sub    $0x24,%esp
c01097a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097a3:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01097a6:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01097aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01097ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01097b0:	88 45 f7             	mov    %al,-0x9(%ebp)
c01097b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01097b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01097b9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01097bc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01097c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01097c3:	89 d7                	mov    %edx,%edi
c01097c5:	f3 aa                	rep stos %al,%es:(%edi)
c01097c7:	89 fa                	mov    %edi,%edx
c01097c9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01097cc:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01097cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01097d2:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01097d3:	83 c4 24             	add    $0x24,%esp
c01097d6:	5f                   	pop    %edi
c01097d7:	5d                   	pop    %ebp
c01097d8:	c3                   	ret    

c01097d9 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01097d9:	55                   	push   %ebp
c01097da:	89 e5                	mov    %esp,%ebp
c01097dc:	57                   	push   %edi
c01097dd:	56                   	push   %esi
c01097de:	53                   	push   %ebx
c01097df:	83 ec 30             	sub    $0x30,%esp
c01097e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01097e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01097e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01097ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01097f1:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01097f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01097fa:	73 42                	jae    c010983e <memmove+0x65>
c01097fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109802:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109805:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109808:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010980b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010980e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109811:	c1 e8 02             	shr    $0x2,%eax
c0109814:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109816:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109819:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010981c:	89 d7                	mov    %edx,%edi
c010981e:	89 c6                	mov    %eax,%esi
c0109820:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109822:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0109825:	83 e1 03             	and    $0x3,%ecx
c0109828:	74 02                	je     c010982c <memmove+0x53>
c010982a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010982c:	89 f0                	mov    %esi,%eax
c010982e:	89 fa                	mov    %edi,%edx
c0109830:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0109833:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109836:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109839:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c010983c:	eb 36                	jmp    c0109874 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010983e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109841:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109844:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109847:	01 c2                	add    %eax,%edx
c0109849:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010984c:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010984f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109852:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0109855:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109858:	89 c1                	mov    %eax,%ecx
c010985a:	89 d8                	mov    %ebx,%eax
c010985c:	89 d6                	mov    %edx,%esi
c010985e:	89 c7                	mov    %eax,%edi
c0109860:	fd                   	std    
c0109861:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109863:	fc                   	cld    
c0109864:	89 f8                	mov    %edi,%eax
c0109866:	89 f2                	mov    %esi,%edx
c0109868:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010986b:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010986e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0109871:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109874:	83 c4 30             	add    $0x30,%esp
c0109877:	5b                   	pop    %ebx
c0109878:	5e                   	pop    %esi
c0109879:	5f                   	pop    %edi
c010987a:	5d                   	pop    %ebp
c010987b:	c3                   	ret    

c010987c <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010987c:	55                   	push   %ebp
c010987d:	89 e5                	mov    %esp,%ebp
c010987f:	57                   	push   %edi
c0109880:	56                   	push   %esi
c0109881:	83 ec 20             	sub    $0x20,%esp
c0109884:	8b 45 08             	mov    0x8(%ebp),%eax
c0109887:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010988a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010988d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109890:	8b 45 10             	mov    0x10(%ebp),%eax
c0109893:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109896:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109899:	c1 e8 02             	shr    $0x2,%eax
c010989c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010989e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01098a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01098a4:	89 d7                	mov    %edx,%edi
c01098a6:	89 c6                	mov    %eax,%esi
c01098a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01098aa:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01098ad:	83 e1 03             	and    $0x3,%ecx
c01098b0:	74 02                	je     c01098b4 <memcpy+0x38>
c01098b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01098b4:	89 f0                	mov    %esi,%eax
c01098b6:	89 fa                	mov    %edi,%edx
c01098b8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01098bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01098be:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01098c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c01098c4:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01098c5:	83 c4 20             	add    $0x20,%esp
c01098c8:	5e                   	pop    %esi
c01098c9:	5f                   	pop    %edi
c01098ca:	5d                   	pop    %ebp
c01098cb:	c3                   	ret    

c01098cc <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01098cc:	55                   	push   %ebp
c01098cd:	89 e5                	mov    %esp,%ebp
c01098cf:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01098d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01098d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01098d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098db:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01098de:	eb 2e                	jmp    c010990e <memcmp+0x42>
        if (*s1 != *s2) {
c01098e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01098e3:	0f b6 10             	movzbl (%eax),%edx
c01098e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01098e9:	0f b6 00             	movzbl (%eax),%eax
c01098ec:	38 c2                	cmp    %al,%dl
c01098ee:	74 18                	je     c0109908 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01098f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01098f3:	0f b6 00             	movzbl (%eax),%eax
c01098f6:	0f b6 d0             	movzbl %al,%edx
c01098f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01098fc:	0f b6 00             	movzbl (%eax),%eax
c01098ff:	0f b6 c0             	movzbl %al,%eax
c0109902:	29 c2                	sub    %eax,%edx
c0109904:	89 d0                	mov    %edx,%eax
c0109906:	eb 18                	jmp    c0109920 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0109908:	ff 45 fc             	incl   -0x4(%ebp)
c010990b:	ff 45 f8             	incl   -0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010990e:	8b 45 10             	mov    0x10(%ebp),%eax
c0109911:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109914:	89 55 10             	mov    %edx,0x10(%ebp)
c0109917:	85 c0                	test   %eax,%eax
c0109919:	75 c5                	jne    c01098e0 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010991b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109920:	c9                   	leave  
c0109921:	c3                   	ret    

c0109922 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0109922:	55                   	push   %ebp
c0109923:	89 e5                	mov    %esp,%ebp
c0109925:	83 ec 58             	sub    $0x58,%esp
c0109928:	8b 45 10             	mov    0x10(%ebp),%eax
c010992b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010992e:	8b 45 14             	mov    0x14(%ebp),%eax
c0109931:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0109934:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109937:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010993a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010993d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0109940:	8b 45 18             	mov    0x18(%ebp),%eax
c0109943:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109946:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109949:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010994c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010994f:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0109952:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109955:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109958:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010995c:	74 1c                	je     c010997a <printnum+0x58>
c010995e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109961:	ba 00 00 00 00       	mov    $0x0,%edx
c0109966:	f7 75 e4             	divl   -0x1c(%ebp)
c0109969:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010996c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010996f:	ba 00 00 00 00       	mov    $0x0,%edx
c0109974:	f7 75 e4             	divl   -0x1c(%ebp)
c0109977:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010997a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010997d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109980:	f7 75 e4             	divl   -0x1c(%ebp)
c0109983:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109986:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0109989:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010998c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010998f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109992:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109995:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109998:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010999b:	8b 45 18             	mov    0x18(%ebp),%eax
c010999e:	ba 00 00 00 00       	mov    $0x0,%edx
c01099a3:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01099a6:	77 56                	ja     c01099fe <printnum+0xdc>
c01099a8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01099ab:	72 05                	jb     c01099b2 <printnum+0x90>
c01099ad:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01099b0:	77 4c                	ja     c01099fe <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01099b2:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01099b5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01099b8:	8b 45 20             	mov    0x20(%ebp),%eax
c01099bb:	89 44 24 18          	mov    %eax,0x18(%esp)
c01099bf:	89 54 24 14          	mov    %edx,0x14(%esp)
c01099c3:	8b 45 18             	mov    0x18(%ebp),%eax
c01099c6:	89 44 24 10          	mov    %eax,0x10(%esp)
c01099ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01099cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01099d0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01099d4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01099d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01099df:	8b 45 08             	mov    0x8(%ebp),%eax
c01099e2:	89 04 24             	mov    %eax,(%esp)
c01099e5:	e8 38 ff ff ff       	call   c0109922 <printnum>
c01099ea:	eb 1b                	jmp    c0109a07 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01099ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01099f3:	8b 45 20             	mov    0x20(%ebp),%eax
c01099f6:	89 04 24             	mov    %eax,(%esp)
c01099f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01099fc:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01099fe:	ff 4d 1c             	decl   0x1c(%ebp)
c0109a01:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0109a05:	7f e5                	jg     c01099ec <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0109a07:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109a0a:	05 28 c2 10 c0       	add    $0xc010c228,%eax
c0109a0f:	0f b6 00             	movzbl (%eax),%eax
c0109a12:	0f be c0             	movsbl %al,%eax
c0109a15:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109a18:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109a1c:	89 04 24             	mov    %eax,(%esp)
c0109a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a22:	ff d0                	call   *%eax
}
c0109a24:	90                   	nop
c0109a25:	c9                   	leave  
c0109a26:	c3                   	ret    

c0109a27 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0109a27:	55                   	push   %ebp
c0109a28:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109a2a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109a2e:	7e 14                	jle    c0109a44 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0109a30:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a33:	8b 00                	mov    (%eax),%eax
c0109a35:	8d 48 08             	lea    0x8(%eax),%ecx
c0109a38:	8b 55 08             	mov    0x8(%ebp),%edx
c0109a3b:	89 0a                	mov    %ecx,(%edx)
c0109a3d:	8b 50 04             	mov    0x4(%eax),%edx
c0109a40:	8b 00                	mov    (%eax),%eax
c0109a42:	eb 30                	jmp    c0109a74 <getuint+0x4d>
    }
    else if (lflag) {
c0109a44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109a48:	74 16                	je     c0109a60 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0109a4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a4d:	8b 00                	mov    (%eax),%eax
c0109a4f:	8d 48 04             	lea    0x4(%eax),%ecx
c0109a52:	8b 55 08             	mov    0x8(%ebp),%edx
c0109a55:	89 0a                	mov    %ecx,(%edx)
c0109a57:	8b 00                	mov    (%eax),%eax
c0109a59:	ba 00 00 00 00       	mov    $0x0,%edx
c0109a5e:	eb 14                	jmp    c0109a74 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0109a60:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a63:	8b 00                	mov    (%eax),%eax
c0109a65:	8d 48 04             	lea    0x4(%eax),%ecx
c0109a68:	8b 55 08             	mov    0x8(%ebp),%edx
c0109a6b:	89 0a                	mov    %ecx,(%edx)
c0109a6d:	8b 00                	mov    (%eax),%eax
c0109a6f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0109a74:	5d                   	pop    %ebp
c0109a75:	c3                   	ret    

c0109a76 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0109a76:	55                   	push   %ebp
c0109a77:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109a79:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109a7d:	7e 14                	jle    c0109a93 <getint+0x1d>
        return va_arg(*ap, long long);
c0109a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a82:	8b 00                	mov    (%eax),%eax
c0109a84:	8d 48 08             	lea    0x8(%eax),%ecx
c0109a87:	8b 55 08             	mov    0x8(%ebp),%edx
c0109a8a:	89 0a                	mov    %ecx,(%edx)
c0109a8c:	8b 50 04             	mov    0x4(%eax),%edx
c0109a8f:	8b 00                	mov    (%eax),%eax
c0109a91:	eb 28                	jmp    c0109abb <getint+0x45>
    }
    else if (lflag) {
c0109a93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109a97:	74 12                	je     c0109aab <getint+0x35>
        return va_arg(*ap, long);
c0109a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a9c:	8b 00                	mov    (%eax),%eax
c0109a9e:	8d 48 04             	lea    0x4(%eax),%ecx
c0109aa1:	8b 55 08             	mov    0x8(%ebp),%edx
c0109aa4:	89 0a                	mov    %ecx,(%edx)
c0109aa6:	8b 00                	mov    (%eax),%eax
c0109aa8:	99                   	cltd   
c0109aa9:	eb 10                	jmp    c0109abb <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0109aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0109aae:	8b 00                	mov    (%eax),%eax
c0109ab0:	8d 48 04             	lea    0x4(%eax),%ecx
c0109ab3:	8b 55 08             	mov    0x8(%ebp),%edx
c0109ab6:	89 0a                	mov    %ecx,(%edx)
c0109ab8:	8b 00                	mov    (%eax),%eax
c0109aba:	99                   	cltd   
    }
}
c0109abb:	5d                   	pop    %ebp
c0109abc:	c3                   	ret    

c0109abd <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0109abd:	55                   	push   %ebp
c0109abe:	89 e5                	mov    %esp,%ebp
c0109ac0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0109ac3:	8d 45 14             	lea    0x14(%ebp),%eax
c0109ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0109ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109acc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109ad0:	8b 45 10             	mov    0x10(%ebp),%eax
c0109ad3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ada:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ade:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ae1:	89 04 24             	mov    %eax,(%esp)
c0109ae4:	e8 03 00 00 00       	call   c0109aec <vprintfmt>
    va_end(ap);
}
c0109ae9:	90                   	nop
c0109aea:	c9                   	leave  
c0109aeb:	c3                   	ret    

c0109aec <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0109aec:	55                   	push   %ebp
c0109aed:	89 e5                	mov    %esp,%ebp
c0109aef:	56                   	push   %esi
c0109af0:	53                   	push   %ebx
c0109af1:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109af4:	eb 17                	jmp    c0109b0d <vprintfmt+0x21>
            if (ch == '\0') {
c0109af6:	85 db                	test   %ebx,%ebx
c0109af8:	0f 84 bf 03 00 00    	je     c0109ebd <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0109afe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109b05:	89 1c 24             	mov    %ebx,(%esp)
c0109b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b0b:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109b0d:	8b 45 10             	mov    0x10(%ebp),%eax
c0109b10:	8d 50 01             	lea    0x1(%eax),%edx
c0109b13:	89 55 10             	mov    %edx,0x10(%ebp)
c0109b16:	0f b6 00             	movzbl (%eax),%eax
c0109b19:	0f b6 d8             	movzbl %al,%ebx
c0109b1c:	83 fb 25             	cmp    $0x25,%ebx
c0109b1f:	75 d5                	jne    c0109af6 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0109b21:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0109b25:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0109b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109b2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0109b32:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0109b39:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109b3c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0109b3f:	8b 45 10             	mov    0x10(%ebp),%eax
c0109b42:	8d 50 01             	lea    0x1(%eax),%edx
c0109b45:	89 55 10             	mov    %edx,0x10(%ebp)
c0109b48:	0f b6 00             	movzbl (%eax),%eax
c0109b4b:	0f b6 d8             	movzbl %al,%ebx
c0109b4e:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0109b51:	83 f8 55             	cmp    $0x55,%eax
c0109b54:	0f 87 37 03 00 00    	ja     c0109e91 <vprintfmt+0x3a5>
c0109b5a:	8b 04 85 4c c2 10 c0 	mov    -0x3fef3db4(,%eax,4),%eax
c0109b61:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0109b63:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0109b67:	eb d6                	jmp    c0109b3f <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0109b69:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0109b6d:	eb d0                	jmp    c0109b3f <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0109b6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0109b76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109b79:	89 d0                	mov    %edx,%eax
c0109b7b:	c1 e0 02             	shl    $0x2,%eax
c0109b7e:	01 d0                	add    %edx,%eax
c0109b80:	01 c0                	add    %eax,%eax
c0109b82:	01 d8                	add    %ebx,%eax
c0109b84:	83 e8 30             	sub    $0x30,%eax
c0109b87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0109b8a:	8b 45 10             	mov    0x10(%ebp),%eax
c0109b8d:	0f b6 00             	movzbl (%eax),%eax
c0109b90:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0109b93:	83 fb 2f             	cmp    $0x2f,%ebx
c0109b96:	7e 38                	jle    c0109bd0 <vprintfmt+0xe4>
c0109b98:	83 fb 39             	cmp    $0x39,%ebx
c0109b9b:	7f 33                	jg     c0109bd0 <vprintfmt+0xe4>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0109b9d:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0109ba0:	eb d4                	jmp    c0109b76 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0109ba2:	8b 45 14             	mov    0x14(%ebp),%eax
c0109ba5:	8d 50 04             	lea    0x4(%eax),%edx
c0109ba8:	89 55 14             	mov    %edx,0x14(%ebp)
c0109bab:	8b 00                	mov    (%eax),%eax
c0109bad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0109bb0:	eb 1f                	jmp    c0109bd1 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0109bb2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109bb6:	79 87                	jns    c0109b3f <vprintfmt+0x53>
                width = 0;
c0109bb8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0109bbf:	e9 7b ff ff ff       	jmp    c0109b3f <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0109bc4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0109bcb:	e9 6f ff ff ff       	jmp    c0109b3f <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c0109bd0:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c0109bd1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109bd5:	0f 89 64 ff ff ff    	jns    c0109b3f <vprintfmt+0x53>
                width = precision, precision = -1;
c0109bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109bde:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109be1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0109be8:	e9 52 ff ff ff       	jmp    c0109b3f <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0109bed:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0109bf0:	e9 4a ff ff ff       	jmp    c0109b3f <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0109bf5:	8b 45 14             	mov    0x14(%ebp),%eax
c0109bf8:	8d 50 04             	lea    0x4(%eax),%edx
c0109bfb:	89 55 14             	mov    %edx,0x14(%ebp)
c0109bfe:	8b 00                	mov    (%eax),%eax
c0109c00:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109c03:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109c07:	89 04 24             	mov    %eax,(%esp)
c0109c0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c0d:	ff d0                	call   *%eax
            break;
c0109c0f:	e9 a4 02 00 00       	jmp    c0109eb8 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0109c14:	8b 45 14             	mov    0x14(%ebp),%eax
c0109c17:	8d 50 04             	lea    0x4(%eax),%edx
c0109c1a:	89 55 14             	mov    %edx,0x14(%ebp)
c0109c1d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0109c1f:	85 db                	test   %ebx,%ebx
c0109c21:	79 02                	jns    c0109c25 <vprintfmt+0x139>
                err = -err;
c0109c23:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0109c25:	83 fb 06             	cmp    $0x6,%ebx
c0109c28:	7f 0b                	jg     c0109c35 <vprintfmt+0x149>
c0109c2a:	8b 34 9d 0c c2 10 c0 	mov    -0x3fef3df4(,%ebx,4),%esi
c0109c31:	85 f6                	test   %esi,%esi
c0109c33:	75 23                	jne    c0109c58 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0109c35:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0109c39:	c7 44 24 08 39 c2 10 	movl   $0xc010c239,0x8(%esp)
c0109c40:	c0 
c0109c41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109c48:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c4b:	89 04 24             	mov    %eax,(%esp)
c0109c4e:	e8 6a fe ff ff       	call   c0109abd <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0109c53:	e9 60 02 00 00       	jmp    c0109eb8 <vprintfmt+0x3cc>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0109c58:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0109c5c:	c7 44 24 08 42 c2 10 	movl   $0xc010c242,0x8(%esp)
c0109c63:	c0 
c0109c64:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c6e:	89 04 24             	mov    %eax,(%esp)
c0109c71:	e8 47 fe ff ff       	call   c0109abd <printfmt>
            }
            break;
c0109c76:	e9 3d 02 00 00       	jmp    c0109eb8 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0109c7b:	8b 45 14             	mov    0x14(%ebp),%eax
c0109c7e:	8d 50 04             	lea    0x4(%eax),%edx
c0109c81:	89 55 14             	mov    %edx,0x14(%ebp)
c0109c84:	8b 30                	mov    (%eax),%esi
c0109c86:	85 f6                	test   %esi,%esi
c0109c88:	75 05                	jne    c0109c8f <vprintfmt+0x1a3>
                p = "(null)";
c0109c8a:	be 45 c2 10 c0       	mov    $0xc010c245,%esi
            }
            if (width > 0 && padc != '-') {
c0109c8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109c93:	7e 76                	jle    c0109d0b <vprintfmt+0x21f>
c0109c95:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0109c99:	74 70                	je     c0109d0b <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109c9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ca2:	89 34 24             	mov    %esi,(%esp)
c0109ca5:	e8 f6 f7 ff ff       	call   c01094a0 <strnlen>
c0109caa:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109cad:	29 c2                	sub    %eax,%edx
c0109caf:	89 d0                	mov    %edx,%eax
c0109cb1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109cb4:	eb 16                	jmp    c0109ccc <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0109cb6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0109cba:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109cbd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109cc1:	89 04 24             	mov    %eax,(%esp)
c0109cc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cc7:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109cc9:	ff 4d e8             	decl   -0x18(%ebp)
c0109ccc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109cd0:	7f e4                	jg     c0109cb6 <vprintfmt+0x1ca>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109cd2:	eb 37                	jmp    c0109d0b <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0109cd4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0109cd8:	74 1f                	je     c0109cf9 <vprintfmt+0x20d>
c0109cda:	83 fb 1f             	cmp    $0x1f,%ebx
c0109cdd:	7e 05                	jle    c0109ce4 <vprintfmt+0x1f8>
c0109cdf:	83 fb 7e             	cmp    $0x7e,%ebx
c0109ce2:	7e 15                	jle    c0109cf9 <vprintfmt+0x20d>
                    putch('?', putdat);
c0109ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ce7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ceb:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0109cf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cf5:	ff d0                	call   *%eax
c0109cf7:	eb 0f                	jmp    c0109d08 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0109cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d00:	89 1c 24             	mov    %ebx,(%esp)
c0109d03:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d06:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109d08:	ff 4d e8             	decl   -0x18(%ebp)
c0109d0b:	89 f0                	mov    %esi,%eax
c0109d0d:	8d 70 01             	lea    0x1(%eax),%esi
c0109d10:	0f b6 00             	movzbl (%eax),%eax
c0109d13:	0f be d8             	movsbl %al,%ebx
c0109d16:	85 db                	test   %ebx,%ebx
c0109d18:	74 27                	je     c0109d41 <vprintfmt+0x255>
c0109d1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109d1e:	78 b4                	js     c0109cd4 <vprintfmt+0x1e8>
c0109d20:	ff 4d e4             	decl   -0x1c(%ebp)
c0109d23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109d27:	79 ab                	jns    c0109cd4 <vprintfmt+0x1e8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0109d29:	eb 16                	jmp    c0109d41 <vprintfmt+0x255>
                putch(' ', putdat);
c0109d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d32:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0109d39:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d3c:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0109d3e:	ff 4d e8             	decl   -0x18(%ebp)
c0109d41:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109d45:	7f e4                	jg     c0109d2b <vprintfmt+0x23f>
                putch(' ', putdat);
            }
            break;
c0109d47:	e9 6c 01 00 00       	jmp    c0109eb8 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0109d4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d53:	8d 45 14             	lea    0x14(%ebp),%eax
c0109d56:	89 04 24             	mov    %eax,(%esp)
c0109d59:	e8 18 fd ff ff       	call   c0109a76 <getint>
c0109d5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109d61:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0109d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d67:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109d6a:	85 d2                	test   %edx,%edx
c0109d6c:	79 26                	jns    c0109d94 <vprintfmt+0x2a8>
                putch('-', putdat);
c0109d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d75:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0109d7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d7f:	ff d0                	call   *%eax
                num = -(long long)num;
c0109d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d84:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109d87:	f7 d8                	neg    %eax
c0109d89:	83 d2 00             	adc    $0x0,%edx
c0109d8c:	f7 da                	neg    %edx
c0109d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109d91:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0109d94:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109d9b:	e9 a8 00 00 00       	jmp    c0109e48 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109da0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109da3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109da7:	8d 45 14             	lea    0x14(%ebp),%eax
c0109daa:	89 04 24             	mov    %eax,(%esp)
c0109dad:	e8 75 fc ff ff       	call   c0109a27 <getuint>
c0109db2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109db5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0109db8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109dbf:	e9 84 00 00 00       	jmp    c0109e48 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109dc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109dcb:	8d 45 14             	lea    0x14(%ebp),%eax
c0109dce:	89 04 24             	mov    %eax,(%esp)
c0109dd1:	e8 51 fc ff ff       	call   c0109a27 <getuint>
c0109dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109dd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0109ddc:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0109de3:	eb 63                	jmp    c0109e48 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0109de5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109de8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109dec:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0109df3:	8b 45 08             	mov    0x8(%ebp),%eax
c0109df6:	ff d0                	call   *%eax
            putch('x', putdat);
c0109df8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109dfb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109dff:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0109e06:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e09:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0109e0b:	8b 45 14             	mov    0x14(%ebp),%eax
c0109e0e:	8d 50 04             	lea    0x4(%eax),%edx
c0109e11:	89 55 14             	mov    %edx,0x14(%ebp)
c0109e14:	8b 00                	mov    (%eax),%eax
c0109e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109e19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109e20:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0109e27:	eb 1f                	jmp    c0109e48 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0109e29:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109e30:	8d 45 14             	lea    0x14(%ebp),%eax
c0109e33:	89 04 24             	mov    %eax,(%esp)
c0109e36:	e8 ec fb ff ff       	call   c0109a27 <getuint>
c0109e3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109e3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0109e41:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0109e48:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0109e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e4f:	89 54 24 18          	mov    %edx,0x18(%esp)
c0109e53:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109e56:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109e5a:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109e61:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109e64:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109e68:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109e6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109e73:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e76:	89 04 24             	mov    %eax,(%esp)
c0109e79:	e8 a4 fa ff ff       	call   c0109922 <printnum>
            break;
c0109e7e:	eb 38                	jmp    c0109eb8 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0109e80:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109e83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109e87:	89 1c 24             	mov    %ebx,(%esp)
c0109e8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e8d:	ff d0                	call   *%eax
            break;
c0109e8f:	eb 27                	jmp    c0109eb8 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0109e91:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109e94:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109e98:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0109e9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ea2:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0109ea4:	ff 4d 10             	decl   0x10(%ebp)
c0109ea7:	eb 03                	jmp    c0109eac <vprintfmt+0x3c0>
c0109ea9:	ff 4d 10             	decl   0x10(%ebp)
c0109eac:	8b 45 10             	mov    0x10(%ebp),%eax
c0109eaf:	48                   	dec    %eax
c0109eb0:	0f b6 00             	movzbl (%eax),%eax
c0109eb3:	3c 25                	cmp    $0x25,%al
c0109eb5:	75 f2                	jne    c0109ea9 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0109eb7:	90                   	nop
        }
    }
c0109eb8:	e9 37 fc ff ff       	jmp    c0109af4 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c0109ebd:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0109ebe:	83 c4 40             	add    $0x40,%esp
c0109ec1:	5b                   	pop    %ebx
c0109ec2:	5e                   	pop    %esi
c0109ec3:	5d                   	pop    %ebp
c0109ec4:	c3                   	ret    

c0109ec5 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0109ec5:	55                   	push   %ebp
c0109ec6:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ecb:	8b 40 08             	mov    0x8(%eax),%eax
c0109ece:	8d 50 01             	lea    0x1(%eax),%edx
c0109ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ed4:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0109ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109eda:	8b 10                	mov    (%eax),%edx
c0109edc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109edf:	8b 40 04             	mov    0x4(%eax),%eax
c0109ee2:	39 c2                	cmp    %eax,%edx
c0109ee4:	73 12                	jae    c0109ef8 <sprintputch+0x33>
        *b->buf ++ = ch;
c0109ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ee9:	8b 00                	mov    (%eax),%eax
c0109eeb:	8d 48 01             	lea    0x1(%eax),%ecx
c0109eee:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109ef1:	89 0a                	mov    %ecx,(%edx)
c0109ef3:	8b 55 08             	mov    0x8(%ebp),%edx
c0109ef6:	88 10                	mov    %dl,(%eax)
    }
}
c0109ef8:	90                   	nop
c0109ef9:	5d                   	pop    %ebp
c0109efa:	c3                   	ret    

c0109efb <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109efb:	55                   	push   %ebp
c0109efc:	89 e5                	mov    %esp,%ebp
c0109efe:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109f01:	8d 45 14             	lea    0x14(%ebp),%eax
c0109f04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0109f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109f0e:	8b 45 10             	mov    0x10(%ebp),%eax
c0109f11:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109f15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109f18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109f1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f1f:	89 04 24             	mov    %eax,(%esp)
c0109f22:	e8 08 00 00 00       	call   c0109f2f <vsnprintf>
c0109f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0109f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109f2d:	c9                   	leave  
c0109f2e:	c3                   	ret    

c0109f2f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109f2f:	55                   	push   %ebp
c0109f30:	89 e5                	mov    %esp,%ebp
c0109f32:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0109f35:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f38:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109f3e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109f41:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f44:	01 d0                	add    %edx,%eax
c0109f46:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109f49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0109f50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109f54:	74 0a                	je     c0109f60 <vsnprintf+0x31>
c0109f56:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f5c:	39 c2                	cmp    %eax,%edx
c0109f5e:	76 07                	jbe    c0109f67 <vsnprintf+0x38>
        return -E_INVAL;
c0109f60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0109f65:	eb 2a                	jmp    c0109f91 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0109f67:	8b 45 14             	mov    0x14(%ebp),%eax
c0109f6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109f6e:	8b 45 10             	mov    0x10(%ebp),%eax
c0109f71:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109f75:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0109f78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109f7c:	c7 04 24 c5 9e 10 c0 	movl   $0xc0109ec5,(%esp)
c0109f83:	e8 64 fb ff ff       	call   c0109aec <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0109f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f8b:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0109f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109f91:	c9                   	leave  
c0109f92:	c3                   	ret    

c0109f93 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c0109f93:	55                   	push   %ebp
c0109f94:	89 e5                	mov    %esp,%ebp
c0109f96:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c0109f99:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f9c:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c0109fa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c0109fa5:	b8 20 00 00 00       	mov    $0x20,%eax
c0109faa:	2b 45 0c             	sub    0xc(%ebp),%eax
c0109fad:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109fb0:	88 c1                	mov    %al,%cl
c0109fb2:	d3 ea                	shr    %cl,%edx
c0109fb4:	89 d0                	mov    %edx,%eax
}
c0109fb6:	c9                   	leave  
c0109fb7:	c3                   	ret    

c0109fb8 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0109fb8:	55                   	push   %ebp
c0109fb9:	89 e5                	mov    %esp,%ebp
c0109fbb:	57                   	push   %edi
c0109fbc:	56                   	push   %esi
c0109fbd:	53                   	push   %ebx
c0109fbe:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0109fc1:	a1 80 5a 12 c0       	mov    0xc0125a80,%eax
c0109fc6:	8b 15 84 5a 12 c0    	mov    0xc0125a84,%edx
c0109fcc:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109fd2:	6b f0 05             	imul   $0x5,%eax,%esi
c0109fd5:	01 fe                	add    %edi,%esi
c0109fd7:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c0109fdc:	f7 e7                	mul    %edi
c0109fde:	01 d6                	add    %edx,%esi
c0109fe0:	89 f2                	mov    %esi,%edx
c0109fe2:	83 c0 0b             	add    $0xb,%eax
c0109fe5:	83 d2 00             	adc    $0x0,%edx
c0109fe8:	89 c7                	mov    %eax,%edi
c0109fea:	83 e7 ff             	and    $0xffffffff,%edi
c0109fed:	89 f9                	mov    %edi,%ecx
c0109fef:	0f b7 da             	movzwl %dx,%ebx
c0109ff2:	89 0d 80 5a 12 c0    	mov    %ecx,0xc0125a80
c0109ff8:	89 1d 84 5a 12 c0    	mov    %ebx,0xc0125a84
    unsigned long long result = (next >> 12);
c0109ffe:	a1 80 5a 12 c0       	mov    0xc0125a80,%eax
c010a003:	8b 15 84 5a 12 c0    	mov    0xc0125a84,%edx
c010a009:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010a00d:	c1 ea 0c             	shr    $0xc,%edx
c010a010:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010a013:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c010a016:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010a01d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010a020:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010a023:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010a026:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010a029:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a02c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010a02f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010a033:	74 1c                	je     c010a051 <rand+0x99>
c010a035:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a038:	ba 00 00 00 00       	mov    $0x0,%edx
c010a03d:	f7 75 dc             	divl   -0x24(%ebp)
c010a040:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010a043:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a046:	ba 00 00 00 00       	mov    $0x0,%edx
c010a04b:	f7 75 dc             	divl   -0x24(%ebp)
c010a04e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010a051:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a054:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010a057:	f7 75 dc             	divl   -0x24(%ebp)
c010a05a:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010a05d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010a060:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a063:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010a066:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010a069:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010a06c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c010a06f:	83 c4 24             	add    $0x24,%esp
c010a072:	5b                   	pop    %ebx
c010a073:	5e                   	pop    %esi
c010a074:	5f                   	pop    %edi
c010a075:	5d                   	pop    %ebp
c010a076:	c3                   	ret    

c010a077 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c010a077:	55                   	push   %ebp
c010a078:	89 e5                	mov    %esp,%ebp
    next = seed;
c010a07a:	8b 45 08             	mov    0x8(%ebp),%eax
c010a07d:	ba 00 00 00 00       	mov    $0x0,%edx
c010a082:	a3 80 5a 12 c0       	mov    %eax,0xc0125a80
c010a087:	89 15 84 5a 12 c0    	mov    %edx,0xc0125a84
}
c010a08d:	90                   	nop
c010a08e:	5d                   	pop    %ebp
c010a08f:	c3                   	ret    

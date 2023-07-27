GFUNC ffs32cust
cpi   r22, 0
cpc   r23, 0
mov    r24, r25
// Fallthrought
ENDF ffs32cust

*/
GFUNC ffs16cust
clr    r26
cpsew_zero r24
rjmp   ffs8cust_impl
mov    r24, r25
subi   r26, -8
rjmp   ffs8cust_impl
ENDF ffs16cust

GFUNC ffs8cust
clr r26
// Fallthrough
ENDF ffs8cust

FUNC ffs8cust_impl
mov    r30, r24
ldi    r31, hi8((lutffs8))
andi   r30, 0x0f
breq   highbits
// assumes &lutffs8 % 256 < 0xf1
subi   r30, lo8(-(lutffs8))
lpm    r24, Z
add    r24, r26
ret
highbits:
mov    r30, r24
swap   r30
subi   r30, lo8(-(lutffs8))
lpm    r24, Z
subi   r24, -4
add    r24, r26
ret
ENDF ffs8cust_impl
#define	r_rem	r25	/* remainder */
#define	r_arg1	r24	/* dividend, quotient */
#define	r_arg2	r22	/* divisor */
#define	r_cnt	r23	/* loop count */
GFUNC div8gcclll
	sub	r_rem,r_rem	// clear remainder and carry
	ldi	r_cnt,8		// init loop counter
	rol	r_arg1		// shift dividend (with CARRY)
__udivmodqi4_loop:
	rol	r_rem		// shift dividend into remainder
	cp	r_rem,r_arg2	// compare remainder & divisor
	brcs	__udivmodqi4_ep	// remainder <= divisor
	sub	r_rem,r_arg2	// restore remainder
__udivmodqi4_ep:
	rol	r_arg1		// shift dividend (with CARRY)
	dec	r_cnt		// decrement loop counter
	brne	__udivmodqi4_loop
	com	r_arg1		// complement result
				// because C flag was complemented in loop
	ret
ENDF div8gcclll

GFUNC div8abc
mov     r30, r22
ldi     r31, hi8((R1H_TBL))
lpm     r25, Z
mul     r24, r25
mov     r25, r1
mul     r22, r25
sub     r24, r0
// __zero_reg__ 0xd231cb43 0x40
clr     r1
cp      r24, r22
brlo	nofixdiv8
inc     r25
sub     r24, r22
nofixdiv8:
ret
ENDF div8abc

// 24 vs 17 words
// with 64 bits: 54, 26
GFUNC popcount32cust
// uses __tmp_reg__ (r0)
call popcount8cust
mov  r0, r24
mov  r24, r25
call popcount8cust
add  r0, r24
mov  r24, r23
call popcount8cust
add  r0, r24
mov  r24, r22
call popcount8cust
add  r24, r0
ret
ENDF popcount32cust

GFUNC popcount16cust
// uses __tmp_reg__ (r0)
call popcount8cust
mov  r0, r24
mov  r24, r25
call popcount8cust
add  r24, r0
ret
ENDF popcount16cust

GFUNC popcount8cust
mov r26,r24
lsr r26
andi r26,lo8(85)
sub r24,r26
mov r26,r24
lsr r24
lsr r24
andi r24,lo8(51)
andi r26,lo8(51)
add r24,r26
mov r26,r24
swap r26
add r24,r26
andi r24,lo8(15)
ret
ENDF popcount8cust

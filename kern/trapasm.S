/*
 * Trap handler entry and exit code, written in assembly language.
 *
 * Copyright (C) 1997 Massachusetts Institute of Technology
 * See section "MIT License" in the file LICENSES for licensing terms.
 *
 * Derived from the MIT Exokernel and JOS.
 * Adapted for PIOS by Bryan Ford at Yale University.
 */

#include <inc/mmu.h>
#include <inc/trap.h>

#include <kern/cpu.h>



/* The TRAPHANDLER macro defines a globally-visible function for handling
 * a trap.  It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 */ 
 // hong:
 // in TRAPHANDLER , CPU automatically pushes an error code
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU does not push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
 // hong:
 // pushe a 0 in place of the error for the same format
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 1: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(vector0, 0)
TRAPHANDLER_NOEC(vector1, 1)
TRAPHANDLER_NOEC(vector2, 2)
TRAPHANDLER_NOEC(vector3, 3)
TRAPHANDLER_NOEC(vector4, 4)
TRAPHANDLER_NOEC(vector5, 5)
TRAPHANDLER_NOEC(vector6, 6)
TRAPHANDLER_NOEC(vector7, 7)
TRAPHANDLER(vector8, 8)
TRAPHANDLER_NOEC(vector9, 9)
TRAPHANDLER(vector10, 10)
TRAPHANDLER(vector11, 11)
TRAPHANDLER(vector12, 12)
TRAPHANDLER(vector13, 13)
TRAPHANDLER(vector14, 14)
TRAPHANDLER_NOEC(vector15, 15)
TRAPHANDLER_NOEC(vector16, 16)
TRAPHANDLER(vector17, 17)
TRAPHANDLER_NOEC(vector18, 18)
TRAPHANDLER_NOEC(vector19, 19)
TRAPHANDLER_NOEC(vector20, 20)
TRAPHANDLER_NOEC(vector21, 21)
TRAPHANDLER_NOEC(vector22, 22)
TRAPHANDLER_NOEC(vector23, 23)
TRAPHANDLER_NOEC(vector24, 24)
TRAPHANDLER_NOEC(vector25, 25)
TRAPHANDLER_NOEC(vector26, 26)
TRAPHANDLER_NOEC(vector27, 27)
TRAPHANDLER_NOEC(vector28, 28)
TRAPHANDLER_NOEC(vector29, 29)
TRAPHANDLER_NOEC(vector30, 30)

/*
 * Lab 1: Your code here for _alltraps
 */
.globl	_alltraps
_alltraps:
	# Build trap frame.
  #pushw %ds
  #pushw %ds
	#pushw %es
	#pushw %es
  pushl %ds
  pushl %es

	#pushw %ds   #pushl %fs  # ignore %fs
  #pushw %ds
  #pushw %es   #pushl %gs  # ignore %gs
  #pushw %es
	pushl %fs
  pushl %gs

	pushal

	# Set up data and per-cpu segments.
	movw $CPU_GDT_KDATA, %ax
	movw %ax, %ds
	movw %ax, %es

	# Call trap(tf), where tf=%esp
	pushl %esp
	call trap
	addl $4, %esp

//
// Trap return code.
// C code in the kernel will call this function to return from a trap,
// providing the 
// Restore the CPU state from a given trapframe struct
// and return from the trap using the processor's 'iret' instruction.
// This function does not return to the caller,
// since the new CPU state this function loads
// replaces the caller's stack pointer and other registers.
//
.globl	trap_return
.type	trap_return,@function
.p2align 4, 0x90		/* 16-byte alignment, nop filled */
trap_return:
/*
 * Lab 1: Your code here for trap_return
 */
  add $4, %esp
  movl (%esp), %esp
 	popal

  #popw %es  # ignore %gs
  #popw %es
 # popw %ds  # ignore %fs
  #popw %ds
  popl %gs
  popl %fs

  #popw %es  # popl es
 	#popw %es
  #popw %ds  # popl ds
 	#popw %ds
  popl %es
  popl %ds

 	addl $0x8, %esp		# trapno and errcode
 	iret
1:	jmp	1b		// just spin



# vector table
.data
.globl vectors
vectors:
  .long vector0
  .long vector1
  .long vector2
  .long vector3
  .long vector4
  .long vector5
  .long vector6
  .long vector7
  .long vector8
  .long vector9
  .long vector10
  .long vector11
  .long vector12
  .long vector13
  .long vector14
  .long vector15
  .long vector16
  .long vector17
  .long vector18
  .long vector19
  .long vector20
  .long vector21
  .long vector22
  .long vector23
  .long vector24
  .long vector25
  .long vector26
  .long vector27
  .long vector28
  .long vector29
  .long vector30
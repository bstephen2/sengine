;	tzcount.asm
;		part of kalulu
;		(c) 2017, Brian Stephenson
;		brian@bstephen.me.uk
;
;/**************************************************************
; *	EXECUTABLE CODE                                          *
; **************************************************************/
               
               	[section .text]
               	global		tzcount
 
;/****************************************************************
; *	PROCEDURE - tzcount(ulong)                                 *
; ****************************************************************/

				%push       maincontext
tzcount: 		equ         $
               	%stacksize  flat
               	%assign     %$localsize 0
               	%arg		lsb:dword, \
               				msb:dword
               	enter       %$localsize, 0
				mov			eax, [lsb]
				or			eax, [msb]
				jnz			tz_00
				mov			eax, 64
				jmp			tz_99
						
tz_00:			equ			$
				mov			eax, [lsb]
				or			eax, eax
				jz			tz_01
				bsf			edx, eax
				mov			eax, edx
				jmp			tz_99
						
tz_01:			equ			$
				mov			eax, [msb]
				bsf			edx, eax
				add			edx, 32
				mov			eax, edx

tz_99:			equ			$
               	leave
               	ret
               	%pop

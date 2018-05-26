; Disassembly of file: main.o
; Sat May 26 16:07:49 2018
; Mode: 64 bits
; Syntax: YASM/NASM
; Instruction set: SSE2, x64

default rel

global sound
global end_clock: function
global tzcount: function
global main: function

extern freeBoard                                        ; near
extern end_dir                                          ; near
extern time_dir                                         ; near
extern add_dir_stats                                    ; near
extern add_dir_options                                  ; near
extern __fprintf_chk                                    ; near
extern close_mem                                        ; near
extern free                                             ; near
extern add_dir_keys                                     ; near
extern add_dir_tries                                    ; near
extern freeBoardlist                                    ; near
extern add_dir_set                                      ; near
extern start_dir                                        ; near
extern solve_direct                                     ; near
extern calloc                                           ; near
extern exit                                             ; near
extern fwrite                                           ; near
extern stderr                                           ; qword
extern validate_board                                   ; near
extern setup_diagram                                    ; near
extern opt_stip                                         ; dword
extern init_mem                                         ; near
extern init                                             ; near
extern do_options                                       ; near
extern clock                                            ; near


SECTION .text   align=16 execute                        ; section number 1, code

end_clock:; Function begin
        jmp     clock                                   ; 0000 _ E9, 00000000(rel)
; end_clock End of function

        nop                                             ; 0005 _ 90
; Filling space: 0AH
; Filler type: Multi-byte NOP
;       db 66H, 2EH, 0FH, 1FH, 84H, 00H, 00H, 00H
;       db 00H, 00H

ALIGN   16

tzcount:; Function begin
        bsf     rdx, rdi                                ; 0010 _ 48: 0F BC. D7
        mov     eax, 64                                 ; 0014 _ B8, 00000040
        test    rdi, rdi                                ; 0019 _ 48: 85. FF
        cmovne  rax, rdx                                ; 001C _ 48: 0F 45. C2
        ret                                             ; 0020 _ C3
; tzcount End of function


SECTION .data   align=1 noexecute                       ; section number 2, data


SECTION .bss    align=8 noexecute                       ; section number 3, bss

prog_start:                                             ; qword
        resq    1                                       ; 0000


SECTION .text.unlikely align=1 execute                  ; section number 4, code


SECTION .rodata.str1.1 align=1 noexecute                ; section number 5, const

?_001:                                                  ; byte
        db 6DH, 61H, 69H, 6EH, 2EH, 63H, 00H            ; 0000 _ main.c.

?_002:                                                  ; byte
        db 4FH, 55H, 54H, 20H, 4FH, 46H, 20H, 4DH       ; 0007 _ OUT OF M
        db 45H, 4DH, 4FH, 52H, 59H, 20H, 61H, 74H       ; 000F _ EMORY at
        db 20H, 25H, 73H, 28H, 25H, 64H, 29H, 0AH       ; 0017 _  %s(%d).
        db 00H                                          ; 001F _ .

?_003:                                                  ; byte
        db 52H, 75H, 6EH, 6EH, 69H, 6EH, 67H, 20H       ; 0020 _ Running 
        db 54H, 69H, 6DH, 65H, 20H, 3DH, 20H, 25H       ; 0028 _ Time = %
        db 66H, 0AH, 00H                                ; 0030 _ f..


SECTION .rodata.str1.8 align=8 noexecute                ; section number 6, const

?_004:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 0000 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 43H       ; 0008 _ ERROR: C
        db 61H, 6EH, 27H, 74H, 20H, 73H, 6FH, 6CH       ; 0010 _ an't sol
        db 76H, 65H, 20H, 73H, 65H, 6CH, 66H, 6DH       ; 0018 _ ve selfm
        db 61H, 74H, 65H, 73H, 20H, 79H, 65H, 74H       ; 0020 _ ates yet
        db 21H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ !.......

?_005:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 0030 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 43H       ; 0038 _ ERROR: C
        db 61H, 6EH, 27H, 74H, 20H, 73H, 6FH, 6CH       ; 0040 _ an't sol
        db 76H, 65H, 20H, 72H, 65H, 66H, 6CH, 65H       ; 0048 _ ve refle
        db 78H, 6DH, 61H, 74H, 65H, 73H, 20H, 79H       ; 0050 _ xmates y
        db 65H, 74H, 21H, 00H, 00H, 00H, 00H, 00H       ; 0058 _ et!.....

?_006:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 0060 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 43H       ; 0068 _ ERROR: C
        db 61H, 6EH, 27H, 74H, 20H, 73H, 6FH, 6CH       ; 0070 _ an't sol
        db 76H, 65H, 20H, 68H, 65H, 6CH, 70H, 6DH       ; 0078 _ ve helpm
        db 61H, 74H, 65H, 73H, 20H, 79H, 65H, 74H       ; 0080 _ ates yet
        db 21H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0088 _ !.......

?_007:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 0090 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 69H       ; 0098 _ ERROR: i
        db 6DH, 70H, 6FH, 73H, 73H, 69H, 62H, 6CH       ; 00A0 _ mpossibl
        db 65H, 20H, 69H, 6EH, 76H, 61H, 6CH, 69H       ; 00A8 _ e invali
        db 64H, 20H, 73H, 74H, 69H, 70H, 75H, 6CH       ; 00B0 _ d stipul
        db 61H, 74H, 69H, 6FH, 6EH, 21H, 21H, 00H       ; 00B8 _ ation!!.


SECTION .text.startup align=16 execute                  ; section number 7, code

main:   ; Function begin
        push    r13                                     ; 0000 _ 41: 55
        push    r12                                     ; 0002 _ 41: 54
        push    rbp                                     ; 0004 _ 55
        mov     rbp, rsi                                ; 0005 _ 48: 89. F5
        push    rbx                                     ; 0008 _ 53
        mov     ebx, edi                                ; 0009 _ 89. FB
        sub     rsp, 8                                  ; 000B _ 48: 83. EC, 08
        call    clock                                   ; 000F _ E8, 00000000(rel)
        mov     edi, ebx                                ; 0014 _ 89. DF
        mov     rsi, rbp                                ; 0016 _ 48: 89. EE
        mov     qword [rel prog_start], rax             ; 0019 _ 48: 89. 05, 00000000(rel)
        call    do_options                              ; 0020 _ E8, 00000000(rel)
        mov     ebx, eax                                ; 0025 _ 89. C3
        test    eax, eax                                ; 0027 _ 85. C0
        jz      ?_009                                   ; 0029 _ 74, 0D
?_008:  add     rsp, 8                                  ; 002B _ 48: 83. C4, 08
        mov     eax, ebx                                ; 002F _ 89. D8
        pop     rbx                                     ; 0031 _ 5B
        pop     rbp                                     ; 0032 _ 5D
        pop     r12                                     ; 0033 _ 41: 5C
        pop     r13                                     ; 0035 _ 41: 5D
        ret                                             ; 0037 _ C3
; main End of function

?_009:  ; Local function
        call    init                                    ; 0038 _ E8, 00000000(rel)
        call    init_mem                                ; 003D _ E8, 00000000(rel)
        cmp     dword [rel opt_stip], 3                 ; 0042 _ 83. 3D, 00000000(rel), 03
        je      ?_021                                   ; 0049 _ 0F 84, 00000168
        mov     edi, 1                                  ; 004F _ BF, 00000001
        call    setup_diagram                           ; 0054 _ E8, 00000000(rel)
        mov     r12, rax                                ; 0059 _ 49: 89. C4
?_010:  mov     rdi, r12                                ; 005C _ 4C: 89. E7
        call    validate_board                          ; 005F _ E8, 00000000(rel)
        mov     ebx, eax                                ; 0064 _ 89. C3
        test    eax, eax                                ; 0066 _ 85. C0
        jne     ?_020                                   ; 0068 _ 0F 85, 00000107
        mov     eax, dword [rel opt_stip]               ; 006E _ 8B. 05, 00000000(rel)
        cmp     eax, 1                                  ; 0074 _ 83. F8, 01
        je      ?_023                                   ; 0077 _ 0F 84, 0000014E
        jc      ?_011                                   ; 007D _ 72, 37
        cmp     eax, 2                                  ; 007F _ 83. F8, 02
        je      ?_025                                   ; 0082 _ 0F 84, 0000018D
        cmp     eax, 3                                  ; 0088 _ 83. F8, 03
        jne     ?_024                                   ; 008B _ 0F 85, 0000015F
        mov     edi, ?_006                              ; 0091 _ BF, 00000000(d)
        mov     edx, 41                                 ; 0096 _ BA, 00000029
        mov     esi, 1                                  ; 009B _ BE, 00000001
        mov     rcx, qword [rel stderr]                 ; 00A0 _ 48: 8B. 0D, 00000000(rel)
        call    fwrite                                  ; 00A7 _ E8, 00000000(rel)
        mov     edi, 1                                  ; 00AC _ BF, 00000001
        call    exit                                    ; 00B1 _ E8, 00000000(rel)
?_011:  mov     esi, 48                                 ; 00B6 _ BE, 00000030
        mov     edi, 1                                  ; 00BB _ BF, 00000001
        call    calloc                                  ; 00C0 _ E8, 00000000(rel)
        mov     rbp, rax                                ; 00C5 _ 48: 89. C5
        test    rax, rax                                ; 00C8 _ 48: 85. C0
        je      ?_028                                   ; 00CB _ 0F 84, 000001BF
        mov     rdi, rax                                ; 00D1 _ 48: 89. C7
        mov     rsi, r12                                ; 00D4 _ 4C: 89. E6
        call    solve_direct                            ; 00D7 _ E8, 00000000(rel)
        call    start_dir                               ; 00DC _ E8, 00000000(rel)
        mov     rdi, qword [rbp]                        ; 00E1 _ 48: 8B. 7D, 00
        test    rdi, rdi                                ; 00E5 _ 48: 85. FF
        jz      ?_012                                   ; 00E8 _ 74, 0E
        call    add_dir_set                             ; 00EA _ E8, 00000000(rel)
        mov     rdi, qword [rbp]                        ; 00EF _ 48: 8B. 7D, 00
        call    freeBoardlist                           ; 00F3 _ E8, 00000000(rel)
?_012:  mov     rdi, qword [rbp+8H]                     ; 00F8 _ 48: 8B. 7D, 08
        test    rdi, rdi                                ; 00FC _ 48: 85. FF
        jz      ?_013                                   ; 00FF _ 74, 0E
        call    add_dir_tries                           ; 0101 _ E8, 00000000(rel)
        mov     rdi, qword [rbp+8H]                     ; 0106 _ 48: 8B. 7D, 08
        call    freeBoardlist                           ; 010A _ E8, 00000000(rel)
?_013:  mov     rdi, qword [rbp+10H]                    ; 010F _ 48: 8B. 7D, 10
        test    rdi, rdi                                ; 0113 _ 48: 85. FF
        jz      ?_014                                   ; 0116 _ 74, 0E
        call    add_dir_keys                            ; 0118 _ E8, 00000000(rel)
        mov     rdi, qword [rbp+10H]                    ; 011D _ 48: 8B. 7D, 10
        call    freeBoardlist                           ; 0121 _ E8, 00000000(rel)
?_014:  mov     rax, qword [rbp+18H]                    ; 0126 _ 48: 8B. 45, 18
        test    rax, rax                                ; 012A _ 48: 85. C0
        je      ?_027                                   ; 012D _ 0F 84, 0000010F
        mov     rdi, qword [rax]                        ; 0133 _ 48: 8B. 38
?_015:  test    rdi, rdi                                ; 0136 _ 48: 85. FF
        je      ?_026                                   ; 0139 _ 0F 84, 000000FB
        mov     rdx, qword [rax]                        ; 013F _ 48: 8B. 10
        mov     r13, qword [rdi+38H]                    ; 0142 _ 4C: 8B. 6F, 38
        cmp     rdi, rdx                                ; 0146 _ 48: 39. D7
        jnz     ?_017                                   ; 0149 _ 75, 0D
        jmp     ?_022                                   ; 014B _ EB, 79

; Filling space: 3H
; Filler type: Multi-byte NOP
;       db 0FH, 1FH, 00H

ALIGN   8
?_016:  cmp     rdi, rax                                ; 0150 _ 48: 39. C7
        jz      ?_019                                   ; 0153 _ 74, 1A
        mov     rdx, rax                                ; 0155 _ 48: 89. C2
?_017:  mov     rax, qword [rdx+38H]                    ; 0158 _ 48: 8B. 42, 38
        test    rax, rax                                ; 015C _ 48: 85. C0
        jnz     ?_016                                   ; 015F _ 75, EF
?_018:  call    free                                    ; 0161 _ E8, 00000000(rel)
        mov     rdi, r13                                ; 0166 _ 4C: 89. EF
        mov     rax, qword [rbp+18H]                    ; 0169 _ 48: 8B. 45, 18
        jmp     ?_015                                   ; 016D _ EB, C7

?_019:  mov     qword [rdx+38H], r13                    ; 016F _ 4C: 89. 6A, 38
        jmp     ?_018                                   ; 0173 _ EB, EC

?_020:  call    close_mem                               ; 0175 _ E8, 00000000(rel)
        call    clock                                   ; 017A _ E8, 00000000(rel)
        pxor    xmm0, xmm0                              ; 017F _ 66: 0F EF. C0
        mov     edx, ?_003                              ; 0183 _ BA, 00000000(d)
        sub     rax, qword [rel prog_start]             ; 0188 _ 48: 2B. 05, 00000000(rel)
        mov     rdi, qword [rel stderr]                 ; 018F _ 48: 8B. 3D, 00000000(rel)
        mov     esi, 1                                  ; 0196 _ BE, 00000001
        cvtsi2sd xmm0, rax                              ; 019B _ F2 48: 0F 2A. C0
        mov     eax, 1                                  ; 01A0 _ B8, 00000001
        divsd   xmm0, qword [rel .LC3]                  ; 01A5 _ F2: 0F 5E. 05, 00000000(rel)
        call    __fprintf_chk                           ; 01AD _ E8, 00000000(rel)
        jmp     ?_008                                   ; 01B2 _ E9, FFFFFE74

?_021:  xor     edi, edi                                ; 01B7 _ 31. FF
        call    setup_diagram                           ; 01B9 _ E8, 00000000(rel)
        mov     r12, rax                                ; 01BE _ 49: 89. C4
        jmp     ?_010                                   ; 01C1 _ E9, FFFFFE96

?_022:  mov     qword [rax], r13                        ; 01C6 _ 4C: 89. 28
        jmp     ?_018                                   ; 01C9 _ EB, 96

?_023:  mov     edi, ?_004                              ; 01CB _ BF, 00000000(d)
        mov     edx, 41                                 ; 01D0 _ BA, 00000029
        mov     esi, 1                                  ; 01D5 _ BE, 00000001
        mov     rcx, qword [rel stderr]                 ; 01DA _ 48: 8B. 0D, 00000000(rel)
        call    fwrite                                  ; 01E1 _ E8, 00000000(rel)
        mov     edi, 1                                  ; 01E6 _ BF, 00000001
        call    exit                                    ; 01EB _ E8, 00000000(rel)
?_024:  mov     edi, ?_007                              ; 01F0 _ BF, 00000000(d)
        mov     edx, 47                                 ; 01F5 _ BA, 0000002F
        mov     esi, 1                                  ; 01FA _ BE, 00000001
        mov     rcx, qword [rel stderr]                 ; 01FF _ 48: 8B. 0D, 00000000(rel)
        call    fwrite                                  ; 0206 _ E8, 00000000(rel)
        mov     edi, 1                                  ; 020B _ BF, 00000001
        call    exit                                    ; 0210 _ E8, 00000000(rel)
?_025:  mov     edi, ?_005                              ; 0215 _ BF, 00000000(d)
        mov     edx, 43                                 ; 021A _ BA, 0000002B
        mov     esi, 1                                  ; 021F _ BE, 00000001
        mov     rcx, qword [rel stderr]                 ; 0224 _ 48: 8B. 0D, 00000000(rel)
        call    fwrite                                  ; 022B _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0230 _ BF, 00000001
        call    exit                                    ; 0235 _ E8, 00000000(rel)
?_026:  mov     rdi, rax                                ; 023A _ 48: 89. C7
        call    free                                    ; 023D _ E8, 00000000(rel)
?_027:  call    add_dir_options                         ; 0242 _ E8, 00000000(rel)
        mov     rdi, rbp                                ; 0247 _ 48: 89. EF
        call    add_dir_stats                           ; 024A _ E8, 00000000(rel)
        call    clock                                   ; 024F _ E8, 00000000(rel)
        sub     rax, qword [rel prog_start]             ; 0254 _ 48: 2B. 05, 00000000(rel)
        pxor    xmm0, xmm0                              ; 025B _ 66: 0F EF. C0
        cvtsi2sd xmm0, rax                              ; 025F _ F2 48: 0F 2A. C0
        divsd   xmm0, qword [rel .LC3]                  ; 0264 _ F2: 0F 5E. 05, 00000000(rel)
        call    time_dir                                ; 026C _ E8, 00000000(rel)
        call    end_dir                                 ; 0271 _ E8, 00000000(rel)
        mov     rdi, rbp                                ; 0276 _ 48: 89. EF
        call    free                                    ; 0279 _ E8, 00000000(rel)
        mov     rdi, r12                                ; 027E _ 4C: 89. E7
        call    freeBoard                               ; 0281 _ E8, 00000000(rel)
        call    close_mem                               ; 0286 _ E8, 00000000(rel)
        jmp     ?_008                                   ; 028B _ E9, FFFFFD9B

?_028:  ; Local function
        mov     rdi, qword [rel stderr]                 ; 0290 _ 48: 8B. 3D, 00000000(rel)
        mov     r8d, 63                                 ; 0297 _ 41: B8, 0000003F
        mov     ecx, ?_001                              ; 029D _ B9, 00000000(d)
        xor     eax, eax                                ; 02A2 _ 31. C0
        mov     edx, ?_002                              ; 02A4 _ BA, 00000000(d)
        mov     esi, 1                                  ; 02A9 _ BE, 00000001
        call    __fprintf_chk                           ; 02AE _ E8, 00000000(rel)
        mov     edi, 1                                  ; 02B3 _ BF, 00000001
; Note: Function does not end with ret or jmp
        call    exit                                    ; 02B8 _ E8, 00000000(rel)


SECTION .rodata.cst8 align=8 noexecute                  ; section number 8, const

.LC3:                                                   ; qword
        dq 412E848000000000H                            ; 0000 _ 1000000.0 


SECTION .eh_frame align=8 noexecute                     ; section number 9, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 78H, 10H, 01H       ; 0008 _ .zR..x..
        db 1BH, 0CH, 07H, 08H, 90H, 01H, 00H, 00H       ; 0010 _ ........
        db 10H, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd end_clock-$-20H                              ; 0020 _ 00000000 (rel)
        dd 00000005H, 00000000H                         ; 0024 _ 5 0 
        dd 00000038H, 00000030H                         ; 002C _ 56 48 
        dd main-$-34H                                   ; 0034 _ 00000000 (rel)
        dd 000002BDH, 100E4200H                         ; 0038 _ 701 269369856 
        dd 0E42028DH, 41038C18H                         ; 0040 _ 239207053 1090751512 
        dd 0486200EH, 83280E44H                         ; 0048 _ 75898894 -2094526908 
        dd 300E4605H, 280E0A60H                         ; 0050 _ 806241797 672008800 
        dd 41200E43H, 0E42180EH                         ; 0058 _ 1092619843 239212558 
        dd 080E4210H, 00000B41H                         ; 0060 _ 135152144 2881 
        dd 00000014H, 0000006CH                         ; 0068 _ 20 108 
        dd end_clock-$-60H                              ; 0070 _ 00000000 (rel)
        dd 00000011H, 00000000H                         ; 0074 _ 17 0 
        dd 00000000H                                    ; 007C _ 0 



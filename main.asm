; Disassembly of file: main.o
; Fri May 25 17:39:39 2018
; Mode: 64 bits
; Syntax: YASM/NASM
; Instruction set: SSE2, x64

default rel

global sound
global end_clock: function
global tzcount: function
global main: function

extern __fprintf_chk                                    ; near
extern close_mem                                        ; near
extern freeBoard                                        ; near
extern free                                             ; near
extern end_dir                                          ; near
extern time_dir                                         ; near
extern add_dir_stats                                    ; near
extern add_dir_options                                  ; near
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
        push    r12                                     ; 0000 _ 41: 54
        push    rbp                                     ; 0002 _ 55
        mov     rbp, rsi                                ; 0003 _ 48: 89. F5
        push    rbx                                     ; 0006 _ 53
        mov     ebx, edi                                ; 0007 _ 89. FB
        call    clock                                   ; 0009 _ E8, 00000000(rel)
        mov     edi, ebx                                ; 000E _ 89. DF
        mov     rsi, rbp                                ; 0010 _ 48: 89. EE
        mov     qword [rel prog_start], rax             ; 0013 _ 48: 89. 05, 00000000(rel)
        call    do_options                              ; 001A _ E8, 00000000(rel)
        mov     ebx, eax                                ; 001F _ 89. C3
        test    eax, eax                                ; 0021 _ 85. C0
        jz      ?_009                                   ; 0023 _ 74, 07
?_008:  mov     eax, ebx                                ; 0025 _ 89. D8
        pop     rbx                                     ; 0027 _ 5B
        pop     rbp                                     ; 0028 _ 5D
        pop     r12                                     ; 0029 _ 41: 5C
        ret                                             ; 002B _ C3
; main End of function

?_009:  ; Local function
        call    init                                    ; 002C _ E8, 00000000(rel)
        call    init_mem                                ; 0031 _ E8, 00000000(rel)
        cmp     dword [rel opt_stip], 3                 ; 0036 _ 83. 3D, 00000000(rel), 03
        je      ?_016                                   ; 003D _ 0F 84, 00000175
        mov     edi, 1                                  ; 0043 _ BF, 00000001
        call    setup_diagram                           ; 0048 _ E8, 00000000(rel)
        mov     rbp, rax                                ; 004D _ 48: 89. C5
?_010:  mov     rdi, rbp                                ; 0050 _ 48: 89. EF
        call    validate_board                          ; 0053 _ E8, 00000000(rel)
        mov     ebx, eax                                ; 0058 _ 89. C3
        test    eax, eax                                ; 005A _ 85. C0
        jne     ?_015                                   ; 005C _ 0F 85, 00000114
        mov     eax, dword [rel opt_stip]               ; 0062 _ 8B. 05, 00000000(rel)
        cmp     eax, 1                                  ; 0068 _ 83. F8, 01
        je      ?_017                                   ; 006B _ 0F 84, 00000156
        jc      ?_011                                   ; 0071 _ 72, 37
        cmp     eax, 2                                  ; 0073 _ 83. F8, 02
        je      ?_019                                   ; 0076 _ 0F 84, 00000195
        cmp     eax, 3                                  ; 007C _ 83. F8, 03
        jne     ?_018                                   ; 007F _ 0F 85, 00000167
        mov     edi, ?_006                              ; 0085 _ BF, 00000000(d)
        mov     edx, 41                                 ; 008A _ BA, 00000029
        mov     esi, 1                                  ; 008F _ BE, 00000001
        mov     rcx, qword [rel stderr]                 ; 0094 _ 48: 8B. 0D, 00000000(rel)
        call    fwrite                                  ; 009B _ E8, 00000000(rel)
        mov     edi, 1                                  ; 00A0 _ BF, 00000001
        call    exit                                    ; 00A5 _ E8, 00000000(rel)
?_011:  mov     esi, 48                                 ; 00AA _ BE, 00000030
        mov     edi, 1                                  ; 00AF _ BF, 00000001
        call    calloc                                  ; 00B4 _ E8, 00000000(rel)
        mov     r12, rax                                ; 00B9 _ 49: 89. C4
        test    rax, rax                                ; 00BC _ 48: 85. C0
        je      ?_020                                   ; 00BF _ 0F 84, 00000171
        mov     rdi, rax                                ; 00C5 _ 48: 89. C7
        mov     rsi, rbp                                ; 00C8 _ 48: 89. EE
        call    solve_direct                            ; 00CB _ E8, 00000000(rel)
        call    start_dir                               ; 00D0 _ E8, 00000000(rel)
        mov     rdi, qword [r12]                        ; 00D5 _ 49: 8B. 3C 24
        test    rdi, rdi                                ; 00D9 _ 48: 85. FF
        jz      ?_012                                   ; 00DC _ 74, 0E
        call    add_dir_set                             ; 00DE _ E8, 00000000(rel)
        mov     rdi, qword [r12]                        ; 00E3 _ 49: 8B. 3C 24
        call    freeBoardlist                           ; 00E7 _ E8, 00000000(rel)
?_012:  mov     rdi, qword [r12+8H]                     ; 00EC _ 49: 8B. 7C 24, 08
        test    rdi, rdi                                ; 00F1 _ 48: 85. FF
        jz      ?_013                                   ; 00F4 _ 74, 0F
        call    add_dir_tries                           ; 00F6 _ E8, 00000000(rel)
        mov     rdi, qword [r12+8H]                     ; 00FB _ 49: 8B. 7C 24, 08
        call    freeBoardlist                           ; 0100 _ E8, 00000000(rel)
?_013:  mov     rdi, qword [r12+10H]                    ; 0105 _ 49: 8B. 7C 24, 10
        test    rdi, rdi                                ; 010A _ 48: 85. FF
        jz      ?_014                                   ; 010D _ 74, 0F
        call    add_dir_keys                            ; 010F _ E8, 00000000(rel)
        mov     rdi, qword [r12+10H]                    ; 0114 _ 49: 8B. 7C 24, 10
        call    freeBoardlist                           ; 0119 _ E8, 00000000(rel)
?_014:  mov     rdi, qword [r12+18H]                    ; 011E _ 49: 8B. 7C 24, 18
        call    freeBoardlist                           ; 0123 _ E8, 00000000(rel)
        call    add_dir_options                         ; 0128 _ E8, 00000000(rel)
        mov     rdi, r12                                ; 012D _ 4C: 89. E7
        call    add_dir_stats                           ; 0130 _ E8, 00000000(rel)
        call    clock                                   ; 0135 _ E8, 00000000(rel)
        sub     rax, qword [rel prog_start]             ; 013A _ 48: 2B. 05, 00000000(rel)
        pxor    xmm0, xmm0                              ; 0141 _ 66: 0F EF. C0
        cvtsi2sd xmm0, rax                              ; 0145 _ F2 48: 0F 2A. C0
        divsd   xmm0, qword [rel .LC3]                  ; 014A _ F2: 0F 5E. 05, 00000000(rel)
        call    time_dir                                ; 0152 _ E8, 00000000(rel)
        call    end_dir                                 ; 0157 _ E8, 00000000(rel)
        mov     rdi, r12                                ; 015C _ 4C: 89. E7
        call    free                                    ; 015F _ E8, 00000000(rel)
        mov     rdi, rbp                                ; 0164 _ 48: 89. EF
        call    freeBoard                               ; 0167 _ E8, 00000000(rel)
        call    close_mem                               ; 016C _ E8, 00000000(rel)
        jmp     ?_008                                   ; 0171 _ E9, FFFFFEAF

?_015:  call    close_mem                               ; 0176 _ E8, 00000000(rel)
        call    clock                                   ; 017B _ E8, 00000000(rel)
        pxor    xmm0, xmm0                              ; 0180 _ 66: 0F EF. C0
        mov     edx, ?_003                              ; 0184 _ BA, 00000000(d)
        sub     rax, qword [rel prog_start]             ; 0189 _ 48: 2B. 05, 00000000(rel)
        mov     rdi, qword [rel stderr]                 ; 0190 _ 48: 8B. 3D, 00000000(rel)
        mov     esi, 1                                  ; 0197 _ BE, 00000001
        cvtsi2sd xmm0, rax                              ; 019C _ F2 48: 0F 2A. C0
        mov     eax, 1                                  ; 01A1 _ B8, 00000001
        divsd   xmm0, qword [rel .LC3]                  ; 01A6 _ F2: 0F 5E. 05, 00000000(rel)
        call    __fprintf_chk                           ; 01AE _ E8, 00000000(rel)
        jmp     ?_008                                   ; 01B3 _ E9, FFFFFE6D

?_016:  xor     edi, edi                                ; 01B8 _ 31. FF
        call    setup_diagram                           ; 01BA _ E8, 00000000(rel)
        mov     rbp, rax                                ; 01BF _ 48: 89. C5
        jmp     ?_010                                   ; 01C2 _ E9, FFFFFE89

?_017:  mov     edi, ?_004                              ; 01C7 _ BF, 00000000(d)
        mov     edx, 41                                 ; 01CC _ BA, 00000029
        mov     esi, 1                                  ; 01D1 _ BE, 00000001
        mov     rcx, qword [rel stderr]                 ; 01D6 _ 48: 8B. 0D, 00000000(rel)
        call    fwrite                                  ; 01DD _ E8, 00000000(rel)
        mov     edi, 1                                  ; 01E2 _ BF, 00000001
        call    exit                                    ; 01E7 _ E8, 00000000(rel)
?_018:  mov     edi, ?_007                              ; 01EC _ BF, 00000000(d)
        mov     edx, 47                                 ; 01F1 _ BA, 0000002F
        mov     esi, 1                                  ; 01F6 _ BE, 00000001
        mov     rcx, qword [rel stderr]                 ; 01FB _ 48: 8B. 0D, 00000000(rel)
        call    fwrite                                  ; 0202 _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0207 _ BF, 00000001
        call    exit                                    ; 020C _ E8, 00000000(rel)
?_019:  mov     edi, ?_005                              ; 0211 _ BF, 00000000(d)
        mov     edx, 43                                 ; 0216 _ BA, 0000002B
        mov     esi, 1                                  ; 021B _ BE, 00000001
        mov     rcx, qword [rel stderr]                 ; 0220 _ 48: 8B. 0D, 00000000(rel)
        call    fwrite                                  ; 0227 _ E8, 00000000(rel)
        mov     edi, 1                                  ; 022C _ BF, 00000001
        call    exit                                    ; 0231 _ E8, 00000000(rel)
?_020:  mov     rdi, qword [rel stderr]                 ; 0236 _ 48: 8B. 3D, 00000000(rel)
        mov     r8d, 63                                 ; 023D _ 41: B8, 0000003F
        mov     ecx, ?_001                              ; 0243 _ B9, 00000000(d)
        xor     eax, eax                                ; 0248 _ 31. C0
        mov     edx, ?_002                              ; 024A _ BA, 00000000(d)
        mov     esi, 1                                  ; 024F _ BE, 00000001
        call    __fprintf_chk                           ; 0254 _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0259 _ BF, 00000001
; Note: Function does not end with ret or jmp
        call    exit                                    ; 025E _ E8, 00000000(rel)


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
        dd 00000028H, 00000030H                         ; 002C _ 40 48 
        dd main-$-34H                                   ; 0034 _ 00000000 (rel)
        dd 00000263H, 100E4200H                         ; 0038 _ 611 269369856 
        dd 0E41028CH, 44038618H                         ; 0040 _ 239141516 1141081624 
        dd 0483200EH, 180E0A61H                         ; 0048 _ 75702286 403573345 
        dd 42100E41H, 0B41080EH                         ; 0050 _ 1108348481 188811278 
        dd 00000014H, 0000005CH                         ; 0058 _ 20 92 
        dd end_clock-$-50H                              ; 0060 _ 00000000 (rel)
        dd 00000011H, 00000000H                         ; 0064 _ 17 0 
        dd 00000000H                                    ; 006C _ 0 



; Disassembly of file: main.o
; Sat May 26 13:52:12 2018
; Mode: 64 bits
; Syntax: YASM/NASM
; Instruction set: SSE2, x64

default rel

global sound
global end_clock: function
global main: function
global tzcount: function

extern fwrite                                           ; near
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
extern exit                                             ; near
extern fprintf                                          ; near
extern stderr                                           ; qword
extern calloc                                           ; near
extern validate_board                                   ; near
extern setup_diagram                                    ; near
extern opt_stip                                         ; dword
extern init_mem                                         ; near
extern init                                             ; near
extern do_options                                       ; near
extern clock                                            ; near


SECTION .text   align=1 execute                         ; section number 1, code

end_clock:; Function begin
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        call    clock                                   ; 0004 _ E8, 00000000(rel)
        mov     qword [rel prog_end], rax               ; 0009 _ 48: 89. 05, 00000000(rel)
        mov     rdx, qword [rel prog_end]               ; 0010 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel prog_start]             ; 0017 _ 48: 8B. 05, 00000000(rel)
        sub     rdx, rax                                ; 001E _ 48: 29. C2
        mov     rax, rdx                                ; 0021 _ 48: 89. D0
        pxor    xmm0, xmm0                              ; 0024 _ 66: 0F EF. C0
        cvtsi2sd xmm0, rax                              ; 0028 _ F2 48: 0F 2A. C0
        movsd   xmm1, qword [rel ?_023]                 ; 002D _ F2: 0F 10. 0D, 00000000(rel)
        divsd   xmm0, xmm1                              ; 0035 _ F2: 0F 5E. C1
        movsd   qword [rel run_time], xmm0              ; 0039 _ F2: 0F 11. 05, 00000000(rel)
        nop                                             ; 0041 _ 90
        pop     rbp                                     ; 0042 _ 5D
        ret                                             ; 0043 _ C3
; end_clock End of function

main:   ; Function begin
        push    rbp                                     ; 0044 _ 55
        mov     rbp, rsp                                ; 0045 _ 48: 89. E5
        sub     rsp, 48                                 ; 0048 _ 48: 83. EC, 30
        mov     dword [rbp-24H], edi                    ; 004C _ 89. 7D, DC
        mov     qword [rbp-30H], rsi                    ; 004F _ 48: 89. 75, D0
        call    clock                                   ; 0053 _ E8, 00000000(rel)
        mov     qword [rel prog_start], rax             ; 0058 _ 48: 89. 05, 00000000(rel)
        mov     rdx, qword [rbp-30H]                    ; 005F _ 48: 8B. 55, D0
        mov     eax, dword [rbp-24H]                    ; 0063 _ 8B. 45, DC
        mov     rsi, rdx                                ; 0066 _ 48: 89. D6
        mov     edi, eax                                ; 0069 _ 89. C7
        call    do_options                              ; 006B _ E8, 00000000(rel)
        mov     dword [rbp-14H], eax                    ; 0070 _ 89. 45, EC
        cmp     dword [rbp-14H], 0                      ; 0073 _ 83. 7D, EC, 00
        jne     ?_013                                   ; 0077 _ 0F 85, 000002B0
        call    init                                    ; 007D _ E8, 00000000(rel)
        call    init_mem                                ; 0082 _ E8, 00000000(rel)
        mov     eax, dword [rel opt_stip]               ; 0087 _ 8B. 05, 00000000(rel)
        cmp     eax, 3                                  ; 008D _ 83. F8, 03
        jnz     ?_001                                   ; 0090 _ 75, 10
        mov     edi, 0                                  ; 0092 _ BF, 00000000
        call    setup_diagram                           ; 0097 _ E8, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 009C _ 48: 89. 45, F0
        jmp     ?_002                                   ; 00A0 _ EB, 0E

?_001:  mov     edi, 1                                  ; 00A2 _ BF, 00000001
        call    setup_diagram                           ; 00A7 _ E8, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 00AC _ 48: 89. 45, F0
?_002:  mov     rax, qword [rbp-10H]                    ; 00B0 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 00B4 _ 48: 89. C7
        call    validate_board                          ; 00B7 _ E8, 00000000(rel)
        mov     dword [rbp-14H], eax                    ; 00BC _ 89. 45, EC
        cmp     dword [rbp-14H], 0                      ; 00BF _ 83. 7D, EC, 00
        jne     ?_012                                   ; 00C3 _ 0F 85, 000001FD
        mov     eax, dword [rel opt_stip]               ; 00C9 _ 8B. 05, 00000000(rel)
        cmp     eax, 1                                  ; 00CF _ 83. F8, 01
        je      ?_008                                   ; 00D2 _ 0F 84, 0000014E
        cmp     eax, 1                                  ; 00D8 _ 83. F8, 01
        jc      ?_003                                   ; 00DB _ 72, 17
        cmp     eax, 2                                  ; 00DD _ 83. F8, 02
        je      ?_009                                   ; 00E0 _ 0F 84, 00000168
        cmp     eax, 3                                  ; 00E6 _ 83. F8, 03
        je      ?_010                                   ; 00E9 _ 0F 84, 00000187
        jmp     ?_011                                   ; 00EF _ E9, 000001AA

?_003:  mov     esi, 48                                 ; 00F4 _ BE, 00000030
        mov     edi, 1                                  ; 00F9 _ BF, 00000001
        call    calloc                                  ; 00FE _ E8, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 0103 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 0107 _ 48: 83. 7D, F8, 00
        jnz     ?_004                                   ; 010C _ 75, 2D
        mov     rax, qword [rel stderr]                 ; 010E _ 48: 8B. 05, 00000000(rel)
        mov     ecx, 63                                 ; 0115 _ B9, 0000003F
        mov     edx, ?_016                              ; 011A _ BA, 00000000(d)
        mov     esi, ?_017                              ; 011F _ BE, 00000000(d)
        mov     rdi, rax                                ; 0124 _ 48: 89. C7
        mov     eax, 0                                  ; 0127 _ B8, 00000000
        call    fprintf                                 ; 012C _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0131 _ BF, 00000001
        call    exit                                    ; 0136 _ E8, 00000000(rel)
?_004:  mov     rdx, qword [rbp-10H]                    ; 013B _ 48: 8B. 55, F0
        mov     rax, qword [rbp-8H]                     ; 013F _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 0143 _ 48: 89. D6
        mov     rdi, rax                                ; 0146 _ 48: 89. C7
        call    solve_direct                            ; 0149 _ E8, 00000000(rel)
        call    start_dir                               ; 014E _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 0153 _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 0157 _ 48: 8B. 00
        test    rax, rax                                ; 015A _ 48: 85. C0
        jz      ?_005                                   ; 015D _ 74, 1E
        mov     rax, qword [rbp-8H]                     ; 015F _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 0163 _ 48: 8B. 00
        mov     rdi, rax                                ; 0166 _ 48: 89. C7
        call    add_dir_set                             ; 0169 _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 016E _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 0172 _ 48: 8B. 00
        mov     rdi, rax                                ; 0175 _ 48: 89. C7
        call    freeBoardlist                           ; 0178 _ E8, 00000000(rel)
?_005:  mov     rax, qword [rbp-8H]                     ; 017D _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 0181 _ 48: 8B. 40, 08
        test    rax, rax                                ; 0185 _ 48: 85. C0
        jz      ?_006                                   ; 0188 _ 74, 20
        mov     rax, qword [rbp-8H]                     ; 018A _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 018E _ 48: 8B. 40, 08
        mov     rdi, rax                                ; 0192 _ 48: 89. C7
        call    add_dir_tries                           ; 0195 _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 019A _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 019E _ 48: 8B. 40, 08
        mov     rdi, rax                                ; 01A2 _ 48: 89. C7
        call    freeBoardlist                           ; 01A5 _ E8, 00000000(rel)
?_006:  mov     rax, qword [rbp-8H]                     ; 01AA _ 48: 8B. 45, F8
        mov     rax, qword [rax+10H]                    ; 01AE _ 48: 8B. 40, 10
        test    rax, rax                                ; 01B2 _ 48: 85. C0
        jz      ?_007                                   ; 01B5 _ 74, 20
        mov     rax, qword [rbp-8H]                     ; 01B7 _ 48: 8B. 45, F8
        mov     rax, qword [rax+10H]                    ; 01BB _ 48: 8B. 40, 10
        mov     rdi, rax                                ; 01BF _ 48: 89. C7
        call    add_dir_keys                            ; 01C2 _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 01C7 _ 48: 8B. 45, F8
        mov     rax, qword [rax+10H]                    ; 01CB _ 48: 8B. 40, 10
        mov     rdi, rax                                ; 01CF _ 48: 89. C7
        call    freeBoardlist                           ; 01D2 _ E8, 00000000(rel)
?_007:  call    add_dir_options                         ; 01D7 _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 01DC _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 01E0 _ 48: 89. C7
        call    add_dir_stats                           ; 01E3 _ E8, 00000000(rel)
        call    end_clock                               ; 01E8 _ E8, 00000000(rel)
        mov     rax, qword [rel run_time]               ; 01ED _ 48: 8B. 05, 00000000(rel)
        movq    xmm0, rax                               ; 01F4 _ 66 48: 0F 6E. C0
        call    time_dir                                ; 01F9 _ E8, 00000000(rel)
        call    end_dir                                 ; 01FE _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 0203 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0207 _ 48: 89. C7
        call    free                                    ; 020A _ E8, 00000000(rel)
        mov     rax, qword [rbp-10H]                    ; 020F _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0213 _ 48: 89. C7
        call    freeBoard                               ; 0216 _ E8, 00000000(rel)
        nop                                             ; 021B _ 90
        call    close_mem                               ; 021C _ E8, 00000000(rel)
        jmp     ?_013                                   ; 0221 _ E9, 00000107

?_008:  mov     rax, qword [rel stderr]                 ; 0226 _ 48: 8B. 05, 00000000(rel)
        mov     rcx, rax                                ; 022D _ 48: 89. C1
        mov     edx, 41                                 ; 0230 _ BA, 00000029
        mov     esi, 1                                  ; 0235 _ BE, 00000001
        mov     edi, ?_018                              ; 023A _ BF, 00000000(d)
        call    fwrite                                  ; 023F _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0244 _ BF, 00000001
        call    exit                                    ; 0249 _ E8, 00000000(rel)
?_009:  mov     rax, qword [rel stderr]                 ; 024E _ 48: 8B. 05, 00000000(rel)
        mov     rcx, rax                                ; 0255 _ 48: 89. C1
        mov     edx, 43                                 ; 0258 _ BA, 0000002B
        mov     esi, 1                                  ; 025D _ BE, 00000001
        mov     edi, ?_019                              ; 0262 _ BF, 00000000(d)
        call    fwrite                                  ; 0267 _ E8, 00000000(rel)
        mov     edi, 1                                  ; 026C _ BF, 00000001
        call    exit                                    ; 0271 _ E8, 00000000(rel)
?_010:  mov     rax, qword [rel stderr]                 ; 0276 _ 48: 8B. 05, 00000000(rel)
        mov     rcx, rax                                ; 027D _ 48: 89. C1
        mov     edx, 41                                 ; 0280 _ BA, 00000029
        mov     esi, 1                                  ; 0285 _ BE, 00000001
        mov     edi, ?_020                              ; 028A _ BF, 00000000(d)
        call    fwrite                                  ; 028F _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0294 _ BF, 00000001
        call    exit                                    ; 0299 _ E8, 00000000(rel)
?_011:  mov     rax, qword [rel stderr]                 ; 029E _ 48: 8B. 05, 00000000(rel)
        mov     rcx, rax                                ; 02A5 _ 48: 89. C1
        mov     edx, 47                                 ; 02A8 _ BA, 0000002F
        mov     esi, 1                                  ; 02AD _ BE, 00000001
        mov     edi, ?_021                              ; 02B2 _ BF, 00000000(d)
        call    fwrite                                  ; 02B7 _ E8, 00000000(rel)
        mov     edi, 1                                  ; 02BC _ BF, 00000001
        call    exit                                    ; 02C1 _ E8, 00000000(rel)
?_012:  call    close_mem                               ; 02C6 _ E8, 00000000(rel)
        call    clock                                   ; 02CB _ E8, 00000000(rel)
        mov     qword [rel prog_end], rax               ; 02D0 _ 48: 89. 05, 00000000(rel)
        mov     rdx, qword [rel prog_end]               ; 02D7 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel prog_start]             ; 02DE _ 48: 8B. 05, 00000000(rel)
        sub     rdx, rax                                ; 02E5 _ 48: 29. C2
        mov     rax, rdx                                ; 02E8 _ 48: 89. D0
        pxor    xmm0, xmm0                              ; 02EB _ 66: 0F EF. C0
        cvtsi2sd xmm0, rax                              ; 02EF _ F2 48: 0F 2A. C0
        movsd   xmm1, qword [rel ?_023]                 ; 02F4 _ F2: 0F 10. 0D, 00000000(rel)
        divsd   xmm0, xmm1                              ; 02FC _ F2: 0F 5E. C1
        movsd   qword [rel run_time], xmm0              ; 0300 _ F2: 0F 11. 05, 00000000(rel)
        mov     rdx, qword [rel run_time]               ; 0308 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel stderr]                 ; 030F _ 48: 8B. 05, 00000000(rel)
        movq    xmm0, rdx                               ; 0316 _ 66 48: 0F 6E. C2
        mov     esi, ?_022                              ; 031B _ BE, 00000000(d)
        mov     rdi, rax                                ; 0320 _ 48: 89. C7
        mov     eax, 1                                  ; 0323 _ B8, 00000001
        call    fprintf                                 ; 0328 _ E8, 00000000(rel)
?_013:  mov     eax, dword [rbp-14H]                    ; 032D _ 8B. 45, EC
        leave                                           ; 0330 _ C9
        ret                                             ; 0331 _ C3
; main End of function

tzcount:; Function begin
        push    rbp                                     ; 0332 _ 55
        mov     rbp, rsp                                ; 0333 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0336 _ 48: 89. 7D, F8
        cmp     qword [rbp-8H], 0                       ; 033A _ 48: 83. 7D, F8, 00
        jnz     ?_014                                   ; 033F _ 75, 07
        mov     eax, 64                                 ; 0341 _ B8, 00000040
        jmp     ?_015                                   ; 0346 _ EB, 05

?_014:  bsf     rax, qword [rbp-8H]                     ; 0348 _ 48: 0F BC. 45, F8
?_015:  pop     rbp                                     ; 034D _ 5D
        ret                                             ; 034E _ C3
; tzcount End of function


SECTION .data   align=1 noexecute                       ; section number 2, data


SECTION .bss    align=8 noexecute                       ; section number 3, bss

prog_start:                                             ; qword
        resq    1                                       ; 0000

prog_end: resq  1                                       ; 0008

run_time: resq  1                                       ; 0010


SECTION .rodata align=8 noexecute                       ; section number 4, const

?_016:                                                  ; byte
        db 6DH, 61H, 69H, 6EH, 2EH, 63H, 00H            ; 0000 _ main.c.

?_017:                                                  ; byte
        db 4FH, 55H, 54H, 20H, 4FH, 46H, 20H, 4DH       ; 0007 _ OUT OF M
        db 45H, 4DH, 4FH, 52H, 59H, 20H, 61H, 74H       ; 000F _ EMORY at
        db 20H, 25H, 73H, 28H, 25H, 64H, 29H, 0AH       ; 0017 _  %s(%d).
        db 00H                                          ; 001F _ .

?_018:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 0020 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 43H       ; 0028 _ ERROR: C
        db 61H, 6EH, 27H, 74H, 20H, 73H, 6FH, 6CH       ; 0030 _ an't sol
        db 76H, 65H, 20H, 73H, 65H, 6CH, 66H, 6DH       ; 0038 _ ve selfm
        db 61H, 74H, 65H, 73H, 20H, 79H, 65H, 74H       ; 0040 _ ates yet
        db 21H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0048 _ !.......

?_019:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 0050 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 43H       ; 0058 _ ERROR: C
        db 61H, 6EH, 27H, 74H, 20H, 73H, 6FH, 6CH       ; 0060 _ an't sol
        db 76H, 65H, 20H, 72H, 65H, 66H, 6CH, 65H       ; 0068 _ ve refle
        db 78H, 6DH, 61H, 74H, 65H, 73H, 20H, 79H       ; 0070 _ xmates y
        db 65H, 74H, 21H, 00H, 00H, 00H, 00H, 00H       ; 0078 _ et!.....

?_020:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 0080 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 43H       ; 0088 _ ERROR: C
        db 61H, 6EH, 27H, 74H, 20H, 73H, 6FH, 6CH       ; 0090 _ an't sol
        db 76H, 65H, 20H, 68H, 65H, 6CH, 70H, 6DH       ; 0098 _ ve helpm
        db 61H, 74H, 65H, 73H, 20H, 79H, 65H, 74H       ; 00A0 _ ates yet
        db 21H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00A8 _ !.......

?_021:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 00B0 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 69H       ; 00B8 _ ERROR: i
        db 6DH, 70H, 6FH, 73H, 73H, 69H, 62H, 6CH       ; 00C0 _ mpossibl
        db 65H, 20H, 69H, 6EH, 76H, 61H, 6CH, 69H       ; 00C8 _ e invali
        db 64H, 20H, 73H, 74H, 69H, 70H, 75H, 6CH       ; 00D0 _ d stipul
        db 61H, 74H, 69H, 6FH, 6EH, 21H, 21H, 00H       ; 00D8 _ ation!!.

?_022:                                                  ; byte
        db 52H, 75H, 6EH, 6EH, 69H, 6EH, 67H, 20H       ; 00E0 _ Running 
        db 54H, 69H, 6DH, 65H, 20H, 3DH, 20H, 25H       ; 00E8 _ Time = %
        db 66H, 0AH, 00H, 00H, 00H, 00H, 00H, 00H       ; 00F0 _ f.......

?_023:  dq 412E848000000000H                            ; 00F8 _ 1000000.0 


SECTION .eh_frame align=8 noexecute                     ; section number 5, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 78H, 10H, 01H       ; 0008 _ .zR..x..
        db 1BH, 0CH, 07H, 08H, 90H, 01H, 00H, 00H       ; 0010 _ ........
        db 1CH, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd end_clock-$-20H                              ; 0020 _ 00000000 (rel)
        dd 00000044H, 100E4100H                         ; 0024 _ 68 269369600 
        dd 0D430286H, 070C7F06H                         ; 002C _ 222495366 118259462 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd end_clock-$+4H                               ; 0040 _ 00000000 (rel)
        dd 000002EEH, 100E4100H                         ; 0044 _ 750 269369600 
        dd 0D430286H, 02E90306H                         ; 004C _ 222495366 48825094 
        dd 0008070CH, 0000001CH                         ; 0054 _ 526092 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd end_clock-$+2D2H                             ; 0060 _ 00000000 (rel)
        dd 0000001DH, 100E4100H                         ; 0064 _ 29 269369600 
        dd 0D430286H, 070C5806H                         ; 006C _ 222495366 118249478 
        dd 00000008H                                    ; 0074 _ 8 


; Error: Relocation number 1 has a non-existing source address. Section: 0 Offset: 00000006H
; Error: Relocation number 2 has a non-existing source address. Section: 0 Offset: 00000006H
; Error: Relocation number 3 has a non-existing source address. Section: 0 Offset: 0000000CH
; Error: Relocation number 4 has a non-existing source address. Section: 0 Offset: 00000010H
; Error: Relocation number 5 has a non-existing source address. Section: 0 Offset: 00000011H
; Error: Relocation number 6 has a non-existing source address. Section: 0 Offset: 00000015H
; Error: Relocation number 7 has a non-existing source address. Section: 0 Offset: 00000019H
; Error: Relocation number 8 has a non-existing source address. Section: 0 Offset: 00000029H
; Error: Relocation number 9 has a non-existing source address. Section: 0 Offset: 0000002EH
; Error: Relocation number 10 has a non-existing source address. Section: 0 Offset: 0000003BH
; Error: Relocation number 11 has a non-existing source address. Section: 0 Offset: 00000042H
; Error: Relocation number 12 has a non-existing source address. Section: 0 Offset: 00000049H
; Error: Relocation number 13 has a non-existing source address. Section: 0 Offset: 00000050H
; Error: Relocation number 14 has a non-existing source address. Section: 0 Offset: 00000057H
; Error: Relocation number 15 has a non-existing source address. Section: 0 Offset: 0000005EH
; Error: Relocation number 16 has a non-existing source address. Section: 0 Offset: 0000006CH
; Error: Relocation number 17 has a non-existing source address. Section: 0 Offset: 00000071H
; Error: Relocation number 18 has a non-existing source address. Section: 0 Offset: 0000007CH
; Error: Relocation number 19 has a non-existing source address. Section: 0 Offset: 00000089H
; Error: Relocation number 20 has a non-existing source address. Section: 0 Offset: 0000008EH
; Error: Relocation number 21 has a non-existing source address. Section: 0 Offset: 000000A3H
; Error: Relocation number 22 has a non-existing source address. Section: 0 Offset: 000000A8H
; Error: Relocation number 23 has a non-existing source address. Section: 0 Offset: 000000B4H
; Error: Relocation number 24 has a non-existing source address. Section: 0 Offset: 000000C0H
; Error: Relocation number 25 has a non-existing source address. Section: 0 Offset: 000000CCH
; Error: Relocation number 26 has a non-existing source address. Section: 0 Offset: 000000D2H
; Error: Relocation number 27 has a non-existing source address. Section: 0 Offset: 000000D8H
; Error: Relocation number 28 has a non-existing source address. Section: 0 Offset: 000000E4H
; Error: Relocation number 29 has a non-existing source address. Section: 0 Offset: 000000F0H
; Error: Relocation number 30 has a non-existing source address. Section: 0 Offset: 000000FCH
; Error: Relocation number 31 has a non-existing source address. Section: 0 Offset: 00000108H
; Error: Relocation number 32 has a non-existing source address. Section: 0 Offset: 00000114H
; Error: Relocation number 33 has a non-existing source address. Section: 0 Offset: 00000120H
; Error: Relocation number 34 has a non-existing source address. Section: 0 Offset: 0000012DH
; Error: Relocation number 35 has a non-existing source address. Section: 0 Offset: 0000013AH
; Error: Relocation number 36 has a non-existing source address. Section: 0 Offset: 00000147H
; Error: Relocation number 37 has a non-existing source address. Section: 0 Offset: 00000154H
; Error: Relocation number 38 has a non-existing source address. Section: 0 Offset: 00000161H
; Error: Relocation number 39 has a non-existing source address. Section: 0 Offset: 0000016EH
; Error: Relocation number 40 has a non-existing source address. Section: 0 Offset: 0000017BH
; Error: Relocation number 41 has a non-existing source address. Section: 0 Offset: 00000188H
; Error: Relocation number 42 has a non-existing source address. Section: 0 Offset: 00000195H
; Error: Relocation number 43 has a non-existing source address. Section: 0 Offset: 000001A2H
; Error: Relocation number 44 has a non-existing source address. Section: 0 Offset: 000001AFH
; Error: Relocation number 45 has a non-existing source address. Section: 0 Offset: 000001BCH
; Error: Relocation number 46 has a non-existing source address. Section: 0 Offset: 000001C9H
; Error: Relocation number 47 has a non-existing source address. Section: 0 Offset: 000001D6H
; Error: Relocation number 48 has a non-existing source address. Section: 0 Offset: 000001E3H
; Error: Relocation number 49 has a non-existing source address. Section: 0 Offset: 000001F0H
; Error: Relocation number 50 has a non-existing source address. Section: 0 Offset: 000001FDH
; Error: Relocation number 51 has a non-existing source address. Section: 0 Offset: 0000020AH
; Error: Relocation number 52 has a non-existing source address. Section: 0 Offset: 00000217H
; Error: Relocation number 53 has a non-existing source address. Section: 0 Offset: 00000225H
; Error: Relocation number 54 has a non-existing source address. Section: 0 Offset: 0000022CH
; Error: Relocation number 55 has a non-existing source address. Section: 0 Offset: 00000238H
; Error: Relocation number 56 has a non-existing source address. Section: 0 Offset: 00000244H
; Error: Relocation number 57 has a non-existing source address. Section: 0 Offset: 00000250H
; Error: Relocation number 58 has a non-existing source address. Section: 0 Offset: 00000291H
; Error: Relocation number 59 has a non-existing source address. Section: 0 Offset: 00000296H
; Error: Relocation number 60 has a non-existing source address. Section: 0 Offset: 000002A3H
; Error: Relocation number 61 has a non-existing source address. Section: 0 Offset: 000002A8H
; Error: Relocation number 62 has a non-existing source address. Section: 0 Offset: 000002B3H
; Error: Relocation number 63 has a non-existing source address. Section: 0 Offset: 000002C3H
; Error: Relocation number 64 has a non-existing source address. Section: 0 Offset: 000002C9H
; Error: Relocation number 65 has a non-existing source address. Section: 0 Offset: 000002CFH
; Error: Relocation number 66 has a non-existing source address. Section: 0 Offset: 000002D5H
; Error: Relocation number 67 has a non-existing source address. Section: 0 Offset: 000002DCH
; Error: Relocation number 68 has a non-existing source address. Section: 0 Offset: 000002ECH
; Error: Relocation number 69 has a non-existing source address. Section: 0 Offset: 000002F2H
; Error: Relocation number 70 has a non-existing source address. Section: 0 Offset: 000002F9H
; Error: Relocation number 71 has a non-existing source address. Section: 0 Offset: 00000309H
; Error: Relocation number 72 has a non-existing source address. Section: 0 Offset: 0000030FH
; Error: Relocation number 73 has a non-existing source address. Section: 0 Offset: 00000315H
; Error: Relocation number 74 has a non-existing source address. Section: 0 Offset: 0000031BH
; Error: Relocation number 75 has a non-existing source address. Section: 0 Offset: 00000321H
; Error: Relocation number 76 has a non-existing source address. Section: 0 Offset: 00000327H
; Error: Relocation number 77 has a non-existing source address. Section: 0 Offset: 0000032DH
; Error: Relocation number 78 has a non-existing source address. Section: 0 Offset: 00000333H
; Error: Relocation number 79 has a non-existing source address. Section: 0 Offset: 0000033AH
; Error: Relocation number 80 has a non-existing source address. Section: 0 Offset: 0000034AH
; Error: Relocation number 81 has a non-existing source address. Section: 0 Offset: 00000350H
; Error: Relocation number 82 has a non-existing source address. Section: 0 Offset: 00000356H
; Error: Relocation number 83 has a non-existing source address. Section: 0 Offset: 0000035CH
; Error: Relocation number 84 has a non-existing source address. Section: 0 Offset: 00000362H
; Error: Relocation number 85 has a non-existing source address. Section: 0 Offset: 00000368H
; Error: Relocation number 86 has a non-existing source address. Section: 0 Offset: 0000036FH
; Error: Relocation number 87 has a non-existing source address. Section: 0 Offset: 0000037CH
; Error: Relocation number 88 has a non-existing source address. Section: 0 Offset: 00000381H
; Error: Relocation number 89 has a non-existing source address. Section: 0 Offset: 0000038DH
; Error: Relocation number 90 has a non-existing source address. Section: 0 Offset: 00000399H
; Error: Relocation number 91 has a non-existing source address. Section: 0 Offset: 000003A5H
; Error: Relocation number 92 has a non-existing source address. Section: 0 Offset: 000003D8H
; Error: Relocation number 93 has a non-existing source address. Section: 0 Offset: 000003E3H
; Error: Relocation number 94 has a non-existing source address. Section: 0 Offset: 000003EFH
; Error: Relocation number 95 has a non-existing source address. Section: 0 Offset: 000003FBH
; Error: Relocation number 96 has a non-existing source address. Section: 0 Offset: 00000407H
; Error: Relocation number 97 has a non-existing source address. Section: 0 Offset: 00000413H
; Error: Relocation number 98 has a non-existing source address. Section: 0 Offset: 0000041FH
; Error: Relocation number 99 has a non-existing source address. Section: 0 Offset: 0000042BH
; Error: Relocation number 100 has a non-existing source address. Section: 0 Offset: 00000437H
; Error: Relocation number 101 has a non-existing source address. Section: 0 Offset: 00000443H
; Error: Relocation number 102 has a non-existing source address. Section: 0 Offset: 0000044FH
; Error: Relocation number 103 has a non-existing source address. Section: 0 Offset: 0000045CH
; Error: Relocation number 104 has a non-existing source address. Section: 0 Offset: 00000474H
; Error: Relocation number 105 has a non-existing source address. Section: 0 Offset: 00000480H
; Error: Relocation number 106 has a non-existing source address. Section: 0 Offset: 00000498H
; Error: Relocation number 107 has a non-existing source address. Section: 0 Offset: 000004A4H
; Error: Relocation number 108 has a non-existing source address. Section: 0 Offset: 000004B0H
; Error: Relocation number 109 has a non-existing source address. Section: 0 Offset: 000004C7H
; Error: Relocation number 110 has a non-existing source address. Section: 0 Offset: 000004D3H
; Error: Relocation number 111 has a non-existing source address. Section: 0 Offset: 000004DFH
; Error: Relocation number 112 has a non-existing source address. Section: 0 Offset: 000004EBH
; Error: Relocation number 113 has a non-existing source address. Section: 0 Offset: 0000050EH
; Error: Relocation number 114 has a non-existing source address. Section: 0 Offset: 0000051AH
; Error: Relocation number 115 has a non-existing source address. Section: 0 Offset: 00000526H
; Error: Relocation number 116 has a non-existing source address. Section: 0 Offset: 00000532H
; Error: Relocation number 117 has a non-existing source address. Section: 0 Offset: 0000053EH
; Error: Relocation number 118 has a non-existing source address. Section: 0 Offset: 00000551H
; Error: Relocation number 119 has a non-existing source address. Section: 0 Offset: 00000578H
; Error: Relocation number 120 has a non-existing source address. Section: 0 Offset: 00000583H
; Error: Relocation number 121 has a non-existing source address. Section: 0 Offset: 0000059BH
; Error: Relocation number 122 has a non-existing source address. Section: 0 Offset: 000005A7H
; Error: Relocation number 123 has a non-existing source address. Section: 0 Offset: 000005B3H
; Error: Relocation number 124 has a non-existing source address. Section: 0 Offset: 000005BFH
; Error: Relocation number 125 has a non-existing source address. Section: 0 Offset: 000005CBH
; Error: Relocation number 126 has a non-existing source address. Section: 0 Offset: 000005D7H
; Error: Relocation number 127 has a non-existing source address. Section: 0 Offset: 000005E4H
; Error: Relocation number 128 has a non-existing source address. Section: 0 Offset: 000005EFH
; Error: Relocation number 129 has a non-existing source address. Section: 0 Offset: 000005F5H
; Error: Relocation number 130 has a non-existing source address. Section: 0 Offset: 00000608H
; Error: Relocation number 131 has a non-existing source address. Section: 0 Offset: 00000612H
; Error: Relocation number 132 has a non-existing source address. Section: 0 Offset: 00000629H
; Error: Relocation number 133 has a non-existing source address. Section: 0 Offset: 00000637H
; Error: Relocation number 134 has a non-existing source address. Section: 0 Offset: 00000652H
; Error: Relocation number 135 has a non-existing source address. Section: 0 Offset: 00000663H
; Error: Relocation number 136 has a non-existing source address. Section: 0 Offset: 00000671H
; Error: Relocation number 137 has a non-existing source address. Section: 0 Offset: 00000682H
; Error: Relocation number 138 has a non-existing source address. Section: 0 Offset: 000006A5H
; Error: Relocation number 139 has a non-existing source address. Section: 0 Offset: 000006AFH
; Error: Relocation number 140 has a non-existing source address. Section: 0 Offset: 000006C6H
; Error: Relocation number 141 has a non-existing source address. Section: 0 Offset: 000006D5H
; Error: Relocation number 142 has a non-existing source address. Section: 0 Offset: 000006E1H
; Error: Relocation number 143 has a non-existing source address. Section: 0 Offset: 000006EAH
; Error: Relocation number 144 has a non-existing source address. Section: 0 Offset: 000006F6H
; Error: Relocation number 145 has a non-existing source address. Section: 0 Offset: 000006FFH
; Error: Relocation number 146 has a non-existing source address. Section: 0 Offset: 0000070BH
; Error: Relocation number 147 has a non-existing source address. Section: 0 Offset: 00000716H
; Error: Relocation number 148 has a non-existing source address. Section: 0 Offset: 0000071BH
; Error: Relocation number 149 has a non-existing source address. Section: 0 Offset: 00000726H
; Error: Relocation number 150 has a non-existing source address. Section: 0 Offset: 00000731H
; Error: Relocation number 151 has a non-existing source address. Section: 0 Offset: 0000073DH


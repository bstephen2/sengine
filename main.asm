; Disassembly of file: main.o
; Mon May 28 08:52:23 2018
; Mode: 64 bits
; Syntax: YASM/NASM
; Instruction set: SSE2, x64

default rel

global sound
global end_clock: function
global main: function

extern freeBoard                                        ; near
extern end_dir                                          ; near
extern time_dir                                         ; near
extern add_dir_stats                                    ; near
extern add_dir_options                                  ; near
extern free                                             ; near
extern add_dir_keys                                     ; near
extern add_dir_tries                                    ; near
extern freeBoardlist                                    ; near
extern add_dir_set                                      ; near
extern start_dir                                        ; near
extern solve_direct                                     ; near
extern calloc                                           ; near
extern fprintf                                          ; near
extern close_mem                                        ; near
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
        movsd   xmm1, qword [rel ?_031]                 ; 002D _ F2: 0F 10. 0D, 00000000(rel)
        divsd   xmm0, xmm1                              ; 0035 _ F2: 0F 5E. C1
        movsd   qword [rel run_time], xmm0              ; 0039 _ F2: 0F 11. 05, 00000000(rel)
        nop                                             ; 0041 _ 90
        pop     rbp                                     ; 0042 _ 5D
        ret                                             ; 0043 _ C3
; end_clock End of function

main:   ; Function begin
        push    rbp                                     ; 0044 _ 55
        mov     rbp, rsp                                ; 0045 _ 48: 89. E5
        sub     rsp, 32                                 ; 0048 _ 48: 83. EC, 20
        mov     dword [rbp-14H], edi                    ; 004C _ 89. 7D, EC
        mov     qword [rbp-20H], rsi                    ; 004F _ 48: 89. 75, E0
        call    clock                                   ; 0053 _ E8, 00000000(rel)
        mov     qword [rel prog_start], rax             ; 0058 _ 48: 89. 05, 00000000(rel)
        mov     rdx, qword [rbp-20H]                    ; 005F _ 48: 8B. 55, E0
        mov     eax, dword [rbp-14H]                    ; 0063 _ 8B. 45, EC
        mov     rsi, rdx                                ; 0066 _ 48: 89. D6
        mov     edi, eax                                ; 0069 _ 89. C7
        call    do_options                              ; 006B _ E8, 00000000(rel)
        mov     dword [rbp-0CH], eax                    ; 0070 _ 89. 45, F4
        cmp     dword [rbp-0CH], 0                      ; 0073 _ 83. 7D, F4, 00
        jne     ?_010                                   ; 0077 _ 0F 85, 00000136
        call    init                                    ; 007D _ E8, 00000000(rel)
        call    init_mem                                ; 0082 _ E8, 00000000(rel)
        mov     eax, dword [rel opt_stip]               ; 0087 _ 8B. 05, 00000000(rel)
        cmp     eax, 3                                  ; 008D _ 83. F8, 03
        jnz     ?_001                                   ; 0090 _ 75, 10
        mov     edi, 0                                  ; 0092 _ BF, 00000000
        call    setup_diagram                           ; 0097 _ E8, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 009C _ 48: 89. 45, F8
        jmp     ?_002                                   ; 00A0 _ EB, 0E

?_001:  mov     edi, 1                                  ; 00A2 _ BF, 00000001
        call    setup_diagram                           ; 00A7 _ E8, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 00AC _ 48: 89. 45, F8
?_002:  mov     rax, qword [rbp-8H]                     ; 00B0 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 00B4 _ 48: 89. C7
        call    validate_board                          ; 00B7 _ E8, 00000000(rel)
        mov     dword [rbp-0CH], eax                    ; 00BC _ 89. 45, F4
        cmp     dword [rbp-0CH], 0                      ; 00BF _ 83. 7D, F4, 00
        jne     ?_009                                   ; 00C3 _ 0F 85, 00000083
        mov     eax, dword [rel opt_stip]               ; 00C9 _ 8B. 05, 00000000(rel)
        cmp     eax, 1                                  ; 00CF _ 83. F8, 01
        jz      ?_004                                   ; 00D2 _ 74, 1F
        cmp     eax, 1                                  ; 00D4 _ 83. F8, 01
        jc      ?_003                                   ; 00D7 _ 72, 0C
        cmp     eax, 2                                  ; 00D9 _ 83. F8, 02
        jz      ?_005                                   ; 00DC _ 74, 23
        cmp     eax, 3                                  ; 00DE _ 83. F8, 03
        jz      ?_006                                   ; 00E1 _ 74, 2C
        jmp     ?_007                                   ; 00E3 _ EB, 38

?_003:  mov     rax, qword [rbp-8H]                     ; 00E5 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 00E9 _ 48: 89. C7
        call    do_direct                               ; 00EC _ E8, 000000C7
        jmp     ?_008                                   ; 00F1 _ EB, 52

?_004:  mov     rax, qword [rbp-8H]                     ; 00F3 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 00F7 _ 48: 89. C7
        call    do_self                                 ; 00FA _ E8, 000002D6
        jmp     ?_008                                   ; 00FF _ EB, 44

?_005:  mov     rax, qword [rbp-8H]                     ; 0101 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0105 _ 48: 89. C7
        call    do_reflex                               ; 0108 _ E8, 00000330
        jmp     ?_008                                   ; 010D _ EB, 36

?_006:  mov     rax, qword [rbp-8H]                     ; 010F _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0113 _ 48: 89. C7
        call    do_help                                 ; 0116 _ E8, 000002EE
        jmp     ?_008                                   ; 011B _ EB, 28

?_007:  mov     rax, qword [rel stderr]                 ; 011D _ 48: 8B. 05, 00000000(rel)
        mov     rcx, rax                                ; 0124 _ 48: 89. C1
        mov     edx, 47                                 ; 0127 _ BA, 0000002F
        mov     esi, 1                                  ; 012C _ BE, 00000001
        mov     edi, ?_024                              ; 0131 _ BF, 00000000(d)
        call    fwrite                                  ; 0136 _ E8, 00000000(rel)
        mov     edi, 1                                  ; 013B _ BF, 00000001
        call    exit                                    ; 0140 _ E8, 00000000(rel)
?_008:  call    close_mem                               ; 0145 _ E8, 00000000(rel)
        jmp     ?_010                                   ; 014A _ EB, 67

?_009:  call    close_mem                               ; 014C _ E8, 00000000(rel)
        call    clock                                   ; 0151 _ E8, 00000000(rel)
        mov     qword [rel prog_end], rax               ; 0156 _ 48: 89. 05, 00000000(rel)
        mov     rdx, qword [rel prog_end]               ; 015D _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel prog_start]             ; 0164 _ 48: 8B. 05, 00000000(rel)
        sub     rdx, rax                                ; 016B _ 48: 29. C2
        mov     rax, rdx                                ; 016E _ 48: 89. D0
        pxor    xmm0, xmm0                              ; 0171 _ 66: 0F EF. C0
        cvtsi2sd xmm0, rax                              ; 0175 _ F2 48: 0F 2A. C0
        movsd   xmm1, qword [rel ?_031]                 ; 017A _ F2: 0F 10. 0D, 00000000(rel)
        divsd   xmm0, xmm1                              ; 0182 _ F2: 0F 5E. C1
        movsd   qword [rel run_time], xmm0              ; 0186 _ F2: 0F 11. 05, 00000000(rel)
        mov     rdx, qword [rel run_time]               ; 018E _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel stderr]                 ; 0195 _ 48: 8B. 05, 00000000(rel)
        movq    xmm0, rdx                               ; 019C _ 66 48: 0F 6E. C2
        mov     esi, ?_025                              ; 01A1 _ BE, 00000000(d)
        mov     rdi, rax                                ; 01A6 _ 48: 89. C7
        mov     eax, 1                                  ; 01A9 _ B8, 00000001
        call    fprintf                                 ; 01AE _ E8, 00000000(rel)
?_010:  mov     eax, dword [rbp-0CH]                    ; 01B3 _ 8B. 45, F4
        leave                                           ; 01B6 _ C9
        ret                                             ; 01B7 _ C3
; main End of function

do_direct:; Local function
        push    rbp                                     ; 01B8 _ 55
        mov     rbp, rsp                                ; 01B9 _ 48: 89. E5
        sub     rsp, 48                                 ; 01BC _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 01C0 _ 48: 89. 7D, D8
        mov     esi, 48                                 ; 01C4 _ BE, 00000030
        mov     edi, 1                                  ; 01C9 _ BF, 00000001
        call    calloc                                  ; 01CE _ E8, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 01D3 _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 01D7 _ 48: 83. 7D, F0, 00
        jnz     ?_011                                   ; 01DC _ 75, 2D
        mov     rax, qword [rel stderr]                 ; 01DE _ 48: 8B. 05, 00000000(rel)
        mov     ecx, 98                                 ; 01E5 _ B9, 00000062
        mov     edx, ?_026                              ; 01EA _ BA, 00000000(d)
        mov     esi, ?_027                              ; 01EF _ BE, 00000000(d)
        mov     rdi, rax                                ; 01F4 _ 48: 89. C7
        mov     eax, 0                                  ; 01F7 _ B8, 00000000
        call    fprintf                                 ; 01FC _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0201 _ BF, 00000001
        call    exit                                    ; 0206 _ E8, 00000000(rel)
?_011:  mov     rdx, qword [rbp-28H]                    ; 020B _ 48: 8B. 55, D8
        mov     rax, qword [rbp-10H]                    ; 020F _ 48: 8B. 45, F0
        mov     rsi, rdx                                ; 0213 _ 48: 89. D6
        mov     rdi, rax                                ; 0216 _ 48: 89. C7
        call    solve_direct                            ; 0219 _ E8, 00000000(rel)
        call    start_dir                               ; 021E _ E8, 00000000(rel)
        mov     rax, qword [rbp-10H]                    ; 0223 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0227 _ 48: 8B. 00
        test    rax, rax                                ; 022A _ 48: 85. C0
        jz      ?_012                                   ; 022D _ 74, 1E
        mov     rax, qword [rbp-10H]                    ; 022F _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0233 _ 48: 8B. 00
        mov     rdi, rax                                ; 0236 _ 48: 89. C7
        call    add_dir_set                             ; 0239 _ E8, 00000000(rel)
        mov     rax, qword [rbp-10H]                    ; 023E _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0242 _ 48: 8B. 00
        mov     rdi, rax                                ; 0245 _ 48: 89. C7
        call    freeBoardlist                           ; 0248 _ E8, 00000000(rel)
?_012:  mov     rax, qword [rbp-10H]                    ; 024D _ 48: 8B. 45, F0
        mov     rax, qword [rax+8H]                     ; 0251 _ 48: 8B. 40, 08
        test    rax, rax                                ; 0255 _ 48: 85. C0
        jz      ?_013                                   ; 0258 _ 74, 20
        mov     rax, qword [rbp-10H]                    ; 025A _ 48: 8B. 45, F0
        mov     rax, qword [rax+8H]                     ; 025E _ 48: 8B. 40, 08
        mov     rdi, rax                                ; 0262 _ 48: 89. C7
        call    add_dir_tries                           ; 0265 _ E8, 00000000(rel)
        mov     rax, qword [rbp-10H]                    ; 026A _ 48: 8B. 45, F0
        mov     rax, qword [rax+8H]                     ; 026E _ 48: 8B. 40, 08
        mov     rdi, rax                                ; 0272 _ 48: 89. C7
        call    freeBoardlist                           ; 0275 _ E8, 00000000(rel)
?_013:  mov     rax, qword [rbp-10H]                    ; 027A _ 48: 8B. 45, F0
        mov     rax, qword [rax+10H]                    ; 027E _ 48: 8B. 40, 10
        test    rax, rax                                ; 0282 _ 48: 85. C0
        jz      ?_014                                   ; 0285 _ 74, 20
        mov     rax, qword [rbp-10H]                    ; 0287 _ 48: 8B. 45, F0
        mov     rax, qword [rax+10H]                    ; 028B _ 48: 8B. 40, 10
        mov     rdi, rax                                ; 028F _ 48: 89. C7
        call    add_dir_keys                            ; 0292 _ E8, 00000000(rel)
        mov     rax, qword [rbp-10H]                    ; 0297 _ 48: 8B. 45, F0
        mov     rax, qword [rax+10H]                    ; 029B _ 48: 8B. 40, 10
        mov     rdi, rax                                ; 029F _ 48: 89. C7
        call    freeBoardlist                           ; 02A2 _ E8, 00000000(rel)
?_014:  mov     rax, qword [rbp-10H]                    ; 02A7 _ 48: 8B. 45, F0
        mov     rax, qword [rax+18H]                    ; 02AB _ 48: 8B. 40, 18
        test    rax, rax                                ; 02AF _ 48: 85. C0
        je      ?_023                                   ; 02B2 _ 0F 84, 000000D6
        mov     rax, qword [rbp-10H]                    ; 02B8 _ 48: 8B. 45, F0
        mov     rax, qword [rax+18H]                    ; 02BC _ 48: 8B. 40, 18
        mov     rax, qword [rax]                        ; 02C0 _ 48: 8B. 00
        mov     qword [rbp-20H], rax                    ; 02C3 _ 48: 89. 45, E0
        jmp     ?_021                                   ; 02C7 _ E9, 00000085

?_015:  mov     rax, qword [rbp-10H]                    ; 02CC _ 48: 8B. 45, F0
        mov     rax, qword [rax+18H]                    ; 02D0 _ 48: 8B. 40, 18
        mov     rdx, qword [rbp-10H]                    ; 02D4 _ 48: 8B. 55, F0
        mov     rdx, qword [rdx+18H]                    ; 02D8 _ 48: 8B. 52, 18
        mov     rdx, qword [rdx]                        ; 02DC _ 48: 8B. 12
        mov     rdx, qword [rdx+38H]                    ; 02DF _ 48: 8B. 52, 38
        mov     qword [rax], rdx                        ; 02E3 _ 48: 89. 10
        jmp     ?_020                                   ; 02E6 _ EB, 55

?_016:  mov     rax, qword [rbp-10H]                    ; 02E8 _ 48: 8B. 45, F0
        mov     rax, qword [rax+18H]                    ; 02EC _ 48: 8B. 40, 18
        mov     rax, qword [rax]                        ; 02F0 _ 48: 8B. 00
        mov     qword [rbp-18H], rax                    ; 02F3 _ 48: 89. 45, E8
        jmp     ?_018                                   ; 02F7 _ EB, 0C

?_017:  mov     rax, qword [rbp-18H]                    ; 02F9 _ 48: 8B. 45, E8
        mov     rax, qword [rax+38H]                    ; 02FD _ 48: 8B. 40, 38
        mov     qword [rbp-18H], rax                    ; 0301 _ 48: 89. 45, E8
?_018:  mov     rax, qword [rbp-18H]                    ; 0305 _ 48: 8B. 45, E8
        mov     rax, qword [rax+38H]                    ; 0309 _ 48: 8B. 40, 38
        test    rax, rax                                ; 030D _ 48: 85. C0
        jz      ?_019                                   ; 0310 _ 74, 0E
        mov     rax, qword [rbp-18H]                    ; 0312 _ 48: 8B. 45, E8
        mov     rax, qword [rax+38H]                    ; 0316 _ 48: 8B. 40, 38
        cmp     rax, qword [rbp-20H]                    ; 031A _ 48: 3B. 45, E0
        jnz     ?_017                                   ; 031E _ 75, D9
?_019:  mov     rax, qword [rbp-18H]                    ; 0320 _ 48: 8B. 45, E8
        mov     rax, qword [rax+38H]                    ; 0324 _ 48: 8B. 40, 38
        test    rax, rax                                ; 0328 _ 48: 85. C0
        jz      ?_020                                   ; 032B _ 74, 10
        mov     rax, qword [rbp-20H]                    ; 032D _ 48: 8B. 45, E0
        mov     rdx, qword [rax+38H]                    ; 0331 _ 48: 8B. 50, 38
        mov     rax, qword [rbp-18H]                    ; 0335 _ 48: 8B. 45, E8
        mov     qword [rax+38H], rdx                    ; 0339 _ 48: 89. 50, 38
?_020:  mov     rax, qword [rbp-20H]                    ; 033D _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0341 _ 48: 89. C7
        call    free                                    ; 0344 _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 0349 _ 48: 8B. 45, F8
        mov     qword [rbp-20H], rax                    ; 034D _ 48: 89. 45, E0
?_021:  cmp     qword [rbp-20H], 0                      ; 0351 _ 48: 83. 7D, E0, 00
        jz      ?_022                                   ; 0356 _ 74, 26
        mov     rax, qword [rbp-20H]                    ; 0358 _ 48: 8B. 45, E0
        mov     rax, qword [rax+38H]                    ; 035C _ 48: 8B. 40, 38
        mov     qword [rbp-8H], rax                     ; 0360 _ 48: 89. 45, F8
        mov     rax, qword [rbp-10H]                    ; 0364 _ 48: 8B. 45, F0
        mov     rax, qword [rax+18H]                    ; 0368 _ 48: 8B. 40, 18
        mov     rax, qword [rax]                        ; 036C _ 48: 8B. 00
        cmp     rax, qword [rbp-20H]                    ; 036F _ 48: 3B. 45, E0
        jne     ?_016                                   ; 0373 _ 0F 85, FFFFFF6F
        jmp     ?_015                                   ; 0379 _ E9, FFFFFF4E

?_022:  mov     rax, qword [rbp-10H]                    ; 037E _ 48: 8B. 45, F0
        mov     rax, qword [rax+18H]                    ; 0382 _ 48: 8B. 40, 18
        mov     rdi, rax                                ; 0386 _ 48: 89. C7
        call    free                                    ; 0389 _ E8, 00000000(rel)
?_023:  call    add_dir_options                         ; 038E _ E8, 00000000(rel)
        mov     rax, qword [rbp-10H]                    ; 0393 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0397 _ 48: 89. C7
        call    add_dir_stats                           ; 039A _ E8, 00000000(rel)
        call    end_clock                               ; 039F _ E8, 00000000(rel)
        mov     rax, qword [rel run_time]               ; 03A4 _ 48: 8B. 05, 00000000(rel)
        movq    xmm0, rax                               ; 03AB _ 66 48: 0F 6E. C0
        call    time_dir                                ; 03B0 _ E8, 00000000(rel)
        call    end_dir                                 ; 03B5 _ E8, 00000000(rel)
        mov     rax, qword [rbp-10H]                    ; 03BA _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 03BE _ 48: 89. C7
        call    free                                    ; 03C1 _ E8, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 03C6 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 03CA _ 48: 89. C7
        call    freeBoard                               ; 03CD _ E8, 00000000(rel)
        nop                                             ; 03D2 _ 90
        leave                                           ; 03D3 _ C9
        ret                                             ; 03D4 _ C3

do_self:; Local function
        push    rbp                                     ; 03D5 _ 55
        mov     rbp, rsp                                ; 03D6 _ 48: 89. E5
        sub     rsp, 16                                 ; 03D9 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 03DD _ 48: 89. 7D, F8
        mov     rax, qword [rel stderr]                 ; 03E1 _ 48: 8B. 05, 00000000(rel)
        mov     rcx, rax                                ; 03E8 _ 48: 89. C1
        mov     edx, 42                                 ; 03EB _ BA, 0000002A
        mov     esi, 1                                  ; 03F0 _ BE, 00000001
        mov     edi, ?_028                              ; 03F5 _ BF, 00000000(d)
        call    fwrite                                  ; 03FA _ E8, 00000000(rel)
        mov     edi, 1                                  ; 03FF _ BF, 00000001
        call    exit                                    ; 0404 _ E8, 00000000(rel)
do_help:push    rbp                                     ; 0409 _ 55
        mov     rbp, rsp                                ; 040A _ 48: 89. E5
        sub     rsp, 16                                 ; 040D _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0411 _ 48: 89. 7D, F8
        mov     rax, qword [rel stderr]                 ; 0415 _ 48: 8B. 05, 00000000(rel)
        mov     rcx, rax                                ; 041C _ 48: 89. C1
        mov     edx, 42                                 ; 041F _ BA, 0000002A
        mov     esi, 1                                  ; 0424 _ BE, 00000001
        mov     edi, ?_029                              ; 0429 _ BF, 00000000(d)
        call    fwrite                                  ; 042E _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0433 _ BF, 00000001
        call    exit                                    ; 0438 _ E8, 00000000(rel)
do_reflex:
        push    rbp                                     ; 043D _ 55
        mov     rbp, rsp                                ; 043E _ 48: 89. E5
        sub     rsp, 16                                 ; 0441 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0445 _ 48: 89. 7D, F8
        mov     rax, qword [rel stderr]                 ; 0449 _ 48: 8B. 05, 00000000(rel)
        mov     rcx, rax                                ; 0450 _ 48: 89. C1
        mov     edx, 44                                 ; 0453 _ BA, 0000002C
        mov     esi, 1                                  ; 0458 _ BE, 00000001
        mov     edi, ?_030                              ; 045D _ BF, 00000000(d)
        call    fwrite                                  ; 0462 _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0467 _ BF, 00000001
; Note: Function does not end with ret or jmp
        call    exit                                    ; 046C _ E8, 00000000(rel)


SECTION .data   align=1 noexecute                       ; section number 2, data


SECTION .bss    align=8 noexecute                       ; section number 3, bss

prog_start:                                             ; qword
        resq    1                                       ; 0000

prog_end: resq  1                                       ; 0008

run_time: resq  1                                       ; 0010


SECTION .rodata align=8 noexecute                       ; section number 4, const

?_024:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 0000 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 69H       ; 0008 _ ERROR: i
        db 6DH, 70H, 6FH, 73H, 73H, 69H, 62H, 6CH       ; 0010 _ mpossibl
        db 65H, 20H, 69H, 6EH, 76H, 61H, 6CH, 69H       ; 0018 _ e invali
        db 64H, 20H, 73H, 74H, 69H, 70H, 75H, 6CH       ; 0020 _ d stipul
        db 61H, 74H, 69H, 6FH, 6EH, 21H, 21H, 00H       ; 0028 _ ation!!.

?_025:                                                  ; byte
        db 52H, 75H, 6EH, 6EH, 69H, 6EH, 67H, 20H       ; 0030 _ Running 
        db 54H, 69H, 6DH, 65H, 20H, 3DH, 20H, 25H       ; 0038 _ Time = %
        db 66H, 0AH, 00H                                ; 0040 _ f..

?_026:                                                  ; byte
        db 6DH, 61H, 69H, 6EH, 2EH, 63H, 00H            ; 0043 _ main.c.

?_027:                                                  ; byte
        db 4FH, 55H, 54H, 20H, 4FH, 46H, 20H, 4DH       ; 004A _ OUT OF M
        db 45H, 4DH, 4FH, 52H, 59H, 20H, 61H, 74H       ; 0052 _ EMORY at
        db 20H, 25H, 73H, 28H, 25H, 64H, 29H, 0AH       ; 005A _  %s(%d).
        db 00H, 00H, 00H, 00H, 00H, 00H                 ; 0062 _ ......

?_028:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 0068 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 43H       ; 0070 _ ERROR: C
        db 61H, 6EH, 27H, 74H, 20H, 73H, 6FH, 6CH       ; 0078 _ an't sol
        db 76H, 65H, 20H, 73H, 65H, 6CH, 66H, 6DH       ; 0080 _ ve selfm
        db 61H, 74H, 65H, 73H, 20H, 79H, 65H, 74H       ; 0088 _ ates yet
        db 21H, 0AH, 00H, 00H, 00H, 00H, 00H, 00H       ; 0090 _ !.......

?_029:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 0098 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 43H       ; 00A0 _ ERROR: C
        db 61H, 6EH, 27H, 74H, 20H, 73H, 6FH, 6CH       ; 00A8 _ an't sol
        db 76H, 65H, 20H, 68H, 65H, 6CH, 70H, 6DH       ; 00B0 _ ve helpm
        db 61H, 74H, 65H, 73H, 20H, 79H, 65H, 74H       ; 00B8 _ ates yet
        db 21H, 0AH, 00H, 00H, 00H, 00H, 00H, 00H       ; 00C0 _ !.......

?_030:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 00C8 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 43H       ; 00D0 _ ERROR: C
        db 61H, 6EH, 27H, 74H, 20H, 73H, 6FH, 6CH       ; 00D8 _ an't sol
        db 76H, 65H, 20H, 72H, 65H, 66H, 6CH, 65H       ; 00E0 _ ve refle
        db 78H, 6DH, 61H, 74H, 65H, 73H, 20H, 79H       ; 00E8 _ xmates y
        db 65H, 74H, 21H, 0AH, 00H, 00H, 00H, 00H       ; 00F0 _ et!.....

?_031:  dq 412E848000000000H                            ; 00F8 _ 1000000.0 


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
        dd 00000174H, 100E4100H                         ; 0044 _ 372 269369600 
        dd 0D430286H, 016F0306H                         ; 004C _ 222495366 24052486 
        dd 0008070CH, 0000001CH                         ; 0054 _ 526092 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd end_clock-$+158H                             ; 0060 _ 00000000 (rel)
        dd 0000021DH, 100E4100H                         ; 0064 _ 541 269369600 
        dd 0D430286H, 02180306H                         ; 006C _ 222495366 35128070 
        dd 0008070CH, 00000018H                         ; 0074 _ 526092 24 
        dd 0000007CH                                    ; 007C _ 124 
        dd end_clock-$+355H                             ; 0080 _ 00000000 (rel)
        dd 00000034H, 100E4100H                         ; 0084 _ 52 269369600 
        dd 0D430286H, 00000006H                         ; 008C _ 222495366 6 
        dd 00000018H, 00000098H                         ; 0094 _ 24 152 
        dd end_clock-$+36DH                             ; 009C _ 00000000 (rel)
        dd 00000034H, 100E4100H                         ; 00A0 _ 52 269369600 
        dd 0D430286H, 00000006H                         ; 00A8 _ 222495366 6 
        dd 0000001CH, 000000B4H                         ; 00B0 _ 28 180 
        dd end_clock-$+385H                             ; 00B8 _ 00000000 (rel)
        dd 00000034H, 100E4100H                         ; 00BC _ 52 269369600 
        dd 0D430286H, 00000006H                         ; 00C4 _ 222495366 6 
        dd 00000000H                                    ; 00CC _ 0 


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
; Error: Relocation number 136 has a non-existing source address. Section: 0 Offset: 0000067FH
; Error: Relocation number 137 has a non-existing source address. Section: 0 Offset: 00000685H
; Error: Relocation number 138 has a non-existing source address. Section: 0 Offset: 0000069CH
; Error: Relocation number 139 has a non-existing source address. Section: 0 Offset: 000006AAH
; Error: Relocation number 140 has a non-existing source address. Section: 0 Offset: 000006B8H
; Error: Relocation number 141 has a non-existing source address. Section: 0 Offset: 000006E3H
; Error: Relocation number 142 has a non-existing source address. Section: 0 Offset: 000006E8H
; Error: Relocation number 143 has a non-existing source address. Section: 0 Offset: 000006FFH
; Error: Relocation number 144 has a non-existing source address. Section: 0 Offset: 00000705H
; Error: Relocation number 145 has a non-existing source address. Section: 0 Offset: 0000071CH
; Error: Relocation number 146 has a non-existing source address. Section: 0 Offset: 0000072BH
; Error: Relocation number 147 has a non-existing source address. Section: 0 Offset: 00000731H
; Error: Relocation number 148 has a non-existing source address. Section: 0 Offset: 00000748H
; Error: Relocation number 149 has a non-existing source address. Section: 0 Offset: 00000757H
; Error: Relocation number 150 has a non-existing source address. Section: 0 Offset: 0000075DH
; Error: Relocation number 151 has a non-existing source address. Section: 0 Offset: 00000774H
; Error: Relocation number 152 has a non-existing source address. Section: 0 Offset: 00000783H
; Error: Relocation number 153 has a non-existing source address. Section: 0 Offset: 0000078FH
; Error: Relocation number 154 has a non-existing source address. Section: 0 Offset: 00000798H
; Error: Relocation number 155 has a non-existing source address. Section: 0 Offset: 000007A4H
; Error: Relocation number 156 has a non-existing source address. Section: 0 Offset: 000007ADH
; Error: Relocation number 157 has a non-existing source address. Section: 0 Offset: 000007B9H
; Error: Relocation number 158 has a non-existing source address. Section: 0 Offset: 000007C4H
; Error: Relocation number 159 has a non-existing source address. Section: 0 Offset: 000007C9H
; Error: Relocation number 160 has a non-existing source address. Section: 0 Offset: 000007D4H
; Error: Relocation number 161 has a non-existing source address. Section: 0 Offset: 000007DFH
; Error: Relocation number 162 has a non-existing source address. Section: 0 Offset: 000007EBH


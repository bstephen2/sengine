; Disassembly of file: main.o
; Fri May 25 14:47:22 2018
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
extern malloc                                           ; near
extern __stack_chk_fail                                 ; near
extern exit                                             ; near
extern realloc                                          ; near
extern vsnprintf                                        ; near
extern free                                             ; near
extern strdup                                           ; near


SECTION .text   align=1 execute                         ; section number 1, code

utarray_str_cpy:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        sub     rsp, 32                                 ; 0004 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 0008 _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 000C _ 48: 89. 75, E0
        mov     rax, qword [rbp-20H]                    ; 0010 _ 48: 8B. 45, E0
        mov     qword [rbp-10H], rax                    ; 0014 _ 48: 89. 45, F0
        mov     rax, qword [rbp-18H]                    ; 0018 _ 48: 8B. 45, E8
        mov     qword [rbp-8H], rax                     ; 001C _ 48: 89. 45, F8
        mov     rax, qword [rbp-10H]                    ; 0020 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0024 _ 48: 8B. 00
        test    rax, rax                                ; 0027 _ 48: 85. C0
        jz      ?_001                                   ; 002A _ 74, 14
        mov     rax, qword [rbp-10H]                    ; 002C _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0030 _ 48: 8B. 00
        mov     rdi, rax                                ; 0033 _ 48: 89. C7
        call    strdup                                  ; 0036 _ E8, 00000000(rel)
        mov     rdx, rax                                ; 003B _ 48: 89. C2
        jmp     ?_002                                   ; 003E _ EB, 05

?_001:  mov     edx, 0                                  ; 0040 _ BA, 00000000
?_002:  mov     rax, qword [rbp-8H]                     ; 0045 _ 48: 8B. 45, F8
        mov     qword [rax], rdx                        ; 0049 _ 48: 89. 10
        nop                                             ; 004C _ 90
        leave                                           ; 004D _ C9
        ret                                             ; 004E _ C3

utarray_str_dtor:; Local function
        push    rbp                                     ; 004F _ 55
        mov     rbp, rsp                                ; 0050 _ 48: 89. E5
        sub     rsp, 32                                 ; 0053 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 0057 _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 005B _ 48: 8B. 45, E8
        mov     qword [rbp-8H], rax                     ; 005F _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 0063 _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 0067 _ 48: 8B. 00
        test    rax, rax                                ; 006A _ 48: 85. C0
        jz      ?_003                                   ; 006D _ 74, 0F
        mov     rax, qword [rbp-8H]                     ; 006F _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 0073 _ 48: 8B. 00
        mov     rdi, rax                                ; 0076 _ 48: 89. C7
        call    free                                    ; 0079 _ E8, 00000000(rel)
?_003:  nop                                             ; 007E _ 90
        leave                                           ; 007F _ C9
        ret                                             ; 0080 _ C3

utstring_printf_va:; Local function
        push    rbp                                     ; 0081 _ 55
        mov     rbp, rsp                                ; 0082 _ 48: 89. E5
        sub     rsp, 96                                 ; 0085 _ 48: 83. EC, 60
        mov     qword [rbp-48H], rdi                    ; 0089 _ 48: 89. 7D, B8
        mov     qword [rbp-50H], rsi                    ; 008D _ 48: 89. 75, B0
        mov     qword [rbp-58H], rdx                    ; 0091 _ 48: 89. 55, A8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0095 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 009E _ 48: 89. 45, F8
        xor     eax, eax                                ; 00A2 _ 31. C0
?_004:  lea     rax, [rbp-20H]                          ; 00A4 _ 48: 8D. 45, E0
        mov     rdx, qword [rbp-58H]                    ; 00A8 _ 48: 8B. 55, A8
        mov     rcx, qword [rdx]                        ; 00AC _ 48: 8B. 0A
        mov     qword [rax], rcx                        ; 00AF _ 48: 89. 08
        mov     rcx, qword [rdx+8H]                     ; 00B2 _ 48: 8B. 4A, 08
        mov     qword [rax+8H], rcx                     ; 00B6 _ 48: 89. 48, 08
        mov     rdx, qword [rdx+10H]                    ; 00BA _ 48: 8B. 52, 10
        mov     qword [rax+10H], rdx                    ; 00BE _ 48: 89. 50, 10
        mov     rax, qword [rbp-48H]                    ; 00C2 _ 48: 8B. 45, B8
        mov     rdx, qword [rax+8H]                     ; 00C6 _ 48: 8B. 50, 08
        mov     rax, qword [rbp-48H]                    ; 00CA _ 48: 8B. 45, B8
        mov     rax, qword [rax+10H]                    ; 00CE _ 48: 8B. 40, 10
        mov     rsi, rdx                                ; 00D2 _ 48: 89. D6
        sub     rsi, rax                                ; 00D5 _ 48: 29. C6
        mov     rax, qword [rbp-48H]                    ; 00D8 _ 48: 8B. 45, B8
        mov     rdx, qword [rax]                        ; 00DC _ 48: 8B. 10
        mov     rax, qword [rbp-48H]                    ; 00DF _ 48: 8B. 45, B8
        mov     rax, qword [rax+10H]                    ; 00E3 _ 48: 8B. 40, 10
        lea     rdi, [rdx+rax]                          ; 00E7 _ 48: 8D. 3C 02
        lea     rdx, [rbp-20H]                          ; 00EB _ 48: 8D. 55, E0
        mov     rax, qword [rbp-50H]                    ; 00EF _ 48: 8B. 45, B0
        mov     rcx, rdx                                ; 00F3 _ 48: 89. D1
        mov     rdx, rax                                ; 00F6 _ 48: 89. C2
        call    vsnprintf                               ; 00F9 _ E8, 00000000(rel)
        mov     dword [rbp-34H], eax                    ; 00FE _ 89. 45, CC
        cmp     dword [rbp-34H], 0                      ; 0101 _ 83. 7D, CC, 00
        js      ?_005                                   ; 0105 _ 78, 52
        mov     eax, dword [rbp-34H]                    ; 0107 _ 8B. 45, CC
        movsxd  rdx, eax                                ; 010A _ 48: 63. D0
        mov     rax, qword [rbp-48H]                    ; 010D _ 48: 8B. 45, B8
        mov     rcx, qword [rax+8H]                     ; 0111 _ 48: 8B. 48, 08
        mov     rax, qword [rbp-48H]                    ; 0115 _ 48: 8B. 45, B8
        mov     rax, qword [rax+10H]                    ; 0119 _ 48: 8B. 40, 10
        sub     rcx, rax                                ; 011D _ 48: 29. C1
        mov     rax, rcx                                ; 0120 _ 48: 89. C8
        cmp     rdx, rax                                ; 0123 _ 48: 39. C2
        jnc     ?_005                                   ; 0126 _ 73, 31
        mov     rax, qword [rbp-48H]                    ; 0128 _ 48: 8B. 45, B8
        mov     rdx, qword [rax+10H]                    ; 012C _ 48: 8B. 50, 10
        mov     eax, dword [rbp-34H]                    ; 0130 _ 8B. 45, CC
        cdqe                                            ; 0133 _ 48: 98
        add     rdx, rax                                ; 0135 _ 48: 01. C2
        mov     rax, qword [rbp-48H]                    ; 0138 _ 48: 8B. 45, B8
        mov     qword [rax+10H], rdx                    ; 013C _ 48: 89. 50, 10
        nop                                             ; 0140 _ 90
        mov     rax, qword [rbp-8H]                     ; 0141 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        xor     rax, qword [fs:abs 28H]                 ; 0145 _ 64 48: 33. 04 25, 00000028
        je      ?_010                                   ; 014E _ 0F 84, 00000125
        jmp     ?_009                                   ; 0154 _ E9, 0000011B

?_005:  cmp     dword [rbp-34H], 0                      ; 0159 _ 83. 7D, CC, 00
        js      ?_007                                   ; 015D _ 0F 88, 00000089
        mov     rax, qword [rbp-48H]                    ; 0163 _ 48: 8B. 45, B8
        mov     rdx, qword [rax+8H]                     ; 0167 _ 48: 8B. 50, 08
        mov     rax, qword [rbp-48H]                    ; 016B _ 48: 8B. 45, B8
        mov     rax, qword [rax+10H]                    ; 016F _ 48: 8B. 40, 10
        sub     rdx, rax                                ; 0173 _ 48: 29. C2
        mov     eax, dword [rbp-34H]                    ; 0176 _ 8B. 45, CC
        add     eax, 1                                  ; 0179 _ 83. C0, 01
        cdqe                                            ; 017C _ 48: 98
        cmp     rdx, rax                                ; 017E _ 48: 39. C2
        jnc     ?_004                                   ; 0181 _ 0F 83, FFFFFF1D
        mov     rax, qword [rbp-48H]                    ; 0187 _ 48: 8B. 45, B8
        mov     rdx, qword [rax+8H]                     ; 018B _ 48: 8B. 50, 08
        mov     eax, dword [rbp-34H]                    ; 018F _ 8B. 45, CC
        add     eax, 1                                  ; 0192 _ 83. C0, 01
        cdqe                                            ; 0195 _ 48: 98
        add     rdx, rax                                ; 0197 _ 48: 01. C2
        mov     rax, qword [rbp-48H]                    ; 019A _ 48: 8B. 45, B8
        mov     rax, qword [rax]                        ; 019E _ 48: 8B. 00
        mov     rsi, rdx                                ; 01A1 _ 48: 89. D6
        mov     rdi, rax                                ; 01A4 _ 48: 89. C7
        call    realloc                                 ; 01A7 _ E8, 00000000(rel)
        mov     qword [rbp-30H], rax                    ; 01AC _ 48: 89. 45, D0
        cmp     qword [rbp-30H], 0                      ; 01B0 _ 48: 83. 7D, D0, 00
        jnz     ?_006                                   ; 01B5 _ 75, 0A
        mov     edi, 4294967295                         ; 01B7 _ BF, FFFFFFFF
        call    exit                                    ; 01BC _ E8, 00000000(rel)
?_006:  mov     rax, qword [rbp-48H]                    ; 01C1 _ 48: 8B. 45, B8
        mov     rdx, qword [rbp-30H]                    ; 01C5 _ 48: 8B. 55, D0
        mov     qword [rax], rdx                        ; 01C9 _ 48: 89. 10
        mov     rax, qword [rbp-48H]                    ; 01CC _ 48: 8B. 45, B8
        mov     rdx, qword [rax+8H]                     ; 01D0 _ 48: 8B. 50, 08
        mov     eax, dword [rbp-34H]                    ; 01D4 _ 8B. 45, CC
        add     eax, 1                                  ; 01D7 _ 83. C0, 01
        cdqe                                            ; 01DA _ 48: 98
        add     rdx, rax                                ; 01DC _ 48: 01. C2
        mov     rax, qword [rbp-48H]                    ; 01DF _ 48: 8B. 45, B8
        mov     qword [rax+8H], rdx                     ; 01E3 _ 48: 89. 50, 08
        jmp     ?_004                                   ; 01E7 _ E9, FFFFFEB8

?_007:  mov     rax, qword [rbp-48H]                    ; 01EC _ 48: 8B. 45, B8
        mov     rdx, qword [rax+8H]                     ; 01F0 _ 48: 8B. 50, 08
        mov     rax, qword [rbp-48H]                    ; 01F4 _ 48: 8B. 45, B8
        mov     rax, qword [rax+10H]                    ; 01F8 _ 48: 8B. 40, 10
        sub     rdx, rax                                ; 01FC _ 48: 29. C2
        mov     rax, qword [rbp-48H]                    ; 01FF _ 48: 8B. 45, B8
        mov     rax, qword [rax+8H]                     ; 0203 _ 48: 8B. 40, 08
        add     rax, rax                                ; 0207 _ 48: 01. C0
        cmp     rdx, rax                                ; 020A _ 48: 39. C2
        jnc     ?_004                                   ; 020D _ 0F 83, FFFFFE91
        mov     rax, qword [rbp-48H]                    ; 0213 _ 48: 8B. 45, B8
        mov     rdx, qword [rax+8H]                     ; 0217 _ 48: 8B. 50, 08
        mov     rax, rdx                                ; 021B _ 48: 89. D0
        add     rax, rax                                ; 021E _ 48: 01. C0
        add     rdx, rax                                ; 0221 _ 48: 01. C2
        mov     rax, qword [rbp-48H]                    ; 0224 _ 48: 8B. 45, B8
        mov     rax, qword [rax]                        ; 0228 _ 48: 8B. 00
        mov     rsi, rdx                                ; 022B _ 48: 89. D6
        mov     rdi, rax                                ; 022E _ 48: 89. C7
        call    realloc                                 ; 0231 _ E8, 00000000(rel)
        mov     qword [rbp-28H], rax                    ; 0236 _ 48: 89. 45, D8
        cmp     qword [rbp-28H], 0                      ; 023A _ 48: 83. 7D, D8, 00
        jnz     ?_008                                   ; 023F _ 75, 0A
        mov     edi, 4294967295                         ; 0241 _ BF, FFFFFFFF
        call    exit                                    ; 0246 _ E8, 00000000(rel)
?_008:  mov     rax, qword [rbp-48H]                    ; 024B _ 48: 8B. 45, B8
        mov     rdx, qword [rbp-28H]                    ; 024F _ 48: 8B. 55, D8
        mov     qword [rax], rdx                        ; 0253 _ 48: 89. 10
        mov     rax, qword [rbp-48H]                    ; 0256 _ 48: 8B. 45, B8
        mov     rdx, qword [rax+8H]                     ; 025A _ 48: 8B. 50, 08
        mov     rax, rdx                                ; 025E _ 48: 89. D0
        add     rax, rax                                ; 0261 _ 48: 01. C0
        add     rdx, rax                                ; 0264 _ 48: 01. C2
        mov     rax, qword [rbp-48H]                    ; 0267 _ 48: 8B. 45, B8
        mov     qword [rax+8H], rdx                     ; 026B _ 48: 89. 50, 08
        jmp     ?_004                                   ; 026F _ E9, FFFFFE30

?_009:  call    __stack_chk_fail                        ; 0274 _ E8, 00000000(rel)
?_010:  leave                                           ; 0279 _ C9
        ret                                             ; 027A _ C3

utstring_printf:; Local function
        push    rbp                                     ; 027B _ 55
        mov     rbp, rsp                                ; 027C _ 48: 89. E5
        sub     rsp, 224                                ; 027F _ 48: 81. EC, 000000E0
        mov     qword [rbp-0D8H], rdi                   ; 0286 _ 48: 89. BD, FFFFFF28
        mov     qword [rbp-0E0H], rsi                   ; 028D _ 48: 89. B5, FFFFFF20
        mov     qword [rbp-0A0H], rdx                   ; 0294 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 029B _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 02A2 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 02A9 _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 02B0 _ 84. C0
        jz      ?_011                                   ; 02B2 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 02B4 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 02B8 _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 02BC _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 02C0 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 02C4 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 02C8 _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 02CC _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 02D0 _ 0F 29. 7D, F0
?_011:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 02D4 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 02DD _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 02E4 _ 31. C0
        mov     dword [rbp-0D0H], 16                    ; 02E6 _ C7. 85, FFFFFF30, 00000010
        mov     dword [rbp-0CCH], 48                    ; 02F0 _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 02FA _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 02FE _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0305 _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 030C _ 48: 89. 85, FFFFFF40
        lea     rdx, [rbp-0D0H]                         ; 0313 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E0H]                   ; 031A _ 48: 8B. 8D, FFFFFF20
        mov     rax, qword [rbp-0D8H]                   ; 0321 _ 48: 8B. 85, FFFFFF28
        mov     rsi, rcx                                ; 0328 _ 48: 89. CE
        mov     rdi, rax                                ; 032B _ 48: 89. C7
        call    utstring_printf_va                      ; 032E _ E8, FFFFFD4E
        nop                                             ; 0333 _ 90
        mov     rax, qword [rbp-0B8H]                   ; 0334 _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        xor     rax, qword [fs:abs 28H]                 ; 033B _ 64 48: 33. 04 25, 00000028
        jz      ?_012                                   ; 0344 _ 74, 05
        call    __stack_chk_fail                        ; 0346 _ E8, 00000000(rel)
?_012:  leave                                           ; 034B _ C9
        ret                                             ; 034C _ C3

_utstring_BuildTable:; Local function
        push    rbp                                     ; 034D _ 55
        mov     rbp, rsp                                ; 034E _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 0351 _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 0355 _ 48: 89. 75, E0
        mov     qword [rbp-28H], rdx                    ; 0359 _ 48: 89. 55, D8
        mov     qword [rbp-10H], 0                      ; 035D _ 48: C7. 45, F0, 00000000
        mov     rax, qword [rbp-10H]                    ; 0365 _ 48: 8B. 45, F0
        sub     rax, 1                                  ; 0369 _ 48: 83. E8, 01
        mov     qword [rbp-8H], rax                     ; 036D _ 48: 89. 45, F8
        mov     rax, qword [rbp-10H]                    ; 0371 _ 48: 8B. 45, F0
        lea     rdx, [rax*8]                            ; 0375 _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-28H]                    ; 037D _ 48: 8B. 45, D8
        add     rdx, rax                                ; 0381 _ 48: 01. C2
        mov     rax, qword [rbp-8H]                     ; 0384 _ 48: 8B. 45, F8
        mov     qword [rdx], rax                        ; 0388 _ 48: 89. 02
        jmp     ?_018                                   ; 038B _ E9, 000000D9

?_013:  mov     rax, qword [rbp-8H]                     ; 0390 _ 48: 8B. 45, F8
        lea     rdx, [rax*8]                            ; 0394 _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-28H]                    ; 039C _ 48: 8B. 45, D8
        add     rax, rdx                                ; 03A0 _ 48: 01. D0
        mov     rax, qword [rax]                        ; 03A3 _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 03A6 _ 48: 89. 45, F8
?_014:  cmp     qword [rbp-8H], 0                       ; 03AA _ 48: 83. 7D, F8, 00
        js      ?_015                                   ; 03AF _ 78, 20
        mov     rdx, qword [rbp-10H]                    ; 03B1 _ 48: 8B. 55, F0
        mov     rax, qword [rbp-18H]                    ; 03B5 _ 48: 8B. 45, E8
        add     rax, rdx                                ; 03B9 _ 48: 01. D0
        movzx   edx, byte [rax]                         ; 03BC _ 0F B6. 10
        mov     rcx, qword [rbp-8H]                     ; 03BF _ 48: 8B. 4D, F8
        mov     rax, qword [rbp-18H]                    ; 03C3 _ 48: 8B. 45, E8
        add     rax, rcx                                ; 03C7 _ 48: 01. C8
        movzx   eax, byte [rax]                         ; 03CA _ 0F B6. 00
        cmp     dl, al                                  ; 03CD _ 38. C2
        jnz     ?_013                                   ; 03CF _ 75, BF
?_015:  add     qword [rbp-10H], 1                      ; 03D1 _ 48: 83. 45, F0, 01
        add     qword [rbp-8H], 1                       ; 03D6 _ 48: 83. 45, F8, 01
        mov     rax, qword [rbp-20H]                    ; 03DB _ 48: 8B. 45, E0
        cmp     qword [rbp-10H], rax                    ; 03DF _ 48: 39. 45, F0
        jge     ?_017                                   ; 03E3 _ 7D, 6A
        mov     rdx, qword [rbp-10H]                    ; 03E5 _ 48: 8B. 55, F0
        mov     rax, qword [rbp-18H]                    ; 03E9 _ 48: 8B. 45, E8
        add     rax, rdx                                ; 03ED _ 48: 01. D0
        movzx   edx, byte [rax]                         ; 03F0 _ 0F B6. 10
        mov     rcx, qword [rbp-8H]                     ; 03F3 _ 48: 8B. 4D, F8
        mov     rax, qword [rbp-18H]                    ; 03F7 _ 48: 8B. 45, E8
        add     rax, rcx                                ; 03FB _ 48: 01. C8
        movzx   eax, byte [rax]                         ; 03FE _ 0F B6. 00
        cmp     dl, al                                  ; 0401 _ 38. C2
        jnz     ?_016                                   ; 0403 _ 75, 2E
        mov     rax, qword [rbp-10H]                    ; 0405 _ 48: 8B. 45, F0
        lea     rdx, [rax*8]                            ; 0409 _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-28H]                    ; 0411 _ 48: 8B. 45, D8
        add     rdx, rax                                ; 0415 _ 48: 01. C2
        mov     rax, qword [rbp-8H]                     ; 0418 _ 48: 8B. 45, F8
        lea     rcx, [rax*8]                            ; 041C _ 48: 8D. 0C C5, 00000000
        mov     rax, qword [rbp-28H]                    ; 0424 _ 48: 8B. 45, D8
        add     rax, rcx                                ; 0428 _ 48: 01. C8
        mov     rax, qword [rax]                        ; 042B _ 48: 8B. 00
        mov     qword [rdx], rax                        ; 042E _ 48: 89. 02
        jmp     ?_018                                   ; 0431 _ EB, 36

?_016:  mov     rax, qword [rbp-10H]                    ; 0433 _ 48: 8B. 45, F0
        lea     rdx, [rax*8]                            ; 0437 _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-28H]                    ; 043F _ 48: 8B. 45, D8
        add     rdx, rax                                ; 0443 _ 48: 01. C2
        mov     rax, qword [rbp-8H]                     ; 0446 _ 48: 8B. 45, F8
        mov     qword [rdx], rax                        ; 044A _ 48: 89. 02
        jmp     ?_018                                   ; 044D _ EB, 1A

?_017:  mov     rax, qword [rbp-10H]                    ; 044F _ 48: 8B. 45, F0
        lea     rdx, [rax*8]                            ; 0453 _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-28H]                    ; 045B _ 48: 8B. 45, D8
        add     rdx, rax                                ; 045F _ 48: 01. C2
        mov     rax, qword [rbp-8H]                     ; 0462 _ 48: 8B. 45, F8
        mov     qword [rdx], rax                        ; 0466 _ 48: 89. 02
?_018:  mov     rax, qword [rbp-20H]                    ; 0469 _ 48: 8B. 45, E0
        cmp     qword [rbp-10H], rax                    ; 046D _ 48: 39. 45, F0
        jl      ?_014                                   ; 0471 _ 0F 8C, FFFFFF33
        nop                                             ; 0477 _ 90
        pop     rbp                                     ; 0478 _ 5D
        ret                                             ; 0479 _ C3

_utstring_BuildTableR:; Local function
        push    rbp                                     ; 047A _ 55
        mov     rbp, rsp                                ; 047B _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 047E _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 0482 _ 48: 89. 75, E0
        mov     qword [rbp-28H], rdx                    ; 0486 _ 48: 89. 55, D8
        mov     rax, qword [rbp-20H]                    ; 048A _ 48: 8B. 45, E0
        sub     rax, 1                                  ; 048E _ 48: 83. E8, 01
        mov     qword [rbp-10H], rax                    ; 0492 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 0496 _ 48: 8B. 45, F0
        add     rax, 1                                  ; 049A _ 48: 83. C0, 01
        mov     qword [rbp-8H], rax                     ; 049E _ 48: 89. 45, F8
        mov     rax, qword [rbp-10H]                    ; 04A2 _ 48: 8B. 45, F0
        add     rax, 1                                  ; 04A6 _ 48: 83. C0, 01
        lea     rdx, [rax*8]                            ; 04AA _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-28H]                    ; 04B2 _ 48: 8B. 45, D8
        add     rdx, rax                                ; 04B6 _ 48: 01. C2
        mov     rax, qword [rbp-8H]                     ; 04B9 _ 48: 8B. 45, F8
        mov     qword [rdx], rax                        ; 04BD _ 48: 89. 02
        jmp     ?_024                                   ; 04C0 _ E9, 000000ED

?_019:  mov     rax, qword [rbp-8H]                     ; 04C5 _ 48: 8B. 45, F8
        add     rax, 1                                  ; 04C9 _ 48: 83. C0, 01
        lea     rdx, [rax*8]                            ; 04CD _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-28H]                    ; 04D5 _ 48: 8B. 45, D8
        add     rax, rdx                                ; 04D9 _ 48: 01. D0
        mov     rax, qword [rax]                        ; 04DC _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 04DF _ 48: 89. 45, F8
?_020:  mov     rax, qword [rbp-20H]                    ; 04E3 _ 48: 8B. 45, E0
        cmp     qword [rbp-8H], rax                     ; 04E7 _ 48: 39. 45, F8
        jge     ?_021                                   ; 04EB _ 7D, 20
        mov     rdx, qword [rbp-10H]                    ; 04ED _ 48: 8B. 55, F0
        mov     rax, qword [rbp-18H]                    ; 04F1 _ 48: 8B. 45, E8
        add     rax, rdx                                ; 04F5 _ 48: 01. D0
        movzx   edx, byte [rax]                         ; 04F8 _ 0F B6. 10
        mov     rcx, qword [rbp-8H]                     ; 04FB _ 48: 8B. 4D, F8
        mov     rax, qword [rbp-18H]                    ; 04FF _ 48: 8B. 45, E8
        add     rax, rcx                                ; 0503 _ 48: 01. C8
        movzx   eax, byte [rax]                         ; 0506 _ 0F B6. 00
        cmp     dl, al                                  ; 0509 _ 38. C2
        jnz     ?_019                                   ; 050B _ 75, B8
?_021:  sub     qword [rbp-10H], 1                      ; 050D _ 48: 83. 6D, F0, 01
        sub     qword [rbp-8H], 1                       ; 0512 _ 48: 83. 6D, F8, 01
        cmp     qword [rbp-10H], 0                      ; 0517 _ 48: 83. 7D, F0, 00
        js      ?_023                                   ; 051C _ 78, 76
        mov     rdx, qword [rbp-10H]                    ; 051E _ 48: 8B. 55, F0
        mov     rax, qword [rbp-18H]                    ; 0522 _ 48: 8B. 45, E8
        add     rax, rdx                                ; 0526 _ 48: 01. D0
        movzx   edx, byte [rax]                         ; 0529 _ 0F B6. 10
        mov     rcx, qword [rbp-8H]                     ; 052C _ 48: 8B. 4D, F8
        mov     rax, qword [rbp-18H]                    ; 0530 _ 48: 8B. 45, E8
        add     rax, rcx                                ; 0534 _ 48: 01. C8
        movzx   eax, byte [rax]                         ; 0537 _ 0F B6. 00
        cmp     dl, al                                  ; 053A _ 38. C2
        jnz     ?_022                                   ; 053C _ 75, 36
        mov     rax, qword [rbp-10H]                    ; 053E _ 48: 8B. 45, F0
        add     rax, 1                                  ; 0542 _ 48: 83. C0, 01
        lea     rdx, [rax*8]                            ; 0546 _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-28H]                    ; 054E _ 48: 8B. 45, D8
        add     rdx, rax                                ; 0552 _ 48: 01. C2
        mov     rax, qword [rbp-8H]                     ; 0555 _ 48: 8B. 45, F8
        add     rax, 1                                  ; 0559 _ 48: 83. C0, 01
        lea     rcx, [rax*8]                            ; 055D _ 48: 8D. 0C C5, 00000000
        mov     rax, qword [rbp-28H]                    ; 0565 _ 48: 8B. 45, D8
        add     rax, rcx                                ; 0569 _ 48: 01. C8
        mov     rax, qword [rax]                        ; 056C _ 48: 8B. 00
        mov     qword [rdx], rax                        ; 056F _ 48: 89. 02
        jmp     ?_024                                   ; 0572 _ EB, 3E

?_022:  mov     rax, qword [rbp-10H]                    ; 0574 _ 48: 8B. 45, F0
        add     rax, 1                                  ; 0578 _ 48: 83. C0, 01
        lea     rdx, [rax*8]                            ; 057C _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-28H]                    ; 0584 _ 48: 8B. 45, D8
        add     rdx, rax                                ; 0588 _ 48: 01. C2
        mov     rax, qword [rbp-8H]                     ; 058B _ 48: 8B. 45, F8
        mov     qword [rdx], rax                        ; 058F _ 48: 89. 02
        jmp     ?_024                                   ; 0592 _ EB, 1E

?_023:  mov     rax, qword [rbp-10H]                    ; 0594 _ 48: 8B. 45, F0
        add     rax, 1                                  ; 0598 _ 48: 83. C0, 01
        lea     rdx, [rax*8]                            ; 059C _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-28H]                    ; 05A4 _ 48: 8B. 45, D8
        add     rdx, rax                                ; 05A8 _ 48: 01. C2
        mov     rax, qword [rbp-8H]                     ; 05AB _ 48: 8B. 45, F8
        mov     qword [rdx], rax                        ; 05AF _ 48: 89. 02
?_024:  cmp     qword [rbp-10H], 0                      ; 05B2 _ 48: 83. 7D, F0, 00
        jns     ?_020                                   ; 05B7 _ 0F 89, FFFFFF26
        nop                                             ; 05BD _ 90
        pop     rbp                                     ; 05BE _ 5D
        ret                                             ; 05BF _ C3

_utstring_find:; Local function
        push    rbp                                     ; 05C0 _ 55
        mov     rbp, rsp                                ; 05C1 _ 48: 89. E5
        mov     qword [rbp-28H], rdi                    ; 05C4 _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 05C8 _ 48: 89. 75, D0
        mov     qword [rbp-38H], rdx                    ; 05CC _ 48: 89. 55, C8
        mov     qword [rbp-40H], rcx                    ; 05D0 _ 48: 89. 4D, C0
        mov     qword [rbp-48H], r8                     ; 05D4 _ 4C: 89. 45, B8
        mov     qword [rbp-8H], -1                      ; 05D8 _ 48: C7. 45, F8, FFFFFFFF
        mov     qword [rbp-10H], 0                      ; 05E0 _ 48: C7. 45, F0, 00000000
        mov     rax, qword [rbp-10H]                    ; 05E8 _ 48: 8B. 45, F0
        mov     qword [rbp-18H], rax                    ; 05EC _ 48: 89. 45, E8
        jmp     ?_028                                   ; 05F0 _ EB, 65

?_025:  mov     rax, qword [rbp-18H]                    ; 05F2 _ 48: 8B. 45, E8
        lea     rdx, [rax*8]                            ; 05F6 _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-48H]                    ; 05FE _ 48: 8B. 45, B8
        add     rax, rdx                                ; 0602 _ 48: 01. D0
        mov     rax, qword [rax]                        ; 0605 _ 48: 8B. 00
        mov     qword [rbp-18H], rax                    ; 0608 _ 48: 89. 45, E8
?_026:  cmp     qword [rbp-18H], 0                      ; 060C _ 48: 83. 7D, E8, 00
        js      ?_027                                   ; 0611 _ 78, 20
        mov     rdx, qword [rbp-18H]                    ; 0613 _ 48: 8B. 55, E8
        mov     rax, qword [rbp-38H]                    ; 0617 _ 48: 8B. 45, C8
        add     rax, rdx                                ; 061B _ 48: 01. D0
        movzx   edx, byte [rax]                         ; 061E _ 0F B6. 10
        mov     rcx, qword [rbp-10H]                    ; 0621 _ 48: 8B. 4D, F0
        mov     rax, qword [rbp-28H]                    ; 0625 _ 48: 8B. 45, D8
        add     rax, rcx                                ; 0629 _ 48: 01. C8
        movzx   eax, byte [rax]                         ; 062C _ 0F B6. 00
        cmp     dl, al                                  ; 062F _ 38. C2
        jnz     ?_025                                   ; 0631 _ 75, BF
?_027:  add     qword [rbp-18H], 1                      ; 0633 _ 48: 83. 45, E8, 01
        add     qword [rbp-10H], 1                      ; 0638 _ 48: 83. 45, F0, 01
        mov     rax, qword [rbp-40H]                    ; 063D _ 48: 8B. 45, C0
        cdqe                                            ; 0641 _ 48: 98
        cmp     rax, qword [rbp-18H]                    ; 0643 _ 48: 3B. 45, E8
        jg      ?_028                                   ; 0647 _ 7F, 0E
        mov     rax, qword [rbp-10H]                    ; 0649 _ 48: 8B. 45, F0
        sub     rax, qword [rbp-18H]                    ; 064D _ 48: 2B. 45, E8
        mov     qword [rbp-8H], rax                     ; 0651 _ 48: 89. 45, F8
        jmp     ?_029                                   ; 0655 _ EB, 24

?_028:  mov     rax, qword [rbp-30H]                    ; 0657 _ 48: 8B. 45, D0
        cdqe                                            ; 065B _ 48: 98
        cmp     rax, qword [rbp-10H]                    ; 065D _ 48: 3B. 45, F0
        jle     ?_029                                   ; 0661 _ 7E, 18
        mov     rax, qword [rbp-10H]                    ; 0663 _ 48: 8B. 45, F0
        mov     rdx, qword [rbp-30H]                    ; 0667 _ 48: 8B. 55, D0
        sub     rdx, rax                                ; 066B _ 48: 29. C2
        mov     rax, qword [rbp-18H]                    ; 066E _ 48: 8B. 45, E8
        add     rax, rdx                                ; 0672 _ 48: 01. D0
        cmp     rax, qword [rbp-40H]                    ; 0675 _ 48: 3B. 45, C0
        jnc     ?_026                                   ; 0679 _ 73, 91
?_029:  mov     rax, qword [rbp-8H]                     ; 067B _ 48: 8B. 45, F8
        pop     rbp                                     ; 067F _ 5D
        ret                                             ; 0680 _ C3

_utstring_findR:; Local function
        push    rbp                                     ; 0681 _ 55
        mov     rbp, rsp                                ; 0682 _ 48: 89. E5
        mov     qword [rbp-28H], rdi                    ; 0685 _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 0689 _ 48: 89. 75, D0
        mov     qword [rbp-38H], rdx                    ; 068D _ 48: 89. 55, C8
        mov     qword [rbp-40H], rcx                    ; 0691 _ 48: 89. 4D, C0
        mov     qword [rbp-48H], r8                     ; 0695 _ 4C: 89. 45, B8
        mov     qword [rbp-8H], -1                      ; 0699 _ 48: C7. 45, F8, FFFFFFFF
        mov     rax, qword [rbp-30H]                    ; 06A1 _ 48: 8B. 45, D0
        sub     rax, 1                                  ; 06A5 _ 48: 83. E8, 01
        mov     qword [rbp-10H], rax                    ; 06A9 _ 48: 89. 45, F0
        mov     rax, qword [rbp-40H]                    ; 06AD _ 48: 8B. 45, C0
        sub     rax, 1                                  ; 06B1 _ 48: 83. E8, 01
        mov     qword [rbp-18H], rax                    ; 06B5 _ 48: 89. 45, E8
        jmp     ?_033                                   ; 06B9 _ EB, 69

?_030:  mov     rax, qword [rbp-18H]                    ; 06BB _ 48: 8B. 45, E8
        add     rax, 1                                  ; 06BF _ 48: 83. C0, 01
        lea     rdx, [rax*8]                            ; 06C3 _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-48H]                    ; 06CB _ 48: 8B. 45, B8
        add     rax, rdx                                ; 06CF _ 48: 01. D0
        mov     rax, qword [rax]                        ; 06D2 _ 48: 8B. 00
        mov     qword [rbp-18H], rax                    ; 06D5 _ 48: 89. 45, E8
?_031:  mov     rax, qword [rbp-40H]                    ; 06D9 _ 48: 8B. 45, C0
        cdqe                                            ; 06DD _ 48: 98
        cmp     rax, qword [rbp-18H]                    ; 06DF _ 48: 3B. 45, E8
        jle     ?_032                                   ; 06E3 _ 7E, 20
        mov     rdx, qword [rbp-18H]                    ; 06E5 _ 48: 8B. 55, E8
        mov     rax, qword [rbp-38H]                    ; 06E9 _ 48: 8B. 45, C8
        add     rax, rdx                                ; 06ED _ 48: 01. D0
        movzx   edx, byte [rax]                         ; 06F0 _ 0F B6. 10
        mov     rcx, qword [rbp-10H]                    ; 06F3 _ 48: 8B. 4D, F0
        mov     rax, qword [rbp-28H]                    ; 06F7 _ 48: 8B. 45, D8
        add     rax, rcx                                ; 06FB _ 48: 01. C8
        movzx   eax, byte [rax]                         ; 06FE _ 0F B6. 00
        cmp     dl, al                                  ; 0701 _ 38. C2
        jnz     ?_030                                   ; 0703 _ 75, B6
?_032:  sub     qword [rbp-18H], 1                      ; 0705 _ 48: 83. 6D, E8, 01
        sub     qword [rbp-10H], 1                      ; 070A _ 48: 83. 6D, F0, 01
        cmp     qword [rbp-18H], 0                      ; 070F _ 48: 83. 7D, E8, 00
        jns     ?_033                                   ; 0714 _ 79, 0E
        mov     rax, qword [rbp-10H]                    ; 0716 _ 48: 8B. 45, F0
        add     rax, 1                                  ; 071A _ 48: 83. C0, 01
        mov     qword [rbp-8H], rax                     ; 071E _ 48: 89. 45, F8
        jmp     ?_034                                   ; 0722 _ EB, 11

?_033:  cmp     qword [rbp-10H], 0                      ; 0724 _ 48: 83. 7D, F0, 00
        js      ?_034                                   ; 0729 _ 78, 0A
        mov     rax, qword [rbp-10H]                    ; 072B _ 48: 8B. 45, F0
        cmp     rax, qword [rbp-18H]                    ; 072F _ 48: 3B. 45, E8
        jge     ?_031                                   ; 0733 _ 7D, A4
?_034:  mov     rax, qword [rbp-8H]                     ; 0735 _ 48: 8B. 45, F8
        pop     rbp                                     ; 0739 _ 5D
        ret                                             ; 073A _ C3

utstring_find:; Local function
        push    rbp                                     ; 073B _ 55
        mov     rbp, rsp                                ; 073C _ 48: 89. E5
        sub     rsp, 64                                 ; 073F _ 48: 83. EC, 40
        mov     qword [rbp-28H], rdi                    ; 0743 _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 0747 _ 48: 89. 75, D0
        mov     qword [rbp-38H], rdx                    ; 074B _ 48: 89. 55, C8
        mov     qword [rbp-40H], rcx                    ; 074F _ 48: 89. 4D, C0
        mov     qword [rbp-18H], -1                     ; 0753 _ 48: C7. 45, E8, FFFFFFFF
        cmp     qword [rbp-30H], 0                      ; 075B _ 48: 83. 7D, D0, 00
        jns     ?_035                                   ; 0760 _ 79, 15
        mov     rax, qword [rbp-28H]                    ; 0762 _ 48: 8B. 45, D8
        mov     rdx, qword [rax+10H]                    ; 0766 _ 48: 8B. 50, 10
        mov     rax, qword [rbp-30H]                    ; 076A _ 48: 8B. 45, D0
        add     rax, rdx                                ; 076E _ 48: 01. D0
        mov     qword [rbp-20H], rax                    ; 0771 _ 48: 89. 45, E0
        jmp     ?_036                                   ; 0775 _ EB, 08

?_035:  mov     rax, qword [rbp-30H]                    ; 0777 _ 48: 8B. 45, D0
        mov     qword [rbp-20H], rax                    ; 077B _ 48: 89. 45, E0
?_036:  mov     rax, qword [rbp-28H]                    ; 077F _ 48: 8B. 45, D8
        mov     rdx, qword [rax+10H]                    ; 0783 _ 48: 8B. 50, 10
        mov     rax, qword [rbp-20H]                    ; 0787 _ 48: 8B. 45, E0
        sub     rdx, rax                                ; 078B _ 48: 29. C2
        mov     rax, rdx                                ; 078E _ 48: 89. D0
        mov     qword [rbp-10H], rax                    ; 0791 _ 48: 89. 45, F0
        mov     rax, qword [rbp-40H]                    ; 0795 _ 48: 8B. 45, C0
        cmp     qword [rbp-10H], rax                    ; 0799 _ 48: 39. 45, F0
        jl      ?_038                                   ; 079D _ 0F 8C, 00000086
        cmp     qword [rbp-40H], 0                      ; 07A3 _ 48: 83. 7D, C0, 00
        jz      ?_038                                   ; 07A8 _ 74, 7F
        mov     rax, qword [rbp-40H]                    ; 07AA _ 48: 8B. 45, C0
        add     rax, 1                                  ; 07AE _ 48: 83. C0, 01
        shl     rax, 3                                  ; 07B2 _ 48: C1. E0, 03
        mov     rdi, rax                                ; 07B6 _ 48: 89. C7
        call    malloc                                  ; 07B9 _ E8, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 07BE _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 07C2 _ 48: 83. 7D, F8, 00
        jz      ?_038                                   ; 07C7 _ 74, 60
        mov     rdx, qword [rbp-8H]                     ; 07C9 _ 48: 8B. 55, F8
        mov     rcx, qword [rbp-40H]                    ; 07CD _ 48: 8B. 4D, C0
        mov     rax, qword [rbp-38H]                    ; 07D1 _ 48: 8B. 45, C8
        mov     rsi, rcx                                ; 07D5 _ 48: 89. CE
        mov     rdi, rax                                ; 07D8 _ 48: 89. C7
        call    _utstring_BuildTable                    ; 07DB _ E8, FFFFFB6D
        mov     rax, qword [rbp-10H]                    ; 07E0 _ 48: 8B. 45, F0
        mov     rdx, qword [rbp-28H]                    ; 07E4 _ 48: 8B. 55, D8
        mov     rcx, qword [rdx]                        ; 07E8 _ 48: 8B. 0A
        mov     rdx, qword [rbp-20H]                    ; 07EB _ 48: 8B. 55, E0
        lea     rdi, [rcx+rdx]                          ; 07EF _ 48: 8D. 3C 11
        mov     rsi, qword [rbp-8H]                     ; 07F3 _ 48: 8B. 75, F8
        mov     rcx, qword [rbp-40H]                    ; 07F7 _ 48: 8B. 4D, C0
        mov     rdx, qword [rbp-38H]                    ; 07FB _ 48: 8B. 55, C8
        mov     r8, rsi                                 ; 07FF _ 49: 89. F0
        mov     rsi, rax                                ; 0802 _ 48: 89. C6
        call    _utstring_find                          ; 0805 _ E8, FFFFFDB6
        mov     qword [rbp-18H], rax                    ; 080A _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 080E _ 48: 83. 7D, E8, 00
        js      ?_037                                   ; 0813 _ 78, 08
        mov     rax, qword [rbp-20H]                    ; 0815 _ 48: 8B. 45, E0
        add     qword [rbp-18H], rax                    ; 0819 _ 48: 01. 45, E8
?_037:  mov     rax, qword [rbp-8H]                     ; 081D _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0821 _ 48: 89. C7
        call    free                                    ; 0824 _ E8, 00000000(rel)
?_038:  mov     rax, qword [rbp-18H]                    ; 0829 _ 48: 8B. 45, E8
        leave                                           ; 082D _ C9
        ret                                             ; 082E _ C3

utstring_findR:; Local function
        push    rbp                                     ; 082F _ 55
        mov     rbp, rsp                                ; 0830 _ 48: 89. E5
        sub     rsp, 64                                 ; 0833 _ 48: 83. EC, 40
        mov     qword [rbp-28H], rdi                    ; 0837 _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 083B _ 48: 89. 75, D0
        mov     qword [rbp-38H], rdx                    ; 083F _ 48: 89. 55, C8
        mov     qword [rbp-40H], rcx                    ; 0843 _ 48: 89. 4D, C0
        mov     qword [rbp-18H], -1                     ; 0847 _ 48: C7. 45, E8, FFFFFFFF
        cmp     qword [rbp-30H], 0                      ; 084F _ 48: 83. 7D, D0, 00
        jns     ?_039                                   ; 0854 _ 79, 15
        mov     rax, qword [rbp-28H]                    ; 0856 _ 48: 8B. 45, D8
        mov     rdx, qword [rax+10H]                    ; 085A _ 48: 8B. 50, 10
        mov     rax, qword [rbp-30H]                    ; 085E _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0862 _ 48: 01. D0
        mov     qword [rbp-20H], rax                    ; 0865 _ 48: 89. 45, E0
        jmp     ?_040                                   ; 0869 _ EB, 08

?_039:  mov     rax, qword [rbp-30H]                    ; 086B _ 48: 8B. 45, D0
        mov     qword [rbp-20H], rax                    ; 086F _ 48: 89. 45, E0
?_040:  mov     rax, qword [rbp-20H]                    ; 0873 _ 48: 8B. 45, E0
        add     rax, 1                                  ; 0877 _ 48: 83. C0, 01
        mov     qword [rbp-10H], rax                    ; 087B _ 48: 89. 45, F0
        mov     rax, qword [rbp-40H]                    ; 087F _ 48: 8B. 45, C0
        cmp     qword [rbp-10H], rax                    ; 0883 _ 48: 39. 45, F0
        jl      ?_041                                   ; 0887 _ 7C, 6F
        cmp     qword [rbp-40H], 0                      ; 0889 _ 48: 83. 7D, C0, 00
        jz      ?_041                                   ; 088E _ 74, 68
        mov     rax, qword [rbp-40H]                    ; 0890 _ 48: 8B. 45, C0
        add     rax, 1                                  ; 0894 _ 48: 83. C0, 01
        shl     rax, 3                                  ; 0898 _ 48: C1. E0, 03
        mov     rdi, rax                                ; 089C _ 48: 89. C7
        call    malloc                                  ; 089F _ E8, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 08A4 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 08A8 _ 48: 83. 7D, F8, 00
        jz      ?_041                                   ; 08AD _ 74, 49
        mov     rdx, qword [rbp-8H]                     ; 08AF _ 48: 8B. 55, F8
        mov     rcx, qword [rbp-40H]                    ; 08B3 _ 48: 8B. 4D, C0
        mov     rax, qword [rbp-38H]                    ; 08B7 _ 48: 8B. 45, C8
        mov     rsi, rcx                                ; 08BB _ 48: 89. CE
        mov     rdi, rax                                ; 08BE _ 48: 89. C7
        call    _utstring_BuildTableR                   ; 08C1 _ E8, FFFFFBB4
        mov     rsi, qword [rbp-10H]                    ; 08C6 _ 48: 8B. 75, F0
        mov     rax, qword [rbp-28H]                    ; 08CA _ 48: 8B. 45, D8
        mov     rax, qword [rax]                        ; 08CE _ 48: 8B. 00
        mov     rdi, qword [rbp-8H]                     ; 08D1 _ 48: 8B. 7D, F8
        mov     rcx, qword [rbp-40H]                    ; 08D5 _ 48: 8B. 4D, C0
        mov     rdx, qword [rbp-38H]                    ; 08D9 _ 48: 8B. 55, C8
        mov     r8, rdi                                 ; 08DD _ 49: 89. F8
        mov     rdi, rax                                ; 08E0 _ 48: 89. C7
        call    _utstring_findR                         ; 08E3 _ E8, FFFFFD99
        mov     qword [rbp-18H], rax                    ; 08E8 _ 48: 89. 45, E8
        mov     rax, qword [rbp-8H]                     ; 08EC _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 08F0 _ 48: 89. C7
        call    free                                    ; 08F3 _ E8, 00000000(rel)
?_041:  mov     rax, qword [rbp-18H]                    ; 08F8 _ 48: 8B. 45, E8
        leave                                           ; 08FC _ C9
        ret                                             ; 08FD _ C3

end_clock:; Function begin
        push    rbp                                     ; 08FE _ 55
        mov     rbp, rsp                                ; 08FF _ 48: 89. E5
        call    clock                                   ; 0902 _ E8, 00000000(rel)
        mov     qword [rel prog_end], rax               ; 0907 _ 48: 89. 05, 00000000(rel)
        mov     rdx, qword [rel prog_end]               ; 090E _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel prog_start]             ; 0915 _ 48: 8B. 05, 00000000(rel)
        sub     rdx, rax                                ; 091C _ 48: 29. C2
        mov     rax, rdx                                ; 091F _ 48: 89. D0
        pxor    xmm0, xmm0                              ; 0922 _ 66: 0F EF. C0
        cvtsi2sd xmm0, rax                              ; 0926 _ F2 48: 0F 2A. C0
        movsd   xmm1, qword [rel ?_064]                 ; 092B _ F2: 0F 10. 0D, 00000000(rel)
        divsd   xmm0, xmm1                              ; 0933 _ F2: 0F 5E. C1
        movsd   qword [rel run_time], xmm0              ; 0937 _ F2: 0F 11. 05, 00000000(rel)
        nop                                             ; 093F _ 90
        pop     rbp                                     ; 0940 _ 5D
        ret                                             ; 0941 _ C3
; end_clock End of function

main:   ; Function begin
        push    rbp                                     ; 0942 _ 55
        mov     rbp, rsp                                ; 0943 _ 48: 89. E5
        sub     rsp, 48                                 ; 0946 _ 48: 83. EC, 30
        mov     dword [rbp-24H], edi                    ; 094A _ 89. 7D, DC
        mov     qword [rbp-30H], rsi                    ; 094D _ 48: 89. 75, D0
        call    clock                                   ; 0951 _ E8, 00000000(rel)
        mov     qword [rel prog_start], rax             ; 0956 _ 48: 89. 05, 00000000(rel)
        mov     rdx, qword [rbp-30H]                    ; 095D _ 48: 8B. 55, D0
        mov     eax, dword [rbp-24H]                    ; 0961 _ 8B. 45, DC
        mov     rsi, rdx                                ; 0964 _ 48: 89. D6
        mov     edi, eax                                ; 0967 _ 89. C7
        call    do_options                              ; 0969 _ E8, 00000000(rel)
        mov     dword [rbp-14H], eax                    ; 096E _ 89. 45, EC
        cmp     dword [rbp-14H], 0                      ; 0971 _ 83. 7D, EC, 00
        jne     ?_054                                   ; 0975 _ 0F 85, 000002B0
        call    init                                    ; 097B _ E8, 00000000(rel)
        call    init_mem                                ; 0980 _ E8, 00000000(rel)
        mov     eax, dword [rel opt_stip]               ; 0985 _ 8B. 05, 00000000(rel)
        cmp     eax, 3                                  ; 098B _ 83. F8, 03
        jnz     ?_042                                   ; 098E _ 75, 10
        mov     edi, 0                                  ; 0990 _ BF, 00000000
        call    setup_diagram                           ; 0995 _ E8, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 099A _ 48: 89. 45, F0
        jmp     ?_043                                   ; 099E _ EB, 0E

?_042:  mov     edi, 1                                  ; 09A0 _ BF, 00000001
        call    setup_diagram                           ; 09A5 _ E8, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 09AA _ 48: 89. 45, F0
?_043:  mov     rax, qword [rbp-10H]                    ; 09AE _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 09B2 _ 48: 89. C7
        call    validate_board                          ; 09B5 _ E8, 00000000(rel)
        mov     dword [rbp-14H], eax                    ; 09BA _ 89. 45, EC
        cmp     dword [rbp-14H], 0                      ; 09BD _ 83. 7D, EC, 00
        jne     ?_053                                   ; 09C1 _ 0F 85, 000001FD
        mov     eax, dword [rel opt_stip]               ; 09C7 _ 8B. 05, 00000000(rel)
        cmp     eax, 1                                  ; 09CD _ 83. F8, 01
        je      ?_049                                   ; 09D0 _ 0F 84, 0000014E
        cmp     eax, 1                                  ; 09D6 _ 83. F8, 01
        jc      ?_044                                   ; 09D9 _ 72, 17
        cmp     eax, 2                                  ; 09DB _ 83. F8, 02
        je      ?_050                                   ; 09DE _ 0F 84, 00000168
        cmp     eax, 3                                  ; 09E4 _ 83. F8, 03
        je      ?_051                                   ; 09E7 _ 0F 84, 00000187
        jmp     ?_052                                   ; 09ED _ E9, 000001AA

?_044:  mov     esi, 48                                 ; 09F2 _ BE, 00000030
        mov     edi, 1                                  ; 09F7 _ BF, 00000001
        call    calloc                                  ; 09FC _ E8, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 0A01 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 0A05 _ 48: 83. 7D, F8, 00
        jnz     ?_045                                   ; 0A0A _ 75, 2D
        mov     rax, qword [rel stderr]                 ; 0A0C _ 48: 8B. 05, 00000000(rel)
        mov     ecx, 63                                 ; 0A13 _ B9, 0000003F
        mov     edx, ?_057                              ; 0A18 _ BA, 00000000(d)
        mov     esi, ?_058                              ; 0A1D _ BE, 00000000(d)
        mov     rdi, rax                                ; 0A22 _ 48: 89. C7
        mov     eax, 0                                  ; 0A25 _ B8, 00000000
        call    fprintf                                 ; 0A2A _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0A2F _ BF, 00000001
        call    exit                                    ; 0A34 _ E8, 00000000(rel)
?_045:  mov     rdx, qword [rbp-10H]                    ; 0A39 _ 48: 8B. 55, F0
        mov     rax, qword [rbp-8H]                     ; 0A3D _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 0A41 _ 48: 89. D6
        mov     rdi, rax                                ; 0A44 _ 48: 89. C7
        call    solve_direct                            ; 0A47 _ E8, 00000000(rel)
        call    start_dir                               ; 0A4C _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 0A51 _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 0A55 _ 48: 8B. 00
        test    rax, rax                                ; 0A58 _ 48: 85. C0
        jz      ?_046                                   ; 0A5B _ 74, 1E
        mov     rax, qword [rbp-8H]                     ; 0A5D _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 0A61 _ 48: 8B. 00
        mov     rdi, rax                                ; 0A64 _ 48: 89. C7
        call    add_dir_set                             ; 0A67 _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 0A6C _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 0A70 _ 48: 8B. 00
        mov     rdi, rax                                ; 0A73 _ 48: 89. C7
        call    freeBoardlist                           ; 0A76 _ E8, 00000000(rel)
?_046:  mov     rax, qword [rbp-8H]                     ; 0A7B _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 0A7F _ 48: 8B. 40, 08
        test    rax, rax                                ; 0A83 _ 48: 85. C0
        jz      ?_047                                   ; 0A86 _ 74, 20
        mov     rax, qword [rbp-8H]                     ; 0A88 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 0A8C _ 48: 8B. 40, 08
        mov     rdi, rax                                ; 0A90 _ 48: 89. C7
        call    add_dir_tries                           ; 0A93 _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 0A98 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 0A9C _ 48: 8B. 40, 08
        mov     rdi, rax                                ; 0AA0 _ 48: 89. C7
        call    freeBoardlist                           ; 0AA3 _ E8, 00000000(rel)
?_047:  mov     rax, qword [rbp-8H]                     ; 0AA8 _ 48: 8B. 45, F8
        mov     rax, qword [rax+10H]                    ; 0AAC _ 48: 8B. 40, 10
        test    rax, rax                                ; 0AB0 _ 48: 85. C0
        jz      ?_048                                   ; 0AB3 _ 74, 20
        mov     rax, qword [rbp-8H]                     ; 0AB5 _ 48: 8B. 45, F8
        mov     rax, qword [rax+10H]                    ; 0AB9 _ 48: 8B. 40, 10
        mov     rdi, rax                                ; 0ABD _ 48: 89. C7
        call    add_dir_keys                            ; 0AC0 _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 0AC5 _ 48: 8B. 45, F8
        mov     rax, qword [rax+10H]                    ; 0AC9 _ 48: 8B. 40, 10
        mov     rdi, rax                                ; 0ACD _ 48: 89. C7
        call    freeBoardlist                           ; 0AD0 _ E8, 00000000(rel)
?_048:  call    add_dir_options                         ; 0AD5 _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 0ADA _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0ADE _ 48: 89. C7
        call    add_dir_stats                           ; 0AE1 _ E8, 00000000(rel)
        call    end_clock                               ; 0AE6 _ E8, 00000000(rel)
        mov     rax, qword [rel run_time]               ; 0AEB _ 48: 8B. 05, 00000000(rel)
        movq    xmm0, rax                               ; 0AF2 _ 66 48: 0F 6E. C0
        call    time_dir                                ; 0AF7 _ E8, 00000000(rel)
        call    end_dir                                 ; 0AFC _ E8, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 0B01 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0B05 _ 48: 89. C7
        call    free                                    ; 0B08 _ E8, 00000000(rel)
        mov     rax, qword [rbp-10H]                    ; 0B0D _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0B11 _ 48: 89. C7
        call    freeBoard                               ; 0B14 _ E8, 00000000(rel)
        nop                                             ; 0B19 _ 90
        call    close_mem                               ; 0B1A _ E8, 00000000(rel)
        jmp     ?_054                                   ; 0B1F _ E9, 00000107

?_049:  mov     rax, qword [rel stderr]                 ; 0B24 _ 48: 8B. 05, 00000000(rel)
        mov     rcx, rax                                ; 0B2B _ 48: 89. C1
        mov     edx, 41                                 ; 0B2E _ BA, 00000029
        mov     esi, 1                                  ; 0B33 _ BE, 00000001
        mov     edi, ?_059                              ; 0B38 _ BF, 00000000(d)
        call    fwrite                                  ; 0B3D _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0B42 _ BF, 00000001
        call    exit                                    ; 0B47 _ E8, 00000000(rel)
?_050:  mov     rax, qword [rel stderr]                 ; 0B4C _ 48: 8B. 05, 00000000(rel)
        mov     rcx, rax                                ; 0B53 _ 48: 89. C1
        mov     edx, 43                                 ; 0B56 _ BA, 0000002B
        mov     esi, 1                                  ; 0B5B _ BE, 00000001
        mov     edi, ?_060                              ; 0B60 _ BF, 00000000(d)
        call    fwrite                                  ; 0B65 _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0B6A _ BF, 00000001
        call    exit                                    ; 0B6F _ E8, 00000000(rel)
?_051:  mov     rax, qword [rel stderr]                 ; 0B74 _ 48: 8B. 05, 00000000(rel)
        mov     rcx, rax                                ; 0B7B _ 48: 89. C1
        mov     edx, 41                                 ; 0B7E _ BA, 00000029
        mov     esi, 1                                  ; 0B83 _ BE, 00000001
        mov     edi, ?_061                              ; 0B88 _ BF, 00000000(d)
        call    fwrite                                  ; 0B8D _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0B92 _ BF, 00000001
        call    exit                                    ; 0B97 _ E8, 00000000(rel)
?_052:  mov     rax, qword [rel stderr]                 ; 0B9C _ 48: 8B. 05, 00000000(rel)
        mov     rcx, rax                                ; 0BA3 _ 48: 89. C1
        mov     edx, 47                                 ; 0BA6 _ BA, 0000002F
        mov     esi, 1                                  ; 0BAB _ BE, 00000001
        mov     edi, ?_062                              ; 0BB0 _ BF, 00000000(d)
        call    fwrite                                  ; 0BB5 _ E8, 00000000(rel)
        mov     edi, 1                                  ; 0BBA _ BF, 00000001
        call    exit                                    ; 0BBF _ E8, 00000000(rel)
?_053:  call    close_mem                               ; 0BC4 _ E8, 00000000(rel)
        call    clock                                   ; 0BC9 _ E8, 00000000(rel)
        mov     qword [rel prog_end], rax               ; 0BCE _ 48: 89. 05, 00000000(rel)
        mov     rdx, qword [rel prog_end]               ; 0BD5 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel prog_start]             ; 0BDC _ 48: 8B. 05, 00000000(rel)
        sub     rdx, rax                                ; 0BE3 _ 48: 29. C2
        mov     rax, rdx                                ; 0BE6 _ 48: 89. D0
        pxor    xmm0, xmm0                              ; 0BE9 _ 66: 0F EF. C0
        cvtsi2sd xmm0, rax                              ; 0BED _ F2 48: 0F 2A. C0
        movsd   xmm1, qword [rel ?_064]                 ; 0BF2 _ F2: 0F 10. 0D, 00000000(rel)
        divsd   xmm0, xmm1                              ; 0BFA _ F2: 0F 5E. C1
        movsd   qword [rel run_time], xmm0              ; 0BFE _ F2: 0F 11. 05, 00000000(rel)
        mov     rdx, qword [rel run_time]               ; 0C06 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel stderr]                 ; 0C0D _ 48: 8B. 05, 00000000(rel)
        movq    xmm0, rdx                               ; 0C14 _ 66 48: 0F 6E. C2
        mov     esi, ?_063                              ; 0C19 _ BE, 00000000(d)
        mov     rdi, rax                                ; 0C1E _ 48: 89. C7
        mov     eax, 1                                  ; 0C21 _ B8, 00000001
        call    fprintf                                 ; 0C26 _ E8, 00000000(rel)
?_054:  mov     eax, dword [rbp-14H]                    ; 0C2B _ 8B. 45, EC
        leave                                           ; 0C2E _ C9
        ret                                             ; 0C2F _ C3
; main End of function

tzcount:; Function begin
        push    rbp                                     ; 0C30 _ 55
        mov     rbp, rsp                                ; 0C31 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0C34 _ 48: 89. 7D, F8
        cmp     qword [rbp-8H], 0                       ; 0C38 _ 48: 83. 7D, F8, 00
        jnz     ?_055                                   ; 0C3D _ 75, 07
        mov     eax, 64                                 ; 0C3F _ B8, 00000040
        jmp     ?_056                                   ; 0C44 _ EB, 05

?_055:  bsf     rax, qword [rbp-8H]                     ; 0C46 _ 48: 0F BC. 45, F8
?_056:  pop     rbp                                     ; 0C4B _ 5D
        ret                                             ; 0C4C _ C3
; tzcount End of function


SECTION .data   align=1 noexecute                       ; section number 2, data


SECTION .bss    align=8 noexecute                       ; section number 3, bss

prog_start:                                             ; qword
        resq    1                                       ; 0000

prog_end: resq  1                                       ; 0008

run_time: resq  1                                       ; 0010


SECTION .rodata align=32 noexecute                      ; section number 4, const

ut_str_icd:                                             ; yword
        db 08H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0008 _ ........
        dq utarray_str_cpy                              ; 0010 _ 0000000000000000 (d)
        dq utarray_str_dtor                             ; 0018 _ 0000000000000000 (d)

ut_int_icd:                                             ; yword
        db 04H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0020 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0030 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0038 _ ........

ut_ptr_icd:                                             ; yword
        db 08H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0040 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0048 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0050 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0058 _ ........

?_057:                                                  ; byte
        db 6DH, 61H, 69H, 6EH, 2EH, 63H, 00H            ; 0060 _ main.c.

?_058:                                                  ; byte
        db 4FH, 55H, 54H, 20H, 4FH, 46H, 20H, 4DH       ; 0067 _ OUT OF M
        db 45H, 4DH, 4FH, 52H, 59H, 20H, 61H, 74H       ; 006F _ EMORY at
        db 20H, 25H, 73H, 28H, 25H, 64H, 29H, 0AH       ; 0077 _  %s(%d).
        db 00H                                          ; 007F _ .

?_059:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 0080 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 43H       ; 0088 _ ERROR: C
        db 61H, 6EH, 27H, 74H, 20H, 73H, 6FH, 6CH       ; 0090 _ an't sol
        db 76H, 65H, 20H, 73H, 65H, 6CH, 66H, 6DH       ; 0098 _ ve selfm
        db 61H, 74H, 65H, 73H, 20H, 79H, 65H, 74H       ; 00A0 _ ates yet
        db 21H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00A8 _ !.......

?_060:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 00B0 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 43H       ; 00B8 _ ERROR: C
        db 61H, 6EH, 27H, 74H, 20H, 73H, 6FH, 6CH       ; 00C0 _ an't sol
        db 76H, 65H, 20H, 72H, 65H, 66H, 6CH, 65H       ; 00C8 _ ve refle
        db 78H, 6DH, 61H, 74H, 65H, 73H, 20H, 79H       ; 00D0 _ xmates y
        db 65H, 74H, 21H, 00H, 00H, 00H, 00H, 00H       ; 00D8 _ et!.....

?_061:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 00E0 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 43H       ; 00E8 _ ERROR: C
        db 61H, 6EH, 27H, 74H, 20H, 73H, 6FH, 6CH       ; 00F0 _ an't sol
        db 76H, 65H, 20H, 68H, 65H, 6CH, 70H, 6DH       ; 00F8 _ ve helpm
        db 61H, 74H, 65H, 73H, 20H, 79H, 65H, 74H       ; 0100 _ ates yet
        db 21H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0108 _ !.......

?_062:                                                  ; byte
        db 73H, 65H, 6EH, 67H, 69H, 6EH, 65H, 20H       ; 0110 _ sengine 
        db 45H, 52H, 52H, 4FH, 52H, 3AH, 20H, 69H       ; 0118 _ ERROR: i
        db 6DH, 70H, 6FH, 73H, 73H, 69H, 62H, 6CH       ; 0120 _ mpossibl
        db 65H, 20H, 69H, 6EH, 76H, 61H, 6CH, 69H       ; 0128 _ e invali
        db 64H, 20H, 73H, 74H, 69H, 70H, 75H, 6CH       ; 0130 _ d stipul
        db 61H, 74H, 69H, 6FH, 6EH, 21H, 21H, 00H       ; 0138 _ ation!!.

?_063:                                                  ; byte
        db 52H, 75H, 6EH, 6EH, 69H, 6EH, 67H, 20H       ; 0140 _ Running 
        db 54H, 69H, 6DH, 65H, 20H, 3DH, 20H, 25H       ; 0148 _ Time = %
        db 66H, 0AH, 00H, 00H, 00H, 00H, 00H, 00H       ; 0150 _ f.......

?_064:  dq 412E848000000000H                            ; 0158 _ 1000000.0 


SECTION .eh_frame align=8 noexecute                     ; section number 5, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 78H, 10H, 01H       ; 0008 _ .zR..x..
        db 1BH, 0CH, 07H, 08H, 90H, 01H, 00H, 00H       ; 0010 _ ........
        db 1CH, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd utarray_str_cpy-$-20H                        ; 0020 _ 00000000 (rel)
        dd 0000004FH, 100E4100H                         ; 0024 _ 79 269369600 
        dd 0D430286H, 0C4A0206H                         ; 002C _ 222495366 206176774 
        dd 00000807H, 0000001CH                         ; 0034 _ 2055 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd utarray_str_cpy-$+0FH                        ; 0040 _ 00000000 (rel)
        dd 00000032H, 100E4100H                         ; 0044 _ 50 269369600 
        dd 0D430286H, 070C6D06H                         ; 004C _ 222495366 118254854 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd utarray_str_cpy-$+21H                        ; 0060 _ 00000000 (rel)
        dd 000001FAH, 100E4100H                         ; 0064 _ 506 269369600 
        dd 0D430286H, 01F50306H                         ; 006C _ 222495366 32834310 
        dd 0008070CH, 0000001CH                         ; 0074 _ 526092 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd utarray_str_cpy-$+1FBH                       ; 0080 _ 00000000 (rel)
        dd 000000D2H, 100E4100H                         ; 0084 _ 210 269369600 
        dd 0D430286H, 0CCD0206H                         ; 008C _ 222495366 214761990 
        dd 00000807H, 0000001CH                         ; 0094 _ 2055 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd utarray_str_cpy-$+2ADH                       ; 00A0 _ 00000000 (rel)
        dd 0000012DH, 100E4100H                         ; 00A4 _ 301 269369600 
        dd 0D430286H, 01280306H                         ; 00AC _ 222495366 19399430 
        dd 0008070CH, 0000001CH                         ; 00B4 _ 526092 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd utarray_str_cpy-$+3BAH                       ; 00C0 _ 00000000 (rel)
        dd 00000146H, 100E4100H                         ; 00C4 _ 326 269369600 
        dd 0D430286H, 01410306H                         ; 00CC _ 222495366 21037830 
        dd 0008070CH, 0000001CH                         ; 00D4 _ 526092 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd utarray_str_cpy-$+4E0H                       ; 00E0 _ 00000000 (rel)
        dd 000000C1H, 100E4100H                         ; 00E4 _ 193 269369600 
        dd 0D430286H, 0CBC0206H                         ; 00EC _ 222495366 213647878 
        dd 00000807H, 0000001CH                         ; 00F4 _ 2055 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd utarray_str_cpy-$+581H                       ; 0100 _ 00000000 (rel)
        dd 000000BAH, 100E4100H                         ; 0104 _ 186 269369600 
        dd 0D430286H, 0CB50206H                         ; 010C _ 222495366 213189126 
        dd 00000807H, 0000001CH                         ; 0114 _ 2055 28 
        dd 0000011CH                                    ; 011C _ 284 
        dd utarray_str_cpy-$+61BH                       ; 0120 _ 00000000 (rel)
        dd 000000F4H, 100E4100H                         ; 0124 _ 244 269369600 
        dd 0D430286H, 0CEF0206H                         ; 012C _ 222495366 216990214 
        dd 00000807H, 0000001CH                         ; 0134 _ 2055 28 
        dd 0000013CH                                    ; 013C _ 316 
        dd utarray_str_cpy-$+6EFH                       ; 0140 _ 00000000 (rel)
        dd 000000CFH, 100E4100H                         ; 0144 _ 207 269369600 
        dd 0D430286H, 0CCA0206H                         ; 014C _ 222495366 214565382 
        dd 00000807H, 0000001CH                         ; 0154 _ 2055 28 
        dd 0000015CH                                    ; 015C _ 348 
        dd utarray_str_cpy-$+79EH                       ; 0160 _ 00000000 (rel)
        dd 00000044H, 100E4100H                         ; 0164 _ 68 269369600 
        dd 0D430286H, 070C7F06H                         ; 016C _ 222495366 118259462 
        dd 00000008H, 0000001CH                         ; 0174 _ 8 28 
        dd 0000017CH                                    ; 017C _ 380 
        dd utarray_str_cpy-$+7C2H                       ; 0180 _ 00000000 (rel)
        dd 000002EEH, 100E4100H                         ; 0184 _ 750 269369600 
        dd 0D430286H, 02E90306H                         ; 018C _ 222495366 48825094 
        dd 0008070CH, 0000001CH                         ; 0194 _ 526092 28 
        dd 0000019CH                                    ; 019C _ 412 
        dd utarray_str_cpy-$+0A90H                      ; 01A0 _ 00000000 (rel)
        dd 0000001DH, 100E4100H                         ; 01A4 _ 29 269369600 
        dd 0D430286H, 070C5806H                         ; 01AC _ 222495366 118249478 
        dd 00000008H                                    ; 01B4 _ 8 


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
; Error: Relocation number 26 has a non-existing source address. Section: 0 Offset: 000000D8H
; Error: Relocation number 27 has a non-existing source address. Section: 0 Offset: 000000E4H
; Error: Relocation number 28 has a non-existing source address. Section: 0 Offset: 000000F0H
; Error: Relocation number 29 has a non-existing source address. Section: 0 Offset: 000000FCH
; Error: Relocation number 30 has a non-existing source address. Section: 0 Offset: 00000107H
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
; Error: Relocation number 58 has a non-existing source address. Section: 0 Offset: 0000025CH
; Error: Relocation number 59 has a non-existing source address. Section: 0 Offset: 00000269H
; Error: Relocation number 60 has a non-existing source address. Section: 0 Offset: 00000270H
; Error: Relocation number 61 has a non-existing source address. Section: 0 Offset: 0000027CH
; Error: Relocation number 62 has a non-existing source address. Section: 0 Offset: 00000288H
; Error: Relocation number 63 has a non-existing source address. Section: 0 Offset: 00000294H
; Error: Relocation number 64 has a non-existing source address. Section: 0 Offset: 000002DEH
; Error: Relocation number 65 has a non-existing source address. Section: 0 Offset: 000002EBH
; Error: Relocation number 66 has a non-existing source address. Section: 0 Offset: 000002F0H
; Error: Relocation number 67 has a non-existing source address. Section: 0 Offset: 000002FDH
; Error: Relocation number 68 has a non-existing source address. Section: 0 Offset: 00000309H
; Error: Relocation number 69 has a non-existing source address. Section: 0 Offset: 00000314H
; Error: Relocation number 70 has a non-existing source address. Section: 0 Offset: 0000032FH
; Error: Relocation number 71 has a non-existing source address. Section: 0 Offset: 00000345H
; Error: Relocation number 72 has a non-existing source address. Section: 0 Offset: 00000363H
; Error: Relocation number 73 has a non-existing source address. Section: 0 Offset: 0000036FH
; Error: Relocation number 74 has a non-existing source address. Section: 0 Offset: 0000037BH
; Error: Relocation number 75 has a non-existing source address. Section: 0 Offset: 0000039AH
; Error: Relocation number 76 has a non-existing source address. Section: 0 Offset: 000003CCH
; Error: Relocation number 77 has a non-existing source address. Section: 0 Offset: 000003D7H
; Error: Relocation number 78 has a non-existing source address. Section: 0 Offset: 000003E7H
; Error: Relocation number 79 has a non-existing source address. Section: 0 Offset: 000003EDH
; Error: Relocation number 80 has a non-existing source address. Section: 0 Offset: 000003F3H
; Error: Relocation number 81 has a non-existing source address. Section: 0 Offset: 000003F9H
; Error: Relocation number 82 has a non-existing source address. Section: 0 Offset: 00000400H
; Error: Relocation number 83 has a non-existing source address. Section: 0 Offset: 00000410H
; Error: Relocation number 84 has a non-existing source address. Section: 0 Offset: 00000416H
; Error: Relocation number 85 has a non-existing source address. Section: 0 Offset: 0000041DH
; Error: Relocation number 86 has a non-existing source address. Section: 0 Offset: 0000042DH
; Error: Relocation number 87 has a non-existing source address. Section: 0 Offset: 00000433H
; Error: Relocation number 88 has a non-existing source address. Section: 0 Offset: 00000439H
; Error: Relocation number 89 has a non-existing source address. Section: 0 Offset: 0000043FH
; Error: Relocation number 90 has a non-existing source address. Section: 0 Offset: 00000445H
; Error: Relocation number 91 has a non-existing source address. Section: 0 Offset: 0000044BH
; Error: Relocation number 92 has a non-existing source address. Section: 0 Offset: 00000451H
; Error: Relocation number 93 has a non-existing source address. Section: 0 Offset: 00000457H
; Error: Relocation number 94 has a non-existing source address. Section: 0 Offset: 0000045EH
; Error: Relocation number 95 has a non-existing source address. Section: 0 Offset: 0000046EH
; Error: Relocation number 96 has a non-existing source address. Section: 0 Offset: 00000474H
; Error: Relocation number 97 has a non-existing source address. Section: 0 Offset: 0000047AH
; Error: Relocation number 98 has a non-existing source address. Section: 0 Offset: 00000480H
; Error: Relocation number 99 has a non-existing source address. Section: 0 Offset: 00000486H
; Error: Relocation number 100 has a non-existing source address. Section: 0 Offset: 0000048CH
; Error: Relocation number 101 has a non-existing source address. Section: 0 Offset: 00000493H
; Error: Relocation number 102 has a non-existing source address. Section: 0 Offset: 000004A0H
; Error: Relocation number 103 has a non-existing source address. Section: 0 Offset: 000004A5H
; Error: Relocation number 104 has a non-existing source address. Section: 0 Offset: 000004B1H
; Error: Relocation number 105 has a non-existing source address. Section: 0 Offset: 000004BDH
; Error: Relocation number 106 has a non-existing source address. Section: 0 Offset: 000004C9H
; Error: Relocation number 107 has a non-existing source address. Section: 0 Offset: 000004FCH
; Error: Relocation number 108 has a non-existing source address. Section: 0 Offset: 00000507H
; Error: Relocation number 109 has a non-existing source address. Section: 0 Offset: 00000513H
; Error: Relocation number 110 has a non-existing source address. Section: 0 Offset: 0000051FH
; Error: Relocation number 111 has a non-existing source address. Section: 0 Offset: 0000052BH
; Error: Relocation number 112 has a non-existing source address. Section: 0 Offset: 00000537H
; Error: Relocation number 113 has a non-existing source address. Section: 0 Offset: 00000543H
; Error: Relocation number 114 has a non-existing source address. Section: 0 Offset: 0000054FH
; Error: Relocation number 115 has a non-existing source address. Section: 0 Offset: 0000055BH
; Error: Relocation number 116 has a non-existing source address. Section: 0 Offset: 00000567H
; Error: Relocation number 117 has a non-existing source address. Section: 0 Offset: 00000573H
; Error: Relocation number 118 has a non-existing source address. Section: 0 Offset: 00000580H
; Error: Relocation number 119 has a non-existing source address. Section: 0 Offset: 00000598H
; Error: Relocation number 120 has a non-existing source address. Section: 0 Offset: 000005A4H
; Error: Relocation number 121 has a non-existing source address. Section: 0 Offset: 000005BCH
; Error: Relocation number 122 has a non-existing source address. Section: 0 Offset: 000005C8H
; Error: Relocation number 123 has a non-existing source address. Section: 0 Offset: 000005D4H
; Error: Relocation number 124 has a non-existing source address. Section: 0 Offset: 000005EBH
; Error: Relocation number 125 has a non-existing source address. Section: 0 Offset: 000005F7H
; Error: Relocation number 126 has a non-existing source address. Section: 0 Offset: 00000603H
; Error: Relocation number 127 has a non-existing source address. Section: 0 Offset: 0000060FH
; Error: Relocation number 128 has a non-existing source address. Section: 0 Offset: 00000632H
; Error: Relocation number 129 has a non-existing source address. Section: 0 Offset: 0000063EH
; Error: Relocation number 130 has a non-existing source address. Section: 0 Offset: 0000064AH
; Error: Relocation number 131 has a non-existing source address. Section: 0 Offset: 00000656H
; Error: Relocation number 132 has a non-existing source address. Section: 0 Offset: 00000662H
; Error: Relocation number 133 has a non-existing source address. Section: 0 Offset: 00000675H
; Error: Relocation number 134 has a non-existing source address. Section: 0 Offset: 0000069CH
; Error: Relocation number 135 has a non-existing source address. Section: 0 Offset: 000006A7H
; Error: Relocation number 136 has a non-existing source address. Section: 0 Offset: 000006BFH
; Error: Relocation number 137 has a non-existing source address. Section: 0 Offset: 000006CBH
; Error: Relocation number 138 has a non-existing source address. Section: 0 Offset: 000006D7H
; Error: Relocation number 139 has a non-existing source address. Section: 0 Offset: 000006E3H
; Error: Relocation number 140 has a non-existing source address. Section: 0 Offset: 000006EFH
; Error: Relocation number 141 has a non-existing source address. Section: 0 Offset: 000006FBH
; Error: Relocation number 142 has a non-existing source address. Section: 0 Offset: 00000708H
; Error: Relocation number 143 has a non-existing source address. Section: 0 Offset: 00000713H
; Error: Relocation number 144 has a non-existing source address. Section: 0 Offset: 00000719H
; Error: Relocation number 145 has a non-existing source address. Section: 0 Offset: 0000074CH
; Error: Relocation number 146 has a non-existing source address. Section: 0 Offset: 0000075AH
; Error: Relocation number 147 has a non-existing source address. Section: 0 Offset: 0000076FH
; Error: Relocation number 148 has a non-existing source address. Section: 0 Offset: 00000775H
; Error: Relocation number 149 has a non-existing source address. Section: 0 Offset: 0000079AH
; Error: Relocation number 150 has a non-existing source address. Section: 0 Offset: 000007A9H
; Error: Relocation number 151 has a non-existing source address. Section: 0 Offset: 000007AFH
; Error: Relocation number 152 has a non-existing source address. Section: 0 Offset: 0000080AH
; Error: Relocation number 153 has a non-existing source address. Section: 0 Offset: 0000081FH
; Error: Relocation number 154 has a non-existing source address. Section: 0 Offset: 0000082EH
; Error: Relocation number 155 has a non-existing source address. Section: 0 Offset: 0000083FH
; Error: Relocation number 156 has a non-existing source address. Section: 0 Offset: 0000085BH
; Error: Relocation number 157 has a non-existing source address. Section: 0 Offset: 00000861H
; Error: Relocation number 158 has a non-existing source address. Section: 0 Offset: 000008A4H
; Error: Relocation number 159 has a non-existing source address. Section: 0 Offset: 000008AAH
; Error: Relocation number 160 has a non-existing source address. Section: 0 Offset: 000008C1H
; Error: Relocation number 161 has a non-existing source address. Section: 0 Offset: 000008CFH
; Error: Relocation number 162 has a non-existing source address. Section: 0 Offset: 000008DDH
; Error: Relocation number 163 has a non-existing source address. Section: 0 Offset: 0000090AH
; Error: Relocation number 164 has a non-existing source address. Section: 0 Offset: 00000910H
; Error: Relocation number 165 has a non-existing source address. Section: 0 Offset: 00000927H
; Error: Relocation number 166 has a non-existing source address. Section: 0 Offset: 00000935H
; Error: Relocation number 167 has a non-existing source address. Section: 0 Offset: 00000943H
; Error: Relocation number 168 has a non-existing source address. Section: 0 Offset: 0000096AH
; Error: Relocation number 169 has a non-existing source address. Section: 0 Offset: 00000974H
; Error: Relocation number 170 has a non-existing source address. Section: 0 Offset: 0000098BH
; Error: Relocation number 171 has a non-existing source address. Section: 0 Offset: 00000999H
; Error: Relocation number 172 has a non-existing source address. Section: 0 Offset: 000009A7H
; Error: Relocation number 173 has a non-existing source address. Section: 0 Offset: 000009B6H
; Error: Relocation number 174 has a non-existing source address. Section: 0 Offset: 000009C5H
; Error: Relocation number 175 has a non-existing source address. Section: 0 Offset: 000009ECH
; Error: Relocation number 176 has a non-existing source address. Section: 0 Offset: 000009FBH
; Error: Relocation number 177 has a non-existing source address. Section: 0 Offset: 00000A06H
; Error: Relocation number 178 has a non-existing source address. Section: 0 Offset: 00000A1DH
; Error: Relocation number 179 has a non-existing source address. Section: 0 Offset: 00000A2CH
; Error: Relocation number 180 has a non-existing source address. Section: 0 Offset: 00000A3BH
; Error: Relocation number 181 has a non-existing source address. Section: 0 Offset: 00000A4BH
; Error: Relocation number 182 has a non-existing source address. Section: 0 Offset: 00000A5BH
; Error: Relocation number 183 has a non-existing source address. Section: 0 Offset: 00000A85H
; Error: Relocation number 184 has a non-existing source address. Section: 0 Offset: 00000A95H
; Error: Relocation number 185 has a non-existing source address. Section: 0 Offset: 00000AA0H
; Error: Relocation number 186 has a non-existing source address. Section: 0 Offset: 00000AC4H
; Error: Relocation number 187 has a non-existing source address. Section: 0 Offset: 00000AD3H
; Error: Relocation number 188 has a non-existing source address. Section: 0 Offset: 00000AE3H
; Error: Relocation number 189 has a non-existing source address. Section: 0 Offset: 00000AF3H
; Error: Relocation number 190 has a non-existing source address. Section: 0 Offset: 00000B02H
; Error: Relocation number 191 has a non-existing source address. Section: 0 Offset: 00000B11H
; Error: Relocation number 192 has a non-existing source address. Section: 0 Offset: 00000B20H
; Error: Relocation number 193 has a non-existing source address. Section: 0 Offset: 00000B30H
; Error: Relocation number 194 has a non-existing source address. Section: 0 Offset: 00000B3BH
; Error: Relocation number 195 has a non-existing source address. Section: 0 Offset: 00000B5FH
; Error: Relocation number 196 has a non-existing source address. Section: 0 Offset: 00000B6EH
; Error: Relocation number 197 has a non-existing source address. Section: 0 Offset: 00000B7EH
; Error: Relocation number 198 has a non-existing source address. Section: 0 Offset: 00000B8EH
; Error: Relocation number 199 has a non-existing source address. Section: 0 Offset: 00000B9DH
; Error: Relocation number 200 has a non-existing source address. Section: 0 Offset: 00000BACH
; Error: Relocation number 201 has a non-existing source address. Section: 0 Offset: 00000BBBH
; Error: Relocation number 202 has a non-existing source address. Section: 0 Offset: 00000BCBH
; Error: Relocation number 203 has a non-existing source address. Section: 0 Offset: 00000BD1H
; Error: Relocation number 204 has a non-existing source address. Section: 0 Offset: 00000BE4H
; Error: Relocation number 205 has a non-existing source address. Section: 0 Offset: 00000BEEH
; Error: Relocation number 206 has a non-existing source address. Section: 0 Offset: 00000C05H
; Error: Relocation number 207 has a non-existing source address. Section: 0 Offset: 00000C13H
; Error: Relocation number 208 has a non-existing source address. Section: 0 Offset: 00000C2EH
; Error: Relocation number 209 has a non-existing source address. Section: 0 Offset: 00000C3FH
; Error: Relocation number 210 has a non-existing source address. Section: 0 Offset: 00000C4DH
; Error: Relocation number 211 has a non-existing source address. Section: 0 Offset: 00000C5EH
; Error: Relocation number 212 has a non-existing source address. Section: 0 Offset: 00000C7BH
; Error: Relocation number 213 has a non-existing source address. Section: 0 Offset: 00000C85H
; Error: Relocation number 214 has a non-existing source address. Section: 0 Offset: 00000C9CH
; Error: Relocation number 215 has a non-existing source address. Section: 0 Offset: 00000CABH
; Error: Relocation number 216 has a non-existing source address. Section: 0 Offset: 00000CB7H
; Error: Relocation number 217 has a non-existing source address. Section: 0 Offset: 00000CC5H
; Error: Relocation number 218 has a non-existing source address. Section: 0 Offset: 00000CD1H
; Error: Relocation number 219 has a non-existing source address. Section: 0 Offset: 00000CDAH
; Error: Relocation number 220 has a non-existing source address. Section: 0 Offset: 00000CE6H
; Error: Relocation number 221 has a non-existing source address. Section: 0 Offset: 00000CEFH
; Error: Relocation number 222 has a non-existing source address. Section: 0 Offset: 00000CFBH
; Error: Relocation number 223 has a non-existing source address. Section: 0 Offset: 00000D04H
; Error: Relocation number 224 has a non-existing source address. Section: 0 Offset: 00000D10H
; Error: Relocation number 225 has a non-existing source address. Section: 0 Offset: 00000D19H
; Error: Relocation number 226 has a non-existing source address. Section: 0 Offset: 00000D25H
; Error: Relocation number 227 has a non-existing source address. Section: 0 Offset: 00000D30H
; Error: Relocation number 228 has a non-existing source address. Section: 0 Offset: 00000D35H
; Error: Relocation number 229 has a non-existing source address. Section: 0 Offset: 00000D40H
; Error: Relocation number 230 has a non-existing source address. Section: 0 Offset: 00000D4BH
; Error: Relocation number 231 has a non-existing source address. Section: 0 Offset: 00000D57H


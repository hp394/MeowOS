[bits 32]

extern kernel_init
global _start
_start:
    ;mov byte [0xb8000], 'K'; indicating entering kernal
    xchg bx, bx
    call kernel_init
    xchg bx, bx
    jmp $; block
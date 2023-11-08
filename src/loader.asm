[org 0x1000]

dw 0x55aa; magic number to check error

;print string
mov si, loading
call print

xchg bx,bx
detect_memory:
    xor ebx, ebx; set ebx to 0

    ; es:di the location of the ards
    mov ax, 0
    mov es, ax
    mov edi, ards_buffer

    mov edx, 0x534d4150; fixed sign
    
.next:
    mov eax, 0xe820
    mov ecx, 20
    int 0x15

    jc error

    ;a
    add di, cx

    inc word [ards_count]
    cmp ebx, 0
    jnz .next

    mov si, detecting
    call print

    ; ards count
    mov cx, [ards_count]
    ; ards pointer
    mov si, 0

.show:
    mov eax, [ards_buffer + si]
    mov ebx, [ards_buffer + si + 8]
    mov edx, [ards_buffer + si + 16]
    add si, 20
    loop .show
; ;block
    jmp $
    ; xchg bx, bx

    ; jmp prepare_protected_mode


; prepare_protected_mode:
;     cli; turn off interrupt

;     ;turn on A20
;     in al, 0x92
;     or al, 0b10
;     out 0x92, al

;     lgdt [gdt_ptr]; load gdt

;     ; launch protected mode
;     mov eax, cr0
;     or eax, 1
;     mov cr0, eax

;     ;jump to refresh cache to launch protect mode
;     jmp dword code_selector:protect_mode
    
print: 
    mov ah, 0x0e
    .next:
        mov al, [si]
        cmp al, 0
        jz .done
        int 0x10
        inc si
        jmp .next
    .done:
        ret
loading:
    db "Loading MeowOS...", 10, 13, 0; \n \r

detecting:
    db "Detecting Memory Success...", 10, 13, 0; \n \r

error:
    mov si, .msg
    call print
    hlt; let cpu stop
    jmp $
    .msg db "Loading Error!", 10, 13, 0

; [bits 32]
; protect_mode:
;  mov ax, data_selector
;  mov ds, ax
;  mov es, ax
;  mov fs, ax
;  mov gs, ax
;  mov ss, ax; initialize segment register

;  mov esp, 0x10000; change the top of stack

;  mov byte [0xb8000], 'P'
;  mov byte [0x200000], 'P'

; jmp $

; code_selector equ (1 << 3)
; data_selector equ (2 << 3)
; memory_base equ 0; memory start position/base address
; memory_limit equ ((1024 * 1024 * 1024 * 4) / (1024 * 4)) - 1; memory limit (4g / 4k - 1)

; gdt_ptr:
;     dw (gdt_end - gdt_base) - 1
;     dd gdt_base
; gdt_base: 
;     dd 0, 0; NULL descriptor
; gdt_code:
;     dw memory_limit & 0xffff; segment limit 0 - 15
;     dw memory_base & 0xffff; base address 0 - 16
;     db (memory_base >> 16) & 0xffff; base address 0 - 16
;     db 0b_1_00_1_1_0_1_0; exist dlp  code readable not visited by CPU
;     db 0b1_1_0_0_0000 | (memory_limit >> 16) & 0xf;
;     db (memory_base >> 24) & 0xff; base address 24 - 31

; gdt_data:
;     dw memory_limit & 0xffff; segment limit 0 - 15
;     dw memory_base & 0xffff; base address 0 - 16
;     db (memory_base >> 16) & 0xffff; base address 0 - 16
;     db 0b_1_00_1_0_0_1_0; exist dlp  data writable not visited by CPU
;     db 0b1_1_0_0_0000 | (memory_limit >> 16) & 0xf;
;     db (memory_base >> 24) & 0xff; base address 24 - 31

; gdt_end:
ards_count: 
    dw 0
ards_buffer:
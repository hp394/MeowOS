[org 0x7c00] ;code address started at 7c00

; set display to text mode and clear the screen
mov ax, 3
int 0x10

; Initialize register
mov ax, 0
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

; memory for text display
mov si, booting
call print

mov edi, 0x1000; read target memory
mov ecx, 2; start sector
mov bl, 4; sector number

call read_disk

cmp word [0x1000], 0x55aa
jnz error
jmp 0:0x1002
;block
jmp $



read_disk:
    ;set the r/w sector number
    mov dx, 0x1f2
    mov al, bl
    out dx, al

    inc dx; 0x1f3
    mov al, cl; first 8 digit of start sector
    out dx, al

    inc dx; 0x1f4
    shr ecx, 8
    mov al, cl; middle 8 digit of start sector
    out dx, al

    inc dx; 0x1f5
    shr ecx, 8
    mov al, cl; high 8 digit of start sector
    out dx, al

    inc dx; 0x1f6
    shr ecx, 8
    and cl, 0b1111;set the high 4 digits to 0

    mov al, 0b1110_0000
    or al, cl
    out dx, al; master disk - LBA

    inc dx; 0f1f7
    mov al, 0x20; read disk
    out dx, al

    xor ecx, ecx; clear ecx
    mov cl, bl; get the number of read/write sectors

    .read:
        push cx; save cx
        call .wait; wait until the data is ready
        call .reads; read a sector
        pop cx; recover cx
        loop .read

    ret
    
    .wait:
        mov dx, 0x1f7
        .check:
            in al, dx
            jmp $ + 2; nop
            jmp $ + 2; nop
            jmp $ + 2; nop
            and al, 0b1000_1000
            cmp al, 0b0000_1000
            jnz .check
        ret
    
    .reads:
        mov dx, 0x1f0
        mov cx, 256; 1 sector has 256 bytes
        .readw:
            in ax, dx
            jmp $ + 2; nop
            jmp $ + 2; nop
            jmp $ + 2; nop
            mov [edi], ax
            add edi, 2
            loop .readw

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
booting:
    db "Booting MeowOS...", 10, 13, 0

error:
    mov si, .msg
    call print
    hlt; let cpu stop
    jmp $
    .msg db "Booting Error!", 10, 13, 0
; fill the rest of the space to 0
times 510 - ($ - $$) db 0

; the last 2 word must be 0x55 and 0xaa
;dw 0x55aa
db 0x55, 0xaa
# Real Mode print

- ah: 0x0e
- al: byte
- int 0x10

    xchg bx, bx; bochs magical breakpoint for bochs
```
mov si, booting
call print
;block
jmp $


print: 
    mov ah, 0x0e
.next
    mov al, [si]
    cmp al, 0
    jz .done
    int 0x10
    inc si
    jmp .next
.done
    ret
booting:
    db "Booting MeowOS...", 10, 13, 0
```
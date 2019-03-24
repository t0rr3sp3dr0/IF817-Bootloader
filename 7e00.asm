org 0x7E00   ; add 0x7E00 to label addresses
bits 16      ; tell the assembler we want 16 bit code

    xor ax, ax     ; set up segments
    mov ds, ax
    mov es, ax
    mov ss, ax     ; setup stack
    mov sp, 0x7E00 ; stack grows downwards from 0x7E00

    mov si, welcome
    call print_string

    mov ah, 0
    int 0x16   ; wait for keypress

    mov ax, 5307h
    mov bx, 0001h
    mov cx, 0003h
    int 15h       ; shutdown

    jmp -1

welcome db 'Welcome to 0x7E00!', 0x0D, 0x0A, 0

; ================
; calls start here
; ================

print_string:
    xor cx, cx

.loop:
    lodsb        ; grab a byte from SI

    or al, al  ; logical or AL by itself
    jz .done   ; if the result is zero, get out

    mov ah, 0x0E
    int 0x10      ; otherwise, print out the character!

    inc cl

    jmp .loop

.done:
    ret

    times 64512 - ($ - $$) db 0

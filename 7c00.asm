org 0x7C00   ; add 0x7C00 to label addresses
bits 16      ; tell the assembler we want 16 bit code

    xor ax, ax     ; set up segments
    mov ds, ax
    mov es, ax
    mov ss, ax     ; setup stack
    mov sp, 0x7C00 ; stack grows downwards from 0x7C00

    mov si, welcome
    call print_string

    mov ah, 02h    ; Read Sectors from Drive
    mov al, 1      ; Sectors to Read Count
    mov ch, 0      ; Cylinder
    mov cl, 2      ; Sector
    mov dh, 0      ; Head
    mov dl, 80h    ; Drive
    mov bx, 0x0500 ; Buffer Address Pointer (Lower)
    int 13h

    jnc 0x0500
    jmp 0x7C00

welcome db 'Welcome to 0x7C00!', 0x0D, 0x0A, 0

; ================
; calls start here
; ================

print_string:
    lodsb        ; grab a byte from SI

    or al, al  ; logical or AL by itself
    jz .done   ; if the result is zero, get out

    mov ah, 0x0E
    int 0x10      ; otherwise, print out the character!

    jmp print_string

.done:
    ret

    times 510 - ($ - $$) db 0
    dw 0xAA55 ; some BIOSes require this signature

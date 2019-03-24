org 0x0500   ; add 0x500 to label addresses
bits 16      ; tell the assembler we want 16 bit code

    xor ax, ax     ; set up segments
    mov ds, ax
    mov es, ax
    mov ss, ax     ; setup stack
    mov sp, 0x0500 ; stack grows downwards from 0x0500

    mov si, welcome
    call print_string

    call check_a20

    mov ah, 02h    ; Read Sectors from Drive
    mov al, 20     ; Sectors to Read Count
    mov ch, 0      ; Cylinder
    mov cl, 3      ; Sector
    mov dh, 0      ; Head
    mov dl, 80h    ; Drive
    mov bx, 0x7E00 ; Buffer Address Pointer (Lower)
    int 13h

    jnc 0x7E00
    jmp 0x0500

welcome db 'Welcome to 0x0500!', 0x0D, 0x0A, 0

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

a20_disabled db 'A20 disabled!', 0x0D, 0x0A, 0
a20_enabled db 'A20 enabled!', 0x0D, 0x0A, 0

check_a20:
    push di
    push si
    push ds
    push es
 
    cli
 
    xor ax, ax ; ax = 0
    mov es, ax
 
    not ax ; ax = 0xFFFF
    mov ds, ax
 
    mov di, 0x0500
    mov si, 0x0510
 
    mov al, byte [es:di]
    push ax
 
    mov al, byte [ds:si]
    push ax
 
    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF
 
    cmp byte [es:di], 0xFF
 
    pop ax
    mov byte [ds:si], al
 
    pop ax
    mov byte [es:di], al

    mov si, a20_disabled
    je .done
 
    mov si, a20_enabled
 
.done:
    pop es
    pop ds

    call print_string

    pop si
    pop di
 
    ret

    times 512 - ($ - $$) db 0

;
; Read some sectors from the boot disk using our disk_read function
;
[org 0x7c00]

    mov [BOOT_DRIVE], dl

    mov bp, 0x8000
    mov sp, bp

    mov bx, 0x9000
    mov dh, 3 
    mov dl, [BOOT_DRIVE]
    call disk_load

    mov dx, [0x9000]
    call print_hex

    mov dx, [0x9000 + 512]
    call print_hex
    
    mov dx, [0x9000 + 1024]
    call print_hex
    jmp $

%include "boot/print_string.asm"
%include "boot/print_hex.asm"
%include "boot/disk_load.asm"

BOOT_DRIVE: db 0

;
; Padding and magic BIOS number.

    times 510-($-$$) db 0
    dw 0xaa55

    times 256 dw 0xdada
    times 256 dw 0xface
    times 256 dw 0xabcd

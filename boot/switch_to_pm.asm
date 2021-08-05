[bits 16]
; Switch to protected mode
switch_to_pm:
	cli
	lgdt [gdt_descriptor]

	mov eax, cr0
	or eax, 0x00000001
	mov cr0, eax
    
    jmp $+2
    nop
    nop

	jmp CODE_SEG:init_pm

[bits 32]
init_pm:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000
	mov esp, ebp

	call BEGIN_PM

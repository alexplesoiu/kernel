ORG 0
BITS 16

; BIOS PARAMETER BLOCK
_start:
	jmp short start
	nop
; Create 33 bytes for BPB
times 33 db 0 

start:
	; Set code segment to 0x7c0
	jmp 0x7c0:step2



step2:
	cli ; Clear Interrupts
	; SETTING SEGMENTS TO 0x7c0
	mov ax, 0x7c0 
	mov ds, ax
	mov es, ax
	mov ax, 0x00
	mov ss, ax
	mov sp, 0x7c00
	sti ;	Enables Interrupts
	
	; READ FROM DISK
	mov ah, 0x02 ; READ SECTOR COMMAND
	mov al, 0x01 ; ONE SECTOR TO READ
	mov ch, 0x00 ; Cylinder low eight bits
	mov cl, 0x02 ; Read sector two
	mov dh, 0x00 ; Head Number
	mov bx, buffer 
	int 0x13
	jc error ; jump if carry flag is set

	mov si, buffer
	call print

	jmp $

error:
	mov si, error_message
	call print
	jmp $


print:
	mov bl, 02h	; Foreground color

	.loop:
	lodsb	; load into al register from si register and increment pointer
	call print_char
	cmp al, 0
	je .done
	jmp .loop
	
	.done:
	ret

print_char:
	mov ah, 0eh	; 14 => teletype output
	int 0x10
	ret

error_message: db 'Failed to load sector', 0

times 510 - ($ - $$) db 0 ; Minimum 510 Bytes
dw 0xAA55	; Set Bootloader Signature

buffer: ; Used reading in the ram on next sector


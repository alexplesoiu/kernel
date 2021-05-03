ORG 0 										; Set the origin to 0
BITS 16 									; Tell nasm to assemble for 16 bits

; BIOS PARAMETER BLOCK
_start:
	jmp short start
	nop

times 33 db 0 ; Create 33 bytes of 0 for BIOS PARAMETER BLOCK

start:
	jmp 0x7c0:step2 					; Setting code segment to 0x7c0


custom_interrupt:
	mov ah, 0eh
	mov al, 'k'
	mov bl, 02h
	int 0x10
	iret

interrupt_one:
	mov ah, 0eh
	mov al, '1'
	mov bl, 02h
	int 0x10
	iret


step2:
	cli 										; Clear Interrupts
	; SETTING SEGMENTS TO 0x7c0
	mov ax, 0x7c0 					
	mov ds, ax
	mov es, ax
	mov ax, 0x00
	mov ss, ax
	mov sp, 0x7c00
	sti 										; Enables Interrupts
	
	; SETTING THE INTERRUPT VECTOR TABLE
	mov word[ss:0x00], custom_interrupt
	mov word[ss:0x02], 0x7c0
	mov word[ss:0x04], interrupt_one
	mov word[ss:0x06], 0x7c0

	int 0x01 ; CALL OUR CUSTOM INTERRUPT

	mov si, message 				; Load into si register, 'message' start address	
	call print 							; Call Print Function
	jmp $ 									; Jump to itself (infinite loop)

print:
	mov bl, 02h 						; Foreground color, ONLY IN GRAPHIC MODE (use bl register)
.loop:
	lodsb 									; load into al register from si register and increment pointer
	call print_char 				; Print char
	cmp al, 0 							; compare al and 0
	je .done 								; if al == 0 jump to .done
	jmp .loop 							; else jump to .loop
.done:
	ret

print_char:
	mov ah, 0eh 						; 14 => teletype output
	int 0x10 								; Call BIOS Function
	ret

message: db 'MGE OS BOOTLOADER !!', 0

times 510 - ($ - $$) db 0 ; Minimum 510 Bytes
dw 0xAA55 								; Set Bootloader Signature

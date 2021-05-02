ORG 0x7C00 								; Set the origin to 0x7C00
BITS 16 									; Tell nasm to assemble for 16 bits

start:
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

message: db 'Hello World!!', 0

times 510 - ($ - $$) db 0 ; Minimum 510 Bytes
dw 0xAA55 								; Set Bootloader Signature

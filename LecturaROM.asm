%macro ASCIIaENTERO 1
	and %1, 11111111b ; Guardar solo ultimos 8 bits
	cmp %1, 96
	ja %%elseL1
	sub %1, 48
	jmp %%end
	%%elseL1:
	sub %1, 87
	%%end:
%endmacro

%macro HexMemoria 3

	shl %1, 4
	add %1, %2
	mov [trama+%3], %1

%endmacro
%macro HexPC 3

	shl %1, 4
	add %1, %2
	mov [pc+%3], %1

%endmacro
;------------------LECTURA ROM.TXT--------------------------------
section .data

	file db "./ROM.txt", 0
	len equ 10000

section .bss 

	buffer: resb 2048
	trama: resb 2048
	pc: resb 2048

section .text

global _start

_start:
;----------------ABRIR ROM.TXT---------------------
	mov ebx, file ; name of the file  
	mov eax, 5  
	mov ecx, 0  
	int 80h     

	mov eax, 3  
	mov ebx, eax
	mov ecx, buffer 
	mov edx, len    
	int 80h 

;-----------PASAR DE ASCII A ENTERO----------------
	mov r8, [buffer]
	mov rax, 0
	mov rbx, 0

loop1:

	inc rax

	mov r8, [buffer+rax]
	ASCIIaENTERO r8
	inc rax
	mov r9, [buffer+rax]
	ASCIIaENTERO r9
	inc rax
	mov r10, [buffer+rax]
	ASCIIaENTERO r10
	inc rax
	mov r11, [buffer+rax]
	ASCIIaENTERO r11
	inc rax
	mov r12, [buffer+rax]
	ASCIIaENTERO r12
	inc rax
	mov r13, [buffer+rax]
	ASCIIaENTERO r13
	inc rax
	mov r14, [buffer+rax]
	ASCIIaENTERO r14
	inc rax
	mov r15, [buffer+rax]
	ASCIIaENTERO r15
	inc rax
;-------------GUARDAR PC EN MEMORIA------------------
	HexPC r14,r15,rbx
	inc rbx
	HexPC r12,r13,rbx
	inc rbx
	HexPC r10,r11,rbx
	inc rbx
	HexPC r8,r9,rbx
	inc rbx

	SUB rbx, 4
	add rax, 2

	mov r8, [buffer+rax]
	ASCIIaENTERO r8
	inc rax
	mov r9, [buffer+rax]
	ASCIIaENTERO r9
	inc rax
	mov r10, [buffer+rax]
	ASCIIaENTERO r10
	inc rax
	mov r11, [buffer+rax]
	ASCIIaENTERO r11
	inc rax
	mov r12, [buffer+rax]
	ASCIIaENTERO r12
	inc rax
	mov r13, [buffer+rax]
	ASCIIaENTERO r13
	inc rax
	mov r14, [buffer+rax]
	ASCIIaENTERO r14
	inc rax
	mov r15, [buffer+rax]
	ASCIIaENTERO r15
	inc rax
;-------------GUARDAR EN MEMORIA------------------
	HexMemoria r14,r15,rbx
	inc rbx
	HexMemoria r12,r13,rbx
	inc rbx
	HexMemoria r10,r11,rbx
	inc rbx
	HexMemoria r8,r9,rbx
	inc rbx

loop2:

	mov r8, [buffer+rax]
	and r8, 11111111b

	cmp r8, 0
	je end

	cmp r8, 10
	je esEnter
	inc rax
	jmp loop2

	esEnter:
	inc rax
	mov r8, [buffer+rax]
	and r8, 11111111b
	cmp r8, 0
	je end
	cmp r8, 10
	je esEnter
	jmp loop1

end:
	mov r8, trama
	mov r9, pc
_exit:
    mov eax, 1  
    mov ebx, 0 
    int 80h
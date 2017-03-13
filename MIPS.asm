%include linux64.inc

;							/* MACROS */

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

%macro printValue 1
	mov rax, %1 ;Al registro rax se le asigna el parámetro de entrada
	%%printRAX:
		mov rcx, digitSpace
		mov [digitSpacePos], rcx
	%%printRAXLoop:
		mov rdx, 0
		mov rbx, 10
		div rbx
		push rax
		add rdx, 48

		mov rcx, [digitSpacePos]
		mov [rcx], dl
		inc rcx
		mov [digitSpacePos], rcx

		pop rax
		cmp rax, 0
		jne %%printRAXLoop
	%%printRAXLoop2:
		mov rcx, [digitSpacePos]

		mov rax, 1
		mov rdi, 1
		mov rsi, rcx
		mov rdx, 1
		syscall

		mov rcx, [digitSpacePos]
		dec rcx
		mov [digitSpacePos], rcx

		cmp rcx, digitSpace

		jge %%printRAXLoop2
		mov rax, SYS_CLOSE
		pop rdi
		syscall

		print text
		exit
%endmacro

%macro alu 1 ; 1 parámetro como "señal de ctrl".
	mov rsi, %1 ; "OP Code" de ALU. Se guarda en rsi.
%%and:
	cmp rsi, 0d ; 0d = AND.
	jne %%or ; Si no es, pasa a siguiente opción.
	and rax, rcx ; rax (rs) AND rcx (rt).
	jmp %%result ; Concluida la operación, pasa a resultado.
%%or:
	cmp rsi, 1d ; 1d = OR.
	jne %%add ; Si no es, pasa a siguiente opción.
	or rax, rcx ; rax (rs) OR rcx (rt).
	jmp %%result ; Concluida la operación, pasa a resultado.
%%add:
	cmp rsi, 2d ; 2d = ADD.
	jne %%substract ; Si no es, pasa a siguiente opción.
	add rax, rcx ; rax (rs) + rcx (rt).
	jmp %%result ; Concluida la operación, pasa a resultado.
%%substract:
	cmp rsi, 3d; 3d = SUB.
	jne %%set_on_less_than ; Si no es, pasa a siguiente opción.
	sub rax, rcx ; rax (rs) - rcx (rt).
	jmp %%result ; Concluida la operación, pasa a resultado.
%%set_on_less_than:
	cmp rsi, 4d; 4d = SLTU.
	jne %%nor ; Si no es, pasa a siguiente opción.
	cmp rcx, rax
	jg %%true  ; Si rcx (rt) > rax(rs).
	jmp %%false ; Si no.
	%%true:
		mov rbp, 1b ; Un 1 en rbp (rd).
		jmp %%end ; Se pasa a fin porque ya resultado está en rd.
	%%false:
		mov rbp, 0b ; Un 0 en rbp (rd).
		jmp %%end ; Se pasa a fin porque ya resultado está en rd.
%%nor:
	cmp rsi, 5d; 5d = NOR.
	jne %%multiply ; Si no es, pasa a siguiente opción.
	or rax, rcx ; rax (rs) OR rcx (rt).
	not rax ; NOT rax (rs).
	jmp %%result ; Concluida la operación, pasa a resultado.
%%multiply:
	cmp rsi, 6d ; 6d = MULT.
	jne %%end ; Si no es, pasa a resultal sin hacer nada.
	mul rcx ; rax (rs) * rcx (rt).
	jmp %%result ; Concluida la operación, pasa a resultado.
%%result: ; Las operaciones realizadas ponen su resultado en rax.
	mov rbp, rax ; Mueve resultado de operación a rbp (rd).
%%end: ; Etiqueta para casos de no hacer nada.
%endmacro

;							/* Código */

section .data

	; -------------------- Mensajes --------------------
	;NOTA: en caso de querer cambiar el color se modifica el #m.

	bienvenido: db  0x1b,"[38;5;183m","************************** Bienvenido al Emulador MIPS *************************", 0xa, 0xa
	lab: db 0x1b,"[38;5;86m", "        EL-4313 - Lab Estructura de Microprocesadores", 0xa
	sem: db 0x1b,"[38;5;86m", "        IS - 2017", 0xa
	buscando: db 0x1b,"[38;5;86m","        Buscando archivo ROM.txt", 0xa
	encuentra: db 0x1b,"[38;5;86m","        Archivo ROM.txt encontrado", 0xa
	noencuentra: db 0x1b, "[38;5;86m","        Archivo ROM.txt no encontrado", 0xa
	inicio:  db 0x1b, "[38;5;86m","        Presione enter para continuar", 0xa
	exito: db 0x1b, "[38;5;86m","        Ejecución exitosa", 0xa
	fallo: db 0x1b, "[38;5;86m","        Ejecución fallida", 0xa
	final: db 0x1b, "[38;5;86m","        Realizado por:", 0xa
	juan: db 0x1b, "[38;5;86m","      	  Juan José Vásquez Alfaro 2014098487", 0xa
	joao: db 0x1b, "[38;5;86m","     	  Joao Kmil Salas Ramirez 2014096609", 0xa
	steven: db 0x1b, "[38;5;86m","      	  Steven León Domínguez 2014138025", 0xa
	andre: db 0x1b, "[38;5;86m","     	  André Martínez Arana 2014068625", 0xa
	camila: db 0x1b, "[38;5;86m","     	  Camila Gómez Molina 2014089559", 0xa
	
	; -------------------- LECTURA ROM.TXT --------------------
	file db "./ROM.txt", 0
	len equ 2048
	n db 0

	; -------------------- Imprimir registros --------------------
	filename: db "myfile.txt",0

section .bss

	; -------------------- LECTURA ROM.TXT --------------------
	buffer: resb 2048
	trama: resb 1

	; -------------------- Imprimir registros --------------------
	text resw 100 ;Reserva un espacio en memoria

section .text

	global _start

_start:

; -------------------- Imprimir mensajes de bienvenida --------------------
	print bienvenido ;Llamado al macro
	print lab
	print sem
	print buscando

; -------------------- ABRIR ROM.TXT --------------------
	mov ebx, file ; name of the file
	mov eax, 5
	mov ecx, 0
	int 80h

	mov eax, 3
	mov ebx, eax
	mov ecx, buffer
	mov edx, len
	int 80h

;-------------------- PASAR DE ASCII A ENTERO --------------------
	mov r8, [buffer]
	mov rax, 0
	mov rbx, 0

loop1:
	add rax, 11

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

;-------------------- GUARDAR EN MEMORIA --------------------
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
	mov r14, [trama+3]
	and r14, 11111100b
	shr r14, 2

_exit:
  mov eax, 1
  mov ebx, 0
  int 80h

; -------------------- Decodificación --------------------
.decode:
	mov r13, r14                        ;Se copia la instrucción a otro registro
	;sar r13, 26                         ;y se mueve a la derecha para dejar solo el código de operación

  cmp r13, 100000b                    ;compara con op code, en este caso de add
	je .suma                            ;salta a la etiqueta correspondiente, en este caso .suma
	cmp r13, 100001b                    ;compara con addu
	je .sumau                           ;salta a .sumau
	cmp r13, 001000b                    ;compara con addi
	je .sumai                           ;salta a .sumai
	cmp r13, 001001b                    ;compara con addiu
	je .sumaiu                          ;salta a .sumaiu
	cmp r13, 100100b                   ;compara con and
	je .y                               ;salta a .y
	cmp r13, 001100b                    ;compara con andi
	je .yi                              ;salta a .y
	cmp r13, 000100b                   ;compara con beq
	je .beq                             ;salta a .beq
	cmp r13, 000101b                    ;compara con bne
	je .bne                             ;salta a .bne
	cmp r13, 000010b                    ;compara con j
	je .j                               ;salta a .j
	cmp r13, 000011b                    ;compara con jal
	je .jandl                           ;salta a .jandl
	cmp r13, 001000b                    ;compara con jr
	je .jr                              ;salta a .jr
	cmp r13, 100011b                    ;compara con lw
	je .lw                              ;salta a .lw
	cmp r13, 011000b                    ;compara con mult
	je .mult                            ;salta a .mult
	cmp r13, 100111b                    ;compara con nor
	je .nor                             ;salta a .nor
	cmp r13, 100101b                    ;compara con or
	je .o                               ;salta a .o
	cmp r13, 001101b                    ;compara con ori
	je .ori                             ;salta a .ori
	cmp r13, 101010b                    ;compara con slt
	je .slt                             ;salta a .slt
	cmp r13, 001010b                    ;compara con slti
	je .slti                            ;salta a .slti
	cmp r13, 001001b                    ;compara con sltiu
	je .sltiu                           ;salta a .sltiu
	cmp r13, 101001b                    ;compara con sltu
	je .sltu                            ;salta a .sltu
	cmp r13, 000000b                    ;compara con sll
	je .sll                             ;salta a .sll
	cmp r13, 000010b                    ;compara con srl
	je .srl                             ;salta a .srl
	cmp r13, 100010b                    ;compara con sub
	je .resta                           ;salta a .resta
	cmp r13, 100011b                    ;compara con subu
	je .restau                          ;salta a .restau
	cmp r13, 101011b                    ;compara con sw
	je .sw                              ;salta a .sw

	jmp .instnotfound                   ;si la instrucción no se
		                                      ;encuentra en el set que
		                                      ;maneja el procesador
		                                      ;se ejecuta una rutina que
		                                      ;lo informa en pantalla

; -------------------- Error de instruccíon no encontrada --------------------
.instnotfound:

; -------------------- Rutinas correspondientes a cada inst --------------------
.suma:
	alu 2d
.sumau:

.sumai:

.sumaiu:

.y:

.yi:

.beq:

.bne:

.j:

.jandl:

.jr:

.lw:

.mult:
	alu 6d
.nor:
	alu 5d
.o:
	alu 1d
.ori:

.slt:
	alu 4d
.slti:

.sltiu:

.sltu:

.sll:

.srl:

.resta:
	alu 3d
.restau:

.sw:


; -------------------- Imprimir registros --------------------
printValue r8 ; Imprime registro del resultado.
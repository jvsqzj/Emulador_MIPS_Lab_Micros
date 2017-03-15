%include "linux64.inc"
%include "macros.inc"

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

%macro alu 1 ; 1 parámetro como "señal de ctrl".
	mov rdx, %1 ; "OP Code" de ALU. Se guarda en rdx.
%%and:
	cmp rdx, 0 ; 0 = AND.
	jne %%or ; Si no es, pasa a siguiente opción.
	and rax, rcx ; rax (rs) AND rcx (rt).
	jmp %%result ; Concluida la operación, pasa a resultado.
%%or:
	cmp rdx, 1 ; 1 = OR.
	jne %%add ; Si no es, pasa a siguiente opción.
	or rax, rcx ; rax (rs) OR rcx (rt).
	jmp %%result ; Concluida la operación, pasa a resultado.
%%add:
	cmp rdx, 2 ; 2 = ADD.
	jne %%substract ; Si no es, pasa a siguiente opción.
	add rax, rcx ; rax (rs) + rcx (rt).
	jmp %%result ; Concluida la operación, pasa a resultado.
%%substract:
	cmp rdx, 3; 3 = SUB.
	jne %%set_on_less_than ; Si no es, pasa a siguiente opción.
	sub rax, rcx ; rax (rs) - rcx (rt).
	jmp %%result ; Concluida la operación, pasa a resultado.
%%set_on_less_than:
	cmp rdx, 4; 4 = SLTU.
	jne %%nor ; Si no es, pasa a siguiente opción.
	cmp rcx, rax
	jg %%true  ; Si rcx (rt) > rax(rs).
	jmp %%false ; Si no.
	%%true:
		mov rbx, 1b ; Un 1 en rbx (rd).
		jmp %%end ; Se pasa a fin porque ya resultado está en rd.
	%%false:
		mov rbx, 0b ; Un 0 en rbx (rd).
		jmp %%end ; Se pasa a fin porque ya resultado está en rd.
%%nor:
	cmp rdx, 5; 5 = NOR.
	jne %%multiply ; Si no es, pasa a siguiente opción.
	or rax, rcx ; rax (rs) OR rcx (rt).
	not rax ; NOT rax (rs).
	jmp %%result ; Concluida la operación, pasa a resultado.
%%multiply:
	cmp rdx, 6 ; 6 = MULT.
	jne %%end ; Si no es, pasa a resultal sin hacer nada.
	mul rcx ; rax (rs) * rcx (rt).
	jmp %%result ; Concluida la operación, pasa a resultado.
%%result: ; Las operaciones realizadas ponen su resultado en rax.
	mov rbx, rax ; Mueve resultado de operación a rbx (rd).
%%end: ; Etiqueta para casos de no hacer nada.
%endmacro

;							/* Código */

section .data

	; -------------------- Mensajes --------------------
	;NOTA: en caso de querer cambiar el color se modifica el #m.

	bienvenido: db  0x1b,"[38;5;183m","************************** Bienvenido al Emulador MIPS *************************", 0xa, 0xa
	lbienvenido: equ $-bienvenido
	lab: db 0x1b,"[38;5;86m", "        EL-4313 - Lab Estructura de Microprocesadores", 0xa
	llab: equ $-lab
	sem: db 0x1b,"[38;5;86m", "        IS - 2017", 0xa
	lsem: equ $-sem
	buscando: db 0x1b,"[38;5;86m","        Buscando archivo ROM.txt", 0xa
	lbuscando: equ $-buscando
	encuentra: db 0x1b,"[38;5;86m","        Archivo ROM.txt encontrado", 0xa
	lencuentra: equ $-encuentra
	noencuentra: db 0x1b, "[38;5;86m","        Archivo ROM.txt no encontrado", 0xa
	lnoencuentra: equ $-noencuentra
	inicio:  db 0x1b, "[38;5;86m","        Presione enter para continuar", 0xa
	linicio: equ $-inicio
	exito: db 0x1b, "[38;5;86m","        Ejecución exitosa", 0xa
	lexito: equ $-exito
	fallo: db 0x1b, "[38;5;86m","        Ejecución fallida", 0xa
	lfallo: equ $-fallo
	final: db 0x1b, "[38;5;86m","        Realizado por:", 0xa
	lfinal: equ $-final
	juan: db 0x1b, "[38;5;86m","      	  Juan José Vásquez ", 0xa
	ljuan: equ $-juan
	joao: db 0x1b, "[38;5;86m","     	  Joao Kmil Salas Ramirez 2014096609", 0xa
	ljoao: equ $-joao
	steven: db 0x1b, "[38;5;86m","      	  Steven León Domínguez 2014138025", 0xa
	lsteven: equ $-steven
	andre: db 0x1b, "[38;5;86m","     	  André Martínez Arana 2014068625", 0xa
	landre: equ $-andre
	camila: db 0x1b, "[38;5;86m","     	  Camila Gómez Molina 2014089559", 0xa
	lcamila: equ $-camila
	nfound: db 0x1b, "[38;5;86m","	La instrucción no ha sido encontrada", 0xa
	lnfound: equ $-nfound
	memmax: db 0x1b, "[38;5;41m","	Error: La dirección es mayor a la capacidad de memoria", 0xa
	lmemmax: equ $-memmax

	; -------------------- LECTURA ROM.TXsT --------------------
	file db "./ROM.txt", 0
	len equ 2048
	n db 0

	; -------------------- Imprimir registros --------------------
	filename: db "myfile.txt",0

section .bss

	; -------------------- LECTURA ROM.TXT --------------------
	buffer: resb 2048
	trama: resb 1

	; -------------------- Reservación en memoria para registros MIPS --------------------
	; De 4 bytes = 32 bits.
	reg0: resb 4
	reg1: resb 4
	reg2: resb 4
	reg3: resb 4
	reg4: resb 4
	reg5: resb 4
	reg6: resb 4
	reg7: resb 4
	reg8: resb 4
	reg9: resb 4
	reg10: resb 4
	reg11: resb 4
	reg12: resb 4
	reg13: resb 4
	reg14: resb 4
	reg15: resb 4
	reg16: resb 4
	reg17: resb 4
	reg18: resb 4
	reg19: resb 4
	reg20: resb 4
	reg21: resb 4
	reg22: resb 4
	reg23: resb 4
	reg24: resb 4
	reg25: resb 4
	reg26: resb 4
	reg27: resb 4
	reg28: resb 4
	reg29: resb 4
	reg30: resb 4
	reg31: resb 4

	; -------------------- Reservación en memoria para memoria de datos MIPS --------------------
	datos: resb 400

	; -------------------- Imprimir registros --------------------
	text resw 100 ;Reserva un espacio en memoria

section .text

	global _start

_start:

; -------------------- Imprimir mensajes de bienvenida --------------------
	printString bienvenido,lbienvenido ;Llamado al macro
	printString lab, llab
	printString sem, lsem
	printString buscando, lbuscando

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
	mov r14, [trama+3] ; En r14 se guarda el byte donde esta el OP Code.
	and r14, 11111100b
	shr r14, 2

	; ------ para tipo R (rs,rt,rd,shamt,funct) ------

	mov r10, [trama+3]
	and r10, 11111111b
	mov r11, [trama+2]
	and r11, 11111111b

	mov r12, r11
	and r12, 00011111b ; En r12 está la dirección de 'rt'.

	shl r10, 6
	shr r11, 2
	or r11, r10
	mov r13, r11
	shr r13, 3 ; En r13 está la dirección de 'rs'.

	mov r11, [trama+1] ; En r11 está la dirección de 'rd'
	and r11, 11111000b
	shr r11, 3

	;mov r9, [trama]
	;and r9, 00111111b ; En r9 está 'funct'

	;mov r7, [trama+1]
	;and r7, 11111111b
	;mov r8, [trama]
	;and r8, 11111111b
	;shl r7, 5
	;shr r8, 3
	;or r8, r7
	;mov r10, r8
	;shr r10, 3 ; En r10 está 'shamt'.

	; ------ para tipo I (rs,rt,imm) ------
	; se usa el mismo rs y rt

	;mov r8, [trama+1]
	;and r8, 11111111b
	;shl r8, 8
	;mov r7, [trama]
	;and r7, 11111111b
	;or r8, r7 ; En r8 está immediate.

	; ------ para tipo J (address) ------

	;mov r7, [trama+3]
	;and r7, 11111111b
	;shl r7, 24
	;mov r6, [trama+2]
	;and r6, 11111111b
	;shl r6, 16
	;mov r5, [trama+1]
	;and r5, 11111111b
	;shl r5, 8
	;mov r4, [trama]
	;and r4, 11111111b
	;or r5, r4
	;or r6, r5
	;or r7, r6
	;and r7, 0x0000000003ffffff ; En r7 está address.


	reg_mips r13
	mov rax, rdi ; rax es rs en la alu.
	reg_mips r12
	mov rcx, rdi ; rcx es rt en la alu.


	jmp decode

_exit:
  mov eax, 1
  mov ebx, 0
  int 80h

; -------------------- Decodificación --------------------
decode:
	;mov r13, r14                        ;Se copia la instrucción a otro registro
	;sar r13, 26                         ;y se mueve a la derecha para dejar solo el código de operación

  cmp r14, 100000b                    ;compara con op code, en este caso de add
	je .suma                            ;salta a la etiqueta correspondiente, en este caso .suma
	cmp r14, 000000b                    ;compara con addu
	je .sumau                           ;salta a .sumau
	cmp r14, 001000b                    ;compara con addi
	je .sumai                           ;salta a .sumai
	cmp r14, 001001b                    ;compara con addiu
	je .sumaiu                          ;salta a .sumaiu
	cmp r14, 100100b                   ;compara con and
	je .y                               ;salta a .y
	cmp r14, 001100b                    ;compara con andi
	je .yi                              ;salta a .y
	cmp r14, 000100b                   ;compara con beq
	je .beq                             ;salta a .beq
	cmp r14, 000101b                    ;compara con bne
	je .bne                             ;salta a .bne
	cmp r14, 000010b                    ;compara con j
	je .j                               ;salta a .j
	cmp r14, 000011b                    ;compara con jal
	je .jandl                           ;salta a .jandl
	cmp r14, 001000b                    ;compara con jr
	je .jr                              ;salta a .jr
	cmp r14, 100011b                    ;compara con lw
	je .lw                              ;salta a .lw
	cmp r14, 011000b                    ;compara con mult
	je .mult                            ;salta a .mult
	cmp r14, 100111b                    ;compara con nor
	je .nor                             ;salta a .nor
	cmp r14, 100101b                    ;compara con or
	je .o                               ;salta a .o
	cmp r14, 001101b                    ;compara con ori
	je .ori                             ;salta a .ori
	cmp r14, 101010b                    ;compara con slt
	je .slt                             ;salta a .slt
	cmp r14, 001010b                    ;compara con slti
	je .slti                            ;salta a .slti
	cmp r14, 001001b                    ;compara con sltiu
	je .sltiu                           ;salta a .sltiu
	cmp r14, 101001b                    ;compara con sltu
	je .sltu                            ;salta a .sltu
	cmp r14, 000000b                    ;compara con sll
	je .sll                             ;salta a .sll
	cmp r14, 000010b                    ;compara con srl
	je .srl                             ;salta a .srl
	cmp r14, 100010b                    ;compara con sub
	je .resta                           ;salta a .resta
	cmp r14, 100011b                    ;compara con subu
	je .restau                          ;salta a .restau
	cmp r14, 101011b                    ;compara con sw
	je .sw                              ;salta a .sw

	jmp .instnotfound                   ;si la instrucción no se
		                                      ;encuentra en el set que
		                                      ;maneja el procesador
		                                      ;se ejecuta una rutina que
		                                      ;lo informa en pantalla

; -------------------- Rutinas correspondientes a cada inst --------------------
.suma:

.sumau:
	alu 2 ; suma rax y rcx. resultado en rbx.
	reg_mips r11
	mov [rsi], rbx ; Mueve resultado a registro mips rd.
.sumai:

.sumaiu:

.y:
	alu 0
	reg_mips r11
	mov [rsi], rbx ; Mueve resultado a registro mips rd.
.yi:

.beq:

.bne:

.j:

.jandl:

.jr:

.lw:
	sign_ext r8															;Se toma el inmediato y se extiende el signo
	reg_mips r13														;se utiliza la macro para obtener el valor y dirección de Rs
	add r13, r8															;se suman ambos valores para calcular la dirección de memoria
	cmp r13, 100
	ja memoverflow
	mov rax, 4															;se multiplica por 4 ya que la memoria se divide en bytes (palabras de 4*8bits)
	mul r13
	add rax, datos 													;se suma a datos ya que es el valor inicial de memoria de datos en el computador real
	mov rax, [rax]													;se toma ese valor de memoria y se guarda de nuevo en rax
	reg_mips r12
	mov [rsi], rax													;se guarda el valor sacado de memoria de datos al registro destino Rt

.mult:
	alu 6
	reg_mips r11
	mov [rsi], rbx ; Mueve resultado a registro mips rd.
.nor:
	alu 5
	reg_mips r11
	mov [rsi], rbx ; Mueve resultado a registro mips rd.
.o:
	alu 1
	reg_mips r11
	mov [rsi], rbx ; Mueve resultado a registro mips rd.
.ori:

.slt:

.slti:

.sltiu:

.sltu:
	alu 4
	reg_mips r11
	mov [rsi], rbx ; Mueve resultado a registro mips rd.
.sll:

.srl:

.resta:

.restau:
	alu 3
	reg_mips r11
	mov [rsi], rbx ; Mueve resultado a registro mips rd.
.sw:
	sign_ext r8															;Se toma el inmediato y se extiende el signo
	reg_mips r13														;se utiliza la macro para obtener el valor y dirección de Rs
	add r13, r8															;se suman ambos valores para calcular la dirección de memoria
	cmp r13, 100
	ja memoverflow
	mov rax, 4															;se multiplica por 4 ya que la memoria se divide en bytes (palabras de 4*8bits)
	mul r13
	add rax, datos 													;se suma a datos ya que es el valor inicial de memoria de datos en el computador real
	reg_mips r12
	mov [rax], rdi													;se toma el valor de rt y se guarda en la dirección calculada en rax


memoverflow:
	printString memmax, lmemmax


.nextinst:


; -------------------- Error de instruccíon no encontrada --------------------
.instnotfound:
							printString nfound, lnfound

; -------------------- Imprimir registros --------------------
;printVal r8 ; Imprime registro del resultado.

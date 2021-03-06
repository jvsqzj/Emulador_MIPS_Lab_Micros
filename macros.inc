%include "linux64.inc"
;							 Sección de variables iniciaizadas
section .data

	; -------------------- Mensajes --------------------
	;NOTA: en caso de querer cambiar el color se modifica el #m.

	;Mensajes de inicio
	bienvenido: db  0x1b,"[38;5;212m","        ****************** Bienvenido al Emulador MIPS *****************", 0xa, 0xa
	lbienvenido: equ $-bienvenido
	lab: db 0x1b,"[38;5;212m", "        EL-4313 - Laboratorio Estructura de Microprocesadores",
	llab: equ $-lab
	sem: db 0x1b,"[38;5;212m", " IS - 2017", 0xa, 0xa
	lsem: equ $-sem
	buscando: db 0x1b,"[38;5;31m","        Buscando archivo ROM.txt.", 0xa
	lbuscando: equ $-buscando
	encuentra: db "        Archivo ROM.txt encontrado.", 0xa
	lencuentra: equ $-encuentra
	mensajeinicio:  db 0x1b, "[38;5;86m","        Presione la tecla enter para continuar.", 0xa
	lmensajeinicio: equ $-mensajeinicio

	;Información de los miembros del equipo
	final: db 0x1b, "[38;5;68m","        Realizado por:", 0xa
	lfinal: equ $-final
	juan: db  "      	  Juan José Vásquez Alfaro  2014098487", 0xa
	ljuan: equ $-juan
	joao: db  "     	  Joao Salas Ramirez        2014096609", 0xa
	ljoao: equ $-joao
	steven: db  "      	  Steven León Domínguez     2014138025", 0xa
	lsteven: equ $-steven
	andre: db  "     	  André Martínez Arana      2014068625", 0xa
	landre: equ $-andre
	camila: db  "     	  Camila Gómez Molina       2014089559", 0xa
	lcamila: equ $-camila

	;Mensajes finales
	exito: db 0x1b, "[38;5;86m","        Ejecución exitosa.", 0xa
	lexito: equ $-exito
	theend: db 0x1b, "[38;5;86m","	Presione la tecla enter para finalizar.", 0xa
	ltheend: equ $-theend

	;Posibles errores
	noencuentra: db 0x1b, "[38;5;9m","        Error: El archivo ROM.txt no ha sido localizado.", 0xa
	lnoencuentra: equ $-noencuentra
	nfound: db 0x1b, "[38;5;9m","	Error: La instrucción no ha sido reconocida.", 0xa
	lnfound: equ $-nfound
	memmax: db 0x1b, "[38;5;9m","	Error: La dirección es mayor a la capacidad de memoria.", 0xa
	lmemmax: equ $-memmax
	invdir: db 0x1b, "[38;5;9m","	Error: El registro utilizado no contiene una dirección de retorno válida.", 0xa
	linvdir: equ $-invdir
	pointofnoreturn: db 0x1b, "[38;5;9m","	Error: No existe una dirección de retorno.", 0xa
	lpointofnoreturn: equ $-pointofnoreturn
	fallo: db 0x1b, "[38;5;9m","        Ejecución fallida.", 0xa
	lfallo: equ $-fallo

	;Info del cpu
	cpuid2: db 0x1b, "[38;5;31m","	CPU ID:", 0xa
	lcpuid2: equ $-cpuid2

	;Instrucciones
	sumar: db 0x1b, "[38;5;41m","      	  Ejecutando add $"
	lsumar: equ $-sumar
	sumaru: db 0x1b, "[38;5;41m","      	  Ejecutando addu $"
	lsumaru: equ $-sumaru
	sumari: db 0x1b, "[38;5;41m","      	  Ejecutando addi $"
	lsumari: equ $-sumari
	sumariu: db 0x1b, "[38;5;41m","      	  Ejecutando addiu $"
	lsumariu: equ $-sumariu
	lalaland: db 0x1b, "[38;5;41m","      	  Ejecutando and $"
	lalalaland: equ $-lalaland
	lalalandi: db 0x1b, "[38;5;41m","      	  Ejecutando andi $"
	lalalalandi: equ $-lalalandi
	branchequal: db 0x1b, "[38;5;41m","      	  Ejecutando beq $"
	lbranchequal: equ $-branchequal
	branchnequal: db 0x1b, "[38;5;41m","      	  Ejecutando bne $"
	lbranchnequal: equ $-branchnequal
	jump: db 0x1b, "[38;5;41m","      	  Ejecutando j "
	ljump: equ $-jump
	jumpal: db 0x1b, "[38;5;41m","      	  Ejecutando jal "
	ljumpal: equ $-jumpal
	jumpreg: db 0x1b, "[38;5;41m","      	  Ejecutando jr $"
	ljumpreg: equ $-jumpreg
	storew: db 0x1b, "[38;5;41m","      	  Ejecutando sw $"
	lstorew: equ $-storew
	loadw: db 0x1b, "[38;5;41m","      	  Ejecutando lw $"
	lloadw: equ $-loadw
	multiplicar: db 0x1b, "[38;5;41m","      	  Ejecutando mult $"
	lmultiplicar: equ $-multiplicar
	nordico: db 0x1b, "[38;5;41m","      	  Ejecutando nor $"
	lnordico: equ $-nordico
	orcito: db 0x1b, "[38;5;41m","      	  Ejecutando or $"
	lorcito: equ $-orcito
	oricito: db 0x1b, "[38;5;41m","      	  Ejecutando ori $"
	loricito: equ $-oricito
	slthan: db 0x1b, "[38;5;41m","      	  Ejecutando slt $"
	lslthan: equ $-slthan
	slthani: db 0x1b, "[38;5;41m","      	  Ejecutando slti $"
	lslthani: equ $-slthani
	slthanu: db 0x1b, "[38;5;41m","      	  Ejecutando sltu $"
	lslthanu: equ $-slthanu
	slthaniu: db 0x1b, "[38;5;41m","      	  Ejecutando sltiu $"
	lslthaniu: equ $-slthaniu
	shiftl: db 0x1b, "[38;5;41m","      	  Ejecutando sll $"
	lshiftl: equ $-shiftl
	shiftr: db 0x1b, "[38;5;41m","      	  Ejecutando srl $"
	lshiftr: equ $-shiftr
	restar: db 0x1b, "[38;5;41m","      	  Ejecutando sub $"
	lrestar: equ $-restar
	restaru: db 0x1b, "[38;5;41m","      	  Ejecutando subu $"
	lrestaru: equ $-restaru

	; Comodines
	retorno: db 0xa
	lretorno: equ $-retorno
	comma: db ", "
	lcomma: equ $-comma
	parentizq: db  "("
	lparentizq: equ $-parentizq
	parentder: db  ")"
	lparentder: equ $-parentder
	dolar: db  "$"
	ldolar: equ $-dolar
	teclado: dq '-'
	cleanS:    db 0x1b, "[2J", 0x1b, "[H"
	cleanS_size: equ $ - cleanS
	tap: db 9
	log: db 'Resultados.txt',0

	; -------------------- Lectura ROM.txt ------------------------
	;AQUIMODIFIQUE
	file db "./ROM.txt", 0
	len equ 2048
	n db 0

	; -------------------- Imprimir registros --------------------
	filename: db "myfile.txt",0
	linea: db  0x1b,"[38;5;209m","        ****************** Contenido de registros MIPS ******************", 0xa
	llinea: equ $-linea
	linea2: db  0x1b,"[38;5;209m","        ****************************************************************", 0xa
	llinea2: equ $-linea2
	nuevaLinea: db 10
	tab: db 9
	reg2s: db  0x1b,"[38;5;35m","				$v0	"
	lreg2s: equ $-reg2s
	reg3s: db   "				$v1	"
	lreg3s: equ $-reg3s
	reg4s: db   "				$a0	"
	lreg4s: equ $-reg4s
	reg5s: db   "				$a1	"
	lreg5s: equ $-reg5s
	reg6s: db   "				$a2	"
	lreg6s: equ $-reg6s
	reg7s: db   "				$a3	"
	lreg7s: equ $-reg7s
	reg16s: db   "				$s0	"
	lreg16s: equ $-reg16s
	reg17s: db   "				$s1	"
	lreg17s: equ $-reg17s
	reg18s: db   "				$s2	"
	lreg18s: equ $-reg18s
	reg19s: db   "				$s3	"
	lreg19s: equ $-reg19s
	reg20s: db   "				$s4	"
	lreg20s: equ $-reg20s
	reg21s: db   "				$s5	"
	lreg21s: equ $-reg21s
	reg22s: db   "				$s6	"
	lreg22s: equ $-reg22s
	reg23s: db   "				$s7	"
	lreg23s: equ $-reg23s
	reg29s: db   "				$sp	"
	lreg29s: equ $-reg29s

	; -------------------- Para argumentos --------------------
	m db 0

%macro ImprimirRegistros 0
	printString linea, llinea
	mov r9, 0

;----------------------------- v0 v1 ------------------------
%%L90:
	cmp r9, 31
	ja %%endloop90
	cmp r9, 2
	jne %%l20
	printString reg2s, lreg2s
	mov eax, [reg2]
	jmp %%imprimirloop

%%l20:
	cmp r9, 3
	jne %%l21
	printString reg3s, lreg3s
	mov eax, [reg3]
	jmp %%imprimirloop

;-------------------------- a0 a1 a2 a3 ----------------------
%%l21:
	cmp r9, 4
	jne %%l22
	printString reg4s, lreg4s
	mov eax, [reg4]
	jmp %%imprimirloop

%%l22:
	cmp r9, 5
	jne %%l23
	printString reg5s, lreg5s
	mov eax, [reg5]
	jmp %%imprimirloop

%%l23:
	cmp r9, 6
	jne %%l24
	printString reg6s, lreg6s
	mov eax, [reg6]
	jmp %%imprimirloop

%%l24:
	cmp r9, 7
	jne %%l25
	printString reg7s, lreg7s
	mov eax, [reg7]
	jmp %%imprimirloop

;-------------------------- s0 s1 s2 s3 s4 s5 s6 s7 ---------------------
%%l25:
	cmp r9, 16
	jne %%l26
	printString reg16s, lreg16s
	mov eax, [reg16]
	jmp %%imprimirloop

%%l26:
	cmp r9, 17
	jne %%l27
	printString reg17s, lreg17s
	mov eax, [reg17]
	jmp %%imprimirloop

%%l27:
	cmp r9, 18
	jne %%l28
	printString reg18s, lreg18s
	mov eax, [reg18]
	jmp %%imprimirloop

%%l28:
	cmp r9, 19
	jne %%l29
	printString reg19s, lreg19s
	mov eax, [reg19]
	jmp %%imprimirloop

%%l29:
	cmp r9, 20
	jne %%l30
	printString reg20s, lreg20s
	mov eax, [reg20]
	jmp %%imprimirloop

%%l30:
	cmp r9, 21
	jne %%l31
	printString reg21s, lreg21s
	mov eax, [reg21]
	jmp %%imprimirloop

%%l31:
	cmp r9, 22
	jne %%l32
	printString reg22s, lreg22s
	mov eax, [reg22]
	jmp %%imprimirloop

%%l32:
	cmp r9, 23
	jne %%l33
	printString reg23s, lreg23s
	mov eax, [reg23]
	jmp %%imprimirloop

%%l33:
	cmp r9, 29
	jne %%l34
	printString reg29s, lreg29s
	mov eax, [stackaddress]
	jmp %%imprimirloop

%%l34:
	inc r9
	jmp %%L90

%%imprimirloop:
	printVal rax
	printString nuevaLinea, 1
	inc r9
	jmp %%L90
%%endloop90:

	printString linea2, llinea2
	printString retorno, lretorno
%endmacro

;--------------- Macro para pasar de ascii a entero --------------

%macro ASCIIaENTERO 1
	and %1, 11111111b																 ; Guardar solo ultimos 8 bits
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

;---------- Macro para determinar los argumentos de entrada ------------

%macro DeterminarArgumento 1
	mov %1, [rax]
	and %1, 11111111b 																; Guardar solo ultimos 8 bits
	cmp %1, 0
	je seguir																					; Si es NULL terminar loop
	cmp %1, 45
	jne %%L2
	mov %1, 0
	jmp seguir
%%L2
	cmp %1, 96
	ja %%elseL1
	sub %1, 48																				; Si es una numero, restar 48 para pasar de ASCII a decimal
	jmp %%end
	%%elseL1:
	sub %1, 87																				; Si es una letra, restar 87 para pasar de ASCII a decimal
	%%end:
%%L1:
	mov r14, [rax+r15]
	and r14, 11111111b															  ; Guardar solo ultimos 8 bits
	cmp r14, 0
	je seguir
	cmp r14, 96
	ja %%elseL2
	sub r14, 48
	jmp %%end2
	%%elseL2:
	sub r14, 87
	%%end2:

	shl %1, 4
	add %1, r14
	inc r15
	jmp %%L1
%endmacro


; Macro que simula el comportamiento de la ALU para las instrucciones que interesan

%macro alu 1 ; 1 parámetro como "señal de ctrl".
	mov rdx, %1 																; "OP Code" de ALU. Se guarda en rdx.
%%and:
	cmp rdx, 0 																	; 0 = AND.
	jne %%or 																		; Si no es, pasa a siguiente opción.
	and rax, rcx 																; rax (rs) AND rcx (rt).
	jmp %%result 																; Concluida la operación, pasa a resultado.
%%or:
	cmp rdx, 1 																	; 1 = OR.
	jne %%add 																	; Si no es, pasa a siguiente opción.
	or rax, rcx																  ; rax (rs) OR rcx (rt).
	jmp %%result 																; Concluida la operación, pasa a resultado.
%%add:
	cmp rdx, 2 																	; 2 = ADD.
	jne %%substract 														; Si no es, pasa a siguiente opción.
	add rax, rcx 																; rax (rs) + rcx (rt).
	jmp %%result 																; Concluida la operación, pasa a resultado.
%%substract:
	cmp rdx, 3																	; 3 = SUB.
	jne %%set_on_less_than 											; Si no es, pasa a siguiente opción.
	sub rax, rcx 																; rax (rs) - rcx (rt).
	jmp %%result 																; Concluida la operación, pasa a resultado.
%%set_on_less_than:
	cmp rdx, 4																	; 4 = SLTU.
	jne %%nor 																	; Si no es, pasa a siguiente opción.
	cmp rcx, rax
	jg %%true  																	; Si rcx (rt) > rax(rs).
	jmp %%false 																; Si no.
	%%true:
		mov rbx, 1b 															; Un 1 en rbx (rd).
		jmp %%end 																; Se pasa a fin porque ya resultado está en rd.
	%%false:
		mov rbx, 0b 															; Un 0 en rbx (rd).
		jmp %%end																	; Se pasa a fin porque ya resultado está en rd.
%%nor:
	cmp rdx, 5																	; 5 = NOR.
	jne %%multiply 															; Si no es, pasa a siguiente opción.
	or rax, rcx 																; rax (rs) OR rcx (rt).
	not rax 																		; NOT rax (rs).
	jmp %%result 																; Concluida la operación, pasa a resultado.
%%multiply:
	cmp rdx, 6 																	; 6 = MULT.
	jne %%end 																	; Si no es, pasa a resultal sin hacer nada.
	mul rcx 																		; rax (rs) * rcx (rt).
	jmp %%result 																; Concluida la operación, pasa a resultado.
%%result: 																		; Las operaciones realizadas ponen su resultado en rax.
	mov rbx, rax 																; Mueve resultado de operación a rbx (rd).
%%end: 																				; Etiqueta para casos de no hacer nada.
%endmacro


; Macro que toma un los registros en los que están las direcciones
;de los registros MIPS de la instrucción y le asigna a rsi la
;dirección correspondiente en memoria de la PC y a rdi el dato
;contenido en dicha dirección.

%macro reg_mips 1 ; 1 parámetro: registro donde está la dirección de rt, rs o rd.
	mov rdx, %1
	and rdx, 0x000000000000001f 								; Aseguro que queden sólo los 5 bit de la dirección.
%%cero:
	cmp rdx, 0x0000000000000000
	jne %%uno
	mov rsi, reg0																; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg0] 														; Se guarda en rdi el dato del reg0 (en memoria).
	jmp %%listo
%%uno:
	cmp rdx, 0x0000000000000001
	jne %%dos
	mov rsi, reg1 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg1] 														; Se guarda en rdi el dato del reg1 (en memoria).
	jmp %%listo
%%dos:
	cmp rdx, 0x0000000000000002
	jne %%tres
	mov rsi, reg2 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg2] 														; Se guarda en rdi el dato del reg2 (en memoria).
	jmp %%listo
%%tres:
	cmp rdx, 0x0000000000000003
	jne %%cuatro
	mov rsi, reg3 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg3] 														; Se guarda en rdi el dato del reg3 (en memoria).
	jmp %%listo
%%cuatro:
	cmp rdx, 0x0000000000000004
	jne %%cinco
	mov rsi, reg4 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg4] 														; Se guarda en rdi el dato del reg4 (en memoria).
	jmp %%listo
%%cinco:
	cmp rdx, 0x0000000000000005
	jne %%seis
	mov rsi, reg5 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg5] 														; Se guarda en rdi el dato del reg5 (en memoria).
	jmp %%listo
%%seis:
	cmp rdx, 0x0000000000000006
	jne %%siete
	mov rsi, reg6 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg6] 														; Se guarda en rdi el dato del reg6 (en memoria).
	jmp %%listo
%%siete:
	cmp rdx, 0x0000000000000007
	jne %%ocho
	mov rsi, reg7 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg7] 														; Se guarda en rdi el dato del reg7 (en memoria).
	jmp %%listo
%%ocho:
	cmp rdx, 0x0000000000000008
	jne %%nueve
	mov rsi, reg8 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg8] 														; Se guarda en rdi el dato del reg8 (en memoria).
	jmp %%listo
%%nueve:
	cmp rdx, 0x0000000000000009
	jne %%diez
	mov rsi, reg9 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg9] 														; Se guarda en rdi el dato del reg9 (en memoria).
	jmp %%listo
%%diez:
	cmp rdx, 0x000000000000000a
	jne %%once
	mov rsi, reg10 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg10] 														; Se guarda en rdi el dato del reg10 (en memoria).
	jmp %%listo
%%once:
	cmp rdx, 0x000000000000000b
	jne %%doce
	mov rdi, [reg11] 														; Se guarda en rdi el dato del reg11 (en memoria).
	mov rsi, reg11 															; Se guarda en rsi la dirección del registro mips.
	jmp %%listo
%%doce:
	cmp rdx, 0x000000000000000c
	jne %%trece
	mov rsi, reg12 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg12]														; Se guarda en rdi el dato del reg12 (en memoria).
	jmp %%listo
%%trece:
	cmp rdx, 0x000000000000000d
	jne %%catorce
	mov rsi, reg13 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg13] 														; Se guarda en rdi el dato del reg13 (en memoria).
	jmp %%listo
%%catorce:
	cmp rdx, 0x000000000000000e
	jne %%quince
	mov rsi, reg14 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg14] 														; Se guarda en rdi el dato del reg14 (en memoria).
	jmp %%listo
%%quince:
	cmp rdx, 0x000000000000000f
	jne %%dieciseis
	mov rsi, reg15 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg15] 														; Se guarda en rdi el dato del reg15 (en memoria).
	jmp %%listo
%%dieciseis:
	cmp rdx, 0x0000000000000010
	jne %%diecisiete
	mov rsi, reg16 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg16] 														; Se guarda en rdi el dato del reg16 (en memoria).
	jmp %%listo
%%diecisiete:
	cmp rdx, 0x0000000000000011
	jne %%dieciocho
	mov rsi, reg17 															; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg17] 														; Se guarda en rdi el dato del reg17 (en memoria).
	jmp %%listo
%%dieciocho:
	cmp rdx, 0x0000000000000012
	jne %%diecinueve
	mov rsi, reg18 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg18] ; Se guarda en rdi el dato del reg18 (en memoria).
	jmp %%listo
%%diecinueve:
	cmp rdx, 0x0000000000000013
	jne %%veinte
	mov rsi, reg19 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg19] ; Se guarda en rdi el dato del reg19 (en memoria).
	jmp %%listo
%%veinte:
	cmp rdx, 0x0000000000000014
	jne %%ventiuno
	mov rsi, reg20 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg20] ; Se guarda en rdi el dato del reg20 (en memoria).
	jmp %%listo
%%ventiuno:
	cmp rdx, 0x0000000000000015
	jne %%ventidos
	mov rsi, reg21 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg21] ; Se guarda en rdi el dato del reg21 (en memoria).
	jmp %%listo
%%ventidos:
	cmp rdx, 0x0000000000000016
	jne %%ventitres
	mov rsi, reg22 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg22] ; Se guarda en rdi el dato del reg22 (en memoria).
	jmp %%listo
%%ventitres:
	cmp rdx, 0x0000000000000017
	jne %%venticuatro
	mov rsi, reg23 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg23] ; Se guarda en rdi el dato del reg23 (en memoria).
	jmp %%listo
%%venticuatro:
	cmp rdx, 0x0000000000000018
	jne %%venticinco
	mov rsi, reg24 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg24] ; Se guarda en rdi el dato del reg24 (en memoria).
	jmp %%listo
%%venticinco:
	cmp rdx, 0x0000000000000019
	jne %%ventiseis
	mov rsi, reg25 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg25] ; Se guarda en rdi el dato del reg25 (en memoria).
	jmp %%listo
%%ventiseis:
	cmp rdx, 0x000000000000001a
	jne %%ventisiete
	mov rsi, reg26 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg26] ; Se guarda en rdi el dato del reg26 (en memoria).
	jmp %%listo
%%ventisiete:
	cmp rdx, 0x000000000000001b
	jne %%ventiocho
	mov rdi, [reg27] ; Se guarda en rdi el dato del reg (en memoria).
	mov rsi, reg27 ; Se guarda en rsi la dirección del registro mips.
	jmp %%listo
%%ventiocho:
	cmp rdx, 0x000000000000001c
	jne %%ventinueve
	mov rsi, reg28 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg28] ; Se guarda en rdi el dato del reg28 (en memoria).
	jmp %%listo
%%ventinueve:
	cmp rdx, 0x000000000000001d
	jne %%treinta
	mov rsi, reg29 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg29] ; Se guarda en rdi el dato del reg29 (en memoria).
	jmp %%listo
%%treinta:
	cmp rdx, 0x000000000000001e
	jne %%treintayuno
	mov rsi, reg30 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg30] ; Se guarda en rdi el dato del reg30 (en memoria).
	jmp %%listo
%%treintayuno:
	cmp rdx, 0x000000000000001f
	jne %%listo
	mov rsi, reg31 ; Se guarda en rsi la dirección del registro mips.
	mov rdi, [reg31] ; Se guarda en rdi el dato del reg31 (en memoria).
%%listo:
and rdi, 0x00000000ffffffff ; Máscara.
%endmacro


; Macro que realiza la extensión de signo y la guarda en r11.
%macro sign_ext 1
  mov rdx, %1
  mov rsi, %1
  shr rdx, 15 ; se corre para analizar bit 15.
  cmp rdx, 0x0000000000000001
  jne %%cerillo
  mov r8, 0x00000000ffff0000 ; Si es 1 el bit 15.
  jmp %%see
%%cerillo:
  mov r8, 0x0000000000000000 ; Si es 0 el bit 15.
%%see:
  or r8, rsi ; Se agrega inmediato en la parte baja de r8.
	mov r11, r8
%endmacro


; Macro que calcula branch address y la guarda en r11.
%macro branch_add 1 ;hola
  mov rdx, %1
  mov rsi, %1
  shr rdx, 15 ; se corre para analizar bit 15.
  cmp rdx, 0x0000000000000001
  jne %%cerillo
  mov rbp, 0x00000000fffc0000 ; Si es 1 el bit 15.
  jmp %%see
%%cerillo:
  mov rbp, 0x0000000000000000 ; Si es 0 el bit 15.
%%see:
  shl rsi, 2
  or rbp, rsi ; Se agrega inmediato con dos 0's al final.
	mov r11, rbp
%endmacro


; Macro que separa la instrucción binaria en las partes del formato R.
%macro separarR 1                   ;Recibe un parametro donde vendrá la instrucción
  mov r13, %1                       ;en r13 se tendrá el Rs
  mov r12, %1                       ;en r12 se tendrá el Rt
  mov r11, %1                       ;en r11 se tendrá el Rd
  mov r10, %1                       ;en r10 se tendrá el shamt
  mov r9, %1                        ;en r9 se tendrá el funct
  and r13, 0x0000000003e00000       ;Se filtra todo lo que no es Rs
  shr r13, 21                       ;y se coloca al inicio del registro
  and r12, 0x00000000001f0000       ;Se filtra todo lo que no es Rt
  shr r12, 16                       ;y se coloca al inicio del registro
  and r11, 0x000000000000f900       ;Se filtra todo lo que no es Rd
  shr r11, 11                       ;y se coloca al inicio del registro
  and r10, 0x00000000000007c0       ;Se filtra todo lo que no es shamt
  shr r10, 6                        ;y se coloca al inicio del registro
  and r9, 0x000000000000003f       ;Se filtra todo lo que no es funct
  reg_mips r13
  mov rax, rdi ; rax es rs en la alu.
	shl rax, 32
	shr rax, 32 ; Cortar dato a 32 bits.
  reg_mips r12
  mov rcx, rdi ; rcx es rt en la alu.
	shl rcx, 32
	shr rcx, 32	; Cortar dato a 32 bits.
%endmacro


; Macro que separa la instrucción binaria en las partes del formato I.
%macro separarI 1                   ;Recibe un parametro donde vendrá la instrucción
  mov r13, %1                       ;en r13 se tendrá el Rs
  mov r12, %1                       ;en r12 se tendrá el Rt
  mov r11, %1
  and r13, 0x0000000003e00000       ;Se filtra todo lo que no es Rs
  shr r13, 21                       ;y se coloca al inicio del registro
  and r12, 0x00000000001f0000       ;Se filtra todo lo que no es Rt
  shr r12, 16                       ;y se coloca al inicio del registro
  and r11, 0x000000000000ffff       ;Se filtra todo lo que no es immediate
%endmacro


; Macro que separa la instrucción binaria en las partes del formato J.
%macro separarJ 1                   ;Recibe un parametro donde vendrá la instrucción
  mov r14, %1                       ;en r14 está el OP Code.
	mov r13, %1                       ;en r13 se tendrá address
  and r14, 0x00000000fc000000
	shr r14, 26												;se corren para dejar solo el opcode
  and r13, 0x0000000003ffffff
%endmacro

; Perifericos
VOLTAR				EQU		190H
ON_OFF				EQU		1A0H
SEL_NR_MENU		EQU		1B0H
OK					EQU		1C0H
CHANGE				EQU		1D0H
CANCEL				EQU		1E0H
PESO				EQU		1F0H

; Display
Display				EQU			200H
Display_end 		EQU			26FH
CaracterVazio 		EQU 		20H	

;valores
CODIGO_MIN		EQU		100
CODIGO_MAX		EQU		124
PESO_MAX		EQU		30


STACK_PRT			EQU			1000H

PLACE 2000H
MenuPrincipal:
	String " MENU PRINCIPAL "
	String "1 - BALANÇA     "
	String "2 - REGISTOS    "
	string "----------------"
	String "3 - LIMPAR      "
	String "    REGISTOS    "
	String "                "
	
PLACE 2080H
ModoBalanca:
	; cenas
	
PLACE 0000H
Inicio:	
		MOV R0, Principio
		JMP R0

Place 3000H
Principio:
		MOV SP, STACK_PRT
		CALL LimpaDisplay
		CALL LimpaPerifericos
		MOV R0, ON_OFF
Liga:
		MOVB R1, [R0]
		CMP R1, 1
		JNE Liga
Ligado:	
		MOV R2, MenuPrincipal
		CALL MostraDisplay
		CALL LimpaPerifericos
Le_nr:
	 MOV R0, SEL_NR_MENU
	 MOV R2, OK	;verifica que OK foi selecionado
	MOVB R3, [R2]
	
	CMP R3, 1	;nao avanca enquanto OK=0
	 MOVB R1, [R0]	 ; Le o valor do periferico
	CMP R1, 1      
	 JEQ OModoBalanca
	CMP R1, 2	; opcao registos
	JEQ ORegistos
	CMP R1, 3	; opcao limpar registos
	JEQ OLimpaRegistos
	CALL MostraErro
	JMP Ligado

		
;------------------
; Mostra Display
;------------------		
MostraDisplay:
	    PUSH R0
	    PUSH R1
	    PUSH R2      ; string
	    PUSH R3      
	    MOV R0, Display
	    MOV R1, Display_end
CicloDisplay:  
	    MOVB R3, [R2]        ; lê o caractere da string 
	    MOVB [R0], R3        ; escreve o caractere no display 
	    ADD R0, 1            ; incrementa apontador do display
	    ADD R2, 1            ; incrementa apontador da string
	    CMP R0, R1           ; verifica se já chegou ao fim do Display
	    JLE CicloDisplay
	    POP R3
	    POP R2
	    POP R1
	    POP R0
	    RET
;--------------------
; Limpa Perifericos
;--------------------
LimpaPerifericos:
	    PUSH R0
	    PUSH R1
	    
	    MOV R0, ON_OFF
	    MOV R1, 0
	    MOVB [R0], R1
	    MOV R0, SEL_NR_MENU
	    MOVB [R0], R1
	    MOV R0, OK
	    MOVB [R0], R1
	    MOV R0, CHANGE
	    MOVB [R0], R1
	    MOV R0, CANCEL
	    MOVB [R0], R1
	    MOV R0, PESO
	    MOVB [R0], R1
    
	    POP R1
	    POP R0
	    RET
    
 ;--------------------
; Limpa Display
;--------------------
LimpaDisplay:
	    PUSH R0
	    PUSH R1
	    PUSH R2
	    
	    MOV R0, Display    
	    MOV R1, Display_end 
	    MOV R2, CaracterVazio 
	    
LimpaLoop:
	    MOVB [R0], R2        ; Escreve o caractere espaço no Display
	    ADD R0, 1            ; Incrementa o apontador do Display
	    CMP R0, R1           ; Verifica se chegou ao fim do Display
	    JLE LimpaLoop     
	    
	    POP R2
	    POP R1
	    POP R0
	    RET
    
;--------------------
; Modo Balanca
;--------------------
OModoBalanca:
	MOV R0, ON_OFF
	MOV R1, SEL_NR_MENU
	MOV R2, OK
	MOV R3, CHANGE
	MOV R4, CANCEL
	MOV R5, PESO

	CALL LimpaDisplay
	CALL LimpaPerifericos
	CALL MostraBalanca

	; Verifica se CHANGE=1
	MOVB R6, [R3]
	MOV R7, 1
	CMP R6, R7
	JEQ MostraProdutos

Le_codigo:
	MOV R6, [R1]      ; lê SEL_NR_MENU
	MOVB R7, [R2]     ; lê OK
	MOV R0, 1
	CMP R7, R0
	JEQ Le_codigo     ; espera até OK = 1

	MOV R0, 0
	CMP R6, R0
	JEQ NenhumProdutoSel

	; Verifica se o codigo esta dentro do intervalo valido
	MOV R0, CODIGO_MIN
	CMP R6, R0
	JLT ERRO_Sel
	MOV R0, CODIGO_MAX
	CMP R6, R0
	JGT ERRO_Sel

	; Verifica o peso
	MOV R7, [R5]
	MOV R0, PESO_MAX
	CMP R7, R0

	JMP OModoBalanca

MostraBalanca:
	RET

NenhumProdutoSel:
	JMP OModoBalanca

ERRO_Sel:
	JMP MostraProdutos

MostraProdutos:
	JMP OModoBalanca


ORegistos:
	JMP Ligado
	
OLimpaRegistos:
	JMP Ligado
	
MostraErro:
	JMP Ligado
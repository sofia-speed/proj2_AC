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
Tamanho_String		EQU			16

;valores
CODIGO_MIN		EQU		100
CODIGO_MAX		EQU		124
PESO_MAX		EQU		3000	;30kg = 3000g

STACK_PRT			EQU			1000H

;preco dos produtos (em centimos!)
PLACE 4000H
BaseDados:
	TABLE 25
	Word 534
	Word 187
	Word 187
	Word 356
	Word 446
	Word 258
	Word 446
	Word 1781
	Word 160
	Word 222
	Word 104
	Word 114
	Word 228
	Word 523
	Word 619
	Word 143
	Word 142
	Word 219
	Word 095
	Word 362
	Word 407
	Word 892
	Word 1839
	Word 803
	Word 2025
	
PLACE 4200H
NomesProdutos:
	String "Uvas           "
	String "Melancia       "
	String "Ananás         "
	String "Kiwi           "
	String "Pêssego        "
	String "Banana         "
	String "Morango        "
	String "Framboesa      "
	String "Laranja        "
	String "Tangerina      "
	String "Cenoura        "
	String "Batata         "
	String "Nabo           "
	String "Beterraba      "
	String "Alho           "
	String "Cebola         "
	String "Ervilha        "
	String "Lentilhas      "
	String "Trigo          "
	String "Milho          "
	String "Favas          "
	String "Castanhas      "
	String "Noz            "
	String "Amendoim       "
	String "Café           "

PLACE 2000H
MenuPrincipal:
	String " MENU PRINCIPAL "
	String "1 - BALANÇA     "
	String "2 - REGISTOS    "
	string "----------------"
	String "3 - LIMPAR      "
	String "    REGISTOS    "
	String "                "
	
PLACE 2100H
DisplayBalancaVazia:
	String "  MODO BALANCA  "
	String "----------------"
	String " NENHUM PRODUTO "
	String "  SELECIONADO   "
	String "                "	
	String "OK PARA         "	
	String "CONTINUAR       "	
	
 PLACE 2200H
DisplayBalanca:
	String "                "		; nome do produto
	String "                "	
	String "PESO:           "	
	String "                "		; peso do produto
	String "PRECO           "	
	String "                "		; preco do produto por kg
	String "TOTAL           "	
               
	
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
		MOV R10, MenuPrincipal
		CALL MostraDisplay
		CALL LimpaPerifericos
Le_nr:
	 MOV R0, SEL_NR_MENU
	 MOV R2, OK	;verifica que OK foi selecionado
	MOVB R3, [R2]
	
	CMP R3, 1	;nao avanca enquanto OK=0
	JNE Le_nr
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
; R10 guarda a memoria dos displays	
MostraDisplay:
	    PUSH R0
	    PUSH R1
	    PUSH R10      ; string
	    PUSH R3      
	    MOV R0, Display
	    MOV R1, Display_end
CicloDisplay:  
	    MOVB R3, [R10]        ; lê o caractere da string 
	    MOVB [R0], R3        ; escreve o caractere no display 
	    ADD R0, 1            ; incrementa apontador do display
	    ADD R10, 1            ; incrementa apontador da string
	    CMP R0, R1           ; verifica se já chegou ao fim do Display
	    JLE CicloDisplay
	    POP R3
	    POP R10
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
	MOV R10, DisplayBalancaVazia

	CALL LimpaDisplay
	CALL LimpaPerifericos
	CALL MostraDisplay

BalancaCiclo:
	; Verifica se CHANGE=1
	MOVB R6, [R3]
	CMP R6, 1
	JEQ MostraProdutos

Le_codigo:
	MOVB R6, [R1]      ; lê SEL_NR_MENU
	MOVB R7, [R2]     ; lê OK
	CMP R7, 1
	JNE Le_codigo    	 ; espera até OK = 1

	CMP R6, 0
	JEQ NenhumProdutoSel

	; Verifica se o codigo esta dentro do intervalo valido
	MOV R0, CODIGO_MIN
	CMP R6, R0
	JLT ERRO_Sel
	MOV R0, CODIGO_MAX
	CMP R6, R0
	JG ERRO_Sel

le_peso:
	; Verifica o peso
	MOVB R7, [R5]				; R7 = PESO
	MOV R0, PESO_MAX	
	CMP R7, R0	
	JG ERRO_Peso			;se o peso exceder 30kg
ProdutoPesado:
	
	JMP BalancaCiclo


NenhumProdutoSel:
	MOV R10, DisplayBalancaVazia	;mostra que nao foi selecionado nenhum produto
	CALL MostraDisplay
	MOVB R6, [R4]					; Le CANCEL
	CMP R6,1
	JEQ  Ligado
	MOVB R6, [R2]
	CMP R6, 1						; Le OK
	JNE NenhumProdutoSel			; espera ate OK = 1 para avancar
	JMP MostraProdutos	

ERRO_Sel:
	JMP MostraProdutos
	
ERRO_Peso:
	MOV R6, 0
	MOVB [R5], R6
	JMP le_peso

MostraProdutos:
	CALL LimpaPerifericos
	;instrucoes
	MOVB R6, [R2]					; le OK
	CMP R6, 1
	JNE MostraProdutos		; espera por OK=1 para avancar
	JMP BalancaCiclo


ORegistos:
	JMP Ligado
	
OLimpaRegistos:
	JMP Ligado
	
MostraErro:
	JMP Ligado
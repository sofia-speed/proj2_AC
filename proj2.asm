PRECO				EQU 	180H
PRODUTO			EQU		190H
; Perifericos
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
PESO_MAX		EQU		30000	;30kg = 30.000g

STACK_PRT			EQU			1000H

;preco dos produtos (em centimos!)
PLACE 4000H
BaseDados:
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
	String "Uvas            "
	String "Melancia        "
	String "Ananás          "
	String "Kiwi            "
	String "Pêssego         "
	String "Banana          "
	String "Morango         "
	String "Framboesa       "
	String "Laranja         "
	String "Tangerina       "
	String "Cenoura         "
	String "Batata          "
	String "Nabo            "
	String "Beterraba       "
	String "Alho            "
	String "Cebola          "
	String "Ervilha         "
	String "Lentilhas       "
	String "Trigo           "
	String "Milho           "
	String "Favas           "
	String "Castanhas       "
	String "Noz             "
	String "Amendoim        "
	String "Café            "
	
	
PLACE 4400H
CodigosProdutos:
	String "Uvas         100"
	String "Melancia     101"
	String "Ananás       102"
	String "Kiwi         103"
	String "Pêssego      104"
	String "Banana       105"
	String "Morango      106"
	String "Framboesa    107"
	String "Laranja      108"
	String "Tangerina    109"
	String "Cenoura      110"
	String "Batata       111"
	String "Nabo         112"
	String "Beterraba    113"
	String "Alho         114"
	String "Cebola       115"
	String "Ervilha      116"
	String "Lentilhas    117"
	String "Trigo        118"
	String "Milho        119"
	String "Favas        120"
	String "Castanhas    121"
	String "Noz          122"
	String "Amendoim     123"
	String "Café         124"

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
	String "              Kg"		; peso do produto
	String "PRECO:          "	
	String "          EUR/Kg"		; preco do produto por kg
	String "TOTAL:       EUR"	
			   
	
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
		MOVB R1, [R0]			; Le periferico ON_OFF
		CMP R1, 1				
		JNE Liga
Ligado:	
		MOV R10, MenuPrincipal
		CALL MostraDisplay
		CALL LimpaPerifericos
Le_nr:
		MOV R0, SEL_NR_MENU
		MOV R2, OK				; verifica que OK foi selecionado
		MOVB R3, [R2]
		
		CMP R3, 1				; nao avanca enquanto OK=0
		JNE Le_nr
		MOVB R1, [R0]	 		; Le o valor do periferico
		CMP R1, 1      
		JEQ OModoBalanca
		CMP R1, 2				; opcao registos
		JEQ ORegistos
		CMP R1, 3				; opcao limpar registos
		JEQ OLimpaRegistos
		CALL MostraErro
		JMP Ligado

			
;------------------
; Mostra Display
;------------------	
; R10 guarda a memoria dos displays	
MostraDisplay:
		PUSH R0					; 
		PUSH R1					; 
		PUSH R10      			; string
		PUSH R3      
		MOV R0, Display
		MOV R1, Display_end
CicloDisplay:  
		MOVB R3, [R10]        	; lê o caractere da string 
		MOVB [R0], R3        	; escreve o caractere no display 
		ADD R0, 1            	; incrementa apontador do display
		ADD R10, 1            	; incrementa apontador da string
		CMP R0, R1           	; verifica se já chegou ao fim do Display
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
		MOV [R0], R1
	
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
		MOVB [R0], R2        	; Escreve o caractere espaço no Display
		ADD R0, 1            	; Incrementa o apontador do Display
		CMP R0, R1          	; Verifica se chegou ao fim do Display
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
	MOVB R6, [R1]      			; lê SEL_NR_MENU

	CMP R6, 0					; se SEL_NR_MENU = 0, mostra que nenhum produto foi selecionado
	JEQ NenhumProdutoSel

	; Verifica se o codigo esta dentro do intervalo valido
	MOV R0, CODIGO_MIN
	CMP R6, R0
	JLT ERRO_Sel
	MOV R0, CODIGO_MAX
	CMP R6, R0
	JGT ERRO_Sel

le_peso:
	; Verifica o peso
	MOV R7, [R5]				; R7 = PESO
	MOV R0, PESO_MAX	
	CMP R7, R0	
	JGT ERRO_Peso				;se o peso exceder 30kg
ProdutoPesado:
	CALL ConverteSel 
	CALL AtualizaBalanca		; altera o display da balanca
	JMP BalancaCiclo


NenhumProdutoSel:
	MOV R10, DisplayBalancaVazia; mostra que nao foi selecionado nenhum produto
	CALL MostraDisplay
	MOVB R6, [R4]				; Le CANCEL
	CMP R6,1
	JEQ  Ligado
	MOVB R6, [R2]
	CMP R6, 1					; Le OK
	JNE NenhumProdutoSel		; espera ate OK = 1 para avancar
	JMP MostraProdutos	

ERRO_Sel:
	JMP MostraProdutos
	
ERRO_Peso:
	MOV R6, 0
	MOVB [R5], R6
	JMP le_peso

MostraProdutos:
		CALL LimpaPerifericos
		CALL MostraCodigosProdutos
	JMP BalancaCiclo


ORegistos:
	JMP Ligado
	
OLimpaRegistos:
	JMP Ligado
	
MostraErro:
	JMP Ligado
	
ConverteSel:
;converte o codigo selecionado na posicao de memoria do produto e preco
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6

	MOV R0, SEL_NR_MENU
	MOVB R1, [R0]		; R1 = SEL_NR_MENU
	MOV R2, 100
	SUB R1, R2		; R1 = R1-100   -> indice do produto
	MOV R3, R1		; R3 = indice do produto
	
	MOV R2, Tamanho_String
	MUL R1, R2		; R1 = R1 x 16
	MOV R2, NomesProdutos
	ADD R1, R2 		; R1 = R1+4200H   -> pos memoria do nome do produto
	MOV [PRODUTO], R1

	SHL R3, 1			; R3 = R3 x 2^1 bytes
	MOV R2, BaseDados
	ADD R3, R2	; R3 = R3 + 4000H -> pos memoria preco do produto
	MOV [PRECO], R3
	
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET
	
AtualizaBalanca:
; atualiza do displaybalanca, para depois ser mostrado no display
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R9
	; Copiar o nome do produto para a primeira linha do DisplayBalanca
	MOV R0, DisplayBalanca 	; R0 = início do DisplayBalanca
	MOV R1, [PRODUTO] 		; R1 = nome do produto
	MOV R3, Tamanho_String 	; R3 = tamanho da string (16)

CopiaNome:
	MOVB R2, [R1] 		; Lê um byte do nome do produto
	MOVB [R0], R2 		; Escreve byte no DisplayBalanca
	ADD R0, 1 			;  próxima posição no DisplayBalanca
	ADD R1, 1 			;  próximo byte do nome do produto
	SUB R3, 1 			; Decrementa o contador de caracteres
	JNE CopiaNome 		; Continua até copiar os 16 car.

CalcEnderecoPreco:
	MOV R4, DisplayBalanca 	; R4 =  início do DisplayBalanca
	MOV R5, Tamanho_String 	; R5 = tamanho da string (16)
	MOV R6, 5
	MUL R5, R6 				; Multiplica por 5 para chegar ao início da  linha do preco (5 linhas x 16 bytes/linha)
	ADD R4, R5 				; R4 = início da linha do preco

	; Ler o preço do produto
	MOV R1, [PRECO] 		; R1 = posicao do preço 
	MOV R2, [R1] 		; R2 = preço

PrecoParaDisplay:
	MOV R3, 6
	CALL ToStringVals
CalcEnderecoPeso:
	MOV R4, DisplayBalanca 	; R4 =  início do DisplayBalanca
	MOV R5, Tamanho_String 	; R5 = tamanho da string (16)
	MOV R6, 3
	MUL R5, R6 				; Multiplica por 3 para chegar ao início da  linha do peso (3 linhas x 16 bytes/linha)
	ADD R4, R5 				; R4 = início da linha do peso
	; Ler o peso
	MOV R1, PESO
	MOVB R5, [R1]
	CMP R5, 0
	JNE PesoParaDisplay
	CALL LimpaPerifericos

PesoParaDisplay:
	MOV R8, 1
	MOV R3, 2
	MOV R2, R5
	CALL ToStringVals

CalculaTotalUnit:
	; calcula o total do peso * preco para um produto
	; obter o inicio display em R4
	MOV R4, DisplayBalanca 	; R4 =  início do DisplayBalanca
	MOV R5, Tamanho_String 	; R5 = tamanho da string (16)
	MOV R6, 6
	MUL R5, R6 				; Multiplica por 6 para chegar ao início da  linha do peso (3 linhas x 16 bytes/linha)
	ADD R4, R5 				; R4 = início da linha do Total
	; preco * peso
	; peso
	MOV R1, PESO
	MOVB R2, [R1]			; 05h = 5dec != 500g x = PESO
	; preco
	MOV R1, [PRECO]
	MOV R3, [R1]			; D = Preco

MOV R1, 1          ; y = 1
MOV R0, 0          ; z = 0
MOV R9, 0          ; counter

MOV R1, 1          ; y = 1
MOV R0, 0          ; z = 0 (result)
MOV R9, 0          ; counter

CalcMultTot:
    MOV R6, R2
    MOV R5, 10
    MOD R6, R5      ; R6 = current digit

    MOV R7, R6
    MUL R7, R3      ; digit * price

    CMP R9, 2
    JGT SkipDiv

    ; only divide if it's the first or second digit
    DIV R7, R5      ; (digit * price) / 10

SkipDiv:
    MUL R7, R1      ; * y (1, 10, 100...)

    ADD R0, R7      ; accumulate to result (R0)

    CMP R9, 2
    JGT SkipYupdate
    MOV R1, 10      ; y = 10

SkipYupdate:
    DIV R2, R5      ; go to next digit
    ADD R9, 1       ; count digits processed

    CMP R2, 0
    JNE CalcMultTot

VerifyRounding:
	MOV R5, 10
	MOV R3, R0
	MOD R3, R5
	MOV R5, 5
	CMP R3, R5
	JLT TotalParaDislplay
	MOV R5, 10
	DIV R0, R5
	ADD R0, 1
	MUL R0, R5

; chamar ToStringVals
TotalParaDislplay:

	MOV R5, R0
	MOV R0, 150H	
	MOV [R0], R5

	MOV R3, 3
	MOV R2, R5
	CALL ToStringVals


	POP R9
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	;-----------------;
	;	Muda Display  ;
	;-----------------;
	MOV R10, DisplayBalanca
	CALL MostraDisplay
	RET

;---------------------------------------------------;
;  ToStringVals, R3-CharactersToSkip, R2-ValorToStringVals 	;
;  													;
;---------------------------------------------------;
ToStringVals:
	PUSH R0
	PUSH R5
	PUSH R6
	PUSH R7
	MOV R7, Tamanho_String
	ADD R3, 1		
	SUB R7, R3		; altera o fim da linha tendo em conta as unidades
	ADD R4, R7		; altera a posicao de escrita para o fim da linha
	SUB R7, 6		; reserva 6 char para o texto no menu
	MOV R0, 0 		; charFilled
	MOV R5, R2		; x para x/10
CalcResto:	
	MOV R6, R5		; x para x%10
	MOV R2, 10
	DIV R5, R2
	MOD R6, R2
	MOV R2, 48		; 48 ASCII = '0'
	ADD R6, R2		; +48 da o char do valor R6 en ASCII
	MOVB [R4], R6	; Escreve
	SUB R4, 1
	ADD R0, 1
	CMP R8, 1
	JNE DefaultA	; if R8!=1 continua normalmente
	MOV R2, 1
	CMP R0, R2
	JEQ PoeVirgula	; se preencheu 1 char poe a virgula
	CMP R8, 1
	JEQ CmpResto	; se R8==1 preencheu virgula apos 1char e preenche os restantes do valor
DefaultA:
	MOV R2, 2
	CMP R0, R2
	JEQ PoeVirgula	; se preencheu 2 char, poe uma virgula / ponto
CmpResto:
	CMP R5, 0
	JNE CalcResto
VerificaFim:
	CMP R0, R7
	JEQ ToStringValsFim
VerificaZero:
	CMP R0, 3
	JLT PreencheZero
	MOV R6, 48
	MOVB [R4], R6
	JMP ToStringValsFim
PreencheZero:
	MOV R6, 48		; '0' para R6
	MOVB [R4], R6	; escreve '0'
DefaultZero:
	SUB R4, 1		; indice-1
	ADD R0, 1		; charFilled+1
	MOV R2, 2
	CMP R0, R2
	JEQ Virgula
	JMP VerificaFim
Virgula:
	MOV R2, 44
	MOVB [R4], R2
	SUB R4, 1
	ADD R0, 1
	JMP VerificaFim
PoeVirgula:
	MOV R2, 44
	MOVB [R4], R2
	SUB R4, 1
	ADD R0, 1
	JMP CmpResto
ToStringValsFim:
	MOV R8, 0
	POP R7
	POP R6
	POP R5
	POP R0
	RET

;------------------------------------;
;     coloca os codigos do produto no display      ;
;------------------------------------;
MostraCodigosProdutos:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9

    MOV R0, 0              ; Página atual (começa em 0)
    MOV R1, 25             ; Total de produtos
    MOV R2, 7              ; Produtos por página
LoopCodigos:
    CALL LimpaDisplay
    MOV R3, R0             ; R3 = página atual
    MUL R3, R2             ; índice inicial = pagina * 7
    MOV R4, Tamanho_String
    MUL R3, R4             ; deslocamento = índice * 16
    MOV R5, CodigosProdutos
    ADD R5, R3             ; R5 aponta para o primeiro produto da página

    ; Escrever 7 produtos no display
    MOV R6, 0              ; contador de linhas (0 a 6)
    MOV R7, Display

CopiaPagina:
    CMP R6, R2
    JGE EsperaInteracao      ; Se já copiou 7 produtos, vai esperar interação

    MOV   R8, 400
    CMP   R3, R8
    JGE   EsperaInteracao    ; Se passou do último produto, também espera

    MOV R8, 0               ; contador de caracteres
    MOV R10, Tamanho_String 
CopiaProduto:
    CMP R8, R10
    JGE ProxProduto

    MOVB R9, [R5]
    MOVB [R7], R9

    ADD R5, 1
    ADD R7, 1
    ADD R8, 1

    JMP CopiaProduto


ProxProduto:
    ADD R6, 1
    JMP CopiaPagina

EsperaInteracao:
    CALL LimpaPerifericos

EsperaTecla:
    ; Verifica CHANGE
    MOV     R8, CHANGE
    MOVB    R9, [R8]
    CMP     R9, 1
    JEQ     AvancaPagina
    ; Verifica CANCEL
    MOV     R8, CANCEL
    MOVB    R9, [R8]
    CMP     R9, 1
    JEQ     VoltaPagina
    ; Verifica OK
    MOV     R8, OK
    MOVB    R9, [R8]
    CMP     R9,1
    JEQ      SairMostraCodigos
    JMP     EsperaTecla

AvancaPagina:
    ADD R0, 1
    ; se passou do máximo, volta para a página 0
    MUL R9, R2         ; R9 = R0 * 7
    CMP R9, R1
    JLT LoopCodigos
    MOV R0, 0
    JMP LoopCodigos

VoltaPagina:
    CMP R0, 0
    JLE LoopCodigos
    SUB R0, 1
    JMP LoopCodigos

SairMostraCodigos:
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET

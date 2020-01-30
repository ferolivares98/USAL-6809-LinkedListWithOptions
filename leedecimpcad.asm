.module leedecimpcad

	pantalla  .equ 0xFF00
	teclado   .equ 0xFF02

	numeroLeer: .word 0

	.globl leer_numero_decimal
	.globl imprime_cadena 

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  leer_numero_decimal                                                                  ;
;     lee un número decimal tecleado por el usuario (máximo 256) ya que lo devolveremos ;
;     en b (8bits).                                                                     ;
;                                                                                       ;
;     Entrada: ninguna                                                                  ;
;     Salida: B                                                                         ;
;     Registros afectados:ninguno                                                       ;
;                                                                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

leer_numero_decimal:

	;Primera cifra
	ldb  teclado
	subb #'0
	lda  #100
	mul 
	stb  numeroLeer
		
	;Segunda cifra
	ldb  teclado
	subb #'0
	lda  #10
	mul 
	addb numeroLeer
	stb  numeroLeer
			
	;Tercera cifra
	clra
	ldb  teclado
	subb #'0
	addb numeroLeer
	stb  numeroLeer
	
	rts
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  imprime_cadena                                                                       ;
;     saca por la pantalla la cadena acabada en '\0 apuntada por X.                     ;
;                                                                                       ;
;     Entrada: x-dirección de comienzo de la cadena.                                    ;
;     Salida: ninguna                                                                   ;
;     Registros afectados: X, CC.                                                       ;
;                                                                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

imprime_cadena:
	pshs x

sgte:
	lda  ,x+
	beq  ret_imprime_cadena
	sta  pantalla
	bra  sgte

ret_imprime_cadena:
	puls x
	rts
	


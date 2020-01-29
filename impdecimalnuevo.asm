.module impDecimal

	pantalla  .equ 0xFF00

	contador:    .word 0
	numReducido: .word 0
	
	.globl impDecimal


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  impDecimal                                                                           ;
;     Lee d y escribe el número en decimal (5 cifras).                                  ;
;                                                                                       ;
;                                                                                       ;
;     Entrada: d                                                                        ;
;     Salida: d                                                                         ;
;     Registros afectados:ninguno                                                       ;
;                                                                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


impDecimal:
	pshs d

	std  numReducido
	ldb  #0
	stb  contador

	;En primer lugar, preparamos las variables que vamos a utilizar a lo
	;largo del programa.
	
Menor10000:
	ldd  numReducido

	cmpd #10000
	blo  imprimir5

	subd #10000
	std  numReducido
	ldb  contador
	incb
	stb  contador

	bra  Menor10000

imprimir5:
	ldb  contador
	addb #'0
	stb  pantalla
	
	ldb  #0
	stb  contador

	;------------------------------;

Menor1000:
	ldd  numReducido

	cmpd #1000
	blo  imprimir4
	
	subd #1000
	std  numReducido
	ldb  contador
	incb
	stb  contador

	bra  Menor1000

imprimir4:
	ldb  contador
	addb #'0
	stb  pantalla
	
	ldb  #0
	stb  contador

	;------------------------------;

Menor100:
	ldd  numReducido
	
	cmpd #100
	blo  imprimir3

	subd #100
	std  numReducido
	ldb  contador
	incb
	stb  contador

	bra Menor100

imprimir3:
	ldb  contador
	addb #'0
	stb  pantalla
	
	ldb  #0
	stb  contador

	;------------------------------;

Menor10:
	ldd  numReducido
	
	cmpd #10
	blo  imprimir2

	subd #10
	std  numReducido
	ldb  contador
	incb
	stb  contador

	bra  Menor10

imprimir2:
	ldb  contador
	addb #'0
	stb  pantalla

	ldb  #0
	stb  contador

	;------------------------------;

Menor1:
	ldd  numReducido
	
	cmpd #1
	blo  imprimir1

	subd #1
	std  numReducido
	ldb  contador
	incb
	stb  contador

	bra  Menor1

imprimir1:
	ldb  contador
	addb #'0
	stb  pantalla

	;INTERCAMBIABLE IMPRIMIR HORIZONTAL Y VERTICAL.
	;IMPRIMIR VERTICAL (marcar dos sta pantalla con ;). Mejor para ver contadores y 'x'.
	;lda  #'\n
	;IMPRIMIR HORIZONTAL (no marcar sta pantalla).
	lda  #' 
	sta  pantalla
	sta  pantalla
	sta  pantalla
	clra
	clrb

	puls d
	rts
	
	

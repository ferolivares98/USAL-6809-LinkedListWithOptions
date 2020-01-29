.module programa

          
	
fin       .equ 0xFF01
pantalla  .equ 0xFF00
teclado   .equ 0xFF02

  
numeroInicial: .byte 0     
contador:      .byte 0
numero:	       .word 0
numeroNodo:    .byte 0
semilla:       .word 0
anterior:      .word 0x400
guardarX:      .word 0x410
aux:	       .word 0x420

        .globl programa
        .globl rand
        .globl srand
	.globl impDecimal
	.globl leer_numero_decimal
	.globl imprime_cadena

cadena1:.asciz "El programa recibira un numero entre 1 y 256 y devolvera por pantalla una"
cadena2:.asciz "cantidad igual a este de numeros aleatorios ordenados de menor a mayor."
cadena3:.asciz "Introduce la cantidad de numeros de tu lista: "
cadena4:.asciz "Numeros de mayor a menor: " 
cadena5:.asciz "Introduzca el numero del nodo a eliminar: "
cadena6:.asciz "Introduzca 0 para repetir la ejecucion del programa al completo: "

programa:
       	ldu  #0x8000 ;Usaremos la pila U. Le damos un valor seguro
	lds  #0xFF00 ;La pila S reservada para las subrutinas.

        ;Introducción al ejercicio.
       	ldx  #cadena1
        jsr  imprime_cadena
	ldx  #cadena2
	jsr  imprime_cadena

	ldb  #'\n
	stb  pantalla
	ldx  #cadena3
	jsr  imprime_cadena


	;A continuación leemos el número decimal entre 1 y 256. Durante el ejercicio 
	;descubrimos bastantes problemas relacionados con las subrutinas de otros ficheros.
	;En muchas llamadas conflictivas, procuramos limpiar a y b para evitar
	;errores.
	clra
	clrb
        jsr  leer_numero_decimal

	;leer_numero devulve b que será contador. EL valor se queda guardado en numeroInicial.
	clra
	stb  contador	
	stb  numeroInicial

	;Ahora generamos los números aleatorios y utilizamos el contador para parar.
      	;Los números aleatorios se generarán a partir de una semilla llamando a srand
	;y a continuación sucesivas llamadas a rand para cada número.
	ldb  numeroInicial
	jsr  srand		;Generamos la semilla.
	std  semilla

;--------------------------------------------------------------------------------------------;

	;Como el primer y el segundo número son distintos, el código es distinto y se realiza
	;antes del bucle.
	ldb  #'\n
	stb  pantalla
	clra

	;Hacemos la comprobación del contador. Este no haría nada si el número introducido
	;fuera 0.
	ldb  contador
	;clra
	;jsr  impDecimal	;Imprimir contador.
	cmpb #0
	lbeq impOrden
	decb
	stb  contador

	;En primer lugar, introducimos en la pila la dirección nula.
	ldd  #0
	pshu d

	ldd  semilla
	jsr  rand		;Generaremos así los números a partir de la semilla.
	std  numero		;Utilizaremos esta variable (equivalente nuevo) para comparar.
	;Ahora tenemos en d el número generado por rand y preparamos los punteros.
	ldd  numero
        pshu  d
	ldd  ,u
	jsr  impDecimal
	leax ,u
	leay ,x

	;Comenzamos con la segunda cifra:
	ldb  contador
	;clra
	;jsr  impDecimal	;Imprimir contador.
	cmpb #0
	lbeq impOrden
	decb
	stb  contador

	ldd  #0
	pshu d
	
	ldd  semilla
	jsr  rand
	std  numero
	jsr  impDecimal
	ldd  numero
	pshu d
	;En este instante, x e y están apuntando a la primera cifra y u a la nueva.
	ldd  ,x
	cmpd numero
	lblo nuevoMayor

	;Si el original es menor, se salta a nuevoMayor.
	;Si el original es mayor, se salta a ultimoMenor ('y' está colocada con 'x').
	;Esta segunda cifra se realiza aparte para ahorrar la comprobación innecesaria
	;de medioMayor y así evitar posibles errores.
	lbra ultimoMenor
	

	;Ahora comenzamos con el bucle principal para el resto del ejercicio.

generador:
	;Hacemos la comprobación del contador. Este no haría nada si el número introducido
	;fuera 0. Esta comprobación se hará en todas las iteracciones.
	ldb  contador
	;clra
	;jsr  impDecimal	;Imprimir contador.
	cmpb #0
	lbeq impOrden
	decb
	stb  contador

	ldd  #0
	pshu d
	;Ahora realizamos el mismo proceso que anteriormente, teniendo en cuenta que debemos 
	;usar el puntero "anterior" para no perdernos al recorrer la lista.
	ldd  semilla
	jsr  rand
	std  numero
	;Ahora tenemos en d el número generado por rand guardado en número.
	ldd  numero
	jsr  impDecimal
        pshu d


	;En este instante, u está apuntando a la nueva cifra. x está con el comienzo de la
	;lista y trabajaremos con 'y' y 'anterior'.
	;ldd  ,x
	;jsr  impDecimal	;Para tener claro el valor de x en cada interacción.
	;ldd  numero

	leay ,x			;Cargamos 'y' con 'x'.
	ldd  ,x			;Cargamos en d el valor de 'x' (lista).
	cmpd numero		;Comprobamos si el nuevo es la nueva cabeza.
	lblo nuevoMayor		;Comparamos.


buscaMenor:
	leay 2,y		;Cargamos 'y' dos direcciones más abajo donde está el sig.
	sty  anterior		;No entramos para poder guardarla en anterior.
	leay [,y]		;'y'viaja hasta el número.
	ldd  ,y			;Recogemos el valor en d.
	cmpd numero
	blo  medioMayor
	
	;Ahora comprobamos si hemos llegado al último.
	leay 2,y		;Avanzamos 2 en 'y'.
	ldd  ,y			;Cargamos en d la dirección->sig en la que estamos.
	cmpd #0			;Comparamos con dirección 0000.
	lbeq ultimoMenor	;Si es igual estamos en el último.
	leay -2,y		;Volvemos al sitio de 'y' porque no es el último.

	lbra buscaMenor

	;Nuevo mayor será usado tanto por la segunda cifra como por el resto ya que
	;no utiliza la variable puntero 'anterior'.
nuevoMayor:
	leax ,u			;Carga en x la dirección de U.
	sty  2,x		;Guarda 'y' (vieja cabeza) en el nuevo x->sig.
	lbra generador		;Saltamos.

medioMayor:
	sty  2,u		;Guardamos 'y' en la nueva dirección->sig
	clra
	clrb
	ldy  anterior		;Cargamos en 'y' anterior.
	stu  ,y			;Guardamos la pila U en 'y'.
	lbra generador

ultimoMenor: 
	stu  ,y			;Guardamos la dirección de nuevo donde está 'y'.
	lbra generador
	

;-------------------------------------------------------------------------------------------;
;-------------------------------------------------------------------------------------------;
	;IMPORTANTE:
	;
	;Ahora imprimimos en orden recorriendo la lista. Nos vemos obligados a guardar x
	;en una variable extra debido a un error con las subrutinas. Esto nos permite
	;imprimir "libremente" y tener siempre la cabeza de la lista segura.
	;
	;
	;
	;Un detalle importante sobre bucleImprimir. Si queremos mostrar el valor del contador,
	;este será 00xxx (numeroInicial) para la primera cifra (la mayor) aunque esta sea la
	;cabeza de la lista. 
	;
	;Lo que esto quiere decir es que la visualización del contador no debe valer
	;como referencia a la hora de eliminar los nodos. Si se desea eliminar el primer
	;nodo (cabeza), el valor correcto será 001. La posibilidad de visualizar el contador
	;es una simple ayuda, y no debe ser tenida en cuenta para la eliminación de nodos.
impOrden:
	clra
	ldb  numeroInicial
	stb  contador

	ldb  #'\n
	stb  pantalla
	stx  guardarX
	ldx  #cadena4
	jsr  imprime_cadena
	ldx  guardarX
	ldb  #'\n
	stb  pantalla

	leay ,x

bucleImprimir:
	ldb  contador
	;clra
	;jsr  impDecimal	;Imprimir contador.
	cmpb #0
	lbeq eliminarNodo
	decb
	stb  contador
	
	ldd  ,y
	jsr  impDecimal
	leay 2,y
	leay [,y]

	lbra bucleImprimir
	

;-------------------------------------------------------------------------------------------:
	;A continuación, se pedirá al usuario que escoja un nodo para que este sea 
	;eliminado. Utilizaremos una variable extra denominada anterior que la necesitaremos
	;una vez eliminemos uno de los nodos. Como estamos en ensamblador, no se incluye
	;las posibilidades que sucederían bajo errores del usuario. 
	;
	;Por tanto, como se supone que el número de nodo introducido estará dentro del
	;número de nodos original, para simplificar se hará una comprobación directa
	;con el número original (para eliminar el último). Si originalmente había 5 nodos,
	;se comparará con 5 en lugar de comparar direcciones 0x0000 como hicimos para
	;crear la lista. Esto nos ahorrará una buena cantidad de iteracciones dependiendo
	;si el número es bastante grande.
	;
	;
	;IMPORTANTE:
	;Para facilitar el código, se da por hecho que se identifica el primer nodo
	;(cabeza) como lista[1] en lugar de comenzar por 0. Es mucho más intuitivo
	;para el usuario y para eliminar los nodos.

eliminarNodo:
	ldb  #'\n
	stb  pantalla
	stx  guardarX
	ldx  #cadena5
	jsr  imprime_cadena
	ldx  guardarX

	clra
	clrb
	jsr  leer_numero_decimal
	clra
	stb  numeroNodo
	ldb  #1
	stb  contador		
	
	ldb  #'\n
	stb  pantalla

	
	;Colocamos 'y' y comenzamos.
	leay ,x
	ldb  numeroNodo
	cmpb #1
	lbeq eliminarPrimero	;Si es el primero saltamos directamente.

	ldb  numeroNodo
	cmpb numeroInicial
	lbeq eliminarFinal	;Si es el último saltamos directamente.
	
bucleEliminarNodo:
	ldb  contador
	incb
	stb  contador

	leay 2,y
	sty  anterior
	leay [,y]
	
	ldb  contador
	cmpb numeroNodo
	lbeq eliminarMedio

	bra  bucleEliminarNodo


eliminarPrimero:
	leay 2,y		;Avanzamos con 'y'.
	leay [,y]		;"Viajamos".
	leax  ,y		;Nueva cabeza de lista.
	bra  imprimirFinal

	;Para eliminarMedio utilizamos momentánemente 'x'. Se supone que sty anterior podría
	;funcionar (pero habrá algo que se nos escapa), así que nos aseguramos utilizando 'x'
	;(el típico intercambio de C con una auxiliar).
eliminarMedio:
	leay 2,y		;Avanzamos con 'y'.
	leay [,y]		;"Viajamos" a la dirección.
	;sty anterior
	stx  guardarX		;Guardamos la cabeza de la lista.
	leax ,y			;Guardamos en 'x' el valor de 'y'.
	ldy  anterior		;Cargamos en 'y' el valor de anterior
	stx  ,y			;Guardamos el valor de 'x' en 'y'.

	ldx  guardarX		;Recuperamos 'x'.
	bra  imprimirFinal

eliminarFinal:
	ldy  anterior		;Vamos al anterior.
	ldy  #0			;Dirección a 0. Perdemos el último.
	bra  imprimirFinal
	
	


	;A pesar de que este bucle es igual al realizado anteriormente, hemos tomado la 
	;decisión de separarlos. Como hemos utilizado un contador para recorrer la lista,
	;nos es más sencillo utilizar este contador para acabar los distintos bucles que
	;presentan resultados por pantalla.
imprimirFinal:
	ldb  numeroInicial	;Cargamos de nuevo el número inicial.
	decb			;Restamos 1 (hemos eliminado un nodo).
	stb  contador		;Guardamos en contador y procedemos a imprimir.

	leay ,x

bucleImprimirFinal:	
	ldb  contador
	;clra
	;jsr  impDecimal	;Imprimir contador.
	cmpb #0
	lbeq otraEjecucion
	decb
	stb  contador
	
	ldd  ,y
	jsr  impDecimal
	leay 2,y
	leay [,y]

	lbra bucleImprimirFinal


	;Por último, se permite realizar otra ejecución del programa al completo. También
	;sería posible añadir una opción para seguir eliminando nodos, en cuyo caso 
	;deberíamos salvar el valor de 'x' (cabeza de la lista), cosa que no hacemos en
	;el siguiente apartado del código (porque no lo pide el enunciado del ejercicio)
	;pero que se podría incluir.
	;
	;Si se quiere añadir esta opción, imprimirFinal debería ser modificado para ir
	;guardando el nuevo tamaño de la lista.
otraEjecucion:
	ldb  #'\n
	stb  pantalla
	ldx  #cadena6
	jsr  imprime_cadena

	clra
	clrb
	jsr  leer_numero_decimal
	lda  #'\n
	sta  pantalla
	sta  pantalla
	cmpb #0
	lbeq programa

acabar: 
	lda  #'\n
	sta  pantalla	
	clra
        sta  fin


	.area FIJA(ABS)
	.org 0xFFFE     ; vector de RESET
        .word programa



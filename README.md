# Assembly-LinkedListWithOptions
Práctica final de Computadores II en la Universidad de Salamanca.
Nota: **10**


## Instalación
* Será necesario que todos los archivos se encuentren en una misma carpeta.
* La base del trabajo y el archivo rand.rel parten de los [apuntes](http://avellano.usal.es/~compii/) de Computadores II. En la [primera sesión](http://avellano.usal.es/~compii/sesion1.htm) se encuentra el link de descarga del instalador del 6809 con instrucciones precisas para configurar el entorno de trabajo y pruebas.


# Uso
1. **Ensamblamos.**
    * as6809 -o ejFinal.asm
    * as6809 -o impdecimalnuevo.asm
    * as6809 -o leedecimpcad.asm
  
2. **Enlazamos.**
    * aslink -s -m -w ejFinal.s19 ejFinal.rel rand.rel impdecimalnuevo.rel leedecimpcad.rel
  
3. **Ejecutamos.**
    * m6809-run ejFinal.s19

# Características
* El programa generará una lista enlazada en ensamblador con una medida concreta (con un máximo de 256) y permitirá la eliminación de alguno de los nodos.
* Para mostrar los números en vertical, se cambia el impdecimalnuevo.asm. Esto facilita ver el contador y el valor de x en el bucle. Se pueden retirar los comentarios de ejFinal.asm para comprender mejor el ejercicio.


## Feedback
Ante bugs o comportamientos extraños por parte del programa, crear un ticket en Issues.

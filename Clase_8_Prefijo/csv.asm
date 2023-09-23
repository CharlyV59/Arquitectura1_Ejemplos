;Macros que se pueden llamar
include macros1.asm 
.model Large 
; -------------- SEGMENTO DE PILA -----------------
.stack 
; -------------- Variables a utilizar -----------------
.data 
;Donde se guarda las operaciones
operaciones db 100 dup(' '), '$'

;Donde se guarda las operaciones
resultadoOperacion db 10 dup('~'), '$'
primerNumero db 1, '$' 
segundoNumero db 1, '$' 
operadorOperacion db 1, '$' 
banderaPila db 1, '$'
numeroActual db 1, '$'

;Indice de las operaciones
indiceOperaciones db 0

;Indice por operacion
indiceOperacion db 1 , '$'

;Salto de linea
skip db 0ah,0dh, ' ' , '$'

;Donde se almacena el simbolo
simbolo db 5 dup('$'), '$'
;Identificador dos caracteres
dosCaracarcteres db 10 dup('$'), '$'
;Identificador
identificadorOP db 30 dup('$'), '$'
;Boleano
bool db 5 dup('$'), '$'
bool2 db 5 dup('$'), '$'

;Convertida
conver db 100 dup('$') , '$'

;Variables para los numeros
numero1 db 100 dup('$') , '$'
number1 db 100 dup('$') , '$'
number2 db 100 dup('$') , '$'
numero2 db 100 dup(' ') , '$'
num1 db 100 dup('$'), '$'
num2 db 100 dup('$'), '$'
resul db 0
resul2 db 0
num3 db 100 dup('$'), '$'
num4 db 100 dup('$'), '$'
test1  db 0
test2  db 0
resultado2 db 100 dup('$') , '$'

;Maneja la entrada del teclado
handlerentrada dw ?

;Simbolos
mas db 0ah,0dh, '+' , '$'
menos db 0ah,0dh, '-' , '$'
multi db 0ah,0dh, '*' , '$'
divi db 0ah,0dh, '/' , '$'
signo db 5 dup('$'), '$'
signo2 db 5 dup('$'), '$'
signo3 db 5 dup('$'), '$'




;Menu principal de la aplicacion
;Cadenas del menu principal
;Seleccion de opciones
rotulo  db 0ah,0dh, "              MENU PRINCIPAL" , '$'
marco   db 0ah,0dh, "         *_   _   _   _   _   _ *" , '$'
marco1  db 0ah,0dh, " ^       | `_' `-' `_' `-' `_' `|       ^" , '$'
marco2  db 0ah,0dh, " |       | 1. SUMA              |       |" , '$'
marco3  db 0ah,0dh, " |       | 2. RESTA             |       |" , '$'
marco4  db 0ah,0dh, " |       | 3. Generar Reporte   |       |" , '$'
marco5  db 0ah,0dh, " |  (*)  | 4. Cargar Operacion  |  \^/  |" , '$'
marco6  db 0ah,0dh, " |_<''>_ | 5. Salir             | _(#)_ |" , '$'
marco7  db 0ah,0dh, "o+o \ / \0                      0/ \ / (=)" , '$'
marco8  db 0ah,0dh, " 0'\ ^ /\/_   _   _   _   _   _ \/\ ^ /`0*" , '$'
marco9  db 0ah,0dh, "   /_^_\ | `_' `-' `_' `-' `_' `| /_^_\" , '$'
marco10  db 0ah,0dh, "   || || |                      | || ||" , '$'
marco11 db 0ah,0dh, "   d|_|b_T______________________T_d|_|b" , '$'


;Mensaje numero 1
ingrese1 db 0ah,0dh, 'Ingrese el primer numero: ' , '$'
;Mensaje numero 2
ingrese2 db 0ah,0dh, 'Ingrese el segundo numero: ' , '$'
;Mensaje operando
operando db 0ah,0dh, 'Ingrese el operando: ' , '$'
;Mensaje resultado
msjResultado db 0ah,0dh, 'El resultado es: ' , '$'



;Mensaje error de simbolo
errorSimbolo db 0ah,0dh, 'El simbolo no es correcto intente de nuevo.' , '$'

;Salto de linea
saltolinea db 10,'$'


;----------------Variables para escribir en un archivo----------------
;Nombre del archivo
nombreArchivo db 'reporte.html',0

;Cadena que almacenada todo el reporte esta llena de espacios vacios
reporte db 30000 dup(' '), '$'

;Maneja como la interrupcion del buffer que utilizaremos para escribir
;Datos del archivo
file db 'c:\repo.html','00h' ;ojo con el 00h es importante
handler dw ?
buffer db 100 dup(' '), '$' ;<-------------------Modifique el tamaño del buffer segun el tamaño de sus archivo

;Modifique la ruta segun como lo tengan ustedes <--------------------------
rute db 'c:/masm611/bin/HELP.TXT' ,'00h'

;Variables para el control de donde escribir en el reporte
indiceReporte db 0
indice_reporte db 100
indiceOP db 100 dup('$') , '$'
contadorIndiceOP db 0

;Cadena para escribir en un archivo HTML (Solo tienen que copiar linea por linea su html casi)
linea1 db  '<html>$' , 0
linea2 db  '<head>$' , 0
linea3 db  '<title>Reporte Operaciones</title> ' , '$'
linea4 db 0ah,0dh, '<style>  ' , '$'
linea5 db 0ah,0dh, 'body{background-color: #e6e6ff;} ' , '$'
linea6 db 0ah,0dh, '</style> ' , '$'
linea7 db 0ah,0dh, '</head> ' , '$'
linea8 db 0ah,0dh, '<body>' , '$'
linea9 db 0ah,0dh, '<H1> Hola mundo </H1>' , '$'
linea10 db 0ah,0dh, '</body>' , '$'
linea11 db 0ah,0dh, '<html>' , '$'

;---------------Variables para carteles de error----------------
err1 db 0ah,0dh, 'Error al abrir el archivo puede que no exista' , '$'
err2 db 0ah,0dh, 'Error al cerrar el archivo' , '$'
err3 db 0ah,0dh, 'Error al escribir en el archivo' , '$'
err4 db 0ah,0dh, 'Error al crear en el archivo' , '$'
err5 db 0ah,0dh, 'Error al leer en el archivo' , '$'

;----------------SEGMENTO DE CODIGO---------------------

.code

main proc far	
mov ax,@data
mov ds,ax
mov es,ax

    begin:
        ;Aqui podemos colocar codigo de inicio de nuestro programa  
        ;Cargamos el indice si al la pila para ir concatenando la cadena del html
        mov si,0
        push si

        ;Carga inicial de el archivo html
        

        ;Como ya cargamos lo necesario ya continua hacia nuestro programa
        jmp menu


    menu:
    	;print operarReporte 

        print rotulo
		print marco;
        print marco1;
        print marco2;
        print marco3;
        print marco4;
        print marco5;
        print marco6;
        print marco7;
        print marco8;
        print marco9;
        print marco10;
        print marco11;
        print skip
		getChar

        cmp al,49 ;mnemonio 31h = 1 en hexadecimal, ascii 49
		je sumarOperacion
		cmp al,50 ;mnemonio 32h = 2 en hexadecimal, ascii 50
		je restar
		cmp al,51 ;mnemonio 33h = 3 en hexadecimal, ascii 51
		je generar
        cmp al,52 ;mnemonio 34h = 4 en hexadecimal, ascii 52
		je entrada
		cmp al,53 ;mnemonio 35h = 5 en hexadecimal, ascii 53
		je salir
        jmp menu

    ;Ejemplo que pasa si pongo la etiqueta sumar <--
    sumarOperacion:
        print saltolinea
		print ingrese1
	    ObtenerTexto numero1
		print operando
        ObtenerTexto simbolo
	    print ingrese2
	    ObtenerTexto numero2

        ;Empezamos a leer cual tipo de operacion es 
        mov al,simbolo
		cmp al,43 ;sumar ASCII
		je sum

        
        ;Si no es una suma que vuelva a ingresar los datos
        print errorSimbolo
        jmp sumarOperacion

        

    sum:
        ;Ejecutamos una suma
        extractorCompleto numero1,num1,num2,test1,signo
		conversor num1,resul,num2
		extractorCompleto numero2,num3,num4,test2,signo2
        conversor num3,resul2,num4

		sumar resul,resul2,resultado2,test1,test2,signo3
        
        ;Como esta bien continua
        print saltolinea
        print msjResultado
		print signo3
		imprimirDecimal resultado2,conver
		print saltolinea
        

        ;clear
        jmp menu
    
    restar:
        print saltolinea
		print ingrese1
	    ObtenerTexto numero1
		print operando
        ObtenerTexto simbolo
	    print ingrese2
	    ObtenerTexto numero2

        ;Empezamos a leer cual tipo de operacion es 
        mov al,simbolo
		cmp al,45 ;restar ASCII
		je res

        
        ;Si no es una suma que vuelva a ingresar los datos
        print errorSimbolo
        jmp restar

        

    res:
        ;Ejecutamos una resta
        extractorCompleto numero1,num1,num2,test1,signo
		conversor num1,resul,num2
		extractorCompleto numero2,num3,num4,test2,signo2
        conversor num3,resul2,num4

		sumar resul,resul2,resultado2,test1,test2,signo3
        
        ;Como esta bien continua
        print saltolinea
        print msjResultado
		print signo3
		imprimirDecimal resultado2,conver
		print saltolinea
        

        ;clear
        jmp menu

    generar:
        

        ;Concatenamos las cadenas que queremos a la del reporte
        concatenarCadena linea1,reporte,indiceReporte
        concatenarCadena linea2,reporte,indiceReporte
        concatenarCadena linea3,reporte,indiceReporte
        concatenarCadena linea4,reporte,indiceReporte
        concatenarCadena linea5,reporte,indiceReporte
        concatenarCadena linea6,reporte,indiceReporte
        concatenarCadena linea7,reporte,indiceReporte
        concatenarCadena linea8,reporte,indiceReporte
        concatenarCadena linea9,reporte,indiceReporte
        concatenarCadena operaciones,reporte,indiceReporte
        concatenarCadena linea10,reporte,indiceReporte
        concatenarCadena linea11,reporte,indiceReporte

        ;Limpiamos variables que utilizamos para escribir
        limpiar rute, SIZEOF rute,24h ;limpiamos el arreglo bufferentrada con $
		limpiar buffer, SIZEOF buffer,24h ;limpiamos el arreglo bufferentrada con $

        ;ObtenerTexto nombreArchivo (Por alguna razon aveces no se obtiene bien el nombre del archivo
        ;Y lo pueden ingresar manual en caso de cualquier error)
        mov nombreArchivo[0],114 ;R
		mov nombreArchivo[1],101 ;E
		mov nombreArchivo[2],112 ;P
		mov nombreArchivo[3],46  ;.
		mov nombreArchivo[4],104 ;h
		mov nombreArchivo[5],116 ;t
		mov nombreArchivo[6],109 ;m
        mov nombreArchivo[7],108 ;l

        ;Interrupcion para crear el archivo
		crear nombreArchivo, handler
        ;Interrupcion para escribir el archivo
        escribir handler, reporte, SIZEOF reporte
        ;Interrupcion para cerrar como que el buffer que se utilizo para escribir
		cerrar handler

        jmp menu

    entrada:
        abrir rute,handlerentrada  ;le mandamos la ruta y el handler,que será la referencia al fichero 
		limpiar buffer, SIZEOF buffer,24h  ;limpiamos la variable donde guardaremos los datos del archivo 
		leer handlerentrada, buffer, SIZEOF buffer ;leemos el archivo
        cerrar handlerentrada
        
        jmp analizar
    
    analizar:
        print saltolinea 
        print buffer
        print saltolinea 

        ;jmp menu

        ;Limpieza de los registros
        xor di,di
        xor cx,cx

        jmp encontrarOperacion
    
    encontrarOperacion:
        mov al,buffer[di]
        cmp al,59 ;simbolo comillas ASCII
		je encontrada

        ;(Tener cuidado ya que si no hay condicion de salida se encicla)
        ;Salida de emergencia mas de 200 de llegada del indice, pueden poner un mayor
        cmp di,200
        je emergencia


        ;Incrementamos el indice
        inc di
        ;Si no es el que buscamos volvemos a buscar 
        jmp encontrarOperacion

    
    encontrada: 
        ;Guardamos el maximo indice de la operacion
        mov ax, di
        ;Tener en cuenta que como maximo el indice en una posicion es 256
        mov indiceOperacion[0],al
        
        ;Probamos que haya encontrado el indice.
        print indiceOperacion

        ;jmp menu

        ;Ahora empezamos a recorrerla de derecha a izquierda
        jmp iniciar

    iniciar:
        ;Empezamos a leer
        mov al, indiceOperacion[0]
        SUB al, 1 ;Le entraemos uno por que necesitamos ubicarnos en el primer numero

        ;Actualizamos el valor del indice
        mov indiceOperacion[0], al
        
        jmp recorrer
    
    recorrer: 
        ;Limpiamos
        xor ax, ax
        xor di, di
        xor bx, bx
        mov al, indiceOperacion[0]
        ;Movemos al registro indice
        mov di, ax
        mov bl, buffer[di]

        ;Guardamos el numero 1
        SUB bl, 48 ;Convertimos a numero decimal
        mov primerNumero[0],bl

        ;Actualizamos el valor del indice
        xor ax, ax
        mov al, indiceOperacion[0]
        SUB al, 1 ;Le entraemos uno por que necesitamos ubicarnos en el siguiente operando
        mov indiceOperacion[0],al

        ;Limpiamos
        xor ax, ax
        xor di, di
        xor bx, bx
        mov al, indiceOperacion[0]
        ;Movemos al registro indice
        mov di, ax
        mov bl, buffer[di]

        ;Guardamos el numero 2
        SUB bl, 48 ;Convertimos a numero decimal
        mov segundoNumero[0],bl

        ;Actualizamos el valor del indice
        xor ax, ax
        mov al, indiceOperacion[0]
        SUB al, 1 ;Le entraemos uno por que necesitamos ubicarnos en el siguiente operando
        mov indiceOperacion[0],al

        ;Limpiamos
        xor ax, ax
        xor di, di
        xor bx, bx
        mov al, indiceOperacion[0]
        ;Movemos al registro indice
        mov di, ax
        mov bl, buffer[di]

        ;Guardamos el operador
        mov operadorOperacion[0],bl

        xor ax,ax
        mov al,operadorOperacion[0]
		cmp al,43 ;sumar ASCII
		je sumarArchivo
        cmp al,42 ;multiplicar ASCII
		je multiplicarArchivo

        ;Si llego hasta aqui es es un numero y hay que hacer ajustes.
        ;Primero guardamos en pila el numero 1
        xor ax,ax
        mov al, primerNumero[0]
        push ax
        mov banderaPila[0],1 ;Ponemos una bandera para saber que tenemos algo en pila

        ;Verificamos los valores actuales
        ;print primerNumero
        ;print segundoNumero

        ;jmp menu
        
        ;Cambiamos el numero2 al numero 1
        xor ax, ax
        mov al, segundoNumero[0]
        mov primerNumero[0],al
        mov segundoNumero[0],36

        ;Verificamos los valores modificados
        ;print primerNumero
        ;print segundoNumero
        
        ;jmp menu

        jmp casoEspecial

    casoEspecial:
        ;Como es un caso especial seguimos analizando la cadena desde el numero2
        ;Limpiamos
        xor ax, ax
        xor di, di
        xor bx, bx
        mov al, indiceOperacion[0]
        ;Movemos al registro indice
        mov di, ax
        mov bl, buffer[di]

        ;verificamos el indice actual y el valor actual
        ;xor ax,ax
        ;mov al, buffer[di]
        ;mov numeroActual[0],al
        ;print skip
        ;print indiceOperacion
        ;print skip
        ;print numeroActual

        

        ;Guardamos el numero 2
        SUB bl, 48 ;Convertimos a numero decimal
        mov segundoNumero[0],bl

        ;Verificamos el primero y el segundo numero
        ;print skip
        ;print primerNumero
        ;print segundoNumero

        ;Actualizamos el valor del indice
        xor ax, ax
        mov al, indiceOperacion[0]
        SUB al, 1 ;Le entraemos uno por que necesitamos ubicarnos en el siguiente operando
        mov indiceOperacion[0],al

        ;Limpiamos
        xor ax, ax
        xor di, di
        xor bx, bx
        mov al, indiceOperacion[0]
        ;Movemos al registro indice
        mov di, ax
        mov bl, buffer[di]

        ;Guardamos el operador
        mov operadorOperacion[0],bl

        ;Verificamos el primero, el segundo numero y el operador
        ;print skip
        ;print primerNumero
        ;print segundoNumero
        ;print operadorOperacion
        
        ;jmp menu

        ;Actualizamos el valor del indice
        xor ax, ax
        mov al, indiceOperacion[0]
        SUB al, 1 ;Le entraemos uno por que necesitamos ubicarnos en el siguiente operando
        mov indiceOperacion[0],al

        ;Verificamos que tipo de operacion es
        xor ax,ax
        mov al,operadorOperacion[0]
		cmp al,43 ;sumar ASCII
		je sumarArchivo
        cmp al,42 ;multiplicar ASCII
		je multiplicarArchivo

        jmp menu


    sumarArchivo:
        ;print skip
        ;print primerNumero
        ;print skip
        ;print segundoNumero
        ;print skip

        ;Como es una multiplicacion ejecutamos la operacion
        xor ax, ax

        mov al,primerNumero[0] ;Numero1 hacia al
        mov bl,segundoNumero[0]  ;Numero2 hacia bl
        ADD al, bl

        ;Guardamos el resultado
        mov resultadoOperacion[0], al


        print skip
        print resultadoOperacion
        print skip

        ;jmp menu

        xor ax,ax
        mov al, banderaPila[0] ;Verificamos que tenemos algo en pila
        cmp al, 1
        je algoPila
        
        jmp menu

    algoPila:
        ;Guardamos el resultado en la operacion anterior
        xor ax,ax
        xor bx,bx
        xor di,di
        mov al, resultadoOperacion[0]
        mov bl, indiceOperacion[0]
        ADD bl, 1 ;Aumentamos en uno para sustituir el que acabamos de operar
        mov di, bx
        xor bx,bx
        mov buffer[di],al

        ;Actualizamos el valor del indice
        xor ax, ax
        mov al, indiceOperacion[0]
        ADD al, 1 ;Le entraemos uno por que necesitamos ubicarnos en el siguiente operando
        mov indiceOperacion[0],al


        ;verificamos que se haya guardado la operacion
        ;xor ax, ax
        ;xor di, di
        ;xor bx, bx
        ;mov al, indiceOperacion[0]
        ;Movemos al registro indice
        ;mov di, ax
        ;mov al, buffer[di]
        ;mov numeroActual[0],al
        ;print skip
        ;print indiceOperacion
        ;print skip
        ;print numeroActual

        ;jmp menu

        ;Actualizamos la banderaPila
        mov banderaPila[0],0


        ;Como tenemos algo en pila necesitamos extraerlo
        xor ax,ax
        pop ax
        mov primerNumero[0],al

        ;Verificamos el que todo este bien
        ;xor ax, ax
        ;xor di, di
        ;xor bx, bx
        ;mov al, indiceOperacion[0]
        ;Movemos al registro indice
        ;mov di, ax
        ;mov al, buffer[di]
        ;mov numeroActual[0],al
        ;print skip
        ;print indiceOperacion
        ;print skip
        ;print primerNumero
        ;print skip
        ;print numeroActual
        ;jmp menu

        ;Extraemos el segundo numero actualizado del resultado
        ;Limpiamos
        xor ax, ax
        xor di, di
        xor bx, bx
        mov al, indiceOperacion[0]
        ;Movemos al registro indice
        mov di, ax
        mov bl, buffer[di]

        ;Guardamos el numero 2
        ;SUB bl, 48 ;Convertimos a numero decimal
        mov segundoNumero[0],bl

        ;Actualizamos el valor del indice
        xor ax, ax
        mov al, indiceOperacion[0]
        SUB al, 1 ;Le entraemos uno por que necesitamos ubicarnos en el siguiente operando
        mov indiceOperacion[0],al


        ;Verificamos el primero, el segundo numero y el operador
        ;print skip
        ;print primerNumero
        ;print segundoNumero
        ;print operadorOperacion
        ;jmp menu

        
        ;Limpiamos
        xor ax, ax
        xor di, di
        xor bx, bx
        mov al, indiceOperacion[0]
        ;Movemos al registro indice
        mov di, ax
        mov bl, buffer[di]

        ;Guardamos el operador
        mov operadorOperacion[0],bl

        ;Actualizamos el valor del indice
        xor ax, ax
        mov al, indiceOperacion[0]
        SUB al, 1 ;Le entraemos uno por que necesitamos ubicarnos en el siguiente operando
        mov indiceOperacion[0],al

        ;Verificamos el primero, el segundo numero y el operador
        ;print skip
        ;print primerNumero
        ;print segundoNumero
        ;print operadorOperacion
        ;jmp menu

        ;Verificamos que tipo de operacion es
        xor ax,ax
        mov al,operadorOperacion[0]
		cmp al,43 ;sumar ASCII
		je sumarArchivo
        cmp al,42 ;multiplicar ASCII
		je multiplicarArchivo

        jmp menu


    multiplicarArchivo:
        

        ;print skip
        ;print primerNumero
        ;print skip
        ;print segundoNumero
        ;print skip

        ;Como es una multiplicacion ejecutamos la operacion
        xor ax, ax

        mov al,primerNumero[0] ;Numero1 hacia al
        mov bl,segundoNumero[0] ;Numero2 hacia bl
        MUL bl 

        ;Guardamos el resultado
        mov resultadoOperacion[0], al


        ;print skip
        ;print resultadoOperacion
        ;print skip

        ;jmp menu

        xor ax,ax
        mov al, banderaPila[0] ;Verificamos que tenemos algo en pila
        cmp al, 1
        je algoPila
        
        jmp menu
    
        ;Cargamos el numero de repeticiones que queremos que realice loop
	    ;mov	cx,numbytes

    emergencia:
        jmp menu

    ;Etiquetas para mostrar los errores
    Error1:
		print saltolinea
		print err1
		getChar
		jmp menu

	Error2:
		print saltolinea
		print err2
		getChar
		jmp menu
	
	Error3:
		print saltolinea
		print err3
		getChar
		jmp menu
	
	Error4:
		print saltolinea
		print err4
		getChar
		jmp menu

	Error5:
		print saltolinea
		print err5
		getChar
		jmp menu
    
    salir:
		close



main endp
end main
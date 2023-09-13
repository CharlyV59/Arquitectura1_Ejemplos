;Macros que se pueden llamar
include macros1.asm 
.model Large 
; -------------- SEGMENTO DE PILA -----------------
.stack 
; -------------- Variables a utilizar -----------------
.data 

;Donde se guarda las operaciones
operaciones db 800 dup('$'), '$'

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
marco3  db 0ah,0dh, " |       | 2. Generar HTML      |       |" , '$'
marco4  db 0ah,0dh, " |  (*)  | 3. Cargar Info       |  \^/  |" , '$'
marco5  db 0ah,0dh, " |_<''>_ | 4. Salir             | _(#)_ |" , '$'
marco6  db 0ah,0dh, "o+o \ / \0                      0/ \ / (=)" , '$'
marco7  db 0ah,0dh, " 0'\ ^ /\/_   _   _   _   _   _ \/\ ^ /`0*" , '$'
marco8  db 0ah,0dh, "   /_^_\ | `_' `-' `_' `-' `_' `| /_^_\" , '$'
marco9  db 0ah,0dh, "   || || |                      | || ||" , '$'
marco10 db 0ah,0dh, "   d|_|b_T______________________T_d|_|b" , '$'


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
        print skip
		getChar

        cmp al,49 ;mnemonio 31h = 1 en hexadecimal, ascii 49
		je opcion1
		cmp al,50 ;mnemonio 32h = 2 en hexadecimal, ascii 50
		je opcion2
		cmp al,51 ;mnemonio 33h = 3 en hexadecimal, ascii 51
		je opcion3
		cmp al,52 ;mnemonio 34h = 4 en hexadecimal, ascii 52
		je salir
        jmp menu

    opcion1:
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
        jmp opcion1

        

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

    opcion2:
        

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

    opcion3:
        abrir rute,handlerentrada  ;le mandamos la ruta y el handler,que será la referencia al fichero 
		limpiar buffer, SIZEOF buffer,24h  ;limpiamos la variable donde guardaremos los datos del archivo 
		leer handlerentrada, buffer, SIZEOF buffer ;leemos el archivo
        cerrar handlerentrada

        print saltolinea 
        print buffer
        print saltolinea 

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
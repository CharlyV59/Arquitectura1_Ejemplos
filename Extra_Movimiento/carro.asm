;Macros que se pueden llamar
include macros1.asm 
.model Large 
; -------------- SEGMENTO DE PILA -----------------
.stack 
; -------------- Variables a utilizar -----------------
.data 

;Donde se almacena el simbolo
simbolo db 5 dup('$'), '$'

;Salto de linea
skip db 0ah,0dh, ' ' , '$'

;Maneja la entrada del teclado
handlerentrada dw ?

;Menu principal de la aplicacion
;Cadenas del menu principal
;Seleccion de opciones
rotulo  db 0ah,0dh, "              MENU PRINCIPAL" , '$'
marco   db 0ah,0dh, "         *_   _   _   _   _   _ *" , '$'
marco1  db 0ah,0dh, " ^       | `_' `-' `_' `-' `_' `|       ^" , '$'
marco2  db 0ah,0dh, " |  (*)  | 1. Modo video        |  \^/  |" , '$'
marco3  db 0ah,0dh, " |_<''>_ | 2. Otros             | _(#)_ |" , '$'
marco4  db 0ah,0dh, "o+o \ / \0 3. Salir             0/ \ / (=)" , '$'
marco5  db 0ah,0dh, " 0'\ ^ /\/_   _   _   _   _   _ \/\ ^ /`0*" , '$'
marco6  db 0ah,0dh, "   /_^_\ | `_' `-' `_' `-' `_' `| /_^_\" , '$'
marco7  db 0ah,0dh, "   || || |                      | || ||" , '$'
marco8 db 0ah,0dh,  "   d|_|b_T______________________T_d|_|b" , '$'


;Mensaje error de simbolo
errorSimbolo db 0ah,0dh, 'El simbolo no es correcto intente de nuevo.' , '$'

;Salto de linea
saltolinea db 10,'$'

;--------------Variables para utiliza en modo video-----------------
columna db 0
fila db 0
contador db 0
posicionX dw 0
posicionY dw 0

;Para dibujar el tablero
posicionTableroX dw 0
posicionTableroY dw 0

;Para dibujar los carriles
posicionCarrilesX dw 0
posicionCarrilesY dw 0

;Manejar la posicion del personaje
posicionPersonajeX dw 0
posicionPersonajeY dw 0

;Manejar la posicion del carro
posicionCarroX dw 0
posicionCarroY dw 0
contadorPosicionCarro db 0

;Diseño carro #1
disenoCarro1 db 81 ;Va a ser de 8 pixeles de altura por 10 pixeles de ancho
posicionCarro1X dw 0
posicionCarro1Y dw 0
posicionCarro1X_Temp dw 0
posicionCarro1Y_Temp dw 0
cicloDuracion dw 0
movimiento dw 0

;Para dibujar la division de los carriles
posicionDivisionCarrilesX dw 0
posicionDivisionCarrilesY dw 0
contadorPixelesSeparacion dw 0

;Seleccionar pagina 
pagina db 0

;---------------Variables para carteles de video----------------
menuVideo1 db 'F1 - Prueba modo video' , '$'
menuVideo2 db 'F2 - Tablero' , '$'
menuVideo3 db 'F3 - Salir modo video ' , '$'
menuVideo4 db 'F4 - Salir programa' , '$'

puntuacionVideo db '038457' , '$'
vidasVideo db 'X X X' , '$'

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
        
        

        ;Como ya cargamos lo necesario ya continua hacia nuestro programa
        jmp menu


    menu:
    	;print operarReporte 

        print rotulo
		print marco
        print marco1
        print marco2
        print marco3
        print marco4
        print marco5
        print marco6
        print marco7
        print marco8
        print skip
		getChar

        cmp al,49 ;mnemonio 31h = 1 en hexadecimal, ascii 49
		je video
		cmp al,50 ;mnemonio 32h = 2 en hexadecimal, ascii 50
		je menu
		cmp al,51 ;mnemonio 33h = 3 en hexadecimal, ascii 51
		je salir
        cmp al,52 ;mnemonio 34h = 4 en hexadecimal, ascii 52
		je salir
        cmp al,53 ;mnemonio 35h = 5 en hexadecimal, ascii 53
		je salir
		cmp al,54 ;mnemonio 35h = 5 en hexadecimal, ascii 53
		je salir
        jmp menu

    


    emergencia:
        jmp menu

    video:
           ;Iniciamos el modo video
           CALL modoVideoIniciar

		   ;Iniciamos la pagina a escribir
		   mov pagina, 0

           jmp logicaVideo

    logicaVideo:
	        ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx

           ;Necesitamos colocar en una posicion el cursor
           mov columna, 9
		   mov fila, 10
		   call colocarCursor
           print menuVideo1

           ;Necesitamos colocar en una posicion el cursor
           mov columna, 9
		   mov fila, 11
		   call colocarCursor
           print menuVideo2

           ;Necesitamos colocar en una posicion el cursor
           mov columna, 9
		   mov fila, 12
		   call colocarCursor
           print menuVideo3

		    ;Necesitamos colocar en una posicion el cursor
           mov columna, 9
		   mov fila, 13
		   call colocarCursor
           print menuVideo4

           getChar

           cmp al,59 ;mnemonio 31h = 1 en hexadecimal
           je dibujar
           cmp al,60 ;mnemonio 31h = 1 en hexadecimal
           je inicioTablero
           cmp al,61 ;mnemonio 31h = 1 en hexadecimal
           je salirModoVideo
		   cmp al,62 ;mnemonio 31h = 1 en hexadecimal
           je salirPrograma

           jmp logicaVideo

    dibujar:
            ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx

			;Inicializamos los valores de posiciones
			mov posicionX ,0
			mov posicionY ,0

	        ;Limpiamos la pantalla
			CALL limpiarEnColorNegro
			jmp ciclo
		
	ciclo:
            ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx

            ;Empezamos a graficar
			mov ah, 0ch         ;Indicar que se imprimira un pixel
			mov dx, posicionY   ;DX coordenada en Y
			mov cx, posicionX   ;CX coordenada en X
			mov bh, pagina      ;BH la pagina a imprimir
			mov al, 15          ;Color que queremos colocar
			int 10h
            
			;Aumentamos el contador
			xor ax,ax
			mov al, contador
			add al, 1
			mov contador, al

			;Aumentamos el valor de posiciones
			xor ax,ax
			xor bx,bx
			mov ax, posicionX
			add ax, 1
			mov posicionX, ax
			mov bx, posicionY
			add bx,1
			mov posicionY, bx

			cmp contador, 50
			jbe ciclo           ;Si es menor o igual salta


            ;Esperamos un caracter
			getChar

			;Ahora limpiamos la pantalla
			CALL limpiarEnColorNegro

			;Ahora nos regresamos al menu
            jmp logicaVideo

	inicioTablero: 
	        ;Limpiamos la pagina
			CALL limpiarEnColorNegro

            ;Colocamos en la pagina 1 para hacer sincronizacion
			mov pagina, 1

			
	        ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx
			mov posicionTableroX,0
			mov posicionTableroY,8

			;Ahora limpiamos la pantalla
			;CALL limpiarEnColorNegro

			jmp tablero

	
	tablero:
            ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx

            ;Empezamos a graficar pagina 0
			mov ah, 0ch                ;Indicar que se imprimira un pixel
			mov dx, posicionTableroY   ;DX coordenada en Y
			mov cx, posicionTableroX   ;CX coordenada en X
			mov bh, pagina             ;BH la pagina a imprimir
			mov al, 7                  ;Color que queremos colocar
			int 10h

			;Empezamos a graficar pagina 1
			mov ah, 0ch                ;Indicar que se imprimira un pixel
			mov dx, posicionTableroY   ;DX coordenada en Y
			mov cx, posicionTableroX   ;CX coordenada en X
			mov bh, 1                  ;BH la pagina a imprimir
			mov al, 7                  ;Color que queremos colocar
			int 10h

            ;Aumentamos la posicionTableroY
			xor ax,ax
			mov ax, posicionTableroY
			add ax, 1
			mov posicionTableroY, ax

            ;Mientras estemos dentro de < = a 192 imprimimos la fila
			cmp posicionTableroY, 192
			jbe tablero           ;Si es menor o igual salta

			;Como se sobre paso reiniciamos la posicionTableroY y aumentamos la posicion tablero X
			xor ax,ax 
			mov posicionTableroY, 8
			mov ax, posicionTableroX
			add ax, 1
			mov posicionTableroX, ax

			;Verificamos que hayamos terminado las columnas
			;Mientras estemos dentro de < = a 320 seguimos analizando
			cmp posicionTableroX, 320
			jbe tablero           ;Si es menor o igual salta

			;Esperamos un caracter
			;getChar

			;Ahora limpiamos la pantalla
			;CALL limpiarEnColorNegro

			;jmp logicaVideo ;<---------------------Regresa al inicio de video

			;Regresamos al inicio de video
			jmp inicioCarriles

	inicioCarriles:
	        ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx
            mov posicionCarrilesX, 0
			mov posicionCarrilesY, 16

			jmp Carriles

	Carriles:
	        ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx

			;Empezamos a graficar
			mov ah, 0ch                ;Indicar que se imprimira un pixel
			mov dx, posicionCarrilesY  ;DX coordenada en Y
			mov cx, posicionCarrilesX  ;CX coordenada en X
			mov bh, pagina             ;BH la pagina a imprimir
			mov al, 8                  ;Color que queremos colocar
			int 10h

			;Empezamos a graficar pagina 1
			mov ah, 0ch                ;Indicar que se imprimira un pixel
			mov dx, posicionTableroY   ;DX coordenada en Y
			mov cx, posicionTableroX   ;CX coordenada en X
			mov bh, 1                  ;BH la pagina a imprimir
			mov al, 7                  ;Color que queremos colocar
			int 10h

            ;Aumentamos la posicionCarrilesY
			xor ax,ax
			mov ax, posicionCarrilesY
			add ax, 1
			mov posicionCarrilesY, ax

            ;Mientras estemos dentro de < = a 184 imprimimos la fila
			cmp posicionCarrilesY, 184
			jbe Carriles           ;Si es menor o igual salta

			;Como se sobre paso reiniciamos la posicionCarrilesY y aumentamos la posicionCarrilesX
			xor ax,ax 
			mov posicionCarrilesY, 16
			mov ax, posicionCarrilesX
			add ax, 1
			mov posicionCarrilesX, ax

			;Verificamos que hayamos terminado las columnas
			;Mientras estemos dentro de < = a 320 seguimos analizando
			cmp posicionCarrilesX, 320
			jbe Carriles           ;Si es menor o igual salta

            ;Como termino de hacer el grafico mostramos la pagina hecha
			;CALL cambiarPagina

			;Esperamos un caracter
			;getChar

			;Ahora limpiamos la pantalla
			;CALL limpiarEnColorNegro

			;jmp logicaVideo

			jmp inicioDivisionCarriles

    inicioDivisionCarriles:
	        ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx 
			xor dx,dx
            mov posicionDivisionCarrilesX, 0
			mov posicionDivisionCarrilesY, 24
			mov contadorPixelesSeparacion,0

			jmp DivisionCarrilesCarriles

	DivisionCarrilesCarriles:
	        ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx

			;Empezamos a graficar
			mov ah, 0ch                			;Indicar que se imprimira un pixel
			mov dx, posicionDivisionCarrilesY   ;DX coordenada en Y
			mov cx, posicionDivisionCarrilesX   ;CX coordenada en X
			mov bh, pagina             			;BH la pagina a imprimir
			mov al, 15                  		;Color que queremos colocar
			int 10h

            ;Aumentamos la contadorPixelesSeparacion
			xor ax,ax
			mov ax, contadorPixelesSeparacion
			add ax, 1
			mov contadorPixelesSeparacion, ax

			;Aumentamos la posicionDivisionCarrilesX
			xor ax,ax
			mov ax, posicionDivisionCarrilesX
			add ax, 1
			mov posicionDivisionCarrilesX, ax

            ;Mientras estemos dentro de = a 10 imprimimos la fila
			cmp contadorPixelesSeparacion, 10
			je aumentoX           ;Si es menor o igual salta

			jmp DivisionCarrilesCarriles


	aumentoX:
            ;Reiniciamos el contador
			mov contadorPixelesSeparacion, 0

			;Aumentamos la posicionDivisionCarrilesX
			xor ax,ax
			mov ax, posicionDivisionCarrilesX
			add ax, 10
			mov posicionDivisionCarrilesX, ax

			;Vericamos que no hayamos llegado al borde
			cmp posicionDivisionCarrilesX, 320
			jbe DivisionCarrilesCarriles           ;Si es menor o igual salta

			;Llegamos al borde aumentamos Y
			xor ax,ax 
			mov ax, posicionDivisionCarrilesY
			add ax, 8
			mov posicionDivisionCarrilesY,ax

			;Reiniciamos X
			mov posicionDivisionCarrilesX, 0

			;Vericamos que no hayamos llegado al borde
			cmp posicionDivisionCarrilesY, 176
			jbe DivisionCarrilesCarriles           ;Si es menor o igual salta

			;Completamos los carriles
			CALL cambiarPagina

            

            jmp cartel
	
	cartel:
	        ;Necesitamos colocar en una posicion el cursor
            mov columna, 0
		    mov fila, 0
		    call colocarCursor
            print puntuacionVideo

			;Necesitamos colocar en una posicion el cursor
            mov columna, 17
		    mov fila, 0
		    call colocarCursor
            print vidasVideo

            jmp inicioCarro

    inicioCarro:
	        ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx

            ;Inicializamos las variables que vamos a usar
			mov posicionCarro1X,0    ;Posicion en x donde inicia
			mov posicionCarro1Y,22   ;Posicion en y donde inicia
			mov posicionCarro1X_Temp, 0
			mov posicionCarro1Y_Temp, 0

            ;Inicializamos el movimiento inicial
			mov movimiento, 0

			;Posicion donde inicia a limpiar los carriles
	        mov posicionCarrilesX, 0
			mov ax, posicionCarro1Y
			sub ax, 6
			mov posicionCarrilesY, ax

			jmp carro

	limpiezaCarriles:
	        

	        ;Limpiamos por donde pasa el carro generando de nuevo el carril
			;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx

			;Empezamos a graficar
			mov ah, 0ch                ;Indicar que se imprimira un pixel
			mov dx, posicionCarrilesY  ;DX coordenada en Y
			mov cx, posicionCarrilesX  ;CX coordenada en X
			mov bh, pagina             ;BH la pagina a imprimir
			mov al, 8                  ;Color que queremos colocar
			int 10h

            ;Aumentamos la posicionCarrilesY
			xor ax,ax
			mov ax, posicionCarrilesY
			add ax, 1
			mov posicionCarrilesY, ax

            ;Comparamos el maximo de la fila
			mov ax, posicionCarro1Y
			add ax, 1

            ;Mientras estemos dentro de < = a 7 imprimimos la fila, es el tamaño del carril
			cmp posicionCarrilesY, ax
			jbe limpiezaCarriles           ;Si es menor o igual salta

			;Como se sobre paso reiniciamos la posicionCarrilesY y aumentamos la posicionCarrilesX
			xor ax,ax 
			mov ax, posicionCarro1Y
			sub ax, 6
			mov posicionCarrilesY, ax
			mov ax, posicionCarrilesX
			add ax, 1
			mov posicionCarrilesX, ax

			;Verificamos que hayamos terminado las columnas
			;Mientras estemos dentro de < = a 320 seguimos analizando
			cmp posicionCarrilesX, 320
			jbe limpiezaCarriles           ;Si es menor o igual salta

            ;Continuamos con el carro
			jmp carro

    carro:
	        
            ;Creamos el diseño del carro
            crearDiseno1 disenoCarro1,posicionCarro1X,posicionCarro1Y,posicionCarro1X_Temp,posicionCarro1Y_Temp,pagina,cicloDuracion,columna,fila

            ;Desplazamos la coordenada de x + 1, para que dibuje justo en la proxima coordenada
			mov bx, posicionCarro1X
			add bx, 1
			mov posicionCarro1X,bx

            ;Posicion donde inicia a limpiar los carriles
	        mov posicionCarrilesX, 0
			mov ax, posicionCarro1Y
			add ax, 1
			mov posicionCarrilesY, ax

			;Agregamos uno el movimiento
			mov ax, movimiento
			add ax, 1
			mov movimiento,ax

            ;Comparamos el movimiento
			cmp ax, 310
			jbe limpiezaCarriles

            ;Reiniciamos para que vuelva a aparecer
			mov movimiento,0
			;Desplazamos la coordenada de x + 1, para que dibuje justo en la proxima coordenada
			mov posicionCarro1X,0
			mov posicionCarro1Y,22

			


			;Volvemos a enciclar
			jmp limpiezaCarriles


            ;Esperamos un caracter
			getChar

            ;Reset para mostrar el menu
			mov pagina, 0

			CALL cambiarPagina

			;Ahora limpiamos la pantalla
			CALL limpiarEnColorNegro


			jmp logicaVideo

    salirModoVideo:
           CALL modoVideoFinalizar
           jmp menu

    salirPrograma:
           CALL modoVideoFinalizar
           jmp salir
        
    ;-------------------Inicio de procesos------------------
    
    
    modoVideoIniciar proc
        xor ax,ax
		xor bx,bx
		xor cx,cx
		xor dx,dx

        iniciar:
		    mov ah, 0
		    mov al, 0Dh
			int 10h
			jmp fin

		fin: 
		    xor ax,ax
		    xor bx,bx
			xor cx,cx
			xor dx,dx
		    ret
    modoVideoIniciar endp

	limpiarPantalla proc
        xor ax,ax
		xor bx,bx
		xor cx,cx
		xor dx,dx

        iniciar:
		    mov ah, 06
			mov al, 00
			mov bh, 07
			mov ch, 00
			mov cl, 00
			mov dh, 24
			mov dl, 79
			int 10h
			jmp fin

		fin:
		   xor ax,ax
		   xor bx,bx
		   xor cx,cx
		   xor dx,dx
		   ret
    limpiarPantalla endp

	limpiarEnColorNegro proc
            xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx

			mov ah,06h
            mov al,0
			xor cx,cx
			mov dx,184FH
			mov bh,pagina
			int 10h 
			xor ax,ax
		    xor bx,bx
			xor cx,cx
			xor dx,dx
			ret 

	limpiarEnColorNegro endp

	generarTablero proc
		   ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx
			mov posicionTableroX,0
			mov posicionTableroY,8

			;Ahora limpiamos la pantalla
			;CALL limpiarEnColorNegro

			jmp tablero1

	
	tablero1:
            ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx

            ;Empezamos a graficar pagina 0
			mov ah, 0ch                ;Indicar que se imprimira un pixel
			mov dx, posicionTableroY   ;DX coordenada en Y
			mov cx, posicionTableroX   ;CX coordenada en X
			mov bh, pagina             ;BH la pagina a imprimir
			mov al, 7                  ;Color que queremos colocar
			int 10h

			;Empezamos a graficar pagina 1
			mov ah, 0ch                ;Indicar que se imprimira un pixel
			mov dx, posicionTableroY   ;DX coordenada en Y
			mov cx, posicionTableroX   ;CX coordenada en X
			mov bh, 1                  ;BH la pagina a imprimir
			mov al, 7                  ;Color que queremos colocar
			int 10h

            ;Aumentamos la posicionTableroY
			xor ax,ax
			mov ax, posicionTableroY
			add ax, 1
			mov posicionTableroY, ax

            ;Mientras estemos dentro de < = a 192 imprimimos la fila
			cmp posicionTableroY, 192
			jbe tablero1          ;Si es menor o igual salta

			;Como se sobre paso reiniciamos la posicionTableroY y aumentamos la posicion tablero X
			xor ax,ax 
			mov posicionTableroY, 8
			mov ax, posicionTableroX
			add ax, 1
			mov posicionTableroX, ax

			;Verificamos que hayamos terminado las columnas
			;Mientras estemos dentro de < = a 320 seguimos analizando
			cmp posicionTableroX, 320
			jbe tablero1           ;Si es menor o igual salta

			;Esperamos un caracter
			;getChar

			;Ahora limpiamos la pantalla
			;CALL limpiarEnColorNegro

			;jmp logicaVideo ;<---------------------Regresa al inicio de video

			;Regresamos al inicio de video
			jmp inicioCarriles1

	inicioCarriles1:
	        ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx
            mov posicionCarrilesX, 0
			mov posicionCarrilesY, 16

			jmp Carriles1

	Carriles1:
	        ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx

			;Empezamos a graficar
			mov ah, 0ch                ;Indicar que se imprimira un pixel
			mov dx, posicionCarrilesY  ;DX coordenada en Y
			mov cx, posicionCarrilesX  ;CX coordenada en X
			mov bh, pagina             ;BH la pagina a imprimir
			mov al, 8                  ;Color que queremos colocar
			int 10h

			;Empezamos a graficar pagina 1
			mov ah, 0ch                ;Indicar que se imprimira un pixel
			mov dx, posicionTableroY   ;DX coordenada en Y
			mov cx, posicionTableroX   ;CX coordenada en X
			mov bh, 1                  ;BH la pagina a imprimir
			mov al, 7                  ;Color que queremos colocar
			int 10h

            ;Aumentamos la posicionCarrilesY
			xor ax,ax
			mov ax, posicionCarrilesY
			add ax, 1
			mov posicionCarrilesY, ax

            ;Mientras estemos dentro de < = a 184 imprimimos la fila
			cmp posicionCarrilesY, 184
			jbe Carriles1           ;Si es menor o igual salta

			;Como se sobre paso reiniciamos la posicionCarrilesY y aumentamos la posicionCarrilesX
			xor ax,ax 
			mov posicionCarrilesY, 16
			mov ax, posicionCarrilesX
			add ax, 1
			mov posicionCarrilesX, ax

			;Verificamos que hayamos terminado las columnas
			;Mientras estemos dentro de < = a 320 seguimos analizando
			cmp posicionCarrilesX, 320
			jbe Carriles1           ;Si es menor o igual salta

            ;Como termino de hacer el grafico mostramos la pagina hecha
			;CALL cambiarPagina

			;Esperamos un caracter
			;getChar

			;Ahora limpiamos la pantalla
			;CALL limpiarEnColorNegro

			;jmp logicaVideo

			jmp inicioDivisionCarriles1

    inicioDivisionCarriles1:
	        ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx 
			xor dx,dx
            mov posicionDivisionCarrilesX, 0
			mov posicionDivisionCarrilesY, 24
			mov contadorPixelesSeparacion,0

			jmp DivisionCarrilesCarriles1

	DivisionCarrilesCarriles1:
	        ;Limpiamos los registros
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx

			;Empezamos a graficar
			mov ah, 0ch                			;Indicar que se imprimira un pixel
			mov dx, posicionDivisionCarrilesY   ;DX coordenada en Y
			mov cx, posicionDivisionCarrilesX   ;CX coordenada en X
			mov bh, pagina             			;BH la pagina a imprimir
			mov al, 15                  		;Color que queremos colocar
			int 10h

            ;Aumentamos la contadorPixelesSeparacion
			xor ax,ax
			mov ax, contadorPixelesSeparacion
			add ax, 1
			mov contadorPixelesSeparacion, ax

			;Aumentamos la posicionDivisionCarrilesX
			xor ax,ax
			mov ax, posicionDivisionCarrilesX
			add ax, 1
			mov posicionDivisionCarrilesX, ax

            ;Mientras estemos dentro de = a 10 imprimimos la fila
			cmp contadorPixelesSeparacion, 10
			je aumentoX1           ;Si es menor o igual salta

			jmp DivisionCarrilesCarriles1


	aumentoX1:
            ;Reiniciamos el contador
			mov contadorPixelesSeparacion, 0

			;Aumentamos la posicionDivisionCarrilesX
			xor ax,ax
			mov ax, posicionDivisionCarrilesX
			add ax, 10
			mov posicionDivisionCarrilesX, ax

			;Vericamos que no hayamos llegado al borde
			cmp posicionDivisionCarrilesX, 320
			jbe DivisionCarrilesCarriles1           ;Si es menor o igual salta

			;Llegamos al borde aumentamos Y
			xor ax,ax 
			mov ax, posicionDivisionCarrilesY
			add ax, 8
			mov posicionDivisionCarrilesY,ax

			;Reiniciamos X
			mov posicionDivisionCarrilesX, 0

			;Vericamos que no hayamos llegado al borde
			cmp posicionDivisionCarrilesY, 176
			jbe DivisionCarrilesCarriles1           ;Si es menor o igual salta


	generarTablero endp

	modoVideoFinalizar proc
        xor ax,ax
		xor bx,bx
		xor cx,cx
		xor dx,dx

        iniciar:
		    mov al, 0003h
			int 10h
			jmp fin

		fin:
		   xor ax,ax
		   xor bx,bx
		   xor cx,cx
		   xor dx,dx
		   ret 
    modoVideoFinalizar endp

    colocarCursor proc
        xor ax,ax
		xor bx,bx
		xor cx,cx
		xor dx,dx

        iniciar:
		    mov bh, pagina
            mov dl, columna
			mov dh, fila
            mov ah, 2 
			int 10h
			jmp fin

		fin:
		   xor ax,ax
		   xor bx,bx
		   xor cx,cx
		   xor dx,dx
		   ret 

	colocarCursor endp 

	cambiarPagina proc
        xor ax,ax
		xor bx,bx
		xor cx,cx
		xor dx,dx

        iniciar:
		    mov ah, 05h
            mov al, pagina
			int 10h
			jmp fin

		fin:
		   xor ax,ax
		   xor bx,bx
		   xor cx,cx
		   xor dx,dx
		   ret 

	cambiarPagina endp 

   

    ;----------------Fin de procesos-----------------------


    ;----------------Inicio de los carteles de error-----------
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

    ;----------------IFin de los carteles de error-----------
    
    salir:
		close



main endp
end main
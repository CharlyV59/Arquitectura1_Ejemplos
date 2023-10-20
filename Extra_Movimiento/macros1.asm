print macro cadena ;imprimir cadenas
    mov ah,09h ;Numero de funcion para imprimir cadena en pantalla
	mov dx, @data ;con esto le decimos que nuestrfo dato se encuentra en la sección data
	mov ds,dx ;el ds debe apuntar al segmento donde se encuentra la cadena (osea el dx, que apunta  a data)
	mov dx,offset cadena ;especificamos el largo de la cadena, con la instrucción offset
	int 21h  ;ejecutamos la interrupción
endm 

close macro  ;cerrar el programa
    mov ah, 4ch ;Numero de función que finaliza el programa
    xor al,al ;limpiar al 
    int 21h
endm

getChar macro ;obtener caracter
    mov ah,01h ;se guarda en al en código hexadecimal del caracter leído 
    int 21h
endm

ObtenerTexto macro cadena ;macro para recibir una cadena, varios caracteres 

LOCAL ObtenerChar, endTexto 
;si, cx, di  registros que usualmente se usan como contadores 
    xor di,di  ; => mov si, 0  reinica el contador

    ObtenerChar:
        getChar  ;llamamos al método de obtener caracter 
        cmp al, 0dh ; como se guarda en al, comparo si al es igual a salto de línea, ascii de salto de linea en hexadecimal o 10en ascii
        je endTexto ;si es igual que el salto de línea, nos vamos a la etiqueta endTexto, donde agregamos el $ de dolar a la entrada 
        mov cadena[di],al ; mov destino, fuente.  Vamos copiando el ascii del caracter que se guardó en al, al vector cadena en la posicion del contador si
        inc di ; => si = si+1
        jmp ObtenerChar

    endTexto:
        mov al, 36 ;ascii del signo $ o en hexadecimal 24h
        mov cadena[di],al  ;copiamos el $ a la cadena
endm 

clear macro ;limpia pantalla
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
endm

;Operaciones aritmeticas

sumar macro  numero1,numero2,resultado,test1,test2,signo3
  LOCAL salto,noSalto,fin   
     
     mov al,numero1 
     imul test1
     mov bl,al
     xor al,al
     mov al,numero2 
     imul test2
     add al,bl 

     ;resuelta
        cmp al,1
        jg salto
        cmp al,1
        jmp noSalto
        
        
        salto:
            ;positivo
            mov resultado,al 
            xor al,al
            mov al,43
            mov signo3[0],al
            xor al,al
            mov al,36
            mov signo3[1],al  
            mov test1,1
            jmp fin
        noSalto:
            neg al
            mov resultado,al ;
            xor al,al
            mov al,45
            mov signo3[0],al
            xor al,al
            mov al,36
            mov signo3[1],al 
            mov test1,-1
        fin:
    
endm


imprimirDecimal macro numero,guardar
    mov al, numero     
    aam               
    add ax, 3030h     
    push ax            
    mov dl, ah         
    mov guardar[0], dl
    mov ah, 02h        
    int 21h
    pop dx             
    mov al,dl
    mov guardar[1], al
    mov ah, 02h        
    int 21h
endm
    
conversor macro numero1,resultado,numero2
    mov al ,numero1[0]
    ;mov resultado[0], al
    sub al,48
    mov cl,10
    mul cl
    mov bl,al
    mov al, numero2[0]
    sub al,48
    add bl,al
    ;add bl, numero2
    mov resultado,bl

endm

extractorCompleto macro arreglo,numero1,numero2,test1,signo
Local ok,fin
            ;Limpiando el registro ax
            mov ax,0000
        
            mov al ,arreglo[0]
            cmp al,47 ;0
                ja ok
          
        ok:
            mov al ,arreglo[0] 
            mov numero1[0],al
            mov al, 36 
            mov numero1[1],al  
            mov al,0          
            mov al ,arreglo[1] 
            mov numero2[0],al 
            mov al, 36 
            mov numero2[1],al  
            mov al, 1     
            mov test1,al  
            mov al,43     
            mov signo[0],al  
            mov al,36     
            mov signo[1],al 
            ;print signo
            jmp fin 
        fin:
            ;Salimos de la macro.
      
            
endm


concatenarCadena macro origen,destino,indiceEscritura
;xor si,si  ; => mov si, 0  reinica el contador
LOCAL ObtenerCaracter,  termino
    ;Limpiamos el indice si y di 
    mov si,0
    mov di,0
    ;Extraemos de la pila el valor y lo guardamos en si
    pop si

    ;En base a la cadena que queremos guardar extraemos caracter por caracter
    ;Y lo guardamos en el destino
    ;Esto es como realizar un += para que podamos concatenar cadenas
    ObtenerCaracter:
        cmp origen[di], 36
        je termino
        mov al, origen[di]
        mov destino[si], al
        inc si
        inc di
        jmp ObtenerCaracter 
    termino:
        ;Como ya termino guardamos el indice si en la pila
        push si
        ;Limpiamos el registro di (Les recomiendo si ya no utilizan un registro limpienlo).
        mov di,0
        
endm

;La utilizamos para limpiar alguna variables con cierto caracter que se envie
limpiar macro buffer, numbytes, caracter
LOCAL Repetir
    ;Limpieza de los registros
	xor si,si
	xor cx,cx
    ;Cargamos el numero de repeticiones que queremos que realice loop
	mov	cx,numbytes

	Repetir:
        ;Movemos el caracter que ingresamos en la posicion especifica de la cadena
		mov buffer[si], caracter
        ;Aumentamos el indice si
		inc si
        ;Repetimos se va a repetir en base al numero que tenga cx, en este caso lo que se ingrese
        ;por el valor de numbytes
		Loop Repetir
endm

;Interrupcion para cerrar el handler
cerrar macro handler
	
	mov ah,3eh
	mov bx, handler
	int 21h
	jc Error2
	mov handler,ax

endm

;Interrupccion para crear un archivo
crear macro buffer, handler
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
	
	mov ah,3ch
	mov cx,00h
	lea dx,buffer
	int 21h
	jc Error4
	mov handler, ax

endm

;Interrupcion para escribir en un archivo (El handle es como el archivo abierto)
escribir macro handler, buffer, numbytes
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx


	mov ah, 40h
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h
	jc Error3

endm

;Interrupcion para abrir archivos
abrir macro buffer,handler

	mov ah,3dh
	mov al,02h
	lea dx,buffer
	int 21h
	jc Error1
	mov handler,ax

endm

;Interrupcion para leer archivos
leer macro handler,buffer, numbytes
	xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx


	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer ; mov dx,offset buffer 
	int 21h
	jc  Error5

endm

;Crear diseño carro 1
crearDiseno1 macro disenoCarro1,posicionCarroX,posicionCarroY,posicionCarroX_Temp,posicionCarroY_Temp,pagina,cicloDuracion,columna,fila
LOCAL dibujo,fila1,fila2,fila3,filaIntermedia
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx


    ;Extraemos la posicion iniciar a dibujar
    mov ax, posicionCarroX
    mov bx, posicionCarroY
    mov cx, 3 ;Limite de ruedas

    ;Va a iniciar a dibujar en la posicionCarroX y posicionCarroY
    dibujo:
            ;Por si necesito colocar valores extra


            jmp fila1

    fila1:
            ;Primer pixel rueda
            add ax,3
            mov posicionCarroX_Temp,ax
            mov posicionCarroY_Temp,bx
            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Interrupcion
            ;interrunpirCarro

            ;Extraemos valores de nuevo
            mov ax, posicionCarroX
            mov bx, posicionCarroY

            ;Segundo pixel rueda
            add ax,4
            mov posicionCarroX_Temp,ax
            mov posicionCarroY_Temp,bx
            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Extraemos valores de nuevo
            mov ax, posicionCarroX
            mov bx, posicionCarroY

            ;Tercer pixel rueda
            add ax,5
            mov posicionCarroX_Temp,ax
            mov posicionCarroY_Temp,bx
            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina


            ;Extraemos valores de nuevo
            mov ax, posicionCarroX
            mov bx, posicionCarroY

            ;Cuarto pixel rueda
            add ax,8
            mov posicionCarroX_Temp,ax
            mov posicionCarroY_Temp,bx
            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Extraemos valores de nuevo
            mov ax, posicionCarroX
            mov bx, posicionCarroY

            ;Cuarto pixel rueda
            add ax,9
            mov posicionCarroX_Temp,ax
            mov posicionCarroY_Temp,bx
            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Extraemos valores de nuevo
            mov ax, posicionCarroX
            mov bx, posicionCarroY

            ;Cuarto pixel rueda
            add ax,10
            mov posicionCarroX_Temp,ax
            mov posicionCarroY_Temp,bx
            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Extraemos valores de nuevo
            mov ax, posicionCarroX
            mov bx, posicionCarroY

            ;Continuamos a la fila2
            jmp fila2
            

    fila2:  ;Es lo mismo de arriba pero desplazamos el y a una posicion anterior
            ;Primer pixel rueda
            add ax,3
            mov posicionCarroX_Temp,ax
            sub bx,1
            mov posicionCarroY_Temp,bx
            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Interrupcion
            ;interrunpirCarro

            ;Extraemos valores de nuevo
            mov ax, posicionCarroX
            mov bx, posicionCarroY

            ;Segundo pixel rueda
            add ax,4
            mov posicionCarroX_Temp,ax
            sub bx,1
            mov posicionCarroY_Temp,bx
            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Extraemos valores de nuevo
            mov ax, posicionCarroX
            mov bx, posicionCarroY

            ;Tercer pixel rueda
            add ax,5
            mov posicionCarroX_Temp,ax
            sub bx,1
            mov posicionCarroY_Temp,bx
            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina


            ;Extraemos valores de nuevo
            mov ax, posicionCarroX
            mov bx, posicionCarroY

            ;Cuarto pixel rueda
            add ax,8
            mov posicionCarroX_Temp,ax
            sub bx,1
            mov posicionCarroY_Temp,bx
            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Extraemos valores de nuevo
            mov ax, posicionCarroX
            mov bx, posicionCarroY

            ;Cuarto pixel rueda
            add ax,9
            mov posicionCarroX_Temp,ax
            sub bx,1
            mov posicionCarroY_Temp,bx
            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Extraemos valores de nuevo
            mov ax, posicionCarroX
            mov bx, posicionCarroY

            ;Cuarto pixel rueda
            add ax,10
            mov posicionCarroX_Temp,ax
            sub bx,1
            mov posicionCarroY_Temp,bx
            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

           
            

            ;Extraemos los valores originales
            mov ax, posicionCarroX
            
            ;Restamos uno para que inicie justo donde se necesita
            sub ax, 1

            ;Lo guardamos en los temporales
            mov posicionCarroX_Temp,ax
            mov bx, posicionCarroY
            sub bx,2
            mov posicionCarroY_Temp,bx

            ;Agregamos el largo del carro a cx
            mov cicloDuracion,13
            
            ;Saltamos a la proxima fila
            jmp fila3
    fila3:
            ;Extraemos valores de nuevo
            mov ax, posicionCarroX_Temp
            mov bx, posicionCarroY_Temp

            ;Se dibuja la carroceria
            add ax,1
            mov posicionCarroX_Temp,ax
            mov posicionCarroY_Temp,bx

            ;Interrupcion
            ;interrunpirCarro

            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Restamos 1 al ciclo
            mov ax, cicloDuracion
            sub ax, 1
            mov cicloDuracion,ax

            ;Extraemos el valor a comparar
            mov cx, cicloDuracion

            ;Hasta que se cumpla el largo sigue iterando
            cmp cx,0
            je filaIntermedia

            ;Si no se cumple que siga iterando
            jmp fila3

    filaIntermedia:
            ;Extraemos los valores originales
            mov ax, posicionCarroX
            
            ;Restamos uno para que inicie justo donde se necesita
            sub ax, 1

            ;Lo guardamos en los temporales
            mov posicionCarroX_Temp,ax
            mov bx, posicionCarroY
            sub bx,3
            mov posicionCarroY_Temp,bx

            ;Agregamos el largo del carro a cx
            mov cicloDuracion,13
            
            ;Saltamos a la proxima fila
            jmp fila4
            

    fila4:  ;Ejecutamos parecido a fila 3 solo que una posicion menos en y
            ;Extraemos valores de nuevo
            mov ax, posicionCarroX_Temp
            mov bx, posicionCarroY_Temp

            ;Interrupcion
            ;interrunpirCarro

            ;Se dibuja la carroceria
            add ax,1
            mov posicionCarroX_Temp,ax
            mov posicionCarroY_Temp,bx

            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Restamos 1 al ciclo
            mov ax, cicloDuracion
            sub ax, 1
            mov cicloDuracion,ax

            ;Extraemos el valor a comparar
            mov cx, cicloDuracion

            ;Hasta que se cumpla el largo sigue iterando
            cmp cx,0
            je filaIntermedia2

            ;Si no se cumple que siga iterando
            jmp fila4
                  
    filaIntermedia2:
            ;Extraemos los valores originales
            mov ax, posicionCarroX
            
            ;Le agregamos 2 para que se desplaze 2 posiciones a la derecha y poder dibujar el techo
            add ax, 2

            ;Lo guardamos en los temporales
            mov posicionCarroX_Temp,ax
            mov bx, posicionCarroY
            sub bx,4
            mov posicionCarroY_Temp,bx

            ;Agregamos el largo del techo
            mov cicloDuracion,6
            
            ;Saltamos a la proxima fila
            jmp fila5


    fila5:  ;Ejecutamos parecido a fila 4 para el techo solo que dos posiciones menos en y
            ;Extraemos valores de nuevo
            mov ax, posicionCarroX_Temp
            mov bx, posicionCarroY_Temp

            ;Interrupcion
            ;interrunpirCarro

            ;Se dibuja la carroceria
            add ax,1
            mov posicionCarroX_Temp,ax
            mov posicionCarroY_Temp,bx

            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Restamos 1 al ciclo
            mov ax, cicloDuracion
            sub ax, 1
            mov cicloDuracion,ax

            ;Extraemos el valor a comparar
            mov cx, cicloDuracion

            ;Hasta que se cumpla el largo sigue iterando
            cmp cx,0
            je filaIntermedia3

            ;Si no se cumple que siga iterando
            jmp fila5
    
    filaIntermedia3:
            ;Extraemos los valores originales
            mov ax, posicionCarroX
            
            ;Le agregamos 2 para que se desplaze 2 posiciones a la derecha y poder dibujar el techo
            add ax, 2

            ;Lo guardamos en los temporales
            mov posicionCarroX_Temp,ax
            mov bx, posicionCarroY
            sub bx,5
            mov posicionCarroY_Temp,bx

            ;Agregamos el largo del techo
            mov cicloDuracion,6
            
            ;Saltamos a la proxima fila
            jmp fila6


    fila6:  ;Ejecutamos parecido a fila 5 para el techo solo que una posiciones menos en y
            ;Extraemos valores de nuevo
            mov ax, posicionCarroX_Temp
            mov bx, posicionCarroY_Temp

            ;Se dibuja la carroceria
            add ax,1
            mov posicionCarroX_Temp,ax
            mov posicionCarroY_Temp,bx

            

            ;Dibujamos
            graficarPixel posicionCarroX_Temp,posicionCarroY_Temp,pagina

            ;Restamos 1 al ciclo
            mov ax, cicloDuracion
            sub ax, 1
            mov cicloDuracion,ax

            ;Extraemos el valor a comparar
            mov cx, cicloDuracion

            ;Hasta que se cumpla el largo sigue iterando
            cmp cx,0
            je fin

            ;Si no se cumple que siga iterando
            jmp fila6

    validacion: 
        

    fin: 
        
        ;Interrupcion para realizar distintas acciones
        interrunpirCarro pagina,columna,fila

    
	

endm

graficarPixel macro pixelX,pixelY,pagina
            xor ax,ax
            xor bx,bx
            xor cx,cx
            xor dx,dx

            ;Empezamos a graficar
			mov ah, 0ch              ;Indicar que se imprimira un pixel
			mov dx, pixelY           ;DX coordenada en Y
			mov cx, pixelX           ;CX coordenada en X
			mov bh, pagina           ;BH la pagina a imprimir
			mov al, 15               ;Color que queremos colocar
			int 10h
endm

interrunpirCarro macro pagina,columna,fila
LOCAL input_loop,fin


            ;Colocamos el cursor donde no se mire
            mov fila,50
            mov columna,50
            
            CALL colocarCursor
           
            ;Aqui podemos hacer validaciones extra

            ;Primero validamos si se presiono algo
            mov ah,1  ;se guarda en al en código hexadecimal del caracter leído 
            int 16h

            ;Si no se presiono que siga
            jz fin

            ;Si se presiono interrumpimos
            mov ah, 0
            int 16h

            ;1,2,3,4,5 para salir
			cmp al,48
			je salirModoVideo
			cmp al,49
			je salirModoVideo
			cmp al,50
			je salirModoVideo
			cmp al,51
			je salirModoVideo
			cmp al,52
			je salirModoVideo

    fin:

endm
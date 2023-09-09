;Llamada a las macros
include macros1.asm
.model Large ;Tamaño del programa

; ---------------- Segmento de pila ----------
.stack
; ---------------- Variables a utilizar -------
.data
;Donde se guardar las operaciones
operaciones db 800 dup('$'), '$'


;Salto de linea 
skip db 0ah,0dh, ' ', '$'

;Donde donde un simbolo 
simbolo db 5 dup ('$'), '$'

;Variables para los numeros
numero1 db 50 dup ('$'), '$'
number1 db 50 dup ('$'), '$'
numero2 db 50 dup ('$'), '$'
number2 db 50 dup (' '), '$'
num1 db 50 dup ('$'), '$'
num2 db 50 dup ('$'), '$'
resul db 0
resul2 db 0000
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

;Convertida
conver db 100 dup('$') , '$'

;Rotulos
rotulo  db 0ah,0dh, "              MENU PRINCIPAL" , '$'
marco   db 0ah,0dh, "         *_   _   _   _   _   _ *" , '$'
marco1  db 0ah,0dh, " ^       | `_' `-' `_' `-' `_' `|       ^" , '$'
marco2  db 0ah,0dh, " |       | 1. SUMA              |       |" , '$'
marco3  db 0ah,0dh, " |       | 2. RESTA             |       |" , '$'
marco4  db 0ah,0dh, " |  (*)  | 3.                   |  \^/  |" , '$'
marco5  db 0ah,0dh, " |_<''>_ | 4.                   | _(#)_ |" , '$'
marco6  db 0ah,0dh, "o+o \ / \0 5. Salir             0/ \ / (=)" , '$'
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

;--------------- Segmento de codigo -------------------
.code
main proc far
mov ax,@data
mov ds,ax
mov es,ax

    menu:
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
        print marco9
        print marco10
        print skip

        getChar

        cmp al,49 ;mnemonio 31h = 1 en hexadecimal, ascii 49
		je opcion1
        cmp al,53 ;mnemonio 31h = 1 en hexadecimal, ascii 49
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


        jmp menu

    sum: 
        ;Ejecutamos una suma 05 num1 = 0 y num2 = 5 signo = -
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

        jmp menu
    
    salir:
        close


main endp
end main







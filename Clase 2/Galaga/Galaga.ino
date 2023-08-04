#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Max72xxPanel.h>
#include <RBD_Timer.h>
RBD::Timer timer;

//Pin de LOAD
int pinCS = 10;
int numeroMatricesHorizontales = 1;
int numeroMatricesVerticales = 2;

//Valores del potenciometro
const int analogPin = A0;

//Inicializamos la variable para el controlador MAX7219
Max72xxPanel matriz = Max72xxPanel(pinCS, numeroMatricesHorizontales, numeroMatricesVerticales);

//Puertos de los botones
const int izq = 2;
const int der = 3;
const int fire = 4;
const int start = 5;

//Texto display
String mensaje = " *GALAGA* ";
const int espacio = 1; //1 columna de espacio entre cada led
const int ancho = 5 + espacio; //La letra ocupa 5 pixeles
const int wait = 100; // In milliseconds


//Variables del Juego
int MODO = 1;
int vel_mensaje = 1;

//Variables de la nave
int x = 2;
int y = 15;

//Variables enemigo
int y_enemigo = 0;
int x_enemigo = random(1, 6);
const int wait_enemigo = 250; // In milliseconds

//Variable proyectil
int y_proyectil = 20;
int x_proyectil = 20;


void setup() {
    Serial.begin(9600); //
    Serial1.begin(9600); //
    pinMode(izq, INPUT);
    pinMode(der, INPUT);
    pinMode(fire, INPUT);
    pinMode(start, INPUT);

    //Configuracion de los paneles
    matriz.setIntensity(7);
    matriz.setPosition(0, 2, 0);
    matriz.setPosition(1, 2, 0);
    matriz.setRotation(0, 2);
    matriz.setRotation(1, 2);

    //Apagamos todos los LED
    //matriz.fillScreen(LOW);
    //delay(100);
    //Posicion inicial de la nave
    /*
    matriz. drawPixel(x, y, HIGH);//Enciende la nave
    matriz. drawPixel(x+1, y, HIGH);//Enciende la nave
    matriz. drawPixel(x+1, y-1, HIGH);//Enciende la nave
    matriz. drawPixel(x+2, y, HIGH);//Enciende la nave
    matriz.write(); // Dibuja en los paneles
    */
}

void loop() {
  switch (MODO) {
    case 0: JUEGO_GALAGA(); break; //juego Galaga
    case 1: MENSAJE(); break; //Mensaje de Galaga
  }

}

void JUEGO_GALAGA(){
      //Colocando el primer pixel
      matriz.setPosition(0, 2, 0);
      matriz.setPosition(1, 2, 0);
      matriz.setRotation(0, 2);
      matriz.setRotation(1, 2);

      //Creacion de proyectiles
      matriz. drawPixel(x_proyectil, y_proyectil, HIGH);//Enciende la nave
      matriz.write(); // Dibuja en los paneles

      //Creacion de enemigos
      matriz.drawPixel(x_enemigo, y_enemigo, HIGH);//Enciende la nave
      matriz.write(); // Dibuja en los paneles

      if(digitalRead(izq) == 1){
          if(x-1 >= 0){
            x = x - 1;
            matriz. drawPixel(x, y, HIGH);//Enciende la nave
            matriz. drawPixel(x+1, y, HIGH);//Enciende la nave
            matriz. drawPixel(x+1, y-1, HIGH);//Enciende la nave
            matriz. drawPixel(x+2, y, HIGH);//Enciende la nave
            matriz.write(); // Dibuja en los paneles
          }
      }
      else if(digitalRead(der) == 1){
          if(x+1 <= 5){
            x = x + 1;
            matriz. drawPixel(x, y, HIGH);//Enciende la nave
            matriz. drawPixel(x+1, y, HIGH);//Enciende la nave
            matriz. drawPixel(x+1, y-1, HIGH);//Enciende la nave
            matriz. drawPixel(x+2, y, HIGH);//Enciende la nave
            matriz.write(); // Dibuja en los paneles
          }
      }else{
            //No hay movimiento
            matriz. drawPixel(x, y, HIGH);//Enciende la nave
            matriz. drawPixel(x+1, y, HIGH);//Enciende la nave
            matriz. drawPixel(x+1, y-1, HIGH);//Enciende la nave
            matriz. drawPixel(x+2, y, HIGH);//Enciende la nave
            matriz.write(); // Dibuja en los paneles
      }

      if(digitalRead(fire) == 1){
            x_proyectil = x+1;
            y_proyectil = y-1;
            //Coordenadas proyectil
            matriz. drawPixel(x_proyectil, y_proyectil, HIGH);//Enciende la nave
            matriz.write(); // Dibuja en los paneles
      }
      
      
      //Pausa para el movimiento
      delay(velocidadGlobal());

      //Imprimimos la posicion
      Serial.println("X Proyectil: " + x_proyectil);
      Serial.println("Y Proyectil: " + y_proyectil);
      Serial.println("X Enemigo: " + x_enemigo);
      Serial.println("Y Enemigo: " + y_enemigo);
      
      //Validamos que exista colicion
      if((x_proyectil == x_enemigo) && (y_proyectil == y_enemigo)
         ||  (y_proyectil-1 == y_enemigo)
         ||  (y_proyectil == y_enemigo+1)){
          //Reiniciamos valores y sacamos de pantalla proyectil
          x_proyectil = 20;
          x_enemigo   = random(1, 6);
          y_proyectil = 20;
          y_enemigo   = -1;
       }

      //Se va acercando el enemigo.
      if(y_enemigo == 15){
         MODO = 1;
      }else{
         y_enemigo++;
         y_proyectil--;
         
      }

      matriz.fillScreen(LOW);
      matriz.write(); // Dibuja en los paneles

      velocidadGlobal();
}

void MENSAJE(){
     for(int i = 0; i < ancho * mensaje.length() + matriz.width() - 1 - espacio;i++){
         int letra = i / ancho;
         int x = (matriz.width() - 1) - i % ancho;
         int y = (matriz.height() - 8) / 2; // centrar el texto verticalmente
         while (x + ancho - espacio >= 0 && letra >= 0) {
           if (letra < mensaje.length()) {
              matriz.drawChar(x, y, mensaje[letra], HIGH, LOW, 1);
           }
           letra--;
           x -= ancho;
         }
         matriz.write(); // Send bitmap to display
         delay(velocidadGlobal());
         matriz.fillScreen(LOW);

         velocidadGlobal();
         
     }
     //Termina que vuelva al modo juego
     MODO = 0;
     
     //posiciones iniciales de la nave
     matriz. drawPixel(x, y, HIGH);//Enciende la nave
     matriz. drawPixel(x+1, y, HIGH);//Enciende la nave
     matriz. drawPixel(x+1, y-1, HIGH);//Enciende la nave
     matriz. drawPixel(x+2, y, HIGH);//Enciende la nave
     matriz.write(); // Dibuja en los paneles
}

int lecturaPotenciometro (){
   return analogRead(analogPin);
}

int velocidadGlobal(){
      int valor = lecturaPotenciometro();
      float valorPotenciometro = 1024;
      int porcentaje = (valor/valorPotenciometro) * 100;
      Serial1.print("Valor potenciometro: " );
      Serial1.println(porcentaje);
      //Caso menor o igual a 30
      int velocidad = 0;
      if(porcentaje > 0 && porcentaje <= 30){
         velocidad = 500;
      }//> 30 y menor o igual a 60
      else if(porcentaje > 30 && porcentaje <= 60){
         velocidad = 250;
      }//> 60 y  menor o igual a 100
      else if(porcentaje > 60 && porcentaje <= 100){
         velocidad = 25;
      }
      Serial1.print("Velocidad Actual: " );
      Serial1.print(velocidad);
      Serial1.println(" ms" );
      return velocidad;
}
      

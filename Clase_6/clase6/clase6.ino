#include <LiquidCrystal.h>
#include <EEPROM.h>

//Iniciar pantalla LCD
LiquidCrystal lcd(22,23,24,27,29,33);

//Mensajes de la pantalla
String mensaje1_fila0 = " Mensaje APP :)";
String mensaje1_fila1 = "               ";

// Creamos un tipo de objeto personalizado
struct alarma{
  int  tiempo;
  char nombre[15];
};

//Alarma que vamos a recuperar
alarma alarma_recuperada;

//Arreglo de numeros a DDR
//63  = 3F = 00111111 = 0 en el display;
//6   = 6  = 00000110 = 1 en el display;
//91  = 5B = 01011011 = 2 en el display;
//79  = 4F = 01001111 = 3 en el display;
//102 = 66 = 01100110 = 4 en el display;
//109 = 6D = 01101101 = 5 en el display;
//125 = 7D = 01111101 = 6 en el display;
//7   = 7  = 00000111 = 7 en el display;
//127 = 7F = 01111111 = 8 en el display;
//111 = 6F = 01101111 = 9 en el display;
//De donde salen estos numeros?
int numeros[] = {63,6,91,79,102,109,125,7,127,111};

int tiempo_temporizador = -1;
int unidades = 0;
int decenas = 0;

//Hacer que solo una vez actualice
boolean unaVez = true;

char caracter;
char finCadena;
String cadenaRecibida = "";
int estado = -1;

void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);

  pinMode(2,INPUT);
  pinMode(3,INPUT);
  pinMode(4,INPUT);
  //Puertos con numero 1 = salidas
  //Puertos con numero 0 = entradas

  //Inicializamos los puerto DDR
  //DDRF = B01011011;
  //DDRK = B01101111;
  
  alarma alarma1 = {
    30,
    "Alarma mod Z."
  };

  //Guardamos un valor
  //EEPROM.put(0, alarma1);
  //updateAlarma(0,alarma1);

  //Inicializamos el LCD
  lcd.begin(16,2);
  lcd.setCursor(1,0);
  lcd.print(mensaje1_fila0);
  lcd.setCursor(1,1);
  lcd.print(mensaje1_fila1);
}

void loop() {
  
  //Recibimos la cena y la guardamos
  if(Serial.available()){
     caracter = Serial.read();
     cadenaRecibida += caracter;
     finCadena = caracter;
  }

  //Seleccionador de estados
  selectorEstado();


  if(tiempo_temporizador >= 0){
     existeTemporizador();
     
     if(tiempo_temporizador == 0){
        //Bloquemos al tiempo
        tiempo_temporizador = -1;
        unaVez = true;
        //Reiniciamos los display
        cambiarNumeroDisplay(1,0);
        cambiarNumeroDisplay(2,0);
        //Enviar informacion.
        Serial.println("Finalizado!");
        Serial1.println("Finalizado!");
     }
  }else{
     if(unaVez){
       //Leemos el nombre y lo colocamos en el panel LCD
       EEPROM.get(0,alarma_recuperada);
    
       //Escribimos el nombre
       lcd.clear();
       lcd.setCursor(1,0);
       lcd.print(mensaje1_fila0);
       lcd.setCursor(1,1);
       lcd.print(alarma_recuperada.nombre);
       unaVez = false;

       //Serial1.println(alarma_recuperada.nombre);
       //Serial1.println(alarma_recuperada.tiempo);
     }
     
  }

 
}

void existeTemporizador(){
    //Cambiamos el estado segun corresponda.
    temporizador(tiempo_temporizador);
  
    //Leemos el nombre y lo colocamos en el panel LCD
    //EEPROM.get(0,alarma_recuperada);
  
    //Escribimos el nombre
    //lcd.clear();
    //lcd.setCursor(1,0);
    //lcd.print(mensaje1_fila0);
    //lcd.setCursor(1,1);
    //lcd.print(alarma_recuperada.nombre);
    
  
    delay(100);
}

void selectorEstado(){
     if(finCadena == '%'){
          //Serial1.println(cadenaRecibida);
          
          //Ya recibimos la cadena completa.
          String tiempo = "";
          String nombre = "";
          boolean bandera = true;
          for(int x = 0;x < cadenaRecibida.length();x++){
              if(cadenaRecibida[x] == ',' || cadenaRecibida[x] == '%'){
                 //Cambiamos el valor de la bandera
                 bandera = false;
                 continue;    
              }
                          
              if(bandera){
                 //Guardamos el tiempo
                 tiempo += cadenaRecibida[x];
              }else{
                 //Guardamos el nombre
                 nombre += cadenaRecibida[x];
              }
              //Serial1.println(tiempo);
              //Serial1.println(nombre);
          }
          //Actualizamos el LCD
          lcd.clear();
          lcd.setCursor(1,0);
          lcd.print(" Ejecutando ");
          lcd.setCursor(1,1);
          lcd.print(" Temporizador! ");

          //Convertimos el string a INT
          tiempo_temporizador = tiempo.toInt();
          //Guardamos los valores
          alarma alarmaGuardar;
          alarmaGuardar.tiempo = tiempo_temporizador;
          //Convertimos String to char
          char nombreArray[15];
          nombre.toCharArray(alarmaGuardar.nombre, nombre.length() + 1);
          updateAlarma(0,alarmaGuardar);

          cadenaRecibida = "";
          finCadena = '$';
     }
}

void temporizador(int tiempo){
      //Convertir los segundos a decenas y unidades
      int decenas = tiempo / 10;
      int unidades = tiempo % 10;
      
      //Serial1.println(decenas);
      //Serial1.println(unidades);
  
      cambiarNumeroDisplay(1,decenas);
      cambiarNumeroDisplay(2,unidades);

      //Para que no vaya a numeros negativos
      if(tiempo>0){
         tiempo--;
      }
      
      tiempo_temporizador = tiempo;
}


void cambiarNumeroDisplay(int numero_display,int numero){
     switch(numero_display){
           case 1: DDRF = numeros[numero];
                   break;
           case 2: DDRK = numeros[numero];
                   break;
     }
}

void updateAlarma(int direccion,alarma actualizar){
    alarma Temporal;
    EEPROM.get(direccion,Temporal);
    if( Temporal.nombre != actualizar.nombre ||
        Temporal.tiempo != actualizar.tiempo
      ){
        EEPROM.put(direccion, actualizar);
    }
}

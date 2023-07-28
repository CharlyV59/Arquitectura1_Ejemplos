//Declaracion de los puertos a utilizar
const int rojo_via1 = 22;
const int rojo_via2 = 51;
const int amarillo_via1 = 23;
const int amarillo_via2 = 52;
const int verde_via1 = 24;
const int verde_via2 = 53;

//Display 1 7 segmentos
const int display1Pin1 = 2;
const int display1Pin2 = 3;
const int display1Pin3 = 4;
const int display1Pin4 = 5;

//Display 2 7 segmentos
const int display2Pin1 = 6;
const int display2Pin2 = 7;
const int display2Pin3 = 8;
const int display2Pin4 = 9;

//Contador inicio
int contadorDisplay1 = 9;
int contadorDisplay2 = 9;

//Matriz decimal a binaria
int numeros[10][4] = {
{0,0,0,0}, //0000 = 0
{0,0,0,1}, //0001 = 1
{0,0,1,0}, //0010 = 2 
{0,0,1,1}, //0011 = 3
{0,1,0,0}, //0100 = 4
{0,1,0,1}, //0101 = 5
{0,1,1,0}, //0110 = 6
{0,1,1,1}, //0111 = 7
{1,0,0,0}, //1000 = 8
{1,0,0,1}, //1001 = 9
};



//Codigo que se ejecuta al iniciar el arduino una sola vez.
void setup() {
  Serial.begin(9600);

  //Al iniciar colocar en verde uno y rojo el otro
  digitalWrite(rojo_via2, HIGH);
  digitalWrite(verde_via1, HIGH);

  //Modos del pin de salida
  pinMode(display1Pin1, OUTPUT);
  pinMode(display1Pin2, OUTPUT);
  pinMode(display1Pin3, OUTPUT);
  pinMode(display1Pin4, OUTPUT);

  pinMode(display2Pin1, OUTPUT);
  pinMode(display2Pin2, OUTPUT);
  pinMode(display2Pin3, OUTPUT);
  pinMode(display2Pin4, OUTPUT);

  pinMode(rojo_via1, OUTPUT);
  pinMode(rojo_via2, OUTPUT);
  pinMode(amarillo_via1, OUTPUT);
  pinMode(amarillo_via2, OUTPUT);
  pinMode(verde_via1, OUTPUT);
  pinMode(verde_via2, OUTPUT);

}

//Se podria decir como un ciclo while que ejecuta el codigo que se encuentre dentro de el
void loop() {
   //Apagamos el rojo via 1
   digitalWrite(rojo_via1, LOW);
   semaforo(rojo_via1,amarillo_via1,verde_via1);

   //Apagamos el rojo via 2
   digitalWrite(rojo_via2, LOW);
   semaforo(rojo_via2,amarillo_via2,verde_via2);
  
}

void semaforo(int rojo,int amarillo, int verde){
      digitalWrite(verde, HIGH);
      pausarContador(750,4);
      //delay(1225);
      int parpadeo = 3;
      parpadeoLED(verde,parpadeo);
      digitalWrite(verde, LOW);

      digitalWrite(amarillo, HIGH);
      pausarContador(750,3);
      parpadeo = 3;
      parpadeoLED(amarillo,parpadeo);
      digitalWrite(amarillo, LOW);
      digitalWrite(rojo, HIGH);
}

void parpadeoLED(int puerto,int repeticiones){
    int contador = 0;
    pausarContador(1,1);
    while(contador < repeticiones){
        delay(125);
        digitalWrite(puerto, LOW);
        delay(125);
        digitalWrite(puerto, HIGH);
        contador++;
    }
    
}

void mostrarNumero(int display,int numero){
    switch(display){
          case 1:
                //Estamos en el display 1
                digitalWrite(display1Pin1, numeros[numero][0]);
                digitalWrite(display1Pin2, numeros[numero][1]);
                digitalWrite(display1Pin3, numeros[numero][2]);
                digitalWrite(display1Pin4, numeros[numero][3]);
                break;
          case 2:
                //Estamos en el display 2
                digitalWrite(display2Pin1, numeros[numero][0]);
                digitalWrite(display2Pin2, numeros[numero][1]);
                digitalWrite(display2Pin3, numeros[numero][2]);
                digitalWrite(display2Pin4, numeros[numero][3]);
                break;
    }
}

void contadorTiempo(){
    mostrarNumero(1,contadorDisplay1--);
    mostrarNumero(2,contadorDisplay2--);
    Serial.print(contadorDisplay1);
    Serial.print("\n");
    Serial.print(contadorDisplay2);

    if(contadorDisplay1 == 0){
        contadorDisplay1 = 9;
        contadorDisplay2 = 9;
    }
}

void pausarContador(int tiempoPausa,int segundos){
      int contador = 0;
      while(contador != segundos){
            contadorTiempo();
            contador++;
            delay(tiempoPausa);
      }
}

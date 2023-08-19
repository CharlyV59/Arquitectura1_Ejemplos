#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

//Crear el objeto lcd  dirección  0x3F y 16 columnas x 2 filas
LiquidCrystal_I2C lcd(0x20,16,2);  //
LiquidCrystal_I2C lcd2(0x21,16,2);  //

long data = 0;
long response = 200;
const byte I2C_SLAVE_ADDR = 0x01;
int pinOut = 0;
int estado = 0;

void setup() {
  // Inicializar el LCD
  lcd.init();
  lcd2.init();
  
  //Encender la luz de fondo.
  lcd.backlight();
  lcd2.backlight();
  
  //Colocamos el cursos columna 0 y fila 0 correspondientemente.
  lcd.setCursor(0, 0);
  // Escribimos el Mensaje en el LCD.
  lcd.print(" Primer Cartel ");
  lcd2.print(" Segundo Cartel ");

  //Iniciamos el serial
  Serial.begin(9600);

  // Pines en modo salida
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);

  
 
}

void loop() {
  //Limpiamos cartel
  lcd2.clear();
  //Colocamos el cursos columna 0 y fila 0 correspondientemente.
  lcd2.setCursor(0, 0);
  // Escribimos el Mensaje en el LCD.
  char Pin[12] = "Pin mod: ";
  Pin[9] = (pinOut+48);
  lcd2.print(Pin);
  lcd2.setCursor(0, 1);
  // Escribimos el Mensaje en el LCD.
  char Estadomsg[12] = "Estado: ";
  Estadomsg[8] = (estado+48);
  lcd2.print(Estadomsg);
  
  
   // Ubicamos el cursor en la primera posición(columna:0) de la segunda línea(fila:1)
  lcd.setCursor(0, 1);
   // Escribimos el número de segundos trascurridos
  lcd.print(millis()/1000);
  lcd.print(" Segundos");
  Serial.println("Envio de cartel!");

  // Unimos este dispositivo al bus I2C con dirección 1
  Wire.begin(I2C_SLAVE_ADDR);
  // Registramos el evento al recibir datos
  Wire.onReceive(receiveEvent);

  //Actualizamos el cartel con el estado
  
 
  delay(500);
}


// Función que se ejecuta siempre que se reciben datos del maestro
// siempre que en el master se ejecute la sentencia endTransmission
// recibirá toda la información que hayamos pasado a través de la sentencia Wire.write
void receiveEvent(int howMany) {
 
  // Si hay dos bytes disponibles
  if (Wire.available() == 2)
  {
    // Leemos el primero que será el pin
    pinOut = Wire.read();
    Serial.print("LED ");
    Serial.println(pinOut);
  }
  // Si hay un byte disponible
  if (Wire.available() == 1)
  {
    estado = Wire.read();
    Serial.print("Estado ");
    Serial.println(estado);
  }
 
  // Activamos/desactivamos salida
  digitalWrite(pinOut,estado);
}

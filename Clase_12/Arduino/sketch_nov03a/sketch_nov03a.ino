void setup() {
  Serial.begin(9600);  // Inicia la comunicación serial a 9600 baudios

}

void loop() {
    // Lectura de la temperatura y la humedad
    float temperatura = 27;
    float humedad = 10; //Porcentaje de humedad
    String cadena = "Temp: "+String(temperatura)+" °C,Humedad: "+String(humedad)+" %";
  
    // Envía los datos al puerto serial
    Serial.print(cadena);
    // Puedes ajustar la velocidad de envío agregando un retardo
    delay(5000); // Espera 2 segundos antes de tomar otra lectura
}

var {SerialPort} = require("serialport");
const express = require('express');
const cors = require('cors');
const http = require('http');
const app = express();
const server = http.createServer(app);
app.use(cors());

var serialPort = new SerialPort( {
  path: "COM5",
  baudRate: 9600
});

var arduinoData = '';

function recibirInformacion(){
  serialPort.on("open", function() {
    console.log("Conexion con arduino correcta.");
    serialPort.on("data", function(data) {
      console.log("Informacion: " + data);

      //Reiniciamos la variable
      arduinoData = "";

      //Obtenemos la informacion
      arduinoData += data.toString();
    });
  });
}

function enviarInformacion(){
  app.get('/getInformacion', (req, res) => {
    console.log("Informacion recibida: " + arduinoData);
    res.json({ informacion: arduinoData });
  });
}


//Metodo para iniciar API
const PORT = process.env.PORT || 3001;

server.listen(PORT, () => {
  //middlewares
  app.use(cors());
  app.use(express.urlencoded({ extended: false }));
  app.use(express.json({ limit: '500mb' }));
  app.use(cors({
    origin: '*'
  }));

  console.log(`Servidor en ejecución en el puerto ${PORT}`);
  //Recibir la informacion arduino
  recibirInformacion();
  //Enviar por la api
  enviarInformacion();


});


// Utilizar funcionalidades del Ecmascript 6
'use strict'

// *Cargamos el fichero app.js con la configuración de Express
let app = require('./src/app');
const express = require('express')

const cors = require("cors");

const db = require("./src/models/index");

//Establece el puerto por el cual se escuchará.
const PORT = process.env.PORT || 3000;

let corsOptions = {
  origin: "http://localhost:5432"
};

app.use(cors(corsOptions));

// parse requests of content-type - application/json
app.use(express.json());

// parse requests of content-type - application/x-www-form-urlencoded
app.use(express.urlencoded({ extended: true }));

//Sincroniza la base de datos (puede eliminarla).
db.sequelize.sync()
  .then(() => {
    console.log("Base de datos sincronizada.");
  })
  .catch((err) => {
    console.log("Error: Fallo al sincronizar la base de datos: " + err.message);
  });

app.listen(PORT, () => {
  console.log(`App running on port ${PORT}.`)
})
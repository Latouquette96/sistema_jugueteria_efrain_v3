'use strict'
//Carga el módulo de express para poder crear rutas
let express = require('express');

//Carga el controlador
let FunctionController = require('../controllers/functions/function_java.controller');

//Se llama al router
let app = express.Router();
//let md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/services/extract_text_pdf/:path',  /*md_auth.ensureAuth, */ FunctionController.extractTextFromPDF)

//Exportación de la configuración
module.exports = app;
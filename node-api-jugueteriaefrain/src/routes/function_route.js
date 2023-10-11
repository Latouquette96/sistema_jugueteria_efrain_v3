'use strict'
//Carga el módulo de express para poder crear rutas
var express = require('express');

//Carga el controlador
var FunctionController = require('../controllers/function.controller');

//Se llama al router
var app = express.Router();
//var md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/services/extract_text_pdf',  /*md_auth.ensureAuth, */ FunctionController.extractTextFromPDF)

//Exportación de la configuración
module.exports = app;
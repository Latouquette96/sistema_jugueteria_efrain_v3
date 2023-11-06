'use strict'
//Carga el módulo de express para poder crear rutas
var express = require('express');

//Carga el controlador
var CodeGeneratedController = require('../../controllers/postgresql/code_generated.controller');

//Se llama al router
var app = express.Router();
//var md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/products/code_generated/:id',  /*md_auth.ensureAuth, */ CodeGeneratedController.findOne)
app.get('/products/code_generated',  /*md_auth.ensureAuth, */ CodeGeneratedController.findFirstFree)
app.post('/products/code_generated',  /*md_auth.ensureAuth, */ CodeGeneratedController.create)
app.put('/products/code_generated/:id',  /*md_auth.ensureAuth, */ CodeGeneratedController.update)
app.put('/products/code_generated/free/:id',  /*md_auth.ensureAuth, */ CodeGeneratedController.free)

//Exportación de la configuración
module.exports = app;
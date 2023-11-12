'use strict'
//Carga el módulo de express para poder crear rutas
const express = require('express');

//Carga el controlador
const CodeGeneratedController = require('../../controllers/postgresql/code_generated.controller');

//Se llama al router
const app = express.Router();
//var md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/code_generated',  /*md_auth.ensureAuth, */ CodeGeneratedController.findByProduct)
app.get('/code_generated/first_free',  /*md_auth.ensureAuth, */ CodeGeneratedController.findFirstFree)
app.post('/code_generated',  /*md_auth.ensureAuth, */ CodeGeneratedController.create)
app.post('/code_generated/generate_code_block',  /*md_auth.ensureAuth, */ CodeGeneratedController.generateCodeBlock)
app.put('/code_generated/:id',  /*md_auth.ensureAuth, */ CodeGeneratedController.updateState)
app.put('/code_generated/free/:id',  /*md_auth.ensureAuth, */ CodeGeneratedController.free)

//Exportación de la configuración
module.exports = app;
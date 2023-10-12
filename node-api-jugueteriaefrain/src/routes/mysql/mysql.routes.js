'use strict'
//Carga el módulo de express para poder crear rutas
var express = require('express');

//Carga el controlador
var MySQLController = require('../../controllers/mysql/mysql.controller');

//Se llama al router
var app = express.Router();
//var md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/mysql/distributors',  /*md_auth.ensureAuth, */ MySQLController.findAllDistributors)
app.get('/mysql/products',  /*md_auth.ensureAuth, */ MySQLController.findAllProducts)
app.post('/mysql/connect',  /*md_auth.ensureAuth, */ MySQLController.connect)
app.post('/mysql/close',  /*md_auth.ensureAuth, */ MySQLController.close)

//Exportación de la configuración
module.exports = app;
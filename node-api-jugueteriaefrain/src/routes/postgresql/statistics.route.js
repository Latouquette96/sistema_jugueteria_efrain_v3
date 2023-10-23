'use strict'
//Carga el módulo de express para poder crear rutas
var express = require('express');

//Carga el controlador
var StatisticsController = require('../../controllers/postgresql/statistics.controller');

//Se llama al router
var app = express.Router();
//var md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/statistics/estimated_total',  /*md_auth.ensureAuth, */ StatisticsController.getEstimatedTotal)

//Exportación de la configuración
module.exports = app;
'use strict'
//Carga el módulo de express para poder crear rutas
var express = require('express');

//Carga el controlador
var DistributorController = require('../controllers/crud/crud_distributor');

//Se llama al router
var app = express.Router();
var md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/distributors', /*md_auth.ensureAuth, */ DistributorController.getDistributors)
app.get('/distributors/:id', /*md_auth.ensureAuth, */ DistributorController.getDistributorById)
app.post('/distributors', /*md_auth.ensureAuth, */ DistributorController.createDistributor)
app.put('/distributors/:id', /*md_auth.ensureAuth, */ DistributorController.updateDistributor)
app.delete('/distributors/:id', /*md_auth.ensureAuth, */ DistributorController.deleteDistributor)

//Exportación de la configuración
module.exports = app;
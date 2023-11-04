'use strict'
//Carga el módulo de express para poder crear rutas
let express = require('express');

//Carga el controlador
let DistributorController = require('../../controllers/postgresql/distributor.controller');

//Se llama al router
let app = express.Router();
//let md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/distributors', /*md_auth.ensureAuth, */ DistributorController.findAll)
app.get('/distributors/:id', /*md_auth.ensureAuth, */ DistributorController.findOne)
app.post('/distributors', /*md_auth.ensureAuth, */ DistributorController.create)
app.put('/distributors/:id', /*md_auth.ensureAuth, */ DistributorController.update)
app.delete('/distributors/:id', /*md_auth.ensureAuth, */ DistributorController.delete)

//Exportación de la configuración
module.exports = app;
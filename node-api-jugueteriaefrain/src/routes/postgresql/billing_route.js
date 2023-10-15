'use strict'
//Carga el módulo de express para poder crear rutas
var express = require('express');

//Carga el controlador
var BillingController = require('../../controllers/postgresql/billing.controller');

//Se llama al router
var app = express.Router();
//var md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/distributors/billings/distributor/:id',  /*md_auth.ensureAuth, */ BillingController.findAll)
app.post('/distributors/billings',  /*md_auth.ensureAuth, */ BillingController.create)
app.delete('/distributors/billings/:id',  /*md_auth.ensureAuth, */ BillingController.delete)
app.delete('/distributors/billings/deleteAll/:id',  /*md_auth.ensureAuth, */ BillingController.deleteAll)

//Exportación de la configuración
module.exports = app;
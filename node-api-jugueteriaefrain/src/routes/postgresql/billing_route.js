'use strict'
//Carga el módulo de express para poder crear rutas
const express = require('express');

//Carga el controlador
const BillingController = require('../../controllers/postgresql/billing.controller');

//Se llama al router
const app = express.Router();
//var md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/distributors/billings/distributor/:id',  /*md_auth.ensureAuth, */ BillingController.findAll)
app.post('/distributors/billings',  /*md_auth.ensureAuth, */ BillingController.create)
app.put('/distributors/billings/:id',  /*md_auth.ensureAuth, */ BillingController.update)
app.delete('/distributors/billings/:id',  /*md_auth.ensureAuth, */ BillingController.delete)
app.delete('/distributors/billings/deleteAll/:id',  /*md_auth.ensureAuth, */ BillingController.deleteAll)

//Exportación de la configuración
module.exports = app;
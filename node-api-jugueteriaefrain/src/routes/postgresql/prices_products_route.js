'use strict'
//Carga el módulo de express para poder crear rutas
var express = require('express');

//Carga el controlador
var PricesProductController = require('../../controllers/postgresql/products_prices.controller');

//Se llama al router
var app = express.Router();
//var md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/products/prices_products/:id',  /*md_auth.ensureAuth, */ PricesProductController.findAll)
app.post('/products/prices_products/',  /*md_auth.ensureAuth, */ PricesProductController.create)
app.put('/products/prices_products/:id',  /*md_auth.ensureAuth, */ PricesProductController.update)
app.delete('/products/prices_products/:id',  /*md_auth.ensureAuth, */ PricesProductController.delete)
app.delete('/products/prices_products/deleteAlls/:id',  /*md_auth.ensureAuth, */ PricesProductController.deleteAll)

//Exportación de la configuración
module.exports = app;
'use strict'
//Carga el módulo de express para poder crear rutas
var express = require('express');

//Carga el controlador
var PricesProductController = require('../controllers/crud/crud_prices_products');

//Se llama al router
var app = express.Router();
var md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/products/prices_products/:id',  /*md_auth.ensureAuth, */ PricesProductController.getProductPriceByID)
app.post('/products/prices_products/',  /*md_auth.ensureAuth, */ PricesProductController.createProductPrice)
app.put('/products/prices_products/:id',  /*md_auth.ensureAuth, */ PricesProductController.updateProductPrice)
app.delete('/products/prices_products/:id',  /*md_auth.ensureAuth, */ PricesProductController.deleteProductPrice)

//Exportación de la configuración
module.exports = app;
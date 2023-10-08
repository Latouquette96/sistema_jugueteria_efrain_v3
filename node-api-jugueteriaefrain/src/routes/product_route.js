'use strict'
//Carga el módulo de express para poder crear rutas
var express = require('express');

//Carga el controlador
var ProductController = require('../controllers/crud/crud_product');

//Se llama al router
var app = express.Router();
var md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/products/:id', /*md_auth.ensureAuth, */ ProductController.getProductById)
app.get('/products', /*md_auth.ensureAuth, */ ProductController.getProducts)
app.post('/products', /*md_auth.ensureAuth, */ ProductController.createProduct)
app.put('/products/:id', /*md_auth.ensureAuth, */ ProductController.updateProduct)
app.put('/products/price_public/:id', /*md_auth.ensureAuth, */ ProductController.updatePricePublicProduct)
app.delete('/products/:id', /*md_auth.ensureAuth, */ ProductController.deleteProduct)

//Exportación de la configuración
module.exports = app;
'use strict'
//Carga el módulo de express para poder crear rutas
let express = require('express');

//Carga el controlador
let ProductController = require('../../controllers/postgresql/product.controller');

//Se llama al router
let app = express.Router();
//let md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/products/:id',  ProductController.findOne)
app.get('/products',  ProductController.findAll)
app.post('/products',  ProductController.create)
app.put('/products/:id',  ProductController.update)
app.put('/products/price_public/:id',  ProductController.updatePricePublic)
app.delete('/products/:id',  ProductController.delete)

//Exportación de la configuración
module.exports = app;
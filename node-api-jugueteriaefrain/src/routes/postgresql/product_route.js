'use strict'
//Carga el módulo de express para poder crear rutas
let express = require('express');

//Carga el controlador
let ProductController = require('../../controllers/postgresql/product.controller');

//Se llama al router
let app = express.Router();
//let md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/products/:id', /*md_auth.ensureAuth, */ ProductController.findOne)
app.get('/products', /*md_auth.ensureAuth, */ ProductController.findAll)
app.post('/products', /*md_auth.ensureAuth, */ ProductController.create)
app.put('/products/:id', /*md_auth.ensureAuth, */ ProductController.update)
app.put('/products/price_public/:id', /*md_auth.ensureAuth, */ ProductController.updatePricePublic)
app.delete('/products/:id', /*md_auth.ensureAuth, */ ProductController.delete)

//Exportación de la configuración
module.exports = app;
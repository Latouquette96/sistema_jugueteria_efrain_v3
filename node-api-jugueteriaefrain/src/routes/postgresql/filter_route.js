'use strict'
//Carga el módulo de express para poder crear rutas
let express = require('express');

//Carga el controlador
let FilterController = require('../../controllers/crud/crud_filter');

//Se llama al router
let app = express.Router();
//let md_auth = require('../middlewares/authenticated');

//-- Creación de rutas para los métodos del controlador --
app.get('/filter/brands', /*md_auth.ensureAuth, */ FilterController.getLoadedBrands)

//Exportación de la configuración
module.exports = app;
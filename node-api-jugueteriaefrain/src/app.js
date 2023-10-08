//Utilizar funcionalidades del Ecmascript 6
'use strict'

//Cargamos los módulos de express y body-parser
var express = require('express');
var bodyParser = require('body-parser');

//Llamamos a express para poder crear el servidor
var app = express();

//Importamos las rutas
var products_routes = require('./routes/product_route'); 
var distributor_routes = require('./routes/distributor_route'); 
var price_products_routes = require('./routes/prices_products_route'); 
var billing_routes = require('./routes/billing_route'); 

//cargar middlewares
//un metodo que se ejecuta antes que llegue a un controlador
//Configuramos bodyParser para que convierta el body de nuestras peticiones a JSON
app.use(bodyParser.urlencoded({extended:false}));
app.use(bodyParser.json());

// Cargamos las rutas
app.use('/', products_routes);
app.use('/', distributor_routes);
app.use('/', price_products_routes);
app.use('/', billing_routes);
// exportamos este módulo para poder usar la variable app fuera de este archivo
module.exports = app;
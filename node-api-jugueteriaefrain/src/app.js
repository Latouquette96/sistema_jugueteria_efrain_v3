//Utilizar funcionalidades del Ecmascript 6
'use strict'

//Carga los módulos de express y body-parser
var express = require('express');
var bodyParser = require('body-parser');

//Llama a express para poder crear el servidor
var app = express();

//Realiza la importación las rutas
var products_routes = require('./routes/postgresql/product_route'); 
var distributor_routes = require('./routes/postgresql/distributor_route'); 
var price_products_routes = require('./routes/postgresql/prices_products_route'); 
var billing_routes = require('./routes/postgresql/billing_route'); 
var function_routes = require('./routes/function_route'); 
var mysql_routes = require('./routes/mysql/mysql.routes'); 
var filter_routes = require('./routes/postgresql/filter_route'); 
var statistics_routes = require('./routes/postgresql/statistics.route'); 

//cargar middlewares: un metodo que se ejecuta antes que llegue a un controlador
//Se configura bodyParser para que convierta el body de nuestras peticiones a JSON
app.use(bodyParser.urlencoded({extended:false}));
app.use(bodyParser.json());

app.get('/', (request, response) => {
    response.json({ info: '¡¡Bienvenido al servidor de Juguetería Efraín!!' })
  })

//Se cargan las rutas
app.use('/', products_routes);
app.use('/', distributor_routes);
app.use('/', price_products_routes);
app.use('/', billing_routes);
app.use('/', function_routes);
app.use('/', mysql_routes);
app.use('/', filter_routes);
app.use('/', statistics_routes);

//Se exporta este módulo para poder usar la variable app fuera de este archivo
module.exports = app;
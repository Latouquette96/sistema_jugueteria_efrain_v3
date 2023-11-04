//Utilizar funcionalidades del Ecmascript 6
'use strict'

//Carga los módulos de express y body-parser
let express = require('express');
let bodyParser = require('body-parser');

//Llama a express para poder crear el servidor
let app = express();

//Realiza la importación las rutas
let products_routes = require('./routes/postgresql/product_route'); 
let distributor_routes = require('./routes/postgresql/distributor_route'); 
let price_products_routes = require('./routes/postgresql/prices_products_route'); 
let billing_routes = require('./routes/postgresql/billing_route'); 
let function_routes = require('./routes/function_route'); 
let mysql_routes = require('./routes/mysql/mysql.routes'); 
let filter_routes = require('./routes/postgresql/filter_route'); 

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

//Se exporta este módulo para poder usar la letiable app fuera de este archivo
module.exports = app;
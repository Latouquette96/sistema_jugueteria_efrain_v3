const mysql = require('mysql');
let connection;

exports.connect = (req, res) => {

    const db_host = req.body.db_host;
    const db_user = req.body.db_user;
    const db_password  = req.body.db_password;

    connection = mysql.createConnection({
        host: db_host,
        user: db_user,
        password: db_password,
        database: "db_jugueteria_efrain",
        port: 3306
    });
    
    connection.connect(err => {
        if (err) {
            res.status(500).send('Error: No se pudo realizar la conexion a la base de datos');
        } 
        else {
            res.status(200).send('Conexión exitosa a la base de datos');
        }
    });
}

exports.close = (req, res) => {
    if(connection && connection.end) {
        connection.end(err => {
            if (err) {
                console.error('Error: No se pudo realizar la desconexión de la base de datos: ', err);
                res.status(500).send('Error: No se pudo realizar la desconexión de la base de datos.');
            } else {
                res.status(200).send('Desconexión exitosa de la base de datos');
            }
        });
    } 
    else {
        res.status(400).send('Error: No hay una conexión a la base de datos para cerrar.');
    }
}

//Recupera todos los productos (junto a datos de la distribuidora y del precio del producto) de la base de datos.
exports.findAllProducts = (req, res) => {
    var sql = "SELECT json_object('p_id', p_id, 'p_codebar', p_codebar, 'p_title', p_title, 'p_brand', p_brand, 'p_description', p_description, 'p_sizeblister', p_sizeblister, 'p_sizeproduct', p_sizeproduct, 'p_category', p_category, 'p_subcategory', p_subcategory, 'p_stock', p_stock, 'p_iva', p_iva, 'p_pricepublic', p_pricepublic, 'p_linkimage', p_linkimage, 'p_datecreated', p_datecreated, 'p_dateupdated', p_dateupdated, 'p_minimumage', p_minimumage, 'p_internal_code', p_internal_code) as product, d_cuit, json_object('p_dateupdated', p_dateupdated, 'p_pricebase', p_pricebase) as price_product FROM db_jugueteria_efrain.products, db_jugueteria_efrain.distributors WHERE p_distributor=d_id;";
    
    connection.query(sql, function (error, results, fields) {
        if (error) {
          console.error(error);
          res.status(500).json({error: 'Error: No se pudo obtener los resultados.'});
        } 
        else {
          res.status(200).json(results);
        }
      });
};

//Recupera todas las distribuidoras existentes.
exports.findAllDistributors = (req, res) => {
    var sql = `SELECT * FROM db_jugueteria_efrain.distributors;`;
    
    connection.query(sql, function (error, results, fields) {
        if (error) {
          console.error(error);
          res.status(500).json({error: 'Error: No se pudo obtener los resultados.'});
        } 
        else {
          res.status(200).json(results);
        }
      });
};
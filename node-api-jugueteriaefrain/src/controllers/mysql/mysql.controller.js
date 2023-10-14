const mysql = require('mysql');
let connection;

exports.connect = (req, res) => {

    if (connection==undefined){
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
                res.status(500).json({
                    status: 500, 
                    title: "Error 500",
                    message: 'Error: No se pudo realizar la conexión a la base de datos.',
                    value: null,
                    error: err
                });
            } 
            else {
                res.status(200).json({
                    status: 200, 
                    title: "Conexión exitosa",
                    message: 'El sistema está conectado a la base de datos del Sistema v2.',
                    value: null,
                    error: null
                });
            }
        });
    }
    else{
        res.status(400).json({
            status: 400, 
            title: "Error 400",
            message: 'Error: El sistema ya se encuentra conectado a la base de datos del Sistema v2.',
            value: null,
            error: null
        });

        return;
    }
}

exports.close = (req, res) => {
    if (connection===undefined){
        res.status(400).json({
            status: 400, 
            title: "Error 400",
            message: 'Error: El sistema ya se encuentra desconectado de la base de datos del Sistema v2.',
            value: null,
            error: null
        });
        return;
    }
    else{
        if(connection && connection.end) {
            connection.end(err => {
                if (err) {
                    console.error('Error: No se pudo realizar la desconexión de la base de datos: ', err);
                    res.status(500).json({
                        status: 500, 
                        title: "Error 500",
                        message: 'Error: No se pudo realizar la desconexión a la base de datos de Sistema v2.',
                        value: null,
                        error: err
                    });
                } else {
                    res.status(200).json({
                        status: 200, 
                        title: "Desconexión exitosa",
                        message: 'Realizada la desconexión a la base de datos de Sistema v2.',
                        value: null,
                        error: null
                    });
                }
            });
        } 
        else {
            res.status(400).json({
                status: 400, 
                title: "Error 400",
                message: 'Error: El sistema ya se encuentra desconectado de la base de datos de Sistema v2.',
                value: null,
                error: null
            });
        }
}
}

//Recupera todos los productos (junto a datos de la distribuidora y del precio del producto) de la base de datos.
exports.findAllProducts = (req, res) => {
    var sql = "SELECT json_object('p_id', p_id, 'p_codebar', p_codebar, 'p_title', p_title, 'p_brand', p_brand, 'p_description', p_description, 'p_sizeblister', p_sizeblister, 'p_sizeproduct', p_sizeproduct, 'p_category', p_category, 'p_subcategory', p_subcategory, 'p_stock', p_stock, 'p_iva', p_iva, 'p_pricepublic', p_pricepublic, 'p_linkimage', p_linkimage, 'p_datecreated', p_datecreated, 'p_dateupdated', p_dateupdated, 'p_minimumage', p_minimumage, 'p_internal_code', p_internal_code) as product, d_cuit, json_object('p_dateupdated', p_dateupdated, 'p_pricebase', p_pricebase) as price_product FROM db_jugueteria_efrain.products, db_jugueteria_efrain.distributors WHERE p_distributor=d_id;";
    
    if (connection===undefined){
        res.status(400).json({
            status: 400, 
            title: "Error 400",
            message: 'Error: No hay conexión establecida con la base de datos de Sistema v2.',
            error: null,
            value: null
        });
        return;
    }
    else{
        connection.query(sql, function (error, results, fields) {
            if (error) {
              console.error(error);
              res.status(500).json({
                status: 500, 
                title: "Error 500",
                message: 'Error: Ocurrió un error al recuperar los productos de la base de datos de Sistema v2.',
                error: error,
                value: null
                });
            } 
            else {
              res.status(200).json({
                status: 200, 
                title: "Operación exitosa",
                message: 'Éxito al recuperar los productos de la base de datos de Sistema v2.',
                error: null,
                value: results
                });
            }
          });
    }
};

//Recupera todas las distribuidoras existentes.
exports.findAllDistributors = (req, res) => {
    var sql = "SELECT * FROM db_jugueteria_efrain.distributors;";
    
    if (connection===undefined){
        res.status(400).json({
            status: 400, 
            title: "Error 400",
            message: 'Error: No hay conexión establecida con la base de datos de Sistema v2.',
            value: null,
            error: null
        });
        return;
    }
    else{
        connection.query(sql, function (error, results, fields) {
            if (error) {
              console.error(error);
              res.status(500).json({
                status: 500, 
                title: "Error 500",
                message: 'Error: Ocurrió un error al recuperar las distribuidoras de la base de datos de Sistema v2.',
                error: error,
                value: null
                });
            } 
            else {
              res.status(200).json({
                status: 200, 
                title: "Operación exitosa",
                message: 'Éxito al recuperar las distribuidoras de la base de datos de Sistema v2.',
                error: null,
                value: results
                });
            }
          });
    }
};
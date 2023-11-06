const db = require("../../models");
const Products = db.products;

//Crear y guardar un nuevo producto.
exports.create = (req, res) => {
    //Validacion de datos.
    if (!req.body) {
      res.status(400).json({
        status: 400, 
        title: "Error 400",
        message: 'Error::Product.create(): Error producido al recibir un formulario nulo.',
        error: null,
        value: null
        })
      return;
    }
  
    //Crea un producto.
    const producto = {
        p_barcode: req.body.p_barcode, 
        p_title: req.body.p_title,
        p_description: req.body.p_description, 
        p_brand: req.body.p_brand, 
        p_price_public: req.body.p_price_public, 
        p_stock: req.body.p_stock, 
        p_subcategory: req.body.p_subcategory, 
        p_images: req.body.p_images, 
        p_sizes: req.body.p_sizes, 
        p_date_updated: req.body.p_date_updated, 
        p_date_created: req.body.p_date_created, 
        p_minimum_age: req.body.p_minimum_age
    };
  
    //Guarda el producto en la base de datos.
    Products.create(producto)
      .then(data => {
        res.status(201).json({
          status: 201, 
          title: "Operación exitosa",
          message: 'El producto fue creado e insertado en la base de datos con éxito.',
          error: null,
          value: {p_id: data.p_id}
          });
      })
      .catch(err => {
        res.status(500).json({
          status: 500, 
          title: "Error 500",
          message: 'Error::Product.create(): Error al crear e insertar el producto en la base de datos.',
          error: err,
          value: null
          });
      });
};

//Realiza la busqueda de un producto con identificador id.
exports.findOne = (req, res) => {
    const id = req.params.id;

    Products.findByPk(id)
      .then(data => {
        if (data) {
          res.status(200).json({
            status: 200, 
            title: "Operación exitosa",
            message: 'El producto en cuestión fue recuperado de la base de datos con éxito.',
            error: null,
            value: data
            });
        } else {
          res.status(404).json({
            status: 404, 
            title: "Error 404",
            message: 'Error::Product.findOne(): No se pudo recuperar el producto de la base de datos.',
            error: null,
            value: null
            });
        }
      })
      .catch(err => {
        res.status(500).json({
          status: 500, 
          title: "Error 500",
          message: 'Error::Product.findOne(): Ocurrió un problema al recuperar el producto de la base de datos.',
          error: err,
          value: null
          });
      });
};

//Recupera todos los productos de la base de datos.
exports.findAll = (req, res) => {

  Products.findAll({ 
    where: {},
    order: [
      ['p_title', 'ASC'],
      ['p_brand', 'ASC']
    ]
  })
    .then(data => {
      res.status(200).json({
        status: 200, 
        title: "Operación exitosa",
        message: 'Se recuperaron todos los productos almacenados en la base de datos.',
        error: null,
        value: data
        });
    })
    .catch(err => {
      res.status(500).json({
        status: 500, 
        title: "Error 500",
        message: 'Error::Product.findAll(): Ocurrió un problema al recuperar los productos de la base de datos.',
        error: err,
        value: null
        });
    });
};

//Actualiza los datos de un producto con identificador id.
exports.update = (req, res) => {
    const id = req.params.id;

    Products.update(req.body, { where: { p_id: id } })
        .then(num => {
            if (num[0] === 1) {
                res.status(200).json({
                  status: 200, 
                  title: "Operación exitosa",
                  message: 'El producto '+ req.body.p_title.toUpperCase() + ' fue actualizado con éxito.',
                  error: null,
                  value: num
                  });
            } 
            else {
                res.status(501).json({
                  status: 501, 
                  title: "Error 501",
                  message: 'Error::Product.update(): No se pudo efectuar la actualización del producto. Compruebe los datos e intente nuevamente.',
                  error: null,
                  value: null
                  });
            }
        })
        .catch(err => {
            res.status(500).json({
              status: 500, 
              title: "Error 500",
              message: 'Error::Product.update(): Ocurrió un problema al actualizar el producto en la base de datos.',
              error: err,
              value: null
              });
        });
};

//Actualiza los datos de un producto con identificador id.
exports.updatePricePublic = (req, res) => {
  const id = req.params.id;
  const {p_price_public} = req.body;

  Products.update({p_price_public: p_price_public}, { where: { p_id: id } })
      .then(num => {
        if (num[0] === 1) {
          res.status(200).json({
            status: 200, 
            title: "Operación exitosa",
            message: 'El precio del producto fue actualizado con éxito.',
            error: null,
            value: num
            });
        } 
        else {
            res.status(501).json({
              status: 501, 
              title: "Error 501",
              message: 'Error::Product.updatePricePublic(): No se pudo efectuar la actualización del producto. Compruebe los datos e intente nuevamente.',
              error: null,
              value: null
              });
        }
      })
      .catch(err => {
          res.status(500).json({
            status: 500, 
            title: "Error 500",
            message: 'Error::Product.updatePricePublic(): Ocurrió un problema al actualizar el precio del producto en la base de datos.',
            error: err,
            value: null
          });
      });
};

//Elimina un producto con un determinado id.
exports.delete = (req, res) => {
    const id = req.params.id;

    Products.destroy({ where: { p_id: id } })
        .then(num => {
            console.log(num);
          if (num === 1) {
            res.status(200).json({
              status: 200, 
              title: "Operación exitosa",
              message: 'El producto fue eliminado de la base de datos con éxito.',
              error: null,
              value: num
              });
          } 
          else {
              res.status(501).json({
                status: 501, 
                title: "Error 501",
                message: 'Error::Product.delete(): No se pudo efectuar la eliminación del producto. Compruebe los datos e intente nuevamente.',
                error: null,
                value: null
                });
          }
        })
        .catch(err => {
            res.status(500).json({
              status: 500, 
              title: "Error 500",
              message: 'Error::Product.delete(): Ocurrió un problema al eliminar el producto de la base de datos.',
              error: err,
              value: null
              });
        });
};

//Elimina todos los productos de la base de datos.
exports.deleteAll = (req, res) => {
    Products.destroy({ where: {}, truncate: false})
        .then(nums => {
          res.status(200).json({
            status: 200, 
            title: "Operación exitosa",
            message: 'Se eliminó todos los productos existentes de la base de datos.',
            error: null,
            value: nums
            });
        })
        .catch(err => {
          res.status(500).json({
            status: 500, 
            title: "Error 500",
            message: 'Error::Product.deleteAll(): Ocurrió un problema al eliminar todos los productos en la base de datos.',
            error: err,
            value: null
          });
        });
};
const db = require("../../models");
const ProductsPrices = db.products_prices;

//Crear y guardar un nuevo precio del producto.
exports.create = (req, res) => {
    //Validacion de datos.
    if (!req.body) {
      res.status(400).json({
        status: 400, 
        title: "Error 400",
        message: 'Error::ProductPrice.create(): Error producido al recibir un formulario nulo.',
        error: null,
        value: null
        })
      return;
    }
  
    //Crea un precio del producto.
    const price_product = {
        pp_internal_code: req.body.pp_internal_code,
        pp_product: req.body.pp_product,
        pp_distributor: req.body.pp_distributor,
        pp_price_base: req.body.pp_price_base,
        pp_date_update: req.body.pp_date_update,
        pp_website: req.body.pp_website,
    };
  
    //Guarda el precio del producto en la base de datos.
    ProductsPrices.create(price_product)
    .then(data => {
      res.status(201).json({
        status: 201, 
        title: "Operación exitosa",
        message: 'El precio del producto fue creado e insertado en la base de datos con éxito.',
        error: null,
        value: data
        });
    })
    .catch(err => {
      res.status(500).json({
        status: 500, 
        title: "Error 500",
        message: 'Error::ProductPrice.create(): Error al crear e insertar el precio del producto en la base de datos.',
        error: err,
        value: null
        });
    });
};

//Realiza la busqueda de un precio del producto con identificador id.
exports.findOne = (req, res) => {
    const id = req.params.id;

    ProductsPrices.findByPk(id)
      .then(data => {
        if (data) {
          res.status(200).json({
            status: 200, 
            title: "Operación exitosa",
            message: 'El precio del producto fue recuperada de la base de datos con éxito.',
            error: null,
            value: data
            });
        } else {
          res.status(404).json({
            status: 404, 
            title: "Error 404",
            message: 'Error::ProductPrice.findOne(): No se pudo recuperar el precio del producto de la base de datos.',
            error: null,
            value: null
            });
        }
      })
      .catch(err => {
        res.status(500).json({
          status: 500, 
          title: "Error 500",
          message: 'Error::Product.findOne(): Ocurrió un problema al recuperar el precio del producto de la base de datos.',
          error: err,
          value: null
          });
      });
};

//Recupera todos los precios del producto en particular.
exports.findAll = (req, res) => {
    const id = parseInt(req.params.id)

    ProductsPrices.findAll({ 
      where: { pp_product: id},
      order: [
        ['pp_price_base', 'ASC']
      ]
    })
      .then(data => {
        res.status(200).json({
          status: 200, 
          title: "Operación exitosa",
          message: 'Se recuperaron todas los precios del producto almacenadas en la base de datos.',
          error: null,
          value: data
          });
      })
      .catch(err => {
        res.status(500).json({
          status: 500, 
          title: "Error 500",
          message: 'Error::ProductPrice.findAll(): Ocurrió un problema al recuperar los precios del producto de la base de datos.',
          error: err,
          value: null
          });
      });
};

//Actualiza los datos de un precio del producto con identificador id.
exports.update = (req, res) => {
    const id = req.params.id;

    ProductsPrices.update(req.body, { where: { pp_id: id } })
      .then(num => {
        if (num[0] === 1) {
            res.status(200).json({
              status: 200, 
              title: "Operación exitosa",
              message: 'El precio del producto fue actualizada con éxito.',
              error: null,
              value: num
              });
        } 
        else {
            res.status(501).json({
              status: 501, 
              title: "Error 501",
              message: 'Error::ProductPrice.update(): No se pudo efectuar la actualización de el precio del producto. Compruebe los datos e intente nuevamente.',
              error: null,
              value: null
              });
        }
    })
    .catch(err => {
        res.status(500).json({
          status: 500, 
          title: "Error 500",
          message: 'Error::ProductPrice.update(): Ocurrió un problema al actualizar el precio del producto en la base de datos.',
          error: err,
          value: null
          });
    });
};

//Elimina un precio del producto con un determinado id.
exports.delete = (req, res) => {
    const id = req.params.id;

    ProductsPrices.destroy({ where: { pp_id: id } })
    .then(num => {
      if (num === 1) {
        res.status(200).json({
          status: 200, 
          title: "Operación exitosa",
          message: 'El precio del producto fue eliminada de la base de datos con éxito.',
          error: null,
          value: num
          });
      } 
      else {
          res.status(501).json({
            status: 501, 
            title: "Error 501",
            message: 'Error::ProductPrice.delete(): No se pudo efectuar la eliminación de el precio del producto. Compruebe los datos e intente nuevamente.',
            error: null,
            value: null
            });
      }
    })
    .catch(err => {
        res.status(500).json({
          status: 500, 
          title: "Error 500",
          message: 'Error::ProductPrice.delete(): Ocurrió un problema al eliminar el precio del producto de la base de datos.',
          error: err,
          value: null
          });
    });
};

//Elimina todos los precio del productos de la base de datos.
exports.deleteAll = (req, res) => {
  const id = req.params.id;

  ProductsPrices.destroy({ where: {pp_product: id}, truncate: false})
  .then(nums => {
    res.status(200).json({
      status: 200, 
      title: "Operación exitosa",
      message: 'Se eliminó, de la base de datos, todas los precios del producto existentes .',
      error: null,
      value: nums
      });          
  })
  .catch(err => {
    res.status(500).json({
      status: 500, 
      title: "Error 500",
      message: 'Error::ProductPrice.deleteAll(): Ocurrió un problema al eliminar los precios del producto en la base de datos.',
      error: err,
      value: null
    });
  });
};
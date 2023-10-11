const db = require("../models/");
const ProductsPrices = db.products_prices;
const Op = db.Sequelize.Op;

//Crear y guardar un nuevo precio del producto.
exports.create = (req, res) => {
    //Validacion de datos.
    if (!req.body) {
      res.status(400).send({
        message: "Error: El contenido del formulario no puede estar vacío."
      });
      return;
    }
  
    //Crea un precio del producto.
    const price_product = {
        //pp_product, pp_distributor, pp_price_base, pp_date_update
        pp_id: req.body.pp_id, 
        pp_product: req.body.pp_product, 
        pp_distributor: req.body.pp_distributor, 
        pp_price_base: req.body.pp_price_base, 
        pp_date_update: req.body.pp_date_update
    };
  
    //Guarda el precio del producto en la base de datos.
    ProductsPrices.create(price_product)
      .then(data => {
        res.status(201).send(data);
      })
      .catch(err => {
        res.status(500).send({
          message:
            err.message || "Error: Se produjo un error al crear el precio del producto."
        });
      });
};

//Realiza la busqueda de un precio del producto con identificador id.
exports.findOne = (req, res) => {
    const id = req.params.id;

    ProductsPrices.findByPk(id)
      .then(data => {
        if (data) {
          res.status(200).send(data);
        } else {
          res.status(404).send({
            message: `Error: No se pudo hallar precio del producto con id=${id}.`
          });
        }
      })
      .catch(err => {
        res.status(500).send({
          message: "Error: Ocurrió un problema al intentar recuperar el precio del producto con id=" + id
        });
      });
};

//Recupera todos los precios del producto en particular.
exports.findAll = (req, res) => {
    const id = parseInt(request.params.id)

    ProductsPrices.findAll({ where: { pp_product: id} })
        .then(data => {
        res.send(data);
        })
        .catch(err => {
        res.status(500).send({
            message:
            err.message || "Error: Ocurrió un error al recuperar los precio del productos."
        });
        });
};

//Actualiza los datos de un precio del producto con identificador id.
exports.update = (req, res) => {
    const id = req.params.id;

    ProductsPrices.update(req.body, { where: { pp_id: id } })
        .then(num => {
            if (num == 1) {
                res.status(200).send({
                    message: "Precio del producto actualizado con éxito."
                });
            } 
            else {
                res.status(501).send({
                    message: "Error: No se puede actualizar el precio del producto con id=" + id + ". Comprueba los datos e intente nuevamente."
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Error: Ocurrió un error al actualizar el precio del producto con id=" + id
            });
        });
};

//Elimina un precio del producto con un determinado id.
exports.delete = (req, res) => {
    const id = req.params.id;

    ProductsPrices.destroy({ where: { db_id: id } })
        .then(num => {
            if (num == 1) {
                res.status(200).send({
                    message: "Precio del producto eliminado con éxito!"
                });
            } 
            else {
                res.status(501).send({
                    message: "Error: No se puede actualizar el precio del producto con id="+id+". Comprueba los datos e intente nuevamente."
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Error: Ocurrió un error al eliminar el precio del producto con id=" + id
            });
        });
};

//Elimina todos los precio del productos de la base de datos.
exports.deleteAll = (req, res) => {
    ProductsPrices.destroy({ where: {}, truncate: false})
        .then(nums => {
          res.status(200).send({ message: `${nums} precio del productos eliminados con éxito!` });
        })
        .catch(err => {
          res.status(500).send({
            message:
              err.message || "Error: Ha ocurrido un error al eliminar los precio del productos."
          });
        });
};
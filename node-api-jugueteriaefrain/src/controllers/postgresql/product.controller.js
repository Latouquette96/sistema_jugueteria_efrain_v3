const db = require("../../models");
const Products = db.products;
const Op = db.Sequelize.Op;

//Crear y guardar un nuevo producto.
exports.create = (req, res) => {
    //Validacion de datos.
    if (!req.body) {
      res.status(400).send({
        message: "Error: El contenido del formulario no puede estar vacío."
      });
      return;
    }
  
    //Crea un producto.
    const producto = {
        p_barcode: req.body.p_barcode, 
        p_internal_code: req.body.p_internal_code, 
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
        res.send(201).send(data.p_id);
      })
      .catch(err => {
        res.status(500).send({
          message:
            err.message || "Error: Se produjo un error al crear el producto."
        });
      });
};

//Realiza la busqueda de un producto con identificador id.
exports.findOne = (req, res) => {
    const id = req.params.id;

    Products.findByPk(id)
      .then(data => {
        if (data) {
          res.send(200).send(data);
        } else {
          res.status(404).send({
            message: `Error: No se pudo hallar producto con id=${id}.`
          });
        }
      })
      .catch(err => {
        res.status(500).send({
          message: "Error: Ocurrió un problema al intentar recuperar el producto con id=" + id
        });
      });
};

//Recupera todos los productos de la base de datos.
exports.findAll = (req, res) => {

  Products.findAll({ where: {} })
    .then(data => {
      res.status(200).send(data);
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || "Error: Ocurrió un error al recuperar los productos."
      });
    });
};

//Actualiza los datos de un producto con identificador id.
exports.update = (req, res) => {
    const id = req.params.id;

    Products.update(req.body, { where: { p_id: id } })
        .then(num => {
            if (num == 1) {
                res.send(200).send({
                    message: "Producto actualizado con éxito."
                });
            } 
            else {
                res.send(501).send({
                    message: "Error: No se puede actualizar el producto con id=" + id + ". Comprueba los datos e intente nuevamente."
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Error: Ocurrió un error al actualizar el producto con id=" + id
            });
        });
};

//Actualiza los datos de un producto con identificador id.
exports.updatePricePublic = (req, res) => {
  const id = req.params.id;
  const {p_price_public} = request.body;

  Products.update({p_price_public: p_price_public}, { where: { p_id: id } })
      .then(num => {
          if (num == 1) {
              res.send(200).send({
                  message: "Producto actualizado con éxito."
              });
          } 
          else {
              res.send(501).send({
                  message: "Error: No se puede actualizar el producto con id=" + id + ". Comprueba los datos e intente nuevamente."
              });
          }
      })
      .catch(err => {
          res.status(500).send({
              message: "Error: Ocurrió un error al actualizar el producto con id=" + id
          });
      });
};

//Elimina un producto con un determinado id.
exports.delete = (req, res) => {
    const id = req.params.id;

    Products.destroy({ where: { p_id: id } })
        .then(num => {
            if (num == 1) {
                res.send(200).send({
                    message: "Producto eliminado con éxito!"
                });
            } 
            else {
                res.send(501).send({
                    message: "Error: No se puede actualizar el producto con id="+id+". Comprueba los datos e intente nuevamente."
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Error: Ocurrió un error al eliminar el producto con id=" + id
            });
        });
};

//Elimina todos los productos de la base de datos.
exports.deleteAll = (req, res) => {
    Products.destroy({ where: {}, truncate: false})
        .then(nums => {
          res.send(501).send({ message: `${nums} productos eliminados con éxito!` });
        })
        .catch(err => {
          res.status(500).send({
            message:
              err.message || "Error: Ha ocurrido un error al eliminar los productos."
          });
        });
};
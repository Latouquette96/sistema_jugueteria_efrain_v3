const db = require("../models/");
const Billings = db.billings;
const Op = db.Sequelize.Op;

//Crear y guardar una nueva factura.
exports.create = (req, res) => {
    //Validacion de datos.
    if (!req.body.title) {
      res.status(400).send({
        message: "Error: El contenido del formulario no puede estar vacío."
      });
      return;
    }
  
    //Crea una factura.
    const factura = {
        //db_id, db_distributor, db_datetime, db_total, db_url_file
        db_id: req.body.db_id, 
        db_distributor: req.body.db_distributor, 
        db_datetime: req.body.db_datetime, 
        db_total: req.body.db_total, 
        db_url_file: req.body.db_url_file
    };
  
    //Guarda el factura en la base de datos.
    Billings.create(factura)
      .then(data => {
        res.send(data);
      })
      .catch(err => {
        res.status(500).send({
          message:
            err.message || "Error: Se produjo una error al crear la factura."
        });
      });
};

//Realiza la busqueda de una factura con identificador id.
exports.findOne = (req, res) => {
    const id = req.params.id;

    Billings.findByPk(id)
      .then(data => {
        if (data) {
          res.send(data);
        } else {
          res.status(404).send({
            message: `Error: No se pudo hallar factura con id=${id}.`
          });
        }
      })
      .catch(err => {
        res.status(500).send({
          message: "Error: Ocurrió una problema al intentar recuperar la factura con id=" + id
        });
      });
};

//Recupera todas las facturas de una distribuidora en particular.
exports.findAll = (req, res) => {
    const id = parseInt(request.params.id)

    Billings.findAll({ where: { db_distributor: id} })
        .then(data => {
        res.send(data);
        })
        .catch(err => {
        res.status(500).send({
            message:
            err.message || "Error: Ocurrió una error al recuperar las facturas."
        });
        });
};

//Actualiza los datos de una factura con identificador id.
exports.update = (req, res) => {
    const id = req.params.id;

    Billings.update(req.body, { where: { db_id: id } })
        .then(num => {
            if (num == 1) {
                res.send({
                    message: "Factura actualizada con éxito."
                });
            } 
            else {
                res.send({
                    message: "Error: No se puede actualizar la factura con id=" + id + ". Comprueba los datos e intente nuevamente."
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Error: Ocurrió una error al actualizar la factura con id=" + id
            });
        });
};

//Elimina una factura con una determinado id.
exports.delete = (req, res) => {
    const id = req.params.id;

    Billings.destroy({ where: { db_id: id } })
        .then(num => {
            if (num == 1) {
                res.send({
                    message: "Factura eliminada con éxito!"
                });
            } 
            else {
                res.send({
                    message: "Error: No se puede actualizar la factura con id="+id+". Comprueba los datos e intente nuevamente."
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Error: Ocurrió una error al eliminar la factura con id=" + id
            });
        });
};

//Elimina todos los facturas de la base de datos.
exports.deleteAll = (req, res) => {
    Billings.destroy({ where: {}, truncate: false})
        .then(nums => {
          res.send({ message: `${nums} facturas eliminadas con éxito!` });
        })
        .catch(err => {
          res.status(500).send({
            message:
              err.message || "Error: Ha ocurrido una error al eliminar las facturas."
          });
        });
};
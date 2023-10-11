const db = require("../models/");
const Distributors = db.distributors;
const Op = db.Sequelize.Op;

//Crear y guardar una nueva distribuidora.
exports.create = (req, res) => {
  console.log(req.body)
    //Validacion de datos.
    if (!req.body) {
      res.status(400).send({
        message: "Error: El contenido del formulario no puede estar vacío."
      });
      return;
    }
  
    //Crea una distribuidora.
    const distribuidora = {
        d_id: req.body.d_id, 
        d_cuit: req.body.d_cuit, 
        d_name: req.body.d_name, 
        d_address: req.body.d_address, 
        d_email: req.body.d_email, 
        d_cel: req.body.d_cel, 
        d_website: req.body.d_website, 
        d_iva: req.body.d_iva
    };
  
    //Guarda el distribuidora en la base de datos.
    Distributors.create(distribuidora)
      .then(data => {
        res.status(201).send(data);
      })
      .catch(err => {
        res.status(500).send({
          message:
            err.message || "Error: Se produjo una error al crear la distribuidora."
        });
      });
};

//Realiza la busqueda de una distribuidora con identificador id.
exports.findOne = (req, res) => {
    const id = req.params.id;

    Distributors.findByPk(id)
      .then(data => {
        if (data) {
          res.status(200).send(data);
        } else {
          res.status(404).send({
            message: `Error: No se pudo hallar distribuidora con id=${id}.`
          });
        }
      })
      .catch(err => {
        res.status(500).send({
          message: "Error: Ocurrió una problema al intentar recuperar la distribuidora con id=" + id
        });
      });
};

//Recupera todos los distribuidoras de la base de datos.
exports.findAll = (req, res) => {

  Distributors.findAll({ where: {} })
    .then(data => {
      res.status(200).send(data);
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || "Error: Ocurrió una error al recuperar los distribuidoras."
      });
    });
};


//Actualiza los datos de una distribuidora con identificador id.
exports.update = (req, res) => {
    const id = req.params.id;

    Distributors.update(req.body, { where: { d_id: id } })
        .then(num => {
            if (num == 1) {
                res.status(200).send({
                    message: "Distribuidora actualizada con éxito."
                });
            } 
            else {
                res.status(501).send({
                    message: "Error: No se puede actualizar la distribuidora con id=" + id + ". Comprueba los datos e intente nuevamente."
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Error: Ocurrió una error al actualizar la distribuidora con id=" + id
            });
        });
};

//Elimina una distribuidora con una determinado id.
exports.delete = (req, res) => {
    const id = req.params.id;

    Distributors.destroy({ where: { d_id: id } })
        .then(num => {
            if (num == 1) {
                res.status(200).send({
                    message: "Distribuidora eliminada con éxito!"
                });
            } 
            else {
                res.status(501).send({
                    message: "Error: No se puede actualizar la distribuidora con id="+id+". Comprueba los datos e intente nuevamente."
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Error: Ocurrió una error al eliminar la distribuidora con id=" + id
            });
        });
};

//Elimina todos los distribuidoras de la base de datos.
exports.deleteAll = (req, res) => {
    Distributors.destroy({ where: {}, truncate: false})
        .then(nums => {
          res.status(200).send({ message: `${nums} distribuidoras eliminadas con éxito!` });
        })
        .catch(err => {
          res.status(500).send({
            message:
              err.message || "Error: Ha ocurrido una error al eliminar las distribuidoras."
          });
        });
};
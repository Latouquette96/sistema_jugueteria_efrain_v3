const db = require("../../models");
const Distributor = db.distributors;

const distributor_controller = {}

//Crear y guardar una nueva distribuidora.
distributor_controller.create = async (req, res) => {
    //Validacion de datos.
    if (!req.body) {
      res.status(400).json({
        status: 400, 
        title: "Error 400",
        message: 'Error::Distributor.create(): Error producido al recibir un formulario nulo.',
        error: null,
        value: null
        })
      return;
    }
  
    //Crea una distribuidora.
    const distribuidora = {
        d_cuit: req.body.d_cuit, 
        d_name: req.body.d_name, 
        d_address: req.body.d_address, 
        d_email: req.body.d_email, 
        d_cel: req.body.d_cel, 
        d_website: req.body.d_website, 
        d_iva: req.body.d_iva
    };
  
    //Guarda el distribuidora en la base de datos.
    await Distributor.create(distribuidora)
      .then(data => {
        res.status(201).json({
          status: 201, 
          title: "Operación exitosa",
          message: 'La distribuidora fue creada e insertada en la base de datos con éxito.',
          error: null,
          value: data
          })
      })
      .catch(err => {
        res.status(500).json({
          status: 500, 
          title: "Error 500",
          message: 'Error::Distributor.create(): Error al crear e insertar la distribuidora en la base de datos.',
          error: err,
          value: null
          });
      });
};

//Realiza la busqueda de una distribuidora con identificador id.
distributor_controller.findOne = async (req, res) => {
    const id = req.params.id;

    await Distributor.findByPk(id)
    .then(data => {
      if (data) {
        res.status(200).json({
          status: 200, 
          title: "Operación exitosa",
          message: 'La distribuidora en cuestión fue recuperada de la base de datos con éxito.',
          error: null,
          value: data
          });
      } else {
        res.status(404).json({
          status: 404, 
          title: "Error 404",
          message: 'Error::Distributor.findOne(): No se pudo recuperar la distribuidora de la base de datos.',
          error: null,
          value: null
          });
      }
    })
    .catch(err => {
      res.status(500).json({
        status: 500, 
        title: "Error 500",
        message: 'Error::Distributor.findOne(): Ocurrió un problema al recuperar la distribuidora de la base de datos.',
        error: err,
        value: null
        });
    });
};

//Recupera todos los distribuidoras de la base de datos.
distributor_controller.findAll = async (req, res) => {

  await Distributor.findAll({ 
    where: {} ,
    order: [
      ['d_name', 'ASC'],
      ['d_cuit', 'ASC']
    ]
  })
    .then(data => {
      res.status(200).json({
        status: 200, 
        title: "Operación exitosa",
        message: 'Se recuperaron todas las distribuidoras almacenadas en la base de datos.',
        error: null,
        value: data
        });
    })
    .catch(err => {
      res.status(500).json({
        status: 500, 
        title: "Error 500",
        message: 'Error::Distributor.findAll(): Ocurrió un problema al recuperar las distribuidoras de la base de datos.',
        error: err,
        value: null
        });
    });
};

//Actualiza los datos de una distribuidora con identificador id.
distributor_controller.update = async (req, res) => {
    const id = req.params.id;

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

    await Distributor.update(distribuidora, { where: { d_id: id } })
        .then(num => {
            if (num[0] === 1) {
              res.status(200).json({
                status: 200, 
                title: "Operación exitosa",
                message: 'La distribuidora fue actualizada en la base de datos con éxito.',
                error: null,
                value: num
                });
            } 
            else {
                res.status(501).json({
                  status: 501, 
                  title: "Error 501",
                  message: 'Error::Distributor.update(): No se pudo efectuar la actualización de la distribuidora. Compruebe los datos e intente nuevamente.',
                  error: null,
                  value: null
                });
            }
        })
        .catch(err => {
          res.status(500).json({
            status: 500, 
            title: "Error 500",
            message: 'Error::Distributor.update(): Error al actualizar la información de la distribuidora en la base de datos.',
            error: err,
            value: null
            });
        });
};

//Elimina una distribuidora con una determinado id.
distributor_controller.delete = async (req, res) => {
    const id = req.params.id;

    await Distributor.destroy({ where: { d_id: id } })
        .then(num => {
            if (num === 1) {
                res.status(200).json({
                  status: 200, 
                  title: "Operación exitosa",
                  message: 'La distribuidora fue eliminada de la base de datos con éxito.',
                  error: null,
                  value: num
                  });
            } 
            else {
                res.status(501).json({
                  status: 501, 
                  title: "Error 501",
                  message: 'Error::Distributor.delete(): No se pudo efectuar la eliminación de la distribuidora. Compruebe los datos e intente nuevamente.',
                  error: null,
                  value: null
                });
            }
        })
        .catch(err => {
          res.status(500).json({
            status: 500, 
            title: "Error 500",
            message: 'Error::Distributor.delete(): Error al eliminar la distribuidora en la base de datos.',
            error: err,
            value: null
            });
        });
};

//Elimina todos los distribuidoras de la base de datos.
distributor_controller.deleteAll = async (req, res) => {
    await Distributor.destroy({ where: {}, truncate: false})
        .then(nums => {
          res.status(200).json({
            status: 200, 
            title: "Operación exitosa",
            message: 'Se eliminó todas las distribuidoras existentes de la base de datos (' + nums +' distribuidoras).',
            error: null,
            value: nums
          }); 
        })
        .catch(err => {
          res.status(500).json({
            status: 500, 
            title: "Error 500",
            message: 'Error::Distributor.deleteAll(): Error al eliminar todas las distribuidoras de la base de datos.',
            error: err,
            value: null
            });
        });
};

module.exports = distributor_controller;
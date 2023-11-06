const db = require("../../models");
const Billings = db.billings;

//Crear y guardar una nueva factura.
exports.create = (req, res) => {
    //Validacion de datos.
    if (!req.body) {
      res.status(400).json({
        status: 400, 
        title: "Error 400",
        message: 'Error::Billing.create(): Error producido al recibir un formulario nulo.',
        error: null,
        value: null
        })
      return;
    }
  
    //Crea una factura.
    const factura = {
        db_distributor: req.body.db_distributor, 
        db_datetime: req.body.db_datetime, 
        db_total: req.body.db_total, 
        db_url_file: req.body.db_url_file
    };
  
    //Guarda el factura en la base de datos.
    Billings.create(factura)
    .then(data => {
      res.status(201).json({
        status: 201, 
        title: "Operación exitosa",
        message: 'La factura fue creada e insertada en la base de datos con éxito.',
        error: null,
        value: {p_id: data.p_id}
        });
    })
    .catch(err => {
      res.status(500).json({
        status: 500, 
        title: "Error 500",
        message: 'Error::Billing.create(): Error al crear e insertar la factura en la base de datos.',
        error: err,
        value: null
        });
    });
};

//Realiza la busqueda de una factura con identificador id.
exports.findOne = (req, res) => {
    const id = req.params.id;

    Billings.findByPk(id)
    .then(data => {
      if (data) {
        res.status(200).json({
          status: 200, 
          title: "Operación exitosa",
          message: 'La factura fue recuperada de la base de datos con éxito.',
          error: null,
          value: data
          });
      } else {
        res.status(404).json({
          status: 404, 
          title: "Error 404",
          message: 'Error::Billing.findOne(): No se pudo recuperar la factura de la base de datos.',
          error: null,
          value: null
          });
      }
    })
    .catch(err => {
      res.status(500).json({
        status: 500, 
        title: "Error 500",
        message: 'Error::CodeGenerated.findOne(): Ocurrió un problema al recuperar la factura de la base de datos.',
        error: err,
        value: null
        });
    });
};

//Recupera todas las facturas de una distribuidora en particular.
exports.findAll = (req, res) => {
    const id = parseInt(req.params.id)

    Billings.findAll({ where: { db_distributor: id} })
    .then(data => {
      res.status(200).json({
        status: 200, 
        title: "Operación exitosa",
        message: 'Se recuperaron todas las facturas almacenadas en la base de datos.',
        error: null,
        value: data
        });
    })
    .catch(err => {
      res.status(500).json({
        status: 500, 
        title: "Error 500",
        message: 'Error::Billing.findAll(): Ocurrió un problema al recuperar las facturas de la base de datos.',
        error: err,
        value: null
        });
    });
};

//Actualiza los datos de una factura con identificador id.
exports.update = (req, res) => {
    const id = req.params.id;

    //Crea una factura.
    const factura = {
        db_distributor: req.body.db_distributor,
        db_datetime: req.body.db_datetime,
        db_total: req.body.db_total,
        db_url_file: req.body.db_url_file
    };

    Billings.update(factura, { where: { db_id: id } })
      .then(num => {
        if (num[0] === 1) {
            res.status(200).json({
              status: 200, 
              title: "Operación exitosa",
              message: 'La factura fue actualizada con éxito.',
              error: null,
              value: num
              });
        } 
        else {
            res.status(501).json({
              status: 501, 
              title: "Error 501",
              message: 'Error::Billing.update(): No se pudo efectuar la actualización de la factura. Compruebe los datos e intente nuevamente.',
              error: null,
              value: null
              });
        }
    })
    .catch(err => {
        res.status(500).json({
          status: 500, 
          title: "Error 500",
          message: 'Error::Billing.update(): Ocurrió un problema al actualizar la factura en la base de datos.',
          error: err,
          value: null
          });
    });
};

//Elimina una factura con una determinado id.
exports.delete = (req, res) => {
    const id = req.params.id;

    Billings.destroy({ where: { db_id: id } })
      .then(num => {
        if (num === 1) {
          res.status(200).json({
            status: 200, 
            title: "Operación exitosa",
            message: 'La factura fue eliminada de la base de datos con éxito.',
            error: null,
            value: num
            });
        } 
        else {
            res.status(501).json({
              status: 501, 
              title: "Error 501",
              message: 'Error::Billing.delete(): No se pudo efectuar la eliminación de la factura. Compruebe los datos e intente nuevamente.',
              error: null,
              value: null
              });
        }
      })
      .catch(err => {
          res.status(500).json({
            status: 500, 
            title: "Error 500",
            message: 'Error::Billing.delete(): Ocurrió un problema al eliminar la factura de la base de datos.',
            error: err,
            value: null
            });
      });
};

//Elimina todos los facturas para una determinada distribuidora.
exports.deleteAll = (req, res) => {
    const id = req.params.id;

    Billings.destroy({ where: {db_distributor: id}, truncate: false})
    .then(nums => {
      res.status(200).json({
        status: 200, 
        title: "Operación exitosa",
        message: 'Se eliminó, de la base de datos, todas las facturas existentes de la distribuidora.',
        error: null,
        value: nums
        });          
    })
    .catch(err => {
      res.status(500).json({
        status: 500, 
        title: "Error 500",
        message: 'Error::Billing.deleteAll(): Ocurrió un problema al eliminar las facturas de la distribuidora en la base de datos.',
        error: err,
        value: null
      });
    });
};
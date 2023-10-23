const db = require("../../models");
const Products = db.products;
const Op = db.Sequelize.Op;


//Devuelve el total estimado entre todos los productos.
exports.getEstimatedTotal = (req, res) => {

  Products.findAll({ where: {p_stock: {
    [Op.gt]: 0
  }}}
  ).then(data => {
      //Variables para almacenar la cantidad de productos en total y el monto total.
      let suma = 0;
      let stock = 0;

      for (let reg of data) {
        suma += reg.p_stock * reg.p_price_public;
        stock += reg.p_stock;
      }

      res.status(200).json({
          status: 200, 
          title: "Operación exitosa",
          message: 'Se recuperaron todos los productos almacenados en la base de datos.',
          error: null,
          value: {
            stock: stock,
            total: suma
          }
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
const Pool = require('pg').Pool
const pool = new Pool({
  user: 'latouquette96',
  host: 'localhost',
  database: 'db_jugueteria_efrain',
  password: '39925523',
  port: 5432,
})

///Devuelve todas las marcas que han sido cargadas en la base de datos.
const getLoadedBrands = (request, response) => {
  pool.query('SELECT distinct(p_brand) FROM public.products ORDER BY p_brand ASC', (error, results) => {
    if (error) {
      response.status(404).json({
        status: 404, 
        title: "Error 404",
        message: 'Error: No se pudo obtener el listado de las marcas de los productos registrados.',
        error: null,
        value: null
        });
      return;
    }
    response.status(200).json({
      status: 200, 
      title: "Operación exitosa",
      message: 'Las marcas de los productos fueron recuperadas con éxito.',
      error: null,
      value: results.rows
      });
    return;
  })
}

module.exports = {
    getLoadedBrands
}
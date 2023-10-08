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
      throw error
    }
    response.status(200).json(results.rows)
  })
}

module.exports = {
    getLoadedBrands
}
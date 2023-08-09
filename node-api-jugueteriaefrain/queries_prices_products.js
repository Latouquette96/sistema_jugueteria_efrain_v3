const Pool = require('pg').Pool
const pool = new Pool({
  user: 'latouquette96',
  host: 'localhost',
  database: 'db_jugueteria_efrain',
  password: '39925523',
  port: 5432,
})

///Devuelve todos los precios de un producto.
const getProductPriceByID = (request, response) => {
  const id = parseInt(request.params.id)

  pool.query('SELECT products_prices.*, distributors.d_name ' +
  '             FROM products_prices, distributors ' +
  '             WHERE products_prices.pp_distributor=d_id and products_prices.pp_product=$1 ORDER BY distributors.d_name;', [id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

///Crea un precio para un producto en particular.
const createProductPrice = (request, response) => {
  const pp_product = request.body.pp_product;
  const pp_distributor = request.body.pp_distributor;
  const pp_price_base  = request.body.pp_price_base;
  const pp_date_update = request.body.pp_date_update;

  pool.query('INSERT INTO public.products_prices(pp_product, pp_distributor, pp_price_base, pp_date_update) '
            + '   VALUES ($1, $2, $3, $4)', [pp_product, pp_distributor, pp_price_base, pp_date_update], (error, results) => {
    if (error) {
      throw error
    }
    response.status(201).send(`Product price added with ID: ${results.insertId}`)
  })
}

///Actualiza un precio para un producto en particular.
const updateProductPrice = (request, response) => {
    const id = parseInt(request.params.id)
    const pp_product = request.body.pp_product;
    const pp_distributor = request.body.pp_distributor;
    const pp_price_base  = request.body.pp_price_base;
    const pp_date_update = request.body.pp_date_update;
  
    pool.query(
      'UPDATE public.products_prices ' + 
        '   SET pp_product=$1, pp_distributor=$2, pp_price_base=$3, pp_date_update=$4 ' +
        '   WHERE pp_id=$5',
      [pp_product, pp_distributor, pp_price_base, pp_date_update, id],
      (error, results) => {
        if (error) {
          throw error
        }
        response.status(200).send(`Product price modified with ID: ${id}`)
      }
    )
  }

///Elimina el precio de un producto en particular.
const deleteProductPrice = (request, response) => {
    const pp_id = parseInt(request.params.id)
  
    pool.query('DELETE FROM public.products_prices WHERE pp_id=$1', [pp_id], (error, results) => {
      if (error) {
        throw error
      }
      response.status(200).send(`Product price deleted with ID: ${pp_id}`)
    })
  }

module.exports = {
    getProductPriceByID,
    createProductPrice,
    updateProductPrice,
    deleteProductPrice
}
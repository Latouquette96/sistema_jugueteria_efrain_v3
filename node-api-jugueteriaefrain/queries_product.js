const Pool = require('pg').Pool
const pool = new Pool({
  user: 'latouquette96',
  host: 'localhost',
  database: 'db_jugueteria_efrain',
  password: '39925523',
  port: 5432,
})

const getProducts = (request, response) => {
  pool.query('SELECT * FROM products ORDER BY p_title ASC, p_brand ASC', (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

const getProductById = (request, response) => {
  const p_id = parseInt(request.params.id)

  pool.query('SELECT * FROM products WHERE p_id = $1', [p_id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

const createProduct = (request, response) => {
  const {p_barcode, p_internal_code, p_title, p_description, p_brand, p_price_public, p_stock, p_subcategory, p_images, p_sizes, p_date_updated, p_date_created, p_minimum_age} = request.body

  pool.query('INSERT INTO public.products(p_barcode, p_internal_code, p_title, p_description, p_brand, p_price_public, p_stock, p_subcategory, p_images, p_sizes, p_date_updated, p_date_created, p_minimum_age) '+
    '   VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)', 
      [p_barcode, p_internal_code, p_title, p_description, p_brand, p_price_public, p_stock, p_subcategory, p_images, p_sizes, p_date_updated, p_date_created, p_minimum_age], 
      (error, results) => {
        if (error) {
          throw error
        }
        response.status(201).send(`Product added with ID: ${results.insertId}`)
      }
    )
}

const updateProduct = (request, response) => {
  const p_id = parseInt(request.params.id)
  const { p_barcode, p_internal_code, p_title, p_description, p_brand, p_price_public, p_stock, p_subcategory, p_images, p_sizes, p_date_updated, p_date_created, p_minimum_age} = request.body

  pool.query(
    'UPDATE public.products ' +
    'SET p_barcode=$1, p_internal_code=$2, p_title=$3, p_description=$4, '+
        'p_brand=$5, p_price_public=$6, p_stock=$7, p_subcategory=$8, p_images=$9, p_sizes=$10, ' +
        'p_date_updated=$11, p_date_created=$12, p_minimum_age=$13 ' +
    'WHERE p_id=$14',
    [p_barcode, p_internal_code, p_title, p_description, p_brand, p_price_public, p_stock, p_subcategory, p_images, p_sizes, p_date_updated, p_date_created, p_minimum_age, p_id],
    (error, results) => {
      if (error) {
        throw error
      }
      response.status(200).send(`Product modified with ID: ${p_id}`)
    }
  )
}

const deleteProduct = (request, response) => {
  const p_id = parseInt(request.params.id)

  pool.query('DELETE FROM public.products ' +
	          '   WHERE p_id=$1', 
            [p_id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).send(`Product deleted with ID: ${p_id}`)
  })
}

module.exports = {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
}